<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%

	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ

				
	//��������
	Hashtable res = rs_db.getCarInfo(c_id);	
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
<!--
	//�����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.our_fault_per.value == '' ){ alert('���Ǻ����� Ȯ���ϼ���.'); return; }
		if(fm.p_desc.value == ''){ alert('Ư�̻����� Ȯ���ϼ���.'); return; }
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = 'accid_pre_doc_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	
	
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.our_fault_per.focus()">
<form action="" name="form1" method="post" >
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type="hidden" name="accid_id" value="<%=accid_id%>">


<table border=0 cellspacing=0 cellpadding=0 width=500>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=res.get("CAR_NO")%> ����Ȯ�� ���� </span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
               	<tr>
		          <td width="13%" class='title'>���Ǻ���</td>
		          <td  colspan=3>&nbsp;���:  
                      <input type="text" name="our_fault_per"  size="4" class=num > %                        
		          </td>
		         </tr>
		         <tr> 
		          <td width="13%" class='title'>�Ա���</td>
		         <td>&nbsp;
					<input type="text" name="p_ip_dt"  size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value); dt_chk();' maxlength="10"></td>
		       	<td width="13%" class='title'>�Աݾ�</td>
		         <td>&nbsp;
					<input type="text" name="p_ip_amt"  size="11" class=num  onBlur='javascript:this.value=parseDecimal(this.value); '></td>		         
		        </tr>
		        <tr>
		          <td width="13%" class='title'>Ư�̻���</td>
		          <td colspan=3>&nbsp; 
                    <textarea name="p_desc" cols="65" rows="6"></textarea>
		          </td>
		         </tr>
            </table>
        </td>
    </tr>
 
    <tr> 
        <td align="right"><a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a> 
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
