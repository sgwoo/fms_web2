<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.add_mark.*, acar.common.*" %>
<jsp:useBean id="am_db" scope="page" class="acar.add_mark.AddMarkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String c_st = request.getParameter("c_st")==null?"":request.getParameter("c_st");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	
	CodeBean bean = new CodeBean();
	bean.setC_st(c_st);
	bean.setCode(request.getParameter("code")==null?"":request.getParameter("code"));
	bean.setNm_cd(request.getParameter("nm_cd")==null?"":request.getParameter("nm_cd"));
	bean.setNm(request.getParameter("nm")==null?"":request.getParameter("nm"));
	bean.setApp_st(request.getParameter("app_st")==null?"N":request.getParameter("app_st"));
	
	if(cmd.equals("i")){//등록
		if(!am_db.insertCode(bean)) count = 1;
	}else{//수정
		if(!am_db.updateCode(bean)) count = 1;
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body leftmargin="15">
<form name='form1' action='s_code_i.jsp' method="POST" target='OpenList'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_br_id" value="<%=s_br_id%>">
<input type="hidden" name="s_dept_id_id" value="<%=s_dept_id%>">
<input type="hidden" name="c_st" value="<%=c_st%>">
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
