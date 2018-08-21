var auction = {
  current_price: 0,
  tmp_price: 0,
  step: 0,
  connected :function() {
    swal.close();
  },
  disconnected :function(){
    swal(
      'Lost connection',
      'Please check again!',
      'warning'
    )
  },
  load_detail :function(data) {
    data = data.obj;
    step = data['bid_step']
    $('#spanCountDown').html(time_convert(data.period));
    $('#product-price').html(formatMoney(data.product_price_start));
  auction.loadDefaultPriceInput(data['product_price_start'], step);
  auction.refreshPage(data['period']);
  },
  loadDefaultPriceInput: function (price, step) {
    if (price !== auction.current_price) {
      auction.current_price = price;
      auction.tmp_price = price;
      $('#price-input').val(formatMoney(price));
      auction.eventAddBtnPrice(price, step);
      auction.step = step;
    }
  },
  eventAddBtnPrice: function (price, step) {
    $('#sub-price').prop('disabled', true);
    $('#sub-price').on('click', function () {
      auction.tmp_price -= step;
      $('#price-input').val(formatMoney(price));
      if (auction.tmp_price === auction.current_price) {
        $('#sub-price').prop('disabled', true);
      }
    });

    $('#plus-price').on('click', function () {
      auction.tmp_price += step;
      $('#price-input').val(formatMoney(price));
      if (auction.tmp_price !== auction.current_price) {
        $('#plus-price').prop('disabled', false);
      }
    });
  },
  eventSubmitPrice: function () {
    $('#bidding').on('click', function () {
      alert('123123');
    });
  },
  refreshPage: function (period) {
    if (period == 0) {
      $('.loadbid').children().remove();
      $('.user-win').html("");
    }
  },
  loadIdCurrentUser: function () {
    user_id = null;
    $.ajax({
      url: '/current_user',
      type: 'GET',
      contentType: 'application/json; charset=utf-8',
      dataType: 'JSON',
      async: false,
      success: function (response) {
        user_id = response;
      },
      error: function (err) {
        console.log(err);
      }
    });
    return user_id;
  }
}

$(document).on('turbolinks:load', function () {
});
