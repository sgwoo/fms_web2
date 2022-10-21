<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=view_precost_exp_excel.xls");
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
        <td>&lt; �Ⱓ��� ����Ʈ &gt; </td>
    </tr>  
    <tr>
        <td>&nbsp;&nbsp;&nbsp;�� <%if(cost_st.equals("2")){%>�����<%}else{%>�ڵ�����<%}%>
	    </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td>
	        <table border="1" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td width='30' rowspan="2" class=title>����</td>
        		    <td colspan="2" class=title>������ȣ</td>
        		    <td colspan="2" class=title >�Ⱓ</td>
        		    <td colspan="2" class=title>��������</td>
        		    <td colspan="2" class=title>�������</td>
        		    <td colspan="2" class=title>�����ܾ�</td>
	            </tr>
		        <tr valign="middle" align="center">
        		    <td width='90' class=title>����</td>		  
        		    <td width='90' class=title>����/����</td>		  			
        		    <td width="70" class=title>from</td>
        		    <td width="70" class=title>to</td>
        	        <td width="30" class=title>�ϼ�</td>
        	        <td width="80" class=title>�ݾ�</td>
        		    <td width="30" class=title>�ϼ�</td>
        		    <td width="80" class=title>�ݾ�</td>
        		    <td width="30" class=title>�ϼ�</td>
        		    <td width="80" class=title>�ݾ�</td>
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
</table>
</form>  
</body>
</html>
