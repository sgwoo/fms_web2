<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String r_gubun2 = request.getParameter("r_gubun2")==null?"":request.getParameter("r_gubun2");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String count 	= request.getParameter("count")==null?"":request.getParameter("count");
	
	String v_tm[] 		= request.getParameterValues("v_tm");
	String v_est_amt[] 	= request.getParameterValues("est_amt");
	String v_rc_amt[] 	= request.getParameterValues("rc_amt");
	String v_sum_amt[] 	= request.getParameterValues("sum_amt");
	String v_rest_amt[] = request.getParameterValues("rest_amt");

	Vector vt = new Vector();
	
	for(int i=0; i <= AddUtil.parseInt(count); i++){
		Hashtable ht = new Hashtable();
		ht.put("RENT_MNG_ID", 	rent_mng_id);
		ht.put("RENT_L_CD", 	rent_l_cd);
		ht.put("RENT_ST",    	rent_st);
		ht.put("GUBUN2",  		r_gubun2);
		ht.put("TM",  			v_tm[i]);
		ht.put("EST_AMT",  		v_est_amt[i]);
		ht.put("RC_AMT", 		v_rc_amt[i]);
		ht.put("SUM_AMT",     	v_sum_amt[i]);
		ht.put("REST_AMT",  	v_rest_amt[i]);
		vt.add(ht);
	}
	
	boolean flag = ae_db.updateScdPpCost(vt);
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='scd_pp_cost_case_sc.jsp' method='post' target='c_foot'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
  <input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
  <input type='hidden' name='rent_st' value='<%=rent_st%>'>
 <input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>  
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='r_gubun2' value='<%=r_gubun2%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>
</form>
<script language='javascript'>
<!--
function save(){
	var fm = document.form1;	
	fm.action='scd_pp_cost_case_sc.jsp';
	fm.target='_self';
	fm.submit();	
}

save();
//-->
</script>
</body>
</html>