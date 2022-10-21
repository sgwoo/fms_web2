<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.fee.*, card.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	if(rent_st.equals("")) rent_st = "1";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
		
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
		
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//월렌트정보
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//신용카드 자동출금
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
	
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	//계약담당자
	CarMgrBean mgr1 = a_db.getCarMgr(rent_mng_id, rent_l_cd, "차량이용자");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	UsersBean busid_bean 	= umd.getUsersBean(base.getBus_id());
	
	
	
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//운전자격검증결과
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;	
	
	String scan_chk = "";
	int scan_cnt = 0;
	
 	String file_rent_st = "1";
 	String file_st = "2";   
 	String content_code = "LC_SCAN";             
  String content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;

	
	if(!client.getClient_st().equals("2")){
		//사업자등록증 없거나 PDF인 경우
	
				
		attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
    attach_vt_size = attach_vt.size();
    
		if(attach_vt_size > 0){
			for (int j = 0 ; j < attach_vt_size ; j++){
 				Hashtable ht = (Hashtable)attach_vt.elementAt(j);
 				if(String.valueOf(ht.get("FILE_TYPE")).length() > 5 && String.valueOf(ht.get("FILE_TYPE")).substring(0,5).equals("image")){
 						scan_cnt++;
 				}
 			}
 			if(scan_cnt == 0) scan_chk = "Y";
 		}
 		
	}
	
	int user_idx = 0;

	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
		
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
	//사업자등록번호 체크
	function CheckBizNo() {	
		var fm = document.form1;
		<%if(!client.getClient_st().equals("2")){%>
		var strNumb1 = fm.enp_no1.value;
    var strNumb2 = fm.enp_no2.value;
    var strNumb3 = fm.enp_no3.value;
    var strNumb = strNumb1+strNumb2+strNumb3;
    if (strNumb.length != 10) {
        alert("사업자등록번호가 잘못되었습니다.");
        return ;
    }    
    sumMod  =   0;
    sumMod  +=  parseInt(strNumb.substring(0,1));
    sumMod  +=  parseInt(strNumb.substring(1,2)) * 3 % 10;
    sumMod  +=  parseInt(strNumb.substring(2,3)) * 7 % 10;
	  sumMod  +=  parseInt(strNumb.substring(3,4)) * 1 % 10;
    sumMod  +=  parseInt(strNumb.substring(4,5)) * 3 % 10;
    sumMod  +=  parseInt(strNumb.substring(5,6)) * 7 % 10;
    sumMod  +=  parseInt(strNumb.substring(6,7)) * 1 % 10;
    sumMod  +=  parseInt(strNumb.substring(7,8)) * 3 % 10;
    sumMod  +=  Math.floor(parseInt(strNumb.substring(8,9)) * 5 / 10);
    sumMod  +=  parseInt(strNumb.substring(8,9)) * 5 % 10;
    sumMod  +=  parseInt(strNumb.substring(9,10));
    if (sumMod % 10  !=  0) {
    	alert("잘못된 사업자 등록번호 입니다.");
			fm.enp_no1.value = '';
			fm.enp_no2.value = '';
			fm.enp_no3.value = '';
      return ;
    }
    alert("올바른 사업자 등록번호 입니다.");
  	return ;
		<%}%>
	}
	
	
	//법인번호 체크
	function Biz_ck(){
		var fm = document.form1;
		<%if(client.getClient_st().equals("1") || client.getClient_st().equals("2")){%>
		var strBiz1 = fm.ssn1.value;
    var strBiz2 = fm.ssn2.value;
    var str_len ;
    var str_no = strBiz1+strBiz2;
    str_len = str_no.length;
		if(fm.client_st.value == '1'){
			if(str_len == 13 ){
	      no_ck = str_no.substring(0, 1) * 1;
	      no_ck = no_ck + str_no.substring( 1, 2) * 2;
	      no_ck = no_ck + str_no.substring( 2, 3) * 1;
	      no_ck = no_ck + str_no.substring( 3, 4) * 2;
	      no_ck = no_ck + str_no.substring( 4, 5) * 1;
	      no_ck = no_ck + str_no.substring( 5, 6) * 2;
	      no_ck = no_ck + str_no.substring( 6, 7) * 1;
	      no_ck = no_ck + str_no.substring( 7, 8) * 2;
	      no_ck = no_ck + str_no.substring( 8, 9) * 1;
	      no_ck = no_ck + str_no.substring( 9, 10) * 2;
	      no_ck = no_ck + str_no.substring( 10, 11) * 1;
	      no_list = no_ck + str_no.substring( 11, 12) * 2;
	      no_ck_no = no_list / 10;
	      ck_no = "'"+no_ck_no+"'";
	      namuji = ck_no.substring(3,4);
	      no = 10 - namuji; 
	      if (no > 9 ){
	        no = 0;
	      }
	      if (no == str_no.substring(12, 13)){
	        alert ("올바른 법인번호입니다.");
	      }else{
	        alert ("잘못된 법인번호입니다.");
	      }
			}else{
				alert( "법인번호를 정확히 입력해 주시기 바랍니다.");
			}
    }else if ( fm.client_st.value == '2' && fm.nationality.value !='2' && fm.nationality.value !='6') {
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
			}else{
				alert('올바른 주민등록 번호입니다.');
			}
		}
		<%}%>
	}	
	
	//관계자 조회
	function search_mgr(idx){if(document.form1.client_id.value==""){alert("고객을 먼저 선택하십시오.");return;}window.open("search_mgr.jsp?car_st=4&idx="+idx+"&client_id="+document.form1.client_id.value,"MGR","left=100,top=100,height=500,width=800,scrollbars=yes,status=yes");}
	
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}
	
	//대여기간 셋팅
	function set_cont_date(){
		var fm = document.form1;
					
		fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value);
		
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;

		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
			
		fm.action='get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
	}
	
	//불량고객 
	function view_badcust()
	{
		var fm = document.form1;	
		
		window.open("about:blank", "BAD_CUST_LIST", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=1400px, height=900px");
		fm.target="BAD_CUST_LIST";
		fm.action = "/acar/bad_cust/stat_badcust_list.jsp"; 
		fm.submit();
		return;
	}			
	
	
	//수정
	function update(){
		var fm = document.form1;
		
		
		if(fm.badcust_chk.value == ''){
			//alert('불량고객 확인을 하십시오.'); 	return;			
		}		
		
		if(fm.est_area.value == '')	{ alert('차량이용지역(시/도)을 확인하십시오.'); 	return;}
		if(fm.county.value == '')		{ alert('차량이용지역(구/군)을 확인하십시오.'); 	return;}
		if(fm.est_area.value == '시/도'){ alert('차량이용지역(시/도)을 확인하십시오.'); 	return;}
		if(fm.county.value == '구/군'){ alert('차량이용지역(구/군)을 확인하십시오.'); 	return;}
		
		
		if(fm.firm_nm.value == ''){					alert('상호를 입력하십시오');					return;	}
		if(fm.client_nm.value == ''){				alert('대표자를 입력하십시오');				return;	}
		
		<%if(client.getClient_st().equals("2")){%>
			if(fm.ssn1.value == '')				{	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '')				{	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '*')			{	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '1')			{	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '2')			{	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '3')			{	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '4')			{	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '*******'){	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '1******'){	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '2******'){	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '3******'){	alert('주민등록번호를 입력하십시오');			return;	}
			if(fm.ssn2.value == '4******'){	alert('주민등록번호를 입력하십시오');			return;	}
			if((!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) || ((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{	alert('주민등록번호를 확인하십시오');	return;	}
			
			Biz_ck();
			
			if(fm.nationality.value == ''){ alert('국적을 입력하십시오.'); 				fm.nationality.focus(); 		return; }
			
		<%}else{%>
			
			if(fm.enp_no1.value == '')		{	alert('사업자등록번호를 입력하십시오');			return;	}
			if(fm.enp_no2.value == '')		{	alert('사업자등록번호를 입력하십시오');			return;	}
			if(fm.enp_no3.value == '')		{	alert('사업자등록번호를 입력하십시오');			return;	}
			if((!isNum(fm.enp_no1.value)) || (!isNum(fm.enp_no2.value)) || (!isNum(fm.enp_no3.value))|| ((fm.enp_no1.value.length != 3)&&(fm.enp_no1.value.length != 0)) || ((fm.enp_no2.value.length != 2)&&(fm.enp_no2.value.length != 0)) || ((fm.enp_no3.value.length != 5)&&(fm.enp_no3.value.length != 0)))	{	alert('사업자등록번호를 확인하십시오');	return;	}
			
			CheckBizNo();

		<%	if(client.getClient_st().equals("1")){%>		
			if(fm.ssn1.value == '')			{	alert('법인번호/생년월일를 입력하십시오');		return;	}
			if((!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) )	{	alert('법인등록번호를 확인하십시오');	return;	}
			
			Biz_ck();
			
		<%	}else{%>
			if(fm.ssn1.value == '')			{	alert('생년월일를 입력하십시오');		return;	}
		<%	}%>		
		<%}%>
		
		if(fm.t_addr.value == ''){ alert('주소를 입력하십시오.'); 				fm.t_addr.focus(); 		return; }
		if(fm.mgr_addr[0].value == ''){ alert('차량이용자의 주소를 입력하십시오.'); 				fm.mgr_addr[0].focus(); 		return; }
		
		//월렌트는 차량운전자의 운전면허번호 필수
		if(fm.lic_no.value == '' && fm.mgr_lic_no[0].value == ''){
			alert('계약자 혹은 차량이용자의 운전면허번호를 입력하십시오.');
			return;
		}
		if(fm.lic_no.value != '' && fm.lic_no.value.length < 12){
			alert('계약자 운전면허번호를 정확히 입력하십시오.');
			return;
		}
		if(fm.mgr_lic_no[0].value != '' && fm.mgr_lic_no[0].value.length < 12){
			alert('차량이용자 운전면허번호를 정확히 입력하십시오.');
			return;
		}
		
		if(fm.test_lic_emp.value == '' || fm.test_lic_rel.value == '' || fm.test_lic_result.value == ''){
			alert('운전면허정보검증 대상자정보 및 검증결과를 입력하십시오.');
			return;
		}
		if(fm.test_lic_result.value != '1'){
			alert('운전자격 없는 자에게 차량을 대여할 수 없습니다. 운전자격 검증결과를 확인해주세요.');
			return;
		}		
		//추가운전자 있으면 검증필수
		if(fm.mgr_nm[1].value == '추가운전자' && fm.mgr_lic_no[1].value != ''){	
			if(fm.test_lic_result2.value == ''){
				alert('추가운전자 운전면허정보검증 대상자정보 및 검증결과를 입력하십시오.');
				return;
			}
			if(fm.test_lic_result2.value != '1'){
				alert('추가운전자 운전자격 없는 자에게 차량을 대여할 수 없습니다. 운전자격 검증결과를 확인해주세요.');
				return;
			}			
		}

		
		if(fm.cms_acc_no.value != '')		{ 
			fm.cms_acc_no.value = replaceString(" ","",fm.cms_acc_no.value);
			if ( !checkInputNumber("CMS 계좌번호", fm.cms_acc_no.value) ) {		
				fm.cms_acc_no.focus(); 		return; 
			}
			//휴대폰,연락처 동일여부 확인
			if(replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getM_tel()%>") || replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getO_tel()%>")){
				alert("계좌번호가 휴대폰 혹은 연락처와 같습니다. 평생계좌번호는 자동이체가 안됩니다.");
				fm.cms_acc_no.focus(); 		return; 
			}
		}
		if(fm.c_cms_acc_no.value != '')		{ 
			fm.c_cms_acc_no.value = replaceString(" ","",fm.c_cms_acc_no.value);
			if ( !checkInputNumber("카드번호", fm.c_cms_acc_no.value) ) {		
				fm.c_cms_acc_no.focus(); 		return; 
			}
		}
		

				
		<%if(client.getClient_st().equals("1") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){%>	
		if(fm.com_emp_yn.value == '')		{ alert('보험사항-임직원운전한정특약 가입여부를 확인하십시오.');		fm.com_emp_yn.focus(); 		return; }
		if(fm.com_emp_yn.value == 'N')	{ alert('보험사항-임직원운전한정특약 미가입으로 되어 있습니다. 확인하십시오.'); }
		<%}%>
		
		<%if(busid_bean.getLoan_st().equals("1")){%>
		if(fm.mng_type[0].checked == false && fm.mng_type[1].checked == false){		
			alert('영업담당자 배정방식을 선택하십시오.'); return;			
		}
		<%}%>		
		

		
		if(confirm('월렌트 차량예약과 연동한 계약을 승인하시겠습니까?')){	
			fm.action='lc_rm_conform_a.jsp';
			fm.target='i_no';
			//fm.target = '_blank';			
			fm.submit();
		}
	}
	
	function set_loc(loc_num, st){
		var fm = document.form1;	
		var loc_nm = '';
		
		if(loc_num == '1')		loc_nm = '영남주차장';
		else if(loc_num == '2')		loc_nm = '대전지점 주차장';
		else if(loc_num == '3')		loc_nm = '부산지점 주차장';
		else if(loc_num == '4')		loc_nm = '광주지점 주차장';
		else if(loc_num == '5')		loc_nm = '대구지점 주차장';
						
		if(loc_nm != ''){
			if(st == 'deli')		fm.deli_loc.value = loc_nm;
			else if(st == 'ret')		fm.ret_loc.value = loc_nm;
		}
	}

	//수신메일주소 셋팅
	function mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.s_mail_addr.options[fm.s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split = i_mail_addr.split("||");
			fm.s_mgr_nm.value 		= i_mail_addr_split[0];
			fm.s_mgr_email.value 	= i_mail_addr_split[1];
			fm.s_mgr_m_tel.value 	= i_mail_addr_split[2];
		}else{
			fm.s_mgr_nm.value 		= '';
			fm.s_mgr_email.value 	= '';
			fm.s_mgr_m_tel.value 	= '';
		}
	}	
	
	//이메일주소 점검
	function isEmail(str) {
		// regular expression? 지원 여부 점검
		var supported = 0;
		if (window.RegExp) {
			var tempStr = "a";
			var tempReg = new RegExp(tempStr);
			if (tempReg.test(tempStr)) supported = 1;
		}
		if (!supported) return (str.indexOf(".") > 2) && (str.indexOf("@") > 0);
		var r1 = new RegExp("(@.*@)|(\\.\\.)|(@\\.)|(^\\.)");
		var r2 = new RegExp("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$");
		return (!r1.test(str) && r2.test(str));
	}	
	
	//스캔등록
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st, "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
	}	
	
	//거래처 연체금액
	function view_dlyamt(client_id)
	{
		window.open('/acar/account/stat_settle_sc_in_view_sub_list_client.jsp?client_id='+client_id, "CLIENT_DLVAMT", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
	}	
	
//-->
</script> 
<script language='javascript'>
<!--
     	var cnt = new Array();
     	cnt[0] = new Array('구/군');
		 	cnt[1] = new Array('구/군','강남구','강동구','강북구','강서구','관악구','광진구','구로구','금천구','노원구','도봉구','동대문구','동작구','마포구','서대문구','서초구','성동구','성북구','송파구','양천구','영등포구','용산구','은평구','종로구','중구','중랑구');
		 	cnt[2] = new Array('구/군','강서구','금정구','남구','동구','동래구','부산진구','북구','사상구','사하구','서구','수영구','연제구','영도구','중구','해운대구','기장군');
		 	cnt[3] = new Array('구/군','남구','달서구','동구','북구','서구','수성구','중구','달성군');
		 	cnt[4] = new Array('구/군','계양구','남구','남동구','동구','미추홀구','부평구','서구','연수구','중구','강화군','옹진군');
		 	cnt[5] = new Array('구/군','광산구','남구','동구','북구','서구');
		 	cnt[6] = new Array('구/군','대덕구','동구','서구','유성구','중구');
		 	cnt[7] = new Array('구/군','남구','동구','북구','중구','울주군');
		 	cnt[8] = new Array('구/군','세종특별자치시');
		 	cnt[9] = new Array('구/군','고양시','과천시','광명시','구리시','군포시','남양주시','동두천시','부천시','성남시','수원시','시흥시','안산시','안양시','오산시','의왕시','의정부시','평택시','하남시','가평군','광주시','김포시','안성시','양주시','양평군','여주군','연천군','용인시','이천시','파주시','포천시','화성시');
		 	cnt[10] = new Array('구/군','강릉시','동해시','삼척시','속초시','원주시','춘천시','태백시','고성군','양구군','양양군','영월군','인제군','정선군','철원군','평창군','홍천군','화천군','횡성군');
		 	cnt[11] = new Array('구/군','제천시','청주시','충주시','괴산군','단양군','보은군','영동군','옥천군','음성군','진천군','청원군','증평군');
		 	cnt[12] = new Array('구/군','공주시','계룡시','보령시','서산시','아산시','천안시','금산군','논산군','당진군','부여군','서천군','연기군','예산군','청양군','태안군','홍성군');
		 	cnt[13] = new Array('구/군','군산시','김제시','남원시','익산시','전주시','정읍시','고창군','무주군','부안군','순창군','완주군','임실군','장수군','진안군');
		 	cnt[14] = new Array('구/군','광양시','나주시','목포시','순천시','여수시','여천시','강진군','고흥군','곡성군','구례군','담양군','무안군','보성군','신안군','여천군','영광군','영암군','완도군','장성군','장흥군','진도군','함평군','해남군','화순군');
		 	cnt[15] = new Array('구/군','경산시','경주시','구미시','김천시','문경시','상주시','안동시','영주시','영천시','포항시','고령군','군위군','봉화군','성주군','영덕군','영양군','예천군','울릉군','울진군','의성군','청도군','청송군','칠곡군');
		 	cnt[16] = new Array('구/군','거제시','김해시','마산시','밀양시','사천시','울산시','진주시','진해시','창원시','통영시','거창군','고성군','남해군','산청군','양산시','의령군','창녕군','하동군','함안군','함양군','합천군');
		 	cnt[17] = new Array('구/군','서귀포시','제주시','남제주군','북제주군');

     	function county_change(add) {
     		var sel=document.form1.county
       		/* 옵션메뉴삭제 */
       		for (i=sel.length-1; i>=0; i--){
        		sel.options[i] = null
        	}
       		/* 옵션박스추가 */
       		for (i=0; i < cnt[add].length;i++){
        		sel.options[i] = new Option(cnt[add][i], cnt[add][i]);
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
<form action='lc_rm_conform_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='cng_item'	 		value='<%=cng_item%>'>     
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_st"			value="<%=base.getCar_st()%>">  
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name='client_id' 		value="<%=base.getClient_id()%>">
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">      
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="idx"			value="">  
  <input type='hidden' name="scan_cnt"			value="">    
  <input type='hidden' name="chk_cnt"			value="">    
  <input type='hidden' name="est_from"			value="lc_c_u">      
  <input type='hidden' name="fee_rent_st"		value="">        
  <input type='hidden' name="car_no" 			value="<%=cr_bean.getCar_no()%>">      
  <input type='hidden' name="c_firm_nm" 		value="<%=client.getFirm_nm()%>">      
  <input type='hidden' name="c_client_nm" 		value="<%=client.getClient_nm()%>">      
  <input type='hidden' name="c_h_tel" 		value="<%=AddUtil.phoneFormat(client.getH_tel())%>">
  <input type='hidden' name="c_o_tel" 		value="<%=AddUtil.phoneFormat(client.getO_tel())%>">
  <input type='hidden' name="c_m_tel" 		value="<%=AddUtil.phoneFormat(client.getM_tel())%>">
  <input type='hidden' name="c_fax" 		  value="<%=AddUtil.phoneFormat(client.getFax())%>">
  <input type='hidden' name="c_con_agnt_o_tel" value="<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%>">
  <input type='hidden' name="c_con_agnt_m_tel" value="<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%>">
  <input type='hidden' name="c_con_agnt_fax" value="<%=AddUtil.phoneFormat(client.getCon_agnt_fax())%>">
<input type='hidden' name='badcust_chk_from' value='lc_rm_conform.jsp'>
   
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약승인하기</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td><font color=red>※ 월렌트 차량예약 연동계약 승인하기</font>
        	&nbsp;&nbsp;&nbsp;
        	<input type="button" class="button" id="bad_cust" value='채권보기' onclick="javascript:view_dlyamt('<%=client.getClient_id()%>');">
        	&nbsp;&nbsp;&nbsp;
        	&nbsp;&nbsp;&nbsp;
            <font color=red>※ 불량고객 확인하기</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='고객확인' onclick="javascript:view_badcust();">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">        	
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
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>상호</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>차명<%}else{%>차량번호<%}%></td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                </tr>
                <tr> 
                    <td class=title width=13%>최초영업자</td>
                    <td>&nbsp;<input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(base.getBus_id(), "USER")%>" size="12"> 
			                  <input type="hidden" name="bus_id" value="<%=base.getBus_id()%>">			                  
			                  <% user_idx++;%>	
			              </td>
                    <td class=title width=10%>영업대리인</td>
                    <td colspan='3'>&nbsp;<input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getBus_agnt_id(), "USER")%>" size="12"> 
			                  <input type="hidden" name="bus_agnt_id" value="<%=cont_etc.getBus_agnt_id()%>">
			                  <a href="javascript:User_search('bus_agnt_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			                  <% user_idx++;%>
			              </td>
        			</td>
                </tr>
                <tr> 
                    <td class=title width=13%>차량이용지역</td>
                    <td colspan='5'>&nbsp;	
								<select name='est_area' onchange="county_change(this.selectedIndex);">
								   <option value=''>시/도</option>
								   <option value='서울'>서울특별시</option>
								   <option value='부산'>부산광역시</option>
								   <option value='대구'>대구광역시</option>
								   <option value='인천'>인천광역시</option>
								   <option value='광주'>광주광역시</option>
								   <option value='대전'>대전광역시</option>
								   <option value='울산'>울산광역시</option>
								   <option value='세종'>세종특별자치시</option>
								   <option value='경기'>경기도</option>
								   <option value='강원'>강원도</option>
								   <option value='충북'>충청북도</option>
								   <option value='충남'>충청남도</option>
								   <option value='전북'>전라북도</option>
								   <option value='전남'>전라남도</option>
								   <option value='경북'>경상북도</option>
								   <option value='경남'>경상남도</option>
								   <option value='제주'>제주도</option>
								</select>&nbsp;
								<select name='county'>
								   <option value=''>구/군</option>
								</select>                                            	
			              </td>
        			</td>
                </tr>                
    		</table>
	    </td>
	</tr>  	  
    <%if(busid_bean.getLoan_st().equals("1")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업담당자 배정</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>배정방식</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="mng_type" value='1'>
        				최초영업자 본인
        			  <input type='radio' name="mng_type" value='2'>
        				자동배정 (차량이용지역 지점별 권역 기준으로 배정) </td>
                </tr>
            </table>
        </td>
    </tr>    
    <%}else{%>
    <input type="hidden" name="mng_type" value="2">
    <%}%>	
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>상호/성명</td>
                    <td width='50%' align='left'>&nbsp;
                    	<input type='text' name='firm_nm' size='50' maxlength='40' class='text' style='IME-MODE: active' value='<%=client.getFirm_nm()%>'></td>
                    <td width='10%' class='title'>대표자</td>
                    <td align='left'>&nbsp;
                    	<input type='text' name="client_nm" value='<%=client.getClient_nm()%>' size='35' class='text'></td>
                </tr>
                <%if(!client.getClient_st().equals("2")){%>
                <tr>
                    <td class='title'>사업자번호</td>
                    <td align='left'>&nbsp;
                    	<input type='text' size='3' name='enp_no1' value='<%=client.getEnp_no1()%>' maxlength='3' class='text' onkeyup="javascript:if(get_length(this.value) == 3){ document.form1.enp_no2.focus(); }">
        			  			-
        			  			<input type='text' size='2' name='enp_no2' value='<%=client.getEnp_no2()%>' maxlength='2' class='text' onkeyup="javascript:if(get_length(this.value) == 2){ document.form1.enp_no3.focus(); }">
        			  			-
        			  			<input type='text' size='5' name='enp_no3' value='<%=client.getEnp_no3()%>' maxlength='5' class='text' onkeyup="javascript:if(get_length(this.value) == 5){ document.form1.ssn1.focus(); }"  OnBlur="CheckBizNo();">
        			  		</td>
                    <td class='title'><%if(client.getClient_st().equals("1")){%>법인번호<%}else{%>생년월일<%}%></td>
                    <td align='left'>&nbsp;
                    	<input type='text' name='ssn1' maxlength='6' value='<%=client.getSsn1()%>' size='6' class='text' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.ssn2.focus(); }">
                    	<%if(client.getClient_st().equals("1")){%>
        			  			-
        			  			<input type='text' name='ssn2' maxlength='7' value='<%=client.getSsn2()%>' size='7' class='text' OnBlur="Biz_ck();">
        			  			<%}%>
                    </td>
                </tr>
     		        <tr>
     		            <td rowspan='3' class='title'>사업장주소</td>
     		            <td rowspan='3' >&nbsp;
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
						          <input type="text" name='t_zip' id="t_zip" size="7" maxlength='7' value='<%=client.getO_zip()%>' >
						          <input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						          &nbsp;&nbsp;
						          <input type="text" name='t_addr' id="t_addr" size="50" value='<%=client.getO_addr()%>'>
						          <!-- <textarea name='t_addr' id="t_addr" rows='3' cols="50" ><%=client.getO_addr()%></textarea> -->
					          </td>
       		          <td width='10%' class='title'>개업일자</td>
    		            <td>&nbsp;
   		                <input type='text' name='open_year' size='11' class='text' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' value="<%= client.getOpen_year()%>"></td>
     		        </tr>     
     		        <tr>
       		          <td width='10%' class='title'>업태</td>
    		            <td>&nbsp;
   		                <input type='text' size='35' name='bus_cdt' value='<%=client.getBus_cdt()%>' maxlength='40' class='text'></td>
     		        </tr>
     		        <tr>
       		            <td width='10%' class='title'>종목</td>
    		              <td >&nbsp;
   		                <input type='text' size='35' name='bus_itm' value='<%=client.getBus_itm()%>' maxlength='40' class='text'></td>
     		        </tr>
                <%}else{%>
                <tr>
   		              <td class='title'>국적</td>
            		    <td>&nbsp;
            		  	  <select name='nationality'>
               		      <option value=""  <%if(client.getNationality().equals(""))  out.println("selected");%>>선택</option>
                		    <option value="1" <%if(client.getNationality().equals("1")) out.println("selected");%>>내국인</option>
                		    <option value="2" <%if(client.getNationality().equals("2")) out.println("selected");%>>외국인</option>
                		  </select>
								    </td>                	
                    <td class='title'>주민번호</td>
                    <td align='left'>&nbsp;
                    	<input type='text' name='ssn1' maxlength='6' value='<%=client.getSsn1()%>' size='6' class='text' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.ssn2.focus(); }">
        			  			-
        			  			<input type='text' name='ssn2' maxlength='7' value='<%=client.getSsn2()%>' size='7' class='text' OnBlur="Biz_ck();">
                    </td>                    
                </tr>
     		        <tr>
     		            <td class='title'>주소</td>
     		            <td colspan='3' >&nbsp;
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
						          <input type="text" name='t_zip' id="t_zip" size="7" maxlength='7' value='<%=client.getO_zip()%>' >
						          <input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						          &nbsp;&nbsp;
						          <input type="text" name='t_addr' id="t_addr" size="70" value='<%=client.getO_addr()%>'>
						          <!-- <textarea name='t_addr' id="t_addr" rows='2' cols="80" ><%=client.getO_addr()%></textarea> -->
					          </td>
     		        </tr>                     
                <%}%>
                <tr>
                    <td width='13%' class='title'>차량이용용도</td>
                    <td colspan='3' align='left'>&nbsp;
                    	<input type='text' name="rm_car_use" value='<%=fee_rm.getCar_use()%>' size='50' class='text'></td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <tr>
                    <td width='13%' class='title'>계약자 운전면허번호</td>
                    <td colspan='4' align='left'>&nbsp;
                    	<input type='text' name='lic_no' value='<%=base.getLic_no()%>'  size='25' class='text' >
			&nbsp;&nbsp;(개인,개인사업자)  
			&nbsp;※ 계약자의 운전면허번호를 기재
			</td>
                </tr>                   
                <!-- 운전자격검증결과 -->
                <tr>
                    <td class='title' rowspan='2'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <input type='text' name='test_lic_emp' value=''  size='8' class='text'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='test_lic_rel' value=''  size='10' class='text'></td>
		            <td width='40%'>&nbsp;검증결과 : <select name='test_lic_result'>
        		          		<option value='' >선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;※ 개인고객은 계약자 본인을, 개인사업자/법인사업자 고객은 계약서상 차량이용자의 운전자격을 검증</td>
                </tr>                   
            </table>
        </td>
    </tr>        
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>관계자</span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                
                <tr> 
                    <td width="3%" rowspan="<%=mgr_size+2%>" class=title>관<br>계<br>자</td>
                    <td class=title width="8%">구분</td>
                    <td class=title width="10%">성명</td>			
                    <td class=title width="14%">생년월일</td>
                    <td class=title width="15%">주소</td>
                    <td class=title width="10%">전화번호</td>
                    <td class=title width="10%">휴대폰</td>
                    <td width="10%" class=title>운전면허번호</td>
                    <td width="15%" class=title>기타</td>
                    <td width="5%" class=title>조회</td>
                </tr>
    		        <%	String mgr_zip = "";
    			        String mgr_addr = "";
    			        int mgr_idx = 0;
    		  	        for(int i = 0 ; i < mgr_size ; i++){
    				          CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
    				          if(mgr.getMgr_st().equals("차량관리자")||mgr.getMgr_st().equals("회계관리자")||mgr.getMgr_st().equals("계약관리자")) continue;
    				 %>
                <tr>                 <input type='hidden' name='mgr_id' value='<%=mgr.getMgr_id()%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%=mgr.getMgr_st()%>' class='white' readonly ></td>
                    
                    <td align='center'><input type='text' name='mgr_nm'   size='13' value='<%=mgr.getMgr_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_ssn'  size='15' maxlength='8' value='<%=mgr.getSsn()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_addr'  size='20' value='<%=mgr.getMgr_addr()%>' class='text' onBlur='javascript:CheckLen(this.value,100)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_tel'    size='13' value='<%=AddUtil.phoneFormat(mgr.getMgr_tel())%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='<%=AddUtil.phoneFormat(mgr.getMgr_m_tel())%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_lic_no'   size='13' value='<%=mgr.getLic_no()%>' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
                    <td align='center'><input type='text' name='mgr_etc' size='20' value='<%=mgr.getEtc()%>' class='text' onBlur='javascript:CheckLen(this.value,100)'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=mgr_idx%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		        <%		mgr_idx++; 
    		  	        } %>
    		        		<input type='hidden' name="mgr_idx"			value="<%=mgr_idx%>">
    		    <!-- 운전자격검증결과 -->
                <tr>
                    <td class='title' colspan='2'>추가운전자 운전자격검증</td>
		            <td>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>		            
		            <td colspan='2'>&nbsp;검증결과 : <select name='test_lic_result2'>
        		          		<option value=''>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
		            <td colspan='4'>&nbsp;※ 추가운전자가 있는 경우 운전자격을 검증</td>
                </tr>      		
            </table>
        </td>
    </tr>			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차 예정사항</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <%
    		String plan_dt = "";
			String plan_h = "";
			String plan_m = "";
    %>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width="13%"  class=title>누적주행거리</td>
                <td colspan='3'>&nbsp;<input type='text' name='sh_km' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getSh_km())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>km</td>
              </tr>                       
              <tr> 
                <td width="13%"  class=title>배차시간</td>
    <%
   		fee_rm.setDeli_plan_dt(AddUtil.replace(AddUtil.getTime(),"-",""));
   		fee_rm.setRet_plan_dt	(AddUtil.replace(AddUtil.getTime(),"-",""));

			plan_dt = fee_rm.getDeli_plan_dt().substring(0,8);
			plan_h 	= fee_rm.getDeli_plan_dt().substring(8,10);
			plan_m	= fee_rm.getDeli_plan_dt().substring(10,12);

    %>                
                <td width="37%">&nbsp;<input type='text' size='11' name='deli_plan_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(plan_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='deli_plan_h' class='default' value='<%=plan_h%>'>
                    시
                    <input type='text' size='2' name='deli_plan_m' class='default' value='<%=plan_m%>'>
                    분
                    </td>
                <td width="13%" class=title>반차시간</td>
    <%
			String plan_dt2 = c_db.addMonth(plan_dt, 1);
			plan_dt2 = c_db.addDay(plan_dt2, -1);
			String plan_h2 	= fee_rm.getRet_plan_dt().substring(8,10);
			String plan_m2	= fee_rm.getRet_plan_dt().substring(10,12);
			String plan_d2 	= fee_rm.getRet_plan_dt().substring(6,8);
    %>                
                
                <td width="37%" class=''>&nbsp;<input type='text' size='11' name='ret_plan_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(plan_dt2)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='ret_plan_h' class='default' value='<%=plan_h2%>'>
                    시
                    <input type='text' size='2' name='ret_plan_m' class='default' value='<%=plan_m2%>'>
                    분
                    </td>
              </tr>
              <tr> 
                <td width="13%"  class=title>배차장소</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='deli_loc' class='default' value='<%=fee_rm.getDeli_loc()%>' onBlur="javscript:set_loc(this.value, 'deli');">
                      </td>
                <td width="13%" class=title>반차장소</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='ret_loc' class='default' value='<%=fee_rm.getRet_loc()%>' onBlur="javscript:set_loc(this.value, 'ret');">
                      </td>
              </tr>          
            </table>
        </td>
    </tr>	
    <tr>
        <td>* 배/반차 장소 번호 자동입력 : 1 - 영남주차장, 2 - 대전지점 주차장, 3 - 부산지점 주차장, 4 - 광주지점 주차장, 5 - 대구지점 주차장 </td>
    </tr>   

	<tr id=tr_fee3 >
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동이체</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	  </tr>						
    <tr id=tr_fee2> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    			  <tr>
    			  	<td width="13%" class='title'>계좌번호</td> 
    			    <td width="50%">&nbsp;
    			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='30' class='text'>
    			      (
    			      <select name='cms_bank'>
                    <option value=''>선택</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];	
    												if(cms.getCms_bank().equals("")){%>
                    <option value='<%= bank.getNm()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}else{%>
                    <option value='<%= bank.getNm()%>' <%if(cms.getCms_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}%>
                    <%		}
    										}
    								%>
                  </select>
    			       ) </td>
    			  	<td width="10%" class='title'>결제일자</td> 
    			    <td>&nbsp;매월
    				    <% cms.setCms_day(plan_d2);%>
    			      <select name='cms_day'>
        			      <option value="">선택</option>
						        <%for(int i=1; i<=31; i++){%>
                    <option value="<%=i%>"  <%if(cms.getCms_day().equals(String.valueOf(i)))%>selected<%%>><%=i%></option>
							      <%}%>
                 </select>일
    				  </td>   			       
    			    </tr>
    			  <tr>
    			  	<td width="13%" class='title'>예금주</td>  
    			    <td colspan='3'>&nbsp;
    			    	이름 :&nbsp;
    			      <input type='text' name='cms_dep_nm' value='<%=cms.getCms_dep_nm()%>' size='30' class='text'>
        			  &nbsp;생년월일/사업자번호 :
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
    			      <br>&nbsp;
        			  연락전화 :
    			      <input type='text' name='cms_tel' size='15' class='text' value="<%=AddUtil.phoneFormat(cms.getCms_tel())%>">
    			      &nbsp;&nbsp;휴대폰 :
    			      <input type='text' name='cms_m_tel' size='15' class='text' value="<%=AddUtil.phoneFormat(cms.getCms_m_tel())%>">
    			      &nbsp;&nbsp;이메일 :
    			      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=cms.getCms_email()%>">
        			</td>
              </tr>
            </table>
        </td>
    </tr>
	<tr id=tr_fee4 >
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용카드 자동출금</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	  </tr>						
    <tr id=tr_fee2> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    			  <tr>
    			  	<td width="13%" class='title'>카드번호</td> 
    			    <td width="50%">&nbsp;
    			      <input type='text' name='c_cms_acc_no' value='<%=card_cms.getCms_acc_no()%>' size='30' class='text'>
    			      (
    			      카드사 : <input type='text' name='c_cms_bank' value='<%=card_cms.getCms_bank()%>' size='20' class='text'>
    			       ) </td>
    			  	<td width="10%" class='title'>결제일자</td> 
    			    <td>&nbsp;매월
    				    <% card_cms.setCms_day(plan_d2);%>
    			      <select name='c_cms_day'>
        			      <option value="">선택</option>
						        <%for(int i=1; i<=31; i++){%>
                    <option value="<%=i%>"  <%if(card_cms.getCms_day().equals(String.valueOf(i)))%>selected<%%>><%=i%></option>
							      <%}%>
                 </select>일
    				  </td>   			       
    			    </tr>
    			  <tr>
    			  	<td width="13%" class='title'>카드주</td>  
    			    <td colspan='3'>&nbsp;
    			    	이름 :&nbsp;
    			      <input type='text' name='c_cms_dep_nm' value='<%=card_cms.getCms_dep_nm()%>' size='30' class='text'>
        			  &nbsp;생년월일 :
    			      <input type='text' name='c_cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(card_cms.getCms_dep_ssn())%>">
    			      <br>&nbsp;
        			  연락전화 :
    			      <input type='text' name='c_cms_tel' size='15' class='text' value="<%=AddUtil.phoneFormat(card_cms.getCms_tel())%>">
    			      &nbsp;&nbsp;휴대폰 :
    			      <input type='text' name='c_cms_m_tel' size='15' class='text' value="<%=AddUtil.phoneFormat(card_cms.getCms_m_tel())%>">
    			      &nbsp;&nbsp;이메일 :
    			      <input type='text' name='c_cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=card_cms.getCms_email()%>">
        			</td>
              </tr>
            </table>
        </td>
    </tr>    

    <%if(!client.getClient_st().equals("2")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>스캔파일</span></td>
    </tr>    
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="40%" class=title>구분</td>
                  <td width="30%" class=title>스캔파일</td>
                  <td width="30%" class=title>등록일자</td>
                </tr>    
		<!--사업자등록증jpg-->			
                <%if(attach_vt_size > 0){
										for (int j = 0 ; j < attach_vt_size ; j++){
 											Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>                
                <tr>
                    <td align="center">사업자등록증jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center">사업자등록증jpg</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
                </tr>      
                <%	}%>
            </table>
        </td>
    </tr>
    <%	if(scan_chk.equals("Y")){%>
    <tr>
	    <td>&nbsp;<font color=red>※ 사업자등록증은 이미지파일이여야 합니다. 스캔등록을 다시 해주세요.</font></td>
	  </tr>
    <%	}%>
    <%}%>
    <%if(client.getClient_st().equals("1")){%>
	  <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험사항</span></td>
	  </tr>
	  <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width="13%" class=title >임직원운전한정특약</td>
                <td class=''>&nbsp;<%if(AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){ cont_etc.setCom_emp_yn("Y"); }%>
                  <select name='com_emp_yn'>
                    <option value="">선택</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                  </select></td>                    
              </tr>          
            </table>
        </td>
    </tr>	    
    <%}%>
    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>	
    <tr>
	    <td align='center'>
	        <%    if(!auth_rw.equals("1")){%>
	   	  	<a href='javascript:update();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_app_cont.gif" align="absmiddle" border="0"></a> 
	  	    &nbsp;
	  	    <%    }%>
	  	    <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
			</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	fm.est_area.value = '<%=cont_etc.getEst_area()%>';
	county_change(fm.est_area.selectedIndex);
	fm.county.value = '<%=cont_etc.getCounty()%>';

	//1 - 영남주차장, 2 - 대전지점 주차장, 3 - 부산지점 주차장, 4 - 광주지점 주차장, 5 - 대구지점 주차장	
	<%if(base.getBrch_id().equals("S1") || base.getBrch_id().equals("S2") || base.getBrch_id().equals("I1") || base.getBrch_id().equals("S3") || base.getBrch_id().equals("S4") || base.getBrch_id().equals("S5") || base.getBrch_id().equals("S6")){%>
	set_loc('1', 'deli');
	set_loc('1', 'ret');
	<%}else if(base.getBrch_id().equals("D1")){%>
	set_loc('2', 'deli');
	set_loc('2', 'ret');
	<%}else if(base.getBrch_id().equals("B1")){%>
	set_loc('3', 'deli');
	set_loc('3', 'ret');
	<%}else if(base.getBrch_id().equals("J1")){%>
	set_loc('4', 'deli');
	set_loc('4', 'ret');
	<%}else if(base.getBrch_id().equals("G1")){%>
	set_loc('5', 'deli');
	set_loc('5', 'ret');
	<%}%>
//-->
</script>
</body>
</html>