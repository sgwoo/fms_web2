<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
//	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String reg_id = request.getParameter("reg_id")==null?ck_acar_id:request.getParameter("reg_id");
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	String from_page 	= "";
	
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}
	
	//채권관계, 잔존채권의 처리의견/지시사항
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
	
	cls.setCls_st	(cls_st);
		
	cls.setUpd_id	(user_id);	
	
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
	cls.setNfee_amt(request.getParameter("nfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt"))); //미납대여료 당초금액
	cls.setEx_di_amt(request.getParameter("ex_di_amt")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt"))); //과부족 대여료 금액 (선납 또는 잔액)
	cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt"))); //대여료 총액
	cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt"))); //월평균대여료
	cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));  //잔여기간
	cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));   //잔여기간
	cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt"))); //잔여기간총대여료
	cls.setDft_int(request.getParameter("dft_int")==null?"":		request.getParameter("dft_int")); //중도해지 위약율
	cls.setDft_int_1(request.getParameter("dft_int_1")==null?"":	request.getParameter("dft_int_1")); //중도해지 위약율
	cls.setDft_amt(request.getParameter("dft_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt")));   //중도해지위약금 당초금액
	cls.setCar_ja_amt(request.getParameter("car_ja_amt")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt"))); //면책금 당초금액
	cls.setDly_amt(request.getParameter("dly_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt")));   //연체료 당초금액
	cls.setEtc_amt(request.getParameter("etc_amt")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt")));  //차량회수외주비 당초금액
	cls.setEtc2_amt(request.getParameter("etc2_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt"))); //차량회수부대비 당초금액
	cls.setEtc3_amt(request.getParameter("etc3_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt"))); //잔존차량가격 당초금액
	cls.setEtc4_amt(request.getParameter("etc4_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt"))); //기타손해배상금 당초금액
	
	cls.setFine_amt(request.getParameter("fine_amt")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt"))); //과태료 당초금액
	cls.setNo_v_amt(request.getParameter("no_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt")));   //부가세 당초금액
	cls.setFdft_amt1(request.getParameter("fdft_amt1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1")));//합계 당초금액
	cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));//고객납입금액
		
	cls.setDfee_amt(request.getParameter("dfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt")));   //과부족+미납대여료 당초금액			
	cls.setFine_amt_1(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //과태료 확정금액
	cls.setCar_ja_amt_1(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //면책금 확정금액
	cls.setDly_amt_1(request.getParameter("dly_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //연체료 확정금액
	cls.setEtc_amt_1(request.getParameter("etc_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //차량회수외주비 확정금액
	cls.setEtc2_amt_1(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //차량회수부대비 확정금액
	cls.setDft_amt_1(request.getParameter("dft_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //중도해지위약금 확정금액
	cls.setEx_di_amt_1(request.getParameter("ex_di_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt_1")));   //과부족 확정금액
	cls.setNfee_amt_1(request.getParameter("nfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt_1")));   //대여료 확정금액
	cls.setEtc3_amt_1(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //잔존차량가격 확정금액
	cls.setEtc4_amt_1(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //기타손해배상금 확정금액

	cls.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //부가세 확정금액
	cls.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//합계 당초금액
	cls.setDfee_amt_1(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1")));   //과부족+미납대여료 확정금액
		
	cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_s_amt")));   //해지정산금 공급가
	cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_v_amt")));   //해지정산금 부가세
	
	cls.setEst_amt(request.getParameter("est_amt")==null?0:				AddUtil.parseDigit(request.getParameter("est_amt")));	   //채권약정금액 
			
	if(cls_st.equals("8")){//매입옵션인경우 
			cls.setFdft_amt3(request.getParameter("fdft_amt3")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt3")));//고객납입금액
				
	} 
				
	//세금계산서 발행의뢰건 등록 : 의뢰했더라도 실제세금계산서가 발행안될 수 있음 :장기연체인 경우 (수금시 세금계산서 발행처리)
	cls.setTax_chk0(request.getParameter("tax_chk0")==null?"N":request.getParameter("tax_chk0"));  //중도해지위약금
	cls.setTax_chk1(request.getParameter("tax_chk1")==null?"N":request.getParameter("tax_chk1"));  //차량외주비용
	cls.setTax_chk2(request.getParameter("tax_chk2")==null?"N":request.getParameter("tax_chk2"));  //차량부대비용
	cls.setTax_chk3(request.getParameter("tax_chk3")==null?"N":request.getParameter("tax_chk3"));  //기타손해배상금
	cls.setTax_chk4(request.getParameter("tax_chk4")==null?"N":request.getParameter("tax_chk4"));  // 초과운행 
		
	String tax_supply[] = request.getParameterValues("tax_supply");
    String tax_value[] = request.getParameterValues("tax_value");
	String tax_g[] = request.getParameterValues("tax_g");
	
	int tax_size = tax_g.length;
	for(int i = 0; i<tax_size; i++){
    		String tax_chk = request.getParameter("tax_chk"+i)==null?"N":	request.getParameter("tax_chk"+i);
		//	out.println(tax_chk);
  			if(tax_chk.equals("Y")){
    	       		
        		if (i == 0) {
        			cls.setDft_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setDft_amt_v(AddUtil.parseDigit(tax_value[i]));
       	 		} else if ( i == 1 ){
	       	 		cls.setEtc_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setEtc_amt_v(AddUtil.parseDigit(tax_value[i]));
	       	 	} else if ( i == 2 ){
	       	 		cls.setEtc2_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setEtc2_amt_v(AddUtil.parseDigit(tax_value[i]));
	       	 	} else if ( i == 3 ){
	       	 		cls.setEtc4_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setEtc4_amt_v(AddUtil.parseDigit(tax_value[i]));       	
	       	 	} else if ( i == 4 ){
	       	 		cls.setOver_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setOver_amt_v(AddUtil.parseDigit(tax_value[i]));       		
	       	 	}	
   	
  			} else {
  			
  				if (i == 0) {
        			cls.setDft_amt_s(0);
	       	 		cls.setDft_amt_v(0);
       	 		} else if ( i == 1 ){
	       	 		cls.setEtc_amt_s(0);
	       	 		cls.setEtc_amt_v(0);
	       	 	} else if ( i == 2 ){
	       	 		cls.setEtc2_amt_s(0);
	       	 		cls.setEtc2_amt_v(0);
	       	 	} else if ( i == 3 ){
	       	 		cls.setEtc4_amt_s(0);
	       	 		cls.setEtc4_amt_v(0);       
	       	  	} else if ( i == 4 ){
	       	 		cls.setOver_amt_s(0);
	       	 		cls.setOver_amt_v(0);       		
	       	 	}	  			
  			
  			}
	}				
	
	cls.setOver_amt(request.getParameter("over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("over_amt")));//초과운행 예정금액
	cls.setOver_amt_1(request.getParameter("over_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("over_amt_1")));//초과운행확정금액
			
	boolean cr1_flag = ac_db.updateClsEtcJungSanTax(cls);
	
	int no_v_amt_1 = 0;
	no_v_amt_1 = request.getParameter("no_v_amt_1")==null?0:AddUtil.parseDigit(request.getParameter("no_v_amt_1"));
	
	int fdft_amt1_1 = 0;
	fdft_amt1_1 = request.getParameter("fdft_amt1_1")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_1"));
	
	int t_cnt = ac_db.updateClsEtcJungSanSubTax(rent_mng_id, rent_l_cd, no_v_amt_1, fdft_amt1_1 );
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>
<script language='javascript'>
<%	if(!cr1_flag){  %>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>
		alert("처리되었습니다");
		parent.opener.location.href = "<%=from_page%><%=valus%>";
		parent.window.close();
<%	}			%>
</script>