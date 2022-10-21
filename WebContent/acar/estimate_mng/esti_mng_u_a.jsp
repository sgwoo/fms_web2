<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd = request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	bean = e_db.getEstimateCase(est_id);
	
	bean.setEst_nm(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
	bean.setEst_ssn(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
	bean.setEst_tel(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
	bean.setEst_fax(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
	bean.setCar_comp_id(request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id"));
	bean.setCar_cd(request.getParameter("code")==null?"":request.getParameter("code"));
	bean.setCar_id(request.getParameter("car_id")==null?"":request.getParameter("car_id"));
	bean.setCar_seq(request.getParameter("car_seq")==null?"":request.getParameter("car_seq"));
	bean.setCar_amt(request.getParameter("car_amt")==null?0:AddUtil.parseDigit(request.getParameter("car_amt")));
	bean.setOpt(request.getParameter("opt")==null?"":request.getParameter("opt"));
	bean.setOpt_seq(request.getParameter("opt_seq")==null?"":request.getParameter("opt_seq"));
	bean.setOpt_amt(request.getParameter("opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt")));
	bean.setCol(request.getParameter("col")==null?"":request.getParameter("col"));
	bean.setCol_seq(request.getParameter("col_seq")==null?"":request.getParameter("col_seq"));
	bean.setCol_amt(request.getParameter("col_amt")==null?0:AddUtil.parseDigit(request.getParameter("col_amt")));
	bean.setDc(request.getParameter("dc")==null?"":request.getParameter("dc"));
	bean.setDc_seq(request.getParameter("dc_seq")==null?"":request.getParameter("dc_seq"));
	bean.setDc_amt(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
	bean.setO_1(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
	bean.setA_a(request.getParameter("a_a")==null?"":request.getParameter("a_a"));
	bean.setA_b(request.getParameter("a_b")==null?"":request.getParameter("a_b"));
	bean.setA_h(request.getParameter("a_h")==null?"":request.getParameter("a_h"));
	bean.setPp_st(request.getParameter("pp_st")==null?"0":request.getParameter("pp_st"));
	bean.setPp_per(request.getParameter("pp_per")==null?0:AddUtil.parseFloat(request.getParameter("pp_per")));
	bean.setPp_amt(request.getParameter("pp_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_amt")));
	bean.setRg_8(request.getParameter("rg_8")==null?0:AddUtil.parseFloat(request.getParameter("rg_8")));
	bean.setIns_good(request.getParameter("ins_good")==null?"":request.getParameter("ins_good"));
	bean.setIns_age(request.getParameter("ins_age")==null?"":request.getParameter("ins_age"));
	bean.setIns_dj(request.getParameter("ins_dj")==null?"":request.getParameter("ins_dj"));
	bean.setRo_13(request.getParameter("ro_13")==null?0:AddUtil.parseFloat(request.getParameter("ro_13")));
	bean.setG_10(request.getParameter("g_10")==null?0:AddUtil.parseDigit(request.getParameter("g_10")));
	bean.setCar_ja(request.getParameter("car_ja")==null?0:AddUtil.parseDigit(request.getParameter("car_ja")));
	bean.setGi_yn(request.getParameter("gi_yn")==null?"":request.getParameter("gi_yn"));
	bean.setGi_amt(request.getParameter("gi_amt")==null?0:AddUtil.parseDigit(request.getParameter("gi_amt")));
	bean.setGi_fee(request.getParameter("gi_fee")==null?0:AddUtil.parseDigit(request.getParameter("gi_fee")));
	bean.setGtr_amt(request.getParameter("gtr_amt")==null?0:AddUtil.parseDigit(request.getParameter("gtr_amt")));
	bean.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	bean.setPp_v_amt(request.getParameter("pp_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_v_amt")));
	bean.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	bean.setIfee_v_amt(request.getParameter("ifee_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("ifee_v_amt")));
	bean.setFee_s_amt(request.getParameter("fee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
	bean.setFee_v_amt(request.getParameter("fee_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
	bean.setUpdate_id(user_id);
	bean.setRo_13_amt(request.getParameter("ro_13_amt")==null?0:AddUtil.parseDigit(request.getParameter("ro_13_amt")));
	bean.setRg_8_amt(request.getParameter("rg_8_amt")==null?0:AddUtil.parseDigit(request.getParameter("rg_8_amt")));
	bean.setFee_dc_per(request.getParameter("fee_dc_per")==null?0:AddUtil.parseFloat(request.getParameter("fee_dc_per")));
	bean.setSpr_yn		(request.getParameter("spr_yn")==null?"0":request.getParameter("spr_yn"));
	bean.setUdt_st		(request.getParameter("udt_st")==null?"0":request.getParameter("udt_st"));
	bean.setIns_per		(request.getParameter("ins_per")	==null?"1":request.getParameter("ins_per"));
	bean.setInsurant	(request.getParameter("insurant")	==null?"1":request.getParameter("insurant"));
	bean.setO_11		(request.getParameter("o_11")==null?0:AddUtil.parseFloat(request.getParameter("o_11")));
	bean.setVali_type	(request.getParameter("vali_type")==null?"":request.getParameter("vali_type"));
	bean.setDoc_type	(request.getParameter("doc_type")==null?"":request.getParameter("doc_type"));
	
	
	count = e_db.updateEstimate(bean);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">  
  <input type="hidden" name="gubun5" value="<%=gubun5%>">
  <input type="hidden" name="gubun6" value="<%=gubun6%>">  
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">          
  <input type="hidden" name="t_wd" value="<%=t_wd%>">     
  <input type="hidden" name="est_id" value="<%=est_id%>">          
  <input type="hidden" name="a_e" value="<%=a_e%>">            
  <input type="hidden" name="cmd" value="u">
  <input type="hidden" name="e_page" value="u"> 
  <input type="hidden" name="from_page" value="estimate_mng">   
</form>
<script>
<%	if(count==1){%>
	<%if(cmd.equals("u")){%>
		alert("정상적으로 처리되었습니다.");	
			
		document.form1.target='d_content';
		
		<%if(from_page.equals("esti_mng_atype_u.jsp")){%>
		document.form1.action = "<%=from_page%>";
		<%}else{%>
		document.form1.action = "esti_mng_u.jsp";
		<%}%>
		document.form1.submit();	
	<%}%>
	
	/*
		var rent_dt = parseInt(<%=AddUtil.getDate(4)%>);
		
		if(rent_dt >= 20050120){
			if(rent_dt >= 20060521){
				if(rent_dt >= 20060818){
					if(rent_dt >= 20070316){
						document.form1.action = "/acar/estimate_mng/esti_mng_i_a_2_20070316.jsp";
					}else{					
						document.form1.action = "/acar/estimate_mng/esti_mng_i_a_2_20060818.jsp";
					}
				}else{
					document.form1.action = "/acar/estimate_mng/esti_mng_i_a_2_20060521.jsp";
				}
			}else{
				document.form1.action = "/acar/estimate_mng/esti_mng_i_a_2_20050120.jsp";
			}
			document.form1.action = "/acar/estimate_mng/esti_mng_i_a_2_20070316.jsp";
		}	
		
		document.form1.submit();		
		
		*/
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>

