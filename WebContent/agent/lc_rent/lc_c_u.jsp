<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_office.*, acar.doc_settle.*, acar.con_ins.*, acar.consignment.*"%>

<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>

<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase"      scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean"             scope="page"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>

<%@ include file="/agent/cookies.jsp" %>

<%
	
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�ڵ����⺻����-�⺻����
	CarMstBean cm_bean2 = cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//��������
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}		
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
			
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
		
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));	
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	//���뺸��������
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	if(cont_etc.getGuar_st().equals("2")) gur_size = 0;
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, rent_st);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//����ǰ��
	DocSettleBean commi_doc = d_db.getDocSettleCommi("1", rent_l_cd);
	
	DocSettleBean doc4 = d_db.getDocSettleCommi("4", rent_l_cd);
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);
	
	//Ư�ǰ������
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);	
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	
	//�����Ҹ���Ʈ
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	if(rent_st.equals("")) rent_st = "1";
	
	
	String valus = 	"?user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(max_fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}	
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(max_fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
	}	
	
	String car_ins_chk = "N";
	
	if(!ins.getCar_mng_id().equals("")){
		car_ins_chk = "Y";
	}				
	
	//���� ���Ź�� ����� �ִ��� Ȯ��
	ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
	
	//���������
	int grt_suc_fee_size = 0;
	ContFeeBean grt_suc_fee = new ContFeeBean();
	
	if(!cont_etc.getGrt_suc_l_cd().equals("")){
		grt_suc_fee_size = af_db.getMaxRentSt(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
		grt_suc_fee = a_db.getContFeeNew(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd(), grt_suc_fee_size+"");		
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
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;	
	}

	//���������ݽ°���ȸ
	function search_grt_suc()
	{
		var fm = document.form1;	
		window.open("/agent/car_pur/s_grt_suc.jsp?from_page=/agent/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ��ȸ
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		window.open("/agent/client/client_site_s_p.jsp?user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("���õ� ������ �����ϴ�."); return;}
		window.open("/agent/client/client_site_i_p.jsp?cmd=view&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	
	//������ ��ȸ
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_mgr.jsp?from_page=lc_c_u&idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
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
	
	//���뺸����
	function guar_display(){
		var fm = document.form1;
		var size = toInt(fm.gur_size.value);
		if(fm.guar_st[0].checked == true){ 				//����
			tr_guar2.style.display	= '';
		}else{											//����
			tr_guar2.style.display	= 'none';
		}
	}	
	
	//������ ��ȸ
	function search_gur(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_gur.jsp?idx="+idx+"&client_id="+fm.client_id.value, "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//���� üũ
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');
		}
	}
	

	//4�ܰ� -----------------------------------------------------------
		
	//�������� ���÷���
	function display_gi(){
		var fm = document.form1;
		if(fm.gi_st[0].checked == true){	//����
			tr_gi1.style.display		= '';
		}else{								//����
			tr_gi1.style.display		= 'none';
		}		
	}	
	

	//����������� ���÷���
	function display_tae(){
		var fm = document.form1;
		if(fm.prv_dlv_yn[0].checked == true){	//����
			tr_tae2.style.display		= 'none';
		}else{									//�ִ�
			tr_tae2.style.display		= '';
		}		
	}		

	//��������� ��ȸ
	function car_search(st)
	{
		var fm = document.form1;
		window.open("search_res_car.jsp?taecha=Y&client_id=<%=base.getClient_id()%>", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");
	}	
	
	//�����Ҵ���� ��ȸ
	function search_emp(st){
		var fm = document.form1;
		var one_self = "N";
		var pur_bus_st = "4"; //������Ʈ����
		if('<%=pur.getOne_self()%>' == 'Y') one_self = "Y";
		window.open("search_emp.jsp?from_page=lc_c_u.jsp&bus_id=<%=base.getBus_id()%>&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self="+one_self+"&pur_bus_st="+pur_bus_st+"&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");						
		//window.open("search_emp.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self=<%=pur.getOne_self()%>&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");		
	}
	//�����Ҵ���� �Է����
	function cancel_emp(st){
		var fm = document.form1;
		if(st == 'BUS'){
			fm.emp_nm[0].value = '';
			fm.emp_id[0].value = '';
			fm.car_off_nm[0].value = '';
			fm.car_off_id[0].value = '';
			fm.car_off_st[0].value = '';
			fm.cust_st.value = '';
			fm.comm_rt.value = '';
			fm.comm_r_rt.value = '';
			fm.ch_remark.value = '';
			fm.ch_sac_id.value = '';
		}else{
			fm.emp_nm[1].value = '';
			fm.emp_id[1].value = '';
			fm.car_off_nm[1].value = '';
			fm.car_off_st[1].value = '';
			fm.car_off_id[1].value = '';
		}		
	}
	
	//��� �����Ҵ���ڸ� ���� �����Ҵ���� ��ó��
	function set_emp_sam(){
		var fm = document.form1;	
		if(fm.emp_chk.checked == true){			
			fm.emp_nm[1].value = fm.emp_nm[0].value;
			fm.emp_id[1].value = fm.emp_id[0].value;
			fm.car_off_nm[1].value = fm.car_off_nm[0].value;
			fm.car_off_st[1].value = fm.car_off_st[0].value;		
		}else{
			cancel_emp('DLV');
		}			
	}

	//����������
	function setCommi(){
		var fm = document.form1;
		
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));		
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
		
		fm.commi.value = parseDecimal(th_round(car_price*comm_r_rt/100));
				
	}
	

	//����
	function update(){
		var fm = document.form1;
		
		var cng_item = fm.cng_item.value;
		
		<%if(cng_item.equals("client")){%>
		
			if(fm.t_addr.value == '')	{ alert('�����ּҸ� Ȯ���Ͻʽÿ�.'); 		return;}
			
			//����,���λ���ڴ� ���������ȣ �ʼ�
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
			}else if(fm.client_st.value == '1'||fm.client_st.value == '6'){	//����
				if(fm.ssn.value==""){
					if(fm.lic_no.value == '' || fm.lic_no.value.length < 12){
						alert('���ι�ȣ�� ���� ���������� ��쿡�� ���������ȣ�� �Է��Ͻʽÿ�.');
						return;
					}
				}
			}			
			
		<%}else if(cng_item.equals("mgr")){%>			
			
			<%for(int i = 0 ; i <= mgr_size ; i++){%>
				if(fm.email_1[<%=i%>].value != '' && fm.email_2[<%=i%>].value != ''){
					fm.mgr_email[<%=i%>].value = fm.email_1[<%=i%>].value+'@'+fm.email_2[<%=i%>].value;
				}
				if(fm.email_1[<%=i%>].value == '' && fm.email_2[<%=i%>].value == ''){
					fm.mgr_email[<%=i%>].value = '';
				}
			<%}%>
			
		
		<%}else if(cng_item.equals("client_guar")){%>
		
			if(fm.client_guar_st[1].checked == true){		
				if(fm.guar_con.options[fm.guar_con.selectedIndex].value == '')		{ alert('��ǥ�̻纸�� ���������� �����Ͻʽÿ�.'); 		return;}			
				if(fm.guar_sac_id.options[fm.guar_sac_id.selectedIndex].value == ''){ alert('��ǥ�̻纸�� ���������ڸ� �����Ͻʽÿ�.'); 	return;}						
			}
			
		<%}else if(cng_item.equals("guar")){%>			
					
			if(fm.guar_st[0].checked == true){
				if(fm.gur_nm[0].value == '')	{ alert('���뺸���� ������ �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_id[0].value == '')	{ alert('���뺸���� ��������� �Է��Ͻʽÿ�.'); 	return;}
				if(fm.t_addr[0].value == '')	{ alert('���뺸���� �ּҸ� �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_tel[0].value == '')	{ alert('���뺸���� ����ó�� �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_rel[0].value == '')	{ alert('���뺸���� ���踦 �Է��Ͻʽÿ�.'); 			return;}												
			}
		

						
		<%}else if(cng_item.equals("car")){%>		
			
// 			if(fm.color.value == '')					{ alert('�뿩����-������ �Է��Ͻʽÿ�.'); 					fm.color.focus(); 			return; }
			
			// ��޽��� �߰� 2017.12.26
			if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
				alert('�������(�⺻��), ������� �̽ð� ����, ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
			}
			if(fm.tint_s_yn.checked == true && fm.tint_ps_yn.checked == true){
				alert('�������(�⺻��)�� ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
			}
			if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true){
				alert('�������(�⺻��)�� ������� �̽ð� ���� �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
			}
			if(fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
				alert('������� �̽ð� ���ΰ� ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_ps_yn.focus(); return;
			}
			if(fm.tint_ps_yn.checked == true && fm.tint_ps_amt.value < 1){
				alert('��޽��� �ݾ��� �Է��ϼ���.'); fm.tint_ps_amt.focus(); return;
			}
			
			if(fm.tint_bn_yn.checked == true && fm.tint_bn_nm.value == ''){
				alert('���ڽ� ������ ���� ������ �����Ͻʽÿ�.'); fm.tint_bn_nm.focus(); return;
			}
			
// 			if(fm.pur_color.value != ''){
// 				if(fm.old_color.value != fm.color.value || fm.old_in_col.value != fm.in_col.value || fm.old_garnish_col.value != fm.garnish_col.value){
// 					alert('Ư�ǹ����� �ִ� ����('+fm.pur_color.value+')�ϰ� �뿩����-������ �ٸ��ϴ�. ���� ������̸� ������ ���¾�ü����-��ü���������� ����(����) ���� �����Ͻʽÿ�.');
// 				}				
// 			}

			var prev_new_license_plate = '<%=car.getNew_license_plate()%>';
			if(prev_new_license_plate == '1' || prev_new_license_plate == '2'){
				prev_new_license_plate = '1';
			} else {
				prev_new_license_plate = '0';
			}
			fm.prev_new_license_plate.value = prev_new_license_plate;
		
		<%}else if(cng_item.equals("gi")){%>		
		
			if(fm.car_st.value != '2'){
				if(fm.gi_st[0].checked == true){//����
					if(fm.gi_jijum.value == '')			{ alert('��������-���������� �Է��Ͻʽÿ�.'); 				fm.gi_jijum.focus(); 		return; }
					var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
					//var gi_fee 	= toInt(parseDigit(fm.gi_fee.value));
					if(gi_amt == 0)						{ alert('��������-���Աݾ��� �Է��Ͻʽÿ�.'); 				fm.gi_amt.focus(); 			return; }
					//if(gi_fee == 0)						{ alert('��������-��������Ḧ �Է��Ͻʽÿ�.'); 			fm.gi_fee.focus(); 			return; }
				}else if(fm.gi_st[1].checked == true){//����

				}
			}
		
		
		<%}else if(cng_item.equals("pay_way")){%>		
		
			<%if(!base.getCar_st().equals("2") && cms.getApp_dt().equals("")){%>
				if(fm.cms_acc_no.value != '')		{ 
					if ( !checkInputNumber("CMS ���¹�ȣ", fm.cms_acc_no.value) ) {		
						fm.cms_acc_no.focus(); 		return; 
					}
					//�޴���,����ó ���Ͽ��� Ȯ��
					if(replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getM_tel()%>") || replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getO_tel()%>")){
						alert("���¹�ȣ�� �޴��� Ȥ�� ����ó�� �����ϴ�. ������¹�ȣ�� �ڵ���ü�� �ȵ˴ϴ�.");
						fm.cms_acc_no.focus(); 		return; 
					}
				}
			<%}%>
		
		<%}else if(cng_item.equals("tax")){%>		
		
			if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ fm.tax_type[0].checked = true; }
			if(fm.car_st.value != '2'){		
				if(fm.rec_st.value == '')				{ alert('���ݰ�꼭-û�������ɹ���� �Է��Ͻʽÿ�.');		fm.rec_st.focus(); 			return; }
				if(fm.rec_st.value == '1'){
					if(fm.ele_tax_st.value == '')		{alert('���ݰ�꼭-���ڼ��ݰ�꼭 �ý����� �Է��Ͻʽÿ�.'); fm.ele_tax_st.focus();		return; }
					if(fm.ele_tax_st.value == '2'){
						if(fm.tax_extra.value == '')	{ alert('���ݰ�꼭-���ڼ��ݰ�꼭 �����ý��� �̸��� �Է��Ͻʽÿ�.'); fm.tax_extra.focus(); 	return; }
					}
				}
			}
		
		<%}else if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){%>		
					
			if(fm.car_gu.value == '1' || ('<%=base.getRent_st()%>' == '3' && fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>')){//���� || �����Ī���� 
				if('<%=fee.getPrv_dlv_yn()%>' == 'Y'){		
					if(fm.tae_car_no.value == '')		{ alert('���������-�ڵ����� �����Ͻʽÿ�.'); 			fm.tae_car_no.focus(); 		return; }										
					
					if('<%=base.getRent_st()%>' == '3' && fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){
						fm.tae_car_mng_id.value 	= '<%=cr_bean.getCar_mng_id()%>';
						fm.tae_car_id.value 		= '<%=cm_bean.getCar_id()%>';
						fm.tae_car_seq.value 		= '<%=cm_bean.getCar_seq()%>';
						fm.tae_car_nm.value 		= '<%=cr_bean.getCar_nm()%>';
						fm.tae_init_reg_dt.value 	= '<%=cr_bean.getInit_reg_dt()%>';						
					}

  					if(fm.tae_car_mng_id.value == '')	{ alert('���������-�ڵ����� �����Ͻʽÿ�.'); 			fm.tae_car_no.focus(); 		return; }																				
					if(fm.tae_car_rent_st.value == '')	{ alert('���������-�뿩�������� �Է��Ͻʽÿ�.'); 		fm.tae_car_rent_st.focus(); return; }
					if(fm.tae_req_st.value == '')		{ alert('���������-û�����θ� �����Ͻʽÿ�.'); 		fm.tae_req_st.focus(); 		return; }
					if(fm.tae_req_st.value == '1'){
						if(toInt(parseDigit(fm.tae_rent_fee.value)) == 0)	{ alert('���������-���뿩�Ḧ �Է��Ͻʽÿ�.'); 			fm.tae_rent_fee.focus(); 	return; }
						if(toInt(parseDigit(fm.tae_rent_inv.value)) == 0)	{ alert('���������-�������� �Է��Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
						if(fm.tae_est_id.value == '')	{ alert('���������-������ ����ϱ⸦ �Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
						<%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              			<%}else{%>
						if(fm.tae_rent_fee_st[0].checked == false && fm.tae_rent_fee_st[1].checked == false){
							alert('��������� ������ <����� ���� �뿩 ��� ������ �������> �׸� ����Ʈ �������� ǥ��Ǿ� �ִ� ��쿡 ����Ʈ �������� �Է��ϰ�, ����Ʈ �������� ǥ��Ǿ� ���� ���� ��쿡�� ���������� ǥ��Ǿ� ���� ������ üũ���ּ���.'); return;
						}else{
							if(fm.tae_rent_fee_st[0].checked == true){
								if(toInt(parseDigit(fm.tae_rent_fee_cls.value)) == 0){ alert('���� ������ �������(����Ʈ������)�� �Է��Ͻʽÿ�.'); return;									}
								if(toInt(parseDigit(fm.tae_rent_fee.value)) >= toInt(parseDigit(fm.tae_rent_fee_cls.value)))	{ alert('���� ������ �������(����Ʈ������)���� ����������� ���뿩�Ẹ�� ũ�� �ʽ��ϴ�. Ȯ���Ͻʽÿ�.'); 			fm.tae_rent_fee_cls.focus(); 	return; }
							}else{
								fm.tae_rent_fee_cls.value = 0;
							}								
						}
						<%}%>
						if(fm.tae_tae_st.value == '')	{ alert('���������-��꼭���࿩�θ� �����Ͻʽÿ�.'); 	fm.tae_tae_st.focus(); 		return; }						
					}
					if(fm.tae_sac_id.value == '')		{ alert('���������-�����ڸ� �����Ͻʽÿ�.'); 			fm.tae_sac_id.focus(); 		return; }
					if(toInt(parseDigit(fm.tae_rent_fee.value))>0){
							fm.tae_rent_fee_s.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.tae_rent_fee.value))));
							fm.tae_rent_fee_v.value 	= parseDecimal(toInt(parseDigit(fm.tae_rent_fee.value)) - toInt(parseDigit(fm.tae_rent_fee_s.value)));						
					}
					
					
					if(fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){
						var est_day = getRentTime('d', fm.tae_car_rent_st.value, fm.tae_car_rent_et.value);
						fm.end_rent_link_day.value = est_day;
						var est_amt = (<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>-<%=grt_suc_fee.getFee_s_amt()+grt_suc_fee.getFee_v_amt()%>)/<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;
						est_amt = replaceFloatRound(est_amt);
						fm.end_rent_link_per.value = est_amt;						
						if(est_day > 35 || est_amt > 30){
							tr_tae3.style.display = '';
							fm.end_rent_link_sac_id_text.value = '(�ʼ�)';
							//������üũ
							if(fm.end_rent_link_sac_id.value == ''){ alert('�����Ī���� �̰������� ���� �����ڸ� �����Ͻʽÿ�.'); fm.end_rent_link_sac_id.focus(); 		return;}
						}						
					}	
					
				}
			}
		
		<%}else if(cng_item.equals("emp1")){%>		
		
			if(fm.emp_id[0].value != ''){			
				if(fm.comm_rt.value == '')			{ alert('������翵�����-�������� �ִ���������� �Է��Ͻʽÿ�.'); 	fm.comm_rt.focus(); 		return; }
				if(fm.comm_r_rt.value == '	')		{ alert('������翵�����-�������� ������������� �Է��Ͻʽÿ�.'); 	fm.comm_r_rt.focus(); 		return; }
				if(toFloat(fm.comm_rt.value) < toFloat(fm.comm_r_rt.value)){ //�ִ������������ ������������� �� Ŭ���� ����.
					alert('������翵�����-�������� �ִ������������ ������������� �� Ŭ�� �� �����ϴ�. Ȯ���Ͻʽÿ�.'); 		fm.comm_rt.focus(); return;
				}
			}

		<%}%>

		

		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_c_u_a.jsp';		
			fm.submit();
		}							
		
		
		
	}
	

	//����
	function update2(st, rent_st){
		var height = 600;
		window.open("/agent/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM2", "left=150, top=150, width=1050, height="+height+", scrollbars=yes");
	}				
	
	
	
	function search_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}				
		
	<%if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){%>		
	//��������� �����뿩�� ��� (����)
	function estimate_taecha(st){
		var fm = document.form1;
		
		if(fm.tae_car_mng_id.value == '' && '<%=base.getRent_st()%>' == '3' && fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){
			fm.tae_car_mng_id.value 	= '<%=cr_bean.getCar_mng_id()%>';
			fm.tae_car_id.value 		= '<%=cm_bean.getCar_id()%>';
			fm.tae_car_seq.value 		= '<%=cm_bean.getCar_seq()%>';
			fm.tae_car_nm.value 		= '<%=cr_bean.getCar_nm()%>';
			fm.tae_init_reg_dt.value 	= '<%=cr_bean.getInit_reg_dt()%>';						
		}
		
		if(fm.tae_car_mng_id.value == '')	{ alert('��������� ������ �����Ͻʽÿ�.');	return;}
		if(fm.tae_car_id.value == '')		{ alert('��������� ������ �ٽ� �����Ͻʽÿ�.');	return;}
		fm.esti_stat.value 	= st;
		if(st == 'view'){ fm.target = '_blank'; }else{ fm.target = 'i_no'; }
		fm.action='get_fee_estimate_taecha.jsp';
		fm.submit();
	}
	
	//�������μ�
	function TaechaEstiPrint(est_id){ 
		var SUBWIN="/acar/secondhand_hp/estimate.jsp?from_page=<%=from_page%>&est_id="+est_id;  	
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}	
	
	<%}%>
	
	// �����ػ� �ӽÿ��ຸ��� 2018.04.19
	function openHc(){
  		window.open('/acar/common/hyundai_confidentiality.jsp','_blank', 'width=800, height=600, menubars=no, scrollbars=auto');
 	}
 	
	function SendMsg(msg_st){
		var fm = document.form1;
		fm.msg_st.value = msg_st;
		window.open('about:blank', "LC_SEND_MSG", "left=0, top=0, width=900, height=400, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "LC_SEND_MSG";
		if(msg_st=='con_amt_pay_req'){
			fm.action = "/fms2/lc_rent/lc_send_msg.jsp";
		}else{
			fm.action = "/fms2/car_pur/reg_trfamt5.jsp";
		}
		fm.submit();
	}
	
	//��������� �˻�
	function EstiTaeSearch(){
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=1100, height=800, resizable=yes, scrollbars=yes, status=yes");
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/tae_esti_history_cont.jsp';
		fm.submit();		
	}	
	
	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
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
	
	function cancel_taecha(){
		var fm = document.form1;
		fm.tae_car_no.value = '';
		fm.tae_no.value = '';
		fm.tae_car_mng_id.value = '';
		fm.tae_car_id.value = '';
		fm.tae_car_seq.value = '';
		fm.tae_s_cd.value = '';
		fm.tae_car_nm.value = '';
		fm.tae_init_reg_dt.value = '';
		fm.tae_car_rent_st.value = '';
		fm.tae_car_rent_et.value = '';
		fm.tae_f_req_yn[0].checked = false;
		fm.tae_f_req_yn[1].checked = false;
		fm.tae_rent_fee.value = '';
		fm.tae_rent_fee_s.value = '';
		fm.tae_rent_fee_v.value = '';
		fm.tae_rent_inv.value = '';
		fm.tae_rent_inv_s.value = '';
		fm.tae_rent_inv_v.value = '';
		fm.tae_est_id.value = '';
		<%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
        <%}else{%>
		fm.tae_rent_fee_st[0].checked = false;
		fm.tae_rent_fee_st[1].checked = false;
		fm.tae_rent_fee_cls.value = '';
		<%}%>
		fm.tae_req_st.value = '';
		fm.tae_tae_st.value = '';
		fm.tae_sac_id.value = '';
	}
					
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
<style type-"text/css>
<!--	
input.whitetextredb		{ text-align:left; font-size : 9pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#ff0000;  font-weight:bold;}
//-->
</style>
</head>
<body leftmargin="15">
<form action='/agent/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name="mode"				value="lc_rent">    
  <input type='hidden' name="rent_st"			value="">      
  <input type='hidden' name="rent_dt"			value="">        
  <input type='hidden' name="a_b"				value="">      
  <input type="hidden" name="fee_opt_amt"  		value=""> 
</form>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='from_page2'	 	value='/agent/lc_rent/lc_c_u.jsp'>
  <input type='hidden' name='cng_item'	 		value='<%=cng_item%>'>     
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">   
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%><%=cm_bean2.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="dpm" 				value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="s_dc1_re" 			value="<%=car.getS_dc1_re()%>">
  <input type='hidden' name="s_dc1_yn" 			value="<%=car.getS_dc1_yn()%>">
  <input type='hidden' name="s_dc1_amt"			value="<%=car.getS_dc1_amt()%>">
  <input type='hidden' name="s_dc2_re" 			value="<%=car.getS_dc2_re()%>">
  <input type='hidden' name="s_dc2_yn" 			value="<%=car.getS_dc2_yn()%>">
  <input type='hidden' name="s_dc2_amt"			value="<%=car.getS_dc2_amt()%>">
  <input type='hidden' name="s_dc3_re" 			value="<%=car.getS_dc3_re()%>">
  <input type='hidden' name="s_dc3_yn" 			value="<%=car.getS_dc3_yn()%>">
  <input type='hidden' name="s_dc3_amt"			value="<%=car.getS_dc3_amt()%>">
  <input type='hidden' name="s_dc1_re_etc"		value="<%=car.getS_dc1_re_etc()%>">  
  <input type='hidden' name="s_dc2_re_etc"		value="<%=car.getS_dc2_re_etc()%>">  
  <input type='hidden' name="s_dc3_re_etc"		value="<%=car.getS_dc3_re_etc()%>">      
  <input type='hidden' name="s_dc1_per"			value="<%=car.getS_dc1_per()%>">  
  <input type='hidden' name="s_dc2_per"			value="<%=car.getS_dc2_per()%>">  
  <input type='hidden' name="s_dc3_per"			value="<%=car.getS_dc3_per()%>">        
  <input type='hidden' name="car_end_dt"		value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_st"			value="<%=base.getCar_st()%>">  
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">      
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="gur_size"			value="<%=gur_size%>">     
  <input type='hidden' name='client_id' 		value="<%=base.getClient_id()%>">
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">      
  <input type='hidden' name="o_1"				value="">
  <input type='hidden' name="ro_13"				value="">  
  <input type='hidden' name="o_13"				value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
  <input type='hidden' name="idx"				value="">  
  <input type='hidden' name="scan_cnt"			value="">    
  <input type='hidden' name="chk_cnt"			value="">    
  <input type='hidden' name="est_from"			value="lc_c_u">      
  <input type='hidden' name="fee_rent_st"		value="<%=rent_st%>">        
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>"> 
  <input type='hidden' name="msg_st"		value="">
  <input type='hidden' name="prev_new_license_plate"		value="">   
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > ������ > <span class=style5>��༭����</span></span></td>
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
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>����<%}else{%>������ȣ<%}%></td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>
        			</td>
                </tr>
    		</table>
	    </td>
	</tr>  	  
	<tr>
	    <td align="right">&nbsp;</td>
	<tr>
	<%if(cng_item.equals("client")){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��ȣ/����</td>
                    <td width='50%' align='left'>&nbsp;<%=client.getFirm_nm()%>              
        			  
        			  </td>
                    <td width='10%' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="client_nm" value='<%=client.getClient_nm()%>' size='22' class='whitetext' readonly></td>
                </tr>		
                <tr>
                    <td width='13%' class='title'>����/����</td>
                    <td colspan="3">&nbsp; 
        			  <input type='text' name="site_nm" value='<%=site.getR_site()%>' size='50' class='whitetext' readonly>
        			  <input type='hidden' name='site_id' value='<%=base.getR_site()%>'>        			  
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
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=base.getP_zip()%>">
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="65" value="<%=base.getP_addr()%>">
                    </td>
                    <td class='title'>����������</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='<%=base.getTax_agnt()%>' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
                </tr>	
                <%	CarMgrBean mgr1 = new CarMgrBean();
                	CarMgrBean mgr5 = new CarMgrBean();
                	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("�����̿���")){
        					mgr1 = mgr;
        				}
        				if(mgr.getMgr_st().equals("�߰�������")){
        					mgr5 = mgr;
        				}
					}                       
                %>                
                <tr>
                    <td class='title'>����� ���������ȣ</td>
		    <td colspan="3">&nbsp;
			<input type='text' name='lic_no' value='<%=base.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			<input type='hidden' name='ssn' value='<%=client.getSsn1()%><%=client.getSsn2()%>'>
			&nbsp;&nbsp;(����,���λ����)    
			&nbsp;�� �����(<%=client.getClient_nm()%>)�� ���������ȣ�� ����
			
		    </td>
                </tr>		
                <tr>
                    <td class='title'>�����̿��� ���������ȣ</td>
		    <td colspan="3">&nbsp;
			<input type='text' name='mgr_lic_no' value='<%=base.getMgr_lic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;�̸�
			<input type='text' name='mgr_lic_emp' value='<%=base.getMgr_lic_emp()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;����
			<input type='text' name='mgr_lic_rel' value='<%=base.getMgr_lic_rel()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;(����,���λ����)    
			&nbsp;�� ����ڰ� �������㰡 ���� ��� �����̿����� �������㸦 �Է�
		    </td>
                </tr>		    
                <%if(mgr5.getMgr_st().equals("�߰�������")){ %>    
                <tr>
                    <td class='title'>�߰������� ���������ȣ</td>
		    <td colspan="3">&nbsp;
			<input type='text' name='mgr_lic_no5' value='<%=mgr5.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;�̸�
			<input type='text' name='mgr_lic_emp5' value='<%=mgr5.getMgr_nm()%>'  size='10' class='text'>
			&nbsp;&nbsp;����
			<input type='text' name='mgr_lic_rel5' value='<%=mgr5.getEtc()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'>			 
		    </td>
                </tr>	
            <%} %>                                
            </table>
        </td>
    </tr>
	<%}%>	
	<%if(cng_item.equals("mgr")){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="3%" rowspan="<%=mgr_size+2 %>" class=title>��<br>��<br>��</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="8%">�ٹ�ó</td>			
                    <td class=title width="8%">�μ�</td>
                    <td class=title width="8%">����</td>
                    <td class=title width="8%">����</td>
                    <td class=title width="10%">��ȭ��ȣ</td>
                    <td class=title width="10%">�޴���</td>
                    <td width="30%" class=title>E-MAIL</td>
                    <td width="5%" class=title>��ȸ</td>
                </tr>
        		  <%String mgr_zip = "";
        			String mgr_addr = "";
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("�����̿���")){
        					mgr_zip = mgr.getMgr_zip();
        					mgr_addr = mgr.getMgr_addr();
        				}%>
                <tr>                 <input type='hidden' name='mgr_id' value='<%=mgr.getMgr_id()%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%=mgr.getMgr_st()%>' class='white' readonly></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' value='<%=mgr.getCom_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' value='<%=mgr.getMgr_dept()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' value='<%=mgr.getMgr_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' value='<%=mgr.getMgr_title()%>' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' value='<%=mgr.getMgr_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='<%=mgr.getMgr_m_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
				<%	String email_1 = "";
					String email_2 = "";
					if(!mgr.getMgr_email().equals("")){
						int mail_len = mgr.getMgr_email().indexOf("@");
						if(mail_len > 0){
							email_1 = mgr.getMgr_email().substring(0,mail_len);
							email_2 = mgr.getMgr_email().substring(mail_len+1);
						}
					}
				%>
                    <td align='center'>
					<input type='text' size='10' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='10' name='email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" onChange="javascript:document.form1.email_2[<%=i%>].value=this.value;" align="absmiddle">
						<option value="" selected>�����ϼ���</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.co.kr">yahoo.co.kr</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">���� �Է�</option>
						</select>
					<input type='hidden' name="mgr_email" value="<%=mgr.getMgr_email()%>">
					</td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
        		  <%	} %>
                <tr>                 <input type='hidden' name='mgr_id'  value='<%=mgr_size%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='' class='text'></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' value='' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'>
					<input type='text' size='10' name='email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='10' name='email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" onChange="javascript:document.form1.email_2[<%=mgr_size%>].value=this.value;" align="absmiddle">
						<option value="" selected>�����ϼ���</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.co.kr">yahoo.co.kr</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">���� �Է�</option>
						</select>
					<input type='hidden' name="mgr_email" value="">
					</td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=mgr_size%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
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
                <tr> 
                    <td colspan="3" class=title>�����̿��� �ǰ����� �ּ�</td>
                    <td colspan="7">&nbsp;
						<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=mgr_zip%>">
						<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr1" size="65" value="<%=mgr_addr%>">
					</td>
                </tr>
            </table>
        </td>
    </tr>	
	<%} %>
	<%if(cng_item.equals("client_guar")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ���뺸��</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_client_guar_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1' onClick="javascript:cng_input2()" <%if(cont_etc.getClient_guar_st().equals("1"))%>checked<%%>>
        				�Ժ�
        			  <input type='radio' name="client_guar_st" value='2' onClick="javascript:cng_input2()" <%if(cont_etc.getClient_guar_st().equals("2"))%>checked<%%>>
        				����</td>
                </tr>
                <tr id=tr_client_guar style="display:<%if(cont_etc.getClient_guar_st().equals("2")){%>''<%}else{%>none<%}%>">
                    <td class='title'>��������</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <select name='guar_con'>
                          <option value="">����</option>
                          <option value="6" <%if(cont_etc.getGuar_con().equals("6")){%>selected<%}%>>��ǥ��������</option>
                          <option value="1" <%if(cont_etc.getGuar_con().equals("1")){%>selected<%}%>>�ſ�������</option>
                          <option value="2" <%if(cont_etc.getGuar_con().equals("2")){%>selected<%}%>>���������δ�ü</option>
                          <option value="3" <%if(cont_etc.getGuar_con().equals("3")){%>selected<%}%>>�����������δ�ü</option>
                          <option value="5" <%if(cont_etc.getGuar_con().equals("5")){%>selected<%}%>>�����濵��</option>
                          <option value="4" <%if(cont_etc.getGuar_con().equals("4")){%>selected<%}%>>��Ÿ ����ȹ��</option>
                        </select>
                    </td>
                    <td width="10%" class='title'>������</td>
                    <td class='left'>&nbsp;
        			  <select name="guar_sac_id">
        			    <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cont_etc.getGuar_sac_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                    </select>
        			</td>
                </tr>
            </table>  
        </td>
    </tr>
	<%} %>
	<%if(cng_item.equals("guar")){%>	
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
                      <input type='radio' name="guar_st" value='1' onClick="javascript:guar_display()" <%if(cont_etc.getGuar_st().equals("1")){%>checked<%}%>>
        				�Ժ�
        			  <input type='radio' name="guar_st" value='2' onClick="javascript:guar_display()" <%if(cont_etc.getGuar_st().equals("2")){%>checked<%}%>>
        				����</td>
                </tr>
                <tr id=tr_guar2 <%if(cont_etc.getGuar_st().equals("1")){%>style="display:''"<%}else{%>style='display:none'<%}%>>
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
                              <%for(int i = 0 ; i < gur_size ; i++){
                					Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
                              <tr>
                                <td class=title>���뺸����<input type='hidden' name='gur_id' value='<%=gur.get("GUR_ID")%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' maxlength='8' class='text' value='<%=gur.get("GUR_NM")%>'></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" class='text' value='<%=gur.get("GUR_SSN")%>'></td>
                                <td align="center">
								<script>
									function openDaumPostcode2() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip2').value = data.zonecode;
												document.getElementById('t_addr2').value = data.address;
												
											}
										}).open();
									}
								</script>
								<input type="text" name="t_zip"  id="t_zip2" size="5" maxlength='7' value="<%=gur.get("GUR_ZIP")%>">
								<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��">
								&nbsp;<input type="text" name="t_addr" id="t_addr2" size="20" value="<%=gur.get("GUR_ADDR")%>">
								</td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value='<%=gur.get("GUR_TEL")%>'></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value='<%=gur.get("GUR_REL")%>'></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span> </td>
                              </tr>
                              <%}%>
                              <%for(int i=gur_size; i<3; i++){%>
                              <tr>
                                <td class=title>���뺸����<input type='hidden' name='gur_id' value='<%=i+1%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" class='text' value=''></td>
                                <td align="center">
								<script>
									function openDaumPostcode3() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip3').value = data.zonecode;
												document.getElementById('t_addr3').value = data.address;
												
											}
										}).open();
									}
								</script>
								<input type="text" name="t_zip"  id="t_zip3" size="5" maxlength='7'>
								<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��">
								&nbsp;<input type="text" name="t_addr" id="t_addr3" size="20">
								</td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value=''></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span> </td>
                              </tr>
                        <%}%>
                        </table>
    			    </td>			
                </tr>
            </table>  
        </td>
    </tr>
	<%} %>

	<%if(cng_item.equals("car")){%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%-- <tr>
                    <td class='title'> ����</td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='color' size='50' class='text' value='<%=car.getColo()%>'>
					  &nbsp;&nbsp;&nbsp;
					  (�������(��Ʈ): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'> )  
					  &nbsp;&nbsp;&nbsp;
					  (���Ͻ�: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'> )
					  
					  <input type="hidden" name="old_color" value="<%=car.getColo()%>">
					  <input type="hidden" name="old_in_col" value="<%=car.getIn_col()%>">
					  <input type="hidden" name="old_garnish_col" value="<%=car.getGarnish_col()%>">  
                    </td>
                </tr> --%>
                <%-- <%if(ej_bean.getJg_g_7().equals("3")){//������%>
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td colspan="5">&nbsp;
                        <%=c_db.getNameByIdCode("0034", "", pur.getEcar_loc_st())%>
                    	  <input type="hidden" name="ecar_loc_st" value="<%=pur.getEcar_loc_st()%>">
        			  </td>
                </tr>	
                <%}%>   
                <%if(ej_bean.getJg_g_7().equals("4")){//������%>
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td colspan="5">&nbsp;
                        <%=c_db.getNameByIdCode("0037", "", pur.getHcar_loc_st())%>
                    	  <input type="hidden" name="hcar_loc_st" value="<%=pur.getHcar_loc_st()%>">
        			  </td>
                </tr>	
                <%}%>  --%>                  
                <%-- <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����-��������%>
                <tr <%if ((ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) && !car.getEco_e_tag().equals("1")) {%>style="display: none;"<%}%>>
                    <td class='title'>�������ｺƼĿ �߱�<br>(�����ͳ� �̿� �����±�)</td>
                    <td colspan="5">&nbsp;
                        <select name="eco_e_tag">
                    	  <option value=""  <%if(car.getEco_e_tag().equals(""))%>selected<%%>>����</option>
                        <option value="0" <%if(car.getEco_e_tag().equals("0"))%>selected<%%>>�̹߱�</option>
                        <option value="1" <%if(car.getEco_e_tag().equals("1"))%>selected<%%>>�߱�</option>
                      </select>
                      &nbsp;�� ģȯ���� �� �� �����ͳ� ���̿��ڸ� �߱� ����, ���̺긮��/�÷����� ���̺긮�� ������ ��� ���������� �뿩�ᰡ ���� ��µ�.
        			      </td>
        			<input type="hidden" name="eco_e_tag" id="eco_e_tag" value="<%=car.getEco_e_tag()%>">
        			<td colspan="5">&nbsp;<%String eco_e_tag = car.getEco_e_tag();%><%if(eco_e_tag.equals("0")){%>�̹߱�<%}else if(eco_e_tag.equals("1")){%>�߱�<%}%></td>
                </tr>		
                <%}%> --%>	                                 
                <%-- <tr>
                    <td class='title'> �����μ���</td>
                    <td colspan="5">&nbsp;
                      <select name="udt_st" <%if(!cons.getUdt_firm().equals("")){%>readonly<%}%>>
                        <option value=''>����</option>
        				<%if(pur.getUdt_st().equals("")){%>
                        <option value='1' <%if(base.getBrch_id().equals("S1")||base.getBrch_id().equals("K1")||base.getBrch_id().equals("K2"))%>selected<%%>>���ﺻ��</option>
                        <option value='2' <%if(base.getBrch_id().equals("B1")||base.getBrch_id().equals("N1"))%>selected<%%>>�λ�����</option>
                        <option value='3' <%if(base.getBrch_id().equals("D1"))%>selected<%%>>��������</option>
                        <option value='5' <%if(base.getBrch_id().equals("G1"))%>selected<%%>>�뱸����</option>
                        <option value='6' <%if(base.getBrch_id().equals("J1"))%>selected<%%>>��������</option>
                        <option value='4' >��</option>
        				<%}else{%>
        				<option value="1" <%if(pur.getUdt_st().equals("1"))%> selected<%%>>���ﺻ��</option>
        		        <option value="2" <%if(pur.getUdt_st().equals("2"))%> selected<%%>>�λ�����</option>
                		<option value="3" <%if(pur.getUdt_st().equals("3"))%> selected<%%>>��������</option>				
        		        <option value="5" <%if(pur.getUdt_st().equals("5"))%> selected<%%>>�뱸����</option>
                		<option value="6" <%if(pur.getUdt_st().equals("6"))%> selected<%%>>��������</option>				
                		<option value="4" <%if(pur.getUdt_st().equals("4"))%> selected<%%>>��</option>
        				<%}%>						
                      </select>
        			  &nbsp; �μ��� Ź�۷� :
        			  <input type='text' name='cons_amt1' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  �� (���μ��� ���� ���� �Է��ϼ���.)
                    </td>
                </tr> --%>
                <tr>
                    <%-- <td width="13%" class='title'>�������</td>
                    <td width="20%">&nbsp;
                    	<%String car_ext = car.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>
                    </td> --%>
                    <td width="13%" class='title'>����</td>
                    <td colspan="5">&nbsp;
                      <input type='text' name="sun_per" value='<%=car.getSun_per()%>' size="4" maxlength="4" class='text'> %
                      	<%if (car.getHipass_yn().equals("")) { // 20181012 �����н����� (������ ������ ���� select���� input���� ���� ó��)%>
							<input type="hidden" name="hipass_yn" value="">
						<%} else {%>
							<input type="hidden" name="hipass_yn" value="<%=car.getHipass_yn()%>">
						<%}%>
						
						<%if (!(base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001"))) {%>
							<%if (car.getBluelink_yn().equals("")) {%>
								<input type="hidden" name="bluelink_yn" value="">
							<%} else {%>
								<input type="hidden" name="bluelink_yn" value="<%=car.getBluelink_yn()%>">
							<%}%>
						<%}%>
                    </td>
                </tr>
               	<% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>
                <tr>
                    <td width='10%' class='title'>��縵ũ����</td>
                    <td colspan="5">&nbsp;
                        <select name="bluelink_yn">
                            <option value='' <%if(car.getBluelink_yn().equals(""))%>selected<%%>>����</option>
                            <option value='Y' <%if(car.getBluelink_yn().equals("Y"))%>selected<%%>>����</option>
                            <option value='N' <%if(car.getBluelink_yn().equals("N"))%>selected<%%>>����</option>
                        </select>
                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;�� �������ý� ��縵ũ ���� �ȳ��� �˸���߼�(�����ٻ�����)</span>
                    </td>
                </tr>
                <% } %>		
                <tr>
                    <td class='title'>LPG����</td>
                    <td colspan="5" >
        			  <table width="100%" border="0" cellpadding="0" cellspacing="0">
        			  	
                        <tr>
                          <td width="80">&nbsp;
                              <select name='lpg_yn'>
                                <option value="">����</option>
                                <option value="Y" <%if(car.getLpg_yn().equals("Y")) out.println("selected");%>>����</option>
                                <option value="N" <%if(car.getLpg_yn().equals("N")) out.println("selected");%>>������ </option>
                              </select>
                          </td>
                          <td width="110">&nbsp;
                              <select name='lpg_setter'>
                                <option value=''>����</option>
                                <option value='1' <%if(car.getLpg_setter().equals("1")){%> selected <%}%>>������</option>
                                <option value='2' <%if(car.getLpg_setter().equals("2")){%> selected <%}%>>���뿩������</option>
                              </select>
                          </td>
                          <td>&nbsp;
                              <select name='lpg_kit'>
                                <option value=''>����</option>
                                <option value='1' <%if(car.getLpg_kit().equals("1")){%> selected <%}%>>�����л�</option>
                                <option value='2' <%if(car.getLpg_kit().equals("2")){%> selected <%}%>>�����л�</option>
                                <option value='3' <%if(car.getLpg_kit().equals("3")){%> selected <%}%>>�����Ұ�</option>						
                              </select>
                          </td>
                        </tr>
                      </table>
        			</td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">������߰�����</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='add_opt' size='65' class="text" value='<%=car.getAdd_opt()%>'>
        				&nbsp;<input type='text' name='add_opt_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  ��<font color="#666666">(�ΰ������Աݾ�, ���� �ݿ���)</font>
        				<%if(cm_bean.getS_st().equals("801")||cm_bean.getS_st().equals("802")||cm_bean.getS_st().equals("811")||cm_bean.getS_st().equals("821")){%>
        					<%if(!cr_bean.getCar_no().equals("")){ %>
								<br>&nbsp;&nbsp;ȭ���� ���� : 
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="" <%if(car.getVan_add_opt().equals("")){%>checked<%}%>>&nbsp;����
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="1" <%if(car.getVan_add_opt().equals("1")){%>checked<%}%>>&nbsp;����ž/���ٵ�	        				
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="2" <%if(car.getVan_add_opt().equals("2")){%>checked<%}%>>&nbsp;Ȱ�������
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="3" <%if(car.getVan_add_opt().equals("3")){%>checked<%}%>>&nbsp;���߱�/ũ����
							<%} %>		
        				<%}%>	  
                    </td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">�����ݿ���ǰ</span></td>
                    <td colspan="5">&nbsp;
                      <label><input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2ä�� ���ڽ�</label>
                      &nbsp;
                      <label><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> ���� ����(�⺻��)</label>
                      &nbsp;
                      <label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> ��޽���(��������)</label>, 
                      	����: <input type="text" name="tint_ps_nm" value='<%=car.getTint_ps_nm()%>' size="5">, 
                      	��ǰ�� ���ޱݾ�:<input type="text" name="tint_ps_amt" value='<%=AddUtil.parseDecimal(car.getTint_ps_amt())%>' size="5" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value);'>�� (�ΰ�������)
                      <br>
                      &nbsp;
                      <label><input type="checkbox" name="tint_sn_yn" value="Y" <%if(car.getTint_sn_yn().equals("Y")){%>checked<%}%>> ������� �̽ð� ����</label>
                      &nbsp;
                      <label><input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> ���ڽ� ������ ���� 
	                  &nbsp; ���λ��� : 
    	              <select name="tint_bn_nm">
                  		<option value=""  <%if (car.getTint_bn_nm().equals("")){%>selected<%}%>>����</option>
                  		<option value="2" <%if (car.getTint_bn_nm().equals("2")){%>selected<%}%>>������</option>
                   		<option value="1" <%if (car.getTint_bn_nm().equals("1")){%>selected<%}%>>��Ʈ��ķ</option>                   		
        	           	</select>
                      </label>
                      &nbsp;
					  <label><input type="checkbox" name="tint_cons_yn" value="Y" <%if(car.getTint_cons_yn().equals("Y")){%>checked<%}%>> �߰�Ź�۷�� </label>
	      		      <input type="text" name="tint_cons_amt" class='num' value='<%=AddUtil.parseDecimal(car.getTint_cons_amt())%>' size="5" onBlur='javascript:this.value=parseDecimal(this.value);'> ��
                      &nbsp;
      		      	  <label <%if(!car.getTint_n_yn().equals("Y")){%>style="display: none;"<%}%>><input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> ��ġ�� ������̼�</label>
                      <%if(ej_bean.getJg_g_7().equals("3")){//������%>
                      &nbsp;
                      <label <%if(!car.getTint_eb_yn().equals("Y")){%>style="display: none;"<%}%>><input type="checkbox" name="tint_eb_yn" value="Y" <%if(car.getTint_eb_yn().equals("Y")){%>checked<%}%>> �̵��� ������(������)</label>
                      <%}%>
                      &nbsp;
                      <%if( !( (Integer.parseInt(ej_bean.getSh_code()) > 9018110 && Integer.parseInt(ej_bean.getSh_code()) < 9018999) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")
                    		  || cm_bean.getCar_comp_id().equals("0044") || cm_bean.getCar_comp_id().equals("0007") || cm_bean.getCar_comp_id().equals("0025") || cm_bean.getCar_comp_id().equals("0033") || cm_bean.getCar_comp_id().equals("0048")) ){ %>
                          ��ȣ�Ǳ���
                      <!-- ������ȣ�ǽ�û -->
                   	  <select name="new_license_plate">
                   		  <option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>����</option>
                   		  <option value="0" <%if (!(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2"))) {%>selected<%}%>>����</option>
                   		  <%-- <option value="" <%if (car.getNew_license_plate().equals("")) {%>selected<%}%>>��û����</option>
                   		  <option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>��û</option> --%>
<%--                    		  <option value="1" <%if (car.getNew_license_plate().equals("1")) {%>selected<%}%>>������</option> --%>
<%--                    		  <option value="2" <%if (car.getNew_license_plate().equals("2")) {%>selected<%}%>>����/�뱸/����/�λ�</option> --%>
                   	  </select>
                   	  <%} %>
                    </td>
                </tr>                
                <tr>
                    <td class='title'><span class="title1">����ǰ��</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='extra_set' size='45' class="text" value='<%=car.getExtra_set()%>'>
        				&nbsp;<input type='text' name='extra_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getExtra_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  ��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����̹ݿ���)</font></span>
        					  &nbsp;<input type="checkbox" name="serv_b_yn" value="Y" <%if(car.getServ_b_yn().equals("Y")){%>checked<%}%>> ���ڽ� (2015��8��1�Ϻ���)
        					  <%if(ej_bean.getJg_g_7().equals("3")){ %>
        					  	&nbsp;<input type="checkbox" name="serv_sc_yn" value="Y" <%if(car.getServ_sc_yn().equals("Y")){%>checked<%}%>> ������������
        					  <%} %>
                    </td>
                </tr>		  
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='5' cols='90' name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null") && !String.valueOf(pur_com.get("USE_YN_ST")).equals("����")){%>
	<tr>
        <td><font color='red'>�� Ư�ǹ������� ��Ϻ��Դϴ�. ������ ������ ��� ���¾�ü����-��ü���������� ��ຯ�� ó���Ͻʽÿ�.</font></td>
    </tr> 
    <input type="hidden" name="pur_color" value="<%=pur_com.get("R_COLO")%>">   
    <%}else{ %>
    <input type="hidden" name="pur_color" value="">
	<%} %>	
	
	<%} %>	


	<%if(cng_item.equals("gi")){%>	
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr id=tr_gi style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1' onClick="javascript:display_gi()" <%if(gins.getGi_st().equals("1")){%> checked <%}%>>
                  		����
                  		<input type='radio' name="gi_st" value='0' onClick="javascript:display_gi()" <%if(gins.getGi_st().equals("0")){%> checked <%}%>>
                  		���� </td>
                </tr>
                <tr id=tr_gi1 style="display:<%if(gins.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>��������</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value='<%=gins.getGi_no()%>'>
        			   <input type='text' name='gi_jijum' value='<%=gins.getGi_jijum()%>' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>���Աݾ�</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                    <td width="10%" class=title >���������</td>
                    <td>&nbsp;
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='<%=AddUtil.parseDecimal(gins.getGi_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                </tr>
            </table>
        </td>
    </tr>
	<%} %>	

	<%if(cng_item.equals("pay_way")){%>		
	<tr id=tr_fee3 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Թ��</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>						
    <tr id=tr_fee2 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>���ݱ���</td>
                    <td width="20%">&nbsp;
                      <select name='fee_sh'>
                        <option value="">����</option>
                        <option value="0" <%if(fee.getFee_sh().equals("0")){%> selected <%}%>>�ĺ�</option>
                        <option value="1" <%if(fee.getFee_sh().equals("1")){%> selected <%}%>>����</option>
                      </select></td>
                    <td width="10%" class='title'>���ι��</td>
                    <td width="20%">&nbsp;
                      <select name='fee_pay_st'>
                        <option value=''>����</option>
                        <option value='1' <%if(fee.getFee_pay_st().equals("1")){%> selected <%}%>>�ڵ���ü</option>
                        <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>�������Ա�</option>
                        <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>����</option>
                        <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>��Ÿ</option>
                      </select></td>
        		    <td width="10%" class='title'>CMS�̽���</td>
        		    <td>&nbsp;
        			    ���� : <input type='text' name='cms_not_cau' size='25' value='<%=fee_etc.getCms_not_cau()%>' class='text'>
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
    		  <%if(cms.getApp_dt().equals("")){%>
              <tr>
                <td class='title'>�ڵ���ü
                  <br><span class="b"><a href="javascript:search_cms('')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;���¹�ȣ : 
    			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='30' class='text'>
    			      (
    			      <input type='hidden' name="cms_bank" 			value="<%=cms.getCms_bank()%>">
    			      <select name='cms_bank_cd'>
                    <option value=''>����</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];	
    												if(cms.getCms_bank().equals("")){
    													//�ű��ΰ�� �̻������ ����
															if(bank.getUse_yn().equals("N"))	 continue;
    								%>
                    <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}else{%>
                    <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}%>
                    <%		}
				    						}
				    				%>
                  </select>
    
    			       ) </td>
    			    </tr>
    			  <tr>
    			    <td>&nbsp;�� �� �� :&nbsp;
    			      <input type='text' name='cms_dep_nm' value='<%=cms.getCms_dep_nm()%>' size='30' class='text'>
    				  &nbsp;&nbsp;
    				  / �������� : �ſ�
    			      <select name='cms_day'>
        			      <option value="">����</option>
						    <%for(int i=1; i<=31; i++){%>
                        	<option value="<%=i%>"  <%if(cms.getCms_day().equals(String.valueOf(i)))%>selected<%%>><%=i%></option>
							<%}%>						
                      	  </select>
    			��
    				  </td>
    			    </tr>
        			  <tr>
        			    <td>&nbsp;������ �������/����ڹ�ȣ :
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
    			      &nbsp;&nbsp;������ �ּ� : 
					  <input type='text' name="t_zip" value='<%=cms.getCms_dep_post()%>' size="7" class='text'>
                      <input type='text' name="t_addr" value='<%=cms.getCms_dep_addr()%>' size="50" class='text'>
        				  </td>
        			    </tr>			
        			  <tr>
        			    <td>&nbsp;������ȭ :
    			      <input type='text' name='cms_tel' size='15' class='text' value="<%=cms.getCms_tel()%>">

    			      &nbsp;&nbsp;�޴��� :
    			      <input type='text' name='cms_m_tel' size='15' class='text' value="<%=cms.getCms_m_tel()%>">
    					  
    			      &nbsp;&nbsp;�̸��� :
    			      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=cms.getCms_email()%>">	

        				  </td>
        			    </tr>		    			    
    			</table>
    			</td>
              </tr>
              
    		 <%}%>
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
                <tr>
                    <td class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
                    <td colspan="5">&nbsp; 
                    <textarea rows='5' cols='90' name='fee_cdt'><%=fee.getFee_cdt()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>			
	<%} %>	
	<%if(cng_item.equals("tax")){%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_tax style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>���޹޴���</td>
                    <td width="20%">&nbsp;
                      <input type="radio" name="tax_type" value="1" <% if(base.getTax_type().equals("1")) out.print("checked"); %>>
        			    ����
        		      <input type="radio" name="tax_type" value="2" <% if(base.getTax_type().equals("2")) out.print("checked"); %>>
        		    	���� </td>
                    <td width="10%" class='title' style="font-size : 8pt;">û����<br>���ɹ��</td>
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
                    <td width="10%" class='title' style="font-size : 8pt;">����<br>���ݰ�꼭</td>
                    <td>&nbsp;<%if(cont_etc.getEle_tax_st().equals("") && cont_etc.getRec_st().equals("1")) cont_etc.setEle_tax_st("1");%>
                      <select name='ele_tax_st'>
                        <option value="">����</option>
                        <option value="1" <% if(cont_etc.getEle_tax_st().equals("1")) out.print("selected"); %>>���ý���</option>
                        <option value="2" <% if(cont_etc.getEle_tax_st().equals("2")) out.print("selected"); %>>�����ý���</option>
                      </select>
                      <input type='text' name='tax_extra' maxlength='10' size='15' value='<%=cont_etc.getTax_extra()%>' class='text'>
        			</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>������</td>
                    <td width="20%">&nbsp;
        			<select name='fee_br_id'>
                        <option value=''>����</option>
                        <%	if(brch_size > 0)	{
        						for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%=branch.get("BR_ID")%>' <%if(fee.getBr_id().equals(branch.get("BR_ID"))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
                    <td width="10%" class='title'>û������</td>
                    <td width="20%">&nbsp;
        			<select name='fee_st'>
                        <option value="0" <%if(fee.getFee_st().equals("0")){%> selected <%}%>>����</option>
                        <option value="1" <%if(fee.getFee_st().equals("1")){%> selected <%}%>>û��</option>
                        <option value="2" <%if(fee.getFee_st().equals("2")){%> selected <%}%>>����</option>
                    </select>
        			</td>
                    <td width="10%" class='title'>��������</td>
                    <td>&nbsp;
        			<select name='rc_day'>
                        <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                        <option value='<%=i%>' <%if(fee.getRc_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� 
                        </option>
                        <% } %>
                        <option value='99' <%if(fee.getRc_day().equals("99")){%> selected <%}%>> 
                        ���� </option>
                    </select>
        			</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>�Ϳ�����</td>
                    <td>&nbsp;<input type='checkbox' name='next_yn' <%if(fee.getNext_yn().equals("Y")){%>checked<%}%>></td>
                    <td width="10%" class='title'>�������</td>
                    <td colspan="3">&nbsp;
    			    <input type='text' size='3' name='leave_day' value='<%=fee.getLeave_day()%>' maxlength='2' class='text'>��</td>
                </tr>		  
            </table>
        </td>
    </tr>
	<%} %>
	<%if(cng_item.equals("taecha_info")){%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������� ����</span></td>
	</tr>
    <tr id=tr_tae1 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 style='height:1'></td>
                </tr>
                <tr>
                    <td width="13%" class=title>�������������</td>
                    <td width="20%">&nbsp; &nbsp;
                      <input type='radio' name="prv_dlv_yn" value='N' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                      ����
                      <input type='radio' name="prv_dlv_yn" value='Y' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
        	 		�ִ�
        		    </td>
                    <td width="10%" class=title style="font-size : 7pt;">�����Ⱓ���Կ���</td>
                    <td>&nbsp; &nbsp;
                      <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> >
                      ������
                      <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> >
        	 		����
        		    </td>									
                </tr>
            </table>
        </td>
    </tr>
    <tr>
		<td>* ����������ִ� ��� ������ �Ϸ�Ǹ� �뿩���-��������������� �߰�����Ͻʽÿ�.</td>
    </tr>
    <%} %>	
	<%if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){%>	
	<input type='hidden' name='taecha_no'		 value='<%=taecha_no%>'>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������</span></td>
	</tr>
    <tr id=tr_tae2 style="display:<%if(fee.getPrv_dlv_yn().equals("Y") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>������ȣ</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='tae_car_no' size='10' class='text' <%if(!base.getRent_st().equals("3"))%>readonly<%%> value='<%=taecha.getCar_no()%>'>
                      <span class="b"><a href="javascript:car_search('taecha')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span> 
        			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
					  <input type='hidden' name='tae_s_cd'	 	 value='<%=taecha.getRent_s_cd()%>'>
        			</td>
                    <td width="10%" class='title'>����</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="tae_car_nm" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getCar_nm()%>'></td>
                    <td width="10%" class='title'>���ʵ����</td>
                    <td>&nbsp; 
                    <input type="text" name="tae_init_reg_dt" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getInit_reg_dt()%>'></td>
                </tr>
                <tr>
                    <td class=title>�뿩������</td>
                    <td>&nbsp;
                      <input type='text' name='tae_car_rent_st' class='text' size='11' maxlength='11' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='title'>�뿩������</td>
                    <td>&nbsp;
                      <input type='text' name='tae_car_rent_et' class='text' size='11' maxlength='11' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
        			  &nbsp;</td>
        			  <td class='title'>�뿩�ἱ�Աݿ���</td>
                <td>&nbsp;
                	<input type='radio' name="tae_f_req_yn" value='Y' <%if(taecha.getF_req_yn().equals("Y")){%> checked <%}%> >
                  ���Ա�
                  <input type='radio' name="tae_f_req_yn" value='N' <%if(taecha.getF_req_yn().equals("N")||taecha.getF_req_yn().equals("")){%> checked <%}%> >
    	 		        ���Ա�
    	 		        </td>
                </tr>
                <tr>
                    <td width="10%" class=title >���뿩��</td>
                    <td>&nbsp;
                      <input type='text' name='tae_rent_fee' class='num' size='8' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����) 
        			  <input type='hidden' name='tae_rent_fee_s'	 value=''>
        			  <input type='hidden' name='tae_rent_fee_v'	 value=''>
        			  <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              		  <%}else{%>	
        			  <a href="javascript:EstiTaeSearch();"><img src=/acar/images/center/button_in_search.gif align="absmiddle" border="0" alt="�����̷�"></a>
        			  <%}%>	
    			    </td>
                    <td width="10%" class=title >������</td>
                    <td colspan='3'>&nbsp;
                      <input type='text' name='tae_rent_inv' class='whitenum' readonly size='8' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_inv())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����) 
        			  <span class="b"><a href="javascript:estimate_taecha('account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
					  <%	if(!taecha.getRent_inv().equals("0")){
					  			ContCarBean t_fee_add = a_db.getContFeeEtcAdd(rent_mng_id, rent_l_cd, "t");%>
					  <a href="javascript:TaechaEstiPrint('<%=t_fee_add.getBc_est_id()%>');"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
					  <%	}%>
					  
        			  <input type='hidden' name='tae_rent_inv_s'	 value=''>
        			  <input type='hidden' name='tae_rent_inv_v'	 value=''>					  
					  <input type='hidden' name='tae_est_id'	 	 value='<%=taecha.getEst_id()%>'>					  
        			  
    			    </td>    			    
                </tr>   
                <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
                <%}else{%>
                <tr>
                    <td class=title>���������ÿ������</td>
                    <td colspan='5' >&nbsp;
                      <input type='radio' name="tae_rent_fee_st" value='1' <%if(taecha.getRent_fee_st().equals("1")){%> checked <%}%> >
                                      ����Ʈ������
                      <input type='text' name='tae_rent_fee_cls' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����)                 
                      <input type='radio' name="tae_rent_fee_st" value='0' <%if(taecha.getRent_fee_st().equals("0")){%> checked <%}%>  >
    	 		          �������� ǥ��Ǿ� ���� ����	                        				  					 
        			</td>                    
              </tr>	    
              <%} %>         
                <tr>
                    <td class=title>û������</td>
                    <td>&nbsp;
                      <select name='tae_req_st'>
                        <option value="">����</option>
                        <option value="1" <% if(taecha.getReq_st().equals("1")) out.print("selected");%>>û��</option>
                        <option value="0" <% if(taecha.getReq_st().equals("0")) out.print("selected");%>>�������</option>
                      </select></td>
                    <td class='title' style="font-size : 8pt;">��꼭���࿩��</td>
                    <td>&nbsp;
                      <select name='tae_tae_st'>
                        <option value="">����</option>
                        <option value="1" <% if(taecha.getTae_st().equals("1")) out.print("selected");%>>����</option>
                        <option value="0" <% if(taecha.getTae_st().equals("0")) out.print("selected");%>>�̹���</option>
                      </select></td>
                    <td class='title'>������</td>
                    <td>&nbsp;
                      <select name='tae_sac_id'>
                        <option value="">����</option>
                       	<%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                   		<option value='<%=user.get("USER_ID")%>' <%if(taecha.getTae_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                      	<%		}
        					}%>
                      </select>
        			</td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(base.getRent_st().equals("3")){%>
    <tr>
	<td>* �����Ī������ ��� ������ȣ�� "<%=cr_bean.getCar_no()%>"�� �Է��Ͻð�(�˻��� �ȵ�), �����Ⱓ�� ������, 
	      �뿩�������� �����ε���, �뿩�������� ����� ���Ό����, ���뿩��� ����� ���뿩��, û�����δ� û��, ��꼭���࿩�δ� �������� �Է��ϼ���.</td>
    </tr>    
    <tr id=tr_tae3 style="display:none">
	    <td>
	        * �����Ī���� �̰������ٱݾ� ���� : �������� ���� <input name="end_rent_link_day" type="text" class="text"  readonly value="" size="4">��,
	        �����뿩��� ���� �뿩�� ���� <input name="end_rent_link_per" type="text" class="text"  readonly value="" size="4">%<br>
	        * �����Ī �Է��� ��  "���������"  �뿩������ / �뿩������ ���̰� 35�� �̻�, �Ǵ� ������� ���� 30% �̻� ���̰� �߻��ϸ� ����������� �Էµ� "���뿩��"�� ��������  ����������� �������� �ݿ��Ѵ�.<br> 
	        * ������ <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(taecha.getEnd_rent_link_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="end_rent_link_sac_id" value="<%=taecha.getEnd_rent_link_sac_id()%>">			
			<a href="javascript:User_search('end_rent_link_sac_id', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<input name="end_rent_link_sac_id_text" type="text" class="whitetextredb"  readonly value="" size="10">
	           
	    </td> 
	<tr>		
    <%}%>	    
	<%} %>	
	<%if(cng_item.equals("emp1") || cng_item.equals("emp2")){%>	
	<tr id=tr_emp_bus_t style="display:<%if(cng_item.equals("emp1")){%>''<%}else{%>none<%}%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>�������<%}else if(base.getCar_gu().equals("2")){%>�߰�������<%}%>-�������</span></td>
	</tr>
    <tr id=tr_emp_bus style="display:<%if(cng_item.equals("emp1")){%>''<%}else{%>none<%}%>"> 	
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
            	    <td class=line2 style='height:1'></td>
            	</tr>
            	              <tr>
                <td class='title'>��������</td>
                <td colspan='5'>&nbsp;                  
                  <input type='radio' name="pur_bus_st" value='4' <%if(pur.getPur_bus_st().equals("4")){%>checked<%}%>>
                  ������Ʈ
                   </td>		
              </tr>	
                <tr>
                    <td width="13%" class='title'>�������</td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>
        		    </td>
                </tr>
                <tr>
                    <td width="13%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
					  </td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp1.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                    <td width="10%" class='title'>�ҵ汸��</td>
                    <td>&nbsp;
                    <input type='text' name='cust_st' size='15' value='<%=emp1.getCust_st()%>' class='whitetext' readonly></td>			
                </tr>
                <tr>
                    <td class='title'>�ִ��������</td>
                    <td>&nbsp;
                      <input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum' readonly>
        			  % 
        			</td>
                    <td class='title'>�����������</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" readonly class='<%if(!commi_doc.getDoc_no().equals(""))%>white<%%>num' onBlur='javascript:setCommi()'>
        		      % 			  	  
        			</td>
                </tr>
                <tr>
                    <td class='title'>�������</td>
                    <td>&nbsp;
                      <select name='commi_car_st'>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>��������</option>
                      </select>  
        			</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;
                      <input type='text' size='11' name='commi_car_amt' maxlength='11' readonly class='<%if(!commi_doc.getDoc_no().equals(""))%>white<%%>num' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">��
					  <%if(emp1.getCommi_car_amt()==0){%>					  
					  	<%if(AddUtil.parseInt(base.getRent_dt())>=20130321){%>
					  	(�Һ������� <%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt())%>)
					  	<%}else{%>
					  	(�Һ������� <%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>)
					  	<%}%>
					  <%}%>
					  </td>
                    <td class='title'>���޼�����</td>
                    <td>&nbsp;
                      <input type='text' name="commi" size='10' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' readonly maxlength='7' class='<%if(!commi_doc.getDoc_no().equals(""))%>white<%%>num' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��			  
        			</td>
                </tr>		  
                <tr>
                    <td class='title'>�������</td>
                    <td colspan="3" >&nbsp;
        		      <input type='text' name="ch_remark" value='<%=emp1.getCh_remark()%>' size="40" class='text'>
                    </td>
                    <td class='title'>������</td>
                    <td>&nbsp;
                      <select name='ch_sac_id'>
                        <option value="">����</option>
                 		<%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
              			<option value='<%=user.get("USER_ID")%>' <%if(emp1.getCh_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
                      </select>
        			</td>
                </tr>
                <tr>
                    <td class='title'>�����</td>
                    <td >&nbsp;
                    	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
        		      <select name='emp_bank_cd'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//�ű��ΰ�� �̻������ ����
																if(bank.getUse_yn().equals("N"))	 continue;
												%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        										}%>
                      </select>
        			</td>
                    <td class='title'>���¹�ȣ</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="15" class='text'>
        			</td>
                    <td class='title'>�����ָ�</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="15" class='text'>
        			</td>
                </tr>		  		  
            </table>
        </td>
    </tr>
	<%if(cng_item.equals("emp1") && !commi_doc.getDoc_no().equals("")){%>
    <tr>
	    <td>* �������繮���� ��� ��ϵ� ���Դϴ�. �������� �� �ݾ׼����� �������繮������ �Ͻñ� �ٶ��ϴ�.&nbsp;</td>
	</tr>		
	<%}%>
	<%} %>	
	<%if(cng_item.equals("emp1") || cng_item.equals("emp2")){%>		
	<tr id=tr_emp_dlv_t style="display:<%if(cng_item.equals("emp2")){%>''<%}else{%>none<%}%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(!base.getCar_gu().equals("2")){%>�������-�����<%}else if(base.getCar_gu().equals("2")){%>�߰�������ó<%}%></span></td>
	</tr>	
    <tr id=tr_emp_dlv style="display:<%if(cng_item.equals("emp2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
            	    <td class=line2 style='height:1'></td>
            	</tr>		
                <tr>
                 <td class='title'>�����</td>
                 <td>&nbsp;
				   <input type='hidden' name='one_self' value='<%=pur.getOne_self()%>'>
				   <%if(pur.getOne_self().equals("Y")){%>��ü���<%}%>
				   <%if(pur.getOne_self().equals("N")){%>����������<%}%>
			     </td>
		<td class='title'>Ư�������</td>
                <td>&nbsp;
                <input type='radio' name="dir_pur_yn" value='Y' <%if(pur.getDir_pur_yn().equals("Y")){%>checked<%}%>>
        				Ư��
        	    <input type='radio' name="dir_pur_yn" value='' <%if(pur.getDir_pur_yn().equals("")){%>checked<%}%>>
        				��Ÿ(��ü)
        		  
    			</td>	
    		<td class='title'>����û��</td>
                <td>&nbsp;
                		  <input type='text' name='pur_req_dt' value='<%=pur.getPur_req_dt()%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
                		   &nbsp;
        		  <input type="checkbox" name="pur_req_yn" value="Y" <%if(pur.getPur_req_yn().equals("Y")){%>checked<%}%>>				  
        				����û�Ѵ�
        		  
    			</td>	     
              </tr>				
                <tr>
                    <td width="13%" class='title'>�����</td>
                    <td width="20%" style='height:44'>&nbsp;
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
        			  <%if(doc4.getDoc_step().equals("")){%>        			   
                      <span class="b"><a href="javascript:search_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href="javascript:cancel_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>        			  
        			  <%}%>                     
                      </td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
        			</td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp2.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
  
                <tr>
                    <td class='title'>�ӽÿ����ȣ</td>
                    <td >&nbsp;
                      <input type='text' name='tmp_drv_no' value='<%=pur.getTmp_drv_no()%>' class='text' maxlength='10' size='10'>
        		    </td>
                    <td class='title'>�ӽÿ���Ⱓ</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='tmp_drv_st' value='<%=pur.getTmp_drv_st()%>' class='text' maxlength='10' size='11'>
        			 ~
                  	  <input type='text' name='tmp_drv_et' value='<%=pur.getTmp_drv_et()%>' class='text' maxlength='10' size='11'>
        			</td>
                </tr>
                <!-- 
			  <tr>				
                <td class='title'>����</td>
                <td>&nbsp;
				  <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��	
				          <%if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getCon_amt_pay_req().equals("")){%>
                	<a href="javascript:SendMsg('con_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                	<%}%>
                	<%if(pur.getCon_amt() > 0 && !pur.getCon_amt_pay_req().equals("")){%>
                	&nbsp;�۱ݿ�û(<%=pur.getCon_amt_pay_req()%>)
                	<%}%>				  
    			</td>				
                <td class='title'>�������</td>				
                <td colspan="3">&nbsp;
					<select name='con_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        								%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        										}%>
                    </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					������ : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='15' class='text'>
    			</td>				
              </tr>						 
              <tr>				
                <td class='title'>�ӽÿ��ຸ���</td>
                <td colspan='5'>&nbsp;
				  <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��					  
    			</td>				
              </tr>   
               -->               
            </table>
        </td>
    </tr>
	<%} %>	

    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>	
    <tr>
	    <td align='center'>
	  	<a href='javascript:update();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	  	&nbsp;
	  	<a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 		
	  	</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
<%if((cng_item.equals("taecha") || cng_item.equals("taecha_info")) && ta_vt_size>0){%>
tr_tae2.style.display		= '';
<%}%>

<%if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){%>	
<%if(!cont_etc.getGrt_suc_l_cd().equals("")){%>
init_end_rent();
<%}%>

function init_end_rent(){
	var fm = document.form1;
	if(fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){	
		var est_day = getRentTime('d', fm.tae_car_rent_st.value, fm.tae_car_rent_et.value);
		fm.end_rent_link_day.value = est_day;
		var est_amt = (<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>-<%=grt_suc_fee.getFee_s_amt()+grt_suc_fee.getFee_v_amt()%>)/<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;
		est_amt = replaceFloatRound(est_amt);
		fm.end_rent_link_per.value = est_amt;						
		if(est_day > 35 || est_amt > 30){
			tr_tae3.style.display = '';
			fm.end_rent_link_sac_id_text.value = '(�ʼ�)';
		}
		return;
	}
}
<%}%>
//-->
</script>
</body>
</html>
