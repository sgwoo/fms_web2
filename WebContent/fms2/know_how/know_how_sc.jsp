<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");

	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-120;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&gubun_nm="+gubun_nm+"&gubun="+gubun+
				   	"&sh_height="+height+"";
					
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
//	function Know_how_Reg(){
//		var SUBWIN="./know_how_i.jsp";	
//		window.open(SUBWIN, "Know_how_Reg", "left=100, top=100, width=650, height=700, scrollbars=no");
//	}
	//등록은 아마존카에서만 
	function Know_how_Reg(){
		var fm = document.Know_how_from;
		fm.target="d_content";
		fm.action="know_how_i.jsp";		
		fm.submit();
	}	
	
function Know_how_Disp(know_how_id, user_id){
		var fm = document.Know_how_from;
		fm.know_how_id.value = know_how_id;
		fm.user_id.value = user_id;
		fm.target="d_content";
		fm.action="know_how_c.jsp";		
		fm.submit();
	}	
	
	
//-->
</script>
</head>
<body>
<form action="" name="Know_how_from" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type="hidden" name="gubun" value="<%=gubun%>">
	<input type="hidden" name="gubun1" value="<%=gubun1%>">
	<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	  <input type="hidden" name="know_how_id" value="">
	<input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td align='right'> 
		<% if( acar_de.equals("1000") || acar_de.equals("8888") ){ %>&nbsp;&nbsp;&nbsp;&nbsp;
		<% } else { %>		
		<a href='javascript:Know_how_Reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<% } %>
		</td>
	</tr>
	<tr>
		<td align=right>
			<iframe src="know_how_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=auto, marginwidth=0, marginheight=0></iframe>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</body>
</html>