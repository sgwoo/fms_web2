<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=settle_account_list_excel17.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSettleAccount_list17(settle_year);
	int vt_size = vt.size();
	
	
	long total_amt1	= 0;
	
	long total_amt[] = new long[10];
	
	

%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td align="center"><%=AddUtil.parseInt(settle_year)+1%>��  1�� �뿩��û������Ʈ ���Ⱓ �⵵���ݾ�</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td width="50" rowspan='2' class="title">����</td>
				  <td width="100" rowspan='2' class="title">������ȣ</td>
				  <td width="100" rowspan='2' class="title">�뵵����</td>
				  <td colspan='2' class="title">�����Ⱓ</td>				  
				  <td width="100" rowspan='2' class="title">û������</td>
				  <td colspan='3' class="title">�뿩��</td>
				  <td colspan='2' class="title">���Ⱓ</td>
				  <td colspan='3' class="title">�ϼ�</td>
				  <td colspan='3' class="title">���ް�</td>
			    </tr>
			    <tr>
			      <td width="100" class="title">�뿩������</td>
				  <td width="100" class="title">�뿩������</td>
				  <td width="100" class="title">���ް�</td>
				  <td width="100" class="title">�ΰ���</td>
				  <td width="100" class="title">���ް�</td>
				  <td width="100" class="title">������</td>
				  <td width="100" class="title">������</td>
				  <td width="100" class="title">���ϼ�</td>
				  <td width="100" class="title"><%=AddUtil.parseInt(settle_year)%>�⵵</td>
				  <td width="100" class="title"><%=AddUtil.parseInt(settle_year)+1%>�⵵</td>
				  <td width="100" class="title"><%=AddUtil.parseInt(settle_year)%>�⵵</td>
				  <td width="100" class="title"><%=AddUtil.parseInt(settle_year)+1%>�⵵</td>
			    </tr>			    
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					total_amt1	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					
					if( String.valueOf(ht.get("CAR_ST")).equals("��Ʈ")){
						total_amt[0]	= total_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					}
					if( String.valueOf(ht.get("CAR_ST")).equals("����")){
						total_amt[1]	= total_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					}
					
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("CAR_NO")%></td>
				  <td align="center"><%=ht.get("CAR_ST")%></td>
				  <td align="center"><%=ht.get("RENT_START_DT")%></td>
				  <td align="center"><%=ht.get("RENT_END_DT")%></td>
				  <td align="center"><%=ht.get("TAX_OUT_DT")%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("FEE_V_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT"))))%></td>
				  <td align="center"><%=ht.get("USE_S_DT")%></td>
				  <td align="center"><%=ht.get("USE_E_DT")%></td>
				  <td align="center"><%=ht.get("TDAY")%></td>
				  <td align="center"><%=ht.get("DAY1")%></td>
				  <td align="center"><%=ht.get("DAY2")%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT1"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT2"))))%></td>
			    </tr>
			    <%	}%>	
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
				  <td class="title">&nbsp;</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
			    </tr>		    
			</table>
		</td>
	</tr>
	<tr>
	  <td>&nbsp;(���ް�)</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			          <td class="title">����</td>
				  <td class="title">�ݾ�</td>				  
			    </tr>	
			    <tr>
			          <td class="title">��Ʈ</td>
				  <td align="right"><%=Util.parseDecimal(total_amt[0])%></td>				  
			    </tr>	
			    <tr>
			          <td class="title">����</td>
				  <td align="right"><%=Util.parseDecimal(total_amt[1])%></td>				  
			    </tr>	
			    <tr>
			          <td class="title">�հ�</td>
				  <td align="right"><%=Util.parseDecimal(total_amt[0]+total_amt[1])%></td>				  
			    </tr>	
			</table>
		</td>
	</tr>			    
  </table>
</form>
</body>
</html>
