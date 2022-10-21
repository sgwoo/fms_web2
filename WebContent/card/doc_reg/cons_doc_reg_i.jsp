<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.serv_off.*,acar.car_service.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	//�������������� ����� ���
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_dt = request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String tot_amt = request.getParameter("tot_amt")==null?"":request.getParameter("tot_amt");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");   //Ź�ۿ��� ����� ����ȣ
	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String buy_user_id = "";
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String acct_code_s = "";
	String strNm	=	request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	String user_su = request.getParameter("user_su")==null?"":request.getParameter("user_su");
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	
	String sender_pos 	= request.getParameter("sender_pos")==null?"":request.getParameter("sender_pos");
	String sender_nm 	= request.getParameter("sender_nm")==null?"":request.getParameter("sender_nm");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");  //Ź�� ����
	String gubun 	= request.getParameter("gubun")==null?"o":request.getParameter("gubun");  //���� : o-> oil, w->wash
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	ServOffDatabase sod = ServOffDatabase.getInstance();

	//ī�� ����Ʈ ��ȸ
	Vector vts = CardDb.getCardUserList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, user_id, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
	
		
	//�ܱ��� �Ѱ� ��ȸ-�������������� ���� ����
	Hashtable res = CardDb.getRentContCase(user_id);
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "10", "06");
		
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	String ven_code = "";
	String ven_name = "";
	
	//�����ü
	if(!off_id.equals("")){
		so_bean = sod.getServOff(off_id);
		
		ven_code = neoe_db.getVenCode2(AddUtil.replace(so_bean.getEnt_no(),"-",""), AddUtil.replace(so_bean.getEnt_no(),"-",""));//-> neoe_db ��ȯ
	}
	
	if(!ven_code.equals("")){
		Hashtable vendor = neoe_db.getVendorCase(ven_code);//-> neoe_db ��ȯ
		ven_name = String.valueOf(vendor.get("VEN_NAME"));
	}
	
	String acct_code = "";
	if ( gubun.equals("o")) { 
		acct_code ="00004";  //������
	} else {
		acct_code ="00005";  //����� - ���� 
	}	
	
	String display = "";
	
	String card_file = "";
	
	//����Ÿ� ��������
	CarServDatabase csd = CarServDatabase.getInstance();	
	Hashtable ht9 = csd.getCarInfo(String.valueOf(res.get("CAR_MNG_ID")));
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

	//���
	function Save()
	{
		var fm = document.form1;
	
	
		//��¥�� ���糯¥ ������ �� ����.			
		if ( toInt(replaceString("-","",fm.buy_dt.value)) > toInt(replaceString("-","",fm.cur_dt.value)) ) {	alert('�ŷ����ڸ� Ȯ���Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		
		//�Է��� ������ �ʹ� ���Ƽ� �ϴ� �߰���.
		//if(parseInt(fm.buy_dt.value.substring(0,4)) != <%=AddUtil.getDate(1)%>){ alert('���س⵵ ��ǥ�� �Է� �����մϴ�.'); return;}		
		
		if(fm.cardno.value == '')	{	alert('ī���ȣ�� �Է��Ͻʽÿ�.'); 	fm.cardno.focus(); 		return; }
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڸ� �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.buy_s_amt.value == '0'){	alert('�ŷ��ݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_s_amt.focus(); 	return; }
		if(fm.buy_amt.value == '0'){	alert('�ŷ��ݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_amt.focus(); 	return; }		
		if(fm.ven_name.value == ''){	alert('�ŷ�ó�� �Է��Ͻʽÿ�.'); 	fm.ven_name.focus(); 	return; }
		if(fm.buy_v_amt.value != '0' && fm.ven_code.value == ''){	alert('�ŷ�ó�� ��ȸ�Ͻʽÿ�?'); return; }
		
		//���ݿ�������ȣ ���ý� ���ι�ȣ �Է��ϵ��� ����
		if(fm.cardno.value == '1111-1111-1111-1111' && fm.siokno.value == '' )	{	alert('���ݿ����� ���ι�ȣ�� �Է��Ͻʽÿ�.'); 	fm.siokno.focus(); 		return; }
		
		if ( fm.cardno.value == '0000-0000-0000-0000' || fm.cardno.value == '9410-4991-0759-0613'  ) {
		
		} else {
			if(parseInt(fm.buy_dt.value.substring(0,4)) >= '2012'){
		
			}
		}
				
		if(fm.user_nm.value == '' || fm.buy_user_id.value == ''){	alert('����ڸ� �˻��Ͻʽÿ�.'); return; }	
		
		if ( fm.acct_code.value == "00004" ) { 
			if ( fm.oil_liter.value == '' || fm.oil_liter.value == '0' ||  toInt(parseDigit(fm.oil_liter.value)) == 0   ) { alert('�������� �Է��Ͻʽÿ�.'); return;}
			if ( toInt(parseDigit(fm.oil_liter.value)) > 75   ) { alert('�������� �ٽ� �ѹ� Ȯ���Ͻñ� �ٶ��ϴ�.'); }
	
			//����Ÿ�
			if ( fm.tot_dist.value == '' || fm.tot_dist.value == '0' ||  toInt(parseDigit(fm.tot_dist.value)) == 0   ) { alert('����Ÿ��� �Է��Ͻʽÿ�.'); return;}
			
		}
		
		//����, ����, ���, ��ݺ�� �ݵ�� ���� ��ȸ�Ͽ� car_mng_id ���Ѵ�.
	   	if ( fm.item_code.value == '') { alert('������ �˻��Ͽ� �����Ͻʽÿ�.'); return;}	
	   	
	   	// �߰� - 20141112	
		if(fm.rent_l_cd.value !=  fm.l_cd.value ){	alert('Ź���Ƿڽ� ����ȣ�� Ʋ���ϴ�. �ٽ� ������ �����ϼ���.'); return; }				

		//���� ���ڼ� üũ
		if(fm.acct_cont.value != '' && !max_length(fm.acct_cont.value,80)){	
			alert('���� ���� ���̴� '+get_length(fm.acct_cont.value)+'��(��������) �Դϴ�.\n\n����� �ѱ�40��/����80�ڱ��� �Է��� �����մϴ�.'); return; } 			

		//��ǥ���� üũ
		if(getRentTime('m', fm.buy_dt.value, <%=AddUtil.getDate()%>) > 3){ 
			if(!confirm('�Է��Ͻ� ��ǥ���ڰ� �����̻� ���̳��ϴ�.\n\n��ǥ�� �Է� �Ͻðڽ��ϱ�?'))			
				return;
		}
		
		var sMoney = 0;
		
		var call_nm_cnt =0;
		var call_tel_cnt =0;
											
		var inCnt	=	0;
		var strAccCont	=	"";			// ����
		var strClient	=	"";			// �ŷ�ó��
		var strClientNm =	"";			// �ŷ�ó �����
		var strUserCnt	=	"";			// �ļ��ο� ��
		
		var strDept_id = "";
		var strMoney = "";
		
		var totMoney = 0;
						   
			 
		if(confirm('����Ͻðڽ��ϱ�?')){
		//document.domain = "amazoncar.co.kr";
			//fm.action='https://fms3.amazoncar.co.kr/card/doc_reg/cons_doc_reg_i_a3.jsp';		
			fm.action='cons_doc_reg_i_a3.jsp';		
			fm.target='i_no';
			fm.submit();
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


	function tot_buy_amt(){
		var fm = document.form1;		
		//����� �ƴϰ�, �Ϲݰ����� ���
///		if(fm.acct_code[1].checked == false && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
//		}else{
//			fm.buy_s_amt.value 		= fm.buy_amt.value;
//			fm.buy_v_amt.value 		= 0;									
//		}				
	}	
	
	//�ݾ׼���
	function set_buy_amt(){
		var fm = document.form1;	
		fm.buy_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) + toInt(parseDigit(fm.buy_v_amt.value)));		
	}
	
	//�ݾ׼���
	function set_buy_s_amt(){
		var fm = document.form1;	
		fm.buy_s_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_v_amt.value)));				
	}
		
	function set_buy_v_amt(){
		var fm = document.form1;	
		//����� �ƴϰ�, �Ϲݰ����� ���
//		if(fm.acct_code[1].checked == false && fm.ven_st[0].checked == true){
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
//		}else{
			fm.buy_v_amt.value = 0;				
//		}
		set_buy_amt();			
	}	
	
	//��ȸ---------------------------------------------------------------------------------------------------------------
	
	//�׿�����ȸ-�ſ�ī��
	function Neom_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno_search.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=500,height=500,left=350,top=150');		
		fm.action = "neom_search.jsp?t_wd="+fm.t_wd.value;
		fm.target = "Neom_search";
		fm.submit();		
	}
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
	}	
	
	//�׿�����ȸ-ǰ��
	function Neom_search2(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'item')	fm.t_wd.value = fm.item_name.value;
		window.open("about:blank",'Neom_search2','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=350,top=150');		
		fm.action = "../card_mng/neom_search.jsp";
		fm.target = "Neom_search2";
		fm.submit();		
	}
	function Neom_enter2(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search2(s_kd);
	}
	
	//�ŷ�ó��ȸ�ϱ�
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.ven_name.value != ''){	fm.t_wd.value = fm.ven_name.value;		}
		else{ 							alert('��ȸ�� �ŷ�ó���� �Է��Ͻʽÿ�.'); 	fm.ven_name.focus(); 	return;}
		window.open("vendor_list.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=350, top=150, width=800, height=500, scrollbars=yes");		
	}
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	//������ȸ�ϱ�
	function Rent_search(idx1){
		var fm = document.form1;	
		var t_wd;
		var go_url = 'cons_doc_reg_i.jsp';
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڸ� �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.item_name.value != ''){	fm.t_wd.value = fm.item_name.value;		}
		else{ 							alert('��ȸ�� ������ȣ/��ȣ�� �Է��Ͻʽÿ�.'); 	return;}

			window.open("rent_search.jsp?t_wd="+fm.t_wd.value+"&go_url="+go_url, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		

	}

