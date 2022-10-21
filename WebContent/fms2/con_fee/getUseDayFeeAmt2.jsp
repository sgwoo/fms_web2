<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.fee.*, acar.cont.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_id 		= request.getParameter("user_id")		==null?"":request.getParameter("user_id");//로그인-ID
	
	int fee_amt 		= request.getParameter("o_fee_amt")		==null?0:AddUtil.parseDigit(request.getParameter("o_fee_amt"));
	int fee_s_amt 		= request.getParameter("o_fee_s_amt")	==null?0:AddUtil.parseDigit(request.getParameter("o_fee_s_amt"));
	int fee_v_amt 		= request.getParameter("o_fee_v_amt")	==null?0:AddUtil.parseDigit(request.getParameter("o_fee_v_amt"));
	
	String use_s_dt 	= request.getParameter("use_s_dt")		==null?"":request.getParameter("use_s_dt");
	String use_e_dt 	= request.getParameter("use_e_dt")		==null?"":request.getParameter("use_e_dt");
	String st 			= request.getParameter("st")			==null?"":request.getParameter("st");
	String dt_auto 		= request.getParameter("dt_auto")		==null?"":request.getParameter("dt_auto");
	int idx 			= request.getParameter("idx")			==null?2:AddUtil.parseInt(request.getParameter("idx"));

	String from_page 	= request.getParameter("from_page")		==null?"":request.getParameter("from_page");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String fee_tm 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);	
	
	//대여기본정보
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");	
	
	int f_fee_tm 	= af_db.getFMinFeeTm(m_id, l_cd);

	if(from_page.equals("/fms2/con_fee/fee_scd_u_tm_est.jsp")){
		f_fee_tm = 1;
	}
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	
	String mons = c_db.getMons(use_e_dt, use_s_dt);
	
	Hashtable ht = af_db.getUseMonDay(use_e_dt, use_s_dt);
	
	//20170421 기준변경 (예)대여기간 2017-04-18 ~ 2020-04-18
	if((base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && AddUtil.parseInt(fee_tm) == f_fee_tm && AddUtil.parseInt(AddUtil.replace(f_fee.getRent_start_dt(),"-","")) >= 20170421){
		mons = c_db.getMons2(use_e_dt, use_s_dt);
		ht = af_db.getUseMonDay2(use_e_dt, use_s_dt);
	}	
	
	String fm = "parent.document.form1";
	
	if(st.equals("view")) fm = "opener.document.form1";
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

function set_reqamt_monday(){
	
	var fm = <%=fm%>;
	
	fm.u_mon.value = <%=ht.get("U_MON")%>;
	fm.u_day.value = <%=ht.get("U_DAY")%>;
	
	var amt 	= 0;
	var s_amt 	= 0;
	var v_amt 	= 0;		
	var cau 	= '';
	
	var fee_s_amt = <%=fee_s_amt%>;
	var fee_v_amt = <%=fee_v_amt%>;
	var fee_amt   = <%=fee_amt%>;
	
	if(fee_s_amt == 0 && fee_amt >0){
		fee_s_amt = sup_amt(fee_amt);
		fee_v_amt = fee_amt - fee_s_amt;
	}
	
	amt 		= Math.round((fee_amt*<%=ht.get("U_MON")%>) + ( fee_amt/30 * <%=ht.get("U_DAY")%>));
	s_amt 	= sup_amt(amt);
	v_amt 	= amt - s_amt;
	
	if(<%=ht.get("U_MON")%>==1 && <%=ht.get("U_DAY")%>==0){
		s_amt 	= fee_s_amt;
		v_amt 	= fee_v_amt;
		amt 	= fee_amt;		
	}
	
	
	
	//대여료 일자계산	
	
	if(<%=ht.get("U_MON")%> >0){	
		if(<%=ht.get("U_DAY")%> == 0){	
			cau	= '일할계산내역:'+fee_amt+'원(월대여료VAT포함)*<%=ht.get("U_MON")%>개월';
		}else{
			cau	= '일할계산내역:('+fee_amt+'원(월대여료VAT포함)*<%=ht.get("U_MON")%>개월) + ( '+fee_amt+'원/30일*<%=ht.get("U_DAY")%>일)';
		}			
	}else{
		cau	= '일할계산내역:'+fee_amt+'원(월대여료VAT포함)/30일*<%=ht.get("U_DAY")%>일';
	}	
	fm.cng_cau.value		= cau;	
	fm.etc.value				= cau;	

	
}
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>
<!--
	set_reqamt_monday();
//-->
</script>
</body>
</html>
