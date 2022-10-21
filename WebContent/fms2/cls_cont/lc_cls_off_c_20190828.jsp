<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.estimate_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.credit.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.con_tax.*, acar.fee.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cls_dt =  request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
		
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();   //중도매입옵션관련 견적 변수가져오기 
		
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//차량기본정보 - 차량가격 
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
			
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	int fee_size_1 = fee_size - 1;  //fee-size보다 작은것 
   int fee_size_1_opt_amt = 0;
   String fee_size_1_end_dt= "";
   
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//fee 기타 - 주행거리 초과분 계산
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	 int  o_amt =   car1.getOver_run_amt();
	 	 
	 String  agree_yn = car1.getAgree_dist_yn();
	 
	  // agree_dist_yn  1:전액면제,  2:50% 납무,  3:100%납부  : 주행거리가 있어야 계산 가능 20130604  계약부터- 2016년 이후 가능.
	 	
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//담당자 리스트
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
	
	//기본정보
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, "", "");
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd,  Integer.toString(fee_size));
	
	//연대보증인 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	String taecha_st_dt = "";
	
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
	String s_opt_end_dt = "";
	
		
		//네오엠-은행정보
	CodeBean[] banks = neoe_db.getCodeAll();
	int bank_size = banks.length;
	
	int pp_amt = AddUtil.parseInt((String)base1.get("PP_S_AMT"));
	
		//면책금 기청구된 건중 매출처리 여부 구분
	int car_ja_no_amt =  ac_db.getCarServiceBillNo(rent_mng_id, rent_l_cd);
	
		//cms 정보
	Hashtable h_cms = c_db.getCmsBank_info(rent_l_cd);
	
	
	//기존에 등록되었는지 여부
	int reg_cnt = 0;
	reg_cnt= ac_db.getClsEtcCnt(rent_mng_id, rent_l_cd);
	
	//싼타페등 연비보상
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id() );		
//	out.println(fuel_cnt);
 	
	Hashtable  return1 =   new Hashtable();
	
   int  return_amt = 0;
	String return_remark = "";
	
	// 혼다 &  싼타페 - 매입옵션인 경우 
   if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id());
	  	return_amt = Integer.parseInt(String.valueOf(return1.get("AMT")));
	  	return_remark = (String)return1.get("REMARK");
  }
  	
   //car_price 
   int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  - car.getDc_cs_amt() - car.getDc_cv_amt(); 
//	int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  ; 
	float f_opt_per = 0;
		
		//중도매입옵션인 경우 처리위한 변수 가져오기 - 20161024
   String a_a = "2";	//렌트
	if(base.getCar_st().equals("3")) a_a = "1"; //리스
		
	String a_j = "";
	if ( fee_size > 1  ) {  //연장이면 
		a_j = e_db.getVar_b_dt("em", ext_fee.getRent_start_dt());   //   견적기준일로 조회 (연장일때는 대여개시일)                
	 } else {
	 	a_j = e_db.getVar_b_dt("em", base.getRent_dt());   //   견적기준일로 조회 (연장일때는 대여개시일)
	} 
		
    em_bean = e_db.getEstiCommVarCase(a_a, "", a_j);

