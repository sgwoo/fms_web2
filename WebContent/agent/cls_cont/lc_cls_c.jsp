<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.credit.*, acar.car_mst.*, acar.car_register.*, acar.car_office.*"%>
<%@ page import="acar.user_mng.*, acar.con_tax.*, acar.fee.*"%>

<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%@ include file="/agent/cookies.jsp" %>

<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
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
	
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//����� ����Ʈ
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();	
	
	//�⺻����
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, "", "");
	
	    	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//���뺸���� 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
	
	int pp_amt = AddUtil.parseInt((String)base1.get("PP_S_AMT"));
	
		//��å�� ��û���� ���� ����ó�� ���� ����
	int car_ja_no_amt =  ac_db.getCarServiceBillNo(rent_mng_id, rent_l_cd);
		
	Vector cms_bnk = c_db.getCmsBank();	//������� �����´�.
	int cms_bnk_size1 = cms_bnk.size();
	
	//cms ����
	Hashtable h_cms = c_db.getCmsBank_info(rent_l_cd);
	
	String re_bank = "";
	String re_acc_no = "";
	String re_acc_nm = "";
		
	re_bank = (String)h_cms.get("CBNK");
	re_acc_no = (String) h_cms.get("CBNO");
	re_acc_nm = (String) h_cms.get("CYJ");
	
	//������ ��ϵǾ����� ����
	int reg_cnt = 0;
	reg_cnt= ac_db.getClsEtcCnt(rent_mng_id, rent_l_cd);
		
	//�������� ����Ʈ
	Vector vt_ext = as_db.getClsList(base.getClient_id());
	int vt_size = vt_ext.size();
	
	 CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;
	
	//������ ������ ��û ���� Ȯ��
	CarOffPreDatabase cop_db 	= CarOffPreDatabase.getInstance();
	EcarChargerBean ec_bean	= cop_db.getEcarChargerOne(rent_l_cd, rent_mng_id);
	    
	//�ܿ��뿩�Ⱓ ���ϱ� (function ���ó�� ) 	
	String r_ymd[] = new String[3]; 
	String rcon_mon = "";
	String rcon_day  = "";
		
	String rr_ymd =  String.valueOf(base1.get("R_YMD"));
	
   StringTokenizer token1 = new StringTokenizer(rr_ymd,"^");				
	while(token1.hasMoreTokens()) {			
			r_ymd[0] = token1.nextToken().trim();	//��
			r_ymd[1] = token1.nextToken().trim();	//�� 
			r_ymd[2] = token1.nextToken().trim();	//�� 
	}	
		
	//�������� ���Ⱓ ������ ���	 
	if  (AddUtil.parseInt(r_ymd[0]) < 0 ||  AddUtil.parseInt(r_ymd[1]) < 0 || AddUtil.parseInt(r_ymd[2]) < 0 ) {		
	   rcon_mon =  "";
 	   rcon_day =  "";
	} else {
	   rcon_mon =  Integer.toString( AddUtil.parseInt(r_ymd[0])*12  + AddUtil.parseInt(r_ymd[1]));
	   rcon_day =   Integer.toString(  AddUtil.parseInt(r_ymd[2])) ;  	
   }     			
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	
	
	//��ĵ���� ����
	function view_scan(m_id, l_cd){
		window.open("/agent/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
		
	//������ ��ȸ
	function car_search()
	{
		var fm = document.form1;
		window.open("search_ext_car.jsp", "EXT_CAR", "left=100, top=100, width=600, height=500, resizable=yes, scrollbars=yes, status=yes");
	}	

	//�� ����
	function view_client(client_id)
	{
		window.open("/agent/client/client_c.jsp?user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site(client_id, site_id)
	{
		window.open("/agent/client/client_site_i_p.jsp?user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/agent/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//�뿩���
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/agent/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
		//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/agent/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}
	
	function save(){
		var fm = document.form1;
			
		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
	
		if( toInt(parseDigit(fm.reg_cnt.value)) > 0 ) { 	 alert('�̹� ��ϵ� ���Դϴ�. Ȯ���Ͻʽÿ�!!'); 	fm.cls_st.focus(); 		return;	}	
	
		if ( fm.cls_st.value == '7' || fm.cls_st.value == '10' ) { //���������(����) , ����������(�縮��)
			if ( fm.car_gu.value == '0') {
			    if(fm.cls_st.value == '7')				{ alert('�縮�� �������������Դϴ�. Ȯ���ϼ���!!'); 		fm.cls_st.focus(); 		return;	}
		    }
			if ( fm.car_gu.value == '1') {
			    if(fm.cls_st.value == '10')				{ alert('���� ������������Դϴ�. Ȯ���ϼ���!!'); 		fm.cls_st.focus(); 		return;	}
		    }
		}
				
		if ( fm.cls_st.value == '1' || fm.cls_st.value == '2' ) {			
			//����ȸ�� ���� �� ȸ������, �԰����� �� check
			if(fm.reco_st[0].checked == true){  //ȸ�� ���ý� - ȸ������ �� ȸ����, �԰��� check
				  if(fm.reco_d1_st.value == "") {
				 		alert("ȸ�������� �����ϼž� �մϴ�.!!");
						return;
				  }	
				  
				 if(fm.reco_dt.value == '')				{ alert('ȸ�����ڸ� �Է��Ͻʽÿ�'); 		fm.reco_dt.focus(); 	return;	}
				 if(fm.ip_dt.value == '')				{ alert('�԰����ڸ� �Է��Ͻʽÿ�'); 		fm.ip_dt.focus(); 		return;	}
					
				 if( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ){
					if(fm.est_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.est_dt.focus(); 		return;	}		
				 }
					
				 if( toInt(parseDigit(fm.tot_dist.value)) < 1 ) { 	 alert('����Ÿ��� �Է��Ͻʽÿ�'); 		fm.tot_dist.focus(); 		return;	}		
		
			} else {
			  if(fm.reco_d2_st.value == "") {
			 		alert("��ȸ�������� �����ϼž� �մϴ�.!!");
					return;
			  }		
			}	
				
			if(fm.serv_st[0].checked == false && fm.serv_st[1].checked == false ){
				alert("������ ��밡���� �����ϼž� �մϴ�.!!");
				return;
			}
		
		}
		
		
		if( toInt(parseDigit(fm.ex_ip_amt.value)) > 0 ){
			//���¹�ȣ		
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;
			var deposit_split = deposit_no.split(":");
			fm.deposit_no2.value = deposit_split[0];			
		
			if(fm.bank_code.value == ""){ alert("������ �����Ͻʽÿ�."); return; }			
			if(fm.deposit_no.value == ""){ alert("���¹�ȣ�� �����Ͻʽÿ�."); return; }		
		}	
		
		//��������
		if( replaceString(' ', '',fm.cls_cau.value) == '' ){
				alert("���������� �Է��ϼž� �մϴ�.!!");
				return;
		}	
		
		if( get_length(Space_All(fm.cls_cau.value)) == 0 ) {
		 		alert("���������� �Է��ϼž� �մϴ�.!!");
				return;
		}	
		
			//��ü�� �� �ߵ����� ������� ���̰� �߻��� ��� ���� �Է� check
		if (  fm.dly_amt.value != fm.dly_amt_1.value ) {
		    if( get_length(Space_All(fm.dly_reason.value)) == 0  ) {
				alert("��ü�� ���׻����� �Է��ϼž� �մϴ�.!!");
				return;
			}	
			
			if( fm.dly_saction_id.value == '' ) {
				alert("��ü�ᰨ�� �����ڸ� �����ϼž� �մϴ�.!!");
				return;
			}	
			
			if( fm.dly_saction_id.value != '000004' ) {
				alert("��ü�ᰨ�� �����ڸ� �Ⱥ��� �������� �����ϼž� �մϴ�. ������ �����Ͻʽÿ�.!!");
				return;
			}				
		}
		
		if (  fm.dft_amt.value != fm.dft_amt_1.value ) {
		    if( get_length(Space_All(fm.dft_reason.value)) == 0 ) {
				alert("�ߵ���������� ���׻����� �Է��ϼž� �մϴ�.!!");
				return;
			}	
			
			if( fm.dft_cost_id.value == '' ) {
				alert("����ȿ�� �ͼӴ���ڸ� �����ϼž� �մϴ�.!!");
				return;
			}	
			
			if( fm.dft_saction_id.value == '000028'  ||  fm.dft_saction_id.value == '000005'   ) {
			
			} else { 
				alert("�ߵ���������� �����ڸ�  �����ϼž� �մϴ�. ������ �����Ͻʽÿ�.!!");
				return;
			}	
				
		}
				
		//����ä��ó��!!! �������� - �����Աݾ� 
		if ( toInt(parseDigit(fm.gi_amt.value)) -  toInt(parseDigit(fm.fdft_amt2.value))  < 0 ){
					
			 if( replaceString(' ', '',fm.remark.value) == '' && replaceString(' ', '', fm.crd_remark1.value)  == '' && replaceString(' ', '', fm.crd_remark2.value) == '' && replaceString(' ', '', fm.crd_remark3.value) == '' && replaceString(' ', '', fm.crd_remark4.value) == '' && replaceString(' ', '',fm.crd_remark5.value) == '' && replaceString(' ', '', fm.crd_remark6.value) == '' ){
				alert("����ä�� ó���ǰ� �Ǵ� ä���� �ڱ�å�� �Է��ϼž� �մϴ�.!!");
				return;
			 }	
			 
			  if( get_length(Space_All(fm.remark.value)) == 0 && get_length(Space_All(fm.crd_remark1.value))  == 0 && get_length(Space_All(fm.crd_remark2.value))  == 0 && get_length(Space_All(fm.crd_remark3.value))  == 0 && get_length(Space_All(fm.crd_remark4.value))  == 0 && get_length(Space_All(fm.crd_remark5.value))  == 0 && get_length(Space_All(fm.crd_remark6.value))  == 0 ){
				alert("����ä�� ó���ǰ� �Ǵ� ä���� �ڱ�å�� �Է��ϼž� �մϴ�.!!");
				return;
			 } 	 
		}
			
		//��꼭�����Ƿ�
		if ( toInt(parseDigit(fm.dft_amt_1.value))  < 1 ) {
			if ( fm.tax_chk0.checked == true) {
				alert("�ߵ����� ������� Ȯ���ϼ���. ��꼭�����Ƿڸ� �� �� �����ϴ�..!!");
				return;
			 }	
		}
				
		if ( toInt(parseDigit(fm.etc_amt_1.value))  < 1 ) {
			if ( fm.tax_chk1.checked == true) {
				alert("����ȸ�����ֺ���� Ȯ���ϼ���. ��꼭�����Ƿڸ� �� �� �����ϴ�..!!");
				return;
			 }	
		}	
	
		if ( toInt(parseDigit(fm.etc2_amt_1.value))  < 1 ) {
			if ( fm.tax_chk2.checked == true) {
				alert("����ȸ���δ����� Ȯ���ϼ���. ��꼭�����Ƿڸ� �� �� �����ϴ�..!!");
				return;
			 }	
		}				
	 
		if ( toInt(parseDigit(fm.etc4_amt_1.value))  < 1 ) {
			if ( fm.tax_chk3.checked == true) {
				alert("��Ÿ���ع����� Ȯ���ϼ���. ��꼭�����Ƿڸ� �� �� �����ϴ�..!!");
				return;
			 }	
		}	
		
		// ���չ���	
		if ( fm.tax_reg_gu[1].checked == true ) {
		
			if ( toInt(parseDigit(fm.rifee_s_amt.value))  > 0 ) {
				alert("���ô뿩���ܾ��� �ֽ��ϴ�. �׸��ջ�û���Ƿڸ� �� �� �����ϴ�..!!");
				return;
		 	}
		 	
		 	if ( toInt(parseDigit(fm.rfee_s_amt.value))  > 0 ) {
				alert("�������ܾ��� �ֽ��ϴ�. �׸��ջ�û���Ƿڸ� �� �� �����ϴ�..!!");
				return;
		 	}		
		}
		
		// ȯ�ұݾ� �߻��� �����ȣ check
		if ( toInt(parseDigit(fm.fdft_amt2.value))  < 0 ) {
		  
		    if ( fm.re_acc_no  == 'null') { 
				alert("ȯ�Ұ��¹�ȣ�� ��Ȯ�ϰ� �Է��ϼ���..!!");
				return;
		    }	
		    
		    if ( fm.re_acc_nm  == 'null') { 
				alert("ȯ�� �����ָ��� �Է��ϼ���..!!");
				return;
		    }					
		}		 						
		//������ ������ ��û���� üũ(20190611)	
		confirmECarCharger();	
	
		if(confirm('����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_c_a.jsp';	
//			fm.target='ii_no';
			fm.target='d_content';
			fm.submit();
		}		

	}
	
	//���÷��� Ÿ��
	function cls_display(){
		var fm = document.form1;
		
		tr_ret.style.display		= '';	//����ȸ��	
		tr_gur.style.display		= '';	//ä�ǰ���
		tr_cre.style.display		= '';	//����ä��ó��
		tr_sale.style.display		= 'none';	//�����Ű�
		tr_refund.style.display		= 'none';	//ȯ������
		tr_scd_ext.style.display	= 'none';	//ȯ������
		tr_dae.style.display		= 'none';	//���������	
			
		if ( fm.cls_st.value == '7' || fm.cls_st.value == '10' ) { //���������(����) , ����������(�縮��)
			tr_ret.style.display		= 'none';	//����ȸ��	
			tr_gur.style.display		= 'none';	//ä�ǰ���
			tr_cre.style.display		= 'none';	//����ä��ó��	
			
			if (fm.cls_st.value == '7' ) {
				tr_dae.style.display		= '';	//���������			
			
			}
			
			fm.cancel_yn.value = 'Y';
			if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'N'){
				td_cancel_n.style.display 		= 'none';  //��������
				td_cancel_y.style.display 		= '';  //�������
			} else {
				td_cancel_n.style.display 		= '';  //��������
				td_cancel_y.style.display 		= 'none';  //�������
			}	
			
		}			
												
		set_init();
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
	   	fm.fdft_amt3.value='0';  //�����Ű�
	 
		set_day();
	
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
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
		
			fm.cancel_yn.value = 'Y';
			alert('�ߵ���������ݾ��� '+fm.fdft_amt2.value+'������ ȯ���ؾ� �մϴ�. \n\n�̿� ���� ��쿡�� ������Ҹ� �����մϴ�.');
			return;			
		}
		
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'N'){
			td_cancel_n.style.display 		= 'none';  //��������
			td_cancel_y.style.display 		= '';  //�������
		} else {
			td_cancel_n.style.display 		= '';  //��������
			td_cancel_y.style.display 		= 'none';  //�������
		}	
	}	
	
	//����� �������ڷ� �ٽ� ���
	function set_day(){
		var fm = document.form1;	
		
		if(fm.cls_dt.value == ''){ 	alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_dt.focus(); 	return;	}
	
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}	
		
		fm.action='./lc_cls_c_nodisplay.jsp';						
				
		fm.target='i_no';
		fm.submit();
	}	
		
	//�����ݾ� ���� : �ڵ����
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		
		if(obj == fm.r_day){ //�̿�Ⱓ �� 	
			set_init();
		}
		
		if(obj == fm.ifee_mon || obj == fm.ifee_day){ //���ô뿩�� ����Ⱓ
			if(fm.ifee_s_amt.value != '0'){		
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );		
		
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //�ܾ�
							
			}
			
		}else if(obj == fm.ifee_ex_amt){ //���ô뿩�� ����ݾ�
			if(fm.ifee_s_amt.value != '0'){		
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );				
			}
		}else if(obj == fm.pded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		
		if(fm.pp_s_amt.value != '0') {
	 	 
	    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //������
	    		
	    		fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;
	    	}   
	    }		
			
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // �����ݾ��� ����� ���
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
				
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		
		 //���ô뿩�ᰡ �� ����� ��� �ܿ����ô뿩��� �̳��뿩�ῡ�� ó��
	    if(fm.ifee_s_amt.value != '0') {
	    	 
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
	    		
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
	    	}   
	    }			
	
		set_cls_s_amt();
	}	
	
	//�̳� �뿩�� ���� : �ڵ����
	function set_cls_amt2(obj){
		var fm = document.form1;
		
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
		var v_ifee_ex_amt = 0;  //���ô뿩�� ����ݾ�
		var  re_nfee_amt = 0;  //�������� �����쿡�� �ϼ� ����� �ݾ��� �ƴ� ��� check
									
		obj.value=parseDecimal(obj.value);
						
		//������ �� ���Աݰ��� vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		}
		 
		if ( fm.ex_di_amt_1.value == fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = fm.ex_di_v_amt.value ;
		}
		
		var no_v_amt = 0;
		var no_v_amt1 = 0;
		
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value = toInt(parseDigit(fm.rifee_s_amt.value)) *0.1;  //���ô뿩�� 
	    fm.rfee_v_amt.value =  toInt(parseDigit(fm.rfee_s_amt.value)) *0.1;    //������ 
	    
	    fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  ;  //���� �뿩�� �ΰ��� 	    
	    fm.dfee_v_amt_1.value = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1); //Ȯ�� �뿩�� �ΰ��� 
			
	    fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		
		
		/*
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
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
		*/
		
	//	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
	
		set_cls_s_amt();
	}	
	
			
	//�̳� �ߵ���������� ���� : �ڵ����
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //�ܿ��뿩���Ⱓ
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
			//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}
		}else if(obj == fm.dft_int_1){ //����� �������
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int_1.value)/100) );
			//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
			//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}			
		}
		
		set_cls_s_amt();
	}		
	
				
	//Ȯ���ݾ� ����
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
										
		var no_v_amt = 0;
		var no_v_amt1 = 0;

		//���� �ΰ��� ����Ͽ� ���Ѵ�.	
		no_v_amt =toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		fm.rifee_v_amt.value = toInt(parseDigit(fm.rifee_s_amt.value)) *0.1;  //���ô뿩�� 
	    fm.rfee_v_amt.value =  toInt(parseDigit(fm.rfee_s_amt.value)) *0.1;    //������ 
	    		    
		fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + (toInt(parseDigit(fm.nfee_amt.value)) * 0.1);  //���� �뿩�� �ΰ��� 
		fm.dfee_v_amt_1.value =toInt(parseDigit(fm.ex_di_v_amt_1.value)) + (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1);  //Ȯ�� �뿩�� �ΰ��� 
									
		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		
		
		set_cls_s_amt();
		
	}	
		
	//Ȯ���ݾ� ����
	function set_cls_s_amt(){
		var fm = document.form1;	
		
		fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
			
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)));	 //Ȯ���ݾ�	
				
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );
		
			//������ �ݾ��� �ִٸ�
		if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
			 tr_refund.style.display		= '';	//ȯ������
			 tr_scd_ext.style.display		= '';	//���� ���������
		} else {
			 tr_refund.style.display		= 'none';	//ȯ������
			 tr_scd_ext.style.display		= 'none';	//���� ���������
		}	
		
			//cms�̸鼭 �̳��ݾ��� �ִ� ��� 	
		if ( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ) {		   
		   if ( fm.cms_yn.value == '' || fm.cms_yn.value == 'null' ) {		   		  	
		   } else {	
		   	     fm.cms_chk.checked = true;	
	       
	       }  
		}
	}	
		
	//��������û���ܾ�
	function set_gi_amt(){
		var fm = document.form1;
		
		if ( toInt(parseDigit(fm.gi_amt.value))  > 0  ) {
			if ( toInt(parseDigit(fm.fdft_amt2.value))  > 0  ) {
				fm.gi_j_amt.value 		= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.gi_amt.value)));
			}			
		}
		
		if ( toInt(parseDigit(fm.gi_j_amt.value)) < 0  ) { //�������� ���Աݾ��� �� ����		              
				fm.gi_j_amt.value  = "0";			    
		}
								
		//�������� û���� �������� �ݾ׸�ŭ �ڱ�å���� ������.
		fm.est_amt.value  = fm.gi_j_amt.value; 				
	}	
	
	//����ȸ�����
	function set_etc_amt(){
		var fm = document.form1;
		
		fm.etc_out_amt.value 		= parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)) + toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		fm.etc_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));	
		fm.etc_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));			
		
		set_cls_s_amt();		
	}	
	
	
	//���ݰ�꼭 check ���� �ΰ��� - �����Ծ׿� �ΰ��� ��ŭ ���Ѵ�(�뿩��, ��å���� ���� (�̹� ��������)) - ���ݰ�꼭 ����Ǹ� �ܻ����ݰ��� 
	function set_vat_amt(obj){
		var fm = document.form1;
			
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
				
	}
			
	// cms ������ ���� - ȯ�ұݾ��� �ִ� ��� 
	function set_cms_value(obj){
		var fm = document.form1;

		if(obj == fm.re_cms_chk){ // �����
		 	if (obj.checked == true) {
		 			fm.re_bank.value 		= '<%=re_bank%>';	
		 			fm.re_acc_no.value 		= '<%=re_acc_no%>';	
				 	fm.re_acc_nm.value 		= '<%=re_acc_nm%>';						 	
			} else {
					fm.re_bank.value 		=  "";	
					fm.re_acc_no.value 		=  "";
					fm.re_acc_nm.value 		=  "";		
		   }	
		}						
	}

    //Ư�̻���  ����
	function view_cng_etc(m_id, l_cd){
		window.open("/agent/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
	//������������ ��û�� �Ǿ� �ִ� �����̸� �ȳ� Ȯ��â(20190605)
	function confirmECarCharger(){
		<%if(!ec_bean.getRent_l_cd().equals("")){%>
				alert("������ ������ ��û�� �Ǿ� �ִ� ����Դϴ�.\n\n������ ������ ������ ��û�� �����ؾ� �մϴ�.");
		<%}%>
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
<form action='' name="form1" method='post'>

<input type='hidden' name='car_gu' 	value='<%=base.getCar_gu()%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 	value='<%=andor%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name="fee_size"			value="<%=fee_size%>">    
<input type='hidden' name='rent_start_dt' value='<%=base1.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base1.get("RENT_END_DT")%>'>  
<input type='hidden' name='car_mng_id' value='<%=base1.get("CAR_MNG_ID")%>'>
<input type='hidden' name='con_mon' value='<%=base1.get("CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base1.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base1.get("IFEE_S_AMT")%>'>
<input type='hidden' name='fee_s_amt' value='<%=base1.get("FEE_S_AMT")%>'>
  
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 

<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'>   <!-- ��ü�� ���� ������¥ -->
<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--�����ϱ��� ������Ⱓ -->

<input type='hidden' name='bank_code2' 	value=''>
<input type='hidden' name='deposit_no2' value=''>
<input type='hidden' name='bank_name' 	value=''>  
 
<input type='hidden' name='cls_s_amt' value='' >
<input type='hidden' name='cls_v_amt' value='' >
<input type='hidden' name='car_ja_no_amt' value='<%=car_ja_no_amt%>' >

<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'>
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_V_AMT")))%>'>
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_AMT")))%>'> <!--�������� ��ü���뿩�� -�ܾ� -->

<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_S_AMT")))%>'> <!--�������� �����뿩�� -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'>  

<input type='hidden' name='s_mon' value='<%=base1.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base1.get("S_DAY")%>'> 

<input type='hidden' name='reg_cnt' value='<%=reg_cnt%>'> <!-- ���Ͽ��� -->
<input type='hidden' name='cms_yn' value='<%=re_bank%>'>  

<input type='hidden' name='lfee_mon' value='<%=base1.get("LFEE_MON")%>'> <!--�뿩������ -->

<input type='hidden' name='rifee_v_amt' value=''> <!-- �ΰ��� ����  -->
<input type='hidden' name='rfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt_1' value=''>
<input type='hidden' name='over_v_amt' value=''>
<input type='hidden' name='over_v_amt_1' value=''>

  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
 	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
	</tr>	
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
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ�<%}else if(bus_st.equals("2")){%>�������<%}else if(bus_st.equals("3")){%>��ü�Ұ�<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>��ȭ���<%}else if(bus_st.equals("6")){%>������ü<%}else if(bus_st.equals("7")){%>������Ʈ<%}else if(bus_st.equals("8")){%>�����<%}%></td>
          </tr>
          <tr> 
            <td class=title>��������</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
            <td class=title>�뵵����</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}%></td>
            <td class=title>��������</td>
            <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
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
            <td style="font-size : 8pt;" width="3%" class=title rowspan="2">����</td>
            <td style="font-size : 8pt;" width="10%" class=title rowspan="2">�������</td>
            <td style="font-size : 8pt;" width="6%" class=title rowspan="2">�̿�Ⱓ</td>
            <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 8pt;" width="7%" class=title rowspan="2">�����</td>
            <td style="font-size : 8pt;" width="9%" class=title rowspan="2">���뿩��</td>
            <td style="font-size : 8pt;" class=title colspan="2">������</td>
            <td style="font-size : 8pt;" width="10%" class=title rowspan="2">������</td>
            <td style="font-size : 8pt;" class=title colspan="2">���ô뿩��</td>
            <td style="font-size : 8pt;" class=title colspan="2">���Կɼ�</td>
          </tr>
          <tr>
            <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 8pt;" width="3%" class=title>%</td>			
          </tr>
		  <%for(int i=0; i<fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				if(!fees.getCon_mon().equals("")){
				
				s_opt_per = fees.getOpt_per();
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
			%>	
          <tr>
            <td style="font-size : 8pt;" align="center"><%=i+1%></td>
            <td style="font-size : 8pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
            <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>����</td>
            <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
            <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
            <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
          </tr>
		  <%}}%>
        </table>
	  </td>
	</tr>
	<tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2" style='background-color:bebebe; height:1;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>		
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
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
			  <select name="cls_st" onChange='javascript:cls_display()'>
			    <option value="">---����---</option> 
                <option value="7">���������(����)</option>         
<!--                <option value="10">����������(�縮��)</option>   -->
              </select> </td>
            
            <td width='13%' class='title'>�Ƿ���</td>
            <td width="13%">&nbsp;
              <select name='reg_id'>
                <option value="">����</option>
                <%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%		}
					}%>
              </select></td>	
                      
            <td width='13%' class='title'>��������</td>
            <td width="13%">&nbsp;
			  <input type='text' name='cls_dt' value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'></td> 
		    <td width='13%' class='title'>�̿�Ⱓ</td>
		    <td >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' readonly  value='<%=base1.get("R_MON")%>' >����&nbsp;
		      <input type='text' name='r_day' size='2' class='text' value='<%= base1.get("R_DAY")%>' >��&nbsp;</td>
         
            </td>
          </tr>
          <tr> 
            <td class='title'>���� </td>
            <td colspan="7">&nbsp;
			  <textarea name="cls_cau" cols="140" class="text" style="IME-MODE: active" rows="3"></textarea> 
            </td>
          </tr>
          <tr>                                                      
            <td class=title >�ܿ�������<br>������ҿ���</td>
     	    <td>&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'>
                <option value="N">��������</option>
                <option value="Y" selected>�������</option>
              </select>
		    </td>
		    <td  class=title width=10%>�����������</td>
            <td  width=12%>&nbsp;
			</td>			        
            <td  colspan="4" align=left>&nbsp;�� ����� ��꼭�� ���� �Ǵ� ��ҿ��� �� Ȯ���� �ʿ�, ������ҽ� ���̳ʽ� ���ݰ�꼭 ���� </td>
          </tr>
                  
        </table>
      </td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ���������, ������������ ��쿡 ���ؼ� ������ ������ ��������縦 ���ؾ� �մϴ�. �̰�� ������ ������ �ʼ��׸��Դϴ�.</td>
    </tr>  
      
    <tr>
      <td>&nbsp;</td>
    </tr>
    
    <tr id=tr_dae style='display:none'> 
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
    
 	
  	<tr id=tr_ret style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ȸ��</span></td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		    
			<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 
			            <td width='13%' class='title'>ȸ������</td>
			            <td width="20%">&nbsp;<input type="radio" name="reco_st" value="Y" checked onClick='javascript:cls_display2()'>ȸ��
	                            <input type="radio" name="reco_st" value="N"  onClick='javascript:cls_display2()'>��ȸ��</td>
	                    <td width='13%' class='title'>����</td>
	                    
	                    <td id=td_ret1 style="display:''">&nbsp; 
						  <select name="reco_d1_st" >
						    <option value="">---����---</option>
			                <option value="1">����ȸ��</option>
			                <option value="2">����ȸ��</option>
			                <option value="3">����ȸ��</option>
			               </select>       
			            </td>
			            
			            <td id=td_ret2 style='display:none'>&nbsp; 
						  <select name="reco_d2_st" >
						    <option value="">---����---</option>
						    <option value="1">����</option>
						    <option value="2">Ⱦ��</option>
						    <option value="3">���</option>
						   </select>       
			            </td>
			            
			            <td class='title' width='13%' >����</td>
						<td>&nbsp;
						<input type="text" name="reco_cau" size=30 maxlength=100 >
						</td>				        		         
		         </tr>
		                   
		         <tr>      
		            <td width='10%' class='title'>ȸ������</td>
		            <td>&nbsp;
					  <input type='text' name='reco_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		            <td width='10%' class='title'>ȸ�������</td>
		            <td>&nbsp;
					  <select name='reco_id'>
		                <option value="">����</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>
		            </td>
		            <td width='10%' class='title'>�԰�����</td>
		            <td>&nbsp;
					  <input type='text' name='ip_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		          </tr>
		          <tr>      
		            <td width='10%' class='title'>����Ÿ�</td>
		            <td>&nbsp;
					  <input type='text' name='tot_dist' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km 
		            </td>
		            <td  colspan=4  align=left>&nbsp;�� �ߵ����� �� ����� ��������Ÿ� </td>
		          </tr>
		          <tr>		          
		           <td class=title>��������ġ</td>
	                    <td colspan=3> 
	                      &nbsp;<SELECT NAME="park" >
	                      			<option value="" >--����--</option>    
	                    		  <%if(good_size > 0){ 			
	                   			   for(int i = 0 ; i < good_size ; i++){
                  								CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' ><%= good.getNm()%></option>		                 
                   		   <%	}                      
								  } %>                
	        		        </SELECT>	        		  
				<input type="text" name="park_cont" value="" size="40" class=text style='IME-MODE: active'>
						   (��Ÿ���ý� ����)
	                    </td>
	                     <td class=title>������ ��밡��</td>
	                      <td> &nbsp;<input type="radio" name="serv_st" value="Y" >��ð���
	                            <input type="radio" name="serv_st" value="N"  >������ ����</td>	                    
		   </tr>
		    <tr>      
		            <td width='10%' class='title'>���ֺ��</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> ��</td>
		            </td>
		            <td width='10%' class='title'>�δ���</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> ��</td>
		            </td>
		            <td width='10%' class='title'>����</td>
		            <td>&nbsp;
					 <input type='text' name='etc_out_amt' size='12' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
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
		                    <input type='text' name='grt_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
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
		                    <input type='text' size='3' name='ifee_mon' readonly  value='' class='num' maxlength='4'>
		                    ����&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='' class='num' maxlength='4' >
		                    ��</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >����ݾ�</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    ��</td>
		                  <td>=���ô뿩�᡿����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ���ô뿩��(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    ��</td>
		                  <td class='title'>=���ô뿩��-����ݾ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">��<br>
		                    ��<br>
		                    ��</td>
		                  <td align='center'>�������� </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    ��</td>
		                  <td>=�����ݡ����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td align='center'>������ �����Ѿ� </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    ��</td>
		                  <td>=�������ס����̿�Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ������(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                    ��</td>
		                  <td class='title'>=������-������ �����Ѿ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">��</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
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
        <td class=h></td>
    </tr>  
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳��ݾ� ����</span>[���ް�]</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    
    <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
              <td class="title" colspan="4" rowspan=2>�׸�</td>
              <td class="title" width='38%' colspan=2> ����</td>                
              <td class="title" width='40%' rowspan=2>���</td>
            </tr>
            <tr>                 
              <td class="title"'> ���ʱݾ�</td>
              <td class="title"'> Ȯ���ݾ�</td>
            </tr>
            <tr> 
              <td class="title" rowspan="18" width="4%">��<br>
                ��<br>
                ��<br>
                ��<br>
                ��</td>
              <td class="title" colspan="3">���·�/��Ģ��(D)</td>
              <td align="center" class="title"> 
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>' size='15' class='num' >
               ��</td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>'  size='15' class='num'  > 
               ��</td>
              <td class="title"><font color="#66CCFF"><%=base1.get("FINE_CNT")%>��</font></td>
             </tr>
             <tr> 
              <td class="title" colspan="3">�ڱ��������ظ�å��(E)</td>
              <td width='19%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>' size='15' class='num' >
                ��</td>
              <td width='19%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>'  size='15' class='num'  > 
                ��</td>                   
              <td width='40%' class="title"><font color="#66CCFF"><%=base1.get("SERV_CNT")%>��</font></td>
            </tr>
            <tr>
              <td class="title" rowspan="4" width="4%"><br>
                ��<br>
                ��<br>
                ��</td>
              <td align="center" colspan="2" class="title">������</td>   
               <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
                <input type='text' name='ex_di_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' >
                ��</td>
              <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td>              
            
              <td>&nbsp; </td>
            </tr>
          
            <tr> 
              <td rowspan="2" align="center" class="title" width="4%">��<br>
                ��     </td>
              <td width='10%' align="center" class="title">�Ⱓ</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' size='3' name='nfee_mon'  value='<%=AddUtil.parseInt((String)base1.get("S_MON"))%>' readonly class='num' maxlength='4' >
                ����&nbsp;&nbsp;&nbsp; 
                <input type='text' size='3' name='nfee_day'  value='<%=AddUtil.parseInt((String)base1.get("S_DAY"))%>' readonly class='num' maxlength='4' >
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" class="title">�ݾ�</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt'  readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' > ��</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td>  
              <td>������꼭�� ���� �Ǵ� ��ҿ��θ� Ȯ��</td>
            </tr>
         
            <tr> 
              <td class="title" colspan="2">�Ұ�(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt' value='' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>  
              <td class='title'>&nbsp;=������ + �̳���</td>
   	         </tr>
           
                <input type='hidden' size='15' name='d_amt' value='' readonly class='num' >
                <input type='hidden' size='15' name='d_amt_1' readonly value='' class='num'>
             
            <tr> 
              <td rowspan="6" class="title">��<br>
                ��<br>
                ��<br>
                ��<br>
                ��<br>
                ��<br>
                ��</td>
              <td align="center" colspan="2" class="title">�뿩���Ѿ�</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base1.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
              <td>=������+���뿩���Ѿ�</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">���뿩��(ȯ��)</td>
              <td class='' colspan=2 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
              <td>=�뿩���Ѿס����Ⱓ</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��뿩���Ⱓ</td>
              <td class=''  colspan=2  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=rcon_mon%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                ����&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day' readonly size='3' value='<%=rcon_day%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
              <td class=''  colspan=2 align="center"> 
                <input type='text' name='trfee_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> ����� 
                �������</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int' readonly value='<%=base1.get("CLS_R_PER")%>' size='5' class='num'  maxlength='4'>
                %</td>
                <td class=''  align="center"> 
                <input type='text' name='dft_int_1' value='<%=base1.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                %</td>
           
              <td>*����� ��������� ��༭�� Ȯ�� <br><font color=red>*</font>��������� ������ �߻��� ����ȿ������ڸ� �ݵ�� ����</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">�ߵ����������(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='' >
                ��</td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' size='15' class='num' value='' onBlur='javascript:set_cls_amt(this)'>
                ��</td>
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                <td class="title"><input type =hidden  name='tax_chk0' value='N' ><!--��꼭�����Ƿ�-->              
                &nbsp;<font color="#FF0000">*</font>����ȿ�������: 
                      <select name='dft_cost_id'>
		                <option value="">����</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>
		              
                </td>
 
            </tr>      
       
            <tr> 
              <td class="title" rowspan="5"><br>
                ��<br>
                Ÿ</td> 
            
              <td colspan="2"  class="title">��ü��(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' > ��</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> ��</td>
             
              <td class='title'>&nbsp;</td>
            </tr>
            <tr>
              <td class="title" colspan="2">����ȸ�����ֺ��(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                ��</td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                ��</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;<input type='hidden' name='tax_chk1' value='N' ></td>
            </tr>
            <tr> 
              <td class="title" colspan="2">����ȸ���δ���(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                ��</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>  
              <td class="title">&nbsp;<input type='hidden' name='tax_chk2' value='N' ></td>
            </tr>
            <tr> 
              <td colspan="2" class="title">������������(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                ��</td>  
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">��Ÿ���ع���(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                ��</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;<input type='hidden' name='tax_chk3' value='N' ><!--��꼭�����Ƿ�--></td>
            </tr>
                   
            <tr> 
              <td class="title" colspan="3">�ΰ���(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='' readonly size='15' class='num' >
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='' readonly size='15' class='num' >
                ��</td>  
              <td > 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td id=td_cancel_n style="display:''" class="title">=(�뿩�� 
                      �̳��Աݾ�-B-C)��10% + ��꼭 ���� �ΰ��� </td>
                    <td id=td_cancel_y style='display:none' class='title'>=(�뿩�� 
                      �̳��Աݾ�-B-C)��10% + ��꼭 ���� �ΰ��� </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr> 
              <td class="title_p" colspan="4">��</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1' value='' readonly  size='15' class='num' >
                ��</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='' readonly  size='15' class='num' >
                ��</td>  
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M)&nbsp;&nbsp;
               <br>�� ��꼭:&nbsp;             
               <input type="radio" name="tax_reg_gu" value="N" checked >�׸�û��
               <input type="radio" name="tax_reg_gu" value="Y" >�׸��ջ�û��
               <input type="radio" name="tax_reg_gu" value="Z" >�뿩����������û��
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
                    <td class=title width=10% >�����Աݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2'  size='15' class='num' readonly  > ��</td>           
                              
                    <% if ( h_cms.get("CBNO") == null  ) {%>
                    <td colspan=6>&nbsp;�� �̳��ݾװ� - ȯ�ұݾװ�</td>
                    <% } else { %>                  
                  	<td class=title width=12% ><input type='checkbox' name='cms_chk' value='Y' >CMS�����Ƿ�</td>
                 	<td colspan=5>&nbsp;�� �̳��ݾװ� - ȯ�ұݾװ�</td>                   	
                    <% } %>
                    
              </tr>
          
              </table>
         </td>       
    <tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ����������� CMS�� �����ϰ����� ���� CMS�����Ƿڿ� check �ϼ���. </td>
    </tr>    
  
    <tr></tr><tr></tr><tr></tr>
    
   	<tr> 
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td  class=title width=10%>��ü�ᰨ��<br>������</td>
                    <td  width=12%>&nbsp;
						  <select name='dly_saction_id'>
			                <option value="">--����--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>��ü�� ���׻���</td>
                    <td colspan=3>&nbsp;<textarea name="dly_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
			
                </tr>
                <tr>
             		<td  class=title width=10%>�ߵ����������<br>���� ������</td>
                    <td  width=12%>&nbsp;
						  <select name='dft_saction_id'>
			                <option value="">--����--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>�ߵ����������<br>���׻���</td>
                    <td colspan=3>&nbsp;<textarea name="dft_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
				   
                </tr>
                	<td  class=title width=10%>Ȯ���ݾװ�����</td>
                    <td  width=12%>&nbsp;
						  <select name='d_saction_id'>
			                <option value="">--����--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>Ȯ���ݾ� ����</td>
                    <td colspan=3>&nbsp;<textarea name="d_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
				  
                </tr>
              </table>
         </td>       
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> �ߵ����� ������� ���� �����ؼ��� ������ ��ä�������� ���縦 ���ؾ� �մϴ�. �̰�� �ߵ���������� ���� ������ �ʼ��׸��Դϴ�.</td>
    </tr>
    
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_sale style='display:none'> 
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >���Կɼǽ�<br>�����Աݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt3'  size='15' class='num' readonly  > ��</td>
                    <td colspan=6>&nbsp;�� �����Աݾ�  + ���ԿɼǱݾ� + ������Ϻ��(�߻��� ���)</td>
              </tr>
                       
              </table>
         </td>       
    <tr>
   
   
<!-- ä���� �ִ� ��쿡 ���� -->
    <tr>
        <td>&nbsp;</td>
    </tr>
        
   	<tr id=tr_gur style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä�ǰ���</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr>
                    <td class=title width=12%>��������</td>
                    <td class=title width=13%>����ݾ�</td>
                    <td width=12%>&nbsp;<input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                    <td class=title width=12%>û��ä��</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_c_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'> ��</td>
                    <td class=title width=12%>����ä��</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_j_amt' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
                </tr>
                <!-- ��ǥ���뺸���� -->
<% if(gur_size > 0){
				for(int i = 0 ; i < gur_size ; i++){
					Hashtable gur = (Hashtable)gurs.elementAt(i); %>       
				                
                <tr>
                  <%if (i == 0 ) { %> <td class=title width=12% rowspan=<%=gur_size%>>���뺸��</td> <% } %>
                    <td class=title width=13%>�Ժ�����</td>
                    <td width=12%>&nbsp;<input type='text' name='gu_st'  size='15' class='text' > </td>
                    <td class=title width=12%>�����μ���</td>
                    <td width=13%>&nbsp;<input type='text' name='gu_nm' value='<%=gur.get("GUR_NM")%>' size='15' class='text' > </td>
                    <td class=title width=12%>����ڿͰ���</td>
                    <td width=13%>&nbsp;<input type='text' name='gu_rel' value='<%=gur.get("GUR_REL")%>' size='15' class='text' ></td>
                </tr>
             <% }
  }             %> 
                <tr>
                    <td class=title width=12%>�ڵ������غ���</td>
                    <td class=title width=13%>�����</td>
                    <td width=17%>&nbsp;<input type='text' name='c_ins'  size='18' class='text' > </td>
                    <td class=title width=12%>�����</td>
                    <td width=17%>&nbsp;<input type='text' name='c_ins_d_nm'  size='18' class='text' > </td>
                    <td class=title width=12%>����ó</td>
                    <td width=17%>&nbsp;<input type='text' name='c_ins_tel' size='18' class='text' ></td>
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
     
    <!-- ����ä���� �ִ� ��� -->
     
    <tr id=tr_cre style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ä���� ó���ǰ�/���û���</span></td>
 	 	  </tr>  
	      <tr>
	        <td class=line2></td>
	      </tr>
	      <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	                <tr>
	                    <td class=title colspan=2>����</td>
	                    <td class=title width=75%>ó���ǰ�/���û���/����</td>
	                  
	                </tr>
	                <tr>
	                    <td class=title width=12%>��������û��</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu1">
	                          <option value="" selected>-����-</option>
		                      <option value="Y" >��</option>
		                      <option value="N" >�ƴϿ�</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark1' size='120' class='text' ></td>
	                 
	                </tr>
	                <tr>
	                    <td class=title>���뺸���α���</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu2">
	                          <option value="" selected>-����-</option>
		                      <option value="Y" >��</option>
		                      <option value="N" >�ƴϿ�</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark2' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>ä���߽ɿ���</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu3">
	                          <option value="" selected>-����-</option>
		                      <option value="Y" >��</option>
		                      <option value="N" >�ƴϿ�</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark3' size='120' class='text' ></td>
	                   
	                </tr>
	                <tr>
	                    <td class=title>�ڵ������غ���</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu4">
	                          <option value="" selected>-����-</option>
		                      <option value="Y" >��</option>
		                      <option value="N" >�ƴϿ�</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark4' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>����</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu5">
	                          <option value="" selected>-����-</option>
		                      <option value="Y" >��</option>
		                      <option value="N" >�ƴϿ�</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark5' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>���ó��</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu6">
	                          <option value="" selected>-����-</option>
		                      <option value="Y" >��</option>
		                      <option value="N" >�ƴϿ�</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark6' size='120' class='text' ></td>
	                  
	                </tr>
	            </table>
	        </td>
	      </tr>
	     <tr></tr><tr></tr>    
	        			         
	     <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	       		  <tr>
	                    <td class=title width=12%>������</td>
	                    <td width=13%>&nbsp;
							  <select name='crd_id'>
				                <option value="">����</option>
				                <%	if(user_size > 0){
										for(int i = 0 ; i < user_size ; i++){
											Hashtable user = (Hashtable)users.elementAt(i); %>
				               	<option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
				  
				                <%		}
									}%>
				              </select>
				        </td>
	                    <td class=title width=12%>����</td>
					    <td colspan=3>&nbsp;<input type='text' name='crd_reason' size='100' maxlength=300 class='text'></td>
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
	      
	<!-- ����ä���� �ִ� ��� -->
    <tr id=tr_get style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä���� �ڱ�å</span></td>
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
					                <option value="1">�Ͻó�</option>
					                <option value="2">�г�</option>
					              </select>             
					              <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                        <tr> 
					                         
					                           <td id='td_div' style='display:none'>&nbsp;�г�Ƚ��&nbsp;  
					                             <select name="div_cnt">
												    <option value="">---����---</option>
									                <option value="2">2</option>
									                <option value="3">3</option>
									                <option value="4">4</option>
									                <option value="5">5</option>
									                <option value="6">6</option>
									                <option value="7">7</option>
									                <option value="8">8</option>
									                <option value="9">9</option>
									                <option value="10">10</option>
									                <option value="11">11</option>
									                <option value="12">12</option>
									              </select>
					                            </td>
					                        </tr>
					                </table>
					         	</td>
					    	</tr>
					  
		                	<tr>
			                    <td class=title width=13%>����</td>
			                    <td class=title width=12%>������</td>
			                    <td>&nbsp;<input type='text' name='est_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
			                    <td class=title width=12%>�����ݾ�</td>
			                    <td>&nbsp;<input type='text' name='est_amt' size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
			                    <td class=title width=12%>������</td>
			                    <td>&nbsp;<input type='text' name='est_nm' size='15' class='text'></td>
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
									         <td width=12%>&nbsp;<input type='text' name='gur_nm' size='15' class='text'></td>
						                     <td width=12% class=title>����ó</td>
						                     <td>&nbsp;<input type='text' name='gur_rel_tel' size='30' class='text'></td>
						                     <td width=12% class=title>����ڿ��ǰ���</td>  
						                     <td colspan=3>&nbsp;<input type='text' name='gur_rel' size='30' class='text'></td>     
		           			             
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
					                    <td class=title style='height:44' width=13%>ó���ǰ�/���û���/<br>����</td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="remark" cols="140" class="text" style="IME-MODE: active" rows="3"></textarea> 
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
    
    <!-- ȯ�ұݾ��� �ִ� ��쿡 ���� -->
        
   	<tr id=tr_refund style='display:none'> 
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
                        <td class="title"> �ڵ���ü </td>
                        <td >&nbsp; <input type="checkbox" name="re_cms_chk" value='Y' onClick="javascript:set_cms_value(this);">����</td>
                        <td class="title">�����ָ�</td>
                        <td >&nbsp; <input type="text" name="re_acc_nm" value="" size="30" class=text></td>
                    </tr>
                        
                    <tr> 
                        <td width=15% class="title">�����</td>
                        <td width=35%>&nbsp; <select name="re_bank" style="width:135">
                            <option value="">==����==</option>
			      <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					    	<option value='<%=h_c_bnk.get("BCODE")%>'><%=h_c_bnk.get("BNAME")%></option> 	
                     
				              <%		}
							}%>
				              </select></td>
                        <td width=15% class="title">���¹�ȣ</td>
                        <td width=35%>&nbsp; <input type="text" name="re_acc_no" value="" size="30" class=text></td>
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
        
   	<tr id=tr_scd_ext style='display:none'> 
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
        
    <tr>
	  <td align="center">&nbsp;<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>	
  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--

	set_init();
	
	function set_init(){
		var fm = document.form1;
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
		var v_ifee_ex_amt = 0;  //���ô뿩�� ����ݾ�
		var  re_nfee_amt = 0;  //�������� �����쿡�� �ϼ� ����� �ݾ��� �ƴ� ��� check
 	 	 	 	
 	 	 	
 	// 	alert(fm.r_day.value);
 	 	//�ѻ���ϼ� �ʱ� ����		
		if(fm.r_day.value == '30'){
			fm.r_mon.value = toInt(fm.r_mon.value) + 1;
			fm.r_day.value = '0';			
		}
				    
 				
		//�������� ��ุ���Ϻ��� ū ��� �������� setting
		if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
			fm.cancel_yn.value = 'N';
			td_cancel_n.style.display 		= 'none';  //��������
			td_cancel_y.style.display 		= '';  //�������
		}
				
			
				//���������(����)�� ��� ������� setting
		if ( fm.cls_st.value == '7' || fm.cls_st.value == '10') { //���������(����) , �縮��(����������)
			fm.cancel_yn.value = 'Y';
			td_cancel_n.style.display 		= 'none';  //��������
			td_cancel_y.style.display 		= '';  //�������
			tr_sale.style.display 		= 'none';  //�����Ű��� �����Աݾ�
		}
			
		
		//�ܿ����ô뿩�� 
		if(fm.ifee_s_amt.value != '0'){
			ifee_tm = parseDecimal(( toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
		//	pay_tm = toInt(fm.con_mon.value)-ifee_tm;
			pay_tm =  parseDecimal(toInt(fm.con_mon.value)-ifee_tm) ;
			
		
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
				fm.ifee_day.value 	= fm.r_day.value;
			}
					
			
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
										
			v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
			v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));				 										  //�ܾ�
		    
			if (v_rifee_s_amt == -1 || v_rifee_s_amt == 1 ) v_rifee_s_amt = 0;  //����
		
	    	if ( fm.cls_st.value == '7' || fm.cls_st.value == '10') { //���������(����) , �縮��(����������)
	  		} else {
				if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //��������  - ���ô뿩�� ��ü �� ������
			    		
			    		fm.ifee_ex_amt.value = '0';
			    		fm.rifee_s_amt.value = '0'; 		    		
			    		v_rifee_s_amt = 0;		    		
			   	} 
			}
			
			if ( v_rifee_s_amt == 0) { //�������� 
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	    		v_rifee_s_amt = 0;	  
	    	}		
		
		}
		
			//���ô뿩�ᰡ �������� �뿩�Ḧ ���� ������ ��� ó�� - 20100924 �߰�
		if(fm.ifee_s_amt.value != '0'){
			if ( toInt(fm.rent_end_dt.value) == toInt(fm.use_e_dt.value) ) {
		   		   if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� ���� ���
		   		   		fm.ifee_mon.value 	= '';
						fm.ifee_day.value 	= '';	
		   		   		fm.ifee_ex_amt.value = '0';
		   		   		fm.rifee_s_amt.value = parseDecimal(fm.ifee_s_amt.value) ; 
		   		   }
		   	} 
	    }

		//�ܿ�������?
		if(fm.pp_s_amt.value != '0'){		
			fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
			fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value)) 
	
		}else{
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;
		}
			
		
		if(fm.pp_s_amt.value != '0') {
	 	 
	 	 	if ( fm.cls_st.value == '7' || fm.cls_st.value == '10') { //���������(����) , �縮��(����������)
	  		} else {
		    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //������
		    		
		    		fm.pded_s_amt.value 	= 0;
					fm.tpded_s_amt.value 	= 0;
					fm.rfee_s_amt.value 	= 0;
		    	}   
		    }	
	    }	
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // �����ݾ��� ����� ���
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
	
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );

			   	    
		//�̳��Աݾ� ���� �ʱ� ����		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}
		
		//���ô뿩�ᰡ ���� ��� 		 -- nnfee_s_amt : �̳��ݾ�(�ܾ׾ƴ�). di_amt :�ܾ׹̳��ݾ�  	  -- �뿩���ð� �� ���    		
		 if(fm.ifee_s_amt.value == '0' ) {
		   	 // ������������� �������� �� ū ��� 
		  	 		   	 
		    if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 		
		   	 	//	  alert("a");
		   	 		  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
		   	 		//    	 alert("b");
		   	 		    	var s1_str = fm.use_e_dt.value;
							var e1_str = fm.cls_dt.value;
							var  count1 = 0;
								
									   
							var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
							var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
					
							var diff1_date = e1_date.getTime() - s1_date.getTime();
					
							count1 = Math.floor(diff1_date/(24*60*60*1000));									
								
					  	   	if ( count1 >= 0 ) { // �뿩�Ḹ���ϰ� ������ �� (������ü�ϼ� ���)					  	   	
					  	   		 fm.nfee_mon.value = parseInt(count1 / 30); 
					  	   		 fm.nfee_day.value  =  parseInt(count1 % 30); 					  	 
					  	   }
		   	 		 
		   	 		  }  else  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
		   	 	//	     alert("c");
		   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ����
		   	 		      if ( toInt(fm.nfee_mon.value) < 0 ) {
						  	 	   	  fm.nfee_mon.value = '0';
						  }
		   	 		     
		   	 		  } 
		   	 	
		   	} //�������� ����.  		  
		
		} //���ô뿩�ᰡ ���� ���
			 	
		
			 //�뿩���ð� �ȵȰ��
	  	if(toInt(fm.rent_start_dt.value)  < 1){
				 fm.nfee_mon.value = ''; 
				 fm.nfee_day.value  =  ''; 			
		}		 
		
		 		//���������,����������  ���
		if ( fm.cls_st.value == '7'  || fm.cls_st.value == '10'   ) {
		  		 fm.nfee_mon.value = ''; 
				 fm.nfee_day.value  =  ''; 			
		}
			 
		//�뿩�ᰡ 100������ ��� ���� ó�� - 2011-01-24.	- �������θ� ó��		 
		if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
			   if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
			   		fm.nfee_day.value = '0';
			   } 
				fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		} else {
				fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		}
	    
		
		 if (fm.ifee_s_amt.value == '0' ) {	
		  	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		      if  ( fm.nfee_amt.value  != '0' ) {
			     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
		 	    	fm.nfee_amt.value = fm.nnfee_s_amt.value;
			 	 }	
			  }	 
		    }		    		   
		 }  			
		
						  		
	  // ���ô뿩�� �ִ� ��쿡 ����. (�������� �뿩�Ⱓ�� ����� ��쿡 ���� )	 
	  	if(fm.ifee_s_amt.value != '0' ) {
	 
		   		if (v_rifee_s_amt <= 0 ) {  //���ô뿩�Ḧ �� ������ ���  -���ô뿩�� ���� ���� ���� 
		   	      	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
			  			     
			      if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 	
			  		//   alert("a1");			  		
			  		} else {  //�̳��� ���� ���  		
			  		  	  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
			  		      
			  		         var s1_str = fm.rent_end_dt.value;
							   var e1_str = fm.cls_dt.value;
							   var  count1 = 0;								
										   
								var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
								var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
						
								var diff1_date = e1_date.getTime() - s1_date.getTime();
						
								count1 = Math.floor(diff1_date/(24*60*60*1000));									
									
						  	   	if ( count1 >= 0 ) { // �뿩�Ḹ���ϰ� ������ �� (������ü�ϼ� ���)					  	   	
						  	   		 fm.nfee_mon.value = parseInt(count1 / 30); 
						  	   		 fm.nfee_day.value  =  parseInt(count1 % 30); 					  	 
						  	   }
						  	   					  	   
						  	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			  		 
			  		      }			  		
			  		}	
			  }  else {  //���ô뿩�ᰡ ���� ��� (�ߵ������Ǵ� ��� )		
			  
			  	     if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
			   	 		    // alert("d1");		   	 		
			   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ����
			   	 		     	
							  if ( toInt(fm.nfee_mon.value) < 0 ) {
							  	 	   	  fm.nfee_mon.value = '0';
							  }
						}		 	 
			  } 
		   	 		  
	   } //���ô뿩�ᰡ �ִ� ��� 	 	 
	   
	   	if(fm.r_day.value != '0'){
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //��������
					
			} else { //�뿩�������� ���ڰ� �ִ���.. �ܿ��뿩�Ⱓ��� ����2010-07-06  - 30�ϱ������� ���
			 	  if (	toInt(fm.r_day.value) + toInt(fm.rcon_day.value) == 31 ) {
				    	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);	
				  } else  if (toInt(fm.r_day.value) + toInt(fm.rcon_day.value) < 30 ) {
				    	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);	
				  }
				
			//	fm.rcon_mon.value 		= toInt(fm.con_mon.value) - toInt(fm.r_mon.value) - 1;
			//	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
			}	
		}else{
			fm.rcon_mon.value = toInt(fm.con_mon.value) - toInt(fm.r_mon.value);
			fm.rcon_day.value = fm.r_day.value;			
		}	    
	 	   
	 		//����������̸鼭 ���������ִ� ���
		if ( fm.cls_st.value == '7' &&  fm.prv_dlv_yn[1].checked == true  ) {
			
			 fm.nfee_mon.value 	= "0";	
			 fm.nfee_day.value 	= "0";	
			 fm.nfee_amt.value  = "0";	
			 //�������� �̳��뿩��� ���������� ó���Ѵ�.
			 
			 if  ( toInt(parseDigit(fm.nnfee_s_amt.value)) > 0 && fm.r_con_mon.value == '0') {
				  fm.ex_di_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nnfee_s_amt.value)));
				  fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
			 }
			 
		}    
	 	    
	   	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		   	
	    fm.nfee_amt_1.value 		= fm.nfee_amt.value; 
	    fm.ex_di_amt_1.value 		= fm.ex_di_amt.value;   
	    fm.ex_di_v_amt_1.value 		= fm.ex_di_v_amt.value;     
	
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)));
		  
		if(toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
		
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}	
					
		if (  toInt(fm.rent_start_dt.value) < 1 ) {
			fm.dft_amt.value 			= "0"; 
			fm.dft_amt_1.value 			= "0";	
		} else {	
			if ( fm.cls_st.value == '7' || fm.cls_st.value == '10' ) { //���������(����)�� ��� ��������� 0
				fm.dft_amt.value 			= "0"; 
				fm.dft_amt_1.value 			= "0";			
			} else { 	
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int_1.value)/100) );
			}	
	   }
						 		
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	 		
		var no_v_amt =0;  //�ΰ����� ������ ���
		
		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
		
	    fm.rifee_v_amt.value = toInt(parseDigit(fm.rifee_s_amt.value)) *0.1;  //���ô뿩�� 
	    fm.rfee_v_amt.value = toInt(parseDigit(fm.rfee_s_amt.value)) *0.1;    //������ 
	    
	    fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1);  //���� �뿩�� �ΰ��� 
	    fm.dfee_v_amt_1.value =  fm.dfee_v_amt.value; //Ȯ�� �뿩�� �ΰ��� 
	   	   		    			
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		
        //�̳��ݾװ�
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)));
		
		//Ȯ���ݾ� �����ֱ�
		fm.dly_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dly_amt.value))) ;
		fm.dft_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dft_amt.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
				
		fm.no_v_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)));
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) +  toInt(parseDigit(fm.dly_amt_1.value)) +  toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)) );	 //Ȯ���ݾ�	
						
		//���� ������ �ݾ� �ʱ� ����	(���ԿɼǱݾ��� ǥ�� ����)
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
		
		//������ �ݾ��� �ִٸ�
		if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
			 tr_refund.style.display		= '';	//ȯ������
			 tr_scd_ext.style.display		= '';	//�������������
		} else {
			 tr_refund.style.display		= 'none';	//ȯ������
			 tr_scd_ext.style.display		= 'none';	//�������������
		}	
			
		//cms�̸鼭 �̳��ݾ��� �ִ� ��� 	
		if ( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ) {		   
		   if ( fm.cms_yn.value == '' || fm.cms_yn.value == 'null' ) {		   		  	
		   } else {	
		   	     fm.cms_chk.checked = true;	
	       
	       }  
		}
	}
	
//-->
</script>
</body>
</html>
