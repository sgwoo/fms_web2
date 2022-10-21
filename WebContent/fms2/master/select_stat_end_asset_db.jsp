<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	Vector vt = ad_db.getSelectStatEndAssetDB(save_dt, "stat");
	int vt_size = vt.size();
	
	long sum_cnt = 0;
	long sum_amt[] = new long[17];

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
	  <td colspan="11" align="center">○ 사업용 자동차 자산 평가 (<%=save_dt%> 기준)</td>
	</tr>		
	<tr>
	  <td colspan="11">1) 장부가격 대비 실거래가(사업용자동차)현황</td>
	</tr>		
	<tr>
	  <td rowspan='2' colspan='2' class="title">구분</td>
	  <td rowspan='2' width="60" class="title">등록대수</td>
	  <td colspan='3' class="title">취득가</td>
	  <td colspan='3' class="title">장부가</td>
	  <td colspan='2' class="title">실거래가(추정가격)</td>
	</tr>
	<tr>
	  <td width="120" class="title">차량가격</td>
	  <td width="120" class="title">부대비용</td>
	  <td width="120" class="title">합계</td>
	  <td width="120" class="title">상각누계</td>
	  <td width="120" class="title">잔가</td>
	  <td width="60" class="title">잔가율</td>
	  <td width="120" class="title">경매장예상<br>낙찰가<br>(VAT별도)</td>
	  <td width="60" class="title">잔가율</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
		<%if(i==0){%>
	  <td width="40" rowspan='<%=vt_size%>' class="title">신<br>규<br>등<br>록</td>
	  <%}%>
	  <td width="60" align="center"><%=ht.get("YYYY")%>년</td>
	  <td align="right"><%=ht.get("CNT")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CAR_B_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CAR_C_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CAR_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DEP_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BOOK_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("BOOK_PER")),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SH_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("SH_PER")),2)%></td>
	</tr>
	<%		sum_cnt    = sum_cnt    + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
				sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("CAR_B_AMT")));
				sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("CAR_C_AMT")));
				sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CAR_AMT")));
				sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
				sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("BOOK_AMT")));
				sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("SH_AMT")));
		}%>
	<tr>
	  <td colspan="2" class="title">합계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_cnt)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[4]))/AddUtil.parseFloat(String.valueOf(sum_amt[2]))*100),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[5]))/AddUtil.parseFloat(String.valueOf(sum_amt[2]))*100),2)%></td>
	</tr>
</table>
<p>
<p>
<table border="1" cellspacing="0" cellpadding="0" width=1000>
	<tr>
	  <td colspan="11">2) 부채 대비 매각손익 현황(현재가치기준)</td>
	</tr>		
	<tr>
	  <td rowspan='3' colspan='2' class="title">구분</td>
	  <td colspan='5' class="title">부채현황</td>
	  <td colspan='3' class="title">예상손익현황</td>
	</tr>
	<tr>
	  <td colspan='3' class="title">차입금잔액</td>
	  <td rowspan='2' width="120" class="title">보증금(예치금)</td>
	  <td rowspan='2' width="120" class="title">합계</td>
	  <td colspan='2' class="title">예상낙찰가(VAT별도)</td>
	  <td rowspan='2' width="120" class="title">차액<br>(예상낙찰가-부채합계)</td>
	</tr>
	<tr>
	  <td width="120" class="title">원금</td>
	  <td width="120" class="title">중도상환수수료(1%)</td>
	  <td width="120" class="title">소계</td>
	  <td width="120" class="title">금액</td>
	  <td width="60" class="title">부채대비</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);			
	%>
	<tr>
		<%if(i==0){%>
	  <td width="40" rowspan='<%=vt_size%>' class="title">신<br>규<br>등<br>록</td>
	  <%}%>
	  <td width="60" align="center"><%=ht.get("YYYY")%>년</td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PRN")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_FEE")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PF_SUM")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("GRT_AMT_S")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DEBT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SH_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("SH_DEBT_PER")),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("GAIN_SD_AMT")))%></td>
	</tr>
	<%		
				sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("ALT_PRN")));
				sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("ALT_FEE")));
				sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("ALT_PF_SUM")));
				sum_amt[9] = sum_amt[9] + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S")));
				sum_amt[10] = sum_amt[10] + AddUtil.parseLong(String.valueOf(ht.get("DEBT_AMT")));
				sum_amt[11] = sum_amt[11] + AddUtil.parseLong(String.valueOf(ht.get("GAIN_SD_AMT")));
		}%>
	<tr>
	  <td colspan="2" class="title">합계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[9])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[10])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[5]))/AddUtil.parseFloat(String.valueOf(sum_amt[10]))*100),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[11])%></td>
	</tr>