//중도매입옵션 자동차세 tax_amt, 보험: insure_amt, 일반식 비용: serv_amt 구하기 
	Hashtable sale = ac_db.getVarAmt(rent_mng_id, rent_l_cd);
   
  	int e_tax_amt = AddUtil.parseInt((String)sale.get("TAX_AMT"));
  	int e_insur_amt = AddUtil.parseInt((String)sale.get("INSUR_AMT"));
  	int e_serv_amt = AddUtil.parseInt((String)sale.get("SERV_AMT")); 
   
   //중도매입시 보증금이자효과 금액 
   float  f_grt_amt = AddUtil.parseFloat((String)base1.get("GRT_AMT") ) *  em_bean.getA_f()/100 /12 ;
  
   int  e_grt_amt =  (int)  f_grt_amt ;
         	 	
  	int vt_size8 = 0;
		
	Vector vts8 = ac_db.getScdFeeList(rent_mng_id,  rent_l_cd);
	vt_size8 = vts8.size(); 	
	
	int t_fee_s_amt = 0;
	
				
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
<!--
	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
	//기존차 조회
	function car_search()
	{
		var fm = document.form1;
		window.open("search_ext_car.jsp", "EXT_CAR", "left=100, top=100, width=600, height=500, resizable=yes, scrollbars=yes, status=yes");
	}	

	//고객 보기
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 보기
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			

	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//대여요금
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
		//은행선택시 계좌번호 가져오기
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('선택', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}
	
	function save(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('해지구분을 선택하십시오'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('해지일자를 입력하십시오'); 		fm.cls_dt.focus(); 		return;	}
		
		if(fm.cls_msg.value != '')				{ alert('계산이 정상적으로 처리되지 않았습니다.'); 		fm.cls_dt.focus(); 		return;	}
			
		if( toInt(parseDigit(fm.reg_cnt.value)) > 0 ) { 	 alert('이미 등록된 건입니다. 확인하십시요!!'); 	fm.cls_st.focus(); 		return;	}	
		
	//	alert(fm.mt.value );
//	alert(fm.opt_amt.value );	
	//	alert(fm.mopt_amt.value );	
	//	alert(fm.old_opt_amt.value );	
	//	alert(fm.t_cal_days.value );	
		
				 
	     if( toInt(parseDigit(fm.tot_dist.value)) < 1 ) {
	    	 alert('주행거리를 입력하십시오'); 	
	    	 	fm.tot_dist.focus(); 
	    		fm.cls_st.value="";	
	    		fm.opt_amt.value=fm.mopt_amt.value;	
	    		cal_rc_rest_clear();
	    	 	return;
	    }		
	
		
		if( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ){
		
			if(fm.est_dt.value == '')				{ alert('약정일자를 입력하십시오'); 		fm.est_dt.focus(); 		return;	}		
		}
		
		//고객에게 받을 돈이 있는 경우 - 자구책 check
			
		if( toInt(parseDigit(fm.opt_amt.value)) == 0 ){ alert('매입옵션금액을 입력하십시오'); 		fm.cls_st.focus(); 	return;	}
	 			
		if( toInt(parseDigit(fm.ex_ip_amt.value)) > 0 ){
			//계좌번호		
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;
			var deposit_split = deposit_no.split(":");
			fm.deposit_no2.value = deposit_split[0];			
		
			if(fm.bank_code.value == ""){ alert("은행을 선택하십시오."); return; }			
			if(fm.deposit_no.value == ""){ alert("계좌번호를 선택하십시오."); return; }		
		}	
		
		
			//연체료 및 중도해지 위약금이 차이가 발생한 경우 사유 입력 check
		if (  fm.dly_amt.value != fm.dly_amt_1.value ) {
		    if( get_length(Space_All(fm.dly_reason.value)) == 0  ) {
				alert("연체료 감액사유를 입력하셔야 합니다.!!");
				return;
			}	
			
			if( fm.dly_saction_id.value == '' ) {
				alert("연체료감액 결재자를 지정하셔야 합니다.!!");
				return;
			}	
			
			if( fm.dly_saction_id.value != '000004' ) {
				alert("연체료감액 결재자를 안보국 팀장으로 지정하셔야 합니다. 사전에 협의하십시요.!!");
				return;
			}				
		}
				
		//잔존채권처리!!! 보증보험 - 고객납입금액 
		if ( toInt(parseDigit(fm.gi_amt.value)) -  toInt(parseDigit(fm.fdft_amt2.value))  < 0 ){
					
			 if( replaceString(' ', '',fm.remark.value) == '' && replaceString(' ', '', fm.crd_remark1.value)  == '' && replaceString(' ', '', fm.crd_remark2.value) == '' && replaceString(' ', '', fm.crd_remark3.value) == '' && replaceString(' ', '', fm.crd_remark4.value) == '' && replaceString(' ', '',fm.crd_remark5.value) == '' && replaceString(' ', '', fm.crd_remark6.value) == '' ){
				alert("잔존채권 처리의견 또는 채무자 자구책을 입력하셔야 합니다.!!");
				return;
			 }	
			 
			  if( get_length(Space_All(fm.remark.value)) == 0 && get_length(Space_All(fm.crd_remark1.value))  == 0 && get_length(Space_All(fm.crd_remark2.value))  == 0 && get_length(Space_All(fm.crd_remark3.value))  == 0 && get_length(Space_All(fm.crd_remark4.value))  == 0 && get_length(Space_All(fm.crd_remark5.value))  == 0 && get_length(Space_All(fm.crd_remark6.value))  == 0 ){
				alert("잔존채권 처리의견 또는 채무자 자구책을 입력하셔야 합니다.!!");
				return;
			 }			     		 
			 		 
		}
		
			//계산서발행의뢰
		if ( toInt(parseDigit(fm.dft_amt_1.value))  < 1 ) {
			if ( fm.tax_chk0.checked == true) {
				alert("중도해지 위약금을 확인하세요. 계산서발행의뢰를 할 수 없습니다..!!");
				return;
			 }	
		}
				
		if ( toInt(parseDigit(fm.etc_amt_1.value))  < 1 ) {
			if ( fm.tax_chk1.checked == true) {
				alert("차량회수외주비용을 확인하세요. 계산서발행의뢰를 할 수 없습니다..!!");
				return;
			 }	
		}	
	
		if ( toInt(parseDigit(fm.etc2_amt_1.value))  < 1 ) {
			if ( fm.tax_chk2.checked == true) {
				alert("차량회수부대비용을 확인하세요. 계산서발행의뢰를 할 수 없습니다..!!");
				return;
			 }	
		}				
	 
		if ( toInt(parseDigit(fm.etc4_amt_1.value))  < 1 ) {
			if ( fm.tax_chk3.checked == true) {
				alert("기타손해배상금을 확인하세요. 계산서발행의뢰를 할 수 없습니다..!!");
				return;
			 }	
		}	
		
		/*
		if ( toInt(parseDigit(fm.over_amt_1.value))  < 1 ) {
			if ( fm.tax_chk4.checked == true) {
				alert("초과운행부담금을 확인하세요. 계산서발행의뢰를 할 수 없습니다..!!");
				return;
			 }	
		}	
		
		
		if ( toInt(parseDigit(fm.over_amt_1.value))  > 1 ) {
			if ( fm.tax_chk4.checked == true) {
			} else {
				alert("초과운행부담금을 확인하세요. 계산서발행 필수입니다..!!");
				return;
			 }	
		}	
		*/
		
		
		if ( fm.des_zip.value == '' || fm.des_addr.value == '' || fm.des_nm.value == ''   ) { 
			alert("서류배송주소, 수취인을 확인하십시오");
			return;
		}		
		
	
	  	if(fm.cls_st.value == '8'){ //매입옵션 선택시 디스플레이	
	  	
	  	      var count =0;
	 			var s_str = fm.rent_end_dt.value;
				var e_str = fm.cls_dt.value;
				
				var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
				var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
				
				var diff_date = s_date.getTime() - e_date.getTime();
				
				count = Math.floor(diff_date/(24*60*60*1000));
					
			 if  ( toInt(fm.fee_size.value) < 2 ) { //연장이 아니면 						
		    	   if (  toInt(fm.vt_size8.value)  >  1 ) {		 // 스케쥴이 있고 연장이 아닌  경우  
		    			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //만기전 해지 
		    			 if ( count > 61) {
			    		  	if (  toInt(parseDigit(fm.t_cal_days.value)) <  1 ) { 
						    		alert("금액확정을 클릭하세요.!!");
									return;
						   	}
						 }  	
					  }
				   }	    	
			} else {	  //연장인 경우 				    	
		      
				
		   	       if (  toInt(fm.vt_size8.value)  >  1 ) {		 // 스케쥴이 있고 연장인 경우  
			 				    		
			    			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //만기전 해지  - 30 일 이상이면 
			        
				    			if ( count > 30 ) { 				
					    		  	if (  toInt(parseDigit(fm.t_cal_days.value)) <  1 ) { 
								    		alert("금액확정을 클릭하세요.!!");
											return;
								   	}
								}   	
						  }					    	
			  
			    }
		  	
		  	}		    
					
			// 중도매입옵션 결재
		 	if (  toInt(parseDigit(fm.old_opt_amt.value)) >   0  ) { 
		
			    if ( fm.add_saction_id.value == '' ) {
							alert("중도매입옵션 경우 매입옵션담당자 결재필수입니다. 담당자를 지정하셔야 합니다..!!");
							return;
				 }	
									
				 if ( toInt(parseDigit(fm.mopt_amt.value))  !=	 toInt(parseDigit(fm.old_opt_amt.value))   ) { 	
				 		alert('중도매입옵션 정산금액차이가 발생했습니다. 처음부터 다시 시작해주십시요'); 	fm.cls_dt.focus(); 
				 		fm.opt_amt.value=fm.mopt_amt.value;
				 		fm.cls_st.value="";			 	
				 		return;		 
				 }	
			
				 
				if (  toInt(fm.r_mon.value)  <  12 ) {		
					  		alert("중도매입옵션 최소이용기간이 1년이상입니다..!! 기존방식으로 진행하세요.!!");
							return;					
				}				
			   
		   } 	
	   					
		}			
		
			// 중도매입옵션 결재
		if(confirm('등록하시겠습니까?')){	
					fm.action='lc_cls_off_c_a.jsp';	
		//			fm.target='ii_no';
					fm.target='d_content';
					fm.submit();
		}		
						
		
	}
	
	//디스플레이 타입
	function cls_display(){
		var fm = document.form1;
				
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );				
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
									
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //매입옵션 선택시 디스플레이
		
			//해지일이 계약만료일 2개월전 경우 매입옵션 행사 불가
			if ( count > 61 ) {  
		//	  	alert("해지일이 계약만료일 2개월 이전인 경우 매입옵션을 행사할수 없습니다..!!!");			  	
			  	set_day();  
			  	return;				
			}
			
			if(fm.opt_chk.value != '1' ){ //매입옵션 선택시 디스플레이		
			  	alert("계약당시 매입옵션 내용이 없습니다. 이같은 경우 매입옵션을 행사할수 없습니다..!!!");
			  	set_day();  
			  	return;				
			}			
			
			
		}
														
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //매입옵션 선택시 디스플레이
			tr_opt.style.display 		= '';  //매입옵션	
			tr_ret.style.display		= 'none';	//차량회수		
			tr_gur.style.display		= 'none';	//채권관계	
			tr_cre.style.display		= 'none';	//잔존채권처리
			tr_sale.style.display		= '';	//차량매각
			
		}else{
			tr_opt.style.display 		= 'none';	//매입옵션
			tr_ret.style.display		= '';	//차량회수	
			tr_gur.style.display		= '';	//채권관계
			tr_cre.style.display		= '';	//잔존채권처리
			tr_sale.style.display		= 'none';	//차량매각		
			tr_cal_sale.style.display		= 'none';	//중도정산서 	
			
		}
	
		
		set_init();
		
		
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
		fm.mt.value='0';
	   	fm.fdft_amt3.value='0';  //차량매각
	   	fm.t_cal_days.value = '0';		
	   		
	   	fm.sui_st[0].checked = false; 	
	   		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){
			fm.opt_per.value=fm.mopt_per.value;
			fm.opt_amt.value=fm.mopt_amt.value;
								
			//만기일보다 해지일자가 적은 경우 만기일로 다시 재계산
			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 			
				set_day_sui(fm.rent_end_dt.value);											
			}
			
			set_sui_c_amt();
		}	

		set_day();

	}	

	//디스플레이 타입 - 차량회수여부
	function cls_display2(){
		var fm = document.form1;
			
		if(fm.reco_st[1].checked == true){  //미회수 선택시
			td_ret1.style.display 	= 'none';
			td_ret2.style.display 	= '';
		}else{
			td_ret1.style.display 	= '';
			td_ret2.style.display 	= 'none';
		}
	}	
	
	//디스플레이 타입
	function cls_display3(){
		var fm = document.form1;
	
		if(fm.div_st.options[fm.div_st.selectedIndex].value == '2'){
			td_div.style.display 	= '';
		}else{
			td_div.style.display 	= 'none';
		}
	}	
	
	//디스플레이 타입
	function cancel_display(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
		    fm.cancel_yn.value = 'Y';
			alert('중도해지정산금액이 '+fm.fdft_amt2.value+'원으로 환불해야 합니다. \n\n이와 같은 경우에는 매출취소만 가능합니다.');
			return;			
		}
		
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'Y'){
			td_cancel_n.style.display 		= 'none';  //매출유지
			td_cancel_y.style.display 		= '';  //매출취소
		} else {
			td_cancel_n.style.display 		= '';  //매출유지
			td_cancel_y.style.display 		= 'none';  //매출취소
		}	
	}	
	
	//변경된 해지일자로 다시 계산
	function set_day(){
		var fm = document.form1;	
			
		if(fm.cls_dt.value == ''){ 	alert('해지일자를 입력하십시오'); 	fm.cls_dt.focus(); 	return;	}
	
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}	
		
		fm.cls_msg.value = "계산중입니다. 잠시 기다려주십시요.!!!";		
				
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
						
		if(fm.cls_st.value == '8'){ //매입옵션 선택시 디스플레이
			
			fm.div_st.value="1";
			fm.est_dt.value= fm.cls_dt.value;
			
			if(fm.opt_chk.value != '1' ){ //매입옵션 선택시 디스플레이		
				tr_opt.style.display 		= 'none';	//매입옵션
			  	alert("계약당시 매입옵션 내용이 없습니다. 이같은 경우 매입옵션을 행사할수 없습니다..!!!");
			  	fm.action='./lc_cls_c_nodisplay.jsp';
				fm.cls_st.value="";				
			} else {
			 	if  ( toInt(fm.fee_size.value) < 2 ) {				 //
			  				
					//해지일이 계약만료일 2개월전 경우 매입옵션 행사 불가
					if ( count > 61 ) { 
				//		alert("해지일이 계약만료일 2개월 이전인 경우 매입옵션을 행사할수 없습니다.!!!!"); 	
						tr_opt.style.display 		= '';	//매입옵션
						tr_cal_sale.style.display		= '';	//중도정산서 
				//		fm.action='./lc_cls_c_nodisplay.jsp'; 
						fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';										  			
					} else {					
						tr_cal_sale.style.display		= 'none';	//중도정산서
						if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 	
						
							fm.dly_c_dt.value=fm.cls_dt.value	;
							 
					  		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.dly_c_dt.value+'&cls_gubun=Y&cls_dt='+fm.rent_end_dt.value;
					    } else { 
					   		fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';
					    }
					}	
				} else {  //연장이면 
				//해지일이 계약만료일 1개월전 경우 매입옵션 행사 불가
					if ( count > 30 ) { 			
						tr_opt.style.display 		= '';	//매입옵션
						tr_cal_sale.style.display		= '';	//중도정산서 
				//		fm.action='./lc_cls_c_nodisplay.jsp'; 
						fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';										  			
					} else {					
						tr_cal_sale.style.display		= 'none';	//중도정산서
						if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 	
						
							fm.dly_c_dt.value=fm.cls_dt.value	;
							 
					  		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.dly_c_dt.value+'&cls_gubun=Y&cls_dt='+fm.rent_end_dt.value;
					    } else { 
					   		fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';
					    }
					}			
				
				}							
				
			}
			
		}else {
		   	fm.action='./lc_cls_c_nodisplay.jsp';		
		}
								
				
		fm.target='i_no';
		fm.submit();
	}	
	
		//변경된 해지일자로 다시 계산
	function set_day_sui(cls_dt){
		var fm = document.form1;	
					
		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.cls_dt.value+'&cls_gubun=Y&cls_dt='+cls_dt;		
		fm.target='i_no';
		fm.submit();
	}			
	
	//선납금액 정산 : 자동계산
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		
		if(obj == fm.r_day){ //이용기간 일 	
			set_init();
		}
		
		if(obj == fm.ifee_mon || obj == fm.ifee_day){ //개시대여료 경과기간
			if(fm.ifee_s_amt.value != '0'){		
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );		
		
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //경과금액
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //잔액
							
			}
			
		}else if(obj == fm.ifee_ex_amt){ //개시대여료 경과금액
			if(fm.ifee_s_amt.value != '0'){		
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );				
			}
		}else if(obj == fm.pded_s_amt){ //선납금 월공제액
			if(fm.pp_s_amt.value != '0'){		
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //선납금 월공제액
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		
		if(fm.pp_s_amt.value != '0') {	 	 
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기일
	    		
	    		fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;
	    	}   
	    }	
			
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // 선납금액이 경과한 경우
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
				
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		
		 //개시대여료가 다 경과한 경우 잔여개시대여료는 미납대여료에서 처리
	    if(fm.ifee_s_amt.value != '0') {
	    	 
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 
	    		
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
	    	} 
	        	
	         set_init();	  
	    }	
		     			
		set_cls_s_amt();
	}	
	
	//미납 대여료 정산 : 자동계산
	function set_cls_amt2(obj){
		var fm = document.form1;
		
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // 개시대여료 잔액
		var v_ifee_ex_amt = 0;  //개시대여료 경과금액
		var  re_nfee_amt = 0;  //마지막차 스케쥴에서 일수 계산한 금액이 아닌 경우 check
								
		obj.value=parseDecimal(obj.value);
						
		//과부족 및 과입금관련 vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} 
		
		if ( fm.ex_di_amt_1.value == fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = fm.ex_di_v_amt.value ;
		}
		
		var no_v_amt = 0;
		
		var c_fee_v_amt =  0;
	
	   c_fee_v_amt = (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) ;
		
			//매입옵션인 경우는 틀림.
		if ( fm.cls_st.value == '8') { //매입옵션 		
			   	     //위약금 0
			   fm.dft_amt.value 			= '0';
			   fm.dft_amt_1.value 	   = '0';			 
	   }
		 
		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
				
		//각각 부가세 계산하여 더한다.	 	
//	 no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		var no_v_amt2 	 = no_v_amt;
	//	no_v_amt2	=  Math.round(no_v_amt * 0.1);

		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt2) );		
		
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
			
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
			
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}	
									
		if ( fm.tax_chk3.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));			
		}		
		
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}			
		
		fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
	
		set_cls_s_amt();
	}	
			
	//미납 중도해지위약금 정산 : 자동계산
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //잔여대여계약기간
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
				fm.tax_supply[0].value 	= fm.dft_amt_1.value;
				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}
		}else if(obj == fm.dft_int_1){ //위약금 적용요율
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
				fm.tax_supply[0].value 	= fm.dft_amt_1.value;
				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}			
		}
		
		fm.d_amt.value 						= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		fm.d_amt_1.value 					= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));	
		set_cls_s_amt();
	}		
	
	//이전등록비용(매입옵션)
	function set_sui_c_amt(){
		
		var fm = document.form1;
								
		if (fm.cls_st.value  == '8' ) {
		  fm.dft_amt.value = '0'; //중도해지위약금
		  fm.dft_amt_1.value = '0'; //중도해지위약금확정
		  		  
		  fm.tax_supply[0].value 	= '0';
		  fm.tax_value[0].value 	= '0';	
		 						
		  if(fm.sui_st[0].checked == true){ 		//등록비용 포함	
		  		fm.sui_d1_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.05 );  //등록세
				fm.sui_d2_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.06 * 0.20 );  //채권할인 (default:25%) -> 20% 변경 20120920
				fm.sui_d3_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.02 );  //취득세 
				fm.sui_d4_amt.value		= '3,000';  //인지대 
				fm.sui_d5_amt.value		= '1,000';  //증지대 
				fm.sui_d6_amt.value		= '11,000';  //번호판대
				fm.sui_d7_amt.value		= '10,000';  //보조번호판대
				fm.sui_d8_amt.value		= '50,000';  //등록대행료
								
				fm.sui_d_amt.value 		= parseDecimal( hun_th_rnd(toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value))));
		  } else {
				fm.sui_d1_amt.value		= '0';
				fm.sui_d2_amt.value		= '0';
				fm.sui_d3_amt.value		= '0';
				fm.sui_d4_amt.value		= '0';
				fm.sui_d5_amt.value		= '0';
				fm.sui_d6_amt.value		= '0';
				fm.sui_d7_amt.value		= '0';
				fm.sui_d8_amt.value		= '0';
				 				
				fm.sui_d_amt.value		= '0';
		  }
		} else { 		
			fm.sui_d1_amt.value		= '0';
			fm.sui_d2_amt.value		= '0';
			fm.sui_d3_amt.value		= '0';
			
			fm.sui_d_amt.value		= '0';
		}	
		
		fm.div_st.value="1";
		fm.est_dt.value= fm.cls_dt.value;
		set_cls_s_amt();
	
	}	
	
	//이전등록비용(매입옵션)
	function set_sui_amt(){
	
		var fm = document.form1;
		
		fm.sui_d_amt.value 		= parseDecimal( hun_th_rnd(toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value))));
				
	//	fm.sui_d_amt.value 		= parseDecimal( toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value)));
		
		fm.div_st.value="1";
		fm.est_dt.value= fm.cls_dt.value;
		
		set_cls_s_amt();	
	}	
						
	//확정금액 셋팅
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		
		if(obj == fm.dft_amt_1){ //중도해지
			fm.tax_supply[0].value 	= obj.value;
			if (fm.tax_chk0.checked == true) {
	 				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );		 		
			} else {
					fm.tax_value[0].value 	= '0';				
			}				
		
		}else if(obj == fm.etc_amt_1){ //회수외주비용
			fm.tax_supply[1].value 	= obj.value;
			if (fm.tax_chk1.checked == true) {
				 fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 fm.tax_value[1].value 	= '0';
			}		
		
		}else if(obj == fm.etc2_amt_1){ //회수부대비용
			fm.tax_supply[2].value 	= obj.value;
			if (fm.tax_chk2.checked == true) {
					fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[2].value 	= '0';
			}		
		
		}else if(obj == fm.etc4_amt_1){ //기타손해배상금
			fm.tax_supply[3].value 	= obj.value;			
			if (fm.tax_chk3.checked == true) {
				 	fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[3].value 	= '0';
			}
			
	//	}else if(obj == fm.over_amt_1){ //초과운행부담금 감액		 
		}else if(obj == fm.m_over_amt){ //초과운행부담금 감액		 
					
    		fm.j_over_amt.value =  toInt(parseDigit(fm.r_over_amt.value)) - toInt(parseDigit(obj.value)) ;  
    		
    		if (  toInt(parseDigit(fm.j_over_amt.value)) > 0) {
    			    				
				fm.over_amt.value =  fm.j_over_amt.value;  
				fm.over_amt_1.value =  fm.j_over_amt.value ;  					
				fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
				fm.tax_chk4.value  = 'Y' ;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );
			} else  { 						
					fm.over_amt.value =  '0';  
					fm.over_amt_1.value =  '0' ;  	
				 	fm.tax_supply[4].value 	= '0';
				 	fm.tax_chk4.value  = 'N' ;
				   fm.tax_value[4].value 	= '0';				
			}		
						
		}	
											
		var no_v_amt = 0;
			//각각 부가세 계산하여 더한다.	 
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		var no_v_amt2 	 = no_v_amt;
					
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt2) );		
					
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 	= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));					
		}		
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}									
		if ( fm.tax_chk3.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));			  
		}		
		
		/*
		if ( fm.tax_chk4.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));			  
		}		
		*/		
				
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.over_amt.value)) +  toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value)) +  toInt(parseDigit(fm.no_v_amt_1.value)));	 //확정금액	
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		
		if (fm.cls_st.value  == '8' ) {	
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));							
		}  
		
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
					
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	

	}	
		
	//확정금액 셋팅
	function set_cls_s_amt(){
		var fm = document.form1;	
					
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.over_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)));	 //확정금액	
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	 	 	
		if (fm.cls_st.value  == '8' ) {	//매입옵션
		   	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );					
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );						
	
		} 
			
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );			

	}	
	
		
	//보증보험청구잔액
	function set_gi_amt(){
		var fm = document.form1;
		
		if ( toInt(parseDigit(fm.gi_amt.value))  > 0  ) {
			if ( toInt(parseDigit(fm.fdft_amt2.value))  > 0  ) {
				fm.gi_j_amt.value 		= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.gi_amt.value)));
			}
		}
		if ( toInt(parseDigit(fm.gi_j_amt.value)) < 0  ) {
				fm.gi_j_amt.value  = "0";
		}
		
		//보증보험 청구시 보증보험 금액만큼 자구책에서 차감함.
		fm.est_amt.value  = fm.gi_j_amt.value;  
				
	}	
	
	//차량회수비용
	function set_etc_amt(){
		var fm = document.form1;
		
		fm.etc_out_amt.value 		= parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)) + toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		fm.etc_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
	
		fm.etc_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
		
					//차량외주비용
		if(toInt(parseDigit(fm.etc_amt.value)) > 0){		
				fm.tax_g[1].value       = "회수 차량외주비용";
		   		fm.tax_supply[1].value 	= fm.etc_amt.value;
		   		
		   		if (fm.tax_chk1.checked == true) {
		   				fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt.value)) * 0.1 );
		   		} else {
		   				fm.tax_value[1].value 	= '0';
		   		}			
		}
					//차량부대비용
		if(toInt(parseDigit(fm.etc2_amt.value)) > 0){
				fm.tax_g[2].value       = "회수 부대비용";
		   		fm.tax_supply[2].value 	= fm.etc2_amt.value;
		   		
		   		if (fm.tax_chk2.checked == true) {
					fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt.value)) * 0.1 );
				} else {
				 	fm.tax_value[2].value 	= '0';
				}	
		}
			
		//합계, 고객납입액		
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)));	 //확정금액	
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		 				
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
		} 
				
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
					
	}	
	
	//세금계산서 check 관련 부가세 - 고객납입액에 부가세 만큼 더한다(대여료, 면책금은 예외 (이미 더해졌음)) - 세금계산서 발행되면 외상매출금계정 
	function set_vat_amt(obj){
		var fm = document.form1;
			
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
			
		if(obj == fm.tax_chk0){ // 위약금
		 	if (obj.checked == true) {
		 			fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
		 			fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		 			fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[0].value)));		
			//	  	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt3.value))+ toInt(parseDigit(fm.tax_value[0].value)));				
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[0].value)));		
			} else {
					fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
					fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[0].value)));			
			//		fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt3.value))- toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[0].value)));		
			}	
	
		} else if(obj == fm.tax_chk1){ // 외주비용
			 if (obj.checked == true) {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[1].value)));			
				// 	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt3.value))+ toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[1].value)));
			 } else {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[1].value)));			
			 //		fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt3.value))- toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[1].value)));
			 }	
			 
		} else if(obj == fm.tax_chk2){ // 부대비용
			 if (obj.checked == true) {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[2].value)));
			//	 	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt3.value))+ toInt(parseDigit(fm.tax_value[2].value)));					
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[2].value)));
			 } else {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[2].value)));			
			// 		fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt3.value))- toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[2].value)));
			 }	
			 
		} else if(obj == fm.tax_chk3){ // 기타손해배상금
			 if (obj.checked == true) {
			 	  	fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );			 
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[3].value)));			
			//	 	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt3.value))+ toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[3].value)));
			 } else {
				 	fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );			 
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[3].value)));			
			// 		fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt3.value))- toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[3].value)));
			 }	
		/*	 
		} else if(obj == fm.tax_chk4){ // 초과운행 부담금 
			 if (obj.checked == true) {
				   fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[4].value)));		
			//	 	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt3.value))+ toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));
			 } else {
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );			 	
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[4].value)));			
		//	 		fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[4].value)));
			 }		*/
			  
		}
		
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
		} 
		
		if (fm.cls_st.value  == '8' ) {	//매입옵션		
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
			
	}
	
	//특이사항  보기
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
		//초과운행주행거리
	function set_over_amt(){
		var fm = document.form1;
		
		var cal_dist  = 0;
		
		if ( fm.cls_st.value == '8' ) {  
				fm.t_s_cal_amt.value ='0';
				fm.t_r_fee_s_amt.value = '0';
				fm.t_r_fee_v_amt.value = '0';
				fm.t_r_fee_amt.value = '0';	
				fm.t_cal_days.value = '0';		
					
		}
	
	//초기화 
		fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
		fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
		fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     )
		fm.add_dist.value 		=     parseDecimal( 1000  );  //써비스마일리지
		fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
		
				
		//매입옵션인 경우 - 50% 납부인 경우만 해당 
		if ( fm.cls_st.value == '8'   &&  (  fm.agree_yn.value == '2'  ||  fm.agree_yn.value == '3' )  ) { 
		 
			if ( (  <%=base.getRent_dt()%>  > 20130604  &&    <%=car1.getAgree_dist()%>  > 0   &&  <%=base.getCar_gu()%>  ==  '1' ) ||    (  <%=base.getRent_dt()%>  > 20140705  &&  <%=base.getCar_gu()%>  ==  '0' )   ) {  
								
				   // fm.taecha_st_dt 값이 있다면 만기매칭
				if ( fm.taecha_st_dt.value  != "" )  {			
					var s1_str = fm.taecha_st_dt.value; 
					var e1_str = fm.cls_dt.value;
					var  count1 = 0;
				
					var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );								
					var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1,  e1_str.substring(8,10) );	
																	
			//		var days = (e1_date - s1_date) / 1000 / 60 / 60 / 24; 		//1일=24시간*60분*60초*1000milliseconds
			//		var mons = (e1_date - s1_date) / 1000 / 60 / 60 / 24 / 30; 	//1달=24시간*60분*60초*1000milliseconds
			//	         	cal_dist  =      (    mons * toInt(fm.o_p_m.value)  ) + ( days * toInt(fm.o_p_d.value)  );/
			
				   var diff1_date = e1_date.getTime() - s1_date.getTime();
				 	count1 = Math.floor(diff1_date/(24*60*60*1000));
					cal_dist =   	toInt(fm.agree_dist.value) * count1/ 365;
				} else {	
				 
				//	cal_dist =   	toInt(parseDigit(fm.agree_dist.value))  * toInt(parseDigit(fm.rent_days.value))   / 365;
					cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
			//		cal_dist  =      (    toInt(fm.r_mon.value) * toInt(fm.o_p_m.value)  ) + (  toInt(fm.r_day.value) * toInt(fm.o_p_d.value)  );				
				}         	
						
				
				fm.cal_dist.value 		=     parseDecimal( cal_dist   );	
			
			//	fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
					
				fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
				fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
				fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );
						  				
				fm.add_dist.value 		=     parseDecimal( 1000  );  //써비스마일리지
				
				fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
						
				if ( 	toInt(parseDigit(fm.jung_dist.value))   > 0   &&  fm.agree_yn.value == '2'   ) {
				
					fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );	
					fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.5 );	
					fm.j_over_amt.value 	=      parseDecimal(  toInt(parseDigit(fm.r_over_amt.value)) -   toInt(parseDigit(fm.m_over_amt.value))     );	 //감액
					
					fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
					fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );											
					fm.tax_chk4.value  = 'Y' ;						
						
					fm.m_reason.value            =   "매입옵션 50% 감면";
					
				} else {
					fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );	
					fm.over_amt.value 		=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );						
					fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );		
				
					fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
					fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );											
					fm.tax_chk4.value  = 'Y' ;	
						
			 	}
			 	
			 	if ( 	toInt(parseDigit(fm.jung_dist.value))   < 0 ) {
			 		fm.r_over_amt.value 	=      "0";
					fm.over_amt.value 		=    "0";
					fm.j_over_amt.value 	=     "0";	
					fm.tax_supply[4].value 	=  "0";		
					fm.tax_value[4].value 	= '0';											
					fm.tax_chk4.value  = 'N' ;					 
			 	
			   }      			
			         		
			}
		
		}
						
		fm.over_amt.value 		    = parseDecimal( toInt(parseDigit(fm.j_over_amt.value)));
		fm.over_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.j_over_amt.value)));			
		
		var no_v_amt = 0;
		
		var c_fee_v_amt =  0;
	
	   c_fee_v_amt = (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) ;
		
			//매입옵션인 경우는 틀림.
		if ( fm.cls_st.value == '8') { //매입옵션 
		
			    //위약금 0
			  fm.dft_amt.value 			= '0';
			  fm.dft_amt_1.value 	   = '0';
			  		  
	   }
		 
		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt  + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
				
		//각각 부가세 계산하여 더한다.	
	//	no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)    -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		var no_v_amt2 	 = no_v_amt;
	
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt2) );		
		
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
			
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
			
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}	
									
		if ( fm.tax_chk3.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));					 
		}		
		
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
		*/
			
		set_cls_s_amt();
				
	}	
	
	
	//중도정산시 금액셋팅 - 연장이 아닌 경우 매입옵션 금액에 대여료 포함하여 계산할것 . (미납대여료(과부족)는 (현재가치가 1인경우는 대여료로) )
	function cal_rc_rest(){
		var fm = document.form1;
				
		 fm.dft_amt.value = '0'; //중도해지위약금
		 fm.dft_amt_1.value = '0'; //중도해지위약금확정
		 fm.mt.value ='0' ;  
		 	
		var scd_size 	= toInt(fm.vt_size8.value);	
	   var a_f = fm.a_f.value;
	       
		var e_str = fm.cls_dt.value;
		var s_str ;
		var diff_date ;
		var count=0;
				
		var s_date = "";
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var s_rc_rate;	
		var t_cal_days = 0;				
							
		for(var i = 0 ; i < scd_size ; i ++){

			s_str = fm.s_r_fee_est_dt[i].value; // 납입할날짜 
			s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7) -1 , s_str.substring(8,10) ); 
									
			diff_date = s_date.getTime() - e_date.getTime();
		   count = Math.floor(diff_date/(24*60*60*1000));					
			
			fm.s_cal_days[i].value = parseDecimal(count);			//기준일대비 경과일수
			
			if  ( toInt(fm.fee_size.value) < 2 ) 	{		//연장건이 아니면 
			
				   fm.mt.value ='1' ;  
					   					
					//선납금  이자효과 계산 - 경과일수가 30일보다 적은 경우는 금액 /30 * 경과일수로 계산 ( 0보다 적은 경우는 0으로 )								
		         var cc_grt_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_grt_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_grt_amt.value)) );
		         cc_grt_amt = ( cc_grt_amt < 0 ? 0 : cc_grt_amt );
		            
		          //마지막회차인경우는 별도로 세금*대여료/계약대여료 
		         if ( i == scd_size - 1 ) 	cc_grt_amt =   toInt(parseDigit(fm.e_grt_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ;
		                  
		          fm.s_grt_amt[i].value = parseDecimal(cc_grt_amt) ;          
		                     
					//자동차세, 보험료, 정비비용 구하기 - 경과일수가 30일보다 적은 경우는 금액 /30 * 경과일수로 계산 ( 0보다 적은 경우는 0으로 )								
		         var cc_tax_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_tax_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_tax_amt.value)) );
		         cc_tax_amt = ( cc_tax_amt < 0 ? 0 : cc_tax_amt );
		         
		         	//마지막회차인경우는 별도로 세금*대여료/계약대여료 
		         if ( i == scd_size - 1 ) 	cc_tax_amt =   toInt(parseDigit(fm.e_tax_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ;
		                  
		         fm.s_tax_amt[i].value = parseDecimal(cc_tax_amt) ;  
		              
		         var cc_insur_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_insur_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_insur_amt.value)) );
		         cc_insur_amt = ( cc_insur_amt < 0 ? 0 : cc_insur_amt );         
		         	//마지막회차인경우는 별도로 보혐료*대여료/계약대여료 
		          if ( i == scd_size - 1 ) 	 cc_insur_amt =  toInt(parseDigit(fm.e_insur_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ; 	
		         	
		         var cc_serv_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_serv_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_serv_amt.value)) );
		         cc_serv_amt = ( cc_serv_amt < 0 ? 0 : cc_serv_amt );           
		         	//마지막회차인경우는 별도로 정비*대여료/계약대여료 
		         	  if ( i == scd_size - 1 ) 	cc_serv_amt =  toInt(parseDigit(fm.e_serv_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ;
		         	    
		         var cc_is_amt ;
		                  
		         //일반식인경우 정비비용 추가
		   <%     if ( fee.getRent_way().equals("1") )  { %>
		         		 cc_is_amt  = cc_insur_amt + cc_serv_amt;
		     <%    } else {  %>
		         		  cc_is_amt  = cc_insur_amt ;
		    <%     }  %>
		    		    
		         fm.s_is_amt[i].value = parseDecimal(cc_is_amt) ;		          
		          
		         //선납금 이자효과 반영         
				   fm.s_g_fee_amt[i].value =    parseDecimal( toInt(parseDigit(fm.s_fee_s_amt[i].value))   +   toInt(parseDigit(fm.s_grt_amt[i].value))  ) ;
		
		         fm.s_cal_amt[i].value =    parseDecimal( toInt(parseDigit(fm.s_g_fee_amt[i].value))   -   toInt(parseDigit(fm.s_tax_amt[i].value))  -   toInt(parseDigit(fm.s_is_amt[i].value)) ) ;
			     
			      s_rc_rate =  (1/ Math.pow(  1+a_f/100/12, count/365*12) ).toFixed(4);
			         	  	
		     	  	fm.s_rc_rate[i].value = s_rc_rate;
		        	  	        		
		      		fm.s_r_fee_s_amt[i].value = parseDecimal(toInt(parseDigit(fm.s_cal_amt[i].value)) *s_rc_rate) ;
		      		fm.s_r_fee_v_amt[i].value =  parseDecimal(toInt(parseDigit(fm.s_r_fee_s_amt[i].value))    * 0.1 )  ;
		      		
		      		fm.s_r_fee_amt[i].value =  parseDecimal(  toInt(parseDigit(fm.s_r_fee_s_amt[i].value) ) +   toInt(parseDigit(fm.s_r_fee_v_amt[i].value)) ) ;      	   
		      		  		  
      		} else {
					s_rc_rate = 1;  //현재가치 는 1 ( 연장인 경우)
				}		     	
      			
		}		
		
		   //매입옵션 현재가치 
		 fm.cls_cau.value = "중도매입옵션,  계약시  매입옵션비용:" +  parseDecimal( toInt(parseDigit(fm.opt_amt.value)) ) ;
		 fm.old_opt_amt.value =  toInt(parseDigit(fm.opt_amt.value)) ;    	
		 
		  //연장인경우는 연장전매입옵션금액을 반영하여 다시 계산해야 함. - 20161117
		 var recal_opt_amt;
		 	 		 
		 var e1_end_str  = fm.fee_size_1_end_dt.value;
		 var e_end_str  = 	 fm.s_opt_end_dt.value;
		 
		 var e1_end_date = "";
		var e_end_date = "";
		
		var diff1_date ;
		var diff2_date ;
		var count1=0;
		var count2=0;
				
		var s_rc_rate;	
		
		e1_end_date =  new Date (e1_end_str.substring(0,4), e1_end_str.substring(4,6) -1 , e1_end_str.substring(6,8) );  //연장 -1 만료일 
		e_end_date =  new Date (e_end_str.substring(0,4), e_end_str.substring(4,6) -1 , e_end_str.substring(6,8) );   //연장만료일 
		
		
		diff1_date = e_date.getTime() - e1_end_date.getTime();
		count1 = Math.floor(diff1_date/(24*60*60*1000));					
		
		diff2_date = e_end_date.getTime() - e1_end_date.getTime();
	   count2 = Math.floor(diff2_date/(24*60*60*1000));			
		 
		if  ( toInt(fm.fee_size.value) < 2 ) { //연장이 아니면 
		} else {		
			recal_opt_amt =   toInt(parseDigit(fm.fee_size_1_opt_amt.value))  - ( ( toInt(parseDigit(fm.fee_size_1_opt_amt.value))  -  toInt(parseDigit(fm.opt_amt.value)) ) *  count1 / count2   ) ; 
		//  alert(recal_opt_amt);
			 fm.opt_amt.value = parseDecimal(recal_opt_amt);	
		}
				
		 fm.opt_amt.value =  parseDecimal( toInt(parseDigit(fm.opt_amt.value)) * s_rc_rate) ;    
		
		   //매입옵션 현재가치 
	    if  ( toInt(fm.fee_size.value) < 2 ) { //연장이 아니면 
	    	 fm.cls_cau.value = "중도매입옵션,  계약시  매입옵션비용:" +  parseDecimal( toInt(parseDigit(fm.old_opt_amt.value)) ) + " , 매입옵션추정치: " +  parseDecimal( toInt(parseDigit(fm.opt_amt.value)) )  ;
	    }
		   
		  if ( toInt(parseDigit(fm.mopt_amt.value))  !=	 toInt(parseDigit(fm.old_opt_amt.value))   ) { 	
		 		alert('중도매입옵션 정산금액차이가 발생했습니다. 처음부터 다시 시작해주십시요'); 	fm.cls_dt.focus(); 
		 		fm.cls_st.value = "";
		 		fm.opt_amt.value=fm.mopt_amt.value;		 
		 		fm.t_s_cal_amt.value ='0';
		 		fm.t_s_grt_amt.value ='0';
		 		fm.t_s_g_fee_amt.value ='0';
				fm.t_r_fee_s_amt.value = '0';
				fm.t_r_fee_v_amt.value = '0';
				fm.t_r_fee_amt.value = '0';	
				fm.t_cal_days.value = '0';			
		 		return;			 
		 }
		 		
		for(var i = 0 ; i < scd_size ; i ++){
			t_cal_days 	= t_cal_days + toInt(parseDigit(fm.s_cal_days[i].value));							
		}
		fm.t_cal_days.value = parseDecimal(t_cal_days);  //총경과일수계산 
		 	 			 	
		//합계란 표시 
		if  ( toInt(fm.fee_size.value) < 2 ) {					
			 cal_tot_set();
		} 			
		
		 set_cls_s_amt()	; //금액재계산 	
	}
	
	
	//중도정산시 금액셋팅 
	function cal_rc_rest_clear(){
		var fm = document.form1;
		
		 fm.dft_amt.value = '0'; //중도해지위약금
		 fm.dft_amt_1.value = '0'; //중도해지위약금확정
		 fm.mt.value= '0'; // 매입옵션 타입
			 	
		var scd_size 	= toInt(fm.vt_size8.value);	
	   var a_f = fm.a_f.value;
	       
		var e_str = fm.cls_dt.value;
		var s_str ;
		var diff_date ;
		var count=0;
				
		var s_date = "";
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var s_rc_rate;	
						
		for(var i = 0 ; i < scd_size ; i ++){

			s_str = fm.s_r_fee_est_dt[i].value; // 납입할날짜 
			s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7) -1 , s_str.substring(8,10) ); 
									
			diff_date = s_date.getTime() - e_date.getTime();
		   count = Math.floor(diff_date/(24*60*60*1000));					
			
			fm.s_cal_days[i].value = '0';			//기준일대비 경과일수
			
		   fm.s_grt_amt[i].value ='0';  
		   fm.s_g_fee_amt[i].value ='0';  
		   fm.s_tax_amt[i].value ='0';  
		   fm.s_cal_amt[i].value ='0';  
		   fm.s_r_fee_s_amt[i].value ='0';  
		   fm.s_r_fee_v_amt[i].value ='0';  
		   fm.s_r_fee_amt[i].value ='0';  
       }
       
      	fm.t_s_grt_amt.value = '0';
      	fm.t_s_g_fee_amt.value = '0';
      	fm.t_s_cal_amt.value = '0';
		fm.t_r_fee_s_amt.value = '0';
		fm.t_r_fee_v_amt.value = '0';
		fm.t_r_fee_amt.value = '0'; 
   }      	
	
	function cal_tot_set(){
		var fm = document.form1;
	
		var t_s_grt_amt = 0;
		var t_s_g_fee_amt = 0;
		var t_s_cal_amt = 0;
		var t_r_fee_s_amt = 0;
		var t_r_fee_v_amt = 0;
		var t_r_fee_amt = 0;
			
		var m_r_fee_s_amt = 0;
		var m_r_fee_v_amt = 0;
		var m_r_fee_amt = 0;
		
		var recal_opt_amt;
		
	
		var scd_size 	= toInt(fm.vt_size8.value);	
				
		for(var i = 0 ; i < scd_size ; i ++){
			
			t_s_grt_amt 	= t_s_grt_amt + toInt(parseDigit(fm.s_grt_amt[i].value));	
			t_s_g_fee_amt 	= t_s_g_fee_amt + toInt(parseDigit(fm.s_g_fee_amt[i].value));	
			t_s_cal_amt 	= t_s_cal_amt + toInt(parseDigit(fm.s_cal_amt[i].value));		
			t_r_fee_s_amt = t_r_fee_s_amt + toInt(parseDigit(fm.s_r_fee_s_amt[i].value));			
			t_r_fee_v_amt = t_r_fee_v_amt + toInt(parseDigit(fm.s_r_fee_v_amt[i].value));			
			t_r_fee_amt 	= t_r_fee_amt + toInt(parseDigit(fm.s_r_fee_amt[i].value));							
				
		}

		fm.t_s_grt_amt.value = parseDecimal(t_s_grt_amt);
		fm.t_s_g_fee_amt.value = parseDecimal(t_s_g_fee_amt);
		fm.t_s_cal_amt.value = parseDecimal(t_s_cal_amt);
		fm.t_r_fee_s_amt.value = parseDecimal(t_r_fee_s_amt);
		fm.t_r_fee_v_amt.value = parseDecimal(t_r_fee_v_amt);
		fm.t_r_fee_amt.value = parseDecimal(t_r_fee_amt);
		
	   for(var i = 0 ; i < scd_size ; i ++){
		
		   if ( toInt(parseDigit(fm.s_rc_rate[i].value)) < 1 ) {
				m_r_fee_s_amt = m_r_fee_s_amt + toInt(parseDigit(fm.s_r_fee_s_amt[i].value));			
				m_r_fee_v_amt = m_r_fee_v_amt + toInt(parseDigit(fm.s_r_fee_v_amt[i].value));			
				m_r_fee_amt 	= m_r_fee_amt + toInt(parseDigit(fm.s_r_fee_amt[i].value));		
				
		   }	
		}
	
	
	   //매입옵션금액에 대여료 포함할 것 
	   recal_opt_amt =  toInt(parseDigit(fm.opt_amt.value)) +   m_r_fee_amt; 
	//   alert("aa")
	//   alert(toInt(parseDigit(fm.opt_amt.value)));
	//   alert("bb")
	//   alert(m_r_fee_amt);
	//   alert("cc")
	//   alert(recal_opt_amt);
	   fm.opt_amt.value = parseDecimal(recal_opt_amt);	
				
		//대여료를 계산된값으로 변경 		
		 fm.ex_di_v_amt.value = '0'; //과부족
		 fm.ex_di_amt.value = '0'; //과부족		 
		 fm.ex_di_v_amt_1.value = '0'; //중도해지위약금
		 fm.ex_di_amt_1.value = '0'; //중도해지위약금확정
		 
		 fm.nfee_mon.value = '0'; // 미납기간
		 fm.nfee_day.value = '0'; //미납기간
		 
		 
		 fm.nfee_amt.value =  parseDecimal(toInt(parseDigit(fm.t_r_fee_s_amt.value))  -  m_r_fee_s_amt); 
		// alert( toInt(parseDigit(fm.t_r_fee_s_amt.value)) );
	//	 alert( toInt(parseDigit(m_r_fee_v_amt)) );
		// alert(fm.nfee_amt.value);
		 
		 fm.nfee_amt_1.value =  parseDecimal(toInt(parseDigit(fm.t_r_fee_s_amt.value))  -  m_r_fee_s_amt); 		 
		 
		// fm.nfee_amt.value = (fm.t_r_fee_s_amt.value; //미납금액
		// fm.nfee_amt_1.value =  fm.t_r_fee_s_amt.value;  //미납금액			
					 		 
	//	 fm.no_v_amt.value = fm.t_r_fee_v_amt.value; //미납금액
	//	 fm.no_v_amt_1.value =  fm.t_r_fee_v_amt.value;  //미납금액
			
		var no_v_amt = 0;
		
		//각각 부가세 계산하여 더한다.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)    -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
	   if ( fm.mt.value == '1' ) {	   	   
	         if (   Math.abs(toInt(parseDigit(fm.t_r_fee_v_amt.value)) - no_v_amt) < 100  ) {
					no_v_amt =   toInt(parseDigit(fm.t_r_fee_v_amt.value)) - toInt(parseDigit(fm.m_r_fee_v_amt.value));						 					 						 		
				} 
				
	   } 
	   
	   var no_v_amt2 	 = no_v_amt;
	   	   
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt2) );		
		 
		
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
			
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
			
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}	
									
		if ( fm.tax_chk3.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));					 
		}		
		
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
		*/
			
		set_cls_s_amt();
	}	
		
	
	function view_car_service(car_id){
	  var fm = document.form1;
		window.open("/acar/secondhand_hp/service_history.jsp?c_id="+fm.car_mng_id.value+"&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, resizable=yes, scrollbars=yes, status=yes");		
	}
	
		
	//대여료 스케줄 인쇄화면
	function print_view(mode)
	{
		var fm = document.form1;
		var m_id = fm.rent_mng_id.value;
		var l_cd = fm.rent_l_cd.value;
		var b_dt=  fm.b_dt.value;
		var cls_chk;
	   var mode;
		window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "PRINT_VIEW", "left=50, top=50, width=700, height=640, scrollbars=yes");
	}
			
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 	value='<%=andor%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name="fee_size"			value="<%=fee_size%>">    
<input type='hidden' name='rent_start_dt' value='<%=base1.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base1.get("RENT_END_DT")%>'>  
<input type='hidden' name='car_mng_id' value='<%=base1.get("CAR_MNG_ID")%>'>
<input type='hidden' name='con_mon' value='<%=base1.get("CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base1.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base1.get("IFEE_S_AMT")%>'>
<input type='hidden' name='fee_s_amt' value='<%=base1.get("FEE_S_AMT")%>'>
  
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 

