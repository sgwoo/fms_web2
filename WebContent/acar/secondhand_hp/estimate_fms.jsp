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
		if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){		//FMS �縮�������������� �⺻������/����������
			est_id = shDb.getSearchEstId(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
			page_kind = "fms";
		}else{									//Ȩ������ �縮������ ������
			est_id = shDb.getSearchEstIdSh(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
			page_kind = "homepage";
		}
	}
	

	if(est_id.equals("")){
		out.println("�������� ��ã�ҽ��ϴ�.");
		return;
	}
	
	//��������
	EstimateBean e_bean = new EstimateBean();
	
	//�ܰ� ��������
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
	
	
	//��������
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
	//�����ڵ庯��
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());		
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);
	
	//��������
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
	//������� ����Ⱓ2(���ɸ�����2����������)
	if(!String.valueOf(ht.get("CAR_END_DT")).equals("") && AddUtil.checkDate(init_reg_dt)){	
		Hashtable carOld4 	= c_db.getOld(init_reg_dt, AddUtil.getDate(4), ""); //����
		car_use_mon = (AddUtil.parseInt(String.valueOf(carOld4.get("YEAR")))*12) + AddUtil.parseInt(String.valueOf(carOld4.get("MONTH")));
	}
	
	String min_use_mon		= "6";
	if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){
		min_use_mon		= "12";
		//���������� ���� �뵵����� (���������ϰ� 24���� �̻� ������ �ǵ���)
		if(AddUtil.parseInt(jg_code) > 2000 && AddUtil.parseInt(jg_code) < 9999 && car_use.equals("1")){
			min_use_mon		= "24";
		}
		//���������� ���� �뵵����� (���������ϰ� 24���� �̻� ������ �ǵ���)
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
	if(e_bean.getEst_st().equals("3") && car_amt == 0) stat = "�������ݺҸ�";
	if(e_bean.getEst_st().equals("3") && AddUtil.parseInt((String)ht.get("O_L")) == 0) stat = "�߰���������";
	
	//�ܰ� ��������
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
	
	//��ȿ�Ⱓ
	String vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 4));
	
	
	
		
	
	//����ó----------------------------------------------------------------
	
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
	

	if(e_bean.getMgr_ssn().equals("�������") && !e_bean.getEst_from().equals("ext_car")){
	
		//���⺻����
		base = a_db.getCont(e_bean.getRent_mng_id(), e_bean.getRent_l_cd());

	  if(!e_bean.getEst_tel().equals("")){
			user_bean 	= umd.getUsersBean(e_bean.getEst_tel());
		}else{
			user_bean 	= umd.getUsersBean(base.getBus_id2());
		}
				
		//������
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

	if(name.equals("�ڱԼ�")) name = "�ּ���";
	
	if(user_bean.getDept_id().equals("1000") && e_bean.getEst_st().equals("2")){
		vali_date = "��Ȯ�� ����";
	}
	
	int esti_num = 0;
%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>������</title>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
$(document).ready(function(){	
	var contiRatDesc = $('#contiRatDesc').text();
	var point = contiRatDesc.indexOf("(");
	if(point >= 0){
		$('#contiRatDesc').text(contiRatDesc.substring(0,point) + "(���տ������)");
	}else{
		$('#contiRatDesc').text(contiRatDesc + "(���տ������)");
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
	//�μ��ϱ�
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
	
	//���Ϲ߼��ϱ�
	function go_mail(est_id){	
		var SUBWIN="/acar/apply/mail_input.jsp?from_page=<%=from_page%>&est_id=<%=est_id%>&write_id=<%=e_bean.getReg_id()%>&acar_id=<%=acar_id%>&opt_chk=<%=opt_chk%>&fee_opt_amt=<%=fee_opt_amt%>&est_email=<%=e_bean.getEst_email()%>&est_m_tel=<%=e_bean.getEst_tel()%>&content_st=sh_fms";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=600, scrollbars=no, status=yes");
	}

	//������ڹ߼�
	function esti_result_sms(est_id){	
		var SUBWIN="/acar/apply/sms_input.jsp?from_page=<%=from_page%>&est_id=<%=est_id%>&write_id=<%=e_bean.getReg_id()%>&acar_id=<%=acar_id%>&opt_chk=<%=opt_chk%>&fee_opt_amt=<%=fee_opt_amt%>&est_email=<%=e_bean.getEst_email()%>&est_m_tel=<%=e_bean.getEst_tel()%>&content_st=sh_fms";	
		window.open(SUBWIN, "openSMS", "left=100, top=100, width=420, height=600, scrollbars=no, status=yes");
	}
	
	//�غ񼭷�����
	function go_paper(){
		var SUBWIN="/acar/main_car_hp/papers.html";	
		window.open(SUBWIN, "openpaper", "left=50, top=50, width=700, height=770, status=no, scrollbars=no, resizable=no");
	}		
	
	//�⺻��纸���ֱ�
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
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>�ۼ���</span></td>
                                <td width=97 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>��ȿ�Ⱓ</span></td>
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
						                [ ��������� ]
						              <%}else{%>  
                        	  [ <%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%> ]
                            <%if(e_bean.getEst_from().equals("res_car")){%>
	  					                - �Ϲݴ���
                            <%}else if(e_bean.getEst_from().equals("emp_car")){%>
			  			                - �������� ������
						                <%}else{%>
						                  <%if(e_bean.getEst_st().equals("1")){%>- ������<%if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){%>�縮��<%}else{%>�緻Ʈ<%}%>
						                  <%}else if(e_bean.getEst_st().equals("2")){%>- ������
						                  <%}else if(e_bean.getEst_st().equals("3")){%>- �߰��� ����
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
                        <td colspan=3><div align="left"><span class=style2><%=e_bean.getEst_nm()%>��
                            <%if(client_st.equals("2")){%>����<%}else{%>����<%}%></span></div></td>
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
				<%if(stat.equals("�������ݺҸ�")){%>
                <tr> 
                  <td colspan="3" height="17">&nbsp;�� �� ������ ������ ���������̸�, ���������� Ȯ�εǾ�� Ȯ�������� ���õ˴ϴ�.</td>
                </tr>
				<%}	else if(stat.equals("�߰���������")){%>
                <tr> 
                  <td colspan="3" height="17">&nbsp;�� �� ������ ������ ���������̸�, �߰��������� �����εǾ�� Ȯ�������� ���õ˴ϴ�.</td>                
				</tr>
				<%}else{%>
                <tr> 
                  <td colspan="3" height="17">&nbsp;�� �ͻ翡�� �����Ͻ� ���뿩�� ���Ͽ� �Ʒ��� ���� ������ �����Ͽ��� 
                    �����Ͻð� ���� �亯 ��Ź�帳�ϴ�.</td>
                </tr>
				<%}%>
              </table></td>
          </tr>
          <tr> 
            <td height=10 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2">
            <%if(e_bean.getAccid_serv_zero().equals("Y")){//�����������%>
<!--             <img src=../main_car_hp/images/bar_01_msg.gif> -->
            <div class='esti-title'>
            	<span class='esti-num'>0<%=++esti_num%></span> 
            	�뿩����
            	<sapn class='esti-title-sub'>(�� ������ �ƴ�: �� ������ �� ������ ������� ��츦 �����Ͽ� ������ ���Դϴ�)</sapn>
            </div>
            <%}else{%>
<!--             <img src=../main_car_hp/images/bar_01.gif> -->
            <div class='esti-title'><span class='esti-num'>0<%=++esti_num%></span> �뿩����</div>
            <%}%>
            </td>
          </tr>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=132 height=17 align=center bgcolor=f2f2f2><span class=style3>������</span></td>
                  <td width=388 bgcolor=#FFFFFF>&nbsp;<span class=style4><%= c_db.getNameById(car_comp_id, "CAR_COM") %></span></td>
                  <td width=114 align=center bgcolor=f2f2f2><span class=style3>�� 
                    ��</span></td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>����(�����𵨸�)</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(est_id.length() > 0){%><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=car_name%></a><%}else{%><%=car_name%><%}%></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%if(stat.equals("�������ݺҸ�")){%>��Ȯ��<%}else{%><%= AddUtil.parseDecimal(e_bean.getCar_amt()) %>
                    ��<%}%></span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                    ��</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(est_id.length() > 0){%><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=opt%></a><%}else{%><%=opt%><%}%></span>
                      <%if(car_mng_id.equals("018647")){%>(���� �ǸŵǴ� �����̾� ���� ������ ����)<%}%>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getOpt_amt()) %>
                    ��</span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� �� </span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(!e_bean.getIn_col().equals("")){%>����: <%}%><%=colo%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;����: <%=e_bean.getIn_col()%><%}%></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getCol_amt()) %>
                    ��</span>&nbsp;</td>
                </tr>
                <%if(!e_bean.getConti_rat().equals("")){%>
                <tr>
                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� �� </span></td>
                    <td bgcolor=#FFFFFF>
                    	<span id="contiRatDesc">
                    		&nbsp;<%=e_bean.getConti_rat()%>
                    	</span>
                    </td>
                    <td bgcolor=#FFFFFF></td>
                </tr>
                <%}%>
                <!-- ���� ���Ҽ� ���� �߰�(2017.10.13) -->
                <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
                <tr>
                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���� ���Ҽ� ���� </span></td>
                    <td bgcolor=#FFFFFF>
                    </td>
                    <td align=right bgcolor=#FFFFFF><span class=style4> - <%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> ��</span>&nbsp;</td>
                </tr>
                <%}%>
                
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>������
                   </span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7>��������� : <%=AddUtil.ChangeDate2(init_reg_dt)%> (�𵨿���:<%=car_y_form%>)
                  	<%if(!e_bean.getTot_dt().equals("") && (e_bean.getEst_from().equals("tae_car") || e_bean.getEst_from().equals("secondhand"))){//�縮��,���������%>
                  		<br>&nbsp;����Ÿ� : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km (Ȯ������:<%=AddUtil.ChangeDate2(e_bean.getTot_dt())%>)
                  	<%}else{%>
                  		&nbsp;&nbsp;����Ÿ� : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km	
                  	<%}%>
                  	</span>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style4>-<%if(stat.equals("�������ݺҸ�") || stat.equals("�߰���������")){%>##,###,###<%}else{%><%= AddUtil.parseDecimal(dlv_car_amt) %><%}%>
				    ��</span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=20 align=center bgcolor=f2f2f2><span class=style3>��������</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7>������ȣ : <%if(!car_no.equals("")){ out.println("****"+car_no.substring(car_no.length()-4, car_no.length())); } %>
                      </span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style6><%if(stat.equals("�߰���������")){%>�̰���<%}else{%><%=AddUtil.parseDecimal(e_bean.getO_1())%> 
                    ��<%}%></span>&nbsp;</td>
                </tr>
              </table></td>
          </tr>		  
          <tr> 
		 	<td height=10 colspan="2">
		   		<table width=638 border=0 cellpadding=0 cellspacing=1>
		        	<tr>
		        		<td>
			        	<%if(!e_bean.getEst_from().equals("res_car") && !e_bean.getEst_from().equals("emp_car") && !e_bean.getEst_from().equals("tae_car") && e_bean.getEst_st().equals("1") && !e_bean.getA_a().equals("")){%>
			          		�� ����, ���ӱ� : 2����/5,000Km ǰ������<span style="font-size:10px;">(�Ⱓ �Ǵ� ����Ÿ� �� ���� ������ ���� �����Ⱓ ����� ����)</span>			          				          		
			          	<%}%>
			          	<%if (e_bean.getBr_to_st().equals("0")) {%>
		          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : ������</p>
		          		<%} else if (e_bean.getBr_to_st().equals("1")) {%>
		          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : ����/����/�泲/���</p>
		          		<%} else if (e_bean.getBr_to_st().equals("2")) {%>
		          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : �뱸/���</p>
		          		<%} else if (e_bean.getBr_to_st().equals("3")) {%>
		          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : ����/����/����</p>
		          		<%} else if (e_bean.getBr_to_st().equals("4")) {%>
		          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : �λ�/���/�泲</p>
		          		<%} else if (e_bean.getBr_to_st().equals("5")) {%>
		          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : ����</p>
		          		<%}%>
		          		</td>
			            <td height=10 align="right">
						<%if(cm_bean.getJg_code().equals("1232") || cm_bean.getJg_code().equals("1242") || cm_bean.getJg_code().equals("1021212") || cm_bean.getJg_code().equals("1023112")){//��׹���ǻ��,����%>
									�� LPG/�ֹ��� �����
						<%}else{%>						
						<%	if(String.valueOf(sh_comp.get("ENGIN")).equals("Y")){%>		�� ��������
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("2")){%>	�� LPG������
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("1")){%>	�� ���ָ�����
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("3")){%>	�� ���̺긮��
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("4")){%>	�� �÷����� ���̺긮��
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("5")){%>	�� ������
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("6")){%>	�� ������
						<%	}else{%>
							<%if(cm_bean.getDiesel_yn().equals("Y")){%>			�� ��������
							<%}else if(cm_bean.getDiesel_yn().equals("2")){%>		�� LPG������
							<%}else if(cm_bean.getDiesel_yn().equals("1")){%>		�� ���ָ�����
							<%}else if(cm_bean.getDiesel_yn().equals("3")){%>		�� ���̺긮��
							<%}else if(cm_bean.getDiesel_yn().equals("4")){%>		�� �÷����� ���̺긮��
							<%}else if(cm_bean.getDiesel_yn().equals("5")){%>		�� ������
							<%}else if(cm_bean.getDiesel_yn().equals("6")){%>		�� ������
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
          	<td colspan="2" bgcolor=f2f2f2 height=45><span class=style4> * �� ������ ����� ��ȯ �̷�(<%=AddUtil.getDate3(cha_st_dt)%>)�� �ִ� �������� ����� ��ȯ�� ����Ÿ��� <%=AddUtil.parseDecimal(b_dist)%>km, ��ȯ�� �� ���<br>
          	&nbsp; ���� ����Ÿ��� <%=AddUtil.parseDecimal(AddUtil.parseInt(today_dist)-AddUtil.parseInt(b_dist))%>km�Դϴ�. ������ ���ÿ��� ����Ÿ��� <%=AddUtil.parseDecimal(today_dist)%>km�� �����ϰ�, �������� ���� �ü��϶���<br>
          	&nbsp; �ݿ��Ͽ����ϴ�.</span></td>
          </tr>
          <%}%>
		
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          
          <!-- ����������� ���� ��������Ÿ� �׸� �����Ű�� ����. -->
          <%if(!e_bean.getEst_from().equals("tae_car")){%>
          <tr> 
             <td height=10 colspan="2"></td>
          </tr>
          <tr> 
            	<td colspan="2">
<!--             		<img src=../main_car_hp/images/bar_2022_04.jpg width=638 height=22> -->
            		<div class='esti-title'>
						<span class='esti-num'>0<%=++esti_num%></span>
						��������Ÿ� 
						<sapn class='esti-title-sub'>(��������Ÿ� ���� ����� ȯ�޴뿩�� ����)</sapn>
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
	            			<td align=center bgcolor=f2f2f2 height=17 rowspan=3 width=75><span class=style3>��������Ÿ�</span></td>
	            			<td bgcolor=ffffff rowspan=3 align=center width=110><span class=style6><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km���� / 1��</span>
	            				<%if(!e_bean.getEst_st().equals("2") && AddUtil.parseInt(e_bean.getA_b()) <12){
            						String agree_dist_m = AddUtil.parseFloatNotDot2(AddUtil.parseFloat(String.valueOf(e_bean.getAgree_dist()))/(12/AddUtil.parseFloat(e_bean.getA_b())));
            						
            				%>	            				
            				<br>
            				<span style="font-size:11px;">��<%=AddUtil.parseDecimal(agree_dist_m)%>km���� / <%=e_bean.getA_b()%>����</span>
            				<%}%>
	            			</td>
	            			<td align=center bgcolor=f2f2f2 height=17 rowspan=3 width=75>
	            				<span class=style3>��������Ÿ���<br>���� ����</span>
	            			</td>
	            			<td bgcolor=f2f2f2 height=17> 
	            			  &nbsp;&nbsp; <b>(�������Ͽ����) ȯ�޴뿩��</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	            			  <%if(e_bean.getRtn_run_amt_yn().equals("1")){ // ȯ�޴뿩�� ������%>
		            			  	������
		            			  <%} else{%>
		            			  	<%=e_bean.getRtn_run_amt()%>��/1km	(�ΰ�������)
		            			  <%} %>
	            			</td>
	            		</tr>
	            		<tr>
	            			<td bgcolor=f2f2f2 height=17>
	            			  &nbsp;&nbsp; <b>(�����ʰ������) �ʰ�����뿩��</b>&nbsp;&nbsp;&nbsp;&nbsp;<%=e_bean.getOver_run_amt()%>��/1km	(�ΰ�������)
	            			</td>
	            		</tr>
	            		<tr>
	            			<td bgcolor=ffffff height=17>
	            			  &nbsp;
	            			  	<%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
		            			  	<% if(AddUtil.parseInt(e_bean.getA_b()) >= 24){ %>	
		            			  		���Կɼ� ���ÿ��� (�������Ͽ����) ȯ�޴뿩�ᰡ ���޵��� �ʰ�, (�����ʰ������) �ʰ�����뿩�ᰡ �����˴ϴ�. (�⺻��)
		            			  	<%}%>
	            			  	<%}%>
	            			</td>
	            		</tr>
	            		
	            	</table>
	            </td>
			</tr>				

				<%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20150217 && !e_bean.getEst_st().equals("2")){%>
	                  <tr> 
			    	<td colspan=2 height=22>&nbsp;<span class=style3>* ��������Ÿ��� ���̸� �뿩����� ���ϵǰ�, ��������Ÿ��� �ø��� �뿩����� �λ�˴ϴ�.</span></td>
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
					�뿩��� 
					<sapn class='esti-title-sub'>(����� ����)</sapn>
					</div>
                  <%}else{%>
<!--                   <img src=/acar/main_car_hp/images/bar_02_1.gif width=208 height=22> -->
                  <div class='esti-title'>
						<span class='esti-num'>0<%=++esti_num%></span>
						�뿩��� 
						<sapn class='esti-title-sub'>(����� ������)</sapn>
					</div>
                  <%}%>
                  </td>
                  <td width=30>&nbsp;</td>
                  <td width=400>
<!--                   <img src=../main_car_hp/images/bar_03.gif width=400 height=22> -->
                  <div class='esti-title'>
						<span class='esti-num'>0<%=++esti_num%></span>
						���躸�����
					</div>
                  </td>
                </tr>
                <tr> 
                  <td height=4 colspan=3></td>
                </tr>
                <tr> 
                  <td> <table width=208 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                      <tr> 
                        <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>�뿩�Ⱓ</span></td>
                        <td width=113 align=right bgcolor=#FFFFFF><span class=style4><%if(e_bean.getEst_from().equals("res_car")){%>1��<%}else{%><%=e_bean.getA_b()%>����<%}%></span>&nbsp;</td>
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
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                          �� �� </span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(fee_s_amt)%> 
                          ��</span>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                          �� �� </span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(fee_v_amt)%> 
                          ��</span>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>���뿩��</span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style6><%=AddUtil.parseDecimal(fee_t_amt)%> 
                          ��</span>&nbsp;</td>
                      </tr>
                    </table></td>
                  <td>&nbsp;</td>
                  <td> 
				  <%if(!e_bean.getIns_per().equals("2")){%>
				  <table width=400 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                      <tr> 
                        <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>���ι��</span></td>
                        <td width=106 align=center bgcolor=#FFFFFF><span class=style4>����(���� 
                          ��,��) </span></td>
                        <td width=92 align=center bgcolor=f2f2f2><span class=style3>������������</span></td>
                        <td width=105 align=center bgcolor=#FFFFFF><span class=style4>1�δ� 
                          �ְ� 2��� </span></td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�빰���</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5õ����<%}else if(e_bean.getIns_dj().equals("4")){%>2���<%}else if(e_bean.getIns_dj().equals("8")){%>3���<%}else if(e_bean.getIns_dj().equals("3")){%>5���<%}else{%>1���<%}%></span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>�����ڿ���</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean.getIns_age().equals("3")){%>��24���̻�<%}else{%>��26���̻�<%}%></span></td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�ڱ��ü���</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5õ����<%}else{%>1���<%}%></span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>����⵿</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>����</span></td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>������å��</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>��</span></td>
                        <%if (e_bean.getDoc_type().equals("")) {%>
                        <td align=center bgcolor=f2f2f2 colspan="2"></td>
                        <%} else {%>
                        <td align=center bgcolor=f2f2f2><span class=style3>�����ڹ���</span></td>
                        <td align=center bgcolor=#FFFFFF>
						<%if (e_bean.getDoc_type().equals("1") || e_bean.getDoc_type().equals("2")) {%>
							<%if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000 && e_bean.getCom_emp_yn().equals("Y")) {%>
							<span class=style4>����������</span>
							<%} else if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000000 && e_bean.getCom_emp_yn().equals("Y")) {%>
                       	  	 <span class=style4>����������</span>
                       		<%} else {%>
							<span class=style4>�������� ���谡��</span>
							<%}%>
						<%-- <%} else if (e_bean.getDoc_type().equals("2")) {%>
							<span class=style4>�������� ���谡��</span> --%>
						<%} else if (e_bean.getDoc_type().equals("3")) {%>
							<span class=style4>����� �� ���谡��</span>
						<%}%>
                        </td>
                        <%}%>
                      </tr>
                    </table>
					<%}else{%>
				  <table width=400 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                      <tr> 
                        <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>���ι��</span></td>
                        <td width=106 align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
                        <td width=92 align=center bgcolor=f2f2f2><span class=style3>������������</span></td>
                        <td width=105 align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�빰���</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>�����ڿ���</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�ڱ��ü���</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>����⵿</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>������å��</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
                        <td align=center bgcolor=f2f2f2>&nbsp;</td>
                        <td align=center bgcolor=#FFFFFF>&nbsp;</td>
                      </tr>
                    </table>
					<%}%>					
				  </td>
                </tr>
                
                <%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && e_bean.getA_a().equals("12")) {%>
	            <tr>
					<td colspan="3" align="right">�� �������� �Ƹ���ī ���� ������忡�� ����</td>
	            </tr>
	            <%}%>
                
                <%if(e_bean.getEst_from().equals("tae_car")){%>
                <tr> 
                  <td height=15 colspan=3 class=listnum2>&nbsp;<span class=style3>* ���� ��� ��������Ÿ� : <%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km����/1��</span></td>
                </tr>
                <%}else{%>
                <tr> 
                  <td height=15 colspan=3 class=listnum2>&nbsp;<span class=style3>* �� ������ �뿩�Ⱓ�� <%=min_use_mon%>����~<%=max_use_mon%>���� ���� ��� ���������� ���ð����մϴ�.</span></td>
                </tr>
                <%}%>
                
        		<!--��ǰ-->
        		<%if(e_bean.getTint_b_yn().equals("Y") || e_bean.getTint_s_yn().equals("Y")|| e_bean.getTint_n_yn().equals("Y")|| e_bean.getTint_eb_yn().equals("Y")){
        				String tint_all = "";
        				if(e_bean.getTint_b_yn().equals("Y")){	tint_all +="1";	}		//2ä�� ���ڽ�
        				if(e_bean.getTint_s_yn().equals("Y")){	tint_all +="2";	}		//���� ����
        				if(e_bean.getTint_n_yn().equals("Y")){	tint_all +="3";	}		//��ġ�� ������̼�
        				if(e_bean.getTint_eb_yn().equals("Y")){	tint_all +="4";	}		//�̵��� ������ �뿩���
        		%>                        
                        <tr> 
			    			<td colspan=3 class=listnum2 valign=top>&nbsp;<span class=style3>* 
                            	<%if(tint_all.equals("1")){%>�� �뿩����� 2ä�� ���ڽ��� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("2")){%>�� �뿩����� ���� ������ ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("3")){%>�� �뿩����� ��ġ�� ������̼��� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("4")){%>�� �뿩����� �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("12")){%>�� �뿩����� 2ä�� ���ڽ��� ���� ������ ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("13")){%>�� �뿩����� 2ä�� ���ڽ��� ��ġ�� ������̼��� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("14")){%>�� �뿩����� 2ä�� ���ڽ��� �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("23")){%>�� �뿩����� ���� ���ð� ��ġ�� ������̼��� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("24")){%>�� �뿩����� ���� ���ð� �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("34")){%>�� �뿩����� ��ġ�� ������̼ǰ� �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("123")){%>�� �뿩����� 2ä�� ���ڽ�, ���� ����, ��ġ�� ������̼��� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("124")){%>�� �뿩����� 2ä�� ���ڽ�, ���� ����, �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("134")){%>�� �뿩����� 2ä�� ���ڽ�, ��ġ�� ������̼�, �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("234")){%>�� �뿩����� ���� ����, ��ġ�� ������̼�, �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                            	<%if(tint_all.equals("1234")){%>�� �뿩����� 2ä�� ���ڽ�, ���� ����, ��ġ�� ������̼�, �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>    
                                </span>
                            </td>
                        </tr>                        
                        <%}%>               
                                        
				<%if(AddUtil.parseInt(cm_bean.getJg_code()) < 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000)){%>

                <tr> 
					<td height=20 colspan=3 class=listnum2>&nbsp;<span class=style8>* �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� <strong>���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.</strong>
					</span></td>
                </tr>
				<%}%>	
				<%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%>			
                <tr> 
					<td height=20 colspan=3 class=listnum2>&nbsp;<span class=style8>* �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� <strong>���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.</strong>
					</span></td>
                </tr>
				<%}%>	
				<%if(e_bean.getEst_from().equals("emp_car")){%>				
                <tr> 
					<td height=20 colspan=3 class=listnum2>&nbsp;
						<span class=style8>
							<%if(AddUtil.parseInt(e_bean.getRent_dt()) < 20110331){%>
							�� ���� ���밪�� [���� ���� ���ް� * 85% -10����]���� ��. (���ٰ����󰢵� ��Ÿ ���� ���� ���� �� �޿������� �ݿ�)
							<%}else{%>
							�� ���밪�� ���ް�
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
            <%-- <%if(!e_bean.getEst_from().equals("tae_car")){ // ��������� �ƴ� ��%>
            	<img src=../main_car_hp/images/bar_2022_05.jpg width=638 height=22>
            <%} else{		// ���������%>
            	<img src=../main_car_hp/images/bar_04.gif width=638 height=22>
            <%} %> --%>
            <div class='esti-title'>
				<span class='esti-num'>0<%=++esti_num%></span>
				�ʱⳳ�Ա�
			</div>
            </td>
          </tr>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=75 height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                    �� ��</span></td>
                  <td width=93 align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getGtr_amt())%> 
                    ��</span>&nbsp;</td>
                  <td width=82 align=center bgcolor=f2f2f2><span class=style3>������ <%=e_bean.getRg_8()%>%</span></td>
                  <td width=383 bgcolor=#FFFFFF>&nbsp;<span class=style4>�������� 
						  	���Ⱓ ���� �� ȯ���� �帳�ϴ�. <!-- ��������϶��� �����ּ���-->[������ 100������ �����ϸ�,<br>&nbsp;���뿩�� 5,500��(VAT����)�� ���ϵ˴ϴ�.(�⸮6.6%ȿ��)]<!-- ��������϶��� �����ּ���--></span></td>
				</tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                    �� ��</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%> 
				    ��</span>&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style4>VAT����</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- ����������� ����ǥ��X(2018.03.29) -->
                  	<span class=style4>�������� �ſ� ���� �ݾ׾� �����Ǿ� �Ҹ�Ǵ� ���Դϴ�. </span><br>&nbsp;
                  	<span class="style4" style="letter-spacing:-1.2px;">�� ���ݰ�꼭�� ����̿�Ⱓ ���� �ſ� �յ� ���� �Ǵ� ���ν� �Ͻ� ���� �� ���ð��� </span>
                  	<%} %>
                  </td><!-- 2018.01.25 �߰� -->
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>���ô뿩��</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
				    ��</span>&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style4>VAT����</span></td>
                  <td bgcolor=#FFFFFF>
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- ����������� ����ǥ��X(2018.03.29) -->
                  	&nbsp;<span class=style4>���ô뿩��� ������ (<%=e_bean.getG_10()%>)����ġ �뿩�Ḧ �����ϴ� ���Դϴ�. </span>
                  	<%} %>
                  </td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                    �� </span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style6><%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
                    ��</span>&nbsp;</td>
                  <td colspan=2  bgcolor=f2f2f2> &nbsp;&nbsp;&nbsp;<span class=style4>���� �뿩����� ���� �ʱⳳ�Ա� ����ȿ���� �ݿ��� �ݾ��Դϴ�.</span></td>
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
                  <td width=206 height=17 align=center bgcolor=f2f2f2><span class=style3>���뿩�� 
                    �ܿ�����ȸ��</span></td>
                  <td width=82 align=center bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>ȸ</span></td>
                  <td width=346 bgcolor=#FFFFFF>&nbsp;<span class=style4>���ô뿩�Ḧ 
                    ������ ��츸 ����Ǵ� �����Դϴ�. </span></td>
                </tr>
              </table></td>
          </tr>
		  <%}%>
		  <%if(e_bean.getPp_ment_yn().equals("Y")){%>     
      <tr> 
		    <td colspan=2>&nbsp;<span class=style3>* �ʱⳳ�Ա��� ������ �ſ뵵�� ���� �ɻ�������� ������ �� �ֽ��ϴ�.</span></td>
      </tr>
      <%}%>		  		  
