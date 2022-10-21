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
	String cost_ym 	= request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String pay_yn 	= request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	String car_use  = request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String tm_st1   = request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	
	Vector vts = new Vector();
	int vt_size = 0;
	
	//����� ����Ʈ
	vts = ai_db.getInsurScdYmList2(cost_ym, pay_yn, car_use, tm_st1);
	vt_size = vts.size();
	
	//����� ����Ʈ
	Vector vts2 =  ai_db.getInsurScdYmStat2(cost_ym, pay_yn, car_use, tm_st1);
	int vt_size2 = vts2.size();
%>
<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� <%if(pay_yn.equals("0")){%>�̳�<%}else{%>����<%}%> ����Ʈ </span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td width='30' rowspan="2" class=title>����</td>
        		    <td colspan="2" class=title>������ȣ</td>
        		    <td colspan="2" class=title >�Ⱓ</td>
        		    <td rowspan="2" width='70' class=title>�����</td>					
        		    <td rowspan="2" width='80' class=title>�Ѻ����</td>
        		    <td rowspan="2" width='30' class=title>����</td>
        		    <td rowspan="2" width='30' class=title>ȸ��</td>			
        		    <td rowspan="2" width='80' class=title>�����</td>			
        		    <td rowspan="2" width='80' class=title>������</td>
        		    <td rowspan="2" width='80' class=title>������</td>			
	            </tr>
		        <tr valign="middle" align="center">
        		    <td width='80' class=title>����</td>		  
        		    <td width='80' class=title>����</td>		  			
        		    <td width="80" class=title>from</td>
        		    <td width="80" class=title>to</td>
		        </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
		        <tr> 
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("CAR_NO")%></td>
        		    <td align='center'><%=ht.get("FIRST_CAR_NO")%></td>			
        		    <td align='center'><%=ht.get("INS_START_DT")%></td>
        		    <td align='center'><%=ht.get("INS_EXP_DT")%></td>			
        		    <td align='center'><%=ht.get("INS_COM_NM")%></td>								
        		    <td align='right'><%=ht.get("TOT_AMT")%></td>
        		    <td align='center'><%=ht.get("INS_TM2")%></td>
        		    <td align='center'><%=ht.get("INS_TM")%>ȸ</td>			
        		    <td align='right'><%=ht.get("PAY_AMT")%></td>
        		    <td align='center'><%=ht.get("INS_EST_DT")%></td>
        		    <td align='center'><%=ht.get("PAY_DT")%></td>
		        </tr>
  <%		total_amt = total_amt + AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
		  }%>
				<tr>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>					
				</tr>		  
	        </table>
	    </td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>		
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td width='190' rowspan="2" class=title>�����</td>
        		    <td colspan="2" class=title>�հ�</td>
        		    <td colspan="2" class=title >�����</td>
        		    <td colspan="2" class=title>ȯ�޺����</td>					
       		    </tr>
		        <tr valign="middle" align="center">
        		    <td width='70' class=title>�Ǽ�</td>		  
        		    <td width='140' class=title>�ݾ�</td>		  			
        		    <td width='70' class=title>�Ǽ�</td>
        		    <td width='130' class=title>�ݾ�</td>
        		    <td width='70' class=title>�Ǽ�</td>
        		    <td width='130' class=title>�ݾ�</td>
		        </tr>
<%		for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);%>								
		        <tr valign="middle" align="center">
		          <td class=title><%=ht.get("INS_COM_NM")%></td>
		          <td><%=ht.get("CNT0")%>��</td>
		          <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("AMT0")))%>��</td>
		          <td><%=ht.get("CNT1")%>��</td>
		          <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>��</td>
		          <td><%=ht.get("CNT2")%>��</td>
		          <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>��</td>
	          </tr>
<%		}%>			  
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
