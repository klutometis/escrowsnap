/* DO NOT MODIFY. This file was compiled Sun, 21 Aug 2011 21:19:19 GMT from
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
    $('a.get').live('click', function(e) {
      e.preventDefault();
      return $.get($(this).attr('href'));
    });
    return $('button.get').live('click', function(e) {
      e.preventDefault();
      return $.get($(this).attr('data-path'));
    });
  });
}).call(this);
