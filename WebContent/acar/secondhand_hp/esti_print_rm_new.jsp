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
	
	//견적정보
	EstimateBean e_bean = new EstimateBean();
	
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp") || from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp") || from_page.equals("/acar/secondhand/secondhand_sc.jsp")||from_page.equals("off_lease_sc.jsp")){		//FMS 재리스결정차량에서 기본견적서/조정견적서
		e_bean = e_db.getEstimateCase(est_id);
		if(today_dist.equals(""))	today_dist = String.valueOf(e_bean.getToday_dist());
	}else{									//홈페이지 재리스차량 견적서
		e_bean = e_db.getEstimateShCase(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}
	
	if(e_bean.getOpt_chk().equals("1") && opt_chk.equals("0")) 	opt_chk 	= e_bean.getOpt_chk();
	
	//잔가 차량정보
	Hashtable sh_comp = new Hashtable();
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp") || from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp") || from_page.equals("/acar/secondhand/secondhand_sc.jsp")||from_page.equals("off_lease_sc.jsp")){
		sh_comp = shDb.getShCompare(est_id);
		
	}else{
		sh_comp = shDb.getShCompareSh(est_id);
	}
	
	//차종정보	
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	//차종별변수
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());				
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);
	
	//단기요금표
	ShortFeeMngBean sf_bean = sfm_db.getShortFeeMngCase(ej_bean.getJg_r(), "2", e_bean.getRent_dt());	
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
		
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
	String vali_date = ""; 
	
	//if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
	//	vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 4));
	//	if(e_bean.getMgr_ssn().equals("연장견적") && !e_bean.getEst_from().equals("ext_car")) 	vali_date = AddUtil.getDate3(rs_db.addMonth(e_bean.getReg_dt().substring(0,8), 1));
	//}
	
	//연락처----------------------------------------------------------------
	
	String name 	= "";
	String tel 	= "";
	String m_tel	= "";
	String h_tel	= "";
	String i_fax	= "";
	String email	= "";
	String h_tels 	= "";	
	String week_st 	= c_db.getWeek_st(AddUtil.getDate());  		//1:일요일 , 7:토요일
	int hol_cnt 	= c_db.getHoliday_st(AddUtil.getDate());  	//휴일
	
	//월렌트 홈페이지에서 넘긴 지역구분
	String br_id = request.getParameter("br_id")	==null?"":request.getParameter("br_id");
	
	
	String watch_id = c_db.getWatch_id(AddUtil.getDate() );  // 본사 인터넷 당직
		
	
	//근무시간내:08:30~20:30 회사전화번호 그후 개인전화번호:서울본사인경우. 지점은 지점번호 노출 
	int t_time = Integer.parseInt(AddUtil.getTime().substring(11,13) + AddUtil.getTime().substring(14,16));
	//default :서울본사 전화번호
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
	
	//20121106 월렌트홈페이지에서 넘긴 지역에 따라 연락처 표시
	if(br_id.equals("B1")){
		name 	= "부산";
		h_tel 	=  "051-851-0606";			
	}else if(br_id.equals("D1")){
		name 	= "대전";
		h_tel 	=  "042-824-1770";				
	}else{
		name 	= "서울";
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
	
		if(name.equals("서울")){
			h_tel 	=  "02-392-4242";	
		}	
		
	}
	
	
	/*
	if(!e_bean.getReg_id().equals("") && e_bean.getReg_id().length() == 6){
		UsersBean user_bean 	= umd.getUsersBean(e_bean.getReg_id());
		name 	= user_bean.getUser_nm();
		tel 	= user_bean.getUser_m_tel();
	}*/
	
	
	//특정사원이 견적한 경우에는 견적담당자로 표기	
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
			m_tel 		=   "070-8224-8670"; //내근직은 휴대전호표시 안함.
		}else {
			m_tel 		= user_bean.getUser_m_tel();	
		}
			
		h_tel 	=  "02-392-4242"; //핫라인 필요없음.
		//20170123 담당자 소속 지점에 따라 연락처 표시
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
	
	//20120830 월렌트홈페이지 적용	
	
	int months 		= request.getParameter("months")	==null?0:AddUtil.parseDigit(request.getParameter("months"));
	int days 		= request.getParameter("days")		==null?0:AddUtil.parseDigit(request.getParameter("days"));
	int tot_rm 		= request.getParameter("tot_rm")	==null?0:AddUtil.parseDigit(request.getParameter("tot_rm"));
	int tot_rm1 		= request.getParameter("tot_rm1")	==null?0:AddUtil.parseDigit(request.getParameter("tot_rm1"));
	String per 		= request.getParameter("per")		==null?"":request.getParameter("per");
	String navi_yn 		= request.getParameter("navi_yn")	==null?"":request.getParameter("navi_yn");
	
	
	//월렌트리스트 링크가 아닌경우
	if(months == 0 && days == 0 && tot_rm == 0 && tot_rm1 == 0 && per.equals("")){
		months 	= 1;
		per	= "0";
		tot_rm	= e_bean.getFee_s_amt();
		tot_rm1	= tot_rm;
	}		
	
	int tot_rm_v 	= 0;
	int tot_rm1_v 	= 0;
	
	//월대여료대부 적용율
	Hashtable day_pers = shDb.getEstiRmDayPers(per);
	
	int day_per[] = new int[30];

	//적용율값 카운트
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
	
	//월렌트 담당자인 김태연씨 휴가일때는 영업팀 권용식씨로 대체
	if(acar_id.equals("000153")){
		//휴가여부
		String today_free_id = umd.getCarScheTodayChk(acar_id);
		
		if(today_free_id.equals(acar_id)){
			acar_id = "000144";
			UsersBean user_bean 	= umd.getUsersBean(acar_id);
			name 		= user_bean.getUser_nm();
			tel 		= user_bean.getUser_m_tel();
			br_id 		= user_bean.getBr_id();
			m_tel 		=  "070-8224-8670"; //고객지원팀	
		//	m_tel 		= user_bean.getUser_m_tel();	
			h_tel 		=  "02-392-4242"; //핫라인 필요없음.	
			//20170123 담당자 소속 지점에 따라 연락처 표시
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
		//	h_tel 		= user_bean.getHot_tel();  ///월렌트 핫라인 필요없음.
		}
	}		