<!--�����ܰ���-->

<%		if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){ //�⺻��%>
<%			if(e_bean.getRo_13_amt() > 0 && AddUtil.parseInt(e_bean.getA_b()) < 24){
					e_bean.setRo_13(0);
					e_bean.setRo_13_amt(0);
				}
				if(stat.equals("�߰���������")){
					e_bean.setRo_13(0);
					e_bean.setRo_13_amt(0);
				}
//				if(cm_bean.getDiesel_yn().equals("2")){//�Ϲݽ¿�LPG�������� ���Կɼ� ������
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
                    	<%-- <%if(!e_bean.getEst_from().equals("tae_car")){	// ��������� �ƴ� �� %>
	                    	<img src=../main_car_hp/images/bar_2022_06.jpg width=638 height=22>
						<%} else{ // ���������%>
	                    	<img src=../main_car_hp/images/bar_05_1.gif width=638 height=22>
						<%} %> --%>
						<div class='esti-title'>
							<span class='esti-num'>0<%=++esti_num%></span>
							���� �ܰ���
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
                                <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>�����ܰ���</span></td>
                                <td width=113 align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getRo_13()==0 ){%><%}else{%><%=e_bean.getRo_13()%>%<%}%></span></td>
                                <td width=60 align=center bgcolor=f2f2f2><span class=style4>&nbsp;</span></td>
                                <td width=368 bgcolor=#FFFFFF align=left>&nbsp;<span class=style4>�����ܰ��� = ���Կɼ���</span></td>
                            </tr>
                            <tr> 
                                <td height=17 align=center bgcolor=f2f2f2><span class=style3>���Կɼǰ���</span></td>
                                <td align=right bgcolor=#FFFFFF><span class=style4><%if(e_bean.getRo_13()==0 ){%>���Կɼ� ����<%}else{%><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>��<%}%></span>&nbsp;</td>
                                <td align=center bgcolor=f2f2f2><span class=style4><%if(e_bean.getRo_13()>0 ){%>VAT����<%}%></span></td>
                                <td bgcolor=#FFFFFF align=left>&nbsp;<span class=style4><%if(e_bean.getRo_13()>0 ){%>�� ���Կɼǰ��ݿ� �̿������� ������ �� �ִ� �Ǹ��� �帳�ϴ�.<%}%></span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<%if(e_bean.getRo_13() == 0 && AddUtil.parseInt(e_bean.getA_b()) < 24){%>
                <tr> 
                    <td height=10 colspan="2">&nbsp;<span class=style8>�� ���Կɼ��� <strong>�⺻�� 24�����̻� ���</strong>�ÿ��� �־���.
					</span></td>
                </tr>				
				<%}%>
				<%if(e_bean.getRo_13() == 0 && AddUtil.parseInt(e_bean.getA_b()) >= 24){%>
                <tr> 
                    <td height=10 colspan="2">&nbsp;<span class=style8>�� ���Կɼ� ����.
					</span></td>
                </tr>				
				<%}%>
