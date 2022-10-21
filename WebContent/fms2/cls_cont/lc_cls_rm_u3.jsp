<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, tax.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.credit.*, acar.fee.*, acar.car_sche.*, acar.doc_settle.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"5":request.getParameter("doc_bit");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	String client_id 	= "";
	String site_id 		= "";
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	client_id = base.getClient_id();
	
	if(base.getTax_type().equals("2")){//����
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
		
	String client_st = client.getClient_st(); //2:����

	String print_nm = "";
	if ( client.getPrint_st().equals("2")) {
		print_nm = "�ŷ�ó���չ���";
	} else if  ( client.getPrint_st().equals("3")) {
		print_nm = "�������չ���";
	} else if (  client.getPrint_st().equals("4")) {
		print_nm = "�������չ���";
	} else if  ( client.getPrint_st().equals("9")) {
		print_nm = "Ÿ�ý��۹���";
	}
		
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
			
		//fee ��Ÿ - ����Ÿ� �ʰ��� ���  - fee_etc ��  over_run_amt > 0���� ū ��� �ش��
//	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd,  "1");
		
	ClsEtcOverBean co = ac_db.getClsEtcOver(rent_mng_id, rent_l_cd);
	 	 
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();	

	//����� ����Ʈ
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//���뺸���� 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
	int  ext_amt = 0;
		
	//�����Ƿ�����
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st();
		
		//������Ÿ �߰� ����
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);
		
	//�����Ƿڻ������
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);
	
	//����ȸ������
	CarRecoBean carReco = ac_db.getCarReco(rent_mng_id, rent_l_cd);
	
	//ä�ǰ�������
	CarCreditBean carCre = ac_db.getCarCredit(rent_mng_id, rent_l_cd);
			
		// ��������������	
	ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);		
			
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	String doc_step = "";
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("11", rent_l_cd);
		doc_no = doc.getDoc_no();
		doc_step = doc.getDoc_step();
	}else{
		doc = d_db.getDocSettle(doc_no);
		doc_step = doc.getDoc_step();
	}
		
	//ȸ�����ں��ʹ� ��ü������ȸ	
		
	//���������
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
		
	//������ ���ݰ�꼭
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
	int re_day= ac_db.getRemainFeeDay(rent_l_cd, fee_tm, cls.getCls_dt());
	
	//���ݰ�꼭 ������� - ���������
	ClsEtcTaxBean ct = ac_db.getClsEtcTaxCase(rent_mng_id, rent_l_cd, 1);
			
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
	Vector cms_bnk = c_db.getCmsBank();	//������� �����´�.
	int cms_bnk_size1 = cms_bnk.size();		
		
    String dly_pubcode = "";	
    dly_pubcode = ac_db.getClsPayEbillDly(rent_mng_id, rent_l_cd);
    
    String dft_pubcode = "";	
    dft_pubcode = ac_db.getClsPayEbillNoTax(rent_mng_id, rent_l_cd, "dft");
    
    String etc_pubcode = "";	
    etc_pubcode = ac_db.getClsPayEbillNoTax(rent_mng_id, rent_l_cd, "etc");
    
    String etc2_pubcode = "";	
    etc2_pubcode = ac_db.getClsPayEbillNoTax(rent_mng_id, rent_l_cd, "etc2");
    
    String etc4_pubcode = "";	
    etc4_pubcode = ac_db.getClsPayEbillNoTax(rent_mng_id, rent_l_cd, "etc4"); 
    
    int maeip_amt = 0;
    int over_amt = 0;
    int jungsan_amt = 0;
       
   	//������ �Ա���
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
		//���Կɼ��� (sui)
	String m_sui_dt = request.getParameter("m_sui_dt")==null?"":request.getParameter("m_sui_dt");
	
	//�������� ����Ʈ
	Vector vt_ext = as_db.getClsList(base.getClient_id());
	int vt_size = vt_ext.size();
	
	
	//������10���� ��������
	String modify_deadline = AddUtil.replace(c_db.addMonth(AddUtil.ChangeDate2(cls.getCls_dt()), 1),"-","").substring(0,6)+"10";
	
	if(modify_deadline.equals("20171010")) modify_deadline = "20171013";
	
	
	//û�������� ��ȸ - �����
	TaxItemListBean t1 = IssueDb.getTaxItemListCls(rent_l_cd, "���������");
	
	//û�������� ��ȸ2 - ��Ÿ���ع���
	TaxItemListBean t2 = IssueDb.getTaxItemListCls(rent_l_cd, "��Ÿ���ع���");
	
	String  theURL  =  "https://fms3.amazoncar.co.kr/data/cls/";

	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "CLS_ETC";
	String content_seq  = rent_mng_id+""+rent_l_cd;

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;							
						
	 CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;   
	
	Vector vt_ip = ac_db.getIpMethod(rent_l_cd);  
 	int vt_ip_size = vt_ip.size();	
  	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
<!--
	
	//��ĵ���� ����
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}	
		
	//��Ÿ �뿩�ὺ���ٰ����� �̵�	
	function move_fee_scd(){
		var fm = document.form1;	
		
		fm.action = "/fms2/con_fee/fee_scd_u_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>";
		fm.target = 'd_content';		
		fm.submit();							
	}
	
//���꼭 �μ�
	function cls_print(){
		var fm = document.form1;

		var SUBWIN="lc_cls_print.jsp?gg=m&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=700, height=650, resizable=yes, scrollbars=yes, status=yes");
		
	}

//����Ʈ
	function list(){
		var fm = document.form1;	
				
		fm.action = 'lc_cls_rm_d_frame.jsp';
		
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//�� ����
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=550, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//�뿩���
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=600, resizable=yes, scrollbars=yes, status=yes");
	}		
				
	function save(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
	
			
		//ȯ�ұݾ� + �߰� �Աݾ� ���� ���ݾ��� ū��� 
		if( ( toInt(parseDigit(fm.c_amt.value))  + toInt(parseDigit(fm.ex_ip_amt.value)) -  toInt(parseDigit(fm.fdft_amt1_2.value)) )  < -1 ) {
				
			alert("ȯ�Ұ����ѱݾ� �ѵ������� ����� �� �ֽ��ϴ�.\n ���ݾ��� �����Ͻʽÿ�.!!");
			return;
		}	
				
		if( toInt(parseDigit(fm.ex_ip_amt.value)) > 0 ){
		
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;		
			
			if(deposit_no.indexOf(":") == -1){
				fm.deposit_no2.value = deposit_no;
			}else{
				var deposit_split = deposit_no.split(":");
				fm.deposit_no2.value = deposit_split[0];	
	 		}
	 		
	 		if(fm.bank_code.value == ""){ alert("������ �����Ͻʽÿ�."); return; }			
			if(fm.deposit_no.value == ""){ alert("���¹�ȣ�� �����Ͻʽÿ�."); return; }		
 		}
 		
 				//������ �ݾ��� �ִٸ�
		if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
		
		 	if ( toInt(parseDigit(fm.h5_amt.value)) !=  toInt(parseDigit(fm.ori_h5_amt.value))  ) {
				alert("ī����ұݾ��� ����Ǿ����ϴ�. ������ ��  �����ϴ�..!!");
				return;
		 	}			
		}	
			
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_u1_a.jsp';	

			fm.target='d_content';
			fm.submit();
		}
	}
		
	//�ΰ��� �� ���� ����
	function save3(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
				
		if( toInt(parseDigit(fm.ex_ip_amt.value)) > 0 ){
		
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;		
			
			if(deposit_no.indexOf(":") == -1){
				fm.deposit_no2.value = deposit_no;
			}else{
				var deposit_split = deposit_no.split(":");
				fm.deposit_no2.value = deposit_split[0];	
	 		}
	 		
	 		if(fm.bank_code.value == ""){ alert("������ �����Ͻʽÿ�."); return; }			
			if(fm.deposit_no.value == ""){ alert("���¹�ȣ�� �����Ͻʽÿ�."); return; }		
 		}
 				
			
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_u3_a.jsp';	

			fm.target='d_content';
			fm.submit();
		}
	}
	
	//���÷��� Ÿ��
	function cls_display(){
		var fm = document.form1;
					
		tr_ret.style.display		= '';	//����ȸ��				
		tr_sale.style.display 		= 'none';   //�����Ű�			
		
		set_init();
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
		fm.fdft_amt3.value='0';
	   			
	}	

	//���÷��� Ÿ�� - ����ȸ������
	function cls_display2(){
		var fm = document.form1;
			
		if(fm.reco_st[1].checked == true){  //��ȸ�� ���ý�
			td_ret1.style.display 	= 'none';
			td_ret2.style.display 	= '';
		}else{
			td_ret1.style.display 	= '';
			td_ret2.style.display 	= 'none';
		}
	}	
	
	//���÷��� Ÿ��
	function cls_display3(){
		var fm = document.form1;
	
		if(fm.div_st.options[fm.div_st.selectedIndex].value == '2'){
			td_div.style.display 	= '';
		}else{
			td_div.style.display 	= 'none';
		}
	}	
	
	//���÷��� Ÿ��
	function cancel_display(){
	   //�����Ա��� 0���� ���� ���: ������ ���� �ִ� ��츸 ���������� �� ����.
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[1].selected = true;
			alert('�ߵ���������ݾ��� '+fm.fdft_amt2.value+'������ ȯ���ؾ� �մϴ�. \n\n�̿� ���� ��쿡�� ������Ҹ� �����մϴ�.');
			return;			
		}		
	}		

						
	//Ȯ���ݾ� ����
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
	
		/*
		if(obj == fm.dft_amt_1){ //�ߵ�����
			fm.tax_supply[0].value 	= obj.value;
			if (fm.tax_chk0.checked == true) {
	 				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );		 		
			} else {
					fm.tax_value[0].value 	= '0';				
			}				
		
		}else if(obj == fm.etc_amt_1){ //ȸ�����ֺ��
			fm.tax_supply[1].value 	= obj.value;
			if (fm.tax_chk1.checked == true) {
				 fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 fm.tax_value[1].value 	= '0';
			}		
		
		}else if(obj == fm.etc2_amt_1){ //ȸ���δ���
			fm.tax_supply[2].value 	= obj.value;
			if (fm.tax_chk2.checked == true) {
					fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[2].value 	= '0';
			}		
		
		}else if(obj == fm.etc4_amt_1){ //��Ÿ���ع���
			fm.tax_supply[3].value 	= obj.value;			
			if (fm.tax_chk3.checked == true) {
				 	fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[3].value 	= '0';
			}
			
	//	}else if(obj == fm.over_amt_1){ //�ʰ�����δ�� ����		 
		}else 
		*/
		
		if(obj == fm.m_over_amt){ //�ʰ�����δ�� ����		 
					
    		fm.j_over_amt.value =  toInt(parseDigit(fm.r_over_amt.value)) - toInt(parseDigit(obj.value)) ;  
    		    		
    		if (  toInt(parseDigit(fm.j_over_amt.value)) > 0) {
    		
			//	fm.over_amt.value =  fm.j_over_amt.value;  
				fm.over_amt_1.value =  fm.j_over_amt.value ;
			
				fm.tax_supply[4].value 	=  fm.j_over_amt.value;					
				fm.tax_chk4.value  = 'Y' ;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );
				fm.over_v_amt_1.value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );	 
		  } else {
		 	//	fm.over_amt.value =  '0';  
				fm.over_amt_1.value =  '0' ;  			
				fm.tax_supply[4].value 	=  '0';					
				fm.tax_chk4.value  = 'N' ;
				fm.tax_value[4].value 	= '0';		
				fm.over_v_amt_1.value 	= '0';
		  }		 					  		  		
						
		}	
		
		var no_v_amt = 0;
				//���� �ΰ��� ����Ͽ� ���Ѵ�.	 
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  +   ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1) -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		var no_v_amt2 	 = no_v_amt;
					
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt2) );		
					
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 	= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));					
		}		
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}									
		if ( fm.tax_chk3.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));			  
		}		
		
