class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = current_user.questions.new
  end

  def edit

  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question was successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user.id == @question.user_id
      @question.update(question_params)
    else
      respond_to do |format|
        format.js { flash.now[:notice] = 'You cannot edit questions you have not created.' }
      end
    end
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      flash[:notice] = 'Question was successfully deleted.'
    else
      flash[:notice] = "You can\'\ t delete questions you haven\'\ t created."
    end
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit!
  end
end
