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
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def show

  end

  def edit

  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:notice] = 'Your answer was successfully deleted.'
    else
      flash[:notice] = "You can\'\ t delete answers you haven\'\ t created."
    end
    redirect_to answers_path
  end
  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit!
  end
end
