<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*, acar.secondhand.*, acar.car_mst.*, acar.car_register.*, acar.cont.*, acar.client.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiMBean" scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="bc_db" class="acar.bad_cust.BadCustDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String chk 			= request.getParameter("chk")==null?"":request.getParameter("chk");  				//�����Է� ����
	String bb_chk 	= request.getParameter("bb_chk")==null?"":request.getParameter("bb_chk");  	//������ ����
	String t_chk		= request.getParameter("t_chk")==null?"":request.getParameter("t_chk");  		//���� ��ȭ
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");  	
	String car_mng_id		= "";
	String rent_mng_id	= "";
	String rent_l_cd		= "";
	String reg_code = "";
	// ��Ϻ��� Ŭ���� ���ܰ� �˻����� ������ ���� �߰�
	String period_gubun = request.getParameter("period_gubun")==null?"":request.getParameter("period_gubun");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String branch = request.getParameter("branch")==null?"":request.getParameter("branch");		//�������� �˻��߰�
	
	if (!bb_chk.equals("") &&  !t_chk.equals("") ) {
		bb_chk = "";
	}
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();

	u_bean = umd.getUsersBean(user_id);

	//����Ʈ���� ��û
	e_bean = e_db.getEstiSpeCase(est_id);
	
	//�������
	EstimateBean [] e_r = e_db.getEstiSpeCarList(est_id);
	int size = e_r.length;
	
	for(int i=0; i<size; i++){
    EstimateBean car_bean = e_r[i];
		if(!car_bean.getCar_mng_id().equals("")){
			car_mng_id = car_bean.getCar_mng_id();
		}
	}
	
	//��ȭ����
	EstiMBean em_r [] = e_db.getEstiMAll(est_id, user_id);
	
	//Ȩ������-�ǽð����� : ����,�縮��
	EstimateBean e_bean2 = e_db.getEstimateCuCase(est_id);
	
	//��������
	ShResBean shBn = shDb.getShResEst(est_id);
	
	//����������� - �縮��
	if(!e_bean2.getMgr_nm().equals("")){
		cr_bean = crd.getCarRegBean(e_bean2.getMgr_nm());
		car_mng_id = e_bean2.getMgr_nm();
	}

	String rmcont_yn = "";
		
	//Ȩ������-�������࿡�� ����Ʈ���� ã��
	EstimateBean e_bean3 = new EstimateBean();
	if(!shBn.getCar_mng_id().equals("") && !shBn.getReg_code().equals("")){
		e_bean3 = e_db.getEstimateCuRmCase(shBn.getCar_mng_id(), shBn.getReg_code());
		rmcont_yn = shDb.getRmContYn(shBn.getEst_id());
		car_mng_id = shBn.getCar_mng_id();
		reg_code = shBn.getEst_id();
	}
	
	//����������� - ����Ʈ
	if(!e_bean3.getMgr_nm().equals("")){
		cr_bean = crd.getCarRegBean(e_bean3.getMgr_nm());
		car_mng_id = e_bean3.getMgr_nm();
	}	

	//����������	
 	Vector driverInfo = shDb.getMonthRentDriverInfo(est_id);
 	
	String bc_lic_no = "";
	String driver_cell = "";
  	if(driverInfo.size() > 0){
  		for(int i=0; i<driverInfo.size(); i++){ 
			Hashtable driver = (Hashtable)driverInfo.elementAt(i);
			if(bc_lic_no.equals("")){
				bc_lic_no = String.valueOf(driver.get("DRIVER_NUM"));
			}
			if(driver_cell.equals("")){
				driver_cell = String.valueOf(driver.get("DRIVER_CELL"));
			}
		}
	}
	//�̳��ݾ� Ȯ��
	String client_id = "";	
	
	if(!car_mng_id.equals("")){
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 		= String.valueOf(cont.get("RENT_L_CD"));		
	}
	
	Hashtable ycont = a_db.getContViewUseYCarCase(car_mng_id);	
	
	//��������
	Hashtable reserv = rs_db.getResCarCase(car_mng_id, "2");
	String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	
	if(use_st.equals("null")){
		reserv = rs_db.getResCarCase(car_mng_id, "1");
		use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	}
	
	//������ ����
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;
	
	//��������	
	Hashtable ht_car = shDb.getShBase(car_mng_id);
	String park = String.valueOf(ht_car.get("PARK"));
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script>
$(document).ready(function(){
	//����� ���� ������ ����� ����϶�� �޼��� �ȳ����� ó��
	if($('#regBtn').length > 0){
		$('#damdangInfo').show();
	}
})
</script>
<script language="JavaScript">
	function tell_save(gubun){
		var fm = document.form1;
		if(fm.est_id.value == ''){ 	alert('est_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.user_id.value == ''){ alert('user_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(gubun=='00')	{
			fm.note.value = "��ȭ��";
			fm.gubun.value = "0";
		} else if(gubun=='01')	{
			fm.note.value = "������";
			fm.gubun.value = "1";
		} else if(gubun=='02')  {
			fm.note.value = "���(�߸��ȹ�ȣ)";
			fm.gubun.value = "2";
		} else if(gubun=='19')  {
			fm.note.value = "������ ���ڹ߼�";
			fm.gubun.value = "1";
		}
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
		
		fm.action = "esti_memo_null_ui.jsp";
		fm.target = "i_no";
		fm.submit();
		
		link.getAttribute('href',originFunc);
	}
	
	function save(){
		var fm = document.form1;
		if(fm.est_id.value == ''){ 	alert('est_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.user_id.value == ''){ alert('user_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.note.value == ''){ 	alert('��ȭ������ �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(!confirm('����Ͻðڽ��ϱ�?')){	return; }					
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
		
		fm.action = "esti_memo_null_ui.jsp";
		fm.target = "i_no";
		fm.submit();
		
		link.getAttribute('href',originFunc);
	}
	
	function change(arg){
		var fm = document.form1;
	
		if(arg=='03')			fm.note.value = "���׳�";
		else if(arg=='04')	fm.note.value = "����� ��Ȯ��";
		else if(arg=='05')	fm.note.value = "�������";
		else if(arg=='06')	fm.note.value = "������ü";
		else if(arg=='07')	fm.note.value = "�ܱ�뿩";
		else if(arg=='08')	fm.note.value = "�񱳰�����";
		else if(arg=='09')	fm.note.value = "����������ȸ";
		else if(arg=='10')	fm.note.value = "�����ü���������";
		else if(arg=='11')	fm.note.value = "Ÿ�緻Ʈ(����)�� �����";
		else if(arg=='12')	fm.note.value = "�Һα�����";
		else if(arg=='13')	fm.note.value = "��Ⱓ����";
		else if(arg=='14')	fm.note.value = "�̸�������";
		else if(arg=='15')	fm.note.value = "��������";
		else if(arg=='16')	fm.note.value = "���ü��";
		else if(arg=='17')	fm.note.value = "������";
		else if(arg=='18')	fm.note.value = "��Ÿ";
		else if(arg=='19')	fm.note.value = "�����߹��ڹ߼�";
	}
	
	function EstiATypeReg(st, car_mng_id, seq){
		var fm = document.form1;		
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return; }
		fm.spe_seq.value = seq;
		fm.target = "d_content";
		if(car_mng_id == ''){
			fm.st.value = st;
			fm.est_table.value = 'esti_spe';
			fm.action = "esti_mng_atype_i.jsp";
			if(st == '2'){
				fm.target = "i_no";
			} 
		}else{
			fm.st.value = '';
			fm.car_mng_id.value = car_mng_id;
			fm.est_table.value = 'esti_spe';
			fm.action = "/acar/secondhand/secondhand_detail_frame.jsp";
		}
		fm.submit();
	}
	function EstiATypeRegSpe(spe_car_nm){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return; }
		fm.spe_car_nm.value = spe_car_nm;
		fm.target = "d_content";
		fm.est_table.value = 'esti_spe';
		fm.action = "esti_mng_atype_i.jsp";
		fm.submit();
	}
	
	//���ڳ��� �߼��ϱ�
	function msg_send(){ 
		fm = document.form1;
		if(!confirm("[<%if(!e_bean.getEst_agnt().equals("")){%><%=e_bean.getEst_agnt()%><%} else {%><%=e_bean.getEst_nm()%><%}%> ���Բ��� ��û�Ͻ� ���� ����� ���� ��ȭ������� ������ ���� �ʾ� ���� ����ϴ�. ������ ����� �����ϴ� ��ȭ �����Ͻ� �� �����ּ���.] ������ ���� ���ڳ����� �߼��Ͻðڽ��ϱ�?"))	return;
		fm.target = "i_no";
		fm.action = "send_case.jsp";
		fm.submit();		
		tell_save("19");
	}

	//��Ϻ���
	function go_list(){
		var prevLink = document.getElementById("prev_page").value;
		var fm = document.form1;
		if(prevLink != "" && prevLink != null){
			fm.action = prevLink;
		}else{
			fm.action = '/acar/estimate_mng/esti_spe_hp_grid_big_frame.jsp';
		}
		fm.target = 'd_content';
		fm.submit(); 
		
		/* var period_gubun = $("#period_gubun").val();
		var gubun4 = $("#gubun4").val();
		var s_dt = $("#s_dt").val();
		var e_dt = $("#e_dt").val();
		var esti_m = $("#esti_m").val();
		var branch = $("#branch").val(); */
	}
	
	//����������
	function EstiView(est_st, est_id, spe_est_id){
		var SUBWIN="";
		if(est_st=='����Ʈ')	SUBWIN="/acar/secondhand_hp/estimate_rm_new.jsp?est_id="+est_id+"&spe_est_id="+spe_est_id+"&acar_id=<%=ck_acar_id%>&from_page=";
		if(est_st=='�縮��')	SUBWIN="/acar/secondhand_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms";
		if(est_st=='����')		SUBWIN="/acar/main_car_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");				
	}
	
	function ReEsti(est_st, est_id, car_mng_id, spe_est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.car_mng_id.value = car_mng_id;
		fm.cmd.value = 're';
		fm.est_table.value = 'esti_spe';
		if(est_st=='����Ʈ'){
			fm.est_id.value = spe_est_id;
		}
		if(est_st=='����Ʈ')	fm.action = '/acar/secondhand/secondhand_detail_frame.jsp';
		if(est_st=='�縮��')	fm.action = '/acar/secondhand/secondhand_detail_frame.jsp';
		if(est_st=='����')	fm.action = 'esti_mng_atype_i.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//������ �������񱳰���
	function ReEsti6(est_st, est_id, car_mng_id, spe_est_id, set_code, eh_code){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.set_code.value = set_code;
		fm.eh_code.value = eh_code;
		fm.car_mng_id.value = car_mng_id;
		fm.cmd.value = 're';
		fm.spe_cmd.value = 're_6';
		fm.est_table.value = 'esti_spe';
		if(est_st=='����Ʈ'){
			fm.est_id.value = spe_est_id;
		}
		if(est_st=='����Ʈ')	fm.action = '/acar/secondhand/secondhand_detail_frame.jsp';
		if(est_st=='�縮��')	fm.action = '/acar/secondhand/secondhand_detail_frame.jsp';
		if(est_st=='����')	fm.action = 'esti_mng_atype_i.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
	
	//�����̷�	
	function view_sh_res_h(){
		var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id=<%=shBn.getCar_mng_id()%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}	
	
	//���Ȯ������ ��ȯ�ϱ�
	function reserveCar2Cng(car_mng_id, seq, situation, damdang_id, shres_reg_dt, shres_cust_nm, shres_cust_tel){
		var fm = document.form1;
		
		var sms_msg = fm.sms_msg.options[fm.sms_msg.selectedIndex].value;
		var sms_msg2 = fm.sms_msg2.options[fm.sms_msg2.selectedIndex].value;
		
		if(damdang_id == ""){
			alert("����ڵ���� ���� �ϼ���");
			return;
		}
				
		//if(sms_msg == ""){
		//	alert("�غ��� �������ּ���");
		//	fm.sms_msg.focus();
		//	return;
		//}
		
		//if(sms_msg2 == ""){
		//	alert("�������� �������ּ���");
		//	fm.sms_msg2.focus();
		//	return;
		//}
		
		fm.car_mng_id.value = car_mng_id;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		fm.shres_cust_nm.value = shres_cust_nm;
		fm.shres_cust_tel.value = shres_cust_tel;
		if(!confirm("����߿��� ���Ȯ������ ��ȯ �Ͻðڽ��ϱ�?"))	return;
		fm.action = "/acar/secondhand/reserveCar2cng.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	//��������ϱ�
	function cancelCar(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.car_mng_id.value = car_mng_id;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("������ ��� �Ͻðڽ��ϱ�?"))	return;
		fm.action = "/acar/secondhand/cancelCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}	
	//����Ʈ��� �����ϱ�
	function RmContReg(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		
		var sms_msg = fm.sms_msg.options[fm.sms_msg.selectedIndex].value;
		var sms_msg2 = fm.sms_msg2.options[fm.sms_msg2.selectedIndex].value;
		
		if(damdang_id == ""){
			alert("����ڵ���� ���� �ϼ���");
			return;
		}
				
		if(sms_msg == ""){
			alert("�غ��� �������ּ���");
			fm.sms_msg.focus();
			return;
		}
		
		if(sms_msg2 == ""){
			alert("�������� �������ּ���");
			fm.sms_msg2.focus();
			return;
		}
				
		fm.car_mng_id.value = car_mng_id;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		
		//��ü�ݾ��� �ִ��� Ȯ���Ѵ�.
		//if(fm.client_id.value != '' && fm.badamt_chk.value == ''){
			//alert('<%=e_bean.getEst_nm()%> ���� ��ü�ݾ��� ���� [Ȯ��] �Ͻʽÿ�.');
			//return;
		//}
				
		if(!confirm("����Ʈ��� ����Ͻðڽ��ϱ�?"))	return;
		fm.action = "/acar/secondhand/rmcontReg.jsp";
		fm.target = "i_no";
		fm.submit();
	}		
	
	function registerDamdang(estId){
		if(confirm("����ڷ� ����Ͻðڽ��ϱ�?")){
			var id = '<%=ck_acar_id%>';
			$.ajax({
				url:'/acar/estimate_mng/reg_damdang.jsp?id='+id+"&estId="+estId,
				contentType:"application/json",
				type:'POST',
				success:function(response){
					location.reload();
				},
				error:function(response,status,error){
					alert(response);
				}
			});
		}
	}
	
	//��ĵ���
	function scan_reg(content_code, content_seq, file_st_nm){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&content_code="+content_code+"&content_seq="+content_seq+"&file_st_nm="+file_st_nm, "SCAN", "left=10, top=10, width=720, height=200, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//������ ���� Ȩ���������� ������ ���� Ȩ������ ������ ������ ȣ��
	function smartEstView(est_id){
		var url = "https://www.amazoncar.co.kr/smart/print?estimateId=" + est_id;
   		window.open(url,"printPopup","width=1010,height=800,top=0,left=100,scrollbars=yes");	
	}
	
	//�ŷ�ó ��ü�ݾ�
	function view_dlyamt(client_id)
	{
		window.open('/acar/account/stat_settle_sc_in_view_sub_list_client.jsp?badamt_chk_from=esti_spe_hp_i.jsp&client_id='+client_id, "CLIENT_DLVAMT", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//�ҷ��� 
	function view_badcust(est_nm, lic_no, est_tel, est_o_tel, est_mail, est_fax, est_comp_tel, est_comp_cel, driver_cell)
	{
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_spe_hp_i.jsp&est_nm='+est_nm+'&lic_no='+lic_no+'&est_tel='+est_tel+'&est_o_tel='+est_o_tel+'&est_mail='+est_mail+'&est_fax='+est_fax+'&est_comp_tel='+est_comp_tel+'&est_comp_cel='+est_comp_cel+'&driver_cell='+driver_cell, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//�� ��ȸ
	function search_client(){window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&t_wd=<%=e_bean.getEst_nm()%>&from_page=/acar/estimate_mng/esti_spe_hp_i.jsp","CLIENT","left=10,top=10,width=1100,height=600,scrollbars=yes,status=yes,resizable=yes");}
	
	//������Ȳ ���γ��� ��ȸ
	function view_rentcont(use_st, rent_s_cd){
		var SUBWIN="/acar/res_stat/res_rent_u.jsp?mode=view&c_id=<%=car_mng_id%>&s_cd="+rent_s_cd;
		if(use_st == '����'){
			SUBWIN="/acar/rent_mng/res_rent_u.jsp?mode=view&c_id=<%=car_mng_id%>&s_cd="+rent_s_cd;
		}
		window.open(SUBWIN, "view_rentcont", "left=5, top=50, width=1000, height=650, scrollbars=yes, status=yes");
	}
	
//-->
</script>
</head>
<body leftmargin="15">
<input type="hidden" name="prev_page" id="prev_page" value="<%=from_page%>"/>
<form action="./esti_memo_null_ui.jsp" name="form1" method="POST" >
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="gubun1" value="<%=gubun1%>">
	<input type="hidden" name="gubun2" value="<%=gubun2%>">
	<input type="hidden" name="gubun3" value="<%=gubun3%>">
	<input type="hidden" name="gubun4" id="gubun4" value="<%=gubun4%>">
	<input type="hidden" name="s_dt" id="s_dt" value="<%=s_dt%>">
	<input type="hidden" name="e_dt" id="e_dt" value="<%=e_dt%>">
	<input type="hidden" name="est_id" value="<%=est_id%>">
	<input type="hidden" name="set_code" value="">
	<input type="hidden" name="eh_code" value="">
	<input type="hidden" name="cmd" value="">
	<input type="hidden" name="spe_cmd" value="">
	<input type="hidden" name="gubun" value="">
	<input type="hidden" name="spe_seq" value="">
	<input type="hidden" name="est_table" value="">
	<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
	<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
	<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
	<input type="hidden" name="reg_code" value="<%=reg_code%>">
	<input type="hidden" name="st" value="">
	<input type="hidden" name="sendname" value="<%=u_bean.getUser_nm()%>">
	<input type="hidden" name="sendphone" value="<%=u_bean.getUser_m_tel()%>">
	<input type="hidden" name="user_pos" value="<%=u_bean.getUser_pos()%>">
	<input type="hidden" name="destphone" value="<%=e_bean.getEst_tel()%>">
	<input type="hidden" name="destname" value=<%if(!e_bean.getEst_agnt().equals("")){%>"<%=e_bean.getEst_agnt()%>"<%} else {%>"<%=e_bean.getEst_nm()%>"<%}%>>
	<input type="hidden" name="msg_type" value="5">
	<input type="hidden" name="msgs" value="">
	<input type="hidden" name="spe_car_nm" value=""> 
	<input type="hidden" name="spe_est_id" value="">
	<input type="hidden" name="from_page" value="/acar/estimate_mng/esti_spe_hp_i.jsp">
	<input type="hidden" name="shres_seq" value="">
	<input type="hidden" name="situation" value="">
	<input type="hidden" name="damdang_id" value="">
	<input type="hidden" name="shres_reg_dt" value="">
	<input type="hidden" name="shres_cust_nm" value="">
	<input type="hidden" name="shres_cust_tel" value="">
	<!-- ��Ϻ��� Ŭ���� ���ܰ� �˻����� ������ ���� �߰� -->
	<input type="hidden" name="period_gubun" id="period_gubun" value="<%=period_gubun%>">
	<input type="hidden" name="esti_m" id="esti_m" value="<%=esti_m%>">
	<input type="hidden" name="branch" id="branch" value="<%=branch%>"> <!-- �������� �˻� �߰� -->
	
	<input type='hidden' name='badamt_chk_from' value='esti_spe_hp_i.jsp'>
	<input type='hidden' name='badamt_chk' value=''> 
	<input type='hidden' name='badcust_chk_from' value='esti_spe_hp_i.jsp'>
	<input type='hidden' name='badcust_chk' value=''>   
	<input type="hidden" name="sh_req" value="">
  
   
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>
    <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
          <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����Ʈ�������� > <span class=style5>������û ���� </span></span></td>
          <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="right"><a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
  </tr>
  <tr>
    <td class=line2></td>
  </tr>
	<tr>
    <td class="line">
 	    <table border="0" cellpadding=0 cellspacing="1" width=100%>
        <tr>
          <td class=title width=10%>����/���θ�</td>
          <td width=15%>&nbsp;<%=e_bean.getEst_nm()%>
          	<%if(e_bean.getClient_yn().equals("Y")){%>
          	<br>&nbsp; - ������ 
          	<%  //�� Ȯ��
				Vector vt_chk2 = al_db.getClientRentCheck(e_bean.getEst_nm(), e_bean.getEst_nm(), "", bc_lic_no, e_bean.getEst_tel(), e_bean.getUrgen_tel(), "", e_bean.getEst_email(), e_bean.getEst_fax());
				int vt_chk2_size = vt_chk2.size();
				if(vt_chk2_size==1){
					Hashtable ht_cust = (Hashtable)vt_chk2.elementAt(0);
					client_id = String.valueOf(ht_cust.get("CLIENT_ID"));
			%>
						<input type="button" class="button" id="bad_amt" value='ä�Ǻ���' onclick="javascript:view_dlyamt('<%=ht_cust.get("CLIENT_ID")%>');">
						<%	Vector conts = l_db.getContList(client_id);
							int cont_size = conts.size(); 							
							if(cont_size > 0){
								for(int i = 0 ; i < 1 ; i++){
									Hashtable cont = (Hashtable)conts.elementAt(i);%>
									<br>&nbsp; (�ֱ� ��������� : <%=cont.get("USER_NM2")%>)
						<%		}
							}	
						%>			
          	<%	}%>
          	<%	if(vt_chk2_size>1){%> : ���������� 1�� �̻��Դϴ�.
          	<span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
          	<% 		Hashtable ht_cust = (Hashtable)vt_chk2.elementAt(0);
					client_id = String.valueOf(ht_cust.get("CLIENT_ID"));
					Vector conts = l_db.getContList(client_id);
					int cont_size = conts.size(); 							
					if(cont_size > 0){
						for(int i = 0 ; i < 1 ; i++){
							Hashtable cont = (Hashtable)conts.elementAt(i);
			%>
									<br>&nbsp; (�ֱ� ��������� : <%=cont.get("USER_NM2")%>)
						<%		}
							}	
						%>			
					
          	<%	}%>
          	<%}%> 
          	<%	//�ҷ��� Ȯ��
								//Vector vt_chk1 = bc_db.getBadCustRentCheck(e_bean.getEst_nm(), e_bean.getEst_nm(), "", bc_lic_no, e_bean.getEst_tel(), e_bean.getUrgen_tel(), e_bean.getEst_comp_tel(), e_bean.getEst_email(), e_bean.getEst_fax(), e_bean.getEst_comp_cel(), driver_cell);
								//int vt_chk1_size = vt_chk1.size();
								//if(vt_chk1_size>0){
						%> 
						      <!--  <br>&nbsp; - �ҷ��� 
						      <input type="button" class="button" id="bad_cust" value='���뺸��' onclick="javascript:view_badcust('<%=e_bean.getEst_nm()%>', '<%=bc_lic_no%>', '<%=e_bean.getEst_tel()%>', '<%=e_bean.getUrgen_tel()%>', '<%=e_bean.getEst_email()%>', '<%=e_bean.getEst_fax()%>', '<%=e_bean.getEst_comp_tel()%>', '<%=e_bean.getEst_comp_cel()%>', '<%=driver_cell%>');">
						      -->
						      
						<%	//}%>          	  
          	<input type='hidden' name='client_id' value='<%=client_id%>'>   
          </td>
          <td width=10% class=title>�������<br>/����ڹ�ȣ</td>
          <td width=15%>&nbsp;<%=e_bean.getEst_ssn()%><span id="koreanAge" style="color:red;"></span></td>
          <td width=10% class=title>�����</td>
          <td width=15%>&nbsp;<%=e_bean.getEst_agnt()%></td>
          <td width=10% class=title>��ȭ��ȣ</td>
          <td width=15%>&nbsp;<%=AddUtil.phoneFormat(e_bean.getEst_tel())%></td>
        </tr>
        <tr>
          <td class=title>������ȣ</td>
          <td>&nbsp;<%=AddUtil.phoneFormat(e_bean.getUrgen_tel())%></td>
          <td class=title>�ѽ���ȣ</td>
          <td>&nbsp;<%=AddUtil.phoneFormat(e_bean.getEst_fax())%></td>
          <td class=title>����</td>
          <td align="left">&nbsp;<%=e_bean.getEst_bus()%></td>
          <td class=title>����/�������</td>
          <td>&nbsp;<%=e_bean.getEst_year()%><%=e_bean.getDriver_year()%></td>
        </tr>      
        <tr>
          <td class=title>ȸ�翬��ó</td>
          <td>&nbsp;<%=AddUtil.phoneFormat(e_bean.getEst_comp_tel())%></td>
          <td class=title>��ǥ�ڸ�</td>
          <td>&nbsp;<%=e_bean.getEst_comp_ceo()%></td>
          <td class=title>��ǥ�ڿ���ó</td>
          <td align="left" colspan='3'>&nbsp;<%=AddUtil.phoneFormat(e_bean.getEst_comp_cel())%></td>
        </tr>               
		<tr>
          <td class=title>�̸���</td>
          <td align="left">&nbsp;<%=e_bean.getEst_email()%></td>
          <td class=title>          
		  <%if (e_bean.getEst_st().equals("PE9") || e_bean.getEst_st().equals("PH9") || e_bean.getEst_st().equals("ME9") || e_bean.getEst_st().equals("MH9")) {%>
		  	���ּ���
		  <%}else{%>
		     ����
		  <%}%>
		  </td>
          <td>
          <%if (!e_bean.getEst_st().equals("ARS")) {%>
          &nbsp;<%=e_bean.getEst_area()%>
		  <%}%>
          </td>
          <td class=title>�ǰ������ּ�</td>
          <td align="left" colspan="3">&nbsp;<%=e_bean.getZipcode()%>&nbsp;<%=e_bean.getAddr1()%>&nbsp;<%=e_bean.getAddr2()%></td>
        </tr>
		<tr>
          <td class=title>���¹�ȣ</td>
          <td align="left" colspan="3">&nbsp;<%=e_bean.getBank()%>&nbsp;<%=e_bean.getAccount()%></td>
          <td class=title>�����̿��� �ּ�</td>
          <td align="left" colspan="3">&nbsp;<%=e_bean.getCar_use_addr1()%>&nbsp;<%=e_bean.getCar_use_addr2()%></td>
        </tr>
        <tr>
          <td class=title>��Ÿ��û����</td>
          <td colspan="7">&nbsp;<%=e_bean.getEtc()%></td>
        </tr>    
        <% if(!shBn.getCar_mng_id().equals("")){ 
               Vector docList = c_db.getAcarAttachFileList("ESTI_SPE",est_id,-1);
        %>
        <tr>
          <td class="title">÷�μ���</td>
          <td colspan="7">
          	<ul>
          		<%
          			String file_st[]	 = new String[4];
								file_st[0] = "001";
								file_st[1] = "002";
								file_st[2] = "003";
								file_st[3] = "004";
          			String file_nm[]	 = new String[4];
								file_nm[0] = "�����������纻";
								file_nm[1] = "�ڵ���ü���»纻";
								file_nm[2] = "����ڵ�����纻";
								file_nm[3] = "�߰� ������ ���������� �纻";
          		%>
          		<%for(int j=0; j<4; j++){
          				String file_yn = "";
          		%>
          		<%	for(int i=0; i<docList.size(); i++){
          					//001 : ����纻 , 002-003 : ����ڵ���� �纻
          					Hashtable doc = (Hashtable)docList.elementAt(i);
          		    	String file_title = (String)doc.get("CONTENT_SEQ");
          		    	if(file_title.split("-")[1].equals(file_st[j])){
          						file_yn = "Y";
          		%>
          			<li><%=file_nm[j]%> : <a href="javascript:openPopP('<%=doc.get("FILE_TYPE")%>','<%=doc.get("SEQ")%>');" title='����' ><%=doc.get("FILE_NAME")%></a>
          			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          			    <a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=doc.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
          			</li>          				
          		<%		}%>
          		<%	}
          				if(file_yn.equals("")){%>
          			<li> <%=file_nm[j]%> : &nbsp;<a href="javascript:scan_reg('ESTI_SPE','<%=est_id%>-<%=file_st[j]%>','<%=file_nm[j]%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></li>	
          		<%	}%>
          		<%}%>
          	</ul>
          </td>
        </tr>
        <% } %>
      </table>
    </td>
  </tr>
    <tr> 
        <td><font color=red>�� �ҷ��� Ȯ���ϱ�</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='��Ȯ��' onclick="javascript:view_badcust('<%=e_bean.getEst_nm()%>', '<%=bc_lic_no%>', '<%=e_bean.getEst_tel()%>', '<%=e_bean.getUrgen_tel()%>', '<%=e_bean.getEst_email()%>', '<%=e_bean.getEst_fax()%>', '<%=e_bean.getEst_comp_tel()%>', '<%=e_bean.getEst_comp_cel()%>', '<%=driver_cell%>');">        	        	        	
        </td>
    </tr>
    <tr>  
  <%
    if(driverInfo.size() > 0){
  %>
  <tr>
	 <td class="h"></td>
  </tr>
  <tr>
	 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ����</span></td>
  </tr>
  <tr>
	  <td class="line">
	 	<table border="0" cellpadding=0 cellspacing="1" width=100%>
	        <tr>
	          <td class=title width=10%>�����ڸ�</td>
	          <td width=10% class=title>���������ȣ</td>
	          <td width=10% class=title>������ ����ó</td>
	          <td width=10% class=title>���</td>
	          <td width=10% class=title>�������⵵</td>
	        </tr>
	        <%  for(int i=0; i<driverInfo.size(); i++){ 
	        		Hashtable driver = (Hashtable)driverInfo.elementAt(i);
	        		//�������⵵ �߰�
	        		String get_d_num_year = ((String)driver.get("DRIVER_NUM")).replace("-","").substring(2,4);
	        		if(AddUtil.parseInt(get_d_num_year) >= 40)  	{	get_d_num_year = "19"+(String)get_d_num_year;	}
	        		else if(AddUtil.parseInt(get_d_num_year) < 40)	{	get_d_num_year = "20"+(String)get_d_num_year;	}
	        %>
	        <tr>
	        	<td align="center"><%if(driver.get("DRIVER_NM").equals("") && i == 0){%><%=e_bean.getEst_nm()%><%}else{%><%=driver.get("DRIVER_NM")%><%}%></td>
	        	<td align="center"><%=driver.get("DRIVER_NUM")%></td>
	        	<td align="center"><%if(driver.get("DRIVER_CELL").equals("") && i == 0){%><%=e_bean.getEst_tel()%><%}else{%><%=driver.get("DRIVER_CELL")%><%}%></td>
	        	<td align="center"><%if(i == 0){%>����� ����<%}else{%>�߰� ������<%} %></td>
	        	<td align="center"><%=get_d_num_year%> ��</td> <!-- �������⵵ �߰� -->
	        </tr>
	        <%  } %>
	     </table>
	 </td>
  </tr>
  <%} %>
  <%if(e_bean2.getEst_id().equals("") && e_bean3.getEst_id().equals("")){%>
  <tr>
    <td class=h></td>
  </tr>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>  
  <tr>
    <td class=line2></td>
  </tr>  
	<tr>
		<td class="line">
			<table border="0" cellpadding=0 cellspacing="1" width=100%>
				<%if(size>0){%>
        <tr>
          <td class=title width=3%>����</td>
          <td class=title width=7%>����</td>
          <td class=title width=25%>����</td>
          <td class=title width=25%>�ɼ�</td>
          <td class=title width=10%>����</td>
          <td class=title width=10%>�뿩��ǰ</td>
          <td class=title width=10%>�뿩�Ⱓ</td>
          <td class=title width=10%>��������Ÿ�</td>
        </tr>
				<%	for(int i=0; i<size; i++){
    					EstimateBean car_bean = e_r[i];
							int a_a_len = car_bean.getA_a().length();
							String a_a[]	= new String[4];
							for(int j=0; j<4; j++){
								a_a[j] = "";
							}
							for(int j=0; j<a_a_len/2; j++){
								a_a[j] = car_bean.getA_a().substring(j*2,(j+1)*2);
							}
							if(!car_bean.getCar_mng_id().equals("")){
								//��������
								Hashtable ht = shDb.getShBase(car_bean.getCar_mng_id());
								car_bean.setEst_ssn	(c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")), "CAR_COM"));
								car_bean.setCar_nm	(String.valueOf(ht.get("CAR_NAME")));
								car_bean.setOpt			(String.valueOf(ht.get("OPT")));
								car_bean.setCol			(String.valueOf(ht.get("COL")));
							}
				%>
        <tr>
          <td align=center rowspan='2'><%=i+1%></td>
          <td align=center rowspan='2'>
									<%if(car_bean.getCar_mng_id().equals("")){%>
									[����]
									<%}else{%>
									<%	if(car_bean.getA_b().equals("1")){%>[����Ʈ]<%}else{%>[�縮��]<%}%> <%=car_bean.getEst_nm()%>
									<%}%>
					</td>
					<td align=center rowspan='2'><%=car_bean.getEst_ssn()%> <%=car_bean.getCar_nm()%> <%=car_bean.getCar_name()%></td>
					<td align=center><%=car_bean.getOpt()%></td>
					<td align=center><%=car_bean.getCol()%> <%=car_bean.getIn_col()%></td>
					<td align=center>
									<%for(int j=0; j<4; j++){%>
									<%	if(a_a[j].equals("11")){%>����<br>�Ϲݽ�<%}%>
									<%	if(a_a[j].equals("12")){%>����<br>�⺻��<%}%>
									<%	if(a_a[j].equals("21")){%>��Ʈ<br>�Ϲݽ�<%}%>
									<%	if(a_a[j].equals("22")){%>��Ʈ<br>�⺻��<%}%>
									<%}%>
					</td>
					<td align=center><%=car_bean.getA_b()%>����</td>
					<td align=center><%=car_bean.getAgree_dist()%>km</td>
				</tr>
				<tr>
				  <td align=center colspan='5'>
									<%if(car_bean.getCar_mng_id().equals("")){//����%>
									
									<%	if(!a_a[0].equals("") && !car_bean.getCar_id().equals("") && !car_bean.getCar_seq().equals("")){%>
									<a href="javascript:EstiATypeReg('2','<%=car_bean.getCar_mng_id()%>','<%=car_bean.getSeq()%>')"><img src=/acar/images/center/button_est_gb.gif align="absmiddle" border="0" alt="�⺻����"></a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<%	}%>
									
									<a href="javascript:EstiATypeReg('3','<%=car_bean.getCar_mng_id()%>','<%=car_bean.getSeq()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="��������"></a>
									
									<%	if(car_bean.getCar_id().equals("") && car_bean.getCar_seq().equals("")){%>
									        <br>* �������� ������ ���� �ʾҽ��ϴ�. ������������ ���� �� ���� ���� ���߾� �����ϼ���.
									<%	}%>
									
									<%}else{//�縮��,����Ʈ%>
									
									<a href="javascript:EstiATypeReg('3','<%=car_bean.getCar_mng_id()%>','<%=car_bean.getSeq()%>')"><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a>
									
									<%}%>
				  </td>
				</tr>
				<%	}%>
				<%}else{%>
				<%		if(!e_bean.getCar_nm().equals("")){%>
        <tr>
          <td width=10% class=title>�������<%if(!e_bean.getCar_nm2().equals("")){%>1<%}%></td>
          <td>&nbsp;
	          	<%if (e_bean.getEst_st().equals("PE9") || e_bean.getEst_st().equals("PH9") || e_bean.getEst_st().equals("ME9") || e_bean.getEst_st().equals("MH9")) {%>
					<font style="color:red;">��������</font> - <%=e_bean.getCar_nm()%>
				<%}else{%>
				<%=e_bean.getCar_nm()%>
				&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="javascript:EstiATypeRegSpe('<%=e_bean.getCar_nm()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="��������"></a>
				<%}%>
       			<%-- &nbsp;<%=e_bean.getCar_nm()%> --%>
									<%-- &nbsp;&nbsp;&nbsp;&nbsp;
                  <a href="javascript:EstiATypeRegSpe('<%=e_bean.getCar_nm()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="��������"></a> --%>          	
          </td>
        </tr>
			<%} else {%>
				
				<%if (e_bean.getEst_st().equals("PC4") || e_bean.getEst_st().equals("MO4") || e_bean.getEst_st().equals("ARS")) {%>
		<tr>
          <td width=10% class=title>�������</td>
          <td>&nbsp;<!-- <font style="color:blue;">��������</font> -  --><%=e_bean.getEtc()%>
          </td>
        </tr>
        		<%}%>      
        		  
			<%}%>
				
				<%		if(!e_bean.getCar_nm2().equals("")){%>
        <tr>
          <td class=title>�������2</td>
          <td>&nbsp;<%=e_bean.getCar_nm2()%>
									&nbsp;&nbsp;&nbsp;&nbsp;
                  <a href="javascript:EstiATypeRegSpe('<%=e_bean.getCar_nm2()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="��������"></a>          	
          	</td>
        </tr>
				<%		}%>
				<%		if(!e_bean.getCar_nm3().equals("")){%>
        <tr>
          <td class=title>�������3</td>
          <td>&nbsp;<%=e_bean.getCar_nm3()%>
									&nbsp;&nbsp;&nbsp;&nbsp;
                  <a href="javascript:EstiATypeRegSpe('<%=e_bean.getCar_nm3()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="��������"></a>          	
          	</td>
        </tr>
				<%		}%>
				<%}%>
      </table>
    </td>
  </tr>
  <%}else{%>  
  <tr>
    <td class=h></td>
  </tr> 
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(!e_bean3.getEst_id().equals("")){%>����û<%}else{%>�ǽð�����<%}%></span></td>
	</tr>    
	<tr>
		<td class="line">
			<table border="0" cellpadding=0 cellspacing="1" width=100%>
        <tr>
          <td class=title width=10%>����</td>
          <td class=title width=15%>����</td>
          <td class=title width=20%>�ɼ�</td>
          <td class=title width=5%>����</td>
          <td class=title width=5%>�뿩<br>��ǰ</td>
          <td class=title width=5%>�뿩<br>�Ⱓ</td>
          <td class=title width=7%>����<br>����Ÿ�</td>
          <td class=title width=5%>����<br>�ɼ�</td>
          <td class=title width=10%>������</td>
          <td class=title width=13%>����</td>
          <td class=title width=5%>��ǰ</td>
        </tr>
        <%
        	EstimateBean e_bean4 = new EstimateBean();
        	
        	if(!e_bean2.getEst_id().equals("")) e_bean4 = e_bean2;
        	if(!e_bean3.getEst_id().equals("")) e_bean4 = e_bean3;
        	
        	CarMstBean cm_bean = a_cmb.getCarNmCase(e_bean4.getCar_id(), e_bean4.getCar_seq());
        	
        	String est_st = "";
        	if(e_bean4.getMgr_nm().equals("")) { 
        		est_st = "����";
        	}else{
        		if(e_bean4.getA_b().equals("1") && e_bean4.getMgr_ssn().equals("rm1")){	
        			est_st = "����Ʈ";
        		}else{	
        			est_st = "�縮��";
        		}
        	}
        %>
        <tr>
          <td align=center><%=est_st%><%if(!cr_bean.getCar_no().equals("")){%>&nbsp;<%=cr_bean.getCar_no()%><%}%></td>
          <td align=center><%=cm_bean.getCar_comp_nm()%> <%=cm_bean.getCar_nm()%> <%=cm_bean.getCar_name()%></td>
          <td align=center><%=e_bean4.getOpt()%></td>
          <td align=center>����: <%=e_bean4.getCol()%><br>����: <%=e_bean4.getIn_col()%></td>
          <td align=center><%if(est_st.equals("����Ʈ")){%>����Ʈ<%}else{%><%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%><%}%></td>
          <td align=center><%=e_bean4.getA_b()%>����</td>
          <td align=center><%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>km/��</td>
          <td align=center><%if(e_bean4.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean4.getOpt_chk().equals("1")){%>�ο�<%}%></td>
          <td align=center>
          	    ������:<%=e_bean4.getRg_8()%>%
            <br>������:<%=e_bean4.getPp_per()%>%
            <br>��������:<%=e_bean4.getGi_per()%>%
          </td>
          <td align=center>
          	    �����ڿ���:<%if(e_bean4.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean4.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean4.getIns_age().equals("3")){%>��24���̻�<%}%>
          	<br>�빰/�ڼ�:<%if(e_bean4.getIns_dj().equals("1")){%>5õ����/5õ����<%}else if(e_bean4.getIns_dj().equals("2")){%>1���/1���<%}else if(e_bean4.getIns_dj().equals("4")){%>2���/1���<%}else if(e_bean4.getIns_dj().equals("8")){%>3���/1���<%}else if(e_bean4.getIns_dj().equals("3")){%>5���/1���<%}%>
          	<br>������å��:<%=AddUtil.parseDecimal(e_bean4.getCar_ja())%>��
          </td>
          <td align=center><%if(e_bean4.getTint_s_yn().equals("Y")){%>���� ����<%}%><br>&nbsp;<%if(e_bean4.getTint_n_yn().equals("Y")){%>��ġ�� ������̼�<%}%><br>&nbsp;<%if(e_bean4.getTint_eb_yn().equals("Y")){%>�̵��� ������<%}%></td>
        </tr>        
        <tr>
          <td class=title>�뿩���</td>
          <td colspan='3'>&nbsp;
          	���뿩�� :  <%if(e_bean4.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt())%>��&nbsp;<%}%>
          	( ���ް� : <%if(e_bean4.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt())%>��&nbsp;<%}%>
          	  �ΰ��� : <%if(e_bean4.getFee_s_amt() == -1){%>�̿<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_v_amt())%>��&nbsp;<%}%>)
          </td>
          <td class=title colspan='2'>�����</td>
          <td colspan='5'>&nbsp;
          	���������� : <%=e_bean4.getCls_per()%>%&nbsp;
          	( �ʿ������� : <%=e_bean4.getCls_n_per()%>% )
          </td>
        </tr>
        
		<%if (est_st.equals("�縮��")) {%>
        <tr>
        	<td class=title>����ġ</td>
        	<td colspan='3'>&nbsp;
        		<%if (e_bean4.getBr_from().equals("0")) {%>����<%}%>
                <%if (e_bean4.getBr_from().equals("1")) {%>����<%}%>
                <%if (e_bean4.getBr_from().equals("2")) {%>�뱸<%}%>
                <%if (e_bean4.getBr_from().equals("3")) {%>����<%}%>
                <%if (e_bean4.getBr_from().equals("4")) {%>�λ�<%}%>
        	</td>
        	<td class=title colspan='2'>���ּ���<br>(�����ε�����)</td>
        	<td colspan='5'>&nbsp;
        		<%if (e_bean4.getBr_to_st().equals("0")) {%>������<%}%>
                <%if (e_bean4.getBr_to_st().equals("1")) {%>����/����/�泲/���<%}%>
                <%if (e_bean4.getBr_to_st().equals("2")) {%>�뱸/���<%}%>
                <%if (e_bean4.getBr_to_st().equals("3")) {%>����/����/����<%}%>
                <%if (e_bean4.getBr_to_st().equals("4")) {%>�λ�/���/�泲<%}%>
                <%if (e_bean4.getBr_to_st().equals("5")) {%>����<%}%>
                <input type="hidden" name="br_to_st" value="<%=e_bean4.getBr_to_st()%>">
        	</td>
        </tr>
		<%}%>
        
        <tr>
          <td class=title>������</td>
          <td colspan='3'>&nbsp;
			<%
			if(!e_bean2.getEst_id().equals("")){	// Ȩ���������� ������ �� ���
			%>
						<a href="javascript:smartEstView(<%=e_bean2.getEst_id()%>)"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
			<%
			}else{	// Ȩ������ ������ ������ ����
			%>
						<a href="javascript:EstiView('<%=est_st%>','<%=e_bean4.getEst_id()%>','<%=est_id%>')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
			<%
			}	
			%>			
          </td>
          <td class=title colspan='2'>�񱳰���</td>
          <td colspan='5'>&nbsp;
          		<%if (e_bean4.getPrint_type().equals("6")) {%>
					<a href="javascript:ReEsti6('<%=est_st%>','<%=e_bean4.getEst_id()%>','<%=e_bean4.getMgr_nm()%>','<%=est_id%>','<%=e_bean4.getSet_code()%>','<%=e_bean4.getEh_code()%>')"><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a>
          		<%} else {%>
					<a href="javascript:ReEsti('<%=est_st%>','<%=e_bean4.getEst_id()%>','<%=e_bean4.getMgr_nm()%>','<%=est_id%>')"><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a>
          		<%}%>
          </td>
        </tr>
        <%	//�ֱ�30���̳� ��������
        	String rent_gubun = "1";
        	if(est_st.equals("����")){		rent_gubun = "1";	}	//����
        	else if(est_st.equals("�縮��")){	rent_gubun = "7";	}	//�縮�� 
    		Vector vt_chk = e_db.getEstimateCustEstCheck(rent_gubun, e_bean.getEst_nm(), e_bean.getEst_ssn(), e_bean.getEst_tel(), e_bean.getEst_fax(), e_bean.getEst_email(), e_bean.getReg_dt().substring(0,8));
    		int vt_chk_size = vt_chk.size();
    		String est_check = "";
	    	if(vt_chk_size > 0){
	    		for (int i = 0 ; i < vt_chk_size ; i++){	
	           		Hashtable ht = (Hashtable)vt_chk.elementAt(i);
      				UsersBean user_bean 	= umd.getUsersBean(String.valueOf(ht.get("USER_NM")));
      				//��ġ���� üũ�Ͽ� �����߰�(20180822)
      				String ssn_yn = String.valueOf(ht.get("SSN_YN"));	//�ֹε�Ϲ�ȣ/����ڹ�ȣ ��ġ����
      				String tel_yn = String.valueOf(ht.get("TEL_YN"));	//��ȭ��ȣ ��ġ����
      				String fax_yn = String.valueOf(ht.get("FAX_YN"));	//�ѽ���ȣ ��ġ����	
      				String email_yn = String.valueOf(ht.get("EMAIL_YN"));	//�̸��� ��ġ����
      				
      				if(!user_bean.getDept_id().equals("1000")){
      					if(i==0)	est_check += "&nbsp;&nbsp;##����ȣ/�̸� or ����ڵ�Ϲ�ȣ or ����ó or FAX or �̸����ּҷ� �˻��� ���## ["+String.valueOf(ht.get("EST_NM"))+"]�� �ֱ� 30���̳� ������ ���Դϴ�.<br><br>&nbsp;&nbsp;&lt;�������� �˻����&gt;<br>";
      					est_check += "&nbsp;&nbsp;("+ String.valueOf(ht.get("REG_DT2")) +") ��������ڴ� " +String.valueOf(ht.get("USER_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"));
      					if(!ssn_yn.equals("Y")&&!tel_yn.equals("Y")&&!fax_yn.equals("Y")&&!email_yn.equals("Y")){
      						est_check += "&nbsp;&nbsp;����ȣ/�̸��� ��ġ�ϴ� ���Դϴ�. (���� ���ϰ����� Ȯ�� �ʿ��մϴ�)";
      					}
      					est_check += "<br>";
      				}
      				if(i==4) break;
	           	}
	    	}
	    	if(!est_check.equals("")){
        %>
		        <tr>
		        	<td class=title>�����̷�</td>
		          	<td colspan='10'><br><%=est_check%><br></td>
		        </tr>
		<%	} %>        
      </table>
    </td>
  </tr> 
  <%}%>
  <%	if(!shBn.getCar_mng_id().equals("")){
  			Vector sr = shDb.getShResList(shBn.getCar_mng_id(), shBn.getReg_code(), shBn.getEst_id());
				int sr_size = sr.size();
  %>
  <tr>
    <td class=h></td>
  </tr>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������&nbsp;&nbsp;<a href="javascript:view_sh_res_h()" title="�̷�"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a></span>
	</tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr>
    <td class="line">
    	<table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td class="title" width="5%">����</td>
          <td class="title" width="10%">�����</td>
          <td class="title" width="10%">�����Ȳ</td>
          <td class="title" width="15%">����Ⱓ</td>
          <td class="title" width="35%">�޸�</td>
          <td class="title" width="10%">�������</td>
          <td class="title" width="15%">ó��</td>
        </tr>
				<%	int sh_res_reg_chk = 0;
						for(int i = 0 ; i < sr_size ; i++){
							Hashtable sr_ht = (Hashtable)sr.elementAt(i);
							
							if(String.valueOf(sr_ht.get("SITUATION")).equals("2") && String.valueOf(sr_ht.get("RES_NUM")).equals("1")) sh_res_reg_chk = 1;
				%>
        <tr> 
          <td align="center"><%=sr_ht.get("RES_NUM")%></td>
          <td align="center">
		  <%
		  	String damdangName = c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER");
		  	if(damdangName != "" && damdangName != null){
		  %>          	
		  	<%=damdangName%>
		  <%}else{%>
		  	<a href="javascript:registerDamdang('<%=String.valueOf(sr_ht.get("EST_ID"))%>')"><img src="../images/button_in_regd.gif" id="regBtn"/></a> <!-- ����ڰ� ���� ��� ����� ��� ��ư�� ��Ÿ���� -->
		  <%} %>
          </td>
          <td align="center"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))				out.print("�����");
        												else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("���Ȯ��");
        												else if(String.valueOf(sr_ht.get("SITUATION")).equals("3"))		out.print("��࿬��");%>
        	</td>
          <td align="center">
					  <%if(!String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>
					    <%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
					  <%}%>
					</td>
          <td>&nbsp;<%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%></td>
          <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %></td>
          <td align="center" rowspan="2">
          	
          	
          	<%	if(String.valueOf(sr_ht.get("EST_ID")).equals(est_id)){%>
          	
						<%		if(String.valueOf(ycont.get("CAR_ST")).equals("2")){%>          	
          	
          	<!--���Ȯ��-->
					  <%			if(String.valueOf(sr_ht.get("RES_NUM")).equals("1") && String.valueOf(sr_ht.get("SITUATION")).equals("0") && !String.valueOf(sr_ht.get("USE_YN")).equals("N")){%>
					  <a href="javascript:reserveCar2Cng('<%=shBn.getCar_mng_id()%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>');" title='�������� ���Ȯ���ϱ�'><img src=/acar/images/center/button_in_dec.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
					  <%			}%>
					  
            <!--����Ʈ��� ����-->
					  <%			if(String.valueOf(sr_ht.get("RES_NUM")).equals("1") && String.valueOf(sr_ht.get("SITUATION")).equals("2") && String.valueOf(sr_ht.get("USE_YN")).equals("Y") && rmcont_yn.equals("")){%>
					  <a href="javascript:RmContReg('<%=shBn.getCar_mng_id()%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='����Ʈ��� �����ϱ�'><img src=/acar/images/center/button_in_mlink.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
					  <%			}%>
					  
					  <%		}%>
					  
					  <!--�������-->
					  <%		if(String.valueOf(sr_ht.get("USE_YN")).equals("N")){%>
					  <%			if(String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>���<%}else{%>����<%}%>
					  <%		}else{%>
					  <a href="javascript:cancelCar('<%=shBn.getCar_mng_id()%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='�������� ����ϱ�'><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a>
					  <%		}%>
					  
			<%	}%>
					  
          	
		  </td>
        </tr>
        <tr>
        	<td align="center" colspan="6">
        		 <%		if((String.valueOf(sr_ht.get("RES_NUM")).equals("1") && String.valueOf(sr_ht.get("SITUATION")).equals("0") && !String.valueOf(sr_ht.get("USE_YN")).equals("N"))||(String.valueOf(sr_ht.get("RES_NUM")).equals("1") && String.valueOf(sr_ht.get("SITUATION")).equals("2") && String.valueOf(sr_ht.get("USE_YN")).equals("Y") && rmcont_yn.equals(""))){%>
        		[�غ�]   
        		<select name='sms_msg'>
                        <option value="">================����================</option>
						            <option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������">�Ϲݰ���/���ι湮/���θ� ����</option>
						            <option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������, �߰�������(�����) ������ �纻">�Ϲݰ���/���ι湮/�߰�������(�����) �ִ°��</option>
						            <option value="">------------------------------------------------------------</option>
						            <option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������, ����� �纻">���λ����/���ι湮/���θ� ����</option>
						            <option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������, ����� �纻, �߰������� [�ǰ����� �ڰ�Ȯ�μ�], �߰������� �������纻">���λ����/���ι湮/�߰������� �ִ°��</option>
						            <option value="���λ���� ���� �ſ�ī��(üũī��� �Ұ�), �����(���λ����) ���������� �纻, ����� �纻, ������ [�ǰ����� �ڰ�Ȯ�μ�], ������ ������">���λ����/�����湮/����� ������ ���� �������</option>
						            <option value="">------------------------------------------------------------</option>
						            <option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ��ǥ�� ����ī�� [üũī�� �Ұ�], ��ǥ�̻� ����������, ����� �纻">����/��ǥ�ڹ湮/���θ� ����</option>
						            <option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ��ǥ�� ����ī�� [üũī�� �Ұ�], ��ǥ�̻� ����������, ����� �纻, �߰������� [�ǰ����� �ڰ�Ȯ�μ�], �߰������� �������纻">����/��ǥ�ڹ湮/�߰������� �ִ°��</option>
						            <option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ���� ������ ����ī�� [üũī�� �Ұ�], ����� �纻, �湮�� [�ǰ����� �ڰ�Ȯ�μ�], �湮�� ����������">����/�����湮/�湮�ڸ� ����</option>
						            <option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ���� ������ ����ī�� [üũī�� �Ұ�], ����� �纻, �湮�� [�ǰ����� �ڰ�Ȯ�μ�], �湮�� ����������, �߰������� [�ǰ����� �ڰ�Ȯ�μ�], �߰������� �������纻">����/�����湮/�߰������� �ִ°��</option>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				[������]   
				<select name='sms_msg2'>
					<option value="">================����================</option>
					<!--<option value="seoul1">��������:�Ѹ��� ���� ������(�������Ա� ���� 20m)</option>-->
					<option value="seoul">������������:������ ����������</option>
					<option value="busan1">�λ�������1:�λ����� ����Ʈ���� 3��</option>
					<option value="busan2">�λ�������2:�����̵���ǽ��� ����1�� ������</option>
					<!-- <option value="daejeon1">����������1:��ȣ�ڵ��������� 2�� (��)�Ƹ���ī ��������</option> -->
					<option value="daejeon2">����������:(��)����ī��ũ 2�� (��)�Ƹ���ī ��������</option>
					<option value="daegu">�뱸������:(��)��������������</option>
					<option value="kwangju">����������:��1���ڵ���������</option>
				</select>
				<%} %>
        	</td>
        </tr>
				<%}%>
				<%if(sr_size==0){%>
        <tr>
          <td align="center" colspan="7">��ϵ� ����Ÿ�� �����ϴ�.</td>
        </tr>
				<%}%>
      </table>
	  </td>
  </tr>
  <%}%>
  <tr>
  	<td>
  		<span style="color:red;display:none;" id="damdangInfo">*** ����ڰ� �����ϴ�. ����� ����ϰ� �������� ���������Ͻʽÿ�</span></td>
  </tr>
  <!-- ������Ȳ�߰� 20190424 -->
  <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ</span></td>
    </tr>
	<%if(!use_st.equals("null")){%>
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">��౸��</td>
                    <% if (String.valueOf(reserv.get("RENT_ST")).equals("��������")) { %>
	                    <td width="34%">&nbsp;<a href="javascript:view_rentcont('<%=reserv.get("USE_ST")%>','<%=reserv.get("RENT_S_CD")%>');"><%=reserv.get("RENT_ST")%></a></td>
	                    <td class="title" width="16%">����ġ</td>
						<td width="34%">&nbsp;			
							<%for(int i = 0 ; i < good_size ; i++){
								CodeBean good = goods[i];
								if(park.equals(good.getNm_cd()))%><%= good.getNm()%>
							<%}%>
						</td>
					<% } else { %>
						<td width="84%" colspan='3'>&nbsp;<a href="javascript:view_rentcont('<%=reserv.get("USE_ST")%>','<%=reserv.get("RENT_S_CD")%>');"><%=reserv.get("RENT_ST")%></a></td>	                    
					<% } %>
    		    </tr>
    		    <tr>
                    <td class="title" width="16%">�뿩�Ⱓ</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT")))%>~<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT")))%>
					&nbsp;&nbsp;&nbsp;
					[���] <%=AddUtil.ChangeDate2(String.valueOf(reserv.get("REG_DT")))%> <%=c_db.getNameById(String.valueOf(reserv.get("REG_ID")),"USER")%>
					</td>
					<td class="title" width="16%">�����</td>
                    <td width="34%">&nbsp;<%=reserv.get("FIRM_NM")%>&nbsp;<%=reserv.get("CUST_NM")%></td>					
                </tr>
            </table>
	    </td>
    </tr>
    	<%	if(String.valueOf(reserv.get("RENT_ST")).equals("�����뿩")){%>
	<input type="hidden" name="ret_dt" 		value="">
	<%	}else{%>
	<input type="hidden" name="ret_dt" 		value="<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT2")))%>">
	<%	}%>
	<%}else{%>
	<input type="hidden" name="ret_dt" 		value="">
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">��౸��</td>
                    <td width="34%">&nbsp;���</td>
                    <td class="title" width="16%">����ġ</td>
                    <td width="34%">&nbsp;
						<%for(int i = 0 ; i < good_size ; i++){
							CodeBean good = goods[i];
							if(park.equals(good.getNm_cd()))%><%= good.getNm()%>
						<%}%>
        			</td>
                </tr>
            </table>
	    </td>
    </tr>
	<%}%>
  <tr>
  	<td><hr></td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
  </tr>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ȭ ����</span></td>
	</tr>
  <tr>
    <td class=line2></td>
  </tr>
	<tr>
    <td class='line'> 
      <table  border=0 cellspacing=1 cellpadding="0" width="100%">
        <tr> 
          <td class=title width=10%>��¥</td>
          <td class=title width=10%>�ۼ���</td>
          <td class=title width=80%>��ȭ����</td>
        </tr>
        <%for(int i=0; i<em_r.length; i++){
        		em_bean = em_r[i];
        %>
        <tr> 
          <td align=center><%= AddUtil.ChangeDate3(em_bean.getReg_dt()) %></td>
          <td align=center><%=c_db.getNameById(em_bean.getUser_id(), "USER")%></td>
          <td>&nbsp;<%=Util.htmlBR(em_bean.getNote())%></td>
        </tr>
        <%}%>
        <%if(em_r.length == 0){%>
        <tr> 
          <td align=center height=25 colspan="3">��ϵ� ����Ÿ�� �����ϴ�.</td>
        </tr>
        <%}%>
			</table>
		</td>
	</tr>
  <tr>
  	<td class=h></td>
  </tr>
  <%if ( chk.equals("1") || !bb_chk.equals("") ) {%> 
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ȭ���� ���� Ŭ��</span></td>
	</tr>
  <tr>
    <td align="left">   
      <a href="javascript:tell_save('00')"><img src=/acar/images/center/button_call_con.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
      <a href="javascript:tell_save('01')"><img src=/acar/images/center/button_call_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
      <a href="javascript:tell_save('02')"><img src=/acar/images/center/button_call_nnum.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
	    <a href="javascript:msg_send()">[�����߹��ڹ߼�]</a>&nbsp;&nbsp; 
    </td>
  </tr>
	<tr><td><font color=red>***</font>&nbsp;[��ȭ����]�� ��ȭ�� �õ��ϴ� ������ ������ ���� ��� ��û�� ���� ��ȭ�� ����� ������ Ŭ���� �Ͽ��� �մϴ�.</td></tr>
  <% } %>
  <tr>
  	<td class=h></td>
  </tr>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� �Է�</span></td>
	</tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr>
    <td class=line>
      <table border="0" cellspacing="1" width=100%>
        <tr>
          <td class=title width=10% rowspan="2">����</td>
          <td>&nbsp;<textarea name="note" cols=100 rows=5 onBlur="javascript:change(this.value);" class=default></textarea>
            &nbsp;<a id="submitLink" href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
          </td>
        </tr>
        <tr>
          <td style="font-size:9pt">
					  &nbsp;03:���׳� 04:����ڹ�Ȯ�� 05:������� 06:������ü 07:�ܱ�뿩 08:�񱳰�����<br> 
					  &nbsp;09:����������ȸ 10:�����ü���������� 11:Ÿ�緻Ʈ(����)�ΰ���� 12:�Һα�����<br>
					  &nbsp;13:��Ⱓ���� 14:�̸������� 15:�������� 16:���ü�� 17:������ 18:��Ÿ 19:�����߹��ڹ߼�
					</td>
        </tr>
      </table>
    </td>
  </tr>	
	<tr>
		<td>
			<font color=red>***</font>&nbsp;����� ��ȣ�� ����Ͻø� ���մϴ�.
		</td>
	</tr>
  <% if ( chk.equals("1") || !bb_chk.equals("") ) {%>
  <% } else {%>   
	<tr>
		<td>
			<font color=red>***</font>&nbsp;Ư���� �Է��� ������� ������ ������ �˴ϴ�.
		</td>
	</tr>
	<% } %>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
