<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd = request.getParameter("s_dd")==null?"":request.getParameter("s_dd");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//���󼼳��� ����
	function getViewCont(idx, bbs_id){
		var fm = document.form1;
		fm.bbs_id.value = bbs_id;
		fm.idx.value = idx;
		fm.action = 'mrent_bbs_c.jsp';
		fm.submit();
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='' target='d_content'>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="gubun" value="<%=gubun%>">
<input type='hidden' name="s_yy" value="<%=s_yy%>">
<input type='hidden' name="s_mm" value="<%=s_mm%>">
<input type='hidden' name="s_dd" value="<%=s_dd%>">
<input type='hidden' name="s_kd" value="<%=s_kd%>">
<input type='hidden' name="t_wd" value="<%=t_wd%>">
<input type='hidden' name="idx" value="<%=idx%>">
<input type='hidden' name="bbs_st" value="">
<input type='hidden' name="bbs_id" value="">
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
		<td class=line2></td>
	</tr>  
	<tr>
		<td class='line'>
			<table border=0 cellspacing=1 width=100%>
				<tr>
					<td width=6% class=title align=center>����</td>
					<td width=70% class=title>&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;</td>
					<td width=12% class=title>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ۼ���&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td width=12% class=title>�ۼ�����</td>
				</tr>
			</table>
		</td>
		<td width='16'></td>
	</tr>
	<tr> 
		<td colspan=2><iframe src="mrent_bbs_sc_in.jsp?member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&s_dd=<%=s_dd%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>#<%=idx%>" name="inner" width="100%" height="380" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td>
	</tr>
</table>
</form>  
</body>
</html>
