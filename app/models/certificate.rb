class Certificate < ApplicationRecord
    audited except: :titulacion
    has_many_attached :uploads 
    belongs_to :payment, autosave:  true
    has_one :documento, through: :payment
    validates :uploads, presence: { message: "necesita adjuntar un documento" }
   # validates :nombre, uniqueness: true
   belongs_to :user
    
end
