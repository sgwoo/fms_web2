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
	
	
	Vector vt = ad_db.getSettleAccount_list4_2016(settle_year, "rent_l_cd");
	int vt_size = vt.size();
	
	
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
	
	long total_amt[]	 		= new long[10];
	
	

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
	  <td align="center"><%=AddUtil.parseInt(settle_year)%>년 계약보증금리스트</td>
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
			      <td width="50" class="title">연번</td>
				  <td width="80" class="title">거래처코드</td>
				  <td width="330" class="title">거래처명</td>
				  <td width="100" class="title">사업자번호</td>
				  <td width="100" class="title">차량번호</td>
				  <td width="100" class="title">계약일자</td>
				  <td width="60" class="title">연장여부</td>
				  <td width="100" class="title">대여개시일</td>
				  <td width="100" class="title">대여만료일</td>
				  <td width="100" class="title">임의연장만료일</td>
				  <td width="100" class="title">해지일자</td>
				  <td width="110" class="title">보증금액</td>
				  <td width="110" class="title">입금액</td>
				  <td width="100" class="title">차액</td>
				  
				  <td width="100" class="title">만기일자</td>
				  <td width="60" class="title">만기년도</td>
			    </tr>
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					total_amt1	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT")));
					total_amt2	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
					total_amt3	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
					
					for(int j = 0 ; j < 8 ; j++){
						if( AddUtil.parseInt(String.valueOf(ht.get("E_YEAR"))) - AddUtil.parseInt(settle_year) == j ){
							total_amt[j]	= total_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT")));
						}
					}
					
					if( AddUtil.parseInt(String.valueOf(ht.get("E_YEAR"))) == 0 ){
							total_amt[9]	= total_amt[9] + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT")));
					}
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("VEN_CODE")%></td>
				  <td align="center"><%=ht.get("FIRM_NM")%></td>
				  <td align="center"><%=ht.get("ENP_NO")%></td>
				  <td align="center"><%=ht.get("CAR_NO")%></td>
				  <td align="center"><%=ht.get("RENT_DT")%></td>
				  <td align="center"><%=ht.get("RENT_ST")%></td>
				  <td align="center"><%=ht.get("RENT_START_DT")%></td>
				  <td align="center"><%=ht.get("RENT_END_DT")%></td>
				  <td align="center"><%=ht.get("IM_END_DT")%></td>
				  <td align="center"><%=ht.get("CLS_DT")%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT"))))%></td>
				  
				  <td align="center"><%=ht.get("E_DT")%></td>
				  <td align="center"><%=ht.get("E_YEAR")%></td>
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
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
				  <td class="title">&nbsp;</td>			
				  <td class="title">&nbsp;</td>							  
			    </tr>		    
			</table>
		</td>
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
			          <td class="title">상환년도</td>
				  <td class="title">금액</td>				  
			    </tr>	
			    <%for(int j = 0 ; j < 8 ; j++){%>	    
			    <tr>
			          <td class="title"><%=AddUtil.parseInt(settle_year)+j%></td>
				  <td align="right"><%=Util.parseDecimal(total_amt[j])%></td>				  
			    </tr>	
			    <%}%>
			    <tr>
			          <td class="title">미등록/미개시</td>
				  <td align="right"><%=Util.parseDecimal(total_amt[9])%></td>				  
			    </tr>	
			    <tr>
			          <td class="title">합계</td>
				  <td align="right"><%=Util.parseDecimal(total_amt1)%></td>				  
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


