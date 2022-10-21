<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.tint.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")){ base.setCar_gu(base.getReg_id()); }
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//영업수당+영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//영업사원
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());

	//에이전트관리 20131101
	CarOffBean a_co_bean = new CarOffBean();	
	if(!coe_bean.getAgent_id().equals("")){
		a_co_bean = cod.getCarOffBean(coe_bean.getAgent_id());
	}else{
		a_co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	}
	
	//영업사원수당 이력
	Vector commis = a_db.getCommis(emp1.getEmp_id());
	int commi_size = commis.size();
	

	//영업소담당자 영업대리인(에이젼트)
	CommiBean emp4 	= a_db.getCommi(rent_mng_id, rent_l_cd, "4");

	CarOffEmpBean coe_bean4 = new CarOffEmpBean();
	
	if(!emp4.getEmp_id().equals("")){
		coe_bean4 = cod.getCarOffEmpBean(emp4.getEmp_id());
	}
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("1", rent_l_cd);
	}
	
	//납품의뢰
	Vector vt = t_db.getTints(rent_mng_id, rent_l_cd);
	int vt_size = vt.size();
	
	//20140828 영업사원 부담 용품의뢰를 안하기 때문에 보여줄 필요없다.
	vt_size = 0;
	
	//용품	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
	TintBean tint3 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "3");
	TintBean tint4 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "4");
	TintBean tint5 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "5");
	TintBean tint6 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "6");
	
	//영업담당자
	user_bean 	= umd.getUsersBean(user_id);
	
	
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&from_page="+from_page+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&doc_no="+doc_no+"&mode="+mode+
				   	"";	
				   	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "COMMI";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
				   	
	//장기전자계약서
	Hashtable alink_lc_rent = ln_db.getAlinkEndLcRent(rent_l_cd, "1");	
	
	int b_agent_commi = 0;
	if(base.getBus_st().equals("7") && cont_etc.getBus_agnt_id().equals("")){
		b_agent_commi = 100000;   
    }
	if(String.valueOf(alink_lc_rent.get("RENT_L_CD")).equals(rent_l_cd)){
		b_agent_commi = 0;
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//리스트
	function list(){
		var fm = document.form1;			
		fm.action = 'commi_doc_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();			
	}
	
	
	
	//영업사원보기
	function view_emp(emp_id){
		var fm = document.form1;
		window.open("/acar/car_office/car_office_p_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_c_c_fee.jsp&cmd=view&emp_id="+emp_id, "VIEW_EMP", "left=50, top=50, width=850, height=600, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//우편번호 검색
	function search_zip(str){
		window.open("../lc_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//스캔등록
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&emp_id=<%=emp1.getEmp_id()%>&from_page=/fms2/commi/commi_doc_i.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//스캔삭제
	function scan_del(file_st){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){		return;	}
		fm.file_st.value = file_st;
		fm.target = "i_no"
		fm.action = "del_scan_a.jsp";
		fm.submit();
	}	
	
	//실수령인 조회
	function search_bank_acc(){
		var fm = document.form1;
		window.open("s_emp_bank_acc.jsp?from_page=/fms2/commi/commi_doc_u.jsp&emp_id=<%=emp1.getEmp_id()%>", "SEARCH_EMP_ACC", "left=50, top=50, width=950, height=600, scrollbars=yes");		
	}	
	
	//영업수당계산
	function setCommi(){
		var fm = document.form1;
		
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));		
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
		
		fm.comm_rt_amt.value 	= parseDecimal(th_round(toInt(parseDigit(fm.commi_car_amt.value))*toFloat(fm.comm_rt.value)/100));
		fm.comm_r_rt_amt.value 	= parseDecimal(th_round(toInt(parseDigit(fm.commi_car_amt.value))*toFloat(fm.comm_r_rt.value)/100));
		
		fm.commi.value = parseDecimal(th_round(car_price*comm_r_rt/100));
				
		set_amt();
				
	}
	
	//영업수당계산
	function set_amt(){
		var fm = document.form1;
		var per = 1;
		
		if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == ''){
			alert('가감1 구분을 선택하십시오.'); return;
		}
		
		if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == ''){
			alert('가감2 구분을 선택하십시오.'); return;
		}
		
		if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == ''){
			alert('가감3 구분을 선택하십시오.'); return;
		}				
		
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
			
			per = 0.1;
			
			fm.inc_per.value = 0;
			fm.res_per.value = 0;
			fm.vat_per.value = per*100;
			fm.tot_per.value = per*100;

			var tot_add1 = 0;//세전가감액
			var tot_add2 = 0;//세후가감액
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt3.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt3.value));
			
			fm.dlv_con_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.dlv_con_commi.value))));
			fm.dlv_tns_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.dlv_tns_commi.value))));
			fm.agent_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.agent_commi.value))));
			
			fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_amt1.value)) + toInt(parseDigit(fm.add_amt2.value)) + toInt(parseDigit(fm.add_amt3.value))); 										
			fm.a_amt.value = parseDecimal(tot_add1);
			fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.dlv_con_commi.value)) + toInt(parseDigit(fm.dlv_tns_commi.value)) + toInt(parseDigit(fm.agent_commi.value)) + toInt(parseDigit(fm.a_amt.value))); 							
			
			fm.inc_amt.value = 0; 
			fm.res_amt.value = 0; 			

			fm.vat_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.b_amt.value))) * per )); 			

			fm.c_amt.value = fm.vat_amt.value; 
						
			fm.e_amt.value = parseDecimal(tot_add2);
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) + toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 		
			
		<%}else{%>
		
		if(fm.rec_incom_st.value == ''){			alert('소득구분을 선택하십시오.'); return;		}
						
		if(fm.rec_incom_st.value != ''){
			
		
			if(fm.rec_incom_st.value == '2'){
				per = 0.03;
			}else if(fm.rec_incom_st.value == '3'){
				per = 0.06;			//20180401부터 0.04->0.06 변경
				if(<%=AddUtil.getDate(4)%> > 20181231){
					per = 0.06;		//20190101부터 0.06->0.08 변경 -> 20190404 영업수당은 2019년 필요경비 70% 유지되는 경우라함 [0.06]
				}
			}
			
			fm.inc_per.value = per*100;
			fm.res_per.value = per*10;
			fm.tot_per.value = per*110;

			var tot_add1 = 0;//세전가감액
			var tot_add2 = 0;//세후가감액
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt3.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt3.value));
			
			fm.dlv_con_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.dlv_con_commi.value))));
			fm.dlv_tns_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.dlv_tns_commi.value))));
			fm.agent_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.agent_commi.value))));
			
			fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_amt1.value)) + toInt(parseDigit(fm.add_amt2.value)) + toInt(parseDigit(fm.add_amt3.value))); 										
			fm.a_amt.value = parseDecimal(tot_add1);
			fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.dlv_con_commi.value)) + toInt(parseDigit(fm.dlv_tns_commi.value)) + toInt(parseDigit(fm.agent_commi.value)) + toInt(parseDigit(fm.a_amt.value))); 							
			
			fm.inc_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.b_amt.value))) * per )); 
			fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			
			fm.c_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
						
			fm.e_amt.value = parseDecimal(tot_add2);
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) - toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 
			
		}
		
		<%}%>
	}
	
	//주민등록번호 체크

 	var errfound = false;

	function jumin_No(){
		var fm = document.form1;
		
		var ssn = '';
		var ssn1 = '';
		var ssn2 = '';
		
		ssn = replaceString('-','',fm.rec_ssn.value);
		
		ssn1 = ssn.substr(0, 6);
		ssn2 = ssn.substr(6);
		
		var str_len ;
    		var str_no = ssn1+ssn2;

    		str_len = str_no.length;
    		
		var a1=str_no.substring(0,1);
		var a2=str_no.substring(1,2);
		var a3=str_no.substring(2,3);
		var a4=str_no.substring(3,4);
		var a5=str_no.substring(4,5);
		var a6=str_no.substring(5,6);

		var check_digit=a1*2+a2*3+a3*4+a4*5+a5*6+a6*7;

		var b1=str_no.substring(6,7);
		var b2=str_no.substring(7,8);
		var b3=str_no.substring(8,9);
		var b4=str_no.substring(9,10);
		var b5=str_no.substring(10,11);
		var b6=str_no.substring(11,12);
		var b7=str_no.substring(12,13);

		var check_digit=check_digit+b1*8+b2*9+b3*2+b4*3+b5*4+b6*5; 

		check_digit = check_digit%11;
		check_digit = 11 - check_digit;
		check_digit = check_digit%10;
			
		if (check_digit != b7){
			alert('잘못된 주민등록번호입니다.');
			errfound = false;          
		}else{
			//alert('올바른 주민등록 번호입니다.');
			errfound = true;
		}    				
		
		return errfound;	
	}


	
	function save(){
		var fm = document.form1;
		
		set_amt();

		if(fm.pp_st.value == '미결' && (fm.pp_est_dt.value == '' || fm.pp_etc.value == '')){
			alert('선수금 완결예정일 또는 미결사유를 입력하십시오.'); return;
		}
		if(fm.gi_st.value == '미결' && (fm.gi_est_dt.value == '' || fm.gi_etc.value == '')){
			alert('보증보험 완결예정일 또는 미결사유를 입력하십시오.'); return;
		}
		
		if(fm.dlv_con_commi.value == 0 && '<%=cont_etc.getDlv_con_commi_yn()%>' == 'Y'){
			alert('출고보전수당이 0원입니다.  확인하십시오.'); return;
		}
		
		if(toFloat(parseDigit(fm.comm_r_rt.value))>0 && toInt(parseDigit(fm.commi_car_amt.value))==0){
			alert('영업수당 적용수수료율(계약조건)이 있으나 영업수당금액 산출을 위한 산출기준 금액이 없습니다. 확인하십시오.'); return;
		}
		
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
		
		<%}else{%>	
			if(fm.emp_acc_nm.value == '')		{	alert('실수령인 이름을 입력하여 주십시오.'); 				return;		}

			if(fm.emp_acc_nm.value.indexOf(',') != -1){	alert('실수령인 이름을 확인하여 주십시오. 소득신고를 하오니 성명만 입력하여 주십시오.');	return;		}
			if(fm.emp_acc_nm.value.indexOf('(') != -1){	alert('실수령인 이름을 확인하여 주십시오. 소득신고를 하오니 성명만 입력하여 주십시오.'); 	return;		}

			if(fm.rel.value == '')			{	alert('실수령인의 영업사원과의 관계를 입력하여 주십시오.'); 		return;		}
			if(fm.rec_incom_yn.value == '')		{	alert('실수령인의 타소득여부를 입력하여 주십시오.'); 			return;		}
			if(fm.rec_incom_st.value == '')		{	alert('실수령인의 소득구분를 입력하여 주십시오.'); 			return;		}
			if(fm.emp_bank_cd.value == '')		{	alert('실수령 은행을 입력하여 주십시오.'); 				return;		}
			if(fm.emp_acc_no.value == '')		{	alert('실수령 계좌번호를 입력하여 주십시오.'); 				return;		}
			if(fm.rec_ssn.value == '')		{	alert('실수령인의 주민번호를 입력하여 주십시오.'); 			return;		}
			if(fm.t_zip.value == '')		{	alert('실수령인의 우편번호를 입력하여 주십시오.'); 			return;		}
			if(fm.t_addr.value == '')		{	alert('실수령인의 주소를 입력하여 주십시오.'); 				return;		}
			
			//주민번호 세부 확인
			if(!jumin_No()){
				return;
			}
		<%}%>

		if(fm.b_amt.value == '0')		{	alert('소득금액을 확인하십시오.'); 					return;		}
		if(fm.c_amt.value == '0')		{	alert('공제금액을 확인하십시오.'); 					return;		}		
		if(fm.d_amt.value == '0')		{	alert('세후지급액을 확인하십시오.'); 					return;		}		
		
		
		
		if(fm.dlv_con_commi.value != '0' && fm.dlv_tns_commi.value != '0'){
			alert('출고보전수당과 실적이관권장수당은 동시 발생할수 없습니다. 확인하십시오.');
			return;
		}
		
		//특판출고(실적이관가능)이면 영업수당은 없다.
		if(<%=base.getRent_dt()%> >= 20190610 && toInt(parseDigit(fm.commi.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && '<%=cont_etc.getDlv_con_commi_yn()%>' == 'Y' && '<%=cont_etc.getDir_pur_commi_yn()%>' == 'Y' && '<%=pur.getDir_pur_yn()%>' == 'Y'){
			alert('현대차이면서 법인고객이고 출고보전수당이 있는 특판출고는 영업수당이 없습니다.'); return;
		}		
		
		<%if(emp1.getCar_off_id().equals("03997")){%>
		if(fm.dlv_con_commi.value == 0){
			if(!confirm('(주)오프라이스 출고보전수당이 없습니다. 품의등록 하시겠습니까?')){	
				return;
			}
		}
		<%}%>
			
		if(fm.email_1.value != '' && fm.email_2.value != ''){
			fm.emp_email.value = fm.email_1.value+'@'+fm.email_2.value;		
		}
		
		if(<%=b_agent_commi%> == 0 && fm.agent_commi.value != '0'){
			alert('업무진행수당이 없는 건입니다.'); return;
		}
		
		set_amt();

		if(confirm('품의등록 하시겠습니까?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
			fm.action='commi_doc_i_a.jsp';		
			fm.target='d_content';			
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}							
	}		
	
	//출고보전수당 보기
	function dlv_con_commi(){
		var fm = document.form1;
		
		window.open('about:blank', "DlvConCommi", "left=0, top=0, width=500, height=600, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "DlvConCommi";				
		fm.action = '/acar/estimate_mng/view_dlv_con_commi.jsp';		
		fm.submit();	
	}	
	//실적이관권장수당 보기
	function dlv_tns_commi(){
		var fm = document.form1;
		
		window.open('about:blank', "DlvConCommi", "left=0, top=0, width=450, height=350, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "DlvConCommi";				
		fm.action = '/acar/estimate_mng/view_dlv_tns_commi.jsp';		
		fm.submit();	
	}	

	function reg_emp_proxy(){
		var fm = document.form1;		
		if(<%=b_agent_commi%> == 0){
			alert('업무진행수당이 없는 건입니다.'); return;
		}
		window.open('commi_doc_proxy_i.jsp<%=valus%>', "EmpProxy", "left=0, top=0, width=930, height=550, scrollbars=yes, status=yes, resizable=yes");				
	}
	function update_emp_proxy(){
		var fm = document.form1;		
		if(<%=b_agent_commi%> == 0){
			alert('업무진행수당이 없는 건입니다.'); return;
		}
		window.open('commi_doc_proxy_u.jsp<%=valus%>', "EmpProxy", "left=0, top=0, width=930, height=550, scrollbars=yes, status=yes, resizable=yes");				
	}
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="emp_id" 		value="<%=emp1.getEmp_id()%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="gur_size" 		value="<%=gur_size%>">  
  <input type='hidden' name="file_st" 		value="">    
  <input type='hidden' name="s_file_name1"	value="">      
  <input type='hidden' name="s_file_name2"	value="">      
  <input type='hidden' name="s_file_gubun1"	value="">      
  <input type='hidden' name="s_file_gubun2"	value="">        
  <input type="hidden" name="rent_dt" 		value="<%=base.getDlv_dt()%>">
  <input type="hidden" name="car_id" 		value="<%=car.getCar_id()%>">
  <input type="hidden" name="car_seq" 		value="<%=car.getCar_seq()%>">
  <input type="hidden" name="car_amt" 		value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">
  <input type="hidden" name="opt_amt" 		value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">
  <input type="hidden" name="col_amt" 		value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">
  <input type='hidden' name="agent_doc_st"	value="<%=a_co_bean.getDoc_st()%>">
  <input type='hidden' name="auto_set_amt"	value="Y">
  <input type='hidden' name="dir_pur_commi_yn"	value="<%=cont_etc.getDir_pur_commi_yn()%>">
  <input type='hidden' name="client_st"	value="<%=client.getClient_st()%>">
  <input type='hidden' name="dir_pur_yn"	value="<%=pur.getDir_pur_yn()%>">
  
  
<% 			int commi_car_amt = car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt();
if(AddUtil.parseInt(base.getRent_dt()) >= 20190701 ){
	commi_car_amt = commi_car_amt -car.getTax_dc_s_amt()-car.getTax_dc_v_amt();
}

                	if(AddUtil.parseInt(base.getRent_dt())<20130321){
                    		if(car.getS_dc1_yn().equals("Y")){ commi_car_amt = commi_car_amt - car.getS_dc1_amt(); }
                    		if(car.getS_dc2_yn().equals("Y")){ commi_car_amt = commi_car_amt - car.getS_dc2_amt(); }
                    		if(car.getS_dc3_yn().equals("Y")){ commi_car_amt = commi_car_amt - car.getS_dc3_amt(); }
                    	}
%>    
  <input type="hidden" name="o_1" value="<%=commi_car_amt-car.getS_dc1_amt()-car.getS_dc2_amt()-car.getS_dc3_amt()%>">
    
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;영업지원 > 계출관리 > 영업수당지급요청 > <span class=style1><span class=style5>영업수당품의</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
	    <td align='right'><a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
	</tr>
	<tr> 
        <td class=line2></td>
    </tr>	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=15%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>상호</td>
                    <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%>사업자번호</td>
                    <td width=15%>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
		        </tr>	
                <tr> 
                    <td class=title width=10%>용도구분</td>
                    <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
                    <td class=title width=10%>관리구분</td>
                    <td width=15%>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}else if(rent_way.equals("2")){%>맞춤식<%}%></td>
                    <td class=title width=10%>이용기간</td>
                    <td width=15%>&nbsp;<%=fee.getCon_mon()%>개월</td>
                    <td class=title width=10%>월대여료</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원</td>
		        </tr>	
                <tr>
                    <td class=title width=10%>납품일자</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_start_dt())%></td>
                    <td class=title width=10%>대여개시일</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
                    <td class=title width=10%>수금구분</td>
                    <td width=15%>&nbsp;<%if(cms.getCms_acc_no().equals("")){%>무통장<%}else{%>CMS<%}%></td>
                    <td class=title width=10%>세금계산서</td>
                    <td width=15%>&nbsp;
        			  <%if(cont_etc.getRec_st().equals("") && client.getEtax_not_cau().equals("")){ 	cont_etc.setRec_st("1"); }
        			    if(cont_etc.getRec_st().equals("") && !client.getEtax_not_cau().equals("")) { cont_etc.setRec_st("2"); }
        				if(cont_etc.getRec_st().equals("1")){ 	
        					out.print("전자");
        				}else{
        					out.print("종이"); 
        				}%>
        				</td>
		        </tr>	
                <tr>
                    <td class=title width=10%>제작사명</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class=title width=10%>차명</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%><%if(!cr_bean.getCar_no().equals("")){%>&nbsp;(<%=cr_bean.getCar_no()%>)<%}%></td>
                    <td class=title width=10%>배기량</td>
                    <td width=15%>&nbsp;<%=cm_bean.getDpm()%>cc</td>
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
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>선수금</td>
                    <td width=15%>
        			  &nbsp;<%String pp_st = "";
        			  	int pp_amt = fee.getGrt_amt_s()+fee.getPp_s_amt()+fee.getIfee_s_amt();
        				int jan_amt = a_db.getPpNoPayAmt(rent_mng_id, rent_l_cd, "1", "");
        				if(pp_amt == 0){
        					pp_st = "면제";
        				}else{
        					String pp_st1 = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "0");
        				  	String pp_st2 = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "1");
        				  	String pp_st3 = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "2");
        					if(pp_st1.equals("미입금") || pp_st1.equals("잔액")){ pp_st = "미결"; }
        					if(pp_st2.equals("미입금") || pp_st2.equals("잔액")){ pp_st = "미결"; }
        					if(pp_st3.equals("미입금") || pp_st3.equals("잔액")){ pp_st = "미결"; }
        					if(pp_st.equals("")){ pp_st = "완결"; }
        				}%>
        				<input type='hidden' name='pp_st' value='<%=pp_st%>'>
        				<%if(jan_amt>0){%>잔액(<%=Util.parseDecimal(jan_amt)%>원)<%}else{%><%=pp_st%><%}%>
        			</td>
                    <td class=title width=10%>완결예정일</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='pp_est_dt' maxlength='12' class="<%if(pp_st.equals("완결")||pp_st.equals("면제")){%>white<%}%>text" value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title width=10%>미결사유</td>
                    <td width=40%>&nbsp;<input type='text' name='pp_etc' size='40' value='<%=fee.getPp_etc()%>' class='<%if(pp_st.equals("완결")||pp_st.equals("면제")){%>white<%}%>text'></td>
		        </tr>	
		        <%%>
                <tr> 
                    <td class=title width=10%>보증보험</td>
                    <td width=15%>
        			  &nbsp;<%String gi_st = "";
        			  	if(gins.getGi_st().equals("0") || gins.getGi_st().equals("")){
        						gi_st = "면제";
        			  	}else{
       						if(gins.getGi_dt().equals("")){
       							gi_st = "미결";
       						}else{
       							gi_st = "완결";
       						}
       					}
        			  %>
        			  
        			  <input type='hidden' name='gi_st' value='<%=gi_st%>'>
        			  <%=gi_st%><%if(!gi_st.equals("면제")){%>(<%=Util.parseDecimal(gins.getGi_amt())%>원)<%}%></td>
                    <td class=title width=10%>완결예정일</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='gi_est_dt' maxlength='12' class="<%if(gi_st.equals("완결")||gi_st.equals("면제")){%>white<%}%>text" value='<%=AddUtil.ChangeDate2(gins.getGi_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title width=10%>미결사유</td>
                    <td width=40%>&nbsp;<input type='text' name='gi_etc' size='40' value='<%=gins.getGi_etc()%>' class='<%if(gi_st.equals("완결")||gi_st.equals("면제")){%>white<%}%>text'></td>
		        </tr>	
                <tr> 
                    <td class=title width=10%>연대보증</td>
                    <td colspan="5">&nbsp;
        			대표자 :
        			<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%>
        			입보
        			<%}else{%>
        			면제
        			<%}%>
        			 /
        			연대보증 :
        			<%if(cont_etc.getGuar_st().equals("1")){%>
        			입보 (<%=gur_size%>)명
        			<%	if(gur_size > 0){
        		  			for(int i = 0 ; i < gur_size ; i++){
        						Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
        					<%=gur.get("GUR_NM")%>&nbsp;
        					<%	}%>
        					
        			<%	}%>
        			<%}else{%>			
        			면제
        			<%}%>
        			</td>
		        </tr>		
		    </table>
	    </td>
	</tr>  	    				
	<%if(vt_size>0){%>  
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr> 
        <td class=line2></td>
    </tr>   
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr>
                  <td width=10% class=title>납품업체</td>
                  <td width="15%">&nbsp;<%=ht.get("OFF_NM")%></td>
                  <td width="25%" class=title><span class="title">작업마감요청일시</span></td>
                  <td colspan="2"><span class="title">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_EST_DT")))%></span></td>
                </tr>				
                <tr> 
                    <td rowspan="2" class=title>구분</td>
                    <td class=title>썬팅</td>
                    <td class=title>청소함</td>
                    <td width=25% class=title>네비게이션</td>
                    <td width=25% class=title>기타</td>
                </tr>
                <tr>
                  <td>&nbsp;<%=ht.get("SUN_PER")%>%
                      <%if(String.valueOf(ht.get("FILM_ST")).equals("1")){%>
                      (일반)
                      <%}%>
                      <%if(String.valueOf(ht.get("FILM_ST")).equals("2")){%>
                      (3M)
                      <%}%>
                      <%if(String.valueOf(ht.get("FILM_ST")).equals("3")){%>
                      (루마)
                      <%}%>
                      <%if(String.valueOf(ht.get("FILM_ST")).equals("") && String.valueOf(ht.get("TINT_CAU")).equals("1") && pur.getCom_tint().equals("1")){%>
                      제조사용품-<%if(pur.getCom_film_st().equals("1")){%>루마<%}else if(pur.getCom_film_st().equals("2")){%>모비스<%}%>썬팅
                      <%}%>
                  </td>
                  <td>&nbsp;
                      <%if(String.valueOf(ht.get("CLEANER_ST")).equals("1")){%>
                      기본
                      <%}%>
                      <%if(String.valueOf(ht.get("CLEANER_ST")).equals("2") && String.valueOf(ht.get("TINT_CAU")).equals("1") && pur.getCom_tint().equals("2")){%>
                      제조사용품-브랜드키트
                      <%}%>
                      <%if(!String.valueOf(ht.get("CLEANER_ADD")).equals("")){%>
                      (<%=ht.get("CLEANER_ADD")%>)
                      <%}%>
                  </td>
                  <td>&nbsp; <%=ht.get("NAVI_NM")%>
                      <%if(!String.valueOf(ht.get("NAVI_EST_AMT")).equals("") && Long.parseLong(String.valueOf(ht.get("NAVI_EST_AMT")))>0){%>
                      (예상:<%=AddUtil.parseDecimal(String.valueOf(ht.get("NAVI_EST_AMT")))%>)
                      <%}%>
                  </td>
                  <td>&nbsp;<%=ht.get("OTHER")%></td>
                </tr>
                <tr> 
                    <td class=title>견적반영용품</td>
                    <td colspan='4'><%if(car.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%> 
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>전면 썬팅
                      &nbsp;
                                      가시광선투과율 : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		          &nbsp;
                      <%if(car.getTint_ps_yn().equals("Y")){%>고급 썬팅
                      &nbsp;
                                      내용 : <%=car.getTint_ps_nm()%>, 금액 : <%=AddUtil.parseDecimal(car.getTint_ps_amt())%>원 (부가세별도)
                      <%}%>
                      <%if(car.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%>
                      &nbsp;
                      <%if(car.getTint_eb_yn().equals("Y")){%>이동형 충전기<%}%>
                      &nbsp;
                      <%if(car.getTint_bn_yn().equals("Y")){%>블랙박스 미제공 할인 (<%if(car.getTint_bn_nm().equals("1")){%>빌트인캠<%}else if(car.getTint_bn_nm().equals("2")){%>고객장착<%}else{%>빌트인캠,고객장착..<%}%>)<%}%> 
                      &nbsp;
                      <%if(car.getTint_cons_yn().equals("Y")){%>추가탁송료등
                      &nbsp;
                      <%=AddUtil.parseDecimal(car.getTint_cons_amt())%>원
                      <%}%> 
                      <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>&nbsp;신형번호판신청<%}%>
<%--                       <%if(car.getNew_license_plate().equals("1")){%>&nbsp;신형번호판신청(수도권)<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("2")){%>&nbsp;신형번호판신청(대전/대구/광주/부산)<%}%> --%>
                    </td>
                </tr>                  
                <%if(AddUtil.parseInt(String.valueOf(ht.get("REG_DT"))) < 20140801){%>
				<%if(!String.valueOf(ht.get("TOT_AMT")).equals("") && Long.parseLong(String.valueOf(ht.get("TOT_AMT")))>0){%>
                <tr>
                  <td class=title>정산금액</td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("TINT_AMT")))%>원</td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("CLEANER_AMT")))%>원</td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("NAVI_AMT")))%>원</td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%>원</td>
                </tr>
                <tr>
                  <td width=10% class=title>청구금액</td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%>원</td>
                  <td class=title><span class="title">납품일시</span></td>
                  <td colspan="2"><span class="title">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_DT")))%></span></td>
                </tr>				
				<%}%>		
				<%if(!String.valueOf(ht.get("E_AMT")).equals("") && Long.parseLong(String.valueOf(ht.get("E_AMT")))>0){%>		
                <tr>
                  <td class=title>영업사원부담분</td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("E_AMT")))%>원</td>
                  <td colspan="3">세전가감액&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("E_SUB_AMT1")))%>원 세후가감액&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("E_SUB_AMT2")))%>원</td>
                </tr>
				<%}%>
		<%}%>		
	      </table>
	    </td>
	</tr>  
	<%	}%>
	<%}else{%>
	<tr>
	    <td style='height:5'></td>
	</tr>	
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>견적반영용품</td>
                    <td width='90%' >&nbsp;
                        <%if(car.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%> 
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>전면 썬팅
                      &nbsp;
                                      가시광선투과율 : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		          &nbsp;
                      <%if(car.getTint_ps_yn().equals("Y")){%>고급 썬팅
                      &nbsp;
                                      내용 : <%=car.getTint_ps_nm()%>, 금액 : <%=AddUtil.parseDecimal(car.getTint_ps_amt())%>원 (부가세별도)
                      <%}%>
                      <%if(car.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%>
                      &nbsp;
                      <%if(car.getTint_eb_yn().equals("Y")){%>이동형 충전기<%}%>
                      &nbsp;
                      <%if(car.getTint_bn_yn().equals("Y")){%>블랙박스 미제공 할인 (<%if(car.getTint_bn_nm().equals("1")){%>빌트인캠<%}else if(car.getTint_bn_nm().equals("2")){%>고객장착<%}else{%>빌트인캠,고객장착..<%}%>)<%}%> 
                      &nbsp;
                      <%if(car.getTint_cons_yn().equals("Y")){%>추가탁송료등
                      &nbsp;
                      <%=AddUtil.parseDecimal(car.getTint_cons_amt())%>원
                      <%}%> 
                      <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>&nbsp;신형번호판신청<%}%>
<%--                       <%if(car.getNew_license_plate().equals("1")){%>&nbsp;신형번호판신청(수도권)<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("2")){%>&nbsp;신형번호판신청(대전/대구/광주/부산)<%}%> --%>
                    </td>
                </tr>
	      </table>
	    </td>
	</tr>   
	<%}%>  		
	<%if(tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y") || tint3.getTint_yn().equals("Y") || tint4.getTint_yn().equals("Y") || tint5.getTint_yn().equals("Y") || tint6.getTint_yn().equals("Y")){%>
	
	<tr>
	    <td> <span class=style2>썬팅(측후면/전면)</span></td>
	</tr>  				                 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan='2' class='title'>시공구분</td>
                    <td width='40%' >&nbsp;
                        <%if(tint1.getTint_yn().equals("Y")){%>측후면<%}%>
                        <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("Y")){%>+<%}%>
                        <%if(tint2.getTint_yn().equals("Y")){%>전면<%}%>
                        <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("N")){%>시공하지않음<%}%>
                    </td>
                    <td colspan='2' class='title'>시공업체</td>
                    <td colspan='2' width='40%'>&nbsp;
                        <%=tint1.getOff_nm()%><%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("Y")){%><%=tint2.getOff_nm()%><%}%></td>
                </tr>
                <%if(tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y")){%>
                <tr> 
                    <td rowspan='2' width='5%' class='title'>필름선택</td>
                    <td width='5%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getFilm_st().equals("2")){%>3M
        		<%}else if(tint1.getFilm_st().equals("3")){%>루마
        		<%}else if(tint1.getFilm_st().equals("5")){%>솔라가드
        		<%}else if(tint1.getFilm_st().equals("6")){%>고급
        		<%}else{%>기타(<%=tint1.getFilm_st()%>)
        		<%}%>
                    </td>
                    <td rowspan='2' width='5%' class='title'>가시광선<br>투과율</td>
                    <td width='5%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%=tint1.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getFilm_st().equals("2")){%>3M
        		<%}else if(tint2.getFilm_st().equals("3")){%>루마
        		<%}else if(tint2.getFilm_st().equals("5")){%>솔라가드
        		<%}else if(tint2.getFilm_st().equals("6")){%>고급
        		<%}else{%>기타(<%=tint2.getFilm_st()%>)
        		<%}%>                    
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=tint2.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td rowspan='2' width='5%' class='title'>비용부담</td>
                    <td width='5%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getCost_st().equals("1")){%>없음
        		<%}else if(tint1.getCost_st().equals("2")){%>고객
        		<%}else if(tint1.getCost_st().equals("4")){%>당사
        		<%}else if(tint1.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td rowspan='2' width='5%' class='title'>견적반영</td>
                    <td width='5%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint1.getEst_m_amt())%>원
        		<%}else if(tint1.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getCost_st().equals("1")){%>없음
        		<%}else if(tint2.getCost_st().equals("2")){%>고객
        		<%}else if(tint2.getCost_st().equals("4")){%>당사
        		<%}else if(tint2.getCost_st().equals("5")){%>에이전트
        		<%}%>                                           
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint2.getEst_m_amt())%>원
        		<%}else if(tint2.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' class='title'>설치일자</td>
                    <td class='title'>측후면</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint1.getSup_est_dt())%>까지 요청함</td>
                    <td rowspan='2' class='title'>설치비용</td>
                    <td class='title'>측후면</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint1.getTint_amt())%>원</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint2.getSup_est_dt())%>까지 요청함</td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint2.getTint_amt())%>원</td>
                </tr>
                <%}%>
            </table>
	</td>
    </tr>      
	<tr>
	    <td> <span class=style2>블랙박스</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>설치구분</td>
                    <td width='40%' >&nbsp;
                        <%if(tint3.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint3.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='10%' class='title'>설치업체</td>
                    <td width='40%'>&nbsp;
                        <%=tint3.getOff_nm()%></td>
                </tr>
                <%if(tint3.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>모델선택</td>
                    <td>&nbsp;
                        <%if(tint3.getModel_st().equals("1")){%>추천모델<%}%>
                        <%if(!tint3.getModel_st().equals("") && !tint3.getModel_st().equals("1")){%>기타선택모델(<%=tint3.getModel_st()%>)<%}%>                    
                    </td>
                    <td class='title'>채널선택</td>
                    <td>&nbsp;
                        <%if(tint3.getChannel_st().equals("1")){%>1채널<%}%>
                        <%if(tint3.getChannel_st().equals("2")){%>2채널<%}%>                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <%=tint3.getCom_nm()%></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <%=tint3.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint3.getCost_st().equals("1")){%>없음
        		<%}else if(tint3.getCost_st().equals("2")){%>고객(전액)
        		<%}else if(tint3.getCost_st().equals("3")){%>고객(일부)
        		<%}else if(tint3.getCost_st().equals("4")){%>당사
        		<%}else if(tint3.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint3.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint3.getEst_m_amt())%>원
        		<%}else if(tint3.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint3.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>          	
	<tr>
	    <td> <span class=style2>내비게이션</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>설치구분</td>
                    <td width='40%' >&nbsp;
                        <%if(tint4.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint4.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='10%' class='title'>설치업체</td>
                    <td width='40%'>&nbsp;
                        <%=tint4.getOff_nm()%></td>
                </tr>
                <%if(tint4.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <%=tint4.getCom_nm()%></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <%=tint4.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint4.getCost_st().equals("1")){%>없음
        		<%}else if(tint4.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint4.getCost_st().equals("4")){%>당사
        		<%}else if(tint4.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint4.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint4.getEst_m_amt())%>원
        		<%}else if(tint4.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint4.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>       	
	<tr>
	    <td> <span class=style2>기타용품</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>상품명</td>
                    <td width='40%' >&nbsp;
                        <%=tint5.getCom_nm()%>&nbsp;<%=tint5.getModel_nm()%></td>
                    <td width='10%' class='title'>설치업체</td>
                    <td width='40%'>&nbsp;
                        <%=tint5.getOff_nm()%></td>
                </tr>
                <%if(!tint5.getModel_nm().equals("")){%>
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <%=tint5.getEtc()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint5.getCost_st().equals("1")){%>없음
        		<%}else if(tint5.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint5.getCost_st().equals("4")){%>당사
        		<%}else if(tint5.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint5.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint5.getEst_m_amt())%>원
        		<%}else if(tint5.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint5.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>
    <!-- 이동형충전기(전기차) -->
    <%if(ej_bean.getJg_g_7().equals("3")){ %>
    <tr>
	    <td> <span class=style2>이동형 충전기</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>설치구분</td>
                    <td width='40%' >&nbsp;
                        <%if(tint6.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint6.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='10%' class='title'>설치업체</td>
                    <td width='40%'>&nbsp;
                        <%=tint6.getOff_nm()%></td>
                </tr>
                <%if(tint6.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <%=tint6.getCom_nm()%></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <%=tint6.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint6.getCost_st().equals("1")){%>없음
        		<%}else if(tint6.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint6.getCost_st().equals("4")){%>당사
        		<%}else if(tint6.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint6.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint6.getEst_m_amt())%>원
        		<%}else if(tint6.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint6.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>
    <%}%>		
<%}%>
	<tr>
	    <td align="right"></td>
	</tr> 
	<tr> 
        <td class=line2></td>
    </tr> 
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>             
            <td colspan='5'>&nbsp;
              <%if(String.valueOf(alink_lc_rent.get("RENT_L_CD")).equals(rent_l_cd)){%>[전자계약서]<%}%>
            </td>            
    		</tr>	                  
                <tr> 
                    <td class=title width=10%>영업구분</td>
                    <td>&nbsp;<%String pur_bus_st = pur.getPur_bus_st();%><%if(pur_bus_st.equals("1")){%>자체영업<%}else if(pur_bus_st.equals("2")){%>영업사원영업<%}else if(pur_bus_st.equals("3")){%>실적이관<%}else if(pur_bus_st.equals("4")){%>에이전트<%}%></td>
                    <td class=title width=10%>영업대리인</td>
                    <td colspan="2">&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>                    
    		</tr>	                        
                <tr> 
                    <td class=title width=10%>산출기준</td>
                    <td width=30%>&nbsp;차량가격</td>
                    <td class=title width=10%>구분</td>
                    <td class=title width=25%>규정</td>
                    <td class=title width=25%>지급</td>
    		</tr>	
                <tr> 
                    <td class=title>구입가격</td>
                    <td>&nbsp;<input type='text' size='11' name='car_ft_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt()-car.getDc_cs_amt()-car.getDc_cv_amt())%>'>원</td>			
        			<td class=title>지급율</td>		
                    <td>&nbsp;<input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum' <%if(!nm_db.getWorkAuthUser("전산팀",user_id)){%>readonly<%}%>>%</td>
                    <td>&nbsp;<input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum' <%if(!nm_db.getWorkAuthUser("전산팀",user_id)){%>readonly<%}else{%>onBlur='javascript:setCommi()'<%}%>>%</td>
    		    </tr>	
                <tr> 
                    <td class=title>산출기준가격</td>
                    <td>&nbsp;<input type='text' size='11' name='commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">원                    
                    (정상조건:<%=AddUtil.parseDecimal(commi_car_amt)%>원)
                    
                    	<%
				content_code = "LC_SCAN";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"1";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
						<br>
			    			<%	for (int j = 0 ; j < 1 ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    						<%	}%>		
    						<%}%>      						      						                    

                    </td>
        	    <td class=title>산정금액</td>		
                    <td>&nbsp;<input type='text' size='11' name='comm_rt_amt' maxlength='11' class='whitenum' value=''>원</td>
                    <td>&nbsp;<input type='text' size='11' name='comm_r_rt_amt' maxlength='11' class='whitenum' value=''>원</td>
    		</tr>	
    		    <tr>
    		    	<td class=title width=10%>출고보전수당 지급여부</td>
    		    	<td colspan="4">&nbsp;<%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>있음<%}else{%>없음<%}%>
    		    	    &nbsp;<%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>:: 특판출고(실적이관가능)<%}else if(cont_etc.getDir_pur_commi_yn().equals("N")){%>:: 특판출고(실적이관불가능)<%}else if(cont_etc.getDir_pur_commi_yn().equals("2")){%>:: 자체출고대리점출고<%}%>
    		    	</td>
    		    </tr>    		
                <tr> 
                    <td class=title width=10%>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td>&nbsp;<%=fee.getFee_cdt()%></td>
                    <td class=title width=10%>계약서 특약사항 기재 내용</td>
                    <td colspan="2">&nbsp;<%=fee_etc.getCon_etc()%></td>                    
    		</tr>	            		
    	    </table>
	</td>
    </tr>  	  	
	<tr>
	    <td class=h></td>
	<tr> 
	<tr>
	    <td align="right"><hr></td>
	<tr> 
	<tr>
	    <td class=h></td>
	<tr> 
	<tr> 
        <td class=line2></td>
    </tr>  
     
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>영업사원</td>
                    <td width=15%>&nbsp;<a href="javascript:view_emp('<%=emp1.getEmp_id()%>');"><%=emp1.getEmp_nm()%></a></td>
                    <td class=title width=10%>영업소명</td>
                    <td width=15%>&nbsp;<%=emp1.getCar_off_nm()%></td>
                    <td class=title width=10%>근로형태</td>
                    <td width=15%>&nbsp;<%if(coe_bean.getJob_st().equals("1")){%>정규직<%}else if(coe_bean.getJob_st().equals("2")){%>비정규직<%}%>
        			<%if(coe_bean.getJob_st().equals("")){%>
        			<%if(coe_bean.getCust_st().equals("2")){%>비정규직<%}else if(coe_bean.getCust_st().equals("3")){%>정규직<%}%>
        			<%}%>
        			</td>
                    <td class=title width=10%>소득구분</td>
                    <td width=15%>&nbsp;<%if(coe_bean.getCust_st().equals("2")){%>사업소득<%}else if(coe_bean.getCust_st().equals("3")){%>기타사업소득<%}%></td>
		</tr>	
		<tr>
		    <td class=title>비고</td>
		    <td colspan='7'><%=emp1.getCh_remark()%></td>
		</tr>	
	    </table>
	</td>
    </tr>  	
    <tr>
	<td>&nbsp;</td>
    <tr> 
    <%if(base.getBus_st().equals("7") && cont_etc.getBus_agnt_id().equals("")){%>			
	<%if(emp4.getEmp_id().equals("")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>대리영업</td>
                    <td>&nbsp;<a href="javascript:reg_emp_proxy()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
                    &nbsp;&nbsp;&nbsp;대리영업인이 있을 경우 선등록한후 영업담당 실수령인 및 금액을 등록해주세요.
                    </td>
                </tr>	
    		</table>
	    </td>
	</tr>  
    <tr> 
        <td class=h></td>
    </tr>	 			
	<%}else{%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>대<br>리<br>영<br>업</td>
                    <td class=title width=7%>실수령인</td>
                    <td width=15%>&nbsp;<%=emp4.getEmp_acc_nm()%></td>
                    <td class=title width=10%>관계</td>
                    <td width=15%>&nbsp;<%=emp4.getRel()%></td>
                    <td class=title width=10%>타소득</td>
                    <td width=15%>&nbsp;<%if(emp4.getRec_incom_yn().equals("1")){%>유<%}else if(emp4.getRec_incom_yn().equals("2")){%>무<%}%></td>
                    <td class=title width=10%>소득구분</td>
                    <td width=15%>&nbsp;<%if(emp4.getRec_incom_st().equals("2")){%>사업소득<%}else if(emp4.getRec_incom_st().equals("3")){%>기타사업소득<%}%></td>
		</tr>	
                <tr> 
                    <td class=title>거래은행</td>
                    <td width=15%>&nbsp;<%=emp4.getEmp_bank()%></td>
                    <td class=title width=10%>계좌번호</td>
                    <td colspan="3">&nbsp;<%=emp4.getEmp_acc_no()%></td>
                    <td class=title width=10%>생년월일</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeEnpH(emp4.getRec_ssn())%></td>
		        </tr>	
                <tr> 
                    <td class=title>주소</td>
                    <td colspan="3">&nbsp;<%=emp4.getRec_zip()%>&nbsp;<%=emp4.getRec_addr()%></td>
                    <td class=title width=10%>신분증사본</td>
                    <td width=15%>&nbsp;
                    	<%
				content_code = "COMMI";
				content_seq  = rent_mng_id+""+rent_l_cd+"4"+"1";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}%>                    	
                    
                     
                    </td>
                    <td class=title width=10%>통장사본</td>
                    <td width=15%>&nbsp;
                    	<%
				content_code = "COMMI";
				content_seq  = rent_mng_id+""+rent_l_cd+"4"+"2";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}%>                     
                       
                    </td>
		</tr>	
		</table>
	    </td>
	</tr> 
	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	<tr>
	    <td align="right"><a href="javascript:update_emp_proxy()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>				
	<%}%>
	<%}%>
    <%}%>	
    <!--영업대리 끝-->  	
	<tr> 
        <td class=line2></td>
    </tr> 
    <%if(a_co_bean.getDoc_st().equals("2")){ //에이전트-세금계산서 발행분%>
    <input type="hidden" name="rel" value="에이전트">
    <input type="hidden" name="rec_incom_yn" value="">
    <input type="hidden" name="rec_incom_st" value="">
    <input type="hidden" name="rec_ssn" value="<%=a_co_bean.getEnp_no()%>">
    <input type="hidden" name="emp_bank" value="<%=a_co_bean.getBank()%>">
    <input type="hidden" name="emp_bank_cd" value="<%=a_co_bean.getBank_cd()%>">
    <input type="hidden" name="emp_acc_no" value="<%=a_co_bean.getAcc_no()%>">
    <input type="hidden" name="emp_acc_nm" value="<%=a_co_bean.getAcc_nm()%>">
    <input type="hidden" name="t_zip" value="<%=a_co_bean.getCar_off_post()%>">
    <input type="hidden" name="t_addr" value="<%=a_co_bean.getCar_off_addr()%>">
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>영<br>업<br>담<br>당</td>
                    <td class=title width=7%>상호/성명</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getCar_off_nm()%></td>
                    <td class=title width=10%>구분</td>
                    <td width=15%>&nbsp;
                        <%if(a_co_bean.getCar_off_st().equals("3")){%>법인<%}%>
                    	<%if(a_co_bean.getCar_off_st().equals("4")){%>개인사업자<%}%>
                    </td>
                    <td class=title width=10%>사업자/주민번호</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeEnpH(a_co_bean.getEnp_no())%></td>
                    <td class=title width=10%>거래증빙</td>
                    <td width=15%>&nbsp;
        		<%if(a_co_bean.getDoc_st().equals("1")){%>원천징수<%}%>
                    	<%if(a_co_bean.getDoc_st().equals("2")){%>세금계산서<%}%>
                    </td>
		        </tr>	
                <tr> 
                    <td class=title>거래은행</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getBank()%></td>
                    <td class=title width=10%>계좌번호</td>
                    <td>&nbsp;<%=a_co_bean.getAcc_no()%></td>
                    <td class=title width=10%>예금주</td>
                    <td colspan="3">&nbsp;<%=a_co_bean.getAcc_nm()%></td>                    
		</tr>	
                <tr> 
                    <td class=title>주소</td>
                    <td colspan="7">&nbsp;<%=a_co_bean.getCar_off_post()%>
        			   &nbsp;<%=a_co_bean.getCar_off_addr()%></td>
		        </tr>	
		    </table>
	    </td>
	</tr> 
    <tr> 
        <td class=h></td>
    </tr>	 				 	 	    
    <%}else{%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>영<br>업<br>담<br>당</td>
                    <td class=title width=7%>실수령인</td>
                    <td width=15%>&nbsp;<input type='text' name="emp_acc_nm" value='<%//=emp1.getEmp_acc_nm()%>' size="12" class='text' readonly>					  					  
					<a href="javascript:search_bank_acc()"><span title="<%//=emp1.getEmp_nm()%> 영업사원의 실수령인을 조회합니다."><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></span></a>					  
		    </td>
                    <td class=title width=10%>관계</td>
                    <td width=15%>&nbsp;<input type='text' name="rel" value='<%//=emp1.getRel()%>' size="16" class='text' readonly></td>
                    <td class=title width=10%>타소득</td>
                    <td width=15%>&nbsp;
        			  <select name="rec_incom_yn">
                        <option value="">==선택==</option>
        				<option value="1">유</option>
        				<option value="2" selected>무</option>							
        			  </select>
        			</td>
                    <td class=title width=10%>소득구분</td>
                    <td width=15%>&nbsp;
        			  <select name="rec_incom_st" onChange="javascript:set_amt()">
                        <option value="">==선택==</option>
        				<option value="2" >사업소득</option>
        				<option value="3" >기타사업소득</option>							
        			  </select>
                    </td>
		        </tr>	
                <tr> 
                    <td class=title>거래은행</td>
                    <td width=15%>&nbsp;
                    	<input type='hidden' name="emp_bank" 			value="<%//=emp1.getEmp_bank()%>">
                    	<select name='emp_bank_cd'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//신규인경우 미사용은행 제외
																if(bank.getUse_yn().equals("N")){	 continue; }
        								%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                      </select></td>
                    <td class=title width=10%>계좌번호</td>
                    <td colspan="3">&nbsp;<input type='text' name="emp_acc_no" value='<%//=emp1.getEmp_acc_no()%>' size="31" class='text' readonly></td>
                    <td class=title width=10%>주민번호</td>
                    <td width=15%>&nbsp;<input type='text' name="rec_ssn" value='' size="16" class='text' readonly></td>
		        </tr>	
                <tr> 
                    <td class=title>주소</td>
                    <td colspan="3">&nbsp;<input type='text' name="t_zip" value='' size="7" class='text' readonly onClick="javascript:search_zip('')" readonly>
        			   &nbsp;<input type='text' name="t_addr" value='' size="40" class='text' style='IME-MODE: active' readonly></td>
                    <td class=title width=10%>신분증사본</td>
                    <td width=15%>&nbsp;
                        
                        
                    	<%
				content_code = "COMMI";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"1";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>   
    						<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;                                                                    
    						<%}%>                        
                    </td>
                    <td class=title width=10%>통장사본</td>
                    <td width=15%>&nbsp;
                    	<%
				content_code = "COMMI";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"2";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%> 
    						<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;                                                                                          
    						<%}%>                                           
                    </td>
		</tr>	
	    </table>
	</td>
    </tr>  	
    <tr> 
        <td>※ 실수령인 유의사항 : 영업담당자가 개인 사정으로 영업 수당을 직접 받기가 어려운 경우에 실수령인을 지정할 수 있습니다. 이때 실수령인은 영업담당자와 가족관계이거나 친인척이어야만 합니다(사전협의, 증빙첨부 필수).
