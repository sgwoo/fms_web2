<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="coev_bean" class="acar.car_office.CarOffEmpVisBean" scope="page"/>
<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	String emp_id = "";					//영업소 사원ID
    
    String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	if(request.getParameter("emp_id") != null) emp_id = request.getParameter("emp_id");
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	
	CarOffEmpVisBean coev_r [] = cod.getCarOffEmpVisAll(emp_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function CarRegister()
{
	alert("정상적으로 등록되었습니다.");

}
function UpdateVis(seq_no,vis_dt,vis_nm,sub,vis_cont)
{
	var theForm = parent.document.VisInsertForm;
	theForm.seq_no.value = seq_no;
	theForm.vis_dt.value = vis_dt;
	theForm.vis_nm.value = vis_nm;
	theForm.sub.value = sub;
	theForm.vis_cont.value = vis_cont;

}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=530>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=530>
        <%
    for(int i=0; i<coev_r.length; i++){
        coev_bean = coev_r[i];
%>
        <tr> 
          <td align="center" width=57><%= i+1 %></td>
          <td align="center" width=117><%= c_db.getNameById(coev_bean.getVis_nm(), "USER") %></td>
          <td width=226>&nbsp;<span title="<%= coev_bean.getVis_cont() %>"><a href="javascript:UpdateVis('<%=coev_bean.getSeq_no()%>','<%=coev_bean.getVis_dt()%>','<%=coev_bean.getVis_nm()%>','<%=coev_bean.getSub()%>','<%=Util.htmlR(coev_bean.getVis_cont())%>')"><%= coev_bean.getSub() %></a></span></td>
          <td align="center" width=117><%= coev_bean.getVis_dt() %></td>
        </tr>
        <%}%>
        <% if(coev_r.length == 0) { %>
        <tr> 
          <td align=center height=25 colspan="4">등록된 데이타가 없습니다.</td>
        </tr>
        <%}%>
      </table>
        </td>
    </tr>

</table>
</body>
</html>