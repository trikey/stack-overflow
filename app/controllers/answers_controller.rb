class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update, :destroy, :best]
  before_action :set_question, only: [:create]
  after_action :publish_answer, only: [:create]

  include Voted

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

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
        "answers_#{@question.id}",
        ApplicationController.render(json: {
            answer: @answer,
            attachments: @answer.attachments
        })
    )
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:_destroy, :id, :file])
  end
end
