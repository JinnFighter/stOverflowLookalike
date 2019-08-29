class Question < ApplicationRecord
  validates :title, :body, presence:true
  has_many :answers
  has_many :attachments
  belongs_to :user
end
