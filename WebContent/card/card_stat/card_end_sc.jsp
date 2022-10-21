<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	int cnt = 0; //현황 출력 영업소 총수
	if(cnt > 0 && cnt < 5) cnt = 5; //기본 
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-210;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='client_mng_c.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='reg_gu' value='1'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td height="<%=height%>"><iframe src="card_end_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td><!--모니터높이 - sh 길이 - 상단메뉴 길이 - (라인수*40)-->
    </tr>  
</table>
</form>
</body>
</html>
