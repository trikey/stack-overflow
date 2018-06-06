$ ->
  $(document).on 'click', '.edit-answer', (e) ->
    e.preventDefault();
    $(this).hide();
    answerId = $(this).data('answer-id');
    $("#edit_answer_#{answerId}").show();

  App.cable.subscriptions.create("AnswersChannel", {
    connected: ->
      question_id = $('.question').data('questionId')
      if question_id
        @perform 'follow', question_id: question_id
      else
        @perform 'unfollow'
    ,
    received: (data) ->
      data = $.parseJSON(data)
      $('.answers').append(JST["templates/answer"](data))
  })