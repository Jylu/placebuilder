
OrganizerApp.Main = Backbone.View.extend({

  initialize: function() {
    this.page = 1;
    this.fileViewer = new OrganizerApp.FileViewer({ el: this.$("#file-viewer") });

    this.filePicker = new OrganizerApp.FilePicker({ 
      el: this.$("#file-picker"),
      collection: this.collection,
      fileViewer: this.fileViewer,
      community: this.options.community
    });
  },


  render: function() {
    var params = {
      "page": this.page
    };
    this.collection.fetch({ 
      data: params,
      success: _.bind(function() {
        _.invoke([this.filePicker], "render");
      }, this)
    });
  }

});
