<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.car_register.*, acar.cont.*, acar.car_mst.*, acar.insur.*, acar.estimate_mng.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ins"     class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="rs_db"   class="acar.res_search.ResSearchDatabase" scope="page"/>
<jsp:useBean id="a_db"    class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�������� ũ���� ��� �Ǻ�		2018.03.05
	String ua = request.getHeader("User-Agent");
	boolean isChrome = false;
	if(ua.contains("Chrome")){
		isChrome = true;
	}

	//�ڵ������ȭ�� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd	 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	// �������� > ������ϰ��� > �ڵ����������� ���� ���� �������� > ������� > ��ǰ�غ��Ȳ���� ���� ��츦 �������� ���� �߰�		2017. 11. 28
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	// ��ǰ�غ��Ȳ���� ������� ��� ��ư���� �̵��� ��� �μ����� �Ű�ü ������ �̵�			2017. 12. 8
	String udt_st = request.getParameter("udt_st")==null?"":request.getParameter("udt_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//�ڵ���ȸ��&����&�ڵ�����
	CarMstBean mst = a_cmb.getCarEtcNmCase(rent_mng_id, rent_l_cd);
	
	//��������
	InsDatabase ai_db = InsDatabase.getInstance();
	String ins_st = ai_db.getInsSt(car_mng_id);
	ins = ai_db.getIns(car_mng_id, ins_st);
	ins_st = ins_st ==null?"0":ins_st;
	
	
	//�ڵ���� �ʿ�------------------------------------------------------------------------------------------
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//��������
	cm_bean = a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
  	//�����������
  	CodeBean[] code32 = c_db.getCodeAll3("0032");
  	int code32_size = code32.length;
  	
	String var_seq = "";
	String a_a = "";
	String a_e = cm_bean.getS_st();
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//���ĺ���
	Hashtable sik 		= e_db.getEstiSikVar();
	Hashtable s_e 		= (Hashtable)sik.get("s_e");		//��ϼ�
	Hashtable s_g 		= (Hashtable)sik.get("s_g");		//��漼
	Hashtable s_h 		= (Hashtable)sik.get("s_h");		//ä�Ǹ��Ծ�
	Hashtable s_j 		= (Hashtable)sik.get("s_j");		//ä�����κ��
	
	//��ϼ� �ڵ� ��� �߰�(2018.01.05)
	long tax_amt2 = 0;
	
	//��漼 �ڵ� ��� �߰�(2017.12.01)
	long tax_amt3 = 0;
	if(rent_l_cd.length() > 0){
		Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);
		if(base.getCar_gu().equals("1")){	// 1.���� ����
			
			//��ϼ� ����(/fms2/car_pur/rent_board_excel.jsp ���Ͽ� �ִ� ��ϼ� ���� ����, ��ǰ�غ��Ȳ ��漼���Ǻ��濡 ����ȸ�簡 �ִ� ��쿡 �������ȭ�鿡�� ��ϼ��� �ݾ��� ����. 2018.01.05)
			if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
				
	      	}else{
	        	if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//ȭ��
	        		if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
	        			
	        		}else{
	        			tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX3")));
					}
				}else{
					if(String.valueOf(ht.get("CAR_ST")).equals("��Ʈ")){//��Ʈ
						tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX2")));
					}else{//����
						if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
							//���� ���� 50���� �氨
							tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX2")));
						}else{
							tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX5")));
						}
					}
				}
			}
			
			// ----------------------------------------------------------------------------------------------------------------------------------------------------------���� start
			if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
				if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//ȭ��
					if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
						
					}else{
						tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX5")));
					}
				}else{
					if(String.valueOf(ht.get("CAR_ST")).equals("��Ʈ")){//��Ʈ
						tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
					}else{//����
						if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
							//���� ���� 50���� �氨
							tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
						}else{
							tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX7")));
						}
					}
				}
			}else{
				if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
					//���� ���� 50���� �氨
					tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
				}else{
					tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
				}
			}
			
			//ģȯ���� ��漼 ����
			if(!String.valueOf(ht.get("JG_G_7")).equals("")){
				if(String.valueOf(ht.get("JG_G_7")).equals("1") || String.valueOf(ht.get("JG_G_7")).equals("2")){
					//20200101 ���̺긮�� ��漼 �������� �Ϻ� ��� 1400000->900000
					//20210101 ���̺긮�� ��漼 �������� �Ϻ� ���  900000->400000
					tax_amt3 = tax_amt3 - 400000;
				}else if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("JG_G_7")).equals("4")){
					tax_amt3 = tax_amt3 - 1400000;
				}
				if(tax_amt3 < 0)	tax_amt3 = 0;
			}
			//���� ���� 50���� �氨-> 2022�� 75����
			if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
				if(AddUtil.parseInt(String.valueOf(ht.get("DLV_DT"))) >= 20220101){
					if(tax_amt3<750000){
						tax_amt3 = 0;
					}else{
						tax_amt3 = tax_amt3-750000;
					}
				}else{
					if(tax_amt3<500000){
						tax_amt3 = 0;
					}else{
						tax_amt3 = tax_amt3-500000;
					}
				}				
			}
			
			// ----------------------------------------------------------------------------------------------------------------------------------------------------------���� end
		}else {	// 0.�縮��, 2.�߰���, 3.����Ʈ ����
			
			// ----------------------------------------------------------------------------------------------------------------------------------------------------------�縮��,�߰���,����Ʈ start
			if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
				if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//ȭ��
					if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
						
					}else{
						tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX5")));
					}
				}else{
					if(String.valueOf(ht.get("CAR_ST")).equals("��Ʈ")){//��Ʈ
						tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
					}else{//����
						if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
							tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
						}else{
							tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX7")));
						}
					}
				}
			}else{
				if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
					tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
				}else{
					tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
				}
			}
			//ģȯ���� ��漼 ����
			if(!String.valueOf(ht.get("JG_G_7")).equals("")){
				if(String.valueOf(ht.get("JG_G_7")).equals("1") || String.valueOf(ht.get("JG_G_7")).equals("2")){
					//20200101 ���̺긮�� ��漼 �������� �Ϻ� ��� 1400000->900000
					//20210101 ���̺긮�� ��漼 �������� �Ϻ� ���  900000->400000
					tax_amt3 = tax_amt3 - 400000;
				}else if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("JG_G_7")).equals("4")){
					tax_amt3 = tax_amt3 - 1400000;
				}
				if(tax_amt3 < 0)	tax_amt3 = 0;
			}			
			//���� ���� 50���� �氨-> 2022�� 75����
			if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
				if(AddUtil.parseInt(String.valueOf(ht.get("DLV_DT"))) >= 20220101){
					if(tax_amt3<750000){
						tax_amt3 = 0;
					}else{
						tax_amt3 = tax_amt3-750000;
					}
				}else{
					if(tax_amt3<500000){
						tax_amt3 = 0;
					}else{
						tax_amt3 = tax_amt3-500000;
					}
				}
			}			
			// ----------------------------------------------------------------------------------------------------------------------------------------------------------�縮��,�߰���,����Ʈ end
		}

	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//����ϱ�
	function CarRegReg(){
		var theForm = document.CarRegForm;	
		if(!CheckInputField()){				return;	}		
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "i";
		theForm.action="./register_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}
	//�����ϱ�
	function CarRegUp(){
		var theForm = document.CarRegForm;	
		if(!CheckInputField()){			return;	}	
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "u";
		theForm.action = "./register_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}
	//����ȭ��
	function CarRegUpDisp(){
		var theForm = document.CarRegForm;	
		theForm.cmd.value = "udp";
		theForm.action = "./register_frame.jsp";
		theForm.target = "d_content"
		theForm.submit();
	}

	//�����˾�
	function OpenIns(){
		var theForm = document.CarRegForm;
		if(theForm.cmd.value=='id'){	alert("���ȭ���� ����� �ϴ� �޴��� ����Ͻʽÿ�.");	return;	}						
		if(car_mng_id == ''){ 			alert('��������� ���� �Ͻʽÿ�.'); 					return; }
		<%if(ins.getCar_mng_id().equals("")){%>
		var url = "/acar/ins_reg/ins_reg_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&c_id=<%=car_mng_id%>";
		<%}else{%>		
		var url = "/acar/ins_mng/ins_u_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&c_id=<%=car_mng_id%>&ins_st=<%=ins_st%>";		
		<%}%>				
		window.open(url, "Ins", "left=100, top=50, width=850, height=610, scrollbars=no");			
	}

	//�ϴܸ޴� ����
	function FootWin(arg){
		var theForm = document.CarRegForm;
		if(theForm.cmd.value=='id'){	alert("���ȭ���� ����� �ϴ� �޴��� ����Ͻʽÿ�.");	return;	}	
		
		if(arg == 'HIS'){			theForm.action = "register_his_id.jsp";
		}else if(arg == 'PUR'){		theForm.action = "register_pur_id.jsp";				
		}else if(arg == 'SER'){		theForm.action = "register_service_id.jsp";		
		}else if(arg == 'CHA'){		theForm.action = "register_change_id.jsp";	
		}else if(arg == 'ACQ'){		theForm.action = "register_acquisition_id.jsp";
		}else if(arg == 'MORT'){	theForm.action = "register_mort_id.jsp";
		}else if(arg == 'KEY'){		theForm.action = "register_key_id.jsp";				
		}
		
		theForm.target = "c_foot";
		theForm.submit();
	}

	function ChangeMortDT(){
		var theForm = document.CarRegForm;
		theForm.mort_dt.value = ChangeDate(theForm.mort_dt.value);
	}

	function CheckInputField(){
		var theForm = document.CarRegForm;
		
		if(theForm.car_no.value.indexOf("GJ") != -1 || theForm.car_no.value.indexOf("gj") != -1  || theForm.car_no.value.indexOf("GH") != -1 || theForm.car_no.value.indexOf("gh") != -1  || theForm.car_no.value.indexOf("GA") != -1 || theForm.car_no.value.indexOf("ga") != -1   ){
			alert("�ڵ���������ȣ�� Ȯ���Ͻʽÿ�. �߸� �ԷµǾ� �ֽ��ϴ�."); theForm.car_no.focus(); return false; 
		}
		
		if(theForm.car_no.value==""){		alert("�ڵ���������ȣ�� �Է��Ͻʽÿ�"); 	theForm.car_no.focus(); return false; }
		if(theForm.car_num.value==""){		alert("�����ȣ�� �Է��Ͻʽÿ�"); 			theForm.car_num.focus(); return false; }
		if(theForm.car_num.value.length != 17){		alert("�����ȣ�� 17�ڸ��Դϴ�. Ȯ�����ּ���!"); theForm.car_num.focus(); return false; }
		if(theForm.init_reg_dt.value==""){	alert("���ʵ������ �Է��Ͻʽÿ�."); 		theForm.init_reg_dt.focus(); return false; }
		if(theForm.car_nm.value==""){		alert("������ �Է��Ͻʽÿ�."); 			theForm.car_nm.focus(); return false; }
		if(theForm.car_ext.value==""){		alert("������ �����Ͻʽÿ�"); 			theForm.car_ext.focus(); return false; }
		if(theForm.car_kd.value==""){		alert("������ �����Ͻʽÿ�"); 			theForm.car_kd.focus(); return false; }
		if(theForm.car_use.value==""){		alert("�뵵�� �����Ͻʽÿ�"); 			theForm.car_use.focus(); return false; }						
		if(theForm.car_y_form.value==""){	alert("������ �Է��Ͻʽÿ�."); 			theForm.car_y_form.focus(); return false; }
	
		<%if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){ //������,������%>
		<%}else{%>
		if(theForm.dpm.value==""){  		alert("��ⷮ�� �Է��Ͻʽÿ�."); 		theForm.dpm.focus(); return false; }
		if(!isNum(theForm.dpm.value)){  	alert("��ⷮ�� ���ڸ� �Է��ϼ���."); 		theForm.dpm.focus(); return false; }		
		<%}%>
		
		if(theForm.taking_p.value==""){		alert("���������� �Է��Ͻʽÿ�."); 		theForm.taking_p.focus(); return false; }
		if(theForm.fuel_kd.value==""){		alert("������ ������ �Է��Ͻʽÿ�."); 	theForm.fuel_kd.focus(); return false; }
		if(theForm.conti_rat.value==""){	alert("���� �Է��Ͻʽÿ�."); 			theForm.conti_rat.focus(); return false; }
		if(theForm.loan_st.value==""){		alert("��ä������ �����Ͻʽÿ�."); 		theForm.loan_st.focus(); return false; }	
		
		//�˻���ȿ�Ⱓ
		if(theForm.maint_st_dt.value==""){		alert("�˻���ȿ�Ⱓ�� �Է��Ͻʽÿ�."); 	theForm.maint_st_dt.focus(); return false; }	
		if(theForm.maint_end_dt.value==""){		alert("�˻���ȿ�Ⱓ�� �Է��Ͻʽÿ�."); 	theForm.maint_end_dt.focus(); return false; }	
		
		if(theForm.car_use.value=="1"){
			if(theForm.car_end_dt.value==""){		alert("���ɸ������� �Է��Ͻʽÿ�."); 	theForm.car_end_dt.focus(); return false; }	
		}	
		
		//���ɸ�����		
		chk_end();
		
		//�˻���ȿ�Ⱓ
		chk_maint();
		
		<%if(car.getCar_origin().equals("2")){//������%>
			if(toInt(parseDigit(theForm.import_car_amt.value)) >0 && theForm.import_tax_dt.value ==''){
				alert("�������Ű����� �Է��Ͻʽÿ�."); 	theForm.import_tax_dt.focus(); return false; 
			}
		<%} else { %>	
			<%if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){ //������,������%>
			<%}else{%>
		  	//��ⷮ - ���� +/-  100
			var mst_dpm ='<%=mst.getDpm()%>';		
		 	var dpm_chk_amt 	= toInt(mst_dpm)    -   toInt(parseDigit(theForm.dpm.value))  ;	 	
			if  (Math.abs(dpm_chk_amt) > 100 ) {
			 	 alert("��ⷮ�� Ȯ���ϼ���!!");
			 	 return false;
			}
			<%}%>	
		<%}%>	
		
		//�������ϴ� �����Һ��ڰ��� �����Һ񼼰������� �Է� �˻�
		<%if(ej_bean.getJg_w().equals("1") || ej_bean.getJg_w().equals("2")){//������%>
			if(toInt(parseDigit(theForm.import_car_amt.value)) > <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt()%> ){
				alert("���������������� �����Һ��ڰ����� Ŭ �� �����ϴ�. �ݾ� Ȯ���Ͻʽÿ�."); return false;
			}
		<%}%>
						
		return true;
	}

	//��ϰ���
	function go_to_list(){
		if(document.CarRegForm.from_page.value == "rbs"){	// �������� > ������� > ��ǰ�غ��Ȳ���� �����ϴ� ���
			parent.location='/fms2/car_pur/rent_board_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>';
		}else {	// �������� > ������ϰ��� > �ڵ����������� �����ϴ� ���
			parent.location='register_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>';	
		}
	}
	
	function loan_set(){
		var fm = document.CarRegForm;
		if(fm.loan_s_amt.value != '' && fm.loan_b_amt.value != ''){
			fm.loan_s_rat.value = parseFloatCipher3(toFloat(parseDigit(fm.loan_s_amt.value)) / toFloat(parseDigit(fm.loan_b_amt.value))*100, 1);
		}else{
			fm.loan_s_rat.value = '';
		}
	}
	
