<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ea_bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");//0606J0366
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	String mobile_yn	= request.getParameter("mobile_yn")	==null?"0":request.getParameter("mobile_yn");
	String mail_yn		= request.getParameter("mail_yn")	==null?"0":request.getParameter("mail_yn");
	
	
	//차명 길이 계산
	int car_nm_length=0;
	//유효기간
	String vali_date = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	EstiDatabase e_db = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//잔가 차량정보
	Hashtable sh_comp = new Hashtable();
	//견적 확인정보
	Hashtable exam = new Hashtable();
	
	if (from_page.equals("/acar/estimate_mng/./images/line.gif")) {
		from_page = "/acar/estimate_mng/esti_mng_u.jsp";
	}
	
	if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		e_bean 		= e_db.getEstimateCase(est_id);
		sh_comp 	= shDb.getShCompare(est_id);
		exam 			= shDb.getEstiExam(est_id);
		vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 9));
	}else{
		e_bean 		= e_db.getEstimateHpCase(est_id);
		sh_comp 	= shDb.getShCompareHp(est_id);
		exam 			= shDb.getEstiExamHp(est_id);
	}
	
	//홈페이지견적서는 기본식일 경우 매입옵션 부여로 본다.
	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")) e_bean.setOpt_chk("1");
	
	if(e_bean.getOpt_chk().equals("1") && opt_chk.equals("0")) 	opt_chk 	= e_bean.getOpt_chk();
	
	
	String a_a = "";
	String rent_way = "";
	if(!e_bean.getA_a().equals("")){
		a_a 		= e_bean.getA_a().substring(0,1);
		rent_way 	= e_bean.getA_a().substring(1);
	}
	String a_b 		= e_bean.getA_b();
	float o_13 		= 0;
	
	//변수기준일자 조회
	String em_b_dt = e_db.getVar_b_dt("em", e_bean.getRent_dt());
	
	//공통변수
	EstiCommVarBean em_bean = e_db.getEstiCommVarCase(a_a,  "", em_b_dt);
	
	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String a_e = cm_bean2.getS_st();
	
	// 단산 차종일 경우 1.대여차량 하단에 문구 추가 작업		2017-11-07
	boolean endDt = false;
	if(e_bean.getCar_id().length() > 0 && e_bean.getCar_seq().length() > 0){
		if(e_db.getEndDtEstimate(e_bean.getCar_id(), e_bean.getCar_seq()).equals("N")){
			endDt = true;
		}
	}
	
	//차종변수
	ea_bean = e_db.getEstiCarVarCase(a_e, a_a, "");
	
	//차종코드변수
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());		
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);
	
	if(a_b.equals("12")) 		o_13 = ea_bean.getO_13_1();
	else if(a_b.equals("18")) 	o_13 = ea_bean.getO_13_2();
	else if(a_b.equals("24")) 	o_13 = ea_bean.getO_13_3();
	else if(a_b.equals("30")) 	o_13 = ea_bean.getO_13_4();
	else if(a_b.equals("36")) 	o_13 = ea_bean.getO_13_5();
	else if(a_b.equals("42")) 	o_13 = ea_bean.getO_13_6();
	else if(a_b.equals("48")) 	o_13 = ea_bean.getO_13_7();
	
	
	String name = "";
	String tel = "";
	
	String week_st = c_db.getWeek_st(AddUtil.getDate());  //1:일요일 , 7:토요일
	int hol_cnt = c_db.getHoliday_st(AddUtil.getDate());  //휴일
	
	
//	근무시간내:08:30~20:30 회사전화번호 그후 개인전화번호:서울본사인경우. 지점은 지점번호 노출 
   	int t_time = Integer.parseInt(AddUtil.getTime().substring(11,13) + AddUtil.getTime().substring(14,16)) ;
   	
   	String watch_id = c_db.getWatch_id(AddUtil.getDate() );  // 본사 인터넷 당직
		
	String br_id = "S1";
	
	//default :서울본사 전화번호
	String check = "C";
	
	if (week_st.equals("1")  || week_st.equals("7") || hol_cnt > 0 ) {
		check = "P";
	} else  {
		if ( t_time >= 801 && t_time <= 2001 ){
			check = "C";
		} else {
		    check = "P";
		}
	}
	
	
	if ( check.equals("C")){
		name = "";
		tel =  "02-757-0802";
	} else {
		
		name = "";
		tel =  "02-392-4242";
		
	}
	
	UsersBean user_bean 	= new UsersBean();
	
	if(!acar_id.equals("")){
		user_bean 	= umd.getUsersBean(acar_id);
		name 	= user_bean.getUser_nm();
		tel 	= user_bean.getUser_m_tel();
		br_id   = user_bean.getBr_id();
	}
	
	String temp_reg_dt = e_bean.getReg_dt();
    String result_reg_dt = "";
    if (temp_reg_dt.equals("") || temp_reg_dt == null) {
        SimpleDateFormat dt_format = new SimpleDateFormat("yyyyMMddHHmm");
        String temp_today = String.valueOf(dt_format.format(new Date()));
        result_reg_dt = temp_today.substring(0, temp_today.length()-2);
    } else {
        result_reg_dt = temp_reg_dt.substring(0, temp_reg_dt.length()-2);
    }
    int ref_reg_dt = AddUtil.parseInt(result_reg_dt);
