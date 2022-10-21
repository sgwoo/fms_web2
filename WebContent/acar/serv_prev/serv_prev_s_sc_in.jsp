<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_prev.*" %>
<jsp:useBean id="sp_bean" class="acar.serv_prev.ServPrevBean" scope="page"/>

<%
	ServPrevDatabase spd = ServPrevDatabase.getInstance();
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
	
	ServPrevBean sp_r [] = spd.getServPrevAll(gubun, gubun_nm, ref_dt1, ref_dt2);
	
	long ave_amt=0;
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
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="1" width=100%>
<%
    for(int i=0; i<sp_r.length; i++){
        sp_bean = sp_r[i];
        
        ave_amt = Long.parseLong(sp_bean.getAverage_dist())*30;
%>
           	<tr>
           		<td width=60 align=center><%=i+1%></td>
        		<td width=90 align=center><%=sp_bean.getCar_no()%></td>
        		<td width=80 align=center><%=sp_bean.getInit_reg_dt()%></td>
        		<td width=100 align=center><span title="<%=sp_bean.getCar_name()%>"><%=Util.subData(sp_bean.getCar_name(),8)%></span></td>
        		<td width=150 align=center><span title="<%=sp_bean.getFirm_nm()%>"><%=Util.subData(sp_bean.getFirm_nm(),8)%></span></td>
        		<td width=80 align=center><span title="<%=sp_bean.getClient_nm()%>"><%=Util.subData(sp_bean.getClient_nm(),5)%></span></td>
        		<td width=70 align=right><%=Util.parseDecimal(sp_bean.getTot_dist())%></td>
        		<td width=60 align=right><%=Util.parseDecimal(ave_amt)%></td>
        		<td width=70 align=right><%=Util.parseDecimal(sp_bean.getToday_dist())%></td>
        		<td width=50 align=center></td>
        		<td width=50 align=center></td>
        		
        	</tr>
<%}%>
<% if(sp_r.length == 0) { %>
            <tr>
                <td width=100% align=center height=25>등록된 데이타가 없습니다.</td>
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