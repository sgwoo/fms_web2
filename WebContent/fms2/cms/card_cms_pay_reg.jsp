<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function saveCms()
	{
		var fm = document.form1;
		
		if(fm.adate.value == ""){ alert("����Ƿ����ڸ� Ȯ���Ͻʽÿ�."); return; }				
		
		
		if ( 	fm.adate.value == "<%=AddUtil.getDate()%>" ){ alert("���Ϸ� �Ƿ��� �� �����ϴ�."); return; }			
				
		if(confirm('CMS���ⵥ��Ÿ�� �����Ͻðڽ��ϱ�?'))
		{		
			fm.target = 'i_no';
			fm.action='card_cms_pay_reg_a.jsp';
			fm.submit();
		}
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
			

%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						ī��CMS ���ο�û����Ÿ ���� </span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	

  
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
	   	<tr><td class=line2></td></tr>
		<tr>
		  <td width='13%' class='title'>�����Ƿ�����</td>		  
		  <td width='87%' >&nbsp;
			  <input type="text" name="adate" value="<%=AddUtil.getDate()%>" size="14" maxlength='10' class='default' onBlur='javascript:this.value=ChangeDate(this.value)'>
		  </td>
		</tr>
	  </table>
	</td>
  </tr>
  <% if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
  	
  <tr>
	<td align='right'><a href="javascript:saveCms()"><img src=/acar/images/center/button_reg.gif border=0></a></td>
  </tr>
  <% } %>
  <tr>
	<td><hr></td>
  </tr>
  <tr> 
 	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����������ȸ</span></td>
  </tr>  
 
 
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%> 
		  <tr>
			<td>
			  <iframe src="card_cms_pay_print.jsp?adate=<%=AddUtil.getDate()%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		  </tr>
		</table>
	  </td>
  </tr>

</table>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>