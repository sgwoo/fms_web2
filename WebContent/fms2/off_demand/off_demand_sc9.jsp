<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.stat_account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.stat_account.StatAccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long fee_amt = 0;
	long alt_amt = 0;
	long prn_amt = 0;
	long int_amt = 0;
	long dly_amt = 0;
	long ls_prn_amt = 0;
	
	
	
	Vector accs = ac_db.getStatFeeDebtGap(save_dt);
	int acc_size = accs.size();	
	
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='off_demand_sc1.jsp' method='post' target='t_content'>
  <table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료/할부금GAP</span></td>
    </tr>
    <tr>
        <td align=right>(<%=AddUtil.ChangeDate2(save_dt) %> 현재, 단위:원)</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
		<td class='line' > 
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr align="center"> 
                    <td width=50 rowspan="2" class=title>연번</td>
                    <td width=100 rowspan="2" class=title>년월</td>
                    <td width=150 rowspan="2" class=title>대여료<br>(공급가)</td>
                    <td colspan="3" class=title>할부금</td>                    
                    <td width=150 rowspan="2" class=title>차액</td>
                    <td width=100 rowspan="2" class=title>대여료 대비<br>할부금비</td>
                </tr>
                <tr align="center">
                  <td width=150 class=title>원금</td>
                  <td width=150 class=title>이자</td>
                  <td width=150 class=title>합계</td>
                </tr>              
              <%for (int i = 0 ; i < acc_size ; i++){
    				Hashtable acc = (Hashtable)accs.elementAt(i);
    				fee_amt = AddUtil.parseLong(String.valueOf(acc.get("FEE_S_AMT")));
					prn_amt = AddUtil.parseLong(String.valueOf(acc.get("PRN_AMT")));
					int_amt = AddUtil.parseLong(String.valueOf(acc.get("INT_AMT")));
					alt_amt = AddUtil.parseLong(String.valueOf(acc.get("ALT_AMT")));					
					dly_amt = AddUtil.parseLong(String.valueOf(acc.get("DLY_AMT")));
    				float per = (AddUtil.parseFloat(String.valueOf(acc.get("ALT_AMT"))))/AddUtil.parseFloat(String.valueOf(acc.get("FEE_S_AMT")))*100;%>
                <tr> 
                    <td align="center"height="38%"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(acc.get("SEQ")))%></td>
                    <td align="right"><%=Util.parseDecimal(fee_amt)%></td>
                    <td align="right"><%=Util.parseDecimal(prn_amt)%></td>
                    <td align="right"><%=Util.parseDecimal(int_amt)%></td>
                    <td align="right"><%=Util.parseDecimal(alt_amt)%></td>                    
                    <td align="right"><%=Util.parseDecimal(dly_amt)%></td>
                    <td align="center"><%=AddUtil.parseFloatCipher(per,2)%>%</td>
                </tr>
                  <%	total_amt1 = total_amt1 + fee_amt;
        			  	total_amt2 = total_amt2 + prn_amt;
						total_amt3 = total_amt3 + int_amt;
        				total_amt4 = total_amt4 + alt_amt;
        			  	total_amt5 = total_amt5 + dly_amt;        			  	
        		  }%>
                <tr>                     
                    <td class=title align="center" height="20" colspan='2'>합계</td>
                    <td class=title align="right"  height="20" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
                    <td height="20" align="right" class=title style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
                    <td height="20" align="right" class=title style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
                    <td height="20" align="right" class=title style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>                    
                    <td class=title align="right"  height="20" style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
                    <td class=title height="20"></td>
                </tr>
            </table>
        </td>
    </tr>									
  </table>
</form>
</body>
</html>
