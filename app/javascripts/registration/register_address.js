var RegisterAddressView = RegistrationModalPage.extend({
  template: "registration.home_address",

  events: {
    "click input.continue": "submit",
    "submit form": "submit",
    "click .next-button": "submit"
  },

  afterRender: function() {
    this.hasAvatarFile = false;
    this.initReferralQuestions();

    if (!this.current) {
      this.slideIn(this.el);
      this.current = true;
    }

    var url = '/api/communities/'+this.communityExterior.id+'/address_completions'
    this.$("input[name=street_address]").autocomplete({ source: url , minLength: 2 });
  },

  community_name: function() { return this.communityExterior.name; },

  user_name: function() {
    return (this.data.full_name) ? this.data.full_name.split(" ")[0] : "";
  },

  submit: function(e) {
    if (e) { e.preventDefault(); }
    this.$(".error").hide();

    this.data.address = this.$("input[name=street_address]").val()

    this.data.referral_source = this.$("select[name=referral_source]").val();
    this.data.referral_metadata = this.$("input[name=referral_metadata]").val();

    //verify address
    this.nextPage("profile", this.data);
  },

  referrers: function() { return this.communityExterior.referral_sources; },

  initAvatarUploader: function($el) {
    var self = this;
    this.avatarUploader = new AjaxUpload($el, {
      action: "/api" + this.communityExterior.links.registration.avatar,
      name: 'avatar',
      data: { },
      responseType: 'json',
      autoSubmit: false,
      onChange: function() { self.toggleAvatar(); },
      onSubmit: function(file, extension) {},
      onComplete: function(file, response) {
        CommonPlace.account.set(response);
        self.nextPage("crop", this.data);
      }
    });
  },

  initReferralQuestions: function() {
    this.$("select[name=referral_source]").bind("change", _.bind(function() {
      var question = {
        "At a table or booth at an event": "What was the event?",
        "In an email": "Who was the email from?",
        "On Facebook or Twitter": "From what person or organization?",
        "On another website": "What website?",
        "In the news": "From which news source?",
        "Word of mouth": "From what person or organization?",
        "Flyer from a business or organization": "Which business or organization?",
        "Other": "Where?"
      }[this.$("select[name=referral_source] option:selected").val()];
      if (question) {
        this.$(".referral_metadata_li").show();
        this.$(".referral_metadata_li label").html(question);
      } else {
        this.$(".referral_metadata_li").hide();
      }
    }, this));
  },

});
