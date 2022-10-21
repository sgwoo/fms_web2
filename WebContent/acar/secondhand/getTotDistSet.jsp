<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*, acar.estimate_mng.*, acar.cont.*, acar.user_mng.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String add_rent_st 	= request.getParameter("add_rent_st")==null?"":request.getParameter("add_rent_st");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_dt 		= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String a_b 		= request.getParameter("a_b")==null?"1":request.getParameter("a_b");
	String rent_st 		= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String est_st 		= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String mode 	  	= request.getParameter("mode")==null?"":request.getParameter("mode");
	int    fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	String jg_b_dt 		= request.getParameter("jg_b_dt")==null?"":request.getParameter("jg_b_dt");
	String a_j 		= request.getParameter("a_j")==null?"":request.getParameter("a_j");
	String today_dist	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String fee_rent_st	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String accid_serv_zero	= request.getParameter("accid_serv_zero")==null?"":request.getParameter("accid_serv_zero");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_rent_st);
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);

	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	ContFeeBean f_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
	//차량정보-여러테이블 조인 조회
	Hashtable ht2 = shDb.getBase(base.getCar_mng_id(), rent_dt);
		
	out.println("TOT_DIST="+ht2.get("TOT_DIST"));
	out.println("계약시주행거리="+f_fee_etc.getOver_bas_km());
				
		//최초 계약시 주행거리(보유차)가 있으면 
		if(AddUtil.parseDouble(String.valueOf(ht2.get("TOT_DIST")))>0 && f_fee_etc.getOver_bas_km() > 0){
			out.println("최초 계약시 주행거리(보유차)가 있으면");
			Hashtable carOld2 	= c_db.getOld(f_fee.getRent_start_dt(), String.valueOf(ht2.get("SERV_DT")));
			double start_serv_mon = (AddUtil.parseDouble(String.valueOf(carOld2.get("YEAR")))*12)+AddUtil.parseDouble(String.valueOf(carOld2.get("MONTH")));
			//가장 최근의 주행거리가 최초 계약 대여개시일(보유차)로부터 3개월 초과
			if(start_serv_mon>3){
				Hashtable ht3 = shDb.getBase(base.getCar_mng_id(), rent_dt, "1", f_fee.getRent_start_dt(), f_fee_etc.getOver_bas_km(), f_fee_etc.getAgree_dist());
				ht2.put("TODAY_DIST", String.valueOf(ht3.get("TODAY_DIST")));
			//가장 최근의 주행거리가 최초 계약 대여개시일(보유차)로부터 3개월 이내	
			}else{
				Hashtable ht3 = shDb.getBase(base.getCar_mng_id(), rent_dt, "2", f_fee.getRent_start_dt(), f_fee_etc.getOver_bas_km(), f_fee_etc.getAgree_dist());
				ht2.put("TODAY_DIST", String.valueOf(ht3.get("TODAY_DIST")));
			}
			out.println("TODAY_DIST="+ht2.get("TODAY_DIST"));
		}
				
		if(String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
			ht2.put("REG_ID", ck_acar_id);
			ht2.put("SECONDHAND_DT", rent_dt);
			//sh_base table insert
			int count = shDb.insertShBase(ht2);
		}else{
			int chk = 0;
			if(!String.valueOf(ht2.get("SECONDHAND_DT")).equals(rent_dt)) 										chk++;
			if(!String.valueOf(ht2.get("BEFORE_ONE_YEAR")).equals(String.valueOf(ht.get("BEFORE_ONE_YEAR")))) 	chk++;
			if(!String.valueOf(ht2.get("SERV_DT")).equals(String.valueOf(ht.get("SERV_DT")))) 					chk++;
			if(!String.valueOf(ht2.get("TOT_DIST")).equals(String.valueOf(ht.get("TOT_DIST")))) 				chk++;
			if(!String.valueOf(ht2.get("TODAY_DIST")).equals(String.valueOf(ht.get("TODAY_DIST")))) 			chk++;
			if(!String.valueOf(ht2.get("PARK")).equals(String.valueOf(ht.get("PARK")))) 						chk++;
			if(!String.valueOf(ht2.get("TAX_DC_AMT")).equals(String.valueOf(ht.get("TAX_DC_AMT")))) 			chk++;
			if(chk >0){
				ht2.put("SECONDHAND_DT", rent_dt);
				//sh_base table update
				int count = shDb.updateShBase(ht2);
			}
		}
		//차량정보
		ht = shDb.getShBase(base.getCar_mng_id());
		today_dist = String.valueOf(ht.get("TODAY_DIST"));
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
</head>
<body>
</body>
<script language="JavaScript">
<!--
				parent.document.form1.sh_tot_km.value			= <%=ht.get("TOT_DIST")%>;
				parent.document.form1.sh_km_bas_dt.value		= <%=ht.get("SERV_DT")%>;
				parent.document.form1.sh_km.value				= <%=ht.get("TODAY_DIST")%>;
				parent.document.form1.o_sh_km.value				= <%=ht.get("TODAY_DIST")%>;
				parent.document.form1.o_over_agree_dist.value = parseDecimal(toInt(parseDigit(parent.document.form1.o_sh_km.value))-toInt(parseDigit(parent.document.form1.o_b_agree_dist.value)));
				if(toInt(parseDigit(parent.document.form1.o_over_agree_dist.value)) <=0){
					parent.document.form1.o_over_agree_dist_nm.value = '한도내';
				}
				if(toInt(parseDigit(parent.document.form1.o_over_agree_dist.value)) >0){
					parent.document.form1.o_over_agree_dist_nm.value = '한도초과';
				}
				
				parent.getSecondhandCarAmt_h();
			
//-->
</script>
</html>
