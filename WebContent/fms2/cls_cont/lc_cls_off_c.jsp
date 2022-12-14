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
	EstiDatabase e_db = EstiDatabase.getInstance();   //???????????????? ???? ???????????? 
		
	//????????????
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//????????????
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. ???? ---------------------------
	
	//????????
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//????????
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//???????????? - ???????? 
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	
	//??????????????
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//????????????
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//????????????
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//???????????? ??????
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//3. ????-----------------------------
	
	//??????????????(????????)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	int fee_size_1 = fee_size - 1;  //fee-size???? ?????? 
    int fee_size_1_opt_amt = 0;
    String fee_size_1_end_dt= "";
   
	//????????????
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));	

	//fee ???? - ???????? ?????? ????
//	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd,"1"); //?????????????? 
	
	int  o_amt =   car1.getOver_run_amt();
	 	 
	String  agree_yn = car1.getAgree_dist_yn();
	 
	  // agree_dist_yn  1:????????,  2:50% ????,  3:100%????  : ?????????? ?????? ???? ???? 20130604  ????????- 2016?? ???? ????.
	 	
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//?????? ??????
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//?????? ??????
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
	
	//????????
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, "", "");
	
	//????????????
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd,  Integer.toString(fee_size));
	
	//?????????? 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	
	
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
	String s_opt_end_dt = "";
			
		//??????-????????
	CodeBean[] banks = neoe_db.getCodeAll();
	int bank_size = banks.length;
	
	int pp_amt = AddUtil.parseInt((String)base1.get("PP_S_AMT"));
	
		//?????? ???????? ???? ???????? ???? ????
	int car_ja_no_amt =  ac_db.getCarServiceBillNo(rent_mng_id, rent_l_cd);
	
		//cms ????
	Hashtable h_cms = c_db.getCmsBank_info(rent_l_cd);
		
	//?????? ???????????? ????
	int reg_cnt = 0;
	reg_cnt= ac_db.getClsEtcCnt(rent_mng_id, rent_l_cd);
	
	//???????? ????????
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id(), "N" );		
//	out.println(fuel_cnt);
 	
	Hashtable  return1 =   new Hashtable();
	
   int  return_amt = 0;
	String return_remark = "";
	
	// ???? &  ?????? - ?????????? ???? 
   if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id() , "N");
	  	return_amt = Integer.parseInt(String.valueOf(return1.get("AMT")));
	  	return_remark = (String)return1.get("REMARK");
   }
  	
   //car_price 
   int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  - car.getDc_cs_amt() - car.getDc_cv_amt(); 
//	int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  ; 
   float f_opt_per = 0;
		
		//?????????????? ???? ???????? ???? ???????? - 20161024
    String a_a = "2";	//????
	if(base.getCar_st().equals("3")) a_a = "1"; //????
		
	String a_j = "";
	if ( fee_size > 1  ) {  //???????? 
		a_j = e_db.getVar_b_dt("em", ext_fee.getRent_start_dt());   //   ???????????? ???? (?????????? ??????????)                
	 } else {
	 	a_j = e_db.getVar_b_dt("em", base.getRent_dt());   //   ???????????? ???? (?????????? ??????????)
	} 
		
    em_bean = e_db.getEstiCommVarCase(a_a, "", a_j);

