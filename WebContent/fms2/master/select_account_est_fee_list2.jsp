<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String fee_end_dt 	= request.getParameter("fee_end_dt")==null?"":request.getParameter("fee_end_dt");
	
//	AdminDatabase ad_db = AdminDatabase.getInstance();
	
	Vector vt = ad_db.getSelectAccountEstFeeList_20120130(fee_end_dt);
	int vt_size = vt.size();
	
	long sum = 0;
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
						
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='cont_end_dt' value='<%=fee_end_dt%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=1250>
	<tr>
	  <td colspan="13" align="center"><%=fee_end_dt%> 대여료 입금/예정 스케줄</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td colspan="11">&nbsp;</td>
	  <td>&nbsp;</td>
	</tr>		
	<tr>
	  <td width="50" rowspan="3" class="title">일자</td>
	  <td colspan="4" class="title">합계</td>
	  <td colspan="4" class="title">CMS</td>
	  <td colspan="4" class="title">CMS외기타</td>
	</tr>
	<tr>
	  <td rowspan="2" class="title">전전월</td>
      <td rowspan="2" class="title">전월</td>
      <td colspan="2" class="title">당월</td>
	  <td rowspan="2" class="title">전전월</td>
      <td rowspan="2" class="title">전월</td>
      <td colspan="2" class="title">당월</td>
	  <td rowspan="2" class="title">전전월</td>
      <td rowspan="2" class="title">전월</td>
      <td colspan="2" class="title">당월</td>
	</tr>
	<tr>
	  <td class="title">예정</td>
      <td class="title">입금</td>
	  <td class="title">예정</td>
      <td class="title">입금</td>
	  <td class="title">예정</td>
      <td class="title">입금</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td class="title"><%=ht.get("일자")%></td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("전전월")))%>	</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("전월")))%>		</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("당월예정")))%>	</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("당월")))%>		</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("전전월_CMS")))%>	</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("전월_CMS")))%>	</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("당월예정_CMS")))%></td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("당월_CMS")))%>	</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("전전월_기타")))%>	</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("전월_기타")))%>	</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("당월예정_기타")))%>	</td>
	  <td width="100" align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("당월_기타")))%>	</td>
	</tr>
	<%		//sum  = sum  + Util.parseLong(String.valueOf(ht.get("월대여료")));
		}%>
	<!--	
	<tr>
	  <td colspan="3" class="title">합계</td>	  
	  <td align="right"><%//=Util.parseDecimal(sum)%></td>
	  <td>&nbsp;</td>	  
	</tr>
	-->
	<tr>
	  <td colspan="13">* CMS는 당사에 실제 입금되는 일자 기준</td>
	</tr>	
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
