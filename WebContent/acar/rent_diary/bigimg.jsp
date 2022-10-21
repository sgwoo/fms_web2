<%@ page language="java" contentType="text/html;charset=euc-kr"%>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String encar_id = request.getParameter("encar_id")==null?"":request.getParameter("encar_id");
	
	if(c_id.equals("000299")){
		encar_id = "626711";
	}else if(c_id.equals("000828")){
		encar_id="616355";
	}else if(c_id.equals("000330")){
		encar_id="619318";
	}else if(c_id.equals("000599")){
		encar_id="619326";
	}
	String img_path = "http://211.239.112.202/carpicture/car_pic/pic0"+encar_id.substring(0,3);
%>
<html>
<head>
<title>FMS</title>
<SCRIPT LANGUAGE="JavaScript1.1">
<!--
	function right(e) {
	//오른쪽마우스 금지 
		if ( navigator.appName == 'Netscape' && (e.which == 3 || e.which == 2) ) return false;
		else if ( navigator.appName == 'Microsoft Internet Explorer' && (event.button == 2 || event.button == 3) ) {
			alert("사용할 수 없습니다.!!");
			return false;
		}
		return true;
	}
	
	document.onmousedown = right;
	if ( document.layers ) window.captureEvents(Event.MOUSEDOWN);
	window.onmousedown = right;
//-->	
</script>
<script language="javascript">
<!--
var timerId = null;
	var slideList = new Array();
	var carPicList = new Array();
	<%if(!encar_id.equals("")){%>			
	carPicList[0] = '<%=img_path%>/<%=encar_id%>_001.jpg';			
	slideList[0]  = '<%=img_path%>/<%=encar_id%>_001.jpg';			
	carPicList[1] = '<%=img_path%>/<%=encar_id%>_002.jpg';			
	slideList[1]  = '<%=img_path%>/<%=encar_id%>_002.jpg';			
	carPicList[2] = '<%=img_path%>/<%=encar_id%>_003.jpg';			
	slideList[2]  = '<%=img_path%>/<%=encar_id%>_003.jpg';			
	carPicList[3] = '<%=img_path%>/<%=encar_id%>_004.jpg';			
	slideList[3]  = '<%=img_path%>/<%=encar_id%>_004.jpg';			
	carPicList[4] = '<%=img_path%>/<%=encar_id%>_005.jpg';			
	slideList[4]  = '<%=img_path%>/<%=encar_id%>_005.jpg';			
	<%}else{%>
	carPicList[0] = 'img/no_photo.gif.jpg';			
	slideList[0]  = 'img/no_photo.gif';			
	carPicList[1] = 'img/no_photo.gif';			
	slideList[1]  = 'img/no_photo.gif';			
	carPicList[2] = 'img/no_photo.gif';			
	slideList[2]  = 'img/no_photo.gif';			
	carPicList[3] = 'img/no_photo.gif';			
	slideList[3]  = 'img/no_photo.gif';			
	carPicList[4] = 'img/no_photo.gif';			
	slideList[4]  = 'img/no_photo.gif';			
	<%}%>	
				
	function startSlideShow(index) {
		index = index % slideList.length;
		if ( slideList.length  <= 1 ) index = 0;
		document.f.src = slideList[index];
		//setSizeByMagnification();
		timerId = setTimeout('startSlideShow('+(++index)+')', 1500);
	}
	
	function stopSlideShow() {
		clearTimeout(timerId);
	}
	
	function showLargePic(index) {
		document.f.src = carPicList[index];
		//setSizeByMagnification();
	}
	
	function setSizeByMagnification() {
		var image = new Image();
		image.src = document.f.src;
		if ( image.width > 600 ) {
			wMagPower = image.width / 600;
			document.f.width = image.width / wMagPower;
			document.f.height = image.height / wMagPower;
		} else {
			document.f.width = image.width;
			document.f.height = image.height;
		}
	}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<body text="#000000" bgcolor="#E0E0E0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"onLoad="MM_preloadImages('images/popup_0101.gif','images/popup_0202.gif','images/popup_0303.gif','images/popup_0404.gif','images/popup_0505.gif','images/play3_01.gif','images/stop2_01.gif','images/popup_tr_01.gif','images/popup_tr_02.gif','images/popup_tr_03.gif','images/popup_tr_04.gif','images/popup_tr_05.gif','img/v_pop01_1.gif','img/v_pop01_2.gif','img/v_pop01_3.gif','img/v_pop01_4.gif','img/v_pop01_5.gif')">
<script language="JavaScript">
	for ( var i = 0; i < document.images.length; i++ ) document.images[i].onmousedown = right;
	for ( var i = 0; i < document.links.length; i++ ) document.links[i].onmousedown = right;
</script>
<table width="620" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="3"><img src="img/v_pop01.gif" width="620" height="26"></td>
  </tr>
  <tr> 
    <td><img src="img/v_pop02.gif" width="10" height="396"></td>
    <td width="600" height="396" bgcolor="757575"><img src="<%=img_path%>/<%=encar_id%>_001.jpg" width="600" height="396" name="f"></td>
    <td><img src="img/v_pop03.gif" width="10" height="396"></td>
  </tr>
  <tr> 
    <td><img src="img/v_pop05.gif" width="10" height="102"></td>
    <td>
      <table width="90%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="14%"><img src="img/v_pop06.gif" width="83" height="102"></td>
          <td width="12%"><a href="javascript:showLargePic(4);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','img/v_pop01_1.gif',1)"><img src="img/v_pop07.gif" width="72" height="102" border="0" name="Image1"></a></td>
          <td width="11%"><a href="javascript:showLargePic(2);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','img/v_pop01_2.gif',1)"><img src="img/v_pop08.gif" width="68" height="102" border="0" name="Image2"></a></td>
          <td width="12%"><a href="javascript:showLargePic(3);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','img/v_pop01_3.gif',1)"><img src="img/v_pop09.gif" width="71" height="102" border="0" name="Image3"></a></td>
          <td width="12%"><a href="javascript:showLargePic(0);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','img/v_pop01_4.gif',1)"><img src="img/v_pop10.gif" width="73" height="102" border="0" name="Image4"></a></td>
          <td width="12%"><a href="javascript:showLargePic(1);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','img/v_pop01_5.gif',1)"><img src="img/v_pop11.gif" width="71" height="102" border="0" name="Image5"></a></td>
          <td width="12%"><a href="javascript:startSlideShow(0)"><img src="img/v_pop12.gif" width="93" height="102" border="0"></a></td>
          <td width="15%"><a href="javascript:stopSlideShow()"><img src="img/v_pop13.gif" width="30" height="102" border="0"></a></td>
          <td width="0%"><a href="javascript:self.close()"><img src="img/v_pop14.gif" border="0"></a></td>
        </tr>
      </table>
    </td>
    <td><img src="img/v_pop15.gif" width="10" height="102"></td>
  </tr>
</table>
</body>
</html>


