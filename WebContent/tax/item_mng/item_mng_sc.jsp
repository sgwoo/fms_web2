<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_tax(item_id, idx){
		var fm = document.form1;
		fm.item_id.value = item_id;
		fm.idx.value = idx;
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	int cnt = 0; //��Ȳ ��� ������ �Ѽ�
	//if(cnt > 0 && cnt < 5) cnt = 5; //�⺻ 
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-230;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<form name='form1' action='item_mng_c.jsp' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='item_id' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td height="<%=height%>"><iframe src="item_mng_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td><!--����ͳ��� - sh ���� - ��ܸ޴� ���� - (���μ�*40)-->
    </tr>  
</table>
</form>
</body>
</html>
