<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String est_nm = request.getParameter("est_nm")==null?"��":request.getParameter("est_nm");
	String send_seq = request.getParameter("send_seq")==null?"":request.getParameter("send_seq");	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>�����ּ� �Է��ϱ�</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style type="text/css">
<!--
body.general		{ background-color:#f4f3f3; font-family: ����, Gulim, AppleGothic, Seoul, Arial; font-size: 9pt;}
.style2 			{color: #515150; font-weight: bold; font-size:9pt;}
-->
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	margin-bottom: 0px;
	background-color:#f4f3f3;
	font-family: ����; font-size: 9pt;
}
-->
</style>
<script>
<!--
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') send_mail();
	}

	//���ϼ����ϱ�
	function send_mail(){
		
		var fm = document.form1;
		var addr = fm.mail_addr.value;
		if(addr==""){ alert("�����ּҸ� �Է����ּ���!"); return; }		
		else if(addr.indexOf("@")<0){ alert("�����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); return; }

		fm.action = "select_send_mail_docs.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	function cng_input(){
		var fm = document.form1;
		if(fm.replyto_st[0].checked == true || fm.replyto_st[1].checked == true){ 				//ȸ��||����
			tr_replyto.style.display='none';
		}else{																					//�����Է�
			tr_replyto.style.display='';				
		}
	}	
//-->
</script>

</head>

<body onLoad="document.form1.est_nm.focus();">
<form name="form1" method="post" action="">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="send_seq" value="<%= send_seq %>">
<table width=440 border=0 cellspacing=0 cellpadding=0>
	<tr>
		<td bgcolor=#9acbe1 height=5></td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[ ���� �߼� ]</td>
    </tr>
    <tr>
		<td height=10></td>
	</tr>
    <tr>
    	<td align=center>
    		<table width=392 border=0 cellspacing=0 cellpadding=0 background=http://fms.amazoncar.co.kr/acar/images/center/mail_bg.gif>
    			<tr>
    				<td><img src=http://fms.amazoncar.co.kr/acar/images/center/mail_up.gif></td>
    			</tr>
    			<tr>
    				<td height=20></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_2.gif></td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>��ȣ �Ǵ� ���� <br>
    				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="est_nm" size="35"></span></td>
    			</tr>
    			<tr>
    				<td height=10></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>�̸����ּ�  <br>
    				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="mail_addr" size="35" onKeydown="javascript:EnterDown()" value='' style='IME-MODE: inactive'></span></td>
    			</tr>
    			<tr>
    				<td height=30></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_3.gif></td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr>
			        <td align=center><table width=350 border=0 cellspacing=0 cellpadding=0>
			            <tr>
			                <td colspan='3'>
							  	<span class=style2>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="replyto_st" value='1' onClick="javascript:cng_input()" checked > ȸ�����</span>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td colspan='3'>
			        			<span class=style2>
			        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="replyto_st" value='2' onClick="javascript:cng_input()" > ����ڵ�ϸ���</span>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td colspan='3'>
			        		<table width=350 border=0 cellspacing=0 cellpadding=0>
			        			<tr>
			        				<td><span class=style2>
			        				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="replyto_st" value='3' onClick="javascript:cng_input()" > �����Է� </span>	</td>			        				
			        			</tr>
			        			<tr id='tr_replyto' style='display:none'>
			        				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="replyto" size="35" onKeydown="javascript:EnterDown()" value=''></td>
			        			</tr>			        			
			        		</table>
							  
							</td>
			            </tr>
			        </table></td>
			    </tr>
			    	
  
    			<tr>
    				<td height=30></td>
    			</tr>    						
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_4.gif></td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <textarea name="memo" cols="30" rows="10"></textarea></td>
    			</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>


			<tr>
    				<td height=20></td>
    			</tr>
    			<tr>
    				<td><img src=http://fms.amazoncar.co.kr/acar/images/center/mail_dw.gif></td>
    			</tr>
    		</table>
    	</td>
    </tr>
    <tr>
    	<td height=10></td>
    </tr>
    <tr>
    	<td align=center><a href="javascript:send_mail();"><img src=http://fms.amazoncar.co.kr/acar/images/center/mail_btn_send.gif border="0"></a></td>
    </tr>
   
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>
