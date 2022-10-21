<%@ page language="java" contentType="text/html; charset=euc-kr" %>
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
	AncBean a_r [] = oad.getAncAll(request,acar_id);
	//공지사항
	AncBean a_r2 [] = oad.getAncAll(request,acar_id,"gong");
	if(a_r2.length > 6){
		count_gong = 6;
	}else{
		count_gong = a_r2.length;
	}
	AncBean a_r3 [] = oad.getAncAll(request,acar_id,"pan");
	AncBean a_r4 [] = oad.getAncAll(request,acar_id,"up");
	a_bean = oad.getAncLastBean();
	
	Vector vt =  a_db.getIncomListChk("2", "Y", "1", "", "");
	int incom_size = vt.size();
	
	String value[] = new String[2];	

	//최대5개
	if(incom_size > 5) incom_size=5;
	
	//스마트견적 대기건수
	int spe_cnt = 0;
	int ars_cnt = 0;
	int mr_cnt = 0;
	int gst_cnt = 0;
	if( !isExtStaff ){
		EstiDatabase e_db = EstiDatabase.getInstance();
		spe_cnt = e_db.getSpeEstiCnt();
		ars_cnt = e_db.getSpeEstiArsCnt();
		mr_cnt = e_db.getMrentEstiCnt();
		gst_cnt = e_db.getGustEstiCnt();
	}
	//메모
	//미수신된 메모확인
	MemoBean[] bns = memo_db.getRece_n_List(acar_id);
	
	
%>
<html>
<head>
<title>:: FMS(Fleet Management System) ::</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/sub.css">
<link href="http://fms1.amazoncar.co.kr/fms2/menu/fontello-embedded.css " rel="stylesheet" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script>
<!--
//리플달기
	function Anc_Open(bbs_id,acar_id){


		var SUBWIN="/fms2/off_anc/anc_se_c.jsp?bbs_id="+bbs_id+"&acar_id="+acar_id;	
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
	
//전기차 등 출고예정차량 보기 추가(20190306)
	function go_pur_pre(){
		location.href = '/fms2/pur_com_pre/pur_pre_frame.jsp?ready_car=Y';
	}
	
	$( document ).ready(function() {

    if(screen.height<=900){
    	$('#smallAnc').css('display','block');
    	$('#bigAnc').css('display','none');
    	$('#smallPan').css('display','block');
    	$('#bigPan').css('display','none');
    	$('#anc_div').css('height','230px');
    	$('#anc_div2').css('height','230px');
    	$('#anc_div3').css('height','230px');
    	
    }

	});
	
//-->
</script>
<style>

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
	color:#545454; font:15Px/90px Nanum Gothic; cursor:pointer;font-weight:bold;
}
.smartGun2{
	color:#1ab300; font:20Px/90px Nanum Gothic; cursor:pointer;font-weight:bold;
}