//���ɸ�����
function chk_end() { 
	
	var NowDay = new Date();
		
	var  dpm = document.CarRegForm.dpm.value;
	var  car_use = document.CarRegForm.car_use.value;
	var	car_ed = document.CarRegForm.car_end_dt.value;	
	var car_end_dt; // ��갪
		
	if(dpm < 2000 ){
		var DDyear = NowDay.getFullYear() + 5;
	}else{
		var DDyear = NowDay.getFullYear() + 8;
	}
	
	var  date = document.CarRegForm.init_reg_dt.value;
	//������¥ ���ϱ�			 
	var selectDate = date.split("-");
	var changeDate = new Date();
	changeDate.setFullYear(selectDate[0], selectDate[1]-1, selectDate[2]-1);
		      
	var y = changeDate.getFullYear();
	var m = changeDate.getMonth() + 1;
	var d = changeDate.getDate();
	if(m < 10)    { m = "0" + m; }
	if(d < 10)    { d = "0" + d; }
		      
	var resultDate = y + "-" + m + "-" + d;	  	
	var DDmonth =  m;
	var DDday =  d;	
	
	car_end_dt = DDyear + "-" + DDmonth + "-" + DDday; //���ɸ�����
	
	if(car_use == 1 ){
		// ���� + -  �Ѵ� ���� - ���������ϰ���
	    if  ( Math.abs(  toInt(replaceString("-","",car_end_dt))  -   toInt(replaceString("-","",car_ed))   )  >31 ) { 
		  	alert("�Է��� ���ɸ������� Ȯ���� �ּ���!!");
			return;
        }       	
	}
}



