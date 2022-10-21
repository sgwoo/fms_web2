<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=stat_cls2_user_sc_y_prn.xls");
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
	int days 	= 0;
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	
	days	= years;
	
	Vector vt = sb_db.getStatCls2UserList(s_mode, s_yy, s_mm, days, f_year);
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
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
  <input type='hidden' name='s_mode' 		value='<%=s_mode%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=50+40+110+60+(60*years*3)%>>
    <tr>
      <td>2. 년도별 현황 (대여종료대수 = 만기반납+만기매입옵션+중도반납+중도매입옵션 (폐차대여종료도 포함됨), 매입옵션=만기매입옵션+중도매입옵션)</td>
    </tr>					
    <tr>
        <td> 
            <table width=100% border="1" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td rowspan="2" class=title>군</td>
                    <td rowspan="2" class=title>연번</td>
                    <td rowspan="2" class=title>성명</td>
                    <td colspan='3' class=title>합계</td>
                    <%for (int j = f_year ; j <= AddUtil.getDate2(1) ; j++){%>
                    <td colspan='3' class=title><%=j%>년</td>
                    <%}%>
                </tr>
                <tr align="center">                     
                	  <%for (int j = f_year ; j <= AddUtil.getDate2(1)+1 ; j++){%>
                    <td width=60 class=title>대여종료<br>대수</td>
                    <td width=60 class=title>실행건수</td>
                    <td width=60 class=title>실행비율</td>
                    <%}%>
                </tr>                
                <%	int count1 = 0;
                		int count2 = 0;
                		for(int i = 0 ; i < vt_size ; i++){
                		Hashtable ht = (Hashtable)vt.elementAt(i);
                			if(String.valueOf(ht.get("LOAN_ST")).equals("1")){
                				count1++;
                %>
                <tr> 
                    <%if(f_row1==i){%><td width="50" align="center" rowspan=<%=rowspan1%>><%=ht.get("LOAN_ST")%>군</td><%}%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="40" align="center"><%if(!String.valueOf(ht.get("USER_NM")).equals("소계")){%><%=count1%><%}%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="110" align="center"><%=ht.get("USER_NM")%></td>
                    <%for (int j = (f_year-(f_year-1)-1) ; j <= (AddUtil.getDate2(1)-(f_year-1)) ; j++){%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER"+j)),1)%></td>
		                <%}%>
                </tr>
                <%		}%>
                <%		if(String.valueOf(ht.get("LOAN_ST")).equals("2")){
                				count2++;
                %>
                <tr> 
                    <%if(f_row2==i){%><td width="50" align="center" rowspan=<%=rowspan2%>><%=ht.get("LOAN_ST")%>군</td><%}%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="40" align="center"><%if(!String.valueOf(ht.get("USER_NM")).equals("소계")){%><%=count2%><%}%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="110" align="center"><%=ht.get("USER_NM")%></td>
                    <%for (int j = (f_year-(f_year-1)-1) ; j <= (AddUtil.getDate2(1)-(f_year-1)) ; j++){%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER"+j)),1)%></td>
		                <%}%>
                </tr>
                <%		}%>
                <%		if(String.valueOf(ht.get("LOAN_ST")).equals("")){%>
                <tr> 
                    <td colspan='3' class=title><%=ht.get("USER_NM")%></td>
                    <%for (int j = (f_year-(f_year-1)-1) ; j <= (AddUtil.getDate2(1)-(f_year-1)) ; j++){%>
                    <td class=title style='text-align:right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_CNT"+j)))%></td>
                    <td class=title style='text-align:right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+j)))%></td>
                    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER"+j)),1)%></td>
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