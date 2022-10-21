<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.res_search.*" %>
<%@ page import="acar.cont.*, acar.client.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>


<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"0":request.getParameter("today_dist");
	String o_1 		= request.getParameter("o_1")==null?"0":request.getParameter("o_1");
	String rent_dt 		= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String a_a 		= request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String a_b 		= request.getParameter("a_b")==null?"":request.getParameter("a_b");
	String amt 		= request.getParameter("amt")==null?"0":request.getParameter("amt");
	
	String est_id	 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_code 	= request.getParameter("est_code")==null?"":request.getParameter("est_code");
	String opt_chk		= request.getParameter("opt_chk")==null?"0":request.getParameter("opt_chk");	
	int fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	String mobile_yn	= request.getParameter("mobile_yn")==null?"":request.getParameter("mobile_yn");
	String mail_yn		= request.getParameter("mail_yn")==null?"0":request.getParameter("mail_yn");
	String select_print_yn		= request.getParameter("select_print_yn")	==null?"":request.getParameter("select_print_yn");
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	
	String page_kind = "";
			
	if(est_id.equals("") && !car_mng_id.equals("")){
		if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){		//FMS 재리스결정차량에서 기본견적서/조정견적서
			est_id = shDb.getSearchEstId(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
			page_kind = "fms";
		}else{									//홈페이지 재리스차량 견적서
			est_id = shDb.getSearchEstIdSh(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
			page_kind = "homepage";
		}
	}
	

	if(est_id.equals("")){
		out.println("견적서를 못찾았습니다.");
		return;
	}
	
	//견적정보
	EstimateBean e_bean = new EstimateBean();
	
	//잔가 차량정보
	Hashtable sh_comp = new Hashtable();
	
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		e_bean = e_db.getEstimateCase(est_id);
		sh_comp = shDb.getShCompare(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}else{
		e_bean = e_db.getEstimateShCase(est_id);
		sh_comp = shDb.getShCompareSh(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}
	
	if(e_bean.getOpt_chk().equals("1") && opt_chk.equals("0")) 	opt_chk 	= e_bean.getOpt_chk();
	
	if(e_bean.getFee_opt_amt() >0 && fee_opt_amt == 0 ) 				fee_opt_amt = e_bean.getFee_opt_amt();
	
	
	//차종정보
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
	//차종코드변수
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());		
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);
	
	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 			= String.valueOf(ht.get("S_ST"));
	String jg_code 			= String.valueOf(ht.get("JG_CODE"));
	String car_no 			= String.valueOf(ht.get("CAR_NO"));
	String car_name			= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	String secondhand_dt 		= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 	= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 		= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 	= String.valueOf(ht.get("OPT"));
	String colo		 	= String.valueOf(ht.get("COL"));
	String car_y_form		= String.valueOf(ht.get("CAR_Y_FORM"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int tax_dc_amt		= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));	
	if(today_dist.equals("0"))	today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	String dist_cng			= String.valueOf(ht.get("DIST_CNG"));	
	int dpm 			= AddUtil.parseInt((String)ht.get("DPM"));
	float spe_dc_per		= AddUtil.parseFloat((String)ht.get("SPE_DC_PER"));
	String cha_st_dt 		= String.valueOf(ht.get("CHA_ST_DT"));
	String b_dist 			= String.valueOf(ht.get("B_DIST"));
	String car_use 			= String.valueOf(ht.get("CAR_USE"));

	if(e_bean.getB_dist() > 0){
		cha_st_dt 		= e_bean.getCha_st_dt();
		b_dist 			= String.valueOf(e_bean.getB_dist());
	}

	int car_use_mon = 0;
	//차량등록 경과기간2(차령만료일2개월전까지)
	if(!String.valueOf(ht.get("CAR_END_DT")).equals("") && AddUtil.checkDate(init_reg_dt)){	
		Hashtable carOld4 	= c_db.getOld(init_reg_dt, AddUtil.getDate(4), ""); //차령
		car_use_mon = (AddUtil.parseInt(String.valueOf(carOld4.get("YEAR")))*12) + AddUtil.parseInt(String.valueOf(carOld4.get("MONTH")));
	}
	
	String min_use_mon		= "6";
	if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){
		min_use_mon		= "12";
		//영업용차량 리스 용도변경시 (경차제외하고 24개월 이상 견적이 되도록)
		if(AddUtil.parseInt(jg_code) > 2000 && AddUtil.parseInt(jg_code) < 9999 && car_use.equals("1")){
			min_use_mon		= "24";
		}
		//영업용차량 리스 용도변경시 (경차제외하고 24개월 이상 견적이 되도록)
		if(AddUtil.parseInt(jg_code) > 2000000 && AddUtil.parseInt(jg_code) < 9999999 && car_use.equals("1")){
			min_use_mon		= "24";
		}
	}
	
	String max_use_mon		= e_bean.getMax_use_mon();
	if(max_use_mon.equals("")){
		if(car_use_mon>0){
			if(ej_bean.getJg_b().equals("2")){
				if(dpm > 2000){
					max_use_mon = String.valueOf(94-car_use_mon);
				}else{
					max_use_mon = String.valueOf(82-car_use_mon);
				}
			}else{
				if(dpm > 2000){
					max_use_mon = String.valueOf(95-car_use_mon);
				}else{
					max_use_mon = String.valueOf(83-car_use_mon);
				}
			}
			if(AddUtil.parseInt(max_use_mon) > 48){
				max_use_mon = "48";
			}
		}else{
			max_use_mon = "48";
		}
	}
		
	if(e_bean.getCar_amt()==0){
		e_bean.setCar_amt(car_amt);
		e_bean.setOpt_amt(opt_amt);
		e_bean.setCol_amt(clr_amt);
	}
	
	String stat = "";
	if(e_bean.getEst_st().equals("3") && car_amt == 0) stat = "신차가격불명";
	if(e_bean.getEst_st().equals("3") && AddUtil.parseInt((String)ht.get("O_L")) == 0) stat = "중고차가미정";
	
	//잔가 차량정보
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	int sh_car_amt			= AddUtil.parseInt((String)sh_var.get("SH_CAR_AMT"));
	int dlv_car_amt			= AddUtil.parseInt((String)sh_var.get("DLV_CAR_AMT"));
	
	sh_car_amt 	= e_bean.getO_1();
	dlv_car_amt = car_amt+opt_amt+clr_amt-tax_dc_amt-e_bean.getO_1();
	
	String rent_way = "2";
	if(!e_bean.getA_a().equals("")){
		a_a 		= e_bean.getA_a().substring(0,1);
		rent_way 	= e_bean.getA_a().substring(1);
	}
	if(a_b.equals(""))	a_b	= e_bean.getA_b();
	String a_e 			= s_st;
	float o_13 			= 0;
	
	//유효기간
	String vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 4));
	
	
	
		
	
	//연락처----------------------------------------------------------------
	
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
	
	String client_st = "2";
	
	ContBaseBean base = new ContBaseBean();
	ClientBean client = new ClientBean();
	

	if(e_bean.getMgr_ssn().equals("연장견적") && !e_bean.getEst_from().equals("ext_car")){
	
		//계약기본정보
		base = a_db.getCont(e_bean.getRent_mng_id(), e_bean.getRent_l_cd());

	  if(!e_bean.getEst_tel().equals("")){
			user_bean 	= umd.getUsersBean(e_bean.getEst_tel());
		}else{
			user_bean 	= umd.getUsersBean(base.getBus_id2());
		}
				
		//고객정보
		client = al_db.getClient(base.getClient_id());
		
		client_st = client.getClient_st();
		
		e_bean.setEst_tel	(client.getO_tel());
		e_bean.setEst_email	(client.getCon_agnt_email());
	}
	
	name 		= user_bean.getUser_nm();
	m_tel 		= user_bean.getUser_m_tel();
	br_id   	= user_bean.getBr_id();
	h_tel 		= user_bean.getHot_tel();
	i_fax   	= user_bean.getI_fax();
	email 		= user_bean.getUser_email();

	if(name.equals("박규숙")) name = "최수진";
	
	if(user_bean.getDept_id().equals("1000") && e_bean.getEst_st().equals("2")){
		vali_date = "미확정 견적";
	}
	
	int esti_num = 0;
