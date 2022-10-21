<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.res_search.*, acar.short_fee_mng.*" %>

<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>


<%
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String car_mng_id 	= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")	==null?"":request.getParameter("today_dist");
	String o_1 		= request.getParameter("o_1")		==null?"":request.getParameter("o_1");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt");
	String a_a 		= request.getParameter("a_a")		==null?"":request.getParameter("a_a");
	String a_b 		= request.getParameter("a_b")		==null?"":request.getParameter("a_b");
	String amt 		= request.getParameter("amt")		==null?"":request.getParameter("amt");
	
	String est_id 		= request.getParameter("est_id")	==null?"":request.getParameter("est_id");
	String est_nm	 	= request.getParameter("est_nm")	==null?"":request.getParameter("est_nm");
	
	String acar_id 		= request.getParameter("acar_id")	==null?"":request.getParameter("acar_id");
	String mail_yn 		= request.getParameter("mail_yn")	==null?"":request.getParameter("mail_yn");
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");
	int fee_opt_amt 	= request.getParameter("fee_opt_amt")	==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//��������
	EstimateBean e_bean = new EstimateBean();
	
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp") || from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp") || from_page.equals("/acar/secondhand/secondhand_sc.jsp")||from_page.equals("off_lease_sc.jsp")){		//FMS �縮�������������� �⺻������/����������
		e_bean = e_db.getEstimateCase(est_id);
		if(today_dist.equals(""))	today_dist = String.valueOf(e_bean.getToday_dist());
	}else{									//Ȩ������ �縮������ ������
		e_bean = e_db.getEstimateShCase(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}
	
	if(e_bean.getOpt_chk().equals("1") && opt_chk.equals("0")) 	opt_chk 	= e_bean.getOpt_chk();
	
	//�ܰ� ��������
	Hashtable sh_comp = new Hashtable();
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp") || from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp") || from_page.equals("/acar/secondhand/secondhand_sc.jsp")||from_page.equals("off_lease_sc.jsp")){
		sh_comp = shDb.getShCompare(est_id);
		
	}else{
		sh_comp = shDb.getShCompareSh(est_id);
	}
	
	//��������	
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	//����������
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());				
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);
	
	//�ܱ���ǥ
	ShortFeeMngBean sf_bean = sfm_db.getShortFeeMngCase(ej_bean.getJg_r(), "2", e_bean.getRent_dt());	
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
		
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
	if(today_dist.equals(""))	today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 	= String.valueOf(ht.get("OPT"));
	String colo		 	= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int tax_dc_amt		= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));	
	String dist_cng			= String.valueOf(ht.get("DIST_CNG"));	
	float spe_dc_per		= AddUtil.parseFloat((String)ht.get("SPE_DC_PER"));
	
	String cha_st_dt 		= String.valueOf(ht.get("CHA_ST_DT"));
	String b_dist 			= String.valueOf(ht.get("B_DIST"));
	
	if(e_bean.getB_dist() > 0){
		cha_st_dt 		= e_bean.getCha_st_dt();
		b_dist 			= String.valueOf(e_bean.getB_dist());
	}
	
	if(e_bean.getCar_amt()==0){
		e_bean.setCar_amt(car_amt);
		e_bean.setOpt_amt(opt_amt);
		e_bean.setCol_amt(clr_amt);
	}
	
	String stat = "";
		
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
	String vali_date = ""; 
	
	//if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
	//	vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 4));
	//	if(e_bean.getMgr_ssn().equals("�������") && !e_bean.getEst_from().equals("ext_car")) 	vali_date = AddUtil.getDate3(rs_db.addMonth(e_bean.getReg_dt().substring(0,8), 1));
	//}
	
	//����ó----------------------------------------------------------------
	
	String name 	= "";
	String tel 	= "";
	String m_tel	= "";
	String h_tel	= "";
	String i_fax	= "";
	String email	= "";
	String h_tels 	= "";	
	String week_st 	= c_db.getWeek_st(AddUtil.getDate());  		//1:�Ͽ��� , 7:�����
	int hol_cnt 	= c_db.getHoliday_st(AddUtil.getDate());  	//����
	
	//����Ʈ Ȩ���������� �ѱ� ��������
	String br_id = request.getParameter("br_id")	==null?"":request.getParameter("br_id");
	
	
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
	
	//20121106 ����ƮȨ���������� �ѱ� ������ ���� ����ó ǥ��
	if(br_id.equals("B1")){
		name 	= "�λ�";
		h_tel 	=  "051-851-0606";			
	}else if(br_id.equals("D1")){
		name 	= "����";
		h_tel 	=  "042-824-1770";				
	}else{
		name 	= "����";
		h_tel 	=  "02-757-0802";	
		h_tels	= "070-8224-8670";			
	}		
	
	if ( check.equals("C")){
//		name = "";
//		h_tel =  "02-757-0802";
	} else {
//		name = "";
//		h_tel =  "02-392-4242";
		
	//	UsersBean user_bean1 	= umd.getUsersBean(watch_id);
	//	name 	= user_bean1.getUser_nm();
	//	tel 	= user_bean1.getUser_m_tel();
	
		if(name.equals("����")){
			h_tel 	=  "02-392-4242";	
		}	
		
	}
	
	
	/*
	if(!e_bean.getReg_id().equals("") && e_bean.getReg_id().length() == 6){
		UsersBean user_bean 	= umd.getUsersBean(e_bean.getReg_id());
		name 	= user_bean.getUser_nm();
		tel 	= user_bean.getUser_m_tel();
	}*/
	
	
	//Ư������� ������ ��쿡�� ��������ڷ� ǥ��	
	acar_id = e_bean.getReg_id();
	
	//if(e_bean.getReg_id().equals("SYSTEM")) acar_id = "000085";
	
	
	if(!acar_id.equals("") && !acar_id.equals("SYSTEM")){
		UsersBean user_bean 	= umd.getUsersBean(acar_id);
		name 		= user_bean.getUser_nm();
		tel 		= user_bean.getUser_m_tel();
		br_id 		= user_bean.getBr_id();
		i_fax   	= user_bean.getI_fax();
		email 		= user_bean.getUser_email();		
		
		if (acar_id.equals("000153") ) {
			m_tel 		=   "070-8224-8670"; //�������� �޴���ȣǥ�� ����.
		}else {
			m_tel 		= user_bean.getUser_m_tel();	
		}
			
		h_tel 	=  "02-392-4242"; //�ֶ��� �ʿ����.
		//20170123 ����� �Ҽ� ������ ���� ����ó ǥ��
		if(br_id.equals("S1")){
			h_tel 	=  "02-757-0802";	
		}else if(br_id.equals("S3")){
			h_tel 	=  "02-2636-9920";	
		}else if(br_id.equals("S4")){
			h_tel 	=  "02-2038-7575";		
		}else if(br_id.equals("S2")){
			h_tel 	=  "02-537-5877";				
		}else if(br_id.equals("S5")){
			h_tel 	=  "02-2038-8661";				
		}else if(br_id.equals("S6")){
			h_tel 	=  "02-2038-2492";				
		}else if(br_id.equals("I1")){
			h_tel 	=  "032-554-8820";				
		}else if(br_id.equals("K3")){
			h_tel 	=  "031-546-8858";				
		}else if(br_id.equals("B1")){
			h_tel 	=  "051-851-0606";				
		}else if(br_id.equals("D1")){
			h_tel 	=  "042-824-1770";				
		}else if(br_id.equals("J1")){
			h_tel 	=  "062-385-0133";				
		}else if(br_id.equals("G1")){
			h_tel 	=  "053-582-2998";				
		}else{
			h_tel 	=  "02-757-0802";			
		}
		//h_tel 		= user_bean.getHot_tel();		
	}
	
	String client_st = "2";
	

	
	if(e_bean.getAgree_dist() == 0) 	e_bean.setAgree_dist(5000);
	if(e_bean.getOver_run_amt() == 0) 	e_bean.setOver_run_amt(90);	
	if(e_bean.getVali_type().equals(""))	e_bean.setVali_type("0");
	
	//20120830 ����ƮȨ������ ����	
	
	int months 		= request.getParameter("months")	==null?0:AddUtil.parseDigit(request.getParameter("months"));
	int days 		= request.getParameter("days")		==null?0:AddUtil.parseDigit(request.getParameter("days"));
	int tot_rm 		= request.getParameter("tot_rm")	==null?0:AddUtil.parseDigit(request.getParameter("tot_rm"));
	int tot_rm1 		= request.getParameter("tot_rm1")	==null?0:AddUtil.parseDigit(request.getParameter("tot_rm1"));
	String per 		= request.getParameter("per")		==null?"":request.getParameter("per");
	String navi_yn 		= request.getParameter("navi_yn")	==null?"":request.getParameter("navi_yn");
	
	
	//����Ʈ����Ʈ ��ũ�� �ƴѰ��
	if(months == 0 && days == 0 && tot_rm == 0 && tot_rm1 == 0 && per.equals("")){
		months 	= 1;
		per	= "0";
		tot_rm	= e_bean.getFee_s_amt();
		tot_rm1	= tot_rm;
	}		
	
	int tot_rm_v 	= 0;
	int tot_rm1_v 	= 0;
	
	//���뿩���� ������
	Hashtable day_pers = shDb.getEstiRmDayPers(per);
	
	int day_per[] = new int[30];

	//�������� ī��Ʈ
	int day_cnt = 0;


	for (int j = 0 ; j < 30 ; j++){
		day_per[j] = AddUtil.parseInt((String)day_pers.get("PER_"+(j+1)));
		
		
		if(j+1 == 30){
			if(day_per[j]>100) 	day_per[j] = 0;
		}else{
			if(day_per[j]>99) 	day_per[j] = 0;
		}

		if(day_per[j]>0) 	day_cnt++;	
	}
	
	//����Ʈ ������� ���¿��� �ް��϶��� ������ �ǿ�ľ��� ��ü
	if(acar_id.equals("000153")){
		//�ް�����
		String today_free_id = umd.getCarScheTodayChk(acar_id);
		
		if(today_free_id.equals(acar_id)){
			acar_id = "000144";
			UsersBean user_bean 	= umd.getUsersBean(acar_id);
			name 		= user_bean.getUser_nm();
			tel 		= user_bean.getUser_m_tel();
			br_id 		= user_bean.getBr_id();
			m_tel 		=  "070-8224-8670"; //��������	
		//	m_tel 		= user_bean.getUser_m_tel();	
			h_tel 		=  "02-392-4242"; //�ֶ��� �ʿ����.	
			//20170123 ����� �Ҽ� ������ ���� ����ó ǥ��
			if(br_id.equals("S1")){
				h_tel 	=  "02-757-0802";	
			}else if(br_id.equals("S3")){
				h_tel 	=  "02-2636-9920";	
			}else if(br_id.equals("S4")){
				h_tel 	=  "02-2038-7575";		
			}else if(br_id.equals("S2")){
				h_tel 	=  "02-537-5877";				
			}else if(br_id.equals("S5")){
				h_tel 	=  "02-2038-8661";				
			}else if(br_id.equals("S6")){
				h_tel 	=  "02-2038-2492";				
			}else if(br_id.equals("I1")){
				h_tel 	=  "032-554-8820";				
			}else if(br_id.equals("K3")){
				h_tel 	=  "031-546-8858";				
			}else if(br_id.equals("B1")){
				h_tel 	=  "051-851-0606";				
			}else if(br_id.equals("D1")){
				h_tel 	=  "042-824-1770";				
			}else if(br_id.equals("J1")){
				h_tel 	=  "062-385-0133";				
			}else if(br_id.equals("G1")){
				h_tel 	=  "053-582-2998";				
			}else{
				h_tel 	=  "02-757-0802";			
			}
		//	h_tel 		= user_bean.getHot_tel();  ///����Ʈ �ֶ��� �ʿ����.
		}
	}		
