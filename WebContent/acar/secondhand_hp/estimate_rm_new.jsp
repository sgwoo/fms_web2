<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.res_search.*, acar.short_fee_mng.*" %>
<%@ page import = "java.text.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>


<%
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String car_mng_id 	= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")	==null?"0":request.getParameter("today_dist");
	String o_1 		= request.getParameter("o_1")		==null?"0":request.getParameter("o_1");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt");
	String a_a 		= request.getParameter("a_a")		==null?"":request.getParameter("a_a");
	String a_b 		= request.getParameter("a_b")		==null?"":request.getParameter("a_b");
	String amt 		= request.getParameter("amt")		==null?"0":request.getParameter("amt");
	
	String est_id 		= request.getParameter("est_id")	==null?"":request.getParameter("est_id");
	String est_nm	 	= request.getParameter("est_nm")	==null?"":request.getParameter("est_nm");
	
	String acar_id 		= request.getParameter("acar_id")	==null?"":request.getParameter("acar_id");
	String est_code 	= request.getParameter("est_code")	==null?"":request.getParameter("est_code");
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	int fee_opt_amt 	= request.getParameter("fee_opt_amt")	==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	String mobile_yn	= request.getParameter("mobile_yn")	==null?"0":request.getParameter("mobile_yn");
	String mail_yn		= request.getParameter("mail_yn")	==null?"0":request.getParameter("mail_yn");
	
	String spe_est_id = request.getParameter("spe_est_id")	==null?"":request.getParameter("spe_est_id");
	String content_st = request.getParameter("content_st")	==null?"sh_rm_new":request.getParameter("content_st");
			
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	String page_kind = "";
	
	
	//20160427 rent_dt null or "" ???? ????
	if(!rent_dt.equals("")){
		//20160422 ?????? ???? ?????? 40?? ?????? ???? ???? ???????? ??????????	
	    SimpleDateFormat dfv = new SimpleDateFormat("yyyyMMdd");
	    Calendar cal = Calendar.getInstance();
	 
	    int yyyy     = cal.get(Calendar.YEAR);    //???? ????
	    int MM        = cal.get(Calendar.MONTH);   //???? ??
	    int dd        = cal.get(Calendar.DATE);    //???? ????
	    int hh        = cal.get(Calendar.HOUR);    //???? ????
	    cal.set(yyyy, MM, dd); //???? ???? ????
	    
	    /* ??,?????? ???? */
	    String resdate = rent_dt;    //??????
	    String today = dfv.format(cal.getTime());
	    Date beginDate = null;
	    Date endDate = null;
	    
	    long diff = 0;
	    long diffDays = 0;
	    long diffTime = 0;
	    
	    beginDate = dfv.parse(resdate);    //parse: ?????? ???? -> Date ?????? ????
	    endDate = dfv.parse(today);
	 
			diff = endDate.getTime() - beginDate.getTime(); //?????????????? ??????
	    diffDays = diff / (24 * 60 * 60 * 1000);
		
	    if(diffDays>=40){
		    out.println("?????? ???? ?? ?? ???? ???????? ???? ???????? ??????????????.<br/>http://www.amazoncar.co.kr/?? ?????????? ???????? ?????????????? ????????.");	 
		    return;
		}
    
	}	
		
	if(est_id.equals("") && !car_mng_id.equals("")){
		if(from_page.equals("secondhand")||from_page.equals("secondhand_rm")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp") || from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp") || from_page.equals("/acar/secondhand/secondhand_sc.jsp")||from_page.equals("off_lease_sc.jsp")){		//FMS ?????????????????? ??????????/??????????
			est_id = shDb.getSearchEstIdRm(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
			page_kind = "fms";
		}else{									//???????? ?????????? ??????
			est_id = shDb.getSearchEstIdShRm(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
			page_kind = "homepage";
		}
	}
		
	
	if(est_id.equals("")){
		out.println("???????? ????????????.");
		return;
	}
	
	
	//????????
	EstimateBean e_bean = new EstimateBean();
	
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")|| from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp") || from_page.equals("/acar/secondhand/secondhand_sc.jsp")||from_page.equals("off_lease_sc.jsp")){
		e_bean = e_db.getEstimateCase(est_id);
		if(today_dist.equals("0"))	today_dist = String.valueOf(e_bean.getToday_dist());
	}else{
		e_bean = e_db.getEstimateShCase(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
		
		//?????????? ?????????? ????
		if(!spe_est_id.equals("")){
			EstimateBean e_bean2 = e_db.getEstimateSpeCarCase(spe_est_id, "");
			if(!e_bean2.getEst_id().equals("")){
	    	e_bean.setEst_nm		(e_bean2.getEst_nm());
				e_bean.setEst_tel		(e_bean2.getEst_tel());
				e_bean.setEst_fax		(e_bean2.getEst_fax());
				e_bean.setEst_email	(e_bean2.getEst_email());
				e_bean.setDoc_type	(e_bean2.getDoc_type());
			}
		}
	}
	
	
	if(e_bean.getOpt_chk().equals("1") && opt_chk.equals("0")) 	opt_chk 	= e_bean.getOpt_chk();			
	
	if(e_bean.getFee_opt_amt() >0 && fee_opt_amt == 0 ) 		fee_opt_amt 	= e_bean.getFee_opt_amt();
	
	
	//???? ????????
	Hashtable sh_comp = new Hashtable();
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")|| from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp") || from_page.equals("/acar/secondhand/secondhand_sc.jsp")||from_page.equals("off_lease_sc.jsp")){
		sh_comp = shDb.getShCompare(est_id);
	}else{
		sh_comp = shDb.getShCompareSh(est_id);
	}
	
	
	//????????
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	//??????????
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());				
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);
	
	//??????????
	ShortFeeMngBean sf_bean = sfm_db.getShortFeeMngCase(ej_bean.getJg_r(), "2", e_bean.getRent_dt());	
	
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
	
	//????????
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
	
	if(today_dist.equals("0"))	today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	
	
	if(e_bean.getCar_amt()==0){
		e_bean.setCar_amt(car_amt);
		e_bean.setOpt_amt(opt_amt);
		e_bean.setCol_amt(clr_amt);
	}
	
	
	String stat = "";
	
	
	//???? ????????
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	int sh_car_amt			= AddUtil.parseInt((String)sh_var.get("SH_CAR_AMT"));
	int dlv_car_amt			= AddUtil.parseInt((String)sh_var.get("DLV_CAR_AMT"));
	
	sh_car_amt 	= e_bean.getO_1();
	dlv_car_amt 	= car_amt+opt_amt+clr_amt-tax_dc_amt-e_bean.getO_1();
	
	
	String rent_way = "2";
	if(!e_bean.getA_a().equals("")){
		a_a 		= e_bean.getA_a().substring(0,1);
		rent_way 	= e_bean.getA_a().substring(1);
	}
	if(a_b.equals(""))	a_b	= e_bean.getA_b();
	String a_e 			= s_st;
	float o_13 			= 0;
	
	
	//????????
	String vali_date = "";
	
	//if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
	//	vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 4));
	//	if(e_bean.getMgr_ssn().equals("????????") && !e_bean.getEst_from().equals("ext_car")) 	vali_date = AddUtil.getDate3(rs_db.addMonth(e_bean.getReg_dt().substring(0,8), 1));
	//}
	
	
	//??????----------------------------------------------------------------
	
	String name 	= "";
	String tel 	= "";
	String m_tel	= "";
	String h_tel	= "";
	String h_tels 	= "";
	String i_fax	= "";
	String email	= "";
	String week_st 	= c_db.getWeek_st(AddUtil.getDate());  		//1:?????? , 7:??????
	int hol_cnt 	= c_db.getHoliday_st(AddUtil.getDate());  	//????	
	String watch_id = c_db.getWatch_id(AddUtil.getDate(), "1" );  	// ???? ??????????
	
	//?????? ???????????? ???? ????????
	String br_id = request.getParameter("br_id")	==null?"":request.getParameter("br_id");
	
		
	
	//??????????:08:30~20:30 ???????????? ???? ????????????:??????????????. ?????? ???????? ???? 
	int t_time 	= Integer.parseInt(AddUtil.getTime().substring(11,13) + AddUtil.getTime().substring(14,16));
	
	//default :???????? ????????
	String check 	= "C";
	
	
	if(week_st.equals("1")  || week_st.equals("7") || hol_cnt > 0 ){
			check = "P";
	}else{
		if ( t_time >= 801 && t_time <= 2001 ){
			check = "C";
		}else{
		    	check = "P";
		}
	}

	//20121106 ?????????????????? ???? ?????? ???? ?????? ????
	if(br_id.equals("B1")){
		name 	= "????";
		h_tel 	=  "051-851-0606";	
		
	}else if(br_id.equals("D1")){
		name 	= "????";
		h_tel 	=  "042-824-1770";	
	}else if(br_id.equals("G1")){
		name 	= "????";
		h_tel 	=  "053-582-2998";		
	}else if(br_id.equals("J1")){
		name 	= "????";
		h_tel 	=  "062-385-0133";				
	}else{
		name 	= "????";
		h_tel 	=  "02-757-0802";				
		h_tels	= "070-8224-8381";
	}	
	
	
	if ( check.equals("C")){ //??????????-??????
	
	//	System.out.println(watch_id);
	//	UsersBean user_bean1 	= umd.getUsersBean(watch_id);		
	//	name 		= user_bean1.getUser_nm();	
	//	h_tel 		= user_bean1.getUser_m_tel();	
			
	//	name 	= "";
	//	h_tel 	=  "02-757-0802";	
		
	} else {	
//		name 	= "";
//		h_tel 	=  "02-392-4242";		

		if(name.equals("????")){
			h_tel 	=  "02-392-4242";	//?????? ???? ???????? ???????? ?????????????? ????.(????????????)
		}

	}
				
		
		
	//?????????? ?????? ???????? ???????????? ????
	acar_id = e_bean.getReg_id();
		
	if(e_bean.getReg_id().equals("SYSTEM") || e_bean.getReg_id().equals("system") || e_bean.getReg_id().equals("")) {
		//acar_id = shDb.getSearchacar_id(e_bean.getRent_dt(), br_id);		
		//acar_id = "000085";
	} 	
	if(!acar_id.equals("") && !acar_id.equals("SYSTEM") && !acar_id.equals("system")){
		UsersBean user_bean 	= umd.getUsersBean(acar_id);		
		name 		= user_bean.getUser_nm();
		tel 		= user_bean.getUser_m_tel();		
		br_id   	= user_bean.getBr_id();
		i_fax   	= user_bean.getI_fax();
		email 		= user_bean.getUser_email();
		
		if (acar_id.equals("000058") ) {
			m_tel 		=   "070-8224-8381"; //???????? ???????????? ????.
		}else {
			m_tel 		= user_bean.getUser_m_tel();	
		}
			
		h_tel 	=  "02-392-4242"; //?????? ????????.
		//20170123 ?????? ???? ?????? ???? ?????? ????
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
	
	

	//20120830 ?????????????? ????	
	
	int months 		= request.getParameter("months")	==null?0:AddUtil.parseDigit(request.getParameter("months"));
	int days 		= request.getParameter("days")		==null?0:AddUtil.parseDigit(request.getParameter("days"));
	int tot_rm 		= request.getParameter("tot_rm")	==null?0:AddUtil.parseDigit(request.getParameter("tot_rm"));
	int tot_rm1 		= request.getParameter("tot_rm1")	==null?0:AddUtil.parseDigit(request.getParameter("tot_rm1"));
	String per 		= request.getParameter("per")		==null?"":request.getParameter("per");
	String navi_yn 		= request.getParameter("navi_yn")	==null?"":request.getParameter("navi_yn");
	
	
	//???????????? ?????? ????????
	if(months == 0 && days == 0 && tot_rm == 0 && tot_rm1 == 0 && per.equals("") && navi_yn.equals("")){
	
		//20220812 ?????? 1???? ????????, ???????? ???? ???????? ?????? ???? - ?????????? ?????? ???? ??????. 
		//EstimateBean rm_bean = e_db.getEstiRmCase(est_id);
		
		//if(!rm_bean.getEst_id().equals("")){
		//	months 	= AddUtil.parseDigit(rm_bean.getMonths	());
		//	days 	= AddUtil.parseDigit(rm_bean.getDays	());
		//	tot_rm 	= AddUtil.parseDigit(rm_bean.getTot_rm	());
		//	tot_rm1 = AddUtil.parseDigit(rm_bean.getTot_rm1	());
		//	per 	= rm_bean.getPer	();
		//	navi_yn = rm_bean.getNavi_yn	();
		//}else{	
			months 	= 1;		
			per	= "0";
			tot_rm	= e_bean.getFee_s_amt();
			tot_rm1	= tot_rm;		
		//}
	}
	
	int tot_rm_v 	= 0;
	int tot_rm1_v 	= 0;
	
	
	//???????????? ??????
	Hashtable day_pers = shDb.getEstiRmDayPers(per);
	
	int day_per[] = new int[30];

	//???????? ??????
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
	
	
	
	//?????? ???????? ???????? ?????????? ?????? ?????????? ????
	if(acar_id.equals("000058")){
		//????????
		String today_free_id = umd.getCarScheTodayChk(acar_id);
		
		if(today_free_id.equals(acar_id)){
			acar_id = "000144";
			UsersBean user_bean 	= umd.getUsersBean(acar_id);
			name 		= user_bean.getUser_nm();
			tel 		= user_bean.getUser_m_tel();
			br_id 		= user_bean.getBr_id();
			m_tel 		=  "070-8224-8381"; //??????????	
		//	m_tel 		= user_bean.getUser_m_tel();	
			h_tel 		=  "02-392-4242"; //?????? ????????.	
			//20170123 ?????? ???? ?????? ???? ?????? ????
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
		//	h_tel 		= user_bean.getHot_tel();  ///?????? ?????? ????????.
		}
	}	



%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>??????</title>
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
	color: #77786b;
	font-size: 8pt
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
	//????????
	function go_print(est_id){	
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.action = "esti_print_rm_new.jsp";
		fm.target = "_blank";
		fm.submit();		
	}	
	
	//????????????
	function go_mail(est_id){	
		<%if(mobile_yn.equals("Y")){%>		
		var SUBWIN="https://fms3.amazoncar.co.kr/smart/rlscar/rlscar_view6_mail.jsp?from_page=<%=from_page%>&est_id=<%=est_id%>&est_email=<%=e_bean.getEst_email()%>&write_id=<%=e_bean.getReg_id()%>&acar_id=<%=acar_id%>&opt_chk=<%=opt_chk%>&fee_opt_amt=<%=fee_opt_amt%>&content_st=<%=content_st%>&months=<%=months%>&days=<%=days%>&tot_rm=<%=tot_rm%>&tot_rm1=<%=tot_rm1%>&per=<%=per%>&navi_yn=<%=navi_yn%>";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=400, scrollbars=no, status=yes");
		<%}else{%>
		var SUBWIN="/acar/apply/mail_input.jsp?from_page=<%=from_page%>&est_id=<%=est_id%>&est_email=<%=e_bean.getEst_email()%>&write_id=<%=e_bean.getReg_id()%>&acar_id=<%//=acar_id%>&opt_chk=<%=opt_chk%>&fee_opt_amt=<%=fee_opt_amt%>&content_st=<%=content_st%>&months=<%=months%>&days=<%=days%>&tot_rm=<%=tot_rm%>&tot_rm1=<%=tot_rm1%>&per=<%=per%>&navi_yn=<%=navi_yn%>";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, <%if(from_page.equals("mrent_list.jsp")){%>height=300<%}else{%>height=600<%}%>, scrollbars=no, status=yes");
		<%}%>
	}
	
	//????????????
	function go_paper(){
		var SUBWIN="/acar/main_car_hp/papers_mrent.html";	
		window.open(SUBWIN, "openpaper", "left=50, top=50, width=1000, height=750, status=no, scrollbars=yes, resizable=no");
	}	
	
	//?????????????????? ?????? ???? ????
	function go_navi_esti(navi_yn){
		var fm = document.form1;
		fm.navi_yn.value = navi_yn;
		fm.action = "estimate_rm_new.jsp";
		fm.target = "_blank";
		fm.submit();		
		
		fm.navi_yn.value = '';		
	}	

	//????????????????
	function opt(car_mng_id){  
		var fm = document.form1;
		var SUBWIN="estimate_rm_new_opt.jsp?car_mng_id="+car_mng_id+"&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=760, height=480, scrollbars=yes, status=yes, resizable=no");
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
<input type="hidden" name="est_id" 	value="<%=est_id%>">
<input type="hidden" name="acar_id" 	value="<%=acar_id%>">
<input type="hidden" name="opt_chk" 	value="<%=opt_chk%>">
<input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">
<input type="hidden" name="mobile_yn" 	value="<%=mobile_yn%>">
<input type="hidden" name="content_st" 	value="<%=content_st%>">

<input type="hidden" name="months" 	value="<%=months%>">
<input type="hidden" name="days" 	value="<%=days%>">
<input type="hidden" name="tot_rm" 	value="<%=tot_rm%>">
<input type="hidden" name="tot_rm1" 	value="<%=tot_rm1%>">
<input type="hidden" name="per" 	value="<%=per%>">
<input type="hidden" name="navi_yn" 	value="<%=navi_yn%>">
<input type="hidden" name="br_id" 	value="<%=br_id%>">

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
                    <td width=478><img src=/acar/main_car_hp/images/title_rm.gif></td>
                    <td width=160 align=right>
                        <table width=160 border=0 cellspacing=1 bgcolor=c4c4c4>
			    <%
				if(e_bean.getVali_type().equals("0") || e_bean.getVali_type().equals("1")){
					vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 4));
				}else if(e_bean.getVali_type().equals("2")){
					vali_date = "?????? ??????????.";
				}
			    %>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>??????</span></td>
                                <td width=97 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
			    <%if(!vali_date.equals("")){%>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>????????</span></td>
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
        <td height=10 colspan=3></td>
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
				                        	<td colspan=3><div align="left"><span class=style2><%=e_bean.getEst_nm()%>
				                            <%if(client_st.equals("2")){%>????<%}else{%>????<%}%></span></div></td>						
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=4><img src=/acar/main_car_hp/images/line.gif width=409 height=1></td>
				                      	</tr>
				                     	 <tr> 
				                        	<td width=24 height=30 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        	<td width=160><span class=style2>TEL.<%=e_bean.getEst_tel()%></span></td>
				                        	<td width=24 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        	<td width=202><span class=style2>FAX.<%=e_bean.getEst_fax()%></span></td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=4><img src=/acar/main_car_hp/images/line.gif width=409 height=1></td>
				                      	</tr>
			                   		</table>
			                   	</td>
			                  	<td width=28>&nbsp;</td>
								<td width=201 valign=bottom> 
			                      <%if(!acar_id.equals("")){%>
			                      <%if(name.equals("????")){%>
				                  	<table width=201 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/tel_bg_new_1.gif  height=110>
						   									<tr> 
				                        		<td colspan=4 height=12></td>
					                			</tr>
					               		
										  					<tr> 
					                        	<td width=60 align=right valign=top height=13>&nbsp;<span class=style5>??????</span></td>
					                        	<td width=20>&nbsp;</td>
					                        	<td width=121 valign=top>&nbsp;<span class=style5>02-757-0802</span></td>
					                      </tr>
					                   		<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>??????</span></td>
					                        	<td>&nbsp;</td>
					                        	<td>&nbsp;<span class=style5>02-2038-8661</span></td>
					                      </tr>
					                    	<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>????</span></td>
					                        	<td>&nbsp;</td>
					                        	<td>&nbsp;<span class=style5>02-537-5877</span></td>
					                      </tr>
					                 			<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>????</span></td>
					                        	<td>&nbsp;</td>
					                        	<td>&nbsp;<span class=style5>02-2038-2492</span></td>
					                      </tr>
										  					<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>????</span></td>
					                        	<td>&nbsp;</td>
					                        	<td>&nbsp;<span class=style5>032-554-8820</span></td>
					                      </tr>
										  					<tr> 
					                        	<td align=right height=13>&nbsp;<span class=style5>????</span></td>
					                        	<td>&nbsp;</td>
					                        	<td>&nbsp;<span class=style5>031-546-8858</span></td>
					                      </tr>
					                      <tr> 
				                        	<td colspan=4 height=10></td>
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
					                          <span class=style5>????????</span></td>
					              		</tr>
					                                
					               		<tr> 
					                        <td>&nbsp;</td>
					                        <td height=14 class=listnum2><span class=style5><%if(br_id.equals("S1")){%><%= tel %><%= name %><%}else{%>02-757-0802<%}%></span></td>
					               		</tr> 
					                    
					              		<tr> 
					                        <td>&nbsp;</td>
					                        <td class=listnum2><img src=/acar/main_car_hp/images/dot1.gif width=4 height=4 align=absmiddle> 
					                          <span class=style5>????????</span></td>
					              		</tr>
					              		<tr> 
					                        <td>&nbsp;</td>
					                        <td height=14 class=listnum2><span class=style5><%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>051-851-0606<%}%></span></td>
					               		</tr> 
										
					           			<tr> 
					                        <td>&nbsp;</td>
					                        <td class=listnum2><img src=/acar/main_car_hp/images/dot1.gif width=4 height=4 align=absmiddle> 
					                          <span class=style5>????????</span></td>
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
			                  	<td colspan="3" height="5"></td>
			                </tr>
			                <tr> 
			                  	<td colspan="3" height="17">&nbsp;?? ???????? ???????? ?????????? ?????? ?????? ???? ?????? ?????????? 
			                    ?????????? ???? ???? ????????????.</td>
			                </tr>
              			</table>
              		</td>
	          	</tr>
	          	<tr> 
	            	<td height=10 colspan="2"></td>
	          	</tr>
	          	<tr> 
	            	<td colspan="2"><img src=/acar/main_car_hp/images/bar_01.gif width=638 height=22></td>
	         	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
	          	<tr> 
	            	<td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
			                <tr> 
			                  <td width=132 height=17 align=center bgcolor=f2f2f2><span class=style3>??????</span></td>
			                  <td width=358 bgcolor=#FFFFFF>&nbsp;<span class=style4><%= c_db.getNameById(car_comp_id, "CAR_COM") %></span></td>
			                  <td width=144 align=center bgcolor=f2f2f2><span class=style3>?? 
			                    ??</span></td>
			                </tr>
			                <tr> 
			                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>????(??????????)</span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><a href="javascript:opt('<%=car_mng_id%>');" onMouseOver="window.status=''; return true"><%=car_name%></a></span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getCar_amt()) %>
			                    ??</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>?? 
			                    ??</span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><a href="javascript:opt('<%=car_mng_id%>');" onMouseOver="window.status=''; return true"><%=opt%></a></span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getOpt_amt()) %>
			                    ??</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>?? 
			                    ?? </span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(!e_bean.getIn_col().equals("")){%>????: <%}%><%=colo%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;????: <%=e_bean.getIn_col()%><%}%></span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getCol_amt()) %>
			                    ??</span>&nbsp;</td>
			                </tr>
						<!-- ???? ?????? ???? ????(2017.10.13) -->
		                <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
		                <tr>
		                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>???? ?????? ???? </span></td>
		                    <td bgcolor=#FFFFFF>
		                    </td>
		                    <td align=right bgcolor=#FFFFFF><span class=style4> - <%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> ??</span>&nbsp;</td>
		                </tr>
		                <%}%>			                
			                <tr> 
			                  <td height=17 align=center bgcolor=f2f2f2><span class=style3>????????
			                   </span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7>?????????? : <%=AddUtil.ChangeDate2(init_reg_dt)%>&nbsp;&nbsp;&nbsp;&nbsp;???????? : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km</span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style4>-<%= AddUtil.parseDecimal(dlv_car_amt) %>
							    ??</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  <td height=20 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
			                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7>???????? : <%if(!car_no.equals("")){ out.println("****"+car_no.substring(car_no.length()-4, car_no.length())); } %>
			                      <!--<%if(!dist_cng.equals("") && spe_dc_per==0){%>&nbsp;???????? ???? ?? ???????? ???? ????<%}else if(!dist_cng.equals("") && spe_dc_per > 0){%>&nbsp;?????????? ?????????? ????????<%}%>-->
			                  </span></td>
			                  <td align=right bgcolor=#FFFFFF><span class=style14><%=AddUtil.parseDecimal(e_bean.getO_1())%> 
			                    ??</span>&nbsp;</td>
			                </tr>
	             		</table>
	             	</td>
	          	</tr>		  
	          	<tr> 
	            	<td height=10 colspan="2" align="right">
				<%if(cm_bean.getJg_code().equals("1232") || cm_bean.getJg_code().equals("1242") || cm_bean.getJg_code().equals("1021212") || cm_bean.getJg_code().equals("1023112")){//????????????,????%>
									?? LPG/?????? ??????
				<%}else{%>						
				<%	if(String.valueOf(sh_comp.get("ENGIN")).equals("Y")){%>		?? ????????
				<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("2")){%>	?? LPG??????
				<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("1")){%>	?? ??????????
				<%	}else{%>
					<%if(cm_bean.getDiesel_yn().equals("Y")){%>			?? ????????
					<%}else if(cm_bean.getDiesel_yn().equals("2")){%>		?? LPG??????
					<%}else if(cm_bean.getDiesel_yn().equals("1")){%>		?? ??????????
					<%}%>
				<%	}%>
				<%}%>			
					</td>
	          	</tr>
          <%if(!dist_cng.equals("")){%>
          <tr>
          	<td colspan="2" bgcolor=f2f2f2 height=45><span class=style4> * ?? ?????? ?????? ???? ????(<%=AddUtil.getDate3(cha_st_dt)%>)?? ???? ???????? ?????? ?????? ?????????? <%=AddUtil.parseDecimal(b_dist)%>km, ?????? ?? ????<br>
          	&nbsp; ???? ?????????? <%=AddUtil.parseDecimal(AddUtil.parseInt(today_dist)-AddUtil.parseInt(b_dist))%>km??????. ???????? ?????????? ?????????? <%=AddUtil.parseDecimal(today_dist)%>km?? ????????, ?????????? ???? ??????????<br>
          	&nbsp; ??????????????.</span></td>
          </tr>
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          <%}%>
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=231>		                  	
				                  	<img src=/acar/main_car_hp/images/bar_02_1_rm_new.gif border=0></a>
			                  	</td>
			                  	<td width=10>&nbsp;</td>
			                  	<td width=397><img src=/acar/main_car_hp/images/bar_03_rm_new.gif></td>
			                </tr>
			                <tr> 
			                  	<td height=4 colspan=3></td>
			                </tr>
			                <tr> 
                  				<td> 
                  					<table width=231 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      	<tr> 
				                        	<td width=94 height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
				                        	<td width=137 align=center bgcolor=#f2f2f2><span class=style3>1????</span></td>
				                      	</tr>
									  <%		if(navi_yn.equals("Y")){
									  			tot_rm 	= tot_rm+25000;
									  			//tot_rm1 = Math.round((tot_rm * months + tot_rm * days/30)/100)*100;  //??????????- 0???? 0??
									  			tot_rm1 = Math.round((tot_rm * months + tot_rm * days/30));  //??????????- 0???? 0??
									  		}
									  		
									  		tot_rm_v 	= tot_rm/10;
									  		tot_rm1_v 	= tot_rm1/10;
									  %>
									  <input type="hidden" name="am_good_st" 	value="??????">									  
									  <input type="hidden" name="am_good_id1" 	value="<%=est_id%>">
									  <input type="hidden" name="am_good_id2" 	value="<%=car_mng_id%>">
									  <input type="hidden" name="am_good_amt" 	value="<%=tot_rm+tot_rm_v%>">
									  <input type="hidden" name="am_good_s_amt" 	value="<%=tot_rm%>">
									  <input type="hidden" name="am_good_v_amt" 	value="<%=tot_rm_v%>">									  
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? 
				                          	?? ?? </span></td>
				                          	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(tot_rm)%> 
				                          	??</span>&nbsp;&nbsp;&nbsp;</td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? 
				                          	?? ?? </span></td>
				                          	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(tot_rm_v)%> 
				                          	??</span>&nbsp;&nbsp;&nbsp;</td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
				                          	<td align=right bgcolor=#FFFFFF><span class=style14><%=AddUtil.parseDecimal(tot_rm+tot_rm_v)%> 
				                          	??</span>&nbsp;&nbsp;&nbsp;</td>
				                      	</tr>
                    				</table>
                    			</td>
			                  	<td>&nbsp;</td>
			                  	<td> 
				  <%if(!e_bean.getIns_per().equals("2")){%>
							  		<table width=397 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      	<tr> 
				                        	<td width=85 height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
				                        	<td width=118 align=center bgcolor=#FFFFFF><span class=style4>????(???? 
				                          ??,??) </span></td>
				                        	<td width=85 align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
				                        	<td width=109 align=center bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>??</span></td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
				                        	<td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5??????<%}else if(e_bean.getIns_dj().equals("4")){%>2????<%}else{%>1????<%}%></span></td>
				                        	<td align=center bgcolor=f2f2f2><span class=style3>????????????</span></td>
				                        	<td align=center bgcolor=#FFFFFF><span class=style4>1????????2????</span></td>
				                        
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>????????????</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5??????<%}else{%>1????<%}%></span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_age().equals("2")){%>??21??????<%}else if(e_bean.getIns_age().equals("3")){%>??24??????<%}else{%>??26??????<%}%></span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
					                        <td align=center bgcolor=#FFFFFF colspan=3><span class=style4>?????? ?? ???????? ?????? ??????????</span></td>
				                      	</tr>
			                    	</table>
							<%}else{%>
								  	<table width=397 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      	<tr> 
					                        <td width=85 height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
					                        <td width=118 align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
					                        <td width=85 align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
					                        <td width=109 align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>????????????</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>????????????</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
					                        <td align=center bgcolor=#FFFFFF colspan=3><span class=style4>??????????</span></td>
				                      	</tr>
				                    </table>
								<%}%>					
				  				</td>
                			</tr>
                			
                			<%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && e_bean.getA_a().equals("12")) {%>
				            <tr>
								<td colspan="3" align="right">?? ?????????? ???????? ???? ???????????? ????</td>
				            </tr>
				            <%}%>
				            
              			</table>
              		</td>
          		</tr>
          		<tr> 
             		<td height=10 colspan="2"></td>
          		</tr>
          		<tr> 
	            	<td colspan="2"><img src=/acar/main_car_hp/images/bar_04_rm.gif width=638 height=22></td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
				<tr>
					<td colspan="2" height=25><span class=style17>???? ????????</span></td>
				</tr>
          		<tr> 
            		<td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                	<tr> 
		                  		<td width=90 height=17 align=center bgcolor=f2f2f2><span class=style3>????????????</span></td>
		                  		<td width=543 bgcolor=#FFFFFF style="padding:3px 5px;"> <span class=style4>?? 26?????? ???????? 3???????? ???????? ?????????? ??????(???????? ???????? 26?????? ???? ????????)<br>?? ?????? ?????????? ?????? ????????</span></td>
		                  	</tr>
							<tr>
								<td height=17 bgcolor=#f2f2f2 align=center><span class=style3>?????? ????</span></td>
								<td bgcolor=#FFFFFF style="padding:3px 5px;" ><span class=style4>???????? ?????? ???? ????(?????? ???? ???? ????)?? ?????????? ???????? ??????.(???????? ????)<br>
									?? ?????????? ?????? ????(?????? ?????? ???? ?????? ???????? ????????)?? ??????????.
									</span></td>
							</tr>
							<tr>
								<td height=17 bgcolor=#f2f2f2 align=center><span class=style3>?????? ????</span></td>
								<td bgcolor=#FFFFFF style="padding:3px 5px;"><span class=style4>???????? : ?????? ???????? (??, ???????? ?????? ???? ???? ?? ???? ????)<br>
								?????????? : ??????(??????????) ?? ?????? ???????? ?????? ???? 1???? ???? ????(?????? ???????? ???? ????)<br>
								 ???? : ?????? ???????? ?????? ???? 2???? ???? ????(?????? ???????? ???? ????) </span></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" height=25><span class=style17>???? ????????</span></td>
				</tr>
				<tr>
					<td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
							<tr>
		                  		<td width=90 height=17 bgcolor=#f2f2f2 align=center><span class=style3>????????????</span></td>
		                  		<td width=543 bgcolor=#ffffff style="padding:3px 5px;"><span class=style4><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km / 1????, ?????? 1km?? <span class=style14><%=e_bean.getOver_run_amt()%></span>??(??????????)?? ???????????????? ??????????(??????????)</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>????????</span></td>
		                  		<td height=17 bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>?????????? ?????? ???? ?????? ????????, ???? ?????? ?????? ???????? ?????????? ??????????.<br>
								???? ?????? ?????? ???? ???? 16?????? ??????. ???? ???? ???? ?????? ?????????? ?????? ???????? ????????. </span></td>
							</tr>
							<tr>
		                  		<td height=32 bgcolor=#f2f2f2 align=center><span class=style3>???? ????/<br>????</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>?????? ?????????? ???? ???? 9??~???? 5?? ?????? ??????????.<br>???????? ?? ?????????? ???????? ???????? ????????, ?????????? ??????????????.<br>
		                  		 ?? ?????????? ?????????? ??????????. ?????? ??) ???? : 22,000??(?????? ????)</span></td>
							</tr>
							
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>???????? ????</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>?? ???????? 1?????? ?????? ???????? ??????.<br>
		                  		?? ???????? ?????? ???? ????(???????? ????)?? ?????????? ???????? ??????. <br>&nbsp;&nbsp;&nbsp; (???????? ???? ?? ?????? ???? ???? ???? ?? ?????? ?????? ?????? ?????????? ????)<br>
		                  		?? 2?????????? ????????, ????????????, ??????????????, ?????? ???? ???? ?????? ?????????? ??????????????.<br>&nbsp;&nbsp;&nbsp; (?????? ???????? ???????? ???? ????, 2?????????? ?????????? ???? ???? ?????????? ?????? ?? ????)</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>???? ???? ??<br>????</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>???? ???? ?? ????(????????, ???????? ???? ??)?? ?????? ???? ???? ???????? ??????????????<br>?????????? ????,
		                  		 ???? ?????? ???????? ?????????????? ???? ?????? ?????? ??????.<br>???????? ???????????? ????????, ???????????? ?????? ?????????? ????????.</span>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>???? ????</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>???????????????? ???????? ?????????? ?? ???????? <span class=style14>???????? 7????</span>?????? ?????? ?????? ?????? ??????.<br>
		                  		???????? ?????? ?????????? ???? ?????????? ?????????? ????, ???????? ?????? ?????? ???????? ???? ?????? ??????????.<br>
		                  		?????????? ?????????? ???? ?????? ???????? ???????????? ????????, ?????????? ????????????.</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>??????????</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>?? ???????????? <%if(day_cnt==30){%>1????<%}else{%><%=day_cnt%>??<%}%> ?????? ????: ???????? ?????????? <span class=style14>10%</span>?? ???????? ??????????.<br>
		                  		?? ???????????? <%if(day_cnt==30){%>1????<%}else{%><%=day_cnt%>??<%}%> ?????? ????: ???? 5.?? ???????? ?????? ????????.</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>?????? ????</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;"><span class=style4>?? ?????????? ??????(????????)?? ?????? ?????? ?????? ???? ????????. ???????????? ?????? ?????????? ?????????? ????????.</span></td>
							</tr>
							<tr>
		                  		<td bgcolor=#f2f2f2 align=center><span class=style3>???? ????<br>???? ????</span></td>
		                  		<td bgcolor=#ffffff style="padding:3px 5px;">
