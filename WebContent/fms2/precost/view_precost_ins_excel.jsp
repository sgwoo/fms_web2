<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=view_precost_ins_excel.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
	String cost_ym = request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String cost_st = request.getParameter("cost_st")==null?"":request.getParameter("cost_st");
	String car_use = request.getParameter("car_use")==null?"":request.getParameter("car_use");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	Vector vts = new Vector();
	int vt_size = 0;
	
	//보험선급비용 미처리스트
	if(cost_st.equals("2")){
		vts = ai_db.getInsurPrecostYmList(cost_ym, cost_st, car_use);
		vt_size = vts.size();
	}
	
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
	
	int  cnt1 = 0;
	int  cnt2 = 0;
	int  cnt3 = 0;
	int  cnt4 = 0;
	int  cnt5 = 0;
	int  cnt6 = 0;
	int  cnt7 = 0;
	int  cnt8 = 0;
	int  cnt9 = 0;
	
%>
<form name='form1' method='post'>
  <table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr>
      <td>&lt; 기간비용 리스트 &gt; </td>
    </tr>  
    <tr>
      <td>○<%if(cost_st.equals("2")){%>보험료<%}else{%>자동차세<%}%>
	  </td>
    </tr>
	<tr>
	  <td>
	    <table border="1" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width='30' rowspan="2" class=title>연번</td>
		    <td colspan="2" class=title>차량번호</td>
		    <td colspan="2" class=title >기간</td>
			<td width='70' rowspan="2" class=title>보험사</td>			
		    <td width='80' rowspan="2" class=title>총보험료</td>			
		    <td colspan="2" class=title>전월누계</td>
		    <td colspan="2" class=title>당월산입</td>
		    <td colspan="2" class=title>선급잔액</td>
	      </tr>
		  <tr valign="middle" align="center">
		    <td width='80' class=title>현재</td>		  
		    <td width='80' class=title>최초</td>		  			
		    <td width="65" class=title>from</td>
		    <td width="65" class=title>to</td>			
	        <td width="30" class=title>일수</td>
	        <td width="80" class=title>금액</td>
		    <td width="30" class=title>일수</td>
		    <td width="80" class=title>금액</td>
		    <td width="30" class=title>일수</td>
		    <td width="80" class=title>금액</td>
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
		  <tr> 
		    <td style="font-size:8pt" align='center'><%=i+1%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("CAR_NO")%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("FIRST_CAR_NO")%></td>			
		    <td style="font-size:8pt" align='center'><%=ht.get("INS_START_DT")%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("INS_EXP_DT")%></td>		
			<td style="font-size:8pt" align='center'><%=ht.get("INS_COM_NM")%></td>			
		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>						
		    <td style="font-size:8pt" align='center'><%=ht.get("BM_DAY")%></td>
		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("BM_AMT")))%></td>			
		    <td style="font-size:8pt" align='center'><%=ht.get("COST_DAY")%></td>
		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("COST_AMT")))%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("REST_DAY")%></td>
		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("REST_AMT")))%></td>
		  </tr>
  <%		total_amt = total_amt + Long.parseLong(String.valueOf(ht.get("COST_AMT")));
		  	total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ht.get("BM_AMT")));
			total_amt3 = total_amt3 + Long.parseLong(String.valueOf(ht.get("REST_AMT")));
			
			if(String.valueOf(ht.get("INS_COM_ID")).equals("0007")){
				sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("TOT_AMT")));
				sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("BM_AMT")));
				sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("COST_AMT")));
				sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("REST_AMT")));
				cnt1 = cnt1+1;
			}else if(String.valueOf(ht.get("INS_COM_ID")).equals("0008")){
				sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("TOT_AMT")));
				sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("BM_AMT")));
				sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("COST_AMT")));
				sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("REST_AMT")));
				cnt2  = cnt2+1;
			}else if(String.valueOf(ht.get("INS_COM_ID")).equals("0010")){
				sum9   = sum9   + Util.parseLong(String.valueOf(ht.get("TOT_AMT")));
				sum10  = sum10  + Util.parseLong(String.valueOf(ht.get("BM_AMT")));
				sum11  = sum11  + Util.parseLong(String.valueOf(ht.get("COST_AMT")));
				sum12  = sum12  + Util.parseLong(String.valueOf(ht.get("REST_AMT")));
				cnt3 = cnt3+1;
			}else{
				sum13  = sum13  + Util.parseLong(String.valueOf(ht.get("TOT_AMT")));
				sum14  = sum14  + Util.parseLong(String.valueOf(ht.get("BM_AMT")));
				sum15  = sum15  + Util.parseLong(String.valueOf(ht.get("COST_AMT")));
				sum16  = sum16  + Util.parseLong(String.valueOf(ht.get("REST_AMT")));
				cnt4 = cnt4+1;
			}
		  }%>
				<tr>
					<td class="star">&nbsp;</td>
					<td class="star">&nbsp;</td>					
					<td class="star">&nbsp;</td>
					<td class="star">&nbsp;</td>					
					<td class="star">&nbsp;</td>					
					<td class="star">&nbsp;</td>
					<td class="star">&nbsp;</td>	
					<td class="star">&nbsp;</td>
					<td class="star" align='right' style="font-size:8pt" ><%=Util.parseDecimal(total_amt2)%></td>
					<td class="star">&nbsp;</td>
					<td class="star" align='right' style="font-size:8pt" ><%=Util.parseDecimal(total_amt)%></td>
					<td class="star">&nbsp;</td>					
					<td class="star" align='right' style="font-size:8pt" ><%=Util.parseDecimal(total_amt3)%></td>
				</tr>		  
	    </table>
	  </td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>		
	<tr>
	    <td>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td width='100' class=title>보험사</td>
					<td width='100' class=title>건수</td>
        		    <td width='200' class=title>총보험료</td>
        		    <td width='200' class=title >전월누계</td>
					<td width='200' class=title >당월산입</td>
        		    <td width='200' class=title>선급잔액</td>					
       		    </tr>
		        <tr valign="middle" align="center">
		          <td class=title>삼성화재</td>
		          <td align='right'><%=cnt1%></td>
		          <td align='right'><%=Util.parseDecimal(sum1)%></td>
		          <td align='right'><%=Util.parseDecimal(sum2)%></td>
		          <td align='right'><%=Util.parseDecimal(sum3)%></td>
		          <td align='right'><%=Util.parseDecimal(sum4)%></td>
	          </tr>
		        <tr valign="middle" align="center">
		          <td class=title>동부화재</td>
		          <td align='right'><%=cnt2%></td>
		          <td align='right'><%=Util.parseDecimal(sum5)%></td>
		          <td align='right'><%=Util.parseDecimal(sum6)%></td>
		          <td align='right'><%=Util.parseDecimal(sum7)%></td>
		          <td align='right'><%=Util.parseDecimal(sum8)%></td>
	          </tr>
		        <tr valign="middle" align="center">
		          <td class=title>LIG손해</td>
		          <td align='right'><%=cnt3%></td>
		          <td align='right'><%=Util.parseDecimal(sum9)%></td>
		          <td align='right'><%=Util.parseDecimal(sum10)%></td>
		          <td align='right'><%=Util.parseDecimal(sum11)%></td>
		          <td align='right'><%=Util.parseDecimal(sum12)%></td>
	          </tr>
		        <tr valign="middle" align="center">
		          <td class=title>기타</td>
		          <td align='right'><%=cnt4%></td>
		          <td align='right'><%=Util.parseDecimal(sum13)%></td>
		          <td align='right'><%=Util.parseDecimal(sum14)%></td>
		          <td align='right'><%=Util.parseDecimal(sum15)%></td>
		          <td align='right'><%=Util.parseDecimal(sum16)%></td>
	          </tr>
		        <tr valign="middle" align="center">
		          <td align='center' class="star">합계</td>
		          <td align='right' class="star">&nbsp;</td>
		          <td align='right' class="star">&nbsp;</td>
		          <td align='right' class="star"><%=Util.parseDecimal(total_amt2)%></td>
		          <td align='right' class="star"><%=Util.parseDecimal(total_amt)%></td>
		          <td align='right' class="star"><%=Util.parseDecimal(total_amt3)%></td>
	          </tr>
	        </table>
	    </td>
	</tr>		
  </table>
</form>  
</body>
</html>
