<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*,acar.car_register.* "%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//차량정보
	cr_bean = crd.getCarRegBean(c_id);
	
	//String seq[] = { "5","앞면", "3","후면", "1","측면1", "4" ,"측면2","2","내부1","6","내부2","7","내부3","8","내부4"};
	String seq[] = { "5","3","1","4","2","6","7","8"};


	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                		
	String content_code = "APPRSL";
	String content_seq  = c_id+"1";

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	

%>
<html>
<head>
<style>
body{
	background-color:#eee;
}
.swiper-container {
    width: 100%;
    height: 600px;
    margin-left: auto;
    margin-right: auto;
}
.swiper-slide {
    background-size: contain;
    background-position: center;
    background-repeat:no-repeat;
}
</style>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/3.3.1/css/swiper.min.css">
<script
  src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/3.3.1/js/swiper.jquery.min.js"></script>
<script language="javascript">
<!--
	
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
	
	//차량사진 출력
	function file_down(code , c_id, downname){
	
		var SUMWIN = "";
		var down_name=encodeURIComponent(downname);	
		SUMWIN ="https://fms3.amazoncar.co.kr/fms2/attach/filezip.jsp?CONTENT_CODE="+code+"&SEQ="+c_id+"&DOWNFILENAME="+down_name;
				
		window.open(SUMWIN, "downfile", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}

	
//-->
</script>
</head>
<body>
 	<div class="swiper-container">
  		<div class="swiper-wrapper">
   	<% 
	   	for(int i=0;i<8;i++){
				
			content_code = "APPRSL";
			content_seq  = c_id+""+seq[i];
	
			attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			attach_vt_size = attach_vt.size();	
	
			if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
						Hashtable ht = (Hashtable)attach_vt.elementAt(j);
   	%>
	           		 <div class="swiper-slide" style="background-image:url(https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>)"></div>
   	<%			}
   			}else{
   	%>
   				<img src="/images/no_photo.gif" width="524" height=390 name="f">
   	<%
   			}
   		}
   	%>  
   		</div>
	    <div class="swiper-pagination"></div>
	    <!-- Add Arrows -->
        <div class="swiper-button-next"></div>
        <div class="swiper-button-prev"></div>
	</div>
	
	<input type="button" class="button" id='downfile' value='저장' onclick="javascript:file_down('APPRSL', '<%=c_id%>', '<%=cr_bean.getCar_no()%>')">	    	  
		
		<!-- Swiper JS -->
	    <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/3.3.1/js/swiper.jquery.min.js"></script>
	
	    <!-- Initialize Swiper -->
	    <script>
	    var swiper = new Swiper('.swiper-container', {
	        nextButton: '.swiper-button-next',
	        prevButton: '.swiper-button-prev',
	        pagination: '.swiper-pagination',
	        paginationType: 'progress'
	    });
	    </script>
																		
</body>

</html>


