var RegisterNewUserView = RegistrationModalPage.extend({
  template: "registration.new",
  facebookTemplate: "registration.facebook",
  
  events: {
    "click a.show-video": "showVideo",
    "click input.sign_up": "submit",
    "submit form": "submit",
    "click img.facebook": "facebook"
  },
  
  afterRender: function() {
    if (!this.current) {
      this.slideIn(this.el);
      this.current = true;
    }
    
    this.$("input[placeholder]").placeholder();
    
    if (this.data.isFacebook) {
      this.$("input[name=full_name]").val(this.data.full_name);
      if (this.isRealEmail()) { this.$("input[name=email]").val(this.data.email); }
    }
    var domains = ["hotmail.com", "gmail.com", "aol.com", "yahoo.com"];

    this.$("input#email").blur(function() {
      $("input#email").mailcheck(domains, {
      suggested: function(element, suggestion) {
        $(".error.email").html("Did you mean " + suggestion.full + "?");
        $(".error.email").show();
        $(".error.email").click(function(e) {
          $(element).val(suggestion.full);
        });
      },
      empty: function(element) {
        $(".error.email").hide();
      }
    });
    });

    var url = '/api/communities/'+this.communityExterior.id+'/address_completions'
    this.$("input[name=street_address]").autocomplete({ source: url , minLength: 2 });

  },
  
  community_name: function() { return this.communityExterior.name; },
  learn_more: function() { return this.communityExterior.links.learn_more; },
  created_at: function() { return this.communityExterior.statistics.created_at; },
  neighbors: function() { return this.communityExterior.statistics.neighbors; },
  feeds: function() { return this.communityExterior.statistics.feeds; },
  postlikes: function() { return this.communityExterior.statistics.postlikes; },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    this.data.full_name = this.$("input[name=full_name]").val();
    this.data.email = this.$("input[name=email]").val();
    this.data.password = this.$("input[name=password]").val();

    params = ["full_name", "email"];
    this.validate_registration(params, _.bind(function() {
      this.nextPage("address", this.data);
    },this));
  },
  
  facebook: function(e) {
    if (e) { e.preventDefault(); }
    
    facebook_connect_registration({
      success: _.bind(function(data) {
        this.data = data;
        this.data.isFacebook = true;
        this.template = this.facebookTemplate;
        this.render();
      }, this)
    });
  },
  
  isRealEmail: function() {
    if (!this.data || !this.data.email) { return false; }
    return this.data.email.search("proxymail") == -1;
  },
  
  showVideo: function(e) {
    if (e) { e.preventDefault(); }
    var video = this.make("iframe", {
      width: 330,
      height: 215,
      src: "http://www.youtube.com/embed/3GIydXPH3Eo?autoplay=1",
      frameborder: 0,
      allowfullscreen: true
    });
    this.$("div.show-video-con").replaceWith(video);
  }
});
