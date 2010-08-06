
function selectTab(tab) {
  $(document).ready(function(){
    $('header #' + tab).addClass('selected_nav');
  });
};

function setInfoBox() {
   $.getJSON(this.path.slice(1), function(response) {
    $("#info").html(response.info_box).css("top", 
        Math.max(0, $(window).scrollTop() - $("#list").offset().top));
  });
} 

function setList() {
  $.getJSON(this.path.slice(1), function(response) {
    $("#list").html(response.list);
  });
}

var app = $.sammy(function() { 

  this.post("/posts", function() {
    $.post(this.path, this.params, function(response) {
      $("#new_post").replaceWith(response.newPost);
      $("#new_post textarea").goodlabel();
      if (response.success) {
        $('#both_columns ul').prepend(response.createdPost);
      } else {
        alert("post validation failed");
      }
    }, "json");
  });
  
  this.post("/posts/:post_id/replies", function() {
    var $post = $("#post_" + this.params['post_id']);
    var sammy = this;
    
    $.post(this.path, this.params, function(response) {
      $("form.new_reply", $post).replaceWith(response.newReply);
      $("form.new_reply textarea", $post).goodlabel();
      if (response.success) {
        $(".replies ol", $post).append(response.createdReply);
      } else {
        alert("reply validation failed");
      }
    }, "json");
  });

  this.get("#/posts/new", function() {
    var sammy = this;
    $.getJSON('/posts/new', function(response) {      
      $(response.form).modal({
        overlayClose: true,
        onClose: function() { 
          $.modal.close(); 
          sammy.redirect("#", "posts");
        }
      });
    });
  });

  this.get("#/announcements/new", function() {
    var sammy = this;
    $.getJSON('/announcements/new', function(response) {
      $(response.form).modal({
        overlayClose: true,
        onClose: function() { 
          $.modal.close(); 
          sammy.redirect("#", "announcements");
        }
      });
    });
  });

  this.get("#/events/new", function() {
    var sammy = this;
    $.getJSON('/events/new', function(response) {
      $(response.form).modal({
        overlayClose: true,
        onClose: function() { 
          $.modal.close(); 
          sammy.redirect("#", "events");
        }
      });
    });
  });
        

  this.get("#/posts/:id", setInfoBox);
  this.get("#/events/:id", setInfoBox);
  this.get("#/announcements/:id", setInfoBox);
  
  this.get("#/announcements", setList);
  this.get("#/events", setList);
  this.get("#/", setList);
  this.get("#/users", setList);
  this.get("#/organizations", setList);
  this.get("#/posts", setList);

});

$(function(){
  app.run();
  
  $('a[data-remote]').click(function(e) {
    app.location_proxy.setLocation("#" + $(this).attr('href'));
    e.preventDefault()
  });
                            

  $(document).bind('scrollup',function(){
    $("#info").animate({top: Math.max(0, $(window).scrollTop() - $("#list").offset().top)});
  });
  
  $('textarea').autoResize({animateDuration: 50, extraSpace: 5});
  
  $('.filter').tipsy({ gravity: 's', delayOut: 0 });
 
});
