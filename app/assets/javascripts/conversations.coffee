# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  $('.encryptMessage').on 'click', (e) ->
    encrypt = undefined
    encrypted = undefined
    publicKey = undefined
    textArea = undefined
    publicKey = $.trim($(".recipientPublicKey").text())
    textArea = $('#message_body')
    encrypt = new JSEncrypt
    encrypt.setPublicKey publicKey
    encrypted = encrypt.encrypt(textArea.val() or '')
    textArea.val encrypted
    return
    
  $('.showHideMessage').on 'click', (e) ->
    target = $(e.target)
    privateKey = localStorage.getItem('privateKey')
    message = target.siblings('.list').children(".item").children("span.messageBody").first()
    decryptedMessageBody = target.siblings('.list').children(".item").children("span.decryptedMessageBody").first()
    decryptModule = new JSEncrypt
    decryptModule.setPrivateKey privateKey
    decrypted = decryptModule.decrypt($.trim(message.text()))
    if !decryptedMessageBody.is(':visible')
      decryptedMessageBody.text decrypted
      $(this).text 'Hide message'
      decryptedMessageBody.show()
      message.hide()
    else
      decryptedMessageBody.hide()
      $(this).text 'Show message'
      message.show()
    return
  return