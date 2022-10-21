<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.watch.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_ars_call_stat_base_excel_pl.xls");
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<style type="text/css">
<!--
.style2 {font-size: 9px}
-->
</style>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
	WatchDatabase wc_db = WatchDatabase.getInstance();

	String var1 = request.getParameter("var1")==null?"":request.getParameter("var1");
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");
	String var3 = request.getParameter("var3")==null?"":request.getParameter("var3");
	
	String base_call_amt = request.getParameter("base_call_amt")==null?"":request.getParameter("base_call_amt");
	String base_call_amt2 = request.getParameter("base_call_amt2")==null?"":request.getParameter("base_call_amt2");
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");

	//ARS call 현황
	Vector vt = wc_db.ArsCallStatBase(s_yy, s_mm, sort);
	int vt_size = vt.size();
	
	//20220907 근무기간별 구간 수당 반영
	

	//금액입력
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		//미지급분만 계산 
		if(String.valueOf(ht.get("PAY_DT")).equals("")){
			//통화량수당
			int flag1 = wc_db.UpdateArsCallAmt(String.valueOf(ht.get("USER_ID")),String.valueOf(ht.get("USER_NM")),String.valueOf(ht.get("DOC_DT")),base_call_amt);
			//근무구간수당
			int flag2 = wc_db.UpdateArsCallAmt2(String.valueOf(ht.get("USER_ID")),String.valueOf(ht.get("DOC_DT")),String.valueOf(ht.get("CALL_DT")),String.valueOf(ht.get("SECTION")),base_call_amt2);
			//합산
			int flag3 = wc_db.UpdateArsCallAmtSum(String.valueOf(ht.get("DOC_DT")));
		}
	}
	
	//ARS call 현황
	vt = wc_db.ArsCallStatBase(s_yy, s_mm, sort);
	vt_size = vt.size();
	
	long total_amt1 = 0;
	
%>
<table border="0" cellspacing="0" cellpadding="0" width='600'>
	<tr>
		<td>
			<table border="1" cellspacing="1" cellpadding="0">
				<tr align="center" bgcolor="#FFFF00">
					<td width='50'>은행코드</td>
			        <td width='150'>계좌번호</td>
			        <td width='100'>입금인성명</td>
			        <td width='100'>입금액</td>										
			        <td width='100'>출금통장표시</td>
			        <td width='100'>입금통장표시</td>
			    </tr>
                <%	for (int i = 0 ; i < vt_size ; i++){
		           		Hashtable ht = (Hashtable)vt.elementAt(i);
		           		total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CALL_AMT")));
				%>
				<tr>
                    <td align=center><%=ht.get("CMS_BK")%></td>
                    <td align=center><%=ht.get("BANK_NO")%></td>
                    <td align=center><%=ht.get("USER_NM")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CALL_AMT")))%></td>
                    <td align=center>당직비</td>
                    <td align=center>당직비</td>
				</tr>
				<%	}%>
                <tr>
                    <td colspan="3" class='title'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td colspan="2" class='title'> </td>
                </tr>		      				
			</table>
		</td>
	</tr>
</table>
</body>
</html>

