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
	
	//????????????
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//????????????
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
//	int guar_cnt = 0;
//	if  (cont_etc.getClient_guar_st().equals("1") ) guar_cnt++;
//	if  (cont_etc.getGuar_st().equals("1") ) guar_cnt++;
	
	//1. ???? ---------------------------
	
	//????????
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	String print_nm = "";
	if ( client.getPrint_st().equals("2")) {
		print_nm = "??????????????";
	} else if  ( client.getPrint_st().equals("3")) {
		print_nm = "????????????";
	} else if (  client.getPrint_st().equals("4")) {
		print_nm = "????????????";
	} else if  ( client.getPrint_st().equals("9")) {
		print_nm = "????????????";
	}
	
	//????????
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//????????????
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//????????????
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//???????????? ??????
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//??????????????
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//????????????
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. ????-----------------------------
	
	//??????????????(????????)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//????????????
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
		//????????
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
		
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//fee ???? - ???????? ?????? ????  - fee_etc ??  over_run_amt > 0???? ?? ???? ??????
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	ClsEtcOverBean co = ac_db.getClsEtcOver(rent_mng_id, rent_l_cd);
	
//	 int o_p_m  =  (int)  car1.getAgree_dist() / 12 ;
//	 int o_p_d  =   (int)  car1.getAgree_dist() / 365 ;
	 
//	 int  o_amt =   car1.getOver_run_amt();
	 
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//?????? ??????
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
		
		//?????? ??????
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
	
		//????????????
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	
	String cls_st = cls.getCls_st_r();
	String term_yn = cls.getTerm_yn();
	int   fdft_amt2 =  cls.getFdft_amt2();
				
	//????????
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls.getCls_dt(), "");
	
	//????????????
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//?????????? 
//	Vector gurs = a_db.getContGurList1(rent_mng_id,  rent_l_cd);
	Vector gurs = r_db.getClsCarGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
	int  ext_amt = 0;
		
	
		
	//???????? ???? ????
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);
		
	//????????????????
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);
	
	//????????????
	CarRecoBean carReco = ac_db.getCarReco(rent_mng_id, rent_l_cd);
	
	//????????????
	CarCreditBean carCre = ac_db.getCarCredit(rent_mng_id, rent_l_cd);
	
		// ??????????????	
	ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);
			
	//????????
	DocSettleBean doc = d_db.getDocSettle(doc_no);

	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("11", rent_l_cd);
		doc_no = doc.getDoc_no();
	}else{
		doc = d_db.getDocSettle(doc_no);
	}
		
	//???????????????? ????????????	
		
	//??????????
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
		
	//?????? ??????????
	CodeBean[] a_banks = neoe_db.getCodeAll();
	int a_bank_size = a_banks.length;
	
	//?????? ??????????
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
	int re_day = 0;
	
	Hashtable tax2= ac_db.getScdFeeTaxVatAmt(rent_mng_id, rent_l_cd, fee_tm); //???????????????? ??????, ?????? ??????
	 
	if ( cls_st.equals("8" ) )  {
	           if (     AddUtil.parseInt( String.valueOf(base1.get("RENT_END_DT") ) )  <  AddUtil.parseInt( String.valueOf(base1.get("USE_S_DT") ) )     ) {  //?????????? ???????????? ????
				re_day = ac_db.getRemainFeeDay(rent_l_cd, fee_tm, cls.getCls_dt());  				
	            } else {
		        if (    AddUtil.parseInt(cls.getCls_dt() ) <  AddUtil.parseInt( String.valueOf(base1.get("USE_E_DT") ) )     ) {  //?????????? ?????????? ???????? ???? ?????????? ?????? ?????? ????.
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
		 tax3= ac_db.getScdFeeTaxVatAmt(rent_mng_id, rent_l_cd, Integer.toString(a_fee_tm) ); //????????????????????????????  ??????, ?????? ??????
	}
	//???????????????? ???? ????
	Hashtable ht_t = new Hashtable();
	 
	if (re_day > 0 ) {
	  ht_t = af_db.getUseMonDay(cls.getCls_dt(),  String.valueOf(tax2.get("USE_S_DT")) );
	} 
	 
	Hashtable tax1 = new Hashtable();
	//???????????????? - ?????????? ???? 2?????????? ????.  - use_e_dt : ???????????? , rent_end_dt :??????????  
	if ( cls_st.equals("8" ) )  {
	        if (    AddUtil.parseInt(cls.getCls_dt() ) <  AddUtil.parseInt( String.valueOf(base1.get("USE_E_DT") ) )     ) {  //?????????? ?????????? ???????? ???? ?????????? ?????? ?????? ????.
	      	     tax1 = ac_db.getSettleTaxRemain(rent_mng_id, rent_l_cd, String.valueOf(base1.get("USE_E_DT") ), fee_tm );
	          } else {
	              tax1 = ac_db.getSettleTaxRemain(rent_mng_id, rent_l_cd, cls.getCls_dt(), fee_tm );
	          } 
	} else {
		 tax1 = ac_db.getSettleTaxRemain(rent_mng_id, rent_l_cd, cls.getCls_dt(), fee_tm );
	}
		
	
	//?????????? ???????? - ??????????
	ClsEtcTaxBean ct = ac_db.getClsEtcTaxCase(rent_mng_id, rent_l_cd, 1);
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
	Vector cms_bnk = c_db.getCmsBank();	//???????? ????????.
	int cms_bnk_size1 = cms_bnk.size();		
	
	int maeip_amt = 0;	 //?????????? ???? ???????? 
	int m_ext_amt = 0;  //?????????? ???? ????/?????? 
		
	//???????????????? 
	String tae_prv_dlv_yn = fee.getPrv_dlv_yn(); 
	
	int tae_cnt = 0;
	String tae_e_dt = "";
	
	if (tae_prv_dlv_yn.equals("Y")) {
		tae_cnt = ac_db.getClsEtcTaeChaCnt(rent_mng_id, rent_l_cd);
		
		if (tae_cnt > 0 ) {
		//?????????????? max(use_e_dt)
		 	 tae_e_dt = ac_db.getClsEtcTaeChaUseEndDt(rent_mng_id, rent_l_cd);
	  	} 	
	}
	
		//???????? ??????
	Vector vt_ext = as_db.getClsList(base.getClient_id());
	int vt_size = vt_ext.size();
	
	
	//???????? ????????
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id() );		
	
	String return_remark = "";
	Hashtable  return1 =   new Hashtable();
	
   if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id()); 	
	   	return_remark = (String)return1.get("REMARK");
  }
  	
  	
	//???????? ???? 
	ClsCarExamBean cce 	= r_db.getClsCarExam(rent_mng_id, rent_l_cd, 1);
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "CLS_ETC";
	String content_seq  = rent_mng_id+""+rent_l_cd;

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
	
	        //?????????????? ????	
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
	
  //???????????? ?????? ???????? 
  Hashtable m_tax1 = new Hashtable();
  m_tax1 = ac_db.getSettleTaxRemain(rent_mng_id, rent_l_cd, Integer.parseInt(fee_tm) );	

	//cms ????
	Hashtable h_cms = c_db.getCmsBank_info(rent_l_cd);
	
	String re_bank = "";
	String re_acc_no = "";
	String re_acc_nm = "";
		
	re_bank = (String)h_cms.get("CBNK");
	re_acc_no = (String) h_cms.get("CBNO");
	re_acc_nm = (String) h_cms.get("CYJ");	
	 		
	seBean = olsD.getSuiEtc(base.getCar_mng_id());		
		  		 					
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

	//???????? ????
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//???? ?????????????????? ????	
	function move_fee_scd(){
		var fm = document.form1;	
		
		fm.action = "/fms2/con_fee/fee_scd_u_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>";
		fm.target = 'd_content';		
		fm.submit();							
	}
	
//?????? ????
	function cls_print(){
		var fm = document.form1;

		var SUBWIN="lc_cls_print.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=700, height=650, resizable=yes, scrollbars=yes, status=yes");
		
	}

//??????
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
	
	//???? ????
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//????/???? ????
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			

	//?????????????? ????
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//????????
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=50, top=50, width=850, height=650, resizable=yes, scrollbars=yes, status=yes");
	}		
		
	function save(chk){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('?????????? ????????????'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('?????????? ????????????'); 		fm.cls_dt.focus(); 		return;	}
						
		//???????? + ???? ?????? ???? ?????????? ?????? 
		if( ( toInt(parseDigit(fm.c_amt.value))  + toInt(parseDigit(fm.ex_ip_amt.value)) +  toInt(parseDigit(fm.opt_ip_amt1.value)) +  toInt(parseDigit(fm.opt_ip_amt2.value)) -  toInt(parseDigit(fm.fdft_amt1_2.value)) )  < -1 ) {
			alert("??????????????(??????????????????) ?????????? ?????? ?? ????????.\n ?????????? ????????????.!!");
			return;
		}			
										
		//?????? ???? ???? ???? ???? ???? ??????
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  >  0  ) {		
			if ( toInt(parseDigit(fm.tax_r_supply[3].value))  >  toInt(parseDigit(fm.dfee_amt_1.value)) ) {
				//alert(toInt(parseDigit(fm.tax_r_supply[3].value)));
				//alert(toInt(parseDigit(fm.dfee_amt_1.value)));
				//alert(toInt(parseDigit(fm.tax_rr_supply[3].value)));
				//alert(toInt(parseDigit(fm.nfee_amt_1.value)));
				if ( toInt(parseDigit(fm.tax_rr_supply[3].value)) <= toInt(parseDigit(fm.nfee_amt_1.value)) ) {
				}else {
					if(!confirm("?????????? ?????? ?????????? ??????????.!!"))	return;
//					alert("?????????? ?????? ?????????? ??????????.!!");
//					return;
				}	
		    }		
		}
			
		
		//?????????? ????
		if (fm.cls_st.value  == '8' ) {	
			//???????? + ???? ?????? ???? ?????????? ?????? 
			
			if( ( toInt(parseDigit(fm.fdft_amt1_1.value))  !=  toInt(parseDigit(fm.fdft_amt1_2.value)) )  ) {
				alert("?????????? ?????????? ??????..!!");
				return;
			}
			
			//???????? ?????????????? ???? ???? - 100???? ????????
			if( toInt(parseDigit(fm.fdft_amt3.value)) > 100 ){ // ???????? ???? ?????? ???? ????
				if(fm.opt_ip_amt1.value == ""){ alert("???????? ??????????."); return; }
				if(fm.opt_ip_dt1.value == "") { alert("???????? ??????????."); return; }			
			//	if(fm.opt_bank_code1.value == ""){ alert("?????? ????????????."); return; }			
			//	if(fm.opt_deposit_no1.value == ""){ alert("?????????? ????????????."); return; }
				
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
	 		
	 		if(fm.bank_code.value == ""){ alert("?????? ????????????."); return; }			
			if(fm.deposit_no.value == ""){ alert("?????????? ????????????."); return; }		
 		} 	
 		
 		
 		if (fm.cls_st.value  == '8' ) {	
	 		if( toInt(parseDigit(fm.opt_ip_amt1.value)) != 0 ){ // ????????
			
				var deposit_no = fm.opt_deposit_no1.options[fm.opt_deposit_no1.selectedIndex].value;		
				
				if(deposit_no.indexOf(":") == -1){
					fm.opt_deposit_no1_2.value = deposit_no;
				}else{
					var deposit_split = deposit_no.split(":");
					fm.opt_deposit_no1_2.value = deposit_split[0];	
		 		}
		 		
		 	//	if(fm.opt_bank_code1.value == ""){ alert("?????? ????????????."); return; }			
			//	if(fm.opt_deposit_no1.value == ""){ alert("?????????? ????????????."); return; }		
	 		} 			
	 		
	 		
	 		if( toInt(parseDigit(fm.opt_ip_amt2.value)) != 0 ){ //????????
			
				var deposit_no = fm.opt_deposit_no2.options[fm.opt_deposit_no2.selectedIndex].value;		
				
				if(deposit_no.indexOf(":") == -1){
					fm.opt_deposit_no2_2.value = deposit_no;
				}else{
					var deposit_split = deposit_no.split(":");
					fm.opt_deposit_no2_2.value = deposit_split[0];	
		 		}
		 		
		 	//	if(fm.opt_bank_code2.value == ""){ alert("?????? ????????????."); return; }			
			//	if(fm.opt_deposit_no2.value == ""){ alert("?????????? ????????????."); return; }		
	 		} 					
		}		
			
		//??????????(????)???? ???????????? ?????????? ??
		if (fm.cls_st.value  == '7' || fm.cls_st.value  == '10' ) {					
			if( fm.tae_prv_dlv_yn.value  == 'Y'  ){ 		
				if( toInt(parseDigit(fm.tae_cnt.value)) < 1  ){ 						
					alert("?????????? ???????? ??????????.!!");
					return;					
				}	
				//???????? ?????? ?????????? ????
			//	if ( toInt(fm.tae_e_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //???????? 
			//		alert("?????????? ???????? ??????????.!!");
			//		return;		
			//	}
				
				//??????????????
			}	
		}		
		
		/*	
		//?????????????? ?? ???????????? ?????? ????	
		if ( toInt(parseDigit(fm.tax_r_supply[0].value)) !=  toInt(parseDigit(fm.tax_rr_supply[0].value)) ) {	
			alert("?????????????? ??????(?????? ????)?? ???? ????????. ??????????.!!");
			return;		
		}
		
		if ( toInt(parseDigit(fm.tax_r_value[0].value)) !=  toInt(parseDigit(fm.tax_rr_value[0].value)) ) {	
			alert("?????????????? ??????(?????? ????)?? ???? ????????. ??????????.!!");
			return;		
		}
		
		if ( toInt(parseDigit(fm.tax_r_supply[1].value)) !=  toInt(parseDigit(fm.tax_rr_supply[1].value)) ) {	
			alert("?????????? ??????(?????? ????)?? ???? ????????. ??????????.!!");
			return;		
		}
		
		if ( toInt(parseDigit(fm.tax_r_value[1].value)) !=  toInt(parseDigit(fm.tax_rr_value[1].value)) ) {	
			alert("?????????? ??????(?????? ????)?? ???? ????????. ??????????.!!");
			return;		
		}
		*/		
		
		if ( toInt(parseDigit(fm.tax_r_value[0].value)) !=  toInt(parseDigit(fm.rifee_amt_2_v.value)) ) {	
			alert("?????????????? ???? ???????? ??????????.!!");
			return;	
		}
		
		if ( toInt(parseDigit(fm.tax_r_value[1].value)) !=  toInt(parseDigit(fm.rfee_amt_2_v.value)) ) {	
			alert("?????????? ???? ???????? ??????????.!!");
			return;	
		}
			
		//?????? ?? ???????? ???????? ?????? ?????? ???? ???? ???? check
		if( fm.dly_saction_id.value != '' ) {
			if (fm.cls_st.value  == '7' || fm.cls_st.value  == '10' ) {	
			} else {	
			//	if (  toInt(parseDigit(fm.dly_amt.value))>0 && fm.dly_amt.value == fm.dly_amt_1.value ) {
			//		alert("?????? ???? ??????????. ??????????????.!!");
			//		return;
			//	}
			}						
		}
		
		if( fm.dft_saction_id.value == '000005' ) {
		        // ????????????????, ???????????????? ?????? ????.
		        	if (fm.cls_st.value  == '7' || fm.cls_st.value  == '10' ) {		
		        	} else {	
		        	//	if (  toInt(parseDigit(fm.dft_amt.value))>0 && fm.dft_amt.value == fm.dft_amt_1.value   ) {	
			 //  		alert("?????????????? ???? ??????????. ??????????????.!!");
			//		return;
			//	}	
				
				if ( fm.match.value == 'Y') {
				} else {
					if( fm.dft_cost_id.value == '' ) {
						alert("???????? ???????????? ?????????? ??????.!!");
						return;
					}	
				}	
			}						
		}
		
	 //?????? ???? ????????  - ?????????? ???? ???? 
	 if ( fm.tax_reg_gu[1].checked == true ) {
	     
	      if ( toInt(parseDigit(fm.tax_r_supply[0].value)) < 0 || toInt(parseDigit(fm.tax_r_supply[1].value)) < 0 || toInt(parseDigit(fm.tax_r_supply[1].value)) <0 ) {
	         	 	alert("???????? ?????? ??????????????(1??)?? ?? ?? ????????..!!");
					return;	 
	      }
	       
	 }
		
		//???????? ?????? ???? ???? ???????? ???? check
<%		for (int i = 0; i <  3 ; i++) { %>		
	
				if ( fm.tax_r_chk<%=i%>.checked == true   ) {
					alert(" <%=i+1%>?? ?????? ?????? ?????????? ?????? ??????????????.!!!");
					return;
				}					
								
<%		 } %>


		//???????????? ???????? ???? check
<%		for (int i = 0; i <  9 ; i++) { %>		
	
			if ( fm.tax_r_chk<%=i%>.checked == true  &&    fm.tax_r_g[<%=i%>].value == ''  ) {
				alert(" <%=i+1%>?? ?????? ?????? ????????. ??????????!!!");
				return;
			}					
		
<%		 } %>			
		
		//?????????? ???????????? - ?????? ?????????? ???? 
<%		if ( base.getCar_st().equals("5") ) {  %>
				 if ( fm.tax_r_chk3.checked == true  ||   toInt(parseDigit(fm.tax_rr_supply[3].value)) > 0     ) {
				 	alert("???????? ?????????????? ?????? ?? ?????????? ??????..!!");
					return;	 
				 }			
<%     } %>
		
		//??????????????????
<% if ( vt_size8 > 0) {%>   
		 if ( fm.tax_r_chk3.checked == true  ||   toInt(parseDigit(fm.tax_rr_supply[3].value)) > 0     ) {
		//		 	alert("???????????????? ?????? ???????????? ???????????????? ?????????? ??????..!!");
	//				return;	 
		 }				
<% } %>		
		
		//?????????? ???? ??????????  ?????? ?????? ???????????? ???? ??????. - ???????????? 
		if (fm.cls_st.value  == '8' ) {	
		//??????????????????
			<% if ( vt_size8 > 0) {%>  
			<% } else {%>
					 if ( fm.tax_r_chk3.checked == true  ||   toInt(parseDigit(fm.tax_rr_supply[3].value)) > 0     ) {
					 	alert("???????? ?????????????? ?????? ?? ?????????? ??????..!!");
						return;	 
			 		}	
			<% } %> 					
		}
		
		if  ( fm.jung_st_chk.value != "" ) {
			 if ( toInt(parseDigit(fm.c_amt.value))  > 0 ) {
				if ( fm.cls_st.value == '1' || fm.cls_st.value == '2'  ) {   //???????? ???? ?????????? ????
					//?????????????? ???? 		
					if  (  fm.jung_st[1].checked == true)  {  //???????? ??????
						 if ( ( toInt(parseDigit(fm.h5_amt.value)) -  toInt(parseDigit(fm.h7_amt.value)) ) * (-1)  !=   toInt(parseDigit(fm.fdft_amt2.value))  ) {	
					 		alert("?????????????? ?????????????? ????????. ??????????????.!!");
							return; 	
					 	}
					 	 if (  toInt(parseDigit(fm.fdft_amt1_2.value))  > 0   ) {	
					 		alert("?????????? ?????????????? ?? ?? ????????. ??????????????.!!");
							return; 	
					 	}
					 					 
					} else {
					 	if ( toInt(parseDigit(fm.h3_amt.value)) *(-1)  !=  toInt(parseDigit(fm.fdft_amt2.value))  ) {
					 		alert("?????????????? ?????????????? ????????. ??????????????.!!");
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
					      if  (  fm.jung_st[0].checked == true)  {  //???????? ??????
							alert("?????????? ??????????.!!");
							return;
					      }
				         }	
				}	
			}	
		}		
			
		       //?????? ?????? ???? ????????check
 	       if  ( fm.pay_st.value == "2" ) {
		<%if ( attach4_vt_size < 1) {%> 		
				alert("?????????? ???? ?????? ?????????? ??????..!!");
				return;
		  <%   } %>		
		}					
			
				
						
		if (chk == '2' ) {
			if(confirm('?????????????????????')){	
				fm.action='lc_cls_u1_a.jsp';	
	
				fm.target='d_content';
				fm.submit();
			}		
		} else {			
			if(confirm('?????????????????????')){	
				fm.action='lc_cls_u1_a.jsp';	
	
				fm.target='d_content';
				fm.submit();
			}		
		}
	}
	
	//?????????? ????
	function cls_display(){
		var fm = document.form1;
	
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //???????? ?????? ??????????
			tr_opt.style.display 		= '';  //????????	
			tr_ret.style.display		= 'none';	//????????		
			tr_gur.style.display		= 'none';	//????????	
			tr_sale.style.display		= '';	//????????
			tr_ex_ip.style.display	= 'none';	//????????
		}else{
			tr_opt.style.display 		= 'none';	//????????
			tr_ret.style.display		= '';	//????????	
			tr_gur.style.display		= '';	//????????
			tr_sale.style.display		= 'none';	//????????
			tr_ex_ip.style.display	= '';	//????????
			
			
		}
				
		set_init();
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
		fm.fdft_amt3.value='0';
	   		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){
			fm.opt_per.value=fm.mopt_per.value;
			fm.opt_amt.value=fm.mopt_amt.value;
			set_sui_amt();
		}
		
	}	

	//?????????? ???? - ????????????
	function cls_display2(){
		var fm = document.form1;
			
		if(fm.reco_st[1].checked == true){  //?????? ??????
			td_ret1.style.display 	= 'none';
			td_ret2.style.display 	= '';
		}else{
			td_ret1.style.display 	= '';
			td_ret2.style.display 	= 'none';
		}
	}	
	
	//?????????? ????
	function cls_display3(){
		var fm = document.form1;
	
		if(fm.div_st.options[fm.div_st.selectedIndex].value == '2'){
			td_div.style.display 	= '';
		}else{
			td_div.style.display 	= 'none';
		}
	}	
	
	//?????????? ???? - ??????????
	function cls_display4(){
		var fm = document.form1;
	
		if(fm.jung_st[1].checked == true){  //???????? ??????
			fm.h1_amt.value='0';  //????????
			fm.h2_amt.value='0';  //????????
			fm.h3_amt.value='0';  //????????
			fm.h4_amt.value='0';  //????
			fm.h5_amt.value='0';  //????????
			fm.h6_amt.value='0';  //????
			fm.h7_amt.value='0';  //????????
			
						
			//?????????????? ???? ???????? ???? ????  - ???????? ?????? ????. 
		//	fm.h4_amt.value = fm.c_amt.value; 	
			fm.h4_amt.value = parseDecimal( toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.rifee_amt_2_v.value)) -   - toInt(parseDigit(fm.rfee_amt_2_v.value)));		
			fm.h5_amt.value = fm.h4_amt.value; 	
			
	//		fm.h6_amt.value =fm.fdft_amt1_1.value; 
			fm.h6_amt.value =fm.fdft_amt1_3.value; 
			fm.h7_amt.value =fm.h6_amt.value; 
		//	fm.h3_amt.value =parseDecimal( toInt(parseDigit(fm.h1_amt.value)) - toInt(parseDigit(fm.h2_amt.value)) );					
						
		}else{
			fm.h1_amt.value='0';  //????????
			fm.h2_amt.value='0';  //????????
			fm.h3_amt.value='0';  //????????
			fm.h4_amt.value='0';  //????
			fm.h5_amt.value='0';  //????????
			fm.h6_amt.value='0';  //????
			fm.h7_amt.value='0';  //????????			
			
			fm.h1_amt.value = fm.c_amt.value; 	
			fm.h2_amt.value =fm.fdft_amt1_1.value; 
			fm.h3_amt.value =parseDecimal( toInt(parseDigit(fm.h1_amt.value)) - toInt(parseDigit(fm.h2_amt.value)) );		
		}
	}	
	
	//?????????? ????
	function cancel_display(){
	   //???????????? 0???? ???? ????: ?????? ???? ???? ?????? ?????????? ?? ????.
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[1].selected = true;
			alert('?????????????????? '+fm.fdft_amt2.value+'?????? ???????? ??????. \n\n???? ???? ???????? ?????????? ??????????.');
			return;			
		}		
	}	
	
	//????????????(????????)
	function set_sui_c_amt(){
	
		var fm = document.form1;
							
		if (fm.cls_st.value  == '8' ) {
		  fm.dft_amt.value = '0'; //??????????????
		  fm.dft_amt_1.value = '0'; //??????????????????
		  fm.tax_r_supply[3].value 	= '0';
		  fm.tax_r_value[3].value 	= '0';	
		 						
		  if(fm.sui_st[0].checked == true){ 		//??????????	
		  		fm.sui_d1_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.05 );  //??????
				fm.sui_d2_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.06 * 0.2 );  //???????? (default:25%) -> 20%????
				fm.sui_d3_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.02 );  //?????? 
				fm.sui_d4_amt.value		= '3,000';  //?????? 
				fm.sui_d5_amt.value		= '1,000';  //?????? 
				fm.sui_d6_amt.value		= '11,000';  //????????
				fm.sui_d7_amt.value		= '10,000';  //????????????
				fm.sui_d8_amt.value		= '50,000';  //??????????
								
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
		
		set_cls_s_amt();
	
	}	
	
	//????????????(????????)
	function set_sui_amt(){
	
		var fm = document.form1;
				
		fm.sui_d_amt.value 		= parseDecimal( hun_th_rnd(toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value))));
					
		set_cls_s_amt();	
	}	
						
	
	//???????? ????
	function set_cls_s_amt(){
		var fm = document.form1;	
		
						
		fm.d_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.over_amt.value))   + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))   + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)));	 //????????	
			
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		 
		 	
		if (fm.cls_st.value  == '8' ) {	//????????
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));					
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));						
		}  
		
		if (fm.cls_st.value  == '8' ) {	//????????
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
				
	}	
	
	function set_cls_amt4_vat(){
		var fm = document.form1;
		
		fm.dfee_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) * 0.1 );
		
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
			fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );
		}
			
