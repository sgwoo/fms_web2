<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*, acar.kakao.*, acar.cont.*, acar.client.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<jsp:useBean id="atp_db" class="acar.kakao.AlimTemplateDatabase" scope="page"/>
<jsp:useBean id="atl_db" class="acar.kakao.AlimTalkLogDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	String set_code = request.getParameter("set_code")==null?"":request.getParameter("set_code");
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	EstimateBean e_bean1 = new EstimateBean();
	EstimateBean e_bean2 = new EstimateBean();
	EstimateBean e_bean3 = new EstimateBean();
	EstimateBean e_bean4 = new EstimateBean();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
			
	e_bean1 = e_db.getEstimateCase(est_id);
	
	cm_bean = a_cmb.getCarNmCase(e_bean1.getCar_id(), e_bean1.getCar_seq());
	
	//��������
    ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	Vector vars = new Vector();
	int size = 0;
	
	if(e_bean1.getPrint_type().equals("2") || e_bean1.getPrint_type().equals("3") || e_bean1.getPrint_type().equals("4") || e_bean1.getPrint_type().equals("5") || e_bean1.getPrint_type().equals("6")){
		vars = e_db.getABTypeEstIds2(set_code, est_id);
		size = vars.size();
	}else{
		vars = e_db.getABTypeEstIds(set_code, est_id);
		size = vars.size();
	}
	
	
	for(int i = 0 ; i < size ; i++){
		Hashtable var = (Hashtable)vars.elementAt(i);
		
		if(e_bean1.getPrint_type().equals("2") || e_bean1.getPrint_type().equals("3") || e_bean1.getPrint_type().equals("4") || e_bean1.getPrint_type().equals("5") || e_bean1.getPrint_type().equals("6")){
			if(i==0) e_bean1 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==1) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==2) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==3) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));		
		}else{
			if(i==0) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==1) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==2) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
		}		
	}
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//������ ����� ��� ǥ��
	//String etc = umd.getCarCompOne(cm_bean.getCar_comp_id());
	Hashtable com_ht = umd.getCarCompCase(cm_bean.getCar_comp_id());
	String etc 	= String.valueOf(com_ht.get("ETC"));
	//String bigo = String.valueOf(com_ht.get("BIGO"));
	String u_nm ="";
	String u_mt ="";
	String u_ht ="";
	
	UserMngDatabase umdb = UserMngDatabase.getInstance();
	
	UsersBean user_bean = umdb.getUsersBean(e_bean1.getReg_id());
	
	u_nm = user_bean.getUser_nm();
	u_mt = user_bean.getUser_m_tel();
	u_ht = user_bean.getHot_tel();

	if(u_nm.equals("�ڱԼ�")) u_nm = "�ּ���";
	if(u_nm.equals("������")) u_mt = "";
	if(u_nm.equals("�輳��")) u_mt = "";
	if(u_nm.equals("�ǿ�ö")) u_nm = "���缮 ����";
	if(u_nm.equals("�����")) u_nm = "�׻���̷�Ʈ";
	if(u_nm.equals("���Ʊ�")){ u_nm = "��������÷�"; u_mt = u_ht;}
	if(u_nm.equals("���ֹ�")) u_nm = "�����ũ";
	if(u_nm.equals("������2")) u_nm = "�Ƹ����÷���";
	
	if(e_bean1.getCaroff_emp_yn().equals("4")){
		u_nm = e_bean1.getDamdang_nm();
		u_mt = e_bean1.getDamdang_m_tel();
		u_ht = "";	
	}
	
	//���⺻����
	ContBaseBean base = a_db.getCont(e_bean1.getRent_mng_id(), e_bean1.getRent_l_cd());
	
	//��������
	Vector car_mgrs = a_db.getCarMgrListNew(e_bean1.getRent_mng_id(), e_bean1.getRent_l_cd(), "Y");
	int mgr_size = car_mgrs.size();
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//īī�����ø�
	String send_msg = "";
	
	ArrayList<String> sendList = new ArrayList<String>();
	
	sendList.add(e_bean1.getEst_nm());
	sendList.add("�ѽ�");
	sendList.add(u_nm);
	sendList.add(u_mt);
	
	AlimTemplateBean sendTemplateBean = atp_db.selectTemplate("acar0072");
	String send_content_temp = sendTemplateBean.getContent();
	String send_content = sendTemplateBean.getContent();
  	for (String send : sendList) {
  		send_content = send_content.replaceFirst("\\#\\{.*?\\}", send);
	}
  	
  	send_msg = send_content;
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style>
.over_auto {
	overflow: auto !important;
}
.num_weight {
	font-weight: 800 !important;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//��Ϻ���
	function go_list(){
		var fm = document.form1;		
		<%if(from_page.equals("/acar/estimate_mng/esti_mng2_sc_in.jsp")){%>
		fm.action = 'esti_mng2_frame.jsp';
		<%}else if(from_page2.equals("/fms2/bus_analysis/ba_esti_frame.jsp")){%>
		fm.action = '/fms2/bus_analysis/ba_esti_frame.jsp';
		<%}else if(from_page2.equals("/fms2/bus_analysis/ba_stat_frame.jsp")){%>
		fm.action = '/fms2/bus_analysis/ba_stat_frame.jsp';
		<%}else{%>
		fm.action = 'esti_mng_frame.jsp';	
		<%}%>
		fm.target = 'd_content';					
		fm.submit();
	}

	function ReEsti(est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.cmd.value = 're';
		fm.action = 'esti_mng_atype_i.jsp';		
		fm.target = 'd_content';					
		fm.submit();
	}
	
	//�ű�_TODO
	function ReEsti6(est_id, set_code){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.set_code.value = set_code;
		fm.cmd.value = 're';
		fm.action = 'esti_mng_atype_i.jsp';		
		fm.target = 'd_content';					
		fm.submit();
	}
	
	function DelEsti(est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.cmd.value = 'd';
		
		if(!confirm('�����Ͻðڽ��ϱ�? �����Ǹ� �������� �ʽ��ϴ�.')){	
			return; 
		}	
		
		fm.action = 'esti_mng_d_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();
	}		

	//����������
	function EstiView(idx, est_id){
		//������,������ �����Աݽ� ���뿩�� ������ Ȯ��
		if      (idx == 1 && <%=e_bean1.getPp_amt()%> > 0 && <%=e_bean1.getFee_s_amt()%> < 0){
			alert('�� ���뿩��� �������� ������ �ȵ˴ϴ�./n/n(������ �� ������ Ȯ�� �� �������� �ʿ�)');
		}else if(idx == 2 && <%=e_bean2.getPp_amt()%> > 0 && <%=e_bean2.getFee_s_amt()%> < 0){
			alert('�� ���뿩��� �������� ������ �ȵ˴ϴ�./n/n(������ �� ������ Ȯ�� �� �������� �ʿ�)');		
		}else if(idx == 3 && <%=e_bean3.getPp_amt()%> > 0 && <%=e_bean3.getFee_s_amt()%> < 0){
			alert('�� ���뿩��� �������� ������ �ȵ˴ϴ�./n/n(������ �� ������ Ȯ�� �� �������� �ʿ�)');		
		}else if(idx == 4 && <%=e_bean4.getPp_amt()%> > 0 && <%=e_bean4.getFee_s_amt()%> < 0){
			alert('�� ���뿩��� �������� ������ �ȵ˴ϴ�./n/n(������ �� ������ Ȯ�� �� �������� �ʿ�)');		
		}else if(idx == 1 && <%=e_bean1.getPp_amt()%> == 0 && <%=e_bean1.getFee_s_amt()%> <= 0){
			alert('�� �������� �����ϰ� �Է��Ͽ����ϴ�. �������� �ٿ��ּ���');
		}else if(idx == 2 && <%=e_bean2.getPp_amt()%> == 0 && <%=e_bean2.getFee_s_amt()%> <= 0){
			alert('�� �������� �����ϰ� �Է��Ͽ����ϴ�. �������� �ٿ��ּ���');		
		}else if(idx == 3 && <%=e_bean3.getPp_amt()%> == 0 && <%=e_bean3.getFee_s_amt()%> <= 0){
			alert('�� �������� �����ϰ� �Է��Ͽ����ϴ�. �������� �ٿ��ּ���');		
		}else if(idx == 4 && <%=e_bean4.getPp_amt()%> == 0 && <%=e_bean4.getFee_s_amt()%> <= 0){
			alert('�� �������� �����ϰ� �Է��Ͽ����ϴ�. �������� �ٿ��ּ���');			
		}else if(idx == 1 && <%=e_bean1.getCls_per()%> > 100){
			alert('�� �������� �����ϰ� �Է��Ͽ����ϴ�. �������� �ٿ��ּ���');
		}else if(idx == 2 && <%=e_bean2.getCls_per()%> > 100){
			alert('�� �������� �����ϰ� �Է��Ͽ����ϴ�. �������� �ٿ��ּ���');		
		}else if(idx == 3 && <%=e_bean3.getCls_per()%> > 100){
			alert('�� �������� �����ϰ� �Է��Ͽ����ϴ�. �������� �ٿ��ּ���');		
		}else if(idx == 4 && <%=e_bean4.getCls_per()%> > 100){
			alert('�� �������� �����ϰ� �Է��Ͽ����ϴ�. �������� �ٿ��ּ���');			
		}else{
			var SUBWIN="/acar/main_car_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
			window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");
		}	
	}
		
	//���߰���������
	function EstiViewAll(print_type, est_id){
		var SUBWIN="/acar/main_car_hp/estimate_renew.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		if(print_type == 4){
			SUBWIN="/acar/main_car_hp/estimate_renew_all.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		}else if(print_type == 5){
			SUBWIN="/acar/main_car_hp/estimate_comp_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		}else if(print_type == 6){
			SUBWIN="/acar/main_car_hp/estimate_eh_all.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		}
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=798, height=800, scrollbars=yes, status=yes");								
	}
	
	//�������ϱ�
	function CustUpate(){
		var fm = document.form1;
		if(!confirm('�������� �����Ͻðڽ��ϱ�?')){	
			return; 
		}	
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}	
	
	//�������İ��� ����
	function BusUpate(){
		var fm = document.form1;
		if(fm.bus_yn.value == '')	{ 
			alert('��࿩�θ� Ȯ���Ͻʽÿ�.'); 		
			return;
		}
		if(!confirm('�����Ȳ�� �����Ͻðڽ��ϱ�?')){	
			return; 
		}	
		fm.action = 'upd_esti_bus_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}
		
	//����� ����
	function EstiClsPerCng(idx, est_id){
		var fm = document.form1;
		fm.cng_est_id.value = est_id;
		fm.cng_cls_per.value = fm.cls_per[idx].value
		fm.cmd.value = 'cls_per_cng';
		if(!confirm('������������ �����Ͻðڽ��ϱ�?')){	
			return; 
		}	
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();
	}	
	
	//�����뿩��
	function EstiFeeAmtCng(idx, est_id){
		var fm = document.form1;
		
		if(est_id == ''){
			alert('������ �뿩�ᰡ �����ϴ�.');
			return;
		}
		
		fm.cng_est_id.value = est_id;		
		
		window.open('about:blank', "FeeAmtCng", "left=0, top=0, width=450, height=220, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "FeeAmtCng";				
		fm.action = 'upd_esti_amt.jsp';		
		fm.submit();	
	}
	
	//��������Ÿ� ���� - ���뿩��, ���ԿɼǱݾ� ����
	function EstiDistCng(idx, est_id){
		var fm = document.form1;
		
		if(est_id == ''){
			alert('������ ��������Ÿ��� �����ϴ�.');
			return;
		}
		
		fm.cng_est_id.value = est_id;		
		
		window.open('about:blank', "DistCng", "left=0, top=0, width=450, height=420, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "DistCng";				
		fm.action = 'upd_dist_esti_amt.jsp';		
		fm.submit();	
	}
	
	//��������ϱ�
	function select_print(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("������ �����ϼ���.");
			return;
		}	
		
		alert("�μ�̸������ ������ Ȯ���� ����Ͻñ⸦ �����մϴ�.");
		
		fm.target = "_blank";
		fm.action = "/acar/main_car_hp/esti_doc_select_print.jsp";
		fm.submit();	
	}	
	
	//���ø��Ϲ߼�
	function select_email(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("������ �����ϼ���.");
			return;
		}	
		
		fm.target = "_blank";
		fm.action = "/acar/apply/select_mail_input.jsp";
		fm.submit();	
	}		
	
	//��ü�����ϱ�
	function all_delete(){
		var fm = document.form1;
		fm.cmd.value = 'all_delete';		
		
		if(!confirm('�ϰ� �����Ͻðڽ��ϱ�? �����Ǹ� �������� �ʽ��ϴ�.')){	
			return; 
		}
		
		fm.action = 'esti_mng_d_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();				
	}			
	
	//������� ���ں�����
	function esti_result_sms(){
		var fm = document.form1;
		
		if(fm.est_tel.value != '' && fm.est_m_tel.value == ''){
			fm.est_m_tel.value = fm.est_tel.value 
		}
		
		if(fm.est_m_tel.value == ''){ 	
			alert('���Ź�ȣ�� �Է��Ͻʽÿ�'); 	
			fm.est_m_tel.focus();
			return;
		}		
		
		fm.cmd.value = 'result_sms';
		
		if(!confirm('�� ��ȣ�� ������ڸ� �߼��Ͻðڽ��ϱ�?')){
			return; 
		}	
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();
	}
	
	//�����������
	function estimates_view(reg_code){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?car_gu=1&rent_st=1&est_code="+reg_code+"&esti_table=estimate";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//������� ���� �󼼳��� ���ں�����
	function select_esti_result_sms(){
		var fm = document.form1;
						
		if(fm.est_tel.value != '' && fm.est_m_tel.value == ''){ 	
			fm.est_m_tel.value = fm.est_tel.value 
		}		
		
		if(fm.est_m_tel.value == ''){ 	
			alert('���Ź�ȣ�� �Է��Ͻʽÿ�'); 		
			fm.est_m_tel.focus();
			return; 
		}
		
		var caroff_emp_yn = document.getElementsByName("caroff_emp_yn");
		var caroff_emp_yn_value;
		for(var i = 0; i < caroff_emp_yn.length; i++){
		    if(caroff_emp_yn[i].checked){
		    	caroff_emp_yn_value = caroff_emp_yn[i].value;
		    }
		}
		
		if (caroff_emp_yn_value != fm.caroff_emp_yn_origin.value) {
			alert("��� ����� ǥ�ñ����� ���� �����Ϳ� ��ġ���� �ʽ��ϴ�. \n����� ǥ�ñ����� ���� �� �������� �߼� ��Ź�帳�ϴ�.");			
			document.getElementById("caroff_emp_yn1").focus();
			return;
		}				
		
		if (!confirm('�� ��ȣ�� �������ڸ� �߼��Ͻðڽ��ϱ�?')){	
			return; 
		}	
		
		fm.cmd.value = 'result_select_sms_wap';
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';							
		fm.submit();	
	}
	
	//��������� ����
	function dlv_con_commi(){
		var fm = document.form1;
		
		window.open('about:blank', "DlvConCommi", "left=0, top=0, width=500, height=600, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "DlvConCommi";				
		fm.action = 'view_dlv_con_commi.jsp';		
		fm.submit();	
	}
	
	//��üŹ�۷� ��ȸ
	function search_cons_cost(){
		var fm = document.form1;
		
		window.open('about:blank', "SearchConsCost", "left=0, top=0, width=800, height=800, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "SearchConsCost";				
		fm.action = 'search_cons_cost.jsp';		
		fm.submit();	
	}
	
	//�������� ����
	function view_car_nm(car_id, car_seq){
		window.open("/acar/car_mst/car_mst_u.jsp?car_id="+car_id+"&car_seq="+car_seq, "VIEW_CAR_NM", "left=20, top=20, width=875, height=650, scrollbars=yes");		
	}
	
	//������ - �����ϰ�� Ư����� ����
	function doc_type_check() {
		var doc_type_value = $('input:radio[name="doc_type"]:checked').val();		
		/* if (doc_type_value != "1") {
			$("#doc_type_check_div").hide();
			//$('input:checkbox[name="dir_pur_commi_yn"]').attr("checked", "checked");
			$('input:checkbox[name="dir_pur_commi_yn"]').removeAttr("checked");
		} else {
			$("#doc_type_check_div").show();
		} */
	}
	
	//īī�����ø� reload
	function reloadTemplateContent() {
		var customer_name = "<%=e_bean1.getEst_nm()%>";
		var esti_send_way = $("select[name=sms_cont2]").val();
		var manager_name = "<%=u_nm%>";
		var manager_phone = "<%=u_mt%>";
		
		var reg = /\#\{(.*?)\}/g;
	    var idx = 1;	    
		var searchFields = new Object();
	    
	    searchFields.customer_name = customer_name;
	    searchFields.esti_send_way = esti_send_way;
	    searchFields.manager_name = manager_name;
	    searchFields.manager_phone = manager_phone;
	     
	    JSON.stringify(searchFields);
	    
	 	var replace_send_content_temp = $("#send_content_temp").val();
	 	var newLine = String.fromCharCode(13, 10);
	 	var replace_send_content = replace_send_content_temp.replace(/\\n/g, newLine);
	 	
	    var empText = replace_send_content.replace(reg, function(match, p1, offset) {
	        var val = searchFields[p1];
	        /*
	        if (val == undefined || val == "") {
	            val = p1;
	        }
	        */
	        return val;
	    });
	    
	    $("#alim-textarea").val(empText);
	}
	
	function view_car_bbs(){
		var fm = document.form1;
		var car_comp_id = $("#car_comp_id option:selected").val();
		if (car_comp_id == '') {    alert('�����縦 �����Ͻʽÿ�');       return; }
		window.open('about:blank', "ViewCarBbs", "left=0, top=0, width=800, height=800, scrollbars=yes, status=yes, resizable=yes");		
		fm.target = "ViewCarBbs";				
		fm.action = 'view_car_bbs.jsp';		
		fm.submit();	
	}	
	
//-->
</script>
</head>
<body onload="javascript:document.form1.est_nm.focus();">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="" name="form1" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="gubun1" value="<%=gubun1%>">
	<input type="hidden" name="gubun2" value="<%=gubun2%>">
	<input type="hidden" name="gubun3" value="<%=gubun3%>">
	<input type="hidden" name="gubun4" value="<%=gubun4%>">
	<input type="hidden" name="gubun5" value="<%=gubun5%>">
	<input type="hidden" name="gubun6" value="<%=gubun6%>">  
	<input type="hidden" name="s_dt" value="<%=s_dt%>">
	<input type="hidden" name="e_dt" value="<%=e_dt%>">
	<input type="hidden" name="s_kd" value="<%=s_kd%>">
	<input type="hidden" name="t_wd" value="<%=t_wd%>">
	<input type="hidden" name="est_id" value="<%=est_id%>">
	<input type="hidden" name="set_code" value="<%=set_code%>">
	<input type="hidden" name="cmd" value="">
	<input type="hidden" name="s_st" value="<%=cm_bean.getS_st()%>">
	<input type="hidden" name="a_e" value="">
	<input type="hidden" name="a_h" value="">		
	<input type="hidden" name="a_h" value="">		
	<input type="hidden" name="a_h" value="">		
	<input type="hidden" name="a_h" value="">					
	<input type="hidden" name="cng_cls_per" value="">					
	<input type="hidden" name="cng_est_id" value="">					
	<input type="hidden" name="wap_est_id" value="">
	<input type="hidden" name="wap_est_idx" value="">
	<input type="hidden" name="from_page" value="esti_mng_atype_u.jsp">					
	<input type="hidden" name="car_id" value="<%=e_bean1.getCar_id()%>">
	<input type="hidden" name="car_seq" value="<%=e_bean1.getCar_seq()%>">
	<input type="hidden" name="car_amt" value="<%=e_bean1.getCar_amt()%>">
	<input type="hidden" name="opt_amt" value="<%=e_bean1.getOpt_amt()%>">
	<input type="hidden" name="opt_amt_m" value="<%=e_bean1.getOpt_amt_m()%>">
	<input type="hidden" name="col_amt" value="<%=e_bean1.getCol_amt()%>">
	<input type="hidden" name="o_1" value="<%=e_bean1.getO_1()%>">
	<input type="hidden" name="print_type" value="<%=e_bean1.getPrint_type()%>">
	<input type="hidden" name="from_page2" value="<%=from_page2%>">
	<input type="hidden" name="u_nm" value="<%=u_nm%>">
	<input type="hidden" name="u_mt" value="<%=u_mt%>">
	<input type="hidden" name="u_ht" value="<%=u_ht%>">
	<input type="hidden" name="car_comp_id" value="<%=e_bean1.getCar_comp_id()%>">
	<input type="hidden" name="code" value="<%=e_bean1.getCar_cd()%>">
	
	
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �������� > <span class=style5>�������߰�������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span> </td>
        <td align="right"><a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=25%>��ȣ �Ǵ� ����</td>
                    <td class=title width=25%>ȣĪ �Ǵ� ������̸�+ȣĪ</td>
                    <td rowspan='2' width=50%>&nbsp;* ��ȣ �Ǵ� ��������� ����ڸ� ��ȣ����, �����̸� ������ �����ϴ�. <br>&nbsp;&nbsp;&nbsp;&nbsp; ��, (��) �Ǵ� �ֽ�ȸ��� �����Ͽ��� �˴ϴ�.</td>
                </tr>            
                <tr> 
                    <td align='center'> 
                        <input type="text" name="est_nm" value="<%=e_bean1.getEst_nm()%>" size="25" maxlength='50' class=text onKeyDown='javascript:enter()' style='IME-MODE: active'>
                    </td>
                    <td align='center'> 
                        <input type="text" name="mgr_nm" value="<%=e_bean1.getMgr_nm()%>" size="25" class=text>
                        &nbsp;�� ����
                    </td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>           
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr>                   
                    <td class=title width=15%>����ڵ�Ϲ�ȣ</td>
                    <td width=35%> 
                        &nbsp;<input type="text" name="est_ssn" value="<%=e_bean1.getEst_ssn()%>" size="15" class=text>
                    </td>
                    <td class=title width=10%>�̸����ּ�</td>
                    <td colspan="3">&nbsp;<input type="text" name="est_email" value="<%=e_bean1.getEst_email()%>" size="30" class=text style='IME-MODE: inactive'>
                      </td>
                </tr>
                <tr>				
                    <td class=title >��ȭ��ȣ</td>
                    <td > 
                        &nbsp;<input type="text" name="est_tel" value="<%=e_bean1.getEst_tel()%>" size="15" class=text>
                    </td>
                    <td class=title >FAX</td>
                    <td colspan="3"> 
                        &nbsp;<input type="text" name="est_fax" value="<%=e_bean1.getEst_fax()%>" size="15" class=text>
                    </td>
                </tr>									
                <tr>				
                    <td class=title>������</td>
                    <td colspan="5">
                    <%-- &nbsp;<input type="radio" name="doc_type" value="1" <% if(e_bean1.getDoc_type().equals("1")||e_bean1.getDoc_type().equals("")) out.print("checked"); %>>
                      ���ΰ�
					  <input type="radio" name="doc_type" value="2" <% if(e_bean1.getDoc_type().equals("2")) out.print("checked"); %>>
                      ���λ���� 
					  <input type="radio" name="doc_type" value="3" <% if(e_bean1.getDoc_type().equals("3")) out.print("checked"); %>>
                      ���� --%> 					  
                      <div style="float: left;">&nbsp;<label><input type="radio" name="doc_type" value="1" onClick="javascript:doc_type_check()" <% if(e_bean1.getDoc_type().equals("1")||e_bean1.getDoc_type().equals("")) out.print("checked"); %>>
	                      ���ΰ�</label>
	            	  <label><input type="radio" name="doc_type" value="2" onClick="javascript:doc_type_check()" <% if(e_bean1.getDoc_type().equals("2")) out.print("checked"); %>>
	                      ���λ����</label> 
	            	  <label><input type="radio" name="doc_type" value="3" onClick="javascript:doc_type_check()" <% if(e_bean1.getDoc_type().equals("3")) out.print("checked"); %>>
	                      ����</label>&nbsp;(�����п� ���� �������� �ʿ伭���� ǥ���մϴ�.)    
                      </div>           		  
           		  	  <%-- <div style="float: left; <%if (e_bean1.getDoc_type().equals("2") || e_bean1.getDoc_type().equals("3")) {%>display: none;<%}%>" id="doc_type_check_div"> --%>
           		  	  <div style="float: left;" id="doc_type_check_div">
           		  	  &nbsp;&nbsp;&nbsp;
           		  	  <input type="checkbox" id="dir_pur_commi_yn" name="dir_pur_commi_yn" value="Y" <%if (e_bean1.getDir_pur_commi_yn().equals("Y")) out.print("checked"); %>><label for="dir_pur_commi_yn">Ư�����(�����̰�����)</label>
           		  	  </div>
                    </td>
                </tr>					  
                <tr>
                    <td class=title>�ſ뵵</td>
                    <td>&nbsp;<b><% if(e_bean1.getSpr_yn().equals("2")){%>�ʿ췮���<%} else if(e_bean1.getSpr_yn().equals("1")){%>�췮���<% }else if(e_bean1.getSpr_yn().equals("0")){%>�Ϲݱ��<% }else if(e_bean1.getSpr_yn().equals("3")){%>�ż�����<%}%></b>
                      </td>
                    <td width=10% class=title>��������</td>
                    <td width=10%>&nbsp;<select name="bus_st">
                        <option value="">����</option>                        
                        <option value="1" <%if(e_bean1.getBus_st().equals("1")){%>selected<%}%>>���ͳ�</option>
                        <option value="8" <%if(e_bean1.getBus_st().equals("8")){%>selected<%}%>>�����</option>
                        <option value="5" <%if(e_bean1.getBus_st().equals("5")){%>selected<%}%>>��ȭ���</option>
                        <option value="2" <%if(e_bean1.getBus_st().equals("2")){%>selected<%}%>>�������</option>
                        <option value="7" <%if(e_bean1.getBus_st().equals("7")){%>selected<%}%>>������Ʈ</option>
                        <option value="6" <%if(e_bean1.getBus_st().equals("6")){%>selected<%}%>>������ü</option>
                        <option value="3" <%if(e_bean1.getBus_st().equals("3")){%>selected<%}%>>��ü�Ұ�</option>
                        <option value="4" <%if(e_bean1.getBus_st().equals("4")){%>selected<%}%>>catalog</option>
                      </select>
                      </td>                      
                    <td width=10% class=title>����</td>
                    <td width=10%>&nbsp;<input type="radio" name="compare_yn" value="N" <% if(e_bean1.getCompare_yn().equals("N")||e_bean1.getCompare_yn().equals("")) out.print("checked"); %>>
                      ����
					  <input type="radio" name="compare_yn" value="Y" <% if(e_bean1.getCompare_yn().equals("Y")) out.print("checked"); %>>
                      ���� 
                      </td>                      
                </tr>	
                <tr>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td colspan="5">&nbsp;<input type="radio" name="vali_type" value="0" <% if(e_bean1.getVali_type().equals("0")||e_bean1.getVali_type().equals("")) out.print("checked"); %>>
                      ��¥��ǥ��(10��/���, �⺻ 10���̳� 10���� �Ϳ��� �Ѿ ��쿡�� ����� ������ �Ѵ�.)
					  <input type="radio" name="vali_type" value="1" <% if(e_bean1.getVali_type().equals("1")) out.print("checked"); %>>
                      ����ĿD/C ���� ���ɼ� ���(10��) 
					  <input type="radio" name="vali_type" value="2" <% if(e_bean1.getVali_type().equals("2")) out.print("checked"); %>>
                      ��Ȯ������ 
                      </td>
                </tr>				
                <tr>
                    <td class=title>�ʱⳳ�Աݾȳ�����</td>
                    <td colspan="3">&nbsp;<input type="radio" name="pp_ment_yn" value="Y" <%if(e_bean1.getPp_ment_yn().equals("Y"))out.print("checked");%>>
                      ǥ��(�ʱⳳ�Ա��� ������ �ſ뵵�� ���� �ɻ�������� ������ �� �ֽ��ϴ�.)
                      <input type="radio" name="pp_ment_yn" value="N" <% if(e_bean1.getPp_ment_yn().equals("N")||e_bean1.getPp_ment_yn().equals("")) out.print("checked");%>>
                      ��ǥ��
                    </td>
                    <td class=title>������������ ���</td>
                    <td>&nbsp;
                    	<select name="gi_grade" id="gi_grade">               			
	               			<option value="" <%if(e_bean1.getGi_grade().equals("")){%>selected<%}%>>������ǥ��</option>
	               			<option value="1" <%if(e_bean1.getGi_grade().equals("1")){%>selected<%}%>>1���</option>
	               			<option value="2" <%if(e_bean1.getGi_grade().equals("2")){%>selected<%}%>>2���</option>
	               			<option value="3" <%if(e_bean1.getGi_grade().equals("3")){%>selected<%}%>>3���</option>
	               			<option value="4" <%if(e_bean1.getGi_grade().equals("4")){%>selected<%}%>>4���</option>
	               			<option value="5" <%if(e_bean1.getGi_grade().equals("5")){%>selected<%}%>>5���</option>
	               			<option value="6" <%if(e_bean1.getGi_grade().equals("6")){%>selected<%}%>>6���</option>
	               			<option value="7" <%if(e_bean1.getGi_grade().equals("7")){%>selected<%}%>>7���</option>
                		</select>
                    </td>
                </tr>                
                <tr>
                    <td class=title>�����</td>
                    <td colspan="4">&nbsp;<select name='damdang_id' class=default>            
                        <option value="">������</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);
        				%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(e_bean1.getReg_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        			  
		        		&nbsp;&nbsp;&nbsp;
		        		<input type="radio" name="caroff_emp_yn" value="1" <%if(e_bean1.getCaroff_emp_yn().equals("1") || e_bean1.getCaroff_emp_yn().equals("")){%>checked<%}%>  id="caroff_emp_yn1">�����������
		        		<input type="radio" name="caroff_emp_yn" value="2" <%if(e_bean1.getCaroff_emp_yn().equals("2")){%>checked<%}%>  >�����������(��� ����� ǥ��)
		        		<input type="radio" name="caroff_emp_yn" value="3" <%if(e_bean1.getCaroff_emp_yn().equals("3")){%>checked<%}%>  >�����������(��� ����� ��ǥ��)
						<input type="hidden" name="caroff_emp_yn_origin" value="<%=e_bean1.getCaroff_emp_yn()%>">
						
						<!-- 20201020 ���Ҽ�ȯ������ ������������� ǥ��� ����ʿ� ���� �Ʒ� ������ ���Ҽ�ȯ������ ǥ�⿩�� �ӽ� �ּ�ó�� -->
			            <input type="hidden" name="info_st" id="info_st" value="">        			  
					</td>
					<td><%if(e_bean1.getCar_comp_id().equals("0001") || e_bean1.getCar_comp_id().equals("0002")){%><input type="button" class="button" value="��üŹ�۷� ��ȸ" onclick="javascript:search_cons_cost();"><%}%></td>
					<%-- <td class=title>���Ҽ�ȯ�� �ȳ�����</td>
                	<td>&nbsp;
                		<select name="info_st" id="info_st">
                			<option value="" <%if (e_bean1.getInfo_st().equals("")) {%>selected<%}%>>�ȳ���ǥ��</option>
                			<option value="N" <%if (e_bean1.getInfo_st().equals("N")) {%>selected<%}%>>�ȳ�����ǥ��</option>
                		</select>
                	</td> --%>
                </tr>															
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
        <td align="right"><a href="javascript:CustUpate();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=15%>������</td>
                    <td colspan="2"> 
                    	&nbsp;<%=cm_bean.getCar_comp_nm()%>
                    	<% if (!e_bean1.getImport_pur_st().equals("1")) { %>
                    	&nbsp;&nbsp;<input type="text" name="etc" value="<%=etc%>" size="150" class="whitetext" readonly>  
                    	<% } %>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td> 
                      &nbsp;<%=cm_bean.getCar_nm()%> (�����ڵ�:<%=cm_bean.getJg_code()%>)
                      <%if(nm_db.getWorkAuthUser("������",user_id)){%>
                      <a href="javascript:view_car_nm('<%= e_bean1.getCar_id() %>','<%=e_bean1.getCar_seq()%>');"><%= e_bean1.getCar_id() %>, <%=e_bean1.getCar_seq()%></a>
                      <%}%>
                    </td>
                    <td align="center"><input type="button" class="button" value="�ش����� ���� ��������" onclick="javascript:view_car_bbs();"></td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td width=70%> 
                      &nbsp;<%=cm_bean.getCar_name()%></td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getCar_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title>�ɼ�</td>
                    <td> 
                      &nbsp;<%=e_bean1.getOpt()%></td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getOpt_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td> 
                      &nbsp;<%if(!e_bean1.getIn_col().equals("")){%>����: <%}%><%=e_bean1.getCol()%><%if(!e_bean1.getIn_col().equals("")){%>&nbsp;/&nbsp;����: <%=e_bean1.getIn_col()%><%}%><%if(!e_bean1.getGarnish_col().equals("")){%>&nbsp;/&nbsp;���Ͻ�: <%=e_bean1.getGarnish_col()%><%}%></td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getCol_amt())%>��</td>
                </tr>
                <tr>
                	<td class="title">����</td>
                	<td>
                		<%=e_bean1.getConti_rat()%>
                	</td>
                	<td></td>
                </tr>
                <tr> 
                    <td class=title>������DC</td>
                    <td>&nbsp;<input type="text" name="bigo" value="<%=e_bean1.getBigo()%>" size="45" class=whitetext>
                      </td>
                    <td align="right"> 
                      -<%=AddUtil.parseDecimal(e_bean1.getDc_amt())%>��</td>
                </tr>
                <%if(e_bean1.getTax_dc_amt()>0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
                <tr> 
                    <td class=title>���Ҽ� ����</td>
                    <td>&nbsp;�����Һ� �� ������ ���� 
                      </td>
                    <td align="right"> 
                      -<%=AddUtil.parseDecimal(e_bean1.getTax_dc_amt())%>��</td>
                </tr>                
                <%}%>
                <%if(e_bean1.getTax_dc_amt()<0){%>
                <tr> 
                    <td class=title>�����Һ�</td>
                    <td>&nbsp;���� ������ �����Һ� (�����Һ� �����ѵ� �ʰ��ݾ�) 
                      </td>
                    <td align="right"> 
                      <%=AddUtil.parseDecimal(-1*e_bean1.getTax_dc_amt())%>��</td>
                </tr>                
                <%}%>
                <tr> 
                    <td class=title>���</td>
                    <td>
                    <% if (!e_bean1.getImport_pur_st().equals("1")) { %>
                      &nbsp;<%=cm_bean.getEtc()%>
                    <% } %>
                    <%
                    	// 1�� Ź�� �� TP Ź�� �Ұ����� ����Ÿ� �߻� �ȳ�
						// �������� - ����
						String car_etc_ment = "";
						// 1�� Ź�� �� TP �Ұ� ����(100% �ε� Ź�� ����)
						String[] first_tp_code = {
							"6014711", "6014712", "7014311", "7014312", "7014313", "7014314", "8014311", "8014312",
							"9014311", "9014312", "9014313", "9014314", "9015433", "9015436", "9025433", "9025437", "9025439",
							"6024413", "6024414", "6024415", "7024413", "7024414"
						};
						// ������ �ƹ� ǥ�⵵ ���� �ʴ� ����(�����->������ �ε�� �ٷ� �ε��ϴ� ����).
						String[] empty_etc_code = {
							"9017311", "9017312", "9017313", "9017314", "9017315", "9018111", "9018112"
						};
						
						if(Arrays.asList(first_tp_code).indexOf(cm_bean.getJg_code()) > -1){
							car_etc_ment = "1�� Ź��(����� �� ��� �����μ���)�� ���� Ư������ ���� TP(TransPorter) Ź���� �Ұ��Ͽ� �ε�(Road)�� Ź�۵Ǹ� Ź�۰Ÿ���ŭ ����Ÿ��� �߻��˴ϴ�.";
						} else if(Arrays.asList(empty_etc_code).indexOf(cm_bean.getJg_code()) > -1){
							car_etc_ment = "";
						} else if(Integer.parseInt(cm_bean.getJg_code()) > 9000000 && Integer.parseInt(cm_bean.getJg_code()) < 9900000){
							car_etc_ment = "1�� Ź��(����� �� ��� �����μ���)�� ���� Ư������ ���� TP(TransPorter) Ź���� �Ұ��� �� ������ �ε�(Road) Ź�۽� Ź�۰Ÿ���ŭ ����Ÿ��� �߻��˴ϴ�.";
						}
                    %>
                    <% if(!car_etc_ment.equals("")){%>
                    	<%if(!cm_bean.getEtc().equals("")){%><br><%}%><%=car_etc_ment %>
                    <%} %>
                    </td>
                    <td align="center"> &nbsp;
                      </td>
                </tr>                    
                <tr> 
                    <td class=title colspan="2">��������</td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getO_1())%>��</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td></td>
        <td align="right"><a href="javascript:dlv_con_commi();"><img src=/acar/images/center/button_sd_cg.gif align=absmiddle border=0 alt='���������'></a></td>
    </tr>        
    
    
    <!-- START_������ -->
    <% if (!e_bean1.getImport_pur_st().equals("")) { %>
    <tr id="import_content_1">
        <td>
        	<table border=0 cellspacing=0 cellpadding=0 width=100%>
        		<tr>
        			<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
        		</tr>
        	</table>
        	<table border=0 cellspacing=0 cellpadding=0 width=100%>
        		<tr>
			        <td class=line2></td>
			    </tr>
        		<tr>
        			<td class="line">
        				<table border="0" cellspacing="1" width=100%>
			            	<tr> 
			                    <td class=title width="15%">���������</td>
						        <td align="left">&nbsp;
						        	<% if (e_bean1.getImport_pur_st().equals("0")) { %>
						        		��ü���
						        	<% } else if (e_bean1.getImport_pur_st().equals("1")) {%>
						        		���������� (��ü��� ������)
						        	<% }%>
						        </td>
			                </tr>
			            </table>
        			</td>
        		</tr>
        	</table>
        </td>
    </tr>
    <% } %>
    <% if (e_bean1.getImport_pur_st().equals("1")) { %>
    <tr id="import_content_2">
        <td>
        	<table border=0 cellspacing=0 cellpadding=0 width=100%>
        		<tr>
			        <td class=h></td>
			    </tr>
        		<tr>
			        <td class=line2></td>
			    </tr>
        		<tr>
        			<td class="line">
        				<table border="0" cellspacing="1" width=100%>
			            	<tr>
			                    <td class=title width="15%">����鼼����</td>
			                    <td align="left">&nbsp;
			                    	<%=AddUtil.parseDecimal(e_bean1.getCar_b_p2())%>��
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">���ݰ�꼭D/C</td>
			                    <td align="left">&nbsp;
			                    	��Ʈ&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getR_dc_amt())%> �� /&nbsp;
			                    	����&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getL_dc_amt())%> ��
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">ī������ݾ�</td>
			                    <td align="left">&nbsp;
			                    	��Ʈ&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getR_card_amt())%> �� /&nbsp;
			                    	����&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getL_card_amt())%> ��
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">Cash Back</td>
			                    <td align="left">&nbsp;
			                    	��Ʈ&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getR_cash_back())%> �� /&nbsp;
			                    	����&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getL_cash_back())%> ��
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">Ź�۽��ú���</td>
			                    <td align="left">&nbsp;
			                    	��Ʈ&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getR_bank_amt())%> �� /&nbsp;
			                    	����&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getL_bank_amt())%> ��
			                    </td>
			                </tr>
			            </table>
        			</td>
        		</tr>        		
        	</table>
        </td>
    </tr>
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <!-- END_������ -->
    
        
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span>		
		(���������� : <%=AddUtil.ChangeDate3(e_bean1.getRent_dt())%>, ������� : <%=AddUtil.ChangeDate3(e_bean1.getReg_dt())%> <%=c_db.getNameById(e_bean1.getReg_id(),"USER")%> 
		 -<%=set_code%>
		 <%=e_bean1.getReg_code()%> <a href="javascript:estimates_view('<%=e_bean1.getReg_code()%>');">[����1]</a>&nbsp;
		 <%if(!e_bean2.getEst_id().equals("")){%> <%=e_bean2.getReg_code()%> <a href="javascript:estimates_view('<%=e_bean2.getReg_code()%>');">[����2]</a><%}%>&nbsp;
		 <%if(!e_bean3.getEst_id().equals("")){%> <%=e_bean3.getReg_code()%> <a href="javascript:estimates_view('<%=e_bean3.getReg_code()%>');">[����3]</a><%}%>&nbsp;
		 <%if(!e_bean4.getEst_id().equals("")){%> <%=e_bean4.getReg_code()%> <a href="javascript:estimates_view('<%=e_bean4.getReg_code()%>');">[����4]</a><%}%>&nbsp;
		)
		</td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td colspan='2' class=title>����</td>
                  <td width="22%" class=title>����1</td>
                  <td width="21%" class=title><%if(!e_bean2.getEst_id().equals("")){%>����2<%}%></td>
                  <td width="21%" class=title><%if(!e_bean3.getEst_id().equals("")){%>����3<%}%></td>
                  <td width="21%" class=title><%if(!e_bean4.getEst_id().equals("")){%>����4<%}%></td>
                </tr>
                <%if(e_bean1.getPrint_type().equals("6")){%>
                <tr> 
                    <td colspan='2' class=title>�μ�/�ݳ� ����</td>
                    <td>&nbsp;<%if(e_bean1.getReturn_select().equals("0")){%>�μ�/�ݳ� ������<%}else if(e_bean1.getReturn_select().equals("1")){%>�ݳ���<%}else{%><%}%>
                    </td>
                    <td>&nbsp;<%if(e_bean2.getReturn_select().equals("0")){%>�μ�/�ݳ� ������<%}else if(e_bean2.getReturn_select().equals("1")){%>�ݳ���<%}else{%><%}%>
                    </td>
                    <td>&nbsp;<%if(e_bean3.getReturn_select().equals("0")){%>�μ�/�ݳ� ������<%}else if(e_bean3.getReturn_select().equals("1")){%>�ݳ���<%}else{%><%}%>
                    </td>
                    <td>&nbsp;<%if(e_bean4.getReturn_select().equals("0")){%>�μ�/�ݳ� ������<%}else if(e_bean4.getReturn_select().equals("1")){%>�ݳ���<%}else{%><%}%>
                    </td>
                </tr>
                <%}%>	                	
                <tr> 
                    <td colspan='2' class=title>�뿩��ǰ</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean1.getA_a())%>
                    </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%>
                    </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean3.getA_a())%>
                    </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%>
                    </td>
                </tr>
                <tr> 
                    <td colspan='2' class=title>�뿩�Ⱓ</td>
                    <td>&nbsp;<%=e_bean1.getA_b()%>����</td>
                    <td>&nbsp;<%=e_bean2.getA_b()%>����</td>
                    <td>&nbsp;<%=e_bean3.getA_b()%>����</td>
                    <td>&nbsp;<%=e_bean4.getA_b()%>����</td>
                </tr>
                <tr> 
                    <td colspan='2' class=title>������DC</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getDc_amt())%>��
                    </td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getDc_amt())%>��
                    </td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getDc_amt())%>��
                    </td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getDc_amt())%>��
                    </td>
                </tr>
                <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20141223){%>
                <tr> 
                    <td width='3%' rowspan="6" class=title>��<br>��</td>
                    <td class=title width='12%'>ǥ�� �ִ��ܰ�</td>
                    <td>&nbsp;<%=e_bean1.getB_o_13()%>%
                    <%if(e_bean1.getRtn_run_amt_yn().equals("0")){%>&nbsp;&nbsp;ȯ�޴뿩������<%}else if(e_bean1.getRtn_run_amt_yn().equals("1")){%>&nbsp;&nbsp;ȯ�޴뿩�������<%}%>
                    </td>
                    <td>&nbsp;<%=e_bean2.getB_o_13()%>%
                    <%if(e_bean2.getRtn_run_amt_yn().equals("0")){%>&nbsp;&nbsp;ȯ�޴뿩������<%}else if(e_bean2.getRtn_run_amt_yn().equals("1")){%>&nbsp;&nbsp;ȯ�޴뿩�������<%}%>
                    </td>
                    <td>&nbsp;<%=e_bean3.getB_o_13()%>%
                    <%if(e_bean3.getRtn_run_amt_yn().equals("0")){%>&nbsp;&nbsp;ȯ�޴뿩������<%}else if(e_bean3.getRtn_run_amt_yn().equals("1")){%>&nbsp;&nbsp;ȯ�޴뿩�������<%}%>
                    </td>
                    <td>&nbsp;<%=e_bean4.getB_o_13()%>%
                    <%if(e_bean4.getRtn_run_amt_yn().equals("0")){%>&nbsp;&nbsp;ȯ�޴뿩������<%}else if(e_bean4.getRtn_run_amt_yn().equals("1")){%>&nbsp;&nbsp;ȯ�޴뿩�������<%}%>
                    </td>															
                </tr>	                               
                <tr> 
                    <td class=title>ǥ�� ��������Ÿ�</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getB_agree_dist())%>km/��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getB_agree_dist())%>km/��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getB_agree_dist())%>km/��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getB_agree_dist())%>km/��</td>
                </tr>	                			
                <tr> 
                    <td class=title>���� ��������Ÿ�</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getAgree_dist())%>km/��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getAgree_dist())%>km/��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getAgree_dist())%>km/��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>km/��</td>
                </tr>	
                <tr> 
                    <td class=title>���� �ִ��ܰ�</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean1.getO_13()%>%</span></td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean2.getO_13()%>%</span></td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean3.getO_13()%>%</span></td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean4.getO_13()%>%</span></td>															
                </tr>									                
                <%if(e_bean1.getPrint_type().equals("6")){%>
                <tr> 
                    <td class=title>�����ܰ�</td>
                    <td>&nbsp;<%if(e_bean1.getOpt_chk().equals("0")){%>�̰���<%}else if(e_bean1.getOpt_chk().equals("1")){%><span class="num_weight"><%=e_bean1.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%>��<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getOpt_chk().equals("0")){%>�̰���<%}else if(e_bean2.getOpt_chk().equals("1")){%><span class="num_weight"><%=e_bean2.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>��<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getOpt_chk().equals("0")){%>�̰���<%}else if(e_bean3.getOpt_chk().equals("1")){%><span class="num_weight"><%=e_bean3.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>��<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getOpt_chk().equals("0")){%>�̰���<%}else if(e_bean4.getOpt_chk().equals("1")){%><span class="num_weight"><%=e_bean4.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>��<%}%></td>
                </tr>
                <%}else{%>
                <tr> 
                    <td class=title>�����ܰ�</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean1.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%>��</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean2.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>��</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean3.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>��</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean4.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>��</td>
                </tr>									
                <%}%>	                                			
                <tr> 
                    <td class=title>���Կɼ�</td>
                    <td>&nbsp;<%if(e_bean1.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean1.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean2.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean3.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean4.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                </tr>	
                
                <%}else{%>                
                <tr> 
                    <td width='3%' rowspan="3" class=title>��<br>��</td>
                    <td class=title width='7%'>�ִ��ܰ�</td>
                    <td>&nbsp;<%=e_bean1.getO_13()%>%</td>
                    <td>&nbsp;<%=e_bean2.getO_13()%>%</td>
                    <td>&nbsp;<%=e_bean3.getO_13()%>%</td>
                    <td>&nbsp;<%=e_bean4.getO_13()%>%</td>															
                </tr>
                <%if(e_bean1.getPrint_type().equals("6")){%>
                <tr> 
                    <td class=title width='7%'>�����ܰ�</td>
                    <td>&nbsp;<%if(e_bean1.getOpt_chk().equals("0")){%>�̰���<%}else if(e_bean1.getOpt_chk().equals("1")){%><%=e_bean1.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%>��<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getOpt_chk().equals("0")){%>�̰���<%}else if(e_bean2.getOpt_chk().equals("1")){%><%=e_bean2.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>��<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getOpt_chk().equals("0")){%>�̰���<%}else if(e_bean3.getOpt_chk().equals("1")){%><%=e_bean3.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>��<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getOpt_chk().equals("0")){%>�̰���<%}else if(e_bean4.getOpt_chk().equals("1")){%><%=e_bean4.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>��<%}%></td>
                </tr>
                <%}else{%>
                <tr> 
                    <td class=title width='7%'>�����ܰ�</td>
                    <td>&nbsp;<%=e_bean1.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%>��</td>
                    <td>&nbsp;<%=e_bean2.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>��</td>
                    <td>&nbsp;<%=e_bean3.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>��</td>
                    <td>&nbsp;<%=e_bean4.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>��</td>
                </tr>									
                <%}%>
                <tr> 
                    <td class=title>���Կɼ�</td>
                    <td>&nbsp;<%if(e_bean1.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean1.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean2.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean3.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean4.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                </tr>	
                <%}%>			  		  		
                <tr> 
                    <td rowspan="3" class=title>��<br>��</td>
                    <td class=title>������</td>
                    <td>&nbsp;<%=e_bean1.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRg_8_amt())%>��</td>
					<td>&nbsp;<%=e_bean2.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRg_8_amt())%>��</td>
					<td>&nbsp;<%=e_bean3.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRg_8_amt())%>��</td>
					<td>&nbsp;<%=e_bean4.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRg_8_amt())%>��</td>                    
                </tr>
                <tr> 
                    <td class=title>������</td>
					<td>&nbsp;<%=e_bean1.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getPp_amt())%>��</td>
					<td>&nbsp;<%=e_bean2.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getPp_amt())%>��</td>
					<td>&nbsp;<%=e_bean3.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getPp_amt())%>��</td>
					<td>&nbsp;<%=e_bean4.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getPp_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title>���ô뿩��</td>
                    <td>&nbsp;<%=e_bean1.getG_10()%>����ġ</td>
                    <td>&nbsp;<%=e_bean2.getG_10()%>����ġ</td>
                    <td>&nbsp;<%=e_bean3.getG_10()%>����ġ</td>
                    <td>&nbsp;<%=e_bean4.getG_10()%>����ġ</td>															
                </tr>
                <tr> 
                    <td rowspan="6" class=title>��<br>��</td>
                    <td class=title>��������</td>
					<td>&nbsp;<%if(e_bean1.getInsurant().equals("1")){%>�Ƹ���ī<%}else if(e_bean1.getInsurant().equals("2")){%>��<%}%></td>
					<td>&nbsp;<%if(e_bean2.getInsurant().equals("1")){%>�Ƹ���ī<%}else if(e_bean2.getInsurant().equals("2")){%>��<%}%></td>
					<td>&nbsp;<%if(e_bean3.getInsurant().equals("1")){%>�Ƹ���ī<%}else if(e_bean3.getInsurant().equals("2")){%>��<%}%></td>
					<td>&nbsp;<%if(e_bean4.getInsurant().equals("1")){%>�Ƹ���ī<%}else if(e_bean4.getInsurant().equals("2")){%>��<%}%></td>					
                </tr>
                <tr>                     
                    <td class=title>�Ǻ�����</td>
					<td>&nbsp;<%if(e_bean1.getIns_per().equals("1")){%>�Ƹ���ī(��������)<%}else if(e_bean1.getIns_per().equals("2")){%>��(���������)<%}%></td>
					<td>&nbsp;<%if(e_bean2.getIns_per().equals("1")){%>�Ƹ���ī(��������)<%}else if(e_bean2.getIns_per().equals("2")){%>��(���������)<%}%></td>
					<td>&nbsp;<%if(e_bean3.getIns_per().equals("1")){%>�Ƹ���ī(��������)<%}else if(e_bean3.getIns_per().equals("2")){%>��(���������)<%}%></td>
					<td>&nbsp;<%if(e_bean4.getIns_per().equals("1")){%>�Ƹ���ī(��������)<%}else if(e_bean4.getIns_per().equals("2")){%>��(���������)<%}%></td>					
                </tr>
                <tr>
                  <td class=title>�빰/�ڼ�</td>
                  <td>&nbsp;<%if(e_bean1.getIns_dj().equals("1")){%>5õ����/5õ����<%}else if(e_bean1.getIns_dj().equals("2")){%>1���/1���<%}else if(e_bean1.getIns_dj().equals("4")){%>2���/1���<%}else if(e_bean1.getIns_dj().equals("8")){%>3���/1���<%}else if(e_bean1.getIns_dj().equals("3")){%>5���/1���<%}%></td>
                  <td>&nbsp;<%if(e_bean2.getIns_dj().equals("1")){%>5õ����/5õ����<%}else if(e_bean2.getIns_dj().equals("2")){%>1���/1���<%}else if(e_bean2.getIns_dj().equals("4")){%>2���/1���<%}else if(e_bean2.getIns_dj().equals("8")){%>3���/1���<%}else if(e_bean2.getIns_dj().equals("3")){%>5���/1���<%}%></td>
                  <td>&nbsp;<%if(e_bean3.getIns_dj().equals("1")){%>5õ����/5õ����<%}else if(e_bean3.getIns_dj().equals("2")){%>1���/1���<%}else if(e_bean3.getIns_dj().equals("4")){%>2���/1���<%}else if(e_bean3.getIns_dj().equals("8")){%>3���/1���<%}else if(e_bean3.getIns_dj().equals("3")){%>5���/1���<%}%></td>
                  <td>&nbsp;<%if(e_bean4.getIns_dj().equals("1")){%>5õ����/5õ����<%}else if(e_bean4.getIns_dj().equals("2")){%>1���/1���<%}else if(e_bean4.getIns_dj().equals("4")){%>2���/1���<%}else if(e_bean4.getIns_dj().equals("8")){%>3���/1���<%}else if(e_bean4.getIns_dj().equals("3")){%>5���/1���<%}%></td>				  				  				  
                </tr>
                <tr>
                  <td class=title>�����ڿ���</td>
				  <td>&nbsp;<%if(e_bean1.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean1.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean1.getIns_age().equals("3")){%>��24���̻�<%}%></td>
				  <td>&nbsp;<%if(e_bean2.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean2.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean2.getIns_age().equals("3")){%>��24���̻�<%}%></td>
				  <td>&nbsp;<%if(e_bean3.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean3.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean3.getIns_age().equals("3")){%>��24���̻�<%}%></td>
				  <td>&nbsp;<%if(e_bean4.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean4.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean4.getIns_age().equals("3")){%>��24���̻�<%}%></td>
                </tr>
                <tr> 
                    <td class=title>������å��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getCar_ja())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getCar_ja())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getCar_ja())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getCar_ja())%>��</td>										
                </tr>
                <tr> 
                    <td class=title>��������</td>
					<td>&nbsp;<%=e_bean1.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getGi_amt())%>��</td>
					<td>&nbsp;<%=e_bean2.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getGi_amt())%>��</td>
					<td>&nbsp;<%=e_bean3.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getGi_amt())%>��</td>
					<td>&nbsp;<%=e_bean4.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getGi_amt())%>��</td>
                </tr>
                <tr id=tr_com_emp_yn style="display:<%if(e_bean1.getCom_emp_yn().equals("")&&e_bean2.getCom_emp_yn().equals("")&&e_bean3.getCom_emp_yn().equals("")&&e_bean4.getCom_emp_yn().equals("")){%>'none'<%}else{%>''<%}%>">
                  <td colspan='2' class=title><!-- ���� -->������ ��������Ư��</td>
                    <td>&nbsp;<%if(e_bean1.getCom_emp_yn().equals("Y")){%>����<%}else if(e_bean1.getCom_emp_yn().equals("N")){%>�̰���<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getCom_emp_yn().equals("Y")){%>����<%}else if(e_bean2.getCom_emp_yn().equals("N")){%>�̰���<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getCom_emp_yn().equals("Y")){%>����<%}else if(e_bean3.getCom_emp_yn().equals("N")){%>�̰���<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getCom_emp_yn().equals("Y")){%>����<%}else if(e_bean4.getCom_emp_yn().equals("N")){%>�̰���<%}%></td>
                </tr> 
                <tr> 
                    <td rowspan="8" class=title>��<br>Ÿ</td>				
                    <td class=title>��ǰ</td>
                    <td>&nbsp;<%if(e_bean1.getTint_b_yn().equals("Y")){%>2ä�� ���ڽ�<%}%><br>&nbsp;<%if(e_bean1.getTint_s_yn().equals("Y")){%>���� ����(�⺻��)<%}%><br>&nbsp;<%if(e_bean1.getTint_ps_yn().equals("Y")){%>��޽���(��������)<%}%><%if(e_bean1.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">���� : <%=e_bean1.getTint_ps_nm()%></span><%}%><%if(e_bean1.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">��ǰ�� ���ޱݾ�(���ް�) : <%=AddUtil.parseDecimal(e_bean1.getTint_ps_amt())%> ��</span><%}%><br>&nbsp;<%if(e_bean1.getTint_n_yn().equals("Y")){%>��ġ�� ������̼�<%}%><br>&nbsp;<%if(e_bean1.getTint_sn_yn().equals("Y")){%>������� �̽ð� ����<%}%><br>&nbsp;<%if(e_bean1.getTint_bn_yn().equals("Y")){%>���ڽ� ����������(��Ʈ��ķ,������)<%}%><br>&nbsp;<%if(e_bean1.getTint_eb_yn().equals("Y")){%>�̵��� ������(������)<%}%><%if (e_bean1.getTint_cons_amt() != 0) {%><br>&nbsp;�߰�Ź�۷�� : <%=AddUtil.parseDecimal(e_bean1.getTint_cons_amt())%> ��<%}%><br>&nbsp;
                    	<%if(e_bean1.getNew_license_plate().equals("1") || e_bean1.getNew_license_plate().equals("2")){%>������ȣ��<%} else if(e_bean1.getNew_license_plate().equals("0")){%>������ȣ��<%} %>
