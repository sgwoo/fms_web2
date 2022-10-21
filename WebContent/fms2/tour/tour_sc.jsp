<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID

	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String yes = request.getParameter("yes")==null?"":request.getParameter("yes");

	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt =3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='' target='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='yes' value='<%=yes%>'>
<input type='hidden' name='f_list' value=''>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1147'>
	<tr>
	    <td style='height:2' colspan=2><font color='red'>※ 해당하는 직원은 년원일을 붉은색으로 표시함.</font></td>
	</tr>
	<tr>
	    <td style='height:2' colspan=2><font color='blue'></font></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='50' rowspan="3" class='title'>연번</td>
					<td width='100' rowspan="3" class='title'>부서</td>
					<td width='100' rowspan="3" class='title'>성명</td>
					<td width='120' rowspan="3" class='title'>입사일자</td>
					<td colspan="8" class='title'>해외여행포상일정</td>
				</tr>
				<tr>
					<td width='190' colspan="2" class='title'>1차(만5년도래일)</td>
					<td width='190' colspan="2" class='title'>2차(만11년도래일)</td>
					<td width='190' colspan="2" class='title'>3차(만18년도래일)</td>
					<td width='190' colspan="2" class='title'>4차(만25년도래일)</td>
				</tr>
				<tr>
					<td width='120' class='title'>년월일</td>
					<td width='70' class='title'>포상금</td>
					<td width='120' class='title'>년월일</td>
					<td width='70' class='title'>포상금</td>
					<td width='120' class='title'>년월일</td>
					<td width='70' class='title'>포상금</td>
					<td width='120' class='title'>년월일</td>
					<td width='70' class='title'>포상금</td>
				</tr>
			</table>
		</td>
		<td width=17>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=2>
			<iframe src="tour_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&yes=<%=yes%>" name="i_no" width="100%" height="<%=height -50%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
		</td>
	</tr>
</table>
</form>
</body>
</html>