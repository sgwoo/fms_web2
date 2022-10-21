<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String sender_id 	= request.getParameter("sender_id")  ==null?"":request.getParameter("sender_id");
	String target_id 	= request.getParameter("target_id")  ==null?"":request.getParameter("target_id");
	String coolmsg_sub 	= request.getParameter("coolmsg_sub")  ==null?"":request.getParameter("coolmsg_sub");
	String coolmsg_cont = request.getParameter("coolmsg_cont")  ==null?"":request.getParameter("coolmsg_cont");
	String coolmsg_url 	= request.getParameter("coolmsg_url")  ==null?"":request.getParameter("coolmsg_url");
	String m_url  ="/fms2/doc_settle/doc_settle_n_frame.jsp";
	boolean flag1 = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
	if(!cs_bean.getUser_id().equals("")){
		if(target_id.equals("000092")) target_id = "000093";
		if(target_id.equals("000093")) target_id = "000092";
	}
	
	UsersBean sender_bean 	= umd.getUsersBean(sender_id);
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
				"    <BACKIMG>4</BACKIMG>"+
				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+coolmsg_sub+"</SUB>"+
				"    <CONT>"+coolmsg_cont+"</CONT>"+
				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+coolmsg_url+"&m_url="+m_url+"</URL>";
	
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
	
	flag1 = cm_db.insertCoolMsg(msg);
	
	System.out.println("쿨메신저["+coolmsg_sub+"]-----------------------"+target_bean.getUser_nm());
%>


<%

	%>
<form name='form1' method='post'>
</form>
<script language='javascript'>
	if(!<%=flag1%>) alert('메시지 에러발생!'); 
	else			alert('메시지 등록완료!');	
</script>
</body>
</html>