%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>견적서</title>
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
        /* margin으로 프린트 여백 조정 */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*상단*/
		-webkit-margin-end: 0mm; /*우측*/
		-webkit-margin-after: 0mm; /*하단*/
		-webkit-margin-start: 0mm; /*좌측*/
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
					vali_date = "미확정 견적입니다.";
				}%>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>작성일</span></td>
                                <td width=97 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
			    <%if(!vali_date.equals("")){%>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>유효기간</span></td>
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
				                            <%if(client_st.equals("2")){%>귀하<%}else{%>귀중<%}%></span></div></td>
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
			                      	<%if(name.equals("서울")){%>
				                  	<table width=201 border=0 cellpadding=0 cellspacing=0 style="background:url(../main_car_hp/images/tel_bg_new_1.gif) no-repeat;background-size:201px 110px;">
						   									<tr> 
				                        		<td colspan=4 height=10></td>
					                			</tr>
					               		
										  					<tr> 
					                        	<td width=70 align=right valign=top height=13>&nbsp;<span class=style5>여의도</span></td>
					                        	<td width=141 valign=top style="padding-left:20px;"><span class=style5>02-757-0802</span></td>
					                      </tr>
					                   		<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>광화문</span></td>
					                        	<td style="padding-left:20px;"><span class=style5>02-2038-8661</span></td>
					                      </tr>
					                    	<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>강남</span></td>
					                        	<td style="padding-left:20px;"><span class=style5>02-537-5877</span></td>
					                      </tr>
					                 			<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>송파</span></td>
					                        	<td height=13 style="padding-left:20px;"><span class=style5>02-2038-2492</span></td>
					                      </tr>
											<tr> 
					                        	<td align=right  height=13>&nbsp;<span class=style5>인천</span></td>
					                        	<td style="padding-left:20px;"><span class=style5>032-554-8820</span></td>
					                      </tr>
										 <tr> 
					                        	<td align=right  height=13>&nbsp;<span class=style5>수원</span></td>
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
				                          <span class=style5>서울본사</span></td>
				                      </tr>
				                                
				                      <tr> 
				                        <td>&nbsp;</td>
				                        <td height=14 class=listnum2><span class=style5><%if(br_id.equals("S1")){%><%= tel %><%= name %><%}else{%>02-757-0802<%}%></span></td>
				                      </tr> 
				                                   
				                      <tr> 
				                        <td>&nbsp;</td>
				                        <td class=listnum2><img src=/acar/main_car_hp/images/dot1.gif width=4 height=4 align=absmiddle> 
				                          <span class=style5>부산지점</span></td>
				                      </tr>
				                      <tr> 
				                        <td>&nbsp;</td>
				                        <td height=14 class=listnum2><span class=style5><%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>051-851-0606<%}%></span></td>
				                      </tr> 
				                      <tr> 
				                        <td>&nbsp;</td>
				                        <td class=listnum2><img src=/acar/main_car_hp/images/dot1.gif width=4 height=4 align=absmiddle> 
				                          <span class=style5>대전지점</span></td>
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
			                  	<td colspan="3">&nbsp;※ 귀사에서 문의하신 장기대여에 대하여 아래와 같이 견적을 제출하오니 
			                    검토하시고 좋은 답변 부탁드립니다.</td>
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
			                  <td width=122 height=13 align=center bgcolor=f2f2f2><span class=style3>제조사</span></td>
			                  <td width=368 bgcolor=#FFFFFF>&nbsp;<span class=style3><%= c_db.getNameById(car_comp_id, "CAR_COM") %></span></td>
			                  <td width=144 align=center bgcolor=f2f2f2><span class=style3>금 
			                    액</span></td>
			                </tr>
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>차종(차량모델명)</span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%=car_name%></b></span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getCar_amt()) %>
			                    원</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>옵 
			                    션</span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%=opt%></b></span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style3><%= AddUtil.parseDecimal(opt_amt) %>
			                    원</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>색 
			                    상 </span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%if(!e_bean.getIn_col().equals("")){%>외장: <%}%><%=colo%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;내장: <%=e_bean.getIn_col()%><%}%></b></span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style3><%= AddUtil.parseDecimal(clr_amt) %>
			                    원</span>&nbsp;</td>
			                </tr>
                <!-- 신차 개소세 감면 추가(2017.10.13) -->
                <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
                <tr>
                	<td height=15 align=center bgcolor=f2f2f2><span class=style3>신차 개소세 감면 </span></td>
                    <td bgcolor=#FFFFFF>
                    </td>
                    <td align=right bgcolor=#FFFFFF><span class=style4> - <%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 원</span>&nbsp;</td>
                </tr>
                <%}%>			                
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>감가상각
			                   </span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3>신차등록일 : <%=AddUtil.ChangeDate2(init_reg_dt)%>&nbsp;&nbsp;&nbsp;&nbsp;주행거리 : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km</span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style3>-<%= AddUtil.parseDecimal(dlv_car_amt) %>
							    원</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>차량가격</span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3>차량번호 : <%if(!car_no.equals("")){ out.println("****"+car_no.substring(car_no.length()-4, car_no.length())); } %>
			                      <!--<%if(!dist_cng.equals("") && spe_dc_per==0){%>&nbsp;주행거리 확인 및 대여요금 조정 필요<%}else if(!dist_cng.equals("") && spe_dc_per > 0){%>&nbsp;실주행거리 대여요금에 반영완료<%}%>-->
			                  </span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style3><b><%=AddUtil.parseDecimal(e_bean.getO_1())%>
			                    원</b></span>&nbsp;</td>
			                </tr>
		              	</table>
					</td>
				</tr>
				<tr> 
		            <td height=10 colspan="2" align="right">
		            <%if(cm_bean.getJg_code().equals("1232") || cm_bean.getJg_code().equals("1242") || cm_bean.getJg_code().equals("1021212") || cm_bean.getJg_code().equals("1023112")){//모닝바이퓨엘,레이%>
					<span class=style4>※ LPG/휘발유 겸용차</span>	
					<%}else{%>						
					<%	if(String.valueOf(sh_comp.get("ENGIN")).equals("Y")){%>		※ 디젤엔진
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("2")){%>	<span class=style4>※ LPG전용차</span>
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("1")){%>	※ 가솔린엔진
					<%	}else{%>
						<%if(cm_bean.getDiesel_yn().equals("Y")){%>			※ 디젤엔진
						<%}else if(cm_bean.getDiesel_yn().equals("2")){%>		<span class=style4>※ LPG전용차</span>
						<%}else if(cm_bean.getDiesel_yn().equals("1")){%>		※ 가솔린엔진
						<%}%>
					<%	}%>
					<%}%>	</span>		
					</td>
				</tr>
          <%if(!dist_cng.equals("")){%>
          <tr>
          	<td colspan="2" bgcolor=f2f2f2 height=40> &nbsp;<span class=style3> * 위 차량은 계기판 교환 이력(<%=AddUtil.getDate3(cha_st_dt)%>)이 있는 차량으로 계기판 교환전 주행거리는 <%=AddUtil.parseDecimal(b_dist)%>km, 교환후<br>
          	&nbsp;&nbsp;&nbsp;&nbsp;현 계기판의 주행거리는 <%=AddUtil.parseDecimal(AddUtil.parseInt(today_dist)-AddUtil.parseInt(b_dist))%>km입니다. 감가상각 계산시에는 주행거리를 <%=AddUtil.parseDecimal(today_dist)%>km로 적용하고, 사고수리에<br>
          	&nbsp;&nbsp;&nbsp;&nbsp;따른 시세하락을 반영하였습니다.</span></td>
          </tr>
          <%}%>
				
				<tr> 
		            <td colspan="2"> 
		            	<table width=638 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=231><%if(navi_yn.equals("")){%><a href=javascript:go_navi_esti('Y'); title='내비게이션포함 견적보기'><img src=/acar/main_car_hp/images/bar_02_1_rm_new.gif border=0></a><%}else{%><img src=/acar/main_car_hp/images/bar_02_rm_new.gif><%}%></td>
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
				                        <td width=94 height=13 align=center bgcolor=f2f2f2><span class=style3>대여기간</span></td>
				                      	<td width=137 align=center bgcolor=#FFFFFF><span class=style3>1개월</span></td>
				                      </tr>
									  <%		if(navi_yn.equals("Y")){
									  			tot_rm 	= tot_rm+25000;
									  			//tot_rm1 = Math.round((tot_rm * months + tot_rm * days/30)/100)*100;  //산출대여료- 0개월 0일
									  			tot_rm1 = Math.round((tot_rm * months + tot_rm * days/30));  //산출대여료- 0개월 0일
									  		}
									  		
									  		tot_rm_v 	= tot_rm/10;
									  		tot_rm1_v 	= tot_rm1/10;
									  %>
				                      <tr> 
				                        <td height=13 align=center bgcolor=f2f2f2><span class=style3>공 
				                          급 가 </span></td>
				                          <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(tot_rm)%> 
				                          원</span>&nbsp;&nbsp;</td>
				                      </tr>
				                      <tr> 
				                        <td height=13 align=center bgcolor=f2f2f2><span class=style3>부 
				                          가 세 </span></td>
				                          <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(tot_rm_v)%> 
				                          원</span>&nbsp;&nbsp;</td>
				                      </tr>
				                      <tr> 
				                        <td height=13 align=center bgcolor=f2f2f2><span class=style3>대여금액</span></td>
				                          <td align=right bgcolor=#FFFFFF><span class=style3><b><%=AddUtil.parseDecimal(tot_rm+tot_rm_v)%> 
				                          원</b></span>&nbsp;&nbsp;</td>
				                      </tr>
				                    </table>
								</td>
			                  	<td>&nbsp;</td>
			                  	<td> 
							  <%if(!e_bean.getIns_per().equals("2")){%>
									<table width=397 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
							        	<tr> 
							          		<td width=85 height=13 align=center bgcolor=f2f2f2><span class=style3>대인배상</span></td>
							            	<td width=118 align=center bgcolor=#FFFFFF><span class=style3>무한(대인 
							                          Ⅰ,Ⅱ) </span></td>
							            	<td width=85 align=center bgcolor=f2f2f2><span class=style3>자차면책금</span></td>
							             	<td width=109 align=center bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>원</span></td>
							         	</tr>
							         	<tr> 
							             	<td height=13 align=center bgcolor=f2f2f2><span class=style3>대물배상</span></td>
							             	<td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_dj().equals("1")){%>5천만원<%}else if(e_bean.getIns_dj().equals("4")){%>2억원<%}else{%>1억원<%}%></span></td>
							              	<td align=center bgcolor=f2f2f2><span class=style3>무보험차상해</span></td>
							             	<td align=center bgcolor=#FFFFFF><span class=style3>1인당최고2억원</span></td>
							                        
							        	</tr>
							       		<tr> 
								      		<td height=13 align=center bgcolor=f2f2f2><span class=style3>자기신체사고</span></td>
								       		<td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_dj().equals("1")){%>5천만원<%}else{%>1억원<%}%></span></td>
								      		<td align=center bgcolor=f2f2f2><span class=style3>운전자연령</span></td>
								       		<td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean.getIns_age().equals("3")){%>만24세이상<%}else{%>만26세이상<%}%></span></td>
							       		</tr>
							        	<tr> 
								         	<td height=17 align=center bgcolor=f2f2f2><span class=style3>운전자범위</span></td>
								         	<td align=center bgcolor=#FFFFFF colspan=3><span class=style3>계약자 및 계약서상 명시된 추가운전자</span></td>
							        	</tr>
						        	</table>                   
								<%}else{%>
									<table width=397 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
							     		<tr> 
											<td width=85 height=13 align=center bgcolor=f2f2f2><span class=style3>대인배상</span></td>
								  			<td width=97 align=center bgcolor=#FFFFFF><span class=style3>보험미반영</span></td>
								    		<td width=85 align=center bgcolor=f2f2f2><span class=style3>자차면책금</span></td>
								   			<td width=87 align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
							       		</tr>
							       		<tr> 
								         	<td height=13 align=center bgcolor=f2f2f2><span class=style3>대물배상</span></td>
								       		<td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
								        	<td align=center bgcolor=f2f2f2><span class=style3>무보험차상해</span></td>
								      		<td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
							        	</tr>
							      		<tr> 
								        	<td height=13 align=center bgcolor=f2f2f2><span class=style3>자기신체사고</span></td>
								       		<td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
								      		<td align=center bgcolor=f2f2f2><span class=style3>운전자연령</span></td>
								     		<td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
							        	</tr>
							       		<tr> 
								        	<td height=13 align=center bgcolor=f2f2f2><span class=style3>운전자범위</span></td>
								     		<td align=center bgcolor=#FFFFFF colspan=3><span class=style4>보험미반영</span></td>
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
					<td colspan="2" height=20><span class=style17>필수 확인사항</span></td>
				</tr>
          		<tr> 
            		<td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                	<tr> 
		                  		<td width=90 height=17 align=center bgcolor=f2f2f2><span class=style3>운전자격요건</span></td>
		                  		<td width=543 bgcolor=#FFFFFF style="padding:3px 5px;"> <span class=style4>만 26세이상 면허취득 3년이상인 대한민국 운전면허증 소지자(아마존카 월렌트는 26세미만 보험 운영않음)<br>※ 국적이 대한민국인 사람만 이용가능</span></td>
		                  	</tr>
							<tr>
								<td height=17 bgcolor=#f2f2f2 align=center><span class=style3>대여료 결제</span></td>
								<td bgcolor=#FFFFFF style="padding:3px 5px;" ><span class=style4>대여료는 계약자 본인 명의(법인의 경우 법인 명의)의 신용카드로 결제해야 합니다.(체크카드 불가)<br>
									※ 법인카드는 기명식 카드(카드에 이용자 개인 이름이 찍혀있는 법인카드)만 가능합니다.
									</span></td>
							</tr>
							<tr>
								<td height=17 bgcolor=#f2f2f2 align=center><span class=style3>운전자 범위</span></td>
								<td bgcolor=#FFFFFF style="padding:3px 5px;"><span class=style4>일반개인 : 본인만 운전가능 (단, 배우자에 한하여 사전 심사 후 추가 가능)<br>
								개인사업자 : 계약자(개인사업자) 및 사전에 면허증이 접수된 직원 1인만 운전 가능(임직원 한정운전 특약 가입)<br>
								 법인 : 사전에 면허증이 접수된 직원 2인만 운전 가능(임직원 한정운전 특약 가입) </span></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" height=20><span class=style17>일반 확인사항</span></td>
				</tr>
				<tr>
					<td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
							<tr>
		                  		<td width=90 height=17 bgcolor=#f2f2f2 align=center><span class=style3>약정운행거리</span></td>
		                  		<td width=543 bgcolor=#ffffff style="padding:3px 5px;"><span class=style4><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km / 1개월, 초과시 1km당 <span class=style14><%=e_bean.getOver_run_amt()%></span>원(부가세별도)의 초과운행대여료가 부과됩니다(대여종료시)</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>예약관련</span></td>
		                  		<td height=17 bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>홈페이지를 통해서 차량 예약이 가능하고, 당사 직원과 상담을 통해서도 차량예약이 가능합니다.<br>
								예약 기한은 근무일 기준 익일 16시까지 입니다. 예약 기한 내에 계약을 진행하셔야 예약이 취소되지 않습니다. </span></td>
							</tr>
							<tr>
		                  		<td height=32 bgcolor=#f2f2f2 align=center><span class=style3>차량 인수/<br>반납</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;">
		                  		<span class=style4>대여시 차량인수는 평일 오전 9시~오후 5시 내에만 가능합니다.<br>차량인수 및 반납장소는 아마존카 주차장이 원칙이며, 반납시에는 탁송가능합니다.<br>
		                  		 ※ 탁송반납시 추가요금이 부과됩니다. 탁송료 예) 서울 : 22,000원(부가세 포함)</span></td>
							</tr>
							
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>대여요금 결제</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>① 대여료는 1개월씩 선불로 결제해야 합니다.<br>
		                  		② 대여료는 계약자 본인 명의(체크카드 불가)의 신용카드로 결제해야 합니다. <br>&nbsp;&nbsp;&nbsp; (신용우수 개인 및 법인의 경우 당사 심사 후 승인된 경우에 한하여 현금결제도 가능)<br>
		                  		③ 2회차부터의 대여요금, 연장대여요금, 중도해지위약금, 면책금 등의 기타 채무는 신용카드로 자동출금됩니다.<br>&nbsp;&nbsp;&nbsp; (계약시 신용카드 자동출금 신청 필수, 2회차부터의 대여요금은 해당 회차 대여시작일 하루전 날 결제)</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>차량 이용 중<br>정비</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>차량 이용 중 정비(고장수리, 엔진오일 교환 등)가 필요한 경우 필히 아마존카 관리담당자에게<br>연락하여야 하며,
		                  		 차량 정비시 아마존카 지정정비업체로 직접 방문해 주셔야 합니다.<br>정비비는 아마존카에서 지불하며, 개인비용으로 처리시 비용처리가 안됩니다.</span>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>계약 연장</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>최초계약기간보다 연장하여 이용하고자 할 경우에는 <span class=style14>계약만료 7일전</span>까지는 당사의 승인을 받아야 합니다.<br>
		                  		계약연장 희망시 고객님께서 먼저 아마존카로 연락하셔야 하며, 고객님의 연락이 없으면 연장하지 않는 것으로 간주합니다.<br>
		                  		일자단위로 연장계약시 전월 대여료 기준으로 일할계산하여 적용되며, 추가연장이 불가능합니다.</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>중도해지시</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>① 실이용기간이 <%if(day_cnt==30){%>1개월<%}else{%><%=day_cnt%>일<%}%> 이상일 경우: 잔여기간 대여요금의 <span class=style14>10%</span>의 위약금이 부과됩니다.<br>
		                  		② 실이용기간이 <%if(day_cnt==30){%>1개월<%}else{%><%=day_cnt%>일<%}%> 미만일 경우: 아래 5.의 요금정산 방법을 따릅니다.</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>유류대 정산</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>본 대여계약은 월렌트(장기계약)의 특성상 유류대 정산을 하지 않습니다. 이용자께서는 이점을 감안하시어 이용하시기 바랍니다.</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>차량 반납<br>가능 시간</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;">
