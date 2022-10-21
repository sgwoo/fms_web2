<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.credit.*, acar.car_mst.*, acar.car_register.*, acar.car_sche.*, acar.car_office.*"%>
<%@ page import="acar.user_mng.*, acar.fee.*"%>
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
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	int guar_cnt = 0;
	if  (cont_etc.getClient_guar_st().equals("1") ) guar_cnt++;
	if  (cont_etc.getGuar_st().equals("1") ) guar_cnt++;

	//1. 고객 ---------------------------
		//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
		
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//보조번호판 발급정보
	CarSecondPlateBean second_plate = a_db.getCarSecondPlate(rent_mng_id, rent_l_cd);
	
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
	
	int dashcnt = 0;
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		dashcnt = ac_db.getDashboardCnt(base.getCar_mng_id());
	}
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
			
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//fee 기타 - 주행거리 초과분 계산  - fee_etc 의  over_run_amt > 0보다 큰 경우 해당됨
	//장기인경우 주행거리가 1년 기준이므로 1년미만 계약인 경우 개월수 확인하여 적용 - 20160714
//	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1"); // 최초로 -20161219 초과운행부담금 중간정산을 하지 않기에  
	
	//전기차 충전기 신청 여부 확인
	CarOffPreDatabase cop_db 	= CarOffPreDatabase.getInstance();
	EcarChargerBean ec_bean	= cop_db.getEcarChargerOne(rent_l_cd, rent_mng_id);
	
	int  o_amt =   car1.getOver_run_amt();   //초과 
			
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
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//연대보증인 -  대표연대보증 포함
	Vector gurs = a_db.getContGurList1(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();     	

	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
		
	//네오엠-은행정보
	CodeBean[] banks = neoe_db.getCodeAll();	//-> neoe_db 변환
	int bank_size = banks.length;
	
	int pp_s_amt = AddUtil.parseInt((String)base1.get("PP_S_AMT"));
	
		//면책금 기청구된 건중 매출처리 여부 구분
	int car_ja_no_amt =  ac_db.getCarServiceBillNo(rent_mng_id, rent_l_cd);
		
	Vector cms_bnk = c_db.getCmsBank();	//은행명을 가져온다.
	int cms_bnk_size1 = cms_bnk.size();
	
	//cms 정보
	Hashtable h_cms = c_db.getCmsBank_info(rent_l_cd);
	
	String re_bank = "";
	String re_acc_no = "";
	String re_acc_nm = "";
		
	re_bank = (String)h_cms.get("CBNK");
	re_acc_no = (String) h_cms.get("CBNO");
	re_acc_nm = (String) h_cms.get("CYJ");
	
	//기존에 등록되었는지 여부
	int reg_cnt = 0;
	reg_cnt= ac_db.getClsEtcCnt(rent_mng_id, rent_l_cd);
		
	//해지정산 리스트
	Vector vt_ext = as_db.getClsList(base.getClient_id());
	int vt_size = vt_ext.size();
	
	
	//싼타페등 연비보상
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id(), "N" );		
//	out.println(fuel_cnt);	

	String return_remark = "";
	Hashtable  return1 =   new Hashtable();
	
   if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "N");
	  	return_remark = (String)return1.get("REMARK");
  }
            
    //car_price 
   int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  - car.getDc_cs_amt() - car.getDc_cv_amt(); 
	float f_opt_per = 0;         
                    
   CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;     
	
	String target_id = "000028";  //중도해지 위약금 면제
		
	CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);  		
						
//	if(!cs_bean2.getWork_id().equals("")) target_id =  cs_bean2.getWork_id();    // cs_bean3.getWork_id();
	if(!cs_bean2.getWork_id().equals("")) target_id =  "000005";    // 영업기획팀장으로;
	
	String target_id1 = "000026";  //중도해지 위약금 면제 - 고객관리팀장 
		
	//잔여대여기간 구하기 (function 사용처리 ) 	
	String r_ymd[] = new String[3]; 
	String rcon_mon = "";
	String rcon_day  = "";
		
	String rr_ymd =  String.valueOf(base1.get("R2_YMD"));
   
   StringTokenizer token1 = new StringTokenizer(rr_ymd,"^");				
	while(token1.hasMoreTokens()) {			
			r_ymd[0] = token1.nextToken().trim();	//년
			r_ymd[1] = token1.nextToken().trim();	//월 
			r_ymd[2] = token1.nextToken().trim();	//일 
	}	
		
	//해지일이 계약기간 이후인 경우	 
	if  (AddUtil.parseInt(r_ymd[0]) < 0 ||  AddUtil.parseInt(r_ymd[1]) < 0 || AddUtil.parseInt(r_ymd[2]) < 0 ) {		
	   rcon_mon =  "";
 	   rcon_day =  "";
	} else {
	   rcon_mon =  Integer.toString( AddUtil.parseInt(r_ymd[0])*12  + AddUtil.parseInt(r_ymd[1]));
	   rcon_day =   Integer.toString(  AddUtil.parseInt(r_ymd[2])) ;  	
   }     
	   
