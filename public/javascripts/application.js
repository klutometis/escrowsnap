/* DO NOT MODIFY. This file was compiled Sun, 21 Aug 2011 13:02:03 GMT from
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
    return $("ul#dates a:first").click();
  });
}).call(this);