//		fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );
				
	    set_cls_amt4();	
	    
	    			   
	}
		
	//???????? - ???????? - ???????????? ???????? ????.
	function set_cls_amt4(){
		var fm = document.form1;
		
		//???????????? ?????????? ???? ?? ????
		if(toInt(parseDigit(fm.fine_amt_1.value)) <  toInt(parseDigit(fm.fine_amt_2.value))   ){ //
			alert("?????? ?????????????? ???????? ????????.!!");
			fm.fine_amt_2.value = "0";
			return;
		}			
		
		//???????????? ?????????? ???? ?? ????
		if(toInt(parseDigit(fm.car_ja_amt_1.value)) < toInt(parseDigit(fm.car_ja_amt_2.value))   ){ //
			alert("?????? ?????????????? ???????? ????????.!!");
			fm.car_ja_amt_2.value = "0";
			return;
		}			
		
		//???????????? ?????????? ???? ?? ???? -  ???????? ???? ?? ????
		if(Math.abs(toInt(parseDigit(fm.dfee_amt_1.value))) <   toInt(parseDigit(fm.dfee_amt_2.value))   ){ //
			alert("?????? ?????????????? ???????? ????????.!!");
			fm.dfee_amt_2.value = "0";		
			return;
		}			
		
		//???????????? ?????????? ???? ?? ????
		if(toInt(parseDigit(fm.dly_amt_1.value)) <  toInt(parseDigit(fm.dly_amt_2.value))  ){ //
			alert("???????? ?????????????? ???????? ????????.!!");
			fm.dly_amt_2.value = "0";
			return;
		}			
			
		
		//???????????? ?????????? ???? ?? ????
		if(toInt(parseDigit(fm.dft_amt_1.value)) <  toInt(parseDigit(fm.dft_amt_2.value)) ){ //
			alert("?????? ?????????????? ???????? ????????.!!");
			fm.dft_amt_2.value = "0";
			return;
		}			
				
		//???????????? ?????????? ???? ?? ????
		if(toInt(parseDigit(fm.etc_amt_1.value)) <  toInt(parseDigit(fm.etc_amt_2.value))  ){ //
			alert("???????????????? ?????????????? ???????? ????????.!!");
			fm.etc_amt_2.value = "0";
			return;
		}			
		//???????????? ?????????? ???? ?? ????
		if(toInt(parseDigit(fm.etc2_amt_1.value)) < toInt(parseDigit(fm.etc2_amt_2.value)) ){ //
			alert("???????????????? ?????????????? ???????? ????????.!!");
			fm.etc2_amt_2.value = "0";
			return;
		}
			
		<% if  ( fuel_cnt > 0 ) {%>
		 <% if (  return_remark.equals("??????")  ) {%>	
		       	if(toInt(parseDigit(fm.etc3_amt_1.value)) !=  toInt(parseDigit(fm.etc3_amt_2.value)) ){ //
		        		alert("???????????????????? ??????????");
		             return;
		          }
	     <% }else if ( return_remark.equals("????") &&  cls.getCls_st().equals("????????")  ) {%>	      
	           	if(toInt(parseDigit(fm.etc3_amt_1.value)) !=  toInt(parseDigit(fm.etc3_amt_2.value)) ){ //
	        		alert("???? ???????? ??????  ??????????");
	             return;
	      <% } %>  
				  
		<% } else { %>	
	
			//???????????? ?????????? ???? ?? ????
			if(toInt(parseDigit(fm.etc3_amt_1.value)) <    toInt(parseDigit(fm.etc3_amt_2.value)) ){ //
		
				alert("???????????? ?????????????? ???????? ????????.!!");
				fm.etc3_amt_2.value = "0";
				return;
			}			
		<% } %>	
		
		//???????????? ?????????? ???? ?? ????
		if(toInt(parseDigit(fm.etc4_amt_1.value)) <  toInt(parseDigit(fm.etc4_amt_2.value))   ){ //
			alert("?????????????? ?????????????? ???????? ????????.!!");
			fm.etc4_amt_2.value = "0";
			return;
		}			
		
	 
			//???????????? ?????????? ???? ?? ????
		if(toInt(parseDigit(fm.over_amt_1.value)) <   toInt(parseDigit(fm.over_amt_2.value))   ){ //
			alert("?????????????????? ?????????????? ???????? ????????.!!");
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
													
		fm.fdft_amt1_2.value 	= parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) + toInt(parseDigit(fm.dly_amt_2.value))+ toInt(parseDigit(fm.dft_amt_2.value)) + toInt(parseDigit(fm.car_ja_amt_2.value)) + toInt(parseDigit(fm.fine_amt_2.value)) + toInt(parseDigit(fm.etc_amt_2.value)) + toInt(parseDigit(fm.etc2_amt_2.value)) + toInt(parseDigit(fm.etc3_amt_2.value)) + toInt(parseDigit(fm.etc4_amt_2.value))  + toInt(parseDigit(fm.over_amt_2.value)) + toInt(parseDigit(fm.no_v_amt_2.value)) );	 //????????	
		fm.fdft_amt1_3.value = parseDecimal( toInt(parseDigit(fm.fdft_amt1_1.value))  -    toInt(parseDigit(fm.fdft_amt1_2.value)) ) ;				
		
		if( ( toInt(parseDigit(fm.c_amt.value))  + toInt(parseDigit(fm.ex_ip_amt.value)) +  toInt(parseDigit(fm.opt_ip_amt1.value)) +  toInt(parseDigit(fm.opt_ip_amt2.value)) -  toInt(parseDigit(fm.fdft_amt1_2.value)) )  < -1 ) {
			alert("??????????????(??????????????????) ?????????? ?????? ?? ????????.\n ?????????? ????????????.!!");
			return;
		}
		
		fm.fdft_j_amt.value = parseDecimal( toInt(parseDigit(fm.c_amt.value))  +  toInt(parseDigit(fm.ex_ip_amt.value))   - toInt(parseDigit(fm.fdft_amt1_2.value)) );		
                   
                   //?????????????? ???? ???? 
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
		          
			  
	   
		if (fm.cls_st.value  == '8' ) {	//????????		    
		     if  ( toInt(parseDigit(fm.fdft_amt2.value))  >=  0 ) {  //????????????			     
				fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));					
				fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			 } else {
			 	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_2.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));					
				fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_2.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
				 
			 }				
		}  
		
		if (fm.cls_st.value  == '8' ) {	//????????
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_2.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_2.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_2.value)) );		
						   
	}
	
	//???????? ????
	function set_maeip_amt(obj){
		 		
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		var ext_amt = 0;
		
	   if(obj == fm.m_dae_amt){ //????????		
			fm.t_dae_amt.value 	= parseDecimal( toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.opt_ip_amt1.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)));	
		//	ext_amt = toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.opt_ip_amt1.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value)) 	;
			
	   } else if(obj == fm.opt_ip_amt1){ //????1		
			fm.t_dae_amt.value 	= parseDecimal( toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)));	
		//	ext_amt = toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value)) 	;
			
			
		}else if(obj == fm.opt_ip_amt2){ //????2
			fm.t_dae_amt.value 	= parseDecimal( toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt1.value)));	
		//	ext_amt	=  toInt(parseDigit(obj.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt1.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value)) 	;	
	
		}	
				
	 	if ( toInt(parseDigit(fm.fdft_amt2.value)) <= 0 ) { //?????????? ????????????
	 		if ( toInt(parseDigit(fm.m_dae_amt.value)) == 0 ) { //?????????? ?????? 
	 			fm.ext_amt.value = parseDecimal( (toInt(parseDigit(fm.fdft_amt2.value)) * (-1))  +  toInt(parseDigit(fm.opt_ip_amt1.value)) + toInt(parseDigit(fm.m_dae_amt.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value))) ;
	 		} else {
	 			fm.ext_amt.value = parseDecimal(  toInt(parseDigit(fm.m_dae_amt.value)) +  toInt(parseDigit(fm.opt_ip_amt1.value))  + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value))) ;
	 		}	 	
	  	 } else {
	  		fm.ext_amt.value = parseDecimal( toInt(parseDigit(fm.opt_ip_amt1.value)) + toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.fdft_amt2.value)) -  toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.sui_d_amt.value))) ; 	  		
	  	 }
	 
	 	 
	 	 if (toInt(parseDigit(fm.ext_amt.value))  >=0  ) { //?????????? ?????? 
	 		fm.est_amt.value =  parseDecimal( toInt(parseDigit(fm.ext_amt.value)) * (-1) ); 
	 	 }
											   
	}
	
	
	//????????????????
	function set_gi_amt(){
		var fm = document.form1;
		
	//	fm.gi_j_amt.value 		= parseDecimal( toInt(parseDigit(fm.gi_amt.value)) - toInt(parseDigit(fm.gi_c_amt.value)));
		
		if ( toInt(parseDigit(fm.gi_c_amt.value))  > 0  ) {
			if ( toInt(parseDigit(fm.fdft_amt2.value))  > 0  ) {
				fm.gi_j_amt.value 		= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.gi_c_amt.value)));
			}
		}
		if ( toInt(parseDigit(fm.gi_j_amt.value)) < 0  ) {
				fm.gi_j_amt.value  = "0";
		}
			
		
	}		
	
	
	//?????????? check ???? ?????? - ???????????? ?????? ???? ??????(??????, ???????? ???? (???? ????????)) - ?????????? ???????? ?????????????? 
	function set_vat_amt(obj){
		var fm = document.form1;
		
		if(obj == fm.tax_chk0){ // ??????
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
	
		} else if(obj == fm.tax_chk1){ // ????????
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
		} else if(obj == fm.tax_chk2){ // ????????
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
		} else if(obj == fm.tax_chk3){ // ??????????????
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
		} else if(obj == fm.tax_chk4){ // ???????? ?????? 
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
			alert('?????????? ???? ???? ????????. ?????????? ?????????? ?????????? ??????!!!..');
			return;	
		   }
		}
			
		if(confirm('?????????????????')){	
			fm.action='lc_cls_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function clsConSanction(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('?????????? ????????????'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('?????????? ????????????'); 		fm.cls_dt.focus(); 		return;	}
					
		if(confirm('?????????????????')){	
			fm.action='lc_cls_cont_sanction.jsp';	
			fm.target='i_no';
		//	fm.target='d_content';
			fm.submit();
		}		
	}
	
	
	
	//?????????? ???????? ????????
	function change_bank(obj){
		var fm = document.form1;
		var bank_code = "";
		if(obj == fm.bank_code){ // ??????????
			//????
			bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;	
			fm.bank_code2.value = bank_code.substring(0,3);
			fm.bank_name.value = bank_code.substring(3);
		} else	if(obj == fm.opt_bank_code1){ // ???????? 1
			bank_code = fm.opt_bank_code1.options[fm.opt_bank_code1.selectedIndex].value;	
			fm.opt_bank_code1_2.value = bank_code.substring(0,3);
			fm.opt_bank_name1.value = bank_code.substring(3);		
			
		} else	if(obj == fm.opt_bank_code2){ // ???????? 2
			bank_code = fm.opt_bank_code2.options[fm.opt_bank_code2.selectedIndex].value;	
			fm.opt_bank_code2_2.value = bank_code.substring(0,3);
			fm.opt_bank_name2.value = bank_code.substring(3);			
		} 		
	
		drop_deposit(obj);		

		if(bank_code == ''){
			if(obj == fm.bank_code){ // ??????????
				fm.bank_code.options[0] = new Option('????', '');
				return;
			} else 	if(obj == fm.opt_bank_code1){ // ???????? 1
				fm.opt_bank_code1.options[0] = new Option('????', '');
				return;			
			} else 	if(obj == fm.opt_bank_code2){ // ???????? 2
				fm.opt_bank_code1.options[0] = new Option('????', '');
				return;			
			}			
		}else{
			fm.target='i_no';
			if(obj == fm.bank_code){ // ??????????
				fm.action='/fms2/con_fee/get_deposit_nodisplay2.jsp?g=1&bank_code='+bank_code.substring(0,3);
			} else 	if(obj == fm.opt_bank_code1){ // ???????? 1
				fm.action='/fms2/con_fee/get_deposit_nodisplay2.jsp?g=2&bank_code='+bank_code.substring(0,3);
			} else 	if(obj == fm.opt_bank_code2){ // ???????? 2
				fm.action='/fms2/con_fee/get_deposit_nodisplay2.jsp?g=3&bank_code='+bank_code.substring(0,3);
			}
			fm.submit();
		}
	}	
	
	function drop_deposit(obj){
		var fm = document.form1;
		var deposit_len = 0;
		if(obj == fm.bank_code){ // ??????????
			deposit_len = fm.deposit_no.length;
			for(var i = 0 ; i < deposit_len ; i++){
				fm.deposit_no.options[deposit_len-(i+1)] = null;
			}
		} else	if(obj == fm.opt_bank_code1){ // ???????? 1
		
			deposit_len = fm.opt_deposit_no1.length;
			for(var i = 0 ; i < deposit_len ; i++){
				fm.opt_deposit_no1.options[deposit_len-(i+1)] = null;
			}		
		} else	if(obj == fm.opt_bank_code2){ // ???????? 2
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
	
			
	//????????
	function ven_search(idx){
		var fm = document.form1;
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx, "VENDOR_LIST", "left=50, top=50, width=500, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function set_cls_tax_value(v_type){
		var fm = document.form1;
		
		if(v_type == '1'){ // ??????????
			fm.tax_rr_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) * 0.1 );	
		} else if(v_type == '2' ){ // ??????????
			fm.tax_rr_value[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[4].value)) * 0.1 );		
		} else if(v_type == '3'){ // ????????
			fm.tax_rr_value[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[5].value)) * 0.1 );	
		} else if(v_type == '4'){ // ????????
			fm.tax_rr_value[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[6].value)) * 0.1 );	
		} else if(v_type == '5'){ // ??????????
			fm.tax_rr_value[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[7].value)) * 0.1 );	
		} else if(v_type == '6'){ //  ??????????????
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
		var fm = document.form1;
				
		if (st == 'cls_jung') {	
			window.open("/fms2/cls_cont/updateClsJung.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=50, width=1050, height=850, resizable=yes, scrollbars=yes, status=yes");
		} else if (st == 'cls_etc') {	
			window.open("/fms2/cls_cont/updateClsEtc.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1050, height=550, resizable=yes, scrollbars=yes, status=yes");			
		} else if (st == 'cls_asset') {  //????????	
			window.open("/fms2/cls_cont/updateClsAsset.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1050, height=450, resizable=yes, scrollbars=yes, status=yes");	
		} else if (st == 'cls_reco') {  //??????,?????? ????	
			window.open("/fms2/cls_cont/updateCarReco.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1050, height=450, resizable=yes, scrollbars=yes, status=yes");					
	   } else if (st == 'tr_p_maeip') {  //???????? ?????? ?????? ???? ????	
			window.open("/fms2/cls_cont/updateTrMaeip.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1050, height=450, resizable=yes, scrollbars=yes, status=yes");					
		
		} else {
			window.open("/fms2/cls_cont/updateTrGet.jsp<%=valus%>", "CHANGE_ITEM", "left=50, top=100, width=1050, height=450, resizable=yes, scrollbars=yes, status=yes");
		}		
	}
	
	
		//????????
	function scan_reg(gubun){
		window.open("reg_scan.jsp?gubun="+gubun+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//????????
	function scan_del(gubun){
		var theForm = document.form1;
		if(!confirm('?????????????????')){		return;	}
		theForm.target = "i_no"
		theForm.action = "del_scan_a.jsp?gubun="+gubun;
		theForm.submit();
	}
	
		//?????????? ????
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
	
	//????????  ????
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
	
	//???????? ??????
	function view_scan_res2(c_id, m_id, l_cd){
		window.open("/fms2/lc_rent/lc_im_doc_print.jsp?c_id="+c_id+"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&mode=fine_doc", "VIEW_SCAN_RES2", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}
	
	
	//?????? ????
	function doc_id_cng(doc_no, doc_bit, doc_user){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 300;		
		window.open("/fms2/doc_settle/doc_user_cng.jsp<%=valus%>&doc_no="+doc_no+"&doc_bit="+doc_bit+"&doc_user="+doc_user, "CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}	
	
	
		//???????????? ???? 
	function reg_dt()
	{
		var fm = document.form1;
		
		if(fm.conj_dt.value == ""){ alert("???????????? ??????????!!."); return;}
									
		if(confirm('?????????? ?????????????????'))
		{		
			fm.target = 'i_no';
			fm.action = "/acar/off_ls_after/off_ls_after_dt_upd_a.jsp?sui_etc=Y" ;
			fm.submit();
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

<!-- ???????? 1 -->
<input type='hidden' name='opt_bank_code1_2' value='<%=cls.getOpt_ip_bank1()%>'>
<input type='hidden' name='opt_deposit_no1_2' value='<%=cls.getOpt_ip_bank_no1()%>'>
<input type='hidden' name='opt_bank_name1' value=''>

<!-- ???????? 2 -->
<input type='hidden' name='opt_bank_code2_2' value='<%=cls.getOpt_ip_bank2()%>'>
<input type='hidden' name='opt_deposit_no2_2' value='<%=cls.getOpt_ip_bank_no2()%>'>
<input type='hidden' name='opt_bank_name2' value=''>

<input type='hidden' name="tfee_s_amt" 		value="<%=tax2.get("FEE_S_AMT")%>">  
<input type='hidden' name="tfee_v_amt" 		value="<%=tax2.get("FEE_V_AMT")%>">
<input type='hidden' name="tuse_s_dt" 		value="<%=tax2.get("USE_S_DT")%>">  
<input type='hidden' name="tuse_e_dt" 		value="<%=tax2.get("USE_E_DT")%>">    
    
<input type='hidden' name="re_day" 		value="<%=re_day%>">  
<input type='hidden' name="term_yn" 		value="<%=term_yn%>">  

<input type='hidden' name='t_day' value='<%=tax1.get("T_DAY")%>'>
<input type='hidden' name='t_mon' value='<%=tax1.get("T_MON")%>'> 
 
<!--?????? ?????? ?????? ???? ?????????? ???? --> 
<input type='hidden' name='u_day' value='<%=ht_t.get("U_DAY")%>'> 
<input type='hidden' name='u_mon' value='<%=ht_t.get("U_MON")%>'> 

<input type='hidden' name='fee_tm' value='<%=fee_tm%>'> 

<!--??????????(????)?????? ???????????????? -->
<input type='hidden' name='tae_prv_dlv_yn' value='<%=tae_prv_dlv_yn%>'> 
<input type='hidden' name='tae_cnt' value='<%=tae_cnt%>'> 
<input type='hidden' name='tae_e_dt' value='<%=tae_e_dt%>'> 

<!--???????????? ???????? ?? ?????????? ????  (?????? (????????)-->                      
<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'>
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_V_AMT")))%>'>

<input type='hidden' name="lfee_s_amt" 		value="<%=tax3.get("FEE_S_AMT")%>">  
<input type='hidden' name="lfee_v_amt" 		value="<%=tax3.get("FEE_V_AMT")%>">

  <!--???????? ???? ???? -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='over_run_day' value='<%=car1.getOver_run_day()%>'>

<input type='hidden' name='sh_km' value='<%=car1.getSh_km()%>'>

<input type='hidden' name='jung_st_chk' value='<%=cct.getJung_st()%>' >
<input type='hidden' name="old_opt_amt" 		value="<%=clsa.getOld_opt_amt() %>">

<!-- ?????????????? ?????? ?????? ???? ?????? ?????????? ???? -->
<input type='hidden' name='ts_r_fee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)m_tax1.get("TS_R_FEE_AMT")))%>'>
<input type='hidden' name='tv_r_fee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)m_tax1.get("TV_R_FEE_AMT")))%>'>

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	 <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>???????? > ???????? ><span class=style5>????????????</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
    <tr>
	    <td align='right'> &nbsp;<a href='javascript:cls_print();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_print_jss.gif align=absmiddle border=0></a>
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
            <td class=title width=13%>????????</td>
            <td width=22%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;<a href="javascript:view_cng_etc('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='????????'><img src=/acar/images/center/button_tish.gif align=absmiddle border=0></a>
              &nbsp;<a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='????????'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
            </td>
            <td class=title width=10%>????????</td>
            <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
            <td class=title width=10%>????????</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
          </tr>
          <tr> 
            <td class=title>??????????</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
            <td class=title>??????????</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
            <td class=title>??????????</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
          </tr>
          <tr>
            <td class=title>????????</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
            <td class=title>????????</td>
            <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>????<%}else if(rent_st.equals("3")){%>????<%}else if(rent_st.equals("4")){%>????<%}%></td>
            <td class=title>????????</td>
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>??????<%}else if(bus_st.equals("2")){%>????????<%}else if(bus_st.equals("3")){%>????????<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>????????<%}else if(bus_st.equals("6")){%>????????<%}else if(bus_st.equals("7")){%>????????<%}else if(bus_st.equals("8")){%>??????<%}%></td>
          </tr>
          <tr> 
            <td class=title>????????</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>??????<%}else if(car_gu.equals("1")){%>????<%}else if(car_gu.equals("2")){%>??????<%}%></td>
            <td class=title>????????</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>????<%}else if(car_st.equals("2")){%>????<%}else if(car_st.equals("3")){%>????<%}else if(car_st.equals("5")){%>????????<%}%></td>
            <td class=title>????????</td>
            <td>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>??????<%}else if(rent_way.equals("3")){%>??????<%}%></td>
          </tr>
          <tr>
            <td class=title>????</td>
            <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="??????????"><%=client.getFirm_nm()%></a></td>
            <td class=title>??????</td>
            <td>&nbsp;<%=client.getClient_nm()%></td>
            <td class=title>????/????</td>
            <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="??????????"><%=site.getR_site()%></a></td>
          </tr>
          <tr>
            <td class=title>????????</td>
            <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="??????????"><%=cr_bean.getCar_no()%></a></td>
            <td class=title width=10%>????</td>
            <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
			<font color="#999999">(????????:<%=cm_bean.getJg_code()%>)</font>
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
            <td style="font-size : 9pt;" width="3%" class=title rowspan="2">????</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">????????</td>
            <td style="font-size : 9pt;" width="6%" class=title rowspan="2">????????</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">??????????</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">??????????</td>
            <td style="font-size : 9pt;" width="7%" class=title rowspan="2">????????</td>
            <td style="font-size : 9pt;" width="9%" class=title rowspan="2">????????</td>
            <td style="font-size : 9pt;" class=title colspan="2">??????</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">??????</td>
            <td style="font-size : 9pt;" class=title colspan="2">??????????</td>
            <td style="font-size : 9pt;" class=title colspan="2">????????</td>
          </tr>
          <tr>
            <td style="font-size : 9pt;" width="10%" class=title>????</td>
            <td style="font-size : 9pt;" width="3%" class=title>????</td>
            <td style="font-size : 9pt;" width="10%" class=title>????</td>
            <td style="font-size : 9pt;" width="3%" class=title>????</td>
            <td style="font-size : 9pt;" width="10%" class=title>????</td>
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
            <td style="font-size : 9pt;" align="center"><%=fees.getCon_mon()%>????</td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>??&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>??&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>????<%}else if(fees.getGrt_suc_yn().equals("1")){%>????<%}else{%>-<%}%></td>			
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>??&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>??&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>????<%}else if(fees.getIfee_suc_yn().equals("1")){%>????<%}else{%>-<%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>??&nbsp;</td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span> <a href="javascript:view_scan_res2('<%=base.getCar_mng_id()%>','<%=base.getRent_mng_id()%>','<%=base.getRent_l_cd()%>')" onMouseOver="window.status=''; return true"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="?????????? ????"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">????</td>
                    <td class=title width="20%">????</td>			
                    <td class=title width="37%">????????</td>
                    <td class=title width="15%">??????</td>
                    <td class=title width="15%">??????</td>                    
                  </tr>
        		  <%	for(int i = 0 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=im_ht.get("ADD_TM")%>????</td>
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
 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????&nbsp;
 		 <a href="javascript:update('cls_etc')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a></span></td>
    </tr> 	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='13%' class='title'>????????</td>
            <td width="13%">&nbsp; 
			  <select name="cls_st" onChange='javascript:cls_display()' disabled >
			    <option value="1" <%if(cls.getCls_st().equals("????????")){%>selected<%}%>>????????</option>
                <option value="2" <%if(cls.getCls_st().equals("????????")){%>selected<%}%>>????????</option>
                <option value="7" <%if(cls.getCls_st().equals("??????????(????)")){%>selected<%}%>>??????????(????)</option>
                <option value="8" <%if(cls.getCls_st().equals("????????")){%>selected<%}%>>????????</option>
                <option value="10" <%if(cls.getCls_st().equals("??????????(??????)")){%>selected<%}%>>??????????(??????)</option>
		      </select> </td>
                      					  
            <td width='13%' class='title'>??????</td>
            <td width="12%">&nbsp;
              <select name='reg_id' disabled >
                <option value="">????</option>
                <%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(cls.getReg_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
                <%		}
					}%>
              </select></td>	
                      
            <td width='13%' class='title'>????????</td>
            <td width="12%">&nbsp;
			  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt())%>' readonly size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 
	    <td width='12%' class='title'>????????</td>
	    <td width='12%' >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' value='<%=cls.getR_mon()%>' readonly  >????&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=cls.getR_day()%>' readonly >??&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>???? </td>
            <td colspan="5">&nbsp;
              <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cls.getCls_cau()%></textarea>			
            </td>
              <td width="12%" class=title ><font color=red>????????<br>????????</font></td>
             <td>&nbsp; 
		  <select name="match" >
		  <option value="" <% if(cls.getMatch().equals("")){%>selected<%}%>>--????--</option>
                     <option value="Y" <% if(cls.getMatch().equals("Y")){%>selected<%}%>>????????</option>           
              </select>
              </td>
          </tr>
          <tr>                                                      
            <td class=title >??????????<br>????????????</td>
     	    <td>&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()' disabled >
                <option value="N" <% if(cls.getCancel_yn().equals("N")){%>selected<%}%>>????????</option>
                <option value="Y" <% if(cls.getCancel_yn().equals("Y")){%>selected<%}%>>????????</option>
              </select>
		    </td>
		    
<%if( cls.getCls_st().equals("????????") )  { %>
  			  <td  class=title width=10%>??????????????</td>
            <td  width=12%>&nbsp;
				  <select name='add_saction_id'>
	                <option value="">--????--</option>
	                 <option value="000197" <% if(clsa.getAdd_saction_id().equals("000197")){%>selected<%}%>>??????</option> 	 
	                <option value="000172" <% if(clsa.getAdd_saction_id().equals("000172")){%>selected<%}%>>??????</option> 	              
	              </select>	                        
			      &nbsp;&nbsp;<%=clsa.getAdd_saction_dt()%>   </td>         
					

<% } else { %> 		    
		     <td  class=title width=10%>????????????</td>
            <td  width=12%>&nbsp;
				  <select name='sb_saction_id'>
	                <option value="">--????--</option>
	                <option value="000052" <% if(cls.getSb_saction_id().equals("000052")){%>selected<%}%>>??????</option> 
	                <option value="000053" <% if(cls.getSb_saction_id().equals("000053")){%>selected<%}%>>??????</option> 
	                <option value="000054" <% if(cls.getSb_saction_id().equals("000054")){%>selected<%}%>>??????</option> 
	                <option value="000118" <% if(cls.getSb_saction_id().equals("000118")){%>selected<%}%>>??????</option> 
	              </select>	        
		     &nbsp;&nbsp;<%=cls.getSb_saction_dt()%> </td>		 
		    
<% } %>		    

            <td  colspan="4" align=left>&nbsp;?? ?????? ???????? ???? ???? ???????? ?? ?????? ????, ?????????? ???????? ?????????? ???? </td>
          </tr>
          <tr>      
		            <td width='10%' class='title'>????????</td>
		            <td>&nbsp;
					  <input type='text' name='tot_dist' size='10' value='<%=AddUtil.parseDecimal(cls.getTot_dist())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km 
		            </td>
		             <td colspan=6   align=left>&nbsp;<%if( cls.getCls_st().equals("????????") ) { %>?? ?????????? ???????????? <% } else { %> ?? ???????? ?? ?????? ???????????? <%} %> </td>	         
		           
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
					                    <td class=title style='height:44' width=13%>???? ???????? </td>
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
 
	 <tr id=tr_opt style="display:<%if( cls.getCls_st().equals("????????") ){%>''<%}else{%>none<%}%>"> 
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	       		  <tr>
	       		   <td class=title width=13%>????????????</td>
	       		   <td  colspan="3">&nbsp; <input type='text' name='des_zip'  size='7' value='<%=clsm.getDes_zip()%>' class='text' >
				      <input type='text' size='70' name='des_addr'   value='<%=clsm.getDes_addr()%>'   maxlength='80' class='text'></td>
			  <td class=title width=10%>??????</td>
			  <td >&nbsp; <input type='text' size='30' name='des_nm'   value='<%=clsm.getDes_nm()%>'   maxlength='40' class='text'> </td>	
			   <td class=title width=10%>??????</td>
			  <td >&nbsp; <input type='text' size='30' name='des_tel'   value='<%=clsm.getDes_tel()%>'   maxlength='40' class='text'> </td>		
			  <td class=title width=10%>??????????</td>
			  <td  >&nbsp; <input type='text' size='12' name='conj_dt'   value='<%= AddUtil.ChangeDate2(seBean.getConj_dt()) %>'   maxlength='40' class='text'>      
			   <% if (   nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("??????????????",user_id)  ) { %>
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
    
       <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ??????????, ???????????? ?????? ?????? ?????? ?????? ???????????? ?????? ??????. ?????? ?????? ?????? ??????????????.</td>
    </tr>  
      
    <tr>
    	<td>&nbsp;<font color="#FF0000">***</font> ???????????????????? ?????????????? ?????????? ????????????.!!  ?????????? ???????? ????????????.!!</td>    
     </tr> 
    <tr>
      <td>&nbsp;</td>
    </tr> 	     
 
    <tr id=tr_dae style="display:<%if( cls.getCls_st().equals("??????????(????)") ){%>''<%}else{%>none<%}%>"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>??????????</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
                    <td width="13%" class=title>??????????????</td>
                    <td width="20%">&nbsp; &nbsp;
                      <input type='radio' name="prv_dlv_yn" value='N' <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%> disabled>
                      ????
                      <input type='radio' name="prv_dlv_yn" value='Y' <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%> disabled>
        	 		????
        		    </td>
                    <td width="10%" class=title style="font-size : 8pt;">????????????????</td>
                    <td colspan=3 >&nbsp; &nbsp;
                      <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> disabled>
                      ??????
                      <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> disabled>
        	 		????
        		    </td>
                </tr>
                <%	for(int i = 0 ; i < ta_vt_size ; i++){
						Hashtable ta_ht = (Hashtable)ta_vt.elementAt(i);
       					taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, ta_ht.get("NO")+"");
    			%>   
                 <tr>
                    <td width="13%" class=title>????????</td>
                    <td width="20%">&nbsp;<%=taecha.getCar_no()%>                  
        			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
        			</td>
                    <td width="10%" class='title'>????</td>
                    <td>&nbsp;<%=taecha.getCar_nm()%></td>
                    <td class='title'>??????????</td>
                    <td>&nbsp;<%=taecha.getInit_reg_dt()%></td>
                </tr>
                <tr>
                    <td class=title>??????????</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
                    <td class='title'>??????????</td>
                    <td width="20%" >&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
                    <td width="10%" class=title >????????</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>??(vat????) 
        			</td>
                </tr>
                <%} %>		 			     
		       </table>
		      </td>        
         </tr>   
         <tr>
     		<td>&nbsp;<font color="#FF0000">***</font> ?????????????? ???? ???? ???????? ?????? ???? ?? ???????? ??????????.!! </td>    
     	 </tr>
     	 <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
    
    
    <!-- ???? ???? --> 
    <tr id=tr_opt style="display:<%if( cls.getCls_st().equals("????????") ){%>''<%}else{%>none<%}%>"> 

 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????&nbsp;<a href="javascript:update('cls_asset')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a></span></td>
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
		          	
		 	 	     <td class='title' width="13%">??????????</td>
		             <td width="13%">&nbsp;<input type='text' name='opt_per' value='<%=f_opt_per%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title' width="13%">??????????</td>
		             <td colspan=2 width="26%">&nbsp;<input type='text' name='opt_amt'size='15' class='num' value="<%=AddUtil.parseDecimal(cls.getOpt_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_sui_c_amt();'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT????)</td> 
		             <td class='title' width="13%">????????</td>
		             <td colspan=2 width=22% >&nbsp;<input type="radio" name="sui_st" value="Y" <%if(cls.getSui_st().equals("Y")){%>checked<%}%> >????
                         <input type="radio" name="sui_st" value="N" <%if(cls.getSui_st().equals("N")){%>checked<%}%>>??????</td>
                  </tr>	
                                
		          <tr> 
		 	 	     <td class='title' width="13%" rowspan=3>????????????</td>
		             <td class='title' width="13%">??????</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d1_amt' value='<%=AddUtil.parseDecimal(cls.getSui_d1_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">????????</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d2_amt' value='<%=AddUtil.parseDecimal(cls.getSui_d2_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">??????</td>
		             <td colspan=2 >&nbsp;<input type='text' name='sui_d3_amt' value='<%=AddUtil.parseDecimal(cls.getSui_d3_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">??????</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d4_amt' value='<%=AddUtil.parseDecimal(cls.getSui_d4_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">??????</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d5_amt' value='<%=AddUtil.parseDecimal(cls.getSui_d5_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">????????</td>
		             <td colspan=2 >&nbsp;<input type='text' name='sui_d6_amt' value='<%=AddUtil.parseDecimal(cls.getSui_d6_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">????????????</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d7_amt' value='<%=AddUtil.parseDecimal(cls.getSui_d7_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">??????????</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d8_amt' value='<%=AddUtil.parseDecimal(cls.getSui_d8_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'></td> 
		             <td class='title' width="13%">??</td>
		             <td colspan=2  >&nbsp;<input type='text' name='sui_d_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getSui_d_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> ??&nbsp;&nbsp; *????????</td> 
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
 
    <tr id=tr_ret style="display:<%if( cls.getCls_st().equals("????????") || cls.getCls_st().equals("??????????(????)")  ){%>none<%}else{%>''<%}%>"> 
  
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????
			      <%  if (  nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("??????????????",user_id) || nm_db.getWorkAuthUser("??????????",user_id)  || nm_db.getWorkAuthUser("??????????",user_id)  || nm_db.getWorkAuthUser("??????????",user_id) ){%>     
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
			            <td width='13%' class='title'>????????</td>
			            <td width="20%">&nbsp;<input type="radio" name="reco_st" value="Y"  <%if(carReco.getReco_st().equals("Y")){%>checked<%}%> >????
	                            <input type="radio" name="reco_st" value="N" <%if(carReco.getReco_st().equals("N")){%>checked<%}%> >??????</td>
	                    <td width='13%' class='title'>????</td>
 
	                    <td id=td_ret1 style='display:<%if( carReco.getReco_st().equals("Y") ){%><%}else{%>none<%}%>'> &nbsp; 
						  <select name="reco_d1_st" disabled >
						    <option value="1" <%if(carReco.getReco_d1_st().equals("????????")){%>selected<%}%>>????????</option>
						    <option value="2" <%if(carReco.getReco_d1_st().equals("????????")){%>selected<%}%>>????????</option>
						    <option value="3" <%if(carReco.getReco_d1_st().equals("????????")){%>selected<%}%>>????????</option>
			               </select>       
			            </td>
 
			            <td id=td_ret2 style='display:<%if( carReco.getReco_st().equals("N") ){%><%}else{%>none<%}%>'> &nbsp; 
						  <select name="reco_d2_st" disabled >
						    <option value="1" <%if(carReco.getReco_d2_st().equals("????")){%>selected<%}%>>????</option>
						    <option value="2" <%if(carReco.getReco_d2_st().equals("????")){%>selected<%}%>>????</option>
						    <option value="3" <%if(carReco.getReco_d2_st().equals("????")){%>selected<%}%>>????</option>						  
						   </select>       
			            </td>
			            
			            <td class='title' width='13%' >????</td>
						<td>&nbsp;
						<input type="text" name="reco_cau" value='<%=carReco.getReco_cau()%>'size=30 maxlength=100 readonly >
						</td>				        		         
		         </tr>
		                   
		         <tr>      
		            <td width='10%' class='title'>????????</td>
		            <td>&nbsp;
					  <input type='text' name='reco_dt' readonly  value='<%=carReco.getReco_dt()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		            <td width='10%' class='title'>??????????</td>
		            <td>&nbsp;
					  <select name='reco_id' disabled >
		                <option value="">????</option>
		                  <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                 <option value='<%=user.get("USER_ID")%>' <%if(carReco.getReco_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
		                 <%		}
						 	}%>							           
		              </select>
		            </td>
		            <td width='10%' class='title'>????????</td>
		            <td>&nbsp;
					  <input type='text' name='ip_dt' readonly size='12' value='<%=carReco.getIp_dt()%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		          </tr>		         
		  
		   			 <tr>        
		            <td class=title>??????????</td>
	                    <td colspan=5> 
	                      &nbsp;<SELECT NAME="park" >
				                 <option value="" <% if(carReco.getPark().equals("")){%>selected<%}%>>--????--</option>
				                    <%if(good_size > 0){ 			
	                   			   for(int i = 0 ; i < good_size ; i++){
                  								CodeBean good = goods[i];%>
		       		          <option value='<%= good.getNm_cd()%>' <% if(carReco.getPark().equals(good.getNm_cd() ) )  {%>selected<%}%>><%= good.getNm()%></option>
		                 <%		}
						 	}%>	
	        		        </SELECT>
							<input type="text" name="park_cont" value='<%=carReco.getPark_cont()%>'  size="80" class=text style='IME-MODE: active'>
						(?????????? ????)
                    	</td>                    	 
	      	          </tr>	
	      	          
	      	          <tr>		          
                    	   <td class=title>?????? ????????</td>
                    	    <td >&nbsp;<input type="radio" name="serv_st" value="Y"  <%if(cls.getServ_st().equals("Y")){%>checked<%}%> >????????
	                            <input type="radio" name="serv_st" value="N" <%if(cls.getServ_st().equals("N")){%>checked<%}%> >?????? ????</td>
	                       <td class=title>?????? ????</td>
                    	    <td colspan=3>&nbsp;<input type="radio" name="serv_gubun" value="1"  <%if(cls.getServ_gubun().equals("1")){%>checked<%}%> >??????/??????
	                            &nbsp;<input type="radio" name="serv_gubun" value="3" <%if(cls.getServ_gubun().equals("3")){%>checked<%}%> >??????
	                            &nbsp;<input type="radio" name="serv_gubun" value="2" <%if(cls.getServ_gubun().equals("2")){%>checked<%}%> >????</td>     
	                            
	      	       </tr>		      
	      	       
		          <tr>      
		            <td width='10%' class='title'>????????</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='12' readonly value='<%=AddUtil.parseDecimal(carReco.getEtc_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		            </td>
		            <td width='10%' class='title'>????????</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='12'  readonly value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		            </td>
		            <td width='10%' class='title'>??????</td>
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
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>???????? ????</span>[??????]</td>
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
		                  <td class='title' align='right' colspan="3">????</td>
		                  <td class='title' width='38%' align="center">????</td>
		                  <td class='title' width="40%">????</td>
		                </tr>
		                <tr> 
		                 <tr> 
		                 <td class='title' rowspan="8" width=4%>??<br>
		                    ??<br>
		                    ??<br>
		                    ??</td>
		                  <td class='title' rowspan="2" >??<br>
		                  ??<br>
		                  ??<br>(A)</td>
		                  <td width="14%" align="center" >????????</td>
		                  <td align="center"> 
		                   <input type='text' name='grt_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>&nbsp;</td>		               	               
		                </tr>
		                 <tr>
		                  <td align="center" >????</td>
		                  <td align="center">&nbsp;<input type="radio" name="suc_gubun" value="1"   <%if(cct.getSuc_gubun().equals("1")){%>checked<%}%>  >?????????????? 
	                            &nbsp;<input type="radio" name="suc_gubun" value="2"    <%if(cct.getSuc_gubun().equals("2")){%>checked<%}%> >?????????????? </td>	  
		                    </td>
		                  <td>???????? ????????:&nbsp;<input type='text' name='suc_l_cd' size='15' value='<%=cct.getSuc_l_cd()%>' class='whitetext' >
		                   &nbsp;<!--<a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="??????????"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a> -->
		                  </td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3" width=4%>??<br>
		                    ??<br>
		                    ??<br>
		                    ??<br>
		                    ??</td>
		                  <td width="14%" align="center" >????????</td>
		                  <td align="center"> 
		                    <input type='text' size='3' name='ifee_mon' readonly  value='<%=cls.getIfee_mon()%>'  class='num' maxlength='4' >
		                    ????&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='<%=cls.getIfee_day()%>' class='num' maxlength='4' >
		                    ??</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >????????</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' readonly value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td>=????????????????????</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>???? ??????????(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td class='title'>=??????????-????????</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">??<br>
		                    ??<br>
		                    ??</td>
		                  <td align='center'>???????? </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td>=????????????????</td>
		                </tr>
		                <tr> 
		                  <td align='center'>?????? ???????? </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td>=????????????????????</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>???? ??????(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td class='title'>=??????-?????? ????????</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">??</td>
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
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>???????? ????</span>[??????]&nbsp;
 <%  if (  nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("??????????",user_id)   || nm_db.getWorkAuthUser("??????????",user_id)  || nm_db.getWorkAuthUser("????????????????",user_id)  ){%>     
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
              <td class="title" colspan="4" rowspan=2>????</td>
              <td class="title" width='40%' colspan=2> ????</td>             
              <td class="title" width='40%' colspan=2> ????</td>                   
              <td class="title" width='38%' rowspan=2>????</td>
            </tr>
            <tr>                 
              <td class="title"'> ????????</td>
              <td class="title"'> ????????</td>
              <td class="title"'> ????????</td>
              <td class="title"'> ????</td>
            </tr>
            <tr> 
              <td class="title" rowspan="27" width="4%">??<br>
                ??<br>
                ??<br>
                ??<br>
                ??</td>
              <td class="title" colspan="3">??????/??????(D)</td>
              <td align="center" class="title"> 
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' ></td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num'  ></td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_2'  value='<%=AddUtil.parseDecimal(clss.getFine_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>
               <td  align="center" class="title"> 
               <input type='text' name='fine_amt_3' readonly  value='<%=AddUtil.parseDecimal(cls.getFine_amt_1() - clss.getFine_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              
              <td class="title">??????????????</td>
             </tr>
             <tr> 
              <td class="title" colspan="3">??????????????????(E)</td>
              <td width='10%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' ></td>
              <td width='10%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>'   size='15' class='num'  ></td>   
              <td width='10%' align="center" class="title">
              <input type='text' name='car_ja_amt_2'  value='<%=AddUtil.parseDecimal(clss.getCar_ja_amt_2())%>'   size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'></td>
                <td width='10%' align="center" class="title">
              <input type='text' name='car_ja_amt_3' readonly  value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1() - clss.getCar_ja_amt_2())%>'   size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                              
              <td width='38%' class="title">??????????????</td>
            </tr>
             <tr>
              <td class="title" rowspan="4" width="4%"><br>
                ??<br>
                ??<br>
                ??</td>
              <td align="center" colspan="2" class="title">??????</td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>'  size='15' class='num' ></td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt_1' readonly  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' ></td> 
              <td class='' align="center">&nbsp;</td>   
              <td class='' align="center">&nbsp;</td>                             
              <td>&nbsp;</td>
             
            </tr>
         
            <tr> 
              <td rowspan="2" align="center" class="title" width="4%">??<br>
                ??</td>
              <td width='10%' align="center" class="title">????</td>
              <td class='' colspan=4  align="center"> 
                <input type='text' size='3' name='nfee_mon' value='<%=cls.getNfee_mon()%>' readonly class='num' maxlength='4' >
                ????&nbsp;&nbsp;&nbsp; 
                <input type='text' size='3' name='nfee_day' value='<%=cls.getNfee_day()%>'  readonly class='num' maxlength='4' >
                ??</td>
              <td>&nbsp;                         
              </td>
            </tr>
            <tr> 
              <td align="center" class="title">????</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt'  readonly  value='<%=AddUtil.parseDecimal(cls.getNfee_amt())%>' class='num' ></td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>  
              <td align="center">&nbsp; </td>  
               <td align="center">&nbsp; </td>    
              <td>?????????????? ???? ???? ?????????? ????  </td>
            </tr>
	  <tr> 
              <td class="title" colspan="2">????(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt' value='<%=AddUtil.parseDecimal(cls.getDfee_amt())%>' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_2'  value='<%=AddUtil.parseDecimal(clss.getDfee_amt_2())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'> </td>                 
                 <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_3' readonly  value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1() - clss.getDfee_amt_2())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '> </td>                 
                 <td class='title'>&nbsp;=?????? + ????</td>
            </tr>
                <input type='hidden' size='15' name='d_amt' >          
                <input type='hidden' size='15' name='d_amt_1'> 
            <tr> 
              <td rowspan="6" class="title">??<br>
                ??<br>
                ??<br>
                ??<br>
                ??<br>
                ??<br>
                ??</td>
              <td align="center" colspan="2" class="title">??????????</td>
              <td class='' colspan=4  align="center"> 
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=??????+????????????</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">????????(????)</td>
              <td class='' colspan=4 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' ></td>
              <td>=????????????????????</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">????????????????</td>
              <td class=''  colspan=4  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4' >
                ????&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day' readonly size='3' value='<%=cls.getRcon_day()%>' class='num' maxlength='4' >
                ??</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">???????? ?????? ????</td>
              <td class=''  colspan=4 align="center"> 
                <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' readonly size='15' class='num' ></td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> ?????? 
                ????????</td>
              <td class='' align="center"> 
                <input type='text' name='dft_int' readonly value='<%=cls.getDft_int()%>' size='5' class='num'  maxlength='5'>
                %</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int_1'  value='<%=cls.getDft_int_1()%>' size='5' class='num'  maxlength='5'>
                %</td>  
              <td class=''  align="center">&nbsp;</td>  
               <td class=''  align="center">&nbsp;</td>    
              <td>*?????? ?????????? ???????? ???? <br><font color=red>*</font>?????????? ?????? ?????? ???????????????? ?????? ????</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">??????????????(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' ></td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' ></td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_2' size='15' class='num'  value='<%=AddUtil.parseDecimal(clss.getDft_amt_2())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td>
                 <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' size='15' class='num' >            
                  <td align="center" class="title"> 
                <input type='text' name='dft_amt_3' readonly size='15' class='num'  value='<%=AddUtil.parseDecimal(cls.getDft_amt_1() - clss.getDft_amt_2())%>' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class="title">&nbsp;<input type='checkbox' name='tax_chk0'  value='Y' <%if(cls.getTax_chk0().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled ><!--??????????????-->
                 &nbsp;<font color="#FF0000">*</font>??????????????: 
                      <select name='dft_cost_id'  disabled >
		                <option value="">????</option>
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
                ??<br>
                ??</td> 
              <td colspan="2" align="center" class="title">??????(H)</td>
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
              <td class="title" colspan="2">????????????????(I)</td>
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
              <td class="title" colspan="2">????????????????(J)</td>
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
              <td colspan="2" class="title">????????????(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>'size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td> 
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_2' value='<%=AddUtil.parseDecimal(clss.getEtc3_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td>    
             <td align="center" class="title"> 
                <input type='text' name='etc3_amt_3' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1() - clss.getEtc3_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>    
             
              <td class="title">&nbsp;
                <% if  ( fuel_cnt > 0 && return_remark.equals("??????")  ) {%>
			 			<font color="#FF0000">*</font> ???????? ???? ????
			 		<% } %>	
			 		 <% if  ( fuel_cnt > 0   && return_remark.equals("????")  &&  cls.getCls_st().equals("????????") ) {%>
 							<font color="#FF0000">*</font> ???? ???????? ???? ????
 				       <% } %>	
              
              </td>
            </tr>
            <tr> 
              <td class="title" colspan="2">??????????????(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>'  size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>  
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_2' value='<%=AddUtil.parseDecimal(clss.getEtc4_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td> 
               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' size='15' class='num' >  
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_3' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1() - clss.getEtc4_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td> 
              <td class="title">&nbsp;<input type='checkbox' name='tax_chk3' value='Y' <%if(cls.getTax_chk3().equals("Y")){%>checked<%}%>  disabled ><!--??????????????-->
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
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='????' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>
    						&nbsp;<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>			                 
    						<%}%>
            <%}%></td>                               
            </tr>
               <tr> 
              <td class="title" colspan="2">??????????????????(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt())%>'  size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>  
              <td align="center" class="title"> 
                <input type='text' name='over_amt_2' value='<%=AddUtil.parseDecimal(clss.getOver_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'></td>             
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getOver_amt_v())%>' size='15' class='num' >  
              <td align="center" class="title"> 
                <input type='text' name='over_amt_3' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt_1() - clss.getOver_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>              
              <td class="title">&nbsp;<input type='checkbox' name='tax_chk4' value='Y' <%if(cls.getTax_chk4().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);" disabled >??????????????</td>                               
            </tr>
            
            
            <tr> 
              <td class="title" rowspan="9"><br>
                ??<br>
                ??<br>
                ??</td> 
                         
              <td width='10%' align="center" class="title" colspan=2 >??????????????</td>
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
              <td align="center" class="title" colspan=2 >??????????</td>
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
              <td align="center" class="title" colspan=2 >??????</td>
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
              <td align="center" class="title" colspan=2 >??????????</td>
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
              <td align="center" class="title" colspan=2 >????????????</td>
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
              <td align="center" class="title" colspan=2 >????????????</td>
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
              <td align="center" class="title" colspan=2>??????????????</td>
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
              <td align="center" class="title" colspan=2>??????????????????</td>
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
              <td class="title" colspan="2">????(N)</td>
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
                    <td id=td_cancel_n style="display:<%if( cls.getCancel_yn().equals("N") ){%>none<%}else{%>''<%}%>" class="title">=(?????? 
                      ????-B-C)??10% + ?????? ???? ?????? </td> 
                    <td id=td_cancel_y style="display:<%if( cls.getCancel_yn().equals("Y") ){%>none<%}else{%>''<%}%>" class='title'>=(?????? 
                       ????-B-C)??10% + ?????? ???? ?????? </td>
                  </tr>
                </table>
              </td>
            </tr>
            
            
            <tr> 
              <td class="title_p" colspan="4">??</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1'value='<%=AddUtil.parseDecimal(cls.getFdft_amt1())%>' readonly  size='15' class='num' ></td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' readonly  size='15' class='num' ></td>  
               <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_2' value='<%=AddUtil.parseDecimal(clss.getFdft_amt1_2())%>'  readonly  size='15' class='num' ></td>   
               <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_3' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1() - clss.getFdft_amt1_2())%>'  readonly  size='15' class='num' ></td>     
              <td class='title_p'>&nbsp;????????????:<input type='text' name='fdft_j_amt'  value='' readonly  size='15' class='num' >
               =(D+E+F+G+H+I+J+K+L+M+N)&nbsp;&nbsp;              
                <br>?? ??????:&nbsp;              
               <input type="radio" name="tax_reg_gu" value="N"  <%if(cls.getTax_reg_gu().equals("N")){%>checked<%}%> >??????????????
               <input type="radio" name="tax_reg_gu" value="Y"  <%if(cls.getTax_reg_gu().equals("Y")){%>checked<%}%> >??????????????(1??)
          <!--     <input type="radio" name="tax_reg_gu" value="Z"  <%if(cls.getTax_reg_gu().equals("Z")){%>checked<%}%> >?????????????????? -->
              
              </td>
            </tr>
          </table>
        </td>         
    </tr>
   
    <tr></tr><tr></tr><tr></tr>
    
      <!-- ?????? ???? ???? - 20150706 -->
      <tr id=tr_jung style="display:<%if( cls.getCls_st().equals("????????") ) { %>none<%} else {%>''<% } %>">      
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????</span></td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		    	
   		  <tr> 
		        <td colspan="2" class='line'> 
		          <table border="0" cellspacing="1" cellpadding="0" width=100%>
		            <tr> 
			            <td width='10%' class='title'>????????</td>
			            <td colspan=5>&nbsp;<input type="radio" name="jung_st" value="1"   <%if(cct.getJung_st().equals("1")){%>checked<%}%> onClick='javascript:cls_display4()'>????????
	                            <input type="radio" name="jung_st" value="2"  <%if(cct.getJung_st().equals("2")){%>checked<%}%> onClick='javascript:cls_display4()'>????????</td>
	                    </tr>
		           <tr> 
		                <td class="title" rowspan=3 width='10%'>????</td>                
		              <td class="title"  rowspan=3  width='12%'>????????(????)</td>
		              <td class="title"  colspan="3"  width='35%'>????????</td>
		              <td class="title" rowspan=3  width='43%'>????</td>
		            </tr>
		            <tr> 
		               <td class="title" rowspan=2 width='12%'>????</td>
		               <td class="title" colspan=2 >????</td>
		            </tr>
		              <tr> 
		               <td class="title" >????</td>
		               <td class="title" >????</td>
		            </tr>
		            <tr> 
		              <td class="title"  >????????</td>   
		              <td>&nbsp; <input type='text' name='h1_amt' value='<%=AddUtil.parseDecimal(cct.getH1_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td>&nbsp; <input type='text' name='h4_amt' value='<%=AddUtil.parseDecimal(cct.getH4_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td align="center" >&nbsp; </td>
		              <td align="left" >&nbsp;</td>
		              <td align="left"  rowspan=3>&nbsp;</td> 
		             </tr>
		                <tr> 
		              <td class="title"  >??????????</td>   
		              <td>&nbsp; <input type='text' name='h2_amt' value='<%=AddUtil.parseDecimal(cct.getH2_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td>&nbsp;</td>
		              <td align="center" >&nbsp;<input type='text' name='h6_amt' value='<%=AddUtil.parseDecimal(cct.getH6_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td align="left" >&nbsp; <select name='h_st'>
			                <option value="">--????--</option>
			                <option value="1" >??????</option>
		                         <option value="2" >??????</option>
		                         <option value="3" >????</option>
			              </select>
		              </td>
		             </tr>
		             <tr> 
		              <td class="title"  >????????</td>   
		              <td>&nbsp; <input type='text' name='h3_amt' value='<%=AddUtil.parseDecimal(cct.getH3_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td>&nbsp; <input type='text' name='h5_amt' value='<%=AddUtil.parseDecimal(cct.getH5_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		              <td align="center" >&nbsp;<input type='text' name='h7_amt' value='<%=AddUtil.parseDecimal(cct.getH7_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '> </td>
		              <td align="left" >&nbsp;??????????: <input type='text' name='h_ip_dt' size='10'  value='<%=AddUtil.ChangeDate2(cct.getH_ip_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
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
                    <td class=title width=10%>????????????</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2' readonly  value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>' size='15' class='num'  ></td>               
                                          	  
                    <% if ( h_cms.get("CBNO") == null  ) {%>
                    <td colspan=6>&nbsp;?? ?????????? - ??????????</td>
                    <% } else { %>    
              		<td class=title width=12% ><input type='checkbox' name='cms_chk' value='Y' <%if(cls.getCms_chk().equals("Y")){%>checked<%}%> >CMS????????</td>
                	<td>&nbsp;?? ?????????? - ??????????</td>    
	                <td colspan=4 width=30%>&nbsp;<input type='checkbox' name='cms_after' value='Y' <%if(clsm.getCms_after().equals("Y")){%>checked<%}%> ><font color="red">CMS ?????? ????????</font></td> 
             		<% } %>                     
              </tr>
             
              </table>
         </td>       
    <tr>
        
    <tr></tr><tr></tr><tr></tr><tr></tr>
     
      
      <tr id=tr_jung1 style="display:<%if( cls.getCls_st().equals("????????") ) { %>none<%} else {%>''<% } %>">      
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
               <tr> 
			            <td width='10%' class='title'>????</td>
			            <td colspan=5>&nbsp;
			            <input type="radio" name="refund_st" value="1" <%if(cct.getRefund_st().equals("1")){%>checked<%}%> >??????????????/????????			           
			                &nbsp;&nbsp;&nbsp; <input type="radio" name="refund_st" value="2"  <%if(cct.getRefund_st().equals("2")){%>checked<%}%>  >?????????????? 
	                   </td>	              
	              </tr>
	              <tr> 
			            <td width='10%' class='title' rowspan=2>????</td>
			            <td colspan=5>&nbsp;<input type="checkbox" name="delay_st" value="Y"  <%if(cct.getDelay_st().equals("Y")){%>checked<%}%>>?????????????? ????(????)
	                      &nbsp;&nbsp;&nbsp;<input type="radio" name="delay_type" value="1"    <%if(cct.getDelay_type().equals("1")){%>checked<%}%> >1. ?????????? ?????? ????
			                   &nbsp;&nbsp;&nbsp;<input type="radio" name="delay_type" value="2"  <%if(cct.getDelay_type().equals("2")){%>checked<%}%>>2. ?????? ????
			                   &nbsp;&nbsp;&nbsp;<input type="radio" name="delay_type" value="3"  <%if(cct.getDelay_type().equals("3")){%>checked<%}%>>3. ????
	                  </td>	           
	              </tr>
	              <tr> 			          
			            <td colspan=5>&nbsp;&nbsp;&nbsp;<font color=red><b>?????? ???? ?????? ????: </b></font><textarea name="delay_desc" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cct.getDelay_desc()%></textarea></td>
	               </tr>   	         
	               
       	 	  <tr> 	 	     
	              <td class="title"  width='10%'>????</td>
	              <td class="title" width='12%'>????</td>                
	              <td class="title" width='18%'>????????</td>
	              <td class="title" width='18%'>????????</td>
	              <td class="title" width='42%'>????</td>
	            </tr>
	            <tr> 
	              <td class="title" >????????</td>   
	              <td align=right>&nbsp;
	              <%  	       //????????  
	  if(cct.getJung_st().equals("1"))  {
	     if ( cls.getFdft_amt2() < 0 ) {  %><%=AddUtil.parseDecimal(cls.getFdft_amt2() * (-1))%>
<%  	      }  %>
<%  	   }  %>	 
<%  	       //????????  
	  if(cct.getJung_st().equals("2"))  {
	     if ( cct.getH5_amt() > 0 ) {  %><%=AddUtil.parseDecimal(cct.getH5_amt())%>
<%  	      }  %>
<%  	   }  %>
	              </td>
	              <td >&nbsp;</td> <!--????????????-->
	              <td >&nbsp; 
	             	 <select name='pay_st'>
			                <option value="">--????--</option>
			                <option value="1"<%if(cct.getPay_st().equals("1")){%>selected<%}%>>????????</option>
			                <option value="2"<%if(cct.getPay_st().equals("2")){%>selected<%}%>>????????</option>	       
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
    							&nbsp;<a href="javascript:openPop('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='????' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    			<%}else{%>			
    						&nbsp;<a href="javascript:scan_reg('4')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>(?????????? ????)
    			<%}  %> 
    			</td>
	             </tr>
	                   <tr> 
	              <td class="title" >????????</td>   
	              <td align=right>&nbsp;
	              <%  	       //????????  
	  if(cct.getJung_st().equals("1"))  {
	     if ( cls.getFdft_amt2() > 0 ) {  %><%=AddUtil.parseDecimal(cls.getFdft_amt2() )%>
<%  	      }  %>
<%  	   }  %>	 
<%  	       //????????  
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
                    <td class=title width=10%>??????????<br>??????</td>
                    <td width=12%>&nbsp;
						   <select name='dly_saction_id'>
			                <option value="">--????--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getDly_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select>
			        </td>
                    <td class=title width=12%>?????? ????????</td>
                    <td colspan=3>&nbsp;<textarea name="dly_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getDly_reason()%></textarea></td> 
				 
                </tr>
                <tr>
                	<td class=title width=10%>??????????????<br>???? ??????</td>
                    <td width=12%>&nbsp;
						   <select name='dft_saction_id'>
			                <option value="">-????--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getDft_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select>
			              &nbsp;&nbsp;<%=cls.getDft_saction_dt()%>
			        </td>
                    <td class=title width=12%>??????????????<br>????????</td>
				    <td colspan=3>&nbsp;<textarea name="dft_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getDft_reason()%></textarea></td> 
				    
                </tr>
                <tr>
                  	<td class=title width=10%>??????????????</td>
                    <td width=12%>&nbsp;
						   <select name='d_saction_id'>
			                <option value="">-????--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getD_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select>
			        </td>
                    <td class=title width=12%>???????? ????</td>
                    <td colspan=3>&nbsp;<textarea name="d_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getD_reason()%></textarea></td> 				   
                </tr>
                <!--
                 <tr>
                	<td  class=title width=10%>????????????????????</td>
                    <td  width=12%>&nbsp;
						  <select name='ext_saction_id'>
			                <option value="">--????--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
						       <option value='<%=user1.get("USER_ID")%>' <%if(cls.getExt_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>	
			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>????????????</td>
                    <td colspan=3>&nbsp;<textarea name="ext_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getExt_reason()%></textarea></td> 				  
                </tr>-->
              </table>
         </td>       
    </tr>
              
    <tr></tr><tr></tr><tr></tr>
 
 
    <tr id=tr_sale style="display:<%if( cls.getCls_st().equals("????????") ){%>''<%}else{%>none<%}%>"> 
    
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >??????????<br>????????????</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt3'  value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>' size='15' class='num' readonly  ></td>
                    <td colspan=6>&nbsp;?? ????????????  + ???????????? + ????????????(?????? ????)</td>
              </tr>                       
            </table>
         </td>       
    </tr> 
    
    
      <tr>
        <td class=h></td>
    </tr>
   
     <tr></tr><tr></tr><tr></tr>
      
    <!-- ???????????? ????  block none  ?????????? 2???????? ?????? ????  -->
 
   <tr id=tr_cal_sale style="display:<%if( clsa.getOld_opt_amt() > 0 ){%>''<%}else{%>none<%}%>"> 
    
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
         <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>???? ??????</span>
 	 		<%  if (  nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("??????????????",user_id)  || nm_db.getWorkAuthUser("??????????",user_id)  ){%>     
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
               <td class="title"  rowspan="2"  width='3%'>????</td>
              <td class="title"  rowspan="2" width='8%'>??????????</td>                
              <td class="title"  rowspan="2" width='8%'>????????<br>(??????)</td>
              <td class="title"  rowspan="2" width='8%'>???????? ?????? <br>?????? ????????</td>
              <td class="title"  rowspan="2" width='8%'>?????? ???????? ??????<br> ????????(??????)</td>                  
              <td class="title"  rowspan="2" width='8%'>????????</td>                
              <td class="title"  rowspan="2" width='8%'>??????+<br>????????</td>
              <td class="title"  rowspan="2" width='8%'>????????,??????<br> ????????<br>(??????)</td>                
              <td class="title"  width='25%' colspan=3>????????,?????? ?????????? ????????</td>             
              <td class="title"  width='16%' colspan=2>???????? ???? ????????<br>(??????: ?? <%=clsa.getA_f()%>%)</td>       
            </tr>          
            
            <tr> 
             <td class="title"  width='8%' >??????</td>
              <td class="title"  width='8%'>??????</td>
              <td class="title"  width='9%'>????</td>
              <td class="title"  width='8%'>??????????</td>
              <td class="title"  width='8%'>??????????<br>????????</td>
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
                    <td colspan="2" class=title>????</td>
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
    
           <!-- ???????????????? ????  block none--> 
          <tr id=tr_over style="display:<%if( co.getRent_days() > 0 ){%>''<%}else{%>none<%}%>"> 
             	
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>??????????????????[??????]</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	 	 	
 	 	   <tr> 
 	      <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="3"  width='34%'>????</td>
              <td class="title" width='20%'>????</td>                
              <td class="title" width='46%'>????</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="6" >??<br>??<br>??<br>??</td>   
              <td class="title"  rowspan=3>????????</td>
              <td class="title" >????????</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
              <td align="left" >&nbsp;????????????</td>
             </tr>
              <tr> 
              <td class="title" >???????? (??)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;????</td>
             </tr>      
              <tr> 
              <td class="title" > ????(??????) (a)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>??</td>
               <td align="left" >&nbsp;=1km</td>
             </tr>           
            <tr> 
              <td class="title"  rowspan=3>????????</td>
              <td class="title" >????????</td>
              <td align="center">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
              <td align="left" >&nbsp;????????????</td>
             </tr>   
              <tr> 
              <td class="title" >????????(??)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(co.getRent_days() )%>' size='7' class='whitenum' > ?? </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title" >????????(????)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7'  value='<%=AddUtil.parseDecimal(co.getCal_dist() )%>' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(??)x(??) / 365</td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >??<br>??<br>??<br>??</td>      
               <td class="title"  rowspan=3>????????</td>
              <td class="title" >??????????????(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value='<%=AddUtil.parseDecimal(co.getFirst_dist() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;????(???? ???????? ????????) , ?????? (???????? ?????? ????????)</td>
             </tr>   
             <tr> 
              <td class="title" >??????????????(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly value='<%=AddUtil.parseDecimal(co.getLast_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title" >??????????(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly   value='<%=AddUtil.parseDecimal(co.getReal_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
              <tr> 
              <td class="title"  rowspan=3>????????</td>
              <td class="title" >????????????(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly   value='<%=AddUtil.parseDecimal(co.getOver_dist() )%>'   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title" >??????????????</td>
              <td align="right" ><input type='text' name='add_dist' readonly value='<%=AddUtil.parseDecimal(co.getAdd_dist() )%>'      size='7' class='whitenum' > km</td>
                <td align="left" >&nbsp;</td>
             </tr>      
              <tr> 
              <td class="title" >????????(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly value='<%=AddUtil.parseDecimal(co.getJung_dist() )%>'      size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>??<br>??</td>
              <td class="title" colspan=2 >????????(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getR_over_amt() )%>'     size='10' class='whitenum' >??</td>
              <td align="left" >&nbsp;=(a)x(b)</td>
             </tr>
              <tr> 
              <td class="title"   colspan=2 >????(i)</td>
              <td align="right"><input type='text' name='m_over_amt'  value='<%=AddUtil.parseDecimal(co.getM_over_amt() )%>'  readonly     size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> ??</td>
              <td align="left" >&nbsp;????????????:
              	   <select name='m_saction_id'>
			                <option value="">--????--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(co.getM_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="m_reason" cols="55" class="text" style="IME-MODE: active" rows="2"><%=co.getM_reason()%></textarea> </td>
             </tr>      
              <tr> 
              <td class="title"   colspan=2 >????(????)????</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getJ_over_amt() )%>'     size='10' class='whitenum' >??</td>
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
      
   <!-- ???? ???? --> 
    <tr id=tr_ip_opt style="display:<%if( cls.getCls_st().equals("????????") ){%>''<%}else{%>none<%}%>"> 
 
	   <%  //???????????????? 
	      if ( cls.getCls_st().equals("????????") ) {
	    //	 System.out.println("status = " + clsm.getStatus());
	    	 if ( !clsm.getStatus().equals("0") ) {  
	    		 maeip_amt =  clsm.getM_dae_amt();
	    		 m_ext_amt =  clsm.getExt_amt();
	    	 }  else { //?????? ?????? 
		    	 if (cls.getFdft_amt2() < 0) {  
			 		   maeip_amt = cls.getFdft_amt2()* (-1);
					 
					   if (maeip_amt > cls.getOpt_amt() ) {
						    maeip_amt = cls.getOpt_amt();						  
					   }  				    	
			     }
	    	 
		    	 if (cls.getFdft_amt3() < 0) {  
		    	    m_ext_amt  = (cls.getFdft_amt3() * (-1)) + maeip_amt + cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2() - cls.getOpt_amt() - cls.getSui_d_amt() ;	
	    	  //   } else {
	    	  //  	m_ext_amt  = maeip_amt +cls.getOpt_ip_amt2()  + cls.getOpt_ip_amt1() - cls.getOpt_amt() - cls.getSui_d_amt() ;	
	    	     } 	    	  
		    
		     }
		    
		   }   
	   %> 
	   
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>???????? ????
 	 		   <%  if (  nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("??????????????",user_id) ){%>     
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
		                    <td class=title width=10%>????????</td>
		                    <td width=13%>&nbsp;<input type='text' name='m_dae_amt'   value='<%=AddUtil.parseDecimal(maeip_amt)%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_maeip_amt(this);' ></td>
		                    <td colspan=6>&nbsp;</td>						  
		              </tr>
		       		  <tr>
		                    <td class=title width=10%>??????</td>
		                    <td width=13%>&nbsp;<input type='text' name='opt_ip_amt1'  value='<%=AddUtil.parseDecimal(cls.getOpt_ip_amt1())%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_maeip_amt(this);' ></td>
		                    <td class=title width=10%>??????</td>
						    <td width=10%>&nbsp;<input type='text' name='opt_ip_dt1' value='<%=cls.getOpt_ip_dt1()%>'  size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
						    <td class=title width=10%>????????</td>
						    <td width=10%>&nbsp;<select name='opt_bank_code1' onChange='javascript:change_bank(this)'>
		                        <option value=''>????</option>
		                        <%if(a_bank_size > 0){
		        						for(int i = 0 ; i < a_bank_size ; i++){
		        							CodeBean a_bank = a_banks[i];	%>
		                        <option value='<%= a_bank.getCode()%><%= a_bank.getNm()%>' <%if(cls.getOpt_ip_bank1().equals(a_bank.getCode())){%>selected<%}%>> <%=a_bank.getNm()%> 
		                        </option>
		                        <%	}
		        					}	%>
		                      </select>&nbsp;</td>
		                    <td class=title width=10%>????????</td>
				            <td>&nbsp;<select name='opt_deposit_no1'>
		                        <option value=''>?????? ??????????</option>
		        				<%if(!cls.getOpt_ip_bank1().equals("")){
		        						Vector deposits = neoe_db.getDepositList(cls.getOpt_ip_bank1()); /* ???????? */
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
		                    <td class=title width=10%>??????</td>
		                    <td width=13%>&nbsp;<input type='text' name='opt_ip_amt2'  value='<%=AddUtil.parseDecimal(cls.getOpt_ip_amt2())%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_maeip_amt(this);' ></td>
		                    <td class=title width=10%>??????</td>
						    <td width=10%>&nbsp;<input type='text' name='opt_ip_dt2' value='<%=cls.getOpt_ip_dt2()%>'  size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
						    <td class=title width=10%>????????</td>
						    <td width=10%>&nbsp;<select name='opt_bank_code2' onChange='javascript:change_bank(this)'>
		                        <option value=''>????</option>
		                        <%if(a_bank_size > 0){
		        						for(int i = 0 ; i < a_bank_size ; i++){
		        							CodeBean a_bank = a_banks[i];	%>
		                        <option value='<%= a_bank.getCode()%><%= a_bank.getNm()%>' <%if(cls.getOpt_ip_bank2().equals(a_bank.getCode())){%>selected<%}%>> <%= a_bank.getNm()%> 
		                        </option>
		                        <%	}
		        					}	%>
		                      </select>&nbsp;</td>
		                    <td class=title width=10%>????????</td>
				            <td>&nbsp;<select name='opt_deposit_no2'>
		                        <option value=''>?????? ??????????</option>
		        				<%if(!cls.getOpt_ip_bank2().equals("")){
		        						Vector deposits = neoe_db.getDepositList(cls.getOpt_ip_bank2()); /* ???????? */
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
		                    <td class=title width=10%>????</td>
		                    <td width=13%>&nbsp;<input type='text' name='t_dae_amt' readonly  value='<%=AddUtil.parseDecimal(maeip_amt+cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2())%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' ></td>
		                    <td colspan=6>&nbsp;????????:&nbsp; 
		                     	<input type="text" name="ext_amt"  size='15' class='num' value='<%=AddUtil.parseDecimal(m_ext_amt)%>' >	
		                        <input type="radio" name="ext_st" value="1" <%if(cls.getExt_st().equals("1"))%>checked<%%> >????????
				                <input type="radio" name="ext_st" value="2" <%if(cls.getExt_st().equals("2"))%>checked<%%> >??????	
				     		                	                    
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>??????????</span>&nbsp;&nbsp;<font color=red><%=print_nm%></font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0>
               <tr> 
                  <td width="3%" rowspan="2" class='title'>????</td>
                  <td colspan="4" class='title'>????</td>
                  <td colspan="6" class='title'>????</td>                
                </tr>
                <tr> 
               	  <td width="10%" class='title'>????????</td>          
   				  <td width="10%" class='title'>??????</td> 
   				  <td width="10%" class='title'>??????</td>       
   				  <td width="10%" class='title'>????</td>                     
                  <td width="13%" class='title'>????</td>
                  <td width="10%" class='title'>??????</td>
                  <td width="10%" class='title'>??????</td>
                  <td width="10%" class='title'>????</td>
                  <td width="13%" class='title'>????</td>
                  <td width="3%" class='title'>????</td>
                </tr>
                
 <% if  (  !bit.equals("????") ) { %>
                             
                <tr> 
                  <td height="23" align="center">1</td>
                  <td align="center">??????????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">????????????</td>
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
                  <td align="center">????????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">??????????????????</td>
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
                  <td class="title_p" align="center" colspan=2>&nbsp;??</td>
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
                  <td align="center">??????????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">????????????</td>
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
                  <td align="center">????????????</td>
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
                  <td align="center">??????????</td>
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
                  <td align="center">??????????????????</td>
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
                  <td class="title_p" align="center" colspan=2>&nbsp;??</td>
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
        <td>&nbsp;<font color="#FF0000">***</font> ???????? ????, ???????? ???????? ???? ?????? ???????????????? ???????? ?????? ??????????.!!!</td>
    </tr>
           
    <tr>
        <td>&nbsp;</td>
    </tr>
        
   	<tr id=tr_gur style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
   		  
   		    <tr> 
		        <td class='line'> 
		            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		                	<tr>		            
				                    <td width="3%" rowspan="3" class=title>????<br>????</td>
				                   <td class=title width=12%>????????</td>
				                    <td width=13%>&nbsp;<input type='text' name='exam_dt'  size='12'  value= '<%=cce.getExam_dt()%>' class='text' ' onBlur='javascript: this.value = ChangeDate(this.value);'></td> 
				                    <td class=title width=12%>??????????</td>
				                    <td >&nbsp;				                    
				                        <select name='exam_id'>
					                <option value="">????</option>
					                <%	if(user_size > 0){
											for(int i = 0 ; i < user_size ; i++){
												Hashtable user = (Hashtable)users.elementAt(i); %>
					                <option value='<%=user.get("USER_ID")%>' <%if(cce.getExam_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
					                <%		}
										}%>
					              </select></td>
				            </tr>
		               		   <tr>		            
				                     <td class=title width=12%>????????</td>
				                     <td  colspan=3>&nbsp;
				                       <INPUT TYPE="checkbox" NAME=s_gu1  value='Y' <%if(cce.getS_gu1().equals("Y")){%>checked<%}%> > 1) ??????????
		                                          <INPUT TYPE="checkbox" NAME=s_gu2  value="Y"<%if(cce.getS_gu2().equals("Y")){%>checked<%}%> > 2) ??????????????????
		                                          <INPUT TYPE="checkbox" NAME=s_gu3  value="Y"<%if(cce.getS_gu3().equals("Y")){%>checked<%}%> > 3) ????????
		                                          <INPUT TYPE="checkbox" NAME=s_gu4  value="Y"<%if(cce.getS_gu4().equals("Y")){%>checked<%}%> > 4) ????( <input type='text' name=s_remark' value='<%=cce.getS_remark()%>' size=70' class='text' >   )					                                    
				                     </td>		               
				            </tr>
				             <tr>		            
				                     <td class=title width=12%>????</td>
				                    <td  colspan=3>&nbsp;<textarea name="s_result" cols="120" class="text" style="IME-MODE: active" rows="2"><%=cce.getS_result()%></textarea>
				                   </td>					                       
				            </tr>
				        
		            </table>
		        </td>
	    </tr>
    	   <tr></tr><tr></tr><tr></tr><tr></tr>
    	  
    	         <tr>
      		   <td><img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle><span class=style2> ?????? </span>
 	 		      (<input type='radio' name="guar_st" value='1'  <%if(carCre.getGuar_st().equals("1")){%> checked <%}%>>
        				??
        			  <input type='radio' name="guar_st" value='0'  <%if(carCre.getGuar_st().equals("0")){%> checked <%}%>>
        				?? ) 
 	 	</td> 
 	      </tr>    
    
 	            <!-- ?????????????? -->
<% if(gur_size > 0){
				for(int i = 0 ; i < gur_size ; i++){
					Hashtable gur = (Hashtable)gurs.elementAt(i); %>   					
    	
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%> 	
		          <tr>		            
		                    <td width="3%" rowspan="4" class=title>??<br>??</td>
		                   <td class=title width=12%>????</td>
		                     <input type='hidden' name='gu_seq' value='<%=i%>'  > 
		                    <td width=13%>&nbsp;<input type='text' name='gu_nm' value='<%=gur.get("GU_NM")%>' size='15' class='text' > </td>
		                    <td class=title width=12%>????????????</td>
		                    <td width=13%>&nbsp;<input type='text' name='gu_rel' value='<%=gur.get("GU_REL")%>' size='15' class='text' ></td>
		                     <td class=title width=12%>??????</td>
		                    <td width=13%>&nbsp;<input type='text' name='gu_tel' value='<%=gur.get("GU_TEL")%>' size='15' class='text' ></td>
		            </tr>
               		   <tr>		            
		                     <td class=title width=12%>????</td>
		                    <td  colspan=5>&nbsp;<input type='text' name='gu_zip' value='<%=gur.get("GU_ZIP")%>' size='8' class='text' >&nbsp;<input type='text' name='gu_addr' value='<%=gur.get("GU_ADDR")%>' size='100' class='text' > </td>		               
		            </tr>
		             <tr>		            
		                     <td class=title width=12%>????????</td>
		                    <td  colspan=2>&nbsp;<input type='radio' name="plan_st<%=i%>" value='Y' <%if(gur.get("PLAN_ST").equals("Y")){%> checked <%}%>>???? <input type='radio' name="plan_st<%=i%>" value='N'  <%if(gur.get("PLAN_ST").equals("N")){%> checked <%}%>>???? </td>	
		                    <td class=title width=12%>???????? ????????</td>
		                    <td  colspan=2>&nbsp;<input type='radio' name="eff_st<%=i%>" value='Y'  <%if(gur.get("EFF_ST").equals("Y")){%> checked <%}%>>???? <input type='radio' name="eff_st<%=i%>" value='N'  <%if(gur.get("EFF_ST").equals("Y")){%> checked <%}%>>???? </td>		               
		            </tr>
		            <tr>		            
		                     <td class=title width=12%>??????????</td>
		                    <td  colspan=2>&nbsp;<input type='text' name='plan_rem' value='<%=gur.get("PLAN_REM")%>' size='50' class='text' > </td>	
		                    <td class=title width=12%>??????????</td>
		                    <td  colspan=2>&nbsp;<input type='text' name='eff_rem' value='<%=gur.get("EFF_REM")%>' size='50' class='text' > </td>		               
		            </tr>
		            </table>
		      </td>     
             </tr> 
             <% }
  }             %> 		          
	                
  	   <tr></tr><tr></tr><tr></tr><tr></tr>
  	    <tr>
      		   <td><img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle><span class=style2> ???????? </span>
 	 		     ( <input type='radio' name="gi_st" value='1'  <%if(gins.getGi_st().equals("1")){%> checked <%}%>>
                  		??
                  		<input type='radio' name="gi_st" value='0'  <%if(gins.getGi_st().equals("0")){%> checked <%}%>>
                  		?? )  
 	 	</td> 
 	      </tr>    
    	   
    	     <tr>
 	 	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr>
		                     <td class=title width=12%>????????</td>
		                    <td class=title width=13%>????????</td>
		                    <td width=12%>&nbsp;<input type='text' name='gi_amt' readonly value='<%=AddUtil.parseDecimal(carCre.getGi_amt())%>' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                    <td class=title width=12%>????????</td>
		                    <td width=13%>&nbsp;<input type='text' name='gi_c_amt' size='15' value='<%=AddUtil.parseDecimal(carCre.getGi_c_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'></td>
		                    <td class=title width=12%>????????</td>
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
		                          <td class=title width=12%>??????????????</td>
			                    <td class=title width=13%>??????</td>
			                    <td width=12%>&nbsp;<input type='text' name='c_ins' value='<%=carCre.getC_ins()%>'  size='18' class='text' > </td>
			                    <td class=title width=12%>??????</td>
			                    <td width=13%>&nbsp;<input type='text' name='c_ins_d_nm'  value='<%=carCre.getC_ins_d_nm()%>' size='18' class='text' > </td>
			                    <td class=title width=12%>??????</td>
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

    <!-- ???????????? ???? : ?????????? ???? ???? --> 
    <tr id=tr_cre style="display:<%if( cls.getFdft_amt2() > 0 ) {%>''<%}else{%>none<%}%>"> 
     
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>?????????? ????????/????????</span></td>
 	 	  </tr>  
	      <tr>
	        <td class=line2></td>
	      </tr>
	      <tr>
	        <td class=line>
	           <table width=100% border=0 cellspacing=1 cellpadding=0>
	                <tr>
	                    <td class=title colspan=2>????</td>
	                    <td class=title width=10%>????????</td>
	                     <td class=title width=8%>????????</td>
	                    <td class=title width=60%>????????/????????/????</td>
	                </tr>
	                <tr>
	                    <td class=title width=12%>????????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu1">
	                          <option value="" selected>-????-</option>
	                          <option value="Y" <% if(carCre.getCrd_reg_gu1().equals("Y")){%>selected<%}%>>??</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu1().equals("N")){%>selected<%}%>>??????</option>
		                   </select>      
	                    </td>
	                       <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu1" value='Y'  <% if(carCre.getCrd_req_gu1().equals("Y")){%> checked <%}%>> ??
                  		 <input type='radio' name="crd_req_gu1" value='N'  <% if(carCre.getCrd_req_gu1().equals("N")){%> checked <%}%>>  ??
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri1' value='<%=carCre.getCrd_pri1()%>' size='1' class='text' ></td>                  		 
	                    <td>&nbsp;<input type='text' name='crd_remark1' value='<%=carCre.getCrd_remark1()%>' size='100' class='text' ></td>
	                 
	                </tr>
	                <tr>
	                    <td class=title>??????????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu2">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu2().equals("Y")){%>selected<%}%>>??</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu2().equals("N")){%>selected<%}%>>??????</option>
	                        </select>      
	                    </td>
	                         <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu2" value='Y'  <% if(carCre.getCrd_req_gu2().equals("Y")){%> checked <%}%>> ??
                  		 <input type='radio' name="crd_req_gu2" value='N'  <% if(carCre.getCrd_req_gu2().equals("N")){%> checked <%}%>>  ??
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri2' value='<%=carCre.getCrd_pri2()%>' size='1' class='text' ></td>          
	                    <td>&nbsp;<input type='text' name='crd_remark2' value='<%=carCre.getCrd_remark2()%>' size='100' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>????????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu3">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu3().equals("Y")){%>selected<%}%>>??</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu3().equals("N")){%>selected<%}%>>??????</option>
	                        </select>      
	                    </td>
	                       <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu3" value='Y'  <% if(carCre.getCrd_req_gu3().equals("Y")){%> checked <%}%>> ??
                  		 <input type='radio' name="crd_req_gu3" value='N'  <% if(carCre.getCrd_req_gu3().equals("N")){%> checked <%}%>>  ??
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri3' value='<%=carCre.getCrd_pri3()%>' size='1' class='text' ></td>       
	                    <td>&nbsp;<input type='text' name='crd_remark3' value='<%=carCre.getCrd_remark3()%>' size='100' class='text' ></td>
	                   
	                </tr>
	                <tr>
	                    <td class=title>??????????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu4">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu4().equals("Y")){%>selected<%}%>>??</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu4().equals("N")){%>selected<%}%>>??????</option>
	                        </select>      
	                    </td>
	                       <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu4" value='Y'  <% if(carCre.getCrd_req_gu4().equals("Y")){%> checked <%}%>> ??
                  		 <input type='radio' name="crd_req_gu4" value='N'  <% if(carCre.getCrd_req_gu4().equals("N")){%> checked <%}%>>  ??
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri4' value='<%=carCre.getCrd_pri4()%>' size='1' class='text' ></td>       
	                    <td>&nbsp;<input type='text' name='crd_remark4' value='<%=carCre.getCrd_remark4()%>' size='100' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu5">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu5().equals("Y")){%>selected<%}%>>??</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu5().equals("N")){%>selected<%}%>>??????</option>
	                        </select>      
	                    </td>
	                       <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu5" value='Y'  <% if(carCre.getCrd_req_gu5().equals("Y")){%> checked <%}%>> ??
                  		 <input type='radio' name="crd_req_gu5" value='N'  <% if(carCre.getCrd_req_gu5().equals("N")){%> checked <%}%>>  ??
                  		 </td>
                  		 <td align=center> &nbsp;<input type='text' name='crd_pri5' value='<%=carCre.getCrd_pri5()%>' size='1' class='text' ></td>       
	                    <td>&nbsp;<input type='text' name='crd_remark5' value='<%=carCre.getCrd_remark5()%>' size='100' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu6">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu6().equals("Y")){%>selected<%}%>>??</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu6().equals("N")){%>selected<%}%>>??????</option>
	                        </select>      
	                    </td>
	                       <td width=10% align=center> 
	                     <input type='radio' name="crd_req_gu6" value='Y'  <% if(carCre.getCrd_req_gu6().equals("Y")){%> checked <%}%>> ??
                  		 <input type='radio' name="crd_req_gu6" value='N'  <% if(carCre.getCrd_req_gu6().equals("N")){%> checked <%}%>>  ??
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
	                    <td class=title width=12%>??????</td>
	                    <td width=12%>&nbsp;
							  <select name='crd_id'>
				                <option value="">????</option>
				                 <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
			                   <option value='<%=user.get("USER_ID")%>' <%if(carCre.getCrd_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
			                 <%		}
							 	}%>	
				              </select>
				        </td>
	                    <td class=title width=12%>????</td>
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
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>?????? ??????&nbsp;
		         <%  if (  nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("??????????",user_id) || nm_db.getWorkAuthUser("??????????????",user_id)  || nm_db.getWorkAuthUser("??????????",user_id )||  nm_db.getWorkAuthUser("????????????????",user_id)  ){%>     
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
		                    <td class=title width=12%>????</td>
		                    <td colspan=7>&nbsp; 
								  <select name="div_st" onChange='javascript:cls_display3()'>
								    <option value="">---????---</option>
								    <option value="1" <%if(cls.getDiv_st().equals("??????")){%>selected<%}%>>??????</option>
            					    <option value="2" <%if(cls.getDiv_st().equals("????")){%>selected<%}%>>????</option>
					             
					              </select>             
					              <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                        <tr> 
  
					                            <td id='td_div' style="display:<%if( cls.getDiv_st().equals("????")){%>''<%}else{%>none<%}%>">&nbsp;????????&nbsp;  
					                             <select name="div_cnt">
												    <option value="">---????---</option>
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
			                    <td class=title width=13%>????</td>
			                    <td class=title width=12%>??????</td>
			                    <td>&nbsp;<input type='text' name='est_dt' value='<%=cls.getEst_dt()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
			                    <td class=title width=12%>????????</td>
			                    <td>&nbsp;<input type='text' name='est_amt' value='<%=AddUtil.parseDecimal(cls.getEst_amt())%>'size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
			                    <td class=title width=12%>??????</td>
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
					                      <td class=title width=13%>??????????</td>
									      <td width=12%>&nbsp;<input type='text' value='<%=cls.getGur_nm()%>' name='gur_nm' size='15' class='text'></td>
						                  <td width=12% class=title>??????</td>
						                  <td>&nbsp;<input type='text' name='gur_rel_tel' value='<%=cls.getGur_rel_tel()%>'  size='30' class='text'></td>
						                  <td width=12% class=title>??????????????</td>  
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
					                    <td class=title style='height:44' width=13%>????????/????????/????</td>
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
					                    <td class=title style='height:34' width=13%>????????</td>
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
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='????' ><%=attach_ht.get("FILE_NAME")%></a>
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
        
    
    <!-- ?????????? ???? ?????? ???? (???????? ???? ????)--> 
    <tr id=tr_refund style="display:<%if( cls.getFdft_amt2() < 0 && !cls.getCls_st().equals("????????") ){%>''<%}else{%>none<%}%>"> 
  
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
 	 	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                    <tr> 
                        <td class="title" width=13% >????????</td>
                        <td >&nbsp; <input type="text" name="re_acc_nm" value='<%=cls.getRe_acc_nm()%>' size="30" class=text></td>
                        <td width=13% class="title">??????</td>
                        <td >&nbsp; <select name="re_bank" style="width:135">
                            <option value="">==????==</option>                         
			     	 <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					    	<option value='<%=h_c_bnk.get("BCODE")%>'  <%if(cls.getRe_bank().equals((String)h_c_bnk.get("BCODE"))){%>selected<%}%>><%= h_c_bnk.get("BNAME")%></option> > 	
                     
				              <%		}
							}%>
				              </select></td>
                        <td width=13% class="title">????????</td>
                        <td >&nbsp; <input type="text" name="re_acc_no" value='<%=cls.getRe_acc_no()%>' size="30" class=text></td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="title">????????</td>
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
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='????' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>
    						<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>			                        
    						<%}%>
                        </td>
                    	<td colspan=3>&nbsp;<font color=red>?? ?????????? ????????,??????,???????? ???? ????.!!!</font><br>&nbsp;&nbsp;???????????????? ???????????? ???? ???? ?????? ??.!!!</td>
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
    
    
     <!-- ?????????? ???? ?????? ???? -->
 
   	<tr id=tr_scd_ext style="display:<%if( cls.getFdft_amt2() < 0 && !cls.getCls_st().equals("????????") ){%>''<%}else{%>none<%}%>"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>???? ??????????</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
 	 	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                 <tr>
                    <td width='5%' class='title' >????</td>					
		            <td width='14%' class='title'>????????</td>
        		    <td width='10%' class='title'>??????</td>
		            <td width="28%" class='title'>????</td>
		            <td width='10%' class='title'>????????</td>		
				    <td width='15%' class='title'>????</td>	
				    <td width='9%' class='title'>????</td>		
				    <td width='9%' class='title'>????????</td>		                	
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
	   
	    <% if (  nm_db.getWorkAuthUser("??????????",user_id)    || nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("??????????????????",user_id) || nm_db.getWorkAuthUser("??????????",user_id)|| nm_db.getWorkAuthUser("??????????????",user_id) || nm_db.getWorkAuthUser("??????????????????",user_id)  || nm_db.getWorkAuthUser("????????????????",user_id)     ){%>
	    
	     <%if(doc.getUser_dt5().equals("") && !bit.equals("????")  ){%> <!--????????-->
	         <a href="javascript:save('1');"><img src=/acar/images/center/button_hj_bill.gif align=absmiddle border=0></a>&nbsp;
	     <%} else { %>   
	     
	       <%  // if  ( !cls.getCls_st().equals("????????")  && !mode.equals("3")   && !bit.equals("????")   ) {   %>  <!--????--> 	 
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
                    <td class=title width=10% rowspan="3">????</td>
                    <td class=title colspan=3>????</td>
                    <td class=title colspan=3>????</td>
                   
        	    </tr>	
        	     <tr> 
                   
                    <td class=title width=15%>??????</td>
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
        			  <%	if(user_id2.equals(user_id) || nm_db.getWorkAuthUser("??????",user_id) ){%>
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
        			  <%	if(user_id3.equals(user_id) || nm_db.getWorkAuthUser("??????",user_id) ){%>
        		<input type="checkbox" name="rt" value="Y" >????&nbsp;<a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			 	  	  <!--?????? ???? -->
        		<% if ( doc.getUser_dt3().equals("")  &&  ( doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)  || nm_db.getWorkAuthUser("??????????",user_id)   )    ){ %>
        			   <a href="javascript:doc_id_cng('<%=doc.getDoc_no()%>','3','<%=doc.getUser_id3()%>');">[????]</a>
        		<% } %>	   
        		 
        			</td> 
        			       			
        		<% if ( cls.getCls_st().equals("????????") || cls.getCls_st().equals("??????????(????)") || cls.getCls_st().equals("??????????(??????)")   ) { %>
        		    <td align="center"></td>
        		<% } else { %>        		    
                    <td align="center"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%>
        			  <%if(!doc.getUser_dt3().equals("") && doc.getUser_dt4().equals("")){
        			  		String user_id4 = doc.getUser_id4();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id4);
        					if(!cs_bean.getWork_id().equals("")){	user_id4 = cs_bean.getWork_id(); }
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	{ user_id4 = "000126"; } //??????(000077)-> 000144
        					%>
        			  <%	if(doc.getUser_id4().equals(user_id) || user_id4.equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)  || nm_db.getWorkAuthUser("??????????",user_id)  ){%>
        			    <a href="javascript:doc_sanction('4')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			  	  <!--?????? ???? -->
        		<% if ( doc.getUser_dt4().equals("")  &&  ( doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)   )    ){ %>
        			   <a href="javascript:doc_id_cng('<%=doc.getDoc_no()%>','4','<%=doc.getUser_id4()%>');">[????]</a>
        		<% } %> 	   
        		
        			</td>	
        		<% } %>	
        			<td align="center"><%=c_db.getNameById(doc.getUser_id5(),"USER_PO")%><br><%=doc.getUser_dt5()%>      		
        			  <%if(!doc.getUser_dt3().equals("") && doc.getUser_dt5().equals("")){
        			  		String user_id5 = doc.getUser_id5();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id5);
        					if(!cs_bean.getWork_id().equals("")){	user_id5 = cs_bean.getWork_id(); }
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	{ user_id5 = "000004"; }//??????(000004)
        					        					%>
        			  <%	if(doc.getUser_id5().equals("000004") || user_id5.equals(user_id) || nm_db.getWorkAuthUser("??????",user_id) ||  doc.getUser_id5().equals("000048") ){%>
        			      
        			     <% if ( ( cls.getCls_st().equals("??????????(????)") || cls.getCls_st().equals("??????????(??????)") )  &&   fdft_amt2 == 0    ) { %>  <!-- ?????????? 0?????? ???????????? -->          			            			  
        			         <a href="javascript:clsConSanction()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>   
        			     <%  } else {%> 
        			      <a href="javascript:doc_sanction('5')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>      
        			      <% } %> 
        			        			    			    
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			  <!--?????????? ???? -->
        		<% if ( doc.getUser_dt5().equals("")  &&  ( doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)   )    ){ %>
        			   <a href="javascript:doc_id_cng('<%=doc.getDoc_no()%>','5','<%=doc.getUser_id5()%>');">[????]</a> 	   
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
			
			
	//	if ( fm.bit.value  == '????') {		   
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
			
	//??????????
	function set_tax_init(){
		var fm = document.form1;
	
		 //?????????? ????
		if(toInt(parseDigit(fm.rifee_s_amt.value)) > 0){
				fm.tax_r_supply[0].value 	= "-"+fm.rifee_s_amt.value;
				
				if ( fm.cls_st.value == '7' ||  fm.cls_st.value == '10' ) {  //?????????? ???? ?????????? 
					fm.tax_r_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.ifee_amt.value))  -  toInt(parseDigit(fm.rifee_s_amt.value)) );
				} else {	
					fm.tax_r_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) * 0.1 );
				}
								
				fm.tax_r_hap[0].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[0].value)) + toInt(parseDigit(fm.tax_r_value[0].value)) );
				fm.tax_rr_supply[0].value 	= "-"+fm.rifee_s_amt.value;
				
				if ( fm.cls_st.value == '7' ||  fm.cls_st.value == '10' ) {  //?????????? ???? ?????????? 
					fm.tax_rr_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.ifee_amt.value))  -  toInt(parseDigit(fm.rifee_s_amt.value)) );
				} else {	
					fm.tax_rr_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) * 0.1 );
				}
				
				fm.tax_rr_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) * 0.1 );
				fm.tax_rr_hap[0].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[0].value)) + toInt(parseDigit(fm.tax_rr_value[0].value)) );
				fm.tax_r_g[0].value       = "???? ?????????? ????";
				fm.tax_r_bigo[0].value    = fm.car_no.value+" ????";
				fm.tax_r_chk0.checked   	= true;
				fm.rifee_amt_2_v.value = fm.tax_rr_value[0].value 
						
		}
		//?????? ????
		if(toInt(parseDigit(fm.rfee_s_amt.value)) > 0){
				fm.tax_r_supply[1].value 	= "-"+fm.rfee_s_amt.value;
				if ( fm.cls_st.value == '7' ||  fm.cls_st.value == '10' ) {  //?????????? ???? ?????????? 
					fm.tax_r_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.pp_amt.value))  -  toInt(parseDigit(fm.rfee_s_amt.value)) );
				} else {	
					fm.tax_r_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) * 0.1 );
				}
				
			//	fm.tax_r_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) * 0.1 );
				fm.tax_r_hap[1].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[1].value)) + toInt(parseDigit(fm.tax_r_value[1].value)) );
				fm.tax_rr_supply[1].value 	= "-"+fm.rfee_s_amt.value;
				if ( fm.cls_st.value == '7' ||  fm.cls_st.value == '10' ) {  //?????????? ???? ?????????? 
					fm.tax_rr_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.pp_amt.value))  -  toInt(parseDigit(fm.rfee_s_amt.value)) );
				} else {	
					fm.tax_rr_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) * 0.1 );
				}
				
			//	fm.tax_rr_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) * 0.1 );
				fm.tax_rr_hap[1].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[1].value)) + toInt(parseDigit(fm.tax_rr_value[1].value)) );
				fm.tax_r_g[1].value       = "???? ?????? ????";
				fm.tax_r_bigo[1].value    = fm.car_no.value+" ????";
				fm.tax_r_chk1.checked   	= true;
				fm.rfee_amt_2_v.value = fm.tax_rr_value[1].value 	
		}
					
		// ?????????? ???? ?????? ???? check ????	
		if (toInt(fm.fdft_amt2.value) < 1 ) {  //????????
		
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
					fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );  //??????????????
			} 
					
			
		   if  ( fm.jung_st_chk.value != "" ) {
				
				if  (  fm.jung_st[1].checked == true)  {  //???????? ??????
			      
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
		 	
		 	// ???? 
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
				
				if  (  fm.jung_st[1].checked == true)  {  //???????? ??????
				} else {	
			
					//?????? ?????? ???????? (?????????? ?????????? ????)
					if ( toInt(parseDigit(fm.no_v_amt_1.value)) != no_v_amt) {			
						no_v_d_amt = toInt(parseDigit(fm.no_v_amt_1.value)) - no_v_amt ;
						fm.dfee_amt_2_v.value = parseDecimal( (toInt(parseDigit(fm.dfee_amt_2.value)) * 0.1 ) + no_v_d_amt ) ;
						no_v_amt =   toInt(parseDigit(fm.dfee_amt_2_v.value)) + toInt(parseDigit(fm.tax_r_value[0].value))+ toInt(parseDigit(fm.tax_r_value[1].value))+ toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value))  + toInt(parseDigit(fm.over_amt_2_v.value))  ;	
					}
				}		
			}
				
			fm.no_v_amt_2.value =  parseDecimal( no_v_amt );
			fm.no_v_amt_3.value =  parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value))  -    toInt(parseDigit(fm.no_v_amt_2.value)) ) ;	
						
			fm.fdft_amt1_2.value 	= parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) + toInt(parseDigit(fm.dly_amt_2.value))+ toInt(parseDigit(fm.dft_amt_2.value)) + toInt(parseDigit(fm.car_ja_amt_2.value)) + toInt(parseDigit(fm.fine_amt_2.value)) + toInt(parseDigit(fm.etc_amt_2.value)) + toInt(parseDigit(fm.etc2_amt_2.value)) + toInt(parseDigit(fm.etc3_amt_2.value)) + toInt(parseDigit(fm.etc4_amt_2.value)) + toInt(parseDigit(fm.over_amt_2.value))  + toInt(parseDigit(fm.no_v_amt_2.value)) );	 //????????	
			fm.fdft_amt1_3.value  = parseDecimal( toInt(parseDigit(fm.fdft_amt1_1.value))  -    toInt(parseDigit(fm.fdft_amt1_2.value)) ) ;		
				
			//???????? ????		
			if ( fm.cls_st.value == '8' ) {
				  if  (toInt(parseDigit(fm.m_dae_amt.value))+ toInt(parseDigit(fm.opt_ip_amt1.value))+ toInt(parseDigit(fm.opt_ip_amt2.value)) - toInt(parseDigit(fm.opt_amt.value)) > 0 ) {
  						fm.ext_amt.value 	= parseDecimal( toInt(parseDigit(fm.m_dae_amt.value))+ toInt(parseDigit(fm.opt_ip_amt1.value))+ toInt(parseDigit(fm.opt_ip_amt1.value)) - toInt(parseDigit(fm.opt_amt.value))  );				        	  	
				  }
			}		  					
		
			fm.fdft_j_amt.value = parseDecimal( toInt(parseDigit(fm.c_amt.value))  +  toInt(parseDigit(fm.ex_ip_amt.value))  - toInt(parseDigit(fm.fdft_amt1_2.value)));
			
			
		}
		
		// ?????? ???????????? ?????????? ?????? ???? - ?????????????? ?????? ?? ?????? ????
		if ( toInt(fm.dfee_amt_1.value) < 1 && toInt(fm.fdft_amt2.value) > 0 )  {  //????????
			fm.dfee_amt_2.value = fm.dfee_amt_1.value;
			fm.dfee_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) * 0.1 );		
		}	
				
		//?????? ???????????? ???? ????
		if (toInt(fm.re_day.value) > 0 ) {
			
			// ?????????? ???? 	- ???????????????????? cls_etc_detail?? 
			if ( fm.cls_st.value == '8' ) {
			    if (  toInt(parseDigit(fm.dfee_amt.value)) ==  toInt(parseDigit(fm.tfee_s_amt.value)) ) {
			    
			    } else { //??????????
			    	if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value))) { //????????		
				
						if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
				        		if ( fm.dly_s_dt.value == '99999999' ) {
						 		//	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
						  		//	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );				    	
						        } else {  //???????? ?????? ???????????? ????...						        							        						        	
						        //	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) *  toInt(fm.nfee_day.value)/30  );  //nfee_day ????				        	  	
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
					
			} else { //?????????? ??????
			
			   				
			    //?????? ???? ????
				if(toInt(parseDigit(fm.nfee_amt_1.value)) > 0){
				   
						fm.tax_r_supply[2].value 	= "-"+parseDecimal( toInt(parseDigit(fm.tfee_s_amt.value)));
						fm.tax_r_value[2].value 	= "-"+parseDecimal( toInt(parseDigit(fm.tfee_v_amt.value)));					
					 				
						fm.tax_r_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) + toInt(parseDigit(fm.tax_r_value[2].value)) );
					
						fm.tax_rr_supply[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value))); 
						fm.tax_rr_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[2].value))); 
						fm.tax_rr_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[2].value)) + toInt(parseDigit(fm.tax_rr_value[2].value)) );
							
						fm.tax_r_g[2].value       = "???? ???? ??????";
							
						fm.tax_r_bigo[2].value    = fm.car_no.value+" ????";
						fm.tax_r_chk2.checked   	= true;						
					
							  		       
			  		     //?????? ?????????? ???????? ???????? ?????? ???? - 20100928 		  
			       		fm.tax_r_supply[3].value 	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.u_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.u_day.value)) );			       	    	 		
			       		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );
			       		   
			  		       												
						fm.tax_r_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) + toInt(parseDigit(fm.tax_r_value[3].value)) );
					
						fm.tax_rr_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value))); 
						fm.tax_rr_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[3].value))); 
						fm.tax_rr_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) + toInt(parseDigit(fm.tax_rr_value[3].value)) );
								
						fm.tax_r_g[3].value       = "???? ??????";
					
						fm.tax_r_bigo[3].value    = fm.car_no.value+" ????";
						fm.tax_r_chk3.checked   	= true;					
						
				
				} else {
					//	alert(toInt(parseDigit(fm.ex_di_amt_1.value)));
				    	if(toInt(parseDigit(fm.ex_di_amt_1.value)) < 0 ){  //?????? ???? - ???? ???? ??????????
								fm.tax_r_supply[2].value 	= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)));
								fm.tax_r_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) * 0.1 );	
															     				
								fm.tax_r_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) + toInt(parseDigit(fm.tax_r_value[2].value)) );
							
								fm.tax_rr_supply[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value))); 
								fm.tax_rr_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[2].value))); 
								fm.tax_rr_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[2].value)) + toInt(parseDigit(fm.tax_rr_value[2].value)) );
									
								fm.tax_r_g[2].value       = "???? ???? ??????";
									
								fm.tax_r_bigo[2].value    = fm.car_no.value+" ????";
								fm.tax_r_chk2.checked   	= true;
					    } else {
								
								// ?????????? ???? ???? - ???????? ?????? ???????? ???????? ????	
								fm.tax_r_supply[2].value 	= "-"+parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.re_day.value)/30))   );
								fm.tax_r_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) * 0.1 );	
																								 				
								fm.tax_r_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value)) + toInt(parseDigit(fm.tax_r_value[2].value)) );
							
								fm.tax_rr_supply[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[2].value))); 
								fm.tax_rr_value[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[2].value))); 
								fm.tax_rr_hap[2].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[2].value)) + toInt(parseDigit(fm.tax_rr_value[2].value)) );
									
								fm.tax_r_g[2].value       = "???? ???? ??????";
									
								fm.tax_r_bigo[2].value    = fm.car_no.value+" ????";
								fm.tax_r_chk2.checked   	= true;
						}					
				}				
				
			}	
		
		}
							
		//??????????  -- ???????????? ???????? ???? ???????? ??????????? - ???????????? ???? ?????? ???????????? ???????? ???? ???? ????. -20100524
		if(toInt(parseDigit(fm.nfee_amt_1.value)) >= 0){
		
		           //???????????? ?????? ?? ???? 	
		      if (toInt(fm.re_day.value) < 0 ) {
		     		 
		     			// ?????????? ???? 	
				if ( fm.cls_st.value == '8' ) {
				       //?????????? ???????????????? ???????????? ???????? ????.
				     if (   toInt(fm.old_opt_amt.value)  > 0 ) {  //?????????????? ????
				     		//	fm.tax_r_supply[3].value 	=  parseDecimal( toInt(parseDigit(fm.t_r_fee_s_amt.value))  );				        	  	
						  	//	fm.tax_r_value[3].value 	=  parseDecimal( toInt(parseDigit(fm.t_r_fee_v_amt.value))  );		
						  		fm.tax_r_supply[3].value 	=  parseDecimal( toInt(parseDigit(fm.ts_r_fee_amt.value))  );				        	  	
						  		fm.tax_r_value[3].value 	=  parseDecimal( toInt(parseDigit(fm.tv_r_fee_amt.value))  );		
						  				        	  					     
				     } else {	      
				       				       
							  if (toInt(fm.re_day.value) * (-1) < 31 ) {
							      	 if ( toInt(fm.rent_end_dt.value) >=  toInt(replaceString("-","",fm.cls_dt.value)) ) {
							     	 		
								     		fm.tax_r_supply[3].value = fm.nnfee_s_amt.value;
											fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );		
									//	alert(fm.tax_r_supply[3].value );	
												      	
							     	 }  else {	
									fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.re_day.value)* (-1)/30) );				        	  	
						  			fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
						  		}							
							  } else {
							       
							 		 if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
							 		
					        					if ( fm.dly_s_dt.value == '99999999' ) {  //???????????? ???????? ??
							 					fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
							  					fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							  			}	
								  	 } else {  //????????
								  	
									  		    //???????????? ???????? ???? ?????? ?????????? ???????? ??????????)
									  		    if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {						  		  
									  		    	fm.tax_r_supply[3].value = fm.nnfee_s_amt.value;
									  		      	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );
									  						  					        	  	
									  		    } else {
									  			 	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
							    				 		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );
									  		    }
							  		 
							  		 }			  
							  }  //31?? ??						  
	     		      }
	     		      
		     		} else {	//?????????? ?????? 
		     			     
					    if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
								  		
				        		        if ( fm.dly_s_dt.value == '99999999' ) { //?????? ????.
				        		
						 			fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
						  			fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );				    	
						        } else { //?????????? ?????? ???? ????
						          
							            if (toInt(fm.re_day.value) * (-1) < 31 ) {
											fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.re_day.value)* (-1)/30) );				        	  	
							  				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							  				
							  	   } else {
							  			 	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
							  			 //	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) *  toInt(fm.nfee_day.value)/30  );  //nfee_day ????				        	  	
							    			fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							    	  }						    
						        }
				        	   } else {	// t_mon, t_day ?? ???? ????
				          
				        	  //???????????? ???????? ???? ?????? ?????????? ???????? ??????????) --???????????? ???? nnfee_s_amt ?????? 0???? ?????? ????
						   if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {		
						   
						   		if ( toInt(fm.nnfee_s_amt.value) == 0 )  { //?????? ?????? ???? ?????? ?????? ????????
						   			fm.tax_r_supply[3].value = parseDecimal(fm.lfee_s_amt.value);
					    				fm.tax_r_value[3].value = parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
						   		} else {
						   		    if ( toInt(fm.dly_s_dt.value) <= toInt(fm.tuse_s_dt.value) ) {		
						   		    	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
					    				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );					
						   		     } else {
							   		fm.tax_r_supply[3].value = fm.nnfee_s_amt.value;
							        		fm.tax_r_value[3].value  = parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );
							       	    }		 
						                  }	 
						      
					        	      } else {  //???? ?????? 
					        	  	
						        		fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
							    	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );					    		
						      }
					    	    		    		
					   }
					    	
					    	//???????????? ?????? ?????? ???? 
					   if (toInt(fm.ifee_s_amt.value) != 0 ) {
					    	     
					    		if ( toInt(fm.rifee_s_amt.value) > 0 )  { //?????? ???????? ????
						     			fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
						    			fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );							    	
							 } else { //?????? ?? ???????? ???????? ?????? ????
							    	  if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //???????? ?????? ???????? ?????? ????  - ?????????? ???????? ?????? ????	
							    		 if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
								    		   if ( fm.dly_s_dt.value == '99999999' ) { //???????? ?????? ?????? ?????? ????
						        						fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
								  				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );				    	
								      		   } else {
								      		    	 if (toInt(fm.re_day.value) * (-1) < 31 ) {
													fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.re_day.value)* (-1)/30) );				        	  	
									  				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
									  		 }						      		   
								      		   }
							      		   	
							      		 } else {   //t_mon, t_day ?? 0?? ???? ????
							    		
							    			fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
							    	 	 //	fm.tax_r_supply[3].value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.t_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.t_day.value)) );
						     				fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							    	  	 }
							    	  } else { //???????? ?????? ?????????? ???? - ?????????? ?? ???????????????? ?????? ???????? ???? ????
							    	 	    				    	  
							    	   		fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.t_mon.value)+toInt(fm.t_day.value)/30) );				        	  	
							    	   		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
							    	   		
								    	//	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
								    	//	fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
								    	
							    	  } 
							    	
							} //????       	
								
					    }   //??????????  
					
			      }   //???????? ??			
				 					
			  }   // re_day < 0
			  				
			  //???? ?????		
			  if ( toInt(fm.re_day.value) ==  0  &&  toInt(fm.fee_tm.value) ==  999) {
			  		if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
					      	fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
					  		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
					}  	
					
					//???????????? ???? ????
					if (toInt(fm.ifee_s_amt.value) != 0 ) {    	
				    		if ( toInt(fm.rifee_s_amt.value) > 0 )  { //?????? ???????? ????				    	
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
							
				  fm.tax_r_g[3].value       = "???? ??????";
					
				  fm.tax_r_bigo[3].value    = fm.car_no.value+" ????";
				  fm.tax_r_chk3.checked   	= true;
			  }				
				
				//?????????????? ?????? ??????????  				
			   if (   fm.match.value == 'Y' ) {
			     fm.tax_r_chk3.checked   	= false;			   			   
			   }	
							
		}//??????????					
		
		//??????  -- ???????????? ???????? ???? ???????? ???????????
		if(toInt(parseDigit(fm.ex_di_amt_1.value)) < 0){
		     		     
		     
		           //???????????? ?????? ?? ???? 	
		        if (toInt(fm.re_day.value) < 0 ) {
		        				        		
	        		 if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //???????? ?????? ???????? ?????? ????  - ?????????? ???????? ?????? ????	
				    		 if ( (toInt(fm.t_mon.value) == 0) && (toInt(fm.t_day.value) == 0) ) {
					    		   if ( fm.dly_s_dt.value == '99999999' ) { //???????? ?????? ?????? ?????? ????
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
				    	  	 
				    	//  } else { //???????? ?????? ?????????? ????
				    	//		fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );				        	  	
				    	//		fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
				      } 	
					  						  			 
		                  //?????? - ??????
		        //	  fm.tax_r_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) + toInt(parseDigit(fm.ex_di_amt_1.value))   );
		        //	  fm.tax_r_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) * 0.1 );	
		        		
		           	  fm.tax_r_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value)) + toInt(parseDigit(fm.tax_r_value[3].value)) );
				
					  fm.tax_rr_supply[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[3].value))); 
					  fm.tax_rr_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_value[3].value))); 
				  	  fm.tax_rr_hap[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) + toInt(parseDigit(fm.tax_rr_value[3].value)) );
								
					  fm.tax_r_g[3].value       = "???? ??????";
					
					  fm.tax_r_bigo[3].value    = fm.car_no.value+" ????";
				  	  fm.tax_r_chk3.checked   	= true;
		        
				}
				
		}		
		
		//?????????????? - ???????? ?????????????? ?????????????? ???? ?????? ?????? ???? ????  - 
		if ( fm.cls_st.value == '8' ) {
			if ( toInt(parseDigit(fm.ts_r_fee_amt.value))  > 0  ) {
				 fm.tax_r_chk3.checked   	= false;
			}		    	
		}
					
		//??????????????
		if(fm.tax_chk0.checked == true ){
				fm.tax_r_supply[4].value 	= fm.dft_amt_1.value;
				fm.tax_r_value[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[4].value)) * 0.1 );	
			
				fm.tax_r_hap[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[4].value)) + toInt(parseDigit(fm.tax_r_value[4].value)) );
				
				fm.tax_rr_supply[4].value 	= fm.dft_amt_1.value;
				fm.tax_rr_value[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[4].value)) * 0.1 );	
				fm.tax_rr_hap[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[4].value)) + toInt(parseDigit(fm.tax_rr_value[4].value)) );
				
				fm.tax_r_g[4].value       = "???? ??????";
				fm.tax_r_bigo[4].value    = fm.car_no.value+" ????";
				fm.tax_r_chk4.checked   	= true;
				
		}
		//????????????
		if(fm.tax_chk1.checked == true ){
				fm.tax_r_supply[5].value 	= fm.etc_amt_1.value;
				fm.tax_r_value[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[5].value)) * 0.1 );	
				fm.tax_r_hap[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[5].value)) + toInt(parseDigit(fm.tax_r_value[5].value)) );		
				fm.tax_rr_supply[5].value 	= fm.etc_amt_1.value;
				fm.tax_rr_value[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[5].value)) * 0.1 );	
				fm.tax_rr_hap[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[5].value)) + toInt(parseDigit(fm.tax_rr_value[5].value)) );			
				fm.tax_r_g[5].value       = "???? ????????????";
				fm.tax_r_bigo[5].value    = fm.car_no.value+" ????";
				fm.tax_r_chk5.checked   	= true;
			

		}
			//????????????
		if(fm.tax_chk2.checked== true ){
				fm.tax_r_supply[6].value 	= fm.etc2_amt_1.value;
				fm.tax_r_value[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[6].value)) * 0.1 );	
				fm.tax_r_hap[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[6].value)) + toInt(parseDigit(fm.tax_r_value[6].value)) );		
				fm.tax_rr_supply[6].value 	= fm.etc2_amt_1.value;
				fm.tax_rr_value[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[6].value)) * 0.1 );	
				fm.tax_rr_hap[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[6].value)) + toInt(parseDigit(fm.tax_rr_value[6].value)) );			
				fm.tax_r_g[6].value       = "???? ????????????";
				fm.tax_r_bigo[6].value    = fm.car_no.value+" ????";
				fm.tax_r_chk6.checked   	= true;
			

		}
			//??????????????(??????)
		if(fm.tax_chk3.checked == true ){
				fm.tax_r_supply[7].value 	= fm.etc4_amt_1.value;
				fm.tax_r_value[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[7].value)) * 0.1 );	
				fm.tax_r_hap[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[7].value)) + toInt(parseDigit(fm.tax_r_value[7].value)) );	
				fm.tax_rr_supply[7].value 	= fm.etc4_amt_1.value;
				fm.tax_rr_value[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[7].value)) * 0.1 );	
				fm.tax_rr_hap[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[7].value)) + toInt(parseDigit(fm.tax_rr_value[7].value)) );		
				fm.tax_r_g[7].value       = "???? ??????????";
					
				fm.tax_r_bigo[7].value    = fm.car_no.value+" ????";
				fm.tax_r_chk7.checked   	= true;
				
		}	
		
		
			//??????????????
		if(fm.tax_chk4.checked == true ){	
//		if(toInt(parseDigit(fm.over_amt_1.value)) > 0){
				fm.tax_r_supply[8].value 	= fm.over_amt.value;
				fm.tax_r_value[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[8].value)) * 0.1 );	
				fm.tax_r_hap[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_r_supply[8].value)) + toInt(parseDigit(fm.tax_r_value[8].value)) );	
				fm.tax_rr_supply[8].value 	= fm.over_amt_1.value;
				fm.tax_rr_value[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[8].value)) * 0.1 );	
				fm.tax_rr_hap[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[8].value)) + toInt(parseDigit(fm.tax_rr_value[8].value)) );		
				fm.tax_r_g[8].value       = "???? ??????????????????";
					
				fm.tax_r_bigo[8].value    = fm.car_no.value+" ????";
				fm.tax_r_chk8.checked   	= true;
								
		}									
		
	}	
		
	
