//= require jquery

function changeImg(img) {
  var expandedImg = document.getElementById('expandImg');
  expandedImg.src = img.src;
}
$(document).ready(function(){
  $("#show_history").click(function(){
      $("#view_history").fadeToggle("slow");
  });
});