%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<title>견적서</title>
<style type="text/css">
<!--
.style1 {
	color: #dc0039;
	font-weight: bold;
	font-size: 22px;
}
.style2 {
	color: #706f6f;
	font-weight: bold;
}
.style3 {
	color: #333333;
}
.style4 {color: #000000;}
.style5 {color: #444444;}
.style7 {color: #1c75ba; font-weight: bold;}
.style8 {color: #354a6d}
.style9 {color: #5f52a0}
.style12 {color: #9cb445; font-weight: bold; }
.style13 {
	color: #c4c4c4;
	font-weight: bold;
}
.style14 {color: #dc0039;font-weight: bold; }
.endDt {font-weight: bold; text-decoration: underline; font-size: 13px}
.esti-title{
	font-size: 16px;
	font-weight: 900;
	padding-bottom: 2px;
	border-bottom: 1px solid #abcd32;
}
.esti-num{
	font-size: 18px;
	color: #abcd32;
	margin-right: 5px;
	border-bottom: 3px solid #abcd32;
}
.esti-title-sub{
	font-size: 12px;
}
.page-separate{
	page-break-after: always
}
-->
</style>
<link href="/acar/main_car_hp/style_est.css" rel="stylesheet" type="text/css">
<script>
$(document).ready(function(){	
	var contiRatDesc = $('#contiRatDesc').text();
	var point = contiRatDesc.indexOf("(");
	if(point == -1){
		$('#contiRatDesc').text( contiRatDesc + "(복합연비기준)");
	}else{
		$('#contiRatDesc').text(contiRatDesc.substring(0,point) + "(복합연비기준)");
	}
	
})
</script>
<script language="JavaScript" type="text/JavaScript">

<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
	//비용비교보기
	function go_compare(est_id){
		var SUBWIN="./m_compare.jsp?est_id="+est_id+"&from_page=<%=from_page%>";	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=717, height=600, scrollbars=yes, status=yes");
	}

	//인쇄하기
	function go_print(est_id){		
		var fm = document.form1;
		fm.est_id.value = est_id;
// 		fm.action = "esti_print.jsp";
// 		fm.target = "_blank";
// 		fm.submit();		
		window.onbeforeprint = function(){
			document.getElementById('esti_button_tr').style.display = 'none';
		}
		
		window.onafterprint = function(){
			document.getElementById('esti_button_tr').style.display = 'table-row';
		}
		
		window.print();
	}	
	//메일수신하기
	function go_mail(est_id){
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&acar_id=<%=acar_id%>&write_id=<%=e_bean.getReg_id()%>&from_page=<%=from_page%>&opt_chk=<%=opt_chk%>&est_email=<%=e_bean.getEst_email()%>&content_st=hp";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=300, scrollbars=no, status=yes");
	}
	
	//준비서류보기
	function go_paper(){
		var SUBWIN="/acar/main_car_hp/papers.html";	
		window.open(SUBWIN, "openpaper", "left=50, top=50, width=573, height=770, status=no, scrollbars=no, resizable=no");
	}
	
	//기본사양보여주기
	function opt(est_id){  
		var fm = document.form1;
		var SUBWIN="opt.jsp?est_id="+est_id+"&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=760, height=480, scrollbars=yes, status=yes, resizable=no");
	}	
	
	// 항목 번호 세팅
	function setEstiNum(){
		var esti_num = document.getElementsByClassName('esti-num');
		var esti_count = 0;
		for(var i=0; i<esti_num.length; i++){
			esti_count++;
			esti_num[i].innerHTML = '0'+esti_count;
		}
	}
//-->
		
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
</head>
<body topmargin=0 leftmargin=0  onload='javascript:setEstiNum();'>
<form action="" name="form1" method="POST" >
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="est_id" value="<%=est_id%>">
<input type="hidden" name="acar_id" value="<%=acar_id%>">
<input type="hidden" name="mobile_yn" value="<%=mobile_yn%>">
<input type="hidden" name="content_st" value="hp">
<table width=680 border=0 cellspacing=0 cellpadding=0>
    <tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
    <tr>
        <td height=8 colspan=3></td>
    </tr>
    <tr>
        <td colspan=3><img src=./images/title.gif width=680 height=39></td>
    </tr>
    <tr>
        <td height=5 colspan=3></td>
    </tr>
    <tr>
        <td width=21>&nbsp;</td>
        <td width=638>
            <table width=638 border=0 cellspacing=0 cellpadding=0>
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellspacing=0 cellpadding=0>
            				<tr>
            		      <td colspan="3" height=17><div align="right"><span class=style2>
            		      	<%if(AddUtil.parseInt(AddUtil.getDate(4)) >= 20170930 && AddUtil.parseInt(AddUtil.getDate(4)) < 20171010){%>
            		      	2017-09-30
            		      	<%}else{%>
            			      <%=AddUtil.getDate()%>
            			      <%}%>
            			      </span>&nbsp;</div>
            			    </td>
            				</tr>
			                <tr> 
			                  	<td width=282> 
			                  		<table width=282 border=0 cellspacing=0 cellpadding=0>
			                      		<tr> 
			                        		<td height=35 colspan=2 valign=top>&nbsp;<span class=style1>[ <%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%> 
			                          	] </span></td>
			                      		</tr>
			                      		<tr> 
			                        		<td colspan=2><img src=./images/est_line.gif></td>
				                      	</tr>
				                      	<tr> 
				                        	<td width=24 height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        	<td width=258><div align="left"><span class=style2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;님 귀하</span></div></td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=2><img src=./images/est_line.gif></td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        	<td><span class=style2>TEL.</span></td>
				                        </tr>
				                        <tr> 
				                        	<td colspan=2><img src=./images/est_line.gif></td>
				                      	</tr>
				                        <tr>
				                        	<td height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        	<td><span class=style2>FAX.</span></td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=2><img src=./images/est_line.gif></td>
				                      	</tr>
			                    	</table>
			                    </td>
			                  	<td width=18>&nbsp;</td>
			                  	<td width=356 valign=bottom> 
			                  		<table width=356 border=0 cellpadding=0 cellspacing=0 background=./images/est_tel_bg.gif>
				                      	<tr> 
				                        	<td colspan=3 height=14></td>
				                      	</tr>
				                      	<tr> 
				                        	<td width=54 height=18></td>
				                        	<td width=155 class=listnum2><span class=style5>여의도영업부 <%if(br_id.equals("S1")){%><%= tel %><%= name %><%}else{%>02-757-0802<%}%></span></td>
				                      		<td width=147 class=listnum2><span class=style5>광화문지점 <%if(br_id.equals("S5")){%><%= tel %><%= name %><%}else{%>02-2038-8661<%}%></span></td>
				                      	</tr> 
				                      	<tr> 
				                        	<td height=18></td>
				                        	<td class=listnum2><span class=style5>강 남 지 점 &nbsp;&nbsp;&nbsp;<%if(br_id.equals("S2")){%><%= tel %><%= name %><%}else{%>02-537-5877<%}%></span></td>
				                        	<td class=listnum2><span class=style5>송 파 지 점 <%if(br_id.equals("S6")){%><%= tel %><%= name %><%}else{%>02-2038-2492<%}%></span></td>
				                      		
				                      	</tr> 
				                      	<tr> 
				                        	<td height=18></td>
				                        	<td class=listnum2><span class=style5>인 천 지 점 &nbsp;<%if(br_id.equals("I1")){%><%= tel %><%= name %><%}else{%>032-554-8820<%}%></span></td>
				                      		<td class=listnum2><span class=style5>수 원 지 점 <%if(br_id.equals("K3")){%><%= tel %><%= name %><%}else{%>031-546-8858<%}%></span></td>
				                      	</tr>  
				                      	<tr> 
				                        	<td height=18></td>
				                        	<td class=listnum2><span class=style5>대 전 지 점 &nbsp;<%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>042-824-1770<%}%></span></td>
				                      		<td class=listnum2><span class=style5>대 구 지 점 <%if(br_id.equals("G1")){%><%= tel %><%= name %><%}else{%>053-582-2998<%}%></span></td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=18></td>
				                        	<td class=listnum2><span class=style5>부 산 지 점 &nbsp;<%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>051-851-0606<%}%></span></td>
				                      		<td class=listnum2><span class=style5>광 주 지 점 <%if(br_id.equals("J1")){%><%= tel %><%= name %><%}else{%>062-385-0133<%}%></span></td>
				                      	</tr>                           	
				                      	<tr> 
				                        	<td colspan=2 height=12></td>
				                      	</tr>  
			                    	</table>
			                    </td>
			                </tr>
			                <tr> 
			                  	<td colspan="3" height="10"></td>
			                </tr>
			                <!-- <tr> 
			                  	<td colspan="3" height="17">&nbsp;※ 귀사에서 문의하신 장기대여에 대하여 아래와 같이 견적을 제출하오니 
			                    검토하시고 좋은 답변 부탁드립니다.</td>
			                </tr> -->
             	 		</table>
             	 	</td>
          		</tr>
          		<tr> 
            		<td height=10 colspan="2"></td>
          		</tr>
		    	<tr> 
		            <td colspan="2">
		            	<%if(e_bean.getEco_e_tag().equals("1")){ //맑은서울스티커발급 문구 조건변경(20190208)%>
		            	<%	//실등록지역 세팅
		            		int reg_loc_st = 0;	//default:서울
		            		if(ej_bean.getJg_g_7().equals("3")){//전기차
								if(e_bean.getEcar_loc_st().equals("0")){ //서울
								}else if(e_bean.getEcar_loc_st().equals("1")){ //인천,경기
								}else if(e_bean.getEcar_loc_st().equals("2")){ //강원 	
								}else if(e_bean.getEcar_loc_st().equals("3")){ //대전 
									reg_loc_st = 4;	//대전
								}else if(e_bean.getEcar_loc_st().equals("4")){ //광주,전남,전북	
								}else if(e_bean.getEcar_loc_st().equals("5")){ //대구
									reg_loc_st = 7;	//대구
								}else if(e_bean.getEcar_loc_st().equals("6")){ //부산,울산,경남
									reg_loc_st = 3;	//부산
								}else if(e_bean.getEcar_loc_st().equals("8")||e_bean.getEcar_loc_st().equals("9")){ //경북,울산/경남
									reg_loc_st = 7;	//대구
								}else if(e_bean.getEcar_loc_st().equals("10")){ //전남,전북(광주제외)
								}
		            		
								reg_loc_st = 0;	//20191031서울
		            		
							}else if(ej_bean.getJg_g_7().equals("4")){//수소차 
								if(e_bean.getHcar_loc_st().equals("0")){ //서울,경기
								}else if(e_bean.getHcar_loc_st().equals("1")){ //인천 
									reg_loc_st = 5;	//인천
								}else if(e_bean.getHcar_loc_st().equals("2")){ //강원
								}else if(e_bean.getHcar_loc_st().equals("3")){ //대전 
									if(e_bean.getA_a().equals("21")||e_bean.getA_a().equals("22")){ //렌트
									}else if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){ //리스
										reg_loc_st = 4;	//대전
									}
								}else if(e_bean.getHcar_loc_st().equals("4")){ //광주,전남,전북
									reg_loc_st = 6;	//광주
								}else if(e_bean.getHcar_loc_st().equals("5")){ //대구,경북
								}else if(e_bean.getHcar_loc_st().equals("6")){ //부산,울산,경남
									reg_loc_st = 2;	//부산
						  		}else if(e_bean.getHcar_loc_st().equals("7")){ //세종,충남,충북(대전제외)
						  		}	
							
								reg_loc_st = 5;	//20200410 인천
							}	
		            	%>
		            	<div style="position: relative;">
<!-- 							<img src=./images/bar_01.gif width=638 height=22> -->
							<div class='esti-title'><span class='esti-num'></span> 대여차량</div>
							<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))) > 0 ){%>
								<div style="font-size: 10.8px; padding-top: 7px;">
								※ 본 견적 차량가격은 개소세 3.5% 기준 차가로 개소세 5% 기준 환산 차량가격은 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))))%>원<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))) > 0 ){%>(친환경차 세제혜택 후 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))))%>원)<%}%> 정도입니다.
								</div>
							<%} %>
							<span style="position: absolute; top:0; right:0;">
								<%if(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){	//전기차,수소차%>
									<%if(reg_loc_st==0){ //실등록지가 서울 %>
										<!-- ※ 맑은서울스티커(남산터널 이용 전자태그) 발급 -->
									<%}else{ %>
										<!-- ※ 맑은서울스티커(남산터널 이용 전자태그) 발급불가 -->
									<%} %>
								<%}else if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")){ //전기차,수소차 이외 친환경차 %>
									<%if(reg_loc_st==0){ //실등록지가 서울 %>
										※ 맑은서울스티커(남산터널 이용 전자태그) 발급
									<%}else{ %>
										※ 맑은서울스티커(남산터널 이용 전자태그) 발급불가
									<%} %>
								<%} %>
							</span>
						</div>
						<%}else{%>
						<!-- <img src=./images/bar_01.gif width=638 height=22> -->
							<div style="position: relative;">
								<div class='esti-title'><span class='esti-num'></span> 대여차량</div>
								<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))) > 0 ){%>
									<div style="font-size: 10.8px; padding-top: 7px;">
									※ 본 견적 차량가격은 개소세 3.5% 기준 차가로 개소세 5% 기준 환산 차량가격은 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))))%>원<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))) > 0 ){%>(친환경차 세제혜택 후 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))))%>원)<%}%> 정도입니다.
									</div>
								<%} %>
								<span style="position: absolute; top:0; right:0;">
									<%-- <%if(ej_bean.getJg_2().equals("1")){	//전기차,수소차%>		
										[차량가격은 개별소비세 과세가격 기준]
									<%}%> --%>
									<%if(cm_bean.getDuty_free_opt().equals("0")){ %>
										[차량가격은 개별소비세 과세가격 기준]
									<%}else if(cm_bean.getDuty_free_opt().equals("1")){ %>
										[차량가격은 개별소비세 면세가격 기준]
									<%} %>
								</span>
							</div>
						<%}%>
		            </td>
		    	</tr>
		     	<tr> 
		            <td height=4 colspan="2"></td>
		    	</tr>
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
			                <tr> 
			                  	<td width=115 height=17 align=center bgcolor=f2f2f2><span class=style3>제조사</span></td>
			                  	<td width=419 bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4><%=cm_bean.getCar_comp_nm()%></span></td>
			                  	<td width=100 align=center bgcolor=f2f2f2><span class=style3>금 
			                    액</span></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>차종(차량모델명)</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style7
			                  		><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"
			                  		><%if(cm_bean.getCar_nm().equals(cm_bean.getCar_name())){ car_nm_length = cm_bean.getCar_nm().length();%>
			                  		<%=cm_bean.getCar_nm()%><%}else{ car_nm_length = cm_bean.getCar_nm().length()+cm_bean.getCar_name().length(); %>
			                  		<%=cm_bean.getCar_nm()+" "+cm_bean.getCar_name()%><%}%></a>
			                  		<%if(car_nm_length>=32){%><br><%}%>
			                  		<%
				                  			//올해 년도보다 모델 년도 데이터가 작으면 안보여줌
			            					String car_y_form = "";
			                  				if(cm_bean.getCar_y_form_yn().equals("Y")){//20190610 신차견적서연형표기여부
				            					if(AddUtil.getDate2(1) <= AddUtil.parseInt(cm_bean.getCar_y_form())){
				            			   			car_y_form = "[" + cm_bean.getCar_y_form() + "년형]";
				            					}
			                  				}
			                  		%>
			                  		<%=car_y_form%>
			                  		</span> 
			                  	</td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_amt())%> 
			                    원</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>옵 
			                    션</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style7><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=e_bean.getOpt()%></a></span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getOpt_amt())%> 
			                    원</span>&nbsp;</td>
			                </tr>
			                <%if(!e_bean.getConti_rat().equals("")){%>
			                <tr>
			                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>연 
			                    비 </span></td>
			                    <td bgcolor=#FFFFFF>&nbsp;&nbsp;<span id="contiRatDesc"><%=e_bean.getConti_rat()%></span></td>
			                    <td bgcolor=#FFFFFF></td>
			                </tr>
			                <%}%>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>기 타</span></td>
			                    <td bgcolor=#FFFFFF>&nbsp;
			                    	<%-- <%if( ej_bean.getJg_g_7().equals("3") && AddUtil.parseInt(String.valueOf(exam.get("BK_128"))) > 0 ){%>
			                  			※ 본 견적은 참고용 예상 견적으로 2022년 보조금 확정 공고시 월대여료가 변경 될 수 있습니다.<br>
			                  		<%}%> 2022.02.18. 해당 문구 미표기 요청으로 주석처리. --%>
			                  		<%if(e_bean.getDc_amt()>0){%>제조사D/C (<%=e_bean.getRent_dt().substring(4, 6)%>월 출고조건)&nbsp;<%=e_bean.getEsti_d_etc()%><%}%>
			                  		<%if(e_bean.getDc_amt()>0 && !e_bean.getEtc().equals("")){%><br>&nbsp;&nbsp;<%}%>
                  					<%if(!e_bean.getEtc().equals("") ){%><%=e_bean.getEtc()%><%}%>
                  					
                  					<%-- <%if (ref_reg_dt <= 2022070500) {%>
	                  					<%if(cm_bean.getJg_code().equals("5048111")){ // 쌍용 토레스%>
					                  		※ 사전계약 가격표 예상 가격 중 최저가격 기준 견적입니다. 정확한 차량가격은 정식 출시일에 확정될 예정입니다. 견적 차량가격과 확정 차량가격이 차이가 날 경우 [차량가격 차이 ÷ 대여개월수] (vat포함, 십원단위이하절사)로 월대여료가 인상됩니다.
					                  	<%}%>
				                  	<%}%> --%>
				                  	
				                  	<%if (ref_reg_dt >= 2022100400 && ref_reg_dt <= 2022103024) {%>
					                  	<%if(cm_bean.getJg_code().equals("5055111") || cm_bean.getJg_code().equals("5055112") || cm_bean.getJg_code().equals("5055113") ){ // 삼성 XM3 %>
					                  		※ 사전계약 가격표 예상 가격 중 최저가격 기준 견적입니다. 정확한 차량가격은 정식 출시일에 확정될 예정입니다. 견적 차량가격과 확정 차량가격이 차이가 날 경우 [차량가격 차이 ÷ 대여개월수] (vat포함, 십원단위이하절사)로 월대여료가 인상됩니다.
					                  	<%}%>
				                  	<%}%>
				                  	
				                  	<%if (ref_reg_dt >= 2022080100 && ref_reg_dt < 2022082200) {%>
					                  	<%if(cm_bean.getJg_code().equals("3016111")){ // 아이오닉6%>
					                  		※ 본 견적은 참고용 예상 견적으로 정확한 차량가격 및 옵션가격은 정식 출시일에 확정될 예정입니다.
				   							(본 견적으로는 계약이 확정되지 않으며, 사전계약 참고용으로만 활용바랍니다)
					                  	<%}%>
				                  	<%}%>
                  					<%-- <%if(cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%>
                  						※ 전기화물차의 경우 현재 지자체 보조금 접수대수 초과 상태이나, 향후 보조금 추경 편성시 계약이 가능할 수 있습니다.
                  					<%}%> --%>
                  					<%-- <%if(cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")) {%>
                  						※ 8월 인도예정
                  					<%}%>
                  					<%if(cm_bean.getJg_code().equals("5315111") || cm_bean.getJg_code().equals("5315112") || cm_bean.getJg_code().equals("5315113")) {%>
                  						※ 9월 초순경 인도예정
                  					<%}%> --%>
                  					<%-- <%if( cm_bean.getJg_code().equals("5315112") ) {%>
				                  		※ 11월 중순경 인도예정
				                  	<%}%> --%>
				                  	<%-- <%if( cm_bean.getJg_code().equals("6015111") || cm_bean.getJg_code().equals("6015112") || cm_bean.getJg_code().equals("6015113") || cm_bean.getJg_code().equals("6015114") ) {%>
	                  					2021년4/4분기 신규출시 차량으로 보조금이 소진되거나 변경될 가능성이 매우 높습니다.
				                  	<%}%> --%>
			                  	</td>
                  				<td align=right bgcolor=#FFFFFF><span class=style3><%if(e_bean.getDc_amt()>0){%>-<%=AddUtil.parseDecimal(e_bean.getDc_amt())%> 
                    				원<%}%></span>&nbsp;</td>
			                </tr>
			                <!-- 개소세 감면 -->
			                
						<%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20200301) && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20200630)) {%>
			                <%if (ej_bean.getJg_3()*100 == 0 || cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("2361") || cm_bean.getJg_code().equals("2362") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("2031111") || cm_bean.getJg_code().equals("2031112") || cm_bean.getJg_code().equals("5033111")) {%>
			                <tr style="display: none;"> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>개소세 감면 </span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;개별소비세 및 교육세 감면</td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
			                    원</span>&nbsp;</td>
			                </tr>
			     	        <%} else if ((ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")) && e_bean.getTax_dc_amt() > 0 ) {//친환경차%>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>개소세 감면 </span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;개별소비세 및 교육세 감면</td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
			                    원</span>&nbsp;</td>
			                </tr>
			                <%} else if (ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")) {%>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>개소세 감면 </span></td>
			                  	<td bgcolor=#FFFFFF>
			                  	<%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20200301) && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20200630)) {%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_190"))) > 0) {%>
									&nbsp;&nbsp;개별소비세 한시적 세액 70% 감면(2020.3~6월) 기간을 초과하여, 개별소비세율이<br>
									&nbsp;&nbsp;3.5%(2020.7~12월)로 조정되어 출고시 월대여료가 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_190"))))%>원(공급가) 인상됩니다.
									<%} else {%>
										&nbsp;&nbsp;개별소비세 한시적 감면기간(2020.3~6월)을 초과하여 출고 될 경우 대여료는 인상됩니다.
									<%}%>
			                  	<%}%>
								</td>
			                  	<td align=right bgcolor=#FFFFFF>
			                  		<%if (e_bean.getTax_dc_amt() == 0) {%>
			                  		<span class=style4>개소세 감면효과&nbsp;<br>견적에 반영</span>&nbsp;
			                  		<%} else {%>
			                  		<span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%>원</span>&nbsp;
			                  		<%}%>
			                  	</td>
			                </tr>                
			                <%} else {%>                
				                <%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20200301) && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20200630)) {%>
				                <tr > 
				                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>개소세 감면 </span></td>
				                  	<td bgcolor=#FFFFFF>
										<!-- &nbsp;&nbsp;개별소비세 한시적 감면기간(2020.3~6월)을 초과하여 출고 될 경우 대여료는 인상됩니다. -->
										<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_190"))) > 0) {%>
										&nbsp;&nbsp;개별소비세 한시적 세액 70% 감면(2020.3~6월) 기간을 초과하여, 개별소비세율이<br>
										&nbsp;&nbsp;3.5%(2020.7~12월)로 조정되어 출고시 월대여료가 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_190"))))%>원(공급가) 인상됩니다.
										<%} else {%>
											&nbsp;&nbsp;개별소비세 한시적 감면기간(2020.3~6월)을 초과하여 출고 될 경우 대여료는 인상됩니다.
										<%}%>
									</td>
				                  	<td align=right bgcolor=#FFFFFF>
				                  		<%if (e_bean.getTax_dc_amt() == 0) {%>
				                  		<span class=style4>개소세 감면효과&nbsp;<br>견적에 반영</span>&nbsp;
				                  		<%} else {%>
				                  		<span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%>원</span>&nbsp;
				                  		<%}%>
				                  	</td>
				                </tr>
				                <%}%>
			                <%}%>
		                <%} else {%>
		                	<!-- 수입차가 아니면서 개소새 감면 한도(교육세포함, 부가세전)가 0보다 크면 개별소비세 및 교육세 감면. 볼트 제외. -->
		                	<%if (!ej_bean.getJg_w().equals("1") && !cm_bean.getJg_code().equals("2362") && !cm_bean.getJg_code().equals("2031112") && e_bean.getTax_dc_amt() > 0) {%>
		                		<tr> 
				                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>개소세 감면</span></td>
				                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;개별소비세 및 교육세 감면</td>
				                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
				                    원</span>&nbsp;</td>
				                </tr>
		                	<%} else{ %>
		                	<!-- 그 외 감면 미적용 개별소비세(개별소비세 인하한도 초과금액)가 0보다 크면 감면 미적용 개별소비세 -->
			                	<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_216"))) > 0) {%>
			                		<%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20210101)) {// && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20220705)%>
				                		<tr>
						                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>개별소비세</span></td>
						                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;감면 미적용 개별소비세 (개별소비세 인하한도 초과금액)<br>&nbsp;&nbsp;※ 상기 차가는 개별소비세 3.5% 기준 금액(최대 인하한도 적용전)</td>
						                  	<%if (e_bean.getTax_dc_amt() > 0) {%>
						                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
						                    원</span>&nbsp;</td>
						                  	<%}%>
						                  	<%if (e_bean.getTax_dc_amt() < 0) {%>
						                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(-1*e_bean.getTax_dc_amt())%> 
						                    원</span>&nbsp;</td>
						                  	<%}%>
						                </tr>
				                	<%}%>
			                	<%}%>
		                	<%} %>
		                	<%-- <%if (AddUtil.parseInt(String.valueOf(exam.get("BK_216"))) > 0) {%>
                				<%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20210101) && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20220105)) {%>
                					<tr> 
					                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>개별소비세</span></td>
					                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;감면 미적용 개별소비세 (개별소비세 인하한도 초과금액)<br>&nbsp;&nbsp;※ 상기 차가는 개별소비세 3.5% 기준 금액(최대 인하한도 적용전)</td>
					                  	<%if (e_bean.getTax_dc_amt() > 0) {%>
					                  		<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
					                    	원</span>&nbsp;</td>
					                  	<%}%>
					                  	<%if (e_bean.getTax_dc_amt() < 0) {%>
					                  		<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(-1*e_bean.getTax_dc_amt())%> 
					                    	원</span>&nbsp;</td>
					                  	<%}%>
					                </tr>
			                	<%}%>
			                <%} else {%>
		                		<%if (!cm_bean.getJg_code().equals("2362") && !cm_bean.getJg_code().equals("2031112") && e_bean.getTax_dc_amt() > 0) {%>
			                		<tr> 
					                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>개소세 감면 </span></td>
					                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;개별소비세 및 교육세 감면</td>
					                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
					                    원</span>&nbsp;</td>
					                </tr>
			                	<%}%>
			                <%}%> --%>
		                <%}%>
			                
			                <tr> 
			                  	<td height=20 align=center bgcolor=f2f2f2><span class=style3>차량가격</span></td>
			                  	<td bgcolor=#FFFFFF style="font-size:11px;">
			                  	<%
			                  	int info_end_dt = 2021010514;
			                  	if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5) {
			                  		info_end_dt = 2021011514;
			                  	}
			                  	
								//수입차 이거나 하이브리드,플러그하이브리드 이거나 특정차종 문구표시
			                  	Boolean etc_jg_code_match = false;
			                  	String[] etc_jg_code = {
		                  			"2179", 
		                  			"4115", "4116", "4117", "4149", "4150", "4160", 
		                  			"4264", "4265", 
		                  			"5155", "5156", "5171", "5172", "5173", 
		                  			"5229", "5230", "5271", "5272", "5273", "5274", 
		                  			"5351", "5352",
		                  			"6134", "6135", "6136", "6137", "6161", "6162", "6163", 
		                  			"6255", "6256", "6271", "6272",
		                  			
		                  			"2013714", 
		                  			"4012621", "4012622", "4012623", "4016311", "4016312", "4016313", 
		                  			"4024121", "4024122", 
		                  			"5018411", "5018412", "6018111", "6018112", "6018113", 
		                  			"5026111", "5026112", "6022411", "6022412", "6022413", "6022414", 
		                  			"3053511", "3053512",
		                  			"6016111", "6016112", "6016113", "6016114", "6018116", "6018117", "6018118", 
		                  			"6024411", "6024412", "6022416", "6022417"
		                  		};
			                  	for (int j = 0; j < etc_jg_code.length; j++) {
			                		if (etc_jg_code[j].equals(cm_bean.getJg_code())) {
			                			etc_jg_code_match = true;
			                		}
			                	}
			                  	%>
			                  	
			                  	<%if (ref_reg_dt >= 2020083113 && ref_reg_dt <= 2020121812) {%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_198"))) > 0) {%>
				                   		<span class=style4>&nbsp;※ 2021년1월1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_198"))))%>원(공급가) 인상됩니다.</span>
				                   	<%}%>
			                  	<%}%>
			                  	
			                  	<%if (ref_reg_dt >= 2020121813 && ref_reg_dt <= 2020123123) {%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_213"))) > 0) {%>
				                   		<span class=style4>&nbsp;※ 2021년1월1일이후 신차가 출고되면 개별소비세율 한시적 인하 연장에도 불구하고 개별소비세 인하 한도(100만원) 초과로 월대여료가 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_213"))))%>원(공급가) 인상됩니다.</span>
				                   	<%}%>
			                  	<%}%>
			                  	
			                  	<%if (ref_reg_dt >= 2020083113 && ref_reg_dt <= 2020123123) {%>
			                  		<%-- <%if (ej_bean.getJg_w().equals("1") || (ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")) || etc_jg_code_match == true || !e_bean.getInfo_st().equals("N")) {%> --%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_206"))) > 0) {%>
										<span class=style4>&nbsp;※ 2021년1월1일 이후 신차가 출고되면 하이브리드 자동차 취득세 감면 혜택 축소에 따라 월대여료가 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_206"))))%>원(공급가) 인상됩니다.</span>
					                <%}%>
					                <%-- <%}%> --%>
			                  	<%}%>
			                    
                  <%
                  int reference_date = 20200101;
                  //국산차와 수입차 기준일 다르게 적용
                  if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5) {
                	  reference_date = 20200108;
                  }
                  
                  if((AddUtil.parseInt(AddUtil.getDate(4)) >= 20181114 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20181114) && AddUtil.parseInt(e_bean.getRent_dt()) <= reference_date){
                  %>	
                  
                  <%	//20181114 2019년 개별소비세 환원 및 구매보조금 변경 안내
						//20190923 변경
                    	double fee_add_amt1 = 0;	//개별소비세 환원에 따른 월대여료 인상금액
                    	double fee_add_amt2 = 0;	//구매보조금 지원중단에 따른 월대여료 인상금액
                    	String fee_add_text1 = "";
                    	String fee_add_text2 = "";
                    	int car_c_amt = e_bean.getCar_amt()+e_bean.getOpt_amt()+e_bean.getCol_amt()-e_bean.getDc_amt();
                    	double fee_pp_amt = e_bean.getFee_s_amt()+(e_bean.getPp_s_amt()/AddUtil.parseDouble(e_bean.getA_b()));		//월대여료+선납금/개월수
                    	//보증금이자효과 20191108
                    	double grt_mo_amt = 0;
                    	if (e_bean.getGtr_amt() > 0) {
                    		//grt_mo_amt = e_bean.getGtr_amt()*0.06/12*0.014;
                    		grt_mo_amt = e_bean.getGtr_amt()*(em_bean.getA_f_2()/100)/12*0.014;
                    	}	 
                    	//20191108 0.015->0.014 변경
                    	//기본개별소비세가 있다.
                    	if(ej_bean.getJg_3()*100 >0){
                    		//전기차 20190923	
                    		if(ej_bean.getJg_g_7().equals("3")){
                    			//개소세전차량가
                    			double car_c_amt2 = AddUtil.parseDouble(String.valueOf(exam.get("O_3")))/1.1;
                    			//수입차는 수입차추정통관면세가
                    			if(ej_bean.getJg_w().equals("1")){
                    				car_c_amt2 = AddUtil.parseDouble(String.valueOf(exam.get("K_SU_4")))/1.1;
                    			}
                    			if(car_c_amt2<=60000000){
                    				fee_add_amt1 = 0;
                    			}else if(car_c_amt2>85714286){
                       				fee_add_amt1 = fee_pp_amt*0.014;
                       			}else{
                       				fee_add_amt1 = (car_c_amt2-60000000)/25714286*0.014*fee_pp_amt;                       				
                       			}
							//수소 20190923
                    		}else if(ej_bean.getJg_g_7().equals("4")){
                    			fee_add_amt1 = 0;
							//하이브리드,플러그하이브리드
                    		}else if(ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")){
                    			if(car_c_amt<=23001000){
                    				fee_add_amt1 = 0;
                    			}else if(car_c_amt>=32858571){
                       				fee_add_amt1 = fee_pp_amt*0.014;
                       			}else{
                       				fee_add_amt1 = ((car_c_amt/1.0455*0.065)-1430000)/car_c_amt*0.75*fee_pp_amt;                       			
                       			}
                       		//그외	
                       		}else{
                       			fee_add_amt1 = fee_pp_amt*0.014;
                       		}
                    		if(fee_add_amt1 > 0){
                    			fee_add_amt1 = fee_add_amt1+grt_mo_amt;
                    			fee_add_amt1 = (double)e_db.getTruncAmt((int)fee_add_amt1, "1", "round", "-2");
                    		}
                    		//개별소비세 환원 문구
                    		//0보다 작으면 표기안함
                    		if(fee_add_amt1 < 0) fee_add_amt1 = 0;
                    		
                    		if (fee_add_amt1 > 0) {
                    			fee_add_text1 = "한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우<br>&nbsp; 월대여료가 "+AddUtil.parseDecimal(fee_add_amt1)+"원(공급가) 인상됩니다.";	//문구변경(20190527)
                    		}
                    		
                    	}
                    	//하이브리드
                    	if(AddUtil.parseInt(AddUtil.getDate(4)) <= 20181231){ //20181227
	                    	if(ej_bean.getJg_g_7().equals("1") && ej_bean.getJg_g_8().equals("1") && AddUtil.parseInt(String.valueOf(exam.get("BK_128"))) > 0){
	                    		fee_add_amt2 = (double)e_db.getTruncAmt((int)(AddUtil.parseDouble(String.valueOf(exam.get("BK_128")))/AddUtil.parseDouble(e_bean.getA_b())), "1", "round", "-2");
	                    		if(fee_add_amt2 > 0) {
	                    			fee_add_text2 = "2019년1월1일 이후 신차가 출고되면 하이브리드 구매보조금 지원중단에 따라 <br>&nbsp; 월대여료가 "+AddUtil.parseDecimal(fee_add_amt2)+"원(공급가) 인상됩니다.";
	                    		}
	                    	}
                    	}
                    	//20191007 2020년부터 하이브리드 취득세 감면 혜택 축소 문구 추가
                    	fee_add_amt2 = 0;
                    	//하이브리드,플러그하이브리드
                    	if(AddUtil.parseInt(AddUtil.getDate(4)) <= 20191231 || AddUtil.parseInt(e_bean.getRent_dt()) <= 20191231){ 
	                    	if(ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")){
	                    		if(e_bean.getA_a().equals("21")||e_bean.getA_a().equals("22")){ //렌트
	                    			double car_c_amt2 = AddUtil.parseDouble(String.valueOf(exam.get("S_D")));	                    		
	                    			if(car_c_amt2<=22500000){
	                    				fee_add_amt2 = 0;
	                    			}else if(car_c_amt2>=35000000){
	                    				fee_add_amt2 = (double)e_db.getTruncAmt((int)(500000/AddUtil.parseDouble(e_bean.getA_b())), "1", "round", "-2");
	                    			}else{
	                    				fee_add_amt2 = (double)e_db.getTruncAmt((int)((car_c_amt2-22500000)*0.04/AddUtil.parseDouble(e_bean.getA_b())), "1", "round", "-2");
	                    			}
	                    		}else{ //리스
	                    			fee_add_amt2 = (double)e_db.getTruncAmt((int)(500000/AddUtil.parseDouble(e_bean.getA_b())), "1", "round", "-2");
	                    		}
	                    	}
                    		if(fee_add_amt2 > 0) {
                    			fee_add_text2 = "2020년1월1일 이후 신차가 출고되면 하이브리드 자동차 취득세 감면 혜택 축소에 따라 <br>&nbsp; 월대여료가 "+AddUtil.parseDecimal(fee_add_amt2)+"원(공급가) 인상됩니다.";
                    		}
                    	}
                  %>
                  
                  <%	if(!fee_add_text1.equals("")){%>&nbsp; <%=fee_add_text1%><%}%>
                  <%	if(!fee_add_text1.equals("") && !fee_add_text2.equals("")){%><br>&nbsp; <%}%>
                  <%	if(fee_add_text1.equals("") && !fee_add_text2.equals("")){%>&nbsp; <%}%>
                  <%	if(!fee_add_text2.equals("")){%><%=fee_add_text2%><%}%>
                  
                  <%}else if(AddUtil.parseInt(e_bean.getRent_dt()) >= 20190101){%>	

                    <%if(ej_bean.getJg_g_7().equals("2") && e_bean.getEcar_pur_sub_amt()>0 ){%>
                    <!-- 친환경차일경우-->&nbsp;&nbsp;친환경차 구매보조금 <%=AddUtil.parseDecimal(e_bean.getEcar_pur_sub_amt())%>원은 월대여료 계산시 반영됨
                    <%}%>
                  
                  <%}else{%>
                  	
                    <%//20170105 임시 소스 변경
                    	
                  	  if((ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("4")) && e_bean.getEcar_pur_sub_amt()>0 ){
                    %>
                    <!-- 친환경차일경우-->&nbsp;&nbsp;친환경차 구매보조금 <%=AddUtil.parseDecimal(e_bean.getEcar_pur_sub_amt())%>원은 월대여료 계산시 반영됨
                    <%}%>
                  
                  
                    <%if(AddUtil.parseInt(AddUtil.getDate(4)) >= 20161108 && AddUtil.parseInt(AddUtil.getDate(4)) < 20161117){%>
                    <%	if(AddUtil.parseInt(cm_bean.getJg_code()) >=  4135 && AddUtil.parseInt(cm_bean.getJg_code()) < 4139){%>
                    <span class=style4>※ 정확한 차량가격 및 옵션가격은 정식 출시일에 확정 예정(본 견적은 참고용 예상 견적임)</span>
                    <%	}%>
                    <%}%>
                  <%}%>
			                  	
                    <%if((e_bean.getCar_id().equals("006171") || e_bean.getCar_id().equals("006172")) && (e_bean.getA_a().equals("21") || e_bean.getA_a().equals("22"))){%>
                    &nbsp;&nbsp;<span class=style4>본 견적서의 차량가격은 개별소비세 포함가격 입니다.(견적 계산 과정에서는 제조사 가격표와 동일하게 개별소비세 면세가(<%=AddUtil.parseDecimal(e_bean.getO_1()/1.065)%>원)로 환산하여 계산됨)</span>
                    <%}%>
                    
	                  <!-- 쏘렌토 MQ4 -->                  
	                  <%if ((AddUtil.parseInt(AddUtil.getDate(4)) >= 20200219 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20200219) && (AddUtil.parseInt(AddUtil.getDate(4)) <= 20200317 || AddUtil.parseInt(e_bean.getRent_dt()) <= 20200317)) {%>
	                  	  <%if(cm_bean.getJg_code().equals("5271") || cm_bean.getJg_code().equals("5273") || cm_bean.getJg_code().equals("6271")){%>
			              	<span class=style4>※ 사전계약 기간 중 예상한 총 차량가격 대비 출시일 확정된 총 차량가격 초과 금액이 30만원 이내이면 월대여료 인상이 없습니다.</span>
			              <%}%>
	                  <%}%>
	                  
	                  <!-- 쏘렌토 MQ4 하이브리드 -->                  
	                  <%if ((AddUtil.parseInt(AddUtil.getDate(4)) >= 20200219 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20200219) && (AddUtil.parseInt(AddUtil.getDate(4)) <= 20200310 || AddUtil.parseInt(e_bean.getRent_dt()) <= 20200310)) {%>
	                  	  <%if(cm_bean.getJg_code().equals("5272") || cm_bean.getJg_code().equals("5274") || cm_bean.getJg_code().equals("6272")){%>
			              	<span class=style4>※ 사전계약 기간 중 예상한 총 차량가격 대비 출시일 확정된 총 차량가격 초과 금액이 30만원 이내이면 월대여료 인상이 없습니다.</span>
			              <%}%>
	                  <%}%>    
	                  
	                  <!-- 아반떼 CN7 -->
	                  <%if ((AddUtil.parseInt(AddUtil.getDate(4)) >= 20200325 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20200325) && (AddUtil.parseInt(AddUtil.getDate(4)) <= 20200406 || AddUtil.parseInt(e_bean.getRent_dt()) <= 20200406)) {%>
	                  	  <%if(cm_bean.getJg_code().equals("2176") || cm_bean.getJg_code().equals("2177")){%>
			              	<span class=style4>※ 사전계약 기간 중 예상한 총 차량가격 대비 출시일 확정된 총 차량가격 초과 금액이 20만원 이내이면 월대여료 인상이 없습니다.</span>
			              <%}%>
	                  <%}%>           
                    
                    <!-- 20200701 한시적 안내문 -->
                  	<%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && !cm_bean.getJg_code().equals("3871") && !cm_bean.getJg_code().equals("3313111")) {%>
	                  	<%if (ref_reg_dt >= 2020070100 && ref_reg_dt <= 2020070813) {%>
	               	  		<span class=style4>※ 7월1일자로 개별소비세율이 조정(세액 감면 → 세율 조정)됨에 따라 차량 가격이 변경됩니다. 당사는 7월1일 자로 변경되는 차량가격을 순차적으로 반영중이라, 본 견적서의 현재 차량가격이 변경전 차량가격일 수 있습니다. 차량가격 변경 반영으로 신차가격이 변경되는 경우 월대여료도 변경되니 이 점 참고 바랍니다. (궁금한 점이 있으면 영업담당 직원에게 문의 바랍니다.)</span>
	               	  	<%}%>
                  	<%} else {%>
	                  	<%if (ref_reg_dt >= 2020070100 && ref_reg_dt <= 2020070113) {%>
	               	  		<span class=style4>※ 7월1일자로 개별소비세율이 조정(세액 감면 → 세율 조정)됨에 따라 차량 가격이 변경됩니다. 당사는 오늘(7월1일) 자로 변경되는 차량가격을 순차적으로 반영중이라, 본 견적서의 현재 차량가격이 변경전 차량가격일 수 있습니다. 차량가격 변경 반영으로 신차가격이 내려가는 경우 월대여료도 인하되니 이 점 참고 바랍니다. (궁금한 점이 있으면 영업담당 직원에게 문의 바랍니다.)</span>
	               	  	<%}%>
                  	<%}%>
                    
					<%if (ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")) {%>
                  	<% if(ej_bean.getJg_g_15() > 0 && e_bean.getEcar_loc_st().equals("13")){ // 전기차 고객주소지 보조금 없는 견적 선택 시 + 보조금이 0보다 큼%>
                  		<span class=style4>&nbsp;&nbsp;[보조금 없는 견적]</span>
                  	<%} else if (e_bean.getCar_comp_id().equals("0056")) { // 테슬라 차량%>
                  		<%if (ej_bean.getJg_g_15() > 0) { // 국고보조금 있는 경우%>
                  			<span class=style4>※ 환율, 연식, 세율 등의 변동이나 제조사 가격정책에 따라 차량가격이 변경될 경우 대여료가 변경될 수 있습니다. 또한 보조금의 소진 또는 변경시 대여료가 변경되거나 계약진행이 불가능 할 수 있습니다.</span>
                  		<%} else{ // 국고보조금 없는 경우%>
                  			<span class=style4>※ 환율, 연식, 세율 등의 변동이나 제조사 가격정책에 따라 차량가격이 변경될 경우 대여료가 변경될 수 있습니다.</span>
                  		<%}%>
                  	<%} else if (ej_bean.getJg_g_15() > 0) { // 친환경차 구분상 전기/수소차 + 국고보조금 있는 경우%>
                  		<span class=style4>※ 보조금 소진 또는 변경, 차량 출고지연 등으로 대여료가 변경되거나 계약진행이 불가능 할 수 있습니다.</span>
                  	<%} %>
                    <!-- 테슬라 -->               
               	  <%-- <%if (e_bean.getCar_comp_id().equals("0056")) {%>
               	  	<% if(e_bean.getEcar_loc_st().equals("13")){ %>
                  		<span class=style4>※ 환율, 연식, 세율 등의 변동이나 제조사 가격정책에 따라 차량가격이 변경될 경우 대여료가 변경될 수 있습니다.<br>[보조금 없는 견적]</span>
	               	 <%} else {%>
                  		<span class=style4>※ 환율, 연식, 세율 등의 변동이나 제조사 가격정책에 따라 차량가격이 변경될 경우 대여료가 변경될 수 있습니다. 또한 보조금의 소진 또는 변경시 대여료가 변경되거나  계약진행이 불가능 할 수 있습니다.</span>
					<%}%>
                  <%} else if (cm_bean.getJg_code().equals("5866")) {%>
                  	<span class=style4>※ 환율, 연식, 세율 등의 변동이나 제조사 가격정책에 따라 차량가격이 변경될 경우 대여료가 변경될 수 있습니다.</span>
               	  <%} else {%>
              	 	  	<% if(!e_bean.getEcar_loc_st().equals("13")){ %>
               		  		<span class=style4>※ 보조금 소진 또는 변경, 차량 출고지연 등으로 대여료가 변경되거나 계약진행이 불가능 할 수 있습니다.</span>
						<%} else{%>
              	 	  		<% if(! (cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113")) ){ %>
               		  			<span class=style4>&nbsp;&nbsp;[보조금 없는 견적]</span>
							<%}%>
						<%}%>
               	  <%}%> --%>
           	  	<%}%>
					
                <%if (ref_reg_dt >= 2021070200) {%>
                	<%if( ej_bean.getJg_3() > 0 && AddUtil.parseInt(String.valueOf(exam.get("BK_198"))) > 0 ){ // 기본개별소비세율(ej_bean.getJg_3())이 0보다 크고 개별소비세 세율 환원 시 월대여료 인상금액(bk_198)이 0보다 클 때	%>
                		<%if( ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4") ){  // 친환경차 구분상 전기/수소차%>
               				<span class=style4>※ 2023년 1월 1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 인상됩니다.</span>
						<%} else {%>
               				<span class=style4>※ 2023년 1월 1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_198"))))%>원(공급가) 인상됩니다.</span>
						<%}%>
					<%}%>
				<%}%>
                    
			                  	</td>
			                	<td align=right bgcolor=#FFFFFF><span class=style14><%=AddUtil.parseDecimal(e_bean.getO_1())%> 
			                    원</span>&nbsp;</td>
			                </tr>
              			</table>
              		</td>
          		</tr>
          		
          		<tr> 
		            <td height=10 colspan="2">
		                <table width=638 border=0 cellpadding=0 cellspacing=1>
		                	<%if(endDt){%><!-- 단산 차종 문구 2017.11.08 -->
		                	<tr>
		                		<td><span class="endDt">※ 생산 중단된 차종입니다. 영업 담당자를 통해서 재고 유무를 확인하고 진행하시기 바랍니다.</span></td>
		                	</tr>
		                	<%}%>
		                    <tr>
		                        <td colspan='2'>
		                        	<%if(ej_bean.getJg_g_7().equals("3")){ //전기차
		                        		if ( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) { 	// 전기화물차
		                        	%>
		                        		<%if(e_bean.getLoc_st().equals("1")){%>※ 차량 인도 지역 : 서울
										<%} else if(e_bean.getLoc_st().equals("2")){%>※ 차량 인도 지역 : 인천/경기
										<%} else if(e_bean.getLoc_st().equals("3")){%>※ 차량 인도 지역 : 강원
										<%} else if(e_bean.getLoc_st().equals("4")){%>※ 차량 인도 지역 : 대전/세종/충남/충북
										<%} else if(e_bean.getLoc_st().equals("5")){%>※ 차량 인도 지역 : 광주/전남/전북
										<%} else if(e_bean.getLoc_st().equals("6")){%>※ 차량 인도 지역 : 대구/경북
										<%} else if(e_bean.getLoc_st().equals("7")){%>※ 차량 인도 지역 : 부산/울산/경남
										<%} %>	
		                        	<%	
		                        		} else {		// 전기승용차
		                        	%>
			                        	<%if( e_bean.getEcar_loc_st().equals("0") || e_bean.getEcar_loc_st().equals("1") ){
			                        		// 전기차 고객주소지가 서울, 인천일 때 %>
		                        		※ [①법인: 사업장 소재지, ②개인: 주민등록등본상 주소지, ③개인사업자: 대표자 주민등록등본상 주소지]
			                        		<% if(e_bean.getEcar_loc_st().equals("0")){ %>
			                        			서울
			                        		<%} else if(e_bean.getEcar_loc_st().equals("1")){ %>
			                        			인천
			                        		<%} %> 기준 견적
		                        		<%} else{%>
		                        			<%if(e_bean.getLoc_st().equals("1")){%>※ 차량 인도 지역 : 서울
											<%} else if(e_bean.getLoc_st().equals("2")){%>※ 차량 인도 지역 : 인천/경기
											<%} else if(e_bean.getLoc_st().equals("3")){%>※ 차량 인도 지역 : 강원
											<%} else if(e_bean.getLoc_st().equals("4")){%>※ 차량 인도 지역 : 대전/세종/충남/충북
											<%} else if(e_bean.getLoc_st().equals("5")){%>※ 차량 인도 지역 : 광주/전남/전북
											<%} else if(e_bean.getLoc_st().equals("6")){%>※ 차량 인도 지역 : 대구/경북
											<%} else if(e_bean.getLoc_st().equals("7")){%>※ 차량 인도 지역 : 부산/울산/경남
											<%} %>
		                        		<%} 
		                        		}%>
                						
                					<%}else if(ej_bean.getJg_g_7().equals("4")){//수소차 (20190208)%>
                						<%-- <%if(e_bean.getHcar_loc_st().equals("0")){ //서울,경기 %>
                							※ 서울 구매보조금 기준 견적.
                						<%}else if(e_bean.getHcar_loc_st().equals("1")){ //인천 %>
                							※ 인천 구매보조금 기준 견적.
                						<%}else if(e_bean.getHcar_loc_st().equals("2")){ //강원 %>	
                							※ 서울 구매보조금 기준 견적.
               							<%}else if(e_bean.getHcar_loc_st().equals("3")){ //대전 %>
               								<%if(e_bean.getA_a().equals("21")||e_bean.getA_a().equals("22")){ //렌트%>
               								※ 서울 구매보조금 기준 견적.
               								<%}else if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){ //리스%>
                							※ 대전 구매보조금 기준 견적.
                							<%} %>
                						<%}else if(e_bean.getHcar_loc_st().equals("4")){ //광주,전남,전북 %>
                							※ 광주 구매보조금 기준 견적.	
                						<%}else if(e_bean.getHcar_loc_st().equals("5")){ //대구,경북 %>
                							※ 서울 구매보조금 기준 견적.	
               							<%}else if(e_bean.getHcar_loc_st().equals("6")){ //부산,울산,경남 %>
                							※ 부산 구매보조금 기준 견적.	
                					  	<%}else if(e_bean.getHcar_loc_st().equals("7")){ //세종,충남,충북(대전제외) %>
                							※ 서울 구매보조금 기준 견적.
                					  	<%}%>	 --%>
                					  	<%if(e_bean.getLoc_st().equals("1")){%>※ 차량 인도 지역 : 서울
										<%}else if(e_bean.getLoc_st().equals("2")){%>※ 차량 인도 지역 : 인천/경기
										<%}else if(e_bean.getLoc_st().equals("3")){%>※ 차량 인도 지역 : 강원
										<%}else if(e_bean.getLoc_st().equals("4")){%>※ 차량 인도 지역 : 대전/세종/충남/충북<!-- 충청 -->
										<%}else if(e_bean.getLoc_st().equals("5")){%>※ 차량 인도 지역 : 광주/전남/전북<!-- 전라 -->
										<%}else if(e_bean.getLoc_st().equals("6")){%>※ 차량 인도 지역 : 대구/경북
										<%}else if(e_bean.getLoc_st().equals("7")){%>※ 차량 인도 지역 : 부산/울산/경남
										<%}%>
                					<%}else{%><!-- 2018년 지자체 구매보조금 산출방식 변경 작업완료에 따라 소스변경(2018.02.07) -->
    									<%if (!cm_bean.getJg_code().equals("5866") && !cm_bean.getJg_code().equals("4854") && !cm_bean.getJg_code().equals("6316111") && !cm_bean.getJg_code().equals("4314111")) {%>
	    									<%if(e_bean.getLoc_st().equals("1")){%>※ 차량 인도 지역 : 서울
	    									<%}else if(e_bean.getLoc_st().equals("2")){%>※ 차량 인도 지역 : 인천/경기
	    									<%}else if(e_bean.getLoc_st().equals("3")){%>※ 차량 인도 지역 : 강원
	    									<%}else if(e_bean.getLoc_st().equals("4")){%>※ 차량 인도 지역 : 대전/세종/충남/충북<!-- 충청 -->
	    									<%}else if(e_bean.getLoc_st().equals("5")){%>※ 차량 인도 지역 : 광주/전남/전북<!-- 전라 -->
	    									<%}else if(e_bean.getLoc_st().equals("6")){%>※ 차량 인도 지역 : 대구/경북
	    									<%}else if(e_bean.getLoc_st().equals("7")){%>※ 차량 인도 지역 : 부산/울산/경남
	    									<%}%>
    									<%}%>
    								<%}%>
								</td>    
		                        <td align="right">
					<%if(cm_bean.getJg_code().equals("1232") || cm_bean.getJg_code().equals("1242") || cm_bean.getJg_code().equals("1021212") || cm_bean.getJg_code().equals("1023112")){//모닝바이퓨엘,레이%>
					※ LPG/휘발유 겸용차
					<%}else{%>			
					<%	if(String.valueOf(sh_comp.get("ENGIN")).equals("Y")){%>		※ 디젤엔진
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("2")){%>	※ LPG전용차
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("1")){%>	※ 가솔린엔진
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("3")){%>	※ 하이브리드
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("4")){%>	※ 플러그인 하이브리드
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("5")){%>	※ 전기차
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("6")){%>	※ 수소차
					<%	}else{%>
							<%if(cm_bean.getDiesel_yn().equals("Y")){%>		※ 디젤엔진
							<%}else if(cm_bean.getDiesel_yn().equals("2")){%>	※ LPG전용차
							<%}else if(cm_bean.getDiesel_yn().equals("1")){%>	※ 가솔린엔진
							<%}else if(cm_bean.getDiesel_yn().equals("3")){%>	※ 하이브리드
							<%}else if(cm_bean.getDiesel_yn().equals("4")){%>	※ 플러그인 하이브리드
							<%}else if(cm_bean.getDiesel_yn().equals("5")){%>	※ 전기차
							<%}else if(cm_bean.getDiesel_yn().equals("6")){%>	※ 수소차
							<%}%>
					<%	}%>
					<%}%>			
					</td>
				    </tr>
				</table>
			    </td>	    	
          		</tr> 
          		<tr>
          			<td height=5></td>
          		</tr>
          		<tr> 
		            <td colspan="2">
