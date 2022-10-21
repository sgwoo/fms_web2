<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.car_office.*, acar.coolmsg.*, acar.car_sche.*, acar.consignment.*, acar.client.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>


<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");


	String cons_no 		= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");		
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String cng_size 	= request.getParameter("cng_size")==null?"":request.getParameter("cng_size");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	int result = 0;
	
	String msg_yn = "N"; 
	String target1_yn = "N"; 
	String target2_yn = "N"; 
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	
	String sub 	= "";
	String cont 	= "";
	
	UsersBean target_bean 	= umd.getUsersBean(base.getBus_id());
	UsersBean target_bean2 	=  new UsersBean();
	
	String target_id2 = "";
			
	if(pur.getOff_id().equals("007751")){
		target_id2 = "000187";					
		target_bean2 	= umd.getUsersBean(target_id2);
	}
	if(pur.getOff_id().equals("009026")){
		target_id2 = "000222";					
		target_bean2 	= umd.getUsersBean(target_id2);
	}
	if(pur.getOff_id().equals("011372")){
		target_id2 = "000308";					
		target_bean2 	= umd.getUsersBean(target_id2);
	}
	if(pur.getOff_id().equals("009771")){
		target_id2 = "000240";					
		target_bean2 	= umd.getUsersBean(target_id2);
	}
			
	//탁송의뢰
	ConsignmentBean cons = cs_db.getConsignmentPur(cons_no);
	


%>


