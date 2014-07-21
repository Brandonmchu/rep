var geocoder;
var map;
var markers = [];

function initialize() {
  geocoder = new google.maps.Geocoder();
  var lat = 43.6452904;
  var lng = -79.3806998;
  var latlng = new google.maps.LatLng(lat,lng);
  var mapOptions = {
    zoom: 15,
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

function overlay() {
  var el = document.getElementById("modal_overlay");
  el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
  var subscribe = $('.subscribe').get(0);
  subscribe.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
}


function subscribe(){
  email = document.getElementById("email").value;
  loi = document.getElementById("loi").value;
  if(email==""){
    alert("I can't send updates if there's no email address!");
  } else if (loi==""){
    alert("Where do you want updates for?");
  } else {

    $.ajax({
      type: 'POST',
      url: '/users',
      data: {'email':email,'locations_of_interest':loi},
      success: function(data,textStatus,jqXHR){
          $(".modal_content").hide();
          $(".modal_email_subscription h4").hide();
          $(".modal_email_subscription h2").html(data)
          el = document.getElementById("modal_overlay");
          var subscribe = $('.subscribe').get(0);
          setTimeout(function(){
            el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
            subscribe.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
          },1000);
        }
    });
  }
}

$(document).ready(function() 
    { 
      initialize();
      codeAddress();

      var proximityFilter = $(".proximity-filter");

      $("#distance-slider").slider({tooltip:'hide'});
      proximityFilter.click(function(){
        if ($("#slider-dropdown").css('display') == 'block'){
          $("#slider-dropdown").css("display","none")
          $(this).css("border-bottom-right-radius","$search-border-radius")
        } else{
          $("#slider-dropdown").css("display","block")
          $(this).css("border-bottom-right-radius","0px")
        }
      })
      $("#distance-slider").on('slide', function(slideEvt) {
        $(".max-value").text(slideEvt.value);
        $("#proximity").val(slideEvt.value)
          $.doTimeout( 'slide', 500, function(){
            codeAddress();
          });
          
      });

      $(document).click(function(event){
        var target = $(event.target);
        if (target.is("span") || target.is(".proximity-filter") || target.is(".proximity-filter-inner") || target.is(".slider div")){
          console.log("BOOYA");
        } else{
          if (proximityFilter.css("display") != "none"){
            $("#slider-dropdown").css("display","none");
          }
        }
      });

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
      
      $('.modal_email_subscription').click(function(event){
        event.stopPropagation();
      });

      $('#datetimepicker1').datetimepicker({
        pickTime: false
      });
      $('#datetimepicker2').datetimepicker({
        pickTime: false
      });
      $("#datetimepicker1").on("dp.change",function (e) {
         $('#datetimepicker2').data("DateTimePicker").setMinDate(e.date);
         var date = new Date($(this).children("input").val());
         $(this).children(".filter-date").text(date.toDateString());
         $("#start_date").val(date);
         codeAddress();
      });
      $("#datetimepicker2").on("dp.change",function (e) {
         $('#datetimepicker1').data("DateTimePicker").setMaxDate(e.date);
         var date = new Date($(this).children("input").val());  
         $(this).children(".filter-date").text(date.toDateString());
         $("#end_date").val(date);
         codeAddress();
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

      adjustProximityFilter = function (){
        var proximityWidth = $('.proximity-filter').outerWidth();
        var proximityHeight = $('.proximity-filter').outerHeight();
        var proximityPositionLeft = $('.proximity-filter').offset().left;
        var proximityPositionTop = $('.proximity-filter').offset().top;
        var topAdjustment = proximityPositionTop + proximityHeight
        $('#slider-dropdown').css('width',proximityWidth+'px');
        $('#slider-dropdown').css('left',proximityPositionLeft+'px');
        $('#slider-dropdown').css('top',topAdjustment+'px');
      }


      adjustSearchPostiion();
      adjustFilterPostiion();
      adjustProximityFilter();

      $(window).resize(function(){
        if ($(window).width() < 1000){
          adjustSearchPostiion();
          adjustProximityFilter();
          //special case for datetime responsive
          $('#datetimepicker1').parent().parent().css('margin-left','0px');
          $('#datetimepicker2').parent().parent().css('margin-right','0px');
        }
        else {
        adjustSearchPostiion();
        adjustFilterPostiion();
        adjustProximityFilter();
        }
      })



    // hide it first
    $("#topper").hide();

    // when an ajax request starts, show topper
    $(document).ajaxStart(function(){
        $("#topper").show();
    });

    // when an ajax request complets, hide topper    
    $(document).ajaxStop(function(){
        $("#topper").hide();
    });
  }



); 