<!-- 		            	<img src=./images/bar_2022_04.jpg width=638 height=22> -->
		            	<div class='esti-title'>
							<span class='esti-num'></span>
							약정운행거리 
							<sapn class='esti-title-sub'>(약정운행거리 이하 운행시 환급대여료 지급)</sapn>
						</div>
		            </td>
				</tr>
				
				<tr> 
		            <td height=4 colspan="2"></td>
				</tr>
				
				<tr> 
		            <td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		            		<tr>
		            			<td align=center bgcolor=f2f2f2 height=17 rowspan=3 width=75><span class=style3>약정운행거리</span></td>
		            			<td bgcolor=ffffff rowspan=3 align=center width=110><span class=style14><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km이하 / 1년</span></td>
		            			<td align=center bgcolor=f2f2f2 height=17 rowspan=3 width=75>
		            				<span class=style3>약정운행거리에<br>따른 정산</span>
		            			</td>
		            			<td bgcolor=f2f2f2 height=17> 
		            			  &nbsp;&nbsp; <b>(약정이하운행시) 환급대여료</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		            			  <%if(e_bean.getRtn_run_amt_yn().equals("1")){ // 환급대여료 미적용%>
		            			  	미적용
		            			  <%} else{%>
		            			  	<%=e_bean.getRtn_run_amt()%>원/1km	(부가세별도)
		            			  <%} %>
		            			</td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=f2f2f2 height=17>
		            			  &nbsp;&nbsp; <b>(약정초과운행시) 초과운행대여료</b>&nbsp;&nbsp;&nbsp;&nbsp;<%=e_bean.getOver_run_amt()%>원/1km	(부가세별도)
		            			</td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=ffffff height=17> &nbsp;&nbsp;
		            				<%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){//기본식%>
		            				매입옵션 행사시에는 (약정이하운행시) 환급대여료가 지급되지 않고, (약정초과운행시) 초과운행대여료가 면제됩니다. (기본식)
		            				<%}%>
		            			</td>
		            		</tr>
		            	</table>
		            </td>
				</tr>     
				<%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20141223){%>
                                <tr> 
				    <td colspan=2 height=22>&nbsp;<span class=style3>* 약정운행거리를 줄이면 대여요금이 인하되고, 약정운행거리를 늘리면 대여요금이 인상됩니다.</span></td>
                                </tr>
				<%}%>    		
          		<tr>
          			<td height=5></td>
          		</tr>         		
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=208>			                  	
							  	<%if(!e_bean.getIns_per().equals("2")){%>
							  	        <%if(e_bean.getEst_nm().indexOf("602") == -1 && e_bean.getEst_nm().indexOf("482") == -1 && e_bean.getEst_nm().indexOf("362") == -1 && e_bean.getEst_nm().indexOf("242") == -1 && e_bean.getEst_nm().indexOf("122") == -1){%>
<!-- 							  		<img src=/acar/main_car_hp/images/bar_02.gif width=208 height=22> -->
							  		<div class='esti-title'>
										<span class='esti-num'></span>
										대여요금 
										<sapn class='esti-title-sub'>(보험료 포함)</sapn>
									</div>
									<%}else{%>
<!-- 									<img src=/acar/main_car_hp/images/bar_02_1.gif width=208 height=22> -->
									<div class='esti-title'>
										<span class='esti-num'></span>
										대여요금 
										<sapn class='esti-title-sub'>(보험료 미포함)</sapn>
									</div>
									<%}%>
							  	<%}else{%>
<!-- 							  	<img src=/acar/main_car_hp/images/bar_02_1.gif width=208 height=22> -->
							  	<div class='esti-title'>
									<span class='esti-num'></span>
									대여요금 
									<sapn class='esti-title-sub'>(보험료 미포함)</sapn>
								</div>
							  	<%}%>				  
							  	</td>
			                  	<td width=30>&nbsp;</td>
			                  	<td width=400>
