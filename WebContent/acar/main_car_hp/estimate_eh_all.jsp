<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*" %>
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
	
	EstimateBean e_bean1 = new EstimateBean();
	EstimateBean e_bean2 = new EstimateBean();
	EstimateBean e_bean3 = new EstimateBean();
	EstimateBean e_bean4 = new EstimateBean();
	
	//잔가 차량정보
	Hashtable sh_comp = new Hashtable();
	//견적 확인정보
	Hashtable exam = new Hashtable();
	Vector vars = new Vector();
	
	if (from_page.equals("/acar/estimate_mng/./images/line.gif")) {
		from_page = "/acar/estimate_mng/esti_mng_u.jsp";
	}
	
	if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		e_bean 		= e_db.getEstimateCase(est_id);
		sh_comp 	= shDb.getShCompare(est_id);
		exam 		= shDb.getEstiExam(est_id);
		vali_date 	= AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 9));
		vars 		= e_db.getABTypeEstIds2(e_bean.getSet_code(), e_bean.getEst_id());
		e_bean1 = e_bean;
	}else{
		e_bean 		= e_db.getEstimateHpCase(est_id);
		sh_comp 	= shDb.getShCompareHp(est_id);
		exam 		= shDb.getEstiExamHp(est_id);
		vars 		= e_db.getABTypeEstIds3(e_bean.getEst_id());
		if(vars.size()==0)	e_bean2 = e_bean;	
		else				e_bean1 = e_bean;
	}
	
	int size = vars.size();
	
	for(int i = 0 ; i < size ; i++){
		Hashtable var = (Hashtable)vars.elementAt(i);
		if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
			if(i==0) e_bean1 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==1) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==2) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==3) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
		}else{
			if(i==0) e_bean1 = e_db.getEstimateHpCase(String.valueOf(var.get("EST_ID")));
			if(i==1) e_bean2 = e_db.getEstimateHpCase(String.valueOf(var.get("EST_ID")));
			if(i==2) e_bean3 = e_db.getEstimateHpCase(String.valueOf(var.get("EST_ID")));
			if(i==3) e_bean4 = e_db.getEstimateHpCase(String.valueOf(var.get("EST_ID")));
		}
	}
	
	exam 			= shDb.getEstiExam(e_bean1.getEst_id());
	
	//조정대여료가 있다면
	if(e_bean1.getCtr_s_amt()>0){
		e_bean1.setFee_s_amt(e_bean1.getCtr_s_amt());
		e_bean1.setFee_v_amt(e_bean1.getCtr_v_amt());
		
		if(e_bean1.getIfee_s_amt()>0 && e_bean1.getG_10()>1){
			e_bean1.setIfee_s_amt(e_bean1.getCtr_s_amt()*e_bean1.getG_10());
			e_bean1.setIfee_v_amt(e_bean1.getCtr_v_amt()*e_bean1.getG_10());
		}
	}
	
	//조정대여료가 있다면
	if(e_bean2.getCtr_s_amt()>0){
		e_bean2.setFee_s_amt(e_bean2.getCtr_s_amt());
		e_bean2.setFee_v_amt(e_bean2.getCtr_v_amt());
		
		if(e_bean2.getIfee_s_amt()>0 && e_bean2.getG_10()>1){
			e_bean2.setIfee_s_amt(e_bean2.getCtr_s_amt()*e_bean2.getG_10());
			e_bean2.setIfee_v_amt(e_bean2.getCtr_v_amt()*e_bean2.getG_10());
		}
	}
	
	//조정대여료가 있다면
	if(e_bean3.getCtr_s_amt()>0){
		e_bean3.setFee_s_amt(e_bean3.getCtr_s_amt());
		e_bean3.setFee_v_amt(e_bean3.getCtr_v_amt());
		
		if(e_bean3.getIfee_s_amt()>0 && e_bean3.getG_10()>1){
			e_bean3.setIfee_s_amt(e_bean3.getCtr_s_amt()*e_bean3.getG_10());
			e_bean3.setIfee_v_amt(e_bean3.getCtr_v_amt()*e_bean3.getG_10());
		}
	}
	
	//조정대여료가 있다면
	if(e_bean4.getCtr_s_amt()>0){
		e_bean4.setFee_s_amt(e_bean4.getCtr_s_amt());
		e_bean4.setFee_v_amt(e_bean4.getCtr_v_amt());
		
		if(e_bean4.getIfee_s_amt()>0 && e_bean4.getG_10()>1){
			e_bean4.setIfee_s_amt(e_bean4.getCtr_s_amt()*e_bean4.getG_10());
			e_bean4.setIfee_v_amt(e_bean4.getCtr_v_amt()*e_bean4.getG_10());
		}
	}	
	

	//조정 위약금이 있다면 
	if(e_bean1.getCtr_cls_per()>0){
		e_bean1.setCls_per(e_bean1.getCtr_cls_per());
	}

	//조정 위약금이 있다면 
	if(e_bean2.getCtr_cls_per()>0){
		e_bean2.setCls_per(e_bean2.getCtr_cls_per());
	}

	//조정 위약금이 있다면 
	if(e_bean3.getCtr_cls_per()>0){
		e_bean3.setCls_per(e_bean3.getCtr_cls_per());
	}

	//조정 위약금이 있다면 
	if(e_bean4.getCtr_cls_per()>0){
		e_bean4.setCls_per(e_bean4.getCtr_cls_per());
	}
	
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
	
	
	String br_id 	= "S1";
	String name 	= "";
	String m_tel	= "";
	String h_tel	= "";
	String i_fax	= "";
	String email	= "";
	
	UsersBean user_bean 	= new UsersBean();
	
	if(!e_bean.getReg_id().equals("") && e_bean.getReg_id().length() == 6){
		user_bean = umd.getUsersBean(e_bean.getReg_id());
	}else{
		if(!acar_id.equals("")){
			user_bean = umd.getUsersBean(acar_id);
		}
	}
	
	name 		= user_bean.getUser_nm();
	m_tel 		= user_bean.getUser_m_tel();
	br_id   	= user_bean.getBr_id();
	h_tel 		= user_bean.getHot_tel();
	i_fax 		= user_bean.getI_fax();
	email 		= user_bean.getUser_email();
	
	if(e_bean.getCaroff_emp_yn().equals("3")){
		name 		= "";
		m_tel 		= "";
		br_id   	= "";
		h_tel 		= "";	
		i_fax 		= "";	
		email 		= "";	
	}
	
	if(name.equals("박규숙")) name = "최수진";
	if(name.equals("김지영")) m_tel = "";
	if(name.equals("김설희")) m_tel = "";
	if(name.equals("권웅철")) name = "유재석 팀장";
	if(name.equals("성장근")) name = "항상다이렉트";
	if(name.equals("강훈구")){ name = "서경오토플랜"; m_tel = h_tel;}
	if(name.equals("염정진2")) name = "아마존플러스";
// 	if(name.equals("정은희")) name = "유니즈카";
	if(name.equals("이세인")) name = "SI오토-빌려탈CAR";
	if(name.equals("이동주")) name = "(주)알에스컴퍼니";
	if(name.equals("임대호")) name = "더베스트고";
	if(name.equals("안대윤")) name = "렌탈파트너";
	
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
<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="euc-kr">
<title>견적서</title>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
$(document).ready(function(){	
	var contiRatDesc = $('#contiRatDesc').text();
	var point = contiRatDesc.indexOf("(");
	if(point >= 0){
		$('#contiRatDesc').text(contiRatDesc.substring(0,point) + "(복합연비기준)");
	}else{
		$('#contiRatDesc').text(contiRatDesc + "(복합연비기준)");
	}
})
</script>
<style type="text/css">
<!--
table {
 border-collapse: collapse;
 border-spacing: 0;
}

