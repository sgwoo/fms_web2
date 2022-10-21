<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.short_fee_mng.*, acar.user_mng.*, acar.res_search.*"%>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	//정산금 자동계산
	
	String section 	= request.getParameter("section")==null?"":request.getParameter("section");
	String ins_yn 	= request.getParameter("ins_yn")==null?"":request.getParameter("ins_yn");
	int rent_hour 	= request.getParameter("rent_hour")==null?0:Util.parseDigit(request.getParameter("rent_hour"));
	int rent_days 	= request.getParameter("rent_days")==null?0:Util.parseDigit(request.getParameter("rent_days"));
	int rent_months = request.getParameter("rent_months")==null?0:Util.parseDigit(request.getParameter("rent_months"));
	int add_hour 	= request.getParameter("add_hour")==null?0:Util.parseDigit(request.getParameter("add_hour"));
	int add_days 	= request.getParameter("add_days")==null?0:Util.parseDigit(request.getParameter("add_days"));
	int add_months 	= request.getParameter("add_months")==null?0:Util.parseDigit(request.getParameter("add_months"));
	String cust_st 	= request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String cust_id 	= request.getParameter("cust_id")==null?"":request.getParameter("cust_id");
	int tot_days 	= request.getParameter("tot_days")==null?0:Util.parseDigit(request.getParameter("tot_days"));
	int tot_months 	= request.getParameter("tot_months")==null?0:Util.parseDigit(request.getParameter("tot_months"));
	
	
	String s_cd 	= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");	
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");	
	String sett_dt 	= request.getParameter("sett_dt")==null?"":request.getParameter("sett_dt");	
	int ext_fee_s_amt 	= request.getParameter("ext_fee_s_amt")==null?0:Util.parseDigit(request.getParameter("ext_fee_s_amt"));	
	
	
	int add_fee_s_amt = 0;
	int cls_s_amt = 0;
	int fee_amt = 0;
	int add_amt_m = 0;
	int add_amt_d = 0;
	int add_amt_h = 0;
	int ins_amt = 0;
	int r_day_per = 0;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);	
	
	//단기대여정보
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	
	//연장계약
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
		
	
	if(rent_months != 0){		//개월레벨(amt01m~amt11m)
			fee_amt = sfm_db.getShortFeeAmt(section, "amt_"+AddUtil.addZero2(rent_months)+"m", "2", "");
	}else{
		if(rent_days != 0){ 	//일자레벨(amt01d~amt30d)
			fee_amt = sfm_db.getShortFeeAmt(section, "amt_"+AddUtil.addZero2(rent_days)+"d", "2", "");		
		}else if(rent_hour != 0){ 					//시간레벨(amt_12h)
			fee_amt = sfm_db.getShortFeeAmt(section, "amt_12h", "2", "");
		}
	}
	
	UsersBean user_bean 	= new UsersBean();
	
	//직원가 적용
	if(cust_st.equals("4")){
		user_bean 	= umd.getUsersBean(cust_id);
	}
	
	
	if(add_months != 0)		add_amt_m = fee_amt * 30 * add_months;
	if(add_days != 0)		add_amt_d = (new Double(fee_amt)).intValue() * add_days;
	if(add_hour != 0) 		add_amt_h = (new Double(fee_amt/24)).intValue() * add_hour;
	
	
	int u_mon = 0;
	int u_day = 0;
	int fee_s_amt = 0;
	
	
	
	if(rent_st.equals("12")){
	
		
		String cls_st 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");	
		
		//중도해지
		if(cls_st.equals("2")){
				
			add_amt_m = 0;
			add_amt_d = 0;
			add_amt_h = 0;
			
			
			String per = rf_bean.getAmt_per();
	
		
			//월대여료대부 적용율
			Hashtable day_pers = rs_db.getEstiRmDayPers(per);
	
			int day_per[] = new int[30];

			//적용율값 카운트
			int day_cnt = 0;
								

			for (int j = 0 ; j < 30 ; j++){
				day_per[j] = AddUtil.parseInt((String)day_pers.get("PER_"+(j+1)));
				
				if(j+1 == 30){
					if(day_per[j]>100) 	day_per[j] = 0;
				}else{
					if(day_per[j]>99) 	day_per[j] = 0;
				}
					
				if(day_per[j]>0) 	day_cnt++;	

				if(tot_months == 0){
					//적용일
					if(j+1 == tot_days)	r_day_per = 	day_per[j];	
				}
				
			}			
			

			//실사용기간 1개월미만
			if(tot_months == 0){
							
				add_amt_d = (new Double(rf_bean.getInv_s_amt()+rf_bean.getNavi_s_amt())).intValue() * r_day_per / 100;
											
			
			//실사용기간 1개월이상
			}else if(tot_months > 0){
				
				Hashtable ht = new Hashtable();
				
				out.println("Ret_plan_dt="+rc_bean.getRet_plan_dt());
				out.println("sett_dt="+sett_dt);
				out.println("ext_size="+ext_size);
				
				
				
				//위약금 : 잔여기간대여료의 10%
				if(ext_size==0){					
					ht = af_db.getUseMonDay(rc_bean.getRet_plan_dt(), sett_dt);		
					fee_s_amt = rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt();
				}else{
					Hashtable ext = (Hashtable)exts.elementAt(ext_size-1);					
					ht = af_db.getUseMonDay(String.valueOf(ext.get("RENT_END_DT")),sett_dt);
					fee_s_amt = ext_fee_s_amt;
					if(fee_s_amt == 0) fee_s_amt = rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt();								
				}
				
				u_mon = AddUtil.parseInt(String.valueOf(ht.get("U_MON")));
				u_day = AddUtil.parseInt(String.valueOf(ht.get("U_DAY")));
							
				
				add_amt_d =   ((new Double(fee_s_amt)).intValue() * u_mon) + ( (new Double(fee_s_amt)).intValue() / 30 * u_day) ;
				cls_s_amt =    (new Double(add_amt_d)).intValue() * 10 / 100 ;
				
				out.println("u_mon="+u_mon);
				out.println("u_day="+u_day);
				out.println("fee_s_amt="+fee_s_amt);
				out.println("add_amt_d="+add_amt_d);
				out.println("cls_s_amt="+cls_s_amt);
				
				
			}

		//만기해지시
		}else{
		
				
			//신규대여료
			if(ext_size==0){					
				fee_s_amt = rf_bean.getInv_s_amt()+rf_bean.getNavi_s_amt();
			//연장대여료			
			}else{
				fee_s_amt = ext_fee_s_amt;
			}

			add_amt_m = 0;
			add_amt_d = 0;
			add_amt_h = 0;
						
			if(add_months + add_days > 0 || add_months + add_days < 0){
			
				u_mon = add_months;
				u_day = add_days;
																			
				add_amt_d =   ((new Double(fee_s_amt)).intValue() * u_mon) + ( (new Double(fee_s_amt)).intValue() / 30 * u_day) ;											
			}
						
			
		}
		
		
		if(tot_months+tot_days ==0){
			add_amt_m = 0;
			add_amt_d = 0;
			add_amt_h = 0;
		}
		
		
	}
	
			
	
	add_fee_s_amt = add_amt_m + add_amt_d + add_amt_h;
		