<!-- 			                  	<img src=./images/bar_03.gif width=400 height=22> -->
			                  	<div class='esti-title'>
									<span class='esti-num'></span>
									보험보상범위
								</div>
			                  	</td>
			                </tr>
			                <tr> 
			                  	<td height=1 colspan=3></td>
			                </tr>
                			<tr> 
                  				<td> 
                  					<table width=208 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      	<tr> 
				                        	<td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>대여기간</span></td>
				                        	<td width=113 align=right bgcolor=#FFFFFF><span class=style4><%=e_bean.getA_b()%>개월</span>&nbsp;&nbsp;</td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>공 급 가 </span></td>
				                        	<td align=right bgcolor=#FFFFFF><span class=style4><%if (e_bean.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getDriver_add_amt()*0.9)%> 원<%}%></span>&nbsp;&nbsp;</td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>부 가 세 </span></td>
				                        	<td align=right bgcolor=#FFFFFF><span class=style4><%if (e_bean.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean.getFee_v_amt()+e_bean.getDriver_add_amt()*0.1)%> 원<%}%></span>&nbsp;&nbsp;</td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>월대여료</span></td>
				                        	<td align=right bgcolor=#FFFFFF><span class=style14><%if (e_bean.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt()+e_bean.getDriver_add_amt())%> 원<%}%></span>&nbsp;&nbsp;</td>
			                      		</tr>
                    				</table>
                    			</td>
			                  	<td>&nbsp;</td>
			                 	<td> 
								  <%if(e_bean.getEst_nm().indexOf("602") == -1 && e_bean.getEst_nm().indexOf("482") == -1 && e_bean.getEst_nm().indexOf("362") == -1 && e_bean.getEst_nm().indexOf("242") == -1 && e_bean.getEst_nm().indexOf("122") == -1){%>
								  	<table width=400 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      	<tr> 
					                        <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>대인배상</span></td>
					                        <td width=106 align=center bgcolor=#FFFFFF><span class=style4>무한(대인 
					                          Ⅰ,Ⅱ) </span></td>
					                        <td width=92 align=center bgcolor=f2f2f2><span class=style3>무보험차상해</span></td>
					                        <td width=105 align=center bgcolor=#FFFFFF><span class=style4>1인당 
					                          최고 2억원 </span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>대물배상</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>1억원</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>운전자연령</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>만26세이상</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>자기신체사고</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>1억원</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>긴급출동</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>가입</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>자차면책금</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(ej_bean.getJg_w().equals("1")){%>50만원<%}else{%>30만원<%}%></span></td>
					                        <td align=center bgcolor=f2f2f2>&nbsp;</td>
					                        <td align=center bgcolor=#FFFFFF>&nbsp;</td>
				                      	</tr>
				                    </table>
								<%}else{%>
								  	<table width=400 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      	<tr> 
					                        <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>대인배상</span></td>
					                        <td width=106 align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
					                        <td width=92 align=center bgcolor=f2f2f2><span class=style3>무보험차상해</span></td>
					                        <td width=105 align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>대물배상</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>운전자연령</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>자기신체사고</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>긴급출동</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>자차면책금</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
					                        <td align=center bgcolor=f2f2f2>&nbsp;</td>
					                        <td align=center bgcolor=#FFFFFF>&nbsp;</td>
				                      	</tr>
				                    </table>
								<%}%>
				  				</td>
                			</tr>
                			<tr>
	          	<!-- 썬팅/블랙박스 표기 -->    
                <td class=listnum2 valign=top  colspan="2">
                <%if(ref_reg_dt >= 2021090600){ %>
	          	<%if( !(e_bean.getCar_comp_id().equals("0056") || e_bean.getCar_comp_id().equals("0057") 
	          			|| (Integer.parseInt(cm_bean.getJg_code()) > 9017300 && Integer.parseInt(cm_bean.getJg_code()) < 9018200 )) ) { // 테슬라, 폴스타, 마이티/메가트럭 제외%>
						<!-- 썬팅 -->
						&nbsp;<span class=style3><%if(e_bean.getTint_sn_yn().equals("Y")){%>* 측후면 썬팅 포함<%} else{ %>* 전면/측후면 썬팅 포함<%} %></span>
						<!-- 블랙박스 -->
						&nbsp;
						<span class=style3>
						<%if(e_bean.getTint_bn_yn().equals("Y")){%>* 블랙박스 미제공 할인
						<%} else{ %>
							<%if( Integer.parseInt(cm_bean.getJg_code()) > 9000000 ){%>* 블랙박스 포함
							<%} else{ %>* 2채널 블랙박스 포함<%}%>
						<%} %>
						</span>
                <%} %>
                <%} %>
                </td>
                </tr>
			   <!-- 번호판 -->
			   <tr>
			   	<td colspan=3 class=listnum2 valign=top>
			   	<%if(ref_reg_dt >= 2021090600){ %>
                <%-- <%if( ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4") || Integer.parseInt(cm_bean.getJg_code()) > 8000000
                		|| !(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) ){%> --%>        
                <%if( ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || Integer.parseInt(cm_bean.getJg_code()) > 8000000
                		|| !(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) ){%>        
						<%if(ej_bean.getJg_b().equals("5")){ // 엔진 구분상 전기차%>
						&nbsp;<span class=style3>* 전기차 전용번호판</span>
						<%} else if(ej_bean.getJg_b().equals("6")){ // 엔진 구분상 수소차%>
						&nbsp;<span class=style3>* 수소전기차 전용번호판</span>
						<%-- <%} else if( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ){ // 승합/화물차%> --%>
						<%} else if( Integer.parseInt(cm_bean.getJg_code()) > 9018110 && Integer.parseInt(cm_bean.getJg_code()) < 9018999 ){ %>
						&nbsp;<span class=style3>* 페인트식 일반(구형)번호판</span>
						<%} else if( !(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) ){ // 그 외 구형번호판 일부러 신청한 경우 %>
						&nbsp;<span class=style3>* 페인트식 일반(구형)번호판</span>
						<%} %>
                <%}%>
                <%}%>
                </td>
			   </tr>
                			
                			<%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && e_bean.getA_a().equals("12")) {%>
			                <tr>
			                	<td colspan="3" align="right">※ 사고수리시 아마존카 지정 정비공장에서 수리&nbsp;</td>
			                </tr>
			                <%}%>

                			
		        		<!--용품-->
		        		<%if(e_bean.getTint_s_yn().equals("Y") || e_bean.getTint_n_yn().equals("Y") || e_bean.getTint_eb_yn().equals("Y")){%>        
                        <tr> 
			    			<td colspan=3 class=listnum2 valign=top>&nbsp;<span class=style3>* 
								위 대여료는 
	                                <%if( e_bean.getTint_s_yn().equals("Y") && !e_bean.getTint_n_yn().equals("Y") && !e_bean.getTint_eb_yn().equals("Y")){%>전면 썬팅이<%}%>
	                                <%if(!e_bean.getTint_s_yn().equals("Y") &&  e_bean.getTint_n_yn().equals("Y") && !e_bean.getTint_eb_yn().equals("Y")){%>거치형 내비게이션이<%}%>
	                                <%if(!e_bean.getTint_s_yn().equals("Y") && !e_bean.getTint_n_yn().equals("Y") &&  e_bean.getTint_eb_yn().equals("Y")){%>이동형 충전기가<%}%>
	                                <%if( e_bean.getTint_s_yn().equals("Y") &&  e_bean.getTint_n_yn().equals("Y") && !e_bean.getTint_eb_yn().equals("Y")){%>전면 썬팅, 거치형 내비게이션이<%}%>
	                                <%if( e_bean.getTint_s_yn().equals("Y") && !e_bean.getTint_n_yn().equals("Y") &&  e_bean.getTint_eb_yn().equals("Y")){%>전면 썬팅, 이동형 충전기가<%}%>
	                                <%if(!e_bean.getTint_s_yn().equals("Y") &&  e_bean.getTint_n_yn().equals("Y") &&  e_bean.getTint_eb_yn().equals("Y")){%>거치형 내비게이션, 이동형 충전기가<%}%>
	                                <%if( e_bean.getTint_s_yn().equals("Y") &&  e_bean.getTint_n_yn().equals("Y") &&  e_bean.getTint_eb_yn().equals("Y")){%>전면 썬팅, 거치형 내비게이션, 이동형 충전기가<%}%>
                               	포함된 금액입니다.
                                </strong></span>
                            </td>
                        </tr>                        
                        <%}%>                			
						<%-- <%if(AddUtil.parseInt(cm_bean.getJg_code()) < 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000)){%>
		                <tr> 
							<td height=20 colspan=3 class=listnum2>&nbsp;* 대여료(월대여료,선납금)가 업무용으로 손비처리 가능할 경우 부가세는 <strong>매입세액공제(환급)받으실 수 있습니다.</strong>
							</td>
		                </tr>
						<%}%> --%>
