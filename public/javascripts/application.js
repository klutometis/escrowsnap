/* DO NOT MODIFY. This file was compiled Sun, 21 Aug 2011 19:52:22 GMT from
 * /Users/micah/rails/escrowsnap/app/scripts/application.coffee
 */

(function() {
  jQuery.ajaxSetup({
    'beforeSend': function(xhr) {
      return xhr.setRequestHeader("Accept", "text/javascript");
    }
  });
  jQuery(function() {
    $().timelinr();
    $("ul#dates a:first").click();
    return $('a.get').click(function(e) {
      e.preventDefault();
      return $.get($(this).attr('href'));
    });
  });
}).call(this);
