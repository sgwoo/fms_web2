<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.con_ins.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//자동차기본정보-기본차량
	CarMstBean cm_bean2 = new CarMstBean();
	if(!cm_bean.getCar_b_inc_id().equals("")){
		cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	}
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	
	//중고차 딜러와 판매처
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "5");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
	//출고영업소정보
	CarOffBean co_bean = new CarOffBean();
	if(!emp2.getCar_off_id().equals("")){
		co_bean = cod.getCarOffBean(emp2.getCar_off_id());
	}
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//영업소리스트
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	//금융사리스트 - cms 가능
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	
	
	Hashtable carOld = new Hashtable();	
	
  	//차량등록지역
  	CodeBean[] code32 = c_db.getCodeAll3("0032");
  	int code32_size = code32.length;	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;
	}
	
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;
	}
		
	//등록/수정: 차량가격 입력시 자동계산으로 가게..
	function enter_car(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_car_amt(obj);
	}	
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_car_amt(obj)
	{
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.car_cs_amt){ 	//차량기본가격 공급가
			fm.car_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) * 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cs_amt){ 	//선택사항 공급가
			fm.opt_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) * 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cs_amt){ 	//색상 공급가
			fm.col_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) * 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.commi_s_amt){ 	//수수료 공급가
			fm.commi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.commi_s_amt.value)) * 0.1 );
			fm.commi_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.commi_s_amt.value)) + toInt(parseDigit(fm.commi_v_amt.value)));
		}else if(obj==fm.storage_s_amt){ 	//보관료 공급가
			fm.storage_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.storage_s_amt.value)) * 0.1 );
			fm.storage_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.storage_s_amt.value)) + toInt(parseDigit(fm.storage_v_amt.value)));
		}else if(obj==fm.car_fs_amt){ 	//중고차차량가격 공급가
			fm.car_fv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) * 0.1 );
			fm.car_f_amt.value		= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
			
		}else if(obj==fm.car_cv_amt){ 	//차량기본가격 부가세
			fm.car_cs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) / 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cv_amt){ 	//선택사항 부가세
			fm.opt_cs_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cv_amt.value)) / 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cv_amt){ 	//색상 부가세
			fm.col_cs_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cv_amt.value)) / 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.commi_v_amt){ 	//보관료 부가세
			fm.commi_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.commi_v_amt.value)) / 0.1 );
			fm.commi_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.commi_s_amt.value)) + toInt(parseDigit(fm.commi_v_amt.value)));
		}else if(obj==fm.storage_v_amt){ 	//수수료 부가세
			fm.storage_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.storage_v_amt.value)) / 0.1 );
			fm.storage_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.storage_s_amt.value)) + toInt(parseDigit(fm.storage_v_amt.value)));
		}else if(obj==fm.car_fv_amt){ 	//중고차차량가격 부가세
			fm.car_fs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) / 0.1 );
			fm.car_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
			
		}else if(obj==fm.car_c_amt){ 	//차량기본가격 합계
			fm.car_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_cs_amt.value)));
		}else if(obj==fm.opt_c_amt){ 	//선택사항 합계
			fm.opt_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.opt_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.opt_cs_amt.value)));
		}else if(obj==fm.col_c_amt){ 	//색상 합계
			fm.col_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.col_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.col_cs_amt.value)));
		}else if(obj==fm.commi_c_amt){ 	//수수료 합계
			fm.commi_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.commi_v_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.commi_s_amt.value)));
		}else if(obj==fm.storage_c_amt){ 	//보관료 합계
			fm.storage_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.storage_v_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.storage_s_amt.value)));
		}else if(obj==fm.car_f_amt){ 	//중고차차량가격 합계
			fm.car_fs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_fv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_fs_amt.value)));
		}
		
		sum_car_c_amt();
		sum_car_f_amt();
	}
	
	//차량 소비자가 합계
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) );
		fm.tot_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) );
		fm.tot_c_amt.value  	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );
		
		fm.sh_car_amt.value		= fm.tot_c_amt.value;
	}
	
	//차가 구입가 합계
	function sum_car_f_amt(){
		var fm = document.form1;
		
		fm.tot_fs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.commi_s_amt.value)) + toInt(parseDigit(fm.storage_s_amt.value)));
		fm.tot_fv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.commi_v_amt.value)) + toInt(parseDigit(fm.storage_v_amt.value)));
		fm.tot_f_amt.value 		= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)));
		
		fm.commi[0].value			= fm.commi_c_amt.value;
		fm.commi[1].value			= fm.car_f_amt.value;
		
		fm.dlv_con_commi.value	= fm.storage_c_amt.value;
	}
		
	//영업소담당자 조회
	function search_emp(st){
		var fm = document.form1;
		window.open("search_emp_ac.jsp?bus_id=<%=base.getBus_id()%>&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");		
	}
	
	//영업소담당자 입력취소
	function cancel_emp(st){
		var fm = document.form1;
		if(st == 'DEL'){
			fm.emp_nm[0].value = '';
			fm.emp_id[0].value = '';
			fm.car_off_nm[0].value = '';
			fm.car_off_id[0].value = '';
			fm.car_off_st[0].value = '';
			fm.emp_bank.value = '';
			fm.emp_bank_cd.value = '';
			fm.emp_acc_no.value = '';
			fm.emp_acc_nm.value = '';
		}else{
			fm.emp_nm[1].value = '';
			fm.emp_id[1].value = '';
			fm.car_off_nm[1].value = '';
			fm.car_off_id[1].value = '';
			fm.car_off_st[1].value = '';
			fm.con_bank.value = '';
			fm.con_acc_no.value = '';
			fm.con_acc_nm.value = '';
		}		
	}

	
	//등록
	function save(){
		var fm = document.form1;
		
		if(fm.color.value == '')					{ alert('대여차량-색상을 입력하십시오.'); 				fm.color.focus(); 			return; }
		if(fm.car_ext.value == '')				{ alert('대여차량-등록지역을 입력하십시오.'); 		fm.car_ext.focus(); 		return; }
		
		var car_c_amt = toInt(parseDigit(fm.car_c_amt.value));
		var car_f_amt = toInt(parseDigit(fm.car_f_amt.value));
		if(car_c_amt == 0)								{ alert('차량가격-소비자가 기본가격을 입력하십시오.'); 			fm.car_c_amt.focus(); 		return; }
		if(car_f_amt == 0)								{ alert('차량가격-중고차구입가 차량가격을 입력하십시오.'); 	fm.car_f_amt.focus(); 		return; }
		
		if(fm.sh_init_reg_dt.value == '')	{ alert('중고차 최초등록일을 입력하십시오.'); 				fm.sh_init_reg_dt.focus(); 	return; }
		if(fm.sh_km.value == ''||fm.sh_km.value == '0'){ alert('중고차 주행거리를 입력하십시오.'); 					fm.sh_km.focus(); 					return; }
		
		var sh_amt 		= toInt(parseDigit(fm.sh_amt.value));
		if(sh_amt == 0)										{ alert('재리스잔존가가 없습니다. 주행거리 입력하고 확인 클릭하여 계산하여 주십시오.'); 	fm.sh_amt.focus(); 		return; }
		
		//if(fm.emp_nm[0].value == '')			{ alert('중고차딜러를 선택하십시오.'); 					fm.emp_nm[0].focus(); 		return; }
		if(fm.emp_nm[1].value == '')			{ alert('중고차구입처를 선택하십시오.'); 				fm.emp_nm[1].focus(); 		return; }

		//if(fm.sh_base_dt[0].value == '')	{ alert('중고차딜러-계약일자를 입력하십시오.'); 		fm.sh_base_dt[0].focus(); 		return; }
		if(fm.sh_base_dt[1].value == '')	{ alert('중고차구입처-매매일자를 입력하십시오.'); 	fm.sh_base_dt[1].focus(); 		return; }
			
		
		if(confirm('4단계를 등록하시겠습니까?')){	
			fm.action='lc_reg_step4_ac_a.jsp';
			fm.target='i_no';
			fm.submit();
		}							
	}
	
	
	//중고차가격 계산하기-숨어서(중고차)
	function getSecondhandCarAmt_h(){
		var fm = document.form1;
		fm.action = "/acar/secondhand/getSecondhandBaseSet3.jsp";
		fm.target = "i_no";
		//fm.target = "_blank";
		fm.submit();
	}

	//출고영업소 계좌조회
	function search_bank_acc(gubun, car_off_id, car_off_nm){
		var fm = document.form1;
		if(car_off_id == ''){
			car_off_id = fm.car_off_id[1].value;
			car_off_nm = fm.car_off_nm[1].value;			
		}
		if(car_off_id == ''){	alert('출고영업소를 먼저 선택하십시오.'); return; 		}
		window.open("/fms2/car_pur/s_bankacc.jsp?go_url=/fms2/lc_rent/lc_b_s.jsp&st="+gubun+"&t_wd="+car_off_nm+"&car_off_id="+car_off_id, "CAR_OFF_ACC", "left=0, top=0, width=800, height=600, status=yes, scrollbars=yes");	
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
<form action='/acar/secondhand/getSecondhandBaseSet3.jsp' name="sh_form" method='post'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id"	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="mode"				value="lc_rent">
  <input type='hidden' name="rent_dt"			value="">
  <input type='hidden' name="rent_st"			value="1">
  <input type='hidden' name="a_b"					value="">
  <input type='hidden' name="fee_opt_amt"	value="">
  <input type='hidden' name="cust_sh_car_amt"	value="">
</form>
<form action='lc_reg_step4_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="opt"					value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%><%=cm_bean2.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="dpm" 				value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="car_end_dt"	value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">
  <input type='hidden' name="o_1"					value="">
  <input type='hidden' name="ro_13"				value="">
  <input type='hidden' name="o_13"				value="">
  <input type='hidden' name="o_13_amt"		value="">
  <input type='hidden' name="esti_stat"		value="">
  <input type='hidden' name="t_dc_amt"		value="">
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">
  <input type='hidden' name="rent_dt"			value="<%=base.getRent_dt()%>">
  <input type='hidden' name="car_mng_id"	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id"		value="<%=base.getClient_id()%>">
  <input type='hidden' name="from_page"		value="car_rent">
  <input type='hidden' name="est_from"		value="lc_reg">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_id"	value="<%=car.getCar_id()%>">
  <input type='hidden' name="car_seq"	value="<%=car.getCar_seq()%>">

                   
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td align='left'>&nbsp;&nbsp; <span class=style2> <font color=red>[4단계]</font> 계약사항</span></td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width="10%">계약일자</td>
                    <td width=20%>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title width="10%">상호</td>
                    <td>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <% String car_gu = base.getCar_gu();%>
                <% String car_st = base.getCar_st();%>
                <tr>
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%><b>중고차</b><%}%></td>
                    <td class=title>용도구분</td>
                    <td colspan='3'>&nbsp;<b><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></b></td>
                </tr>
                <tr> 
                    <td class=title>관리지점</td>
                    <td colspan='5'>&nbsp;<%if(cont_etc.getMng_br_id().equals("")) cont_etc.setMng_br_id(base.getBrch_id());%>
        	        <select name='mng_br_id'>
                            <option value=''>선택</option>
                            <%for (int i = 0 ; i < brch_size ; i++){
        			Hashtable branch = (Hashtable)branches.elementAt(i);%>
                            <option value='<%=branch.get("BR_ID")%>' <%if(cont_etc.getMng_br_id().equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                            <%}%>
                        </select></td>
                </tr>                    
            </table>
	      </td>
    </tr>
    <tr>
	      <td>&nbsp;</td>
    </tr>	
    <tr>
	      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여차량</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'>자동차회사</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' width="10%">차명</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' width='10%'>차종</td>
                    <td>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class='title'>소분류 </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
                    <td class='title' width="10%">차종코드</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>배기량</td>
                    <td>&nbsp;<%if(cr_bean.getCar_mng_id().equals("")){%><%=cm_bean.getDpm()%>cc<%}else{%><%=cr_bean.getDpm()%>cc<%}%></td>
                </tr>
                <tr>
                    <td class='title'>기본사양</td>
                    <td colspan="5" align=center>
                        <table width=98% cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td>
        			                      <%if(!cm_bean2.getCar_name().equals("")){%><span title='<%=cm_bean2.getCar_b()%>'><font color='#999999'><%=cm_bean2.getCar_name()%>외&nbsp;</font></span><%}%>
        			                      <%=cm_bean.getCar_b()%>
        			                  </td>
        			              <tr>
                                <td style='height:3'></td>
                            </tr>
                        </table>
                    </td>
                </tr>		  
                <tr>
                    <td class='title'>옵션</td>
                    <td colspan="5">&nbsp;
        		            <%=car.getOpt()%><input type='hidden' name='opt_code' value='<%=car.getOpt_code()%>'></td>
                </tr>
                <tr>
                    <td class='title'> 색상</td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='color' size='50' class='default' value='<%=car.getColo()%>'>
                        &nbsp;&nbsp;&nbsp;
			                  (내장색상(시트): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'>)
                        &nbsp;&nbsp;&nbsp;
			                  (가니쉬: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'>)
                    </td>
                </tr>
                <tr>
                	<td class="title">연비</td>
                	<td colspan="5">
                		&nbsp;<%=car.getConti_rat()%>
                	</td>
                </tr>
                <tr>
                	<td class="title">추정수리비</td>
                	<td>
                		&nbsp;<input type='text' name='accid_serv_amt' size='10' maxlength='20' class='num' value='<%=car.getAccid_serv_amt()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        		원
                	</td>
                	<td class="title">사고내용</td>
                	<td colspan='3'>
                		&nbsp;<input type='text' name="accid_serv_cont" size='50' class='text' value='<%=car.getAccid_serv_cont()%>'>
                	</td>
                </tr>      
                <tr>
                	<td class="title">색상잔가반영</td>
                	<td>
                		&nbsp;<input type='text' name="jg_col_st" size='5' class='text' value='<%=car.getJg_col_st()%>'>
                	</td>
                	<td class="title">사양잔가반영</td>
                	<td colspan='3'>
                		&nbsp;<input type='text' name="jg_opt_st" size='5' class='text' value='<%=car.getJg_opt_st()%>'>
                	</td>
                </tr>  
                <tr>
                	<td class="title">TUIX/TUON트림여부</td>
                	<td>
                		&nbsp;<input type='text' name="jg_tuix_st" size='5' class='text' value='<%=car.getJg_tuix_st()%>'>
                	</td>
                	<td class="title">TUIX/TUON옵션여부</td>
                	<td colspan='3'>
                		&nbsp;<input type='text' name="jg_tuix_opt_st" size='5' class='text' value='<%=car.getJg_tuix_opt_st()%>'>
                	</td>
                </tr>                                                   
                <tr>
                    <td class='title'> 차량인수지</td>
                    <td colspan="3">&nbsp;
                        <select name="udt_st" class='default'>
                    		    <option value="1" <%if(pur.getUdt_st().equals("1"))%> selected<%%>>서울본사</option>
                        </select>
                    </td>
                    <td class='title'>등록지역</td>
                    <td colspan="3" >&nbsp;
                      <select name="car_ext" class='default'>
                        <option value=''>선택</option>
                        <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(cr_bean.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>          		        
                      </select></td>                    
                </tr>
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='5' cols='90' class=default name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_car1 style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td class='title'>과세구분</td>
                <td colspan="3">&nbsp;
    			        <%if(base.getCar_st().equals("3")){%>
    			          과세<input type='hidden' name="purc_gu" value="1">
    			        <%}else{
    				        if(cm_bean.getS_st().equals("401") || cm_bean.getS_st().equals("402") || cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("821")){
    				      %>
    				        비과세<input type='hidden' name="purc_gu" value="0">
    			        <%	}else{%>
    				        면세<input type='hidden' name="purc_gu" value="0">
    			        <%	}%>
    			        <%}%>
                </td>
                <td class='title'>출처</td>
                <td colspan="3">&nbsp;<%String car_origin = car.getCar_origin();%>
    			        <%	if(car_origin.equals("")){
    					          code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
    					          car_origin = code_bean.getApp_st();
    				          }
    				      %>
    			        <%if(car_origin.equals("1")){%>국산<%}else if(car_origin.equals("2")){%>수입<%}%>
    			        <input type='hidden' name="car_origin" value="<%=car_origin%>">
    			      </td>
              </tr>
              <tr>
                <td width="13%" rowspan="2" class='title'>구분 </td>
                <td colspan="3" class='title'>소비자가격</td>
                <td width="10%" rowspan="2" class='title'>구분</td>
                <td colspan="3" class='title'>중고차구입가격</td>
              </tr>
              <tr>
                <td width="13%" class='title'>공급가</td>
                <td width="13%" class='title'>부가세</td>
                <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_c_amt()" onMouseOver="window.status=''; return true" title="소비자가 합계 계산하기">합계</a></span></td>
                <td width="13%" class='title'>공급가</td>
                <td width="12%" class='title'>부가세</td>
                <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_f_amt()" onMouseOver="window.status=''; return true" title="중고차 구입가 합계 계산하기">합계</a></span></td>
              </tr>
              <tr>
                <td class='title'> 기본가격</td>
                <td>&nbsp;
                  <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td class=title>매매금액</td>
                <td>&nbsp;
                  <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
              </tr>
              <tr>
                <td height="12" class='title'>옵션</td>
                <td>&nbsp;
                  <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td class=title>중개수수료</td>
                <td height="12">&nbsp;
                  <input type='text' name='commi_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='commi_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_v_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='commi_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt()+car.getCommi_v_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
              </tr>
              <tr>
                <td height="26" class='title'> 색상</td>
                <td>&nbsp;
                  <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                                <td class=title>보관료</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_v_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt()+car.getStorage_v_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
              </tr>
              <tr>
                <td align="center" class='title_p'>합계</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_cs_amt' size='10' value='' class='fixnum' readonly>
    			    원</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_cv_amt' size='10' value='' class='fixnum' readonly>
    				원</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_c_amt' size='10' value='' class='fixnum'  readonly>
    				원</td>
                <td align='center' class='title_p'>합계</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_fs_amt' size='10' value='' class='fixnum' readonly>
    				원</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_fv_amt' size='10' value='' class='fixnum' readonly>
    				원</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_f_amt' size='10' value='' class='fixnum'  readonly>
    				원</td>
              </tr>
            </table>		
	    </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    		  
    <tr id=tr_car0 style="display:''"> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> 신차소비자가 </td>
                    <td width="20%">&nbsp;
        				  	    <input type='text' name='sh_car_amt' value=''size='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
        				        원 
        				        <input type='hidden' name="view_car_amt" value="">
        				    </td>
                    <td class='title' width="10%">잔가율</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='sh_ja' value=''size='4' class='defaultnum'>
                      %</td>
                    <td class='title' width='10%'>재리스잔존가</td>
                    <td>&nbsp;
                      <input type='text' name='sh_amt' value=''size='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 
                    </td>
                </tr>
                <tr>
                    <td class='title'>차령</td>
                    <td colspan="3">&nbsp;
					              <input type='text' name='sh_year' value='<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("YEAR")%><%}%>'size='1' class='default' >
                        년
                        <input type='text' name='sh_month' value='<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("MONTH")%><%}%>'size='2' class='default' >
                        개월
                        <input type='text' name='sh_day' value='<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("DAY")%><%}%>'size='2' class='default' >
                        일 (
                        최초등록일
                        <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                        ~
                        계약일
                        <input type='text' name='sh_day_bas_dt' value='<%= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='default'  onBlur='javascript:this.value=ChangeDate(this.value);'>
                        )                  
					          </td>
                    <td class='title' width='10%'>경매장시세</td>
                    <td>&nbsp;
                      <input type='text' name='sh_est_amt' value=''size='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 
                    </td>					          
                </tr>
                <tr>
                  <td class='title'>주행거리</td>
                  <td colspan="5">&nbsp;
				                <input type='text' name='sh_km' size='6' value='' class='defaultnum' >
                        km 
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="javascript:getSecondhandCarAmt_h();"><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0></a>
                        ( 중고차 최초등록일가 주행거리를 입력하고 확인을 클릭하면 당사 재리스잔존가 계산합니다. )
					          </td>
                </tr>
            </table>
	    </td>
    </tr>               
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중고차딜러</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_emp_bus style="display:''"> 	
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>                
                <td width="13%" class='title'>성명</td>
                <td width="20%" >&nbsp;
                  <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
    			        <input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>
                  <span class="b"><a href="javascript:search_emp('DEL')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
    		          <span class="b"><a href="javascript:cancel_emp('DEL')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
    		        </td>
                <td width="10%" class='title'>상호</td>
                <td width="20%">&nbsp;
                  <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
				          <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
				        </td>
                <td width="10%" class='title'>구분</td>
                <td>&nbsp;
                  <input type='text' name='car_off_st' size='15' value='<%=emp1.getCar_off_st()%>' class='whitetext' readonly>
                </td>
              </tr>
              <tr>
                <td class='title'>계약일자</td>
                <td >&nbsp;
                  <input type='text' name='sh_base_dt' value='<%= AddUtil.ChangeDate2(emp1.getSh_base_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			      </td>
                <td class='title'>중개수수료</td>
                <td colspan='3'>&nbsp;
                  <input type='text' name='commi' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			        원</td>
              </tr>       
              <tr>
                <td class='title'>세금계산서일자</td>
                <td >&nbsp;
                  <input type='text' name='file_gubun1' value='<%= AddUtil.ChangeDate2(emp1.getFile_gubun1())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  (보관료)
    			      </td>
                <td class='title'>보관료</td>
                <td colspan='3'>&nbsp;
                  <input type='text' name='dlv_con_commi' value='<%=AddUtil.parseDecimal(emp1.getDlv_con_commi())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			</td>    			        
              </tr>                           
              <tr>
                <td class='title'>은행명</td>
                <td>&nbsp;
                	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
    		          <select name='emp_bank_cd'>
                    <option value=''>선택</option>
                    <%	if(bank_size > 0){
    						        	for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];
    												//신규인경우 미사용은행 제외
   													if(bank.getUse_yn().equals("N"))	 continue;
   									%>
                    <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%		}
    					        	}
    					      %>
                  </select>
    			      </td>
                <td class='title'>계좌번호</td>
                <td>&nbsp;
                  <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='text'   style="IME-MODE:disabled;">
    			      </td>
                <td class='title'>예금주명</td>
                <td>&nbsp;
                  <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='text'  >
    			      </td>
              </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중고차구입처</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_emp_dlv style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
              <tr>                
                <td width="13%" class='title'>성명</td>
                <td width="20%" >&nbsp;
                  <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
    			        <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
                  <span class="b"><a href="javascript:search_emp('AUC')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
    			        <span class="b"><a href="javascript:cancel_emp('AUC')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
                </td>
                <td width="10%" class='title'>상호</td>
                <td width="20%">&nbsp;
                  <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
				          <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
    			      </td>
                <td width="10%" class='title'>구분</td>
                <td>&nbsp;
                  <input type='text' name='car_off_st' size='15' value='<%=emp2.getCar_off_st()%>' class='whitetext' readonly>
                </td>
              </tr>
              <tr>
                <td class='title'>매매일자</td>
                <td >&nbsp;
                  <input type='text' name='sh_base_dt' value='<%= AddUtil.ChangeDate2(emp2.getSh_base_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			      </td>
                <td class='title'>매매금액</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='commi' value='<%=AddUtil.parseDecimal(emp2.getCommi())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			        원</td>
              </tr>
              <tr>
                <td class='title'>전차량번호</td>
                <td >&nbsp;
                  <input type='text' name='est_car_no' value='<%=pur.getEst_car_no()%>' class='text' maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
    		        </td>
                <td class='title'>차대번호</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='car_num' value='<%=pur.getCar_num()%>' class='text' maxlength='20' size='20' onBlur='javascript:this.value=this.value.toUpperCase()'>
    			      </td>
              </tr>
              <tr>
                <td class='title'>계약금</td>
                <td>&nbsp;
				          <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원	
    			      </td>	
                <td class='title'>은행계좌</td>				
                <td colspan="3">&nbsp;
					          <select name='con_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];	
        												if(pur.getCon_bank().equals("")){%>
                        <option value='<%= bank.getNm()%>' <%if(co_bean.getBank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}else{%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}%>
                        <%		}
        										}
        								%>
                    </select>
				  	        &nbsp;
					          계좌번호 : 
        			      <input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					          &nbsp;
					          예금주 : 
        			      <input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
                </td>
              </tr>
            </table>
        </td>
  </tr>
  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
  <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>
  <%}%>
	<tr>
    <td>&nbsp;</td>
  </tr>
	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
    <tr>
        <td align='right'>
	        <a href="lc_b_u_ac.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>" target='d_content'><img src=/acar/images/center/button_mig.gif align=absmiddle border=0></a>&nbsp;
	        <a href="lc_c_frame.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>
	    </td>
    </tr>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="100" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
 	
	sum_car_c_amt();
	sum_car_f_amt();
		
	//반올림
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}
//-->
</script>
</body>
</html>
