function openTab(evt, Tab) {
  var i, tabcontent, tablinks;
  tabcontent = document.getElementsByClassName("auction_list");
  for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
      tablinks[i].className = tablinks[i].className.replace(" active", "");
  }
  document.getElementById(Tab).style.display = "table";
  evt.currentTarget.className += " active";
}