<script>
//�������/����� ��ȣ ������ ���
function getKoreanAge(est_st, est_ssn){		// ��� ������ /fms2/lc_rent/search_age.jsp������ Search(birth) �Լ� ����
	if(est_st.length == 3 && est_ssn != null){
		var substr_est_st = est_st.substr(2,1);
		if(substr_est_st == '3'){	// ������ ���� ������ ǥ��
			var regex = /[^0-9]/gi;
			var removeCharacter = est_ssn.replace(regex, "");	
						
			var birthYear;
			var birthFullYear;
			var birthMon;
			var birthDay;
			
			if(removeCharacter.length == 6){		// 810515 ����
				birthYear = removeCharacter.substr(0, 2);	// �����̿� ����
				if(birthYear > 20){	// 1921�⵵, 1922��, 1923�� ...
					birthFullYear = 19;
				}else {		// 2020��, 2019��, 2018�� ...
					birthFullYear = 20;
				}
				birthFullYear += birthYear;
				birthMon = removeCharacter.substr(2, 2);
				birthDay = removeCharacter.substr(4, 2);
			}else if(removeCharacter.length == 8){	// 19810515 ����
				birthFullYear = removeCharacter.substr(0, 4);
				birthMon = removeCharacter.substr(4, 2);
				birthDay = removeCharacter.substr(6, 2);
			}
			
			var birthdaymd = birthMon;
			birthdaymd += birthDay;
						
			var today = new Date();
			var year = today.getFullYear();
			var month = (today.getMonth()+1);
			var day = today.getDate();
			
			//var monthDay = month + day;	// monthDay �� 1218 �������� �Ǿ�� �ϳ� ������ ������ �̷������ 
			var monthDay = month;
			monthDay += day.toString();	// ���ڿ��� ��ȯ �� ���� �� �ֵ��� ������		2017.12.18
						
			var age = " (�� ";
			age += monthDay < birthdaymd ? year - birthFullYear -1 : year - birthFullYear;
			age += "��)";
						
			document.getElementById("koreanAge").innerText = age;
		}
	}
}

document.addEventListener('DOMContentLoaded', function(){
	getKoreanAge('<%=e_bean.getEst_st()%>', '<%=e_bean.getEst_ssn()%>');
});
	
</script>
</html>
