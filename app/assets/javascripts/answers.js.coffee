$ ->
  $(document).on 'click', '.edit-answer', (e) ->
    e.preventDefault();
    $(this).hide();
    answerId = $(this).data('answer-id');
    $("#edit_answer_#{answerId}").show();