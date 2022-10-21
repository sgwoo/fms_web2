<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="em_bean" class="acar.res_search.RentMBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String msg_st = request.getParameter("msg_st")==null?"":request.getParameter("msg_st");
	
	String sub = request.getParameter("sub")==null?"":request.getParameter("sub");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	int count = 0;
	
	em_bean.setUser_id(user_id);
	em_bean.setRent_s_cd(s_cd);
	em_bean.setSub(sub);
	em_bean.setNote(note);
	
	count = rs_db.insertRentM(em_bean);
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function NullAction(){
	<%if(count==1){%>
		alert("정상적으로 등록되었습니다.");
		parent.document.form1.sub.value = '';
		parent.document.form1.note.value = '';
		parent.i_in.location.href = 'res_memo_i_in.jsp?msg_st=<%=msg_st%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&user_id=<%=user_id%>';
	<%}else{%>
		alert("에러발생!!");
	<%}%>
	}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">

</body>
</html>
