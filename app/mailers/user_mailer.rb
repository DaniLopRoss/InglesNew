class UserMailer < ApplicationMailer
    def document_created_email(user, documento)
      @user = user
      @documento = documento
      mail(to: financieros_emails, subject: 'Se ha subido un nuevo documento')
    end
  
    def payment_created_email(user, payment)
      @user = user
      @payment = payment
      mail(to: gestion_emails, subject: 'Se ha subido un nuevo documento')
    end
  
    def document_verified_email(user, documento)
      @user = user
      @documento = documento
      mail(to: subdireccion_emails, subject: 'Documento verificado') if documento.status
    end
  
    def payment_verified_email(user, payment)
      @user = user
      @payment = payment
      mail(to: direccion_emails, subject: 'Documento verificado') if payment.verificarsub
    end


    def direccion_verified_email(user, payment)
      @user = user
      @payment = payment
      mail(to: ingles_emails, subject: 'Documento verificado') if payment.verificar
    end

  
    def certificate_created_email(user, certificate)
      @user = user
      @certificate = certificate
      mail(to: titulacion_emails, subject: 'Se ha subido un nuevo documento')
    end
  
    private
  
    def financieros_emails
      User.where(role: 'financieros').pluck(:email)
    end
  
    def gestion_emails
      User.where(role: 'gestion').pluck(:email)
    end
  
    def subdireccion_emails
      User.where(role: 'subdireccion').pluck(:email)
    end
  
    def direccion_emails
      User.where(role: 'direccion').pluck(:email)
    end

    def ingles_emails
      User.where(role: 'ingles').pluck(:email)
    end
  
    def titulacion_emails
      User.where(role: ['titulacion', 'servicios']).pluck(:email)
    end
  end
  