<%		}%>
<!--�����ܰ���-->
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
						�ߵ����������
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
		            			<td align=center bgcolor=f2f2f2 height=17><span class=style3>�ߵ����������</span></td>
		            			<td colspan=2 bgcolor=ffffff> &nbsp;�ߵ������ÿ��� �ܿ����Ⱓ �� �뿩���� <span class=style6><b><%if(e_bean.getCls_per()>0){%><%=AddUtil.parseFloatNotDot(e_bean.getCls_per())%><%}else{%><%	if(e_bean.getMgr_ssn().equals("�������")){%>20<%}else{%>30<%}%><%}%>%</b></span> �� ������� ����</td>
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
            	<!-- �������� ���� �������� -->
           	    <%-- <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){	// �⺻��%>
           	    	<%if(!e_bean.getEst_from().equals("tae_car")){ // ��������� �ƴҶ�%>
            	        <%if(ej_bean.getJg_k().equals("0")){%>
            	        <img src=../main_car_hp/images/bar_07_1_2.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
            	        <img src=../main_car_hp/images/bar_07_1_1.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
            	        <img src=../main_car_hp/images/bar_07_3.gif width=638 height=22>
            	        <%}else{%>
            	        <img src=../main_car_hp/images/bar_2022_07.jpg width=638 height=22>
            	        <%}%>
            	    <%}else{	 %>
            	        <%if(ej_bean.getJg_k().equals("0")){%>
            	        <img src=../main_car_hp/images/bar_06_1_2.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
            	        <img src=../main_car_hp/images/bar_06_1_1.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
            	        <img src=../main_car_hp/images/bar_06_3.gif width=638 height=22>
            	        <%}else{%>
            	        <img src=../main_car_hp/images/bar_06_1.gif width=638 height=22>
            	        <%}%>
           	    	<%}%>
           	    <%}else{%>
           	    	<%if(!e_bean.getEst_from().equals("tae_car")){ // ��������� �ƴҶ�%>
            	        <%if(ej_bean.getJg_k().equals("2")){%>
            	        <img src=../main_car_hp/images/bar_06_1_1.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
            	        <img src=../main_car_hp/images/bar_06_3.gif width=638 height=22>
            	        <%}else{%>
            	        <img src=../main_car_hp/images/bar_06_1.gif width=638 height=22>
            	        <%}%>
           	        <%}else{	// ���������%>      	    	            	        
            	        <%if(ej_bean.getJg_k().equals("2")){%>
            	        <img src=../main_car_hp/images/bar_05_1_1.gif width=638 height=22>
            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
            	        <img src=../main_car_hp/images/bar_05_3.gif width=638 height=22>
            	        <%}else{%>
            	        <img src=../main_car_hp/images/bar_05.gif width=638 height=22>
            	        <%}%>		      
            	    <%	}%>            
           	    <%	}%> --%>      
           	    
           	    <div class='esti-title'>
					<span class='esti-num'>0<%=++esti_num%></span>
					�������� ���� ��������
					<sapn class='esti-title-sub'>(���뼭�񽺿� üũ�� ��ĭ�� ���񽺰� �����˴ϴ�)</sapn> 
					<sapn style='font-size: 10px; letter-spacing: -1px;'>
						<%if(ej_bean.getJg_k().equals("0")){%>
            	        �� �������� ������
            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
            	        �� �������񽺴� �¿� �� RV�� ����
            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
            	        �� �������񽺴� �Ϲ� ��������������� ����
            	        <%}else if(ej_bean.getJg_k().equals("4")){%><!-- ���� �Ϸ�Ʈ�� �������񽺴� �Ϲ� ������� �¿� �� RV �������� ���� 2019.12.12 -->
            	        �� �������񽺴� �Ϲ� ������� �¿� �� RV�� ����
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
		                     	<td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>���뼭��</span></td>
		                    	<td width=543 colspan=2 bgcolor=#FFFFFF>&nbsp;<%if(!e_bean.getInsurant().equals("2")){%>* ������ �߻��� <span class=style3><b>���ó�� ���� ����</b></span><%}%> &nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;*<span class=style3><b> ����������</b></span>(���ػ��ô� �������)<%}%></td>
		                    </tr>
		                </table>
		          </td>
		         </tr>
		         <tr></tr>
		         <tr>
		         	<td colspan="2">
		                <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                    <tr>
		                       	<td colspan=2 align=center bgcolor=#f2f2f2 height=17><input type="checkbox" name="rent_way" value="3" <%if(!ej_bean.getJg_k().equals("0") && !rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:3px;"><b>�⺻��</b> (���񼭺� ������ ��ǰ)</span></td>
		                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<input type="checkbox" name="rent_way" value="1" <%if(!ej_bean.getJg_k().equals("0") && rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:3px;"><b>�Ϲݽ�</b> (���񼭺� ���� ��ǰ)</span></td>
		                  	</tr>
		                  	<tr>
		                  		<td width=356 colspan=2 bgcolor=#FFFFFF height=95>&nbsp; <span class=style3><b>* �Ƹ����ɾ� ����</b></span><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - ���� ���� ���� ���� ��㼭�� ��� ����<br>
		                  		<%if(!e_bean.getEst_st().equals("2")){%>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� �̳� ���� ������� ����<%if(e_bean.getCar_comp_id().equals("0056")) {%>(�׽������� ����)<%}%><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24�ð� �̻� ������� �԰��)<br> 		                  		
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� ����<%}else{%>&nbsp;&nbsp;&nbsp;&nbsp; - <%}%> ���� ������ ���� ������� ����<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (�ܱ� �뿩����� 15~30% ����, Ź�۷� ����)</td>
		                   		<td width=279 bgcolor=#FFFFFF align=left>&nbsp; <span class=style3><b>* ��ü�� ���񼭺�</b></span><br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - ���� ��������ǰ/�Ҹ�ǰ ����, ��ȯ, ����<br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - ������ ���� ��޼��� ����<br>
		                   		&nbsp; <span class=style3><b>* �����������</b></span><br> 
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 4�ð� �̻� ������� �԰��</td>
		                 	</tr>
		         		</table>
		         	</td>
		        </tr>
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          
          <!--���������-->
          <%if(e_bean.getEst_from().equals("tae_car")){%>
          
          		<tr> 
		            <td colspan="2">
<!-- 		            <img src=../main_car_hp/images/bar_07_dc.gif width=638 height=22> -->
		            <div class='esti-title'>
						<span class='esti-num'>0<%=++esti_num%></span>
						����� ���� �뿩 ��� ������ ��� ����
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
		            				<!-- &nbsp;&nbsp;&nbsp;�� �뿩����� ���� �뿩 ����� ���������� ���� ���� ��� ����Ǵ� ���� ����Դϴ�.<br>
		            				&nbsp;&nbsp;&nbsp;����� ���� �뿩 ��� ������ ����Ʈ ���������� ����û���Ǹ�, ���� �ε�/ȸ�� Ź�۷ᵵ ���� û���˴ϴ�. -->
		            				<%
		            				Hashtable taeCarHt = shDb.getTaeCarRmAmt(est_id);
		            				int tae_car_fee_s_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("FEE_S_AMT"))); //���������������
		            				int tae_car_fee_v_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("FEE_V_AMT"))); //��������������� �ΰ���
		            				int tae_car_fee_t_amt = tae_car_fee_s_amt + tae_car_fee_v_amt; //��������������� �ΰ��� �ջ� �ݾ�
		            				int tae_car_r_rm_fee_s_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("R_RM_FEE_S_AMT"))); //������������� ������� ��� (����Ʈ���+����������������̵�Ź�۷�+�������������������ȿ��)
		            				int rm_fee_s_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("RM_FEE_S_AMT"))); // ����Ʈ���� ������
		            				%>
		            				<%if (rm_fee_s_amt <= 0) { // 2021.01.13. �߰�. ����Ʈ�������� 0 ������ �� %>
		            				&nbsp;&nbsp;&nbsp;�� �뿩����� ���� �뿩 ����� ���������� ���� ���� ��� ����Ǵ� ���� ����Դϴ�.<br>
									&nbsp;&nbsp;&nbsp;����� ���� �뿩 ��� ������ ����Ʈ ���������� ���� û���Ǹ�, ���� �ε�/ȸ�� Ź�۷�[Ź�� ������ Ź�۷� ����, ��)����꼭��: �պ� 44,000��(�ΰ�������)] �Ǻ�뵵 ���� û���˴ϴ�.
		            				<%} else {%>
			            				<%if (tae_car_fee_t_amt < tae_car_r_rm_fee_s_amt) { // ������������ < ����Ʈ������(�������̵�Ź�۷�����, ����������ȿ�� ����) %>
			            				&nbsp;&nbsp;&nbsp;�� �뿩����� ���� �뿩 ����� ���������� ���� ���� ��� ����Ǵ� ���� ����Դϴ�.<br>
										&nbsp;&nbsp;&nbsp;����� ���� �뿩 ��� ������ ����Ʈ ������[<%=AddUtil.parseDecimal(tae_car_r_rm_fee_s_amt)%>�� (�ΰ�������)]���� ���� û���Ǹ�,<br>
										&nbsp;&nbsp;&nbsp;���� �ε�/ȸ�� Ź�۷�[Ź�� ������ Ź�۷� ����, ��)����꼭��: �պ� 44,000��(�ΰ�������)] �Ǻ�뵵 ���� û���˴ϴ�.
			            				<%}%>
			            				<%if (tae_car_fee_t_amt >= tae_car_r_rm_fee_s_amt) { // ������������ >= ����Ʈ ������(�������̵�Ź�۷�����, ����������ȿ�� ����) %>
										&nbsp;&nbsp;&nbsp;����� ���� �뿩 ��� ������ ���� �ε�/ȸ�� Ź�۷�[Ź�� ������ Ź�۷� ����, ��)����꼭��: �պ� 44,000��(�ΰ�������)] �Ǻ���� ���� û���˴ϴ�.
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
							��Ÿ�뿩����
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
			                  	<td width=593 colspan=2 align=left class=listnum2>�ڵ����� ����, ����˻� 
			                    � �Ƹ���ī���� ó��(�� ��� �δ� ����)</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=../main_car_hp/images/2.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>Ȩ���������� �뿩���� ������������ �������� [FMS(Fleet Management System)]</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=../main_car_hp/images/3.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>�뿩�Ⱓ ����ÿ��� �ݳ�, �����̿�<%if((e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")) /* && !cm_bean.getDiesel_yn().equals("2") */ && AddUtil.parseInt(e_bean.getA_b()) >= 24){//�⺻�� && ��LPG && 24�����̻� %>, ���Կɼ� ���<%}%> �� ���� ����</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("21")){%>
			                <!-- <tr> 
			                  	<td height=17 align=right><img src=../main_car_hp/images/4.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>���Ⱓ ���� 
			                    �Ʒ��ݾ��� ����(����)�������� ��������(�ſ�����ü ����)</td>
			                </tr> -->
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td colspan=4 height=3></td>
			                </tr>
			                <%-- <%if (e_bean.getGi_fee() > 0) {%>
							<tr>
								<td colspan=4 align=right style="font-weight: bold;">�� �ſ��� <%=e_bean.getGi_grade()%>��ޱ���</td>
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
				                          	<span class=style12>�������� ���Աݾ�</span><span class=style13> 
				                          	|</span> <span class=style4><%=AddUtil.parseDecimal(e_bean.getGi_amt())%> ��</span></td>
				                        	<td width=284>
				                        		<img src=../main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
				                          		<span class=style12>���������(<%=e_bean.getA_b()%>����ġ)</span>
				                          		<span class=style13>|</span>
				                          		&nbsp;<span class=style4>
				                          		<%if (e_bean.getGi_amt() > 0) {%>
						                          	<%if (!e_bean.getGi_grade().equals("")) {%>
						                          		<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>&nbsp;��
						                          	<%} else {%>
					                          			<span style="padding-left: 60px;">��</span>
						                          	<%}%>
					                          	<%} else {%>
					                          		<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>&nbsp;��
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
								<td colspan=4 align=right>�� �ſ��޺��� ��������ᰡ �޶����ϴ�.</td>
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
	<!--�ʿ伭��ǥ�� start-->
    <!-- ����-->
	<%if(e_bean.getDoc_type().equals("1")){%>
    <tr>
        <td colspan=3 align=center>
            <table width=638 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img.gif>
                <tr>
                    <td colspan=2 align=left background=../main_car_hp/images/p_up_img.gif height=24>
                        <table width=638 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����غ񼭷� (����)</td>
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
                                <td valign=top>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>���⼭�� :</span></td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>	
                                <td>
                                    <table width=610 border=0 cellspacing=0 cellpadding=0 align=center>
                                        <tr>
                                            <td width=115 style="font-size:11px;" valign=top><span class=style4>1.��ǥ�̻� ���� �����:</span></td>
                                            <td style="font-size:11px;">
                                            <span class=style4>
                                            	�� ����ڵ���� �纻  &nbsp;�� ���� �纻(�ڵ���ü��) &nbsp;�� ��ǥ�̻� �ź��� �纻 &nbsp;�� �ֿ�����  ������  �纻<br>
                                            	�� ����Ȯ�ν� �ź��� �ǹ� ���� �ʼ�, ���� �� ���θ��� ���� �ʿ�
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
                                            <td width=135 style="font-size:11px;" valign=top><span class=style4>2.��ǥ�̻� ���� ���� �Ұ���:</span></td>
                                            <td style="font-size:11px;">
                                            <span class=style4>
                                            	�� ����ڵ���� �纻 &nbsp;�� ���� �纻(�ڵ���ü��) &nbsp;�� �����ΰ����� 1��&nbsp; �� ��ǥ�̻� �ź��� �纻<br>�� ��ǥ�̻� �ΰ����� 1�� &nbsp;�� �ֿ����� ������ �纻 &nbsp;(�ΰ������� �ֱ� 3�����̳� �߱޺�)
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
                                <td colspan=2>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>�ſ�ɻ� ������ : </span>  &nbsp;&nbsp;<span class=style4>�繫��ǥ(��������ǥ, ���Ͱ�꼭 ��) &nbsp;&nbsp;�� �ʿ�� ���뺸����(��ǥ�̻�)�� �ֹε�ϵ</span></td>
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
    <!-- ���λ����-->
    <tr>
        <td colspan=3 align=center>
            <table width=638 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img.gif height=24>
                        <table width=638 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����غ񼭷� (���λ����)</td>
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
                                <td width=88 valign=top>&nbsp;<img src=/acar/main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>���⼭�� :</span></td>
                                <td width=540>
                                    <table width=540 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td style="font-size:11px;">
                                            <span class=style4>
			                                            �� ����ڵ���� �纻  &nbsp;&nbsp;�� ���������� �纻 &nbsp;&nbsp;�� ���� �纻(�ڵ���ü��) &nbsp;&nbsp;�� �ֿ����ڰ� ������ ��� �ֿ����� ������ �纻<br> 
			                                            �� ����Ȯ�ν� �ź��� �ǹ� ���� �ʼ� &nbsp;&nbsp; 
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
	                                <span class=style12>�ſ�ɻ� ������ :&nbsp;&nbsp;</span> 
	                                <span class=style4 style="font-size:11px;">
	                                	���������ڷ�(�ΰ���ġ������ǥ������ ��) &nbsp;&nbsp;
	                                	<br><span style='margin-left: 100px;'>�� �ſ� �ɻ翡 �ʿ��� ��� �ֹε�ϵ ������ ��û�� �� �ֽ��ϴ�.</span>
	                                </span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 style="font-size:10.8px; padding-top: 5px;">
                                            �ذ����(�����)�� ������ ���� ������ ����� �븮�ؾ� �� ��쿡�� �����(�����)�� �����ΰ������� �����ϰ�, �����(�����)�� �����ΰ�����(�ֱ� 3�����̳� �߱޵� ��)�� ÷���Ͽ� ����� ü���� �� �ֽ��ϴ�. (�Ƹ���ī �������� �� �븮�� �ź��� �ʿ�)
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
    <!-- ����-->
    <%}else if(e_bean.getDoc_type().equals("3")){%>
    <tr>
        <td colspan=3 align=center>
            <table width=638 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img.gif height=24>
                        <table width=638 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����غ񼭷� (����)</td>
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
                                <td width=93>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>���⼭�� :</span></td>
                                <td width=535>
                                    <table width=525 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td style="font-size:11px;"><span class=style4>�� ���������� �纻  &nbsp;&nbsp;�� ���� �纻(�ڵ���ü��)</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td colspan=2>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>�ſ�ɻ� ������ :</span> &nbsp;&nbsp;&nbsp;<span class=style4>��������, �ҵ������ڷ�(��õ¡�������� ��)<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;�� �ſ� �ɻ翡 �ʿ��� ��� �ֹε�ϵ ������ ��û�� �� �ֽ��ϴ�.</span></td>
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
	<!--�ʿ伭��ǥ�� end-->	
	<%if(!select_print_yn.equals("Y")){ %>	
    <tr id='esti_button_tr'>
        <td align=center colspan=3>
		      <a id='esti_print' href=javascript:go_print('<%= est_id %>'); title='������ ����Ʈ �ϱ�'><img src=../main_car_hp/images/button_print.gif border=0></a>&nbsp;&nbsp;
  		    <a id='esti_mail' href=javascript:go_mail('<%= est_id %>'); title='������ ���� �߼��ϱ�'><img src="../main_car_hp/images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;	
			    <a id='esti_sms' href=javascript:esti_result_sms('<%= est_id %>'); title='��� ���� �߼��ϱ�'><img src="../main_car_hp/images/button_sms.gif" border=0></a>&nbsp;&nbsp;
		      <%if(e_bean.getDoc_type().equals("")){%>
		      <a id='esti_paper' href="javascript:go_paper();" title='����غ񼭷�����'><img src=../main_car_hp/images/button_paper.gif border=0></a>
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