<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'> 

<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--만기일기준 경과계약기간 -->

<input type='hidden' name='bank_code2' 	value=''>
<input type='hidden' name='deposit_no2' 	value=''>
<input type='hidden' name='bank_name' 	value=''>  
 
<input type='hidden' name='cls_s_amt' value='' >
<input type='hidden' name='cls_v_amt' value='' >
<input type='hidden' name='car_ja_no_amt' value='<%=car_ja_no_amt%>' >
<input type='hidden' name='opt_chk' value='<%=ext_fee.getOpt_chk()%>'>

<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'>
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_V_AMT")))%>'>
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_AMT")))%>'> <!--스케쥴의 연체월대여료 -잔액 -->

<input type='hidden' name='s_mon' value='<%=base1.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base1.get("S_DAY")%>'> 

<input type='hidden' name='m_mon' value='<%=base1.get("M_MON")%>'>
<input type='hidden' name='m_day' value='<%=base1.get("M_DAY")%>'> 

<input type='hidden' name='hs_mon' value='<%=base1.get("HS_MON")%>'>  <!-- 잔액제외한 미납일자 -->
<input type='hidden' name='hs_day' value='<%=base1.get("HS_DAY")%>'> <!-- 잔액제외한 미납일자 -->

<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_S_AMT")))%>'> <!--스케쥴의 선납대여료 -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'>  

