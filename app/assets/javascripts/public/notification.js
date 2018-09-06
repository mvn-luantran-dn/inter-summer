$(document).ready(function () {
  $(".notif-item").slice(0, 5).attr('style','display:block !important');
  $("#loadMore").on('click', function (e) {
      e.stopPropagation();
      e.preventDefault();
      $(".notif-item:hidden").slice(0, 5).attr('style','display:block !important');
      if ($(".notif-item:hidden").length == 0) {
          $("#loadMore").fadeOut('slow');
      }
  });
});
