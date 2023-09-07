class CertificatesController < ApplicationController
  before_action :set_certificate, only: [:show, :edit, :update, :destroy, :edit_titulacion, :update_titulacion]


  def edit_fecha_titulacion
    @certificate = Certificate.find(params[:id])
  end

  def update_fecha_titulacion
    @certificate = Certificate.find(params[:id])
    #puts params.inspect
    if @certificate.update(certificate_params)
      redirect_to certificate_path(@certificate), notice: 'Fecha de titulación actualizada exitosamente.'
    else
      render :edit_fecha_titulacion
    end
  end

  # GET /payments or /payments.json
  def index
    if current_user.role == "direccion" 
      @certificates = Certificate.joins(:payment).where(payments: { verificar: true })
    elsif current_user.role == "titulacion"
      @certificates = Certificate.where(titulacion: nil)
    
    else
      @certificates = Certificate.all
    end
  end
  


  

  
  def verified_titulacion
    @certificates = Certificate.where.not(titulacion: nil)
  end
  




  # GET /payments/1 or /payments/1.json
  def show
    @certificate = Certificate.includes(:documento).find(params[:id])
    @payment = @certificate.payment
    @documento = @certificate.documento
    #@payment = Payment.find(params[:id])
    if @documento&.user_update_id.present?
      user = User.find(@documento.user_update_id)
      @user_name = "#{user.nombre} #{user.apellido_uno} #{user.apellido_dos}"
    else
      @user_name = "Documento no validado"
    end
  
    if @payment&.user_update_id.present?
      userpayment = User.find(@payment.user_update_id)
      @user_namepayment = "#{userpayment.nombre} #{userpayment.apellido_uno} #{userpayment.apellido_dos}"
    else
      @user_namepayment = "Documento no validado"
    end


    if @payment.present? && @payment.audits.size >= 2
      user_id = @payment.audits.order(created_at: :desc).second.user_id
      @user_updated_payment = User.find(user_id)
      @updated_at_payment = @payment.audits.order(created_at: :desc).second.created_at
    end
    

    @documento_date = @documento.updated_at.in_time_zone("Mexico City").strftime("%Y-%m-%d %H:%M:%S")
    @payment_date = @payment&.updated_at&.in_time_zone("Mexico City")&.strftime("%Y-%m-%d %H:%M:%S")
  end
  

  # GET /certificates/new
  def new
    @certificate = Certificate.new
    @payment = Payment.find(params[:payment_id])
  end
  def update_status
    @certificate = Certificate.find(params[:id])
    @certificate.update(status: true)
    redirect_to @certificate.payment
  end
  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
  def create
    
    @certificate = Certificate.new(certificate_params)
    @certificate.payment_id = params[:certificate][:payment_id]
    @certificate.user = current_user

    logger.debug("Payment ID: #{params[:certificate][:payment_id]}")

    if @certificate.save
      blob = @certificate.uploads.first.blob
      nombre=blob.filename
      @certificate.nombre = nombre
      @certificate.save
      redirect_to certificate_path(@certificate), notice: "El documento firmado ha sido agregado con éxito."
      UserMailer.certificate_created_email(current_user, @certificate).deliver_now
      else
        flash[:error] = "El archivo ya existe"
      render :new
    end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      #@certificate.titulacion = params[:certificate][:titulacion]
      if @certificate.update(certificate_params)
        
        format.html { redirect_to certificate_url(@certificate), notice: "Certtificate was successfully updated." }
        format.json { render :show, status: :ok, location: @certificate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @certificate.destroy

    respond_to do |format|
      format.html { redirect_to certificates_url, notice: "Certificate was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certificate
      @certificate = Certificate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def certificate_params
      params.require(:certificate).permit(:user_id, :nombre, :payment_id, :titulacion, :status, uploads: [])
    end
    
end