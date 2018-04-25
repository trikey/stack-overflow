class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
    @question.attachments.build
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    unless current_user.author_of?(@question)
      flash[:alert] = 'Can not update not your question'
      redirect_to @question
      return
    end

    if @question.update(question_params)
      flash[:notice] = 'Question was successfully updated.'
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Question was successfully deleted.'
    else
      flash[:alert] = 'Can not delete not your question'
    end
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:_destroy, :id, :file])
  end
end
