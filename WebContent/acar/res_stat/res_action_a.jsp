<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*,acar.memo.*, acar.secondhand.*, acar.estimate_mng.*, tax.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.cont.*, acar.common.*,acar.client.*, acar.car_mst.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String f_page = request.getParameter("f_page")==null?"":request.getParameter("f_page");
	
	boolean flag3 = true;
	boolean flag4 = true;
	int count = 1;
	int count1 = 1;
	int count_cust = 0;
	String cms_reg_msg = "";
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AddCarMstDatabase 	cmb 	= AddCarMstDatabase.getInstance();
	
	//계약정보
	String deli_dt 		= request.getParameter("h_deli_dt")==null?"":AddUtil.replace(request.getParameter("h_deli_dt"),"-","");
	String deli_loc 	= request.getParameter("deli_loc")==null?"":request.getParameter("deli_loc");
	String deli_mng_id 	= request.getParameter("deli_mng_id")==null?"":request.getParameter("deli_mng_id");
	String ret_plan_dt 	= request.getParameter("h_ret_plan_dt")==null?"":request.getParameter("h_ret_plan_dt");
	String cms_est_dt 	= request.getParameter("cms_est_dt")==null?"":request.getParameter("cms_est_dt");
	String h_ret_dt = "";

	//단기대여관리 수정
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
				
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(s_cd, "4");
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	if(mode.equals("Y")){
		rc_bean.setDeli_dt2	(deli_dt);
		rc_bean.setDeli_loc	(deli_loc);
		rc_bean.setDeli_mng_id	(deli_mng_id);
		rc_bean.setReg_id	(user_id);
		rc_bean.setUse_st	("2");
		rc_bean.setRet_plan_dt	(ret_plan_dt);
		
		//월렌트연장스케줄관련
		String scd_reg_yn = request.getParameter("scd_reg_yn")==null?"":request.getParameter("scd_reg_yn");
		String paid_st 	= request.getParameter("paid_st")==null?"1":request.getParameter("paid_st");
		String est_dt 	= request.getParameter("est_dt")==null?"":request.getParameter("est_dt");	
		int    reg_tm 	= request.getParameter("reg_tm")==null?1:AddUtil.parseDigit(request.getParameter("reg_tm"));	//납입횟수
		int rent_amt 	= request.getParameter("rent_amt")==null?0:Util.parseDigit(request.getParameter("rent_amt"));
		int rent_s_amt 	= request.getParameter("rent_s_amt")==null?0:Util.parseDigit(request.getParameter("rent_s_amt"));
		int rent_v_amt 	= request.getParameter("rent_v_amt")==null?0:Util.parseDigit(request.getParameter("rent_v_amt"));
		
		
		
		
		//월렌트연장스케줄 자동이체 관련
		String cms_reg_yn 	= request.getParameter("cms_reg_yn")	==null?"":request.getParameter("cms_reg_yn");
		
		
		
		
		//배차시 재리스 예약자 메시지 발송
		String  d_flag4 =  rs_db.call_sp_res_deli_msg("배차처리", s_cd);
		
	}else{
		rc_bean.setUse_st("5");
		
		//운행스케줄 삭제
		count = rs_db.deleteScdCar(s_cd, c_id, "");
//		System.out.println("일지삭제"+count);

		
		
		
	}
	
	count = rs_db.updateRentCont(rc_bean);
	
	//운행일지 수정
	if(mode.equals("Y")){
//		예약등록시 스케줄 생성으로 여기서는 필요없음.
		String rent_st = rc_bean.getRent_st();
		String rent_start_dt = rc_bean.getRent_start_dt_d();
		String rent_end_dt = rc_bean.getRent_end_dt_d();
		String ret_dt = rent_end_dt;
		String ret_time = "00";
		int use_days = 0;
		
		if(rent_end_dt.equals("")){
			if(rent_st.equals("2") || rent_st.equals("3")){			ret_dt = rs_db.addDay(rc_bean.getDeli_dt_d(), 7); //일주일
			}else if(rent_st.equals("4") || rent_st.equals("5")){	ret_dt = rs_db.addMonth(rc_bean.getDeli_dt_d(), 1); //한달
			}else{													ret_dt = rs_db.addDay(rc_bean.getDeli_dt_d(), 3); //3일
			}
			ret_time = rc_bean.getRent_end_dt_h();
		}
		
		h_ret_dt = ret_dt;
		
		//운행일수
		use_days = AddUtil.parseInt(rs_db.getDay(rc_bean.getDeli_dt_d(), ret_dt));
		
		for(int i=0; i<use_days; i++){
			ScdCarBean sc_bean = new ScdCarBean();
			sc_bean.setCar_mng_id(c_id);
			sc_bean.setRent_s_cd(s_cd);
			sc_bean.setTm(i+1);
			sc_bean.setDt(rs_db.addDay(rc_bean.getDeli_dt_d(), i));
			if(i==0){//대여시작
				sc_bean.setTime(rc_bean.getDeli_dt_h());
				sc_bean.setUse_st("0");
			}else if(i > 0 && i==use_days-1){//대여종료 예정일
				sc_bean.setTime(ret_time);
				sc_bean.setUse_st("2");
			}else{//대여기간
				sc_bean.setTime("");
				sc_bean.setUse_st("1");
			}
			sc_bean.setReg_id(user_id);
			count1 = rs_db.insertScdCar(sc_bean);
//			System.out.println("c_id="+c_id+",s_cd="+s_cd+",dt="+sc_bean.getDt()+",count="+count);
		}
	}
