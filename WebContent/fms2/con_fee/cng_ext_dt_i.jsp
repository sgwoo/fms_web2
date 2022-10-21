<%@ page language="java" import="java.util.*, acar.fee.*, acar.cont.*" contentType="text/html;charset=euc-kr"%>
<jsp:useBean id="f_db" scope="page" class="acar.fee.FeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
		if((fm.t_fee_est_dt.value == '')|| !isDate(fm.t_fee_est_dt.value))	{	alert('�Աݿ������� Ȯ���Ͻʽÿ�');		return;	}
		if((fm.t_pay_cng_cau.value == '')){		alert('��������� Ȯ���Ͻʽÿ�');		return;	}		
		if(fm.c_all.checked == true)
			fm.h_all.value = 'Y';
		else
			fm.h_all.value = 'N';

		fm.target = 'i_no';
		//fm.target = 'about:blank';
		fm.submit();
	}

-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String prv_mon_yn = request.getParameter("prv_mon_yn")==null?"":request.getParameter("prv_mon_yn");//����������Ⱓ���Կ���
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	Vector tms = f_db.getFeeScdTm(m_id);
	int tm_size = tms.size();
%>

<form name='form1' action='/fms2/con_fee/cng_ext_dt_i_a.jsp' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='prv_mon_yn' value='<%=prv_mon_yn%>'>
<input type='hidden' name='h_all' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=300>
	<tr>
		<td align='left'><<�Աݿ����Ϻ���>></td>
	</tr>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=300>
				<tr>
					<td class='title'>����ȸ�� </td>
					<td>&nbsp;
					<%	if(tm_size > 0){%>
						<select name='s_fee_tm'>
					<%		for(int i = 0 ; i < tm_size ; i++){
								Hashtable tm = (Hashtable)tms.elementAt(i);%>
							<option value='<%=tm.get("FEE_TM")%>'><%=tm.get("FEE_TM")%></option>
					<%		}%>
						</select> ȸ
					<%	}else{%>
						���ð����� ȸ���� �����ϴ�.
					<%	}%>		
						&nbsp;<input type='checkbox' name='c_all'>����ȸ������ ��� ����</td>
				</tr>
				<tr>
					<td class='title'>�������� </td>
					<td>&nbsp;<input type='text' name='t_fee_est_dt' size='12' maxlength='12' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
				</tr>
				<tr>
					<td class='title'>������� </td>
					<td>&nbsp;<textarea name='t_pay_cng_cau' cols='35' maxlength='255'></textarea> </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'><a href="javascript:save()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
			&nbsp;&nbsp;<a href="javascript:window.close()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>