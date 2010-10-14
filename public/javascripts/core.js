Sammy.CPLocationProxy = function(app) {
  this.app = app
};
Sammy.CPLocationProxy.prototype = {
  bind: function () {},
  unbind: function() {},
  getLocation: function() {
    var matches = window.location.toString().match(/^[^#]*(#.+)$/);
    return matches ? matches[1] : '';
  },
  setLocation: function(new_location) {
      return (window.location = new_location);
  }
}

$(function() {
  jQuery.extend({
    put: function(url, data, callback, type) {
      return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
      return _ajax_request(url, data, callback, type, 'DELETE');
    }
  });

  $('a[data-remote]').live('click', function(e) {
    $.sammy("body").setLocation("#" + $(this).attr('href'));
    $.sammy("body").runRoute("get", "#" + $(this).attr('href'));
    e.preventDefault()
  });

  $('textarea').autoResize({animateDuration: 50, extraSpace: 5});

  $('#org_url').textTruncate(140);

  $(window).bind('resize.modal', function () {
    var $m = $("#modal"),
    w = $m.width(),
    h = $m.height(),
    $b = $(window),
    bw = $b.width(),
    bh = $b.height();
    
    $m.css({top: (bh - h) / 2,
            left: (bw - w) / 2,
           });
  });
  $(window).trigger('resize.modal');

});

function setModal() {
  $.getJSON(this.path.slice(1), function(response) {
    $(response.form).modal({
      overlayClose: true,
      onClose: function() { 
        $.modal.close(); 
      }
    });
  });
}

function setTooltip(text, class) {
  $("#tooltip").html(text).attr("class", class);
}

function renderMaps() {
  $('div[data-map]').each(function() {
    var args = $.parseJSON($(this).attr('data-map'))
    if (args && args.center) {
      var map = new google.maps.Map(this, {
        zoom: 15,
        center: jsonToLatLng(args.center),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        navigationControl: true,
        mapTypeControl: false,
        scaleControl: true
      });
      $(this).data('map', map);
      $.each(args.markers, function() {renderMarker(this,map)});
      $.each(args.polygons, function() {renderPolygon(this,map)});
      $.each(args.directions, function() {renderDirections(this,map)});
    }
  });
}

function renderMarker(args,map) {
  new google.maps.Marker({
    position: jsonToLatLng(args.position),
    map: map
  });
}

function jsonToLatLng(args) {
  return new google.maps.LatLng(args.lat,args.lng);
}

function renderPolygon(args,map) {
  var path = $.map(args.vertices, jsonToLatLng),
  neighborhood = new google.maps.Polygon({
    paths: path,
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#0000FF",
        fillOpacity: 0.35
  });
  neighborhood.setMap(map);
}
function renderDirections(args,map) {
  var directionsService = new google.maps.DirectionsService(),
  directionsDisplay = new google.maps.DirectionsRenderer({ 
    suppressMarkers: true
  }),
  directionsRequest = {
    origin: jsonToLatLng(args.origin),
    destination: jsonToLatLng(args.destination),
    travelMode: google.maps.DirectionsTravelMode.WALKING
  };
  directionsDisplay.setMap(map);
  directionsService.route(directionsRequest, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(result);
    }
  });
}
      
function _ajax_request(url, data, callback, type, method) {
  if (jQuery.isFunction(data)) {
    callback = data;
    data = {};
  }
  return jQuery.ajax({
    type: method,
    url: url,
    data: data,
    success: callback,
    dataType: type
  });
}


function setInfoBoxPosition() {
  if ($(window).scrollTop() + 10 > $('#information').offset().top){
    $('.info_box').css('position','fixed');
  } else {
    $('.info_box').css('position', 'static');
  }
}

function selectTab(tab) {
  $(document).ready(function(){
    $('header #' + tab).addClass('selected_nav');
  });
};

function setInfoBox() {
  $.getJSON(this.path.slice(1), function(response) {
    $("#information").html(response.info_box);
    setInfoBoxPosition();
    renderMaps();
  });
} 

function setList() {
  $.getJSON(this.path.slice(1), function(response) {
    $("#list").html(response.list);
    $("#add").replaceWith(response.add);
    $("#info").html(response.info);
  });
}

function merge(html, context) {
  $(html).each(function () { 
    if (this) {
      $("#" + this.id, context).replaceWith(this.outerHTML);
    }
    if (this.id == "modal") {
      $(window).trigger('resize.modal');
    }
    
  });
}