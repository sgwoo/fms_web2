<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
<!--
//리스트 엑셀 전환
	function prop_excel(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "acar_car_excel_list2.jsp";
		fm.submit();
	}
//-->
//-->
</script>
</head>
<body leftmargin=15 rightmargin=0>
<form name='form1' method='post'>

<input type='hidden' name='s_kd' value='<%=s_kd%>'> 
<input type='hidden' name='st_dt' value='<%=st_dt%>'> 
<input type='hidden' name='end_dt' value='<%=end_dt%>'> 

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>				
			        <td align='left'><a href="javascript:prop_excel();"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a></td>
			  
				</tr>
			</table>
		</td>
	</tr>
	
    <tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./car_list_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>" name="RegList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>	
</table>
</form>
</body>
</html>