</style>
<body style="height:85%;">
	
	<div style="width:100%;height:100%;">
		<div id = "anc_div" style="width:1024px; height:390px; margin:0 auto;">
			<!--공지사항-->
			<div id = "anc_div2" style="float:left;  width:510px; height:390px; border:1px solid #dcdcdc;">
				<div style="float:left;background-color:#88acc6;  width:55px; height:52px; text-align:center;">
					<span class="icon-volume-down ficonS"></span>
				</div>
				<div style="float:left;  width:400px; height:52px; ">
					<span class="ancTitle">공지사항</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<a href="/fms2/off_anc/anc_s_grid_frame.jsp"><span class="icon-plus ancPlus"></span></a>
				</div>
				<div style="clear:both;  width:490px; border-top:1px solid #dcdcdc; padding:10px;">
					<table id = "bigAnc" style="line-height:18px; width:490px;">
						<%	
							
							
							for(int i=0; i< count_gong; i++){
						 	
						    a_bean = a_r2[i];
							
						%>
							<tr>
						    	<td style="font-size:15px;">
									<%if(a_bean.getBbs_st().equals("5")){ %>
									
										<a href="javascript:Anc_Open('<%=a_bean.getBbs_id()%>','<%=acar_id%>')" id="bbs_<%=a_bean.getBbs_id()%>" >
									<%}else{ %>
										<a href="javascript:Anc_Open('<%=a_bean.getBbs_id()%>','<%=acar_id%>')" id="bbs_<%=a_bean.getBbs_id()%>" >
									<%}%>
								  
						
					
								  <!--제목-->
								  <span class="ancTableTitle">
								  &nbsp;&nbsp;<%=Util.subData(String.valueOf(a_bean.getTitle()),35)%>
								  </span>
								  <!-- 		  중요 처리 -->
								  <%if(a_bean.getImpor_yn().equals("Y")){%>
								  	<img alt="icon-star" src="/images/icon_star.png">
								  <%} %>
								  <!-- 		  필독 처리 -->
								  <%if(a_bean.getRead_yn().equals("Y")){%>
								  	
								  		<img src="/images/n_icon.gif" border=0 align=absmiddle />&nbsp;
							  		<%}%>		
								</a>
							</span>
							<br>
							 &nbsp;&nbsp;<span class="ancTableDate"><%=a_bean.getReg_dt()%></span>&nbsp;
							 <span class="ancTableName"><%=a_bean.getUser_nm()%></span>
								</td>
   				</tr>
   				<%if(i==count_gong-1){%><%}else{%>
   				<tr>
   					<td></td>
   				</tr>
   				<tr>
   					<td style="border-bottom: 1px solid #ded8d8;"></td>
   				</tr>
   				<tr>
   					<td></td>
   				</tr>
   				<%}%>
   			
   				<%}%>
					</table>
					
					<table id = "smallAnc" style="line-height:18px; width:490px; display:none;">
						<%	
							if(a_r2.length > 3){
								count_gong = 3;
							}else{
								count_gong = a_r2.length;
							}
							
							for(int i=0; i< count_gong; i++){
						 	
						    a_bean = a_r2[i];
							
						%>
							<tr>
						    	<td style="font-size:15px;">
									<%if(a_bean.getBbs_st().equals("5")){ %>
									
										<a href="javascript:Anc_Open('<%=a_bean.getBbs_id()%>','<%=acar_id%>')" id="bbs_<%=a_bean.getBbs_id()%>" >
									<%}else{ %>
										<a href="javascript:Anc_Open('<%=a_bean.getBbs_id()%>','<%=acar_id%>')" id="bbs_<%=a_bean.getBbs_id()%>" >
									<%}%>
								  
						
					
								  <!--제목-->
								  <span class="ancTableTitle">
								  &nbsp;&nbsp;<%=Util.subData(String.valueOf(a_bean.getTitle()),35)%>
								  </span>
								  <!-- 		  중요 처리 -->
								  <%if(a_bean.getImpor_yn().equals("Y")){%>
								  	<img alt="icon-star" src="/images/icon_star.png">
								  <%} %>
								  <!-- 		  필독 처리 -->
								  <%if(a_bean.getRead_yn().equals("Y")){%>
								  	
								  		<img src="/images/n_icon.gif" border=0 align=absmiddle />&nbsp;
							  		<%}%>		
								</a>
							</span>
							<br>
							 &nbsp;&nbsp;<span class="ancTableDate"><%=a_bean.getReg_dt()%></span>&nbsp;
							 <span class="ancTableName"><%=a_bean.getUser_nm()%></span>
								</td>
   				</tr>
   				<%if(i==count_gong-1){%><%}else{%>
   				<tr>
   					<td></td>
   				</tr>
   				<tr>
   					<td style="border-bottom: 1px solid #ded8d8;"></td>
   				</tr>
   				<tr>
   					<td></td>
   				</tr>
   				<%}%>
   			
   				<%}%>
					</table>
				</div>
			</div>
			<!--판매조건-->
			<div id = "anc_div3" style="float:left; width:510px; height:390px; border:1px solid #dcdcdc; border-left: 0px; ">
				<div style="float:left; background-color:#88c6c1; width:55px; height:52px;text-align:center;">
					<span class="icon-cab ficonS2"></span>
				</div>
				<div style="float:left; width:400px; height:52px; ">
					<span class="ancTitle">판매조건</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<a href="/fms2/off_anc/anc_s_grid_frame.jsp"><span class="icon-plus panPlus"></span></a>
				</div>
				<div style="clear:both;  width:490px; height:52px; border-top:1px solid #dcdcdc; padding:10px;">
					<table id="bigPan" style="line-height:18px; width:490px;">
						<%	
							if(a_r3.length > 6){
								count_pan = 6;
							}else{
								count_pan = a_r3.length;
							}
							
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
		  <%if(a_bean.getRead_yn().equals("Y")){//필독 처리%><b><img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%>		
		  </a>	<br>
							 &nbsp;&nbsp;<span class="ancTableDate"><%=a_bean.getReg_dt()%></span>&nbsp;
							 <span class="ancTableName"><%=a_bean.getUser_nm()%></span>
		
	</span>
		</td>
   	</tr>
   	
   		<%if(i==count_pan-1){%><%}else{%>
   				<tr>
   					<td></td>
   				</tr>
   				<tr>
   					<td style="border-bottom: 1px solid #ded8d8;"></td>
   				</tr>
   				<tr>
   					<td></td>
   				</tr>
   				<%}%>
   	
<%	
	}%>
					</table>
					
					<table id="smallPan" style="line-height:18px; width:490px; display:none;">
						<%	
							if(a_r3.length > 3){
								count_pan = 3;
							}else{
								count_pan = a_r3.length;
							}
							
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
		  <%if(a_bean.getRead_yn().equals("Y")){//필독 처리%><b><img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%>		
		  </a>	<br>
							 &nbsp;&nbsp;<span class="ancTableDate"><%=a_bean.getReg_dt()%></span>&nbsp;
							 <span class="ancTableName"><%=a_bean.getUser_nm()%></span>
		
	</span>
		</td>
   	</tr>
   	
   		<%if(i==count_pan-1){%><%}else{%>
   				<tr>
   					<td></td>
   				</tr>
   				<tr>
   					<td style="border-bottom: 1px solid #ded8d8;"></td>
   				</tr>
   				<tr>
   					<td></td>
   				</tr>
   				<%}%>
   	
<%	
	}%>
					</table>
				</div>
			</div>
		</div>
		<div style="width:1024px; height:230px; margin:0 auto; margin-top:15px;">
			<!--미확인 입금사항-->
			<div style="float:left;  width:510px; height:230px; border:1px solid #dcdcdc;">
				<div style="float:left;background-color:#8cc689;  width:55px; height:52px; text-align:center; ">
					<span class="icon-desktop ficonS3"></span>
				</div>
				<div style="float:left;  width:400px; height:52px; ">
					<span class="ancTitle">BANK 미확인 입금사항</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<a href="/fms2/account/unconfirm_s_frame.jsp"><span class="icon-plus bankPlus"></span></a>
				</div>
				<div style="clear:both;  width:470px; height:52px; border-top:1px solid #dcdcdc;padding:20px;">
					<table style="line-height: 23px;">
						<%	for(int i = 0 ; i < incom_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								StringTokenizer st = new StringTokenizer(String.valueOf(ht.get("BANK_NM")),":");
								int s=0; 
								while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}%>
									<tr>
			 <td style="font-size:15px;">
		  <a  href="javascript:MM_openBrWindow('/fms2/account/unconfirm_reply.jsp?auth_rw=<%=auth_rw%>&incom_dt=<%=ht.get("INCOM_DT")%>&incom_seq=<%=ht.get("INCOM_SEQ")%>&incom_amt=<%=ht.get("INCOM_AMT")%>','Reply','scrollbars=no,status=yes,resizable=yes,width=450,height=220,left=50, top=50')">
		  <span class="grayDate"> <!--거래일자--><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%>&nbsp;&nbsp;</span>
		  <span class="blackTitle" style="color:#545454;">
		  <!--적요--><%=Util.subData(String.valueOf(ht.get("REMARK")), 15)%>&nbsp;
		  <!--금액--><%=Util.parseDecimal(String.valueOf(ht.get("INCOM_AMT")))%>
			</span>
		</a>
		</td>
   	</tr>
