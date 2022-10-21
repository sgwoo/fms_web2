<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.forfeit_mng.*" %>
<%@ page import="acar.common.*" %>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	ForfeitDatabase cdb = ForfeitDatabase.getInstance();
	String gubun = "";
	String rent_l_cd = "";
	String firm_nm = "";
	String car_no = "";
	
	if(request.getParameter("gubun") != null)	gubun = request.getParameter("gubun");
	if(request.getParameter("rent_l_cd") != null)	rent_l_cd = request.getParameter("rent_l_cd");
	if(request.getParameter("firm_nm") != null)	firm_nm = request.getParameter("firm_nm");
	if(request.getParameter("car_no") != null)	car_no = request.getParameter("car_no");
	
	RentListBean rl_r [] = cdb.getCarRentListAll(gubun,rent_l_cd,firm_nm,car_no);
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SetCarRent(car_mng_id,rent_mng_id,rent_l_cd,firm_nm,client_nm,car_no,car_name,rent_way_nm,con_mon,rent_start_dt,o_tel,fax)
{
	var theForm = opener.document.ForfeitForm;
	theForm.car_mng_id.value = car_mng_id;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.car_no.value = car_no;
	theForm.car_name.value = car_name;
	theForm.rent_way_nm.value = rent_way_nm;
	theForm.con_mon.value = con_mon;
	theForm.rent_start_dt.value = rent_start_dt;
	theForm.o_tel.value = o_tel;
	theForm.o_fax.value = fax;
	self.close();
	
}
//-->
</script>
</head>
<body onLoad="self.focus()">


<table border=0 cellspacing=0 cellpadding=0 width=550>
	
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=550>
            	<tr>
            		<td class=title width="100">계약번호</td>
            		<td class=title width="150">상호</td>
            		<td class=title width="100">고객명</td>
            		<td class=title width="100">차량번호</td>
            		<td class=title width="100">차명</td>
            	</tr>
<%
    for(int i=0; i<rl_r.length; i++){
        rl_bean = rl_r[i];
%>
            	<tr>
            		<td align="center"><a href="javascript:SetCarRent('<%=rl_bean.getCar_mng_id()%>','<%=rl_bean.getRent_mng_id()%>','<%=rl_bean.getRent_l_cd()%>','<%=rl_bean.getFirm_nm()%>','<%=rl_bean.getClient_nm()%>','<%=rl_bean.getCar_no()%>','<%=rl_bean.getCar_nm()%>','<%=rl_bean.getRent_way_nm()%>','<%=rl_bean.getCon_mon()%>','<%=rl_bean.getRent_start_dt()%>','<%=rl_bean.getO_tel()%>','<%=rl_bean.getFax()%>')"><%= rl_bean.getRent_l_cd() %></a></td>
            		<td align="center"><%= rl_bean.getFirm_nm() %></td>
            		<td align="center"><%= rl_bean.getClient_nm() %></td>
            		<td align="center"><%= rl_bean.getCar_no() %></td>
            		<td align="center"><%= rl_bean.getCar_nm() %></td>
            	</tr>
<%}%>
<% if(rl_r.length == 0) { %>
            <tr>
                <td colspan=5 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
            </table>
        </td>
    </tr>
</table>

</body>
</html>