%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
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
.style5 {color: #444444}
.style6 {color: #dc0039; font-weight: bold; }
.style7 {color: #1c75ba; font-weight: bold; }
.style8 {color: #354a6d}
.style9 {color: #5f52a0}
.style12 {color: #9cb445; font-weight: bold; }
.style13 {
	color: #c4c4c4;
	font-weight: bold;
}
.style14 {color: #616161}
.style15 {
	color: #6e6e6e;
	font-weight: bold;
}
.style16 {
	color: #77786b;
	font-size: 8pt
}
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
//-->		
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
	//인쇄하기
	function go_print(est_id){	
		var fm = document.form1;
		fm.est_id.value = est_id;
// 		fm.action = "esti_print_fms.jsp";
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
	
	//메일발송하기
	function go_mail(est_id){	
		var SUBWIN="/acar/apply/mail_input.jsp?from_page=<%=from_page%>&est_id=<%=est_id%>&write_id=<%=e_bean.getReg_id()%>&acar_id=<%=acar_id%>&opt_chk=<%=opt_chk%>&fee_opt_amt=<%=fee_opt_amt%>&est_email=<%=e_bean.getEst_email()%>&est_m_tel=<%=e_bean.getEst_tel()%>&content_st=sh_fms";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=600, scrollbars=no, status=yes");
	}

	//결과문자발송
	function esti_result_sms(est_id){	
		var SUBWIN="/acar/apply/sms_input.jsp?from_page=<%=from_page%>&est_id=<%=est_id%>&write_id=<%=e_bean.getReg_id()%>&acar_id=<%=acar_id%>&opt_chk=<%=opt_chk%>&fee_opt_amt=<%=fee_opt_amt%>&est_email=<%=e_bean.getEst_email()%>&est_m_tel=<%=e_bean.getEst_tel()%>&content_st=sh_fms";	
		window.open(SUBWIN, "openSMS", "left=100, top=100, width=420, height=600, scrollbars=no, status=yes");
	}
	
	//준비서류보기
	function go_paper(){
		var SUBWIN="/acar/main_car_hp/papers.html";	
		window.open(SUBWIN, "openpaper", "left=50, top=50, width=700, height=770, status=no, scrollbars=no, resizable=no");
	}		
	
	//기본사양보여주기
	function opt(est_id){  
		var fm = document.form1;
		var SUBWIN="/acar/main_car_hp/opt.jsp?est_id="+est_id+"&from_page=<%=from_page%>";	
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
<input type="hidden" name="from_page" 	value="<%=from_page%>">
<input type="hidden" name="est_id" 		value="<%=est_id%>">
<input type="hidden" name="acar_id" 	value="<%=acar_id%>">
<input type="hidden" name="opt_chk" 	value="<%=opt_chk%>">
<input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">
<input type="hidden" name="mobile_yn" 	value="<%=mobile_yn%>">
<input type="hidden" name="content_st" 	value="sh_fms">
<table width=680 border=0 cellspacing=0 cellpadding=0>
    <tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
    <tr>
        <td height=8 colspan=3></td>
    </tr>
    <tr>
        <td colspan=3>
            <table width=680 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=21>&nbsp;</td>
                    <td width=478><img src=../main_car_hp/images/title_2.gif></td>
                    <td width=160 align=right>
                        <table width=100% border=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>작성일</span></td>
                                <td width=97 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>유효기간</span></td>
                                <td bgcolor=ffffff align=center><span class=style16><%=vali_date%></span></td>
                            </tr>
                        </table>
                    </td>
                    <td width=21>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=5 colspan=3></td>
    </tr>
    <tr>
        <td width=21>&nbsp;</td>
        <td width=638>
            <table width=638 border=0 cellspacing=0 cellpadding=0>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellspacing=0 cellpadding=0>
                <tr> 
                  <td width=410> <table width=410 border=0 cellspacing=0 cellpadding=0>
                      <tr> 
                        <td height=30 colspan=4>&nbsp;<span class=style1>
                        	<%if(e_bean.getEst_from().equals("tae_car")){%>
						                [ 출고전대차 ]
						              <%}else{%>  
                        	  [ <%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%> ]
                            <%if(e_bean.getEst_from().equals("res_car")){%>
	  					                - 일반대차
                            <%}else if(e_bean.getEst_from().equals("emp_car")){%>
			  			                - 업무용차 순원가
						                <%}else{%>
						                  <%if(e_bean.getEst_st().equals("1")){%>- 보유차<%if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){%>재리스<%}else{%>재렌트<%}%>
						                  <%}else if(e_bean.getEst_st().equals("2")){%>- 연장계약
						                  <%}else if(e_bean.getEst_st().equals("3")){%>- 중고차 리스
						                  <%}%>
						                <%}%>
						              <%}%>  
						  </span></td>
                      </tr>
                      <tr> 
                        <td colspan=4><img src=../main_car_hp/images/line.gif width=409 height=1></td>
                      </tr>
                      <tr> 
                        <td width=24 height=25 align=center><img src=../main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td colspan=3><div align="left"><span class=style2><%=e_bean.getEst_nm()%>님
                            <%if(client_st.equals("2")){%>귀하<%}else{%>귀중<%}%></span></div></td>
                      </tr>
                      <tr> 
                        <td colspan=4><img src=../main_car_hp/images/line.gif width=409 height=1></td>
                      </tr>
                      <tr> 
                        <td width=24 height=25 align=center><img src=../main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td width=160><span class=style2>TEL.<%=e_bean.getEst_tel()%></span></td>
                        <td width=24 align=center><img src=../main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td width=202><span class=style2>FAX.<%=e_bean.getEst_fax()%></span></td>
                      </tr>
                      <tr> 
                        <td colspan=4><img src=../main_car_hp/images/line.gif width=409 height=1></td>
                      </tr>
                    </table></td>
                  <td width=28>&nbsp;</td>
                  <td width=201 valign=bottom> 
                  	<table width=201 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/tel_bg_new.gif  height=80>
		   				<tr> 
                        	<td colspan=4 height=9></td>
	                	</tr>
	               		<tr> 
	                        <td width=60 align=center>&nbsp;<span class=style5><b><%= name %></b></span></td>
	                        <td width=30 align=right>hp)</td>
	                        <td width=111 class=listnum2>&nbsp;<span class=style5><%= m_tel %></span></td>
	                 	</tr>
	                  	<tr> 
	                        <td>&nbsp;</td>
	                        <td align=right>tel)</td>
	                        <td class=listnum2>&nbsp;<span class=style5><%= h_tel %></span></td>
	                 	</tr>
	                   	<tr> 
	                     	<td>&nbsp;</td>
	                        <td align=right>fax)</td>
	                        <td class=listnum2>&nbsp;<span class=style5><%= i_fax %></span></td>
	                  	</tr>
	                  	<tr> 
	                        <td>&nbsp;</td>
	                        <td colspan='2' class=listnum2>&nbsp;&nbsp;<span class=style5><%= email %></span></td>
	                  	</tr>
        				<tr> 
                        	<td colspan=4 height=5></td>
                      	</tr>          
                    </table>
					</td>
                </tr>
                <tr> 
                  <td colspan="3" height="10"></td>
                </tr>
				<%if(stat.equals("신차가격불명")){%>
                <tr> 
                  <td colspan="3" height="17">&nbsp;※ 본 견적은 개략적 추정견적이며, 신차가격이 확인되어야 확정견적이 제시됩니다.</td>
                </tr>
				<%}	else if(stat.equals("중고차가미정")){%>
                <tr> 
                  <td colspan="3" height="17">&nbsp;※ 본 견적은 개략적 추정견적이며, 중고차가격이 결정인되어야 확정견적이 제시됩니다.</td>                
				</tr>
				<%}else{%>
                <tr> 
                  <td colspan="3" height="17">&nbsp;※ 귀사에서 문의하신 장기대여에 대하여 아래와 같이 견적을 제출하오니 
                    검토하시고 좋은 답변 부탁드립니다.</td>
                </tr>
				<%}%>
              </table></td>
          </tr>
          <tr> 
            <td height=10 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2">
            <%if(e_bean.getAccid_serv_zero().equals("Y")){//무사고차견적%>
<!--             <img src=../main_car_hp/images/bar_01_msg.gif> -->
            <div class='esti-title'>
            	<span class='esti-num'>0<%=++esti_num%></span> 
            	대여차량
            	<sapn class='esti-title-sub'>(실 견적이 아님: 본 견적은 이 차량이 무사고였을 경우를 가정하여 견적한 것입니다)</sapn>
            </div>
            <%}else{%>
<!--             <img src=../main_car_hp/images/bar_01.gif> -->
            <div class='esti-title'><span class='esti-num'>0<%=++esti_num%></span> 대여차량</div>
            <%}%>
            </td>
          </tr>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=132 height=17 align=center bgcolor=f2f2f2><span class=style3>제조사</span></td>
                  <td width=388 bgcolor=#FFFFFF>&nbsp;<span class=style4><%= c_db.getNameById(car_comp_id, "CAR_COM") %></span></td>
                  <td width=114 align=center bgcolor=f2f2f2><span class=style3>금 
                    액</span></td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>차종(차량모델명)</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(est_id.length() > 0){%><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=car_name%></a><%}else{%><%=car_name%><%}%></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%if(stat.equals("신차가격불명")){%>미확인<%}else{%><%= AddUtil.parseDecimal(e_bean.getCar_amt()) %>
                    원<%}%></span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>옵 
                    션</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(est_id.length() > 0){%><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=opt%></a><%}else{%><%=opt%><%}%></span>
                      <%if(car_mng_id.equals("018647")){%>(현재 판매되는 프리미엄 사양과 유사한 모델임)<%}%>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getOpt_amt()) %>
                    원</span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>색 상 </span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(!e_bean.getIn_col().equals("")){%>외장: <%}%><%=colo%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;내장: <%=e_bean.getIn_col()%><%}%></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getCol_amt()) %>
                    원</span>&nbsp;</td>
                </tr>
                <%if(!e_bean.getConti_rat().equals("")){%>
                <tr>
                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>연 비 </span></td>
                    <td bgcolor=#FFFFFF>
                    	<span id="contiRatDesc">
                    		&nbsp;<%=e_bean.getConti_rat()%>
                    	</span>
                    </td>
                    <td bgcolor=#FFFFFF></td>
                </tr>
                <%}%>
                <!-- 신차 개소세 감면 추가(2017.10.13) -->
                <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
                <tr>
                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>신차 개소세 감면 </span></td>
                    <td bgcolor=#FFFFFF>
                    </td>
                    <td align=right bgcolor=#FFFFFF><span class=style4> - <%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 원</span>&nbsp;</td>
                </tr>
                <%}%>
                
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>감가상각
                   </span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7>신차등록일 : <%=AddUtil.ChangeDate2(init_reg_dt)%> (모델연도:<%=car_y_form%>)
                  	<%if(!e_bean.getTot_dt().equals("") && (e_bean.getEst_from().equals("tae_car") || e_bean.getEst_from().equals("secondhand"))){//재리스,출고전대차%>
                  		<br>&nbsp;주행거리 : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km (확인일자:<%=AddUtil.ChangeDate2(e_bean.getTot_dt())%>)
                  	<%}else{%>
                  		&nbsp;&nbsp;주행거리 : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km	
                  	<%}%>
                  	</span>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style4>-<%if(stat.equals("신차가격불명") || stat.equals("중고차가미정")){%>##,###,###<%}else{%><%= AddUtil.parseDecimal(dlv_car_amt) %><%}%>
				    원</span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=20 align=center bgcolor=f2f2f2><span class=style3>차량가격</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7>차량번호 : <%if(!car_no.equals("")){ out.println("****"+car_no.substring(car_no.length()-4, car_no.length())); } %>
                      </span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style6><%if(stat.equals("중고차가미정")){%>미결정<%}else{%><%=AddUtil.parseDecimal(e_bean.getO_1())%> 
                    원<%}%></span>&nbsp;</td>
                </tr>
              </table></td>
          </tr>		  
          <tr> 
		 	<td height=10 colspan="2">
		   		<table width=638 border=0 cellpadding=0 cellspacing=1>
		        	<tr>
		        		<td>
			        	<%if(!e_bean.getEst_from().equals("res_car") && !e_bean.getEst_from().equals("emp_car") && !e_bean.getEst_from().equals("tae_car") && e_bean.getEst_st().equals("1") && !e_bean.getA_a().equals("")){%>
			          		※ 엔진, 변속기 : 2개월/5,000Km 품질보증<span style="font-size:10px;">(기간 또는 주행거리 중 먼저 도래한 것을 보증기간 만료로 간주)</span>			          				          		
			          	<%}%>
			          	<%if (e_bean.getBr_to_st().equals("0")) {%>
		          			<p style="margin: 0px;">※ 고객주소지(차량인도지역) : 수도권</p>
		          		<%} else if (e_bean.getBr_to_st().equals("1")) {%>
		          			<p style="margin: 0px;">※ 고객주소지(차량인도지역) : 대전/세종/충남/충북</p>
		          		<%} else if (e_bean.getBr_to_st().equals("2")) {%>
		          			<p style="margin: 0px;">※ 고객주소지(차량인도지역) : 대구/경북</p>
		          		<%} else if (e_bean.getBr_to_st().equals("3")) {%>
		          			<p style="margin: 0px;">※ 고객주소지(차량인도지역) : 광주/전남/전북</p>
		          		<%} else if (e_bean.getBr_to_st().equals("4")) {%>
		          			<p style="margin: 0px;">※ 고객주소지(차량인도지역) : 부산/울산/경남</p>
		          		<%} else if (e_bean.getBr_to_st().equals("5")) {%>
		          			<p style="margin: 0px;">※ 고객주소지(차량인도지역) : 강원</p>
		          		<%}%>
		          		</td>
			            <td height=10 align="right">
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
							<%if(cm_bean.getDiesel_yn().equals("Y")){%>			※ 디젤엔진
							<%}else if(cm_bean.getDiesel_yn().equals("2")){%>		※ LPG전용차
							<%}else if(cm_bean.getDiesel_yn().equals("1")){%>		※ 가솔린엔진
							<%}else if(cm_bean.getDiesel_yn().equals("3")){%>		※ 하이브리드
							<%}else if(cm_bean.getDiesel_yn().equals("4")){%>		※ 플러그인 하이브리드
							<%}else if(cm_bean.getDiesel_yn().equals("5")){%>		※ 전기차
							<%}else if(cm_bean.getDiesel_yn().equals("6")){%>		※ 수소차
							<%}%>
						<%	}%>
						<%}%>			
						</td>
			          </tr>
			     </table>
			  </td>
		</tr>
          <%if(!dist_cng.equals("")){%>
          <tr>
          	<td colspan="2" bgcolor=f2f2f2 height=45><span class=style4> * 위 차량은 계기판 교환 이력(<%=AddUtil.getDate3(cha_st_dt)%>)이 있는 차량으로 계기판 교환전 주행거리는 <%=AddUtil.parseDecimal(b_dist)%>km, 교환후 현 계기<br>
          	&nbsp; 판의 주행거리는 <%=AddUtil.parseDecimal(AddUtil.parseInt(today_dist)-AddUtil.parseInt(b_dist))%>km입니다. 감가상각 계산시에는 주행거리를 <%=AddUtil.parseDecimal(today_dist)%>km로 적용하고, 사고수리에 따른 시세하락을<br>
          	&nbsp; 반영하였습니다.</span></td>
          </tr>
          <%}%>
		
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          
          <!-- 출고전대차일 때는 약정운행거리 항목 노출시키지 않음. -->
          <%if(!e_bean.getEst_from().equals("tae_car")){%>
          <tr> 
             <td height=10 colspan="2"></td>
          </tr>
          <tr> 
            	<td colspan="2">
<!--             		<img src=../main_car_hp/images/bar_2022_04.jpg width=638 height=22> -->
            		<div class='esti-title'>
						<span class='esti-num'>0<%=++esti_num%></span>
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
	            			<td bgcolor=ffffff rowspan=3 align=center width=110><span class=style6><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km이하 / 1년</span>
	            				<%if(!e_bean.getEst_st().equals("2") && AddUtil.parseInt(e_bean.getA_b()) <12){
            						String agree_dist_m = AddUtil.parseFloatNotDot2(AddUtil.parseFloat(String.valueOf(e_bean.getAgree_dist()))/(12/AddUtil.parseFloat(e_bean.getA_b())));
            						
            				%>	            				
            				<br>
            				<span style="font-size:11px;">※<%=AddUtil.parseDecimal(agree_dist_m)%>km이하 / <%=e_bean.getA_b()%>개월</span>
            				<%}%>
	            			</td>
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
	            			<td bgcolor=ffffff height=17>
	            			  &nbsp;
	            			  	<%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
		            			  	<% if(AddUtil.parseInt(e_bean.getA_b()) >= 24){ %>	
		            			  		매입옵션 행사시에는 (약정이하운행시) 환급대여료가 지급되지 않고, (약정초과운행시) 초과운행대여료가 면제됩니다. (기본식)
		            			  	<%}%>
	            			  	<%}%>
	            			</td>
	            		</tr>
	            		
	            	</table>
	            </td>
			</tr>				

				<%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20150217 && !e_bean.getEst_st().equals("2")){%>
	                  <tr> 
			    	<td colspan=2 height=22>&nbsp;<span class=style3>* 약정운행거리를 줄이면 대여요금이 인하되고, 약정운행거리를 늘리면 대여요금이 인상됩니다.</span></td>
	                  </tr>
				<%}%>
		<%}%>
          
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellspacing=0 cellpadding=0>
                <tr> 
                  <td width=208>
                  <%if(!e_bean.getIns_per().equals("2")){%>
<!--                   <img src=/acar/main_car_hp/images/bar_02.gif width=208 height=22> -->
                  <div class='esti-title'>
					<span class='esti-num'>0<%=++esti_num%></span>
					대여요금 
					<sapn class='esti-title-sub'>(보험료 포함)</sapn>
					</div>
                  <%}else{%>
<!--                   <img src=/acar/main_car_hp/images/bar_02_1.gif width=208 height=22> -->
                  <div class='esti-title'>
						<span class='esti-num'>0<%=++esti_num%></span>
						대여요금 
						<sapn class='esti-title-sub'>(보험료 미포함)</sapn>
					</div>
                  <%}%>
                  </td>
                  <td width=30>&nbsp;</td>
                  <td width=400>
