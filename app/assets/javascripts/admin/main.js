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

function total_order() {
  result = null;
  $.ajax({
    url: "/order_sum",
    type: 'GET',
    contentType: 'application/json; charset=utf-8',
    dataType: 'JSON',
    async: false,
    success: function (response) {
      result = response;
    },
    error: function (err) {
      console.log(err);
    }
  });
  return result;
}

$(document).ready(function () {
  check();
  total_money = $('#total_money');
  if(total_money.html()){
    total_money.html(" " + formatMoney(parseInt($('#total_money').html())));
  }
  $("#checkAll").click(function () {
    if (this.checked) {
      $('.delete-more').show();
    } else {
      $('.delete-more').hide();
    }
    $('input:checkbox').not(this).prop('checked', this.checked);
  });
  $(".table-row-checkbox").change(function () {
    if (this.checked) {
      $('.delete-more').show();
    } else {
      if ($("tbody").find("input[type=checkbox]:checked").length < 1) {
        $('.delete-more').hide();
      }
    }
  });
  CKEDITOR.config.height = 500;
  CKEDITOR.config.width = 800;
  CKEDITOR.config.entities_processNumerical = 'force';
  if ($('textarea').length > 0) {
    var data = $('.ckeditor');
    $.each(data, function (i) {
      CKEDITOR.replace(data[i].id)
    });
  }
});

function formatMoney(number) {
  return number.toLocaleString('it-IT', {
    style: 'currency',
    currency: 'VND'
  });
}
