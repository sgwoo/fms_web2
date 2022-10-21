<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun = request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-125;//현황 라인수만큼 제한 아이프레임 사이즈

	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun_nm="+gubun_nm+"&gubun="+gubun+
				   	"&sh_height="+height+"";	
%>
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	
	<title>FMS</title>
	<link rel="stylesheet" type="text/css" href="/include/table_t.css">
	<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>
<form action="" name="AncRegForm" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type="hidden" name="gubun" value="<%=gubun%>">
	<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>"> 
	<table border=0 cellspacing=0 cellpadding=0 width=100%>	    
	 	<tr>
			<td>
				<table border="0" cellspacing="0" cellpadding="0" width=100%>
					<tr>
						<td>
							<iframe src="complain_sc_in.jsp<%=valus%>&s_width=<%=s_width%>&s_height=<%=s_height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=auto, marginwidth=0, marginheight=0 >
							</iframe>
						</td>
					</tr>
				</table>
			</td>
	 	</tr>
	</table>
</form>
</body>
</html>