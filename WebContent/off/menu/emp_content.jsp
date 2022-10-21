<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.incom.*, acar.user_mng.*, acar.memo.*, acar.estimate_mng.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/off/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	a_bean = oad.getAncLastBean(); 
	
	Vector vt =  a_db.getIncomListChk("2", "Y", "1", "", "");
	int incom_size = vt.size();
	
	String value[] = new String[2];
	
	// anc_div, anc_div2, anc_div3 높이 설정 2018.04.13
	boolean chk_view = false;
	int anc_count = 0;
	int count_gong = 0;
	int pan_count = 0;
	AncBean a_r [] = oad.getAncAll(acar_id);
	for(int i=0; i<a_r.length; i++){
        a_bean = a_r[i];
		chk_view = a_bean.getP_view().equals("Y") || a_bean.getP_view().equals("J");
		// 1. 일반공지 2. 최근뉴스 3. 판매조건 4. 업무협조 5. 경조사 6. 규정및인사 7. 업그레이드 8. 에이전트 공지 9. 협력업체 공지 Y. 협력업체 A. 에이전트 J. 협력업체/에이전트
		if((a_bean.getBbs_st().equals("1") && chk_view) || (a_bean.getBbs_st().equals("2") && chk_view) || (a_bean.getBbs_st().equals("3") && chk_view) ||  
			(a_bean.getBbs_st().equals("4") && chk_view)	|| (a_bean.getBbs_st().equals("5") && chk_view) || (a_bean.getBbs_st().equals("6") && chk_view) || 
			(a_bean.getBbs_st().equals("9") && chk_view)){
			anc_count++;
		}
	}
	count_gong = anc_count;
	if(pan_count > anc_count){
		count_gong = pan_count;
	}
	int div_height = 100+count_gong*38;
%>
<html>
<head>
<title>협력업체 FMS</title>

<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.12.0/jquery-ui.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<link rel=stylesheet type="text/css" href="/acar/include/sub.css">
<link href="/fms2/menu/fontello-embedded.css " rel="stylesheet" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<script>
$(document).ready(function(){
	
	$('.page-link').click(function(){
		var menuNameParam = $(this).attr("param");
		var menuFullPath = menuNameParam.split(":")[0] + " > " + menuNameParam.split(":")[1] + " > " + menuNameParam.split(":")[2];
		
		$.cookie("currentMenuNavi",menuFullPath,{expires: 1, path: '/', domain:'.amazoncar.co.kr'});
		
		location.href = $(this).attr("href");
	})
	
	
	
})


</script>
<script>
<!--
	//리플달기
	function Anc_Open(bbs_id,acar_id){


		var SUBWIN="/fms2/off_anc/anc_c.jsp?bbs_id="+bbs_id+"&acar_id="+acar_id;	
		window.open(SUBWIN, "AncDisp", "left=100, top=50, width=1024, height=800, scrollbars=yes");
	}
	
	function Anc_Open1(bbs_id,acar_id){


		var SUBWIN="/fms2/off_anc/anc_c2.jsp?bbs_id="+bbs_id+"&acar_id="+acar_id;	
		window.open(SUBWIN, "AncDisp", "left=100, top=50, width=1024, height=800, scrollbars=yes");
	}
	
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

	$( document ).ready(function() {

    /*if(screen.height<=900){
    	$('#smallAnc').css('display','block');
    	$('#bigAnc').css('display','none');
    	$('#smallPan').css('display','block');
    	$('#bigPan').css('display','none');
    	$('#anc_div').css('height','230px');
    	$('#anc_div2').css('height','230px');
    	$('#anc_div3').css('height','230px');
    	
    }*/

	});
	$( window ).resize(function() {
  	$('.mymenu-boxes').css('height',$(window).height());
  	$('.mymenu-window-sub').css('height',$(window).height());
	});
	
	
