# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.accounts.show').ready ->
  $('a#view-history').on 'click', (e) ->
    e.preventDefault()
    $('#accountTabs a[href="#history"]').tab('show')

  # Execute datatable.js on history
  $.fn.dataTable.moment( 'MM/DD/YYYY' )
  $("#account-history").DataTable()


$('.accounts.new, .accounts.edit').ready ->
  $('#account_schedule').on('change', ->
    is_not_recurring  = $('#account_schedule')[0].selectedIndex == 0
    $('#account_payment_amount').prop('disabled', is_not_recurring))