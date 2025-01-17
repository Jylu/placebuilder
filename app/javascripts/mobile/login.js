var LoginView = CommonPlace.View.extend({
    template: "mobile.login",
    id: "main",
    events: {
        "click a#register":"register",
        "submit form":"login"
    },

    register: function(e) {
                  e.preventDefault();
                  var registerView = new RegisterView();
                  registerView.render();
      $("#main").replaceWith(registerView.el);
              },

    login: function(e) {
                e.preventDefault();
                var email = $("#email").val();
                var password = $("#password").val();
                $.ajax({
                    type: "POST",
                    url: "/api/sessions",
                    contentType: "application/json",
                    data: JSON.stringify({ email: email, password: password }),
                    dataType: "json",
                    success: function(response) {
                        $.getJSON("/api/account", function(response) {
                            $("#message").hide();
                            window.account = response;
                            window.full_name = response.name;
                            get_recommendations();
                        });
                    },

                    error: function() {
                        $("#message").show();
                    }
                });
                return false;

    }

});


function get_recommendations() {
        var lat = null;
        var lng = null;
        if (geo_position_js.init()) {
            geo_position_js.getCurrentPosition(function(loc) {
                lat = loc.coords.latitude;
                lng = loc.coords.longitude;
                new Recommendations([]).fetch({
                    data: {
                              latitude: lat,
                              longitude: lng
                          },
                    success: function(recommendations) {
                                recommendationsView = new RecommendationsView({el:$('#main'),collection:recommendations});
                                recommendationsView.render();
                            }
                });
            });
        }



}
