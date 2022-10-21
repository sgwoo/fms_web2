<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//기간비용
	function view_ins_scd_list(cost_ym, com_id, pay_dt, pay_st){
		window.open('view_precost_ins_chk_day_list_sub.jsp?cost_ym='+cost_ym+'&com_id='+com_id+'&pay_dt='+pay_dt+'&pay_st='+pay_st, "PRECOST_SUB_LIST", "left=0, top=0, width=800, height=768, scrollbars=yes, status=yes, resize");
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String cost_ym 	= request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String car_use 	= request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String com_id 	= request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String pay_dt 	= request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	String pay_st 	= request.getParameter("pay_st")==null?"":request.getParameter("pay_st");
	
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	
	Vector vts = ai_db.getInsurPrecostYmChkDayListSub(cost_ym, car_use, com_id, pay_dt, pay_st);
	int vt_size = vts.size();
	
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
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>납부보험료 점검 리스트</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width="5%" class=title>연번</td>
		    <td width="5%" class=title>용도</td>			
		    <td width="10%" class=title>차량번호</td>
		    <td width="15%" class=title>차명</td>			
		    <td width="15%" class=title>증권번호</td>
		    <td width="10%" class=title >보험시작일</td>			
		    <td width="10%" class=title >구분</td>
		    <td width="10%" class=title >발생일자</td>			
		    <td width="10%" class=title >납부일자</td>						
		    <td width="10%" class=title >금액</td>
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);
				//if(String.valueOf(ht.get("INS_COM_ID")).equals("0007")){%>
		        <tr> 
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("CAR_USE")%></td>
        		    <td align='center'><%=ht.get("CAR_NO")%></td>					
        		    <td align='center'><%=ht.get("CAR_NM")%></td>					
        		    <td align='center'><%=ht.get("INS_CON_NO")%></td>										
        		    <td align='center'><%=ht.get("INS_START_DT")%></td>
        		    <td align='center'><%if(pay_st.equals("0")){%>가입<%}else if(pay_st.equals("1")){%>추가<%}else if(pay_st.equals("2")){%>해지환급<%}else if(pay_st.equals("3")){%>추가환급<%}%></td>
        		    <td align='center'><%=ht.get("B_DT2")%></td>		
        		    <td align='center'><%=ht.get("PAY_DT")%></td>										
        		    <td align='right'><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("PAY_AMT"))))%></td>										
       		    </tr>
  <%		sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("PAY_AMT")));
  		}//}%>
		        <tr> 
        		    <td class=star align='center'></td>
        		    <td class=star align='center'></td>					
        		    <td class=star align='center'>합계</td>
        		    <td class=star align='center'></td>
        		    <td class=star align='center'></td>
        		    <td class=star align='center'></td>
        		    <td class=star align='center'></td>
        		    <td class=star align='center'></td>
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum1)%></td>					
       		    </tr>  
	        </table>
	    </td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>				
</table>
</form>  
</body>
</html>
