<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.receive.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.credit.*, acar.fee.*, acar.car_sche.*, acar.doc_settle.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="r_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="seBean" class="acar.offls_sui.Sui_etcBean" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "01", "08", "05"); }
		
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"2":request.getParameter("doc_bit");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String bit		 	= request.getParameter("bit")==null?"":request.getParameter("bit");
	
					
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
//	if(base.getUse_yn().equals("N"))		return;  //결재완료후도 메신저를 통해서 화면 보이게 

	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
//	int guar_cnt = 0;
//	if  (cont_etc.getClient_guar_st().equals("1") ) guar_cnt++;
//	if  (cont_etc.getGuar_st().equals("1") ) guar_cnt++;
	
	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	String print_nm = "";
	if ( client.getPrint_st().equals("2")) {
		print_nm = "거래처통합발행";
	} else if  ( client.getPrint_st().equals("3")) {
		print_nm = "지점통합발행";
	} else if (  client.getPrint_st().equals("4")) {
		print_nm = "현장통합발행";
	} else if  ( client.getPrint_st().equals("9")) {
		print_nm = "타시스템발행";
	}
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//출고지연대차
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
	
		//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
		
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//fee 기타 - 주행거리 초과분 계산  - fee_etc 의  over_run_amt > 0보다 큰 경우 해당됨
//	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1"); // 최초로 -20161219 초과운행부담금 중간정산을 하지 않기에  
	
	ClsEtcOverBean co = ac_db.getClsEtcOver(rent_mng_id, rent_l_cd);
	
//	 int o_p_m  =  (int)  car1.getAgree_dist() / 12 ;
//	 int o_p_d  =   (int)  car1.getAgree_dist() / 365 ;
	 
//	 int  o_amt =   car1.getOver_run_amt();
	 
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
		
		//담당자 리스트
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
	
		//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	
	String cls_st = cls.getCls_st_r();
	String term_yn = cls.getTerm_yn();
	int   fdft_amt2 =  cls.getFdft_amt2();
				
	//기본정보
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls.getCls_dt(), "");
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//연대보증인 
//	Vector gurs = a_db.getContGurList1(rent_mng_id,  rent_l_cd);
	Vector gurs = r_db.getClsCarGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
	int  ext_amt = 0;
			
	//해지기타 추가 정보
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);
		
	String m_m_id = c_db.getRent_mng_id(clsm.getMatch_l_cd());
	//만기매칭정보 -
	ContTaechaBean m_taecha = a_db.getTaecha(m_m_id, clsm.getMatch_l_cd(), "0");
	
	//해지의뢰상계정보
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);
	
	//차량회수정보
	CarRecoBean carReco = ac_db.getCarReco(rent_mng_id, rent_l_cd);
	
	//채권관리정보
	CarCreditBean carCre = ac_db.getCarCredit(rent_mng_id, rent_l_cd);
	
		// 선수금정산정보	
	ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);
			
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);

	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("11", rent_l_cd);
		doc_no = doc.getDoc_no();
	}else{
		doc = d_db.getDocSettle(doc_no);
	}
		
	//회계담당자부터는 전체내용조회	
		
	//영업담당자
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
		
	//네오엠 은행리스트
	CodeBean[] a_banks = neoe_db.getCodeAll();
	int a_bank_size = a_banks.length;
	
	//마지막 세금계산서
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
	int re_day = 0;
	
	Hashtable tax2= ac_db.getScdFeeTaxVatAmt(rent_mng_id, rent_l_cd, fee_tm); //마지막세금계산서 공급가, 부가세 구하기
	 
	if ( cls_st.equals("8" ) )  {
	     if (     AddUtil.parseInt( String.valueOf(base1.get("RENT_END_DT") ) )  <  AddUtil.parseInt( String.valueOf(base1.get("USE_S_DT") ) )     ) {  //만기일이후 스케쥴생성된 경우
						re_day = ac_db.getRemainFeeDay(rent_l_cd, fee_tm, cls.getCls_dt());  				
	     } else {
		        if (    AddUtil.parseInt(cls.getCls_dt() ) <  AddUtil.parseInt( String.valueOf(base1.get("USE_E_DT") ) )     ) {  //만기일이전 매입옵션을 처리하는 경우 만기일까지 대여료 계산서 처리.
		    		  re_day = ac_db.getRemainFeeDay(rent_l_cd, fee_tm,  String.valueOf(base1.get("USE_E_DT") ) );  		    	
		        } else {
		        		re_day = ac_db.getRemainFeeDay(rent_l_cd, fee_tm, cls.getCls_dt());          
		        } 
		 }        
	} else {
		re_day = ac_db.getRemainFeeDay(rent_l_cd, fee_tm, cls.getCls_dt());  
	}        

	
	Hashtable tax3 = new Hashtable();
	if (re_day < 0) {
	     int a_fee_tm = AddUtil.parseInt(fee_tm) + 1; 
		 tax3= ac_db.getScdFeeTaxVatAmt(rent_mng_id, rent_l_cd, Integer.toString(a_fee_tm) ); //마지막세금계산서발행다음회차  공급가, 부가세 구하기
	}
	//해지취소대여료가 있는 경우
	Hashtable ht_t = new Hashtable();
	 
	if (re_day > 0 ) {
	  ht_t = af_db.getUseMonDay(cls.getCls_dt(),  String.valueOf(tax2.get("USE_S_DT")) );
	} 
	 
	Hashtable tax1 = new Hashtable();
	//미발행세금계산서 - 매입옵션인 경우 2개월전부터 가능.  - use_e_dt : 스케쥴만기일 , rent_end_dt :계약만기일  
	if ( cls_st.equals("8" ) )  {
	        if (    AddUtil.parseInt(cls.getCls_dt() ) <  AddUtil.parseInt( String.valueOf(base1.get("USE_E_DT") ) )     ) {  //만기일이전 매입옵션을 처리하는 경우 만기일까지 대여료 계산서 처리.
	      	     tax1 = ac_db.getSettleTaxRemain(rent_mng_id, rent_l_cd, String.valueOf(base1.get("USE_E_DT") ), fee_tm );
	        } else {
	              tax1 = ac_db.getSettleTaxRemain(rent_mng_id, rent_l_cd, cls.getCls_dt(), fee_tm );
	        } 
	} else {
		 tax1 = ac_db.getSettleTaxRemain(rent_mng_id, rent_l_cd, cls.getCls_dt(), fee_tm );
	}
		
	
	//세금계산서 발행관련 - 해지정산시
	ClsEtcTaxBean ct = ac_db.getClsEtcTaxCase(rent_mng_id, rent_l_cd, 1);
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
	Vector cms_bnk = c_db.getCmsBank();	//은행명을 가져온다.
	int cms_bnk_size1 = cms_bnk.size();		
	
	int maeip_amt = 0;	 //매입옵션인 경우 대체입금 
	int m_ext_amt = 0;  //매입옵션인 경우 환불/잡이익 
		
	//출고지연대차관련 
	String tae_prv_dlv_yn = fee.getPrv_dlv_yn(); 
	
	int tae_cnt = 0;
	String tae_e_dt = "";
	
	if (tae_prv_dlv_yn.equals("Y")) {
		tae_cnt = ac_db.getClsEtcTaeChaCnt(rent_mng_id, rent_l_cd);
		
		if (tae_cnt > 0 ) {
		//기존대여스케줄 max(use_e_dt)
		 	 tae_e_dt = ac_db.getClsEtcTaeChaUseEndDt(rent_mng_id, rent_l_cd);
	  	} 	
	}
	
		//해지정산 리스트
	Vector vt_ext = as_db.getClsList(base.getClient_id(), rent_l_cd);
	int vt_size = vt_ext.size();
	
	
	//싼타페등 연비보상
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id(), "N" );		
	
	String return_remark = "";
	Hashtable  return1 =   new Hashtable();
	
	if (   fuel_cnt > 0   ) {     
		  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "N"); 	
		   	return_remark = (String)return1.get("REMARK");
	}
  	  	
	//사업장의 계속 
	ClsCarExamBean cce 	= r_db.getClsCarExam(rent_mng_id, rent_l_cd, 1);
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "CLS_ETC";
	String content_seq  = rent_mng_id+""+rent_l_cd;

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
	
	        //현금수령인경우 체크	
   	content_seq  = rent_mng_id+""+rent_l_cd+"4";
   attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
   int attach4_vt_size =  attach_vt.size();								
	
		    //car_price 
 	int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  - car.getDc_cs_amt() - car.getDc_cv_amt(); 
  
	float f_opt_per = 0;       
	
	ClsEtcAddBean clsa 	= ac_db.getClsEtcAddInfo(rent_mng_id, rent_l_cd);
	
	int vt_size8 = 0;
		
	Vector vts8 = ac_db.getClsEtcDetailList(rent_mng_id,  rent_l_cd);
	vt_size8 = vts8.size(); 	
     	

	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;   	
	
  //중도매입옵션 계산서 발행관련 
  Hashtable m_tax1 = new Hashtable();
  m_tax1 = ac_db.getSettleTaxRemain(rent_mng_id, rent_l_cd, Integer.parseInt(fee_tm) );	

	//cms 정보
	Hashtable h_cms = c_db.getCmsBank_info(rent_l_cd);
	
	String re_bank = "";
	String re_acc_no = "";
	String re_acc_nm = "";
		
	re_bank = (String)h_cms.get("CBNK");
	re_acc_no = (String) h_cms.get("CBNO");
	re_acc_nm = (String) h_cms.get("CYJ");	
	 		
	seBean = olsD.getSuiEtc(base.getCar_mng_id());		
	
	//만기매칭 대여기간 구하기 (function 사용처리 ) 	
	String m_ymd[] = new String[3]; 
			
	String rr_ymd =  ac_db.getBetweenYMD2(m_taecha.getCar_rent_et(), m_taecha.getCar_rent_st());
//		out.println(rr_ymd);		
	StringTokenizer token1 = new StringTokenizer(rr_ymd,"^");				
	while(token1.hasMoreTokens()) {			
				m_ymd[0] = token1.nextToken().trim();	//년
				m_ymd[1] = token1.nextToken().trim();	//월 
				m_ymd[2] = token1.nextToken().trim();	//일 
	}	
			
	String mm_mon = "";
	String mm_day  = "";
			
		//해지일이 계약기간 이후인 경우	 
	if  (AddUtil.parseInt(m_ymd[0]) < 0 ||  AddUtil.parseInt(m_ymd[1]) < 0 || AddUtil.parseInt(m_ymd[2]) < 0 ) {		
			mm_mon =  "";
			mm_day =  "";
	} else {
			mm_mon =  Integer.toString( AddUtil.parseInt(m_ymd[0])*12  + AddUtil.parseInt(m_ymd[1]));
			mm_day =  Integer.toString(  AddUtil.parseInt(m_ymd[2])) ;  	
	}     
		  		 					
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
	var popObj = null;
<!--

	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//기타 대여료스케줄관리로 이동	
	function move_fee_scd(){
		var fm = document.form1;	
		
		fm.action = "/fms2/con_fee/fee_scd_u_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>";
		fm.target = 'd_content';		
		fm.submit();							
	}
	
	
	//매입옵션안내문 메일발송
		function view_mail(m_id, l_cd){
			window.open("/acar/car_rent/rent_email_reg.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>"+"&pur_email=pur_opt", "RentDocEmail", "left=100, top=100, width=1000, height=700, scrollbars=yes, status=yes");		
		}
		
		//메일 보내기 - 매입옵션외  
		function sendMail(m_id, l_cd){
			window.open("/acar/car_rent/rent_email_reg.jsp?mtype=cls_etc&m_id="+m_id+"&l_cd="+l_cd+"&br_id=S1", "RentDocEmail", "left=100, top=100, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");		
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

		var SUBWIN="lc_cls_print.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=700, height=650, resizable=yes, scrollbars=yes, status=yes");
		
	}

	function cls_talk(){
		var fm = document.form1;
	
		var SUBWIN="/fms2/con_fee/credit_memo_sms.jsp?auth_rw=2&m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&cls_etc=Y";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=820, height=800, resizable=yes, scrollbars=yes, status=yes");
				
	}
	
//리스트
	function list(){
		var fm = document.form1;			
		if(fm.cls_st.value == '8'){
			fm.action =  'lc_cls_off_d_frame.jsp';
		}else{
			fm.action = 'lc_cls_d_frame.jsp';
		}
		fm.target = 'd_content';
		fm.submit();
	}	
		
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}
	
	function view_tel(m_id,l_cd)
	{
		window.open("/fms2/consignment_new/cons_tel_list_s.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_TEL", "left=100, top=100, width=820, height=600, scrollbars=yes");
	}
	
	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//대여요금
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=50, top=50, width=850, height=650, resizable=yes, scrollbars=yes, status=yes");
	}		
		
	function save(chk){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('해지구분을 선택하십시오'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('해지일자를 입력하십시오'); 		fm.cls_dt.focus(); 		return;	}
						
		//환불금액 + 추가 입금액 보다 상계금액이 큰경우 
		if( ( toInt(parseDigit(fm.c_amt.value))  + toInt(parseDigit(fm.ex_ip_amt.value)) +  toInt(parseDigit(fm.opt_ip_amt1.value)) +  toInt(parseDigit(fm.opt_ip_amt2.value)) -  toInt(parseDigit(fm.fdft_amt1_2.value)) )  < -1 ) {
			alert("환불가능한금액(매입옵션입금분포함) 한도내에서 상계할 수 있습니다.\n 상계금액을 조정하십시요.!!");
			return;
		}			
										
		//미납이 있는 경우 일자 계산 금액 확인용
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  >  0  ) {		
			if ( toInt(parseDigit(fm.tax_r_supply[3].value))  >  toInt(parseDigit(fm.dfee_amt_1.value)) ) {
				//alert(toInt(parseDigit(fm.tax_r_supply[3].value)));
				//alert(toInt(parseDigit(fm.dfee_amt_1.value)));
				//alert(toInt(parseDigit(fm.tax_rr_supply[3].value)));
				//alert(toInt(parseDigit(fm.nfee_amt_1.value)));
				if ( toInt(parseDigit(fm.tax_rr_supply[3].value)) <= toInt(parseDigit(fm.nfee_amt_1.value)) ) {
				}else {
					if(!confirm("미납대여료 계산서 발행금액을 확인하세요.!!"))	return;
				}	
		    }		
		}
				
		//매입옵션인 경우
		if (fm.cls_st.value  == '8' ) {	
			//환불금액 + 추가 입금액 보다 상계금액이 큰경우 
			
			if( ( toInt(parseDigit(fm.fdft_amt1_1.value))  !=  toInt(parseDigit(fm.fdft_amt1_2.value)) )  ) {
				alert("상계금액을 지정하셔야 합니다..!!");
				return;
			}
			
			//매입옵션 고객납입금액이 있는 경우 - 100까지 잡손실??
			if( toInt(parseDigit(fm.fdft_amt3.value)) > 100 ){ // 매입옵션 받을 금액이 있는 경우
				if(fm.opt_ip_amt1.value == ""){ alert("입금액을 입력하세요."); return; }
				if(fm.opt_ip_dt1.value == "") { alert("입금일을 입력하세요."); return; }	
			}		
		}		
		
		if( toInt(parseDigit(fm.ex_ip_amt.value)) > 0 ){
		
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;		
			
			if(deposit_no.indexOf(":") == -1){
				fm.deposit_no2.value = deposit_no;
			}else{
				var deposit_split = deposit_no.split(":");
				fm.deposit_no2.value = deposit_split[0];	
	 		}
	 		
	 		if(fm.bank_code.value == ""){ alert("은행을 선택하십시오."); return; }			
			if(fm.deposit_no.value == ""){ alert("계좌번호를 선택하십시오."); return; }		
 		} 	
 		
 		
 		if (fm.cls_st.value  == '8' ) {	
	 		if( toInt(parseDigit(fm.opt_ip_amt1.value)) != 0 ){ // 매입옵션
			
				var deposit_no = fm.opt_deposit_no1.options[fm.opt_deposit_no1.selectedIndex].value;		
				
				if(deposit_no.indexOf(":") == -1){
					fm.opt_deposit_no1_2.value = deposit_no;
				}else{
					var deposit_split = deposit_no.split(":");
					fm.opt_deposit_no1_2.value = deposit_split[0];	
		 		}		 
	 		} 			
	 			 		
	 		if( toInt(parseDigit(fm.opt_ip_amt2.value)) != 0 ){ //매입옵션
			
				var deposit_no = fm.opt_deposit_no2.options[fm.opt_deposit_no2.selectedIndex].value;		
				
				if(deposit_no.indexOf(":") == -1){
					fm.opt_deposit_no2_2.value = deposit_no;
				}else{
					var deposit_split = deposit_no.split(":");
					fm.opt_deposit_no2_2.value = deposit_split[0];	
		 		}
	 		} 					
		}		
			
		//출고전해지(신차)에서 출고지연대차 스케쥴확인 등
		if (fm.cls_st.value  == '7' || fm.cls_st.value  == '10' ) {					
			if( fm.tae_prv_dlv_yn.value  == 'Y'  ){ 		
				if( toInt(parseDigit(fm.tae_cnt.value)) < 1  ){ 						
					alert("출고전대차 스케쥴을 생성하세요.!!");
					return;					
				}	
				//해지일과 생성된 대차스케쥴 비교
			//	if ( toInt(fm.tae_e_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 
			//		alert("출고전대차 스케쥴을 생성하세요.!!");
			//		return;		
			//	}
				
				//미납금액표시로
			}	
		}
				
		if ( toInt(parseDigit(fm.tax_r_value[0].value)) !=  toInt(parseDigit(fm.rifee_amt_2_v.value)) ) {	
			alert("잔여개시대여료 상계 부가세를 확인하세요.!!");
			return;	
		}
		
		if ( toInt(parseDigit(fm.tax_r_value[1].value)) !=  toInt(parseDigit(fm.rfee_amt_2_v.value)) ) {	
			alert("잔여선납금 상계 부가세를 확인하세요.!!");
			return;	
		}
			
		//연체료 및 중도해지 위약금이 차이가 발생한 경우 사유 입력 check
		if( fm.dly_saction_id.value != '' ) {
			if (fm.cls_st.value  == '7' || fm.cls_st.value  == '10' ) {	
			} else {	
		
			}						
		}
		
			
	 //계산서 발행 체크관련  - 마이너스가 있는 경우 
		 if ( fm.tax_reg_gu[1].checked == true ) {	     
		      if ( toInt(parseDigit(fm.tax_r_supply[0].value)) < 0 || toInt(parseDigit(fm.tax_r_supply[1].value)) < 0 || toInt(parseDigit(fm.tax_r_supply[1].value)) <0 ) {
		         	 	alert("해당건은 계산서 항목별통합발행(1장)을 할 수 없습니다..!!");
						return;	 
		      }
		       
		 }
		
		//마이너스 계산서 발행 불가 항목없는 경우 check
<%		for (int i = 0; i <  3 ; i++) { %>		
	
				if ( fm.tax_r_chk<%=i%>.checked == true   ) {
					alert(" <%=i+1%>번 계산서 발행은 원계산서를 찾아서 수정발행하세요.!!!");
					return;
				}					
								
<%		 } %>


		//계산서발행시 항목없는 경우 check
<%		for (int i = 0; i <  9 ; i++) { %>		
	
			if ( fm.tax_r_chk<%=i%>.checked == true  &&    fm.tax_r_g[<%=i%>].value == ''  ) {
				alert(" <%=i+1%>번 계산서 품목이 없습니다. 확인하세요!!!");
				return;
			}					
		
<%		 } %>			
		
		//업무용차량 해지인경우는 - 대여료 스케쥴에서 정리 
