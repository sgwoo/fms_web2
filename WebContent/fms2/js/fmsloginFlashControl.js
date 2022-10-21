/*메뉴 플래시*/
var myObjectElement = document.createElement('<object id="fmslogin_elementid" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="428" height="67"></object>');

var myParamElement1 = document.createElement('<PARAM NAME=movie value="/fms2/flash/fms_login.swf">');  
var myParamElement2 = document.createElement('<Param name=quality value=high>');

myObjectElement.appendChild(myParamElement1);
myObjectElement.appendChild(myParamElement2);

fmsloginFlashLoc.appendChild(myObjectElement);