//		if ( fm.tax_chk4.checked == true) {
//			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));			  
//	}						
		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.over_amt.value))   +  toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value))   +  toInt(parseDigit(fm.no_v_amt_1.value)));	 //Ȯ���ݾ�	
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
						
	
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
							
		//ä������ ����
		if ( toInt(parseDigit(fm.fdft_amt2.value)) > 0)	{	
			tr_get.style.display		= '';	//ä�����ڱ�å
		} else {		
			tr_get.style.display		= 'none';	//ä�����ڱ�å
		}			
		
		//set_tax_init();
	}	
	
	//Ȯ���ݾ� ����
	function set_cls_s_amt(){
		var fm = document.form1;	
		
						
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
	  	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value))   + toInt(parseDigit(fm.no_v_amt_1.value)));	 //Ȯ���ݾ�	
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
					
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
				
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );					
	}			
	
	function set_cls_amt4_vat(){
		var fm = document.form1;
		
		fm.dfee_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) * 0.1 );
		
		if(fm.tax_chk0.checked == true ){		
			fm.dft_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dft_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk1.checked == true ){
			fm.etc_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk2.checked == true ){
			fm.etc2_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc2_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk3.checked == true ){
			fm.etc4_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc4_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk4.checked == true ){
			fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );
		}
			
	//	fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );
				
	    set_cls_amt4();				   
	}
		
	//���ݾ� - �ܾ׼���
	function set_cls_amt4(){
		var fm = document.form1;
			
		fm.no_v_amt_2.value =  parseDecimal( toInt(parseDigit(fm.dfee_amt_2_v.value)) + toInt(parseDigit(fm.tax_r_value[0].value))+ toInt(parseDigit(fm.tax_r_value[1].value))+ toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value))  + toInt(parseDigit(fm.over_amt_2_v.value)) );	
										
		fm.fdft_amt1_2.value 	= parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) + toInt(parseDigit(fm.dly_amt_2.value))+ toInt(parseDigit(fm.dft_amt_2.value)) + toInt(parseDigit(fm.car_ja_amt_2.value)) + toInt(parseDigit(fm.fine_amt_2.value)) + toInt(parseDigit(fm.etc_amt_2.value)) + toInt(parseDigit(fm.etc2_amt_2.value)) + toInt(parseDigit(fm.etc3_amt_2.value)) + toInt(parseDigit(fm.etc4_amt_2.value))  + toInt(parseDigit(fm.over_amt_2.value))  + toInt(parseDigit(fm.no_v_amt_2.value)) );	 //���ݾ�	
		
		if( ( toInt(parseDigit(fm.c_amt.value))  + toInt(parseDigit(fm.ex_ip_amt.value)) -  toInt(parseDigit(fm.fdft_amt1_2.value)) )  < -1 ) {
			alert("ȯ�Ұ����ѱݾ� �ѵ������� ����� �� �ֽ��ϴ�.\n ���ݾ��� �����Ͻʽÿ�.!!");
		}					   
	}
		
	//���ݰ�꼭 check ���� �ΰ��� - �����Ծ׿� �ΰ��� ��ŭ ���Ѵ�(�뿩��, ��å���� ���� (�̹� ��������)) - ���ݰ�꼭 ����Ǹ� �ܻ����ݰ��� 
	function set_vat_amt(obj){
		var fm = document.form1;
		
		if(obj == fm.tax_chk0){ // �����
		 	if (obj.checked == true) {
		 			fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		 			fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[0].value)));		
			} else {
					fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[0].value)));		
			}	
	
		} else if(obj == fm.tax_chk1){ // ȸ�����
			 if (obj.checked == true) {
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[1].value)));
			 } else {
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[1].value)));
			 }	
		} else if(obj == fm.tax_chk2){ // �δ���
			 if (obj.checked == true) {
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[2].value)));
			 } else {
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[2].value)));
			 }	
		} else if(obj == fm.tax_chk3){ // ��Ÿ���ع���
			 if (obj.checked == true) {
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[3].value)));
			 } else {
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[3].value)));
			 }
		} else if(obj == fm.tax_chk4){ // �ʰ�����δ��
			 if (obj.checked == true) {
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));
			 } else {
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[4].value)));
			 }		 	
		}	
		
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );			
				
	}
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
		
	//��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx, "VENDOR_LIST", "left=50, top=50, width=500, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}

	function clsContReg(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}				
		
				//���̳ʽ� ��꼭 ���� �Ұ� �׸���� ��� check
