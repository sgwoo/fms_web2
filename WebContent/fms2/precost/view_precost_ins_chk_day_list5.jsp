<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�Ⱓ���
	function view_ins_scd_list(cost_ym, car_use, com_id, pay_dt, pay_st){
		window.open('view_precost_ins_chk_day_list_sub5.jsp?cost_ym='+cost_ym+'&car_use='+car_use+'&com_id='+com_id+'&pay_dt='+pay_dt+'&pay_st='+pay_st, "PRECOST_SUB_LIST", "left=0, top=0, width=800, height=768, scrollbars=yes, status=yes, resize");
	}
	
	function view_ins_chk_day4(cost_ym, car_use, com_id){
		window.open('view_precost_ins_chk_day_list4.jsp?cost_ym='+cost_ym+'&car_use='+car_use+'&com_id='+com_id, "PRECOST_LIST_"+cost_ym+car_use+com_id, "left=0, top=0, width=950, height=768, scrollbars=yes, status=yes, resize");
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String cost_ym = request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String car_use = request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	
	Vector vts = ai_db.getInsurPrecostYmChkDayList5(cost_ym, car_use, com_id);
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�߻������ ���� ����Ʈ (���谡���� ����)</span>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
        	<a href="javascript:view_ins_chk_day4('<%=cost_ym%>','<%=car_use%>','<%=com_id%>')"> -> [��������� ����]</a></td>
    </tr>  
    <%if(com_id.equals("")){%>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width="5%" rowspan="2" class=title>����</td>
		    <td width="5%" rowspan="2" class=title>�����</td>
		    <td width="10%" rowspan="2" class=title>��¥</td>
		    <td width="10%" rowspan="2" class=title >����+�߰�</td>	
		    <td colspan="2" class=title >����<br>(�ű�/����)</td>
		    <td colspan="2" class=title >�߰�<br>(�㺸����)</td>
		    <td width="10%" rowspan="2" class=title >����+�߰�</td>
		    <td colspan="2" class=title >����ȯ��</td>
		    <td colspan="2" class=title >�߰�ȯ��</td>
	      </tr>
		  <tr valign="middle" align="center">
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);
				%>
		        <tr> 
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%//=ht.get("COM_NM")%></td>
        		    <td align='center'><%=ht.get("B_DT2")%></td>
        		    <td align='right'><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT1")))+Util.parseLong(String.valueOf(ht.get("AMT2"))))%></td>
        		    <td align='center'><%=ht.get("CNT1")%></td>		
        		    <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%//=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','0')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%></a></td>
        		    <td align='center'><%=ht.get("CNT2")%></td>
        		    <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%//=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','1')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%></a></td>
        		    <td align='right'><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT3")))+Util.parseLong(String.valueOf(ht.get("AMT4"))))%></td>        		    	
        		    <td align='center'><%=ht.get("CNT3")%></td>
		            <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%//=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','2')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%></a></td>
        		    <td align='center'><%=ht.get("CNT4")%></td>
		            <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%//=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','3')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%></a></td>
		        </tr>
  <%			
  			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("AMT4")));
			
  			sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("AMT4")));
  		}%>
		        <tr> 
        		    <td class=star align='center'></td>
        		    <td class=star align='center'>�հ�</td>
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum1+sum2)%></td>
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum1)%></td>
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum2)%></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum3+sum4)%></td>
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum3)%></td>
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum4)%></td>
		        </tr>  
	        </table>
	    </td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>		    
    <%}else{%>
    <tr>
        <td >[ ����ī�������� ]</td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width="5%" rowspan="2" class=title>����</td>
		    <td width="10%" rowspan="2" class=title>�����</td>
		    <td width="10%" rowspan="2" class=title>��¥</td>
		    <td width="10%" rowspan="2" class=title >����+�߰�</td>			
		    <td colspan="2" class=title >����<br>(�ű�/����)</td>
		    <td colspan="2" class=title >�߰�<br>(�㺸����)</td>
		    <td width="10%" rowspan="2" class=title >����+�߰�</td>
		    <td colspan="2" class=title >����ȯ��</td>			
		    <td colspan="2" class=title >�߰�ȯ��</td>						
	      </tr>
		  <tr valign="middle" align="center">
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		  </tr>
<%		sum1 = 0;
		sum2 = 0;
		sum3 = 0;
		sum4 = 0;
		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);
				if(!String.valueOf(ht.get("INS_COM_ID")).equals("0008")&&!String.valueOf(ht.get("INS_COM_ID")).equals("0007")){%>
		        <tr> 
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("COM_NM")%></td>
        		    <td align='center'><%=ht.get("B_DT2")%></td>
        		    <td align='right'><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT1")))+Util.parseLong(String.valueOf(ht.get("AMT2"))))%></td>					
        		    <td align='center'><%=ht.get("CNT1")%></td>		
        		    <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','0')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%></a></td>
        		    <td align='center'><%=ht.get("CNT2")%></td>
        		    <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','1')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%></a></td>
                <td align='right'><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT3")))+Util.parseLong(String.valueOf(ht.get("AMT4"))))%></td>        		    		
        		    <td align='center'><%=ht.get("CNT3")%></td>
		            <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','2')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%></a></td>
        		    <td align='center'><%=ht.get("CNT4")%></td>
		            <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','3')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%></a></td>
		        </tr>
  <%			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("AMT4")));
			
  			sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("AMT4")));
  		}}%>
		        <tr> 
        		    <td class=star align='center'></td>
        		    <td class=star align='center'>�հ�</td>
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum1+sum2)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum1)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum2)%></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum3+sum4)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum3)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum4)%></td>					
		        </tr>  
	        </table>
	    </td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>		
    <tr>
        <td >[ ����ȭ�� ]</td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width="5%" rowspan="2" class=title>����</td>
		    <td width="8%" rowspan="2" class=title>�����</td>
		    <td width="10%" rowspan="2" class=title>��¥</td>
		    <td width="10%" rowspan="2" class=title >����+�߰�</td>			
		    <td colspan="2" class=title >����<br>(�ű�/����)</td>
		    <td colspan="2" class=title >�߰�<br>(�㺸����)</td>
		    <td width="10%" rowspan="2" class=title >����+�߰�</td>
		    <td colspan="2" class=title >����ȯ��</td>			
		    <td colspan="2" class=title >�߰�ȯ��</td>						
	      </tr>
		  <tr valign="middle" align="center">
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		  </tr>
<%		
		sum1 = 0;
		sum2 = 0;
		sum3 = 0;
		sum4 = 0;
		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);
				if(String.valueOf(ht.get("INS_COM_ID")).equals("0008")){%>
		        <tr> 
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("COM_NM")%></td>
        		    <td align='center'><%=ht.get("B_DT2")%></td>
        		    <td align='right'><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT1")))+Util.parseLong(String.valueOf(ht.get("AMT2"))))%></td>					
        		    <td align='center'><%=ht.get("CNT1")%></td>		
        		    <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','0')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%></a></td>
        		    <td align='center'><%=ht.get("CNT2")%></td>
        		    <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','1')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%></a></td>
                <td align='right'><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT3")))+Util.parseLong(String.valueOf(ht.get("AMT4"))))%></td>        		    	
        		    <td align='center'><%=ht.get("CNT3")%></td>
		            <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','2')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%></a></td>
        		    <td align='center'><%=ht.get("CNT4")%></td>
		            <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','3')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%></a></td>
		        </tr>
  <%		sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("AMT4")));
			
  			sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("AMT4")));
  		}}%>
		        <tr> 
        		    <td class=star align='center'></td>
        		    <td class=star align='center'>�հ�</td>
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum1+sum2)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum1)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum2)%></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum3+sum4)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum3)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum4)%></td>					
		        </tr>  
	        </table>
	    </td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>		
    <tr>
        <td >[ �Ｚȭ��/��Ÿ ����� ]</td>
    </tr>	
     <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width="5%" rowspan="2" class=title>����</td>
		    <td width="8%" rowspan="2" class=title>�����</td>
		    <td width="10%" rowspan="2" class=title>��¥</td>
		    <td width="10%" rowspan="2" class=title >����+�߰�</td>			
		    <td colspan="2" class=title >����<br>(�ű�/����)</td>
		    <td colspan="2" class=title >�߰�<br>(�㺸����)</td>
		    <td width="10%" rowspan="2" class=title >����+�߰�</td>
		    <td colspan="2" class=title >����ȯ��</td>			
		    <td colspan="2" class=title >�߰�ȯ��</td>						
	      </tr>
		  <tr valign="middle" align="center">
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		    <td width="5%" class=title >�Ǽ�</td>
		    <td width="10%" class=title >�ݾ�</td>
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);
				if(String.valueOf(ht.get("INS_COM_ID")).equals("0007")){%>
		        <tr> 
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("COM_NM")%></td>
        		    <td align='center'><%=ht.get("B_DT2")%></td>
        		    <td align='right'><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT1")))+Util.parseLong(String.valueOf(ht.get("AMT2"))))%></td>					
        		    <td align='center'><%=ht.get("CNT1")%></td>		
        		    <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','0')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%></a></td>
        		    <td align='center'><%=ht.get("CNT2")%></td>
        		    <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','1')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%></a></td>
       		    	<td align='right'><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT3")))+Util.parseLong(String.valueOf(ht.get("AMT4"))))%></td>        		    	
        		    <td align='center'><%=ht.get("CNT3")%></td>
		            <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','2')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%></a></td>
        		    <td align='center'><%=ht.get("CNT4")%></td>
		            <td align='right'><a href="javascript:view_ins_scd_list('<%=cost_ym%>','<%=car_use%>','<%=ht.get("INS_COM_ID")%>','<%=ht.get("B_DT2")%>','3')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%></a></td>
		        </tr>
  <%			
  			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("AMT4")));
			
  			sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("AMT2")));
			sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("AMT3")));
			sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("AMT4")));
  		}}%>
		        <tr> 
        		    <td class=star align='center'></td>
        		    <td class=star align='center'>�հ�</td>
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum1+sum2)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum1)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum2)%></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum3+sum4)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum3)%></td>					
        		    <td class=star align='center'></td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum4)%></td>					
		        </tr>  
	        </table>
	    </td>
	</tr>
   
	<tr>
		<td>&nbsp;</td>	
	</tr>		
	<tr>
		<td>&nbsp;</td>	
	</tr>		
    <tr>
        <td >[ ��ü ]</td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>         		    
        		    <td class=star align='center'>�հ�</td>
        		    <td class=star align='right'><%=Util.parseDecimal(sum5+sum6)%></td>					
        		    <td class=star align='right'><%=Util.parseDecimal(sum5)%></td>					
        		    <td class=star align='right'><%=Util.parseDecimal(sum6)%></td>					
        		    <td class=star align='right'><%=Util.parseDecimal(sum7+sum8)%></td>					
        		    <td class=star align='right'><%=Util.parseDecimal(sum7)%></td>					        		    
        		    <td class=star align='right'><%=Util.parseDecimal(sum8)%></td>					
		        </tr>  
	        </table>
	    </td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>
    <%}%>						
</table>
</form>  
</body>
</html>
