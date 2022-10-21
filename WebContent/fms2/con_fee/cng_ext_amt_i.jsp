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
		if(fm.t_fee_s_amt_c.value == '' || fm.t_fee_s_amt_c.value == 0)	{	alert('����뿩�� ���ް��� �Է��Ͻʽÿ�');	return;	}
		if(fm.t_fee_v_amt_c.value == '' || fm.t_fee_v_amt_c.value == 0)	{	alert('����뿩�� ���ް��� �Է��Ͻʽÿ�');	return;	}				
		if(fm.t_pay_cng_cau.value == ''){ alert("��������� �Է��Ͻʽÿ�"); return; }
		fm.target = 'i_no';
		fm.submit();
	}

	function cal_sv_amt()
	{
		var fm = document.form1;
		if(parseDigit(fm.t_fee_amt.value).length > 8)
		{	alert('���뿩�Ḧ Ȯ���Ͻʽÿ�');	return;	}
		fm.t_fee_amt.value = parseDecimal(fm.t_fee_amt.value);
		fm.t_fee_s_amt.value = parseDecimal(sup_amt(parseDigit(fm.t_fee_amt.value)));
		fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_amt.value)) - toInt(parseDigit(fm.t_fee_s_amt.value)));
	}
	
	function change_fee(obj){
		var fm = document.form1;
		obj.value = parseDecimal(obj.value);
		if(obj==fm.t_fee_s_amt_c){ //���� ���ް�		
			fm.t_fee_v_amt_c.value = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt_c.value)) * 0.1 );
		}else if(obj==fm.t_fee_v_amt_c){ //���� �ΰ���
			fm.t_fee_s_amt_c.value = parseDecimal(toInt(parseDigit(fm.t_fee_v_amt_c.value)) / 0.1 );
		}
	}
-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onload="javascript:document.form1.t_fee_s_amt_c.focus();">
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String prv_mon_yn = request.getParameter("prv_mon_yn")==null?"":request.getParameter("prv_mon_yn");//����������Ⱓ���Կ���
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String fee_amt = request.getParameter("fee_amt")==null?"":request.getParameter("fee_amt");
	
	Vector tms = f_db.getFeeScdTm(m_id);
	int tm_size = tms.size();
%>

<form name='form1' action='cng_ext_amt_i_a.jsp' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='t_fee_amt' value='<%=fee_amt%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='prv_mon_yn' value='<%=prv_mon_yn%>'>
<table border="0" cellspacing="0" cellpadding="0" width=300>
	<tr>		
      <td align='left'><<�뿩�ắ��>></td>
	</tr>
	<tr>
		<td class='line'>			 
        <table border="0" cellspacing="1" cellpadding="0" width=380>
          <tr> 
            <td class='title' width="60">����ȸ�� </td>
            <td colspan="4">&nbsp; 
              <%if(tm_size > 0){%>
              <select name='s_fee_tm'>
                <%for(int i = 0 ; i < tm_size ; i++){
					Hashtable tm = (Hashtable)tms.elementAt(i);%>
                <option value='<%=tm.get("FEE_TM")%>'><%=tm.get("FEE_TM")%></option>
                <%}%>
              </select>
              ȸ&nbsp;&nbsp;(����ȸ������ ��� ����) 
              <%}else{%>
              ���ð����� ȸ���� �����ϴ�. 
              <%}%>
            </td>
          </tr>
          <tr> 
            <td class='title' width="60" height="27">������</td>
            <td class='result' width="60" align="center">���ް�</td>
            <td align="right"> 
              <input type='text' name='t_fee_s_amt' size='9' value='' class='whitenum' readonly>
              ��&nbsp;</td>
            <td class='result' width="60" align="center">�ΰ���</td>
            <td align="right"> 
              <input type='text' name='t_fee_v_amt' size='9' value='' class='whitenum' readonly>
              ��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' width="60">������</td>
            <td class='result' width="60" align="center">���ް�</td>
            <td align="right"> 
              <input type='text' name='t_fee_s_amt_c' size='9' value='' class='num' onBlur='javascript:change_fee(this)'>
              ��&nbsp;</td>
            <td class='result' width="60" align="center">�ΰ���</td>
            <td align="right"> 
              <input type='text' name='t_fee_v_amt_c' size='9' value='' class='num'>
              ��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' width="60">�������</td>
            <td colspan="4">&nbsp; 
              <textarea name='t_pay_cng_cau' cols='35' maxlength='255'></textarea>
            </td>
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
<script language='javascript'>
<!--
	cal_sv_amt();
-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>