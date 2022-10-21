<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.attend.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.attend.AttendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int seq = request.getParameter("seq")==null?0:Util.parseDigit(request.getParameter("seq"));
	String hday = request.getParameter("hday")==null?"":request.getParameter("hday");
	String hday_nm = request.getParameter("hday_nm")==null?"":request.getParameter("hday_nm");
	int count = 0;
	
	if(cmd.equals("등록")){		//등록
		if(!t_db.insertHoliday(seq, hday, hday_nm))	count += 1;
	}else if(cmd.equals("수정")){	//수정
		if(!t_db.updateHoliday(seq, hday, hday_nm))	count += 1;
	}else{
		if(!t_db.deleteHoliday(seq, hday, hday_nm))	count += 1;
	}
%>
<script language='javascript'>
<%	if(count != 0){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{%>
		alert('<%=cmd%>되었습니다');
		parent.parent.location='/acar/attend/holiday_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>';
<%	}%>
</script>
</body>
</html>
