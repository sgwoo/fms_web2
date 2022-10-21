<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.bank_mng.*, acar.cls.*, acar.bill_mng.*, acar.car_mst.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//팝업창에서 호출시 수정불가 처리를 위한 변수(2017.12.22)
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String modify_yn = ""; 
	if(from_page.equals("/off_ls_pre_go_debt_pop_a.jsp"))	modify_yn = "N";
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "02");
	
	CommonDataBase c_db = CommonDataBase.getInstance();

	//계약정보
	Hashtable cont = ad_db.getAllotByCase(m_id, l_cd);
	if(car_id.equals(""))	car_id = String.valueOf(cont.get("CAR_MNG_ID"));

	String ssn = AddUtil.ChangeEnpH(String.valueOf(cont.get("ENP_NO")));
	
	
	//출고영업소정보
	Hashtable mgrs = a_db.getCommiNInfo(m_id, l_cd);
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");
	
	CodeBean[] banks = c_db.getBankList("1"); /* 코드 구분:제1금융권 */	
	int bank_size = banks.length;
	CodeBean[] banks2 = c_db.getBankList("2"); /* 코드 구분:제2금융권 */
	int bank_size2 = banks2.length;
	
	//할부정보
	ContDebtBean debt = ad_db.getContDebtReg(m_id, l_cd);
	//근저당정보
	CltrBean cltr = ad_db.getBankLend_mapping_cltr(m_id, l_cd);
	//중도해지정보
	ClsAllotBean cls = as_db.getClsAllot(m_id, l_cd);
	
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 7; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
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
	
	function save(){
		var fm = document.form1;

		if(fm.allot_st.value == '2'){
			if(fm.cpt_cd.value == '' && fm.cpt_cd2.value == ''){	alert('금융사를 입력하십시오');	fm.lend_dt.focus(); return;	}		
			if(fm.lend_dt.value == ''){			alert('대출일자를 입력하십시오');		fm.lend_dt.focus(); 		return;	}
			if(fm.lend_prn.value == ''){		alert('대출원금을 입력하십시오');		fm.lend_prn.focus(); 		return;	}
//			if(fm.lend_int.value == ''){		alert('대출이율를 입력하십시오');		fm.lend_int.focus(); 		return;	}
			if(fm.rtn_tot_amt.value == ''){		alert('상환총금액을 입력하십시오');		fm.rtn_tot_amt.focus(); 	return;	}						
			if(fm.tot_alt_tm.value == ''){		alert('할부횟수를 입력하십시오');		fm.tot_alt_tm.focus(); 		return;	}						
			if(fm.alt_amt.value == ''){			alert('월상환료를 입력하십시오');		fm.alt_amt.focus();			return;	}		
		}

		fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.pay_sch_amt.value)) - toInt(parseDigit(fm.lend_prn.value)));

		//자동전표
		if(fm.autodoc_yn.checked == true){
			if(fm.ven_code.value == ""){ alert("거래처를 선택하십시오."); return; }
			if(fm.bank_code.value == ""){ alert("은행을 선택하십시오."); return; }			
			if(fm.deposit_no.value == ""){ alert("계좌번호를 선택하십시오."); return; }									
			//거래처
			//var ven_code = fm.ven_code.options[fm.ven_code.selectedIndex].value;
			//fm.ven_code2.value = ven_code.substring(0,6);
			//fm.firm_nm.value = ven_code.substring(6);
			//계좌번호
			fm.bank_code2.value = fm.bank_code.value;
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;
			var deposit_split = deposit_no.split(":");
			fm.deposit_no2.value = deposit_split[0];
		}		
		
		if(confirm('수정하시겠습니까?')){					
			fm.action='debt_reg_u_a.jsp';		
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}
	}

	function go_to_list(){
		var fm = document.form1;		
		fm.action='debt_scd_frame_s.jsp';		
		fm.target='d_content';
		fm.submit();	
	}
	
	//스케줄보기
	function go_to_scd(){
		var fm = document.form1;		
		fm.action='debt_scd_u.jsp';		
		fm.target='d_content';
		fm.submit();	
	}	
	
	//은행대출
	function go_lend_bank(lend_id){
		var fm = document.form1;		
		fm.action='../bank_mng/bank_reg_frame.jsp?lend_id='+lend_id;		
		fm.target='d_content';
		fm.submit();	
	}		
	//은행대출스케줄
	function go_lend_bank_scd(lend_id, rtn_seq){
		var fm = document.form1;		
		fm.action='../bank_mng/bank_scd_u.jsp?lend_id='+lend_id+'&rtn_seq_r='+rtn_seq;		
		fm.target='d_content';
		fm.submit();	
	}			

	//은행별대출리스트
	function mapping_list(lend_id, rtn_seq){
		var fm = document.form1;	
		var auth_rw = fm.auth_rw.value;		
		window.open('../bank_mng/bank_mapping_frame_s.jsp?gubun=list&auth_rw='+auth_rw+'&lend_id='+lend_id+'&s_rtn='+rtn_seq+'&rtn_st=0', "MAPPING", "left=100, top=30, width=900, height=650, scrollbars=yes, status=yes");
	}
		
	//할부기간,월상환료 셋팅
	function set_alt_term(obj){
		var fm = document.form1;	
		if(obj == fm.alt_start_dt){//할부기간 종료일 셋팅
			fm.action='debt_dt_nodisplay.jsp?alt_start_dt='+fm.alt_start_dt.value+'&tot_alt_tm='+fm.tot_alt_tm.value;
			fm.target='i_no';
			fm.submit();		
		}
		else if(obj == fm.lend_int_amt){
			fm.rtn_tot_amt.value = parseDecimal(toInt(parseDigit(fm.lend_prn.value)) + toInt(parseDigit(fm.lend_int_amt.value)));	
		}
		else if(obj == fm.rtn_tot_amt || obj == fm.tot_alt_tm){
			fm.alt_amt.value = parseDecimal(toInt(parseDigit(fm.rtn_tot_amt.value)) / toInt(parseDigit(fm.tot_alt_tm.value)));	
		}
	}		

	//근저당 설정 셋팅
	function set_cltr(obj){
		var fm = document.form1;	
		if(obj == fm.cltr_set_dt){//설정일자 입력
		  fm.cltr_f_amt.value = fm.cltr_amt.value;
		  fm.cltr_user.value = fm.cpt_cd_nm.value;
			fm.reg_tax.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.002);
			fm.set_stp_fee.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.004);
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else	if(obj == fm.reg_tax){//설정등록세 입력
			fm.set_stp_fee.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) * 2);
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else if(obj == fm.set_stp_fee){//설정인지대 입력
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else	if(obj == fm.exp_tax){//말소등록세 입력
//			fm.exp_stp_fee.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) * 2);
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
		}else if(obj == fm.exp_stp_fee){//말소인지대 입력
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
		}		
	}		
				
	//디스플레이 타입
	function bond_sub_display(){
		var fm = document.form1;
		if(fm.bond_get_st.options[fm.bond_get_st.selectedIndex].value == '7'){ //채권확보유형 선택시 기타입력 디스플레이
			td_bond_sub.style.display	= '';
		}else{
			td_bond_sub.style.display	= 'none';
		}
	}	

	//디스플레이 타입
	function bn_display(){
		var fm = document.form1;
		if(fm.cpt_cd_st.options[fm.cpt_cd_st.selectedIndex].value == '1'){ //금융사구분 선택시 금융사 디스플레이
			td_bn_1.style.display	= '';
			td_bn_2.style.display	= 'none';
		}else{
			td_bn_1.style.display	= 'none';
			td_bn_2.style.display	= '';
		}
	}	
	


	//중도해지
	function view_cls(){	
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var car_id = fm.car_id.value;
		var cls_yn = fm.cls_yn.value;
		var url = "";
		if(cls_yn == 'Y') 	url = "../cls_allot/cls_u.jsp?m_id="+m_id+"&l_cd="+l_cd+"&car_id="+car_id+"&auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		else				url = "../cls_allot/cls_i.jsp?m_id="+m_id+"&l_cd="+l_cd+"&car_id="+car_id+"&auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		window.open(url, "CLS_I", "left=100, top=80, width=840, height=550, status=yes, scrollbars=yes");
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
	//조회하기
	function ven_search(){
		var fm = document.form1;
		window.open("/acar/con_debt/vendor_list.jsp?idx=", "VENDOR_LIST", "left=300, top=300, width=430, height=400, scrollbars=yes");		
	}
	
	//스캔등록
	function scan_reg(){
		window.open("/acar/bank_mng/reg_scan.jsp?lend_id=<%=l_cd%>&alt_st=allot", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
			
	//스캔삭제
	function scan_del(){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){		return;	}
		fm.target = "i_no"
		fm.action = "/acar/bank_mng/del_scan_a.jsp";
		fm.submit();
	}	
		
	//시설자금 조회
	function search_fund_bank(){
		var fm = document.form1;
		window.open("/fms2/bank_mng/s_fund_bank.jsp?from_page=/fms2/bank_mng/debt_scd_reg_i.jsp&lend_id=&cont_bn="+fm.cpt_cd.value, "SEARCH_LEND_BANK", "left=50, top=50, width=750, height=600, scrollbars=yes");		
	}	
		

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>

<form name='form1' action='debt_reg_i_a.jsp' target='' method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='pay_sch_amt' value='<%=cont.get("CAR_F_AMT")%>'>
<input type='hidden' name='cls_yn' value='<%=debt.getCls_yn()%>'>
<input type='hidden' name='dif_amt' value=''>
<input type='hidden' name='rimitter' value=''>
<input type='hidden' name='cpt_cd_nm' value='<%=c_db.getNameById(debt.getCpt_cd(),"BANK")%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='alt_st' value='allot'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 구매자금관리 > 할부금관리 ><span class=style5>할부금 수정(건별)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right" colspan=2>
        <%if(modify_yn.equals("N")){%>
        	<br><div align="left"><b>현재 팝업창에서는 정보열람만 가능합니다. 등록 및 수정은 재무회계 > 자금관리 > 할부금상환스케줄조회 를 사용해 주세요.</b></div><br>
        <%}else{%>
		    <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>					  
		    <a href='javascript:save();'><img src=../images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		    <%	}%>		  
	        <a href='javascript:go_to_list();'><img src=../images/center/button_list.gif align=absmiddle border=0></a>
	    <%}%>    
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>계약번호</td>
                    <td>&nbsp;<%=l_cd%> </td>
                    <td class='title'>상호</td>
                    <td colspan="3">&nbsp;<%=cont.get("FIRM_NM")%> </td>
                    <td class='title'> 사업자등록번호</td>
                    <td align='left'>&nbsp;<%=ssn%></td>
                </tr>
                <tr> 
                    <td width='10%' class='title'> 차량번호</td>
                    <td width='15%'>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td width='10%' class='title'> 차명</td>
                    <td width='15%' align='left'>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm()+" "+mst.getCar_name(), 9)%></span></td>
                    <td width='10%' class='title'>소비자가격</td>
                    <td width='15%'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_C_AMT")))%>원&nbsp;</td>
                    <td width='10%' class='title'>구입가격</td>
                    <td width='15%'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_F_AMT")))%>원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>출고일자</td>
                    <td>&nbsp;<%=cont.get("DLV_DT")%></td>
                    <td class='title'>최초등록일자</td>
                    <td>&nbsp;<%=cont.get("INIT_REG_DT")%></td>
                    <td class='title'>계약기간</td>
                    <td>&nbsp;<%=cont.get("CON_MON")%>개월</td>
                    <td class='title'>대여방식</td>
                    <td>&nbsp;<%=cont.get("RENT_WAY")%></td>
                </tr>
                <tr> 
                    <td class='title'>계약개시일</td>
                    <td>&nbsp;<%=cont.get("RENT_START_DT")%></td>
                    <td class='title'>계약종료일</td>
                    <td>&nbsp;<%=cont.get("RENT_END_DT")%></td>
                    <td class='title'>월대여료</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("FEE_AMT")))%>원&nbsp;</td>
                    <td class='title'>총대여료</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("TOT_FEE_AMT")))%>원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'> 보증금</td>
                    <td align='left'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("GRT_AMT")))%>원&nbsp;</td>
                    <td class='title'>선납금</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("PP_AMT")))%>원&nbsp;</td>
                    <td class='title'>개시대여료</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("IFEE_AMT")))%>원&nbsp;</td>
                    <td class='title'>선수금총액</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("TOT_PRE_AMT")))%>원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>자동차회사</td>
                    <td align='left'>&nbsp;
                      <%if(mgr_dlv.get("COM_NM") != null) out.println(mgr_dlv.get("COM_NM"));%>
                    </td>
                    <td  class='title'>지점/영업소</td>
                    <td align='left'>&nbsp;
                      <%if(mgr_dlv.get("CAR_OFF_ST") != null && mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%>
                      &nbsp;
                      <%if(mgr_dlv.get("CAR_OFF_ST") != null && !mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%>
                    </td>
                    <td  class='title'>출고담당자</td>
                    <td align='left'>&nbsp;
                      <%if(mgr_dlv.get("NM") != null) out.println(mgr_dlv.get("NM"));%>
                      &nbsp;
                      <%if(mgr_dlv.get("POS") != null) out.println(mgr_dlv.get("POS"));%>
                    </td>
                    <td class='title'>전화번호</td>
                    <td align='left'>&nbsp;
                      <%if(mgr_dlv.get("O_TEL") != null) out.println(mgr_dlv.get("O_TEL"));%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
  <%if(debt.getLend_id().equals("")){%>  
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>자금관리</span></td>        
    </tr>  
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>자금관리번호</td>
                    <td >&nbsp; 
                    	<input type="text" name="fund_id" size="10" value='<%=debt.getFund_id()%>' class="text">
                    <%if(modify_yn.equals("N")){}else{%>	 
                    	<a href="javascript:search_fund_bank()">[자금관리연결]</a>
                    <%}%>	
                </tr>
            </table>
        </td>
    </tr>	    
  <%}else{%>
  <input type='hidden' name='fund_id' value='<%=debt.getFund_id()%>'>
  <%}%>
	<%if(!debt.getRtn_seq().equals("")){
		BankLendBean bl = abl_db.getBankLend(debt.getLend_id());
		BankRtnBean br  = new BankRtnBean();
		if(!debt.getRtn_seq().equals("")){
			br = abl_db.getBankRtn(debt.getLend_id(), debt.getRtn_seq());
		}%>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>묶음대출</span></td>
        <td align="right">
        <%if(modify_yn.equals("N")){}else{%> 
	    	<a href="javascript:mapping_list('<%=debt.getLend_id()%>', '<%=debt.getRtn_seq()%>')" onMouseOver="window.status=''; return true"><img src=../images/center/button_list_bank.gif align=absmiddle border=0></a>
	    <%}%>	
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>계약일</td>
                    <td width='15%'>&nbsp;<%=bl.getCont_dt()%></td>
                    <td width='10%' class='title'>대출번호</td>
                    <td width='15%'>&nbsp;<input type='text' name='lend_id' value='<%=debt.getLend_id()%>' size='4' maxlength='4' class='text'></td>
                    <td width='10%' class='title'>상환구분</td>
                    <td align='left'>&nbsp;<input type='text' name='rtn_seq' value='<%=debt.getRtn_seq()%>' size='2' maxlength='2' class='text'>&nbsp;		
                            <select name='rtn_st_nm' disabled>
                              <option value="0" <%if(bl.getRtn_st().equals("0")){%>selected<%}%>>전체</option>
                              <option value="1" <%if(bl.getRtn_st().equals("1")){%>selected<%}%>>순차</option>
                              <option value="2" <%if(bl.getRtn_st().equals("2")){%>selected<%}%>>분할</option>
                            </select>	
        			</td>
                </tr>
                <tr> 
                    <td class='title'>대출일자</td>
                    <td>&nbsp;<%=bl.getCont_dt()%></td>
                    <td class='title'>대출금액</td>
                    <td>&nbsp;<%=AddUtil.parseDecimalLong(br.getRtn_cont_amt())%></td>
                    <td class='title'>대출기간</td>
                    <td align='left'>&nbsp;<%=br.getCont_start_dt()%>~<%=br.getCont_end_dt()%>
                    <%if(modify_yn.equals("N")){}else{%>							
	        			&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:go_lend_bank('<%=debt.getLend_id()%>')"><img src=../images/center/button_in_bank.gif align=absmiddle border=0></a>
	        			&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:go_lend_bank_scd('<%=debt.getLend_id()%>', '<%=debt.getRtn_seq()%>')"><img src=../images/center/button_in_scha.gif align=absmiddle border=0></a>
	        		<%}%>				
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
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>할부관리</span></td>
        <td align="right"> 
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>할부구분</td>
                    <td width=15%>&nbsp; 
                      <select name='allot_st'>
                        <option value="1" <%if(debt.getAllot_st().equals("1")){%>selected<%}%>>현금구매</option>
                        <option value="2" <%if(debt.getAllot_st().equals("2")){%>selected<%}%>>할부구매</option>
                      </select>
                    </td>
                    <td class=title width=10%>금융사구분</td>
                    <td width=15%>&nbsp; 
                      <select name='cpt_cd_st' onChange='javascript:bn_display()'>
                        <option value=""  <%if(debt.getCpt_cd_st().equals("")){%>selected<%}%>>선택</option>
                        <option value="1"  <%if(debt.getCpt_cd_st().equals("1")){%>selected<%}%>>제1금융권</option>
                        <option value="2"  <%if(debt.getCpt_cd_st().equals("2")){%>selected<%}%>>제2금융권</option>
                      </select>
                    </td>
                    <td width=10% class='title'>금융사</td>
                    <td width=15%> 
                      <table width="115" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td id="td_bn_1" style="display:<%if(debt.getCpt_cd_st().equals("1") || debt.getCpt_cd_st().equals("")) {%>''<%}else{%>none<%}%>" width="115">&nbsp; 
                            <select name='cpt_cd'>
        	                <option value="" >선택</option>					
                              <%	if(bank_size > 0){
        								for(int i = 0 ; i < bank_size ; i++){
        									CodeBean bank = banks[i];		%>
                              <option value='<%= bank.getCode()%>'  <%if(debt.getCpt_cd().equals(bank.getCode())){%>selected<%}%>><%= bank.getNm()%></option>
                              <%		}
        							}		%>
                            </select>
                          </td>
                          <td id="td_bn_2" style="display:<%if(debt.getCpt_cd_st().equals("2")){%>''<%}else{%>none<%}%>" width="115">&nbsp; 
                            <select name='cpt_cd2'>
                     	   <option value="" >선택</option>					
                              <%	if(bank_size2 > 0){
        								for(int i = 0 ; i < bank_size2 ; i++){
        									CodeBean bank2 = banks2[i];		%>
                              <option value='<%= bank2.getCode()%>' <%if(debt.getCpt_cd().equals(bank2.getCode())){%>selected<%}%>><%= bank2.getNm()%></option>
                              <%		}
        							}		%>
                            </select>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td width=10% class='title'>대출번호 </td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='lend_no' value='<%=debt.getLend_no()%>' size='20' maxlength='30' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>대출일자 </td>
                    <td>&nbsp; 
                      <input type='text' name='lend_dt' value='<%=debt.getLend_dt()%>' size='11' maxlength='11' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td class='title'>대출원금 </td>
                    <td>&nbsp; 
                      <input type='text' name='lend_prn' value='<%=Util.parseDecimal(debt.getLend_prn())%>' size='11' maxlength='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td class='title'>대출이자</td>
                    <td>&nbsp; 
                      <input type='text' name='lend_int_amt' value='<%=Util.parseDecimal(debt.getLend_int_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
                      원</td>
                    <td class='title'>대출이율</td>
                    <td>&nbsp; 
                      <input type='text' name='lend_int' value='<%=debt.getLend_int()%>' size='6' maxlength='6' class='num'>
                      %</td>
                </tr>
                <tr> 
                    <td class='title'>상환총금액</td>
                    <td>&nbsp; 
                      <input type='text' name='rtn_tot_amt' value='<%=Util.parseDecimal(debt.getRtn_tot_amt())%>' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
                      원</td>
                    <td class='title'>상환의무자</td>
                    <td>&nbsp; 
                      <select name='loan_debtor'>
                        <option value='2' <%if(debt.getLoan_debtor().equals("2")){%>selected<%}%>>당사</option>
                        <option value='1' <%if(debt.getLoan_debtor().equals("1")){%>selected<%}%>>고객</option>
                      </select>
                    </td>
                    <td class='title'>상환조건</td>
                    <td>&nbsp; 
                      <select name='rtn_cdt'>
                        <option value='1' <%if(debt.getRtn_cdt().equals("1")){%>selected<%}%>>원리금균등</option>
                        <option value='2' <%if(debt.getRtn_cdt().equals("2")){%>selected<%}%>>원금균등</option>
                      </select>
                    </td>
                    <td class='title'>상환방법</td>
                    <td>&nbsp; 
                      <select name='rtn_way'>
                        <option value='1' <%if(debt.getRtn_way().equals("1")){%>selected<%}%>>자동이체</option>
                        <option value='2' <%if(debt.getRtn_way().equals("2")){%>selected<%}%>>지로</option>
                        <option value='3' <%if(debt.getRtn_way().equals("3")){%>selected<%}%>>기타</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>상환약정일 </td>
                    <td>&nbsp; 
                      <select name='rtn_est_dt'>
                        <%	for(int j=1; j<=31 ; j++){ //1~31일 %>
                        <option value='<%=j%>' <%if(debt.getRtn_est_dt().equals(Integer.toString(j))){%>selected<%}%>><%=j%>일 
                        </option>
                        <% } %>
                        <option value='99' <%if(debt.getRtn_est_dt().equals("99")){%>selected<%}%>> 
                        말일 </option>
                      </select>
                    </td>
                    <td class='title'>할부횟수 </td>
                    <td>&nbsp; 
                      <input type='text' name='tot_alt_tm' value='<%=debt.getTot_alt_tm()%>' size='3' maxlength='2' class='num' onBlur='javascript:set_alt_term(this);'>
                      회</td>
                    <td class='title'>할부기간 </td>
                    <td colspan="3">&nbsp; 
                      <input type='text' name='alt_start_dt' value='<%=debt.getAlt_start_dt()%>' size='11' maxlength='11' class='text'  onBlur='javscript:this.value=ChangeDate(this.value); set_alt_term(this);'>
                      ~ 
                      <input type='text' name='alt_end_dt' value='<%=debt.getAlt_end_dt()%>' size='11' maxlength='11' class='text'  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>월상환료</td>
                    <td>&nbsp; 
                      <input type='text' name='alt_amt' value='<%=Util.parseDecimal(debt.getAlt_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                    <td class='title'>할부수수료 </td>
                    <td>&nbsp; 
                      <input type='text' name='alt_fee' value='<%=Util.parseDecimal(debt.getAlt_fee())%>' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                    <td class='title'>공증료</td>
                    <td>&nbsp; 
                      <input type='text' name='ntrl_fee' value='<%=Util.parseDecimal(debt.getNtrl_fee())%>' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                    <td class='title'>인지대 </td>
                    <td>&nbsp; 
                      <input type='text' name='stp_fee' value='<%=Util.parseDecimal(debt.getStp_fee())%>' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>기타비용</td>
                    <td colspan='7'>&nbsp;
                      내용 : 
                      <input type="text" name="alt_etc" value='<%=debt.getAlt_etc()%>' maxlength='100' size="40" class=text>&nbsp; 
                      &nbsp; 총금액 :
                      <input type='text' name='alt_etc_amt' value='<%=AddUtil.parseDecimal(debt.getAlt_etc_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원
                      &nbsp; 회차 :
                      <input type='text' name='alt_etc_tm' value='<%=debt.getAlt_etc_tm()%>' size='3' maxlength='2' class='num'>
                      회
                      &nbsp;
                      (대출금에 포함되어 있으나 원금 별도 상환인 경우)
                      </td>                    
                </tr>
                <tr> 
                    <td class='title'>채권확보유형</td>
                    <td colspan='7'>&nbsp; 
                      <select name='bond_get_st'>
                        <option value=""  <%if(debt.getBond_get_st().equals("")){%> selected<%}%>>선택</option>
                        <option value="1" <%if(debt.getBond_get_st().equals("1")){%>selected<%}%>>계약서 
                        </option>
                        <option value="2" <%if(debt.getBond_get_st().equals("2")){%>selected<%}%>>계약서+인감증명서</option>
                        <option value="3" <%if(debt.getBond_get_st().equals("3")){%>selected<%}%>>계약서+인감증명서+공증서</option>
                        <option value="4" <%if(debt.getBond_get_st().equals("4")){%>selected<%}%>>계약서+인감증명서+공증서+LOAN 
                        연대보증서계약자</option>
                        <option value="5" <%if(debt.getBond_get_st().equals("5")){%>selected<%}%>>계약서+인감증명서+공증서+LOAN 
                        연대보증서보증인</option>
                        <option value="6" <%if(debt.getBond_get_st().equals("6")){%>selected<%}%>>계약서+연대보증인</option>
                      </select>
                      추가서류:&nbsp; 
                      <input type="text" name="bond_get_st_sub" value='<%=debt.getBond_get_st_sub()%>' maxlength='40' size="40" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>기타</td>
                    <td colspan='7'>&nbsp; 
                      <input type="text" name="note" value='<%=debt.getNote()%>' maxlength='100' size="100" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>중도상환<br>수수료율</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cls_rtn_fee_int" maxlength='5' value="<%=debt.getCls_rtn_fee_int()%>" size="5" class=text >
                      %</td>
                    <td class=title wwidth=10%>중도상환<br>특이사항</td>
                    <td colspan='5'>&nbsp; 
                      <textarea name="cls_rtn_etc" cols="90" rows="2"><%=debt.getCls_rtn_etc()%></textarea></td>                    
                </tr>	
                <tr> 
                    <td class='title'>금융약정계약서</td>
                    <td colspan='7'>&nbsp;
                    <%if(modify_yn.equals("N")){}else{%> 
				  		<%if(debt.getFile_name().equals("")){%>
				    		<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
				  		<%}else{%>
					    	<%=debt.getFile_name()%><%= debt.getFile_type() %>
							&nbsp;<a href="javascript:ScanOpen('<%= debt.getFile_name() %>', '<%= debt.getFile_type() %>')"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>						
							&nbsp;<a href="javascript:scan_del()"><img src=/acar/images/center/button_in_delete.gif border=0 align=absmiddle></a>
							&nbsp;<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
					  	<%}%>
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
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>중도상환</span></td>
        <td align="right">
        <%if(modify_yn.equals("N")){}else{%> 
		    <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	        <a href="javascript:view_cls();"><img src=../images/center/button_hj.gif align=absmiddle border=0></a>
		    <%	}%>
		<%}%>    		 		
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr> 
                    <td class='title'>중도일시상환일</td>
                    <td> &nbsp; 
                      <input type='text' name='cls_rtn_dt' value='<%=cls.getCls_rtn_dt()%>' size='11' maxlength='11' class='whitetext' onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td class='title'>중도상환액</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_amt' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_amt())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                    <td class='title'>중도상환수수료</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_fee' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_fee())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                    <td class='title'>기간이자</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_int_amt' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_int_amt())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title' style='height:38'>기타수수료</td>
                    <td colspan='7'>&nbsp; 
                      <input type="text" name="cls_etc_fee" value="<%=cls.getCls_etc_fee()%>" maxlength='10' size="12" class='whitenum'>
                      원&nbsp;(저당말소대행비 등)
                    </td>
                </tr>
                <tr> 
                    <td class='title' style='height:38'>중도일시<br>
                      상환사유</td>
                    <td colspan='7'>&nbsp; 
                      <input type="text" name="cls_rtn_cau" value="<%=cls.getCls_rtn_cau()%>" maxlength='100' size="100" class='whitetext'>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>근저당설정관리</span>
	    <input type='hidden' name='cltr_id' value='<%=cltr.getCltr_id()%>'> 
        &nbsp;&nbsp;<input type="checkbox" name="cltr_st" value="Y" <%if(cltr.getCltr_st().equals("Y")){%>checked<%}%>>
        <span class=style7>근저당설정</span></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>설정약정액</td>
                    <td width=15%>&nbsp; <input type='text' name='cltr_amt' value='<%=Util.parseDecimal(cltr.getCltr_amt())%>' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원</td>
                    <td width=10% class='title' style='height:36'>설정서류<br>
                      작성일자</td>
                    <td width=15%>&nbsp; <input type='text' name='cltr_docs_dt' value='<%=cltr.getCltr_docs_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td width=10% class='title'>설정일자</td>
                    <td width=15%>&nbsp; <input type='text' name='cltr_set_dt' value='<%=cltr.getCltr_set_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_cltr(this)'> 
                    </td>
                    <td width=10% class='title'>설정가액</td>
                    <td width=15%>&nbsp; <input type='text' name='cltr_f_amt' value='<%=Util.parseDecimal(cltr.getCltr_f_amt())%>' size='11' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 </td>
                </tr>
                <tr> 
                    <td class='title'>저당권순위</td>
                    <td>&nbsp; <select name='mort_lank'>
                        <option value="1" <%if(cltr.getMort_lank().equals("1")){%>selected<%}%>>1</option>
                        <option value="2" <%if(cltr.getMort_lank().equals("2")){%>selected<%}%>>2</option>
                        <option value="3" <%if(cltr.getMort_lank().equals("3")){%>selected<%}%>>3</option>
                      </select>
                      위</td>
                    <td class='title'>설정율</td>
                    <td>&nbsp; <input type='text' name='cltr_per_loan' value='<%=cltr.getCltr_per_loan()%>' maxlength='6' size='6' class='num' onBlur='javascript:set_cltr(this)'>
                      %</td>
                    <td class='title'>근저당권자</td>
                    <td>&nbsp; 
                      <input type='text' name='cltr_user' value='<%=cltr.getCltr_user()%>' size='12' maxlength='15' class='text'> 
                    </td>
                    <td class='title'>을부번호</td>
                    <td>&nbsp; <input name='cltr_num' type='text' class='text' id="cltr_num" value='<%=cltr.getCltr_num()%>' size='14' maxlength='20'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>등록관청</td>
                    <td>&nbsp; <input type='text' name='cltr_office' value='<%=cltr.getCltr_office()%>' size='12' maxlength='15' class='text'> 
                    </td>
                    <td class='title'>담당자</td>
                    <td>&nbsp; <input type='text' name='cltr_offi_man' value='<%=cltr.getCltr_offi_man()%>' size='12' maxlength='15' class='text'> 
                    </td>
                    <td class='title'>전화번호</td>
                    <td>&nbsp; <input type='text' name='cltr_offi_tel' value='<%=cltr.getCltr_offi_tel()%>' size='12' maxlength='15' class='text'> 
                    </td>
                    <td class='title'>팩스번호</td>
                    <td>&nbsp; <input type='text' name='cltr_offi_fax' value='<%=cltr.getCltr_offi_fax()%>' size='12' maxlength='15' class='text'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>설정등록세</td>
                    <td>&nbsp; <input type='text' name='reg_tax'  value='<%=Util.parseDecimal(cltr.getReg_tax())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cltr(this);'>
                      원&nbsp;</td>
                    <td class='title'>설정인지대</td>
                    <td>&nbsp; <input type='text' name='set_stp_fee' value='<%=Util.parseDecimal(cltr.getSet_stp_fee())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cltr(this);'>
                      원&nbsp;</td>
                    <td class='title'>설정비용합계</td>
                    <td colspan='3'>&nbsp; <input type='text' name='ext_tot_amt' value='<%=Util.parseDecimal(cltr.getReg_tax()+cltr.getSet_stp_fee())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>말소등록일</td>
                    <td>&nbsp; <input type='text' name='cltr_exp_dt' value='<%=cltr.getCltr_exp_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td class='title'>말소사유</td>
                    <td colspan="5">&nbsp; <input type='text' name='cltr_exp_cau' value='<%=cltr.getCltr_exp_cau()%>' maxlength='100' size='80' class='text'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>말소등록세</td>
                    <td>&nbsp; <input type='text' name='exp_tax'  value='<%=Util.parseDecimal(cltr.getExp_tax())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_cltr(this);'>
                      원&nbsp;</td>
                    <td class='title'>말소인지대</td>
                    <td>&nbsp; <input type='text' name='exp_stp_fee'  value='<%=Util.parseDecimal(cltr.getExp_stp_fee())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cltr(this);'>
                      원&nbsp;</td>
                    <td class='title'>말소비용합계</td>
                    <td colspan='3'>&nbsp; <input type='text' name='exp_tot_amt'  value='<%=Util.parseDecimal(cltr.getExp_tax()+cltr.getExp_stp_fee())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>할부 자동전표 정보</span>
        &nbsp;&nbsp;<input type="checkbox" name="autodoc_yn" value="Y" <%if(debt.getAutodoc_yn().equals("Y")){%>checked<%}%>>
        <span class=style7>자동전표</span></td>
    </tr>
	<%	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();	
		
		//거래처정보
		CodeBean[] vens = neoe_db.getCodeAll(c_db.getNameById(debt.getCpt_cd(),"BANK"));
		int ven_size = vens.length;
		
		Hashtable ven = new Hashtable();
		if(!debt.getVen_code().equals("")){
			ven = neoe_db.getVendorCase(debt.getVen_code());
		}
		
		//네오엠 은행리스트
		CodeBean[] a_banks = neoe_db.getCodeAll();
		int a_bank_size = a_banks.length;
	%>
<input type='hidden' name='bank_code2' value=''>
<input type='hidden' name='deposit_no2' value=''>
<input type='hidden' name='bank_name' value=''>
<!--
<input type='hidden' name='ven_code2' value=''>
<input type='hidden' name='firm_nm' value=''>-->
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>거래처</td>
                    <td width=40%>&nbsp; 
                      <input type='text' name='ven_name' size='30' value='<%=ven.get("VEN_NAME")==null?"":ven.get("VEN_NAME")%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href='javascript:ven_search()' onMouseOver="window.status=''; return true"><img src=../images/center/button_search.gif align=absmiddle border=0></a> 
        			  <input type='hidden' name='ven_code' size='10' value='<%=debt.getVen_code()%>' class='text'>
                    </td>
                    <td class=title width=10%>계정과목</td>
                    <td width=40%>&nbsp; 
                      <input type="radio" name="acct_code" value="26000" <%if(debt.getAcct_code().equals("26000"))%>checked<%%>>
                      단기차입금 
                      <input type="radio" name="acct_code" value="29300" <%if(debt.getAcct_code().equals("26400")||debt.getAcct_code().equals("29300"))%>checked<%%>>
                      장기차입금
                       <input type="radio" name="acct_code" value="45450" <%if(debt.getAcct_code().equals("45450"))%>checked<%%>>
                      리스료 
                      </td>
                </tr>
                <tr> 
                    <td class=title>은행</td>
                    <td>&nbsp; 
                      <select name='bank_code' onChange='javascript:change_bank()'>
                        <option value=''>선택</option>
                        <%if(a_bank_size > 0){
        						for(int i = 0 ; i < a_bank_size ; i++){
        							CodeBean a_bank = a_banks[i];	%>
                        <option value='<%= a_bank.getCode()%><%//= a_bank.getNm()%>' <%if(debt.getBank_code().equals(a_bank.getCode()))%>selected<%%>> <%= a_bank.getNm()%> 
                        </option>
                        <%	}
        					}	%>
                      </select>
                    </td>
                    <td class=title>계좌번호</td>
                    <td>&nbsp; 
                      <select name='deposit_no'>
                        <option value=''>계좌를 선택하세요</option>
        				<%if(!debt.getBank_code().equals("")){
        						Vector deposits = neoe_db.getDepositList(debt.getBank_code());
        						int deposit_size = deposits.size();
        						for(int i = 0 ; i < deposit_size ; i++){
        							Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
        				<option value='<%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%>' <%if(debt.getDeposit_no().equals(String.valueOf(deposit.get("DEPOSIT_NO"))))%>selected<%%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
        				<%		}
        				}%>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(modify_yn.equals("N")){}else{%>	
		<%if(debt.getRtn_seq().equals("")){%>	
	    <tr> 
	        <td align="right" colspan=2><a href="javascript:go_to_scd()"><img src=../images/center/button_see_sch.gif align=absmiddle border=0></a></td>
	    </tr>		
		<%}%>
	<%}%>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

