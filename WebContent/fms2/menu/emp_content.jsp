<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.incom.*, acar.user_mng.*, acar.memo.*, acar.estimate_mng.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="memo_db" scope="page" class="acar.memo.Memo_Database"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int count = 1;
	int count_gong = 0;
	int count_pan = 0;
	int count_up = 0;
	String acar_id = ck_acar_id;
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	AncBean a_r [] = oad.getAncAll(request,acar_id);
	//공지사항
	AncBean a_r2 [] = oad.getAncAll(request,acar_id,"gong");
	AncBean a_r3 [] = oad.getAncAll(request,acar_id,"pan");
	if(a_r2.length < 6){
		count_gong = 6;
	}else{
		count_gong = a_r2.length;
	}
	if(a_r2.length<a_r3.length){
		count_gong = a_r3.length;
	}
	
	int aDivHeight =237;
	if(a_r2.length>=a_r3.length){
		if(a_r2.length>3 && a_r2.length <= 6){
			aDivHeight += ((a_r2.length - 3 ) * 50);
		}else if(a_r2.length>3 && a_r2.length > 6){
			aDivHeight += 150;
		}
	}else if(a_r2.length<=a_r3.length){
		if(a_r3.length>3 && a_r3.length <= 6){
			aDivHeight += ((a_r3.length - 3 ) * 50);
		}else if(a_r3.length>3 && a_r3.length > 6){
			aDivHeight += 150;
		}
	}
	
	AncBean a_r4 [] = oad.getAncAll(request,acar_id,"up");
	a_bean = oad.getAncLastBean();
	
	//제안완료건 - 최근30일이내
	Vector p_vt = p_db.getProp30EndList();
	int p_vt_size = p_vt.size();
	
	Vector vt =  a_db.getIncomListChk("2", "Y", "1", "", "");
	int incom_size = vt.size();
		
	String value[] = new String[2];	
	
	//최대7개
	if(incom_size > 7) incom_size=7;
	
	//스마트견적 대기건수
	int spe_cnt = 0;
	int ars_cnt = 0;
	int mr_cnt = 0;
	int pc_mr_cnt = 0;
	int gst_cnt = 0;
	if( !isExtStaff ){
		
		spe_cnt = e_db.getSpeEstiCnt();
		ars_cnt = e_db.getSpeEstiArsCnt();
		mr_cnt = e_db.getMobileMrentEstiCnt();
		gst_cnt = e_db.getGustEstiCnt();
		pc_mr_cnt = e_db.getPCMrentEstiCnt();
	}
	//메모
	//미수신된 메모확인
	MemoBean[] bns = memo_db.getRece_n_List(acar_id);
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiSikVarBean[]  hp_var   = e_db.getEstiSikVarList("hp_var");

	String ch = null;
	java.util.Date d = new java.util.Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	ch = sdf.format(d).substring(0, 10);
	
%>
<html>
<head>
<title>:: FMS(Fleet Management System) ::</title>

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
		var SUBWIN="/fms2/off_anc/anc_se_c.jsp?bbs_id="+bbs_id+"&acar_id="+acar_id;
		<%if(ck_acar_id.equals("000029")){%>
		SUBWIN="/fms2/off_anc/anc_se_c.jsp?bbs_id="+bbs_id+"&acar_id="+acar_id;
		<%}%>
		window.open(SUBWIN, "AncDisp<%if(ck_acar_id.equals("000029")){%>"+bbs_id+"<%}%>", "left=100, top=50, width=1024, height=800, scrollbars=yes");
	}
	
	function Anc_Open1(bbs_id,acar_id){


		var SUBWIN="/fms2/off_anc/anc_c2.jsp?bbs_id="+bbs_id+"&acar_id="+acar_id;	
		window.open(SUBWIN, "AncDisp", "left=100, top=50, width=1024, height=800, scrollbars=yes");
	}
	
	
