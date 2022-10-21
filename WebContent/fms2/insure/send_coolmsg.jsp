<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.coolmsg.*,acar.car_sche.*,acar.user_mng.*"%>

<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String send_id 		= request.getParameter("send_id")==null? "":request.getParameter("send_id");
	String target_id 		= request.getParameter("target_id")==null? "" :request.getParameter("target_id");
	String cool_car_no 		= request.getParameter("cool_car_no")==null?"":request.getParameter("cool_car_no");
	boolean flag2 = false;
	
	CarSchDatabase csd = CarSchDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String url 	 = request.getParameter("url")==null? "":request.getParameter("url");
	String m_url = "/fms2/insure/ins_doc_frame.jsp";
	
	CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);
		if(!cs_bean2.getWork_id().equals("")) target_id = cs_bean2.getWork_id();
			
		
			String sub 		= "보험변경요청 스캔등록알림";
			String cont 		= "["+cool_car_no+"] 스캔등록이 완료되었습니다 보험변경문서를 결재해주세요.";
			
		UsersBean sender_bean 	= umd.getUsersBean(send_id);
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
 						"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
 						"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			
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
			
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저(보험변경문서결재)"+cool_car_no+"-----------------------"+target_bean.getUser_nm());
		
	
	
%>
<script language='javascript'>
<%if(flag2){%>
	alert('메시지 전송완료');
	window.open("about:blank","_self").close();
<%}else{%>
	alert('메시지 전송오류');
<%}%>

</script>
</body>
</html>