%>
<script language='javascript'>
	var fm = parent.form1;
	

	
	<%if(rent_st.equals("12")){%>
		var r_fee_s_amt = 0;
		
		<%if(add_fee_s_amt >0){%>
		
		<%	if(tot_months == 0){%>
					
				r_fee_s_amt = <%=add_fee_s_amt%>;
		
				fm.add_fee_s_amt.value = "-"+parseDecimal(hun_th_rnd(<%=rf_bean.getInv_s_amt()%>-r_fee_s_amt));
		
		<%	}else if(tot_months > 0){%>
		
				<%if(add_months + add_days < 0){%>
				fm.add_fee_s_amt.value = "-"+parseDecimal(hun_th_rnd(<%=add_fee_s_amt%>));
				<%}else if(add_months + add_days > 0){%>
				fm.add_fee_s_amt.value = parseDecimal(hun_th_rnd(<%=add_fee_s_amt%>));
				<%}%>
				
				<%if(cls_s_amt > 0){%>
				fm.cls_s_amt.value = parseDecimal(hun_th_rnd(<%=cls_s_amt%>));	
				parent.set_amt(fm.cls_s_amt);
				<%}%>
		<%	}%>
		
			
		
		<%}%>
		
		
		
		<%if(add_fee_s_amt ==0 && tot_months+tot_days ==0){%>
			fm.add_inv_s_amt.value 	= "-"+fm.ag_inv_s_amt.value;
			fm.add_inv_v_amt.value 	= "-"+fm.ag_inv_v_amt.value;
			fm.add_inv_amt.value 	= "-"+fm.ag_inv_amt.value;
	
			fm.add_navi_s_amt.value = "-"+fm.ag_navi_s_amt.value;
			fm.add_navi_v_amt.value = "-"+fm.ag_navi_v_amt.value;
			fm.add_navi_amt.value 	= "-"+fm.ag_navi_amt.value;
			
			fm.add_etc_s_amt.value 	= "-"+fm.ag_etc_s_amt.value;
			fm.add_etc_v_amt.value 	= "-"+fm.ag_etc_v_amt.value;
			fm.add_etc_amt.value 	= "-"+fm.ag_etc_amt.value;
			
			fm.add_fee_s_amt.value 	= "-"+fm.ag_fee_s_amt.value;
			fm.add_fee_v_amt.value 	= "-"+fm.ag_fee_v_amt.value;
			fm.add_fee_amt.value 	= "-"+fm.ag_fee_amt.value;
		<%}%>
		
	<%}else{%>

		<%if(cust_st.equals("4") && user_bean.getLoan_st().equals("")){%>
			fm.add_fee_s_amt.value = parseDecimal(hun_th_rnd(<%=add_fee_s_amt%>*0.2));
		<%}else if(cust_st.equals("4") && !user_bean.getLoan_st().equals("")){%>		
			fm.add_fee_s_amt.value = parseDecimal(hun_th_rnd(<%=add_fee_s_amt%>*0.25));	
		<%}else{%>	
			fm.add_fee_s_amt.value = <%=add_fee_s_amt%>;	
		<%}%>
	
	<%}%>
	
	fm.add_inv_s_amt.value = fm.add_fee_s_amt.value;	
	
	<%if(ins_yn.equals("Y") && rent_months == 0){%>
//		fm.add_ins_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) * 0.1) ;	
//		parent.set_amt(fm.add_ins_s_amt);	
	<%}%>		
	
	parent.set_amt(fm.add_fee_s_amt);
	parent.set_amt(fm.add_inv_s_amt);
	

	
</script>
</body>
</html>