%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>������</title>
<style type="text/css">
<!--
.style1 {
	color: #ff00ff;
	font-weight: bold;
	font-size: 19px;
}
.style2 {
	color: #000000;
	font-weight: bold;
	font-size:11px;
}
.style3 {
	color: #000000;
	font-size:11px;
}
.style4 {color: #000000;
	font-size:11px;}
.style5 {color: #000000;}
.style7 {color: #e86e1b; font-weight: bold;}
.style8 {color: #354a6d; font-weight: bold;}
.style9 {color: #5f52a0; font-weight: bold;}
.style12 {color: #9cb445; font-weight: bold; }
.style13 {
	color: #c4c4c4;
	font-weight: bold;
}
.style14 {color: #616161; font-weight: bold;}
.style15 {
	color: #6e6e6e;
	font-weight: bold;
}
.style16 {
	color: #000000;
	font-size: 8pt;
}
.style11 {
	color: #000000;
	font-size:1.3em;
	font-weight: bold;
}
.style17 {
	color: #000000;
	font-size:1.1em;
	font-weight: bold;
}
-->
</style>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	/* transform: scale(.9); */    	
        /* margin���� ����Ʈ ���� ���� */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*���*/
		-webkit-margin-end: 0mm; /*����*/
		-webkit-margin-after: 0mm; /*�ϴ�*/
		-webkit-margin-start: 0mm; /*����*/
}

</style>
<link href="/acar/main_car_hp/style_est_print.css" rel="stylesheet" type="text/css">
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
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

</head>
<body topmargin=0 leftmargin=0 <%if(mail_yn.equals("")){%>onLoad="javascript:onprint();"<%}%>>
<%if(mail_yn.equals("")){%>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">

</object>
<%}%>

<form action="" name="form1" method="POST" >
<input type="hidden" name="est_id" value="<%=est_id%>">

<table width=680 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr bgcolor=80972e>
        <td height=4 colspan=3></td>
    </tr>
    <tr>
        <td height=5 colspan=3></td>
    </tr>
    <tr>
        <td colspan=3 align=center>
            <table width=680 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=21>&nbsp;</td>
                    <td width=478 align=right><img src=/acar/main_car_hp/images/title_rm.gif></td>
                    <td width=160 align=right>
                        <table width=160 border=0 cellspacing=1 bgcolor=c4c4c4>
			    <%
				if(e_bean.getVali_type().equals("0") || e_bean.getVali_type().equals("1")){
					vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 4));
				}else if(e_bean.getVali_type().equals("2")){
					vali_date = "��Ȯ�� �����Դϴ�.";
				}%>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>�ۼ���</span></td>
                                <td width=97 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
			    <%if(!vali_date.equals("")){%>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>��ȿ�Ⱓ</span></td>
                                <td bgcolor=ffffff align=center><span class=style16><%=vali_date%></span></td>
                            </tr>
			    <%}%>														
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
		            <td colspan="2"> 
		            	<table width=638 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=410> 
			                  		<table width=410 border=0 cellspacing=0 cellpadding=0>
				                      <tr> 
				                        <td height=5 colspan=4></td>
				                      </tr>
				                      <tr> 
				                        <td colspan=4><img src=/acar/main_car_hp/images/line.gif width=409 height=1></td>
				                      </tr>
				                      <tr> 
				                        <td width=24 height=30 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        <td width=160><div align="left"><span class=style2><%=e_bean.getEst_nm()%>
				                            <%if(client_st.equals("2")){%>����<%}else{%>����<%}%></span></div></td>
				                        <td width=24 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        <td width=202><div align="left"><span class=style2><%=AddUtil.ChangeDate2(e_bean.getRent_dt())%></span></div></td>
				                      </tr>
				                      <tr> 
				                        <td colspan=4><img src=/acar/main_car_hp/images/line.gif width=409 height=1></td>
				                      </tr>
				                      <tr> 
				                        <td height=30 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        <td><span class=style2>TEL.<%=e_bean.getEst_tel()%></span></td>
				                        <td align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        <td><span class=style2>FAX.<%=e_bean.getEst_fax()%></span></td>
				                      </tr>
				                      <tr> 
				                        <td colspan=4><img src=/acar/main_car_hp/images/line.gif width=409 height=1></td>
				                      </tr>
			                    	</table>
			                    </td>
			                  	<td width=28>&nbsp;</td>
			                  	<td width=201>
			                    <%if(!acar_id.equals("")){%>
			                      	<%if(name.equals("����")){%>
				                  	<table width=201 border=0 cellpadding=0 cellspacing=0 style="background:url(../main_car_hp/images/tel_bg_new_1.gif) no-repeat;background-size:201px 110px;">
						   									<tr> 
				                        		<td colspan=4 height=10></td>
					                			</tr>
					               		
										  					<tr> 
					                        	<td width=70 align=right valign=top height=13>&nbsp;<span class=style5>���ǵ�</span></td>
					                        	<td width=141 valign=top style="padding-left:20px;"><span class=style5>02-757-0802</span></td>
					                      </tr>
					                   		<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>��ȭ��</span></td>
					                        	<td style="padding-left:20px;"><span class=style5>02-2038-8661</span></td>
					                      </tr>
					                    	<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>����</span></td>
					                        	<td style="padding-left:20px;"><span class=style5>02-537-5877</span></td>
					                      </tr>
					                 			<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>����</span></td>
					                        	<td height=13 style="padding-left:20px;"><span class=style5>02-2038-2492</span></td>
					                      </tr>
											<tr> 
					                        	<td align=right  height=13>&nbsp;<span class=style5>��õ</span></td>
					                        	<td style="padding-left:20px;"><span class=style5>032-554-8820</span></td>
					                      </tr>
										 <tr> 
					                        	<td align=right  height=13>&nbsp;<span class=style5>����</span></td>
					                        	<td style="padding-left:20px;"><span class=style5>031-546-8858</span></td>
					                      </tr>
					                      <tr> 
				                        	<td colspan=4 height=8></td>
				                      	</tr> 
					                  </table>
										  <%}else{%>
										  			<table width=201 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/tel_bg_new.gif  height=80>
					                      <tr> 
					                        	<td width=50 align=right>&nbsp;<span class=style5><b><%= name %></b></span></td>
					                        	<td width=20>&nbsp;</td>
					                        	<td class=listnum2>&nbsp;<span class=style5><%= h_tel %></span></td>
					                      </tr>
					                  </table>
										 	 <%}%> 
			                    <%}else{%>
				                    <table width=201 border=0 cellpadding=0 cellspacing=0 background=/acar/main_car_hp/images/tel_bg.gif>
				                      <tr> 
				                        <td colspan=2 height=13></td>
				                      </tr>
				                      <tr> 
				                        <td width=68>&nbsp;</td>
				                        <td class=listnum2><img src=/acar/main_car_hp/images/dot1.gif width=4 height=4 align=absmiddle> 
				                          <span class=style5>���ﺻ��</span></td>
				                      </tr>
				                                
				                      <tr> 
				                        <td>&nbsp;</td>
				                        <td height=14 class=listnum2><span class=style5><%if(br_id.equals("S1")){%><%= tel %><%= name %><%}else{%>02-757-0802<%}%></span></td>
				                      </tr> 
				                                   
				                      <tr> 
				                        <td>&nbsp;</td>
				                        <td class=listnum2><img src=/acar/main_car_hp/images/dot1.gif width=4 height=4 align=absmiddle> 
				                          <span class=style5>�λ�����</span></td>
				                      </tr>
				                      <tr> 
				                        <td>&nbsp;</td>
				                        <td height=14 class=listnum2><span class=style5><%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>051-851-0606<%}%></span></td>
				                      </tr> 
				                      <tr> 
				                        <td>&nbsp;</td>
				                        <td class=listnum2><img src=/acar/main_car_hp/images/dot1.gif width=4 height=4 align=absmiddle> 
				                          <span class=style5>��������</span></td>
				                      </tr>
				                      <tr> 
				                        <td>&nbsp;</td>
				                        <td height=14 class=listnum2><span class=style5><%if(br_id.equals("D1")){%><%= tel %><%= name %><%}else{%>042-824-1770<%}%></span></td>
				                      </tr> 
				                      <tr> 
				                        <td colspan=2 height=2></td>
				                      </tr>                 				                                     
				                    </table>
			                    <%}%>
			                  	</td>
			                </tr>
			                <tr> 
			                  	<td colspan="3" height="2"></td>
			                </tr>
			                <tr> 
			                  	<td colspan="3">&nbsp;�� �ͻ翡�� �����Ͻ� ���뿩�� ���Ͽ� �Ʒ��� ���� ������ �����Ͽ��� 
			                    �����Ͻð� ���� �亯 ��Ź�帳�ϴ�.</td>
			                </tr>
			                <tr> 
			                  	<td colspan="3" height="2"></td>
			                </tr>
		              	</table>
					</td>
				</tr>
				<tr> 
		            <td colspan="2"><img src=/acar/main_car_hp/images/bar_01.gif width=638 height=22></td>
				</tr>
				<tr> 
		            <td height=2 colspan="2"></td>
				<tr> 
				</tr>
		            <td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
			                <tr> 
			                  <td width=122 height=13 align=center bgcolor=f2f2f2><span class=style3>������</span></td>
			                  <td width=368 bgcolor=#FFFFFF>&nbsp;<span class=style3><%= c_db.getNameById(car_comp_id, "CAR_COM") %></span></td>
			                  <td width=144 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    ��</span></td>
			                </tr>
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>����(�����𵨸�)</span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%=car_name%></b></span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getCar_amt()) %>
			                    ��</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    ��</span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%=opt%></b></span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style3><%= AddUtil.parseDecimal(opt_amt) %>
			                    ��</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    �� </span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%if(!e_bean.getIn_col().equals("")){%>����: <%}%><%=colo%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;����: <%=e_bean.getIn_col()%><%}%></b></span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style3><%= AddUtil.parseDecimal(clr_amt) %>
			                    ��</span>&nbsp;</td>
			                </tr>
                <!-- ���� ���Ҽ� ���� �߰�(2017.10.13) -->
                <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
                <tr>
                	<td height=15 align=center bgcolor=f2f2f2><span class=style3>���� ���Ҽ� ���� </span></td>
                    <td bgcolor=#FFFFFF>
                    </td>
                    <td align=right bgcolor=#FFFFFF><span class=style4> - <%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> ��</span>&nbsp;</td>
                </tr>
                <%}%>			                
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>������
			                   </span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3>��������� : <%=AddUtil.ChangeDate2(init_reg_dt)%>&nbsp;&nbsp;&nbsp;&nbsp;����Ÿ� : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km</span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style3>-<%= AddUtil.parseDecimal(dlv_car_amt) %>
							    ��</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>��������</span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3>������ȣ : <%if(!car_no.equals("")){ out.println("****"+car_no.substring(car_no.length()-4, car_no.length())); } %>
			                      <!--<%if(!dist_cng.equals("") && spe_dc_per==0){%>&nbsp;����Ÿ� Ȯ�� �� �뿩��� ���� �ʿ�<%}else if(!dist_cng.equals("") && spe_dc_per > 0){%>&nbsp;������Ÿ� �뿩��ݿ� �ݿ��Ϸ�<%}%>-->
			                  </span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style3><b><%=AddUtil.parseDecimal(e_bean.getO_1())%>
			                    ��</b></span>&nbsp;</td>
			                </tr>
		              	</table>
					</td>
				</tr>
				<tr> 
		            <td height=10 colspan="2" align="right">
		            <%if(cm_bean.getJg_code().equals("1232") || cm_bean.getJg_code().equals("1242") || cm_bean.getJg_code().equals("1021212") || cm_bean.getJg_code().equals("1023112")){//��׹���ǻ��,����%>
					<span class=style4>�� LPG/�ֹ��� �����</span>	
					<%}else{%>						
					<%	if(String.valueOf(sh_comp.get("ENGIN")).equals("Y")){%>		�� ��������
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("2")){%>	<span class=style4>�� LPG������</span>
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("1")){%>	�� ���ָ�����
					<%	}else{%>
						<%if(cm_bean.getDiesel_yn().equals("Y")){%>			�� ��������
						<%}else if(cm_bean.getDiesel_yn().equals("2")){%>		<span class=style4>�� LPG������</span>
						<%}else if(cm_bean.getDiesel_yn().equals("1")){%>		�� ���ָ�����
						<%}%>
					<%	}%>
					<%}%>	</span>		
					</td>
				</tr>
          <%if(!dist_cng.equals("")){%>
          <tr>
          	<td colspan="2" bgcolor=f2f2f2 height=40> &nbsp;<span class=style3> * �� ������ ����� ��ȯ �̷�(<%=AddUtil.getDate3(cha_st_dt)%>)�� �ִ� �������� ����� ��ȯ�� ����Ÿ��� <%=AddUtil.parseDecimal(b_dist)%>km, ��ȯ��<br>
          	&nbsp;&nbsp;&nbsp;&nbsp;�� ������� ����Ÿ��� <%=AddUtil.parseDecimal(AddUtil.parseInt(today_dist)-AddUtil.parseInt(b_dist))%>km�Դϴ�. ������ ���ÿ��� ����Ÿ��� <%=AddUtil.parseDecimal(today_dist)%>km�� �����ϰ�, ��������<br>
          	&nbsp;&nbsp;&nbsp;&nbsp;���� �ü��϶��� �ݿ��Ͽ����ϴ�.</span></td>
          </tr>
          <%}%>
				
				<tr> 
		            <td colspan="2"> 
		            	<table width=638 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=231><%if(navi_yn.equals("")){%><a href=javascript:go_navi_esti('Y'); title='������̼����� ��������'><img src=/acar/main_car_hp/images/bar_02_1_rm_new.gif border=0></a><%}else{%><img src=/acar/main_car_hp/images/bar_02_rm_new.gif><%}%></td>
			                  	<td width=10>&nbsp;</td>
			                  	<td width=397><img src=/acar/main_car_hp/images/bar_03_rm_new.gif></td>
			                </tr>
			                <tr> 
			                  	<td height=2 colspan=3></td>
			                </tr>
			                <tr> 
			                  	<td> 
									<table width=231 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      <tr> 
				                        <td width=94 height=13 align=center bgcolor=f2f2f2><span class=style3>�뿩�Ⱓ</span></td>
				                      	<td width=137 align=center bgcolor=#FFFFFF><span class=style3>1����</span></td>
				                      </tr>
									  <%		if(navi_yn.equals("Y")){
									  			tot_rm 	= tot_rm+25000;
									  			//tot_rm1 = Math.round((tot_rm * months + tot_rm * days/30)/100)*100;  //����뿩��- 0���� 0��
									  			tot_rm1 = Math.round((tot_rm * months + tot_rm * days/30));  //����뿩��- 0���� 0��
									  		}
									  		
									  		tot_rm_v 	= tot_rm/10;
									  		tot_rm1_v 	= tot_rm1/10;
									  %>
				                      <tr> 
				                        <td height=13 align=center bgcolor=f2f2f2><span class=style3>�� 
				                          �� �� </span></td>
				                          <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(tot_rm)%> 
				                          ��</span>&nbsp;&nbsp;</td>
				                      </tr>
				                      <tr> 
				                        <td height=13 align=center bgcolor=f2f2f2><span class=style3>�� 
				                          �� �� </span></td>
				                          <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(tot_rm_v)%> 
				                          ��</span>&nbsp;&nbsp;</td>
				                      </tr>
				                      <tr> 
				                        <td height=13 align=center bgcolor=f2f2f2><span class=style3>�뿩�ݾ�</span></td>
				                          <td align=right bgcolor=#FFFFFF><span class=style3><b><%=AddUtil.parseDecimal(tot_rm+tot_rm_v)%> 
				                          ��</b></span>&nbsp;&nbsp;</td>
				                      </tr>
				                    </table>
								</td>
			                  	<td>&nbsp;</td>
			                  	<td> 
							  <%if(!e_bean.getIns_per().equals("2")){%>
									<table width=397 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
							        	<tr> 
							          		<td width=85 height=13 align=center bgcolor=f2f2f2><span class=style3>���ι��</span></td>
							            	<td width=118 align=center bgcolor=#FFFFFF><span class=style3>����(���� 
							                          ��,��) </span></td>
							            	<td width=85 align=center bgcolor=f2f2f2><span class=style3>������å��</span></td>
							             	<td width=109 align=center bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>��</span></td>
							         	</tr>
							         	<tr> 
							             	<td height=13 align=center bgcolor=f2f2f2><span class=style3>�빰���</span></td>
							             	<td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_dj().equals("1")){%>5õ����<%}else if(e_bean.getIns_dj().equals("4")){%>2���<%}else{%>1���<%}%></span></td>
							              	<td align=center bgcolor=f2f2f2><span class=style3>������������</span></td>
							             	<td align=center bgcolor=#FFFFFF><span class=style3>1�δ��ְ�2���</span></td>
							                        
							        	</tr>
							       		<tr> 
								      		<td height=13 align=center bgcolor=f2f2f2><span class=style3>�ڱ��ü���</span></td>
								       		<td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_dj().equals("1")){%>5õ����<%}else{%>1���<%}%></span></td>
								      		<td align=center bgcolor=f2f2f2><span class=style3>�����ڿ���</span></td>
								       		<td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean.getIns_age().equals("3")){%>��24���̻�<%}else{%>��26���̻�<%}%></span></td>
							       		</tr>
							        	<tr> 
								         	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�����ڹ���</span></td>
								         	<td align=center bgcolor=#FFFFFF colspan=3><span class=style3>����� �� ��༭�� ��õ� �߰�������</span></td>
							        	</tr>
						        	</table>                   
								<%}else{%>
									<table width=397 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
							     		<tr> 
											<td width=85 height=13 align=center bgcolor=f2f2f2><span class=style3>���ι��</span></td>
								  			<td width=97 align=center bgcolor=#FFFFFF><span class=style3>����̹ݿ�</span></td>
								    		<td width=85 align=center bgcolor=f2f2f2><span class=style3>������å��</span></td>
								   			<td width=87 align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
							       		</tr>
							       		<tr> 
								         	<td height=13 align=center bgcolor=f2f2f2><span class=style3>�빰���</span></td>
								       		<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
								        	<td align=center bgcolor=f2f2f2><span class=style3>������������</span></td>
								      		<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
							        	</tr>
							      		<tr> 
								        	<td height=13 align=center bgcolor=f2f2f2><span class=style3>�ڱ��ü���</span></td>
								       		<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
								      		<td align=center bgcolor=f2f2f2><span class=style3>�����ڿ���</span></td>
								     		<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
							        	</tr>
							       		<tr> 
								        	<td height=13 align=center bgcolor=f2f2f2><span class=style3>�����ڹ���</span></td>
								     		<td align=center bgcolor=#FFFFFF colspan=3><span class=style4>����̹ݿ�</span></td>
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
				            
		              	</table>
					</td>
				</tr>
				<tr> 
					<td height=5 colspan="2"></td>
				</tr>
				<tr> 
					<td colspan="2"><img src=/acar/main_car_hp/images/bar_04_rm.gif width=638 height=22></td>
				</tr>
				<tr> 
					<td height=2 colspan="2"></td>
				</tr>
				<tr>
					<td colspan="2" height=20><span class=style17>�ʼ� Ȯ�λ���</span></td>
				</tr>
          		<tr> 
            		<td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                	<tr> 
		                  		<td width=90 height=17 align=center bgcolor=f2f2f2><span class=style3>�����ڰݿ��</span></td>
		                  		<td width=543 bgcolor=#FFFFFF style="padding:3px 5px;"> <span class=style4>�� 26���̻� ������� 3���̻��� ���ѹα� ���������� ������(�Ƹ���ī ����Ʈ�� 26���̸� ���� �����)<br>�� ������ ���ѹα��� ����� �̿밡��</span></td>
		                  	</tr>
							<tr>
								<td height=17 bgcolor=#f2f2f2 align=center><span class=style3>�뿩�� ����</span></td>
								<td bgcolor=#FFFFFF style="padding:3px 5px;" ><span class=style4>�뿩��� ����� ���� ����(������ ��� ���� ����)�� �ſ�ī��� �����ؾ� �մϴ�.(üũī�� �Ұ�)<br>
									�� ����ī��� ���� ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��)�� �����մϴ�.
									</span></td>
							</tr>
							<tr>
								<td height=17 bgcolor=#f2f2f2 align=center><span class=style3>������ ����</span></td>
								<td bgcolor=#FFFFFF style="padding:3px 5px;"><span class=style4>�Ϲݰ��� : ���θ� �������� (��, ����ڿ� ���Ͽ� ���� �ɻ� �� �߰� ����)<br>
								���λ���� : �����(���λ����) �� ������ �������� ������ ���� 1�θ� ���� ����(������ �������� Ư�� ����)<br>
								 ���� : ������ �������� ������ ���� 2�θ� ���� ����(������ �������� Ư�� ����) </span></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" height=20><span class=style17>�Ϲ� Ȯ�λ���</span></td>
				</tr>
				<tr>
					<td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
							<tr>
		                  		<td width=90 height=17 bgcolor=#f2f2f2 align=center><span class=style3>��������Ÿ�</span></td>
		                  		<td width=543 bgcolor=#ffffff style="padding:3px 5px;"><span class=style4><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km / 1����, �ʰ��� 1km�� <span class=style14><%=e_bean.getOver_run_amt()%></span>��(�ΰ�������)�� �ʰ�����뿩�ᰡ �ΰ��˴ϴ�(�뿩�����)</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>�������</span></td>
		                  		<td height=17 bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>Ȩ�������� ���ؼ� ���� ������ �����ϰ�, ��� ������ ����� ���ؼ��� ���������� �����մϴ�.<br>
								���� ������ �ٹ��� ���� ���� 16�ñ��� �Դϴ�. ���� ���� ���� ����� �����ϼž� ������ ��ҵ��� �ʽ��ϴ�. </span></td>
							</tr>
							<tr>
		                  		<td height=32 bgcolor=#f2f2f2 align=center><span class=style3>���� �μ�/<br>�ݳ�</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;">
		                  		<span class=style4>�뿩�� �����μ��� ���� ���� 9��~���� 5�� ������ �����մϴ�.<br>�����μ� �� �ݳ���Ҵ� �Ƹ���ī �������� ��Ģ�̸�, �ݳ��ÿ��� Ź�۰����մϴ�.<br>
		                  		 �� Ź�۹ݳ��� �߰������ �ΰ��˴ϴ�. Ź�۷� ��) ���� : 22,000��(�ΰ��� ����)</span></td>
							</tr>
							
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>�뿩��� ����</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>�� �뿩��� 1������ ���ҷ� �����ؾ� �մϴ�.<br>
		                  		�� �뿩��� ����� ���� ����(üũī�� �Ұ�)�� �ſ�ī��� �����ؾ� �մϴ�. <br>&nbsp;&nbsp;&nbsp; (�ſ��� ���� �� ������ ��� ��� �ɻ� �� ���ε� ��쿡 ���Ͽ� ���ݰ����� ����)<br>
		                  		�� 2ȸ�������� �뿩���, ����뿩���, �ߵ����������, ��å�� ���� ��Ÿ ä���� �ſ�ī��� �ڵ���ݵ˴ϴ�.<br>&nbsp;&nbsp;&nbsp; (���� �ſ�ī�� �ڵ���� ��û �ʼ�, 2ȸ�������� �뿩����� �ش� ȸ�� �뿩������ �Ϸ��� �� ����)</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>���� �̿� ��<br>����</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>���� �̿� �� ����(�������, �������� ��ȯ ��)�� �ʿ��� ��� ���� �Ƹ���ī ��������ڿ���<br>�����Ͽ��� �ϸ�,
		                  		 ���� ����� �Ƹ���ī ���������ü�� ���� �湮�� �ּž� �մϴ�.<br>������ �Ƹ���ī���� �����ϸ�, ���κ������ ó���� ���ó���� �ȵ˴ϴ�.</span>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>��� ����</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>���ʰ��Ⱓ���� �����Ͽ� �̿��ϰ��� �� ��쿡�� <span class=style14>��ุ�� 7����</span>������ ����� ������ �޾ƾ� �մϴ�.<br>
		                  		��࿬�� ����� ���Բ��� ���� �Ƹ���ī�� �����ϼž� �ϸ�, ������ ������ ������ �������� �ʴ� ������ �����մϴ�.<br>
		                  		���ڴ����� ������� ���� �뿩�� �������� ���Ұ���Ͽ� ����Ǹ�, �߰������� �Ұ����մϴ�.</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>�ߵ�������</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>�� ���̿�Ⱓ�� <%if(day_cnt==30){%>1����<%}else{%><%=day_cnt%>��<%}%> �̻��� ���: �ܿ��Ⱓ �뿩����� <span class=style14>10%</span>�� ������� �ΰ��˴ϴ�.<br>
		                  		�� ���̿�Ⱓ�� <%if(day_cnt==30){%>1����<%}else{%><%=day_cnt%>��<%}%> �̸��� ���: �Ʒ� 5.�� ������� ����� �����ϴ�.</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>������ ����</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>�� �뿩����� ����Ʈ(�����)�� Ư���� ������ ������ ���� �ʽ��ϴ�. �̿��ڲ����� ������ �����Ͻþ� �̿��Ͻñ� �ٶ��ϴ�.</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>���� �ݳ�<br>���� �ð�</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;">
