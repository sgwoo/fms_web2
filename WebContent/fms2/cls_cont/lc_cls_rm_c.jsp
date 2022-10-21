<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.credit.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.con_tax.*, acar.fee.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
		
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//출고지연대차 리스트
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//fee 기타 - 주행거리 초과분 계산
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
	 // 매입옵션시:  agree_dist_yn  1:전액면제,  2:50% 납무,  3:100%납부
	 
	  int  o_amt =   car1.getOver_run_amt();
	  
//	 out.println(o_p_m);
//	 out.println(fee_size);
		
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
	Hashtable base1 = as_db.getSettleBaseRm(rent_mng_id, rent_l_cd, "", "");
	
	    	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//연대보증인 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
		
	
	int pp_amt = AddUtil.parseInt((String)base1.get("PP_S_AMT"));
	
		//면책금 기청구된 건중 매출처리 여부 구분
	int car_ja_no_amt =  ac_db.getCarServiceBillNo(rent_mng_id, rent_l_cd);
		
	Vector cms_bnk = c_db.getCmsBank();	//은행명을 가져온다.
	int cms_bnk_size1 = cms_bnk.size();
	
	//cms 정보
	Hashtable h_cms = c_db.getCmsBank_info(rent_l_cd);
	
	//card  cms 정보 
	Hashtable h1_cms = c_db.getCardCms_info(rent_l_cd);
	
	String re_bank = "";
	String re_acc_no = "";
	String re_acc_nm = "";
		
	re_bank = (String)h_cms.get("CBNK");
	re_acc_no = (String) h_cms.get("CBNO");
	re_acc_nm = (String) h_cms.get("CYJ");
	
	if ( h1_cms.get("CBNO")  == null  ) 	{
	} else{ 
		re_acc_no = (String) h1_cms.get("CBNO");
		re_acc_nm = (String) h1_cms.get("CYJ");
	}
	
	//기존에 등록되었는지 여부
	int reg_cnt = 0;
	reg_cnt= ac_db.getClsEtcCnt(rent_mng_id, rent_l_cd);
		
		
	//해지정산 리스트
	Vector vt_ext = as_db.getClsList(base.getClient_id());
	int vt_size = vt_ext.size();
					
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
	int tot_months = AddUtil.parseInt((String)base1.get("R_MON"));  
	int tot_days = AddUtil.parseInt((String)base1.get("R_DAY"));  			
								
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
	
