<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.res_search.*" %>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*"%>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn"  class="acar.secondhand.ShResBean" scope="page"/>
<jsp:useBean id="rs_db" class="acar.res_search.ResSearchDatabase" scope="page"/>
<jsp:useBean id="cm_db" class="acar.coolmsg.CoolMsgDatabase" scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String reg_dt 		= request.getParameter("shres_reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("shres_reg_dt"));
	String seq 		= request.getParameter("shres_seq")==null?"":request.getParameter("shres_seq");	
	
	int result = 0;
	boolean flag5 = true;
	
	result = shDb.shRes_2cng(car_mng_id, seq);
	
	//연장처리
	String  d_flag1 =  shDb.call_sp_sh_res_dire_dtset("i", car_mng_id, seq, AddUtil.getDate());
	
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	CarRegDatabase 	crd 	= CarRegDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(damdang_id);
	
	UsersBean target_bean 	= new UsersBean();
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	if(damdang_id.equals("")) damdang_id = user_id;
	
	//계약확정일 경우 예약시스템 장기대기로 자동등록 및 보유차담당자에게 메시지 통보
	//단기대여관리 등록
	RentContBean rc_bean = new RentContBean();
	rc_bean.setCar_mng_id		(car_mng_id);
	rc_bean.setRent_st		("11");
	rc_bean.setRent_dt		(reg_dt);
	rc_bean.setBrch_id		(sender_bean.getBr_id());
	rc_bean.setBus_id		(damdang_id);
	rc_bean.setRent_start_dt	(reg_dt+"0000");
	rc_bean.setEtc			("재리스결정차량 계약확정 자동예약");
	rc_bean.setDeli_plan_dt		(reg_dt+"0000");
	rc_bean.setUse_st		("1");
	rc_bean.setReg_id		(damdang_id);
	rc_bean = rs_db.insertRentCont(rc_bean);
		
				
	//다음대기자들에게 계약확정 통보
	Vector sr = shDb.getShResList(car_mng_id);
	int sr_size = sr.size();
	
	for (int i = 0 ; i < sr_size ; i++) {
		Hashtable sr_ht = (Hashtable)sr.elementAt(i);
		if (String.valueOf(sr_ht.get("SITUATION")).equals("0") && !String.valueOf(sr_ht.get("SEQ")).equals(seq)) {
						
			String customer_nm = String.valueOf(sr_ht.get("CUST_NM"));
			if (customer_nm.equals("")) {
				customer_nm = "없음";
			}
			
			String customer_num = String.valueOf(sr_ht.get("CUST_TEL"));
			if (customer_num.equals("")) {
				customer_num = "없음";
			}
			
			String customer_memo = String.valueOf(sr_ht.get("MEMO"));			
			if (customer_memo.equals("")) {
				customer_memo = "없음";
			}
			
			//사용자 정보 조회
			target_bean 	= umd.getUsersBean(String.valueOf(sr_ht.get("DAMDANG_ID")));
		
			String xml_data1 = "";
			xml_data1 =  "<COOLMSG>"+
	  					"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>재리스 1순위 상담자 계약확정처리</SUB>"+
		  					"<CONT>"+
							"재리스 1순위 상담자가 계약확정처리하였습니다.  &lt;br&gt; &lt;br&gt; 차량번호 : "+cr_bean.getCar_no()+
							"  &lt;br&gt; &lt;br&gt; 상호 : "+customer_nm+
							"  &lt;br&gt; &lt;br&gt; 연락처 : "+customer_num+
							"  &lt;br&gt; &lt;br&gt; 메모 : "+customer_memo+
		  					"</CONT>"+
 						"    <URL></URL>";
			xml_data1 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data1 += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
	  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			

			
			CdAlertBean msg1 = new CdAlertBean();
			msg1.setFlddata(xml_data1);
			msg1.setFldtype("1");
			
			//에이젼트이면 문자발송
			if (target_bean.getDept_id().equals("1000")) {	
				String sendphone 	= sender_bean.getUser_m_tel();
				String sendname 	= sender_bean.getUser_nm();
				String destphone 	= target_bean.getUser_m_tel();
				String destname 	= target_bean.getUser_nm();
				String msg_cont		= "1순위 상담자가 계약확정처리하였습니다. : "+cr_bean.getCar_no()+"-아마존카-";
				IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", msg_cont);
			} else {
				flag5 = cm_db.insertCoolMsg(msg1);	
			}
		} 
	}
	
		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--

<%if(d_flag1.equals("0")){%>
	alert("등록되었습니다.");
	parent.location.reload();
<%	}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%	}%>
//-->
</script>
</body>
</html>