<!-- 		                  		<span class=style4>���� �ݳ��� ���� 9��~���� 5�ñ��� �� �ּž� �մϴ�.<br> -->
<!-- 		                  		(��, ����(���� 1�� 1��) �� �߼� ������ ���� �ݳ��� �Ұ��մϴ�.)</span> -->
									<span class=style4>����: ���� 9��~���� 5�ñ��� �����ݳ��� �����մϴ�.<br>
		                  			������ �� �����: ���� 9��~12�ñ��� �����ݳ��� �����մϴ�.<br>
		                  			�Ͽ���, ����(���� 1�� 1��) �� �߼� ����: �����ݳ��� �Ұ��Ͽ��� ������ �ݳ��� �ֽñ� �ٶ��ϴ�.</span>
		                  		</td>
							</tr>
		              	</table>
					</td>
		     	</tr>
				<tr> 
					<td height=5 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2" background=../main_car_hp/images/bar_05_rm.gif width=638 height=22 valign=top style="padding-left:125px;"><span class=style11><%if(day_cnt==30){%>1����<%}else{%><%=day_cnt%>��<%}%></span></td>
		   		</tr>
				<tr> 
		            <td height=2 colspan="2"></td>
				</tr>
          		<tr> 
        			<td colspan="2"> 
            			<table width=638 border=0 cellspacing=1 cellpadding=0 bgcolor=c4c4c4>
		                	<tr> 
		                  		<td colspan=31 bgcolor=#ffffff height=13 style="padding:0 5px;">&nbsp;<span class=style4>�Ʒ����ؿ� �ǰ� �̿� �ϼ� ��ŭ�� �뿩�ᰡ ����˴ϴ�. (����: ��, %)</span></td>
		                	</tr>
		                	<tr>
		                		<td height=13 width=92 align=center bgcolor=f2f2f2><span class=style3>�̿� �ϼ�</span></td>
		                		<td bgcolor=#ffffff align=center width=16><span class=style4>1</span></td>
		                		<td bgcolor=#ffffff align=center width=16><span class=style4>2</span></td>
		                		<td bgcolor=#ffffff align=center width=16><span class=style4>3</span></td>
		                		<td bgcolor=#ffffff align=center width=16><span class=style4>4</span></td>
		                		<td bgcolor=#ffffff align=center width=16><span class=style4>5</span></td>
		                		<td bgcolor=#ffffff align=center width=16><span class=style4>6</span></td>
		                		<td bgcolor=#ffffff align=center width=16><span class=style4>7</span></td>
		                		<td bgcolor=#ffffff align=center width=16><span class=style4>8</span></td>
		                		<td bgcolor=#ffffff align=center width=16><span class=style4>9</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>10</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>11</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>12</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>13</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>14</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>15</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>16</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>17</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>18</span></td>
		                		<td bgcolor=#ffffff align=center width=17><span class=style4>19</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>20</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>21</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>22</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>23</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>24</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>25</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>26</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>27</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>28</span></td>
		                		<td bgcolor=#ffffff align=center width=18><span class=style4>29</span></td>
		                		<td bgcolor=#ffffff align=center width=20><span class=style4>30</span></td>
		                	</tr>
							<tr>
						<td height=20 align=center bgcolor=f2f2f2><span class=style3>���뿩�� ���<br>������</span></td>
						<%for (int j = 0 ; j < 30 ; j++){%>
						<td bgcolor=#ffffff align=center><span class=style4><%if(day_per[j]>0){%><%=day_per[j]%><%}%></span></td>
		                		<%}%>
		                	</tr>
		              	</table>
              		</td>
				</tr>
				<tr>
		          	<td height=2></td>
				</tr>
		 		<tr>
					<td colspan=2><span class=style4>�ؿ���) 6�� �̿�� ����뿩��: <%=AddUtil.parseDecimal(tot_rm+tot_rm_v)%>�� �� <%=day_per[5]%>/100 = <%=AddUtil.parseDecimal((tot_rm+tot_rm_v)*day_per[5]/100)%>��&nbsp;(���� ī����� ��� ��, ����뿩��� �ٽ� ������)</span></td>
				</tr>
		 		<tr> 
		            <td colspan="2"><img src=/acar/main_car_hp/images/bar_06_rm.gif width=638 height=22></td>
				</tr>
				<tr> 
		            <td height=2 colspan="2"></td>
				</tr>
		   		<tr> 
		            <td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=0 bgcolor=c4c4c4>
		                	<tr> 
		                  		<td colspan=31 bgcolor=#ffffff height=24  style="padding:0 5px;"><span class=style4>���� ��å������ ���� ��� �߻���, �뿩������ �����Ⱓ�� �ش��ϴ� �뿩���(�Ƹ���ī �ܱⷻƮ ���ǥ ����)�� 50%�� ���� �δ��Ͽ��� �մϴ�. (�ڵ����뿩 ǥ�ؾ�� �� 19���� ����)</span></td>
		                	</tr>
		                	<tr>
		                		<td width=92 align=center bgcolor=f2f2f2 rowspan=3><span class=style3>�Ƹ���ī<br>�ܱⷻƮ ���</span></td>
		                		<td width=259 align=center bgcolor=f2f2f2 height=13><span class=style3>�뿩����</span></td>
		                		<td width=280 align=center bgcolor=f2f2f2 colspan=4><span class=style3>�뿩�Ⱓ�� 1�Ͽ�� (�ΰ��� ����)</span></td>
		                	</tr>
		                	<tr>
		                		<td height=13 bgcolor=#ffffff align=center rowspan=2><span class=style4><%=ej_bean.getJg_v()%></span></td>
		                		<td bgcolor=#ffffff align=center width=70 height=13><span class=style4>1~2��</span></td>
		                		<td bgcolor=#ffffff align=center width=70><span class=style4>3~4��</span></td>
		                		<td bgcolor=#ffffff align=center width=70><span class=style4>5~6��</span></td>
		                		<td bgcolor=#ffffff align=center width=70><span class=style4>7���̻�</span></td>
		                	</tr>
		                	<tr>
		                		<td bgcolor=#ffffff align=center height=13><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_01d()*1.1)%>��</span></td>
		                		<td bgcolor=#ffffff align=center><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_03d()*1.1)%>��</span></td>
		                		<td bgcolor=#ffffff align=center><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_05d()*1.1)%>��</span></td>
		                		<td bgcolor=#ffffff align=center><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_07d()*1.1)%>��</span></td>
		                	</tr>
		              	</table>
		            </td>
          		</tr>
 
