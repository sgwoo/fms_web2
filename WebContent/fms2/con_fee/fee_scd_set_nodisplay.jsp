<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.fee.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int fee_pay_tm 			=  request.getParameter("fee_pay_tm")	==null?0:Integer.parseInt(request.getParameter("fee_pay_tm"));
	int con_mon 			=  request.getParameter("rent_mon")		==null?0:Integer.parseInt(request.getParameter("rent_mon"));
	String rent_start_dt 	=  request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_way 		=  request.getParameter("rent_way")		==null?"":request.getParameter("rent_way");
	String from_page 		=  request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");	
	String rent_st 			= request.getParameter("rent_st")		==null?"":request.getParameter("rent_st");
	int    idx 			= request.getParameter("idx")			==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);	
	
	//대여기본정보
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");	
	

	
	
	String rent_end_dt		= "";
	
	if(from_page.equals("/fms2/con_fee/fee_scd_u_addscd.jsp") || from_page.equals("/fms2/lc_rent/lc_im_renew_c.jsp")){
		fee_pay_tm 			=  request.getParameter("add_tm")	==null?0:Integer.parseInt(request.getParameter("add_tm"));
		rent_start_dt		=  request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
		con_mon 			= fee_pay_tm;
	}else{
		// 납입횟수가 0인 경우만 납입횟수를 세팅한다. (일반식 : 대여개월수-3개월, 맞춤식 : 대여개월수)
		if(fee_pay_tm == 0){
			if(rent_way.equals("1"))	fee_pay_tm = con_mon - 3; //일반식
			else 						fee_pay_tm = con_mon;		//맞춤식
		}
	}
	
	// 대여기간 (대여개시일 ~ 대여개시일+계약개월수-1일)
	CommonDataBase c_db = CommonDataBase.getInstance();
	rent_end_dt = c_db.addMonth(rent_start_dt, con_mon);
	
	if(from_page.equals("/fms2/con_fee/fee_scd_u_addscd.jsp") || from_page.equals("/fms2/lc_rent/lc_im_renew_c.jsp")){
		rent_end_dt = c_db.addDay(rent_end_dt, -1);
	}else{
		//출고전대차
		if(idx == 1 && rent_st.equals("")){
	
			//20170421 기준변경 (예)대여기간 2017-04-18 ~ 2020-04-18
			if((base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(rent_start_dt,"-","")) >= 20170421){
		
			}else{
				rent_end_dt = c_db.addDay(rent_end_dt, -1);	
			}
	
		}else if(rent_st.equals("1")){

			//20170421 기준변경 (예)대여기간 2017-04-18 ~ 2020-04-18
			if((base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(rent_start_dt,"-","")) >= 20170421){
		
			}else{
				rent_end_dt = c_db.addDay(rent_end_dt, -1);	
			}
		
		}else{
			rent_end_dt = c_db.addDay(rent_end_dt, -1);	
		}
	}
	

%>

<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>
	t_fm = parent.form1;
	<%if(from_page.equals("/fms2/con_fee/fee_scd_u_addscd.jsp") || from_page.equals("/fms2/lc_rent/lc_im_renew_c.jsp")){%>
	t_fm.rent_end_dt.value		= '<%=AddUtil.ChangeDate2(rent_end_dt)%>';
	<%}else{%>
	t_fm.f_use_start_dt.value	= '<%=rent_start_dt%>';
	t_fm.rent_end_dt.value		= '<%=rent_end_dt%>';
	t_fm.fee_pay_tm.value 		= '<%=fee_pay_tm%>';
	t_fm.f_use_end_dt.focus();
	<%}%>
</script>
</body>
</html>
