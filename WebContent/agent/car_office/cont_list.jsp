<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="cm_bean" class="acar.car_office.CommiBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>
<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");

	CommiBean cm_r [] = cod.getCommiAll(emp_id);
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>

<body>
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>거래내역</span></span></td>
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
                    <td width=10% class=title>계약일</td>
                    <td width=20% class=title>상호</td>
                    <td width=10% class=title>계약자</td>
                    <td width=34% class=title>차명</td>
                    <td width=10% class=title>등록일</td>
                    <td width=11% class=title>영업담당자</td>
                </tr>
        <%
    for(int i=0; i<cm_r.length; i++){
        cm_bean = cm_r[i];
%>
                <tr>
                    <td align=center><%= i+1 %></td>
                    <td align=center><%= cm_bean.getRent_dt() %></td>
                    <td align=center><%= cm_bean.getFirm_nm() %></td>
                    <td align=center><%= cm_bean.getClient_nm() %></td>
                    <td align=center><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td><%= cm_bean.getCar_name() %></td></tr></table></td>
                    <td align=center><%= cm_bean.getInit_reg_dt() %></td>
                    <td align=center><%= cm_bean.getUser_nm() %></td>
                </tr>
        <%}%>
        <% if(cm_r.length == 0) { %>
                <tr> 
                    <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
        <%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