<%if(!e_bean.getDoc_type().equals("")){%>
	          	<tr> 
	            	<td colspan="2"><img src=/acar/main_car_hp/images/bar_07_rm.gif width=638 height=22></td>
	          	</tr>
	          	<tr> 
	            	<td height=2 colspan="2"></td>
	          	</tr>
<%}%>	          	
 <%if(e_bean.getDoc_type().equals("1")){%>	
	          	<tr> 
            		<td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=2 bgcolor=c4c4c4>
		                	<tr>
		                		<td width=86 align=center bgcolor=f2f2f2><span class=style3>����</span></td>
		                		<td width=543 bgcolor=ffffff><span class=style4>�ʼ� ���⼭��: ����ڵ���� �纻, ���ε��ε 1��, �����ΰ����� 1��, �ֿ����� ����������, �ڵ���ü���� �纻<br>
		                		�ʿ�� ���⼭��: ��ǥ�� �ΰ����� 1��, �ֿ����� ����������<br>
		                		���ΰ������� �ֱ� 3�����̳� ����� ���̶�� �մϴ�. ��༭ �ۼ���: ����, �ΰ����� ����</span></td>
		                	</tr>
		              	</table>
            		</td>
          		</tr>
          		<tr>
		          	<td height=2></td>
		    	</tr>
		   		<tr>
		          	<td colspan="2"><span class=style3>[ �Աݰ��� : �������� 140-004-023871 (��)�Ƹ���ī ]</span></td>
		   		</tr>
<%}else if(e_bean.getDoc_type().equals("2")){%>
    <!-- ���λ����-->      
          		<tr> 
		            <td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=2 bgcolor=c4c4c4>
		                	<tr>
		                		<td width=86 align=center bgcolor=f2f2f2><span class=style3>���λ����</span></td>
		                		<td width=543 bgcolor=ffffff><span class=style4>����ڵ���� �纻, ��ǥ�� �ź���, �ֿ����� ������, �ſ�ī��, �ڵ���ü���� �纻<br>
		                		�ذ�༭ ����� ���� �μ��� ����� ������ ���� �Ͽ��� �մϴ�.</span></td>
		                	</tr>
		              	</table>
		            </td>
          		</tr>
          		<tr>
		          	<td height=2></td>
		    	</tr>
		   		<tr>
		          	<td colspan="2"><span class=style3>[ �Աݰ��� : �������� 140-004-023871 (��)�Ƹ���ī ]</span></td>
		   		</tr>
     <!-- ����-->
    <%}else if(e_bean.getDoc_type().equals("3")){%>
    			<tr> 
            		<td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=2 bgcolor=c4c4c4>
		                	<tr>
		                		<td width=86 align=center bgcolor=f2f2f2><span class=style3>����</span></td>
		                		<td width=543 bgcolor=ffffff><span class=style4>����������, �ſ�ī��, �ڵ���ü���� �纻<br>
		                		�ذ�༭ ����� ���� �μ��� ����� ������ ���� �Ͽ��� �մϴ�.</span></td>
		                	</tr>
		              	</table>
            		</td>
          		</tr>
          		<tr>
		          	<td height=2></td>
		    	</tr>
		   		<tr>
		          	<td colspan="2"><span class=style3>[ �Աݰ��� : �������� 140-004-023871 (��)�Ƹ���ī ]</span></td>
		   		</tr>
   	<%}else{%>
          		<!-- �Աݰ���-->
          		<tr>
	          		<td height=5></td>
	          	</tr>
   	<%}%>
	<!--�ʿ伭��ǥ�� end-->	

		  <%if(mail_yn.equals("")){%>
	          	<tr> 
	            	<td align=right><img src=/acar/main_car_hp/images/ceo.gif>&nbsp;</td>
	            	<td align=right>&nbsp;&nbsp;</td>
	          	</tr>
			  <%}else{%>
	          	<tr> 
	          		<td align=right><img src=/acar/main_car_hp/images/ceo.gif>&nbsp;</td>
	            	<td align=right>&nbsp;&nbsp;</td>
	          	</tr>
		  <%}%>		  		  		  
        	</table>
        </td>
        <td width=21>&nbsp;</td>
    </tr>
    <tr>
    	<td height=5></td>
    </tr>
	<tr bgcolor=80972e>
        <td height=4 colspan=3></td>
    </tr>
</table>

</html>
<script>
onprint();

//5���Ŀ� �μ�ڽ� �˾�
//setTimeout(onprint_box,5000);

onprint_box();


function IE_Print(){
	factory.printing.header 	= ""; //��������� �μ�
	factory.printing.footer 	= ""; //�������ϴ� �μ�
	factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
	factory.printing.leftMargin 	= 10.0; //��������   
	factory.printing.rightMargin 	= 10.0; //��������
	factory.printing.topMargin 	= 10.0; //��ܿ���    
	factory.printing.bottomMargin 	= 10.0; //�ϴܿ���
}

function onprint(){
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}

function onprint_box(){
	factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>