//	System.out.println(mode+" "+f_page+" "+rc_bean.getRent_st());
	
	//메모===========================================================================
	String memo_title 	= "";
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
	String c_cust_nm 	= request.getParameter("c_cust_nm")==null?"":request.getParameter("c_cust_nm");
	String rent_st2		= rc_bean.getRent_st();
	
	if(mode.equals("Y"))			memo_title = "[배차]";
	else 					memo_title = "[취소]";
	
	if(rent_st2.equals("1")) 		memo_title += "단기대여-";
	else if(rent_st2.equals("2")) 		memo_title += "정비대차-";
	else if(rent_st2.equals("3")) 		memo_title += "사고대차-";
	else if(rent_st2.equals("9")) 		memo_title += "보험대차-";
	else if(rent_st2.equals("10")) 		memo_title += "지연대차-";
	else if(rent_st2.equals("4")) 		memo_title += "업무대여-";
	else if(rent_st2.equals("5")) 		memo_title += "업무지원-";
	else if(rent_st2.equals("6")) 		memo_title += "차량정비-";
	else if(rent_st2.equals("7")) 		memo_title += "차량점검-";
	else if(rent_st2.equals("8")) 		memo_title += "사고수리-";
	else if(rent_st2.equals("11")) 		memo_title += "장기대기-";
	
	
	memo_title += car_no+" "+c_firm_nm+" "+c_cust_nm;
	
	
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
		String sub 		= "보유차 처리 통보";
		String cont 	= memo_title;
		String target_id = nm_db.getWorkAuthUser("보유차관리");
		
		
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")) 	target_id = cs_bean.getWork_id();
		if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")) 	target_id = nm_db.getWorkAuthUser("본사관리팀장");
		
		
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
 					"    <URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
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
		
		//flag3 = cm_db.insertCoolMsg(msg);
		//System.out.println("쿨메신저 보유차 ---" + memo_title+ " :: "+sender_bean.getUser_nm());
		//System.out.println(xml_data);
			
		
		//배차처리일때 재리스 계약확정이 있다면 통보한다.
		
		//예약상태
		ShResBean srBn = shDb.getShRes3(c_id);
		