따라서 영업담당자의 직장동료 등 타인은 실수령인으로 등록할 수가 없습니다.</td>
    </tr>
    <tr>
	<td style='height:18'><span class=style4>&nbsp;<font color=red>* 실수령인은 꼭 조회해서 등록하십시오. 실수령인에 조회 데이타가 없거나 내용변경이 있으면 영업관리-영업사원관리-영업사원관리에서 실수령인을 등록(수정)하십시오.</font></span> </td>
    </tr>	
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* 영업사원과 실수령인 이름이 같고 영업사원에 <b>신분증,통장 사본</b>이 있으면 별도 등록하지 않아도 등록처리시 끌어옵니다.</span> </td>
	</tr>			  	
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* 은행 : 계약관리에 입력한 정보이며, 계약관리에서 입력한 정보가 없을 때에는 영업사원에 있는 은행정보를 가져옵니다.</span> </td>
	</tr>			 
	<%}%>
	
	<%if(!emp4.getEmp_id().equals("")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업담당자</span></td>
	</tr>  		
	<%}%>	
	<tr> 
        <td class=line2></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title>구분</td>
                    <td class=title width=12%>금액</td>
                    <td class=title width=10%>세율</td>
                    <td width=3% rowspan="<%if(a_co_bean.getDoc_st().equals("2")){%>7<%}else{%>9<%}%>" class=title>가<br>감<br></td>
                    <td class=title width=12%>구분</td>
                    <td class=title width=10%>금액</td>			
                    <td class=title width=40%>적요</td>
                </tr>	
                <tr> 
                    <td width="3%" rowspan="6" class=title><%if(a_co_bean.getDoc_st().equals("2")){%>지<br>급<br>수<br>수<br>료<br><%}else{%>과<br>
                      세<br>기<br>준<br><%}%></td>
                    <td width="10%" class=title>영업수당</td>
                    <td align="center"><input type='text' name='commi' maxlength='10' value='<%=Util.parseDecimal(emp1.getCommi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;
        			  <select name="add_st1" onchange="javascript:set_amt()">
                        <option value="">==선택==</option>
        				<option value="1" <%if(emp1.getAdd_st1().equals("1"))%>selected<%%>>세전</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp1.getAdd_st1().equals("2")){%>selected<%}%>>세후</option><%}%>
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt1' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt1())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                      <input name="add_cau1" type="text" class="num" id="add_cau1" value="<%=emp1.getAdd_cau1()%>" size="50"></td>
                </tr>
                <tr>
                    <td class=title style="font-size : 8pt;">출고보전수당</td>
                    <td align="center"><input type='text' name='dlv_con_commi' id='dlv_con_commi' maxlength='8' value='<%=Util.parseDecimal(emp1.getDlv_con_commi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center">
                        <!--출고보전수당-->
                        <%//if( (cont_etc.getDlv_con_commi_yn().equals("Y") || cont_etc.getDir_pur_commi_yn().equals("Y") || cont_etc.getDir_pur_commi_yn().equals("2") || pur.getPur_bus_st().equals("2") || pur.getPur_bus_st().equals("4")) && pur.getOne_self().equals("Y") ){%>
                        <%if(cont_etc.getDlv_con_commi_yn().equals("Y") && pur.getOne_self().equals("Y")){ %>                        
                            <a href="javascript:dlv_con_commi();"><img src=/acar/images/center/button_sd_cg.gif align=absmiddle border=0 alt='출고보전수당'></a>
                        <%}%>
                    </td>
                    <td align="center">&nbsp;
        			  <select name="add_st2" onchange="javascript:set_amt()">
                        <option value="">==선택==</option>
        				<option value="1" <%if(emp1.getAdd_st2().equals("1")){%>selected<%}%>>세전</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp1.getAdd_st2().equals("2")){%>selected<%}%>>세후</option><%}%>							
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt2' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt2())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                    <input name="add_cau2" type="text" class="text" value="<%=emp1.getAdd_cau2()%>" size="50"></td>
                </tr>
                <tr>
                    <td class=title style="font-size : 8pt;">실적이관권장수당</td>
                    <td align="center"><input type='text' name='dlv_tns_commi' maxlength='8' value='<%=Util.parseDecimal(emp1.getDlv_tns_commi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center"><%if(pur.getPur_bus_st().equals("3") && (pur.getDlv_brch().equals("B2B사업운영팀") || pur.getDlv_brch().equals("특판팀") || pur.getDlv_brch().equals("법인판촉팀") || pur.getDlv_brch().equals("법인판매팀") || pur.getOne_self().equals("Y"))){%><a href="javascript:dlv_tns_commi();"><img src=/acar/images/center/button_sd_sjig.gif align=absmiddle border=0 alt='실적이관권장수당'></a><%}%></td>
                    <td align="center">&nbsp;
        			  <select name="add_st3" onchange="javascript:set_amt()">
                        <option value="">==선택==</option>
        				<option value="1" <%if(emp1.getAdd_st3().equals("1"))%>selected<%%>>세전</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp1.getAdd_st3().equals("2"))%>selected<%%>>세후</option><%}%>							
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt3' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt3())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                    <input name="add_cau3" type="text" class="text" value="<%=emp1.getAdd_cau3()%>" size="50"></td>
                </tr>        
                <tr>
                    <td class=title style="font-size : 8pt;">업무진행수당</td>
                    <td align="center"><input type='text' name='agent_commi' maxlength='8' value='<%if(!String.valueOf(alink_lc_rent.get("RENT_L_CD")).equals(rent_l_cd) && base.getBus_st().equals("7") && cont_etc.getBus_agnt_id().equals("") && emp4.getEmp_id().equals("")){%>100,000<%}%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;-</td>			
                    <td align="center">-</td>		
                    <td>&nbsp;</td>
                </tr>                                              
                <tr>
                    <td class=title>세전가감액</td>
                    <td align="center"><input type='text' name='a_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;-</td>			
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="center"><input type='text' name='b_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">-</td>			
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <%if(a_co_bean.getDoc_st().equals("2")){%>
                <tr>
                    <td colspan="2" class=title>VAT</td>
                    <td align="center"><input type='text' name='vat_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                    <td align="center"><input type='text' name='vat_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td width=3% class=title>소계</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type='text' name='add_tot_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;</td>                    
                </tr> 
                <input type="hidden" name="inc_amt" value="<%=Util.parseDecimal(emp1.getInc_amt())%>">
                <input type="hidden" name="inc_per" value="">
                <input type="hidden" name="res_amt" value="<%=Util.parseDecimal(emp1.getRes_amt())%>">
                <input type="hidden" name="res_per" value="">
                <input type="hidden" name="c_amt" value="<%=Util.parseDecimal(emp1.getTot_amt())%>">
                <input type="hidden" name="tot_per" value="">
                <input type="hidden" name="e_amt" value="">
                <%}else{%>                
                <tr>
                    <td rowspan="3" class=title>원<br>천<br>징<br>수</td>
                    <td class=title>소득세</td>
                    <td align="center"><input type='text' name='inc_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getInc_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='inc_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>지방세</td>
                    <td align="center"><input type='text' name='res_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getRes_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='res_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="center"><input type='text' name='c_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getTot_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='tot_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value);'>%</td>
                    <td width=3% class=title>소계</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type='text' name='add_tot_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2" class=title>세후가감액</td>
                    <td align="center"><input type='text' name='e_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                    <td colspan="5">&nbsp;  </td>
                </tr>
                <input type="hidden" name="vat_amt" value="<%=Util.parseDecimal(emp1.getVat_amt())%>">
                <input type="hidden" name="vat_per" value="">
                <%}%>
                <tr>
                  <td colspan="2" class=title>실지급액</td>
                  <td align="center"><input type='text' name='d_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td colspan="5">&nbsp;실지급액  = 과세기준액 -  원천징수세액 + 세후가감액</td>
                </tr>	
		    </table>
	    </td>
	</tr>  
	<%if(!emp4.getEmp_id().equals("")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대리영업</span></td>
	</tr>  		
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title>구분</td>
                    <td class=title width=12%>금액</td>
                    <td class=title width=10%>세율</td>
                    <td width=3% rowspan="<%if(emp4.getInc_amt()==0 && emp4.getVat_amt()>0){%>4<%}else{%>6<%}%>" class=title>가<br>감<br></td>
                    <td class=title width=12%>구분</td>
                    <td class=title width=10%>금액</td>			
                    <td class=title width=40%>적요</td>
                </tr>	
                <%
                	int tot_add1 = 0;
                	int tot_add2 = 0;
                	
                	if(emp4.getAdd_st1().equals("1")){ tot_add1 = tot_add1+emp4.getAdd_amt1(); }
                	if(emp4.getAdd_st2().equals("1")){ tot_add1 = tot_add1+emp4.getAdd_amt2(); }
                	if(emp4.getAdd_st3().equals("1")){ tot_add1 = tot_add1+emp4.getAdd_amt3(); }
                	if(emp4.getAdd_st1().equals("2")){ tot_add2 = tot_add2+emp4.getAdd_amt1(); }
                	if(emp4.getAdd_st2().equals("2")){ tot_add2 = tot_add2+emp4.getAdd_amt2(); }
                	if(emp4.getAdd_st3().equals("2")){ tot_add2 = tot_add2+emp4.getAdd_amt3(); }
                %>
                <tr> 
                    <td width="3%" rowspan="3" class=title>과<br>
                      세<br>기<br>준<br></td>
                    <td width="10%" class=title>영업대리수당</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getCommi())%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;<%if(emp4.getAdd_st1().equals("1")){%>세전<%}%>
        				<%if(emp4.getAdd_st1().equals("2")){%>세후<%}%>
        	    </td>			
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt1())%></td>
                    <td>&nbsp;<%=emp4.getAdd_cau1()%></td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">세전가감액</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(tot_add1)%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;<%if(emp4.getAdd_st2().equals("1")){%>세전<%}%>
        				<%if(emp4.getAdd_st2().equals("2")){%>세후<%}%></td>			
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt2())%></td>
                    <td>&nbsp;<%=emp4.getAdd_cau2()%></td>

                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">소계</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getCommi()+emp4.getAdd_amt1()+emp4.getAdd_amt2()+emp4.getAdd_amt3())%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;<%if(emp4.getAdd_st3().equals("1")){%>세전<%}%>
        				<%if(emp4.getAdd_st3().equals("2")){%>세후<%}%></td>			
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt3())%></td>
                    <td>&nbsp;<%=emp4.getAdd_cau3()%></td>
                </tr>                
                <%if(emp4.getInc_amt()==0 && emp4.getVat_amt()>0){ // 영업대리도 부가세인 경우%>
                <tr>
                    <td class=title>부가세</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getVat_amt())%></td>
                    <td align="center">&nbsp;<%=emp4.getVat_per()%>%</td>
                    <td width=3% class=title>소계</td>
                    <td>&nbsp;</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt1()+emp4.getAdd_amt2()+emp4.getAdd_amt3())%></td>
                    <td>&nbsp;</td>
                </tr>                
                <%}else{%>
                <tr>
                    <td rowspan="3" class=title>원<br>천<br>징<br>수</td>
                    <td class=title>소득세</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getInc_amt())%></td>
                    <td align="center">&nbsp;<%=emp4.getInc_per()%>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>지방세</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getRes_amt())%></td>
                    <td align="center">&nbsp;<%=emp4.getRes_per()%>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getTot_amt())%></td>
                    <td align="center">&nbsp;<%=emp4.getTot_per()%>%</td>
                    <td width=3% class=title>소계</td>
                    <td>&nbsp;</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt1()+emp4.getAdd_amt2()+emp4.getAdd_amt3())%></td>
                    <td>&nbsp;</td>
                </tr>
                <%}%>
                <tr>
                    <td colspan="2" class=title>세후가감액</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(tot_add2)%></td>
                    <td colspan="5">&nbsp;  </td>
                </tr>
                <tr>
                  <td colspan="2" class=title>실지급액</td>
                  <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getCommi()+tot_add1-emp4.getTot_amt()+tot_add2)%></td>
                  <td colspan="5">&nbsp;실지급액  = 과세기준액 -  원천징수세액 + 세후가감액</td>
                </tr>	
		    </table>
	    </td>
	</tr>  
	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	<tr>
	    <td align="right"><a href="javascript:update_emp_proxy()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>				
	<%}%>
	<%}%>
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* 가감 : 영업수당외에 추가로 지급되는 것 또는 공제해야 되는 것에 대한 내용입니다.</span> </td>
	</tr>			  	
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* 출고보전수당 : 현대특판이면서 영업사원-영업담당 영업구분이 영업사원영업인 경우 지급</span> </td>
	</tr>			  	
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* 실적이관권장수당 : 현대특판이면서 영업사원-영업담당 영업구분이 실적이관인 경우 지급</span> </td>
	</tr>			  	
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>안내메일</td>
                    <td>&nbsp;
					<%	String email_1 = "";
						String email_2 = "";
						if(!coe_bean.getEmp_email().equals("")){
							int mail_len = coe_bean.getEmp_email().indexOf("@");
							if(mail_len > 0){
								email_1 = coe_bean.getEmp_email().substring(0,mail_len);
								email_2 = coe_bean.getEmp_email().substring(mail_len+1);
							}
						}
					%>						  
        			  메일주소 : 
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
					  		    <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
								  <option value="" selected>선택하세요</option>
								  <option value="hanmail.net">hanmail.net</option>
								  <option value="naver.com">naver.com</option>
								  <option value="nate.com">nate.com</option>
								  <option value="bill36524.com">bill36524.com</option>
								  <option value="gmail.com">gmail.com</option>
								  <option value="paran.com">paran.com</option>
								  <option value="yahoo.com">yahoo.com</option>
								  <option value="korea.com">korea.com</option>
								  <option value="hotmail.com">hotmail.com</option>
								  <option value="chol.com">chol.com</option>
								  <option value="daum.net">daum.net</option>
								  <option value="hanafos.com">hanafos.com</option>
								  <option value="lycos.co.kr">lycos.co.kr</option>
								  <option value="dreamwiz.com">dreamwiz.com</option>
								  <option value="unitel.co.kr">unitel.co.kr</option>
								  <option value="freechal.com">freechal.com</option>
								  <option value="">직접 입력</option>
							    </select>
						        <input type='hidden' name='emp_email' value='<%=coe_bean.getEmp_email()%>'>
        			  휴 대 폰 : <input type='text' name='emp_m_tel' size='15' value='<%=coe_bean.getEmp_m_tel()%>' class='text'>&nbsp;        			  
        			</td>
                </tr>	
    		</table>
	    </td>
	</tr>  
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* 출금이 완료된 후에 위의 정보로 영업수당안내메일과 문자가 발송됩니다.</span> </td>
	</tr>	
	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>	  	
    <tr>
	    <td align='center'>
	    <%if(doc_no.equals("") || rent_l_cd.equals("S114HHLR00099")){%><a id="submitLink" href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a><%}%>
	    </td>
	</tr>	
	<%}%>
	<tr>
	    <td align="center">&nbsp;</td>
	<tr>  		
	<%if(commi_size > 0){%>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
	<td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
                    <td class=title width=4%>연번</td>
                    <td class=title width=10%>계약번호</td>
                    <td class=title width=15%>고객</td>
                    <td class=title width=8%>지급일자</td>			
                    <td class=title width=8%>기준차가</td>
                    <td class=title width=5%>수당율</td>
                    <td class=title width=8%>영업수당</td>
                    <td class=title width=7%>가감금액</td>
                    <td class=title width=7%>소득세</td>
                    <td class=title width=6%>주민세</td>
                    <td class=title width=7%>부가세</td>
                    <td class=title width=5%>세율</td>
                    <td class=title width=10%>실지급액</td>																								
		</tr>		
                <%for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);
				int car_commi_amt= AddUtil.parseInt(String.valueOf(commi.get("COMMI_CAR_AMT")));
				int commi_amt	= AddUtil.parseInt(String.valueOf(commi.get("COMMI")));
				int add_amt 	= AddUtil.parseInt(String.valueOf(commi.get("ADD_AMT1")))+AddUtil.parseInt(String.valueOf(commi.get("ADD_AMT2")))+AddUtil.parseInt(String.valueOf(commi.get("ADD_AMT3")));
				int tot_amt 	= AddUtil.parseInt(String.valueOf(commi.get("TOT_AMT")));
				int inc_amt 	= AddUtil.parseInt(String.valueOf(commi.get("INC_AMT")));
				int res_amt 	= AddUtil.parseInt(String.valueOf(commi.get("RES_AMT")));
				int vat_amt 	= AddUtil.parseInt(String.valueOf(commi.get("VAT_AMT")));
				int dif_amt 	= AddUtil.parseInt(String.valueOf(commi.get("DIF_AMT")));
				String tax_per	= String.valueOf(commi.get("TOT_PER"));
				if(tax_per.equals("")){
					tax_per	= AddUtil.parseFloatCipher2((float)tot_amt/(commi_amt+add_amt)*100,1);
					if(tax_per.equals("3.2")){ tax_per = "3.3"; }
					if(tax_per.equals("5.4")){ tax_per = "5.5"; }
				}
				%>
                <tr> 
                    <td align='center'><%=commi_size-i%></td>
                    <td align='center'><%=commi.get("RENT_L_CD")%></td>
                    <td align='center'><span title='<%=commi.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(commi.get("FIRM_NM")), 5)%></span></td>
                    <td align='center'><%=commi.get("SUP_DT")%></td>			
                    <td align='right'><%=Util.parseDecimal(car_commi_amt)%>&nbsp;</td>		
                    <td align='center'><%=commi.get("COMM_R_RT")%>%</td>
                    <td align='right'><%=Util.parseDecimal(commi_amt)%>&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(add_amt)%>&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(inc_amt)%>&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(res_amt)%>&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(vat_amt)%>&nbsp;</td>
                    <td align='center'><%=tax_per%>%</td>
                    <td align='right'><%=Util.parseDecimal(dif_amt)%>&nbsp;</td>																				
                </tr>
                <%}%>
            </table>
	    </td>
	<tr>  	
	<%}%>
    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>		
