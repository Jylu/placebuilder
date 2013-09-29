
var Ad = Model.extend({
  validate: function(attribs) {
    var missing = [];

    if(!attribs.body) { missing.push("body"); }
    if(missing.length > 0) {
      var responseText = "Please fill in the " + missing.shift();
      _.each(missing, function(field) {
        responseText = responseText + " and " + field;
      });
      var response = {
        status: 400,
        responseText: responseText + "."
      };

      return response;
    }
  }
})

var Ads = Collection.extend({ model: Ad });
