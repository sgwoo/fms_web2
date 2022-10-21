<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*, acar.estimate_mng.*, acar.cont.*, acar.res_search.*, acar.user_mng.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="bc_db" class="acar.bad_cust.BadCustDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String tae_car_mng_id 	= request.getParameter("tae_car_mng_id")==null?"":request.getParameter("tae_car_mng_id");
	
	String esti_nm 		= request.getParameter("esti_nm")	==null?"":request.getParameter("esti_nm");
	String a_a 		= request.getParameter("a_a")		==null?"":request.getParameter("a_a");
	String a_b 		= request.getParameter("a_b")		==null?"":request.getParameter("a_b");
	String pp_st 		= request.getParameter("pp_st")		==null?"2":request.getParameter("pp_st");
	String rg_8 		= request.getParameter("rg_8")		==null?"":request.getParameter("rg_8");
	String rent_st 		= request.getParameter("rent_st")	==null?"":request.getParameter("rent_st");
	String spr_yn 		= request.getParameter("spr_yn")	==null?"":request.getParameter("spr_yn");
	String lpg_yn 		= request.getParameter("lpg_yn")	==null?"":request.getParameter("lpg_yn");
	String lpg_kit 		= request.getParameter("lpg_kit")	==null?"0":request.getParameter("lpg_kit");
	String a_h 		= request.getParameter("a_h")		==null?"":request.getParameter("a_h");
	String ins_dj 		= request.getParameter("ins_dj")	==null?"":request.getParameter("ins_dj");
	String ins_age 		= request.getParameter("ins_age")	==null?"":request.getParameter("ins_age");
	String ins_good 	= request.getParameter("ins_good")	==null?"":request.getParameter("ins_good");
	String gi_yn 		= request.getParameter("gi_yn")		==null?"":request.getParameter("gi_yn");
	String car_ja 		= request.getParameter("car_ja")	==null?"":request.getParameter("car_ja");
	String jg_code		= request.getParameter("jg_code")	==null?"":request.getParameter("jg_code");
	String st 		= request.getParameter("st")		==null?"":request.getParameter("st");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String udt_st 		= "";
	String ins_per 		= "";
	String insurant		= "";
	
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");
	String damdang_id	= request.getParameter("damdang_id2")==null?"":request.getParameter("damdang_id2");
	String cust_tel		= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");
	String cust_fax 	= request.getParameter("cust_fax")==null?"":request.getParameter("cust_fax");
	String cust_email 	= request.getParameter("cust_email")==null?"":request.getParameter("cust_email");
	String doc_type 	= request.getParameter("doc_type")==null?"":request.getParameter("doc_type");
	String mgr_nm	 	= request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm");
	String cust_ssn 	= request.getParameter("cust_ssn")==null?"":request.getParameter("cust_ssn");
	String com_emp_yn 	= request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn");
	
	String est_st 		= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?"":request.getParameter("fee_opt_amt");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	String rent_dt	 	= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String cng_item	 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String jg_w	 	= request.getParameter("jg_w")==null?"":request.getParameter("jg_w");
	
	String br_to_st	= request.getParameter("br_to_st")==null?"":request.getParameter("br_to_st");
	String br_to 		= request.getParameter("br_to")==null?"":request.getParameter("br_to");
	String br_from 	= request.getParameter("br_from")==null?"":request.getParameter("br_from");
	
	int o_1	 		= request.getParameter("apply_secondhand_price")==null?0:AddUtil.parseDigit(request.getParameter("apply_secondhand_price"));
	
	//�ҷ��� Ȯ��
	Vector vt_chk1 = new Vector();
	if(!cust_nm.equals("")||!cust_tel.equals("")||!cust_email.equals("")||!cust_fax.equals("")){
		vt_chk1 = bc_db.getBadCustRentCheck(cust_nm, cust_nm, "", "", cust_tel, "", "", cust_email, cust_fax, "", "");
	}	
	int vt_chk1_size = vt_chk1.size();
	
	if(cng_item.equals("taecha") && !tae_car_mng_id.equals("") && from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")){
		car_mng_id = tae_car_mng_id;
	}
	
	//��������
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	//��������-�������̺� ���� ��ȸ
	Hashtable ht2 = shDb.getBase(car_mng_id);
	
	if( (est_st.equals("2") || cng_item.equals("taecha")) && !rent_l_cd.equals("") && String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
		ht2.put("REG_ID", ck_acar_id);
		//sh_base table insert
		int count = shDb.insertShBase(ht2);
	}else{
		int chk = 0;
		if(!String.valueOf(ht2.get("COLO")).equals(String.valueOf(ht.get("COL")))) 							chk++;
		if(!String.valueOf(ht2.get("JG_CODE")).equals(String.valueOf(ht.get("JG_CODE")))) 					chk++;
		if(!String.valueOf(ht2.get("CAR_USE")).equals(String.valueOf(ht.get("CAR_USE")))) 					chk++;
		if(!String.valueOf(ht2.get("CAR_EXT")).equals(String.valueOf(ht.get("CAR_EXT")))) 					chk++;
		if(!String.valueOf(ht2.get("CAR_NO")).equals(String.valueOf(ht.get("CAR_NO")))) 					chk++;
		if(!String.valueOf(ht2.get("SECONDHAND_DT")).equals(String.valueOf(ht.get("SECONDHAND_DT")))) 		chk++;
		if(!String.valueOf(ht2.get("BEFORE_ONE_YEAR")).equals(String.valueOf(ht.get("BEFORE_ONE_YEAR")))) 	chk++;
		if(!String.valueOf(ht2.get("SERV_DT")).equals(String.valueOf(ht.get("SERV_DT")))) 					chk++;
		if(!String.valueOf(ht2.get("TOT_DIST")).equals(String.valueOf(ht.get("TOT_DIST")))) 				chk++;
		if(!String.valueOf(ht2.get("TODAY_DIST")).equals(String.valueOf(ht.get("TODAY_DIST")))) 			chk++;
		if(!String.valueOf(ht2.get("PARK")).equals(String.valueOf(ht.get("PARK")))) 						chk++;
		if(chk >0){
			//sh_base table update
			int count = shDb.updateShBase(ht2);
			
			ht = shDb.getShBase(car_mng_id);
		}
	}
	
	//�ܰ� ��������
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	String a_e = String.valueOf(ht.get("S_ST"));
	String name = "";
	
	if(a_a.equals(""))				a_a = "12";
	if(a_a.equals("1"))				a_a = "12";
	if(a_a.equals("2"))				a_a = "22";
	
	if(a_a.equals("11"))			name = "�����÷��� �Ϲݽ�";
	else if(a_a.equals("12"))		name = "�����÷��� �⺻��";
	else if(a_a.equals("21"))		name = "��ⷻƮ �Ϲݽ�";
	else if(a_a.equals("22"))		name = "��ⷻƮ �⺻��";
	else					name = "����";
	
	
	
	//������������ 20110105 ���Ǻ����ڷ� ����
	if(jg_w.equals("1")){
		if(a_a.equals("11") || a_a.equals("12")){
			//ins_per = "2";
			ins_per = "1";
		}
	}

	//����������ȣ ���� �� ���� ���
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String jg_b_dt = e_db.getVar_b_dt(String.valueOf(ht.get("JG_CODE")), "jg", rent_dt);
	
	//��������
	ej_bean = e_db.getEstiJgVarCase(String.valueOf(ht.get("JG_CODE")), jg_b_dt);	
	
	ContBaseBean base = new ContBaseBean();
	ContEtcBean cont_etc = new ContEtcBean();
	ContFeeBean fee = new ContFeeBean();
	ContCarBean car = new ContCarBean();
	ContPurBean pur = new ContPurBean();
	ContTaechaBean taecha = new ContTaechaBean();
	
	//���������� ����̵�� ������� ����ϱ�
	if(est_st.equals("2") && !rent_l_cd.equals("")){
		//���⺻����
		base = a_db.getCont(rent_mng_id, rent_l_cd);
		//����Ÿ����
		cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		//�뿩����
		fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_rent_st);
		//�����⺻����
		car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
		//�������
		pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
		if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());
		
		spr_yn 	= cont_etc.getDec_gr();
		a_h 	= car.getCar_ext();
		udt_st 	= pur.getUdt_st();
		ins_dj	= base.getGcp_kd();
		ins_age	= base.getDriving_age();
		if(base.getDriving_age().equals("0")) ins_age = "1";
		if(base.getDriving_age().equals("1")) ins_age = "2";
		ins_per	= cont_etc.getInsur_per();
		insurant= cont_etc.getInsurant();
		gi_yn 	= car.getGi_st();
		car_ja	= String.valueOf(AddUtil.parseDecimal(base.getCar_ja()));
		rent_dt = rs_db.addDay(fee.getRent_end_dt(), 1);
		fee_rent_st = String.valueOf(AddUtil.parseInt(fee_rent_st)+1);
		if(base.getCar_st().equals("1") && fee.getRent_way().equals("1")){
			name = "��ⷻƮ �Ϲݽ�";
			a_a = "21";
		}else if(base.getCar_st().equals("1") && fee.getRent_way().equals("3")){ 
			name = "��ⷻƮ �⺻��";
			a_a = "22";
		}else if(base.getCar_st().equals("3") && fee.getRent_way().equals("1")){ 
			name = "�����÷��� �Ϲݽ�";
			a_a = "11";
		}else if(base.getCar_st().equals("3") && fee.getRent_way().equals("3")){ 
			name = "�����÷��� �⺻��";
			a_a = "12";
		}
	}
	
	//���������� ����������� ���� ����ϱ�
	if(cng_item.equals("taecha") && !rent_l_cd.equals("")){
		//���⺻����
		base = a_db.getCont(rent_mng_id, rent_l_cd);
		//����Ÿ����
		cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		//�뿩����
		fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		//�����⺻����
		car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
		//�������
		pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
		String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
		
		if(taecha_no.equals("")){
			taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
		}
				
		//�����������
		taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
		
		
		if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());
		
		spr_yn 	= cont_etc.getDec_gr();
		
		a_h 	= car.getCar_ext();
		udt_st 	= pur.getUdt_st();
		ins_dj	= base.getGcp_kd();
		ins_age	= base.getDriving_age();
		if(base.getDriving_age().equals("0")) ins_age = "1";
		if(base.getDriving_age().equals("1")) ins_age = "2";
		ins_per	= cont_etc.getInsur_per();
		insurant= cont_etc.getInsurant();
		gi_yn 	= car.getGi_st();
		car_ja	= String.valueOf(AddUtil.parseDecimal(base.getCar_ja()));
		rent_dt = taecha.getCar_rent_st();
		fee_rent_st = "1";
		
		if(rent_dt.equals("")) rent_dt = AddUtil.getDate();
		
		// * �⺻�� 12���� ������ ������ �����Դϴ�.
		
		a_b		= "12";
		
		if(base.getCar_st().equals("1") && fee.getRent_way().equals("1")){
			name = "��ⷻƮ �⺻��";
			a_a = "22";
		}else if(base.getCar_st().equals("1") && fee.getRent_way().equals("3")){ 
			name = "��ⷻƮ �⺻��";
			a_a = "22";
		}else if(base.getCar_st().equals("3") && fee.getRent_way().equals("1")){ 
			name = "�����÷��� �⺻��";
			a_a = "12";
		}else if(base.getCar_st().equals("3") && fee.getRent_way().equals("3")){ 
			name = "�����÷��� �⺻��";
			a_a = "12";
		}
	}
	
	//out.println("ins_per="+ins_per);

