Parse.Cloud.beforeSave('Notification', function(request, response) {
  var currentUser = request.user;
  var objectUser = request.object.get('fromUser');

  if(!currentUser || !objectUser) {
    response.error('An Notification should have a valid fromUser.');
  } else if (currentUser.id === objectUser.id) {
    response.success();
  } else {
    response.error('Cannot set fromUser on Notification to a user other than the current user.');
  }
});

Parse.Cloud.afterSave('Notification', function(request) {
  // Only send push notifications for new activities
  if (request.object.existed()) {
    return;
  }

  var toUser = request.object.get("toUser");
  if (!toUser) {
    throw "Undefined toUser. Skipping push for Activity " + request.object.get('type') + " : " + request.object.id;
    return;
  }


  var query = new Parse.Query(Parse.Installation);
  query.equalTo('user', toUser);

  Parse.Push.send({
    where: query, // Set our Installation query.
    data: alertPayload(request)
  }).then(function() {
    // Push was successful
    console.log('Sent push.');
  }, function(error) {
    throw "Push Error " + error.code + " : " + error.message;
  });
});

var alertMessage = function(request) {
  var message = "";

  if (request.object.get("type") === "offerComment"  ) {
    if (request.user.get('username')) {
      message = request.user.get('username') + ' commented on your item: ' + request.object.get('content').trim();
    } else {
      message = "Someone commented on your item.";
    }
  }
   else if (request.object.get("type") === "like") {
    if (request.user.get('username')) {
      message = request.user.get('username') + ' likes your item.';
    } else {
      message = 'Someone likes your item.';
    }
  } else if (request.object.get("type") === "follow") {
    if (request.user.get('username')) {
      message = request.user.get('username') + ' is now following you.';
    } else {
      message = "You have a new follower.";
    }
  }else if (request.object.get("type") === "joinEvent") {
      if (request.user.get('username')) {
        message = request.user.get('username') + ' has joined your event.';
      } else {
        message = "Someone joined your event.";
      }
  }else if (request.object.get("type") === "makeOffer") {
	  if (request.user.get('username')) {
	    message = request.user.get('username') + ' bid on your item.';
      } else {
		message = "Someone bid on your item.";
	  }
  }  
  // Trim our message to 140 characters.
  if (message.length > 140) {
    message = message.substring(0, 140);
  }

  return message;
}

var alertPayload = function(request) {
  var payload = {};

  if (request.object.get("type") === "offerComment") {
    return {
      alert: alertMessage(request), // Set our alert message.
      badge: 'Increment', // Increment the target device's badge count.
      // The following keys help Anypic load the correct photo in response to this push notification.
	  sound: 'default',
      p: 'nf', // Payload Type: Activity
      t: 'co', // Activity Type: Comment offer
      fu: request.object.get('fromUser').id, // From User
      objId: request.object.id // Photo Id
  	  };
  	} else if (request.object.get("type") === "joinEvent") {
    return {
      alert: alertMessage(request), // Set our alert message.
      badge: 'Increment', // Increment the target device's badge count.
      // The following keys help Anypic load the correct photo in response to this push notification.
	  sound: 'default',
      p: 'nf', // Payload Type: Activity
      t: 'je', // Activity Type: join event
      fu: request.object.get('fromUser').id, // From User
      objId: request.object.id // Photo Id
      };
    }else if (request.object.get("type") === "makeOffer") {
      return {
        alert: alertMessage(request), // Set our alert message.
        badge: 'Increment', // Increment the target device's badge count.
        // The following keys help Anypic load the correct photo in response to this push notification.
  	    sound: 'default',
        p: 'nf', // Payload Type: Activity
        t: 'mo', // Activity Type: Like
        fu: request.object.get('fromUser').id, // From User
        objId: request.object.id // Photo Id
      };
    }else if (request.object.get("type") === "like") {
    return {
      alert: alertMessage(request), // Set our alert message.
      badge: 'Increment', // Increment the target device's badge count.
      // The following keys help Anypic load the correct photo in response to this push notification.
	  sound: 'default',
      p: 'nf', // Payload Type: Activity
      t: 'l', // Activity Type: Like
      fu: request.object.get('fromUser').id, // From User
      objId: request.object.id // Photo Id
    };
  } else if (request.object.get("type") === "follow") {
    return {
      alert: alertMessage(request), // Set our alert message.
      badge: 'Increment', // Increment the target device's badge count.	
      // The following keys help Anypic load the correct photo in response to this push notification.
  	  sound: 'default',
	  p: 'nf', // Payload Type: NotificationFeed
      t: 'f', // Activity Type: Follow
      fu: request.object.get('fromUser').id // From User
    };
  }
}
