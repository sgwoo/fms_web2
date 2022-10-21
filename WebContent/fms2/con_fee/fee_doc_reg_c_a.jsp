<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.doc_settle.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*, acar.car_mst.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String m_id		 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd		 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String ins_st 		= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	InsDatabase ins_db 		= InsDatabase.getInstance();
	CarSchDatabase csd 		= CarSchDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	
	String cng_dt 	= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String cng_etc 	= request.getParameter("cng_etc")	==null?"":request.getParameter("cng_etc");
	int o_fee_amt	= request.getParameter("o_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("o_fee_amt"));
	int n_fee_amt	= request.getParameter("n_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_fee_amt"));
	int d_fee_amt	= request.getParameter("d_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("d_fee_amt"));
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
		
	//차종변수
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");	
	
	//대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	String doc_no 		= "";
	String ch_before 	= "";
	String ch_after 	= "";
	String reg_code  	= Long.toString(System.currentTimeMillis());
	String current_dt = Util.getDate();
	String car_no = base.getCar_no();
	
	//처리상태
	int flag = 0;
	
	
	if(c_id.equals("")){
		c_id = "AAAAAA";
	}
	
	String rent_way_nm[] 				= request.getParameterValues("rent_way_nm");
	
	String u_chk 		= request.getParameter("u_chk")			==null?"":request.getParameter("u_chk");
	String fee_dc 		= request.getParameter("fee_dc")		==null?"":request.getParameter("fee_dc");
	String fee_etc 		= request.getParameter("fee_etc")		==null?"":request.getParameter("fee_etc");
	String fee_add_user = request.getParameter("fee_add_user")	==null?"":request.getParameter("fee_add_user");
	String fee_dis_plus = request.getParameter("fee_dis_plus")	==null?"":request.getParameter("fee_dis_plus");
	String fee_day 		= request.getParameter("fee_day")		==null?"":request.getParameter("fee_day");	
	String fee_sticker 	= request.getParameter("fee_sticker")	==null?"":request.getParameter("fee_sticker");	
	String others_device= request.getParameter("others_device")	==null?"":request.getParameter("others_device");
	String o_grt_amt		= request.getParameter("o_grt_amt")		==null?"":request.getParameter("o_grt_amt");
	String grt_amt		= request.getParameter("grt_amt")		==null?"":request.getParameter("grt_amt");
	String o_agree_dist = request.getParameter("o_agree_dist")	==null?"":request.getParameter("o_agree_dist");
	
	InsurChangeBean d_bean = new InsurChangeBean();
	d_bean.setIns_doc_no		(reg_code);
	d_bean.setCar_mng_id		(c_id);
	d_bean.setIns_st			(rent_st);
	d_bean.setCh_dt				(cng_dt);
	d_bean.setCh_etc			(cng_etc);
	d_bean.setUpdate_id			(user_id);
	d_bean.setRent_mng_id		(rent_mng_id);
	d_bean.setRent_l_cd			(rent_l_cd);
	d_bean.setRent_st			(rent_st);
	d_bean.setO_fee_amt			(o_fee_amt);
	d_bean.setN_fee_amt			(n_fee_amt);
	d_bean.setD_fee_amt			(d_fee_amt);
	d_bean.setDoc_st			("2");
	d_bean.setCh_st				("1");
	d_bean.setO_opt_amt			(request.getParameter("o_opt_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("o_opt_amt")));
	d_bean.setN_opt_amt			(request.getParameter("n_opt_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_opt_amt")));
	d_bean.setO_cls_per			(request.getParameter("o_cls_per")==null? 0:AddUtil.parseFloat(request.getParameter("o_cls_per")));
	d_bean.setN_cls_per			(request.getParameter("n_cls_per")==null? 0:AddUtil.parseFloat(request.getParameter("n_cls_per")));
	d_bean.setO_rtn_run_amt		(request.getParameter("o_rtn_run_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_rtn_run_amt")));
	d_bean.setN_rtn_run_amt		(request.getParameter("n_rtn_run_amt")==null?0:AddUtil.parseDigit(request.getParameter("n_rtn_run_amt")));
	d_bean.setO_over_run_amt	(request.getParameter("o_over_run_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_over_run_amt")));
	d_bean.setN_over_run_amt	(request.getParameter("n_over_run_amt")==null?0:AddUtil.parseDigit(request.getParameter("n_over_run_amt")));
	
	if(!ins_db.insertInsChangeDoc(d_bean)) flag += 1;
	
	InsurChangeBean bean = new InsurChangeBean();
	bean.setIns_doc_no		(reg_code);
	bean.setCar_mng_id		(c_id);
	bean.setIns_st			(rent_st);
	bean.setCh_tm			("0");
	bean.setCh_dt			(cng_dt);
	bean.setCh_amt			(0);
	bean.setUpdate_id		(user_id);
	bean.setRent_mng_id		(rent_mng_id);
	bean.setRent_l_cd		(rent_l_cd);
	
	//대여상품
	if(u_chk.equals("1")){
		ch_before 	= rent_way_nm[0];
		ch_after 	= rent_way_nm[1];
		bean.setCh_item("1");
	//대여료할인
	}else if(u_chk.equals("2")){
		ch_before 	= "";
		ch_after 	= fee_dc;
		bean.setCh_item("2");
	//기타
	}else if(u_chk.equals("3")){
		ch_before 	= "";
		ch_after 	= fee_etc;
		bean.setCh_item("3");
	}else if(u_chk.equals("4")){
		ch_before 	= "";
		ch_after 	= fee_add_user;		
		bean.setCh_item("4");
	}else if(u_chk.equals("5")){
		ch_before 	= o_agree_dist;
		ch_after 	= fee_dis_plus;
		bean.setCh_item("5");
	}else if(u_chk.equals("6")){	//대여료입금예정일(20180718)
		ch_before 	= "";
		ch_after 	= fee_day;
		bean.setCh_item("6");
	}else if(u_chk.equals("7")){	//맑은서울스티커(20180507)
		ch_before 	= "";
		ch_after 	= fee_sticker;
		bean.setCh_item("7");
	}else if(u_chk.equals("8")){	//견인장치장착
		ch_before 	= "";
		ch_after 	= others_device;
		bean.setCh_item("8");
	}else if(u_chk.equals("9")){	//보증금증감
		ch_before 	= o_grt_amt;
		ch_after 	= grt_amt;
		bean.setCh_item("9");
	}
	
	bean.setCh_before		(ch_before.trim());
	bean.setCh_after		(ch_after.trim());
	
	if(!ins_db.insertInsChangeDocList(bean)) flag += 1;
	
	//보험변경리스트
	Vector ins_cha = ins_db.getInsChangeDocList(reg_code);
	int ins_cha_size = ins_cha.size();
	
	if(ins_cha_size >0){
	
		int flag1 = 0;
		int flag2 = 0;
		int flag3 = 0;
		int flag4 = 0;
		boolean flag6 = true;
		boolean flag7 = true;
		int count1 = 0;
		int count2 = 0;
		int count3 = 0;		
		
		//기안자
		UsersBean sender_bean 	= umd.getUsersBean(user_id);		
		
		//문서기안
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		
		String sub 	= "대여료변경요청문서 품의";
		String cont 	= "["+firm_nm+"] 대여료변경문서를 등록하였으니 결재바랍니다.";
		
		String user_id2 = nm_db.getWorkAuthUser("본사영업부팀장");
		String user_id3 = nm_db.getWorkAuthUser("세금계산서담당자"); //20151116 스케줄담당자 추가
		String sidogi_id = nm_db.getWorkAuthUser("차량등록자"); 
		String sticker_id = nm_db.getWorkAuthUser("저공해스티커담당"); 
		
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);
		CarScheBean cs_bean3 = csd.getCarScheTodayBean(user_id3);
		
		if(!cs_bean2.getWork_id().equals("")) user_id2 = cs_bean2.getWork_id();
		if(!cs_bean3.getWork_id().equals("")) user_id3 = cs_bean3.getWork_id();
		
		
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st	("48");
		doc.setDoc_id	(reg_code);
		doc.setSub		(sub);
		doc.setCont		(cont);
		doc.setEtc		(cng_etc);
		doc.setUser_nm1	("기안자");
		doc.setUser_nm2	("영업팀장");
		doc.setUser_nm3	("세금계산서담당자");
		doc.setUser_nm4	("");
		doc.setUser_nm5	("");
		doc.setUser_id1	(user_id);
		doc.setUser_id2	(user_id2);
		doc.setUser_id3	(user_id3);
		doc.setDoc_bit	("0");
		doc.setDoc_step	("0");//기안
		
		String target_id = doc.getUser_id2();
		
		if(u_chk.equals("7")){	
			doc.setUser_nm4	("시도지변경담당자");
			doc.setUser_id4	(sidogi_id);
			doc.setUser_nm5	("맑은서울스티커담당자");
			doc.setUser_id5	(sticker_id);
		}
		
		//=====[doc_settle] insert=====
		flag6 = d_db.insertDocSettle2(doc);
		
		doc = d_db.getDocSettleCommi("48", reg_code);
		
		doc_no = doc.getDoc_no();
		
	
		/* 대여료입금예정일 변경은 바로 세금계산서 담당자에게 전달  */
		if(u_chk.equals("6")){	
			//대여료입금예정일변경 건이면 기안자, 영업팀장님 결제는 생략.(20180719)

			d_bean.setIns_doc_st("Y");
			
			flag6=  ins_db.updateInsChangeDoc(d_bean);
			flag6 = d_db.updateDocSettle(doc_no, user_id, "1", "1");	
			flag6 = d_db.updateDocSettle(doc_no, "XXXXXX", "2", "2");	
			
			sub 		= "대여료변경에 따른 대여료스케줄 변경요청";
			cont 		= "[ "+car_no+" "+rent_l_cd+" "+firm_nm+" ]  &lt;br&gt; &lt;br&gt; 대여료입금예정일이 변경되어 대여료스케줄 변경을 요청합니다.  &lt;br&gt; &lt;br&gt; 월대여료 "
						+	Util.parseDecimal(d_bean.getO_fee_amt())+"원에서 "
						+	Util.parseDecimal(d_bean.getN_fee_amt())+"원으로 변경  &lt;br&gt; &lt;br&gt; (월반영금액 "
						+	Util.parseDecimal(d_bean.getD_fee_amt())+"원)";
			
			target_id 	= nm_db.getWorkAuthUser("세금계산서담당자");
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
			
		}
		
		//추가운전자
		if(u_chk.equals("4")){
			Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
    		int mgr_size = car_mgrs.size();
			CarMgrBean mgr5 = a_db.getCarMgr(rent_mng_id, rent_l_cd, "추가운전자");
			if(mgr5.getRent_mng_id().equals("")){
				mgr5.setRent_mng_id	(rent_mng_id);
				mgr5.setRent_l_cd	(rent_l_cd);
				mgr5.setMgr_id		(String.valueOf(mgr_size));
				mgr5.setMgr_st		("추가운전자");
				mgr5.setMgr_nm		(request.getParameter("mgr_lic_emp5")	==null?"":request.getParameter("mgr_lic_emp5"));
				mgr5.setLic_no		(request.getParameter("mgr_lic_no5")	==null?"":request.getParameter("mgr_lic_no5"));
				mgr5.setEtc			(request.getParameter("mgr_lic_rel5")	==null?"":request.getParameter("mgr_lic_rel5"));
				mgr5.setLic_result	(request.getParameter("mgr_lic_result5")	==null?"":request.getParameter("mgr_lic_result5"));
				if(!mgr5.getMgr_nm().equals("") || !mgr5.getLic_no().equals("")){
					//=====[CAR_MGR] insert=====
					flag6 = a_db.insertCarMgr(mgr5);
				}
			}			
			if(fee_add_user.equals("운전자 추가 취소") && !mgr5.getRent_mng_id().equals("")){
				mgr5.setMgr_nm		("");
				mgr5.setLic_no		("");
				mgr5.setEtc			("");
				mgr5.setLic_result	("");
				//=====[CAR_MGR] update=====
				flag6 = a_db.updateCarMgrNew(mgr5);
			}
		}
		
		
		//쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/con_fee/fee_doc_frame.jsp";
		
		String msg_send_yn = "";
		//대여료변경문서 - 신차 약정운행거리 변경 권용식차장 메시지발송
		if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")) && u_chk.equals("5")){
			sub 		= "대여료변경문서 신차 약정운행거리 변경";
			cont 		= "[ "+car_no+" "+rent_l_cd+" "+firm_nm+" ]  &lt;br&gt; &lt;br&gt; 대여료변경문서 신차 전기/수소차 약정운행거리 변경 등록되었습니다.  &lt;br&gt; &lt;br&gt; 약정주행거리 "
						+	ch_before+"km에서 "
						+	ch_after+"km으로 변경  &lt;br&gt; &lt;br&gt; (월반영금액 "
						+	Util.parseDecimal(d_bean.getD_fee_amt())+"원)";
			
			target_id 	= nm_db.getWorkAuthUser("엑셀견적관리자");
			
			msg_send_yn = "Y";
		}		
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
		//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		//보낸사람
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
		
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		if(u_chk.equals("6") || msg_send_yn.equals("Y")){
			flag7 = cm_db.insertCoolMsg(msg);
		}
		
		
		
	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 			value="<%=rent_st%>">   
  <input type='hidden' name="c_id" 				value="<%=c_id%>">
  <input type='hidden' name="ins_st"			value="<%=ins_st%>">
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">       
</form>
<script language='javascript'>
<%	if(flag > 0){%>
		alert("등록하지 않았습니다.");
<%	}else{		%>		
		alert("등록되었습니다.");
		var fm = document.form1;
		fm.target='d_content';
		fm.action='fee_doc_frame.jsp';
		fm.submit();
		window.close();
<%	}			%>
</script>
</body>
</html>