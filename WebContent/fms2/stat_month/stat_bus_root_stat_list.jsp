<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st     = request.getParameter("st")==null?"":request.getParameter("st");
	String car_gu = request.getParameter("car_gu")==null?"":request.getParameter("car_gu");
	String rent_st= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String bus_st1= request.getParameter("bus_st1")==null?"":request.getParameter("bus_st1");
	
	
	Vector vt = sb_db.getStatBusRootListSub(st, s_yy, s_mm, 0, 0, gubun1, car_gu, rent_st, bus_st1);
	int vt_size = vt.size();
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
 <input type='hidden' name='mode' value=''>
 <input type='hidden' name='s_cd' value=''>
 <input type='hidden' name='c_id' value=''>
 <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 영업관리 > <span class=style5>영업루트별계약현황 리스트 (<%=car_gu%>/<%=rent_st%>/<%=bus_st1%>)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=5% class=title>연번</td>
                    <td width=13% class=title>계약일자</td>
                    <td width=12% class=title>영업구분</td>
                    <td width=25% class=title>상호</td>
                    <td width=45% class=title>차명</td>
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
                %>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td align='center'><%=ht.get("BUS_ST")%></td>
                    <td align='center'><%=ht.get("FIRM_NM")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%></td>
                </tr>
		            <%	}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>