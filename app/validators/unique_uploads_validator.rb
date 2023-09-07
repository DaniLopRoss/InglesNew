# app/validators/unique_uploads_validator.rb
class UniqueUploadsValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      value.each do |upload|
        if record.class.joins("INNER JOIN active_storage_attachments AS att ON att.record_type = '#{record.class}' AND att.record_id = #{record.class.table_name}.id")
                     .joins("INNER JOIN active_storage_blobs AS blobs ON blobs.id = att.blob_id")
                     .where.not("att.name = ?", upload.name)
                     .where(blobs: { filename: upload.filename.to_s, checksum: upload.blob.checksum })
                     .count > 0
          record.errors.add(attribute, "El archivo #{upload.blob.filename.to_s} ya ha sido subido.")
        end 
      end 
    end 
  end