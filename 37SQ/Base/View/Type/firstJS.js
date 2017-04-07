/**
 * Created by vic on 16/4/5.
 */


function showMessage1(){
    sendCommand("alert","1");
}
function showMessage2(){
    sendCommand("alert","2");
}
function showMessage3(){
    sendCommand("alert","3");
}
function showMessage4(){
    sendCommand("alert","4");
}
function showMessage5(){
    sendCommand("alert","5");
}
function showMessage6(){
    sendCommand("alert","6");
}
function showMessage7(){
    sendCommand("alert","7");
}
function showMessage8(){
    sendCommand("alert","8");
}
function showMessage9(){
    sendCommand("alert","9");
}
function sendCommand(cmd,param){
    var url="testapp:"+cmd+":"+param;
    document.location = url;
}

