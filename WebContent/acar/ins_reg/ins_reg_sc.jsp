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
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
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
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");//�����
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");//��ϱ���
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");//��ϻ���
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "01");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//���� ����
	String var1 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt1");
	String var2 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt2");
	String var3 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt3");
	String var4 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt4");
	String var5 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt5");
	String var6 = e_db.getEstiSikVarCase("1", "", "ins_reg_amt6");
	String var7 = e_db.getEstiSikVarCase("1", "", "ins_reg_per1");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//�ڵ����������
	cr_bean = crd.getCarRegBean(c_id);
	
	//��ǰ����
	TintBean tint 	= t_db.getTint(m_id, l_cd);
	
	TintBean tint3 	= t_db.getCarTint(m_id, l_cd, "3");
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
	if(car_st.length()>5 && !car_st.equals("") )	car_st = car_st.substring(4,5);
	
	//��������
	String ins_st = ai_db.getInsStReg(c_id);
	acar.insur.InsurBean ins = ai_db.getIns(c_id, ins_st);
	if(ins_st.equals("")){
		ins_st = "0";
		ins.setCar_use(String.valueOf(cont.get("CAR_USE")));
	}
	
	
	//����� ����Ʈ
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;
	
	String client_id = String.valueOf(cont.get("CLIENT_ID"));
	//�ŷ�ó
	ClientBean client = al_db.getClient(client_id);
	
	//20170202 ����ȭ�� ����
	String s_st_cd = cont.get("S_ST_CD")+"";
	int s_st_pay = 0;
	String s_st_day= "";
	String car_nm = cont.get("CAR_NM")+"";
	/*
	0008	�����Һз�	�����Һз�
			101		��¿�
			102		�����¿�
			103		�����¿�
			104		�����¿륰
			105		�����¿륱
			106		�����¿륲
			107		�����¿륳
			201		������
			301		�����¿�LPG
			302		�����¿�LPG
			402		5�ν�¤ / 2000CC�ʰ�
			501		7~8�ν� / 2000CC����
			502		7~8�ν� / 2000CC�ʰ�
			601		9�ν� / 2000CC����
			602		9�ν� / 2000CC�ʰ�
			701		11~12�ν�
			801		1������ ȭ��
			811		2.5������ ȭ��
			821		5������ ȭ��
			901		���� �����¿�
			902		���� �����¿륰
			903		���� �����¿륱
			904		���� �����¿륲
			401		5�ν�¤ / 2000CC����

	*/
	if( s_st_cd.equals("100") || s_st_cd.equals("101") || s_st_cd.equals("409") ){
		if(car_nm.contains("����ũ")){
			s_st_pay = 547480;
		}else{
			s_st_pay = 566260 ;
		}
	}else if(s_st_cd.equals("102") || s_st_cd.equals("112") ){
		if(car_nm.contains("�ƹݶ�")){
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
		if(car_nm.contains("Ƽ����")){
			s_st_pay = 593710;
		}else{
			s_st_pay = 626960 ;
		}
	}else if( s_st_cd.equals("401")){
		if(car_nm.contains("����Ƽ��")){
			s_st_pay = 604110;
		}else if(car_nm.contains("��Ÿ��")){
			s_st_pay = 552790 ;
		}else if(car_nm.contains("���")){
			s_st_pay = 603760;
		}else{
			s_st_pay = 589260;
		}
	}else if( s_st_cd.equals("402")){
		if(car_nm.contains("����Ƽ��")){
			s_st_pay = 604110;
		}else if(car_nm.contains("��Ÿ��")){
			s_st_pay = 552790 ;
		}else if(car_nm.contains("���")){
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
		if(car_nm.contains("��Ÿ��")){
			s_st_pay = 574600;
		}else if(car_nm.contains("���")){
			s_st_pay = 571250;
		}else{
			s_st_pay = 591440 ;
		}
	}else if( s_st_cd.equals("601") || s_st_cd.equals("602") ){
		if(car_nm.contains("�ڶ��� ��������")){
			s_st_pay = 666420;
		}else{
			s_st_pay = 589620 ;
		}
	}else if( s_st_cd.equals("700") ){ //11�ν� ����
		//s_st_pay = 622200;
		s_st_pay = 710170;
	}else if( s_st_cd.equals("701") ){ //12�ν� ����
		//s_st_pay = 590890;
		s_st_pay = 715190;
	}else if( s_st_cd.equals("803") ){	//1�����Ϲ���
		//s_st_pay = 663240;
		s_st_pay = 768860;
	}else if( s_st_cd.equals("801") ){ //1������ �Ϲ���
		//s_st_pay = 753960;
		s_st_pay = 839680;
	}else if( s_st_cd.equals("811") ){	//2.5������ ȭ��
		//s_st_pay = 916790;
		s_st_pay = 937900;
	}else if( s_st_cd.equals("821") ){	//5������ ȭ��
		//s_st_pay = 1085790;
		s_st_pay = 1104760;
	}else if( s_st_cd.equals("702")){	//�����
		//s_st_pay = 520850;
		s_st_pay = 608080;
	}else if( s_st_cd.equals("802") ){ //��ȭ��
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
		if(fm.m_id.value == '' || fm.l_cd.value == '' || fm.c_id.value == ''){ alert('������ �����Ͻʽÿ�.'); return; }

		if(fm.car_use.value == '2' && fm.con_f_nm.value == '�Ƹ���ī' && replaceString("-","",fm.ins_exp_dt.value).substring(4,8) != '0210'){
			alert('���������� �Ƹ���ī �Ǻ������̸� ���踸������ 02��10���̿��� �մϴ�.');
			fm.ins_exp_dt.focus();
			return;
		}
		
		//�Ⱓ üũ
		if(getRentTime('d', fm.ins_start_dt.value, fm.ins_exp_dt.value) < 0){ 
			if(!confirm('����Ⱓ�� '+fm.ins_start_dt.value+'���� '+fm.ins_exp_dt.value+' �Դϴ�.\n\n�Է��Ͻ� ���� �̻��մϴ�.\n\n����Ͻðڽ��ϱ�?'))			
				return;
		}		
		
		<%if(ins.getCar_use().equals("2")){%>
		if( (fm.age_scp.value=='2' || fm.age_scp.value=='5' || fm.age_scp.value=='6' || fm.age_scp.value=='7' || fm.age_scp.value=='8') && toInt(parseDigit(fm.insur_y_pay_cha.value)) >= 100000 && fm.con_f_nm.value=='�Ƹ���ī'){
			if(!confirm("1��ġ ������ ȯ���� �ݾװ� ����� �����ݾ��� 10�����̻� ���̳��ϴ�. �׷��� ����Ͻðڽ��ϱ�?")){	return;	}
		}else if  ( (fm.age_scp.value=='1' || fm.age_scp.value=='4')   && toInt(parseDigit(fm.insur_y_pay_cha.value)) >= 50000  && fm.con_f_nm.value=='�Ƹ���ī'){
			if(!confirm("1��ġ ������ ȯ���� �ݾװ� ����� �����ݾ��� 5�����̻� ���̳��ϴ�. �׷��� ����Ͻðڽ��ϱ�?")){	return;	}
		}
		<%}%>
		
		
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
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
	
	//����� �հ� ����
	function set_tot(){
		var fm = document.form1;
		//å��
		fm.tot_amt1.value = fm.rins_pcp_amt.value;
		
//		fm.vins_cacdt_cm_amt.value = parseDecimal(toInt(parseDigit(fm.vins_cacdt_car_amt.value)) + toInt(parseDigit(fm.vins_cacdt_me_amt.value)));
		//����
		if(fm.s_gubun1.value == '1'){//���պ���
			fm.tot_amt2.value = parseDecimal(toInt(parseDigit(fm.vins_pcp_amt.value))+
											toInt(parseDigit(fm.vins_gcp_amt.value))+
											toInt(parseDigit(fm.vins_bacdt_amt.value))+
											toInt(parseDigit(fm.vins_canoisr_amt.value))+
											toInt(parseDigit(fm.vins_share_extra_amt.value))+
											toInt(parseDigit(fm.vins_cacdt_cm_amt.value))+
											toInt(parseDigit(fm.vins_spe_amt.value)));
		}
		//��
		//fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.tot_amt1.value)) + toInt(parseDigit(fm.tot_amt2.value)) - toInt(parseDigit(fm.vins_blackbox_amt.value)) );
		fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.tot_amt1.value)) + toInt(parseDigit(fm.tot_amt2.value)) );
		
		<%if(ins.getCar_use().equals("2")){%>		set_insur_y_pay();<%}%>
		
	}
	//����Ⱓ ����
	function set_ins_dt(){
		var fm = document.form1;
		var ins_y = toInt(fm.ins_start_dt.value.substr(0,4))+1;			
		if(fm.car_use.value == '2' && fm.con_f_nm.value == '�Ƹ���ī'){			
			fm.ins_exp_dt.value = ChangeDate(ins_y+'0210');
			
			if(toInt(replaceString('-','',fm.ins_start_dt.value)) < toInt(<%=AddUtil.getDate(1)%>+"0210")){
				fm.ins_exp_dt.value =ChangeDate( fm.ins_start_dt.value.substr(0,4)+'0210');
			}							
		}else{
			fm.ins_exp_dt.value = ChangeDate(ins_y+fm.ins_start_dt.value.substring(4));			
		}
		<%if(ins.getCar_use().equals("2")){%>		set_insur_y_pay();<%}%>
	}

	//�ϴ� ���÷���
	function cng_display(){
		var fm = document.form1;		
		if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '1'){
			tr1.style.display = '';
			tr2.style.display = '';			
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '2'){
			tr1.style.display = 'none';
			tr2.style.display = 'none';	
			fm.age_scp[2].selected = true;//��������	
		}
	}	
	//��ϻ��� ���÷���
	function change_type()
	{
		var fm = document.form1;
		drop_type();
		if(fm.s_gubun2.value == '1'){
			fm.s_gubun3.options[0] = new Option('����', '1');
			fm.s_gubun3.options[1] = new Option('�뵵����', '2');
			fm.s_gubun3.options[2] = new Option('��������', '5');			
		}else if(fm.s_gubun2.value == '2'){
			fm.s_gubun3.options[0] = new Option('����', '4');
			fm.s_gubun3.options[1] = new Option('�㺸����', '3');
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

	//��������������� ���ÿ� ���� �ڱ�δ�� ����
	function setCacdtMeAmt(){
		var fm = document.form1;
		fm.vins_cacdt_memin_amt.value = toInt(fm.vins_cacdt_mebase_amt.value)*0.1;		
		if(toInt(fm.vins_cacdt_mebase_amt.value) >0){
			fm.vins_cacdt_me_amt.value = 50;
		}
	}
	
	//�뿩�ϼ� ���ϱ�
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
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
	
	//�����̰���ϱ�
	function age_search()
	{
		var fm = document.form1;
		
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}	
	<%if(ins.getCar_use().equals("2")){%>
	//20170202 ����� ������ ���
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
		
		if(fm.con_f_nm.value=='�Ƹ���ī'){
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
                    <td class=title width=10%>����ȣ</td>
                    <td width=13%>&nbsp;<%=l_cd%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=22%>&nbsp;<%=cont.get("FIRM_NM")%></td>
                    <td class=title width=10%>�����</td>
                    <td width=12%>&nbsp;<%=cont.get("CLIENT_NM")%></td>
                    <td class=title width=10%>��뺻����</td>
                    <td width=13%>&nbsp;<%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td class=title>����</td>
                    <td>&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                    <td class=title>���ʵ����</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>�����ȣ</td>
                    <td>&nbsp;<%=cont.get("CAR_NUM")%></td>
                </tr>
                <tr>
                  <td class=title>�������</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                  <td class=title>�뿩�Ⱓ</td>
                  <td colspan="5">&nbsp;<%=AddUtil.ChangeDate2(base.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(base.getRent_end_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
		
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��༭ ��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>��������</td>
                    <td colspan='5'>&nbsp;<b><%String insurant = cont_etc.getInsurant();%><%if(insurant.equals("1") || insurant.equals("")){%>�Ƹ���ī<%}else if(insurant.equals("2")){%>��<%}%></b></td>
                </tr>
                <tr> 
                    <td width="13%"  class=title>�Ǻ�����</td>
                    <td width="20%">&nbsp;<b><%String insur_per = cont_etc.getInsur_per();%><%if(insur_per.equals("1") || insur_per.equals("")){%>�Ƹ���ī<%}else if(insur_per.equals("2")){%>��<%}%></b></td>
                    <td width="10%" class=title>�����ڹ���</td>
                    <td width="20%" class=''>&nbsp;<%String driving_ext = base.getDriving_ext();%><%if(driving_ext.equals("1") || driving_ext.equals("")){%>�����<%}else if(driving_ext.equals("2")){%>��������<%}else if(driving_ext.equals("3")){%>��Ÿ<%}%></td>
                    <td width="10%" class=title >�����ڿ���</td>
                    <td class=''>&nbsp;<b><%String driving_age = base.getDriving_age();%>
                    <%
                    	if(driving_age.equals("0")){%>��26���̻�<%}
                    	else if(driving_age.equals("3")){%>��24���̻�<%}
                    	else if(driving_age.equals("1")){%>��21���̻�<%}
                    	else if(driving_age.equals("5")){%>��30���̻�<%}
                    	else if(driving_age.equals("6")){%>��35���̻�<%}
                    	else if(driving_age.equals("7")){%>��40���̻�<%}
                    	else if(driving_age.equals("2")){%>��������<%}
                    	else if(driving_age.equals("9")){%>��22���̻�<%}
                    	else if(driving_age.equals("10")){%>��28���̻�<%}
                    	else if(driving_age.equals("11")){%>��35����~��49������<%}
                    %>
                    </b>
                    </td>
                </tr>
                <tr>
                    <td  class=title>���ι��</td>
                    <td>&nbsp;����(���ι��,��)</td>
                    <td class=title>�빰���</td>
                    <td class=''>&nbsp;<%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5õ����<%}else if(gcp_kd.equals("2")){%>1���<%}else if(gcp_kd.equals("3")){%>5���<%}else if(gcp_kd.equals("4")){%>2���<%}else if(gcp_kd.equals("8")){%>3���<%}%></td>
                    <td class=title >�ڱ��ü���</td>
                    <td class=''>&nbsp;<%String bacdt_kd = base.getBacdt_kd();%><%if(bacdt_kd.equals("1")){%>5õ����<%}else if(bacdt_kd.equals("2")){%>1���<%}%></td>
                </tr>
                <tr>
                    <td  class=title>������������</td>
                    <td>&nbsp;<%String canoisr_yn = cont_etc.getCanoisr_yn();%><%if(canoisr_yn.equals("Y")){%>����<%}else if(canoisr_yn.equals("N")){%>�̰���<%}%></td>
                    <td class=title>�ڱ���������</td>
                    <td class=''>&nbsp;<%String cacdt_yn = cont_etc.getCacdt_yn();%><%if(cacdt_yn.equals("Y")){%>����<%}else if(cacdt_yn.equals("N")){%>�̰���<%}%></td>
                    <td class=title >����⵿</td>
                    <td class=''>&nbsp;<%String eme_yn = cont_etc.getEme_yn();%><%if(eme_yn.equals("Y")){%>����<%}else if(eme_yn.equals("N")){%>�̰���<%}%></td>
                </tr>
                <tr>
                    <td  class=title>������å��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(base.getCar_ja())%>��</td>
                    <td class=title>�������</td>
                    <td class=''>&nbsp;<%=cont_etc.getJa_reason()%></td>
                    <td class=title >������</td>
                    <td class=''>&nbsp;<%=c_db.getNameById(cont_etc.getRea_appr_id(),"USER")%>(�⺻ <%=AddUtil.parseDecimal(car.getImm_amt())%>��) </td>
                </tr>
                <tr>
                    <td  class=title>�ڵ���</td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="v_air_ds_yn" 	value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%>checked<%}%> disabled>
        				�����������
                      <input type="checkbox" name="v_air_as_yn" 	value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%>checked<%}%> disabled>
        				�����������        	      
                      <input type="checkbox" name="v_blackbox_yn" 	value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%>checked<%}%> disabled>
        				���ڽ�
        	     			
        	      <input type="checkbox" name="v_com_emp_yn" 	value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%>checked<%}%> disabled>
        				��������������Ư��			
                      </td>
                </tr>
                <tr id=tr_ip style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                    <td  class=title>�Ժ�ȸ��</td>
                    <td colspan="5">
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">&nbsp;�����  :
                                    <input type='text' name='ip_insur' value='<%=cont_etc.getIp_insur()%>' size='12' class='whitetext'>
                      				&nbsp;�븮�� : 
                      				<input type='text' name='ip_agent' value='<%=cont_etc.getIp_agent()%>' size='15' class='whitetext'>
                      				&nbsp;����� :
                      				<input type='text' name='ip_dam' value='<%=cont_etc.getIp_dam()%>' size='10' class='whitetext'>
                					&nbsp;����ó :
                					<input type='text' name='ip_tel' value='<%=cont_etc.getIp_tel()%>' size='13' class='whitetext'>
                			    </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id=tr_me style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                    <td  class=title>��������</td>
                    <td colspan="5">
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">&nbsp;��������������� :
                                    <input type='text' name='cacdt_mebase_amt' value='<%=cont_etc.getCacdt_mebase_amt()%>' size='5' class='whitenum'>����
                      				&nbsp;&nbsp;&nbsp;�ּ��ڱ�δ�� : 
                      				<input type='text' name='cacdt_memin_amt' value='<%=cont_etc.getCacdt_memin_amt()%>' size='5' class='whitenum'>����
                      				&nbsp;&nbsp;&nbsp;�ִ��ڱ�δ�� :
                      				<input type='text' name='cacdt_me_amt' value='<%=cont_etc.getCacdt_me_amt()%>' size='5' class='whitenum'>����
                			    </td>
                            </tr>
                        </table>
                    </td>
                </tr>				
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;<%=HtmlUtil.htmlBR(base.getOthers())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
			    <tr>
				  <td class=title>���谡����</td>
				  <td colspan='7'>&nbsp;<input type="text" name="ins_rent_dt" value="<%=AddUtil.getDate()%>" size="11" class="text"  onBlur='javascript:this.value=ChangeDate(this.value);'></td>
				</tr>
                <tr> 
                    <td class=title>��ϱ���</td>
                    <td> 
                      &nbsp;<select name='s_gubun2' onChange='javascript:change_type()'>
                        <option value="1" <%if(ins.getCar_mng_id().equals("") || s_gubun2.equals("1") || ins_st.equals("0"))%>selected<%%>>�ű�</option>
                        <option value="2" <%if(!ins.getCar_mng_id().equals("") || s_gubun2.equals("2") || !ins_st.equals("0"))%>selected<%%>>����</option>
                      </select>
                    </td>
                    <td class=title>��ϻ���</td>
                    <td> 
                      &nbsp;<select name='s_gubun3'>
        			  <%if(ins.getCar_mng_id().equals("")){%>
                        <option value="1" <%if(s_gubun3.equals("1"))%>selected<%%>>����</option>
                        <option value="2" <%if(s_gubun3.equals("2"))%>selected<%%>>�뵵����</option>
                        <option value="5" <%if(s_gubun3.equals("5"))%>selected<%%>>��������</option>				
        			  <%}else{%>
                        <option value="4" <%if(s_gubun3.equals("4"))%>selected<%%>>����</option>
                        <option value="3" <%if(s_gubun3.equals("3"))%>selected<%%>>�㺸����</option>
        			  <%}%>        			  
                      </select>
                    </td>
                    <td class=title>�㺸����</td>
                    <td colspan="3"> 
                      &nbsp;<select name='s_gubun1' onChange='javascript:cng_display()'>
                        <option value="1" <%if(s_gubun1.equals("1"))%>selected<%%>>���㺸</option>
                        <option value="2" <%if(s_gubun1.equals("2"))%>selected<%%>>å�Ӻ���</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>����ȸ��</td>
                    <td width=13%> 
                      &nbsp;<select name='ins_com_id'>
                        <%if(ic_size > 0){
							ins.setIns_com_id("0007");
							
							//������űԴ� ��Ʈī��������
							if(ins_st.equals("0") && ins.getCar_use().equals("1")) ins.setIns_com_id("0038");
							
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ins.getIns_com_id().equals(ic.getIns_com_id())){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td class=title width=10%>����ȣ</td>
                    <td width=22%> 
                      &nbsp;<input type='text' name='ins_con_no' size='25' class='text'>
                    </td>
                    <td class=title width=10%>�����</td>
                    <td width=12%> 
					  <%if(ins.getConr_nm().equals("")) 	ins.setConr_nm("�Ƹ���ī");
					    if(ins.getCon_f_nm().equals("")) 	ins.setCon_f_nm("�Ƹ���ī");%>
                      &nbsp;<input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='10' class='text'>
                    </td>
                    <td class=title width=10%>�Ǻ�����</td>
                    <td width=13%> 
                      &nbsp;<input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='10' class='text' onblur="<%if(ins.getCar_use().equals("2")){%>		set_insur_y_pay();<%}%>">
                    </td>
                </tr>
                <tr> 
                    <td class=title>����Ⱓ</td>
                    <td colspan="3"> 
                    <% String ins_start_dt 	= AddUtil.getDate(1)+"0210";
                       String ins_exp_dt 	= AddUtil.getDate2(1)+1+"0210";

                       ins_start_dt 		= AddUtil.getDate();
                       ins_exp_dt 		= (AddUtil.getDate2(1)+1)+""+AddUtil.getDate(2)+""+AddUtil.getDate(3);

                       //������ �ͳ�2��10�ϱ���
                       if(cr_bean.getCar_use().equals("2") && !insur_per.equals("2") && !ins.getCon_f_nm().equals("�Ƹ���ī")){ //������
                         ins_exp_dt 	= AddUtil.getDate2(1)+1+"0210";

                         //2��10�������϶��� ���س⵵�� ��
                         if(AddUtil.parseInt(AddUtil.replace(ins_start_dt,"-","")) < AddUtil.parseInt(AddUtil.getDate(1)+"0210")){
                           ins_exp_dt 	= AddUtil.getDate2(1)+"0210";
                         }
                       }
                    %>
                      &nbsp;<input type="text" name="ins_start_dt" value="<%=AddUtil.ChangeDate2(ins_start_dt)%>" size="11" class="text"  onBlur='javascript:this.value=ChangeDate(this.value); set_ins_dt();'>
                      &nbsp;24��&nbsp;&nbsp;~ &nbsp;&nbsp; 
                      <input type="text" name="ins_exp_dt" value="<%=AddUtil.ChangeDate2(ins_exp_dt)%>" size="11"  class="<%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%>white<%}%>text"  onBlur='javascript:this.value=ChangeDate(this.value); <%if(ins.getCar_use().equals("2")){%>set_insur_y_pay();<%}%>'>
                      &nbsp;24�� 
                      </td>
                    <td class=title>��������</td>
                    <td> 
                      &nbsp;<select name='car_use' onChange='javascript:set_ins_dt()'>
                      	<%if(cr_bean.getCar_use().equals("1")){%>
                        <option value='1' <%if(ins.getCar_use().equals("1")){%>selected<%}%>>������</option>
                        <%}else{%>
                        <option value='2' <%if(ins.getCar_use().equals("2")){%>selected<%}%>>������</option>
                          <%if(insur_per.equals("2") || !ins.getCon_f_nm().equals("�Ƹ���ī") ){//���Ǻ�����%>
                          <option value='3' <%if(ins.getCar_use().equals("3")){%>selected<%}%>>���ο�</option>
                          <%}%>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>���ɹ���</td>
                    <td> 
                      &nbsp;<select name='age_scp'>
                        <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>��21���̻�</option>
                        <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>��24���̻�</option>
                        <option value='2' <%if(ins.getAge_scp().equals("2") || ins.getAge_scp().equals("")){%>selected<%}%>>��26���̻�</option>				
                        <option value='3' <%if(ins.getAge_scp().equals("3") || s_gubun1.equals("2")){%>selected<%}%>>��������</option>
                        <option value=''>=�Ǻ����ڰ�=</option>
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>��30���̻�</option>
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>��35���̻�</option>
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>��43���̻�</option>
                        <option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>��48���̻�</option>
                        <option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>��22���̻�</option>												
                        <option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>��28���̻�</option>												
                        <option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>��35����~��49������</option>	
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�ڵ��� �μ�</td>
                    <td colspan="3">
                      &nbsp;<input type='checkbox' name='air_ds_yn' value='Y' <%if(ins.getAir_ds_yn().equals("Y")||ins.getCar_mng_id().equals("")){%>checked<%}%>>
                      �����������
                      <input type='checkbox' name='air_as_yn' value='Y' <%if(ins.getAir_as_yn().equals("Y")||ins.getCar_mng_id().equals("")){%>checked<%}%>>
                      �����������
                      <input type="checkbox" name="auto_yn" 	value="Y" <%if(ins.getAuto_yn().equals("Y")){%>checked<%}%> >
                      �ڵ����ӱ�
                      <input type="checkbox" name="abs_yn" 		value="Y" <%if(ins.getAbs_yn().equals("Y")){%>checked<%}%> >
                      ABS��ġ
                      </td>
                    <td class='title'>���԰����</td>
                    <td> 
                      &nbsp;<input type='text' name='car_rate' size='5' value='100' class='text'>
                      % </td>
                    <td class='title'>����������</td>
                    <td> 
                      &nbsp;<input type='text' name='ext_rate' size='5' value='61' class='text'>
                      % </td>
                </tr>
                
                 <tr> 
                    <td class=title>��������������Ư��</td>
                    <td colspan="9">&nbsp;
                      ���Կ���
                      <select name='com_emp_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%>selected<%}%>>����</option>
                          <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
                       &nbsp; ������������
                      <input type="text" class="text" name="firm_emp_nm" value="<%=cont.get("FIRM_NM")%>" size="30">
                      ��ⱸ�� 
                      <select name='long_emp_yn'>
                          <option value="">����</option>
                          <option value="Y" selected >���</option>
                          <option value="N">�ܱ�</option>
                      </select>
                      
                       <% 	
                       		if(ins.getLkas_yn().equals(""))	ins.setLkas_yn(cont_etc.getLkas_yn()); 
                       		if(ins.getLdws_yn().equals(""))	ins.setLdws_yn(cont_etc.getLdws_yn()); 
                       		if(ins.getAeb_yn().equals(""))	ins.setAeb_yn(cont_etc.getAeb_yn()); 
                       		if(ins.getFcw_yn().equals(""))	ins.setFcw_yn(cont_etc.getFcw_yn()); 
                       		if(ins.getEv_yn().equals(""))	ins.setEv_yn(cont_etc.getEv_yn()); 
                       		
                     	%>
                      
                         &nbsp; ����ڹ�ȣ
                      <input type="text" class="text" name="enp_no" value="<%=ins.getEnp_no()%>" size="15">
                      
                          &nbsp; ��Ÿ��ġ
                      <input type="text" class="text" name="others_device" value="<%=ins.getOthers_device()%>" size="15">
                      
                      <br/>
                       &nbsp; ������Ż(������)
                      <select name='lkas_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getLkas_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getLkas_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
                      
                       	������Ż(�����)
                      <select name='ldws_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getLdws_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getLdws_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; �������(������) 
                      <select name='aeb_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getAeb_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getAeb_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
                       	 �������(�����) 
                      <select name='fcw_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getFcw_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getFcw_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; �����ڵ��� 
                      <select name='ev_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getEv_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getEv_yn().equals("N")){%> selected <%}%>>�̰���</option>
                       </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; ���ΰ� 
                      <select name='hook_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getHook_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getHook_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
                      &nbsp;&nbsp;&nbsp;&nbsp; �������������(�����) 
                      <select name='legal_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getLegal_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getLegal_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
		    </td>
                </tr>
                 <tr> 
                    <td class=title>���ڽ�Ư��</td>
                    <td colspan="9">&nbsp;
                      ���Կ���
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
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getBlackbox_yn().equals("Y")){%>selected<%}%>>����</option>
                          <option value="N" <%if(ins.getBlackbox_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
                       &nbsp; �𵨸�
                      <input type="text" class="text" name="blackbox_nm" value="<%=ins.getBlackbox_nm()%>" size="30">
                       &nbsp; �ø����ȣ
                      <input type="text" class="text" name="blackbox_no" value="<%=ins.getBlackbox_no()%>" size="20">
                       &nbsp; ���԰�(���ް�)
                      <input type="text" class="num" name="blackbox_amt" value="<%=AddUtil.parseDecimal(ins.getBlackbox_amt())%>" size="8">��
                       &nbsp; ��ġ����
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
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����û�����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<%
		if(base.getCar_st().equals("1") || ins.getCar_use().equals("1")){	//��Ʈ
			ins.setRins_pcp_amt				(AddUtil.parseInt(var1));
			ins.setVins_pcp_amt				(AddUtil.parseInt(var2));
			ins.setVins_gcp_amt				(AddUtil.parseInt(var3));
			ins.setVins_bacdt_amt			(AddUtil.parseInt(var4));
			ins.setVins_canoisr_amt		(AddUtil.parseInt(var5));
			ins.setVins_share_extra_amt	(AddUtil.parseInt(var6));
			if(ins.getIns_com_id().equals("0038")){
				ins.setVins_blackbox_per(var7);
			}
		}else{									//����
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
                    <td class=title colspan="2">�㺸</td>
                    <td class=title width=60%>���Աݾ�</td>
                    <td class=title width=15%>�����</td>
                </tr>
                <tr> 
                    <td class=title width=10%>å�Ӻ���</td>
                    <td class=title width=15%>���ι��</td>
                    <td>&nbsp;�ڹ�� ����ɿ��� ���� �ݾ�</td>
                    <td align="center"> 
                      <input type='text' size='12' name='rins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getRins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(1)"> ��</td>
                </tr>
            </table>
        </td>
    </tr>

    <tr></tr><tr></tr>
    <tr id=tr1 style="display:<%if(s_gubun1.equals("2")){%>none<%}else{%>''<%}%>">
	    <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title rowspan="10" width=10%>���Ǻ���</td>
                    <td class=title colspan="2">���ι��</td>
                    <td width=60%> 
                      &nbsp;<select name='vins_pcp_kd'>
                        <option value='1' <%if(ins.getVins_pcp_kd().equals("1")||ins.getVins_pcp_kd().equals("")){%>selected<%}%>>����</option>
                        <option value='2' <%if(ins.getVins_pcp_kd().equals("2")){%>selected<%}%>>����</option>
                      </select>
                    </td>
                    <td align="center" width=15%> 
                      <input type='text' size='12' name='vins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(2)"> ��</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">�빰���&nbsp;&nbsp;</td>
                    <td> 
                      &nbsp;<select name='vins_gcp_kd'>
                        <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5���</option>
						<option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3���</option>
						<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2���</option>
                        <option value='3' <%if(ins.getVins_gcp_kd().equals("3")||ins.getVins_gcp_kd().equals("")){%>selected<%}%>>1���</option>						
                        <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000����&nbsp;&nbsp;&nbsp;</option>
                        <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000����</option>
                        <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500����</option>
                        <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000����</option>				
                      </select>
                      (1����)</td>
                    <td align="center"> 
                      <input type='text' size='12' class='num' name='vins_gcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_gcp_amt()))%>' onBlur='javascript:this.value=parseDecimal(this.value); set_tot(this)' onKeyDown="javasript:enter(3)">
                      ��</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2" colspan="2">�ڱ��ü���</td>
                    <td> 
                      &nbsp;<select name='vins_bacdt_kd'>
                        <option value=""  <%if(ins.getVins_bacdt_kd().equals("")){%>selected<%}%>>����</option>
                        <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3���</option>
                        <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1��5õ����</option>
                        <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")||ins.getVins_bacdt_kd().equals("")){%>selected<%}%>>1���</option>
                        <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000����</option>
                        <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000����</option>
                        <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500����</option>
                        <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>�̰���</option>
                      </select>
                      (1�δ���/����)</td>
                    <td align="center" rowspan="2"> 
                      <input type='text' size='12' name='vins_bacdt_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_bacdt_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(4)">
                      ��</td>
                </tr>
                <tr> 
                    <td> 
                      &nbsp;<select name='vins_bacdt_kc2'>
                        <option value=""  <%if(ins.getVins_bacdt_kc2().equals("")){%>selected<%}%>>����</option>					  
                        <option value="1" <%if(ins.getVins_bacdt_kc2().equals("1")){%>selected<%}%>>3���</option>
                        <option value="2" <%if(ins.getVins_bacdt_kc2().equals("2")){%>selected<%}%>>1��5õ����</option>
                        <option value="6" <%if(ins.getVins_bacdt_kc2().equals("6")){%>selected<%}%>>1���</option>
                        <option value="5" <%if(ins.getVins_bacdt_kc2().equals("5")){%>selected<%}%>>5000����</option>
                        <option value="3" <%if(ins.getVins_bacdt_kc2().equals("3")){%>selected<%}%>>3000����</option>
                        <option value="4" <%if(ins.getVins_bacdt_kc2().equals("4")||ins.getVins_bacdt_kc2().equals("")){%>selected<%}%>>1500����</option>
                      </select>
                      (1�δ�λ�)</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">������������</td>
                    <td></td>
                    <td align="center"> 
                      <input type='text' size='12' name='vins_canoisr_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_canoisr_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(5)">
                      ��</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">�д����������</td>
                    <td></td>
                    <td align="center"> 
                      <input type='text' size='12' name='vins_share_extra_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_share_extra_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(5)">
                      ��</td>
                </tr>
                <tr> 
                    <td class=title rowspan="3" width=9%>�ڱ���������</td>
                    <td class=title width=6%>�Ƹ���ī</td>
                    <td>&nbsp;<font color="#666666">���������: <%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>�� 
                      </font></td>
                    <td align="center" rowspan="3"> 
                      <input type='text' size='12' name='vins_cacdt_cm_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_cm_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(6)">
                      ��</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2">�����</td>
                    <td>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� 
                      &nbsp;<input type='text' size='6' name='vins_cacdt_car_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ����</td>
                </tr>
                <tr> 
                    <td>&nbsp;���������������
					  <select name='vins_cacdt_mebase_amt' onChange="javascript:setCacdtMeAmt();" align="absmiddle">
					    <option value=""    <%if(ins.getVins_cacdt_mebase_amt()==0  ){%>selected<%}%>>����</option>
					    <option value="50"  <%if(ins.getVins_cacdt_mebase_amt()==50 ){%>selected<%}%>>50����</option>
					    <option value="100" <%if(ins.getVins_cacdt_mebase_amt()==100){%>selected<%}%>>100����</option>
					    <option value="150" <%if(ins.getVins_cacdt_mebase_amt()==150){%>selected<%}%>>150����</option>
					    <option value="200" <%if(ins.getVins_cacdt_mebase_amt()==200){%>selected<%}%>>200����</option>
					  </select>
					  / (�ִ�)�ڱ�δ�� 
                      <input type='text' size='6' name='vins_cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      ���� 
					  / (�ּ�)�ڱ�δ��  
                      <select name='vins_cacdt_memin_amt'>
                        <option value=""   <%if(ins.getVins_cacdt_memin_amt()==0 ){%>selected<%}%>>����</option>
                        <option value="5"  <%if(ins.getVins_cacdt_memin_amt()==5 ){%>selected<%}%>>5����</option>
                        <option value="10" <%if(ins.getVins_cacdt_memin_amt()==10){%>selected<%}%>>10����</option>
                        <option value="15" <%if(ins.getVins_cacdt_memin_amt()==15){%>selected<%}%>>15����</option>
                        <option value="20" <%if(ins.getVins_cacdt_memin_amt()==20){%>selected<%}%>>20����</option>
                      </select>                
					</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">Ư��</td>
                    <td> 
                      &nbsp;<input type='text' size='50' name='vins_spe' value='<%=ins.getVins_spe()%>' class='text' style='IME-MODE: active' onKeyDown="javasript:enter(7)">
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' name='vins_spe_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_spe_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(8)">
                      ��</td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr></tr><tr></tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=25%>���ڽ�����Ư��</td>                    
                    <td width=60%>&nbsp;������ <input type='text' size='2' name='vins_blackbox_per' value='<%=ins.getVins_blackbox_per()%>' class='text' style='IME-MODE: active'>%</td>
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
                    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                                <td class=title width=10%>�Ѻ����</td>
                                <td width=45%> 
                                &nbsp;<input type='text' name='tot_amt' value='' class='whitenum' size='10' readonly>
                                ��(å��:
                                <input type='text' name='tot_amt1' value='' class='whitenum' size='8' readonly>
                                ��, ����:
                                <input type='text' name='tot_amt2' value='' class='whitenum' size='8' readonly>
                                ��) </td>
                                <td class=title width=10%>���Թ��</td>
                                <td width=35%> 
                                &nbsp;<select name='pay_tm'>
                                  <option value="1">1</option>
                                  <option value="2">2</option>
                                  <option value="3">3</option>
                                  <option value="4">4</option>					  
                                  <option value="6">6</option>
                                </select>
                                ȸ </td>
                            </tr>
                            <tr> 
                                <td class=title>��ȸ�����</td>
                                <td> 
                                &nbsp;<input type='text' size='10' name='pay_amt' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                                <td class=title>���ⳳ����</td>
                                <td> 
                                &nbsp;<input type='text' size='11' name='ins_est_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                                </td>
                            </tr>
                            <%if(ins.getCar_use().equals("2")){%>
                             <tr id="insur_tr"> 
                             	<td class=title  style="color:red;">����� ������</td>
                                <td colspan="3"  style="color:red; font-weight:bold;">&nbsp;�غ���� �����ݾ� : <input type='text' size='10' name='insur_c_pay' class='num' value='<%=Util.parseDecimal(s_st_pay)%>' readonly>��&nbsp;&nbsp;&nbsp;
                                		������ �� : <input type='text' size='10' name='insur_c_day' class='num' value='' readonly>��&nbsp;&nbsp;&nbsp;
                                		��1��ġ ����� : <input type='text' size='10' name='insur_y_pay' class='num'  value='' readonly>��&nbsp;&nbsp;&nbsp;
                                		�غ���� ���� : <input type='text' size='10' name='insur_y_pay_cha' class='num'  value='' readonly>��&nbsp;&nbsp;&nbsp;
                               			
                               	<input type="button" value="������" onclick="compareEst()">
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
	    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� �ȳ����� 
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
                    <td width=10% class=title>�����ּ�</td>
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
