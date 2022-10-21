<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function AncReg(){
	
	var SUBWIN="./bul_i.jsp?ck_acar_id=<%=ck_acar_id%>";	
		window.open(SUBWIN, "AncReg", "left=100, top=100, width=850, height=650, scrollbars=yes");
				
	}

	function AncDisp(b_id){
	
		var SUBWIN="./bul_c.jsp?b_id=" + b_id;	
		window.open(SUBWIN, "AncDisp", "left=10, top=10, width=850, height=650, scrollbars=yes");
		
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	int count = 0;
	
	
	String acar_id = ck_acar_id;
	
	OffBulDatabase obd = OffBulDatabase.getInstance();
	//만료일 지난것 삭제->기록 남기기 변경

	BulBean a_r [] = obd.getBulAll(gubun, gubun_nm, acar_id, "B");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-30;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form  name="AncRegForm" method="POST">
	<input type="hidden" name="cmd" value="">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name="b_id" value="">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<input type='hidden' name="s_width" value="<%=s_width%>">   
	<input type='hidden' name="s_height" value="<%=s_height%>">  
	<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<tr> 
		<td align='right' colspan=2> <a href='javascript:AncReg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;	
    	</td>
	</tr>
	<%}%>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<tr> 
					<td class='title' width=5%>연번</td>
					<td class='title' width=49%>제목</td>
					<td class='title' width=10%>등록자</td>
					<td class='title' width=12%>부서</td>
					<td class='title' width=12%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;등록일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class='title' width=12%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;만료일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
			</table>
		<td width="16">&nbsp;</td>
	</tr>
    <tr>
        <td colspan=2>
<iframe src="./bul_s_sc_in.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
</tr>
</form>
</body>
</html>