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
      questions_list.append(JST['templates/question_list']($.parseJSON(data)))
  })