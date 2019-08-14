require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer_to_question, user: @user) }

  describe "GET index" do
    let(:answers) { create_list(:answer, 2)}
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
      before {get :edit, params: { id:answer }}

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
          expect{ post :create, params: {answer: attributes_for(:answer_to_question), question_id: parent_question}}.to change(Answer, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: {answer: attributes_for(:answer_to_question), question_id: parent_question}
          expect(response).to redirect_to question_path(parent_question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect{ post :create, params: {answer: attributes_for(:invalid_answer), question_id: parent_question}}.to_not change(Answer, :count)
        end

        it 're-renders new view' do
          post :create, params: {answer: attributes_for(:invalid_answer), question_id: parent_question}
          expect(response).to render_template :new
        end
      end
    end

    describe "PATCH update" do
      sign_in_user

      context 'valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: {id: answer, answer: attributes_for(:answer)}
          expect(assigns(:answer)).to eq(answer)
        end

        it 'changes question attributes' do
          patch :update, params: {id: answer, answer: {body: "new answer"}}
          answer.reload
          expect(answer.body).to eq "new answer"
        end

        it 'redirects to the updated answer' do
          patch :update, params: {id: answer, answer: attributes_for(:answer)}
          expect(response).to redirect_to answer
        end
      end

      context 'invalid attributes' do
        before { patch :update, params: {id: answer, answer:{body: nil}} }

        it 'does not change answer attributes' do
          answer.reload

          expect(answer.body).to eq 'Test_body'
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE destroy" do
      sign_in_user
      before {answer}

      it 'deletes answer' do
        expect{ delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answers_path
      end
    end
  end
end
