<%@ page language="java" contentType="text/html;charset=euc-kr" %>
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
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String cost_ym = request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String cost_st = request.getParameter("cost_st")==null?"":request.getParameter("cost_st");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	Vector vts = new Vector();
	int vt_size = 0;
	
	vts = ai_db.getExpPrecostYmList(cost_ym, cost_st);
	vt_size = vts.size();
%>
<form name='form1' method='post'>
  <table border="0" cellspacing="0" cellpadding="0" width=680>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기간비용 리스트<span></td>
    </tr>  
    <tr>
        <td>&nbsp;&nbsp;&nbsp;○ <%if(cost_st.equals("2")){%>보험료<%}else{%>자동차세<%}%>
	    </td>
    </tr>
    <tr>
        <td align="right"><a href="view_precost_exp_excel.jsp?cost_ym=<%=cost_ym%>&cost_st=<%=cost_st%>" target="_blank"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
	    </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
    		    <tr valign="middle" align="center"> 
        		    <td width='30' rowspan="2" class=title>연번</td>
        		    <td colspan="2" class=title>차량번호</td>
        		    <td colspan="2" class=title >기간</td>
        		    <td colspan="2" class=title>전월누계</td>
        		    <td colspan="2" class=title>당월산입</td>
        		    <td colspan="2" class=title>선급잔액</td>
    	        </tr>
    		    <tr valign="middle" align="center">
        		    <td width='90' class=title>현재</td>		  
        		    <td width='90' class=title>납부/최초</td>		  			
        		    <td width="70" class=title>from</td>
        		    <td width="70" class=title>to</td>
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
        		    <td style="font-size:8pt" align='center'><%=ht.get("EXP_START_DT")%></td>
        		    <td style="font-size:8pt" align='center'><%=ht.get("EXP_END_DT")%></td>			
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
		  }%>
				<tr>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>	
					<td class="title">&nbsp;</td>
					<td class="title" style='text-align:right' style="font-size:8pt" ><%=Util.parseDecimal(total_amt2)%></td>
					<td class="title">&nbsp;</td>
					<td class="title" style='text-align:right' style="font-size:8pt" ><%=Util.parseDecimal(total_amt)%></td>
					<td class="title">&nbsp;</td>					
					<td class="title" style='text-align:right' style="font-size:8pt" ><%=Util.parseDecimal(total_amt3)%></td>
				</tr>		  
	    </table>
	  </td>
	</tr>
	<tr>
		<td align='right'>
		  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>	
</table>
</form>  
</body>
</html>
