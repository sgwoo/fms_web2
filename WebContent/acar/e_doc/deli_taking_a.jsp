<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<% 

	String cons_no	= request.getParameter("cons_no")	== null ?	"" : request.getParameter("cons_no");
	String seq 			= request.getParameter("seq")			== null ?	"" : request.getParameter("seq");

	String start_km 	= request.getParameter("start_km")	== null ? "" : request.getParameter("start_km");
	String end_km 	= request.getParameter("end_km")	== null ? "" : request.getParameter("end_km");
	
	String chk_a	 	= request.getParameter("chk_a")	== null ? "" : request.getParameter("chk_a");
	String chk_b	 	= request.getParameter("chk_b")	== null ? "" : request.getParameter("chk_b");
	String chk_c	 	= request.getParameter("chk_c")	== null ? "" : request.getParameter("chk_c");
	String chk_d	 	= request.getParameter("chk_d")	== null ? "" : request.getParameter("chk_d");
	String chk_e	 	= request.getParameter("chk_e")	== null ? "" : request.getParameter("chk_e");
	String chk_f	 	= request.getParameter("chk_f")	== null ? "" : request.getParameter("chk_f");
	String chk_g	 	= request.getParameter("chk_g")	== null ? "" : request.getParameter("chk_g");
	String chk_h	 	= request.getParameter("chk_h")	== null ? "" : request.getParameter("chk_h");
	String chk_i	 	= request.getParameter("chk_i")	== null ? "" : request.getParameter("chk_i");
	String chk_j	 	= request.getParameter("chk_j")	== null ? "" : request.getParameter("chk_j");
	String chk_k	 	= request.getParameter("chk_k")	== null ? "" : request.getParameter("chk_k");
	String chk_l	 	= request.getParameter("chk_l")	== null ? "" : request.getParameter("chk_l");
	String chk_m	 	= request.getParameter("chk_m")	== null ? "" : request.getParameter("chk_m");
	String chk_n	 	= request.getParameter("chk_n")	== null ? "" : request.getParameter("chk_n");
	String chk_o	 	= request.getParameter("chk_o")	== null ? "" : request.getParameter("chk_o");
	String chk_p	 	= request.getParameter("chk_p")	== null ? "" : request.getParameter("chk_p");
	String chk_q	 	= request.getParameter("chk_q")	== null ? "" : request.getParameter("chk_q");

	String chk_r	 	= request.getParameter("chk_r")	== null ? "" : request.getParameter("chk_r");
	String chk_s	 	= request.getParameter("chk_s")	== null ? "" : request.getParameter("chk_s");
	String chk_t	 	= request.getParameter("chk_t")	== null ? "" : request.getParameter("chk_t");
	String chk_u	 	= request.getParameter("chk_u")	== null ? "" : request.getParameter("chk_u");
	String chk_v	 	= request.getParameter("chk_v")	== null ? "" : request.getParameter("chk_v");
	String chk_w	 	= request.getParameter("chk_w")	== null ? "" : request.getParameter("chk_w");
	String chk_x	 	= request.getParameter("chk_x")	== null ? "" : request.getParameter("chk_x");
	String chk_y	 	= request.getParameter("chk_y")	== null ? "" : request.getParameter("chk_y");
	String chk_z	 	= request.getParameter("chk_z")	== null ? "" : request.getParameter("chk_z");

	String cons_type	 = request.getParameter("cons_type")	== null ? "" : request.getParameter("cons_type");
	String valuables	 = request.getParameter("valuables")	== null ? "" : request.getParameter("valuables");
	
	String cons_client_nm	 	= request.getParameter("cons_client_nm")	== null ? "" : request.getParameter("cons_client_nm");
	String cons_client_tel	 	= request.getParameter("cons_client_tel")	== null ? "" : request.getParameter("cons_client_tel");
	String cons_relationship	 = request.getParameter("cons_relationship")	== null ? "" : request.getParameter("cons_relationship");
	
	
	Map<String, String> paramMap = new HashMap<String, String>();
	paramMap.put("cons_no", cons_no+seq);
	paramMap.put("start_km", start_km);
	paramMap.put("end_km", end_km);
	paramMap.put("chk_a", chk_a);
	paramMap.put("chk_b", chk_b);
	paramMap.put("chk_c", chk_c);
	paramMap.put("chk_d", chk_d);
	paramMap.put("chk_e", chk_e);
	paramMap.put("chk_f", chk_f);
	paramMap.put("chk_g", chk_g);
	paramMap.put("chk_h", chk_h);
	paramMap.put("chk_i", chk_i);
	paramMap.put("chk_j", chk_j);
	paramMap.put("chk_k", chk_k);
	paramMap.put("chk_l", chk_l);
	paramMap.put("chk_m", chk_m);
	paramMap.put("chk_n", chk_n);
	paramMap.put("chk_o", chk_o);
	paramMap.put("chk_p", chk_p);
	paramMap.put("chk_q", chk_q);
	
	paramMap.put("chk_r", chk_r);
	paramMap.put("chk_s", chk_s);
	paramMap.put("chk_t", chk_t);
	paramMap.put("chk_u", chk_u);
	paramMap.put("chk_v", chk_v);
	paramMap.put("chk_w", chk_w);
	paramMap.put("chk_x", chk_x);
	paramMap.put("chk_y", chk_y);
	paramMap.put("chk_z", chk_z);
	paramMap.put("cons_type", cons_type);
	paramMap.put("valuables", valuables);
	paramMap.put("cons_client_nm", cons_client_nm);
	paramMap.put("cons_client_tel", cons_client_tel);
	paramMap.put("cons_relationship", cons_relationship);
	
	boolean flag = ln_db.updateConsignmentLink(paramMap);
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
<form name='form1' action='deli_taking.jsp' method='post' target="">
  <input type='hidden' name="cons_no" 	value="<%=cons_no%>" />
  <input type='hidden' name="seq" 			value="<%=seq%>" />
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