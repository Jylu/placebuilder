var MessageFormView = FormView.extend({
  template: "shared/message-form",
  goToInbox: true,
  beforeCreate: undefined,

  save: function(callback) {
    var self = this;
    var oldHTML = this.$(".controls").html();
    this.$(".controls button").replaceWith("<img src='/assets/loading.gif' />");
    if (this.beforeCreate !== undefined) this.beforeCreate();
    console.log(this.model);
    this.model.save({
      subject: this.$("[name=subject]").val(),
      body: this.$("[name=body]").val()
    }, {
      wait: true,
      success: function(model, response) {
        this.$(".controls").html(oldHTML);
        callback();
        if (self.goToInbox) {
          window.location = '/' + CommonPlace.community.get("slug") + '/inbox#' + response;
        }
      },
      error: function(attribs, response) {
        this.$(".controls").html(oldHTML);
        self.showError(response);
      }
    });
  },
  
  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  name: function() {
    return this.model.name();
  }
});

var MessageFormViewUnaddressed = MessageFormView.extend({
  template: "shared/message-form-unaddressed",
  events: {
    "click #cancel-recipient": "cancelRecipient",
    "click form a.cancel": "exit",
    "submit form": "send"
  },

  beforeCreate: function() {
    this.model = new Message({ messagable: this.selectedUser() });
  },

  postRender: function() {
    var self = this;
    this.$("#recipient").tokenInput('/api' + CommonPlace.community.get("links")['users'],
      {
        queryParam: "query",
        propertyToSearch: "name",
        theme: 'facebook',
        resultsFormatter: function(item) {
          result = "<li>" + item.name + "</li>";
          return result;
        },
        onAdd: function(item) {
          if (self.$("#recipient").tokenInput("get").length > 1)
            self.$("#recipient").tokenInput("remove", { id: item.id });
          self.$("#recipient-selector").hide();
          self.$("#recipient-name").html(item.name);
          self.$("#recipient-viewer").show();
        },
        spawnListFrom: this.$("#recipient-selector"),
        hintText: "Type the name of then neighbor you would like to message"
      });
  },

  cancelRecipient: function() {
    this.$("#recipient").tokenInput("remove", { id: this.$("#recipient").tokenInput("get")[0].id});
    this.$("#recipient-name").html('');
    this.$("#recipient-viewer").hide();
    this.$("#recipient-selector").show();
  },

  selectedUser: function() {
    var user_id = this.$("#recipient").tokenInput("get")[0].id;
    return new User({
      links: {
        self: "/users/" + user_id,
        messages: "/users/" + user_id + "/messages"
      }
    });
  }

});