%>
<html>
<head>
<title>��������</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	

	//�ѵ�üũ
	function compare(obj){
		var fm = document.form1;
		if(obj == fm.rg_8){
											fm.rg_8_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.o_1.value)) * toInt(fm.rg_8.value) / 100 / 1000) * 1000);	
		}else if(obj == fm.rg_8_amt){
											var rg_8 = parseFloatCipher(toInt(parseDigit(fm.rg_8_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100,2);
											fm.rg_8.value = rg_8;	
		}else if(obj == fm.pp_per){
											fm.pp_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.pp_per.value)/100);						
		}else if(obj == fm.pp_amt){
											fm.pp_per.value = Math.round(toInt(parseDigit(fm.pp_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}else if(obj == fm.gi_per){
											fm.gi_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.gi_per.value)/100);						
		}else if(obj == fm.gi_amt){
											fm.gi_per.value = Math.round(toInt(parseDigit(fm.gi_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}	

	}	
	
	//���ô뿩�����
	function change_g_10(){
		fm = document.form1;
		if(fm.pp_st.checked==false){
			fm.g_10.value = "0";
		}else{
			fm.g_10.value = "3";
		} 
	}
	
	//��������
	function EstiReg(){
		var fm = document.form1;
		
		// ������ ���� 100% ����		2018.01.12
		<%-- var car_o_1 = fm.o_1.value.replace(/,/gi,'');
		var car_rg8_amt = fm.rg_8_amt.value.replace(/,/gi,'');
		var st_val = <%=st%>;
		if(st_val != 1){	// ��������� �� ���� ������ 100% ������ ���� �Ѵ�. 2018.01.17
			if(Number(car_rg8_amt) > Number(car_o_1)){
		    	alert('�������� ������ 100% �̳��� ���� �����մϴ�. \n\n�߰��� �ʱⳳ�Ա� ���θ� ���� ��� ���������� �����Ͻø� �˴ϴ�.');
		    	return;
		    }
		} --%>
		
		if(fm.a_h.value == '')	{ alert('��������� �����Ͻʽÿ�'); return; }	
		
		<%if (!(nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
			<%if ((AddUtil.parseInt(jg_code) > 9000000 && AddUtil.parseInt(jg_code) < 9036000)) {%>
			if (Number(fm.agree_dist.value.replace(/,/g,"")) < 5000 || Number(fm.agree_dist.value.replace(/,/g,"")) > 60000) {
	    		alert("���� ��������Ÿ� �ִ밪�� �ʰ��Ͽ� �Է��Ͽ����ϴ�.\n\n* ������ ���� ��������Ÿ� �ִ밪\n- ��Ÿ���� �� �� Ʈ�� : 5,000 ~ 60,000km/�� ����\n- �׿����� : 5,000 ~ 50,000km/�� ����");
	    		return;
	    	}
			<%} else {%>
			if (Number(fm.agree_dist.value.replace(/,/g,"")) < 5000 || Number(fm.agree_dist.value.replace(/,/g,"")) > 50000) {
	    		alert("���� ��������Ÿ� �ִ밪�� �ʰ��Ͽ� �Է��Ͽ����ϴ�.\n\n* ������ ���� ��������Ÿ� �ִ밪\n- ��Ÿ���� �� �� Ʈ�� : 5,000 ~ 60,000km/�� ����\n- �׿����� : 5,000 ~ 50,000km/�� ����");
	    		return;
	    	}
			<%}%>
		<%}%>
		
		//20150414 �빰5���϶� �޽���
		if(fm.ins_dj.value == '3'){
			alert('�빰 �����ѵ� 5����� ��༭ �ۼ����� ����ī�������տ� �̸� ������ �޾ƾ� �մϴ�.');			
		}
		
		//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
		/*
		if(fm.a_a.value == '12'){
			if(fm.insurant.value == '2' && fm.ins_per.value != '2'){
				alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('�������� ���� �����⺻�ĸ� �����մϴ�.');
				return;
			}			
		}	
		*/	
		
		<%if(ej_bean.getJg_w().equals("1")){%>
		if(parseDigit(fm.car_ja.value) != '500000'){
      		alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      	}
		<%}else{%>
		if(parseDigit(fm.car_ja.value) == '300000' || parseDigit(fm.car_ja.value) == '200000' || parseDigit(fm.car_ja.value) == '100000'){
      	}else{
      		alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      	}
		<%}%>
		
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		if(!(fm.doc_type.value == '1' || fm.doc_type.value == '2') && fm.com_emp_yn.value == 'Y'){
			fm.com_emp_yn.value = 'N';
		}
		<%}%>
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return; }
		fm.action = 'esti_mng_i_20090901_a.jsp';
		fm.target = "_self";
		fm.submit();
	}		

	//��������
	function EstiRegAuto(){
		var fm = document.form1;
		
		<%if (vt_chk1_size > 0) {%>
		alert('[<%=cust_nm%>]�� �ҷ������� ��ϵ� ���� �������� ���θ� Ȯ�� �� �����Ͻñ� �ٶ��ϴ�. ������������ Ȯ���ϰ� ó���ϼ���.'); 
		return;
		<%}%>

		<%if (ej_bean.getJg_w().equals("1")) {%>
		if(parseDigit(fm.car_ja.value) != '500000'){
      		alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      	}
		<%} else {%>
		if(parseDigit(fm.car_ja.value) == '300000' || parseDigit(fm.car_ja.value) == '200000' || parseDigit(fm.car_ja.value) == '100000'){
		}else{
	    	alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
	    }
		<%}%>
		
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		if(!(fm.doc_type.value == '1' || fm.doc_type.value == '2') && fm.com_emp_yn.value == 'Y'){
			fm.com_emp_yn.value = 'N';
		}
		<%}%>
		
		fm.action = 'esti_mng_i_20090901_a.jsp';
		fm.target = "_self";
		fm.submit();
	}
	
	//�������������뺸�� ���Կ���
	function SetComEmpYn(){
		var fm = document.form1;
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		if(fm.doc_type.value == '1'){
			fm.com_emp_yn.value = 'Y';
		}else{
			fm.com_emp_yn.value = 'N';
		}
		<%}%>
	}

	//�ҷ��� 
	function view_badcust(est_nm, lic_no, est_tel, est_o_tel, est_mail, est_fax, est_comp_tel, est_comp_cel, driver_cell)
	{
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_i_20090901.jsp&est_nm='+est_nm+'&lic_no='+lic_no+'&est_tel='+est_tel+'&est_o_tel='+est_o_tel+'&est_mail='+est_mail+'&est_fax='+est_fax+'&est_comp_tel='+est_comp_tel+'&est_comp_cel='+est_comp_cel+'&driver_cell='+driver_cell, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}		

//-->
</script>
</head>
<body leftmargin="15" onLoad="init();" >
<table border=0 cellspacing=0 cellpadding=0 width=650>
  <form action="" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
    <input type="hidden" name="br_id" 			value="<%=br_id%>">
    <input type="hidden" name="user_id" 		value="<%=user_id%>">
    <input type="hidden" name="car_mng_id" 		value="<%=car_mng_id%>">
    <input type="hidden" name="esti_nm"			value="<%=esti_nm%>">
    <input type="hidden" name="a_a"			value="<%=a_a%>">    
    <input type="hidden" name="rent_st"			value="<%=rent_st%>">	
    <input type="hidden" name="lpg_kit" 		value="<%=lpg_kit%>">
    <input type="hidden" name="o_1"			value="<%=o_1%>">
    
    <input type="hidden" name="st" 			value="<%=st%>">	
    <input type="hidden" name="from_page" 		value="<%=from_page%>">	
    <input type="hidden" name="cust_nm" 		value="<%=cust_nm%>">		
    <input type="hidden" name="damdang_id" 		value="<%=damdang_id%>">		
    <input type="hidden" name="cust_tel" 		value="<%=cust_tel%>">		
    <input type="hidden" name="cust_fax" 		value="<%=cust_fax%>">		
    <input type="hidden" name="cust_email" 		value="<%=cust_email%>">		
    <input type="hidden" name="mgr_nm" 			value="<%=mgr_nm%>">		
    <input type="hidden" name="cust_ssn" 		value="<%=cust_ssn%>">		
    <input type="hidden" name="udt_st" 			value="<%=udt_st%>">		
    <input type='hidden' name="est_st"				value="<%=est_st%>">      
    <input type='hidden' name="fee_opt_amt"		value="<%=fee_opt_amt%>">        
    <input type="hidden" name="rent_mng_id"	value="<%=rent_mng_id%>">
    <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">		
    <input type="hidden" name="fee_rent_st"		value="<%=fee_rent_st%>">		
    <input type="hidden" name="cng_item"		value="<%=cng_item%>">
    <input type="hidden" name="br_to_st"		value="<%=br_to_st%>">
    <input type="hidden" name="br_to"			value="<%=br_to%>">
    <input type="hidden" name="br_from"		value="<%=br_from%>">
			
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�縮�� > �������� > <span class=style5><%=rent_l_cd%> ��������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td colspan="2" align=right><span class=style3>* �Ʒ� ������ �Է��ϰ�, ������ ���ñ� �ٶ��ϴ�.</span>&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <%if (nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("��������������", user_id)) {%>
    <tr>
        <td>�� �������� : <input type="text" name="rent_dt" value="<%=AddUtil.getDate()%>" size="10" class=text></td>
    </tr>
    <%}else{ %>
    <input type="hidden" name="rent_dt"			value="<%=rent_dt%>">    
    <%} %>
    <tr> 
        <td colspan="2"><font size="+1">
            <div align="center"><b><%if(st.equals("1")){ //���������%>���������<%}else{%>[ <%= name %> ]<%}%></b></div></font></td>
    </tr>
    <%if(vt_chk1_size>0){%>
    <tr> 
        <td colspan="2">�� [<%=cust_nm%>]�� �ҷ������� ��ϵ� ���� �������� ���θ� Ȯ�� �� �����Ͻñ� �ٶ��ϴ�.
        	<input type="button" class="button" id="bad_cust" value='���뺸��' onclick="javascript:view_badcust('<%=cust_nm%>', '', '<%=cust_tel%>', '', '<%=cust_email%>', '<%=cust_fax%>', '', '', '');">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">	
        </td>
    </tr>
        
    <%}%>          
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td colspan="2" class=title>&nbsp;</td>
                    <td width="40%" class=title>������</td>
                    <td width="40%" class=title>������</td>
                    <!-- <td class=title>������</td>
                    <td width="358" class=title>������</td> -->
                </tr>
				<%if(est_st.equals("2") && !st.equals("1")){%>
                <tr> 
                    <td colspan="2" class=title>�뿩�Ⱓ</td>
                    <td>&nbsp;-</td>
                    <td>
                      <input type="text" name="a_b" class=num size="4" value="12">
                      ����</td>
                </tr>	
				<%}else{%>			
				<input type="hidden" name="a_b" value="<%=a_b%>">
				<%}%>
                <tr> 
                    <td colspan="2" class=title>LPGŰƮ</td>
                    <td>&nbsp;
                      <%if(lpg_kit.equals("Y")){
      						out.print("LPG����(���)");
        				}else{
        					if(a_e.equals("301")||a_e.equals("302")){
        						out.print("LPG����");
        					}else{
        						out.print("������");
        					}
        				}  %>
                    </td>
                    <td><select name="lpg_yn">
                        <% if(lpg_kit.equals("Y")){ %>
                        <option value="2" selected>��������</option>
                        <% }else{
        					if(a_e.equals("301")||a_e.equals("302")){ %>
                        <option value="0" selected>����Ұ�</option>
                        <%		}else{ %>
                        <option value="0" selected>������</option>
                        <option value="1" >�߰�����</option>
                        <%		}
        			   } %>
                      </select></td>
                </tr>
                <%
              		int b_agree_dist =0;
              		//int agree_dist   =0;
              		int agree_dist = request.getParameter("agree_dist")==null?0:AddUtil.parseDigit(request.getParameter("agree_dist"));
              	
           				b_agree_dist = 30000;
           				
           				//20220415 ��������Ÿ� 23000
           				if(AddUtil.parseInt(AddUtil.replace(rent_dt,"-","")) >= 20220415){
           					b_agree_dist = 23000;
           				}
           		
									//���� +5000
									if(ej_bean.getJg_b().equals("1")){
										b_agree_dist = b_agree_dist+5000;
									}				
									//LPG +10000 -> 20190418 +5000
									if(ej_bean.getJg_b().equals("2")){
										b_agree_dist = b_agree_dist+5000;				
									}
			
									if(agree_dist==0)	agree_dist = b_agree_dist;
		
              %>                         
                <tr> 
                    <td width="22" rowspan="2" class=title>��<br>��<br>��<br>��</td>
                    <td class=title width="75">ǥ�ؾ���<br>����Ÿ�</td>
                    <td width="182">&nbsp;-</td>
                    <td><input type="text" name="b_agree_dist" class=whitenum size="10" value='<%=AddUtil.parseDecimal(b_agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/�� </td>
                </tr>       
                <tr> 
                    <td class=title width="75">�������<br>����Ÿ�</td>
                    <td>&nbsp;-</td>
                    <td><input type="text" name="agree_dist" class=num size="10" value='<%=AddUtil.parseDecimal(agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/��
                        <%if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn'>
	                        	<option value='0'>ȯ�޴뿩�� ����</option>
	                        	<option value='1'>������</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
                    </td>
                </tr> 
                <tr id="tr_o13" style="display:''"> 
                    <td colspan="2" class=title>�����ܰ��� </td>
                    <td>&nbsp;-
					<!--������ 
                          <input type="text" name="o_13" size="3" class=whitetext  onblur="javascript:compare(this)" value="">
                          %--></td>
                    <td>������ 
                          <input type="text" name="ro_13" size="3" class=text  onblur="javascript:compare(this)" value="">
                          % (���Է½� ���� �ִ��ܰ����� ������)
						  </td>
                </tr>
                <!--
                <tr> 
                    <td colspan="2" class=title>���Կɼ� </td>
                    <td>&nbsp;-</td>
                    <td><select name="opt_chk">
                      <option value="0" >�̺ο�</option>
                      <option value="1" <%if(a_a.equals("12") || a_a.equals("22")){%>selected<%}%>>�ο�</option>
                    </select></td>
                </tr>
                -->                
                <tr> 
                    <td colspan="2" class=title>������<br> </td>
                    <td>&nbsp;������ 
                      <input type="text" name="g_8" class=whitenum size="4" onBlur="javascript:compare(this)" value="<%=rg_8%>">
                      %</td>
                    <td>
					  <%if(st.equals("1")){ //���������%>					   
					   ������ 
                      <input type="text" name="rg_8" class=num size="4" onBlur="javascript:compare(this)" value="">
                      % || 
						���뺸���ݾ� 
                      <input type="text" name="rg_8_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      �� <br><!-- (���� ���� ���� ������ �ݾ��� �Է��� �ּ���) -->
                      <!-- ����������� ���� ����(2018.03.29) -->
                      (��������� ���� ������ ���� ������ �ݾ��� �Է����ּ���)
					  <%}else{
					  		if(est_st.equals("2") || cng_item.equals("taecha")){%>
					      <input type="hidden" name="rg_8" value="">
						���뺸���ݾ� 
                      <input type="text" name="rg_8_amt" class=num value="<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>" size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      �� 				
					  <%	}else{%>	
					  ������ 
                      <input type="text" name="rg_8" class=num size="4" onBlur="javascript:compare(this)" value="">
                      % || ���뺸���ݾ� 
                      <input type="text" name="rg_8_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      �� 
					  <%	}%>					  
					  <%}%>
					  </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>������<br> </td>
                    <td>&nbsp;-</td>
                    <td>������ 
                      <input type="text" name="pp_per" class=num size="4" onBlur="javascript:compare(this)">
                      % || ���뼱���ݾ� 
                      <input type="text" name="pp_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      ��
					  <%if(st.equals("1")){ //���������%>
					  <br><!-- (���� ���� ���� ������ �ݾ��� �Է��� �ּ���) -->
					  		<!-- ����������� ���� ����(2018.03.29) -->
					  		(��������� ���� ������ ���� ������ �ݾ��� �Է�, ��������� ������ �� ��� �������� ���������� ȯ���Ͽ� ����)
					  <%}%></td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>���ô뿩�� </td>
                    <td>&nbsp;3����ġ �뿩�� ����</td>
                    <td><font color="#666666"> 
                      <input type="checkbox" name="pp_st" value="1" <% if(pp_st.equals("1") && !st.equals("1")) out.print("checked"); %> <%if(st.equals("1")){ //���������%>onclick="return false;"<%}else{%>onClick="javascript:change_g_10();"<%}%>>					  
                      <input type="text" name="g_10" class=num size="2" value="<% if(pp_st.equals("1") && !st.equals("1")) out.print("3"); %>" <%if(st.equals("1")){ //���������%>readonly<%}%>>
                      ����ġ �뿩�� ����
					  </font>
					  <%if(st.equals("1")){ //���������%>
					  <br>|| ���밳�ô뿩�� <input type="text" name="ifee_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
					  <br><!-- (���� ���� ���� ���ô뿩�� �ݾ��� �Է��� �ּ���) -->
					  		<!-- ����������� ���� ����(2018.03.29) -->
					  		(��������� ���� ������ ���� ���ô뿩�� �ݾ��� �Է�, ��������� ������ �� ��� ���ô뿩��� ���������� ȯ���Ͽ� ����)
					  <%}%>
					  </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>�ʱⳳ�Ա�<br>�ȳ�����</td>
                    <td>&nbsp;�ʱⳳ�Ա��� ������ �ſ뵵�� ���� �ɻ�������� ������ �� �ֽ��ϴ�.</td>
                    <td>
                    	<input type="radio" name="pp_ment_yn" value="Y">
                      ǥ��
                      <input type="radio" name="pp_ment_yn" value="N" checked>
                      ��ǥ��
					          </td>
                </tr>    
                <tr <%if (a_a.equals("12") || a_a.equals("11")) {%>style="display: none;"<%}%>> 
                    <td colspan="2" class=title>�������� </td>
                    <td>&nbsp;����</td>
                    <td><select name="gi_yn">
                            <option value="0" <%if(gi_yn.equals("0")||gi_yn.equals(""))%>selected<%%>>����</option>
                            <option value="1" <%if(gi_yn.equals("1"))%>selected<%%>>����</option>
                          </select>
                          &nbsp;
                          ������ 
                      <input type="text" name="gi_per" class=num size="4" onBlur="javascript:compare(this)" value="">
                      % || ���밡�Աݾ� 
                      <input type="text" name="gi_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      �� 
                    </td>
                </tr>                
                <tr> 
                    <td colspan="2" class=title>������� </td>
                    <td>&nbsp;<select name="f_udt_st" onchange="javascript:set_car_ext()">
                        <option value="1" <%if(udt_st.equals("1") || acar_br.equals("S1"))%>selected<%%>>���ﺻ��</option>
                        <option value="2" <%if(udt_st.equals("2") || acar_br.equals("B1"))%>selected<%%>>�λ�����</option>
                        <option value="3" <%if(udt_st.equals("3") || acar_br.equals("D1"))%>selected<%%>>��������</option>
                        <option value="5" <%if(udt_st.equals("5") || acar_br.equals("G1"))%>selected<%%>>�뱸����</option>
                        <option value="6" <%if(udt_st.equals("6") || acar_br.equals("J1"))%>selected<%%>>��������</option>
                        <option value="4" <%if(udt_st.equals("4"))%>selected<%%>>��</option>
                      </select> (�����μ�����)</td>
                    <td><select name="a_h">
                        <option value="1" <%if(a_h.equals("1"))%>selected<%%>>����</option>
                        <option value="2" <%if(a_h.equals("2"))%>selected<%%>>���</option>
                        <option value="3" <%if(a_h.equals("3"))%>selected<%%>>�λ�</option>
                        <option value="4" <%if(a_h.equals("4"))%>selected<%%>>�泲</option>
                        <option value="5" <%if(a_h.equals("5"))%>selected<%%>>����</option>
						            <option value="7" <%if(a_h.equals("7")||a_h.equals(""))%>selected<%%>>��õ</option>
						            <option value="9" <%if(a_h.equals("9"))%>selected<%%>>����</option>
                      </select></td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>�ſ��� </td>
                    <td>&nbsp;�췮���</td>
                    <td><select name="spr_yn">
                  			<option value='3' <%if(spr_yn.equals("3"))%>selected<%%>>�ż�����</option>
                  			<option value='0' <%if(spr_yn.equals("0"))%>selected<%%>>�Ϲݰ�</option>
                  			<option value='1' <%if(spr_yn.equals("1")||spr_yn.equals(""))%>selected<%%>>�췮���</option>
                  			<option value='2' <%if(spr_yn.equals("2"))%>selected<%%>>�ʿ췮���</option>
                      </select></td>
                </tr>
                <tr <%if (a_a.equals("12") || a_a.equals("11")) {%>style="display: none;"<%}%>>
                	<td colspan="2" class=title>���������<br>������</td>
                	<td>&nbsp;������ǥ��</td>
                	<td>
                		<select name="gi_grade" id="gi_grade">
               				<option value="" selected>������ǥ��</option>
                			<option value="1">1���</option>
                			<option value="2">2���</option>
                			<option value="3">3���</option>
                			<option value="4">4���</option>
                			<option value="5">5���</option>
                			<option value="6">6���</option>
                			<option value="7">7���</option>
                		</select>
                	</td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>�ʿ伭��ǥ��</td>
                    <td>&nbsp;-</td>
                    <td><select name="doc_type" <%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>onChange="javascript:SetComEmpYn()"<%}%>>
                            <option value=""  <%if(doc_type.equals("") && !st.equals("3")){%>selected<%}%>>����</option>					                            
                            <option value="1" <%if(doc_type.equals("1") || (doc_type.equals("") && st.equals("3"))){%>selected<%}%>>���ΰ�</option><!--����������-->
                            <option value="2" <%if(doc_type.equals("2")){%>selected<%}%>>���λ����</option>
                            <option value="3" <%if(doc_type.equals("3")){%>selected<%}%>>����</option>
                          </select></td>
                </tr>                  
                <tr> 
                    <td width="22" rowspan="4" class=title>����</td>
                    <td class=title width="75">�빰/�ڼ�</td>
                    <td width="182">&nbsp;1���</td>
                    <td><select name="ins_dj" >
                        <%-- <option value="1" <%if(ins_dj.equals("1"))%>selected<%%>>5õ����/5õ����</option> --%>
                        <option value="2" <%if(ins_dj.equals("2")||ins_dj.equals(""))%>selected<%%>>1���/1���</option>
                        <option value="4" <%if(ins_dj.equals("4"))%>selected<%%>>2���/1���</option>
						<option value="8" <%if(ins_dj.equals("8"))%>selected<%%>>3���/1���</option>
						<option value="3" <%if(ins_dj.equals("3"))%>selected<%%>>5���/1���</option>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title width="75">�����ڿ���</td>
                    <td>&nbsp;��26���̻�</td>
                    <td><select name="ins_age">
                        <option value="1" <%if(ins_age.equals("1")||ins_age.equals(""))%>selected<%%>>��26���̻�</option>
                        <%if(a_a.equals("11")||a_a.equals("12")){%>
                        <option value="3" <%if(ins_age.equals("3"))%>selected<%%>>��24���̻�</option>
                        <%}%>
                        <option value="2" <%if(ins_age.equals("2"))%>selected<%%>>��21���̻�</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class=title>����⵿</td>
                    <td>&nbsp;�̰���</td>
                    <td><select name="ins_good">
                            <option value="0" selected>�̰���</option>
                            <option value="1">����</option>
                          </select></td>
                </tr>
                <!--
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;�Ƹ���ī</td>
                    <td><select name="insurant">
                            <option value="1" <%if(insurant.equals("1")||insurant.equals(""))%>selected<%%>>�Ƹ���ī</option>
                            <%if(a_a.equals("12")){%>
                            <option value="2" <%if(insurant.equals("2"))%>selected<%%>>��</option>
                            <%}%>
                          </select>
                          </td>
                </tr>
                -->
                <tr> 
                    <td class=title>�Ǻ�����</td>
                    <td>&nbsp;�Ƹ���ī</td>
                    <td><select name="ins_per">
                            <option value="1" <%if(ins_per.equals("1")||ins_per.equals(""))%>selected<%%>>�Ƹ���ī(��������)</option>
                            <%-- <option value="2" <%if(ins_per.equals("2"))%>selected<%%> disabled>��(���������)</option> --%>
                          </select>
                          </td>
                </tr>
                <%if(!st.equals("1") && ((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000))){%>
                <tr> 
                    <td colspan="2" class=title>���������뺸��</td>
                    <td>&nbsp;-</td>
                    <td><select name="com_emp_yn">
                            <option value="N" <%if(com_emp_yn.equals("N"))%>selected<%%>>�̰���</option>
                            <option value="Y" <%if(com_emp_yn.equals("Y") || (doc_type.equals("") && st.equals("3")))%>selected<%%>>����</option>
                          </select></td>
                </tr>               
                <%}else{%>  
                <input type="hidden" name="com_emp_yn"		value="<%=com_emp_yn%>">
                <%}%>
                <tr> 
                    <td colspan="2" class=title>������å��</td>
                    <td>&nbsp;<input type="text" name="car_ja2" class=whitenum size="10" value="300,000" onBlur='javascript:this.value=parseDecimal(this.value);'>�� </td>
                    <td><input type="text" name="car_ja" class=num size="10" value="<%=car_ja%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                          �� </td>
                </tr>
                <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20150217){%>                         
                <tr>                     
                    <td class=title colspan="2" >��ǰ</td>
                    <td width="182">&nbsp;-</td>
                    <td>
                    	<input type="checkbox" name="tint_b_yn"   value="Y" > 2ä�� ���ڽ�<br>
                      	<input type="checkbox" name="tint_s_yn" value="Y" > ���� ����<br>
                      	<input type="checkbox" name="tint_n_yn" value="Y" > ��ġ�� ������̼�<br>
                      	<input type="checkbox" name="tint_eb_yn" value="Y" > �̵��� ������(������):�������� �������� ����
                      </td>
                </tr>       
                <%}%>    
                <tr> 
                    <td colspan="2" class=title>�뿩��D/C </td>
                    <td>&nbsp;-</td>
                    <td>�뿩���� 
                          <input type="text" name="fee_dc_per" size="4" class=text>
                          %</td>
                </tr>

                <%if(st.equals("4")){//�����������%>           
                <input type="hidden" name="accid_serv_zero" value="Y">
                <input type="hidden" name="accid_serv_amt1" value="0">
                <input type="hidden" name="accid_serv_amt2" value="0">
                <%}else{%>
                <tr> 
                    <td colspan="2" class=title>��������1</td>
                    <td>&nbsp;-</td>
                    <td><%=AddUtil.parseDecimal(String.valueOf(ht.get("ACCID_SERV_AMT1")))%>��<input type="hidden" name="accid_serv_amt1" value="<%=ht.get("ACCID_SERV_AMT1")%>"></td>
                </tr>                
                <tr> 
                    <td colspan="2" class=title>��������2</td>
                    <td>&nbsp;-</td>
                    <td><%=AddUtil.parseDecimal(String.valueOf(ht.get("ACCID_SERV_AMT2")))%>��<input type="hidden" name="accid_serv_amt2" value="<%=ht.get("ACCID_SERV_AMT2")%>"></td>
                </tr>     
                <input type="hidden" name="accid_serv_zero" value="N">
                <%}%>
            </table>
        </td>
    </tr>
    <tr> 
      <td align=center colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td align=center colspan="2"><a href="javascript:EstiReg();"><img src=/acar/images/center/button_est.gif border=0 align=absmiddle></a> 
      </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no2" width="0" height="0" frameborder="0" noresize></iframe>
<script>
<!--	
	var fm = document.form1;
	
	<%if(!est_st.equals("2") && !cng_item.equals("taecha")){%>
	
	<%	if(!rg_8.equals("0")){%>
	fm.rg_8.value 		= <%=rg_8%>;
	fm.rg_8_amt.value 	= parseDecimal(Math.round(<%=o_1%>*<%=rg_8%> / 100 / 1000) * 1000);
	<%	}%>
		
	if(toInt(<%=String.valueOf(ht.get("CAR_COMP_ID"))%>) > 5){
		fm.car_ja2.value 	= '500,000';
		fm.car_ja.value 	= '500,000';
		//fm.ins_per.value	= '2';
		fm.ins_per.value	= '1';
	}
	
	set_car_ext();
		
	<%}%>
	


	function set_car_ext(){
			
		//�ǵ������		
		var udt_st = fm.f_udt_st.value;
		var br_id = '<%=acar_br%>';
		
		
		if(udt_st == ''){
			if(br_id =='S1') udt_st = '1';
			if(br_id =='B1') udt_st = '2';
			if(br_id =='D1') udt_st = '3';
		}
		
		var a_h = 1;
		var a_e = <%=a_e%>;
		var a_a = <%=a_a.substring(0,1)%>;
		var au28 = 0;
		var av28 = 0;
		if(a_e == 402 || a_e == 501 || a_e == 502 || a_e == 601 || a_e == 602) au28 = 1;//7-9�ν�2000cc�ʰ�¤����
		if(a_e == 104 || a_e == 105 || a_e == 106 || a_e == 107 || a_e == 201) av28 = 1;//�����¿뿩��
		//[20110108] ��������(��¿�,����)
		//if(a_e == 100 || a_e == 101 || a_e == 702 || a_e == 802) av28 = 1; 				
		if(a_a==1){//����	
			if(av28==1){
				a_h = 4;	
			}else{
				if(au28==1){
					if(udt_st == '1') 		a_h = 1; //�����μ��϶� ����
					else if(udt_st == '2') 	a_h = 4; //�λ��μ��ϴ� �泲
					else if(udt_st == '3') 	a_h = 4; //�����μ��϶� �泲
					else if(udt_st == '4') 	a_h = 1; //���μ��ϴ� ����
				}else{
					if(udt_st == '1') 		a_h = 2; //�����μ��϶� ���
					else if(udt_st == '2') 	a_h = 4; //�λ��μ��ϴ� �泲
					else if(udt_st == '3') 	a_h = 4; //�����μ��϶� �泲
					else if(udt_st == '4') 	a_h = 1; //���μ��ϴ� ����
				}
			}	
		}else{//��Ʈ
			if(udt_st == '1') 				a_h = 2; //�����μ��϶� ���
			else if(udt_st == '2') 			a_h = 4; //�λ��μ��ϴ� �泲
			else if(udt_st == '3') 			a_h = 4; //�����μ��϶� �泲
			else if(udt_st == '4') 			a_h = 2; //���μ��ϴ� ���
		}
		//��õ���� �߰��� ����
		if(udt_st == '1') 					a_h = 7; //�����μ��϶� ��õ
		else if(udt_st == '2') 			a_h = 4; //�λ��μ��ϴ� �泲
		else if(udt_st == '3') 			a_h = 4; //�����μ��϶� �泲
		else if(udt_st == '4') 			a_h = 7; //���μ��ϴ� ���
		
		
		fm.a_h.value 	= a_h;
		fm.udt_st.value = udt_st;
	}	
	
	<%if(st.equals("2")){ //�⺻������ �ٷ� ���%>
	EstiRegAuto()
	<%}%>
//-->
</script>	
</body>
</html>