//�˻���ȿ�Ⱓ
function chk_maint() { 

	var NowDay = new Date();
	
	var  car_use = document.CarRegForm.car_use.value;    //1:������
	var  car_kd= document.CarRegForm.car_kd.value;  
	var	maint_st = document.CarRegForm.maint_st_dt.value;
	var	maint_ed = document.CarRegForm.maint_end_dt.value;	
	var	maint_st_dt;    //��갪
	var	maint_end_dt;    //��갪
	
	if(car_use == 1 ){
		var DDyear = NowDay.getFullYear() + 2;
		
	}else if(car_use == 2 && (car_kd == 1 || car_kd == 2 || car_kd == 3 || car_kd == 9) ){
		var DDyear = NowDay.getFullYear() + 4;
	}else if(car_use == 2 && (car_kd == 4 || car_kd == 5 || car_kd == 6 || car_kd == 7 || car_kd == 8) ){
		var DDyear = NowDay.getFullYear() + 1;
	}
			
	var  date = document.CarRegForm.init_reg_dt.value;
	//������¥ ���ϱ�			 
	var selectDate = date.split("-");
	 var changeDate = new Date();
	 changeDate.setFullYear(selectDate[0], selectDate[1]-1, selectDate[2]-1);
		      
	 var y = changeDate.getFullYear();
	 var m = changeDate.getMonth() + 1;
	 var d = changeDate.getDate();
	 if(m < 10)    { m = "0" + m; }
	 if(d < 10)    { d = "0" + d; }
		      
	var resultDate = y + "-" + m + "-" + d;
	var DDmonth =  m;
	var DDday =  d;	
		
	maint_st_dt = document.CarRegForm.init_reg_dt.value; //�˻���ȿ�Ⱓ ������
	maint_end_dt = DDyear + "-" + DDmonth + "-" + DDday; //�˻���ȿ�Ⱓ ������
		      
	//�˻���
	if(  toInt(replaceString("-","",maint_st_dt))   !=   toInt(replaceString("-","",maint_st))   ) {
		alert("�Է��� �˻���ȿ�Ⱓ �������� Ȯ���� �ּ���!!");
		return;
	}
	
	// ���� + -  �Ѵ� ���� - ���������ϰ���
    if  ( Math.abs(  toInt(replaceString("-","",maint_end_dt))  -   toInt(replaceString("-","",maint_ed))   )  > 31) {
	  	alert("�Է��� �˻���ȿ�Ⱓ �������� Ȯ���� �ּ���!!");
		return;
	}		
	
}

