<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<% 
	String rent_l_cd 			= request.getParameter("rent_l_cd")			== null ? "" : request.getParameter("rent_l_cd");
	String rent_mng_id 		= request.getParameter("rent_mng_id")		== null ? "" : request.getParameter("rent_mng_id");
	String rent_st	 			= request.getParameter("rent_st")				== null ? "" : request.getParameter("rent_st");
	String cms_type 			= request.getParameter("cms_type")			== null ? "" : request.getParameter("cms_type");
	
	String c_cms_bank 		= request.getParameter("c_cms_bank")		== null ? "" : request.getParameter("c_cms_bank");
	String c_enp_no 			= request.getParameter("c_enp_no")			== null ? "" : request.getParameter("c_enp_no");
	String c_cms_dep_nm	= request.getParameter("c_cms_dep_nm")	== null ? "" : request.getParameter("c_cms_dep_nm");
	String c_cms_acc_no	= request.getParameter("c_cms_acc_no")	== null ? "" : request.getParameter("c_cms_acc_no");
	String c_cms_dep_ssn	= request.getParameter("c_cms_dep_ssn")	== null ? "" : request.getParameter("c_cms_dep_ssn");
	String c_mm 				= request.getParameter("c_mm")				== null ? "" : request.getParameter("c_mm");
	String c_yyyy 				= request.getParameter("c_yyyy")				== null ? "" : request.getParameter("c_yyyy");
	
	boolean flag = ln_db.updateRmRentCardCms(rent_l_cd, rent_st, c_cms_bank, c_enp_no, c_cms_dep_nm, c_cms_acc_no, c_cms_dep_ssn, c_mm, c_yyyy);
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
<form name='form1' action='rmcar_doc.jsp' method='post' target="">
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 			value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st" 				value="<%=rent_st%>">
  <input type='hidden' name='cms_type' value='<%=cms_type%>' />
</form>
<script language="JavaScript">
<%if(flag){%>
	
	var fm = document.form1;
	
	alert("정상적으로 저장되었습니다.");
	
	fm.submit();
	
<%}else{%>
	alert("저장에 실패했습니다.");
<%}%>

</script>
</body>
</html>