//???????????? ???????? tax_amt, ????: insure_amt, ?????? ????: serv_amt ?????? 
	Hashtable sale = ac_db.getVarAmt(rent_mng_id, rent_l_cd);
   
  	int e_tax_amt = AddUtil.parseInt((String)sale.get("TAX_AMT"));
  	int e_insur_amt = AddUtil.parseInt((String)sale.get("INSUR_AMT"));
  	int e_serv_amt = AddUtil.parseInt((String)sale.get("SERV_AMT")); 
   
   //?????????? ?????????????? ???? - 20191114???? 
    float f_grt_amt = 0;
   
   if ( em_bean.getA_f_2() > 0 ) {
	   f_grt_amt = AddUtil.parseFloat((String)base1.get("GRT_AMT") ) *  em_bean.getA_f_2()/100 /12 ;
   } else {
	   f_grt_amt = AddUtil.parseFloat((String)base1.get("GRT_AMT") ) *  em_bean.getA_f()/100 /12 ;
   }
   
 //   f_grt_amt = AddUtil.parseFloat((String)base1.get("GRT_AMT") ) *  em_bean.getA_f()/100 /12 ;
  
    int  e_grt_amt =  (int)  f_grt_amt ;
         	 	
  	int vt_size8 = 0;
		
	Vector vts8 = ac_db.getScdFeeList(rent_mng_id,  rent_l_cd);
	vt_size8 = vts8.size(); 	
	
	int t_fee_s_amt = 0;
	
	//???????????? ?????? (function ???????? ) 	
	String r_ymd[] = new String[3]; 
	String rcon_mon = "";
	String rcon_day  = "";
	
	//20200625????  - r_ymd ????
	String rr_ymd =  String.valueOf(base1.get("R2_YMD"));
	
    StringTokenizer token1 = new StringTokenizer(rr_ymd,"^");				
	while(token1.hasMoreTokens()) {			
			r_ymd[0] = token1.nextToken().trim();	//??
			r_ymd[1] = token1.nextToken().trim();	//?? 
			r_ymd[2] = token1.nextToken().trim();	//?? 
	}	
		
	//???????? ???????? ?????? ????	 
	if  (AddUtil.parseInt(r_ymd[0]) < 0 ||  AddUtil.parseInt(r_ymd[1]) < 0 || AddUtil.parseInt(r_ymd[2]) < 0 ) {		
	   rcon_mon =  "";
 	   rcon_day =  "";
	} else {
	   rcon_mon =  Integer.toString( AddUtil.parseInt(r_ymd[0])*12  + AddUtil.parseInt(r_ymd[1]));
	   rcon_day =   Integer.toString(  AddUtil.parseInt(r_ymd[2])) ;  	
    } 
	
	 int tot_dist_cnt = 0;      	 
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
<!--
	
	//???????? ????
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
		
	//?????? ????
	function car_search()
	{
		var fm = document.form1;
		window.open("search_ext_car.jsp", "EXT_CAR", "left=100, top=100, width=600, height=500, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}
	
	function view_tel(m_id,l_cd)
	{
		window.open("/fms2/consignment_new/cons_tel_list_s.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_TEL", "left=100, top=100, width=820, height=600, scrollbars=yes");
	}
	
	//????/???? ????
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			

	//?????????????? ????
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//????????
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
		//?????????? ???????? ????????
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('????', '');
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
				
		if(fm.cls_st.value == '')				{ alert('?????????? ????????????'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('?????????? ????????????'); 		fm.cls_dt.focus(); 		return;	}
		
		//?????? ???? 2???? ?????? ???? ???? 		
		var s_str = fm.today_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1, s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1 , e_str.substring(8,10) );
		
		var diff_date = e_date.getTime() - s_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
		
		if ( count > 61 ) { 
			alert("???????? ?????????? 2???????? ?????? ?????? ?? ????????.!!!"); 	
		    return;
		}	
		
		if(fm.cls_msg.value != '')				{ alert('?????? ?????????? ???????? ??????????.'); 		fm.cls_dt.focus(); 		return;	}
			
		if( toInt(parseDigit(fm.reg_cnt.value)) > 0 ) { 	 alert('???? ?????? ????????. ????????????!!'); 	fm.cls_st.focus(); 		return;	}	
		
	
	 	if ( fm.tot_dist_cnt.value == '0' ) {	 			   alert("???????????? ???? ?? ???????? ??????????.!!!");					   return;		}			
				 
	    if( toInt(parseDigit(fm.tot_dist.value)) < 1 ) {
	    	 alert('?????????? ????????????'); 	
	    	 	fm.tot_dist.focus(); 
	    		fm.cls_st.value="";	
	    		fm.opt_amt.value=fm.mopt_amt.value;	
	    		cal_rc_rest_clear();
	    	 	return;
	    }	
			
		if( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ){
		
			if(fm.est_dt.value == '')				{ alert('?????????? ????????????'); 		fm.est_dt.focus(); 		return;	}		
		}
		
		//???????? ???? ???? ???? ???? - ?????? check			
		if( toInt(parseDigit(fm.opt_amt.value)) == 0 ){ alert('?????????????? ????????????'); 		fm.cls_st.focus(); 	return;	}
	 			
		if( toInt(parseDigit(fm.ex_ip_amt.value)) > 0 ){
			//????????		
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;
			var deposit_split = deposit_no.split(":");
			fm.deposit_no2.value = deposit_split[0];			
		
			if(fm.bank_code.value == ""){ alert("?????? ????????????."); return; }			
			if(fm.deposit_no.value == ""){ alert("?????????? ????????????."); return; }		
		}	
		
		//?????????????? ???? ???? ??
		 if ( fm.mt.value !='1') {
				 
				//?????? ?? ???????? ???????? ?????? ?????? ???? ???? ???? check
			if (  fm.dly_amt.value != fm.dly_amt_1.value ) {
			    if( get_length(Space_All(fm.dly_reason.value)) == 0  ) {
					alert("?????? ?????????? ?????????? ??????.!!");
					return;
				}	
				
				if( fm.dly_saction_id.value == '' ) {
					alert("?????????? ???????? ?????????? ??????.!!");
					return;
				}	
				
				if( fm.dly_saction_id.value != '000004' ) {
					alert("?????????? ???????? ?????? ???????? ?????????? ??????. ?????? ????????????.!!");
					return;
				}				
			}
		 }
		
		//????????????!!! ???????? - ???????????? 
		if ( toInt(parseDigit(fm.gi_amt.value)) -  toInt(parseDigit(fm.fdft_amt2.value))  < 0 ){
					
			 if( replaceString(' ', '',fm.remark.value) == '' && replaceString(' ', '', fm.crd_remark1.value)  == '' && replaceString(' ', '', fm.crd_remark2.value) == '' && replaceString(' ', '', fm.crd_remark3.value) == '' && replaceString(' ', '', fm.crd_remark4.value) == '' && replaceString(' ', '',fm.crd_remark5.value) == '' && replaceString(' ', '', fm.crd_remark6.value) == '' ){
				alert("???????? ???????? ???? ?????? ???????? ?????????? ??????.!!");
				return;
			 }	
			 
			  if( get_length(Space_All(fm.remark.value)) == 0 && get_length(Space_All(fm.crd_remark1.value))  == 0 && get_length(Space_All(fm.crd_remark2.value))  == 0 && get_length(Space_All(fm.crd_remark3.value))  == 0 && get_length(Space_All(fm.crd_remark4.value))  == 0 && get_length(Space_All(fm.crd_remark5.value))  == 0 && get_length(Space_All(fm.crd_remark6.value))  == 0 ){
				alert("???????? ???????? ???? ?????? ???????? ?????????? ??????.!!");
				return;
			 }			     		 
			 		 
		}
		
			//??????????????
		if ( toInt(parseDigit(fm.dft_amt_1.value))  < 1 ) {
			if ( fm.tax_chk0.checked == true) {
				alert("???????? ???????? ??????????. ???????????????? ?? ?? ????????..!!");
				return;
			 }	
		}
				
		if ( toInt(parseDigit(fm.etc_amt_1.value))  < 1 ) {
			if ( fm.tax_chk1.checked == true) {
				alert("?????????????????? ??????????. ???????????????? ?? ?? ????????..!!");
				return;
			 }	
		}	
	
		if ( toInt(parseDigit(fm.etc2_amt_1.value))  < 1 ) {
			if ( fm.tax_chk2.checked == true) {
				alert("?????????????????? ??????????. ???????????????? ?? ?? ????????..!!");
				return;
			 }	
		}				
	 
		if ( toInt(parseDigit(fm.etc4_amt_1.value))  < 1 ) {
			if ( fm.tax_chk3.checked == true) {
				alert("???????????????? ??????????. ???????????????? ?? ?? ????????..!!");
				return;
			 }	
		}	
			
		if ( fm.des_zip.value == '' || fm.des_addr.value == '' || fm.des_nm.value == '' || fm.des_tel.value == ''   ) { 
			alert("????????????, ??????, ???????? ????????????");
			return;
		}		
			
	  	if(fm.cls_st.value == '8'){ //???????? ?????? ??????????	
	  	
	  	      var count =0;
	 		  var s_str = fm.rent_end_dt.value;
			  var e_str = fm.cls_dt.value;
				
			  var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
			  var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
				
			  var diff_date = s_date.getTime() - e_date.getTime();
				
			  count = Math.floor(diff_date/(24*60*60*1000));
					
			  if  ( toInt(fm.fee_size.value) < 2 ) { //?????? ?????? 	 2????					
		    	   if (  toInt(fm.vt_size8.value)  >  1 ) {		 // ???????? ???? ?????? ????  ????  
		    			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //?????? ???? 
		    			 if ( count > 61) {
			    		  	if (  toInt(parseDigit(fm.t_cal_days.value)) <  1 ) { 
						    		alert("?????????? ??????????.!!");
									return;
						   	}
						 }  	
					  }
				   }	    	
			 } else {	  //?????? ???? 	- 1????
		   	       if (  toInt(fm.vt_size8.value)  >  1 ) {		 // ???????? ???? ?????? ???? 
			 				    		
			    		if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //?????? ????  - 30 ?? ???????? 
			        
				    			if ( count > 30 ) { 				
					    		  	if (  toInt(parseDigit(fm.t_cal_days.value)) <  1 ) { 
								    		alert("?????????? ??????????.!!");
											return;
								   	}
								}   	
						 }		    	
			       }		  	
		  	}		    
					
			// ???????????? ????
		 	if (  toInt(parseDigit(fm.old_opt_amt.value)) >   0  ) { 
		
			    if ( fm.add_saction_id.value == '' ) {
							alert("???????????? ???? ?????????????? ??????????????. ???????? ?????????? ??????..!!");
							return;
				 }	
									
				 if ( toInt(parseDigit(fm.mopt_amt.value))  !=	 toInt(parseDigit(fm.old_opt_amt.value))   ) { 	
				 		alert('???????????? ?????????????? ????????????. ???????? ???? ??????????????'); 	fm.cls_dt.focus(); 
				 		fm.opt_amt.value=fm.mopt_amt.value;
				 		fm.cls_st.value="";			 	
				 		return;		 
				 }	
							 
				if (  toInt(fm.r_mon.value)  <  12 ) {		
					 	alert("???????????? ?????????????? 1????????????..!! ????(????)???????? ??????????.!!");
						return;					
				}
		   } 	
	   					
		}			
		
	  //?????? ???? ???? ?????? ???? -- warning !!!!	 
		if(toInt(parseDigit(fm.nfee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			if ( toInt(fm.rent_end_dt.value)  < toInt(replaceString("-","",fm.cls_dt.value)) ) {	                
				//???????? 
				if( toInt(parseDigit(fm.rcon_mon.value)) < 1  && toInt(parseDigit(fm.rcon_day.value)) < 1 ){
					alert("!!!!!!!?????????? ?????????????? ????????(????)?? ????????.!!!!!!\n\n?????? ???? ???? ?????? ?????? ?????? ???? ?? ?????????? ???????? ???? ??????????!!!");		
				//	print_view();
				}	
			}
		}  
	  
			// ???????????? ????
		if(confirm('?????????????????')){	
					fm.action='lc_cls_off_c_a.jsp';	
		//			fm.target='ii_no';
					fm.target='d_content';
					fm.submit();
		}	
	}
	
	//?????????? ????
	function cls_display(){
		var fm = document.form1;
				
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );				
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
									
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //???????? ?????? ??????????
		
			//???????? ?????????? 2?????? ???? ???????? ???? ???? - ????????????(?????????? 1?? ????) ???? ????
			if ( count > 61 ) {  
		//	  	alert("???????? ?????????? 2???? ?????? ???? ?????????? ???????? ????????..!!!");			  	
			  	set_day();  
			  	return;				
			}
			
			if(fm.opt_chk.value != '1' ){ //???????? ?????? ??????????		
			  	alert("???????? ???????? ?????? ????????. ?????? ???? ?????????? ???????? ????????..!!!");
			  	set_day();  
			  	return;				
			}			
		}
														
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //???????? ?????? ??????????
			tr_opt.style.display 		= '';  //????????	
			tr_ret.style.display		= 'none';	//????????		
			tr_gur.style.display		= 'none';	//????????	
			tr_cre.style.display		= 'none';	//????????????
			tr_sale.style.display		= '';	//????????
			
		}else{
			tr_opt.style.display 		= 'none';	//????????
			tr_ret.style.display		= '';	//????????	
			tr_gur.style.display		= '';	//????????
			tr_cre.style.display		= '';	//????????????
			tr_sale.style.display		= 'none';	//????????		
			tr_cal_sale.style.display		= 'none';	//?????????? 	
			
		}
			
		set_init();
			
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
		fm.mt.value='0';
	   	fm.fdft_amt3.value='0';  //????????
	   	fm.t_cal_days.value = '0';		   	
	   	fm.sui_st.value = 'N';	 
	   		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){
			fm.opt_per.value=fm.mopt_per.value;
			fm.opt_amt.value=fm.mopt_amt.value;
								
			//?????????? ?????????? ???? ???? ???????? ???? ??????
			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //???????? 			
				set_day_sui(fm.rent_end_dt.value);											
			}
			
			set_sui_c_amt();
		}	

		set_day();
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
	
	//?????????? ????
	function cancel_display(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
		    fm.cancel_yn.value = 'Y';
			alert('?????????????????? '+fm.fdft_amt2.value+'?????? ???????? ??????. \n\n???? ???? ???????? ?????????? ??????????.');
			return;			
		}
		
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'Y'){
			td_cancel_n.style.display 		= 'none';  //????????
			td_cancel_y.style.display 		= '';  //????????
		} else {
			td_cancel_n.style.display 		= '';  //????????
			td_cancel_y.style.display 		= 'none';  //????????
		}	
	}	
	
	//?????? ?????????? ???? ????
	function set_day(){
		var fm = document.form1;	
			
		if(fm.cls_dt.value == ''){ 	alert('?????????? ????????????'); 	fm.cls_dt.focus(); 	return;	}
	
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}	
		
		fm.cls_msg.value = "????????????. ???? ??????????????.!!!";		
				
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
						
		if(fm.cls_st.value == '8'){ //???????? ?????? ??????????
			
			fm.div_st.value="1";
			fm.est_dt.value= fm.cls_dt.value;
		 
			if(fm.opt_chk.value != '1' ){ //???????? ?????? ??????????		
				tr_opt.style.display 		= 'none';	//????????
			  	alert("???????? ???????? ?????? ????????. ?????? ???? ?????????? ???????? ????????..!!!");
			  	fm.action='./lc_cls_c_nodisplay.jsp';
				fm.cls_st.value="";	
				fm.cls_msg.value ="";
			} else {
			 	if  ( toInt(fm.fee_size.value) < 2 ) {				 //
			  				
					//???????? ?????????? 2?????? ???? ???? ?????? ????
					if ( count > 61 ) { 
				//		alert("???????? ?????????? 2???? ?????? ???? ?????????? ???????? ????????.!!!!"); 	
						tr_opt.style.display 		= '';	//????????
						tr_cal_sale.style.display		= '';	//?????????? 				
						fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';										  			
					} else {					
						tr_cal_sale.style.display		= 'none';	//??????????
						if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //???????? 							
							fm.dly_c_dt.value=fm.cls_dt.value;							 
					  		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.dly_c_dt.value+'&cls_gubun=Y&cls_dt='+fm.rent_end_dt.value;
					    } else { 
					   		fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';
					    }
					}	
				} else {  //???????? 
				//???????? ?????????? 1?????? ???? ?????????? ????
					if ( count > 30 ) { 			
						tr_opt.style.display 		= '';	//????????
						tr_cal_sale.style.display		= '';	//?????????? 				
						fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';										  			
					} else {					
						tr_cal_sale.style.display		= 'none';	//??????????
						if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //???????? 						
							fm.dly_c_dt.value=fm.cls_dt.value;							 
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
	
		//?????? ?????????? ???? ????
	function set_day_sui(cls_dt){
		var fm = document.form1;	
					
		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.cls_dt.value+'&cls_gubun=Y&cls_dt='+cls_dt;		
		fm.target='i_no';
		fm.submit();
	}			
	
	//???????? ???? : ????????
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		
		if(obj == fm.r_day){ //???????? ?? 	
			set_init();
		}
		
		if(obj == fm.ifee_mon || obj == fm.ifee_day){ //?????????? ????????
			if(fm.ifee_s_amt.value != '0'){		
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );		
		
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //????????
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //????
							
			}
			
		}else if(obj == fm.ifee_ex_amt){ //?????????? ????????
			if(fm.ifee_s_amt.value != '0'){		
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );				
			}
		}else if(obj == fm.pded_s_amt){ //?????? ????????
			if(fm.pp_s_amt.value != '0'){		
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //?????? ????????
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		
		if(fm.pp_s_amt.value != '0') {	 	 
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //??????
	    		
	    		fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;
	    	}   
	    }	
			
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // ?????????? ?????? ????
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
				
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		
		 //???????????? ?? ?????? ???? ???????????????? ?????????????? ????
	    if(fm.ifee_s_amt.value != '0') {
	    	 
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //???????? 	    		
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
	    	} 
	        	
	         set_init();	  
	    }	
		     			
		set_cls_s_amt();
	}	
	
	//???? ?????? ???? : ????????
	function set_cls_amt2(obj){
		var fm = document.form1;
		
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // ?????????? ????
		var v_ifee_ex_amt = 0;  //?????????? ????????
		var  re_nfee_amt = 0;  //???????? ?????????? ???? ?????? ?????? ???? ???? check
								
		obj.value=parseDecimal(obj.value);
						
		//?????? ?? ?????????? vat 	
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
		var c_over_s_amt = 0;
		var c_fee_v_amt =  0;
		
		
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt.value)) * 0.1)) ;
		c_fee_v_amt1 = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		
		// ?????? ?????? - 20190904 - ?????? ???? ?????????? ?????? (???????? ????)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
	    	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
	    	c_fee_v_amt1  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
 	    }	
				
	    c_over_s_amt = (toInt(parseDigit(fm.over_amt_1.value)) *0.1);
	        
			//?????????? ?????? ????.
		if ( fm.cls_st.value == '8') { //???????? 				   	
			   fm.dft_amt.value 			= '0';      //?????? 0
			   fm.dft_amt_1.value 	   = '0';			 
	   }
		 
		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
		no_v_amt1				= toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1  + c_over_s_amt   -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
				
		fm.rifee_v_amt.value =  parseDecimal(  toInt(parseDigit(fm.rifee_s_amt.value)) * 0.1 );  //?????????? 
		fm.rfee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rfee_s_amt.value))*0.1 );    //?????? 
		    
		fm.dfee_v_amt.value =  parseDecimal(  toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );  //???? ?????? ?????? 
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 );  //???? ?????? ?????? 
					    
		fm.over_v_amt.value =  '0';  //???? ???????? ?????? 
		fm.over_v_amt_1.value =  parseDecimal(  c_over_s_amt );  //???? ???????? ?????? 
		
		//???? ?????? ???????? ??????.	 	
		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		

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
		
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}			
		*/
		
		set_cls_s_amt();
	}	
			
	//???? ?????????????? ???? : ????????
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //????????????????
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
			//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
			//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}
		}else if(obj == fm.dft_int_1){ //?????? ????????
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
			//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}			
		}
		
		set_cls_s_amt();
	}		
	
	//????????????(????????)
	function set_sui_c_amt(){
		
		var fm = document.form1;
								
		if (fm.cls_st.value  == '8' ) {
		    fm.dft_amt.value = '0'; //??????????????
		    fm.dft_amt_1.value = '0'; //??????????????????
		  		  
		    fm.tax_supply[0].value 	= '0';
		    fm.tax_value[0].value 	= '0';	
		
			fm.sui_d1_amt.value		= '0';
			fm.sui_d2_amt.value		= '0';
			fm.sui_d3_amt.value		= '0';
			fm.sui_d4_amt.value		= '0';
			fm.sui_d5_amt.value		= '0';
			fm.sui_d6_amt.value		= '0';
			fm.sui_d7_amt.value		= '0';
			fm.sui_d8_amt.value		= '0';
			 				
			fm.sui_d_amt.value		= '0';
				
			fm.div_st.value="1";
			fm.est_dt.value= fm.cls_dt.value;
			set_cls_s_amt();
		}
	}	
	
							
	//???????? ????
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		
		/* ???????? - 2022-04
		if(obj == fm.dft_amt_1){ //????????
			fm.tax_supply[0].value 	= obj.value;
			if (fm.tax_chk0.checked == true) {
	 				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );		 		
			} else {
					fm.tax_value[0].value 	= '0';				
			}				
		
		}else if(obj == fm.etc_amt_1){ //????????????
			fm.tax_supply[1].value 	= obj.value;
			if (fm.tax_chk1.checked == true) {
				 fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 fm.tax_value[1].value 	= '0';
			}		
		
		}else if(obj == fm.etc2_amt_1){ //????????????
			fm.tax_supply[2].value 	= obj.value;
			if (fm.tax_chk2.checked == true) {
					fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[2].value 	= '0';
			}		
		
		}else if(obj == fm.etc4_amt_1){ //??????????????
			fm.tax_supply[3].value 	= obj.value;			
			if (fm.tax_chk3.checked == true) {
				 	fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[3].value 	= '0';
			}
			
	//	}else if(obj == fm.over_amt_1){ //?????????????? ????		 
		}else 
		*/
		
		if(obj == fm.m_over_amt){ //?????????????? ????		 
					
    		fm.j_over_amt.value =  toInt(parseDigit(fm.r_over_amt.value)) - toInt(parseDigit(obj.value)) ;  
    		
    		if (  toInt(parseDigit(fm.j_over_amt.value)) > 0) {    			    				
				fm.over_amt.value =  '0';  
				fm.over_amt_1.value =  fm.j_over_amt.value ;  					
				fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
				fm.tax_chk4.value  = 'Y' ;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );
				fm.over_v_amt.value 	= '0';	 
				fm.over_v_amt_1.value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );	 
			} else  { 						
					fm.over_amt.value =  '0';  
					fm.over_amt_1.value =  '0' ;  	
				 	fm.tax_supply[4].value 	= '0';
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
		
		var c_fee_v_amt =  0;
		var c_fee_v_amt1 =  0;
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt.value)) * 0.1)) ;
		c_fee_v_amt1 = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		
		// ?????? ?????? - 20190904 - ?????? ???? ?????????? ?????? (???????? ????)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
	    	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
	    	c_fee_v_amt1  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
 	    }	
		
		//???? ?????? ???????? ??????.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt  - c_pp_s_amt - c_rfee_s_amt ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 + c_over_s_amt - c_pp_s_amt - c_rfee_s_amt ;
						
		fm.rifee_v_amt.value = parseDecimal(c_rfee_s_amt );  //?????????? 
		fm.rfee_v_amt.value = parseDecimal(c_pp_s_amt );    //?????? 
		    
		fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );  //???? ?????? ?????? 
		fm.dfee_v_amt_1.value =parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 );  //???? ?????? ?????? 
			  			
		fm.over_v_amt.value =  '0';  //???? ???????? ?????? 
		fm.over_v_amt_1.value = parseDecimal( c_over_s_amt );  //???? ???????? ?????? 
		
		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		
				
		/* 2022-04 ???????? 	
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
		/*
		if ( fm.tax_chk4.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));			  
		}		
		*/		
		
		set_cls_s_amt();
		
	}	
		
	//???????? ????
	function set_cls_s_amt(){
		var fm = document.form1;			
	
	  	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value))  +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.over_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value))  + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)));	 //????????	
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	 	 	
		if (fm.cls_st.value  == '8' ) {	//????????
		   	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );					
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );						
		} 
			
		if (fm.cls_st.value  == '8' ) {	//????????
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );			

	}	
	
		
	//????????????????
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
		
		//???????? ?????? ???????? ???????? ?????????? ??????.
		fm.est_amt.value  = fm.gi_j_amt.value;  
				
	}	
	
	//????????????
	function set_etc_amt(){
		var fm = document.form1;
		
		fm.etc_out_amt.value 		= parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)) + toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		fm.etc_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));	
		fm.etc_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
		
					//????????????
	/*				
		if(toInt(parseDigit(fm.etc_amt.value)) > 0){		
				fm.tax_g[1].value       = "???? ????????????";
		   		fm.tax_supply[1].value 	= fm.etc_amt.value;
		   		
		   		if (fm.tax_chk1.checked == true) {
		   				fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt.value)) * 0.1 );
		   		} else {
		   				fm.tax_value[1].value 	= '0';
		   		}			
		}
					//????????????
		if(toInt(parseDigit(fm.etc2_amt.value)) > 0){
				fm.tax_g[2].value       = "???? ????????";
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
	
	//?????????? check ???? ?????? - ???????????? ?????? ???? ??????(??????, ???????? ???? (???? ????????)) - ?????????? ???????? ?????????????? 
	function set_vat_amt(obj){
		var fm = document.form1;
			
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
		/*
		if(obj == fm.tax_chk0){ // ??????
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
	
		} else if(obj == fm.tax_chk1){ // ????????
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
			 
		} else if(obj == fm.tax_chk2){ // ????????
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
			 
		} else if(obj == fm.tax_chk3){ // ??????????????
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
		} else if(obj == fm.tax_chk4){ // ???????? ?????? 
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
			 }		 
			  
		} */
		
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
	
	//????????  ????
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
		//????????????????
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
		
		//?????? 
		fm.m_reason.value 	=     "";	
		fm.m_over_amt.value 	=     "0";	
		fm.r_over_amt.value 	=     "0";	
		fm.j_over_amt.value 	=     "0";	
		fm.m_saction_id.value= "";
		fm.over_amt.value 	=     "0";	
		fm.over_amt_1.value 	=     "0";	
		fm.over_v_amt.value 	=     "0";	
		fm.over_v_amt_1.value 	=     "0";	
		
		fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
		fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );	
		cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
		fm.cal_dist.value 		=     parseDecimal( cal_dist   );
		
		fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     )
		
		//fm.add_dist.value 		=     parseDecimal( 1000  );  //??????????????
		//fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
					
		//?????? 20220414 ?????? ????
		if (  <%=base.getRent_dt()%>  > 20220414 ) {  
			// 2022-05 ????  over_dist??  0 ???? ???? 1000, 0  ?????? -1000 ???? - ?????????????? 
			if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
					fm.add_dist.value 		=  '0';  //???????????? 
					fm.jung_dist.value 		=  '0';			
			} else {
					// 2022-05 ????  over_dist??  0 ???? ???? 1000, 0  ?????? -1000 ???? - ?????????????? 
					if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
						fm.add_dist.value 		=     parseDecimal( 1000  );  //???????????? 			
					} else {
						fm.add_dist.value 		=     parseDecimal( -1000  );  //???????????? 	
					}
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
			}
		} else {
			fm.add_dist.value 		=     parseDecimal( 1000  );  //??????????????	(?????????? ???????? ????)
			fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );					
		}
			
		
		//?????????? ???? - 50% ?????? ?????? ????  (??????, ???????? 100%???? )  : 202204???? 40% ???? ???? ????
		if ( fm.cls_st.value == '8'   &&  (  fm.agree_yn.value == '2'  ||  fm.agree_yn.value == '3' )  ) { 
		 
			if ( (  <%=base.getRent_dt()%>  > 20130604  &&    <%=car1.getAgree_dist()%>  > 0   &&  <%=base.getCar_gu()%>  ==  '1' ) ||    (  <%=base.getRent_dt()%>  > 20140705  &&  <%=base.getCar_gu()%>  ==  '0' )   ) {  
								
				 // fm.taecha_st_dt ???? ?????? ???????? - 20210330 ?????? ?????? ?????????????? ???????? ???? - ???? ?????????? ???? ?????? ?????????????? ???????? ???? 
			//	if ( fm.taecha_st_dt.value  != "" )  {			
			//		var s1_str = fm.taecha_st_dt.value; 
			//		var e1_str = fm.cls_dt.value;
			//		var  count1 = 0;
				
			//		var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );								
			//		var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1,  e1_str.substring(8,10) );	
																	
			////		var days = (e1_date - s1_date) / 1000 / 60 / 60 / 24; 		//1??=24????*60??*60??*1000milliseconds
			////		var mons = (e1_date - s1_date) / 1000 / 60 / 60 / 24 / 30; 	//1??=24????*60??*60??*1000milliseconds
			////	         	cal_dist  =      (    mons * toInt(fm.o_p_m.value)  ) + ( days * toInt(fm.o_p_d.value)  );/
			
			//	   var diff1_date = e1_date.getTime() - s1_date.getTime();
			//	 	count1 = Math.floor(diff1_date/(24*60*60*1000));
			//		cal_dist =   	toInt(fm.agree_dist.value) * count1/ 365;
			//	} else {	
				 
				//	cal_dist =   	toInt(parseDigit(fm.agree_dist.value))  * toInt(parseDigit(fm.rent_days.value))   / 365;
					cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
			//		cal_dist  =      (    toInt(fm.r_mon.value) * toInt(fm.o_p_m.value)  ) + (  toInt(fm.r_day.value) * toInt(fm.o_p_d.value)  );				
			//	}         	
					
				fm.cal_dist.value 		=     parseDecimal( cal_dist   );				
			//	fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );						
				fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
				fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
				fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );						  				
			//	fm.add_dist.value 		=     parseDecimal( 1000  );  //??????????????				
			//	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
				
			    if (  <%=base.getRent_dt()%>  > 20220414 ) {  //?????? 20220414 ?????? ????
					if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
						fm.add_dist.value 		=  '0';  //???????????? 
						fm.jung_dist.value 		=  '0';			
					} else {
						// 2022-05 ????  over_dist??  0 ???? ???? 1000, 0  ?????? -1000 ???? - ?????????????? 
						if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
							fm.add_dist.value 		=     parseDecimal( 1000  );  //???????????? 			
						} else {
							fm.add_dist.value 		=     parseDecimal( -1000  );  //???????????? 	
						}
						fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
					}
			    } else {
			    	fm.add_dist.value 		=     parseDecimal( 1000  );  //??????????????	(?????????? ???????? ????)
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );	
			    }
			    
				//?????? 100% ????,  //???????? ???? 
			<%    if ( fee.getRent_way().equals("1") )  { %>
						
				   if ( toInt(parseDigit(fm.jung_dist.value))   > 0   ) {
				   		
						fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );
						
						if (  <%=base.getRent_dt()%>  > 20220414 ) {
							fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.6 );	
							fm.m_reason.value        =   "???????? 60% ????";
						} else {
							fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.5 );	
							fm.m_reason.value       =   "???????? 50% ????";
						}
						
						fm.j_over_amt.value 	=      parseDecimal(  toInt(parseDigit(fm.r_over_amt.value)) -   toInt(parseDigit(fm.m_over_amt.value))    );	 //????
					
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
						if (  <%=base.getRent_dt()%>  > 20220414 ) {  //?????? 20220414 ?????? ????
							fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.rtn_run_amt.value)   );				
							fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.6  );	
							fm.m_reason.value       =   "???????? 40% ????";	
							fm.j_over_amt.value 	=      parseDecimal(  toInt(parseDigit(fm.r_over_amt.value)) -   toInt(parseDigit(fm.m_over_amt.value))   );	 //????
													
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
				 	/*
					if ( 	toInt(parseDigit(fm.jung_dist.value))   > 0   &&  fm.agree_yn.value == '2'   ) {
					
						fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );	
						fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.5 );	
						fm.j_over_amt.value 	=      parseDecimal(  toInt(parseDigit(fm.r_over_amt.value)) -   toInt(parseDigit(fm.m_over_amt.value))     );	 //????
						fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
						fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );	
					
						fm.tax_chk4.value  = 'Y' ;
						fm.m_reason.value            =   "???????? 50% ????";
						
					} else {
						fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );	
										
						fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );		
					
						fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
						fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );		
					
						fm.tax_chk4.value  = 'Y' ;	
							
				 	} */
				 
			<% } %>	
				
			/* 	if ( toInt(parseDigit(fm.jung_dist.value))   < 0 ) {
			 		fm.r_over_amt.value 	=      "0";					
					fm.j_over_amt.value 	=     "0";	
					fm.tax_supply[4].value 	=  "0";		
					fm.tax_value[4].value 	= '0';
				
					fm.tax_chk4.value  = 'N' ;	
			   }  */  		
			}
		}
						
		fm.over_amt.value 		    = '0';
		fm.over_amt_1.value 	    = parseDecimal( toInt(parseDigit(fm.j_over_amt.value)));			
		
		var no_v_amt = 0;
		var no_v_amt1 = 0;
		var   c_pp_s_amt = 0;
		var   c_rfee_s_amt = 0;
		var   c_over_s_amt = 0;
		
		c_pp_s_amt = toInt(parseDigit(fm.rfee_s_amt.value))*0.1;
		c_rfee_s_amt = toInt(parseDigit(fm.rifee_s_amt.value)) *0.1;
		c_over_s_amt = toInt(parseDigit(fm.over_amt_1.value)) *0.1;
					
		var c_fee_v_amt =  0;
		var c_fee_v_amt1 =  0;
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt.value)) * 0.1)) ;
		c_fee_v_amt1 = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		
		// ?????? ?????? - 20190904 - ?????? ???? ?????????? ?????? (???????? ????)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
	    	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
	    	c_fee_v_amt1  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
 	    }	
		
			//?????????? ?????? ????.
		if ( fm.cls_st.value == '8') { //???????? 		
			    //?????? 0
			  fm.dft_amt.value 			= '0';
			  fm.dft_amt_1.value 	   = '0';			  		  
	   }
		 
		//???? ?????? ???????? ??????.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt  -  c_pp_s_amt  - c_rfee_s_amt ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1  + c_over_s_amt -  c_pp_s_amt  - c_rfee_s_amt ;
						
		fm.rifee_v_amt.value = parseDecimal( c_rfee_s_amt );  //?????????? 
		fm.rfee_v_amt.value = parseDecimal( c_pp_s_amt );    //?????? 
		    
		fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );  //???? ?????? ?????? 
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 );  //???? ?????? ?????? 
			    
		fm.over_v_amt.value = '0';  //???? ???????? ?????? 
		fm.over_v_amt_1.value = parseDecimal( c_over_s_amt );  //???? ???????? ?????? 
					
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
		
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
		
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
		*/			
		set_cls_s_amt();				
	}		
	
	//?????????? ???????? - ?????? ???? ???? ???????? ?????? ?????? ???????? ???????? . (??????????(??????)?? (?????????? 1???????? ????????) )
	function cal_rc_rest(){
		var fm = document.form1;
				
		 fm.dft_amt.value = '0'; //??????????????
		 fm.dft_amt_1.value = '0'; //??????????????????
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

			s_str = fm.s_r_fee_est_dt[i].value; // ?????????? 
			s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7) -1 , s_str.substring(8,10) ); 
									
			diff_date = s_date.getTime() - e_date.getTime();
		    count = Math.floor(diff_date/(24*60*60*1000));					
			
			fm.s_cal_days[i].value = parseDecimal(count);			//?????????? ????????
			
			if  ( toInt(fm.fee_size.value) < 2 ) 	{		//???????? ?????? 
			
				   fm.mt.value ='1' ;  
					   					
					//??????  ???????? ???? - ?????????? 30?????? ???? ?????? ???? /30 * ?????????? ???? ( 0???? ???? ?????? 0???? )								
		         var cc_grt_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_grt_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_grt_amt.value)) );
		         cc_grt_amt = ( cc_grt_amt < 0 ? 0 : cc_grt_amt );
		            
		          //?????????????????? ?????? ????*??????/?????????? 
		         if ( i == scd_size - 1 ) 	cc_grt_amt =   toInt(parseDigit(fm.e_grt_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ;
		                  
		          fm.s_grt_amt[i].value = parseDecimal(cc_grt_amt) ;          
		                     
					//????????, ??????, ???????? ?????? - ?????????? 30?????? ???? ?????? ???? /30 * ?????????? ???? ( 0???? ???? ?????? 0???? )								
		         var cc_tax_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_tax_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_tax_amt.value)) );
		         cc_tax_amt = ( cc_tax_amt < 0 ? 0 : cc_tax_amt );		         
		         	//?????????????????? ?????? ????*??????/?????????? 
		         if ( i == scd_size - 1 ) 	cc_tax_amt =   toInt(parseDigit(fm.e_tax_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ;
		                  
		         fm.s_tax_amt[i].value = parseDecimal(cc_tax_amt) ;  
		              
		         var cc_insur_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_insur_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_insur_amt.value)) );
		         cc_insur_amt = ( cc_insur_amt < 0 ? 0 : cc_insur_amt );         
		         	//?????????????????? ?????? ??????*??????/?????????? 
		         if ( i == scd_size - 1 ) 	 cc_insur_amt =  toInt(parseDigit(fm.e_insur_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ; 	
		         	
		         var cc_serv_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_serv_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_serv_amt.value)) );
		         cc_serv_amt = ( cc_serv_amt < 0 ? 0 : cc_serv_amt );           
		         	//?????????????????? ?????? ????*??????/?????????? 
		         if ( i == scd_size - 1 ) 	cc_serv_amt =  toInt(parseDigit(fm.e_serv_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ;
		         	    
		         var cc_is_amt ;
		                  
		         //???????????? ???????? ????
		   <%     if ( fee.getRent_way().equals("1") )  { %>
		         		 cc_is_amt  = cc_insur_amt + cc_serv_amt;
		     <%    } else {  %>
		         		  cc_is_amt  = cc_insur_amt ;
		    <%     }  %>
		    		    
		         fm.s_is_amt[i].value = parseDecimal(cc_is_amt) ;		          
		          
		         //?????? ???????? ????         
				 fm.s_g_fee_amt[i].value =    parseDecimal( toInt(parseDigit(fm.s_fee_s_amt[i].value))   +   toInt(parseDigit(fm.s_grt_amt[i].value))  ) ;
		
		         fm.s_cal_amt[i].value =    parseDecimal( toInt(parseDigit(fm.s_g_fee_amt[i].value))   -   toInt(parseDigit(fm.s_tax_amt[i].value))  -   toInt(parseDigit(fm.s_is_amt[i].value)) ) ;
			     
			     s_rc_rate =  (1/ Math.pow(  1+a_f/100/12, count/365*12) ).toFixed(5);
			         	  	
		     	 fm.s_rc_rate[i].value = s_rc_rate;
		        
		     	 if ( s_rc_rate > 1) {  //?????? ???? ?????? 
		     		fm.s_r_fee_s_amt[i].value = parseDecimal(toInt(parseDigit(fm.s_cal_amt[i].value)) * 1) ;
		     	 } else {
		     		 fm.s_r_fee_s_amt[i].value = parseDecimal(toInt(parseDigit(fm.s_cal_amt[i].value)) *s_rc_rate) ;
		     	 }
		      			      	 
		      	 fm.s_r_fee_v_amt[i].value =  parseDecimal(toInt(parseDigit(fm.s_r_fee_s_amt[i].value))    * 0.1 )  ;
		      		
		      	 fm.s_r_fee_amt[i].value =  parseDecimal(  toInt(parseDigit(fm.s_r_fee_s_amt[i].value) ) +   toInt(parseDigit(fm.s_r_fee_v_amt[i].value)) ) ;      	   
		      		  		  
      		} else {
				s_rc_rate = 1;  //???????? ?? 1 ( ?????? ????)
			}	    	
      			
		}		
		
		   //???????? ???????? 
		fm.cls_cau.value = "????????????,  ??????  ????????????:" +  parseDecimal( toInt(parseDigit(fm.opt_amt.value)) ) ;
		fm.old_opt_amt.value =  toInt(parseDigit(fm.opt_amt.value)) ;    	
		 
		  //???????????? ???????????????????? ???????? ???? ???????? ??. - 20161117
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
		
		e1_end_date =  new Date (e1_end_str.substring(0,4), e1_end_str.substring(4,6) -1 , e1_end_str.substring(6,8) );  //???? -1 ?????? 
		e_end_date =  new Date (e_end_str.substring(0,4), e_end_str.substring(4,6) -1 , e_end_str.substring(6,8) );   //?????????? 
				
		diff1_date = e_date.getTime() - e1_end_date.getTime();
		count1 = Math.floor(diff1_date/(24*60*60*1000));					
		
		diff2_date = e_end_date.getTime() - e1_end_date.getTime();
	    count2 = Math.floor(diff2_date/(24*60*60*1000));			
		 
		if  ( toInt(fm.fee_size.value) < 2 ) { //?????? ?????? 
		} else {		
			recal_opt_amt =   toInt(parseDigit(fm.fee_size_1_opt_amt.value))  - ( ( toInt(parseDigit(fm.fee_size_1_opt_amt.value))  -  toInt(parseDigit(fm.opt_amt.value)) ) *  count1 / count2   ) ; 
		//  alert(recal_opt_amt);
			 fm.opt_amt.value = parseDecimal(recal_opt_amt);
			 fm.mt.value ='2' ;		
			 fm.count1.value =count1 ;
			 fm.count2.value =count2 ;
		}
				
		fm.opt_amt.value =  parseDecimal( toInt(parseDigit(fm.opt_amt.value)) * s_rc_rate) ;   
		fm.rc_rate.value = s_rc_rate;
		
		   //???????? ???????? 
	    if  ( toInt(fm.fee_size.value) < 2 ) { //?????? ?????? 
	    	 fm.cls_cau.value = "????????????,  ??????  ????????????:" +  parseDecimal( toInt(parseDigit(fm.old_opt_amt.value)) ) + " , ??????????????: " +  parseDecimal( toInt(parseDigit(fm.opt_amt.value)) )  ;
	    }
		   
		if ( toInt(parseDigit(fm.mopt_amt.value))  !=	 toInt(parseDigit(fm.old_opt_amt.value))   ) { 	
		 		alert('???????????? ?????????????? ????????????. ???????? ???? ??????????????'); 	fm.cls_dt.focus(); 
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
		fm.t_cal_days.value = parseDecimal(t_cal_days);  //?????????????? 
		 	 			 	
		//?????? ???? 
		if  ( toInt(fm.fee_size.value) < 2 ) {					
			 cal_tot_set();
		} 			
		
		 set_cls_s_amt()	; //?????????? 	
	}
		
	//?????????? ???????? 
	function cal_rc_rest_clear(){
		var fm = document.form1;
		
		 fm.dft_amt.value = '0'; //??????????????
		 fm.dft_amt_1.value = '0'; //??????????????????
		 fm.mt.value= '0'; // ???????? ????
			 	
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

			s_str = fm.s_r_fee_est_dt[i].value; // ?????????? 
			s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7) -1 , s_str.substring(8,10) ); 
									
			diff_date = s_date.getTime() - e_date.getTime();
		    count = Math.floor(diff_date/(24*60*60*1000));					
			
			fm.s_cal_days[i].value = '0';			//?????????? ????????
			
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
	
	   //?????????????? ?????? ?????? ?? 
	   recal_opt_amt =  toInt(parseDigit(fm.opt_amt.value)) +   m_r_fee_amt; 
	   fm.m_r_fee_amt.value = m_r_fee_amt;  //?????????????? ?????? ??????
	   
	   fm.opt_amt.value = parseDecimal(recal_opt_amt);	
				
		//???????? ???????????? ???? 		
	 //  fm.ex_di_v_amt.value = '0'; //??????
	 //  fm.ex_di_amt.value = '0'; //??????		 
	   fm.ex_di_v_amt_1.value = '0'; //??????????????
	   fm.ex_di_amt_1.value = '0'; //??????????????????
	 
	   fm.nfee_mon.value = '0'; // ????????
	   fm.nfee_day.value = '0'; //????????
	  
	//   fm.nfee_amt.value =  parseDecimal(toInt(parseDigit(fm.t_r_fee_s_amt.value))  -  m_r_fee_s_amt); 	 
	   fm.nfee_amt_1.value =  parseDecimal(toInt(parseDigit(fm.t_r_fee_s_amt.value))  -  m_r_fee_s_amt); 		 
	 
		var no_v_amt = 0;
		var no_v_amt1 = 0;
		
		//???? ?????? ???????? ??????.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)    -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value = toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 ;  //?????????? 
		fm.rfee_v_amt.value = toInt(parseDigit(fm.rfee_s_amt.value))*0.1;    //?????? 
		    
		fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + (toInt(parseDigit(fm.nfee_amt.value)) * 0.1);  //???? ?????? ?????? 
		fm.dfee_v_amt_1.value =toInt(parseDigit(fm.ex_di_v_amt_1.value)) + (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1);  //???? ?????? ?????? 
		    
		fm.over_v_amt.value  =   '0';  //???? ???????? ?????? 
		fm.over_v_amt_1.value = toInt(parseDigit(fm.over_amt_1.value)) * 0.1;  //???? ???????? ?????? 
						
	   if ( fm.mt.value == '1' ) {	 //???????? - 2022-04  	   
	         if (   Math.abs(toInt(parseDigit(fm.t_r_fee_v_amt.value)) - no_v_amt) < 100  ) {
					no_v_amt =   toInt(parseDigit(fm.t_r_fee_v_amt.value)) - toInt(parseDigit(fm.m_r_fee_v_amt.value));						 					 						 		
			} 
	   } 
	   	  
	//	fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
		
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
		
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
		*/
			
		set_cls_s_amt();
	}	
		
	
	function view_car_service(car_id){
	  var fm = document.form1;
	  fm.tot_dist_cnt.value = '1';
		window.open("/acar/secondhand_hp/service_history.jsp?c_id="+fm.car_mng_id.value+"&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, resizable=yes, scrollbars=yes, status=yes");		
	}
			
	//?????? ?????? ????????
	function print_view(mode)
	{
		var fm = document.form1;
		var m_id = fm.rent_mng_id.value;
		var l_cd = fm.rent_l_cd.value;
		var b_dt=  fm.b_dt.value;
		var cls_chk;
	    var mode;
		window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "PRINT_VIEW", "left=50, top=50, width=770, height=640, scrollbars=yes");
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
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base1.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base1.get("IFEE_S_AMT")%>'>
<input type='hidden' name='fee_s_amt' value='<%=base1.get("FEE_S_AMT")%>'>
  
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 
<input type='hidden' name='use_oe_dt' value='<%=base1.get("USE_OE_DT")%>'>  <!--  ???????????? ?????? ??????????  -->
<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'> 

