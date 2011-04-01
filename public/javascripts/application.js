$(document).ready(function() {
  $('input.jq-date').live("focus", function() {
    $(this).datepicker();
  });
  $('select.jq-combo').combobox();

  $('#action-links div').buttonset();
  
  $("input[type='submit']").button();
  

  $("ul.orderable").sortable({
      axis: 'y',
      dropOnEmpty: false,
      cursor: 'crosshair',
      items: 'li',
      opacity: 0.4,
      scroll: true,
      update: function () {
        $this = $(this);
        $.ajax({
          type: 'post',
          data: $(this).sortable('serialize'),
          dataType: 'script',
          complete: function () {
              $this.effect('highlight');
            },
          url: $(this).attr('url')
          });
        }
      });

});