<%		for (int i = 0; i <  3 ; i++) { %>		
	
			if ( fm.tax_r_chk<%=i%>.checked == true   ) {
				alert(" <%=i+1%>�� ��꼭 ������ ����꼭�� ã�Ƽ� ���������ϼ���.!!!");
				return;
			}					
		
<%		 } %>
	
	  //ī���������� ��������� ȯ�ұ� 0�� ������ 
	  if ( toInt(parseDigit(fm.fdft_amt2.value)) == 0 ) {
		 	if ( toInt(parseDigit(fm.h5_amt.value))  > 0  &&   toInt(parseDigit(fm.h7_amt.value))  > 0   ) {
		 	  	   fm.h5_amt.value = "0";
		 	      fm.h7_amt.value = "0";
		 	      fm.jung_st.value = "1";		 	   				
		 	}			
		}						
	
		if(confirm('����ó���Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_cont_reg_a.jsp';	

			fm.target='d_content';
			fm.submit();
		}		
	}

	function clsContAutoDocReg(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
		
		fm.real_dt.value = fm.cls_dt.value; 
		
		//��꼭 ������ �ִ� ��츸 check
		if ( fm.tax_r_chk0.checked == false && fm.tax_r_chk1.checked == false && fm.tax_r_chk2.checked == false && fm.tax_r_chk3.checked == false && fm.tax_r_chk4.checked == false && fm.tax_r_chk5.checked == false && fm.tax_r_chk6.checked == false && fm.tax_r_chk7.checked == false) {	
		 
		} else {
		
		    if ( toInt(replaceString("-","",fm.real_dt.value)) >  toInt(replaceString("-","",fm.today_dt.value))) { //������(�Ա���)�� ���Ϻ��� ū��� ��꼭 ���� �ȵ� 
				alert('������(�Ա���)�� ���ú��� Ŭ ���� �����ϴ�.');
				return;
			} 	
							
			//�������Ѻ��� ���ó�¥�� Ŭ ��� ����
			if(toInt(replaceString("-","",fm.modify_dt.value)) < toInt(replaceString("-","",fm.today_dt.value)) ){
				alert('��꼭 �������� ����Ǿ����ϴ�. Ȯ���ϼ���');
				return;		
			}	
			
			//�����׸� ǰ���� �Է¾ȵǾ����� �� check		
		<%	for (int i = 0; i <9 ; i++) { %>		
				if ( fm.tax_r_chk<%=i%>.checked == true)  {
				    if ( fm.tax_r_g[<%=i%>].value  == '' )  
				    { 
				         alert("<%=i+1%>�� ǰ���� Ȯ���ϼ���"); 	
					return;		
				    }
				}    			
		<%	} %>	 
			
		} 
					
		if(confirm('ȸ��ó���Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_cont_autodoc_reg_a.jsp';	

			fm.target='d_content';
			fm.submit();
		}
	}		
		
	function clsContAutoDocReReg(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
		
			
		if(confirm('��ǥ������� ������ǥ ������ �۾��ϼž� �մϴ�. �����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_cont_autodoc_re_reg_a.jsp';	

			fm.target='d_content';
			fm.submit();
		}
	}		
	
	function clsContAutoDocReReg1(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
		
			
		if(confirm('���ݰ�꼭&��ǥ������� ���� ��꼭 �� ��ǥ ������ �۾��ϼž� �մϴ�. �����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_cont_autodoc_reg_a1.jsp';	

			fm.target='d_content';
			fm.submit();
		}		

	}				
	
	function update(st){
		
		if (st == 'cls_jung') {	
			window.open("/fms2/cls_cont/updateClsJung.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=50, width=1150, height=850, resizable=yes, scrollbars=yes, status=yes");
		} else if (st == 'cls_etc') {	
			window.open("/fms2/cls_cont/updateClsEtc.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1150, height=650, resizable=yes, scrollbars=yes, status=yes");			
		} else if (st == 'cls_reco') {  //�Ա���,ȸ���� ����	
			window.open("/fms2/cls_cont/updateCarReco.jsp<%=valus%>", "CHANGE_ITEM", "left= 50, top=100, width=1150, height=550, resizable=yes, scrollbars=yes, status=yes");					
	   	} else {
			window.open("/fms2/cls_cont/updateTrGet.jsp<%=valus%>", "CHANGE_ITEM", "left=50, top=100, width=1150, height=550, resizable=yes, scrollbars=yes, status=yes");
		} 
				
	}
	
	
	function scan_reg(gubun){
		window.open("reg_scan.jsp?gubun="+gubun+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
		
		//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
//		theURL = "https://fms3.amazoncar.co.kr/data/cls/"+theURL;
		window.open(theURL,winName,features);
	}

	function view_agnt_email(gubun, pay_amt, pubcode)
	{
		var fm = document.form1;

		if(pubcode == ''){
			var SUBWIN="lc_cls_payebill_u.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&trusbill_gubun="+gubun+"&pay_amt="+pay_amt;
			window.open(SUBWIN, "agnt_email", "left=100, top=50, width=700, height=350, resizable=yes, scrollbars=yes, status=yes");
		}else{
			viewDepoSlip(pubcode);
		}			
	}
	
	function view_agnt_email1(gubun, pay_amt, item_id)
	{
		var fm = document.form1;		
		
		if(item_id == ''){
			var SUBWIN="lc_cls_taxitem_u.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&trusbill_gubun="+gubun+"&pay_amt="+pay_amt;
			window.open(SUBWIN, "agnt_email1", "left=100, top=50, width=700, height=350, resizable=yes, scrollbars=yes, status=yes");
		}else{
			ViewTaxItem(item_id);
		}	
	}
	
	function ViewTaxItem(item_id){		
		var taxItemInvoice = window.open("about:blank", "TaxItem", "resizable=yex,  scrollbars=yes, status=yes, left=50,top=20, width=1000px, height=800px");
		var fm = document.form1;
		fm.target="TaxItem";
		fm.action = "/tax/issue_1_tax/tax_item_u.jsp?item_id="+item_id;
		fm.submit();			
	}	
	
	function  viewDepoSlip(depoSlippubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var depoSlip = window.open("about:blank", "depoSlip", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=750px, height=700px");
		document.depoSlipListForm.action="https://www.trusbill.or.kr/jsp/directDepo/DepoSlipViewIndex.jsp";
		document.depoSlipListForm.method="post";
		document.depoSlipListForm.depoSlippubCode.value=depoSlippubCode;
		document.depoSlipListForm.docType.value="P"; 	//�Ա�ǥ
		document.depoSlipListForm.userType.value="S"; 	// S=�������� ó��ȭ��, R= �޴��� ó��ȭ��
		document.depoSlipListForm.target="depoSlip";
		document.depoSlipListForm.submit();
		document.depoSlipListForm.target="_self";
		document.depoSlipListForm.depoSlippubCode.value="";
		depoSlip.focus();
		return;
	}	
	
	function set_cls_tax_value(v_type){
		var fm = document.form1;
		
		if(v_type == '1'){ // �̳��뿩��
			fm.tax_rr_value[3].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[3].value)) * 0.1 );	
		} else if(v_type == '2' ){ // ���������
			fm.tax_rr_value[4].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[4].value)) * 0.1 );		
		} else if(v_type == '3'){ // ���ֺ��
			fm.tax_rr_value[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[5].value)) * 0.1 );	
		} else if(v_type == '4'){ // �δ���
			fm.tax_rr_value[6].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[6].value)) * 0.1 );	
		} else if(v_type == '5'){ // ���ع���
			fm.tax_rr_value[7].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[7].value)) * 0.1 );	
		} else if(v_type == '6'){ //  �ʰ�����δ��
			fm.tax_rr_value[8].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[8].value)) * 0.1 );		
		}	
			
	    set_cls_tax_hap();				   
	}
	
	function set_cls_tax_hap(){
		
		var fm = document.form1;		
								
		for(var i=2 ; i<9 ; i++){
			  fm.tax_rr_hap[i].value 	= parseDecimal( toInt(parseDigit(fm.tax_rr_supply[i].value)) +  toInt(parseDigit(fm.tax_rr_value[i].value)));				
		}
				   
	}
	
	//Ư�̻���  ����
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	

	function sendMail(m_id, l_cd){
		window.open("/acar/car_rent/rent_email_reg.jsp?mtype=cls&m_id="+m_id+"&l_cd="+l_cd+"&br_id=S1", "RentDocEmail", "left=100, top=100, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
	function clsExt_st(){
		var fm = document.form1;
					
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_ext_st_a.jsp';	

			fm.target='d_content';
			fm.submit();
		}
	}
		
		
	//���� - cls_etc, car_cre
	function sac_delete(doc_bit) {
		var fm = document.form1;
		
		fm.doc_bit.value = doc_bit;  
			
		if(confirm('�����Ƿڳ����� �����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_d_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}		
	}	
	
	function clsContEtcReg(){
		var fm = document.form1;
					
		if(confirm('ī���������� �����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_card_etc_a.jsp';	

			fm.target='d_content';
			fm.submit();
		}
	}
	
	//ī����Ұ��� ������ ����
	function updateCardDate(){
		var theForm = document.form1;
	
		if(theForm.r_date.value == '')				{ alert('ī����ҽ������� �Է��Ͻʽÿ�'); 		theForm.r_date.focus(); 		return;	}
		
		if(!confirm('ī����ҽ����� �����Ͻðڽ��ϱ� ?')){		return;	}
		theForm.target = "i_no";
		//theForm.action = "card_r_dt_up_a.jsp";
		theForm.action = "lc_cls_update_a.jsp?m_gubun=card_r_dt";
		theForm.submit();
	}

	//���� ������ - ���Կɼǿ�  
	function sendMail(m_id, l_cd){
		window.open("/acar/car_rent/rent_email_reg.jsp?pur_email=rm_etc&m_id="+m_id+"&l_cd="+l_cd+"&br_id=S1", "RentDocEmail", "left=100, top=100, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");		
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
<form name="depoSlipListForm" method="get">
	<input type="hidden" name="depoSlippubCode" >
	<input type="hidden" name="docType" >
	<input type="hidden" name="userType" >
</form>

<form action='' name="form1" method='post'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 	value='<%=andor%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name="fee_size"			value="<%=fee_size%>">    

<input type='hidden' name='car_mng_id' value='<%=base.getCar_mng_id()%>'>
<input type='hidden' name="mode" 			value="<%=mode%>">     

<input type='hidden' name='car_no' value='<%=cr_bean.getCar_no()%>'>
<input type='hidden' name='car_nm' value='<%=cr_bean.getCar_nm()%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>

<input type='hidden' name="doc_bit" 		value="">              
  
<input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
<input type='hidden' name="from_page" 	value="<%=from_page%>">

<input type='hidden' name='cls_s_amt' value='<%=AddUtil.parseDecimal(cls.getCls_s_amt())%>' >
<input type='hidden' name='cls_v_amt' value='<%=AddUtil.parseDecimal(cls.getCls_v_amt())%>' >
          
<input type='hidden' name='bank_code2' value='<%=clsm.getEx_ip_bank()%>'>
<input type='hidden' name='deposit_no2' value='<%=clsm.getEx_ip_bank_no()%>'>
<input type='hidden' name='bank_name' value=''>
  
<input type='hidden' name="re_day" 		value="<%=re_day%>">  
<input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>"> 

<input type='hidden' name="gubun1" 		value="<%=gubun1%>"> 

<!-- ������ ��꼭 check -->
<input type='hidden' name="today_dt" 	value="<%=AddUtil.getDate()%>">
<input type='hidden' name="real_dt" 	value="">
<input type='hidden' name="modify_dt" 	value="<%=modify_deadline%>">
 
<input type='hidden' name='jung_st' value='<%=cct.getJung_st()%>'> 
                      
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	 <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>����ý��� > ����Ʈ���� ><span class=style5>����Ʈ�������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(!mode.equals("view")){%>
    <tr>
	    <td align='right'>
	     &nbsp;&nbsp;<a href="javascript:sendMail('<%=rent_mng_id%>', '<%=rent_l_cd%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_send_mail.gif" align=absmiddle border=0></a> 
	    &nbsp;<a href='javascript:cls_print();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_print_jss.gif align=absmiddle border=0></a>
	    &nbsp;&nbsp;<a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
	    </td>
	</tr>
	<%}%>   
	<tr> 
        <td class=line2></td>
    </tr>	
  
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>����ȣ</td>
            <td width=22%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;<a href="javascript:view_cng_etc('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='Ư�̻���'><img src=/acar/images/center/button_tish.gif align=absmiddle border=0></a>
              &nbsp;<a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='��ĵ����'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
            </td>
            <td class=title width=10%>��������</td>
            <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
            <td class=title width=10%>��������</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
          </tr>
          <tr> 
            <td class=title>���ʿ�����</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
            <td class=title>�����븮��</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
            <td class=title>���������</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
          </tr>
          <tr>
            <td class=title>�������</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
            <td class=title>��౸��</td>
            <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>�ű�<%}else if(rent_st.equals("3")){%>����<%}else if(rent_st.equals("4")){%>����<%}%></td>
            <td class=title>��������</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("4")){%>����Ʈ<%} %></td>
          </tr>
    
          <tr>
            <td class=title>��ȣ</td>
            <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a></td>
            <td class=title>��ǥ��</td>
            <td>&nbsp;<%=client.getClient_nm()%></td>
            <td class=title>����/����</td>
            <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=site.getR_site()%></a></td>
          </tr>
          <tr>
            <td class=title>������ȣ</td>
            <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a></td>
            <td class=title width=10%>����</td>
            <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
			<font color="#999999">(�����ڵ�:<%=cm_bean.getJg_code()%>)</font>
			</td>
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
        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
          <tr>
            <td style="font-size : 9pt;" width="3%" class=title rowspan="2">����</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">�������</td>
            <td style="font-size : 9pt;" width="6%" class=title rowspan="2">�̿�Ⱓ</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 9pt;" width="7%" class=title rowspan="2">�����</td>
            <td style="font-size : 9pt;" width="9%" class=title rowspan="2">���뿩��</td>
            <td style="font-size : 9pt;" class=title colspan="2">������</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">������</td>
            <td style="font-size : 9pt;" class=title colspan="2">���ô뿩��</td>
            <td style="font-size : 9pt;" class=title colspan="2">���Կɼ�</td>
          </tr>
          <tr>
            <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 9pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 9pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 9pt;" width="3%" class=title>%</td>			
          </tr>
		  <%for(int i=0; i<fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				if(!fees.getCon_mon().equals("")){
				
				s_opt_per = fees.getOpt_per();
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
				%>	
          <tr>
            <td style="font-size : 9pt;" align="center"><%=i+1%></td>
            <td style="font-size : 9pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
            <td style="font-size : 9pt;" align="center"><%=fees.getCon_mon()%>����</td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%=fees.getOpt_per()%></td>
          </tr>
		  <%}}%>
        </table>
	  </td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td style='height:1; background-color=d2d2d2;' ></td>
	</tr>
	<tr>
	    <td></td>
	</tr>		
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������&nbsp;
	      <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id)  || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id)  || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)  || nm_db.getWorkAuthUser("����������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || nm_db.getWorkAuthUser("����Ʈ����",user_id)  ){%>     
	  	 			 <a href="javascript:update('cls_etc')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
		<% } %>
	 </span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='13%' class='title'>��������</td>
            <td width="13%">&nbsp; 
			  <select name="cls_st" onChange='javascript:cls_display()' disabled >
			    <option value="14" <%if(cls.getCls_st().equals("����Ʈ����"))%>selected<%%>>����Ʈ����</option>    
		      </select> </td>
                      					  
            <td width='13%' class='title'>�Ƿ���</td>
            <td width="13%">&nbsp;
              <select name='reg_id'  >
                <option value="">����</option>
                <%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(cls.getReg_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
                <%		}
					}%>
              </select></td>	
                      
            <td width='13%' class='title'>��������</td>
            <td width="13%">&nbsp;
			  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt())%>' readonly size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 
		    <td width='13%' class='title'>�̿�Ⱓ</td>
		    <td >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' value='<%=cls.getR_mon()%>' readonly  >����&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=cls.getR_day()%>' readonly >��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>���� </td>
            <td colspan="7">&nbsp;
              <textarea name="cls_cau" cols="140" class="text" style="IME-MODE: active" rows="3"><%=cls.getCls_cau()%></textarea>
			
            </td>
          </tr>
          <tr>                                                      
            <td class=title >�ܿ�������<br>������ҿ���</td>
     	    <td>&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'  >
                <option value="N" <% if(cls.getCancel_yn().equals("N")){%>selected<%}%>>��������</option>
                <option value="Y" <% if(cls.getCancel_yn().equals("Y")){%>selected<%}%>>�������</option>
              </select>
		    </td>
		   
            <td  colspan="6" align=left>&nbsp;&nbsp;�� ����� ��꼭�� ���� �Ǵ� ��ҿ��� �� Ȯ���� �ʿ�, ������ҽ� ���̳ʽ� ���ݰ�꼭 ���� </td>
          </tr>
           <tr>      
		            <td width='10%' class='title'>����Ÿ�</td>
		            <td>&nbsp;
					  <input type='text' name='tot_dist' size='10' value='<%=AddUtil.parseDecimal(cls.getTot_dist())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km 
		            </td>
		            <td colspan=6   align=left>&nbsp;&nbsp;�� �ߵ����� �� ����� ��������Ÿ� </td>	         
		           
		  		</tr>         
        </table>
      </td>
    </tr>

     <tr></tr><tr></tr>    
    
     <tr id=tr_dae style="display:none"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
                    <td width="13%" class=title>�������������</td>
                    <td width="20%">&nbsp; &nbsp;
                      <input type='radio' name="prv_dlv_yn" value='N' <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%> disabled>
                      ����
                      <input type='radio' name="prv_dlv_yn" value='Y' <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%> disabled>
        	 		�ִ�
        		    </td>
                    <td width="10%" class=title style="font-size : 8pt;">�����Ⱓ���Կ���</td>
                    <td colspan=3 >&nbsp; &nbsp;
                      <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> disabled>
                      ������
                      <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> disabled>
        	 		����
        		    </td>
                </tr>
                <%	for(int i = 0 ; i < ta_vt_size ; i++){
						Hashtable ta_ht = (Hashtable)ta_vt.elementAt(i);
       					taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, ta_ht.get("NO")+"");
    			%>   
                 <tr>
                    <td width="13%" class=title>������ȣ</td>
                    <td width="20%">&nbsp;<%=taecha.getCar_no()%>                  
        			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
        			</td>
                    <td width="10%" class='title'>����</td>
                    <td>&nbsp;<%=taecha.getCar_nm()%></td>
                    <td class='title'>���ʵ����</td>
                    <td>&nbsp;<%=taecha.getInit_reg_dt()%></td>
                </tr>
                <tr>
                    <td class=title>�뿩������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
                    <td class='title'>�뿩������</td>
                    <td width="20%" >&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
                    <td width="10%" class=title >���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>��(vat����) 
        			</td>
                </tr>	
                <%} %>		 		     
		       </table>
		      </td>        
         </tr>   
         <tr>
     		<td>&nbsp;<font color="#FF0000">***</font> ������������� �ִ� ��� �������� ������ ���� �� ������ ȯ�ҵ˴ϴ�.!! </td>    
     	 </tr>
     	 <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
    
  
    <tr id=tr_ret style="display:''""> 
  
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ȸ��
			    <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id)  || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)  || nm_db.getWorkAuthUser("����������",user_id)  || nm_db.getWorkAuthUser("����������",user_id)  || nm_db.getWorkAuthUser("����Ʈ����",user_id) ){%>     
	  	 			 <a href="javascript:update('cls_reco')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
				<% } %>
			  </span></td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		  			
			<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 
			            <td width='13%' class='title'>ȸ������</td>
			            <td width="20%">&nbsp;<input type="radio" name="reco_st" value="Y"  <%if(carReco.getReco_st().equals("Y"))%>checked<%%> >ȸ��
	                            <input type="radio" name="reco_st" value="N" <%if(carReco.getReco_st().equals("N"))%>checked<%%> >��ȸ��</td>
	                    <td width='13%' class='title'>����</td>
	                    
	                    <td id=td_ret1 style="display:<%if( carReco.getReco_st().equals("Y") ){%>''<%}else{%>none<%}%>"> &nbsp; 
						  <select name="reco_d1_st" disabled >
						    <option value="1" <%if(carReco.getReco_d1_st().equals("����ȸ��"))%>selected<%%>>����ȸ��</option>
						    <option value="2" <%if(carReco.getReco_d1_st().equals("����ȸ��"))%>selected<%%>>����ȸ��</option>
						    <option value="3" <%if(carReco.getReco_d1_st().equals("����ȸ��"))%>selected<%%>>����ȸ��</option>
			               </select>       
			            </td>
			            
			            <td id=td_ret2 style="display:<%if( carReco.getReco_st().equals("N") ){%>''<%}else{%>none<%}%>"> &nbsp;  
						  <select name="reco_d2_st" disabled >
						    <option value="1" <%if(carReco.getReco_d2_st().equals("����"))%>selected<%%>>����</option>
						    <option value="2" <%if(carReco.getReco_d2_st().equals("Ⱦ��"))%>selected<%%>>Ⱦ��</option>
						    <option value="3" <%if(carReco.getReco_d2_st().equals("���"))%>selected<%%>>���</option>						  
						   </select>       
			            </td>
			            
			            <td class='title' width='13%' >����</td>
						<td>&nbsp;
						<input type="text" name="reco_cau" value='<%=carReco.getReco_cau()%>'size=30 maxlength=100 readonly >
						</td>				        		         
		         </tr>
		                   
		         <tr>      
		            <td width='10%' class='title'>ȸ������</td>
		            <td>&nbsp;
					  <input type='text' name='reco_dt' readonly  value='<%=carReco.getReco_dt()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		            <td width='10%' class='title'>ȸ�������</td>
		            <td>&nbsp;
					  <select name='reco_id' disabled >
		                <option value="">����</option>
		                  <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                 <option value='<%=user.get("USER_ID")%>' <%if(carReco.getReco_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
		                 <%		}
						 	}%>							           
		              </select>
		            </td>
		            <td width='10%' class='title'>�԰�����</td>
		            <td>&nbsp;
					  <input type='text' name='ip_dt' readonly size='12' value='<%=carReco.getIp_dt()%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		          </tr>
		       
		 			<tr>           
		            <td class=title>��������ġ</td>
	                     <td colspan=5> 
	                      &nbsp;<SELECT NAME="park" >
				                 <option value="" <% if(carReco.getPark().equals("")){%>selected<%}%>>--����--</option>
				                 
				                  <%if(good_size > 0){ 			
	                   			   for(int i = 0 ; i < good_size ; i++){
                  								CodeBean good = goods[i];%>
		       		          <option value='<%= good.getNm_cd()%>' <% if(carReco.getPark().equals(good.getNm_cd() ) )  {%>selected<%}%>><%= good.getNm()%></option>
		                 <%		}
						 	}%>						
	        		        		</SELECT>
							<input type="text" name="park_cont" value='<%=carReco.getPark_cont()%>' readonly  size="35" class=text style='IME-MODE: active'>
							 (��Ÿ���ý� ����)
							 </td>
					</tr>
					<tr>		 
	                    	<td class=title>������ ��밡��</td>
                    	    <td >&nbsp;<input type="radio" name="serv_st" value="Y"  <%if(cls.getServ_st().equals("Y"))%>checked<%%> >��ð���
	                            <input type="radio" name="serv_st" value="N" <%if(cls.getServ_st().equals("N"))%>checked<%%> >������ ����</td>
	                       <td class=title>������ ����</td>
                    	    <td colspan=3>&nbsp;<input type="radio" name="serv_gubun" value="1"  <%if(cls.getServ_gubun().equals("1"))%>checked<%%> >�縮��/����Ʈ
	                            &nbsp;<input type="radio" name="serv_gubun" value="3" <%if(cls.getServ_gubun().equals("3"))%>checked<%%> >����Ʈ
	                            &nbsp;<input type="radio" name="serv_gubun" value="2" <%if(cls.getServ_gubun().equals("2"))%>checked<%%> >�Ű�</td>      	 
		          </tr>
		          
		          <tr>      
		            <td width='10%' class='title'>���ֺ��</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='12' readonly value='<%=AddUtil.parseDecimal(carReco.getEtc_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
		            </td>
		            <td width='10%' class='title'>�δ���</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='12'  readonly value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
		            </td>
		            <td width='10%' class='title'>����</td>
		            <td>&nbsp;
					 <input type='text' name='etc_out_amt' size='12' readonly value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt() + carReco.getEtc_d1_amt())%>' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
		            </td>
		          </tr>
		      
		        </table>
		      </td>
		    </tr>
		    <tr>
		      <td>&nbsp;</td>
		    </tr>	
		</table>
      </td>	 
    </tr>	     
		    
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ݾ� ����</span>[���ް�]</td>
	</tr>
	
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
		            <td  colspan="2" class='line'> 
		              <table border="0" cellspacing="1" cellpadding="0" width="100%">
		                <tr> 
		                  <td class='title' align='right' colspan="3">�׸�</td>
		                  <td class='title' width='38%' align="center">����</td>
		                  <td class='title' width="40%">���</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="7" width=4%>ȯ<br>
		                    ��<br>
		                    ��<br>
		                    ��</td>
		                  <td class='title' colspan="2">������(A)</td>
		                  <td class='title' > 
		                    <input type='text' name='grt_amt' readonly value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
		                    ��</td>
		                  <td class='title'>&nbsp;</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3" width=4%>��<br>
		                    ��<br>
		                    ��<br>
		                    ��<br>
		                    ��</td>
		                  <td width="14%" align="center" >����Ⱓ</td>
		                  <td align="center"> 
		                    <input type='text' size='3' name='ifee_mon' readonly  value='<%=cls.getIfee_mon()%>'  class='num' maxlength='4' >
		                    ����&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='<%=cls.getIfee_day()%>' class='num' maxlength='4' >
		                    ��</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >����ݾ�</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' readonly value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
		                    ��</td>
		                  <td>=���ô뿩�᡿����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ���ô뿩��(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    ��</td>
		                  <td class='title'>=���ô뿩��-����ݾ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">��<br>
		                    ��<br>
		                    ��</td>
		                  <td align='center'>�������� </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
		                    ��</td>
		                  <td>=�����ݡ����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td align='center'>������ �����Ѿ� </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
		                    ��</td>
		                  <td>=�������ס����̿�Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ������(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
		                    ��</td>
		                  <td class='title'>=������-������ �����Ѿ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">��</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' >
		                    ��</td>
		                  <td class='title'>=(A+B+C)</td>
		                </tr>
		              </table>
		            </td>
			     </tr>
    
            </table>
        </td>
    </tr>
   	<tr></tr><tr></tr><tr></tr>
  	
    <input type='hidden' name='ex_ip_amt'  value='0'> 
    <input type='hidden' name='ex_ip_dt' > 
    <input type='hidden' name='bank_code' > 
    <input type='hidden' name='deposit_no' > 
   
    <tr>
        <td></td>
    </tr>
    
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳��ݾ� ����</span>[���ް�]&nbsp;
	  <%if(!mode.equals("view")){%>
	  <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id)  || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id)  || nm_db.getWorkAuthUser("����������",user_id) ||  nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id)   ){%>     
	  	  <a href="javascript:update('cls_jung')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
	  <% } %>
	  <%}%>
	   </span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    
       <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
              <td class="title" colspan="4" rowspan=2>�׸�</td>
              <td class="title" width='38%' colspan=3> ä��</td>                
              <td class="title" width='40%' rowspan=2>���</td>
            </tr>
            <tr>                 
              <td class="title"'> ���ʱݾ�</td>
              <td class="title"'> Ȯ���ݾ�</td>
              <td class="title"'> ���ݾ�</td>
            </tr>
            <tr> 
              <td class="title" rowspan="27" width="4%">��<br>
                ��<br>
                ��<br>
                ��<br>
                ��</td>
              <td class="title" colspan="3">���·�/��Ģ��(D)</td>
              <td align="center" class="title"> 
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' >
               ��</td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num'  > 
               ��</td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_2'  value='<%=AddUtil.parseDecimal(clss.getFine_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>
              
              <td class="title">���Ϻλ��Ұ�</td>
             </tr>
             <tr> 
              <td class="title" colspan="3">�ڱ��������ظ�å��(E)</td>
              <td width='13%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' >
                ��</td>
              <td width='13%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>'   size='15' class='num'  > 
                ��</td>   
              <td width='12%' align="center" class="title">
              <input type='text' name='car_ja_amt_2'  value='<%=AddUtil.parseDecimal(clss.getCar_ja_amt_2())%>'   size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>
                          
              <td width='40%' class="title">���Ϻλ��Ұ�</td>
            </tr>
             <tr>
              <td class="title" rowspan="4" width="4%"><br>
                ��<br>
                ��<br>
                ��</td>
              <td align="center" colspan="2" class="title">������</td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>'  size='15' class='num' >
                ��</td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt_1' readonly  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' >
                ��</td> 
              <td class='' align="center">&nbsp;</td>         
                             
              <td>&nbsp;</td>
             
            </tr>
         
            <tr> 
              <td rowspan="2" align="center" class="title" width="4%">��<br>
                ��</td>
              <td width='10%' align="center" class="title">�Ⱓ</td>
              <td class='' colspan=3  align="center"> 
                <input type='text' size='3' name='nfee_mon' value='<%=cls.getNfee_mon()%>' readonly class='num' maxlength='4' >
                ����&nbsp;&nbsp;&nbsp; 
                <input type='text' size='3' name='nfee_day' value='<%=cls.getNfee_day()%>'  readonly class='num' maxlength='4' >
                ��</td>
              <td>&nbsp;
               
              </td>
            </tr>
            <tr> 
              <td align="center" class="title">�ݾ�</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt'  readonly  value='<%=AddUtil.parseDecimal(cls.getNfee_amt())%>' class='num' > ��</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>  
              <td align="center">&nbsp;</td>   
              <td>������꼭�� ���� �Ǵ� ��ҿ��θ� Ȯ��</td>
            </tr>
             <tr> 
              <td class="title" colspan="2">�Ұ�(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt' value='<%=AddUtil.parseDecimal(cls.getDfee_amt())%>' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>  
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_2'  value='<%=AddUtil.parseDecimal(clss.getDfee_amt_2())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'> ��</td>
               
                <td class='title'>=������ + �̳�</td>
            </tr>
          
             <input type='hidden' size='15' name='d_amt' >          
              <input type='hidden' size='15' name='d_amt_1'> 
                    
            <tr> 
              <td rowspan="6" class="title">��<br>
                ��<br>
                ��<br>
                ��<br>
                ��<br>
                ��<br>
                ��</td>
              <td align="center" colspan="2" class="title">�뿩���Ѿ�</td>
              <td class='' colspan=3  align="center"> 
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
              <td>=������+���뿩���Ѿ�</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">���뿩��(ȯ��)</td>
              <td class='' colspan=3 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' >
                ��</td>
              <td>=�뿩���Ѿס����Ⱓ</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��뿩���Ⱓ</td>
              <td class=''  colspan=3  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4' >
                ����&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day' readonly size='3' value='<%=cls.getRcon_day()%>' class='num' maxlength='4' >
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
              <td class=''  colspan=3 align="center"> 
                <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' readonly size='15' class='num' >
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> ����� 
                �������</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int' readonly value='<%=cls.getDft_int()%>' size='5' class='num'  maxlength='4'>
                %</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int_1' readonly value='<%=cls.getDft_int_1()%>' size='5' class='num'  maxlength='4'>
                %</td>
              <td class=''  align="center">&nbsp;</td> 
              <td>*����� ��������� ��༭�� Ȯ�� <br><font color=red>*</font>��������� ������ �߻��� ����ȿ������ڸ� �ݵ�� ����</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">�ߵ����������(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' >
                ��</td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' >
                ��</td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_2' size='15' class='num'  value='<%=AddUtil.parseDecimal(clss.getDft_amt_2())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>
                 <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' size='15' class='num' >            
                <td class="title">&nbsp;
                   <%if( clss.getDft_amt_1() > 0 && cls.getTax_chk0().equals("N") ){%>
			  <%  if (  nm_db.getWorkAuthUser("������",user_id) ||  nm_db.getWorkAuthUser("����������",user_id)  || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	  <a href="javascript:view_agnt_email1('dft', '<%=clss.getDft_amt_1()%>', '<%=t1.getItem_id()%>')"><img src=/acar/images/center/button_cgsbh.gif align=absmiddle border=0></a>
			  <% } %>
		  <%}%>     
			  
           	  <%if( clss.getDft_amt_2() > 0 && cls.getTax_chk0().equals("N") ){%>
			  <%  if (  nm_db.getWorkAuthUser("������",user_id) ||  nm_db.getWorkAuthUser("����������",user_id)  || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	  <a href="javascript:view_agnt_email('dft', '<%=clss.getDft_amt_2()%>', '<%=dft_pubcode%>')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
			  <% } %>
			  <%}%>                
               &nbsp;<input type='checkbox' name='tax_chk0'  value='Y' <%if(cls.getTax_chk0().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled ><!--��꼭�����Ƿ�-->
               &nbsp;<font color="#FF0000">*</font>����ȿ�������: 
               		  <select name='dft_cost_id'  disabled >
		                <option value="">����</option>
		                  <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                 <option value='<%=user.get("USER_ID")%>' <%if(cls.getDft_cost_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
		                 <%		}
						 	}%>							           
		              </select>    
                              
               </td>
            </tr>      
       
            <tr> 
              <td class="title" rowspan="6"><br>
                ��<br>
                Ÿ</td>          
              <td colspan="2" align="center" class="title">��ü��(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getDly_amt())%>' size='15' class='num' > ��</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1'  readonly value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_2'  value='<%=AddUtil.parseDecimal(clss.getDly_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>
             
              <td class='title'>&nbsp;
           	  <%if( clss.getDly_amt_2() > 0 ){%>
			  <%  if (  nm_db.getWorkAuthUser("������",user_id) ||  nm_db.getWorkAuthUser("����������",user_id)   || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	  <a href="javascript:view_agnt_email('dly', '<%=clss.getDly_amt_2()%>', '<%=dly_pubcode%>')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
			  <% } %>
			  <%}%>
              </td>
            </tr>
            <tr> 
              <td class="title" colspan="2">����ȸ�����ֺ��(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt())%>' size='15' class='num' >
                ��</td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                ��</td>  
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_2'  value='<%=AddUtil.parseDecimal(clss.getEtc_amt_2())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'> ��</td> 
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_v())%>' size='15' class='num' >  
               <td class="title">&nbsp;
              <%if( clss.getEtc_amt_2() > 0 && cls.getTax_chk1().equals("N") ){%>
			  <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	  <a href="javascript:view_agnt_email('etc', '<%=clss.getEtc_amt_2()%>', '<%=etc_pubcode%>')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
			  <% } %>
			  <%}%>
               &nbsp;<input type='checkbox' name='tax_chk1'  value='Y' <%if(cls.getTax_chk1().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled >��꼭�����Ƿ�</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">����ȸ���δ���(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>' size='15' class='num' >
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                ��</td>  
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_2' value='<%=AddUtil.parseDecimal(clss.getEtc2_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'> ��</td>   
                <input type='hidden' name='tax_value' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_v())%>' size='15' class='num' >  
               <td class="title">&nbsp;
              <%if( clss.getEtc2_amt_2() > 0 && cls.getTax_chk2().equals("N") ){%>
			  <%  if (  nm_db.getWorkAuthUser("������",user_id) ||  nm_db.getWorkAuthUser("����������",user_id)   || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	  <a href="javascript:view_agnt_email('etc2', '<%=clss.getEtc2_amt_2()%>', '<%=etc2_pubcode%>')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
			  <% } %>
			  <%}%>
               &nbsp;<input type='checkbox' name='tax_chk2'  value='Y' <%if(cls.getTax_chk2().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled >��꼭�����Ƿ�</td>
            </tr>
            <tr> 
              <td colspan="2" class="title">������������(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' >
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>'size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                ��</td> 
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_2' value='<%=AddUtil.parseDecimal(clss.getEtc3_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'> ��</td>    
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">��Ÿ���ع���(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>'  size='15' class='num' >
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                ��</td>  
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_2' value='<%=AddUtil.parseDecimal(clss.getEtc4_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'> ��</td> 
               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' size='15' class='num' >  
              <td class="title">&nbsp;
                 <%if( clss.getEtc4_amt_1() > 0 && cls.getTax_chk3().equals("N") ){%>
			  <%  if (  nm_db.getWorkAuthUser("������",user_id) ||  nm_db.getWorkAuthUser("����������",user_id)  || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			 	
			  	  <a href="javascript:view_agnt_email1('etc4', '<%=clss.getEtc4_amt_1()%>', '<%=t2.getItem_id()%>')"><img src=/acar/images/center/button_cgsbh.gif align=absmiddle border=0></a>
			  <% } %>
		  <%}%>  
              <%if( clss.getEtc4_amt_2() > 0 && cls.getTax_chk3().equals("N") ){%>
			  <%  if (  nm_db.getWorkAuthUser("������",user_id) ||  nm_db.getWorkAuthUser("����������",user_id)   || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	  <a href="javascript:view_agnt_email('etc4', '<%=clss.getEtc4_amt_2()%>', '<%=etc4_pubcode%>')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
			  <% } %>
			  <%}%>
               &nbsp;<input type='checkbox' name='tax_chk3' value='Y' <%if(cls.getTax_chk3().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);" disabled ><!--��꼭�����Ƿ�&nbsp;-->
               
               <%if( cls.getEtc4_amt_1() > 0 ) {%>
                 
                 <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"2";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>
    						&nbsp;<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>			                 
    						<%}%>
                 
                <%}%>
                
               </td>
                                             
            </tr>
               
             <tr> 
              <td class="title" colspan="2">�ʰ�����뿩��(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt())%>'  size='15' class='num' >
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                ��</td>  
              <td align="center" class="title"> 
                <input type='text' name='over_amt_2' value='<%=AddUtil.parseDecimal(clss.getOver_amt_2())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4_vat();'> ��</td>             
              <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getOver_amt_v())%>' size='15' class='num' >  
              <td class="title">&nbsp;<input type='checkbox' name='tax_chk4' value='Y' <%if(cls.getTax_chk4().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);" disabled >��꼭�����Ƿ�&nbsp;</td>                               
            </tr>
              
            <tr> 
              <td class="title" rowspan="9"><br>
                ��<br>
                ��<br>
                ��</td> 
              <td width='10%' align="center" class="title" colspan=2 >�ܿ����ô뿩��</td>
                <td align="center" class="title"> 
               </td>
              <td align="center" class="title">  
                </td>  
               <td align="center" class="title"> 
                <input type='text' name='rifee_amt_2_v' <% if ( clss.getRifee_amt_2_v() < 0 ) { %> value='<%=AddUtil.parseDecimal(clss.getRifee_amt_2_v())%>' <% } else { %> value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_v())%>' <% } %> size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>
              <td class="title">&nbsp;</td>
            </tr>
            
            <tr> 
              <td align="center" class="title" colspan=2 >�ܿ�������</td>
                <td align="center" class="title"> 
                </td>
              <td align="center" class="title"> 
                </td>  
               <td align="center" class="title"> 
                <input type='text' name='rfee_amt_2_v' <% if ( clss.getRfee_amt_2_v() < 0 ) { %> value='<%=AddUtil.parseDecimal(clss.getRfee_amt_2_v())%>' <% } else { %>  value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_v())%>' <% } %>  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" class="title" colspan=2 >�뿩��</td>
                 <td align="center" class="title"> 
                </td>
              <td align="center" class="title"> 
                </td>  
               <td align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getDfee_amt_2_v())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��
               
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" class="title" colspan=2 >���������</td>
                <td align="center" class="title"> 
                </td>
              <td align="center" class="title"> 
                </td>  
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getDft_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>
              <td class="title">&nbsp;</td>
            </tr>    
            <tr> 
              <td align="center" class="title" colspan=2 >ȸ�����ֺ��</td>
              <td align="center" class="title"> 
              </td>
              <td align="center" class="title"> 
               </td>  
               <td align="center" class="title"> 
                <input type='text' name='etc_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getEtc_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>
             <td class="title">&nbsp;</td>
            </tr>    
            <tr> 
              <td align="center" class="title" colspan=2 >ȸ���δ���</td>
                <td align="center" class="title"> 
                </td>
              <td align="center" class="title"> 
                </td>  
               <td align="center" class="title"> 
                <input type='text' name='etc2_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getEtc2_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>
             <td class="title">&nbsp;</td>
            </tr>  
            <tr> 
              <td align="center" class="title" colspan=2 >��Ÿ���ع���</td>
              <td align="center" class="title"> 
              </td>
              <td align="center" class="title"> 
               </td>  
               <td align="center" class="title"> 
                <input type='text' name='etc4_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getEtc4_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>  
             <td class="title">&nbsp;</td>
            </tr>    
             <tr> 
              <td align="center" class="title" colspan=2>�ʰ�����뿩��</td>
              <td align="center" class="title"> 
              </td>
              <td align="center" class="title"> 
               </td>  
               <td align="center" class="title"> 
                <input type='text' name='over_amt_2_v' value='<%=AddUtil.parseDecimal(clss.getOver_amt_2_v())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>  
             <td class="title">&nbsp;</td>
            </tr>                                            
                   
            <tr> 
              <td class="title" colspan="2">�Ұ�(N)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt())%>' readonly size='15' class='num' >
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>' readonly size='15' class='num' >
                ��</td>  
               <td align="center" class="title"> 
                <input type='text' name='no_v_amt_2' value='<%=AddUtil.parseDecimal(clss.getNo_v_amt_2())%>' readonly size='15' class='num'>
                ��</td>
               
              <td > 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                 <tr> 
                    <td id=td_cancel_n style="display:<%if( cls.getCancel_yn().equals("N") ){%>none<%}else{%>''<%}%>" class="title">=(F+M-B-C)��10%  </td>
                    <td id=td_cancel_y style="display:<%if( cls.getCancel_yn().equals("Y") ){%>none<%}else{%>''<%}%>" class='title'>=(F+M-B-C)��10%  </td>
                  </tr>
                
                </table>
              </td>
            </tr>
            
            <tr> 
              <td class="title_p" colspan="4">��</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1'value='<%=AddUtil.parseDecimal(cls.getFdft_amt1())%>' readonly  size='15' class='num' >
                ��</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' readonly  size='15' class='num' >
                ��</td>  
               <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_2' value='<%=AddUtil.parseDecimal(clss.getFdft_amt1_2())%>' readonly  size='15' class='num' >
                ��</td>   
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M+N)&nbsp;&nbsp;              
                <br>�� ��꼭:&nbsp;              
               <input type="radio" name="tax_reg_gu" value="N"  <%if(cls.getTax_reg_gu().equals("N")){%>checked<%}%> >�׸񺰰�������
               <input type="radio" name="tax_reg_gu" value="Y"  <%if(cls.getTax_reg_gu().equals("Y")){%>checked<%}%> >�׸����չ���(1��)
           <!--    <input type="radio" name="tax_reg_gu" value="Z"  <%if(cls.getTax_reg_gu().equals("Z")){%>checked<%}%> >�뿩����������û�� -->
              
              </td>
            </tr>
          </table>
        </td>         
    </tr>
   
    <tr></tr><tr></tr><tr></tr>
    
   <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10%>�����Աݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2' readonly  value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>' size='15' class='num'  > ��</td>
                   	<td colspan=6>&nbsp;<input type='hidden' name='cms_chk' value='<%=cls.getCms_chk()%>' >
                   <%if(cls.getCms_chk().equals("Y")){%>
              		<font color="blue">(CMS�����Ƿ�)</font>&nbsp;
              		<% } %>   
                    �� �̳��Աݾװ� - ȯ�ұݾװ�
                  <!-- ī������� ���� ���� - ���� ������ ��Һ��� ���� �� ���� (1ȸ���� �ƴϿ��� )  getCntClsContEtc()-->                    
                    <% if ( user_id.equals("000063") && cct.getH5_amt() < 1 && cls.getFdft_amt2() < 0  ) {%>
             		 <a href="javascript:clsContEtcReg();">ī����������</a>             		 
             		<% } %>      
                    </td>             		     
              </tr>
             
              </table>
         </td>       
    </tr>
    
   <tr>
        <td>&nbsp;</td>
    </tr>  
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ����������� CMS(ī��CMS)�� �����ϴ°��� CMS�����Ƿڿ� check �ϼ���. </td>
    </tr>       
    
   <tr>
        <td>&nbsp;<font color="#FF0000">*** �̿�Ⱓ 1���� �̸��� ȯ���� �߻��� ��� ī����ι�ȣ Ȯ���Ͽ� ī������� �ش��ϱ��� �̿�ݾ��� �ٽ� ī�� �����ϼž� �մϴ�. ī��������� �ݾ��� �ݵ�� Ȯ���ϼ���!!! </font></td>
    </tr>

    <tr> 
   	
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�� �ֱ� 2����</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
         	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                 <tr>
                   <td width='5%' class='title' >����</td>              
                   <td width='10%' class='title' >1ȸ������ </td>	
                   <td width='15%' class='title'>������</td>
        		   <td width='10%' class='title'>����ݾ�</td>
        		   <td width='10%' class='title'>���ι�ȣ</td>
		           <td width="10%" class='title'>����</td>		           
				           	
				  </tr>	
                </table>
            </td>
         </tr>             
         
<% if (    vt_ip_size   > 0 ) { %>
		 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
<%
		for(int i = 0 ; i < vt_ip_size ; i++)
		{
				Hashtable htc = (Hashtable) vt_ip.elementAt(i);	%>               
              <tr>
                    <td width='5%' align='center'><%=i+1%></td>	                    
                       <td width='10%' align='center'><%=htc.get("F_TM_CHK")%></td>
        		       <td width='15%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(htc.get("R_DATE")))%></td>
		               <td width="10%" align='center'><%=Util.parseDecimal(String.valueOf(htc.get("R_AMOUNT")))%></td>		               
		               <td width='10%' align='center'><%=ac_db.getCardAppr_no(rent_l_cd, (String)htc.get("R_DATE")) %></td>	
		               <td width='10%' align='center' >
		                <% if ( String.valueOf(htc.get("IP_METHOD")).equals("1") ) {%>������ü<%} else { %>ī��<% } %></td>						             	
				   </tr>	
		<%		}    %>  		
                </table>
            </td>
         </tr>             
	<%		}    %>  	
   
    <tr>
        <td>&nbsp;</td>
    </tr> 
          
    <tr></tr><tr></tr><tr></tr>      
    
	<tr id=tr_card style="display:<%if( cls.getFdft_amt2() < 0  && cct.getH5_amt()  > 0  ){%>''<%}else{%>none<%}%>"> 

 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
         <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ī������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	 	 	
 	 	  <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >ī����ұݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='h5_amt'  size='15' class='num' value='<%=AddUtil.parseDecimal(cct.getH5_amt() ) %>' > ��</td>     
                    <td class=title width=12%>&nbsp; ī��(��) ����ݾ�</td>
                   	<td  width=12% ><input type='text' name='h7_amt'    size='15' class='num' value='<%=AddUtil.parseDecimal(cct.getH7_amt() ) %>' > ��</td>
                  	<td class=title width=12%>&nbsp; ī����� ������</td>
                   	<td >&nbsp;<input type='text' name='r_date' size='12' class='text' value='<%=cct.getR_date()%>' >    
                   	   
                   	 <%  if (  nm_db.getWorkAuthUser("������",user_id)  || nm_db.getWorkAuthUser("����������",user_id) ||  nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id)   ){%>     
	  	             <a href="javascript:updateCardDate()">[ī����� ������ ����]</a>
	    	         <% } %>
	    	                     	
                   	</td> 
                 	<td colspan=3>
                 				<input type='hidden' name='ori_h5_amt'    size='15' class='num' value='<%=AddUtil.parseDecimal(cct.getH5_amt() ) %>' >
                 				<input type='hidden' name='ori_h7_amt'    size='15' class='num' value='<%=AddUtil.parseDecimal(cct.getH7_amt() ) %>' >
                 	</td> 
              </tr>
          
              </table>
         </td>       
      <tr>
   </table>
   </td>
   </tr>      
  
    <tr>
        <td>&nbsp;<font color="red">*** 2ȸ���̻� ī��CMS��Ұ��� ���ι�ȣ�� �ֽ��ϴ�. ī��CMS��� ���� ������ �����  ��������� ī���� ���αݾװ� ��ġ�ϴ��� Ȯ���ϼ���!!!!</font> </td>
    </tr>   
    
   <tr>
        <td class=h></td>
    </tr>  
    
     <tr></tr><tr></tr><tr></tr>
    
        
          <!-- �ʰ�����δ�ݿ� ����  block none-->
     <tr id=tr_over style="display:<%if( co.getR_over_amt() > 0 ){%>''<%}else{%>none<%}%>"> 
             	
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ʰ�����뿩��[���ް�]</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	 	 	
 	 	   <tr> 
 	      <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="3"  width='34%'>�׸�</td>
              <td class="title" width='20%'>����</td>                
              <td class="title" width='46%'>���</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>   
              <td class="title"  rowspan=3>��೻��</td>
              <td class="title" >���Ⱓ</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%></td>
              <td align="left" >&nbsp;���ʰ��Ⱓ</td>
             </tr>
              <tr> 
              <td class="title" >�����Ÿ� (��)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;����</td>
             </tr>      
              <tr> 
              <td class="title" > �ܰ�(�δ��) (a)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>��</td>
               <td align="left" >&nbsp;=1km</td>
             </tr>           
            <tr> 
              <td class="title"  rowspan=3>�������</td>
              <td class="title" >�뿩�Ⱓ</td>
              <td align="center">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
              <td align="left" >&nbsp;�����뿩�Ⱓ</td>
             </tr>   
              <tr> 
              <td class="title" >�뿩�ϼ�(��)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(co.getRent_days() )%>' size='7' class='whitenum' > �� </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title" >�����Ÿ�(�ѵ�)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7'  value='<%=AddUtil.parseDecimal(co.getCal_dist() )%>' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(��)x(��) / 30</td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>      
               <td class="title"  rowspan=3>����Ÿ�</td>
              <td class="title" >��������Ÿ���(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value='<%=AddUtil.parseDecimal(co.getFirst_dist() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;����(�� �ε����� ����Ÿ�) , ������ (��༭�� ��õ� ����Ÿ�)</td>
             </tr>   
             <tr> 
              <td class="title" >��������Ÿ���(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly value='<%=AddUtil.parseDecimal(co.getLast_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title" >�ǿ���Ÿ�(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly   value='<%=AddUtil.parseDecimal(co.getReal_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
              <tr> 
              <td class="title"  rowspan=3>�������</td>
              <td class="title" >�ʰ�����Ÿ�(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly   value='<%=AddUtil.parseDecimal(co.getOver_dist() )%>'   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title" >���񽺸��ϸ���</td>
              <td align="right" ><input type='text' name='add_dist' readonly value='<%=AddUtil.parseDecimal(co.getAdd_dist() )%>'      size='7' class='whitenum' > km</td>
                <td align="left" >&nbsp;</td>
             </tr>      
              <tr> 
              <td class="title" >�������(g)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly value='<%=AddUtil.parseDecimal(co.getJung_dist() )%>'      size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>��<br>��</td>
              <td class="title" colspan=2 >����ݾ�(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getR_over_amt() )%>'     size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;=(a)x(b)</td>
             </tr>
              <tr> 
              <td class="title"   colspan=2 >����(i)</td>
              <td align="right"><input type='text' name='m_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getM_over_amt() )%>'      size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> ��</td>
              <td align="left" >&nbsp;�����ڹ׻���:
              	   <select name='m_saction_id'>
			                <option value="">--����--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(co.getM_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="m_reason" cols="55" class="text" style="IME-MODE: active" rows="2"><%=co.getM_reason()%></textarea> </td>
             </tr>      
              <tr> 
              <td class="title"   colspan=2 >����(����)�ݾ�</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getJ_over_amt() )%>'     size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;=(h)-(i)</td>
             </tr>  
                </table>
            </td>
         </tr>           
   
     	</table>
      </td>	 
    </tr>	  	 	    
             
    <tr>
        <td>&nbsp;</td>
    </tr>     
           
     
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭</span>&nbsp;&nbsp;<font color=red><%=print_nm%></font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    
     <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0>
               <tr> 
                  <td width="3%" rowspan="2" class='title'>����</td>
                  <td colspan="4" class='title'>����</td>
                  <td colspan="6" class='title'>����</td>                
                </tr>
                <tr> 
               	  <td width="10%" class='title'>�����׸�</td>          
   				  <td width="10%" class='title'>���ް�</td> 
   				  <td width="10%" class='title'>�ΰ���</td>       
   				  <td width="10%" class='title'>�հ�</td>                     
                  <td width="13%" class='title'>ǰ��</td>
                  <td width="10%" class='title'>���ް�</td>
                  <td width="10%" class='title'>�ΰ���</td>
                  <td width="10%" class='title'>�հ�</td>
                  <td width="13%" class='title'>���</td>
                  <td width="3%" class='title'>����</td>
                </tr>
                <tr> 
                  <td height="23" align="center">1</td>
                  <td align="center">�ܿ����ô뿩��</td>
                  <td align='center'><input type='text' name='tax_r_supply' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' name='tax_r_value' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' name='tax_r_hap' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRifee_s_amt_s()+ct.getRifee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getRifee_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rifee_s_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' name='tax_rr_value' readonly size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getR_rifee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' name='tax_rr_hap' readonly size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rifee_s_amt_s()+ct.getR_rifee_s_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk0' value='Y' <%if(ct.getTax_r_chk0().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                <tr> 
                  <td align="center">2</td>
                  <td align="center">�ܿ�������</td>
                 <td align='center'><input type='text'  readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_s())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly  name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getRfee_s_amt_s()+ct.getRfee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getRfee_etc()%>'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rfee_s_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_value' size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getR_rfee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_rfee_s_amt_s()+ct.getR_rfee_s_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"> <input type='checkbox' name='tax_r_chk1' value='Y' <%if(ct.getTax_r_chk1().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                
                <tr> 
                  <td align="center">3</td>
                  <td align="center">��Ҵ뿩��</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_c_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_c_amt_s()+ct.getDfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getDfee_c_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_c_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_c_amt_s()+ct.getR_dfee_c_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk2' value='Y' <%if(ct.getTax_r_chk2().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                
                 <tr> 
                  <td align="center">4</td>
                  <td align="center">�̳��뿩��</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDfee_amt_s()+ct.getDfee_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getDfee_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_amt_s())%>'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(1);'> ��</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dfee_amt_s()+ct.getR_dfee_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk3' value='Y' <%if(ct.getTax_r_chk3().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                                            
                <tr> 
                  <td align="center">5</td>
                  <td align="center">���������</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDft_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getDft_amt_s()+ct.getDft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getDft_etc()%>' ></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dft_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(2);'> ��</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_dft_amt_s()+ct.getR_dft_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk4' value='Y' <%if(ct.getTax_r_chk4().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                <tr> 
                  <td align="center">6</td>
                  <td align="center">ȸ�����ֺ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc_amt_s()+ct.getEtc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text'  value='<%=ct.getEtc_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(3);'> ��</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc_amt_s()+ct.getR_etc_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td> 
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk5' value='Y' <%if(ct.getTax_r_chk5().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr> 
                <tr> 
                  <td align="center">7</td>
                  <td align="center">ȸ���δ���</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc2_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc2_amt_s()+ct.getEtc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text'  value='<%=ct.getEtc2_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc2_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(4);'> ��</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc2_amt_s()+ct.getR_etc2_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td> 
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk6' value='Y' <%if(ct.getTax_r_chk6().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr> 
                <tr> 
                  <td align="center">8</td>
                  <td align="center">���ع���</td>
                  <td align='center'><input type='text' readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc4_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getEtc4_amt_s()+ct.getEtc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text'  value='<%=ct.getEtc4_etc()%>'></td>
                  <td align='center'><input type='text' name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc4_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(5);'> ��</td>
                  <td align='center'><input type='text' name='tax_rr_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_hap();'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_etc4_amt_s()+ct.getR_etc4_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"><input type='checkbox' name='tax_r_chk7' value='Y' <%if(ct.getTax_r_chk7().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                 <tr> 
                  <td align="center">9</td>
                  <td align="center">�ʰ�����뿩��</td>
                 <td align='center'><input type='text'  readonly name='tax_r_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getOver_amt_s())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly  name='tax_r_value' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getOver_amt_v())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getOver_amt_s()+ct.getOver_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align="center"><input type='text' readonly name='tax_r_g' size='20' class='text' value='<%=ct.getOver_etc()%>'></td>
                  <td align='center'><input type='text' readonly name='tax_rr_supply' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_over_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_tax_value(6);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_value' size='12' class='num'  value='<%=AddUtil.parseDecimal(ct.getR_over_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_rr_hap' size='12' class='num' value='<%=AddUtil.parseDecimal(ct.getR_over_amt_s()+ct.getR_over_amt_v())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td align='center'><input type='text' readonly name='tax_r_bigo' size='22' class='text' value=''></td>
                  <td align="center"> <input type='checkbox' name='tax_r_chk8' value='Y' <%if(ct.getTax_r_chk8().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"  ></td>
                </tr>
                 
                <tr> 
                  <td class="title_p" align="center" colspan=2>&nbsp;��</td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); '> ��</td>
                  <td class="title_p" align='center'><input type='text' readonly name='p_tax_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td class="title_p" align="center">&nbsp;</td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_supply' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); ;'> ��</td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_value' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); '> ��</td>
                  <td class="title_p" align='center'><input type='text' readonly name='r_tax_hap' size='12' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                  <td class="title_p" align='center' colspan=2>&nbsp;</td>                    
                  
                </tr> 
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>  
  
  	   
	<tr id=tr_get style="display:''">	  
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä���� �ڱ�å&nbsp;
		       	 <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)  || nm_db.getWorkAuthUser("����������",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id ) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id)   ){%>     
			  	  <a href="javascript:update('tr_get')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
			  	 <% } %></span></td>
		    </tr>
		    <tr>
		        <td class=line2></td>
		    </tr>
		    <tr>
		        <td class=line>
		            <table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
		                    <td class=title width=12%>����</td>
		                    <td colspan=7>&nbsp; 
								  <select name="div_st" onChange='javascript:cls_display3()'>
								    <option value="">---����---</option>
								    <option value="1" <%if(cls.getDiv_st().equals("�Ͻó�"))%>selected<%%>>�Ͻó�</option>
            					    <option value="2" <%if(cls.getDiv_st().equals("�г�"))%>selected<%%>>�г�</option>
					             
					              </select>             
					              <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                        <tr> 
					                         
					                           <td id='td_div' style="display:<%if( cls.getDiv_st().equals("�г�")){%>''<%}else{%>none<%}%>">&nbsp;�г�Ƚ��&nbsp;  
					                             <select name="div_cnt">
												    <option value="">---����---</option>
												    <option value="1" <%if(cls.getDiv_cnt() == 1)%>selected<%%>>1</option>
            					   					<option value="2" <%if(cls.getDiv_cnt() == 2)%>selected<%%>>2</option>
            					   				    <option value="3" <%if(cls.getDiv_cnt() == 3)%>selected<%%>>3</option>
            					   					<option value="4" <%if(cls.getDiv_cnt() == 4)%>selected<%%>>4</option>
            					   				    <option value="5" <%if(cls.getDiv_cnt() == 5)%>selected<%%>>5</option>
            					   					<option value="6" <%if(cls.getDiv_cnt() == 6)%>selected<%%>>6</option>
            					   				    <option value="7" <%if(cls.getDiv_cnt() == 7)%>selected<%%>>7</option>
            					   					<option value="8" <%if(cls.getDiv_cnt() == 8)%>selected<%%>>8</option>
            					   				    <option value="9" <%if(cls.getDiv_cnt() == 9)%>selected<%%>>9</option>
            					   				    <option value="10" <%if(cls.getDiv_cnt() == 10)%>selected<%%>>10</option>
            					   				    <option value="11" <%if(cls.getDiv_cnt() == 11)%>selected<%%>>11</option>
            					   				    <option value="12" <%if(cls.getDiv_cnt() == 12)%>selected<%%>>12</option>       
            					   					
									              </select>
					                            </td>
					                        </tr>
					                </table>
					         	</td>
					    	</tr>
					  
		                	<tr>
			                    <td class=title width=13%>����</td>
			                    <td class=title width=12%>������</td>
			                    <td>&nbsp;<input type='text' name='est_dt' value='<%=cls.getEst_dt()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
			                    <td class=title width=12%>�����ݾ�</td>
			                    <td>&nbsp;<input type='text' name='est_amt' value='<%=AddUtil.parseDecimal(cls.getEst_amt())%>'size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
			                    <td class=title width=12%>������</td>
			                    <td>&nbsp;<input type='text' name='est_nm' value='<%=cls.getEst_nm()%>' size='15' class='text'></td>
		                	</tr>
		             	                
		            	</td>
		        	</tr>
		    	</table>
		  		</td>
		    </tr>
			<tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>
					                      <td class=title width=13%>����������</td>
									      <td width=12%>&nbsp;<input type='text' value='<%=cls.getGur_nm()%>' name='gur_nm' size='15' class='text'></td>
						                  <td width=12% class=title>����ó</td>
						                  <td>&nbsp;<input type='text' name='gur_rel_tel' value='<%=cls.getGur_rel_tel()%>'  size='30' class='text'></td>
						                  <td width=12% class=title>����ڿ��ǰ���</td>  
						                  <td colspan=3>&nbsp;<input type='text' name='gur_rel' value='<%=cls.getGur_rel()%>'  size='30' class='text'></td>   
		           			             
		               			    </tr>
		               			 </table>
		               		</td>
		                </tr>
		             </table>
		          </td>
		    </tr>
		   	<tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>              
					                    <td class=title style='height:44' width=13%>ó���ǰ�/���û���/����</td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="remark" cols="140" class="text" style="IME-MODE: active" rows="3"><%=cls.getRemark()%></textarea> 
					                    </td>
					                </tr>
		                
		           				</table>
		           			</td>
		           		</tr>
		           	</table>			
		        </td>
		    </tr>
		     <tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>              
					                    <td class=title style='height:34' width=13%>����÷��</td>
					                    <td colspan=7>&nbsp; 
					                    
                 <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"3";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>
    						<a href="javascript:scan_reg('3')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>								                    
    						<%}%>
					                    </td>                    	
					                </tr>
		                
		           				</table>
		           			</td>
		           		</tr>
		           	</table>			
		        </td>
		    </tr>
		   	<tr>
     		 <td>&nbsp;</td>
     	    </tr>
       	</table>
      </td>	 
    </tr>	
    
      <!-- ȯ�ұݾ��� �ִ� ��쿡 ���� (���Կɼ� �ƴ� ���)-->
    <tr id=tr_refund style="display:<%if( cls.getFdft_amt2() < 0 && !cls.getCls_st().equals("���Կɼ�") ){%>''<%}else{%>none<%}%>"> 
  
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ȯ������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
 	 	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                    <tr> 
                        <td class="title" width=13% >�����ָ�</td>
                        <td >&nbsp; <input type="text" name="re_acc_nm" value='<%=cls.getRe_acc_nm()%>' size="30" class=text></td>
                        <td width=13% class="title">�����</td>
                        <td >&nbsp; <select name="re_bank" style="width:135">
                            <option value="">==����==</option>                         
			     	 <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					    	<option value='<%=h_c_bnk.get("BCODE")%>'  <%if(cls.getRe_bank().equals((String)h_c_bnk.get("BCODE"))){%>selected<%}%>><%= h_c_bnk.get("BNAME")%></option> > 	
                     
				              <%		}
							}%>
				              </select></td>
                        <td width=13% class="title">���¹�ȣ</td>
                        <td >&nbsp; <input type="text" name="re_acc_no" value='<%=cls.getRe_acc_no()%>' size="30" class=text></td>
                    </tr>
                    
                      <tr>
                        <td width="13%" class="title">����纻</td>
                        <td colspan=2>&nbsp;
                        
                 <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"1";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>
    						<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>			
    						<%}%>
    						                        
                        </td>
                    	<td colspan=3>&nbsp;<font color=red>�� ��ȯ�ҽ� �����ָ�,�����,���¹�ȣ �Է� �ʼ�.!!!</font><br>&nbsp;&nbsp;�ڵ���ü�������� ȯ���ϴ°�� �纻 ÷�� ���ص� ��.!!!</td>
                    </tr>                               
                </table>
            </td>
         </tr>             
                            
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	
    
     <!-- ȯ�ұݾ��� �ִ� ��쿡 ���� -->
        
   	<tr id=tr_scd_ext style="display:<%if( cls.getFdft_amt2() < 0 && !cls.getCls_st().equals("���Կɼ�") ){%>''<%}else{%>none<%}%>"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ���������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
 	 	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                 <tr>
                    <td width='5%' class='title' >����</td>					
		            <td width='14%' class='title'>����ȣ</td>
        		    <td width='10%' class='title'>������</td>
		            <td width="28%" class='title'>��</td>
		            <td width='10%' class='title'>������ȣ</td>		
				    <td width='15%' class='title'>����</td>	
				    <td width='9%' class='title'>�ݾ�</td>		
				    <td width='9%' class='title'>�������</td>		                	
				</tr>	
                </table>
            </td>
         </tr>             
 <%
	if(vt_size > 0)
	{	
%>     
		 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht_ext = (Hashtable) vt_ext.elementAt(i);	%>                
                 <tr>
                    <td width='5%' align='center'><%=i+1%></td>					
		            <td width='14%' align='center'><%=ht_ext.get("RENT_L_CD")%></td>
        		    <td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht_ext.get("CLS_DT")))%></td>
		            <td width="28%" align='center'><%=ht_ext.get("FIRM_NM")%></td>
		            <td width='10%' align='center' ><%=ht_ext.get("CAR_NO")%></td>		
				    <td width='15%' align='center'><%=ht_ext.get("CAR_NM")%></td>	
				    <td width='9%' align='right'><%=Util.parseDecimal(String.valueOf(ht_ext.get("CLS_AMT")))%></td>		
				    <td width='9%' align='center'><%=c_db.getNameById(String.valueOf(ht_ext.get("BUS_ID2")),"USER")%></td>		                	
				</tr>	
		<%		}    %>  		
                </table>
            </td>
         </tr>             
     
