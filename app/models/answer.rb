class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question
  belongs_to :user

  def set_best!
    question.answers.update_all(best_answer: false)
    update!(best_answer: true)
  end
end
