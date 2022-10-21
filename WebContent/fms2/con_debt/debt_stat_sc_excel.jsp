<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*,jxl.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mm		= request.getParameter("mm")==null?"":request.getParameter("mm");
		
	long amt13 = 0;
	long amt15 = 0;
	long total_amt = 0;
	
    Vector debts = ad_db.getDebtSettleList1Detaiil(gubun1, mm); 
	int debt_size = debts.size();
	
	 Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		//System.out.println("현재날짜 : "+ sdf.format(d));
		String filename = sdf.format(d)+"_유동성대체내역.xls";
		filename = java.net.URLEncoder.encode(filename, "UTF-8");
		response.setContentType("application/octer-stream");
		response.setHeader("Content-Transper-Encoding", "binary");
		response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
		response.setHeader("Content-Description", "JSP Generated Data");
	
%>
<form name='form1' method="post">
<input type='hidden' name='allot_size' value='<%=debt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=840>
    <tr> 
      <td class=h><%=gubun1%>/<%=mm%> 유동성 대채 내역</td>
    </tr>
	<tr>
	  <td class='line'>			
        <table border="1" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
			<td width=30  class='title' style='height:38'>연번</td>			
			<td width=150 class='title'>금융사</td>	
			<td width=150 class='title'>대출번호</td>	
			<td width=90  class='title'>차량번호</td>										
			<td width=120 class='title'>계좌번호</td>		
			<td width=100 class='title' style='height:38'>대출일자</td>
			<td width=100 class='title'>상환완료예정일</td>					
			<td width=100 class='title'>대체금액</td>
		  </tr>		
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);

			amt13 = AddUtil.parseLong(String.valueOf(debt.get("AMT13"))); 
			amt15 = AddUtil.parseLong(String.valueOf(debt.get("AMT15")));    
			
			%>
		  <tr>
			<td align='center' width=30><%=i+1%></td>			
			<td align='center' width=150><%=debt.get("CPT_NM")%></td>	
			<td align='center' width=150><%=debt.get("LEND_NO")%></td>		
			<td align='center' width=90><%=debt.get("CAR_NO")%></td>										
			<td align='center' width=120><%=debt.get("DEPOSIT_NO")%></td>				
			<td align='center' width=100><%=debt.get("LEND_DT")%></td>
			<td align='center' width=100><%=debt.get("END_DT")%></td>	
			<td align='right' width=100><%=AddUtil.parseDecimalLong(amt13+amt15)%></td>
			
		  </tr>					
<%		total_amt   = total_amt   + (amt13 + amt15);
					
		}%>
          <tr> 
			<td colspan="7" class="title">합계</td>					
			<td class="title" style='text-align:right'><%=total_amt%></td>
		
		  </tr>		
		</table>
		</td>
	</tr>		
</table>
</form>
</body>
</html>