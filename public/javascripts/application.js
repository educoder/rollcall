
$(document).ready(function(){ 
  $('.listing').each(function() {
    if ($(this).has('li.groupable').length > 0) {
      $(this).addClass('clickable')
    }
  })
  
  $('.groupable').draggable({
    revert: 'invalid', 
    helper: 'clone'
  })
  
  $('.group').droppable({
    hoverClass: 'dropping',
    drop: function(event, ui) {
      $(ui.helper).effect('drop')
    }
  })
  
  $('.listing').click(function() {
    if ($(this).has('li').length > 0) {
      $(this).children('.groupables').slideToggle('fast')
    }
  })
})



/** XMPP test stuff **/


function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

/**
* Extract the 'token' parameter from the URL.
* Connect to RollCall, authenticate user, and get user info
*/
function authenticate(){
    var userToken = getUrlVars()['token'];
    if (!userToken){
        alert('Error: no user token provided');
    }

    $.ajax({
        url: 'http://rollcall.proto.encorelab.org/sessions/validate_token.json',
        dataType: 'jsonp',
        data: {
            _method: 'GET',
            token: userToken
        },
        success: function(data) {
            if (data.error)
                alert("ERROR: "+data.error)
            else
                $('#welcomeHeader').html('Welcome '+data.session.user.display_name);
        }
    });
}






//bosh_server = 'http://bosh.metajack.im:5280/xmpp-httpbind';
bosh_server = 'http://cms/http-bind';

room_name = 's12';
room_subdomain = 'conference';

//username = 'mzukowski';
//password = 'testtest';

strophe = null;

function connect_to_xmpp(){
    // Create connection object
    //strophe = new Strophe.Connection('http://cms/http-bind/');
    strophe = new Strophe.Connection(bosh_server);

    // Setup debugging listeners and handlers
    strophe.xmlInput = function(data) {
        console.log("XMLInput:");
        console.log($(data).children()[0]);
        //console.log(data);
    };
    strophe.xmlOutput = function(data) {
        console.log("XMLOutput:");
        console.log(data);
    };

    //strophe.addHandler(onStanza, null, null);
    //strophe.addHandler(onPresence, null, "presence");
    strophe.addHandler(onGroupchat, null, "message", "groupchat");
    //strophe.addHandler(onGroupchat, null, "message");

    console.log('CONNECTING WITH: '+username+'/'+password);
    strophe.connect(username, password, onConnect);
}

function onConnect(status) {
    if (status === Strophe.Status.CONNECTED) {
        console.log('CONNECTED to '+bosh_server);
        onConnectionSuccessful();
    } else if (status === Strophe.Status.DISCONNECTED) {
        console.log('DISCONNECTED from '+bosh_server);
    } else if (status === Strophe.Status.CONNECTING) {
        console.log('CONNECTING to '+bosh_server);
    }
}

function disconnect_from_xmpp(){
    strophe.disconnect();
}

function onConnectionSuccessful(){
    var domain = Strophe.getDomainFromJid(strophe.jid);
    s3room = room_name+"@"+room_subdomain+"."+domain;
    console.log('ROOM: '+s3room);

    //announcePresence();
}

function announceAway(){
    pres = $pres({type: "unavailable"});

    strophe.send(pres.tree());

    console.log('SET STAUS TO AWAY');
}

function announcePresence(){
    pres = $pres({to: s3room+"/"+username}).c('x', {xmlns: 'http://jabber.org/protocol/muc'})
    
    strophe.send(pres.tree());
}

function onPresence(pres) {
    console.log('Detected Presence');
    console.log(pres);
}

function onGroupchat(pres) {
    console.log('Detected Group Chat');
    console.log(pres);
}

function onStanza(stanza){
    console.log('Detected Stanza');
    console.log(stanza);

    var message = $(stanza);
    var messageContent = message.find('html body').html();
    $(document).append(messageContent);

    return true;
}