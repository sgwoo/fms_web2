<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=select_stat_end_cont_fee_list_db_e.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	Vector vt = ad_db.getSelectStatEndContFeeListDB(save_dt);
	int vt_size = vt.size();
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
  <table border="1" cellspacing="0" cellpadding="0" width=1450>
	<tr>
	  <td colspan="16" align="center"><%=save_dt%> 계약현황</td>
	</tr>		
	<tr>
	  <td colspan="15">&nbsp;</td>
	  <td>(공급가기준)</td>
	</tr>		
	<tr>
	  <td width="50" class="title">연번</td>
	  <td width="100" class="title">챠랑번호</td>
	  <td width="100" class="title">차명</td>
	  <td width="100" class="title">최초등록일</td>
	  <td width="100" class="title">용도구분</td>
	  <td width="100" class="title">계약구분</td>
	  <td width="100" class="title">차량구분</td>
	  <td width="100" class="title">고객상호</td>
	  <td width="100" class="title">약정보증금</td>
	  <td width="100" class="title">약정선납금</td>
	  <td width="100" class="title">약정개시대여료</td>
	  <td width="100" class="title">약정월대여료</td>
	  <td width="100" class="title">약정기간</td>
	  <td width="100" class="title">대여개시일</td>
	  <td width="100" class="title">대여만료일</td>	  
	  <td width="100" class="title">최종스케줄</td>	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align="center"><%=ht.get("INIT_REG_DT")%></td>
	  <td align="center"><%=ht.get("CAR_USE")%></td>
	  <td align="center"><%=ht.get("RENT_ST")%></td>
	  <td align="center"><%=ht.get("CAR_ST")%></td>
	  <td align="center"><%=ht.get("FIRM_NM")%></td>	  
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("D_GRT_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("PP_S_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("IFEE_S_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%></td>
	  <td align="center"><%=ht.get("CON_MON")%></td>
	  <td align="center"><%=ht.get("RENT_START_DT")%></td>
	  <td align="center"><%=ht.get("RENT_END_DT")%></td>
	  <td align="center"><%=ht.get("SCD_END_DT")%></td>  
	</tr>
	<%		
		}%>
  </table>
</form>
</body>
</html>
