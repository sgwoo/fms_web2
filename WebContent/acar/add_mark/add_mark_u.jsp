<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.off_anc.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	OffAncDatabase oad = OffAncDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	int bbs_id = 0;
	String user_id = "";
	String acar_id = "";
	String user_nm = "";
	String br_id = "";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";
	String reg_dt = "";
	String exp_dt = "";
	String title = "";
	String content = "";
    String auth_rw = "";
    String cmd = "";
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("bbs_id") != null) bbs_id = Util.parseInt(request.getParameter("bbs_id"));
	
	acar_id = login.getCookieValue(request, "acar_id");
	
	a_bean = oad.getAncBean(bbs_id);
	user_id = a_bean.getUser_id();
	user_nm = a_bean.getUser_nm();
	dept_nm = a_bean.getDept_nm();
	reg_dt = a_bean.getReg_dt();
	exp_dt = a_bean.getExp_dt();
	title = a_bean.getTitle();
	content = a_bean.getContent();
	
%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function AncUp()
{
	var theForm = document.AncUpForm;
	if(theForm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
	else if(theForm.content.value == '')	{	alert('내용을 입력하십시오');	return;	}
	if(get_length(theForm.content.value) > 4000){
		alert("4000자 까지만 입력할 수 있습니다.");
		return;
	}	
	theForm.cmd.value = "u";
	theForm.target="i_no";
	theForm.submit();
}
function ChangeDT()
{
	var theForm = document.AncUpForm;
	theForm.exp_dt.value = ChangeDate(theForm.exp_dt.value);
}
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body onLoad="javascript:self.focus()">
<center>
<table border="0" cellspacing="0" cellpadding="0" width=500>
	<tr>
		
      <td> <font color="navy">MASTER -> </font><font color="navy">공지사항 -> </font><font color="red">공지사항 
        수정</font> </td>
	</tr>
	<tr>
		<td colspan='4' align='right'> <a href="javascript:AncUp()" onMouseOver="window.status=''; return true"> 수정 </a> </td>
	</tr>
	<form action="./anc_null_ui.jsp" name="AncUpForm" method="post">
	<tr>
	<td class='line'>
		 <table border="0" cellspacing="1" cellpadding="0" width=500>
			
			<tr>
				<td class="title">작성자</td>
				<td align="center"><%=user_nm%></td>
				<td class="title">부서</td>
				<td align="center"><%=dept_nm%></td>
				
			</tr>
			<tr>
				<td class="title" width="70">작성일</td>
				<td align="center" width="180"><%=reg_dt%></td>
				<td class="title" width="70">만료일</td>
				<td align="center" width="180"><input type='text' name="exp_dt" value="<%=exp_dt%>" size='28' class='text' onBlur="javascript:ChangeDT()"></td>
			</tr>
			<tr>
				<td class="title">제목</td>
				<td colspan="3" align="center"><input type='text' name="title" value="<%=title%>" size='70' class='text'></td>
			</tr>									
			<tr>
				<td class="title">내용</td>
				<td colspan="3" align="center"><textarea name="content" cols='68' rows='15'><%=content%></textarea></td>
			</tr>
		</table>
		<input type="hidden" name="user_id" value="<%=user_id%>">
		<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
		<input type="hidden" name="cmd" value="">
	</td>
	</tr>
	</form>
		
</table>
</center>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>

</body>
</html>