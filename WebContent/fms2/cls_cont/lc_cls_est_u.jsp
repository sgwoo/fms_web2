<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*,  acar.receive.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.credit.*, acar.fee.*, acar.car_sche.*, acar.doc_settle.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "08", "05");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
		
		
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
		
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
	
		//fee 기타 - 주행거리 초과분 계산  - fee_etc 의  over_run_amt > 0보다 큰 경우 해당됨
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	ClsEtcOverBean co = ac_db.getClsEstOver(rent_mng_id, rent_l_cd);
	
	
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
		//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();	
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//담당자 리스트
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
		
		//해지의뢰정보
	ClsEstBean cls = ac_db.getClsEstCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st();
	
		
	//기본정보
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls.getCls_dt(), "");
		
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;			
					
	//마지막 세금계산서
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
	
	int re_day= ac_db.getRemainFeeDay(rent_l_cd, fee_tm, cls.getCls_dt());
	
	from_page = "/fms2/cls_cont/lc_cls_est_u.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
		
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
	
	//해지정산 리스트
	Vector vt_ext = as_db.getClsList(base.getClient_id());
	int vt_size = vt_ext.size();
	
		//싼타페등 연비보상
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id() , "N" );		
				
	Hashtable  return1 =   new Hashtable();	
 
	String return_remark = "";
	
	//   싼타페 , 혼다는 매입옵션일때만 해당 
   if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "N");	
	  	return_remark = (String)return1.get("REMARK");
  }
  
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "CLS_ETC";
	String content_seq  = rent_mng_id+""+rent_l_cd;

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	
	
	//기타손해배상금 증빙체크	
     	content_seq  = rent_mng_id+""+rent_l_cd+"2";
     attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
     int attach2_vt_size =  attach_vt.size();	
          
     //현금수령인경우 체크	
     	content_seq  = rent_mng_id+""+rent_l_cd+"4";
     attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
     int attach4_vt_size =  attach_vt.size();	
    
        //car_price 
  	int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  - car.getDc_cs_amt() - car.getDc_cv_amt(); 

	float f_opt_per = 0;     
		
	ClsEtcAddBean clsa 	= ac_db.getClsEstAddInfo(rent_mng_id, rent_l_cd);
	
	int vt_size8 = 0;
		
	Vector vts8 = ac_db.getClsEstDetailList(rent_mng_id,  rent_l_cd);
	vt_size8 = vts8.size(); 	
	
	 CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;   	
	
%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
	var popObj = null;
<!--

//스캔관리 보기
	function view_scan(m_id, l_cd){	
	  window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
		
	}		
			
	//자동차양도증명서 인쇄
	function opt_print(){
		var fm = document.form1;
	
		var SUBWIN="/acar/off_ls_after/car_transfer_certificate.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=820, height=600, resizable=yes, scrollbars=yes, status=yes");
				
	}

//정산서 인쇄
	function cls_print(){
		var fm = document.form1;
	
		var SUBWIN="lc_cls_est_print.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=700, height=650, resizable=yes, scrollbars=yes, status=yes");
				
	}