<%--                     	<%if(e_bean1.getNew_license_plate().equals("1")){%>������ȣ�ǽ�û(������)<%} else if (e_bean1.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û(����/�뱸/����/�λ�)<%}%> --%>
                    	<%-- <%if(e_bean1.getNew_license_plate().equals("1") || e_bean1.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û<%}%> --%>
                    </td>
                    <td>&nbsp;<%if(e_bean2.getTint_b_yn().equals("Y")){%>2ä�� ���ڽ�<%}%><br>&nbsp;<%if(e_bean2.getTint_s_yn().equals("Y")){%>���� ����(�⺻��)<%}%><br>&nbsp;<%if(e_bean2.getTint_ps_yn().equals("Y")){%>��޽���(��������)<%}%><%if(e_bean2.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">���� : <%=e_bean2.getTint_ps_nm()%></span><%}%><%if(e_bean2.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">��ǰ�� ���ޱݾ�(���ް�) : <%=AddUtil.parseDecimal(e_bean2.getTint_ps_amt())%> ��</span><%}%><br>&nbsp;<%if(e_bean2.getTint_n_yn().equals("Y")){%>��ġ�� ������̼�<%}%><br>&nbsp;<%if(e_bean2.getTint_sn_yn().equals("Y")){%>������� �̽ð� ����<%}%><br>&nbsp;<%if(e_bean2.getTint_bn_yn().equals("Y")){%>���ڽ� ����������(��Ʈ��ķ,������)<%}%><br>&nbsp;<%if(e_bean2.getTint_eb_yn().equals("Y")){%>�̵��� ������(������)<%}%><%if (e_bean2.getTint_cons_amt() != 0) {%><br>&nbsp;�߰�Ź�۷�� : <%=AddUtil.parseDecimal(e_bean2.getTint_cons_amt())%> ��<%}%><br>&nbsp;
                    	<%if(e_bean2.getNew_license_plate().equals("1") || e_bean2.getNew_license_plate().equals("2")){%>������ȣ��<%} else if(e_bean2.getNew_license_plate().equals("0")){%>������ȣ��<%} %>
