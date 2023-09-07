require 'nokogiri'
require 'builder'
#require 'pdf-reader'
require 'digest'


# require 'barby/barcode/itf'
# require 'barby/outputter/svg_outputter'

class DocumentosController < ApplicationController
  before_action :set_documento, only: %i[ show edit update destroy ]

  # GET /documentos or /documentos.json
  def index
    if current_user.role == "direccion" 
      @documentos = Documento.sin_pago.where(status: true)
    elsif current_user.role == "gestion"
      @documentos = Documento.joins(:payment)
                             .where.not(payments: { id: nil }).where(payments:{commentp:nil})
                             .where(documentos: { status: false, comment: nil })
    elsif current_user.role == "financieros"
      @documentos = Documento.sin_pago.where(comment: nil)
    elsif current_user.role == "ingles" || current_user.role == "servicios" || current_user.role == "administrador"
      @documentos = Documento.where(comment: nil)
    else
      # Si el usuario no tiene un rol válido, se muestra una lista vacía
      @documentos = []
    end
    
  end

  # GET /documentos/1 or /documentos/1.json
  def show
    @documento = Documento.find(params[:id])
    user_id_act = @documento.user_update_id
    if user_id_act.present?
      user = User.find(user_id_act)
      @user_name = "#{user.nombre} #{user.apellido_uno} #{user.apellido_dos}"
    else
      @user_name = "Documento no validado"
    end
    @documento_date = @documento.updated_at.in_time_zone("Mexico City").strftime("%Y-%m-%d %H:%M:%S")
    #puts "Nombre del usuario que actualizó el documento: #{@user_name}"
    #@certificate = Certificate.includes(:documento).find_by(documento_id: @documento.id)
    @payment = Payment.includes(:documento).find_by(documento_id: @documento.id)
    

  end
  
  # GET /documentos/new
  def new
    @documento = Documento.new
    
   
  end

  # GET /documentos/1/edit
  def edit
  end

  # POST /documentos or /documentos.json

  def create
    respond_to do |format|
      @documento = Documento.new(documento_params)
      @documento.user = current_user
      
      if @documento.save

  

        pdf_blob =  @documento.uploads.first.blob
        xml_blob = @documento.xml_uploads.first.blob
        
        referencia = pdf_blob.filename.to_s

        md5_pdf = Digest::MD5.hexdigest(pdf_blob.download)
        xml_doc = Nokogiri::XML(xml_blob.download)
        md5_xml = xml_doc.xpath('//md5-pdf').text
  
        # puts md5_pdf
        # puts md5_xml
 
        if md5_xml == md5_pdf
          # Read the contents of the XML file
          xml_content = xml_blob.download
          xml_doc = Nokogiri::XML(xml_content)
          
          # Extract the relevant data from the XML document
          serial = xml_doc.at_xpath("//serial")&.text
          no_oficio = xml_doc.at_xpath("//no-oficio")&.text
          asunto = xml_doc.at_xpath("//asunto")&.text
          plan = xml_doc.at_xpath("//plan")&.text
          nombre = xml_doc.at_xpath("//nombre-completo")&.text
          numero_de_control = xml_doc.at_xpath("//numero-control")&.text
          carrera = xml_doc.at_xpath("//carrera")&.text
          nivel = xml_doc.at_xpath("//nivel")&.text
          periodo = xml_doc.at_xpath("//periodo")&.text
          #fecha = xml_doc.at_xpath("//fecha")&.text
          md5 = xml_doc.at_xpath("//md5-pdf")&.text
          cadena_comprobacion = xml_doc.at_xpath("//cadena-comprobacion")&.text
          
          fecha_str = xml_doc.at_xpath("//fecha")&.text
          fecha = Date.parse(fecha_str) if fecha_str
          
          

          # Save the extracted data in the database
          @documento.serial = serial
          @documento.no_oficio = no_oficio
          @documento.asunto = asunto
          @documento.plan = plan
          @documento.nombre = nombre
          @documento.numero_de_control = numero_de_control
          @documento.carrera = carrera
          @documento.nivel = nivel
          @documento.periodo = periodo
          @documento.fecha = fecha
          @documento.md5= md5
          @documento.referencia=referencia
          @documento.cadena_comprobacion = cadena_comprobacion
          @documento.status = 0
          @documento.user_update_id = nil
          existing_doc = Documento.find_by(md5: md5_pdf)
          if existing_doc.present?
            format.html { redirect_to new_documento_path, alert: 'El documento ya existe en la base de datos.' }
            format.json { render json: { error: 'El documento ya existe en la base de datos.' }, status: :unprocessable_entity }
            # Eliminar el documento y los archivos de Active Storage
            @documento.destroy
            pdf_blob.purge
            xml_blob.purge
          end
          @documento.save
          
          UserMailer.document_created_email(current_user, @documento).deliver_now


        else

        format.html { redirect_to new_documento_path, alert: 'El archivo PDF y el archivo XML no coinciden. Por favor, sube el archivo correcto.' }
        format.json { render json: { error: 'El archivo PDF y el archivo XML no coinciden. Por favor, sube el archivo correcto.' }, status: :unprocessable_entity }
          # Código que se ejecuta si los archivos no coinciden
          # Eliminar el documento y los archivos de Active Storage
          @documento.destroy
          pdf_blob.purge
          xml_blob.purge
        end
        
        format.html { redirect_to @documento, notice: 'Documento se ha creado con éxito.' }
        format.json { render :show, status: :created, location: @documento }
      else
        format.html { render :new }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end
  


  def verified_gestion
    @documentos = Documento.joins(:payment).where.not(payments: { id: nil }).where(documentos: { status: true })
  end
     

  def documentos_invalidos
    @documentos = Documento.where.not(comment: nil)
  end

  def documentos_gestion
    @documentos = Documento.where.not(comment: nil)
  end

  def financieros_invalidos
    @documentos = Documento.where.not(comment: nil)
  end

  
  # PATCH/PUT /documentos/1 or /documentos/1.json
 def update
  respond_to do |format|
    if @documento.update(documento_params)
      @documento.user_update_id = current_user.id
      @documento.comment = params[:documento][:comment]
      @documento.save
      user_id_act = @documento.user_update_id
      user = User.find(user_id_act)
      user_name = user.nombre
      #puts "Nombre del usuario que actualizó el documento: #{user_name}"

      # puts "User updated document with id: #{current_user.id}"
 # Enviar correo a usuarios con rol "subdireccion"
 if current_user.role == "gestion" && @documento.status
  UserMailer.document_verified_email(current_user, @documento).deliver_now
end


      format.html { redirect_to documento_url(@documento), notice: "Documento se ha actualizado con éxito." }
      format.json { render :show, status: :ok, location: @documento }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @documento.errors, status: :unprocessable_entity }
    end
  end
end

  # DELETE /documentos/1 or /documentos/1.json
  def destroy
    begin
      @documento.destroy
      respond_to do |format|
        format.html { redirect_to documentos_url, notice: "Documento was successfully destroyed." }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      respond_to do |format|
        format.html { redirect_to documentos_url, alert: "Cannot delete document because it is associated with payments." }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_documento
      @documento = Documento.find(params[:id])
      @documento_id= @documento.id
   
    end

    # Only allow a list of trusted parameters through.
 def documento_params
  params.require(:documento).permit(:serial, :no_oficio, :asunto, :plan, :nombre, :numero_de_control, :carrera, :nivel, :periodo, :md5, :cadena_comprobacion, :fecha, :user_id, :referencia, :status,:user_update_id, :comment, uploads: [], xml_uploads: [])

end


# def update_status
#   documento = Documento.find(params[:id])
#   user = documento.user
#   status = params[:status]
#   documento.update(status: status)
#   redirect_to documentos_path
# end



 

end    