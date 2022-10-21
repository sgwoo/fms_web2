<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
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
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	
	Vector debts = ad_db.getDebtSettleEstIntList(gubun1, gubun2, gubun3, gubun4, s_kd, t_wd, sort_gubun, asc);
	int debt_size = debts.size();
%>
<form name='form1' action='' method="post">
<input type='hidden' name='size' value='<%=debt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=1550>
	<tr> 
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1><span class=style5><%=gubun2%>년 이후 상환예정 유동성부채현황 (원금+이자)</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>            
      </td>
    </tr>
    <tr> 
      <td class=h></td>
    </tr>
	<tr>
	  <td class='line'>			
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
			<td width=30 rowspan="2" class='title' style='height:38'>연번</td>
			<td width=50 rowspan="2" class='title'>구분</td>		
			<td width=110 rowspan="2" class='title'>금융사</td>
			<td width=50 rowspan="2" class='title'>이자율</td>								
			<td width=100 rowspan="2" class='title'>거래처코드</td>											
			<td width=100 rowspan="2" class='title'>계약번호</td>			
			<td width=120 rowspan="2" class='title'>계좌번호</td>
			<td width=90 rowspan="2" class='title'>차량번호</td>
			<td width=100 rowspan="2" class='title' style='height:38'>대출일자</td>
			<td width=100 rowspan="2" class='title'>상환완료예정일</td>					
			<td colspan="7" class='title'>상환금액</td>
		  </tr>
		  <tr>
			<td width=100 class='title'>합계</td>
			<td width=100 class='title'><%=AddUtil.parseInt(gubun2)+1%>년</td>
			<td width=100 class='title'><%=AddUtil.parseInt(gubun2)+2%>년</td>
			<td width=100 class='title'><%=AddUtil.parseInt(gubun2)+3%>년</td>
			<td width=100 class='title'><%=AddUtil.parseInt(gubun2)+4%>년</td>
			<td width=100 class='title'><%=AddUtil.parseInt(gubun2)+5%>년</td>			
			<td width=100 class='title'><%=AddUtil.parseInt(gubun2)+6%>년</td>
		  </tr>				
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);%>
		  <tr>
			<td align='center' width=30><%=i+1%></td>
			<td align='center' width=50><%=debt.get("ST2")%></td>		
			<td align='center' width=110><%=debt.get("CPT_NM")%></td>								
			<td align='center' width=50><%=debt.get("LEND_INT")%></td>								
			<td align='center' width=100><%=debt.get("VEN_CODE")%></td>	
			<td align='center' width=100><%=debt.get("LEND_NO")%></td>										
			<td align='center' width=120><%=debt.get("DEPOSIT_NO")%></td>
			<td align='center' width=90><%=debt.get("CAR_NO")%></td>					
			<td align='center' width=100><%=debt.get("LEND_DT")%></td>
			<td align='center' width=100><%=debt.get("END_DT")%></td>					
			<td align='right' width=100><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT13")))%></td>
			<td align='right' width=100><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT1")))%></td>
			<td align='right' width=100><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT2")))%></td>
			<td align='right' width=100><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT3")))%></td>
			<td align='right' width=100><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT4")))%></td>
			<td align='right' width=100><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT5")))%></td>			
			<td align='right' width=100><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT6")))%></td>
		  </tr>					
<%						total_amt1   = total_amt1   + AddUtil.parseLong(String.valueOf(debt.get("AMT1")));
						total_amt2   = total_amt2   + AddUtil.parseLong(String.valueOf(debt.get("AMT2")));
						total_amt3   = total_amt3   + AddUtil.parseLong(String.valueOf(debt.get("AMT3")));
						total_amt4   = total_amt4   + AddUtil.parseLong(String.valueOf(debt.get("AMT4")));
						total_amt5   = total_amt5   + AddUtil.parseLong(String.valueOf(debt.get("AMT5")));
						total_amt6   = total_amt6   + AddUtil.parseLong(String.valueOf(debt.get("AMT6")));
						total_amt13  = total_amt13  + AddUtil.parseLong(String.valueOf(debt.get("AMT13")));
		}%>
          <tr> 
			<td colspan="10" class="title">합계</td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt13)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt3)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt4)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt5)%></td>			
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt6)%></td>
		  </tr>		
		</table>
		</td>
	</tr>		
	<tr>
		<td align='right'>
		  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>		
</table>
</form>
</body>
</html>