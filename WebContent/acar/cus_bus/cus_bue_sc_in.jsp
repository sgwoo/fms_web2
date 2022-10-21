<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cus_bus.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String year = request.getParameter("year")==null?"":request.getParameter("year");
	String mon = request.getParameter("mon")==null?"":request.getParameter("mon");
	
	CusBus_Database cb_db = CusBus_Database.getInstance();
	Vector conts = cb_db.getContList_e(year,mon);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <% if(conts.size()>0){
		  		for(int i=0; i<conts.size(); i++){
					RentListBean cont = (RentListBean)conts.elementAt(i); %>
                <tr> 
                    <td width='7%' align='center'><%= i+1 %></td>
                    <td width='12%' align='center'><%= cont.getRent_l_cd() %></td>
                    <td width='12%' align='left'>&nbsp;<span title='<%= cont.getFirm_nm() %>'><%= AddUtil.subData(cont.getFirm_nm(),6) %></span></td>
                    <td width='10%' align='center'><%= cont.getCar_no() %></td>
                    <td width='11%' align='left'>&nbsp;<span title="<%= cont.getCar_nm() %>"><%= AddUtil.subData(cont.getCar_nm(),6) %></span></td>
                    <td width='10%' align='center'><%= cont.getRent_start_dt() %></td>
                    <td width='10%' align='center'><a href="#"><%= cont.getRent_end_dt() %></a></td>
                    <td width='10%' align='center'> 
                    <% if(cont.getCar_st().equals("1")) out.print("렌트");
        		  						else if(cont.getCar_st().equals("2")) out.print("보유");
        								else if(cont.getCar_st().equals("3")) out.print("리스"); %>
                    <%= cont.getRent_way() %></td>
                    <td width='9%' align='center'><%= c_db.getNameById(cont.getBus_id2(),"USER") %></td>
                    <td width='9%' align='center'><%= c_db.getNameById(cont.getMng_id(),"USER") %></td>
                </tr>
                <% 		}
        		}else{ %>
                <tr> 
                    <td colspan="10" align='center'>해당 계약건이 없습니다.</td>
                </tr>
        <% } %>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
