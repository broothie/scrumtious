/* js/client.js */

// Set focus to canvas so that keys are caught by KeyTrap
document.getElementById('stage').focus();

var myURL = location.protocol + '//' + document.domain + (location.port ? ':' + location.port : '');
var socket = io.connect(myURL);

socket.on('connect', function(){
    urlPathArray = document.location.pathname.split('/');
    fingerprint = urlPathArray[urlPathArray.length-1];
    socket.emit('HANDSHAKE', fingerprint);
});

socket.on('INITIALIZE', function(payload){
    // TODO: Switch to Angular.js because Processing is annoying
    // var pi = Processing.getInstanceById('sketch');
    document.title = payload.boardname + ' - Scrumtious Scrumboard';
});

// socket.on('CLIENT_UPDATE', function(payload){
//     // TODO: socket.emit('SERVER_UPDATE', {})
// });

socket.on('disconnect', function(){
    // TODO: Emit final state
    // socket.emit('BOARD_CLOSE', fingerprint)
});