function reg_sum(){
		var fm = document.CarRegForm;
		var reg_amt = fm.reg_amt.value;
		var car_use = fm.car_use.value;
		var car_kd = fm.car_kd.value;
		
		var gs_amt = th_rndd(<%=car.getCar_fs_amt()+car.getSd_cs_amt()-car.getDc_cs_amt()%>);
		var r_amt = 0;
		
		if(gs_amt != ''){
			
			//���ֽ�û ������ Ȩ������ �����Ͽ� ���������

			if(car_use == 1 ){ //������������ ǥ�ذ������� 2%
				gs_amt = ((gs_amt * 0.02 )/10);
			}else if(car_use == 2 && car_kd != 1 && car_kd != 2 && car_kd != 3){//�񿵾��������̸鼭 �¿����� �ƴѰ�� 3%
				gs_amt = ((gs_amt * 0.03 )/10);
			}else{ //�񿵾��������̸鼭 �¿����� ǥ�ذ������� 5%
				gs_amt = ((gs_amt * 0.05 )/10);
			}
			
				gs_amt = Math.floor(gs_amt);
				gs_amt = gs_amt * 10;
		}else{
			gs_amt = '';
		}
	
		r_amt = reg_amt - gs_amt ; 
		 
	    //����̸� ���� ���� - ��������
		if ( Math.abs(r_amt) > 100) {
			alert("�Է��� ��ϼ� �ݾ��� Ȯ���� �ּ���!!");
			fm.reg_amt.value = "";
		}
		
}
	
function acq_sum(){
		var fm = document.CarRegForm;
		var acq_amt = fm.acq_amt.value;
		var gs_amt = th_rndd(<%=car.getCar_fs_amt()+car.getSd_cs_amt()-car.getDc_cs_amt()%>);
		var a_amt = 0;
		
		if(gs_amt != ''){
				gs_amt = ((gs_amt * 0.02 )/10);
				gs_amt = Math.floor(gs_amt);
				gs_amt = gs_amt * 10;

		}else{
			gs_amt = '';
		}

		a_amt = acq_amt - gs_amt ; 
		 
	    //����̸� ���� ���� - ��������
		if ( Math.abs(a_amt) > 100) {
			alert("�Է��� ��漼 �ݾ��� Ȯ���� �ּ���!!");
			fm.acq_amt.value = "";
		}
	}


