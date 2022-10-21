<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.insur.*"%>
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
	String car_ext 	= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//��� �ڵ����� ����
	Vector vt = ai_db.getExpCheckList(car_ext, gubun1, mode);
	int vt_size = vt.size();
%>
<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=1620>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ����� ��� ���� ����Ʈ</span></td>
    </tr>  
    <tr>
        <td>&nbsp;&nbsp;&nbsp;�� ���� : <%=c_db.getNameByIdCode("0032", "", car_ext)%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td width='30' rowspan="2" class=title>����</td>
        		    <td width='90' rowspan="2" class=title>������ȣ</td>
        		    <td width='80' rowspan="2" class=title>���ι�ȣ</td>			
        		    <td width='130' rowspan="2" class=title >����</td>
        		    <td width='80' rowspan="2" class=title>���ʵ����</td>
        		    <td colspan="4" class=title>��꺯��</td>
        		    <td colspan="7" class=title>�����</td>
        		    <td colspan="3" class=title>������</td>
        		    <td colspan="3" class=title>�Ⱓ����</td>			
	            </tr>
		        <tr valign="middle" align="center">
        		    <td width='60' class=title>����</td>		  
        		    <td width='60' class=title>�뵵</td>		  
        		    <td width='60' class=title>����</td>		  			
        		    <td width="60" class=title>��ⷮ/<br>���緮</td>
        		    <td width="80" class=title>���⼼��</td>			
        		    <td width="50" class=title>����<br>�氨</td>
        		    <td width="50" class=title>����<br>�氨</td>									
        		    <td width="80" class=title>�ڵ�����</td>
        		    <td width='80' class=title>���汳����</td>		  
        		    <td width='100' class=title>�հ輼��</td>
        		    <td width='100' class=title>����</td>			
        		    <td width='80' class=title>�ݾ�</td>
        		    <td width='80' class=title>�����Ⱓ1</td>
        		    <td width='80' class=title>�����Ⱓ2</td>			
        		    <td width='80' class=title>���������</td>
        		    <td width='50' class=title>�ʰ���</td>			
        		    <td width='50' class=title>���</td>
		        </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		        <tr> 
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=i+1%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><a href="javascript:view_car_exp('<%=ht.get("CAR_MNG_ID")%>')"><%=ht.get("CAR_NO")%></a></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("EXP_CAR_NO")%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("CAR_NM")%></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("INIT_REG_DT")%></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("CAR_EXT")%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("CAR_USE")%></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("CAR_ST")%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><%if(String.valueOf(ht.get("CAR_ST")).equals("ȭ��")){%><%=Util.parseDecimal(String.valueOf(ht.get("MAX_KG")))%>kg<%}else{%><%=Util.parseDecimal(String.valueOf(ht.get("DPM")))%>cc<%}%>&nbsp;</td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><span title="r_day1=<%=ht.get("R_DAY1")%>/r_day2=<%=ht.get("R_DAY2")%>/car_per=<%=ht.get("CAR_PER")%>/pay_per=<%=ht.get("PAY_PER")%>"><%=Util.parseDecimal(String.valueOf(ht.get("BAC_TAX")))%>��&nbsp;</span></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("CAR_PER")%></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("PAY_PER")%></td>						
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CAR_TAX")))%>��&nbsp;</td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("EDU_TAX")))%>��&nbsp;</td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TOT_TAX")))%>��&nbsp;</td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><font color=red><%=Util.parseDecimal(String.valueOf(ht.get("DLF_TAX")))%>��&nbsp;</font></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("EXP_AMT")))%>��&nbsp;</td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("EXP_gT_DT")%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("EXP_END_DT")%></td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("NEXT_EXP_gT_DT")%></td>
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("DLF_DT")%>��</td>			
        		    <td <%if(!String.valueOf(ht.get("CLIENT_ID")).equals("")){%>class=g<%}%> align='center'><%=ht.get("DT_CHK")%></td>			
		        </tr>
  <%		if(!String.valueOf(ht.get("TOT_TAX")).equals("")){
	  			total_amt = total_amt + Long.parseLong(String.valueOf(ht.get("TOT_TAX")));
 		 		total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ht.get("DLF_TAX")));
			  	total_amt3 = total_amt3 + Long.parseLong(String.valueOf(ht.get("EXP_AMT")));
			}
		  }%>
				<tr>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>										
					<td class="title">&nbsp;</td>										
					<td class="title">&nbsp;</td>										
					<td class="title">&nbsp;</td>	
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>	
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>															
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��&nbsp;</td>
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>��&nbsp;</td>					
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%>��&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
				</tr>		  
	        </table>
	    </td>
	</tr>
	<tr>
		<td align='right'>
		  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></a>
		</td>	
	</tr>	
</table>
</form>  
</body>
</html>