.table_est   {border:1px solid #c4c4c4; margin-bottom:2px;}
.table_est td{border:1px solid #c4c4c4; height:18px;}

.table_est td.bd_left   {border-left:1px solid #dcdddd;}
.table_est td.bd_top    {border-top:1px solid #dcdddd;}
.table_est td.bd_bottom {border-bottom:1px solid #dcdddd;}
.ht td{height:14px;}
.style1 {
	color: #ff00ff;
	font-weight:900;
	font-size: 14pt
}
.style2 {
	color: #706f6f;
	font-weight:900;
}

.style3 {
	color: #333333; 
}
.style4 {color: #000000;}
.style5 {color: #444444; line-height:5px; }
.style6 {color: #000000; font-weight:900;}
.style7 {color: #dc0039; font-weight:900;}
.style8 {color: #1368f5;font-weight:900;}
.style9 {color: #000000; font-size:11px;}
.style10 {font-weight:900;}
.style12 {color: #9cb445;font-weight:900; }
.style13 {
	color: #c4c4c4;
	font-weight:900;
}
.style14 {color: #616161}
.endDt {font-weight: bold; text-decoration: underline; font-size: 13px}
-->
</style>
<link href="/acar/main_car_hp/style_est.css" rel="stylesheet" type="text/css">


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

	//인쇄하기
	function go_print(est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.action = "esti_print_eh_all.jsp";
		fm.target = "_blank";
		fm.submit();		
	}	
	//메일수신하기
	function go_mail(est_id){
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&acar_id=<%=acar_id%>&write_id=<%=e_bean.getReg_id()%>&from_page=<%=from_page%>&opt_chk=<%=opt_chk%>&est_email=<%=e_bean.getEst_email()%>&content_st=hp_eh_all";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=600, scrollbars=no, status=yes");
	}
	
	//준비서류보기
	function go_paper(){
		var SUBWIN="/acar/main_car_hp/papers.html";	
		window.open(SUBWIN, "openpaper", "left=50, top=50, width=573, height=720, status=no, scrollbars=no, resizable=no");
	}
	
	//기본사양보여주기
	function opt(est_id){  
		var fm = document.form1;
		var SUBWIN="opt.jsp?est_id="+est_id+"&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=798, height=550, scrollbars=yes, status=yes, resizable=no");
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
<body topmargin=0 leftmargin=0>
<form action="" name="form1" method="POST" >
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="est_id" value="<%=est_id%>">
<input type="hidden" name="acar_id" value="<%=acar_id%>">
<input type="hidden" name="mobile_yn" value="<%=mobile_yn%>">
<input type="hidden" name="content_st" value="hp_eh_all">
<table width=740 border=0 cellspacing=0 cellpadding=0>
    <tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
    <tr>
        <td height=8 colspan=3></td>
    </tr>
	  <%if(e_bean.getVali_type().equals("0") || e_bean.getVali_type().equals("1")){
				vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 9));
			}else if(e_bean.getVali_type().equals("2")){
				vali_date = "미확정 견적입니다.";
			}
		%>
    <tr>
        <td colspan=3>
            <table width=740 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=21>&nbsp;</td>
                    <td width=528><img src=../main_car_hp/images/title_2.gif></td>
                    <td width=170 align=right>
                        <table width=170  class="table_est">
                            <%if(AddUtil.parseInt(AddUtil.getDate(4)) >= 20170930 && AddUtil.parseInt(AddUtil.getDate(4)) < 20171010){//긴연휴기간%>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>기준일</span></td>
                                <td width=107 bgcolor=ffffff align=center><span class=style16>2017-09-30</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>유효기간</span></td>
                                <td bgcolor=ffffff align=center><span class=style16></span></td>
                            </tr>
                            <%}else{%>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>작성일</span></td>
                                <td width=107 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
							              <%	if(!vali_date.equals("")){%>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>유효기간</span></td>
                                <td bgcolor=ffffff align=center><span class=style16><%=vali_date%></span></td>
                            </tr>
							              <%	}%>
							              <%}%>
                        </table>
                    </td>
                    <td width=21>&nbsp;</td>
                </tr>
				        <%if(e_bean.getVali_type().equals("1")){%>
                <tr>
                    <td colspan='3' align=right>* 메이커D/C 변경시 대여요금도 변경됩니다.</td>
                    <td width=21>&nbsp;</td>
                </tr>
				        <%}%>
            </table>
        </td>
    </tr>	

    <tr>
        <td height=10 colspan=3></td>
    </tr>
    <tr>
        <td width=21>&nbsp;</td>
        <td width=698>
            <table width=698 border=0 cellspacing=0 cellpadding=0>
          		<tr> 
            		<td colspan="2"> 
            			<table width=698 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=410> 
			                  		<table width=410 border=0 cellspacing=0 cellpadding=0>
				                      	<tr> 
				                        	<td height=10 colspan=4><span class=style1></span></td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=4><img src=./images/line.gif width=409 height=1></td>
					                	</tr>
					                	<tr> 
					                        <td width=24 height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
					                        <td colspan='3'><div align="left"><span class=style2><%=e_bean.getEst_nm()%> <%=e_bean.getMgr_nm()%>&nbsp;님 귀하</span></div></td>
					               		</tr>
					                 	<tr> 
					                        <td colspan=4><img src=./images/line.gif width=409 height=1></td>
					                 	</tr>
					                  	<tr> 
					                        <td width=24 height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
					                        <td width=160><span class=style2>TEL.<%=e_bean.getEst_tel()%></span></td>
					                        <td width=24 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
					                        <td width=202><span class=style2>FAX.<%=e_bean.getEst_fax()%></span></td>
					                 	</tr>
					                	<tr> 
					                        <td colspan=4><img src=./images/line.gif width=409 height=1></td>
					                 	</tr>
				                    </table>
								</td>
                  				<td width=47>&nbsp;</td>
                  				<td width=241 valign=bottom> 
                  					<table width=241 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/tel_bg_comp.gif class="ht">
										<tr> 
				                        <td colspan=4 height=0></td>
				                      </tr>
				                      <tr> 
				                        <td width=75 align=center><span class=style5><%= name %></span></td>
				                        <td width=30 align=right><span class=style5>hp)</span></td>
				                        <td width=136>&nbsp;<span class=style5><%= m_tel %></span></td>
				                      </tr>
				                     	<tr> 
				                        <td></td>
				                        <td align=right><span class=style5>tel)</span></td>
				                        <td>&nbsp;<span class=style5 ><%= h_tel %></span></td>
				                      </tr>
				                     	<tr> 
				                     	<td></td>
				                        <td align=right><span class=style5>fax)</span></td>
				                        <td>&nbsp;<span class=style5><%= i_fax %></span></td>
				                      </tr>
				                    	<tr> 
				                        <td></td>
				                        <td colspan='2'>&nbsp;<span class=style5><%= email %></span></td>
				                      </tr>  
										<tr> 
				                        <td style="height:10px;"></td>
				                      </tr>
				                    </table>
                   				</td>
                			</tr>
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
								/* if(e_bean.getEcar_loc_st().equals("0")){ //서울
								}else if(e_bean.getEcar_loc_st().equals("1")){ //인천,경기
								}else if(e_bean.getEcar_loc_st().equals("2")){ //강원 	
									reg_loc_st = 7;	//대구
								}else if(e_bean.getEcar_loc_st().equals("3")){ //대전 
									//reg_loc_st = 4;	//대전
									reg_loc_st = 7;	//대구
								}else if(e_bean.getEcar_loc_st().equals("4")){ //광주,전남,전북
									reg_loc_st = 7;	//대구
								}else if(e_bean.getEcar_loc_st().equals("5")){ //대구
									reg_loc_st = 7;	//대구
								}else if(e_bean.getEcar_loc_st().equals("6")){ //부산,울산,경남
									reg_loc_st = 3;	//부산
								}else if(e_bean.getEcar_loc_st().equals("7")){ //세종,충남,충북(대전제외)
									reg_loc_st = 7;	//대구
								}else if(e_bean.getEcar_loc_st().equals("8")||e_bean.getEcar_loc_st().equals("9")){ //경북,울산/경남
									reg_loc_st = 7;	//대구
								}else if(e_bean.getEcar_loc_st().equals("10")){ //전남,전북(광주제외)
								} */								
								
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
							<img src=./images/bar_01_car_prt.gif align=right>
							<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))) > 0 ){%>
								<div style="font-size: 10.8px; padding-top: 7px;">
								※ 본 견적 차량가격은 개소세 3.5% 기준 차가로 개소세 5% 기준 환산 차량가격은 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))))%>원<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))) > 0 ){%>(친환경차 세제혜택 후 <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))))%>원)<%}%> 정도입니다.
								</div>
							<%} %>
							<span style="position: absolute; top:0; right:0;font-weight: bold;font-size: 13px;text-decoration: underline;">
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
						<!-- <img src=./images/bar_01_car_prt.gif align=right> -->
							<div style="position: relative;">
								<img src=./images/bar_01_car_prt.gif align=right>
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
	            		<table width=698 class="table_est">
			                <tr> 
			                  	<td width=115 height=17 align=center bgcolor=f2f2f2><span class=style3>제조사</span></td>
			                  	<td width=419>&nbsp;<span class=style4><%=cm_bean.getCar_comp_nm()%></span></td>
			                  	<td width=100 align=center bgcolor=f2f2f2><span class=style3>금 
			                    액</span></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>차종(차량모델명)</span></td>
			                  	<td>&nbsp;<span class=style8><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%if(cm_bean.getCar_nm().equals(cm_bean.getCar_name())){ car_nm_length = cm_bean.getCar_nm().length();%><%=cm_bean.getCar_nm()%><%}else{ car_nm_length = cm_bean.getCar_nm().length()+cm_bean.getCar_name().length(); %><%=cm_bean.getCar_nm()+" "+cm_bean.getCar_name()%><%}%></a> 
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
			                  	<td align=right><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_amt())%> 
			                    원</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>옵 
			                    션</span></td>
			                  	<td>&nbsp;<span class=style6><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=e_bean.getOpt()%></a></span></td>
			                  	<td align=right><span class=style4><%=AddUtil.parseDecimal(e_bean.getOpt_amt())%> 
			                    원</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>색 
			                    상 </span></td>
			                  	<td>&nbsp;<span class=style6><%if(!e_bean.getIn_col().equals("")){%>외장: <%}%><%=e_bean.getCol()%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;내장: <%=e_bean.getIn_col()%><%}%><%if(!e_bean.getGarnish_col().equals("")){%>&nbsp;/&nbsp;가니쉬: <%=e_bean.getGarnish_col()%><%}%></span></td>
			                  	<td align=right><span class=style4><%=AddUtil.parseDecimal(e_bean.getCol_amt())%> 
			                    원</span>&nbsp;</td>
			                </tr>
			                <%if(!e_bean.getConti_rat().equals("")){%>
			                <tr>
			                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>연 
			                    비 </span></td>
			                  	<td>
			                  		<span id="contiRatDesc">
			                  			<%=e_bean.getConti_rat()%>
			                  		</span>
			                  	</td>
			                  	<td></td>
			                </tr>
			                <%}%>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>기 
			                    타 </span></td>
			                    <td bgcolor=#FFFFFF>&nbsp;
