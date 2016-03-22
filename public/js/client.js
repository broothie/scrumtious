/* js/client.js */

// Set focus to canvas so that keys are caught by KeyTrap
document.getElementById('stage').focus();

var eurecaServer;

var eurecaClientSetup = function(){
    // Create instance of Eureca client
    var eurecaClient = new Eureca.Client();
    eurecaClient.ready(function(proxy){
        // Get server object
        eurecaServer = proxy;
    });

    eurecaClient.exports.hand = function(payload){
        eurecaServer.accept('shake');
    };

    eurecaClient.exports.updateState = function(payload){

    };
};
