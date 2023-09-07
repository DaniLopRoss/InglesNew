class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

         has_many :documentos
         has_many :payments
         has_one_attached :avatar
         has_many :certificates

end