<%-- 			                    	<%if( (ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")) && !e_bean.getEcar_loc_st().equals("13") ){%> --%>
			                    	<%-- <%if( ej_bean.getJg_g_7().equals("3") && AddUtil.parseInt(String.valueOf(exam.get("BK_128"))) > 0 ){%>
			                  			※ 본 견적은 참고용 예상 견적으로 2022년 보조금 확정 공고시 월대여료가 변경 될 수 있습니다.<br>
			                  		<%}%> 2022.02.18. 해당 문구 미표기 요청으로 주석처리. --%>
			                  		<%if(e_bean.getDc_amt()>0){%>제조사D/C (<%=e_bean.getRent_dt().substring(4, 6)%>월 출고조건)&nbsp;<%=e_bean.getEsti_d_etc()%><%}%>
			                  		<%if(e_bean.getDc_amt()>0 && !e_bean.getEtc().equals("")){%><br>&nbsp;&nbsp;<%}%>
                  					<%if(!e_bean.getEtc().equals("") ){%><%=e_bean.getEtc()%><%}%>
                  					
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
			                  	<td align=right><span class=style4><%if(e_bean.getDc_amt()>0){%>-<%=AddUtil.parseDecimal(e_bean.getDc_amt())%> 
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
			                  	<td style="font-size:11px;">
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
                    	int car_c_amt = e_bean1.getCar_amt()+e_bean1.getOpt_amt()+e_bean1.getCol_amt()-e_bean1.getDc_amt();
                    	double fee_pp_amt = e_bean1.getFee_s_amt()+(e_bean1.getPp_s_amt()/AddUtil.parseDouble(e_bean1.getA_b()));		//월대여료+선납금/개월수
                    	//보증금이자효과 20191108
                    	double grt_mo_amt = 0;
                    	if(e_bean1.getGtr_amt() >0){
                    		//grt_mo_amt = e_bean1.getGtr_amt()*0.06/12*0.014;
                    		grt_mo_amt = e_bean1.getGtr_amt()*(em_bean.getA_f_2()/100)/12*0.014;
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
                    			fee_add_text1 = "한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우<br>&nbsp; 월대여료가 "+AddUtil.parseDecimal(fee_add_amt1)+"원(공급가) 인상됩니다.(견적1 기준)";	//문구변경(20190527)
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
                    
				  <%if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){%>
					<% if(!e_bean.getEcar_loc_st().equals("13")){ %>
               		  		<span class=style4>※ 보조금 소진 또는 변경, 차량 출고지연 등으로 대여료가 변경되거나 계약진행이 불가능 할 수 있습니다.</span>
						<%} else{%>
              	 	  		<% if(! (cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113")) ){ %>
               		  			<span class=style4>&nbsp;&nbsp;[보조금 없는 견적]</span>
							<%}%>
						<%}%>
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
			                  	<td align=right><span class=style7><%=AddUtil.parseDecimal(e_bean.getO_1())%> 
			                    원</span>&nbsp;</td>
			                </tr>
	              		</table>
	              	</td>
	          	</tr>
          		<tr> 
		            <td height=10 colspan="2">
		                <table width=698 border=0 cellpadding=0 cellspacing=1>
		                	<%if(endDt){%><!-- 단산 차종 문구 2017.11.08 -->
		                	<tr>
		                		<td><span class="endDt">※ 생산 중단된 차종입니다. 영업 담당자를 통해서 재고 유무를 확인하고 진행하시기 바랍니다.</span></td>
		                	</tr>
		                	<%}%>
		                    <tr>
		                        <td colspan='2'>
		                        	<%if(ej_bean.getJg_g_7().equals("3")){ //전기차
// 		                        		if ( cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440") ) {
		                        		if ( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) { 
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
		                        		} else {
		                        	%>
			                        	<%if( e_bean.getEcar_loc_st().equals("0") || e_bean.getEcar_loc_st().equals("1") || e_bean.getEcar_loc_st().equals("3")
			                        			|| e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5") || e_bean.getEcar_loc_st().equals("6") ){
			                        		// 전기차 고객주소지가 서울, 인천, 대전, 광주, 대구, 부산일 때 %>
		                        		※ [①법인: 사업장 소재지, ②개인: 주민등록등본상 주소지, ③개인사업자: 대표자 주민등록등본상 주소지]
			                        		<% if(e_bean.getEcar_loc_st().equals("0")){ %>
			                        			서울
			                        		<%} else if(e_bean.getEcar_loc_st().equals("1")){ %>
			                        			인천
			                        		<%} else if(e_bean.getEcar_loc_st().equals("3")){ %>
			                        			대전
			                        		<%} else if(e_bean.getEcar_loc_st().equals("4")){ %>
			                        			광주
			                        		<%} else if(e_bean.getEcar_loc_st().equals("5")){ %>
			                        			대구
			                        		<%} else if(e_bean.getEcar_loc_st().equals("6")){ %>
			                        			부산
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
		                        		
		                        		<%-- <%if (!(cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440"))) {%>
		                        			<%if( e_bean.getEcar_loc_st().equals("0") || e_bean.getEcar_loc_st().equals("1") || e_bean.getEcar_loc_st().equals("3")
				                        			|| e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5") || e_bean.getEcar_loc_st().equals("6") ){// 전기차 고객주소지가 서울, 인천, 대전, 광주, 대구, 부산 %>
		                        				<br>※ 지자체별 전기차 구매보조금 차이로 고객주소지에 따라 월대여로 상이함(고객주소지 보조금 이용)
		                        			<%} %>
		                        		<%} %> 해당 문구 미표기 요청으로 주석 처리. 2022.02.18. --%>
		                        		<%-- <%if (!cm_bean.getJg_code().equals("5866") && !cm_bean.getJg_code().equals("4854") && !cm_bean.getJg_code().equals("6316111") && !cm_bean.getJg_code().equals("4314111")) {%>
		                        			<%if (cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")) {%>
		                        				※ 3월말 인도예정
		                        			<%} else if (cm_bean.getJg_code().equals("5315111") || cm_bean.getJg_code().equals("5315112") || cm_bean.getJg_code().equals("5315113")) {%>
		                        				※ 5월중순경 인도예정
		                        			<%} else if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%>
		                        				※ [①법인: 사업장 소재지, ②개인: 주민등록등본상 주소지, ③개인사업자: 대표자 주민등록등본상 주소지]가 서울이여야 함
		                        				<!-- ※ 전기화물차 구매보조금 2300만원 기준 견적 -->
		                        				<!-- ※ 전기화물차 구매보조금 2700만원 기준 견적 -->
		                        			<%} else {%>
		                        				<!-- ※ 전기차 구매보조금 1200만원 기준 견적 -->
		                        				<%if ((AddUtil.parseInt(AddUtil.getDate(4)) >= 20181114 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20181114) && AddUtil.parseInt(e_bean.getRent_dt()) <= 20200121) {%>
		                        					※ 전기차 구매보조금 1200만원 기준 견적
		                        				<%} else {%>
			                						<!-- ※ 서울 구매보조금 기준 견적. 고정형 충전기 선택시 정부지원금을 초과하는 금액은 고객부담 -->
													<!-- ※ 고정형 충전기 선택시 정부지원금을 초과하는 금액은 고객부담 -->
													<%if(e_bean.getEcar_loc_st().equals("0")){ //서울 %>
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_0_amt() %>만원 기준 견적			                							
													<%}else if(e_bean.getEcar_loc_st().equals("1")){ //인천,경기 %>
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_1_amt() %>만원 기준 견적
													<%}else if(e_bean.getEcar_loc_st().equals("2")){ //강원 %>
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_2_amt() %>만원 기준 견적
													<%}else if(e_bean.getEcar_loc_st().equals("3")){ //대전 %>
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_3_amt() %>만원 기준 견적
													<%}else if(e_bean.getEcar_loc_st().equals("4")){ //광주,전남,전북 %>	
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_4_amt() %>만원 기준 견적
													<%}else if(e_bean.getEcar_loc_st().equals("5")){ //대구 %>
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_5_amt() %>만원 기준 견적
													<%}else if(e_bean.getEcar_loc_st().equals("6")){ //부산 %>
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_6_amt() %>만원 기준 견적
													<%}else if(e_bean.getEcar_loc_st().equals("7")){ //세종,충남,충북(대전제외) %>	
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_7_amt() %>만원 기준 견적
													<%}else if(e_bean.getEcar_loc_st().equals("8")){ //경북(대구제외) %>
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_8_amt() %>만원 기준 견적	
													<%}else if(e_bean.getEcar_loc_st().equals("9")){ //울산,경남 %>
														※ 전기차 구매보조금 <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_9_amt() %>만원 기준 견적
													<%}%>
													
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
		                        		<%}%> --%>
                						
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
	      <!-- 보험보상범위 -->
	          	<tr> 
	            	<td colspan="2">
                       	<div style="position: relative;">
							<img src=./images/bar_02_ins_comp_est_prt.gif align=left>
							<span style="position: absolute; top:4; right:4;">
								<%if (e_bean.getDoc_type().equals("1") || e_bean.getDoc_type().equals("2")) {%>
									<%if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000 && e_bean.getCom_emp_yn().equals("Y")) {%>
		                        	      ※ 운전자범위 : 임직원한정
		                        	<%} else if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000000 && e_bean.getCom_emp_yn().equals("Y")) {%>
		                        	      ※ 운전자범위 : 임직원한정      
		                        	<%} else {%>    
		                        	     ※ 운전자범위 : 임직원과 직계가족                        	  
		                        	<%}%>
		                        <%-- <%} else if (e_bean.getDoc_type().equals("2")) {%>
		                        	  ※ 운전자범위 : 임직원과 직계가족 --%>
		                        <%} else if (e_bean.getDoc_type().equals("3")) {%>
		                        	  ※ 운전자범위 : 계약자 및 직계가족
		                        <%}%>
							</span>
						</div>  		
	            	</td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
	          	<tr>
	          		<td colspan="2">
						<table width=698  class="table_est">
							<tr>
								<td height=17 align=center bgcolor=f2f2f2><span class=style3>대인배상</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>대물배상</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>자기신체사고</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>자차면책금</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>무보험차상해</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>운전자연령</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>긴급출동</span></td>
							</tr>
						<%	if(!e_bean.getIns_per().equals("2")){%>
							<tr>
								<td height=17 align=center><span class=style4>무한(대인Ⅰ,Ⅱ)</span></td>
								<td align=center><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5천만원<%}else if(e_bean.getIns_dj().equals("3")){%>5억원<%}else if(e_bean.getIns_dj().equals("4")){%>2억원<%}else if(e_bean.getIns_dj().equals("8")){%>3억원<%}else{%>1억원<%}%></span></td>
								<td align=center><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5천만원<%}else{%>1억원<%}%></span></td>
								<td align=center><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>원</span></td>
								<td align=center><span class=style4>1인당 최고 2억원 </span></td>
								<td align=center><span class=style4><%if(e_bean.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean.getIns_age().equals("3")){%>만24세이상<%}else{%>만26세이상<%}%></span></td>
								<td align=center><span class=style4>가입</span></td>
							</tr>
						<%	}else{%>
							<tr>
								<td height=17 align=center><span class=style4>보험미반영</span></td>
								<td align=center><span class=style4>보험미반영</span></td>
								<td align=center><span class=style4>보험미반영</span></td>
								<td align=center><span class=style4>보험미반영</span></td>
								<td align=center><span class=style4>보험미반영</span></td>
								<td align=center><span class=style4>보험미반영</span></td>
								<td align=center><span class=style4>보험미반영</span></td>
							</tr>
						<%	}%>
						</table>
					</td>
	       		</tr>
	       		
	       		<%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && e_bean.getA_a().equals("12")) {%>
                <tr>
                	<td colspan="3" align="right">※ 사고수리시 아마존카 지정 정비공장에서 수리</td>
                </tr>
                <%}%>

			<!-- 보험보상범위 end-->	
				<tr> 
	            	<td height=10 colspan="2"></td>
	          	</tr>
	          	<tr> 
	            	<td colspan="2"><img src=./images/bar_03_fee_prt.gif></td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
	        <!-- 월대여료 및 초기납입금 -->
	          	<tr>
	          		<td colspan="2">
	          			<table width=698 class="table_est">
							<tr>
								<td align=center bgcolor=f2f2f2 colspan=2>구분</td>
								<td align=center bgcolor=f2f2f2 width=135>견적1</td>
								<td align=center bgcolor=f2f2f2 width=135>견적2</td>
								<td align=center bgcolor=f2f2f2 width=135>견적3</td>
								<td align=center bgcolor=f2f2f2 width=135>견적4</td>
							</tr>
							<tr>
								<td align=center bgcolor=f2f2f2 colspan=2>인수/반납 유형</td>
								<td align=center bgcolor=f2f2f2 width=135><%if(!e_bean1.getEst_id().equals("")){if(e_bean1.getReturn_select().equals("0")){%>인수/반납 선택형<%}else if(e_bean1.getReturn_select().equals("1")){%>반납형<%}}else{%>인수/반납 선택형<%}%></td>
								<td align=center bgcolor=f2f2f2 width=135><%if(!e_bean2.getEst_id().equals("")){if(e_bean2.getReturn_select().equals("0")){%>인수/반납 선택형<%}else if(e_bean2.getReturn_select().equals("1")){%>반납형<%}}%></td>
								<td align=center bgcolor=f2f2f2 width=135><%if(!e_bean3.getEst_id().equals("")){if(e_bean3.getReturn_select().equals("0")){%>인수/반납 선택형<%}else if(e_bean3.getReturn_select().equals("1")){%>반납형<%}}%></td>
								<td align=center bgcolor=f2f2f2 width=135><%if(!e_bean4.getEst_id().equals("")){if(e_bean4.getReturn_select().equals("0")){%>인수/반납 선택형<%}else if(e_bean4.getReturn_select().equals("1")){%>반납형<%}}%></td>
							</tr>
	          				<tr>
	          					<td align=center bgcolor=f2f2f2 colspan=2><span class=style3>대여상품명</span></td>	   
	          					<td align=center height=17 bgcolor=ffffff><span class=style3><%if(!e_bean1.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean1.getA_a())%><%}else{%><%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%><%}%></span></td>
	          					<td align=center bgcolor=ffffff><span class=style3><%if(!e_bean2.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%><%}%></span></td>
	          					<td align=center bgcolor=ffffff><span class=style3><%if(!e_bean3.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean3.getA_a())%><%}%></span></td>
	          					<td align=center bgcolor=ffffff><span class=style3><%if(!e_bean4.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%><%}%></span></td>
	          				</tr>
	          				<tr bgcolor=f2f2f2>
	          					<td height=17 align=center colspan=2><span class=style3>대여기간</span></td>
	          					<td align=<%if(!e_bean1.getEst_id().equals("")){%>right<%}else{%>center<%}%>><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=e_bean1.getA_b()%> 개월<%}else{%>미운영<%}%></span>&nbsp;</td>  
	          					<td align=right><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=e_bean2.getA_b()%> 개월<%}%></span>&nbsp;</td>
	          					<td align=right><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=e_bean3.getA_b()%> 개월<%}%></span>&nbsp;</td>
	          					<td align=right><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=e_bean4.getA_b()%> 개월<%}%></span>&nbsp;</td>
	          				</tr>     
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2 width=20>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 width=138 style="border:0px; border-left:1px solid #dcdddd;"><span class=style3>공급가</span></td>
	          					<td align=right class="bd_bottom"><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%if (e_bean1.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getDriver_add_amt()*0.9)%> 원<%}%><%}%></span>&nbsp;</td>  
	          					<td align=right class="bd_bottom"><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%if (e_bean2.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getDriver_add_amt()*0.9)%> 원<%}%><%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom"><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%if (e_bean3.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getDriver_add_amt()*0.9)%> 원<%}%><%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom"><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%if (e_bean4.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getDriver_add_amt()*0.9)%> 원<%}%><%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td style="border:0px" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 style="border:0px; border-left:1px solid #dcdddd; border-top:1px solid #dcdddd;"><span class=style3>부가세</span></td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%if (e_bean1.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt()*0.1)%> 원<%}%><%}%></span>&nbsp;</td>  
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%if (e_bean2.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt()*0.1)%> 원<%}%><%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%if (e_bean3.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt()*0.1)%> 원<%}%><%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%if (e_bean4.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt()*0.1)%> 원<%}%><%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 bgcolor=f2f2f2 style="border:0px;padding-left:29px; border-top:1px solid #dcdddd;"><span class=style3>월대여료</span></td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean1.getEst_id().equals("")){%><%if (e_bean1.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt())%> 원<%}%><%}%></span>&nbsp;</td>  
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean2.getEst_id().equals("")){%><%if (e_bean2.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt())%> 원<%}%><%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean3.getEst_id().equals("")){%><%if (e_bean3.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt())%> 원<%}%><%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean4.getEst_id().equals("")){%><%if (e_bean4.getCls_per() > 100) {%>견적불가<%} else {%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt())%> 원<%}%><%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td style="border-bottom:0px;border-right:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 style="border-left:1px solid #dcdddd;border-bottom:0px;"><span class=style3>보증금</span></td>
	          					<td class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean1.getEst_id().equals("")){%><%=Math.round(e_bean1.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getGtr_amt())%> 원<%}%></span>&nbsp;</td>  
										</tr>
									</table>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean2.getEst_id().equals("")){%><%=Math.round(e_bean2.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getGtr_amt())%> 원<%}%></span>&nbsp;</td>
										</tr>
									</table>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean3.getEst_id().equals("")){%><%=Math.round(e_bean3.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getGtr_amt())%> 원<%}%></span>&nbsp;</td>
										</tr>
									</table>
								</td>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean4.getEst_id().equals("")){%><%=Math.round(e_bean4.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getGtr_amt())%> 원<%}%></span>&nbsp;</td>
										</tr>
									</table>
								</td>
	          				</tr> 
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 style="border:0px; border-left:1px solid #dcdddd; border-top:1px solid #dcdddd;"><span class=style3>선납금(VAT포함)</span></td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getPp_s_amt()+e_bean1.getPp_v_amt())%> 원<%}%></span>&nbsp;</td>  
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getPp_s_amt()+e_bean2.getPp_v_amt())%> 원<%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getPp_s_amt()+e_bean3.getPp_v_amt())%> 원<%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getPp_s_amt()+e_bean4.getPp_v_amt())%> 원<%}%></span>&nbsp;</td>
	          				</tr>
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 style="border:0px; border-left:1px solid #dcdddd; border-top:1px solid #dcdddd;"><span class=style3>개시대여료(VAT포함)</span></td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getIfee_s_amt()+e_bean1.getIfee_v_amt())%> 원<%}%></span>&nbsp;</td>  
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getIfee_s_amt()+e_bean2.getIfee_v_amt())%> 원<%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getIfee_s_amt()+e_bean3.getIfee_v_amt())%> 원<%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getIfee_s_amt()+e_bean4.getIfee_v_amt())%> 원<%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 bgcolor=f2f2f2 style="border:0px; padding-left:10px; border-top:1px solid #dcdddd;"><span class=style3>초기납입금 합계</span></td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getGtr_amt()+e_bean1.getPp_s_amt()+e_bean1.getPp_v_amt()+e_bean1.getIfee_s_amt()+e_bean1.getIfee_v_amt())%> 원<%}%></span>&nbsp;</td>  
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getGtr_amt()+e_bean2.getPp_s_amt()+e_bean2.getPp_v_amt()+e_bean2.getIfee_s_amt()+e_bean2.getIfee_v_amt())%> 원<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getGtr_amt()+e_bean3.getPp_s_amt()+e_bean3.getPp_v_amt()+e_bean3.getIfee_s_amt()+e_bean3.getIfee_v_amt())%> 원<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getGtr_amt()+e_bean4.getPp_s_amt()+e_bean4.getPp_v_amt()+e_bean4.getIfee_s_amt()+e_bean4.getIfee_v_amt())%> 원<%}%></span>&nbsp;</td>
	          				</tr> 
						</table>
						<%if(e_bean1.getGi_amt()+e_bean2.getGi_amt()+e_bean3.getGi_amt()+e_bean4.getGi_amt() > 0){%>
						<table width=698 class="table_est">
							<tr>	
								<td align=center bgcolor=f2f2f2 width=158>보증보험 가입금액</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean1.getEst_id().equals("")){%><%=e_bean1.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getGi_amt())%> 원&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean2.getEst_id().equals("")){%><%=e_bean2.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getGi_amt())%> 원&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean3.getEst_id().equals("")){%><%=e_bean3.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getGi_amt())%> 원&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean4.getEst_id().equals("")){%><%=e_bean4.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getGi_amt())%> 원&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td align=center bgcolor=f2f2f2>
									보증보험료
									<%-- <br>
									<span style="font-size: 11px;">※ 신용등급 <%=e_bean1.getGi_grade()%>등급기준</span> --%>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=55><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=e_bean1.getA_b()%>개월치<%}%></span></td>
											<td align=right style="border:0px;" width=80>
												<span class=style4>
													<%if(!e_bean1.getEst_id().equals("")){%>
														<%if (e_bean1.getGi_amt() > 0) {%>
								                          	<%if (!e_bean1.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean1.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;원&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean1.getGi_fee())%>&nbsp;원&nbsp;
							                          	<%}%>
						                          	<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=55><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=e_bean2.getA_b()%>개월치<%}%></span></td>
											<td align=right style="border:0px;" width=80>
												<span class=style4>
													<%if(!e_bean2.getEst_id().equals("")){%>
														<%if (e_bean2.getGi_amt() > 0) {%>
								                          	<%if (!e_bean2.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean2.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;원&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean2.getGi_fee())%>&nbsp;원&nbsp;
							                          	<%}%>
						                          	<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=55><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=e_bean3.getA_b()%>개월치<%}%></span></td>
											<td align=right style="border:0px;" width=80>
												<span class=style4>
													<%if(!e_bean3.getEst_id().equals("")){%>
														<%if (e_bean3.getGi_amt() > 0) {%>
								                          	<%if (!e_bean3.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean3.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;원&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean3.getGi_fee())%>&nbsp;원&nbsp;
							                          	<%}%>
						                          	<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=55><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=e_bean4.getA_b()%>개월치<%}%></span></td>
											<td align=right style="border:0px;" width=80>
												<span class=style4>
													<%if(!e_bean4.getEst_id().equals("")){%>
														<%if (e_bean4.getGi_amt() > 0) {%>
								                          	<%if (!e_bean4.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean4.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;원&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean4.getGi_fee())%>&nbsp;원&nbsp;
							                          	<%}%>
						                          	<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%}%>
						
						<table width=698 class="table_est">
							<tr>
								<td align=center bgcolor=f2f2f2 width=158>매입옵션가격(VAT포함)</td>
								<td class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><span class=style4><%if(!e_bean1.getEst_id().equals("") && e_bean1.getOpt_chk().equals("1")){%><%=e_bean1.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%if(e_bean1.getOpt_chk().equals("1")){%><%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%> 원<%}else{%>매입옵션 없음<%}%><%}%></span>&nbsp;</td>  
										</tr>
									</table>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><span class=style4><%if(!e_bean2.getEst_id().equals("") && e_bean2.getOpt_chk().equals("1")){%><%=e_bean2.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%if(e_bean2.getOpt_chk().equals("1")){%><%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%> 원<%}else{%>매입옵션 없음<%}%><%}%></span>&nbsp;</td>  
										</tr>
									</table>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><span class=style4><%if(!e_bean3.getEst_id().equals("") && e_bean3.getOpt_chk().equals("1")){%><%=e_bean3.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%if(e_bean3.getOpt_chk().equals("1")){%><%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%> 원<%}else{%>매입옵션 없음<%}%><%}%></span>&nbsp;</td>  
										</tr>
									</table>
								</td>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><span class=style4><%if(!e_bean4.getEst_id().equals("") && e_bean4.getOpt_chk().equals("1")){%><%=e_bean4.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%if(e_bean4.getOpt_chk().equals("1")){%><%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%> 원<%}else{%>매입옵션 없음<%}%><%}%></span>&nbsp;</td>  
										</tr>
									</table>
								</td>
						<table>
						
						
						<table width=698 class="table_est">
							<tr>
		            			<td bgcolor=f2f2f2 height=17 align=center width=148><span class=style3>연간 약정운행거리</span></td>
		            			<td bgcolor=ffffff align=right width=140><%if(!e_bean1.getEst_id().equals("")){%><span class=style7><%=AddUtil.parseDecimal(e_bean1.getAgree_dist())%>km</span> 이하&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right width=140><%if(!e_bean2.getEst_id().equals("")){%><span class=style7><%=AddUtil.parseDecimal(e_bean2.getAgree_dist())%>km</span> 이하&nbsp;<%}%></td>
						        <td bgcolor=ffffff align=right width=140><%if(!e_bean3.getEst_id().equals("")){%><span class=style7><%=AddUtil.parseDecimal(e_bean3.getAgree_dist())%>km</span> 이하&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right width=140><%if(!e_bean4.getEst_id().equals("")){%><span class=style7><%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>km</span> 이하&nbsp;<%}%></td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=f2f2f2 height=17 align=center><span class=style3>초과운행대여료(VAT별도)</span></td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean1.getEst_id().equals("")){%>초과 1km당 &nbsp;<b>(<%=e_bean1.getOver_run_amt()%>)원</b>&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean2.getEst_id().equals("")){%>초과 1km당 &nbsp;<b>(<%=e_bean2.getOver_run_amt()%>)원</b>&nbsp;<%}%></td>
						        <td bgcolor=ffffff align=right><%if(!e_bean3.getEst_id().equals("")){%>초과 1km당 &nbsp;<b>(<%=e_bean3.getOver_run_amt()%>)원</b>&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean4.getEst_id().equals("")){%>초과 1km당 &nbsp;<b>(<%=e_bean4.getOver_run_amt()%>)원</b>&nbsp;<%}%></td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=f2f2f2 height=17 align=center><span class=style3>매입옵션 행사시<br>초과운행대여료</span></td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean1.getEst_id().equals("")){%><%if(e_bean1.getOpt_chk().equals("1")){%><%if(e_bean1.getA_a().equals("12")||e_bean1.getA_a().equals("22")){%>면제<%}else{%>50%만 납부<%}%><%}else{%>매입옵션 없음<%}%><%}%>&nbsp;</td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean2.getEst_id().equals("")){%><%if(e_bean2.getOpt_chk().equals("1")){%><%if(e_bean2.getA_a().equals("12")||e_bean2.getA_a().equals("22")){%>면제<%}else{%>50%만 납부<%}%><%}else{%>매입옵션 없음<%}%><%}%>&nbsp;</td>
						        <td bgcolor=ffffff align=right><%if(!e_bean3.getEst_id().equals("")){%><%if(e_bean3.getOpt_chk().equals("1")){%><%if(e_bean3.getA_a().equals("12")||e_bean3.getA_a().equals("22")){%>면제<%}else{%>50%만 납부<%}%><%}else{%>매입옵션 없음<%}%><%}%>&nbsp;</td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean4.getEst_id().equals("")){%><%if(e_bean4.getOpt_chk().equals("1")){%><%if(e_bean4.getA_a().equals("12")||e_bean4.getA_a().equals("22")){%>면제<%}else{%>50%만 납부<%}%><%}else{%>매입옵션 없음<%}%><%}%>&nbsp;</td>
		            		</tr>
						</table>
						<table width=698 class="table_est">
	          				<tr>
	          					<td height=17 align=center bgcolor=f2f2f2 width=148><span class=style3>중도해지 위약금</span></td>
	          					<td width=140 align=right><span class=style9><%if(!e_bean1.getEst_id().equals("")){%>잔여기간 대여료의</span> <span class=style7><%if(e_bean1.getCls_per()>0){%><%=e_bean1.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean1.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>  
	          					<td width=140 align=right><span class=style9><%if(!e_bean2.getEst_id().equals("")){%>잔여기간 대여료의</span> <span class=style7><%if(e_bean2.getCls_per()>0){%><%=e_bean2.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean2.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>
	          					<td width=140 align=right><span class=style9><%if(!e_bean3.getEst_id().equals("")){%>잔여기간 대여료의</span> <span class=style7><%if(e_bean3.getCls_per()>0){%><%=e_bean3.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean3.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>
	          					<td width=140 align=right><span class=style9><%if(!e_bean4.getEst_id().equals("")){%>잔여기간 대여료의</span> <span class=style7><%if(e_bean4.getCls_per()>0){%><%=e_bean4.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean4.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>
	          				</tr>  
	          			</table>
	          		</td>
	          	</tr> 
	          	<tr>
	          		<td colspan="2" height="5"></td>
	          	</tr>
	          	<tr>
	          	<!-- 썬팅/블랙박스 표기 -->    
                <td class=listnum2 valign=top>
                <%if(ref_reg_dt >= 2021090600){ %>
	          	<%if( !(e_bean.getCar_comp_id().equals("0056") || e_bean.getCar_comp_id().equals("0057")
	          			|| (Integer.parseInt(cm_bean.getJg_code()) > 9017300 && Integer.parseInt(cm_bean.getJg_code()) < 9018200 )) ) { // 테슬라, 폴스타, 마이티/메가트럭 제외%>
						<!-- 썬팅 -->
						&nbsp;<span class=style3><%if(e_bean.getTint_sn_yn().equals("Y")){%>* 측후면 썬팅 포함<%} else{ %>* 전면/측후면 썬팅 포함<%} %></span>
						<!-- 블랙박스 -->
						&nbsp;
						<span class=style3>
							<%if(e_bean.getTint_bn_yn().equals("Y")){%> * 블랙박스 미제공 할인
		                	<%} else{ %>
		                		<%if( Integer.parseInt(cm_bean.getJg_code()) > 9000000 ){%>
		                		* 블랙박스 포함
		                		<%} else{ %>
		                		* 2채널 블랙박스 포함
				                <%}%>
				            <%} %>
						</span>
                <%} %>
                <%} %>
                </td>
                <!-- 번호판 -->
				<td class=listnum2 valign=top align="right">
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
        		<!--용품-->
        		<%if(e_bean.getTint_s_yn().equals("Y") || e_bean.getTint_n_yn().equals("Y") || e_bean.getTint_eb_yn().equals("Y")){%>      
                        <tr> 
			    <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style3>※
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
	          	
	          	<tr> 
                    <td colspan="2" style="padding-left:20px;"><span class=style4>※ ① 보증금은 계약기간 만료 후 환불해 드립니다.<br>
                    <!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [보증금 100만원을 증액하면, 월대여료 5,500원(VAT포함)이 인하됩니다. (년리 6.6% 효과)]<br> -->
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [보증금 100만원을 증액하면, 월대여료 4,620원(VAT포함)이 인하됩니다. (년리 5.5% 효과)]<br>
                    &nbsp;&nbsp;&nbsp;&nbsp; ② 선납금은 매월 일정 금액씩 공제되어 소멸되는 돈입니다.<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ※ 세금계산서는 계약이용기간 동안 매월 균등 발행 또는 납부시 일시 발행 중 선택가능<br><!-- 2018.01.23 추가 -->
                    &nbsp;&nbsp;&nbsp;&nbsp; ③ 개시대여료는 마지막 (<%=e_bean.getG_10()%>)개월치 대여료를 선납하는 것입니다.
				    <%-- <%if(AddUtil.parseInt(cm_bean.getJg_code()) < 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000)){%>
                    <br>
                    &nbsp;&nbsp;&nbsp;&nbsp; ④ 대여료(월대여료,선납금)과 업무용으로 손비처리 가능할 경우 부가세는 매입세액공제(환급)받으실 수 있습니다.
                    <%}%> --%>
<%--                     <%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%> --%>
                    <%if(AddUtil.parseInt(cm_bean.getS_st()) <= 101 || AddUtil.parseInt(cm_bean.getS_st()) == 409 || AddUtil.parseInt(cm_bean.getS_st()) >= 601 ){%>
                    <br>
                    &nbsp;&nbsp;&nbsp;&nbsp; ④ 대여료(월대여료,선납금)과 업무용으로 손비처리 가능할 경우 부가세는 매입세액공제(환급)받으실 수 있습니다.
                    <%}%>
                    

					<br>
					※ 약정운행거리를 줄이면 대여요금이 인하되고, 약정운행거리를 늘리면 대여요금이 인상됩니다.
					<%if(e_bean1.getGi_amt()+e_bean2.getGi_amt()+e_bean3.getGi_amt()+e_bean4.getGi_amt() > 0){%>
					<br>
					※ 신용등급별로 보증보험료가 달라집니다.
					<%}%>
                    </span></td>
                </tr>
	         <!-- 월대여료 및 초기납입금 end -->  
			    <%if(e_bean.getPp_ment_yn().equals("Y")){%>          
			        <tr> 
					    <td colspan=2>&nbsp;<span class=style3>* 초기납입금은 고객님의 신용도에 따라 심사과정에서 조정될 수 있습니다.</span></td>
			        </tr>
		      <%}%>	      
		      <%if(e_bean.getTint_ps_yn().equals("Y")){%> 
	                <tr><td colspan=3 class=listnum2 valign=top>
					<%if(e_bean.getTint_ps_st().equals("Y")){%>        
						&nbsp;<span class=style3>* 썬팅구분: 고급썬팅</span>
                	<%}else if(e_bean.getTint_ps_st().equals("N")){%>
                	<%}else if(e_bean.getTint_ps_st().equals("I")){ %>
                		&nbsp;<span class=style3>* <%=e_bean.getTint_ps_nm()%></span>
                	<%} %>
	                </td></tr>
                <%}%>   
	      <!-- 차량관리 서비스-->
	          	
				
		   		<tr> 
		            <td height=10 colspan="2"></td>
		   		</tr>
		      	<tr> 
		            <td colspan="2"><%if(ej_bean.getJg_k().equals("2")){%><img src=./images/bar_04_service_dc_prt.gif><%} else if(ej_bean.getJg_k().equals("0")){%><img src=./images/bar_04_service_ndc_prt.gif><%} else if(ej_bean.getJg_k().equals("3")){%><img src=./images/bar_04_3.gif><%}else{%><img src=./images/bar_04_service_prt.gif><%}%></td>
		    	</tr>
		  		<tr> 
		            <td height=4 colspan="2"></td>
		     	</tr>
		    	<tr> 
		          <td colspan="2" valign=top> 
		          		<table width=698 class="table_est">
		                  	<tr> 
		                     	<td width=115 height=17 align=center bgcolor=f2f2f2><span class=style3>공통서비스</span></td>
		                    	<td width=583 colspan=2>&nbsp; <%if(!e_bean.getInsurant().equals("2")){%>* 교통사고 발생시 <span class=style6>사고처리 업무 대행</span><%}%> &nbsp;&nbsp;&nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;*<span class=style6> 사고대차서비스</span>(피해사고시는 보험대차)<%}%> </td>
		                    </tr>
		                </table>
		          </td>
		         </tr>
		         <tr></tr>
		         <tr>
		         	<td colspan="2">
		                <table width=698 class="table_est">
		                    <tr>
		                       	<td colspan=2 align=center bgcolor=#f2f2f2 height=17><span class=style6>기본식</span> (정비서비스 미포함 상품)</span></td>
		                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<span class=style6>일반식</span> (정비서비스 포함 상품)</span></td>
		                  	</tr>
		                  	<tr>
		                  		<td width=349 colspan=2 height=95 style="padding:10px 15px;">&nbsp; <span class=style6>* 아마존케어 서비스</span><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - 차량 정비 관련 유선 상담서비스 상시 제공<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - 대여 개시 2개월 이내 무상 정비대차 제공<%if(e_bean.getCar_comp_id().equals("0056")) {%>(테슬라차량 제외)<%}%><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24시간 이상 정비공장 입고시)<br> 
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - 대여 개시 2개월 이후 원가 수준의 유상 정비대차 제공<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (단기 대여요금의 15~30% 수준, 탁송료 별도)</td>
		                   		<td width=349 align=left style="padding-left:15px;">&nbsp; <span class=style6>* 일체의 정비서비스</span><br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 각종 내구성부품/소모품 점검, 교환, 수리<br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 제조사 차량 취급설명서 기준<br>
		                   		&nbsp; <span class=style6>* 정비대차서비스</span><br> 
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 4시간 이상 정비공장 입고시</td>
		                 	</tr>
		         		</table>
		         	</td>
		        </tr>
		     	<tr> 
		            <td height=10 colspan="2"></td>
		     	</tr>
		     <!-- 기타 대여조건-->
		    	<tr> 
		            <td colspan="2"><img src=./images/bar_05_etc_prt.gif></td>
		    	</tr>
		  		<tr> 
		            <td height=4 colspan="2"></td>
		   		</tr>
	          	<tr> 
		            <td colspan="2" align=center> 
		            	<table width=671 border=0 cellspacing=0 cellpadding=0>
		            		<tr> 
			                  	<td width=28 height=17 align=right style='vertical-align: baseline'><img src=./images/1.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=593 colspan=2 align=left class=listnum2>
			                  	제조사의 차량 상품성 개선, 연식 변경 또는 정부 정책(안전사양 의무장착, 배기가스저감, 세율조정 등) 변경 등으로<br>차량가격이 변동 될 경우 상기 견적금액은 변동 될 수 있습니다.
			                  	</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td width=28 height=17 align=right><img src=./images/2.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=635 colspan=2 align=left class=listnum2>등록, 자동차세 납부<%if (!e_bean.getCar_comp_id().equals("0056")) {%>, 정기검사<%}%> 
			                    등도 아마존카에서 처리(고객 비용 부담 없음)</td>
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
			                  		대여기간 만료시에는 인수/반납 선택형의 경우 차량반납, 연장이용<%if(!e_bean.getCar_comp_id().equals("0056") && (!cm_bean.getJg_code().equals("9133") && !cm_bean.getJg_code().equals("9237") && !cm_bean.getJg_code().equals("9015435") && !cm_bean.getJg_code().equals("9025435") && !cm_bean.getJg_code().equals("9015436") && !cm_bean.getJg_code().equals("9015437") && !cm_bean.getJg_code().equals("9025439") && !cm_bean.getJg_code().equals("9025440"))) {%>(할인요금 적용)<%}%>, 매입옵션 행사 중 선택 가능하고,
			                  	</td> --%>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>
			                  		반납형의 경우 차량반납, 연장이용(할인요금 적용) 중 선택 가능.
			                  	</td>
			                </tr>
			  			</table>
		           	</td>
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
	<!--필요서류표기 start-->
    <!-- 법인-->
	<%if(e_bean.getDoc_type().equals("1")){%>
    <tr>
        <td colspan=3 align=center>
            <table width=698 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img_prt.gif>
                <tr>
                    <td colspan=2 align=left background=../main_car_hp/images/p_up_img_prt.gif height=24>
                        <table width=698 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약준비서류 (법인)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width=15>&nbsp;</td>
                    <td width=683  align=left>
                        <table width=668 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td valign=top>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>제출서류 :</span></td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>	
                                <td>
                                    <table width=658 border=0 cellspacing=0 cellpadding=0r>
                                        <tr>
                                            <td width=125 style="font-size:11px;" valign=top>&nbsp; <span class=style4>1.대표이사 자필 서명시:</span></td>
                                            <td style="font-size:11px; letter-spacing:-0.05em;">
                                            	<span class=style4>
                                            	① 사업자등록증 사본  &nbsp;② 통장 사본(자동이체용) &nbsp;③ 대표이사 신분증 사본 &nbsp;④ 주운전자  면허증  사본<br>
                                            	※ 본인확인시 신분증 실물 대조 필수, 명판 및 법인명의 도장 필요
                                            	</span>
                                            </td>
                                        </tr>
                                     </table>
                                 </td>
                             </tr>
                             <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                             <tr>
                             			<td>
                                       <table width=658 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=150 style="font-size:11px;" valign=top>&nbsp; <span class=style4>2.대표이사 자필 서명 불가시:</span></td>
                                            <td style="font-size:11px; letter-spacing:-0.05em;">
                                            	<span class=style4>
                                            	① 사업자등록증 사본 &nbsp;② 통장 사본(자동이체용) &nbsp;③ 법인인감증명서 1통&nbsp; ④ 대표이사 신분증 사본<br>⑤ 대표이사 인감증명서 1통 &nbsp;⑥ 주운전자 면허증 사본 &nbsp;(인감증명서는 최근 3개월이내 발급분)
                                            	</span>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td colspan=2>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>신용심사 참고서류 : </span>  &nbsp;&nbsp;&nbsp;<span class=style4>재무제표(대차대조표, 손익계산서 등) &nbsp;&nbsp;※ 필요시 연대보증인(대표이사)의 주민등록등본</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=2><img src=../main_car_hp/images/p_dw_img_prt.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>			
	<%}else if(e_bean.getDoc_type().equals("2")){%>
    <!-- 개인사업자-->
    <tr>
        <td colspan=3 align=center>
            <table width=698 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img_prt.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img_prt.gif height=24>
                        <table width=698 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약준비서류 (개인사업자)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50 width=15>&nbsp;</td>
                    <td width=668 align=left>
                        <table width=668 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=8></td>
                            </tr>
                            <tr>
                                <td width=65 valign=top>&nbsp;<img src=/acar/main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>제출서류 :</span></td>
                                <td width=580>
                                    <table width=580 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td style="font-size:11px;">
	                                            <span class=style4>
					                                            ① 사업자등록증 사본  &nbsp;&nbsp;② 운전면허증 사본 &nbsp;&nbsp;③ 통장 사본(자동이체용) &nbsp;&nbsp;④ 주운전자가 직원일 경우 주운전자 면허증 사본<br> 
					                                            ※ 본인확인시 신분증 실물 대조 필수 &nbsp;&nbsp; 
	                                            </span>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td colspan=2 style="font-size:11px;">
	                                &nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> 
	                                <span class=style12>신용심사 참고서류 :&nbsp;&nbsp; </span> 
	                                <span class=style4 style="font-size:11px;">매출증빙자료(부가가치세과세표준증명서 등) &nbsp;&nbsp;
	                                <br><span style='margin-left: 100px;'>※ 신용 심사에 필요할 경우 주민등록등본 제출을 요청할 수 있습니다.</span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 style="font-size:10.8px; padding-top: 5px;">
                                            ※계약자(사업주)의 위임을 받은 직원이 계약을 대리해야 할 경우에는 계약자(사업주)의 개인인감도장을 날인하고, 계약자(사업주)의 개인인감증명서(최근 3개월이내 발급된 것)를 첨부하여 계약을 체결할 수 있습니다. (아마존카 사전승인 및 대리인 신분증 필요)
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width=15>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan=3><img src=../main_car_hp/images/p_dw_img_prt.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>		
    <!-- 개인-->
    <%}else if(e_bean.getDoc_type().equals("3")){%>
    <tr>
        <td colspan=3 align=center>
            <table width=698 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img_prt.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img_prt.gif height=24>
                        <table width=698 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약준비서류 (개인)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50 width=15>&nbsp;</td>
                    <td width=658 align=left>
                        <table width=658 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=8></td>
                            </tr>
                            <tr>
                                <td width=88>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>제출서류 :</span></td>
                                <td width=570>
                                    <table width=570 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td style="font-size:11px;"><span class=style4>① 운전면허증 사본  &nbsp;&nbsp;② 통장 사본(자동이체용)</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>신용심사 참고서류 :</span> &nbsp;&nbsp;&nbsp;<span class=style4>재직증명서, 소득증빙자료(원천징수영수증 등)<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;※ 신용 심사에 필요할 경우 주민등록등본 제출을 요청할 수 있습니다.</span></td>
                            </tr> 
                        </table>
                    </td>
                    <td width=15>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan=3><img src=../main_car_hp/images/p_dw_img_prt.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>	
	<%}%>
	<!--필요서류표기 end-->		
    <tr>
        <td align=center colspan=3>
		  <a href=javascript:go_print('<%= est_id %>');><img src=./images/button_print.gif border=0></a>&nbsp;&nbsp;
		  <a href=javascript:go_mail('<%= est_id %>');><img src="./images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;		  
		</td>
    </tr>
    <tr>
        <td height=15></td>
    </tr>
	<tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
</table>

<SCRIPT LANGUAGE="JavaScript">
var EchoID = "amazonecar9";
var EchoGoodNm = "";
var EchoAmount = "";
var EchoUIP = "";
var EchoTarget = "";
var EchoLogSend = "";
var EchoCV = "";
var EchoPN = "";

var EchoLogServer = "adlog.cresendo.net";
var EchoCookieDays = 45;
var Echotoday = new Date();
function FN_ZoneMark(_Ea) { if (_Ea < 10) { return "0" + _Ea; } else { return _Ea; } }
var EchoToDay = Echotoday.getYear() + "" + FN_ZoneMark(Echotoday.getMonth()) + "" + FN_ZoneMark(Echotoday.getDate());
var EchoToDayHours = Echotoday.getHours();
function FN_GetDomain(_Eb) { var _s = _Eb.split("."); if (_s.length == 3) { if (_s[1].length == 2) { return _Eb; } else { return _s[1] + "." + _s[2]; } } else if (_s.length > 3) { if (_s[_s.length-2].length == 2) { return _s[_s.length-3] + "." + _s[_s.length-2] + "." + _s[_s.length-1]; } else { return _s[_s.length-2] + "." + _s[_s.length-1]; } } else { return _Eb; } }
function FN_SetCookie(_Ec,_Ed,_Ee,_Ef,_Eg) { var _dt = new Date(); _ut = _dt.getTime(); _Ee = (!_Ee) ? "/" : _Ee; if( _Ed == null ) { _Eg = 0; } if( _Eg != null ) { _et = _ut + (_Eg * 1000); _dt.setTime(_et); _pt = " expires=" + _dt.toUTCString() + ";"; 	} else { _pt = ""; } if( _Ef != null ) { _pt += " domain=" + _Ef + ";"; } document.cookie = _Ec + "=" + escape(_Ed) + "; path=" + _Ee + ";" + _pt; }
function FN_GetCookie(_Ec) { var _nc = _Ec + "="; var _x = 0; while( _x <= document.cookie.length ) { var _y = _x + _nc.length; if (document.cookie.substring(_x,_y) == _nc) { if ((_ec = document.cookie.indexOf(";",_y)) == -1) { _ec = document.cookie.length; } return unescape(document.cookie.substring(_y,_ec)); } _x = document.cookie.indexOf(" ", _x) + 1; if (_x == 0) { break; } } return ""; }
function FN_StrPos(_Eh,_Ei) { for (var _i=0; _i < _Eh.length; _i++) { if (_Eh.substring(_i, _i+1) == _Ei) { return _i; } } return -1; }
function FN_FullDomain(_Ej) { if (FN_StrPos(_Ej, ":") > 0) { _Ej = _Ej.substring(0, FN_StrPos(_Ej, ":")); } if (FN_StrPos(_Ej, "/") > 0) { _Ej = _Ej.substring(0, FN_StrPos(_Ej, "/")); } _Ej = FN_GetDomain(_Ej); return _Ej; }
function FN_PageUrl(_Ek) { _Ek = _Ek.replace("http://", ""); _Ek = _Ek.replace("https://", ""); if (_Ek.indexOf("/") > 0 ) { _Ek = _Ek.replace(_Ek.substring(0, FN_StrPos(_Ek, "/")), ""); _Ek = _Ek.substring(0, FN_StrPos(_Ek, "?")); return _Ek; } else { return "/"; } }
function FN_getNavigatorInfoStr() { var name = navigator.appName, ver = navigator.appVersion, ver_int = parseInt(navigator.appVersion), ua = navigator.userAgent, infostr; if(name == "Microsoft Internet Explorer") { if(ver.indexOf("MSIE 3.0") != -1) { return "Internet Explorer 3.0x"; } if(ver_int != 4) { return "Internet Explorer " + ver.substring(0, ver.indexOf(" ")); } var real_ver = parseInt(ua.substring(ua.indexOf("MSIE ") + 5)); if(real_ver >= 7) { infostr = "Windows Internet Explorer "; } else {infostr = "Microsoft Internet Explorer "; } if(ua.indexOf("MSIE 5.5") != -1) { return infostr + "5.5"; } else { return infostr + real_ver + ".x"; } return "Internet Explorer"; } else if(name == "Netscape") { if(parseInt(ua.substring(8, 8)) <= 4) { return "Netscape " + ver.substring(0, ver.indexOf(" ")); } else if(ua.lastIndexOf(" ") < ua.lastIndexOf("/")) { return ua.substring(ua.lastIndexOf(" ")); } else { return "Netscape"; } } else { return name; } }
function FN_getOSInfoStr() { var ua = navigator.userAgent; if(ua.indexOf("NT 6.0") != -1) { return "Windows Vista/Server 2008"; }  else if(ua.indexOf("NT 5.2") != -1) { return "Windows Server 2003"; } else if(ua.indexOf("NT 5.1") != -1) { return "Windows XP"; } else if(ua.indexOf("NT 5.0") != -1) { return "Windows 2000"; } else if(ua.indexOf("NT") != -1) { return "Windows NT"; } else if(ua.indexOf("9x 4.90") != -1) { return "Windows Me"; } else if(ua.indexOf("98") != -1) { return "Windows 98"; } else if(ua.indexOf("95") != -1) { return "Windows 95"; } else if(ua.indexOf("Win16") != -1) { return "Windows 3.x"; } else if(ua.indexOf("Windows") != -1) { return "Windows"; } else if(ua.indexOf("Linux") != -1) { return "Linux"; } else if(ua.indexOf("Macintosh") != -1) { return "Macintosh"; } else { return ""; } }
function FN_IPClose() { document.write("<body oncontextmenu='return false' onselectstart='return false' style='overflow:hidden;'><div id='DIVIPCLOSE' style='position:absolute; left:0; top:0; height:1200px; z-index: 90; background-color: #FFFFFF; filter:alpha(opacity=70);display:none;'><table id='tb1' border='0' height='500' cellpadding='0' cellspacing='0' align='center'><tr><td><table width='400' height='300' border='0' cellpadding='0' cellspacing='0' background='http://www.cresendo.net/img/ipClose/pop_back.jpg'><tr><td><table width='300' border='0' align='center' cellpadding='0' cellspacing='0'><tr valign='top'><td height='200' colspan='2'><div align='center' style='font-family:돋움;font-size:9pt;'><p><strong>죄송합니다 !</strong><br><br>지금 접속은 검색을 통한 접근이 차단된 경로 입니다.<br><br>많은 중복 검색과 접속으로 인해 불가피하게 <br>접근을 차단합니다.<br>아래 &quot;<strong>즐겨찾기 추가하기</strong>&quot; 를 눌러 <br>직접 접속하시기를 권장합니다.</p></div></td></tr><tr><td><div align='center'><a href='javascript:FN_bookmarksite()'><img src='http://www.cresendo.net/img/ipClose/pop_bt1.gif' width='138' height='29' border='0'></a></div></td><td><div align='center'><a href='javascript:window.close()'><img src='http://www.cresendo.net/img/ipClose/pop_bt2.gif' border='0' width='70' height='29'></div></td></tr></table></td></tr></table></td></tr></table></div></body>"); var arrayPageSize = this.getPageSize(); document.getElementById('tb1').style.width = arrayPageSize[0] + 'px'; document.getElementById('DIVIPCLOSE').style.height = arrayPageSize[1] + 'px'; FN_DivSH(document.getElementById("DIVIPCLOSE"), "true"); document.getElementById("DIVIPCLOSE").focus(); }
function FN_DivSH(DivName, SHType) { if (SHType == "auto") { if (DivName.style.display == "none") { DivName.style.display = "block"; } else { DivName.style.display = "none"; } } else if (SHType == "true") { DivName.style.display = "block"; } else if (SHType == "false") { DivName.style.display = "none"; } }
function getPageSize() { var xScroll, yScroll; if (window.innerHeight && window.scrollMaxY) { xScroll = window.innerWidth + window.scrollMaxX; yScroll = window.innerHeight + window.scrollMaxY; } else if (document.body.scrollHeight > document.body.offsetHeight){ xScroll = document.body.scrollWidth; yScroll = document.body.scrollHeight; } else { xScroll = document.body.offsetWidth; yScroll = document.body.offsetHeight; } var windowWidth, windowHeight; if (self.innerHeight) { if(document.documentElement.clientWidth){ windowWidth = document.documentElement.clientWidth; } else { windowWidth = self.innerWidth; } windowHeight = self.innerHeight; } else if (document.documentElement && document.documentElement.clientHeight) { windowWidth = document.documentElement.clientWidth; windowHeight = document.documentElement.clientHeight; } else if (document.body) { windowWidth = document.body.clientWidth; windowHeight = document.body.clientHeight; } if(yScroll < windowHeight){ pageHeight = windowHeight; } else { pageHeight = yScroll; } if(xScroll < windowWidth){ pageWidth = xScroll; } else { pageWidth = windowWidth; } return [pageWidth,pageHeight]; }
function FN_bookmarksite() { var title=window.location.title; var url=window.location.href; if (window.sidebar) { window.sidebar.addPanel(title, url, ""); }else if(window.opera && window.print) { var elem = document.createElement('a');  elem.setAttribute('href',url); elem.setAttribute('title',title); elem.setAttribute('rel','sidebar'); elem.click(); } else if(document.all) { window.external.AddFavorite(parent.location.href, parent.location.title); } }

var _EchoPR = location.protocol.indexOf("https");
var _EchoHostName = location.hostname;
var _EchoPathName = location.pathname;
var _EchoSearch = location.search;
var _EchoHash = location.hash
var _EchoUL = document.URL;
var _EchoRF = document.referrer;
var _EchoDoMain = FN_FullDomain(_EchoHostName);

var _EchoAK = FN_GetCookie("ECHO_AKEY");
var _EchoCK = FN_GetCookie("ECHO_CKEY");
var _EchoSK = FN_GetCookie("ECHO_KEY");
var _EchoSS = FN_GetCookie("ECHO_SESSION");
var _EchoOv = FN_GetCookie("ECHO_OVKEY");
var _EchoK = "";
var _EchoDate = FN_GetCookie("ECHO_DATE");
var _EchoInKey = "";
var _EchoCV = "";
var _EchoPN = "";
var _EchoLogSend = "";

if (_EchoUL.indexOf("#") > 0) { _EchoUL = _EchoUL.substring(0, _EchoUL.indexOf("#")); }
if (_EchoUL.charAt(_EchoUL.length-1) == "/" ) { _EchoUL = _EchoUL.substring(0, _EchoUL.length-1); }

var _EchoULEchoKey = _EchoUL.toUpperCase().indexOf("ECHO_KEY=");
var _EchoULOvKey = _EchoUL.toUpperCase().indexOf("OVKEY=");
var _EchoULTemp="", _EchoULSubDomain="", _EchoRFTemp="", _EchoRFSubDomain="";

if (_EchoULEchoKey > 0) { var _ii = _EchoUL.indexOf("&", _EchoULEchoKey+9); if( _ii > 0 ) { _EchoK = _EchoUL.substring(_EchoULEchoKey+9, _ii); } else { _EchoK = _EchoUL.substring(_EchoULEchoKey+9); } if( _EchoK != _EchoSK ) { echo_new_session = true; } FN_SetCookie("ECHO_KEY", _EchoK, "/", _EchoDoMain); }
if (_EchoULOvKey > 0) { var _ii = _EchoUL.toUpperCase().substring(_EchoULOvKey+6, _EchoUL.toUpperCase().indexOf("&", _EchoULOvKey+6)); _EchoOv = _ii; FN_SetCookie("ECHO_OVKEY", _ii, "/", _EchoDoMain); }
if (!_EchoK || _EchoK == "") { _EchoK="unknown"; }
if (!_EchoCK || _EchoCK == "") { _EchoCK="unknown"; }
if (_EchoK != "unknown") { _EchoCK = _EchoK; _EchoDate = EchoToDay; FN_SetCookie("ECHO_CKEY", _EchoK, "/", _EchoDoMain, EchoCookieDays * 24 * 60 * 60); FN_SetCookie("ECHO_DATE", EchoToDay, "/", _EchoDoMain, EchoCookieDays * 24 * 60 * 60); if (!_EchoAK || _EchoAK == "") { _EchoAK = _EchoK; FN_SetCookie("ECHO_AKEY", _EchoK, "/", _EchoDoMain, 1 * 24 * 60 * 60); } }
if (!_EchoSS || _EchoSS == "") { var _DT=new Date(); _EchoSS = ((Math.round(Math.random()*900)%900+100)) + "" + _DT.getTime(); FN_SetCookie("ECHO_SESSION", _EchoSS, "/", _EchoDoMain); }

_EchoUL = _EchoUL.replace("'", "");
_EchoULTemp = _EchoUL.replace("http://", "");
_EchoULTemp = _EchoULTemp.replace("https://", "");
_EchoULSubDomain = FN_FullDomain(_EchoULTemp);

if (!_EchoRF || _EchoRF == "") { _EchoRFSubDomain = ""; } else { _EchoRF = _EchoRF.replace("'", ""); _EchoRFTemp = _EchoRF.replace("http://", ""); _EchoRFTemp = _EchoRFTemp.replace("https://", ""); _EchoRFSubDomain = FN_FullDomain(_EchoRFTemp); }

var _LandYn = "N";
var _BookMark = "N";
var _EchoIPCloseYn = "N";

if (_EchoPR > 0) { if (_EchoULSubDomain != _EchoRFSubDomain) { _LandYn="Y"; if (_EchoRFSubDomain == "") { _BookMark="Y"; _LandYn="N"; } } _EchoInKey = _EchoCK; } else { if (_EchoULSubDomain != _EchoRFSubDomain) { _LandYn="Y"; if (_EchoRFSubDomain == "") {  _BookMark="Y"; _LandYn="N"; } } if (_EchoK=="unknown") { if (_EchoCK=="unknown") { _EchoInKey = _EchoAK; } else { _EchoInKey = _EchoCK; } } else { _EchoInKey = _EchoK; } }
if (_LandYn=="Y" && _BookMark=="N") { if (typeof(IPClose)=="object") {  if (IPClose[0].indexOf(EchoUIP) > 0) { _EchoIPCloseYn="Y"; FN_IPClose(); } } }
if (typeof(EchoTarget)!="string") { EchoTarget=""; }
if (typeof(EchoCV)=="undefined" || typeof(EchoCV)!="string") { _EchoCV=""; } else { _EchoCV=EchoCV; }
if (typeof(EchoPN)=="undefined" || typeof(EchoPN)!="string") { _EchoPN=""; } else { _EchoPN=EchoPN; }
if (typeof(EchoLogSend)=="undefined" || typeof(EchoLogSend)!="string") { _EchoLogSend=""; } else { _EchoLogSend=EchoLogSend; }

if (_EchoLogSend=="Y") {
	if (_EchoInKey!="" || _EchoAK!="") {
		if (_LandYn=="Y" || _EchoCV=="Y" || _BookMark=="Y") {
			var _EchoLogUrl = "//" + EchoLogServer + "/?ac=" + EchoID + "&k=" + escape(_EchoInKey) + "&ak=" + _EchoAK + "&ok=" + escape(_EchoOv)+ "&la=" + _LandYn + "&bm=" + _BookMark + "&gd=" + encodeURIComponent(EchoGoodNm) + "&at=" + EchoAmount + "&ud=" + escape(_EchoULSubDomain) + "&ul=" + escape(_EchoUL) + "&rd=" + escape(_EchoRFSubDomain) + "&rl=" + escape(_EchoRF) + "&pg=" + escape(_EchoUL.replace(_EchoSearch + _EchoHash,"")) + "&cd=" + _EchoDate + "&ic=" + _EchoIPCloseYn + "&br=" + escape(FN_getNavigatorInfoStr()) + "&os=" + escape(FN_getOSInfoStr()) + "&et=" + EchoTarget + "&cv=" + _EchoCV + "&pn=" + _EchoPN + "&ss=" + _EchoSS + "&vr=4.0";
			var _EchoImg = new Image(); _EchoImg.src = _EchoLogUrl;
		}
	}
} else {
	var _EchoLogUrl = "//" + EchoLogServer + "/?ac=" + EchoID + "&k=" + escape(_EchoInKey) + "&ak=" + _EchoAK + "&ok=" + escape(_EchoOv)+ "&la=" + _LandYn + "&bm=" + _BookMark + "&gd=" + encodeURIComponent(EchoGoodNm) + "&at=" + EchoAmount + "&ud=" + escape(_EchoULSubDomain) + "&ul=" + escape(_EchoUL) + "&rd=" + escape(_EchoRFSubDomain) + "&rl=" + escape(_EchoRF) + "&pg=" + escape(_EchoUL.replace(_EchoSearch + _EchoHash,"")) + "&cd=" + _EchoDate + "&ic=" + _EchoIPCloseYn + "&br=" + escape(FN_getNavigatorInfoStr()) + "&os=" + escape(FN_getOSInfoStr()) + "&et=" + EchoTarget + "&cv=" + _EchoCV + "&pn=" + _EchoPN + "&ss=" + _EchoSS + "&vr=4.0";
	var _EchoImg = new Image(); _EchoImg.src = _EchoLogUrl;
}

</script>


</form>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	
    </body>
</html>