//??????????
function set_tax_init1(){
	var fm = document.form1;              
     
	  //?????????? ????
	if(toInt(parseDigit(fm.rifee_s_amt.value)) > 0){
			fm.tax_r_bigo[0].value    = fm.car_no.value+" ????";	
	}
	
	//?????? ????
	if(toInt(parseDigit(fm.rfee_s_amt.value)) > 0){
			fm.tax_r_bigo[1].value    = fm.car_no.value+" ????";			
	}
	
		//??????????  
	//???????????? ?????? ????
	if (toInt(fm.re_day.value) > 0 ) {
	  //?????? ???? ????
	    if (fm.cls_st.value != '8' ) { //?????????? ??????		 
			if(toInt(parseDigit(fm.nfee_amt_1.value)) > 0){ 
				fm.tax_r_bigo[2].value    = fm.car_no.value+" ????";
				fm.tax_r_bigo[3].value    = fm.car_no.value+" ????";	
			} else {
				fm.tax_r_bigo[2].value    = fm.car_no.value+" ????";
			}
		}	
	}
	
	
	//?????????? ???????? ????????  ---  
	if(toInt(parseDigit(fm.ex_di_amt_1.value)) < 0 ){
		 if (toInt(fm.nfee_amt_1.value) < 1 ) {
		 	fm.tax_r_bigo[2].value    = fm.car_no.value+" ????";
		 }
	} 
	
	//??????????  
	if(toInt(parseDigit(fm.nfee_amt_1.value)) > 0){
	     //???????????? ?????? ?? ????
	    if (toInt(fm.re_day.value) < 0 ) {
			fm.tax_r_bigo[3].value    = fm.car_no.value+" ????";	
		}		
	}
	
	//??????????????
	if(fm.tax_chk0.checked == true ){
			fm.tax_r_bigo[4].value    = fm.car_no.value+" ????";		
	}
	
	//????????????
	if(fm.tax_chk1.checked == true ){
			fm.tax_r_bigo[5].value    = fm.car_no.value+" ????";
	}
	
		//????????????
	if(fm.tax_chk2.checked== true ){
			fm.tax_r_bigo[6].value    = fm.car_no.value+" ????";
	}
		//??????????????(??????)
	if(fm.tax_chk3.checked == true ){		
			fm.tax_r_bigo[7].value    = fm.car_no.value+" ????";		
	}
			
		//?????????????? - 20160803 ???? - ?????? ?????? ?????? ???? 
	if(fm.tax_chk4.checked == true ){			
		fm.tax_r_bigo[8].value    = fm.car_no.value+" ????";		
	}
		
//    fm.fdft_j_amt.value = parseDecimal( toInt(parseDigit(fm.c_amt.value))  +  toInt(parseDigit(fm.ex_ip_amt.value))  - toInt(parseDigit(fm.fdft_amt1_2.value)));		
	  
}

</script>
</body>
</html>
