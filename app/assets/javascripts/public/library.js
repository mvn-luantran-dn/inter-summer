function time_convert(num) {
  var sec_num = parseInt(num, 10);
  var hours = Math.floor(sec_num / 3600);
  var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
  var seconds = sec_num - (hours * 3600) - (minutes * 60);

  if (hours < 10) {
    hours = "0" + hours;
  }
  if (minutes < 10) {
    minutes = "0" + minutes;
  }
  if (seconds < 10) {
    seconds = "0" + seconds;
  }
  if (hours == 0) return minutes + ':' + seconds;
  return hours + ':' + minutes + ':' + seconds;
}

function formatMoney(number) {
  return number.toLocaleString('it-IT', {
    style: 'currency',
    currency: 'VND'
  });
}

function addEventChangeStatus(user_id) {
  $('#change-status').on('click', function () {
    $('#quantity-notify').hide();
    $.ajax({
      url: "/change/" + user_id,
      type: 'GET',
      contentType: 'application/json; charset=utf-8',
      dataType: 'JSON',
      async: false,
      success: function (response) {
        console.log(response);
      },
      error: function (err) {
        console.log(err);
      }
    });
  });
}
