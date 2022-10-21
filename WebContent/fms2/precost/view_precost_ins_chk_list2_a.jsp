<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*, acar.common.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String cost_ym = request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String cost_st = request.getParameter("cost_st")==null?"":request.getParameter("cost_st");
	String car_use = request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String com_id  = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String chk_st  = request.getParameter("chk_st")==null?"":request.getParameter("chk_st");
	
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	
	Vector vts = new Vector();
	int vt_size = 0;
	
	int flag = 0;
	
	//보험선급비용 미처리스트
	if(cost_st.equals("2")){
		vts = ai_db.getInsurPrecostYmSettleChkList(cost_ym, cost_st, car_use, com_id, chk_st);
		vt_size = vts.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
			String car_mng_id	= String.valueOf(ht.get("CAR_MNG_ID"));
			String ins_st		= String.valueOf(ht.get("INS_ST"));
			int    cost_amt		= Util.parseInt(String.valueOf(ht.get("COST_AMT")))+Util.parseInt(String.valueOf(ht.get("CHK_AMT2")));
			
			if(!String.valueOf(ht.get("CHK_AMT2")).equals("0")){
				InsurBean ins = ai_db.getInsCase(car_mng_id, ins_st);
				
				PrecostBean cost = new PrecostBean();
				cost.setCar_mng_id	(car_mng_id);
				cost.setCost_id		(ins_st);
				cost.setCost_st		("2");
				cost.setCost_tm		(String.valueOf(ht.get("COST_TM")));
				cost.setCost_ym		(String.valueOf(ht.get("COST_YM")));
				cost.setCost_day	(AddUtil.parseDigit2(String.valueOf(ht.get("COST_DAY"))));
				cost.setCost_amt	(cost_amt);
				cost.setRest_day	(0);
				cost.setRest_amt	(0);
				
				out.println(String.valueOf(ht.get("CAR_NO")));
				out.println(cost.getCar_mng_id());
				out.println(cost.getCost_id());
				out.println(cost.getCost_st());
				out.println(cost.getCost_tm());
				out.println(cost.getCost_ym());
				out.println(cost.getCost_day());
				out.println(cost.getCost_amt());
				out.println(cost.getRest_day());
				out.println(cost.getRest_amt());
				out.println("<br>");
				
				if(!ai_db.updatePrecost(cost)) flag += 1;
			}
			
		}
	}
%>
<form name='form1' method='post'>
</form>  
</body>
</html>