//	out.println(rr_ymd);  
//	out.println(rcon_mon);  
//	out.println(rcon_day);  
		
   int tot_dist_cnt = 0;
   int scd_fee_cnt = 0;
   
   //연장전 임의연장 스케쥴 갯수 - 
   int feecnt3 =0;
   feecnt3 = ac_db.getFeeCnt3(rent_mng_id, rent_l_cd, fee_size);

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
<!--	
	
	//승계받을 계약 
	function search_grt_suc(gubun){
		window.open("s_grt_suc.jsp?gubun="+gubun+"&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=99991231","SERV_GRT_OFF","left=10,top=10,width=800,height=500,scrollbars=yes,status=yes,resizable=yes");
	}
	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}		

	//고객 보기
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}
	
	function view_tel(m_id,l_cd)
	{
		window.open("/fms2/consignment_new/cons_tel_list_s.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_TEL", "left=100, top=100, width=820, height=600, scrollbars=yes");
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
		
		if ( '<%=base.getCar_st()%>'  ==  '4'   ) {
				alert("월렌트정산에서 등록하세요!!");
				return;		
		}
		
			
		//car_st :업무대여차량, 회계팀에서 업무처리 완료.		
		if(fm.cls_st.value == '')				{ alert('해지구분을 선택하십시오'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('해지일자를 입력하십시오'); 		fm.cls_dt.focus(); 		return;	}
	
		//현재일 기준 2개월 내에만 등록 가능 		
		var s_str = fm.today_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1, s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1 , e_str.substring(8,10) );
		
		var diff_date = e_date.getTime() - s_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
		
		if ( count > 61 ) { 
			alert("해지일이 현재날짜와 2개월이상 차이시 등록할 수 없습니다.!!!"); 	
		    return;
		}	
		
		if(fm.cls_msg.value != '')				{ alert('계산이 정상적으로 처리되지 않았습니다.'); 		fm.cls_dt.focus(); 		return;	}
		
		if( toInt(parseDigit(fm.reg_cnt.value)) > 0 ) { 	 alert('이미 등록된 건입니다. 확인하십시요!!'); 	fm.cls_st.focus(); 		return;	}	
	
		if ( fm.cls_st.value == '7' || fm.cls_st.value == '10' ) { //출고전해지(신차) , 개시전해지(재리스)
			if ( fm.car_gu.value == '0') {
			    if(fm.cls_st.value == '7')				{ alert('재리스 개시전해지건입니다. 확인하세요!!'); 		fm.cls_st.focus(); 		return;	}
		    }
			if ( fm.car_gu.value == '1') {
			    if(fm.cls_st.value == '10')				{ alert('신차 출고전해지건입니다. 확인하세요!!'); 		fm.cls_st.focus(); 		return;	}
		    }
		}
		
		
		//출고전해지는 차량이 있다면 안됨.
		if ( fm.cls_st.value == '7'  ) {
			if( get_length(Space_All(fm.car_mng_id.value)) > 0 ) {	 		alert("등록된 차량입니다. 출고전해지 할 수 없습니다.!!");				return;		}			
		} else {
		  //주행거리 check 
		//  alert(fm.tot_dist_cnt.value);
		   if ( fm.tot_dist_cnt.value == '0' ) {	 		   alert("주행거리이력 확인 후 주행거리 입력하세요.!!!");					   return;		}		
		   if ( fm.scd_fee_cnt.value == '0' ) {	 			   alert("[스케쥴]확인하여 미납금액이  맞는지 다시 확인하세요.!!!");			   return;		}		
		} 
		
		if ( fm.cls_st.value == '1' || fm.cls_st.value == '2'  ||  fm.cls_st.value == '10'  ) {			
			//차량회수 여부 및 회수일자, 입고일자 등 check	
			if(fm.reco_st[0].checked == true){  //회수 선택시 - 회수형태 및 회수일, 입고일 check
					  if(fm.reco_d1_st.value == "") {
					 		alert("회수구분을 선택하셔야 합니다.!!");
							return;
					  }	
					  
					 if(fm.reco_dt.value == '')				{ alert('회수일자를 입력하십시오'); 		fm.reco_dt.focus(); 	return;	}
					 if(fm.ip_dt.value == '')				{ alert('입고일자를 입력하십시오'); 		fm.ip_dt.focus(); 		return;	}
						
						//회수일자 , 입고일자 비교 					
					if ( Math.abs( toInt(replaceString("-","",fm.cls_dt.value)) -   toInt(replaceString("-","",fm.reco_dt.value)) )  >  7   ) { //만기일		  
						alert("해지일자와 회수일자가 1주일 이상 차이납니다. 회수일자를 확인하세요.!!");
					}
					
					if (Math.abs( toInt(replaceString("-","",fm.cls_dt.value)) -   toInt(replaceString("-","",fm.ip_dt.value)) )  > 7      ) { //만기일		  
					 	alert("해지일자와 입고일자가 1주일 이상 차이납니다. 입고일자를 확인하세요.!!");
					}
						
					 if( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ){
						if(fm.est_dt.value == '')				{ alert('약정일자를 입력하십시오'); 		fm.est_dt.focus(); 		return;	}		
					 }
						
					 if( toInt(parseDigit(fm.tot_dist.value)) < 1 ) { 	 alert('주행거리를 입력하십시오'); 		fm.tot_dist.focus(); 		return;	}		
					 
					 if(fm.park.value == "") {
				 		alert("현위치를 선택하셔야 합니다.!!");
						return;
				   }	
				   
				   if(fm.serv_gubun[0].checked == false && fm.serv_gubun[1].checked == false && fm.serv_gubun[2].checked == false ){
						alert("예비차 적용를 선택하셔야 합니다.!!");
						return;
					}		
												
					
					<%  if ( base.getCar_st().equals("3") ) { %>
						 if(fm.serv_gubun[1].checked == true ){
								alert("리스차는 월렌트 적용을 할 수 없습니다.!!");
								return;
						}		
					
					<% } %>
				  			
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
		   
		}
				
		if( toInt(parseDigit(fm.ex_ip_amt.value)) > 0 ){
			//계좌번호		
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;
			var deposit_split = deposit_no.split(":");
			fm.deposit_no2.value = deposit_split[0];			
		
			if(fm.bank_code.value == ""){ alert("은행을 선택하십시오."); return; }			
			if(fm.deposit_no.value == ""){ alert("계좌번호를 선택하십시오."); return; }		
		}	
		
		//해지사유
		if( replaceString(' ', '',fm.cls_cau.value) == '' ){			alert("해지사유를 입력하셔야 합니다.!!");			return;		}			
		if( get_length(Space_All(fm.cls_cau.value)) == 0 ) {	 		alert("해지사유를 입력하셔야 합니다.!!");				return;		}	
					
			//연체료 및 중도해지 위약금이 차이가 발생한 경우 사유 입력 check
		if (  fm.dly_amt.value != fm.dly_amt_1.value ) {
		        if( get_length(Space_All(fm.dly_reason.value)) == 0  ) {				alert("연체료 감액사유를 입력하셔야 합니다.!!");				return;			}				
				  if( fm.dly_saction_id.value == '' ) {				alert("연체료감액 결재자를 지정하셔야 합니다.!!");				return;			}				
				  if( fm.dly_saction_id.value != '000004' ) {		alert("연체료감액 결재자를 안보국 팀장으로 지정하셔야 합니다. 사전에 협의하십시요.!!");			return;			}				
		}
					
		if(fm.match[0].checked == true){  //만기매칭  유 선택시
			if( fm.match_l_cd.value == "") { alert("만기매칭계약을  선택하십시오."); return; }				
			if ( toInt(parseDigit(fm.dft_amt_1.value)) > 0  ) {alert("만기매칭입니다. 위약금이 발생할 수 없습니다. 확인하세요!!!!.");				return;			}		
		}
		//업무용차량
		if ( fm.car_st.value == '5') {
		     fm.dft_amt.value = '0';
		     fm.dft_amt_1.value = '0'; 	     				     
		}
				
		//승계관련 - 20170223 
		if ( fm.suc_l_cd.value  != '') {
			 if ( fm.suc_gubun[0].checked == false &&  fm.suc_gubun[1].checked == false ) {		 		alert("승계구분을 선택하셔야 합니다.!!");				return;		 	}
		} 		
		
		if(fm.match[1].checked == true){  //만기매칭  유 선택시 위약금 없음 	
	
			if (  fm.dft_amt.value != fm.dft_amt_1.value ) {
			   if( get_length(Space_All(fm.dft_reason.value)) == 0 ) {				alert("중도해지위약금 감액사유를 입력하셔야 합니다.!!");				return;			}				
				if( fm.dft_cost_id.value == '' ) {				alert("영업효율 귀속대상자를 선택하셔야 합니다.!!");				return;			}					
				if( fm.dft_saction_id.value == '<%=target_id%>'  ||  fm.dft_saction_id.value == '<%=target_id1%>'   ) {			
				} else { 
					alert("중도해지위약금 결재자를  영업팀장 또는 관리팀장으로 지정하셔야 합니다.!!!!");
					return;				
				}
												
			}
		}	
		
		//출고전해지(신차),  개시전해지(재리스) 인경우 지점은 지점장 결재 득한후 처리가능	- 지점결재 생략 ( 20190705 제안)	
					 	
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
		/*
		if ( toInt(parseDigit(fm.dft_amt_1.value))  < 1 ) {
			if ( fm.tax_chk0.checked == true) {				alert("중도해지 위약금을 확인하세요. 계산서발행의뢰를 할 수 없습니다..!!");				return;			 }	
		}
				
		if ( toInt(parseDigit(fm.etc_amt_1.value))  < 1 ) {
			if ( fm.tax_chk1.checked == true) {				alert("차량회수외주비용을 확인하세요. 계산서발행의뢰를 할 수 없습니다..!!");				return;			 }	
		}	
	
		if ( toInt(parseDigit(fm.etc2_amt_1.value))  < 1 ) {
			if ( fm.tax_chk2.checked == true) {				alert("차량회수부대비용을 확인하세요. 계산서발행의뢰를 할 수 없습니다..!!");				return;			 }	
		}				
	 
		if ( toInt(parseDigit(fm.etc4_amt_1.value))  < 1 ) {
			if ( fm.tax_chk3.checked == true) {				alert("기타손해배상금을 확인하세요. 계산서발행의뢰를 할 수 없습니다..!!");				return;			 }	
		}	
		*/
		
		// 통합발행	
		if ( fm.tax_reg_gu[1].checked == true ) {		
			if ( toInt(parseDigit(fm.rifee_s_amt.value))  > 0 ) {				alert("개시대여료잔액이 있습니다. 항목별통합발행(1장)을 할 수 없습니다..!!");				return;		 	}		 	
		 	if ( toInt(parseDigit(fm.rfee_s_amt.value))  > 0 ) {				alert("선납금잔액이 있습니다. 항목별통합발행(1장)을 할 수 없습니다..!!");				return;		 	}		
		}
		
		// 환불금액 발생시 통장번호 check
		if ( toInt(parseDigit(fm.fdft_amt2.value))  < 0 ) {		  
		    if  (  fm.delay_st.checked == true ||   fm.suc_l_cd.value  != '')  {  
		    } else {
			    if ( fm.re_acc_no.value  == 'null' || fm.re_acc_no.value == ''  ) { 			alert("환불계좌번호를 정확하게 입력하세요..!!");			return;		    }			    
			    if ( fm.re_acc_nm.value  == 'null' ||   fm.re_acc_nm.value  == '') { 		alert("환불 예금주명을 입력하세요..!!");			return;		    }	
			 }   
		     //정산구분
		 	 if ( fm.refund_st[0].checked == false && fm.refund_st[1].checked == false  ){ 	alert("환불구분을 선택하세요.!!");			return;			}		   	

		}	
		
		  //정산구분				
		if ( fm.jung_st[0].checked == false && fm.jung_st[1].checked == false  ){			alert("정산구분을 선택하세요.!!");			return;			}
			
			//구분정산 선택시
		if ( toInt(parseDigit(fm.c_amt.value))  < 1 ) {
			 	if  (  fm.jung_st[1].checked == true)  {  			 		alert("합산정산으로 선택하세요.!!");			     	return;			   }
		 }
							
			//선수금정산관련 금액 		
		if  (  fm.jung_st[1].checked == true)  {  //구분정산 선택시
				 if ( ( toInt(parseDigit(fm.h5_amt.value)) -  toInt(parseDigit(fm.h7_amt.value)) ) * (-1)  !=   toInt(parseDigit(fm.fdft_amt2.value))  ) {	
			 		alert("고객납입금액과 구분정산금액이 틀립니다. 금액확인하세요.!!");
					return; 	
			 	}			
		} else {
			 	if ( toInt(parseDigit(fm.h3_amt.value)) *(-1)  !=  toInt(parseDigit(fm.fdft_amt2.value))  ) {
			 		alert("고객납입금액과 합산정산금액이 틀립니다. 금액확인하세요.!!");
					return; 	
			 	}		 		
		}
			
		//잔여개시대여료 또는 잔여선납금인경우 구분 정산 불가 - 20191121 	
		if  (  fm.jung_st[1].checked == true)  {  //구분정산 선택시
			 if (  toInt(parseDigit(fm.rfee_s_amt.value)) > 0  ) { 
				 alert("잔여 선납금이 있는 경우 합산정산으로 선택하세요.!!");
				 return; 
			 }
			
			 if (  toInt(parseDigit(fm.rifee_s_amt.value)) > 0  ) { 
				 alert("잔여 개시대여료가  있는 경우 합산정산으로 선택하세요.!!");
				 return; 
			 }			
		}
				
		//cms 부분 인출의뢰 체크  - 20200507 
		if  (  fm.cms_chk.checked == true)  {  //
			if  (  fm.jung_st[1].checked == true)  {  //구분정산 선택시
				 if (  toInt(parseDigit(fm.cms_amt.value)) > toInt(parseDigit(fm.h7_amt.value)) ) { 
					 alert(" cms부분인출금액이 청구금액보다 큽니다. 부분인출금액 확인하세요.!!");
					 return;  
				 }
			}
		    
			if  (  fm.jung_st[0].checked == true  &&  toInt(parseDigit(fm.fdft_amt2.value)) > 0 )  {  //구분정산 선택시
				 if (  toInt(parseDigit(fm.cms_amt.value)) > toInt(parseDigit(fm.fdft_amt2.value)) ) { 
					 alert(" cms부분인출금액이 고객납입금액보다 큽니다. 부분인출금액 확인하세요.!!");
					 return;  
				 }
			}
		}		
		
		//선납이 있는 경우 대여료 환산 -- warning !!!!
		if(toInt(parseDigit(fm.nfee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			if ( toInt(fm.rent_end_dt.value)  < toInt(replaceString("-","",fm.cls_dt.value)) ) {	                
				//만기이후 
				if( toInt(parseDigit(fm.rcon_mon.value)) < 1  && toInt(parseDigit(fm.rcon_day.value)) < 1 ){
					alert("!!!!!!!월대여료와 중도해지위약금 월대여료(환산)이 틀립니다.!!!!!!\n\n미납이 있는 경우 반드시 대여료 스케쥴 확인 후 미납금액을 계산하여 별도 적용하세요!!!");		
				//	print_view();
				}	
			}
		}
					
		//전기차 충전기 신청여부 체크(20190611)	
		confirmECarCharger();
		
		//출고전해지시 대차있는 경우  차량 왕복탁송료 부대비용 확인  -20210128
		if ( fm.cls_st.value == '7' &&  fm.prv_dlv_yn[1].checked == true  ) {
			if ( toInt(parseDigit(fm.etc2_amt_1.value))  < 1 ) {
					alert("차량회수부대비용을 확인하세요.왕복탁송료를 입력하세요!!!");			
					return;		
			}		
		}
			
		//연비보상 대상외 잔존차량금액이 마이너스인경우 체크 		
		if ( toInt(parseDigit(fm.etc3_amt_1.value))  < 0 ) {
			<% if  ( fuel_cnt  <  1 ) {%>
				alert("연비보상대상이 아닙니다. 확인하세요!!!");			
				return;	
			<% } %>
		}
			
		
		if(confirm('등록하시겠습니까?')){	
			fm.action='lc_cls_c_a.jsp';	
			fm.target='d_content';
			fm.submit();
		}		

	}
			
	//디스플레이 타입
	function cls_display(){
		var fm = document.form1;
		
		tr_ret.style.display		= '';	//차량회수	
		tr_gur.style.display		= '';	//채권관계
		tr_cre.style.display		= '';	//잔존채권처리
		tr_sale.style.display		= 'none';	//차량매각
		tr_refund.style.display		= 'none';	//환불정보
		tr_scd_ext.style.display	= 'none';	//환불정보
		tr_dae.style.display		= 'none';	//출고전대차	
			
		if ( fm.cls_st.value == '7' || fm.cls_st.value == '10' ) { //출고전해지(신차) , 개시전해지(재리스)
		
			tr_match.style.display		= 'none';	//만기매칭		
			tr_gur.style.display		= 'none';	//채권관계
			tr_cre.style.display		= 'none';	//잔존채권처리	
			
			if (fm.cls_st.value == '7' ) {
				tr_ret.style.display		= 'none';	//차량회수	
				tr_dae.style.display		= '';	//출고전대차	
			}
			
			fm.cancel_yn.value = 'Y';
			if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'N'){
				td_cancel_n.style.display 		= 'none';  //매출유지
				td_cancel_y.style.display 		= '';  //매출취소
			} else {
				td_cancel_n.style.display 		= '';  //매출유지
				td_cancel_y.style.display 		= '';  //매출취소
			}	
			
		}	
						  		
		//tot_dist 초기화 
		fm.tot_dist.value = "0";
		
	//	if ( fm.match.value == 'Y') {
	//		alert("만기매칭이 지워졌습니다. 반드시 만기매칭을 다시 선택하세요!!");
	//		fm.match.value = "" ;					
	//	}
		
		set_init();
		
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
	   	fm.fdft_amt3.value='0';  //차량매각	 
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
	
	//디스플레이 타입 - 선수금정산
	function cls_display4(){
		var fm = document.form1;
	
		if(fm.jung_st[1].checked == true){  //구분정산 선택시
			fm.h1_amt.value='0';  //선납금액
			fm.h2_amt.value='0';  //미납금액
			fm.h3_amt.value='0';  //정산금액
			fm.h4_amt.value='0';  //환불
			fm.h5_amt.value='0';  //환불정산
			fm.h6_amt.value='0';  //미납
			fm.h7_amt.value='0';  //미납정산
			
			fm.h4_amt.value = fm.c_amt.value; 	
			fm.h5_amt.value = fm.c_amt.value; 	
			fm.h6_amt.value =fm.fdft_amt1_1.value; 
			fm.h7_amt.value =fm.fdft_amt1_1.value; 
		//	fm.h3_amt.value =parseDecimal( toInt(parseDigit(fm.h1_amt.value)) - toInt(parseDigit(fm.h2_amt.value)) );		
			
						
		}else{
			fm.h1_amt.value='0';  //선납금액
			fm.h2_amt.value='0';  //미납금액
			fm.h3_amt.value='0';  //정산금액
			fm.h4_amt.value='0';  //환불
			fm.h5_amt.value='0';  //환불정산
			fm.h6_amt.value='0';  //미납
			fm.h7_amt.value='0';  //미납정산			
			
			fm.h1_amt.value = fm.c_amt.value; 	
			fm.h2_amt.value =fm.fdft_amt1_1.value; 
			fm.h3_amt.value =parseDecimal( toInt(parseDigit(fm.h1_amt.value)) - toInt(parseDigit(fm.h2_amt.value)) );		
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
						
		fm.cls_msg.value = "계산중입니다. 잠시 기다려주십시요.!!!";		
		
		//tot_dist 초기화 
		fm.tot_dist.value = "0";
		
	//	if(fm.match[0].checked == true){  //만기매칭  유 선택시 	
	//	if ( fm.match.value == 'Y') {
	//		alert("만기매칭이 지워졌습니다. 반드시 만기매칭 대차여부 항목을  확인후 다시 선택하세요!!");
	//		fm.match.value = "" ;					
	//	}
				
		set_init();		
		fm.action='./lc_cls_c_nodisplay.jsp';	
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
			if(fm.pp_s_amt.value != '0'){		//rent_st별로 처리해야 함 
				fm.rfee_s_amt.value     = parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );  //잔여대여기간으로 계산 - 20190827
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) ); 
				
			//	fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.m_mon.value)+toInt(fm.m_day.value)/30) );
			//	fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //선납금 월공제액
		
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		
		if ( fm.cls_st.value == '7'  ||  fm.cls_st.value == '10' ) {
	   } else {		
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
		var   c_pp_s_amt = 0;
		var   c_rfee_s_amt = 0;
		var   c_over_s_amt = 0;
		
		var c_fee_v_amt =  0;
		var c_fee_v_amt1 =  0;
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt.value)) * 0.1)) ;
		c_fee_v_amt1 = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		
		// 부가세 맞추기 - 20190904 - 잔액이 아닌 미납금액이 같다면 (한회차인 경우)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
		 	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));	
		 	c_fee_v_amt1  = toInt(parseDigit(fm.nnfee_v_amt.value));		 		   
 	    }	
				
		c_pp_s_amt = toInt(parseDigit(fm.rfee_s_amt.value))*0.1;
		c_rfee_s_amt = toInt(parseDigit(fm.rifee_s_amt.value)) *0.1;
		c_over_s_amt = toInt(parseDigit(fm.over_amt_1.value)) *0.1;  //초과운행은 예정과 확정이 같다. 
		
	   if ( fm.cls_st.value == '7'  ||  fm.cls_st.value == '10' ) {  //출고전해지. 개시전해지 - 계산시 부가세 틀린경우가 있음 	       
	       c_pp_s_amt =  toInt(parseDigit(fm.pp_amt.value)) -  toInt(parseDigit(fm.pp_s_amt.value)); 
	   	   c_rfee_s_amt = toInt(parseDigit(fm.ifee_amt.value)) -  toInt(parseDigit(fm.ifee_s_amt.value)); 
	   }
			   	   
		//각각 부가세 계산하여 더한다.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt  - c_pp_s_amt - c_rfee_s_amt ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 + c_over_s_amt - c_pp_s_amt - c_rfee_s_amt ;
		
		fm.rifee_v_amt.value = parseDecimal( c_rfee_s_amt);  //개시대여료 
	    fm.rfee_v_amt.value = parseDecimal( c_pp_s_amt) ;    //선납금 
	    
	    fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );  //당초 대여료 부가세 	    
	    fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 ); //확정 대여료 부가세 
		    
	    fm.over_v_amt.value =  '0';  //당초 초과운행 부가세  (0으로 처리 )
	    fm.over_v_amt_1.value = parseDecimal( c_over_s_amt );  //확정 초과운행 부가세 
							
		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		

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
		}			
		*/
		
		set_cls_s_amt();
	}	
	
			
	//미납 중도해지위약금 정산 : 자동계산
	function set_cls_amt3(obj){
		var fm = document.form1;
	//	obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //잔여대여계약기간
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
			//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
			//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}
		}else if(obj == fm.dft_int_1){ //위약금 적용요율
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
			//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}			
		}
		
		set_cls_s_amt();
	}		
							
	//확정금액 셋팅  -예정은 수정안함 ( 2022-04)
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		
		/*
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
			
//		}else if(obj == fm.over_amt_1){ //초과운행부담금 감액		 
		
	   */
	   
		if(obj == fm.m_over_amt){ //초과운행부담금 감액		 
					
    		fm.j_over_amt.value =  toInt(parseDigit(fm.r_over_amt.value)) - toInt(parseDigit(obj.value)) ;  
    		
    		if (  toInt(parseDigit(fm.j_over_amt.value)) > 0) {    		
				fm.over_amt.value = '0';  
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
		var no_v_amt1 = 0;
		var   c_pp_s_amt = 0;
		var   c_rfee_s_amt = 0;
		var   c_over_s_amt = 0;
		
		c_pp_s_amt = toInt(parseDigit(fm.rfee_s_amt.value))*0.1;
		c_rfee_s_amt = toInt(parseDigit(fm.rifee_s_amt.value)) *0.1;
		c_over_s_amt = toInt(parseDigit(fm.over_amt_1.value)) *0.1;
		
	    if ( fm.cls_st.value == '7'  ||  fm.cls_st.value == '10' ) {  //출고전해지. 개시전해지 - 계산시 부가세 틀린경우가 있음 	       
	       c_pp_s_amt =  toInt(parseDigit(fm.pp_amt.value)) -  toInt(parseDigit(fm.pp_s_amt.value)); 
	   	   c_rfee_s_amt = toInt(parseDigit(fm.ifee_amt.value)) -  toInt(parseDigit(fm.ifee_s_amt.value)); 
	    }
			
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
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt - c_pp_s_amt - c_rfee_s_amt ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 + c_over_s_amt - c_pp_s_amt - c_rfee_s_amt ;
		
		fm.rifee_v_amt.value = parseDecimal( c_rfee_s_amt) ;  //개시대여료 
		fm.rfee_v_amt.value = parseDecimal( c_pp_s_amt );    //선납금 
				 
	    fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );  //당초 대여료 부가세 	    
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 );   //확정 대여료 부가세 
			    
		fm.over_v_amt.value = '0';  //당초 초과운행 부가세 
		fm.over_v_amt_1.value = parseDecimal( c_over_s_amt);  //확정 초과운행 부가세 	
		
		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		
		
		/*  2022-04-20 사용안함.				
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
		*/	
		
		set_cls_s_amt();
				
	}	
		
	//확정금액 셋팅
	function set_cls_s_amt(){
		var fm = document.form1;	
	
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
			 tr_scd_ext.style.display		= '';	//잔존 해지정산금
		} else {
			 tr_refund.style.display		= 'none';	//환불정보
			 tr_scd_ext.style.display		= 'none';	//잔존 해지정산금
		}					
	}	
		
	//보증보험청구잔액
	function set_gi_amt(){
		var fm = document.form1;
		
		if ( toInt(parseDigit(fm.gi_c_amt.value))  > 0  ) {
			if ( toInt(parseDigit(fm.fdft_amt2.value))  > 0  ) {
				fm.gi_j_amt.value 		= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.gi_c_amt.value)));
			}			
		}
		
		if ( toInt(parseDigit(fm.gi_j_amt.value)) < 0  ) { //보증보험 가입금액이 더 많다		              
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
		/*		
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
		
		/*
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
			 }	
			 
		} else if(obj == fm.tax_chk4){ // 초과운행부담금 
							
			 if (obj.checked == true) {
			//   alert("chk over");
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));				
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));
			 } else {
		//   alert("no");
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );		
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[4].value)));
			 }	
	 	 
		} */
			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );						
	}
		
		
	// cms 정보와 동일 - 환불금액이 있는 경우 
	function set_cms_value(obj){
		var fm = document.form1;

		if(obj == fm.re_cms_chk){ // 위약금
		 	if (obj.checked == true) {
		 			fm.re_bank.value 		= '<%=re_bank%>';	
		 			fm.re_acc_no.value 		= '<%=re_acc_no%>';	
				 	fm.re_acc_nm.value 		= '<%=re_acc_nm%>';						 	
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
		
	  //만기매칭 여부
	function cng_input(){
		
		var fm = document.form1;
		
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // 개시대여료 잔액
		var v_ifee_ex_amt = 0;  //개시대여료 경과금액
		var  re_nfee_amt = 0;  //마지막차 스케쥴에서 일수 계산한 금액이 아닌 경우 check
	
		if(fm.match[0].checked == true){  //만기매칭  유 선택시
	//	 if ( fm.match.value == 'Y' ) {
	   		fm.dft_amt.value = '0';
	    	fm.dft_amt_1.value = '0'; 	
	    	fm.rifee_s_amt.value = '0';  //선납대여료 및 선납금 0 처리  
	    	fm.rfee_s_amt.value = '0'; 	//선납금 
	    	fm.rifee_v_amt.value = '0';  //개시대여료 
			fm.rfee_v_amt.value = '0';    //선납금 
	    	
	        //선납금액  
			fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
	    	
		    if ( toInt(parseDigit(fm.nfee_amt.value)) > 0  ) {  
		        alert(" 미도래 대여료 스케줄은 만기매칭되는 신규차량으로 이관되어 청구예정입니다!!! " );
				 fm.nfee_amt_1.value = '0'; 	  //미도래되는 대여료인 경우 
			 }   	    
		} else {		
			fm.cls_st.value="";	
			fm.match_l_cd.value="";	
			fm.match_car_no.value="";	
			fm.match_car_nm.value="";	
			fm.match_end_dt.value="";			
			set_day();
		
		} 	
						
		//과부족 및 과입금관련 vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		}
		 
		if ( fm.ex_di_amt_1.value == fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = fm.ex_di_v_amt.value ;
		}
		
		var no_v_amt = 0;
		var no_v_amt1 	= 0;		
		
		//각각 부가세 계산하여 더한다.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)   + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)      -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		 
		fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + (toInt(parseDigit(fm.nfee_amt.value)) * 0.1) );  //당초 대여료 부가세 
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) );  //확정 대여료 부가세 
				    
		fm.over_v_amt.value =  '0';  //당초 초과운행 부가세 
		fm.over_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );   //확정 초과운행 부가세 
		    	   	 
		fm.no_v_amt.value 	= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		
		
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
		}			
		*/
		
		set_cls_s_amt();			
	}
		
	//초과운행주행거리 - 20161122 계산서 발행 필수 
	function set_over_amt(){
		var fm = document.form1;
					
		var cal_dist  = 0;		
		var tae_cal_dist  = 0;	
		
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
		
		//초기화 
		fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) + toInt(parseDigit(fm.b_tot_dist.value))   );	
		fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) + toInt(parseDigit(fm.b_tot_dist.value))  -   toInt(parseDigit(fm.first_dist.value))     );		  
		cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
		fm.cal_dist.value 		=     parseDecimal( cal_dist   );
		
		fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     )
	
		//계약이 20220414 이후만 환급
		if (  <%=base.getRent_dt()%>  > 20220414 ) {  
			// 2022-05 수정  over_dist가  0 보다 크면 1000, 0  작으면 -1000 처리 - 기본공제처리시 
			if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
					fm.add_dist.value 		=  '0';  //기본공제처리 
					fm.jung_dist.value 		=  '0';			
			} else {
					// 2022-05 수정  over_dist가  0 보다 크면 1000, 0  작으면 -1000 처리 - 기본공제처리시 
					if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
						fm.add_dist.value 		=     parseDecimal( 1000  );  //기본공제처리 			
					} else {
						fm.add_dist.value 		=     parseDecimal( -1000  );  //기본공제처리 	
					}
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
			}
		} else {
			fm.add_dist.value 		=     parseDecimal( 1000  );  //써비스마일리지	(대차인경우 대차기간 표시)
			fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );					
		}
		
		//중도해약, 계약만료인 경우
		if ( fm.cls_st.value == '1' || fm.cls_st.value == '2'  ) { 
		       
			if ( (  <%=base.getRent_dt()%>  > 20130604  &&    <%=car1.getAgree_dist()%>  > 0   &&  <%=base.getCar_gu()%>  ==  '1' ) ||    (  <%=base.getRent_dt()%>  > 20140705  &&  <%=base.getCar_gu()%>  ==  '0' )   ) {  
						     
			     // fm.taecha_st_dt 값이 있다면 만기매칭 - 20210330 대차인 경우는 초과운행대여료 적용하지 않음 - 신차 만기매칭인 경우 해지시 초과운향부담금 감액으로 처리 
			//	if ( fm.taecha_st_dt.value  != "" )  {			
			//		var s1_str = fm.taecha_st_dt.value; //대차시작일
			//		var te1_str = fm.taecha_et_dt.value;  //대차만료일 
			//		var t_count1 = 0;
					
			//		var te1_date =  new Date (te1_str.substring(0,4), te1_str.substring(4,6) -1 , te1_str.substring(6,8) );	
					
			//		var t_diff1_date = te1_date.getTime() - s1_date.getTime();
			//		t_count1 = Math.floor(t_diff1_date/(24*60*60*1000));
			//		tae_cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  * t_count1/ 365;
										
			//		var e1_str = fm.cls_dt.value;
			//		var  count1 = 0;
					  
			//		var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );								
			//		var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1,  e1_str.substring(8,10) );	
																	
			////		var days = (e1_date - s1_date) / 1000 / 60 / 60 / 24; 		//1일=24시간*60분*60초*1000milliseconds
			////		var mons = (e1_date - s1_date) / 1000 / 60 / 60 / 24 / 30; 	//1달=24시간*60분*60초*1000milliseconds
					
			//	   var diff1_date = e1_date.getTime() - s1_date.getTime();
			//	 	count1 = Math.floor(diff1_date/(24*60*60*1000));
			//		cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  * count1/ 365;
			//	} else {											
			    	cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;		
			//	}         	
								
				fm.cal_dist.value 		=     parseDecimal( Math.round(cal_dist)  );				
			//	fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );						
				fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) + toInt(parseDigit(fm.b_tot_dist.value))   );	
				fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) + toInt(parseDigit(fm.b_tot_dist.value))  -   toInt(parseDigit(fm.first_dist.value))     );		  
				fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );							
				
				//계약이 20220414 이후만 환급
				if (  <%=base.getRent_dt()%>  > 20220414 ) {  
				
					if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
						fm.add_dist.value 		=  '0';  //기본공제처리 
						fm.jung_dist.value 		=  '0';			
					} else {
						// 2022-05 수정  over_dist가  0 보다 크면 1000, 0  작으면 -1000 처리 - 기본공제처리시 
						if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
							fm.add_dist.value 		=     parseDecimal( 1000  );  //기본공제처리 			
						} else {
							fm.add_dist.value 		=     parseDecimal( -1000  );  //기본공제처리 	
						}
						fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
					}
				} else {				
					fm.add_dist.value 		=     parseDecimal( 1000  );  //써비스마일리지	(대차인경우 대차기간 표시)
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
				}
				
				//지연대차가 있는 경우 -				
			//	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
			//	alert( toInt(parseDigit(fm.jung_dist.value)) );				
				if ( 	toInt(parseDigit(fm.jung_dist.value))   > 0   ) {
					fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );								
					fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );
					fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
					fm.tax_chk4.value  = 'Y' ;
				    fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );				
				
				}  else if ( toInt(parseDigit(fm.jung_dist.value))  == 0   ) {
				    
					fm.r_over_amt.value 	=      "0";				
					fm.j_over_amt.value 	=     "0";	
					fm.tax_supply[4].value 	=  '0';					 
					fm.tax_value[4].value 	=  '0';		
					fm.tax_chk4.value  = 'N' ;					
				}  else  {	
					if ( <%=car1.getRtn_run_amt()%> > 0) {					
					    fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.rtn_run_amt.value)   );								
						fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.rtn_run_amt.value)   );
						fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
						fm.tax_chk4.value  = 'Y' ;
					    fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );		
					} else {
				
						fm.r_over_amt.value 	=      "0";				
						fm.j_over_amt.value 	=     "0";	
						fm.tax_supply[4].value 	=  '0';					 
						fm.tax_value[4].value 	=  '0';		
						fm.tax_chk4.value  = 'N' ;	
					}    
									
			 	}						         		
			}		
		}				
		
		fm.over_amt.value 		    = '0';
		fm.over_amt_1.value 	    = parseDecimal( toInt(parseDigit(fm.j_over_amt.value)));				
		
		var no_v_amt = 0;
		var no_v_amt1 = 0;
		
		var c_fee_v_amt =  0;
		var c_fee_v_amt1 =  0;
		var c_over_s_amt = 0;
		
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt.value)) * 0.1)) ;
		c_fee_v_amt1 = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		c_over_s_amt = toInt(parseDigit(fm.over_amt_1.value)) * 0.1;
		
		// 부가세 맞추기 - 20190904 - 잔액이 아닌 미납금액이 같다면 (한회차인 경우)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
	    	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
	    	c_fee_v_amt1  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
 	    }	
			  					
		//각각 부가세 계산하여 더한다.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt  - ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 + c_over_s_amt - ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //개시대여료 
		fm.rfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) *0.1 );    //선납금 
		    
		fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );//당초 대여료 부가세 
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 );  //확정 대여료 부가세 
		    
		fm.over_v_amt.value =  '0';  //당초 초과운행 부가세 
		fm.over_v_amt_1.value =  parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );  //확정 초과운행 부가세 
		
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
		}		
		*/
		
		set_cls_s_amt();			
		
	}	
	
	
	function view_car_service(car_id){
	  var fm = document.form1;
	    fm.tot_dist_cnt.value = '1';
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
	    fm.scd_fee_cnt.value = '1';
	    
		window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "PRINT_VIEW", "left=50, top=50, width=770, height=640, scrollbars=yes");
	}
	
	//전기차충전기 신청이 되어 있는 차량이면 안내 확인창(20190605)
	function confirmECarCharger(){
		<%if(!ec_bean.getRent_l_cd().equals("")){%>
				alert("전기차 충전기 신청이 되어 있는 계약입니다.\n\n해지후 전기차 충전기 신청도 해지해야 합니다.");
		<%}%>
	}
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15"">
<form action='' name="form1" method='post'>

