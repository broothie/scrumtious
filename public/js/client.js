/* js/client.js */

// Set focus to canvas so that keys are caught by KeyTrap
document.getElementById('stage').focus();

var myURL = location.protocol + '//' + document.domain + (location.port ? ':' + location.port : '');
var socket = io.connect(myURL);

socket.on('connect', function(){
    urlPathArray = document.location.pathname.split('/');
    if(urlPathArray[urlPathArray.length-2] == 'board'){
        fingerprint = urlPathArray[urlPathArray.length-1];
        socket.emit('handshake', fingerprint);
    }else{
        // TODO: Improve this error handling
        alert('URL is wrong');
    }
});

socket.on('initialize', function(payload){
    var pi = Processing.getInstanceById('sketch');
    document.title = payload.name + ' - Scrumtious Scrumboard';
});