<%		if ( base.getCar_st().equals("5") ) {  %>
				 if ( fm.tax_r_chk3.checked == true  ||   toInt(parseDigit(fm.tax_rr_supply[3].value)) > 0     ) {
				 	alert("해당건은 대여료스케쥴을 정리한 후 처리하셔야 합니다..!!");
					return;	 
				 }			
<%     } %>
				
		//매입옵션인 경우 미납대여료  계산서 발행은 해지정산에서 하지 않는다. - 중도매입제외 
		if (fm.cls_st.value  == '8' ) {	
		//중도매입옵션인경우
			<% if ( vt_size8 > 0) {%>  
			<% } else {%>
					 if ( fm.tax_r_chk3.checked == true  ||   toInt(parseDigit(fm.tax_rr_supply[3].value)) > 0     ) {
					 	alert("해당건은 대여료스케쥴을 정리한 후 처리하셔야 합니다..!!");
						return;	 
			 		}	
			<% } %> 					
		}
		
		if  ( fm.jung_st_chk.value != "" ) {
			 if ( toInt(parseDigit(fm.c_amt.value))  > 0 ) {
				if ( fm.cls_st.value == '1' || fm.cls_st.value == '2'  ) {   //계약만료 또는 중도해지만 해당
					//선수금정산관련 금액 		
					if  (  fm.jung_st[1].checked == true)  {  //구분정산 선택시
						 if ( ( toInt(parseDigit(fm.h5_amt.value)) -  toInt(parseDigit(fm.h7_amt.value)) ) * (-1)  !=   toInt(parseDigit(fm.fdft_amt2.value))  ) {	
					 		alert("고객납입금액과 구분정산금액이 틀립니다. 금액확인하세요.!!");
							return; 	
					 	}
					 	 if (  toInt(parseDigit(fm.fdft_amt1_2.value))  > 0   ) {	
					 		alert("구분정산시 상계금액입력을 할 수 없습니다. 금액확인하세요.!!");
							return; 	
					 	}
					 					 
					} else {
					 	if ( toInt(parseDigit(fm.h3_amt.value)) *(-1)  !=  toInt(parseDigit(fm.fdft_amt2.value))  ) {
					 		alert("고객납입금액과 합산정산금액이 틀립니다. 금액확인하세요.!!");
							return; 	
					 	}		 		
					}	
	 			}
	 		}	
 		}
 		
 		
 		if (fm.cls_st.value  != '8' ) {					
			if( toInt(parseDigit(fm.c_amt.value)) > 0  ){ 		
				if( toInt(parseDigit(fm.fdft_amt1_1.value)) != 0 ){ 					
					if( toInt(parseDigit(fm.fdft_amt1_2.value)) == 0 ){ 
					      if  (  fm.jung_st[0].checked == true)  {  //구분정산 선택시
							alert("상계금액을 입력하세요.!!");
							return;
					      }
				    }	
				}	
			}	
		}		
			
		       //환불이 현금인 경우 첨부등록check
 	    if  ( fm.pay_st.value == "2" ) {
		<%if ( attach4_vt_size < 1) {%> 		
				alert("현금수령인 경우 증빙을 첨부하셔야 합니다..!!");
				return;
		  <%   } %>		
		}					
		
		//초과운행환불인경우 계산서 체크처리 해제		- 20220822
		if ( fm.tax_r_chk8.checked == true  &&  toInt(parseDigit(fm.over_amt_2.value)) < 0 ) {
			alert("초과운행거리 환불인 경우 계산서 발행을 확인하세요.!!");
			return;
		}
		
		if (chk == '2' ) {
			if(confirm('금액수정하시겠습니까?')){				
				fm.action='lc_cls_u1_a.jsp?from_page=/fms2/cls_cont/lc_cls_u1.jsp';	
	
				fm.target='d_content';
				fm.submit();
			}		
		} else {			
			if(confirm('금액확정하시겠습니까?')){	
				fm.action='lc_cls_u1_a.jsp?from_page=/fms2/cls_cont/lc_cls_u1.jsp';	
	
				fm.target='d_content';
				fm.submit();
			}		
		}
	}
	
	//디스플레이 타입
	function cls_display(){
		var fm = document.form1;
	
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //매입옵션 선택시 디스플레이
			tr_opt.style.display 		= '';  //매입옵션	
			tr_ret.style.display		= 'none';	//차량회수		
			tr_gur.style.display		= 'none';	//채권관계	
			tr_sale.style.display		= '';	//차량매각
			tr_ex_ip.style.display	= 'none';	//추가입금
		}else{
			tr_opt.style.display 		= 'none';	//매입옵션
			tr_ret.style.display		= '';	//차량회수	
			tr_gur.style.display		= '';	//채권관계
			tr_sale.style.display		= 'none';	//차량매각
			tr_ex_ip.style.display	= '';	//추가입금
			
			
		}
				
		set_init();
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
		fm.fdft_amt3.value='0';
	   		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){
			fm.opt_per.value=fm.mopt_per.value;
			fm.opt_amt.value=fm.mopt_amt.value;		
		}
		
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
			
						
			//잔여개시대여료 또는 선납금이 남은 경우  - 마이너스 부가세 포함. 
		//	fm.h4_amt.value = fm.c_amt.value; 	
			fm.h4_amt.value = parseDecimal( toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.rifee_amt_2_v.value)) -   - toInt(parseDigit(fm.rfee_amt_2_v.value)));		
			fm.h5_amt.value = fm.h4_amt.value; 	
			
	//		fm.h6_amt.value =fm.fdft_amt1_1.value; 
			fm.h6_amt.value =fm.fdft_amt1_3.value; 
			fm.h7_amt.value =fm.h6_amt.value; 
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
	   //고객납입금이 0보다 적은 경우: 돌려줄 돈이 있는 경우만 매출유지할 수 있음.
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[1].selected = true;
			alert('중도해지정산금액이 '+fm.fdft_amt2.value+'원으로 환불해야 합니다. \n\n이와 같은 경우에는 매출취소만 가능합니다.');
			return;			
		}		
	}	
	
	//이전등록비용(매입옵션)
	function set_sui_c_amt(){
	
		var fm = document.form1;
							
		if (fm.cls_st.value  == '8' ) {
		  fm.dft_amt.value = '0'; //중도해지위약금
		  fm.dft_amt_1.value = '0'; //중도해지위약금확정
		  fm.tax_r_supply[3].value 	= '0';
		  fm.tax_r_value[3].value 	= '0';			
		}	
		
		set_cls_s_amt();
	
	}	
	
							
	
	//확정금액 셋팅
	function set_cls_s_amt(){
		var fm = document.form1;	
		
						
	//	fm.d_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	 // 	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
	 	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );

		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))   + toInt(parseDigit(fm.over_amt.value))   + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))   + toInt(parseDigit(fm.over_amt_1.value))   + toInt(parseDigit(fm.no_v_amt_1.value)));	 //확정금액	

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
	
	function set_cls_amt4_vat(){
		var fm = document.form1;
		
		fm.dfee_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) * 0.1 );
		
		/*
		if(fm.tax_chk0.checked == true ){		
			fm.dft_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dft_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk1.checked == true ){
			fm.etc_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk2.checked == true ){
			fm.etc2_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc2_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk3.checked == true ){
			fm.etc4_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc4_amt_2.value)) * 0.1 );
		}*/
			
		if(fm.tax_chk4.checked == true ){
			fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );
		}
			