<input type='hidden' name='car_gu' 	value='<%=base.getCar_gu()%>'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 	value='<%=andor%>'>
<input type='hidden' name='car_st' 	value='<%=base.getCar_st()%>'>
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
<input type='hidden' name='pp_amt' value='<%=base1.get("PP_AMT")%>'>
<input type='hidden' name='ifee_amt' value='<%=base1.get("IFEE_AMT")%>'>
  
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 
<input type='hidden' name='use_oe_dt' value='<%=base1.get("USE_OE_DT")%>'> <!--임의연장 전 만기일자 -->

<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'>   <!-- 연체중 가장 작은날짜 -->
<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--만기일기준 경과계약기간 -->

<input type='hidden' name='bank_code2' 	value=''>
<input type='hidden' name='deposit_no2' value=''>
<input type='hidden' name='bank_name' 	value=''>  
 
<input type='hidden' name='cls_s_amt' value='' >
<input type='hidden' name='cls_v_amt' value='' >
<input type='hidden' name='car_ja_no_amt' value='<%=car_ja_no_amt%>' >

<!-- 미납금액 -->
<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'>
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_V_AMT")))%>'>
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_AMT")))%>'> <!--스케쥴의 연체월대여료 -잔액 -->

<input type='hidden' name='s_mon' value='<%=base1.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base1.get("S_DAY")%>'> 

