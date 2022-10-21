<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.car_sche.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	

	
	long req_total_amt1	= 0;
	long req_total_amt2 = 0;
	long req_total_amt3	= 0;
	long req_total_amt4 = 0;
	long req_total_amt5	= 0;
	long req_total_amt6 = 0;
	long req_total_amt7	= 0;
	long req_total_amt8 = 0;
	
	long pay_total_amt1 = 0;
	long pay_total_amt2 = 0;
	long pay_total_amt3 = 0;
	long pay_total_amt4 = 0;
	long pay_total_amt5 = 0;
	long pay_total_amt6 = 0;
	long pay_total_amt7 = 0;
	long pay_total_amt8 = 0;
	
	long req_total_amt = 0;
	long pay_total_amt = 0;
	
	int total_cnt1	= 0;
	int total_cnt2 = 0;

	
	int end_year = 2007;
	int nyear = 0;
		nyear = calendar.getThisYear();

	int thisyear = Util.parseInt(nyear+"1231");
	int thisyear1 = Util.parseInt((nyear-1)+"1231");
	int thisyear2 = Util.parseInt((nyear-2)+"1231");
	int thisyear3 = Util.parseInt((nyear-3)+"1231");
	int thisyear4 = Util.parseInt((nyear-4)+"1231");
	
	Vector vt = as_db.getMyAccidInsComDtStatYear(nyear, s_mm);
	int vt_size = vt.size();
	
	Vector vt1 = as_db.getMyAccidInsComDtStatYear(nyear-1, s_mm);
	int vt1_size = vt1.size();
	
	Vector vt2 = as_db.getMyAccidInsComDtStatYear(nyear-2, s_mm);
	int vt2_size = vt2.size();
	
	Vector vt3 = as_db.getMyAccidInsComDtStatYear(nyear-3, s_mm);
	int vt3_size = vt3.size();

	Vector vt4 = as_db.getMyAccidInsComDtStatYear(nyear-4, s_mm);
	int vt4_size = vt4.size();
	
	Vector vt5 = as_db.getMyAccidInsComDtStatYear(nyear-5, s_mm);
	int vt5_size = vt5.size();
	
	Vector vt6 = as_db.getMyAccidInsComDtStatYear(nyear-6, s_mm);
	int vt6_size = vt6.size();

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//세부리스트
	function view_stat(ins_com){
		window.open('accid_s11_stat_list.jsp?s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&ins_com='+ins_com, "STAT_LIST", "left=0, top=0, width=900, height=568, scrollbars=yes, status=yes, resize");
	}

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
  <input type='hidden' name='years' 		value='<%=end_year%>'>
  <input type='hidden' name='nyear' 		value='<%=nyear%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
					<td width="20%" class=title>연도</td>
					<td width="30%" class=title>청구금액</td>
					<td width="30%" class=title>입금금액</td>
					<td width="20%" class=title>입금비율</td>
                </tr>
				<tr> 
					<td width="20%" class=title colspan=""><%=nyear%>년</td>
				<% for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
				
					req_total_amt1 	= req_total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("REQ_AMT")));
					pay_total_amt1 	= pay_total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
				
				%>
				<%}%>
					<td align="right"><%=AddUtil.parseDecimal(req_total_amt1)%></td>
                    <td align="right"><%=AddUtil.parseDecimal(pay_total_amt1)%></td>
					<td align="center"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(pay_total_amt1))/AddUtil.parseFloat(String.valueOf(req_total_amt1))*100,2)%>%</td>
                </tr>		
				<tr>
					<td width="20%" class=title colspan=""><%=nyear-1%>년</td>
				<% for(int i = 0 ; i < vt1_size ; i++){
						Hashtable ht1 = (Hashtable)vt1.elementAt(i);
				
					req_total_amt2 	= req_total_amt2 + AddUtil.parseLong(String.valueOf(ht1.get("REQ_AMT")));
					pay_total_amt2 	= pay_total_amt2 + AddUtil.parseLong(String.valueOf(ht1.get("PAY_AMT")));
				%>
				<%}%>									
					<td align="right"><%=AddUtil.parseDecimal(req_total_amt2)%></td>
                    <td align="right"><%=AddUtil.parseDecimal(pay_total_amt2)%></td>
					<td align="center"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(pay_total_amt2))/AddUtil.parseFloat(String.valueOf(req_total_amt2))*100,2)%>%</td>
				</tr>	
				<tr>
					<td width="20%" class=title colspan=""><%=nyear-2%>년</td>
				<% for(int i = 0 ; i < vt2_size ; i++){
						Hashtable ht2 = (Hashtable)vt2.elementAt(i);
				
					req_total_amt3 	= req_total_amt3 + AddUtil.parseLong(String.valueOf(ht2.get("REQ_AMT")));
					pay_total_amt3 	= pay_total_amt3 + AddUtil.parseLong(String.valueOf(ht2.get("PAY_AMT")));
				%>
				<%}%>									
					<td align="right"><%=AddUtil.parseDecimal(req_total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimal(pay_total_amt3)%></td>
					<td align="center"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(pay_total_amt3))/AddUtil.parseFloat(String.valueOf(req_total_amt3))*100,2)%>%</td>
				</tr>
				<tr>
					<td width="20%" class=title colspan=""><%=nyear-3%>년</td>
				<% for(int i = 0 ; i < vt3_size ; i++){
						Hashtable ht3 = (Hashtable)vt3.elementAt(i);
				
					req_total_amt4 	= req_total_amt4 + AddUtil.parseLong(String.valueOf(ht3.get("REQ_AMT")));
					pay_total_amt4 	= pay_total_amt4 + AddUtil.parseLong(String.valueOf(ht3.get("PAY_AMT")));
				%>
				<%}%>									
					<td align="right"><%=AddUtil.parseDecimal(req_total_amt4)%></td>
                    <td align="right"><%=AddUtil.parseDecimal(pay_total_amt4)%></td>
					<td align="center"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(pay_total_amt4))/AddUtil.parseFloat(String.valueOf(req_total_amt4))*100,2)%>%</td>
				</tr>
				<tr>
					<td width="20%" class=title colspan=""><%=nyear-4%>년</td>
				<% for(int i = 0 ; i < vt4_size ; i++){
						Hashtable ht4 = (Hashtable)vt4.elementAt(i);
				
					req_total_amt5 	= req_total_amt5 + AddUtil.parseLong(String.valueOf(ht4.get("REQ_AMT")));
					pay_total_amt5 	= pay_total_amt5 + AddUtil.parseLong(String.valueOf(ht4.get("PAY_AMT")));
				%>
				<%}%>									
					<td align="right"><%=AddUtil.parseDecimal(req_total_amt5)%></td>
                    <td align="right"><%=AddUtil.parseDecimal(pay_total_amt5)%></td>
					<td align="center"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(pay_total_amt5))/AddUtil.parseFloat(String.valueOf(req_total_amt5))*100,2)%>%</td>
				</tr>
				<tr>
					<td width="20%" class=title colspan=""><%=nyear-5%>년</td>
				<% for(int i = 0 ; i < vt5_size ; i++){
						Hashtable ht5 = (Hashtable)vt5.elementAt(i);
				
					req_total_amt6 	= req_total_amt6 + AddUtil.parseLong(String.valueOf(ht5.get("REQ_AMT")));
					pay_total_amt6 	= pay_total_amt6 + AddUtil.parseLong(String.valueOf(ht5.get("PAY_AMT")));
				%>
				<%}%>									
					<td align="right"><%=AddUtil.parseDecimal(req_total_amt6)%></td>
                    <td align="right"><%=AddUtil.parseDecimal(pay_total_amt6)%></td>
					<td align="center"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(pay_total_amt6))/AddUtil.parseFloat(String.valueOf(req_total_amt6))*100,2)%>%</td>
				</tr>
				<tr>
					<td width="20%" class=title colspan=""><%=nyear-6%>년</td>
				<% for(int i = 0 ; i < vt6_size ; i++){
						Hashtable ht6 = (Hashtable)vt6.elementAt(i);
				
					req_total_amt7 	= req_total_amt7 + AddUtil.parseLong(String.valueOf(ht6.get("REQ_AMT")));
					pay_total_amt7 	= pay_total_amt7 + AddUtil.parseLong(String.valueOf(ht6.get("PAY_AMT")));
				%>
				<%}%>									
					<td align="right"><%=AddUtil.parseDecimal(req_total_amt7)%></td>
                    <td align="right"><%=AddUtil.parseDecimal(pay_total_amt7)%></td>
					<td align="center"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(pay_total_amt7))/AddUtil.parseFloat(String.valueOf(req_total_amt7))*100,2)%>%</td>
				</tr>
				<%
					req_total_amt = req_total_amt1 + req_total_amt2 + req_total_amt3 + req_total_amt4 + req_total_amt5 + req_total_amt6 + req_total_amt7;
					pay_total_amt = pay_total_amt1 + pay_total_amt2 + pay_total_amt3 + pay_total_amt4 + pay_total_amt5 + pay_total_amt6 + pay_total_amt7;
				%>				
				<tr>
					<td align="center" class=title >합   계</td>
					<td align="right"><%=AddUtil.parseDecimal(req_total_amt)%></td>
                    <td align="right"><%=AddUtil.parseDecimal(pay_total_amt)%></td>
					<td align="center"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(pay_total_amt))/AddUtil.parseFloat(String.valueOf(req_total_amt))*100,2)%>%</td>
				</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>