class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments

  default_scope { order(best_answer: :desc) }

  def set_best!
    question.answers.update_all(best_answer: false)
    update!(best_answer: true)
  end
end
