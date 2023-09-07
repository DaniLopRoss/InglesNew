Rails.application.routes.draw do
  resources :users
  
  resources :certificates do
    member do
      get 'edit_fecha_titulacion'
      patch 'update_fecha_titulacion'
    end
end

  resources :payments
  resources :referencia
  resources :anexos




  resources :file_uploads
  resources :archivos
  post 'archivos/subir_archivo' => 'archivos#subir_archivo'

  resources :documentos
  get '/descargar_pdf', to: 'documentos#descargar_pdf'
  get 'ingles', to: 'home#ingles'
  get 'financieros', to: 'home#financieros'
  get 'direccion', to: 'home#direccion'
  get 'servicios', to: 'home#serviciosescolares'
  get 'pagadas', to: 'documentos#index2'
  root to: 'home#index'
  #get 'documentos/:id/download', to: 'documentos#download', as: 'download_documento'

  resources :documentos 
  

  patch '/documentos/:id/update_status', to: 'documentos#update_status', as: 'update_status_documento'



  devise_for :user
  authenticated :user do
    root 'home#index', as: :admin_root
  end
  


  authenticated :ingles, :gestion do
    root 'home#ingles', as: :ingles_root
  end
  
  
  authenticated :financieros do
    root 'home#financieros', as: :financieros_root
  end
  authenticated :servicios do
    root 'home#serviciosescolares', as: :servicios_root
  end

  devise_scope :devise do 
    get 'signup', to: 'devise/registrations#new'
    get 'sign_in', to: 'devise/sessions#new'
    #get 'signout', to: 'devise/sessions#destroy'
  end 
  devise_scope :user do
    # Otras rutas de Devise aquí
    get "/signout" => "devise/sessions#destroy"
  end
  
  

  get 'verified_documents', to: 'payments#verified_documents'

  get 'verified_subdireccion', to: 'payments#verified_subdireccion'
  #get 'agregar_fecha_titulacion', to: 'certificates#agregar_fecha_titulacion'
  get 'verified_gestion', to: 'documentos#verified_gestion'
    
  get 'verified_titulacion', to: 'certificates#verified_titulacion'

  get 'documentos_invalidos', to: 'documentos#documentos_invalidos'

  get 'documentos_gestion', to: 'documentos#documentos_gestion'

  get 'financieros_invalidos', to: 'documentos#financieros_invalidos'

  get 'subdireccion_invalidos', to: 'payments#subdireccion_invalidos'
  get 'direccion_invalidos', to: 'payments#direccion_invalidos'
  

end