<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--?????????? ???????????? -->

<input type='hidden' name='bank_code2' 	value=''>
<input type='hidden' name='deposit_no2' 	value=''>
<input type='hidden' name='bank_name' 	value=''>  
 
<input type='hidden' name='cls_s_amt' value='' >
<input type='hidden' name='cls_v_amt' value='' >
<input type='hidden' name='car_ja_no_amt' value='<%=car_ja_no_amt%>' >
<input type='hidden' name='opt_chk' value='<%=ext_fee.getOpt_chk()%>'>

<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'>
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_V_AMT")))%>'>
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_AMT")))%>'> <!--???????? ???????????? -???? -->

<input type='hidden' name='s_mon' value='<%=base1.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base1.get("S_DAY")%>'> 

<!-- <input type='hidden' name='m_mon' value='<%=base1.get("M_MON")%>'> -->
<!-- <input type='hidden' name='m_day' value='<%=base1.get("M_DAY")%>'> -->

<input type='hidden' name='hs_mon' value='<%=base1.get("HS_MON")%>'>  <!-- ?????????? ???????? -->
<input type='hidden' name='hs_day' value='<%=base1.get("HS_DAY")%>'> <!-- ?????????? ???????? -->

<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_S_AMT")))%>'> <!--???????? ?????????? -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'>  

