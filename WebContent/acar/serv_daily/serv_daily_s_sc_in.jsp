<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_daily.*" %>
<jsp:useBean id="sd_bean" class="acar.serv_daily.ServDailyBean" scope="page"/>

<%
	ServDailyDatabase sdd = ServDailyDatabase.getInstance();
	String auth_rw = "";
	String gubun_nm = "";
	String gubun = "";
	String ref_dt1 = "";
	String ref_dt2 = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun_nm") !=null) gubun_nm = request.getParameter("gubun_nm");
	if(request.getParameter("gubun") !=null) gubun = request.getParameter("gubun");
	if(request.getParameter("ref_dt1") !=null) ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") !=null) ref_dt2 = request.getParameter("ref_dt2");
	
	
	ServDailyBean sd_r [] = sdd.getServDailyAll(gubun, gubun_nm, ref_dt1, ref_dt2);
	

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function AccidentDisp(car_mng_id, accid_id)
{
	var theForm = document.AccidDispForm;
	theForm.car_mng_id.value = car_mng_id;
	theForm.accid_id.value = accid_id;
	theForm.target = "d_content";
	theForm.submit();
}
function ServiceList(car_mng_id, rent_mng_id, rent_l_cd, serv_dt)
{
	
	var url	= "?car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&serv_dt="+serv_dt;
	var SUBWIN="./serv_daily_c.jsp"+ url;
	window.open(SUBWIN, "ServiceList", "left=100, top=100, width=800, height=330, scrollbars=yes");
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
    for(int i=0; i<sd_r.length; i++){
        sd_bean = sd_r[i];
%>
           	<tr>
        		<td width=50 align=center><%=i+1%></td>
        		<td width=90 align=center><%=sd_bean.getCar_no()%></td>
        		<td width=80 align=center><%=sd_bean.getInit_reg_dt()%></td>
        		<td width=100 align=center></td>
        		<td width=108 align=center><span title="<%=sd_bean.getFirm_nm()%>"><%=Util.subData(sd_bean.getFirm_nm(),7)%></span></td>
        		<td width=70 align=center><span title="<%=sd_bean.getClient_nm()%>"><%=Util.subData(sd_bean.getClient_nm(),3)%></span></td>
        		<td width=50 align=center style="background-color:<%=sd_bean.getServ_dt5_c()%>"><a href="javascript:ServiceList('<%=sd_bean.getCar_mng_id()%>','<%=sd_bean.getRent_mng_id()%>','<%=sd_bean.getRent_l_cd()%>','<%=sd_bean.getServ_dt5()%>')"><%=sd_bean.getServ_dt5_m()%></a></td>
        		<td width=50 align=center style="background-color:<%=sd_bean.getServ_dt4_c()%>"><a href="javascript:ServiceList('<%=sd_bean.getCar_mng_id()%>','<%=sd_bean.getRent_mng_id()%>','<%=sd_bean.getRent_l_cd()%>','<%=sd_bean.getServ_dt4()%>')"><%=sd_bean.getServ_dt4_m()%></a></td>
        		<td width=50 align=center style="background-color:<%=sd_bean.getServ_dt3_c()%>"><a href="javascript:ServiceList('<%=sd_bean.getCar_mng_id()%>','<%=sd_bean.getRent_mng_id()%>','<%=sd_bean.getRent_l_cd()%>','<%=sd_bean.getServ_dt3()%>')"><%=sd_bean.getServ_dt3_m()%></a></td>
        		<td width=50 align=center style="background-color:<%=sd_bean.getServ_dt2_c()%>"><a href="javascript:ServiceList('<%=sd_bean.getCar_mng_id()%>','<%=sd_bean.getRent_mng_id()%>','<%=sd_bean.getRent_l_cd()%>','<%=sd_bean.getServ_dt2()%>')"><%=sd_bean.getServ_dt2_m()%></a></td>
        		<td width=50 align=center style="background-color:<%=sd_bean.getServ_dt1_c()%>"><a href="javascript:ServiceList('<%=sd_bean.getCar_mng_id()%>','<%=sd_bean.getRent_mng_id()%>','<%=sd_bean.getRent_l_cd()%>','<%=sd_bean.getServ_dt1()%>')"><%=sd_bean.getServ_dt1_m()%></a></td>
        		<td width=50 align=center style="background-color:<%=sd_bean.getServ_dt_c()%>"><a href="javascript:ServiceList('<%=sd_bean.getCar_mng_id()%>','<%=sd_bean.getRent_mng_id()%>','<%=sd_bean.getRent_l_cd()%>','<%=sd_bean.getServ_dt()%>')"><%=sd_bean.getServ_dt_m()%></a></td>
        	</tr>
<%}%>
<% if(sd_r.length == 0) { %>
            <tr>
                <td width=800 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
            </table>
        </td>
    </tr>
    
</table>
<form action="./car_accid_c_frame.jsp" name="AccidDispForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="accid_id" value="">
</form>

</body>
</html>