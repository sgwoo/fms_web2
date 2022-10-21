<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=stat_accid_user_sc_d_prn.xls");
%>

<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*" %>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_mode	= request.getParameter("s_mode")==null?"":request.getParameter("s_mode");
	
	int f_year 	= 2004;	
	int days 	= AddUtil.getMonthDate(AddUtil.parseInt(s_yy), AddUtil.parseInt(s_mm));
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	
	Vector vt = sb_db.getStatAccidUserList(s_mode, s_yy, s_mm, days, f_year);
	int vt_size = vt.size();
	
	int rowspan1 = 0;
	int rowspan2 = 0;

	int f_row1 = 0;
	int f_row2 = 0;
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
    if(String.valueOf(ht.get("LOAN_ST")).equals("1")){
    	if(rowspan1==0) f_row1 = i;
      rowspan1++;
    }else if(String.valueOf(ht.get("LOAN_ST")).equals("2")){
    	if(rowspan2==0) f_row2 = i;	
    	rowspan2++;
    }
	}
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
  <input type='hidden' name='s_mode' 		value='<%=s_mode%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=50+110+40+(40*days)%>>
    <tr>
      <td>1. 일별 피해차량현황</td>
    </tr>
    <tr>
        <td> 
            <table width=100% border="1" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td colspan="2" class=title>구분</td>
                    <td width=40 class=title>합계</td>
                    <%for (int j = 0 ; j < days ; j++){%>
                    <td width=40 class=title><%=j+1%>일</td>
                    <%}%>
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
                		Hashtable ht = (Hashtable)vt.elementAt(i);
                			if(String.valueOf(ht.get("LOAN_ST")).equals("1")){
                %>
                <tr> 
                    <%if(f_row1==i){%><td width="50" align="center" rowspan=<%=rowspan1%>><%=ht.get("LOAN_ST")%>군</td><%}%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="110" align="center"><%=ht.get("USER_NM")%></td>
                    <%for (int j = 0 ; j < days+1 ; j++){%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> align="right"><%=ht.get("CNT"+j)%></td>
		                <%}%>
                </tr>
                <%		}%>
                <%		if(String.valueOf(ht.get("LOAN_ST")).equals("2")){%>
                <tr> 
                    <%if(f_row2==i){%><td width="50" align="center" rowspan=<%=rowspan2%>><%=ht.get("LOAN_ST")%>군</td><%}%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="110" align="center"><%=ht.get("USER_NM")%></td>
                    <%for (int j = 0 ; j < days+1 ; j++){%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> align="right"><%=ht.get("CNT"+j)%></td>
		                <%}%>
                </tr>
                <%		}%>
                <%		if(String.valueOf(ht.get("LOAN_ST")).equals("")){%>
                <tr> 
                    <td width="50" colspan='2' class=title><%=ht.get("USER_NM")%></td>
                    <%for (int j = 0 ; j < days+1 ; j++){%>
                    <td class=title style='text-align:right'><%=ht.get("CNT"+j)%></td>
		                <%}%>
                </tr>
                <%		}%>
                <%	}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>