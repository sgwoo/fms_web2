<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.client.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='javascript'>
<!--
	function save(idx)
	{
		confirm('등록하시겠습니까?')
		{
			var fm = document.form1;
			if(fm.user_id.value == '')						{	alert('USER_ID를 확인하십시오');	return;	}
			else if(fm.user_psd1.value != fm.user_psd2.value)	{	alert('PASSWORD를 확인하십시오');	return;	}
			fm.page_mode.value=idx;
			//fm.submit();
		}
	}
//-->
</script>
</head>
<body>
<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	ClientUserBean c_user = l_db.getClientUser(c_id);
%>
<form name='form1' action='/acar/mng_client/cng_user_u_a.jsp' method='post' target='i_no'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='page_mode' value=''>
<table border=0 cellspacing=0 cellpadding=0 width='400'>
	<tr>
		<td>
			<고객 사용자 ID관리>
		</td>
	</tr>
<%
		if(c_user == null){
%>
	<tr>
        <td class='line'>
            <table border="0" cellspacing="1" cellpadding='0' width=400>
            	<tr>
					<td width='100' class='title'>USER ID</td>
                    <td colspan='3'>&nbsp;<input type='text' name='user_id' value='' class='text' size='10'></td>
               	</tr>
               	<tr>
                    <td width='100' class='title'>PASSWORD</td>
                    <td width='100'>&nbsp;<input type='password' name='user_psd1' value='' class='text' size='10'></td>
                    <td width='100' class='title'>PASSWORD확인</td>
                    <td width='100'>&nbsp;<input type='password' name='user_psd2' value='' class='text' size='10'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'>
			<a href="javascript:save('0')">등록</a>
		</td>
	</tr>
<%
		}else{
%>
	<tr>
        <td class='line'>
            <table border="0" cellspacing="1" cellpadding='0' width=400>
            	<tr>
					<td width='100' class='title'>USER ID</td>
                    <td colspan='3'>&nbsp;<input type='text' name='user_id' value='<%=c_user.getUser_id()%>' class='text' size='10'></td>
               	</tr>
               	<tr>
                    <td width='100' class='title'>PASSWORD</td>
                    <td width='100'>&nbsp;<input type='password' name='user_psd1' value='<%=c_user.getUser_psd()%>' class='text' size='10'></td>
                    <td width='100' class='title'>PASSWORD확인</td>
                    <td width='100'>&nbsp;<input type='password' name='user_psd2' value='<%=c_user.getUser_psd()%>' class='text' size='10'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'>
			<a href="javascript:save('1')">수정</a>
		</td>
	</tr>

<%
		}
%>

	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
