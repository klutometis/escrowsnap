# Ajax Setup
jQuery.ajaxSetup 'beforeSend': (xhr) -> xhr.setRequestHeader("Accept", "text/javascript")

jQuery ->
  $().timelinr()
  $("ul#dates a:first").click()


  $('a.get').live 'click', (e) -> 
    e.preventDefault()
    $.get $(this).attr('href')
  
  $('button.get').live 'click', (e) ->
    e.preventDefault()
    $.get $(this).attr('data-path')