<%--                     	<%if(e_bean2.getNew_license_plate().equals("1")){%>������ȣ�ǽ�û(������)<%} else if (e_bean2.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û(����/�뱸/����/�λ�)<%}%> --%>
                    	<%-- <%if(e_bean2.getNew_license_plate().equals("1") || e_bean2.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û<%}%> --%>
                    </td>
                    <td>&nbsp;<%if(e_bean3.getTint_b_yn().equals("Y")){%>2ä�� ���ڽ�<%}%><br>&nbsp;<%if(e_bean3.getTint_s_yn().equals("Y")){%>���� ����(�⺻��)<%}%><br>&nbsp;<%if(e_bean3.getTint_ps_yn().equals("Y")){%>��޽���(��������)<%}%><%if(e_bean3.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">���� : <%=e_bean3.getTint_ps_nm()%></span><%}%><%if(e_bean3.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">��ǰ�� ���ޱݾ�(���ް�) : <%=AddUtil.parseDecimal(e_bean3.getTint_ps_amt())%> ��</span><%}%><br>&nbsp;<%if(e_bean3.getTint_n_yn().equals("Y")){%>��ġ�� ������̼�<%}%><br>&nbsp;<%if(e_bean3.getTint_sn_yn().equals("Y")){%>������� �̽ð� ����<%}%><br>&nbsp;<%if(e_bean3.getTint_bn_yn().equals("Y")){%>���ڽ� ����������(��Ʈ��ķ,������)<%}%><br>&nbsp;<%if(e_bean3.getTint_eb_yn().equals("Y")){%>�̵��� ������(������)<%}%><%if (e_bean3.getTint_cons_amt() != 0) {%><br>&nbsp;�߰�Ź�۷�� : <%=AddUtil.parseDecimal(e_bean3.getTint_cons_amt())%> ��<%}%><br>&nbsp;
                    <%if(e_bean3.getNew_license_plate().equals("1") || e_bean3.getNew_license_plate().equals("2")){%>������ȣ��<%} else if(e_bean3.getNew_license_plate().equals("0")){%>������ȣ��<%} %>
