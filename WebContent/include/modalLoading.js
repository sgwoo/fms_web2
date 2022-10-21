
var modalopenCnt = 0;
var eObj = null;

function setLoadingLayer(){
	modalopenCnt = 0;
	var loading = true;
	
	var deniedUrl = [
		"/emp_top.jsp"
		,"/emp_menu.jsp"
		,"/amazoncar.jsp"
		,"_sh.jsp"
	];
	var url = location.href;
	for( var i=0; i < deniedUrl.length; i++ ){
		if( url.indexOf(deniedUrl[i]) != -1 ){
			loading = false;
			break;
		}
	}
	
	if( loading ){
		var modalCnt = 0;
		var target = null;
		
		if(typeof getModalCnt != "undefined"){
			modalCnt = getModalCnt();
			setModalCnt();
		}
				
		
		var obj = document.getElementById("modal_bg");
		
		if( obj == null && modalCnt <= 0 ){
			
			var modaldiv = document.createElement("div");
			var img = document.createElement("img");
			
			
			modaldiv.setAttribute("name","modal_bg");
			
			modaldiv.style.cssText = "position:absolute;top:0;left:0;z-index:100;width:100%;height:100%;text-align:center;line-height:1em;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(Opacity=50);filter:progid:DXImageTransform.Microsoft.Alpha(Opacity=50);opacity:.5;background:#000000;";
			modaldiv.setAttribute("id","modal_bg");
			modaldiv.innerHTML = '============================================== YES';
			img.setAttribute("src","/images/viewLoading.gif");
			img.style.cssText = "top: 50%;left: 50%; position: absolute; display: inline-block; margin-top: 24px;   width: 24;";
			
			modaldiv.appendChild(img);
			
			target = document.getElementsByTagName("html");
			
		    target[0].appendChild(modaldiv);


			if( target != null && target.length > 0 ){
				//eObj = target[0].getElementsByTagName("div")[0];
				
				eObj = document.getElementById("modal_bg");
			}
			
		}else{
			eObj = obj;
		}
		
		if( eObj != null ){
			eObj.style.display = "inline-block";			
		}
	}	
	
}

function getModalCnt(){
	return modalopenCnt;
}

function setModalCnt(){
	modalopenCnt++;
}

function hideBlindLayer(){
	if( eObj != null ){
		//alert("close");
		eObj.style.display = "none";
		modalopenCnt = 0;
		eObj = null;
	}
}