<%	}  %>	
                      
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	        

 <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>   	       	 	    
    <%if(!mode.equals("view")){%> 	 	
    <tr>
	    <td align='center'>	

	<%  if ( nm_db.getWorkAuthUser("������",user_id)   || nm_db.getWorkAuthUser("����Ʈ����",user_id) || nm_db.getWorkAuthUser("��������ȸ�������",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)  || nm_db.getWorkAuthUser("����������",user_id)  || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id)   ){%>     
 	<%     if ( !doc.getUser_dt5().equals("")){%>  
 			 <a href="javascript:save();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
 			 
	<%       if(!base.getUse_yn().equals("N")) { %>		
	         <a href="javascript:clsContReg();"><img src=/acar/images/center/button_hj_hj.gif align=absmiddle border=0></a>&nbsp;	          
	         <%}%> 
	         <% if( !cls.getCls_st().equals("���Կɼ�") && !cls.getAutodoc_yn().equals("Y") ){%>    
	           	  <a href="javascript:clsContAutoDocReg();"><img src=/acar/images/center/button_hj_hg.gif align=absmiddle border=0></a>&nbsp;
	         <% } %>	       	 	       	
	   	      	 
	   <% }  %>
	<% } %>
	   <% if( cls.getAutodoc_yn().equals("Y") && !cls.getCls_st().equals("���Կɼ�") ){%> 
	      <!--  <a href="javascript:save3();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp; -->
	        <a href="javascript:clsContAutoDocReReg();"><img src=/acar/images/center/button_jdjp_jbh.gif align=absmiddle border=0></a>&nbsp;	
	        <a href="javascript:clsContAutoDocReReg1();"><img src=/acar/images/center/button_jdjp_gss.gif align=absmiddle border=0></a>&nbsp;	
	  
	       
	       <% } %>     
	       
	    </td>
	</tr>			  
	<%}%>    
	<tr>