<%--                     <%if(e_bean3.getNew_license_plate().equals("1")){%>������ȣ�ǽ�û(������)<%} else if (e_bean3.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û(����/�뱸/����/�λ�)<%}%> --%>
                    <%-- <%if(e_bean3.getNew_license_plate().equals("1") || e_bean3.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û<%}%> --%>
                    </td>
                    <td>&nbsp;<%if(e_bean4.getTint_b_yn().equals("Y")){%>2ä�� ���ڽ�<%}%><br>&nbsp;<%if(e_bean4.getTint_s_yn().equals("Y")){%>���� ����(�⺻��)<%}%><br>&nbsp;<%if(e_bean4.getTint_ps_yn().equals("Y")){%>��޽���(��������)<%}%><%if(e_bean4.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">���� : <%=e_bean4.getTint_ps_nm()%></span><%}%><%if(e_bean4.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">��ǰ�� ���ޱݾ�(���ް�) : <%=AddUtil.parseDecimal(e_bean4.getTint_ps_amt())%> ��</span><%}%><br>&nbsp;<%if(e_bean4.getTint_n_yn().equals("Y")){%>��ġ�� ������̼�<%}%><br>&nbsp;<%if(e_bean4.getTint_sn_yn().equals("Y")){%>������� �̽ð� ����<%}%><br>&nbsp;<%if(e_bean4.getTint_bn_yn().equals("Y")){%>���ڽ� ����������(��Ʈ��ķ,������)<%}%><br>&nbsp;<%if(e_bean4.getTint_eb_yn().equals("Y")){%>�̵��� ������(������)<%}%><%if (e_bean4.getTint_cons_amt() != 0) {%><br>&nbsp;�߰�Ź�۷�� : <%=AddUtil.parseDecimal(e_bean4.getTint_cons_amt())%> ��<%}%><br>&nbsp;
                    <%if(e_bean4.getNew_license_plate().equals("1") || e_bean4.getNew_license_plate().equals("2")){%>������ȣ��<%} else if(e_bean4.getNew_license_plate().equals("0")){%>������ȣ��<%} %>
