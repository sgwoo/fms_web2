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
	
	//CAR_NM : ????????
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean2 = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String a_e = cm_bean2.getS_st();
	
	//????????
	em_bean = e_db.getEstiCommVarCase(a_a, "");
	
	//????????
	o_13 = e_db.getJanga(e_bean.getCar_id(), e_bean.getCar_seq(), a_b, e_bean.getLpg_yn());			
	
	
	//?????????? ??????
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	//??????????
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll_Esti(e_bean.getCar_comp_id());
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* ???? ????:?????????? */
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
	//????????
	function go_list(){
		var fm = document.form1;
		fm.action = 'esti_mng_frame.jsp';		
		fm.target = 'd_content';					
		fm.submit();
	}

	//?????????? ?????? ???????? ????????
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '??????';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '8';
		fm2.target="i_no";
		fm2.submit();
	}

	//??????D/C ?????? ????????????
	function set_amt(){
		var fm = document.form1;	
		fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));		
	}
	
	//??????????
	function sub_list(idx){
		var fm = document.form1;
		var SUBWIN="./esti_sub_list.jsp?idx="+idx+"&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text;	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");
	}
	
	//LPG???? ??????????
	function lpg_display(){
		var fm = document.form1;
		var s_st = toInt(fm.s_st.value);
		if(s_st > 101 && s_st < 107){ //????????~????????3???? ???????? ????
			tr_lpg.style.display	= '';
		}else{
//			tr_lpg.style.display	= 'none';
			tr_lpg.style.display	= '';			
		}
	}	
	
	//?????????? ??????????
	function opt_display(){
		var fm = document.form1;
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		if(a_a.substring(1) == '2'){ //??????
			fm.pp_st.checked = false;
//			tr_ifee.style.display	= 'none';
			tr_ifee.style.display	= '';
			fm.opt_chk[1].checked = true;
			fm.g_10.value = '0';
		}else if(a_a.substring(1) == '1'){ //??????
			fm.pp_st.checked = true; 			
			tr_ifee.style.display	= '';			
			fm.opt_chk[0].checked = true;
			fm.g_10.value = '3';		
		}
		change_c();
		o13_display();			
	}

	//?????? ????, ????==???? ????
	function compare(obj){
		var fm = document.form1;
//		if(fm.o_1.value == '' || fm.o_1.value == '0'){ alert('?????????? ????????????.'); return; }
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		if(obj == fm.rg_8){
//			if(fm.rg_8.value != '' && toInt(fm.rg_8.value) < toInt(fm.g_8.value)){ alert('???????????? ???????? ?????????? ??????.'); fm.rg_8.focus(); return; }
			fm.rg_8_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.rg_8.value)/100);	
		}else if(obj == fm.rg_8_amt){
			var rg_8 = toInt(parseDigit(fm.rg_8_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
//			if(fm.rg_8_amt.value != '' && rg_8 < toInt(fm.g_8.value)){ alert('???????????? ???????? ?????????? ??????.'); fm.rg_8_amt.focus(); return; }					
			fm.rg_8.value = Math.round(rg_8);	
		}else if(obj == fm.pp_per){
			fm.pp_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.pp_per.value)/100);						
		}else if(obj == fm.pp_amt){
			fm.pp_per.value = Math.round(toInt(parseDigit(fm.pp_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}else if(obj == fm.ro_13){
//			if(fm.ro_13.value != '' && toInt(fm.ro_13.value) > toInt(fm.o_13.value)){ alert('???????????????? ?????????? ??????.'); fm.ro_13.focus(); return; }
			fm.ro_13_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.ro_13.value)/100);		
		}else if(obj == fm.ro_13_amt){
			var ro_13 = toInt(parseDigit(fm.ro_13_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
//			if(fm.ro_13_amt.value != '' && ro_13 > toInt(fm.o_13.value)){ alert('???????????????? ?????????? ??????.'); fm.ro_13_amt.focus(); return; }
			fm.ro_13.value = Math.round(ro_13);		
		}	
		fm.a_a.focus();				
	}
	
	//???????? ?????? ???????? ??????????
	function change_c(){
		var fm = document.form1;
		drop_c();
		fm.a_b.options[0] = new Option('48????', '48');		
		fm.a_b.options[1] = new Option('42????', '42');
		fm.a_b.options[2] = new Option('36????', '36');
		fm.a_b.options[3] = new Option('30????', '30');			
		fm.a_b.options[4] = new Option('24????', '24');
		fm.a_b.options[5] = new Option('18????', '18');
		fm.a_b.options[6] = new Option('12????', '12');
	}		
	function drop_c(){
		var fm = document.form1;
		var len = fm.a_b.length;
		for(var i = 0 ; i < len ; i++){
			fm.a_b.options[len-(i+1)] = null;
		}
	}		
		
	//????
	function GetVar(){
		var fm = document.form1;
		if(fm.code.value == ''){ alert('?????? ????????????'); return; }
		if(fm.car_id.value == ''){ alert('?????? ????????????'); return; }		
		fm.action = 'get_var_null.jsp';
		fm.target = 'i_no';
		fm.submit();
	}		
	
	function Update(){
		var fm = document.form1;
		if(fm.cmd.value == 'u'){
			var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
			if(a_a.substring(1) == '2' && fm.rg_8.value == ''){ //??????
				alert('?????????????? ????????????'); fm.rg_8.focus(); return;
			}
			if(fm.ro_13.value == ''){ alert('???????????? ????????????'); fm.ro_13.focus(); return; }
			if(!confirm('?????????????????')){	return; }			
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
	
	//????????
	function EstiReg(){
		var fm = document.form1;
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		if(a_a.substring(1) == '2' && fm.rg_8.value == ''){ //??????
//			alert('?????????????? ????????????'); fm.rg_8.focus(); return;
		}
		if(fm.ro_13.value == ''){ alert('???????????? ????????????'); fm.ro_13.focus(); return; }
		if(!confirm('?????????????????')){	return; }
		fm.cmd.value = "i";
		fm.action = 'esti_mng_i_a_1.jsp';
		fm.target = "i_no";
		fm.submit();
	}
	
	//????????????
	function open_mail(){
		<%if(e_bean.getEst_from().equals("secondhand")){%>
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&mail_st=&content_st=sh_fms";	
		<%}else{%>
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&mail_st=&content_st=hp_fms";	
		<%}%>	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=200, scrollbars=no, status=yes");
	}	
	//??????????
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
		
		//??????????		
		var udt_st = fm.f_udt_st.value;
		var br_id = '<%=br_id%>';
		
		var a_h = 1;
		var a_e = <%=a_e%>;
		var a_a = <%=a_a.substring(0,1)%>;
		var au28 = 0;
		var av28 = 0;
		
		if(a_e == 402 || a_e == 501 || a_e == 502 || a_e == 601 || a_e == 602) au28 = 1;	//7~9????,2000cc???? ??????
		if(a_e == 104 || a_e == 105 || a_e == 106 || a_e == 107 || a_e == 201) av28 = 1;	//????????????
		
		if(a_a==1){//????	
			a_h = 4;	
			/*	
			if(av28==1){
				a_h = 4;	
			}else{
				if(au28==1){
					if(udt_st == '1') 		a_h = 1; //???????????? ????
					else if(udt_st == '2') 	a_h = 4; //???????????? ????
					else if(udt_st == '3') 	a_h = 4; //???????????? ????
					else if(udt_st == '4') 	a_h = 1; //???????????? ????
				}else{
					if(udt_st == '1') 		a_h = 2; //???????????? ????
					else if(udt_st == '2') 	a_h = 4; //???????????? ????
					else if(udt_st == '3') 	a_h = 4; //???????????? ????
					else if(udt_st == '4') 	a_h = 1; //???????????? ????
				}
			}	
			*/		
		}else{//????
			if(udt_st == '1') 				a_h = 2; //???????????? ????
			else if(udt_st == '2') 			a_h = 4; //???????????? ????
			else if(udt_st == '3') 			a_h = 4; //???????????? ????
			else if(udt_st == '4') 			a_h = 2; //???????????? ????
		}

		fm.a_h.value 	= a_h;
		fm.udt_st.value = udt_st;
	}	
	
	//?????????? ????
	function searchO13(){
		var fm = document.form1;
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		var ins_age = fm.ins_age.options[fm.ins_age.selectedIndex].value;
		if(fm.code.value == ''){ 	alert('?????? ????????????'); return; }
		if(fm.car_id.value == ''){ 	alert('?????? ????????????'); return; }
		if(fm.car_amt.value == ''){ alert('?????????? ????????????'); return; }				
		if(fm.a_a.value == ''){ 	alert('?????????? ????????????'); return; }
		if(fm.a_b.value == ''){ 	alert('?????????? ????????????'); return; }
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>???????? > ???????? > <span class=style5>????????(<%=est_id%>)</span></span> : ????????(<%=est_id%>)</td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
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
                    <td class=title width=10%>????</td>
                    <td width=17%>&nbsp;<input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="22" class=<%=white%>text style='IME-MODE: active'> 
                    </td>
                    <td class=title width=10%>??????????</td>
                    <td align=left width=13%>&nbsp;<input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=<%=white%>text> 
                    </td>
                    <td class=title width=10%>??????</td>
                    <td width=15%>&nbsp;<input type="text" name="mgr_nm" value="<%=e_bean.getMgr_nm()%>" size="12" class=<%=white%>text> 
                    </td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<input type="text" name="mgr_ssn" value="<%=e_bean.getMgr_ssn()%>" size="15" maxlength='8' class=<%=white%>text> 
                    </td>
                </tr>			
	  <%}else{%>
                <tr> 
                    <td class=title width=10%>????</td>
                    <td width=15%>&nbsp;<input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="22" class=<%=white%>text style='IME-MODE: active'> 
                    </td>
                    <td class=title width=10%>????????</td>
                    <td align=left width=15%>&nbsp;<input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" maxlength='8' class=<%=white%>text> 
                    </td>
                    <td class=title width=10%>????</td>
                    <td colspan="3">&nbsp;<input type="text" name="job" value="<%=e_bean.getJob()%>" size="30" class=<%=white%>text> </td>
                </tr>				  
	  <%}%>	 
                <tr>
                    <td class=title>????????</td>
                    <td>&nbsp;<input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title>FAX</td>
                    <td align=left>&nbsp;<input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=<%=white%>text>
                    </td> 
                    <td class=title>??????????</td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
        <td><div align="right"><% if(e_bean.getSpr_yn().equals("1")) 		out.print("<font color=red>??????????</font>");
	  							else if(e_bean.getSpr_yn().equals("2"))	out.print("<font color=red>????????????</font>"); %></div></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr>
                    <td class=title width=10%>?????? ????</td>
                    <td>&nbsp;<input type="radio" name="spr_yn" value="3" <% if(e_bean.getSpr_yn().equals("3")) out.print("checked"); %>>
                      ????????
        			  <input type="radio" name="spr_yn" value="0" <% if(e_bean.getSpr_yn().equals("0")) out.print("checked"); %>>
                      ???????? 
                      <input type="radio" name="spr_yn" value="1" <% if(e_bean.getSpr_yn().equals("1")) out.print("checked"); %>>
                      ???????? 
                      <input type="radio" name="spr_yn" value="2" <% if(e_bean.getSpr_yn().equals("2")) out.print("checked"); %>>
                      ??????????</td>
                </tr>
                <tr> 
                    <td class=title>????????</td>
                    <td>&nbsp;<select name="a_a" onChange="javascript:change_c(); opt_display(); GetVar();" <%=disabled%>>
                        <option value="">=?? ??=</option>
                        <%for(int i = 0 ; i < good_size ; i++){
        					CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' <%if(e_bean.getA_a().equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        <%}%>
                      </select> 
                      <!--<input type="text" name="reg_dt" value="<%=AddUtil.getDate()%>" class=text size="12" onBlur='javscript:this.value = ChangeDate(this.value);'>
                      ???????? -->
                    </td>
                </tr>
                <tr> 
                    <td class=title>????????</td>
                    <td>&nbsp;<input type="text" name="a_b" value="<%=e_bean.getA_b()%>" size="2" class=<%=white%>text>????</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>??????</td>
                    <td colspan="2">&nbsp;<select name="car_comp_id" onChange="javascript:GetCarCode()" <%=disabled%>>
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(e_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>????</td>
                    <td colspan="2">&nbsp;<select name="code" <%=disabled%>>
                        <option value="">????</option>
                        <%for(int i=0; i<cm_r.length; i++){
        						        cm_bean = cm_r[i];%>
                        <option value="<%= cm_bean.getCode() %>" <%if(e_bean.getCar_cd().equals(cm_bean.getCode()))%>selected<%%>>[<%=cm_bean.getCar_cd()%>]<%=cm_bean.getCar_nm()%></option>
                        <%	}	%>
                      </select> 
					  (<%=cm_bean2.getJg_code()%>)
					  </td>
                </tr>
                <tr> 
                    <td class=title width=10%>????</td>
                    <td width=65%> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a> 
                      <%}%>
                      &nbsp;<input type="text" name="car_name" value="<%=cm_bean2.getCar_name()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="car_id" value="<%=e_bean.getCar_id()%>"> 
                      <input type="hidden" name="car_seq" value="<%=e_bean.getCar_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="car_amt" value="<%=AddUtil.parseDecimal(e_bean.getCar_amt())%>" size="15" class=<%=white%>num>
                      ??</td>
                </tr>
                <tr> 
                    <td class=title>????</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="opt" value="<%=e_bean.getOpt()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="opt_seq" value="<%=e_bean.getOpt_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="opt_amt" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>" size="15" class=<%=white%>num>
                      ??</td>
                </tr>
                <tr> 
                    <td class=title>????</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="col" value="<%=e_bean.getCol()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="col_seq" value="<%=e_bean.getCol_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="col_amt" value="<%=AddUtil.parseDecimal(e_bean.getCol_amt())%>" size="15" class=<%=white%>num>
                      ??</td>
                </tr>
                <tr> 
                    <td class=title>??????DC</td>
                    <td>&nbsp;<input type="text" name="dc" value="<%=e_bean.getDc()%>" size="83" class=<%=white%>text> 
                      <input type="hidden" name="dc_seq" value="<%=e_bean.getDc_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(e_bean.getDc_amt())%>" size="15" class=<%=white%>num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      ??</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">????????</td>
                    <td align="center"><input type="text" name="o_1" value="<%=AddUtil.parseDecimal(e_bean.getO_1())%>" size="15" class=<%=white%>num>
                      ??</td>
                </tr>
                <tr id=tr_lpg style="display:<%if(AddUtil.parseInt(a_e) > 101 || AddUtil.parseInt(a_e) < 107) {%>''<%}else{%>none<%}%>"> 
                    <td class=title>LPG????</td>
                    <td colspan="2">&nbsp;<select name="lpg_yn"  <%=disabled%> onChange="javascript:GetVar()">
                        <option value="0" <%if(e_bean.getLpg_yn().equals("0"))%>selected<%%>>??????</option>
                        <option value="1" <%if(e_bean.getLpg_yn().equals("1"))%>selected<%%>>????</option>
                      </select> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td width=10% colspan="2" class=title>????????</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(e_bean.getReg_dt())%> </td>
                </tr>
                <tr> 
                    <td width="10%" rowspan="2" class=title>????</td>
                    <td width="8%" class=title>??????????</td>
                    <td colspan="3"> &nbsp;?????? 
                      <input type="text" name="ro_13" value="<%=e_bean.getRo_13()%>" size="4" class=<%=white%>text  onblur="javascript:compare(this)">
                      % <font color="#666666">(?????????? 
                      <input type="text" name="o_13" value="<%=o_13*100%>" class=whitenum size="3">
                      % ?????? ????)</font> , ???????????? 
                      <input type="text" name="ro_13_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);' value="<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>">
                      ?? <font color="#666666">(???????? ??????)</font>
					  <a href="javascript:searchO13();"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
					  </td>
                </tr>
                <tr>
                  <td class=title>????????</td>
                  <td colspan="3">&nbsp;
				    <input type='radio' name="opt_chk" value='0' <%if(e_bean.getOpt_chk().equals("0")){%> checked <%}%>>
                      ??????
                      <input type='radio' name="opt_chk" value='1' <%if(e_bean.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		  ????
					</td>
                </tr>				
                <tr> 
                    <td rowspan="3" class=title>????</td>
                    <td class=title>??????<br>
                    </td>
                    <td colspan="3">&nbsp;?????? 
                      <input type="text" name="rg_8" value="<%=e_bean.getRg_8()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, ???????????? <font color="#666666"> 
                      <input type="text" name="rg_8_amt" value="<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      ?? (???????????? 
                      <input type="text" name="g_8" value="<%=em_bean.getG_8()%>" class=whitenum size="3">
                      % ???????? ????) </font> </td>
                </tr>
                <tr> 
                    <td class=title>??????<br>
                    </td>
                    <td colspan="3">&nbsp;?????? 
                      <input type="text" name="pp_per" value="<%=e_bean.getPp_per()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, ????????????<font color="#666666">&nbsp;</font> <input type="text" name="pp_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      ?? </td>
                </tr>
                <tr id="tr_ifee" style="display:''"> 
                    <td class=title>??????????</td>
                    <td colspan="3">&nbsp;<font color="#666666"> 
                    <input type="checkbox" name="pp_st" value="1" <%if(e_bean.getPp_st().equals("1"))%> checked<%%> <%=disabled%>>
                    <input type="text" name="g_10" class=<%=white%>num size="2" value="<%=e_bean.getG_10()%>">
                    ?????? ?????? ???? </font></td>
                </tr>
                 <tr> 
                    <td rowspan="3" class=title>????</td>
                    <td class=title>????,????</td>
                    <td >&nbsp;                      <select name="ins_dj"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_dj().equals("1"))%>selected<%%>>5??????</option>
                        <option value="2" <%if(e_bean.getIns_dj().equals("2"))%>selected<%%>>1????</option>
                    </select> </td>
                    <!--
                    <td class=title width=11%>??????????</td>
                    <td>&nbsp;<select name="ins_good" <%=disabled%>>
                        <option value="0" <%if(e_bean.getIns_good().equals("0"))%>selected<%%>>??????</option>
                        <option value="1" <%if(e_bean.getIns_good().equals("1"))%>selected<%%>>????</option>
                      </select> </td>
                      -->
                    <td class=title width='11%'>??????????</td>
                    <td> 
                      &nbsp;<select name="insurant"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getInsurant().equals("1"))%>selected<%%>>????????</option>
                            <!--<option value="2" <%if(e_bean.getInsurant().equals("2"))%>selected<%%>>????</option>-->
                          </select>
                    </td>	                      
                </tr>
                <tr>
                  <td class=title>??????????</td> 
                    <td >&nbsp;                      <select name="ins_age"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_age().equals("1"))%>selected<%%>>??26??????</option>
						<option value="3" <%if(e_bean.getIns_age().equals("3"))%>selected<%%>>??24??????</option>
                        <option value="2" <%if(e_bean.getIns_age().equals("2"))%>selected<%%>>??21??????</option>
                    </select> </td>
                    <td class=title width='11%'>????????</td>
                    <td> 
                      &nbsp;<select name="ins_per"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getIns_per().equals("1"))%>selected<%%>>????????(????????)</option>
                            <option value="2" <%if(e_bean.getIns_per().equals("2"))%>selected<%%>>????(??????????)</option>
                          </select>
                    </td>	
                </tr>
                <tr> 
                    <td class=title>????????</td>
                    <td>&nbsp;<select name="gi_yn"  <%=disabled%>>
                        <option value="0" <%if(e_bean.getGi_yn().equals("0"))%>selected<%%>>????</option>
                        <option value="1" <%if(e_bean.getGi_yn().equals("1"))%>selected<%%>>????</option>
                      </select> </td>
                    <td class=title>??????????</td>
                    <td>&nbsp;<input type="text" name="car_ja" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>					  
                </tr>
               <tr> 
                    <td rowspan="3" class=title>????<br> </td>
                    <td class=title>????????</td>
                    <td>&nbsp;<select name="a_h"  <%=disabled%>>
                        <option value="">=?? ??=</option>
                        <option value="1" <%if(e_bean.getA_h().equals("1"))%>selected<%%>>????</option>
                        <option value="2" <%if(e_bean.getA_h().equals("2"))%>selected<%%>>????</option>
                        <option value="3" <%if(e_bean.getA_h().equals("3"))%>selected<%%>>????</option>
                        <option value="4" <%if(e_bean.getA_h().equals("4"))%>selected<%%>>????</option>
                        <option value="5" <%if(e_bean.getA_h().equals("5"))%>selected<%%>>????</option>				
                      </select> </td>
                    <td class=title>??????????</td>
                    <td>&nbsp;<select name="f_udt_st"  <%=disabled%> onchange="javascript:set_car_ext()">
                        <option value="">=?? ??=</option>
                        <option value="1" <%if(e_bean.getUdt_st().equals("1"))%>selected<%%>>????????</option>
                        <option value="2" <%if(e_bean.getUdt_st().equals("2"))%>selected<%%>>????????</option>
                        <option value="3" <%if(e_bean.getUdt_st().equals("3"))%>selected<%%>>????????</option>
                        <option value="4" <%if(e_bean.getUdt_st().equals("4"))%>selected<%%>>????</option>
                      </select> </td>					  
                </tr>
                <tr> 
                    <td class=title>??????D/C</td>
                    <td>&nbsp;???????? 
                      <input type="text" name="fee_dc_per" value="<%=e_bean.getFee_dc_per()%>" size="4" class=<%=white%>text>
                      %</td>
					<td class=title>????????</td>
                    <td>&nbsp;?????? 
                      <input type="text" name="o_11" value="<%=e_bean.getO_11()%>" size="4" class=<%=white%>text>
                      %</td>  
                </tr>
                <tr> 
                    <td class=title>????????????</td>
                    <td>&nbsp;<select name="vali_type"  <%=disabled%>>
                        <option value="" <%if(e_bean.getVali_type().equals(""))%>selected<%%>>????</option>					
                        <option value="0" <%if(e_bean.getVali_type().equals("0"))%>selected<%%>>??????????(10??)</option>
                        <option value="1" <%if(e_bean.getVali_type().equals("1"))%>selected<%%>>??????D/C ???? ?????? ????</option>
                        <option value="2" <%if(e_bean.getVali_type().equals("2"))%>selected<%%>>??????????</option>						
                      </select></td>
                    <td class=title>????????????</td>
                    <td>&nbsp;<select name="doc_type"  <%=disabled%>>
					    <option value="" <%if(e_bean.getDoc_type().equals(""))%>selected<%%>>????</option>					
                        <option value="1" <%if(e_bean.getDoc_type().equals("1"))%>selected<%%>>????????</option>
                        <option value="2" <%if(e_bean.getDoc_type().equals("2"))%>selected<%%>>??????????</option>
						<option value="3" <%if(e_bean.getDoc_type().equals("3"))%>selected<%%>>????</option>
                      </select></td>					  
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=7% rowspan="2">&nbsp;</td>
                    <td class=title rowspan="2" width=13%>??????????</td>
                    <td class=title colspan="4">??????????</td>
                </tr>
                <tr> 
                    <td class=title width=13%>??????</td>
                    <td class=title width=13%>??????</td>
                    <td class=title width=14%>??????????</td>
                    <td class=title >??</td>
                </tr>
                <tr> 
                    <td class=title>??????</td>
                    <td align="center"> <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="gtr_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="pp_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="ifee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class=title>??????<br> </td>
                    <td align="center"> <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> -</td>
                    <td align="center"> <input type="text" name="pp_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="ifee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class=title>??</td>
                    <td align="center"> <input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="t_gtr_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="t_pp_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="t_ifee_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <font color="#666666"> 
                      <input type="text" name="tot_p_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </font></td>
                </tr>
                <tr> 
                    <td class=title colspan="2">???????? ???? ????????</td>
                    <td colspan="4">
                      &nbsp;<font color="#666666"><input type="text" name="tm" value="<%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>" class=<%=white%>num size="2">
                      </font>??</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">???????????????? </td>
                    <td>&nbsp;<input type="text" name="gi_amt" value="<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td class=title>??????????</td>
                    <td colspan="2">&nbsp;<input type="text" name="gi_fee" value="<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                </tr>
                <tr> 
                    <td class=title colspan="2">??????????????</td>
                    <td colspan="4">&nbsp;???????? ???????????? 
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
        <td colspan="2">&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> <font color=red>[????????????]?? ?????? ???? ?????? ?????????? ???? ?????????? ??????.</font></td>
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
        <td colspan="2">&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> <font color=red>[????????????]?? ?????? ???? ?????? ?????????? ???? ?????????? ??????.</font></td>
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
        <td colspan="2">&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ???? ???? ?????? &quot;MeadCo's ScriptX?? ???????? ?????????????????&quot;???? ?????? [??]/[????]&quot; ????????</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ?????? ???? ???? ?????? ???????? ?????????? ?????? &quot;????&quot;?? ???? ???? ????????. </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??????-??????????-??????????-????-?????? &quot;????&quot;???? &quot;????&quot;?? ????????????. </td>
    </tr>
	-->
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>