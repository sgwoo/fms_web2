<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.off_anc.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	int bbs_id = 0;
	String user_id = "";
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
	
	reg_dt = Util.getDate();
	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_nm = u_bean.getBr_nm();
	dept_nm = u_bean.getDept_nm();
	
%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function AncReg()
{
	var theForm = document.AncRegForm;
	if(theForm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
	else if(theForm.content.value == '')	{	alert('내용을 입력하십시오');	return;	}
	if(get_length(theForm.content.value) > 4000){
		alert("4000자 까지만 입력할 수 있습니다.");
		return;
	}		
	theForm.cmd.value = "i";
	theForm.target="i_no";
	theForm.submit();
}
function AncClose()
{
	opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}
function ChangeDT()
{
	var theForm = document.AncRegForm;
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
        등록</font> </td>
	</tr>
	<tr>
		<td colspan='4' align='right'> <a href="javascript:AncReg()"> 등록 </a> <a href="javascript:AncClose()">닫기</a></td>
	</tr>
	<form action="./anc_null_ui.jsp" name="AncRegForm" method="post">
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
				<td align="center" width="180"><input type='text' name="exp_dt"  size='28' class='text' onBlur="javascript:ChangeDT()"> </td>
			</tr>
			<tr>
				<td class="title">제목</td>
				<td colspan="3" align="center"> <input type='text' name="title" size='70' class='text'> </td>
			</tr>									
			<tr>
				<td class="title">내용</td>
				<td colspan="3" align="center"> <textarea name="content" cols='68' rows='15'> </textarea> </td>
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