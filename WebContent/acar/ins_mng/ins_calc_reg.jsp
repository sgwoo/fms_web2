<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,acar.car_office.*, acar.user_mng.*"%>
<%@ page import="acar.insur.*, acar.car_register.*,common.*, acar.beans.*"%>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String o_c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String o_ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	String reg_code = request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "01");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	ins = ai_db.getIns(o_c_id, o_ins_st);
	
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(o_c_id);
	
	
	
	//계약번호 생성 페이지
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	//영업소 조회
	Vector branches = c_db.getUserBranchs("rent"); 			//영업소 리스트	
	int brch_size = branches.size();
	
	//자동차회사 리스트	
	CarCompBean cc_r [] = umd.getCarCompAllNew("1");

	
	
  	//차종소분류
  	CodeBean[] goods = c_db.getCodeAll2("0008", "Y");
  	int good_size = goods.length;
  	
	int ins_size = 0;
	InsCalcBean calc = ai_db.getInsCalcInfo(reg_code);
	Vector files = new Vector();
	if(!reg_code.equals("")) files = c_db.getAcarAttachFileList("INSUR",reg_code+"_c",0);
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src='/include/common.js'></script>
<script>

	//자동차구분에 따른 디스플레이	
	function cng_input(){
		var fm = document.form1;
		
		if(fm.car_gu[2].checked == true){							//중고차
		}else{
		}
				
		if(fm.car_gu[1].checked == true){							//재리스
			if(fm.car_name.value != '') fm.reset();
			tr_cartype_2.style.display		= '';					
			td_01.style.display			= 'none';
			td_02.style.display			= '';
			td_11.style.display			= 'none';			
			td_12.style.display			= '';
			td_21.style.display			= 'none';
			td_22.style.display			= '';
			td_31.style.display			= 'none';
			td_32.style.display			= '';
			/* td_41.style.display			= 'none';
			td_42.style.display			= '';
			td_51.style.display			= 'none';
			td_52.style.display			= '';			 */
		}else{											//신차||중고차
			if(fm.car_mng_id.value != '') fm.reset();
			tr_cartype_2.style.display		= 'none';
			td_01.style.display			= '';
			td_02.style.display			= 'none';			
			td_11.style.display			= '';
			td_12.style.display			= 'none';
			td_21.style.display			= '';
			td_22.style.display			= 'none';
			td_31.style.display			= '';
			td_32.style.display			= '';
			/* td_41.style.display			= '';
			td_42.style.display			= '';
			td_51.style.display			= '';
			td_52.style.display			= ''; */
		}
	
	}
	//기존차 조회
	function car_search()
	{
		var fm = document.form1;
		var car_gu = "0";
		window.open("search_ext_car.jsp?car_gu="+car_gu, "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");
	}	
	
	
	//출처에 따른 자동차 제조사 출력하기
	function GetCarCompe(){
		var fm = document.form1;
		var fm2 = document.form2;
		var car_origin = fm.car_origin.options[fm.car_origin.selectedIndex].value;
		fm2.car_origin.value = car_origin;
		te = fm.car_comp_id;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.car_comp_id";
		fm2.mode.value = '0';
		fm2.target="i_no";
		fm2.submit();		
	}
	
	//자동차회사 선택시 차종코드 출력하기
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		var car_comp_id = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		//fm.con_cd3.value = car_comp_id.substring(0,1);
		fm2.car_comp_id.value = car_comp_id.substring(1);
		fm2.s_st.value = fm.s_st.options[fm.s_st.selectedIndex].value;
		if(fm.car_gu[2].checked == true){//중고차
			fm2.car_st.value = fm.car_st.options[fm.car_st.selectedIndex].value;
		}else{
			fm2.car_st.value = '';
		}		
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	//차종코드 선택시 계약코드 출력하기
	function GetCarCd(){
		var fm = document.form1;	
		var code = fm.code.options[fm.code.selectedIndex].text;
	}
		
	//세부리스트
	function sub_list(idx){
		var fm = document.form1;
		if(fm.car_comp_id.value == '')		{ 	alert('자동차회사를 선택하십시오.'); 	return;}
		if(fm.code.value == '')			{ 	alert('차명을 선택하십시오.'); 		return;}
		var car_comp_id = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value.substring(1);
		var SUBWIN="/fms2/lc_rent/search_esti_sub_list.jsp?idx="+idx+"&car_comp_id="+car_comp_id+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text;
		if(fm.car_gu[2].checked == true && idx == 1){//중고차
			SUBWIN="/fms2/lc_rent/search_esti_sub_oldcar_list.jsp?idx="+idx+"&car_comp_id="+car_comp_id+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text;
		}
		window.open(SUBWIN, "SubList", "left=100, top=100, width=1050, height=650, scrollbars=yes, status=yes");
	}
	
	// 법인/개인구분
	function changeClientSt(client_st){
		if(client_st == '1'){
			document.getElementById("age_td1").style.display ="";
			document.getElementById("age_td2").style.display ="none";
			
			document.getElementById("client_nm_td").innerHTML = "상호명/대표자명";
			
			document.getElementById("ssn_td").innerHTML = "대표자 생년월일";
			document.getElementById("ssn2").style.display ="none";
			document.getElementById("ssn_gubun").style.display ="none";
			
			document.getElementById("tel_com_td").innerHTML ="대표자 휴대폰";
			
			document.getElementById("addr_btn").setAttribute("disabled", "disabled");
			document.getElementById("t_zip").setAttribute("disabled", "disabled");
			document.getElementById("t_addr").setAttribute("disabled", "disabled");
			
			
			document.getElementById("job").setAttribute("disabled", "disabled");
			document.getElementById("ins_limit").setAttribute("disabled", "disabled");
			document.getElementById("ins_limit").style.backgroundColor = "rgb(235, 235, 228)";
			document.getElementById("com_emp_yn").value="Y";
			
			document.getElementById("enp_no").removeAttribute("disabled");  
			document.getElementById("enp_no").style.backgroundColor = "white";

			document.getElementById("driver_tr").style.display ="none";
			
		}else if(client_st == '2'){
			document.getElementById("age_td1").style.display ="none";
			document.getElementById("age_td2").style.display ="";
			
			document.getElementById("client_nm_td").innerHTML = "상호명/대표자명";
			
			document.getElementById("ssn_td").innerHTML = "주민번호";
			document.getElementById("ssn2").style.display ="";
			document.getElementById("ssn_gubun").style.display ="";
			
			document.getElementById("tel_com_td").innerHTML ="휴대폰";
			
			document.getElementById("addr_btn").removeAttribute("disabled");
			document.getElementById("t_zip").removeAttribute("disabled");
			document.getElementById("t_addr").removeAttribute("disabled");

			document.getElementById("job").removeAttribute("disabled");
			document.getElementById("ins_limit").removeAttribute("disabled");
			document.getElementById("ins_limit").style.backgroundColor = "white";
			document.getElementById("com_emp_yn").value="N";

			document.getElementById("enp_no").setAttribute("disabled", "disabled");
			document.getElementById("enp_no").style.backgroundColor = "rgb(235, 235, 228)";

			document.getElementById("driver_tr").style.display ="";
		}
	}

	function save(){
		var fm = document.form1;
		
		if(!confirm('등록하시겠습니까?')){	return;	}
		
		if(fm.client_st.value == '1'){
			document.getElementById("ssn2").value="";
			document.getElementById("job").value="";
			document.getElementById("t_zip").value="";
			document.getElementById("t_addr").value="";
			document.getElementById("age").value ="";
			document.getElementById("ins_limit").value="";
			document.getElementById("driver_nm").value="";
			document.getElementById("driver_ssn1").value="";
			document.getElementById("driver_rel").value="";
		}else{
			document.getElementById("age_scp").value ="";
			document.getElementById("enp_no").value ="";
		}
		
		fm.req_st.value='r';
		fm.target = 'i_no';
		fm.action = 'ins_calc_reg_a.jsp';
		fm.submit();
	}
	
	function update(){
		var fm = document.form1;
		
		if(!confirm('수정하시겠습니까?')){	return;	}
		if(fm.client_st.value == '1'){
			document.getElementById("ssn2").value="";
			document.getElementById("job").value="";
			document.getElementById("t_zip").value="";
			document.getElementById("t_addr").value="";
			document.getElementById("age").value ="";
			document.getElementById("ins_limit").value="";
			document.getElementById("driver_nm").value="";
			document.getElementById("driver_ssn1").value="";
			document.getElementById("driver_rel").value="";
		}else{
			document.getElementById("age_scp").value ="";
			document.getElementById("enp_no").value ="";
		}
		
		fm.req_st.value='u';
		fm.target = 'i_no';
		fm.action = 'ins_calc_reg_a.jsp';
		fm.submit();
	}
	function del(){
		var fm = document.form1;
		
		if(!confirm('수정하시겠습니까?')){	return;	}
		
		fm.req_st.value='d';
		fm.target = 'i_no';
		fm.action = 'ins_calc_reg_a.jsp';
		fm.submit();
	}
	
	//검색하기
	function search(){
		var fm = document.form1;	
		window.open("about:blank", "SEARCH", "left=100, top=100, width=800, height=500, scrollbars=yes");
		var fm = document.form1;
		fm.action = "search_succ.jsp";		
		fm.target = "SEARCH";
		fm.submit();		
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function enter(idx) {
		var fm = document.form1;
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			if(idx == 1)  fm.vins_pcp_amt.focus();
			if(idx == 2)  fm.vins_gcp_amt.focus();
			if(idx == 3)  fm.vins_bacdt_amt.focus();
			if(idx == 4)  fm.vins_canoisr_amt.focus();
			if(idx == 5)  fm.vins_cacdt_cm_amt.focus();
			if(idx == 6)  fm.vins_spe.focus();
			if(idx == 7)  fm.vins_spe_amt.focus();
		}
	}
	
	function openDaumPostcode() {
		new daum.Postcode({
			oncomplete: function(data) {
				document.getElementById('t_zip').value = data.zonecode;
				document.getElementById('t_addr').value = data.address;
				
			}
		}).open();
	}
	
	function setColAmt(){
		var fm = document.form1;
		
		if(fm.car_gu[1].checked == true){
		
		}else{
			fm.col_s_amt.value =  parseDecimal(sup_amt(toInt(parseDigit(fm.col_amt.value))));
			fm.col_v_amt.value =  parseDecimal(toInt(parseDigit(fm.col_amt.value))-toInt(parseDigit(fm.col_s_amt.value)));
			
			fm.o_1.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)));
			fm.o_1_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_s_amt.value)) + toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.col_s_amt.value)));
			fm.o_1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_v_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)) + toInt(parseDigit(fm.col_v_amt.value)));
		}
	}
	
	function onlyNumber(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		
	}
	function removeChar(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}
	function numberComma(x){
		var fm = document.form1;
		fm.car_b_p.value= x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	function getprice(){
		var fm = document.form1;
		fm.car_b_p.value = fm.o_1.value;
	}
	
	function calcAge() {    
	
		var fm = document.form1;
		var birth = fm.ssn1.value;
		var year ="";
		if(Number(birth.substring(0,2))>20) year = "19";
		else year = "20";
			
		birth = year +birth.substring(0,2) +"/"+birth.substring(2,4) +"/"+birth.substring(4,6);
	   
		var birthday = new Date(birth);
	    var today = new Date();
	    var years = today.getFullYear() - birthday.getFullYear();
	    birthday.setFullYear(today.getFullYear());
	    if (today < birthday)years--;
	    fm.age.value = years; 
	
	} 
	
	
	function sendRegPage(){
		location.href = '/acar/ins_mng/ins_calc_frame.jsp';
	}
	
	function file_delete_btn(seq){
		var refresh = false;
		var url = 'https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ='+seq;
		 window.open(url,'popupView','toolbar=no, width=1000, height=300'); 
		  refresh=true;	
	       if(refresh){
	    	   setTimeout(function() {
					document.location.reload();// 프레임새로고침
				}, 2000);
			}
	}
	
	function page_reload(){
		location.reload();	
	}
</script>
<script>
/*파일업로드 관련  */
$(document).ready(function() {
	//리스트 삭제
	function removefile(){
		$('#form3').children('#upload-select').remove();
		//$('#form2').children('#pevFileNames').remove();
		$('#form3').find('#file-upload-form').find('tbody').remove();
		$('#form3').find('#file-upload-form').find('tr').remove();
		$('#upload-list').empty();
		$('#upload-select').val("");
		$('#upload-list').css("height","20px");
	}
	//validation
	function validation(){
		var check = false;
		if($('#file-upload-form').find('tr').html() == undefined){
			alert("파일을 등록해주세요");
		}else{
			 check = true;
		}  
		return check;
	}

	$('#upload-select-fake').bind('click', function() {
		removefile();
		$('#upload-select').trigger('click');
	});
	
	$('#upload-select').change(function() {
		 var list = '';
         fileIdx = 0;
         for (var i = 0; i < this.files.length; i++) {
             fileIdx += 1;
             list += fileIdx + '. ' + this.files[i].name + '\n';
         }
         //파일리스트
         $('#upload-list').append(list);
         $('#upload-list').css("height","auto");
         
         for (var i = 0; i < this.files.length; i++) {
	         var file = this.files[i];
	         var tokens = file.name.split('.');
	         tokens.pop();
	         var content_seq = '<%=reg_code%>'; 
	         var file_name = this.files[i].name;
	     	 var file_size = this.files[i].size;
	         var file_type = this.files[i].type;
	         
	         var tr =
	             '<tr><td>' +
	             '' +
	             '<input type="hidden" name="content_seq" value="'+ content_seq +'">' +
	             '<input type="hidden" name="file_name" value="'+ file_name +'">' +
	             '<input type="hidden" name="file_size" value="'+ file_size +'">' +
	             '<input type="hidden" name="file_type" value="'+ file_type +'">' +
	             '</td></tr>';
	         //파일 정보    
	         $('#file-upload-form').append(tr);
         }
         
	     	var real= $('#upload-select');
	    	var cloned = real.clone(true);
	    	real.hide();
	    	cloned.insertAfter(real);
	    	real.appendTo('#form3');
         
		});
	
		$('#upload-button-fake').bind('click', function() {
		        /* if(validation()){ 
			       if(!confirm("해당 파일을 등록하시겠습니까?")) return; */
			       var refresh=false;
			          //$("#form2").attr("action", "https://fms3.amazoncar.co.kr/fms2/attach/multifileupload.jsp?contentCode=INSUR");//실제사용
			       var fm = document.form1;
			       var url = "ins_calc_reg_file.jsp";
			       window.open("","form1","top=300, toolbar=no, width=900, height=300, directories=no");
			       fm.action = url;
			       fm.method = "post";
			       fm.target="form1";
			       fm.submit();
			          
			       refresh=true;	
			      /*  if(refresh){
			    	   setTimeout(function() {
							document.location.reload();// 프레임새로고침
						}, 2000);
					} */
		       /*  }  */
		   });
});
</script>
<style>
	td.title{height:26px;}
	input{height:20px;}
	select{height:20px;}
	input[type=button]{height:20px;font-size:8pt;}
	input[type=radio]{height:13px;}
</style>
</head>
<body>
<form action="/fms2/lc_rent/get_car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_origin" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="s_st" value="">
  <input type="hidden" name="car_st" value="">
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">
  <input type="hidden" name="t_wd" value="">
  <input type="hidden" name="auth_rw" value="">
  <input type="hidden" name="mode" value="">
</form>

<form name='form1' method='post' action='ins_calc_reg_a.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="o_c_id" value='<%=o_c_id%>'>
<input type='hidden' name="o_ins_st" value='<%=o_ins_st%>'>
<input type="hidden" name="con_cd" value="">
<input type="hidden" name="jg_opt_st" value="">
<input type="hidden" name="jg_col_st" value="">
<input type="hidden" name="jg_tuix_st" value="">
<input type="hidden" name="jg_tuix_opt_st" value="">
<input type="hidden" name="lkas_yn" value="">			<!-- 차선이탈 제어형 (차종포함) -->
<input type="hidden" name="lkas_yn_opt_st" value="">	<!-- 차선이탈 제어형 (옵션) -->
<input type="hidden" name="ldws_yn" value="">			<!-- 차선이탈 경고형 (차종포함) -->
<input type="hidden" name="ldws_yn_opt_st" value="">	<!-- 차선이탈 경고형 (옵션) -->
<input type="hidden" name="aeb_yn" value="">			<!-- 긴급제동 제어형 (차종포함) -->
<input type="hidden" name="aeb_yn_opt_st" value="">		<!-- 긴급제동 제어형 (옵션) -->
<input type="hidden" name="fcw_yn" value="">			<!-- 긴급제동 경고형 (차종포함) -->
<input type="hidden" name="fcw_yn_opt_st" value="">		<!-- 긴급제동 경고형 (옵션) -->
<input type="hidden" name="req_st" value="">
<input type="hidden" name="reg_code" value="<%=reg_code%>">


<table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
		<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 > 고객피보험산출요청 ><span class=style5>
			고객피보험산출요청등록</span></span></td>
		<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
	</tr>
</table>
<br>
<div style="font-size:9pt;margin-bottom:5px;">
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>안내문구</span>
	<img src="/acar/images/center/button_back_p.gif" onclick="sendRegPage()" style="margin-bottom:20px;float:right;cursor:pointer;">
</div>
<div style="font-size:9pt;background-color: #e2e7ff;border-top: 4px solid #b0baec;border-bottom: 4px solid #b0baec;color: #464e7c;font-weight:bold;">
<br>
	<div>&nbsp;
		<img src=/acar/images/center/arrow.gif align=absmiddle>
		차량 출고 확정 후 등록예정일을 보험가입일자, 요율로 따른 최종 보험료가 달라질 수 있습니다. <br>&nbsp;&nbsp;&nbsp;&nbsp;
		최종청약서로 피보험자 란에 서명을 받아야 하기 때문에	등록예정일 전 고객 서명을 받기 전에 반드시 보험 담당자에게 통보해야 합니다.
	</div>
	<br>
	<div>&nbsp;
		<img src=/acar/images/center/arrow.gif align=absmiddle>
		운전자한정은 좁을 수록 심사승인 가능성이 높습니다.
		고객 요율에 따라 심사거부, 인수 거절, 심사진행에 따라 가입이 어려울 수 있으며 삼성화재로 재산출 요청해야 합니다.
	</div>
	<br>
	<div>&nbsp;
		<img src=/acar/images/center/arrow.gif align=absmiddle>
		물적사고 사고 기준 기본 200만원, 수입차(견인20km, 잠금 장치제외), 질권설정 자동 가입 진행됩니다.
	</div>
	<br>
</div>

<br>
<%-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격정보</span></td>
    </tr>
    <tr>
        <td align='left' >
    		&nbsp;
    		<input type='radio' name="car_gu" value='1' onClick="javascript:cng_input()" checked>신차
 			<input type='radio' name="car_gu" value='0' onClick="javascript:cng_input()">재리스
			<input type='radio' name="car_gu" value='2' onClick="javascript:cng_input()">중고차
		</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan="2" class='title'>항목</td>
                    <td width="70%" class='title'>선택</td>
                    <td width="17%" class='title'>금액</td>
                </tr>
                <tr> 
                    <td colspan="2" class='title'>영업지점</td>
                    <td>&nbsp; 
                      <select name='brch_id'>
                        <option value=''>선택</option>
                      <%		for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%=branch.get("BR_ID")%>'><%= branch.get("BR_NM")%></option>
                      <%		}%>
                      </select>&nbsp;
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr id=tr_cartype_2 style='display:none'> 
                    <td colspan="2" class='title'>차량번호</td>
                    <td>&nbsp;
        			  <input type='text'   name='car_no' class='fix' size='15' readonly>
        			  <input type='hidden' name='car_mng_id' value=''>
        			  <input type='hidden' name='old_rent_mng_id' value=''>
        			  <input type='hidden' name='old_rent_l_cd' value=''>			  
        			  <input type='hidden' name='car_use' value=''>			  
                      <a href="javascript:car_search();"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td width="3%" rowspan="8" class='title'>자<br>동<br>차</td>
                    <td width="10%" class='title'>출처</td>
                    <td><table width="100%" border="0" cellpadding="0">
                        <tr>
                          <td id=td_01 style="display:''">&nbsp;
                            <select name="car_origin" onChange="javascript:GetCarCompe()" class='default'>
                              <option value="">선택</option>
                              <option value="1" selected>국산</option>
                              <option value="2">수입</option>
                            </select></td>
                          <td id=td_02 style='display:none'>&nbsp;
        				  <input type='text' name="car_origin_nm" size='60' class='fix' readonly></td>
                        </tr>
                      </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>제작회사</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                              <td id=td_11 style="display:''">&nbsp;
                          		<select name="car_comp_id"  onChange="javascript:GetCarCode()" class='default'>
            					  <option value="">선택</option>
                            	<%	for(int i=0; i<cc_r.length; i++){
            					  		cc_bean = cc_r[i];%>
                            	  <option value="<%= cc_bean.getNm_cd() %><%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                            	<%	}	%>
                          		</select>
                          		&nbsp;&nbsp;차명분류 : 
                          		<select name="s_st" onChange="javascript:GetCarCode()">
                        <option value="">=선 택=</option>
                        <%for(int i = 0 ; i < good_size ; i++){
                  CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>'><%= good.getNm()%></option>
                        <%}%>
                      </select> 
                      (중고차일때 차명분류 사용)
            				</td>
                              <td id=td_12 style='display:none'>&nbsp;
                                  <input type='text' name="car_comp_nm" size='60' class='fix' readonly></td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>차명</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_21 style="display:''">&nbsp;                    
                					<select name="code" onChange="javascript:GetCarCd()">
                                	  <option value="">선택</option>
                              		</select>
                					&nbsp; </td>
                                <td id=td_22 style='display:none'>&nbsp;
            				    <input type='text' name="car_nm" size='60' class='fix' readonly></td>
                            </tr>
                        </table> 
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>차종</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_31 style="display:''">&nbsp;                    
            					    <a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
            				    </td>
                                <td id=td_32 style="display:''">&nbsp;
                				  	<input type='text' name="car_name" size='60' class='fix' readonly>
                			  		<input type='hidden' name='car_id' value=''>
                			  		<input type='hidden' name='car_seq' value=''>
                					<input type='hidden' name='car_s_amt' value=''>
                					<input type='hidden' name='car_v_amt' value=''>
			        				<input type='hidden' name='auto_yn' value=''>
			        				<input type='hidden' name='car_b' value=''>
               					</td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='car_amt' size='10' value='' maxlength='15' class='fixnum' readonly>
        			  원</td>
                </tr>
                <tr> 
                    <td class='title'>옵션</td>
                    <td>
        			    <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_41 style="display:''">&nbsp;
            				        <a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>					
                                </td>
                                <td id=td_42 style="display:''">&nbsp;
            				    <input type='text' name="opt" size='60' class='fix' readonly>
            				    <input type='hidden' name='opt_seq' value=''>
            				    <input type='hidden' name='opt_s_amt' value=''>
            				    <input type='hidden' name='opt_v_amt' value=''></td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='opt_amt' size='10' value='' maxlength='13' class='fixnum' readonly>원</td>
                </tr>
                <tr> 
                    <td class='title'>색상</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_51 style="display:''">&nbsp;
            				        <a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                                </td>
                                <td id=td_52 style="display:''">&nbsp;
            				    <input type='text' name="col" size='50' class='text'>
								(내장색상(시트): <input type='text' name="in_col" size='20' class='text'> )
            				    <input type='hidden' name='col_seq' value=''>
            				    <input type='hidden' name='col_s_amt' value=''>
            				    <input type='hidden' name='col_v_amt' value=''></td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='col_amt' size='10' value='' maxlength='13' class='num' onBlur="javascript:setColAmt()">원</td>
                </tr>
                <tr>
                	<td class="title">연비</td>
                	<td>
                		<table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_41 style="display:''">&nbsp;
            				        <a href="javascript:sub_list('5');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>					
                                </td>
                                <td id=td_42 style="display:''">&nbsp;
            				    <input type='text' name="conti_rat" size='60' class='fix' readonly>
            				    <input type='hidden' name='conti_rat_seq' value=''>
                            </tr>
                        </table>
                	</td>
                	<td></td>
                </tr>
                <tr>
                    <td colspan="" class='title'>차량가격</td>
                    <td colspan=""></td>
                    <td align="center" ><input type='text' name='o_1'size='10' value='' maxlength='13' class='fixnum' readonly style="text-align:center;" >					
        				원<input type='hidden' name='o_1_s_amt' value=''><input type='hidden' name='o_1_v_amt' value=''></td>
                </tr>
                 <tr>
			        <td class=line2></td>
			    </tr>
            </table>
	    </td>
    </tr>
    </table> --%>
    <br>
    
    <!-- 고객피보험정보 -->
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객피보험정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>구분</td>
                    <td>&nbsp;
                      <select name='client_st' style="width:100px;" onchange="changeClientSt(this.value)">
                        <option value="1" <%if(calc.getClientSt().equals("1")){%>selected<%}%>>법인</option>
                        <option value="2" <%if(calc.getClientSt().equals("2")){%>selected<%}%>>개인</option>
                      </select>		
                    </td>
                    <td class=title>차종</td>
                    <td colspan="">&nbsp;
                     <input type='text' name='car_name2' value='<%=calc.getCarName()%>' class='text' style="width:200px;">
                    </td>
                    <td class=title>차량가격</td>
                    <td colspan="">&nbsp;
                     <input type='text' name='car_b_p' value='<%=Util.parseDecimal(String.valueOf(calc.getCarBP()))%>' class='text' style="width:100px;" 
                      onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' onblur='numberComma(this.value)'>
                      &nbsp;원&nbsp;&nbsp;
                     <!--  <input type="button" value="차량가격 적용" onclick="getprice();"> -->
                    </td>
                </tr>
                <tr> 
                	<td class=title  width=10% id="client_nm_td">상호명/대표자명</td>
                    <td width=15%>&nbsp;
                     <input type='text' name='client_nm' value='<%=calc.getClientNm()%>' class='text' style="width:200px;">
                    </td>
                    <td class=title width=10% id="ssn_td">대표자 생년월일</td>
                    <td width=15%>&nbsp;
                        <input type="text" name="ssn1" class='text' style="width:60px;" onblur="calcAge()" maxlength="6" value="<%if(calc.getSsn().length()>5){%><%=calc.getSsn().substring(0,6)%><%}%>">
                    	<span id="ssn_gubun" style="display:none;">-</span>  
                    	<input type="text" name="ssn2" id="ssn2" class='text' style="width:70px;display:none;" maxlength="7" value="<%if(calc.getSsn().length()>13){%><%=calc.getSsn().substring(7,14)%><%}%>">
                    </td>
                   <td class=title  width=10% id="tel_com_td">대표자 휴대폰</td>
                    <td width=15%>&nbsp;
                      <select name='tel_com'>
                        <option value='SKT' <%if(calc.getTelCom().equals("SKT")){%>selected<%}%>>SKT</option>
                        <option value='KT'  <%if(calc.getTelCom().equals("KT")){%>selected<%}%>>KT</option>
                        <option value='LG'  <%if(calc.getTelCom().equals("LG")){%>selected<%}%>>LG</option>
                        <option value='알뜰폰'>알뜰폰</option>
                      </select>
                      <input type='text' onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' name='m_tel' value='<%=calc.getMTel()%>' class='text'  maxlength='11'>
                    </td>
                </tr>
                <tr> 
                 	<td class=title>주소</td>
                    <td colspan="5">&nbsp; 
                   		<input type="text" name='t_zip' id="t_zip" maxlength='7'  style="width:70px;" value="<%=calc.getTZip()%>" disabled>
						<input type="button" onclick="openDaumPostcode()" value="우편번호" id="addr_btn" disabled>
	                    <input type="text" name='addr' id="t_addr" value="<%=calc.getAddr()%>" style="width:625px;margin-left:40px;" disabled>
                    </td>
                </tr>
                <tr> 
                 <td class=title >연령</td>
                     <td id="age_td1">  &nbsp;
                     <select name='age_scp' id='age_scp'>
                        <option value='1'  <%if(calc.getAgeScp().equals("1")){%>selected<%}%>>만21세이상</option>
                        <option value='4'  <%if(calc.getAgeScp().equals("4")){%>selected<%}%>>만24세이상</option>
                        <option value='2'  <%if(calc.getAgeScp().equals("2")){%>selected<%}%>>만26세이상</option>				
                        <option value='3'  <%if(calc.getAgeScp().equals("3")){%>selected<%}%>>모든운전자</option>
                        <option value=''>	=피보험자고객=</option>
                        <option value='5'  <%if(calc.getAgeScp().equals("5")){%>selected<%}%>>만30세이상</option>
                        <option value='6'  <%if(calc.getAgeScp().equals("6")){%>selected<%}%>>만35세이상</option>
                        <option value='7'  <%if(calc.getAgeScp().equals("7")){%>selected<%}%>>만43세이상</option>
                        <option value='8'  <%if(calc.getAgeScp().equals("8")){%>selected<%}%>>만48세이상</option>
                        <option value='9'  <%if(calc.getAgeScp().equals("9")){%>selected<%}%>>만22세이상</option>												
                        <option value='10' <%if(calc.getAgeScp().equals("10")){%>selected<%}%>>만28세이상</option>												
                        <option value='11' <%if(calc.getAgeScp().equals("11")){%>selected<%}%>>만35세이상~만49세이하</option>	
                      </select>
                    </td>
                     <td id="age_td2" style="display:none">&nbsp; 
                     	만&nbsp;<input type="text" name="age"  id="age" value="<%if(!calc.getAgeScp().equals("") && Integer.parseInt(calc.getAgeScp())>18) %><%=calc.getAgeScp()%>" style="text-align:right;width:30px;">&nbsp;세
                    </td>
                    <td class=title>대물</td>
                    <td>&nbsp; 
                        <select name='vins_gcp_kd' style="width:100px;">
						<option value='3' <%if(calc.getVinsGcpKd().equals("3")){%>selected<%}%> >1억원</option>
						<option value='7' <%if(calc.getVinsGcpKd().equals("7")){%>selected<%}%> >2억원</option>
						<option value='8' <%if(calc.getVinsGcpKd().equals("8")){%>selected<%}%> >3억원</option>
                        <option value='6' <%if(calc.getVinsGcpKd().equals("6")){%>selected<%}%> >5억원</option>
                        <option value='5' <%if(calc.getVinsGcpKd().equals("5")){%>selected<%}%> >1000만원</option>				
                        <option value='2' <%if(calc.getVinsGcpKd().equals("2")){%>selected<%}%> >1500만원</option>
                        <option value='1' <%if(calc.getVinsGcpKd().equals("1")){%>selected<%}%> >3000만원</option>
                        <option value='4' <%if(calc.getVinsGcpKd().equals("4")){%>selected<%}%> >5000만원&nbsp;&nbsp;&nbsp;</option>
                      </select>
                    </td>
                    <td class=title>사업자번호</td>
                    <td>&nbsp; 
                     <input type='text' onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' name='enp_no' id='enp_no' value='<%=calc.getEnpNo()%>' class='text'  maxlength='15' >
                    </td>
                </tr>
                <tr>
                    <td class=title>한정</td>
                    <td>&nbsp; 
                   	   <select name='ins_limit' id='ins_limit' style="width:120px;background-color:rgb(235, 235, 228);" disabled>
                        <option value=''>선택</option>
                        <option value='1' <%if(calc.getInsLimit().equals("1")){%>selected<%}%> >부부한정</option>
						<option value='2' <%if(calc.getInsLimit().equals("2")){%>selected<%}%> >기명피보험자한정</option>
						<option value='3' <%if(calc.getInsLimit().equals("3")){%>selected<%}%> >가족한정</option>
                      </select>
                    </td>
                    <td class=title>임직원한정</td>
                    <td>&nbsp; 
                      <select name='com_emp_yn' id='com_emp_yn' style="width:100px;">
                        <option value='Y' <%if(calc.getComEmpYn().equals("Y")){%>selected<%}%>>가입</option>
						<option value='N' <%if(calc.getComEmpYn().equals("N")){%>selected<%}%>>미가입</option>
                      </select>
                    </td>
                    <td class=title>직업</td>
                    <td>&nbsp; 
                      <input type="text" name="job" id="job" value="<%=calc.getJob()%>" style="width:200px;" disabled>
                     </td>
                </tr>
                <tr id="driver_tr" style="display:none;">
                    <td class=title>추가운전자 이름</td>
                    <td>&nbsp; 
                   		<input type='text' name='driver_nm' id='driver_nm' value='<%=calc.getDriverNm()%>' class='text' style="width:200px;">
                    </td>
                    <td class=title>추가운전자 생년월일</td>
                    <td>&nbsp; 
                    	 <input type="text" name="driver_ssn1" id="driver_ssn1" class='text' style="width:60px;margin-right:80px;" onblur="" maxlength="6" value="<%if(calc.getDriverSsn().length()>5){%><%=calc.getDriverSsn().substring(0,6)%><%}%>"> 
                    </td>
                    <td class=title>고객과의 관계</td>
                    <td>&nbsp; 
                      <input type="text" name="driver_rel" id="driver_rel" value="<%=calc.getDriverRel()%>" style="width:200px;">
                     </td>
                </tr>
                <tr>
                    <td class=title>비고</td>
                    <td colspan="5">&nbsp; 
                   	   <input type="text" name="etc" value="<%=calc.getEtc()%>" style="width:1000px;">
                    </td>
                </tr>
                  <%if(!reg_code.equals("")){ %>
                 <tr>
                    <td class=title>첨부파일</td>
                    <td colspan="3">&nbsp; 
					    <!-- <input type="button" id="upload-select-fake" class="button" value="파일 선택" style="height:25px;"/> -->
					    <!-- <img src=/acar/images/center/button_in_fsearch.gif  border=0 id="upload-select-fake"> -->
					    <!-- <input type="button" id="upload-button-fake" class="button btn-submit" value="업로드" style="height:25px;"/> -->
					    <!-- <pre style="font-size: 9pt;display: inline-block;width:300px;height:20px;margin:0px;padding:0px;background:#e2e6ea;" id="upload-list" ></pre> -->
					    <img src=/acar/images/center/button_in_scan_reg.gif  border=0 id="upload-button-fake" style="cursor:pointer;">
					    <!-- <input style="display: none;" id="upload-select" type="file" name="files[]" multiple> -->
					   	&nbsp;&nbsp;* 스캔파일을 등록하고나서 이 페이지를 <a href="javascript:page_reload()">새로고침</a> 해주세요 	
                    </td>   
                   	<%if(files.size() ==0){%>
                    	<td colspan="2">
                    	</td>
                   	<%}else{%>
                   		<td colspan="2">
                   	<% for(int i =0; i<files.size(); i++){
                   		Hashtable ht = (Hashtable)files.elementAt(i);%>
                   	 	<div style="margin:5px 10px;">
                   	 		<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
<%--                    	 		&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>"  target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a> --%>
                   	 		&nbsp;<img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0" onclick="file_delete_btn('<%=ht.get("SEQ")%>')">
                   	 	</div>
           			<%} %>
              			</td>	
                   	<%} %>
                </tr>
                <%} %> 
            </table>
        </td>
    </tr>
      <tr>
        <td class=line2></td>
    </tr>
</table>

<div align="right" style="margin-top:20px;">
<%if(reg_code.equals("")){ %>
	<a href="javascript:save();"><img src=/acar/images/center/button_reg.gif border=0></a>
<%}else{ %>
	<a href="javascript:update();"><img src="/acar/images/center/button_modify.gif" border="0"></a>
	<a href="javascript:del();"><img src="/acar/images/center/button_delete.gif" border="0"></a>
<%} %>
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script>changeClientSt('<%=calc.getClientSt()%>')</script>	
<form name='form3' method='post' action='' id="form3" enctype="multipart/form-data">
	<div>
		<table id="file-upload-form" style="display: block;"></table>
	</div>
</form>
</body>
</html>
