<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.cls.*,  acar.fee.*, acar.car_office.*, cust.member.*, acar.ext.*, acar.car_register.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*,acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<jsp:useBean id="admin_db" 	scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	//if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cls_st	 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	int    fee_size	 	= request.getParameter("fee_size")==null?0:AddUtil.parseInt(request.getParameter("fee_size"));
	String fee_tm	 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String con_cd3 		= request.getParameter("con_cd3")==null?"":request.getParameter("con_cd3");
	String con_cd4 		= request.getParameter("con_cd4")==null?"":request.getParameter("con_cd4");
	String cng_fee_tm 	= request.getParameter("cng_fee_tm")==null?"":request.getParameter("cng_fee_tm");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	boolean flag10 = true;
	boolean flag11 = true;
	boolean flag12 = true;


	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	
	
	cr_bean = crd.getCarRegBean(car_mng_id);	


	//원계약 해지처리-----------------------------------------------------------------------------------------------
	
	//cls_cont
	ClsBean cls = new ClsBean();
	
	cls.setRent_mng_id	(rent_mng_id);
	cls.setRent_l_cd	(rent_l_cd);
	cls.setTerm_yn		("Y");
	cls.setCls_st		(cls_st);
	cls.setCls_dt		(request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt"));
	cls.setR_mon		(request.getParameter("r_mon")==null?"":request.getParameter("r_mon"));
	cls.setR_day		(request.getParameter("r_day")==null?"":request.getParameter("r_day"));
	cls.setCls_cau		(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));
	cls.setReg_id		(user_id);
	
	cls.setCls_cau		(cls.getCls_cau()+", [대여료이관]"+cng_fee_tm);
	
	flag1 = as_db.insertCls2(cls);

	//승계계약 생성---------------------------------------------------------------------------------------------
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	String old_car_mng_id = base.getCar_mng_id();
	
	String md_con_cd = "";
	
	md_con_cd = rent_l_cd.substring(0,4)+""+con_cd3+""+con_cd4+""+rent_l_cd.substring(7,8);
	

	if(cr_bean.getCar_use().equals("1") && base.getCar_st().equals("3")){
		md_con_cd = rent_l_cd.substring(0,4)+""+con_cd3+""+con_cd4+"R";
		base.setCar_st	("1");		
	}
	if(cr_bean.getCar_use().equals("2") && base.getCar_st().equals("1")){
		md_con_cd = rent_l_cd.substring(0,4)+""+con_cd3+""+con_cd4+"L";
		base.setCar_st	("3");		
	}

	
	base.setRent_l_cd	(md_con_cd);//생성
	base.setCar_mng_id	(car_mng_id);
	base.setUse_yn		("");
	
	if(!car_mng_id.equals("")){
		//계약기본정보
		ContBaseBean old_base = a_db.getContBase(old_rent_mng_id, old_rent_l_cd);
		base.setDlv_dt	(old_base.getDlv_dt());
	}
	
	base = a_db.insertContBaseNew(base);
	
	//=====[cont] update=====
	base.setReg_dt		(AddUtil.getDate(4));
	base.setOthers		("");
	base.setFine_mm		("");
	base.setSanction_id	("");
	base.setSanction	("");
	base.setCall_st		("");
	base.setSanction_type("차종변경등록");
	flag1 = a_db.updateContBaseNew(base);	
	
	
	String new_rent_l_cd = base.getRent_l_cd();


	//관련테이블 생성 [cont_etc,car_mgr,car_pur,car_etc,fee,allot] insert-------------------------------------------------
	
	flag2 = a_db.insertContEtcRows(rent_mng_id, new_rent_l_cd);
	
	
	//기존차량 갖고 있는 보유차 계약의 사용여부를 N으로 수정
	flag3 = a_db.updateUseynDt(old_rent_mng_id, old_rent_l_cd, cls.getCls_dt());
	
	
	//car_etc
	ContCarBean car = a_db.getContCarNew(old_rent_mng_id, old_rent_l_cd);
	car.setRent_mng_id	(rent_mng_id);
	car.setRent_l_cd	(new_rent_l_cd);
	flag3 = a_db.updateContCarNew(car);
	
	//car_pur
	ContPurBean pur = a_db.getContPur(old_rent_mng_id, old_rent_l_cd);
	pur.setRent_mng_id	(rent_mng_id);
	pur.setRent_l_cd	(new_rent_l_cd);
	flag3 = a_db.updateContPur(pur);
	
	//allot
	ContDebtBean debt = ad_db.getContDebtReg(old_rent_mng_id, old_rent_l_cd);
	debt.setRent_mng_id	(rent_mng_id);
	debt.setRent_l_cd	(new_rent_l_cd);
	flag3 = ad_db.updateContDebt(debt);
	
	for(int i=0; i<fee_size; i++){
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
		fee.setRent_mng_id	(rent_mng_id);
		fee.setRent_l_cd	(new_rent_l_cd);
		if(i==0){
			flag3 = a_db.updateContFeeNew(fee);
		}else{
			flag3 = a_db.insertContFee(fee);
			flag3 = a_db.updateContFeeNew(fee);
		}
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(i+1));
		fee_etc.setRent_mng_id	(rent_mng_id);
		fee_etc.setRent_l_cd	(new_rent_l_cd);
		if(i == fee_size-1){
			flag3 = a_db.updateFeeEtcCngCheckInit(rent_mng_id, fee_etc.getRent_l_cd(), fee_etc.getRent_st(), nm_db.getWorkAuthUser("연장/승계담당자"), "차종변경");
		}
		if(i==0){
			flag3 = a_db.updateFeeEtc(fee_etc);
		}else{
			flag3 = a_db.insertFeeEtc(fee_etc);
			flag3 = a_db.updateFeeEtc(fee_etc);
		}
		//fee_rtn
		Vector rtn_vt = af_db.getFeeRtnList(rent_mng_id, rent_l_cd, Integer.toString(i+1));
		int rtn_size = rtn_vt.size();
		for(int j = 0 ; j < rtn_size ; j++){
			Hashtable r_ht = (Hashtable)rtn_vt.elementAt(j);
			FeeRtnBean rtn = af_db.getFeeRtn(rent_mng_id, rent_l_cd, String.valueOf(r_ht.get("RENT_ST")), String.valueOf(r_ht.get("RENT_SEQ")));
			rtn.setRent_mng_id	(rent_mng_id);
			rtn.setRent_l_cd	(new_rent_l_cd);
			flag3 = af_db.insertFeeRtn(rtn);
		}
	}
	

	//scd_ext
	Vector grts 	= ae_db.getGrtScdAll(rent_mng_id, rent_l_cd);
	int grt_size 	= grts.size();
	for(int i = 0 ; i < grt_size ; i++){
		ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
		grt.setRent_mng_id	(rent_mng_id);
		grt.setRent_l_cd	(new_rent_l_cd);
		grt.setRent_seq		("1");
		grt.setExt_id		("0");
		grt.setUpdate_id	(user_id);
		//=====[scd_pre] insert=====
		flag3 = ae_db.insertGrt(grt);
	}
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	cont_etc.setRent_mng_id	(rent_mng_id);
	cont_etc.setRent_l_cd	(new_rent_l_cd);
	cont_etc.setCar_deli_dt	(request.getParameter("car_deli_dt")==null?"":request.getParameter("car_deli_dt"));
	
	// 차량변경등록 시 보험사항의 첨단안전장치 값(Lkas_yn, Ldws_yn, Aeb_yn, Fcw_yn)과 전기차 여부 값(Ev_yn)을 변경하는 차량(변경 차종)으로부터 값을 가져와 다시 설정한다. 2018.03.27
	cont_etc.setLkas_yn(request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn"));
	cont_etc.setLdws_yn(request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn"));
	cont_etc.setAeb_yn(request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn"));
	cont_etc.setFcw_yn(request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn"));
	cont_etc.setEv_yn(request.getParameter("ev_yn")==null?"":request.getParameter("ev_yn"));		// 전기차 여부
	cont_etc.setHook_yn(request.getParameter("hook_yn")==null?"":request.getParameter("hook_yn"));
	cont_etc.setOthers_device(request.getParameter("others_device")	==null?"":request.getParameter("others_device"));
	
	flag3 = a_db.insertContEtc(cont_etc);
	
	//car_mgr
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	for(int i = 0 ; i < mgr_size ; i++){
		CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
		mgr.setRent_mng_id	(rent_mng_id);
		mgr.setRent_l_cd	(new_rent_l_cd);
		flag3 = a_db.updateCarMgrNew(mgr);
	}
	
	//cont_gur
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	for(int i = 0 ; i < gur_size ; i++){
		Hashtable gur_h = (Hashtable)gurs.elementAt(i);
		String gur_id = String.valueOf(gur_h.get("GUR_ID"));
		ContGurBean gur = a_db.getContGur(rent_mng_id, rent_l_cd, gur_id);
		if(!gur.getRent_l_cd().equals("")){
			gur.setRent_mng_id	(rent_mng_id);
			gur.setRent_l_cd	(new_rent_l_cd);
			//=====[CONT_GUR] update=====
			flag3 = a_db.updateContGur(gur);
		}
	}
	
	//cont_eval
	Vector evals = a_db.getContEvalList(rent_mng_id, rent_l_cd, "");
	int eval_size = evals.size();
	for(int i = 0 ; i < eval_size ; i++){
		Hashtable eval_h = (Hashtable)evals.elementAt(i);
		String e_seq = String.valueOf(eval_h.get("E_SEQ"));
		ContEvalBean eval = a_db.getContEval(rent_mng_id, rent_l_cd, e_seq);
		if(!eval.getRent_l_cd().equals("")){
			eval.setRent_mng_id	(rent_mng_id);
			eval.setRent_l_cd	(new_rent_l_cd);
			//=====[CONT_GUR] update=====
			flag3 = a_db.updateContEval(eval);
		}
	}
	

	//원계약 해지처리-----------------------------------------------------------------------------------------------
	
	//cont
	base = a_db.getCont(rent_mng_id, rent_l_cd);
	base.setUse_yn		("N");
	
	//=====[cont] update=====
	flag8 = a_db.updateContBaseNew(base);
	
	//예비용으로 전환
	String new_rent_l_cd2 = as_db.getNextRent_l_cd(rent_l_cd.substring(0, 7)+"S");//신규계약코드
	flag8 = a_db.insertReContEtcRows2(rent_mng_id, rent_l_cd, new_rent_l_cd2, cls.getCls_dt());
	
	//등록차량 상태값 초기화
	flag9 = a_db.updateCarStatCng(base.getCar_mng_id());
	
	//재리스 예약 전부 취소 / 자동차관리의 오프리스구분, 보유차구분, 재리스구분 초기화
	int sr_result = 0;
	sr_result = shDb.shRes_all_cancel(base.getCar_mng_id());
	
	
	
	
	
	//이행보증보험-----------------------------------------------------------------------------------------------
	
	//gua_ins
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, new_rent_l_cd, Integer.toString(fee_size));
	
	
	gins.setGi_no		("[차량변경]"+Integer.toString(fee_size));
	gins.setGi_reason	("");
	gins.setGi_sac_id	("");
	gins.setGi_jijum	(request.getParameter("gi_jijum")==null?"":request.getParameter("gi_jijum"));
	gins.setGi_amt		(request.getParameter("gi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_amt")));
	gins.setGi_fee		(request.getParameter("gi_fee")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_fee")));
	
	
	String gi_st = request.getParameter("gi_st")==null?"":request.getParameter("gi_st");
	
	if(gi_st.equals("1") && gins.getGi_jijum().equals("") && gins.getGi_amt() == 0 && gins.getGi_fee() == 0){
		gi_st = "0";
	}	
		
	//car_etc
	car 	= a_db.getContCarNew(rent_mng_id, new_rent_l_cd);
	car.setGi_st		(gi_st);
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	if(gi_st.equals("1") && ( !gins.getGi_jijum().equals("") || gins.getGi_amt() > 0 )){
				
				//이행보증보험 가입여부 보증보험담당자에게 메시지 통보
						
				UsersBean gins_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("보증보험담당자"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>보증보험가입 차량변경 등록</SUB>"+
		  				"    <CONT>보증보험가입 차량변경 등록 : "+new_rent_l_cd+"</CONT>"+
 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+gins_target_bean.getId()+"</TARGET>";

				xml_data3 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
				CdAlertBean msg3 = new CdAlertBean();
				msg3.setFlddata(xml_data3);
				msg3.setFldtype("1");
			
				flag12 = cm_db.insertCoolMsg(msg3);
			
	}		
		
		if(gins.getRent_mng_id().equals("")){
			//=====[gua_ins] insert=====
			gins.setRent_mng_id	(rent_mng_id);
			gins.setRent_l_cd	(new_rent_l_cd);
			gins.setRent_st		(Integer.toString(fee_size));
			flag2 = a_db.insertGiInsNew(gins);
		}else{
			//=====[gua_ins] update=====
			flag2 = a_db.updateGiInsNew(gins);
		}	
	
		
	//고객별 최종스캔 동기화
	String  d_flag1 =  admin_db.call_sp_lc_rent_scanfile_syn2(cls_st, rent_mng_id, rent_l_cd, new_rent_l_cd, user_id);


	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	CarRegBean cr_bean_old = crd.getCarRegBean(old_car_mng_id);
	
	

	//20160905차종변경 보험담당자에게 메시지 발송
	if(1==1){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			

			String sub 	= "차종변경 등록";
			String cont 	= "[ "+rent_l_cd+" "+cr_bean_old.getCar_no()+" -> "+new_rent_l_cd+" "+cr_bean.getCar_no()+" "+client.getFirm_nm()+" ] 차종변경 등록되었습니다. 보험 확인바랍니다.";
			String target_id = nm_db.getWorkAuthUser("부산보험담당");
			
			//보험변경요청 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, new_rent_l_cd, String.valueOf(fee_size));
			
						
			
			CarSchDatabase csd = CarSchDatabase.getInstance();
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	target_id = cs_bean.getWork_id();
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			//flag12 = cm_db.insertCoolMsg(msg);
			
	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=new_rent_l_cd%>">  
  <input type="hidden" name="c_st" 				value="fee">    
  <input type="hidden" name="now_stat" 			value="차종변경">        
</form>
<script language='javascript'>
	var fm = document.form1;

	
<%		if(!flag1){	%>
		alert('원계약 해지정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag2){	%>
		alert('승계계약 기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag3){	%>
		alert('관련테이블 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag4){	%>
		alert('관계자 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag5){	%>
		alert('대표자보증 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag6){	%>
		alert('연대보증 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag7){	%>
		alert('대여료스케줄 이관 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag8){	%>
		alert('원계약 기본정보 수정 에러입니다.\n\n확인하십시오');
<%		}	%>		

	fm.action = 'lc_b_s.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>