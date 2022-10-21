<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");


	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                		
	String content_code = "APPRSL";
	String content_seq  = c_id+"1";

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	

%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
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
<table width="620" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan="3"><img src="/images/res/v_pop01.gif" width="620"></td>
    </tr>
    <tr> 
        <td valign=top><img src="/images/res/v_pop02.gif" width="10" height="395"></td>
        <td width="600" bgcolor="000000" align=center valign=middle>
    	<%if(attach_vt_size > 0){
    		for (int j = 0 ; j < attach_vt_size ; j++){
    						Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    	%>
    	    <img src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" width="524" height=390 name="f">
    	<%	}%>    
    	<%}else{%>																				
    	    <img src="/images/res/no_photo.gif" width="524" height=390 name="f">    									
    	<%}%>		
    	</td>
        <td valign=top><img src="/images/res/v_pop03.gif" width="10" height="395"></td>
    </tr>
    <tr> 
        <td valign=top><img src="/images/res/v_pop05.gif" width="10" height="102"></td>
        <td valign=top>
            <table width="90%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="14%"><img src="/images/res/v_pop06.gif" width="83" height="102"></td>
                  <td width="12%"><a href="javascript:showLargePic(4);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','/images/res/v_pop01_1.gif',1)"><img src="/images/res/v_pop07.gif" width="72" height="102" border="0" name="Image1"></a></td>
                  <td width="11%"><a href="javascript:showLargePic(2);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','/images/res/v_pop01_2.gif',1)"><img src="/images/res/v_pop08.gif" width="68" height="102" border="0" name="Image2"></a></td>
                  <td width="12%"><a href="javascript:showLargePic(3);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','/images/res/v_pop01_3.gif',1)"><img src="/images/res/v_pop09.gif" width="71" height="102" border="0" name="Image3"></a></td>
                  <td width="12%"><a href="javascript:showLargePic(0);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','/images/res/v_pop01_4.gif',1)"><img src="/images/res/v_pop10.gif" width="73" height="102" border="0" name="Image4"></a></td>
                  <td width="12%"><a href="javascript:showLargePic(1);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','/images/res/v_pop01_5.gif',1)"><img src="/images/res/v_pop11.gif" width="71" height="102" border="0" name="Image5"></a></td>
                  <td width="12%"><a href="javascript:startSlideShow(0)"><img src="/images/res/v_pop12.gif" width="93" height="102" border="0"></a></td>
                  <td width="15%"><a href="javascript:stopSlideShow()"><img src="/images/res/v_pop13.gif" width="30" height="102" border="0"></a></td>
                  <td width="0%"><a href="javascript:self.close()"><img src="/images/res/v_pop14.gif" border="0"></a></td>
                </tr>
            </table>
        </td>
        <td valign=top><img src="/images/res/v_pop15.gif" width="10" height="102"></td>
    </tr>
    <tr> 
        <td colspan="3" background="/images/res/v_pop06.gif" style='height:10'></td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td colspan="3" align=center>     
        <a href="javascript:MM_openBrWindow('car_img_add_all.jsp?c_id=<%=c_id%>&car_no=','ImgAdd','scrollbars=no,status=yes,resizable=yes,width=820,height=650,left=50, top=50');" class="btn"><img src=/acar/images/center/button_reg_p.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>                                  
    </tr>
</table>
</body>
<script language="javascript">
<!--
	var timerId = null;
	var slideList = new Array();
	var carPicList = new Array();
	
	
	<%	for(int i=0;i<5;i++){
                	               			
			content_code = "APPRSL";
			content_seq  = c_id+""+String.valueOf(i+1);

			attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			attach_vt_size = attach_vt.size();	

			if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);
	%>         
                	
	
		carPicList[<%=i%>] = "https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>";
		slideList[<%=i%>]  = "https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>";
	<%			}%>
	<%		}else{%>																				
		carPicList[<%=i%>] = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";
		slideList[<%=i%>]  = "http://fms1.amazoncar.co.kr/images/res/no_photo.gif";

	<%		}%>
	<%	}%>

				
	function startSlideShow(index) {
		index = index % slideList.length;
		if ( slideList.length  <= 1 ) index = 0;
		document.f.src = slideList[index];		
		timerId = setTimeout('startSlideShow('+(++index)+')', 1500);
	}
	
	function stopSlideShow() {
		clearTimeout(timerId);
	}
	
	function showLargePic(index) {
		document.f.src = carPicList[index];		
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

//-->
</script>
</html>


