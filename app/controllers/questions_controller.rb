class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :build_answer, only: [:show]
  before_action :build_attachments, only: [:edit]
  after_action :publish_question, only: [:create]

  respond_to :js, only: [:update]
  respond_to :json

  include Voted

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit; end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy) if current_user.author_of?(@question)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(json: { question: @question })
    )
  end

  def build_answer
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def build_attachments
    @question.attachments.build
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:_destroy, :id, :file])
  end
end
