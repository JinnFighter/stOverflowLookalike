class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :edit, :update, :destroy]

  def index
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    if @answer.save
      flash[:notice] = 'Your answer was successfully added.'
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user.id == @answer.user_id
      @answer.update(answer_params)
    else
      respond_to do |format|
        format.js { flash.now[:notice] = 'You cannot edit answers you have not created.' }
      end
    end
  end

  def show

  end

  def edit

  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
    else
      respond_to do |format|
        format.js { flash.now[:notice] = "You can\'\ t delete answers you haven\'\ t created." }
      end
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit!
  end
end
