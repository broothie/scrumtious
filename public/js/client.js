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
    console.log(pi);
    console.log(payload);
});

// var eurecaServer;
//
// var eurecaClientSetup = function(){
//     // Create instance of Eureca client
//     var eurecaClient = new Eureca.Client();
//     eurecaClient.ready(function(proxy){
//         // Get server object
//         eurecaServer = proxy;
//     });
//
//     eurecaClient.exports.handshakeToClient = function(payload){
        // console.log(payload);
        // urlPathArray = document.location.pathname.split('/');
        // if(payload == 'offer' && urlPathArray[urlPathArray.length-2] == 'boards'){
        //     fingerprint = urlPathArray[urlPathArray.length-1];
        //     eurecaServer.handshakeToServer({'fingerprint': fingerprint});
        // }else{
        //     // TODO: Improve this error handling
        //     eurecaServer.handshakeToServer({'error': 'URL is wrong'});
        // }
//     };
//
//     eurecaClient.exports.updateState = function(payload){
//
//     };
// };
//
// eurecaClientSetup();
