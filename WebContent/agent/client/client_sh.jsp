<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 	= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	String incom_dt = request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq	= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.t_wd.value=document.form1.t_wd.value.replace(/\'/g,""); //�ܵ���ǥ ġȯ
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>

<form name='form1' action='/agent/client/client_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type="hidden" name="incom_dt" value="<%=incom_dt%>">
<input type="hidden" name="incom_seq" value="<%=incom_seq%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp;
						<select name='s_kd'>
							<option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ</option>
							<option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>�����</option>
							<option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>�����</option>
							<option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>��ȭ��ȣ</option>
							<option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>�޴���</option>
							<option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>�ּ�</option>
							<option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>�������/����ڹ�ȣ</option>
							<option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>�����</option>							
						</select>
						<input type='text' size='15' class='text' name='t_wd' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
						<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;<input type='radio' name='asc' value='0' <%if(asc.equals("0")){%>checked<%}%> onClick='javascript:search()'>��������
						<input type='radio' name='asc' value='1' <%if(asc.equals("1")){%>checked<%}%> onClick='javascript:search()'>��������
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
