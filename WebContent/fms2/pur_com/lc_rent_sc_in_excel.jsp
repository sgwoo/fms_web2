<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=lc_rent_sc_in_excel.xls");
%>

<%@ page import="java.util.*, acar.util.*, acar.car_office.* "%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	int count =0;
	
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
			
	Vector vt = umd.getPurComLcRentList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<% int col_cnt = 15;%>
<table border="0" cellspacing="0" cellpadding="0" width='1500'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(주)아마존카 자동차납품 신규계약 리스트 (<%=AddUtil.getDate()%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='1450'>
            <tr>                                        
                <td width='100' align='center' style="font-size : 8pt;">아마존카<br>계약번호</td>
                <td width='100' align='center' style="font-size : 8pt;">제조사<br>계약번호</td>
                <td width='100' align='center' style="font-size : 8pt;">배정예정일</td>
                <td width='100' align='center' style="font-size : 8pt;">출고지</td>
                <td width='100' align='center' style="font-size : 8pt;">차명</td>                    
        	    <td width="100" align='center' style="font-size : 8pt;">선택사양</td>
        	    <td width="100" align='center' style="font-size : 8pt;">색상</td>		  
        	    <td width='100' align='center' style="font-size : 8pt;">차량가격</td>
        	    <td width='100' align='center' style="font-size : 8pt;">면세가격</td>        	    
        	    <td width='100' align='center' style="font-size : 8pt;">인수지</td>
        	    <td width='100' align='center' style="font-size : 8pt;">탁송료</td>
        	    <td width='100' align='center' style="font-size : 8pt;">차량가총액</td>
        	    <td width='100' align='center' style="font-size : 8pt;">DC금액</td>
        	    <td width='100' align='center' style="font-size : 8pt;">추가DC</td>
        	    <td width='100' align='center' style="font-size : 8pt;">DC후차가</td>
        	</tr>
            <%	for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
            <tr> 
                <td align='center' style="font-size : 8pt;"><%=ht.get("RENT_L_CD")%></td>
                <td align='center' style="font-size : 8pt;"></td>
                <td align='center' style="font-size : 8pt;"></td>
                <td align='center' style="font-size : 8pt;"></td>
                <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NAME")%></td>                    
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("OPT")%></td>					
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("COLO")%>/<%=ht.get("IN_COL")%>/<%=ht.get("GARNISH_COL")%></td>
        	    <td align='center' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td>
        	    <td align='center' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("UDT_ST")%></td>
        	    <td align='center' style="font-size : 8pt;">0</td>	  
        	    <td align='center' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
        	    <td align='center' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("DC_C_AMT")))%></td>
        	    <td align='center' style="font-size : 8pt;">0</td>
        	    <td align='center' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_R_AMT")))%></td>        	            		   
            </tr>
		<%	}%>
</table>
<script language='javascript'>
<!--
	
//-->
</script>
</body>
</html>

