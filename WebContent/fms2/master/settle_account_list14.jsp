<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSettleAccount_list14(settle_year);
	int vt_size = vt.size();
	
	
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
	long total_amt4	= 0;
	long total_amt5	= 0;
	long total_amt6	= 0;
	long total_amt7	= 0;
	long total_amt8	= 0;	
	long total_amt9	= 0;
	
	long total_amt[]	 		= new long[2];
	
	

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
	  <td align="center"><%=AddUtil.parseInt(settle_year)%>년 계약 대여료일시납 년도별 금액 (선수대여료스케줄)</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td width="50" rowspan='2' class="title">연번</td>
				  <td width="80" rowspan='2' class="title">거래처코드</td>
				  <td width="330" rowspan='2' class="title">거래처명</td>
				  <td width="100" rowspan='2' class="title">사업자번호</td>
				  <td width="50" rowspan='2' class="title">용도</td>
				  <td width="100" rowspan='2' class="title">차량번호</td>
				  <td width="100" rowspan='2' class="title">계약일자</td>
				  <td width="60" rowspan='2' class="title">연장<br>여부</td>
				  <td width="100" rowspan='2' class="title">대여개시일</td>
				  <td width="100" rowspan='2' class="title">대여만료일</td>
				  <td width="50" rowspan='2' class="title">대여<br>기간</td>
				  <td colspan='2' class="title">계산서발행</td>
				  <td colspan='6' class="title">년도별 대여료일시납(공급가)</td>
			    </tr>
			    <tr>
			      <td width="100" class="title">계산서일자</td>
				  <td width="100" class="title">공급가</td>
				  <td width="100" class="title"><%=AddUtil.parseInt(settle_year+1)%>년</td>
				  <td width="100" class="title"><%=AddUtil.parseInt(settle_year+2)%>년</td>
				  <td width="100" class="title"><%=AddUtil.parseInt(settle_year+3)%>년</td>
				  <td width="100" class="title"><%=AddUtil.parseInt(settle_year+4)%>년</td>
				  <td width="100" class="title"><%=AddUtil.parseInt(settle_year+5)%>년</td>
				  <td width="100" class="title">합계</td>
			    </tr>			    
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					total_amt3	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("REST_AMT")));
					total_amt4	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("AMT_P1")));
					total_amt5	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("AMT_P2")));
					total_amt6	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("AMT_P3")));
					total_amt7	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("AMT_P4")));
					total_amt8	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("AMT_P5")));
					total_amt9	= total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("AMTSUM")));
					
					if( String.valueOf(ht.get("CAR_ST")).equals("렌트")){
						total_amt[0]	= total_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("AMTSUM")));
					}
					if( String.valueOf(ht.get("CAR_ST")).equals("리스")){
						total_amt[1]	= total_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("AMTSUM")));
					}
					
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("VEN_CODE")%></td>
				  <td align="center"><%=ht.get("FIRM_NM")%></td>
				  <td align="center"><%=ht.get("ENP_NO")%></td>
				  <td align="center"><%=ht.get("CAR_ST")%></td>
				  <td align="center"><%=ht.get("CAR_NO")%></td>
				  <td align="center"><%=ht.get("RENT_DT")%></td>
				  <td align="center"><%=ht.get("RENT_ST")%></td>
				  <td align="center"><%=ht.get("RENT_START_DT")%></td>
				  <td align="center"><%=ht.get("RENT_END_DT")%></td>
				  <td align="center"><%=ht.get("CON_MON")%></td>
				  <td align="center"><%=ht.get("EST_DT")%></td>	
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("REST_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT_P1"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT_P2"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT_P3"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT_P4"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT_P5"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMTSUM"))))%></td>
			    </tr>
			    <%	}%>	
			    <tr> 
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>			
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt6)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt7)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt8)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt9)%></td>
			    </tr>		    
			</table>
		</td>
	</tr>
	<tr>
	  <td>&nbsp;(공급가)</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			          <td class="title">구분</td>
				  <td class="title">금액</td>				  
			    </tr>	
			    <tr>
			          <td class="title">렌트</td>
				  <td align="right"><%=Util.parseDecimal(total_amt[0])%></td>				  
			    </tr>	
			    <tr>
			          <td class="title">리스</td>
				  <td align="right"><%=Util.parseDecimal(total_amt[1])%></td>				  
			    </tr>	
			    <tr>
			          <td class="title">합계</td>
				  <td align="right"><%=Util.parseDecimal(total_amt[0]+total_amt[1])%></td>				  
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
