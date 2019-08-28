# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
q_ready = ->
  $('.edit-question-link').on 'click', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $("form#edit-question-"+question_id).show();

$(document).ready(q_ready)
$(document).on('turbolinks:load', q_ready)
$(document).on('turbolinks:update', q_ready)
