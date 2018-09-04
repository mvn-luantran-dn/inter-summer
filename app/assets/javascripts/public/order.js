$(document).on('turbolinks:load', function(){
  $('#myModal').on('show.bs.modal', function (e) {
      var getname = $('#field-name').val();
      var number = $('#field-phone').val()
      var getaddress = $('#field-address').val();

      //Pass Values
      $('#Name').html(getname);
      $('#Phone').html(number);
      $('#Address').html(getaddress);
  });
});
