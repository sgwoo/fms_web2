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
	
	Vector debts = ad_db.getDebtSettleList(gubun1, gubun2, gubun3, gubun4, s_kd, t_wd, sort_gubun, asc);
	int debt_size = debts.size();
	
	 Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		//System.out.println("현재날짜 : "+ sdf.format(d));
		String filename = sdf.format(d)+"_유동성부채.xls";
		filename = java.net.URLEncoder.encode(filename, "UTF-8");
		response.setContentType("application/octer-stream");
		response.setHeader("Content-Transper-Encoding", "binary");
		response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
		response.setHeader("Content-Description", "JSP Generated Data");
	
	
	
%>
<form name='form1' action='debt_pay_sc.jsp' method="post">
<input type='hidden' name='allot_size' value='<%=debt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=2070>
	<tr> 
      <td>
        <table width=100% border=1 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 구매자금관리 > <span class=style1><span class=style5>유동성부채현황</span></span></td>
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
			<td width=100 rowspan="2" class='title'>거래처코드</td>														
			<td width=100 rowspan="2" class='title'>대출번호</td>											
			<td width=120 rowspan="2" class='title'>계좌번호</td>
			<td width=90 rowspan="2" class='title'>차량번호</td>
			<td width=100 rowspan="2" class='title' style='height:38'>대출일자</td>
			<td width=100 rowspan="2" class='title'>상환완료예정일</td>					
			<td width=100 rowspan="2" class='title'>잔액</td>
			<td colspan="13" class='title'>월상환금액</td>
		  </tr>
		  <tr>
			<td width=90 class='title'>합계</td>
			<td width=90 class='title'>1월</td>
			<td width=90 class='title'>2월</td>
			<td width=90 class='title'>3월</td>
			<td width=90 class='title'>4월</td>
			<td width=90 class='title'>5월</td>
			<td width=90 class='title'>6월</td>
			<td width=90 class='title'>7월</td>
			<td width=90 class='title'>8월</td>
			<td width=90 class='title'>9월</td>
			<td width=90 class='title'>10월</td>
			<td width=90 class='title'>11월</td>
			<td width=90 class='title'>12월</td>
		  </tr>				
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);
			String st1 = String.valueOf(debt.get("ST1"));
			String st2 = String.valueOf(debt.get("ST2"));%>
		  <tr>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='center' width=30><%=i+1%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='center' width=50><%=st2%></td>		
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='center' width=110><%=debt.get("CPT_NM")%></td>								
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='center' width=100><%=debt.get("VEN_CODE")%></td>								
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='center' width=100><%=debt.get("LEND_NO")%>
									<%if(String.valueOf(debt.get("LEND_NO")).equals("") && st2.equals("묶음")){%>
									<%=debt.get("LEND_ID")%> <%=debt.get("RTN_SEQ")%>
									<%}else if(String.valueOf(debt.get("LEND_NO")).equals("") && st2.equals("개별")){%>
									<%=debt.get("RENT_L_CD")%>
									<%}%>
			</td>											
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='center' width=120><%=debt.get("DEPOSIT_NO")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='center' width=90><%=debt.get("CAR_NO")%></td>					
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='center' width=100><%=debt.get("LEND_DT")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='center' width=100><%=debt.get("END_DT")%></td>					
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT14")%></td>								
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT13")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT1")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT2")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT3")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT4")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT5")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT6")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT7")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT8")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT9")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT10")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT11")%></td>
			<td <%if(st1.equals("납부완료"))%>class=is<%%> align='right' width=90><%=debt.get("AMT12")%></td>
		  </tr>					
<%						total_amt1   = total_amt1   + AddUtil.parseLong(String.valueOf(debt.get("AMT1")));
						total_amt2   = total_amt2   + AddUtil.parseLong(String.valueOf(debt.get("AMT2")));
						total_amt3   = total_amt3   + AddUtil.parseLong(String.valueOf(debt.get("AMT3")));
						total_amt4   = total_amt4   + AddUtil.parseLong(String.valueOf(debt.get("AMT4")));
						total_amt5   = total_amt5   + AddUtil.parseLong(String.valueOf(debt.get("AMT5")));
						total_amt6   = total_amt6   + AddUtil.parseLong(String.valueOf(debt.get("AMT6")));
						total_amt7   = total_amt7   + AddUtil.parseLong(String.valueOf(debt.get("AMT7")));
						total_amt8   = total_amt8   + AddUtil.parseLong(String.valueOf(debt.get("AMT8")));
						total_amt9   = total_amt9   + AddUtil.parseLong(String.valueOf(debt.get("AMT9")));
						total_amt10  = total_amt10  + AddUtil.parseLong(String.valueOf(debt.get("AMT10")));
						total_amt11  = total_amt11  + AddUtil.parseLong(String.valueOf(debt.get("AMT11")));
						total_amt12  = total_amt12  + AddUtil.parseLong(String.valueOf(debt.get("AMT12")));
						total_amt13  = total_amt13  + AddUtil.parseLong(String.valueOf(debt.get("AMT13")));
						total_amt14  = total_amt14  + AddUtil.parseLong(String.valueOf(debt.get("AMT14")));
		}%>
          <tr> 
			<td colspan="9" class="title">합계</td>
			<td class="title" style='text-align:right'><%=total_amt14%></td>						
			<td class="title" style='text-align:right'><%=total_amt13%></td>
			<td class="title" style='text-align:right'><%=total_amt1%></td>
			<td class="title" style='text-align:right'><%=total_amt2%></td>
			<td class="title" style='text-align:right'><%=total_amt3%></td>
			<td class="title" style='text-align:right'><%=total_amt4%></td>
			<td class="title" style='text-align:right'><%=total_amt5%></td>
			<td class="title" style='text-align:right'><%=total_amt6%></td>
			<td class="title" style='text-align:right'><%=total_amt7%></td>
			<td class="title" style='text-align:right'><%=total_amt8%></td>
			<td class="title" style='text-align:right'><%=total_amt9%></td>
			<td class="title" style='text-align:right'><%=total_amt10%></td>
			<td class="title" style='text-align:right'><%=total_amt11%></td>
			<td class="title" style='text-align:right'><%=total_amt12%></td>
		  </tr>		
		</table>
		</td>
	</tr>		
</table>
</form>
</body>
</html>