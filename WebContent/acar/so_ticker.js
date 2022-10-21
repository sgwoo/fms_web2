/****************************

so_ticker
version 1.0
last revision: 03.30.2006
steve@slayeroffice.com

For implementation instructions, see:
http://slayeroffice.com/code/so_ticker/

Should you improve upon or modify this
code, please let me know so that I can update
the version hosted at slayeroffice.

Please leave this notice intact.


****************************/

so_ticker = new Object();
so_ticker = {
	current:0,			
	currentLetter:0,	
	zInterval:null,	
	tObj: null,			
	op:0.95,			
	pause: false,		
	tickerContent: [],	
	LETTER_TICK:100, 
	FADE: 10, 
	NEXT_ITEM_TICK: 3000, 
	init:function() {
		var d=document;	
		var mObj = d.getElementById("so_oTickerContainer");	
		so_ticker.tObj = d.createElement("div");		
		so_ticker.tObj.setAttribute("id","so_tickerDiv"); 
		var h = d.createElement("h1");	
		h.appendChild(d.createTextNode(so_ticker.getTextNodeValues(mObj.getElementsByTagName("h1")[0])));	
		h.setAttribute("id","so_tickerH1");	
		var ea = d.createElement("a");
		ea.setAttribute("href","javascript:so_ticker.showContent();");
		pImg = ea.appendChild(document.createElement("img"));
		pImg.setAttribute("src","http://slayeroffice.com/code/so_ticker/plus.png");
		pImg.setAttribute("alt","Click to View all News Items.");
		ea.setAttribute("title","Click to View all News Items.");
		h.insertBefore(ea,h.firstChild);
		anchors = mObj.getElementsByTagName("a");		
		var nObj = mObj.cloneNode(false);		
		mObj.parentNode.insertBefore(nObj,mObj); 
		mObj.style.display = "none";	
		nObj.className = "so_tickerContainer"; 	
		nObj.setAttribute("id","so_nTickerContainer");
		nObj.appendChild(h); 	
		nObj.appendChild(so_ticker.tObj);	
		so_ticker.getTickerContent();	
		so_ticker.zInterval = setInterval(so_ticker.tick,so_ticker.LETTER_TICK);	 
	},
	showContent:function() {
			var d = document;
			d.getElementById("so_oTickerContainer").style.display = "block"; 
			d.getElementById("so_nTickerContainer").style.display = "none";
			d.getElementById("so_oTickerContainer").getElementsByTagName("a")[0].focus();
			clearInterval(so_ticker.zInterval);
	},
	getTickerContent:function() {
		for(var i=0;i<anchors.length;i++) so_ticker.tickerContent[i] = so_ticker.getTextNodeValues(anchors[i]);
	}, 
	getTextNodeValues:function(obj) {
		if(obj.textContent) return obj.textContent;
		if (obj.nodeType == 3) return obj.data;
		var txt = [], i=0;
		while(obj.childNodes[i]) {
			txt[txt.length] = so_ticker.getTextNodeValues(obj.childNodes[i]);
			i++;
		}
    	return txt.join("");
    },
    tick: function() {
    	var d = document;
    	if(so_ticker.pause) {
    		try {
    			so_ticker.clearContents(d.getElementById("so_tickerAnchor"));
    			d.getElementById("so_tickerAnchor").appendChild(d.createTextNode(so_ticker.tickerContent[so_ticker.current]));
    			so_ticker.currentLetter = so_ticker.tickerContent[so_ticker.current].length;
    		} catch(err) { }
    		return;
    	}
    	if(!d.getElementById("so_tickerAnchor")) {
    		var aObj = so_ticker.tObj.appendChild(d.createElement("a"));
    		aObj.setAttribute("id","so_tickerAnchor");
    		aObj.setAttribute("href",anchors[so_ticker.current].getAttribute("href"));
    		aObj.onmouseover = function() { so_ticker.pause = true; }
    		aObj.onmouseout = function() { so_ticker.pause = false; }
    		aObj.onfocus = aObj.onmouseover;
			aObj.onblur = aObj.onmouseout;
			aObj.setAttribute("title",so_ticker.tickerContent[so_ticker.current]);
    	}
		d.getElementById("so_tickerAnchor").appendChild(d.createTextNode(so_ticker.tickerContent[so_ticker.current].charAt(so_ticker.currentLetter)));
    	so_ticker.currentLetter++;
    	if(so_ticker.currentLetter > so_ticker.tickerContent[so_ticker.current].length) {
    		clearInterval(so_ticker.zInterval);
    		setTimeout(so_ticker.initNext,so_ticker.NEXT_ITEM_TICK);
    	}
    },
    fadeOut: function() {
    	if(so_ticker.paused) return;
    	so_ticker.setOpacity(so_ticker.op,so_ticker.tObj);
    	so_ticker.op-=.10;
    	if(so_ticker.op<0) {
    		clearInterval(so_ticker.zInterval);
    		so_ticker.clearContents(so_ticker.tObj);
    		so_ticker.setOpacity(.95,so_ticker.tObj);
    		so_ticker.op = .95;
    		so_ticker.zInterval = setInterval(so_ticker.tick,so_ticker.LETTER_TICK);
    	}
    },
    initNext:function() {
    		so_ticker.currentLetter = 0, d = document;
    		so_ticker.current = so_ticker.tickerContent[so_ticker.current + 1]?so_ticker.current+1:0;
    		d.getElementById("so_tickerAnchor").setAttribute("href",anchors[so_ticker.current].getAttribute("href"));
    		d.getElementById("so_tickerAnchor").setAttribute("title",so_ticker.tickerContent[so_ticker.current]);
    		so_ticker.zInterval = setInterval(so_ticker.fadeOut,so_ticker.FADE);
    },
    setOpacity:function(opValue,obj) {
    	obj.style.opacity = opValue;
    	obj.style.MozOpacity = opValue;
    	obj.style.filter = "alpha(opacity=" + (opValue*100) + ")";
    },
    clearContents:function(obj) {
    	try {
    		while(obj.firstChild) obj.removeChild(obj.firstChild);
    	} catch(err) { }
    }
}


function page_init(){
	so_ticker.init();
}
window.addEventListener?window.addEventListener("load",page_init,false):window.attachEvent("onload",page_init);