<%	}%>
					</table>
				</div>
			</div>
				<!--업그레이드 정보-->
			<div style="float:left; width:510px; height:230px; border:1px solid #dcdcdc; border-left: 0px; ">
				<div style="float:left; background-color:#b4c688; width:55px; height:52px; text-align:center;">
					<span class="icon-upload ficonS4"></span>
				</div>
				<div style="float:left; width:400px; height:52px; ">
						<span class="ancTitle">FMS 업그레이드 정보</span>
				</div>
				<div style="float:left;  width:47px; height:52px; ">
					<a href="/fms2/off_anc/upgrade_frame.jsp"><span class="icon-plus upPlus"></span></a>
				</div>
				<div style="clear:both;  width:470px; height:52px; border-top:1px solid #dcdcdc; padding:20px;">
					<table style="line-height:23px;">
						<%	
						
							if(a_r4.length > 5){
								count_up = 5;
							}else{
								count_up = a_r4.length;
							}
								for(int i=0; i<count_up; i++){
						 	
						    a_bean = a_r4[i];

								
								if(a_bean.getBbs_st().equals("7")){%>
				<td style="font-size:15px;">
    		<a href="javascript:Anc_Open('<%=a_bean.getBbs_id()%>','<%=acar_id%>')" id="bbs_<%=a_bean.getBbs_id()%>" >
    	<span class="grayDate"> <%=a_bean.getReg_dt()%>&nbsp;&nbsp;</span>
		   <span class="blackTitle" style="color:#545454;"><!--제목--><%=Util.subData(String.valueOf(a_bean.getTitle()),25)%><!--작성자-->&nbsp;</span>
		  <span style="color:black;">
		  <%if(a_bean.getRead_yn().equals("Y")){//필독 처리%><b><img src="/images/n_icon.gif" border=0 align=middle>&nbsp;<%}%>		
			</span>
		</a>
		</td>
   	</tr>
<%			
		}
	}%>
					</table>
				</div>
			</div>
		</div>
		
		<div style="width:1024px; height:90px; margin:0 auto; margin-top:15px;">
			<div style="float:left; width:255px; height:90px; background-color:#f1f5f4; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; text-align:center;">
				<a href="/acar/estimate_mng/esti_spe_hp_frame.jsp">
						<span class="smartTitle2">스마트견적</span>
						<span class="smartGun2"><%=spe_cnt%></span>
						<span class="smartTitle2">건</span>
				</a>
			</div>
			<div style="float:left; width:255px; height:90px; background-color:#f1f5f4; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; text-align:center;">
				<a href="/fms2/biz_tel_mng/guest_frame.jsp">
						<span class="smartTitle2">고객상담요청</span>
						<span class="smartGun2"><%=gst_cnt%></span>
						<span class="smartTitle2">건</span>
				</a>
			</div>
			<div style="float:left; width:255px; height:90px; background-color:#f1f5f4; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; text-align:center;">
						<a href="/acar/estimate_mng/esti_spe_hp_frame.jsp">
							<span class="smartTitle2">월렌트견적</span>
							<span class="smartGun2"><%=mr_cnt%></span>
							<span class="smartTitle2">건</span>
						</a>
			</div>
			<%-- <div style="float:left; width:255px; height:90px; background-color:#f1f5f4;text-align:center; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; ">
				<a href=javascript:Memo('<%=acar_id%>',''); title=''>
						<span class="smartTitle2">메모</span>
						<span class="smartGun2"><%=bns.length%></span>
						<span class="smartTitle2">건</span>
				</a>
			</div> --%>
			<div style="float:left; width:255px; height:90px; background-color:#f1f5f4;text-align:center; border-top:1px solid #1ab300;border-bottom:1px solid #1ab300; ">
				<a href=javascript:go_pur_pre(); title=''>
						<span class="smartTitle2">전기차 등 출고예정차량 보기</span>
				</a>
			</div>
		</div>
	</div>
	
	
</body>
</html>