<input type='hidden' name='dly_c_dt' value='' >

<input type='hidden' name='reg_cnt' value='<%=reg_cnt%>'> <!-- 기등록여부 -->

<input type='hidden' name='lfee_mon' value='<%=base1.get("LFEE_MON")%>'> <!--대여개월수 -->
  

   <!--초과운행 거리 계산 -->
<input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
<input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
<input type='hidden' name='over_run_day' value='<%=car1.getOver_run_day()%>'>
 <input type='hidden' name='agree_yn' value='<%=car1.getAgree_dist_yn()%>'>
  
<input type='hidden' name='rc_s_amt' value='<%=base1.get("RC_S_AMT")%>'> <!--받은 금액 --> 
<input type='hidden' name='rc_v_amt' value='<%=base1.get("RC_V_AMT")%>'> <!-- 받은 금액 --> 
<input type='hidden' name='rr_s_amt' value='<%=base1.get("RR_S_AMT")%>'> <!-- 받을 금액 --> 
<input type='hidden' name='rr_v_amt' value='<%=base1.get("RR_V_AMT")%>'> <!-- 받을 금액 --> 
<input type='hidden' name='rr_amt' value='<%=base1.get("RR_AMT")%>'> <!-- 받을 금액 --> 
 <input type='hidden' name='taecha_st_dt' value='<%=taecha_st_dt%>'><!--만기매칭대차 시작일 -->
    
<input type='hidden' name='a_f' value='<%=em_bean.getA_f()%>'>  <!-- 이자율 --> 

<input type='hidden' name='vt_size8' value='<%=vt_size8%>' >  <!--중도정산시 미납스케쥴 -->

<input type='hidden' name='e_grt_amt' value='<%=e_grt_amt%>' >
<input type='hidden' name='e_tax_amt' value='<%=AddUtil.parseInt((String)sale.get("TAX_AMT"))%>' >
<input type='hidden' name='e_insur_amt' value='<%=AddUtil.parseInt((String)sale.get("INSUR_AMT"))%>' >
<input type='hidden' name='e_serv_amt' value='<%=AddUtil.parseInt((String)sale.get("SERV_AMT"))%>' >
    