function sum(){
		var fm = document.CarRegForm;
		var reg_amt = fm.reg_amt.value;
		var acq_amt = fm.acq_amt.value;
		var gs_amt1 = th_rndd(<%=car.getCar_fs_amt()+car.getSd_cs_amt()-car.getDc_cs_amt()%>);
		var gs_amt2 = th_rndd(<%=car.getCar_fs_amt()+car.getSd_cs_amt()-car.getDc_cs_amt()%>);
		if(gs_amt1 != ''){
				gs_amt1 = ((gs_amt1 * 0.02 )/10);
				gs_amt1 = Math.floor(gs_amt1);
				gs_amt1 = gs_amt1 * 10;
			fm.reg_amt.value = gs_amt1;
		}else{
			gs_amt1 = '';
		}

		if(gs_amt2 != ''){
				gs_amt2 = ((gs_amt2 * 0.02 )/10);
				gs_amt2 = Math.floor(gs_amt2);
				gs_amt2 = gs_amt2 * 10;
			fm.acq_amt.value = gs_amt2;
		}else{
			gs_amt2 = '';
		}		
	}

function get_makedYear(val){
	if(val.length == 17){
		var fm = document.CarRegForm;
		var str = val.substr(9,1);
		var year = "";
		
		if(		    str=="A"){	year = "2010";	}else if(str=="B"){	year = "2011";	}else if(str=="C"){	year = "2012";	}
		else if(	str=="D"){	year = "2013";	}else if(str=="E"){	year = "2014";	}else if(str=="F"){	year = "2015";	}
		else if(	str=="G"){	year = "2016";	}else if(str=="H"){	year = "2017";	}else if(str=="J"){	year = "2018";	}
		else if(	str=="K"){	year = "2019";	}else if(str=="L"){	year = "2020";	}else if(str=="M"){	year = "2021";	}
		else if(	str=="N"){	year = "2022";	}else if(str=="P"){	year = "2023";	}else if(str=="R"){	year = "2024";	}
		else if(	str=="S"){	year = "2025";	}else if(str=="T"){	year = "2026";	}else if(str=="V"){	year = "2027";	}
		else if(	str=="W"){	year = "2028";	}else if(str=="X"){	year = "2029";	}else if(str=="Y"){	year = "2030";	}
		else if(	str=="1"){	year = "2031";	}else if(str=="2"){	year = "2032";	}else if(str=="3"){	year = "2033";	}
		else if(	str=="4"){	year = "2034";	}else if(str=="5"){	year = "2035";	}else if(str=="6"){	year = "2036";	}
		else if(	str=="7"){	year = "2037";	}else if(str=="8"){	year = "2038";	}else if(str=="9"){	year = "2039";	}
		else{	alert("�����ȣ ���Է����� ������ �ڵ��Է� �� �� �����ϴ�. �����ȣ Ȯ�����ּ���.");	return false;	}
		
		fm.car_y_form.value = year;
	}	
}

