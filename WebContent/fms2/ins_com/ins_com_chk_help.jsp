<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<style type=text/css>

<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>

<div class="navigation">
	<span class=style1>������� ></span><span class=style5>�����û����</span>
</div>

<table border="0" cellspacing="0" cellpadding="0" width='650'>  
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Կ�û ���˳���</span></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>����</td>
					<td width='450' class='title'>����</td>
			  </tr>
				<tr>
					<td class='title'>�������</td>
					<td>&nbsp;��������� �� ����� �����Ǿ���.</td>
			  </tr>
				<tr>
					<td class='title'>���� ����</td>
					<td>&nbsp;������ �̹� ��ϵǾ� �ִ�.</td>
			  </tr>
			</table>
		</td>
	</tr>     
    <tr> 
        <td>�� �����ȣ, ������ȣ, ���ڽ� ������ ���� ó���Ѵ�.</td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>    
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ſ�û ���˳���</span></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>����</td>
					<td width='450' class='title'>����</td>
			  </tr>
				<tr>
					<td class='title'>���������� ���</td>
					<td>&nbsp;��� �� ���Կɼ��� �Ǿ�����, ������������ ���Ž����Ϻ��� �۴�.</td>
			  </tr>
				<tr>
					<td class='title'>��ຯ��</td>
					<td>&nbsp;���� ��û�� ���� �� ������ ����� �ٸ���.</td>
			  </tr>
				<tr>
					<td class='title'>�������</td>
					<td>&nbsp;����� ���� �Ϸ�Ǿ���.</td>
			  </tr>
				<tr>
					<td class='title'>��������Ƿ�</td>
					<td>&nbsp;����� �����Ƿڰ� ��ϵǾ���.</td>
			  </tr>
				<tr>
					<td class='title'>���� ����</td>
					<td>&nbsp;�����ڷ� ���ź����� �̹� ��ϵǾ� �ִ�.</td>
			  </tr>			  
			</table>
		</td>
	</tr>     
    <tr> 
        <td>&nbsp;</td>
    </tr>    
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�輭��û ���˳���</span></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>����</td>
					<td width='450' class='title'>����</td>
			  </tr>
				<tr>
					<td class='title'>����������</td>
					<td>&nbsp;���������������� ��û�� ������ �����Ƿڰ� �����Ǿ���.</td>
			  </tr>
			</table>
		</td>
	</tr>     
    <tr> 
        <td>�� ���躯���û���� ��ϵ� ���� �輭��û ������� ���� ��ݿ� �� �輭��Ȳ�� ������ Ȯ���ϰ� ����Ǹ� ����Ѵ�.</td>
    </tr>
	
    <tr> 
        <td>&nbsp;</td>
    </tr>    
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������û ���˳���</span></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>����</td>
					<td width='450' class='title'>����</td>
			  </tr>
				<tr>
					<td class='title'>���� ����</td>
					<td>&nbsp;���������� �̹� ��ϵǾ� �ִ�</td>
			  </tr>
			</table>
		</td>
	</tr>     	
    <tr> 
        <td>&nbsp;</td>
    </tr>            
    <tr>
        <td align="right">		
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>	
</table>

</body>
</html>