<%-- 						<%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%> --%>
						<%if(AddUtil.parseInt(cm_bean.getS_st()) <= 101 || AddUtil.parseInt(cm_bean.getS_st()) == 409 || AddUtil.parseInt(cm_bean.getS_st()) >= 601 ){%>
		                <tr> 
							<td height=20 colspan=3 class=listnum2>&nbsp;* 대여료(월대여료,선납금)가 업무용으로 손비처리 가능할 경우 부가세는 <strong>매입세액공제(환급)받으실 수 있습니다.</strong>
							</td>
		                </tr>
						<%}%>						
						<%if(e_bean.getTint_ps_yn().equals("Y")){%> 
		                <tr>
			                <td colspan=3 class=listnum2 valign=top>
							<%if(e_bean.getTint_ps_st().equals("Y")){%>        
								&nbsp;<span class=style3>* 썬팅구분: 고급썬팅</span>
		                	<%}else if(e_bean.getTint_ps_st().equals("N")){%>
		                	<%}else if(e_bean.getTint_ps_st().equals("I")){ %>
		                		&nbsp;<span class=style3>* <%=e_bean.getTint_ps_nm()%></span>
		                	<%} %>
			                </td>
		                </tr>
		                <%}%>		
              			</table>
              		</td>
          		</tr>
          		<tr> 
					<td height=10 colspan="2"></td>
				</tr>
				
	          	<tr> 
	             	<td height=10 colspan="2"></td>
	          	</tr>
	          	<tr> 
	            	<td colspan="2">
