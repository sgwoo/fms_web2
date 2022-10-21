<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>

<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<%
	ServOffDatabase sod = ServOffDatabase.getInstance();
	
	
    String cmd = "";
	int count = 0;
	String auth_rw = "";
	String off_id = ""; 
	String car_comp_id = ""; 
	String off_nm = ""; 
	String off_st = ""; 
	String own_nm = ""; 
	String ent_no = ""; 
	String off_sta = ""; 
	String off_item = ""; 
	String off_tel = ""; 
	String off_fax = ""; 
	String homepage = ""; 
	String off_post = ""; 
	String off_addr = ""; 
	String bank = ""; 
	String acc_no = ""; 
	String acc_nm = ""; 
	String note = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("off_id") != null) off_id = request.getParameter("off_id"); 
	if(request.getParameter("car_comp_id") != null) car_comp_id = request.getParameter("car_comp_id"); 
	if(request.getParameter("off_nm") != null) off_nm = request.getParameter("off_nm"); 
	if(request.getParameter("off_st") != null) off_st = request.getParameter("off_st"); 
	if(request.getParameter("own_nm") != null) own_nm = request.getParameter("own_nm"); 
	if(request.getParameter("ent_no") != null) ent_no = request.getParameter("ent_no"); 
	if(request.getParameter("off_sta") != null) off_sta = request.getParameter("off_sta"); 
	if(request.getParameter("off_item") != null) off_item = request.getParameter("off_item"); 
	if(request.getParameter("off_tel") != null) off_tel = request.getParameter("off_tel"); 
	if(request.getParameter("off_fax") != null) off_fax = request.getParameter("off_fax"); 
	if(request.getParameter("homepage") != null) homepage = request.getParameter("homepage"); 
	if(request.getParameter("off_post") != null) off_post = request.getParameter("off_post"); 
	if(request.getParameter("off_addr") != null) off_addr = request.getParameter("off_addr"); 
	if(request.getParameter("bank") != null) bank = request.getParameter("bank"); 
	if(request.getParameter("acc_no") != null) acc_no = request.getParameter("acc_no"); 
	if(request.getParameter("acc_nm") != null) acc_nm = request.getParameter("acc_nm"); 
	if(request.getParameter("note") != null) note = request.getParameter("note");

	if(cmd.equals("i")||cmd.equals("u"))
	{
				
		so_bean.setOff_id(off_id); 
		so_bean.setCar_comp_id(car_comp_id); 
		so_bean.setOff_nm(off_nm); 
		so_bean.setOff_st(off_st); 
		so_bean.setOwn_nm(own_nm); 
		so_bean.setEnt_no(ent_no); 
		so_bean.setOff_sta(off_sta); 
		so_bean.setOff_item(off_item); 
		so_bean.setOff_tel(off_tel); 
		so_bean.setOff_fax(off_fax); 
		so_bean.setHomepage(homepage); 
		so_bean.setOff_post(off_post); 
		so_bean.setOff_addr(off_addr); 
		so_bean.setBank(bank);
		so_bean.setAcc_no(acc_no);
		so_bean.setAcc_nm(acc_nm);
		so_bean.setNote(note);
		
		if(cmd.equals("i"))
		{
			off_id = sod.insertServOff(so_bean);
		}else if(cmd.equals("u")){
			count = sod.updateServOff(so_bean);
		}
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%
	if(cmd.equals("u"))
	{
%>

alert("정상적으로 수정되었습니다.");
//var theForm = document.form1;
//theForm.target="";
//theForm.submit();
window.location="about:blank";
<%
	}else{
		if(!off_id.equals(""))
		{
%>
alert("정상적으로 등록되었습니다.");
var theForm = document.form1;
theForm.target="c_body";
theForm.submit();
window.location="about:blank";

<%
		}
	}
%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="./serv_off_main_i.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="off_id" value="<%=off_id%>">
</form>
</body>
</html>