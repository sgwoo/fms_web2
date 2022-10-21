<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	CarInfoBean ci_bean = new CarInfoBean();
	ci_bean = cr_db.getCarInfo(car_mng_id);
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
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 자동차정비등록 > <span class=style5>정비/수리 내역</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"><div align="right"><a href="javascript:window.close();"><img src=../images/center/button_close.gif border=0 align=absmiddle></a></div></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=10%>차량번호</td>
                    <td width=13% align="center"><%= ci_bean.getCar_no() %>&nbsp;</td>
                    <td class='title' width=10%>차명</td>
                    <td width=44%>&nbsp;&nbsp;<%= ci_bean.getCar_jnm() %>&nbsp;<%= ci_bean.getCar_nm() %></td>
                    <td class='title' width=10%>최초등록일</td>
                    <td width=13% align="center"><%= AddUtil.ChangeDate2(ci_bean.getInit_reg_dt()) %></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align=right> 
            <table width="98%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td width="45%"><img src=../images/center/icon_arrow.gif border=0 align=absmiddle> <span class=style2>주체작업</span></td>
                    <td width="2%">&nbsp;</td>
                    <td width="51%"><img src=../images/center/icon_arrow.gif border=0 align=absmiddle> <span class=style2>부수작업</span></td>
                </tr>
                <tr> 
                    <td rowspan="3" valign="top"><iframe src="work_main.jsp?car_mng_id=<%= car_mng_id %>" name="inner1" width="100%" height="290" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                    <td rowspan="3">&nbsp;</td>
                    <td valign="top"><iframe src="work_sub.jsp?car_mng_id=<%= car_mng_id %>" name="inner2" width="100%" height="140" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                </tr>
                <tr> 
                    <td><img src=../images/center/icon_arrow.gif border=0 align=absmiddle> <span class=style2>부 품</span></td>
                </tr>
                <tr> 
                    <td valign="top"><iframe src="work_part.jsp?car_mng_id=<%= car_mng_id %>" name="inner3" width="100%" height="130" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                </tr>
                <tr> 
                    <td colspan="3" valign="top"><iframe src="item_serv.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>" name="inner4" width="100%" height="230" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                </tr>
            </table>
        </td>
    </tr>
    <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</table>
</body>
</html>