<!-- 	            		<img src=./images/bar_2022_05.jpg width=638 height=22> -->
	            		<div class='esti-title'>
							<span class='esti-num'></span>
							초기납입금
						</div>
	            	</td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
			                <tr> 
			                  	<td width=75 height=17 align=center bgcolor=f2f2f2><span class=style3>보 
			                    증 금</span></td>
			                  	<td width=93 align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getGtr_amt())%> 
			                    원</span>&nbsp;</td>
			                  	<td width=82 align=center bgcolor=f2f2f2><span class=style4>차가의 
			                    <%=Math.round(e_bean.getRg_8())%>% </span></td>
			                  	<td width=383 bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4>보증금은 
						  	계약기간 만료 후 환불해 드립니다.&nbsp;[보증금 100만원을 증액하면, <br>&nbsp;&nbsp;월대여료 5,500원(VAT포함)이 인하됩니다.&nbsp;(년리 6.6% 효과)]</span></td>
<!-- 						  	계약기간 만료 후 환불해 드립니다.&nbsp;[보증금 100만원을 증액하면, <br>&nbsp;&nbsp;월대여료 4,620원(VAT포함)이 인하됩니다.&nbsp;(년리 5.5% 효과)]</span></td> -->
							</tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>선 
			                    납 금</span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%> 원</span>&nbsp;</td>
			                  	<td align=center bgcolor=f2f2f2><span class=style4>VAT포함</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4>선납금은 매월 일정 금액씩 
			                    공제되어 소멸되는 돈입니다. </span><br>&nbsp;&nbsp;<span class=style4 style="letter-spacing:-1.5px;">※ 세금계산서는 계약이용기간 동안 매월 균등 발행 또는 납부시 일시 발행 중 선택가능</span></td><!-- 2018.01.22 -->
			                </tr>
			                <%if(e_bean.getG_10() > 0){ %>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>개시대여료</span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 원</span>&nbsp;</td>
			                  	<td align=center bgcolor=f2f2f2><span class=style4>VAT포함</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4>개시대여료는 마지막 (<%=e_bean.getG_10()%>)개월치 
			                    대여료를 선납하는 것입니다. </span></td>
			                </tr>
			                <%} %>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>합 
			                    계 </span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style14><%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>
			                    원</span>&nbsp;</td>
			                  	<td colspan=2  bgcolor=f2f2f2> &nbsp;&nbsp;&nbsp; <span class=style4>위의 대여요금은 좌측 초기납입금 이자효과가 반영된 금액입니다.</span></td>
			                </tr>
              			</table>
              		</td>
	          	</tr>
			  	<%if(e_bean.getIfee_s_amt()>0){%>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
			                <tr> 
			                  	<td width=206 height=17 align=center bgcolor=f2f2f2><span class=style3>월대여료 
			                    잔여납입회수</span></td>
			                  	<td width=82 align=center bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>회</span></td>
			                  	<td width=346 bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4>개시대여료를 
			                    납입한 경우만 적용되는 내용입니다. </span></td>
			                </tr>
              			</table>
              		</td>
          		</tr>
		  		<%}%>
      <tr> 
		    <td colspan=2>&nbsp;<span class=style3>* 초기납입금은 고객님의 신용도에 따라 심사과정에서 조정될 수 있습니다.</span></td>
      </tr>		  		
			<!--적용잔가율-->
			<%if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){//fms견적%>
			<%	if(opt_chk.equals("1")){%>
                <tr> 
                    <td height=10 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2">
<!--                     <img src=images/bar_2022_06.jpg width=638 height=22> -->
                    <div class='esti-title'>
							<span class='esti-num'></span>
							적용 잔가율
						</div>
                    </td>
                </tr>
                <tr> 
                    <td height=4 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2"> 
                        <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr> 
                                <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>적용잔가율</span></td>
                                <td width=113 align=center bgcolor=#FFFFFF><span class=style4><%=e_bean.getRo_13()%>%</span></td>
                                <td width=60 align=center bgcolor=f2f2f2><span class=style4>&nbsp;</span></td>
                                <td width=368 bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4>적용잔가율 = 매입옵션율</span></td>
                            </tr>
                            <tr> 
                                <td height=17 align=center bgcolor=f2f2f2><span class=style3>매입옵션가격</span></td>
                                <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>원</span>&nbsp;&nbsp;</td>
                                <td align=center bgcolor=f2f2f2><span class=style4>VAT포함</span></td>
                                <td bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4>본 매입옵션가격에 이용차량을 매입할 수 있는 권리를 드립니다.</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
			<%	}%>			
			<%}else{//주요차종견적%>
			<%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
                <tr> 
                    <td height=10 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2">
<!--                     	<img src=images/bar_2022_06.jpg width=638 height=22> -->
                    	<div class='esti-title'>
							<span class='esti-num'></span>
							적용 잔가율
						</div>
                    </td>
                </tr>
                <tr> 
                    <td height=4 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2"> 
                        <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr> 
                                <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>적용잔가율</span></td>
                                <td width=113 align=center bgcolor=#FFFFFF><span class=style4><%=e_bean.getRo_13()%>%</span></td>
                                <td width=60 align=center bgcolor=f2f2f2><span class=style4>&nbsp;</span></td>
                                <td width=368 bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4>적용잔가율 = 매입옵션율</span></td>
                            </tr>
                            <tr> 
                                <td height=17 align=center bgcolor=f2f2f2><span class=style3>매입옵션가격</span></td>
                                <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>원</span>&nbsp;&nbsp;</td>
                                <td align=center bgcolor=f2f2f2><span class=style4>VAT포함</span></td>
                                <td bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4>본 매입옵션가격에 이용차량을 매입할 수 있는 권리를 드립니다.</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
			<%	}%>			
			<%}%>