</table>
<p>
<p>	
<table border="1" cellspacing="0" cellpadding="0" width=1000>
	<tr>
	  <td colspan="10">3) 부채 대비 받을대여료 현황</td>
	</tr>		
	<tr>
	  <td rowspan='3' colspan='2' class="title">구분</td>
	  <td colspan='3' class="title">부채현황</td>
	  <td colspan='4' class="title">예상손익현황</td>
	  <!-- <td rowspan='3' width="100" class="title">비고</td> -->
	</tr>
	<tr>
	  <td colspan='3' class="title">차입금잔액</td>
	  <td colspan='2' class="title">받을대여료<br>(공급가)</td>
	  <td colspan='2' width="100" class="title">차액<br>(받을대여료-부채합계)</td>
	</tr>
	<tr>
	  <td width="100" class="title">원금</td> 
	  <td width="100" class="title">이자</td>
	  <td width="100" class="title">합계</td>
	  <td width="100" class="title">금액</td>
	  <td width="100" class="title">부채대비</td>	  
	  <td width="100" class="title">금액</td>
	  <td width="100" class="title">부채대비</td>	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
	<tr>
		<%if(i==0){%>
	  <td width="40" rowspan='<%=vt_size%>' class="title">신<br>규<br>등<br>록</td>
	  <%}%>
	  <td width="60" align="center"><%=ht.get("YYYY")%>년</td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PRN2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_INT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_AMT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("FEE_EST_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("FEE_DEBT_PER")),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("GAIN_FD_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("GAIN_FD_PER")),2)%></td>
	  <!-- 
	  <%if(i==0){%>
	  <td rowspan='<%=vt_size+1%>'>
	  	1)감가상각기준이 합리적이다.<br><br>
	  	2)기준시점에 자산을 처분할 경우에도 부채 상환에는 우려가 없다.<br><br>
	  	3)받을 대여료 현황 및 채권의 우수성을 감안할 때 유동성에 우려가 없다.<br><br>
	  	4)일시에 모든 계약을 중도해지할 경우에도 해지수익이 추가로 발행함으로 손익은 더 좋아지고 우려할 이유는 없다.
	  </td>
	  <%}%>
	   -->
	</tr>
	<%		
				sum_amt[12] = sum_amt[12] + AddUtil.parseLong(String.valueOf(ht.get("FEE_EST_AMT")));
				sum_amt[13] = sum_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("GAIN_FD_AMT")));
				sum_amt[14] = sum_amt[14] + AddUtil.parseLong(String.valueOf(ht.get("ALT_INT2")));
				sum_amt[15] = sum_amt[15] + AddUtil.parseLong(String.valueOf(ht.get("ALT_AMT2")));
				
		}%>
	<tr>
	  <td colspan="2" class="title">합계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[14])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[15])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[12])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[12]))/AddUtil.parseFloat(String.valueOf(sum_amt[8]))*100),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[13])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[13]))/AddUtil.parseFloat(String.valueOf(sum_amt[8]))*100),2)%></td>
	</tr>
</table>	
<%if(sum_amt[15]==0){

	Vector vt2 = ad_db.getSelectStatEndAssetDB_debt(save_dt);
	int vt_size2 = vt2.size();
%>
<p>
<p>	
<table border="1" cellspacing="0" cellpadding="0" width=1000>
	<tr>
	  <td colspan="7">4) 부채현황</td>
	</tr>		
	<tr>
	  <td rowspan='2' class="title">구분</td>
	  <td colspan='3' class="title">차입금잔액</td>
	  <td colspan='3' class="title">부채현황</td>
	</tr>
	<tr>
	  <td width="150" class="title">원금</td> 
	  <td width="150" class="title">중도상환수수료(1%)</td>
	  <td width="150" class="title">소계</td>
	  <td width="150" class="title">원금</td> 
	  <td width="150" class="title">이자</td>
	  <td width="150" class="title">합계</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht = (Hashtable)vt2.elementAt(i);%>
	<tr>
	  <td width="100" align="center"><%=ht.get("YYYY")%>년</td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PRN")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_FEE")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PF_SUM")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PRN")))%></td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_INT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_AMT")))%></td>	  
	</tr>
	<%		
				sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("ALT_PRN")));
				sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("ALT_FEE")));
				sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("ALT_PF_SUM")));
				sum_amt[14] = sum_amt[14] + AddUtil.parseLong(String.valueOf(ht.get("ALT_INT")));
				sum_amt[15] = sum_amt[15] + AddUtil.parseLong(String.valueOf(ht.get("ALT_AMT")));
				
		}%>
	<tr>
	  <td class="title">합계</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[14])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[15])%></td>	  
	</tr>
</table>	
<%}%>
</form>
</body>
</html>