</table>
</form>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	<%if(coe_bean.getCust_st().equals("")){%>
		fm.rec_incom_st.value = '2';
	<%}%>
	//set_amt(fm.commi);


	fm.comm_rt_amt.value 	= parseDecimal(th_round(toInt(parseDigit(fm.commi_car_amt.value))*toFloat(fm.comm_rt.value)/100));
	fm.comm_r_rt_amt.value 	= parseDecimal(th_round(toInt(parseDigit(fm.commi_car_amt.value))*toFloat(fm.comm_r_rt.value)/100));
	fm.commi.value 		= fm.comm_r_rt_amt.value;
	
	
	<%if(a_co_bean.getDoc_st().equals("2")){%>
	set_amt();
	<%}%>
	
	//바로가기
	var s_fm = parent.top_menu.document.form1;
	s_fm.auth_rw.value 		= fm.auth_rw.value;
	s_fm.user_id.value 		= fm.user_id.value;
	s_fm.br_id.value 		= fm.br_id.value;		
	s_fm.m_id.value 		= fm.rent_mng_id.value;
	s_fm.l_cd.value 		= fm.rent_l_cd.value;	
	s_fm.c_id.value 		= "<%=base.getCar_mng_id()%>";
	s_fm.client_id.value 	= "<%=base.getClient_id()%>";	
	s_fm.accid_id.value 	= "";
	s_fm.serv_id.value 		= "";
	s_fm.seq_no.value 		= "";			
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

