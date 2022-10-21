<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.credit.*, acar.fee.*, acar.car_sche.*, acar.doc_settle.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>

<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<%@ include file="/agent/cookies.jsp" %>

<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
		
	String dft 	= request.getParameter("dft")==null?"N":request.getParameter("dft");	
	
	String sb 	= request.getParameter("sb")==null?"N":request.getParameter("sb");	
		
//	System.out.println("lc_cls_u doc_bit = " + doc_bit);
	
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
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
	String cls_st = cls.getCls_st();
	
	if (cls.getDft_saction_id().equals("000005") && cls.getDft_saction_dt().equals("")) {
		dft = "Y";
	}	
	
	//기본정보
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls.getCls_dt(), "");
		
	//연대보증인 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;		
	
		//해지기타 추가 정보
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);
	
	//해지의뢰상계정보
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);
	
	//차량회수정보
	CarRecoBean carReco = ac_db.getCarReco(rent_mng_id, rent_l_cd);
	
	//채권관리정보
	CarCreditBean carCre = ac_db.getCarCredit(rent_mng_id, rent_l_cd);
			
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

	//마지막 세금계산서
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
	
	int re_day= ac_db.getRemainFeeDay(rent_l_cd, fee_tm, cls.getCls_dt());
	
	from_page = "/agent/cls_cont/lc_cls_u.jsp";
	
	String valus = 	"?user_id="+user_id+"&br_id="+br_id+
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
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "CLS_ETC";
	String content_seq  = rent_mng_id+""+rent_l_cd;

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;		
	
	 CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;   
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/agent/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}		
			
	
//정산서 인쇄
	function cls_print(){
		var fm = document.form1;

		var SUBWIN="lc_cls_print.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=700, height=650, resizable=yes, scrollbars=yes, status=yes");
		
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
	
	//고객 보기
	function view_client(client_id)
	{
		window.open("/agent/client/client_c.jsp?user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 보기
	function view_site(client_id, site_id)
	{
		window.open("/agent/client/client_site_i_p.jsp?user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			

	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/agent/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//대여요금
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/agent/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=50, top=50, width=850, height=675, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//결재요청
	function sac_req(){
		var fm = document.form1;
		
		fm.doc_bit.value = "1";  
		
			//해지사유
		if( replaceString(' ', '',fm.cls_cau.value) == '' ){
				alert("해지사유를 입력하셔야 합니다.!!");
				return;
		}				
					
		if( get_length(Space_All(fm.cls_cau.value)) == 0 ) {
		 		alert("해지사유를 입력하셔야 합니다.!!");
				return;
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
													
		if(confirm('결재요청하시겠습니까?')){	
			fm.action='lc_cls_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}		
	}	
	
	//결재전 삭제
	function sac_delete(doc_bit) {
		var fm = document.form1;		
		fm.doc_bit.value = doc_bit;  
			
		if(confirm('해지의뢰내역을 삭제하시겠습니까?')){	
			fm.action='lc_cls_d_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}	
		
	}	
			
	function save(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('해지구분을 선택하십시오'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('해지일자를 입력하십시오'); 		fm.cls_dt.focus(); 		return;	}				
						
		if( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ){		
			if(fm.est_dt.value == '')				{ alert('약정일자를 입력하십시오'); 		fm.est_dt.focus(); 		return;	}		
		}
		
		//고객에게 받을 돈이 있는 경우 - 자구책 check					
		
		   if ( fm.cls_st.value == '7' || fm.cls_st.value == '10') {
		   
		   }else {	
				//차량회수 여부 및 회수일자, 입고일자 등 check
				if(fm.reco_st[0].checked == true){  //회수 선택시 - 회수형태 및 회수일, 입고일 check
					 if(fm.reco_d1_st.value == "") {
					 		alert("회수구분을 선택하셔야 합니다.!!");
							return;
					 }	
					  
					 if ( fm.cls_st.value != '8') {	
							if(fm.reco_dt.value == '')				{ alert('회수일자를 입력하십시오'); 		fm.reco_dt.focus(); 	return;	}
							if(fm.ip_dt.value == '')				{ alert('입고일자를 입력하십시오'); 		fm.ip_dt.focus(); 		return;	}
					 }
			
				} else {
				  if(fm.reco_d2_st.value == "") {
				 		alert("미회수구분을 선택하셔야 합니다.!!");
						return;
				  }		
				}
		  }		
					
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
							
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_cls_u_a.jsp';	

			fm.target='d_content';
			fm.submit();
		}		

	}
	
	//디스플레이 타입
	function cls_display(){
		var fm = document.form1;
	
		fm.fdft_amt3.value='0';
		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '7'){ //출고전해지(신차) 선택시 디스플레이
		 		
			tr_ret.style.display		= 'none';	//차량회수	
			tr_gur.style.display		= 'none';	//채권관계		
			tr_sale.style.display		= 'none';	//차량매각시 고객납입액				
		}else{
			
			tr_ret.style.display		= '';	//차량회수	
			tr_gur.style.display		= '';	//채권관계		
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
	 	 
	    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //만기일
	    		
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
	    }	
			
	
		set_cls_s_amt();
	}	
	
	//미납 대여료 정산 : 자동계산
	function set_cls_amt2(obj){
		var fm = document.form1;
								
		obj.value=parseDecimal(obj.value);	
					
			//과부족 및 과입금관련 vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} else { 					
		    fm.ex_di_v_amt_1.value		=  ( ( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) ) * 0.1 ) -  ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) ;
		} 
	
		var no_v_amt = 0;
		var   c_pp_s_amt = 0;
		var   c_rfee_s_amt = 0;
				
		c_pp_s_amt = toInt(parseDigit(fm.rfee_s_amt.value))*0.1;
		c_rfee_s_amt = toInt(parseDigit(fm.rifee_s_amt.value)) *0.1;
				
	   if ( fm.cls_st.value == '7'  ||  fm.cls_st.value == '10' ) {  //출고전해지. 개시전해지 - 계산시 부가세 틀린경우가 있음 	       
	       c_pp_s_amt =  toInt(parseDigit(fm.pp_amt.value)) -  toInt(parseDigit(fm.pp_s_amt.value)); 
	   	    c_rfee_s_amt = toInt(parseDigit(fm.ifee_amt.value)) -  toInt(parseDigit(fm.ifee_s_amt.value)); 
	   }
						
		//각각 부가세 계산하여 더한다.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) - c_pp_s_amt - c_rfee_s_amt ;
		
		fm.rifee_v_amt.value = c_rfee_s_amt;  //개시대여료 
	    fm.rfee_v_amt.value = c_pp_s_amt;    //선납금 
	    
	  //  fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + (toInt(parseDigit(fm.nfee_amt.value)) * 0.1);  //당초 대여료 부가세 
	    fm.dfee_v_amt_1.value = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1); //확정 대여료 부가세 
	  							  	
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
	
		set_cls_s_amt();
	}		
			
	//미납 중도해지위약금 정산 : 자동계산
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //잔여대여계약기간
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			}
		}else if(obj == fm.dft_int_1){ //위약금 적용요율
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int_1.value)/100) );
			
			}			
		}
				
		set_cls_s_amt();
	}
							
	//확정금액 셋팅
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		
		//과부족 및 과입금관련 vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} else { 					
		   fm.ex_di_v_amt_1.value		=  ( ( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) ) * 0.1 ) -  ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) ;
		} 			
						
		var no_v_amt = 0;
		
		//각각 부가세 계산하여 더한다.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value = c_rfee_s_amt;  //개시대여료 
		fm.rfee_v_amt.value = c_pp_s_amt;    //선납금 
		    
	//	fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + (toInt(parseDigit(fm.nfee_amt.value)) * 0.1);  //당초 대여료 부가세 
		fm.dfee_v_amt_1.value =toInt(parseDigit(fm.ex_di_v_amt_1.value)) + (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1);  //확정 대여료 부가세 
		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt) );				
			
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
		
		fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))   + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))   + toInt(parseDigit(fm.no_v_amt_1.value)));	 //확정금액	
	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
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
	
		
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='lc_cls_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	//은행선택시 계좌번호 가져오기
	function change_bank(){
		var fm = document.form1;
		//은행
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
				
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('선택', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/agent/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
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
	//조회하기
	function ven_search(idx){
		var fm = document.form1;
		window.open("/agent/con_debt/vendor_list.jsp?idx="+idx, "VENDOR_LIST", "left=50, top=50, width=500, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
	function update(st){
		var fm = document.form1;
		
		if (st == 'cls_tax') {	
			window.open("/agent/cls_cont/updateClsTax.jsp?<%=valus%>", "CHANGE_ITEM", "left= 50, top=50, width=1050, height=800, resizable=yes, scrollbars=yes, status=yes");					
		} else if (st == 'tr_cre') {	
			window.open("/agent/cls_cont/updateTrCre.jsp?<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=970, height=450, resizable=yes, scrollbars=yes, status=yes");
					
		} else {
			window.open("/agent/cls_cont/updateTrGet.jsp<%=valus%>", "CHANGE_ITEM", "left=50, top=100, width=970, height=450, resizable=yes, scrollbars=yes, status=yes");
		}		
	}
	
		//스캔등록
	function scan_reg(gubun){
		window.open("reg_scan.jsp?gubun="+gubun+"&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	//스캔삭제
	function scan_del(gubun){
		var theForm = document.form1;
		if(!confirm('삭제하시겠습니까?')){		return;	}
		theForm.target = "i_no"
		theForm.action = "del_scan_a.jsp?gubun="+gubun;
		theForm.submit();
	}
	
		//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/cls/"+theURL;
		window.open(theURL,winName,features);
	}
	
	//중도해지 위약금 결재
	function dft_sanction() {
		var fm = document.form1;
					
		if(confirm('결재하시겠습니까?')){	
			fm.action='lc_cls_dft_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}	
		
	}
	
	
	//출고전해지 지점장 결재
	function sb_sanction() {
		var fm = document.form1;
					
		if(confirm('결재하시겠습니까?')){	
			fm.action='lc_cls_sb_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}	
		
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
		window.open("/agent/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
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
<input type='hidden' name="mode" 			value="<%=mode%>">     
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 
<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'> 
<input type='hidden' name='car_no' value='<%=base1.get("CAR_NO")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
				
<input type='hidden' name='con_mon' value='<%=base1.get("CON_MON")%>'>
<input type='hidden' name="doc_bit" 		value="">              
  
<input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
<input type='hidden' name="from_page" 	value="<%=from_page%>">

<input type='hidden' name='cls_s_amt' value='<%=AddUtil.parseDecimal(cls.getCls_s_amt())%>' >
<input type='hidden' name='cls_v_amt' value='<%=AddUtil.parseDecimal(cls.getCls_v_amt())%>' >
          
<input type='hidden' name='bank_code2' value='<%=clsm.getEx_ip_bank()%>'>
<input type='hidden' name='deposit_no2' value='<%=clsm.getEx_ip_bank_no()%>'>
<input type='hidden' name='bank_name' value=''>
  
<input type='hidden' name="re_day" 		value="<%=re_day%>">  
<input type='hidden' name='car_ja_no_amt' value='<%=AddUtil.parseDecimal(cls.getCar_ja_no_amt())%>' >
 
<input type='hidden' name='ex_di_v_amt'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
<input type='hidden' name='ex_di_v_amt_1' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--만기일기준 경과계약기간 -->    

<input type='hidden' name='rifee_v_amt' value='<%=cls.getRifee_v_amt()%>'> <!-- 부가세 관련  -->
<input type='hidden' name='rfee_v_amt' value='<%=cls.getRfee_v_amt()%>'>
<input type='hidden' name='dfee_v_amt' value='<%=cls.getDfee_v_amt()%>'>
<input type='hidden' name='dfee_v_amt_1' value='<%=cls.getDfee_v_amt_1()%>'>
                
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	 <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;Agent > 해지관리 > <span class=style1><span class=style5>해지정산품의</span></span></td>
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
            <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
            <td class=title>영업구분</td>
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
          </tr>
          <tr> 
            <td class=title>차량구분</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
            <td class=title>용도구분</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}%></td>
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
            <td style="font-size : 8pt;" width="3%" class=title rowspan="2">연번</td>
            <td style="font-size : 8pt;" width="10%" class=title rowspan="2">계약일자</td>
            <td style="font-size : 8pt;" width="6%" class=title rowspan="2">이용기간</td>
            <td style="font-size : 8pt;" width="8%" class=title rowspan="2">대여개시일</td>
            <td style="font-size : 8pt;" width="8%" class=title rowspan="2">대여만료일</td>
            <td style="font-size : 8pt;" width="7%" class=title rowspan="2">계약담당</td>
            <td style="font-size : 8pt;" width="9%" class=title rowspan="2">월대여료</td>
            <td style="font-size : 8pt;" class=title colspan="2">보증금</td>
            <td style="font-size : 8pt;" width="10%" class=title rowspan="2">선납금</td>
            <td style="font-size : 8pt;" class=title colspan="2">개시대여료</td>
            <td style="font-size : 8pt;" class=title colspan="2">매입옵션</td>
          </tr>
          <tr>
            <td style="font-size : 8pt;" width="10%" class=title>금액</td>
            <td style="font-size : 8pt;" width="3%" class=title>승계</td>
            <td style="font-size : 8pt;" width="10%" class=title>금액</td>
            <td style="font-size : 8pt;" width="3%" class=title>승계</td>
            <td style="font-size : 8pt;" width="10%" class=title>금액</td>
            <td style="font-size : 8pt;" width="3%" class=title>%</td>			
          </tr>
		  <%for(int i=0; i<fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				if(!fees.getCon_mon().equals("")){
				
				s_opt_per = fees.getOpt_per();
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
				%>	
          <tr>
            <td style="font-size : 8pt;" align="center"><%=i+1%></td>
            <td style="font-size : 8pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
            <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>개월</td>
            <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
            <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
            <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>원&nbsp;</td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>원&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원&nbsp;</td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
          </tr>
		  <%}}%>
        </table>
	  </td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	  <td style='height:1; background-color=d2d2d2;' ></td>
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
			  <select name="cls_st" disabled >
		                <option value="7" <%if(cls.getCls_st().equals("출고전해지(신차)"))%>selected<%%>>출고전해지(신차)</option>
            
		      </select> </td>
                      					  
            <td width='13%' class='title'>의뢰자</td>
            <td width="13%">&nbsp;
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
            <td width="13%">&nbsp;
       
		  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt())%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '>
			  
			  </td> 
		    <td width='13%' class='title'>이용기간</td>
		    <td >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' value='<%=cls.getR_mon()%>' >개월&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=cls.getR_day()%>' >일&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>사유 </td>
            <td colspan="7">&nbsp;
              <textarea name="cls_cau" cols="140" class="text" style="IME-MODE: active" rows="3"><%=cls.getCls_cau()%></textarea>
			
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
		    <td  class=title width=10%>지점장결재자</td>
            <td  width=12%>&nbsp;				
			              
			</td>			
			<td  colspan="4" align=left>&nbsp;※ 기발행 계산서의 유지 또는 취소여부 등 확인이 필요, 매출취소시 마이너스 세금계산서 발행 </td>
          </tr>
                
        </table>
      </td>
    </tr>
         <tr></tr><tr></tr>    
     
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
    
  
    <tr id=tr_ret style="display:<%if( cls.getCls_st().equals("매입옵션")  || cls.getCls_st().equals("출고전해지(신차)")){%>none<%}else{%>''<%}%>"> 
  
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
			            <td width="20%">&nbsp;<input type="radio" name="reco_st" value="Y"  <%if(carReco.getReco_st().equals("Y"))%>checked<%%> >회수
	                            <input type="radio" name="reco_st" value="N" <%if(carReco.getReco_st().equals("N"))%>checked<%%> >미회수</td>
	                    <td width='13%' class='title'>구분</td>
	                    
	                    <td id=td_ret1 style="display:<%if( carReco.getReco_st().equals("Y") ){%>''<%}else{%>none<%}%>"> &nbsp; 
						  <select name="reco_d1_st" >
						    <option value="1" <%if(carReco.getReco_d1_st().equals("정상회수"))%>selected<%%>>정상회수</option>
						    <option value="2" <%if(carReco.getReco_d1_st().equals("강제회수"))%>selected<%%>>강제회수</option>
						    <option value="3" <%if(carReco.getReco_d1_st().equals("협의회수"))%>selected<%%>>협의회수</option>
			               </select>       
			            </td>
			            
			            <td id=td_ret2 style="display:<%if( carReco.getReco_st().equals("N") ){%>''<%}else{%>none<%}%>"> &nbsp; 
						  <select name="reco_d2_st" >
						    <option value="1" <%if(carReco.getReco_d2_st().equals("도난"))%>selected<%%>>도난</option>
						    <option value="2" <%if(carReco.getReco_d2_st().equals("횡령"))%>selected<%%>>횡령</option>
						    <option value="3" <%if(carReco.getReco_d2_st().equals("멸실"))%>selected<%%>>멸실</option>						  
						   </select>       
			            </td>
			            
			            <td class='title' width='13%' >사유</td>
						<td>&nbsp;
						<input type="text" name="reco_cau" value='<%=carReco.getReco_cau()%>'size=30 maxlength=100 >
						</td>				        		         
		         </tr>
		                   
		         <tr>      
		            <td width='10%' class='title'>회수일자</td>
		            <td>
					  <input type='text' name='reco_dt' value='<%=carReco.getReco_dt()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		            <td width='10%' class='title'>회수담당자</td>
		            <td>&nbsp;
					  <select name='reco_id'>
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
					  <input type='text' name='ip_dt' size='12' value='<%=carReco.getIp_dt()%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		          </tr>
		          <tr>      
		            <td width='10%' class='title'>주행거리</td>
		            <td>&nbsp;
					  <input type='text' name='tot_dist' size='10' value='<%=AddUtil.parseDecimal(cls.getTot_dist())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km 
		            </td>
		            <td colspan=4   align=left>&nbsp;※ 중도해지 및 만기시 차량주행거리 </td>	
		    </tr>
		    <tr>        
		            <td class=title>차량현위치</td>
	                    <td colspan=3> 
	                      &nbsp;<SELECT NAME="park" >	                                          
				                 <option value="" <% if(carReco.getPark().equals("")){%>selected<%}%>>--선택--</option>
				        		  <%if(good_size > 0){ 			
	                   			   for(int i = 0 ; i < good_size ; i++){
                  								CodeBean good = goods[i];%>
		       		          <option value='<%= good.getNm_cd()%>' <%if(carReco.getPark().equals(good.getNm_cd() ) ){%>selected<%}%>><%= good.getNm()%></option>
		                 <%		}
						 	}%>							  
				          
	        		        </SELECT>
							<input type="text" name="park_cont" value='<%=carReco.getPark_cont()%>'  size="40" class=text style='IME-MODE: active'>
						(기타선택시 내용)
                    	</td>
                    	   <td class=title>예비차 사용가능</td>
                    	    <td >&nbsp;<input type="radio" name="serv_st" value="Y"  <%if(cls.getServ_st().equals("Y"))%>checked<%%> >즉시가능
	                            <input type="radio" name="serv_st" value="N" <%if(cls.getServ_st().equals("N"))%>checked<%%> >수리후 가능</td>
	      	          </tr>		          
		          <tr>      
		            <td width='10%' class='title'>외주비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='12' value='<%=AddUtil.parseDecimal(carReco.getEtc_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> 원</td>
		            </td>
		            <td width='10%' class='title'>부대비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='12'  value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> 원</td>
		            </td>
		            <td width='10%' class='title'>비용계</td>
		            <td>&nbsp;
					 <input type='text' name='etc_out_amt' size='12' value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt() + carReco.getEtc_d1_amt())%>' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
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
		                  <td class='title' width='38%' align="center">내용</td>
		                  <td class='title' width="40%">비고</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="7" width=4%>환<br>
		                    불<br>
		                    금<br>
		                    액</td>
		                  <td class='title' colspan="2">보증금(A)</td>
		                  <td class='title' > 
		                    <input type='text' name='grt_amt' readonly value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
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
		                    <input type='text' size='3' name='ifee_mon' readonly  value='<%=cls.getIfee_mon()%>'  class='num' maxlength='4' >
		                    개월&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='<%=cls.getIfee_day()%>' class='num' maxlength='4' >
		                    일</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >경과금액</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    원</td>
		                  <td>=개시대여료×경과기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 개시대여료(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
		                    원</td>
		                  <td class='title'>=개시대여료-경과금액</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">선<br>
		                    납<br>
		                    금</td>
		                  <td align='center'>월공제액 </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    원</td>
		                  <td>=선납금÷계약기간</td>
		                </tr>
		                <tr> 
		                  <td align='center'>선납금 공제총액 </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    원</td>
		                  <td>=월공제액×실이용기간</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>잔여 선납금(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    원</td>
		                  <td class='title'>=선납금-선납금 공제총액</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">계</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' >
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
              <td class="title" width='38%' colspan=2> 내용</td>                
              <td class="title" width='40%' rowspan=2>비고</td>
            </tr>
            <tr>                 
              <td class="title"'> 당초금액</td>
              <td class="title"'> 확정금액</td>
              
            </tr>
            <tr> 
              <td class="title" rowspan="18" width="4%">미<br>
                납<br>
                입<br>
                금<br>
                액</td>
              <td class="title" colspan="3">과태료/범칙금(D)</td>
              <td align="center" class="title"> 
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' >
               원</td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num'  > 
               원</td>
           
              <td class="title">&nbsp;</td>
             </tr>
             <tr> 
              <td class="title" colspan="3">자기차량손해면책금(E)</td>
              <td width='19%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' >
                원</td>
              <td width='19%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>'   size='15' class='num'  > 
                원</td>   
                     
              <td width='40%' class="title">&nbsp;</td>
            </tr>
             <tr>
              <td class="title" rowspan="4" width="4%"><br>
                대<br>
                여<br>
                료</td>
              <td align="center" colspan="2" class="title">과부족</td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>'  size='15' class='num' >
                원</td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td> 
             
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
                <input type='text' size='15' name='nfee_amt'  readonly  value='<%=AddUtil.parseDecimal(cls.getNfee_amt())%>' class='num' > 원</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td>  
             
              <td>기발행계산서의 유지 또는 취소여부를 확인</td>
            </tr>
             <tr> 
              <td class="title" colspan="2">소계(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt' value='<%=AddUtil.parseDecimal(cls.getDfee_amt())%>' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                원</td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
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
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                원</td>
              <td>=선납금+월대여료총액</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">월대여료(환산)</td>
              <td class='' colspan=2 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' >
                원</td>
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
                <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' readonly size='15' class='num' >
                원</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> 위약금 
                적용요율</td>
              <td class='' align="center"> 
                <input type='text' readonly name='dft_int'  value='<%=cls.getDft_int()%>' size='5' class='num'  maxlength='4'>
                %</td>
              <td class='' align="center"> 
                <input type='text' name='dft_int_1'  value='<%=cls.getDft_int_1()%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                %</td>  
              <td>*위약금 적용요율은 계약서를 확인 <br><font color=red>*</font>해지위약금 차액이 발생시 영업효율대상자를 반드시 선택</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">중도해지위약금(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' >
                원</td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' onBlur='javascript:set_cls_amt(this)'>
                원</td>
                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_s())%>' size='15' class='num' >      
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' size='15' class='num' >            
                <input type='hidden' name='tax_g' size='20' class='text' value='중도해지 위약금'>
                <td class="title">&nbsp;<input type='checkbox' name='tax_chk0'  value='Y' <%if(cls.getTax_chk0().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled >계산서발행의뢰
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
              <td class="title" rowspan="5"><br>
                기<br>
                타</td> 
              <td colspan="2" align="center" class="title">연체료(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getDly_amt())%>' size='15' class='num' > 원</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1'  value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td>
             
              <td class='title'>&nbsp; </td>
            </tr>
            <tr>
              <td class="title" colspan="2">차량회수외주비용(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt())%>' size='15' class='num' >
                원</td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                원</td>  
                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_s())%>' size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_v())%>' size='15' class='num' >  
                <input type='hidden' name='tax_g' size='20' class='text' value='회수 차량외주비용'>
               <td class="title">&nbsp;<input type='checkbox' name='tax_chk1'  value='Y' <%if(cls.getTax_chk1().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled >계산서발행의뢰</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">차량회수부대비용(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>' size='15' class='num' >
                원</td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                원</td>  
                <input type='hidden' name='tax_supply' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_s())%>' size='15' class='num' > 
                <input type='hidden' name='tax_value' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_v())%>' size='15' class='num' >  
                <input type='hidden' name='tax_g' size='20' class='text' value='회수 부대비용'>
               <td class="title">&nbsp;<input type='checkbox' name='tax_chk2'  value='Y' <%if(cls.getTax_chk2().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled >계산서발행의뢰</td>
            </tr>
            <tr> 
              <td colspan="2" class="title">잔존차량가격(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' >
                원</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>'size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                원</td> 
            
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">기타손해배상금(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>'  size='15' class='num' >
                원</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                원</td>  
               <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_s())%>' size='15' class='num' > 
               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' size='15' class='num' >  
               <input type='hidden' name='tax_g' size='20' class='text' value='기타손해배상금'>
              <td class="title">&nbsp;<input type='checkbox' name='tax_chk3' value='Y' <%if(cls.getTax_chk3().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);" disabled >계산서발행의뢰
                          
             <!-- 기타손해배상금이 있는 경우만 --> 
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
    						<%}%>
                 
                 
                 
            <%}%></td>                                                        
            </tr>
                   
            <tr> 
              <td class="title" colspan="3">부가세(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt())%>' readonly size='15' class='num' >
                원</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>' readonly size='15' class='num' >
                원</td> 
         
              <td> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td id=td_cancel_n style="display:<%if( cls.getCancel_yn().equals("N") ){%>none<%}else{%>''<%}%>" class="title">=(대여료 
                      미납입금액-B-C)×10% + 계산서 발행 부가세 </td>
                    <td id=td_cancel_y style="display:<%if( cls.getCancel_yn().equals("Y") ){%>none<%}else{%>''<%}%>" class='title'>=(대여료  
                      미납입금액-B-C)×10% + 계산서 발행 부가세 </td>
                  </tr>
                </table>
              </td>
            </tr>
            
            <tr> 
              <td class="title_p" colspan="4">계</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1'value='<%=AddUtil.parseDecimal(cls.getFdft_amt1())%>' readonly  size='15' class='num' >
                원</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' readonly  size='15' class='num' >
                원</td>  
                
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M)&nbsp;&nbsp;
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
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2' readonly  value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>' size='15' class='num'  > 원</td>
                    <% if ( h_cms.get("CBNO") == null  ) {%>
                    <td colspan=6>&nbsp;※ 미납금액계 - 환불금액계</td>
                    <% } else { %>    
              		<td class=title width=12% ><input type='checkbox' name='cms_chk' value='Y' <%if(cls.getCms_chk().equals("Y")){%>checked<%}%> >CMS인출의뢰</td>
                 	<td colspan=5>&nbsp;※ 미납금액계 - 환불금액계</td>  
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
			                <option value="">--선택--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getDft_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select>
			              
			              <% if ( dft.equals("Y") && cls.getDft_saction_dt().equals("") && user_id.equals("000005") ) { %>
			              &nbsp;<a href="javascript:dft_sanction()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
			              <% } %>
			              
			              &nbsp;&nbsp;<%=cls.getDft_saction_dt()%><input type='hidden' name='dft_saction_dt' value='<%=cls.getDft_saction_dt()%>'>
			        </td>
                    <td class=title width=12%>중도해지위약금<br>감액사유</td>
		 <td colspan=3>&nbsp;<textarea name="dft_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getDft_reason()%></textarea></td> 
		 				    				    
                </tr>
                <tr>
                  	<td class=title width=10%>확정금액결재자</td>
                    <td width=12%>&nbsp;
						   <select name='d_saction_id'>
			                <option value="">--선택--</option>
			                 <%	if(user_size > 0){
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
              </table>
         </td>       
    </tr>
  
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_sale style="display:<%if( cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >매입옵션시<br>고객납입금액</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt3'  value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>' size='15' class='num' readonly  > 원</td>
                    <td colspan=6>&nbsp;※ 고객납입금액  + 매입옵션금액 + 이전등록비용(발생한 경우)</td>
              </tr>
                       
              </table>
         </td>       
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
                    <td class=title width=12%>보증보험</td>
                    <td class=title width=13%>보험금액</td>
                    <td width=12%>&nbsp;<input type='text' name='gi_amt' readonly value='<%=AddUtil.parseDecimal(carCre.getGi_amt())%>' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                    <td class=title width=12%>청구채권</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_c_amt' size='15' value='<%=AddUtil.parseDecimal(carCre.getGi_c_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'> 원</td>
                    <td class=title width=12%>잔존채권</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_j_amt' size='15' value='<%=AddUtil.parseDecimal(carCre.getGi_j_amt())%>' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
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
    <tr id=tr_cre style="display:<%if( cls.getFdft_amt2() > 0 ){%>''<%}else{%>none<%}%>"> 
     
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>잔존채권의 처리의견/지시사항&nbsp;<a href="javascript:update('tr_cre')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a></span></td>
 	 	  </tr>  
	      <tr>
	        <td class=line2></td>
	      </tr>
	      <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	                <tr>
	                    <td class=title colspan=2>구분</td>
	                    <td class=title width=80%>처리의견/지시사항/사유</td>
	                  
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
	                    <td>&nbsp;<input type='text' name='crd_remark1' value='<%=carCre.getCrd_remark1()%>' size='120' class='text' ></td>
	                 
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
	                    <td>&nbsp;<input type='text' name='crd_remark2' value='<%=carCre.getCrd_remark2()%>' size='120' class='text' ></td>
	                  
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
	                    <td>&nbsp;<input type='text' name='crd_remark3' value='<%=carCre.getCrd_remark3()%>' size='120' class='text' ></td>
	                   
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
	                    <td>&nbsp;<input type='text' name='crd_remark4' value='<%=carCre.getCrd_remark4()%>' size='120' class='text' ></td>
	                  
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
	                    <td>&nbsp;<input type='text' name='crd_remark5' value='<%=carCre.getCrd_remark5()%>' size='120' class='text' ></td>
	                  
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
	                    <td>&nbsp;<input type='text' name='crd_remark6'  value='<%=carCre.getCrd_remark6()%>' size='120' class='text' ></td>
	                  
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
	   
	<!-- 받을채권이 있는 경우 -->
 
	<tr id=tr_get style="display:''">
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채무자 자구책&nbsp;<a href="javascript:update('tr_get')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a></span></td>
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
			                    <td>&nbsp;<input type='text' name='est_amt' value='<%=AddUtil.parseDecimal(cls.getEst_amt())%>'size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
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
    						&nbsp;<a href="javascript:scan_reg('3')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
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
     	
    <tr>
	   <td align='center'>	
	       <% if( cls.getTerm_yn().equals("0") ) { %>
	         <a href="javascript:sac_req();"><img src=/acar/images/center/button_gjyc.gif align=absmiddle border=0></a>&nbsp;	 
	         <a href="javascript:sac_delete('0');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>&nbsp;    
	         <a href="javascript:save();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
	       <%}%> 
	       <%	if( cls.getTerm_yn().equals("1") &&  doc.getUser_dt2().equals("") ) {%>
	         <a href="javascript:sac_delete('1');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>&nbsp;    
	         <a href="javascript:save();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
	       <%}%> 
	    </td>
	</tr>			  
	
   <% if( !cls.getTerm_yn().equals("0") ) { %>
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
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id2 = "000026"; 
        					%>
        			  <%	if(user_id2.equals(user_id)){%>
        			    <a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>        	
                    <td align="center"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
        			  <%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){
        				  	String user_id3 = doc.getUser_id3();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);        			
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id3 = "000058";//황효심(000116)
        					%>
        			  <%	if(doc.getUser_id3().equals(user_id) || user_id3.equals(user_id) ){%>
        			    <a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>        			
        		<% if ( cls.getCls_st().equals("매입옵션") || cls.getCls_st().equals("출고전해지(신차)") || cls.getCls_st().equals("개시전해지(재리스)") || cls.getCls_st().equals("중도해약") || cls.getCls_st().equals("계약만료")  ) { %>
        		 	<td align="center">
        			</td>
        		<% } else {%>	        		 
                    <td align="center"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%>
        			  <%if(!doc.getUser_dt3().equals("") && doc.getUser_dt4().equals("")){
        			  		String user_id4 = doc.getUser_id4();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id4);
        					if(!cs_bean.getWork_id().equals(""))	user_id4 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id4 = "000077";//권용식(000077)
        					%>
        			  <%	if(user_id4.equals(user_id) ){%>
        			    <a href="javascript:doc_sanction('4')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>        		
        		 <% } %>        				        			
        			<td align="center"><%=c_db.getNameById(doc.getUser_id5(),"USER_PO")%><br><%=doc.getUser_dt5()%>
        			  <%if(!doc.getUser_dt3().equals("") && doc.getUser_dt5().equals("")){
        			  		String user_id5 = doc.getUser_id5();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id5);
        					if(!cs_bean.getWork_id().equals(""))	user_id5 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id5 = "000004";//안보국(000004)
        					%>
        			  <%	if(user_id5.equals(user_id) ){%>
        			    <a href="javascript:doc_sanction('5')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>				
        	    </tr>	
    		</table>
	    </td>
	</tr>  	  
 <% } %> 
 
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
		
	function set_init(){
		
		var fm = document.form1;		
		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
	}		
	
//-->
</script>
</body>
</html>