//		fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );
				
	    set_cls_amt4();		    
	    			   
	}
		
	//상계금액 - 잔액셋팅 - 확정금액없이 상계할수 없음.
	function set_cls_amt4(){
		var fm = document.form1;
		
		//확정금액없이 상계금액만 있을 수 없음
		if(toInt(parseDigit(fm.fine_amt_1.value)) <  toInt(parseDigit(fm.fine_amt_2.value))   ){ //
			alert("과태료 확정금액내에서 상계할수 있습니다.!!");
			fm.fine_amt_2.value = "0";
			return;
		}			
		
		//확정금액없이 상계금액만 있을 수 없음
		if(toInt(parseDigit(fm.car_ja_amt_1.value)) < toInt(parseDigit(fm.car_ja_amt_2.value))   ){ //
			alert("면책금 확정금액내에서 상계할수 있습니다.!!");
			fm.car_ja_amt_2.value = "0";
			return;
		}			
		
		//확정금액없이 상계금액만 있을 수 없음 -  환불건도 있을 수 있음
		if(Math.abs(toInt(parseDigit(fm.dfee_amt_1.value))) <   toInt(parseDigit(fm.dfee_amt_2.value))   ){ //
			alert("대여료 확정금액내에서 상계할수 있습니다.!!");
			fm.dfee_amt_2.value = "0";		
			return;
		}			
		
		//확정금액없이 상계금액만 있을 수 없음
		if(toInt(parseDigit(fm.dly_amt_1.value)) <  toInt(parseDigit(fm.dly_amt_2.value))  ){ //
			alert("연체이자 확정금액내에서 상계할수 있습니다.!!");
			fm.dly_amt_2.value = "0";
			return;
		}			
			
		
		//확정금액없이 상계금액만 있을 수 없음
		if(toInt(parseDigit(fm.dft_amt_1.value)) <  toInt(parseDigit(fm.dft_amt_2.value)) ){ //
			alert("위약금 확정금액내에서 상계할수 있습니다.!!");
			fm.dft_amt_2.value = "0";
			return;
		}			
				
		//확정금액없이 상계금액만 있을 수 없음
		if(toInt(parseDigit(fm.etc_amt_1.value)) <  toInt(parseDigit(fm.etc_amt_2.value))  ){ //
			alert("차량회수외주비용 확정금액내에서 상계할수 있습니다.!!");
			fm.etc_amt_2.value = "0";
			return;
		}			
		//확정금액없이 상계금액만 있을 수 없음
		if(toInt(parseDigit(fm.etc2_amt_1.value)) < toInt(parseDigit(fm.etc2_amt_2.value)) ){ //
			alert("차량회수부대비용 확정금액내에서 상계할수 있습니다.!!");
			fm.etc2_amt_2.value = "0";
			return;
		}
			
		<% if  ( fuel_cnt > 0 ) {%>
		 <% if (  return_remark.equals("싼타페") || return_remark.equals("벤츠") || return_remark.equals("볼보")  ) {%>	
		       	if(toInt(parseDigit(fm.etc3_amt_1.value)) !=  toInt(parseDigit(fm.etc3_amt_2.value)) ){ //
		        	 alert("연비보상금액을 처리하세요");
		             return;
		         }
	     <% }else if ( return_remark.equals("혼다") &&  cls.getCls_st().equals("매입옵션")  ) {%>	      
	           	if(toInt(parseDigit(fm.etc3_amt_1.value)) !=  toInt(parseDigit(fm.etc3_amt_2.value)) ){ //
	        		alert("혼다 특별보상 금액을  처리하세요");
	                return;
	           	}    
	      <% } %>  
				  
		<% } else { %>	
	
			//확정금액없이 상계금액만 있을 수 없음
			if(toInt(parseDigit(fm.etc3_amt_1.value)) <    toInt(parseDigit(fm.etc3_amt_2.value)) ){ //
		
				alert("잔존차량가격 확정금액내에서 상계할수 있습니다.!!");
				fm.etc3_amt_2.value = "0";
				return;
			}			
		<% } %>	
		
		//확정금액없이 상계금액만 있을 수 없음
		if(toInt(parseDigit(fm.etc4_amt_1.value)) <  toInt(parseDigit(fm.etc4_amt_2.value))   ){ //
			alert("기타손해배상금 확정금액내에서 상계할수 있습니다.!!");
			fm.etc4_amt_2.value = "0";
			return;
		}			
		
	 
			//확정금액없이 상계금액만 있을 수 없음
		if(toInt(parseDigit(fm.over_amt_1.value)) <   toInt(parseDigit(fm.over_amt_2.value))   ){ //
			alert("초과운행대여료 확정금액내에서 상계할수 있습니다.!!");
			fm.over_amt_2.value = "0";
			return;
		}	
		
		fm.fine_amt_3.value = parseDecimal( toInt(parseDigit(fm.fine_amt_1.value))  -    toInt(parseDigit(fm.fine_amt_2.value)) ) ;
		fm.car_ja_amt_3.value = parseDecimal( toInt(parseDigit(fm.car_ja_amt_1.value))  -    toInt(parseDigit(fm.car_ja_amt_2.value)) ) ;
		fm.dfee_amt_3.value =parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value))  -    toInt(parseDigit(fm.dfee_amt_2.value)) ) ;
		fm.dly_amt_3.value = parseDecimal( toInt(parseDigit(fm.dly_amt_1.value))  -    toInt(parseDigit(fm.dly_amt_2.value)) ) ;
		fm.dft_amt_3.value =parseDecimal( toInt(parseDigit(fm.dft_amt_1.value))  -    toInt(parseDigit(fm.dft_amt_2.value)) ) ;
		fm.etc_amt_3.value = parseDecimal( toInt(parseDigit(fm.etc_amt_1.value))  -    toInt(parseDigit(fm.etc_amt_2.value)) ) ;
		fm.etc2_amt_3.value = parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value))  -    toInt(parseDigit(fm.etc2_amt_2.value)) ) ;
		fm.etc3_amt_3.value = parseDecimal( toInt(parseDigit(fm.etc3_amt_1.value))  -    toInt(parseDigit(fm.etc3_amt_2.value)) ) ;
		fm.etc4_amt_3.value =parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value))  -    toInt(parseDigit(fm.etc4_amt_2.value)) ) ;
		fm.over_amt_3.value = parseDecimal( toInt(parseDigit(fm.over_amt_1.value))  -    toInt(parseDigit(fm.over_amt_2.value)) ) ;	
			
		fm.no_v_amt_2.value =  parseDecimal( toInt(parseDigit(fm.dfee_amt_2_v.value)) + toInt(parseDigit(fm.tax_r_value[0].value))+ toInt(parseDigit(fm.tax_r_value[1].value))+ toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value)) + toInt(parseDigit(fm.over_amt_2_v.value)) );	
		fm.no_v_amt_3.value = parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value))  -    toInt(parseDigit(fm.no_v_amt_2.value)) ) ;				
													
		fm.fdft_amt1_2.value 	= parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) + toInt(parseDigit(fm.dly_amt_2.value))+ toInt(parseDigit(fm.dft_amt_2.value)) + toInt(parseDigit(fm.car_ja_amt_2.value)) + toInt(parseDigit(fm.fine_amt_2.value)) + toInt(parseDigit(fm.etc_amt_2.value)) + toInt(parseDigit(fm.etc2_amt_2.value)) + toInt(parseDigit(fm.etc3_amt_2.value)) + toInt(parseDigit(fm.etc4_amt_2.value))  + toInt(parseDigit(fm.over_amt_2.value)) + toInt(parseDigit(fm.no_v_amt_2.value)) );	 //상계금액	
		fm.fdft_amt1_3.value = parseDecimal( toInt(parseDigit(fm.fdft_amt1_1.value))  -    toInt(parseDigit(fm.fdft_amt1_2.value)) ) ;				
		
		if( ( toInt(parseDigit(fm.c_amt.value))  + toInt(parseDigit(fm.ex_ip_amt.value)) +  toInt(parseDigit(fm.opt_ip_amt1.value)) +  toInt(parseDigit(fm.opt_ip_amt2.value)) -  toInt(parseDigit(fm.fdft_amt1_2.value)) )  < -1 ) {
			alert("환불가능한금액(매입옵션입금분포함) 한도내에서 상계할 수 있습니다.\n 상계금액을 조정하십시요.!!");
			return;
		}
		
		fm.fdft_j_amt.value = parseDecimal( toInt(parseDigit(fm.c_amt.value))  +  toInt(parseDigit(fm.ex_ip_amt.value))   - toInt(parseDigit(fm.fdft_amt1_2.value)) );		
                   
                   //상계잔여금액이 있는 경우 
          //         if  ( toInt(parseDigit(fm.fdft_j_amt.value))  >  0 ) {
	 //              fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_2.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	//		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_2.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );		                
         //          }  else {                                      
	//                   fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.fdft_amt1_2.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	//		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.fdft_amt1_2.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
          //         }
                    
        //           alert(                 fm.fdft_amt2.value  ) ;       
        fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );		
        //              alert(                 fm.fdft_amt2.value  ) ;         	
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		         			  
	   
		if (fm.cls_st.value  == '8' ) {	//매입옵션		    
		     if  ( toInt(parseDigit(fm.fdft_amt2.value))  >=  0 ) {  //납입해야하면			     
				fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));					
				fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			 } else {
			 	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_2.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));					
				fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_2.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
				 
			 }				
		}  
		
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_2.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_2.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_2.value)) );		
						   
	}
	
	//매입옵션 금액
	function set_maeip_amt(obj){
		 		
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		var ext_amt = 0;
		
	   if(obj == fm.m_dae_amt){ //대체입금		
			fm.t_dae_amt.value 	= parseDecimal( toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.opt_ip_amt1.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)));	
		//	ext_amt = toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.opt_ip_amt1.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value)) 	;
			
	   } else if(obj == fm.opt_ip_amt1){ //입금1		
			fm.t_dae_amt.value 	= parseDecimal( toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)));	
		//	ext_amt = toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value)) 	;
			
			
		}else if(obj == fm.opt_ip_amt2){ //입금2
			fm.t_dae_amt.value 	= parseDecimal( toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt1.value)));	
		//	ext_amt	=  toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt1.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value)) 	;	
	
		}	
				
	 	if ( toInt(parseDigit(fm.fdft_amt2.value)) <= 0 ) { //매입옵션시 고객납입금액
	 		if ( toInt(parseDigit(fm.m_dae_amt.value)) == 0 ) { //대체입금이 없다면 
	 			fm.ext_amt.value = parseDecimal( (toInt(parseDigit(fm.fdft_amt2.value)) * (-1))  +  toInt(parseDigit(fm.opt_ip_amt1.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value))) ;
	 		} else {
	 			fm.ext_amt.value = parseDecimal(  toInt(parseDigit(fm.m_dae_amt.value)) +  toInt(parseDigit(fm.opt_ip_amt1.value))  + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value))) ;
	 		}	 	
	  	 } else {
	  		fm.ext_amt.value = parseDecimal( toInt(parseDigit(fm.opt_ip_amt1.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.fdft_amt2.value)) -  toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value))) ; 	  		
	  	 }
	 
	 	 
	 	 if (toInt(parseDigit(fm.ext_amt.value))  >=0  ) { //환불금액이 있다면 
	 		fm.est_amt.value =  parseDecimal( toInt(parseDigit(fm.ext_amt.value)) * (-1) ); 
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
		if ( toInt(parseDigit(fm.gi_j_amt.value)) < 0  ) {
				fm.gi_j_amt.value  = "0";
		}		
	}		
		
	//세금계산서 check 관련 부가세 - 고객납입액에 부가세 만큼 더한다(대여료, 면책금은 예외 (이미 더해졌음)) - 세금계산서 발행되면 외상매출금계정 
	function set_vat_amt(obj){
		var fm = document.form1;
		
		/*
		if(obj == fm.tax_chk0){ // 위약금
		 	if (obj.checked == true) {
		 			fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		 			fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[0].value)));		
			} else {
					fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[0].value)));		
			}	
	
		} else if(obj == fm.tax_chk1){ // 회수비용
			 if (obj.checked == true) {
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[1].value)));
			 } else {
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[1].value)));
			 }	
		} else if(obj == fm.tax_chk2){ // 부대비용
			 if (obj.checked == true) {
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[2].value)));
			 } else {
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[2].value)));
			 }	
		} else if(obj == fm.tax_chk3){ // 기타손해배상금
			 if (obj.checked == true) {
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[3].value)));
			 } else {
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[3].value)));
			 }	
		} else */
		
		if(obj == fm.tax_chk4){ // 초과운행 부담금 
			 if (obj.checked == true) {
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));
			 } else {
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[4].value)));
			 } 
		}	
		
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
				
	}
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if ( fm.doc_bit.value == '3') {
		  if ( fm.term_yn.value != '2') {
			alert('금액확정이 되어 있지 않습니다. 금액확정후 작업하셔야 결재하셔야 합니다!!!..');
			return;	
		   }
		}
			
		if(confirm('결재하시겠습니까?')){	
			fm.action='lc_cls_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
		
	//해지처리 - 출고전해지등 조건에 맞는 경우
	function clsConSanction(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('해지구분을 선택하십시오'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('해지일자를 입력하십시오'); 		fm.cls_dt.focus(); 		return;	}
					
		if(confirm('결재하시겠습니까?')){	
			fm.action='lc_cls_cont_sanction.jsp';	
			fm.target='i_no';
		//	fm.target='d_content';
			fm.submit();
		}		
	}	
		
	//은행선택시 계좌번호 가져오기
	function change_bank(obj){
		var fm = document.form1;
		var bank_code = "";
		if(obj == fm.bank_code){ // 추가입금액
			//은행
			bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;	
			fm.bank_code2.value = bank_code.substring(0,3);
			fm.bank_name.value = bank_code.substring(3);
		} else	if(obj == fm.opt_bank_code1){ // 매입옵션 1
			bank_code = fm.opt_bank_code1.options[fm.opt_bank_code1.selectedIndex].value;	
			fm.opt_bank_code1_2.value = bank_code.substring(0,3);
			fm.opt_bank_name1.value = bank_code.substring(3);		
			
		} else	if(obj == fm.opt_bank_code2){ // 매입옵션 2
			bank_code = fm.opt_bank_code2.options[fm.opt_bank_code2.selectedIndex].value;	
			fm.opt_bank_code2_2.value = bank_code.substring(0,3);
			fm.opt_bank_name2.value = bank_code.substring(3);			
		} 		
	
		drop_deposit(obj);		

		if(bank_code == ''){
			if(obj == fm.bank_code){ // 추가입금액
				fm.bank_code.options[0] = new Option('선택', '');
				return;
			} else 	if(obj == fm.opt_bank_code1){ // 매입옵션 1
				fm.opt_bank_code1.options[0] = new Option('선택', '');
				return;			
			} else 	if(obj == fm.opt_bank_code2){ // 매입옵션 2
				fm.opt_bank_code1.options[0] = new Option('선택', '');
				return;			
			}			
		}else{
			fm.target='i_no';
			if(obj == fm.bank_code){ // 추가입금액
				fm.action='/fms2/con_fee/get_deposit_nodisplay2.jsp?g=1&bank_code='+bank_code.substring(0,3);
			} else 	if(obj == fm.opt_bank_code1){ // 매입옵션 1
				fm.action='/fms2/con_fee/get_deposit_nodisplay2.jsp?g=2&bank_code='+bank_code.substring(0,3);
			} else 	if(obj == fm.opt_bank_code2){ // 매입옵션 2
				fm.action='/fms2/con_fee/get_deposit_nodisplay2.jsp?g=3&bank_code='+bank_code.substring(0,3);
			}
			fm.submit();
		}
	}	
	
	function drop_deposit(obj){
		var fm = document.form1;
		var deposit_len = 0;
		if(obj == fm.bank_code){ // 추가입금액
			deposit_len = fm.deposit_no.length;
			for(var i = 0 ; i < deposit_len ; i++){
				fm.deposit_no.options[deposit_len-(i+1)] = null;
			}
		} else	if(obj == fm.opt_bank_code1){ // 매입옵션 1
		
			deposit_len = fm.opt_deposit_no1.length;
			for(var i = 0 ; i < deposit_len ; i++){
				fm.opt_deposit_no1.options[deposit_len-(i+1)] = null;
			}		
		} else	if(obj == fm.opt_bank_code2){ // 매입옵션 2
			deposit_len = fm.opt_deposit_no2.length;
			for(var i = 0 ; i < deposit_len ; i++){
				fm.opt_deposit_no2.options[deposit_len-(i+1)] = null;
			}
		} 	
			
	}	
		
	function add_deposit(idx, val, str, g){
	    if ( g == '1') {
			document.form1.deposit_no[idx] = new Option(str, val);		
		} else if ( g == '2') {
			document.form1.opt_deposit_no1[idx] = new Option(str, val);		
		} else if ( g == '3') {
			document.form1.opt_deposit_no2[idx] = new Option(str, val);		
		}
	}
				
	//조회하기
	function ven_search(idx){
		var fm = document.form1;
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx, "VENDOR_LIST", "left=50, top=50, width=500, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function set_cls_tax_value(v_type){
		var fm = document.form1;
		
		if(v_type == '1'){ // 미납대여료
			fm.tax_rr_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) * 0.1 );	
		} else if(v_type == '2' ){ // 해지정산금
			fm.tax_rr_value[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[4].value)) * 0.1 );		
		} else if(v_type == '3'){ // 외주비용
			fm.tax_rr_value[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[5].value)) * 0.1 );	
		} else if(v_type == '4'){ // 부대비용
			fm.tax_rr_value[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[6].value)) * 0.1 );	
		} else if(v_type == '5'){ // 손해배상금
			fm.tax_rr_value[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[7].value)) * 0.1 );	
		} else if(v_type == '6'){ //  초과운행부담금
			fm.tax_rr_value[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[8].value)) * 0.1 );		
		}	
			
	    set_cls_tax_hap();				   
	}
	
	
	function set_cls_p_tax_hap(){
		var fm = document.form1;		
		
		fm.p_tax_supply.value = 0;
		fm.p_tax_value.value = 0;	
		fm.p_tax_hap.value = 0;	
				
		for(var i=0 ; i<9 ; i++){
			
		  fm.tax_r_hap[i].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[i].value)) +  toInt(parseDigit(fm.tax_r_value[i].value)));		
		  fm.p_tax_supply.value    	= parseDecimal( toInt(parseDigit(fm.p_tax_supply.value)) + toInt(parseDigit(fm.tax_r_supply[i].value)) );
		  fm.p_tax_value.value     	= parseDecimal( toInt(parseDigit(fm.p_tax_value.value)) + toInt(parseDigit(fm.tax_r_value[i].value)) );
		}
	
		fm.p_tax_hap.value    		= parseDecimal( toInt(parseDigit(fm.p_tax_supply.value)) + toInt(parseDigit(fm.p_tax_value.value)) );  		   
	}
	
	
	function set_cls_tax_hap(){
		var fm = document.form1;		
	
		fm.r_tax_supply.value = 0;
		fm.r_tax_value.value = 0;	
		fm.r_tax_hap.value = 0;	
				
		for(var i=0 ; i<9 ; i++){
		  fm.tax_rr_hap[i].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[i].value)) +  toInt(parseDigit(fm.tax_rr_value[i].value)));	
		  fm.r_tax_supply.value    	= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.tax_rr_supply[i].value)) );
		  fm.r_tax_value.value     	= parseDecimal( toInt(parseDigit(fm.r_tax_value.value)) + toInt(parseDigit(fm.tax_rr_value[i].value)) );
		}
	
		fm.r_tax_hap.value    		= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.r_tax_value.value)) ); 		   
	}
	
	
	function update(st){
						
		if (st == 'cls_jung') {	
			window.open("/fms2/cls_cont/updateClsJung.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=50, width=1150, height=850, resizable=yes, scrollbars=yes, status=yes");
		} else if (st == 'cls_etc') {	
			window.open("/fms2/cls_cont/updateClsEtc.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1150, height=650, resizable=yes, scrollbars=yes, status=yes");			
		} else if (st == 'cls_asset') {  //매입옵션	
			window.open("/fms2/cls_cont/updateClsAsset.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1150, height=550, resizable=yes, scrollbars=yes, status=yes");	
		} else if (st == 'cls_reco') {  //입금일,회수일 수정	
			window.open("/fms2/cls_cont/updateCarReco.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1150, height=550, resizable=yes, scrollbars=yes, status=yes");					
	    } else if (st == 'tr_p_maeip') {  //매입옵션 정산서 부가세 끝전 수정	
			window.open("/fms2/cls_cont/updateTrMaeip.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1150, height=550, resizable=yes, scrollbars=yes, status=yes");					
		} else {
			window.open("/fms2/cls_cont/updateTrGet.jsp<%=valus%>", "CHANGE_ITEM", "left=50, top=100, width=1150, height=550, resizable=yes, scrollbars=yes, status=yes");
		}		 
	}
		
		//스캔등록
	function scan_reg(gubun){
		window.open("reg_scan.jsp?gubun="+gubun+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//스캔삭제
	function scan_del(gubun){
		var theForm = document.form1;
		if(!confirm('삭제하시겠습니까?')){		return;	}
		theForm.target = "i_no";
		theForm.action = "del_scan_a.jsp?gubun="+gubun;
		theForm.submit();
	}
	
	
	//특이사항  보기
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
	
	//임의연장 계약서
	function view_scan_res2(c_id, m_id, l_cd){
		window.open("/fms2/lc_rent/lc_im_doc_print.jsp?c_id="+c_id+"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&mode=fine_doc", "VIEW_SCAN_RES2", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}
	
	
	//의뢰자 변경
	function doc_id_cng(doc_no, doc_bit, doc_user){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 300;		
		window.open("/fms2/doc_settle/doc_user_cng.jsp<%=valus%>&doc_no="+doc_no+"&doc_bit="+doc_bit+"&doc_user="+doc_user, "CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}	
		
		//서류수령일등 저장 
	function reg_dt()
	{
		var fm = document.form1;
		
		if(fm.conj_dt.value == ""){ alert("서류수령일을 입력하세요!!."); return;}
									
		if(confirm('등록정보를 저장하시겠습니까?'))
		{		
			fm.target = 'i_no';
			fm.action = "/acar/off_ls_after/off_ls_after_dt_upd_a.jsp?sui_etc=Y" ;
			fm.submit();
		}
	}
		
	function clsOverUpdate(){
		var fm = document.form1;
		
		if(!confirm('초과운행대여료를 수정하시겠습니까?')){		return;	}
		fm.target = "i_no";
		fm.action = "updateClsOver_a.jsp";
		fm.submit();		
	}	

	//초과운행주행거리 - 해당부분만 수정 -정산금액은 일단 별도로 처리해야함 (기타항목 확인하면서 !!! - 금액꼬임!!) - 일단 전산팀
	function set_over_amt(){
		var fm = document.form1;
					
		var cal_dist  = 0;		
		var tae_cal_dist  = 0;		
	
		//초기화 
		fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) + toInt(parseDigit(fm.b_tot_dist.value))   );	
		fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) + toInt(parseDigit(fm.b_tot_dist.value))  -   toInt(parseDigit(fm.first_dist.value))     );		  
		
		cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
		fm.cal_dist.value 		=     parseDecimal( cal_dist   );
		fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     )
	
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
				
		//	fm.add_dist.value 		=     parseDecimal( 1000  );  //써비스마일리지
	 //	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
		
		//중도해약, 계약만료인 경우
		if ( fm.cls_st.value == '1' || fm.cls_st.value == '2'  ) { 
		
			if ( (  <%=base.getRent_dt()%>  > 20130604  &&    <%=car1.getAgree_dist()%>  > 0   &&  <%=base.getCar_gu()%>  ==  '1' ) ||    (  <%=base.getRent_dt()%>  > 20140705  &&  <%=base.getCar_gu()%>  ==  '0' )   ) {  
			
			   	cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;	
								
				fm.cal_dist.value 		=     parseDecimal( Math.round(cal_dist)  );				
				
			//	fm.add_dist.value 		=     parseDecimal( 1000  );  //써비스마일리지	(대차인경우 대차기간 표시)
				//지연대차가 있는 경우 -				
			//	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
				
				fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) + toInt(parseDigit(fm.b_tot_dist.value))   );	
				fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) + toInt(parseDigit(fm.b_tot_dist.value))  -   toInt(parseDigit(fm.first_dist.value))     );		  
				fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );							
				
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
				}  else  {	 //환급인 경우 - 2022-04-15이후 환급약정이 있는 경우
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
<input type='hidden' name='bit' value='<%=bit%>' >     
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 
<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'> 
<input type='hidden' name='car_no' value='<%=base1.get("CAR_NO")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
<input type='hidden' name='pp_amt' value='<%=base1.get("PP_AMT")%>'>
<input type='hidden' name='ifee_amt' value='<%=base1.get("IFEE_AMT")%>'>
				
<input type='hidden' name='con_mon' value='<%=base1.get("CON_MON")%>'>
<input type='hidden' name="doc_bit" 	value="<%=doc_bit%>">              
  
<input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
<input type='hidden' name="from_page" 	value="<%=from_page%>">
<input type='hidden' name="status" 	value="<%=clsm.getStatus()%>">
<input type='hidden' name='cls_s_amt' value='<%=AddUtil.parseDecimal(cls.getCls_s_amt())%>' >
<input type='hidden' name='cls_v_amt' value='<%=AddUtil.parseDecimal(cls.getCls_v_amt())%>' >
          
<input type='hidden' name='bank_code2' value='<%=clsm.getEx_ip_bank()%>'>
<input type='hidden' name='deposit_no2' value='<%=clsm.getEx_ip_bank_no()%>'>
<input type='hidden' name='bank_name' value=''>

<input type='hidden' name='hs_mon' value='<%=base1.get("HS_MON")%>'>  <!-- 잔액제외한 미납일자 -->
<input type='hidden' name='hs_day' value='<%=base1.get("HS_DAY")%>'>  <!-- 잔액제외한 미납일자 -->

<!-- 매입옵션 1 -->
<input type='hidden' name='opt_bank_code1_2' value='<%=cls.getOpt_ip_bank1()%>'>
<input type='hidden' name='opt_deposit_no1_2' value='<%=cls.getOpt_ip_bank_no1()%>'>
<input type='hidden' name='opt_bank_name1' value=''>

<!-- 매입옵션 2 -->
<input type='hidden' name='opt_bank_code2_2' value='<%=cls.getOpt_ip_bank2()%>'>
<input type='hidden' name='opt_deposit_no2_2' value='<%=cls.getOpt_ip_bank_no2()%>'>
<input type='hidden' name='opt_bank_name2' value=''>

<!-- 마지막 계산서 발행일 / 발행금액  -->
<input type='hidden' name="tfee_s_amt" 		value="<%=tax2.get("FEE_S_AMT")%>">  
<input type='hidden' name="tfee_v_amt" 		value="<%=tax2.get("FEE_V_AMT")%>">
<input type='hidden' name="tuse_s_dt" 		value="<%=tax2.get("USE_S_DT")%>">  
<input type='hidden' name="tuse_e_dt" 		value="<%=tax2.get("USE_E_DT")%>">    
    
<input type='hidden' name="re_day" 		value="<%=re_day%>">  
<input type='hidden' name="term_yn" 		value="<%=term_yn%>">  

<!-- 미발행날짜  -->
<input type='hidden' name='t_day' value='<%=tax1.get("T_DAY")%>'>
<input type='hidden' name='t_mon' value='<%=tax1.get("T_MON")%>'> 
 
<!--계산서 취소한 시작일 부터 해지일까지 날짜 --> 
<input type='hidden' name='u_day' value='<%=ht_t.get("U_DAY")%>'> 
<input type='hidden' name='u_mon' value='<%=ht_t.get("U_MON")%>'> 

<input type='hidden' name='fee_tm' value='<%=fee_tm%>'> 

<!--출고전해지(신차)인경우 출고지연대차관련 -->
<input type='hidden' name='tae_prv_dlv_yn' value='<%=tae_prv_dlv_yn%>'> 
<input type='hidden' name='tae_cnt' value='<%=tae_cnt%>'> 
<input type='hidden' name='tae_e_dt' value='<%=tae_e_dt%>'> 

<!--마지막회차가 해지일이 된 경우처리를 위해  (미납분 (잔액제외)-->                      
<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'>
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_V_AMT")))%>'>

<!--  마지막계산서 발행 다음회차 금액   -->
<input type='hidden' name="lfee_s_amt" 		value="<%=tax3.get("FEE_S_AMT")%>">  
<input type='hidden' name="lfee_v_amt" 		value="<%=tax3.get("FEE_V_AMT")%>">

  <!--초과운행 거리 계산 -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='rtn_run_amt' value='<%=car1.getRtn_run_amt()%>'>
 
<input type='hidden' name='sh_km' value='<%=car1.getSh_km()%>'>

<input type='hidden' name='jung_st_chk' value='<%=cct.getJung_st()%>' >
<input type='hidden' name="old_opt_amt" 		value="<%=clsa.getOld_opt_amt() %>">

<!-- 중도매입옵션시 기발행 계산서 금액 제외한 미납대여료 산정 -->
<input type='hidden' name='ts_r_fee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)m_tax1.get("TS_R_FEE_AMT")))%>'>
<input type='hidden' name='tv_r_fee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)m_tax1.get("TV_R_FEE_AMT")))%>'>

<input type='hidden' name='rifee_v_amt' value='<%=cls.getRifee_v_amt()%>'> <!-- 부가세 관련  -->
<input type='hidden' name='rfee_v_amt' value='<%=cls.getRfee_v_amt()%>'>
<input type='hidden' name='dfee_v_amt' value='<%=cls.getDfee_v_amt()%>'>
<input type='hidden' name='dfee_v_amt_1' value='<%=cls.getDfee_v_amt_1()%>'>
<input type='hidden' name='over_v_amt' value='<%=cls.getOver_v_amt()%>'>
<input type='hidden' name='over_v_amt_1' value='<%=cls.getOver_v_amt_1()%>'>


<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	 <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>영업지원 > 해지관리 >
                    <span class=style5><% if(cls.getCls_st().equals("매입옵션")) {%> 매입옵션문서관리<% } else { %> 해지정산문서관리 <%} %></span></span></td> 
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
    <tr>
      <td align='right'> 
    <% if(cls.getCls_st().equals("매입옵션")) {%>
	   &nbsp;&nbsp;<a href="javascript:view_mail('<%=rent_mng_id%>','<%=rent_l_cd%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_send_mail.gif align=absmiddle border=0></a>
	    &nbsp;&nbsp;<a href='javascript:opt_print();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_print_yangdo.png align=absmiddle border=0></a>
	<% } else {%>
	    &nbsp;&nbsp;<a href="javascript:sendMail('<%=rent_mng_id%>', '<%=rent_l_cd%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_send_mail.gif" align=absmiddle border=0></a> 
	<% } %> 
	   &nbsp;&nbsp;<a href='javascript:cls_talk();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_ntalk.gif align=absmiddle border=0></a>     
	   &nbsp;<a href='javascript:cls_print();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_print_jss.gif align=absmiddle border=0></a>
	    &nbsp;&nbsp;<a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
	    </td>
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
            </td>
            <td rowspan="7" class="title">대<br>
		                여<br>
		                자<br>
		                동<br>
		                차</td>
		    <td class=title width=10%>차명</td>
            <td>&nbsp;
             <% if  ( cr_bean.getFuel_kd().equals("8") ) { %><font color=red>[전]</font>&nbsp;<% } %>
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
 		 <a href="javascript:update('cls_etc')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a></span></td>
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
			  <select name="cls_st" onChange='javascript:cls_display()' disabled >
			    <option value="1" <%if(cls.getCls_st().equals("계약만료")){%>selected<%}%>>계약만료</option>
                <option value="2" <%if(cls.getCls_st().equals("중도해약")){%>selected<%}%>>중도해약</option>
                <option value="7" <%if(cls.getCls_st().equals("출고전해지(신차)")){%>selected<%}%>>출고전해지(신차)</option>
                <option value="8" <%if(cls.getCls_st().equals("매입옵션")){%>selected<%}%>>매입옵션</option>
                <option value="10" <%if(cls.getCls_st().equals("개시전해지(재리스)")){%>selected<%}%>>개시전해지(재리스)</option>
		      </select> </td>
                      					  
            <td width='13%' class='title'>의뢰자</td>
            <td width="12%">&nbsp;
              <select name='reg_id' disabled >
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
			  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt())%>' readonly size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 
	    <td width='12%' class='title'>이용기간</td>
	    <td width='12%' >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' value='<%=cls.getR_mon()%>' readonly  >개월&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=cls.getR_day()%>' readonly >일&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>사유 </td>
            <td colspan="7">&nbsp;
              <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cls.getCls_cau()%></textarea>			
            </td>
          
          </tr>
          <tr>                                                      
            <td class=title >잔여선납금<br>매출취소여부</td>
     	    <td>&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()' disabled >
                <option value="N" <% if(cls.getCancel_yn().equals("N")){%>selected<%}%>>매출유지</option>
                <option value="Y" <% if(cls.getCancel_yn().equals("Y")){%>selected<%}%>>매출취소</option>
              </select>
		    </td>
		    
<%if( cls.getCls_st().equals("매입옵션") )  { %>
  			  <td  class=title width=10%>매입옵션담당자</td>
            <td  width=12%>&nbsp;
				  <select name='add_saction_id'>
	                <option value="">--선택--</option>
	                 <option value="000197" <% if(clsa.getAdd_saction_id().equals("000197")){%>selected<%}%>>조현준</option> 	 
	                <option value="000172" <% if(clsa.getAdd_saction_id().equals("000172")){%>selected<%}%>>정진식</option> 	              
	              </select>	                        
			      &nbsp;&nbsp;<%=clsa.getAdd_saction_dt()%>   </td>         
					

<% } else { %> 		    
		     <td  class=title width=10%>지점장결재자</td>
            <td  width=12%>&nbsp;
			 </td>		 
		    
<% } %>		    

            <td  colspan="4" align=left>&nbsp;※ 기발행 계산서의 유지 또는 취소여부 등 확인이 필요, 매출취소시 마이너스 세금계산서 발행 </td>
          </tr>
          <tr>      
		            <td width='10%' class='title'>주행거리</td>
		            <td>&nbsp;
					  <input type='text' name='tot_dist' size='10' value='<%=AddUtil.parseDecimal(cls.getTot_dist())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km 
		            </td>
		             <td colspan=5   align=left>&nbsp;
		              <% if ( dashcnt > 0) { %><font color=red> ※  계기판 교환직전 주행거리 </font>
		              <input type='text' name='b_tot_dist' size='8' value='<%=AddUtil.parseDecimal(cls.getB_tot_dist())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>&nbsp;km 
		              <% } else{ %>
		             <input type='hidden' name='b_tot_dist'   >
		              <%}  %> 
		             &nbsp; 
		             <%if( cls.getCls_st().equals("매입옵션") ) { %>※ 매입옵션시 차량주행거리 <% } else { %> ※ 중도해지 및 만기시 차량주행거리 <%} %> </td>	   
		             <td > ( 등록자 : <%=umd.getUserNm(cls.getInput_id())%> )</td>               
		           
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
   
    
     <tr></tr><tr></tr>    
 
	 <tr id=tr_opt style="display:<%if( cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	       		  <tr>
		       		   <td class=title width=13%>서류배송주소</td>
		       		   <td  colspan="3">&nbsp; <input type='text' name='des_zip'  size='7' value='<%=clsm.getDes_zip()%>' class='text' >
					      <input type='text' size='70' name='des_addr'   value='<%=clsm.getDes_addr()%>'   maxlength='80' class='text'></td>
					  <td class=title width=10%>상호&수취인</td>
					  <td >&nbsp; <input type='text' size='30' name='des_nm'   value='<%=clsm.getDes_nm()%>'   maxlength='40' class='text'> </td>	
					   <td class=title width=10%>연락처</td>
					  <td >&nbsp; <input type='text' size='30' name='des_tel'   value='<%=clsm.getDes_tel()%>'   maxlength='40' class='text'> </td>		
					  <td class=title width=10%>서류수령일</td>
					  <td  >&nbsp; <input type='text' size='12' name='conj_dt'   value='<%= AddUtil.ChangeDate2(seBean.getConj_dt()) %>'   maxlength='40' class='text'>      
					   <% if (   nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("매입옵션관리자",user_id)  ) { %>
					           &nbsp; <a href="javascript:reg_dt()"><img src=/acar/images/center/button_save.gif border=0 align=absmiddle></a>  
					   <% } %>	
					   </td>
	                </tr>
	            </table>
	        </td>       
   	 </tr>
   	
    <tr>
      <td>&nbsp;</td>
    </tr> 	     
 
   <tr id=tr_match style="display:<%if( cls.getCls_st().equals("매입옵션")  || cls.getCls_st().equals("출고전해지(신차)") || cls.getCls_st().equals("개시전해지(재리스)") ){%>none<%}else{%>''<%}%>">  
  
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
			          <td colspan=7>&nbsp;<input type="radio" name="match" value="Y" <%if(cls.getMatch().equals("Y")){%> checked <%}%> disabled>유
	                            <input type="radio" name="match" value="N"  <%if(!cls.getMatch().equals("Y")){%> checked <%}%> disabled>무
	          <!--        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약:&nbsp;<a href="javascript:search_grt_suc(2)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a> --></td>	                
		          </tr>		                   
		          <tr>      
		            <td width='10%' class='title'>계약번호</td>
		            <td>&nbsp;<input type='text' name='match_l_cd' size='15' value='<%=clsm.getMatch_l_cd()%>' class='whitetext' readonly  ></td>
		            <td width='10%' class='title'>차명</td>
		            <td>&nbsp;<input type='text' name='match_car_nm' size='20' value='<%=m_taecha.getCar_nm()%>' class='whitetext' ></td>
		            <td width='10%' class='title'>대여개시일</td>
		            <td>&nbsp;<input type='text' name='match_start_dt' size='15' value='<%=AddUtil.ChangeDate2(m_taecha.getCar_rent_st())%>' class='whitetext' ></td>
		          </tr>		         
		          <tr>      
		            <td width='10%' class='title'>차량번호</td>
		            <td>&nbsp;<input type='text' name='match_car_no' size='15' value='<%=m_taecha.getCar_no()%>' class='whitetext' readonly ></td>
		            <td width='10%' class='title'>대여종료일</td>
		            <td>&nbsp;<input type='text' name='match_end_dt' size='15' value='<%=AddUtil.ChangeDate2(m_taecha.getCar_rent_et())%>' class='whitetext'y ></td>
		            <td width='10%' class='title'>대여기간</td>
		            <td>&nbsp;<input type='text' name='match_m_mm' size='2' value='<%=mm_mon%>' class='whitenum'>월 <input type='text' name='match_m_dd' size='2' value='<%=mm_day%>' class='whitenum'>일</td>
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
   
    <tr id=tr_dae style="display:<%if( cls.getCls_st().equals("출고전해지(신차)") ){%>''<%}else{%>none<%}%>"> 
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
                      <% if  ( AddUtil.parseInt(cls.getCls_dt().substring(0,4)) > 2020 ) { %> 
                    <td width="10%" class=title >신차해지시요금정산<br>(월렌트정상요금)</td>
                    <td>&nbsp;                      
                      <%if(taecha.getRent_fee_st().equals("1")){%>                            
		                      <%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>원(vat포함)                
		              <%}%>
		              <%if(taecha.getRent_fee_st().equals("0")){%> 견적서에 표기되어 있지 않음    <%}%> 
                  <% } else { %> 
                    <td width="10%" class=title >월대여료</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>원(vat포함) 
                  <% } %>  
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
    <tr id=tr_opt style="display:<%if( cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 

 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매입옵션&nbsp;
 	 		   <%  if (  nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("매입옵션관리자",user_id)  || nm_db.getWorkAuthUser("채권관리팀",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)   ){%>     
 	 		 <a href="javascript:update('cls_asset')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
 	 		 <% } %>
 	 		 </span></td>
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
		          	
		 	 	     <td class='title' width="13%">매입옵션율</td>
		             <td width="13%">&nbsp;<input type='text' name='opt_per' value='<%=f_opt_per%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title' width="13%">매입옵션가</td>
		             <td colspan=2 width="26%">&nbsp;<input type='text' name='opt_amt'size='15' class='num' value="<%=AddUtil.parseDecimal(cls.getOpt_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_sui_c_amt();'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT포함)</td> 
		             <td class='title' width="13%">등록비용</td>
		             <td colspan=2 width=22% >&nbsp;
		               <select name="sui_st" disabled>
							  <option value="Y" <% if(clsm.getSui_st().equals("Y")){%>selected<%}%>>포함</option>
					          <option value="N" <% if(clsm.getSui_st().equals("N")){%>selected<%}%>>미포함</option>           
              			</select></td>		            
                  </tr>	
                                
		           <tr id=tr_opt1 style="display:<%if ( clsm.getSui_st().equals("Y") ){%>''<%}else{%>none<%}%>"> 
		 	 	     <td class='title' width="13%" rowspan=3>이전등록비용</td>
		             <td class='title' width="13%">등록세</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d1_amt' readonly value='<%=AddUtil.parseDecimal(clsm.getSui_d1_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td> 
		             <td class='title' width="13%">채권할인</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d2_amt' readonly value='<%=AddUtil.parseDecimal(clsm.getSui_d2_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td> 
		             <td class='title' width="13%">취득세</td>
		             <td colspan=2 >&nbsp;<input type='text' name='sui_d3_amt' readonly value='<%=AddUtil.parseDecimal(clsm.getSui_d3_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td> 
		          </tr>  
		           <tr id=tr_opt2 style="display:<%if ( clsm.getSui_st().equals("Y") ){%>''<%}else{%>none<%}%>">  
		 	 	     <td class='title' width="13%">인지대</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d4_amt' readonly value='<%=AddUtil.parseDecimal(clsm.getSui_d4_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td> 
		             <td class='title' width="13%">증지대</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d5_amt' readonly value='<%=AddUtil.parseDecimal(clsm.getSui_d5_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td> 
		             <td class='title' width="13%">번호판대</td>
		             <td colspan=2 >&nbsp;<input type='text' name='sui_d6_amt' readonly value='<%=AddUtil.parseDecimal(clsm.getSui_d6_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td> 
		          </tr>  
		           <tr id=tr_opt3 style="display:<%if ( clsm.getSui_st().equals("Y") ){%>''<%}else{%>none<%}%>"> 
		 	 	     <td class='title' width="13%">보조번호판대</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d7_amt' readonly value='<%=AddUtil.parseDecimal(clsm.getSui_d7_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td> 
		             <td class='title' width="13%">등록대행료</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d8_amt' readonly value='<%=AddUtil.parseDecimal(clsm.getSui_d8_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td> 
		             <td class='title' width="13%">계</td>
		             <td colspan=2  >&nbsp;<input type='text' name='sui_d_amt' readonly  value='<%=AddUtil.parseDecimal(clsm.getSui_d_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 원&nbsp;&nbsp; *천원절사</td> 
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
 
    <tr id=tr_ret style="display:<%if( cls.getCls_st().equals("매입옵션") || cls.getCls_st().equals("출고전해지(신차)")  ){%>none<%}else{%>''<%}%>"> 
  
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량회수
			      <%  if (  nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("매입옵션관리자",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id)  || nm_db.getWorkAuthUser("보유차관리",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id) ){%>     
	  	 			 <a href="javascript:update('cls_reco')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
				<% } %>			  
			  </span></td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		  			
			<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 
			            <td width='13%' class='title'>회수여부</td>
			            <td width="20%">&nbsp;<input type="radio" name="reco_st" value="Y"  <%if(carReco.getReco_st().equals("Y")){%>checked<%}%> >회수
	                            <input type="radio" name="reco_st" value="N" <%if(carReco.getReco_st().equals("N")){%>checked<%}%> >미회수</td>
	                    <td width='13%' class='title'>구분</td>
 
	                    <td id=td_ret1 style='display:<%if( carReco.getReco_st().equals("Y") ){%><%}else{%>none<%}%>'> &nbsp; 
						  <select name="reco_d1_st" disabled >
						    <option value="1" <%if(carReco.getReco_d1_st().equals("정상회수")){%>selected<%}%>>정상회수</option>
						    <option value="2" <%if(carReco.getReco_d1_st().equals("강제회수")){%>selected<%}%>>강제회수</option>
						    <option value="3" <%if(carReco.getReco_d1_st().equals("협의회수")){%>selected<%}%>>협의회수</option>
			               </select>       
			            </td>
 
			            <td id=td_ret2 style='display:<%if( carReco.getReco_st().equals("N") ){%><%}else{%>none<%}%>'> &nbsp; 
						  <select name="reco_d2_st" disabled >
						    <option value="1" <%if(carReco.getReco_d2_st().equals("도난")){%>selected<%}%>>도난</option>
						    <option value="2" <%if(carReco.getReco_d2_st().equals("횡령")){%>selected<%}%>>횡령</option>
						    <option value="3" <%if(carReco.getReco_d2_st().equals("멸실")){%>selected<%}%>>멸실</option>						  
						   </select>       
			            </td>
			            
			            <td class='title' width='13%' >사유</td>
						<td>&nbsp;
						<input type="text" name="reco_cau" value='<%=carReco.getReco_cau()%>'size=30 maxlength=100 readonly >
						</td>				        		         
		         </tr>
		                   
		         <tr>      
		            <td width='10%' class='title'>회수일자</td>
		            <td>&nbsp;
					  <input type='text' name='reco_dt' readonly  value='<%=carReco.getReco_dt()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		            <td width='10%' class='title'>회수담당자</td>
		            <td>&nbsp;
					  <select name='reco_id' disabled >
		                <option value="">선택</option>
		                  <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                 <option value='<%=user.get("USER_ID")%>' <%if(carReco.getReco_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
		                 <%		}
						 	}%>							           
		              </select>
		            </td>
		            <td width='10%' class='title'>입고일자</td>
		            <td>&nbsp;
					  <input type='text' name='ip_dt' readonly size='12' value='<%=carReco.getIp_dt()%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		          </tr>		         
		  
		   			 <tr>        
		            <td class=title>차량현위치</td>
	                    <td colspan=5> 
	                      &nbsp;<SELECT NAME="park" >
				                 <option value="" <% if(carReco.getPark().equals("")){%>selected<%}%>>--선택--</option>
				                    <%if(good_size > 0){ 			
	                   			   for(int i = 0 ; i < good_size ; i++){
                  								CodeBean good = goods[i];%>
		       		          <option value='<%= good.getNm_cd()%>' <% if(carReco.getPark().equals(good.getNm_cd() ) )  {%>selected<%}%>><%= good.getNm()%></option>
		                 <%		}
						 	}%>	
	        		        </SELECT>
							<input type="text" name="park_cont" value='<%=carReco.getPark_cont()%>'  size="80" class=text style='IME-MODE: active'>
						(기타선택시 내용)
                    	</td>                    	 
	      	          </tr>	
	      	          
	      	          <tr>		          
                    	   <td class=title>예비차 사용가능</td>
                    	    <td >&nbsp;<input type="radio" name="serv_st" value="Y"  <%if(cls.getServ_st().equals("Y")){%>checked<%}%> >즉시가능
	                            <input type="radio" name="serv_st" value="N" <%if(cls.getServ_st().equals("N")){%>checked<%}%> >수리후 가능</td>
	                       <td class=title>예비차 적용</td>
                    	    <td colspan=3>&nbsp;<input type="radio" name="serv_gubun" value="1"  <%if(cls.getServ_gubun().equals("1")){%>checked<%}%> >재리스/월렌트
	                            &nbsp;<input type="radio" name="serv_gubun" value="3" <%if(cls.getServ_gubun().equals("3")){%>checked<%}%> >월렌트
	                            &nbsp;<input type="radio" name="serv_gubun" value="2" <%if(cls.getServ_gubun().equals("2")){%>checked<%}%> >매각</td>     
	                            
	      	       </tr>		      
	      	       
		          <tr>      
		            <td width='10%' class='title'>외주비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='12' readonly value='<%=AddUtil.parseDecimal(carReco.getEtc_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		            </td>
		            <td width='10%' class='title'>부대비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='12'  readonly value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		            </td>
		            <td width='10%' class='title'>비용계</td>
		            <td>&nbsp;
					 <input type='text' name='etc_out_amt' size='12' readonly value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt() + carReco.getEtc_d1_amt())%>' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
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
		                   <input type='text' name='grt_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>&nbsp;</td>		               	               
		                </tr>
		                 <tr>
		                  <td align="center" >승계</td>
		                  <td align="center">&nbsp;<input type="radio" name="suc_gubun" value="1"   <%if(cct.getSuc_gubun().equals("1")){%>checked<%}%>  >예치금전액승계 
	                            &nbsp;<input type="radio" name="suc_gubun" value="2"    <%if(cct.getSuc_gubun().equals("2")){%>checked<%}%> >정산후잔액승계 </td>	  
		                    </td>
		                  <td>승계받을 계약번호:&nbsp;<input type='text' name='suc_l_cd' size='15' value='<%=cct.getSuc_l_cd()%>' class='whitetext' >
		                   &nbsp;<!--<a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a> -->
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
		                    <input type='text' size='3' name='ifee_mon' readonly  value='<%=cls.getIfee_mon()%>'  class='num' maxlength='4' >
		                    개월&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='<%=cls.getIfee_day()%>' class='num' maxlength='4' >
		                    일</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >경과금액</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' readonly value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td>=개시대여료×경과기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 개시대여료(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td class='title'>=개시대여료-경과금액</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">선<br>
		                    납<br>
		                    금</td>
		                  <td align='center'>월공제액 </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td>=선납금÷계약기간</td>
		                </tr>
		                <tr> 
		                  <td align='center'>선납금 공제총액 </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td>=월공제액×실이용기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 선납금(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
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
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납금액 정산</span>[공급가]&nbsp;
 <%  if (  nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id)   || nm_db.getWorkAuthUser("해지관리자",user_id)  || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  ){%>     
	  	  <a href="javascript:update('cls_jung')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
	  <% } %>
	</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    
    <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
              <td class="title" colspan="4" rowspan=2>항목</td>
              <td class="title" width='40%' colspan=2> 채권</td>             
              <td class="title" width='40%' colspan=2> 정산</td>                   
              <td class="title" width='38%' rowspan=2>비고</td>
            </tr>
            <tr>                 
              <td class="title"'> 당초금액</td>
              <td class="title"'> 확정금액</td>
              <td class="title"'> 상계금액</td>
              <td class="title"'> 잔액</td>
            </tr>
            <tr> 
              <td class="title" rowspan="27" width="4%">미<br>
                납<br>
                입<br>
                금<br>
                액</td>
              <td class="title" colspan="3">과태료/범칙금(D)</td>
              <td align="center" class="title"> 
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' ></td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num'  ></td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_2'  value='<%=AddUtil.parseDecimal(clss.getFine_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>
               <td  align="center" class="title"> 
               <input type='text' name='fine_amt_3' readonly  value='<%=AddUtil.parseDecimal(cls.getFine_amt_1() - clss.getFine_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              
              <td class="title">※일부상계불가</td>
             </tr>
             <tr> 
              <td class="title" colspan="3">자기차량손해면책금(E)</td>
              <td width='10%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' ></td>
              <td width='10%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>'   size='15' class='num'  ></td>   
              <td width='10%' align="center" class="title">
              <input type='text' name='car_ja_amt_2'  value='<%=AddUtil.parseDecimal(clss.getCar_ja_amt_2())%>'   size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>
                <td width='10%' align="center" class="title">
              <input type='text' name='car_ja_amt_3' readonly  value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1() - clss.getCar_ja_amt_2())%>'   size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                              
              <td width='38%' class="title">※일부상계불가</td>
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
                <input type='text' name='ex_di_amt_1' readonly  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' ></td> 
              <td class='' align="center">&nbsp;</td>   
              <td class='' align="center">&nbsp;</td>                             
              <td>&nbsp;</td>
             
            </tr>
         
            <tr> 
              <td rowspan="2" align="center" class="title" width="4%">미<br>
                납</td>
              <td width='10%' align="center" class="title">기간</td>
              <td class='' colspan=4  align="center"> 
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
                <input type='text' size='15' name='nfee_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>  
              <td align="center">&nbsp; </td>  
               <td align="center">&nbsp; </td>    
              <td>기발행계산서의 유지 또는 취소여부를 확인  </td>
            </tr>
	        <tr> 
              <td class="title" colspan="2">소계(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt' value='<%=AddUtil.parseDecimal(cls.getDfee_amt())%>' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_2'  value='<%=AddUtil.parseDecimal(clss.getDfee_amt_2())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'> </td>                 
                 <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_3' readonly  value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1() - clss.getDfee_amt_2())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '> </td>                 
                 <td class='title'>&nbsp;=과부족 + 미납</td>
            </tr>
                <input type='hidden' size='15' name='d_amt' >          
                <input type='hidden' size='15' name='d_amt_1'> 
            <tr> 
              <td rowspan="6" class="title">중<br>
                도<br>
                해<br>
                지<br>
                위<br>
                약<br>
                금</td>
              <td align="center" colspan="2" class="title">대여료총액</td>
              <td class='' colspan=4  align="center"> 
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=선납금+월대여료총액</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">월대여료(환산)</td>
              <td class='' colspan=4 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' ></td>
              <td>=대여료총액÷계약기간</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">잔여대여계약기간</td>
              <td class=''  colspan=4  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4' >
                개월&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day' readonly size='3' value='<%=cls.getRcon_day()%>' class='num' maxlength='4' >
                일</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">잔여기간 대여료 총액</td>
              <td class=''  colspan=4 align="center"> 
                <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' readonly size='15' class='num' ></td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> 위약금 
                적용요율</td>
              <td class='' align="center"> 
                <input type='text' name='dft_int' readonly value='<%=cls.getDft_int()%>' size='5' class='num'  maxlength='5'>
                %</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int_1'  value='<%=cls.getDft_int_1()%>' size='5' class='num'  maxlength='5'>
                %</td>  
              <td class=''  align="center">&nbsp;</td>  
               <td class=''  align="center">&nbsp;</td>    
              <td>*위약금 적용요율은 계약서를 확인 <br><font color=red>*</font>해지위약금 차액이 발생시 영업효율대상자를 반드시 선택</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">중도해지위약금(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' ></td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' ></td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_2' size='15' class='num'  value='<%=AddUtil.parseDecimal(clss.getDft_amt_2())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td>
                 <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' size='15' class='num' >            
                  <td align="center" class="title"> 
                <input type='text' name='dft_amt_3' readonly size='15' class='num'  value='<%=AddUtil.parseDecimal(cls.getDft_amt_1() - clss.getDft_amt_2())%>' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class="title">&nbsp;<input type='checkbox' name='tax_chk0'  value='Y' <%if(cls.getTax_chk0().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled ><!--계산서발행의뢰-->
                 &nbsp;<font color="#FF0000">*</font>영업효율대상자: 
                      <select name='dft_cost_id'  disabled >
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
                <input type='text' name='dly_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_2'  value='<%=AddUtil.parseDecimal(clss.getDly_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>             
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_3'  value='<%=AddUtil.parseDecimal(cls.getDly_amt_1() - clss.getDly_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>             
              <td class='title'>&nbsp; </td>
            </tr>
            <tr>          
              <td class="title" colspan="2">차량회수외주비용(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt())%>' size='15' class='num' ></td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>  
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_2'  value='<%=AddUtil.parseDecimal(clss.getEtc_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td> 
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_v())%>' size='15' class='num' >  
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_3' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1() - clss.getEtc_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
               <td class="title">&nbsp;<input type='checkbox' name='tax_chk1'  value='Y' <%if(cls.getTax_chk1().equals("Y")){%>checked<%}%>   disabled ></td>
            </tr>
            <tr> 
              <td class="title" colspan="2">차량회수부대비용(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>' size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>  
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_2' value='<%=AddUtil.parseDecimal(clss.getEtc2_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td>   
                <input type='hidden' name='tax_value' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_v())%>' size='15' class='num' >  
               <td align="center" class="title"> 
                <input type='text' name='etc2_amt_3' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1() - clss.getEtc2_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>    
               <td class="title">&nbsp;<input type='checkbox' name='tax_chk2'  value='Y' <%if(cls.getTax_chk2().equals("Y")){%>checked<%}%>   disabled ></td>
              
            </tr>
            <tr> 
              <td colspan="2" class="title">잔존차량가격(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>'size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td> 
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_2' value='<%=AddUtil.parseDecimal(clss.getEtc3_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td>    
             <td align="center" class="title"> 
                <input type='text' name='etc3_amt_3' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1() - clss.getEtc3_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>    
             
              <td class="title">&nbsp;
                <% if  ( fuel_cnt > 0   && (return_remark.equals("싼타페") || return_remark.equals("볼보") || return_remark.equals("벤츠") ) ) {%>            
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
                <input type='text' name='etc4_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>  
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_2' value='<%=AddUtil.parseDecimal(clss.getEtc4_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td> 
               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' size='15' class='num' >  
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_3' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1() - clss.getEtc4_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td> 
              <td class="title">&nbsp;<input type='checkbox' name='tax_chk3' value='Y' <%if(cls.getTax_chk3().equals("Y")){%>checked<%}%>  disabled ><!--계산서발행의뢰-->
            <%if( cls.getEtc4_amt_1() > 0 ) {%>
                 
                 <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"2";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                	<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    				<%}else{%>
    						&nbsp;<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>	
    						 <!-- 견적서 등록 또는 예상수리내역 입력 --> 		
    				        <!--  면책금 + 20만원 예상수리비 인경우 예상내역 입력으로 대체 가능 - 20210907 -->		
								&nbsp;
								  <br>※ 예상수리내역&nbsp; <br> 
								  예상수리비:&nbsp;<input type='text' name='e_serv_amt'  value='<%=AddUtil.parseDecimal(clsm.getE_serv_amt())%>'  size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>  
					         	   수리항목:&nbsp;<input type='text' name='e_serv_rem'  value='<%=clsm.getE_serv_rem()%>' size='70' class='text' > 	
			    	   						    								                 
    			    <%}%>
            <%}%></td>                               
            </tr>
               <tr> 
              <td class="title" colspan="2">초과운행대여료(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt())%>'  size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>  
              <td align="center" class="title"> 
                <input type='text' name='over_amt_2' value='<%=AddUtil.parseDecimal(clss.getOver_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td>             
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getOver_amt_v())%>' size='15' class='num' >  
              <td align="center" class="title"> 
                <input type='text' name='over_amt_3' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt_1() - clss.getOver_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>              
              <td class="title">&nbsp;<input type='checkbox' name='tax_chk4' value='Y' <%if(cls.getTax_chk4().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);" disabled >계산서발행의뢰</td>                               
            </tr>
            
            
            <tr> 
              <td class="title" rowspan="9"><br>
                부<br>
                가<br>
                세</td> 
                         
              <td width='10%' align="center" class="title" colspan=2 >잔여개시대여료</td>
                <td align="center" class="title"> 
               </td>
              <td align="center" class="title">  
                </td>  
               <td align="center" class="title"> 
                <input type='text' name='rifee_amt_2_v'  value='<%=AddUtil.parseDecimal(clss.getRifee_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>
              <td class="title">&nbsp;</td>
                <td class="title">&nbsp;</td>
            </tr>
            
            <tr> 
              <td align="center" class="title" colspan=2 >잔여선납금</td>
                <td align="center" class="title"> 
                </td>
              <td align="center" class="title"> 
                </td>  
               <td align="center" class="title"> 
                <input type='text' name='rfee_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getRfee_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>
              <td class="title">&nbsp;</td>
                <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" class="title" colspan=2 >대여료</td>
                 <td align="center" class="title"> 
                </td>
              <td align="center" class="title"> 
                </td>  
               <td align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getDfee_amt_2_v())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>                          
                <td class="title">&nbsp;</td>
                  <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" class="title" colspan=2 >해지위약금</td>
                <td align="center" class="title"> 
                </td>
              <td align="center" class="title"> 
                </td>  
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getDft_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>
              <td class="title">&nbsp;</td>
                <td class="title">&nbsp;</td>
            </tr>    
            <tr> 
              <td align="center" class="title" colspan=2 >회수외주비용</td>
              <td align="center" class="title"> 
              </td>
              <td align="center" class="title"> 
               </td>  
               <td align="center" class="title"> 
                <input type='text' name='etc_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getEtc_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>
             <td class="title">&nbsp;</td>
               <td class="title">&nbsp;</td>
            </tr>    
             <tr> 
              <td align="center" class="title" colspan=2 >회수부대비용</td>
                <td align="center" class="title"> 
                </td>
              <td align="center" class="title"> 
                </td>  
               <td align="center" class="title"> 
                <input type='text' name='etc2_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getEtc2_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>
             <td class="title">&nbsp;</td>
               <td class="title">&nbsp;</td>
            </tr>  
            <tr> 
              <td align="center" class="title" colspan=2>기타손해배상금</td>
              <td align="center" class="title"> 
              </td>
              <td align="center" class="title"> 
               </td>  
               <td align="center" class="title"> 
                <input type='text' name='etc4_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getEtc4_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>  
             <td class="title">&nbsp;</td>
               <td class="title">&nbsp;</td>
            </tr>      
             <tr> 
              <td align="center" class="title" colspan=2>초과운행대여료</td>
              <td align="center" class="title"> 
              </td>
              <td align="center" class="title"> 
               </td>  
               <td align="center" class="title"> 
                <input type='text' name='over_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getOver_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>  
             <td class="title">&nbsp;</td>
               <td class="title">&nbsp;</td>
            </tr>                     
            <tr> 
              <td class="title" colspan="2">소계(N)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt())%>' readonly size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>'  size='15' class='num' ></td>  
               <td align="center" class="title"> 
                <input type='text' name='no_v_amt_2' value='<%=AddUtil.parseDecimal(clss.getNo_v_amt_2())%>' readonly  size='15'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
                 <td align="center" class="title"> 
                <input type='text' name='no_v_amt_3' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1() - clss.getNo_v_amt_2())%>' readonly  size='15'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
               <td> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                 <tr> 
                    <td id=td_cancel_n style="display:<%if( cls.getCancel_yn().equals("N") ){%>none<%}else{%>''<%}%>" class="title">=(F+M-B-C)×10% </td> 
                    <td id=td_cancel_y style="display:<%if( cls.getCancel_yn().equals("Y") ){%>none<%}else{%>''<%}%>" class='title'>=(F+M-B-C)×10% </td>
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
               <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_2' value='<%=AddUtil.parseDecimal(clss.getFdft_amt1_2())%>'  readonly  size='15' class='num' ></td>   
               <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_3' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1() - clss.getFdft_amt1_2())%>'  readonly  size='15' class='num' ></td>     
              <td class='title_p'>&nbsp;상계잔여금액:<input type='text' name='fdft_j_amt'  value='' readonly  size='15' class='num' >
               =(D+E+F+G+H+I+J+K+L+M+N)&nbsp;&nbsp;              
                <br>※ 계산서:&nbsp;              
               <input type="radio" name="tax_reg_gu" value="N"  <%if(cls.getTax_reg_gu().equals("N")){%>checked<%}%> >항목별개별발행
               <input type="radio" name="tax_reg_gu" value="Y"  <%if(cls.getTax_reg_gu().equals("Y")){%>checked<%}%> >항목별통합발행(1장)
          <!--     <input type="radio" name="tax_reg_gu" value="Z"  <%if(cls.getTax_reg_gu().equals("Z")){%>checked<%}%> >대여료통합포함청구 -->
              
              </td>
            </tr>
          </table>
        </td>         
    </tr>
    
     <tr>
    	<td>&nbsp;<font color="#FF0000">***</font> 기타손해배상금이 있는 경우 견적서등록(보험가입면책금+20만원내 인 경우) 또는 예상수리내역 입력하세요.!!</td>    
     </tr> 
     
   
    <tr></tr><tr></tr><tr></tr>
    
      <!-- 선수금 정산 추가 - 20150706 -->
      <tr id=tr_jung style="display:<%if( cls.getCls_st().equals("매입옵션") ) { %>none<%} else {%>''<% } %>">      
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
			            <td colspan=5>&nbsp;<input type="radio" name="jung_st" value="1"   <%if(cct.getJung_st().equals("1")){%>checked<%}%> onClick='javascript:cls_display4()'>합산정산
	                            <input type="radio" name="jung_st" value="2"  <%if(cct.getJung_st().equals("2")){%>checked<%}%> onClick='javascript:cls_display4()'>구분정산</td>
	                    </tr>
		           <tr> 
		                <td class="title" rowspan=3 width='10%'>구분</td>                
		              <td class="title"  rowspan=3  width='12%'>합산정산(상계)</td>
		              <td class="title"  colspan="3"  width='35%'>구분정산</td>
		              <td class="title" rowspan=3  width='43%'>적요</td>
		            </tr>
		            <tr> 
		               <td class="title" rowspan=2 width='12%'>환불</td>
		               <td class="title" colspan=2 >청구</td>
		            </tr>
		              <tr> 
		               <td class="title" >금액</td>
		               <td class="title" >구분</td>
		            </tr>
		            <tr> 
		              <td class="title"  >선납금액</td>   
		              <td>&nbsp; <input type='text' name='h1_amt' value='<%=AddUtil.parseDecimal(cct.getH1_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td>&nbsp; <input type='text' name='h4_amt' value='<%=AddUtil.parseDecimal(cct.getH4_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td align="center" >&nbsp; </td>
		              <td align="left" >&nbsp;</td>
		              <td align="left"  rowspan=3>&nbsp;</td> 
		             </tr>
		                <tr> 
		              <td class="title"  >미납입금액</td>   
		              <td>&nbsp; <input type='text' name='h2_amt' value='<%=AddUtil.parseDecimal(cct.getH2_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td>&nbsp;</td>
		              <td align="center" >&nbsp;<input type='text' name='h6_amt' value='<%=AddUtil.parseDecimal(cct.getH6_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
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
		              <td>&nbsp; <input type='text' name='h3_amt' value='<%=AddUtil.parseDecimal(cct.getH3_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td>&nbsp; <input type='text' name='h5_amt' value='<%=AddUtil.parseDecimal(cct.getH5_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td align="center" >&nbsp;<input type='text' name='h7_amt' value='<%=AddUtil.parseDecimal(cct.getH7_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '> </td>
		              <td align="left" >&nbsp;입금예정일: <input type='text' name='h_ip_dt' size='10'  value='<%=AddUtil.ChangeDate2(cct.getH_ip_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
		             </tr>
		             </table>
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
                    <td>&nbsp;※ 미납입금액계 - 환불금액계</td>                   
                  	<td class=title width='10%'><input type='checkbox' name='cms_chk' value='Y' <%if(cls.getCms_chk().equals("Y"))%>checked<%%> >CMS인출의뢰</td>
                  	<td colspan=3 >&nbsp;부분인출금액&nbsp;<input type='text' name='cms_amt'  size='15' class='num' value='<%=AddUtil.parseDecimal(clsm.getCms_amt())%>' ><font color=red>※ 부분 CMS인출의뢰인 경우에 한해서 부분인출금액을 입력하세요.!!! (전체의뢰인 경우는  부분인출금액 입력 불필요!!!!)</font> </td>	                		                   
                 	<td >&nbsp;<input type='checkbox' name='cms_after' value='Y' <%if(clsm.getCms_after().equals("Y")){%>checked<%}%> ><font color="red">CMS 확인후 처리</font></td>               		
                 	<% } %>                     
              </tr>
             
              </table>
         </td>       
    <tr>
        
    <tr></tr><tr></tr><tr></tr><tr></tr>
     
      
      <tr id=tr_jung1 style="display:<%if( cls.getCls_st().equals("매입옵션") ) { %>none<%} else {%>''<% } %>">      
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
               <tr> 
			            <td width='10%' class='title'>환불</td>
			            <td colspan=5>&nbsp;
			            <input type="radio" name="refund_st" value="1" <%if(cct.getRefund_st().equals("1")){%>checked<%}%> >예치금전액환불/별도정산			           
			                &nbsp;&nbsp;&nbsp; <input type="radio" name="refund_st" value="2"  <%if(cct.getRefund_st().equals("2")){%>checked<%}%>  >정산후잔액환불 
	                   </td>	              
	              </tr>
	              <tr> 
			            <td width='10%' class='title' rowspan=2>유보</td>
			            <td colspan=5>&nbsp;<input type="checkbox" name="delay_st" value="Y"  <%if(cct.getDelay_st().equals("Y")){%>checked<%}%>>정산후잔액환불 유보(선택)
	                      &nbsp;&nbsp;&nbsp;<input type="radio" name="delay_type" value="1"    <%if(cct.getDelay_type().equals("1")){%>checked<%}%> >1. 타계약건과 합산후 환불
			                   &nbsp;&nbsp;&nbsp;<input type="radio" name="delay_type" value="2"  <%if(cct.getDelay_type().equals("2")){%>checked<%}%>>2. 고객의 사정
			                   &nbsp;&nbsp;&nbsp;<input type="radio" name="delay_type" value="3"  <%if(cct.getDelay_type().equals("3")){%>checked<%}%>>3. 기타
	                  </td>	           
	              </tr>
	              <tr> 			          
			            <td colspan=5>&nbsp;&nbsp;&nbsp;<font color=red><b>유보할 사유 구체적 내용: </b></font><textarea name="delay_desc" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cct.getDelay_desc()%></textarea></td>
	               </tr>   	         
	               
       	 	  <tr> 	 	     
	              <td class="title"  width='10%'>구분</td>
	              <td class="title" width='12%'>금액</td>                
	              <td class="title" width='18%'>처리일시</td>
	              <td class="title" width='18%'>처리구분</td>
	              <td class="title" width='42%'>비고</td>
	            </tr>
	            <tr> 
	              <td class="title" >환불금액</td>   
	              <td align=right>&nbsp;
	              <%  	       //합산정산  
	  if(cct.getJung_st().equals("1"))  {
	     if ( cls.getFdft_amt2() < 0 ) {  %><%=AddUtil.parseDecimal(cls.getFdft_amt2() * (-1))%>
<%  	      }  %>
<%  	   }  %>	 
<%  	       //합산정산  
	  if(cct.getJung_st().equals("2"))  {
	     if ( cct.getH5_amt() > 0 ) {  %><%=AddUtil.parseDecimal(cct.getH5_amt())%>
<%  	      }  %>
<%  	   }  %>
	              </td>
	              <td >&nbsp;</td> <!--출금원장에서-->
	              <td >&nbsp; 
	             	 <select name='pay_st'>
			                <option value="">--선택--</option>
			                <option value="1"<%if(cct.getPay_st().equals("1")){%>selected<%}%>>계좌송금</option>
			                <option value="2"<%if(cct.getPay_st().equals("2")){%>selected<%}%>>현금지급</option>	       
	               </select>	   
	              </td>
	              <td align="left" >
	                   <%
                 		content_seq  = rent_mng_id+""+rent_l_cd+"4";
                 		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 		attach_vt_size = attach_vt.size();	
                
                 		if(attach_vt_size > 0){   %>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j); %>
    							&nbsp;<a href="javascript:openPop('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    			<%}else{%>			
    						&nbsp;<a href="javascript:scan_reg('4')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>(현금지급인 경우)
    			<%}  %> 
    			</td>
	             </tr>
	                   <tr> 
	              <td class="title" >청구금액</td>   
	              <td align=right>&nbsp;
	              <%  	       //합산정산  
	  if(cct.getJung_st().equals("1"))  {
	     if ( cls.getFdft_amt2() > 0 ) {  %><%=AddUtil.parseDecimal(cls.getFdft_amt2() )%>
<%  	      }  %>
<%  	   }  %>	 
<%  	       //합산정산  
	  if(cct.getJung_st().equals("2"))  {
	     if ( cct.getH7_amt() > 0 ) {  %><%=AddUtil.parseDecimal(cct.getH7_amt())%>
<%  	      }  %>
<%  	   }  %>	
	              </td>
	              <td >&nbsp;</td>
	              <td >&nbsp; </td>
	              <td align="left" >&nbsp;</td>
	             </tr> 
             
              </table>
         </td>       
    <tr>
     <tr></tr><tr></tr><tr></tr><tr></tr>
     
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10%>연체료감액<br>결재자</td>
                    <td width=12%>&nbsp;
						   <select name='dly_saction_id'>
			                <option value="">--선택--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getDly_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select>
			        </td>
                    <td class=title width=12%>연체료 감액사유</td>
                    <td colspan=3>&nbsp;<textarea name="dly_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getDly_reason()%></textarea></td> 
				 
                </tr>
                <tr>
                	<td class=title width=10%>중도해지위약금<br>감액 결재자</td>
                    <td width=12%>&nbsp;
						   <select name='dft_saction_id'>
			                <option value="">-선택--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getDft_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select>
			              &nbsp;&nbsp;<%=cls.getDft_saction_dt()%>
			        </td>
                    <td class=title width=12%>중도해지위약금<br>감액사유</td>
				    <td colspan=3>&nbsp;<textarea name="dft_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getDft_reason()%></textarea></td> 
				    
                </tr>
                <tr>
                  	<td class=title width=10%>확정금액결재자</td>
                    <td width=12%>&nbsp;
						   <select name='d_saction_id'>
			                <option value="">-선택--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getD_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select>
			        </td>
                    <td class=title width=12%>확정금액 사유</td>
                    <td colspan=3>&nbsp;<textarea name="d_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getD_reason()%></textarea></td> 				   
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
						       <option value='<%=user1.get("USER_ID")%>' <%if(cls.getExt_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>	
			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>후불처리사유</td>
                    <td colspan=3>&nbsp;<textarea name="ext_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getExt_reason()%></textarea></td> 				  
                </tr>-->
              </table>
         </td>       
    </tr>
              
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
 
   <tr id=tr_cal_sale style="display:<%if( clsa.getOld_opt_amt() > 0 && fee_size  ==  1 ){%>''<%}else{%>none<%}%>"> 
    
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
         <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중도 정산서</span>
 	 		<%  if (  nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("매입옵션관리자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id)  ){%>     
			  	  <a href="javascript:update('tr_p_maeip')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
			<% } %>	  	 		 
 	 		 
 	 		 </td>
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
				//	t_g_fee_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_G_FEE_AMT")));
					
					s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_G_FEE_AMT"))) ;
					
					if ( s_g_fee_amt < 1) {s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT"))) ; }
								
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
  
    <tr></tr><tr></tr><tr></tr>     
    
           <!-- 초과운행부담금에 한함  block none--> 
    <tr id=tr_over style="display:<%if( co.getRent_days() > 0 ){%>''<%}else{%>none<%}%>"> 
      <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>환급/초과운행 대여료[공급가]</span>
 	 		<%  if (  nm_db.getWorkAuthUser("전산팀",user_id)){%>     
			  	  <a href="javascript:clsOverUpdate()"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
			<% } %> 
 	 		 
 	 		 </td>
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
              <td align="right" > <input type='text' name='rent_days'  <%  if (  nm_db.getWorkAuthUser("전산팀",user_id)){%> <%} else { %>readonly<% } %>    value='<%=AddUtil.parseDecimal(co.getRent_days() )%>' size='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_over_amt();'> 일 </td> 
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
              <td align="right"><input type='text' name='m_over_amt'  value='<%=AddUtil.parseDecimal(co.getM_over_amt() )%>'  readonly    size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> 원</td>
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
      
   <!-- 추후 수정 --> 
    <tr id=tr_ip_opt style="display:<%if( cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 
 
	   <%  //매입옵션인경우만 
	      if ( cls.getCls_st().equals("매입옵션") ) {
	    //	 System.out.println("status = " + clsm.getStatus());
	    	 if ( !clsm.getStatus().equals("0") ) {  
	    		 maeip_amt =  clsm.getM_dae_amt();
	    		 m_ext_amt =  clsm.getExt_amt();
	    	 }  else { //계산된 값으로 
		    	 if (cls.getFdft_amt2() < 0) {  
			 		   maeip_amt = cls.getFdft_amt2()* (-1);
					 
					   if (maeip_amt > cls.getOpt_amt() ) {
						    maeip_amt = cls.getOpt_amt();						  
					   }  				    	
			     }
	    	 
		    	 if (cls.getFdft_amt3() < 0) {  
		    	    m_ext_amt  = (cls.getFdft_amt3() * (-1)) + maeip_amt + cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2() - cls.getOpt_amt() - clsm.getSui_d_amt() ;	
	    	  //   } else {
	    	  //  	m_ext_amt  = maeip_amt +cls.getOpt_ip_amt2()  + cls.getOpt_ip_amt1() - cls.getOpt_amt() - cls.getSui_d_amt() ;	
	    	     } 	    	  
		    
		     }
		    
		   }   
	   %> 
	   
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매입옵션 입금
 	 		   <%  if (  nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("매입옵션관리자",user_id) ){%>     
			  	  <a href="javascript:update('cls_asset')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
			<% } %>	 
 	 		 </span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
		        <td class=line>
		            <table width=100% border=0 cellspacing=1 cellpadding=0>
		               <tr>
		                    <td class=title width=10%>대체입금</td>
		                    <td width=13%>&nbsp;<input type='text' name='m_dae_amt'   value='<%=AddUtil.parseDecimal(maeip_amt)%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_maeip_amt(this);' ></td>
		                    <td colspan=6>&nbsp;</td>						  
		              </tr>
		       		  <tr>
		                    <td class=title width=10%>입금액</td>
		                    <td width=13%>&nbsp;<input type='text' name='opt_ip_amt1'  value='<%=AddUtil.parseDecimal(cls.getOpt_ip_amt1())%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_maeip_amt(this);' ></td>
		                    <td class=title width=10%>입금일</td>
						    <td width=10%>&nbsp;<input type='text' name='opt_ip_dt1' value='<%=cls.getOpt_ip_dt1()%>'  size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
						    <td class=title width=10%>입금은행</td>
						    <td width=10%>&nbsp;<select name='opt_bank_code1' onChange='javascript:change_bank(this)'>
		                        <option value=''>선택</option>
		                        <%if(a_bank_size > 0){
		        						for(int i = 0 ; i < a_bank_size ; i++){
		        							CodeBean a_bank = a_banks[i];	%>
		                        <option value='<%= a_bank.getCode()%><%= a_bank.getNm()%>' <%if(cls.getOpt_ip_bank1().equals(a_bank.getCode())){%>selected<%}%>> <%=a_bank.getNm()%> 
		                        </option>
		                        <%	}
		        					}	%>
		                      </select>&nbsp;</td>
		                    <td class=title width=10%>계좌번호</td>
				            <td>&nbsp;<select name='opt_deposit_no1'>
		                        <option value=''>계좌를 선택하세요</option>
		        				<%if(!cls.getOpt_ip_bank1().equals("")){
		        						Vector deposits = neoe_db.getDepositList(cls.getOpt_ip_bank1()); /* 계좌번호 */
		        						int deposit_size = deposits.size();
		        						for(int i = 0 ; i < deposit_size ; i++){
		        							Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
		        				<option value='<%=deposit.get("DEPOSIT_NO")%>' <%if(cls.getOpt_ip_bank_no1().equals(String.valueOf(deposit.get("DEPOSIT_NO")))){%>selected<%}%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
		        				<%		}
		        				}%>
		                      </select>
		                    </td>
		                </tr>
		                <tr>
		                    <td class=title width=10%>입금액</td>
		                    <td width=13%>&nbsp;<input type='text' name='opt_ip_amt2'  value='<%=AddUtil.parseDecimal(cls.getOpt_ip_amt2())%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_maeip_amt(this);' ></td>
		                    <td class=title width=10%>입금일</td>
						    <td width=10%>&nbsp;<input type='text' name='opt_ip_dt2' value='<%=cls.getOpt_ip_dt2()%>'  size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
						    <td class=title width=10%>입금은행</td>
						    <td width=10%>&nbsp;<select name='opt_bank_code2' onChange='javascript:change_bank(this)'>
		                        <option value=''>선택</option>
		                        <%if(a_bank_size > 0){
		        						for(int i = 0 ; i < a_bank_size ; i++){
		        							CodeBean a_bank = a_banks[i];	%>
		                        <option value='<%= a_bank.getCode()%><%= a_bank.getNm()%>' <%if(cls.getOpt_ip_bank2().equals(a_bank.getCode())){%>selected<%}%>> <%= a_bank.getNm()%> 
		                        </option>
		                        <%	}
		        					}	%>
		                      </select>&nbsp;</td>
		                    <td class=title width=10%>계좌번호</td>
				            <td>&nbsp;<select name='opt_deposit_no2'>
		                        <option value=''>계좌를 선택하세요</option>
		        				<%if(!cls.getOpt_ip_bank2().equals("")){
		        						Vector deposits = neoe_db.getDepositList(cls.getOpt_ip_bank2()); /* 계좌번호 */
		        						int deposit_size = deposits.size();
		        						for(int i = 0 ; i < deposit_size ; i++){
		        							Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
		        				<option value='<%=deposit.get("DEPOSIT_NO")%>' <%if(cls.getOpt_ip_bank_no2().equals(String.valueOf(deposit.get("DEPOSIT_NO")))){%>selected<%}%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
		        				<%		}
		        				}%>
		                      </select>
		                    </td>
		                </tr>
		                
		                <tr>
		                    <td class=title width=10%>합계</td>
		                    <td width=13%>&nbsp;<input type='text' name='t_dae_amt' readonly  value='<%=AddUtil.parseDecimal(maeip_amt+cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2())%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' ></td>
		                    <td colspan=6>&nbsp;과입금액:&nbsp; 
		                     	<input type="text" name="ext_amt"  size='15' class='num' value='<%=AddUtil.parseDecimal(m_ext_amt)%>' >	
		                        <input type="radio" name="ext_st" value="1" <%if(cls.getExt_st().equals("1"))%>checked<%%> >고객환불
				                <input type="radio" name="ext_st" value="2" <%if(cls.getExt_st().equals("2"))%>checked<%%> >잡이익	
				     		                	                    
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서</span>&nbsp;&nbsp;<font color=red><%=print_nm%></font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0>
               <tr> 
                  <td width="3%" rowspan="2" class='title'>연번</td>
                  <td colspan="4" class='title'>예정</td>
                  <td colspan="6" class='title'>발행</td>                
                </tr>
                <tr> 
               	  <td width="10%" class='title'>정산항목</td>          
   				  <td width="10%" class='title'>공급가</td> 
   				  <td width="10%" class='title'>부가세</td>       
   				  <td width="10%" class='title'>합계</td>                     
                  <td width="13%" class='title'>품목</td>
                  <td width="10%" class='title'>공급가</td>
                  <td width="10%" class='title'>부가세</td>
                  <td width="10%" class='title'>합계</td>
                  <td width="13%" class='title'>비고</td>
                  <td width="3%" class='title'>발행</td>
                </tr>
                
 <% if  (  !bit.equals("확정") ) { %>
                             
                <tr> 
                  <td height="23" align="center">1</td>
                  <td align="center">잔여개시대여료</td>
                  <td align='center'><input type='text' name='tax_r_supply' size='12' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' name='tax_r_value'  size='12' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);  set_cls_p_tax_hap();' ></td>
                  <td align='center'><input type='text' name='tax_r_hap' readonly size='12' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value=''></td>
                  <td align='center'><input type='text' readonly name='tax_rr_supply'  size='12' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' name='tax_rr_value'  size='12' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();' ></td>
                  <td align='center'><input type='text' name='tax_rr_hap' readonly size='12' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk0' value='Y'></td>
                </tr>
                <tr> 
                  <td align="center">2</td>
                  <td align="center">잔여선납금</td>
                 <td align='center'><input type='text'   name='tax_r_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text'  name='tax_r_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);  set_cls_p_tax_hap();' ></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value=''></td>
                  <td align='center'><input type='text'   name='tax_rr_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text'  name='tax_rr_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"> <input type='checkbox' name='tax_r_chk1' value='Y'></td>
                </tr>
                
                <tr> 
                  <td align="center">3</td>
                  <td align="center">취소대여료</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value=''></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> </td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text'  name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk2' value='Y'></td>
                </tr>
                
                 <tr> 
                  <td align="center">4</td>
                  <td align="center">미납대여료</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value=''></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(1);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text'  name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk3' value='Y'></td>
                </tr>
                                            
                <tr> 
                  <td align="center">5</td>
                  <td align="center">해지위약금</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num'  value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_s()+cls.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value=''></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(2);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_s()+cls.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk4' value='Y' <%if(cls.getTax_chk0().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                <tr> 
                  <td align="center">6</td>
                  <td align="center">회수외주비용</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_s()+cls.getEtc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value=''></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(3);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_s()+cls.getEtc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td> 
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk5' value='Y' <%if(cls.getTax_chk1().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr> 
                <tr> 
                  <td align="center">7</td>
                  <td align="center">회수부대비용</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_s()+cls.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value=''></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(4);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_s()+cls.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td> 
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk6' value='Y' <%if(cls.getTax_chk2().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr> 
                <tr> 
                  <td align="center">8</td>
                  <td align="center">손해배상금</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_s()+cls.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value=''></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(5);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_s()+cls.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk7' value='Y' <%if(cls.getTax_chk3().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr> 
                  <tr> 
                  <td align="center">9</td>
                  <td align="center">초과운행대여료</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getOver_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getOver_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getOver_amt_s()+cls.getOver_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value=''></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getOver_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(6);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getOver_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(cls.getOver_amt_s()+cls.getOver_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text'  name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk8' value='Y' <%if(cls.getTax_chk4().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>            
                             
                <tr> 
                  <td class="title_p" align="center" colspan=2>&nbsp;계</td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td class="title_p" align="center">&nbsp;</td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); ;'></td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td class="title_p" align='center' colspan=2>&nbsp;</td>                  
                </tr>  
<% } else {%>
                      <tr> 
                  <td height="23" align="center">1</td>
                  <td align="center">잔여개시대여료</td>
                  <td align='center'><input type='text' name='tax_r_supply' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' name='tax_r_value' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' name='tax_r_hap' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_s()+ct.getRifee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getRifee_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rifee_s_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' name='tax_rr_value'  size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getR_rifee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();''></td>
                  <td align='center'><input type='text' name='tax_rr_hap' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rifee_s_amt_s()+ct.getR_rifee_s_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk0' value='Y' <%if(ct.getTax_r_chk0().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                <tr> 
                  <td align="center">2</td>
                  <td align="center">잔여선납금</td>
                 <td align='center'><input type='text'  readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_s())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly  name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_s()+ct.getRfee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getRfee_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rfee_s_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getR_rfee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();''></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rfee_s_amt_s()+ct.getR_rfee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"> <input type='checkbox' name='tax_r_chk1' value='Y' <%if(ct.getTax_r_chk1().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                
                <tr> 
                  <td align="center">3</td>
                  <td align="center">취소대여료</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_c_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_c_amt_s()+ct.getDfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getDfee_c_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_c_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_c_amt_s()+ct.getR_dfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text'  name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk2' value='Y' <%if(ct.getTax_r_chk2().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                
                 <tr> 
                  <td align="center">4</td>
                  <td align="center">미납대여료</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_amt_s()+ct.getDfee_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getDfee_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_amt_s())%>'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(1);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_amt_s()+ct.getR_dfee_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text'  name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk3' value='Y' <%if(ct.getTax_r_chk3().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                                            
                <tr> 
                  <td align="center">5</td>
                  <td align="center">해지위약금</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDft_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDft_amt_s()+ct.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getDft_etc()%>' ></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dft_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(2);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dft_amt_s()+ct.getR_dft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk4' value='Y' <%if(ct.getTax_r_chk4().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                <tr> 
                  <td align="center">6</td>
                  <td align="center">회수외주비용</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc_amt_s()+ct.getEtc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text'  value='<%=ct.getEtc_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(3);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc_amt_s()+ct.getR_etc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td> 
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk5' value='Y' <%if(ct.getTax_r_chk5().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr> 
                <tr> 
                  <td align="center">7</td>
                  <td align="center">회수부대비용</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc2_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc2_amt_s()+ct.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text'  value='<%=ct.getEtc2_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc2_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(4);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc2_amt_s()+ct.getR_etc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td> 
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk6' value='Y' <%if(ct.getTax_r_chk6().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr> 
                <tr> 
                  <td align="center">8</td>
                  <td align="center">손해배상금</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc4_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc4_amt_s()+ct.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text'  value='<%=ct.getEtc4_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc4_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(5);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc4_amt_s()+ct.getR_etc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk7' value='Y' <%if(ct.getTax_r_chk7().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>                
                  <tr> 
                  <td align="center">9</td>
                  <td align="center">초과운행대여료</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getOver_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getOver_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getOver_amt_s()+ct.getOver_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getOver_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_over_amt_s())%>'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(6);'></td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_over_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_over_amt_s()+ct.getR_over_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td align='center'><input type='text'  name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk8' value='Y' <%if(ct.getTax_r_chk8().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                
                <tr> 
                  <td class="title_p" align="center" colspan=2>&nbsp;계</td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td class="title_p" align="center">&nbsp;</td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); ;'></td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td class="title_p" align='center' colspan=2>&nbsp;</td>                                        
                </tr>  
 <% }  %>              
            </table>
        </td>
    </tr>
           
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> 선납금이 있고, 매출취소 계산서가 있는 경우는 통합계산서발행시 전산팀에 반드시 문의하세요.!!!</td>
    </tr>
           
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
				                    <td width=13%>&nbsp;<input type='text' name='exam_dt'  size='12'  value= '<%=cce.getExam_dt()%>' class='text' ' onBlur='javascript: this.value = ChangeDate(this.value);'></td> 
				                    <td class=title width=12%>조사담당자</td>
				                    <td >&nbsp;				                    
				                        <select name='exam_id'>
					                <option value="">선택</option>
					                <%	if(user_size > 0){
											for(int i = 0 ; i < user_size ; i++){
												Hashtable user = (Hashtable)users.elementAt(i); %>
					                <option value='<%=user.get("USER_ID")%>' <%if(cce.getExam_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
					                <%		}
										}%>
					              </select></td>
				            </tr>
		               		   <tr>		            
				                     <td class=title width=12%>조사방법</td>
				                     <td  colspan=3>&nbsp;
				                     	  <INPUT TYPE="checkbox" NAME=s_gu1  value='Y' <%if(cce.getS_gu1().equals("Y")){%>checked<%}%> > 1) 사업장방문
                                          <INPUT TYPE="checkbox" NAME=s_gu2  value="Y"<%if(cce.getS_gu2().equals("Y")){%>checked<%}%> > 2) 사업자등록관계열람
                                          <INPUT TYPE="checkbox" NAME=s_gu3  value="Y"<%if(cce.getS_gu3().equals("Y")){%>checked<%}%> > 3) 전화통화
                                          <INPUT TYPE="checkbox" NAME=s_gu4  value="Y"<%if(cce.getS_gu4().equals("Y")){%>checked<%}%> > 4) 기타( <input type='text' name=s_remark' value='<%=cce.getS_remark()%>' size=70' class='text' >   )					                                    
				                     </td>		               
				            </tr>
				             <tr>		            
				                     <td class=title width=12%>결과</td>
				                    <td  colspan=3>&nbsp;<textarea name="s_result" cols="120" class="text" style="IME-MODE: active" rows="2"><%=cce.getS_result()%></textarea>
				                   </td>					                       
				            </tr>
				        
		            </table>
		        </td>
	    </tr>
    	   <tr></tr><tr></tr><tr></tr><tr></tr>
    	  
    	         <tr>
      		   <td><img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle><span class=style2> 보증인 </span>
 	 		      (<input type='radio' name="guar_st" value='1'  <%if(carCre.getGuar_st().equals("1")){%> checked <%}%>>
        				유
        			  <input type='radio' name="guar_st" value='0'  <%if(carCre.getGuar_st().equals("0")){%> checked <%}%>>
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
		                    <td width=13%>&nbsp;<input type='text' name='gu_nm' value='<%=gur.get("GU_NM")%>' size='15' class='text' > </td>
		                    <td class=title width=12%>계약자와관계</td>
		                    <td width=13%>&nbsp;<input type='text' name='gu_rel' value='<%=gur.get("GU_REL")%>' size='15' class='text' ></td>
		                     <td class=title width=12%>연락처</td>
		                    <td width=13%>&nbsp;<input type='text' name='gu_tel' value='<%=gur.get("GU_TEL")%>' size='15' class='text' ></td>
		            </tr>
               		   <tr>		            
		                     <td class=title width=12%>주소</td>
		                    <td  colspan=5>&nbsp;<input type='text' name='gu_zip' value='<%=gur.get("GU_ZIP")%>' size='8' class='text' >&nbsp;<input type='text' name='gu_addr' value='<%=gur.get("GU_ADDR")%>' size='100' class='text' > </td>		               
		            </tr>
		             <tr>		            
		                     <td class=title width=12%>상환계획</td>
		                    <td  colspan=2>&nbsp;<input type='radio' name="plan_st<%=i%>" value='Y' <%if(gur.get("PLAN_ST").equals("Y")){%> checked <%}%>>있음 <input type='radio' name="plan_st<%=i%>" value='N'  <%if(gur.get("PLAN_ST").equals("N")){%> checked <%}%>>없음 </td>	
		                    <td class=title width=12%>보증인의 실효구분</td>
		                    <td  colspan=2>&nbsp;<input type='radio' name="eff_st<%=i%>" value='Y'  <%if(gur.get("EFF_ST").equals("Y")){%> checked <%}%>>있음 <input type='radio' name="eff_st<%=i%>" value='N'  <%if(gur.get("EFF_ST").equals("Y")){%> checked <%}%>>없음 </td>		               
		            </tr>
		            <tr>		            
		                     <td class=title width=12%>없음의근거</td>
		                    <td  colspan=2>&nbsp;<input type='text' name='plan_rem' value='<%=gur.get("PLAN_REM")%>' size='50' class='text' > </td>	
		                    <td class=title width=12%>없음의근거</td>
		                    <td  colspan=2>&nbsp;<input type='text' name='eff_rem' value='<%=gur.get("EFF_REM")%>' size='50' class='text' > </td>		               
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
		                    <td width=12%>&nbsp;<input type='text' name='gi_amt' readonly value='<%=AddUtil.parseDecimal(carCre.getGi_amt())%>' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                    <td class=title width=12%>청구채권</td>
		                    <td width=13%>&nbsp;<input type='text' name='gi_c_amt' size='15' value='<%=AddUtil.parseDecimal(carCre.getGi_c_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'></td>
		                    <td class=title width=12%>잔존채권</td>
		                    <td width=13%>&nbsp;<input type='text' name='gi_j_amt' size='15' value='<%=AddUtil.parseDecimal(carCre.getGi_j_amt())%>' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
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
			                    <td width=12%>&nbsp;<input type='text' name='c_ins' value='<%=carCre.getC_ins()%>'  size='18' class='text' > </td>
			                    <td class=title width=12%>담당자</td>
			                    <td width=13%>&nbsp;<input type='text' name='c_ins_d_nm'  value='<%=carCre.getC_ins_d_nm()%>' size='18' class='text' > </td>
			                    <td class=title width=12%>연락처</td>
			                    <td width=13%>&nbsp;<input type='text' name='c_ins_tel' value='<%=carCre.getC_ins_tel()%>' size='18' class='text' ></td>
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

    <!-- 채권담당자가 처리 : 잔존채권이 있는 경우 --> 
    <tr id=tr_cre style="display:<%if( cls.getFdft_amt2() > 0 ) {%>''<%}else{%>none<%}%>"> 
     
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
	                          <option value="Y" <% if(carCre.getCrd_reg_gu1().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu1().equals("N")){%>selected<%}%>>아니오</option>
		                   </select>      
	                    </td>
	                       <td width=10% align=center> 
		                     <input type='radio' name="crd_req_gu1" value='Y'  <% if(carCre.getCrd_req_gu1().equals("Y")){%> checked <%}%>> 유
	                  		 <input type='radio' name="crd_req_gu1" value='N'  <% if(carCre.getCrd_req_gu1().equals("N")){%> checked <%}%>>  무
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri1' value='<%=carCre.getCrd_pri1()%>' size='1' class='text' ></td>                  		 
	                    <td>&nbsp;<input type='text' name='crd_remark1' value='<%=carCre.getCrd_remark1()%>' size='100' class='text' ></td>
	                 
	                </tr>
	                <tr>
	                    <td class=title>연대보증인구상</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu2">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu2().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu2().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                     <td width=10% align=center> 
		                     <input type='radio' name="crd_req_gu2" value='Y'  <% if(carCre.getCrd_req_gu2().equals("Y")){%> checked <%}%>> 유
	                  		 <input type='radio' name="crd_req_gu2" value='N'  <% if(carCre.getCrd_req_gu2().equals("N")){%> checked <%}%>>  무
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri2' value='<%=carCre.getCrd_pri2()%>' size='1' class='text' ></td>          
	                    <td>&nbsp;<input type='text' name='crd_remark2' value='<%=carCre.getCrd_remark2()%>' size='100' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>채권추심외주</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu3">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu3().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu3().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                       <td width=10% align=center> 
		                     <input type='radio' name="crd_req_gu3" value='Y'  <% if(carCre.getCrd_req_gu3().equals("Y")){%> checked <%}%>> 유
	                  		 <input type='radio' name="crd_req_gu3" value='N'  <% if(carCre.getCrd_req_gu3().equals("N")){%> checked <%}%>>  무
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri3' value='<%=carCre.getCrd_pri3()%>' size='1' class='text' ></td>       
	                    <td>&nbsp;<input type='text' name='crd_remark3' value='<%=carCre.getCrd_remark3()%>' size='100' class='text' ></td>
	                   
	                </tr>
	                <tr>
	                    <td class=title>자동차손해보험</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu4">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu4().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu4().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                       <td width=10% align=center> 
		                     <input type='radio' name="crd_req_gu4" value='Y'  <% if(carCre.getCrd_req_gu4().equals("Y")){%> checked <%}%>> 유
	                  		 <input type='radio' name="crd_req_gu4" value='N'  <% if(carCre.getCrd_req_gu4().equals("N")){%> checked <%}%>>  무
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri4' value='<%=carCre.getCrd_pri4()%>' size='1' class='text' ></td>       
	                    <td>&nbsp;<input type='text' name='crd_remark4' value='<%=carCre.getCrd_remark4()%>' size='100' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>면제</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu5">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu5().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu5().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                       <td width=10% align=center> 
		                     <input type='radio' name="crd_req_gu5" value='Y'  <% if(carCre.getCrd_req_gu5().equals("Y")){%> checked <%}%>> 유
	                  		 <input type='radio' name="crd_req_gu5" value='N'  <% if(carCre.getCrd_req_gu5().equals("N")){%> checked <%}%>>  무
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri5' value='<%=carCre.getCrd_pri5()%>' size='1' class='text' ></td>       
	                    <td>&nbsp;<input type='text' name='crd_remark5' value='<%=carCre.getCrd_remark5()%>' size='100' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>대손처리</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu6">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu6().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu6().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                       <td width=10% align=center> 
		                     <input type='radio' name="crd_req_gu6" value='Y'  <% if(carCre.getCrd_req_gu6().equals("Y")){%> checked <%}%>> 유
	                  		 <input type='radio' name="crd_req_gu6" value='N'  <% if(carCre.getCrd_req_gu6().equals("N")){%> checked <%}%>>  무
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri6' value='<%=carCre.getCrd_pri6()%>' size='1' class='text' ></td>       
	                    <td>&nbsp;<input type='text' name='crd_remark6'  value='<%=carCre.getCrd_remark6()%>' size='100' class='text' ></td>	                  
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
	                    <td width=12%>&nbsp;
							  <select name='crd_id'>
				                <option value="">선택</option>
				                 <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
			                   <option value='<%=user.get("USER_ID")%>' <%if(carCre.getCrd_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
			                 <%		}
							 	}%>	
				              </select>
				        </td>
	                    <td class=title width=12%>사유</td>
					    <td colspan=3>&nbsp;<input type='text' name='crd_reason' value='<%=carCre.getCrd_reason()%>' size='100' maxlength=300 class='text'></td>
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
	   
	<tr id=tr_get style="display:''">	  
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
    		<tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채무자 자구책&nbsp;
		         <%  if (  nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id) || nm_db.getWorkAuthUser("매입옵션관리자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id )||  nm_db.getWorkAuthUser("세금계산서담당자",user_id)  ){%>     
			  	  <a href="javascript:update('tr_get')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
			  	 <% } %>
		       </span></td>
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
								    <option value="1" <%if(cls.getDiv_st().equals("일시납")){%>selected<%}%>>일시납</option>
            					    <option value="2" <%if(cls.getDiv_st().equals("분납")){%>selected<%}%>>분납</option>
					             
					              </select>             
					              <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                        <tr> 
  
					                            <td id='td_div' style="display:<%if( cls.getDiv_st().equals("분납")){%>''<%}else{%>none<%}%>">&nbsp;분납횟수&nbsp;  
					                             <select name="div_cnt">
												    <option value="">---선택---</option>
												    <option value="1" <%if(cls.getDiv_cnt() == 1){%>selected<%}%>>1</option>
            					   					<option value="2" <%if(cls.getDiv_cnt() == 2){%>selected<%}%>>2</option>
            					   				    <option value="3" <%if(cls.getDiv_cnt() == 3){%>selected<%}%>>3</option>
            					   					<option value="4" <%if(cls.getDiv_cnt() == 4){%>selected<%}%>>4</option>
            					   				    <option value="5" <%if(cls.getDiv_cnt() == 5){%>selected<%}%>>5</option>
            					   					<option value="6" <%if(cls.getDiv_cnt() == 6){%>selected<%}%>>6</option>
            					   				    <option value="7" <%if(cls.getDiv_cnt() == 7){%>selected<%}%>>7</option>
            					   					<option value="8" <%if(cls.getDiv_cnt() == 8){%>selected<%}%>>8</option>
            					   				    <option value="9" <%if(cls.getDiv_cnt() == 9){%>selected<%}%>>9</option>
            					   					<option value="10" <%if(cls.getDiv_cnt() == 10){%>selected<%}%>>10</option>
            					   				    <option value="11" <%if(cls.getDiv_cnt() == 11){%>selected<%}%>>11</option>
            					   				    <option value="12" <%if(cls.getDiv_cnt() == 12){%>selected<%}%>>12</option>       
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
		     <tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>              
					                    <td class=title style='height:34' width=13%>파일첨부</td>
					                    <td colspan=7>&nbsp;
					                    
                 <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"3";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>								                    
    						<a href="javascript:scan_reg('3')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
    						<%}%>
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
        
    
    <!-- 환불금액이 있는 경우에 한함 (매입옵션 아닌 경우)--> 
    <tr id=tr_refund style="display:<%if( cls.getFdft_amt2() < 0 && !cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 
  
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
                        <td class="title" width=13% >예금주명</td>
                        <td >&nbsp; <input type="text" name="re_acc_nm" value='<%=cls.getRe_acc_nm()%>' size="30" class=text></td>
                        <td width=13% class="title">은행명</td>
                        <td >&nbsp; <select name="re_bank" style="width:135">
                            <option value="">==선택==</option>                         
			     	 <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					    	<option value='<%=h_c_bnk.get("BCODE")%>'  <%if(cls.getRe_bank().equals((String)h_c_bnk.get("BCODE"))){%>selected<%}%>><%= h_c_bnk.get("BNAME")%></option> > 	
                     
				              <%		}
							}%>
				              </select></td>
                        <td width=13% class="title">계좌번호</td>
                        <td >&nbsp; <input type="text" name="re_acc_no" value='<%=cls.getRe_acc_no()%>' size="30" class=text></td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="title">통장사본</td>
                        <td colspan=2>&nbsp; 
                        
                 <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"1";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>
    						<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>			                        
    						<%}%>
                        </td>
                    	<td colspan=3>&nbsp;<font color=red>※ 고객환불시 예금주명,은행명,계좌번호 입력 필수.!!!</font><br>&nbsp;&nbsp;자동이체통장으로 환불하는경우 사본 첨부 안해도 됨.!!!</td>
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
 
   	<tr id=tr_scd_ext style="display:<%if( cls.getFdft_amt2() < 0 && !cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 
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
    <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>  	 	     
     	
    <tr>
	    <td align='center'>	
	   
	    <% if (  nm_db.getWorkAuthUser("해지관리자",user_id)    || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업수당회계관리자",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id)|| nm_db.getWorkAuthUser("매입옵션관리자",user_id) || nm_db.getWorkAuthUser("계약서류점검담당자",user_id)  || nm_db.getWorkAuthUser("세금계산서담당자",user_id)     ){%>
	    
	     <%if(doc.getUser_dt5().equals("") && !bit.equals("확정")  ){%> <!--금액확정-->
	         <a href="javascript:save('1');"><img src=/acar/images/center/button_hj_bill.gif align=absmiddle border=0></a>&nbsp;
	     <%} else { %>   
	     
	       <%  // if  ( !cls.getCls_st().equals("매입옵션")  && !mode.equals("3")   && !bit.equals("확정")   ) {   %>  <!--수정--> 	 
	         <a href="javascript:save('2');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
	        <%  }%>   	        
	        
	    <%}%>       
	    </td>
	</tr>			  
	<% } %>  
	<tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="3">결재</td>
                    <td class=title colspan=3>발신</td>
                    <td class=title colspan=3>수신</td>
                   
        	    </tr>	
        	     <tr> 
                   
                    <td class=title width=15%>지점명</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%=doc.getUser_nm3()%></td>
                    <td class=title width=15%><%=doc.getUser_nm4()%></td>
                    <td class=title width=15%><%=doc.getUser_nm5()%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></td>
                
                    <td align="center"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			  <%if(doc.getUser_dt2().equals("") && !doc.getUser_id2().equals("XXXXXX") ){
        			  		String user_id2 = doc.getUser_id2();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        					if(!cs_bean.getWork_id().equals("")){									user_id2 = cs_bean.getWork_id(); }
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")){	user_id2 = "000026"; } 
        					%>
        			  <%	if(user_id2.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) ){%>
        			    <a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>        		
                <td align="center"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
                    
        			  <%if( !doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("") ){
        				  	String user_id3 = doc.getUser_id3();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
        					%>
        			  <%	if(user_id3.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) ){%>
        					<input type="checkbox" name="rt" value="Y" >즉시&nbsp;
        					 <% if ( ( cls.getCls_st().equals("출고전해지(신차)") || cls.getCls_st().equals("개시전해지(재리스)") )  &&   fdft_amt2 == 0    ) { %>  <!-- 정산금액이 0인경우 해지처리한다 -->          			            			  
        			         <a href="javascript:clsConSanction()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>   
        			      <%  } else {%> 
        					<a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			      <% } %>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			 	  	  <!--결재자 변경 -->
        		<% if ( doc.getUser_dt3().equals("")  &&  ( doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id)   )    ){ %>
        			   <a href="javascript:doc_id_cng('<%=doc.getDoc_no()%>','3','<%=doc.getUser_id3()%>');">[변경]</a>
        		<% } %>	   
        		 
        			</td> 
        			       			
        		<% if ( cls.getCls_st().equals("매입옵션") || cls.getCls_st().equals("출고전해지(신차)") || cls.getCls_st().equals("개시전해지(재리스)")   ) { %>
        		    <td align="center"></td>
        		<% } else { %>        		    
                    <td align="center"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%>
        			  <%if(!doc.getUser_dt3().equals("") && doc.getUser_dt4().equals("")){
        			  		String user_id4 = doc.getUser_id4();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id4);
        					if(!cs_bean.getWork_id().equals("")){	user_id4 = cs_bean.getWork_id(); }
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	{ user_id4 = "000126"; } //권용식(000077)-> 000144
        					%>
        			  <%	if(doc.getUser_id4().equals(user_id) || user_id4.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)  || nm_db.getWorkAuthUser("채권관리팀",user_id)  ){%>
        			    <a href="javascript:doc_sanction('4')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			  	  <!--결재자 변경 -->
        		<% if ( doc.getUser_dt4().equals("")  &&  ( doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)   )    ){ %>
        			   <a href="javascript:doc_id_cng('<%=doc.getDoc_no()%>','4','<%=doc.getUser_id4()%>');">[변경]</a>
        		<% } %> 	   
        		
        			</td>	
        		<% } %>	
        			<td align="center"><%=c_db.getNameById(doc.getUser_id5(),"USER_PO")%><br><%=doc.getUser_dt5()%>      		
        			  <%if(!doc.getUser_dt3().equals("") && doc.getUser_dt5().equals("")){
        			  		String user_id5 = doc.getUser_id5();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id5);
        					if(!cs_bean.getWork_id().equals("")){	user_id5 = cs_bean.getWork_id(); }
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	{ user_id5 = "000004"; }//안보국(000004)
        					        					%>
        			  <%	if(doc.getUser_id5().equals("000004") || user_id5.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) ||  doc.getUser_id5().equals("000048") ){%>
        			      <a href="javascript:doc_sanction('5')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> 
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			  <!--최종결재자 변경 -->
        		<% if ( doc.getUser_dt5().equals("")  &&  ( doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)   )    ){ %>
        			   <a href="javascript:doc_id_cng('<%=doc.getDoc_no()%>','5','<%=doc.getUser_id5()%>');">[변경]</a> 	   
        		<% } %> 	   
        			</td>				
        	    </tr>	
    		</table>
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
		
		var no_v_amt = 0;
		var no_v_d_amt = 0;
					
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));	
		fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));		
		
		fm.bank_name.value = fm.bank_code.value.substring(3);
		fm.opt_bank_name1.value = fm.opt_bank_code1.value.substring(3);	
		fm.opt_bank_name2.value = fm.opt_bank_code2.value.substring(3);	
			
			
	//	if ( fm.bit.value  == '확정') {		   
		if ( fm.status.value  == '0') {		          
			set_tax_init();
		} else {							
			set_tax_init1();
		}
		
		fm.p_tax_supply.value = 0;
		fm.p_tax_value.value = 0;
		fm.p_tax_hap.value = 0;
		fm.r_tax_supply.value = 0;
		fm.r_tax_value.value = 0;	
		fm.r_tax_hap.value = 0;	
				
		for(var i=0 ; i<9 ; i++){
		  fm.p_tax_supply.value    	= parseDecimal( toInt(parseDigit(fm.p_tax_supply.value)) + toInt(parseDigit(fm.tax_r_supply[i].value)) );
		  fm.p_tax_value.value     	= parseDecimal( toInt(parseDigit(fm.p_tax_value.value)) + toInt(parseDigit(fm.tax_r_value[i].value)) );
		  fm.r_tax_supply.value    	= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.tax_rr_supply[i].value)) );
		  fm.r_tax_value.value     	= parseDecimal( toInt(parseDigit(fm.r_tax_value.value)) + toInt(parseDigit(fm.tax_rr_value[i].value)) );
		}
		fm.p_tax_hap.value    		= parseDecimal( toInt(parseDigit(fm.p_tax_supply.value)) + toInt(parseDigit(fm.p_tax_value.value)) );
		fm.r_tax_hap.value    		= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.r_tax_value.value)) );
				
}
			
	//세금계산서
