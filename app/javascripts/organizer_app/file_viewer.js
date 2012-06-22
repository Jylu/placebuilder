
OrganizerApp.FileViewer = CommonPlace.View.extend({

  //template: "organizer_app.file-viewer",
  template: "organizer_app.viewer",

  events: {
    "submit form#add-log": "addLog",
    "submit form#add-address": "addAddress",
    "submit form#add-email": "addEmail"
  },

  show: function(model) {
    this.model = model;
    this.render();
    this.$("#log-add").click($.proxy(function() {
      this.model.addLog();
    }, this));
    this.$("#log-date").datepicker();
    this.allactions();
  },

  ifuser: function() {
    return this.model.get("on_commonplace");
  },
  
  full_name: function() {
    var name = this.model.full_name();
    if (name === undefined) {
      return "No name";
    } else {
      return name;
    }
  },

  address: function() {
    var address = this.model.get('address');
    if (!address) {
      return "No address in our records";
    } else {
      return address;
    }
  },
  
  phone: function() {
    var phone = this.model.get('phone');
    if (!phone) {
      return "No phone in our records";
    } else {
      return phone;
    }
  },
  
  organization: function() {
    var organization = this.model.get('organization');
    if (!organization) {
      return "No organization in our records";
    } else {
      return organization;
    }
  },
  
  position: function() {
    var position = this.model.get('position');
    if (!position) {
      return "No position in our records";
    } else {
      return position;
    }
  },
  
  notes: function() {
    var notes = this.model.get('notes');
    if (!notes) {
      return "No notes in our records";
    } else {
      return notes;
    }
  },
  
  sector: function() {
    var sector = this.model.get('sector');
    if (!sector) {
      return "No sector in our records";
    } else {
      return sector;
    }
  },
  
  type: function() {
    var type = this.model.get('type');
    if (!type) {
      return "No type in our records";
    } else {
      return type;
    }
  },

  addAddress: function(e) {
    e.preventDefault();
    var address = this.$("#address-text").val();
    if (!address) {
      alert("Please enter a non-empty address.");
    } else {
      this.model.save({address: address}, {success: _.bind(this.render, this)});
      //location.reload();
    }
  },

  email: function() {
    var email = this.model.get('email');
    console.log(email);
    if (!email) {
      return "No email in our records";
    } else {
      return email;
    }
  },

  addEmail: function(e) {
    e.preventDefault();
    var email = this.$("#email-text").val();
    var atpos = email.indexOf("@");
    var dotpos = email.lastIndexOf(".");
    if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length) {
      alert("Please enter a valid email address.");
    } else {
      this.model.save({email: email}, {success: _.bind(this.render, this)});
      //this.model.addEmail({email: email}, {success: _.bind(this.render, this)});
      //location.reload();
    }
  },
  
  addLog: function(e) {
    e.preventDefault();
    console.log({
      date: $("#log-date").val(),
      text: $("#log-text").val(),
    });
    this.model.addLog({ 
      date: $("#log-date").val(),
      text: $("#log-text").val(),
      //TODO: include tags. They are checkboxes and not CSVs now
      /*tags: _.map(this.$("#log-").val().split(","), $.trim)*/
    }, _.bind(this.render,this));
  },

  logs: function() {
    var logs = this.model.get('logs');
    if (logs) {
      return logs
    } else {
      return "No logs in our records yet.";
    }
  },

  tags: function() { 
    var tags = this.model.get('tags');
    if (tags) {
      return tags
    } else {
      return "No tags in our records yet.";
    }
  },
  
  allactions: function() {
    //this.$("#action-count").empty();
    //this.$("#action-count").append("<p>here</p>");
    if(!this.model.get("on_commonplace")){
      this.$("#action-count").before("Not a user yet");
    }
    else{
      this.$("#content").attr("src",this.model.get("community_id")+"/"+this.model.get("id")+"/all"); 
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("id")+"/all\" target=\"content\" >All</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("id")+"/sitevisit\" target=\"content\" >Log In Time</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("id")+"/post\" target=\"content\" >Post</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("id")+"/announcement\" target=\"content\" >Announcement</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("id")+"/reply\" target=\"content\" >Reply</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("id")+"/event\" target=\"content\" >Event</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("id")+"/invite\" target=\"content\" >Invite</a>");
    }
    
  },

  possibleTags: function() { return possTags; }

});
