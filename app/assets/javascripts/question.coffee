$(document).on 'turbolinks:load', ->
  questions_list = $('.questions')

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      if questions_list.length
        @perform 'follow'
      else
        @perform 'unfollow'
    ,
    received: (data) ->
      data = $.parseJSON(data)
      questions_list.append(JST['templates/question_list'](data.question))
  })