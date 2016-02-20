# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  header = $('#stickedHeader')
  headerPositionTop = header.position().top
  $(window).scroll ->
    if parseInt($(window).scrollTop()) > headerPositionTop
      if header.hasClass('static')
        header.removeClass('static').addClass 'fixed'
    else
      if header.hasClass('fixed')
        header.removeClass('fixed').addClass 'static'
    return
  return