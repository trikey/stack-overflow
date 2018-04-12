class AnswersController < ApplicationController
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_question, only: [:create]
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def edit; end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @answer.question
    else
      render 'questions/show';
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted.'
    else
      flash[:alert] = 'Can not delete not your answer'
    end
    redirect_to @answer.question
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
