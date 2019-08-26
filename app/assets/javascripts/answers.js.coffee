ready = ->
  $('.edit-answer-link').on 'click', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $("form#edit-answer-" + answer_id).show();

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
$(document).on('turbolinks:update', ready)