<input type='hidden' name='mt'  value='0' >  <!-- 매입옵션타입  0:원래, 1:중도매입 2:연장중도매입 --> 
 <input type='hidden' name='b_dt' size='10' value='<%=Util.getDate()%>' >
     
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
 	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약사항</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=12%>계약번호</td>
            <td width=24%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;<a href="javascript:view_cng_etc('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='특이사항'><img src=/acar/images/center/button_tish.gif align=absmiddle border=0></a>
               &nbsp;<a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='스캔관리'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
                &nbsp;<a href="javascript:print_view('');" title='기본' onMouseOver="window.status=''; return true">[스케쥴]</a>
            </td>
            <td class=title width=10%>영업지점</td>
            <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
            <td class=title width=10%>관리지점</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
          </tr>
          <tr> 
            <td class=title>최초영업자</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
            <td class=title>영업대리인</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
            <td class=title>영업담당자</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
          </tr>
          <tr>
            <td class=title>계약일자</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
            <td class=title>계약구분</td>
            <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
            <td class=title>영업구분</td>
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이전트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
          </tr>
          <tr> 
            <td class=title>차량구분</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
            <td class=title>용도구분</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
            <td class=title>관리구분</td>
            <td>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
          </tr>
          <tr>
            <td class=title>상호</td>
            <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a></td>
            <td class=title>대표자</td>
            <td>&nbsp;<%=client.getClient_nm()%></td>
            <td class=title>지점/현장</td>
            <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=site.getR_site()%></a></td>
          </tr>
          <tr>
            <td class=title>차량번호</td>
            <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a>
                &nbsp;<font color="red">(차령: <%=base1.get("CAR_MON")%>개월, 차령만료일:<%=cr_bean.getCar_end_dt()%> ) 
             <% if ( cr_bean.getCar_end_yn().equals("Y") )  {%>연장종료<%} %>
              </font>  
            </td>
            <td class=title width=10%>차명</td>
            <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
			<font color="#999999">(차종코드:<%=cm_bean.getJg_code()%>)</font>
			</td>
          </tr>		  
        </table>
	  </td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
          <tr>
            <td style="font-size : 9pt;" width="3%" class=title rowspan="2">연번</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">계약일자</td>
            <td style="font-size : 9pt;" width="6%" class=title rowspan="2">계약기간</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">대여개시일</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">대여만료일</td>
            <td style="font-size : 9pt;" width="7%" class=title rowspan="2">계약담당</td>
            <td style="font-size : 9pt;" width="9%" class=title rowspan="2">월대여료</td>
            <td style="font-size : 9pt;" class=title colspan="2">보증금</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">선납금</td>
            <td style="font-size : 9pt;" class=title colspan="2">개시대여료</td>
            <td style="font-size : 9pt;" class=title colspan="2">매입옵션</td>
          </tr>
          <tr>
            <td style="font-size : 9pt;" width="10%" class=title>금액</td>
            <td style="font-size : 9pt;" width="3%" class=title>승계</td>
            <td style="font-size : 9pt;" width="10%" class=title>금액</td>
            <td style="font-size : 9pt;" width="3%" class=title>승계</td>
            <td style="font-size : 9pt;" width="10%" class=title>금액</td>
            <td style="font-size : 9pt;" width="3%" class=title>%</td>			
          </tr>
		  <%for(int i=0; i<fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				if(!fees.getCon_mon().equals("")){
				
			//	s_opt_per = fees.getOpt_per(); // 계산방식으로 변경 
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
				s_opt_end_dt= fees.getRent_end_dt();
				
			   f_opt_per  = (float) s_opt_amt  / car_price * 100 ;
			   			 			   
			   f_opt_per =  AddUtil.parseFloatCipher(f_opt_per,1);
				
				  //  fee_size - 1인것 (연장인경우에 한해서 ) 
			   if ( fee_size_1 > 0 ) {
			        if ( i+1 == fee_size_1 ) { 
						      fee_size_1_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
			   					fee_size_1_end_dt= fees.getRent_end_dt();
   					}   
			   }
			   
				%>	
          <tr>
            <td style="font-size : 9pt;" align="center"><%=i+1%></td>
            <td style="font-size : 9pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
            <td style="font-size : 9pt;" align="center"><%=fees.getCon_mon()%>개월</td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>원&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>원&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%=f_opt_per%></td>
          </tr>
		  <%}}%>
        </table>
	  </td>
	</tr>
	<tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2" style='background-color:bebebe; height:1;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>	
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지내역</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='13%' class='title'>해지구분</td>
            <td width="13%">&nbsp; 
			  <select name="cls_st" onChange='javascript:cls_display()'>
			    <option value="">---선택---</option> 
                <option value="8">매입옵션</option>   
              </select> </td>
            
            <td width='13%' class='title'>의뢰자</td>
            <td width="13%">&nbsp;
              <select name='reg_id'>
                <option value="">선택</option>
                <%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%		}
					}%>
              </select></td>	
                      
            <td width='13%' class='title'>해지일자</td>
            <td width="13%">&nbsp;
			  <input type='text' name='cls_dt' value='<%=AddUtil.getDate()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'></td> 
		    <td width='13%' class='title'>이용기간</td>
		    <td >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' readonly  value='<%=base1.get("R_MON")%>' >개월&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=base1.get("R_DAY")%>' onBlur='javascript:set_cls_amt1(this);'>일&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>사유 </td>
            <td colspan="7">&nbsp;
			  <textarea name="cls_cau" cols="140" class="text" style="IME-MODE: active" rows="3"></textarea> 
            </td>
          </tr>
          <tr>                                                      
            <td class=title >잔여선납금<br>매출취소여부</td>
     	    <td>&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'>
                  <option value="Y" selected>매출취소</option>
                  <option value="N">매출유지</option>
              </select>
		    </td>
		    
		    <td  class=title width=10%>매입옵션담당자</td>
            <td  width=12%>&nbsp;
				  <select name='add_saction_id'>
	                <option value="">--선택--</option>
	         <!--       <option value="000172">정진식</option> -->
	                <option value="000197">조현준</option>	              
	            </select>
			</td>			     
            <td  colspan="4" align=left>&nbsp;※ 기발행 계산서의 유지 또는 취소여부 등 확인이 필요, 매출취소시 마이너스 세금계산서 발행 </td>
          </tr>
          
           <tr>      
		            <td width='13%' class='title'>주행거리</td>
		            <td width='18%' >&nbsp;
		             <input type='text' name='tot_dist' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_over_amt();'>&nbsp;km
                     &nbsp;<a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="정비내역보기"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a>
                     </td>	     	    		
                  <td colspan=6>&nbsp;※ 매입옵션시 차량주행거리 </td>
		     </tr>        
              	   
        </table>
      </td>
    </tr>    
    
     <% if ( !cont_etc.getCls_etc().equals("") ) {%>
  			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>              
					                    <td class=title style='height:44' width=13%>해지 특이사항 </td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="cont_cls_etc" cols="140" class="text" style="IME-MODE: active" rows="2"><%=cont_etc.getCls_etc()%></textarea> 
					                    </td>
					                </tr>
		                
		           				</table>
		           			</td>
		           		</tr>
		           	</table>			
		        </td>
		    </tr>
   <%} %>  
   
      <tr></tr><tr></tr>    
        			         
	 <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('des_zip').value =  data.zonecode;
								document.getElementById('des_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
	       		  <tr>
	                    <td class=title width=13%>서류배송주소</td>
						<td colspan=4>&nbsp;
							<input type="text" name='des_zip' id="des_zip" size="7" maxlength='7'>
							<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
							&nbsp;&nbsp;<input type="text" name='des_addr' id="des_addr" size="80">
						</td>
						<!--
	                    <td  colspan="4">&nbsp; <input type='text' name='des_zip'  size='7' class='text' readonly onClick="javascript:search_zip('des');">
				      <input type='text' size='70' name='des_addr'  maxlength='80' class='text'>   </td>
					  -->
                   	  <td class=title width=13%>수취인</td>
                   	   <td  colspan=2 >&nbsp; <input type='text' size='30' name='des_nm'    maxlength='40' class='text'> </td>
			  </tr>
	              </table>
	         </td>       
   	 </tr> 
   	 <tr>
     		 <td>&nbsp;</td>
     </tr>
  
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> 만기전 매입옵션 행사하는 경우 대여료는 계약만기일까지 자동 계산됩니다.</td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> 매입옵션 입력시 해지일자는 매입옵션 입금예정일을 입력하셔야 합니다. </td>
    </tr>
    
    <tr>
           	<td>&nbsp;<font color="#FF0000">***  31일, 30일 일자에 따라 금액 차이 발생될 수 있으니 반드시 대여료 스케쥴 확인하여 처리하세요.!!! </font></td> 
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    
 	<tr id=tr_opt style="display:''">  
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매입옵션</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 		<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>          	
		          	<input type='hidden' name='mopt_per' value='<%=f_opt_per%>'>
		          	<input type='hidden' name='mopt_amt' value='<%=AddUtil.parseDecimal(s_opt_amt)%>'>
		          	<input type='hidden' name='mopt_s_amt' value='<%=s_opt_s_amt%>'>
		          	<input type='hidden' name='old_opt_amt' >
		         		<input type='hidden' name='fee_size_1_opt_amt' value='<%=fee_size_1_opt_amt%>'>  <!--연장인경우 중도매입옵션시 필요할 수도 있음 -->
		           	<input type='hidden' name='fee_size_1_end_dt' value='<%=fee_size_1_end_dt%>'>
		          	<input type='hidden' name='s_opt_end_dt' value='<%=s_opt_end_dt%>'>
		 			<tr>	         	
		 	 	     <td class='title' width="12%">매입옵션율</td>
		             <td width="12%">&nbsp;<input type='text' name='opt_per' value='<%=f_opt_per%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title' width="12%">매입옵션가</td>
		             <td colspan=2 width="26%">&nbsp;<input type='text' name='opt_amt'size='13' class='num' value="<%=AddUtil.parseDecimal(s_opt_amt)%>" onBlur='javascript:this.value=parseDecimal(this.value); set_sui_c_amt();'>&nbsp;(VAT포함)</td> 
		       
		             <td class='title' width="13%">등록비용</td>
		             <td colspan=2 width="22%" >&nbsp;<input type="radio" name="sui_st" value="Y" onClick='javascript:set_sui_c_amt()'>포함
                                                <input type="radio" name="sui_st" value="N" checked onClick='javascript:set_sui_c_amt()'>미포함 </td>
                  </tr>	
                         
		          <tr> 
		 	 		   <td class='title' width="12%" rowspan=3>이전등록비용</td>
		             <td class='title' width="12%">등록세</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d1_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">채권할인</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d2_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">취득세</td>
		             <td colspan=2  width="22%" >&nbsp;<input type='text' name='sui_d3_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		          </tr>  
		          <tr> 
				 	    <td class='title' width="12%">인지대</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d4_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">증지대</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d5_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">번호판대</td>
		             <td colspan=2  width="22%" >&nbsp;<input type='text' name='sui_d6_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		          </tr>  
		          <tr> 
		 		  	  <td class='title' width="12%">보조번호판대</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d7_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">등록대행료</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d8_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">계</td>
		             <td colspan=2  width="22%" >&nbsp;<input type='text' name='sui_d_amt' readonly  value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp; *천원절사</td> 
		          </tr> 
		       </table>
		      </td>        
         </tr>   
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
  
  	<tr id=tr_ret style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량회수</span></td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		    
			<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 
			            <td width='13%' class='title'>회수여부</td>
			            <td width="20%">&nbsp;<input type="radio" name="reco_st" value="Y" checked onClick='javascript:cls_display2()'>회수
	                            <input type="radio" name="reco_st" value="N"  onClick='javascript:cls_display2()'>미회수</td>
	                    <td width='13%' class='title'>구분</td>
	                    
	                    <td id=td_ret1 style="display:''">&nbsp; 
						  <select name="reco_d1_st" >
						    <option value="">---선택---</option>
			                <option value="1">정상회수</option>
			                <option value="2">강제회수</option>
			                <option value="3">협의회수</option>
			               </select>       
			            </td>
			            
			            <td id=td_ret2 style='display:none'>&nbsp; 
						  <select name="reco_d2_st" >
						    <option value="">---선택---</option>
						    <option value="1">도난</option>
						    <option value="2">횡령</option>
						    <option value="3">멸실</option>
						   </select>       
			            </td>
			            
			            <td class='title' width='13%' >사유</td>
						<td>&nbsp;
						<input type="text" name="reco_cau" size=30 maxlength=100 >
						</td>				        		         
		         </tr>
		                   
		         <tr>      
		            <td width='10%' class='title'>회수일자</td>
		            <td>&nbsp;
					  <input type='text' name='reco_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		            <td width='10%' class='title'>회수담당자</td>
		            <td>&nbsp;
					  <select name='reco_id'>
		                <option value="">선택</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>
		            </td>
		            <td width='10%' class='title'>입고일자</td>
		            <td>&nbsp;
					  <input type='text' name='ip_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		          </tr>
		          
		          <tr>      
		            <td width='10%' class='title'>외주비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'></td>
		            </td>
		            <td width='10%' class='title'>부대비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'></td>
		            </td>
		            <td width='10%' class='title'>비용계</td>
		            <td>&nbsp;
					 <input type='text' name='etc_out_amt' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		            </td>
		          </tr>
		     
		        </table>
		      </td>
		    </tr>
		    <tr>
		      <td>&nbsp;</td>
		    </tr>	
		</table>
      </td>	 
    </tr>	     
		    
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선납금액 정산</span>[공급가]</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
		            <td  colspan="2" class='line'> 
		              <table border="0" cellspacing="1" cellpadding="0" width="100%">
		                <tr> 
		                  <td class='title' align='right' colspan="3">항목</td>
		                  <td class='title' width='38%' align="center">정산</td>
		                  <td class='title' width="40%">비고</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="7" width=4%>환<br>
		                    불<br>
		                    금<br>
		                    액</td>
		                  <td class='title' colspan="2">보증금(A)</td>
		                  <td class='title' > 
		                    <input type='text' name='grt_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td class='title'>&nbsp;</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3" width=4%>개<br>
		                    시<br>
		                    대<br>
		                    여<br>
		                    료</td>
		                  <td width="14%" align="center" >경과기간</td>
		                  <td align="center"> 
		                    <input type='text' size='3' name='ifee_mon' readonly  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
		                    개월&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
		                    일</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >경과금액</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td>=개시대여료×경과기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 개시대여료(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td class='title'>=개시대여료-경과금액</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">선<br>
		                    납<br>
		                    금</td>
		                  <td align='center'>월공제액 </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td>=선납금÷계약기간</td>
		                </tr>
		                <tr> 
		                  <td align='center'>선납금 공제총액 </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td>=월공제액×실이용기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 선납금(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td class='title'>=선납금-선납금 공제총액</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">계</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
		                  <td class='title'>=(A+B+C)</td>
		                </tr>
		              </table>
		            </td>
			     </tr>
    
            </table>
        </td>
    </tr>
   	<tr></tr><tr></tr><tr></tr>
     
    <input type='hidden' name='ex_ip_amt'  value='0'> 
    <input type='hidden' name='ex_ip_dt' > 
    <input type='hidden' name='bank_code' > 
    <input type='hidden' name='deposit_no' > 
    <!-- 추가입금은 당분간 사용 안함  
   	<tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10%>추가입금액</td>
                    <td width=13%>&nbsp;<input type='text' name='ex_ip_amt'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);' > 원</td>
                    <td class=title width=10%>입금일</td>
				    <td width=10%>&nbsp;<input type='text' name='ex_ip_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
				    <td class=title width=10%>입금은행</td>
				    <td width=10%>&nbsp;<select name='bank_code' onChange='javascript:change_bank()'>
                      <option value=''>선택</option>
                      <%if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];	%>
                      <option value='<%= bank.getCode()%>:<%= bank.getNm()%>'><%= bank.getNm()%></option>
                      <%	}
					}	%>
                    </select>&nbsp;</td>
                    <td class=title width=10%>계좌번호</td>
		            <td>&nbsp;<select name='deposit_no'>
		                      <option value=''>계좌를 선택하세요</option>
		                    </select>
					</td>
                </tr>
              </table>
         </td>       
    </tr>
    -->
    
    <tr>
        <td class=h></td>
    </tr>
        
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납금액 정산</span>[공급가]</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    
    <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
              <td class="title" colspan="4" rowspan=2>항목</td>
              <td class="title" width='38%' colspan=2>채권</td>        
              <td class="title" width='40%' rowspan=2>비고</td>
            </tr>
            <tr>                 
              <td class="title"'> 당초금액</td>
              <td class="title"'> 확정금액</td>
            </tr>
            <tr> 
              <td class="title" rowspan="19" width="4%">미<br>
                납<br>
                입<br>
                금<br>
                액</td>
              <td class="title" colspan="3">과태료/범칙금(D)</td>
              <td align="center" class="title"> 
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>' size='15' class='num' ></td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>'  size='15' class='num'  ></td>
              <td class="title"><font color="#66CCFF"><%=base1.get("FINE_CNT")%>건</font></td>
             </tr>
             <tr> 
              <td class="title" colspan="3">자기차량손해면책금(E)</td>
              <td width='19%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>' size='15' class='num' ></td>
              <td width='19%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>'  size='15' class='num'  ></td>                   
              <td width='40%' class="title"><font color="#66CCFF"><%=base1.get("SERV_CNT")%>건</font></td>
            </tr>
            <tr>
              <td class="title" rowspan="5" width="4%"><br>
                대<br>
                여<br>
                료</td>
              <td align="center" colspan="2" class="title">과부족</td>   
               <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
                <input type='text' name='ex_di_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' ></td>
              <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>              
            
              <td>&nbsp; </td>
            </tr>
          
            <tr> 
              <td rowspan="2" align="center" class="title" width="4%">미<br>
                납</td>
              <td width='10%' align="center" class="title">기간</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' size='3' name='nfee_mon'  value='<%=AddUtil.parseInt((String)base1.get("S_MON"))%>' readonly class='num' maxlength='4' >
                개월&nbsp;&nbsp;&nbsp; 
                <input type='text' size='3' name='nfee_day'  value='<%=AddUtil.parseInt((String)base1.get("S_DAY"))%>' readonly class='num' maxlength='4' >
                일</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" class="title">금액</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt'  readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' ></td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>  
              <td>기발행계산서의 유지 또는 취소여부를 확인
               <input type='hidden' size='15' name='dfee_amt' value='' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                <input type='hidden' size='15' name='dfee_amt_1' readonly value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
              </td>
            </tr>      
            <tr> 
              <td colspan="2" align="center" class="title">연체료</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' ></td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>
             
              <td class='title'>&nbsp;</td>
            </tr>
         
            <tr> 
              <td class="title" colspan="2">소계(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='d_amt' value='' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='d_amt_1' readonly value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
              <td class='title'>&nbsp;=과부족 + 미납 + 연체료</td>
            </tr>
            <tr> 
              <td rowspan="6" class="title">중<br>
                도<br>
                해<br>
                지<br>
                위<br>
                약<br>
                금</td>
              <td align="center" colspan="2" class="title">대여료총액</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base1.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=선납금+월대여료총액</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">월대여료(환산)</td>
              <td class='' colspan=2 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=대여료총액÷계약기간</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">잔여대여계약기간</td>
              <td class=''  colspan=2  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=AddUtil.parseInt((String)base1.get("N_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                개월&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day' readonly size='3' value='<%=AddUtil.parseInt((String)base1.get("N_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                일</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">잔여기간 대여료 총액</td>
              <td class=''  colspan=2 align="center"> 
                <input type='text' name='trfee_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> 위약금 
                적용요율</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int' readonly value='<%=base1.get("CLS_R_PER")%>' size='5' class='num'  maxlength='5'>
                %</td>
                <td class=''  align="center"> 
                <input type='text' name='dft_int_1' value='<%=base1.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='5'>
                %</td>
           
              <td>위약금 적용요율은 계약서를 확인</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">중도해지위약금(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='' ></td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' size='15' class='num' value='' onBlur='javascript:set_cls_amt(this)'></td>
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                <td class="title">&nbsp;<input type='hidden' name='tax_chk0' value='N' ><!--계산서발행의뢰--></td>
            </tr>      
       
            <tr> 
              <td class="title" rowspan="5"><br>
                기<br>
                타</td> 
              <td class="title" colspan="2">차량회수외주비용(H)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;<input type='hidden' name='tax_chk1' value='N' ></td>
            </tr>
            <tr> 
              <td class="title" colspan="2">차량회수부대비용(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>  
              <td class="title">&nbsp;<input type='hidden' name='tax_chk2' value='N' ></td>
            </tr>
            <tr> 
              <td colspan="2" class="title">잔존차량가격(J)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">기타손해배상금(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;<input type='hidden' name='tax_chk3' value='N' ><!--계산서발행의뢰--></td>
            </tr>
               <tr> 
              <td class="title" colspan="2">초과운행추가대여료(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1'  readonly  value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                  <input type='hidden' name='tax_chk4'  value=''>
                 <td class="title">&nbsp;<!--<input type='checkbox' name='tax_chk4' value='Y' onClick="javascript:set_vat_amt(this);">계산서발행의뢰--></td>
            </tr>       
            <tr> 
              <td class="title" colspan="3">부가세(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='' readonly size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='' readonly size='15' class='num' ></td>  
              <td > 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td id=td_cancel_n style="display:''" class="title">=(대여료 
                      미납입금액-B-C)×10% + 계산서 발행 부가세 </td>
                    <td id=td_cancel_y style='display:none' class='title'>=(대여료 
                       미납입금액-B-C)×10% + 계산서 발행 부가세 </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr> 
              <td class="title_p" colspan="4">계</td>
              <td class='title_p' align="center"> 
	               <input type='text' name='fdft_amt1' value='' readonly  size='15' class='num' ></td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='' readonly  size='15' class='num' ></td>  
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M)&nbsp;&nbsp;
               <br>※ 계산서:&nbsp;             
                <input type="radio" name="tax_reg_gu" value="N" checked >항목별개별발행
                <input type="radio" name="tax_reg_gu" value="Y" >항목별통합발행(1장)
               
            </tr>
          </table>
        </td>
         
    </tr>
    <tr></tr><tr></tr><tr></tr>
    
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >고객납입금액</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2'  size='15' class='num' readonly  ></td>
                        <% if ( h_cms.get("CBNO") == null  ) {%>
	                    <td colspan=6 width=60%>&nbsp;※ 미납금액계 - 환불금액계</td>
	                    <% } else { %>                  
	                  	<td class=title width='12%'></td>
	                 	<td>&nbsp;※ 미납금액계 - 환불금액계</td>    
	                 	<td colspan=4 width=30%>&nbsp;<input type='checkbox' name='cms_after' value='Y' ><font color="red">CMS 확인후 익일처리</font></td>   	                    	
	                    <% } %>	  
              </tr>
          
              </table>
         </td>       
    <tr>
    <tr></tr><tr></tr><tr></tr>
   	<tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td  class=title width=10%>연체료감액<br>결재자</td>
                    <td  width=12%>&nbsp;
						  <select name='dly_saction_id'>
			                <option value="">--선택--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>연체료 감액사유</td>
                    <td colspan=3>&nbsp;<textarea name="dly_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
			
                </tr>
                <tr>
             		<td  class=title width=10%>중도해지위약금<br>감액 결재자</td>
                    <td  width=12%>&nbsp;
						  <select name='dft_saction_id'>
			                <option value="">--선택--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>중도해지위약금<br>감액사유</td>
                    <td colspan=3>&nbsp;<textarea name="dft_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
				   
                </tr>
                <tr>
                	<td  class=title width=10%>확정금액결재자</td>
                    <td  width=12%>&nbsp;
						  <select name='d_saction_id'>
			                <option value="">--선택--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>확정금액 사유</td>
                    <td colspan=3>&nbsp;<textarea name="d_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
				  
                </tr>
              </table>
         </td>       
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> 중도해지 위약금의 감액 관련해서는 사전에 영업팀장의 결재를 득해야 합니다. 이경우 중도해지위약금 감액 결재자 필수항목입니다.</td>
    </tr>
    
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_sale style='display:none'> 
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >매입옵션시<br>고객납입금액</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt3'  size='15' class='num' readonly  ></td>
                    <td colspan=6>&nbsp;※ 고객납입금액  + 매입옵션금액 + 이전등록비용(발생한 경우)</td>
              </tr>
                       
              </table>
         </td>       
    <tr>
  
      <tr>
        <td>&nbsp;</td>
    </tr>
     
    
   <!-- 중도정산서에 한함  block none  대여만기가 2개월이상 남았을 경우  -->
    
   	<tr id=tr_cal_sale style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td height=22><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중도 정산서 </span></td>
 	 		 <td align="right">&nbsp;<a href='javascript:cal_rc_rest()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_hj_bill.gif" align=absmiddle border="0"></a>&nbsp;&nbsp;</td>
 	 	  </tr>
 	 	    
 	 	  <tr>
      		 <td colspan="2" class=line2></td>
   		  </tr>	
 	 	 	 	
 	 	  <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  rowspan="2"  width='3%'>회차</td>
              <td class="title"  rowspan="2" width='8%'>납입할날짜</td>                
              <td class="title"  rowspan="2" width='8%'>월대여료<br>(공급가)</td>
              <td class="title"  rowspan="2" width='8%'>월대여료 산정시 <br>보증금 이자효과</td>
              <td class="title"  rowspan="2" width='8%'>보증금 이자효과 반영전<br> 월대여료(공급가)</td>                  
              <td class="title"  rowspan="2" width='8%'>자동차세</td>                
              <td class="title"  rowspan="2" width='8%'>보험료+<br>정비비용</td>
              <td class="title"  rowspan="2" width='8%'>자동차세,보험료<br> 제외요금<br>(공급가)</td>                
              <td class="title"  width='25%' colspan=3>자동차세,보험료 제외요금의 현재가치</td>             
              <td class="title"  width='16%' colspan=2>현재가치 산출 보조자료<br>(이자율: 년 <%=em_bean.getA_f()%>%)</td>             
            </tr>          
            
            <tr> 
              <td class="title"  width='8%' >공급가</td>
              <td class="title"  width='8%'>부가세</td>
              <td class="title"  width='9%'>합계</td>
              <td class="title"  width='8%'>현재가치율</td>
              <td class="title"  width='8%'>기준일대비<br>경과일수</td>
             </tr>  
             <tr> 
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td align="center"> (1) </td>
              <td align="center"> (2) </td>
              <td align="center"> (3) = (1) + (2)</td>
              <td align="center"> (4) </td>
              <td align="center"> (5) </td>
              <td align="center"> (6) = (3) - (4) - (5) </td>
              <td align="center"> (7) = (6) * (10) </td>
              <td align="center"> (8) = (7) * 0.1</td>
              <td align="center"> (9) = (7) + (8)</td>
              <td align="center"> (10) </td>
              <td align="center"> (11) </td>                          
             </tr>              
             
<!-- scd_fee에서 데이타 가져와서 처리 --> 
              
<%	
		
	for(int i = 0 ; i < vt_size8 ; i++){
					Hashtable ht8 = (Hashtable)vts8.elementAt(i); 					
										
					t_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("FEE_S_AMT")));
					
%>       
	 		   <tr>
                    <td>&nbsp;<input type='text' name='s_fee_tm'  readonly value='<%=ht8.get("FEE_TM")%>' size='4' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_est_dt'  readonly value='<%=AddUtil.ChangeDate2(String.valueOf(ht8.get("R_FEE_EST_DT")))%>' size='12' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_fee_s_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("FEE_S_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_grt_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_g_fee_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_tax_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_is_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_cal_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_s_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_v_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_rc_rate'  readonly value='' size='10' class='num' > </td> 
                    <td>&nbsp;<input type='text' name='s_cal_days'  readonly value='' size='8' class='num' > </td>
                 
                   
               </tr>
<% } %>
               
               <tr>
                    <td colspan="2" class=title>합계</td>
                    <td class=title><input type='text' name='t_fee_s_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_fee_s_amt)%>'></td>
                    <td class=title><input type='text' name='t_s_grt_amt' size='10' class='fixnum' value=''></td>
                    <td class=title><input type='text' name='t_s_g_fee_amt' size='10' class='fixnum' value=''></td>
                    <td class=title></td>
                    <td class=title></td>
                    <td class=title><input type='text' name='t_s_cal_amt' size='10' class='fixnum' value=''></td>
                    <td class=title><input type='text' name='t_r_fee_s_amt' size='10' class='fixnum' value=''></td>
                    <td class=title><input type='text' name='t_r_fee_v_amt' size='10' class='fixnum' value=''></td>
                    <td class=title><input type='text' name='t_r_fee_amt' size='10' class='fixnum' value=''></td>
                    <td class=title></td>
                    <td class=title><input type='text' name='t_cal_days' size='10' class='fixnum' value=''></td>                   
                  
               </tr>	  
                   
             </table>
            </td>
         </tr>         
    	
     	</table>
      </td>	 
  </tr>	  	 	    
  
   <tr>
        <td>&nbsp;</td>
   </tr>
   
     
         <!-- 초과운행부담금에 한함  block none-->
    
   	<tr id=tr_over style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>초과운행추가대여료[공급가]</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	 	 	
 	 	   <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="3"  width='34%'>항목</td>
              <td class="title" width='20%'>내용</td>                
              <td class="title" width='46%'>비고</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="6" >계<br>약<br>사<br>항</td>   
              <td class="title"  rowspan=3>계약내용</td>
              <td class="title" >계약기간</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%>  </td>
              <td align="left" >&nbsp;당초계약기간</td>
             </tr>
              <tr> 
              <td class="title" >약정거리 (가)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;년간</td>
             </tr>      
              <tr> 
              <td class="title" > 단가(부담금) (a)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>원</td>
               <td align="left" >&nbsp;=1km</td>
             </tr>           
            <tr> 
              <td class="title"  rowspan=3>정산기준</td>
              <td class="title" >대여기간</td>
              <td align="right">&nbsp;</td>
              <td align="left" >&nbsp;실제대여기간</td>
             </tr>   
              <tr> 
              <td class="title" >대여일수(나)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("RENT_DAYS")))%>' size='7' class='whitenum' > 일 </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title" >약정거리(한도)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(가)x(나) / 365</td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >운<br>행<br>거<br>리</td>      
               <td class="title"  rowspan=3>운행거리</td>
              <td class="title" >최초주행거리계(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value = '<%=AddUtil.parseDecimal(car1.getSh_km() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;신차(고객 인도시점 주행거리) , 보유차 (계약서에 명시된 주행거리)</td>
             </tr>   
             <tr> 
              <td class="title" >최종주행거리계(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title" >실운행거리(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
              <tr> 
              <td class="title"  rowspan=3>정산기준</td>
              <td class="title" >초과운행거리(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title" >서비스마일리지</td>
              <td align="right" ><input type='text' name='add_dist' readonly    size='7' class='whitenum' > km</td>
                <td align="left" >&nbsp;</td>
             </tr>      
              <tr> 
              <td class="title" >정산기준(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>정<br>산</td>
              <td class="title" colspan=2 >산출금액(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly    size='10' class='whitenum' >원</td>
              <td align="left" >&nbsp;=(a)x(b)</td>
             </tr>
              <tr> 
              <td class="title"   colspan=2 >감액(i)</td>
              <td align="right"> <input type='text' name='m_over_amt'     size='10' class='num'   onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> 원</td>
              <td align="left" >&nbsp;결재자및사유:
                <select name='m_saction_id'>
			                <option value="">--선택--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
		 </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="m_reason" cols="55" class="text" style="IME-MODE: active" rows="2"></textarea> </td>
             </tr>      
              <tr> 
              <td class="title"   colspan=2 >정산(납부)금액</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly    size='10' class='whitenum' >원</td>
              <td align="left" >&nbsp;=(h)-(i)</td>
             </tr>  
                </table>
            </td>
         </tr>         
  
     	</table>
      </td>	 
    </tr>	  	 	    
  
      <tr>
        <td>&nbsp;</td>
    </tr>
   
    
   
<!-- 채권이 있는 경우에 한함 -->
    <tr>
        <td>&nbsp;</td>
    </tr>
        
   	<tr id=tr_gur style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채권관계</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr>
                    <td class=title width=12%>보증보험</td>
                    <td class=title width=13%>보험금액</td>
                    <td width=12%>&nbsp;<input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td class=title width=12%>청구채권</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_c_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'></td>
                    <td class=title width=12%>잔존채권</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_j_amt' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                </tr>
                <!-- 대표연대보증등 -->
<% if(gur_size > 0){
				for(int i = 0 ; i < gur_size ; i++){
					Hashtable gur = (Hashtable)gurs.elementAt(i); %>       
				                
                <tr>
                  <%if (i == 0 ) { %> <td class=title width=12% rowspan=<%=gur_size%>>연대보증</td> <% } %>
                    <td class=title width=13%>입보구분</td>
                    <td width=12%>&nbsp;<input type='text' name='gu_st'  size='15' class='text' > </td>
                    <td class=title width=12%>보증인성명</td>
                    <td width=13%>&nbsp;<input type='text' name='gu_nm' value='<%=gur.get("GUR_NM")%>' size='15' class='text' > </td>
                    <td class=title width=12%>계약자와관계</td>
                    <td width=13%>&nbsp;<input type='text' name='gu_rel' value='<%=gur.get("GUR_REL")%>' size='15' class='text' ></td>
                </tr>
             <% }
  }             %> 
                <tr>
                    <td class=title width=12%>자동차손해보험</td>
                    <td class=title width=13%>보험사</td>
                    <td width=17%>&nbsp;<input type='text' name='c_ins'  size='18' class='text' > </td>
                    <td class=title width=12%>담당자</td>
                    <td width=17%>&nbsp;<input type='text' name='c_ins_d_nm'  size='18' class='text' > </td>
                    <td class=title width=12%>연락처</td>
                    <td width=17%>&nbsp;<input type='text' name='c_ins_tel' size='18' class='text' ></td>
                </tr>
		       </table>
		      </td>        
         </tr>   
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
     
    <!-- 받을채권이 있는 경우 -->
     
    <tr id=tr_cre style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>잔존채권의 처리의견/지시사항</span></td>
 	 	  </tr>  
	      <tr>
	        <td class=line2></td>
	      </tr>
	      <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	                <tr>
	                    <td class=title colspan=2>구분</td>
	                    <td class=title width=75%>처리의견/지시사항/사유</td>
	                  
	                </tr>
	                <tr>
	                    <td class=title width=12%>보증보험청구</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu1">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" >예</option>
		                      <option value="N" >아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark1' size='120' class='text' ></td>
	                 
	                </tr>
	                <tr>
	                    <td class=title>연대보증인구상</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu2">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" >예</option>
		                      <option value="N" >아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark2' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>채권추심외주</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu3">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" >예</option>
		                      <option value="N" >아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark3' size='120' class='text' ></td>
	                   
	                </tr>
	                <tr>
	                    <td class=title>자동차손해보험</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu4">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" >예</option>
		                      <option value="N" >아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark4' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>면제</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu5">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" >예</option>
		                      <option value="N" >아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark5' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>대손처리</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu6">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" >예</option>
		                      <option value="N" >아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark6' size='120' class='text' ></td>
	                  
	                </tr>
	            </table>
	        </td>
	      </tr>
	     <tr></tr><tr></tr>    
	        			         
	     <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	       		  <tr>
	                    <td class=title width=12%>결재자</td>
	                    <td width=13%>&nbsp;
							  <select name='crd_id'>
				                <option value="">선택</option>
				                <%	if(user_size > 0){
										for(int i = 0 ; i < user_size ; i++){
											Hashtable user = (Hashtable)users.elementAt(i); %>
				               	<option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
				  
				                <%		}
									}%>
				              </select>
				        </td>
	                    <td class=title width=12%>사유</td>
					    <td colspan=3>&nbsp;<input type='text' name='crd_reason' size='100' maxlength=300 class='text'></td>
	                </tr>
	              </table>
	         </td>       
   		 </tr>
   		 <tr>
     		 <td>&nbsp;</td>
     	 </tr>
	            
	  	</table>
      </td>	 
    </tr>	 
       
	      
	<!-- 받을채권이 있는 경우 -->
    <tr id=tr_get style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채무자 자구책</span></td>
		    </tr>
		    <tr>
		        <td class=line2></td>
		    </tr>
		    <tr>
		        <td class=line>
		            <table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
		                    <td class=title width=12%>구분</td>
		                    <td colspan=7>&nbsp; 
								  <select name="div_st" onChange='javascript:cls_display3()'>
								    <option value="">---선택---</option>
					                <option value="1">일시납</option>
					                <option value="2">분납</option>
					              </select>             
					              <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                        <tr> 
					                         
					                           <td id='td_div' style='display:none'>&nbsp;분납횟수&nbsp;  
					                             <select name="div_cnt">
												    <option value="">---선택---</option>
									                <option value="2">2</option>
									                <option value="3">3</option>
									                <option value="4">4</option>
									                <option value="5">5</option>
									                <option value="6">6</option>
									                <option value="7">7</option>
									                <option value="8">8</option>
									                <option value="9">9</option>
									                <option value="10">10</option>
									                <option value="11">11</option>
									                <option value="12">12</option>
									              </select>
					                            </td>
					                        </tr>
					                </table>
					         	</td>
					    	</tr>
					  
		                	<tr>
			                    <td class=title width=13%>내역</td>
			                    <td class=title width=12%>약정일</td>
			                    <td>&nbsp;<input type='text' name='est_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
			                    <td class=title width=12%>약정금액</td>
			                    <td>&nbsp;<input type='text' name='est_amt' size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
			                    <td class=title width=12%>약정자</td>
			                    <td>&nbsp;<input type='text' name='est_nm' size='15' class='text'></td>
		                	</tr>
		             	                
		            	</td>
		        	</tr>
		    	</table>
		  		</td>
		    </tr>
			<tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>
									         <td class=title width=13%>대위변제자</td>
									         <td width=12%>&nbsp;<input type='text' name='gur_nm' size='15' class='text'></td>
						                     <td width=12% class=title>연락처</td>
						                     <td>&nbsp;<input type='text' name='gur_rel_tel' size='30' class='text'></td>
						                     <td width=12% class=title>계약자와의관계</td>  
						                     <td colspan=3>&nbsp;<input type='text' name='gur_rel' size='30' class='text'></td>     
		           			             
		               			    </tr>
		               			 </table>
		               		</td>
		                </tr>
		             </table>
		          </td>
		    </tr>
		   	<tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>              
					                    <td class=title style='height:44' width=13%>처리의견/지시사항/<br>사유</td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="remark" cols="140" class="text" style="IME-MODE: active" rows="3"></textarea> 
					                    </td>
					                </tr>
		                
		           				</table>
		           			</td>
		           		</tr>
		           	</table>			
		        </td>
		    </tr>
		    <tr>
		        <td>&nbsp;</td>
		    </tr>
       	</table>
      </td>	 
    </tr>
    
    <tr>
	  <td align="center">&nbsp;<input type="text" name="cls_msg"  size="80" readonly  class=text> </td>
	</tr>	    
        	  	   
    
    <tr>
	  <td align="center">&nbsp;<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>	
  
  </table>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // 개시대여료 잔액
		var v_ifee_ex_amt = 0;  //개시대여료 경과금액
		var  re_nfee_amt = 0;  //마지막차 스케쥴에서 일수 계산한 금액이 아닌 경우 check
 		var  santafe_amt = 0; 
 		 		
 		//총사용일수 초기 셋팅		
		if(fm.r_day.value == '30'){
			fm.r_mon.value = toInt(fm.r_mon.value) + 1;
			fm.r_day.value = '0';			
		}
		
		//0 보다 적은 경우	
		if(toInt(fm.r_day.value)  <0){
			fm.r_day.value = '0';			
		}	 
 			 				
 		if(toInt(fm.nfee_day.value)  <0){
			fm.nfee_day.value = '0';			
		}		    
				 				
		//해지일이 계약만료일보다 큰 경우 매출유지 setting
		if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 
			fm.cancel_yn.value = 'N';
			td_cancel_n.style.display 		= 'none';  //매출유지
			td_cancel_y.style.display 		= '';  //매출취소
		}
				
			//매입옵션인 경우 매출유지 setting
		if ( fm.cls_st.value == '8') { //매입옵션 
			fm.cancel_yn.value = 'N';
			td_cancel_n.style.display 		= 'none';  //매출유지
			td_cancel_y.style.display 		= '';  //매출취소
			tr_sale.style.display 		= '';  //차량매각시 고객납입금액
			
			
		}
		
		//초과운행부담금 2 인경우 - 50% 납부 , 3이면 정산금액
		if ( fm.agree_yn.value == '2'   ||  fm.agree_yn.value == '3'  ) {	
			if ( <%= o_amt%> > 0   ) {
		
				tr_over.style.display 		= '';  //초과운행부담금
				if (<%=car1.getOver_bas_km()%>  > 0 ) {
					 fm.first_dist.value='<%=car1.getOver_bas_km()%>';				
				//	 alert("aa" + fm.first_dist.value);
				} else {
					 fm.first_dist.value='<%=car1.getSh_km()%>';		
				//	 alert("bb" + fm.first_dist.value);
				}	
					
				fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.first_dist.value))   );	
			}
		}		
		
		fm.remark.value="매입옵션";						
		<% if  ( fuel_cnt > 0) { %>   
		 <%    if ( return_remark.equals("싼타페") ) {%>  				 	
				 	 		fm.cls_cau.value = "싼타페 연비보상 대상 차량. 매입옵션";
				 	 		fm.etc3_amt_1.value = '-400,000';
		 <%    } else if ( return_remark.equals("혼다") ) {%> 		 				
				 	 		fm.cls_cau.value = "혼다 특별보상 대상 차량. 매입옵션";
				 	 		fm.etc3_amt_1.value = '<%=return_amt %>';
				 	 		fm.etc3_amt_1.value =  parseDecimal(  toInt(parseDigit(fm.etc3_amt_1.value)) * (-1)  );	                  
								 	 				  	 	 		
	      	<% }%> 	 	 	 		
 	 	<% }  else { %> 
	 		fm.cls_cau.value="매입옵션";
	 		fm.opt_amt.value = fm.mopt_amt.value;
	 		fm.t_cal_days.value = '0';
 		<% }%> 	 
 					
		//잔여개시대여료 
		if(fm.ifee_s_amt.value != '0'){
			ifee_tm = parseDecimal((toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
		
			pay_tm =  parseDecimal(toInt(fm.con_mon.value)-ifee_tm) ;
			
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
				fm.ifee_day.value 	= fm.r_day.value;
						
			} else {
			   	 fm.ifee_mon.value = "0";  //초기화
		   		 fm.ifee_day.value  = "0";			
			}
		
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
											
			v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //경과금액
			v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //잔액
			
		    if (v_rifee_s_amt == -1 || v_rifee_s_amt == 1 ) v_rifee_s_amt = 0;  //끝전
		    
		   	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후  - 개시대여료 전체 다 공제됨
		    		
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 		    		
		    		v_rifee_s_amt = 0;		    		
		   	} 
		  
		   
		   //개시대여료 잔액이 남은 경우 매입옵션 불가 
	   //매입옵션인 경우는 틀림. 	   	 
		   	if ( fm.cls_st.value == '8') { //매입옵션 
		  		 if (	 v_rifee_s_amt > 0 ) {
		  		     alert("개시대여료 잔액이 있습니다. 수기로 진행하세요 !!!") ;
		  		     fm.cls_st.options[0].selected = true;
		  		     fm.cls_cau.value = "";		  		 		  		      		  
		  		 } else {		   	
		    	 	fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 		    		
		    		v_rifee_s_amt = 0;
		    	}			    		
		   	}
		  		   	
		   	if ( v_rifee_s_amt == 0) { //만기이후 
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 
		    		v_rifee_s_amt = 0;	  
	    	}	
		}
		
		//개시대여료가 있음에도 대여료를 별도 납부한 경우 처리 - 20100924 추가
		if(fm.ifee_s_amt.value != '0'){
			if ( toInt(fm.rent_end_dt.value) == toInt(fm.use_e_dt.value) ) {
		   		   if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 없는 경우
		   		   		fm.ifee_mon.value 	= '';
						fm.ifee_day.value 	= '';	
		   		   		fm.ifee_ex_amt.value = '0';
		   		   		fm.rifee_s_amt.value = parseDecimal(fm.ifee_s_amt.value) ; 
		   		   }
		   	} 
	    }

		//잔여선납금?
		if(fm.pp_s_amt.value != '0'){
	
			fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.lfee_mon.value) );
			fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.m_mon.value)+toInt(fm.m_day.value)/30) );
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value)) 
		}else{
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;
		}
		
		if(fm.pp_s_amt.value != '0') {
	 	 
		    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //만기일
		    		
		    		fm.pded_s_amt.value 	= 0;
				   fm.tpded_s_amt.value 	= 0;
				   fm.rfee_s_amt.value 	= 0;
		    	} 
		    	
		    	if ( fm.cls_st.value == '8') { //매입옵션 
		    		fm.pded_s_amt.value 	= 0;
				   fm.tpded_s_amt.value 	= 0;
				   fm.rfee_s_amt.value 	= 0;
		    		
		    	}	  
	      }	
		
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // 선납금액이 경과한 경우 (계약기간이 경과한 경우)
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
		
		//선납금이 남아있는 경우 수기 진행 
		if ( fm.cls_st.value == '8') { //매입옵션 
	  		 if (toInt(parseDigit(fm.rfee_s_amt.value)) > 0 ) {
	  		     alert("선납금 잔액이 있습니다. 수기로 진행하세요 !!!") ;
	  		     fm.cls_st.options[0].selected = true;
	  		     fm.cls_cau.value = "";		  		 		  		      		  
	  		 } else {		   	
	  			fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;		
	    	}			    		
	   	}
		
		//선납금액 
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
	   	    
		//미납입금액 정산 초기 셋팅		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}	 

		//개시대여료가 없는 경우 		 -- nnfee_s_amt : 미납금액(잔액아님). di_amt :잔액미납금액  	  -- 대여개시가 된 경우    
  		if(fm.ifee_s_amt.value == '0' ) {
		   	 // 스케쥴생성보다 해지일이 더 큰 경우 
		  	 		   	 
		    if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 		
		   	 	//	  alert("a");
		   	 		  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
		   	 	     		   //스케쥴자체가 없다면 
	   	 		          var s1_str;
	   	 	             if  ( toInt(fm.use_e_dt.value)  < 1 ) {
	   	 	           	  s1_str = fm.rent_end_dt.value;
	   	 	             } else {
	   	 	 		        s1_str = fm.use_e_dt.value;
		   	 		    	}
							var e1_str = fm.cls_dt.value;
							var  count1 = 0;
								
									   
							var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
							var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
					
							var diff1_date = e1_date.getTime() - s1_date.getTime();
					
							count1 = Math.floor(diff1_date/(24*60*60*1000));									
								
					  	   	if ( count1 >= 0 ) { // 대여료만기일과 정산일 비교 (실제연체일수 계산)					  	   	
					  	   		 fm.nfee_mon.value = parseInt(count1 / 30); 
					  	   		 fm.nfee_day.value  =  parseInt(count1 % 30); 					  	 
					  	   }
		   	 		 
		   	 		  }  else  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
		   	 	//	     alert("c");
		   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌
		   	 		      if ( toInt(fm.nfee_mon.value) < 0 ) {
						  	 	   	  fm.nfee_mon.value = '0';
						  }
		   	 		     
		   	 		  } 
		   	 	
		   	} //스케쥴이 있음.  		  
		
		} //개시대여료가 없는 경우	 	   		   		
		
		
		 //미납잔액이 있고 , 1개월이상 미납이 또 생긴 경우  	 	
		 if (  toInt(parseDigit(fm.di_amt.value)) > 0 && toInt(parseDigit(fm.s_mon.value)) > 1 ) {		 
			 if (  toInt(parseDigit(fm.rr_s_amt.value)) - toInt(parseDigit(fm.rc_s_amt.value))   >   toInt(parseDigit(fm.nfee_s_amt.value))  ) {	 			 
			  	       fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 		   	    	 				   	    	 						              
			   }
		 }  		
		 
		 //미납잔액이 있고 , 또 미납이 발생된 경우 
		  if (  toInt(parseDigit(fm.di_amt.value)) > 0  ) {		
		    if ( toInt(fm.s_mon.value) - 1 ==  toInt(fm.hs_mon.value)  ) {
		         fm.nfee_mon.value 	= 	 toInt(fm.hs_mon.value);  //잔액이 있는 미납월을 제외함.		     
		    } 		
		  }
		 
	   	
	  	if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) {
	   	   	    	if (  toInt(parseDigit(fm.di_amt.value)) > 0 ) {  //잔액이 있다면 
	   	   	    	   if ( toInt(parseDigit(fm.hs_mon.value)) < 1  &&  toInt(parseDigit(fm.hs_day.value)) < 1 ) {  // 잔액 스케쥴에 해지일이 포함되는 경우
	   	   	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {  //과부족이 보이면서 하단의 미납대여료도 중복으로 나오는 경우 - 20170324
	   	   	    				
	   	   	    				 	fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );  //받을금액  - 받은금액    		
					      	 	   fm.nfee_amt.value = fm.nnfee_s_amt.value;    
					      	 	   fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
									if (fm.nfee_amt.value == '0' ) {
						 	       			fm.nfee_day.value = 0;
						 	      	}
						 	 }     		
						}
						
						 if ( toInt(parseDigit(fm.hs_mon.value)) >0  &&  toInt(parseDigit(fm.hs_day.value)) > 0 ) {  // 잔액 스케쥴에 해지일이 포함되는 경우
					 			 fm.nfee_mon.value 	= 	 toInt(fm.hs_mon.value);  //잔액이 있는 미납월을 제외함.
					   	    	  
					   	    	 if  ( fm.nnfee_s_amt.value  != '0' ) {
					   	    		 	  fm.nfee_day.value 	= 	 toInt(fm.hs_day.value);  //잔액이 있는 미납월을 제외함.	
					   	    	 }						 
						 } 	       	
	   	   	    	}	   	   	
	   }  	   	 		
	    		
	    //대여료가 100이하인 경우 별도 처리 - 2011-01-24.	- 선납으로만 처리
		if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
		   if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   		fm.nfee_day.value = '0';
		   } 
			fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		} else {
			fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
	   }
	    		
	   	//마지막회차인경우(일수 계산을 한경우)는 스케쥴에 남아있는 금액으로 처리 ..		
		if (fm.ifee_s_amt.value == '0' ) {	
		   	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   	 	if ( toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value) ) {  //계약기간과 스케쥴 만기와 같으면 
				        if  ( fm.nfee_amt.value  != '0' ) {
					          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
				 	       		fm.nfee_amt.value = fm.nnfee_s_amt.value;
				 	       		if (fm.nfee_amt.value == '0' ) {
				 	       			fm.nfee_day.value = 0;
				 	       		}	
					 	       }	
					     }	 
			    	}		    	
	    	}	    	
	   } 	 		
	    				
			 // 개시대여료 있는 경우에 한함. (해지일이 대여기간을 경과한 경우에 한함 )	 
	  	if(fm.ifee_s_amt.value != '0' ) {
	 
		   	if (v_rifee_s_amt <= 0 ) {  //개시대여료를 다 소진한 경우  -개시대여료 없는 경우와 유사 
		   	      	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
			  		
			  	   if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우 			  		  	     
				        if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
			   	          //   alert(" 개시대여료 소진, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	
			   	       	   
				  		 } else {  //미납이 없는 경우  		
				  		  	  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
				  		      
				  		         var s1_str = fm.rent_end_dt.value;
								   var e1_str = fm.cls_dt.value;
								   var  count1 = 0;								
											   
									var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
									var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
							
									var diff1_date = e1_date.getTime() - s1_date.getTime();
							
									count1 = Math.floor(diff1_date/(24*60*60*1000));									
										
							  	   	if ( count1 >= 0 ) { // 대여료만기일과 정산일 비교 (실제연체일수 계산)					  	   	
							  	   		 fm.nfee_mon.value = parseInt(count1 / 30); 
							  	   		 fm.nfee_day.value  =  parseInt(count1 % 30); 					  	 
							  	   }
							  	   					  	   
							  	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 			  		 
				  		      }			  		
				  		}	
			  	  } else {  //개시대여료 소진후 스케쥴 생성 안됨.   			  	  
			  	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우   +  경과분만큼 대여료 계산 
		   		//	       alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");			   	    
				   	     	 var r_tm = 0;     
				   	     	 if  ( toInt(parseDigit(fm.di_amt.value)) > 0 &&  toInt(fm.s_mon.value) > 0 ) {						 
						   	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// 총미납료에서 - 개시대여료 공제  , 잔액이 발생되었기에 1달 빼줌 
						//   	 } else {
						  // 	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// 총미납료에서 - 개시대여료 공제   
						   	 }
				   					   				   	
						   	 fm.nfee_mon.value 	= r_tm;
						   	 fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ;	// 총미납료에서 - 개시대여료 공제   
				  	
						  	 // 해지일과 만료일이 같은 경우 - 일자계산된 경우 발생 20110524						  	 
							 if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
							     if  ( fm.nfee_amt.value  != '0' ) {
								     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
								 		fm.nfee_amt.value = fm.nnfee_s_amt.value;						 		
								 	 }	
								 }	 
							 }			   	         
			   	      }else {
			   	       //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");			   	      
			   	           if ( toInt(fm.r_mon.value) > 0 ||  toInt(fm.r_day.value) > 0 ) { 
				   	       	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
					   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
					   	      	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30)  ) ; 
				   	   		}
				   	   }
			  	  
			  	  }
			  	  
			  }  else {  //개시대여료가 남은 경우 (중도해지되는 경우 )		
				  	     
				  	     if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
				  	     	  if ( toInt(fm.use_e_dt.value) <= toInt(replaceString("-","",fm.cls_dt.value)) ) {  // 개시대여료 내에해지 
				  	     	 
					  	     	   if  ( fm.nfee_amt.value  != '0' ) {
							          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
						 	       		fm.nfee_amt.value =    fm.nnfee_s_amt.value;
						 	       		if (fm.nfee_amt.value == '0' ) {
						 	       			fm.nfee_day.value = 0;
						 	       		}	
							 	       }	
							      }	
						        			  	     	 
				  	     	 }  else { 	   
				  	            
				  	            fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// 총미납료에서 - 개시대여료 공제
				  	       }  
				  	     } 
				  	     
				  	     if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
				   	 		    // alert("d1");		   	 		
				   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌
				   	 		     	
								  if ( toInt(fm.nfee_mon.value) < 0 ) {
								  	 	   	  fm.nfee_mon.value = '0';
								  }
						  }			
								 	 
			 } 
	 	}   
	 	
	 	//마지막회차인경우(일수 계산을 한경우)는 스케쥴에 남아있는 금액으로 처리 ..
		//매입옵션인 경우는 틀림.					 	    		   
	  if ( fm.cls_st.value == '8') { //매입옵션 	
	         var count ;
	  			var s_str = fm.rent_end_dt.value;
				var e_str = fm.cls_dt.value;
				
				var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
				var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
				
				var diff_date = s_date.getTime() - e_date.getTime();
				
				count = Math.floor(diff_date/(24*60*60*1000));
				    
		//	if (fm.ifee_s_amt.value == '0' ) {	
				if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
						if ( toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value) ) {  //계약기간과 스케쥴 만기와 같으면 
			    	 
					        if  ( fm.nfee_amt.value  != '0' ) {
						          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
					 	       		fm.nfee_amt.value = fm.nnfee_s_amt.value;
					 	       		if (fm.nfee_amt.value == '0' ) {
					 	       			fm.nfee_day.value = 0;
					 	       		}	
						 	       }	
						     }	 
				    	}		    	
		    	}
					
				if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) {
				      if (toInt(fm.fee_size.value) < 2 ) {  //연장건이 아니면 
					      if  ( fm.nfee_amt.value  != '0' ) {
							     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
							 		fm.nfee_amt.value = fm.nnfee_s_amt.value;							 		
							 	 }	
				 			}	 
						} else {  //연장인 경우는 30일 이내는 만기로 처리 
							if ( count > 30 ) { 			
							
							} else {
							    if  ( fm.nfee_amt.value  != '0' ) {
								     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
								 			fm.nfee_amt.value = fm.nnfee_s_amt.value;							 		
								 	 }	
				 				}	 
							
							}
												
						}					
						  	 
				 }    				 	
				 	    		 
	//		}
				 		
		}			
	   	   	  	
		  //환불인경우 계산 -  받을돈에서 받은돈 
		 if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
		 
		          //원래 만기인경우 일자 계산되는 경우도 있음.
		        if ( toInt(fm.rent_end_dt.value)  != toInt(replaceString("-","",fm.cls_dt.value)) ) {
		                     
				      fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );
				      fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))   -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	
				      fm.nfee_mon.value = '0';
				      fm.nfee_day.value = '0';				      
				      fm.nfee_amt.value = '0';	
			    }	      		         
		 }
			
		
	 	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));   	
	   	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
	   	
	    fm.nfee_amt_1.value 		= fm.nfee_amt.value; 
	    fm.ex_di_amt_1.value 		= fm.ex_di_amt.value; 
	    fm.ex_di_v_amt_1.value 		= fm.ex_di_v_amt.value; 
	   
	  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)));
	   	
		if(fm.r_day.value != '0'){
			fm.rcon_mon.value 		= toInt(fm.con_mon.value) - toInt(fm.r_mon.value) - 1;
			fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
		}else{
			fm.rcon_mon.value = toInt(fm.con_mon.value) - toInt(fm.r_mon.value);
			fm.rcon_day.value = fm.r_day.value;			
		}	

		if(toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
		
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}	
				
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
		fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
						
			//각각 부가세 계산하여 더한다.	 		
		var no_v_amt =0;

		var c_fee_v_amt =  0;
	
	   c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt.value)) * 0.1)) ;
		
			//매입옵션인 경우는 틀림.
		if ( fm.cls_st.value == '8') { //매입옵션 
			    //위약금 0
				fm.dft_amt.value 			= '0';
				fm.dft_amt_1.value 	   = '0';				 		
	   }
		 
		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt  +   ( toInt(parseDigit(fm.over_amt.value)) * 0.1) -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
								
