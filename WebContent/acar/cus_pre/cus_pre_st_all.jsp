<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_mng.*"%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"6":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;	
		if(fm.save_dt.value != ''){ alert("�̹� ���� ��ϵ� ����� ������Ȳ�Դϴ�."); return; }		
		var i_fm = i_view.form1;
		i_view.save();		
/*		if(i_fm.save_dt.value != ''){ alert("�̹� ���� ��ϵ� �ڵ���������Ȳ�Դϴ�."); return; }
		if(!confirm('�����Ͻðڽ��ϱ�?'))
			return;
		i_fm.target='i_no';
		i_fm.submit();		
*/		
	}	

	//������ȸ
	function TodaySearch(today){
		var fm = document.form1;	
		var i_fm = i_view.form1;
		fm.view_dt.value = today;
		fm.save_dt.value = '';		
		i_fm.save_dt.value = '';
		i_fm.target='i_view';
		i_fm.action='stat_mng_sc_in_view.jsp';		
		i_fm.submit();				
	}
	
	function OpenHelp(){
		var fm = document.form1;		
		var SUBWIN = "stat_mng_help.jsp?auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&br_id="+fm.br_id.value+"&save_dt="+fm.save_dt.value;
		window.open(SUBWIN, "Help", "left=100, top=100, width=600, height=500, scrollbars=yes");
	}	
//-->
</script>
</head>
<body>

<form action="/serv/stat_car/stat_mng_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='6'>
<input type='hidden' name='user_id' value='000029'>
<input type='hidden' name='br_id' value='S1'>
<input type='hidden' name='save_dt' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width="820">
    <tr> 
      <td width="180"><font color="navy">������-> </font><font color="red">������Ȳ(��ü)</font></td>
      <td align="right" colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2">������Ȳ<a href="cus_pre_st_day.jsp" target="i_view">(����)</a> ||
	   ����,�Ⱓ,�����Ⱓ ��Ȳ<a href="cus_pre_st_month.jsp" target="i_view">(���)</a> || 
	   ����,������� ��Ȳ<a href="cus_pre_st_year.jsp" target="i_view">(����)</a></td>
      <td align="right" width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><iframe src="./cus_pre_st_day.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>&br_id=<%= br_id %>&save_dt=" name="i_view" width="100%" height="530" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
      </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
