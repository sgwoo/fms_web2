<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.car_register.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//차량정보
	Hashtable offlh = rs_db.getCarBinImg(c_id);
	String encar_id = String.valueOf(offlh.get("ENCAR_ID"));
	String img_path = "";
	
	if(!encar_id.equals("")){
		img_path = String.valueOf(offlh.get("IMG_PATH"))+"pic0"+encar_id.substring(0,3);
	}
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
.clsBannerScreen {
    overflow: hidden;
    position: relative;
    height: 390px;
    width: 600px;
    border: 0px solid #e1e1e1;
    cursor: pointer;
    clear: both;
}
.clsBannerScreen .images {
	position: absolute;
	display: none;
}
ul, li {
    list-style: none;
    margin: 0;
    padding: 0;
    font-size: 10pt;
}
.clsBannerButton {
    width: 600px;
    cursor: pointer;
    border-bottom: 0px solid #e1e1e1;
}
.clsBannerButton li {
	width: 100px;
	float: left;
	border-right: 0px solid #e1e1e1;
	padding: 2px;
}
.clsBannerButton li.fir {
	border-left: 1px solid #e1e1e1;
}
.clsBannerButton li.labelOverClass {
	font-weight: bold;
}
</style>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="js/jquery.banner.js"></script>
<script src="js/script.js"></script>
<script language="javascript">
<!--
var timerId = null;
	var slideList = new Array();
	var carPicList = new Array();
	
	<%if(!String.valueOf(offlh.get("IMGFILE1")).equals("")){%>								
		carPicList[0] = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE1")%>.gif";
		slideList[0]  = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE1")%>.gif";
	<%}else if(String.valueOf(offlh.get("IMGFILE1")).equals("") && !encar_id.equals("")){%>	
		carPicList[0] = '<%=img_path%>/<%=encar_id%>_001.jpg';	
		slideList[0]  = '<%=img_path%>/<%=encar_id%>_001.jpg';	
	<%}else{%>																				
		carPicList[0] = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
		slideList[0]  = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
	<%}%>
	<%if(!String.valueOf(offlh.get("IMGFILE2")).equals("")){%>								
		carPicList[1] = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE2")%>.gif";
		slideList[1]  = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE2")%>.gif";
	<%}else if(String.valueOf(offlh.get("IMGFILE2")).equals("") && !encar_id.equals("")){%>	
		carPicList[1] = '<%=img_path%>/<%=encar_id%>_002.jpg';	
		carPicList[1] = '<%=img_path%>/<%=encar_id%>_002.jpg';	
	<%}else{%>																				
		carPicList[1] = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
		slideList[1]  = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
	<%}%>
	<%if(!String.valueOf(offlh.get("IMGFILE3")).equals("")){%>								
		carPicList[2] = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE3")%>.gif";
		slideList[2]  = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE3")%>.gif";
	<%}else if(String.valueOf(offlh.get("IMGFILE3")).equals("") && !encar_id.equals("")){%>	
		carPicList[2] = '<%=img_path%>/<%=encar_id%>_003.jpg';	
		slideList[2]  = '<%=img_path%>/<%=encar_id%>_003.jpg';	
	<%}else{%>																				
		carPicList[2] = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
		slideList[2]  = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
	<%}%>
	<%if(!String.valueOf(offlh.get("IMGFILE4")).equals("")){%>								
		carPicList[3] = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE4")%>.gif";
		slideList[3]  = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE4")%>.gif";
	<%}else if(String.valueOf(offlh.get("IMGFILE4")).equals("") && !encar_id.equals("")){%>	
		carPicList[3] = '<%=img_path%>/<%=encar_id%>_004.jpg';	
		slideList[3]  = '<%=img_path%>/<%=encar_id%>_004.jpg';	
	<%}else{%>																				
		carPicList[3] = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
		slideList[3]  = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
	<%}%>
	<%if(!String.valueOf(offlh.get("IMGFILE5")).equals("")){%>								
		carPicList[4] = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE5")%>.gif";
		slideList[4]  = "https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE5")%>.gif";
	<%}else if(String.valueOf(offlh.get("IMGFILE5")).equals("") && !encar_id.equals("")){%>	
		carPicList[4] = '<%=img_path%>/<%=encar_id%>_005.jpg';	
		slideList[4]  = '<%=img_path%>/<%=encar_id%>_005.jpg';
	<%}else{%>																				
		carPicList[4] = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
		slideList[4]  = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
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
		if ( image.width > 524 ) {
			wMagPower = image.width / 524;
			document.f.width = image.width / wMagPower;
			document.f.height = image.height / wMagPower;
		} else {
			document.f.width = image.width;
			document.f.height = image.height;
		}
	}

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
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
<body text="#000000" bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"onLoad="MM_preloadImages('images/popup_0101.gif','images/popup_0202.gif','images/popup_0303.gif','images/popup_0404.gif','images/popup_0505.gif','images/play3_01.gif','images/stop2_01.gif','images/popup_tr_01.gif','images/popup_tr_02.gif','images/popup_tr_03.gif','images/popup_tr_04.gif','images/popup_tr_05.gif','/images/res/v_pop01_1.gif','/images/res/v_pop01_2.gif','/images/res/v_pop01_3.gif','/images/res/v_pop01_4.gif','/images/res/v_pop01_5.gif')">
<script language="JavaScript">
	for ( var i = 0; i < document.images.length; i++ ) document.images[i].onmousedown = right;
	for ( var i = 0; i < document.links.length; i++ ) document.links[i].onmousedown = right;
