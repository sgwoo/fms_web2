<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.credit.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String job = request.getParameter("job")==null?"3":request.getParameter("job");
	
	String est_dt = request.getParameter("est_dt")==null?"":request.getParameter("est_dt");
		
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
	
	int   c_amt = request.getParameter("c_amt")==null?0:AddUtil.parseDigit(request.getParameter("c_amt"));  //선납정산
	int   ex_ip_amt = request.getParameter("ex_ip_amt")==null?0:AddUtil.parseDigit(request.getParameter("ex_ip_amt"));  //추가입금액
	
	int   no_v_amt_1 = request.getParameter("no_v_amt_1")==null?0:AddUtil.parseDigit(request.getParameter("no_v_amt_1"));  //부가세 확정
	int   fdft_amt1_1 = request.getParameter("fdft_amt1_1")==null?0:AddUtil.parseDigit(request.getParameter("fdft_amt1_1"));  //확정금액 계
		
	int   no_v_amt_2 = request.getParameter("no_v_amt_2")==null?0:AddUtil.parseDigit(request.getParameter("no_v_amt_2"));  //부가세 상계
	int   fdft_amt1_2 = request.getParameter("fdft_amt1_2")==null?0:AddUtil.parseDigit(request.getParameter("fdft_amt1_2"));  //상걔금액 계
	
	int   fdft_amt2 = fdft_amt1_1 - c_amt - ex_ip_amt;
			
	int   cls_s_amt 			= fdft_amt2 - no_v_amt_1;
	int   cls_v_amt 			= no_v_amt_1;
		
	String real_date = "";
	real_date = cls.getCls_dt();
	
	String ext_st = cls.getExt_st();  //매입옵션 과입금액 환불여부
	
	int opt_ip_amt = 0;  
  	opt_ip_amt =   AddUtil.parseDigit(request.getParameter("opt_ip_amt1"))  + AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) - AddUtil.parseDigit(request.getParameter("fdft_amt2")) - AddUtil.parseDigit(request.getParameter("opt_amt"))  -  AddUtil.parseDigit(request.getParameter("sui_d_amt")) ;
    			
	int flag = 0;
	
	// 해당페이지 사용유뮤 확인할것 - 2022-04-22 
	
