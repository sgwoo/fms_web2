<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*"%>
<%@ page import="acar.cont.*, acar.accid.*, acar.insur.*, acar.estimate_mng.*, acar.car_register.*, acar.tint.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");//사고구분
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");//등록구분
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");//등록사유
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "01");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//계산식 변수
	String var1 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt1");
	String var2 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt2");
	String var3 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt3");
	String var4 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt4");
	String var5 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt5");
	String var6 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt6");
	String var7 = e_db.getEstiSikVarCase("1", "", "ins_reg_per1");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//자동차등록정보
	cr_bean = crd.getCarRegBean(c_id);
	
	//납품관리
	TintBean tint 	= t_db.getTint(m_id, l_cd);
	
	TintBean tint3 	= t_db.getCarTint(m_id, l_cd, "3");
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
	if(car_st.length()>5 && !car_st.equals("") )	car_st = car_st.substring(4,5);
	
	//보험정보
	String ins_st = ai_db.getInsStReg(c_id);
	acar.insur.InsurBean ins = ai_db.getIns(c_id, ins_st);
	if(ins_st.equals("")){
		ins_st = "0";
		ins.setCar_use(String.valueOf(cont.get("CAR_USE")));
	}
	
	
	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;
	
	String client_id = String.valueOf(cont.get("CLIENT_ID"));
	//거래처
	ClientBean client = al_db.getClient(client_id);
	
	//20170202 동부화재 견적
	String s_st_cd = cont.get("S_ST_CD")+"";
	int s_st_pay = 0;
	String s_st_day= "";
	String car_nm = cont.get("CAR_NM")+"";
	/*
	0008	차종소분류	차종소분류
			101		경승용
			102		소형승용
			103		중형승용
			104		대형승용Ⅰ
			105		대형승용Ⅱ
			106		대형승용Ⅲ
			107		대형승용Ⅳ
			201		리무진
			301		중형승용LPG
			302		대형승용LPG
			402		5인승짚 / 2000CC초과
			501		7~8인승 / 2000CC이하
			502		7~8인승 / 2000CC초과
			601		9인승 / 2000CC이하
			602		9인승 / 2000CC초과
			701		11~12인승
			801		1톤이하 화물
			811		2.5톤이하 화물
			821		5톤이하 화물
			901		수입 중형승용
			902		수입 대형승용Ⅰ
			903		수입 대형승용Ⅱ
			904		수입 대형승용Ⅲ
			401		5인승짚 / 2000CC이하

	*/
	if( s_st_cd.equals("100") || s_st_cd.equals("101") || s_st_cd.equals("409") ){
		if(car_nm.contains("스파크")){
			s_st_pay = 547480;
		}else{
			s_st_pay = 566260 ;
		}
	}else if(s_st_cd.equals("102") || s_st_cd.equals("112") ){
		if(car_nm.contains("아반떼")){
			s_st_pay = 639150;
		}else{
			s_st_pay = 598430 ;
		}
	}else if( s_st_cd.equals("103") ){
		if(car_nm.contains("K5")){
			s_st_pay = 588200;
		}else{
			s_st_pay = 552640 ;
		}
	}else if( s_st_cd.equals("104") || s_st_cd.equals("105") ){
		if(car_nm.contains("K7")){
			s_st_pay = 502900;
		}else{
			s_st_pay = 504090 ;
		}
	}else if( s_st_cd.equals("400")){
		if(car_nm.contains("티볼리")){
			s_st_pay = 593710;
		}else{
			s_st_pay = 626960 ;
		}
	}else if( s_st_cd.equals("401")){
		if(car_nm.contains("스포티지")){
			s_st_pay = 604110;
		}else if(car_nm.contains("싼타페")){
			s_st_pay = 552790 ;
		}else if(car_nm.contains("쏘렌토")){
			s_st_pay = 603760;
		}else{
			s_st_pay = 589260;
		}
	}else if( s_st_cd.equals("402")){
		if(car_nm.contains("스포티지")){
			s_st_pay = 604110;
		}else if(car_nm.contains("싼타페")){
			s_st_pay = 552790 ;
		}else if(car_nm.contains("쏘렌토")){
			s_st_pay = 603760;
		}else{
			s_st_pay = 589260;
		}
		s_st_pay = 491810;
	}else if( s_st_cd.equals("501")){
		if(car_nm.contains("K7")){
			s_st_pay = 571250;
		}else{
			s_st_pay = 630190 ;
		}
	}else if(s_st_cd.equals("502") ){
		if(car_nm.contains("싼타페")){
			s_st_pay = 574600;
		}else if(car_nm.contains("쏘렌토")){
			s_st_pay = 571250;
		}else{
			s_st_pay = 591440 ;
		}
	}else if( s_st_cd.equals("601") || s_st_cd.equals("602") ){
		if(car_nm.contains("코란도 투리스모")){
			s_st_pay = 666420;
		}else{
			s_st_pay = 589620 ;
		}
	}else if( s_st_cd.equals("700") ){ //11인승 승합
		//s_st_pay = 622200;
		s_st_pay = 710170;
	}else if( s_st_cd.equals("701") ){ //12인승 승합
		//s_st_pay = 590890;
		s_st_pay = 715190;
	}else if( s_st_cd.equals("803") ){	//1톤이하밴형
		//s_st_pay = 663240;
		s_st_pay = 768860;
	}else if( s_st_cd.equals("801") ){ //1톤이하 일반형
		//s_st_pay = 753960;
		s_st_pay = 839680;
	}else if( s_st_cd.equals("811") ){	//2.5톤이하 화물
		//s_st_pay = 916790;
		s_st_pay = 937900;
	}else if( s_st_cd.equals("821") ){	//5톤이하 화물
		//s_st_pay = 1085790;
		s_st_pay = 1104760;
	}else if( s_st_cd.equals("702")){	//경승합
		//s_st_pay = 520850;
		s_st_pay = 608080;
	}else if( s_st_cd.equals("802") ){ //경화물
		//s_st_pay = 605320;
		s_st_pay = 749930;
	}
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;
		if(fm.m_id.value == '' || fm.l_cd.value == '' || fm.c_id.value == ''){ alert('차량을 선택하십시오.'); return; }

		if(fm.car_use.value == '2' && fm.con_f_nm.value == '아마존카' && replaceString("-","",fm.ins_exp_dt.value).substring(4,8) != '0210'){
			alert('업무용차량 아마존카 피보험자이면 보험만료일은 02월10일이여야 합니다.');
			fm.ins_exp_dt.focus();
			return;
		}
		
		//기간 체크
		if(getRentTime('d', fm.ins_start_dt.value, fm.ins_exp_dt.value) < 0){ 
			if(!confirm('보험기간이 '+fm.ins_start_dt.value+'부터 '+fm.ins_exp_dt.value+' 입니다.\n\n입력하신 값이 이상합니다.\n\n등록하시겠습니까?'))			
				return;
		}		
		
		<%if(ins.getCar_use().equals("2")){%>
		if( (fm.age_scp.value=='2' || fm.age_scp.value=='5' || fm.age_scp.value=='6' || fm.age_scp.value=='7' || fm.age_scp.value=='8') && toInt(parseDigit(fm.insur_y_pay_cha.value)) >= 100000 && fm.con_f_nm.value=='아마존카'){
			if(!confirm("1년치 보험료로 환산한 금액과 보험사 약정금액이 10만원이상 차이납니다. 그래도 등록하시겠습니까?")){	return;	}
		}else if  ( (fm.age_scp.value=='1' || fm.age_scp.value=='4')   && toInt(parseDigit(fm.insur_y_pay_cha.value)) >= 50000  && fm.con_f_nm.value=='아마존카'){
			if(!confirm("1년치 보험료로 환산한 금액과 보험사 약정금액이 5만원이상 차이납니다. 그래도 등록하시겠습니까?")){	return;	}
		}
		<%}%>
		
		
		if(!confirm('등록하시겠습니까?')){	return;	}
		if(toInt(fm.ins_c_id.value) > 0){
			fm.ins_st.value = toInt(fm.ins_st.value)+1;
		}else{
			fm.ins_st.value = toInt(fm.ins_st.value);
		}
		fm.ins_kd.value = fm.s_gubun1.value;
		fm.reg_cau.value = fm.s_gubun3.value;	
		
		fm.ins_com_nm.value = fm.ins_com_id.options[fm.ins_com_id.selectedIndex].text;
		
		
			
		fm.target = 'i_no';
		fm.action = 'ins_reg_a.jsp';
		fm.submit();
	}
	
	//보험료 합계 셋팅
	function set_tot(){
		var fm = document.form1;
		//책임
		fm.tot_amt1.value = fm.rins_pcp_amt.value;
		
//		fm.vins_cacdt_cm_amt.value = parseDecimal(toInt(parseDigit(fm.vins_cacdt_car_amt.value)) + toInt(parseDigit(fm.vins_cacdt_me_amt.value)));
		//임의
		if(fm.s_gubun1.value == '1'){//종합보험
			fm.tot_amt2.value = parseDecimal(toInt(parseDigit(fm.vins_pcp_amt.value))+
											toInt(parseDigit(fm.vins_gcp_amt.value))+
											toInt(parseDigit(fm.vins_bacdt_amt.value))+
											toInt(parseDigit(fm.vins_canoisr_amt.value))+
											toInt(parseDigit(fm.vins_share_extra_amt.value))+
											toInt(parseDigit(fm.vins_cacdt_cm_amt.value))+
											toInt(parseDigit(fm.vins_spe_amt.value)));
		}
		//계
		//fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.tot_amt1.value)) + toInt(parseDigit(fm.tot_amt2.value)) - toInt(parseDigit(fm.vins_blackbox_amt.value)) );
		fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.tot_amt1.value)) + toInt(parseDigit(fm.tot_amt2.value)) );
		
		<%if(ins.getCar_use().equals("2")){%>		set_insur_y_pay();<%}%>
		
	}
	//보험기간 셋팅
	function set_ins_dt(){
		var fm = document.form1;
		var ins_y = toInt(fm.ins_start_dt.value.substr(0,4))+1;			
		if(fm.car_use.value == '2' && fm.con_f_nm.value == '아마존카'){			
			fm.ins_exp_dt.value = ChangeDate(ins_y+'0210');
			
			if(toInt(replaceString('-','',fm.ins_start_dt.value)) < toInt(<%=AddUtil.getDate(1)%>+"0210")){
				fm.ins_exp_dt.value =ChangeDate( fm.ins_start_dt.value.substr(0,4)+'0210');
			}							
		}else{
			fm.ins_exp_dt.value = ChangeDate(ins_y+fm.ins_start_dt.value.substring(4));			
		}
		<%if(ins.getCar_use().equals("2")){%>		set_insur_y_pay();<%}%>
	}

	//하단 디스플레이
	function cng_display(){
		var fm = document.form1;		
		if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '1'){
			tr1.style.display = '';
			tr2.style.display = '';			
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '2'){
			tr1.style.display = 'none';
			tr2.style.display = 'none';	
			fm.age_scp[2].selected = true;//모든운전자	
		}
	}	
	//등록사유 디스플레이
	function change_type()
	{
		var fm = document.form1;
		drop_type();
		if(fm.s_gubun2.value == '1'){
			fm.s_gubun3.options[0] = new Option('신차', '1');
			fm.s_gubun3.options[1] = new Option('용도변경', '2');
			fm.s_gubun3.options[2] = new Option('오프리스', '5');			
		}else if(fm.s_gubun2.value == '2'){
			fm.s_gubun3.options[0] = new Option('만기', '4');
			fm.s_gubun3.options[1] = new Option('담보변경', '3');
		}
	}	
	function drop_type()
	{
		var fm = document.form1;
		var len = fm.s_gubun3.length;
		for(var i = 0 ; i < len ; i++){
			fm.s_gubun3.options[len-(i+1)] = null;
		}
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
			if(idx == 8)  fm.pay_amt.focus();
		}
	}

	//물적사고할증기준 선택에 따라 자기부담금 셋팅
	function setCacdtMeAmt(){
		var fm = document.form1;
		fm.vins_cacdt_memin_amt.value = toInt(fm.vins_cacdt_mebase_amt.value)*0.1;		
		if(toInt(fm.vins_cacdt_mebase_amt.value) >0){
			fm.vins_cacdt_me_amt.value = 50;
		}
	}
	
	//대여일수 구하기
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}			

	function compareEst(){
		var fm = document.form1;
		window.open("about:blank",'compareEst','scrollbars=yes,status=no,resizable=yes,width=1060,height=650,left=370,top=100');		
		fm.action = "/acar/ins_reg/ins_est_cpr.jsp";
		fm.target = "compareEst";
		fm.submit();	
	}			
	
	//만나이계산하기
	function age_search()
	{
		var fm = document.form1;
		
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}	
	<%if(ins.getCar_use().equals("2")){%>
	//20170202 보험료 견적비교 계산
	function set_insur_y_pay()
	{
		var fm = document.form1;
		var dateString1 = fm.ins_start_dt.value;
		var dateString2 = fm.ins_exp_dt.value;
		
		var dateArray1 = dateString1.split("-"); 
		var dateArray2 = dateString2.split("-"); 
		
		var dateObj1 = new Date(dateArray1[0], Number(dateArray1[1])-1, dateArray1[2]); 
		var dateObj2 = new Date(dateArray2[0], Number(dateArray2[1])-1, dateArray2[2]);
		var betweenDay = (dateObj2.getTime() - dateObj1.getTime()) / 1000 / 60 / 60 / 24;
		
		var con = document.getElementById("insur_tr");
		
		if(fm.con_f_nm.value=='아마존카'){
        	con.style.display = '';
    	}else{
        	con.style.display = 'none';
        	
    	}
		fm.insur_c_day.value = betweenDay; 
		if(toInt(fm.insur_c_day.value) >=365 ){
			fm.insur_y_pay.value = parseDecimal(toInt (parseDigit(fm.insur_c_pay.value)));  
			fm.insur_y_pay_cha.value =parseDecimal( toInt (parseDigit(fm.insur_y_pay.value) - parseDigit(fm.insur_c_pay.value)));		
		}else{
			fm.insur_y_pay.value = parseDecimal(toInt(toInt (parseDigit(fm.tot_amt.value) / toInt (fm.insur_c_day.value)) *365));  
			fm.insur_y_pay_cha.value =parseDecimal( toInt (parseDigit(fm.insur_y_pay.value) - parseDigit(fm.insur_c_pay.value)));		
		}
		
		
		
	}	
	<%}%>
	
	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='ins_reg_a.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<!--<input type='hidden' name="s_gubun1" value='<%=s_gubun1%>'>-->
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="ins_st" value='<%=ins_st%>'>
<input type='hidden' name="ins_kd" value='<%=s_gubun1%>'>
<input type='hidden' name="reg_cau" value='<%=s_gubun3%>'>
<input type='hidden' name="ins_c_id" value='<%=ins.getCar_mng_id()%>'>
<input type='hidden' name="car_no" value='<%=cont.get("CAR_NO")%>'>
<input type='hidden' name="gov_nm" value='<%=cont.get("FIRM_NM")%>'>
<input type='hidden' name="bus_id2" value='<%=base.getBus_id2()%>'>
<input type='hidden' name="ins_com_nm" value=''>
<input type='hidden' name="client_id" value='<%=client_id%>'>
<input type='hidden' name="car_nm" value='<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%>'>
<input type='hidden' name="jg_code" value='<%=cont.get("JG_CODE")%>'>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=13%>&nbsp;<%=l_cd%></td>
                    <td class=title width=10%>상호</td>
                    <td width=22%>&nbsp;<%=cont.get("FIRM_NM")%></td>
                    <td class=title width=10%>계약자</td>
                    <td width=12%>&nbsp;<%=cont.get("CLIENT_NM")%></td>
                    <td class=title width=10%>사용본거지</td>
                    <td width=13%>&nbsp;<%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title>차량번호</td>
                    <td>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td class=title>차명</td>
                    <td>&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                    <td class=title>최초등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>차대번호</td>
                    <td>&nbsp;<%=cont.get("CAR_NUM")%></td>
                </tr>
                <tr>
                  <td class=title>계약일자</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                  <td class=title>대여기간</td>
                  <td colspan="5">&nbsp;<%=AddUtil.ChangeDate2(base.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(base.getRent_end_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
		
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약서 약정내용</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>보험계약자</td>
                    <td colspan='5'>&nbsp;<b><%String insurant = cont_etc.getInsurant();%><%if(insurant.equals("1") || insurant.equals("")){%>아마존카<%}else if(insurant.equals("2")){%>고객<%}%></b></td>
                </tr>
                <tr> 
                    <td width="13%"  class=title>피보험자</td>
                    <td width="20%">&nbsp;<b><%String insur_per = cont_etc.getInsur_per();%><%if(insur_per.equals("1") || insur_per.equals("")){%>아마존카<%}else if(insur_per.equals("2")){%>고객<%}%></b></td>
                    <td width="10%" class=title>운전자범위</td>
                    <td width="20%" class=''>&nbsp;<%String driving_ext = base.getDriving_ext();%><%if(driving_ext.equals("1") || driving_ext.equals("")){%>모든사람<%}else if(driving_ext.equals("2")){%>가족한정<%}else if(driving_ext.equals("3")){%>기타<%}%></td>
                    <td width="10%" class=title >운전자연령</td>
                    <td class=''>&nbsp;<b><%String driving_age = base.getDriving_age();%>
                    <%
                    	if(driving_age.equals("0")){%>만26세이상<%}
                    	else if(driving_age.equals("3")){%>만24세이상<%}
                    	else if(driving_age.equals("1")){%>만21세이상<%}
                    	else if(driving_age.equals("5")){%>만30세이상<%}
                    	else if(driving_age.equals("6")){%>만35세이상<%}
                    	else if(driving_age.equals("7")){%>만40세이상<%}
                    	else if(driving_age.equals("2")){%>모든운전자<%}
                    	else if(driving_age.equals("9")){%>만22세이상<%}
                    	else if(driving_age.equals("10")){%>만28세이상<%}
                    	else if(driving_age.equals("11")){%>만35세상~만49세이하<%}
                    %>
                    </b>
                    </td>
                </tr>
                <tr>
                    <td  class=title>대인배상</td>
                    <td>&nbsp;무한(대인배상Ⅰ,Ⅱ)</td>
                    <td class=title>대물배상</td>
                    <td class=''>&nbsp;<%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5천만원<%}else if(gcp_kd.equals("2")){%>1억원<%}else if(gcp_kd.equals("3")){%>5억원<%}else if(gcp_kd.equals("4")){%>2억원<%}else if(gcp_kd.equals("8")){%>3억원<%}%></td>
                    <td class=title >자기신체사고</td>
                    <td class=''>&nbsp;<%String bacdt_kd = base.getBacdt_kd();%><%if(bacdt_kd.equals("1")){%>5천만원<%}else if(bacdt_kd.equals("2")){%>1억원<%}%></td>
                </tr>
                <tr>
                    <td  class=title>무보험차상해</td>
                    <td>&nbsp;<%String canoisr_yn = cont_etc.getCanoisr_yn();%><%if(canoisr_yn.equals("Y")){%>가입<%}else if(canoisr_yn.equals("N")){%>미가입<%}%></td>
                    <td class=title>자기차량손해</td>
                    <td class=''>&nbsp;<%String cacdt_yn = cont_etc.getCacdt_yn();%><%if(cacdt_yn.equals("Y")){%>가입<%}else if(cacdt_yn.equals("N")){%>미가입<%}%></td>
                    <td class=title >긴급출동</td>
                    <td class=''>&nbsp;<%String eme_yn = cont_etc.getEme_yn();%><%if(eme_yn.equals("Y")){%>가입<%}else if(eme_yn.equals("N")){%>미가입<%}%></td>
                </tr>
                <tr>
                    <td  class=title>자차면책금</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(base.getCar_ja())%>원</td>
                    <td class=title>변경사유</td>
                    <td class=''>&nbsp;<%=cont_etc.getJa_reason()%></td>
                    <td class=title >결재자</td>
                    <td class=''>&nbsp;<%=c_db.getNameById(cont_etc.getRea_appr_id(),"USER")%>(기본 <%=AddUtil.parseDecimal(car.getImm_amt())%>원) </td>
                </tr>
                <tr>
                    <td  class=title>자동차</td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="v_air_ds_yn" 	value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%>checked<%}%> disabled>
        				운전석에어백
                      <input type="checkbox" name="v_air_as_yn" 	value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%>checked<%}%> disabled>
        				조수석에어백        	      
                      <input type="checkbox" name="v_blackbox_yn" 	value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%>checked<%}%> disabled>
        				블랙박스
        	     			
        	      <input type="checkbox" name="v_com_emp_yn" 	value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%>checked<%}%> disabled>
        				임직원운전한정특약			
                      </td>
                </tr>
                <tr id=tr_ip style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                    <td  class=title>입보회사</td>
                    <td colspan="5">
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">&nbsp;보험사  :
                                    <input type='text' name='ip_insur' value='<%=cont_etc.getIp_insur()%>' size='12' class='whitetext'>
                      				&nbsp;대리점 : 
                      				<input type='text' name='ip_agent' value='<%=cont_etc.getIp_agent()%>' size='15' class='whitetext'>
                      				&nbsp;담당자 :
                      				<input type='text' name='ip_dam' value='<%=cont_etc.getIp_dam()%>' size='10' class='whitetext'>
                					&nbsp;연락처 :
                					<input type='text' name='ip_tel' value='<%=cont_etc.getIp_tel()%>' size='13' class='whitetext'>
                			    </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id=tr_me style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                    <td  class=title>차량손해</td>
                    <td colspan="5">
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">&nbsp;물적사고할증기준 :
                                    <input type='text' name='cacdt_mebase_amt' value='<%=cont_etc.getCacdt_mebase_amt()%>' size='5' class='whitenum'>만원
                      				&nbsp;&nbsp;&nbsp;최소자기부담금 : 
                      				<input type='text' name='cacdt_memin_amt' value='<%=cont_etc.getCacdt_memin_amt()%>' size='5' class='whitenum'>만원
                      				&nbsp;&nbsp;&nbsp;최대자기부담금 :
                      				<input type='text' name='cacdt_me_amt' value='<%=cont_etc.getCacdt_me_amt()%>' size='5' class='whitenum'>만원
                			    </td>
                            </tr>
                        </table>
                    </td>
                </tr>				
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="5">&nbsp;<%=HtmlUtil.htmlBR(base.getOthers())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험계약</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
			    <tr>
				  <td class=title>보험가입일</td>
				  <td colspan='7'>&nbsp;<input type="text" name="ins_rent_dt" value="<%=AddUtil.getDate()%>" size="11" class="text"  onBlur='javascript:this.value=ChangeDate(this.value);'></td>
				</tr>
                <tr> 
                    <td class=title>등록구분</td>
                    <td> 
                      &nbsp;<select name='s_gubun2' onChange='javascript:change_type()'>
                        <option value="1" <%if(ins.getCar_mng_id().equals("") || s_gubun2.equals("1") || ins_st.equals("0"))%>selected<%%>>신규</option>
                        <option value="2" <%if(!ins.getCar_mng_id().equals("") || s_gubun2.equals("2") || !ins_st.equals("0"))%>selected<%%>>갱신</option>
                      </select>
                    </td>
                    <td class=title>등록사유</td>
                    <td> 
                      &nbsp;<select name='s_gubun3'>
        			  <%if(ins.getCar_mng_id().equals("")){%>
                        <option value="1" <%if(s_gubun3.equals("1"))%>selected<%%>>신차</option>
                        <option value="2" <%if(s_gubun3.equals("2"))%>selected<%%>>용도변경</option>
                        <option value="5" <%if(s_gubun3.equals("5"))%>selected<%%>>오프리스</option>				
        			  <%}else{%>
                        <option value="4" <%if(s_gubun3.equals("4"))%>selected<%%>>만기</option>
                        <option value="3" <%if(s_gubun3.equals("3"))%>selected<%%>>담보변경</option>
        			  <%}%>        			  
                      </select>
                    </td>
                    <td class=title>담보구분</td>
                    <td colspan="3"> 
                      &nbsp;<select name='s_gubun1' onChange='javascript:cng_display()'>
                        <option value="1" <%if(s_gubun1.equals("1"))%>selected<%%>>전담보</option>
                        <option value="2" <%if(s_gubun1.equals("2"))%>selected<%%>>책임보험</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>보험회사</td>
                    <td width=13%> 
                      &nbsp;<select name='ins_com_id'>
                        <%if(ic_size > 0){
							ins.setIns_com_id("0007");
							
							//영업용신규는 렌트카공제조합
							if(ins_st.equals("0") && ins.getCar_use().equals("1")) ins.setIns_com_id("0038");
							
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ins.getIns_com_id().equals(ic.getIns_com_id())){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td class=title width=10%>계약번호</td>
                    <td width=22%> 
                      &nbsp;<input type='text' name='ins_con_no' size='25' class='text'>
                    </td>
                    <td class=title width=10%>계약자</td>
                    <td width=12%> 
					  <%if(ins.getConr_nm().equals("")) 	ins.setConr_nm("아마존카");
					    if(ins.getCon_f_nm().equals("")) 	ins.setCon_f_nm("아마존카");%>
                      &nbsp;<input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='10' class='text'>
                    </td>
                    <td class=title width=10%>피보험자</td>
                    <td width=13%> 
                      &nbsp;<input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='10' class='text' onblur="<%if(ins.getCar_use().equals("2")){%>		set_insur_y_pay();<%}%>">
                    </td>
                </tr>
                <tr> 
                    <td class=title>보험기간</td>
                    <td colspan="3"> 
                    <% String ins_start_dt 	= AddUtil.getDate(1)+"0210";
                       String ins_exp_dt 	= AddUtil.getDate2(1)+1+"0210";

                       ins_start_dt 		= AddUtil.getDate();
                       ins_exp_dt 		= (AddUtil.getDate2(1)+1)+""+AddUtil.getDate(2)+""+AddUtil.getDate(3);

                       //업무용 익년2월10일까지
                       if(cr_bean.getCar_use().equals("2") && !insur_per.equals("2") && !ins.getCon_f_nm().equals("아마존카")){ //업무용
                         ins_exp_dt 	= AddUtil.getDate2(1)+1+"0210";

                         //2월10일이전일때는 당해년도로 함
                         if(AddUtil.parseInt(AddUtil.replace(ins_start_dt,"-","")) < AddUtil.parseInt(AddUtil.getDate(1)+"0210")){
                           ins_exp_dt 	= AddUtil.getDate2(1)+"0210";
                         }
                       }
                    %>
                      &nbsp;<input type="text" name="ins_start_dt" value="<%=AddUtil.ChangeDate2(ins_start_dt)%>" size="11" class="text"  onBlur='javascript:this.value=ChangeDate(this.value); set_ins_dt();'>
                      &nbsp;24시&nbsp;&nbsp;~ &nbsp;&nbsp; 
                      <input type="text" name="ins_exp_dt" value="<%=AddUtil.ChangeDate2(ins_exp_dt)%>" size="11"  class="<%if(ins.getCon_f_nm().equals("아마존카")){%>white<%}%>text"  onBlur='javascript:this.value=ChangeDate(this.value); <%if(ins.getCar_use().equals("2")){%>set_insur_y_pay();<%}%>'>
                      &nbsp;24시 
                      </td>
                    <td class=title>보험종류</td>
                    <td> 
                      &nbsp;<select name='car_use' onChange='javascript:set_ins_dt()'>
                      	<%if(cr_bean.getCar_use().equals("1")){%>
                        <option value='1' <%if(ins.getCar_use().equals("1")){%>selected<%}%>>영업용</option>
                        <%}else{%>
                        <option value='2' <%if(ins.getCar_use().equals("2")){%>selected<%}%>>업무용</option>
                          <%if(insur_per.equals("2") || !ins.getCon_f_nm().equals("아마존카") ){//고객피보험자%>
                          <option value='3' <%if(ins.getCar_use().equals("3")){%>selected<%}%>>개인용</option>
                          <%}%>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>연령범위</td>
                    <td> 
                      &nbsp;<select name='age_scp'>
                        <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>만21세이상</option>
                        <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>만24세이상</option>
                        <option value='2' <%if(ins.getAge_scp().equals("2") || ins.getAge_scp().equals("")){%>selected<%}%>>만26세이상</option>				
                        <option value='3' <%if(ins.getAge_scp().equals("3") || s_gubun1.equals("2")){%>selected<%}%>>모든운전자</option>
                        <option value=''>=피보험자고객=</option>
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>만30세이상</option>
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>만35세이상</option>
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>만43세이상</option>
                        <option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>만48세이상</option>
                        <option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>만22세이상</option>												
                        <option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>만28세이상</option>												
                        <option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>만35세상~만49세이하</option>	
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
                    </td>
                </tr>
                <tr> 
                    <td class=title>자동차 부속</td>
                    <td colspan="3">
                      &nbsp;<input type='checkbox' name='air_ds_yn' value='Y' <%if(ins.getAir_ds_yn().equals("Y")||ins.getCar_mng_id().equals("")){%>checked<%}%>>
                      운전석에어백
                      <input type='checkbox' name='air_as_yn' value='Y' <%if(ins.getAir_as_yn().equals("Y")||ins.getCar_mng_id().equals("")){%>checked<%}%>>
                      조수석에어백
                      <input type="checkbox" name="auto_yn" 	value="Y" <%if(ins.getAuto_yn().equals("Y")){%>checked<%}%> >
                      자동변속기
                      <input type="checkbox" name="abs_yn" 		value="Y" <%if(ins.getAbs_yn().equals("Y")){%>checked<%}%> >
                      ABS장치
                      </td>
                    <td class='title'>가입경력율</td>
                    <td> 
                      &nbsp;<input type='text' name='car_rate' size='5' value='100' class='text'>
                      % </td>
                    <td class='title'>할인할증율</td>
                    <td> 
                      &nbsp;<input type='text' name='ext_rate' size='5' value='61' class='text'>
                      % </td>
                </tr>
                
                 <tr> 
                    <td class=title>임직원운전한정특약</td>
                    <td colspan="9">&nbsp;
                      가입여부
                      <select name='com_emp_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%>selected<%}%>>가입</option>
                          <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp; 임직원임차인
                      <input type="text" class="text" name="firm_emp_nm" value="<%=cont.get("FIRM_NM")%>" size="30">
                      장기구분 
                      <select name='long_emp_yn'>
                          <option value="">선택</option>
                          <option value="Y" selected >장기</option>
                          <option value="N">단기</option>
                      </select>
                      
                       <% 	
                       		if(ins.getLkas_yn().equals(""))	ins.setLkas_yn(cont_etc.getLkas_yn()); 
                       		if(ins.getLdws_yn().equals(""))	ins.setLdws_yn(cont_etc.getLdws_yn()); 
                       		if(ins.getAeb_yn().equals(""))	ins.setAeb_yn(cont_etc.getAeb_yn()); 
                       		if(ins.getFcw_yn().equals(""))	ins.setFcw_yn(cont_etc.getFcw_yn()); 
                       		if(ins.getEv_yn().equals(""))	ins.setEv_yn(cont_etc.getEv_yn()); 
                       		
                     	%>
                      
                         &nbsp; 사업자번호
                      <input type="text" class="text" name="enp_no" value="<%=ins.getEnp_no()%>" size="15">
                      
                          &nbsp; 기타장치
                      <input type="text" class="text" name="others_device" value="<%=ins.getOthers_device()%>" size="15">
                      
                      <br/>
                       &nbsp; 차선이탈(제어형)
                      <select name='lkas_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getLkas_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getLkas_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                      
                       	차선이탈(경고형)
                      <select name='ldws_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getLdws_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getLdws_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; 긴급제동(제어형) 
                      <select name='aeb_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getAeb_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getAeb_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       	 긴급제동(경고형) 
                      <select name='fcw_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getFcw_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getFcw_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; 전기자동차 
                      <select name='ev_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getEv_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getEv_yn().equals("N")){%> selected <%}%>>미가입</option>
                       </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; 견인고리 
                      <select name='hook_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getHook_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getHook_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                      &nbsp;&nbsp;&nbsp;&nbsp; 법률비용지원금(고급형) 
                      <select name='legal_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getLegal_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getLegal_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
		    </td>
                </tr>
                 <tr> 
                    <td class=title>블랙박스특약</td>
                    <td colspan="9">&nbsp;
                      가입여부
                      <% 	if(ins.getBlackbox_yn().equals("") && cont_etc.getBlackbox_yn().equals("Y")) ins.setBlackbox_yn("Y"); 
                      		if(tint3.getTint_yn().equals("Y") && !tint3.getModel_nm().equals("")){
                      			if(!ins.getBlackbox_yn().equals("Y")) ins.setBlackbox_yn("Y");
                      			if(ins.getBlackbox_nm().equals("")) 	ins.setBlackbox_nm(tint3.getCom_nm()+" "+tint3.getModel_nm());
                      			if(ins.getBlackbox_no().equals("")) 	ins.setBlackbox_no(tint3.getSerial_no());
                      			if(ins.getBlackbox_amt() == 0) 				ins.setBlackbox_amt(tint3.getTint_amt());
                      			if(ins.getBlackbox_amt() == 0) 				ins.setBlackbox_amt(92727);
                      			if(ins.getBlackbox_dt().equals("")) 	ins.setBlackbox_dt(tint3.getSup_dt());
                      		}
                      		
                      		if(ins.getBlackbox_amt() == 0){
                      			if(tint.getBlackbox_yn().equals("Y")||tint.getBlackbox_yn().equals("3")||tint.getBlackbox_yn().equals("4")){
                      				ins.setBlackbox_yn("Y");
                      				ins.setBlackbox_nm	(tint.getBlackbox_nm());
                      				ins.setBlackbox_amt	(tint.getBlackbox_amt());
                      				ins.setBlackbox_dt	(tint.getSup_dt());
                      			}
                      		}
                      %>
                      <select name='blackbox_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getBlackbox_yn().equals("Y")){%>selected<%}%>>가입</option>
                          <option value="N" <%if(ins.getBlackbox_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp; 모델명
                      <input type="text" class="text" name="blackbox_nm" value="<%=ins.getBlackbox_nm()%>" size="30">
                       &nbsp; 시리얼번호
                      <input type="text" class="text" name="blackbox_no" value="<%=ins.getBlackbox_no()%>" size="20">
                       &nbsp; 구입가(공급가)
                      <input type="text" class="num" name="blackbox_amt" value="<%=AddUtil.parseDecimal(ins.getBlackbox_amt())%>" size="8">원
                       &nbsp; 설치일자
                      <input type="text" class="text" name="blackbox_dt" value="<%=ins.getBlackbox_dt()%>" size="12">
		    </td>
                </tr>                
                
                
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험청약사항</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<%
		if(base.getCar_st().equals("1") || ins.getCar_use().equals("1")){	//렌트
			ins.setRins_pcp_amt				(AddUtil.parseInt(var1));
			ins.setVins_pcp_amt				(AddUtil.parseInt(var2));
			ins.setVins_gcp_amt				(AddUtil.parseInt(var3));
			ins.setVins_bacdt_amt			(AddUtil.parseInt(var4));
			ins.setVins_canoisr_amt		(AddUtil.parseInt(var5));
			ins.setVins_share_extra_amt	(AddUtil.parseInt(var6));
			if(ins.getIns_com_id().equals("0038")){
				ins.setVins_blackbox_per(var7);
			}
		}else{									//리스
			ins.setRins_pcp_amt			(0);
			ins.setVins_pcp_amt			(0);
			ins.setVins_gcp_amt				(0);
			ins.setVins_bacdt_amt		(0);
			ins.setVins_canoisr_amt		(0);
			ins.setVins_share_extra_amt	(0);
			ins.setVins_blackbox_per	("0");
		}
		
		ins.setVins_cacdt_cm_amt		(0);
		ins.setVins_cacdt_car_amt		(0);
		ins.setVins_cacdt_me_amt		(0);
		ins.setVins_spe				("");
		ins.setVins_spe_amt			(0);
	%>	
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">담보</td>
                    <td class=title width=60%>가입금액</td>
                    <td class=title width=15%>보험료</td>
                </tr>
                <tr> 
                    <td class=title width=10%>책임보험</td>
                    <td class=title width=15%>대인배상Ⅰ</td>
                    <td>&nbsp;자배법 시행령에서 정한 금액</td>
                    <td align="center"> 
                      <input type='text' size='12' name='rins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getRins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(1)"> 원</td>
                </tr>
            </table>
        </td>
    </tr>

    <tr></tr><tr></tr>
    <tr id=tr1 style="display:<%if(s_gubun1.equals("2")){%>none<%}else{%>''<%}%>">
	    <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title rowspan="10" width=10%>임의보험</td>
                    <td class=title colspan="2">대인배상Ⅱ</td>
                    <td width=60%> 
                      &nbsp;<select name='vins_pcp_kd'>
                        <option value='1' <%if(ins.getVins_pcp_kd().equals("1")||ins.getVins_pcp_kd().equals("")){%>selected<%}%>>무한</option>
                        <option value='2' <%if(ins.getVins_pcp_kd().equals("2")){%>selected<%}%>>유한</option>
                      </select>
                    </td>
                    <td align="center" width=15%> 
                      <input type='text' size='12' name='vins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(2)"> 원</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">대물배상&nbsp;&nbsp;</td>
                    <td> 
                      &nbsp;<select name='vins_gcp_kd'>
                        <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5억원</option>
						<option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3억원</option>
						<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2억원</option>
                        <option value='3' <%if(ins.getVins_gcp_kd().equals("3")||ins.getVins_gcp_kd().equals("")){%>selected<%}%>>1억원</option>						
                        <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000만원&nbsp;&nbsp;&nbsp;</option>
                        <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000만원</option>
                        <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500만원</option>
                        <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000만원</option>				
                      </select>
                      (1사고당)</td>
                    <td align="center"> 
                      <input type='text' size='12' class='num' name='vins_gcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_gcp_amt()))%>' onBlur='javascript:this.value=parseDecimal(this.value); set_tot(this)' onKeyDown="javasript:enter(3)">
                      원</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2" colspan="2">자기신체사고</td>
                    <td> 
                      &nbsp;<select name='vins_bacdt_kd'>
                        <option value=""  <%if(ins.getVins_bacdt_kd().equals("")){%>selected<%}%>>선택</option>
                        <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3억원</option>
                        <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1억5천만원</option>
                        <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")||ins.getVins_bacdt_kd().equals("")){%>selected<%}%>>1억원</option>
                        <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000만원</option>
                        <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000만원</option>
                        <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500만원</option>
                        <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>미가입</option>
                      </select>
                      (1인당사망/장해)</td>
                    <td align="center" rowspan="2"> 
                      <input type='text' size='12' name='vins_bacdt_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_bacdt_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(4)">
                      원</td>
                </tr>
                <tr> 
                    <td> 
                      &nbsp;<select name='vins_bacdt_kc2'>
                        <option value=""  <%if(ins.getVins_bacdt_kc2().equals("")){%>selected<%}%>>선택</option>					  
                        <option value="1" <%if(ins.getVins_bacdt_kc2().equals("1")){%>selected<%}%>>3억원</option>
                        <option value="2" <%if(ins.getVins_bacdt_kc2().equals("2")){%>selected<%}%>>1억5천만원</option>
                        <option value="6" <%if(ins.getVins_bacdt_kc2().equals("6")){%>selected<%}%>>1억원</option>
                        <option value="5" <%if(ins.getVins_bacdt_kc2().equals("5")){%>selected<%}%>>5000만원</option>
                        <option value="3" <%if(ins.getVins_bacdt_kc2().equals("3")){%>selected<%}%>>3000만원</option>
                        <option value="4" <%if(ins.getVins_bacdt_kc2().equals("4")||ins.getVins_bacdt_kc2().equals("")){%>selected<%}%>>1500만원</option>
                      </select>
                      (1인당부상)</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">무보험차상해</td>
                    <td></td>
                    <td align="center"> 
                      <input type='text' size='12' name='vins_canoisr_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_canoisr_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(5)">
                      원</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">분담금할증한정</td>
                    <td></td>
                    <td align="center"> 
                      <input type='text' size='12' name='vins_share_extra_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_share_extra_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(5)">
                      원</td>
                </tr>
                <tr> 
                    <td class=title rowspan="3" width=9%>자기차량손해</td>
                    <td class=title width=6%>아마존카</td>
                    <td>&nbsp;<font color="#666666">자차보험료: <%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>원 
                      </font></td>
                    <td align="center" rowspan="3"> 
                      <input type='text' size='12' name='vins_cacdt_cm_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_cm_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(6)">
                      원</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2">보험사</td>
                    <td>&nbsp;차&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;량 
                      &nbsp;<input type='text' size='6' name='vins_cacdt_car_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      만원</td>
                </tr>
                <tr> 
                    <td>&nbsp;물적사고할증기준
					  <select name='vins_cacdt_mebase_amt' onChange="javascript:setCacdtMeAmt();" align="absmiddle">
					    <option value=""    <%if(ins.getVins_cacdt_mebase_amt()==0  ){%>selected<%}%>>선택</option>
					    <option value="50"  <%if(ins.getVins_cacdt_mebase_amt()==50 ){%>selected<%}%>>50만원</option>
					    <option value="100" <%if(ins.getVins_cacdt_mebase_amt()==100){%>selected<%}%>>100만원</option>
					    <option value="150" <%if(ins.getVins_cacdt_mebase_amt()==150){%>selected<%}%>>150만원</option>
					    <option value="200" <%if(ins.getVins_cacdt_mebase_amt()==200){%>selected<%}%>>200만원</option>
					  </select>
					  / (최대)자기부담금 
                      <input type='text' size='6' name='vins_cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      만원 
					  / (최소)자기부담금  
                      <select name='vins_cacdt_memin_amt'>
                        <option value=""   <%if(ins.getVins_cacdt_memin_amt()==0 ){%>selected<%}%>>선택</option>
                        <option value="5"  <%if(ins.getVins_cacdt_memin_amt()==5 ){%>selected<%}%>>5만원</option>
                        <option value="10" <%if(ins.getVins_cacdt_memin_amt()==10){%>selected<%}%>>10만원</option>
                        <option value="15" <%if(ins.getVins_cacdt_memin_amt()==15){%>selected<%}%>>15만원</option>
                        <option value="20" <%if(ins.getVins_cacdt_memin_amt()==20){%>selected<%}%>>20만원</option>
                      </select>                
					</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">특약</td>
                    <td> 
                      &nbsp;<input type='text' size='50' name='vins_spe' value='<%=ins.getVins_spe()%>' class='text' style='IME-MODE: active' onKeyDown="javasript:enter(7)">
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' name='vins_spe_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_spe_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(8)">
                      원</td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr></tr><tr></tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=25%>블랙박스할인특약</td>                    
                    <td width=60%>&nbsp;할인율 <input type='text' size='2' name='vins_blackbox_per' value='<%=ins.getVins_blackbox_per()%>' class='text' style='IME-MODE: active'>%</td>
                    <td width=15% align="center">                         
                    </td>
                </tr>
            </table>
        </td>
    </tr>
        	
    <tr id=tr2 style="display:<%if(s_gubun1.equals("2")){%>none<%}else{%>''<%}%>"> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td></td>
                </tr>
                <tr> 
                    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험료</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                                <td class=title width=10%>총보험료</td>
                                <td width=45%> 
                                &nbsp;<input type='text' name='tot_amt' value='' class='whitenum' size='10' readonly>
                                원(책임:
                                <input type='text' name='tot_amt1' value='' class='whitenum' size='8' readonly>
                                원, 임의:
                                <input type='text' name='tot_amt2' value='' class='whitenum' size='8' readonly>
                                원) </td>
                                <td class=title width=10%>납입방법</td>
                                <td width=35%> 
                                &nbsp;<select name='pay_tm'>
                                  <option value="1">1</option>
                                  <option value="2">2</option>
                                  <option value="3">3</option>
                                  <option value="4">4</option>					  
                                  <option value="6">6</option>
                                </select>
                                회 </td>
                            </tr>
                            <tr> 
                                <td class=title>초회보험료</td>
                                <td> 
                                &nbsp;<input type='text' size='10' name='pay_amt' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                                <td class=title>차기납입일</td>
                                <td> 
                                &nbsp;<input type='text' size='11' name='ins_est_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                                </td>
                            </tr>
                            <%if(ins.getCar_use().equals("2")){%>
                             <tr id="insur_tr"> 
                             	<td class=title  style="color:red;">보험료 견적비교</td>
                                <td colspan="3"  style="color:red; font-weight:bold;">&nbsp;※보험사 약정금액 : <input type='text' size='10' name='insur_c_pay' class='num' value='<%=Util.parseDecimal(s_st_pay)%>' readonly>원&nbsp;&nbsp;&nbsp;
                                		※일자 수 : <input type='text' size='10' name='insur_c_day' class='num' value='' readonly>일&nbsp;&nbsp;&nbsp;
                                		※1년치 보험료 : <input type='text' size='10' name='insur_y_pay' class='num'  value='' readonly>원&nbsp;&nbsp;&nbsp;
                                		※보험료 차액 : <input type='text' size='10' name='insur_y_pay_cha' class='num'  value='' readonly>원&nbsp;&nbsp;&nbsp;
                               			
                               	<input type="button" value="견적비교" onclick="compareEst()">
                               	</td>
                            </tr>
                            <%}%>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
	    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경 안내메일 
	    <input type="checkbox" name="mail_yn" value="Y"  >
	    </span></td>
	<tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td width=10% class=title>메일주소</td>
                    <td width=90%>&nbsp;
        			  <input type='text' name='email' size='65' value='<%=client.getCon_agnt_email()%>' class='text' style='IME-MODE: inactive'>
        			</td>
                </tr>		  	  		         	  	  		  
            </table>
        </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>	
	
    <tr> 	
        <td align="right">
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()'><img src=../images/center/button_reg.gif align=absmiddle border=0></a>
        <%}%>	  
	    </td>
    </tr>
</table>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</form>
<script language="JavaScript">
<!--	
	set_ins_dt();
	set_tot();	
//-->
</script>
</body>
</html>
