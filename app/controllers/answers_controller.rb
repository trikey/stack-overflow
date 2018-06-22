class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update, :destroy, :best]
  before_action :set_question, only: [:create]
  after_action :publish_answer, only: [:create]

  authorize_resource

  include Voted

  def edit; end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Answer was successfully deleted.'
    redirect_to @answer.question
  end

  def best
    authorize! :best, @answer

    @answer.make_best
    flash[:notice] = 'Answer marked as best'
    redirect_to @answer.question
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
        "answers_#{@question.id}",
        { answer: @answer, attachments: @answer.attachments }.to_json
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
