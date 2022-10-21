<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*, acar.cont.*, acar.user_mng.*, acar.cls.*, acar.estimate_mng.*"%>
<%@ page import="acar.insur.*, acar.car_sche.*, acar.res_search.*, acar.common.*,   acar.im_email.*,  acar.memo.*, acar.client.* , tax.* "%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"Y":request.getParameter("cls_doc_yn");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	String match 	= request.getParameter("match")==null?"":request.getParameter("match"); //만기매칭 :Y
	
	String car_st 	= request.getParameter("car_st")==null?"":request.getParameter("car_st"); // 업무대여 :5
					
	boolean flag1 = true;
	boolean flag2 = true;
	 	
	int	flag = 0;	
	int	count = 0;	
		
	String from_page 	= "";	
		
	
	CommonDataBase c_db = CommonDataBase.getInstance();		
	
			
	ClsBean cls = new ClsBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	//해지의뢰정보
	ClsEtcBean clsEtc = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = clsEtc.getCls_st_r();
	
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}
			
	String car_mng_id = "";
	
	String bus_id2 = "";
	
	String mng_id = "";
	
	//계약기본정보
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	car_mng_id = base.getCar_mng_id();
	
	bus_id2 = base.getBus_id2();
	
			//거래처정보
	ClientBean client       = al_db.getClient(base.getClient_id());
				
		//선수금 입금일
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
	String real_date = "";
	String r_add_date = "";  //해지부터 1달 후 -> 해지부터 1주일 후 --> 해지부터 3일 후
		
	real_date = cls_dt;
	r_add_date =  c_db.addDay(real_date, 3);  
			
	if (cls_st.equals("8") ) {
	   if ( !opt_ip_dt1.equals("") ) {	    		    	    	
				if ( !cls_dt.equals(opt_ip_dt1) ) {
				 //  real_date = opt_ip_dt1;
				   real_date = cls_dt;
				} else {
				   real_date = cls_dt;
				}		   		
		}	
	}
		
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setTerm_yn("Y");  //해지등록
	cls.setCls_st(cls_st);
	cls.setCls_dt(real_date);
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//실이용기간 월
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//실이용기간 일
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//해지내역
	
	cls.setCls_doc_yn("Y");
	cls.setReg_id(reg_id); //담당자id
	
	if(cls_st.equals("8")){//매입옵션인경우 
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));	
		cls.setFdft_amt3(request.getParameter("fdft_amt3")==null?0:			AddUtil.parseDigit(request.getParameter("fdft_amt3")));	  //매입옵션시 고객납입액

	} else {
	 
		//중도해지, 매입옵션, 만기해지 해지의뢰 등록
		cls.setCancel_yn(request.getParameter("cancel_yn")==null?"":request.getParameter("cancel_yn"));
		cls.setGrt_amt(request.getParameter("grt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("grt_amt")));
		cls.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
		cls.setIfee_mon(request.getParameter("ifee_mon")==null?"":		request.getParameter("ifee_mon"));
		cls.setIfee_day(request.getParameter("ifee_day")==null?"":		request.getParameter("ifee_day"));
		cls.setIfee_ex_amt(request.getParameter("ifee_ex_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_ex_amt")));
		cls.setRifee_s_amt(request.getParameter("rifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_s_amt")));
		cls.setRifee_v_amt(request.getParameter("rifee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_v_amt"))); // 2022-04
		cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
		cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
		cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
		cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
		cls.setRfee_v_amt(request.getParameter("rfee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_v_amt")));
		cls.setNfee_s_amt(request.getParameter("nfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("nfee_s_amt")));
		cls.setNfee_mon(request.getParameter("nfee_mon")==null?"":		request.getParameter("nfee_mon"));
		cls.setNfee_day(request.getParameter("nfee_day")==null?"":		request.getParameter("nfee_day"));
		cls.setNfee_amt(request.getParameter("nfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt_1"))); //미납대여료 당초금액
		cls.setEx_di_amt(request.getParameter("ex_di_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt_1"))); //과부족 대여료 금액 (선납 또는 잔액)
		cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt"))); //대여료 총액
		cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt"))); //월평균대여료
		cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));  //잔여기간
		cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));   //잔여기간
		cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt"))); //잔여기간총대여료
		cls.setDft_int(request.getParameter("dft_int_1")==null?"":		request.getParameter("dft_int_1")); //중도해지 위약율
		cls.setDft_amt(request.getParameter("dft_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //중도해지위약금 당초금액
		cls.setCar_ja_amt(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //면책금 당초금액
		cls.setDly_amt(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //연체료 당초금액
		cls.setEtc_amt(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //차량회수외주비 당초금액
		cls.setEtc2_amt(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //차량회수부대비 당초금액
		cls.setEtc3_amt(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //잔존차량가격 당초금액
		cls.setEtc4_amt(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //기타손해배상금 당초금액
	
		cls.setFine_amt(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //과태료 당초금액
		cls.setNo_v_amt(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //부가세 당초금액
		cls.setFdft_amt1(request.getParameter("fdft_amt1_1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//합계 당초금액
		cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));//고객납입금액
				
		cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_s_amt")));   //해지정산금 공급가
		cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_v_amt")));   //해지정산금 부가세
		cls.setCls_est_dt(request.getParameter("est_dt")==null?"":	request.getParameter("est_dt"));

		if(cls.getCls_est_dt().equals(""))	cls.setCls_est_dt(real_date);			
				
		//추가입금액이 있을 경우 - 정산서 작성시점에
		cls.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //추가입금일
		cls.setEx_ip_amt(request.getParameter("ex_ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_ip_amt")));	  //추가입금액 	
		cls.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //입금은행
		cls.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //입금구좌
		cls.setTot_dist(request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist")));   //차량주행거리
		
		cls.setCms_chk(request.getParameter("cms_chk")==null?"N":request.getParameter("cms_chk"));  //cms인출의뢰
				
		cls.setOver_amt(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //초과운행 확정금액	
		cls.setOver_v_amt(request.getParameter("over_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt_1"))); //초과운행 확정금액 vat
		
		cls.setDfee_s_amt(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1"))); //대여료 확정금액	
		cls.setDfee_v_amt(request.getParameter("dfee_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_v_amt_1"))); //대여료 확정금액 vat
	}
			
	//계약해지등록  - 정산구분 : 1-> 합산정산 , 2->구분정산
	String jung_st = request.getParameter("jung_st")==null?"1":request.getParameter("jung_st");	
	int    h5_amt	= request.getParameter("h5_amt")==null?0:AddUtil.parseDigit(request.getParameter("h5_amt"));
	int    h7_amt	= request.getParameter("h7_amt")==null?0:AddUtil.parseDigit(request.getParameter("h7_amt"));
	h5_amt = h5_amt * (-1);
	h7_amt = h7_amt;
	

   if ( car_st.equals("5") ) { //업무대여 
		if(!as_db.insertCls(cls))	flag += 1;
	} else {
		if ( jung_st.equals("2") ) { 
			
			if(!as_db.insertCls2(cls, h5_amt, h7_amt, jung_st ))	flag += 1;	
			
		} else {
			if(!as_db.insertCls2(cls))	flag += 1;
		}
	}
	
//	System.out.println(" 계약해지 flag 1=" + flag);
		
	 		
	System.out.println(" cls cont 생성 "+car_no+"--------"+ rent_l_cd);	
			    		
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>

<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 저장 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				
     fm.s_kd.value = '2';
   <% if (  !cls_st.equals("14")  ) {%>	
    fm.action='/fms2/cls_cont/lc_cls_u3.jsp';
    <% } else { %>
        fm.action='/fms2/cls_cont/lc_cls_rm_u3.jsp';
    <% } %>    
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