<!--                   <img src=../main_car_hp/images/bar_03.gif width=400 height=22> -->
                  <div class='esti-title'>
						<span class='esti-num'>0<%=++esti_num%></span>
						보험보상범위
					</div>
                  </td>
                </tr>
                <tr> 
                  <td height=4 colspan=3></td>
                </tr>
                <tr> 
                  <td> <table width=208 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                      <tr> 
                        <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>대여기간</span></td>
                        <td width=113 align=right bgcolor=#FFFFFF><span class=style4><%if(e_bean.getEst_from().equals("res_car")){%>1일<%}else{%><%=e_bean.getA_b()%>개월<%}%></span>&nbsp;</td>
                      </tr>
					  <%	int fee_s_amt = e_bean.getFee_s_amt();
								int fee_v_amt = e_bean.getFee_v_amt();
						  	int fee_t_amt = e_bean.getFee_s_amt()+e_bean.getFee_v_amt();
								if(e_bean.getEst_from().equals("res_car")){
									fee_s_amt = AddUtil.ml_th_rnd(fee_s_amt/30);
									fee_v_amt = fee_s_amt/10;
									fee_t_amt = fee_s_amt+fee_v_amt;
								}
					  %>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>공 
                          급 가 </span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(fee_s_amt)%> 
                          원</span>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>부 
                          가 세 </span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(fee_v_amt)%> 
                          원</span>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>월대여료</span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style6><%=AddUtil.parseDecimal(fee_t_amt)%> 
                          원</span>&nbsp;</td>
                      </tr>
                    </table></td>
                  <td>&nbsp;</td>
                  <td> 
				  <%if(!e_bean.getIns_per().equals("2")){%>
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
                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5천만원<%}else if(e_bean.getIns_dj().equals("4")){%>2억원<%}else if(e_bean.getIns_dj().equals("8")){%>3억원<%}else if(e_bean.getIns_dj().equals("3")){%>5억원<%}else{%>1억원<%}%></span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>운전자연령</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean.getIns_age().equals("3")){%>만24세이상<%}else{%>만26세이상<%}%></span></td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>자기신체사고</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5천만원<%}else{%>1억원<%}%></span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>긴급출동</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>가입</span></td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>자차면책금</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>원</span></td>
                        <%if (e_bean.getDoc_type().equals("")) {%>
                        <td align=center bgcolor=f2f2f2 colspan="2"></td>
                        <%} else {%>
                        <td align=center bgcolor=f2f2f2><span class=style3>운전자범위</span></td>
                        <td align=center bgcolor=#FFFFFF>
						<%if (e_bean.getDoc_type().equals("1") || e_bean.getDoc_type().equals("2")) {%>
							<%if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000 && e_bean.getCom_emp_yn().equals("Y")) {%>
							<span class=style4>임직원한정</span>
							<%} else if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000000 && e_bean.getCom_emp_yn().equals("Y")) {%>
                       	  	 <span class=style4>임직원한정</span>
                       		<%} else {%>
							<span class=style4>임직원과 직계가족</span>
							<%}%>
						<%-- <%} else if (e_bean.getDoc_type().equals("2")) {%>
							<span class=style4>임직원과 직계가족</span> --%>
						<%} else if (e_bean.getDoc_type().equals("3")) {%>
							<span class=style4>계약자 및 직계가족</span>
						<%}%>
                        </td>
                        <%}%>
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
                
                <%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && e_bean.getA_a().equals("12")) {%>
	            <tr>
					<td colspan="3" align="right">※ 사고수리시 아마존카 지정 정비공장에서 수리</td>
	            </tr>
	            <%}%>
                
                <%if(e_bean.getEst_from().equals("tae_car")){%>
                <tr> 
                  <td height=15 colspan=3 class=listnum2>&nbsp;<span class=style3>* 신차 계약 약정운행거리 : <%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km이하/1년</span></td>
                </tr>
                <%}else{%>
                <tr> 
                  <td height=15 colspan=3 class=listnum2>&nbsp;<span class=style3>* 본 차량의 대여기간은 <%=min_use_mon%>개월~<%=max_use_mon%>개월 사이 모든 개월수에서 선택가능합니다.</span></td>
                </tr>
                <%}%>
                
        		<!--용품-->
        		<%if(e_bean.getTint_b_yn().equals("Y") || e_bean.getTint_s_yn().equals("Y")|| e_bean.getTint_n_yn().equals("Y")|| e_bean.getTint_eb_yn().equals("Y")){
        				String tint_all = "";
        				if(e_bean.getTint_b_yn().equals("Y")){	tint_all +="1";	}		//2채널 블랙박스
        				if(e_bean.getTint_s_yn().equals("Y")){	tint_all +="2";	}		//전면 썬팅
        				if(e_bean.getTint_n_yn().equals("Y")){	tint_all +="3";	}		//거치형 내비게이션
        				if(e_bean.getTint_eb_yn().equals("Y")){	tint_all +="4";	}		//이동형 충전기 대여비용
        		%>                        
                        <tr> 
			    			<td colspan=3 class=listnum2 valign=top>&nbsp;<span class=style3>* 
                            	<%if(tint_all.equals("1")){%>위 대여요금은 2채널 블랙박스가 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("2")){%>위 대여요금은 전면 썬팅이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("3")){%>위 대여요금은 거치형 내비게이션이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("4")){%>위 대여요금은 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("12")){%>위 대여요금은 2채널 블랙박스와 전면 썬팅이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("13")){%>위 대여요금은 2채널 블랙박스와 거치형 내비게이션이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("14")){%>위 대여요금은 2채널 블랙박스와 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("23")){%>위 대여요금은 전면 썬팅과 거치형 내비게이션이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("24")){%>위 대여요금은 전면 썬팅과 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("34")){%>위 대여요금은 거치형 내비게이션과 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("123")){%>위 대여요금은 2채널 블랙박스, 전면 썬팅, 거치형 내비게이션이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("124")){%>위 대여요금은 2채널 블랙박스, 전면 썬팅, 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("134")){%>위 대여요금은 2채널 블랙박스, 거치형 내비게이션, 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("234")){%>위 대여요금은 전면 썬팅, 거치형 내비게이션, 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("1234")){%>위 대여요금은 2채널 블랙박스, 전면 썬팅, 거치형 내비게이션, 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>    
                                </span>
                            </td>
                        </tr>                        
                        <%}%>               
                                        
				<%if(AddUtil.parseInt(cm_bean.getJg_code()) < 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000)){%>

                <tr> 
					<td height=20 colspan=3 class=listnum2>&nbsp;<span class=style8>* 대여료(월대여료,선납금)가 업무용으로 손비처리 가능할 경우 부가세는 <strong>매입세액공제(환급)받으실 수 있습니다.</strong>
					</span></td>
                </tr>
				<%}%>	
				<%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%>			
                <tr> 
					<td height=20 colspan=3 class=listnum2>&nbsp;<span class=style8>* 대여료(월대여료,선납금)가 업무용으로 손비처리 가능할 경우 부가세는 <strong>매입세액공제(환급)받으실 수 있습니다.</strong>
					</span></td>
                </tr>
				<%}%>	
				<%if(e_bean.getEst_from().equals("emp_car")){%>				
                <tr> 
					<td height=20 colspan=3 class=listnum2>&nbsp;
						<span class=style8>
							<%if(AddUtil.parseInt(e_bean.getRent_dt()) < 20110331){%>
							※ 실제 적용값은 [여기 계산된 공급가 * 85% -10만원]으로 함. (과다감가상각등 기타 원가 요인 감안 및 급여공제분 반영)
							<%}else{%>
							※ 적용값은 공급가
							<%}%>
						</span>
					</td>
                </tr>
				<%}%>				
              </table></td>
          </tr>
          
          <tr> 
             <td height=10 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2">
            <%-- <%if(!e_bean.getEst_from().equals("tae_car")){ // 출고전대차 아닐 때%>
            	<img src=../main_car_hp/images/bar_2022_05.jpg width=638 height=22>
            <%} else{		// 출고전대차%>
            	<img src=../main_car_hp/images/bar_04.gif width=638 height=22>
            <%} %> --%>
            <div class='esti-title'>
				<span class='esti-num'>0<%=++esti_num%></span>
				초기납입금
			</div>
            </td>
          </tr>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=75 height=17 align=center bgcolor=f2f2f2><span class=style3>보 
                    증 금</span></td>
                  <td width=93 align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getGtr_amt())%> 
                    원</span>&nbsp;</td>
                  <td width=82 align=center bgcolor=f2f2f2><span class=style3>차가의 <%=e_bean.getRg_8()%>%</span></td>
                  <td width=383 bgcolor=#FFFFFF>&nbsp;<span class=style4>보증금은 
						  	계약기간 만료 후 환불해 드립니다. <!-- 연장견적일때는 지워주세요-->[보증금 100만원을 증액하면,<br>&nbsp;월대여료 5,500원(VAT포함)이 인하됩니다.(년리6.6%효과)]<!-- 연장견적일때는 지워주세요--></span></td>
				</tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>선 
                    납 금</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%> 
				    원</span>&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style4>VAT포함</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- 출고전대차는 문구표시X(2018.03.29) -->
                  	<span class=style4>선납금은 매월 일정 금액씩 공제되어 소멸되는 돈입니다. </span><br>&nbsp;
                  	<span class="style4" style="letter-spacing:-1.2px;">※ 세금계산서는 계약이용기간 동안 매월 균등 발행 또는 납부시 일시 발행 중 선택가능 </span>
                  	<%} %>
                  </td><!-- 2018.01.25 추가 -->
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>개시대여료</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
				    원</span>&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style4>VAT포함</span></td>
                  <td bgcolor=#FFFFFF>
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- 출고전대차는 문구표시X(2018.03.29) -->
                  	&nbsp;<span class=style4>개시대여료는 마지막 (<%=e_bean.getG_10()%>)개월치 대여료를 선납하는 것입니다. </span>
                  	<%} %>
                  </td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>합 
                    계 </span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style6><%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
                    원</span>&nbsp;</td>
                  <td colspan=2  bgcolor=f2f2f2> &nbsp;&nbsp;&nbsp;<span class=style4>위의 대여요금은 좌측 초기납입금 이자효과가 반영된 금액입니다.</span></td>
                </tr>
              </table></td>
          </tr>
		  <%if(e_bean.getIfee_s_amt()>0 && (AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10())>0 ){%>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=206 height=17 align=center bgcolor=f2f2f2><span class=style3>월대여료 
                    잔여납입회수</span></td>
                  <td width=82 align=center bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>회</span></td>
                  <td width=346 bgcolor=#FFFFFF>&nbsp;<span class=style4>개시대여료를 
                    납입한 경우만 적용되는 내용입니다. </span></td>
                </tr>
              </table></td>
          </tr>
		  <%}%>
		  <%if(e_bean.getPp_ment_yn().equals("Y")){%>     
      <tr> 
		    <td colspan=2>&nbsp;<span class=style3>* 초기납입금은 고객님의 신용도에 따라 심사과정에서 조정될 수 있습니다.</span></td>
      </tr>
      <%}%>		  		  