<!-- 		                  		<span class=style4>차량 반납은 오전 9시~오후 5시까지 해 주셔야 합니다.<br> -->
<!-- 		                  		(단, 설날(음력 1월 1일) 및 추석 당일은 차량 반납이 불가합니다.)</span> -->
									<span class=style4>평일: 오전 9시~오후 5시까지 차량반납이 가능합니다.<br>
		                  			공휴일 및 토요일: 오전 9시~12시까지 차량반납이 가능합니다.<br>
		                  			일요일, 설날(음력 1월 1일) 및 추석 당일: 차량반납이 불가하오니 다음날 반납해 주시기 바랍니다.</span>
		                  		</td>
							</tr>
		              	</table>
					</td>
		     	</tr>
				<tr> 
					<td height=5 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2" background=../main_car_hp/images/bar_05_rm.gif width=638 height=22 valign=top style="padding-left:125px;"><span class=style11><%if(day_cnt==30){%>1개월<%}else{%><%=day_cnt%>일<%}%></span></td>
		   		</tr>
				<tr> 
		            <td height=2 colspan="2"></td>
				</tr>
          		<tr> 
        			<td colspan="2"> 
            			<table width=638 border=0 cellspacing=1 cellpadding=0 bgcolor=c4c4c4>
		                	<tr> 
		                  		<td colspan=31 bgcolor=#ffffff height=13 style="padding:0 5px;">&nbsp;<span class=style4>아래기준에 의거 이용 일수 만큼의 대여료가 적용됩니다. (단위: 일, %)</span></td>
		                	</tr>
		                	<tr>
		                		<td height=13 width=92 align=center bgcolor=f2f2f2><span class=style3>이용 일수</span></td>
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
						<td height=20 align=center bgcolor=f2f2f2><span class=style3>월대여료 대비<br>적용율</span></td>
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
					<td colspan=2><span class=style4>※예시) 6일 이용시 적용대여료: <%=AddUtil.parseDecimal(tot_rm+tot_rm_v)%>원 × <%=day_per[5]%>/100 = <%=AddUtil.parseDecimal((tot_rm+tot_rm_v)*day_per[5]/100)%>원&nbsp;(기존 카드결제 취소 후, 적용대여료로 다시 결제함)</span></td>
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
		                  		<td colspan=31 bgcolor=#ffffff height=24  style="padding:0 5px;"><span class=style4>고객의 귀책사유에 의한 사고 발생시, 대여차량의 수리기간에 해당하는 대여요금(아마존카 단기렌트 요금표 기준)의 50%를 고객이 부담하여야 합니다. (자동차대여 표준약관 제 19조에 의함)</span></td>
		                	</tr>
		                	<tr>
		                		<td width=92 align=center bgcolor=f2f2f2 rowspan=3><span class=style3>아마존카<br>단기렌트 요금</span></td>
		                		<td width=259 align=center bgcolor=f2f2f2 height=13><span class=style3>대여차량</span></td>
		                		<td width=280 align=center bgcolor=f2f2f2 colspan=4><span class=style3>대여기간별 1일요금 (부가세 포함)</span></td>
		                	</tr>
		                	<tr>
		                		<td height=13 bgcolor=#ffffff align=center rowspan=2><span class=style4><%=ej_bean.getJg_v()%></span></td>
		                		<td bgcolor=#ffffff align=center width=70 height=13><span class=style4>1~2일</span></td>
		                		<td bgcolor=#ffffff align=center width=70><span class=style4>3~4일</span></td>
		                		<td bgcolor=#ffffff align=center width=70><span class=style4>5~6일</span></td>
		                		<td bgcolor=#ffffff align=center width=70><span class=style4>7일이상</span></td>
		                	</tr>
		                	<tr>
		                		<td bgcolor=#ffffff align=center height=13><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_01d()*1.1)%>원</span></td>
		                		<td bgcolor=#ffffff align=center><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_03d()*1.1)%>원</span></td>
		                		<td bgcolor=#ffffff align=center><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_05d()*1.1)%>원</span></td>
		                		<td bgcolor=#ffffff align=center><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_07d()*1.1)%>원</span></td>
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
		                		<td width=86 align=center bgcolor=f2f2f2><span class=style3>법인</span></td>
		                		<td width=543 bgcolor=ffffff><span class=style4>필수 제출서류: 사업자등록증 사본, 법인등기부등본 1통, 법인인감증명서 1통, 주운전자 운전면허증, 자동이체통장 사본<br>
		                		필요시 제출서류: 대표자 인감증명서 1통, 주운전자 운전면허증<br>
		                		※인감증명서는 최근 3개월이내 발행된 것이라야 합니다. 계약서 작성시: 명판, 인감도장 날인</span></td>
		                	</tr>
		              	</table>
            		</td>
          		</tr>
          		<tr>
		          	<td height=2></td>
		    	</tr>
		   		<tr>
		          	<td colspan="2"><span class=style3>[ 입금계좌 : 신한은행 140-004-023871 (주)아마존카 ]</span></td>
		   		</tr>
