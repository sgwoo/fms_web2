<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
		
	function VarReg(){
		var fm = document.form1;
		fm.action = "asset_var_i.jsp";
		fm.target = "d_content";
		fm.submit();
	}
	
	
	
	function OpenList(c_st){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var user_id = fm.user_id.value;
		var br_id = fm.br_id.value;
		var SUBWIN = "../add_mark/s_code_i.jsp";
		window.open(SUBWIN+"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&c_st="+c_st, "OpenList", "left=100, top=100, width=450, height=500, resizable=yes, scrollbars=yes, status=yes");
	}	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form action="./seti_var_sc_in.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">

</form>
<table border=0 cellspacing=0 cellpadding=0 width=800>
  <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
  <tr> 
    <td width="100%" align='right'>
	  <a href="javascript:VarReg()">변수등록</a> 
	
	</td>
    <td width="20" align='right'>&nbsp;</td>
  </tr>
  <%	}%>
  <tr> 
    <td colspan="2">
	      <iframe src="./asset_var_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>
	</td>
  </tr>
</table>
</body>
</html>