//-->
</script>
</head>
<body leftmargin="15"  >
<form action="register_null_ui.jsp" name="CarRegForm" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="reg_dt" value="<%=Util.getDate()%>">
<input type="hidden" name="reg_nm" value="<%=c_db.getNameById(user_id, "USER")%>">
<input type="hidden" name="car_fs_amt" value="<%=car.getCar_fs_amt()%>">
<input type="hidden" name="sd_cs_amt" value="<%=car.getSd_cs_amt()%>">
<input type="hidden" name="dc_cs_amt" value="<%=car.getDc_cs_amt()%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="new_license_plate" id="new_license_plate" value="<%=car.getNew_license_plate()%>">
<input type="hidden" name="udt_st" id="udt_st" value="<%=udt_st%>">
<input type="hidden" name="acq_amt_card" id="acq_amt_card"><!-- ��漼�� �ְ� ������ ������ �ƴ� ��� ��漼���簡 ī������ �ϱ����� �߰� 2017.12.13 -->
<input type="hidden" name="isChrome" id="isChrome" value="<%=isChrome%>"><!-- �������� ũ������ �ƴ��� �Ǻ� 2018.03.05 -->
<input type="hidden" name="car_size" id="car_size" value="<%=cm_bean.getJg_code()%>"><!-- ���� ���ÿ��� �ڵ��� �ڵ尡 8000 ���ϴ� �¿���, 8000 �ʰ� 9000 ���ϴ� ������, 9000 �ʰ��� ȭ�������� ���� ���� 2018.03.05 -->

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �ڵ������� > <span class=style5>�ڵ������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td align="right">
    	   <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
           	<a href="javascript:CarRegReg()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_write.gif align=absmiddle border=0></a>&nbsp;
              <% }%> 	
			<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>	
	  </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="12%" class=title>���ʵ����</td>
                    <td width="33%">&nbsp; 
                      <input type="text" name="init_reg_dt" value="<%=Util.getDate()%>" size="12" class=text  maxlength="12" onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>����</td>
                    <td colspan="3">&nbsp; 
                      <select name="car_ext" id="car_ext">
                        <option value="">����</option>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(car.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                                                
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�ڵ�����ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="car_no" id="car_no" value="<%=pur.getEst_car_no()%>" size="15" class=text maxlength="15">
                    </td>
                    <td class=title>����</td>
                    <td width=20%>&nbsp; 
                      <select name="car_kd" id="car_kd" style="width:115px">
                        <option value="" selected>����</option><!-- �Է� ȭ�� ���Խ� ������ ����Ʈ �������� ���� 2018.03.07 -->
                        <option value="1" id="big_pass">�����¿�</option>
                        <option value="2" id="mid_pass">�����¿�</option>
                        <option value="3" id="small_pass">�����¿�</option>
                        <option value="9" id="ssmall_pass">�����¿�</option>
                        <option value="4" id="mid_van">��������</option>
                        <option value="5" id="small_van">��������</option>
                        <option value="8" id="big_truck">����ȭ��</option>
                        <option value="7" id="mid_truck">����ȭ��</option>
                        <option value="6" id="small_truck">����ȭ��</option>
                      </select>
                    </td>
                    <td class=title width=10%>�뵵</td>
                    <td width="15%">&nbsp; 
                      <select name="car_use">
                        <option value="">����</option>			  
                        <option value="1" <%if(base.getCar_st().equals("1")||base.getCar_gu().equals("2"))%>selected<%%>>������</option>
                        <option value="2" <%if(base.getCar_st().equals("3"))%>selected<%%>>�ڰ���</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=mst.getCar_nm()%> <%=mst.getCar_name()%> 
                      <input type="hidden" name="car_nm" value="<%=mst.getCar_nm()%>">
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_form" value="<%=cr_bean.getCar_form()%>" size="15" class=text>
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_y_form" value="<%=cr_bean.getCar_y_form()%>" size="6" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�����ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="car_num" value="<%=pur.getCar_num()%>" size="30" class=text maxlength="20" onblur="javascript:get_makedYear(this.value);">
                    </td>
                    <td class=title>����������</td>
                    <td colspan=3>&nbsp; 
                      <input type="text" name="mot_form" value="<%=cr_bean.getMot_form()%>" size="30" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr>                    
                    <td class=title width=12%>��ⷮ</td>                    
                    <td width=15%>&nbsp; 
                      <input type="text" name="dpm" value="" size="4" class=text>
                    cc</td>
                    <td class=title width=10%>��������</td>                    
                    <td width=15%>&nbsp; 
                      <input type="text" name="taking_p" value="<%if(ej_bean.getJg_g_17()!=0){%><%=ej_bean.getJg_g_17()%><%}%>" size="2" class=text>
                    ��</td>
                    <td class=title width=10%>����</td>                    
                    <td width=15%>&nbsp; 
                      <input type="text" name="car_length" value="" size="6" class=num>&nbsp;mm
                    </td>
                    <td class=title width=10%>�ʺ�</td>                    
                    <td width=13%>&nbsp; 
                      <input type="text" name="car_width" value="" size="6" class=num>&nbsp;mm
                    </td>
                </tr>
                <tr>                    
                    <td class=title>����������</td>                    
                    <td colspan="3">&nbsp;
                      <select name="fuel_kd">
                        <option value="">����</option>
                        <option value="1" <% if(cm_bean.getDiesel_yn().equals("1"))%>selected<%%>>�ֹ���</option>
                        <option value="3" <% if(cm_bean.getS_st().equals("301")||cm_bean.getS_st().equals("302"))%>selected<%%>>LPG</option>
                        <option value="4" <% if(cm_bean.getDiesel_yn().equals("Y"))%>selected<%%>>����</option>
                        <option value="5" >�ֹ���+LPG���</option>                        
                        <option value="7" <% if(cm_bean.getDiesel_yn().equals("3")||cm_bean.getDiesel_yn().equals("4"))%>selected<%%>>�ֹ���+����</option>
                        <option value="8" <% if(cm_bean.getDiesel_yn().equals("5"))%>selected<%%>>����</option>
                        <option value="9" <% if(cm_bean.getDiesel_yn().equals("6"))%>selected<%%>>����</option>
                        <option value="10" <% if(cm_bean.getDiesel_yn().equals("10"))%>selected<%%>>����+����</option>
                      </select>
                      <span style="font-size:8pt"> (����
                      <input type="text" name="conti_rat" value="" size="4" class=text> km/L)</span></td>
                    <td class=title>Ÿ�̾�</td>                            
                    <td>&nbsp; 
                      <input type="text" name="tire" value="" size="20" class=text>
                    </td>                    
                    <td class=title>�ִ����緮</td>
                    <td>&nbsp;
                      <input type="text" name="max_kg" value="" size="4" class=text> kg</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=12%>���ʵ�Ϲ�ȣ</td>
                    <td width=15%>&nbsp;
                      <input type="text" name="first_car_no" value="�ڵ�����" size="15" class=whitetext maxlength="15" readonly></td>
                    <td class=title width=10%>�Ϲݼ�����</td>
                    <td width=26%>&nbsp; 
                      <input type="text" name="guar_gen_y" value="" size="4" class=text>
                      �� 
                      <input type="text" name="guar_gen_km" value="" size="8" class=text>
                    km </td>
                    <td class=title width=10%>����������</td>
                    <td width="27%">&nbsp; 
                      <input type="text" name="guar_endur_y" value="" size="4" class=text>
                      �� 
                      <input type="text" name="guar_endur_km" value="" size="8" class=text>
                    km </td>
                </tr>
                <tr>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp;
                      <input type="text" name="car_end_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title>�˻���ȿ�Ⱓ</td>
                    <td>&nbsp;
                      	<input type="text" name="maint_st_dt" value="<%=Util.getDate()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  	<input type="text" name="maint_end_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); '>
        			</td>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td>&nbsp;
                        <input type="text" name="test_st_dt" value=""  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
          				~
          				<input type="text" name="test_end_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); '>
                    </td>
                </tr>
                <%if(ej_bean.getJg_w().equals("1") || ej_bean.getJg_w().equals("2")){//������%>
                <tr> 
                    <td class=title>��������������</td>
                    <td>&nbsp;
                      <input type="text" name="import_car_amt" value="" size="10" class=num onBlur='javscript:this.value=parseDecimal(this.value);'>
                    ��</td>
                    <td class=title>����������</td>
                    <td>&nbsp; 
                      ����
                      <input type="text" name="import_tax_amt" value="" size="10" class=num onBlur='javscript:this.value=parseDecimal(this.value);'>
                      ��,
                      �����Һ�
                      <input type="text" name="import_spe_tax_amt" value="" size="10" class=num onBlur='javscript:this.value=parseDecimal(this.value);'>
                      ��                    
                    </td>
                    <td class=title>�������Ű���</td>
                    <td>&nbsp; 
                      <input type="text" name="import_tax_dt" value="" size="10" class=text>
                    &nbsp;&nbsp;
                    (���ԽŰ�����)
                    </td>                    
                </tr>                
                <%}else{%>
                <input type='hidden' name="import_car_amt" value="0">
                <input type='hidden' name="import_tax_amt" value="0">
                <input type='hidden' name="import_tax_dt" value="">
                <input type='hidden' name="import_spe_tax_amt" value="0">
                <%}%>
            </table>
        </td>
	</tr>	
	<tr>
        <td class=h></td>
    </tr>	
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ϼ�����(�ݾ�)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr>                    
                    <td width="12%" class=title>��ä(ä��)����</td>                    
                    <td width="15%">&nbsp; 
                      <select name="loan_st">
                        <option value="">����</option>			  
                   		<option value="2" selected>�������߰�ä</option>
                   		<option value="1">����ö��ä</option>
                   	  </select>                    	
                    </td>                    
                    <td width="10%" class=title>��ä���Խ�</td>                    
                    <td width="15%">&nbsp; 
                      <input type="text" name="loan_b_amt" value="" size="10" class=num onBlur='javscript:loan_set(); this.value=parseDecimal(this.value);'>
                    ��</td>
                    <td width="10%" class=title>��ä���ν�</td>                    
                    <td width="15%">&nbsp; 
                      <input type="text" name="loan_s_amt" value="" size="10" class=num onBlur='javscript:loan_set(); this.value=parseDecimal(this.value);'>
                    �� </td>
                	<td width="10%" class=title>��ä������</td>                    
                    <td width="13%">&nbsp; 
                      <input type="text" name="loan_s_rat" value="" size="6" class=num>
                    % </td>                    
                </tr>
                <tr>
                    <td class=title>��ϼ�</td>                    
                    <td>&nbsp; 
                      <input type="text" name="reg_amt" value="<%if(tax_amt2 != 0){%><%=Util.parseDecimal(tax_amt2)%><%}else{%>0<%}%>" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                    �� </td>
                    <td class=title>��漼</td>                    
                    <td>&nbsp; 
                      <input type="text" name="acq_amt" id="acq_amt" value="<%if(tax_amt3 != 0){%><%=Util.parseDecimal(tax_amt3)%><%}else{%>0<%}%>" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                    ��</td>
                    <td class=title>��ȣ���ۺ�</td>                    
                    <td>&nbsp; 
                      <input type="text" name="no_m_amt" id="no_m_amt" value="<%if(!base.getCar_gu().equals("2") && br_id.equals("S1")){%>8,800<%}%>" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                    �� <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%><span style="color: red;">(������ȣ�ǽ�û)</span><%}%></td>
                                      

                	<td class=title>��,������</td>                    
                    <td>&nbsp; 
                      <input type="text" name="stamp_amt" value="<%if(base.getCar_gu().equals("2")){%>1,000<%}else if(br_id.equals("S1")){%>2,000<%}%>" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                      �� </td>                      
                                   </tr>
                <tr>
                    <td class=title>��Ÿ������</td>                    
                    <td >&nbsp;
        				<input type="text" name="etc" value="" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                      �� </td>
                    <td class=title>��Ϻ�������</td>                    
                    <td  colspan=7 >&nbsp; 
                      <input type="text" name="reg_pay_dt" value="<%=Util.getDate()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      </td>
    			  
                </tr>
                <tr>                    
                    <td class=title>��ϼ�����</td>                    
                    <td >&nbsp;
					   <label><input type="checkbox" name="reg_amt_card" value="Y"> 
					    ī�����</label>
        				 </td>
                    <td class=title>��ȣ�Ǵ�ݰ���</td>                    
                    <td  colspan=7 >&nbsp; 
                      <input type="checkbox" name="no_amt_card" value="Y"> 
					  ī�����
                      </td>
    			  
                </tr>
				
            </table>
        </td>
    </tr>
