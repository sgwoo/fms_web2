<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.common.*, acar.util.*, acar.bill_mng.*, acar.pay_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");	
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	
	/* 코드 구분:제1금융권 */
	CodeBean[] banks = c_db.getBankList("1");
	int bank_size = banks.length;
	/* 코드 구분:제1금융권 */
	CodeBean[] banks2 = c_db.getBankList("2");
	int bank_size2 = banks2.length;
	
	/* 영업소 조회 */
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	//사원 사용자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	//은행대출 정보
	BankLendBean bl = abl_db.getBankLend(lend_id);

	//대출중도상환		
	Vector cls_vt =  as_db.getClsBankList(lend_id);
	int cls_vt_size = cls_vt.size();
		
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
	//네오엠 은행리스트
	CodeBean[] a_banks = neoe_db.getCodeAll();
	int a_bank_size = a_banks.length;
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LEND_BANK";
	String content_seq  = lend_id;
	
	Vector attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
	int attach_vt_size = attach_vt.size();
	
	//금융사리스트
	Vector p_bank_vt =  ps_db.getCodeList("0003");
	int p_bank_size = p_bank_vt.size();
		
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		if(file_type == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/bank/"+theURL+".pdf";
		}else{			
			theURL = "https://fms3.amazoncar.co.kr/data/bank/"+theURL+""+file_type;		
		}
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}					
		popObj.location = theURL;
		popObj.focus();		

	}

		
	//수정
	function modify(){
		var fm = document.form1;	
		
		var deposit_no = fm.deposit_no_d.options[fm.deposit_no_d.selectedIndex].value;		
		if(deposit_no.indexOf(":") == -1){
			fm.deposit_no_d.value = deposit_no;
		}else{
			var deposit_split = deposit_no.split(":");
			fm.deposit_no_d.value = deposit_split[0];	
 		}
		
		fm.p_bank_nm.value = fm.ps_bank_id.options[fm.ps_bank_id.selectedIndex].text;
		
		if(fm.p_bank_nm.value == '선택')		fm.p_bank_nm.value = '';
		
		
		if(confirm('수정하시겠습니까?')){
			if(fm.cont_dt.value == ''){	alert('계약일을 입력하십시오');	fm.cont_dt.focus(); return;	}			
			if(fm.cont_bn_st.value == '1') 	fm.cont_bn.value = fm.cont_bn.value;
			else 							fm.cont_bn.value = fm.cont_bn2.value;
			fm.action='bank_lend_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//목록
	function go_to_list(){
		var fm = document.form1;	
		fm.action ='bank_frame_s.jsp';
		fm.target='d_content';		
		fm.submit();	
	}
	
	//순차-진행완료일때 1차일시상환 입력시 대출금액,상환총액 셋팅	
	function set_cont_amt(idx){
		var fm = document.form1;	
		fm.idx.value = idx;
		fm.target = 'i_no';
		fm.action = 'lim_dt_nodisplay.jsp';
//		fm.submit();		
	}
	
	//수수료 합계 계산
	function set_total_amt(){
		var fm = document.form1;
		fm.total_amt.value = parseDecimal(toInt(parseDigit(fm.charge_amt.value))+toInt(parseDigit(fm.ntrl_fee.value))+toInt(parseDigit(fm.stp_fee.value)));
	}
	
	//대출신청기간제한
	function lend_lim_chk(){
		var fm = document.form1;
		if(fm.lend_lim.value == '1'){//대출신청기간제한 있다.
			if(fm.lend_lim_st.value == '' || fm.lend_lim_et.value == ''){ alert('대출신청기간 제한을 입력하십시오'); fm.lend_lim_st.focus(); return;}		
			var today = getToday();
			var s_dt = replaceString("-","",fm.lend_lim_st.value);
			var e_dt = replaceString("-","",fm.lend_lim_et.value);
			if(parseInt(s_dt) > parseInt(today) || parseInt(today) > parseInt(e_dt)){
				alert(today+'는 대출신청기간 '+s_dt+'~'+e_dt+'이 지났습니다');
				return;
			}			
		}
	}

	//대출별등록
	function mapping_reg(){		
		var fm = document.form1;	
		if(fm.move_st.value == '1'){ alert('진행 완료된 은행대출입니다.\n\n대출별등록을 하실 수 없습니다.'); return; }		
//		if(fm.pm_rest_amt.value == '0' && fm.pm_amt.value > '0'){ alert('약정잔액이 0원 입니다.\n\n약정금액을 초과하여 등록할 수 없습니다.'); return; }
		if(confirm('약정잔액이 '+fm.pm_rest_amt.value+'원 입니다.\n\n대출별 등록을 하시겠습니까?')){
			if(fm.rtn_st.value == '0') lend_lim_chk()
			var auth_rw = fm.auth_rw.value;						
			var lend_id = fm.lend_id.value;			
			var cont_bn = fm.cont_bn.value;		
			var lend_int = fm.lend_int.value;
			var max_cltr_rat = fm.max_cltr_rat.value;
			var lend_amt_lim = fm.lend_amt_lim.value;
			var rtn_st = fm.rtn_st.value;		
			var rtn_size = fm.rtn_size.value;				
			if(fm.cont_bn_st.value == '2') cont_bn = fm.cont_bn2.value;
			window.open('bank_mapping_frame_s.jsp?gubun=reg&auth_rw='+auth_rw+'&lend_id='+lend_id+'&cont_bn='+cont_bn+'&lend_int='+lend_int+'&max_cltr_rat='+max_cltr_rat+'&lend_amt_lim='+lend_amt_lim+'&rtn_st='+rtn_st+'&rtn_size='+rtn_size, "MAPPING", "left=100, top=30, width=840, height=610, scrollbars=yes, status=yes");
		}
	}
	
	//은행별대출리스트
	function mapping_list(){
		var fm = document.form1;	
		var lend_id = fm.lend_id.value;	
		var auth_rw = fm.auth_rw.value;		
		var rtn_st = fm.rtn_st.value;		
		var rtn_size = fm.rtn_size.value;		
		var lend_int = fm.lend_int.value;							
		window.open('bank_mapping_frame_s.jsp?gubun=list&auth_rw='+auth_rw+'&lend_id='+lend_id+'&rtn_st='+rtn_st+'&rtn_size='+rtn_size+'&lend_int='+lend_int, "MAPPING", "left=20, top=20, width=900, height=700, scrollbars=yes, status=yes");
	}
	
	//상환스케줄 등록
	function scd_view(gu, idx, rtn_seq, cont_term){
		var fm = document.form1;
		var lend_id = fm.lend_id.value;	
		var auth_rw = fm.auth_rw.value;		
		if(gu == 'i'){
			parent.location='bank_scd_i.jsp?auth_rw='+auth_rw+'&lend_id='+lend_id+'&rtn_seq_r='+rtn_seq+'&cont_term='+cont_term;
		}else{
			parent.location='bank_scd_u.jsp?auth_rw='+auth_rw+'&lend_id='+lend_id+'&rtn_seq_r='+rtn_seq+'&cont_term='+cont_term;
		}
	}
	
	//은행대출담당자 셋팅
	function select_agnt(seq, nm, title, tel, email){
		var fm = document.form1;
		fm.seq.value = seq;
		fm.ba_nm.value = nm;
		fm.ba_tel.value = tel;
		fm.ba_title.value = title;
		fm.ba_email.value = email;
	}
	
	//은행대출담당자 수정
	function modify_agnt(idx){
		var fm = document.form1;
		var ment = '';
		if(idx == '1'){//수정
		 	fm.gubun.value='a_u';
			ment = '수정';
			if(fm.seq.value == ''){	alert('등록된 사용자를 선택하고 수정한 후 수정버튼을 누르십시오');	return;	}
			if(fm.ba_nm.value == ''){ alert('담당자 이름을 입력하십시오');	return;	}
		}else if(idx == '0'){//추가
			ment = '추가';		
			fm.gubun.value='a_i';
			if(fm.ba_nm.value == ''){ alert('담당자 이름을 입력하십시오');	return;	}
		}
		
		if(confirm(ment+'하시겠습니까?')){
			fm.action='bank_lend_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}	
		
	//디스플레이 타입
	function bn_display(){
		var fm = document.form1;
		if(fm.cont_bn_st.options[fm.cont_bn_st.selectedIndex].value == '1'){ //금융사구분 선택시 금융사 디스플레이
			td_bn_1.style.display	= '';
			td_bn_2.style.display	= 'none';
		}else{
			td_bn_1.style.display	= 'none';
			td_bn_2.style.display	= '';
		}
	}	
	//디스플레이 타입
	function docs_display(){
		var fm = document.form1;
		if(fm.cl_lim.options[fm.cl_lim.selectedIndex].value == '1'){ //거래처 제한선택시 상세조건 디스플레이
			tr_docs.style.display	= '';
		}else{
			tr_docs.style.display	= 'none';
		}
	}	
	//순차->진행완료시 추가버튼
	function add_display(){
		var fm = document.form1;
		var rtn_size = fm.rtn_size.value;
		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '1'){//순차
			if(rtn_size == '1' && fm.rtn_move_st0.value == '1')		td_add.style.display = '';	
			else if(rtn_size == '2' && fm.rtn_move_st1.value == '1')	td_add.style.display = '';	
			else if(rtn_size == '3' && fm.rtn_move_st2.value == '1')	td_add.style.display = '';	
			else if(rtn_size == '4' && fm.rtn_move_st3.value == '1')	td_add.style.display = '';	
			else if(rtn_size == '5' && fm.rtn_move_st4.value == '1')	td_add.style.display = '';												
			else 								td_add.style.display = 'none';			
		}
	} 
	//상환구분선택시 디스플레이 타입
	function rtn_display1(){
		var fm = document.form1;
		td_rtn_su.style.display	= 'none';
		td_add.style.display	= 'none';		
		tr_rtn_1.style.display	= '';
		tr_rtn_2.style.display	= 'none';
		tr_rtn_3.style.display	= 'none';
		tr_rtn_4.style.display	= 'none';
		tr_rtn_5.style.display	= 'none';
		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '2'){//분할
			td_rtn_su.style.display	= '';
		}
//		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '1'){//순차
//			td_add.style.display	= '';
//		}
	}
		
	//상환구분 분할에서 갯수 선택시 디스플레이 타입
	function rtn_display2(){
		var fm = document.form1;
		if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '1'){//분할(1)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= 'none';
			tr_rtn_3.style.display	= 'none';
			tr_rtn_4.style.display	= 'none';
			tr_rtn_5.style.display	= 'none';		
		}else if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '2'){//분할(2)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= '';
			tr_rtn_3.style.display	= 'none';
			tr_rtn_4.style.display	= 'none';
			tr_rtn_5.style.display	= 'none';
		}else if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '3'){//분할(3)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= '';
			tr_rtn_3.style.display	= '';
			tr_rtn_4.style.display	= 'none';
			tr_rtn_5.style.display	= 'none';
		}else if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '4'){//분할(4)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= '';
			tr_rtn_3.style.display	= '';
			tr_rtn_4.style.display	= '';
			tr_rtn_5.style.display	= 'none';
		}else if(fm.rtn_su.options[fm.rtn_su.selectedIndex].value == '5'){//분할(5)
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= '';
			tr_rtn_3.style.display	= '';
			tr_rtn_4.style.display	= '';
			tr_rtn_5.style.display	= '';
		}else{
			tr_rtn_1.style.display	= '';
			tr_rtn_2.style.display	= 'none';
			tr_rtn_3.style.display	= 'none';
			tr_rtn_4.style.display	= 'none';
			tr_rtn_5.style.display	= 'none';
		}
	}
	
	//상환구분 분할에서 갯수 선택시 디스플레이 타입
	function rtn_display3(){
		var fm = document.form1;
		var su = fm.su.value;	
		if(fm.rtn_st.options[fm.rtn_st.selectedIndex].value == '1'){//순차
			if(su ==1){		 
				tr_rtn_1.style.display	= '';
				tr_rtn_2.style.display	= '';
				tr_rtn_3.style.display	= 'none';
				tr_rtn_4.style.display	= 'none';
				tr_rtn_5.style.display	= 'none';
			}else if(su ==2){			
				tr_rtn_1.style.display	= '';
				tr_rtn_2.style.display	= '';
				tr_rtn_3.style.display	= '';
				tr_rtn_4.style.display	= 'none';
				tr_rtn_5.style.display	= 'none';
			}else if(su ==3){			
				tr_rtn_1.style.display	= '';
				tr_rtn_2.style.display	= '';
				tr_rtn_3.style.display	= '';
				tr_rtn_4.style.display	= '';
				tr_rtn_5.style.display	= 'none';
			}else if(su ==4){			
				tr_rtn_1.style.display	= '';
				tr_rtn_2.style.display	= '';
				tr_rtn_3.style.display	= '';
				tr_rtn_4.style.display	= '';
				tr_rtn_5.style.display	= '';
			}
			fm.su.value = parseInt(su)+1;			
		}
	}	
	
	//중도해지
	function view_cls(cls_yn, rtn_seq){	
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var lend_id = fm.lend_id.value;
		var url = "";
		url = "../cls_bank/cls_i.jsp?auth_rw="+auth_rw+"&lend_id="+lend_id+"&rtn_seq="+rtn_seq;
		window.open(url, "CLS_I", "left=100, top=80, width=840, height=550, status=yes, scrollbars=yes");
	}		
	
	//중도해지
	function view_cls_list(cls_yn, rtn_seq){	
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var lend_id = fm.lend_id.value;
		var url = "";
		url = "../cls_bank/cls_list.jsp?auth_rw="+auth_rw+"&lend_id="+lend_id+"&rtn_seq="+rtn_seq;
		window.open(url, "CLS_LIST", "left=10, top=80, width=1040, height=550, status=yes, scrollbars=yes");
	}			
	
	//자동전표----------------------------------------------------------------------------------------------------
	
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
			fm.action='get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no_d.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no_d.options[deposit_len-(i+1)] = null;
		}
	}		
	function add_deposit(idx, val, str){
		document.form1.deposit_no_d[idx] = new Option(str, val);		
	}		
	//조회하기
	function ven_search(idx){
		var fm = document.form1;
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx, "VENDOR_LIST", "left=50, top=50, width=500, height=400, scrollbars=yes");		
	}
	
	//스캔등록
	function scan_reg(){
		window.open("reg_scan.jsp?lend_id=<%=lend_id%>&alt_st=lend_bank", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
			
		
	//스캔등록
	function scan_reg_scd(){
		window.open("reg_scan.jsp?lend_id=<%=lend_id%>&alt_st=scd", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}

	
	//시설자금 조회
	function search_fund_bank(){
		var fm = document.form1;
		window.open("/fms2/bank_mng/s_fund_bank.jsp?from_page=/acar/bank_mng/bank_lend_u.jsp&lend_id=<%=lend_id%>&cont_bn=<%=bl.getCont_bn()%>", "SEARCH_LEND_BANK", "left=50, top=50, width=750, height=600, scrollbars=yes");		
	}	
	
	//새로고침
	function go_to_self()
	{
		var fm = document.form1;	
		fm.action = 'bank_lend_u.jsp';
		fm.target = 'd_content';		
		fm.submit();
	}	
	
//-->
</script>
</head>

<body leftmargin=15>
<form action="bank_lend_u_a.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type="hidden" name="lend_id" value="<%=lend_id%>">
<input type='hidden' name='gubun' value=''>
<input type='hidden' name='idx' value=''>
<input type='hidden' name='alt_st' value='lend_bank'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>은행정보</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>계약일</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_dt" maxlength='11' value="<%=bl.getCont_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title width=10%>금융사구분</td>
                    <td width=15%>&nbsp; 
                      <select name='cont_bn_st'  onChange='javascript:bn_display()'>
                        <option value="1" <%if(bl.getCont_bn_st().equals("1")){%>selected<%}%>>제1금융권</option>
                        <option value="2" <%if(bl.getCont_bn_st().equals("2")){%>selected<%}%>>제2금융권</option>
                      </select>
                    </td>
                    <td class=title width=10%>금융사</td>
                    <td width=15%> 
                        <table width=100% border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id="td_bn_1" <%if(bl.getCont_bn_st().equals("1") || bl.getCont_bn_st().equals("")){%>style="display:''"<%}else{%>style='display:none'<%}%> >&nbsp; 
                                    <select name='cont_bn'>
                                      <%	if(bank_size > 0){
                								for(int i = 0 ; i < bank_size ; i++){
                									CodeBean bank = banks[i];		%>
                                      <option value='<%= bank.getCode()%>' <%if(bl.getCont_bn().equals(bank.getCode())){%>selected<%}%>><%= bank.getNm()%></option>
                                      <%		}
                							}		%>
                                    </select>
                                </td>
                                <td id="td_bn_2" <%if(bl.getCont_bn_st().equals("2")){%>style="display:''"<%}else{%>style='display:none'<%}%> >&nbsp; 
                                    <select name='cont_bn2'>
                                      <%	if(bank_size2 > 0){
                								for(int i = 0 ; i < bank_size2 ; i++){
                									CodeBean bank2 = banks2[i];		%>
                                      <option value='<%= bank2.getCode()%>' <%if(bl.getCont_bn().equals(bank2.getCode())){%>selected<%}%>><%= bank2.getNm()%></option>
                                      <%		}
                							}		%>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class=title width=10%>계약구분</td>
                    <td width=15%>&nbsp; 
                      <select name='cont_st'>
                        <option value="0" <%if(bl.getCont_st().equals("0")){%>selected<%}%>>신규</option>
                        <option value="1" <%if(bl.getCont_st().equals("1")){%>selected<%}%>>연장</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>지점</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="bn_br" maxlength='30' value="<%=bl.getBn_br()%>" size="43" class=text>
                    </td>
                    <td class=title>지점전화번호</td>
                    <td>&nbsp; 
                      <input type="text" name="bn_tel" maxlength='15' value="<%=bl.getBn_tel()%>" size="15" class=text>
                    </td>
                    <td class=title>지점팩스번호</td>
                    <td>&nbsp; 
                      <input type="text" name="bn_fax" maxlength='15' value="<%=bl.getBn_fax()%>" size="15" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>NO</td>
                    <td class=title width=15%>대출 담당자</td>
                    <td class=title width=15%>직위</td>
                    <td class=title width=20%>연락처</td>
                    <td class=title width=25%>E-mail</td>
                    <td class=title width=15%>&nbsp;</td>
                </tr>
              <%Vector agnts = abl_db.getBankAgnts(lend_id);
    			int agnt_size = agnts.size();
    			if(agnt_size > 0){%>
              <%				for(int i = 0 ; i < agnt_size ; i++){
    					BankAgntBean agnt = (BankAgntBean)agnts.elementAt(i);%>
                <tr> 
                    <td align="center"><%=agnt.getSeq()%></td>
                    <td align="center"><a href="javascript:select_agnt('<%=agnt.getSeq()%>', '<%=agnt.getBa_nm()%>', '<%=agnt.getBa_title()%>', '<%=agnt.getBa_tel()%>', '<%=agnt.getBa_email()%>')" onMouseOver="window.status=''; return true"><%=agnt.getBa_nm()%></a></td>
                    <td align="center"><%=agnt.getBa_title()%></td>
                    <td align="center"><%=agnt.getBa_tel()%></td>
                    <td align="center"><%=agnt.getBa_email()%></td>
                    <td></td>
                </tr>
              <%				}
    			}		%>
                <tr align="center"> 
                    <td> 
                      <input type="hidden" name="seq" value="" size="12" maxlength='30'>
                    </td>
                    <td> 
                      <input type="text" name="ba_nm" value="" size="12" maxlength='30' class=text>
                    </td>
                    <td> 
                      <input type="text" name="ba_title" value="" size="13" maxlength='30' class=text>
                    </td>
                    <td> 
                      <input type="text" name="ba_tel" value="" size="15" maxlength='15' class=text>
                    </td>
                    <td> 
                      <input type="text" name="ba_email" value="" size="25" maxlength='50' class=text>
                    </td>
                    <td> 
                      <a href="javascript:modify_agnt('1');"><img src=../images/center/button_in_modify.gif align=absmiddle border=0></a>
                      &nbsp;&nbsp; 
                      <a href="javascript:modify_agnt('0');"><img src=../images/center/button_in_plus.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>담당 영업소</td>
                    <td width=15%>&nbsp; 
                      <select name='br_id'>
                        <option value=''>선택</option>
                        <%	if(brch_size > 0)	{
        						for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);		%>
                        <option value='<%=branch.get("BR_ID")%>' <%if(bl.getBr_id().equals(branch.get("BR_ID"))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%		}
        					}			%>
                      </select>
                    </td>
                    <td class=title width=10%>담당자</td>
                    <td width=15%>&nbsp; 
                      <select name='mng_id'>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%= user.get("USER_ID") %>' <%if(bl.getMng_id().equals(user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title width=10%>진행여부</td>
                    <td width=40%>&nbsp; 
                      <select name='move_st'>
                        <option value="0" <%if(bl.getMove_st().equals("0")){%>selected<%}%>>진행</option>
                        <option value="1" <%if(bl.getMove_st().equals("1")){%>selected<%}%>>완료</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>승인조건</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>거래처 제한</td>
                    <td colspan="7">&nbsp; 
                      <select name='cl_lim'  onChange='javascript:docs_display()'>
                        <option value="1" <%if(bl.getCl_lim().equals("1")){%>selected<%}%>>유</option>
                        <option value="0" <%if(bl.getCl_lim().equals("0")){%>selected<%}%>>무</option>
                      </select>
                    </td>
                </tr>
                <tr id=tr_docs  <%if(!bl.getCl_lim().equals("0")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                    <td class=title>상세조건</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="cl_lim_sub" cols="90" rows="2"><%=bl.getCl_lim_sub()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class=title>개인 제한</td>
                    <td colspan="7">&nbsp; 
                      <select name='ps_lim'>
                        <option value="1" <%if(bl.getPs_lim().equals("1")){%>selected<%}%>>유</option>
                        <option value="0" <%if(bl.getPs_lim().equals("0")){%>selected<%}%>>무</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title style='height:40'>대출금액<br>제한</td>
                    <td colspan="5">&nbsp; 
                      <select name='lend_amt_lim'>
                        <option value="" <%if(bl.getLend_amt_lim().equals("")){%>selected<%}%>>선택</option>
                        <option value="1" <%if(bl.getLend_amt_lim().equals("1")){%>selected<%}%>>(차량가격(탁송료포함)/1.1)에 나온 금액에 만원단위 절사</option>
                        <option value="3" <%if(bl.getLend_amt_lim().equals("3")){%>selected<%}%>>(차량가격(탁송료포함)/1.1)에 나온 금액에 천원단위 절사</option>
                        <option value="4" <%if(bl.getLend_amt_lim().equals("4")){%>selected<%}%>>(차량가격(탁송료포함)/1.1)에 나온 금액에 백원단위 절사</option>
        				<option value="2" <%if(bl.getLend_amt_lim().equals("2")){%>selected<%}%>>(차량가격(탁송료포함)의 85%)에 나온 금액에 만원단위 절사</option>
        				<option value="5" <%if(bl.getLend_amt_lim().equals("5")){%>selected<%}%>>(차량가격(탁송료포함)의 70%)에 나온 금액에 만원단위 절사</option>				
                        <option value="0" <%if(bl.getLend_amt_lim().equals("0")){%>selected<%}%>>없음</option>
                      </select>
                      <font color="#999999">(계산식)</font><%=bl.getRtn_change()%></td>
                    <td class=title>상환금을 약정<br>잔액으로 대체</td>
                    <td>&nbsp; 
                      <select name='rtn_change'>
                        <option value="0" <%if(bl.getRtn_change().equals("0")){%>selected<%}%>>무</option>
                        <option value="1" <%if(bl.getRtn_change().equals("1")){%>selected<%}%>>유</option>
                      </select>
                    </td>
                </tr>		  
                <tr> 
                    <td class=title style='height:40'>근저당설정<br>채권최고액</td>
                    <td>&nbsp;대출금의 
                      <input type="text" name="max_cltr_rat" value="<%=bl.getMax_cltr_rat()%>" maxlength='5' size="3" class=text>
                      (%)</td>
                    <td class=title>대출신청<br>기간제한 유무</td>
                    <td>&nbsp; 
                      <select name='lend_lim'>
                        <option value="1" <%if(bl.getLend_lim().equals("1")){%>selected<%}%>>유</option>
                        <option value="0" <%if(bl.getLend_lim().equals("0")){%>selected<%}%>>무</option>
                      </select>
                    </td>
                    <td class=title>대출신청<br>기간제한</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="lend_lim_st" value="<%=bl.getLend_lim_st()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="lend_lim_et" value="<%=bl.getLend_lim_et()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class=title style='height:40'>채권양도양수<br>계약서</td>
                    <td colspan="7">&nbsp; 
                      <input type="text" name="cre_docs" value="<%=bl.getCre_docs()%>" maxlength='80' size="80" class=text>
                      <font color="#999999">(예:보증인 입보등)</font></td>
                </tr>
                <tr> 
                    <td class=title>기타</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="note" cols="152" rows="2"><%=bl.getNote()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class=title>선이자율</td>
                    <td>&nbsp; 
                      <input type="text" name="f_rat" value="<%=bl.getF_rat()%>" size="5" maxlength='5' class=text>
                      (%)</td>
                    <td class=title>선이자액</td>
                    <td>&nbsp; 
                      <input type="text" name="f_amt" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getF_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원</td>
                    <td class=title>적용기간</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="f_start_dt" value="<%=bl.getF_start_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="f_end_dt" value="<%=bl.getF_end_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width=10%>수수료</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="charge_amt" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getCharge_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_total_amt();'>
                      원</td>
                    <td class='title' width=10%>공증료</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="ntrl_fee" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getNtrl_fee())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_total_amt();'>
                      원</td>
                    <td class='title' width=10%>인지대</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="stp_fee" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getStp_fee())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_total_amt();'>
                      원</td>
                    <td class='title' width=10%">합계</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="total_amt" maxlength='9' value="<%=AddUtil.parseDecimal(bl.getCharge_amt()+bl.getNtrl_fee()+bl.getStp_fee())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>조건</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="condi" cols="152" rows="2"><%=bl.getCondi()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약정보</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>대출금액</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_amt"  value="<%=AddUtil.parseDecimalLong(bl.getCont_amt())%>" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원</td>
                    <td class=title width=10%>대출이율</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="lend_int" value="<%=bl.getLend_int()%>" maxlength='10' size="10" class=text>
                      (%)</td>
                    <td class=title width=10%>상환구분</td>
                    <td width=40%> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td width="70">&nbsp; 
                                    <select name='rtn_st'  onChange='javascript:rtn_display1()'>
                                      <option value="0" <%if(bl.getRtn_st().equals("0")){%>selected<%}%>>전체</option>
                                      <option value="1" <%if(bl.getRtn_st().equals("1")){%>selected<%}%>>순차</option>
                                      <option value="2" <%if(bl.getRtn_st().equals("2")){%>selected<%}%>>분할</option>
                                    </select>
                                </td>
                                <td width="70" id="td_rtn_su"> 
                                    <select name='rtn_su'  onChange='javascript:rtn_display2()'>
                                      <option value=""  <%if(bl.getRtn_su().equals("")){%>selected<%}%>>선택</option>
                                      <option value="1" <%if(bl.getRtn_su().equals("1")){%>selected<%}%>>1</option>					  
                                      <option value="2" <%if(bl.getRtn_su().equals("2")){%>selected<%}%>>2</option>
                                      <option value="3" <%if(bl.getRtn_su().equals("3")){%>selected<%}%>>3</option>
                                      <option value="4" <%if(bl.getRtn_su().equals("4")){%>selected<%}%>>4</option>
                                      <option value="5" <%if(bl.getRtn_su().equals("5")){%>selected<%}%>>5</option>
                                    </select>
                                </td>
                                <td align="right"><img src=../images/center/arrow_help.gif align=absmiddle> : <a href="#" title="상환없다. 계약을 매핑한후 스케줄 생성한다.">전체</a>/ 
                                <a href="#" title="상환이 순차로 발생한다.(1차,2차)  스케줄은 상환별로 생성한다. 계약을 매핑한다.">순차</a>/ 
                                <a href="#" title="한번에 여러개로 분할하여 상환한다.">분할</a>&nbsp;&nbsp;</td>            				  
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>채권확보유형</td>
                    <td colspan='5'>&nbsp; 
                            <select name='bond_get_st'>
                              <option value="" <%if(bl.getBond_get_st().equals("")){%>selected<%}%>>선택</option>
                              <option value="1" <%if(bl.getBond_get_st().equals("1")){%>selected<%}%>>계약서 
                              </option>
                              <option value="2" <%if(bl.getBond_get_st().equals("2")){%>selected<%}%>>계약서+인감증명서</option>
                              <option value="3" <%if(bl.getBond_get_st().equals("3")){%>selected<%}%>>계약서+인감증명서+공증서</option>
                              <option value="4" <%if(bl.getBond_get_st().equals("4")){%>selected<%}%>>계약서+인감증명서+공증서+LOAN 
                              연대보증서계약자</option>
                              <option value="5" <%if(bl.getBond_get_st().equals("5")){%>selected<%}%>>계약서+인감증명서+공증서+LOAN 
                              연대보증서보증인</option>
                              <option value="6" <%if(bl.getBond_get_st().equals("6")){%>selected<%}%>>계약서+연대보증인</option>
                              <option value="7" <%if(bl.getBond_get_st().equals("7")){%>selected<%}%>>기타</option>
                            </select>
                          &nbsp;추가서류:&nbsp; 
                            <input type="text" name="bond_get_st_sub" maxlength='40' value="<%=bl.getBond_get_st_sub()%>" size="40" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>중도상환<br>수수료율</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cls_rtn_fee_int" maxlength='5' value="<%=bl.getCls_rtn_fee_int()%>" size="5" class=text >
                      (%)</td>
                    <td class=title wwidth=10%>중도상환<br>특이사항</td>
                    <td colspan='3'>&nbsp; 
                      <textarea name="cls_rtn_etc" cols="90" rows="2"><%=bl.getCls_rtn_etc()%></textarea></td>                    
                </tr>	
                <tr> 
                    <td class='title'>금융약정계약서</td>
                    <td colspan='5'>&nbsp; 
			<%if(attach_vt_size > 0){%>
			    <%	for (int j = 0 ; j < attach_vt_size ; j++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    					<%if(j+1 < attach_vt_size){%><br><%}%>
    			    <%	}%>		
        		<%}else{%>		
        		<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
        		<%}%>
                    </td>
                </tr>											
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>대출신청시 구비서류</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>대출신청시<br>준비서류</td>
                    <td colspan=3 width=90%>&nbsp; 
                      <textarea name="docs" cols="152" rows="2"><%=bl.getDocs()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
<%	Vector rtns = abl_db.getBankRtn(lend_id);
	int rtn_size = rtns.size();%>
	<tr>
	    <td class=h></td>
	</tr>	
    <tr> 
        <td width="740"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>상환조건</span></td>
        <td id="td_add" width="60" align="right" style='display:none'> 
            <input type="button" name="rtn_add" value="추가" onClick="javascript:rtn_display3();" title="상환구분이 순차일 경우, 상환을 추가하실 수 있습니다.">
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
<%	for(int i = 0 ; i < rtn_size ; i++){
		BankRtnBean rtn = (BankRtnBean)rtns.elementAt(i);
		int rtn_scd_size = Integer.parseInt(abl_db.getRtnScdYn(lend_id, rtn.getSeq()));
		
		long rtn_cont_amt = rtn.getRtn_cont_amt();
		
		Hashtable ven = new Hashtable();
		if(!rtn.getVen_code().equals("")){
			ven = neoe_db.getVendorCase(rtn.getVen_code());
		}
		
%>
	
    <tr id='tr_rtn_<%=i+1%>' style="display:<%if(!rtn.getSeq().equals("")) {%>''<% } else {%>none<%}%>"> 
        <input type='hidden' name='rtn_seq<%=i%>' value='<%=rtn.getSeq()%>'>
	    <input type='hidden' name='ven_value<%=i%>' value=''>
	    <input type='hidden' name='firm_value<%=i%>' value=''>
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>대출금액</td>
                    <td>&nbsp; 
                      <%if(bl.getRtn_st().equals("1") && rtn.getRtn_move_st().equals("0")){%>
                      - 
                      <input type="text" name="rtn_cont_amt<%=i%>" value="<%=AddUtil.parseDecimalLong(rtn_cont_amt)%>" size="15"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 
                      <%}else{%>
                      <input type="text" name="rtn_cont_amt<%=i%>" value="<%=AddUtil.parseDecimalLong(rtn.getRtn_cont_amt())%>" size="15"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 
                      <%}%>
                    </td>
                    <td class=title>대출기간</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="loan_start_dt<%=i%>" value="<%=rtn.getLoan_start_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="loan_end_dt<%=i%>" value="<%=rtn.getLoan_end_dt()%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title>진행여부</td>
                    <td>&nbsp; 
                      <select name='rtn_move_st<%=i%>'>
                        <option value="0" <%if(rtn.getRtn_move_st().equals("0"))%>selected<%%>>진행</option>
                        <option value="1" <%if(rtn.getRtn_move_st().equals("1"))%>selected<%%>>완료</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>상환총금액</td>
                    <td width=15%>&nbsp;                       
                      <%if(bl.getRtn_st().equals("1") && rtn.getRtn_move_st().equals("0")){%>
                      <input type="text" name="rtn_tot_amt<%=i%>" value="<%=AddUtil.parseDecimalLong(rtn_cont_amt)%>" size="15"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 
                      <%}else{%>
                      <input type="text" name="rtn_tot_amt<%=i%>" value="<%=AddUtil.parseDecimalLong(rtn.getRtn_tot_amt())%>" size="15"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 
                      <%}%>
                    </td>
                    <td class=title width=10%>월상환금액</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="alt_amt<%=i%>" value="<%=AddUtil.parseDecimal(rtn.getAlt_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원</td>
                    <td class=title width=10%>상환개시일</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_start_dt<%=i%>" maxlength='11' value="<%=rtn.getCont_start_dt()%>" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title width=10%>상환만료일</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_end_dt<%=i%>" maxlength='11' value="<%=rtn.getCont_end_dt()%>" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>상환개월</td>
                    <td>&nbsp; 
                      <input type="text" name="cont_term<%=i%>" value="<%=rtn.getCont_term()%>" maxlength='4' size="4" class=text>
                      개월</td>
                    <td class=title>상환약정일</td>
                    <td>&nbsp; 
                      <select name='rtn_est_dt<%=i%>'>
                        <%	for(int j=1; j<=31 ; j++){ //1~31일 %>
                        <option value='<%=j%>' <%if(rtn.getRtn_est_dt().equals(String.valueOf(j))){%>selected<%}%>><%=j%>일</option>
                        <% } %>
                        <option value='99' <%if(rtn.getRtn_est_dt().equals("99")){%>selected<%}%>>말일</option>
                      </select>
                    </td>
                    <td class='title'>상환조건</td>
                    <td>&nbsp; 
                      <select name='rtn_cdt<%=i%>'>
                        <option value='1' <%if(rtn.getRtn_cdt().equals("1")){%>selected<%}%>>원리금균등</option>
                        <option value='2' <%if(rtn.getRtn_cdt().equals("2")){%>selected<%}%>>원금균등</option>
                      </select>
                    </td>
                    <td class='title'>상환방법</td>
                    <td>&nbsp; 
                      <select name='rtn_way<%=i%>'>
                        <option value='1' <%if(rtn.getRtn_way().equals("1")){%>selected<%}%>>자동이체</option>
                        <option value='2' <%if(rtn.getRtn_way().equals("2")){%>selected<%}%>>지로</option>
                        <option value='3' <%if(rtn.getRtn_way().equals("3")){%>selected<%}%>>기타</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>1차 일시상환금</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_one_amt<%=i%>" value="<%=AddUtil.parseDecimal(rtn.getRtn_one_amt())%>" size="12" maxlength='12' class=num  onBlur="javascript:this.value=parseDecimal(this.value); set_cont_amt('<%=i%>');">
                      원 </td>
                    <td class=title>1차 일시상환일</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_one_dt<%=i%>" maxlength='11' value="<%=rtn.getRtn_one_dt()%>" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class='title' style='height:40'>2차 장기분할<br>상환</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="rtn_two_amt<%=i%>" value="<%=AddUtil.parseDecimal(rtn.getRtn_two_amt())%>" size="11" maxlength='12' class=num  onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 </td>
                </tr>
                <tr> 
                    <td class=title>계좌번호</td>
                    <td colspan="3">&nbsp; 
                      <input name="deposit_no<%=i%>" type="text" class=text id="deposit_no" value="<%=rtn.getDeposit_no()%>" size="20" ></td>
                    <td class='title'>네오엠거래처</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='ven_name<%=i%>' size='30' value='<%=ven.get("VEN_NAME")==null?"":ven.get("VEN_NAME")%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href='javascript:ven_search(<%=i%>)' onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif align=absmiddle border=0></a> 
        			  <input type='hidden' name='ven_code<%=i%>' size='10' value='<%=rtn.getVen_code()%>' class='text'></td>
                </tr>
                <tr> 
                    <td class=title>중도상환조건</td>
                    <td colspan="4">&nbsp; 
                      <textarea name="cls_rtn_condi<%=i%>" cols="82" rows="3"><%=rtn.getCls_rtn_condi()%></textarea>
                    </td>
                    <td colspan="2" align="center"> 
                      <%if(bl.getRtn_st().equals("1")){//순차
        			  		if(rtn_scd_size > 0 && rtn.getRtn_move_st().equals("1")){%>
                      <a href ="javascript:scd_view('u','<%=i%>','<%=rtn.getSeq()%>','<%=rtn.getCont_term()%>');"><img src=../images/center/button_in_sch.gif align=absmiddle border=0></a> 
                      <%	}else if(rtn_scd_size == 0 && rtn.getRtn_move_st().equals("1")){%>
                      <input type="button" name="rtn_sch_mk<%=i%>" value="상환스케줄 등록" onClick="javascript:scd_view('i','<%=i%>','<%=rtn.getSeq()%>','<%=rtn.getCont_term()%>');">
                      <%	}
        			  	}else if(bl.getRtn_st().equals("2")){//분할
        					if(rtn_scd_size > 0){%>
                      <a href ="javascript:scd_view('u','<%=i%>','<%=rtn.getSeq()%>','<%=rtn.getCont_term()%>');"><img src=../images/center/button_in_sch.gif align=absmiddle border=0></a>	
                      <%	}else if(rtn_scd_size == 0){%>
                      <input type="button" name="rtn_sch_mk<%=i%>" value="상환스케줄 등록" onClick="javascript:scd_view('i','<%=i%>','<%=rtn.getSeq()%>','<%=rtn.getCont_term()%>');">
                      <%	}
        			  	}else{}%>
                    </td>
                    <td align="center"> 					  
                      <%if(bl.getRtn_st().equals("1")){//순차
        			  		if(rtn_scd_size > 0 && rtn.getRtn_move_st().equals("1")){%>
                      <a href="javascript:view_cls('<%=rtn.getCls_yn()%>','<%=rtn.getSeq()%>');"><img src=../images/center/button_in_jdsh.gif align=absmiddle border=0></a>
                      <%	}
        			  	}else if(bl.getRtn_st().equals("2")){//분할
        					if(rtn_scd_size > 0){%>
                      <a href="javascript:view_cls('<%=rtn.getCls_yn()%>','<%=rtn.getSeq()%>');"><img src=../images/center/button_in_jdsh.gif align=absmiddle border=0></a>
                      <%	}
        			  	}else{}%>
					  <%if(cls_vt_size>0){//중도상환 이력%>	
					  &nbsp; &nbsp; &nbsp;<a href="javascript:view_cls_list('<%=rtn.getCls_yn()%>','<%=rtn.getSeq()%>');" title='중도상환 이력 보기'><img src=../images/center/button_in_see.gif align=absmiddle border=0></a>
					  <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <%}%>
    <input type='hidden' name='rtn_size' value='<%=rtn_size%>'>
	<input type='hidden' name='su' value='<%=rtn_size%>'>
    <%for(int i=rtn_size; i<5; i++){%>
    <tr id='tr_rtn_<%=i+1%>' style='display:none'> 
        <input type='hidden' name='rtn_seq<%=i%>' value='<%=i+1%>'>
	    <input type='hidden' name='ven_value<%=i%>' value=''>
	    <input type='hidden' name='firm_value<%=i%>' value=''>	  
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>대출금액</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_cont_amt<%=i%>"  value="0" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원</td>
                    <td>대출기간</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="loan_start_dt<%=i%>" value="" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="loan_end_dt<%=i%>" value="" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title>진행여부</td>
                    <td>&nbsp; 
                      <select name='rtn_move_st<%=i%>'>
                        <option value="0" selected>진행</option>
                        <option value="1">완료</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>상환총금액</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="rtn_tot_amt<%=i%>" value="" size="12"  class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원</td>
                    <td class=title width=10%>월상환금액</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="alt_amt<%=i%>" value="" size="12" maxlength='12' class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원</td>
                    <td class=title width=10%>상환개시일</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_start_dt<%=i%>" maxlength='11' value="" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title width=10%>상환만료일</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cont_end_dt<%=i%>" maxlength='11' value="" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>상환개월</td>
                    <td>&nbsp; 
                      <input type="text" name="cont_term<%=i%>" value="" maxlength='4' size="4" class=text>
                      개월</td>
                    <td class=title>상환약정일</td>
                    <td>&nbsp; 
                      <select name='rtn_est_dt<%=i%>'>
                        <%	for(int j=1; j<=31 ; j++){ //1~31일 %>
                        <option value='<%=j%>'><%=j%>일 </option>
                        <% } %>
                        <option value='99'> 말일 </option>
                      </select>
                    </td>
                    <td class='title'>상환조건</td>
                    <td>&nbsp; 
                      <select name='rtn_cdt<%=i%>'>
                        <option value='1'>원리금균등</option>
                        <option value='2'>원금균등</option>
                      </select>
                    </td>
                    <td class='title'>상환방법</td>
                    <td>&nbsp; 
                      <select name='rtn_way<%=i%>'>
                        <option value='1'>자동이체</option>
                        <option value='2'>지로</option>
                        <option value='3'>기타</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>1차 일시상환금</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_one_amt<%=i%>" value="" size="12"  class=num  onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 </td>
                    <td class=title>1차 일시상환일</td>
                    <td>&nbsp; 
                      <input type="text" name="rtn_one_dt<%=i%>" maxlength='11' value="" size="11" class=text  onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class='title' style='height:40'>2차 장기분할<br>상환</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="rtn_two_amt<%=i%>" value="" size="12"  class=num  onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 </td>
                </tr>
                <tr> 
                    <td class=title>계좌번호</td>
                    <td colspan="3">&nbsp; 
                      <input name="deposit_no<%=i%>" type="text" class=text id="deposit_no" value="" size="20" ></td>
                    <td class='title'>네오엠거래처</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='ven_name<%=i%>' size='30' value='<%//=ven.get("VEN_NAME")==null?"":ven.get("VEN_NAME")%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href='javascript:ven_search(<%=i%>)' onMouseOver="window.status=''; return true">검색</a> 
        			  <input type='hidden' name='ven_code<%=i%>' size='10' value='<%//=rtn.getVen_code()%>' class='text'></td>
                </tr>		  
                <tr> 
                    <td class=title>중도상환조건</td>
                    <td colspan="7">&nbsp; 
                      <textarea name="cls_rtn_condi<%=i%>" cols="90" rows="2"></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>할부 자동전표 정보</span></td>
    </tr>
<input type='hidden' name='bank_code2' value='<%=bl.getBank_code()%>'>
<input type='hidden' name='deposit_no2' value='<%=bl.getDeposit_no_d()%>'>
<input type='hidden' name='bank_name' value=''>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
        		    <td class=title width=10%>자동전표</td>
        			<td width=40%>&nbsp;
        			  <input type="checkbox" name="autodoc_yn" value="Y" <%if(bl.getAutodoc_yn().equals("Y")){%>checked<%}%>></td>
                    <td class=title width=10%>계정과목</td>
                    <td width=40%>&nbsp;
                      <input type="radio" name="acct_code" value="26000" <%if(bl.getAcct_code().equals("26000"))%>checked<%%>>
        				단기차입금
        			  <input type="radio" name="acct_code" value="29300" <%if(bl.getAcct_code().equals("26400")||bl.getAcct_code().equals("29300"))%>checked<%%>>
        				장기차입금</td>
                </tr>
                <tr> 
                    <td class=title>은행</td>
                    <td rowspan='2'>&nbsp; 
                      <select name='bank_code' onChange='javascript:change_bank()'>
                        <option value=''>선택</option>
                        <%if(a_bank_size > 0){
        						for(int i = 0 ; i < a_bank_size ; i++){
        							CodeBean a_bank = a_banks[i];	%>
                        <option value='<%= a_bank.getCode()%><%= a_bank.getNm()%>' <%if(bl.getBank_code().equals(a_bank.getCode()))%>selected<%%>> <%= a_bank.getNm()%> 
                        </option>
                        <%	}
        					}	%>
                      </select>
                    </td>
                    <td class=title>당사 계좌번호</td>
                    <td>&nbsp; 
                      <select name='deposit_no_d'>
                        <option value=''>계좌를 선택하세요</option>
        				<%if(!bl.getBank_code().equals("")){
        						Vector deposits = neoe_db.getDepositList(bl.getBank_code());
        						int deposit_size = deposits.size();
        						for(int i = 0 ; i < deposit_size ; i++){
        							Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
        				<option value='<%=deposit.get("DEPOSIT_NO")%>' <%if(bl.getDeposit_no_d().equals(String.valueOf(deposit.get("DEPOSIT_NO"))))%>selected<%%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
        				<%		}
        				}%>
                      </select>
                      (자동이체)
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>할부상환방식 계좌이체인 경우</span></td>
    </tr>              
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <tr>
            		<td class=title width=10%>입금계좌</td>
            		<td >&nbsp;
              			<select name='ps_bank_id'>
                			<option value=''>선택</option>
                			<%	for(int i = 0 ; i < p_bank_size ; i++){
									Hashtable bank_ht = (Hashtable)p_bank_vt.elementAt(i);
							%>
                			<option value='<%= bank_ht.get("BANK_ID")%>' <%if(String.valueOf(bank_ht.get("BANK_ID")).equals(bl.getP_bank_id())||String.valueOf(bank_ht.get("NM")).equals(bl.getP_bank_nm()))	%>selected<%%>><%= bank_ht.get("NM")%></option>
                			<%	}%>
              			</select>
            			<input type='text' name='p_bank_no' size='33' value='<%=bl.getP_bank_no()%>' class='default' >							
						<input type='hidden' name='p_bank_id' 	value='<%=bl.getP_bank_id()%>'>
						<input type='hidden' name='p_bank_nm' 	value='<%=bl.getP_bank_nm()%>'>
            			(지출처 계좌, <font color="#FF0000">계좌이체일 때</font>) 
            		</td>
          		</tr>                
            </table>
        </td>
    </tr>
    	
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>자금관리</span></td>
    </tr> 
    <tr> 
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=10%>관리번호</td>
                    <td>&nbsp;
        			<%if(bl.getFund_id().equals("")){%>
        			<a href="javascript:search_fund_bank()">[자금관리연결]</a>
        			<%}else{
        				WorkingFundBean wf = abl_db.getWorkingFundBean(bl.getFund_id());%>
        			<%=wf.getFund_no()%>
        			<%}%>			
        			</td>
                    
                </tr>
            </table>
        </td>
    </tr>       
    
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=10%>약정금액</td>
                    <td width=15%>
        			<%if(bl.getCont_bn().equals("0016") && bl.getCont_amt() == 0){%>
        			<input type="text" name="pm_amt" value="<%=AddUtil.parseDecimalLong(bl.getLend_a_amt())%>" size="12" class=whitenum>원
        			<%}else{%>
        			<input type="text" name="pm_amt" value="<%=AddUtil.parseDecimalLong(bl.getCont_amt())%>" size="12" class=whitenum>원			
        			<%}%>			
        			</td>
                    <td class=title width=10%>대출승인금액</td>
                    <td width=15%><input type="text" name="lend_a_amt" value="<%=AddUtil.parseDecimalLong(bl.getLend_a_amt())%>" size="12" class=whitenum>원</td>
                    <td class=title width=10%>약정잔액</td>
                    <td width=40%>
        			<%if(bl.getCont_bn().equals("0016") && bl.getCont_amt() == 0){%>			
        					<input type="text" name="pm_rest_amt" value="0" size="12" class=whitenum>원			
        			<%}else{%>
        				<%if(bl.getRtn_change().equals("1")){%>
        					<input type="text" name="pm_rest_amt" value="<%=AddUtil.parseDecimal(bl.getPm_rest_amt()+bl.getAlt_pay_amt())%>" size="12" class=whitenum>원
        				<%}else{%>
        					<input type="text" name="pm_rest_amt" value="<%=AddUtil.parseDecimal(bl.getPm_rest_amt())%>" size="12" class=whitenum>원
        				<%}%>	
        			<%}%>						
        			</td>		
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td>
        			<a href="javascript:mapping_list()"><img src=../images/center/button_list_bank.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        		    <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
        			<a href="javascript:mapping_reg()"><img src=../images/center/button_reg_dc.gif align=absmiddle border=0></a> 
        		    <% } %>	
                    </td>
                    <td align='right' width="150"></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>    
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>스케줄 스캔파일</span>
            &nbsp;&nbsp;&nbsp;&nbsp;<%if( auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:scan_reg_scd()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a><%}%>	
        </td>
    </tr> 
    <%
    		//20160831 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
				content_code = "LEND_BANK";
				content_seq  = "scd"+lend_id;
	
				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				attach_vt_size = attach_vt.size();
				
				if(attach_vt_size>0){
    %>  
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td colspan="2" class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="10%" class=title>연번</td>
                  <td width="60%" class=title>스캔파일</td>
                  <td width="20%" class=title>등록일자</td>
                  <td width="10%" class=title>삭제</td>
                </tr>    
                <%for (int j = 0 ; j < attach_vt_size ; j++){
                		Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=j+1%></td>                    
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><%if( auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a><%}%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>                
    <%	}%>     
</table>
</form>
<script language='javascript'>
<!--
	add_display();
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>