//	System.out.println( "c_amt = " +c_amt + ": ex_ip_amt = " + ex_ip_amt + ": no_v_amt = " +no_v_amt_1 + "| fdft_amt1 = "+ fdft_amt1_1 + "| fdft_amt2= " + fdft_amt2 );
//	System.out.println( "cls_s_amt = " + cls_s_amt + "| cls_v_amt = " + cls_v_amt);
	
	 //cls_cont 수정 
	if(!ac_db.updateClsContReJungsan(rent_mng_id, rent_l_cd, no_v_amt_1, fdft_amt1_1, fdft_amt2, cls_s_amt, cls_v_amt,  user_id))	flag += 1;

	
	//cls_etc 수정			
  	if(!ac_db.updateClsEtcReJungsan(rent_mng_id, rent_l_cd, no_v_amt_1, fdft_amt1_1, fdft_amt2, cls_s_amt, cls_v_amt,  user_id))	flag += 1;

       //scd_ext 수정
	if(!ac_db.updateScdExtReJungsan(rent_mng_id, rent_l_cd,  cls_s_amt, cls_v_amt,  user_id ))	flag += 1;	
	
	//해지의뢰상세내역 - 상계금액 지정 
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);		

	clss.setRent_mng_id(rent_mng_id);
	clss.setRent_l_cd(rent_l_cd);
	clss.setFine_amt_1(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //과태료 확정금액
	clss.setCar_ja_amt_1(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //면책금 확정금액
	clss.setDly_amt_1(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //연체료 확정금액
	clss.setEtc_amt_1(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //차량회수외주비 확정금액
	clss.setEtc2_amt_1(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //차량회수부대비 확정금액
	clss.setDft_amt_1(request.getParameter("dft_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //중도해지위약금 확정금액
	clss.setDfee_amt_1(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1")));   //중도해지위약금 확정금액
	clss.setEtc3_amt_1(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //잔존차량가격 확정금액
	clss.setEtc4_amt_1(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //기타손해배상금 확정금액
	clss.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //부가세 확정금액
	clss.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//합계 당초금액
	
	clss.setFine_amt_2(request.getParameter("fine_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_2"))); //과태료 상계금액
	clss.setCar_ja_amt_2(request.getParameter("car_ja_amt_2")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_2"))); //면책금 상계금액
	clss.setDly_amt_2(request.getParameter("dly_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_2")));   //연체료 상계금액
	clss.setEtc_amt_2(request.getParameter("etc_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_2")));  //차량회수외주비 상계금액
	clss.setEtc2_amt_2(request.getParameter("etc2_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_2"))); //차량회수부대비 상계금액
	clss.setDft_amt_2(request.getParameter("dft_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_2")));   //중도해지위약금 상계금액
	clss.setDfee_amt_2(request.getParameter("dfee_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_2")));   //미납대여료 상계금액
	clss.setEtc3_amt_2(request.getParameter("etc3_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_2"))); //잔존차량가격 상계금액
	clss.setEtc4_amt_2(request.getParameter("etc4_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_2"))); //기타손해배상금 상계금액
	clss.setNo_v_amt_2(request.getParameter("no_v_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_2")));   //부가세 상계금액
	clss.setFdft_amt1_2(request.getParameter("fdft_amt1_2")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_2")));//합계 상계금액
	clss.setDfee_amt_2_v(request.getParameter("dfee_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_2_v")));   //미납대여료 상계금액 vat
	clss.setDft_amt_2_v(request.getParameter("dft_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_2_v")));   //위약금 상계금액 vat
	clss.setEtc_amt_2_v(request.getParameter("etc_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_2_v")));   //외주비용 상계금액 vat
	clss.setEtc2_amt_2_v(request.getParameter("etc2_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_2_v")));   //부대비용 상계금액 vat
	clss.setEtc4_amt_2_v(request.getParameter("etc4_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_2_v")));   //손해배상금 상계금액 vat
	
	clss.setUpd_id(user_id);		
		
	//해지의뢰서브내역 저장	
	if(!ac_db.updateClsEtcSub(clss))	flag += 1;
	
	
	//해지의뢰 세금계산서관련 
	//세금계산서 발행의뢰건 등록 : 의뢰했더라도 실제세금계산서가 발행안될 수 있음 :장기연체인 경우 (수금시 세금계산서 발행처리)
	ClsEtcTaxBean ct = ac_db.getClsEtcTax(rent_mng_id, rent_l_cd, 1);
	ct.setRent_mng_id(rent_mng_id);
	ct.setRent_l_cd	(rent_l_cd);		
	ct.setSeq_no	(1);
	ct.setTax_r_chk0(request.getParameter("tax_r_chk0")==null?"N":request.getParameter("tax_r_chk0"));  //잔여개시대여료
	ct.setTax_r_chk1(request.getParameter("tax_r_chk1")==null?"N":request.getParameter("tax_r_chk1"));  //잔여선납금
	ct.setTax_r_chk2(request.getParameter("tax_r_chk2")==null?"N":request.getParameter("tax_r_chk2"));  //취소대여료
	ct.setTax_r_chk3(request.getParameter("tax_r_chk3")==null?"N":request.getParameter("tax_r_chk3"));  //미납대여료
	ct.setTax_r_chk4(request.getParameter("tax_r_chk4")==null?"N":request.getParameter("tax_r_chk4"));  //해지위약금
	ct.setTax_r_chk5(request.getParameter("tax_r_chk5")==null?"N":request.getParameter("tax_r_chk5"));  //회수외주비용
	ct.setTax_r_chk6(request.getParameter("tax_r_chk6")==null?"N":request.getParameter("tax_r_chk6"));  //회수부대비용
	ct.setTax_r_chk7(request.getParameter("tax_r_chk7")==null?"N":request.getParameter("tax_r_chk7"));  //손해배상금
	
	String tax_r_supply[] = request.getParameterValues("tax_r_supply"); // 총발행예정분
    String tax_r_value[] = request.getParameterValues("tax_r_value");
 
    String tax_rr_supply[] = request.getParameterValues("tax_rr_supply"); // 발행분
    String tax_rr_value[] = request.getParameterValues("tax_rr_value");
    
    String tax_rr_hap[] = request.getParameterValues("tax_rr_hap");  //실제발행분
    
	String tax_r_g[] = request.getParameterValues("tax_r_g");
	String tax_r_bigo[] = request.getParameterValues("tax_r_bigo");
	
	int tax_size = tax_r_g.length;
	for(int i = 0; i<tax_size; i++){
    	    
    	   	if (i == 0) {
    			ct.setRifee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //잔여개시대여료 예정
       	 		ct.setRifee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
       	 		ct.setR_rifee_s_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //잔여개시대여료 발행
       	 		ct.setR_rifee_s_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
       	 	//	ct.setRifee_s_amt(AddUtil.parseDigit(tax_rr_hap[i]));  //실제 발행할 계산서금액
       	 		ct.setRifee_etc(tax_r_g[i]);  //실제 발행할 품목
   	 		} else if ( i == 1 ){
       	 		ct.setRfee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //잔여선납금 예정
       	 		ct.setRfee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
       	 		ct.setR_rfee_s_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //잔여선납금 발행
       	 		ct.setR_rfee_s_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
       	 	//	ct.setRfee_s_amt(AddUtil.parseDigit(tax_rr_hap[i]));
       	 		ct.setRfee_etc(tax_r_g[i]);  //실제 발행할 품목
       	 	} else if ( i == 2 ){
       	 		ct.setDfee_c_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //취소대여료 예정
       	 		ct.setDfee_c_amt_v(AddUtil.parseDigit(tax_r_value[i]));
       	 		ct.setR_dfee_c_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //취소대여료 발행
       	 		ct.setR_dfee_c_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
       	 //		ct.setDfee_c_amt(AddUtil.parseDigit(tax_rr_hap[i]));
       	 		ct.setDfee_c_etc(tax_r_g[i]);  //실제 발행할 품목	
       	 	} else if ( i == 3 ){
       	 		ct.setDfee_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //미납대여료 예정
       	 		ct.setDfee_amt_v(AddUtil.parseDigit(tax_r_value[i]));
       	 		ct.setR_dfee_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //미납대여료 발행
       	 		ct.setR_dfee_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
       	 	//	ct.setDfee_amt(AddUtil.parseDigit(tax_rr_hap[i]));
       	 		ct.setDfee_etc(tax_r_g[i]);  //실제 발행할 품목
       	 	} else if ( i == 4 ){
       	 		ct.setDft_amt_s(AddUtil.parseDigit(tax_r_supply[i]));   //중도해지위약금 예정
       	 		ct.setDft_amt_v(AddUtil.parseDigit(tax_r_value[i]));       
       	 		ct.setR_dft_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));   //중도해지위약금 발행
       	 		ct.setR_dft_amt_v(AddUtil.parseDigit(tax_rr_value[i]));       
       	 //		ct.setDft_amt(AddUtil.parseDigit(tax_rr_hap[i]));       	
       	 		ct.setDft_etc(tax_r_g[i]);  //실제 발행할 품목    		
       	 	} else if ( i == 5 ){
       	 		ct.setEtc_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //외주비용 예정
       	 		ct.setEtc_amt_v(AddUtil.parseDigit(tax_r_value[i])); 
       	 		ct.setR_etc_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //외주비용 발행
       	 		ct.setR_etc_amt_v(AddUtil.parseDigit(tax_rr_value[i])); 
       	 //		ct.setEtc_amt(AddUtil.parseDigit(tax_rr_hap[i]));      
       	 		ct.setEtc_etc(tax_r_g[i]);  //실제 발행할 품목
       	 	} else if ( i == 6 ){
       	 		ct.setEtc2_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //부대비용 예정
       	 		ct.setEtc2_amt_v(AddUtil.parseDigit(tax_r_value[i]));     
       	 		ct.setR_etc2_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //부대비용 발행
       	 		ct.setR_etc2_amt_v(AddUtil.parseDigit(tax_rr_value[i]));     
       	 //		ct.setEtc2_amt(AddUtil.parseDigit(tax_rr_hap[i]));  
       	 		ct.setEtc2_etc(tax_r_g[i]);  //실제 발행할 품목      	
       	 	} else if ( i == 7 ){
       	 		ct.setEtc4_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //손해배상금 예정
       	 		ct.setEtc4_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
       	 		ct.setR_etc4_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //손해배상금 발행
       	 		ct.setR_etc4_amt_v(AddUtil.parseDigit(tax_rr_value[i]));   
       	 	//	ct.setEtc4_amt(AddUtil.parseDigit(tax_rr_hap[i]));       
       	 		ct.setEtc4_etc(tax_r_g[i]);  //실제 발행할 품목
       	 	}	
	}				
	
	if(!ac_db.updateClsEtcTax(ct))	flag += 1;	


%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='bit' value=''>
<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 수정 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 수정 성공.. %>
	
    alert('처리되었습니다');				
	
//	fm.t_wd.value = fm.rent_l_cd.value;
 //   fm.action='/fms2/cls_cont/lc_cls_d_frame.jsp';
    fm.action='/fms2/cls_cont/lc_cls_u3.jsp';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>