//		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
				
		var no_v_amt2 	 = no_v_amt;
	
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt2) );		
		
		set_tax_init();
		
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
			
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
			
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}	
									
		if ( fm.tax_chk3.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[3].value)));					 
		}	
				
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
       */
       
        //미납금액계
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)));
		
		//확정금액 보여주기
		fm.dly_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dly_amt.value))) ;
		fm.dft_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dft_amt.value)));
		fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value))); 
		fm.no_v_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)));
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) +  toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)) );	 //확정금액	
	
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
				
					
		//고객이 납입할 금액 초기 셋팅	(매입옵션금액은 표시 안함)
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
					
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
		}
		
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
						
	}
	
	//세금계산서
	function set_tax_init(){
		var fm = document.form1;
			
			//중도해지위약금
		if(toInt(parseDigit(fm.dft_amt.value)) > 0){
				fm.tax_g[0].value       = "중도해지 위약금";
				fm.tax_supply[0].value 	= fm.dft_amt.value;
				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
		}			
		
			//차량외주비용
		if(toInt(parseDigit(fm.etc_amt.value)) > 0){
				fm.tax_g[1].value       = "회수 차량외주비용";
		   		fm.tax_supply[1].value 	= fm.etc_amt.value;
				fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt.value)) * 0.1 );
	
		}
		
			//차량부대비용
		if(toInt(parseDigit(fm.etc2_amt.value)) > 0){
				fm.tax_g[2].value       = "회수 부대비용";
		   		fm.tax_supply[2].value 	= fm.etc2_amt.value;
				fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt.value)) * 0.1 );
	
		}
		
			//기타손해배상금
		if(toInt(parseDigit(fm.etc4_amt.value)) > 0){
				fm.tax_g[3].value       = "기타손해배상금";
		   		fm.tax_supply[3].value 	= fm.etc4_amt.value;
				fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt.value)) * 0.1 );
	
		}
		
			//초과운행부담금
		if(toInt(parseDigit(fm.over_amt.value)) > 0){
				fm.tax_g[4].value       = "초과운행추가대여료";
		   		fm.tax_supply[4].value 	= fm.over_amt.value;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt.value)) * 0.1 );
	
		}
	}	
//-->
</script>
</body>
</html>
