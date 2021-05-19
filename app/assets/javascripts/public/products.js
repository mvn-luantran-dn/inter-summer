//= require jquery

// jQuery(function($) {

//   // define the gallery object
//   var $gallery = $('#js-gallery');

//   // Build array of objects to open in Fancybox.
//   var $imgs = [];
//   $('a', $gallery).each(function() {
//     $imgs.push({'src': $(this).data('zoom-image')});
//   });

//   // Initiate ElevateZoom
//   $("#js-ContentPlaceHolder1_imgProductPhoto").elevateZoom({
//     gallery: $gallery.attr('id'),
//     cursor: 'pointer',
//     galleryActiveClass: 'active',
//     imageCrossfade: true,
//     loadingIcon: 'loading.gif'
//   });

//   // Bind Fancybox to clicking the zoom image.
//   // Open it to the currently active index.
//   $("#js-ContentPlaceHolder1_imgProductPhoto").on("click", function(e) {
//     e.preventDefault();
//     var active_index = $('a.active', $gallery).index();
//     $.fancybox.open($imgs, false, active_index);
//   });

// });

function changeImg(img) {
  var expandedImg = document.getElementById('expandImg');
  expandedImg.src = img.src;
}