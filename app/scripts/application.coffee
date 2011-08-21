# Ajax Setup
jQuery.ajaxSetup 'beforeSend': (xhr) -> xhr.setRequestHeader("Accept", "text/javascript")

jQuery ->
  $().timelinr()
  $("ul#dates a:first").click()