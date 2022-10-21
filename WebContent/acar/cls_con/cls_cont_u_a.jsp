<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String dly_count = request.getParameter("dly_count")==null?"":request.getParameter("dly_count");
	String dly_value = request.getParameter("dly_value")==null?"":request.getParameter("dly_value");
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	//검색구분
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
%>

<html>
<head><title>FMS</title></head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
</form>
<script language='javascript'>
	var fm = document.form1;

	<%if(!as_db.closeCont(m_id, l_cd, cls_st, dly_count, dly_value, "")){%>

		alert('오류발생!');
		location='about:blank';

	<%}else{%>

		alert('처리되었습니다');
//		fm.action='/sian/cls_con/cls_frame_s.jsp';		
		fm.action='../car_rent/con_frame_s.jsp';		
		fm.target='d_content';		
		parent.window.close();		
		fm.submit();			

	<%}		%>
</script>
</body>
</html>
