<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	ClientBean client = al_db.getNewClient(client_id);
		
	//�ŷ�ó �ڻ�
	ClientAssestBean client_assest = al_db.getClientAssest(client_id);
	
	//�ŷ�ó �繫��ǥ
	ClientFinBean client_fin = al_db.getClientFin(client_id);	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		if(confirm('�����Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;	
			if(fm.email_1.value != '' && fm.email_2.value != ''){
				fm.con_agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;		
			}	
			fm.target='i_no';
			fm.submit();
		}
	}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body>
<form name='form1' method='post' action='client_u_mini_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='client_st' value='<%=client.getClient_st()%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan="2">
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
	    <td class=line2 colspan=2></td>
	</tr>
	<tr> 
        <td colspan="2" class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='13%'> ������ </td>
                    <td >&nbsp; 
                          <%if(client.getClient_st().equals("1")) 		out.println("����");
                          	else if(client.getClient_st().equals("2"))  out.println("����");
                          	else if(client.getClient_st().equals("3")) 	out.println("���λ����(�Ϲݰ���)");
                          	else if(client.getClient_st().equals("4"))	out.println("���λ����(���̰���)");
                          	else if(client.getClient_st().equals("5")) 	out.println("���λ����(�鼼�����)");
            				else if(client.getClient_st().equals("6")) 	out.println("�����");%>
                    </td>
                </tr>
                <tr>
                    <td class='title' width='13%'> ��ȣ/���� </td>
                    <td >&nbsp; 
                          <%=client.getFirm_nm()%>
                    </td>
                </tr>				
            </table>
        </td>
	</tr>	
	<tr>
        <td class=h></td>
    </tr>
	<tr>  
        <td colspan="2">
            <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    			<tr>
    		        <td class=line2></td>
    		    </tr>
			    <tr>
			        <td class=line>
			            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td width='13%' class='title'>�޴�����ȣ</td>
            		            <td>&nbsp;<input type='text' size='30' name='m_tel' value='<%=client.getM_tel()%>' maxlength='15' class='text'></td></td>
            		            <td width='13%' class='title'>���ù�ȣ</td>
            		            <td>&nbsp;<input type='text' size='30' name='h_tel' value='<%=client.getH_tel()%>' maxlength='15' class='text'></td></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>�繫�ǹ�ȣ</td>
            		            <td>&nbsp;<input type='text' size='30' name='o_tel' value='<%=client.getO_tel()%>' maxlength='15' class='text'></td>
            		            <td class='title'>�ѽ���ȣ</td>
            		            <td>&nbsp;<input type='text' size='30' name='fax' value='<%=client.getFax()%>' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>  
            		            <td class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;<input type='text' size='50' name='homepage' value='<%=client.getHomepage()%>' maxlength='70' class='text'></td>
            		        </tr>
                	        <tr>
                	            <td width="13%" rowspan='2' class='title'>���ݰ�꼭<br>
                	            �����</td>
                	            <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> ����:&nbsp;&nbsp;&nbsp;
        			            <input type='text' size='15' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text'>
        			        	&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �繫��:
        			        	<input type='text' size='30' name='con_agnt_o_tel' value='<%=client.getCon_agnt_o_tel()%>' maxlength='30' class='text'>
        			        	&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �̵���ȭ:
        			        	<input type='text' size='15' name='con_agnt_m_tel' value='<%=client.getCon_agnt_m_tel()%>' maxlength='15' class='text'>
        			        	&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> FAX:
        			        	<input type='text' size='15' name='con_agnt_fax' value='<%=client.getCon_agnt_fax()%>' maxlength='15' class='text'>
        			            </td>
                	        </tr>
				<%	String email_1 = "";
					String email_2 = "";
					if(!client.getCon_agnt_email().equals("")){
						int mail_len = client.getCon_agnt_email().indexOf("@");
						if(mail_len > 0){
							email_1 = client.getCon_agnt_email().substring(0,mail_len);
							email_2 = client.getCon_agnt_email().substring(mail_len+1);
						}
					}
				%>							
                	        <tr>
               	              <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> EMAIL: 
							    <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
					  		    <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
								  <option value="" selected>�����ϼ���</option>
								  <option value="hanmail.net">hanmail.net</option>
								  <option value="naver.com">naver.com</option>
								  <option value="nate.com">nate.com</option>
								  <option value="bill36524.com">bill36524.com</option>
								  <option value="gmail.com">gmail.com</option>
								  <option value="paran.com">paran.com</option>
								  <option value="yahoo.com">yahoo.com</option>
								  <option value="korea.com">korea.com</option>
								  <option value="hotmail.com">hotmail.com</option>
								  <option value="chol.com">chol.com</option>
								  <option value="daum.net">daum.net</option>
								  <option value="hanafos.com">hanafos.com</option>
								  <option value="lycos.co.kr">lycos.co.kr</option>
								  <option value="dreamwiz.com">dreamwiz.com</option>
								  <option value="unitel.co.kr">unitel.co.kr</option>
								  <option value="freechal.com">freechal.com</option>
								  <option value="">���� �Է�</option>
							    </select>
						        <input type='hidden' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>'>
        			            <!--<input type='text' size='42' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='100' class='text'>-->
        			        	&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �ٹ��μ�:
        			        	<input type='text' size='10' name='con_agnt_dept' value='<%=client.getCon_agnt_dept()%>' maxlength='15' class='text'>
        			        	&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> ����:
        			        	<input type='text' size='10' name='con_agnt_title' value='<%=client.getCon_agnt_title()%>' maxlength='10' class='text'>
               	             </td>
               	         </tr>
               	         <tr>
               	             <td class='title'>��ü����</td>
               	             <td colspan="3">&nbsp;���ſ��� : 
					        	<select name='dly_sms'>
               	                 <option value='Y' <%if(client.getDly_sms().equals("Y")||client.getDly_sms().equals("")) out.println("selected");%>>�¶�</option>
               	                 <option value='N' <%if(client.getDly_sms().equals("N")) out.println("selected");%>>�ź�</option>
               	             </select>	
					        	</td>
               	         </tr>	
		                </table>
			        </td>
		        </tr>
    	    </table>
    	</td>
    </tr>	 
    <tr>
        <td colspan='2'>&nbsp;</td>
    </tr>	
<% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	<tr>
		<td colspan='2' align='right'> 
		  <a href="javascript:save()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		  <a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>		
<%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
