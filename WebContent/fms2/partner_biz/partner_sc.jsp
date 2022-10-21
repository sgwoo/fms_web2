<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//내용보기
	function getViewCont(idx, client_id, r_site, member_id){	
		var fm = document.form1;
		fm.idx.value = idx;
		fm.client_id.value = client_id;
		fm.r_site.value = r_site;
		fm.member_id.value = member_id;		
		fm.target = 'd_content';
		fm.submit();
	}
	
	//ID 등록
	function BranchAdd()
	{
	var SUBWIN="partner_office.jsp";	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=850, height=300, scrollbars=yes");
	}

	//New 로그인
	function getLogin2(url, id, pass){	
		var w = 450;
		var h = 250;
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var SUBWIN=url;	
//		var SUBWIN=url+"?userID="+id+"&password="+pass;
		window.open(SUBWIN, "InfoUp1", "left=5, top=5, width=1240, height=760, scrollbars=yes, status=yes, menubar=yes, toolbar=yes, resizable=yes");		
		
	}
	
function BranchUpdate(po_id)
{
	
	var SUBWIN="partner_office_u.jsp?po_id="+po_id;	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=850, height=300, scrollbars=yes");
}		

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='' target='d_content'>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_kd" value="<%=s_kd%>">
<input type='hidden' name="t_wd" value="<%=t_wd%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td><a href="javascript:BranchAdd()"><img src=/acar/images/center/button_reg_hluc.gif align=absmiddle border=0></a><br><br>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="partner_in.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>  
</body>
</html>