//		if(srBn.getSituation().equals("2")){
//		if(srBn.getSituation().equals("0")){
		if(!srBn.getSituation().equals("")){
			
//			sub 	= "재리스계약확정차량의 보유차 처리 통보";
//			cont 	= memo_title+" -- 재리스계약확정 상태에서 배차되었으니 확인하시기 바랍니다.";
			
			sub 	= "재리스 상담중인 차량의 보유차 처리 통보";
			cont 	= memo_title+" -- 재리스 예약중인 상태에서 배차되었으니 확인하시기 바랍니다.";
			
			UsersBean target_bean2 	= umd.getUsersBean(srBn.getDamdang_id());
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
	  					 "<ALERTMSG>"+
  						 "    <BACKIMG>4</BACKIMG>"+
  						 "    <MSGTYPE>104</MSGTYPE>"+
  						 "    <SUB>"+sub+"</SUB>"+
	  					 "    <CONT>"+cont+"</CONT>"+
 						 "    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						 "    <MSGICON>10</MSGICON>"+
  						 "    <MSGSAVE>1</MSGSAVE>"+
  						 "    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					 "    <FLDTYPE>1</FLDTYPE>"+
  						 "  </ALERTMSG>"+
  						 "</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			//상담종료일보다 반차예정일이 더 큰 경우
			if(AddUtil.parseInt(AddUtil.replace(h_ret_dt,"-","")) > AddUtil.parseInt(srBn.getRes_end_dt())){
				//flag3 = cm_db.insertCoolMsg(msg2);  20201123 call_sp_res_deli_msg 프로시저 대체
//				System.out.println("쿨메신저(재리스계약확정차량의 보유차 배차 처리 통보)-----------------------"+cont);
			}
		}
	
	
	//배차처리일때
	if(rc_bean.getUse_st().equals("2")){
		//군별 담당자가 업무대여 차량을 쓰는 경우 장기대여 보유차 관리담당자를 본인으로
		if(rc_bean.getRent_st().equals("4")){
			Hashtable cont_view = a_db.getContViewUseYCarCase(c_id);
			UsersBean mng_bean 	= umd.getUsersBean(rc_bean.getCust_id());
			
			if(!mng_bean.getLoan_st().equals("") && String.valueOf(cont_view.get("CAR_ST")).equals("2") && !rc_bean.getCust_id().equals(String.valueOf(cont_view.get("MNG_ID")))){
				ContBaseBean base = a_db.getCont(String.valueOf(cont_view.get("RENT_MNG_ID")), String.valueOf(cont_view.get("RENT_L_CD")));
				base.setMng_id(rc_bean.getCust_id());
				boolean flag1 = a_db.updateContBaseNew(base);
//				System.out.println("[업무대여-계약 관리담당자 수정]"+memo_title);
			}
		}
		
	}
	
	
	
			
	
	
	
	
	if(mode.equals("Y")){
		//보험변경요청 프로시저 호출
	  if(rc_bean.getRent_st().equals("2") || rc_bean.getRent_st().equals("3")){
		  /* 예약시 등록되는걸로 변경 (다시취소)*/
		 String  d_flag2 =  ec_db.call_sp_ins_cng_req("대차등록", s_cd, c_id, "");
		}else if(rc_bean.getRent_st().equals("10")){
			
			//고객정보
			ClientBean client = al_db.getNewClient(rc_bean.getCust_id());
				
			//자동차기본정보
			cm_bean = cmb.getCarNmCase(String.valueOf(reserv.get("CAR_ID")), String.valueOf(reserv.get("CAR_SEQ")));	

			//장기계약 연동
			if(!rc_bean.getSub_l_cd().equals("")){
				Hashtable cont_ht = a_db.getContViewCase("", rc_bean.getSub_l_cd());
				
				ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont_ht.get("RENT_MNG_ID")), String.valueOf(cont_ht.get("RENT_L_CD")));
				
				//출고지연대차 법인 임직원전용대상차량 배차
				if(cont_etc.getCom_emp_yn().equals("Y") && rc_bean.getRent_st().equals("10") && !client.getClient_st().equals("2") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("지연대차등록 임직원전용보험", s_cd, c_id, "");
				}else{				
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("대차등록", s_cd, c_id, "");
				}
			//장기계약 미연동
			}else{
				//출고지연대차 법인 임직원전용대상차량 배차
				if(client.getClient_st().equals("1") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("지연대차등록 임직원전용보험", s_cd, c_id, "");
				}else{
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("대차등록", s_cd, c_id, "");
				}
				
				//출고지연대차 법인 임직원전용대상차량 배차2(가입조건을 예약등록에서 한 경우 rent_con에서 직접 저장 )
				if(client.getClient_st().equals("1") && rc_bean.getCom_emp_yn().equals("Y")){
//					System.out.println("//출고지연대차 법인 임직원전용대상차량 배차2(가입조건을 예약등록에서 한 경우 rent_con에서 직접 저장 )");
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("지연대차등록 임직원전용보험", s_cd, c_id, "");
				}else{
					String  d_flag2 =  ec_db.call_sp_ins_cng_req("대차등록", s_cd, c_id, "");
				}
			}
			
		}
	}
	
	//사고대차 배차등록시 고객에게 이메일 발송 (2017.12.19)
	if(mode.equals("Y") && rc_bean.getRent_st().equals("3") && count==1){
		
		if(!rc_bean2.getEmail().equals("")){
			
			EstiDatabase e_db = EstiDatabase.getInstance();
			DmailBean d_bean = new DmailBean();
			Hashtable cont_view = a_db.getContViewUseYCarCase(c_id);
			
			d_bean.setSubject			("[아마존카] 대차료동의서 안내문 및 위임장 입니다.");
			d_bean.setSql				("SSV:"+rc_bean2.getEmail().trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<tax200@amazoncar.co.kr>");
			d_bean.setMailto			("\""+rc_bean2.getFirm_nm()+"\"<"+rc_bean2.getEmail().trim()+">");
			d_bean.setReplyto			("\"아마존카\"<tax200@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<tax200@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				("대차료동의서");
			d_bean.setGubun2			("");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(1);//admin계정
			d_bean.setMsgflag     		(0);
			d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/rent/bond_request.jsp?l_cd="+cont_view.get("RENT_L_CD")+"&m_id="+cont_view.get("RENT_MNG_ID")+"&s_cd="+s_cd+"&c_id="+c_id);
			
			boolean flag;
			flag = e_db.insertDEmail4(d_bean, "", "+7");
		}
	}
	
	if(rc_bean.getRent_st().equals("6") && rc_bean.getEtc().equals("자산양수차 명의이전 등록 및 재리스 정비중")){
		
		//반차처리시 차량의 현위치를 반차위치로 수정
		String park = request.getParameter("park")==null?"":request.getParameter("park");
		String park_cont = request.getParameter("park_cont")==null?"":request.getParameter("park_cont");
	
		int count6 = rs_db.updateCarPark(c_id, park, park_cont);
		
	}
		
%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('정상적으로 처리되었습니다');
		parent.self.close();
		<%if(mode.equals("Y") || (mode.equals("R") && rc_bean.getRent_st().equals("1"))){
			//if(f_page.equals("")){%>
				parent.opener.parent.location='/acar/res_stat/res_st_frame_s.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "02", "05", "01")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
//				parent.opener.parent.location='/acar/rent_mng/rent_mn_frame_s.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "02", "05", "02")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=3&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=';
			<%//}else{%> 
				//parent.opener.location='/acar/res_plan/res_pl_sc.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "03", "11")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
			<%//}%>
		<%}else{
			//if(f_page.equals("")){%>
//				parent.parent.location='/acar/rent_mng/rent_mn_frame_s.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "02", "05", "02")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=3&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=';
				parent.parent.location='/acar/res_stat/res_st_frame_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
			<%//}else{%> 
				//parent.location='/acar/res_plan/res_pl_sc.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "03", "11")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
			<%//}%>
		<%}%>			
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
