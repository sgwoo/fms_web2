<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>
<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");

	Vector conts = al_db.getContList(client_id, dt, ref_dt1, ref_dt2);
	int cont_size = conts.size();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>

<body>
<table width="810" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 고객관리 > 거래처계약현황 > <span class=style5>계약건수</span></span></td>
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
                    <td width=15% class=title>계약번호</td>
                    <td width=11% class=title>계약일</td>
                    <td width=12% class=title>차량번호</td>
                    <td width=14% class=title>차명</td>
                    <td width=21% class=title>계약기간</td>
                    <td width=12% class=title>대여방식</td>
                    <td width=10% class=title>영업담당자</td>
                </tr>
        <%
    for(int i=0; i<cont_size; i++){
        Hashtable cont = (Hashtable)conts.elementAt(i);
%>
                <tr>
                    <td align=center><%= i+1 %></td>
                    <td align=center><%=cont.get("RENT_L_CD")%></td>
                    <td align=center><%=cont.get("RENT_DT")%></td>
                    <td align=center><%=cont.get("CAR_NO")%></td>
                    <td align=center><span title="<%=cont.get("CAR_NM")%>"><%= Util.subData(String.valueOf(cont.get("CAR_NM")),5) %></span></td>
                    <td align=center><%=cont.get("RENT_START_DT")%>&nbsp;~&nbsp;<%=cont.get("RENT_END_DT")%></td>
                    <td align=center><%=cont.get("RENT_WAY")%></td>
                    <td align=center><%=cont.get("USER_NM")%></td>
                </tr>
                <%}%>
                <% if(cont_size == 0) { %>
                <tr> 
                    <td colspan=9 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</body>
</html>
