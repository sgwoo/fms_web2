<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=settle_account_list_excel3.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSettleAccount_list3(settle_year);
	int vt_size = vt.size();
	
	
	long total_amt1	= 0;
	long total_amt2 = 0;	
	long total_amt3	= 0;
	long total_amt4 = 0;	
	long total_amt5 = 0;	
	long total_amt6	= 0;
	long total_amt7 = 0;	
	long total_amt8	= 0;
	long total_amt9 = 0;	
	long total_amt10 = 0;	
	long total_amt11 = 0;	
	long total_amt12 = 0;	
	

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
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td colspan="5" align="center"><%=AddUtil.parseInt(settle_year)%>년 영업사원수당 지급현황</td>
	</tr>		
	<tr>
	  <td colspan="5">&nbsp;</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td width="50" class="title">연번</td>
				  <td width="100" class="title">계약번호</td>
				  <td width="200" class="title">성명</td>
				  <td width="100" class="title">지급일자</td>
				  <td width="100" class="title">기준차가</td>
				  <td width="80" class="title">수당율</td>
				  <td width="100" class="title">영업수당</td>
				  <td width="100" class="title">출고보전수당</td>
				  <td width="100" class="title">실적이관수당</td>
				  <td width="100" class="title">업무진행수당</td>
				  <td width="100" class="title">세전가감액</td>
				  <td width="100" class="title">소계</td>
				  <td width="80" class="title">세율</td>
				  <td width="80" class="title">소득세</td>
				  <td width="80" class="title">지방소득세</td>
				  <td width="80" class="title">소계</td>
				  <td width="100" class="title">세후가감액</td>
				  <td width="100" class="title">실지급액</td>
			    </tr>
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					total_amt1	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("COMMI_CAR_AMT")));
					total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("COMMI")));
					total_amt3	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("DLV_CON_COMMI")));
					total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("DLV_TNS_COMMI")));
					total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("AGENT_COMMI")));
					total_amt6	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("ADD_AMT_A")));
					total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("A_AMT")));
					total_amt8	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("INC_AMT")));
					total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("RES_AMT")));
					total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
					total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("B_AMT")));
					total_amt12 	= total_amt12 + AddUtil.parseLong(String.valueOf(ht.get("DIF_AMT")));
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("RENT_L_CD")%></td>
				  <td align="center"><%=ht.get("EMP_ACC_NM")%></td>
				  <td align="center"><%=ht.get("SUP_DT")%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("COMMI_CAR_AMT"))))%></td>
				  <td align="center"><%=ht.get("COMM_R_RT")%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("COMMI"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("DLV_CON_COMMI"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("DLV_TNS_COMMI"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AGENT_COMMI"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ADD_AMT_A"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("A_AMT"))))%></td>
				  <td align="center"><%=ht.get("TOT_PER")%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("INC_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("RES_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("B_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("DIF_AMT"))))%></td>
			    </tr>
			    <%	}%>	
			    <tr> 
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>			
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
				  <td class="title">&nbsp;</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt6)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt7)%></td>
				  <td class="title">&nbsp;</td>			
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt8)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt9)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt10)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt11)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt12)%></td>
				  
			    </tr>		    
			</table>
		</td>
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


