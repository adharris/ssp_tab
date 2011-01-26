$(document).ready(function() {
  $('input.jq-date').live("focus", function() {
    $(this).datepicker();
  });
});