<!--적용잔가율-->
          		<tr> 
					<td height=10 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2">
		            <%-- <%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
					<img src=/acar/main_car_hp/images/bar_2022_08.jpg>
		            <%}else{%>
		            <img src=./images/bar_2022_07_yj.jpg width=638 height=22>
		            <%	}%> --%>
		            <div class='esti-title'>
						<span class='esti-num'></span>
						중도해지위약금
					</div>
		            </td>
				</tr>
				<tr> 
		            <td height=4 colspan="2"></td>
				</tr>
				
				<tr> 
		            <td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		            		<tr>
		            			<td align=center bgcolor=f2f2f2 height=17><span class=style3>중도해지위약금</span></td>
		            			<td colspan=2 bgcolor=ffffff> &nbsp;&nbsp;중도해지시에는 잔여계약기간 총 대여료의 <span class=style14><%if(e_bean.getCls_per()>0){%><%=e_bean.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean.getCls_per())%><%}else{%>30<%}%>%</span> 의 위약금이 있음</td>
		            		</tr>
		            	</table>
		            </td>
				</tr>
          		<tr> 
            		<td height=10 colspan="2"></td>
	          	</tr>
	          	<!--차량관리 서비스 제공범위-->
	          	<tr> 
	            	<td colspan="2">
	            	    <%-- <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
	            	        <%if(ej_bean.getJg_k().equals("0")){%>
	            	        <img src=./images/bar_07_1_2.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=./images/bar_07_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- 대차서비스는 일반 내연기관차량으로 제공 2017.11.15 -->
	            	        <img src=./images/bar_07_3.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("4")){%><!-- 포터 일렉트릭 대차서비스는 일반 내연기관 승용 및 RV 차량으로 제공 2019.12.12 -->
	            	        <img src=./images/bar_07_4.png width=638 height=22>
	            	        <%}else{%>
	            	        <img src=./images/bar_2022_07.jpg width=638 height=22>
	            	        <%}%>
	            	    <%}else{%>
	            	        <%if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=./images/bar_06_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- 대차서비스는 일반 내연기관차량으로 제공 2017.11.15 -->
	            	        <img src=./images/bar_06_3.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("4")){%><!-- 포터 일렉트릭 대차서비스는 일반 내연기관 승용 및 RV 차량으로 제공 2019.12.12 -->
	            	        <img src=./images/bar_06_4.png width=638 height=22>
	            	        <%}else{%>
	            	        <img src=./images/bar_06_1.gif width=638 height=22>
	            	        <%}%>	            	    	            	        
	            	    <%	}%> --%>
	            	    <div class='esti-title'>
								<span class='esti-num'></span>
								차량관리 서비스 제공범위
								<sapn class='esti-title-sub'>(공통서비스와 체크된 □칸의 서비스가 제공됩니다)</sapn> 
								<sapn style='font-size: 10px; letter-spacing: -1px;'>
									<%if(ej_bean.getJg_k().equals("0")){%>
			            	        ※ 대차서비스 미제공
			            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
			            	        ※ 대차서비스는 승용 및 RV로 제공
			            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- 대차서비스는 일반 내연기관차량으로 제공 2017.11.15 -->
			            	        ※ 대차서비스는 일반 내연기관차량으로 제공
			            	        <%}else if(ej_bean.getJg_k().equals("4")){%><!-- 포터 일렉트릭 대차서비스는 일반 내연기관 승용 및 RV 차량으로 제공 2019.12.12 -->
			            	        ※ 대차서비스는 일반 내연기관 승용 및 RV로 제공
			            	        <%}%>
								</sapn>
							</div>
	            	</td>
	          	</tr>
          		<tr> 
		          <td colspan="2" valign=top> 
		          		<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                  	<tr> 
		                     	<td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>공통서비스</span></td>
		                    	<td width=543 colspan=2 bgcolor=#FFFFFF>&nbsp;&nbsp; <%if(!e_bean.getInsurant().equals("2")){%>* 교통사고 발생시 <span class=style3><b>사고처리 업무 대행</b></span><%}%> &nbsp;&nbsp;&nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;*<span class=style3> <b>사고대차서비스</b></span>(피해사고시는 보험대차)<%}%> </td>
		                    </tr>
		                </table>
		          </td>
		         </tr>
		         <tr></tr>
		         <tr>
		         	<td colspan="2">
		                <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                    <tr>
		                       	<td colspan=2 align=center bgcolor=#f2f2f2 height=17><input type="checkbox" name="rent_way" value="3" <%if(!ej_bean.getJg_k().equals("0") && !rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>기본식</b> (정비서비스 미포함 상품)</span></td>
		                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<input type="checkbox" name="rent_way" value="1" <%if(!ej_bean.getJg_k().equals("0") && rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>일반식</b> (정비서비스 포함 상품)</span></td>
		                  	</tr>
		                  	<tr>
		                  		<td width=356 colspan=2 bgcolor=#FFFFFF height=95>&nbsp; <span class=style3><b>* 아마존케어 서비스</b></span><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - 차량 정비 관련 유선 상담서비스 상시 제공<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - 대여 개시 2개월 이내 무상 정비대차 제공<%if(e_bean.getCar_comp_id().equals("0056")) {%>(테슬라차량 제외)<%}%><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24시간 이상 정비공장 입고시)<br> 
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - 대여 개시 2개월 이후 원가 수준의 유상 정비대차 제공<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (단기 대여요금의 15~30% 수준, 탁송료 별도)</td>
		                   		<td width=279 bgcolor=#FFFFFF align=left>&nbsp; <span class=style3><b>* 일체의 정비서비스</b></span><br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 각종 내구성부품/소모품 점검, 교환, 수리<br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 제조사 차량 취급설명서 기준<br>
		                   		&nbsp;<span class=style3><b> * 정비대차서비스</b></span><br> 
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 4시간 이상 정비공장 입고시</td>
		                 	</tr>
		         		</table>
		         	</td>
		        </tr>
				
				<tr> 
		            <td height=10 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2">
		            <%-- <%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
		            <img src=/acar/main_car_hp/images/bar_2022_09.jpg width=638 height=22>
		            <%}else{%>
		            <img src=./images/bar_08.gif width=638 height=22>
		            <%	}%> --%>
		            <div class='esti-title'>
						<span class='esti-num'></span>
						기타대여조건
					</div>
		            </td>
				</tr>
				<tr> 
		            <td height=4 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2" align=center> 
		            	<table width=621 border=0 cellspacing=0 cellpadding=0>
		            		<tr> 
			                  	<td width=28 height=17 align=right style='vertical-align: baseline'><img src=./images/1.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=593 colspan=2 align=left class=listnum2>
			                  	제조사의 차량 상품성 개선, 연식 변경 또는 정부 정책(안전사양 의무장착, 배기가스저감, 세율조정 등) 등으로<br>차량가격이 변동되거나 정부 조세정책이 변경될 경우 상기 견적금액은 변동 될 수 있습니다.
			                  	</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td width=20 height=17 align=right><img src=./images/2.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=593 colspan=2 align=left class=listnum2>등록, 자동차세 납부<%if (!e_bean.getCar_comp_id().equals("0056")) {%>, 정기검사<%}%> 
			                    등도 아마존카에서 처리(고객 비용 부담 없음) </td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=./images/3.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>홈페이지에서 대여차량 유지관리내역 정보제공 [FMS(Fleet Management System)]</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=./images/4.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>			                  	
			                  	<td colspan=2 align=left class=listnum2>
			                  		<span class=style4>대여기간 만료시에는 반납, 연장이용<%if( !(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")) ) {%> (할인요금 적용)<%}%>, 매입옵션 행사 중 선택 가능</span>
			                  	</td>
			                  	<%-- <td colspan=2 align=left class=listnum2>
			                  		대여기간 만료시에는 반납, 연장이용
			                  		<%if(!e_bean.getCar_comp_id().equals("0056") && (!cm_bean.getJg_code().equals("9133") && !cm_bean.getJg_code().equals("9237") && !cm_bean.getJg_code().equals("9015435") && !cm_bean.getJg_code().equals("9025435") && !cm_bean.getJg_code().equals("9015436") && !cm_bean.getJg_code().equals("9015437") && !cm_bean.getJg_code().equals("9025439") && !cm_bean.getJg_code().equals("9025440") )) {%>
			                  		(할인요금 적용)
			                  		<%}%>
			                  		<%if(opt_chk.equals("1")){%>, 매입옵션 행사<%}%> 중 선택 가능
			                  	</td> --%>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <%-- <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("21")){%>
			                <tr> 
			                  	<td height=17 align=right><img src=./images/4.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>계약기간 동안 
			                    아래금액의 이행(지급)보증보험 가입조건(신용우수업체 면제) </td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td colspan=4 height=3></td>
			                </tr>
			                <%if (e_bean.getGi_fee() > 0) {%>
							<tr>
								<td colspan=4 align=right style="font-weight: bold;">※ 신용등급 <%=e_bean.getGi_grade()%>등급기준</td>
							</tr>
							<%}%>
			                <tr> 
			                  	<td height=24>&nbsp;</td>
			                  	<td>&nbsp;</td>
			                  	<td width=17><img src=./images/arrow_1.gif width=10 height=6>&nbsp;</td>
			                  	<td width=569 align=left> 
			                  		<table width=569 border=0 cellpadding=0 cellspacing=0 background=./images/img_bg.gif>
				                      	<tr> 
				                        	<td colspan=3><img src=./images/img_up.gif width=569 height=5></td>
				                      	</tr>
				                     	<tr> 
				                        	<td width=15 height=15>&nbsp;</td>
				                        	<td width=270><img src=./images/dot.gif width=5 height=5 align=absmiddle> 
				                          	<span class=style12>보증보험 가입금액</span><span class=style13> 
				                          	|</span> <span class=style4><%=AddUtil.parseDecimal(e_bean.getGi_amt())%>원
				                          	</span></td>
				                        	<td width=284><img src=./images/dot.gif width=5 height=5 align=absmiddle> 
					                          	<span class=style12>보증보험료(<%=e_bean.getA_b()%>개월치)</span>
					                          	<span class=style13>|</span> 
					                          	<span class=style4>
				                          		<%if (e_bean.getGi_amt() > 0) {%>
						                          	<%if (!e_bean.getGi_grade().equals("")) {%>
						                          		<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>&nbsp;원
						                          	<%} else {%>
					                          			<span style="padding-left: 60px;">원</span>
						                          	<%}%>
					                          	<%} else {%>
					                          		<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>&nbsp;원
					                          	<%}%>
					                          	</span>
				                          	</td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=3><img src=./images/img_dw.gif width=569 height=5></td>
				                      	</tr>
			                    	</table>
			                    </td>
			                </tr>
			                <%if (e_bean.getGi_amt() > 0) {%>
							<tr>
								<td colspan=4 align=right>※ 신용등급별로 보증보험료가 달라집니다.</td>
							</tr>
							<%}%>
			                <%}%> --%>
		              	</table>
					</td>
				</tr>
				<tr> 
		            <td height=5 colspan="2">&nbsp;</td>
				</tr>
				<tr> 
		            <td align=right><img src=./images/ceo.gif>&nbsp;</td>
		            <td align=right>&nbsp;</td>
				</tr>
				<tr> 
		            <td height=10 colspan="2"></td>
				</tr>
			</table>
		</td>
        <td width=21>&nbsp;</td>
	</tr>
    <tr id='esti_button_tr'>
        <td align=center colspan=3>
		      <a href=javascript:go_print('<%= est_id %>');><img src=./images/button_print.gif border=0></a>&nbsp;&nbsp;
		      <a href=javascript:go_mail('<%= est_id %>');><img src="./images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;
  		    <%	if(ej_bean.getJg_w().equals("1")||ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){//수입차,친환경차%>
  		    <%	}else{%>
  		    <%		if(AddUtil.parseInt((String)sh_comp.get("AE93")) < 0 || AddUtil.parseInt((String)sh_comp.get("AE93")) > 0){%>
		  	  <a href=javascript:go_compare('<%= est_id %>');><img src=./images/button_compare.gif border=0></a>&nbsp;&nbsp;
		  	  <%		}%>
		  	  <%	}%>
		      <a href="javascript:go_paper();"><img src=./images/button_paper.gif border=0></a>
		    </td>
    </tr>
    <tr>
        <td height=15></td>
    </tr>
	<tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
</table>

</form>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	
    </body>
</html>