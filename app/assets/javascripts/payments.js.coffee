# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/ 
$(document).ready ->
  $('.payments.new, .payments.create, .payments.edit').ready ->
    console.log "this is working"
    $(".datepicker").datetimepicker 
      pickTime: false,
      format: 'MM/DD/YYYY'