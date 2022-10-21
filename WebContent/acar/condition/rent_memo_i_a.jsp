<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.end_cont.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.end_cont.End_ContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String tm_st = request.getParameter("tm_st")==null?"":request.getParameter("tm_st");	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	boolean flag = true;
	
	End_ContBean memo = new End_ContBean();
	
	memo.setRent_mng_id(m_id);
	memo.setRent_l_cd(l_cd);	
	memo.setReg_id(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));	// cookie세팅
	memo.setReg_dt(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	memo.setRe_bus_id(request.getParameter("re_bus_id")==null?"":request.getParameter("re_bus_id"));
	memo.setContent(request.getParameter("content")==null?"":request.getParameter("content"));
	
	flag = ec_db.insertEnd_Cont(memo);

%>
<form name='form1' action='/acar/condition/rent_memo_frame_s.jsp' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='tm_st' value='<%=tm_st%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>

</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{%>
		alert('등록되었습니다');
		document.form1.target = 'INS_MEMO';
		document.form1.submit();
<%	}%>
</script>
</body>
</html>