function set_tax_init(){
		var fm = document.form1;
	
		 //개시대여료 환급
		if(toInt(parseDigit(fm.rifee_s_amt.value)) > 0){
				fm.tax_r_supply[0].value 	= "-"+fm.rifee_s_amt.value;
				
				if ( fm.cls_st.value == '7' ||  fm.cls_st.value == '10' ) {  //출고전해지 또는 개시전해지 
					fm.tax_r_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.ifee_amt.value))  -  toInt(parseDigit(fm.rifee_s_amt.value)) );
				} else {	
					fm.tax_r_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) * 0.1 );
				}
								
				fm.tax_r_hap[0].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[0].value)) + toInt(parseDigit(fm.tax_r_value[0].value)) );
				fm.tax_rr_supply[0].value 	= "-"+fm.rifee_s_amt.value;
				
				if ( fm.cls_st.value == '7' ||  fm.cls_st.value == '10' ) {  //출고전해지 또는 개시전해지 
					fm.tax_rr_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.ifee_amt.value))  -  toInt(parseDigit(fm.rifee_s_amt.value)) );
				} else {	
					fm.tax_rr_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) * 0.1 );
				}
				
				fm.tax_rr_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) * 0.1 );
				fm.tax_rr_hap[0].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[0].value)) + toInt(parseDigit(fm.tax_rr_value[0].value)) );
				fm.tax_r_g[0].value       = "해지 개시대여료 환급";
				fm.tax_r_bigo[0].value    = fm.car_no.value+" 해지";
				fm.tax_r_chk0.checked   	= true;
				fm.rifee_amt_2_v.value = fm.tax_rr_value[0].value 
						
		}
		//선납금 환급
		if(toInt(parseDigit(fm.rfee_s_amt.value)) > 0){
				fm.tax_r_supply[1].value 	= "-"+fm.rfee_s_amt.value;
				if ( fm.cls_st.value == '7' ||  fm.cls_st.value == '10' ) {  //출고전해지 또는 개시전해지 
					fm.tax_r_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.pp_amt.value))  -  toInt(parseDigit(fm.rfee_s_amt.value)) );
				} else {	
					fm.tax_r_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) * 0.1 );
				}
				
			//	fm.tax_r_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) * 0.1 );
				fm.tax_r_hap[1].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[1].value)) + toInt(parseDigit(fm.tax_r_value[1].value)) );
				fm.tax_rr_supply[1].value 	= "-"+fm.rfee_s_amt.value;
				if ( fm.cls_st.value == '7' ||  fm.cls_st.value == '10' ) {  //출고전해지 또는 개시전해지 
					fm.tax_rr_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.pp_amt.value))  -  toInt(parseDigit(fm.rfee_s_amt.value)) );
				} else {	
					fm.tax_rr_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) * 0.1 );
				}
				
			//	fm.tax_rr_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) * 0.1 );
				fm.tax_rr_hap[1].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[1].value)) + toInt(parseDigit(fm.tax_rr_value[1].value)) );
				fm.tax_r_g[1].value       = "해지 선납금 환급";
				fm.tax_r_bigo[1].value    = fm.car_no.value+" 해지";
				fm.tax_r_chk1.checked   	= true;
				fm.rfee_amt_2_v.value = fm.tax_rr_value[1].value 	
		}
					
		// 자동상계인 경우 부가세 끝전 check 추가	
		if (toInt(fm.fdft_amt2.value) < 1 ) {  //자동상계
		
			fm.fine_amt_2.value = fm.fine_amt_1.value;
			fm.car_ja_amt_2.value = fm.car_ja_amt_1.value;
			fm.dfee_amt_2.value = fm.dfee_amt_1.value;
			fm.dly_amt_2.value = fm.dly_amt_1.value;
			fm.dft_amt_2.value = fm.dft_amt_1.value;
			fm.etc_amt_2.value = fm.etc_amt_1.value;
			fm.etc2_amt_2.value = fm.etc2_amt_1.value;
			fm.etc3_amt_2.value = fm.etc3_amt_1.value;
			fm.etc4_amt_2.value = fm.etc4_amt_1.value;
			fm.over_amt_2.value = fm.over_amt_1.value;
		//	fm.no_v_amt_2.value = fm.no_v_amt_1.value;
									
			fm.dfee_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) * 0.1 );
		//	alert(fm.dfee_amt_2_v.value);
			
			if(fm.tax_chk0.checked == true ){
				fm.dft_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dft_amt_2.value)) * 0.1 );
			}
			if(fm.tax_chk1.checked == true ){
				fm.etc_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc_amt_2.value)) * 0.1 );
			}
			if(fm.tax_chk2.checked == true ){
				fm.etc2_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc2_amt_2.value)) * 0.1 );
			}
			if(fm.tax_chk3.checked == true ){
				fm.etc4_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc4_amt_2.value)) * 0.1 );
			}
			
			if(fm.tax_chk4.checked == true ){
					fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );  //초과운행부담금
			} 
					
			
		   if  ( fm.jung_st_chk.value != "" ) {
				
				if  (  fm.jung_st[1].checked == true)  {  //구분정산 선택시
			      
					fm.fine_amt_2.value = '0';
					fm.car_ja_amt_2.value = '0';
					fm.dfee_amt_2.value = '0';
					fm.dly_amt_2.value = '0';
					fm.dft_amt_2.value = '0';
					fm.etc_amt_2.value = '0';
					fm.etc2_amt_2.value = '0';
					fm.etc3_amt_2.value = '0';
					fm.etc4_amt_2.value = '0';
					fm.over_amt_2.value = '0';			
				
					fm.dfee_amt_2_v.value = '0';				
					fm.dft_amt_2_v.value = '0';	
					fm.etc_amt_2_v.value ='0';
					fm.etc2_amt_2_v.value ='0';				
					fm.etc4_amt_2_v.value = '0';
					fm.over_amt_2_v.value ='0';					
					
				}
				
		 }	
		 	
		 	// 잔액 
		  	fm.fine_amt_3.value = parseDecimal( toInt(parseDigit(fm.fine_amt_1.value))  -    toInt(parseDigit(fm.fine_amt_2.value)) ) ;
			fm.car_ja_amt_3.value = parseDecimal( toInt(parseDigit(fm.car_ja_amt_1.value))  -    toInt(parseDigit(fm.car_ja_amt_2.value)) ) ;
			fm.dfee_amt_3.value =parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value))  -    toInt(parseDigit(fm.dfee_amt_2.value)) ) ;
			fm.dly_amt_3.value = parseDecimal( toInt(parseDigit(fm.dly_amt_1.value))  -    toInt(parseDigit(fm.dly_amt_2.value)) ) ;
			fm.dft_amt_3.value =parseDecimal( toInt(parseDigit(fm.dft_amt_1.value))  -    toInt(parseDigit(fm.dft_amt_2.value)) ) ;
			fm.etc_amt_3.value = parseDecimal( toInt(parseDigit(fm.etc_amt_1.value))  -    toInt(parseDigit(fm.etc_amt_2.value)) ) ;
			fm.etc2_amt_3.value = parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value))  -    toInt(parseDigit(fm.etc2_amt_2.value)) ) ;
			fm.etc3_amt_3.value = parseDecimal( toInt(parseDigit(fm.etc3_amt_1.value))  -    toInt(parseDigit(fm.etc3_amt_2.value)) ) ;
			fm.etc4_amt_3.value =parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value))  -    toInt(parseDigit(fm.etc4_amt_2.value)) ) ;
			fm.over_amt_3.value = parseDecimal( toInt(parseDigit(fm.over_amt_1.value))  -    toInt(parseDigit(fm.over_amt_2.value)) ) ;
									
			no_v_amt =   toInt(parseDigit(fm.dfee_amt_2_v.value)) + toInt(parseDigit(fm.tax_r_value[0].value))+ toInt(parseDigit(fm.tax_r_value[1].value))+ toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value)) + toInt(parseDigit(fm.over_amt_2_v.value))  ;
			
			if  ( fm.jung_st_chk.value != "" ) {
				
				if  (  fm.jung_st[1].checked == true)  {  //구분정산 선택시
				} else {	
			
					//부가세 차이가 발생하면 (차이만큼을 대여료에서 처리)
					if ( toInt(parseDigit(fm.no_v_amt_1.value)) != no_v_amt) {			
						no_v_d_amt = toInt(parseDigit(fm.no_v_amt_1.value)) - no_v_amt ;
						fm.dfee_amt_2_v.value = parseDecimal( (toInt(parseDigit(fm.dfee_amt_2.value)) * 0.1 ) + no_v_d_amt ) ;
						no_v_amt =   toInt(parseDigit(fm.dfee_amt_2_v.value)) + toInt(parseDigit(fm.tax_r_value[0].value))+ toInt(parseDigit(fm.tax_r_value[1].value))+ toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value))  + toInt(parseDigit(fm.over_amt_2_v.value))  ;	
					}
				}		
			}
				
			fm.no_v_amt_2.value =  parseDecimal( no_v_amt );
			fm.no_v_amt_3.value =  parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value))  -    toInt(parseDigit(fm.no_v_amt_2.value)) ) ;	
						
			fm.fdft_amt1_2.value 	= parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) + toInt(parseDigit(fm.dly_amt_2.value))+ toInt(parseDigit(fm.dft_amt_2.value)) + toInt(parseDigit(fm.car_ja_amt_2.value)) + toInt(parseDigit(fm.fine_amt_2.value)) + toInt(parseDigit(fm.etc_amt_2.value)) + toInt(parseDigit(fm.etc2_amt_2.value)) + toInt(parseDigit(fm.etc3_amt_2.value)) + toInt(parseDigit(fm.etc4_amt_2.value)) + toInt(parseDigit(fm.over_amt_2.value))  + toInt(parseDigit(fm.no_v_amt_2.value)) );	 //상계금액	
			fm.fdft_amt1_3.value  = parseDecimal( toInt(parseDigit(fm.fdft_amt1_1.value))  -    toInt(parseDigit(fm.fdft_amt1_2.value)) ) ;		
				
			//매입옵션 환불		
			if ( fm.cls_st.value == '8' ) {
				  if  (toInt(parseDigit(fm.m_dae_amt.value))+ toInt(parseDigit(fm.opt_ip_amt1.value))+ toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) > 0 ) {
  						fm.ext_amt.value 	= parseDecimal( toInt(parseDigit(fm.m_dae_amt.value))+ toInt(parseDigit(fm.opt_ip_amt1.value))+ toInt(parseDigit(fm.opt_ip_amt1.value)) - toInt(parseDigit(fm.opt_amt.value))  );				        	  	
				  }
			}		  					
		
			fm.fdft_j_amt.value = parseDecimal( toInt(parseDigit(fm.c_amt.value))  +  toInt(parseDigit(fm.ex_ip_amt.value))  - toInt(parseDigit(fm.fdft_amt1_2.value)));
			
			
		}
		
		// 대여료 선납으로인한 환급분만이 발생한 경우 - 마이너스분만큼 상계할 수 있도록 처리
		if ( toInt(fm.dfee_amt_1.value) < 1 && toInt(fm.fdft_amt2.value) > 0 )  {  //자동상계
			fm.dfee_amt_2.value = fm.dfee_amt_1.value;
			fm.dfee_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) * 0.1 );		
		}	
				
		//기발행 세금계산서가 있는 경우
		if (toInt(fm.re_day.value) > 0 ) {
			
			// 매입옵션인 경우 	- 중도매입옵션인경우는 cls_etc_detail로 
			if ( fm.cls_st.value == '8' ) {
			    if (  toInt(parseDigit(fm.dfee_amt.value)) ==  toInt(parseDigit(fm.tfee_s_amt.value)) ) {
			    
			    } else { //같지않다면
			    	if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후		
				
						if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
				        		if ( fm.dly_s_dt.value == '99999999' ) {
						 		//	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
						  		//	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );				    	
						        } else {  //과부족은 계산서 발행되었다는 가정...						        							        						        	
						        //	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) *  toInt(fm.nfee_day.value)/30  );  //nfee_day 만큼				        	  	
					    		//	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );
					    			
					    			fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_amt_1.value)) - toInt(parseDigit(fm.tfee_s_amt.value)));
									fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );					    			
						        }
				       	} else {
				        		fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
					    		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
					   	}
				  }				    
			   } 
					
			} else { //매입옵션이 아니면
			
			   				
			    //미납이 있는 경우
				if(toInt(parseDigit(fm.nfee_amt_1.value)) > 0){
				   
						fm.tax_r_supply[2].value 	= "-"+parseDecimal( toInt(parseDigit(fm.tfee_s_amt.value)));
						fm.tax_r_value[2].value 	= "-"+parseDecimal( toInt(parseDigit(fm.tfee_v_amt.value)));					
					 				
						fm.tax_r_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) + toInt(parseDigit(fm.tax_r_value[2].value)) );
					
						fm.tax_rr_supply[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value))); 
						fm.tax_rr_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[2].value))); 
						fm.tax_rr_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[2].value)) + toInt(parseDigit(fm.tax_rr_value[2].value)) );
							
						fm.tax_r_g[2].value       = "해지 취소 대여료";
							
						fm.tax_r_bigo[2].value    = fm.car_no.value+" 해지";
						fm.tax_r_chk2.checked   	= true;						
												  		       
			  		     //계산서 발행최소된 날짜부터 해지일로 재계산 적용 - 20100928 		  
			       		fm.tax_r_supply[3].value 	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.u_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.u_day.value)) );			       	    	 		
			       		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );
			       		   			  		       												
						fm.tax_r_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) + toInt(parseDigit(fm.tax_r_value[3].value)) );
					
						fm.tax_rr_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value))); 
						fm.tax_rr_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[3].value))); 
						fm.tax_rr_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) + toInt(parseDigit(fm.tax_rr_value[3].value)) );
								
						fm.tax_r_g[3].value       = "해지 대여료";
					
						fm.tax_r_bigo[3].value    = fm.car_no.value+" 해지";
						fm.tax_r_chk3.checked   	= true;		
				
				} else {
					//	alert(toInt(parseDigit(fm.ex_di_amt_1.value)));
				    	if(toInt(parseDigit(fm.ex_di_amt_1.value)) < 0 ){  //선납인 경우 - 남은 금액 세금계산서
								fm.tax_r_supply[2].value 	= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)));
								fm.tax_r_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) * 0.1 );	
															     				
								fm.tax_r_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) + toInt(parseDigit(fm.tax_r_value[2].value)) );
							
								fm.tax_rr_supply[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value))); 
								fm.tax_rr_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[2].value))); 
								fm.tax_rr_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[2].value)) + toInt(parseDigit(fm.tax_rr_value[2].value)) );
									
								fm.tax_r_g[2].value       = "해지 취소 대여료";
									
								fm.tax_r_bigo[2].value    = fm.car_no.value+" 해지";
								fm.tax_r_chk2.checked   	= true;
					    } else {
								
								// 일부미납이 있는 경우 - 해지일과 만료일 체크하여 일수만큼 취소	
								fm.tax_r_supply[2].value 	= "-"+parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.re_day.value)/30))   );
								fm.tax_r_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) * 0.1 );	
																								 				
								fm.tax_r_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) + toInt(parseDigit(fm.tax_r_value[2].value)) );
							
								fm.tax_rr_supply[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value))); 
								fm.tax_rr_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[2].value))); 
								fm.tax_rr_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[2].value)) + toInt(parseDigit(fm.tax_rr_value[2].value)) );
									
								fm.tax_r_g[2].value       = "해지 취소 대여료";
									
								fm.tax_r_bigo[2].value    = fm.car_no.value+" 해지";
								fm.tax_r_chk2.checked   	= true;
						}					
				}				
				
			}	
		
		}
							
		//미납대여료  -- 세금계산서를 발행하지 않고 대여료를 낸경우는??? - 과부족금액만 있는 경우도 계산서발행이 안된건이 있을 수도 있음. -20100524
		if(toInt(parseDigit(fm.nfee_amt_1.value)) >= 0){
		
		           //세금계산서가 발행안 된 경우 	
		      if (toInt(fm.re_day.value) < 0 ) {
		     		 
		     			// 매입옵션인 경우 	
				if ( fm.cls_st.value == '8' ) {
				       //매입옵션은 미납발행계산서는 해지정산에서 발행하지 않음.
				     if (   toInt(fm.old_opt_amt.value)  > 0 ) {  //중도매입옵션인 경우
				     		//	fm.tax_r_supply[3].value 	=  parseDecimal( toInt(parseDigit(fm.t_r_fee_s_amt.value))  );				        	  	
						  	//	fm.tax_r_value[3].value 	=  parseDecimal( toInt(parseDigit(fm.t_r_fee_v_amt.value))  );		
						  		fm.tax_r_supply[3].value 	=  parseDecimal( toInt(parseDigit(fm.ts_r_fee_amt.value))  );				        	  	
						  		fm.tax_r_value[3].value 	=  parseDecimal( toInt(parseDigit(fm.tv_r_fee_amt.value))  );		
						  				        	  					     
				     } else {	      
				       				       
							  if (toInt(fm.re_day.value) * (-1) < 31 ) {
							      	 if ( toInt(fm.rent_end_dt.value) >=  toInt(replaceString("-","",fm.cls_dt.value)) ) {
								      		fm.tax_r_supply[3].value = fm.nnfee_s_amt.value;
								     		fm.tax_r_value[3].value = fm.nnfee_v_amt.value;		//20191111 수정 - 끝회차 금액으로 						     										     		
										//	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );																											
											
									//	alert(fm.tax_r_supply[3].value );	
												      	
							     	 }  else {	
										fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.re_day.value)* (-1)/30) );				        	  	
							  			fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
						  			}							
							  } else {
							       
							 		 if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
							 		
					        				if ( fm.dly_s_dt.value == '99999999' ) {  //스케쥴발행이 안되있는 건
							 					fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
							  					fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							  				}	
								  	 } else {  //미발행분
								  	
								  		    //대여만료일과 해지일이 같은 경우는 마지막회차 대여료로 무조건처리)
								  		    if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {						  		  
								  		    	fm.tax_r_supply[3].value = fm.nnfee_s_amt.value;
								  		  		fm.tax_r_value[3].value = fm.nnfee_v_amt.value;		//20191111 수정 - 끝회차 금액으로 		
								  		     // 	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );
								  						  					        	  	
								  		    } else {
								  			 	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
						    				 	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );
								  		    }							  		 
							  		 }			  
							  }  //31일 끝						  
	     		      }
	     		      
		     		} else {	//매입옵션이 아니면 
		     			     
					    if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
								  		
				        	   if ( fm.dly_s_dt.value == '99999999' ) { //미납이 없다.
				        		
						 			fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
						  			fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );				    	
						        } else { //세금계산서 발행이 안된 일수
						          
							            if (toInt(fm.re_day.value) * (-1) < 31 ) {
											fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.re_day.value)* (-1)/30) );				        	  	
							  				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							  				
							  	   } else {
							  			 	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
							  			 //	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) *  toInt(fm.nfee_day.value)/30  );  //nfee_day 만큼				        	  	
							    			fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							    	  }						    
						        }
				        } else {	// t_mon, t_day 가 있는 경우
				          
				        	  //대여만료일과 해지일이 같은 경우는 마지막회차 대여료로 무조건처리) --미리납부하는 경우 nnfee_s_amt 금액이 0라서 안되고 있음
						   if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {		
						   
						   		if ( toInt(fm.nnfee_s_amt.value) == 0 )  { //계산서 발행전 미리 납부한 경우는 별도처라
						   			    fm.tax_r_supply[3].value = parseDecimal(fm.lfee_s_amt.value);
						   			    fm.tax_r_value[3].value = parseDecimal(fm.lfee_v_amt.value);
					    			//	fm.tax_r_value[3].value = parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
						   		} else {
						   		    if ( toInt(fm.dly_s_dt.value) <= toInt(fm.tuse_s_dt.value) ) {	
						   		     	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
						    			fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
						   		     
						    			//마지막회차만 발행이 안된 경우라면 - 스케쥴에 맞춘다	-20191203
						    			if ( fm.con_mon.value == '<%=tax3.get("FEE_TM")%>') {  					    			 
							   		        fm.tax_r_supply[3].value = parseDecimal(fm.lfee_s_amt.value);
							   			    fm.tax_r_value[3].value = parseDecimal(fm.lfee_v_amt.value);
						    			}						   		  
					    			
						   		     } else {
							   		       fm.tax_r_supply[3].value = fm.nnfee_s_amt.value;
							        	   fm.tax_r_value[3].value  = parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );
							       	 }		 
						         }	 
						      
					         } else {  //같지 않다면 
					        	  	
						      		fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
							    	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );					    		
						      }
					    	    		    		
					   }
		     		
						// 부가세 맞추기 - 20191202 - 잔액이 아닌 미납금액이 같다면 (한회차인 경우)
					 	if ( toInt(parseDigit(fm.hs_mon.value)) <= 1  &&  toInt(parseDigit(fm.hs_day.value)) > 1 ) {
							if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {	
						    	fm.tax_r_supply[3].value = parseDecimal(fm.nnfee_s_amt.value);
			    				fm.tax_r_value[3].value  = parseDecimal(fm.nnfee_v_amt.value);	
							}
				 	    }	
					    	
					    	//개시대여료가 있었던 계약인 경우 
					   if (toInt(fm.ifee_s_amt.value) != 0 ) {
					    	     
					    		if ( toInt(fm.rifee_s_amt.value) > 0 )  { //잔액이 남아있는 경우
						     			fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
						    			fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );							    	
							 } else { //잔액을 다 소진하여 계약기간 이후인 경우
							    	  if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우  - 세금계산서 발행안된 이후만 발행	
							    		 if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
								    		   if ( fm.dly_s_dt.value == '99999999' ) { //스케쥴이 없어서 발행이 안되는 경우
						        					fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
								  					fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );				    	
								      		   } else {
								      		    	 if (toInt(fm.re_day.value) * (-1) < 31 ) {
														fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.re_day.value)* (-1)/30) );				        	  	
										  				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
									  				 }						      		   
								      		   }
							      		   	
							      		 } else {   //t_mon, t_day 가 0이 아닌 경우
							    		
							    			fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
							    	 	 //	fm.tax_r_supply[3].value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.t_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.t_day.value)) );
						     				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							    	  	 }
							    	  } else { //미납액에 대해서 세금계산서 발행 - 개시대여료 뺀 나머지스케쥴에서 계산서 발행안된 건만 발행
							    	 	    				    	  
							    	   		fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
							    	   		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							    	   		
								    	//	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
								    	//	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );									    	
							    	  } 
							    	
							} //잔액       	
								
					    }   //개시대여료  
					
			      }   //매입옵션 끝			
				 					
			  }   // re_day < 0
			  				
			  //최초 발행?		
			  if ( toInt(fm.re_day.value) ==  0  &&  toInt(fm.fee_tm.value) ==  999) {
			  		if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
					      	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
					  		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
					}  	
					
					//개시대여료가 있는 경우
					if (toInt(fm.ifee_s_amt.value) != 0 ) {    	
			    		if ( toInt(fm.rifee_s_amt.value) > 0 )  { //잔액이 남아있는 경우				    	
			    				fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
			    				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );						    	
			    		}					
					}	
			  }			
			
			  if (	 toInt(parseDigit(fm.tax_r_supply[3].value)) != 0 ){			
							
				  fm.tax_r_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) + toInt(parseDigit(fm.tax_r_value[3].value)) );
					
				  fm.tax_rr_supply[3].value = parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value))); 
				  fm.tax_rr_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[3].value))); 
				  fm.tax_rr_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) + toInt(parseDigit(fm.tax_rr_value[3].value)) );
							
				  fm.tax_r_g[3].value       = "해지 대여료";
					
				  fm.tax_r_bigo[3].value    = fm.car_no.value+" 해지";
				  fm.tax_r_chk3.checked   	= true;
			  }				
				
				//만기매칭인경우 계산서 발행안되게  				
			   if (   fm.match.value == 'Y' ) {
			     fm.tax_r_chk3.checked   	= false;			   			   
			   }	
							
		}//미납대여료					
		
		//대여료  -- 세금계산서를 발행하지 않고 대여료를 낸경우는???
		if(toInt(parseDigit(fm.ex_di_amt_1.value)) < 0){
		     		     		     
		           //세금계산서가 발행안 된 경우 	
		        if (toInt(fm.re_day.value) < 0 ) {
		        				        		
	        		 if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우  - 세금계산서 발행안된 이후만 발행	
				    		 if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
					    		   if ( fm.dly_s_dt.value == '99999999' ) { //스케쥴이 없어서 발행이 안되는 경우
			        					fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
					  					fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );				    	
					      		   } else {
					      		     if (toInt(fm.re_day.value) * (-1) < 31 ) {
										fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.re_day.value)* (-1)/30) );				        	  	
						  				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
						  			 }						      		   
					      		   }					      		   	
				      		 } else {					    		
				    			fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
				    	 		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
				    	  	 }				    	  	 
				    
				      } 	
					  						  			 
		                 //대여료 - 선납분
		              fm.tax_r_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) + toInt(parseDigit(fm.tax_r_value[3].value)) );
				
					  fm.tax_rr_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value))); 
					  fm.tax_rr_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[3].value))); 
				  	  fm.tax_rr_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) + toInt(parseDigit(fm.tax_rr_value[3].value)) );
								
					  fm.tax_r_g[3].value       = "해지 대여료";
					
					  fm.tax_r_bigo[3].value    = fm.car_no.value+" 해지";
				  	  fm.tax_r_chk3.checked   	= true;
		        
				}
				
		}		
		
		//중도매입인경우 - 대여료가 매입옵션금액에 포함되는경우는 미납 대여료 계산서 발행 안함  - 
		if ( fm.cls_st.value == '8' ) {
			if ( toInt(parseDigit(fm.ts_r_fee_amt.value))  > 0  ) {
				 fm.tax_r_chk3.checked   	= false;
			}		    	
		}
		/*			
		//중도해지위약금
		if(fm.tax_chk0.checked == true ){
				fm.tax_r_supply[4].value 	= fm.dft_amt_1.value;
				fm.tax_r_value[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[4].value)) * 0.1 );	
			
				fm.tax_r_hap[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[4].value)) + toInt(parseDigit(fm.tax_r_value[4].value)) );
				
				fm.tax_rr_supply[4].value 	= fm.dft_amt_1.value;
				fm.tax_rr_value[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[4].value)) * 0.1 );	
				fm.tax_rr_hap[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[4].value)) + toInt(parseDigit(fm.tax_rr_value[4].value)) );
				
				fm.tax_r_g[4].value       = "해지 위약금";
				fm.tax_r_bigo[4].value    = fm.car_no.value+" 해지";
				fm.tax_r_chk4.checked   	= true;
				
		}
		//회수외주비용
		if(fm.tax_chk1.checked == true ){
				fm.tax_r_supply[5].value 	= fm.etc_amt_1.value;
				fm.tax_r_value[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[5].value)) * 0.1 );	
				fm.tax_r_hap[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[5].value)) + toInt(parseDigit(fm.tax_r_value[5].value)) );		
				fm.tax_rr_supply[5].value 	= fm.etc_amt_1.value;
				fm.tax_rr_value[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[5].value)) * 0.1 );	
				fm.tax_rr_hap[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[5].value)) + toInt(parseDigit(fm.tax_rr_value[5].value)) );			
				fm.tax_r_g[5].value       = "해지 회수외주비용";
				fm.tax_r_bigo[5].value    = fm.car_no.value+" 해지";
				fm.tax_r_chk5.checked   	= true;
			

		}
			//회수부대비용
		if(fm.tax_chk2.checked== true ){
				fm.tax_r_supply[6].value 	= fm.etc2_amt_1.value;
				fm.tax_r_value[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[6].value)) * 0.1 );	
				fm.tax_r_hap[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[6].value)) + toInt(parseDigit(fm.tax_r_value[6].value)) );		
				fm.tax_rr_supply[6].value 	= fm.etc2_amt_1.value;
				fm.tax_rr_value[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[6].value)) * 0.1 );	
				fm.tax_rr_hap[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[6].value)) + toInt(parseDigit(fm.tax_rr_value[6].value)) );			
				fm.tax_r_g[6].value       = "해지 회수부대비용";
				fm.tax_r_bigo[6].value    = fm.car_no.value+" 해지";
				fm.tax_r_chk6.checked   	= true;
			

		}
			//기타손해배상금(면책금)
		if(fm.tax_chk3.checked == true ){
				fm.tax_r_supply[7].value 	= fm.etc4_amt_1.value;
				fm.tax_r_value[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[7].value)) * 0.1 );	
				fm.tax_r_hap[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[7].value)) + toInt(parseDigit(fm.tax_r_value[7].value)) );	
				fm.tax_rr_supply[7].value 	= fm.etc4_amt_1.value;
				fm.tax_rr_value[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[7].value)) * 0.1 );	
				fm.tax_rr_hap[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[7].value)) + toInt(parseDigit(fm.tax_rr_value[7].value)) );		
				fm.tax_r_g[7].value       = "해지 손해배상금";
					
				fm.tax_r_bigo[7].value    = fm.car_no.value+" 해지";
				fm.tax_r_chk7.checked   	= true;
				
		}	
		*/
			//초과운행부담금
		if(fm.tax_chk4.checked == true ){	
//		if(toInt(parseDigit(fm.over_amt_1.value)) > 0){
				fm.tax_r_supply[8].value 	= fm.over_amt.value;
				fm.tax_r_value[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[8].value)) * 0.1 );	
				fm.tax_r_hap[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[8].value)) + toInt(parseDigit(fm.tax_r_value[8].value)) );	
				fm.tax_rr_supply[8].value 	= fm.over_amt_1.value;
				fm.tax_rr_value[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[8].value)) * 0.1 );	
				fm.tax_rr_hap[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[8].value)) + toInt(parseDigit(fm.tax_rr_value[8].value)) );	
				
				fm.tax_r_g[8].value       = "해지 초과운행대여료";
									
				fm.tax_r_bigo[8].value    = fm.car_no.value+" 해지";
				fm.tax_r_chk8.checked   	= true;
								
		}									
		
}	
		
	
//세금계산서
function set_tax_init1() {
	var fm = document.form1;              
     
	  //개시대여료 환급
	if(toInt(parseDigit(fm.rifee_s_amt.value)) > 0){
			fm.tax_r_bigo[0].value    = fm.car_no.value+" 해지";	
	}
	
	//선납금 환급
	if(toInt(parseDigit(fm.rfee_s_amt.value)) > 0){
			fm.tax_r_bigo[1].value    = fm.car_no.value+" 해지";			
	}
	
		//취소대여료  
	//세금계산서가 발행된 경우
	if (toInt(fm.re_day.value) > 0 ) {
	  //미납이 있는 경우
	    if (fm.cls_st.value != '8' ) { //매입옵션이 아니면		 
			if(toInt(parseDigit(fm.nfee_amt_1.value)) > 0){ 
				fm.tax_r_bigo[2].value    = fm.car_no.value+" 해지";
				fm.tax_r_bigo[3].value    = fm.car_no.value+" 해지";	
			} else {
				fm.tax_r_bigo[2].value    = fm.car_no.value+" 해지";
			}
		}	
	}
	
	
	//선불인경우 과부족이 마이너스  ---  
	if(toInt(parseDigit(fm.ex_di_amt_1.value)) < 0 ){
		 if (toInt(fm.nfee_amt_1.value) < 1 ) {
		 	fm.tax_r_bigo[2].value    = fm.car_no.value+" 해지";
		 }
	} 
	
	//미납대여료  
	if(toInt(parseDigit(fm.nfee_amt_1.value)) > 0){
	     //세금계산서가 발행안 된 경우
	    if (toInt(fm.re_day.value) < 0 ) {
			fm.tax_r_bigo[3].value    = fm.car_no.value+" 해지";	
		}		
	}
	
	//중도해지위약금
	if(fm.tax_chk0.checked == true ){
			fm.tax_r_bigo[4].value    = fm.car_no.value+" 해지";		
	}
	
	//회수외주비용
	if(fm.tax_chk1.checked == true ){
			fm.tax_r_bigo[5].value    = fm.car_no.value+" 해지";
	}
	
		//회수부대비용
	if(fm.tax_chk2.checked== true ){
			fm.tax_r_bigo[6].value    = fm.car_no.value+" 해지";
	}
		//기타손해배상금(면책금)
	if(fm.tax_chk3.checked == true ){		
			fm.tax_r_bigo[7].value    = fm.car_no.value+" 해지";		
	}
			
		//초과운행부담금 - 20160803 수정 - 이전은 무조건 계산서 발행 
	if(fm.tax_chk4.checked == true ){			
		fm.tax_r_bigo[8].value    = fm.car_no.value+" 해지";		
	}
		
//    fm.fdft_j_amt.value = parseDecimal( toInt(parseDigit(fm.c_amt.value))  +  toInt(parseDigit(fm.ex_ip_amt.value))  - toInt(parseDigit(fm.fdft_amt1_2.value)));		
	  
}

</script>
</body>
</html>
