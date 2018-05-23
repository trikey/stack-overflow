vote = ->
  $('.vote_up, .vote_down').on 'ajax:success', (e, data, status, xhr) ->
    rating_block = $(this).closest('.rating_block')
    rating_block.find('.rating').html(data.rating)
    console.log(data.message);
    $('#flash').html('<div class="alert alert-success">' + data.message + '</div>')

  .on 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    message = ''
    $.each errors, (index, value) ->
      message += '<p>' + value + '</p>'

    $('#flash').html('<div class="alert alert-danger">' + message + '</div>')

$(document).on('turbolinks:load', vote)