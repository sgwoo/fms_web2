<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.insur.*, acar.bill_mng.*, acar.user_mng.*, acar.accid.*, acar.cont.* "%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="cls" 	class="acar.insur.InsurClsBean" 		scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//보험관리번호
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cha_amt = request.getParameter("cha_amt")==null?"":request.getParameter("cha_amt");
	
	String update_yn = request.getParameter("update_yn")==null?"":request.getParameter("update_yn");
	String enp_no = request.getParameter("enp_no")==null?"":request.getParameter("enp_no");
	String lkas_yn = request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn");
	String ldws_yn = request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn");
	String aeb_yn = request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn");
	String fcw_yn = request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn");
	String ev_yn = request.getParameter("ev_yn")==null?"":request.getParameter("ev_yn");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	int flag = 0;
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
		
	InsurBean old_ins = ai_db.getInsCase(c_id, ins_st);


	InsurBean ins = ai_db.getInsCase(c_id, ins_st);
	
	
	String orgin_com_emp_yn = ins.getCom_emp_yn();
	
	
	if(mode.equals("0")){//상단 수정
		
		ins.setIns_st		(ins_st);
		ins.setIns_sts		(request.getParameter("ins_sts")==null?"":request.getParameter("ins_sts"));	//1:유효, 2:만료, 3:중도해지, 4:오프리스보험
		ins.setIns_com_id	(request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id"));
		ins.setIns_con_no	(request.getParameter("ins_con_no")==null?"":request.getParameter("ins_con_no"));
		ins.setConr_nm		(request.getParameter("conr_nm")==null?"":request.getParameter("conr_nm"));
		ins.setCon_f_nm		(request.getParameter("con_f_nm")==null?"":request.getParameter("con_f_nm"));
		ins.setIns_start_dt	(request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt"));
		ins.setIns_exp_dt	(request.getParameter("ins_exp_dt")==null?"":request.getParameter("ins_exp_dt"));
		ins.setCar_use		(request.getParameter("car_use")==null?"":request.getParameter("car_use"));
		ins.setAge_scp		(request.getParameter("age_scp")==null?"":request.getParameter("age_scp"));
		ins.setAir_ds_yn	(request.getParameter("air_ds_yn")==null?"N":request.getParameter("air_ds_yn"));
		ins.setAir_as_yn	(request.getParameter("air_as_yn")==null?"N":request.getParameter("air_as_yn"));
		ins.setCar_rate		(request.getParameter("car_rate")==null?"":request.getParameter("car_rate"));
		ins.setExt_rate		(request.getParameter("ext_rate")==null?"":request.getParameter("ext_rate"));
		ins.setIns_kd		(request.getParameter("ins_kd")==null?"":request.getParameter("ins_kd"));
		ins.setReg_cau		(request.getParameter("reg_cau")==null?"":request.getParameter("reg_cau"));
		ins.setAuto_yn		(request.getParameter("auto_yn")==null?"N":request.getParameter("auto_yn"));
		ins.setAbs_yn		(request.getParameter("abs_yn")==null?"N":request.getParameter("abs_yn"));
		ins.setBlackbox_yn	(request.getParameter("blackbox_yn")==null?"N":request.getParameter("blackbox_yn"));
		ins.setHook_yn		(request.getParameter("hook_yn")==null?"N":request.getParameter("hook_yn"));
		ins.setLegal_yn		(request.getParameter("legal_yn")==null?"N":request.getParameter("legal_yn"));
		ins.setUpdate_id	(user_id);
		ins.setCom_emp_yn	(request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn"));
		ins.setFirm_emp_nm	(request.getParameter("firm_emp_nm")==null?"":request.getParameter("firm_emp_nm"));
		ins.setLong_emp_yn	(request.getParameter("long_emp_yn")==null?"":request.getParameter("long_emp_yn"));
		ins.setBlackbox_nm		(request.getParameter("blackbox_nm")==null?"":request.getParameter("blackbox_nm"));
		ins.setBlackbox_amt		(request.getParameter("blackbox_amt")==null?0:Util.parseDigit(request.getParameter("blackbox_amt")));
		ins.setBlackbox_no		(request.getParameter("blackbox_no")==null?"":request.getParameter("blackbox_no"));
		ins.setBlackbox_dt		(request.getParameter("blackbox_dt")==null?"":request.getParameter("blackbox_dt"));
		ins.setEnp_no		(request.getParameter("enp_no")==null?"":request.getParameter("enp_no"));
		ins.setLkas_yn		(request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn"));
		ins.setLdws_yn		(request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn"));
		ins.setAeb_yn		(request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn"));
		ins.setFcw_yn		(request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn"));
		ins.setEv_yn		(request.getParameter("ev_yn")==null?"":request.getParameter("ev_yn"));
		ins.setOthers		(request.getParameter("others")==null?"":request.getParameter("others"));
		ins.setOthers_device		(request.getParameter("others_device")==null?"":request.getParameter("others_device"));
		
		

		if(orgin_com_emp_yn.equals("N") && ins.getCom_emp_yn().equals("Y")){
			// ins_com_emp_info 에 데이터가 있는지 확인			
			ins.setCom_emp_start_dt		(ins.getIns_start_dt());
			ins.setClient_nm		(client_id);
				
			if(!ai_db.insertInsComEmpInfo(ins))	flag += 1;
			
		}else if(orgin_com_emp_yn.equals("Y") && ins.getCom_emp_yn().equals("N")){
			//만료일 대입	
		    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			Calendar c1 = Calendar.getInstance();
			String strToday = sdf.format(c1.getTime());

			String ins_ext_dt = strToday;
			
			if(!ai_db.updateInsComEmpInfo(c_id, ins_st, ins_ext_dt,user_id  ))	flag += 1;
		}
		
		if(!ai_db.updateIns(ins))	flag += 1;
		
		
		//20140610 보험변동분 계약 연동 처리-------------------------------------------------------

		System.out.println("[보험변경점검] car_mng_id||ins_st = "+c_id+" "+ins_st);
		System.out.println("[피보험자]"+old_ins.getCon_f_nm()+"->"+ins.getCon_f_nm());
		System.out.println("[연령범위]"+old_ins.getAge_scp()+"->"+ins.getAge_scp());
	
		

		//피보험자
		if(!ins.getCon_f_nm().equals(old_ins.getCon_f_nm())){
		
		 	Hashtable ht_cont = a_db.getContViewUseYCarCase(c_id);
		 	
		 	//계약기타정보
			ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(ht_cont.get("RENT_MNG_ID")), String.valueOf(ht_cont.get("RENT_L_CD")));
			
			//아마존카피보험자에서 고객피보험자로
			if(old_ins.getCon_f_nm().equals("아마존카") && !ins.getCon_f_nm().equals("아마존카")){
				cont_etc.setInsur_per("2");
				
				System.out.println("[보험변동분 계약 연동 처리] 아마존카피보험자에서 고객피보험자로"+c_id);
			}
			//고객피보험자에서 아마존카피보험자로
			if(!old_ins.getCon_f_nm().equals("아마존카") && ins.getCon_f_nm().equals("아마존카")){
				cont_etc.setInsur_per("1");
				
				System.out.println("[보험변동분 계약 연동 처리] 고객피보험자에서 아마존카피보험자로"+c_id);
			}
			
			//=====[cont_etc] update=====
			boolean flag3 = a_db.updateContEtc(cont_etc);
			
		}
		
		//보험계약자
		if(!ins.getConr_nm().equals(old_ins.getConr_nm())){
		
		 	Hashtable ht_cont = a_db.getContViewUseYCarCase(c_id);
		 	
		 	//계약기타정보
			ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(ht_cont.get("RENT_MNG_ID")), String.valueOf(ht_cont.get("RENT_L_CD")));
			
			//아마존카보험계약자에서 고객보험계약자로
			if(old_ins.getConr_nm().equals("아마존카") && !ins.getConr_nm().equals("아마존카")){
				cont_etc.setInsurant("2");
				
				System.out.println("[보험변동분 계약 연동 처리] 아마존카보험계약자에서 고객보험계약자로"+c_id);
			}
			//고객보험계약자에서 아마존카보험계약자로
			if(!old_ins.getConr_nm().equals("아마존카") && ins.getConr_nm().equals("아마존카")){
				cont_etc.setInsurant("1");
				
				System.out.println("[보험변동분 계약 연동 처리] 고객보험계약자에서 아마존카보험계약자로"+c_id);
			}
			
			//=====[cont_etc] update=====
			boolean flag3 = a_db.updateContEtc(cont_etc);
			
		}		
		
		//연령범위
		if(!ins.getAge_scp().equals(old_ins.getAge_scp())){

		 	Hashtable ht_cont = a_db.getContViewUseYCarCase(c_id);
		 	
		 	//계약기본정보
			ContBaseBean base = a_db.getCont(String.valueOf(ht_cont.get("RENT_MNG_ID")), String.valueOf(ht_cont.get("RENT_L_CD")));
			
			if(ins.getAge_scp().equals("1"))	base.setDriving_age	("1"); 	//21세
			if(ins.getAge_scp().equals("2"))	base.setDriving_age	("0");	//26세
			if(ins.getAge_scp().equals("3"))	base.setDriving_age	("2");	//모든운전자
			if(ins.getAge_scp().equals("4"))	base.setDriving_age	("3");	//24세
			if(ins.getAge_scp().equals("5"))	base.setDriving_age	("5"); 	//30세
			if(ins.getAge_scp().equals("6"))	base.setDriving_age	("6");	//35세
			if(ins.getAge_scp().equals("7"))	base.setDriving_age	("7");	//43세
			if(ins.getAge_scp().equals("8"))	base.setDriving_age	("8");	//48세
			if(ins.getAge_scp().equals("9"))	base.setDriving_age	("9");	//22세
			if(ins.getAge_scp().equals("10"))	base.setDriving_age	("10");	//28세
			if(ins.getAge_scp().equals("11"))	base.setDriving_age	("11");	//49세
			
			System.out.println("[보험변동분 계약 연동 처리] 연령범위 변경"+c_id);
			
			boolean flag3 = a_db.updateContBaseNew(base);						
		 				
		}
		
		
		//20140610 보험변동분 계약 연동 처리-------------------------------------------------------		
		

	}
	else if(mode.equals("1")){//보험청약사항 수정
		
		ins.setIns_rent_dt	(request.getParameter("ins_rent_dt")==null?"":request.getParameter("ins_rent_dt"));
		ins.setRins_pcp_amt	(request.getParameter("rins_pcp_amt")==null?0:Util.parseDigit(request.getParameter("rins_pcp_amt")));
		ins.setVins_pcp_kd	(request.getParameter("vins_pcp_kd")==null?"":request.getParameter("vins_pcp_kd"));
		ins.setVins_pcp_amt	(request.getParameter("vins_pcp_amt")==null?0:Util.parseDigit(request.getParameter("vins_pcp_amt")));
		ins.setVins_gcp_kd	(request.getParameter("vins_gcp_kd")==null?"":request.getParameter("vins_gcp_kd"));
		ins.setVins_gcp_amt	(request.getParameter("vins_gcp_amt")==null?0:Util.parseDigit(request.getParameter("vins_gcp_amt")));
		ins.setVins_bacdt_kd	(request.getParameter("vins_bacdt_kd")==null?"":request.getParameter("vins_bacdt_kd"));
		ins.setVins_bacdt_kc2	(request.getParameter("vins_bacdt_kc2")==null?"":request.getParameter("vins_bacdt_kc2"));
		ins.setVins_bacdt_amt	(request.getParameter("vins_bacdt_amt")==null?0:Util.parseDigit(request.getParameter("vins_bacdt_amt")));
//		ins.setVins_canoisr_kd	(request.getParameter("vins_canoisr_kd")==null?0:request.getParameter("vins_canoisr_kd"));
		ins.setVins_canoisr_amt	(request.getParameter("vins_canoisr_amt")==null?0:Util.parseDigit(request.getParameter("vins_canoisr_amt")));
		ins.setVins_cacdt_car_amt(request.getParameter("vins_cacdt_car_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_car_amt")));
		ins.setVins_cacdt_me_amt(request.getParameter("vins_cacdt_me_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_me_amt")));
		ins.setVins_cacdt_cm_amt(request.getParameter("vins_cacdt_cm_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_cm_amt")));
		ins.setVins_cacdt_amt	(request.getParameter("vins_cacdt_cm_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_cm_amt")));
		ins.setVins_spe		(request.getParameter("vins_spe")==null?"":request.getParameter("vins_spe"));
		ins.setVins_spe_amt	(request.getParameter("vins_spe_amt")==null?0:Util.parseDigit(request.getParameter("vins_spe_amt")));
		ins.setPay_tm		(request.getParameter("pay_tm")==null?"":request.getParameter("pay_tm"));
		ins.setVins_cacdt_memin_amt(request.getParameter("vins_cacdt_memin_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_memin_amt")));
		ins.setVins_cacdt_mebase_amt(request.getParameter("vins_cacdt_mebase_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_mebase_amt")));
		ins.setUpdate_id(user_id);
		ins.setVins_share_extra_amt(request.getParameter("vins_share_extra_amt")==null?0:Util.parseDigit(request.getParameter("vins_share_extra_amt")));
		ins.setVins_blackbox_amt	(request.getParameter("vins_blackbox_amt")==null?0:Util.parseDigit(request.getParameter("vins_blackbox_amt")));
		ins.setVins_blackbox_per	(request.getParameter("vins_blackbox_per")==null?"N":request.getParameter("vins_blackbox_per"));
		ins.setHook_yn	(request.getParameter("hook_yn")==null?"N":request.getParameter("hook_yn"));
		ins.setLegal_yn	(request.getParameter("legal_yn")==null?"N":request.getParameter("legal_yn"));
		
		if(!ai_db.updateIns(ins))	flag += 1;
		
				
		//20140610 보험변동분 계약 연동 처리-------------------------------------------------------
		
		//대물배상
		if(!ins.getVins_gcp_kd().equals(old_ins.getVins_gcp_kd())){
			
		 	Hashtable ht_cont = a_db.getContViewUseYCarCase(c_id);
		 	
		 	//계약기본정보
			ContBaseBean base = a_db.getCont(String.valueOf(ht_cont.get("RENT_MNG_ID")), String.valueOf(ht_cont.get("RENT_L_CD")));
			
			//if(ins.getVins_gcp_kd().equals("1"))		base.setGcp_kd	("1"); 	//3천만원
			//if(ins.getVins_gcp_kd().equals("2"))		base.setGcp_kd	("0");	//1500만원
			if(ins.getVins_gcp_kd().equals("3"))		base.setGcp_kd	("2");	//1억원
			if(ins.getVins_gcp_kd().equals("4"))		base.setGcp_kd	("1");	//5천만원
			//if(ins.getVins_gcp_kd().equals("5"))		base.setGcp_kd	("5"); 	//1000만원
			if(ins.getVins_gcp_kd().equals("6"))		base.setGcp_kd	("3");	//5억원
			if(ins.getVins_gcp_kd().equals("7"))		base.setGcp_kd	("4");	//2억원
			if(ins.getVins_gcp_kd().equals("8"))		base.setGcp_kd	("8");	//3억원
			if(ins.getVins_gcp_kd().equals("9"))		base.setGcp_kd	("9");	//3억원
			
			System.out.println("[보험변동분 계약 연동 처리] 대물배상 변경"+c_id);
			
			boolean flag3 = a_db.updateContBaseNew(base);
						
		}

		//자기신체사고
		if(!ins.getVins_bacdt_kd().equals(old_ins.getVins_bacdt_kd())){
			
		 	Hashtable ht_cont = a_db.getContViewUseYCarCase(c_id);
		 	
		 	//계약기본정보
			ContBaseBean base = a_db.getCont(String.valueOf(ht_cont.get("RENT_MNG_ID")), String.valueOf(ht_cont.get("RENT_L_CD")));
			
			//if(ins.getVins_bacdt_kd().equals("1"))	base.setBacdt_kd	("1"); 	//3억원
			//if(ins.getVins_bacdt_kd().equals("2"))	base.setBacdt_kd	("0");	//1억5천만원
			//if(ins.getVins_bacdt_kd().equals("3"))	base.setBacdt_kd	("2");	//3천만원
			//if(ins.getVins_bacdt_kd().equals("4"))	base.setBacdt_kd	("1");	//1500만원
			if(ins.getVins_bacdt_kd().equals("5"))		base.setBacdt_kd	("1"); 	//5천만원
			if(ins.getVins_bacdt_kd().equals("6"))		base.setBacdt_kd	("2");	//1억원
			
			System.out.println("[보험변동분 계약 연동 처리] 자기신체사고 변경"+c_id);
			
			boolean flag3 = a_db.updateContBaseNew(base);
						
		}
		
		//20140610 보험변동분 계약 연동 처리-------------------------------------------------------
		
	}
	else if(mode.equals("2")){//보험변경사항 등록/수정
	
		String ch_dt = request.getParameter("r_ch_dt")==null?"":request.getParameter("r_ch_dt");
		String ch_item = request.getParameter("r_ch_item")==null?"":request.getParameter("r_ch_item");
		int ch_amt = request.getParameter("r_ch_amt")==null?0:Util.parseDigit(request.getParameter("r_ch_amt"));
		
		if(ch_item.equals("14")){
				String firm_emp_nm = request.getParameter("r_ch_after")==null?"":request.getParameter("r_ch_after");
				if(firm_emp_nm.indexOf("/")>0){
					String[] firm_emp_nm_v = firm_emp_nm.split("/", 3);
					String change_com_emp_nm = firm_emp_nm_v[0];
					String change_long_emp_yn = firm_emp_nm_v[1];
					if(change_com_emp_nm.equals("가입")){ins.setCom_emp_yn	("Y");}
					if(change_com_emp_nm.equals("미가입")){ins.setCom_emp_yn	("N");}
					ins.setFirm_emp_nm	(firm_emp_nm_v[1]);
					if(change_com_emp_nm.equals("장기")){ins.setLong_emp_yn	("Y");}
					if(change_com_emp_nm.equals("단기")){ins.setLong_emp_yn	("N");}
				}
				
				if(!ai_db.updateIns(ins))	flag += 1;
		}
	
		
		
		
		InsurChangeBean bean = new InsurChangeBean();
		bean.setCar_mng_id		(c_id);
		bean.setIns_st			(ins_st);
		bean.setCh_tm			(request.getParameter("r_ch_tm")==null?"":request.getParameter("r_ch_tm"));
		bean.setCh_dt			(ch_dt);
		bean.setCh_item			(request.getParameter("r_ch_item")==null?"":request.getParameter("r_ch_item"));
		bean.setCh_before		(request.getParameter("r_ch_before")==null?"":request.getParameter("r_ch_before"));
		bean.setCh_after		(request.getParameter("r_ch_after")==null?"":request.getParameter("r_ch_after"));
		bean.setCh_amt			(ch_amt);
		bean.setUpdate_id		(user_id);
		
		if(cmd.equals("i")){
			if(!ai_db.insertInsChange(bean)) flag += 1;
			
			//보험스케줄
			Vector ins_scd = ai_db.getInsScds(c_id, ins_st);
			int ins_scd_size = ins_scd.size();
			
			InsurScdBean scd = new InsurScdBean();
			scd.setCar_mng_id		(c_id);
			scd.setIns_st			(ins_st);
			scd.setIns_tm			(Integer.toString(ins_scd_size+1));
			
			if(ch_amt >0 ){	//추가납부 -> 다음달 10일
				scd.setIns_est_dt	(ch_dt);
				if(ins.getIns_com_id().equals("0008") || ins.getIns_com_id().equals("0038") || ins.getIns_com_id().equals("0007")){
					String ch_est_dt = c_db.addMonth(ch_dt, 1);
					ch_est_dt = ch_est_dt.substring(0,8)+"10";
					scd.setIns_est_dt	(ch_est_dt);
				}
				scd.setPay_dt		("");
				scd.setPay_yn		("0");
			}else{			//환급분 -> 실입금일
				scd.setIns_est_dt	(ch_dt);
				if(ins.getIns_com_id().equals("0008") || ins.getIns_com_id().equals("0038") || ins.getIns_com_id().equals("0007")){
					String ch_est_dt = c_db.addMonth(ch_dt, 1);
					ch_est_dt = ch_est_dt.substring(0,8)+"10";
					scd.setIns_est_dt	(ch_est_dt);
				}
				scd.setPay_dt		("");
				scd.setPay_yn		("0");
			}
			
			/*
			if(ch_item.equals("11")){//차량대체
				String ch_est_dt = c_db.addMonth(ch_dt, 1);
				ch_est_dt = ch_est_dt.substring(0,8)+"10";
				scd.setIns_est_dt(ch_est_dt);
				scd.setPay_dt("");
				scd.setPay_yn("0");
			}else{
				scd.setIns_est_dt(ch_dt);
				scd.setPay_dt(ch_dt);
				scd.setPay_yn("1");
			}
			*/
			//공휴일/주말일 경우 전날로 처리
			scd.setR_ins_est_dt		(ai_db.getValidDt(scd.getIns_est_dt()));
			scd.setPay_amt			(ch_amt);
			scd.setIns_tm2			("1");
			scd.setCh_tm			(bean.getCh_tm());
			
			if(!ai_db.insertInsScd(scd)) flag += 1;
			
			
			
			//1. 보험변경해서 추가납부인 경우 기간비용 처리 및 자동전표 생성
			//2. 동부화재일 경우 미수금,미지급금 바로 처리
			//if(scd.getPay_amt() > 0 || ins.getIns_com_id().equals("0008")){
				
				//기간비용 처리
				boolean b_flag = ai_db.settleInsurPrecost_InsCng(c_id, ins_st, ch_dt, ch_amt);
				
				
				
				//자동전표 생성
				
				//자동전표처리용
				Vector vt = new Vector();
				int line = 0;
				int count =0;
				String acct_cont = "";
				String acct_code = "";
				
				UsersBean user_bean 	= umd.getUsersBean(user_id);
				String no_emp_user_nm = user_bean.getUser_nm();
				if (no_emp_user_nm.equals("조민규")) {
					no_emp_user_nm = "고영은";
				}	
				Hashtable per 		= neoe_db.getPerinfoDept(no_emp_user_nm);	//-> neoe_db 변환
				String insert_id = String.valueOf(per.get("SA_CODE"));
							
				//보험사
				Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
				
				//대여차량선급보험료
				if(ins.getCar_use().equals("1")){
					acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " 영업용";
					acct_code = "13300";
				//리스차량선급보험료
				}else{
					acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " 업무용";
					acct_code = "13200";
				}
				
				if(scd.getPay_amt() > 0){
					acct_cont = acct_cont+ " 변경 ("+String.valueOf(cont.get("CAR_NO"))+")";
				}else{
					acct_cont = acct_cont+ " 변경환급 ("+String.valueOf(cont.get("CAR_NO"))+")";
					
					ch_amt = 0-ch_amt;
				}
				
				
				
				line++;
				
				//선급보험료
				Hashtable ht1 = new Hashtable();
				ht1.put("DATA_GUBUN", 	"53");
				ht1.put("WRITE_DATE", 	ch_dt);
				ht1.put("DATA_NO",    	"");
				ht1.put("DATA_LINE",  	String.valueOf(line));
				ht1.put("DATA_SLIP",  	"1");
				ht1.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
				ht1.put("NODE_CODE",  	"S101");
				ht1.put("C_CODE",     	"1000");
				ht1.put("DATA_CODE",  	"");
				ht1.put("DOCU_STAT",  	"0");
				ht1.put("DOCU_TYPE",  	"11");
				ht1.put("DOCU_GUBUN", 	"3");
				ht1.put("AMT_GUBUN",  	"3");//차변
				ht1.put("DR_AMT",    	ch_amt);
				ht1.put("CR_AMT",     	"0");
				if(scd.getPay_amt() < 0){
					ht1.put("AMT_GUBUN",  	"4");//대변
					ht1.put("DR_AMT",    	"0");
					ht1.put("CR_AMT",     	ch_amt);
				}
				ht1.put("ACCT_CODE",  	acct_code);
				ht1.put("CHECK_CODE1",	"A19");//전표번호
				ht1.put("CHECK_CODE2",	"A07");//거래처
				ht1.put("CHECK_CODE3",	"A05");//표준적요
				ht1.put("CHECK_CODE4",	"");
				ht1.put("CHECK_CODE5",	"");
				ht1.put("CHECK_CODE6",	"");
				ht1.put("CHECK_CODE7",	"");
				ht1.put("CHECK_CODE8",	"");
				ht1.put("CHECK_CODE9",	"");
				ht1.put("CHECK_CODE10",	"");
				ht1.put("CHECKD_CODE1",	"");//전표번호
				ht1.put("CHECKD_CODE2",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
				ht1.put("CHECKD_CODE3",	"");//표준적요
				ht1.put("CHECKD_CODE4",	"");
				ht1.put("CHECKD_CODE5",	"");
				ht1.put("CHECKD_CODE6",	"");
				ht1.put("CHECKD_CODE7",	"");
				ht1.put("CHECKD_CODE8",	"");
				ht1.put("CHECKD_CODE9",	"");
				ht1.put("CHECKD_CODE10","");
				ht1.put("CHECKD_NAME1",	"");//전표번호
				ht1.put("CHECKD_NAME2",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
				ht1.put("CHECKD_NAME3",	acct_cont);//표준적요
				ht1.put("CHECKD_NAME4",	"");
				ht1.put("CHECKD_NAME5",	"");
				ht1.put("CHECKD_NAME6",	"");
				ht1.put("CHECKD_NAME7",	"");
				ht1.put("CHECKD_NAME8",	"");
				ht1.put("CHECKD_NAME9",	"");
				ht1.put("CHECKD_NAME10","");
				ht1.put("INSERT_ID",	insert_id);
				
				line++;
				
				//미지급금
				Hashtable ht2 = new Hashtable();
				ht2.put("DATA_GUBUN", 	"53");
				ht2.put("WRITE_DATE", 	ch_dt);
				ht2.put("DATA_NO",    	"");
				ht2.put("DATA_LINE",  	String.valueOf(line));
				ht2.put("DATA_SLIP",  	"1");
				ht2.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
				ht2.put("NODE_CODE",  	"S101");
				ht2.put("C_CODE",     	"1000");
				ht2.put("DATA_CODE",  	"");
				ht2.put("DOCU_STAT",  	"0");
				ht2.put("DOCU_TYPE",  	"11");
				ht2.put("DOCU_GUBUN", 	"3");
				ht2.put("AMT_GUBUN",  	"4");//대변
				ht2.put("DR_AMT",    	"0");
				ht2.put("CR_AMT",     	ch_amt);
				ht2.put("ACCT_CODE",  	"25300");
				ht2.put("CHECK_CODE1",	"A07");//거래처
				ht2.put("CHECK_CODE2",	"A19");//전표번호
				ht2.put("CHECK_CODE3",	"F47");//신용카드번호
				ht2.put("CHECK_CODE4",	"A13");//project
				ht2.put("CHECK_CODE5",	"A05");//표준적요
				ht2.put("CHECK_CODE6",	"");
				ht2.put("CHECK_CODE7",	"");
				ht2.put("CHECK_CODE8",	"");
				ht2.put("CHECK_CODE9",	"");
				ht2.put("CHECK_CODE10",	"");
				ht2.put("CHECKD_CODE1",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
				ht2.put("CHECKD_CODE2",	"");//전표번호
				ht2.put("CHECKD_CODE3",	"");//신용카드번호
				ht2.put("CHECKD_CODE4",	"");//project
				ht2.put("CHECKD_CODE5",	"0");//표준적요
				ht2.put("CHECKD_CODE6",	"");
				ht2.put("CHECKD_CODE7",	"");
				ht2.put("CHECKD_CODE8",	"");
				ht2.put("CHECKD_CODE9",	"");
				ht2.put("CHECKD_CODE10","");
				ht2.put("CHECKD_NAME1",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
				ht2.put("CHECKD_NAME2",	"");//전표번호
				ht2.put("CHECKD_NAME3",	"");//신용카드번호
				ht2.put("CHECKD_NAME4",	"");//project
				ht2.put("CHECKD_NAME5",	acct_cont);//표준적요
				ht2.put("CHECKD_NAME6",	"");
				ht2.put("CHECKD_NAME7",	"");
				ht2.put("CHECKD_NAME8",	"");
				ht2.put("CHECKD_NAME9",	"");
				ht2.put("CHECKD_NAME10","");
				if(scd.getPay_amt() < 0){//미수금
					ht2.put("AMT_GUBUN",  	"3");//차변
					ht2.put("DR_AMT",    	ch_amt);
					ht2.put("CR_AMT",     	"0");
					ht2.put("ACCT_CODE",  	"12000");
					ht2.put("CHECK_CODE1",	"A07");//거래처
					ht2.put("CHECK_CODE2",	"F19");//발생일자
					ht2.put("CHECK_CODE3",	"A19");//전표번호
					ht2.put("CHECK_CODE4",	"A05");//표준적요
					ht2.put("CHECK_CODE5",	"");
					ht2.put("CHECK_CODE6",	"");
					ht2.put("CHECK_CODE7",	"");
					ht2.put("CHECK_CODE8",	"");
					ht2.put("CHECK_CODE9",	"");
					ht2.put("CHECK_CODE10",	"");
					ht2.put("CHECKD_CODE1",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
					ht2.put("CHECKD_CODE2",	"");//발생일자
					ht2.put("CHECKD_CODE3",	"");//전표번호
					ht2.put("CHECKD_CODE4",	"0");//표준적요
					ht2.put("CHECKD_CODE5",	"");
					ht2.put("CHECKD_CODE6",	"");
					ht2.put("CHECKD_CODE7",	"");
					ht2.put("CHECKD_CODE8",	"");
					ht2.put("CHECKD_CODE9",	"");
					ht2.put("CHECKD_CODE10","");
					ht2.put("CHECKD_NAME1",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
					ht2.put("CHECKD_NAME2",	"");//발생일자
					ht2.put("CHECKD_NAME3",	"");//전표번호
					ht2.put("CHECKD_NAME4",	acct_cont);//표준적요
					ht2.put("CHECKD_NAME5",	"");
					ht2.put("CHECKD_NAME6",	"");
					ht2.put("CHECKD_NAME7",	"");
					ht2.put("CHECKD_NAME8",	"");
					ht2.put("CHECKD_NAME9",	"");
					ht2.put("CHECKD_NAME10","");
				}
				ht2.put("INSERT_ID",	insert_id);
				
				vt.add(ht1);
				vt.add(ht2);
				
				if(line > 0 && vt.size() > 0){
					
					String row_id = neoe_db.insertDebtSettleAutoDocu(ch_dt, vt);	//-> neoe_db 변환
				}
				
			//}
			
			
		}else if(cmd.equals("u")){
			if(!ai_db.updateInsChange(bean)) flag += 1;
		}else if(cmd.equals("d")){
			if(!ai_db.dropInsChange(c_id, ins_st, request.getParameter("r_ch_tm"))) flag += 1;
		}
		
		
		//기간비용 삭제후 재계산
		/*
		PrecostBean cost = new PrecostBean();
		cost.setCar_mng_id	(c_id);
		cost.setCost_st		("2");//1:자동차세 2:보험료
		cost.setCost_id		(ins_st);
		if(!ai_db.deletePrecost(cost)) flag += 1;
		
			Hashtable ht = ai_db.getInsurPrecost(c_id, ins_st);
			String car_mng_id	= String.valueOf(ht.get("CAR_MNG_ID"));
			String cost_id		= String.valueOf(ht.get("INS_ST"));
			String ins_start_dt = String.valueOf(ht.get("INS_START_DT"));
			String ins_end_dt	= String.valueOf(ht.get("INS_EXP_DT"));
			float tot_amt		= AddUtil.parseFloat(String.valueOf(ht.get("TOT_AMT")));
			float tot_days		= AddUtil.parseFloat(String.valueOf(ht.get("TOT_DAYS")));
			float use_days		= 0.0f;
			float rest_days		= tot_days;
			float use_amt		= 0.0f;
			float rest_amt		= tot_amt;
			int count3			= 0;
			String cost_dt		= "";
			//1회차 시작일
			String f_use_s_dt 	= ins_start_dt;
			//1회차 실종료일
			String f_use_e_dt 	= ins_start_dt.substring(0,6)+""+AddUtil.getMonthDate(AddUtil.parseInt(ins_start_dt.substring(0,4)), AddUtil.parseInt(ins_start_dt.substring(4,6)));
			if(AddUtil.parseInt(ins_start_dt.substring(0,6)) == AddUtil.parseInt(ins_end_dt.substring(0,6))){//1회차만 있을 경우
				f_use_e_dt = ins_end_dt;
			}
			//2회차 실시작일
			String t_use_s_dt 	= AddUtil.replace(c_db.addDay(f_use_e_dt, 1),"-","");
			for(int j = 0 ; j < 13 ; j++){
				PrecostBean cost2 = new PrecostBean();
				cost2.setCar_mng_id	(car_mng_id);
				cost2.setCost_st		("2");//1:자동차세 2:보험료
				cost2.setCost_id		(cost_id);
				cost2.setCost_tm		(String.valueOf(j+1));
				if(j == 0){//1회차
					cost_dt = f_use_s_dt;
					use_days = AddUtil.parseFloat(rs_db.getDay(cost_dt, f_use_e_dt));//일할금액계산하기
					cost2.setCost_ym	(cost_dt.substring(0,6));
				}else{
					if(AddUtil.parseInt(ins_start_dt.substring(0,6)) == AddUtil.parseInt(ins_end_dt.substring(0,6))){//1회차만 있을 경우
						break;
					}
					cost_dt = AddUtil.replace(c_db.addMonth(t_use_s_dt, count3),"-","");
					if(AddUtil.parseInt(cost_dt.substring(0,6)) == AddUtil.parseInt(ins_end_dt.substring(0,6))){//마지막회차
						use_days = rest_days;
					}else if(AddUtil.parseInt(cost_dt.substring(0,6)) <  AddUtil.parseInt(ins_end_dt.substring(0,6))){
						use_days = AddUtil.getMonthDate(AddUtil.parseInt(cost_dt.substring(0,4)), AddUtil.parseInt(cost_dt.substring(4,6)));
					}else{
						break;
					}
					count3++;
				}
				if(AddUtil.parseInt(cost_dt.substring(0,6)) == AddUtil.parseInt(ins_end_dt.substring(0,6))){//마지막회차
					use_amt = rest_amt;
				}else{
					use_amt = Math.round(tot_amt/tot_days*use_days);
				}
				rest_days -= use_days;
				rest_amt  -= use_amt;
				cost2.setCost_ym (cost_dt.substring(0,6));
				cost2.setCost_day(use_days);
				cost2.setCost_amt(use_amt);
				cost2.setRest_day(rest_days);
				cost2.setRest_amt(rest_amt);
				cost2.setUpdate_id(user_id);
				
				if(!ai_db.insertPrecost(cost2)) flag += 1;
			}
		*/
	}
	else if(mode.equals("3") || mode.equals("pay")){//보험스케줄 등록/수정
		
		String ins_est_dt = request.getParameter("r_ins_est_dt")==null?"":request.getParameter("r_ins_est_dt");
		String ins_est_dt2 = request.getParameter("r_ins_est_dt2")==null?"":request.getParameter("r_ins_est_dt2");
		String pay_dt = request.getParameter("r_pay_dt")==null?"":request.getParameter("r_pay_dt");
		String o_pay_dt = request.getParameter("r_o_pay_dt")==null?"":request.getParameter("r_o_pay_dt");
		String r_ins_tm = request.getParameter("r_ins_tm")==null?"":request.getParameter("r_ins_tm");
		String r_ch_tm = request.getParameter("r_ch_tm")==null?"":request.getParameter("r_ch_tm");
		
		InsurScdBean scd = ai_db.getInsScd(c_id, ins_st, r_ins_tm);
		
		scd.setIns_est_dt	(ins_est_dt);
		//공휴일/주말일 경우 전날로 처리
		scd.setR_ins_est_dt	(ai_db.getValidDt(ins_est_dt));
		scd.setPay_amt			(request.getParameter("r_pay_amt")==null?0:Util.parseDigit(request.getParameter("r_pay_amt")));
		scd.setPay_dt				(pay_dt);
		if(pay_dt.equals(""))		scd.setPay_yn("0");
		else						scd.setPay_yn("1");
		scd.setIns_tm2			(request.getParameter("r_ins_tm2")==null?"":request.getParameter("r_ins_tm2"));
		scd.setExcel_chk		(request.getParameter("excel_chk")==null?"":request.getParameter("excel_chk"));
		scd.setCh_tm				(r_ch_tm);
		
		if(cmd.equals("i")){
			scd.setCar_mng_id	(c_id);
			scd.setIns_st		(ins_st);
			scd.setIns_tm		(r_ins_tm);
			if(!ai_db.insertInsScd(scd)) flag += 1;
		}else if(cmd.equals("u")){
			if(!ai_db.updateInsScd(scd)) flag += 1;
		}else if(cmd.equals("d")){
			if(!scd.getCh_tm().equals("")){
			  InsurChangeBean ic_bean = ai_db.getInsChange(c_id, ins_st, scd.getCh_tm());
				//기간비용 처리
				boolean b_flag = ai_db.settleInsurPrecost_InsCng(c_id, ins_st, ic_bean.getCh_dt(), 0-scd.getPay_amt());
				if(!ai_db.dropInsChange(c_id, ins_st, scd.getCh_tm())) flag += 1;
			}
			if(!ai_db.dropInsScd(c_id, ins_st, request.getParameter("r_ins_tm"))) flag += 1;
		}
		
		String autodocu_st = "";
		int autodocu_amt = 0;
		//해지보험료 입금처리시 해지테이블도 수정
		if(request.getParameter("r_ins_tm2").equals("2") && !pay_dt.equals("") && o_pay_dt.equals("")){
			//해지보험정보
			cls = ai_db.getInsurClsCase(c_id, ins_st);
			cls.setRtn_amt		(request.getParameter("r_pay_amt"	)==null?0 :Util.parseDigit(request.getParameter("r_pay_amt"	)));
			cls.setRtn_dt		(request.getParameter("r_pay_dt"	)==null?"":request.getParameter("r_pay_dt"	)); 
			cls.setUpd_id		(user_id);
			if(!ai_db.updateInsCls(cls))	flag += 1;
			
			if(!ins.getIns_com_id().equals("0008") && !ins.getIns_com_id().equals("0038")){ // 동부화재는 해지등록시 이미 처리함.
				//기간비용 처리
				boolean b_flag = ai_db.settleInsurPrecost_ClsRtn(c_id, ins_st, pay_dt, scd.getPay_amt());
			}
			//기간비용정산
//			if(!ai_db.settleInsurPrecost(ins, pay_dt, -scd.getPay_amt()))	flag += 1;
			
			autodocu_st = "cls_amt1";
			autodocu_amt = scd.getPay_amt();
		}
		
		//변경환급보험료 입금처리시 해지테이블도 수정
		if(request.getParameter("r_ins_tm2").equals("1") && !pay_dt.equals("") && o_pay_dt.equals("") && scd.getPay_amt() < 0){
			
			if(!ins.getIns_com_id().equals("0008") && !ins.getIns_com_id().equals("0038")){ // 동부화재는 변경환급 등록시 이미 처리함.
				//기간비용 처리
				boolean b_flag = ai_db.settleInsurPrecost_InsCng(c_id, ins_st, pay_dt, scd.getPay_amt());
			}
			
			autodocu_st = "cls_amt2";
			autodocu_amt = 0-scd.getPay_amt();
		}
		
		//입금관리에서 처리한다.
		autodocu_st = "";
		autodocu_amt = 0;
		
		//환급보험료 입금시 자동전표 처리
		if(!ins.getIns_com_id().equals("0008") && !ins.getIns_com_id().equals("0038") && !autodocu_st.equals("") && autodocu_amt>0){
			
			
			//자동전표처리용
			Vector vt = new Vector();
			int line = 0;
			int count =0;
			String acct_cont = "[해지보험료환급]"+String.valueOf(cont.get("CAR_NO"));
			String acct_code = "";
			
			if(autodocu_st.equals("cls_amt2")) acct_code = "[변경보험료환급]"+String.valueOf(cont.get("CAR_NO"));
			
			UsersBean user_bean 	= umd.getUsersBean(user_id);
			Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());	//-> neoe_db 변환
			String insert_id = String.valueOf(per.get("SA_CODE"));
			
			//보험사
			Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
			
			//대여차량선급보험료
			if(ins.getCar_use().equals("1")){
				acct_code = "13300";
			//리스차량선급보험료
			}else{
				acct_code = "13200";
			}
			
			//20120111추가-------------------------------------------------------
			
			//해지보험정보
			cls = ai_db.getInsurClsCase(c_id, ins_st);
			//보험스케줄
			Vector ins_scd = ai_db.getInsScds(c_id, ins_st);
			int ins_scd_size = ins_scd.size();
			for(int i = 0 ; i < ins_scd_size ; i++){
				InsurScdBean scd2 = (InsurScdBean)ins_scd.elementAt(i);
				if(scd2.getIns_tm2().equals("2")){
					if(ins.getIns_com_id().equals("0007")){//삼성화재
						if(!ai_db.deleteNextPrecostClsInsAct2(c_id, ins_st, scd2.getPay_dt(), scd2.getPay_amt())) flag += 1;
					}else if(ins.getIns_com_id().equals("0008") || ins.getIns_com_id().equals("0038")){//동부화재
						if(!ai_db.deleteNextPrecostClsInsAct2(c_id, ins_st, cls.getReq_dt(), scd2.getPay_amt())) flag += 1;
					}
					
					if(flag==0) cha_amt = "0";
				}
			}
			//20120111추가-------------------------------------------------------
				
			
			line++;
			
			
			//선급보험료
			Hashtable ht1 = new Hashtable();
			ht1.put("DATA_GUBUN", 	"53");
			ht1.put("WRITE_DATE", 	pay_dt);
			ht1.put("DATA_NO",    	"");
			ht1.put("DATA_LINE",  	String.valueOf(line));
			ht1.put("DATA_SLIP",  	"1");
			ht1.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
			ht1.put("NODE_CODE",  	"S101");
			ht1.put("C_CODE",     	"1000");
			ht1.put("DATA_CODE",  	"");
			ht1.put("DOCU_STAT",  	"0");
			ht1.put("DOCU_TYPE",  	"11");
			ht1.put("DOCU_GUBUN", 	"3");
			ht1.put("AMT_GUBUN",  	"4");//대변
			ht1.put("DR_AMT",    	"0");
			ht1.put("CR_AMT",     	autodocu_amt);
			ht1.put("ACCT_CODE",  	acct_code);
			ht1.put("CHECK_CODE1",	"A19");//전표번호
			ht1.put("CHECK_CODE2",	"A07");//거래처
			ht1.put("CHECK_CODE3",	"A05");//표준적요
			ht1.put("CHECK_CODE4",	"");
			ht1.put("CHECK_CODE5",	"");
			ht1.put("CHECK_CODE6",	"");
			ht1.put("CHECK_CODE7",	"");
			ht1.put("CHECK_CODE8",	"");
			ht1.put("CHECK_CODE9",	"");
			ht1.put("CHECK_CODE10",	"");
			ht1.put("CHECKD_CODE1",	"");//전표번호
			ht1.put("CHECKD_CODE2",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
			ht1.put("CHECKD_CODE3",	"");//표준적요
			ht1.put("CHECKD_CODE4",	"");
			ht1.put("CHECKD_CODE5",	"");
			ht1.put("CHECKD_CODE6",	"");
			ht1.put("CHECKD_CODE7",	"");
			ht1.put("CHECKD_CODE8",	"");
			ht1.put("CHECKD_CODE9",	"");
			ht1.put("CHECKD_CODE10","");
			ht1.put("CHECKD_NAME1",	"");//전표번호
			ht1.put("CHECKD_NAME2",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
			ht1.put("CHECKD_NAME3",	acct_cont);//표준적요
			ht1.put("CHECKD_NAME4",	"");
			ht1.put("CHECKD_NAME5",	"");
			ht1.put("CHECKD_NAME6",	"");
			ht1.put("CHECKD_NAME7",	"");
			ht1.put("CHECKD_NAME8",	"");
			ht1.put("CHECKD_NAME9",	"");
			ht1.put("CHECKD_NAME10","");
			ht1.put("INSERT_ID",	insert_id);
			
			line++;
			
			//보통예금
			Hashtable ht2 = new Hashtable();
			ht2.put("DATA_GUBUN", 	"53");
			ht2.put("WRITE_DATE", 	pay_dt);
			ht2.put("DATA_NO",    	"");
			ht2.put("DATA_LINE",  	String.valueOf(line));
			ht2.put("DATA_SLIP",  	"1");
			ht2.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
			ht2.put("NODE_CODE",  	"S101");
			ht2.put("C_CODE",     	"1000");
			ht2.put("DATA_CODE",  	"");
			ht2.put("DOCU_STAT",  	"0");
			ht2.put("DOCU_TYPE",  	"11");
			ht2.put("DOCU_GUBUN", 	"3");
			ht2.put("AMT_GUBUN",  	"3");//차변
			ht2.put("DR_AMT",    	autodocu_amt);
			ht2.put("CR_AMT",     	"0");
			ht2.put("ACCT_CODE",  	"10300");
			ht2.put("CHECK_CODE1",	"A03");//금융기관
			ht2.put("CHECK_CODE2",	"F05");//예적금계좌번호
			ht2.put("CHECK_CODE3",	"F10");//자금과목
			ht2.put("CHECK_CODE4",	"A05");//표준적요
			ht2.put("CHECKD_CODE1",	"260");//금융기관
			ht2.put("CHECKD_CODE2",	"140-004-023871");//예적금계좌번호
			ht2.put("CHECKD_CODE3",	"");//자금과목
			ht2.put("CHECKD_CODE4",	"0");//표준적요
			ht2.put("CHECKD_NAME1",	"신한");//금융기관
			ht2.put("CHECKD_NAME2",	"140-004-023871");//예적금계좌번호
			ht2.put("CHECKD_NAME3",	"");//자금과목
			ht2.put("CHECKD_NAME4",	acct_cont);//표준적요
			ht2.put("CHECK_CODE5",	"");
			ht2.put("CHECK_CODE6",	"");
			ht2.put("CHECK_CODE7",	"");
			ht2.put("CHECK_CODE8",	"");
			ht2.put("CHECK_CODE9",	"");
			ht2.put("CHECK_CODE10",	"");
			ht2.put("CHECKD_CODE5",	"");
			ht2.put("CHECKD_CODE6",	"");
			ht2.put("CHECKD_CODE7",	"");
			ht2.put("CHECKD_CODE8",	"");
			ht2.put("CHECKD_CODE9",	"");
			ht2.put("CHECKD_CODE10","");
			ht2.put("CHECKD_NAME5",	"");
			ht2.put("CHECKD_NAME6",	"");
			ht2.put("CHECKD_NAME7",	"");
			ht2.put("CHECKD_NAME8",	"");
			ht2.put("CHECKD_NAME9",	"");
			ht2.put("CHECKD_NAME10","");
			ht2.put("INSERT_ID",	insert_id);
			
			vt.add(ht1);
			vt.add(ht2);
			
			if(line > 0 && vt.size() > 0){
				
				String row_id = neoe_db.insertDebtSettleAutoDocu(pay_dt, vt);	//-> neoe_db 변환
				
				if(row_id.equals("")){
					count = 1;
				}
			}
			
		}
	}
	else if(mode.equals("7")){//기간비용
		
	
		PrecostBean cost = new PrecostBean();
		
		cost.setCar_mng_id	(c_id);
		cost.setCost_id		(ins_st);
		cost.setCost_st		("2");
		cost.setCost_tm		(request.getParameter("r_cost_tm")==null?"":request.getParameter("r_cost_tm"));
		cost.setCost_ym		(request.getParameter("r_cost_ym")==null?"":request.getParameter("r_cost_ym"));
		cost.setCost_day	(request.getParameter("r_cost_day")==null?0:AddUtil.parseDigit2(request.getParameter("r_cost_day")));
		cost.setCost_amt	(request.getParameter("r_cost_amt")==null?0:AddUtil.parseDigit2(request.getParameter("r_cost_amt")));
		cost.setRest_day	(request.getParameter("r_rest_day")==null?0:AddUtil.parseDigit2(request.getParameter("r_rest_day")));
		cost.setRest_amt	(request.getParameter("r_rest_amt")==null?0:AddUtil.parseDigit2(request.getParameter("r_rest_amt")));
		cost.setUpdate_id	(user_id);
		cost.setCar_no		(String.valueOf(cont.get("CAR_NO")));
		cost.setCar_use		(ins.getCar_use());
		
		if(cost.getCost_tm().equals("1")){
			cost.setCost_tm2("1");
		}
		
		if(cmd.equals("i")){		
			if(!ai_db.insertPrecost(cost)) flag += 1;
		}else if(cmd.equals("u")){
			if(!ai_db.updatePrecost(cost)) flag += 1;
		}else if(cmd.equals("d")){
			if(!ai_db.deletePrecostCase(cost)) flag += 1;
		}else if(cmd.equals("d_next")){
			if(!ai_db.deleteNextPrecostCase(cost)) flag += 1;
		}else if(cmd.equals("cls_ins_costs")){//해지로 인한 기간비용 정리하기
			if(Util.parseInt(cha_amt) >0 ){
				//해지보험정보
				cls = ai_db.getInsurClsCase(c_id, ins_st);
				//보험스케줄
				Vector ins_scd = ai_db.getInsScds(c_id, ins_st);
				int ins_scd_size = ins_scd.size();
				for(int i = 0 ; i < ins_scd_size ; i++){
					InsurScdBean scd = (InsurScdBean)ins_scd.elementAt(i);										
					if(scd.getIns_tm2().equals("2")){						
						if(ins.getIns_com_id().equals("0007")){//삼성화재
							if(!ai_db.deleteNextPrecostClsInsAct2(c_id, ins_st, scd.getPay_dt(), scd.getPay_amt())) flag += 1;							
						}else if(ins.getIns_com_id().equals("0008") || ins.getIns_com_id().equals("0038")){//동부화재
							if(!ai_db.deleteNextPrecostClsInsAct2(c_id, ins_st, cls.getReq_dt(), scd.getPay_amt())) flag += 1;
						}
						
						if(flag==0) cha_amt = "0";
					}
				}
			}
		}else if(cmd.equals("reg_costs")){
					
			if(!ai_db.deletePrecost(cost)) flag += 1;
			Hashtable ht = ai_db.getInsurPrecost(c_id, ins_st);
			String car_mng_id	= String.valueOf(ht.get("CAR_MNG_ID"));
			String cost_id		= String.valueOf(ht.get("INS_ST"));
			String ins_start_dt 	= String.valueOf(ht.get("INS_RENT_DT"));
			if(ins_start_dt.equals("")){
				ins_start_dt 	= String.valueOf(ht.get("INS_START_DT"));
			}
			String ins_end_dt	= String.valueOf(ht.get("INS_EXP_DT"));
			float tot_amt		= AddUtil.parseFloat(String.valueOf(ht.get("TOT_AMT")));			
			float tot_days		= AddUtil.parseFloat(String.valueOf(ht.get("TOT_DAYS")));
			float use_days		= 0.0f;
			float rest_days		= tot_days;
			float use_amt		= 0.0f;
			float rest_amt		= tot_amt;
			int count3		= 0;
			String cost_dt		= "";
			//1회차 시작일
			String f_use_s_dt 	= ins_start_dt;
			//System.out.println(ins_start_dt);
			//if(1==1)return;
			//1회차 실종료일
			String f_use_e_dt 	= ins_start_dt.substring(0,6)+""+AddUtil.getMonthDate(AddUtil.parseInt(ins_start_dt.substring(0,4)), AddUtil.parseInt(ins_start_dt.substring(4,6)));
			if(AddUtil.parseInt(ins_start_dt.substring(0,6)) == AddUtil.parseInt(ins_end_dt.substring(0,6))){//1회차만 있을 경우
				f_use_e_dt = ins_end_dt;
			}
			
			//System.out.println("첫금액:"+tot_amt);
			//2회차 실시작일
			String t_use_s_dt 	= AddUtil.replace(c_db.addDay(f_use_e_dt, 1),"-","");
			for(int j = 0 ; j < 13 ; j++){
				PrecostBean cost2 = new PrecostBean();
				cost2.setCar_mng_id	(car_mng_id);
				cost2.setCost_st		("2");//1:자동차세 2:보험료
				cost2.setCost_id		(cost_id);
				cost2.setCost_tm		(String.valueOf(j+1));
				if(j == 0){//1회차
					cost_dt = f_use_s_dt;
					use_days = AddUtil.parseFloat(rs_db.getDay(cost_dt, f_use_e_dt));//일할금액계산하기
					cost2.setCost_ym	(cost_dt.substring(0,6));
				}else{
					if(AddUtil.parseInt(ins_start_dt.substring(0,6)) == AddUtil.parseInt(ins_end_dt.substring(0,6))){//1회차만 있을 경우
						break;
					}
					cost_dt = AddUtil.replace(c_db.addMonth(t_use_s_dt, count3),"-","");
					if(AddUtil.parseInt(cost_dt.substring(0,6)) == AddUtil.parseInt(ins_end_dt.substring(0,6))){//마지막회차
						use_days = rest_days;
					}else if(AddUtil.parseInt(cost_dt.substring(0,6)) <  AddUtil.parseInt(ins_end_dt.substring(0,6))){
						use_days = AddUtil.getMonthDate(AddUtil.parseInt(cost_dt.substring(0,4)), AddUtil.parseInt(cost_dt.substring(4,6)));
					}else{
						break;
					}
					count3++;
				}
				if(AddUtil.parseInt(cost_dt.substring(0,6)) == AddUtil.parseInt(ins_end_dt.substring(0,6))){//마지막회차
				//if(rest_amt < Math.round(tot_amt/12)){
					use_amt = rest_amt;
					use_days = rest_days;
				}else{
					//if(j == 0){//1회차				   
						use_amt = Math.round(tot_amt/tot_days*use_days);
					//}else{//중간회차는 월계산
					//	use_amt = Math.round(tot_amt/12);
					//	use_days = 31;
					//}
				}
				rest_days -= use_days;
				rest_amt  -= use_amt;
				
				
				cost2.setCost_ym	(cost_dt.substring(0,6));
				cost2.setCost_day	(use_days);
				cost2.setCost_amt	(use_amt);
				cost2.setRest_day	(rest_days);
				cost2.setRest_amt	(rest_amt);
				cost2.setUpdate_id	(user_id);
				cost2.setCar_no		(String.valueOf(cont.get("CAR_NO")));
				cost2.setCar_use	(ins.getCar_use());
				if(j==0){
					cost2.setCost_tm2("1");
				}
				
				if(use_amt+rest_amt >0){
						if(!ai_db.insertPrecost(cost2)) flag += 1;				
				}
				
			}
		}
		
	}
	else if(mode.equals("4") || mode.equals("cls")){//보험해지 수정
		String car_use = request.getParameter("car_use")==null?"":request.getParameter("car_use");//보험종류-영업용/업무용
		String ins_kd = request.getParameter("ins_kd")==null?"":request.getParameter("ins_kd");//담보종류-전담보/책임보험
		String exp_yn1 = "N";
		
		//해지보험정보
		cls = ai_db.getInsurClsCase(c_id, ins_st);
		
		cls.setExp_dt		(request.getParameter("exp_dt"		)==null?"":request.getParameter("exp_dt"	));
		cls.setReq_dt		(request.getParameter("req_dt"		)==null?"":request.getParameter("req_dt"	));
		cls.setCls_st		(request.getParameter("cls_st"		)==null?"":request.getParameter("cls_st"	));
		cls.setExp_aim		(request.getParameter("exp_aim"		)==null?"":request.getParameter("exp_aim"	));
		
		if(!cls.getCls_st().equals("2")){
			
			if(ins_kd.equals("2")){//책임보험
				cls.setUse_day1		(request.getParameter("use_day"	)==null?0 :Util.parseDigit(request.getParameter("use_day")));
				cls.setUse_amt1		(request.getParameter("use_amt"	)==null?0 :Util.parseDigit(request.getParameter("use_amt")));
				cls.setExp_yn1		(request.getParameter("exp_yn"	)==null?"N":request.getParameter("exp_yn"	));
			}else{//종합보험
				String use_day[] = request.getParameterValues("use_day");
				String use_amt[] = request.getParameterValues("use_amt");
				String exp_yn[] = request.getParameterValues("exp_yn");
				cls.setUse_day1	(AddUtil.parseDigit(use_day[0]));
				cls.setUse_day2	(AddUtil.parseDigit(use_day[1]));
				cls.setUse_day3	(AddUtil.parseDigit(use_day[2]));
				cls.setUse_day4	(AddUtil.parseDigit(use_day[3]));
				cls.setUse_day5	(AddUtil.parseDigit(use_day[4]));
				cls.setUse_day6	(AddUtil.parseDigit(use_day[5]));
				cls.setUse_day7	(AddUtil.parseDigit(use_day[6]));
				cls.setUse_amt1	(AddUtil.parseDigit(use_amt[0]));
				cls.setUse_amt2	(AddUtil.parseDigit(use_amt[1]));
				cls.setUse_amt3	(AddUtil.parseDigit(use_amt[2]));
				cls.setUse_amt4	(AddUtil.parseDigit(use_amt[3]));
				cls.setUse_amt5	(AddUtil.parseDigit(use_amt[4]));
				cls.setUse_amt6	(AddUtil.parseDigit(use_amt[5]));
				cls.setUse_amt7	(AddUtil.parseDigit(use_amt[6]));
				if(exp_yn==null){
					cls.setExp_yn1	("N");
				}else{
					cls.setExp_yn1	(exp_yn[0]==null?"N":exp_yn[0]);
					exp_yn1 = exp_yn[0]==null?"N":exp_yn[0];
				}
				cls.setExp_yn2	("N");
				cls.setExp_yn3	("N");
				cls.setExp_yn4	("N");
				cls.setExp_yn5	("N");
				cls.setExp_yn6	("N");
				cls.setExp_yn7	("N");
			}
			cls.setTot_ins_amt	(request.getParameter("tot_ins_amt"	)==null?0 :Util.parseDigit(request.getParameter("tot_ins_amt"	)));
			cls.setTot_use_amt	(request.getParameter("tot_use_amt"	)==null?0 :Util.parseDigit(request.getParameter("tot_use_amt"	)));
			cls.setNopay_amt	(request.getParameter("nopay_amt"	)==null?0 :Util.parseDigit(request.getParameter("nopay_amt"		)));
			cls.setRtn_est_amt	(request.getParameter("rtn_est_amt"	)==null?0 :Util.parseDigit(request.getParameter("rtn_est_amt"	)));
//			cls.setRtn_amt		(request.getParameter("rtn_amt"		)==null?0 :Util.parseDigit(request.getParameter("rtn_amt"		)));
//			cls.setRtn_dt		(request.getParameter("rtn_dt"		)==null?"":request.getParameter("rtn_dt"	)); 
			cls.setDif_amt		(request.getParameter("dif_amt"		)==null?0 :Util.parseDigit(request.getParameter("dif_amt"		)));
			cls.setDif_cau		(request.getParameter("dif_cau"		)==null?"":request.getParameter("dif_cau"	)); 
			cls.setCls_st		(request.getParameter("cls_st"		)==null?"":request.getParameter("cls_st"	)); 
		}
		cls.setUpd_id		(user_id);
		
		if(!ai_db.updateInsCls(cls))	flag += 1;
	
	/*
		ins.setIns_sts("3");	//1:유효 2:만료 3:중도해지
		ins.setIns_exp_dt(request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt"));
		ins.setExp_dt(request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt"));
		ins.setExp_cau(request.getParameter("exp_cau")==null?"":request.getParameter("exp_cau"));
		ins.setRtn_amt(request.getParameter("rtn_amt")==null?0:AddUtil.parseDigit(request.getParameter("rtn_amt")));
		ins.setRtn_dt(request.getParameter("rtn_dt")==null?"":request.getParameter("rtn_dt"));
		ins.setUpdate_id(user_id);
		
		if(!ai_db.updateIns(ins))	flag += 1;
		
		if(cmd.equals("i")){
			//미납보험료 삭제
			if(!ai_db.dropInsScd(c_id, ins_st)) flag += 1;
			
			//보험스케줄
			Vector ins_scd = ai_db.getInsScds(c_id, ins_st);
			int ins_scd_size = ins_scd.size();
			//환급보험 스케줄 생성
			InsurScdBean scd = new InsurScdBean();
			scd.setCar_mng_id(c_id);
			scd.setIns_st(ins_st);
			scd.setIns_tm(Integer.toString(ins_scd_size+1));
			scd.setIns_est_dt(request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt"));
			scd.setR_ins_est_dt(request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt"));
			scd.setPay_amt(request.getParameter("rtn_amt")==null?0:AddUtil.parseDigit("-"+request.getParameter("rtn_amt")));
			scd.setPay_dt(request.getParameter("rtn_dt")==null?"":request.getParameter("rtn_dt"));
			if(scd.getPay_dt().equals(""))		scd.setPay_yn("0");
			else								scd.setPay_yn("1");
			scd.setIns_tm2("2");
			
			if(!ai_db.insertInsScd(scd)) flag += 1;
		}
	*/
	}
	else if(mode.equals("5")){//인적사고 수정
	}
	
%>
<form name='form1' method='post' action='../ins_mng/ins_u_frame.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="ins_st" value='<%=ins_st%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="mode" value=''>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='cha_amt' value='<%=cha_amt%>'>
</form>

<script language='javascript'>
<%	if(flag != 0){%>
		alert('등록되지 않았습니다');
		location='about:blank';
<%	}else{	%>

		alert("수정되었습니다");
		<%if(mode.equals("cls")){%>	
			var fm = document.form1;
			fm.action = "ins_s_frame.jsp";		
			fm.target = "d_content";		
			fm.submit();			
			parent.window.close();			
		<%}else if(mode.equals("pay")){%>	
			var fm = document.form1;
			fm.action = "../ins_mng2/ins_s_frame.jsp";		
			fm.target = "d_content";		
			fm.submit();			
			parent.window.close();						
		<%}else{%>
			<%if(mode.equals("0") || mode.equals("4")){%>
			var fm = document.form1;
			fm.mode.value = <%=mode%>;
			fm.action = "ins_u_frame.jsp";		
			fm.target = "d_content";		
			fm.submit();				
			<%}else{
				if(mode.equals("")) mode="1";%>
			var fm = document.form1;
			fm.action = "ins_u_in<%=mode%>.jsp";		
			fm.target = "c_foot";		
			fm.submit();							
			<%}%>		
		<%}%>				
		
<%	}	%>
</script>
</body>
</html>
