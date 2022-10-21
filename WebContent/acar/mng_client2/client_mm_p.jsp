<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function reg_mm()
	{
		if(confirm('메모를 등록하시겠습니까?'))
		{
			var fm = document.form1;
			if(fm.content.value == '')	{alert('내용을 입력하십시오');	return;	}
			fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<form name='form1' method='post' action='/acar/mng_client2/client_mm_i_a.jsp'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='reg_id' value='<%=user_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>거래처메모</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>		
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width='18%' class='title'>날짜</td>
					<td width='18%' class='title'>등록자</td>
					<td width='64%' class='title'>메모</td>
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="/acar/mng_client2/client_mm_in.jsp?client_id=<%=client_id%>" name="inner" width="100%" height="200" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		</td>
	</tr>
<%
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
	<tr>
		<td align='right'><a href='javascript:reg_mm()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
		<td></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width='18%' class='title'>작성일</td>
					<td>&nbsp;<input type='text' size='12' name='reg_dt' class='text' value='<%=Util.getDate()%>' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
				</tr>
				<tr>
					<td class='title'>작성자</td>
					<td>&nbsp;<%=c_db.getNameById(user_id, "USER")%></td>
				</tr>
				<tr>
					<td class='title'>내용</td>
					<td>&nbsp;<textarea name='content' rows='3' cols='60' maxlength='400'></textarea></td>
				</tr>
			</table>
		</td>
		<td></td>
	</tr>
<%
	}
%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
