<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*" %>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String est_nm = request.getParameter("est_nm")==null?"��":request.getParameter("est_nm");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String type = request.getParameter("type")==null?"":request.getParameter("type");
	String view_amt = request.getParameter("view_amt")==null?"":request.getParameter("view_amt");
	String pay_way = request.getParameter("pay_way")==null?"":request.getParameter("pay_way");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String ch_cd = request.getParameter("ch_cd")==null?"":request.getParameter("ch_cd");
	String user_type = request.getParameter("user_type")==null?"":request.getParameter("user_type");
	
	String view_good = request.getParameter("view_good")==null?"":request.getParameter("view_good");
	String view_tel = request.getParameter("view_tel")==null?"":request.getParameter("view_tel");
	String view_addr = request.getParameter("view_addr")==null?"":request.getParameter("view_addr");
	String doc_url = request.getParameter("doc_url")==null?"":request.getParameter("doc_url");
	String client_st = request.getParameter("client_st")==null?"":request.getParameter("client_st");
	
	//�̸����ּ�
	Vector vt1 = al_db.getClientEdocList("mail", client_id, rent_l_cd);
	int vt1_size = vt1.size();
	
	//�޴�����ȣ
	Vector vt2 = al_db.getClientEdocList("m_tel", client_id, rent_l_cd);
	int vt2_size = vt2.size();
	
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
.style5 			{color: #515150; font-weight: bold; font-size:15pt;}
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

input.default 		{ font-size : 10pt; text-align:left; background-color:#EAF1FF ; border-color:#000000; border-width:1; height:20;}
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
		
		if(fm.send_st[0].checked == true){ 				//����(PC)
			if(addr==""){ alert("�����ּҸ� �Է����ּ���!"); return; }		
			else if(addr.indexOf("@")<0){ alert("�����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); return; }	
		}else{											//�˸���(�����)
			if(fm.m_tel.value==""){ alert("�޴�����ȣ�� �Է����ּ���!"); return; }					
		}

		fm.action = "select_send_mail_e_doc.jsp";
		//fm.target = "i_no";
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
			tr_from_m.style.display='none';
		}else{											//�˸���(�����)
			tr_from_p.style.display='none';									
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
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="ch_cd" value="<%= ch_cd %>">
<input type="hidden" name="user_type" value="<%= user_type %>">
<input type="hidden" name="type" value="<%= type %>">
<input type="hidden" name="view_amt" value="<%= view_amt %>">
<input type="hidden" name="pay_way" value="<%= pay_way %>">
<input type="hidden" name="view_good" value="<%= view_good %>">
<input type="hidden" name="view_tel" value="<%= view_tel %>">
<input type="hidden" name="view_addr" value="<%= view_addr %>">
<input type="hidden" name="doc_url" value="<%= doc_url %>">
<input type="hidden" name="client_st" value="<%= client_st %>">

<table width=100% border=0 cellspacing=0 cellpadding=0>
	<tr>
		<td bgcolor=#9acbe1 height=5></td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
    <tr>
        <td align=center>[ 
           <%if(type.equals("1")){ %>�ڱ���������Ȯ�μ�
           		<input type="hidden" name="doc_name" value="�ڱ���������Ȯ�μ�">
           		<input type="hidden" name="doc_type" value="4">
           <%}else if(type.equals("2")){ %>�ڵ��� �뿩�̿� ����� Ȯ�μ�
           		<input type="hidden" name="doc_name" value="�ڵ��� �뿩�̿� ����� Ȯ�μ�">
           		<input type="hidden" name="doc_type" value="3">
           <%}else if(type.equals("3")){ %>�ڵ������� ���� Ư�� ������
           		<input type="hidden" name="doc_name" value="�ڵ������� ���� Ư�� ������">
           		<input type="hidden" name="doc_type" value="4">
           <%}else if(type.equals("4")){ %>�ڵ��� ���뿩 �뿩���� �������� �ȳ�
           		<input type="hidden" name="doc_name" value="�ڵ��� ���뿩 �뿩���� �������� �ȳ�">
           		<input type="hidden" name="doc_type" value="3">
           <%}else if(type.equals("5")){ %>���������ڵ������� ����/�̰��� ��û��(���λ���� ����)
           		<input type="hidden" name="doc_name" value="���������ڵ������� ����/�̰��� ��û��(���λ���� ����)">
           		<input type="hidden" name="doc_type" value="4">                      
           <%}else if(type.equals("8")){ %>���������ڵ������� ����/�̰��� ��û��(���λ���� ����)
           		<input type="hidden" name="doc_name" value="���������ڵ������� ����/�̰��� ��û��(���λ���� ����)">
           		<input type="hidden" name="doc_type" value="4">
           <%}else if(type.equals("9")){ %>������ ���� ��û��
           		<input type="hidden" name="doc_name" value="������ ���� ��û��">
           		<input type="hidden" name="doc_type" value="4">
           <%}else if(type.equals("10")){ %>������� ���� ��û��
           		<input type="hidden" name="doc_name" value="������� ���� ��û��">
           		<input type="hidden" name="doc_type" value="4">
           <%}else if(type.equals("11")){ %>(�ɻ��)����(�ſ�)���� ����_�̿�_��ȸ���Ǽ�
           		<input type="hidden" name="doc_name" value="(�ɻ��)����(�ſ�)���� ����_�̿�_��ȸ���Ǽ�">
           		<input type="hidden" name="doc_type" value="4">
           <%}else if(type.equals("12")){ %>CMS�ڵ���ü��û��(����/���λ���� ����)
           		<input type="hidden" name="doc_name" value="CMS�ڵ���ü��û��(����/���λ���� ����)">
           		<input type="hidden" name="doc_type" value="4">
           <%}else if(type.equals("13")){ %>CMS�ڵ���ü��û��(���� ����)
           		<input type="hidden" name="doc_name" value="CMS�ڵ���ü��û��(���� ����)">
           		<input type="hidden" name="doc_type" value="3">
           <%} %>
                   �߼� ]
        </td>
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
    				<td height=7></td>
    			</tr>
    			<tr>
    				<td>   
    				&nbsp;&nbsp;&nbsp; 				
    				<span class=style2>
								&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<input type='radio' name="send_st" value='1' onClick="javascript:cng_input2()" checked > ����(PC)</span>            							
					<span class=style2>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="send_st" value='2' onClick="javascript:cng_input2()" > �˸���(�����)</span>
    				</td>
    			</tr>    	
    			<tr>
    				<td height=7></td>
    			</tr>
    			<input type="hidden" name="sign_type" value="2">
    			<!-- 
    			<tr>
    				<td>   
    				&nbsp;&nbsp;&nbsp; 				
    				<span class=style2>
								&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<input type='radio' name="sign_type" value='0' <%if(type.equals("1") || type.equals("3") || type.equals("5") || type.equals("8") || type.equals("9") || type.equals("10") || type.equals("11") || type.equals("12")){ %>disabled<%}else{%>checked<%} %>> �������</span>      
					<span class=style2>
								&nbsp;&nbsp;&nbsp;<input type='radio' name="sign_type" value='1' disabled> ������</span>            							
					<span class=style2>
								&nbsp;&nbsp;&nbsp;<input type='radio' name="sign_type" value='2' <%if(type.equals("1") || type.equals("3") || type.equals("5") || type.equals("8") || type.equals("9") || type.equals("10") || type.equals("11") || type.equals("12")){ %>checked<%}else{%>disabled<%} %>> ���ʼ���</span>
    				</td>
    			</tr>
    			 -->    			
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
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>��ȣ �Ǵ� ���� <br><br>
    				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    				<input type="text" name="est_nm" class='default' size="35" value='<%=est_nm%>'></span></td>
    			</tr>
    			
    			<tr>
    				<td height=20></td>
    			</tr>
    			
    			<tr id='tr_from_p' style="display:''">
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>�̸����ּ� (���ϼ����ּ�) <br><br>
    				<%if(!type.equals("11")){ %>
    				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    				<select name="lb_userList1" onChange="javascript:document.form1.mail_addr.value=this.value;">
    					<option value="">����</option>								
        				<%for(int i = 0 ; i < vt1_size ; i++){
        					Hashtable ht = (Hashtable)vt1.elementAt(i);
        				%>
        				<option value="<%=ht.get("EMAIL")%>">[<%=ht.get("ST")%>] <%=ht.get("EMP_NM")%> <%=ht.get("EMAIL")%></option>
        				<%}%>	
         			</select><br><br>
         			<%} %>
         			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    				<input type="text" name="mail_addr" class='default' size="35" onKeydown="javascript:EnterDown()" value='' style='IME-MODE: inactive'></span></td>
    			</tr>
    			
    			<tr id='tr_from_m' style='display:none'>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>�޴�����ȣ (�˸�����Ź�ȣ)  <br><br>
    				<%if(!type.equals("11")){ %>
    				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    				<select name="lb_userList2" onChange="javascript:document.form1.m_tel.value=this.value;">
    					<option value="">����</option>								
        				<%for(int i = 0 ; i < vt2_size ; i++){
        					Hashtable ht = (Hashtable)vt2.elementAt(i);
        				%>
        				<option value="<%=ht.get("M_TEL")%>">[<%=ht.get("ST")%>] <%=ht.get("EMP_NM")%> <%=ht.get("M_TEL")%></option>
        				<%}%>	
         			</select><br><br>
         			<%} %>         			
         			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    				<input type="text" name="m_tel" size="35" onKeydown="javascript:EnterDown()" value='' style='IME-MODE: inactive'></span></td>
    			</tr>
				<tr>
    				<td height=30></td>
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