</script>
<div id="image_list_2">
        <div class="clsBannerScreen">
			<div class="images" style="display:block"><%if(!String.valueOf(offlh.get("IMGFILE5")).equals("")){%>
				<img src="https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE5")%>.gif" width="524" height=390 name="f">    								
				<%}else if(String.valueOf(offlh.get("IMGFILE5")).equals("") && !encar_id.equals("")){%>	
				<img src="<%=img_path%>/<%=encar_id%>_005.jpg" width="524" height=390 name="f">    									
				<%}else{%>																				
				<img src="/images/res/no_photo.gif" width="524" height=390 name="f">    									
				<%}%>
			</div>
			
            <div class="images"><%if(!String.valueOf(offlh.get("IMGFILE3")).equals("")){%>
				<img src="https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE3")%>.gif" width="524" height=390 name="f">    								
				<%}else if(String.valueOf(offlh.get("IMGFILE3")).equals("") && !encar_id.equals("")){%>	
				<img src="<%=img_path%>/<%=encar_id%>_003.jpg" width="524" height=390 name="f">    									
				<%}else{%>																				
				<img src="/images/res/no_photo.gif" width="524" height=390 name="f">    									
				<%}%>
			</div>
			
			<div class="images">
				<%if(!String.valueOf(offlh.get("IMGFILE1")).equals("")){%>
				<img src="https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE1")%>.gif" width="524" height=390 name="f">    								
				<%}else if(String.valueOf(offlh.get("IMGFILE1")).equals("") && !encar_id.equals("")){%>	
				<img src="<%=img_path%>/<%=encar_id%>_001.jpg" width="524" height=390 name="f">    									
				<%}else{%>																				
				<img src="/images/res/no_photo.gif" width="524" height=390 name="f">    									
				<%}%>
			</div>
            
            <div class="images"><%if(!String.valueOf(offlh.get("IMGFILE4")).equals("")){%>
				<img src="https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE4")%>.gif" width="524" height=390 name="f">    								
				<%}else if(String.valueOf(offlh.get("IMGFILE4")).equals("") && !encar_id.equals("")){%>	
				<img src="<%=img_path%>/<%=encar_id%>_004.jpg" width="524" height=390 name="f">    									
				<%}else{%>																				
				<img src="/images/res/no_photo.gif" width="524" height=390 name="f">    									
				<%}%>
			</div>
            
			<div class="images"><%if(!String.valueOf(offlh.get("IMGFILE2")).equals("")){%>
				<img src="https://fms3.amazoncar.co.kr/images/carImg/<%=offlh.get("IMGFILE2")%>.gif" width="524" height=390 name="f">    								
				<%}else if(String.valueOf(offlh.get("IMGFILE2")).equals("") && !encar_id.equals("")){%>	
				<img src="<%=img_path%>/<%=encar_id%>_002.jpg" width="524" height=390 name="f">    									
				<%}else{%>																				
				<img src="/images/res/no_photo.gif" width="524" height=390 name="f">    									
				<%}%>
			</div>
        </div>

        <ul class="clsBannerButton" id="label_2">
            <li class="fir"><a href="javascript:showLargePic(4);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','/images/res/v_pop01_1.gif',1)"><img src="/images/res/v_pop07.gif" width="72" height="102" border="0" name="Image1"></a></li>
            <li><a href="javascript:showLargePic(2);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','/images/res/v_pop01_2.gif',1)"><img src="/images/res/v_pop08.gif" width="68" height="102" border="0" name="Image2"></a></li>
            <li><a href="javascript:showLargePic(3);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','/images/res/v_pop01_3.gif',1)"><img src="/images/res/v_pop09.gif" width="71" height="102" border="0" name="Image3"></a></li>
            <li><a href="javascript:showLargePic(0);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','/images/res/v_pop01_4.gif',1)"><img src="/images/res/v_pop10.gif" width="73" height="102" border="0" name="Image4"></a></li>
            <li><a href="javascript:showLargePic(1);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','/images/res/v_pop01_5.gif',1)"><img src="/images/res/v_pop11.gif" width="71" height="102" border="0" name="Image5"></a></li>
        </ul>
    </div>
	<p></p>
	<div>
        <a href="javascript:MM_openBrWindow('car_img_add_all.jsp?c_id=<%=c_id%>&car_no=','ImgAdd','scrollbars=no,status=yes,resizable=yes,width=820,height=650,left=50, top=50');" class="btn"><img src=/acar/images/center/button_reg_p.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
    </div>
</table>
</body>
</html>