<!--적용잔가율-->

<%		if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){ //기본식%>
<%			if(e_bean.getRo_13_amt() > 0 && AddUtil.parseInt(e_bean.getA_b()) < 24){
					e_bean.setRo_13(0);
					e_bean.setRo_13_amt(0);
				}
				if(stat.equals("중고차가미정")){
					e_bean.setRo_13(0);
					e_bean.setRo_13_amt(0);
				}
//				if(cm_bean.getDiesel_yn().equals("2")){//일반승용LPG전용차는 매입옵션 미제공
				if(AddUtil.parseInt(e_bean.getRent_dt()) < 20190419 && cm_bean.getDiesel_yn().equals("2")){	//20190419
					if(cm_bean.getS_st().equals("300") || cm_bean.getS_st().equals("301") || cm_bean.getS_st().equals("302")){
						e_bean.setRo_13(0);
						e_bean.setRo_13_amt(0);
					}
				}
%>
                <tr> 
                    <td height=10 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2">
                    	<%-- <%if(!e_bean.getEst_from().equals("tae_car")){	// 출고전대차 아닐 때 %>
	                    	<img src=../main_car_hp/images/bar_2022_06.jpg width=638 height=22>
						<%} else{ // 출고전대차%>
	                    	<img src=../main_car_hp/images/bar_05_1.gif width=638 height=22>
						<%} %> --%>
						<div class='esti-title'>
							<span class='esti-num'>0<%=++esti_num%></span>
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
                                <td width=113 align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getRo_13()==0 ){%><%}else{%><%=e_bean.getRo_13()%>%<%}%></span></td>
                                <td width=60 align=center bgcolor=f2f2f2><span class=style4>&nbsp;</span></td>
                                <td width=368 bgcolor=#FFFFFF align=left>&nbsp;<span class=style4>적용잔가율 = 매입옵션율</span></td>
                            </tr>
                            <tr> 
                                <td height=17 align=center bgcolor=f2f2f2><span class=style3>매입옵션가격</span></td>
                                <td align=right bgcolor=#FFFFFF><span class=style4><%if(e_bean.getRo_13()==0 ){%>매입옵션 없음<%}else{%><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>원<%}%></span>&nbsp;</td>
                                <td align=center bgcolor=f2f2f2><span class=style4><%if(e_bean.getRo_13()>0 ){%>VAT포함<%}%></span></td>
                                <td bgcolor=#FFFFFF align=left>&nbsp;<span class=style4><%if(e_bean.getRo_13()>0 ){%>본 매입옵션가격에 이용차량을 매입할 수 있는 권리를 드립니다.<%}%></span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<%if(e_bean.getRo_13() == 0 && AddUtil.parseInt(e_bean.getA_b()) < 24){%>
                <tr> 
                    <td height=10 colspan="2">&nbsp;<span class=style8>※ 매입옵션은 <strong>기본식 24개월이상 계약</strong>시에만 주어짐.
					</span></td>
                </tr>				
				<%}%>
				<%if(e_bean.getRo_13() == 0 && AddUtil.parseInt(e_bean.getA_b()) >= 24){%>
                <tr> 
                    <td height=10 colspan="2">&nbsp;<span class=style8>※ 매입옵션 없음.
					</span></td>
                </tr>				
				<%}%>