<input type='hidden' name='dly_c_dt' value='' >

<input type='hidden' name='reg_cnt' value='<%=reg_cnt%>'> <!-- ?????????? -->

<input type='hidden' name='lfee_mon' value='<%=base1.get("LFEE_MON")%>'> <!--?????????? -->
  
   <!--???????? ???? ???? -->
<input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
<input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='agree_yn' value='<%=car1.getAgree_dist_yn()%>'>
 <input type='hidden' name='rtn_run_amt' value='<%=car1.getRtn_run_amt()%>'>
  
<input type='hidden' name='rc_s_amt' value='<%=base1.get("RC_S_AMT")%>'> <!--???? ???? --> 
<input type='hidden' name='rc_v_amt' value='<%=base1.get("RC_V_AMT")%>'> <!-- ???? ???? --> 
<input type='hidden' name='rr_s_amt' value='<%=base1.get("RR_S_AMT")%>'> <!-- ???? ???? --> 
<input type='hidden' name='rr_v_amt' value='<%=base1.get("RR_V_AMT")%>'> <!-- ???? ???? --> 
<input type='hidden' name='rr_amt' value='<%=base1.get("RR_AMT")%>'> <!-- ???? ???? --> 
    
<input type='hidden' name='a_f' value='<%=em_bean.getA_f()%>'>  <!-- ?????? --> 

<input type='hidden' name='vt_size8' value='<%=vt_size8%>' >  <!--?????????? ?????????? -->

<input type='hidden' name='e_grt_amt' value='<%=e_grt_amt%>' >
<input type='hidden' name='e_tax_amt' value='<%=AddUtil.parseInt((String)sale.get("TAX_AMT"))%>' >
<input type='hidden' name='e_insur_amt' value='<%=AddUtil.parseInt((String)sale.get("INSUR_AMT"))%>' >
<input type='hidden' name='e_serv_amt' value='<%=AddUtil.parseInt((String)sale.get("SERV_AMT"))%>' >
    
<input type='hidden' name='mt'  value='0' >  <!-- ????????????  0:????, 1:???????? 2:???????????? --> 
<input type='hidden' name='b_dt' size='10' value='<%=Util.getDate()%>' >
<input type='hidden' name='taecha_st_dt' value='<%=taecha.getCar_rent_st()%>'><!--???? ?????? -->
<input type='hidden' name='taecha_et_dt' value='<%=taecha.getCar_rent_et()%>'><!--???? ?????? -->

