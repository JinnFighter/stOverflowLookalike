class Question < ApplicationRecord
  validates :title, :body, presence:true
  has_many :answers
  has_many :attachments, as: :attachable, inverse_of: :attachable
  belongs_to :user

  accepts_nested_attributes_for :attachments
end
