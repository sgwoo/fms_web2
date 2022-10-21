<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cls.*, acar.cont.* "%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<%
	String rent_mng_id =  request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd =  request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_start_dt =  request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt =  request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	String cls_dt =  request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String cls_st =  request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_gubun =  request.getParameter("cls_gubun")==null?"":request.getParameter("cls_gubun");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String dly_c_dt =  request.getParameter("dly_c_dt")==null?"":request.getParameter("dly_c_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
//	System.out.println("dly_c_dt =" + dly_c_dt + " |rent_end_dt=" + rent_end_dt + "| cls_dt = " + cls_dt + "| cls_st=" + cls_st +"| rent_l_cd = " + rent_l_cd );
	
					
	Hashtable base = as_db.getSettleBaseRm(rent_mng_id, rent_l_cd, AddUtil.replace(cls_dt,"-",""), dly_c_dt );
		
	int  r_day = AddUtil.parseInt( (String)base.get("R_DAY") ); //2월달 계약인 경우 일수 계산시 문제 : 28일이 1달  30일이 1달???	
	
			//월렌트정보
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	
        //
   String per = f_fee_rm.getAmt_per();	
		
	//월대여료대부 적용율
	Hashtable day_pers = c_db.getEstiRmDayPers(per);

	int add_amt_d = 0;  //1달미만 사용인 경우 위약금 ( 환불금액: 대여료 - 위약금)
	int r_day_per = 0;
	
	int day_per[] = new int[30];

	//적용율값 카운트
	int day_cnt = 0;

	//이용기간
	int tot_months = AddUtil.parseInt((String)base.get("R_MON"));  
	int tot_days = AddUtil.parseInt((String)base.get("R_DAY"));  			
								
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
			
	if(tot_months == 0  ){		
	           if ( day_cnt >  tot_days ) {	
			add_amt_d = (new Double(AddUtil.parseInt((String)base.get("FEE_S_AMT"))	)).intValue() * r_day_per / 100;
		}	

	}else if(tot_months > 0){				


	}
				
//	out.println(add_amt_d);	
		
%>
	t_fm = parent.form1;
<% if ( cls_st.equals("8") && !cls_gubun.equals("Y") ) { %> 	
	t_fm.cls_st.value = '';	
<% } %>	
	
	t_fm.r_mon.value		= '<%=base.get("R_MON")%>';
<% if (r_day < 0 ) { %> 
	t_fm.r_day.value 		= '<%=base.get("S_DAY")%>';
<% } else  { %>
	t_fm.r_day.value 		= '<%=base.get("R_DAY")%>';
<% } %>
	

	
	<%if(from_page.equals("")){%>
	
	t_fm.ex_di_amt.value 	= '<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_S_AMT"))+AddUtil.parseInt((String)base.get("DI_AMT")))%>';
	t_fm.ex_di_v_amt.value 	= '<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_V_AMT"))+AddUtil.parseInt((String)base.get("DI_V_AMT")))%>';
	t_fm.nfee_mon.value		= '<%=base.get("S_MON")%>';
	t_fm.nfee_day.value		= '<%=base.get("S_DAY")%>';	
	t_fm.nfee_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>';
	t_fm.dly_amt.value 		= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DLY_AMT")))%>';
//	t_fm.r_con_mon.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("R_CON_MON")))%>';
	
	t_fm.s_mon.value		= '<%=base.get("S_MON")%>';
	t_fm.s_day.value		= '<%=base.get("S_DAY")%>';
	t_fm.hs_mon.value		= '<%=base.get("HS_MON")%>';
	t_fm.hs_day.value		= '<%=base.get("HS_DAY")%>';
	
	t_fm.nnfee_s_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>';	
	t_fm.di_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_AMT")))%>';
	t_fm.di_v_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_V_AMT")))%>';
	t_fm.ex_s_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_S_AMT")))%>';
	t_fm.ex_v_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_V_AMT")))%>';

//	t_fm.dly_s_dt.value		= '<%=base.get("DLY_S_DT")%>';
//	t_fm.dly_e_dt.value		= '<%=base.get("DLY_E_DT")%>';
	
	t_fm.use_s_dt.value		= '<%=base.get("USE_S_DT")%>';
	t_fm.use_e_dt.value		= '<%=base.get("USE_E_DT")%>';
	
//	t_fm.ex_s_dt.value		= '<%=base.get("EX_S_DT")%>';
//	t_fm.ex_e_dt.value		= '<%=base.get("EX_E_DT")%>';
	
	t_fm.rcon_mon.value	= '<%=base.get("N_MON")%>';
	t_fm.rcon_day.value		= '<%=base.get("N_DAY")%>';
	
//	t_fm.df_e_dt.value		= '<%=base.get("DF_E_DT")%>';
//	t_fm.df_s_amt.value		= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DF_S_AMT")))%>';
	t_fm.add_amt_d.value	= '<%=add_amt_d%>';
	t_fm.day_cnt.value	= '<%=day_cnt%>';
	
		
	t_fm.rr_s_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("RR_S_AMT")))%>';
	t_fm.rr_v_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("RR_V_AMT")))%>';
	t_fm.rr_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("RR_AMT")))%>';
	
	t_fm.rent_days.value	=  '<%=base.get("RENT_DAYS")%>';	
   
	parent.set_init();		

	<%}%>
	
</script>
</body>
</html>