//-->
</script>
<style>
@import url(//cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothic.css);
@import url(//cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothiclight.css);
@font-face{
	font-family:"Nanum Gothic";
	src:url('/fms2/menu/font/NanumGothic.eot');
	src:url('/fms2/menu/font/NanumGothic.eot?#iefix') format('embedded-opentype'),
	url('/fms2/menu/font/NanumGothic.woff') format('woff'),
	url('/fms2/menu/font/NanumGothic.ttf') format('truetype');
	url('/fms2/menu/font/NanumGothic.svg#NanumGothic') format('svg')
	src:local(※), url('/fms2/menu/font/NanumGothic.woff') format('woff');
}

 
body, table, div, p,td {font-family:'Nanum Gothic';}

.ancTitle{
	color:black; margin-left:20px; font:18px/52px Nanum Gothic; font-weight:bold; 
}
.ancPlus{
	color:#88acc6; font:25Px/52px Nanum Gothic; cursor:pointer;
}
.panPlus{
	color:#88c6c1; font:25Px/52px Nanum Gothic; cursor:pointer;
}
.bankPlus{
	color:#8cc689; font:25Px/52px Nanum Gothic; cursor:pointer;
}
.upPlus{
	color:#b4c688; font:25Px/52px Nanum Gothic; cursor:pointer;
}
.updatePlus{
	color:#ff6508; font:20Px/40px Nanum Gothic; cursor:pointer;
}
.ficonS{
	color:white; font:38Px/52px Nanum Gothic;"
}
.ficonS2{
	color:white; font:30Px/52px Nanum Gothic;"
}
.ficonS3{
	color:white; font:30Px/52px Nanum Gothic;"
}
.ficonS4{
	color:white; font:30Px/52px Nanum Gothic;"
}
.ancTableTitle{
	font-weight:bold;
	color:#545454;
}
.ancTableDate{
	font-weight:bold;
	color:#939393;
	font-size:12px;
}
.ancTableName{
	font-weight:bold;
	color:#545454;
	font-size:13px;
}
.grayDate{
	color:#939393;
	font-weight:bold;
}
.blackTitle{
	font-weight:bold;
}
.smartTitle{
	color:white; font:15Px/90px Nanum Gothic; cursor:pointer;font-weight:bold;
}
.smartGun{
	color:yellow; font:20Px/90px Nanum Gothic; cursor:pointer;font-weight:bold;
}
.smartTitle2{
	color:#545454; font:15Px/70px Nanum Gothic; cursor:pointer;font-weight:bold;
}
.smartGun2{
	color:#1ab300; font:20Px/70px Nanum Gothic; cursor:pointer;font-weight:bold;
}
.smartTitle3{
	color:#545454; font:12Px/40px Nanum Gothic;font-weight:bold;
}
.smartGun3{
	color:#ff6508; font:17Px/40px Nanum Gothic;font-weight:bold;
}
div.mymenu-window.open{
    -moz-transition-duration: 0.3s;
    -webkit-transition-duration: 0.3s;
    -o-transition-duration: 0.3s;
    transition-duration: 0.3s;
    -moz-transition-timing-function: ease-in;
    -webkit-transition-timing-function: ease-in;
    -o-transition-timing-function: ease-in;
    transition-timing-function: ease-in;
    left: 0;
}
div.mymenu-window{
    -moz-transition-duration: 0.3s;
    -webkit-transition-duration: 0.3s;
    -o-transition-duration: 0.3s;
    transition-duration: 0.3s;
    -moz-transition-timing-function: cubic-bezier(0, 1, 0.5, 1);
    -webkit-transition-timing-function: cubic-bezier(0, 1, 0.5, 1);
    -o-transition-timing-function: cubic-bezier(0, 1, 0.5, 1);
    transition-timing-function: cubic-bezier(0, 1, 0.5, 1);
	position:fixed;
	left: -160px;

}
::-webkit-scrollbar {
display:none;
}
.mymenu-path{
 font-family:'Nanum Barun Gothic';
 font-size:13px;
}
.mymenu{
	line-height:15px;
}
</style>
<body style="height:85%;">
<form name="AncForm" method="post">
	<input type='hidden' name='acar_id' value='<%=acar_id%>'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>				
	<input type='hidden' name='bbs_id' value='<%=a_bean.getBbs_id()%>'>
	<input type="hidden" name="temp">
	<div style="width:100%;height:100%;">
		<div id = "anc_div" style="width:1024px; height:<%=div_height%>px; margin:0 auto;">
			<!--공지사항-->
			<div id = "anc_div2" style="float:left;width:510px; height:<%=div_height%>px; border:1px solid #dcdcdc;">
				<div style="float:left;background-color:#88acc6;  width:55px; height:52px; text-align:center;">
					<span class="icon-volume-down ficonS"></span>
				</div>
				<div style="float:left;  width:400px; height:52px; ">
					<span class="ancTitle">공지사항</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<a class="page-link" href="/off/off_bbs/off_bbs_frame.jsp" param="FMS운영관리:공지사항:공지사항">
						<span class="icon-plus ancPlus"></span>
					</a>
				</div>
				<div style="clear:both;  width:490px; border-top:1px solid #dcdcdc; padding:10px;">
					<table id="bigAnc" style="line-height:18px; width:490px;">
						<%	
							int gong_count = 0;
							String[] latestObj = new String[4];
						    for(int i=0; i<a_r.length; i++){
						        a_bean = a_r[i];
								String r_ch = a_bean.getRead_chk();
								String cont = AddUtil.replace(a_bean.getContent(),"\\","&#92;&#92;");
								String cont_title = a_bean.getTitle();
								cont_title = AddUtil.replace(cont_title,"\"","&#34;");
								cont = AddUtil.replace(cont,"\"","&#34;");
								cont = AddUtil.replace(cont,"&#39;","'+'\\'");
								cont = Util.htmlR(cont);
								// bbs_st : 9 / 
								chk_view = a_bean.getP_view().equals("Y") || a_bean.getP_view().equals("J");
								// 1. 일반공지 2. 최근뉴스 3. 판매조건 4. 업무협조 5. 경조사 6. 규정및인사 7. 업그레이드 8. 에이전트 공지 9. 협력업체 공지 Y. 협력업체 A. 에이전트 J. 협력업체/에이전트
								if((a_bean.getBbs_st().equals("1") && chk_view) || (a_bean.getBbs_st().equals("2") && chk_view) || (a_bean.getBbs_st().equals("3") && chk_view) ||  
									(a_bean.getBbs_st().equals("4") && chk_view)	|| (a_bean.getBbs_st().equals("5") && chk_view) || (a_bean.getBbs_st().equals("6") && chk_view) || 
									(a_bean.getBbs_st().equals("9") && chk_view)){
									gong_count++;
						%>
							<tr>
						    	<td style="font-size:15px;">
						    		<a href="javascript:Anc_Open('<%=a_bean.getBbs_id()%>','<%=acar_id%>');"
						    			><span class="ancTableTitle"><%=Util.subData(String.valueOf(a_bean.getTitle()),35)%></span>
						    			<%if(a_bean.getRead_yn().equals("Y")){%><!-- 필독처리 -->
						    				<span style="font-size:15px; background-color:rgba(238, 34, 0, 0.81);border-radius:2px; color:white; vertical-align:middle;">
								  			<span style="font-size:11px;vertical-align:text-top;margin-bottom:5px;">&nbsp;필독&nbsp;</span></span>
						    			<%}%>
						    			<%if(a_bean.getReg_dt().equals(AddUtil.getDate())){%>
						    				<span style="font-size:15px; background-color:rgba(0, 51, 255, 0.81);border-radius:2px; color:white; vertical-align:middle;">
								  			<span class="blink" style="font-size:11px;vertical-align:text-top; font-weight: bold; ">&nbsp;New&nbsp;</span></span>
						    			<%}%>
						    		</a>
						    		<br/><span class="ancTableDate"><%=a_bean.getReg_dt()%></span>&nbsp;
						    		<span class="ancTableName"><%=a_bean.getUser_nm()%></span>
						    	</td>
						    </tr>
						   <%
						   		if(gong_count < anc_count){
						   %>
							<tr>
						    	<td style="border-bottom: 1px solid #ded8d8;"></td>
						    </tr>
						    <%}%>
						    <%
						   /* if(!a_bean.getBbs_st().equals("5")) {
								latestObj[3] = latestObj[3] == null ? "0" : latestObj[3];
								if( i > 0 ){
									int preContentDt = Integer.parseInt(latestObj[3].replaceAll("-", ""));
									int contentDt = Integer.parseInt(a_bean.getReg_dt().replaceAll("-", ""));
									if( preContentDt < contentDt ){
										latestObj[0] = Integer.toString(a_bean.getBbs_id());
										latestObj[1] = a_bean.getTitle();
										latestObj[2] = cont;
										latestObj[3] = a_bean.getReg_dt();
									}
								}else{
									latestObj[0] = Integer.toString(a_bean.getBbs_id());
									latestObj[1] = a_bean.getTitle();
									latestObj[2] = cont;
									latestObj[3] = a_bean.getReg_dt();			
								}
							} */
						    %>
   							<%}%>
						<%}%>
					</table>
					
					
				</div>
			</div>
			
			<!-- 업그레이드 정보 -->
			<!-- 배치만 되어 있고 기능은 없음 2018.05.03 -->
			<div style="float:left; width:510px; height:<%=div_height%>px; border:1px solid #dcdcdc; border-left: 0px; ">
				<div style="float:left; background-color:#b4c688; width:55px; height:52px; text-align:center;">
					<span class="icon-upload ficonS4"></span>
				</div>
				<div style="float:left; width:400px; height:52px; ">
						<span class="ancTitle">FMS 업그레이드 정보</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<span class="icon-plus upPlus"></span>
				</div>
				<div style="clear:both;  width:470px; height:52px; border-top:1px solid #dcdcdc; padding:20px;">
					<table style="line-height:23px;">
						<tr>
							<td style="font-size:15px;">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
		</div>
	</div>
	</form>
</body>
</html>