<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.cus0601.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	int count = -1;
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String off_nm = request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String off_st = request.getParameter("off_st")==null?"":request.getParameter("off_st");
	String own_nm = request.getParameter("own_nm")==null?"":request.getParameter("own_nm");
	String ent_no = request.getParameter("ent_no")==null?"":request.getParameter("ent_no");
	String off_sta = request.getParameter("off_sta")==null?"":request.getParameter("off_sta");
	String off_item = request.getParameter("off_item")==null?"":request.getParameter("off_item");
	String off_tel = request.getParameter("off_tel")==null?"":request.getParameter("off_tel");
	String off_fax = request.getParameter("off_fax")==null?"":request.getParameter("off_fax");
	String off_post = request.getParameter("t_zip")==null?"":request.getParameter("t_zip");
	String off_addr = request.getParameter("t_addr")==null?"":request.getParameter("t_addr");
	String bank = request.getParameter("bank")==null?"":request.getParameter("bank");
	String acc_no = request.getParameter("acc_no")==null?"":request.getParameter("acc_no");
	String acc_nm = request.getParameter("acc_nm")==null?"":request.getParameter("acc_nm");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String upd_id = request.getParameter("upd_id")==null?"":request.getParameter("upd_id");
	String ven_code = request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	String bank_cd = request.getParameter("bank_cd")==null?"":request.getParameter("bank_cd");

		c61_soBn.setOff_id(off_id); 
		c61_soBn.setCar_comp_id(car_comp_id); 
		c61_soBn.setOff_nm(off_nm); 
		c61_soBn.setOff_st(off_st); 
		c61_soBn.setOwn_nm(own_nm); 
		c61_soBn.setEnt_no(ent_no); 
		c61_soBn.setOff_sta(off_sta); 
		c61_soBn.setOff_item(off_item); 
		c61_soBn.setOff_tel(off_tel); 
		c61_soBn.setOff_fax(off_fax); 
		c61_soBn.setOff_post(off_post); 
		c61_soBn.setOff_addr(off_addr); 
		c61_soBn.setBank(bank);
		c61_soBn.setAcc_no(acc_no);
		c61_soBn.setAcc_nm(acc_nm);
		c61_soBn.setNote(note);
		c61_soBn.setUpd_id(upd_id);
		c61_soBn.setVen_code(ven_code);
		c61_soBn.setBank_cd(bank_cd);
		
		if(!c61_soBn.getBank_cd().equals("")){
			c61_soBn.setBank		(c_db.getNameById(c61_soBn.getBank_cd(), "BANK"));
		}	
		
		Cus0601_Database c61_db = Cus0601_Database.getInstance();
		
		count = c61_db.updateServOff(c61_soBn);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%if(count>0){%>
	alert("정상적으로 수정되었습니다.");
	var theForm = document.form1;
	theForm.target="dc_body";
	theForm.submit();
	window.location="about:blank";
<%}else{%>
	alert("데이터베이스에 문제가 생겼습니다.\n관리자님께 연락바랍니다.");
	var theForm = document.form1;
	theForm.target="dc_body";
	theForm.submit();
	window.location="about:blank";
<%}%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form name="form1" method="post" action="cus0602_d_cont.jsp">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="off_id" value="<%=off_id%>">
</form>
</body>
</html>