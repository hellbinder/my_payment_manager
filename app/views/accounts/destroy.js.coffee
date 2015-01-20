$('.delete_account').bind ('ajax:success'), ->
  $(this).closest('tr').fadeOut 'slow', ->
      $(this).remove()