<%
	//변경
	if(cng_item.equals("cng")){
	
		ConsignmentBean cng_bean = new ConsignmentBean();
		
		int next_seq = cs_db.getConsPurCngNextSeq(cons_no);
		
		cng_bean.setCons_no		(cons_no);
		cng_bean.setSeq			(next_seq);
		
		
		String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
		
		if(cng_st.equals("1")){
		
			pur.setUdt_st		(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
				
			cons.setUdt_firm		(request.getParameter("udt_firm")	==null?"":request.getParameter("udt_firm"));	
			cons.setUdt_addr		(request.getParameter("udt_addr")	==null?"":request.getParameter("udt_addr"));		
			cons.setUdt_mng_id		(request.getParameter("udt_mng_id")	==null?"":request.getParameter("udt_mng_id"));	
			cons.setUdt_mng_nm		(request.getParameter("udt_mng_nm")	==null?"":request.getParameter("udt_mng_nm"));	
			cons.setUdt_mng_tel		(request.getParameter("udt_mng_tel")	==null?"":request.getParameter("udt_mng_tel"));	
			
			msg_yn = "Y";
			target1_yn = "N"; 
			target2_yn = "Y"; 
			
			if(target_id2.equals("")) target2_yn = "N";
			
			sub 	= "배달탁송변경";
			cont 	= "[ "+pur.getRpt_no()+" ] 배달탁송관리에서 배달지가 변경되었습니다.  "+cons.getUdt_addr()+" ";
								
		}else if(cng_st.equals("2")){
			cons.setDlv_dt		(request.getParameter("dlv_dt")	==null?"":request.getParameter("dlv_dt"));	
		}else if(cng_st.equals("3")){
			cons.setDlv_dt		("");	
		}else if(cng_st.equals("4")){
			cons.setEtc		(request.getParameter("etc")	==null?"":request.getParameter("etc"));	
			
			msg_yn = "Y";
			target1_yn = "N"; 
			target2_yn = "Y"; 
			
			if(target_id2.equals("")) target2_yn = "N";
			
			sub 	= "배달탁송변경";
			cont 	= "[ "+pur.getRpt_no()+" ] 배달탁송관리에서 업무연락내용이 변경되었습니다.  "+cons.getEtc()+" ";			
		}
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPur(cons);
			
			
		cng_bean.setCng_st		(cng_st);			
		cng_bean.setReg_id		(user_id);
					
		//=====[CONS_PUR_CNT] insert=====				
		flag1 = cs_db.insertConsignmentPurCng(cng_bean);	
		
	
	}
	
	//인수
	if(cng_item.equals("udt")){
		cons.setUdt_yn		(request.getParameter("udt_yn")	==null?"":request.getParameter("udt_yn"));	
		cons.setUdt_dt		(request.getParameter("udt_dt")	==null?"":request.getParameter("udt_dt"));		
		cons.setUdt_id		(user_id);
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPurUdt(cons);
	}
	
	//인수일자
	if(cng_item.equals("udt_dt")){
		cons.setUdt_dt		(request.getParameter("udt_dt")	==null?"":request.getParameter("udt_dt"));		
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPurUdtdt(cons);
	}	
	
	

	//취소
	if(cng_item.equals("cancel")){
		cons.setCancel_id	(user_id);	
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPurCancel(cons);	
		
		
		msg_yn = "Y";
		target1_yn = "N"; 
		target2_yn = "Y"; 
		
		if(target_id2.equals("")) target2_yn = "N";
			
		sub 	= "배달탁송취소";
		cont 	= "[ "+pur.getRpt_no()+" ] 배달탁송이 취소되었습니다. ";
		
	}
	
	//반품탁송
	if(cng_item.equals("return_car")){
		
		cons.setReturn_dt		(request.getParameter("return_dt")	==null?"":request.getParameter("return_dt"));
		cons.setReturn_id		(user_id);	
		cons.setReturn_amt		(request.getParameter("return_amt")==null? 0:AddUtil.parseDigit(request.getParameter("return_amt")));
		cons.setRt_com_con_no	(pur.getRpt_no());
			
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPurReturn(cons);	
			
		msg_yn = "N";
		target1_yn = "N"; 
		target2_yn = "N"; 
			
	}	
	
	//의뢰로
	if(cng_item.equals("init")){
		cons.setDriver_nm			("");
		cons.setDriver_m_tel	("");
		cons.setDriver_ssn		("");
		cons.setDriver_nm2		("");
		cons.setDriver_m_tel2	("");
		
		cons.setTo_est_dt			("");
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPur(cons);	
	}	
		
	//출고
	if(cng_item.equals("dlv")){
		cons.setDlv_dt		(request.getParameter("dlv_dt")	==null?"":request.getParameter("dlv_dt"));	
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPur(cons);
	}
		
	//출고일 수정
	if(cng_item.equals("dlv_dt")){
		cons.setDlv_dt		(request.getParameter("dlv_dt")	==null?"":request.getParameter("dlv_dt"));	
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPurDlvdt(cons);
	}
	
	//출고대리인 등록	
	if(cng_item.equals("driver")){
		cons.setDriver_nm	(request.getParameter("driver_nm")	==null?"":request.getParameter("driver_nm"));	
		cons.setDriver_m_tel	(request.getParameter("driver_m_tel")	==null?"":request.getParameter("driver_m_tel"));		
		cons.setDriver_ssn	(request.getParameter("driver_ssn")	==null?"":request.getParameter("driver_ssn"));		
		
		String to_est_dt 	= request.getParameter("to_est_dt")==null?"":request.getParameter("to_est_dt");
		String to_est_h 	= request.getParameter("to_est_h")==null?"":request.getParameter("to_est_h");
		String to_est_s 	= request.getParameter("to_est_s")==null?"":request.getParameter("to_est_s");

		//cons.setTo_est_dt    	(to_est_dt+to_est_h+to_est_s);
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPur(cons);
		
	}	
	
	//배달지도착예정지 변경
	if(cng_item.equals("to_est_dt")){
		
		cons.setDriver_nm2	(request.getParameter("driver_nm2")	==null?"":request.getParameter("driver_nm2"));	
		cons.setDriver_m_tel2	(request.getParameter("driver_m_tel2")	==null?"":request.getParameter("driver_m_tel2"));		
		
		String to_est_dt 	= request.getParameter("to_est_dt")==null?"":request.getParameter("to_est_dt");
		String to_est_h 	= request.getParameter("to_est_h")==null?"":request.getParameter("to_est_h");
		String to_est_s 	= request.getParameter("to_est_s")==null?"":request.getParameter("to_est_s");

		cons.setTo_est_dt    	(to_est_dt+to_est_h+to_est_s);
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPur(cons);
		
		String sms_send_yn 	= request.getParameter("sms_send_yn")==null?"":request.getParameter("sms_send_yn");		
		
		
		sms_send_yn = "Y";
		
		if(sms_send_yn.equals("Y")){
		
			UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
			
			String destphone = "";
			String destname = "";			
			String callbackNum = "";	
			String msg = "";
			String msg_type = "5";
			String msg_subject = "0";
			String sms_yn = "";
			int msg_len = 0;

			//계약담당자에게 문자발송
			destphone 	= target_bean.getUser_m_tel();
			destname 	= target_bean.getUser_nm();
			
			//에이전트 실의뢰자한테 요청
			if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
				destname 	= a_coe_bean.getEmp_nm();
				destphone = a_coe_bean.getEmp_m_tel();
			}
						
			msg 		= pur.getRpt_no() + " 차량이 " + to_est_dt + " " + to_est_h + ":" + to_est_s + "경 도착예정입니다. 탁송기사 " + cons.getDriver_nm2()+ " " + cons.getDriver_m_tel2()+" (주)아마존카 www.amazoncar.co.kr";
			if(cons.getDriver_m_tel2().equals("")){
				msg 		= pur.getRpt_no() + " 차량이 " + to_est_dt + " " + to_est_h + ":" + to_est_s + "경 도착예정입니다. 탁송기사 " + cons.getDriver_nm()+ " " + cons.getDriver_m_tel()+" (주)아마존카 www.amazoncar.co.kr";
			}
			msg_subject = "출고대리인 알림";

			String car_num = pur.getRpt_no();						// 차량 번호
			String car_num2 = pur.getRpt_no() + " " + client.getFirm_nm();		// 차량 번호 + 상호명
			String deliver_date = to_est_dt;						// 탁송 날짜 (월/일)
			String deliver_hour = to_est_h;							// 탁송 날짜 (시간)
			String deliver_min = to_est_s;							// 탁송 날짜 (분)
			String deliver_name = cons.getDriver_nm2();				// 탁송 기사 이름
			String deliver_phone = cons.getDriver_m_tel2();			// 탁송 기사 전화
			if (cons.getDriver_m_tel2().equals("")) {
			    deliver_name = cons.getDriver_nm();
			    deliver_phone = cons.getDriver_m_tel();
			}
			callbackNum = user_bean.getUser_m_tel();
			
			if(destphone.equals("") || destphone.equals("-") || destphone.equals("--")){
				sms_yn = "N";
			}else{
				
				// jjlim add alimtalk
				// acar53 탁송기사 알림
				List<String> fieldList = Arrays.asList(car_num2, deliver_date, deliver_hour, deliver_min, deliver_name, deliver_phone);
				at_db.sendMessageReserve("acar0053", fieldList, destphone, "02-392-4243", null,  rent_l_cd, ck_acar_id );
			}
						
			//출고대리인에게 문자발송
			destphone 	= cons.getDriver_m_tel2();
			destname 	= cons.getDriver_nm2();			
			
			if(cons.getDriver_m_tel2().equals("")){
				destphone 	= cons.getDriver_m_tel();
				destname 	= cons.getDriver_nm();			
			}
			
			String manager_name = target_bean.getUser_nm();
			String manager_phone = target_bean.getUser_m_tel();
			
			msg 		= "아마존카 " + pur.getRpt_no() + " 영업담당자 " + target_bean.getUser_nm() + " " + target_bean.getUser_m_tel();
			msg_subject = "출고배정 알림";
		
			if(destphone.equals("") || destphone.equals("-") || destphone.equals("--")){
				sms_yn = "N";
			}else{
				
			  //친구톡 	
				List<String> fieldList = Arrays.asList(car_num, manager_name, manager_phone);
				at_db.sendMessageReserve("acar0067", fieldList, destphone, "02-392-4243", null,  rent_l_cd, ck_acar_id );
			}
			
		}
		
	}		
	
	
	//출고대리인 문자발송
	if(cng_item.equals("driver_sms")){
	
		UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
		
		String destname 	= request.getParameter("destname")==null?"":request.getParameter("destname");
		String destphone 	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
		String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
	
		String msg_type = "0";
		String msg_subject = "0";
		String sms_yn = "";
		
		String callbackNum = "";	
				
		int msg_len = AddUtil.lengthb(msg);
		
		if(msg_len>80){
			msg_type = "5";
			msg_subject = "출고대리인 알림";
		}
		
		if(destphone.equals("") || destphone.equals("-") || destphone.equals("--")){
			sms_yn = "N";
		}else{
		
	   //친구톡 	
			callbackNum = user_bean.getUser_m_tel();
			at_db.sendMessage(1009, "0", msg, destphone, "02-392-4243", null,  rent_l_cd, ck_acar_id );
	
		}
	
	
	}		
	
	
	//확정
	if(cng_item.equals("settle")){
	
		cons.setSettle_id	(user_id);	
		
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPurSettle(cons);	
		
		
		msg_yn = "Y";
		target1_yn = "N"; 
		target2_yn = "Y"; 
		
		if(target_id2.equals("")) target2_yn = "N";
			
		sub 	= "배달탁송확정";
		cont 	= "[ "+pur.getRpt_no()+" ] 배달탁송 확정합니다. 출고대리인 배정하십시오. ";
		
	}
	
		
	if(msg_yn.equals("Y")){
	
		if(target1_yn.equals("Y") || target2_yn.equals("Y")){
		
			//쿨메신저 메세지 전송------------------------------------------------------------------------------------------
				
			String url 	= "/fms2/cons_pur/cons_pur_c.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|cons_no="+cons_no;
			String m_url ="/fms2/cons_pur/consp_doc_frame.jsp";
						
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	 
 					
	 		if(target1_yn.equals("Y")){	
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			}
		
			if(target2_yn.equals("Y")){
				xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			}
		
			xml_data += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			flag2 = cm_db.insertCoolMsg(msg);		
		}
	}


%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('배달탁송 처리 에러입니다.\n\n확인하십시오');		<%}%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page'	   value='<%=from_page%>'>   
  <input type='hidden' name='rent_mng_id'  value='<%=rent_mng_id%>'>  
  <input type='hidden' name='rent_l_cd'	   value='<%=rent_l_cd%>'> 
  <input type='hidden' name="cons_no"   value="<%=cons_no%>">  
</form>
<script language='javascript'>
	<%if(flag1){%>
	alert('처리되었습니다.');
	<%}%>
	
	<%if(cng_item.equals("driver_sms")){%>
	<%}else{%>
	parent.self.close();
	<%}%>
	var fm = document.form1;	
	fm.action = 'cons_pur_c.jsp';
	fm.target = 'd_content';
	fm.submit();
	
</script>
</body>
</html>