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
	
	
	//기간비용
	Vector costs = ai_db.getInsurPrecostStat3("", cost_ym);
	int cost_size = costs.size();
	
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
      <td align="center"><span class=style2><%=cost_ym%> 년 자동차 보험료 기간비용</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='3%' rowspan="2" class='title'>월</td>
            <td colspan="2" class='title'>총합계</td>
            <td width='9%' rowspan="2" class='title'>보험사</td>
            <td class='title' colspan="3">합계</td>
            <td colspan="3" class='title'>영업용</td>
            <td colspan="3" class='title'>업무용</td>
          </tr>
          <tr>
            <td width='10%' class='title'>당월산입</td>
            <td width='9%' class='title'>선급잔액</td>
            <td class='title' width="5%">건수</td>
            <td class='title' width="9%">당월산입</td>
            <td class='title' width="9%">선급잔액</td>
            <td class='title' width="5%">건수</td>
            <td class='title' width="9%">당월산입</td>
            <td class='title' width="9%">선급잔액</td>
            <td class='title' width="5%">건수</td>
            <td class='title' width="9%">당월산입</td>
            <td class='title' width="9%">선급잔액</td>
          </tr>
          <%	for(int i = 0 ; i < cost_size ; i++){
					Hashtable ht = (Hashtable)costs.elementAt(i);%>		  
          <tr> 
            <td rowspan="4" style='text-align:center;'><%=ht.get("MM")%></td>
            <td rowspan="4" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT1")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','')"></a>--></td>
            <td rowspan="4" style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT2")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','')"></a>--></td>
             <td style='text-align:center;'>렌터카조합</td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT7")))%></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT15")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT16")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT8")))%></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT17")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','1','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT18")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT9")))%></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT19")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','2','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT20")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')"></a>&nbsp;--></td>
          </tr>
          <tr> 
            <td style='text-align:center;'>동부화재</td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT4")))%></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT9")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT10")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT5")))%></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT11")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','1','0008')">.</a>--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT12")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT6")))%></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT13")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','2','0008')">.</a>--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT14")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')">.</a>--></td>
          </tr>
          <tr> 
          	 <td style='text-align:center;'>삼성화재/기타</td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT3")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0007')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT4")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0007')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT5")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','1','0007')">.</a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT6")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0007')"></a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT3")))%></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT7")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','2','0007')">.</a>&nbsp;--></td>
            <td style='text-align:right;'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT8")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0007')"></a>&nbsp;--></td>
          
          </tr>
          <tr> 
            <td style='text-align:center;' class="is">소계</td>
            <td style='text-align:right;' class="is"><%=Util.parseDecimalLong(String.valueOf(ht.get("CNT0")))%></td>
            <td style='text-align:right;' class="is"><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT1")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;' class="is"><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT2")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;' class="is"><%=Util.parseDecimalLong(String.valueOf(ht.get("S_CNT1")))%></td>
            <td style='text-align:right;' class="is"><%=Util.parseDecimalLong(String.valueOf(ht.get("S_AMT1")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','1','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;' class="is"><%=Util.parseDecimalLong(String.valueOf(ht.get("S_AMT2")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','1','')"></a>--></td>
            <td style='text-align:right;' class="is"><%=Util.parseDecimalLong(String.valueOf(ht.get("S_CNT2")))%></td>
            <td style='text-align:right;' class="is"><%=Util.parseDecimalLong(String.valueOf(ht.get("S_AMT3")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','2','0008')"></a>&nbsp;--></td>
            <td style='text-align:right;' class="is"><%=Util.parseDecimalLong(String.valueOf(ht.get("S_AMT4")))%><!--<a href="javascript:view_precost2('<%=ht.get("YM")%>','2','2','')"></a>--></td>
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
            <td rowspan="4" style='text-align:right;' class=title><%=Util.parseDecimalLong(sum1)%></td>
            <td rowspan="4" style='text-align:right;' class=title><%=Util.parseDecimalLong(sum2)%></td>
            <td style='text-align:center;' class=title>렌터카조합</td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt7)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum15)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum16)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt8)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum17)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum18)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt9)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum19)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum20)%></td>
          </tr>
          <tr>
            <td style='text-align:center;' class=title>동부화재</td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt4)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum9)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum10)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt5)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum11)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum12)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt6)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum13)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum14)%></td>
          </tr>
          <tr>
          	 <td style='text-align:center;' class=title>삼성화재/기타</td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt1)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum3)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum4)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt2)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum5)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum6)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt3)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum7)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum8)%></td>
            
          </tr>
          <tr>
            <td style='text-align:center;' class=title>소계</td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt1+cnt4+cnt7)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum3+sum9+sum15)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum4+sum10+sum16)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt2+cnt5+cnt8)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum5+sum11+sum17)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum6+sum12+sum18)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(cnt3+cnt6+cnt9)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum7+sum13+sum19)%></td>
            <td class=title style='text-align:right;'><%=Util.parseDecimalLong(sum8+sum14+sum20)%></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
