<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String gubun = "car_off_nm";
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st");
	if(gubun_nm.equals(""))	gubun_nm = "--";
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarOffBean co_r [] = umd.getCarOffAll(car_comp_id,gubun,gubun_nm);
	CommonDataBase c_db = CommonDataBase.getInstance();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <%for(int i=0; i<co_r.length; i++){
			co_bean = co_r[i];	%>
                <tr> 
                    <td width='7%' align='center'><%= i+1 %></td>
                    <td width='20%' align='center'><%= c_db.getNameById(co_bean.getCar_comp_id(),"CAR_COM") %></td>
                    <td width='16%' align='center'><%if(co_bean.getCar_off_st().equals("1")){ out.print("지점");
        		  								}else if(co_bean.getCar_off_st().equals("2")){ out.print("대리점");
        										} %></td>
                    <td width='35%' align='center'><a href="javascript:parent.SetCarOff('<%= co_bean.getCar_comp_id() %>','<%= co_bean.getCar_off_id() %>','<%= co_bean.getCar_off_nm() %>','<%= co_bean.getCar_off_st() %>','<%= co_bean.getCar_off_tel() %>','<%= co_bean.getCar_off_fax() %>','<%= co_bean.getCar_off_post() %>','<%= co_bean.getCar_off_addr() %>')"><%= co_bean.getCar_off_nm() %></a></td>
                    <td width="22%" align='center'><%= co_bean.getCar_off_tel() %></td>
                </tr>
        <%}
if(co_r.length == 0) { %>
                <tr> 
                    <td colspan="5" align='center'>해당 영업소가 없읍니다.</td>
                </tr>
        <%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>