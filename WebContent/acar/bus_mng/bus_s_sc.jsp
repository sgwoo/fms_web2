<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function BusDisp(bus_id, bus_nm){
		var fm = document.form1;
		fm.bus_id.value = bus_id;
		fm.bus_nm.value = bus_nm;
		fm.action = "bus_s_sc_in2.jsp";
//		fm.target = "i_sub";
//		fm.submit();
	}
	
	function BusChange(m_id, l_cd){
		window.open("about:blank", "BUS_CH", "left=100, top=100, width=450, height=180, scrollbars=no");	
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.action = "bus_change.jsp";
		fm.target = "BUS_CH";
		fm.submit();
	}	

	function view_client(m_id, l_cd)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=0", "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}	
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}	
	//대여료 스케줄 인쇄화면
	function view_fee(m_id, l_cd)
	{
		window.open("/fms2/con_fee/print_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "PRINT", "left=50, top=50, width=700, height=640, scrollbars=yes");
	}				
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String bus_id = request.getParameter("bus_id")==null?"":request.getParameter("bus_id");	
	String bus_nm = request.getParameter("bus_nm")==null?"":request.getParameter("bus_nm");	
%>
<form name='form1' action='../ins_mng/ins_u_frame.jsp' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='bus_id' value='<%=bus_id%>'>
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>          		
        <td>
	        <iframe src="bus_s_sc_in3.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&sort=<%=sort%>&asc=<%=asc%>" name="i_main" width="100%" height="550" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe> 
        </td>
    </tr>    
</table>
</form>
</body>
</html>
