class DailyMailerPreview < ActionMailer::Preview

  def digest
    user = User.first
    questions = Question.last_day
    DailyMailer.digest(user, questions)
  end

end