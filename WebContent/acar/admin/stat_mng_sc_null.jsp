<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_mng.*"%>
<jsp:useBean id="sm_db" scope="page" class="acar.stat_mng.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	int size1 = request.getParameter("mng_size1")==null?0:AddUtil.parseDigit(request.getParameter("mng_size1"));
	int size2 = request.getParameter("mng_size2")==null?0:AddUtil.parseDigit(request.getParameter("mng_size2"));	
	String today = AddUtil.getDate(4);
	int flag = 0;
	int flag2 = 0;
	
	flag2 = sm_db.getInsertYn("stat_mng", today);
	
	if(flag2 == 0){
		String mng_id[] = request.getParameterValues("mng_id");
		String c_cnt_o[] = request.getParameterValues("c_cnt_o");
		String c_cnt_t[] = request.getParameterValues("c_cnt_t");		
		String c_ga[] = request.getParameterValues("c_ga");
		String g_cnt_o[] = request.getParameterValues("g_cnt_o");
		String g_cnt_t[] = request.getParameterValues("g_cnt_t");
		String g_ga[] = request.getParameterValues("g_ga");
		String b_cnt_o[] = request.getParameterValues("b_cnt_o");
		String b_cnt_t[] = request.getParameterValues("b_cnt_t");
		String b_ga[] = request.getParameterValues("b_ga");
		String p_cnt_o[] = request.getParameterValues("p_cnt_o");
		String p_cnt_t[] = request.getParameterValues("p_cnt_t");
		String p_ga[] = request.getParameterValues("p_ga");
		String cg_cnt_b1[] = request.getParameterValues("cg_cnt_b1");
		String cg_cnt_b2[] = request.getParameterValues("cg_cnt_b2");
		String cg_cnt_m1[] = request.getParameterValues("cg_cnt_m1");
		String cb_cnt_b1[] = request.getParameterValues("cb_cnt_b1");
		String cb_cnt_b2[] = request.getParameterValues("cb_cnt_b2");
		String cb_cnt_m1[] = request.getParameterValues("cb_cnt_m1");
		String cg_ga[] = request.getParameterValues("cg_ga");
		String cb_ga[] = request.getParameterValues("cb_ga");
		
		for(int i=0; i<size1+size2; i++){
			StatMngBean bean = new StatMngBean();
			bean.setSave_dt(today);
			bean.setSeq(AddUtil.addZero2(i));
			bean.setUser_id(mng_id[i]);			
			bean.setClient_cnt_o(AddUtil.parseInt(c_cnt_o[i]));
			bean.setClient_cnt_t(AddUtil.parseInt(c_cnt_t[i]));
			bean.setClient_ga(AddUtil.parseFloat(c_ga[i]));
			bean.setGen_cnt_o(AddUtil.parseInt(g_cnt_o[i]));
			bean.setGen_cnt_t(AddUtil.parseInt(g_cnt_t[i]));
			bean.setGen_ga(AddUtil.parseFloat(g_ga[i]));
			bean.setBas_cnt_o(AddUtil.parseInt(b_cnt_o[i]));
			bean.setBas_cnt_t(AddUtil.parseInt(b_cnt_t[i]));
			bean.setBas_ga(AddUtil.parseFloat(b_ga[i]));	
			bean.setPut_cnt_o(AddUtil.parseInt(p_cnt_o[i]));
			bean.setPut_cnt_t(AddUtil.parseInt(p_cnt_t[i]));
			bean.setPut_ga(AddUtil.parseFloat(p_ga[i]));
			bean.setReg_id(user_id);
			bean.setC_Gen_cnt_b1(AddUtil.parseInt(cg_cnt_b1[i]));
			bean.setC_Gen_cnt_b2(AddUtil.parseInt(cg_cnt_b2[i]));
			bean.setC_Gen_cnt_m1(AddUtil.parseInt(cg_cnt_m1[i]));
			bean.setC_Gen_ga(AddUtil.parseFloat(cg_ga[i]));
			bean.setC_BP_cnt_b1(AddUtil.parseInt(cb_cnt_b1[i]));
			bean.setC_BP_cnt_b2(AddUtil.parseInt(cb_cnt_b2[i]));
			bean.setC_BP_cnt_m1(AddUtil.parseInt(cb_cnt_m1[i]));
			bean.setC_BP_ga(AddUtil.parseFloat(cb_ga[i]));
			
			if(!sm_db.insertStatMng(bean)) flag = 1;
		}
	}
%>
<form name='form1' action='stat_mng_sc.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=today%>'>
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag2 != 0){%>
	alert('이미 등록되었습니다.\n\n동일일자는 한번만 등록 가능합니다.');
<%	}else{
		if(flag != 0){%>
		alert('등록 오류발생!');
<%		}else{%>
		alert('등록되었습니다.');
		fm.submit();				
<%		}
	}%>
</script>
</body>
</html>