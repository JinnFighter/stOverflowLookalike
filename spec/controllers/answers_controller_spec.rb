require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create :user }
  let!(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }
  let(:other_answer) { create :answer, question: question }
  let!(:other_question) { create :question }
  let(:third_answer) { create :answer, question: other_question }

  describe "GET index" do
    let(:answers) { create_list(:answer, 2) }
    before { get :index }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

    describe "GET show" do
      before { get :show, params: { id: answer } }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    describe "GET new" do
      sign_in_user
      before { get :new }

      it 'assigns a new Answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe "GET edit" do
      sign_in_user
      before { get :edit, params: { id: answer } }

      it 'assign the requested answer to @answer' do
        expect(assigns(:answer)).to eq(answer)
      end

      it 'should render edit view' do
        expect(response).to render_template :edit
      end
    end

    describe "POST create" do
      sign_in_user
      let(:parent_question) { FactoryGirl.create(:question) }

      context 'with valid attributes' do

        it 'saves new answer in the database' do
          expect{ post :create, params: { answer: attributes_for(:answer_to_question), question_id: parent_question, format: :js } }.to change(parent_question.answers, :count).by(1)
        end

        it 'renders create template' do
          post :create, params: { answer: attributes_for(:answer_to_question), question_id: parent_question, format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with valid attributes and attachment' do
        it 'saves new answer in the database' do
          expect{ post :create, params: { answer: attributes_for(:answer, :with_file), question_id: question, format: :js } }.to change(Answer, :count).by(1)
        end

        it 'renders create template' do
          post :create, params: { answer: attributes_for(:answer, :with_file), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect{ post :create, params: { answer: attributes_for(:invalid_answer), question_id: parent_question, format: :js } }.to_not change(Answer, :count)
        end

        it 're-renders create view' do
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: parent_question, format: :js }
          expect(response).to render_template :create
        end
      end
    end

    describe "PATCH update" do
      let(:answer) { create(:answer, question: question, user: user) }
      before do
        sign_in(user)
      end

      context 'edit own answer' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq(answer)
        end

        it 'assigns the question' do
          patch :update, params: { id: answer, question_id: question, answer: { body: "new answer" }, format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'changes answer attributes' do
          patch :update, params: { id: answer, question_id: question, answer: { body: "new answer" }, format: :js }
          answer.reload
          expect(answer.body).to eq "new answer"
        end

        it 'render update template' do
          patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'edit someone elses answer' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: other_answer, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq(other_answer)
        end

        it 'assigns the question' do
          patch :update, params: { id: other_answer, question_id: question, answer: { body: "new answer" }, format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'does not change answer attributes' do
          patch :update, params: { id: other_answer, question_id: question, answer: { body: "new answer" }, format: :js }
          answer.reload
          expect(other_answer.body).to eq "MyText"
        end

        it 'renders update template' do
          patch :update, params: { id: other_answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end
    end

    describe "DELETE destroy" do
      before do
        sign_in(user)
      end

      context 'by author' do
        before { answer }

        it 'deletes answer' do
          expect{ delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not by author' do
        before { other_answer }

        it 'does not delete answer' do
          expect { delete :destroy, params: { id: other_answer, format: :js } }.to_not change(Answer, :count)
        end

        it 're-renders show template' do
          delete :destroy, params: { id: other_answer, format: :js }
          expect(response).to redirect_to answer_path(other_answer)
        end
      end
    end

    describe 'Mark as best' do
      before do
        sign_in(user)
      end

      context 'as author of question' do
        it 'assigns the requested answer to @answer' do
          patch :set_best, params: { id: answer, format: :js }
          expect(assigns(:answer)).to eq(answer)
        end

        it 'assigns the question' do
          patch :set_best, params: { id: answer, question_id: question, format: :js }
          expect(assigns(:question)).to eq(question)
        end

        it 'changes answer best attribute' do
          patch :set_best, params: { id: answer, question_id: question, answer: { best_answer: true }, format: :js }
          answer.reload
          expect(answer.best_answer).to eq true
        end

        it 'renders set_best template' do
          patch :set_best, params: { id: answer, question_id: question, answer: { best_answer: true }, format: :js }
          expect(response).to render_template :set_best
        end
      end

      context 'not as author of question' do
        it 'assigns the requested answer to @answer' do
          patch :set_best, params: { id: third_answer, format: :js }
          expect(assigns(:answer)).to eq(third_answer)
        end

        it 'assigns the question' do
          patch :set_best, params: { id: third_answer, question_id: other_question, format: :js }
          expect(assigns(:question)).to eq(other_question)
        end

        it 'does not change answer best attribute' do
          patch :set_best, params: { id: third_answer, question_id: other_question, answer: { best_answer: true }, format: :js }
          answer.reload
          expect(answer.best_answer).to eq false
        end

        it 'renders set_best template' do
          patch :set_best, params: { id: third_answer, question_id: other_question, answer: { best_answer: true }, format: :js }
          expect(response).to render_template :set_best
        end
      end
    end
  end
end
