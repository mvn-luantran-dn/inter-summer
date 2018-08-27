//= require jquery

function changeImg(img) {
  var expandedImg = document.getElementById('expandImg');
  expandedImg.src = img.src;
}
$(document).on('turbolinks:load', function () {
  $("#show_history").click(function(){
    $("#view_history").fadeToggle("slow");
  });
  $("#view_return").click(function() {
    $('#view_shipping_condition').hide();
    $('#view_payment_condition').hide();
    $('#view_return_condition').toggle();
  });
  $("#view_shipping").click(function() {
    $('#view_return_condition').hide();
    $('#view_payment_condition').hide();
    $('#view_shipping_condition').toggle();
  });
  $("#view_payment").click(function() {
    $('#view_return_condition').hide();
    $('#view_shipping_condition').hide();
    $('#view_payment_condition').toggle();
  });
});
