<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
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
	String dly_c_dt =  request.getParameter("dly_c_dt")==null?"":request.getParameter("dly_c_dt");
	
//	System.out.println("dly_c_dt =" + dly_c_dt + " |rent_end_dt=" + rent_end_dt + "| cls_dt = " + cls_dt + "| cls_st=" + cls_st +"| rent_l_cd = " + rent_l_cd );
	
	if ( cls_st.equals("8") ) {		
			dly_c_dt = AddUtil.replace(dly_c_dt,"-","");
	} else {
			dly_c_dt = "";
	}
	
	Hashtable base = as_db.getSettleBase(rent_mng_id, rent_l_cd, AddUtil.replace(cls_dt,"-",""), dly_c_dt );
	
	//System.out.println("r_day=" + base.get("EX_S_AMT")); 

	int  r_day = AddUtil.parseInt( (String)base.get("R_DAY") ); //2월달 계약인 경우 일수 계산시 문제 : 28일이 1달  30일이 1달???	
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
	t_fm.r_con_mon.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("R_CON_MON")))%>';
	
	t_fm.s_mon.value		= '<%=base.get("S_MON")%>';	
	t_fm.s_day.value		= '<%=base.get("S_DAY")%>';
	t_fm.nnfee_s_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>';	
	t_fm.di_amt.value 	    = '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_AMT")))%>';
	t_fm.di_v_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_V_AMT")))%>';
	t_fm.ex_s_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_S_AMT")))%>';
	t_fm.ex_v_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_V_AMT")))%>';
	
	t_fm.ddly_s_dt.value	= '<%=base.get("DDLY_S_DT")%>';
	t_fm.dly_s_dt.value		= '<%=base.get("DLY_S_DT")%>';
	t_fm.dly_e_dt.value		= '<%=base.get("DLY_E_DT")%>';
	t_fm.use_s_dt.value		= '<%=base.get("USE_S_DT")%>';
	t_fm.use_e_dt.value		= '<%=base.get("USE_E_DT")%>';	
	
	t_fm.rcon_mon.value		= '<%=base.get("N_MON")%>';
	t_fm.rcon_day.value		= '<%=base.get("N_DAY")%>';
	
	t_fm.hs_mon.value		= '<%=base.get("HS_MON")%>';
	t_fm.hs_day.value		= '<%=base.get("HS_DAY")%>';
			
//	if(t_fm.r_day.value != '0'){
//	  if ( toInt(t_fm.rent_end_dt.value) <=  toInt(replaceString("-","",t_fm.cls_dt.value))) { //만기이후
//	  } else {
	   				  
//		t_fm.rcon_mon.value 		= toInt(t_fm.con_mon.value) - toInt(t_fm.r_mon.value) - 1;		
//		t_fm.rcon_day.value 		= 30-toInt(t_fm.r_day.value);
//	  }	
//	}else{
//		t_fm.rcon_mon.value 		= toInt(t_fm.con_mon.value) - toInt(t_fm.r_mon.value);
//		t_fm.rcon_day.value 		= toInt(t_fm.r_day.value);
//	}	

	parent.set_init();	

	<%}%>
</script>
</body>
</html>
