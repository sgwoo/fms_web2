<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.partner.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 4; //��Ȳ ��� �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
		
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--


function Mail_send(){
	
		var fm = document.form1;	
		
	
		if(!confirm('������ �����Ͻðڽ��ϱ�?')){	return;	}
	
		if ( fm.s_kd.value == "X" ) {
		//	fm.action = "mail_care_a.jsp";
		//	fm.action = "mail_santafe_a.jsp";
		} else {
			fm.action = "mail_a.jsp";
		}
		fm.target = "i_no";
		fm.submit();
			
	}

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
</head>
<body leftmargin="15" onLoad="self.focus()">

<form action="" name="form1" method="POST"  enctype="multipart/form-data">
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_kd" value="<%=s_kd%>">
<input type='hidden' name="use_yn" value="<%=use_yn%>">
<input type='hidden' name="t_wd" value="<%=t_wd%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	
<table border=0 cellspacing=0 cellpadding=0 width="600">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> ���¾�ü > �ܺξ�ü�α��� > <span class=style5>����ڰ��� ���Ϻ�����</span></span></td>
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
    	<td class=line>
	    	<table border="0" cellspacing="1" cellpadding="0" width="100%">
	    		<tr>
			    	<td width=20% class=title>����</td>
			    	<td width=80% align="center"><input type="text" name="mail_title" size="73" ></td>			 
			    </tr>
				
				<tr>
			    	<td width=20% class=title>�޴»��</td>
			    	<td width=80% align="center">��ü</td>			 
			    </tr>

			    <tr>
			    	<td width=20% class=title>����</td>
			    	<td width=80% align="center"><textarea name="mail_cau" id="mail_cau" cols="75" class="text" style="IME-MODE: active" rows="20"></textarea> </td>
			
			    </tr>
			    <tr>
			    	<td width=20% class=title>÷������</td>
			    	<td width=80% align="center"><input type="file" name="filename" size="50"></td>
				</tr>
				<tr>
			    	<td width=20% class=title>÷������</td>
			    	<td width=80% align="center"><input type="file" name="filename2" size="50"></td>
				</tr>
			</table>
    	</td>
    </tr>
	<tr>
    	<td align="right" height=25><a href="javascript:Mail_send()"><img src="/acar/images/center/button_mail.gif" align=absmiddle border=0></a>&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</body>
</html>