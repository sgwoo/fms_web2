<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*"%>
<%@ page import="acar.accid.*, acar.res_search.*, acar.cont.*, acar.car_mst.*, acar.user_mng.*,  acar.settle_acc.*, acar.estimate_mng.*"%>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="my_bean2" class="acar.accid.MyAccidBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");//사고관리일련번호
	String mode = request.getParameter("mode")==null?"8":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
		
	String bus_id2 = "";
	
	
	
	//보험청구내역리스트
	MyAccidBean my_r [] = as_db.getMyAccidList(c_id, accid_id);
	
	if(seq_no.equals("")) seq_no = "1";
	
	//보험청구내역(휴차/대차료)
	MyAccidBean ma_bean = as_db.getMyAccid(c_id, accid_id, AddUtil.parseInt(seq_no));
		
		
	if ( !ma_bean.getBus_id2().equals("")){
	 	bus_id2 = ma_bean.getBus_id2();
	} else {
	    if ( !a_bean.getBus_id2().equals("") ) {  //사고시점의 담당자
	  	    bus_id2 = a_bean.getBus_id2();
	    } else {
			bus_id2 = (String)cont.get("BUS_ID2");
		}	
	}
	
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCaseAccid(c_id, accid_id);
	//예약현황
	Vector rc_conts = rs_db.getResCarAccidList(c_id, accid_id);
	int rc_cont_size = rc_conts.size();
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(rc_bean.getCar_mng_id());
	
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax_accid(l_cd, c_id, accid_id, seq_no);
	
	Vector tax_vts = ScdMngDb.getEbHistoryList(t_bean.getTax_no());
	int tax_vt_size = tax_vts.size();
	String pubcode = "";
	if(tax_vt_size > 0){
		Hashtable tax_ht = (Hashtable)tax_vts.elementAt(tax_vt_size-1);
		pubcode = String.valueOf(tax_ht.get("PUBCODE"));
	}
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
	if(!car_st.equals("")){
		if(car_st.indexOf("허") != -1){
			car_st = car_st.substring(4,5);	
		}
	}
	
	//상대차량 인적사항
	OtAccidBean oa_r [] = as_db.getOtAccid(c_id, accid_id);
	if(oa_r.length > 0){
		for(int i=0; i<1; i++){
   			oa_bean = oa_r[i];   			
			if(ma_bean.getIns_com().equals(""))		ma_bean.setIns_com	(oa_bean.getOt_ins());
			if(ma_bean.getIns_nm().equals(""))		ma_bean.setIns_nm	(oa_bean.getMat_nm());
			if(ma_bean.getIns_tel().equals(""))		ma_bean.setIns_tel	(oa_bean.getMat_tel());
			if(ma_bean.getIns_num().equals(""))		ma_bean.setIns_num	(oa_bean.getOt_num());
		}
	}
	
	//청구서발행 조회
	TaxItemListBean ti = IssueDb.getTaxItemListMyAccid(c_id, accid_id, seq_no, ma_bean.getIns_req_amt());
	
	
	
	//휴대차료 수금스케줄
	Hashtable ext6 = a_db.getScdExtEtcPay(m_id, l_cd, "6", accid_id+""+seq_no);
	if(AddUtil.parseInt(String.valueOf(ext6.get("PAY_AMT")))>0){
		ma_bean.setIns_pay_amt(AddUtil.parseInt(String.valueOf(ext6.get("PAY_AMT"))));
	}
	
	//변수
	String d_var1 = e_db.getEstiSikVarCase("1", "", "myaccid_app1");//첨부서류1
	String d_var2 = e_db.getEstiSikVarCase("1", "", "myaccid_app2");//첨부서류2
	String d_var3 = e_db.getEstiSikVarCase("1", "", "myaccid_app3");//첨부서류3
	String d_var4 = e_db.getEstiSikVarCase("1", "", "myaccid_app4");//첨부서류4	
	String d_var5 = e_db.getEstiSikVarCase("1", "", "myaccid_app5");//첨부서류5
	String d_var6 = e_db.getEstiSikVarCase("1", "", "myaccid_app6");//첨부서류6
	String d_var7 = e_db.getEstiSikVarCase("1", "", "myaccid_app7");//첨부서류7
	String d_var8 = e_db.getEstiSikVarCase("1", "", "myaccid_app8");//첨부서류8
	String d_var9 = e_db.getEstiSikVarCase("1", "", "myaccid_app9");//첨부서류9
	String d_var10 = e_db.getEstiSikVarCase("1", "", "myaccid_app10");//첨부서류10
	String d_var11 = e_db.getEstiSikVarCase("1", "", "myaccid_app11");//첨부서류11
	
	
	String i_start_dt = ma_bean.getIns_use_st();
    	String i_start_h 	= "00";
    	String i_start_s 	= "00";
    	String get_start_dt = ma_bean.getIns_use_st();
    	if(get_start_dt.length() == 12){
    		i_start_dt 	= get_start_dt.substring(0,8);
    		i_start_h 	= get_start_dt.substring(8,10);
    		i_start_s	= get_start_dt.substring(10,12);
    	}
    	if(get_start_dt.length() == 10){
    		i_start_dt 	= get_start_dt.substring(0,8);
    		i_start_h 	= get_start_dt.substring(8,10);
    	}
	if(ma_bean.getIns_req_amt()==0 && get_start_dt.length() == 8 && !rc_bean.getCar_mng_id().equals("") && get_start_dt.equals(rc_bean.getDeli_dt_d())){
		i_start_h 	= rc_bean.getDeli_dt_h();
    		i_start_s	= rc_bean.getDeli_dt_s();
	}
	String i_end_dt = ma_bean.getIns_use_et();
    	String i_end_h 	= "00";
    	String i_end_s 	= "00";
    	String get_end_dt = ma_bean.getIns_use_et();
    	if(get_end_dt.length() == 12){
    		i_end_dt 	= get_end_dt.substring(0,8);
    		i_end_h 	= get_end_dt.substring(8,10);
    		i_end_s		= get_end_dt.substring(10,12);
    	}
    	if(get_end_dt.length() == 10){
    		i_end_dt 	= get_end_dt.substring(0,8);
    		i_end_h 	= get_end_dt.substring(8,10);
    	}
    	if(ma_bean.getIns_req_amt()==0 && get_end_dt.length() == 8 && !rc_bean.getCar_mng_id().equals("") && get_end_dt.equals(rc_bean.getRet_dt_d())){
		i_end_h 	= rc_bean.getRet_dt_h();
    		i_end_s		= rc_bean.getRet_dt_s();
	}
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
			
	String content_code = "PIC_RESRENT_ACCID";
	String content_seq  = c_id+""+accid_id+""+seq_no;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	

	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}	
	
	//수정하기
	function save(cmd){
		var fm = document.form1;	
		
		fm.cmd.value = cmd;
		

		if(fm.ins_use_st.value != '')
			fm.h_rent_start_dt.value 	= fm.ins_use_st.value+fm.use_st_h.value+fm.use_st_s.value;
		if(fm.ins_use_et.value != '')
			fm.h_rent_end_dt.value 		= fm.ins_use_et.value+fm.use_et_h.value+fm.use_et_s.value;


				
		if(fm.accid_id.value == '')			{ alert("상단을 먼저 등록하십시오."); 	return; }		
		if(fm.ins_use_day.value == 'NaN')	{ alert('일수를 확인하십시오.'); 		fm.ins_use_day.focus(); 	return; }
		
		if(fm.ins_req_gu.value == '2' && fm.ins_req_st.value == '1'){
			if(fm.mc_v_amt.value == '0' || fm.mc_v_amt.value == ''){
				alert('대차료로 청구하는 경우 부가세를 입력해주세요.'); return;
			}
		}
		
		if( fm.ins_req_st.value == '1'){
			if(fm.ins_req_dt.value == '' ){
				alert('청구일자를 입력해주세요.'); fm.ins_req_dt.focus(); return;
			}
			if(fm.ins_use_st.value == '' ){
				alert('대차기간을 입력해주세요.'); fm.ins_use_st.focus(); return;
			}
			if(fm.ins_use_et.value == '' ){
				alert('대차기간을 입력해주세요.'); fm.ins_use_et.focus(); return;
			}
			
			if(toInt(replaceString('-','',fm.ins_use_st.value)) < <%=a_bean.getAccid_dt().substring(0,8)%>){
				alert('사고일자보다 대차시작일이 빠릅니다. 확인하십시오.');
				return;
			}
		}	
		
		if(fm.ins_req_st.value == '1'){ //청구인 경우
			if(fm.ins_req_gu.value == '2'){ //대차료				
				if(fm.ins_car_no.value == '')		{ alert("대차한 차량번호를 입력하십시오.");	fm.ins_car_no.focus(); 	return; }									
				if('<%=cont.get("CAR_NO")%>' == replaceString(" ","",fm.ins_car_no.value)){ alert("대차료를 청구한 차량번호와 사고 발생한 차량번호가 같으면 안됩니다."); 	return; }	
				//대차료인 경우 영업용차량만 가능함.
				if(fm.ins_car_no.value.indexOf("허")==-1 && fm.ins_car_no.value.indexOf("하")==-1 && fm.ins_car_no.value.indexOf("호")==-1){
					alert("대차료를 청구할 경우 대차차량은 영업용이여야 합니다. \n\n차량번호를 수정하세요.");				fm.ins_car_no.focus(); 	return; 
				}	
				if(fm.ins_com.value == '')			{ alert("보험사명을 입력하십시오.");		fm.ins_com.focus(); 	return; }	
			}
		}
		
		var mc_amt = toInt(parseDigit(fm.mc_s_amt.value)) + toInt(parseDigit(fm.mc_v_amt.value)); 							
		var req_amt = toInt(parseDigit(fm.ins_req_amt.value));
		
		if(mc_amt > req_amt || mc_amt < req_amt){
			alert('청구금액과 (공급가+부가세) 금액이 틀립니다. 확인하십시오.'); return;
		}
		
		
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.action = "accid_u_a.jsp"
		fm.target = "i_no"
		fm.submit();
	}
	
	//지급보험금 합계 셋팅
	function set_accid_tot_amt(obj){
		var fm = document.form1;
		fm.accid_tot_amt.value = parseDecimal(toInt(parseDigit(fm.hum_amt.value)) + toInt(parseDigit(fm.mat_amt.value)) + toInt(parseDigit(fm.one_amt.value)) + toInt(parseDigit(fm.my_amt.value))); 							
	}
		
	//휴차/대차기간 일자계산
	function set_ins_use_dt(){
		var fm = document.form1;
		
		if(fm.ins_use_st.value != '' && fm.ins_use_et.value != ''){		

			m  = 30*24*60*60*1000;		//달
			l  = 24*60*60*1000;  		// 1일
			lh = 60*60*1000;  			// 1시간
			lm = 60*1000;  	 	 		// 1분			
			var d1 = replaceString('-','',fm.ins_use_st.value)+fm.use_st_h.value+fm.use_st_s.value;
			var d2 = replaceString('-','',fm.ins_use_et.value)+fm.use_et_h.value+fm.use_et_s.value;		
			var t1 = getDateFromString(d1).getTime();
			var t2 = getDateFromString(d2).getTime();
			var t3 = t2 - t1;			
			fm.ins_use_day.value 	= parseInt(t3/l);
			fm.use_hour.value 		= parseInt(((t3%m)%l)/lh);	
			
			if(toInt(d1)>0 && toInt(d1)==toInt(d2) && fm.ins_use_day.value == '0' && fm.use_hour.value == '0'){
				fm.ins_use_day.value 	= 1;
			}
			
			if(toInt(parseDigit(fm.ins_day_amt.value))>0){
				fm.ins_req_amt.value = parseDecimal( ((toInt(parseDigit(fm.ins_day_amt.value)) * toInt(fm.ins_use_day.value)) + (toInt(parseDigit(fm.ins_day_amt.value))/24 * toInt(fm.use_hour.value))) * (toInt(fm.ot_fault_per.value)/100) );
				if(fm.ins_req_gu.value == '1'){		//휴차료
					fm.mc_s_amt.value = fm.ins_req_amt.value;
				}else{				
					fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
					fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
				}
			}

		}
	}	
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
		
	//청구금액 셋팅
	function set_ins_amt(){
		var fm = document.form1;		
		fm.ins_req_amt.value = parseDecimal( (toInt(parseDigit(fm.ins_day_amt.value)) * toInt(fm.ins_use_day.value)) * toInt(fm.f_per.value)/100 );
		if(fm.vat_yn.checked == true){
			fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
		}else{
			fm.mc_s_amt.value = fm.ins_req_amt.value;
		}
	}
	
	//청구금액 셋팅
	function set_ins_vat_amt(){
		var fm = document.form1;		
		if(fm.vat_yn.checked == true){
			fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
		}
	}	
	
	function set_v_amt(){
		var fm = document.form1;		
		if(fm.vat_yn.checked == true){
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.mc_s_amt.value)) * 0.1);					
		}
		
	}
	function accid_tax(){
		var fm = document.form1;
		if(<%=ma_bean.getIns_req_amt()%>==0){ alert('청구금액이 없습니다. 청구내용을 먼저 수정하십시오.'); return;}
		
		
		if(fm.ins_req_gu.value == '1'){		
			fm.action = "/tax/issue_3/issue_3_sc6.jsp";//휴차료
		}else{
			fm.action = "/tax/issue_3/issue_3_sc5.jsp";//대차료
		}

		fm.target = "d_content";
		fm.submit();
	}	

	//견적서인쇄
	function DocPrint(){
		var fm = document.form1;
		var SUBWIN="/tax/item_mng/doc_accid_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no="+fm.seq_no.value;	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
	}	
	
	//세금계산서인쇄
	function TaxPrint(tax_no){
		var fm = document.form1;
		var SUBWIN="/tax/tax_mng/tax_accid_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>";	
		window.open(SUBWIN, "TaxPrint", "left=50, top=50, width=680, height=550, scrollbars=yes, status=yes");
	}	
	
	//세금계산서인쇄
	function TaxPrint2(tax_no){
		var fm = document.form1;
		var SUBWIN="/tax/tax_mng/tax_print.jsp?tax_no="+tax_no;
		window.open(SUBWIN, "TaxPrint", "left=50, top=50, width=680, height=550, scrollbars=yes, status=yes");
	}	
	
	//필요서류
	function DocSelect(){
		var fm = document.form1;
		var SUBWIN="myaccid_reqdoc_select.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>&client_id=<%=cont.get("CLIENT_ID")%>";			
		window.open(SUBWIN, "DocSelect", "left=50, top=50, width=950, height=600, scrollbars=yes, status=yes");	
	}
	
	//청구금액 셋팅
	function set_reqamt(st){
		var fm = document.form1;			
		
		if(fm.ins_use_day.value == '') 	set_ins_use_dt();		
		if(fm.ins_use_day.value == ''){	alert('이용일수를 입력하십시오.'); return;}

		if(fm.use_hour.value == '') 	set_ins_use_dt();
		if(fm.use_hour.value == ''){	alert('이용시간을 입력하십시오. 대차종료일자에서 커서를 뒀다가 나오시면 자동계산 합니다.'); return;}

		
		fm.st.value = st;
		fm.action='getMyAccidReqAmt.jsp';
		
		if(st == 'view'){
			fm.target='_blank';
		}else{
			
			if(toInt(replaceString('-','',fm.ins_use_st.value)) < <%=a_bean.getAccid_dt().substring(0,8)%>){
				alert('사고일자보다 대차시작일이 빠릅니다. 확인하십시오.');
				return;
			}
						
			fm.target='i_no';
		}
				
		fm.submit();
	}	
	

	
	function accid_tax_msg(){
		var fm = document.form1;	
		fm.action='/fms2/coolmsg/cool_msg_send.jsp';
		fm.target='i_no';
		fm.submit();
	}
	
	//대차료청구문서 발행요청
	function accid_doc_req_msg(){
		var fm = document.form1;	
		
		if(<%=ma_bean.getIns_req_amt()%>==0){ 	alert('청구금액이 없습니다. 청구내용을 먼저 수정하십시오.'); 		return;}
		if('<%=ma_bean.getIns_req_dt()%>'==''){ alert('청구일자가 없습니다. 청구내용을 먼저 수정하십시오.'); 		return;}
		if('<%=ma_bean.getIns_com()%>'==''){ 	alert('청구할 보험사가 없습니다. 청구내용을 먼저 수정하십시오.'); 	return;}
		if('<%=ma_bean.getIns_nm()%>'==''){ 	alert('청구할 보험사-담당자가 없습니다. 청구내용을 먼저 수정하십시오.'); 	return;}
		if('<%=ma_bean.getIns_zip()%>'==''){ 	alert('청구할 보험사-우편번호가 없습니다. 청구내용을 먼저 수정하십시오.'); 	return;}
		if('<%=ma_bean.getIns_addr()%>'==''){ 	alert('청구할 보험사-주소가 없습니다. 청구내용을 먼저 수정하십시오.'); 	return;}
		if('<%=ma_bean.getApp_docs()%>'==''){ 	alert('청구할 보험사-첨부서류가 없습니다. 청구내용을 먼저 수정하십시오.'); 	return;}
			
		if(!confirm('요청하시겠습니까?')){
			return;
		}
		fm.action = "accid_u_h_a.jsp";
		fm.target = "i_no";
		fm.submit();		
	}
	
	
	function reg_save(){
		var fm = document.form1;	
		fm.seq_no.value = <%=my_r.length%>+1;
		fm.action='accid_u_in8.jsp';
		fm.target='_self';
		fm.submit();		
	}
	
	function view_my_accid(seq_no){
		var fm = document.form1;	
		fm.seq_no.value = seq_no;
		fm.seq_no2.value = seq_no;
		fm.action='accid_u_in8.jsp';
		fm.target='_self';
		fm.submit();		
	}
	
	//트러스빌 연결
	function  viewTaxInvoice(pubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=680px, height=760px");
		document.form1.action="https://www.trusbill.or.kr/jsp/directTax/TaxViewIndex.jsp";
		document.form1.method="post";
		document.form1.pubCode.value=pubCode;
		document.form1.docType.value="T"; //세금계산서
		document.form1.userType.value="S"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
		document.form1.target="taxInvoice";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.pubCode.value="";
		taxInvoice.focus();
		return;
	}
		
	function ViewTaxItem(){		
		var taxItemInvoice = window.open("about:blank", "TaxItem", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=1000px, height=800px");
		var fm = document.form1;
		fm.target="TaxItem";
		fm.action = "/tax/issue_1_tax/tax_item_u.jsp";
		fm.submit();			
	}						
		
	//보험사조회
	function find_gov_search(){
		var fm = document.form1;	
		window.open("find_gov_search.jsp?mode=<%=mode%>", "SEARCH_FINE_INSCOM", "left=100, top=10, width=1050, height=850, scrollbars=yes");
	}		
	
	//출력하기
	function FineDocPrint(doc_id){
		var fm = document.form1;
		var SUMWIN = "/fms2/accid_doc/accid_mydoc_print.jsp?doc_id="+doc_id;	
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
			
	
	//예약시스템 데이타 연동(단일일때)
	function reserv_set(){
		var fm = document.form1;
		if(fm.ins_req_st.value == '' || fm.ins_req_st.value == '0') fm.ins_req_st.value = '1';
		fm.ins_car_no.value = '<%=reserv.get("CAR_NO")%>';
		fm.ins_car_nm.value = '<%=reserv.get("CAR_NM")%>';
		fm.ins_use_st.value = ChangeDate('<%=rc_bean.getDeli_dt_d()%>');
		fm.use_st_h.value 	= '<%=rc_bean.getDeli_dt_h()%>';
		fm.use_st_s.value 	= '<%=rc_bean.getDeli_dt_s()%>';
		fm.ins_use_et.value = ChangeDate('<%=rc_bean.getRet_dt_d()%>');
		fm.use_et_h.value 	= '<%=rc_bean.getRet_dt_h()%>';
		fm.use_et_s.value 	= '<%=rc_bean.getRet_dt_s()%>';		
				
		//대차기간 계산(일,시간)		
		set_ins_use_dt();
		
		if(fm.ot_fault_per.value == '0' || fm.ot_fault_per.value == ''){ alert('상대과실율이 없습니다. \n\n상대과실율을 입력하고 [계산하기]를 클릭 하십시오.'); fm.ot_fault_per.focus(); return; } 
		
		//대차기준금액 계산
		set_reqamt('');
	}
	
	//예약시스템 데이타 연동(대차여러건)
	function reserv_set2(car_no, car_nm, deli_dt, ret_dt){
		var fm = document.form1;
		if(fm.ins_req_st.value == '' || fm.ins_req_st.value == '0') fm.ins_req_st.value = '1';
		fm.ins_car_no.value = car_no;
		fm.ins_car_nm.value = car_nm;
		if(deli_dt.length >= 8){
			fm.ins_use_st.value = ChangeDate(deli_dt.substring(0,8));
			if(deli_dt.length == 12){
				fm.use_st_h.value 	= deli_dt.substring(8,10);
				fm.use_st_s.value 	= deli_dt.substring(10,12);			
			}else{
				fm.use_st_h.value 	= '00';
				fm.use_st_s.value 	= '00';						
			}
		}
		if(ret_dt.length >= 8){
			fm.ins_use_et.value = ChangeDate(ret_dt.substring(0,8));
			if(ret_dt.length == 12){
				fm.use_et_h.value 	= ret_dt.substring(8,10);
				fm.use_et_s.value 	= ret_dt.substring(10,12);			
			}else{
				fm.use_et_h.value 	= '00';
				fm.use_et_s.value 	= '00';						
			}
		}
				
		//대차기간 계산(일,시간)		
		set_ins_use_dt();
		
		if(fm.ot_fault_per.value == '0' || fm.ot_fault_per.value == ''){ alert('상대과실율이 없습니다. \n\n상대과실율을 입력하고 [계산하기]를 클릭 하십시오.'); fm.ot_fault_per.focus(); return; } 
		
		//대차기준금액 계산
		set_reqamt('');
	}	
	
	//청구선택시 처리건
	function cng_reserv(value){
		var fm = document.form1;
		if(value =='1' && '<%=rc_bean.getCar_mng_id()%>' != ''){
			if(!confirm('예약시스템의 대차내용을 가져오겠습니까?')){
				return;
			}
			reserv_set();
		}
	}
	
	//예약시스템 계약서
	function view_scan_res(mode, c_id, s_cd){
		window.open("/acar/rent_mng/res_rent_u_accid_print.jsp?c_id="+c_id+"&s_cd="+s_cd+"&mode="+mode+"&sub_c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>", "VIEW_SCAN_RES", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}	
	
	//대차차량이 자가용일때 영업용 보유차 조회하기
	function res_car_search(reg_yn, section, car_nm, deli_dt, ret_dt, ins_com){
		var fm = document.form1;
		if(reg_yn == 'Y'){
			window.open("res_car_taecha_search.jsp?section_yn=Y&section="+section+"&car_nm="+car_nm+"&deli_dt="+deli_dt+"&ret_dt="+ret_dt+"&ins_com="+ins_com+"", "SEARCH_RES_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");				
		}else{
			if(fm.ins_use_st.value == '' )	{	alert('대차기간 시작을 입력해주세요.'); 	fm.ins_use_st.focus(); 	return;	}
			if(fm.ins_com.value == '')		{ 	alert("보험사명을 입력하십시오.");	fm.ins_com.focus(); 	return; }	
			window.open("res_car_taecha_search.jsp?section_yn=Y&section=<%=cm_bean.getSection()%>&car_nm=<%=cm_bean.getCar_nm()%>&deli_dt="+fm.ins_use_st.value+"&ret_dt="+fm.ins_use_et.value+"&ins_com="+fm.ins_com.value+"", "SEARCH_RES_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");						
		}
	}
	

	//스캔등록
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
			
	//스캔삭제
	function scan_del(accid_id, c_id){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){		return;	}

		fm.target = "i_no"
		fm.action = "del_accid_scan_a.jsp?accid_id="+accid_id+"&c_id="+c_id;
		fm.submit();
		
	}
	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="accid_u_a.jsp" name="form1">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>
  <input type='hidden' name='gubun6' value='<%=gubun6%>'>
  <input type='hidden' name='brch_id' value='<%=brch_id%>'>
  <input type='hidden' name='st_dt' value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='sort' value='<%=sort%>'>
  <input type='hidden' name='asc' value='<%=asc%>'>
  <input type='hidden' name='s_st' value='<%=s_st%>'>
  <input type='hidden' name='idx' value='<%=idx%>'>
  <input type='hidden' name='m_id' value='<%=m_id%>'>
  <input type='hidden' name='l_cd' value='<%=l_cd%>'>
  <input type='hidden' name='c_id' value='<%=c_id%>'>
  <input type='hidden' name='accid_id' value='<%=accid_id%>'>
  <input type='hidden' name='mode' value='<%=mode%>'>
  <input type='hidden' name='cmd' value='<%=cmd%>'>    
  <input type='hidden' name='go_url' value='<%=go_url%>'>
  <input type="hidden" name="client_id" value="<%=cont.get("CLIENT_ID")%>">
  <input type="hidden" name="site_id" value="">  
  <input type="hidden" name="rent_mng_id" value="<%=m_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=c_id%>">      
  <input type="hidden" name="firm_nm" value="<%=cont.get("FIRM_NM")%>">     
  <input type='hidden' name='f_per' value='<%=Math.abs(a_bean.getOur_fault_per()-100)%>'>
  <input type='hidden' name='st' value=''>
  <input type="hidden" name="sender_id" value="<%=user_id%>">  	
  <input type="hidden" name="target_id" value="<%=nm_db.getWorkAuthUser("사고관리")%>">  	
  <input type="hidden" name="coolmsg_sub" value="대차료청구공문 발송요청">  	
  <input type="hidden" name="coolmsg_cont" value="▣ 대차료청구공문 발행요청 :: <%=cont.get("FIRM_NM")%> <%=cont.get("CAR_NO")%>, 사고일시:<%=a_bean.getAccid_dt()%>, 청구금액:<%=AddUtil.parseDecimal(ma_bean.getIns_req_amt())%>">  	
  <input type="hidden" name="seq_no" value="<%=seq_no%>">  	
  <input type="hidden" name="seq_no2" value="<%=seq_no%>">  	
  <input type='hidden' name="pubCode" value="">
  <input type='hidden' name="docType" value="">
  <input type='hidden' name="userType" value="">  
  <input type='hidden' name="item_id" value="<%=ti.getItem_id()%>">    
  <input type='hidden' name='ins_com_id' value=''>
  <input type='hidden' name='h_rent_start_dt' value=''>
  <input type='hidden' name='h_rent_end_dt' value=''>
  

    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="6%" class=title>연번</td>
                    <td width="6%" class=title>구분</td>
                    <td width="15%" class=title>보험사</td>
                    <td width="10%" class=title>보험담당자</td>
                    <td width="10%" class=title>차량번호</td>
                    <td width="15%" class=title>차종</td>
                    <td width="10%" class=title>청구금액</td>
                    <td width="10%" class=title>청구일자</td>
                    <td width="10%" class=title>입금금액</td>
                    <td width="10%" class=title>입금일자</td>
                </tr>
		<%	for(int i=0; i<my_r.length; i++){
    				my_bean2 = my_r[i];
				//휴대차료 수금스케줄
				Hashtable ext66 = a_db.getScdExtEtcPay(m_id, l_cd, "6", accid_id+""+my_bean2.getSeq_no());
				if(AddUtil.parseInt(String.valueOf(ext66.get("PAY_AMT")))>0){
					my_bean2.setIns_pay_amt(AddUtil.parseInt(String.valueOf(ext66.get("PAY_AMT"))));
				}
		%>
                <tr>
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%if(my_bean2.getIns_req_gu().equals("2")){%>대차료<%}%><%if(my_bean2.getIns_req_gu().equals("1")){%>휴차료<%}%></td>
                  <td align="center"><a href="javascript:view_my_accid(<%=my_bean2.getSeq_no()%>);"><%=my_bean2.getIns_com()%></a></td>
                  <td align="center"><%=my_bean2.getIns_nm()%></td>
                  <td align="center"><%=my_bean2.getIns_car_no()%></td>
                  <td align="center"><%=my_bean2.getIns_car_nm()%></td>
                  <td align="right"><%=AddUtil.parseDecimal(my_bean2.getIns_req_amt())%>원</td>
                  <td align="center"><%=AddUtil.ChangeDate2(my_bean2.getIns_req_dt())%></td>
                  <td align="right"><%=AddUtil.parseDecimal(my_bean2.getIns_pay_amt())%>원</td>
                  <td align="center"><%=AddUtil.ChangeDate2(my_bean2.getIns_pay_dt())%></td>
                </tr>
		<%	}%>
	    </table>
	</td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
        <td align="right">
            <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
            <a href='javascript:reg_save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_plus.gif" align="absmiddle" border="0"></a>
            <%}%>
        </td>
    </tr>	
    <tr>
        <td></td>
    </tr>
    <tr><td colspan=2 style='background-color:bebebe; height:1;'></td></td></tr>	
    <%if(rc_cont_size > 0){%>
    <tr><td class=h></td></tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고대차</span> </td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2">
            <table border="0" cellspacing="1" width=100%>
		<%	for(int i = 0 ; i < rc_cont_size ; i++){
    				Hashtable reservs = (Hashtable)rc_conts.elementAt(i);
    		%>
                <tr> 
                    <td class=title width=9%>차량번호</td>
                    <td width=15%>&nbsp;<%=reservs.get("CAR_NO")%>
			<%if(rc_cont_size ==1){%>
			<a href="javascript:reserv_set2('<%=reservs.get("CAR_NO")%>','<%=reservs.get("CAR_NM")%>','<%=reservs.get("DELI_DT")%>','<%=reservs.get("RET_DT")%>')" onMouseOver="window.status=''; return true" onFocus="this.blur()" title='사고대차의 데이타를 대차료 청구와 연동합니다.'>[연동]</a>
			<%}else{%>
			<a href="javascript:reserv_set2('<%=reservs.get("CAR_NO")%>','<%=reservs.get("CAR_NM")%>','<%=reservs.get("DELI_DT")%>','<%=reservs.get("RET_DT")%>')" onMouseOver="window.status=''; return true" onFocus="this.blur()" title='사고대차의 데이타를 대차료 청구와 연동합니다.'>[연동]</a>						
			<%}%>
		    </td>
                    <td class=title width=9%>차명</td>
                    <td width=23%>&nbsp;<%=reservs.get("CAR_NM")%>&nbsp;<%//=reservs.get("CAR_NAME")%></td>
                    <td class=title width=9%>대차기간</td>
                    <td width=35%>&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(reservs.get("DELI_DT")))%>~<%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RET_DT")))%>
			&nbsp;<a href="javascript:view_scan_res('accid_doc','<%=reservs.get("CAR_MNG_ID")%>','<%=reservs.get("RENT_S_CD")%>')" onMouseOver="window.status=''; return true" title='단기계약서 보기'><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		    </td>
                </tr>
		<%	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>		
    <%}%>		
    <tr> 
        <td>
            <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대차료</span>
	</td>
        <td align="right">
        
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
            <%if(ma_bean.getAccid_id().equals("")){%>
            <a href='javascript:save("i")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
            <%}else{%>
            <a href='javascript:save("u")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
            <%}%>
        <%}%>
        
	</td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>청구구분</td>
                    <td width=15%> 
                      <select name="ins_req_gu">
                        <option value="2" <%if(ma_bean.getIns_req_gu().equals("2"))%>selected<%%>>대차료</option>
                        <option value="1" <%if(ma_bean.getIns_req_gu().equals("1"))%>selected<%%>>휴차료</option>
                      </select>
                    </td>
                    <td class=title width=9%>상태</td>
                    <td width=15%> 
                      <select name="ins_req_st" onChange="javascript:cng_reserv(this.value)">
                        <option value="0" <%if(ma_bean.getIns_req_st().equals("0"))%>selected<%%>>미청구</option>
                        <option value="1" <%if(ma_bean.getIns_req_st().equals("1"))%>selected<%%>>청구</option>
                        <option value="2" <%if(ma_bean.getIns_req_st().equals("2"))%>selected<%%>>완료</option>
                        <option value="3" <%if(ma_bean.getIns_req_st().equals("3"))%>selected<%%>>최고장종결</option>
                      </select>
                    </td>
                    <td class=title width=9%>차량번호</td>
                    <td width=15%> 
                      <input type="text" name="ins_car_no" value="<%=ma_bean.getIns_car_no()%>" size="14" class=text maxlength="12">
					  <%	if(!rc_bean.getCar_mng_id().equals("")){%>	
					  <%		if(String.valueOf(reserv.get("CAR_USE")).equals("2")){%>	
					  			<span class="b"><a href="javascript:res_car_search('Y','<%=reserv.get("SECTION")%>', '<%=reserv.get("CAR_NM")%>', '<%=rc_bean.getDeli_dt()%>', '<%=rc_bean.getRet_dt()%>', '<%=ma_bean.getIns_com()%>')" onMouseOver="window.status=''; return true" title="영업용 보유차 조회하기"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  <%		}%>
					  <%	}else{%>
					  			<span class="b"><a href="javascript:res_car_search('N','', '', '', '', '')" onMouseOver="window.status=''; return true" title="영업용 보유차 조회하기"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  <%	}%>
                    </td>
                    <td class=title width=9%>차종</td>
                    <td width=19%> 
                      <input type="text" name="ins_car_nm" value="<%=ma_bean.getIns_car_nm()%>" class=text size="20" maxlength="30">
                    </td>
                </tr>
                <tr> 
                    <td class=title> 기간</td>
                    <td colspan="7">
                      <input type="text" name="ins_use_st" value="<%=AddUtil.ChangeDate2(i_start_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="12">

					  <select name="use_st_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_start_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="use_st_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_start_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>	

                      ~ 
                      <input type="text" name="ins_use_et" value="<%=AddUtil.ChangeDate2(i_end_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); set_ins_use_dt();' maxlength="12">

					  <select name="use_et_h" onChange="javscript:set_ins_use_dt();">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_end_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="use_et_s" onChange="javscript:set_ins_use_dt();">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_end_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>	

                      ( 
                      <input type="text" name="ins_use_day" value="<%=ma_bean.getIns_use_day()%>" size="3" class=num onBlur='javscript:set_ins_amt();'>
                      일					  
					  <input type="text" name="use_hour" value="<%=ma_bean.getUse_hour()%>" size="2" class=num onBlur='javscript:set_ins_amt();'>
                      시간 	
					  )&nbsp; 
        			  <span class="b"><a href="javascript:set_reqamt('')" onMouseOver="window.status=''; return true" title="계산하기"><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
        			  <span class="b"><a href="javascript:set_reqamt('view')" onMouseOver="window.status=''; return true" title="계산식 보기"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>
        			  </td>                    
                </tr>
                <tr> 
                    <td class=title>청구기준</td>
                    <td colspan="3"> 1일 
                      <input type="text" name="ins_day_amt" value="<%=AddUtil.parseDecimal(ma_bean.getIns_day_amt())%>" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_ins_amt();'>
                      원</td>
                    <td class=title>상대과실</td>
					<%	int ot_fault_per = ma_bean.getOt_fault_per();
						if(ot_fault_per==0) ot_fault_per = Math.abs(a_bean.getOur_fault_per()-100);%>
                    <td colspan="3"> <input type=text name='ot_fault_per' value='<%=ot_fault_per%>' size="3" class=num>%</td>
                </tr>
                <tr> 
                    <td class=title>청구금액</td>
                    <td colspan="7">
                      <input type="text" name="ins_req_amt" value="<%=AddUtil.parseDecimal(ma_bean.getIns_req_amt())%>" size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
					  <font color=#666666>&nbsp;(청구금액=((1일청구기준*대차일수)+(1일청구기준/24*대차시간))*상대과실율)</font>
					  </td>
                </tr>
                <tr> 
                    <td class=title>공급가</td>
                    <td colspan="3"><input type="text" name="mc_s_amt" value="<%=AddUtil.parseDecimal(ma_bean.getMc_s_amt())%>" size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_v_amt();'>
						원 </td>
                    <td class=title>부가세</td>
                    <td colspan="3"><input type="text" name="mc_v_amt" value="<%=AddUtil.parseDecimal(ma_bean.getMc_v_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
						원
						  (<input type='checkbox' name='vat_yn' value="Y" <%if(ma_bean.getVat_yn().equals("Y"))%> checked<%%> onclick='javscript:set_ins_vat_amt()'>부가세포함)</td>
                </tr>				
                <tr> 
                    <td class=title>청구일자</td>
                    <td colspan="3"> 
					  <%if(ma_bean.getIns_req_dt().equals("") || nm_db.getWorkAuthUser("전산팀",user_id)){%>	
                      <input type="text" name="ins_req_dt" value="<%=AddUtil.ChangeDate2(ma_bean.getIns_req_dt())%>" size="12" class=text   onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="10">
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(ma_bean.getIns_req_dt())%>
					  <input type='hidden' name="ins_req_dt" value="<%=ma_bean.getIns_req_dt()%>">
					  <%}%>
                    </td>
                    <td class=title>청구자</td>   
                    <td colspan="3">&nbsp;<select name='bus_id2'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>   					
                </tr>												
                <tr> 				
                    <td class=title>미청구사유</td>
                    <td colspan="7">
                    <textarea name="re_reason" cols="120" class="text" rows="2"><%=ma_bean.getRe_reason()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan='2'>(최초등록일:<%=AddUtil.ChangeDate2(ma_bean.getReg_dt())%>, 최초등록자:<%=c_db.getNameById(ma_bean.getReg_id(), "USER")%> / 최종등록일:<%=AddUtil.ChangeDate2(ma_bean.getUpdate_dt())%>, 최종등록자:<%=c_db.getNameById(ma_bean.getUpdate_id(), "USER")%>)
	    <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%><%=c_id%>/<%=accid_id%>/<%=seq_no%><%}%></td>
    </tr>		    	
    <tr> 
        <td width="30%"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>스캔파일</td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="15%" colspan="2">대차차량 계약서</td>
                    <td colspan='6'>
			<%if(attach_vt_size > 0){%>
			    <%	for (int i = 0 ; i < attach_vt_size ; i++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(i);%>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    					<%if(i+1 < attach_vt_size){%><br><%}%>
    			    <%	}%>		
			<%}else{%>
			    <a href="javascript:scan_reg(1)"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
			<%}%>
		    </td>
                </tr>
            </table>
        </td>
    </tr>	

    <tr><td class=h></td></tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>입금구분</td>
                  <td width=15%><select name="pay_gu" disabled>
				    <option value="" <%if(ma_bean.getPay_gu().equals(""))%>selected<%%>>선택</option>
                    <option value="2" <%if(ma_bean.getPay_gu().equals("2"))%>selected<%%>>대차료</option>
                    <option value="1" <%if(ma_bean.getPay_gu().equals("1"))%>selected<%%>>휴차료</option>
                  </select></td>
                    <td class=title width=9%>입금금액</td>
                    <td width=15%><input type="text" name="ins_pay_amt" value="<%=AddUtil.parseDecimal(ma_bean.getIns_pay_amt())%>" size="10" <%if(nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);' readonly<%}else{%>class=whitenum readonly<%}%>>
					원 
                    </td>
                    <td class=title width=9%>입금일자</td>
                    <td width=43%> 
                      <input type="text" name="ins_pay_dt" value="<%=AddUtil.ChangeDate2(ma_bean.getIns_pay_dt())%>" size="12" <%if(nm_db.getWorkAuthUser("회계업무",user_id)|| nm_db.getWorkAuthUser("전산팀",user_id) ){%>class=whitetext   onBlur='javscript:this.value = ChangeDate(this.value);'  readonly <%}else{%>class=whitetext readonly<%}%> maxlength="10">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>보험사</td>
                    <td colspan="5"> 
					  <input type="text" name="ins_com" value="<%=ma_bean.getIns_com()%>" size="20" class='text' maxlength="20" readonly >
					  <a href="javascript:find_gov_search();" titile='보험사 검색'><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <% 	if(!ma_bean.getIns_com().equals("") || !ma_bean.getIns_com_id().equals("")){
						  		Hashtable ins_com = ai_db.getInsCom(ma_bean.getIns_com_id(), ma_bean.getIns_com());						  		
					  %>	  		
					  &nbsp;
					  (<%=ma_bean.getIns_com()%> 연락처:<%=ins_com.get("AGNT_TEL")%>/FAX:<%=ins_com.get("AGNT_FAX")%>/긴급출동:<%=ins_com.get("AGNT_IMGN_TEL")%>/사고접수:<%=ins_com.get("ACC_TEL")%>)
				 	  <%	   		
					  		}	  	
					  %>					  
                    </td>
                    <td class=title>접수번호</td>
                    <td>NO.<input name="ins_num" type="text" class=text id="ins_num" value="<%=ma_bean.getIns_num()%>" size="30" maxlength="50" >
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=9%>보험담당자</td>
                    <td width=15%> 
                      <input type="text" name="ins_nm" value="<%=ma_bean.getIns_nm()%>" size="20" class=text maxlength="30" >
                    </td>
                    <td class=title width=9%>연락처Ⅰ</td>
                    <td width=15%> 
                      <input type="text" name="ins_tel" value="<%=ma_bean.getIns_tel()%>" size="13" class=text maxlength="15" >
                    </td>
                    <td class=title width=9%>연락처Ⅱ</td>
                    <td width=15%> 
                      <input type="text" name="ins_tel2" value="<%=ma_bean.getIns_tel2()%>" size="13" class=text maxlength="15" >
                    </td>
                    <td class=title width=9%>팩스</td>
                    <td width=19%> 
                      <input type="text" name="ins_fax" value="<%=ma_bean.getIns_fax()%>" size="13" class=text maxlength="15" >
                    </td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>주소</td>
				  <td colspan=7>
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=ma_bean.getIns_zip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="100" value="<%=ma_bean.getIns_addr()%>">
				  </td>
				</tr>
                <tr> 
                    <td class=title>비고</td>
                    <td colspan="7"> 
                      <input type="text" name="ins_etc" value="<%=ma_bean.getIns_etc()%>" size="110" class=text maxlength="200">
                    </td>
                </tr>
                <tr> 
                    <td class=title>첨부서류</td>
                    <td colspan="7"> 
						<table cellspacing="2" cellpadding="2" border="0">
							<tr>
    							<td>[기본] 아마존카 사업자등록증 1부, 
									아마존카 단기대여요금표 1부, 
									아마존카 신한은행 통장 사본 1부
								</td>
							</tr>
							
							<tr>
							    <td>
								  <%int s=0;
									String value[] = new String[11];
									
									if(!ma_bean.getApp_docs().equals("")){
								  		StringTokenizer st = new StringTokenizer(ma_bean.getApp_docs(),"^");
										
										while(st.hasMoreTokens()){
											value[s] = st.nextToken();
											s++;
										}
								  	}else{
										for(int i=0; i<11; i++){
											value[i] = "N";
										}
									}%>
								  [선택]	
								  <br>
			                      <input type="checkbox" name="app_doc4"  value="Y" <%if(s>0 && value[3].equals("Y"))%>checked<%%>><%=d_var4%>
								  <input type="checkbox" name="app_doc5"  value="Y" <%if(s>0 && value[4].equals("Y"))%>checked<%%>><%=d_var5%>
								  <br>
								  <input type="checkbox" name="app_doc6"  value="Y" <%if(s>0 && value[5].equals("Y"))%>checked<%%>><%=d_var6%>
								  <input type="checkbox" name="app_doc7"  value="Y" <%if(s>0 && value[6].equals("Y"))%>checked<%%>><%=d_var7%>
								  <br>
								  <input type="checkbox" name="app_doc8"  value="Y" <%if(s>0 && value[7].equals("Y"))%>checked<%%>><%=d_var8%>								  
								  <br>
								  <input type="checkbox" name="app_doc10" value="Y" <%if(s>0 && value[9].equals("Y"))%>checked<%%>><%=d_var10%>
								  <input type="checkbox" name="app_doc11" value="Y" <%if(s>10 && value[10].equals("Y"))%>checked<%%>><%=d_var11%>
								  
								  <br><br>* 대차료공문에 첨부할 서류만 체크해주세요.
								</td>
							</tr>
						</table>
                    </td>
                </tr>				
            </table>
        </td>
    </tr>    
	<%if(ti.getCar_mng_id().equals("")){%>
    <tr> 
        <td>&nbsp;</td>
        <td width="50%" align="right">
        	<a href="javascript:accid_tax()" title='청구서발행'><img src="/acar/images/center/button_cgsbh.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href="javascript:DocSelect()" title='청구서류일괄인쇄'><img src="/acar/images/center/button_print_ig.gif" align="absmiddle" border="0"></a>		
		</td>
    </tr>	
	<%}else{%>	
    <tr> 
        <td>&nbsp; </td>
        <td align="right">
		<a href="javascript:DocPrint()" title='청구서인쇄'><img src="/acar/images/center/button_print_cgs.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;		
		<%if(t_bean.getTax_no().equals("") && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄변경담당자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id) || user_id.equals(bus_id2))){%>	  
	  	<a href="javascript:ViewTaxItem()" title='거래명세서수정'><img src=/acar/images/center/button_modify_bill.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	  	<%}%>
		<a href="javascript:MM_openBrWindow('아마존카_신한은행_통장사본.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_tj.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href="javascript:DocSelect()" title='청구서류일괄인쇄'><img src="/acar/images/center/button_print_ig.gif" align="absmiddle" border="0"></a>
		</td>
    </tr>	
	<%}%>
	<%
		Vector settles = s_db.getInsurHReqDocHistoryList(c_id, accid_id, seq_no);
		int settle_size = settles.size();%>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대차료청구공문</span>
		<%	if(ma_bean.getDoc_req_dt().equals("")){%>
		<%		if(settle_size==0){%>&nbsp;<a href="javascript:accid_doc_req_msg()"><img src="/acar/images/center/button_send_smsdc.gif" align="absmiddle" border="0"></a>
		        					 &nbsp;<font color=green>(보험사, 담당자, 주소, 첨부서류를 꼭 입력하세요.)</font>
		<%		}%>
		<%	}else{%>
		&nbsp;<font color=green><%=AddUtil.getDate3(ma_bean.getDoc_req_dt())%>에 대차료청구공문발행의뢰 하였음.</font>
		<%	}%>
		</td>
    </tr>
	<%	if(settle_size > 0){%>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class="line" colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            	  <tr> 
            	    <td class='title' width=5%> 연번</td>
		            <td class='title' width="15%">문서번호</td>
		            <td class='title' width="15%">시행일자</td>
		            <td class='title' width="40%">수신</td>
		            <td class='title' width="15%">참조</td>
		            <td class='title' width="10%">등록자</td>					
		          </tr>          
                </tr>
        		<%	for (int i = 0 ; i < settle_size ; i++){
						Hashtable settle = (Hashtable)settles.elementAt(i);%>		  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td align='center'><a href="javascript:FineDocPrint('<%=settle.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><%=settle.get("DOC_ID")%></a></td>
			        <td align='center'><%=settle.get("DOC_DT")%></td>
			        <td align='center'><%=settle.get("GOV_NM")%></td>
			        <td align='center'><%=settle.get("MNG_DEPT")%> <%=settle.get("MNG_NM")%> <%=settle.get("MNG_POS")%></td>			
			        <td align='center'><%=settle.get("USER_NM")%></td>								
                </tr>
          		<%	}%>
            </table>
        </td>
    </tr>
	<%	}%>
    <tr><td class=h></td></tr>	
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;※ 차량번호/차명 : 대차차량정보</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;※ [계산하기] : 1일 청구기준 금액 계산 / [보기] : 계산과정 확인 (차종구분에 따라 1일 금액이 틀릴 수 있음. 전산팀에 문의하세요.)</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;※ 청구서 담당자 = 청구서 발행자</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;※ 입금액과 입금일자는 회계업무담당자만 처리합니다.</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#red>&nbsp;※ 대차료는 <font color=red>부가세 포함</font>한 금액을 청구합니다. /  계산서 발행의뢰는 <font color=red>청구일자</font>가 입력되어야 할 수 있습니다.</font> </td>
	</tr>					
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;※ 청구서류 일괄인쇄 : 아마존카 사업자등록증/단기대여요금표/통장사본, 사고차량 계약서/자동차등록증, 대차차량 계약서/자동차등록증, 청구용 거래명세서를 선택하여 인쇄할수 있습니다.</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;※ 청구일자는 한번 입력하면 수정할 수 없습니다.</font> </td>
	</tr>			
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
