<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.cooperation.*, acar.coolmsg.*, tax.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int count = 0;
	
	
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
%>


<%
	String sub_id 	= request.getParameter("sub_id")==null?"":request.getParameter("sub_id");
	String title 	= request.getParameter("title")==null?"":request.getParameter("title");
	String content 	= request.getParameter("content")==null?"":request.getParameter("content");
	
	cp_bean.setIn_id	(user_id);
	cp_bean.setTitle	(title);
	cp_bean.setContent	(content);
	cp_bean.setOut_id	("");
	cp_bean.setSub_id	(sub_id);
	
	count = cp_db.insertCooperation(cp_bean);
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	UsersBean target_bean 	= umd.getUsersBean(sub_id);
	
	String sub 		= "계약점검 결과 미제출서류 통보";
	String cont 	= "["+sender_bean.getUser_nm()+"]님이 계약점검 미제출서류와 관련하여 업무협조를 요청하셨습니다. 확인바랍니다.";
	
	String url 		= "/fms2/cooperation/cooperation_frame.jsp";
	String m_url ="/fms2/cooperation/cooperation_frame.jsp";
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
				"<ALERTMSG>"+
				"	<BACKIMG>4</BACKIMG>"+
				"	<MSGTYPE>104</MSGTYPE>"+
				"	<SUB>"+sub+"</SUB>"+
  				"	<CONT>"+cont+"</CONT>"+
				"	<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
				
				//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				//보낸사람
				xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
 				"	<MSGICON>10</MSGICON>"+
 				"   <MSGSAVE>1</MSGSAVE>"+
 				"   <LEAVEDMSG>1</LEAVEDMSG>"+
 				"   <FLDTYPE>1</FLDTYPE>"+
 				"</ALERTMSG>"+
 				"</COOLMSG>";
	
	CdAlertBean msg = new CdAlertBean();
	msg.setFlddata(xml_data);
	msg.setFldtype("1");
	flag6 = cm_db.insertCoolMsg(msg);
	
	%>
<script language='javascript'>
<%		if(count==0){	%>	alert('에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='m_id' 		value='<%=m_id%>'>
  <input type='hidden' name='l_cd' 		value='<%=l_cd%>'>
  <input type='hidden' name='r_st' 		value='<%=r_st%>'>
  <input type='hidden' name='title' 	value='<%=title%>'>  
  <input type='hidden' name='sub_id' 	value='<%=sub_id%>'>    
</form>
<script language='javascript'>
	alert('업무협조 등록하였습니다.');
	parent.window.close();
</script>
</body>
</html>