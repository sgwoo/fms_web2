<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String est_nm = request.getParameter("est_nm")==null?"��":request.getParameter("est_nm");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String type = request.getParameter("type")==null?"":request.getParameter("type");
	String view_amt = request.getParameter("view_amt")==null?"":request.getParameter("view_amt");
	String pay_way = request.getParameter("pay_way")==null?"":request.getParameter("pay_way");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	String view_good = request.getParameter("view_good")==null?"":request.getParameter("view_good");
	String view_tel = request.getParameter("view_tel")==null?"":request.getParameter("view_tel");
	String view_addr = request.getParameter("view_addr")==null?"":request.getParameter("view_addr");
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

		fm.action = "select_send_mail_rent_docs.jsp";
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
	
	function cng_input2(){
		var fm = document.form1;
		if(fm.send_st[0].checked == true){ 				//����(PC)
			tr_from_p.style.display='';
			tr_from_p2.style.display='';
			tr_from_p3.style.display='';
			tr_from_m.style.display='none';
		}else{											//�˸���(�����)
			tr_from_p.style.display='none';				
			tr_from_p2.style.display='none';
			tr_from_p3.style.display='none';
			tr_from_m.style.display='';
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
<input type="hidden" name="rent_l_cd" value="<%= rent_l_cd %>">
<input type="hidden" name="rent_mng_id" value="<%= rent_mng_id %>">
<input type="hidden" name="rent_st" value="<%= rent_st %>">
<input type="hidden" name="client_id" value="<%= client_id %>">
<input type="hidden" name="type" value="<%= type %>">
<input type="hidden" name="view_amt" value="<%= view_amt %>">
<input type="hidden" name="pay_way" value="<%= pay_way %>">
<input type="hidden" name="view_good" value="<%= view_good %>">
<input type="hidden" name="view_tel" value="<%= view_tel %>">
<input type="hidden" name="view_addr" value="<%= view_addr %>">
<table width=100% border=0 cellspacing=0 cellpadding=0>
	<tr>
		<td bgcolor=#9acbe1 height=5></td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[ 
           <%if(type.equals("1")){ %>�ڱ���������Ȯ�μ�
           <%}else if(type.equals("2")){ %>�ڵ��� �뿩�̿� ����� Ȯ�μ�
           <%}else if(type.equals("3")){ %>�ڵ������� ���� Ư�� ������
           <%}else if(type.equals("4")){ %>�ڵ��� ���뿩 �뿩���� �������� �ȳ�
           <%}else if(type.equals("5")){ %>������ ���� ���Ի�� Ȯ�μ�
           <%}else if(type.equals("6")){ %>����������� ����� Ȯ�μ�
           <%}else if(type.equals("7")){ %>�뿩������ ��༭
           <%} %>
                   �߼� ]
        </td>
    </tr>
    <tr>
		<td height=10></td>
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
    			<tr id='tr_from_p' style="display:''">
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>�̸����ּ� (���ϼ����ּ�) <br>
    				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="mail_addr" size="35" onKeydown="javascript:EnterDown()" value='' style='IME-MODE: inactive'></span></td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr id='tr_from_p2' style="display:''">
			        <td align=center>
			        	<table width=350 border=0 cellspacing=0 cellpadding=0>
    						<tr>
    							<td height=30></td>
    						</tr>    						
    						<tr>
    							<td>&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_3.gif></td>
    						</tr>
    						<tr>
    							<td height=7></td>
    						</tr>
			            	<tr>
			                	<td>
							  		<span class=style2>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="replyto_st" value='1' onClick="javascript:cng_input()" checked > ȸ�����</span>
			        			</td>
			        		</tr>
			        		<tr>
			        			<td>
			        				<span class=style2>
			        				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="replyto_st" value='2' onClick="javascript:cng_input()" > ����ڵ�ϸ���</span>
			        			</td>
			        		</tr>
			        		<tr>
			        			<td >
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
			        	</table>
			        </td>
			    </tr>
			    <tr id='tr_from_p3' style="display:''">
			        <td align=center>
			        	<table width=350 border=0 cellspacing=0 cellpadding=0>	
    						<tr>
    							<td height=30></td>
    						</tr>    						
    						<tr>
    							<td>&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_4.gif></td>
    						</tr>
    						<tr>
    							<td height=7></td>
    						</tr>
    						<tr>
    							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <textarea name="memo" cols="30" rows="10"></textarea></td>
    						</tr>
    					</table>
			        </td>
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
