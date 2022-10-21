<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*"%>
<jsp:useBean id="coh_bean" class="acar.car_office.CarOffEdhBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");

	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CarOffEdhBean[] cohList  = cod.getCar_off_edh(emp_id); 
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>

<body>
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>변경이력</span></span></td>
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
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="10%" class="title">연번</td>
                    <td width="20%" class="title">담당자명</td>
                    <td width="20%" class="title">지정(변경)일자</td>
                    <td width="30%" class="title">지정사유</td>
                    <td width="20%" class="title">등록자</td>
                </tr>
                <%for(int i=0; i<cohList.length; i++){
        			coh_bean = cohList[i];  %>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%= c_db.getNameById(coh_bean.getDamdang_id(),"USER") %></td>
                    <td align="center"><%= AddUtil.ChangeDate2(coh_bean.getCng_dt()) %></td>
                    <td>&nbsp; <% if(coh_bean.getCng_rsn().equals("1"))	 		out.print("1.최근계약");
        				  			else if(coh_bean.getCng_rsn().equals("2")) out.print("2.대면상담");
        				  			else if(coh_bean.getCng_rsn().equals("3")) out.print("3.전화상담");
        				  			else if(coh_bean.getCng_rsn().equals("4")) out.print("4.전산배정");														
        				  			else if(coh_bean.getCng_rsn().equals("5")) out.print("5.기타"); %></td>
        			<td align="center"><%= c_db.getNameById(coh_bean.getReg_id(),"USER") %></td>	  			
                </tr>
                <% } %>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
