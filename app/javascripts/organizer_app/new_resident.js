
OrganizerApp.AddResident = CommonPlace.View.extend({

  template: "organizer_app.new-resident",

  events: {
    "submit form#add-resident": "addResident"
  },

  addResident: function(e){
    e.preventDefault();
    var sectortags = document.getElementsByName('sector-tag');
    var sectorvalue = new Array();
    for(var i = 0; i < sectortags.length; i++){
      if(sectortags[i].checked)
         sectorvalue.push(sectortags[i].value);
    }
    var typetags = document.getElementsByName('type-tag');
    var typevalue = new Array();
    for(var i = 0; i < typetags.length; i++){
      if(typetags[i].checked)
         typevalue.push(typetags[i].value);
    }
    $.ajax({
	type: 'POST',
        contentType: "application/json",
	url: this.collection.url() + "/newresident",
	data: JSON.stringify({
                              first_name: this.$("#first-name").val(),
                              last_name: this.$("#last-name").val(),
                              email: this.$("#email").val(),
                              phone: this.$("#phone").val(),
                              organization: this.$("#organization").val(),
                              position: this.$("#position").val(),
                              notes: this.$("#notes").val(),
                              address: this.$("#address").val(),
                              sector_tags: sectorvalue,
                              type_tags:typevalue
        }),
	cache: 'false',
	success: function() { //this.show("Added");
        alert("Added. Refresh to see new residents");
      }
    });

    this.options.filePicker.render();
  },

  show: function(){
    //return this.filePicker.url();
    collection.each(function(model) {
      console.log(model.full_name());
    });
    //return this.collection.url();
    //return result;
    //return this.filepicker.reload();
  }

});
