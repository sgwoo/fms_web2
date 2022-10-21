<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_car_exp(car_mng_id){
		window.open('view_exp_car_list.jsp?car_mng_id='+car_mng_id, "VIEW_EXP_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");
	}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String cost_ym 	= request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String pay_yn 	= request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	String car_ext 	= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	Vector vts = new Vector();
	int vt_size = 0;
	
	//�ڵ����� ����Ʈ
	if(cost_ym.equals("rtn")){
		vts = ai_db.getExpRtnScdYmList("", pay_yn, car_ext);
		vt_size = vts.size();
	}else{
		vts = ai_db.getExpScdYmList(cost_ym, pay_yn, car_ext);
		vt_size = vts.size();
	}
%>
<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ����� <%if(cost_ym.equals("rtn")){%>ȯ��<%}else{%><%if(pay_yn.equals("0")){%>�̳�<%}else{%>����<%}%><%}%> ����Ʈ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr> 
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td width='40' rowspan="2" class=title>����</td>
        		    <td colspan="3" class=title>������ȣ</td>
        		    <td colspan="2" class=title >�Ⱓ</td>
        		    <td colspan="3" class=title>�ڵ�����</td>
        		    <td rowspan="2" width='75' class=title>����<%if(pay_yn.equals("0")){%>����<%}%>����</td>
        		    <td rowspan="2" width='75' class=title>ȯ�޻�����</td>			
        		    <td rowspan="2" width='70' class=title>ȯ������</td>			
        		    <td rowspan="2" width='75' class=title>ȯ�޽�û��</td>		
        		    <td width='40' rowspan="2" class=title>����</td>				
	            </tr>
		        <tr valign="middle" align="center">
        		    <td width='85' class=title>���δ��</td>		  
        		    <td width='85' class=title>����</td>		  
        		    <td width='85' class=title>����</td>		  			
        		    <td width="70" class=title>from</td>
        		    <td width="70" class=title>to</td>
        		    <td width='95' class=title>����</td>		  
        		    <td width='80' class=title>ȯ��<%if(cost_ym.equals("rtn")){%>����<%}%></td>		  
        		    <td width='95' class=title>��</td>		  			
			
		        </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
		        <tr> 
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=i+1%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("EXP_CAR_NO")%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><a href="javascript:view_car_exp('<%=ht.get("CAR_MNG_ID")%>')"><%=ht.get("CAR_NO")%></a></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("FIRST_CAR_NO")%></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("EXP_START_DT")%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("EXP_END_DT")%></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("EXP_AMT")))%>��&nbsp;</td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("RTN_AMT")))%>��&nbsp;</td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("R_EXP_AMT")))%>��&nbsp;</td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%if(pay_yn.equals("0")){%><%=ht.get("EXP_EST_DT")%><%}else{%><%=ht.get("EXP_DT")%><%}%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("RTN_CAU_DT")%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("RTN_DT")%></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("RTN_REQ_DT")%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("CAR_EXT_NM")%></td>			
		        </tr>
  <%		total_amt = total_amt + Long.parseLong(String.valueOf(ht.get("EXP_AMT")));
		  	total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ht.get("RTN_AMT")));
  			total_amt3 = total_amt3 + Long.parseLong(String.valueOf(ht.get("R_EXP_AMT")));
		  }%>
				<tr>
					<td class="p">&nbsp;</td>
					<td class="p">&nbsp;</td>					
					<td class="p">&nbsp;</td>
					<td class="p">&nbsp;</td>
					<td class="p">&nbsp;</td>					
					<td class="p">&nbsp;</td>										
					<td class="p" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��&nbsp;</td>
					<td class="p"  style='text-align:right'><%=Util.parseDecimal(total_amt2)%>��&nbsp;</td>
					<td class="p"  style='text-align:right'><%=Util.parseDecimal(total_amt3)%>��&nbsp;</td>
					<td class="p">&nbsp;</td>					
					<td class="p">&nbsp;</td>					
					<td class="p">&nbsp;</td>					
					<td class="p">&nbsp;</td>										
					<td class="p">&nbsp;</td>															
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
