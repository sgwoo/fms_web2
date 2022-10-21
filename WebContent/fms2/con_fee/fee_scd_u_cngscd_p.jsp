<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.insur.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<%
	InsDatabase ins_db = InsDatabase.getInstance();
	
	String auth 		= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 			= request.getParameter("asc")==null?"":request.getParameter("asc");
		
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	String idx 				= request.getParameter("idx")==null?"2":request.getParameter("idx");
	String m_id 			= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 			= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 			= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 			= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq			= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String gubun 			= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cng_st 			= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	
	String fee_tm 			= request.getParameter("r_fee_tm")==null?"":request.getParameter("r_fee_tm");
	String c_all 			= request.getParameter("c_all")==null?"N":request.getParameter("c_all");
	String max_auto 		= request.getParameter("max_auto")==null?"N":request.getParameter("max_auto");
	String req_dt 			= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String tax_out_dt 		= request.getParameter("tax_out_dt")==null?"":request.getParameter("tax_out_dt");
	String fee_est_dt 		= request.getParameter("fee_est_dt")==null?"":request.getParameter("fee_est_dt");
	String cng_dt 			= request.getParameter("cng_dt")==null?"":request.getParameter("cng_dt");
	String cng_cau 			= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	String s_max_tm 		= request.getParameter("s_max_tm")==null?"":request.getParameter("s_max_tm");
	String comm_value 		= request.getParameter("comm_value")==null?"N":request.getParameter("comm_value");
	String fee_est_day_cng 	= request.getParameter("fee_est_day_cng")==null?"N":request.getParameter("fee_est_day_cng");
	String fee_amt_cng 		= request.getParameter("fee_amt_cng")==null?"N":request.getParameter("fee_amt_cng");
	
	String ins_cng 			= request.getParameter("ins_cng")==null?"N":request.getParameter("ins_cng");
	String ins_cng_amt 		= request.getParameter("ins_cng_amt")==null?"0":request.getParameter("ins_cng_amt");
	String ins_cng_dt 		= request.getParameter("ins_cng_dt")==null?"":request.getParameter("ins_cng_dt");
	String ins_cng_st 		= request.getParameter("ins_cng_st")==null?"":request.getParameter("ins_cng_st");	
	
	String maxday_yn 		= request.getParameter("maxday_yn")==null?"":request.getParameter("maxday_yn");
	String maxday_yn2 		= request.getParameter("maxday_yn2")==null?"":request.getParameter("maxday_yn2");
	
	String a_fee_s_amt		= request.getParameter("a_fee_s_amt")==null?"0":request.getParameter("a_fee_s_amt");
	String a_fee_amt		= request.getParameter("a_fee_amt")==null?"0":request.getParameter("a_fee_amt");
	String fee_amt 			= request.getParameter("fee_amt")==null?"0":request.getParameter("fee_amt");
	String fee_s_amt 		= request.getParameter("fee_s_amt")==null?"0":request.getParameter("fee_s_amt");
	String fee_v_amt 		= request.getParameter("fee_v_amt")==null?"0":request.getParameter("fee_v_amt");
	String mon_st			= request.getParameter("mon_st")==null?"1":request.getParameter("mon_st");
	
	String f_use_start_dt 	= request.getParameter("f_use_start_dt")==null?"":request.getParameter("f_use_start_dt");
	String f_use_end_dt 	= request.getParameter("f_use_end_dt")==null?"":request.getParameter("f_use_end_dt");
	
	out.println(fee_s_amt);
	out.println(fee_v_amt);
	
	
	int flag 	= 0;
	boolean flag2 	= true;

	//프로시저 처리
	InsurExcelBean ins = new InsurExcelBean();
	String reg_code = "SCD-F"+Long.toString(System.currentTimeMillis());
	ins.setReg_code(reg_code);		
	ins.setSeq(1); 							 				
	ins.setValue01(cng_st);	
	ins.setValue02(m_id); 	
	ins.setValue03(l_cd); 		
	ins.setValue04(rent_st); 		
	ins.setValue05(rent_seq); 	
	ins.setValue06(fee_tm);					
	ins.setValue07(c_all); 		
	ins.setValue08(s_max_tm);		
	ins.setValue09(mon_st); 	
	ins.setValue10(max_auto); 		
	ins.setValue11(ins_cng); 	
	ins.setValue12(ins_cng_st); 		
	ins.setValue13(ins_cng_amt);
	ins.setValue14(ins_cng_dt);
	ins.setValue15(comm_value);
	ins.setValue16(fee_amt_cng);
	ins.setValue17(cng_cau);
	ins.setValue18(maxday_yn);
	ins.setValue19(maxday_yn2);
	ins.setValue20(fee_est_day_cng);
	ins.setValue21(fee_s_amt);
	ins.setValue22(fee_v_amt);
	ins.setValue23(req_dt);
	ins.setValue24(tax_out_dt);
	ins.setValue25(fee_est_dt);
	ins.setValue26(f_use_start_dt);
	ins.setValue27(f_use_end_dt);
	ins.setValue28(user_id);
	
	flag2 = ins_db.insertInsExcel2(ins);
	if( !flag2 ){
		++flag;
	}else{
		String  d_flag2 =  af_db.call_sp_scd_fee_cng(reg_code);
	}
	
	
	

%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert("스케줄이 변경되지 않았습니다");
<%	}else{%>		
		alert("스케줄이 변경되었습니다");
		var fm = document.form1;
		fm.target='d_body';
		fm.action='./fee_scd_u_sc.jsp';
		fm.submit();			
		parent.window.close();	
<%	}%>
</script>