class Documento < ApplicationRecord
  #validates :numero_de_control,  uniqueness: { message: "ya existe en la base de datos" }
  audited except: :fecha
  has_paper_trail
  has_one_attached :archivo_pdf
  has_many_attached :uploads
  has_many_attached :xml_uploads
  belongs_to :user
  has_one :payment
  validates :uploads, presence: { message: "necesita adjuntar un documento" }
  validates :xml_uploads, presence: { message: "necesita adjuntar un documento" }
  #validates :referencia, uniqueness: true
 
  def self.sin_pago
    where.not(id: Payment.select(:documento_id))
  end



end
 