<%		}%>
<!--적용잔가율-->
          <tr> 
            <td height=10 colspan="2"></td>
          </tr>
          <%if(!e_bean.getEst_from().equals("tae_car")){%>
          
          		<tr> 
		            <td colspan="2">
		            <%-- <%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
				            <img src=../main_car_hp/images/bar_2022_08.jpg width=638 height=22>
		            <%}else{%>
				            <img src=../main_car_hp/images/bar_2022_07_yj.jpg width=638 height=22>
		            <%	}%> --%>
		            <div class='esti-title'>
						<span class='esti-num'>0<%=++esti_num%></span>
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
		            			<td colspan=2 bgcolor=ffffff> &nbsp;중도해지시에는 잔여계약기간 총 대여료의 <span class=style6><b><%if(e_bean.getCls_per()>0){%><%=AddUtil.parseFloatNotDot(e_bean.getCls_per())%><%}else{%><%	if(e_bean.getMgr_ssn().equals("연장견적")){%>20<%}else{%>30<%}%><%}%>%</b></span> 의 위약금이 있음</td>
		            		</tr>
		            	</table>
		            </td>
				</tr>				
        <%}%>
          <tr> 
            <td height=10 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2">
            	<!-- 차량관리 서비스 제공범위 -->
           	    <%-- <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){	// 기본식%>
           	    	<%if(!e_bean.getEst_from().equals("tae_car")){ // 출고전대차 아닐때%>
            	        <%if(ej_bean.getJg_k().equals("0")){%>
            	        <img src=../main_car_hp/images/bar_07_1_2.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
            	        <img src=../main_car_hp/images/bar_07_1_1.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- 대차서비스는 일반 내연기관차량으로 제공 2017.11.15 -->
            	        <img src=../main_car_hp/images/bar_07_3.gif width=638 height=22>
            	        <%}else{%>
            	        <img src=../main_car_hp/images/bar_2022_07.jpg width=638 height=22>
            	        <%}%>
            	    <%}else{	 %>
            	        <%if(ej_bean.getJg_k().equals("0")){%>
            	        <img src=../main_car_hp/images/bar_06_1_2.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
            	        <img src=../main_car_hp/images/bar_06_1_1.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- 대차서비스는 일반 내연기관차량으로 제공 2017.11.15 -->
            	        <img src=../main_car_hp/images/bar_06_3.gif width=638 height=22>
            	        <%}else{%>
            	        <img src=../main_car_hp/images/bar_06_1.gif width=638 height=22>
            	        <%}%>
           	    	<%}%>
           	    <%}else{%>
           	    	<%if(!e_bean.getEst_from().equals("tae_car")){ // 출고전대차 아닐때%>
            	        <%if(ej_bean.getJg_k().equals("2")){%>
            	        <img src=../main_car_hp/images/bar_06_1_1.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- 대차서비스는 일반 내연기관차량으로 제공 2017.11.15 -->
            	        <img src=../main_car_hp/images/bar_06_3.gif width=638 height=22>
            	        <%}else{%>
            	        <img src=../main_car_hp/images/bar_06_1.gif width=638 height=22>
            	        <%}%>
           	        <%}else{	// 출고전대차%>      	    	            	        
            	        <%if(ej_bean.getJg_k().equals("2")){%>
            	        <img src=../main_car_hp/images/bar_05_1_1.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- 대차서비스는 일반 내연기관차량으로 제공 2017.11.15 -->
            	        <img src=../main_car_hp/images/bar_05_3.gif width=638 height=22>
            	        <%}else{%>
            	        <img src=../main_car_hp/images/bar_05.gif width=638 height=22>
            	        <%}%>		      
            	    <%	}%>            
           	    <%	}%> --%>      
           	    
           	    <div class='esti-title'>
					<span class='esti-num'>0<%=++esti_num%></span>
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
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
		          <td colspan="2" valign=top> 
		          		<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                  	<tr> 
		                     	<td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>공통서비스</span></td>
		                    	<td width=543 colspan=2 bgcolor=#FFFFFF>&nbsp;<%if(!e_bean.getInsurant().equals("2")){%>* 교통사고 발생시 <span class=style3><b>사고처리 업무 대행</b></span><%}%> &nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;*<span class=style3><b> 사고대차서비스</b></span>(피해사고시는 보험대차)<%}%></td>
		                    </tr>
		                </table>
		          </td>
		         </tr>
		         <tr></tr>
		         <tr>
		         	<td colspan="2">
		                <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                    <tr>
		                       	<td colspan=2 align=center bgcolor=#f2f2f2 height=17><input type="checkbox" name="rent_way" value="3" <%if(!ej_bean.getJg_k().equals("0") && !rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:3px;"><b>기본식</b> (정비서비스 미포함 상품)</span></td>
		                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<input type="checkbox" name="rent_way" value="1" <%if(!ej_bean.getJg_k().equals("0") && rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:3px;"><b>일반식</b> (정비서비스 포함 상품)</span></td>
		                  	</tr>
		                  	<tr>
		                  		<td width=356 colspan=2 bgcolor=#FFFFFF height=95>&nbsp; <span class=style3><b>* 아마존케어 서비스</b></span><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - 차량 정비 관련 유선 상담서비스 상시 제공<br>
		                  		<%if(!e_bean.getEst_st().equals("2")){%>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - 대여 개시 2개월 이내 무상 정비대차 제공<%if(e_bean.getCar_comp_id().equals("0056")) {%>(테슬라차량 제외)<%}%><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24시간 이상 정비공장 입고시)<br> 		                  		
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - 대여 개시 2개월 이후<%}else{%>&nbsp;&nbsp;&nbsp;&nbsp; - <%}%> 원가 수준의 유상 정비대차 제공<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (단기 대여요금의 15~30% 수준, 탁송료 별도)</td>
		                   		<td width=279 bgcolor=#FFFFFF align=left>&nbsp; <span class=style3><b>* 일체의 정비서비스</b></span><br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 각종 내구성부품/소모품 점검, 교환, 수리<br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 제조사 차량 취급설명서 기준<br>
		                   		&nbsp; <span class=style3><b>* 정비대차서비스</b></span><br> 
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 4시간 이상 정비공장 입고시</td>
		                 	</tr>
		         		</table>
		         	</td>
		        </tr>
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          
          <!--출고전대차-->
          <%if(e_bean.getEst_from().equals("tae_car")){%>
          
          		<tr> 
		            <td colspan="2">
<!-- 		            <img src=../main_car_hp/images/bar_07_dc.gif width=638 height=22> -->
		            <div class='esti-title'>
						<span class='esti-num'>0<%=++esti_num%></span>
						출고전 신차 대여 계약 해지시 요금 정산
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
		            			<td height=40 bgcolor=ffffff>
		            				<!-- &nbsp;&nbsp;&nbsp;위 대여요금은 신차 대여 계약이 정상적으로 진행 됐을 경우 적용되는 할인 요금입니다.<br>
		            				&nbsp;&nbsp;&nbsp;출고전 신차 대여 계약 해지시 월렌트 정상요금으로 정산청구되며, 차량 인도/회수 탁송료도 정산 청구됩니다. -->
		            				<%
		            				Hashtable taeCarHt = shDb.getTaeCarRmAmt(est_id);
		            				int tae_car_fee_s_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("FEE_S_AMT"))); //출고전대차정상요금
		            				int tae_car_fee_v_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("FEE_V_AMT"))); //출고전대차정상요금 부가세
		            				int tae_car_fee_t_amt = tae_car_fee_s_amt + tae_car_fee_v_amt; //출고전대차정상요금 부가세 합산 금액
		            				int tae_car_r_rm_fee_s_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("R_RM_FEE_S_AMT"))); //출고전대차견적 계약해지 요금 (월렌트요금+출고전대차지점간이동탁송료+출고전대차선수금이자효과)
		            				int rm_fee_s_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("RM_FEE_S_AMT"))); // 월렌트견적 정상요금
		            				%>
		            				<%if (rm_fee_s_amt <= 0) { // 2021.01.13. 추가. 월렌트정상요금이 0 이하일 때 %>
		            				&nbsp;&nbsp;&nbsp;위 대여요금은 신차 대여 계약이 정상적으로 진행 됐을 경우 적용되는 할인 요금입니다.<br>
									&nbsp;&nbsp;&nbsp;출고전 신차 대여 계약 해지시 월렌트 정상요금으로 정산 청구되며, 차량 인도/회수 탁송료[탁송 구간별 탁송료 상이, 예)서울↔서울: 왕복 44,000원(부가세포함)] 실비용도 정산 청구됩니다.
		            				<%} else {%>
			            				<%if (tae_car_fee_t_amt < tae_car_r_rm_fee_s_amt) { // 출고전대차요금 < 월렌트정상요금(지점간이동탁송료포함, 보증금이자효과 감안) %>
			            				&nbsp;&nbsp;&nbsp;위 대여요금은 신차 대여 계약이 정상적으로 진행 됐을 경우 적용되는 할인 요금입니다.<br>
										&nbsp;&nbsp;&nbsp;출고전 신차 대여 계약 해지시 월렌트 정상요금[<%=AddUtil.parseDecimal(tae_car_r_rm_fee_s_amt)%>원 (부가세포함)]으로 정산 청구되며,<br>
										&nbsp;&nbsp;&nbsp;차량 인도/회수 탁송료[탁송 구간별 탁송료 상이, 예)서울↔서울: 왕복 44,000원(부가세포함)] 실비용도 정산 청구됩니다.
			            				<%}%>
			            				<%if (tae_car_fee_t_amt >= tae_car_r_rm_fee_s_amt) { // 출고전대차요금 >= 월렌트 정상요금(지점간이동탁송료포함, 보증금이자효과 감안) %>
										&nbsp;&nbsp;&nbsp;출고전 신차 대여 계약 해지시 차량 인도/회수 탁송료[탁송 구간별 탁송료 상이, 예)서울↔서울: 왕복 44,000원(부가세포함)] 실비용이 정산 청구됩니다.
			            				<%}%>
		            				<%}%>
		            			</td>
		            		</tr>
		            	</table>
		            </td>
				</tr>				
        <%}%>
				<tr> 
		            <td height=10 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2">
		            	<%-- <%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
		            		<%if(!e_bean.getEst_from().equals("tae_car")){%>
		            			<img src=../main_car_hp/images/bar_2022_09.jpg width=638 height=22>
							<%} else{	%>
								<img src=../main_car_hp/images/bar_08.gif width=638 height=22>
							<%} %>
		            	<%}else{%>
		            		<%if(!e_bean.getEst_from().equals("tae_car")){%>
		            		<img src=../main_car_hp/images/bar_08.gif width=638 height=22>
							<%} else{%>
								<img src=../main_car_hp/images/bar_07.gif width=638 height=22>
							<%} %>
		            	<%	}%> --%>
		            	<div class='esti-title'>
							<span class='esti-num'>0<%=++esti_num%></span>
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
			                  	<td width=28 height=17 align=right><img src=../main_car_hp/images/1.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=593 colspan=2 align=left class=listnum2>자동차세 납부, 정기검사 
			                    등도 아마존카에서 처리(고객 비용 부담 없음)</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=../main_car_hp/images/2.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>홈페이지에서 대여차량 유지관리내역 정보제공 [FMS(Fleet Management System)]</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=../main_car_hp/images/3.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>대여기간 만료시에는 반납, 연장이용<%if((e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")) /* && !cm_bean.getDiesel_yn().equals("2") */ && AddUtil.parseInt(e_bean.getA_b()) >= 24){//기본식 && 비LPG && 24개월이상 %>, 매입옵션 행사<%}%> 중 선택 가능</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("21")){%>
			                <!-- <tr> 
			                  	<td height=17 align=right><img src=../main_car_hp/images/4.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>계약기간 동안 
			                    아래금액의 이행(지급)보증보험 가입조건(신용우수업체 면제)</td>
			                </tr> -->
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td colspan=4 height=3></td>
			                </tr>
			                <%-- <%if (e_bean.getGi_fee() > 0) {%>
							<tr>
								<td colspan=4 align=right style="font-weight: bold;">※ 신용등급 <%=e_bean.getGi_grade()%>등급기준</td>
							</tr>
							<%}%> --%>
			                <%-- <tr> 
			                  	<td height=24>&nbsp;</td>
			                  	<td>&nbsp;</td>
			                  	<td width=17><img src=../main_car_hp/images/arrow_1.gif width=10 height=6>&nbsp;</td>
			                  	<td width=569 align=left> 
			                  		<table width=569 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/img_bg.gif>
				                      	<tr> 
				                        	<td colspan=3><img src=../main_car_hp/images/img_up.gif width=569 height=5></td>
				                      	</tr>
				                     	<tr> 
				                        	<td width=15 height=15>&nbsp;</td>
				                        	<td width=270><img src=../main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
				                          	<span class=style12>보증보험 가입금액</span><span class=style13> 
				                          	|</span> <span class=style4><%=AddUtil.parseDecimal(e_bean.getGi_amt())%> 원</span></td>
				                        	<td width=284>
				                        		<img src=../main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
				                          		<span class=style12>보증보험료(<%=e_bean.getA_b()%>개월치)</span>
				                          		<span class=style13>|</span>
				                          		&nbsp;<span class=style4>
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
				                        	<td colspan=3><img src=../main_car_hp/images/img_dw.gif width=569 height=5></td>
				                      	</tr>
			                    	</table>
			                    </td>
			                </tr> --%>
			                <%-- <%if (e_bean.getGi_amt() > 0) {%>
						  	<tr>
								<td colspan=4 align=right>※ 신용등급별로 보증보험료가 달라집니다.</td>
						  	</tr>
						  	<%}%> --%>
			                <%}%>
		              	</table>
					</td>
				</tr>
          <tr> 
            <td height=3 colspan="2"></td>
          </tr>
          <tr> 
            <td align=right><img src=../main_car_hp/images/ceo.gif>&nbsp;</td>
            <td align=right>&nbsp;&nbsp;</td>
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
            <table width=638 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img.gif>
                <tr>
                    <td colspan=2 align=left background=../main_car_hp/images/p_up_img.gif height=24>
                        <table width=638 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약준비서류 (법인)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width=10>&nbsp;</td>
                    <td width=628  align=left>
                        <table width=628 border=0 cellspacing=0 cellpadding=0>
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
                                    <table width=610 border=0 cellspacing=0 cellpadding=0 align=center>
                                        <tr>
                                            <td width=115 style="font-size:11px;" valign=top><span class=style4>1.대표이사 자필 서명시:</span></td>
                                            <td style="font-size:11px;">
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
                                       <table width=610 border=0 cellspacing=0 cellpadding=0 align=center>
                                        <tr>
                                            <td width=135 style="font-size:11px;" valign=top><span class=style4>2.대표이사 자필 서명 불가시:</span></td>
                                            <td style="font-size:11px;">
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
                                <td colspan=2>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>신용심사 참고서류 : </span>  &nbsp;&nbsp;<span class=style4>재무제표(대차대조표, 손익계산서 등) &nbsp;&nbsp;※ 필요시 연대보증인(대표이사)의 주민등록등본</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=2><img src=../main_car_hp/images/p_dw_img.gif></td>
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
            <table width=638 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img.gif height=24>
                        <table width=638 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약준비서류 (개인사업자)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50 width=15>&nbsp;</td>
                    <td width=608 align=left>
                        <table width=608 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=8></td>
                            </tr>
                            <tr>
                                <td width=88 valign=top>&nbsp;<img src=/acar/main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>제출서류 :</span></td>
                                <td width=540>
                                    <table width=540 border=0 cellspacing=0 cellpadding=0>
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
	                                <span class=style12>신용심사 참고서류 :&nbsp;&nbsp;</span> 
	                                <span class=style4 style="font-size:11px;">
	                                	매출증빙자료(부가가치세과세표준증명서 등) &nbsp;&nbsp;
	                                	<br><span style='margin-left: 100px;'>※ 신용 심사에 필요할 경우 주민등록등본 제출을 요청할 수 있습니다.</span>
	                                </span>
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
                    <td colspan=3><img src=../main_car_hp/images/p_dw_img.gif></td>
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
            <table width=638 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img.gif height=24>
                        <table width=638 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약준비서류 (개인)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50 width=15>&nbsp;</td>
                    <td width=608 align=left>
                        <table width=608 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=8></td>
                            </tr>
                            <tr>
                                <td width=93>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>제출서류 :</span></td>
                                <td width=535>
                                    <table width=525 border=0 cellspacing=0 cellpadding=0>
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
                                <td colspan=2>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>신용심사 참고서류 :</span> &nbsp;&nbsp;&nbsp;<span class=style4>재직증명서, 소득증빙자료(원천징수영수증 등)<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;※ 신용 심사에 필요할 경우 주민등록등본 제출을 요청할 수 있습니다.</span></td>
                            </tr> 
                        </table>
                    </td>
                    <td width=15>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan=3><img src=../main_car_hp/images/p_dw_img.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>	
	<%}%>
	<!--필요서류표기 end-->	
	<%if(!select_print_yn.equals("Y")){ %>	
    <tr id='esti_button_tr'>
        <td align=center colspan=3>
		      <a id='esti_print' href=javascript:go_print('<%= est_id %>'); title='견적서 프린트 하기'><img src=../main_car_hp/images/button_print.gif border=0></a>&nbsp;&nbsp;
  		    <a id='esti_mail' href=javascript:go_mail('<%= est_id %>'); title='견적서 메일 발송하기'><img src="../main_car_hp/images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;	
			    <a id='esti_sms' href=javascript:esti_result_sms('<%= est_id %>'); title='결과 문자 발송하기'><img src="../main_car_hp/images/button_sms.gif" border=0></a>&nbsp;&nbsp;
		      <%if(e_bean.getDoc_type().equals("")){%>
		      <a id='esti_paper' href="javascript:go_paper();" title='계약준비서류보기'><img src=../main_car_hp/images/button_paper.gif border=0></a>
		      <%}%>
		    </td>
    </tr>
    <% } %>
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