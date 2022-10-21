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
	
	
	Vector vt = ad_db.getSettleAccount_list2(settle_year);
	int vt_size = vt.size();
	
	
	long total_amt1	= 0;
	long total_amt2 = 0;	
	long total_amt3	= 0;
	long total_amt4 = 0;	
	long total_amt5 = 0;	
	long total_amt6 = 0;
	

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
	  <td colspan="5" align="center"><%=AddUtil.parseInt(settle_year)+1%>년1월 지급(예정) 할부금 리스트</td>
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
			      <td width="100" class="title">금융사</td>			      
			      <td width="50" class="title">이자율</td>
			      <td width="50" class="title">회차</td>
				  <td width="100" class="title">지급예정일<br>한달전</td>
				  <td width="100" class="title">지급예정일</td>
				  <td width="100" class="title">원금</td>
				  <td width="100" class="title">이자</td>
				  <td width="100" class="title">월할부금</td>
				  <td width="100" class="title">잔액</td>
				  <td width="100" class="title">12월이자분</td>
				  <td width="50" class="title">일수</td>
				  <td width="100" class="title">12월<br>해당일수</td>
				  <td width="100" class="title">중도상환일</td>
			    </tr>
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					total_amt1	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("ALT_PRN")));
					total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("ALT_INT")));
					total_amt3	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("ALT_AMT")));
					total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("ALT_REST")));
					total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(!String.valueOf(ht.get("CLS_RTN_DT")).equals("")){
						total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("ALT_REST")));
					}
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("RENT_L_CD")%> <%=ht.get("RTN_SEQ")%></td>
				  <td align="center"><%=ht.get("CPT_NM")%></td>
				  <td align="center"><%=ht.get("LEND_INT")%></td>
				  <td align="center"><%=ht.get("ALT_TM")%></td>
				  <td align="center"><%=ht.get("S_DT")%></td>
				  <td align="center"><%=ht.get("ALT_EST_DT")%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ALT_PRN"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ALT_INT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ALT_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ALT_REST"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT"))))%></td>
				  <td align="center"><%=ht.get("DAYS1")%></td>	  
				  <td align="center"><%=ht.get("DAYS2")%></td>	  
				  <td align="center"><%=ht.get("CLS_RTN_DT")%></td>
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
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
				  <td class="title">&nbsp;</td>			
				  <%if(ck_acar_id.equals("000029")){ %>
				  <td class="title">중도상환잔액:</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt6)%></td>
				  <%}else{ %>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <%} %>
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
