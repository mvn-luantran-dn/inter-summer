var auction = {
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
    $('#spanCountDown').html(time_convert(data.period));
    $('#product-price').html(formatMoney(data.product_price_start));
  }
}

$(document).on('turbolinks:load', function () {
});
