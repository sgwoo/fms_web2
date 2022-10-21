<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//신규영업 중단하고 대여사업 계속시 CASH FLOW(종합)
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String s_unit 	= request.getParameter("s_unit")==null?"":request.getParameter("s_unit");
	
	Vector vt = ad_db.getSelectStatEndCont19ListDB(save_dt);
	int vt_size = vt.size();
	
	long sum_amt[] = new long[23];
	long h_sum_amt[] = new long[23];
	
	long d_amt = 0;

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
<table border="1" cellspacing="0" cellpadding="0" width=1760>
	<tr>
	  <td colspan="23" align="center">○ 신규영업 중단하고 대여사업 계속시 CASH FLOW(종합)</td>
	</tr>		
	<tr>
	  <td colspan="23" align="right">단위:백만원, 기준일자(<%=save_dt%>)</td>
	</tr>			
	<tr>
	  <td rowspan='3' width="80" class="title">구분</td>
	  <td colspan='4' class="title">사업용자동차 보유대수</td>
	  <td rowspan='3' width="80" class="title">월말잔액</td>
	  <td rowspan='3' width="80" class="title">순유입<br>(유입-유출)</td>
	  <td colspan='3' class="title">현금유입</td>
	  <td colspan='12' class="title">현금유출</td>
	</tr>
	<tr>
	  <td rowspan='2' width="80" class="title">상환중</td>
	  <td rowspan='2' width="80" class="title">상환완료</td>
	  <td rowspan='2' width="80" class="title">비차입</td>
	  <td rowspan='2' width="80" class="title">합계</td>
	  
	  <td width="80" class="title">수입</td>
	  <td width="80" class="title">자산매각</td>	  	 
	  <!-- <td width="80" class="title">장부가액</td> -->
	  <td rowspan='2' width="80" class="title">합계</td>
	  
	  <td colspan='3' class="title">부채상환</td>
	  <td width="80" class="title">자산변동</td>
	  <td colspan='6'  class="title">비용</td>
	  <td rowspan='2' width="80" class="title">인건비 및<br>관리비</td>	  
	  <td rowspan='2' width="80" class="title">합계</td>
	</tr>
	<tr>
	  <td width="80" class="title">월대여료</td>
	  <td width="80" class="title">차량매각</td>
	  <!-- <td width="80" class="title">(참고)</td> -->
	  <td width="80" class="title">대출금<br>(원금+이자)</td>
	  <td width="80" class="title">보증금</td>
	  <td width="80" class="title">소계</td>
	  <td width="80" class="title">개소세환입</td>
	  <td width="80" class="title">자동차세</td>
	  <td width="80" class="title">종합보험료</td>
	  <td width="80" class="title">자차보험료</td>
	  <td width="80" class="title">일반식<br>정비비</td>
	  <td width="80" class="title">자동차<br>검사비용</td>
	  <td width="80" class="title">소계</td>
	</tr>	
	<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	
				
				long c_amt = AddUtil.parseLong(String.valueOf(ht.get("A_AMT"))) - AddUtil.parseLong(String.valueOf(ht.get("B_AMT")));
				
				d_amt = d_amt + c_amt;
	%>
	<tr>
	  <td align="center"><%=ht.get("CASH_YM")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DEBT_ST1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DEBT_ST2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DEBT_ST3")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(d_amt)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(c_amt)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_FEE_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_SUI_AMT")))%></td>
	  <!-- <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_BOOK_AMT")))%></td> -->
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("PRN_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_GRT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("E_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("F_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_TAX_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_INS_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_INS_AMT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_SERV_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_MAINT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("G_AMT")))%></td>
	  <td align="right"><%//=AddUtil.parseDecimalLong(String.valueOf(ht.get("GONG4")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("B_AMT")))%></td>
	</tr>
	<%			
					sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("DEBT_ST1")));
					sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("DEBT_ST2")));
					sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("DEBT_ST3")));
					sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
					//sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("D_AMT")));
					sum_amt[5] = sum_amt[5] + c_amt;
					sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("M_FEE_AMT")));
					sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("M_SUI_AMT")));					
					sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("A_AMT")));
					sum_amt[9] = sum_amt[9] + AddUtil.parseLong(String.valueOf(ht.get("PRN_AMT")));
					sum_amt[10] = sum_amt[10] + AddUtil.parseLong(String.valueOf(ht.get("M_GRT_AMT")));													
					sum_amt[11] = sum_amt[11] + AddUtil.parseLong(String.valueOf(ht.get("E_AMT")));
					sum_amt[12] = sum_amt[12] + AddUtil.parseLong(String.valueOf(ht.get("F_AMT")));
					sum_amt[13] = sum_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("M_TAX_AMT")));
					sum_amt[14] = sum_amt[14] + AddUtil.parseLong(String.valueOf(ht.get("M_INS_AMT")));
					sum_amt[15] = sum_amt[15] + AddUtil.parseLong(String.valueOf(ht.get("M_INS_AMT2")));
					sum_amt[16] = sum_amt[16] + AddUtil.parseLong(String.valueOf(ht.get("M_SERV_AMT")));
					sum_amt[17] = sum_amt[17] + AddUtil.parseLong(String.valueOf(ht.get("M_MAINT_AMT")));
					sum_amt[18] = sum_amt[18] + AddUtil.parseLong(String.valueOf(ht.get("G_AMT")));
					sum_amt[19] = sum_amt[19] + AddUtil.parseLong(String.valueOf(ht.get("GONG4")));
					sum_amt[20] = sum_amt[20] + AddUtil.parseLong(String.valueOf(ht.get("B_AMT")));							
					sum_amt[21] = sum_amt[21] + AddUtil.parseLong(String.valueOf(ht.get("M_BOOK_AMT")));
					
			}
	%>	
	<tr>
	  <td class="title">합계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(d_amt)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <!-- <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[21])%></td> -->
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[9])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[10])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[11])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[12])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[13])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[14])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[15])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[16])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[17])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[18])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[19])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[20])%></td>
	</tr>
		
</table>
</form>
</body>
</html>