//리스트
	function list(){
		var fm = document.form1;			
	
		fm.action = 'lc_cls_est_frame.jsp';	
		fm.target = 'd_content';
		fm.submit();
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
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//대여요금
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=50, top=50, width=850, height=675, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//임의연장 계약서
	function view_scan_res2(c_id, m_id, l_cd){
		window.open("/fms2/lc_rent/lc_im_doc_print.jsp?c_id="+c_id+"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&mode=fine_doc", "VIEW_SCAN_RES2", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}	
				
	//결재전 삭제
	function sac_delete() {
		var fm = document.form1;
					
		if(confirm('사전정산서를 삭제하시겠습니까?')){	
			fm.action='lc_cls_est_d_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}	
		
	}	
		
	
	//디스플레이 타입
	function cls_display(){
		var fm = document.form1;
	
		fm.fdft_amt3.value='0';
			
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //매입옵션 선택시 디스플레이
			tr_opt.style.display 		= '';  //매입옵션			
			tr_sale.style.display		= '';	//차량매각시 고객납입액
		
		} else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '7'){ //출고전해지(신차) 선택시 디스플레이
	
			tr_opt.style.display 		= 'none';	//매입옵션			
			tr_sale.style.display		= 'none';	//차량매각시 고객납입액				
		}else{
			tr_opt.style.display 		= 'none';	//매입옵션		
			tr_sale.style.display		= 'none';	//차량매각시 고객납입액			
			
		}
				
		set_init();
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
		fm.fdft_amt3.value='0';  //차량매각
	   		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){
			fm.opt_per.value=fm.mopt_per.value;
			fm.opt_amt.value=fm.mopt_amt.value;
			set_sui_amt();
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
	   //고객납입금이 0보다 적은 경우: 돌려줄 돈이 있는 경우만 매출유지할 수 있음.
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[1].selected = true;
			alert('중도해지정산금액이 '+fm.fdft_amt2.value+'원으로 환불해야 합니다. \n\n이와 같은 경우에는 매출취소만 가능합니다.');
			return;			
		}		
	}	
			
	//선납금액 정산 : 자동계산
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
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
				
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // 선납금액이 경과한 경우 (계약기간이 경과한 경우 - 연장계약없이 )
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
								
		obj.value=parseDecimal(obj.value);
	
		if(obj == fm.nfee_mon || obj == fm.nfee_day){ //미납입대여료 기간
										
			//잔여개시대여료 
			if(fm.ifee_s_amt.value != '0'){
				ifee_tm = parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			//	ifee_tm = toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value)) ;
				
				pay_tm = toInt(fm.con_mon.value)-ifee_tm;
				if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
					fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
					fm.ifee_day.value 	= fm.r_day.value;
				}
			
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
						
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //경과금액
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //잔액
							
			}
			
			  //개시대여료가 다 경과한 경우 잔여개시대여료는 미납대여료에서 처리
		    if(fm.ifee_s_amt.value != '0') {
	    	 
		    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 
		    		
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 
		      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
		    	}   
		    }		
			
				//대여 스케쥴이 생성안되고, 미납이 없는 경우 scd_fee가 없어서 nfee_mon, nfee_day 구할수 없음.
		   if(fm.ifee_s_amt.value == '0' ) {	
			   if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성이 안된 경우 
				 if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { 
				   	     //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
			   	 // 	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
			   	 	  if (toInt(fm.r_con_mon.value) > 0) {  
			   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //해지일 - 만기일의 개월 수
			   	  	  } else {  //만기전해지인 경우  (개시대여료가 있는 경우)
			   	  	  	 fm.nfee_mon.value = '0';
			   	  	  } 
			   	   	  
			   	   	  if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_e_dt.value) ) { // 만기일과 스케쥴 만기일 비교	   	  	  	    	  	   
		  	   	     	fm.nfee_day.value 	= 	fm.r_day.value;
		  	   	   	  } 
		  	   	   	  
		  	   	   	  if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) {	  	   	      	     
				  	   	   var s1_str = fm.use_e_dt.value;
						   var e1_str = fm.cls_dt.value;
						   var  count1 = 0;
							
						   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1, s1_str.substring(6,8) );
						   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );
				
						   var diff1_date = e1_date.getTime() - s1_date.getTime();
				
						   count1 = Math.floor(diff1_date/(24*60*60*1000));
							
				  	   	   if ( count1 >= 0 ) { // 대여료만기일과 정산일 비교 (실제연체일수 계산)	   	  	  	    	  	   
				  	   	     fm.nfee_day.value 	= 	count1;
				  	   	   } 
				  	  }	  	   	   	 
				 }
				
			  } else { //만기이후 스테쥴 생성이 된 경우
		   
			      if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 없는 경우
				   	     //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
				   	 
			   	//  	   if (toInt(fm.r_con_mon.value) > 0) {  
				//   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //해지일 - 만기일의 개월 수
				//   	   } else {  //만기전해지인 경우  (개시대여료가 있는 경우)
				//   	  	  	 fm.nfee_mon.value = '0';
				 //  	   } 
		   	  	  
		   	  	  	   if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) { // 만기일과 스케쥴 만기일 비교	   	  	  	    	  	   
			  	   	     fm.nfee_day.value 	= 	fm.r_day.value;
			  	   	   } 			   
			      }
			  }		
				
			}			
			
							
			//미납금액  - 개시대여료가 있는 경우 개시대여료만큼 스케쥴이 미생성, 만기일 이후 스케쥴이 생성된 건이라면 생성된 스케쥴로 미납금액 계산하고,
			//            스케쥴 생성하지 않은 경우는 경과개시대료를 계산하여 미납금액을 계산함
							 
		    fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
	
			// 개시대여료 있는 경우에 한함. (해지일이 대여기간을 경과한 경우에 한함 )
		   	if(fm.ifee_s_amt.value != '0' ) {
								
		   		if (v_rifee_s_amt < 0) {  //개시대여료를 다 소진한 경우
		   	    	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
						
			   	    if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
			   	    //       alert(" 개시대여료 소진, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// 총미납료에서 - 개시대여료 공제
			   	       }else {
			   	      //     alert(" 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우
			   	       //	   alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
			   	           fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// 총미납료에서 - 개시대여료 공제   	   
			   	    
			   	      
			   	      }else {
			   	       //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
			   	       	   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_rifee_s_amt ) ; 
			   	      	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
			   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
			   	       }
			   	   }
			    } else {  //개시대여료가 남아있는 경우
			        if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
			   	    //   	   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// 총미납료에서 - 개시대여료 공제
			   	       }else {
			   	    //       alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우
			   	     //      alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
			   	           fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// 총미납료에서 - 개시대여료 공제   	   
			   	      }else {
			   	     //      alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이없는 경우");
			   	       	   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ; 
			   	
			   	       }
			   	    }
			    }   
		   	} 		   		 	
						
		}
				
			//과부족 및 과입금관련 vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} 
		
		if ( fm.ex_di_amt_1.value == fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = fm.ex_di_v_amt.value ;
		}
			
		//vat계산 (대여료)
		var no_v_amt = 0;
	
	  //  no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
	   	no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)   + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)      -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		 	     
		var no_v_amt2 	 = no_v_amt;
		
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
		
	//	if ( fm.tax_chk4.checked == true) {
	//			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
	//			 
	//	}	
			
	//	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
			
		set_cls_s_amt();
	}	
			
	//미납 중도해지위약금 정산 : 자동계산
	function set_cls_amt3(obj){
		var fm = document.form1;
	//	obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //잔여대여계약기간
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
			}
		}else if(obj == fm.dft_int_1){ //위약금 적용요율
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			
			}			
		}
		
		//fm.dfee_amt.value					= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		
		set_cls_s_amt();
	}
	
			
	
	//이전등록비용(매입옵션)
	function set_sui_c_amt(){
	
		var fm = document.form1;
							
		if (fm.cls_st.value  == '8' ) {
		  fm.dft_amt.value = '0'; //중도해지위약금
		  fm.dft_amt_1.value = '0'; //중도해지위약금확정
		}  
				
		set_cls_s_amt();
	
	}	
	
	//이전등록비용(매입옵션)
	function set_sui_amt(){
	
		var fm = document.form1;
				
	//	fm.sui_d_amt.value 		= parseDecimal( hun_th_rnd(toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value))));
				
		set_cls_s_amt();	
	}	
						
	//확정금액 셋팅
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
			
	//	}else if(obj == fm.over_amt_1){ //초과운행부담금 감액		 
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
		  } else {
		 		fm.over_amt.value =  '0';  
				fm.over_amt_1.value =  '0' ;  			
				fm.tax_supply[4].value 	=  '0';					
				fm.tax_chk4.value  = 'N' ;
				fm.tax_value[4].value 	= '0';		  		  
		  }		
						
		}	
								
		var no_v_amt = 0;
		
		//각각 부가세 계산하여 더한다.	 
	
	//	 no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		 no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  +   ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1) -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt) );				
		
		/*
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
		
	//	if ( fm.tax_chk4.checked == true) {
	//			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
	//			 
	//	}		
			
		set_cls_s_amt();
						
		//채무관련 보기
		if ( toInt(parseDigit(fm.fdft_amt2.value)) > 0)	{	
			tr_get.style.display		= '';	//채무자자구책
		} else {
		
			tr_get.style.display		= 'none';	//채무자자구책
		}		
			
	}	
	
	//확정금액 셋팅
	function set_cls_s_amt(){
		var fm = document.form1;	
							
	//	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	//  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
	  	fm.dfee_amt.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) +  toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))   + toInt(parseDigit(fm.over_amt.value))   + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) +  toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))   + toInt(parseDigit(fm.over_amt_1.value))   + toInt(parseDigit(fm.no_v_amt_1.value)));	 //확정금액	
			
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
		
	
	//보증보험청구잔액
	function set_gi_amt(){
		var fm = document.form1;
		
		if ( toInt(parseDigit(fm.gi_c_amt.value))  > 0  ) {
			if ( toInt(parseDigit(fm.fdft_amt2.value))  > 0  ) {
				fm.gi_j_amt.value 		= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.gi_c_amt.value)));
			}
		}
		if ( toInt(parseDigit(fm.gi_j_amt.value)) < 0  ) {
				fm.gi_j_amt.value  = "0";
		}
		
		fm.est_amt.value 		= fm.gi_j_amt.value;
		
	}	
	
	//차량회수비용
	function set_etc_amt(){
		var fm = document.form1;
		
		fm.etc_out_amt.value 		= parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)) + toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		fm.etc_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
	
		fm.etc_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		set_cls_s_amt();
			
	}
			
	
		//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/cls/"+theURL;
		popObj =window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}
			
	//변경된 해지일자로 다시 계산
	function set_day(){
		var fm = document.form1;	
		
		if(fm.cls_dt.value == ''){ 	alert('해지일자를 입력하십시오'); 	fm.cls_dt.focus(); 	return;	}
	
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}	
		
		fm.action='./lc_cls_c_nodisplay.jsp';						
				
		fm.target='i_no';
		fm.submit();
	}		
	
	//특이사항  보기
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
		//메일 보내기
	function sendMail(m_id, l_cd){
		window.open("/acar/car_rent/rent_email_reg.jsp?pur_email=cls_est&mtype=cls_est&m_id="+m_id+"&l_cd="+l_cd+"&br_id=S1", "RentDocEmail", "left=100, top=100, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
	//매입옵션안내문 메일발송 -사전정산서인 경우 
	function view_mail(m_id, l_cd){
			window.open("/acar/car_rent/rent_email_reg.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=S1&pur_email=pur_opt&mtype=est", "RentDocEmail", "left=100, top=100, width=1000, height=700, scrollbars=yes, status=yes");		
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
<input type='hidden' name='car_st' 	value='<%=base.getCar_st()%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name="fee_size"			value="<%=fee_size%>">    
<input type='hidden' name='rent_start_dt' value='<%=base1.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base1.get("RENT_END_DT")%>'>  
<input type='hidden' name='car_mng_id' value='<%=base1.get("CAR_MNG_ID")%>'>
<input type='hidden' name="mode" 			value="<%=mode%>">     
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 
<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'> 
<input type='hidden' name='car_no' value='<%=base1.get("CAR_NO")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
				
<input type='hidden' name='con_mon' value='<%=base1.get("CON_MON")%>'>

<input type='hidden' name="from_page" 	value="<%=from_page%>">

<input type='hidden' name='cls_s_amt' value='<%=AddUtil.parseDecimal(cls.getCls_s_amt())%>' >
<input type='hidden' name='cls_v_amt' value='<%=AddUtil.parseDecimal(cls.getCls_v_amt())%>' >
  
<input type='hidden' name="re_day" 		value="<%=re_day%>">  
<input type='hidden' name='car_ja_no_amt' value='<%=AddUtil.parseDecimal(cls.getCar_ja_no_amt())%>' >
 
<input type='hidden' name='ex_di_v_amt'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
<input type='hidden' name='ex_di_v_amt_1' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--만기일기준 경과계약기간 -->            

  <!--초과운행 거리 계산 -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='over_run_day' value='<%=car1.getOver_run_day()%>'>
  
<input type='hidden' name='sh_km' value=''>
  

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	 <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>영업지원 > 해지관리 ><span class=style5>사전정산서 품의</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    <!-- 사전정산서임을 표시 -->
    	<td align='right'> &nbsp;   
        <a href="javascript:sendMail('<%=rent_mng_id%>', '<%=rent_l_cd%>');"><img src="/acar/images/center/button_send_mail.gif" align=absmiddle border=0></a>&nbsp;   
        <a href='javascript:cls_print();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_print_jss.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
	    </td>
	</tr>
	  
	<tr> 
        <td class=line2></td>
    </tr>	
  
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>계약번호</td>
            <td width=22%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;<a href="javascript:view_cng_etc('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='특이사항'><img src=/acar/images/center/button_tish.gif align=absmiddle border=0></a>
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
            <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차 <%}else if(rent_st.equals("4")){%>증차 <%}%></td>
            <td class=title>영업구분</td>
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷 <%}else if(bus_st.equals("2")){%>영업사원 <%}else if(bus_st.equals("3")){%>업체소개 <%}else if(bus_st.equals("4")){%>catalog <%}else if(bus_st.equals("5")){%>전화상담 <%}else if(bus_st.equals("6")){%>기존업체 <%}else if(bus_st.equals("7")){%>에이전트 <%}else if(bus_st.equals("8")){%>모바일 <%}%></td>
          </tr>
          <tr> 
            <td class=title>차량구분</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스 <%}else if(car_gu.equals("1")){%>신차 <%}else if(car_gu.equals("2")){%>중고차 <%}%></td>
            <td class=title>용도구분</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트 <%}else if(car_st.equals("2")){%> 예비 <%}else if(car_st.equals("3")){%> 리스 <%}else if(car_st.equals("5")){%>업무대여 <%}%></td>
            <td class=title>관리구분</td>
            <td>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식 <%}%></td>
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
            <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a></td>
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
				
				s_opt_per = fees.getOpt_per();
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
            <td style="font-size : 9pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계 <%}else if(fees.getGrt_suc_yn().equals("1")){%>별도 <%}else{%>-<%}%></td>			
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계 <%}else if(fees.getIfee_suc_yn().equals("1")){%>별도 <%}else{%>-<%}%></td>
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
	
		<%if(im_vt_size>0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>임의연장</span> <a href="javascript:view_scan_res2('<%=base.getCar_mng_id()%>','<%=base.getRent_mng_id()%>','<%=base.getRent_l_cd()%>')" onMouseOver="window.status=''; return true"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="임의계약서 보기"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">연번</td>
                    <td class=title width="20%">회차</td>			
                    <td class=title width="37%">대여기간</td>
                    <td class=title width="15%">등록자</td>
                    <td class=title width="15%">등록일</td>                    
                  </tr>
        		  <%	for(int i = 0 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=im_ht.get("ADD_TM")%>회차</td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
                    <td align='center'><%=im_ht.get("USER_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("REG_DT")))%></td>
                  </tr>
        		  <%	} %>
            </table>
        </td>
    </tr>				
    <tr>
        <td class=h></td>
    </tr>			
	<%}%>	
	
	<tr>
	  <td style='height:1; background-color=d2d2d2;' ></td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
	 <tr> 
 	 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지내역&nbsp;
 			 
 		 </span></td>
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
			  <select name="cls_st" disabled >
			    <option value="1" <%if(cls.getCls_st().equals("계약만료"))%>selected<%%>>계약만료</option>          
                <option value="2" <%if(cls.getCls_st().equals("중도해약"))%>selected<%%>>중도해약</option>
                <option value="7" <%if(cls.getCls_st().equals("출고전해지(신차)"))%>selected<%%>>출고전해지(신차)</option>
                <option value="8" <%if(cls.getCls_st().equals("매입옵션"))%>selected<%%>>매입옵션</option>   
                <option value="10" <%if(cls.getCls_st().equals("개시전해지(재리스)"))%>selected<%%>>개시전해지(재리스)</option>> 
		      </select> </td>
                      					  
            <td width='13%' class='title'>의뢰자</td>
            <td width="12%">&nbsp;
              <select name='reg_id'>
                <option value="">선택</option>
                <%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(cls.getReg_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
                <%		}
					}%>
              </select></td>	
                      
            <td width='13%' class='title'>해지일자</td>
            <td width="12%">&nbsp;
       <% if (user_id.equals("000063")) {%>     
			  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt() )%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'>
		<% } else { %>
		  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt())%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '>
		<% }%>	  
			  </td> 
		    <td width='12%' class='title'>이용기간</td>
		    <td width="12%" >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' value='<%=cls.getR_mon()%>' >개월&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=cls.getR_day()%>' >일&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>사유 </td>
            <td colspan="5">&nbsp;
              <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cls.getCls_cau()%></textarea>			
            </td>
              <td width="12%" class=title >만기매칭<br>대차여부</td>
     	    <td>&nbsp; 
		  <select name="match" >
		  <option value="" <% if(cls.getMatch().equals("")){%>selected<%}%>>--선택--</option>
                     <option value="Y" <% if(cls.getMatch().equals("Y")){%>selected<%}%>>만기매칭</option>           
              </select>
	    </td>
          </tr>
          <tr>                                                      
            <td class=title >잔여선납금<br>매출취소여부</td>
     	    <td>&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'>
                <option value="N" <% if(cls.getCancel_yn().equals("N")){%>selected<%}%>>매출유지</option>
                <option value="Y" <% if(cls.getCancel_yn().equals("Y")){%>selected<%}%>>매출취소</option>
              </select>
		    </td>
		
				<td  colspan="6" align=left>&nbsp;※ 기발행 계산서의 유지 또는 취소여부 등 확인이 필요, 매출취소시 마이너스 세금계산서 발행 </td>
          </tr>
           <tr>      
		            <td width='10%' class='title'>주행거리</td>
		            <td>&nbsp;
					  <input type='text' name='tot_dist' size='10' value='<%=AddUtil.parseDecimal(cls.getTot_dist())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km 
		            </td>
		            <td colspan=6   align=left>&nbsp;<%if( cls.getCls_st().equals("매입옵션") ) { %>※ 매입옵션시 차량주행거리 <% } else { %> ※ 중도해지 및 만기시 차량주행거리 <%} %> </td>	         
		           
		  			 </tr>     
        </table>
      </td>
    </tr>
    
       <tr></tr><tr></tr>    
       			         
         
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> 출고전해지, 개시전해지인 경우에 한해서 지점은 사전에 지점장결재를 득해야 합니다. 이경우 지점장 결재자 필수항목입니다.</td>
    </tr>  
      
    <tr>
    	<td>&nbsp;<font color="#FF0000">***</font> 만기매칭대차인경우는 만기매칭대차의 계약번호를 입력해주세요.!!  대차차량의 스케쥴을 확인해주세요.!!</td>    
     </tr> 
   
    <tr>
      <td>&nbsp;</td>
    </tr> 	 
    
    
     <tr id=tr_dae style="display:<%if( cls.getCls_st().equals("출고전해지(신차)") ){%>'' <%}else{%>none <%}%>"> 
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
                    <td width="10%" class=title >월대여료</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>원(vat포함) 
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
    
    
    <!-- 추후 수정 -->
    <tr id=tr_opt style="display:<%if( cls.getCls_st().equals("매입옵션") ){%>'' <%}else{%>none <%}%>"> 

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
		          <tr> 		          	
		          	<input type='hidden' name='mopt_per' value='<%=s_opt_per%>'>
		          	<input type='hidden' name='mopt_amt' value='<%=AddUtil.parseDecimal(s_opt_amt)%>'>
		          	<input type='hidden' name='mopt_s_amt' value='<%=s_opt_s_amt%>'>
		          	<input type='hidden' name='old_opt_amt' value='<%=clsa.getOld_opt_amt()%>'>
		          	
		 	 	     <td class='title' width="13%">매입옵션율</td>
		             <td width="13%">&nbsp;<input type='text' name='opt_per' value='<%=f_opt_per%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title' width="13%">매입옵션가</td>
		             <td colspan=5 >&nbsp;<input type='text' name='opt_amt'size='15' class='num' value="<%=AddUtil.parseDecimal(cls.getOpt_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_sui_c_amt();'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT포함)</td> 
		            
                  </tr>	
                 
                   <input type='hidden' name='sui_st'  value='N' >
                   <input type='hidden' name='sui_d_amt' value='0' >
		          </tr>  
		       </table>
		      </td>        
         </tr>  
        <%if (clsa.getMt().equals("1") ||  clsa.getMt().equals("2")) {%>  
        <tr>
        	<td>&nbsp;<font color="#FF0000">※</font> 매입옵션가 산출식</td>
    	</tr>
    	 <%if (clsa.getMt().equals("2")) {%>  
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= 연장전 매입옵션 - (연장계약 매입옵션 감가액  * 이용일수 / 연장계약일수)</td>
    	   </tr>
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= <%=AddUtil.parseDecimal(clsa.getB_old_opt_amt())%> - {(<%=AddUtil.parseDecimal(clsa.getB_old_opt_amt())%> -<%=AddUtil.parseDecimal(clsa.getOld_opt_amt())%>) * <%=clsa.getCount1()%> / <%=clsa.getCount2()%>}</td>
    	   </tr>
    	
    	 <% } else { %>
    	     <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= 계약시 매입옵션가격 * 현재가치율  + 자동차세,보험료 제외요금의 현재가치 합계</td>
    	   </tr>
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= <%=AddUtil.parseDecimal(clsa.getOld_opt_amt())%> * <%=clsa.getRc_rate()%> + <%=AddUtil.parseDecimal(clsa.getM_r_fee_amt())%></td>
    	   </tr>
    	 <% } %>
        <% } %>
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
		                    <input type='text' name='grt_amt' readonly value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
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
		                    <input type='text' size='3' name='ifee_mon' readonly  value='<%=cls.getIfee_mon()%>'  class='num' maxlength='4' >
		                    개월&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='<%=cls.getIfee_day()%>' class='num' maxlength='4' >
		                    일</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >경과금액</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' readonly value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' ></td>
		                  <td>=개시대여료×경과기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 개시대여료(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td class='title'>=개시대여료-경과금액</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">선<br>
		                    납<br>
		                    금</td>
		                  <td align='center'>월공제액 </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=선납금÷계약기간</td>
		                </tr>
		                <tr> 
		                  <td align='center'>선납금 공제총액 </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=월공제액×실이용기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 선납금(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td class='title'>=선납금-선납금 공제총액</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">계</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' ></td>
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
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납금액 정산</span>[공급가]</span></td>
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
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' ></td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num'  ></td>           
              <td class="title">&nbsp;</td>
             </tr>
             <tr> 
              <td class="title" colspan="3">자기차량손해면책금(E)</td>
              <td width='19%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' ></td>
              <td width='19%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>'   size='15' class='num'  ></td>                     
              <td width='40%' class="title">&nbsp;</td>
            </tr>
             <tr>
              <td class="title" rowspan="4" width="4%"><br>
                대<br>
                여<br>
                료</td>
              <td align="center" colspan="2" class="title">과부족</td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>'  size='15' class='num' ></td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>              
              <td>&nbsp;</td>
             
            </tr>
         
            <tr> 
              <td rowspan="2" align="center" class="title" width="4%">미<br>
                납</td>
              <td width='10%' align="center" class="title">기간</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' size='3' name='nfee_mon' value='<%=cls.getNfee_mon()%>' readonly class='num' maxlength='4' >
                개월&nbsp;&nbsp;&nbsp; 
                <input type='text' size='3' name='nfee_day' value='<%=cls.getNfee_day()%>'  readonly class='num' maxlength='4' >
                일</td>
              <td>&nbsp;     
              </td>
            </tr>
            <tr> 
              <td align="center" class="title">금액</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt'  readonly  value='<%=AddUtil.parseDecimal(cls.getNfee_amt())%>' class='num' ></td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>               
              <td>기발행계산서의 유지 또는 취소여부를 확인              
              </td>
            </tr>
            
            <tr> 
              <td class="title" colspan="2">소계(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt'  value='<%=AddUtil.parseDecimal(cls.getDfee_amt())%>' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly   value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
              
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
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=선납금+월대여료총액</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">월대여료(환산)</td>
              <td class='' colspan=2 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' ></td>
              <td>=대여료총액÷계약기간</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">잔여대여계약기간</td>
              <td class=''  colspan=2  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4' >
                개월&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day' readonly size='3' value='<%=cls.getRcon_day()%>' class='num' maxlength='4' >
                일</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">잔여기간 대여료 총액</td>
              <td class=''  colspan=2 align="center"> 
                <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' readonly size='15' class='num' ></td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> 위약금 
                적용요율</td>
              <td class='' align="center"> 
                <input type='text' readonly name='dft_int'  value='<%=cls.getDft_int()%>' size='5' class='num'  maxlength='5'>
                %</td>
              <td class='' align="center"> 
                <input type='text' name='dft_int_1'  value='<%=cls.getDft_int_1()%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='5'>
                %</td>  
              <td>*위약금 적용요율은 계약서를 확인 <br><font color=red>*</font>해지위약금 차액이 발생시 영업효율대상자를 반드시 선택</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">중도해지위약금(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' ></td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' onBlur='javascript:set_cls_amt(this)'></td>
                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_s())%>' size='15' class='num' >      
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' size='15' class='num' >            
                <input type='hidden' name='tax_g' size='20' class='text' value='중도해지 위약금'>
                <td class="title">&nbsp;<input type='checkbox' name='tax_chk0'  value='Y' <%if(cls.getTax_chk0().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled ><!--계산서발행의뢰-->
             	 &nbsp;<font color="#FF0000">*</font>영업효율대상자: 
                     <select name='dft_cost_id'>
		                <option value="">선택</option>
		                  <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                 <option value='<%=user.get("USER_ID")%>' <%if(cls.getDft_cost_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
		                 <%		}
						 	}%>							           
		              </select>                
                </td>
            </tr>      
       
            <tr> 
              <td class="title" rowspan="6"><br>
                기<br>
                타</td> 
              <td colspan="2" align="center" class="title">연체료(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getDly_amt())%>' size='15' class='num' ></td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1'  value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>             
              <td class='title'>&nbsp; </td>
            </tr>
            
              <td class="title" colspan="2">차량회수외주비용(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt())%>' size='15' class='num' ></td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_s())%>' size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_v())%>' size='15' class='num' >  
                <input type='hidden' name='tax_g' size='20' class='text' value='회수 차량외주비용'>
               <td class="title">&nbsp;<input type='checkbox' name='tax_chk1'  value='Y' <%if(cls.getTax_chk1().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled >계산서발행의뢰</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">차량회수부대비용(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>' size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_s())%>' size='15' class='num' > 
                <input type='hidden' name='tax_value' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_v())%>' size='15' class='num' >  
                <input type='hidden' name='tax_g' size='20' class='text' value='회수 부대비용'>
               <td class="title">&nbsp;<input type='checkbox' name='tax_chk2'  value='Y' <%if(cls.getTax_chk2().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled >계산서발행의뢰</td>
            </tr>
            <tr> 
              <td colspan="2" class="title">잔존차량가격(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>'size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td> 
            
              <td class="title">&nbsp;
              		<% if  ( fuel_cnt > 0   && return_remark.equals("싼타페") ) {%>
 							<font color="#FF0000">*</font> 연비보상 대상 차량
 				       <% } %>	
 				     	<% if  ( fuel_cnt > 0   && return_remark.equals("혼다")  &&  cls.getCls_st().equals("매입옵션") ) {%>
 							<font color="#FF0000">*</font> 혼다 특별보상 대상 차량
 				       <% } %>	              
              </td>
            </tr>
            <tr> 
              <td class="title" colspan="2">기타손해배상금(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>'  size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
               <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_s())%>' size='15' class='num' > 
               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' size='15' class='num' >  
               <input type='hidden' name='tax_g' size='20' class='text' value='기타손해배상금'>
              <td class="title">&nbsp;<input type='checkbox' name='tax_chk3' value='Y' <%if(cls.getTax_chk3().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);" disabled ><!--계산서발행의뢰 -->
              &nbsp;          
             <!-- 기타손해배상금이 있는 경우만 --> 
              <%if( cls.getEtc4_amt_1() > 0 ) {%>
                 
                 <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"2";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){   %>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPop('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>			
    						&nbsp;
    						<%}%>
    						                 
            <%}%></td>                                                        
            </tr>
            
            <tr> 
              <td class="title" colspan="2">초과운행대여료(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt())%>'  size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1'  readonly  value='<%=AddUtil.parseDecimal(cls.getOver_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>             
                <td class="title">&nbsp;<input type='checkbox' name='tax_chk4' value='Y' <%if(cls.getTax_chk4().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);" disabled >계산서발행의뢰</td>                                                    
            </tr>
            
                   
            <tr> 
              <td class="title" colspan="3">부가세(N)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt())%>' readonly size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>' readonly size='15' class='num' ></td> 
         
              <td> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td id=td_cancel_n style="display:<%if( cls.getCancel_yn().equals("N") ){%>none<%}else{%>'' <%}%>" class="title">=(F+M-B-C)×10% </td>
                    <td id=td_cancel_y style="display:<%if( cls.getCancel_yn().equals("Y") ){%>none<%}else{%>'' <%}%>" class='title'>=(F+M-B-C)×10% </td>
                  </tr>
                </table>
              </td>
            </tr>
            
            <tr> 
              <td class="title_p" colspan="4">계</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1'value='<%=AddUtil.parseDecimal(cls.getFdft_amt1())%>' readonly  size='15' class='num' ></td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' readonly  size='15' class='num' ></td>  
                
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M+N)&nbsp;&nbsp;
                <br>※ 계산서:&nbsp;              
               <input type="radio" name="tax_reg_gu" value="N"  <%if(cls.getTax_reg_gu().equals("N")){%>checked<%}%> >항목별청구
               <input type="radio" name="tax_reg_gu" value="Y"  <%if(cls.getTax_reg_gu().equals("Y")){%>checked<%}%> >항목합산청구
               <input type="radio" name="tax_reg_gu" value="Z"  <%if(cls.getTax_reg_gu().equals("Z")){%>checked<%}%> >대여료통합포함청구
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
                    <td class=title width=10%>고객납입금액</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2' readonly  value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>' size='15' class='num'  ></td>
                    <% if ( h_cms.get("CBNO") == null  ) {%>
                    <td colspan=6>&nbsp;※ 미납입금액계 - 환불금액계</td>
                    <% } else { %>    
              		<td class=title width=12% ><input type='checkbox' name='cms_chk' value='Y' <%if(cls.getCms_chk().equals("Y")){%>checked<%}%> >CMS인출의뢰</td>
                 	<td colspan=5>&nbsp;※ 미납입금액계 - 환불금액계</td>  
             		<% } %>        
              </tr>
             
              </table>
         </td>       
    <tr> 
  
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_sale style="display:<%if( cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >매입옵션시<br>고객납입금액</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt3'  value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>' size='15' class='num' readonly  ></td>
                    <td colspan=6>&nbsp;※ 고객납입금액  + 매입옵션가 + 이전등록비용(발생한 경우)</td>
              </tr>
                       
              </table>
         </td>       
    </tr> 
   
     <tr>
        <td class=h></td>
    </tr>
   
     <tr></tr><tr></tr><tr></tr>
      
    <!-- 중도정산서에 한함  block none  대여만기가 2개월이상 남았을 경우  -->
   
   <tr id=tr_cal_sale style="display:<%if( clsa.getOld_opt_amt() > 0  && fee_size == 1){%>''<%}else{%>none<%}%>"> 
    
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
         <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중도 정산서</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
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
              <td class="title"  width='16%' colspan=2>현재가치 산출 보조자료<br>(이자율: 년 <%=clsa.getA_f()%>%)</td>  
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
                           
<%	
		
	int t_fee_s_amt = 0;            
	int t_s_cal_amt = 0;
	int t_r_fee_s_amt = 0;
	int t_r_fee_v_amt = 0;
	int t_r_fee_amt = 0;
	
	int t_grt_amt = 0;
	int t_g_fee_amt = 0;	
	
	int s_g_fee_amt = 0;
	
					
	for(int i = 0 ; i < vt_size8 ; i++){
					Hashtable ht8 = (Hashtable)vts8.elementAt(i); 					
										
					t_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT")));
					t_s_cal_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_CAL_AMT")));
					t_r_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_S_AMT")));
					t_r_fee_v_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_V_AMT")));
					t_r_fee_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_AMT")));
					
					t_grt_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_GRT_AMT")));
					s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_G_FEE_AMT"))) ;
					
					if ( s_g_fee_amt < 1) s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT"))) ;
								
					t_g_fee_amt += s_g_fee_amt;											
					
%>       
	 		   <tr>
                    <td>&nbsp;<input type='text' name='s_fee_tm'  readonly value='<%=ht8.get("S_FEE_TM")%>' size='4' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_est_dt'  readonly value='<%=AddUtil.ChangeDate2(String.valueOf(ht8.get("S_R_FEE_EST_DT")))%>' size='12' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_fee_s_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_FEE_S_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_grt_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_GRT_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_g_fee_amt'  readonly value='<%=Util.parseDecimal(s_g_fee_amt)%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_tax_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_TAX_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_is_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_IS_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_cal_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_s_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_S_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_v_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_V_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_rc_rate'  readonly value='<%=AddUtil.parseFloat(String.valueOf(ht8.get("S_RC_RATE")))%>' size='10' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_cal_days'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_DAYS")))%>' size='8' class='num' > </td>
                                    
               </tr>
<% } %>
               
               <tr>
                    <td colspan="2" class=title>합계</td>
                    <td class=title><input type='text' name='t_fee_s_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_fee_s_amt)%>'></td>
                    <td class=title><input type='text' name='t_s_grt_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_grt_amt)%>'></td>
                    <td class=title><input type='text' name='t_s_g_fee_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_g_fee_amt)%>'></td>
                    <td class=title></td>
                    <td class=title></td>
                    <td class=title><input type='text' name='t_s_cal_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_s_cal_amt)%>'></td>
                    <td class=title><input type='text' name='t_r_fee_s_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_r_fee_s_amt)%>'></td>
                    <td class=title><input type='text' name='t_r_fee_v_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_r_fee_v_amt)%>'></td>
                    <td class=title><input type='text' name='t_r_fee_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_r_fee_amt)%>'></td>
                    <td class=title></td>
                    <td class=title></td>                   
                  
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
 <!--   <tr id=tr_over style="display:<%if( co.getRent_days() > 0 ){%>''<%}else{%>none<%}%>"> -->
    <tr id=tr_over style="display:<%if( co.getR_over_amt() != 0 ){%>''<%}else{%>none<%}%>">  
      
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
              <td align="center">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
              <td align="left" >&nbsp;실제대여기간</td>
            </tr>   
            <tr> 
              <td class="title"  colspan=2 >실이용일수	(나)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(co.getRent_days() )%>' size='7' class='whitenum' > 일 </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title"  colspan=3 >약정거리(한도)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7'  value='<%=AddUtil.parseDecimal(co.getCal_dist() )%>' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(가)x(나) / 365</td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >운<br>행<br>거<br>리</td>      
              <td class="title"  rowspan=3>기<br>준</td>
              <td class="title"  colspan=3 >최초주행거리계(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value='<%=AddUtil.parseDecimal(co.getFirst_dist() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;신차(고객 인도시점 주행거리) , 보유차 (계약서에 명시된 주행거리)</td>
             </tr>   
             <tr> 
              <td class="title"  colspan=3>최종주행거리계(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly value='<%=AddUtil.parseDecimal(co.getLast_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title"  colspan=3 >실운행거리(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly   value='<%=AddUtil.parseDecimal(co.getReal_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
             <tr> 
              <td class="title"  rowspan=3>정<br>산</td>
              <td class="title"   colspan=3 >정산기준운행거리	(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly   value='<%=AddUtil.parseDecimal(co.getOver_dist() )%>'   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title"   colspan=3 >기본공제거리</td>
               <% if (  AddUtil.parseInt(base.getRent_dt()) > 20220414 ) { %>             
              <td align="right" >&nbsp;±1,000 km</td>
            <% } else { %>
              <td align="right" >&nbsp;1,000 km</td>
            <% }  %>  
         
                <td align="left" >&nbsp;<input type='hidden' name='add_dist'  value='<%=AddUtil.parseDecimal(co.getAdd_dist() )%>'   readonly> </td>
             </tr>      
              <tr> 
              <td class="title"  colspan=3 >대여료정산기준운행거리	(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly value='<%=AddUtil.parseDecimal(co.getJung_dist() )%>'      size='7' class='whitenum' > km</td>
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
              <td align="right" ><input type='text' name='r_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getR_over_amt() )%>'     size='10' class='whitenum' >원</td>
              <td align="left" >&nbsp;(b)가  0km 미만이면 (a1)*(b), (b)가 1km이상이면 (a2)*(b)</td>
             </tr>
             <tr> 
              <td class="title"   colspan=3 >가감액(i)</td>
              <td align="right"><input type='text' name='m_over_amt'  value='<%=AddUtil.parseDecimal(co.getM_over_amt() )%>'      size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> 원</td>
              <td align="left" >&nbsp;결재자및사유:
              	   <select name='m_saction_id'>
			                <option value="">--선택--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(co.getM_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="m_reason" cols="55" class="text" style="IME-MODE: active" rows="2"><%=co.getM_reason()%></textarea> </td>
             </tr>      
             <tr> 
              <td class="title"  colspan=4 >정산(부과/환급예정)금액</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getJ_over_amt() )%>'     size='10' class='whitenum' >원</td>
              <td align="left" >&nbsp;=(h)-(i), 환급(-)</td>
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
      
      <%	//이행보증보험
			//	ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);
         		 ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
				
		%>
     <tr> 
          <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증보험 가입</span></td>
     </tr>
     
     <tr> 
          <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
              <tr> 
                <td class='title' width="10%"> 
                  <%if(gins.getGi_st().equals("1")){%>가입<%}else if(gins.getGi_st().equals("0")){ gins.setGi_amt(0);%>면제<%}%>
                </td>
                <td class='title' width="15%" align="center"> 
                  <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' maxlength='15'>
                  </td>
                <td class='title' width="65%"></td>
              </tr>
            </table>
          </td>
    </tr>
   
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>    
  
	<!-- 받을채권이 있는 경우 -->
 
	<tr id=tr_get style="display:''">
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채무자 자구책&nbsp;</span></td>
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
								    <option value="1" <%if(cls.getDiv_st().equals("일시납"))%>selected<%%>>일시납</option>
            					    <option value="2" <%if(cls.getDiv_st().equals("분납"))%>selected<%%>>분납</option>
					             
					              </select>             
					              <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                        <tr> 
					                          
					                           <td id='td_div' style="display:<%if( cls.getDiv_st().equals("분납")){%>''<%}else{%>none<%}%>">&nbsp;분납횟수&nbsp;  
					                             <select name="div_cnt">
												    <option value="">---선택---</option>
												    <option value="1" <%if(cls.getDiv_cnt() == 1)%>selected<%%>>1</option>
            					   					<option value="2" <%if(cls.getDiv_cnt() == 2)%>selected<%%>>2</option>
            					   				    <option value="3" <%if(cls.getDiv_cnt() == 3)%>selected<%%>>3</option>
            					   					<option value="4" <%if(cls.getDiv_cnt() == 4)%>selected<%%>>4</option>
            					   				    <option value="5" <%if(cls.getDiv_cnt() == 5)%>selected<%%>>5</option>
            					   					<option value="6" <%if(cls.getDiv_cnt() == 6)%>selected<%%>>6</option>
            					   				    <option value="7" <%if(cls.getDiv_cnt() == 7)%>selected<%%>>7</option>
            					   					<option value="8" <%if(cls.getDiv_cnt() == 8)%>selected<%%>>8</option>
            					   				    <option value="9" <%if(cls.getDiv_cnt() == 9)%>selected<%%>>9</option>
            					   				    <option value="10" <%if(cls.getDiv_cnt() == 10)%>selected<%%>>10</option>
            					   				    <option value="11" <%if(cls.getDiv_cnt() == 11)%>selected<%%>>11</option>
            					   				    <option value="12" <%if(cls.getDiv_cnt() == 12)%>selected<%%>>12</option>            					   					
									              </select>
					                            </td>
					                        </tr>
					                </table>
					         	</td>
					    	</tr>
					  
		                	<tr>
			                    <td class=title width=13%>내역</td>
			                    <td class=title width=12%>약정일</td>
			                    <td>&nbsp;<input type='text' name='est_dt' value='<%=cls.getEst_dt()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
			                    <td class=title width=12%>약정금액</td>
			                    <td>&nbsp;<input type='text' name='est_amt' value='<%=AddUtil.parseDecimal(cls.getEst_amt())%>'size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
			                    <td class=title width=12%>약정자</td>
			                    <td>&nbsp;<input type='text' name='est_nm' value='<%=cls.getEst_nm()%>' size='15' class='text'></td>
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
									      <td width=12%>&nbsp;<input type='text' value='<%=cls.getGur_nm()%>' name='gur_nm' size='15' class='text'></td>
						                  <td width=12% class=title>연락처</td>
						                  <td>&nbsp;<input type='text' name='gur_rel_tel' value='<%=cls.getGur_rel_tel()%>'  size='30' class='text'></td>
						                  <td width=12% class=title>계약자와의관계</td>  
						                  <td colspan=3>&nbsp;<input type='text' name='gur_rel' value='<%=cls.getGur_rel()%>'  size='30' class='text'></td>   
		           			             
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
					                    <td class=title style='height:44' width=13%>처리의견/지시사항/사유</td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="remark" cols="140" class="text" style="IME-MODE: active" rows="3"><%=cls.getRemark()%></textarea> 
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
	    <td align='center'>	
	         <a href="javascript:sac_delete();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>&nbsp; 
	    </td>
	</tr>			  
   
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
		
	function set_init(){
		
		var fm = document.form1;		
		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
	//	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));	
	//	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));	
					
	}		
	
//-->
</script>
</body>
</html>
