<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="p_bean" class="acar.off_anc.PropBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int prop_id = request.getParameter("prop_id")==null?0:Util.parseInt(request.getParameter("prop_id"));
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();

   //���� ä�� ���� �� ����ݾ�	
	p_bean = p_db.getPropBean(prop_id);

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
				
		if ( toInt(parseDigit(fm.e_amt.value)) > 500 ) {	alert('���������� 500���� ������ �����ϴ�. Ȯ���Ͻʽÿ�');	return;	}
	//	if ( toInt(parseDigit(fm.p_amt.value)) > 500000 ) {	alert('�����򰡱ݾ��� 500,000���� ������ �����ϴ�. Ȯ���Ͻʽÿ�');	return;	}
	//	if ( toInt(parseDigit(fm.e_amt.value)) < 1 ) {	alert('���������� 0���� �ο��� �� �����ϴ�. Ȯ���Ͻʽÿ�');	return;	}
	//	if ( toInt(parseDigit(fm.p_amt.value)) < 1 &&  fm.use_yn.value == 'Y') {	alert('�����򰡱ݾ��� 0���� �ο��� �� �����ϴ�. Ȯ���Ͻʽÿ�');	return;	}

		
//		if(confirm('����Ͻðڽ��ϱ�?'))
//		{
										
			fm.target='i_no';
			fm.action='t_eval_i_a.jsp';
			fm.submit();
//		}
	}
	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='prop_id' value='<%=prop_id%>'>
<input type='hidden' name='seq' value='0'>
<input type='hidden' name='re_seq' value='0'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='use_yn' value='<%=p_bean.getUse_yn()%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   

<table border="0" cellspacing="0" cellpadding="0" width=500>

    <tr>
	<!-- 202006���� ����    <td >&nbsp;<font color=red>*&nbsp;</font>���� ���� : 1~100������ �ο�, ���� �򰡱ݾ�:50,000~500,000������ �ο�</td> -->
	    <td >&nbsp;<font color=red>*&nbsp;</font>���� ���� : 1~500������ �ο�</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line' width=500>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="15%"> �������� </td>
                    <td width=28%>&nbsp;<input type='text' name='e_amt' size='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);' ></td>
              <%if(p_bean.getUse_yn().equals("Y") || p_bean.getUse_yn().equals("M")){%>
                    <td class='title' width="15%"> �����򰡱ݾ� </td>
                    <td width=38%>&nbsp;
                    <input type='text' name='p_amt' value = '0' readonly size='12' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);' >��
                     </td>
              <% } else { %>
                	<td class='title' width="15%"></td>
                    <td width=38%>&nbsp;
                    <input type='hidden' name='p_amt' size='12' value = '0' readonly class='num'  onBlur='javascript:this.value=parseDecimal(this.value);' >��
                   	 </td>
                   <% } %>  
           
                </tr>
            </table>
        </td>		
	</tr>
	<tr>
		<td align='right'>
		<%if(p_bean.getJigub_dt().equals("")) {%>
				 <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
		<% } %>	
				&nbsp;<a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
	</tr>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>

</body>
</html>
