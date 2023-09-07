class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_user!
         protected
     
         def configure_permitted_parameters
             devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :nombre, :id, :apellido_uno, :apellido_dos, :role]) 
             devise_parameter_sanitizer.permit(:account_update, keys: [:email, :nombre, :id, :apellido_uno, :apellido_dos, :role])
         end
         
         def after_sign_in_path_for(resource)
          if current_user.role == 'ingles'
              ingles_path
            elsif current_user.role == 'financieros'
              financieros_path
            elsif current_user.role == 'direccion'
              direccion_path
            elsif current_user.role == 'servicios'
              servicios_path
            elsif current_user.role == 'titulacion'
              servicios_path
            elsif current_user.role == 'gestion'
              documentos_path
            elsif current_user.role == 'subdireccion'
              payments_path
            else
              root_path 
            end
          end
         
end