<!-- <input type='hidden' name='m_mon' value='<%=base1.get("M_MON")%>'> -->
<!-- <input type='hidden' name='m_day' value='<%=base1.get("M_DAY")%>'> -->

<input type='hidden' name='hs_mon' value='<%=base1.get("HS_MON")%>'>  <!-- 잔액제외한 미납일자 -->
<input type='hidden' name='hs_day' value='<%=base1.get("HS_DAY")%>'>  <!-- 잔액제외한 미납일자 -->

<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_S_AMT")))%>'> <!--스케쥴의 선납대여료 (해지일 이후) -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'>  

<input type='hidden' name='reg_cnt' value='<%=reg_cnt%>'> <!-- 기등록여부 -->
<input type='hidden' name='cms_yn' value='<%=re_bank%>'>  

<input type='hidden' name='lfee_mon' value='<%=base1.get("LFEE_MON")%>'> <!--대여개월수 -->
<input type='hidden' name='feecnt3' value='<%=feecnt3%>'> <!-- 연장전 임의연장 갯수 -->
  
  <!--초과운행 거리 계산 -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='rtn_run_amt' value='<%=car1.getRtn_run_amt()%>'>
 
<input type='hidden' name='sh_km' value=''>
  
<input type='hidden' name='rc_s_amt' value='<%=base1.get("RC_S_AMT")%>'> <!--받은 금액 --> 
<input type='hidden' name='rc_v_amt' value='<%=base1.get("RC_V_AMT")%>'> <!-- 받은 금액 --> 
<input type='hidden' name='rr_s_amt' value='<%=base1.get("RR_S_AMT")%>'> <!-- 받을 금액 --> 
<input type='hidden' name='rr_v_amt' value='<%=base1.get("RR_V_AMT")%>'> <!-- 받을 금액 --> 
<input type='hidden' name='rr_amt' value='<%=base1.get("RR_AMT")%>'> <!-- 받을 금액 --> 
<input type='hidden' name='b_dt' size='10' value='<%=Util.getDate()%>' >
<input type='hidden' name='taecha_st_dt' value='<%=taecha.getCar_rent_st()%>'><!--대차 시작일 -->
<input type='hidden' name='taecha_et_dt' value='<%=taecha.getCar_rent_et()%>'><!--대차 종료일 -->

<input type='hidden' name='rifee_v_amt' value=''> <!-- 부가세 관련  -->
<input type='hidden' name='rfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt_1' value=''>
<input type='hidden' name='over_v_amt' value=''>
<input type='hidden' name='over_v_amt_1' value=''>

