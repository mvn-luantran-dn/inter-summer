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
    timer = data.obj;
    step = timer['bid_step'];
    cat_timer = data.cat
    $('#spanCountDown').html(time_convert(timer.period));
    $('#product-price').html(formatMoney(timer.product_price_start));
    html = "";
    cat_timer.forEach(function (e) {
      html += '<div class="item-box">';
      html += '<h4>'+ e.product_name +'</h4>';
      html += '<div class="item-box-left">';
      html += '<a href="/auctions/'+ e.id +'"><img style="border-width:0px;", src="' + e.product_pictures[0].file.url  + '"></a>';
      html += '<div class="info_data timeout last_minute"></div>';
      html += '</div>';
      html += '<div class="item-box-right">';
      html += '<div class="timeout last_minute">' + time_convert(e.period) + '</div>';
      html += '<div class="current_bid right-product">'+ formatMoney(e.product_price_start) +'</div>';
      html += '<a class="buttons bidding small see_details" href="/auctions/' + e.id + '">Bid now</a>';
      html += '</div>';
      html += '</div>';
      html += '<hr>';
    });
    $('#cat-timer').html(html);
    auction.loadDefaultPriceInput(timer['product_price_start'], step);
    auction.refreshPage(timer['period']);
  },
  loadDefaultPriceInput: function (price, step) {
    if (price !== auction.current_price) {
      auction.current_price = price;
      auction.tmp_price = price;
      $('#price-input').val(formatMoney(price));
      auction.step = step;
      auction.eventAddBtnPrice(price, step);
    }
  },
  eventAddBtnPrice: function (price, step) {
    $('#sub-price').prop('disabled', true);
    $('#sub-price').on('click', function () {
      auction.tmp_price -= step;
      $('#price-input').val(formatMoney(auction.tmp_price));
      if (auction.tmp_price === auction.current_price) {
        $('#sub-price').prop('disabled', true);
      }
    });

    $('#plus-price').on('click', function () {
      auction.tmp_price += step;
      $('#price-input').val(formatMoney(auction.tmp_price));
      if (auction.tmp_price !== auction.current_price) {
        $('#plus-price').prop('disabled', false);
        $('#sub-price').prop('disabled', false);
      }
    });
  },
  eventSubmitPrice: function () {
    $('#ContentPlaceHolder1_btnBid').on('click', function () {
      if (auction.tmp_price === auction.current_price) {
        auction.tmp_price += auction.step;
      }
      if (auction.tmp_price > (auction.current_price + auction.step)) {
        auction.tmp_price = auction.current_price + auction.step;
      }
      data = {
        price: auction.tmp_price,
        user_id: auction.loadIdCurrentUser()
      };
      App.auction_detail.send(data);
    });
  },
  refreshPage: function (period) {
    if (period == 0) {
      $('#bid-final').html("");
      $('#user-winner').html("");
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

$(document).ready(function () {
  auction.eventSubmitPrice();
});
