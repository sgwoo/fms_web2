<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*" %>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");

	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String rent_way 	= request.getParameter("rent_way")	==null?"":request.getParameter("rent_way");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String dept_id 		= request.getParameter("dept_id")	==null?"":request.getParameter("dept_id");	
	
	
	Vector vt = new Vector();
	int vt_size = 0;	
	
	if(mode.equals("4")){
		vt = sb_db.getStatDeptRmListSub(mode, gubun1, st_dt, end_dt, rent_way, br_id, dept_id);
	}else{
		vt = sb_db.getStatDeptListSub(mode, gubun1, st_dt, end_dt, rent_way, br_id, dept_id);
	}
	vt_size = vt.size();	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 영업현황 > <span class=style5>부서별계약현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td width=5% class=title>연번</td>
                    <td width=10% class=title>계약일자</td>
                    <td width=20% class=title>상호</td>
                    <td width=10% class=title>차량구분</td>
                    <td width=10% class=title>관리구분</td>
                    <td width=10% class=title>차량번호</td>
                    <td width=25% class=title>차명</td>
                    <td width=10% class=title>최초영업자</td>
                </tr>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);					
		%>
                <tr>
                    <td align=center><%= i+1 %></td>
                    <td align=center><%=ht.get("RENT_DT")%></td>
                    <td align=center><%=ht.get("FIRM_NM")%></td>
                    <td align=center><%=ht.get("CAR_GU")%></td>
                    <td align=center><%=ht.get("RENT_WAY")%></td>
                    <td align=center><%=ht.get("CAR_NO")%></td>
                    <td align=center><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
                    <td align=center><%=ht.get("USER_NM")%></td>                    
                </tr>
        	<%	}%> 
        	  
            </table>
        </td>
    </tr>
    <tr>
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</body>
</html>

