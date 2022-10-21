<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.pay_mng.*, acar.cont.*,acar.client.*, acar.car_register.*, acar.accid.*, acar.cus_reg.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_register.CarMaintBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int    sh_height	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String r_acct_code 	= request.getParameter("r_acct_code")==null?"":request.getParameter("r_acct_code");
	String reqseq 		= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int    i_seq 		= request.getParameter("i_seq")==null?0:AddUtil.parseInt(request.getParameter("i_seq"));
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");	
	
	String chk="0";
	long total_amt1	= 0;
	long total_amt2	= 0;
	
	CommonDataBase 		c_db = CommonDataBase.getInstance();
	CarRegDatabase 		crd = CarRegDatabase.getInstance();
	AccidDatabase 		as_db = AccidDatabase.getInstance();
	CusReg_Database 	cr_db = CusReg_Database.getInstance();
	PayMngDatabase 		pm_db = PayMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();


	//��ݿ���
	PayMngBean pay 	= pm_db.getPay(reqseq);
	
	//��ݿ���
	PayMngBean item	= pm_db.getPayItem(reqseq, i_seq);
	
	//��ݿ��� ���� �׸�
	Vector vt =  pm_db.getPayItemList(reqseq);
	int vt_size = vt.size();
	
	if(i_seq == 0 && item.getReqseq().equals("")) i_seq = vt_size+1;
	
	//���⺻����
	ContBaseBean base = new ContBaseBean();
	//������
	ClientBean client = new ClientBean();
	//�����ȸ
	AccidentBean a_bean = new AccidentBean();
	//������ȸ
	ServInfoBean siBn = new ServInfoBean();
	
	if(item.getP_gubun().equals("99")){
		//���⺻����
		base = a_db.getCont(item.getP_cd1(), item.getP_cd2());
		//�����������
		cr_bean = crd.getCarRegBean(item.getP_cd3());
		//������
		client = al_db.getNewClient(base.getClient_id());
		//�����ȸ
		a_bean = as_db.getAccidentBean(item.getP_cd3(), item.getP_cd4());
		//������ȸ
		siBn = cr_db.getServInfo(item.getP_cd3(), item.getP_cd5());
		//�˻���ȸ
		cm_bean = crd.getCarMaint(item.getP_cd3(), item.getP_cd6());
	}else{
		if(item.getP_gubun().equals("11") || item.getP_gubun().equals("14") || item.getP_gubun().equals("15")){
			//���⺻����
			base = a_db.getCont(item.getP_cd4(), item.getP_cd5());
			//�����������
			cr_bean = crd.getCarRegBean(item.getP_cd1());
			//������
			client = al_db.getNewClient(base.getClient_id());
			//�����ȸ
			a_bean = as_db.getAccidentBean(item.getP_cd1(), item.getP_cd3());
			//������ȸ
			siBn = cr_db.getServInfo(item.getP_cd1(), item.getP_cd2());
		}
	}
	
	String serv_dt  = siBn.getServ_dt()		==null?"":siBn.getServ_dt();
	String accid_dt = a_bean.getAccid_dt()	==null?"":a_bean.getAccid_dt();
	String maint_dt = cm_bean.getChe_dt()	==null?"":cm_bean.getChe_dt();
	if(!accid_dt.equals("")){
		accid_dt = a_bean.getAccid_dt().substring(0,8);
	}
	
	//�μ��ڵ�
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	
	//Ź�ۻ���
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	//��������
	CodeBean[] accts = c_db.getCodeAll_0043();
	int a_size = accts.length;
		
	//������
	int user_size = c_db.getUserSize();
	
	if(user_size > 30 && user_size < 40){ 		user_size = 40;
	}else if(user_size > 40 && user_size < 50){ 	user_size = 50;
	}else if(user_size > 50 && user_size < 60){ 	user_size = 60;
	}else if(user_size > 60 && user_size < 70){ 	user_size = 70;
	}else if(user_size > 70 && user_size < 80){ 	user_size = 80;
	}else if(user_size > 80 && user_size < 90){ 	user_size = 90;
	}else if(user_size > 90 && user_size < 100){ 	user_size = 100; }
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" src="InnoAP.js"></script>
<script language="JavaScript">
<!--
	//����Ʈ
	function list(){
		var fm = document.form1;		
		if(fm.from_page.value == ''){
			fm.action = '/fms2/pay_mng/pay_upd_step2.jsp';
		}else{
			fm.action = fm.from_page.value;
		}			
		fm.target = 'd_content';
		fm.submit();
	}	

	//����Ű ó��
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13'){		 
			if(nm == 'buy_user_id')		User_search(nm, idx);
			if(nm == 'off_id')			off_search(idx);			
		}
	}	

	//����� ��ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm[0].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "/card/card_mng/user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	
	//���� ������ȸ
	function User_search2(nm, idx)
	{
		var fm = document.form1;
		if(fm.user_nm[idx].value != '') 	fm.t_wd.value = fm.user_nm[idx].value;
		else								fm.t_wd.value = '';
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "/card/card_mng/user_m_search.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search";
		fm.submit();		
	}
	function enter2(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search2(nm, idx);
	}	
	
	//����� �������
	function pay_user_excel(){
		var fm = document.form1;
		window.open("about:blank",'User_excel','scrollbars=yes,status=yes,resizable=yes,width=600,height=600,left=370,top=200');		
		fm.action = "user_excel.jsp";
		fm.target = "User_excel";
		fm.submit();		
	}
	
	//����ó��ȸ�ϱ�
	function off_search(idx){
		var fm = document.form1;	
		var t_wd = fm.off_nm.value;
		var off_st_nm = fm.off_st.options[fm.off_st.selectedIndex].text;
		if(fm.off_st.value == ''){		alert('��ȸ�� ����ó ������ �����Ͻʽÿ�.'); 	fm.off_st.focus(); 	return;}
		if(fm.off_nm.value == ''){		alert('��ȸ�� ����ó���� �Է��Ͻʽÿ�.'); 		fm.off_nm.focus(); 	return;}
		window.open("/fms2/pay_mng/off_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&off_st="+fm.off_st.value+"&idx="+idx+"&t_wd="+t_wd+"&off_st_nm="+off_st_nm, "OFF_LIST", "left=50, top=50, width=1150, height=550, scrollbars=yes");		
	}
	
	//�׿��� ��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;	
		if(fm.ven_name.value == ''){	alert('��ȸ�� �׿����ŷ�ó���� �Է��Ͻʽÿ�.'); fm.ven_name.focus(); return;}
		window.open("/card/doc_reg/vendor_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&idx="+idx+"&t_wd="+fm.ven_name.value+"&from_page=/fms2/pay_mng/off_list.jsp", "VENDOR_LIST", "left=150, top=150, width=950, height=550, scrollbars=yes");		
	}			
	function ven_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') ven_search(idx);
	}	
		
	//������ȸ�ϱ�
	function Rent_search(){
		var fm = document.form1;	
		if(fm.car_info.value != '')	fm.t_wd.value = fm.car_info.value;
		window.open("/card/doc_reg/rent_search.jsp?go_url=/fms2/pay_mng/pay_dir_reg.jsp&t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
	}
	function Rent_enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search();
	}	
	
	
	
	//���� ��ȸ ------------------------------------------------------------------------------------------------	
	function Serv_search(){
		var fm = document.form1;
		if(fm.off_id.value == ''){		alert('����ó�� ���� �����Ͻʽÿ�.'); 	fm.off_nm.focus(); 	return;}
		if(fm.rent_l_cd.value == ''){	alert('������ ���� �����Ͻʽÿ�.'); 	fm.car_info.focus(); 	return;}		
		window.open("/acar/res_search/sub_select_2_s.jsp?go_url=/fms2/pay_mng/pay_dir_reg.jsp&gubun=mng&c_id="+fm.car_mng_id.value+"&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&off_id="+fm.off_id.value+"&rent_st=1&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value, "SERV_SEARCH", "left=50, top=50, width=930, height=800, status=yes");
	}	
	function Serv_enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Serv_search();
	}	

	//�˻� ��ȸ ------------------------------------------------------------------------------------------------	
	function Maint_search(){
		var fm = document.form1;
		if(fm.off_id.value == ''){		alert('����ó�� ���� �����Ͻʽÿ�.'); 	fm.off_nm.focus(); 	return;}
		if(fm.rent_l_cd.value == ''){	alert('������ ���� �����Ͻʽÿ�.'); 	fm.car_info.focus(); 	return;}		
		window.open("/acar/cus_reg/cus_reg_maint.jsp?go_url=/fms2/pay_mng/pay_dir_reg.jsp&gubun=mng&car_mng_id="+fm.car_mng_id.value+"&client_id="+fm.client_id.value+"&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&off_id="+fm.off_id.value+"&rent_st=1&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value, "MAINT_SEARCH", "left=50, top=50, width=930, height=800, status=yes");
	}	
	function Maint_enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Maint_search();
	}	

	
	// ������ ------------------------------------------------------------------------------------------------
	
	//��� ��ȸ
	function Accid_search(){
		var fm = document.form1;
		if(fm.rent_l_cd.value == ''){	alert('������ ���� �����Ͻʽÿ�.'); 	fm.car_info.focus(); 	return;}		
		window.open("/acar/res_search/sub_select_3_a.jsp?go_url=/fms2/pay_mng/pay_dir_reg.jsp&gubun=mng&c_id="+fm.car_mng_id.value+"&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&car_no=&rent_st=1&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value, "ACCID_SEARCH", "left=50, top=50, width=930, height=600, status=yes");
	}	
	function Accid_enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Accid_search();
	}	
		
	//�����̿�����ȸ
	function CarMgr_search(){
		var fm = document.form1;
		var width = 600;
		if(fm.rent_l_cd.value == ''){	alert('������ ���� �����Ͻʽÿ�.'); 	fm.car_info.focus(); 	return;}		
		window.open("/fms2/consignment_new/s_man.jsp?go_url=/fms2/pay_mng/pay_dir_reg.jsp&st=1&value=2&idx=0&s_kd=3&t_wd="+fm.rent_l_cd.value, "MAN", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");				
	}
			
	//�ݾ׼���
	function tot_buy_amt2(){
		var fm = document.form1;		
		fm.buy_amt.value 			= parseDecimal(toInt(parseDigit(fm.sub_amt1.value)) + toInt(parseDigit(fm.sub_amt2.value)) + toInt(parseDigit(fm.sub_amt3.value)) + toInt(parseDigit(fm.sub_amt4.value)) + toInt(parseDigit(fm.sub_amt5.value)) + toInt(parseDigit(fm.sub_amt6.value)));		
	}		
		
	//�ݾ׼���
	function tot_buy_amt(){
		var fm = document.form1;		
		if(fm.ven_st[1].checked == true )
		{		
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}	
	}		
	function set_buy_amt(){
		var fm = document.form1;	
		fm.buy_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) + toInt(parseDigit(fm.buy_v_amt.value)));		
	}
	function set_buy_s_amt(){
		var fm = document.form1;	
		fm.buy_s_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_v_amt.value)));		
	}		
	function set_buy_v_amt(){
		var fm = document.form1;	
		fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
		set_buy_amt();			
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
	function cng_input_vat2()
	{
		var fm 		= document.form1;
		var inVat	= toInt(parseDigit(fm.buy_v_amt.value));
		
		if(fm.vat_Rdio2.checked == true && inVat > 0)
		{
			fm.buy_v_amt.value = 0;
			set_buy_amt();	
		}else{
			set_buy_v_amt();
			set_buy_amt();				
		}
	}		

	//����ó ���ý�
	function cng_off_input(){
		var fm = document.form1;
		fm.off_nm.focus();
		if(fm.off_st.options[fm.off_st.selectedIndex].value == 'user_id' && fm.buy_user_id.value != ''){

		}
	}
	
	//�������� ���ý�
	function cng_input(){
		var fm = document.form1;
		tr_acct1.style.display		= 'none';
		tr_acct2.style.display		= 'none';
		tr_acct3.style.display		= 'none';
		tr_acct4.style.display		= 'none';
		tr_acct6.style.display		= 'none';
		tr_acct7.style.display		= 'none';
		tr_acct8.style.display		= 'none';
		tr_acct3_1.style.display	= 'none';
		tr_acct3_2.style.display	= 'none';
		tr_acct3_3.style.display	= 'none';
		tr_acct3_4.style.display	= 'none';
		tr_acct3_5.style.display	= 'none';				
		tr_acct3_6.style.display	= 'none';						
		tr_acct98.style.display		= 'none';
		tr_acct99.style.display	 	= 'none';
		tr_acct101.style.display 	= 'none';
		
		if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '81100'){ 			//�����Ļ���
			fm.acct_code_g[0].checked 	= true;//�⺻:�Ĵ�
			fm.acct_code_g2[1].checked 	= true;//�⺻:�߽�			
			tr_acct1.style.display		= '';
			tr_acct98.style.display		= '';
			tr_acct99.style.display	 	= '';
			tr_acct101.style.display 	= '';
			cng_input2(fm.acct_code_g[0].value);
		}else if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '81300'){ 	//�����
			tr_acct6.style.display		= '';
			tr_acct98.style.display		= '';
			tr_acct99.style.display	 	= '';
			tr_acct101.style.display 	= '';
		}else if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '81200'){ 	//�������
			tr_acct4.style.display		= '';
			tr_acct98.style.display		= '';
			tr_acct99.style.display	 	= '';
			tr_acct101.style.display 	= '';
		}else if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '45800'){ 	//����������
			tr_acct2.style.display		= '';
			tr_acct3_1.style.display	= '';			
			tr_acct3_2.style.display	= '';			
			tr_acct98.style.display		= '';
		}else if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '45700'){ 	//���������
			fm.acct_code_g[8].checked 	= true;//�⺻:�Ϲݼ���
			tr_acct3.style.display		= '';
			tr_acct3_1.style.display	= '';			
			tr_acct3_5.style.display	= '';			
			tr_acct3_3.style.display	= '';									
			tr_acct98.style.display		= '';
			cng_input3(fm.acct_code_g[8].value);
		}else if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '46000'){ 	//������ǰ��
			fm.acct_code_g[8].checked 	= true;//�⺻:�Ϲݼ���
			tr_acct3.style.display		= '';
			tr_acct3_1.style.display	= '';			
			tr_acct3_5.style.display	= '';			
			tr_acct3_3.style.display	= '';									
			tr_acct98.style.display		= '';
		}else if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '45600'){ 	//��������
			tr_acct3_1.style.display	= '';			
			tr_acct3_4.style.display	= '';			
			tr_acct3_5.style.display	= '';						
			tr_acct3_3.style.display	= '';			
			tr_acct98.style.display		= '';
		}else if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '81400'){ 	//��ź�
			tr_acct3_1.style.display	= '';
			tr_acct7.style.display		= '';
			tr_acct98.style.display		= '';
			tr_acct99.style.display	 	= '';
			tr_acct101.style.display	 	= '';			
		}else if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '21700' || fm.acct_code.options[fm.acct_code.selectedIndex].value == '21900'){ 	//�뿩�������/�����������
			tr_acct3_1.style.display	= '';
			tr_acct8.style.display		= '';
			tr_acct98.style.display		= '';
		}else if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '46400'){ 	//��ݺ�
			tr_acct3_1.style.display	= '';
			tr_acct98.style.display		= '';
		}else{
			tr_acct3_1.style.display	= '';
			tr_acct98.style.display		= '';		
		}
	}
		
	//���δ� ���� �ݾ�(1/n:0, �ݾ������Է�:1)
	function cng_input1()
	{
		var fm 		= document.form1;
		var inCnt	= toInt(fm.user_su.value);
		var inTot	= toInt(parseDigit(fm.buy_amt.value));
		var innTot	= 0;
		
		if(inCnt > <%=user_size%>){	alert('1/n �Է��� �ִ� 60�α��� �Դϴ�.'); return;}
		
		if(fm.user_Rdio[0].checked == true && inCnt > 0 && toInt(parseDigit(fm.buy_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_amt.value)) / inCnt);			

			for(i=0; i<inCnt ; i++){
				fm.money[i].value = parseDecimal(inAmt);
				innTot += inAmt;
			}
			for(i=inCnt; i<<%=user_size%> ; i++){
				fm.money[i].value = '0';
			}
			
			if(inTot > innTot) 	fm.money[0].value 		= parseDecimal(toInt(parseDigit(fm.money[0].value)) 	  + (inTot-innTot));
			if(inTot < innTot) 	fm.money[inCnt-1].value = parseDecimal(toInt(parseDigit(fm.money[inCnt-1].value)) + (inTot-innTot));
			
			fm.txtTot.value = fm.buy_amt.value;
		}
		
		if(fm.user_Rdio[1].checked == true)
		{
			for(i=0; i<<%=user_size%> ; i++){
				fm.money[i].value = '0';
			}
			fm.txtTot.value = '0';
		}
	}
			
	//�����Է½� �հ��� �� ����
	function Keyvalue()
	{
		var fm 		= document.form1;
		var innTot	= 0;
		
		for(i=0; i<<%=user_size%> ; i++){
			innTot += toInt(parseDigit(fm.money[i].value));
		}
		fm.txtTot.value = parseDecimal(innTot);
	}
				
	//�����Ļ��� ���� ���ý�
	function cng_input2(acct_code_g)
	{
		var fm = document.form1;
		tr_acct98.style.display 	= '';
		tr_acct99.style.display 	= '';
		tr_acct101.style.display 	= '';
		
		if(acct_code_g == '1'){ //�Ĵ�
			fm.acct_code_g2[1].checked 	= true;//�⺻:�߽�
			tr_acct1_1.style.display	= '';
			tr_acct1_2.style.display	= 'none';
		}
		if(acct_code_g == '2'){ //ȸ�ĺ�
			fm.acct_code_g2[3].checked 	= true;//�⺻:ȸ����ü����
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= '';			
		}
		if(acct_code_g == '15'){ //������
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
		}
		if(acct_code_g == '3'){ //��Ÿ
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
		}
	}			
	
	//��������� ���� ���ý�
	function cng_input3(acct_code_g)
	{
		var fm = document.form1;
		tr_acct98.style.display 	= '';
		tr_acct99.style.display 	= 'none';
		tr_acct101.style.display 	= 'none';
		
		if(acct_code_g == '6' || acct_code_g == '21'){ //�Ϲ�����,�縮������
			tr_acct3_1.style.display	= '';		
			tr_acct3_3.style.display	= '';			
			tr_acct3_5.style.display	= '';
			tr_acct3_6.style.display	= 'none';
		}else if(acct_code_g == '7'){ //����˻�
			tr_acct3_1.style.display	= '';		
			tr_acct3_3.style.display	= 'none';			
			tr_acct3_5.style.display	= 'none';
			tr_acct3_6.style.display	= '';
		}else if(acct_code_g == '18'){ //��ȣ�Ǵ��
			tr_acct3_1.style.display	= '';		
			tr_acct3_3.style.display	= 'none';
			tr_acct3_5.style.display	= 'none';
			tr_acct3_6.style.display	= 'none';
		}else if(acct_code_g == '22'){ //��Ÿ
			tr_acct3_1.style.display	= '';		
			tr_acct3_3.style.display	= 'none';
			tr_acct3_5.style.display	= 'none';
			tr_acct3_6.style.display	= 'none';
		}				
	}				
	
	function save()
	{
		var fm = document.form1;
		fm.acct_code_nm.value = fm.acct_code.options[fm.acct_code.selectedIndex].text;
		
	
		if(fm.acct_code_nm.value == '����')	fm.acct_code_nm.value = '';
		
		<%if(item.getP_gubun().equals("99")){%>		
		
		if(fm.buy_user_id.value == '' && fm.user_nm[0].value == '')	{	alert('������ڸ� �Է��Ͻʽÿ�.'); 	fm.buy_user_id.focus(); 	return; }				
		if(fm.buy_amt.value == '0')		{	alert('�ݾ��� �Է��Ͻʽÿ�.'); 			fm.buy_amt.focus(); 		return; }				
		if(fm.acct_code.value == '')	{	alert('���������� �Է��Ͻʽÿ�.'); 		fm.acct_code.focus(); 		return; }
				
		//���������
		if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '45700'
			&& fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false)
		{ alert('��������� ������ �����Ͻʽÿ�.'); return;}
				
		if(fm.acct_code.options[fm.acct_code.selectedIndex].value == '45700' && fm.acct_code_g[8].checked == true){ 	//���������-�Ϲݼ���
			//���������-�Ϲ������϶� �����̿��� �Է� �ʼ�
			if(fm.call_t_nm.value == '' || fm.call_t_tel.value == '')		{	alert('�����̿��ڿ� ����ó�� �Է��ؾ� �մϴ�. ���� �ݼ��Ϳ��� ��������Ͽ� ������ �ʿ��մϴ�.'); 	fm.call_t_nm.focus(); 	return; }	
		}
		<%}else{%>
		if(fm.buy_user_id.value == '' && fm.user_nm[0].value == '')	{	
			fm.buy_user_id.value 	= '000003';
			fm.user_nm[0].value 	= '������';
		}				
		<%}%>				
		
		fm.buy_user_nm.value = fm.user_nm[0].value;
		
		if(toInt(parseDigit(fm.money[0].value))>0 && toInt(parseDigit(fm.user_su.value))==0){
			alert("���ο��� �Է��Ͽ� �ֽʽÿ�.");	return;
		}		
		
		fm.mode.value = 'u';		
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			fm.action = 'pay_upd_step2_in_a.jsp';
			fm.target = 'i_no';
			fm.submit();	
			
			link.getAttribute('href',originFunc);	
		}
	}	
	
	//�����ϱ�
	function item_delete(){
		var fm = document.form1;	
		
		if(!confirm('��ݿ��� ���� �Ͻðڽ��ϱ�?')){	return; }
		if(!confirm('�ٽ� Ȯ���մϴ�. ��ݿ��� ���� �Ͻðڽ��ϱ�?')){	return; }
		if(!confirm('������ ��ݿ��� ���� �Ͻðڽ��ϱ�?')){	return; }
			
		if(confirm('�����Ͻðڽ��ϱ�?')){
			fm.action = 'pay_upd_step1_in_d.jsp';
			fm.target = 'i_no';
//			fm.submit();		
		}		
	}
	

	
	//�����ĵ��
	function insertServ(){
		var fm = document.form1;
		if(fm.r_serv_dt.value == '')	{	alert('�������ڸ� �Է��Ͻʽÿ�.'); 		fm.r_serv_dt.focus(); 	return; }
		if(fm.rep_cont.value == '')		{	alert('���񳻿��� �Է��Ͻʽÿ�.'); 		fm.rep_cont.focus(); 	return; }
		if(fm.r_labor.value == '0')		{	alert('���Ӱ��� �Է��Ͻʽÿ�.'); 		fm.r_labor.focus(); 	return; }				
		if(fm.r_amt.value == '0')		{	alert('��ǰ���� �Է��Ͻʽÿ�.'); 		fm.r_amt.focus(); 		return; }				
		if(fm.r_dc.value == '0')		{	alert('��ǰD/C�� �Է��Ͻʽÿ�.'); 		fm.r_dc.focus(); 		return; }				
		if( '<%=pay.getOff_st()%>' != 'off_id') {	alert('�����ĵ���� �Ϸ��� ����ó ������ [���¾�ü]�̾�� �մϴ�.'); 		return; }
		
		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.action = 'pay_b_u_dir_serv_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}
	
	//�˻��ĵ��
	function insertMaint(){
		var fm = document.form1;
		if(fm.maint_st.value == '')		{	alert('�˻����ڸ� �Է��Ͻʽÿ�.'); 		fm.maint_st.focus(); 		return; }
		if(fm.r_maint_dt.value == '')	{	alert('�˻����ڸ� �Է��Ͻʽÿ�.'); 		fm.r_maint_dt.focus(); 		return; }
		if(fm.maint_st_dt.value == '')	{	alert('�����˻����ڸ� �Է��Ͻʽÿ�.'); 	fm.maint_st_dt.focus(); 	return; }
		if(fm.maint_end_dt.value == '')	{	alert('�����˻����ڸ� �Է��Ͻʽÿ�.'); 	fm.maint_end_dt.focus();	return; }				
		
		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.action = 'pay_b_u_dir_maint_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}

	
	//�׿�����ǥ��ȸ
	function doc_reg(){
		var fm = document.form1;
		
		if(confirm('�����ޱ���ǥ�� �����Ͻðڽ��ϱ�?')){
			fm.action = 'pay_c_u_25300_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}	
	
	//������氨��û�������
	function M_doc_action(st, m_doc_code, seq1, seq2, buy_user_id, doc_bit, doc_no){
		var fm = document.form1;
		fm.st.value 		= st;		
		fm.m_doc_code.value 	= m_doc_code;
		fm.seq1.value 		= seq1;
		fm.seq2.value 		= seq2;		
		fm.doc_bit.value 	= doc_bit;
		fm.doc_no.value 	= '';		
		fm.action = '/fms2/consignment_new/cons_oil_doc_u.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}				
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>  
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>        
  <input type='hidden' name='from_page' value='<%=from_page%>'>      
  <input type='hidden' name='r_est_dt' 	value='<%=pay.getP_est_dt()%>'>            
  <input type='hidden' name='off_id' 	value='<%=pay.getOff_id()%>'>              
  <input type="hidden" name="rent_mng_id" value="<%=item.getP_cd1()%>">
  <input type="hidden" name="rent_l_cd" value="<%=item.getP_cd2()%>">
  <input type="hidden" name="car_mng_id" value="<%=item.getP_cd3()%>">
  <input type="hidden" name="client_id" value="">  
  <input type="hidden" name="accid_id" 	value="<%=item.getP_cd4()%>">
  <input type="hidden" name="serv_id" 	value="<%=item.getP_cd5()%>">
  <input type="hidden" name="maint_id" 	value="<%=item.getP_cd6()%>">  
  <input type='hidden' name='r_acct_code' value='<%=r_acct_code%>'>
  <input type='hidden' name='go_url' 	value='/fms2/pay_mng/pay_dir_reg.jsp'>      
  <input type='hidden' name='acct_code_nm' value=''>      
  <input type="hidden" name="ven_nm_cd" value="">
  <input type="hidden" name="mode" value="">  
  
  <input type='hidden' name='st' 	 value=''>
  <input type='hidden' name='m_doc_code' value=''>  
  <input type='hidden' name='seq1' 	 value=''>
  <input type='hidden' name='seq2' 	 value=''>
  <input type='hidden' name="doc_bit" 	 value="">
  <input type='hidden' name="doc_no" 	 value="">
  

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						��ݿ���[����]���� (2�ܰ�)</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>     
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="10%" class=title>�����ȣ</td>
            <td width="15%" >&nbsp;			  
              <%=reqseq%></td>
            <td width="10%" class=title>�ŷ�����</td>
            <td width="10%" >&nbsp;			  
              <%=AddUtil.ChangeDate2(pay.getP_est_dt())%></td>
            <td width="10%" class=title>�ݾ�</td>
            <td width="10%" >&nbsp;			  
              <%=AddUtil.parseDecimalLong(pay.getAmt())%>��</td>
            <td width="10%" class=title>����ó</td>
            <td width="25%" >&nbsp;			  
              <%=pay.getOff_nm()%></td>
          </tr>
		</table>
	  </td>
	</tr> 		
	<tr>
	  <td>&nbsp;</td>
	</tr>  				
	<tr>
	  <td>&nbsp;</td>
	</tr>  			
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>		
          <tr>
            <td colspan="2" class=title>�Ϸù�ȣ</td>
            <td >&nbsp;	<%=i_seq%>	
			  <input type="hidden" name="i_seq" value="<%=i_seq%>">	  
               </td>
          </tr>			  
          <tr>
            <td colspan="2" class=title>�������</td>
            <td >&nbsp;			  
              <input name="user_nm" type="text" class="default" value="<%=c_db.getNameById(item.getBuy_user_id(), "USER")%>" size="10" style='IME-MODE: active' onKeyDown="javasript:enter('buy_user_id', '0')">
              <input type="hidden" name="buy_user_id" value="<%=item.getBuy_user_id()%>">
			  <input type="hidden" name="buy_user_nm" value="">
              <a href="javascript:User_search('buy_user_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>           </td>
          </tr>	
          <tr>
            <td width="5%" rowspan="3" class=title>��<br>��<br>
            ��<br>
            ��</td>
            <td width="10%" class=title>���ް�</td>
            <td>&nbsp;
			    <input type="hidden" name="buy_s_amt" 	value="<%=item.getI_s_amt()%>">  
                <%=AddUtil.parseDecimalLong(item.getI_s_amt())%>��&nbsp;
			</td>
          </tr>
          <tr>
            <td class=title>�ΰ���</td>
            <td>&nbsp;
			    <input type="hidden" name="buy_v_amt" 	value="<%=item.getI_v_amt()%>">  
                <%=AddUtil.parseDecimalLong(item.getI_v_amt())%>��
			</td>
          </tr>
          <tr>
            <td class=title>�հ�</td>
            <td>&nbsp;
			   <input type="hidden" name="buy_amt" 	value="<%=item.getI_amt()%>">  
				<%=AddUtil.parseDecimalLong(item.getI_amt())%>��
				</td>
          </tr>
          <tr>
            <td colspan="2" class=title>��������</td>
            <td >&nbsp;
              <select name='acct_code' class='default' onchange="javascript:cng_input()">
                <option value="" >����</option>
                <%for(int i = 0 ; i < a_size ; i++){
       					CodeBean code = accts[i];	%>
		        <option value='<%=code.getNm_cd()%>' <%if(code.getNm_cd().equals(item.getAcct_code()) && !code.getCode().equals("0000")){%>selected<%}%>><%= code.getNm()%></option>
		        <%}%>		
              </select></td>
          </tr>
          <tr>
            <td colspan="2" class=title>��뱸��</td>
            <td >&nbsp;
              <select name='cost_gubun' class='default'>
                <option value="" >����</option>
                <option value="1" <%if(item.getCost_gubun().equals("1"))	%>selected<%%>>Ź�۷�(�뿩�����ε�)</option>
                <option value="7" <%if(item.getCost_gubun().equals("7"))	%>selected<%%>>Ź�۷�(��Ÿ����)</option>				
                <option value="2" <%if(item.getCost_gubun().equals("2"))	%>selected<%%>>��Ʈ���(�ܺ�)</option>
                <option value="3" <%if(item.getCost_gubun().equals("3"))	%>selected<%%>>��ź�</option>
                <option value="4" <%if(item.getCost_gubun().equals("4"))	%>selected<%%>>���ú��</option>
                <option value="5" <%if(item.getCost_gubun().equals("5"))	%>selected<%%>>Ź��������</option>
                <option value="6" <%if(item.getCost_gubun().equals("6"))	%>selected<%%>>���޿�ǰ</option>
              </select></td>
          </tr>		  		  
          <tr>
            <td colspan="2" class=title>����ݾ�</td>
            <td>&nbsp;��
                <input name='sub_amt1' type='text' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);' value='<%=AddUtil.parseDecimalLong(item.getSub_amt1())%>' size='15' maxlength='15'>
                ��
				&nbsp;��
                <input name='sub_amt2' type='text' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);' value='<%=AddUtil.parseDecimalLong(item.getSub_amt2())%>' size='15' maxlength='15'>
                ��
				&nbsp;��
                <input name='sub_amt3' type='text' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);' value='<%=AddUtil.parseDecimalLong(item.getSub_amt3())%>' size='15' maxlength='15'>
                ��
				&nbsp;��
                <input name='sub_amt4' type='text' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);' value='<%=AddUtil.parseDecimalLong(item.getSub_amt4())%>' size='15' maxlength='15'>
                ��
				&nbsp;��
                <input name='sub_amt5' type='text' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);' value='<%=AddUtil.parseDecimalLong(item.getSub_amt5())%>' size='15' maxlength='15'>
                ��
                &nbsp;��
                <input name='sub_amt6' type='text' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);' value='<%=AddUtil.parseDecimalLong(item.getSub_amt6())%>' size='15' maxlength='15'>
                ��
				<%if(item.getP_gubun().equals("02")){%>
				<br><br>[��������] �翵������+���������ݾ� ��ҵ漼 ���ֹμ� �꼼�������ݾ� �뼼�İ����ݾ� 
				<%}else if(item.getP_gubun().equals("03")){%>
				<br><br>[�ڵ�������] ��ű�+���� ���߰����� ������ȯ�� ���߰�ȯ��
				<%}else if(item.getP_gubun().equals("04")){%>
				<br><br>[�ڵ����Һ�] ����� ������
				<%}else if(item.getP_gubun().equals("05")){%>
				<br><br>[�ڵ����Һ�] ��̻�ȯ���� ������������ä ��������Ա� ���ߵ����������� �������� ���Ÿ������
				<%}else if(item.getP_gubun().equals("11")){%>
				<br><br>[�ڵ�������] ����ް� ��ΰ��� ��D/C
				<%}else if(item.getP_gubun().equals("14")){%>
				<br><br>[�ڵ�����������] ����� ���ǰ �����D/C
				<%}else if(item.getP_gubun().equals("15")){%>
				<br><br>[�ڼհ��Ӻΰ���] ����Ӱ� �����ǥ�ؾ�
				<%}else if(item.getP_gubun().equals("16")){%>
				<br><br>[�ڼպ�ǰ�ΰ���] ���ǰ�� �����ǥ�ؾ�
				<%}else if(item.getP_gubun().equals("12")){%>
				<br><br>[�ڵ���Ź��] ����ް� ��ΰ���
				<%}else if(item.getP_gubun().equals("13")){%>
				<br><br>[�ڵ�����ǰ] ����ް� ��ΰ���
				<%}else if(item.getP_gubun().equals("22")){%>
				<br><br>[�����Һ�] �����뿩 ��Ű� ��뵵���� ������
				<%}else if(item.getP_gubun().equals("31") || item.getP_gubun().equals("37")){%>
				<br><br>[����ȯ�ұ�] ����ް� ��ΰ��� ��°躸���� ���Ÿ��ü��
				<%}else if(item.getP_gubun().equals("33")||item.getP_gubun().equals("34")){%>
				<br><br>[�°躸����] ������ຸ���� ��°��Һ�����
				<%}else if(item.getP_gubun().equals("37")){%>
				<br><br>[����Ʈȯ�ұ�] ����ް� ��ΰ���
				<%}else{%>								
				<br>[���] ����� ��ҵ漼 ���ֹμ�
				<br>[���޼�����] �����޼����� ��ҵ漼 ���ֹμ�
				<%}%>
			</td>
          </tr>		  
		</table>
	  </td>
	</tr> 			
	<tr>
	  <td align="right">&nbsp;
	  || p_cd1:<%=item.getP_cd1()%> || p_cd2:<%=item.getP_cd2()%> || p_cd3:<%=item.getP_cd3()%> || p_cd4:<%=item.getP_cd4()%> || p_cd5:<%=item.getP_cd5()%> ||p_cd6:<%=item.getP_cd6()%> ||
	  <br>|| p_st1:<%=item.getP_st1()%> || p_st2:<%=item.getP_st2()%> || p_st3:<%=item.getP_st3()%> || p_st4:<%=item.getP_st4()%> || p_st5:<%=item.getP_st5()%> ||
	  </td>
	</tr>  		
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��볻��</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr> 
    <tr id=tr_acct1 style='display:<%if(item.getAcct_code().equals("81100") || item.getAcct_code_g().equals("1")||item.getAcct_code_g().equals("2")||item.getAcct_code_g().equals("15")||item.getAcct_code_g().equals("3")){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="15%" rowspan="2" class='title'>����</td>
          			<td width="85%">&nbsp;
		      			<input type="radio" name="acct_code_g" value="1"  onClick="javascript:cng_input2(1)"  <%if(item.getAcct_code_g().equals("1"))%>checked<%%>>�Ĵ�
              			<input type="radio" name="acct_code_g" value="2"  onClick="javascript:cng_input2(2)"  <%if(item.getAcct_code_g().equals("2"))%>checked<%%>>������
			  			<input type="radio" name="acct_code_g" value="15" onClick="javascript:cng_input2(15)" <%if(item.getAcct_code_g().equals("15"))%>checked<%%>>������
			  			<input type="radio" name="acct_code_g" value="3"  onClick="javascript:cng_input2(3)"  <%if(item.getAcct_code_g().equals("3"))%>checked<%%>>��Ÿ
		  			</td>
		  		</tr>        		
        		<tr>
          			<td>
          				<table width="90%"  border="0" cellpadding="0" cellspacing="0">
              				<tr id=tr_acct1_1 style='display:<%if(item.getAcct_code_g2().equals("1")||item.getAcct_code_g2().equals("2")||item.getAcct_code_g2().equals("3")){%>""<%}else{%>none<%}%>'>
                				<td>&nbsp;
                  					<input type="radio" name="acct_code_g2" value="1" <%if(item.getAcct_code_g2().equals("1"))%>checked<%%>>����
				  					<input type="radio" name="acct_code_g2" value="2" <%if(item.getAcct_code_g2().equals("2"))%>checked<%%>>�߽�
				  					<input type="radio" name="acct_code_g2" value="3" <%if(item.getAcct_code_g2().equals("3"))%>checked<%%>>Ư�ٽ�
				  				</td>
              				</tr>
              				
              				<tr id=tr_acct1_2 style='display:<%if(item.getAcct_code_g2().equals("4")||item.getAcct_code_g2().equals("5")||item.getAcct_code_g2().equals("6")||item.getAcct_code_g2().equals("15")){%>""<%}else{%>none<%}%>'>
                				<td>&nbsp;
                  					<input type="radio" name="acct_code_g2" value="4" <%if(item.getAcct_code_g2().equals("4"))%>checked<%%>>ȸ����ü����
				  					<input type="radio" name="acct_code_g2" value="5" <%if(item.getAcct_code_g2().equals("5"))%>checked<%%>>�μ��� �������
				  					<input type="radio" name="acct_code_g2" value="6" <%if(item.getAcct_code_g2().equals("6"))%>checked<%%>>�μ��� ������ȸ��
				  					<input type="radio" name="acct_code_g2" value="15" <%if(item.getAcct_code_g2().equals("15"))%>checked<%%>>��ȣȸ 
				  					
				  				</td>
              				</tr>
           				</table>
           			</td>
        		</tr>
       		</table>
       	</td>
    </tr>	 
	
    <tr id=tr_acct2 style='display:<%if(item.getAcct_code().equals("45800") || item.getAcct_code_g().equals("13")||item.getAcct_code_g().equals("4")||item.getAcct_code_g().equals("5")||item.getAcct_code_g().equals("27")){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
      		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="8%" rowspan="2" class='title' >����</td>
          			<td width="7%" class='title'>����</td>
          		
          			<td width="85%">&nbsp;
          				<input type="radio" name="acct_code_g" value="13" <%if(item.getAcct_code_g().equals("13"))%>checked<%%>>���ָ�
						<input type="radio" name="acct_code_g" value="4" <%if(item.getAcct_code_g().equals("4"))%>checked<%%>>����
						<input type="radio" name="acct_code_g" value="5" <%if(item.getAcct_code_g().equals("5"))%>checked<%%>>LPG
						<input type="radio" name="acct_code_g" value="27" <%if(item.getAcct_code_g().equals("27"))%>checked<%%>>����/���� 	<!-- ���������� �߰� -->
			  		</td>
				</tr>				
				<tr>
					<td class='title'>�뵵</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g2" value="11" <%if(item.getAcct_code_g2().equals("11"))%>checked<%%>>����
						<input type="radio" name="acct_code_g2" value="12" <%if(item.getAcct_code_g2().equals("12"))%>checked<%%>>������ ����
						<input type="radio" name="acct_code_g2" value="13" <%if(item.getAcct_code_g2().equals("13"))%>checked<%%>>������
					</td>
				</tr>
			</table>
      	</td>
    </tr>
    <tr id=tr_acct3 style='display:<%if(item.getAcct_code().equals("45700") || item.getAcct_code_g().equals("6")||item.getAcct_code_g().equals("7")||item.getAcct_code_g().equals("8")||item.getAcct_code_g().equals("18")||item.getAcct_code_g().equals("21")||item.getAcct_code_g().equals("22")){%>""<%}else{%>none<%}%>'>    
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
	        	<tr>
	          		<td width="15%" class='title'>����</td>
	          		<td width="85%">&nbsp;
	          			<input type="radio" name="acct_code_g" value="6"   onClick="javascript:cng_input3(6)"  <%if(item.getAcct_code_g().equals("6"))%>checked<%%>>�Ϲ�����
						<input type="radio" name="acct_code_g" value="21"  onClick="javascript:cng_input3(21)" <%if(item.getAcct_code_g().equals("21"))%>checked<%%>>�縮������						
						<input type="radio" name="acct_code_g" value="7"   onClick="javascript:cng_input3(7)"  <%if(item.getAcct_code_g().equals("7"))%>checked<%%>>�ڵ����˻�
						<input type="radio" name="acct_code_g" value="18"  onClick="javascript:cng_input3(18)" <%if(item.getAcct_code_g().equals("18"))%>checked<%%>>��ȣ�Ǵ��
						<input type="radio" name="acct_code_g" value="22"  onClick="javascript:cng_input3(22)" <%if(item.getAcct_code_g().equals("22"))%>checked<%%>>��Ÿ						
					</td>
	        	</tr>
      		</table>
      	</td>
    </tr>
      	
    <tr id=tr_acct4 style='display:<%if(item.getAcct_code().equals("81200") || item.getAcct_code_g().equals("9")||item.getAcct_code_g().equals("10")){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="15%" class='title'>����</td>
          			<td width="85%">&nbsp;
            			<input type="radio" name="acct_code_g" value="9" <%if(item.getAcct_code_g().equals("9"))%>checked<%%>>�����
						<input type="radio" name="acct_code_g" value="10" <%if(item.getAcct_code_g().equals("10"))%>checked<%%>>��Ÿ�����
					</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    
    <tr id=tr_acct6 style='display:<%if(item.getAcct_code().equals("81300") || item.getAcct_code_g().equals("11")||item.getAcct_code_g().equals("12")||item.getAcct_code_g().equals("14")){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="15%" class='title'>����</td>
          			<td width="85%">&nbsp;
            			<input type="radio" name="acct_code_g" value="11" <%if(item.getAcct_code_g().equals("11"))%>checked<%%>>�Ĵ�
						<input type="radio" name="acct_code_g" value="12" <%if(item.getAcct_code_g().equals("12"))%>checked<%%>>������
						<input type="radio" name="acct_code_g" value="14" <%if(item.getAcct_code_g().equals("14"))%>checked<%%>>��Ÿ
					</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    
        	
    <tr id=tr_acct7 style='display:<%if(item.getAcct_code().equals("81400") || item.getAcct_code_g().equals("16")||item.getAcct_code_g().equals("17")){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="15%" class='title'>����</td>
          			<td width="85%">&nbsp;
            			<input type="radio" name="acct_code_g" value="16" <%if(item.getAcct_code_g().equals("16"))%>checked<%%>>����
						<input type="radio" name="acct_code_g" value="17" <%if(item.getAcct_code_g().equals("17"))%>checked<%%>>����
					</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    
    <tr id=tr_acct8 style='display:<%if(item.getAcct_code().equals("21700") || item.getAcct_code().equals("21900") || item.getAcct_code_g().equals("19") || item.getAcct_code_g().equals("23")){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="15%" class='title'>����</td>
          			<td width="85%">&nbsp;
            			<input type="radio" name="acct_code_g" value="19" <%if(item.getAcct_code_g().equals("19"))%>checked<%%>>�ڵ�����ϼ�
            			<input type="radio" name="acct_code_g" value="23" <%if(item.getAcct_code_g().equals("23"))%>checked<%%>>�ڵ�����漼						
					</td>
        		</tr>
      		</table>
      	</td>
    </tr>
	
  <tr id=tr_acct3_1 style='display:<%if(item.getAcct_code().equals("45600")||item.getAcct_code().equals("45700")||item.getAcct_code().equals("45800")||item.getAcct_code().equals("46400")||!item.getCost_gubun().equals("")){%>""<%}else{%>""<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>����</td>
          <td width="85%">&nbsp;
            <input name="car_info" type="text" class="text" value="<%=cr_bean.getCar_no()%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter()">			
            <a href="javascript:Rent_search();"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(������ȣ/��ȣ�� �˻�)</td>
        </tr>
      </table></td>
    </tr>
    
  <tr id=tr_acct3_4 style='display:<%if(item.getAcct_code().equals("45600")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" <%if(accid_dt.equals("")){%>rowspan="2"<%}%> class='title'>���</td>
          <td width="85%">&nbsp;
            <input name="accid_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(accid_dt)%>" size="15" style='IME-MODE: active' onKeyDown="javasript:Accid_enter()">
            <a href="javascript:Accid_search();"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			&nbsp;&nbsp;(���������϶�, ������ ���� �����ϰ� ��� ����)</td>
        </tr>
		<%if(accid_dt.equals("")){%>
        <tr>
          <td>&nbsp;
		    <%if(item.getReqseq().equals("")){%>
		    <input type='checkbox' name="accid_yn" value='Y' >
            �ڵ���ĵ���� �Ѵ�.  ===> [�Է��׸�]&nbsp;&nbsp;
			<%}else{%>
		    <font color='#666666'>[��ĵ��]&nbsp;&nbsp;</font>
			<%}%>		  		    
			�������&nbsp;:&nbsp;
			<input name="r_accid_dt" type="text" class="text" value="" size="11" style='IME-MODE: active' onBlur='javscript:this.value = ChangeDate(this.value);'>
			&nbsp;/&nbsp;
			�����&nbsp;:&nbsp;
            <select name='accid_st'>
              <option value="" >����</option>
              <option value="1" >������</option>
              <option value="2" >������</option>
              <option value="3" >�ֹ�</option>
              <option value="5" >�������</option>
              <option value="4" >��������</option>
              <option value="6" >����</option>
              <option value="7" >�縮������</option>
            </select>			
			</td>
        </tr>
		<%}%>  		
      </table>
	</td>
  </tr>	
		
  <tr id=tr_acct3_5 style='display:<%if((item.getAcct_code().equals("45700") && (item.getAcct_code_g().equals("6") || item.getAcct_code_g().equals("20"))) || item.getAcct_code().equals("45600")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" <%if(serv_dt.equals("")){%>rowspan="3"<%}%> class='title'>����</td>
          <td width="85%">&nbsp;
            <input name="serv_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(serv_dt)%>" size="15" style='IME-MODE: active' onKeyDown="javasript:Serv_enter()">
            <a href="javascript:Serv_search();"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			&nbsp;&nbsp;(���������-�Ϲ����� Ȥ�� ���������϶�, ������ ���� �����ϰ� ����)</td>
        </tr>
		<%if(serv_dt.equals("")){%>
        <tr>
          <td>&nbsp;
		    <%if(item.getReqseq().equals("")){%>
		    <input type='checkbox' name="serv_yn" value='Y' >
			�ڵ���ĵ���� �Ѵ�.  ===> [�Է��׸�]&nbsp;&nbsp;
			<%}else{%>
		    <font color='#666666'>[��ĵ��]&nbsp;&nbsp;</font>
			<%}%>
			��������&nbsp;:&nbsp;
			<input name="r_serv_dt" type="text" class="text" value="" size="11" style='IME-MODE: active' onBlur='javscript:this.value = ChangeDate(this.value);'>
			&nbsp;/&nbsp;
			����Ÿ�&nbsp;:&nbsp;
            <input name="tot_dist"  type="text" class="num" size="6" value="" onBlur='javascript:this.value=parseDecimal(this.value)'>
            &nbsp;km /&nbsp;
			���񳻿�&nbsp;:&nbsp;
		    <input name="rep_cont" type="text"  class="text" size="15" value="" style='IME-MODE: active'>
			</td>
        </tr>     		
        <tr>
          <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;			
			��ǰ��&nbsp;:&nbsp;
            <input name="r_amt"  type="text" class="num" size="10" value="" onBlur='javascript:this.value=parseDecimal(this.value)'>
            &nbsp;�� /&nbsp;
			���Ӱ�&nbsp;:&nbsp;
			<input name="r_labor" type="text" class="num" size="10" value="" onBlur='javascript:this.value=parseDecimal(this.value)'>
			&nbsp;�� /&nbsp;
			��ǰD/C&nbsp;:&nbsp;
		    <input name="r_dc" type="text" class="num" size="10" value="" onBlur='javascript:this.value=parseDecimal(this.value)'>
			&nbsp;�� &nbsp;&nbsp;
			<%if(!item.getReqseq().equals("")){%>
			<a href="javascript:insertServ()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>	
			<%}%>
			</td>
        </tr>
		<%}else{%>     		
		<input type="hidden" name="tot_dist" value="">
		<%}%>
      </table>
	</td>
  </tr>	
		
  <tr id=tr_acct3_6 style='display:<%if(item.getAcct_code().equals("45700") && (item.getAcct_code_g().equals("7") || item.getAcct_code_g().equals("8"))){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>		
        <tr>
          <td width="15%" <%if(maint_dt.equals("")){%>rowspan="2"<%}%> class='title'>�˻�</td>
          <td width="85%">&nbsp;
            <input name="maint_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(maint_dt)%>" size="15" style='IME-MODE: active' onKeyDown="javasript:Maint_enter()">
            <a href="javascript:Maint_search();"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(���������-����˻�/���а˻��϶�, ������ ���� �����ϰ� ����)</td>
        </tr>		
      </table>
	  </td>
    </tr>	
			
    <tr id=tr_acct3_2 style='display:<%if(item.getAcct_code().equals("45800")){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
		          <td width="15%" class='title'>����</td>
		          <td width="85%">&nbsp;
		          			<select name="o_cau" >
		        			    <option value="">--����--</option>
		        				<%for(int i = 0 ; i < c_size ; i++){
		        					CodeBean code = codes[i];	%>
		        				<option value='<%=code.getNm_cd()%>' <%if(code.getNm_cd().equals(item.getO_cau()))%>selected<%%>><%= code.getNm()%></option>
		        				<%}%>
		          			</select>
		            &nbsp;*�������� ��� ���þ��ص� ��.
		            <%if(!from_page.equals("/fms2/consignment_new/cons_oil_doc_frame.jsp") && item.getI_amt()>0 && item.getAcct_code_g2().equals("12") && item.getAcct_code().equals("45800") && item.getM_doc_code().equals("")){%>
        		    <a href="javascript:M_doc_action('pay', '', '<%=item.getReqseq()%>', '<%=item.getI_seq()%>', '<%=item.getBuy_user_id()%>', '1', '');" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='������氨��û���� ����ϱ�'><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a>
            		    <%}%>
		          </td>
		        </tr>
    
      		</table>
      	</td>
    </tr>
    
    <tr id=tr_acct3_3 style='display:<%if(item.getAcct_code().equals("45600")||item.getAcct_code().equals("45700")){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
		          <td width="15%" class='title'>�����̿���</td>
		          <td width="35%">&nbsp;
		       		   <input type='text' size='15' class='text'  name='call_t_nm' value='<%=item.getCall_t_nm()%>'>
					   <a href="javascript:CarMgr_search();"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>			                
		          </td>
		         <td width="15%" class='title'>����ó</td>
		         <td width="35%">&nbsp;
		         	<input type='text' size='15' class='text'  name='call_t_tel' value='<%=item.getCall_t_tel()%>'>
		          </td>
		        </tr>            
      		</table>
      	</td>
    </tr>
		
    <tr id=tr_acct98 style="display:''">
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="15%" class='title'>����</td>
          			<td width="85%">&nbsp;
            			<textarea name="p_cont" cols="90" rows="2" class="text"><%=item.getP_cont()%></textarea> (�ѱ�40���̳�)
            		</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
	<%if(!mode.equals("view")){%>	
	<tr>
	  <td align="right">
	  <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>					  
	      <a id="submitLink" href="javascript:save()">
	      <%if(item.getReqseq().equals("")){%>
	      <%	if(total_amt1 >total_amt2){%>
	      <img src=/acar/images/center/button_reg.gif border=0 align=absmiddle>
	      <%	}%>	  	  
	      <%}else{%>
	      <img src=/acar/images/center/button_modify.gif border=0 align=absmiddle>	  
	      <%}%>
	      </a>
	      <%if(!item.getReqseq().equals("")){%>
	      <%	if(pay.getP_step().equals("0") || nm_db.getWorkAuthUser("������",user_id)){%>
	      &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:item_delete();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
	      <%	}%>
	      <%}%>	  
	  <%}%>
	  </td>
	</tr>  			
	<%}else{%>	
    <tr>
	    <td align='right'>
	    <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<%}%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�μ�/����/�ݾ� �Է�</span> 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:pay_user_excel();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='����ڵ���Ÿ�� ������ �̿��� ����Ѵ�.'><img src=/acar/images/center/button_reg_excel.gif border=0 align=absmiddle></a>
		</td>        
    </tr>		
    <tr id=tr_acct99 style='display:<%if(item.getUser_su().equals("")||item.getUser_su().equals("0")){%>none<%}else{%>""<%}%>'>
    	<td colspan="2" class="line">
      		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr><td class=line2></td></tr>
        		<tr>
          			<td width="15%" class='title'>�ο�</td>                                                                                                                                                                                                          
          			<td width="35%">&nbsp;
            			<input name="user_su" type="text" class="text" value="<%=item.getUser_su()%>" size="3" onBlur="javascript:cng_input1()">��       		  
            			<input name="user_cont" type="hidden" class="text"  value="<%=item.getUser_cont()%>" size="10">
					</td>          
          			<td width="15%" class='title'>���κ� ����ݾ�</td>              	
              		<td width="35%">	
			     		<input type="radio" name="user_Rdio" value="0" onClick="javascript:cng_input1()" checked> 1/n
			      		<input type="radio" name="user_Rdio" value="1" onClick="javascript:cng_input1()">�ݾ� �����Է� &nbsp;
			      		<input type="hidden"  name="buy_a_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					</td>
          		</tr>
          	</table>
        </td>
    </tr>		
  	<tr>
		<td id=tr_acct101 style='display:<%if(item.getUser_su().equals("")||item.getUser_su().equals("0")){%>none<%}else{%>""<%}%>'>
			<table border="0" cellspacing=0 cellpadding=0 width="100%">
				<tr>
					<td class=line>
						<table width="100%" border="0" cellspacing="1" cellpadding="0">
                        	<tr>
	                         	<td width="7%" class='title'>����</td>
	                         	<td width="15%" class='title'>�μ�</td>
								<td width="15%" class='title'>����</td>
							 	<td width="13%" class='title'>�ݾ�</td>
								<td width="7%" class='title'>����</td>
	                         	<td width="15%" class='title'>�μ�</td>
								<td width="15%" class='title'>����</td>
							 	<td width="13%" class='title'>�ݾ�</td>
                        	</tr>
                        <%	Vector vts1 = pm_db.getPayItemUserList(reqseq, i_seq);
							int vt_size1 = vts1.size();
							
							if ( vt_size1 % 2 == 1 ) {
							  chk = "1";
							}
						%>
							
						<%	for(int j = 0 ; j < vt_size1 ; j+=2){
							
								Hashtable ht = (Hashtable)vts1.elementAt(j);
								Hashtable ht2 = new Hashtable();
								if(j+1 < vt_size1){
										ht2 = (Hashtable)vts1.elementAt(j+1);
										
								}%>					
													
                        	<tr>
	                         	<td align="center"><%=j+1%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+1%>);">>	
          								<option value=''>��ü</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(String.valueOf(ht.get("DEPT_ID")).equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden" value='<%=ht.get("PAY_USER")%>'>
									<input name="user_nm" type="text" class="text" value='<%=ht.get("USER_NM")%>' size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+1%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("PAY_AMT")))%>" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
								  	<td align="center"><%=j+2%></td>
					            <%if(j+1 < vt_size1){%>
								<td align="center">
								   		<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>��ü</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(String.valueOf(ht2.get("DEPT_ID")).equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden" value='<%=ht2.get("PAY_USER")%>'>
									<input name="user_nm" type="text" readonly class="text" value='<%=ht2.get("USER_NM")%>' size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht2.get("PAY_AMT")))%>" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								<% } else  { %>	
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>��ü</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
								
								<% }  %>	
								</td>
							</tr>								
							<%}%>							
							<!-- �߰� -->						
						<%	if 	(chk.equals("1"))  {
									 vt_size1 = vt_size1 + 1;
							}	
							for( int j = vt_size1 ; j < user_size ; j+=2){
						
						%>
                        	<tr>
	                         	<td align="center"><%=j+1%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+1%>);">>	
          								<option value=''>��ü</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+1%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
								
									<td align="center"><%=j+2%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>��ü</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
							</tr>								
							<%}%>
							<tr>
								<td colspan="7" class='title'>����</td>
								<td align="center">
									<input name="txtTot" class="text" value="" style="text-align:right;" size="14">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	</tr>  
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>	
  </table>
</form>
<script language='javascript'>
<!--
	Keyvalue();
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

