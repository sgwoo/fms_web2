<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.fee.*, acar.cont.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
	<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();

	String user_id 		= request.getParameter("user_id")		==null?"":request.getParameter("user_id");//로그인-ID
	
	int fee_amt 		= request.getParameter("o_fee_amt")		==null?0:AddUtil.parseDigit(request.getParameter("o_fee_amt"));
	int fee_s_amt 		= request.getParameter("o_fee_s_amt")	==null?0:AddUtil.parseDigit(request.getParameter("o_fee_s_amt"));
	int fee_v_amt 		= request.getParameter("o_fee_v_amt")	==null?0:AddUtil.parseDigit(request.getParameter("o_fee_v_amt"));
	
	String rent_end_dt 	= request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt");
	String use_s_dt 	= request.getParameter("use_s_dt")		==null?"":request.getParameter("use_s_dt");
	String use_e_dt 	= request.getParameter("use_e_dt")		==null?"":request.getParameter("use_e_dt");
	String st 			= request.getParameter("st")			==null?"":request.getParameter("st");
	String dt_auto 		= request.getParameter("dt_auto")		==null?"":request.getParameter("dt_auto");
	int idx 			= request.getParameter("idx")			==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	String from_page 	= request.getParameter("from_page")		==null?"":request.getParameter("from_page");
	
	if(from_page.equals("fee_scd_u_mkscd.jsp") || from_page.equals("/fms2/con_fee/fee_scd_u_addscd.jsp") || from_page.equals("/fms2/lc_rent/lc_im_renew_c.jsp")){
		fee_amt 		= request.getParameter("fee_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_amt"));
		fee_s_amt 		= request.getParameter("fee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
		fee_v_amt 		= request.getParameter("fee_v_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_v_amt"));
		
		use_s_dt 		= request.getParameter("f_use_start_dt")==null?"":request.getParameter("f_use_start_dt");
		use_e_dt 		= request.getParameter("f_use_end_dt")	==null?"":request.getParameter("f_use_end_dt");
	}
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String fee_tm 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st2 	= request.getParameter("tm_st2")==null?"":request.getParameter("tm_st2");
	
	String rent_st 	= request.getParameter("rent_st")		==null?"":request.getParameter("rent_st");
	String rtn_st 	= request.getParameter("rtn_st")		==null?"":request.getParameter("rtn_st");			//통합여부
	int    rtn_tm 	= request.getParameter("rtn_tm")		==null?0:AddUtil.parseInt(request.getParameter("rtn_tm"));	//분할갯수
	
	String tm_cng_cau = request.getParameter("tm_cng_cau")		==null?"":request.getParameter("tm_cng_cau");
		
	String rtn_type = "";
	int fee_amt2 			= 0;
	
	if(rtn_st.equals("Y") && rtn_tm == 2 && from_page.equals("fee_scd_u_mkscd.jsp")){
		String v_rtn_type[] 		= request.getParameterValues("rtn_type");
		String v_rtn_fee_amt[] 	= request.getParameterValues("rtn_fee_amt");
		rtn_type = v_rtn_type[1];
		fee_amt2 = AddUtil.parseDigit(v_rtn_fee_amt[1]);
	}
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);	
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//대여기본정보
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");	
	
	int f_fee_tm 	= af_db.getFMinFeeTm(m_id, l_cd);
	
	if(from_page.equals("/fms2/con_fee/fee_scd_u_tm_est.jsp")){
		f_fee_tm = 1;
	}
	
	//계약승계이관스케줄이면 첫회차를 1로 잡는다.
	if(!cont_etc.getRent_suc_dt().equals("") && cont_etc.getSuc_rent_st().equals(rent_st)){
		f_fee_tm 	= af_db.getFMinFeeTm(m_id);
		tm_cng_cau = "계약승계 이관";
	}
	
	out.println("rent_st="+rent_st);
	out.println("car_st="+base.getCar_st());
	out.println("tm_cng_cau="+tm_cng_cau);
	out.println("from_page="+from_page);
	out.println("f_fee_tm="+f_fee_tm);
	out.println("fee_tm="+fee_tm);
	out.println("idx="+idx);

	Hashtable ht = new Hashtable();
	String mons = "";
	
	//호출페이지 from_page
	//'from_page' value='fee_scd_u_mkscd.jsp'                스케줄생성 (출고전대차,신규스케줄)
	//'from_page' value='/fms2/con_fee/fee_scd_u_addscd.jsp' 회차연장변경
	//'from_page' value='/fms2/con_fee/fee_scd_u_tm.jsp'>    회차수정
	//'from_page' value='/fms2/con_fee/fee_scd_u_tm_est.jsp' 회차수정
	//"from_page" 	value="/fms2/lc_rent/lc_im_renew_c.jsp"> 임의연장 월렌트
	//"from_page" 	value="/fms2/lc_rent/lc_im_renew_c.jsp"> 임의연장           
			
	//출고전대차
	if(!tm_cng_cau.equals("만기매칭대차 이관") && idx == 1 && rent_st.equals("") && from_page.equals("fee_scd_u_mkscd.jsp")){	
		mons 	= c_db.getMons2(use_e_dt, use_s_dt);
		ht 		= af_db.getUseMonDay2(use_e_dt, use_s_dt);
		out.println("1) 출고전대차 하루더");
	//신규스케줄
	}else if(!tm_cng_cau.equals("만기매칭대차 이관") && rent_st.equals("1") && from_page.equals("fee_scd_u_mkscd.jsp")){	
		mons 	= c_db.getMons2(use_e_dt, use_s_dt);
		ht 		= af_db.getUseMonDay2(use_e_dt, use_s_dt);
		out.println("2) 신규 하루더");
	//1회차수정
	}else if(!tm_st2.equals("") && rent_st.equals("1") && idx==0 && AddUtil.parseInt(fee_tm) == f_fee_tm && (from_page.equals("/fms2/con_fee/fee_scd_u_tm.jsp")||from_page.equals("/fms2/con_fee/fee_scd_u_tm_est.jsp"))){
		mons 	= c_db.getMons2(use_e_dt, use_s_dt);
		ht 		= af_db.getUseMonDay2(use_e_dt, use_s_dt);
		out.println("3) 1회차 하루더");
	//출고전대차 첫회차 수정	
	}else if(tm_st2.equals("2") && idx == 0 && AddUtil.parseInt(fee_tm)==1){
		mons 	= c_db.getMons2(use_e_dt, use_s_dt);
		ht 		= af_db.getUseMonDay2(use_e_dt, use_s_dt);
		out.println("5) 출고전대차 하루더");		
	}else{
		//변경전 -1일
		ht 		= af_db.getUseMonDay(use_e_dt, use_s_dt);
		mons 	= c_db.getMons(use_e_dt, use_s_dt);
		out.println("4) 예전방식");
	}

	
	//20190704 만기매칭대차이관, 계약승계이관 스케줄은 하루더 계산하지 않는다.
