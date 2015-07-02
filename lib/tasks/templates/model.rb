class Import < ActiveRecord::Base

  has_attached_file :asset
  validates_attachment_content_type :asset, content_type: ['text/csv', 'text/plain']

  validates :name_of_model, presence: true

end
