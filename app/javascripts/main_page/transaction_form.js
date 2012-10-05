
var TransactionForm = CommonPlace.View.extend({
  template: "main_page.forms.transaction-form",
  tagName: "form",
  className: "create-transaction transaction",

  events: {
    "click button": "createTransaction",
    "keydown textarea": "resetLayout",
    "focusout input, textarea": "onFormBlur"
  },

  afterRender: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    var self = this;
  },

  createTransaction: function(e) {
    e.preventDefault();

    this.$("button").hide();
    this.$(".spinner").show();

    var self = this;
    this.cleanUpPlaceholders();

    var n = this.$("[name=price]").val();
    var price = Number(n.replace(/[^0-9\.]+/g, "") * 100).toFixed(2);

    CommonPlace.community.transactions.create({ // use $.fn.serialize here
      title:   this.$("[name=title]").val(),
      price: price,
      body: this.$("[name=body]").val()
    }, {
      success: function() {
        CommonPlace.community.transactions.trigger("sync");
        self.render();
      },
      error: function(attribs, response) {
        self.$("button").show();
        self.$(".spinner").hide();
        self.showError(response);
      }
    });
  },

  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  groups: function() {
    return CommonPlace.community.get('groups');
  },

  resetLayout: function() { CommonPlace.layout.reset(); },

  onFormBlur: function(e) {
    if (!$(e.target).val() || $(e.target).val() == $(e.target).attr("placeholder")) {
      $(e.target).removeClass("filled");
    } else {
      $(e.target).addClass("filled");
    }
  }
});