<%--                     <%if(e_bean4.getNew_license_plate().equals("1")){%>������ȣ�ǽ�û(������)<%} else if (e_bean4.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û(����/�뱸/����/�λ�)<%}%> --%>
                    <%-- <%if(e_bean4.getNew_license_plate().equals("1") || e_bean4.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û<%}%> --%>
                    </td>
                </tr>
                <%-- <tr> 
                    <td class=title>������ ���ּ���</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean1.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean2.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean3.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean4.getEcar_loc_st())%></td>
                </tr> --%>
                <%if (ej_bean.getJg_g_7().equals("3")) {%>
                <tr>
                    <td class=title>������ ���ּ���</td>
                    <td>&nbsp;<%if(!( cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113") )){%><%=c_db.getNameByIdCode("0034", "", e_bean1.getEcar_loc_st())%><%}%></td>
                    <td>&nbsp;<%if(!( cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113") )){%><%=c_db.getNameByIdCode("0034", "", e_bean2.getEcar_loc_st())%><%}%></td>
                    <td>&nbsp;<%if(!( cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113") )){%><%=c_db.getNameByIdCode("0034", "", e_bean3.getEcar_loc_st())%><%}%></td>
                    <td>&nbsp;<%if(!( cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113") )){%><%=c_db.getNameByIdCode("0034", "", e_bean4.getEcar_loc_st())%><%}%></td>
                </tr>
                <%} else if (ej_bean.getJg_g_7().equals("4")) {%>
                <tr>
                    <td class=title>������ ���ּ���</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0037", "", e_bean1.getHcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0037", "", e_bean2.getHcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0037", "", e_bean3.getHcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0037", "", e_bean4.getHcar_loc_st())%></td>
                </tr>
                <%} else {%>
                <tr>
                    <td class=title>������ ���ּ���</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean1.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean2.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean3.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean4.getEcar_loc_st())%></td>
                </tr>
                <%}%>
                <%if (!e_bean1.getEco_e_tag().equals("") && !(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4"))) {%>
                <tr> 
                    <td class=title>�������ｺƼĿ �߱�</td>
                    <td>&nbsp;<%if(e_bean1.getEco_e_tag().equals("0")){%>�̹߱�<%}else if(e_bean1.getEco_e_tag().equals("1")){%>�߱�<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getEco_e_tag().equals("0")){%>�̹߱�<%}else if(e_bean2.getEco_e_tag().equals("1")){%>�߱�<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getEco_e_tag().equals("0")){%>�̹߱�<%}else if(e_bean3.getEco_e_tag().equals("1")){%>�߱�<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getEco_e_tag().equals("0")){%>�̹߱�<%}else if(e_bean4.getEco_e_tag().equals("1")){%>�߱�<%}%></td>
                </tr>
                <%}%>
                <tr> 
                    <td class=title>�����ε�����</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0033", "", e_bean1.getLoc_st())%><%-- <span <%if (!e_bean1.getCar_comp_id().equals("0056")) {%>style="display: none;"<%}%>>(���ﰭ�����񽺼��Ϳ��� ���� �� �ε�)</span> --%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0033", "", e_bean2.getLoc_st())%><%-- <span <%if (!e_bean2.getCar_comp_id().equals("0056")) {%>style="display: none;"<%}%>>(���ﰭ�����񽺼��Ϳ��� ���� �� �ε�)</span> --%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0033", "", e_bean3.getLoc_st())%><%-- <span <%if (!e_bean3.getCar_comp_id().equals("0056")) {%>style="display: none;"<%}%>>(���ﰭ�����񽺼��Ϳ��� ���� �� �ε�)</span> --%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0033", "", e_bean4.getLoc_st())%><%-- <span <%if (!e_bean4.getCar_comp_id().equals("0056")) {%>style="display: none;"<%}%>>(���ﰭ�����񽺼��Ϳ��� ���� �� �ε�)</span> --%></td>
                </tr>
                <tr> 
                    <td class=title>�����μ�����</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0035", "", e_bean1.getUdt_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0035", "", e_bean2.getUdt_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0035", "", e_bean3.getUdt_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0035", "", e_bean4.getUdt_st())%></td>
                </tr>	                		                                
                <tr> 
                    <td class=title>�ǵ������</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean1.getA_h())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean2.getA_h())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean3.getA_h())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean4.getA_h())%></td>
                </tr>			
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;������<%=e_bean1.getO_11()%>%</td>
                    <td>&nbsp;������<%=e_bean2.getO_11()%>%</td>
                    <td>&nbsp;������<%=e_bean3.getO_11()%>%</td>
                    <td>&nbsp;������<%=e_bean4.getO_11()%>%</td>
                </tr>											
                <tr> 
                    <td class=title>�뿩��D/C</td>
                    <td>&nbsp;�뿩����<%=e_bean1.getFee_dc_per()%>%</td>
                    <td>&nbsp;�뿩����<%=e_bean2.getFee_dc_per()%>%</td>
                    <td>&nbsp;�뿩����<%=e_bean3.getFee_dc_per()%>%</td>
                    <td>&nbsp;�뿩����<%=e_bean4.getFee_dc_per()%>%</td>
                </tr>	                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span>
		</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td colspan='2' class=title>����</td>
                  <td colspan='12'>&nbsp;<%if(e_bean1.getPrint_type().equals("1")){%>��ǰ��<%}%>
					<%if(e_bean1.getPrint_type().equals("2")){%>��Ʈ<%}%>
					<%if(e_bean1.getPrint_type().equals("3")){%>����<%}%>
					<%if(e_bean1.getPrint_type().equals("4")){%>����<%}%>
					<%if(e_bean1.getPrint_type().equals("5")){%>������ ����<%}%>
					<%if(e_bean1.getPrint_type().equals("6")){%>������ �μ�/ �ݳ� ������ �� �ݳ��� ����<%}%>
					<%if(e_bean1.getPrint_type().equals("2")||e_bean1.getPrint_type().equals("3")||e_bean1.getPrint_type().equals("4")||e_bean1.getPrint_type().equals("5")||e_bean1.getPrint_type().equals("6")){%>
						<%if(e_bean1.getPrint_type().equals("2") || e_bean1.getPrint_type().equals("3") || e_bean1.getPrint_type().equals("4")){ // ��Ʈ, ����, ���� ���� �� ������ ���� ������ ���  %>
					&nbsp;<a href="javascript:EstiViewAll('5','<%=e_bean1.getEst_id()%>')" title='������ ����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
						<%}else{ %>
					&nbsp;<a href="javascript:EstiViewAll('<%=e_bean1.getPrint_type()%>','<%=e_bean1.getEst_id()%>')" title='������ ����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
						<%}%>
					<%}%>
                  </td>
                </tr>	            
                <tr>
                  <td colspan='2' class=title>����</td>
                  <td colspan="3" class=title><%if(!e_bean1.getPrint_type().equals("6")){%><input type="checkbox" name="ch_l_cd" value="<%=e_bean1.getEst_id()%>" checked ><%}%>����1</td>
                  <td colspan="3" class=title><%if(!e_bean2.getEst_id().equals("")){%><%if(!e_bean2.getPrint_type().equals("6")){%><input type="checkbox" name="ch_l_cd" value="<%=e_bean2.getEst_id()%>" checked><%}%><%}%>����2</td>
                  <td colspan="3" class=title><%if(!e_bean3.getEst_id().equals("")){%><%if(!e_bean2.getPrint_type().equals("6")){%><input type="checkbox" name="ch_l_cd" value="<%=e_bean3.getEst_id()%>" checked><%}%><%}%>����3</td>
                  <td colspan="3" class=title><%if(!e_bean4.getEst_id().equals("")){%><%if(!e_bean2.getPrint_type().equals("6")){%><input type="checkbox" name="ch_l_cd" value="<%=e_bean4.getEst_id()%>" checked><%}%><%}%>����4</td>
                </tr>		
                <tr> 
                    <td width='3%' rowspan="3" class=title>��<br>��<br>��<br>��</td>				
                    <td class=title>���ް�</td>
                    <td width="13%">&nbsp;<%if(e_bean1.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getDriver_add_amt()*0.9)%>��<%}%></td>
                    <td width="3%" rowspan="3" align="center">��<br>
                    ��<br>
                    ��</td>
                    <td width="8%">&nbsp;<%=AddUtil.parseDecimal(e_bean1.getCtr_s_amt())%>��</td>
                    <td width="11%">&nbsp;<%if(e_bean2.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getDriver_add_amt()*0.9)%>��<%}%></td>
                    <td width="3%" rowspan="3" align="center">��<br>
                      ��<br>
                    ��</td>
                    <td width="8%">&nbsp;<%=AddUtil.parseDecimal(e_bean2.getCtr_s_amt())%>��</td>
                    <td width="11%">&nbsp;<%if(e_bean3.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getDriver_add_amt()*0.9)%>��<%}%></td>
                    <td width="3%" rowspan="3" align="center">��<br>
                      ��<br>
                    ��</td>
                    <td width="8%">&nbsp;<%=AddUtil.parseDecimal(e_bean3.getCtr_s_amt())%>��</td>
                    <td width="11%">&nbsp;<%if(e_bean4.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getDriver_add_amt()*0.9)%>��<%}%></td>
                    <td width="3%" rowspan="3" align="center">��<br>
                      ��<br>
                    ��</td>
                    <td width="8%">&nbsp;<%=AddUtil.parseDecimal(e_bean4.getCtr_s_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td>&nbsp;<%if(e_bean1.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt()*0.1)%>��<%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getCtr_v_amt())%>��</td>
                    <td>&nbsp;<%if(e_bean2.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt()*0.1)%>��<%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getCtr_v_amt())%>��</td>
                    <td>&nbsp;<%if(e_bean3.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt()*0.1)%>��<%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getCtr_v_amt())%>��</td>
                    <td>&nbsp;<%if(e_bean4.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt()*0.1)%>��<%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getCtr_v_amt())%>��</td>
                </tr>						
                <tr> 
                    <td class=title>���뿩��</td>
                    <td>&nbsp;<%if(e_bean1.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt())%>��&nbsp;<a href="javascript:EstiFeeAmtCng(0, '<%=e_bean1.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a><%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getCtr_s_amt()+e_bean1.getCtr_v_amt())%>��</td>
                    <td>&nbsp;<%if(e_bean2.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt())%>��&nbsp;<a href="javascript:EstiFeeAmtCng(1, '<%=e_bean2.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a><%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getCtr_s_amt()+e_bean2.getCtr_v_amt())%>��</td>
                    <td>&nbsp;<%if(e_bean3.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt())%>��&nbsp;<a href="javascript:EstiFeeAmtCng(2, '<%=e_bean3.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a><%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getCtr_s_amt()+e_bean3.getCtr_v_amt())%>��</td>
                    <td>&nbsp;<%if(e_bean4.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt())%>��&nbsp;<a href="javascript:EstiFeeAmtCng(3, '<%=e_bean4.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a><%}%></td>															
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getCtr_s_amt()+e_bean4.getCtr_v_amt())%>��</td>
                </tr>		
                <tr> 
                    <td rowspan="2" class=title>��<br>��<br>��</td>				
                    <td class=title>�ʿ�������</td>
                    <td colspan="3">&nbsp;<%=e_bean1.getCls_n_per()%>%</td>
                    <td colspan="3">&nbsp;<%=e_bean2.getCls_n_per()%>%</td>
                    <td colspan="3">&nbsp;<%=e_bean3.getCls_n_per()%>%</td>
                    <td colspan="3">&nbsp;<%=e_bean4.getCls_n_per()%>%</td>
                </tr>
                <tr> 
                    <td class=title>����������</td>
                    <td>
                    &nbsp;<input type="text" name="cls_per" size="4" value='<%=e_bean1.getCls_per()%>' class=num>%&nbsp;<a href="javascript:EstiClsPerCng(0, '<%=e_bean1.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a></td>
                    <td align="center">��<br/>��<br/>��</td>
                    <td>&nbsp;<%=e_bean1.getCtr_cls_per()%>%</td>
                    <td>&nbsp;<input type="text" name="cls_per" size="4" value='<%=e_bean2.getCls_per()%>' class=num>%&nbsp;<a href="javascript:EstiClsPerCng(1, '<%=e_bean2.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a></td>
                    <td align="center">��<br/>��<br/>��</td>
                    <td>&nbsp;<%=e_bean2.getCtr_cls_per()%>%</td>
                    <td>&nbsp;<input type="text" name="cls_per" size="4" value='<%=e_bean3.getCls_per()%>' class=num>%&nbsp;<a href="javascript:EstiClsPerCng(2, '<%=e_bean3.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a></td>
                    <td align="center">��<br/>��<br/>��</td>
                    <td>&nbsp;<%=e_bean3.getCtr_cls_per()%>%</td>
                    <td>&nbsp;<input type="text" name="cls_per" size="4" value='<%=e_bean4.getCls_per()%>' class=num>%&nbsp;<a href="javascript:EstiClsPerCng(3, '<%=e_bean4.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a></td>
                	<td align="center">��<br/>��<br/>��</td>
                    <td>&nbsp;<%=e_bean4.getCtr_cls_per()%>%</td>
                </tr>	
                <%if(e_bean1.getPrint_type().equals("1")){ //���������� ��ǰ �� ��츸 �� ������ ���������Ⱑ ����(20181002) %>	       
                <tr> 
                    <td colspan='2' class=title>������</td>
                    <td colspan="3">&nbsp;<a href="javascript:EstiView(1,'<%=e_bean1.getEst_id()%>')" title='������ ����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                    <td colspan="3">&nbsp;<%if(!e_bean2.getEst_id().equals("")){%><a href="javascript:EstiView(2,'<%=e_bean2.getEst_id()%>')" title='������ ����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a><%}%></td>
                    <td colspan="3">&nbsp;<%if(!e_bean3.getEst_id().equals("")){%><a href="javascript:EstiView(3,'<%=e_bean3.getEst_id()%>')" title='������ ����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a><%}%></td>
                    <td colspan="3">&nbsp;<%if(!e_bean4.getEst_id().equals("")){%><a href="javascript:EstiView(4,'<%=e_bean4.getEst_id()%>')" title='������ ����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a><%}%></td>
                </tr>
                <%} %>
                			
                <tr> 
                    <td colspan='2' class=title>�񱳰���</td>
                    <td colspan="3">&nbsp;
                    	<%if (e_bean1.getPrint_type().equals("6")) {%>
                    	<%-- <a href="javascript:ReEsti6('<%=e_bean1.getEst_id()%>','<%=e_bean1.getSet_code()%>');" title='�񱳰���'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a> --%>
                    	<%} else {%>
                    	<a href="javascript:ReEsti('<%=e_bean1.getEst_id()%>');" title='�񱳰���'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a>
                    	<%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean2.getEst_id().equals("") && !e_bean2.getPrint_type().equals("6")){%><a href="javascript:ReEsti('<%=e_bean2.getEst_id()%>');" title='�񱳰���'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a><%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean3.getEst_id().equals("") && !e_bean3.getPrint_type().equals("6")){%><a href="javascript:ReEsti('<%=e_bean3.getEst_id()%>');" title='�񱳰���'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a><%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean4.getEst_id().equals("") && !e_bean4.getPrint_type().equals("6")){%><a href="javascript:ReEsti('<%=e_bean4.getEst_id()%>');" title='�񱳰���'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a><%}%>
                    </td>
                </tr>
                
                <%if(!e_bean1.getUse_yn().equals("N")){%>
                <tr style="display: <%if(e_bean1.getPrint_type().equals("6")){%>none<%}else{%><%}%>"> 
                    <td colspan='2' class=title>����</td>
                    <td colspan="3">&nbsp;
                    	<a href="javascript:DelEsti('<%=e_bean1.getEst_id()%>');" title='����'><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean2.getEst_id().equals("")){%><a href="javascript:DelEsti('<%=e_bean2.getEst_id()%>');" title='����'><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a><%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean3.getEst_id().equals("")){%><a href="javascript:DelEsti('<%=e_bean3.getEst_id()%>');" title='����'><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a><%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean4.getEst_id().equals("")){%><a href="javascript:DelEsti('<%=e_bean4.getEst_id()%>');" title='����'><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a><%}%>
                    </td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������İ��� (����ü�� ���� �Է�)</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=15%>��࿩��</td>
                    <td>&nbsp;<select name="bus_yn">
                        <option value="">����</option>
                        <!--<option value="Y" <%if(e_bean1.getBus_yn().equals("Y"))%>selected<%%>>���</option>-->
                        <option value="N" <%if(e_bean1.getBus_yn().equals("N"))%>selected<%%>>�̰��</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class=title>�����Ȳ</td>
                    <td>&nbsp;<textarea name='bus_cau' rows='5' cols='100' maxlenght='500'><%=e_bean1.getBus_cau()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
        <td align="right"><a href="javascript:BusUpate();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>    
    <tr> 
        <td align=right colspan="2">&nbsp; </td>
    </tr>
    <tr> 
        <td align=right colspan="2">&nbsp; </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
    <%if(!e_bean1.getUse_yn().equals("N")){%>
	
    <tr> 
        <td align=center colspan="2"> 
	<%if(size>0){%>
		<%if(!e_bean1.getPrint_type().equals("6")){%>
            <a href="javascript:select_print();" title='���� ����ϱ�'><img src=/acar/images/center/button_print_se.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
            <a href='javascript:select_email();' title='���ø��Ϲ߼��ϱ�'><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;        
            <a href='javascript:all_delete();' title='��ü �����ϱ�'><img src=/acar/images/center/button_delete_s.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
        <%}%>	            
	<%}%>	
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2">
        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����˸��� �߼�</span>
        	&nbsp;&nbsp;* �˸��� ������ ����� �� ���Ź�ȣ�� ��ܿ��� �Էµ� �������� �������� ǥ��˴ϴ�.
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr>
    <%
		String url1 = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		String url2 = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id="+e_bean2.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		String url3 = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id="+e_bean3.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		String url4 = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id="+e_bean4.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		//���հ��� short url �߰� (20181002)
		String url_total = "";
		if(!e_bean1.getPrint_type().equals("1")){
			if(e_bean1.getPrint_type().equals("4")){
				url_total = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew_all.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
			}else if(e_bean1.getPrint_type().equals("5")){
				url_total = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_comp_fms.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
			}else if(e_bean1.getPrint_type().equals("6")){
				url_total = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_eh_all.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";	
			}else{
				url_total = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
			}
		}
	%>
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title>���Ź�ȣ</td>
					<td>&nbsp;
						<select name="s_destphone" onchange="javascript:document.form1.est_m_tel.value=this.value;">
							<option value="">����</option>
	        				<%if(!client.getM_tel().equals("")){%>
	        				<option value="<%=client.getM_tel()%>">[��&nbsp;&nbsp;&nbsp;ǥ&nbsp;&nbsp;&nbsp;��] <%=client.getM_tel()%> <%=client.getClient_nm()%></option>
	        				<%}%>
	        				<%if(!client.getCon_agnt_m_tel().equals("")){%>
	        				<option value="<%=client.getCon_agnt_m_tel()%>">[���ݰ�꼭] <%=client.getCon_agnt_m_tel()%> <%=client.getCon_agnt_nm()%></option>
	        				<%}%>
	        				<%for(int i = 0 ; i < mgr_size ; i++){
	        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
	        					if(!mgr.getMgr_m_tel().equals("")){%>
	        					<option value="<%=mgr.getMgr_m_tel()%>" >[<%=mgr.getMgr_st()%>] <%=mgr.getMgr_m_tel()%> <%=mgr.getMgr_nm()%> <%=mgr.getMgr_title()%></option>
	        				<%}}%>
	        				<%if (!e_bean1.getEst_tel().equals("")) {%>
	        					<option value="<%=e_bean1.getEst_tel()%>" selected>[��� ������ó] <%=e_bean1.getEst_tel()%></option>
	        				<%}%>
        			  	</select>
        			  	&nbsp;&nbsp;
						��ȣ : <input type="text" name="est_m_tel" value="<%=e_bean1.getEst_tel()%>" size="20" class="text">
					</td>
				</tr>			
                <tr>
                  	<td width="10%" class=title>�ѽ�/���Ϲ߼� �˸���</td>
                  	<td width="90%">&nbsp;
				  		<%-- <input type="text" name="sms_cont1" value="<%=e_bean1.getEst_nm()%> ���Բ��� ��û�Ͻ� ��������" size="70" class=whitetext readOnly>
						<br>
						&nbsp;
						<select name='sms_cont2' id="'send_sms_cont2'" onchange="reloadTemplateContent();">            
	                        <option value="">����</option>					
	                        <option value="�ѽ�" selected>�ѽ�</option>
	                        <option value="����">����</option>
						</select>
						<input type="text" name="sms_cont3" value="�� �������� Ȯ�� �ٶ��ϴ�. �ñ��� ���� ������ �������� ��ȭ�ּ���. ����ڴ� <%=u_nm%> <%=u_mt%> �Դϴ�. (��)�Ƹ���ī" size="120" class=whitetext readOnly> --%>
						������ �߼� ��� :&nbsp;
                  		<select name='sms_cont2' id="send_sms_cont2" onchange="reloadTemplateContent();">
	                        <option value="">����</option>
	                        <option value="�ѽ�" selected>�ѽ�</option>
	                        <option value="����">����</option>
						</select><br><br>&nbsp;
						<textarea id="send_content_temp" style="display: none;"><%=send_content_temp%></textarea>						
						<textarea id="alim-textarea" rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=send_msg%></textarea>
				  	</td>
                </tr>	
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" align="right">
        	<a href="javascript:esti_result_sms();" title='���ں�����'>
        		<img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0>
        	</a>
        </td>
    </tr>
    <tr>
        <td class="h" colspan="2"></td>
    </tr>
    <tr>
        <td class="line2" colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
            	<input type="hidden" name="a_car_name" value="<%=cm_bean.getCar_nm()%>">
         	<%if (e_bean1.getPrint_type().equals("1")) {%>
         		<%if (!e_bean1.getEst_id().equals("")) {
						// String a_a = e_bean1.getA_a().substring(0,1);
						// String rent_way = e_bean1.getA_a().substring(1);
						String s_a_a = "";
						String s_rent_way = "";
						
						String a_a = "";
						String rent_way = "";
						if(!e_bean1.getA_a().equals("")){
							a_a = e_bean1.getA_a().substring(0,1);
							rent_way = e_bean1.getA_a().substring(1);
						}
						
						
						if (a_a.equals("1")) {
							s_a_a="�����÷���";
						} else {
							s_a_a="��ⷻƮ";
						}
						
						if (rent_way.equals("1")) {
							s_rent_way="�Ϲݽ�(��������)";
						} else {
							s_rent_way="�⺻��";
						}
						//�����뿩�ᰡ �ִٸ�
						if (e_bean1.getCtr_s_amt()>0) {
							e_bean1.setFee_s_amt(e_bean1.getCtr_s_amt());
							e_bean1.setFee_v_amt(e_bean1.getCtr_v_amt());
						}
						
						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean1.getO_1()));
						fieldList.add(s_a_a);
						fieldList.add(s_rent_way);
						fieldList.add(e_bean1.getA_b());
						fieldList.add(AddUtil.parseDecimal(e_bean1.getGtr_amt()));
						fieldList.add(String.valueOf(e_bean1.getRg_8()));						
						fieldList.add(AddUtil.parseDecimal(e_bean1.getAgree_dist()));
						fieldList.add(AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt()));
						fieldList.add(url1);
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						//System.out.println(fieldList);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
                %>
				<tr>
					<td width="10%" class=title>
						<input type="checkbox" name="ch_mms_id" value="<%=e_bean1.getEst_id()%>" checked>���� �˸���1
					</td>
                  	<td width="90%">&nbsp;
	                  	<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">������ ��û�Ͻ� �����ȳ�. <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean1.getO_1())%>�� <%=c_db.getNameByIdCode("0009", "", e_bean1.getA_a())%><%if(e_bean1.getA_a().equals("11") || e_bean1.getA_a().equals("21")){%>(��������)<%}%> <%=e_bean1.getA_b()%>���� ������<%=e_bean1.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean1.getAgree_dist())%>km/�� <%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt())%>�� VAT���� (������ ���� : <%=url1 %> ) ����ڴ� <%=u_nm%> <%=u_mt%> �Դϴ�. (��)�Ƹ���ī </textarea> --%>
	                  	<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
	                  	<input type="hidden" name="a_url" value="<%=url1%>">
	                  	<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
	                  	<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
		  			</td>
				</tr>	                
                <%}%>
                <%if (!e_bean2.getEst_id().equals("")) {
						// String a_a = e_bean2.getA_a().substring(0,1);
						// String rent_way = e_bean2.getA_a().substring(1);
						String a_a = "";
						String rent_way = "";
						if(!e_bean2.getA_a().equals("")){
							a_a = e_bean2.getA_a().substring(0,1);
							rent_way = e_bean2.getA_a().substring(1);
						}
						String s_a_a = "";
						String s_rent_way = "";
						
						if (a_a.equals("1")) {
							s_a_a = "�����÷���";
						} else {
							s_a_a = "��ⷻƮ";
						}
						
						if (rent_way.equals("1")) {
							s_rent_way="�Ϲݽ�(��������)";
						} else {
							s_rent_way="�⺻��";
						}
						//�����뿩�ᰡ �ִٸ�
						if (e_bean2.getCtr_s_amt()>0) {
							e_bean2.setFee_s_amt(e_bean2.getCtr_s_amt());
							e_bean2.setFee_v_amt(e_bean2.getCtr_v_amt());
						}						

						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean2.getO_1()));
						fieldList.add(s_a_a);
						fieldList.add(s_rent_way);
						fieldList.add(e_bean2.getA_b());
						fieldList.add(AddUtil.parseDecimal(e_bean2.getGtr_amt()));
						fieldList.add(String.valueOf(e_bean2.getRg_8()));						
						fieldList.add(AddUtil.parseDecimal(e_bean2.getAgree_dist()));
						fieldList.add(AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt()));
						fieldList.add(url2);
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
                %>
                <tr>
					<td width="10%" class=title><input type="checkbox" name="ch_mms_id" value="<%=e_bean2.getEst_id()%>" checked>���� �˸���2</td>
        	        <td width="90%">&nbsp;
                  		<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">������ ��û�Ͻ� �����ȳ�.  <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean2.getO_1())%>�� <%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%><%if(e_bean2.getA_a().equals("11") || e_bean2.getA_a().equals("21")){%>(��������)<%}%> <%=e_bean2.getA_b()%>���� ������<%=e_bean2.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean2.getAgree_dist())%>km/�� <%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt())%>�� VAT���� (������ ���� : <%=url2 %> ) ����ڴ� <%=u_nm%> <%=u_mt%> �Դϴ�. (��)�Ƹ���ī </textarea> --%>
						<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
                  		<input type="hidden" name="a_url" value="<%=url2%>">
                  		<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
                  		<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
		  			</td>
                </tr>	                
                <%}%>
                <%if (!e_bean3.getEst_id().equals("")) {
						String a_a = "";
						String rent_way = "";
						if(!e_bean3.getA_a().equals("")){
							a_a = e_bean3.getA_a().substring(0,1);
							rent_way = e_bean3.getA_a().substring(1);
						}
						String s_a_a = "";
						String s_rent_way = "";
						
						if (a_a.equals("1")) {
							s_a_a="�����÷���"; 
						} else {
							s_a_a="��ⷻƮ";
						}
						
						if (rent_way.equals("1")) {
							s_rent_way="�Ϲݽ�(��������)";
						} else {
							s_rent_way="�⺻��";
						}
						//�����뿩�ᰡ �ִٸ�
						if (e_bean3.getCtr_s_amt()>0) {
							e_bean3.setFee_s_amt(e_bean3.getCtr_s_amt());
							e_bean3.setFee_v_amt(e_bean3.getCtr_v_amt());
						}						

						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean3.getO_1()));
						fieldList.add(s_a_a);
						fieldList.add(s_rent_way);
						fieldList.add(e_bean3.getA_b());
						fieldList.add(AddUtil.parseDecimal(e_bean3.getGtr_amt()));
						fieldList.add(String.valueOf(e_bean3.getRg_8()));						
						fieldList.add(AddUtil.parseDecimal(e_bean3.getAgree_dist()));
						fieldList.add(AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt()));
						fieldList.add(url3);
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
                %>
                <tr>
                	<td width="10%" class=title><input type="checkbox" name="ch_mms_id" value="<%=e_bean3.getEst_id()%>" checked>���� �˸���3</td>
                  	<td width="90%">&nbsp;
                  		<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">������ ��û�Ͻ� �����ȳ�.  <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean3.getO_1())%>�� <%=c_db.getNameByIdCode("0009", "", e_bean3.getA_a())%><%if(e_bean3.getA_a().equals("11") || e_bean3.getA_a().equals("21")){%>(��������)<%}%> <%=e_bean3.getA_b()%>���� ������<%=e_bean3.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean3.getAgree_dist())%>km/�� <%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt())%>�� VAT���� (������ ���� : <%=url3 %> ) ����ڴ� <%=u_nm%> <%=u_mt%> �Դϴ�. (��)�Ƹ���ī </textarea> --%>
                  		<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
                  		<input type="hidden" name="a_url" value="<%=url3%>">
                  		<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
                  		<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
		  			</td>
                </tr>
                <%}%>
                
                <%if (!e_bean4.getEst_id().equals("")) {
						// String a_a = e_bean4.getA_a().substring(0,1);
						// String rent_way = e_bean4.getA_a().substring(1);
						String s_a_a = "";
						String s_rent_way = "";
						
						String a_a = "";
						String rent_way = "";
						if(!e_bean4.getA_a().equals("")){
							a_a = e_bean4.getA_a().substring(0,1);
							rent_way = e_bean4.getA_a().substring(1);
						}
						
						if (a_a.equals("1")) {
							s_a_a="�����÷���";
						} else {
							s_a_a="��ⷻƮ";
						}
						
						if (rent_way.equals("1")) {
							s_rent_way="�Ϲݽ�(��������)";
						} else {
							s_rent_way="�⺻��";
						}
						//�����뿩�ᰡ �ִٸ�
						if (e_bean4.getCtr_s_amt()>0) {
							e_bean4.setFee_s_amt(e_bean4.getCtr_s_amt());
							e_bean4.setFee_v_amt(e_bean4.getCtr_v_amt());
						}						

						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean4.getO_1()));
						fieldList.add(s_a_a);
						fieldList.add(s_rent_way);
						fieldList.add(e_bean4.getA_b());
						fieldList.add(AddUtil.parseDecimal(e_bean4.getGtr_amt()));
						fieldList.add(String.valueOf(e_bean4.getRg_8()));						
						fieldList.add(AddUtil.parseDecimal(e_bean4.getAgree_dist()));
						fieldList.add(AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt()));
						fieldList.add(url4);
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
                %>
                <tr>
                	<td width="10%" class=title><input type="checkbox" name="ch_mms_id" value="<%=e_bean4.getEst_id()%>" checked>���� �˸���4</td>
                  	<td width="90%">&nbsp;
                  		<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">������ ��û�Ͻ� �����ȳ�.  <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean4.getO_1())%>�� <%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%><%if(e_bean4.getA_a().equals("11") || e_bean4.getA_a().equals("21")){%>(��������)<%}%> <%=e_bean4.getA_b()%>���� ������<%=e_bean4.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>km/�� <%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt())%>�� VAT���� (������ ���� : <%=url4 %> ) ����ڴ� <%=u_nm%> <%=u_mt%> �Դϴ�. (��)�Ƹ���ī </textarea> --%>
                  		<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
                  		<input type="hidden" name="a_url" value="<%=url4%>">
                  		<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
                  		<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
		  			</td>
                </tr>	                
                <%}%>
          <%} else {	//���հ��� short url �߰� (20181002) %>
	          	<%if (!e_bean1.getEst_id().equals("")) { 
	        	  		String s_a_a = "";
						String s_rent_way = "";
						
						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean1.getO_1()));
						fieldList.add(ShortenUrlGoogle.getShortenUrl(url_total));
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0144");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
	          	%>
                <tr>
                	<td width="10%" class=title><input type="checkbox" name="ch_mms_id" value="<%=e_bean1.getEst_id()%>" checked>���� �˸���<br>
                  	<%if (e_bean1.getPrint_type().equals("2")) {%>(��Ʈ)<%}%>
					<%if (e_bean1.getPrint_type().equals("3")) {%>(����)<%}%>
					<%if (e_bean1.getPrint_type().equals("4")) {%>(����)<%}%>
					<%if (e_bean1.getPrint_type().equals("5")) {%>(������ ����)<%}%>
                  	</td>
                  	<td width="90%">&nbsp;
                  		<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">������ ��û�Ͻ� �����ȳ�.  <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean1.getO_1())%>�� (������ ���� : <%=ShortenUrlGoogle.getShortenUrl(url_total) %> ) ����ڴ� <%=u_nm%> <%=u_mt%> �Դϴ�. (��)�Ƹ���ī </textarea> --%>
                  		<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
                  		<input type="hidden" name="a_url" value="<%=ShortenUrlGoogle.getShortenUrl(url_total)%>">
                  		<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
                  		<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
					</td>
               	</tr>	                
               	<%}%>
       		<%} %>
            </table>
        </td>
    </tr>	
    <tr>
    	<td></td>
        <td align="right"><a href="javascript:select_esti_result_sms();" title='���ں�����'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a></td>
    </tr>  
    <%}%>	
</form>
</table>
<script>
<%//if (e_bean1.getCls_per() > 100 || e_bean2.getCls_per() > 100 || e_bean3.getCls_per() > 100 || e_bean4.getCls_per() > 100) {%>
//alert("��������� 100%�� �ʰ��Ͽ����ϴ�. ��������� 100% �̳��� �ǵ��� ���� �������� �ٿ��ּ���.");
<%//}%>
</script>
<script>
<!--
	<%if(from_page.equals("/acar/estimate_mng/esti_mng_atype_proc.jsp")){%>
//	EstiView('<%=e_bean1.getEst_id()%>');
	<%}%>
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