<%}else if(e_bean.getDoc_type().equals("2")){%>
    <!-- 개인사업자-->      
          		<tr> 
		            <td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=2 bgcolor=c4c4c4>
		                	<tr>
		                		<td width=86 align=center bgcolor=f2f2f2><span class=style3>개인사업자</span></td>
		                		<td width=543 bgcolor=ffffff><span class=style4>사업자등록증 사본, 대표자 신분증, 주운전자 면허증, 신용카드, 자동이체통장 사본<br>
		                		※계약서 서명과 차량 인수는 계약자 본인이 직접 하여야 합니다.</span></td>
		                	</tr>
		              	</table>
		            </td>
          		</tr>
          		<tr>
		          	<td height=2></td>
		    	</tr>
		   		<tr>
		          	<td colspan="2"><span class=style3>[ 입금계좌 : 신한은행 140-004-023871 (주)아마존카 ]</span></td>
		   		</tr>
     <!-- 개인-->
    <%}else if(e_bean.getDoc_type().equals("3")){%>
    			<tr> 
            		<td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=2 bgcolor=c4c4c4>
		                	<tr>
		                		<td width=86 align=center bgcolor=f2f2f2><span class=style3>개인</span></td>
		                		<td width=543 bgcolor=ffffff><span class=style4>운전면허증, 신용카드, 자동이체통장 사본<br>
		                		※계약서 서명과 차량 인수는 계약자 본인이 직접 하여야 합니다.</span></td>
		                	</tr>
		              	</table>
            		</td>
          		</tr>
          		<tr>
		          	<td height=2></td>
		    	</tr>
		   		<tr>
		          	<td colspan="2"><span class=style3>[ 입금계좌 : 신한은행 140-004-023871 (주)아마존카 ]</span></td>
		   		</tr>
   	<%}else{%>
          		<!-- 입금계좌-->
          		<tr>
	          		<td height=5></td>
	          	</tr>
   	<%}%>
	<!--필요서류표기 end-->	

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

//5초후에 인쇄박스 팝업
//setTimeout(onprint_box,5000);

onprint_box();


function IE_Print(){
	factory.printing.header 	= ""; //폐이지상단 인쇄
	factory.printing.footer 	= ""; //폐이지하단 인쇄
	factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin 	= 10.0; //좌측여백   
	factory.printing.rightMargin 	= 10.0; //우측여백
	factory.printing.topMargin 	= 10.0; //상단여백    
	factory.printing.bottomMargin 	= 10.0; //하단여백
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
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>