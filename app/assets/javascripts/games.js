$(function() {
  $("#sit_filter").select(function() {
    $.get($("#sit_filter").attr("action"), $("#sit_filter").serialize(), null, "script");
    return false;
  });
});

$(function() {
  var $tooltip = $('#tooltip');
  $tooltip.hide();
  var $text = $('#tooltiptext');
  displayTooltip = function (text, left) {
    $text.text(text);
    $tooltip.show();
    $tooltip.css('left', parseInt(left) + 24 + 'px');
  };
  var timer;
  hideTooltip = function (e) {
    clearTimeout(timer);
    timer = setTimeout(function () {
      $tooltip.fadeOut();
    }, 5000);
  };
});
