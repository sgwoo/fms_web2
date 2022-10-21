<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=s_money_excel.xls");
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
<link rel=stylesheet type="text/css" href="../../include/table.css">
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
	
	Vector vt = ac_db.S_MoneyList(dt, ref_dt1, ref_dt2, gubun1);
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
					<td width='6%' align="center">연번</td>
					<td width='6%' align="center">사원번호</td>
					<td width='10%' align="center">성명</td>
					<td width='13%' align="center">
					<% if (gubun1.equals("9") ) { %>제안포상금 
					<% } else if (gubun1.equals("2") ) { %>영업캠페인포상
					<% } else if (gubun1.equals("1") ) { %>채권캠페인포상
					<% } else if (gubun1.equals("5") ) { %>비용캠페인포상
					<% } else if (gubun1.equals("6") ) { %>제안캠페인포상
					<% } else if (gubun1.equals("30") ) { %>1군비용캠페인포상
					<% } else if (gubun1.equals("29") ) { %>2군비용캠페인포상
					<% } else if (gubun1.equals("8") ) { %>통신비
					<% } %>			
					</td>
					<td class='title' width='17%' align="center" >유류대정산<br>(포상금차감/복지비지급)</td> 
					<td class='title' width='13%' align="center">실지급액</td>
				
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
			
			oil_m_amt = 0;					
			oil_p_amt = 0;					
			pr_amt = 0;		
			
			t_amt1[0] += AddUtil.parseLong(String.valueOf(ht.get("AMT")));
			
				
			if ( AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT"))) < 0) {
				oil_m_amt  = AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT"))); 
				pr_amt  = AddUtil.parseLong(String.valueOf(ht.get("PRIZE"))); 
				t_amt2[0] += AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
				t_amt3[0] +=   AddUtil.parseLong(String.valueOf(ht.get("PRIZE")));
					
			} else {
				oil_p_amt  =   AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT"))); 
				pr_amt  = AddUtil.parseLong(String.valueOf(ht.get("AMT"))); 
				t_amt4[0] += AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
				t_amt3[0] +=   AddUtil.parseLong(String.valueOf(ht.get("AMT")));
			}
%>             	
				<tr>
            		<td width='6%' align="center"><%=i+1%></td>
            		<td width='6%' align="center"><%=ht.get("ID")%></td>
            		<td width='10%' align="center"><%=ht.get("USER_NM")%></td>
            		<td width='13%' align="right"><%=AddUtil.parseDecimal(ht.get("AMT"))%></td>
            		<td width='17%' align="right"></td> 
               	<!--<td width='17%' align="right"><%=AddUtil.parseDecimal(oil_m_amt)%><br>
               								<%=AddUtil.parseDecimal(oil_p_amt)%></td>  -->
            		<td width='13%' align="right"><%=AddUtil.parseDecimal(pr_amt)%></td>
            		
            	</tr>
<%} %>
	   <tr>
            		<td class=title  colspan=3 align="center">계</td>
            		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%></td>
            	 	<td class=title style="text-align:right"></td> 
            <!--		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt2[0])%><br>
            										<%=Util.parseDecimal(t_amt4[0])%></td> -->
            		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%></td>
            		
            	</tr>
<% }else{%>                  	
	            <tr>
    	            <td colspan=7  align=center height=25>등록된 데이타가 없습니다.</td>
        	    </tr>
<%}%>        	    
            </table>
        </td>
    </tr>
</table>
</body>
</html>
