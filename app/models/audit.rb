class Audit < ApplicationRecord
    belongs_to :user
    belongs_to :auditable, polymorphic: true
  
    # Resto de las asociaciones y validaciones que puedas necesitar
  
  end
  