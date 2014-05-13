//= require bootstrap
//= require bootstrap-datetimepicker
//= require bootstrap-editable
//= require icon_grid

$(document).ready(function() {

  //
  // Bootstrap basic
  //
  $('[alt]').each(function() {
    if ($(this).attr('title') == undefined) {
      $(this).attr('title', $(this).attr('alt')).attr('rel', 'tooltip');
    }
  })
  $('[title]').attr('rel', 'tooltip');
  $('.dropdown-toggle').dropdown();
  $("[rel=tooltip]").tooltip();

  //
  // bootstrap-datetimepicker
  //
  $('.date-time-picker').datetimepicker(
    {
      format: 'yyyy-MM-dd hh:mm:ss'
    }
  );
  $('.date-picker').datetimepicker(
    {
      format: 'yyyy-MM-dd',
      pickTime: false
    }
  );

  $.blockUI.defaults.css = {
    backgroundColor:'transparent',
    color:          '#666'
  };

  $.blockUI.defaults.overlayCSS = {
    backgroundColor:'#fff',
    opacity:        0.75,
    cursor:         'wait'
  };
});

function block_overlay(block, message) {
  var msg = '<div style="text-align:center"><img src="/assets/loading2.gif" /><h5>正在载入，请稍等...</h5></div>';
  if (message != null) {
    msg = message;
  }

  block.block({ message: msg });
}

function unblock_overlay(block) {
  block.unblock();
}