<input type='hidden' name='rc_rate'  value=''  >  <!-- ????????????  ?????????? --> 
<input type='hidden' name='count1' value='' >   
<input type='hidden' name='count2' value='' >  
<input type='hidden' name='m_r_fee_amt' value=''>  <!--  ?????????????? ?????? ?????? -->

<input type='hidden' name='rifee_v_amt' value=''> <!-- ?????? ????  -->
<input type='hidden' name='rfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt_1' value=''>
<input type='hidden' name='over_v_amt' value=''>
<input type='hidden' name='over_v_amt_1' value=''>

<input type='hidden' name='today_dt' value='<%=AddUtil.getDate(4)%>'>
     
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
 	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
      <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=12% colspan=2>????????</td>
            <td width=24%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;<a href="javascript:view_cng_etc('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='????????'><img src=/acar/images/center/button_tish.gif align=absmiddle border=0></a>          
            &nbsp;<a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='????????'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
              &nbsp;<a href="javascript:print_view('');" title='????' onMouseOver="window.status=''; return true">[??????]</a>              
            </td>
            <td rowspan="7" class="title">??<br>
		                ??<br>
		                ??<br>
		                ??<br>
		                ??</td>
		    <td class=title width=10%>????</td>
            <td >&nbsp;<% if  ( cr_bean.getFuel_kd().equals("8") ) { %><font color=red>[??]</font>&nbsp;<% } %>
            <%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
			<font color="#999999">(????????:<%=cm_bean.getJg_code()%>)</font>
			</td>
			<td rowspan="4" class="title">??<br>
		                ??</td>		            
            <td class=title width=10%>????????</td>
            <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
          </tr>
          <tr>
            <td rowspan="3" class="title">??<br>
		                ??<br>
		                ??</td>
		    <td class=title>????</td>
            <td>&nbsp;<a href="javascript:view_client('<%=rent_mng_id%>', '<%=rent_l_cd%>', '<%=fee_size%>')" onMouseOver="window.status=''; return true" title="??????????"><%=client.getFirm_nm()%></a>
            &nbsp;&nbsp;<a href="javascript:view_tel('<%=rent_mng_id%>' ,'<%=rent_l_cd%>')" onMouseOver="window.status=''; return true" title="??????????">[??????????]</a>
            </td>
		    <td class=title>????????</td>
            <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="??????????"><%=cr_bean.getCar_no()%></a>
              
            </td>
            <td class=title>????????</td>
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>??????<%}else if(bus_st.equals("2")){%>????????<%}else if(bus_st.equals("3")){%>????????<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>????????<%}else if(bus_st.equals("6")){%>????????<%}else if(bus_st.equals("7")){%>????????<%}else if(bus_st.equals("8")){%>??????<%}%></td>
          </tr>
          <tr> 
            <td class=title>??????</td>
            <td>&nbsp;<%=client.getClient_nm()%></td> 
            <td class=title>????????</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>??????<%}else if(car_gu.equals("1")){%>????<%}else if(car_gu.equals("2")){%>??????<%}%></td>
            <td class=title>??????????</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
          </tr>
          <tr>
            <td class=title>????/????</td>
            <td>&nbsp;<%=site.getR_site()%></td> 
            <td class=title>????????</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>????<%}else if(car_st.equals("2")){%>????<%}else if(car_st.equals("3")){%>????<%}else if(car_st.equals("5")){%>????????<%}%></td>   
            <td class=title>??????????</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
          </tr>
          <tr> 
            <td rowspan="3" class="title">??<br>
		                ??</td>    
		    <td class=title>????????</td>
            <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>????<%}else if(rent_st.equals("3")){%>????<%}else if(rent_st.equals("4")){%>????<%}%></td>            
            <td class=title>??????????</td>
            <td>&nbsp;<%=cr_bean.getInit_reg_dt()%></td> 
            <td rowspan="3" class="title">??<br>
		               ??</td>  
            <td class=title width=10%>????????</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
          </tr>
          <tr> 
            <td class=title>????????</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
            <td class=title>??????????</td>
            <td>&nbsp;<%=cr_bean.getCar_end_dt()%>
            <font color="red"><% if ( cr_bean.getCar_end_yn().equals("Y") )  {%>????????<%} %></font>  
            </td>     
            <td class=title>????????</td>
            <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>??????<%}else if(rent_way.equals("3")){%>??????<%}%></td>
          </tr>
          <tr>   
            <td class=title>????????</td>
            <td>&nbsp;<%=fee.getCon_mon()%> ????</td>
            <td class=title>????????</td>
            <td>&nbsp;<b><%=base1.get("CAR_MON")%></b> ????</td>         
            <td class=title>??????????</td>
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
				
			//	s_opt_per = fees.getOpt_per(); // ???????????? ???? 
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
				s_opt_end_dt= fees.getRent_end_dt();
				
			   f_opt_per  = (float) s_opt_amt  / car_price * 100 ;
			   			 			   
			   f_opt_per =  AddUtil.parseFloatCipher(f_opt_per,1);
				
				  //  fee_size - 1???? (???????????? ?????? ) 
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
    <tr>
        <td colspan="2" style='background-color:bebebe; height:1;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>	
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
            <td width='13%' class='title'>????????</td>
            <td width="13%">&nbsp; 
			  <select name="cls_st" onChange='javascript:cls_display()'>
			    <option value="">---????---</option> 
                <option value="8">????????</option>   
              </select> </td>
            
            <td width='13%' class='title'>??????</td>
            <td width="13%">&nbsp;
              <select name='reg_id'>
                <option value="">????</option>
                <%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%		}
					}%>
              </select></td>	
                      
            <td width='13%' class='title'>????????</td>
            <td width="13%">&nbsp;
			  <input type='text' name='cls_dt' value='<%=AddUtil.getDate()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'></td> 
		    <td width='13%' class='title'>????????</td>
		    <td >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' readonly  value='<%=base1.get("R_MON")%>' >????&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=base1.get("R_DAY")%>' onBlur='javascript:set_cls_amt1(this);'>??&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>???? </td>
            <td colspan="7">&nbsp;
			  <textarea name="cls_cau" cols="140" class="text" style="IME-MODE: active" rows="3"></textarea> 
            </td>
          </tr>
          <tr>                                                      
            <td class=title >??????????<br>????????????</td>
     	    <td>&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'>
                  <option value="Y" selected>????????</option>
                  <option value="N">????????</option>
              </select>
		    </td>
		    
		    <td  class=title width=10%>??????????????</td>
            <td  width=12%>&nbsp;
				  <select name='add_saction_id'>
	                <option value="">--????--</option>
	         <!--       <option value="000172">??????</option> -->
	                <option value="000197">??????</option>	              
	            </select>
			</td>			     
            <td  colspan="4" align=left>&nbsp;?? ?????? ???????? ???? ???? ???????? ?? ?????? ????, ?????????? ???????? ?????????? ???? </td>
          </tr>
          
           <tr>      
		            <td width='13%' class='title'>????????</td>
		            <td width='18%' >&nbsp;
		             <input type='text' name='tot_dist' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_over_amt();'>&nbsp;km
                     <input type ='hidden' name='tot_dist_cnt' value='<%=tot_dist_cnt%>' > 
                     &nbsp;<a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="????????????"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a>
                     </td>	     	    		
                  <td colspan=6>&nbsp;?? ?????????? ???????????? </td>
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
					                    <td class=title style='height:44' width=13%><font color=red>???? ????????</font></td>
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
	                    <td class=title width=13%>????????????</td>
						<td colspan=4>&nbsp;
							<input type="text" name='des_zip' id="des_zip" size="7" maxlength='7'>
							<input type="button" onclick="openDaumPostcode()" value="???????? ????"><br>
							&nbsp;&nbsp;<input type="text" name='des_addr' id="des_addr" size="80">
						</td>
						<!--
	                    <td  colspan="4">&nbsp; <input type='text' name='des_zip'  size='7' class='text' readonly onClick="javascript:search_zip('des');">
				      <input type='text' size='70' name='des_addr'  maxlength='80' class='text'>   </td>
					  -->
                   	  <td class=title width=12%>????&??????</td>
                   	   <td  >&nbsp; <input type='text' size='30' name='des_nm'    maxlength='40' class='text'> </td>
                   	   <td class=title width=12%>??????</td>
                   	   <td  >&nbsp; <input type='text' size='30' name='des_tel'    maxlength='40' class='text'> </td> 
			  </tr>
	              </table>
	         </td>       
   	 </tr> 
   	 <tr>
     		 <td>&nbsp;</td>
     </tr>
  
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ?????? ???????? ???????? ???? ???????? ?????????????? ???? ??????????.</td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ?????? ???????? ????????   ???? ???? ?????????? 1?? ??????????.</td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***  ?????????? 3???? ???? ???????? ?????? ?????????? !!!</font></td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ???????? ?????? ?????????? ???????? ???????????? ?????????? ??????. </td>
    </tr>
    
    <tr>
           	<td>&nbsp;<font color="#FF0000">***(????)???? ???????? ???? ?????????? ?????? ?? ?????? ?????? ?????? ?????? ???????? ?????????? ????????????.!!! </font></td> 
    </tr>
    
    <tr>
           	<td>&nbsp;<font color="#FF0000">***  31??, 30?? ?????? ???? ???? ???? ?????? ?? ?????? ?????? ?????? ?????? ???????? ??????????.!!! </font></td> 
    </tr>
     
    <tr>
      <td>&nbsp;</td>
    </tr>
    
 	<tr id=tr_opt style="display:''">  
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
		          	<input type='hidden' name='mopt_per' value='<%=f_opt_per%>'>
		          	<input type='hidden' name='mopt_amt' value='<%=AddUtil.parseDecimal(s_opt_amt)%>'>
		          	<input type='hidden' name='mopt_s_amt' value='<%=s_opt_s_amt%>'>
		          	<input type='hidden' name='old_opt_amt' >
		         	<input type='hidden' name='fee_size_1_opt_amt' value='<%=fee_size_1_opt_amt%>'>  <!--?????????? ?????????????? ?????? ???? ???? -->
		           	<input type='hidden' name='fee_size_1_end_dt' value='<%=fee_size_1_end_dt%>'>
		          	<input type='hidden' name='s_opt_end_dt' value='<%=s_opt_end_dt%>'>
		 			<tr>	         	
		 	 	     <td class='title' width="12%">??????????</td>
		             <td width="12%">&nbsp;<input type='text' name='opt_per' readonly value='<%=f_opt_per%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title' width="12%">??????????</td>
		             <td colspan=2 width="26%">&nbsp;<input type='text' name='opt_amt'size='13' class='num' readonly value="<%=AddUtil.parseDecimal(s_opt_amt)%>" onBlur='javascript:this.value=parseDecimal(this.value); set_sui_c_amt();'>&nbsp;(VAT????)</td> 
		       
		             <td class='title' width="13%">????????</td>
		             <td colspan=2 width="22%" >&nbsp;
		              <select name="sui_st" onChange='javascript:set_sui_c_amt()'>		               
		                  <option value="N" selected>??????</option>
		              </select> </td>
                  </tr>	
                  
                   <input type='hidden' name='sui_d1_amt' >
                   <input type='hidden' name='sui_d2_amt' >
                   <input type='hidden' name='sui_d3_amt' >
                   <input type='hidden' name='sui_d4_amt' >
                   <input type='hidden' name='sui_d5_amt' >
                   <input type='hidden' name='sui_d6_amt' >
                   <input type='hidden' name='sui_d7_amt' >
                   <input type='hidden' name='sui_d8_amt' >
                   <input type='hidden' name='sui_d_amt' >
                 
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
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		    
			<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 
			            <td width='13%' class='title'>????????</td>
			            <td width="20%">&nbsp;<input type="radio" name="reco_st" value="Y" checked onClick='javascript:cls_display2()'>????
	                            <input type="radio" name="reco_st" value="N"  onClick='javascript:cls_display2()'>??????</td>
	                    <td width='13%' class='title'>????</td>
	                    
	                    <td id=td_ret1 style="display:''">&nbsp; 
						  <select name="reco_d1_st" >
						    <option value="">---????---</option>
			                <option value="1">????????</option>
			                <option value="2">????????</option>
			                <option value="3">????????</option>
			               </select>       
			            </td>
			            
			            <td id=td_ret2 style='display:none'>&nbsp; 
						  <select name="reco_d2_st" >
						    <option value="">---????---</option>
						    <option value="1">????</option>
						    <option value="2">????</option>
						    <option value="3">????</option>
						   </select>       
			            </td>
			            
			            <td class='title' width='13%' >????</td>
						<td>&nbsp;
						<input type="text" name="reco_cau" size=30 maxlength=100 >
						</td>				        		         
		         </tr>
		                   
		         <tr>      
		            <td width='10%' class='title'>????????</td>
		            <td>&nbsp;
					  <input type='text' name='reco_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		            <td width='10%' class='title'>??????????</td>
		            <td>&nbsp;
					  <select name='reco_id'>
		                <option value="">????</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>
		            </td>
		            <td width='10%' class='title'>????????</td>
		            <td>&nbsp;
					  <input type='text' name='ip_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		          </tr>
		          
		          <tr>      
		            <td width='10%' class='title'>????????</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'></td>
		            </td>
		            <td width='10%' class='title'>????????</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'></td>
		            </td>
		            <td width='10%' class='title'>??????</td>
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
		                  <td class='title' rowspan="7" width=4%>??<br>
		                    ??<br>
		                    ??<br>
		                    ??</td>
		                  <td class='title' colspan="2">??????(A)</td>
		                  <td class='title' > 
		                    <input type='text' name='grt_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td class='title'>&nbsp;</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3" width=4%>??<br>
		                    ??<br>
		                    ??<br>
		                    ??<br>
		                    ??</td>
		                  <td width="14%" align="center" >????????</td>
		                  <td align="center"> 
		                    <input type='text' size='3' name='ifee_mon' readonly  value='' class='num' maxlength='4' >
		                    ????&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='' class='num' maxlength='4' >
		                    ??</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >????????</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td>=????????????????????</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>???? ??????????(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td class='title'>=??????????-????????</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">??<br>
		                    ??<br>
		                    ??</td>
		                  <td align='center'>???????? </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=????????????????</td>
		                </tr>
		                <tr> 
		                  <td align='center'>?????? ???????? </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=????????????????????</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>???? ??????(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td class='title'>=??????-?????? ????????</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">??</td>
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
    <!-- ?????????? ?????? ???? ????  
   	<tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10%>??????????</td>
                    <td width=13%>&nbsp;<input type='text' name='ex_ip_amt'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);' > ??</td>
                    <td class=title width=10%>??????</td>
				    <td width=10%>&nbsp;<input type='text' name='ex_ip_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
				    <td class=title width=10%>????????</td>
				    <td width=10%>&nbsp;<select name='bank_code' onChange='javascript:change_bank()'>
                      <option value=''>????</option>
                      <%if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];	%>
                      <option value='<%= bank.getCode()%>:<%= bank.getNm()%>'><%= bank.getNm()%></option>
                      <%	}
					}	%>
                    </select>&nbsp;</td>
                    <td class=title width=10%>????????</td>
		            <td>&nbsp;<select name='deposit_no'>
		                      <option value=''>?????? ??????????</option>
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
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>???????? ????</span>[??????]</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    
    <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
              <td class="title" colspan="4" rowspan=2>????</td>
              <td class="title" width='38%' colspan=2>????</td>        
              <td class="title" width='40%' rowspan=2>????</td>
            </tr>
            <tr>                 
              <td class="title"'> ????????</td>
              <td class="title"'> ????????</td>
            </tr>
            <tr> 
              <td class="title" rowspan="19" width="4%">??<br>
                ??<br>
                ??<br>
                ??<br>
                ??</td>
              <td class="title" colspan="3">??????/??????(D)</td>
              <td align="center" class="title"> 
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>' size='15' class='num' ></td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>'  size='15' class='num'  ></td>
              <td class="title"><font color="#66CCFF"><%=base1.get("FINE_CNT")%>??</font></td>
             </tr>
             <tr> 
              <td class="title" colspan="3">??????????????????(E)</td>
              <td width='19%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>' size='15' class='num' ></td>
              <td width='19%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>'  size='15' class='num'  ></td>                   
              <td width='40%' class="title"><font color="#66CCFF"><%=base1.get("SERV_CNT")%>??</font></td>
            </tr>
            <tr>
              <td class="title" rowspan="4" width="4%"><br>
                ??<br>
                ??<br>
                ??</td>
              <td align="center" colspan="2" class="title">??????</td>   
               <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
                <input type='text' name='ex_di_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' ></td>
              <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>              
            
              <td>&nbsp; </td>
            </tr>
          
            <tr> 
              <td rowspan="2" align="center" class="title" width="4%">??<br>
                ??</td>
              <td width='10%' align="center" class="title">????</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' size='3' name='nfee_mon'  value='<%=AddUtil.parseInt((String)base1.get("S_MON"))%>' readonly class='num' maxlength='4' >
                ????&nbsp;&nbsp;&nbsp; 
                <input type='text' size='3' name='nfee_day'  value='<%=AddUtil.parseInt((String)base1.get("S_DAY"))%>' readonly class='num' maxlength='4' >
                ??</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" class="title">????</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt'  readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' ></td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>  
              <td>?????????????? ???? ???? ?????????? ????
               </td>
            </tr>      
           
            <tr> 
              <td class="title" colspan="2">????(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt'  readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly  class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
              
                 <td class='title'>&nbsp;=?????? + ????</td>
            </tr>
                <input type='hidden' size='15' name='d_amt' value='' readonly class='num' >
                <input type='hidden' size='15' name='d_amt_1' readonly value='' class='num' >  
         
            <tr> 
              <td rowspan="6" class="title">??<br>
                ??<br>
                ??<br>
                ??<br>
                ??<br>
                ??<br>
                ??</td>
              <td align="center" colspan="2" class="title">??????????</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base1.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=??????+????????????</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">????????(????)</td>
              <td class='' colspan=2 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=????????????????????</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">????????????????</td>
              <td class=''  colspan=2  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=rcon_mon%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                ????&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day' readonly size='3' value='<%=rcon_day%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                ??</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">???????? ?????? ????</td>
              <td class=''  colspan=2 align="center"> 
                <input type='text' name='trfee_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> ?????? 
                ????????</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int' readonly value='<%=base1.get("CLS_R_PER")%>' size='5' class='num'  maxlength='5'>
                %</td>
                <td class=''  align="center"> 
                <input type='text' name='dft_int_1' value='<%=base1.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='5'>
                %</td>
           
              <td>?????? ?????????? ???????? ????</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">??????????????(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='' ></td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' size='15' class='num' value='' onBlur='javascript:set_cls_amt(this)'></td>
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                <td class="title">&nbsp;<input type='hidden' name='tax_chk0' value='N' ><!--??????????????--></td>
            </tr>      
       
            <tr> 
              <td class="title" rowspan="6"><br>
                ??<br>
                ??</td>
              <td colspan="2" align="center" class="title">??????(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' ></td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>
             
              <td class='title'>&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">????????????????(I)</td>
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
              <td class="title" colspan="2">????????????????(J)</td>
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
              <td colspan="2" class="title">????????????(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">??????????????(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;
              <font color="#FF0000">*</font>??????????????:&nbsp;<input type='text' class='num' name='car_ja' size='7' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' readonly ><input type='hidden' name='tax_chk3' value='N' ><input type='hidden' name='tax_chk3' value='N' ><!--??????????????--></td>
            </tr>
               <tr> 
              <td class="title" colspan="2">??????????????(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1'  readonly  value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                  <input type='hidden' name='tax_chk4'  value=''>
                 <td class="title">&nbsp;<!--<input type='checkbox' name='tax_chk4' value='Y' onClick="javascript:set_vat_amt(this);">??????????????--></td>
            </tr>       
            <tr> 
              <td class="title" colspan="3">??????(N)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='' readonly size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='' readonly size='15' class='num' ></td>  
              <td > 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td id=td_cancel_n style="display:''" class="title">=(F+M-B-C)??10%  </td>
                    <td id=td_cancel_y style='display:none' class='title'>=(F+M-B-C)??10%  </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr> 
              <td class="title_p" colspan="4">??</td>
              <td class='title_p' align="center"> 
	               <input type='text' name='fdft_amt1' value='' readonly  size='15' class='num' ></td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='' readonly  size='15' class='num' ></td>  
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M+N)&nbsp;&nbsp;
               <br>?? ??????:&nbsp;             
                <input type="radio" name="tax_reg_gu" value="N" checked >??????????????
                <input type="radio" name="tax_reg_gu" value="Y" >??????????????(1??)
               
            </tr>
          </table>
        </td>
         
    </tr>
    <tr></tr><tr></tr><tr></tr>
    
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >????????????</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2'  size='15' class='num' readonly  ></td>
                        <% if ( h_cms.get("CBNO") == null  ) {%>
	                    <td colspan=6 width=60%>&nbsp;?? ???????????? - ??????????</td>
	                    <% } else { %>                  
	                  	<td class=title width='12%'></td>
	                 	<td>&nbsp;?? ???????????? - ??????????</td>    
	                 	<td colspan=4 width=30%>&nbsp;<input type='checkbox' name='cms_after' value='Y' ><font color="red">CMS ?????? ????</font></td>   	                    	
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
                    <td  class=title width=10%>??????????<br>??????</td>
                    <td  width=12%>&nbsp;
						  <select name='dly_saction_id'>
			                <option value="">--????--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>?????? ????????</td>
                    <td colspan=3>&nbsp;<textarea name="dly_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
			
                </tr>
                <tr>
             		<td  class=title width=10%>??????????????<br>???? ??????</td>
                    <td  width=12%>&nbsp;
						  <select name='dft_saction_id'>
			                <option value="">--????--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>??????????????<br>????????</td>
                    <td colspan=3>&nbsp;<textarea name="dft_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
				   
                </tr>
                <tr>
                	<td  class=title width=10%>??????????????</td>
                    <td  width=12%>&nbsp;
						  <select name='d_saction_id'>
			                <option value="">--????--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>???????? ????</td>
                    <td colspan=3>&nbsp;<textarea name="d_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
				  
                </tr>
              </table>
         </td>       
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ???????? ???????? ???? ?????????? ?????? ?????????? ?????? ?????? ??????. ?????? ?????????????? ???? ?????? ??????????????.</td>
    </tr>
    
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_sale style='display:none'> 
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >??????????<br>????????????</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt3'  size='15' class='num' readonly  ></td>
                    <td colspan=6>&nbsp;?? ????????????  + ?????????? + ????????????(?????? ????)</td>
              </tr>
                       
              </table>
         </td>       
    <tr>
  
      <tr>
        <td>&nbsp;</td>
    </tr>
         
   <!-- ???????????? ????  block none  ?????????? 2???????? ?????? ????  -->
    
   	<tr id=tr_cal_sale style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td height=22><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>???? ?????? </span></td>
 	 		 <td align="right">&nbsp;<a href='javascript:cal_rc_rest()' onMouseOver="window.status=''; return true" title="??????????"><img src="/acar/images/center/button_hj_bill.gif" align=absmiddle border="0"></a>&nbsp;&nbsp;</td>
 	 	  </tr>
 	 	    
 	 	  <tr>
      		 <td colspan="2" class=line2></td>
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
              <td class="title"  width='16%' colspan=2>???????? ???? ????????<br>(??????: ?? <%=em_bean.getA_f()%>%)</td>             
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
             
<!-- scd_fee???? ?????? ???????? ???? --> 
              
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
                    <td colspan="2" class=title>????</td>
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
        
    <!-- ???????????????? ????  block none-->  
    <tr id=tr_over style="display:<%if( fee.getRent_way().equals("1")  ){%>''<%}else{%>none<%}%>"> 
  
   	    <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> ????/???????? ??????[??????]</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	 	 	
 	 	   <tr> 
 	      <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="5"  width='34%'>????</td>
              <td class="title" width='20%'>????</td>                
              <td class="title" width='46%'>????</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="7" >??<br>??<br>??<br>??</td>   
              <td class="title"  rowspan=4>??<br>??</td>
              <td class="title"  colspan=3>????????</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
              <td align="left" >&nbsp;????????????</td>
             </tr>
             <tr> 
              <td class="title" rowspan=3>????<br>????<br>????</td>
              <td class="title"  colspan=2>???????????? (??)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title" rowspan=2>????<br>(1km) </td>
              <td class="title" >?????????? (a1)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getRtn_run_amt() )%>??</td>
              <td align="left" >&nbsp;???????? ????????</td>
             </tr>            
             <tr> 
              <td class="title" >??????????????(a2)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>??</td>
               <td align="left" >&nbsp;???????? ????????</td>
            </tr>           
            <tr> 
              <td class="title"  rowspan=3>??<br>??</td>
              <td class="title"  rowspan=2>????<br>????</td>  
              <td class="title"  colspan=2 >??????????	</td>     
              <td align="center">&nbsp;</td>
              <td align="left" >&nbsp;????????????</td>
            </tr>   
            <tr> 
              <td class="title"  colspan=2 >??????????	(??)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("RENT_DAYS")))%>' size='7' class='whitenum' > ?? </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title"  colspan=3 >????????(????)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(??)x(??) / 365</td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >??<br>??<br>??<br>??</td>      
              <td class="title"  rowspan=3>??<br>??</td>
              <td class="title"  colspan=3 >??????????????(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value = '<%=AddUtil.parseDecimal(car1.getSh_km() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;????(???? ???????? ????????) , ?????? (???????? ?????? ????????)</td>
             </tr>   
             <tr> 
              <td class="title"  colspan=3>??????????????(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title"  colspan=3 >??????????(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
             <tr> 
              <td class="title"  rowspan=3>??<br>??</td>
              <td class="title"   colspan=3 >????????????????	(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly    size='7' class='whitenum' > km</td> 
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
             <tr> 
              <td class="title"   colspan=3 >????????????</td>
                <% if (  AddUtil.parseInt(base.getRent_dt()) > 20220414 ) { %>             
              <td align="right" >&nbsp;??1,000 km</td>
            <% } else { %>
              <td align="right" >&nbsp;1,000 km</td>
            <% }  %>  
                <td align="left" >&nbsp;<input type='hidden' name='add_dist'  readonly class='whitenum' > </td>
             </tr>      
              <tr> 
              <td class="title"  colspan=3 >??????????????????????	(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly    size='7' class='whitenum' > km</td>
                 <% if (  AddUtil.parseInt(base.getRent_dt())  > 20220414 ) { %>  
              <td align="left" >&nbsp;(g)?? ??1,000km ???????? ??????(0km) , (g)??  ??1,000km?? ?????? (g)?????????????? </td>
                <% } else { %>
               <td align="left" >&nbsp;</td> 
                <% }  %>           
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>??<br>??<br>??</td>
              <td class="title"  rowspan=2>??<br>??</td>
              <td class="title"  colspan=3 >????????(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly    size='10' class='whitenum' >??</td>
              <td align="left" >&nbsp;(b)??  0km ???????? (a1)*(b), (b)?? 1km???????? (a2)*(b)</td>
             </tr>
             <tr> 
              <td class="title"   colspan=3 >??????(i)</td>
              <td align="right"><input type='text' name='m_over_amt'   size='10' class='num'   onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> ??</td>
              <td align="left" >&nbsp;????????????:
              	   <select name='m_saction_id'>
			                <option value="">--????--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
					 </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="m_reason" cols="55" class="text" style="IME-MODE: active" rows="2"></textarea> </td>
             </tr>      
             <tr> 
              <td class="title"  colspan=4 >????(????/????????)????</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly    size='10' class='whitenum' >??</td>
              <td align="left" >&nbsp;=(h)-(i), ????(-)</td>
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
    
   
<!-- ?????? ???? ?????? ???? -->
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
                    <td class=title width=12%>????????</td>
                    <td class=title width=13%>????????</td>
                    <td width=12%>&nbsp;<input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td class=title width=12%>????????</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_c_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'></td>
                    <td class=title width=12%>????????</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_j_amt' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                </tr>
                <!-- ?????????????? -->
<% if(gur_size > 0){
				for(int i = 0 ; i < gur_size ; i++){
					Hashtable gur = (Hashtable)gurs.elementAt(i); %>       
				                
                <tr>
                  <%if (i == 0 ) { %> <td class=title width=12% rowspan=<%=gur_size%>>????????</td> <% } %>
                    <td class=title width=13%>????????</td>
                    <td width=12%>&nbsp;<input type='text' name='gu_st'  size='15' class='text' > </td>
                    <td class=title width=12%>??????????</td>
                    <td width=13%>&nbsp;<input type='text' name='gu_nm' value='<%=gur.get("GUR_NM")%>' size='15' class='text' > </td>
                    <td class=title width=12%>????????????</td>
                    <td width=13%>&nbsp;<input type='text' name='gu_rel' value='<%=gur.get("GUR_REL")%>' size='15' class='text' ></td>
                </tr>
             <% }
  }             %> 
                <tr>
                    <td class=title width=12%>??????????????</td>
                    <td class=title width=13%>??????</td>
                    <td width=17%>&nbsp;<input type='text' name='c_ins'  size='18' class='text' > </td>
                    <td class=title width=12%>??????</td>
                    <td width=17%>&nbsp;<input type='text' name='c_ins_d_nm'  size='18' class='text' > </td>
                    <td class=title width=12%>??????</td>
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
     
    <!-- ?????????? ???? ???? -->
     
    <tr id=tr_cre style="display:''"> 
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
	                    <td class=title width=75%>????????/????????/????</td>
	                  
	                </tr>
	                <tr>
	                    <td class=title width=12%>????????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu1">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" >??</option>
		                      <option value="N" >??????</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark1' size='120' class='text' ></td>
	                 
	                </tr>
	                <tr>
	                    <td class=title>??????????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu2">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" >??</option>
		                      <option value="N" >??????</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark2' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>????????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu3">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" >??</option>
		                      <option value="N" >??????</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark3' size='120' class='text' ></td>
	                   
	                </tr>
	                <tr>
	                    <td class=title>??????????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu4">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" >??</option>
		                      <option value="N" >??????</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark4' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu5">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" >??</option>
		                      <option value="N" >??????</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark5' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>????????</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu6">
	                          <option value="" selected>-????-</option>
		                      <option value="Y" >??</option>
		                      <option value="N" >??????</option>
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
	                    <td class=title width=12%>??????</td>
	                    <td width=13%>&nbsp;
							  <select name='crd_id'>
				                <option value="">????</option>
				                <%	if(user_size > 0){
										for(int i = 0 ; i < user_size ; i++){
											Hashtable user = (Hashtable)users.elementAt(i); %>
				               	<option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
				  
				                <%		}
									}%>
				              </select>
				        </td>
	                    <td class=title width=12%>????</td>
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
       	      
	<!-- ?????????? ???? ???? -->
    <tr id=tr_get style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>?????? ??????</span></td>
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
					                <option value="1">??????</option>
					                <option value="2">????</option>
					              </select>             
					              <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                        <tr> 
					                         
					                           <td id='td_div' style='display:none'>&nbsp;????????&nbsp;  
					                             <select name="div_cnt">
												    <option value="">---????---</option>
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
			                    <td class=title width=13%>????</td>
			                    <td class=title width=12%>??????</td>
			                    <td>&nbsp;<input type='text' name='est_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
			                    <td class=title width=12%>????????</td>
			                    <td>&nbsp;<input type='text' name='est_amt' size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
			                    <td class=title width=12%>??????</td>
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
									         <td class=title width=13%>??????????</td>
									         <td width=12%>&nbsp;<input type='text' name='gur_nm' size='15' class='text'></td>
						                     <td width=12% class=title>??????</td>
						                     <td>&nbsp;<input type='text' name='gur_rel_tel' size='30' class='text'></td>
						                     <td width=12% class=title>??????????????</td>  
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
					                    <td class=title style='height:44' width=13%>????????/????????/<br>????</td>
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
		var v_rifee_s_amt = 0;  // ?????????? ????
		var v_ifee_ex_amt = 0;  //?????????? ????????
		var  re_nfee_amt = 0;  //???????? ?????????? ???? ?????? ?????? ???? ???? check
 		var  santafe_amt = 0; 
 		
		fm.cls_msg.value="";
 		//?????????? ???? ????		
		if(fm.r_day.value == '30'){
			fm.r_mon.value = toInt(fm.r_mon.value) + 1;
			fm.r_day.value = '0';			
		}
		
		//0 ???? ???? ????	
		if(toInt(fm.r_day.value)  <0){
			fm.r_day.value = '0';			
		}	 
 			 				
 		if(toInt(fm.nfee_day.value)  <0){
			fm.nfee_day.value = '0';			
		}		    
				 				
		//???????? ?????????????? ?? ???? ???????? setting
		if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //???????? 
			fm.cancel_yn.value = 'N';
			td_cancel_n.style.display 		= 'none';  //????????
			td_cancel_y.style.display 		= '';  //????????
		}
				
			//?????????? ???? ???????? setting
		if ( fm.cls_st.value == '8') { //???????? 
			fm.cancel_yn.value = 'N';
			td_cancel_n.style.display 		= 'none';  //????????
			td_cancel_y.style.display 		= '';  //????????
			tr_sale.style.display 		= '';  //?????????? ????????????	
		}
		
		//?????????????? 2 ?????? - 50% ???? , 3???? ????????
		if ( fm.agree_yn.value == '2'   ||  fm.agree_yn.value == '3'  ) {	
			if ( <%= o_amt%> > 0   ) {
		
				tr_over.style.display 		= '';  //??????????????
								
				if (<%=car1.getOver_bas_km()%>  > 0 ) {
					 fm.first_dist.value='<%=car1.getOver_bas_km()%>';	
				} else {
					 fm.first_dist.value='<%=car1.getSh_km()%>';	
				}	
								
				fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.first_dist.value))   );	
			}
		}		
		//?????? ?????????? 
		fm.remark.value="????????";						
		<% if  ( fuel_cnt > 0) { %>   
		 <%    if ( return_remark.equals("??????") ) {%>  				 	
				 	 		fm.cls_cau.value = "?????? ???????? ???? ????. ????????";
				 	 		fm.etc3_amt_1.value = '-400,000';
		 <%    } else if ( return_remark.equals("????") ) {%> 		 				
				 	 		fm.cls_cau.value = "???? ???????? ???? ????. ????????";
				 	 		fm.etc3_amt_1.value = '<%=return_amt %>';
				 	 		fm.etc3_amt_1.value =  parseDecimal(  toInt(parseDigit(fm.etc3_amt_1.value)) * (-1)  );	
 		 <%    } else if ( return_remark.equals("????") ) {%> 		 				
				 		fm.cls_cau.value = "???? ???????? ???? ????. ????????";
				 		fm.etc3_amt_1.value = '<%=return_amt %>';
				 		fm.etc3_amt_1.value =  parseDecimal(  toInt(parseDigit(fm.etc3_amt_1.value)) * (-1)  );	  
		 <%    } else if ( return_remark.equals("????") ) {%> 		 				
					 		fm.cls_cau.value = "???? ???????? ???? ????. ????????";
					 		fm.etc3_amt_1.value = '-520,000';					 		 		
	      	<% }%> 	 	 	 		
 	 	<% }  else { %> 
	 		fm.cls_cau.value="????????";
	 		fm.opt_amt.value = fm.mopt_amt.value;
	 		fm.t_cal_days.value = '0';
 		<% }%> 	 
 					
		//?????????????? 
		if(toInt(fm.ifee_s_amt.value)  != 0){		
	//	if(fm.ifee_s_amt.value != '0'){
		//	ifee_tm = parseDecimal((toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			ifee_tm = Math.round(( toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			pay_tm =  parseDecimal(toInt(fm.con_mon.value)-ifee_tm) ;
			
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
				fm.ifee_day.value 	= fm.r_day.value;
						
			} else {
			   	 fm.ifee_mon.value = "0";  //??????
		   		 fm.ifee_day.value  = "0";			
			}
		
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
											
			v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //????????
			v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //????
			
		    if (v_rifee_s_amt == -1 || v_rifee_s_amt == 1 ) v_rifee_s_amt = 0;  //????
		    
		   	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //????????  - ?????????? ???? ?? ??????
		    		
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 		    		
		    		v_rifee_s_amt = 0;		    		
		   	} 
		  		   
		   //?????????? ?????? ???? ???? ???????? ???? 			  		   	
		   	if ( v_rifee_s_amt == 0) { //???????? 
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 
		    		v_rifee_s_amt = 0;	  
	    	}	
		}
		
		//???????????? ???????? ???????? ???? ?????? ???? ???? - 20100924 ????
		if(toInt(fm.ifee_s_amt.value)  != 0){		
		//if(fm.ifee_s_amt.value != '0'){
			if ( toInt(fm.rent_end_dt.value) == toInt(fm.use_e_dt.value) ) {
		   		   if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //?????? ?????? ???????? ???? ????
		   		   		fm.ifee_mon.value 	= '';
						fm.ifee_day.value 	= '';	
		   		   		fm.ifee_ex_amt.value = '0';
		   		   		fm.rifee_s_amt.value = parseDecimal(fm.ifee_s_amt.value) ; 
		   		   }
		   	} 
	    }

		//???????????  fm.mt.value
		if(toInt(fm.pp_s_amt.value)  != 0){				
	//	if(fm.pp_s_amt.value != '0'){	
			
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //??????
	    		
	    	   fm.pded_s_amt.value 	= 0;
			   fm.tpded_s_amt.value 	= 0;
			   fm.rfee_s_amt.value 	= 0;
	    	} else { 
		
				fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.lfee_mon.value) );
				fm.rfee_s_amt.value     = parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );  //???????????????? ???? - 20190827
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) ); 
	    	}						
		//	fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.m_mon.value)+toInt(fm.m_day.value)/30) );
		//	fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value)) 
		}
		
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // ?????????? ?????? ???? (?????????? ?????? ????)
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
		
		//?????????? ????
		//??????, ???????????? ???? ???? ???? -  ???? ?? ???????????? - ?????? 0???? ????, ?????? ???????? ?????? ???? ????????  ???? ???? 
		if ( fm.cls_st.value == '8') { //???????? 
	    	 if  ( toInt(fm.fee_size.value) < 2 ) { //?????? ?????? 	 - ?????? 0????	
	    		   fm.ifee_mon.value = '';  //??????
			   	   fm.ifee_day.value  = '';			
				   fm.ifee_ex_amt.value = 0;
		    	   fm.rifee_s_amt.value = 0; 
		    	   v_rifee_s_amt = 0;	  
	    		   fm.pded_s_amt.value 	= 0;
				   fm.tpded_s_amt.value = 0;
				   fm.rfee_s_amt.value 	= 0;	
	    	 }
		
	    	 if ( v_rifee_s_amt > 0 ) {
	    	     alert("?????????? ?????? ????????. ?????? ?????????? !!!") ;
	  		     fm.cls_st.options[0].selected = true;
	  		     fm.cls_cau.value = "";		  		 		  		      		  
	  		 } else {		   	
	    	 	fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 		    		
	    		v_rifee_s_amt = 0;
	    	 }
		
	  		 if (toInt(parseDigit(fm.rfee_s_amt.value)) > 0 ) {
	  		     alert("?????? ?????? ????????. ?????? ?????????? !!!") ;
	  		     fm.cls_st.options[0].selected = true;
	  		     fm.cls_cau.value = "";		  		 		  		      		  
	  		 } else {		   	
	  			fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;		
	    	}			    
	   	}
						
		//???????? 
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
	   	    
		//?????????? ???? ???? ????		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}	 

		//???????????? ???? ???? 		 -- nnfee_s_amt : ????????(????????). di_amt :????????????  	  -- ?????????? ?? ????  
		if(toInt(fm.ifee_s_amt.value)  == 0){		
  	//	if(fm.ifee_s_amt.value == '0' ) {
		   	 // ?????????????? ???????? ?? ?? ???? 
		  	 		   	 
		    if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 		
		   	 	//	  alert("a");
		   	 		  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
		   	 	     		   //???????????? ?????? 
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
							
				  	   	  if ( count1 >= 0 ) { // ?????????????? ?????? ???? (???????????? ????)					  	   	
				  	   		 fm.nfee_mon.value = parseInt(count1 / 30); 
				  	   		 fm.nfee_day.value  =  parseInt(count1 % 30); 					  	 
					  	  }
		   	 		 
		   	 		  }  else  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
		   	 	//	     alert("c");
		   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // ?????? ???????????? 1?? ????
		   	 		     if ( toInt(fm.nfee_mon.value) < 0 ) {
						  	  fm.nfee_mon.value = '0';
						 }		   	 		     
		   	 		  } 
		   	 	
		   	} //???????? ????.  		  
		
		} //???????????? ???? ????	 	   		   		
		
		  
		 if (  toInt(parseDigit(fm.di_amt.value)) > 0  ) {					  
			    if ( toInt(fm.s_mon.value) - 1  >= 0 ) {
			         fm.nfee_mon.value 	= 	 toInt(fm.s_mon.value) - 1;  //?????? ???? ???????? ??????.		     
			    } 		
		 }
	   	
		 if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) {
 	   	    	if (  toInt(parseDigit(fm.di_amt.value)) > 0  &&  toInt(parseDigit(fm.nfee_amt.value)) == 0 ) {  //?????? ???? ?????? ??????   	    	 
	   	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {  //???????? ???????? ?????? ???????????? ???????? ?????? ???? - 20170324  	   	    				
	   	    				fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );  //????????  - ????????    		
			      	 	    fm.nfee_amt.value = fm.nnfee_s_amt.value;    
			      	 	    fm.ex_di_v_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_v_amt.value))  -    toInt(parseDigit(fm.rc_v_amt.value)) );  //????????  - ????????    
			      	 	   // fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
							if (fm.nfee_amt.value == '0' ) {
				 	       			fm.nfee_day.value = 0;
				 	      	}
				 	 }  
				  	
 	   	    	}	   	   	
         }  	   	
		  
		  /*
	  	 if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) {
	   	   	    	if (  toInt(parseDigit(fm.di_amt.value)) > 0 ) {  //?????? ?????? 
	   	   	    	   if ( toInt(parseDigit(fm.hs_mon.value)) < 1  &&  toInt(parseDigit(fm.hs_day.value)) < 1 ) {  // ???? ???????? ???????? ???????? ????
	   	   	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {  //???????? ???????? ?????? ???????????? ???????? ?????? ???? - 20170324
	   	   	    				
	   	   	    				 	fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );  //????????  - ????????    		
					      	 	   fm.nfee_amt.value = fm.nnfee_s_amt.value;    
					      	 	   fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
									if (fm.nfee_amt.value == '0' ) {
						 	       			fm.nfee_day.value = 0;
						 	      	}
						 	 }     		
						}
						
						 if ( toInt(parseDigit(fm.hs_mon.value)) >0  &&  toInt(parseDigit(fm.hs_day.value)) > 0 ) {  // ???? ???????? ???????? ???????? ????
					 			 fm.nfee_mon.value 	= 	 toInt(fm.hs_mon.value);  //?????? ???? ???????? ??????.
					   	    	  
					   	    	 if  ( fm.nnfee_s_amt.value  != '0' ) {
					   	    		 	  fm.nfee_day.value 	= 	 toInt(fm.hs_day.value);  //?????? ???? ???????? ??????.	
					   	    	 }						 
						 } 	       	
	   	   	    	}	   	   	
	   }  	   	 		
	   */
	//   alert("1");
	//   alert(fm.nfee_amt.value);
	    //???????? 100?????? ???? ???? ???? - 2011-01-24.	- ?????????? ????
		if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
		   if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   		fm.nfee_day.value = '0';
		   } 
			fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		} else {			
			fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		
		}
	    		    
	   	//????????????????(???? ?????? ??????)?? ???????? ???????? ???????? ???? ..		
	 	if(toInt(fm.ifee_s_amt.value)  == 0){		
	//	if (fm.ifee_s_amt.value == '0' ) {	
		   	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   	 	
		   		if ( (toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_oe_dt .value)) ||  (toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value)) ) {  //??????????  ?????????? ?????? ?????? ?????? 
		   	//	if ( toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value)  ) {  //?????????? ?????? ?????? ?????? 
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
	    				
			 // ?????????? ???? ?????? ????. (???????? ?????????? ?????? ?????? ???? )		  
	 	if(toInt(fm.ifee_s_amt.value)  != 0){	
		   	if (v_rifee_s_amt <= 0 ) {  //???????????? ?? ?????? ????  -?????????? ???? ?????? ???? 
		   	      	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
			  		
			  	   if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //???????? ?????? ???????? ?????? ???? 			  		  	     
				        if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //?????? ?????? ???????? ???? ????  
			   	          //   alert(" ?????????? ????, ?????? ?????????????? ????, ?????? ???? ???????? ???? ????");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	
			   	       	   
				  		 } else {  //?????? ???? ????  		
				  		  	  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
				  		      
				  		           var s1_str = fm.rent_end_dt.value;
								   var e1_str = fm.cls_dt.value;
								   var  count1 = 0;								
											   
									var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
									var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
							
									var diff1_date = e1_date.getTime() - s1_date.getTime();
							
									count1 = Math.floor(diff1_date/(24*60*60*1000));									
										
							  	   	if ( count1 >= 0 ) { // ?????????????? ?????? ???? (???????????? ????)					  	   	
							  	   		 fm.nfee_mon.value = parseInt(count1 / 30); 
							  	   		 fm.nfee_day.value  =  parseInt(count1 % 30); 					  	 
							  	   }
							  	   					  	   
							  	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 			  		 
				  		      }			  		
				  		}	
			  	  } else {  //?????????? ?????? ?????? ???? ????.   			  	  
			  	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //?????? ?????? ???????? ???? ????   +  ?????????? ?????? ???? 
		   		//	       alert(" ?????? ?????????????? ???? ????, ?????? ???? ???????? ???? ????");			   	    
				   	     	 var r_tm = 0;     
				   	     	 if  ( toInt(parseDigit(fm.di_amt.value)) > 0 &&  toInt(fm.s_mon.value) > 0 ) {						 
						   	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// ???????????? - ?????????? ????  , ?????? ???????????? 1?? ???? 
						//   	 } else {
						  // 	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// ???????????? - ?????????? ????   
						   	 }
				   					   				   	
						   	 fm.nfee_mon.value 	= r_tm;
						   	 fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ;	// ???????????? - ?????????? ????   
				  	
						  	 // ???????? ???????? ???? ???? - ?????????? ???? ???? 20110524						  	 
							 if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
							     if  ( fm.nfee_amt.value  != '0' ) {
								     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
								 		fm.nfee_amt.value = fm.nnfee_s_amt.value;						 		
								 	 }	
								 }	 
							 }			   	         
			   	      }else {
			   	       //    alert(" ?????? ?????????????? ???? ????, ?????? ???? ???????? ???? ????");			   	      
			   	           if ( toInt(fm.r_mon.value) > 0 ||  toInt(fm.r_day.value) > 0 ) { 
				   	       	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //???????? ????
					   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
					   	      	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30)  ) ; 
				   	   		}
				   	   }
			  	  
			  	  }
			  	  
			  }  else {  //???????????? ???? ???? (???????????? ???? )		
				  	     
				  	     if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //?????? ?????? ???????? ???? ????  
				  	     	  if ( toInt(fm.use_e_dt.value) <= toInt(replaceString("-","",fm.cls_dt.value)) ) {  // ?????????? ???????? 
				  	     	 
					  	     	   if  ( fm.nfee_amt.value  != '0' ) {
							          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
						 	       		fm.nfee_amt.value =    fm.nnfee_s_amt.value;
						 	       		if (fm.nfee_amt.value == '0' ) {
						 	       			fm.nfee_day.value = 0;
						 	       		}	
							 	       }	
							      }	
						        			  	     	 
				  	     	 }  else { 	   
				  	            
				  	            fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// ???????????? - ?????????? ????
				  	       }  
				  	     } 
				  	     
				  	     if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
				   	 		    // alert("d1");		   	 		
				   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // ?????? ???????????? 1?? ????
				   	 		     	
								  if ( toInt(fm.nfee_mon.value) < 0 ) {
								  	 	   	  fm.nfee_mon.value = '0';
								  }
						  }			
								 	 
			 } 
	 	}   
	 	
	
	 	//????????????????(???? ?????? ??????)?? ???????? ???????? ???????? ???? ..
		//?????????? ?????? ????.					 	    		   
	  if ( fm.cls_st.value == '8') { //???????? 	
            var count ;
  			var s_str = fm.rent_end_dt.value;
			var e_str = fm.cls_dt.value;
			
			var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
			var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
			
			var diff_date = s_date.getTime() - e_date.getTime();
			
			count = Math.floor(diff_date/(24*60*60*1000));
				    
		//	if (fm.ifee_s_amt.value == '0' ) {	
			if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
					if ( toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value) ) {  //?????????? ?????? ?????? ?????? 
		    	 
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
			      if (toInt(fm.fee_size.value) < 2 ) {  //???????? ?????? 
				      if  ( fm.nfee_amt.value  != '0' ) {
						     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
						 		fm.nfee_amt.value = fm.nnfee_s_amt.value;							 		
						 	 }	
			 			}	 
					} else {  //?????? ?????? 30?? ?????? ?????? ???? 
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
				 					 		
		}			
	   	   	  	
		  //?????????? ???? -  ?????????? ?????? 
		 if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
		 
		          //???? ?????????? ???? ???????? ?????? ????.
		        if ( toInt(fm.rent_end_dt.value)  != toInt(replaceString("-","",fm.cls_dt.value)) ) {
		                     
				      fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );
				      fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))   -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	
				      fm.nfee_mon.value = '0';
				      fm.nfee_day.value = '0';				      
				      fm.nfee_amt.value = '0';	
			    }	      		         
		 }
			
		fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
	
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
				
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
		fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
		
		//?????? ???? ???? ?????? ???? -- warning !!!!
			
		if(toInt(parseDigit(fm.nfee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			if ( toInt(fm.rent_end_dt.value)  < toInt(replaceString("-","",fm.cls_dt.value)) ) {	                
				//???????? 
				if( toInt(parseDigit(fm.rcon_mon.value)) < 1  && toInt(parseDigit(fm.rcon_day.value)) < 1 ){
					alert("!!!!!!!?????????? ?????????????? ????????(????)?? ????????.!!!!!!\n\n?????? ???? ???? ?????? ?????? ?????? ???? ?? ?????????? ???????? ???? ??????????!!!");		
					print_view();
				}	
			}
		}
				
		//???? ?????? ???????? ??????.	 		
		var no_v_amt = 0;
		var no_v_amt1 = 0;
		
		var  c_fee_v_amt =  0;
			
		var   c_pp_s_amt = 0;
		var   c_rfee_s_amt = 0;
		var   c_over_s_amt = 0;
		
		c_pp_s_amt   = toInt(parseDigit(fm.rfee_s_amt.value))*0.1;
		c_rfee_s_amt = toInt(parseDigit(fm.rifee_s_amt.value))*0.1;
		c_over_s_amt = toInt(parseDigit(fm.over_amt_1.value)) * 0.1;
			   
	    c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
				
		// ?????? ?????? - 20190904 - ?????? ???? ?????????? ?????? (???????? ????)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
	    	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));		   
 	    }	
		
			//?????????? ?????? ????.
		if ( fm.cls_st.value == '8') { //???????? 
			    //?????? 0
				fm.dft_amt.value 	= '0';
				fm.dft_amt_1.value 	   = '0';				 		
	   }
		 
		//???? ?????? ???????? ??????.		
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt -  c_pp_s_amt  -  c_rfee_s_amt ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt  + c_over_s_amt -  c_pp_s_amt  -  c_rfee_s_amt ;
		
	//  ?????? ???? - 20220420 ???? 
	    fm.rifee_v_amt.value = parseDecimal( c_rfee_s_amt );  //?????????? 
	    fm.rfee_v_amt.value = parseDecimal( c_pp_s_amt );    //?????? 
	    
	    fm.dfee_v_amt.value =    parseDecimal(  toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );  //???? ?????? ?????? 
	    fm.dfee_v_amt_1.value =  parseDecimal(  toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt );  //???? ?????? ?????? 
	    
	    fm.over_v_amt.value =   '0';  //???? ???????? ?????? 
	    fm.over_v_amt_1.value = parseDecimal( c_over_s_amt );  //???? ???????? ?????? 
		
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
					
		set_tax_init();
		
		/* ?????? ???? ???? - 2022-04
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
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
       */
       
        //??????????	
        fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value))  + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));
		       
		//???????? ????????
		fm.dly_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dly_amt.value))) ;
		fm.dft_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dft_amt.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)));

		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) +  toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)) );	 //????????	
		
		//?????? ?????? ???? ???? ????	(?????????????? ???? ????)
		
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
	
	//??????????
	function set_tax_init(){
		var fm = document.form1;
			
		/* 2022-04 ???????? 
			//??????????????
		if(toInt(parseDigit(fm.dft_amt.value)) > 0){
				fm.tax_g[0].value       = "???????? ??????";
				fm.tax_supply[0].value 	= fm.dft_amt.value;
				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
		}			
		
			//????????????
		if(toInt(parseDigit(fm.etc_amt.value)) > 0){
				fm.tax_g[1].value       = "???? ????????????";
		   		fm.tax_supply[1].value 	= fm.etc_amt.value;
				fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt.value)) * 0.1 );
	
		}
		
			//????????????
		if(toInt(parseDigit(fm.etc2_amt.value)) > 0){
				fm.tax_g[2].value       = "???? ????????";
		   		fm.tax_supply[2].value 	= fm.etc2_amt.value;
				fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt.value)) * 0.1 );
	
		}
		
			//??????????????
		if(toInt(parseDigit(fm.etc4_amt.value)) > 0){
				fm.tax_g[3].value       = "??????????????";
		   		fm.tax_supply[3].value 	= fm.etc4_amt.value;
				fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt.value)) * 0.1 );
	
		}
		*/
		
			//??????????????
		if(toInt(parseDigit(fm.over_amt_1.value)) > 0){
				fm.tax_g[4].value       = "??????????????";
		   		fm.tax_supply[4].value 	= fm.over_amt_1.value;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );
	
		}
	}	
//-->
</script>
</body>
</html>
