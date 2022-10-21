<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cms.*"%>
<jsp:useBean id="cms_db" scope="page" class="acar.cms.CmsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	String bcode = request.getParameter("bcode")==null?"":request.getParameter("bcode");
	String bname = request.getParameter("bname")==null?"":request.getParameter("bname");
	String c_code = request.getParameter("c_code")==null?"":request.getParameter("c_code");
	
	if(cmd.equals("i")){		//등록
		if(!cms_db.insertCmsBnk(bcode, bname, c_code))	count += 1;
	}else if(cmd.equals("u")){	//수정
		if(!cms_db.updateCmsBnk(bcode, bname, c_code))	count += 1;
	}else{}
%>
<form name='form1' method='post'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
</form>
<script language='javascript'>
<%	if(count != 0){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{%>
		alert('처리되었습니다');
		var fm = document.form1;
		fm.target = "d_content";		
		fm.action = "bank_code.jsp";		
	//	parent.parent.location='/fms2/cms/bank_code.jsp';
		fm.submit();				
<%	}%>
</script>
</body>
</html>
