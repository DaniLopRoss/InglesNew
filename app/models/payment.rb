class Payment < ApplicationRecord
   audited
    belongs_to :documento, autosave: true
    has_many_attached :uploads 
    has_one :certificate
    belongs_to :user
 
    # validates :status, presence: true


      #validates :uploads, presence: { message: "necesita adjuntar un documento" }

   
end


   # def self.sin_certificado
    #     where(certificate_id: nil)
    #   end  