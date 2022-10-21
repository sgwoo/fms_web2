<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.res_search.*" %>
<%@ page import="acar.cont.*" %>
<%@ page import = "java.text.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>


<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"0":request.getParameter("today_dist");
	String o_1 		= request.getParameter("o_1")==null?"0":request.getParameter("o_1");
	String rent_dt 		= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String a_a 		= request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String a_b 		= request.getParameter("a_b")==null?"":request.getParameter("a_b");
	String amt 		= request.getParameter("amt")==null?"0":request.getParameter("amt");	
	
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_code 	= request.getParameter("est_code")==null?"":request.getParameter("est_code");
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	int fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	String mobile_yn	= request.getParameter("mobile_yn")	==null?"0":request.getParameter("mobile_yn");
	String mail_yn		= request.getParameter("mail_yn")	==null?"0":request.getParameter("mail_yn");
	String mobile		= request.getParameter("mobile")	==null?"0":request.getParameter("mobile");
	
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	
	String page_kind = "";
	
	//20160427 rent_dt null or "" ���� ó��
	if(!rent_dt.equals("")){
		//20160422 ������ ���� ��¥�� 40�� ������ ��� �ٸ� �������� �����̷�Ʈ	
	    SimpleDateFormat dfv = new SimpleDateFormat("yyyyMMdd");
	    Calendar cal = Calendar.getInstance();
	 
	    int yyyy     = cal.get(Calendar.YEAR);    //���� �⵵
	    int MM        = cal.get(Calendar.MONTH);   //���� ��
	    int dd        = cal.get(Calendar.DATE);    //���� ��¥
	    int hh        = cal.get(Calendar.HOUR);    //���� �ð�
	    cal.set(yyyy, MM, dd); //���� ��¥ ����
	    
	    /* ��,�б��� ��� */
	    String resdate = rent_dt;    //������
	    String today = dfv.format(cal.getTime());
	    Date beginDate = null;
	    Date endDate = null;
	    
	    long diff = 0;
	    long diffDays = 0;
	    long diffTime = 0;
	    
	    beginDate = dfv.parse(resdate);    //parse: ������ ��¥ -> Date ���·� ��ȯ
	    endDate = dfv.parse(today);
	 
		diff = endDate.getTime() - beginDate.getTime(); //�и����������� ����
	    diffDays = diff / (24 * 60 * 60 * 1000);
		
	    if(diffDays>=40){
		    out.println("������ ���� �� �� ���� ����Ͽ� �ش� �������� �ı�Ǿ����ϴ�.<br/>http://www.amazoncar.co.kr/�� �湮�Ͻþ� �������� ��߱����ֽñ� �ٶ��ϴ�.");	 
		    return;
		}
    
	}	
	
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
	
	if (from_page.equals("secondhand") || from_page.equals("/fms2/lc_rent/lc_s_frame.jsp") || from_page.equals("/fms2/lc_rent/lc_t_frame.jsp") || from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp") || from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")) {
		e_bean = e_db.getEstimateCase(est_id);
		sh_comp = shDb.getShCompare(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	} else {
		e_bean = e_db.getEstimateShCase(est_id);
		sh_comp = shDb.getShCompareSh(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}
	
	if(e_bean.getOpt_chk().equals("1") && opt_chk.equals("0")) 	opt_chk 	= e_bean.getOpt_chk();
	
	if(e_bean.getFee_opt_amt() >0 && fee_opt_amt == 0 ) 		fee_opt_amt = e_bean.getFee_opt_amt();
	
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
	String car_y_form		= String.valueOf(ht.get("CAR_Y_FORM"));
	String secondhand_dt 		= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 	= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 		= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 	= String.valueOf(ht.get("OPT"));
	String colo		 	= String.valueOf(ht.get("COL"));
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
	
	
	
	//����ó----------------------------------------------------------------
	
	String name 	= "";
	String tel 		= "";
	String week_st 	= c_db.getWeek_st(AddUtil.getDate());  		//1:�Ͽ��� , 7:�����
	int hol_cnt 	= c_db.getHoliday_st(AddUtil.getDate());  	//����
	
	String watch_id = c_db.getWatch_id(AddUtil.getDate() );  // ���� ���ͳ� ����
		
	
	//�ٹ��ð���:08:30~20:30 ȸ����ȭ��ȣ ���� ������ȭ��ȣ:���ﺻ���ΰ��. ������ ������ȣ ���� 
	int t_time = Integer.parseInt(AddUtil.getTime().substring(11,13) + AddUtil.getTime().substring(14,16));
	//default :���ﺻ�� ��ȭ��ȣ
	String check = "C";
	
	if(week_st.equals("1")  || week_st.equals("7") || hol_cnt > 0 ){
		check = "P";
	}else{
		if ( t_time >= 801 && t_time <= 2001 ){
			check = "C";
		}else{
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
	
		
	String br_id = "S1";
	
	if(!acar_id.equals("")){
		UsersBean user_bean 	= umd.getUsersBean(acar_id);
		name 	= user_bean.getUser_nm();
		tel 	= user_bean.getUser_m_tel();
		br_id 	= user_bean.getBr_id();
	}
	

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
	font-size: 19px;
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
.style7 {color: #1c75ba; font-weight: bold; }
.style8 {color: #354a6d}
.style9 {color: #5f52a0}
.style12 {color: #9cb445; font-weight: bold; }
.style13 {
	color: #c4c4c4;
	font-weight: bold;
}
.style14 {color: #dc0039;font-weight: bold; }
.style15 {
	color: #6e6e6e;
	font-weight: bold;
}
.style16 {
	color: #333333;
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
.page-separate{
	page-break-after: always
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
	//���񱳺���
	function go_compare(est_id){  
		var SUBWIN="sh_compare.jsp?from_page=<%=from_page%>&est_id="+est_id;
		window.open(SUBWIN, "SubList2", "left=10, top=10, width=717, height=800, scrollbars=yes, status=yes");
	}
	//�μ��ϱ�
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
	//���ϼ����ϱ�
	function go_mail(est_id){
		var SUBWIN="/acar/apply/mail_input.jsp?from_page=<%=from_page%>&est_id=<%=est_id%>&write_id=<%=e_bean.getReg_id()%>&acar_id=<%=acar_id%>&opt_chk=<%=opt_chk%>&fee_opt_amt=<%=fee_opt_amt%>&content_st=sh";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=300, scrollbars=no, status=yes");
	}
	
	//�غ񼭷�����
	function go_paper(){
		var SUBWIN="/acar/main_car_hp/papers.html";	
		window.open(SUBWIN, "openpaper", "left=50, top=50, width=573, height=770, status=no, scrollbars=no, resizable=no");
	}
	
	//�⺻��纸���ֱ�
	function opt(est_id){  
		var fm = document.form1;
		var SUBWIN="/acar/main_car_hp/opt.jsp?est_id="+est_id+"&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=798, height=550, scrollbars=yes, status=yes, resizable=no");
	}
	
	// �׸� ��ȣ ����
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
<input type="hidden" name="opt_chk" value="<%=opt_chk%>">
<input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">
<input type="hidden" name="mobile_yn" value="<%=mobile_yn%>">
<input type="hidden" name="content_st" value="sh">
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
                        <table width=160 border=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>�ۼ���</span></td>
                                <td width=97 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
                        </table>
                    </td>
                    <td width=21>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 colspan=3></td>
    </tr>
    <tr>
        <td width=21>&nbsp;</td>
        <td width=638>
            <table width=638 border=0 cellspacing=0 cellpadding=0>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellspacing=0 cellpadding=0>
                <tr> 
                  <td width=282> <table width=282 border=0 cellspacing=0 cellpadding=0>
                      <tr> 
                        <td height=35 colspan=2 ><span class=style1>[<%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%>]
						              ������<%if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){%>�縮��<%}else{%> �緻Ʈ<%}%></span></td>
                      </tr>
                      <tr> 
                        <td colspan=2><img src=../main_car_hp/images/est_line.gif></td>
                      </tr>
                      <tr> 
                        <td width=24 height=25 align=center><img src=../main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td width=258><div align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <span class=style2>�� ����</span></div></td>
                      </tr>
                      <tr> 
                        <td colspan=2><img src=../main_car_hp/images/est_line.gif></td>
                      </tr>
                      <tr> 
                        <td height=25 align=center><img src=../main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td><span class=style2>TEL.<%=e_bean.getEst_tel()%></span></td>
                      </tr>
                      <tr> 
                        <td colspan=2><img src=../main_car_hp/images/est_line.gif></td>
                      </tr>
                      <tr>
                        <td align=center height=25><img src=../main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td><span class=style2>FAX.<%=e_bean.getEst_fax()%></span></td>
                      </tr>
                      <tr> 
                        <td colspan=2><img src=../main_car_hp/images/est_line.gif></td>
                      </tr>
                    </table></td>
                  <td width=18>&nbsp;</td>
                  <td width=356> 
                  	<table width=356 border=0 cellpadding=0 cellspacing=0 background=/acar/main_car_hp/images/est_tel_bg.gif>
                      	<tr> 
                        	<td colspan=3 height=14></td>
                      	</tr>
                      	<tr> 
                        	<td width=54 height=18></td>
                        	<td width=155 class=listnum2><span class=style5>���ǵ������� <%if(br_id.equals("S1")){%><%= tel %><%= name %><%}else{%>02-757-0802<%}%></span></td>
                      		<td width=147 class=listnum2><span class=style5>��ȭ������ <%if(br_id.equals("S5")){%><%= tel %><%= name %><%}else{%>02-2038-8661<%}%></span></td>
                      	</tr> 
                      	<tr> 
                        	<td height=18></td>
                        	<td class=listnum2><span class=style5>�� �� �� �� &nbsp;&nbsp;&nbsp;<%if(br_id.equals("S2")){%><%= tel %><%= name %><%}else{%>02-537-5877<%}%></span></td>
                        	<td class=listnum2><span class=style5>�� �� �� �� <%if(br_id.equals("S6")){%><%= tel %><%= name %><%}else{%>02-2038-2492<%}%></span></td>
                      		
                      	</tr> 
                      	<tr> 
                        	<td height=18></td>
                        	<td class=listnum2><span class=style5>�� õ �� �� &nbsp;<%if(br_id.equals("I1")){%><%= tel %><%= name %><%}else{%>032-554-8820<%}%></span></td>
                      		<td class=listnum2><span class=style5>�� �� �� �� <%if(br_id.equals("K3")){%><%= tel %><%= name %><%}else{%>031-546-8858<%}%></span></td>
                      	</tr>  
                      	<tr> 
                        	<td height=18></td>
                        	<td class=listnum2><span class=style5>�� �� �� �� &nbsp;<%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>042-824-1770<%}%></span></td>
                      		<td class=listnum2><span class=style5>�� �� �� �� <%if(br_id.equals("G1")){%><%= tel %><%= name %><%}else{%>053-582-2998<%}%></span></td>
                      	</tr>
                      	<tr> 
                        	<td height=18></td>
                        	<td class=listnum2><span class=style5>�� �� �� �� &nbsp;<%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>051-851-0606<%}%></span></td>
                      		<td class=listnum2><span class=style5>�� �� �� �� <%if(br_id.equals("J1")){%><%= tel %><%= name %><%}else{%>062-385-0133<%}%></span></td>
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
<!--             	<img src=../main_car_hp/images/bar_01.gif width=638 height=22> -->
            	<div class='esti-title'><span class='esti-num'></span> �뿩����</div>
            </td>
          </tr>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=132 height=17 align=center bgcolor=f2f2f2><span class=style3>������</span></td>
                  <td width=388 bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4><%= c_db.getNameById(car_comp_id, "CAR_COM") %></span></td>
                  <td width=114 align=center bgcolor=f2f2f2><span class=style3>�� 
                    ��</span></td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>����(�����𵨸�)</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style7><%if(est_id.length() > 0){%><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=car_name%></a><%}else{%><%=car_name%><%}%></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%if(stat.equals("�������ݺҸ�")){%>��Ȯ��<%}else{%><%= AddUtil.parseDecimal(e_bean.getCar_amt()) %>
                    ��<%}%></span>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                    ��</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style7><%if(est_id.length() > 0){%><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=opt%></a><%}else{%><%=opt%><%}%></span>
                      <%if(car_mng_id.equals("018647")){%>(���� �ǸŵǴ� �����̾� ���� ������ ����)<%}%>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getOpt_amt()) %>
                    ��</span>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                    �� </span></td>
                  <td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style7><%if(!e_bean.getIn_col().equals("")){%>����: <%}%><%=colo%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;����: <%=e_bean.getIn_col()%><%}%></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getCol_amt()) %>
                    ��</span>&nbsp;&nbsp;</td>
                </tr>
                <%if(!e_bean.getConti_rat().equals("")){%>
                <tr>
                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                    �� </span></td>
                    <td bgcolor=#FFFFFF><span id="contiRatDesc">&nbsp;&nbsp;<%=e_bean.getConti_rat()%></span></td>
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
                  <td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style7>��������� : <%=AddUtil.ChangeDate2(init_reg_dt)%> (�𵨿���:<%=car_y_form%>)
                  	<%if(!e_bean.getTot_dt().equals("") && (e_bean.getEst_from().equals("tae_car") || e_bean.getEst_from().equals("secondhand"))){//�縮��,���������%>
                  		<br>&nbsp;����Ÿ� : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km (Ȯ������:<%=AddUtil.ChangeDate2(e_bean.getTot_dt())%>)
                  	<%}else{%>
                  		&nbsp;&nbsp;����Ÿ� : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km	
                  	<%}%>
                  	</span>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style4>-<%if(stat.equals("�������ݺҸ�") || stat.equals("�߰���������")){%>##,###,###<%}else{%><%= AddUtil.parseDecimal(dlv_car_amt) %><%}%>
				    ��</span>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td height=20 align=center bgcolor=f2f2f2><span class=style3>��������</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style7>������ȣ : <%if(!car_no.equals("")){ out.println("****"+car_no.substring(car_no.length()-4, car_no.length())); } %>
                      </span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style14><%if(stat.equals("�߰���������")){%>�̰���<%}else{%><%=AddUtil.parseDecimal(e_bean.getO_1())%> 
                    ��<%}%></span>&nbsp;&nbsp;</td>
                </tr>
              </table></td>
          </tr>		  
          <tr> 
		 	<td height=10 colspan="2">
		   		<table width=638 border=0 cellpadding=0 cellspacing=1>
		        	<tr>
		          		<td>�� ����, ���ӱ� : 2����/5,000Km ǰ������<span style="font-size:10px;">(�Ⱓ �Ǵ� ����Ÿ� �� ���� ������ ���� �����Ⱓ ����� ����)</span></td> 
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
            <td height=10 colspan="2"></td>
          </tr>
          <tr> 
	            <td colspan="2">
<!-- 	            <img src=../main_car_hp/images/bar_2022_04.jpg width=638 height=22> -->
	            <div class='esti-title'>
						<span class='esti-num'></span>
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
	            			<td bgcolor=ffffff rowspan=3 align=center width=110> <span class=style14><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km���� / 1��</span>
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
	            			<td bgcolor=ffffff height=17> &nbsp;&nbsp;
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
			
				<%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20150217){%>
                                <tr> 
				    <td colspan=2 height=22>&nbsp;&nbsp;<span class=style3>* ��������Ÿ��� ���̸� �뿩����� ���ϵǰ�, ��������Ÿ��� �ø��� �뿩����� �λ�˴ϴ�.</span></td>
                                </tr>
				<%}%>
          
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellspacing=0 cellpadding=0>
                <tr> 
                  <td width=208>
	                  <%if(!e_bean.getIns_per().equals("2")){%>
<!-- 	                  <img src=/acar/main_car_hp/images/bar_02.gif width=208 height=22> -->
	                  <div class='esti-title'>
						<span class='esti-num'></span>
						�뿩��� 
						<sapn class='esti-title-sub'>(����� ����)</sapn>
						</div>
	                  <%}else{%>
<!-- 	                  <img src=/acar/main_car_hp/images/bar_02_1.gif width=208 height=22> -->
	                  <div class='esti-title'>
						<span class='esti-num'></span>
						�뿩��� 
						<sapn class='esti-title-sub'>(����� ������)</sapn>
					</div>
	                  <%}%>
                  </td>
                  <td width=30>&nbsp;</td>
                  <td width=400>
<!--                   	<img src=../main_car_hp/images/bar_03.gif width=400 height=22> -->
                  	<div class='esti-title'>
						<span class='esti-num'></span>
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
                        <td width=113 align=right bgcolor=#FFFFFF><span class=style4><%=e_bean.getA_b()%>����</span>&nbsp;&nbsp;</td>
                      </tr>
					  <%	int fee_s_amt = e_bean.getFee_s_amt();
								int fee_v_amt = e_bean.getFee_v_amt();
						  	int fee_t_amt = e_bean.getFee_s_amt()+e_bean.getFee_v_amt();
					  %>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                          �� �� </span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(fee_s_amt)%> 
                          ��</span>&nbsp;&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                          �� �� </span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(fee_v_amt)%> 
                          ��</span>&nbsp;&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>���뿩��</span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style14><%=AddUtil.parseDecimal(fee_t_amt)%> 
                          ��</span>&nbsp;&nbsp;</td>
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
                        <td align=center bgcolor=f2f2f2>&nbsp;</td>
                        <td align=center bgcolor=#FFFFFF>&nbsp;</td>
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
          
          <tr> 
            <td height=15 colspan=3 class=listnum2>&nbsp;* �� ������ �뿩�Ⱓ�� <%=min_use_mon%>����~<%=max_use_mon%>���� ���� ��� ���������� ���ð����մϴ�.</strong></td>
          </tr>                
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
					<td height=20 colspan=3 class=listnum2>&nbsp;* �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� <span class=style3><strong>���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.</strong></span>
					</td>
                </tr>
				<%}%>	
				<%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%>			
                <tr> 
					<td height=20 colspan=3 class=listnum2>&nbsp;* �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� <span class=style3><strong>���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.</strong></span>
					</td>
                </tr>
				<%}%>	

              </table></td>
          </tr>
          <tr> 
             <td height=10 colspan="2"></td>
          </tr>
          
          <tr> 
             <td height=10 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2">
<!--             	<img src=../main_car_hp/images/bar_2022_05.jpg width=638 height=22> -->
            	<div class='esti-title'>
					<span class='esti-num'></span>
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
                  <td width=98 align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getGtr_amt())%> 
                    ��</span>&nbsp;&nbsp;</td>
                  <td width=87 align=center bgcolor=f2f2f2><span class=style14>������ <%=e_bean.getRg_8()%>%</span></td>
                  <td width=373 bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4>�������� 
						  	���Ⱓ ���� �� ȯ���� �帳�ϴ�. [������ 100������ �����ϸ�,<br>&nbsp;&nbsp;���뿩�� 5,500��(VAT����)�� ���ϵ˴ϴ�.(�⸮6.6%ȿ��)]</span></td>
				</tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                    �� ��</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%> 
				    ��</span>&nbsp;&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style4>VAT����</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;&nbsp;
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- ����������� ����ǥ��X(2018.03.29) -->
                  	<span class=style4>�������� �ſ� ���� �ݾ׾� �����Ǿ� �Ҹ�Ǵ� ���Դϴ�. </span><br>&nbsp;&nbsp;
                  	<span class="style4" style="letter-spacing:-1.5px;">�� ���ݰ�꼭�� ����̿�Ⱓ ���� �ſ� �յ� ���� �Ǵ� ���ν� �Ͻ� ���� �� ���ð���</span>
                  	<%} %>
                  </td><!-- 2018.01.25 �߰� -->
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>���ô뿩��</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
				    ��</span>&nbsp;&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style4>VAT����</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;&nbsp;
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- ����������� ����ǥ��X(2018.03.29) -->
                  	<span class=style4>���ô뿩��� ������ (<%=e_bean.getG_10()%>)����ġ �뿩�Ḧ �����ϴ� ���Դϴ�. </span>
                  	<%} %>
                  </td>
                </tr>
                <tr> 
                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
                    �� </span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style14><%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
                    ��</span>&nbsp;&nbsp;</td>
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
<%		if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){//�⺻��%>
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
<!--                     <img src=../main_car_hp/images/bar_2022_06.jpg width=638 height=22> -->
                    <div class='esti-title'>
						<span class='esti-num'></span>
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
                                <td width=368 bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4>�����ܰ��� = ���Կɼ���</span></td>
                            </tr>
                            <tr> 
                                <td height=17 align=center bgcolor=f2f2f2><span class=style3>���Կɼǰ���</span></td>
                                <td align=right bgcolor=#FFFFFF><span class=style4><%if(e_bean.getRo_13()==0 ){%>���Կɼ� ����<%}else{%><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>��<%}%></span>&nbsp;&nbsp;</td>
                                <td align=center bgcolor=f2f2f2><span class=style4><%if(e_bean.getRo_13()>0 ){%>VAT����<%}%></span></td>
                                <td bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4><%if(e_bean.getRo_13()>0 ){%>�� ���Կɼǰ��ݿ� �̿������� ������ �� �ִ� �Ǹ��� �帳�ϴ�.<%}%></span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<%if(e_bean.getRo_13() == 0 && AddUtil.parseInt(e_bean.getA_b()) < 24){%>
                <tr> 
                    <td height=10 colspan="2">&nbsp;�� ���Կɼ��� <span class=style3><strong>�⺻�� 24�����̻� ���</strong></span>�ÿ��� �־���.
					</td>
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
          
          	<tr> 
	            <td colspan="2">
	            <%-- <%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
	            <img src=../main_car_hp/images/bar_2022_08.jpg width=638 height=22>
	            <%}else{%>
	            <img src=../main_car_hp/images/bar_07_yj.gif width=638 height=22>
	            <%	}%> --%>
	            <div class='esti-title'>
						<span class='esti-num'></span>
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
	            			<td colspan=2 bgcolor=ffffff> &nbsp;&nbsp;�ߵ������ÿ��� �ܿ����Ⱓ �� �뿩���� <span class=style14><%if(e_bean.getCls_per()>0){%><%=AddUtil.parseFloatNotDot(e_bean.getCls_per())%><%}else{%>30<%}%>%</span> �� ������� ����</td>
	            		</tr>
	            	</table>
	            </td>
			</tr>
          <tr> 
            <td height=10 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2">
	            	    <%-- <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){ %>
	            	        <%if(ej_bean.getJg_k().equals("0")){%>
	            	        <img src=../main_car_hp/images/bar_07_1_2.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=../main_car_hp/images/bar_07_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
	            	        <img src=../main_car_hp/images/bar_07_3.gif width=638 height=22>
	            	        <%}else{%>
	            	        <img src=../main_car_hp/images/bar_2022_07.jpg width=638 height=22>
	            	        <%}%>
	            	    <%}else{%>
	            	        <%if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=../main_car_hp/images/bar_06_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
	            	        <img src=../main_car_hp/images/bar_06_3.gif width=638 height=22>
	            	        <%}else{%>
	            	        <img src=../main_car_hp/images/bar_06_1.gif width=638 height=22>
	            	        <%}%>	            	    	            	        
	            	    <%	}%>    --%>
	            <div class='esti-title'>
					<span class='esti-num'></span>
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
		                    	<td width=543 colspan=2 bgcolor=#FFFFFF>&nbsp;&nbsp; <%if(!e_bean.getInsurant().equals("2")){%>* ������ �߻��� <span class=style3><b>���ó�� ���� ����</b></span><%}%> &nbsp;&nbsp;&nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;*<span class=style3> <b>����������</b></span>(���ػ��ô� �������)<%}%></td>
		                    </tr>
		                </table>
		          </td>
		         </tr>
		         <tr></tr>
		         <tr>
		         	<td colspan="2">
		                <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                    <tr>
		                       	<td colspan=2 align=center bgcolor=#f2f2f2 height=17><input type="checkbox" name="rent_way" value="3" <%if(!ej_bean.getJg_k().equals("0") && !rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>�⺻��</b> (���񼭺� ������ ��ǰ)</span></td>
		                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<input type="checkbox" name="rent_way" value="1" <%if(!ej_bean.getJg_k().equals("0") && rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>�Ϲݽ�</b> (���񼭺� ���� ��ǰ)</span></td>
		                  	</tr>
		                  	<tr>
		                  		<td width=356 colspan=2 bgcolor=#FFFFFF height=95>&nbsp; <span class=style3><b>* �Ƹ����ɾ� ����</b></span><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - ���� ���� ���� ���� ��㼭�� ��� ����<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� �̳� ���� ������� ����<%if(e_bean.getCar_comp_id().equals("0056")) {%>(�׽������� ����)<%}%><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24�ð� �̻� ������� �԰��)<br> 
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� ���� ���� ������ ���� ������� ����<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (�ܱ� �뿩����� 15~30% ����, Ź�۷� ����)</td>
		                   		<td width=279 bgcolor=#FFFFFF align=left>&nbsp; <span class=style3><b>* ��ü�� ���񼭺�</b></span><br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - ���� ��������ǰ/�Ҹ�ǰ ����, ��ȯ, ����<br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - ������ ���� ��޼��� ����<br>
		                   		&nbsp;  <span class=style3><b>* �����������</b></span><br> 
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 4�ð� �̻� ������� �԰��</td>
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
		     	<img src=../main_car_hp/images/bar_2022_09.jpg width=638 height=22>
		     	<%}else{%>
		     	<img src=../main_car_hp/images/bar_08.gif width=638 height=22>
		     	<%	}%> --%>
		     		<div class='esti-title'>
						<span class='esti-num'></span>
						��Ÿ�뿩����
					</div>
		     	</td>
			</tr>			
          	<tr> 
            	<td height=4 colspan="2"></td>
         	</tr>
          	<tr> 
            <td colspan="2" align=center> <table width=621 border=0 cellspacing=0 cellpadding=0>
                <tr> 
                  <td width=20 height=17 align=right><img src=../main_car_hp/images/1.gif width=13 height=13 align=absmiddle></td>
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
                  <td height=17 align=right class=listnum2><img src=../main_car_hp/images/4.gif width=13 height=13 align=absmiddle></td>
                  <td>&nbsp;</td>
                  <td colspan=2 align=left>���Ⱓ ���� 
			                    �Ʒ��ݾ��� ����(����)�������� ��������(�ſ�����ü ����)</td>
                </tr> -->
                <tr> 
                  <td colspan=4 height=3></td>
                </tr>
                <%-- <%if (e_bean.getGi_fee() > 0) {%>
			  	<tr>
					<td colspan=4 align=right style="font-weight: bold;">�� �ſ��� <%=e_bean.getGi_grade()%>��ޱ���</td>
			  	</tr>
			  	<%}%> --%>
                <tr> 
                  <td height=24>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td width=17><img src=../main_car_hp/images/arrow_1.gif width=10 height=6></td>
                  <td width=569 align=left> 
                  <%-- <table width=569 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/img_bg.gif>
                      <tr> 
                        <td colspan=3><img src=../main_car_hp/images/img_up.gif width=569 height=5></td>
                      </tr>
                      <tr> 
                        <td width=15 height=15>&nbsp;</td>
                        <td width=270><img src=../main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
                          <span class=style12>�������� ���Աݾ�</span><span class=style13> 
                          |</span> <span class=style4>
						                 <%e_bean.setGi_amt(0);
						  	               e_bean.setGi_fee(0);%>
						                 <%=AddUtil.parseDecimal(e_bean.getGi_amt())%>��
                          </span></td>
                        <td width=284>
                        	<img src=../main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
                          	<span class=style12>���������(<%=e_bean.getA_b()%>����ġ)</span>
                          	<span class=style13>|</span>
                          	<span class=style4>
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
                    </table> --%>
                    </td>
                </tr>
                <%-- <%if (e_bean.getGi_amt() > 0) {%>
			  	<tr>
					<td colspan=4 align=right>�� �ſ��޺��� ��������ᰡ �޶����ϴ�.</td>
			  	</tr>
			  	<%}%> --%>
                <%}%>
              </table></td>
          </tr>
          <tr> 
            <td height=5 colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td align=right><img src=../main_car_hp/images/ceo.gif>&nbsp;</td>
            <td align=right>&nbsp;&nbsp;</td>
          </tr>
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
        </table>
        </td>
        <td width=21>&nbsp;</td>
    </tr>
    <tr id='esti_button_tr'>
       <%if(mobile.equals("m")){%>
       <td align=center colspan=3><a href=javascript:go_mail('<%= est_id %>');><img src="../main_car_hp/images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;</td>
	     <%}else{%>	
		   <td align=center colspan=3>
		     <a href=javascript:go_print('<%= est_id %>');><img src=../main_car_hp/images/button_print.gif border=0></a>&nbsp;&nbsp;
  		   <a href=javascript:go_mail('<%= est_id %>');><img src="../main_car_hp/images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;
		     <%if(page_kind.equals("homepage")){%>
  		   <%			if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){//ģȯ����%>
  		   <%			}else{%>		  
		  	 <a href=javascript:go_compare('<%= est_id %>');><img src=../main_car_hp/images/button_compare.gif border=0></a>&nbsp;&nbsp;
		  	 <%			}%>
		     <%}%>
		     <a href="javascript:go_paper();"><img src=../main_car_hp/images/button_paper.gif border=0></a>
		   </td>
	     <%}%>
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