//	out.println(day_cnt);
//	out.println(tot_days);
//	out.println(r_day_per);
      		
	if(tot_months == 0  ){		
	    if ( day_cnt >  tot_days ) {	
			add_amt_d = (new Double(AddUtil.parseInt((String)base1.get("FEE_S_AMT"))	)).intValue() * r_day_per / 100;
		}	

	}else if(tot_months > 0){				

	}
	
	 CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;           
	
	String a120_days = c_db.addDay(AddUtil.getDate(4) , 120) ; // 4 개월후 
		
		//카드 cms 이체인 경우 - 나이스를 통해서 데이타를 처리한 경우  또는 1회차인경우 
	Vector vt_card = ac_db.getCardCancel(rent_l_cd);
	int vt_c_size = vt_card.size();	
	
 //  int amt_2_over =  ac_db.getCardCancelAmt(rent_l_cd);  //card cms 고객이 아니면서 연장사용한 고객 check
 //   int amt_2_cnt =  ac_db.getCardCancelCnt(rent_l_cd);  //card cms 고객이 아니면서 연장사용한 고객 check
	
 // 월렌트 현금입금인 경우 환불관련처리 - 20200911 최근 2개월전 내역으로 
	String ip_chk = "";
 
 	Vector vt_ip = ac_db.getIpMethod(rent_l_cd);  
 	int vt_ip_size = vt_ip.size();
 	
	if ( vt_ip_size > 0) {
	 	for(int i = 0 ; i < 1 ; i++)
		{
			Hashtable ht_ip = (Hashtable) vt_ip.elementAt(i);	 
			
			if ( String.valueOf(ht_ip.get("IP_METHOD")).equals("1") ) {   //현금으로 결재했다면 
				ip_chk = "1";
			}			
		}	
 	}
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
	
	//입력오류에 의한 삭제 - 거래처가 없고, 대여개시일이 없고 금액도 없고... 등등
	function save1(){
		var fm = document.form1;
			
		if(fm.rent_start_dt.value != '')			{ alert('대여개시건입니다.'); 		fm.cls_dt.focus(); 		return;	}
												
		if(confirm('데이타 정리하시겠습니까?')){	
			fm.action='lc_cont_mon_rm_a.jsp';	
			fm.target='ii_no';
			fm.target='d_content';
			fm.submit();
		}		

	}
		
	function save(){
		var fm = document.form1;
		
		//alert만 
		if ( toInt(replaceString("-","",fm.car_end_dt.value))  < toInt(replaceString("-","",fm.car_120_dt.value))  ) {
		   if ( '<%=cr_bean.getCar_end_yn()%>'  == 'Y'  ) { 
    		  alert('차령만료일이 4개월미만입니다.  예비차적용을 매각으로 처리하세요.'); 
    		}	  
    	 }
    	 
       if (  toInt(parseDigit(fm.tot_dist.value))  > 200000  ) { 
    		  alert('주행거리가 20만km이상입니다.  예비차적용을 매각으로 처리하세요.'); 
    	}	  
    		
   
		if(fm.cls_st.value == '')				{ alert('해지구분을 선택하십시오'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('해지일자를 입력하십시오'); 		fm.cls_dt.focus(); 		return;	}
	
		if( toInt(parseDigit(fm.reg_cnt.value)) > 0 ) { 	 alert('이미 등록된 건입니다. 확인하십시요!!'); 	fm.cls_st.focus(); 		return;	}	
	
		if ( fm.rent_start_dt.value != ''    ) {		
						
	//	if ( fm.cls_st.value == '14' ) {			
			//차량회수 여부 및 회수일자, 입고일자 등 check
			if(fm.reco_st[0].checked == true){  //회수 선택시 - 회수형태 및 회수일, 입고일 check
				  if(fm.reco_d1_st.value == "") {
				 		alert("회수구분을 선택하셔야 합니다.!!");
						return;
				  }	
				  
				 if(fm.reco_dt.value == '')				{ alert('회수일자를 입력하십시오'); 		fm.reco_dt.focus(); 	return;	}
				 if(fm.ip_dt.value == '')				{ alert('입고일자를 입력하십시오'); 		fm.ip_dt.focus(); 		return;	}
				
				 var s1_str = fm.reco_dt.value;
				 var s2_str = fm.ip_dt.value;
				 var e1_str = fm.cls_dt.value;
				 var  count1 = 0;	
				 var  count2 = 0;			
							   
				 var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(5,7) -1, s1_str.substring(8,10) );
				 var s2_date =  new Date (s2_str.substring(0,4), s2_str.substring(5,7) -1, s2_str.substring(8,10) );
				 var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
			
				 var diff1_date = e1_date.getTime() - s1_date.getTime();
				
				count1 = Math.floor(diff1_date/(24*60*60*1000));									
						
			  	if ( count1 >= 7 ) { // 대여료만기일과 정산일 비교 (실제연체일수 계산)					  	   	
			  		alert("해지일자와 회수일자가 1주일 이상 차이납니다. 회수일자를 확인하세요.!!");			  	 
			  	}
			  	
				var diff2_date = e1_date.getTime() - s2_date.getTime();
				count2 = Math.floor(diff2_date/(24*60*60*1000));	
				
			 	if ( count2 >= 7 ) { // 대여료만기일과 정산일 비교 (실제연체일수 계산)		
				 	alert("해지일자와 입고일자가 1주일 이상 차이납니다. 입고일자를 확인하세요.!!");
				}
								
				 if( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ){
					if(fm.est_dt.value == '')				{ alert('약정일자를 입력하십시오'); 		fm.est_dt.focus(); 		return;	}		
				 }
					
				 if( toInt(parseDigit(fm.tot_dist.value)) < 1 ) { 	 alert('주행거리를 입력하십시오'); 		fm.tot_dist.focus(); 		return;	}		
				 
				 if(fm.serv_gubun[0].checked == false && fm.serv_gubun[1].checked == false && fm.serv_gubun[2].checked == false ){
						alert("예비차 적용를 선택하셔야 합니다.!!");
						return;
				}		
				
		
			} else {
			  if(fm.reco_d2_st.value == "") {
			 		alert("미회수구분을 선택하셔야 합니다.!!");
					return;
			  }		
			}	
				
			if(fm.serv_st[0].checked == false && fm.serv_st[1].checked == false ){
				alert("예비차 사용가능을 선택하셔야 합니다.!!");
				return;
			}	
			 
			//수리후 가능이면 목동일수 없음.
			if (fm.serv_st[1].checked == true && fm.park.value == "1"  ){
				alert("수리후 가능은 차량현위치가 영남주차장일수 없습니다..!!");
				return;
			}	
			
				
		}
			
		//해지사유
		if( replaceString(' ', '',fm.cls_cau.value) == '' ){
				alert("해지사유를 입력하셔야 합니다.!!");
				return;
		}	
		
		if( get_length(Space_All(fm.cls_cau.value)) == 0 ) {
		 		alert("해지사유를 입력하셔야 합니다.!!");
				return;
		}	
	
		//해지사유
		if( replaceString(' ', '',fm.park.value) == '' ){
				alert("차량현위치를  입력하셔야 합니다.!!");
				return;
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
		}	*/
		
		
		// 통합발행	
		if ( fm.tax_reg_gu[1].checked == true ) {
		
			if ( toInt(parseDigit(fm.rifee_s_amt.value))  > 0 ) {
				alert("개시대여료잔액이 있습니다. 항목합산청구의뢰를 할 수 없습니다..!!");
				return;
		 	}
		 	
		 	if ( toInt(parseDigit(fm.rfee_s_amt.value))  > 0 ) {
				alert("선납금잔액이 있습니다. 항목합산청구의뢰를 할 수 없습니다..!!");
				return;
		 	}		
		}
		
				
		// 환불금액 발생시 통장번호 check
		if ( toInt(parseDigit(fm.fdft_amt2.value))  < 0 ) {
		  
		    if ( fm.re_acc_no.value  == 'null'  ) { 
				alert("환불계좌번호를 정확하게 입력하세요..!!");
				return;
		    }	
		    
		    if ( fm.re_acc_nm.value  == 'null') { 
				alert("환불 예금주명을 입력하세요..!!");
				return;
		    }					
		}		
		 			
			//카드 cms 취소처리위해 - 환불건은 최소승인취소후 재승인요청으로 처리해야 함 
	   var len=fm.elements.length;
		var cnt=0;		
		var clen=0;
		var idnum="";
		var id="";
				
				
		//환불건이고 카드 cms 등록 계좌인 경우 		
		if (  toInt(parseDigit(fm.fdft_amt2.value))  < 0   ) {
		
		 	if ( <%=vt_c_size %> > 0  &&  fm.ip_chk.value == '' ) {	
		 				 	   		 	    
				for(var i=0 ; i<len ; i++){
					var ck=fm.elements[i];		
					if(ck.name == "t_card"){		
						if(ck.checked == true){
							cnt++;					
							idnum=ck.value;
						}
					}	
				}					
			
				if(cnt == 0){
				 	alert("취소처리할 카드를 선택하세요.");
					return;
				}	
			
				if(cnt >1){
				 	alert("1건이상 선택할 수 없습니다. !!!");
					return;
				}
				
				//재설정 
			   if (  toInt(parseDigit(fm.h5_amt.value)) > 0 &&   toInt(parseDigit(fm.h7_amt.value))  > 0    ) {
				    fm.jung_st.value = '3'; 
				}
							
		   }	//취소할 카드금액 , 재결재할 금액 체크 
		   
			if (  fm.ip_chk.value == '1' ) {		
				alert(" 환불계좌를 받으세요!!!!! ");		 			
			}
		} 						
			
			
		//재설정  - 20171130
	   if (  toInt(parseDigit(fm.h5_amt.value)) > 0 &&   toInt(parseDigit(fm.h7_amt.value))  > 0    ) {
	         if  ( fm.jung_st.value != "3" ) {
	                fm.jung_st.value = "3"; 
	         }
				  
		}
									
					
		//cms이면서 미납금액이 있는 경우 	
		if ( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ) {		
		    if ( fm.re_acc_no.value   == 'null' ||  fm.re_acc_no.value   == ''  ) { 
		  } else {	   
		     if ( fm.cms_chk.checked == false ) {		   		  	
		   	  	   	alert("CMS인출미의뢰로 진행됩니다. 확인후 다시 진행해주세요.!!!.");
	        }  
	     }   
		}
										
										
		if(confirm('등록하시겠습니까?')){	
			fm.action='lc_cls_rm_c_a.jsp';	
//			fm.target='ii_no';
			fm.target='d_content';
			fm.submit();
		}		

	}
	
	//디스플레이 타입
	function cls_display(){
		var fm = document.form1;
	
	
		tr_ret.style.display		= '';	//차량회수		
		
		tr_refund.style.display		= 'none';	//환불정보
		tr_scd_ext.style.display	= 'none';	//환불정보
						
		//tot_dist 초기화 
		fm.tot_dist.value = "0";
															
		set_init();
		 
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
		
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'N'){
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
					
		//tot_dist 초기화 
		fm.tot_dist.value = "0";
		
		fm.action='./lc_cls_rm_c_nodisplay.jsp';						
			
		fm.target='i_no';		
	//	fm.target='_blank';
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
	 	 
	    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //만기일
	    		
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
		var no_v_amt1 = 0;
	
		var c_fee_v_amt =  0;
		var c_fee_v_amt1 =  0;
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt.value)) * 0.1)) ;
		c_fee_v_amt1 = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		
		// 부가세 맞추기 - 20190904 - 잔액이 아닌 미납금액이 같다면 (한회차인 경우)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
		 	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));	
		 	c_fee_v_amt1  = toInt(parseDigit(fm.nnfee_v_amt.value));		 		   
 	    }	
			 	   
		//각각 부가세 계산하여 더한다.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt  -  (toInt(parseDigit(fm.rfee_s_amt.value)) *0.1) -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 + ( toInt(parseDigit(fm.over_amt_1.value)) *0.1) - (toInt(parseDigit(fm.rfee_s_amt.value)) *0.1) -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //개시대여료 
	    fm.rfee_v_amt.value =  parseDecimal(  toInt(parseDigit(fm.rfee_s_amt.value)) *0.1 );    //선납금 
	    
	    fm.dfee_v_amt.value =  parseDecimal(  toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );  //당초 대여료 부가세 	    
	    fm.dfee_v_amt_1.value = parseDecimal(  toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 ); //확정 대여료 부가세 
		    
	    fm.over_v_amt.value =  '0';  //당초 초과운행 부가세  (0으로 처리 )
	    fm.over_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) *0.1 );  //확정 초과운행 부가세 
							
		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		

		
		/*  2022-04 사용안함 
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
				 
		}	*/
		
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 
		}	*/
		
		
	//	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
	
		set_cls_s_amt();
	}	
	
			
	//미납 중도해지위약금 정산 : 자동계산
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		
	    if ( toInt(parseDigit(fm.add_amt_d.value))  < 1 )	{
			if(obj == fm.rcon_mon || obj == fm.rcon_day){ //잔여대여계약기간
				if(fm.mfee_amt.value != '0'){		
					fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
					fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int_1.value)/100) );
				//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
				//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
				}
			}else if(obj == fm.dft_int_1){ //위약금 적용요율
				if(fm.trfee_amt.value != '0'){		
					fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int_1.value)/100) );
				//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
				//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
				}			
			}
	    }
	    
	//	fm.d_amt.value 						= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	//	fm.d_amt_1.value 					= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));	
		
		set_cls_s_amt();
	}		
	

						
	//확정금액 셋팅
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		
		/* 2022-04  사용안함 
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
			
		}else 
		*/	
		if(obj == fm.m_over_amt){ //초과운행부담금 감액		 
    		fm.j_over_amt.value =  toInt(parseDigit(fm.r_over_amt.value)) - toInt(parseDigit(obj.value)) ;  
			
			if (  toInt(parseDigit(fm.j_over_amt.value)) > 0) {
    		
				fm.over_amt.value =  '0';  
				fm.over_amt_1.value =  fm.j_over_amt.value ;  
			
				fm.tax_supply[4].value 	=  fm.j_over_amt.value;
					
				fm.tax_chk4.value  = 'Y' ;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );
				fm.over_v_amt.value 	= '0';	 
				fm.over_v_amt_1.value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );	 
		  } else {
		  		fm.over_amt.value =  '0';  
				fm.over_amt_1.value =  '0' ;  
				fm.tax_supply[4].value 	=  '0';
			    fm.tax_chk4.value  = 'N' ;
				fm.tax_value[4].value 	= '0';
				fm.over_v_amt.value 	= '0';		 
				fm.over_v_amt_1.value 	= '0';	
		  }	
				
		}	
								
		var no_v_amt = 0;
			//각각 부가세 계산하여 더한다.	 
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)    -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //개시대여료 
		fm.rfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) *0.1 );    //선납금 
		    
		fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + (toInt(parseDigit(fm.nfee_amt.value)) * 0.1) );  //당초 대여료 부가세 
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) );  //확정 대여료 부가세 
		    
		fm.over_v_amt.value =  '0';  //당초 초과운행 부가세 
		fm.over_v_amt_1.value =  parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );  //확정 초과운행 부가세 
									
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt) );		
		
		/* 2022-04 사용안함 
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
		}*/
		
		/*	
		if ( fm.tax_chk4.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));			  
		}		
		*/
		
		set_cls_s_amt();		
	
	}	
		
	//확정금액 셋팅
	function set_cls_s_amt(){
		var fm = document.form1;	
					
	//	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	//  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
	  	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))   + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)));	 //확정금액	
				
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );
			
			//돌려줄 금액이 있다면
		if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
			 tr_refund.style.display		= '';	//환불정보
			 tr_scd_ext.style.display		= '';	//잔존해지정산금
			 if ( <%=vt_c_size%> > 0) {
				 	 tr_card.style.display		= '';	//카드정산 
				 	 set_card_amt();
				 //	 fm.h5_amt.value 			= parseDecimal( toInt(parseDigit(fm.t_amount.value )) );  //카드 재결재금액  
				  	 fm.h7_amt.value 			= parseDecimal( toInt(parseDigit(fm.h5_amt.value)) + toInt(parseDigit(fm.fdft_amt2.value)) );  //카드 재결재금액 
				  	 fm.jung_st.value = '3';
			 } 	 
			  	 
		} else {
			 tr_refund.style.display		= 'none';	//환불정보
			 tr_scd_ext.style.display		= 'none';	//잔존해지정산금
		  	 tr_card.style.display		= 'none';	// 카드정산
		  	 fm.h5_amt.value =0;
		  	 fm.h7_amt.value =0;
		  	 fm.jung_st.value = '1';		  
		}	
		
	}	
		

	//차량회수비용
	function set_etc_amt(){
		var fm = document.form1;
		
		fm.etc_out_amt.value 		= parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)) + toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		fm.etc_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
	
		fm.etc_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));			
		
		/* 2022-04 사용안함 
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
		*/
			
		set_cls_s_amt();		
							
	}	
	
	
	//세금계산서 check 관련 부가세 - 고객납입액에 부가세 만큼 더한다(대여료, 면책금은 예외 (이미 더해졌음)) - 세금계산서 발행되면 외상매출금계정 
	function set_vat_amt(obj){
		var fm = document.form1;
			
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
		/* 2022-04 사용안함 
		if(obj == fm.tax_chk0){ // 위약금
		 
		 	if (obj.checked == true) {
		 			fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
		 			fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		 			fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[0].value)));		
			} else {
					fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
					fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[0].value)));		
			}	
	
		} else if(obj == fm.tax_chk1){ // 외주비용
			 if (obj.checked == true) {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[1].value)));
			 } else {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[1].value)));
			 }	
			 
		} else if(obj == fm.tax_chk2){ // 부대비용
			 if (obj.checked == true) {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[2].value)));
			 } else {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[2].value)));
			 }	
			 
		} else if(obj == fm.tax_chk3){ // 기타손해배상금
			 if (obj.checked == true) {
			 		fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[3].value)));
			 } else {
			 		fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );		
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[3].value)));
			 }	*/
			 
	/*		 
		} else if(obj == fm.tax_chk4){ // 초과운행 부담금 
			 if (obj.checked == true) {
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));
			 } else {
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );		
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[4].value)));
			 }		 
			
			 
		}  */
			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
				
	}
	
			
	// cms 정보와 동일 - 환불금액이 있는 경우 
	function set_cms_value(obj){
		var fm = document.form1;

		if(obj == fm.re_cms_chk){ // 위약금
		 	if (obj.checked == true) {
		 	
		 	   <% if ( h_cms.get("CBNO")  == null  ) 	{ %>
		 		   	fm.re_bank.value 		=  "";	
					fm.re_acc_no.value 		=  "";
					fm.re_acc_nm.value 		=  "";		
		 	   <% } else { %>
		 	     	fm.re_bank.value 		= '<%=re_bank%>';	
		 			fm.re_acc_no.value 		= '<%=re_acc_no%>';	
				 	fm.re_acc_nm.value 		= '<%=re_acc_nm%>';	
				 <% } 	%>					 	
			} else {
					fm.re_bank.value 		=  "";	
					fm.re_acc_no.value 		=  "";
					fm.re_acc_nm.value 		=  "";		
		   }	
		}						
	}

    //특이사항  보기
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
	
		//초과운행주행거리
	function set_over_amt(){
		var fm = document.form1;
		
		var cal_rent_days = 0;
		var cal_dist  = 0;
		
		//초기화 
		fm.m_reason.value 	=     "";	
		fm.m_over_amt.value 	=     "0";	
		fm.r_over_amt.value 	=     "0";	
		fm.j_over_amt.value 	=     "0";	
		fm.m_saction_id.value= "";
		fm.over_amt.value 	=     "0";	
		fm.over_amt_1.value 	=     "0";	
		fm.over_v_amt.value 	=     "0";	
		fm.over_v_amt_1.value 	=     "0";	
		
		if ( fm.rent_start_dt.value =="" ) {
		} else {
			if (  <%=base.getRent_dt()%>  > 20130604      ) {
				  if (  toInt(parseDigit(fm.sh_km.value)) > 0 ) {  //주행거리가 입력이 된 경우??? 	
						  
				    // 월렌트는 1달은 30일로 - 20191017	               
						cal_rent_days = toInt(fm.r_mon.value) * 30  + toInt(fm.r_day.value);				  			 
						fm.rent_days.value 		=     parseDecimal( cal_rent_days );	
					
				//     	cal_dist =   	toInt(fm.agree_dist.value) * toInt(fm.rent_days.value) / 30;
				     	cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 30;
				     		
				     	fm.cal_dist.value 		=     parseDecimal( cal_dist   );	
				
				//	fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
						
						fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
						fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
						fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );
								
						fm.add_dist.value 		=     parseDecimal( 0 );  //써비스마일리지
						
						fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
						      
								         
					   if ( 	toInt(parseDigit(fm.jung_dist.value))   > 0 ) {
								fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );								
								fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );								
								fm.tax_supply[4].value 	=  fm.j_over_amt.value;																
								fm.tax_chk4.value  = 'Y' ;
								fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );		
							
								    
					 	} else {
					 		fm.r_over_amt.value 	=      "0";						
							fm.j_over_amt.value 	=     "0";	
							fm.tax_supply[4].value 	=  '0';					 
							fm.tax_value[4].value 	= '0';		
							fm.tax_chk4.value  = 'N' ;	
						
					 	}					 			 	
				         		
				  }
			}
		}	
		
		fm.over_amt.value 		    = '0';
		fm.over_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)));	
		
		var no_v_amt = 0;
		var no_v_amt1 = 0;
		
		//각각 부가세 계산하여 더한다.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)    -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //개시대여료 
		fm.rfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) *0.1 );    //선납금 
		    
		fm.dfee_v_amt.value   =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + (toInt(parseDigit(fm.nfee_amt.value)) * 0.1) );  //당초 대여료 부가세 
		fm.dfee_v_amt_1.value =	 parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) +( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) );  //확정 대여료 부가세 
		    
		fm.over_v_amt.value =  '0';  //당초 초과운행 부가세 
		fm.over_v_amt_1.value = parseDecimal(  toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );  //확정 초과운행 부가세 	
		
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
		
		/* 2022-04-20 사용안함
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
		}	*/
		/*	
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
			*/
			
		set_cls_s_amt();
				
	}	
		
	function set_card_amt(){
		var fm = document.form1;
	
		var scd_size 	= toInt(fm.scd_size.value);		
		var t_p_amt = 0;
	   var r_date = "";
	   
	   var len=fm.elements.length;
		var cnt=0;		
		var clen=0;
		var idnum="";
		var id="";
					
		if ( <%=vt_c_size %> > 0  &&  fm.ip_chk.value == '' ) {	
		 					
			for(var i=0 ; i<len ; i++){
				var ck=fm.elements[i];		
				if(ck.name == "t_card"){		
					if(ck.checked == true){
						cnt++;					
						idnum=ck.value;
					}
				}	
			}			   
	  	  	
			if(cnt == 0){
			 	alert("취소처리할 카드를 선택하세요.");
				return;
			}	
		
			if(cnt >1){
			 	alert("1건이상 선택할 수 없습니다. !!!");
				return;
			}	
			   	   
		  	if ( scd_size < 2  ) {
				    if ( scd_size == 0 ) {			    
				    } else { 
					       if ( fm.t_card.checked == true) {
					    		t_p_amt =   t_p_amt + toInt(parseDigit(fm.t_c_amt.value));				
					    		r_date 	= 	 fm.t_card.value 	;   	
						  	 }  	 
					}    
			} else {
					for(var i = 0 ; i < scd_size ; i ++){			    
					     if ( fm.t_card[i].checked == true) {
								t_p_amt =   t_p_amt + toInt(parseDigit(fm.t_c_amt[i].value));		
					  			r_date 	= 	 fm.t_card[i].value 	 ; 
						 }
					}
			}	
							
			fm.r_date.value =  r_date;							
			fm.h5_amt.value  = parseDecimal ( t_p_amt )  ;
			fm.h7_amt.value  = parseDecimal ( t_p_amt +  toInt(parseDigit(fm.fdft_amt2.value)))  ;
		}	
				
	}	
	
	function view_car_service(car_id){
	  var fm = document.form1;
		window.open("/acar/secondhand_hp/service_history.jsp?c_id="+fm.car_mng_id.value+"&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, resizable=yes, scrollbars=yes, status=yes");		
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

<input type='hidden' name='car_gu' 	value='<%=base.getCar_gu()%>'>
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
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FEE_S_AMT")))%>'> <!-- 월대여료-->
<input type='hidden' name='pp_s_amt' value='<%=base1.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base1.get("IFEE_S_AMT")%>'>
<input type='hidden' name='fee_s_amt' value='<%=base1.get("FEE_S_AMT")%>'>
  
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 

<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'>   <!-- 연체중 가장 작은날짜 -->
 
<input type='hidden' name='cls_s_amt'  value=''>
<input type='hidden' name='cls_v_amt'  value='' >
<input type='hidden' name='car_ja_no_amt' value='<%=car_ja_no_amt%>' >

<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'> <!--스케쥴의 연체월대여료 -->
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_V_AMT")))%>'>
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_AMT")))%>'> <!--스케쥴의 연체월대여료 -잔액 -->
<input type='hidden' name='s_mon' value='<%=base1.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base1.get("S_DAY")%>'> 

<input type='hidden' name='hs_mon' value='<%=base1.get("HS_MON")%>'>  <!-- 잔액제외한 미납일자 -->
<input type='hidden' name='hs_day' value='<%=base1.get("HS_DAY")%>'> <!-- 잔액제외한 미납일자 -->

<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_S_AMT")))%>'> <!--스케쥴의 선납대여료 -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'>  

<input type='hidden' name='reg_cnt' value='<%=reg_cnt%>'> <!-- 기등록여부 -->
<input type='hidden' name='cms_yn' value='<%=re_bank%>'>  
 
<input type='hidden' name='lfee_mon' value='<%=base1.get("LFEE_MON")%>'> <!--대여개월수 -->

 <input type='hidden' name='add_amt_d' value='<%=add_amt_d%>' >  <!--실이용기간에 따른 정산금액 (1개월 미만 사용인 경우) -->
 <input type='hidden' name='day_cnt' value='<%=day_cnt%>' >  <!--실이용기간에 따른  이용일수 기준표 값 구하기 -->
 
  
  <!--초과운행 거리 계산 -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='over_run_day' value='<%=car1.getOver_run_day()%>'>
  
<input type='hidden' name='sh_km' value='<%=car1.getSh_km()%>'>

<input type='hidden' name='rc_s_amt' value='<%=base1.get("RC_S_AMT")%>'> <!--받은 금액 --> 
<input type='hidden' name='rc_v_amt' value='<%=base1.get("RC_V_AMT")%>'> <!-- 받은 금액 --> 
<input type='hidden' name='rr_s_amt' value='<%=base1.get("RR_S_AMT")%>'> <!-- 받을 금액 --> 
<input type='hidden' name='rr_v_amt' value='<%=base1.get("RR_V_AMT")%>'> <!-- 받을 금액 -->
<input type='hidden' name='rr_amt' value='<%=base1.get("RR_AMT")%>'> <!-- 받을 금액 --> 

<input type='hidden' name='cons_s_amt' value='<%=f_fee_rm.getCons1_s_amt() + f_fee_rm.getCons2_s_amt()%>'> <!-- 배반차료  -->
<input type='hidden' name='cons_v_amt' value='<%=f_fee_rm.getCons1_v_amt() + f_fee_rm.getCons2_v_amt()%>'> <!-- 배반차료  -->

<input type='hidden' name='car_end_dt' value='<%=cr_bean.getCar_end_dt()%>'>
<input type='hidden' name='car_120_dt' value='<%=a120_days%>'>

<input type='hidden' name='scd_size' value='<%=vt_c_size%>'>
<input type='hidden' name='ip_chk' value='<%=ip_chk%>'>
 
<input type='hidden' name='rifee_v_amt' value=''> <!-- 부가세 관련  -->
<input type='hidden' name='rfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt_1' value=''>
<input type='hidden' name='over_v_amt' value=''>
<input type='hidden' name='over_v_amt_1' value=''>
 
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
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("4")){%>월렌트<%} %></td>
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
            <td style="font-size : 9pt;" width="6%" class=title rowspan="2">이용기간</td>
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
				
				s_opt_per = fees.getOpt_per();
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
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
            <td style="font-size : 9pt;" align="center"><%=fees.getOpt_per()%></td>
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
                		    <option value="14">월렌트해지</option>                            
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
		       <input type='text' name='r_mon' class='text' size='2' readonly  value='<%=base1.get("R_MON")%>' >개월&nbsp;
		      <input type='text' name='r_day' size='2' class='text' value='<%= base1.get("R_DAY")%>' onBlur='javascript:set_cls_amt1(this);'>일&nbsp;</td>
         
            </td>
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
                <option value="N">매출유지</option>
                <option value="Y" selected>매출취소</option>
              </select>
		    </td>
		    <td  class=title width=10%>지점장결재자</td>
            <td  width=12%>&nbsp;
				  <select name='sb_saction_id'>
	                <option value="">--선택--</option>
	                <option value="000052">박영규</option>
	                <option value="000053">제인학</option>	       
	                <option value="000054">윤영탁</option>
	                <option value="000118">이수재</option>
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
		            <td  colspan=6  align=left>&nbsp;※ 중도해지 및 만기시 차량주행거리 </td>
		     </tr>                
        </table>
      </td>
    </tr>
  
    <tr>
      <td>&nbsp;</td>
    </tr>
    
    
  	<tr id=tr_ret style="display:''"> 
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
		        		   <td class=title>차량현위치</td>
	                    <td colspan=5> 
	                      &nbsp;<SELECT NAME="park" >
	                        <%if(good_size > 0){ 			
	                   			   for(int i = 0 ; i < good_size ; i++){
                  								CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' ><%= good.getNm()%></option>		                 
                   		   <%	}                      
								  } %>           		
	        		        </SELECT>
						<input type="text" name="park_cont" value="" size="40" class=text style='IME-MODE: active'>
						   (기타선택시 내용)
	                    </td>
	                </tr>  
	                
	                
		     			 <tr>	         
		                  <td class=title>예비차 사용가능</td>
	                      <td> &nbsp;<input type="radio" name="serv_st" value="Y" >즉시가능
	                            <input type="radio" name="serv_st" value="N"  >수리후 가능</td>	            
	                      <td class=title>예비차 적용</td>
	                      <td colspan=3> &nbsp;<input type="radio" name="serv_gubun" value="1" >재리스/월렌트
	                            &nbsp;<input type="radio" name="serv_gubun" value="3"  >월렌트
	                            &nbsp;<input type="radio" name="serv_gubun" value="2"  >매각 </td>	              
	                                 
		 	  			</tr>
		 	  	                 
		    			<tr>      
			            <td width='10%' class='title'>외주비용</td>
			            <td>&nbsp;
						   <input type='text' name='etc_d1_amt' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> 원</td>
			            </td>
			            <td width='10%' class='title'>부대비용</td>
			            <td>&nbsp;
						   <input type='text' name='etc2_d1_amt' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> 원</td>
			            </td>
			            <td width='10%' class='title'>비용계</td>
			            <td>&nbsp;
						 <input type='text' name='etc_out_amt' size='12' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
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
		                    <input type='text' name='grt_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    원</td>
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
		                    <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    원</td>
		                  <td>=개시대여료×경과기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 개시대여료(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    원</td>
		                  <td class='title'>=개시대여료-경과금액</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">선<br>
		                    납<br>
		                    금</td>
		                  <td align='center'>월공제액 </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    원</td>
		                  <td>=선납금÷계약기간</td>
		                </tr>
		                <tr> 
		                  <td align='center'>선납금 공제총액 </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    원</td>
		                  <td>=월공제액×실이용기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 선납금(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    원</td>
		                  <td class='title'>=선납금-선납금 공제총액</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">계</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
		                    원</td>
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
              <td class="title" width='38%' colspan=2> 채권</td>                
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
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>' size='15' class='num' >
               원</td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>'  size='15' class='num'  > 
               원</td>
              <td class="title"><font color="#66CCFF"><%=base1.get("FINE_CNT")%>건</font></td>
             </tr>
             <tr> 
              <td class="title" colspan="3">자기차량손해면책금(E)</td>
              <td width='19%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>' size='15' class='num' >
                원</td>
              <td width='19%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>'  size='15' class='num'  > 
                원</td>                   
              <td width='40%' class="title"><font color="#66CCFF"><%=base1.get("SERV_CNT")%>건</font></td>
            </tr>
            <tr>
              <td class="title" rowspan="4" width="4%"><br>
                대<br>
                여<br>
                료</td>
              <td align="center" colspan="2" class="title">과부족</td>   
               <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
                <input type='text' name='ex_di_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' >
                원</td>
              <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td>              
            
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
                <input type='text' size='15' name='nfee_amt'  readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' > 원</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td>  
              <td>기발행계산서의 유지 또는 취소여부를 확인</td>
            </tr>
         
            <tr> 
              <td class="title" colspan="2">소계(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt' value='' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                원</td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                원</td>  
              <td class='title'>&nbsp;=과부족 + 미납입</td>
   	        </tr>                    
            <input type='hidden' size='15' name='d_amt' value='' readonly class='num' >
            <input type='hidden' size='15' name='d_amt_1' readonly value='' class='num' >  
            
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
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base1.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                원</td>
              <td>=선납금+월대여료총액</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">월대여료(환산)</td>
              <td class='' colspan=2 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                원</td>
              <td>=대여료총액÷계약기간</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">잔여대여계약기간</td>
              <td class=''  colspan=2  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=AddUtil.parseInt((String)base1.get("N_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                개월&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day'  size='3' value='<%=AddUtil.parseInt((String)base1.get("N_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                일</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">잔여기간 대여료 총액</td>
              <td class=''  colspan=2 align="center"> 
                <input type='text' name='trfee_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                원</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> 위약금 
                적용요율</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int' readonly value='<%=base1.get("CLS_R_PER")%>' size='5' class='num'  maxlength='4'>
                %</td>
                <td class=''  align="center"> 
                <input type='text' name='dft_int_1' value='<%=base1.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                %</td>
           
              <td>*위약금 적용요율은 계약서를 확인 <!--<br><font color=red>*</font>해지위약금 차액이 발생시 영업효율대상자를 반드시 선택--></td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">중도해지위약금(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='' >
                원</td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' size='15' class='num' value='' onBlur='javascript:set_cls_amt(this)'>
                원</td>
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                <td class="title">
                <input type='hidden' name='tax_chk0' value='N' onClick="javascript:set_vat_amt(this);"><!--계산서발행의뢰-->
                <!--
                &nbsp;<font color="#FF0000">*</font>영업효율대상자: 
                      <select name='dft_cost_id'>
		                <option value="">선택</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>
	    -->	              
                </td>
 
            </tr>      
       
            <tr> 
              <td class="title" rowspan="6"><br>
                기<br>
                타</td>               
              <td colspan="2" align="center" class="title">연체료(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' > 원</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td>
             
              <td class='title'>&nbsp;</td>
            </tr>
            <tr>
              <td class="title" colspan="2">차량회수외주비용(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                원</td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                원</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;<input type='hidden' name='tax_chk1' value='N' ></td>
            </tr>
            <tr> 
              <td class="title" colspan="2">차량회수부대비용(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                원</td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                원</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>  
              <td class="title">&nbsp;<input type='hidden' name='tax_chk2' value='N'></td>
            </tr>
            <tr> 
              <td colspan="2" class="title">잔존차량가격(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                원</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                원</td>  
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">기타손해배상금(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                원</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                원</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;
              <font color="#FF0000">*</font>보험가입면책금:&nbsp;<input type='text' class='num' name='car_ja' size='7' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' readonly ><input type='hidden' name='tax_chk3' value='N' ><input type='hidden' name='tax_chk3' value='N' onClick="javascript:set_vat_amt(this);"><!--계산서발행의뢰--></td>
            </tr>
            
            <tr> 
              <td class="title" colspan="2">초과운행대여료(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                원</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1'  readonly  value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                원</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                 <input type='hidden' name='tax_chk4'  value=''>
                 <td class="title">&nbsp;<!--<input type='checkbox' name='tax_chk4' value='Y' onClick="javascript:set_vat_amt(this);">계산서발행의뢰 --></td>
            </tr> 
                   
            <tr> 
              <td class="title" colspan="3">부가세(N)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='' readonly size='15' class='num' >
                원</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='' readonly size='15' class='num' >
                원</td>  
              <td > 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td id=td_cancel_n style="display:''" class="title">=(F+M-B-C)×10%  </td>
                    <td id=td_cancel_y style='display:none' class='title'>=(F+M-B-C)×10% </td>
                  </tr>
                </table>
              </td>
            </tr>
            
            <tr> 
              <td class="title_p" colspan="4">계</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1' value='' readonly  size='15' class='num' >
                원</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='' readonly  size='15' class='num' >
                원</td>  
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M+N)&nbsp;&nbsp;
               <br>※ 계산서:&nbsp;             
                <input type="radio" name="tax_reg_gu" value="N" checked >항목별개별발행
                <input type="radio" name="tax_reg_gu" value="Y" >항목별통합발행(1장)
              </td>
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
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2'  size='15' class='num' readonly  > 원</td>           
                              
                    <% if ( re_acc_no == null   || re_acc_no.equals("")  ) {%>
                    <td colspan=6>&nbsp;※ 미납입금액계 - 환불금액계 </td>
                    <% } else { %>                  
                  	<td class=title width=12% ><input type='checkbox' name='cms_chk' value='Y'  checked >CMS인출의뢰</td>
                 	<td colspan=5>&nbsp;※ 미납입금액계 - 환불금액계</td>                   	
                    <% } %>
                    
              </tr>
          
              </table>
         </td>       
    <tr>
    
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> 해지정산금을 CMS(카드CMS)로 인출하는경우는 CMS인출의뢰에 check 하세요. </td>
    </tr>    
    <tr>
        <td>&nbsp;<font color="#FF0000">*** 이용기간 1개월 미만의 환불이 발생한 경우 카드승인번호 확인하여 카드취소후 해당일까지 이용금액을 다시 카드 결재하셔야 합니다. 카드정산관련 금액을 반드시 확인하세요!!! </font></td>
    </tr> 


 <!-- 환불금액이 있는 경우에 한함 -->
        
   	<tr id=tr_card style='display:none'> 
   	
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>카드정산</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
         	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                 <tr>
                   <td width='5%' class='title' >선택</td>	
                   <td width='5%' class='title' >연번</td>	
                   <td width='10%' class='title' >1회차여부 </td>	
                   <td width='15%' class='title'>승인일</td>
        		      <td width='10%' class='title'>승인금액</td>
		            <td width="10%" class='title'>승인번호</td>		           
				           	
				     </tr>	
                </table>
            </td>
         </tr>             
         
<% if (    vt_c_size   > 0 && ip_chk.equals("") ) { %>
		 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
<%
		for(int i = 0 ; i < vt_c_size ; i++)
		{
				Hashtable htc = (Hashtable) vt_card.elementAt(i);	%>               
              <tr>
                    <td width='5%' align='center'><input type='checkbox' name='t_card' value='<%=htc.get("R_DATE")%>'  onClick="javascript:set_card_amt();"  ></td>		
                      <td width='5%' align='center'><%=i+1%><input type="hidden" name="t_card_c" value='<%=htc.get("CARD")%>' ></td>
                      <td width='10%' align='center'><input type="hidden" name="t_f_tm_chk" value="<%=htc.get("F_TM_CHK")%>"><%=htc.get("F_TM_CHK")%></td>
        		         <td width='15%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(htc.get("R_DATE")))%></td>
		               <td width="10%" align='center'><input type="hidden" name="t_c_amt" value="<%=htc.get("R_AMOUNT")%>"><%=Util.parseDecimal(String.valueOf(htc.get("R_AMOUNT")))%></td>
		               <td width='10%' align='center' ><%=htc.get("APPR_NO")%></td>						             	
				   </tr>	
		<%		}    %>  		
                </table>
            </td>
         </tr>             
	<%		}    %>  	
         
          <tr></tr><tr></tr><tr></tr>     
         <tr>
         <input type='hidden' name='r_date'   >       
 		  <input type="hidden" name="jung_st"  >
          
          <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10%>카드 취소금액</td>
                    <td width=12% >&nbsp;<input type='text' name='h5_amt'  readonly   size='15' class='num'  > 원</td>        
                    
                     <td class=title width=10%>카드(재)출금액</td>
                    <td width=12% >&nbsp;<input type='text' name='h7_amt'    size='15' class='num'  > 원</td>                 
                             
                   	<td colspan=4>&nbsp;                
                  </td>             		     
              </tr>
             
              </table>
          </td>       
        </tr>
         
     	</table>
      </td>	 
    </tr>	  	 	    

  
   <tr>
        <td class=h></td>
    </tr>  
    
    <tr></tr><tr></tr><tr></tr>
    
  
     <!-- 초과운행부담금에 한함  block none-->
    
   	<tr id=tr_over style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>초과운행대여료</span></td>
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
              <td align="left" >&nbsp;월간</td>
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
               <td align="left" >&nbsp;=(가)x(나) / 30</td>
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
              <td align="right"> <input type='text' name='m_over_amt'   size='10' class='num'   onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> 원</td>
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
			                    <td>&nbsp;<input type='text' name='est_amt' size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
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
    
    <!-- 환불금액이 있는 경우에 한함 -->
        
   	<tr id=tr_refund style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>환불정보</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
 	 	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                    <tr> 
                        <td class="title"> 자동이체 </td>
                        <td >&nbsp; <input type="checkbox" name="re_cms_chk" value='Y' onClick="javascript:set_cms_value(this);">동일</td>
                        <td class="title">예금주명</td>
                        <td >&nbsp; <input type="text" name="re_acc_nm" value="" size="30" class=text></td>
                    </tr>
                        
                    <tr> 
                        <td width=15% class="title">은행명</td>
                        <td width=35%>&nbsp; <select name="re_bank" style="width:135">
                            <option value="">==선택==</option>
			      <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					    	<option value='<%=h_c_bnk.get("BCODE")%>'><%=h_c_bnk.get("BNAME")%></option> 	
                     
				              <%		}
							}%>
				              </select></td>
                        <td width=15% class="title">계좌번호</td>
                        <td width=35%>&nbsp; <input type="text" name="re_acc_no" value="" size="30" class=text></td>
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
    
    <!-- 환불금액이 있는 경우에 한함 -->
        
   	<tr id=tr_scd_ext style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>잔존 해지정산금</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
 	 	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                 <tr>
                    <td width='5%' class='title' >연번</td>					
		            <td width='14%' class='title'>계약번호</td>
        		    <td width='10%' class='title'>해지일</td>
		            <td width="28%" class='title'>고객</td>
		            <td width='10%' class='title'>차량번호</td>		
				    <td width='15%' class='title'>차명</td>	
				    <td width='9%' class='title'>금액</td>		
				    <td width='9%' class='title'>영업담당</td>		                	
				</tr>	
                </table>
            </td>
         </tr>             
 <%
	if(vt_size > 0)
	{	
%>     
		 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht_ext = (Hashtable) vt_ext.elementAt(i);	%>                
                 <tr>
                    <td width='5%' align='center'><%=i+1%></td>					
		            <td width='14%' align='center'><%=ht_ext.get("RENT_L_CD")%></td>
        		    <td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht_ext.get("CLS_DT")))%></td>
		            <td width="28%" align='center'><%=ht_ext.get("FIRM_NM")%></td>
		            <td width='10%' align='center' ><%=ht_ext.get("CAR_NO")%></td>		
				    <td width='15%' align='center'><%=ht_ext.get("CAR_NM")%></td>	
				    <td width='9%' align='right'><%=Util.parseDecimal(String.valueOf(ht_ext.get("CLS_AMT")))%></td>		
				    <td width='9%' align='center'><%=c_db.getNameById(String.valueOf(ht_ext.get("BUS_ID2")),"USER")%></td>		                	
				</tr>	
		<%		}    %>  		
                </table>
            </td>
         </tr>             
     
<%	}  %>	
                      
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
        
    <tr>
      	<td align="center">&nbsp;
      	<% if (nm_db.getWorkAuthUser("전산담당",user_id)) {%>
      	<a href="javascript:save1();">입력오류건 처리</a>  &nbsp; 
      	<% } %>
      	<%// if (nm_db.getWorkAuthUser("본사주차장",user_id) || nm_db.getWorkAuthUser("주차장출납",user_id) || nm_db.getWorkAuthUser("본사주차장관리",user_id) || nm_db.getWorkAuthUser("본사주차장부관리",user_id)) { %>
      	<%//} else { %>
      	<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle>
      	<%// } %>
	  <td align="center"></td>
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
 	 	 	 	
 	   	 fm.h5_amt.value =0;
		 fm.h7_amt.value =0;
		  	 
		  	 	
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
		
		//초과운행부담금	
		if ( <%= o_amt%> > 0 ) {
			tr_over.style.display 		= '';  //초과운행부담금
		}
				
	
		//잔여선납금?
		if(fm.pp_s_amt.value != '0'){		
			fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
			fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value)) 
	
		}else{
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;
		}
			
		
		if(fm.pp_s_amt.value != '0') {
	 	 
	 	 	if ( fm.cls_st.value == '7' || fm.cls_st.value == '10') { //출고전해지(신차) , 재리스(개시전해지)
	  		} else {
		    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //만기일
		    		
		    		fm.pded_s_amt.value 	= 0;
					fm.tpded_s_amt.value 	= 0;
					fm.rfee_s_amt.value 	= 0;
		    	}   
		    }	
	    }	
	    
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // 선납금액이 경과한 경우
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
	
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );

	 
		//미납입금액 정산 초기 셋팅		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}
			
	          //월렌트 환산금액 - 2개월미만인경우 원대여료로 계산
		if( toInt(fm.r_mon.value)   < 2 )  {
		     	   fm.mfee_amt.value = fm.nfee_s_amt.value;
	     } else {
	        	     fm.nfee_s_amt.value = fm.mfee_amt.value;  //2개월이상인 경우는 5% dc가 기준대여료	          
	   }
	   
	     //개시대여료가 없는 경우 		 -- nnfee_s_amt : 미납금액(잔액아님). di_amt :잔액미납금액  	  -- 대여개시가 된 경우     	
	   if(fm.ifee_s_amt.value == '0' ) {
		   	 // 스케쥴생성보다 해지일이 더 큰 경우 
	     if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 		
		   	 	//	  alert("a");
		   	 		  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
		   	 		//    	 alert("b");
		   	 		    	var s1_str = fm.use_e_dt.value;
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
		
								       			
		//미납금액  - 개시대여료가 있는 경우 개시대여료만큼 스케쥴이 미생성, 만기일 이후 스케쥴이 생성된 건이라면 생성된 스케쥴로 미납금액 계산하고,
		//            스케쥴 생성하지 않은 경우는 경과개시대료를 계산하여 미납금액을 계산함
		//스케줄생성안된 경과일수 인 경우
		//대여료가 100이하인 경우 별도 처리 - 2011-01-24.	
			
	
	if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
		  if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   		fm.nfee_day.value = '0';
		  } 
		  fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
	   } else {
		  fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
	    }
	
		if (fm.ifee_s_amt.value == '0' ) {	
		  	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		      if  ( fm.nfee_amt.value  != '0' ) {
			     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
		 	    	fm.nfee_amt.value = fm.nnfee_s_amt.value;
			 	 }	
			  }	 
		    }
		
		}     		   				
		
		//대여개시가 안된 건
		if(fm.rent_start_dt.value == '')	{		  
		   fm.nfee_mon.value = '0';
		   fm.nfee_day.value  = '0' ;
		   fm.nfee_amt.value  = '0' ;				
		}
		     
	       	  //월렌트 관련 추가		
	   	//1달미만 해지된 경우. 날짜별 요금정산에 따름.
	   	//총사용일수 초기 셋팅		
		if(fm.r_mon.value  == '0' )  {
		          if ( toInt(parseDigit(fm.nfee_amt.value))  > 0 ) {  //미납이 있다면  (선납인데 예외로 후납됨)
			 	   fm.nfee_amt.value 	=   parseDecimal(  toInt(parseDigit(fm.add_amt_d.value)) ) ; 	    
			 }      
			     	
			   			   
				       //선납대여료 - 받을돈에서 받은돈 
			   if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
			            
					   if ( toInt(parseDigit(fm.day_cnt.value)) >   toInt(parseDigit(fm.r_day.value))  ) {	  
					   	  	  fm.ex_di_amt.value       =   parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) ; 					   	  	  
					   	   	 fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		 
					   	   	 fm.nfee_mon.value = '0';
							 fm.nfee_day.value = '0';
							 fm.nfee_amt.value = '0';			            
				       }   	 
					 				 
			  } 
		   	
		   	
		//	   alert(  parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) );
			 
		} else {   //잔여대여료 일수로 다시 계산 ( 환불일 경우)  rcon_mon, rcon_day:잔여대여기간  r_mon, r_day :이용기간 
		 		 //월렌트는 선납임   - 해지일 이후 입금건이 있다면  
			    // 완불이 안된경우는 계산된 값으로 일단 처리 - 받은돈이 많을 경우
			       			        
				          if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {
				                    
				                    //1달이고 배반차가 있으면  배반차료 추가해서 
				                       if ( toInt(parseDigit(fm.cons_s_amt.value))  > 0  &&  fm.r_mon.value  == '1'  && fm.r_day.value  == '0'   ) {
				                            fm.ex_di_amt.value      = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  +  toInt(parseDigit(fm.cons_s_amt.value))   -    toInt(parseDigit(fm.rc_s_amt.value)) );	 
				        		         fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))    +  toInt(parseDigit(fm.cons_s_amt.value)) +  toInt(parseDigit(fm.cons_v_amt.value))    -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	       
				                       				                                       
				                       } else {
				                       					                       	
				        		      fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );	 
				        		      fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))   -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	       
						     }
						      fm.nfee_mon.value = '0';
						      fm.nfee_day.value = '0';
						      fm.nfee_amt.value = '0';
						
					//	      alert(	 fm.rr_s_amt.value  );	
					//	      alert(	 fm.rr_amt.value  );	
						      	         
				          }
			
		}	
					
	 //       alert( fm.ex_s_amt.value );	
	         
	 //  	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	 	
	   	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		   	
		fm.nfee_amt_1.value 		= fm.nfee_amt.value; 
		fm.ex_di_amt_1.value 		= fm.ex_di_amt.value; 
		    
		fm.ex_di_v_amt_1.value 		= fm.ex_di_v_amt.value; 	    
	   
	//  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)));
	
		if(toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
		
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}	
			
		
		if(fm.dft_int.value == '' || fm.dft_int.value == '0' ) {
			fm.dft_int.value 			= 10;			
			fm.dft_int_1.value 			= 10;			
		}	
			
			
		if (  toInt(fm.rent_start_dt.value) < 1 ) {
			fm.dft_amt.value 			= "0"; 
			fm.dft_amt_1.value 			= "0";
			
		} else {	
			if ( fm.cls_st.value == '7' || fm.cls_st.value == '10' ) { //출고전해지(신차)인 경우 해지위약금 0
				fm.dft_amt.value 			= "0"; 
				fm.dft_amt_1.value 			= "0";			
			} else { 	
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int_1.value)/100) );
				
			}	
	        }
		
						
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
		
		//월렌트-   총사용일수 초기 셋팅	- 월렌트인경우 1개월 미만인 경우 별도 정산 - 1개월 이후 사용시 중도해지 위약금 발생				
		if(fm.r_mon.value  == '0' )  {
		     if ( toInt(parseDigit(fm.day_cnt.value)) >   toInt(parseDigit(fm.r_day.value))  ) {	  
				 	fm.dft_amt.value 			= '0';
		      }
		}      
		        				
		var no_v_amt =0;  //부가세는 무조건 계산
		var no_v_amt1 =0;  //부가세는 무조건 계산				
						
		no_v_amt 	= toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value))  + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) + (toInt(parseDigit(fm.over_amt_1.value)) * 0.1 ) -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
		
				
	//  부가세 저장 - 20220420 추가 
	    fm.rifee_v_amt.value = parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //개시대여료 
	    fm.rfee_v_amt.value = parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value))*0.1 );    //선납금 
	    
	    fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1) );  //당초 대여료 부가세 
	    fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) );  //확정 대여료 부가세 
	    
	    fm.over_v_amt.value =   '0';  //당초 초과운행 부가세 
	    fm.over_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );  //확정 초과운행 부가세 
	    			
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
	
        //미납금액계
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) +  toInt(parseDigit(fm.dly_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.over_amt.value))   + toInt(parseDigit(fm.no_v_amt.value)));
		
		//확정금액 보여주기
		fm.dly_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dly_amt.value))) ;
		fm.dft_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dft_amt.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
	
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) +  toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)) );	 //확정금액	
				
		set_tax_init();
			
		//고객이 납입할 금액 초기 셋팅	(매입옵션금액은 표시 안함)
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
		
		//돌려줄 금액이 있다면
		if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
			 tr_refund.style.display		= '';	//환불정보
			 tr_scd_ext.style.display		= '';	//잔존해지정산금
			 if ( <%=vt_c_size%> > 0 ) {
				 tr_card.style.display		= '';	//카드정산 
				 set_card_amt();
			// 	 fm.h5_amt.value 			= parseDecimal( toInt(parseDigit(fm.t_amount.value )) );  //카드 재결재금액  
			//  	 fm.h7_amt.value 			= parseDecimal( toInt(parseDigit(fm.h5_amt.value)) + toInt(parseDigit(fm.fdft_amt2.value)) );  //카드 재결재금액 
			  	 fm.jung_st.value = '3';
			}	 
		} else {
			 tr_refund.style.display		= 'none';	//환불정보
			 tr_scd_ext.style.display		= 'none';	//잔존해지정산금
		  	 tr_card.style.display		= 'none';	// 카드정산
		  	 fm.h5_amt.value =0;
		  	 fm.h7_amt.value =0;
		  	 fm.jung_st.value = '1';
		  
		}	
	
	}
	
	//세금계산서
	function set_tax_init(){
		var fm = document.form1;
		
		/* 2022-04 사용안함
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
		*/
		
				//초과운행부담금
		if(toInt(parseDigit(fm.over_amt_1.value)) > 0){
				fm.tax_g[4].value       = "초과운행대여료";
		   		fm.tax_supply[4].value 	= fm.over_amt_1.value;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );
	
		}	
		
	}	
	
//-->
</script>
</body>
</html>
