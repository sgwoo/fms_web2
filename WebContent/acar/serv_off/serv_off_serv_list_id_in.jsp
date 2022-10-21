<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_service.*" %>
<%@ page import="acar.serv_off.*" %>

<jsp:useBean id="sb_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItemBean" scope="page"/>

<%
	ServOffDatabase csd = ServOffDatabase.getInstance();
	CarServDatabase csd1 = CarServDatabase.getInstance();
	
	String auth_rw = "";
	String off_id = "";
		
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") != null)	off_id = request.getParameter("off_id");
	
	ServiceBean sb_r [] = csd.getServiceAll(off_id);
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function ServiceDisp(serv_id,serv_st)
{

	var theForm = parent.parent.c_body.document.ServiceRegInforForm;
	var auth_rw = theForm.auth_rw.value;
	var rent_mng_id = theForm.rent_mng_id.value;
	var rent_l_cd = theForm.rent_l_cd.value;
	var car_mng_id = theForm.car_mng_id.value;
	var off_id = theForm.off_id.value;
	var car_no = theForm.car_no.value;
	var firm_nm = theForm.firm_nm.value;
	var client_nm = theForm.client_nm.value;
	
	var url = "?auth_rw=" + auth_rw
			+ "&rent_mng_id=" + rent_mng_id 
			+ "&rent_l_cd=" + rent_l_cd
			+ "&car_mng_id=" + car_mng_id
			+ "&off_id=" + off_id 
			+ "&car_no=" + car_no
			+ "&firm_nm=" + firm_nm
			+ "&client_nm=" + client_nm
			+ "&serv_id="+ serv_id;
	
	if(serv_st=='1')
	{
	var SUBWIN="./service_round_c.jsp" + url;
	window.open(SUBWIN, "RoundReg", "left=100, top=100, width=730, height=280, scrollbars=no");
	}else if(serv_st=='2'){
	var SUBWIN="./service_general_c.jsp" + url;	
	window.open(SUBWIN, "GenReg", "left=100, top=100, width=730, height=500, scrollbars=no");
	}else if(serv_st=='3'){
	var SUBWIN="./service_guarantee_c.jsp" + url;	
	window.open(SUBWIN, "GuarReg", "left=100, top=100, width=730, height=280, scrollbars=no");
	}
}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=800>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="1" width=800>
<%
    for(int i=0; i<sb_r.length; i++){
        sb_bean = sb_r[i];
%>
            	<tr>
            		<td width=100 align=center><%=sb_bean.getServ_dt()%></td>
            		<td width=200 align=center>&nbsp;
            <span title="<%
            				if(sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("4"))
            				{
            					ServItemBean si_r [] = csd1.getServItemAll(sb_bean.getCar_mng_id(), sb_bean.getServ_id() );
            					for(int j=0; j<si_r.length; j++)
            					{
            						si_bean = si_r[j];
            						if(j==si_r.length-1)
            						{
            						out.print(si_bean.getItem());
            						}else{
            						out.print(si_bean.getItem()+",");
            						}
            	
            					}
            				}
            			%>">
            			<%
            				if(sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("4"))
            				{
            					ServItemBean si_r [] = csd1.getServItemAll(sb_bean.getCar_mng_id(), sb_bean.getServ_id() );
            					for(int j=0; j<si_r.length; j++)
            					{
            						si_bean = si_r[j];
            						if(j==0)
            						{
            			%>
            					<%=si_bean.getItem()%> 외 <font color="red"><%=si_r.length-1%></font> 건
            					
            			<%
            						}
            					}
            				}
            			%></span>
            		</td>
            		<td width=300 align=center><%=sb_bean.getRep_cont()%></td>
            		<td width=100 align=center><%=sb_bean.getRep_amt()%></td>
            		<td width=100 align=center><%=sb_bean.getSet_dt()%></td>
            	</tr>
<%}%>
<% if(sb_r.length == 0) { %>
            <tr>
                <td width=800 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
            </table>
        </td>
    </tr>
</table>
<form action="./service_i_sc_in.jsp" name="LoadServiceForm" method="post">
<input type="hidden" name="car_mng_id" value="<%=off_id%>">
</form>
</body>
</html>