//�߰��߰�
	//�����̿�����ȸ
	function CarMgr_search(idx1){
		var fm = document.form1;	
		var t_wd;
		if(fm.rent_l_cd[idx1].value != ''){	fm.t_wd.value = fm.rent_l_cd[idx1].value;}
		else{ 							alert('��ȸ�� ������ȣ�� �Է��Ͻʽÿ�.');  	return;}
		window.open("s_man.jsp?idx1="+idx1+"&s_kd=3&t_wd="+fm.rent_l_cd[idx1].value, "CarMgr_search", "left=10, top=10, width=600, height=400, scrollbars=yes, status=yes, resizable=yes");				
		
	}

	function Rent_enter(idx1) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search(idx1);
	}	
		
	//������ȸ
	function User_search(nm, idx)
	{
		var fm = document.form1;
		var t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "../card_mng/user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search(nm, idx);
	}	
	
	//������ȸ-�����Է�
	function User_search2(nm, idx)
	{
		var fm = document.form1;
		if(fm.user_nm[idx].value != '') 	fm.t_wd.value = fm.user_nm[idx].value;
		else								fm.t_wd.value = '';
		window.open("about:blank",'User_search2','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "../card_mng/user_m_search.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search2";
		fm.submit();		
	}
	function enter2(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search2(nm, idx);
	}	
	
	
	
	//�������� �ȳ���
	function help(){
		var fm = document.form1;
		var SUBWIN="help.jsp";	
		window.open(SUBWIN, "help", "left=350, top=350, width=400, height=300, scrollbars=yes, status=yes");
	}
	
	//���÷���---------------------------------------------------------------------------------------------------------------
	
	function cng_vs_input(){
		var fm = document.form1;
		
		//����� �ƴϰ�, �Ϲݰ����� ���
		if(fm.acct_code[1].checked == false && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;									
		}					
	}
	
	
	
	
	
	function cng_input_vat()
	{
		var fm 		= document.form1;
		var inVat	= toInt(parseDigit(fm.buy_v_amt.value));
		
		if(fm.vat_Rdio[0].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) + 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_s_amt();	
		}
		if(fm.vat_Rdio[1].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) - 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_s_amt();	
		}
	}
	
	//�����Է½� �հ��� �� ����
	function Keyvalue()
	{
		var fm 		= document.form1;
		var innTot	= 0;
		
		for(i=0; i<80 ; i++){
			innTot += toInt(parseDigit(fm.money[i].value));
		}
		fm.txtTot.value = parseDecimal(innTot);
	}
	
	function date_type_input(date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";
		var dt = today;
		if(date_type==2){			
			dt = new Date(today.valueOf()-(24*60*60*1000));
		}else if(date_type == 3){
			dt = new Date(today.valueOf()-(24*60*60*1000)*2);			
		}
		s_dt = String(dt.getFullYear())+"-";
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		fm.buy_dt.value = s_dt;		
	}	
	
	
	//������ȸ-
	function User_search3(nm, idx)
	{
		var fm = document.form1;
		if(fm.user_nm[idx].value != '') 	fm.t_wd.value = fm.user_nm[idx].value;
		else								fm.t_wd.value = '';
		window.open("about:blank",'User_search3','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "../card_mng/user_m_search2.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search3";
		fm.submit();		
	}
	function enter3(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search3(nm, idx);
	}

	
	//����û����������ȸ
	function search_nts(){
		var fm = document.form1;
		fm.nts_yn.value='Y';
		window.open("https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
	}	
//-->
</script>

</head>
<body onLoad="javascript:document.form1.cardno_search.focus();">

<form action="" name="form1" method="POST" >

<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name="sh_height" value="<%=sh_height%>">   
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name="idx" value="<%=idx%>">
<input type="hidden" name="type" value="search">  
<input type="hidden" name="s_kd" value="">
<input type="hidden" name="t_wd" value="">  
<input type="hidden" name="etc" value="">    
<input type="hidden" name="cur_dt" value="<%=AddUtil.getDate()%>">  
<input type='hidden' name='nts_yn' value=''> 
<input type='hidden' name='cons_no' value='<%=cons_no%>'>
<!--<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">-->
<input type="hidden" name="l_cd" value="<%=l_cd%>">  <!-- Ź�ۿ��� ����� rent_l_cd -->
<input type="hidden" name="car_no" value="<%=car_no%>">
<input type='hidden' name="seq" value="<%=seq%>">
<input type='hidden' name="from_page" value="/cons_doc_reg_i.jsp">
<!-- ù��° ���̺� //-->
<table border=0 cellspacing=0 cellpadding=0 width=100%>
		<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>����ī����� ��ǥ���</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>	<tr><td class=h></td></tr>
	<tr><td class=line2 colspan=2></td></tr>
    <tr> 
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr> 
            		<td width='10%'  class='title'>ī�� ��ȸ</td>
            		<td colspan="3">&nbsp; 
            			<input name="cardno_search" type="text" class="text" value="��������" size="30" style='IME-MODE: active' onKeyDown="javasript:Neom_enter('cardno')" readonly>
              			&nbsp;<a href="javascript:Neom_search('cardno');" ><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
						&nbsp;<span style="font-size:8pt">(ī���ȣ/����ڸ����� �˻�)</span>
            		</td>
          		</tr>
          
          		<tr> 
            		<td width='10%'  class='title'>�ſ�ī���ȣ</td>
            		<td width="50%" >
            			&nbsp; <input name="cardno" type="text" class="whitetext"  value="" size="30"  >
            			<input type='hidden' name="buy_id" value="">
					</td>
            		<td width="10%" class='title'>����ڱ���</td>
            		<td>&nbsp; <input name="card_name" type="text" class="whitetext" value="" size="30" redeonly></td>
          		</tr>
          		
          		<tr> 
            		<td class='title'>�߱�����</td>
            		<td>&nbsp; <input name="card_sdate" type="text" class="whitetext" value="" size="15" redeonly></td>
            		<td class='title'>��������</td>
            		<td>&nbsp; <input name="card_edate" type="text" class="whitetext" value="" size="15" redeonly></td>
          		</tr>
          
          		<tr> 
		            <td class='title'>�����</td>
		            <td colspan="3">&nbsp; 
			        	<input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(user_id, "USER")%>" size="12" style='IME-MODE: active' onKeyDown="javasript:enter('buy_user_id', '0')"> 
			            <input type="hidden" name="buy_user_id" value="<%=user_id%>">
			            <a href="javascript:User_search('buy_user_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
		            </td>
          		</tr>
          		
        	</table>
        </td>
    </tr>   
    <tr>
    	<td class=h></td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
    	<td colspan="2" class=line>
	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          		<tr>
            		<td colspan="2" class='title'>�ŷ�����</td>
          			<td colspan="3">&nbsp;
		  	  			<input name="buy_dt" type="text" class="text" value="<%=serv_dt%>" size="12" onBlur='javascript:this.value=ChangeDate2(this.value)'>
						&nbsp;&nbsp;
					    <input type='radio' name="date_type" value='1'  onClick="javascript:date_type_input(1)">����
						<input type='radio' name="date_type" value='2'  onClick="javascript:date_type_input(2)">����
						<input type='radio' name="date_type" value='3'  onClick="javascript:date_type_input(3)">����						
		  	  		</td>
          		</tr>
          		<tr>
          			<td colspan="2" class='title'>�ŷ�ó</td>
          			<td width=50% >&nbsp;
		            	<input name="ven_name" type="text" class="text" value="<%//=ven_name%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
						<input type="hidden" name="ven_code" value="<%=ven_code%>">
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 
						<span style="font-size:8pt">(ī�� ������, <b>����ڵ�Ϲ�ȣ</b>�� �˻�)</span>
					</td>
					<td width=10% class='title' style="font-size:8pt">����ڵ�Ϲ�ȣ</td>
					<td>&nbsp;
		            	<input type="text" class="whitetext"   name="ven_nm_cd"  value="">&nbsp;						
					</td>
       	  		</tr>
          		<tr>
          			<td colspan="2" class='title'>��������</td>
          			<td colspan="3" >&nbsp;
          			<input type="hidden" name="ve_st" value="">
			              <input type="radio" name="ven_st" value="1"  onClick="javascript:cng_vs_input()">�Ϲݰ���
					&nbsp;<input type="hidden" name="ven_st" value="2"  onClick="javascript:cng_vs_input()"><!--���̰���-->
					&nbsp;<input type="hidden" name="ven_st" value="3"  onClick="javascript:cng_vs_input()"><!--�鼼-->
					&nbsp;<input type="hidden" name="ven_st" value="4"  onClick="javascript:cng_vs_input()"><!--�񿵸�����(�������/��ü)-->
					&nbsp;&nbsp;
					<a href="javascript:search_nts();"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>
					&nbsp;<input type="text" class="whitetext"   name="nts_search_nm"  value="">
				</td>
       	  		</tr>
          		<tr>
          			<td colspan="2" class='title'>���ι�ȣ</td>
          			<td colspan="3" >&nbsp;&nbsp;<input type="text" name="siokno" value="" size = "30" >(���ݿ����� ī�� ��ǥ �Է½� ���ι�ȣ�� �� �Է��ϼ���.)</td>
       	  		</tr>	

          		<tr>
          			<td width="3%" rowspan="3" class='title'>��<br>��<br>��<br>��</td>
          			<td class='title'>���ް�</td>
          			<td colspan="3" >&nbsp;
              			<input type="text" name="buy_s_amt" value="" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();'>��
						
            		</td>
          		</tr>
          
          		<tr>
          			<td class='title'>�ΰ���</td>
          			<td colspan="3" >&nbsp;
              			<input type="text" name="buy_v_amt" value="" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();'>��
						
            		</td>
            	</tr>          
          		<tr>
          			<td width="7%" class='title'>�հ�</td>
          			<td  colspan="3" >&nbsp;
              			<input type="text" name="buy_amt" value="<%//=tot_amt%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); tot_buy_amt();'>��
              		</td>
          		</tr>
          		          
          		<tr>
          			<td colspan="2" class='title'>��������</td>
          			<td  colspan="3" >
			  			<table width="100%" border="0">
			    			<tr>
			      				<td width="90">
			      				  <%if(acct_code.equals("00004")) {%>
			      					<input type="radio" name="acct_code" value="00004" <%if(acct_code.equals("00004"))%>checked<%%>>����������
			      				<% } else { %>	
			      					<input type="radio" name="acct_code" value="00005" <%if(acct_code.equals("00005"))%>checked<%%>>�����
			      				<% } %>	
			      				</td>
							</tr>
			  			</table>
            		</td>
          		</tr>
          		
	        </table>
	  	</td>
    </tr> 
    
    <tr>
        <td class=h></td>
    </tr> 
    <tr>
    	<td class=h></td>
    </tr>  
    
    <tr>
        <td colspan="2" ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��볻��</span>              
        </td>      
    </tr>
    
    <tr><td class=line2 colspan=2></td></tr>
	
	<tr id=tr_acct1 style='display:<%if(acct_code.equals("00004")){%>''<%}else{%>none<%}%>'>   
    	<td colspan="2" class="line">
      		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" rowspan="2" class='title' >����</td>
          			<td width="10%" class='title'>����</td>
          		
          			<td width="80%">&nbsp;
          				<input type="radio" name="acct_code_g" value="13">���ָ�
						<input type="radio" name="acct_code_g" value="4">����
						<input type="radio" name="acct_code_g" value="5">LPG
						<input type="radio" name="acct_code_g" value="27">����/����
			  		</td>
				</tr>
				
				<tr>
					<td width="10%" class='title'>�뵵</td>
					<td width="90%">&nbsp;					
						<input type="radio" name="acct_code_g2" value="12" checked>Ź��&nbsp;&nbsp;&nbsp;(�Ƿ���:<%=sender_pos%>&nbsp;<%=sender_nm%>)
					</td>
				</tr>
			</table>
      	</td>
    </tr>
    <tr id=tr_acct2 style='display:<%if(acct_code.equals("00005")){%>''<%}else{%>none<%}%>'>   
    	<td colspan="2" class="line">
      		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" rowspan="2" class='title' >����</td>
          			<td width="90%">&nbsp;
          			<input type="radio" name="acct_code_g" value="22" checked>
					��Ÿ(����)
			  		</td>
				</tr>
								
			</table>
      	</td>
    </tr>
    <tr>
      <td colspan="2" class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="10%" class='title'>����</td>
          <td width="50%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=car_no%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('0')" readonly>
			<input type="hidden" name="rent_l_cd" value="">
			<input type="hidden" name="serv_id" value="">
			<input type="hidden" name="item_code" value="">
			<input type="hidden" name="stot_amt" value="">
			<input type="hidden" name="firm_nm" value="">
            <a href="javascript:Rent_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(������ȣ/��ȣ�� �˻�)</td>
            <%if(acct_code.equals("00004")){%>  
			<td width="10%" class='title'>��������Ÿ�</td>
			<td width="10%" align="center"><input type="text" name="last_dist" value="" size="10" class=num>km&nbsp;</td>
			<td width="8%" class='title'>�����</td>
			<td width="12%" align="center"><input type="text" name="last_serv_dt" value="" size="10">&nbsp;</td>
			<%} else { %>
			<td colspan=4'></td>
			<% } %>
        </tr>
     		
      </table></td>
    </tr>
    
   <tr id=tr_acct3 style='display:<%if(acct_code.equals("00004")){%>''<%}else{%>none<%}%>'>   
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>  
        		<tr>
		          <td width="10%" class='title'>������</td>
		          <td width="50%">&nbsp;
		          	<input type='text' size='10' class='num'  name='oil_liter' >&nbsp;L		
		            &nbsp;*�������� ��� �ʼ�(�Ҽ������ڸ����� �Է°���)		          	
		          </td>
				  <td width="10%" class='title'>������Ÿ�</td>
		          <td width="30%">&nbsp;
		          	<input type='text' size='10' class='num'  name='tot_dist' >&nbsp;km		
		          </td>
		        </tr>
    
      		</table>
      	</td>
    </tr>
    <tr >
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" class='title'>����</td>
          			<td width="90%">&nbsp;
            			<textarea name="acct_cont" cols="100" rows="2" class="text"></textarea> (�ѱ�40���̳�)
            		</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    
    <tr>
    	<td class=h></td>
    </tr>
    
 
<%if(user_id.equals("000096")){%>
	<tr>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" class='title'>��������ĵ����</td>
          			<td width="90%">&nbsp;
            			<input type="file" name="file" size = "40">
            		</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
<%}%>	

    <tr>
    	<td class=h></td>
    </tr>
    
    <tr>
        
        <td align="right">
      		<a href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
      	</td>
    </tr>
 
</table>            
</form>             
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	tot_buy_amt();
	//cng_input();
//-->
</script>
</body>             
</html>             