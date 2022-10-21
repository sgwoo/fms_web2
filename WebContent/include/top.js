browserName = navigator.appName;
browserVer = parseInt(navigator.appVersion);
if (browserName == "Netscape" && browserVer >= 3)  ver = "n3";
else if (browserName == "Microsoft Internet Explorer" && browserVer >= 4)  ver = "n3";
else ver = "n2" ;

if (ver == "n3"){
	menu1_on = new Image();
	menu2_on = new Image();
	menu3_on = new Image();
	menu4_on = new Image();
	menu5_on = new Image();
	menu6_on = new Image();
	menu7_on = new Image();

	menu1_off = new Image();
	menu2_off = new Image();
	menu3_off = new Image();
	menu4_off = new Image();
	menu5_off = new Image();
	menu6_off = new Image();
	menu7_off = new Image();

       
	menu1_on.src = "image/menu1_on.gif";
	menu2_on.src = "image/menu2_on.gif"; 
	menu3_on.src = "image/menu3_on.gif";
	menu4_on.src = "image/menu4_on.gif";
	menu5_on.src = "image/menu5_on.gif";
	menu6_on.src = "image/menu6_on.gif";
	menu7_on.src = "image/menu7_on.gif";

	menu1_off.src = "image/menu1.gif";
	menu2_off.src = "image/menu2.gif"; 
	menu3_off.src = "image/menu3.gif";
	menu4_off.src = "image/menu4.gif";
	menu5_off.src = "image/menu5.gif";
	menu6_off.src = "image/menu6.gif";
	menu7_off.src = "image/menu7.gif";

}

function changeImage(name){
	if (ver == "n3"){
		document[name].src = eval(name + "_on.src"); 
	}
}

function unchangeImage(name){
	if (ver == "n3"){
		document[name].src = eval(name + "_off.src"); 
	}
}

function eventLoad(){
	location.href="event.html";
}

