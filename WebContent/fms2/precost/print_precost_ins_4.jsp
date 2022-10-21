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
	
		
	//납부보험료
	Vector scds = ai_db.getInsurScdPayAmtStat3("", cost_ym);
	int scd_size = scds.size();	
		
	
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
            <td width='2%' rowspan="2" class='title'>월</td>
            <td colspan="2" class='title'>총합계</td>
            <td width='7%' rowspan="2" class='title'>보험사</td>
            <td class='title' colspan="4">합계</td>
            <td class='title' colspan="4">영업용</td>
            <td class='title' colspan="4">업무용</td>
          </tr>
          <tr>
            <td width='4%' class='title'>건수</td>
            <td width='9%' class='title'>지급</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="8%">지급</td>
            <td class='title' width="6%">환급</td>
            <td class='title' width="8%">소계</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="8%">지급</td>
            <td class='title' width="6%">환급</td>
            <td class='title' width="8%">소계</td>
            <td class='title' width="4%">건수</td>
            <td class='title' width="8%">지급</td>
            <td class='title' width="6%">환급</td>
            <td class='title' width="8%">소계</td>
          </tr>
          <%	for(int i = 0 ; i < scd_size ; i++){
					Hashtable ht = (Hashtable)scds.elementAt(i);%>		  
          <tr> 
            <td rowspan="4" style='text-align:center;'><%=ht.get("MM")%></td>
            <td rowspan="4" style='text-align:center;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT1")))%></td>
            <td rowspan="4" style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT3")))%></td>
 			 <td style='text-align:center;'>렌터카조합</td> 
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT7")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT19")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT20")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT21")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT8")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT22")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT23")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT24")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT9")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT25")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT26")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT27")))%></td>
          </tr>
          <tr>
            <td style='text-align:center;'>동부화재</td> 
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT4")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT10")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT11")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT12")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT5")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT13")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT14")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT15")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT6")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT16")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT17")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT18")))%></td>
          </tr>
          <tr>
          	 <td style='text-align:center;'>삼성화재/기타</td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT6")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT3")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT7")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT8")))%></td>
            <td style='text-align:right;'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT9")))%></td>
           
          </tr>
          <tr>
            <td style='text-align:center;' class="is">소계</td> 
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT1")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT1")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT2")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT3")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT2")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT4")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT5")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT6")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CNT3")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT7")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT8")))%></td>
            <td style='text-align:right;' class="is"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_AMT9")))%></td>
          </tr>
<%			
			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("AMT4")));
			sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("AMT5")));
			sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("AMT6")));
			sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("AMT7")));
			sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("AMT8")));
			sum9  = sum9  + Util.parseLong(String.valueOf(ht.get("AMT9")));
			sum10 = sum10 + Util.parseLong(String.valueOf(ht.get("AMT10")));
			sum11 = sum11 + Util.parseLong(String.valueOf(ht.get("AMT11")));
			sum12 = sum12 + Util.parseLong(String.valueOf(ht.get("AMT12")));
			sum13 = sum13 + Util.parseLong(String.valueOf(ht.get("AMT13")));
			sum14 = sum14 + Util.parseLong(String.valueOf(ht.get("AMT14")));
			sum15 = sum15 + Util.parseLong(String.valueOf(ht.get("AMT15")));
			sum16 = sum16 + Util.parseLong(String.valueOf(ht.get("AMT16")));
			sum17 = sum17 + Util.parseLong(String.valueOf(ht.get("AMT17")));
			sum18 = sum18 + Util.parseLong(String.valueOf(ht.get("AMT18")));
			sum19 = sum19 + Util.parseLong(String.valueOf(ht.get("AMT19")));
			sum20 = sum20 + Util.parseLong(String.valueOf(ht.get("AMT20")));
			sum21 = sum21 + Util.parseLong(String.valueOf(ht.get("AMT21")));
			sum22 = sum22 + Util.parseLong(String.valueOf(ht.get("AMT22")));
			sum23 = sum23 + Util.parseLong(String.valueOf(ht.get("AMT23")));
			sum24 = sum24 + Util.parseLong(String.valueOf(ht.get("AMT24")));
			sum25 = sum25 + Util.parseLong(String.valueOf(ht.get("AMT25")));
			sum26 = sum26 + Util.parseLong(String.valueOf(ht.get("AMT26")));
			sum27 = sum27 + Util.parseLong(String.valueOf(ht.get("AMT27")));
			
			cnt1 = cnt1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			cnt2 = cnt2 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			cnt3 = cnt3 + Util.parseInt(String.valueOf(ht.get("CNT3")));
			cnt4 = cnt4 + Util.parseInt(String.valueOf(ht.get("CNT4")));
			cnt5 = cnt5 + Util.parseInt(String.valueOf(ht.get("CNT5")));
			cnt6 = cnt6 + Util.parseInt(String.valueOf(ht.get("CNT6")));
			cnt7 = cnt7 + Util.parseInt(String.valueOf(ht.get("CNT7")));
			cnt8 = cnt8 + Util.parseInt(String.valueOf(ht.get("CNT8")));
			cnt9 = cnt9 + Util.parseInt(String.valueOf(ht.get("CNT9")));
}%>			  
  
          <tr> 
            <td rowspan="4" style='text-align:center;' class=title>계</td>
            <td rowspan="4" style='text-align:center;' class=title><%=AddUtil.parseDecimalLong(cnt1+cnt4+cnt7)%></td>
            <td rowspan="4"  style='text-align:right;' class=title><%=AddUtil.parseDecimalLong(sum3+sum12+sum21)%></td>
            <td style='text-align:center;' class=title>렌터카조합</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum19)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum20)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum21)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum22)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum23)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum24)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt9)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum25)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum26)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum27)%></td>
          </tr>
          <tr>
            <td style='text-align:center;' class=title>동부화재</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt4)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum10)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum11)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum12)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt5)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum13)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum14)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum15)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt6)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum16)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum17)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum18)%></td>
          </tr>
          <tr>
          	 <td style='text-align:center;' class=title>삼성화재/기타</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt1)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum1)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum2)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum3)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt2)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum4)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum5)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum6)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt3)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum9)%></td>
           
          </tr>
          <tr>
            <td style='text-align:center;' class=title>소계</td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt1+cnt4+cnt7)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum1+sum10+sum19)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum2+sum11+sum20)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum3+sum12+sum21)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt2+cnt5+cnt8)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum4+sum13+sum22)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum5+sum14+sum23)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum6+sum15+sum24)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(cnt3+cnt6+cnt9)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum7+sum16+sum25)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum8+sum17+sum26)%></td>
            <td class=title style='text-align:right;'><%=AddUtil.parseDecimalLong(sum9+sum18+sum27)%></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
