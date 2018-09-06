$(document).ready(function () {
  $('#myModal').on('show.bs.modal', function (e) {
      var getname = $('#field-name').val();
      var number = $('#field-phone').val()
      var getaddress = $('#field-address').val();

      //Pass Values
      $('#Name').html(getname);
      $('#Phone').html(number);
      $('#Address').html(getaddress);
  });
  $('#hover-cash-on-delivery').click(function(){
    console.log('1')
    $('#order_type_payment_cash_on_delivery').prop('checked', true);
  });
  $('#hover-ngan-luong').click(function(){
    console.log(2)
    $('#order_type_payment_ngan_luong').prop('checked', true);
  });
});