<% } %>	
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="3">����</td>
                    <td class=title colspan=3>�߽�</td>
                    <td class=title colspan=3>����</td>
                   
        	    </tr>	
        	     <tr>                    
                    <td class=title width=15%>������</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%=doc.getUser_nm3()%></td>
                    <td class=title width=15%><%=doc.getUser_nm4()%></td>
                    <td class=title width=15%><%=doc.getUser_nm5()%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></td>
                   
        		<td align="center">
        		</td>        	      			
                    <td align="center"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
        			  <%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){
        				  	String user_id3 = doc.getUser_id3();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
        					if(!cs_bean.getWork_id().equals(""))									user_id3 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id3 = "000131";//Ȳȿ��(000116) -> 000058
        					%>
        			  <%	if(doc.getUser_id3().equals(user_id) || user_id3.equals(user_id) || nm_db.getWorkAuthUser("������",user_id)  ){%>
        			    <a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td> 
        			<td align="center">
        			</td>      		
        			<td align="center">
        			</td>	
        	    </tr>	
    		</table>
	    </td>
	</tr>  	  
  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
	
	set_tax_init();
				
	function set_init(){
		var fm = document.form1;		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));	
		fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));			
			
	}
	
	//���ݰ�꼭
	function set_tax_init(){
		var fm = document.form1;
	      	
		
		//��Ҵ뿩��  
		//���ݰ�꼭�� ����� ���
		if (toInt(fm.re_day.value) > 0 ) {		  
			  //�̳��� �ִ� ���
				if(toInt(parseDigit(fm.nfee_amt_1.value)) > 0){ 
					fm.tax_r_bigo[2].value    = fm.car_no.value+" ����";
					fm.tax_r_bigo[3].value    = fm.car_no.value+" ����";	
				} else {
				
					fm.tax_r_bigo[2].value    = fm.car_no.value+" ����";
				}				
		}
			
			//�����ΰ�� �������� ���̳ʽ�  ---  
		if(toInt(parseDigit(fm.ex_di_amt_1.value)) < 0 ){
		 if (toInt(fm.nfee_amt_1.value) < 1 ) {   //�̳��� ���� ���
		 	fm.tax_r_bigo[2].value    = fm.car_no.value+" ����";
		 }
		} 
		
		//�̳��뿩��  
		if(toInt(parseDigit(fm.nfee_amt_1.value)) > 0){
		     //���ݰ�꼭�� ����� �� ���
		    if (toInt(fm.re_day.value) < 0 ) {
				fm.tax_r_bigo[3].value    = fm.car_no.value+" ����";	
			}		
		}
		
		//�����ΰ�� �������� ���̳ʽ�  --- �̶� ó���� ???
					
		//�ߵ����������
		if(fm.tax_chk0.checked == true ){
				fm.tax_r_bigo[4].value    = fm.car_no.value+" ����";		
		}
		
		//ȸ�����ֺ��
		if(fm.tax_chk1.checked == true ){
				fm.tax_r_bigo[5].value    = fm.car_no.value+" ����";
		}
		
			//ȸ���δ���
		if(fm.tax_chk2.checked== true ){
				fm.tax_r_bigo[6].value    = fm.car_no.value+" ����";
		}
			//��Ÿ���ع���(��å��)
		if(fm.tax_chk3.checked == true ){		
				fm.tax_r_bigo[7].value    = fm.car_no.value+" ����";		
		}
		
		//�ʰ�����δ��
		if(fm.tax_chk4.checked == true ){		
//		if(toInt(parseDigit(fm.over_amt_1.value)) > 0){
				fm.tax_r_bigo[8].value    = fm.car_no.value+" ����";		
		}		
		
		fm.p_tax_supply.value = 0;
		fm.p_tax_value.value = 0;
		fm.p_tax_hap.value = 0;
		fm.r_tax_supply.value = 0;
		fm.r_tax_value.value = 0;	
		fm.r_tax_hap.value = 0;	
				
		for(var i=0 ; i<9 ; i++){
		  fm.p_tax_supply.value    	= parseDecimal( toInt(parseDigit(fm.p_tax_supply.value)) + toInt(parseDigit(fm.tax_r_supply[i].value)) );
		  fm.p_tax_value.value     	= parseDecimal( toInt(parseDigit(fm.p_tax_value.value)) + toInt(parseDigit(fm.tax_r_value[i].value)) );
		  fm.r_tax_supply.value    	= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.tax_rr_supply[i].value)) );
		  fm.r_tax_value.value     	= parseDecimal( toInt(parseDigit(fm.r_tax_value.value)) + toInt(parseDigit(fm.tax_rr_value[i].value)) );
		}
		fm.p_tax_hap.value    		= parseDecimal( toInt(parseDigit(fm.p_tax_supply.value)) + toInt(parseDigit(fm.p_tax_value.value)) );
		fm.r_tax_hap.value    		= parseDecimal( toInt(parseDigit(fm.r_tax_supply.value)) + toInt(parseDigit(fm.r_tax_value.value)) );
		
	}	
				
//-->
</script>
</body>
</html>
