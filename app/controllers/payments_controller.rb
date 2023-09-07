class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[ show edit update destroy ]

  # GET /payments or /payments.json
  def index
    if current_user.role == "financieros" || current_user.role == "servicios"
      @payments = Payment.all
    elsif current_user.role == "subdireccion"
      @payments = Payment.joins(:documento).where(documentos: { status: true }).where(verificarsub: false)
    elsif current_user.role == "direccion"
      @payments = Payment.joins(:documento).where(documentos: { status: true }).where(verificar: false, verificarsub: true)
      #@documentos = Documento.where(status: true)
    elsif current_user.role == "ingles"
      @payments = Payment.left_outer_joins(:certificate).where(status: "PAGADO", certificates: { id: nil })
                       .where(verificar: true, verificarsub: true)
                       .joins(:documento)
                       .where(documentos: { status: true })
    else
      @payments = []
    end
  end
  

  # GET /payments/1 or /payments/1.json
  def show
    @payment = Payment.includes(documento: :user).find(params[:id])
    @documento = @payment.documento
    @user_updated_payment = nil
    @payment = Payment.find(params[:id])

    if @documento.user_update_id.present?
      user = User.find(@documento.user_update_id)
      @user_name = "#{user.nombre} #{user.apellido_uno} #{user.apellido_dos}"
    else
      @user_name = "Documento no validado"
    end
  
    if @payment.user_update_id.present?
      userpayment = User.find(@payment.user_update_id)
      @user_namepayment = "#{userpayment.nombre} #{userpayment.apellido_uno} #{userpayment.apellido_dos}"
    else
      @user_namepayment = "Documento no validado"
    end
    @documento_date = @documento.updated_at.in_time_zone("Mexico City").strftime("%Y-%m-%d %H:%M:%S")
    @payment_date = @payment.updated_at.in_time_zone("Mexico City").strftime("%Y-%m-%d %H:%M:%S")

    if @payment.present? && @payment.audits.size >= 2
      user_id = @payment.audits.order(created_at: :desc).second.user_id
      @user_updated_payment = User.find(user_id)
      @updated_at_payment = @payment.audits.order(created_at: :desc).second.created_at
    end
    

    @payment = Payment.find(params[:id])
  @user_verificarsub = User.find_by(id: @payment.audits.where(audited_changes: { verificarsub: true }).last&.user_id)


  end


  def verified_documents
    @payments = Payment.where(verificar: true)

  end
  

  def verified_subdireccion
    @payments = Payment.where(verificarsub: true)
  end
  
 
  def subdireccion_invalidos
    @payments = Payment.where.not({ commentp: nil })
  end

  def direccion_invalidos
    @payments = Payment.where.not({ commentp: nil })
  end
  
  # GET /payments/new
  def new
    @payment = Payment.new
    @documento = Documento.find(params[:documento_id])
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
def create
  @payment = Payment.new(payment_params)
  @payment.documento_id = params[:payment][:documento_id]
  @payment.user = current_user
  @payment.nombre = params[:payment][:referencia] # Asignar el valor de referencia al nombre
  @payment.verificar = 0
  @payment.verificarsub = 0
  logger.debug("Documento ID: #{params[:payment][:documento_id]}")
  UserMailer.payment_created_email(current_user, @payment).deliver_now
  if @payment.save
    if @payment.uploads.attached?
      blob = @payment.uploads.first.blob
      nombre = blob.filename
      @payment.nombre = nombre
      @payment.save

      
    end
    redirect_to payment_path(@payment), notice: "El pago ha sido agregado con éxito."
  else
    render :new
  end
end



  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        @payment.user_update_id = current_user.id
        @payment.commentp = params[:payment][:commentp]
        @payment.save
        user_id_act = @payment.user_update_id
        user = User.find(user_id_act)
        user_name = user.nombre
        format.html { redirect_to payment_url(@payment), notice: "Payment was successfully updated." }

        if current_user.role == "subdireccion" && @payment.verificarsub
          UserMailer.payment_verified_email(current_user, @payment).deliver_now
        elsif current_user.role == "direccion" && @payment.verificarsub && @payment.verificar
          UserMailer.direccion_verified_email(current_user, @payment).deliver_now
        end

        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url, notice: "Payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_params
      params.require(:payment).permit(:user_id,:nombre, :status, :documento_id,:referencia,:user_update_id,:verificar, :verificarsub, :commentp, uploads: [])
    end
end