<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	int flag = 0;
	
	ClsBean cls = new ClsBean();
	
	cls.setRent_mng_id(request.getParameter("m_id"));
	cls.setRent_l_cd(request.getParameter("l_cd"));
	cls.setTerm_yn("Y");
	cls.setCls_st(cls_st);
	cls.setCls_dt(request.getParameter("cls_dt"));
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//해지내역
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//해지내역
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//해지내역
	cls.setPp_st(request.getParameter("pp_st")==null?"":	request.getParameter("pp_st"));
	cls.setCls_doc_yn(cls_doc_yn);
	cls.setReg_id(request.getParameter("user_id"));
	
	if(cls_st.equals("2")){//중도해지
		if(cls_doc_yn.equals("Y")){
			cls.setCancel_yn(request.getParameter("cancel_yn")==null?"":request.getParameter("cancel_yn"));
			cls.setGrt_amt(request.getParameter("grt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("grt_amt")));
			cls.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
			cls.setIfee_mon(request.getParameter("ifee_mon")==null?"":		request.getParameter("ifee_mon"));
			cls.setIfee_day(request.getParameter("ifee_day")==null?"":		request.getParameter("ifee_day"));
			cls.setIfee_ex_amt(request.getParameter("ifee_ex_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_ex_amt")));
			cls.setRifee_s_amt(request.getParameter("rifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_s_amt")));
			cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
			cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
			cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
			cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
			cls.setNfee_s_amt(request.getParameter("nfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("nfee_s_amt")));
			cls.setNfee_mon(request.getParameter("nfee_mon")==null?"":		request.getParameter("nfee_mon"));
			cls.setNfee_day(request.getParameter("nfee_day")==null?"":		request.getParameter("nfee_day"));
			cls.setNfee_amt(request.getParameter("nfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt")));
			cls.setDly_amt(request.getParameter("dly_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt")));
			cls.setEx_di_amt(request.getParameter("ex_di_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_di_amt")));
			cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt")));
			cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt")));
			cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));
			cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));
			cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt")));
			cls.setDft_int(request.getParameter("dft_int")==null?"":		request.getParameter("dft_int"));
			cls.setDft_amt(request.getParameter("dft_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt")));
			cls.setCar_ja_amt(request.getParameter("car_ja_amt")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt")));
			cls.setNo_v_amt(request.getParameter("no_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt")));
			cls.setEtc_amt(request.getParameter("etc_amt")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt")));
			cls.setFine_amt(request.getParameter("fine_amt")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt")));
			cls.setFdft_amt1(request.getParameter("fdft_amt1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1")));
			cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));
			cls.setFdft_dc_amt(request.getParameter("fdft_dc_amt")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_dc_amt")));
		}
		cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("cls_s_amt")));
		cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("cls_v_amt")));
		cls.setCls_est_dt(request.getParameter("cls_est_dt")==null?"":	request.getParameter("cls_est_dt"));
		if(cls.getCls_st().equals("2") && cls.getCls_est_dt().equals(""))	cls.setCls_est_dt(cls.getCls_dt());
		cls.setExt_dt(request.getParameter("ext_dt")==null?"":			request.getParameter("ext_dt"));
		cls.setExt_id(request.getParameter("ext_id")==null?"":			request.getParameter("ext_id"));
		cls.setNo_dft_yn(request.getParameter("no_dft_yn")==null?"N":	request.getParameter("no_dft_yn"));
		cls.setNo_dft_cau(request.getParameter("no_dft_cau")==null?"":	request.getParameter("no_dft_cau"));
	}else if(cls_st.equals("3")){//영업소변경
		cls.setP_brch_cd(request.getParameter("p_brch_cd")==null?"":	request.getParameter("p_brch_cd"));//구영업소코드
		cls.setNew_brch_cd(request.getParameter("new_brch_cd")==null?"":request.getParameter("new_brch_cd"));//신규영업소코드
		cls.setTrf_dt(request.getParameter("trf_dt")==null?"":			request.getParameter("trf_dt"));//이관일자
	}else if(cls_st.equals("8")){//매입옵션
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));
		cls.setOpt_dt(request.getParameter("opt_dt")==null?"":			request.getParameter("opt_dt"));
		cls.setOpt_mng(request.getParameter("opt_mng")==null?"":		request.getParameter("opt_mng"));
	}
	
	if(!as_db.insertCls2(cls))	flag += 1;
	
	//출고전.후 해약 구분
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	//연체리스트 미선택 정보
	String dly_count = request.getParameter("dly_count")==null?"":request.getParameter("dly_count");
	String dly_value = request.getParameter("dly_value")==null?"":request.getParameter("dly_value");
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='m_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 

</form>
<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 삽입 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 삽입 성공..
		
		if(cls.getCls_st().equals("4") || cls.getCls_st().equals("5")){	//차종변경 or 계약이관	%>

			fm.action='../car_rent/con_reg_frame.jsp';
			fm.target='d_content';
			parent.window.close();
			fm.submit();			
			
<%		}else{				 											// 중도해지 or 계약만료 or 매각 or 영업소변경 or 매입옵션 or 폐차
			
			if(!as_db.closeCont(cls.getRent_mng_id(), cls.getRent_l_cd(), cls.getCls_st(), dly_count, dly_value, car_no, cls.getCls_dt())){	//실패%>

				alert('오류발생!');
				location='about:blank';

<%			}else{															//성공%>

				alert('처리되었습니다');
				fm.mode.value = '1';
				if(fm.cls_st.value == '1') fm.cont_st.value = '6';
				if(fm.cls_st.value == '2') fm.cont_st.value = '7';
				if(fm.cls_st.value == '3') fm.cont_st.value = '8';
				if(fm.cls_st.value == '4') fm.cont_st.value = '9';
				if(fm.cls_st.value == '5') fm.cont_st.value = '10';
				if(fm.cls_st.value == '6') fm.cont_st.value = '11';
				if(fm.cls_st.value == '7') fm.cont_st.value = '12';
				fm.s_kd.value = '1';
				fm.t_wd.value = fm.l_cd.value;
				fm.action='../car_rent/con_frame_s.jsp';		
				fm.target='d_content';		
				parent.window.close();		
				fm.submit();			

<%			}
		}
	}%>
</script>
</body>
</html>
