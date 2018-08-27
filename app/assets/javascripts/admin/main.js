function check() {
  var number = $('.image-list').find('input[value="false"]').length;
  if (number > 3) {
    $('.add').hide();
  } else {
    $('.add').show();
  }
  if (number > 1) {
    $('.remove').show();
  } else {
    $('.remove').hide();
  }
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  // find the new_ + "association" that was defined in Rails helper
  var regexp = new RegExp("new_" + association, "g");

  // find the container and append in the sub field content
  $(link).prev().append(content.replace(regexp, new_id));
  check();
  return false;
}

function removeField(link) {
  $(link).prev("input[type = hidden]").val("1");
  $(link).closest(".image-item").fadeOut();
  check();
}

$(document).ready(function () {
  check();
  $('#dataTables-example').dataTable();
});
$(document).on('turbolinks:load', function () {
  if ($('textarea').length > 0) {
    var data = $('.ckeditor');
    $.each(data, function (i) {
      CKEDITOR.replace(data[i].id)
    });
  }
});