</table>
</form>
<center>
<a href="javascript:FootWin('HIS')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_ir.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('PUR')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_cg.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('MORT')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_jdg.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('SER')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_jggs.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('CHA')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_gj.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:OpenIns()"       onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_ins.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('ACQ')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_cd.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('KEY')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_ybk.gif align=absmiddle border=0></a>&nbsp; 
</center>
<script language="JavaScript">
<!--	
	var fm = document.CarRegForm;
	
	// ��ȣ���ۺ� ���		2017.12.07(1�� �۾�)		2018.01.05(2�� �۾�)    2020.04.12
	var car_ext = $("#car_ext").val();	// ����
	var udt = $("#udt_st").val();
	var car_no = $("#car_no").val();
	var car_use = fm.car_use.value;
	var new_license_plate = $("#new_license_plate").val();
	
	//20220314 ��ȣ�� ��뺯��
	//��õ=����=����=����=�� ����20000, ����21400, ����7700
		
	if(car_no == "�� ��" || car_use== '2'){		// �뵵�� ������ ��쿡�� �μ����� ���� �� ���� ��ȣ���ۺ� 0������ ������ �μ����� ���� 8,800������ ó��
		if(udt=="����"){
			$("#no_m_amt").val("0");
		}else {
			$("#no_m_amt").val("7,700");
		}
	}else if(udt=="����"||udt=="��õ"||udt=="��������"||udt=="��������"||udt=="��"){
		$("#no_m_amt").val("7,700");
	}else if(udt=="�λ�����"){	// �λ�
		$("#no_m_amt").val("9,000");
	}else if(udt=="�뱸����"){	// �뱸
		$("#no_m_amt").val("9,100");
	}else{
		$("#no_m_amt").val("7,700");
	}
	
	//����
	if($("#car_ext").val() == 1){
		$("#no_m_amt").val("6,800");
	}
	
	//������ȣ�� ��û�� ��� �Ʒ��ݾ����� ����
	if (new_license_plate == "1" || new_license_plate == "2") {
		$("#no_m_amt").val("21,400");
		//20220707 ������ ������ 21400
		if(car_no == "�� ��" || car_use== '2'){
			
		}else{
			if(udt=="�뱸����"){
				$("#no_m_amt").val("20,800");
			}
			if(udt=="�λ�����"){
				$("#no_m_amt").val("24,000");
			}
			//����
			if($("#car_ext").val() == 1){
				$("#no_m_amt").val("21,500");
			}
		}	
	}
	//������,������
	<%if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){ %>
		$("#no_m_amt").val("20,000");
		if(udt=="�뱸����"){
			$("#no_m_amt").val("24,100");
		}
		if(udt=="�λ�����"){
			$("#no_m_amt").val("24,000");
		}
	<%}%>
	
	
	// ���� ���ÿ��� �ڵ��� �ڵ尡 8000000 ���ϴ� �¿���, 8000000 �ʰ� 9000000 ���ϴ� ������, 9000000 �ʰ��� ȭ�������� ���� ���� 2018.03.05
	var car_size = $("#car_size").val();
	var isChrome = $("#isChrome").val();
	if(car_size < 8001000){	// �¿���
		if(isChrome=="true"){
			$("#car_kd option[id=mid_van]").hide();
			$("#car_kd option[id=small_van]").hide();
			$("#car_kd option[id=big_truck]").hide();
			$("#car_kd option[id=mid_truck]").hide();
			$("#car_kd option[id=small_truck]").hide();	
		}else{
			$("#car_kd option[id=mid_van]").prop('disabled','disabled');
			$("#car_kd option[id=small_van]").prop('disabled','disabled');
			$("#car_kd option[id=big_truck]").prop('disabled','disabled');
			$("#car_kd option[id=mid_truck]").prop('disabled','disabled');
			$("#car_kd option[id=small_truck]").prop('disabled','disabled');
		}
	}else if(car_size < 9001000){// ������
		if(isChrome=="true"){
			$("#car_kd option[id=big_pass]").hide();
			$("#car_kd option[id=mid_pass]").hide();
			$("#car_kd option[id=small_pass]").hide();
			$("#car_kd option[id=ssmall_pass]").hide();
			$("#car_kd option[id=big_truck]").hide();
			$("#car_kd option[id=mid_truck]").hide();
			$("#car_kd option[id=small_truck]").hide();	
		}else{
			$("#car_kd option[id=big_pass]").prop('disabled','disabled');
			$("#car_kd option[id=mid_pass]").prop('disabled','disabled');
			$("#car_kd option[id=small_pass]").prop('disabled','disabled');
			$("#car_kd option[id=ssmall_pass]").prop('disabled','disabled');
			$("#car_kd option[id=big_truck]").prop('disabled','disabled');
			$("#car_kd option[id=mid_truck]").prop('disabled','disabled');
			$("#car_kd option[id=small_truck]").prop('disabled','disabled');
		}
	}else{	// ȭ����
		if(isChrome=="true"){
			$("#car_kd option[id=big_pass]").hide();
			$("#car_kd option[id=mid_pass]").hide();
			$("#car_kd option[id=small_pass]").hide();
			$("#car_kd option[id=ssmall_pass]").hide();
			$("#car_kd option[id=mid_van]").hide();
			$("#car_kd option[id=small_van]").hide();
		}else{
			$("#car_kd option[id=big_pass]").prop('disabled','disabled');
			$("#car_kd option[id=mid_pass]").prop('disabled','disabled');
			$("#car_kd option[id=small_pass]").prop('disabled','disabled');
			$("#car_kd option[id=ssmall_pass]").prop('disabled','disabled');
			$("#car_kd option[id=mid_van]").prop('disabled','disabled');
			$("#car_kd option[id=small_van]").prop('disabled','disabled');
		}
	}

	<%if(base.getCar_gu().equals("2")){%>
	fm.init_reg_dt.value = ChangeDate('<%=car.getSh_init_reg_dt()%>');
	<%}%>	
	
//-->
</script>	
</body>
</html>