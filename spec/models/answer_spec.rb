require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  describe 'sets best_answer' do
    let!(:user) { create(:user) }
    let!(:question) { create :question, user: user }
    let!(:answer) { create :answer, question: question }
    let!(:other_answer) { create :answer, question: question, best_answer: true }

    it 'should set answer as best' do
      answer.set_best!
      expect(answer.best_answer).to be true
    end

    it 'should make other answers not best' do
      answer.set_best!

      answer.reload
      other_answer.reload

      expect(answer.best_answer).to be true
      expect(other_answer.best_answer).to be false
    end
  end
end
