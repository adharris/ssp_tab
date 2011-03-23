$(document).ready(function() {
  $('input.jq-date').live("focus", function() {
    $(this).datepicker();
  });
  $('select.jq-combo').combobox();

  $('#action-links div').buttonset();
});
