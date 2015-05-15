#$(function() {
#  $("#sit_filter").select(function() {
#    $.get($("#sit_filter").attr("action"), $("#sit_filter").serialize(), null, "script");
#    return false;
#  });
#});
#
$ ->
  $("#sit_filter").select ->
    $.get($("#sit_filter").attr("action"), $("#sit_filter").serialize(), null, "script")
    return false

#  vim: set ts=8 sw=2 tw=0 noet :
