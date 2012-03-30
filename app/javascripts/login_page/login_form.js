
var LoginForm = Backbone.View.extend({

  INVALID_LOGIN_FIRST_ERROR_MESSAGE: "Your username or password is incorrect.",
  INVALID_LOGIN_SECOND_ERROR_MESSAGE: "Your login is still invalid. Did you <a href='/users/password/new'>forget your password?</a>",
  NO_EMAIL_ERROR_MESSAGE: "No email",
  NO_PASSWORD_ERROR_MESSAGE: "No password",

  failed_login_count: 0,

  events: {
    "click input.submit": "login",
    "submit form": "login"
  },

  login: function(e) {
    if (e) { e.preventDefault(); }

    var email = this.$("input[name=email]").val();
    var password = this.$("input[name=password]").val();

    if (!email) {
      this.$(".notice").append(this.NO_EMAIL_ERROR_MESSAGE);
      this.$("label[name=email]").addClass("error");
      return;
    }

    if (!password) {
      this.$(".notice").append(this.NO_PASSWORD_ERROR_MESSAGE);
      this.$("label[name=password]").addClass("error");
      return;
    }

    $.postJSON({
      url: "/api/sessions",
      data: {
        email: email, password: password
      },
      success: function() {
        window.location = "/users/sign_in";
      },
      error: _.bind(function() {
        this.failed_login_count += 1;
        if (this.failed_login_count == 1) {
          this.$(".notice").html(this.INVALID_LOGIN_FIRST_ERROR_MESSAGE);
        } else if (this.failed_login_count > 1) {
          this.$(".notice").html(this.INVALID_LOGIN_SECOND_ERROR_MESSAGE);
        }
        this.$(".notice").addClass("error");
        this.$(".notice").show();
      }, this)
    });
  }

});