/*
	//20170421 기준변경 (예)대여기간 2017-04-18 ~ 2020-04-18
	if(cont_etc.getRent_suc_dt().equals("") && !tm_cng_cau.equals("계약승계 이관") && !from_page.equals("/fms2/con_fee/fee_scd_u_addscd.jsp") && 
			(base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && 
			AddUtil.parseInt(fee_tm) == f_fee_tm && AddUtil.parseInt(AddUtil.replace(f_fee.getRent_start_dt(),"-","")) >= 20170421){
		mons = c_db.getMons2(use_e_dt, use_s_dt);
		ht = af_db.getUseMonDay2(use_e_dt, use_s_dt);
		out.println("1) 신차 하루더");
	}
	
	//출고전대차
	if(!tm_cng_cau.equals("만기매칭대차 이관") && idx == 1 && rent_st.equals("") && from_page.equals("fee_scd_u_mkscd.jsp")){	
		if((base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(use_s_dt,"-","")) >= 20170421){
			mons = c_db.getMons2(use_e_dt, use_s_dt);
			ht = af_db.getUseMonDay2(use_e_dt, use_s_dt);
			out.println("2) 출고전대차 하루더");
		}
	}
	
	//신차스케줄
	if(!tm_cng_cau.equals("만기매칭대차 이관") && rent_st.equals("1") && from_page.equals("fee_scd_u_mkscd.jsp")){	
		if((base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(use_s_dt,"-","")) >= 20170421){
			mons = c_db.getMons2(use_e_dt, use_s_dt);
			ht = af_db.getUseMonDay2(use_e_dt, use_s_dt);
			out.println("3) 신차 하루더");
		}
	}
	
	//1회차수정
	if(!tm_st2.equals("") && rent_st.equals("1") && idx==0 && AddUtil.parseInt(fee_tm) == f_fee_tm){
		mons = c_db.getMons2(use_e_dt, use_s_dt);
		ht = af_db.getUseMonDay2(use_e_dt, use_s_dt);
		out.println("4) 1회차 하루더");
	}
*/	
	
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
	
	var u_mon 	= <%=ht.get("U_MON")%>;
	var u_day 	= <%=ht.get("U_DAY")%>;
	
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
	
	var amt2 	= 0;
	var s_amt2 	= 0;
	var v_amt2 	= 0;		
	var cau2 	= '';
	
	var fee_s_amt2 = 0;
	var fee_v_amt2 = 0;
	var fee_amt2   = <%=fee_amt2%>;
	
	if(fee_amt2 >0){
		fee_s_amt2 = sup_amt(fee_amt2);
		fee_v_amt2 = fee_amt2 - fee_s_amt2;
	}
	
	amt 		= Math.round((fee_amt*u_mon) + ( fee_amt/30 * u_day));
	s_amt 	= sup_amt(amt);
	v_amt 	= amt - s_amt;

	amt2 		= Math.round((fee_amt2*u_mon) + ( fee_amt2/30 * u_day));
	s_amt2 	= sup_amt(amt2);
	v_amt2 	= amt2 - s_amt2;
	
	
	if(u_mon==1 && u_day==0){
		s_amt 	= fee_s_amt;
		v_amt 	= fee_v_amt;
		amt 		= fee_amt;
		
		s_amt2 	= fee_s_amt2;
		v_amt2 	= fee_v_amt2;
		amt2 		= fee_amt2;
	}
	
	//2월말일자 처리
	<%if(use_s_dt.length()>=8 && use_e_dt.length()>=8 && rent_end_dt.length()>=8 && AddUtil.replace(use_s_dt,"-","").substring(4,8).equals("0228") && AddUtil.replace(use_e_dt,"-","").substring(4,8).equals("0327") && AddUtil.replace(rent_end_dt,"-","").substring(6,8).equals("27")){%>
		s_amt 	= fee_s_amt;
		v_amt 	= fee_v_amt;
		amt 		= fee_amt;
		s_amt2 	= fee_s_amt2;
		v_amt2 	= fee_v_amt2;
		amt2 		= fee_amt2;
		u_mon		= 1;			
		u_day		= 0;
	<%}%>
	//2월말일자 처리
	<%if(use_s_dt.length()>=8 && use_e_dt.length()>=8 && rent_end_dt.length()>=8 && AddUtil.replace(use_s_dt,"-","").substring(4,8).equals("0229") && AddUtil.replace(use_e_dt,"-","").substring(4,8).equals("0328") && AddUtil.replace(rent_end_dt,"-","").substring(6,8).equals("28")){%>
		s_amt 	= fee_s_amt;
		v_amt 	= fee_v_amt;
		amt 		= fee_amt;			
		s_amt2 	= fee_s_amt2;
		v_amt2 	= fee_v_amt2;
		amt2 		= fee_amt2;
		u_mon	= 1;			
		u_day	= 0;
	<%}%>
	
	
	fm.u_mon.value = u_mon;
	fm.u_day.value = u_day;

	
	<%if(from_page.equals("fee_scd_u_mkscd.jsp") || from_page.equals("/fms2/con_fee/fee_scd_u_addscd.jsp") || from_page.equals("/fms2/lc_rent/lc_im_renew_c.jsp")){%>
	
	//대여료 일자계산	
	fm.f_fee_s_amt.value 	= parseDecimal( s_amt );
	fm.f_fee_v_amt.value 	= parseDecimal( v_amt );
	fm.f_fee_amt.value		= parseDecimal( amt );
	if(u_mon >0){	
		if(u_day == 0){	
			
		}else{
			cau	= '일할계산내역:('+fee_amt+'원(월대여료VAT포함)*'+u_mon+'개월) + ( '+fee_amt+'원/30일*'+u_day+'일)';
		}
	}else{
		cau	= '일할계산내역:'+fee_amt+'원(월대여료VAT포함)/30일*'+u_day+'일'; 
	}
	fm.cng_cau.value = cau;
	fm.etc.value		 = cau;
	
	<%	if(from_page.equals("fee_scd_u_mkscd.jsp") && rtn_type.equals("4")){%>
	//대여료 일자계산	
	fm.f_rtn2_fee_s_amt.value 	= parseDecimal( s_amt2 );
	fm.f_rtn2_fee_v_amt.value 	= parseDecimal( v_amt2 );
	fm.f_rtn2_fee_amt.value			= parseDecimal( amt2 );
	if(u_mon >0){	
		if(u_day == 0){	
			
		}else{
			cau2	= '일할계산내역:('+fee_amt2+'원(월대여료VAT포함)*'+u_mon+'개월) + ( '+fee_amt2+'원/30일*'+u_day+'일)';
		}
	}else{
		cau2	= '일할계산내역:'+fee_amt2+'원(월대여료VAT포함)/30일*'+u_day+'일'; 
	}	
	fm.etc2.value		 = cau2;
	<%	}%>
	
	
	<%}else{%>
	
	//대여료 일자계산	
	fm.fee_s_amt.value 	= parseDecimal( s_amt );
	fm.fee_v_amt.value 	= parseDecimal( v_amt );
	fm.fee_amt.value	= parseDecimal( amt );		
	if(u_mon >0){	
		if(u_day == 0){	
			
		}else{
			cau	= '일할계산내역:('+fee_amt+'원(월대여료VAT포함)*'+u_mon+'개월) + ( '+fee_amt+'원/30일*'+u_day+'일)';
		}			
	}else{
		cau	= '일할계산내역:'+fee_amt+'원(월대여료VAT포함)/30일*'+u_day+'일';
	}	
	fm.cng_cau.value = cau;
	fm.etc.value		 = cau;
	
	<%}%>
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
