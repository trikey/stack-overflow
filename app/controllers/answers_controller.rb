class AnswersController < ApplicationController
  before_action :set_answer, only: [:edit, :update, :destroy, :best]
  before_action :set_question, only: [:create]
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def edit; end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    unless current_user.author_of?(@answer)
      flash[:alert] = 'Can not update not your answer'
      redirect_to @answer.question
      return
    end

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

  def best
    unless current_user.author_of?(@answer.question)
      flash[:alert] = 'Can not set best answer of not your question'
      redirect_to @answer.question
      return
    end

    @answer.make_best
    flash[:notice] = 'Answer marked as best'
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
