# encoding: utf-8

class ArticleUploader < CarrierWave::Uploader::Base

  storage :file
 

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(doc docx)
  end

  def content_type_whitelist
    %w(application/msword
       application/vnd.openxmlformats-officedocument.wordprocessingml.document)
  end
end
