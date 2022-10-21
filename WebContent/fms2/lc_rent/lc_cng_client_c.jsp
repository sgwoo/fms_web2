<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, acar.fee.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="ai_db2" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "11");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	EstiJgVarBean ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
		
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//��������
		String ins_st = ai_db2.getInsSt(base.getCar_mng_id());
		ins = ai_db.getInsCase(base.getCar_mng_id(), ins_st);
	}
	
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));

	//�ʰ�����δ��
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	Hashtable sh_ht = shDb.getShBase(base.getCar_mng_id());
	
	//�����Ī������ ���� ���������Ϻ��� ����Ÿ����--
	String taecha_st_dt = "";
	taecha_st_dt = ac_db.getClsEtcTaeChaStartDt(rent_mng_id, rent_l_cd, base.getCar_mng_id() );	
	
	
	
	
	//gua_ins
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));	
	
	Vector ht = af_db.getFeeScdCng(rent_l_cd, "", "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//�����ڰݰ������
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;	
	
	
	//ä�ǿ���----------------------------------------
	
	Vector settles = s_db.getSettleList_20091001("", "", "", "", "", "", "9", rent_l_cd);
	int settle_size = settles.size();
	
	long amt[]   = new long[13];
	long settle_amt = 0;
	long r_settle_amt = 0;
	
	for (int i = 0 ; i < settle_size ; i++){
		Hashtable settle = (Hashtable)settles.elementAt(i);
		for(int j=0; j<9; j++){
			amt[j]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT"+j)));
			if(j>0){
				settle_amt = settle_amt + amt[j];
			}
		}
		r_settle_amt = settle_amt-amt[6];
			
	}
	
	int car_amt = car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt();
	
	String a_a = "2";
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";
	String var_seq = "";
	//���뺯��
	if(a_a.equals("1")) var_seq = "92";
	if(a_a.equals("2")) var_seq = "93";
	em_bean = edb.getEstiCommVarCase(a_a, "");
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type-"text/css>
<!--	
input.whitetextredb		{ text-align:left; font-size : 9pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#ff0000;  font-weight:bold;}
//-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//�� ��ȸ
	function search_client()
	{
		window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_cng_client_c.jsp", "CLIENT", "left=10, top=10, width=1100, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		

	//����/���� ��ȸ
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_cng_client_c.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			
	
	//�� ����
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_cng_client_c.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_cng_client_c.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//������ ��ȸ
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_mgr.jsp?idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
	
	//���뺸����
	function cng_input(){
		var fm = document.form1;		
		if(fm.guar_st[0].checked == true){ 				//����
			tr_guar2.style.display	= '';
		}else{											//����
			tr_guar2.style.display	= 'none';
		}
	}	
	
	//��ǥ�̻纸��
	function cng_input2(){	
		var fm = document.form1;		
		if(fm.client_guar_st[0].checked == true){ 		//����
			tr_client_guar.style.display = 'none';		
		}else{											//����
			tr_client_guar.style.display = '';				
		}
	}
	
	//���������� �����������
	function cng_input4(){
		if(document.form1.client_st.value == '2' && document.form1.client_share_st[0].checked==true){
			tr_client_share_st_test.style.display='';//����
		}else{
			tr_client_share_st_test.style.display='none';//����
		}
	}	

	//������ ��ȸ
	function search_gur(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_gur.jsp?idx="+idx+"&client_id="+fm.client_id.value, "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//�ּ� ��ȸ
	function search_post(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_post.jsp?idx="+idx+"&client_id="+fm.client_id.value, "POST", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//�뿩���
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=650, scrollbars=yes");
	}		
	
	//����� �������ڷ� �ٽ� ���
	function set_day(){
		var fm = document.form1;	
		if(fm.cls_dt.value == ''){ 	alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_dt.focus(); 	return;	}
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}					
		fm.action='/acar/cls_con/cls_settle_nodisplay.jsp';		
		fm.target='i_no';
		fm.submit();
	}
	
	
	function save(){
		var fm = document.form1;

		if(fm.cls_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.');			return;}
		
		if(fm.r_mon.value.length > 3 || fm.r_day.value.length > 3){
			alert('�̿�Ⱓ-�� Ȥ�� ���� 3�ڸ��� �Ѿ�ϴ�. Ȯ���Ͻʽÿ�.'); return;
		}
		
		var est_day1 = getRentTime('l', '<%=fee.getRent_start_dt()%>', fm.cls_dt.value);
		//�������� üũ
		if(est_day1 < 0){ 
			alert('�������ڰ�  �뿩�����Ϻ��� �۽��ϴ�. Ȯ���Ͻʽÿ�.');			return;
		}
		<%if(!cont_etc.getRent_suc_dt().equals("")){%>
		var est_day2 = getRentTime('l', '<%=cont_etc.getRent_suc_dt()%>', fm.cls_dt.value);
		//�������� üũ
		if(est_day1>=0 && est_day2 < 0){ 
			alert('�������ڰ�  ���� �°����ں��� �۽��ϴ�. Ȯ���Ͻʽÿ�.');			return;
		}
		<%}%>
		

		
		
		if(fm.client_id.value == '')		{ alert('���� �����Ͻʽÿ�.'); 			return;}
		
		if(fm.client_id.value == fm.client_id_old.value)		{ alert('������ ���� �������Դϴ�. �°��ϴ� ���� �����Ͻʽÿ�.'); 			return;}
		
		<%if(!ck_acar_id.equals("000029")){%>
		
		//20150417 ����,���λ���ڴ� ���������ȣ �ʼ�
		if(fm.client_st.value == '2' || fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){		
			
				if(fm.lic_no.value == '' && fm.mgr_lic_no.value == ''){
					alert('����,���λ���ڴ� ���������ȣ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.lic_no.value != '' && fm.lic_no.value.length < 12){
					alert('����� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_no.value.length < 12){
					alert('�����̿��� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
					return;
				}			
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_emp.value == ''){
					alert('�����̿��� ���������ȣ �̸��� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_rel.value == ''){
					alert('�����̿��� ���������ȣ ���踦 �Է��Ͻʽÿ�.');
					return;
				}
		}
		if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_emp5.value == ''){
			alert('�߰������� ���������ȣ �̸��� �Է��Ͻʽÿ�.');
			return;
		}
		if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_rel5.value == ''){
			alert('�߰������� ���������ȣ ���踦 �Է��Ͻʽÿ�.');
			return;
		}
		if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_result5.value != '1'){
			alert('�߰��������� ���������������� Ȯ�����ּ���. �����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�.');
			return;
		}
		
		//����&���λ���� �����ڰݰ���
		if(fm.client_st.value == '2' || fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){	
			if(fm.test_lic_emp.value == '' || fm.test_lic_rel.value == '' || fm.test_lic_result.value == ''){
				alert('���������������� ��������� �� ��������� �Է��Ͻʽÿ�.');
				return;
			}
			if(fm.test_lic_result.value != '1'){
				alert('�����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�. �����ڰ� ��������� Ȯ�����ּ���.');
				return;
			}
		}
		//���� �����ڰݰ���
		if(fm.client_st.value == '1'){	
			if(fm.test_lic_emp.value == '' || fm.test_lic_rel.value == '' || fm.test_lic_result.value == ''){
				alert('���������������� ��������� �� ��������� �Է��Ͻʽÿ�.');
				return;
			}
			if(fm.test_lic_result.value != '1'){
				alert('�����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�. �����ڰ� ��������� Ȯ�����ּ���.');
				return;
			}
		}
		//����-���������� ����
		if(fm.client_st.value == '2' && fm.client_share_st[0].checked == true){	
			if(fm.test_lic_emp2.value == '' || fm.test_lic_rel2.value == '' || fm.test_lic_result2.value == ''){
				alert('����-���������� ���������������� ��������� �� ��������� �Է��Ͻʽÿ�.');
				return;
			}
			if(fm.test_lic_result2.value != '1'){
				alert('����-���������� �����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�. �����ڰ� ��������� Ȯ�����ּ���.');
				return;
			}
		}

		if(fm.t_addr[0].value == '')		{ alert('�����ּҸ� Ȯ���Ͻʽÿ�.'); 			return;}
		if(fm.guar_st[0].checked == true){
			if(fm.gur_nm[0].value == '')	{ alert('���뺸���� ������ �Է��Ͻʽÿ�.'); 		return;}
			if(fm.gur_ssn[0].value == '')	{ alert('���뺸���� ��������� �Է��Ͻʽÿ�.'); 	return;}
			if(fm.t_addr[2].value == '')	{ alert('���뺸���� �ּҸ� �Է��Ͻʽÿ�.'); 		return;}
			if(fm.gur_tel[0].value == '')	{ alert('���뺸���� ����ó�� �Է��Ͻʽÿ�.'); 		return;}
			if(fm.gur_rel[0].value == '')	{ alert('���뺸���� ���踦 �Է��Ͻʽÿ�.'); 		return;}												
		}
		if(fm.client_guar_st[1].checked == true){		
			if(fm.guar_con.options[fm.guar_con.selectedIndex].value == '')			{ alert('��ǥ�̻纸�� ���������� �����Ͻʽÿ�.'); 	return;}			
			if(fm.guar_sac_id.options[fm.guar_sac_id.selectedIndex].value == '')		{ alert('��ǥ�̻纸�� ���� �����ڸ� �����Ͻʽÿ�.'); 	return;}						
		}
		
		if(fm.est_area.value == '')		{ alert('�����̿�����(��/��)�� Ȯ���Ͻʽÿ�.'); 	return;}
		if(fm.county.value == '')		{ alert('�����̿�����(��/��)�� Ȯ���Ͻʽÿ�.'); 	return;}
		if(fm.est_area.value == '��/��')	{ alert('�����̿�����(��/��)�� Ȯ���Ͻʽÿ�.'); 	return;}
		if(fm.county.value == '��/��')		{ alert('�����̿�����(��/��)�� Ȯ���Ͻʽÿ�.'); 	return;}
		
		if(fm.ext_agnt.value == '')				{ alert('������ڸ� �Է��Ͻʽÿ�.'); 					fm.ext_agnt.focus(); 		return; }

		var rent_suc_commi 	= toInt(parseDigit(fm.rent_suc_commi.value));
		var rent_suc_commi_est 	= toInt(parseDigit(fm.rent_suc_commi_est.value));
		
		if(rent_suc_commi>0 && fm.rent_suc_commi_est_dt.value == '')				{ alert('�°������ �Աݿ������� �Է��Ͻʽÿ�.');	return;}
		
		if(rent_suc_commi_est>0 && rent_suc_commi < rent_suc_commi_est && fm.rent_suc_exem_cau.value == '')							{ alert('�°������ �°�����ᰨ������� �Է��Ͻʽÿ�.');	return;}
		if(rent_suc_commi_est>0 && rent_suc_commi < rent_suc_commi_est && fm.rent_suc_exem_cau.value == '4' && fm.rent_suc_exem_cau_sub.value == '')		{ alert('�°������ �°�����ᰨ�����-��Ÿ�� ��� ���� �Է��Ͻʽÿ�.');	return;}
		if(rent_suc_commi_est>0 && rent_suc_commi < rent_suc_commi_est && fm.rent_suc_exem_cau.value !== '' && fm.rent_suc_exem_id.value == '')			{ alert('�°������ �����ᰨ�� �����ڸ� �Է��Ͻʽÿ�.');	return;}
		
		if(fm.car_deli_dt.value == '')		{ alert('�����ε��ϸ� �Է��Ͻʽÿ�.');				return;}				
		
		est_day1 = getRentTime('l', '<%=fee.getRent_start_dt()%>', fm.car_deli_dt.value);
		//�����ε��� üũ
		if(est_day1 < 0){ 
			alert('�����ε�����  �뿩�����Ϻ��� �۽��ϴ�. Ȯ���Ͻʽÿ�.');			return;
		}
		<%if(!cont_etc.getRent_suc_dt().equals("")){%>
		est_day2 = getRentTime('l', '<%=cont_etc.getRent_suc_dt()%>', fm.car_deli_dt.value);
		//�������� üũ
		if(est_day1>=0 && est_day2 < 0){ 
			alert('�����ε�����  ���� �°����ں��� �۽��ϴ�. Ȯ���Ͻʽÿ�.');			return;
		}
		<%}%>
		
		var est_day3 = getRentTime('l', fm.rent_suc_dt.value, fm.rent_suc_commi_est_dt.value);
		//�Աݿ����� üũ
		if(rent_suc_commi>0 && est_day3 < 0){ 
			fm.rent_suc_commi_est_dt.value = fm.rent_suc_dt.value;
		}		
		
		if(fm.rent_suc_route.value == '')	{ alert('���-�°��Ʈ�� �Է��Ͻʽÿ�.');			return;}								
		
		<%if(ht_size>0){%>
		if(fm.fee_tm.value == '')		{ alert('������ �̰�ȸ���� �����Ͻʽÿ�.'); 			return;}		
		
		fm.cng_fee_tm.value = fm.fee_tm.options[fm.fee_tm.selectedIndex].text;
		<%}%>
		
		//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
		if('<%=base.getCar_st()%><%=ext_fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
				return;					
			}
		}else{
			if(<%=fee_size%>==1 && fm.insurant.value == '2'){
				alert('�������� ���� �����⺻�ĸ� �����մϴ�.');
				return;
			}			
		}		
		
		//����������üũ
		if(fm.client_st.value == '1' && <%=a_e%> > 101 && <%=a_e%> < 600 && <%=a_e%> != 409 ){	
			if(fm.com_emp_yn.value == '')					{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');		fm.com_emp_yn.focus(); 		return; }
		}else if(toInt(fm.client_st.value) > 2 && <%=a_e%> > 101 && <%=a_e%> < 600 && <%=a_e%> != 409 ){	
			//���λ���� ������������ ���Ѿ���
			if(fm.com_emp_yn.value == '')					{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');		fm.com_emp_yn.focus(); 		return; }
		}else{
			if(fm.com_emp_yn.value == 'Y')				{ alert('�������-��������������Ư�� ���Դ���� �ƴѵ� �������� �Ǿ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');	fm.com_emp_yn.focus(); 	return; }
		}
		
		//������ �������
		var grt_amt = toInt(parseDigit(fm.grt_s_amt.value));
		
		if (grt_amt > 0 ) {
			if(fm.grt_suc_yn.value == '')			{ alert('������-�°迩�θ� �����Ͻʽÿ�.'); 			fm.grt_suc_yn.focus(); 		return; }
			//��������� �������� ���ٸ� ���� 20180711
			//if(toInt(parseDigit(fm.o_grt_s_amt.value))==0)				{ fm.grt_suc_yn.value = '1'; }
			//��������� �����ݰ� �������� �������� ���ٸ� �°� 20180711
			//if(grt_amt == toInt(parseDigit(fm.o_grt_s_amt.value))){ fm.grt_suc_yn.value = '0'; }
		}else{
			if(fm.grt_suc_yn.value != '')			{ fm.grt_suc_yn.value = '' }
		}	
		
		//������ �������
		var pp_amt = toInt(parseDigit(fm.pp_amt.value));
		
		if (pp_amt > 0 ) {
			if(fm.pp_suc_yn.value == '')			{ alert('������-�°迩�θ� �����Ͻʽÿ�.'); 			fm.pp_suc_yn.focus(); 		return; }
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));
		}else{
			if(fm.pp_suc_yn.value != '')			{ fm.pp_suc_yn.value = '' }
		}		
		
		//���ô뿩�� �������
		var ifee_amt = toInt(parseDigit(fm.ifee_amt.value));
		
		if (ifee_amt > 0 ) {
			if(fm.ifee_suc_yn.value == '')			{ alert('���ô뿩��-�°迩�θ� �����Ͻʽÿ�.'); 			fm.ifee_suc_yn.focus(); 		return; }
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));
		}else{
			if(fm.ifee_suc_yn.value != '')			{ fm.ifee_suc_yn.value = '' }
		}				
		
   		if(fm.gi_st[0].checked == false && fm.gi_st[1].checked == false){	
   			alert('�������� ���Կ��θ� �����Ͻʽÿ�.'); fm.gi_st[0].focus(); return; 
   		}		
		
		if(toInt(parseDigit(fm.grt_s_amt.value))+toInt(parseDigit(fm.pp_amt.value))+toInt(parseDigit(fm.ifee_amt.value))==0 && fm.gi_st[1].checked == true){
			if(!confirm('������,�������� ���� �������� ������ �Ǿ� �ֽ��ϴ�. �°� ����� �����Ͻðڽ��ϱ�?')){	return;	}	
		}
		
		if(fm.dec_gr.value == '')			{ alert('����ſ����� �����Ͻʽÿ�.'); 			return;}
		if(fm.dec_f_dt.value == '')			{ alert('�������ڸ� �Է��Ͻʽÿ�.'); 			return;}
		
		<%}%>
		
		if(confirm('����Ͻðڽ��ϱ�?')){		
		
			fm.commi_s_amt.value = sup_amt(toInt(parseDigit(fm.rent_suc_commi.value)));
			fm.commi_v_amt.value = toInt(parseDigit(fm.rent_suc_commi.value)) - toInt(fm.commi_s_amt.value);			
			fm.cms_bank_cd.value = fm.fee_bank.options[fm.fee_bank.selectedIndex].text;
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");

			fm.action='lc_cng_client_c_a.jsp';
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}		
	}
	
	//���� üũ
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');
		}
	}
	
	function getSucCommi()
	{
		var fm = document.form1;
		
		<%if(AddUtil.parseInt(AddUtil.getDate(4)) < 20170220){//20170220 ���� 0.7*1.1%>
  	fm.rent_suc_commi.value = parseDecimal(<%=car_amt%>*0.7/100*1.1);
  	fm.rent_suc_commi_est.value = fm.rent_suc_commi.value;
  	<%}else{%>
  	fm.rent_suc_commi.value = parseDecimal(<%=car_amt%>*0.8/100);
  	fm.rent_suc_commi_est.value = fm.rent_suc_commi.value;
  	<%}%>
    
  	if(fm.rent_suc_exem_cau.value == '1'){
  		fm.rent_suc_commi.value = 0;
  	}else if(fm.rent_suc_exem_cau.value == '2'){
  		fm.rent_suc_commi.value = parseDecimal(toInt(parseDigit(fm.rent_suc_commi.value)) * 0.5);
  	}
 	}
	
	//��������� �ڵ����
	function set_gi_amt(){
		var fm = document.form1;
		//var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
		//var oa_g 	= <%//=em_bean.getOa_g()%>/100;
		//var a_b 	= toInt(parseDigit(fm.gi_month.value));
		//var gi_fee 	= <%//=gi_fee%>;
		//fm.gi_fee.value = parseDecimal(gi_fee);	
	}
	
	//�ʰ�����Ÿ� �󼼺���	
	function view_over_agree(){
		var fm = document.form1;
		var SUBWIN="view_over_agree.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=ext_fee.getRent_st()%>&tot_dist=<%=sh_ht.get("TODAY_DIST")%>";
		window.open(SUBWIN, "ViewOverAgree", "left=50, top=50, width=850, height=700, scrollbars=yes, status=yes");
	}	
	
			
	//�����̷º���
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=base.getCar_mng_id()%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}	
		
	//û���ݾ� ����
	function set_reqamt(st){
		var fm = document.form1;			
		if(fm.cls_dt.value == ''){	alert('�������� �Է��Ͻʽÿ�.'); return;}
		if(fm.r_mon.value == ''){	alert('�̿�Ⱓ(����)�� �����ϴ�.'); return;}	
		if(fm.r_day.value == ''){	alert('�̿�Ⱓ(��)�� �����ϴ�.'); return;}
		
		//�̻��Ⱓ
		var n_mon = <%=ext_fee.getCon_mon()%>-toInt(fm.r_mon.value);
		var n_day = 0;
		if(toInt(fm.r_day.value) >0){
			n_mon = n_mon-1;
			n_day = 30-toInt(fm.r_day.value);
		}
		
		if(st == 'pp_amt'){
			var mon_amt	= toInt(parseDigit(fm.o_pp_amt.value))/<%=ext_fee.getCon_mon()%>;
			var amt 	= Math.round( (mon_amt*n_mon) + (mon_amt/30*n_day) );
			fm.pp_amt.value	= parseDecimal(amt);
		}

		if(st == 'ifee_amt'){
			//�Ⱓ���
			var ifee_cnt = <%=ext_fee.getPere_r_mth()%>;
			var r_mon = <%=ext_fee.getCon_mon()%>-ifee_cnt;
			var r_day = 0;
			//�̻����� �ִ�.
			if(n_mon < ifee_cnt){				
				var mon_amt	= toInt(parseDigit(fm.o_ifee_amt.value))/ifee_cnt;
				var amt 	= Math.round( (mon_amt*n_mon) + (mon_amt/30*n_day) );
				fm.ifee_amt.value = parseDecimal(amt);				
			}
		}
		
		fm.n_mon.value = n_mon;
		fm.n_day.value = n_day;
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
     	cnt[0] = new Array('��/��');
     	cnt[1] = new Array('��/��','������','������','���ϱ�','������','���Ǳ�','������','���α�','��õ��','�����','������','���빮��','���۱�','������','���빮��','���ʱ�','������','���ϱ�','���ı�','��õ��','��������','��걸','����','���α�','�߱�','�߶���');
     	cnt[2] = new Array('��/��','������','������','����','����','������','�λ�����','�ϱ�','���','���ϱ�','����','������','������','������','�߱�','�ؿ�뱸','���屺');
     	cnt[3] = new Array('��/��','����','�޼���','����','�ϱ�','����','������','�߱�','�޼���');
     	cnt[4] = new Array('��/��','��籸','����','������','����','����Ȧ��','����','����','������','�߱�','��ȭ��','������');
     	cnt[5] = new Array('��/��','���걸','����','����','�ϱ�','����');
     	cnt[6] = new Array('��/��','�����','����','����','������','�߱�');
     	cnt[7] = new Array('��/��','����','����','�ϱ�','�߱�','���ֱ�');
     	cnt[8] = new Array('��/��','����Ư����ġ��');
     	cnt[9] = new Array('��/��','����','��õ��','�����','������','������','�����ֽ�','����õ��','��õ��','������','������','�����','�Ȼ��','�Ⱦ��','�����','�ǿս�','�����ν�','���ý�','�ϳ���','����','���ֽ�','������','�ȼ���','���ֽ�','����','���ֱ�','��õ��','���ν�','��õ��','���ֽ�','��õ��','ȭ����');
     	cnt[10] = new Array('��/��','������','���ؽ�','��ô��','���ʽ�','���ֽ�','��õ��','�¹��','����','�籸��','��籺','������','������','������','ö����','��â��','ȫõ��','ȭõ��','Ⱦ����');
     	cnt[11] = new Array('��/��','��õ��','û�ֽ�','���ֽ�','���걺','�ܾ籺','������','������','��õ��','������','��õ��','û����','����');
     	cnt[12] = new Array('��/��','���ֽ�','���ɽ�','�����','�ƻ��','õ�Ƚ�','�ݻ걺','��걺','������','�ο���','��õ��','���ⱺ','���걺','û�籺','�¾ȱ�','ȫ����');
     	cnt[13] = new Array('��/��','�����','������','������','�ͻ��','���ֽ�','������','��â��','���ֱ�','�ξȱ�','��â��','���ֱ�','�ӽǱ�','�����','���ȱ�');
     	cnt[14] = new Array('��/��','�����','���ֽ�','������','��õ��','������','��õ��','������','���ﱺ','���','���ʱ�','��籺','���ȱ�','������','�žȱ�','��õ��','������','���ϱ�','�ϵ���','�强��','���ﱺ','������','����','�س���','ȭ����');
     	cnt[15] = new Array('��/��','����','���ֽ�','���̽�','��õ��','�����','���ֽ�','�ȵ���','���ֽ�','��õ��','���׽�','��ɱ�','������','��ȭ��','���ֱ�','������','���籺','��õ��','�︪��','������','�Ǽ���','û����','û�۱�','ĥ�');
     	cnt[16] = new Array('��/��','������','���ؽ�','�����','�о��','��õ��','����','���ֽ�','���ؽ�','â����','�뿵��','��â��','����','���ر�','��û��','����','�Ƿɱ�','â�籺','�ϵ���','�Ծȱ�','�Ծ籺','��õ��');
     	cnt[17] = new Array('��/��','��������','���ֽ�','�����ֱ�','�����ֱ�');

     	function county_change(add) {
     		var sel=document.form1.county
       		/* �ɼǸ޴����� */
       		for (i=sel.length-1; i>=0; i--){
        		sel.options[i] = null
        	}
       		/* �ɼǹڽ��߰� */
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
<body>
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 				value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 				value="<%=rent_l_cd%>">
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">  
  <input type='hidden' name="client_id_old"		value="<%=client.getClient_id()%>">    
  <input type='hidden' name="from_page" 	value="/fms2/lc_rent/lc_cng_client_frame.jsp">
  <input type='hidden' name="cng_fee_tm"  value="">
  <input type='hidden' name="cms_bank"    value="">
  <input type='hidden' name="cms_bank_cd"    value="">
  <input type='hidden' name="o_insur_per" value="<%=cont_etc.getInsur_per()%>">
  <input type='hidden' name="o_gi_st"     value="<%=gins.getGi_st()%>">
  <input type='hidden' name="o_gi_amt"     value="<%=gins.getGi_amt()%>">
  <input type="hidden" name="lkas_yn" id="lkas_yn" value="<%=cont_etc.getLkas_yn()%>"><!-- ������Ż ������ -->
  <input type="hidden" name="ldws_yn" id="ldws_yn" value="<%=cont_etc.getLdws_yn()%>"><!-- ������Ż ����� -->
  <input type="hidden" name="aeb_yn" id="aeb_yn" value="<%=cont_etc.getAeb_yn()%>"><!-- ������� ������ -->
  <input type="hidden" name="fcw_yn" id="fcw_yn" value="<%=cont_etc.getFcw_yn()%>"><!-- ������� ����� -->
  <input type="hidden" name="ev_yn" id="ev_yn" value="<%=cont_etc.getEv_yn()%>"><!-- ������ ���� -->
  <input type="hidden" name="hook_yn" id="hook_yn" value="<%=cont_etc.getHook_yn()%>"><!-- ���ΰ� -->
  <input type='hidden' name="car_no"    value="<%=cr_bean.getCar_no()%>">  
  <input type='hidden' name="st"    value="">
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
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
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
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
	<%if(!cont_etc.getRent_suc_dt().equals("")){%>
	<tr>
	    <td>&nbsp;* ���°����� : <%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%></td>
	</tr>
	<%}else{%>
	<tr>
	    <td>&nbsp;</td>
	</tr>
	<%} %>
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
    				
    				
    				
    				if(!fees.getCon_mon().equals("")){%>	
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
	    <td class=h></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ʰ�����δ��</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <!--�ʰ�����δ�� ����-->
                <tr>
                    <td class='title' width='13%'>������������Ÿ�</td>
                    <td width='15%'>&nbsp;
						<input type='text' name='o_agree_dist' size='6' value='<%=AddUtil.parseDecimal(f_fee_etc.getAgree_dist())%>' class='whitenum' readonly>
					km����/1��
					</td>
                    <td class='title' width='13%'>��������Ÿ�(�ѵ�)</td>
                    <td width='35%'>&nbsp;
						<input type='text' name='o_y_agree_dist' size='6' value='' class='whitenum' readonly>
					km (�����������Ÿ�*�뿩�ϼ�<input type='text' name='o_rent_days' size='2' value='' class='whitenum' readonly>/365)
					</td>					
                    <td class='title' width='13%'>��������Ÿ�(������)</td>
                    <td width='11%'>&nbsp;
						<input type='text' name='o_over_bas_km' size='6' value='<%=AddUtil.parseDecimal(f_fee_etc.getOver_bas_km())%>' class='whitenum' readonly>
					km
					</td>
                </tr>
                <tr>
                    <td class='title'>�ʰ�����Ÿ� �������</td>
                    <td colspan='5'>&nbsp;
						<input type='text' name='o_b_agree_dist' size='6' value='' class='whitenum' readonly>
					km (��������Ÿ�(�ѵ�)+��������Ÿ�(������)+���񽺸��ϸ���(1000km))
					</td>
                </tr>                
                
                <tr>
                    <td class='title'>��������Ÿ�</td>
                    <td colspan='5'>&nbsp;                      
						<input type='text' name='o_sh_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>' class='whitenum' readonly>
					km
					&nbsp;&nbsp; 
					(�ǰ����� �Ʒ��� "��������Ÿ�" �� �������� ���˴ϴ�.)
					</td>
                </tr>				
                
                <tr>
                    <td class='title'>�ʰ�����Ÿ�</td>
                    <td colspan='5'>&nbsp;
						<input type='text' name='o_over_agree_dist' size='6' value='' class='whitenum' readonly>
					km &nbsp;&nbsp; 
					<input type='text' name='o_over_agree_dist_nm' size='6' value='' class='whitetextredb' readonly>
					&nbsp;&nbsp; 
					<input type="button" class="button" id="over_agree_pop" value='�󼼺���' onclick="javascript:view_over_agree();">
					&nbsp;&nbsp; 
					(��������Ÿ�-�ʰ�����Ÿ� �������(����Ÿ�)
					</td>
                </tr>   
                <tr>
                    <td width="13%" class='title'> �ֱ�����Ÿ� </td>
                    <td  colspan='5'>&nbsp;
        			  <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>' class='whitenum' >
					km
					(
					�������� <input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value);'>
					)
					
					  <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="����Ÿ��̷�"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>
					</td>
                </tr>			                
                                
            </table>
	    </td>
    </tr>
    <tr>
        <td>* �� �ʰ�����Ÿ��� ��������Ÿ��� �������� ����� �����Դϴ�.</td>
    </tr>			
	<tr>
	    <td class=h></td>
	</tr>	     	
	<%if(settle_size>0 && settle_amt>0 ){ //�̳�ä���� ������%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳�ä��</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title' rowspan='2'>����</td>
                    <td class='title'>������</td>
                    <td class='title'>�뿩��</td>                    
                    <td class='title'>��ü����</td>					
                    <td class='title'>���·�</td>
                    <td class='title'>��å��</td>
                    <td class='title'>��/������</td>
                    <td class='title'>���������</td>
                    <td class='title'>�ܱ���</td>	
                </tr>
                <tr> 
                    <%	for(int j=1; j<9; j++){%>
                    <td align='right'><%=Util.parseDecimal(amt[j])%></td>
                    <%  } %>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <%if(settle_size>0 && r_settle_amt>0 && !user_id.equals("000029")){ //�޴����Ḧ ������ �̳�ä���� ������%>	
	<tr>
	    <td> * �޴����Ḧ ������ �̳�ä���� �ֽ��ϴ�. �̳�ä�� �ذ��� �°����Ͻʽÿ�. </td>
	</tr>    
</table>
</form>

	<%}else{%>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1;'></td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>��������</td>
                    <td width="20%">&nbsp;
        			  <input type='hidden' name="cls_st" value="5">
        			  ���°� 
        			  </td>
                    <td width='10%' class='title'>������</td>
                    <td width="20%">&nbsp;
        			  <input type='text' name='cls_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'> 
                    </td>
                    <td class='title' width="10%">�̿�Ⱓ</td>
                    <td>&nbsp;
        			  <input type='text' name='r_mon' value='' class='text' size="2">
                      ���� 
                      <input type='text' name='r_day' value='' class='text' size="2">
                      �� </td>
                </tr>
                <tr> 
                    <td class='title'>�������� </td>
                    <td colspan="5">&nbsp;
        			  <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���°���</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��ȣ/����</td>
                    <td width='50%' align='left'>&nbsp;
                      <input type='text' name="firm_nm" size='50' class='text' readonly>
        			  <input type='hidden' name='client_id' value=''>
        			  <input type='hidden' name='client_st' value=''>
        			  <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  </td>
                    <td width='10%' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp;
                      <input type='text' name="client_nm" value='' size='22' class='whitetext' readonly></td>
                </tr>
                <tr>
                    <td class='title'>����/����</td>
                    <td height="26" colspan="3" class='left'>&nbsp; 
        			  <input type='text' name="site_nm" value='' size='50' class='text' readonly>
        			  <input type='hidden' name='site_id' value=''>
        			  <span class="b"><a href='javascript:search_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			</td>
                </tr>
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
                <tr>
                    <td class='title'>�����ּ�</td>
                    <td align='left'>&nbsp;
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="">
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="40" value="">
                    </td>
                    <td class='title'>����������</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
                </tr>	
                <tr>
                    <td class=title width=13%>�����̿�����</td>
                    <td  colspan="3">&nbsp;
								<select name='est_area' onchange="county_change(this.selectedIndex);">
								   <option value=''>��/��</option>
								   <option value='����'>����Ư����</option>
								   <option value='�λ�'>�λ걤����</option>
								   <option value='�뱸'>�뱸������</option>
								   <option value='��õ'>��õ������</option>
								   <option value='����'>���ֱ�����</option>
								   <option value='����'>����������</option>
								   <option value='���'>��걤����</option>
								   <option value='����'>����Ư����ġ��</option>
								   <option value='���'>��⵵</option>
								   <option value='����'>������</option>
								   <option value='���'>��û�ϵ�</option>
								   <option value='�泲'>��û����</option>
								   <option value='����'>����ϵ�</option>
								   <option value='����'>���󳲵�</option>
								   <option value='���'>���ϵ�</option>
								   <option value='�泲'>��󳲵�</option>
								   <option value='����'>���ֵ�</option>
								</select>&nbsp;
								<select name='county'>
								   <option value=''>��/��</option>
								</select>                        
					</td>
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
                <tr id=tr_lic_no1 style="display:''">
                    <td class='title'>����� ���������ȣ</td>
		            <td colspan='3'>&nbsp;<input type='text' name='lic_no' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
						<input type="hidden" name="ssn" value="">
					</td>
		            <td>&nbsp;(����,���λ����)&nbsp;�� ������� ���������ȣ�� ����</td>
                </tr>
                <tr id=tr_lic_no2 style="display:''">
                    <td class='title' width='13%'>�����̿��� ���������ȣ</td>
		            <td width='15%'>&nbsp;<input type='text' name='mgr_lic_no' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='20%'>&nbsp;�̸� : <input type='text' name='mgr_lic_emp' value=''  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'</td>
		            <td width='12%'>&nbsp;���� : <input type='text' name='mgr_lic_rel' value=''  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='40%'>&nbsp;(���λ����)&nbsp;�� ����ڰ� �������㰡 ���� ��� �����̿����� �������㸦 �Է�</td>
                </tr>  
                <tr id=tr_lic_no3 style="display:''">
                    <td class='title'>�߰������� ���������ȣ</td>
		            <td>&nbsp;<input type='text' name='mgr_lic_no5' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;�̸� : <input type='text' name='mgr_lic_emp5' value=''  size='10' class='text'></td>
		            <td>&nbsp;���� : <input type='text' name='mgr_lic_rel5' value=''  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;������� : <select name='mgr_lic_result5'>
        		          		<option value=''>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select>&nbsp;�� ��༭�� "�����ڹ���" ���� �����ڸ� �߰������ڷ� ����ϴ� ��쿡�� �߰������� ���������� ����</td>
                </tr>                
                <!-- �����ڰݰ������ -->
                <tr>
                    <td class='title' rowspan='2' width='13%'>�������� �����ڰݰ���</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;���������(�̸�) : <input type='text' name='test_lic_emp' value=''  size='8' class='text'></td>
		            <td width='12%'>&nbsp;���� : <input type='text' name='test_lic_rel' value=''  size='10' class='text'></td>
		            <td width='40%'>&nbsp;������� : <select name='test_lic_result'>
        		          		<option value='' <%if(base.getTest_lic_result().equals("")) out.println("selected");%>>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;�� ���ΰ��� ����� ������, ���λ����/���λ���� ���� ��༭�� �����̿����� �����ڰ��� ����</td>
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
                    <td width="3%" rowspan="7" class=title>��<br>��<br>��</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="10%">�ٹ�ó</td>			
                    <td class=title width="10%">�μ�</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="13%">��ȭ��ȣ</td>
                    <td class=title width="13%">�޴���</td>
                    <td width="16%" class=title>E-MAIL</td>
                    <td width="5%" class=title>��ȸ</td>
                </tr>
    		  <%for(int i=0; i<=3; i++){%>
                <tr> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%if(i==0) out.println("�����̿���"); else if(i==1) out.println("����������"); else if(i==2) out.println("ȸ�������"); else if(i==3) out.println("�������");%>' class='white' readonly ></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_email' size='18' class='text' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: inactive'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		  <%	} %>
                <tr> 
                    <td colspan="2" class=title>�����̿��� �ǰ����� �ּ�</td>
					<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip1').value = data.zonecode;
								document.getElementById('t_addr1').value = data.address;
								
							}
						}).open();
					}
				</script>
                    <td colspan="7">&nbsp;
						<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=base.getP_zip()%>">
						<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr1" size="65" value="<%=base.getP_addr()%>">
					</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_client_share_st style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>������������</td>
                    <td colspan="4" align='left'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' onClick="javascript:cng_input4()">
        				�ִ�
        	      <input type='radio' name="client_share_st" value='2' onClick="javascript:cng_input4()">
        				����</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr id=tr_client_share_st_test style="display:none"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                     
                <tr>
                    <td width='13%' class='title' rowspan='2'>�������� �����ڰݰ���</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;���������(�̸�) : <input type='text' name='test_lic_emp2' value=''  size='8' class='text'></td>
		            <td width='12%'>&nbsp;���� : <input type='text' name='test_lic_rel2' value=''  size='10' class='text'></td>
		            <td width='40%'>&nbsp;������� : <select name='test_lic_result2'>
        		          		<option value=''>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;(����)&nbsp;�� ���ΰ��� ������������ �ִ� ��� �����ڰ��� ����</td>
                </tr>  
            </table>  
        </td>
    </tr>           	    
    <tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ���뺸��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr id=tr_client_guar_st style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1' onClick="javascript:cng_input2()" checked>
        				�Ժ�
        			  <input type='radio' name="client_guar_st" value='2' onClick="javascript:cng_input2()">
        				����</td>
                </tr>
                <tr id=tr_client_guar style='display:none'>
                    <td class='title'>��������</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <select name='guar_con'>
                          <option  value="">����</option>
                          <option value="6">��ǥ��������</option>
                          <option value="1">�ſ�������</option>
                          <option value="2">���������δ�ü</option>
                          <option value="3">�����������δ�ü</option>
                          <option value="5">�����濵��</option>
                          <option value="4">��Ÿ ����ȹ��</option>
                        </select>
                    </td>
                    <td width="10%" class='title'>������</td>
                    <td class='left'>&nbsp;
        			  <select name="guar_sac_id">
        			    <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
        			</td>
                </tr>
            </table>  
        </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뺸���� (��ǥ ��)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="guar_st" value='1' onClick="javascript:cng_input()">
        				�Ժ�
        			  <input type='radio' name="guar_st" value='2' onClick="javascript:cng_input()" checked>
        				����</td>
                </tr>
                <tr id=tr_guar2 style='display:none'>
                    <td height="26" colspan="4" class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width="13%" class=title>����</td>
                                <td width="10%" class=title>����</td>
                                <td width="15%" class='title'>�������</td>
                                <td width="28%" class='title'>�ּ�</td>
                                <td width="13%" class='title'>����ó</td>
                                <td width="16%" class='title'>����</td>
                                <td width="5%" class='title'>��ȸ</td>
                            </tr>
                            <%for(int i=0; i<3; i++){%>
                            <tr>
                                <td class=title>���뺸����<input type='hidden' name='gur_id' value='<%=i+1%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" maxlength='8' class='text' value=''></td>
                                <td align="center"><input type="text" name="t_zip"  size="7"   class='text' value=''>&nbsp;<input type='text' name="t_addr" size='25' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value=''></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                      <%}%>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ſ�������</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" rowspan="2" class=title>����ſ���</td>
                    <td colspan="2" class=title>�ɻ�</td>
                    <td colspan="2" class=title>����</td>
                </tr>
                <tr>
                    <td width="20%" class=title>�����</td>
                    <td width="20%" class='title'>��������</td>
                    <td width="20%" class=title>������</td>
                    <td width="27%" class='title'>��������</td>
                </tr>
                <tr>
                    <td align="center">
                     <select name='dec_gr'>
                          <%if(base.getCar_gu().equals("1")){//����%>
                          <option value="2" >�ʿ췮���</option>
                          <option value="1" >�췮���</option>
                          <%}else if(base.getCar_gu().equals("0")){//�縮��%>
                          <option value="1" >�췮���</option>
                          <option value="0" >�Ϲݰ�</option>
                          <%}%>
                      </select>
                    </td>
                    <td align="center">
                        -
                     <input type="hidden" name="dec_f_id" value="">
                   </td>
                   <td align="center"><input type='text' name='dec_f_dt' size='11' maxlength='20' class='text' value="" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                   <td align="center">
                        -                         
                     <input type="hidden" name="dec_l_id" value="">
                   </td>
                   <td align="center"><input type='text' name='dec_l_dt' size='11' maxlength='20' class='whitetext' value="" disabled ></td>
                </tr>
            </table>
        </td>
    </tr>	
	<tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���°�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>���°���</td>
                    <td width='20%'>&nbsp;
        			  <input type='text' name='rent_suc_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
                    </td>
                    <td width='10%' class='title'>�����ε���</td>
                    <td>&nbsp;
        			  <input type='text' name='car_deli_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
		<tr>
                    <td class=title width=13%>�°���� ����Ÿ�</td>
                    <td colspan='3'>&nbsp;
    			    	<input type='text' size='11' name='rent_suc_dist' maxlength='10' class='defaultnum' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  km
		    </td>					
		</tr>    		                  						
		<tr>
                    <td class=title width=13%>���-�°��Ʈ</td>
                    <td colspan='3'>&nbsp;
    			    	<textarea name="rent_suc_route" cols="100" class="text" style="IME-MODE: active" rows="3"></textarea> 						
		    </td>					
		</tr>    		                  						
                <tr>
                    <td width='13%' class='title'>�������</td>
                    <td width='20%'>&nbsp;
        			  <select name='ext_agnt'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
                    </td>
                    <td width='10%' class='title'>�����븮��</td>
                    <td>&nbsp;
                    	<%if(acar_de.equals("1000")){%>
                    	<input type='hidden' name='bus_agnt_id' 		value=''>
                    	<%}else{%>
        			  <select name='bus_agnt_id'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
                      <%}%>
                    </td>
                </tr>	
    		</table>
	    </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�°������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>�°������</td>
                    <td colspan='3'>&nbsp;
                        <input type='text' size='11' name='rent_suc_commi' maxlength='10' class='defaultnum' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                        <input type='hidden' name='commi_s_amt' value='0'>
                        <input type='hidden' name='commi_v_amt' value='0'>	
                        <!--
                        <br>&nbsp;
                        <input type="checkbox" name="tax_req" value="Y" checked> ��꼭 �����Ѵ�. <b><font color=red>(���� �°������ ��꼭 ������ ���� ��� üũ���ּ���.)</font></b>
                        -->
                        <br>
                        <hr>
                        &nbsp;
                        * ����°������ : <input type='text' size='11' name='rent_suc_commi_est' maxlength='10' class='whitenum' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                        <%if(AddUtil.parseInt(AddUtil.getDate(4)) < 20170220){//20170220 ���� 0.7*1.1%>
                        (�����Һ��ڰ� <%=AddUtil.parseDecimal(car_amt)%>��*0.7%*1.1, �ΰ�������)                        
                        <%}else{%>                        
                        (�����Һ��ڰ� <%=AddUtil.parseDecimal(car_amt)%>���� 0.8%, �ΰ�������)
                        <%}%> 
                    </td>
                </tr>
                <tr>
                    <td width='13%' class='title'>�°������ �������</td>
                    <td width='37%'>&nbsp;
                        <select name='rent_suc_exem_cau' onChange="javascript:getSucCommi();">
                            <option value="">����</option>
                            <option value="1">���� ��ȯ (���װ���)</option>
                            <option value="2">�̿��� ���� (50%����)</option>
                            <option value="3">�������� Ư������</option>
                            <option value="4">��Ÿ (���� ���� �Է�)</option>
                        </select>       
                        <input type='text' name='rent_suc_exem_cau_sub' size='30' class='text'>               
                    </td>
                    <td width='10%' class='title'>�����ᰨ�� ������</td>
                    <td width='40%'>&nbsp;
                      <select name='rent_suc_exem_id'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>        			  
                    </td>                
                </tr>                     
                <tr>
                    <td width='13%' class='title'>���δ���</td>
                    <td colspan='3'>&nbsp;
        			  <input type="radio" name="rent_suc_commi_pay_st" value="1" >
        			    ������� (<%=client.getFirm_nm()%>)
        		      <input type="radio" name="rent_suc_commi_pay_st" value="2" checked>
        		    	���°��� 
						&nbsp;&nbsp;
						<b><font color=red>(���δ��� ���ÿ� ���� �°������ �������� �����˴ϴ�.)</font></b>
                    </td> 
                </tr>						
                <tr>
                    <td class='title'>�Աݿ�����</td>
                    <td colspan='3'>&nbsp;
        			  <input type='text' name='rent_suc_commi_est_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
					  <b><font color=red>(�°������ �Աݿ����� - ���� ����� ������ ä�ǿ� ��Ÿ���ϴ�.)</font></b>
                    </td>
                </tr>								
    		</table>
	    </td>
    </tr>    	 
    <tr>
	    <td class=h></td>
	</tr> 	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�� ������ �̰�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>�̰�ȸ��</td>
                    <td>&nbsp;
        			  <%	if(ht_size > 0){%>
        						<select name='fee_tm'>
        						   <option value="">����</option>
        					<%		for(int i = 0 ; i < ht_size ; i++){
        								FeeScdBean bean = (FeeScdBean)ht.elementAt(i);
        								if(i==0){
        									fee_scd = bean;
        								}
        								if(bean.getTm_st2().equals("4")) continue;			
        					%>
        							<option value='<%=bean.getFee_tm()%>'>[<%=AddUtil.addZero(bean.getFee_tm())%>ȸ��] <%=AddUtil.ChangeDate2(bean.getFee_est_dt())%> <%if(bean.getRc_yn().equals("0")){%>���Ա�<%}else{%>�Ա�<%}%></option>
        					<%		}%>
								  <option value="9999">�̰�ȸ������</option>
        						</select> ȸ
                		      &nbsp;(����ȸ������ ��� ȸ�� �̰�)
							  <!--
							  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;							  
							  <input type="checkbox" name="tax_cng_yn" value="Y" checked> ����� ��꼭�� ���� ��� �°��ϴ� ����ȣ�� ����
							  -->
        					<%	}else{%>
        						���ð����� ȸ���� �����ϴ�.
        					<%	}%>	
        					
        		&nbsp;
        		/ ���ڰ��������� : <input type='text' name='rent_suc_fee_tm_b_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>			
                    </td>
                </tr>
    		</table>
	    </td>
    </tr>	  
    <tr>
	    <td class=h></td>
	</tr> 		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ �°迩��</span>&nbsp; (�̻��Ⱓ <input type='text' name='n_mon' value='' class='whitetext' size="2" readonly>
                      ���� 
                      <input type='text' name='n_day' value='' class='whitetext' size="2" readonly>
                      ��)</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>������</td>
                    <td>&nbsp; 
					  �ݾ� : <input type='text' size='11' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        				  ��, 
					  �°迩�� : 
        			  <select name='grt_suc_yn'>
                              <option value="">����</option>
                              <option value="0">�°�</option>
                              <option value="1">����</option>
                            </select>	
							
					 &nbsp;(�°迩�θ� �°�� �ϸ� ���� ������ �������� ������Ű��, ������ �����ϸ� �ű� �������� �����˴ϴ�.)
					 <input type='hidden' name="o_grt_s_amt" value="<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>">
                    </td>
                </tr>
    		</table>
	    </td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>������</td>
                    <td>&nbsp; 
					  �ݾ� : <input type='text' size='11' maxlength='10' name='pp_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        				  ��, 
        				   �°迩�� : 
        			  <select name='pp_suc_yn'>
                              <option value="">����</option>
                              <option value="0">�°�</option>
                              <option value="1">����</option>
                            </select>	
                            &nbsp;&nbsp;
							<span class="b"><a href="javascript:set_reqamt('pp_amt')" onMouseOver="window.status=''; return true" title="������ ����մϴ�."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
					 &nbsp;&nbsp;
					 &nbsp;(�°迩�θ� �°�� �ϸ� ���� ������ �������� ������Ű��, ������ �����ϸ� �ű� �������� �����˴ϴ�.)
					 <input type='hidden' name="o_pp_amt" value="<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>">
					 <input type='hidden' name="pp_s_amt" value="">
					 <input type='hidden' name="pp_v_amt" value="">
                    </td>
                </tr>
    		</table>
	    </td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>���ô뿩��</td>
                    <td>&nbsp; 
					  �ݾ� : <input type='text' size='11' maxlength='10' name='ifee_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        				  ��, 
        				 �°迩�� : 
        			  <select name='ifee_suc_yn'>
                              <option value="">����</option>
                              <option value="0">�°�</option>
                              <option value="1">����</option>
                            </select>	
                             &nbsp;&nbsp;
							 <span class="b"><a href="javascript:set_reqamt('ifee_amt')" onMouseOver="window.status=''; return true" title="������ ����մϴ�."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
        				  &nbsp;&nbsp;					  
					 &nbsp;(�°迩�θ� �°�� �ϸ� ���� ���ô뿩�� �������� ������Ű��, ������ �����ϸ� �ű� �������� �����˴ϴ�.)
					 <input type='hidden' name="o_ifee_amt" value="<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>">
					 <input type='hidden' name="ifee_s_amt" value="">
					 <input type='hidden' name="ifee_v_amt" value="">
                    </td>
                </tr>
    		</table>
	    </td>
    </tr>	              
    <tr>
	    <td class=h></td>
	</tr> 		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Թ��</span></td>
    </tr>	
    <tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="3%" rowspan="4" class='title'>��<br>��<br>��<br>��<br>��<br>��<br>��</td>				
                    <td width="10%" class='title'>���ݱ���</td>
                    <td width="20%">&nbsp;
                      <select name='fee_sh'>
                        <option value="">����</option>
                        <option value="0" <%if(fee.getFee_sh().equals("0")){%> selected <%}%>>�ĺ�</option>
                        <option value="1" <%if(fee.getFee_sh().equals("1")){%> selected <%}%>>����</option>
                      </select></td>
                    <td width="10%" class='title'>���ι��</td>
                    <td>&nbsp;
                      <select name='fee_pay_st'>
                        <option value=''>����</option>
                        <option value='1' <%if(fee.getFee_pay_st().equals("1")){%> selected <%}%>>�ڵ���ü</option>
                        <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>�������Ա�</option>
                        <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>����</option>
                        <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>��Ÿ</option>
                        <option value='6' <%if(fee.getFee_pay_st().equals("6")){%> selected <%}%>>ī��</option>
                      </select></td>
        			  <td class='title'>CMS�̽���</td>
        			  <td>&nbsp;
        			    ���� : <input type='text' name='cms_not_cau' size='25' value='<%//=fee_etc.getCms_not_cau()%>' class='text'>
        			  </td>			  
                </tr>					  		  		  
                <tr>
                    <td class='title'>��ġ����</td>
                    <td colspan="3">&nbsp;
                    <select name='def_st'>
                      <option value="N" <%if(fee.getDef_st().equals("N")){%> selected <%}%>>����</option>
                      <option value="Y" <%if(fee.getDef_st().equals("Y")){%> selected <%}%>>����</option>
                    </select>
        			 ���� :            
        			 <input type='text' name='def_remark' size='40' value='<%=fee.getDef_remark()%>' class='text'>
        			</td>
                    <td class='title'>������</td>
                    <td>&nbsp;
                      <select name='def_sac_id'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(fee.getDef_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
                </tr>
                <tr>
                    <td class='title'>�����Ա�</td>
                    <td colspan="5">&nbsp; 
                      <select name='fee_bank'>
                        <option value=''>����</option>
                        <%if(bank_size > 0){
        										for(int j = 0 ; j < bank_size ; j++){
        											CodeBean bank = banks[j];
        											//�ű��ΰ�� �̻������ ����
															if(bank.getUse_yn().equals("N"))	 continue;
        								%>
                              <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%= bank.getNm()%> </option>
	                      <%	}
        									}%>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>		
    <tr>
	    <td class=h></td>
	</tr> 	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>���޹޴���</td>
                    <td width="20%">&nbsp;
                      <input type="radio" name="tax_type" value="1" <% if(base.getTax_type().equals("1")) out.print("checked"); %>>
        			    ����
        		      <input type="radio" name="tax_type" value="2" <% if(base.getTax_type().equals("2")) out.print("checked"); %>>
        		    	���� </td>
                    <td width="10%" class='title' style="font-size : 8pt;">û�������ɹ��</td>
                    <td width="20%">&nbsp;
        			  <%if(cont_etc.getRec_st().equals("") && client.getEtax_not_cau().equals("")) 	cont_etc.setRec_st("1");
        			    if(cont_etc.getRec_st().equals("") && !client.getEtax_not_cau().equals("")) cont_etc.setRec_st("2");%>
                      <select name='rec_st'>
                        <option value="">����</option>					
                        <option value="1" <% if(cont_etc.getRec_st().equals("1")) out.print("selected"); %>>�̸���</option>
                        <option value="2" <% if(cont_etc.getRec_st().equals("2")) out.print("selected"); %>>����</option>
                        <option value="3" <% if(cont_etc.getRec_st().equals("3")) out.print("selected"); %>>���ɾ���</option>
                      </select>
                    </td>
                    <td width="10%" class='title' style="font-size : 8pt;">���ڼ��ݰ�꼭</td>
                    <td>&nbsp;<%if(cont_etc.getEle_tax_st().equals("") && cont_etc.getRec_st().equals("1")) cont_etc.setEle_tax_st("1");%>
                      <select name='ele_tax_st'>
                        <option value="">����</option>
                        <option value="1" <% if(cont_etc.getEle_tax_st().equals("1")) out.print("selected"); %>>���ý���</option>
                        <option value="2" <% if(cont_etc.getEle_tax_st().equals("2")) out.print("selected"); %>>�����ý���</option>
                      </select>
                      <input type='text' name='tax_extra' maxlength='10' size='15' value='<%=cont_etc.getTax_extra()%>' class='text'>
        			</td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;1. ���� ���Ե� ��������</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title >��������</td>
                    <td width="15%">&nbsp;
                        <input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='30' class='whitetext'>
					</td>
                    <td width="10%" class=title >�Ǻ�����</td>
                    <td>&nbsp;
                        <input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='30' class='whitetext'>
					</td>
                    <td width="10%" class=title >��������������Ư��</td>
                    <td width="15%">&nbsp;
                        <select name='i_com_emp_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
					</td>
                </tr>
            </table>
	    </td>		
	</tr>
    <tr>
	    <td style='height:5'></td>
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;2. ��༭�� ������ ��������</td>
	</tr>		
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                    <td width="13%" class=title >��������</td>
                    <td width="15%">&nbsp;
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                      </select>					  
		    </td>			  
                    <td width="10%" class=title >�Ǻ�����</td>
                    <td>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per'>
                          <option value="">����</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(car_st.equals("3") && cont_etc.getInsur_per().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                        </select>
		       	<b><font color=red>(�Ǻ����ڰ� ��->�Ƹ���ī, �Ƹ���ī->������ ����� ��� �������ڿ��� �޽��� �߼��մϴ�.)</font></b>
		    </td>	
                <td width="10%" class=title >��������������Ư��</td>
                <td width="15%">&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">����</option>
                    <option value="Y">����</option>
                    <option value="N">�̰���</option>
                  </select>                  
                  </td>
              </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="7">&nbsp;
                        <input type='radio' name="gi_st" value='1' >
                  		����
                  		<input type='radio' name="gi_st" value='0' >
                  		���� </td>
                </tr>                
                <tr>
                    <td class=title>��������</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value=''>
        			   <input type='text' name='gi_jijum' value='' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>���Աݾ�</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                  	<!-- �������� ���԰��� �߰�(2018.03.16) -->
                  	<td class=title >���ԱⰣ</td>
                  	<td>&nbsp;	
                  		<input type='text' name='gi_month' size='5' maxlength='2' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt()'>
                  	����</td>
                    <td class=title >���������</td>
                    <td>&nbsp;
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                </tr>	
            </table>
        </td>
    </tr>      		
    <tr>
        <td>&nbsp;</td>
    </tr>
	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr>
		<td align="right"><a id="submitLink" href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
	<%}%>
</table>
</form>
<script language="JavaScript">
<!--	
	getSucCommi();
//-->
</script>
<%}%>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--		
	var fm = document.form1;
	
	//�ʰ�����
	var fw_917 = getRentTime('l', '<%=fee.getRent_start_dt()%>', '<%=ext_fee.getRent_end_dt()%>');
	
	if ( '<%=taecha_st_dt%>'  != '' )  {
		fw_917 = getRentTime('l', '<%=taecha_st_dt%>', '<%=ext_fee.getRent_end_dt()%>');
	}
	
	fm.o_rent_days.value = fw_917;
	
	fm.o_y_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_agree_dist.value))*fw_917/365);
	
	fm.o_b_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_y_agree_dist.value))+toInt(parseDigit(fm.o_over_bas_km.value))+1000);
	
	fm.o_over_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_sh_km.value))-toInt(parseDigit(fm.o_b_agree_dist.value)));
	if(toInt(parseDigit(fm.o_over_agree_dist.value)) <=0){
		fm.o_over_agree_dist_nm.value = '�ѵ���';
	}
	if(toInt(parseDigit(fm.o_over_agree_dist.value)) >0){
		fm.o_over_agree_dist_nm.value = '�ѵ��ʰ�';
	}	
	
	//�ϼ� ���ϱ�
	function getRentTime(gubun, d1, d2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var t1;
		var t2;
		var t3;		
		t1 = getDateFromString(replaceString('-','',d1)).getTime();
		t2 = getDateFromString(replaceString('-','',d2)).getTime();
		t3 = t2 - t1;
		if(gubun=='m') return parseInt(t3/m);
		if(gubun=='l') return parseInt(t3/l);
		if(gubun=='lh') return parseInt(t3/lh);
		if(gubun=='lm') return parseInt(t3/lm);	
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}			
		
//-->
</script>
</body>
</html>	
