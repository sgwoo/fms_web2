<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.stat_account.StatAccountDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"6":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.replace(request.getParameter("st_dt"),"-","");
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.replace(request.getParameter("end_dt"),"-","");
	
	long cha_est_amt = 0;
	long cha_pay_amt = 0;
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	
	if(gubun.equals("1")){
		st_dt  = s_yy+""+s_mm+"01";
		end_dt = s_yy+""+s_mm;
	}else if(gubun.equals("2")){
		st_dt  = s_yy+""+"0101";
		end_dt = s_yy+""+"1231";
	}
	
	Vector accs = ac_db.getStatFeeDebtIns(gubun, st_dt, end_dt);
	int acc_size = accs.size();	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css"> 
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='size' value='<%=acc_size%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='mode' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                	<%if(gubun.equals("2")){%>
                	<td width=20% rowspan="2" class=title>귀속월</td>
                	<%}else{%>
                	<td colspan="2" class=title>귀속일자</td>
                	<%}%>                    
                  <td colspan="2" class=title>대여료</td>
                  <td colspan="2" class=title>할부금</td>
                  <td colspan="2" class=title>보험료</td>
                  <td colspan="2" class=title>차액</td>
                </tr>
                <tr align="center">
                	<%if(!gubun.equals("2")){%>
                	<td width=10% class=title>일자</td>
                	<td width=10% class=title>요일</td>
                	<%}%>                    
                  <td width=10% class=title>예정금액</td>
                  <td width=10% class=title>입금금액</td>
                  <td width=10% class=title>예정금액</td>
                  <td width=10% class=title>지출금액</td>
                  <td width=10% class=title>예정금액</td>
                  <td width=10% class=title>지출금액</td>
                  <td width=10% class=title>예정금액</td>
                  <td width=10% class=title>지출금액</td>
                </tr>
                <%for (int i = 0 ; i < acc_size ; i++){
										Hashtable acc = (Hashtable)accs.elementAt(i);
										cha_est_amt = AddUtil.parseLong(String.valueOf(acc.get("AMT1")))-AddUtil.parseLong(String.valueOf(acc.get("AMT3")))-AddUtil.parseLong(String.valueOf(acc.get("AMT5")));
										cha_pay_amt = AddUtil.parseLong(String.valueOf(acc.get("AMT2")))-AddUtil.parseLong(String.valueOf(acc.get("AMT4")))-AddUtil.parseLong(String.valueOf(acc.get("AMT6")));
										total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(acc.get("AMT1")));
										total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(acc.get("AMT2")));
										total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(acc.get("AMT3")));
										total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(acc.get("AMT4")));
										total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(acc.get("AMT5")));
										total_amt6 = total_amt6 + AddUtil.parseLong(String.valueOf(acc.get("AMT6")));
										total_amt7 = total_amt7 + cha_est_amt;
										total_amt8 = total_amt8 + cha_pay_amt;
								%>
                <tr> 
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(acc.get("B_DT")))%></td>
                    <%if(!gubun.equals("2")){%>  
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(acc.get("B_DT_NM")))%></td>
                    <%}%>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(acc.get("AMT1")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(acc.get("AMT2")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(acc.get("AMT3")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(acc.get("AMT4")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(acc.get("AMT5")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(acc.get("AMT6")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(cha_est_amt)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(cha_pay_amt)%></td>
                </tr>
                <%}%>
                <tr> 
                    <td class=title <%if(!gubun.equals("2")){%>colspan='2'<%}%>>합계</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt6)%></td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt7)%></td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt8)%></td>
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
</body>
</html>
