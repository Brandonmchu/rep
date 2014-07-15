var geocoder;
var map;
var markers = [];

function initialize() {
  geocoder = new google.maps.Geocoder();
  var lat = 43.6452904;
  var lng = -79.3806998;
  var latlng = new google.maps.LatLng(lat,lng);
  var mapOptions = {
    zoom: 14,
    center: latlng,
    backgroundColor: "white",
    disableDefaultUI: true,
    streetViewControl: true,
    streetViewControlOptions: {
      position: google.maps.ControlPosition.TOP_LEFT
    },
    zoomControl: true,
    zoomControlOptions: {
      style: google.maps.ZoomControlStyle.SMALL,
      position: google.maps.ControlPosition.TOP_LEFT
    }
  }
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
}

// Sets the map on all markers in the array.
function setAllMap(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}

// Removes the markers from the map, but keeps them in the array.
function clearMarkers() {
  setAllMap(null);
}

// Shows any markers currently in the array.
function showMarkers() {
  setAllMap(map);
}

// Deletes all markers in the array by removing references to them.
function deleteMarkers() {
  clearMarkers();
  markers = [];
}

function codeAddress() {
  deleteMarkers();
  var address = document.getElementById("address").value;
  console.log(address)
  address = address + "Toronto, Ontario, Canada"

  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      $("#latitude").val(results[0].geometry.location.lat());
      $("#longitude").val(results[0].geometry.location.lng());
      $("#search-form").submit();
      map.setCenter(results[0].geometry.location);
      var marker = new google.maps.Marker({
          map: map,
          position: results[ 0].geometry.location,
          icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
      });
      markers.push(marker);
    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });
}



$(document).ready(function() 
    { 
      $("#distance-slider").slider({tooltip:'hide',orientation:'vertical'});
      $(".proximity-filter-inner").click(function(){
        if ($(".slider").css('display') == 'block'){
          $(".slider").css("display","none")
        } else{
          $(".slider").css("display","block")
        }
      })
      $("#distance-slider").on('slide', function(slideEvt) {
        $(".max-value").text(slideEvt.value);
        $("#proximity").val(slideEvt.value)
      });

      // $("#searchResults").tablesorter({sortList: [2,1]});
      initialize(); 

      $('#address').keypress(function (e) {
        if (e.which == 13) {
          codeAddress();
        } 
      });

      var text_input = $('.search-field');
      text_input.focus ();
      text_input.select ();
  
      // $('.dropdown-menu').click(function(event){
      //   event.stopPropagation();
      // });


      $('#datetimepicker1').datetimepicker();
      $('#datetimepicker2').datetimepicker();
      $("#datetimepicker1").on("dp.change",function (e) {
         $('#datetimepicker2').data("DateTimePicker").setMinDate(e.date);
         var date = new Date($(this).children("input").val());
         $(this).children(".filter-date").text(date.toDateString());
         $("#start_date").val(date);
         $("#search-form").submit();
      });
      $("#datetimepicker2").on("dp.change",function (e) {
         $('#datetimepicker1').data("DateTimePicker").setMaxDate(e.date);
         var date = new Date($(this).children("input").val());  
         $(this).children(".filter-date").text(date.toDateString());
         $("#end_date").val(date);
         $("#search-form").submit();
      });

      adjustSearchPostiion = function (){
        windowWidth = $('.search-block').width();
        var searchWidth = $('.search-bar-inner').width();
        var margin = (windowWidth - searchWidth) / 2
        $('.search-bar-inner').css('margin-left', margin)
        $('.search-bar-inner').css('margin-right', margin)  
      }

      adjustFilterPostiion = function (){
        var searchWidth = $('.search-bar-inner').width();
        var adjustment = (1/12 * searchWidth / 2)
        $('#datetimepicker1').parent().parent().css('margin-left',adjustment+'px');
        $('#datetimepicker2').parent().parent().css('margin-right',adjustment+'px');
      }

      // adjustProximityHeight = function (){
      //   var searchHeight = $('#address').height();
      //   $('.proximity-filter i').css('height',searchHeight+'px');
      // }

      adjustSearchPostiion();
      adjustFilterPostiion();
      // adjustProximityHeight();

      $(window).resize(function(){
        if ($(window).width() < 1000){
          adjustSearchPostiion();
          $('#datetimepicker1').parent().parent().css('margin-left','0px');
          $('#datetimepicker2').parent().parent().css('margin-right','0px');
        }
        else {
        adjustSearchPostiion();
        adjustFilterPostiion();
        // adjustProximityHeight();
        }
      })

    } 

); 