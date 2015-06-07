# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  $('#setKeys').on 'click', ->
    privateKey = undefined
    publicKey = undefined
    userId = window.location.pathname.match(/[0-9]/)[0]
    publicKey = $('#publicKey').val()
    privateKey = $('#privateKey').val()
    localStorage.setItem 'publicKey', publicKey
    localStorage.setItem 'privateKey', privateKey
    $.ajax
      type: 'POST'
      url: '/users/setPublicKey'
      data:
        public_key: publicKey
        id: userId
      success: (data) ->
        console.log data.message
        return
    return
  return