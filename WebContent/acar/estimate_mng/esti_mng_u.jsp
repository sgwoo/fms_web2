<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String white = "";
	String disabled = "";
	if(cmd.equals("")){
		white = "white";
		disabled = "disabled";
	}
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
		
	EstiDatabase e_db = EstiDatabase.getInstance();
	e_bean = e_db.getEstimateCase(est_id);
	
	String a_a = e_bean.getA_a().substring(0,1);
	String rent_way = e_bean.getA_a().substring(1);
	String a_b = e_bean.getA_b();
	float o_13 = 0;
	
	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean2 = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String a_e = cm_bean2.getS_st();
	
	//공통변수
	em_bean = e_db.getEstiCommVarCase(a_a, "");
	
	//최대잔가
	o_13 = e_db.getJanga(e_bean.getCar_id(), e_bean.getCar_seq(), a_b, e_bean.getLpg_yn());			
	
	
	//자동차회사 리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	//차종리스트
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll_Esti(e_bean.getCar_comp_id());
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* 코드 구분:대여상품명 */
	int good_size = goods.length;

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//목록보기
	function go_list(){
		var fm = document.form1;
		fm.action = 'esti_mng_frame.jsp';		
		fm.target = 'd_content';					
		fm.submit();
	}

	//자동차회사 선택시 차종코드 출력하기
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '8';
		fm2.target="i_no";
		fm2.submit();
	}

	//제조사D/C 입력후 차가계산하기
	function set_amt(){
		var fm = document.form1;	
		fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));		
	}
	
	//세부리스트
	function sub_list(idx){
		var fm = document.form1;
		var SUBWIN="./esti_sub_list.jsp?idx="+idx+"&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text;	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");
	}
	
	//LPG키트 디스플레이
	function lpg_display(){
		var fm = document.form1;
		var s_st = toInt(fm.s_st.value);
		if(s_st > 101 && s_st < 107){ //소형승용~대형승용3까지 장착가능 차종
			tr_lpg.style.display	= '';
		}else{
//			tr_lpg.style.display	= 'none';
			tr_lpg.style.display	= '';			
		}
	}	
	
	//초기납입금 디스플레이
	function opt_display(){
		var fm = document.form1;
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		if(a_a.substring(1) == '2'){ //기본식
			fm.pp_st.checked = false;
//			tr_ifee.style.display	= 'none';
			tr_ifee.style.display	= '';
			fm.opt_chk[1].checked = true;
			fm.g_10.value = '0';
		}else if(a_a.substring(1) == '1'){ //일반식
			fm.pp_st.checked = true; 			
			tr_ifee.style.display	= '';			
			fm.opt_chk[0].checked = true;
			fm.g_10.value = '3';		
		}
		change_c();
		o13_display();			
	}

	//한도와 비교, 비율==금액 변환
	function compare(obj){
		var fm = document.form1;
//		if(fm.o_1.value == '' || fm.o_1.value == '0'){ alert('차량정보를 입력하십시오.'); return; }
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		if(obj == fm.rg_8){
//			if(fm.rg_8.value != '' && toInt(fm.rg_8.value) < toInt(fm.g_8.value)){ alert('기본보증금율 이상에서 선택하셔야 합니다.'); fm.rg_8.focus(); return; }
			fm.rg_8_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.rg_8.value)/100);	
		}else if(obj == fm.rg_8_amt){
			var rg_8 = toInt(parseDigit(fm.rg_8_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
//			if(fm.rg_8_amt.value != '' && rg_8 < toInt(fm.g_8.value)){ alert('기본보증금율 이상에서 선택하셔야 합니다.'); fm.rg_8_amt.focus(); return; }					
			fm.rg_8.value = Math.round(rg_8);	
		}else if(obj == fm.pp_per){
			fm.pp_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.pp_per.value)/100);						
		}else if(obj == fm.pp_amt){
			fm.pp_per.value = Math.round(toInt(parseDigit(fm.pp_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}else if(obj == fm.ro_13){
//			if(fm.ro_13.value != '' && toInt(fm.ro_13.value) > toInt(fm.o_13.value)){ alert('최대잔가율내에서 선택하셔야 합니다.'); fm.ro_13.focus(); return; }
			fm.ro_13_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.ro_13.value)/100);		
		}else if(obj == fm.ro_13_amt){
			var ro_13 = toInt(parseDigit(fm.ro_13_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
//			if(fm.ro_13_amt.value != '' && ro_13 > toInt(fm.o_13.value)){ alert('최대잔가율내에서 선택하셔야 합니다.'); fm.ro_13_amt.focus(); return; }
			fm.ro_13.value = Math.round(ro_13);		
		}	
		fm.a_a.focus();				
	}
	
	//대여방식 선택시 대여기간 디스플레이
	function change_c(){
		var fm = document.form1;
		drop_c();
		fm.a_b.options[0] = new Option('48개월', '48');		
		fm.a_b.options[1] = new Option('42개월', '42');
		fm.a_b.options[2] = new Option('36개월', '36');
		fm.a_b.options[3] = new Option('30개월', '30');			
		fm.a_b.options[4] = new Option('24개월', '24');
		fm.a_b.options[5] = new Option('18개월', '18');
		fm.a_b.options[6] = new Option('12개월', '12');
	}		
	function drop_c(){
		var fm = document.form1;
		var len = fm.a_b.length;
		for(var i = 0 ; i < len ; i++){
			fm.a_b.options[len-(i+1)] = null;
		}
	}		
		
	//변수
	function GetVar(){
		var fm = document.form1;
		if(fm.code.value == ''){ alert('차명을 선택하십시오'); return; }
		if(fm.car_id.value == ''){ alert('차종을 선택하십시오'); return; }		
		fm.action = 'get_var_null.jsp';
		fm.target = 'i_no';
		fm.submit();
	}		
	
	function Update(){
		var fm = document.form1;
		if(fm.cmd.value == 'u'){
			var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
			if(a_a.substring(1) == '2' && fm.rg_8.value == ''){ //기본식
				alert('적용보증금율을 입력하십시오'); fm.rg_8.focus(); return;
			}
			if(fm.ro_13.value == ''){ alert('적용잔가율을 입력하십시오'); fm.ro_13.focus(); return; }
			if(!confirm('수정하시겠습니까?')){	return; }			
			fm.action = 'esti_mng_u_a.jsp';		
			fm.target = 'd_content';	
//			fm.target = "i_no";							
			fm.submit();
		}else{
			fm.cmd.value = 'u';
			fm.action = 'esti_mng_u.jsp';		
			fm.target = 'd_content';					
			fm.submit();
		}		
	}
	
	//견적내기
	function EstiReg(){
		var fm = document.form1;
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		if(a_a.substring(1) == '2' && fm.rg_8.value == ''){ //기본식
//			alert('적용보증금율을 입력하십시오'); fm.rg_8.focus(); return;
		}
		if(fm.ro_13.value == ''){ alert('적용잔가율을 입력하십시오'); fm.ro_13.focus(); return; }
		if(!confirm('견적하시겠습니까?')){	return; }
		fm.cmd.value = "i";
		fm.action = 'esti_mng_i_a_1.jsp';
		fm.target = "i_no";
		fm.submit();
	}
	
	//메일수신하기
	function open_mail(){
		<%if(e_bean.getEst_from().equals("secondhand")){%>
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&mail_st=&content_st=sh_fms";	
		<%}else{%>
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&mail_st=&content_st=hp_fms";	
		<%}%>	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=200, scrollbars=no, status=yes");
	}	
	//견적서보기
	function EstiView(){
		<%if(e_bean.getEst_from().equals("secondhand")){%>
		var SUBWIN="/acar/secondhand_hp/estimate_fms.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		<%}else{%>
		var SUBWIN="/acar/main_car_hp/estimate_fms.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";							
		<%}%>
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");				
	}
	
	function set_car_ext(){
			
		var fm = document.form1;
		
		//실등록지역		
		var udt_st = fm.f_udt_st.value;
		var br_id = '<%=br_id%>';
		
		var a_h = 1;
		var a_e = <%=a_e%>;
		var a_a = <%=a_a.substring(0,1)%>;
		var au28 = 0;
		var av28 = 0;
		
		if(a_e == 402 || a_e == 501 || a_e == 502 || a_e == 601 || a_e == 602) au28 = 1;	//7~9인승,2000cc초과 집여부
		if(a_e == 104 || a_e == 105 || a_e == 106 || a_e == 107 || a_e == 201) av28 = 1;	//대형승용여부
		
		if(a_a==1){//리스	
			a_h = 4;	
			/*	
			if(av28==1){
				a_h = 4;	
			}else{
				if(au28==1){
					if(udt_st == '1') 		a_h = 1; //본사인수일때 서울
					else if(udt_st == '2') 	a_h = 4; //부산인수일대 경남
					else if(udt_st == '3') 	a_h = 4; //대전인수일때 경남
					else if(udt_st == '4') 	a_h = 1; //고객인수일대 서울
				}else{
					if(udt_st == '1') 		a_h = 2; //본사인수일때 경기
					else if(udt_st == '2') 	a_h = 4; //부산인수일대 경남
					else if(udt_st == '3') 	a_h = 4; //대전인수일때 경남
					else if(udt_st == '4') 	a_h = 1; //고객인수일대 서울
				}
			}	
			*/		
		}else{//렌트
			if(udt_st == '1') 				a_h = 2; //본사인수일때 경기
			else if(udt_st == '2') 			a_h = 4; //부산인수일대 경남
			else if(udt_st == '3') 			a_h = 4; //대전인수일때 경남
			else if(udt_st == '4') 			a_h = 2; //고객인수일대 경기
		}

		fm.a_h.value 	= a_h;
		fm.udt_st.value = udt_st;
	}	
	
	//최대잔가율 조회
	function searchO13(){
		var fm = document.form1;
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		var ins_age = fm.ins_age.options[fm.ins_age.selectedIndex].value;
		if(fm.code.value == ''){ 	alert('차명을 선택하십시오'); return; }
		if(fm.car_id.value == ''){ 	alert('차종을 선택하십시오'); return; }
		if(fm.car_amt.value == ''){ alert('차종금액을 확인하십시오'); return; }				
		if(fm.a_a.value == ''){ 	alert('대여상품을 선택하십시오'); return; }
		if(fm.a_b.value == ''){ 	alert('대여기간을 선택하십시오'); return; }
//		fm.action = 'get_o13.jsp';
//		fm.action = '/acar/estimate_mng/get_o13_20080808.jsp';		
		fm.action = '/acar/estimate_mng/get_o13_20090901.jsp';		
		fm.target = 'i_no';
		fm.submit();
	}		
	
	function Move_a_type(){
		var fm = document.form1;
		fm.action = 'esti_mng_atype_u.jsp';		
		fm.target = 'd_content';					
		fm.submit();
	}		
	
	function ReEsti(){
		var fm = document.form1;
		fm.action = 'esti_mng_atype_i.jsp';		
		fm.target = 'd_content';					
		fm.submit();
	}			
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="../car_mst/car_mst_null.jsp" name="form2" method="post">
    <input type="hidden" name="sel" value="">
    <input type="hidden" name="car_comp_id" value="">
    <input type="hidden" name="code" value="">
    <input type="hidden" name="mode" value="">
  </form>
  <form action="./esti_mng_u_a.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
  <input type="hidden" name="gubun5" value="<%=gubun5%>">
  <input type="hidden" name="gubun6" value="<%=gubun6%>">  
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="esti_m" value="<%=esti_m%>">
    <input type="hidden" name="esti_m_dt" value="<%=esti_m_dt%>">
    <input type="hidden" name="esti_m_s_dt" value="<%=esti_m_s_dt%>">
    <input type="hidden" name="esti_m_e_dt" value="<%=esti_m_e_dt%>">
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="cmd" value="<%=cmd%>">
    <input type="hidden" name="s_st" value="">
    <input type="hidden" name="a_e" value="">
	<input type="hidden" name="udt_st" value="<%=e_bean.getUdt_st()%>">
	<input type="hidden" name="set_code" value="<%=e_bean.getSet_code()%>">	
	<input type="hidden" name="from_page" value="<%=from_page%>">					
	<input type="hidden" name="from_page2" value="<%=from_page2%>">						
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 견적관리 > <span class=style5>견적내기(<%=est_id%>)</span></span> : 견적내기(<%=est_id%>)</td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right">
        <a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
	        <%if(e_bean.getEst_ssn().length() < 13){%>	  
                <tr> 
                    <td class=title width=10%>상호</td>
                    <td width=17%>&nbsp;<input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="22" class=<%=white%>text style='IME-MODE: active'> 
                    </td>
                    <td class=title width=10%>사업자번호</td>
                    <td align=left width=13%>&nbsp;<input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=<%=white%>text> 
                    </td>
                    <td class=title width=10%>대표자</td>
                    <td width=15%>&nbsp;<input type="text" name="mgr_nm" value="<%=e_bean.getMgr_nm()%>" size="12" class=<%=white%>text> 
                    </td>
                    <td class=title width=10%>생년월일</td>
                    <td width=15%>&nbsp;<input type="text" name="mgr_ssn" value="<%=e_bean.getMgr_ssn()%>" size="15" maxlength='8' class=<%=white%>text> 
                    </td>
                </tr>			
	  <%}else{%>
                <tr> 
                    <td class=title width=10%>성명</td>
                    <td width=15%>&nbsp;<input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="22" class=<%=white%>text style='IME-MODE: active'> 
                    </td>
                    <td class=title width=10%>생년월일</td>
                    <td align=left width=15%>&nbsp;<input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" maxlength='8' class=<%=white%>text> 
                    </td>
                    <td class=title width=10%>직업</td>
                    <td colspan="3">&nbsp;<input type="text" name="job" value="<%=e_bean.getJob()%>" size="30" class=<%=white%>text> </td>
                </tr>				  
	  <%}%>	 
                <tr>
                    <td class=title>전화번호</td>
                    <td>&nbsp;<input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title>FAX</td>
                    <td align=left>&nbsp;<input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=<%=white%>text>
                    </td> 
                    <td class=title>상담연락처</td>
                    <td colspan="3">&nbsp;<input type="text" name="talk_tel" value="<%=e_bean.getTalk_tel()%>" size="15" class=<%=white%>text>
                    </td>
                </tr>			
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>상품선택</span></td>
        <td><div align="right"><% if(e_bean.getSpr_yn().equals("1")) 		out.print("<font color=red>※우량기업</font>");
	  							else if(e_bean.getSpr_yn().equals("2"))	out.print("<font color=red>※초우량기업</font>"); %></div></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr>
                    <td class=title width=10%>신용도 구분</td>
                    <td>&nbsp;<input type="radio" name="spr_yn" value="3" <% if(e_bean.getSpr_yn().equals("3")) out.print("checked"); %>>
                      신설법인
        			  <input type="radio" name="spr_yn" value="0" <% if(e_bean.getSpr_yn().equals("0")) out.print("checked"); %>>
                      일반기업 
                      <input type="radio" name="spr_yn" value="1" <% if(e_bean.getSpr_yn().equals("1")) out.print("checked"); %>>
                      우량기업 
                      <input type="radio" name="spr_yn" value="2" <% if(e_bean.getSpr_yn().equals("2")) out.print("checked"); %>>
                      초우량기업</td>
                </tr>
                <tr> 
                    <td class=title>대여상품</td>
                    <td>&nbsp;<select name="a_a" onChange="javascript:change_c(); opt_display(); GetVar();" <%=disabled%>>
                        <option value="">=선 택=</option>
                        <%for(int i = 0 ; i < good_size ; i++){
        					CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' <%if(e_bean.getA_a().equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        <%}%>
                      </select> 
                      <!--<input type="text" name="reg_dt" value="<%=AddUtil.getDate()%>" class=text size="12" onBlur='javscript:this.value = ChangeDate(this.value);'>
                      견적일자 -->
                    </td>
                </tr>
                <tr> 
                    <td class=title>대여기간</td>
                    <td>&nbsp;<input type="text" name="a_b" value="<%=e_bean.getA_b()%>" size="2" class=<%=white%>text>개월</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>제조사</td>
                    <td colspan="2">&nbsp;<select name="car_comp_id" onChange="javascript:GetCarCode()" <%=disabled%>>
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(e_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>차명</td>
                    <td colspan="2">&nbsp;<select name="code" <%=disabled%>>
                        <option value="">선택</option>
                        <%for(int i=0; i<cm_r.length; i++){
        						        cm_bean = cm_r[i];%>
                        <option value="<%= cm_bean.getCode() %>" <%if(e_bean.getCar_cd().equals(cm_bean.getCode()))%>selected<%%>>[<%=cm_bean.getCar_cd()%>]<%=cm_bean.getCar_nm()%></option>
                        <%	}	%>
                      </select> 
					  (<%=cm_bean2.getJg_code()%>)
					  </td>
                </tr>
                <tr> 
                    <td class=title width=10%>차종</td>
                    <td width=65%> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a> 
                      <%}%>
                      &nbsp;<input type="text" name="car_name" value="<%=cm_bean2.getCar_name()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="car_id" value="<%=e_bean.getCar_id()%>"> 
                      <input type="hidden" name="car_seq" value="<%=e_bean.getCar_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="car_amt" value="<%=AddUtil.parseDecimal(e_bean.getCar_amt())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>옵션</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="opt" value="<%=e_bean.getOpt()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="opt_seq" value="<%=e_bean.getOpt_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="opt_amt" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>색상</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="col" value="<%=e_bean.getCol()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="col_seq" value="<%=e_bean.getCol_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="col_amt" value="<%=AddUtil.parseDecimal(e_bean.getCol_amt())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>제조사DC</td>
                    <td>&nbsp;<input type="text" name="dc" value="<%=e_bean.getDc()%>" size="83" class=<%=white%>text> 
                      <input type="hidden" name="dc_seq" value="<%=e_bean.getDc_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(e_bean.getDc_amt())%>" size="15" class=<%=white%>num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">차량가격</td>
                    <td align="center"><input type="text" name="o_1" value="<%=AddUtil.parseDecimal(e_bean.getO_1())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
                <tr id=tr_lpg style="display:<%if(AddUtil.parseInt(a_e) > 101 || AddUtil.parseInt(a_e) < 107) {%>''<%}else{%>none<%}%>"> 
                    <td class=title>LPG키트</td>
                    <td colspan="2">&nbsp;<select name="lpg_yn"  <%=disabled%> onChange="javascript:GetVar()">
                        <option value="0" <%if(e_bean.getLpg_yn().equals("0"))%>selected<%%>>미장착</option>
                        <option value="1" <%if(e_bean.getLpg_yn().equals("1"))%>selected<%%>>장착</option>
                      </select> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약조건</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td width=10% colspan="2" class=title>견적일시</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(e_bean.getReg_dt())%> </td>
                </tr>
                <tr> 
                    <td width="10%" rowspan="2" class=title>잔가</td>
                    <td width="8%" class=title>적용잔가율</td>
                    <td colspan="3"> &nbsp;차가의 
                      <input type="text" name="ro_13" value="<%=e_bean.getRo_13()%>" size="4" class=<%=white%>text  onblur="javascript:compare(this)">
                      % <font color="#666666">(최대잔가율 
                      <input type="text" name="o_13" value="<%=o_13*100%>" class=whitenum size="3">
                      % 내에서 선택)</font> , 적용잔가금액 
                      <input type="text" name="ro_13_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);' value="<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>">
                      원 <font color="#666666">(매입옵션 금액임)</font>
					  <a href="javascript:searchO13();"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
					  </td>
                </tr>
                <tr>
                  <td class=title>매입옵션</td>
                  <td colspan="3">&nbsp;
				    <input type='radio' name="opt_chk" value='0' <%if(e_bean.getOpt_chk().equals("0")){%> checked <%}%>>
                      미부여
                      <input type='radio' name="opt_chk" value='1' <%if(e_bean.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		  부여
					</td>
                </tr>				
                <tr> 
                    <td rowspan="3" class=title>선수</td>
                    <td class=title>보증금<br>
                    </td>
                    <td colspan="3">&nbsp;차가의 
                      <input type="text" name="rg_8" value="<%=e_bean.getRg_8()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, 적용보증금액 <font color="#666666"> 
                      <input type="text" name="rg_8_amt" value="<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 (기본보증금율 
                      <input type="text" name="g_8" value="<%=em_bean.getG_8()%>" class=whitenum size="3">
                      % 이상에서 선택) </font> </td>
                </tr>
                <tr> 
                    <td class=title>선납금<br>
                    </td>
                    <td colspan="3">&nbsp;차가의 
                      <input type="text" name="pp_per" value="<%=e_bean.getPp_per()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, 적용선납금액<font color="#666666">&nbsp;</font> <input type="text" name="pp_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 </td>
                </tr>
                <tr id="tr_ifee" style="display:''"> 
                    <td class=title>개시대여료</td>
                    <td colspan="3">&nbsp;<font color="#666666"> 
                    <input type="checkbox" name="pp_st" value="1" <%if(e_bean.getPp_st().equals("1"))%> checked<%%> <%=disabled%>>
                    <input type="text" name="g_10" class=<%=white%>num size="2" value="<%=e_bean.getG_10()%>">
                    개월치 대여료 선납 </font></td>
                </tr>
                 <tr> 
                    <td rowspan="3" class=title>보험</td>
                    <td class=title>대물,자손</td>
                    <td >&nbsp;                      <select name="ins_dj"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_dj().equals("1"))%>selected<%%>>5천만원</option>
                        <option value="2" <%if(e_bean.getIns_dj().equals("2"))%>selected<%%>>1억원</option>
                    </select> </td>
                    <!--
                    <td class=title width=11%>애니카보험</td>
                    <td>&nbsp;<select name="ins_good" <%=disabled%>>
                        <option value="0" <%if(e_bean.getIns_good().equals("0"))%>selected<%%>>미가입</option>
                        <option value="1" <%if(e_bean.getIns_good().equals("1"))%>selected<%%>>가입</option>
                      </select> </td>
                      -->
                    <td class=title width='11%'>보험계약자</td>
                    <td> 
                      &nbsp;<select name="insurant"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getInsurant().equals("1"))%>selected<%%>>아마존카</option>
                            <!--<option value="2" <%if(e_bean.getInsurant().equals("2"))%>selected<%%>>고객</option>-->
                          </select>
                    </td>	                      
                </tr>
                <tr>
                  <td class=title>운전자연령</td> 
                    <td >&nbsp;                      <select name="ins_age"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_age().equals("1"))%>selected<%%>>만26세이상</option>
						<option value="3" <%if(e_bean.getIns_age().equals("3"))%>selected<%%>>만24세이상</option>
                        <option value="2" <%if(e_bean.getIns_age().equals("2"))%>selected<%%>>만21세이상</option>
                    </select> </td>
                    <td class=title width='11%'>피보험자</td>
                    <td> 
                      &nbsp;<select name="ins_per"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getIns_per().equals("1"))%>selected<%%>>아마존카(보험포함)</option>
                            <option value="2" <%if(e_bean.getIns_per().equals("2"))%>selected<%%>>고객(보험미포함)</option>
                          </select>
                    </td>	
                </tr>
                <tr> 
                    <td class=title>보증보험</td>
                    <td>&nbsp;<select name="gi_yn"  <%=disabled%>>
                        <option value="0" <%if(e_bean.getGi_yn().equals("0"))%>selected<%%>>면제</option>
                        <option value="1" <%if(e_bean.getGi_yn().equals("1"))%>selected<%%>>가입</option>
                      </select> </td>
                    <td class=title>자차면책금</td>
                    <td>&nbsp;<input type="text" name="car_ja" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>					  
                </tr>
               <tr> 
                    <td rowspan="3" class=title>기타<br> </td>
                    <td class=title>등록지역</td>
                    <td>&nbsp;<select name="a_h"  <%=disabled%>>
                        <option value="">=선 택=</option>
                        <option value="1" <%if(e_bean.getA_h().equals("1"))%>selected<%%>>서울</option>
                        <option value="2" <%if(e_bean.getA_h().equals("2"))%>selected<%%>>경기</option>
                        <option value="3" <%if(e_bean.getA_h().equals("3"))%>selected<%%>>부산</option>
                        <option value="4" <%if(e_bean.getA_h().equals("4"))%>selected<%%>>경남</option>
                        <option value="5" <%if(e_bean.getA_h().equals("5"))%>selected<%%>>대전</option>				
                      </select> </td>
                    <td class=title>차량인수지</td>
                    <td>&nbsp;<select name="f_udt_st"  <%=disabled%> onchange="javascript:set_car_ext()">
                        <option value="">=선 택=</option>
                        <option value="1" <%if(e_bean.getUdt_st().equals("1"))%>selected<%%>>서울본사</option>
                        <option value="2" <%if(e_bean.getUdt_st().equals("2"))%>selected<%%>>부산지점</option>
                        <option value="3" <%if(e_bean.getUdt_st().equals("3"))%>selected<%%>>대전지점</option>
                        <option value="4" <%if(e_bean.getUdt_st().equals("4"))%>selected<%%>>고객</option>
                      </select> </td>					  
                </tr>
                <tr> 
                    <td class=title>대여료D/C</td>
                    <td>&nbsp;대여료의 
                      <input type="text" name="fee_dc_per" value="<%=e_bean.getFee_dc_per()%>" size="4" class=<%=white%>text>
                      %</td>
					<td class=title>영업수당</td>
                    <td>&nbsp;차가의 
                      <input type="text" name="o_11" value="<%=e_bean.getO_11()%>" size="4" class=<%=white%>text>
                      %</td>  
                </tr>
                <tr> 
                    <td class=title>견적유효기간</td>
                    <td>&nbsp;<select name="vali_type"  <%=disabled%>>
                        <option value="" <%if(e_bean.getVali_type().equals(""))%>selected<%%>>선택</option>					
                        <option value="0" <%if(e_bean.getVali_type().equals("0"))%>selected<%%>>날짜만표기(10일)</option>
                        <option value="1" <%if(e_bean.getVali_type().equals("1"))%>selected<%%>>메이커D/C 변경 가능성 언급</option>
                        <option value="2" <%if(e_bean.getVali_type().equals("2"))%>selected<%%>>미확정견적</option>						
                      </select></td>
                    <td class=title>필요서류표기</td>
                    <td>&nbsp;<select name="doc_type"  <%=disabled%>>
					    <option value="" <%if(e_bean.getDoc_type().equals(""))%>selected<%%>>선택</option>					
                        <option value="1" <%if(e_bean.getDoc_type().equals("1"))%>selected<%%>>법인고객</option>
                        <option value="2" <%if(e_bean.getDoc_type().equals("2"))%>selected<%%>>개인사업자</option>
						<option value="3" <%if(e_bean.getDoc_type().equals("3"))%>selected<%%>>개인</option>
                      </select></td>					  
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적결과</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=7% rowspan="2">&nbsp;</td>
                    <td class=title rowspan="2" width=13%>월대여요금</td>
                    <td class=title colspan="4">초기선납금</td>
                </tr>
                <tr> 
                    <td class=title width=13%>보증금</td>
                    <td class=title width=13%>선납금</td>
                    <td class=title width=14%>개시대여료</td>
                    <td class=title >계</td>
                </tr>
                <tr> 
                    <td class=title>공급가</td>
                    <td align="center"> <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="gtr_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="pp_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="ifee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class=title>부가세<br> </td>
                    <td align="center"> <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> -</td>
                    <td align="center"> <input type="text" name="pp_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="ifee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class=title>계</td>
                    <td align="center"> <input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="t_gtr_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="t_pp_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="t_ifee_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <font color="#666666"> 
                      <input type="text" name="tot_p_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </font></td>
                </tr>
                <tr> 
                    <td class=title colspan="2">월대여료 잔여 납입회수</td>
                    <td colspan="4">
                      &nbsp;<font color="#666666"><input type="text" name="tm" value="<%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>" class=<%=white%>num size="2">
                      </font>회</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">보증보험가입금액 </td>
                    <td>&nbsp;<input type="text" name="gi_amt" value="<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td class=title>보증보험료</td>
                    <td colspan="2">&nbsp;<input type="text" name="gi_fee" value="<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                </tr>
                <tr> 
                    <td class=title colspan="2">중도해지위약금</td>
                    <td colspan="4">&nbsp;잔여기간 대여료총액의 
                      <input type="text" name="cls_per" value="<%=e_bean.getCls_per()%>" size="4" class=<%=white%>text>
                      %</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr> 
        <td align=right colspan="2">&nbsp; </td>
    </tr>
    <%if(!from_page.equals("esti_mng_atype_u.jsp")){%>
    <tr>
        <td colspan="2">&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> <font color=red>[견적다시하기]를 하려면 조건 변경후 적용잔가를 다시 계산하여야 합니다.</font></td>
    </tr>	
    <tr> 
        <td align=center colspan="2"> 
        <%if(!cmd.equals("")){%>
        <a href="javascript:EstiReg();"><img src=/acar/images/center/button_again_gj.gif align=absmiddle border=0></a>
        <%}%>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:open_mail()"><img src=/acar/images/center/button_send_mail.gif align=absmiddle border=0></a> 
             
			 &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:EstiView()"><img src=/acar/images/center/button_est_see.gif align=absmiddle border=0></a> 
	         
			 &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:ReEsti()"><img src=/acar/images/center/button_est_rdj.gif align=absmiddle border=0></a>			 
        </td>
    </tr>
    <%}else{%>
    <tr>
        <td colspan="2">&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> <font color=red>[견적다시하기]를 하려면 조건 변경후 적용잔가를 다시 계산하여야 합니다.</font></td>
    </tr>	
    <tr> 
        <td align=center colspan="2">         
          <a href='javascript:Update();'><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;&nbsp 
          <a href="javascript:EstiReg();"><img src=/acar/images/center/button_again_gj.gif align=absmiddle border=0></a>        
        </td>
    </tr>    
     
    <%}%>
	<!--
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 인쇄 버튼 클릭시 &quot;MeadCo's ScriptX를 설치하고 실행하시겠습니까?&quot;라고 물으면 [예]/[설치]&quot; 하십시오</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 한줄씩 인쇄 되는 경우가 발생하면 페이지설정 여백이 &quot;인치&quot;로 되어 있을 때입니다. </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;제어판-국가별옵션-사용자지정-숫자-단위를 &quot;인치&quot;에서 &quot;미터&quot;로 수정하십시오. </td>
    </tr>
	-->
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>