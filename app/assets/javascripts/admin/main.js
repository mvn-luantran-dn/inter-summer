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
  CKEDITOR.config.height = 300;
  CKEDITOR.config.width = 1000;
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
// $(document).ready(function get_cat_id() {
//   // obj_click = event.target;
//   // id_click = parseInt(obj_click.options[obj_click.selectedIndex].value);
//   var arr_id = [];
//   var select_cat = $('.image-list').find('.select-cat');
//   $.each(select_cat, function (_index, value) {
//     arr_id.push(parseInt(value.options[value.selectedIndex].value));
//   });
//   // var index = arr_id.indexOf(id_click);
//   // if (index > -1) {
//   //   arr_id.splice(index, 1);
//   // }
//   return arr_id;
// })
$(document).ready(function () {
  $(".cat-pro").on("click", function () {
    var arr_id = [];
    var select_cat = $('.image-list').find('.select-cat');
    $.each(select_cat, function (_index, value) {
      arr_id.push(parseInt(value.options[value.selectedIndex].value));
    });
    arr_id = arr_id.filter(id => id > 0);
    arr_id = arr_id.join(',');
    $.ajax({
      data: { arr_id: arr_id}, 
      url: '/admin/category_pro?arr_id[]=' + arr_id,
      type: "GET",
      contentType: 'application/json; charset=utf-8',
      dataType: 'JSON',
      async: true,
      success: function (response) {
        var select_cat_last = $('.image-list').find('.select-cat').slice(-1)[0];
        var option = document.createElement("option");
        option.text = "Choose Category";
        option.value = "0";
        select_cat_last.options.length = 0;
        select_cat_last.append(option)
        $.each(response, function (_index, value) {
          var option = document.createElement("option");
          option.text = value['name'];
          option.value = value['id'];
          select_cat_last.append(option)
        })
      },
      error: function (err) {
        console.log(err);
      }
    });
  });

//   $(".select-cat").on("click", function () {
//     var obj_click = event.target;
//     var id_click = parseInt(obj_click.options[obj_click.selectedIndex].value);    
//     obj_click = $(obj_click);
//     obj_click.attr('id', 'selected'+ '_' + id_click);
//     var arr_id = [];
//     var select_cat = $('.image-list').find('.select-cat');
//     $.each(select_cat, function (_index, value) {
//       arr_id.push(parseInt(value.options[value.selectedIndex].value));
//     });
//     arr_id = arr_id.filter(id => id > 0);
//     var index = arr_id.indexOf(id_click);
//     if (index > -1) {
//       arr_id.splice(index, 1);
//     }
//     arr_id = arr_id.join(',');
//     $.ajax({
//       data: { arr_id: arr_id, id_click: id_click },
//       url: '/admin/category_pro?arr_id[]=' + arr_id,
//       type: "GET",
//       contentType: 'application/json; charset=utf-8',
//       dataType: 'JSON',
//       async: true,
//       success: function (response) {
//         select_cat_last = document.getElementById('selected_' + id_click);
//         select_cat_last.options.length = 0;
//         $.each(response, function (_index, value) {
//           var option = document.createElement("option");
//           option.text = value['name'];
//           option.value = value['id'];
//           select_cat_last.append(option)
//         })
//         select_cat_last = $(select_cat_last);
//         select_cat_last.val(id_click);
//       },
//       error: function (err) {
//         console.log(err);
//       }
//     });
//   });
});

function report_order() {
  result = null;
  $.ajax({
    url: "/admin/report_order",
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
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#profile-img-tag').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
  $("#profile-img").change(function () {
    readURL(this);
  });
});

const capitalize = (s) => {
  if (typeof s !== 'string') return ''
  return s.charAt(0).toUpperCase() + s.slice(1)
}
