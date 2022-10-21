<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

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

<%
	String cost_ym 	= request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String car_use 	= request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String com_id 	= request.getParameter("com_id")==null?"":request.getParameter("com_id");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	
	//보험료
	Vector costs = ai_db.getInsurPrecostPrint_2_amt(cost_ym);
	int cost_size = costs.size();
	
	//차량대수
	Vector costs2 = ai_db.getInsurPrecostPrint_2_cnt(cost_ym);
	int cost_size2 = costs2.size();
	
	long sum0 = 0;
	long sum1 = 0;
	long sum2 = 0;
	long sum3 = 0;
	long sum4 = 0;
	long sum5 = 0;
	long sum6 = 0;
	long sum7 = 0;
	long sum8 = 0;
	long sum9 = 0;
	long sum10 = 0;
	long sum11 = 0;
	long sum12 = 0;
	long sum13 = 0;
	long sum14 = 0;
	long sum15 = 0;
	long sum16 = 0;
	long sum17 = 0;
	long sum18 = 0;
	long sum19 = 0;
	long sum20 = 0;
	long sum21 = 0;
	long sum22 = 0;
	long sum23 = 0;
	long sum24 = 0;
	long sum25 = 0;
	long sum26 = 0;
	long sum27 = 0;
	long sum28 = 0;
	long sum29 = 0;
	long sum30 = 0;
	
	int  cnt1 = 0;
	int  cnt2 = 0;
	int  cnt3 = 0;
	int  cnt4 = 0;
	int  cnt5 = 0;
	int  cnt6 = 0;
	int  cnt7 = 0;
	int  cnt8 = 0;
	int  cnt9 = 0;
	int  cnt10 = 0;
	int  cnt11 = 0;
	int  cnt12 = 0;
	int  cnt13 = 0;
	int  cnt14 = 0;
	int  cnt15 = 0;
	int  cnt16 = 0;
	int  cnt17 = 0;
	int  cnt18 = 0;
	int  cnt19 = 0;
	int  cnt20 = 0;
	int  cnt21 = 0;
	int  cnt22 = 0;
	int  cnt23 = 0;
	int  cnt24 = 0;
	int  cnt25 = 0;
	int  cnt26 = 0;
	int  cnt27 = 0;
	int  cnt28 = 0;
	int  cnt29 = 0;
	int  cnt30 = 0;
%>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td align="center"><span class=style2><%=cost_ym%> 년 자동차 보험료 납부현황</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='7%' rowspan="3" class='title'>보험사</td>
            <td width="7%" rowspan="3" class='title'>구분</td>
            <td width="6%" rowspan="3" class='title'>총건수</td>
            <td width="10%" rowspan="3" class='title'>총보험료</td>
            <td colspan="8" class='title'>납부보험료</td>
            <td colspan="2" rowspan="2" class='title'>환급보험료</td>
          </tr>
          <tr>
            <td colspan="2" class='title'>1회납보험료</td>
            <td colspan="2" class='title'>분납보험료</td>
            <td colspan="2" class='title'>추가보험료</td>
            <td colspan="2" class='title'>소계</td>
          </tr>
          <tr>
            <td class='title' width="4%">건수</td>
            <td class='title' width="10%">금액</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="10%">금액</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="10%">금액</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="10%">금액</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="10%">금액</td>
          </tr>
          <%	for(int i = 0 ; i < cost_size ; i++){
					Hashtable ht = (Hashtable)costs.elementAt(i);%>		  
          <tr> 
            <td align="center" style='text-align:center;'><%=ht.get("INS_COM_ID")%></td>
            <td align="center" style='text-align:center;'><%=ht.get("CAR_USE")%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("T1")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("T2")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT3")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("C")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("A")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT4")))%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></td>
          </tr>
<%				}%>
        </table>
      </td>
    </tr>
    <tr>
		<td></td>
	</tr>	
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='7%' class='title'>보험사</td>
            <td width="7%" class='title'>구분</td>
            <td width="86%" class='title'>총건수</td>
          </tr>
          <%	for(int i = 0 ; i < cost_size2 ; i++){
					Hashtable ht = (Hashtable)costs2.elementAt(i);%>		  
          <tr> 
            <td align="center" style='text-align:center;'><%=ht.get("INS_COM_ID")%></td>
            <td align="center" style='text-align:center;'><%=ht.get("CAR_USE")%></td>
            <td align="right" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
          </tr>
<%				}%>
        </table>
      </td>
    </tr>	
  </table>
</body>
</html>