<input type='hidden' name='today_dt' value='<%=AddUtil.getDate(4)%>'>
 
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
            <td class=title width=12% colspan=2>계약번호</td>
            <td width=24%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;<a href="javascript:view_cng_etc('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='특이사항'><img src=/acar/images/center/button_tish.gif align=absmiddle border=0></a>          
            &nbsp;<a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='스캔관리'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
              &nbsp;<a href="javascript:print_view('');" title='기본' onMouseOver="window.status=''; return true">[스케쥴]</a>
               <input type='hidden' name='scd_fee_cnt'  value='<%= scd_fee_cnt%>' >
            </td>
            <td rowspan="7" class="title">대<br>
		                여<br>
		                자<br>
		                동<br>
		                차</td>
		    <td class=title width=10%>차명</td>
            <td >&nbsp;<% if  ( cr_bean.getFuel_kd().equals("8") ) { %><font color=red>[전]</font>&nbsp;<% } %>
            <%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
			<font color="#999999">(차종코드:<%=cm_bean.getJg_code()%>)</font>
			</td>
			<td rowspan="4" class="title">영<br>
		                업</td>		            
            <td class=title width=10%>영업지점</td>
            <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
          </tr>
          <tr>
            <td rowspan="3" class="title">계<br>
		                약<br>
		                자</td>
		    <td class=title>상호</td>
            <td>&nbsp;<a href="javascript:view_client('<%=rent_mng_id%>', '<%=rent_l_cd%>', '<%=fee_size%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a>
            &nbsp;&nbsp;<a href="javascript:view_tel('<%=rent_mng_id%>' ,'<%=rent_l_cd%>')" onMouseOver="window.status=''; return true" title="클릭하세요">[고객연락처]</a>
            </td>
		    <td class=title>차량번호</td>
            <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a>
              
            </td>
            <td class=title>영업구분</td>
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이전트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
          </tr>
          <tr> 
            <td class=title>대표자</td>
            <td>&nbsp;<%=client.getClient_nm()%></td> 
            <td class=title>차량구분</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
            <td class=title>최초영업자</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
          </tr>
          <tr>
            <td class=title>지점/현장</td>
            <td>&nbsp;<%=site.getR_site()%></td> 
            <td class=title>용도구분</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>   
            <td class=title>영업대리인</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
          </tr>
          <tr> 
            <td rowspan="3" class="title">계<br>
		                약</td>    
		    <td class=title>계약구분</td>
            <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>            
            <td class=title>최초등록일</td>
            <td>&nbsp;<%=cr_bean.getInit_reg_dt()%></td> 
            <td rowspan="3" class="title">관<br>
		               리</td>  
            <td class=title width=10%>관리지점</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
          </tr>
          <tr> 
            <td class=title>계약일자</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
            <td class=title>차령만료일</td>
            <td>&nbsp;<%=cr_bean.getCar_end_dt()%>
            <font color="red"><% if ( cr_bean.getCar_end_yn().equals("Y") )  {%>연장종료<%} %></font>  
            </td>     
            <td class=title>관리구분</td>
            <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
          </tr>
          <tr>   
            <td class=title>계약기간</td>
            <td>&nbsp;<%=fee.getCon_mon()%> 개월</td>
            <td class=title>현재차령</td>
            <td>&nbsp;<b><%=base1.get("CAR_MON")%></b> 개월</td>         
            <td class=title>영업담당자</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
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
				
				f_opt_per  = (float) s_opt_amt  / car_price * 100 ;
			   			 			   
			   f_opt_per =  AddUtil.parseFloatCipher(f_opt_per,1);
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
            <td width='12%' class='title'>해지구분</td>
            <td width="13%">&nbsp; 
			  <select name="cls_st" onChange='javascript:cls_display()'>
			    <option value="">---선택---</option>
                <option value="1">계약만료</option>             
                <option value="2">중도해약</option>              
                <option value="7">출고전해지(신차)</option>         
                <option value="10">개시전해지(재리스)</option> 
              </select> </td>            
            <td width='12%' class='title'>의뢰자</td>
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
                      
            <td width='12%' class='title'>해지일자</td>
            <td width="12%">&nbsp;
			  <input type='text' name='cls_dt' value='<%=AddUtil.getDate()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'></td> 
		    <td width='12%' class='title'>이용기간</td>
		    <td >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' readonly  value='<%=base1.get("R_MON")%>' >개월&nbsp;
		      <input type='text' name='r_day' size='2' class='text' value='<%= base1.get("R_DAY")%>' onBlur='javascript:set_cls_amt1(this);'>일&nbsp;</td>
         
            </td>
          </tr>
          <tr> 
            <td class='title'>사유 </td>
            <td colspan="7">&nbsp;
			  <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"></textarea> 
            </td>           
          </tr>                                         
              
          <tr>                                                      
            <td class=title >잔여선납금<br>매출취소여부</td>
     	    <td >&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'>
                <option value="N">매출유지</option>
                <option value="Y" selected>매출취소</option>
              </select>	  
			</td>
			<td  class=title width=10%>지점장결재자</td>
            <td  width=12%>&nbsp;			
			</td>			        
            <td  colspan="4" align=left>&nbsp;※ 기발행 계산서의 유지 또는 취소여부 등 확인이 필요, 매출취소시 마이너스 세금계산서 발행 </td>           
          </tr>
           <tr>      
		            <td width='13%' class='title'>주행거리</td>
		            <td>&nbsp;
					  <input type='text' name='tot_dist' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_over_amt();'>&nbsp;km 
					  <input type='hidden' name='tot_dist_cnt' value='<%=tot_dist_cnt%>' > 
					   &nbsp;					   
					   <a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="정비내역보기"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a>	 
    	    		</td>
		            <td  colspan=6  align=left>&nbsp;
		           <% if ( dashcnt > 0) { %><font color=red> ※  계기판 교환직전 주행거리  </font>
		             <input type='text' name='b_tot_dist' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_over_amt();'>&nbsp;km 
		           <% } else{ %>
		             <input type='hidden' name='b_tot_dist'   >
		           <%}  %>       
		    &nbsp;※ 중도해지 및 만기시 차량주행거리 </td>	
		    
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
					                    <td class=title style='height:44' width=13%><font color=red>해지 특이사항</font></td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="cont_cls_etc" cols="140" class="text" style="IME-MODE: active" rows="3"><%=cont_etc.getCls_etc()%></textarea> 
					                    </td>
					                </tr>
		                
		           				</table>
		           			</td>
		           		</tr>
		           	</table>			
		        </td>
		    </tr>
   <%} %>  
  
   <tr>
      	<td>&nbsp;<font color="#FF0000">***  31일, 30일 일자에 따라 금액 차이 발생될 수 있으니 반드시 대여료 스케쥴 확인하여 처리하세요.!!! </font></td> 
   </tr> 
      
    <tr>
      <td>&nbsp;</td>
    </tr>
    
    <tr id=tr_match style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>만기매칭대차</span></td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		    
			<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 
			          <td width='13%' class='title'>만기매칭대차</td>
			          <td colspan=7>&nbsp;<input type="radio" name="match" value="Y"  onClick='javascript:cng_input()'>유
	                            <input type="radio" name="match" value="N"  checked  onClick='javascript:cng_input()'>무
	                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약:&nbsp;<a href="javascript:search_grt_suc(2)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>	                
		          </tr>		                   
		          <tr>      
		            <td width='10%' class='title'>계약번호</td>
		            <td>&nbsp;<input type='text' name='match_l_cd' size='15' value='' class='whitetext' readonly ></td>
		            <td width='10%' class='title'>차명</td>
		            <td>&nbsp;<input type='text' name='match_car_nm' size='20' value='' class='whitetext' readonly ></td>
		            <td width='10%' class='title'>대여개시일</td>
		            <td>&nbsp;해지일자와 같은 날 </td>
		          </tr>		         
		          <tr>      
		            <td width='10%' class='title'>차량번호</td>
		            <td>&nbsp;<input type='text' name='match_car_no' size='15' value='' class='whitetext' readonly ></td>
		            <td width='10%' class='title'>대여종료일</td>
		            <td>&nbsp;<input type='text' name='match_end_dt' size='15' value='' class='whitetext' readonly ></td>
		            <td width='10%' class='title'>대여기간</td>
		            <td>&nbsp;</td>
		          </tr>	
		       </table>
		     </td>
		   </tr>       	      
		    <tr>
	    		<td>&nbsp;<font color="#FF0000">***</font> 만기매칭대차인경우는 만기매칭대차의 계약번호를 입력해주세요.!!  대차차량의 스케쥴을 확인해주세요.!!</td>    
	   	   </tr>		  	
		</table>
      </td>	 
    </tr>	     
    
   <tr>
      <td>&nbsp;</td>
   </tr>
    
    <tr id=tr_dae style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고전대차</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
                    <td width="13%" class=title>출고전대차여부</td>
                    <td width="20%">&nbsp; &nbsp;
                      <input type='radio' name="prv_dlv_yn" value='N' <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%> disabled>
                      없다
                      <input type='radio' name="prv_dlv_yn" value='Y' <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%> disabled>
        	 		있다
        		    </td>
                    <td width="10%" class=title style="font-size : 8pt;">대차기간포함여부</td>
                    <td colspan=3 >&nbsp; &nbsp;
                      <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> disabled>
                      미포함
                      <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> disabled>
        	 		포함
        		    </td>
                </tr>
                <%	for(int i = 0 ; i < ta_vt_size ; i++){
						Hashtable ta_ht = (Hashtable)ta_vt.elementAt(i);
       					taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, ta_ht.get("NO")+"");
    			%>   
                 <tr>
                    <td width="13%" class=title>차량번호</td>
                    <td width="20%">&nbsp;<%=taecha.getCar_no()%>                  
        			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
        			</td>
                    <td width="10%" class='title'>차명</td>
                    <td>&nbsp;<%=taecha.getCar_nm()%></td>
                    <td class='title'>최초등록일</td>
                    <td>&nbsp;<%=taecha.getInit_reg_dt()%></td>
                </tr>
                <tr>
                    <td class=title>대여개시일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
                    <td class='title'>대여만료일</td>
                    <td width="20%" >&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>                
                    <td width="10%" class=title >신차해지시요금정산<br>(월렌트정상요금)</td>
                    <td>&nbsp;
                      <%if(taecha.getRent_fee_st().equals("1")){%>                            
		                      <%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>원(vat포함)                
		              <%}%>
		              <%if(taecha.getRent_fee_st().equals("0")){%> 견적서에 표기되어 있지 않음 <br><b><font color=blue>(월렌트 정상요금 산출시 권용식 과장과 상의)</font></b>    <%}%> 
        			</td>
                </tr>		
                <%} %>		 	     
		       </table>
		      </td>        
         </tr>   
         <tr>
     		<td>&nbsp;<font color="#FF0000">***</font> 출고지연대차가 있는 경우 지연대차 대차료 정산 후 고객에게 환불됩니다.!! </td>    
     	 </tr>
     
     	 <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
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
	                      			<option value="" >--선택--</option>    
	                     <%if(good_size > 0){ 			
	                   			   for(int i = 0 ; i < good_size ; i++){
                  								CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' ><%= good.getNm()%></option>		                 
                   		   <%	}                      
								  } %>                
	        		        </SELECT>
					<input type="text" name="park_cont" value="" size="80" class=text style='IME-MODE: active'>
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
					   <input type='text' name='etc_d1_amt' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'></td>
		            </td>
		            <td width='10%' class='title'>부대비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'></td>
		            </td>
		            <td width='10%' class='title'>비용계</td>
		            <td>&nbsp;
					 <input type='text' name='etc_out_amt' size='12' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
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
		                  <td class='title' rowspan="8" width=4%>환<br>
		                    불<br>
		                    금<br>
		                    액</td>
		                  <td class='title' rowspan="2" >보<br>
		                  증<br>
		                  금<br>(A)</td>
		                  <td width="14%" align="center" >예치금액</td>
		                  <td align="center"> 
		                   <input type='text' name='grt_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>&nbsp;</td>		              		              
		                </tr>
		                <tr>
		                  <td align="center" >승계</td>
		                  <td align="center">&nbsp;<input type="radio" name="suc_gubun" value="1"  >예치금전액승계 
	                            &nbsp;<input type="radio" name="suc_gubun" value="2"  >정산후잔액승계 </td>	  
		                    </td>
		                  <td>승계받을 계약번호:&nbsp;<input type='text' name='suc_l_cd' size='15' value='' class='whitetext' >
		                   &nbsp;<a href="javascript:search_grt_suc(1)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		                  </td>
		                </tr>
		                
		                <tr> 
		                  <td class='title' rowspan="3" width=4%>개<br>
		                    시<br>
		                    대<br>
		                    여<br>
		                    료</td>
		                  <td width="14%" align="center" >경과기간</td>
		                  <td align="center"> 
		                    <input type='text' size='3' name='ifee_mon' readonly  value='' class='num' maxlength='4' >
		                    개월&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='' class='num' maxlength='4' >
		                    일</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >경과금액</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=개시대여료×경과기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 개시대여료(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td class='title'>=개시대여료-경과금액</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">선<br>
		                    납<br>
		                    금</td>
		                  <td align='center'>월공제액 </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' readonly  value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=선납금÷계약기간</td>
		                </tr>
		                <tr> 
		                  <td align='center'>선납금 공제총액 </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt'  readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=월공제액×실이용기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 선납금(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td class='title'>=선납금-선납금 공제총액</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">계</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
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
              <td class="title" rowspan="4" width="4%"><br>
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
                                                  
              </td>
            </tr>
            
            <tr> 
              <td class="title" colspan="2">소계(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt'  readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly  class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
              
                 <td class='title'>&nbsp;=과부족 + 미납</td>
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
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(pp_s_amt+AddUtil.parseInt((String)base1.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
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
                <input type='text' name='rcon_mon'   size='3' value='<%=rcon_mon%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'> 개월&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day'  size='3' value='<%=rcon_day%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'> 일</td>
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
           
              <td>*위약금 적용요율은 계약서를 확인 <br><font color=red>*</font>해지위약금 차액이 발생시 영업효율대상자를 반드시 선택</td>
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
                <td class="title"><input type =hidden  name='tax_chk0' value='N' ><!--계산서발행의뢰-->              
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
                </td> 
            </tr>      
       
            <tr> 
              <td class="title" rowspan="6"><br>
                기<br>
                타</td> 
              <td colspan="2"  class="title">연체료(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' ></td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>
               <td class="title">&nbsp;</td>
          </tr>           
            
          <tr>  
              <td class="title" colspan="2">차량회수외주비용(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;<input type='hidden' name='tax_chk1' value='N' ></td>
            </tr>
            <tr> 
              <td class="title" colspan="2">차량회수부대비용(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>  
              <td class="title">&nbsp;<input type='hidden' name='tax_chk2' value='N' ></td>
            </tr>
            <tr> 
              <td colspan="2" class="title">잔존차량가격(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">기타손해배상금(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;
              <font color="#FF0000">*</font>보험가입면책금:&nbsp;<input type='text' class='num' name='car_ja' size='7' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' readonly >
              <input type='hidden' name='tax_chk3' value='N' ><!--계산서발행의뢰--></td>
            </tr>
            <tr> 
              <td class="title" colspan="2">초과운행대여료(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='0' size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1'   readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g'     value=''>
                <input type='hidden' name='tax_chk4'  value=''>
              <td class="title">&nbsp;<!--<input type='checkbox' name='tax_chk4' value='Y'  onClick="javascript:set_vat_amt(this);">계산서발행의뢰 --></td>   
            </tr> 
                              
            <tr> 
              <td class="title" colspan="3">부가세(N)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='' readonly size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='' readonly size='15' class='num' ></td>  
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
                <input type='text' name='fdft_amt1' value='' readonly  size='15' class='num' ></td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='' readonly  size='15' class='num' ></td>  
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M+N)&nbsp;&nbsp;
               <br>※ 계산서:&nbsp;             
               <input type="radio" name="tax_reg_gu" value="N" checked >항목별개별발행
               <input type="radio" name="tax_reg_gu" value="Y" >항목별통합발행(1장)
           <!--    <input type="radio" name="tax_reg_gu" value="Z" >대여료통합포함청구 -->
              </td>
            </tr>
          </table>
        </td>
         
    </tr>
    <tr></tr><tr></tr><tr></tr>
     <tr>
        <td class=h></td>
    </tr>  
    <!-- 선수금 정산 추가 - 20150706  fm.c_amt.value > 0 보다 큰 경우-->
    <tr id=tr_jung style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
		   <tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정산</span></td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		  
		   <tr> 
		        <td colspan="2" class='line'> 
		          <table border="0" cellspacing="1" cellpadding="0" width=100%>
		            <tr> 
			            <td width='10%' class='title'>정산구분</td>
			            <td colspan=5>&nbsp;<input type="radio" name="jung_st" value="1" onClick='javascript:cls_display4()'>합산정산
	                            <input type="radio" name="jung_st" value="2"  onClick='javascript:cls_display4()'>구분정산</td>
	              
	                    </tr>
		           <tr> 
		                <td class="title" rowspan=3 width='10%'>구분</td>                
		              <td class="title"  rowspan=3  width='12%'>합산정산(상계)</td>
		              <td class="title"  colspan="3"  width='35%'>구분정산</td>
		              <td class="title" rowspan=3  width='43%'>적요</td>
		            </tr>
		            <tr> 
		               <td class="title" rowspan=2 width='14%'>환불</td>
		               <td class="title" colspan=2 >청구</td>
		            </tr>
		              <tr> 
		               <td class="title" >금액</td>
		               <td class="title" >구분</td>
		            </tr>
		            <tr> 
		              <td class="title"  >선납금액</td>   
		              <td>&nbsp; <input type='text' name='h1_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td>&nbsp; <input type='text' name='h4_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td align="center" >&nbsp; </td>
		              <td align="left" >&nbsp;</td>
		              <td align="left"  rowspan=3>&nbsp;</td> 
		             </tr>
		                <tr> 
		              <td class="title"  >미납입금액</td>   
		              <td>&nbsp; <input type='text' name='h2_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td>&nbsp;</td>
		              <td align="center" >&nbsp;<input type='text' name='h6_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td align="left" >&nbsp; <select name='h_st'>
			                <option value="">--선택--</option>
			                <option value="1" >계약자</option>
		                         <option value="2" >운전자</option>
		                         <option value="3" >기타</option>
			              </select>
		              </td>
		             </tr>
		              <tr> 
		              <td class="title"  >정산금액</td>   
		              <td>&nbsp; <input type='text' name='h3_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td>&nbsp; <input type='text' name='h5_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td align="center" >&nbsp;<input type='text' name='h7_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '> </td>
		              <td align="left" >&nbsp;입금예정일: <input type='text' name='h_ip_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
		             </tr>
		             </table>
		            </td>
		      </tr> 
		   </table>
      </td>	 
    </tr>	     
     <tr></tr><tr></tr><tr></tr>   
	
    <tr>    
           <td colspan="2" class='line'> 
		          <table border="0" cellspacing="1" cellpadding="0" width=100%>
		            <tr>
	                    <td class=title width='10%' >고객납입금액</td>
	                    <td>&nbsp;<input type='text' name='fdft_amt2'  size='15' class='num' readonly  ></td>	
	                                     
	                    <% if ( h_cms.get("CBNO") == null  ) {%>
	                    <td colspan=6 width=60%>&nbsp;※ 미납입금액계 - 환불금액계</td>
	                    <input type='hidden' name='cms_chk' value='N' >
	                    <% } else { %> 
	                   	<td>&nbsp;※ 미납입금액계 - 환불금액계</td>                
	                  	<td class=title width='10%'>	                  
	                  	<input type='checkbox' name='cms_chk' value='Y' >CMS인출의뢰</td>
	                  	<td colspan=3>&nbsp;부분인출금액&nbsp;<input type='text' name='cms_amt'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '><font color=red>※ 부분 CMS인출의뢰인 경우에 한해서 부분인출금액을 입력하세요.!!! (전체의뢰인 경우는  부분인출금액 입력 불필요!!!!)</font> </td>	                  		                   
	                 	<td  >&nbsp;<input type='checkbox' name='cms_after' value='Y' ><font color="red">CMS 확인후 처리</font></td>   	                    	
	                    <% } %>	                    
	              </tr>
	              
		            <tr> 
			            <td width='10%' class='title'>환불</td>
			            <td colspan=7>&nbsp;
			            <input type="radio" name="refund_st" value="1" >예치금전액환불/별도정산			           
			                &nbsp;&nbsp;&nbsp; <input type="radio" name="refund_st" value="2"  >정산후잔액환불 
	                   </td>	              
	              </tr>
	              <tr> 
			            <td width='10%' class='title' rowspan=2>유보</td>
			            <td colspan=7  >&nbsp;<input type="checkbox" name="delay_st" value="Y" >정산후잔액환불 유보(선택)
	                      &nbsp;&nbsp;&nbsp;<input type="radio" name="delay_type" value="1"  >1. 타계약건과 합산후 환불
			                   &nbsp;&nbsp;&nbsp;<input type="radio" name="delay_type" value="2" >2. 고객의 사정
			                   &nbsp;&nbsp;&nbsp;<input type="radio" name="delay_type" value="3" >3. 기타
	                  </td>	           
	              </tr>
	               <tr> 			          
			            <td colspan=8 >&nbsp;&nbsp;&nbsp;<font color=red><b>유보할 사유 구체적 내용:</b></font>&nbsp;<textarea name="delay_desc"  cols="105" class="text" style="IME-MODE: active" rows="2"></textarea>			           
	                  </td>
	               </tr>     
	       		          
              </table>
         </td>       
    <tr>
    
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> 해지정산금을 CMS로 인출하고자할 경우는 CMS인출의뢰에 check 하세요. </td>
    </tr>    
  
    <tr></tr><tr></tr><tr></tr>
    
   	<tr> 
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td  class=title width=12%>연체료감액<br>결재자</td>
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
			                <option value="000028">김진좌</option>
			                <option value="000005">정채달</option>
			                <option value="000026">김광수</option>
			           		           
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
                
       <!--         
                 <tr>
                	<td  class=title width=10%>선수금후불처리결재자</td>
                    <td  width=12%>&nbsp;
						  <select name='ext_saction_id'>
			                <option value="">--선택--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>후불처리사유</td>
                    <td colspan=3>&nbsp;<textarea name="ext_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 				  
                </tr>
          -->      
         
              </table>
         </td>       
    </tr>
    
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> 중도해지 위약금의 감액 관련해서는 사전에 영업팀장의 결재를 득해야 합니다. 이경우 중도해지위약금 감액 결재자 필수항목입니다.</td>
    </tr>
<!--
       <tr>
        <td>&nbsp;<font color="#FF0000">***</font> 선수금 후불처리 관련해서는 사전에 총무팀장의 결재를 득해야 합니다.</td>
    </tr> -->
    
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
   
     <tr></tr><tr></tr><tr></tr>
     
      <!-- 초과운행부담금에 한함  block none-->
   
   	<tr id=tr_over style="display:'none'"> 
   	    <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> 환급/초과운행 대여료[공급가]</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	 	 	
 	 	   <tr> 
 	      <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="5"  width='34%'>구분</td>
              <td class="title" width='20%'>내용</td>                
              <td class="title" width='46%'>적요</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="7" >계<br>약<br>사<br>항</td>   
              <td class="title"  rowspan=4>기<br>준</td>
              <td class="title"  colspan=3>계약기간</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
              <td align="left" >&nbsp;당초계약기간</td>
             </tr>
             <tr> 
              <td class="title" rowspan=3>운행<br>거리<br>약정</td>
              <td class="title"  colspan=2>연간약정거리 (가)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title" rowspan=2>단가<br>(1km) </td>
              <td class="title" >환급대여료 (a1)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getRtn_run_amt() )%>원</td>
              <td align="left" >&nbsp;약정거리 이하운행</td>
             </tr>            
             <tr> 
              <td class="title" >초과운행대여료(a2)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>원</td>
               <td align="left" >&nbsp;약정거리 초과운행</td>
            </tr>           
            <tr> 
              <td class="title"  rowspan=3>정<br>산</td>
              <td class="title"  rowspan=2>이용<br>기간</td>  
              <td class="title"  colspan=2 >실이용기간	</td>     
              <td align="center">&nbsp;</td>
              <td align="left" >&nbsp;실제대여기간</td>
            </tr>   
            <tr> 
              <td class="title"  colspan=2 >실이용일수	(나)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("RENT_DAYS")))%>' size='7' class='whitenum' > 일 </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title"  colspan=3 >약정거리(한도)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(가)x(나) / 365</td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >운<br>행<br>거<br>리</td>      
              <td class="title"  rowspan=3>기<br>준</td>
              <td class="title"  colspan=3 >최초주행거리계(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value = '<%=AddUtil.parseDecimal(car1.getSh_km() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;신차(고객 인도시점 주행거리) , 보유차 (계약서에 명시된 주행거리)</td>
             </tr>   
             <tr> 
              <td class="title"  colspan=3>최종주행거리계(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title"  colspan=3 >실운행거리(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
             <tr> 
              <td class="title"  rowspan=3>정<br>산</td>
              <td class="title"   colspan=3 >정산기준운행거리	(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly    size='7' class='whitenum' > km</td> 
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title"   colspan=3 >기본공제거리</td>
            <% if (  AddUtil.parseInt(base.getRent_dt()) > 20220414 ) { %>             
              <td align="right" >&nbsp;±1,000 km</td>
            <% } else { %>
              <td align="right" >&nbsp;1,000 km</td>
            <% }  %>  
                <td align="left" >&nbsp;<input type='hidden' name='add_dist'  readonly class='whitenum' > </td>
             </tr>      
              <tr> 
              <td class="title"  colspan=3 >대여료정산기준운행거리	(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly    size='7' class='whitenum' > km</td>
               <% if (  AddUtil.parseInt(base.getRent_dt())  > 20220414 ) { %>  
              <td align="left" >&nbsp;(g)가 ±1,000km 이내이면 미정산(0km) , (g)가  ±1,000km가 아니면 (g)±기본공제거리 </td>
                <% } else { %>
               <td align="left" >&nbsp;</td> 
                <% }  %>
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>대<br>여<br>료</td>
              <td class="title"  rowspan=2>조<br>정</td>
              <td class="title"  colspan=3 >산출금액(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly    size='10' class='whitenum' >원</td>
              <td align="left" >&nbsp;(b)가  0km 미만이면 (a1)*(b), (b)가 1km이상이면 (a2)*(b)</td>
             </tr>
             <tr> 
              <td class="title"   colspan=3 >가감액(i)</td>
              <td align="right"><input type='text' name='m_over_amt'   size='10' class='num'   onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> 원</td>
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
              <td class="title"  colspan=4 >정산(부과/환급예정)금액</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly    size='10' class='whitenum' >원</td>
              <td align="left" >&nbsp;=(h)-(i), 환급(-)</td>
             </tr>  
            </table>
           </td>
       
         </tr>         
  
     	</table>
      </td>	 
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
			                    <td width="3%" rowspan="3" class=title>신용<br>조사</td>
			                   <td class=title width=12%>조사일자</td>
			                    <td width=13%>&nbsp;<input type='text' name='exam_dt'  size='12' class='text' ' onBlur='javascript: this.value = ChangeDate(this.value);'></td> 
			                    <td class=title width=12%>조사담당자</td>
			                    <td >&nbsp;
			                      <select name='exam_id'>
			                              <option value="">선택</option>
			                      
			                           <%	if(user_size > 0){
							for(int i = 0 ; i < user_size ; i++){
								Hashtable user = (Hashtable)users.elementAt(i); %>
	               						 <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
	  
				                <%		}
									}%>
							  </select>
	              			</td>		                 
			            </tr>
	               		   <tr>		            
			                     <td class=title width=12%>조사방법</td>
			                     <td  colspan=3>&nbsp;
			                       <INPUT TYPE="checkbox" NAME=s_gu1  value='Y'   > 1) 사업장방문
	                                          <INPUT TYPE="checkbox" NAME=s_gu2  value="Y" > 2) 사업자등록관계열람
	                                          <INPUT TYPE="checkbox" NAME=s_gu3  value="Y" > 3) 전화통화
	                                          <INPUT TYPE="checkbox" NAME=s_gu4  value="Y" > 4) 기타( <input type='text' name=s_remark'  size=70' class='text' >   )                                 
			                     </td>		               
			            </tr>
			             <tr>		            
			                     <td class=title width=12%>결과</td>
			                    <td  colspan=3>&nbsp;<textarea name="s_result" cols="120" class="text" style="IME-MODE: active" rows="2"></textarea>
			                   </td>					                       
			            </tr>
				        
		            </table>
		        </td>
	   	 </tr>
    	   <tr></tr><tr></tr><tr></tr><tr></tr>
   	 
    	      <tr>
      		   <td><img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle><span class=style2> 보증인 </span>
 	 		    (<input type='radio' name="guar_st" value='1'   <%if(guar_cnt > 0  ){%>checked<%}%>>
        				유
        			  <input type='radio' name="guar_st" value='0'  <%if( guar_cnt < 1  ){%>checked<%}%>>
        				무 ) 
 	 			</td> 
 	      </tr>    
    
 	            <!-- 대표연대보증등 -->
<% if(gur_size > 0){
				for(int i = 0 ; i < gur_size ; i++){
					Hashtable gur = (Hashtable)gurs.elementAt(i); %>   					
    	
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%> 	
		          <tr>		            
		                    <td width="3%" rowspan="4" class=title>보<br>증</td>
		                   <td class=title width=12%>성명</td>
		                   <input type='hidden' name='gu_seq' value='<%=i%>'  > 
		                    <td width=13%>&nbsp;<input type='text' name='gu_nm' value='<%=gur.get("GUR_NM")%>' size='15' class='text' > </td>
		                    <td class=title width=12%>계약자와관계</td>
		                    <td width=13%>&nbsp;<input type='text' name='gu_rel' value='<%=gur.get("GUR_REL")%>' size='15' class='text' ></td>
		                     <td class=title width=12%>연락처</td>
		                    <td width=13%>&nbsp;<input type='text' name='gu_tel' value='<%=gur.get("GUR_TEL")%>' size='15' class='text' ></td>
		            </tr>
               		   <tr>		            
		                     <td class=title width=12%>주소</td>
		                    <td  colspan=5>&nbsp;<input type='text' name='gu_zip' value='<%=gur.get("GUR_ZIP")%>' size='8' class='text' >&nbsp;<input type='text' name='gu_addr' value='<%=gur.get("GUR_ADDR")%>' size='100' class='text' > </td>		               
		            </tr>
		             <tr>		            
		                     <td class=title width=12%>상환계획</td>
		                    <td  colspan=2>&nbsp;<input type='radio' name="plan_st<%=i%>" value='Y' >있음 <input type='radio' name="plan_st<%=i%>" value='N' >없음 </td>	
		                    <td class=title width=12%>보증인의 실효구분</td>
		                    <td  colspan=2>&nbsp;<input type='radio' name="eff_st<%=i%>" value='Y' >있음 <input type='radio' name="eff_st<%=i%>" value='N' >없음 </td>		               
		            </tr>
		              <tr>		            
		                     <td class=title width=12%>없음의근거</td>
		                    <td  colspan=2>&nbsp;<input type='text' name='plan_rem' value='' size='50'  maxlength=200  class='text' > </td>	
		                    <td class=title width=12%>없음의근거</td>
		                    <td  colspan=2>&nbsp;<input type='text' name='eff_rem' value='' size='50' maxlength=200 class='text' > </td>		               
		            </tr>
		    	       </table>
		      </td>     
             </tr>        
             <% }
  }             %> 		          
	                     
    	   <tr></tr><tr></tr><tr></tr><tr></tr>
    	   <tr>
      		   <td><img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle><span class=style2> 보증보험 </span>
 	 		     ( <input type='radio' name="gi_st" value='1'  <%if(gins.getGi_st().equals("1")){%> checked <%}%>>
                  		유
                  		<input type='radio' name="gi_st" value='0'  <%if(gins.getGi_st().equals("0")){%> checked <%}%>>
                  		무 )  
 	 	</td> 
 	      </tr>    
    	   
    	     <tr>
 	 	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr>
		                    <td class=title width=12%>보증보험</td>
		                    <td class=title width=13%>보험금액</td>
		                    <td width=17%>&nbsp;<input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                    <td class=title width=12%>청구채권</td>
		                    <td width=17%>&nbsp;<input type='text' name='gi_c_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'></td>
		                    <td class=title width=12%>잔존채권</td>
		                    <td width=17%>&nbsp;<input type='text' name='gi_j_amt' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		            </tr>                               
                		  </table>
		   </td>        
         	 </tr>   	
             <tr></tr><tr></tr><tr></tr><tr></tr>
             
    	     <tr>
 	 	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
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
	                    <td class=title width=10%>권리분석</td>
	                     <td class=title width=8%>우선순위</td>
	                    <td class=title width=60%>처리의견/지시사항/사유</td>	                  
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
	                     <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu1" value='Y' >유
                  		 <input type='radio' name="crd_req_gu1" value='N' > 무
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri1' size='1' class='text' ></td>
	                    <td>&nbsp;<input type='text' name='crd_remark1' size='100' class='text' ></td>	                 
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
	                     <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu2" value='Y' >유
                  		 <input type='radio' name="crd_req_gu2" value='N' > 무
                  		 </td>
                  		  <td align=center> &nbsp;<input type='text' name='crd_pri2' size='1' class='text' ></td>
	                    <td>&nbsp;<input type='text' name='crd_remark2' size='100' class='text' ></td>
	                  
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
	                   <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu3" value='Y' >유
                  		 <input type='radio' name="crd_req_gu3" value='N' > 무
                  		 </td>
                  		  <td align=center> &nbsp;<input type='text' name='crd_pri3' size='1' class='text' ></td>
	                    <td>&nbsp;<input type='text' name='crd_remark3' size='100' class='text' ></td>
	                   
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
	                     <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu4" value='Y' >유
                  		 <input type='radio' name="crd_req_gu4" value='N' > 무
                  		 </td>
                  		  <td align=center> &nbsp;<input type='text' name='crd_pri4' size='1' class='text' ></td>
	                    <td>&nbsp;<input type='text' name='crd_remark4' size='100' class='text' ></td>
	                  
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
	                          <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu5" value='Y' >유
                  		 <input type='radio' name="crd_req_gu5" value='N' > 무
                  		 </td>
                  		  <td align=center> &nbsp;<input type='text' name='crd_pri5' size='1' class='text' ></td>
	                    <td>&nbsp;<input type='text' name='crd_remark5' size='100' class='text' ></td>
	                  
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
	                          <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu6" value='Y' >유
                  		 <input type='radio' name="crd_req_gu6" value='N' > 무
                  		 </td>
                  		  <td align=center> &nbsp;<input type='text' name='crd_pri6' size='1' class='text' ></td>
	                    <td>&nbsp;<input type='text' name='crd_remark6' size='100' class='text' ></td>
	                  
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
					             <!-- <option value="2">분납</option> -->
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
    
    <!-- 환불금액이 있는 경우에 한함 -->
   
   	<tr id=tr_refund style="display:''"> 
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
                        <td width=35%>&nbsp; <input type="text" name="re_acc_no" value="" size="30" class=text  onkeyup='removeChar(event);' onkeydown='return onlyNumber(event)'></td>
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
        
   	<tr id=tr_scd_ext style="display:''"> 
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
 	 	 	 	  	 	 	
 		fm.cls_msg.value="";
 	// 	alert(fm.r_day.value);
 	 	//총사용일수 초기 셋팅		
		if(fm.r_day.value == '30'){
			fm.r_mon.value = toInt(fm.r_mon.value) + 1;
			fm.r_day.value = '0';			
		}
		
		  //총대여기간(r_mon, r_day,), 잔여기간 등 계산   - 20191219 먼저 계산 
	 	if(fm.r_day.value != '0'){	 		
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후
					
			} else { //대여개월수가 일자가 있더라.. 잔여대여기간계산 수정2010-07-06  - 30일기준으로 계산  - 		
			 	  if (	toInt(fm.r_day.value) + toInt(fm.rcon_day.value) == 31 ) {
			 		//  if ( toInt(fm.rent_start_dt.value) <= 20170420 ) {	//20170420이후 사용일+1에 따라서 31일이 있을 수 있음.		 		
				    	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
			 		//  }	
				  } else  if (toInt(fm.r_day.value) + toInt(fm.rcon_day.value) < 30 ) {
					
				    	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);	
				  }
			}				
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
		
				//출고전해지(신차)인 경우 매출취소 setting
		if ( fm.cls_st.value == '7' || fm.cls_st.value == '10') { //출고전해지(신차) , 재리스(개시전해지)
			fm.cancel_yn.value = 'Y';
			td_cancel_n.style.display 		= 'none';  //매출유지
			td_cancel_y.style.display 		= '';  //매출취소
			tr_sale.style.display 		= 'none';  //차량매각시 고객납입금액
		}
					
		//초과운행부담금	
		if ( <%= o_amt%> > 0 ) {
			tr_over.style.display 		= '';  //초과운행부담금
						
			if ( fm.car_gu.value == '1' )  { //신차인 경우는 연장, 또는 승계를 해도 처음 계약건으로 - 정산은 안하고 진행되기에 -20190315 
				 fm.first_dist.value='<%=car1.getSh_km()%>';		
			}  else {	 
				if (<%=car1.getOver_bas_km()%>  > 0 ) {
					 fm.first_dist.value='<%=car1.getOver_bas_km()%>';	
				} else {
					 fm.first_dist.value='<%=car1.getSh_km()%>';	
				}	
		    }
		 	
			//신차인 경우는 일단 	
			fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.first_dist.value))   );	
		}
					
		<% if  ( fuel_cnt > 0 && return_remark.equals("싼타페")  ) {%>
 			fm.cls_cau.value="싼타페 연비보상 대상 차량";
 			
		   var s1_str = fm.rent_start_dt.value;
		   var e1_str = fm.cls_dt.value;
		   var  count1 = 0;
								   
		   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
		   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
				
		   var diff1_date = e1_date.getTime()  - s1_date.getTime();			
	
		   count1 = Math.floor(diff1_date/(24*60*60*1000)) ;	
 						
 	 		fm.remark.value = "싼타페 연비보상 대상 차량  80,000/365*" +count1 ; // 30일자가 아닌 실사용일수로 변경
 	 		
 	 	//	santafe_amt = 80000/365 *( ( toInt(parseDigit(fm.r_mon.value)) * 30 ) +   toInt(parseDigit(fm.r_day.value)) );
 	 		santafe_amt = 80000/365 * count1;
 	 	//	alert(santafe_amt);	 	 	 
 	 	     	 	     	 	 	 	 	          	 	     	 	 	 	 	          	 	    
 	 	   if ( fm.r_mon.value == '36' && fm.r_day.value == '0' )  	 	santafe_amt = 240000;	 
 	 	   if ( fm.r_mon.value == '48' && fm.r_day.value == '0' )  	 	santafe_amt = 320000;	 	 	          
 	 	 	 
 	 		if ( santafe_amt > 400000) {
 	 			santafe_amt = 400000;
 	 		}  
 	 		
 	 		//3년이면 240000, 4년이면 320000, 5년이상:400000 	 		
 	 		fm.etc3_amt_1.value = parseDecimal(santafe_amt * (-1) ); 	 		
 	 
 		<% }%> 	 
 		
 		<% if  ( fuel_cnt > 0 && return_remark.equals("볼보")  ) {%>
			fm.cls_cau.value="볼보 연비보상 대상 차량";
			
			var s1_str = fm.rent_start_dt.value;
		   var e1_str = fm.cls_dt.value;
		   var  count1 = 0;
								   
		   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
		   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
				
		   var diff1_date = e1_date.getTime()  - s1_date.getTime();			
	
		   count1 = Math.floor(diff1_date/(24*60*60*1000)) ;							   
			   
						
	 		fm.remark.value = "볼보 연비보상 대상 차량 259,750/365*" +count1 ; // 30일자가 아닌 실사용일수로 변경
	 		
	 	//	santafe_amt = 80000/365 *( ( toInt(parseDigit(fm.r_mon.value)) * 30 ) +   toInt(parseDigit(fm.r_day.value)) );
	 		santafe_amt = 259750/365 * count1;
	 	//	alert(santafe_amt);	 	 	 
	 	     	 	     	 	 	 	 	          	 	     	 	 	 	 	          	 	    
	 	   if ( fm.r_mon.value == '36' && fm.r_day.value == '0' )  	 	santafe_amt = 779250;	 
	 	   if ( fm.r_mon.value == '48' && fm.r_day.value == '0' )  	 	santafe_amt = 1039000;	 	 	          
	 	 	 	 	 	          	 	          	 	         	 	
	 		if ( santafe_amt > 1298748) {
	 			santafe_amt = 1298748;
	 		}  
	 		
	 		//3년이면 779250, 4년이면 1039000, 5년이상:1298748	 		
	 		fm.etc3_amt_1.value = parseDecimal(santafe_amt * (-1) ); 			
	 
		<% }%> 	 
		
		<% if  ( fuel_cnt > 0 && return_remark.equals("벤츠")  ) {%>
		fm.cls_cau.value="벤츠 연비보상 대상 차량";
		
		var s1_str = fm.rent_start_dt.value;
	   var e1_str = fm.cls_dt.value;
	   var  count1 = 0;
							   
	   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
	   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
			
	   var diff1_date = e1_date.getTime()  - s1_date.getTime();			

	   count1 = Math.floor(diff1_date/(24*60*60*1000)) ;							   
		   
					
 		fm.remark.value = "벤츠 연비보상 대상 차량 104,000/365*" +count1 ; // 30일자가 아닌 실사용일수로 변경
 		
 	//	santafe_amt = 80000/365 *( ( toInt(parseDigit(fm.r_mon.value)) * 30 ) +   toInt(parseDigit(fm.r_day.value)) );
 		santafe_amt = 104000/365 * count1;
 	//	alert(santafe_amt);	 	 	 
 	     	 	     	 	 	 	 	          	 	     	 	 	 	 	          	 	    
 	   if ( fm.r_mon.value == '36' && fm.r_day.value == '0' )  	 	santafe_amt = 312000;	 
 	   if ( fm.r_mon.value == '48' && fm.r_day.value == '0' )  	 	santafe_amt = 416000;	 	 	          
 	 	 	 	 	          	 	          	 	         	 	
 		if ( santafe_amt > 520000) {
 			santafe_amt = 520000;
 		}  
 		
 		//3년이면 312000, 4년이면 416000, 5년이상:520000		
 		fm.etc3_amt_1.value = parseDecimal(santafe_amt * (-1) ); 			
 
	<% }%> 	 
 			 		
		//잔여개시대여료  -- 연장에 따라 조건이 달라질 수 있음. ( ) :r_mon, r_day :이용기간  - 20200902 수정 :::
		if(toInt(fm.ifee_s_amt.value)  != 0){		
		//if(fm.ifee_s_amt.value != '0'){
				   	 
			ifee_tm = Math.round(( toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
		//	ifee_tm = parseDecimal(( toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
		//	alert(  ifee_tm );			
			pay_tm =  parseDecimal(toInt(fm.con_mon.value)-ifee_tm) ;
		
			//임의연장 후 연장하는 경우 
			if ( toInt(fm.fee_size.value) > 1 && toInt(fm.feecnt3.value) > 0 )  {
				alert("연장전 임의연장 스케쥴이 있으니  개시대여료 정산금액 확인 후 진행하세요!!!")
				pay_tm =  parseDecimal(toInt(fm.con_mon.value)-ifee_tm + toInt(fm.feecnt3.value) )  ;
			} 
		
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);  
				fm.ifee_day.value 	= fm.r_day.value;				
			} else {
			   	 fm.ifee_mon.value = "0";  //초기화
		   		 fm.ifee_day.value  = "0";			
			}
										
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) ); //잔여 개시대여료(
										
			v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //경과금액
			v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));				 										  //잔액
		  					
			if (v_rifee_s_amt == -1 || v_rifee_s_amt == 1 ) v_rifee_s_amt = 0;  //끝전			
				
	    	if ( fm.cls_st.value == '7' || fm.cls_st.value == '10') { //출고전해지(신차) , 재리스(개시전해지)
	  		} else {
				if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후  - 개시대여료 전체 다 공제됨
			    		
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
		if(toInt(fm.ifee_s_amt.value)  != 0){					
	//	if(fm.ifee_s_amt.value != '0'){
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
		if(toInt(fm.pp_s_amt.value)  != 0){				
	//	if(fm.pp_s_amt.value != '0'){							
			if ( fm.cls_st.value == '7' || fm.cls_st.value == '10') { //출고전해지(신차) , 재리스(개시전해지)
				fm.rfee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) );  //잔여선납금 (선납금액) -202104추가 
			} else {
			   if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기일	    		
			    	   fm.pded_s_amt.value 	= 0;
					   fm.tpded_s_amt.value 	= 0;
					   fm.rfee_s_amt.value 	= 0;
			    } else { 			
						fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.lfee_mon.value) );
						fm.rfee_s_amt.value     = parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );  //잔여대여기간으로 계산 - 20190827
						fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) ); 
			    }		
			}	
				
			//	fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.m_mon.value)+toInt(fm.m_day.value)/30) );  //선납금 공제총액
			//	fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value))   //잔여 선납금(
		   			
		}

			
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // 선납금액이 경과한 경우
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
						
	     //선납금액  
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
			   	    
		//미납입금액 정산 초기 셋팅		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}
				    
	  //개시대여료가 없는 경우 		 -- nnfee_s_amt : 미납금액(잔액아님). di_amt :잔액미납금액  	  -- 대여개시가 된 경우   
	  	if(toInt(fm.ifee_s_amt.value)  == 0){	
	//    if(fm.ifee_s_amt.value == '0' ) {
		   	 // 스케쥴생성보다 해지일이 더 큰 경우 		  	 		   	 
		    if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 		
		   	
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
		   	 
		   	 		      fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌
		   	 		      if ( toInt(fm.nfee_mon.value) < 0 ) {
						  	 	fm.nfee_mon.value = '0';
						  }
		   	 		     //만기후 스케쥴생성이 안됨 - 한달미만인 경우 
		   	 		   	  if ( toInt(fm.s_mon.value) == 0 &&  fm.nnfee_s_amt.value  == '0' ) {
						   		fm.nfee_day.value 	= 	fm.r_day.value;
						  }
		   	 		  } 
		   	 	
		   	}  else {//스케쥴이 있음. 
			   	 if  (  toInt(parseDigit(fm.di_amt.value))  > 0  ) { //미납이 있다면 (1개월 미만 미만 미납에 한해서 )
			   	//	 alert("c");
			   	     if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {
			   		  	if ( toInt(parseDigit(fm.hs_mon.value)) < 1  &&  toInt(parseDigit(fm.hs_day.value)) > 1 ) {  // 잔액 스케쥴에 해지일이 포함되는 경우
							fm.nfee_day.value = toInt(fm.hs_day.value); 
						}
			   	    }		
		         } 
	       } //스케쥴이 더 크면 
		} //개시대여료가 없는 경우	 	   		   		
			
		
		 //대여개시가 안된경우
	  	if(toInt(fm.rent_start_dt.value)  < 1){
				 fm.nfee_mon.value = ''; 
				 fm.nfee_day.value  =  ''; 			
		}		 
		
		 		//출고전해지,개시전해지  경우
		if ( fm.cls_st.value == '7'  || fm.cls_st.value == '10'   ) {
		  		 fm.nfee_mon.value = ''; 
				 fm.nfee_day.value  =  ''; 			
		}
								
		//미납금액  - 개시대여료가 있는 경우 개시대여료만큼 스케쥴이 미생성, 만기일 이후 스케쥴이 생성된 건이라면 생성된 스케쥴로 미납금액 계산하고,
		//            스케쥴 생성하지 않은 경우는 경과개시대료를 계산하여 미납금액을 계산함
		 				 
		//미납잔액이 있고 , 또 미납이 발생된 경우 
		if (  toInt(parseDigit(fm.di_amt.value)) > 0  ) {					  
		    if ( toInt(fm.s_mon.value) - 1  >= 0 ) {
		         fm.nfee_mon.value 	= 	 toInt(fm.s_mon.value) - 1;  //잔액이 있는 미납월을 제외함.		     
		    } 
		    
		}
		 
	 
		if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
   	   	    	if (  toInt(parseDigit(fm.di_amt.value)) > 0  &&  toInt(parseDigit(fm.nfee_amt.value)) == 0 ) {  //잔액이 있고 미납이 없다면      	   	    	
   	   	    	 
  	   	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {  //과부족이 보이면서 하단의 미납대여료도 중복으로 나오는 경우 - 20170324  	   	    				
  	   	    			//	fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );  //받을금액  - 받은금액    		
			      	 	    fm.nfee_amt.value = fm.nnfee_s_amt.value;    
			      	 	  //  fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
			      	 	 //   fm.ex_di_v_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_v_amt.value))  -    toInt(parseDigit(fm.rc_v_amt.value)) );  //받을금액  - 받은금액    
							if (fm.nfee_amt.value == '0' ) {
				 	       			fm.nfee_day.value = 0;
				 	      	}
				 	 }  
				  	
   	   	       }   	   	   
        }  	   	
		 
	   	//회수일자 , 입고일자 비교 		
	   	if ( 	fm.reco_dt.value != '' ) {
			if ( Math.abs( toInt(replaceString("-","",fm.cls_dt.value)) -   toInt(replaceString("-","",fm.reco_dt.value)) )  >  7   ) { //만기일		  
							alert("해지일자와 회수일자가 1주일 이상 차이납니다. 회수일자를 확인하세요.!!");
			}
		}
	 
	   /*	
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
	 */
	
	 //대여료가 100이하인 경우 별도 처리 - 2011-01-24.	- 선납으로만 처리
		if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
			   if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
			   		fm.nfee_day.value = '0';
			   } 
				fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		} else {
				fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		}
	    
		//20200117 - 이중계산되는  경우  - 20210729 위치조정 
	   	if (  toInt(parseDigit(fm.di_amt.value)) > 0 ) {  //잔액이 있다면 	   	 
	    	   if ( toInt(parseDigit(fm.hs_mon.value)) < 1  &&  toInt(parseDigit(fm.hs_day.value)) < 1 ) {  // 잔액 스케쥴에 해지일이 포함되는 경우
	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1  ) {  //과부족이 보이면서 하단의 미납대여료도 중복으로 나오는 경우 - 20170324
	    	             fm.ex_di_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.s_mon.value)+toInt(fm.s_day.value)/30) );		
	    	        
	    	             if ( toInt(parseDigit(fm.ex_di_amt.value)) == toInt(parseDigit(fm.nfee_amt.value)) ) {  //계산된 금액이 같다면 
	    	            	  fm.ex_di_amt.value  = '0';  
	    	             }  	    	  
			      	
			      	 //	 fm.nfee_amt.value = fm.nnfee_s_amt.value; 
	    	              fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );	
			      	 	 
				  }   	    	   
			   }
	   	}
	  
			//마지막회차인경우(일수 계산을 한경우)는 스케쥴에 남아있는 금액으로 처리 ..		
		if(toInt(fm.ifee_s_amt.value)  == 0){		
	 //	if (fm.ifee_s_amt.value == '0' ) {	
		   	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   		if ( (toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_oe_dt .value)) ||  (toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value)) ) {  //계약기간과  임위연장전 스케쥴 만기와 같으면		 
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
	  //	if(fm.ifee_s_amt.value != '0' ) {
	  	if(toInt(fm.ifee_s_amt.value)  != 0){	
	  		
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
						 //  	 } else {
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
	  		  
	  	 
	 		//출고전대차이면서 지연대차있는 경우
		if ( fm.cls_st.value == '7' &&  fm.prv_dlv_yn[1].checked == true  ) {
			
			 fm.nfee_mon.value 	= "0";	
			 fm.nfee_day.value 	= "0";	
			 fm.nfee_amt.value  = "0";	
			 //지연대차 미납대여료는 과부족으로 처리한다.
			 
			 if  ( toInt(parseDigit(fm.nnfee_s_amt.value)) > 0 && fm.r_con_mon.value == '0') {
				  fm.ex_di_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nnfee_s_amt.value)));
				  fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
			 }			 
		} 
	 	
				 
		 //선납대여료시 30일기준 계산???  -
		 //계산 //총사용일수 초기 셋팅		//잔여대여료 일수로 다시 계산 ( 
		// 환불일 경우)  rcon_mon, rcon_day:잔여대여기간  r_mon, r_day :이용기간 			
		
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
			
		fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) ); //대여료계(F)	  							 	    
	 
		fm.nfee_amt_1.value 		= fm.nfee_amt.value; 
		fm.ex_di_amt_1.value 		= fm.ex_di_amt.value; 		    
		fm.ex_di_v_amt_1.value 		= fm.ex_di_v_amt.value; 
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
			
			
		if (  toInt(fm.rent_start_dt.value) < 1 ) {
			fm.dft_amt.value 			= "0"; 
			fm.dft_amt_1.value 			= "0";	
		} else {	
			if ( fm.cls_st.value == '7' || fm.cls_st.value == '10' ) { //출고전해지(신차)인 경우 해지위약금 0
				fm.dft_amt.value 			= "0"; 
				fm.dft_amt_1.value 			= "0";			
			} else { 	
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );			
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			}	
	   }
			
		//선납이 있는 경우 대여료 환산 		
		if(toInt(parseDigit(fm.nfee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			if ( toInt(fm.rent_end_dt.value)  < toInt(replaceString("-","",fm.cls_dt.value)) ) {	                
				//만기이후 
				if( toInt(parseDigit(fm.rcon_mon.value)) < 1  && toInt(parseDigit(fm.rcon_day.value)) < 1 ){
					alert("!!!!!!!월대여료와 중도해지위약금 월대여료(환산)이 틀립니다.!!!!!!\n\n미납이 있는 경우 반드시 대여료 스케쥴 확인 후 미납금액을 계산하여 별도 적용하세요!!!");		
					print_view();
				}	
			}
		}
						
		//각각 부가세 계산하여 더한다.	 		
		var no_v_amt =0;  //부가세는 무조건 계산
		var no_v_amt1 =0;  //부가세는 무조건 계산
		
		var c_fee_v_amt =  0;
		
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		
		// 부가세 맞추기 - 20190904 - 잔액이 아닌 미납금액이 같다면 (한회차인 경우)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
	    	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));		   
 	    }	
		
		var   c_pp_s_amt = 0;
		var   c_rfee_s_amt = 0;
		var   c_over_s_amt = 0;
		
		c_pp_s_amt   = toInt(parseDigit(fm.rfee_s_amt.value))*0.1;
		c_rfee_s_amt = toInt(parseDigit(fm.rifee_s_amt.value))*0.1;
		c_over_s_amt = toInt(parseDigit(fm.over_amt_1.value)) * 0.1;
		
	   if ( fm.cls_st.value == '7'  ||  fm.cls_st.value == '10' ) {  //출고전해지. 개시전해지 - 계산시 부가세 틀린경우가 있음 	       
	       c_pp_s_amt =  toInt(parseDigit(fm.pp_amt.value)) -  toInt(parseDigit(fm.pp_s_amt.value)); 
	   	   c_rfee_s_amt = toInt(parseDigit(fm.ifee_amt.value)) -  toInt(parseDigit(fm.ifee_s_amt.value)); 
	   }
					
		//각각 부가세 계산하여 더한다.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt -  c_pp_s_amt  -  c_rfee_s_amt ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt  + c_over_s_amt -  c_pp_s_amt  -  c_rfee_s_amt ;
		
	//  부가세 저장 - 20220420 추가 
	    fm.rifee_v_amt.value =  parseDecimal( toInt(c_rfee_s_amt) )  ;  //개시대여료 
	    fm.rfee_v_amt.value =   parseDecimal( toInt(c_pp_s_amt) ) ;    //선납금 
	    
	    fm.dfee_v_amt.value 	=   parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );  //당초 대여료 부가세 
	    fm.dfee_v_amt_1.value 	=   parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt );  //확정 대여료 부가세 
	    
	    fm.over_v_amt.value =   '0';  //당초 초과운행 부가세 
	    fm.over_v_amt_1.value =  parseDecimal( toInt(c_over_s_amt) ) ; ;  //확정 초과운행 부가세 
	    		
	 
	 //대여료 부가세 저장 -- 20180525  ( 과부족(과입금) + 미납대여료) 
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
					
		set_tax_init();	
	
	/*	2022-04-20 계산서 더이상 발행안함 
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
		*/
		
        //미납금액계
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value))  + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));
				
		//확정금액 보여주기
		fm.dly_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dly_amt.value))) ;
		fm.dft_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dft_amt.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
	
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) +  toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)) );	 //확정금액	
							
		//고객이 납입할 금액 초기 셋팅	(매입옵션금액은 표시 안함)		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
			    
					    
		//돌려줄 금액이 있다면
		if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
			 tr_refund.style.display		= '';	//환불정보
			 tr_scd_ext.style.display		= '';	//잔존해지정산금
		} else {
			 tr_refund.style.display		= 'none';	//환불정보
			 tr_scd_ext.style.display		= 'none';	//잔존해지정산금
		}				
	}
	
	//세금계산서
	function set_tax_init(){
		var fm = document.form1;
		
	/*	2022-04-20 계산서 더 이상 발행안함 	
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
<script>
<%if (second_plate.getSecond_plate_yn().equals("Y")) {%>
alert("보조번호판이 발급된 차량입니다.\n영업관리>계출관리>보조번호판관리 메뉴에서 확인해주세요.");
<%}%>
</script>
</body>
</html>