<!-- 		                  		<span class=style4>???? ?????? ???? 9??~???? 5?????? ?? ?????? ??????.<br> -->
<!-- 		                  		(??, ????(???? 1?? 1??) ?? ???? ?????? ???? ?????? ??????????.)</span> -->
			                  		<span class=style4>????: ???? 9??~???? 5?????? ?????????? ??????????.<br>
			                  		?????? ?? ??????: ???? 9??~12?????? ?????????? ??????????.<br>
			                  		??????, ????(???? 1?? 1??) ?? ???? ????: ?????????? ?????????? ?????? ?????? ?????? ????????.</span>
		                  		</td>
							</tr>
		              	</table>
					</td>
		     	</tr>
		   		<tr> 
		            <td height=10 colspan="2"></td>
		 		</tr>
		   		<tr> 
		            <td colspan="2" background=/acar/main_car_hp/images/bar_05_rm.gif width=638 height=22 valign=top  style="padding-left:125px;"><span class=style11><%if(day_cnt==30){%>1????<%}else{%><%=day_cnt%>??<%}%></span></td>
		   		</tr>
		 		<tr> 
		            <td height=4 colspan="2"></td>
		  		</tr>
          		<tr> 
            		<td colspan="2"> 
		            	<table width=638 border=0 cellspacing=1 cellpadding=0 bgcolor=c4c4c4>
		                	<tr> 
		                  		<td colspan=31 bgcolor=#ffffff height=17  style="padding:0 5px;">&nbsp;<span class=style4>?????????? ???? ???? ???? ?????? ???????? ??????????. (????: ??, %)</span></td>
		                	</tr>
		                	<tr>
		                		<td height=17 width=92 align=center bgcolor=f2f2f2><span class=style3>???? ????</span></td>
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
						<td height=32 align=center bgcolor=f2f2f2><span class=style3>????????????<br>??????</span></td>
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
	          		<td colspan=2><span class=style4>?? ????) 6?? ?????? ??????????: <%=AddUtil.parseDecimal(tot_rm+tot_rm_v)%>?? ?? <%=day_per[5]%>/100 = <%=AddUtil.parseDecimal((tot_rm+tot_rm_v)*day_per[5]/100)%>?? &nbsp;(???? ???????? ???? ??, ???????????? ???? ??????)</span></td>
	          	</tr>
	          	<tr> 
	            	<td height=10 colspan="2"></td>
	          	</tr>
	          	<tr> 
	            	<td colspan="2"><img src=/acar/main_car_hp/images/bar_06_rm.gif width=638 height=22></td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
	          	<tr> 
            		<td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=0 bgcolor=c4c4c4>
		                	<tr> 
		                  		<td colspan=31 bgcolor=#ffffff height=32  style="padding:0 5px;"><span class=style4>?????? ?????????? ???? ???? ??????, ?????????? ?????????? ???????? ????????(???????? ???????? ?????? ????)?? 50%?? ?????? ?????????? ??????. (?????????? ???????? ?? 19???? ????)</span></td>
		                	</tr>
		                	<tr>
		                		<td width=92 align=center bgcolor=f2f2f2 rowspan=3><span class=style3>????????<br>???????? ????</span></td>
		                		<td width=259 align=center bgcolor=f2f2f2 height=17><span class=style3>????????</span></td>
		                		<td width=280 align=center bgcolor=f2f2f2 colspan=4><span class=style3>?????????? 1?????? (?????? ????)</span></td>
		                	</tr>
		                	<tr>
		                		<td height=17 bgcolor=#ffffff align=center rowspan=2><span class=style4><%=ej_bean.getJg_v()%></span></td>
		                		<td bgcolor=#ffffff align=center width=70 height=17><span class=style4>1~2??</span></td>
		                		<td bgcolor=#ffffff align=center width=70><span class=style4>3~4??</span></td>
		                		<td bgcolor=#ffffff align=center width=70><span class=style4>5~6??</span></td>
		                		<td bgcolor=#ffffff align=center width=70><span class=style4>7??????</span></td>
		                	</tr>
		                	<tr>
		                		<td bgcolor=#ffffff align=center height=17><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_01d()*1.1)%>??</span></td>
		                		<td bgcolor=#ffffff align=center><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_03d()*1.1)%>??</span></td>
		                		<td bgcolor=#ffffff align=center><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_05d()*1.1)%>??</span></td>
		                		<td bgcolor=#ffffff align=center><span class=style4><%=AddUtil.parseDecimal(sf_bean.getAmt_07d()*1.1)%>??</span></td>
		                	</tr>
		              	</table>
            		</td>
          		</tr>

	  <%if(!e_bean.getDoc_type().equals("")){%>
	          	<tr> 
	            	<td height=10 colspan="2"></td>
	          	</tr>
	          	<tr> 
	            	<td colspan="2"><img src=/acar/main_car_hp/images/bar_07_rm.gif width=638 height=22></td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
          <%}else{%>
          		<!-- ????????-->
          		<tr>
	          		<td height=5></td>
	          	</tr>
	          	<tr>
	          		<td colspan="2">&nbsp;</td>
	          	</tr>
          <%}%>
	<!--???????????? start-->
    <!-- ????-->
	<%if(e_bean.getDoc_type().equals("1")){%>
          		<tr> 
            		<td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=3 bgcolor=c4c4c4>
		                	<tr>
		                		<td width=86 align=center bgcolor=f2f2f2><span class=style3>????</span></td>
		                		<td width=543 bgcolor=ffffff><span class=style4>???? ????????: ???????????? ????, ?????????????? 1??, ?????????????? 1??, ???????? ??????????, ???????????? ????<br>
		                		?????? ????????: ?????? ?????????? 1??, ???????? ??????????<br>
		                		?????????????? ???? 3???????? ?????? ???????? ??????. ?????? ??????: ????, ???????? ????</span></td>
		                	</tr>
		              	</table>
            		</td>
				</tr>
		  		<tr>
		          	<td height=5></td>
		    	</tr>
		   		<tr>
		          	<td colspan="2"><span class=style3>[ ???????? : ???????? 140-004-023871 (??)???????? ]</span></td>
		   		</tr>
		    <%}else if(e_bean.getDoc_type().equals("2")){%>
		    <!-- ??????????-->      
		   		<tr> 
		            <td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=3 bgcolor=c4c4c4>
		                	<tr>
		                		<td width=86 align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
		                		<td width=543 bgcolor=ffffff><span class=style4>???????????? ????, ?????? ??????, ???????? ??????, ????????, ???????????? ????<br>
		                		???????? ?????? ???? ?????? ?????? ?????? ???? ?????? ??????.</span></td>
		                	</tr>
		              	</table>
		            </td>
		    	</tr>
		  		<tr>
		          	<td height=5></td>
		   		</tr>
		   		<tr>
		          	<td colspan="2"><span class=style3>[ ???????? : ???????? 140-004-023871 (??)???????? ]</span></td>
		   		</tr>
     <!-- ????-->
    <%}else if(e_bean.getDoc_type().equals("3")){%>
    			<tr> 
		            <td colspan="2">
		            	<table width=638 border=0 cellspacing=1 cellpadding=3 bgcolor=c4c4c4>
		                	<tr>
		                		<td width=86 align=center bgcolor=f2f2f2><span class=style3>????</span></td>
		                		<td width=543 bgcolor=ffffff><span class=style4>??????????, ????????, ???????????? ????<br>
		                		???????? ?????? ???? ?????? ?????? ?????? ???? ?????? ??????.</span></td>
		                	</tr>
		              	</table>
		            </td>
	          	</tr>
	          	<tr>
	          		<td height=5></td>
	          	</tr>
	          	<tr>
	          		<td colspan="2"><span class=style3>[ ???????? : ???????? 140-004-023871 (??)???????? ]</span></td>
	          	</tr>
   	<%}%>
	<!--???????????? end-->	
	          	<tr> 
	            	<td height=5 colspan="2">&nbsp;</td>
	          	</tr>
	          	<tr> 
	            	<td align=right><img src=/acar/main_car_hp/images/ceo.gif>&nbsp;</td>
	            	<td align=right>&nbsp;&nbsp;</td>
	          	</tr>
	          	<tr> 
	            	<td height=5 colspan="2"></td>
	          	</tr>
        	</table>
        </td>
        <td width=21>&nbsp;</td>
    </tr>

    <tr>
        <td align=center colspan=3>
		  <a href=javascript:go_print('<%= est_id %>'); title='??????????'><img src="/acar/main_car_hp/images/button_print.gif" border=0></a>&nbsp;&nbsp;
		  
  		  <a href=javascript:go_mail('<%= est_id %>'); title='????????????'><img src="/acar/main_car_hp/images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;
		  <%    if(e_bean.getDoc_type().equals("")){%>
		  <a href="javascript:go_paper();" title='????????????'><img src="/acar/main_car_hp/images/button_paper.gif" border=0></a>
		  <%    }%>		  
		  		  
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