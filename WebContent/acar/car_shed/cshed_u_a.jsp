<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.car_shed.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.car_shed.CarShedDatabase"/>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">

</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String brch 	= request.getParameter("brch")==null?"":request.getParameter("brch");
	
	String shed_id = request.getParameter("shed_id")==null?"":request.getParameter("shed_id");
	CarShedBean shed = cs_db.getCarShed(shed_id);
	shed.setShed_id(shed_id);
	shed.setShed_nm(request.getParameter("shed_nm")==null?"":request.getParameter("shed_nm"));
	shed.setMng_off(request.getParameter("mng_off")==null?"":request.getParameter("mng_off"));
	shed.setMng_agnt(request.getParameter("mng_agnt")==null?"":request.getParameter("mng_agnt"));
	shed.setLea_nm(request.getParameter("lea_nm")==null?"":request.getParameter("lea_nm"));
	shed.setLea_comp_nm(request.getParameter("lea_comp_nm")==null?"":request.getParameter("lea_comp_nm"));
	shed.setLea_sta(request.getParameter("lea_sta")==null?"":request.getParameter("lea_sta"));
	shed.setLea_ssn(request.getParameter("lea_ssn")==null?"":request.getParameter("lea_ssn"));
	shed.setLea_ent_no(request.getParameter("lea_ent_no")==null?"":request.getParameter("lea_ent_no"));
	shed.setLea_item(request.getParameter("lea_item")==null?"":request.getParameter("lea_item"));
	shed.setLea_h_post(request.getParameter("lea_h_post")==null?"":request.getParameter("lea_h_post"));
	shed.setLea_h_addr(request.getParameter("lea_h_addr")==null?"":request.getParameter("lea_h_addr"));
	shed.setLea_h_tel(request.getParameter("lea_h_tel")==null?"":request.getParameter("lea_h_tel"));
	shed.setLea_o_post(request.getParameter("lea_o_post")==null?"":request.getParameter("lea_o_post"));
	shed.setLea_o_addr(request.getParameter("lea_o_addr")==null?"":request.getParameter("lea_o_addr"));
	shed.setLea_o_tel(request.getParameter("lea_o_tel")==null?"":request.getParameter("lea_o_tel"));
	shed.setLea_tax_st(request.getParameter("lea_tax_st")==null?"":request.getParameter("lea_tax_st"));
	shed.setLea_fax(request.getParameter("lea_fax")==null?"":request.getParameter("lea_fax"));
	shed.setLea_m_tel(request.getParameter("lea_m_tel")==null?"":request.getParameter("lea_m_tel"));
	shed.setLea_st(request.getParameter("lea_st")==null?"":request.getParameter("lea_st"));
	shed.setLea_st_dt(request.getParameter("lea_st_dt")==null?"":request.getParameter("lea_st_dt"));
	shed.setLea_end_dt(request.getParameter("lea_end_dt")==null?"":request.getParameter("lea_end_dt"));
	shed.setLend_own_nm(request.getParameter("lend_own_nm")==null?"":request.getParameter("lend_own_nm"));
	shed.setLend_comp_nm(request.getParameter("lend_comp_nm")==null?"":request.getParameter("lend_comp_nm"));
	shed.setLend_sta(request.getParameter("lend_sta")==null?"":request.getParameter("lend_sta"));
	shed.setLend_ssn(request.getParameter("lend_ssn")==null?"":request.getParameter("lend_ssn"));
	shed.setLend_ent_no(request.getParameter("lend_ent_no")==null?"":request.getParameter("lend_ent_no"));
	shed.setLend_item(request.getParameter("lend_item")==null?"":request.getParameter("lend_item"));
	shed.setLend_h_post(request.getParameter("lend_h_post")==null?"":request.getParameter("lend_h_post"));
	shed.setLend_h_addr(request.getParameter("lend_h_addr")==null?"":request.getParameter("lend_h_addr"));
	shed.setLend_o_post(request.getParameter("lend_o_post")==null?"":request.getParameter("lend_o_post"));
	shed.setLend_o_addr(request.getParameter("lend_o_addr")==null?"":request.getParameter("lend_o_addr"));
	shed.setLend_post(request.getParameter("lend_post")==null?"":request.getParameter("lend_post"));
	shed.setLend_addr(request.getParameter("lend_addr")==null?"":request.getParameter("lend_addr"));
	shed.setLend_h_tel(request.getParameter("lend_h_tel")==null?"":request.getParameter("lend_h_tel"));
	shed.setLend_o_tel(request.getParameter("lend_o_tel")==null?"":request.getParameter("lend_o_tel"));
	shed.setLend_m_tel(request.getParameter("lend_m_tel")==null?"":request.getParameter("lend_m_tel"));
	shed.setLend_tax(request.getParameter("lend_tax")==null?"":request.getParameter("lend_tax"));
	shed.setLend_rel(request.getParameter("lend_rel")==null?"":request.getParameter("lend_rel"));
	shed.setLend_fax(request.getParameter("lend_fax")==null?"":request.getParameter("lend_fax"));
	shed.setLend_tot_ar(request.getParameter("lend_tot_ar")==null?"":request.getParameter("lend_tot_ar"));
	shed.setLend_mng_agnt(request.getParameter("lend_mng_agnt")==null?"":request.getParameter("lend_mng_agnt"));
	shed.setLend_region(request.getParameter("lend_region")==null?"":request.getParameter("lend_region"));
	shed.setLend_cap_ar(request.getParameter("lend_cap_ar")==null?"":request.getParameter("lend_cap_ar"));
	shed.setLend_gov(request.getParameter("lend_gov")==null?"":request.getParameter("lend_gov"));
	shed.setLend_cla(request.getParameter("lend_cla")==null?"":request.getParameter("lend_cla"));
	
	shed.setShed_st(request.getParameter("shed_st")==null?"":request.getParameter("shed_st"));
	shed.setBjg_amt(request.getParameter("bjg_amt")==null?0:AddUtil.parseInt(request.getParameter("bjg_amt")));
	shed.setWsg_amt(request.getParameter("wsg_amt")==null?0:AddUtil.parseInt(request.getParameter("wsg_amt")));
	shed.setHsjsg_amt(request.getParameter("hsjsg_amt")==null?0:AddUtil.parseInt(request.getParameter("hsjsg_amt")));
	shed.setCar_lend(request.getParameter("car_lend")==null?"":request.getParameter("car_lend"));
	shed.setCar_lend_amt(request.getParameter("car_lend_amt")==null?0:AddUtil.parseInt(request.getParameter("car_lend_amt")));
	shed.setCar_lend_dt(request.getParameter("car_lend_dt")==null?"":request.getParameter("car_lend_dt"));
	shed.setIm_in_dt(request.getParameter("im_in_dt")==null?"":request.getParameter("im_in_dt"));
	shed.setUse_yn(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
	shed.setLend_cap_car(request.getParameter("lend_cap_car")==null?"":request.getParameter("lend_cap_car"));
	shed.setCont_amt(request.getParameter("cont_amt")==null?"":String.valueOf(request.getParameter("cont_amt")).replaceAll(",",""));
	
//System.out.println("bjg_amt="+shed.getBjg_amt());
//System.out.println("wsg_amt="+shed.getWsg_amt());
//System.out.println("hsjsg_amt="+shed.getHsjsg_amt());	

%>
<script language='javascript'>
<%
	if(cs_db.updateCarShed(shed))
	{
%>
		alert('수정되었습니다');
		<%-- parent.location='/acar/car_shed/cshed_m_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>&shed_id=<%=shed_id%>'; --%>
		parent.location='/acar/car_shed/cshed_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>&shed_id=<%=shed_id%>';
<%
	}
	else
	{
%>
		alert('수정되지 않았습니다');
<%
	}
%>
</script>
</body>
</html>
