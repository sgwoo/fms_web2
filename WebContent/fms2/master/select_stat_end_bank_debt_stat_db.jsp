<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	Vector vt = ad_db.getSelectStatEndBankDebtStatDB(save_dt);
	int vt_size = vt.size();
	
	long sum_amt[] = new long[10];
	long h_sum_amt[] = new long[10];

	int rowspan_cnt1 = 0;
	int rowspan_cnt2 = 0;
	int rowspan_cnt3 = 0;
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		if(String.valueOf(ht.get("ETC")).equals("1")) rowspan_cnt1++;
		if(String.valueOf(ht.get("ETC")).equals("2")) rowspan_cnt2++;
		if(String.valueOf(ht.get("ETC")).equals("3")) rowspan_cnt3++;
	}
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
<table border="1" cellspacing="0" cellpadding="0" width=1000>
	<tr>
	  <td colspan="12" align="center">○ 금융사별차입금세부현항</td>
	</tr>		
	<tr>
	  <td colspan="12" align="right">단위:백만원, 기준일자(<%=save_dt%>)</td>
	</tr>			
	<tr>
	  <td rowspan='2' colspan='3' class="title">구분</td>
	  <td colspan='3' class="title">사업용자동차(대수) 차입금 현황</td>
	  <td colspan='3' class="title">잔가(경매장 시세 기준)</td>
	  <td colspan='3' class="title">차입금 대비 대여료(잔액기준)</td>
	</tr>
	<tr>
	  <td width="80" class="title">상환중</td>
	  <td width="80" class="title">상환완료</td>
	  <td width="80" class="title">합계</td>
	  <td width="80" class="title">상환중</td>
	  <td width="80" class="title">상환완료</td>
	  <td width="80" class="title">합계</td>
	  <td width="80" class="title">대여료</td>
	  <td width="80" class="title">차입금</td>
	  <td width="80" class="title">차액</td>
	</tr>
	<%	int etc_count = 0;
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(String.valueOf(ht.get("ETC")).equals("1")){
					etc_count++;
	%>
	<tr>
		<%if(etc_count==1){%>
	  <td width="40" rowspan='<%=rowspan_cnt1+1%>' class="title">은<br>행</td>
	  <%}%>
	  <td width="40" align="center"><%=etc_count%></td>
	  <td width="200" align="center"><%=ht.get("NM")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("OVER_MON_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CHA_AMT")))%></td>
	</tr>
	<%			
					sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("CNT1")));
					sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("CNT2")));
					sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
					sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("OVER_MON_AMT")));
					sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("CHA_AMT")));
				}
			}
	%>
	<tr>
	  <td colspan="2" class="title">소계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	</tr>
	<%
			for(int i = 0 ; i < 9 ; i++){
				h_sum_amt[i] = h_sum_amt[i] + sum_amt[i];
				sum_amt[i]   = 0;
			}
	%>
	<%	etc_count = 0;
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(String.valueOf(ht.get("ETC")).equals("2")){
					etc_count++;
	%>
	<tr>
		<%if(etc_count==1){%>
	  <td width="40" rowspan='<%=rowspan_cnt2+1%>' class="title">저<br>축<br>은<br>행</td>
	  <%}%>
	  <td width="40" align="center"><%=etc_count%></td>
	  <td width="200" align="center"><%=ht.get("NM")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("OVER_MON_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CHA_AMT")))%></td>
	</tr>
	<%			sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("CNT1")));
					sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("CNT2")));
					sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
					sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("OVER_MON_AMT")));
					sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("CHA_AMT")));
				}
			}
	%>
	<tr>
	  <td colspan="2" class="title">소계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	</tr>	
	<%
			for(int i = 0 ; i < 9 ; i++){
				h_sum_amt[i] = h_sum_amt[i] + sum_amt[i];
				sum_amt[i]   = 0;
			}
	%>	
	<%	etc_count = 0;
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(String.valueOf(ht.get("ETC")).equals("3")){
					etc_count++;
	%>
	<tr>
		<%if(etc_count==1){%>
	  <td width="40" rowspan='<%=rowspan_cnt3+1%>' class="title">여<br>신<br>전<br>문<br>금<br>융<br>기<br>관</td>
	  <%}%>
	  <td width="40" align="center"><%=etc_count%></td>
	  <td width="200" align="center"><%=ht.get("NM")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("OVER_MON_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CHA_AMT")))%></td>
	</tr>
	<%			sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("CNT1")));
					sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("CNT2")));
					sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
					sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("OVER_MON_AMT")));
					sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("CHA_AMT")));
				}
			}
	%>
	<tr>
	  <td colspan="2" class="title">소계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	</tr>	
	<%
			for(int i = 0 ; i < 9 ; i++){
				h_sum_amt[i] = h_sum_amt[i] + sum_amt[i];
				sum_amt[i]   = 0;
			}
	%>		
	<tr>
	  <td colspan="3" class="title">합계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[8])%></td>
	</tr>		
	<%	etc_count = 0;
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(String.valueOf(ht.get("ETC")).equals("")){
	%>
	<tr>
	  <td colspan='3' class="title">비차입</td>
	  <td align="right"></td>
	  <td align="right"></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
	  <td align="right"></td>
	  <td align="right"></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
	  <td align="right"></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CHA_AMT")))%></td>
	</tr>
	<%			sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
					sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("CHA_AMT")));
				}
			}
	%>
	<%
			for(int i = 0 ; i < 9 ; i++){
				h_sum_amt[i] = h_sum_amt[i] + sum_amt[i];
			}
	%>			
	<tr>
	  <td colspan="3" class="title">총계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[8])%></td>
	</tr>		
</table>
</form>
</body>
</html>
