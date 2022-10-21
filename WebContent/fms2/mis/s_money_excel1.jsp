<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=s_money_excel1.xls");
%>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">

<body>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String gubun1		= request.getParameter("gubun1")==null?"9":request.getParameter("gubun1");
	// System.out.println("gubun1=" + gubun1);
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = ac_db.S_MoneyList1(dt, ref_dt1, ref_dt2, gubun1);
	int vt_size = vt.size();
	
	long t_amt1[] = new long[1];
	long t_amt2[] = new long[1];
	long t_amt3[] = new long[1];
	long t_amt4[] = new long[1];
	
	long oil_m_amt = 0;
	long oil_p_amt = 0;

	long pr_amt = 0;
%>

<table border="1" cellspacing="0" cellpadding="1" width='500' bordercolor="#000000">
	<tr> 
		<td>
			<table border="1" cellspacing="0" cellpadding="1" width='100%' bordercolor="#000000">
				<tr> 
									
					<td width='6%' align="center"> 은행코드</td>
			   		<td width='20%' align="center"> 계좌번호</td>
					<td width='10%' align="center"> 입금인성명</td>
					<td width='15%' align="center"> &nbsp;&nbsp;&nbsp;&nbsp;입금액&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td width='10%' align="center">출금통장표시</td>
					<td width='15%' align="center">입금통장표시</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table border="1" cellspacing="0" cellpadding="1" width='100%' bordercolor="#000000">
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
		
			pr_amt  = AddUtil.parseLong(String.valueOf(ht.get("PRIZE"))); 	
			
		         if  ( pr_amt   < 1)  continue;
		         							
			
%>             	
				<tr>
		            		
		            		<td width='6%' align="center"><%=ht.get("BANK")%></td>
		            		<td width='20%' align="center"  style="mso-number-format:0"><%=AddUtil.parseLong(String.valueOf(ht.get("BANK_NO")))%> </td>
		            		<td width='10%' align="center"><%=ht.get("USER_NM")%></td>
		            		<td width='15%' align="center"><%=AddUtil.parseDecimal(pr_amt)%></td>
		            		<td width='10%' align="center"><%=ht.get("USER_NM")%></td>
		            		<td width='15%' align="center">
		            		<% if (gubun1.equals("9") ) { %>제안포상금 
					<% } else if (gubun1.equals("2") ) { %>영업캠페인
					<% } else if (gubun1.equals("1") ) { %>채권캠페인
					<% } else if (gubun1.equals("5") ) { %>비용캠페인
					<% } else if (gubun1.equals("6") ) { %>제안캠페인
					<% } else if (gubun1.equals("30") ) { %>1군비용캠페인
					<% } else if (gubun1.equals("29") ) { %>2군비용캠페인
					<% } else if (gubun1.equals("8") ) { %>통신비
					<% } %></td>		            		
		            	</tr>
<%}
}else{%>            	
	            <tr>
    	            <td colspan=4 align=center height=25>등록된 데이타가 없습니다.</td>
        	    </tr>
<%}%>        	    
            </table>
        </td>
    </tr>
</table>
</body>
</html>
