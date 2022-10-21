<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.add_mark.*" %>
<jsp:useBean id="am_db" scope="page" class="acar.add_mark.AddMarkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_start_dt = request.getParameter("s_start_dt")==null?"":request.getParameter("s_start_dt");	
	String s_gubun = request.getParameter("s_gubun")==null?"":request.getParameter("s_gubun");
	String s_mng_who = request.getParameter("s_mng_who")==null?"":request.getParameter("s_mng_who");	
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	if(cmd.equals("i")){//등록
		AddMarkBean bean = new AddMarkBean();		
		//bean.setSeq(seq);
		bean.setBr_id(request.getParameter("r_br_id")==null?"":request.getParameter("r_br_id"));
		bean.setDept_id(request.getParameter("r_dept_id")==null?"":request.getParameter("r_dept_id"));
		bean.setMng_st(request.getParameter("r_mng_st")==null?"":request.getParameter("r_mng_st"));
		bean.setMng_way(request.getParameter("r_mng_way")==null?"":request.getParameter("r_mng_way"));
		bean.setMarks(request.getParameter("r_marks")==null?"":request.getParameter("r_marks"));
		bean.setStart_dt(request.getParameter("r_start_dt")==null?"":request.getParameter("r_start_dt"));
		bean.setEnd_dt(request.getParameter("r_end_dt")==null?"":request.getParameter("r_end_dt"));
		bean.setReg_id(user_id);
		bean.setGubun(request.getParameter("r_gubun")==null?"":request.getParameter("r_gubun"));
		bean.setMng_who(request.getParameter("r_mng_who")==null?"":request.getParameter("r_mng_who"));
		if(!am_db.insertAddMarks(bean)) count = 1;

	}else{ //수정
		AddMarkBean bean = new AddMarkBean();
		bean.setSeq(request.getParameter("seq")==null?"":request.getParameter("seq"));
		bean.setMarks(request.getParameter("marks")==null?"":request.getParameter("marks"));
		bean.setEnd_dt(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));
		if(!am_db.updateAddMarks(bean)) count = 1;
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<%if(cmd.equals("i")){%>
<form name='form1' action='add_mark_s_sc.jsp' method="POST" target='c_foot'>
<%}else{%>
<form name='form1' action='add_mark_s_sc_in.jsp' method="POST" target='i_view'>
<%}%>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_br_id" value="<%=s_br_id%>">
<input type="hidden" name="s_dept_id_id" value="<%=s_dept_id%>">
<input type="hidden" name="s_start_dt" value="<%=s_start_dt%>">
<input type="hidden" name="s_gubun" value="<%=s_gubun%>">
<input type="hidden" name="s_mng_who" value="<%=s_mng_who%>">
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==0){
		if(cmd.equals("u")){%>
			alert("정상적으로 수정되었습니다.");
			fm.submit();
<%		}else{%>
			alert("정상적으로 등록되었습니다.");
			fm.submit();
<%		}
	}else{%>
			alert("오류발생!");
<%	}%>
//-->
</script>
</body>
</html>