//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
//메모보기
	function Memo(arg, cmd){
		var SUBWIN="/acar/memo/memo_frame.jsp?user_id="+arg+"&cmd="+cmd;	
		window.open(SUBWIN, "MemoUp", "left=10, top=10, width=650, height=650, scrollbars=yes");
	}	
	$( document ).ready(function() {

    

	});
	$( window ).resize(function() {
  	$('.mymenu-boxes').css('height',$(window).height());
  	$('.mymenu-window-sub').css('height',$(window).height());
	});
	
	
	//통계 수정
	function open_update_var(){
		var SUBWIN="/fms2/menu/help_hp_var.jsp";	
		window.open(SUBWIN, "help_hp_var", "left=10, top=10, width=650, height=250, scrollbars=yes");
	}
	
	//전기차 등 출고예정차량 보기 추가(20190306)
	function go_pur_pre(){
		location.href = '/fms2/pur_com_pre/pur_pre_frame.jsp?ready_car=Y';
	}
	
	function PropDisp(prop_id, idx){
		var SUBWIN="/fms2/off_anc/prop_c.jsp?mode=pop_view&prop_id="+prop_id;	
		window.open(SUBWIN, "PropDisp", "left=100, top=50, width=1024, height=800, scrollbars=yes");
	}	
	
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

	
	<div style="width:100%;height:100%;">

		<%	if(Long.parseLong(ch) > 2018012000 && Long.parseLong(ch) < 2018012018){%>
		<!--
		<div style="width:1024px; height:100px; margin:0 auto; margin-top:15px;">
			<div style="float:left; width:1024px; height:100px; background-color:#f1f5f4; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; text-align:center;">
						<span class="smartGun3">DB서버장비 교체 작업으로 조회업무만 가능하고 데이터 입력은 하지 마십시오.
							<br>
							장비교체 작업중에 입력한 데이타는 소실됩니다. 주의해주십시오.
						</span>
			</div>
		</div>	
		<br>
		-->
		<%	}%>

		<%if(!acar_id.equals("000203") && !acar_id.equals("000239")){//외부사용자가 아닌%>
		<div id = "anc_div" style="width:1024px; height:<%=52+(count_gong*42)%>px; margin:0 auto;">
			<!--공지사항-->
			<div id = "anc_div2" style="float:left;  width:510px; height:<%=52+(count_gong*42)%>px; border:1px solid #dcdcdc;">
				<div style="float:left;background-color:#88acc6;  width:55px; height:52px; text-align:center;">
					<span class="icon-volume-down ficonS"></span>
				</div>
				<div style="float:left;  width:400px; height:52px; ">
					<span class="ancTitle">공지사항</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<a class="page-link" href="/fms2/off_anc/anc_s_grid_frame.jsp" param="FMS운영관리:공지사항:공지사항">
						<span class="icon-plus ancPlus"></span>
					</a>
				</div>
				<div style="clear:both;  width:490px; border-top:1px solid #dcdcdc; padding:10px;">
					<table id = "bigAnc" style="line-height:18px; width:490px;">					
						<%	
							for(int i=0; i< a_r2.length; i++){						 	
						  		a_bean = a_r2[i];							
						%>
                        <tr>
							<td style="font-size:15px;">
								<%if(a_bean.getBbs_st().equals("5")){ %>									
								<a href="javascript:Anc_Open1('<%=a_bean.getBbs_id()%>','<%=acar_id%>')" id="bbs_<%=a_bean.getBbs_id()%>" >
								<%}else{ %>
								<a href="javascript:Anc_Open('<%=a_bean.getBbs_id()%>','<%=acar_id%>')" id="bbs_<%=a_bean.getBbs_id()%>" >
								<%}%>
								<!--제목-->
								<span class="ancTableTitle">
								&nbsp;&nbsp;<%=Util.subData(String.valueOf(a_bean.getTitle()),35)%>
								</span>
								<!--중요 처리 -->
								<%if(a_bean.getImpor_yn().equals("Y")){%>
								&nbsp;
								<img alt="icon-star" src="/images/icon_star.png">
								<%} %>
								<!--필독 처리 -->
								<%if(a_bean.getRead_yn().equals("Y")){%>
								&nbsp;								  									  	
								<span style="font-size:15px; background-color:rgba(238, 34, 0, 0.81);border-radius:2px; color:white;">
									<span style="font-size:11px;vertical-align:top;">&nbsp;필독&nbsp;</span>
								</span>								  	
							  	<%}%>	
							  	<!-- New 처리 -->
							  	<%if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>
							  	&nbsp;								  	
						  		<span style="font-size:15px; background-color:rgba(0, 51, 255, 0.81);border-radius:2px; color:white;">
							  		<span class="blink" style="font-size:11px;vertical-align:top; font-weight: bold; ">&nbsp;New&nbsp;</span>
							  	</span> 
						  		<%}%>						  											  		
								</a>							
								<br>
							 	&nbsp;&nbsp;<span class="ancTableDate"><%=a_bean.getReg_dt()%></span>&nbsp;
							 	<span class="ancTableName"><%=a_bean.getUser_nm()%></span>
							</td>
   						</tr>												
   						<%		if(i==a_r2.length-1){%>
   						<%		}else{%>
   						<!-- 줄간바 -->
   						<tr>
   							<td style="border-bottom: 1px solid #ded8d8; height:2px;"></td>
   						</tr>
   						<%		}%>   			
   						<%	}%>
   				
						<%	if(count_gong>a_r2.length){
								for(int i=a_r2.length+1; i<count_gong; i++){
						%>	
   						<tr>
    						<td style="font-size:15px;">
    							<span style="color:black;">&nbsp;</span>
							</td>
   						</tr>   	
   						<%			if(i==count_gong-1){%>
   						<%			}else{%>
   						<tr>
   							<td></td>
   						</tr>   						
   						<%			}%>
						<%		}
	  						}
	  					%>   				
					</table>										
				</div>
			</div>
			
			<!--판매조건-->
			<div id = "anc_div3" style="float:left; width:510px; height:<%=52+(count_gong*42)%>px; border:1px solid #dcdcdc; border-left: 0px; ">
				<div style="float:left; background-color:#88c6c1; width:55px; height:52px;text-align:center;">
					<span class="icon-cab ficonS2"></span>
				</div>
				<div style="float:left; width:400px; height:52px; ">
					<span class="ancTitle">판매조건</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<a class="page-link" href="/fms2/off_anc/anc_s_grid_frame.jsp" param="FMS운영관리:공지사항:판매조건"><span class="icon-plus panPlus" ></span></a>
				</div>
				<div style="clear:both;  width:490px; height:52px; border-top:1px solid #dcdcdc; padding:10px;">
					<table id="bigPan" style="line-height:18px; width:490px;">
						<%	
							//if(a_r3.length > 6){
							//	count_pan = 6;
							//}else{
								count_pan = a_r3.length;
							//}
						
							for(int i=0; i<count_pan; i++){						 	
						    	a_bean = a_r3[i];						
						%>
   						<tr>
    						<td style="font-size:15px;">
    							<span style="color:black;">
		  							<a href="javascript:Anc_Open('<%=a_bean.getBbs_id()%>','<%=acar_id%>')" id="bbs_<%=a_bean.getBbs_id()%>" >
		  							<span class="ancTableTitle">
		  							<!--제목-->&nbsp;&nbsp;<%=Util.subData(String.valueOf(a_bean.getTitle()),35)%><!--작성자-->&nbsp;
									</span>
								  	<%if(a_bean.getRead_yn().equals("Y")){//필독 처리%>		  				
		  							&nbsp;<span style="font-size:15px; background-color:rgba(238, 34, 0, 0.81);border-radius:2px; color:white;">
									<span style="font-size:11px;vertical-align:top;">&nbsp;필독&nbsp;</span></span>		  	
		  							<%}%>
		  							<!-- New 처리 -->
		  							<%if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>		  		
		  							&nbsp;<span style="font-size:15px; background-color:rgba(0, 51, 255, 0.81);border-radius:2px; color:white;">
			  							<span class="blink" style="font-size:11px;vertical-align:top; font-weight: bold; ">&nbsp;New&nbsp;</span></span> 
		  							<%}%>		  		
		  							</a>
		  							<br>
							 		&nbsp;&nbsp;<span class="ancTableDate"><%=a_bean.getReg_dt()%></span>&nbsp;
							 		<span class="ancTableName"><%=a_bean.getUser_nm()%></span>		
								</span>
							</td>
   						</tr>   	
   						<%		if(i==a_r3.length-1){%>
   						<%		}else{%>   		   						
   						<tr>
   							<td style="border-bottom: 1px solid #ded8d8; height:2px;"></td>
   						</tr>
   						<%		}%>   	   	
						<%	}%>
						<%	if(count_gong>a_r3.length){
								for(int i=a_r3.length+1; i<count_gong; i++){
						%>
   						<tr>
    						<td style="font-size:15px;">
    							<span style="color:black;">&nbsp;</span>
							</td>
   						</tr>   	
   						<%			if(i==count_gong-1){%>
   						<%			}else{%>
   						<tr>
   							<td></td>
   						</tr>   						
   						<%			}%>
						<%		}
	  						}
	  					%>   			
					</table>										
				</div>
			</div>
		</div>
		<div style="width:1024px; height:<%=52+(7*26)%>px; margin:0 auto; margin-top:15px;">
			<!--미확인 입금사항-->
			<div style="float:left;  width:510px; height:<%=52+(7*26)%>px; border:1px solid #dcdcdc;">
				<div style="float:left;background-color:#8cc689;  width:55px; height:52px; text-align:center; ">
					<span class="icon-desktop ficonS3"></span>
				</div>
				<div style="float:left;  width:400px; height:52px; ">
					<span class="ancTitle">BANK 미확인 입금사항</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<a  class="page-link" href="/fms2/account/unconfirm_s_frame.jsp" param="FMS운영관리:공지사항:미확인입금사항"><span class="icon-plus bankPlus"></span></a>
				</div>
				<div style="clear:both;  width:470px; height:52px; border-top:1px solid #dcdcdc;padding:10px;">
					<table style="line-height: 23px;">
						<%	for(int i = 0 ; i < incom_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);								
								StringTokenizer st = new StringTokenizer(String.valueOf(ht.get("BANK_NM")),":");
								int s=0; 
								while(st.hasMoreTokens()){
									value[s] = st.nextToken();
									s++;						
								}
						%>
						<tr>
			 				<td style="font-size:15px;">
		  						<a  href="javascript:MM_openBrWindow('/fms2/account/unconfirm_reply.jsp?auth_rw=<%=auth_rw%>&incom_dt=<%=ht.get("INCOM_DT")%>&incom_seq=<%=ht.get("INCOM_SEQ")%>&incom_amt=<%=ht.get("INCOM_AMT")%>','Reply','scrollbars=no,status=yes,resizable=yes,width=450,height=220,left=50, top=50')">
		  						<span class="grayDate"> <!--거래일자--><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%>&nbsp;&nbsp;</span>
		  						<span class="blackTitle" style="color:#545454;">
		  							<!--적요--><%=Util.subData(String.valueOf(ht.get("REMARK")), 15)%>&nbsp;
		  							<!--금액--><%=Util.parseDecimal(String.valueOf(ht.get("INCOM_AMT")))%>
								</span>
								<!-- New 처리 -->
	  							<%if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>	  					
	  							<span style="font-size:15px; background-color:rgba(0, 51, 255, 0.81);border-radius:2px; color:white;">
		  							<span class="blink" style="font-size:11px;vertical-align:top; font-weight: bold; ">&nbsp;New&nbsp;</span>
		  						</span> 
	  							<%}%>	  		
								</a>
							</td>
   						</tr>
						<%	}%>
					</table>
				</div>
			</div>
			<!--업그레이드 정보-->
			<div style="float:left; width:510px; height:<%=52+(7*26)%>px; border:1px solid #dcdcdc; border-left: 0px; ">
				<div style="float:left; background-color:#b4c688; width:55px; height:52px; text-align:center;">
					<span class="icon-upload ficonS4"></span>
				</div>
				<div style="float:left; width:400px; height:52px; ">
						<span class="ancTitle">제안완료</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<!-- <a class="page-link" href="/fms2/off_anc/upgrade_frame.jsp" param="FMS운영관리:공지사항:업그레이드정보"><span class="icon-plus upPlus"></span></a> -->
				</div>
				<div style="clear:both;  width:470px; height:52px; border-top:1px solid #dcdcdc; padding:10px;">
					<table style="line-height:23px;">
						<%	
							if(a_r4.length > 7){
								count_up = 7;
							}else{
								count_up = a_r4.length;
							}
					
							if(count_up > 7){
								count_up = 7;
							}
							
							
							count_up = 0;
							
					
							for(int i=0; i<count_up; i++){					 	
						    	a_bean = a_r4[i];						
								if(a_bean.getBbs_st().equals("7")){
						%>
						<tr>
							<td style="font-size:15px;">
    							<a href="javascript:Anc_Open('<%=a_bean.getBbs_id()%>','<%=acar_id%>')" id="bbs_<%=a_bean.getBbs_id()%>" >
    								<span class="grayDate"> <%=a_bean.getReg_dt()%>&nbsp;&nbsp;</span>
		   							<span class="blackTitle" style="color:#545454;"><!--제목--><%=Util.subData(String.valueOf(a_bean.getTitle()),20)%><!--작성자-->&nbsp;</span>
		  							<span style="color:black;">
		  								<%if(a_bean.getRead_yn().equals("Y")){//필독 처리%>		  						
		  								<span style="font-size:15px; background-color:rgba(238, 34, 0, 0.81);border-radius:2px; color:white;">
										<span style="font-size:11px;vertical-align:top;">&nbsp;필독&nbsp;</span></span>
		  								<%}%>		
									</span>
									<!-- New 처리 -->
							  		<%if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>							  	
						  			<span style="font-size:15px; background-color:rgba(0, 51, 255, 0.81);border-radius:2px; color:white;">
						  				<span class="blink" style="font-size:11px;vertical-align:top; font-weight: bold; ">&nbsp;New&nbsp;</span>
						  			</span> 
							  		<%}%>
							  		<!-- New 처리 끝 -->
								</a>
							</td>
   						</tr>
						<%			
								}
							}
						%>
						<!-- 제안완료건 -->
						<%	
							if(count_up >= 7){
								p_vt_size = 0;
							}else{
								if( p_vt_size > 7-count_up){
									p_vt_size = 7-count_up;
								}
							}					
							for(int i = 0 ; i < p_vt_size ; i++){
								Hashtable ht = (Hashtable)p_vt.elementAt(i);
						%>
						<tr>
							<td style="font-size:15px;">
							    <a href="javascript:PropDisp('<%=ht.get("PROP_ID")%>', '')" onMouseOver="window.status=''; return true">
    								<span class="grayDate"> <%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXP_DT")))%>&nbsp;&nbsp;</span>
		   							<span class="blackTitle" style="color:#545454;" title='<%=ht.get("TITLE")%>'><!--제목"[제안완료]"+--><%=AddUtil.substringbdot(String.valueOf(ht.get("TITLE")),45)%>&nbsp;</span>
							    </a>		   						
							</td>
   						</tr>							
						<%	} %>
					</table>
				</div>
			</div>
		</div>
		
		<div style="width:1024px; height:70px; margin:0 auto; margin-top:15px;">
			<div style="float:left; width:255px; height:70px; background-color:#f1f5f4; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; text-align:center;">
				<a href="/acar/estimate_mng/esti_spe_hp_grid_big_frame.jsp">
						<span class="smartTitle2">스마트견적</span>
						<span class="smartGun2"><%=spe_cnt%></span>
						<span class="smartTitle2">건</span>
				</a>
			</div>
			<div style="float:left; width:255px; height:70px; background-color:#f1f5f4; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; text-align:center;">
				<a href="/fms2/biz_tel_mng/guest_frame.jsp">
						<span class="smartTitle2">고객상담요청</span>
						<span class="smartGun2"><%=gst_cnt%></span>
						<span class="smartTitle2">건</span>
				</a>
			</div>
			<%-- <div style="float:left; width:203px; height:70px; background-color:#f1f5f4; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; text-align:center;">
						<a href="/acar/estimate_mng/esti_spe_hp_grid_big_frame.jsp?gubun2=2">
							<span class="smartTitle2">월렌트견적</span>
							<span class="smartGun2"><%=mr_cnt%></span>
							<span class="smartTitle2">건</span>
						</a>
			</div> --%>
			<div style="float:left; width:255px; height:70px; background-color:#f1f5f4; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; text-align:center;">
						<a href="/acar/secondhand/sh_res_frame.jsp?gubun3=2&gubun4=0">
							<span class="smartTitle2">월렌트예약</span>
							<span class="smartGun2"><%=pc_mr_cnt%></span>
							<span class="smartTitle2">건</span>
						</a>
			</div>
			<%-- <div style="float:left; width:255px; height:70px; background-color:#f1f5f4;text-align:center; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; ">
				<a href=javascript:Memo('<%=acar_id%>',''); title=''>
						<span class="smartTitle2">메모</span>
						<span class="smartGun2"><%=bns.length%></span>
						<span class="smartTitle2">건</span>
				</a>
			</div> --%>
			<div style="float:left; width:255px; height:70px; background-color:#f1f5f4;text-align:center; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; ">
				<a href=javascript:go_pur_pre(); title=''>
						<span class="smartTitle2">전기차 등 출고예정차량 보기</span>
				</a>
			</div>
		</div>
		
		<%if( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("통계관리담당자",ck_acar_id)){%>
		<div style="width:1024px; height:40px; margin:0 auto; margin-top:5px;text-align:right;">
			<div style="float:left; width:255px; height:40px; background-color:#fde8de; border-top:1px solid #ff6508;border-bottom:1px solid #ff6508; text-align:center;">
						<span class="smartTitle3">보유차량</span>
						<span class="smartGun3"><%=hp_var[0].getVar_sik()%></span>
						<span class="smartTitle3">대</span>
			</div>
			<div style="float:left; width:255px; height:40px; background-color:#fde8de; border-top:1px solid #ff6508;border-bottom:1px solid #ff6508; text-align:center;">
						<span class="smartTitle3">보유자산</span>
						<span class="smartGun3"><%=hp_var[1].getVar_sik()%></span>
						<span class="smartTitle3">억</span>
			</div>
			<div style="float:left; width:255px; height:40px; background-color:#fde8de; border-top:1px solid #ff6508;border-bottom:1px solid #ff6508; text-align:center;">
							<span class="smartTitle3">장기렌트 고객사</span>
							<span class="smartGun3"><%=hp_var[2].getVar_sik()%></span>
							<span class="smartTitle3">개</span>
			</div>
			<div style="float:left; width:255px; height:40px; background-color:#fde8de;text-align:center; border-top:1px solid #ff6508;border-bottom:1px solid #ff6508; ">
						<!-- 
						<span class="smartTitle3">동종업계</span>
						<span class="smartGun3"><%=hp_var[3].getVar_sik()%></span>
						<span class="smartTitle3">년간</span>
						<span class="smartGun3"><%=hp_var[4].getVar_sik()%></span>
						<span class="smartTitle3">위 </span>
						 --> 
						<span class="smartGun3"><%=hp_var[3].getVar_sik()%></span>
						<span class="smartTitle3">년 외길 장기렌트 전문</span>
						
						<span class="smartGun3">
						&nbsp;&nbsp;&nbsp;
						<a href="javascript:open_update_var();"><span class="icon-plus updatePlus"></span></span></a>
		
		</div><span style="color:#545454; font:12Px Nanum Gothic;font-weight:bold;">(<%=hp_var[0].getA_j()%> 기준) &nbsp;<br>&nbsp;<br></span>
			
		</div>
			<%}%>
			
					<%}else{%>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<%}%>

		
	</div>
	<script>

</script>
	
</body>
</html>