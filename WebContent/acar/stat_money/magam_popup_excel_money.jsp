<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.stat_account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.stat_account.StatAccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_magam_popup_excel_money.xls");
%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
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
</script>

<style type="text/css">
<!--
.style1 {color: #FFFFFF}
-->
</style>
<body>


<table border="0" cellspacing="0" cellpadding="0" width=900>
  <tr> 
    <td colspan='9' align="center"><font face="±¼¸²" size="5" ><b>´ë¿©·á/ÇÒºÎ±ÝGAP</b></font></td>
  </tr>
  <tr> 
    <td class=title align="center" height="20"></td>
    <td class=title align="center" height="20"></td>
    <td class=title align="right"  height="20" style='text-align:right'></td>
    <td height="20" align="right" class=title style='text-align:right'></td>
    <td height="20" align="right" class=title style='text-align:right'></td>
    <td height="20" align="right" class=title style='text-align:right'></td>
    <td class=title align="right"  height="20" style='text-align:right'></td>
    <td class=title align="right"  height="20" style='text-align:right'></td>
    <td align="right"><font face="±¼¸²" size="2">Ãâ·ÂÀÏÀÚ: <%=AddUtil.getDate()%></font></td>
  </tr>
</table>  
<table border="0" cellspacing="0" cellpadding="0" width=900>
  <tr> 
      <td class="line" > 
        <table width="100%" border="1" cellspacing="1" cellpadding="1">        
                <tr align="center"> 
                    <td width=4% rowspan="2" class=title>¿¬¹ø</td>
                    <td width=6% rowspan="2" class=title>³â¿ù</td>
                    <td width=10% rowspan="2" class=title>´ë¿©·á<br>(°ø±Þ°¡)</td>
                    <td colspan="3" class=title>ÇÒºÎ±Ý</td>
                    <td width=10% rowspan="2" class=title>¸®½º·á</td>
                    <td width=10% rowspan="2" class=title>Â÷¾×</td>
                    <td  rowspan="2" class=title>´ë¿©·á ´ëºñ ÇÒºÎ±Ýºñ</td>
                </tr>
                <tr align="center">
                  <td width=10% class=title>¿ø±Ý</td>
                  <td width=10% class=title>ÀÌÀÚ</td>
                  <td width=10% class=title>ÇÕ°è</td>
                </tr>                  
              <%for (int i = 0 ; i < acc_size ; i++){
    				Hashtable acc = (Hashtable)accs.elementAt(i);
    				fee_amt = AddUtil.parseLong(String.valueOf(acc.get("FEE_S_AMT")));
					prn_amt = AddUtil.parseLong(String.valueOf(acc.get("PRN_AMT")));
					int_amt = AddUtil.parseLong(String.valueOf(acc.get("INT_AMT")));
					alt_amt = AddUtil.parseLong(String.valueOf(acc.get("ALT_AMT")));
					ls_prn_amt = AddUtil.parseLong(String.valueOf(acc.get("LS_PRN_AMT")));
					dly_amt = AddUtil.parseLong(String.valueOf(acc.get("DLY_AMT")));
    				float per = (AddUtil.parseFloat(String.valueOf(acc.get("ALT_AMT")))+AddUtil.parseFloat(String.valueOf(acc.get("LS_PRN_AMT"))))/AddUtil.parseFloat(String.valueOf(acc.get("FEE_S_AMT")))*100;%>
                <tr> 
                    <td align="center" width=4% height="38%"><font face="±¼¸²" size="2"><%=i+1%></font></td>
                    <td align="center" width=6% height="38%"><font face="±¼¸²" size="2">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(acc.get("SEQ")))%></font></td>
                    <td align="right" width=12% height="38%"><font face="±¼¸²" size="2"><%=Util.parseDecimal(fee_amt)%></font></td>
                    <td width=10% align="right"><font face="±¼¸²" size="2"><%=Util.parseDecimal(prn_amt)%></font></td>
                    <td width=10% align="right"><font face="±¼¸²" size="2"><%=Util.parseDecimal(int_amt)%></font></td>
                    <td align="right" width=10% height="38%"><font face="±¼¸²" size="2"><%=Util.parseDecimal(alt_amt)%></font></td>
                    <td align="right" width=10% height="38%"><font face="±¼¸²" size="2"><%=Util.parseDecimal(ls_prn_amt)%></font></td>
                    <td align="right" width=10% height="38%"><font face="±¼¸²" size="2"><%=Util.parseDecimal(dly_amt)%></font></td>
                    <td width="194" height=38%> <font face="±¼¸²" size="2"><%=AddUtil.parseFloatCipher(per,2)%>%</font> </td>
                </tr>
                  <%	total_amt1 = total_amt1 + fee_amt;
        			  	total_amt2 = total_amt2 + prn_amt;
						total_amt3 = total_amt3 + int_amt;
        				total_amt4 = total_amt4 + alt_amt;
        			  	total_amt5 = total_amt5 + dly_amt;
        			  	total_amt6 = total_amt6 + ls_prn_amt;
        		  }%>
                <tr> 
                    <td class=title align="center" height="20"></td>
                    <td class=title align="center" height="20">ÇÕ°è</td>
                    <td class=title align="right"  height="20" style='text-align:right'><font face="±¼¸²" size="2"><%=Util.parseDecimal(total_amt1)%></font></td>
                    <td height="20" align="right" class=title style='text-align:right'><font face="±¼¸²" size="2"><%=Util.parseDecimal(total_amt2)%></font></td>
                    <td height="20" align="right" class=title style='text-align:right'><font face="±¼¸²" size="2"><%=Util.parseDecimal(total_amt3)%></font></td>
                    <td height="20" align="right" class=title style='text-align:right'><font face="±¼¸²" size="2"><%=Util.parseDecimal(total_amt4)%></font></td>
                    <td class=title align="right"  height="20" style='text-align:right'><font face="±¼¸²" size="2"><%=Util.parseDecimal(total_amt6)%></font></td>
                    <td class=title align="right"  height="20" style='text-align:right'><font face="±¼¸²" size="2"><%=Util.parseDecimal(total_amt5)%></font></td>
                    <td class=title height="20"></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<br>
</body>
</html>

