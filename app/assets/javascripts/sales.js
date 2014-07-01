var geocoder;
var map;
function initialize() {
  geocoder = new google.maps.Geocoder();
  // var lat = document.getElementById("init_lat").value;
  // var lng = document.getElementById("init_lng").value;
  // var latlng = new google.maps.LatLng(lat,lng);
  // var mapOptions = {
  //   zoom: 12,
  //   center: latlng
  // }
  // map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
}

function codeAddress() {
  var address = document.getElementById("address").value;
  console.log(address)
  address = address + "Toronto, Ontario, Canada"
  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      $("#latitude").val(results[0].geometry.location.k);
      $("#longitude").val(results[0].geometry.location.A);
      // $("#last_address").val(address)
      $("#search-form").submit();
      // map.setCenter(results[0].geometry.location);
      // var marker = new google.maps.Marker({
      //     map: map,
      //     position: results[ 0].geometry.location
      // });
    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });
}




// function localFilter(distance) {
//   $('#yelp_results .yelp-row .yelp-row-dist').each(function(){
//     if (distance*1000 < $(this).text()){
//       $(this).parent().hide();
//     }
//     else {
//       $(this).parent().show();
//     }
//   })

// }

// $( document ).ready(function() {
  

//   $("#yelp_results").tablesorter();
// });


$(document).ready(function() 
    { 
      $("#distance-slider").slider();
      $("#distance-slider").on('slide', function(slideEvt) {
        $("#max-value").text(slideEvt.value);
        $("#proximity").val(slideEvt.value)
      });

      $("#searchResults").tablesorter({sortList: [2,1]});
      initialize(); 

      $('#address').keypress(function (e) {
        if (e.which == 13) {
          codeAddress();
        } 
      });
    } 
); 