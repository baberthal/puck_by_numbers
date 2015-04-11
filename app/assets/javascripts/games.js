$(function() {
  $("#sit_filter").select(function() {
    $.get($("#sit_filter").attr("action"), $("#sit_filter").serialize(), null, "script");
    return false;
  });
});

