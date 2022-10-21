<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.res_search.*" %>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*"%>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn" class="acar.secondhand.ShResBean" scope="page"/>
<jsp:useBean id="cm_db" class="acar.coolmsg.CoolMsgDatabase" scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int result = 0;
	
	MaMenuDatabase 	nm_db 	= MaMenuDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	CarSchDatabase 	csd 	= CarSchDatabase.getInstance();
	CarRegDatabase 	crd 	= CarRegDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String reg_dt 		= request.getParameter("shres_reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("shres_reg_dt"));
	String seq 		= request.getParameter("shres_seq")==null?"":request.getParameter("shres_seq");	
	
	//취소처리
	String  d_flag1 =  shDb.call_sp_sh_res_dire_cancel(car_mng_id, seq);
	
	
	
	//계약확정-취소일 경우 예약시스템 장기대기로 자동등록 취소 및 보유차담당자에게 메시지 통보
	if(situation.equals("2") && AddUtil.parseInt(reg_dt) >= 20090819){
	
		
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
		boolean flag3 		= true;
		String sub 		= "보유차 처리 통보";
		String cont 		= "[취소]장기대기-"+cr_bean.getCar_no()+", 재리스결정차량현황에서 예약취소됨";
		String target_id 	= nm_db.getWorkAuthUser("보유차관리");
		
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		
		if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")) 	target_id = cs_bean.getWork_id();
		if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")) 	target_id = nm_db.getWorkAuthUser("본사관리팀장");
		
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
		
//		flag3 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저[보유차 처리 통보-재리스결정차량 계약확정 취소] "+cr_bean.getCar_no()+"-----------------------"+target_bean.getUser_nm());
		//System.out.println(xml_data);
		
		
		
		
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
	alert("예약이 취소 되었습니다.");
	parent.location.reload();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>
