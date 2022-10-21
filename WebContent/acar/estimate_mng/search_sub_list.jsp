<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String jg_g_7 = request.getParameter("jg_g_7")==null?"":request.getParameter("jg_g_7");
	String print_type = request.getParameter("print_type")==null?"":request.getParameter("print_type");
	String garnish_yn_opt_st = request.getParameter("garnish_yn_opt_st")==null?"":request.getParameter("garnish_yn_opt_st");
	String hook_yn_opt_st = request.getParameter("hook_yn_opt_st")==null?"":request.getParameter("hook_yn_opt_st");
	String rent_dt	= request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt");
	
	if(rent_dt.equals("")){
		rent_dt = AddUtil.getDate(4);
	}else{
		rent_dt = AddUtil.replace(rent_dt,"-","");
	}
	
	if(ck_acar_id.equals("000029")){
		//out.println("rent_dt="+rent_dt);
	}
	
	//System.out.println("print_type >>> " + print_type);
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	/* System.out.println(idx);
	System.out.println(car_comp_id);
	System.out.println(car_cd);
	System.out.println(car_id);
	System.out.println(car_seq);
	System.out.println(a_a); */

	//���������� ����Ʈ	
	Vector vars = e_db.getCarSubList(idx, car_comp_id, car_cd, car_id, car_seq, a_a);
	int size = vars.size();
	
	String tmp_jg_tuix_st = "";
	String tmp_lkas_yn = "";
	String tmp_ldws_yn = "";
	String tmp_aeb_yn = "";
	String tmp_fcw_yn = "";
	String tmp_garnish_yn = "";
	String tmp_hook_yn = "";
	
	if (idx.equals("2")) {
		Vector vars2 = e_db.getCarSubList("2_1", car_comp_id, car_cd, car_id, car_seq, a_a);
		for (int v = 0 ; v < vars2.size() ; v++) {
			Hashtable var2 = (Hashtable)vars2.elementAt(v);
			
			tmp_jg_tuix_st = var2.get("JG_TUIX_ST").toString();
			tmp_lkas_yn = var2.get("LKAS_YN").toString();
			tmp_ldws_yn = var2.get("LDWS_YN").toString();
			tmp_aeb_yn = var2.get("AEB_YN").toString();
			tmp_fcw_yn = var2.get("FCW_YN").toString();
			tmp_garnish_yn = var2.get("GARNISH_YN").toString();
			tmp_hook_yn = var2.get("HOOK_YN").toString();
			
			/* System.out.println("tmp_jg_tuix_st >>>> " + tmp_jg_tuix_st);
			System.out.println("tmp_lkas_yn >>>> " + tmp_lkas_yn);
			System.out.println("tmp_ldws_yn >>>> " + tmp_ldws_yn);
			System.out.println("tmp_aeb_yn >>>> " + tmp_aeb_yn);
			System.out.println("tmp_fcw_yn >>>> " + tmp_fcw_yn); */
		}
	}
	
	//tuix/tuon ī��Ʈ
	int tuix_count = 0;
	
	//��������ǥ������ ī��Ʈ
	int duty_free_count = 0;
	int duty_free_count2 = 0;
	if(idx.equals("1")){		
		for(int z = 0 ; z < size ; z++){
			Hashtable temp_var = (Hashtable)vars.elementAt(z);
			
			if (temp_var.get("DUTY_FREE_OPT").equals("0")) {
				duty_free_count++;
			}
			if (temp_var.get("DUTY_FREE_OPT").equals("1")) {
				duty_free_count2++;
			}
		}
	}
	
	if(idx.equals("4") && size==0){
		//vars = e_db.getCarSubList("4_2", car_comp_id, car_cd, car_id, car_seq, a_a);
		//size = vars.size();		
	}
	
	
	if(idx.equals("2")||idx.equals("3")){
		//��������
		cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
		//��������
		ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	}
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style>
.parent-title {
    color:#494949;
    font-weight:bold;
    margin-left:8px;
}
.default-title {
	color:#f23053;
	font-weight:bold;
}
.parent-desc {
	font-weight:bold;
	line-height:25px;
}
p {
	margin:5px auto 20px;
}

#tuix {
    font-family: sans-serif, Gulim, AppleGothic, Seoul, Arial;
    cursor: pointer;
    font-weight: bold;
    font-size: 12px;
    padding: 3px 3px 3px 3px;
    background-color: #848484;
    color: #FFF;
    width: 140px;
    height: 17px;
    text-align: center;
    vertical-align: middle;
    margin-left: 10px;
}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function setCodeDir(){		
		var ofm = opener.document.form1;
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;		
		
		<%if(idx.equals("2")){%>
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_s_seq"){		
				if(ck.checked == true){
					cnt++;
				}
			}
		}
		
		if(cnt == 0){
			ofm.opt.value 		= fm.dir_nm.value;
			ofm.opt_seq.value 	= '';
			ofm.opt_amt.value 	= fm.dir_amt.value;			
			ofm.opt_amt_m.value 	= "";			
			ofm.jg_opt_st.value 	= '';	
			ofm.jg_tuix_opt_st.value 	= '';	
		}else{
			save();
		}
					
		<%}else if(idx.equals("3")){%>
		ofm.col.value 		= fm.dir_nm.value;
		ofm.in_col.value	= fm.dir_nm2.value;
		ofm.col_seq.value 	= '';
		ofm.col_amt.value 	= fm.dir_amt.value;				
		ofm.jg_col_st.value 	= '';	
		<%}%>
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));
				
		self.close();				
	}	
	
	function setCode(id, seq, nm, amt, s_st, jg_code, jg_f, jg_g, jg_3, jg_w, jg_h, jg_i, jg_b, jg_opt_st, jg_g_7, end_dt, jg_tuix_st, lkas_yn, ldws_yn, aeb_yn, fcw_yn, car_etc, car_etc2, car_b_p2, duty_free_opt, jg_opt_yn, garnish_yn, hook_yn, jg_g_15) {
		var fm = opener.document.form1;
		
		var car_comp_id = '<%=car_comp_id%>';
		
		<%if (idx.equals("1")) {%>
		if (end_dt == 'N') {
			if(!confirm('�� ������ �ܻ�� �������� ��� Ȯ�� �ٶ��ϴ�.')){	return;	}	
		}
		
		var param_jg_g_7 = document.form1.jg_g_7.value;
		
		fm.jg_code.value = jg_code;	
		fm.car_name.value = nm;
		fm.car_id.value = id;
		fm.car_seq.value = seq;
		fm.car_amt.value = parseDecimal(amt);
		fm.s_st.value = s_st;				
		fm.opt.value = '';
		fm.opt_seq.value = '';
		fm.opt_amt.value = '0';		
		fm.opt_amt_m.value = '0';		
		fm.jg_opt_st.value = '';	
		fm.col.value = '';
		fm.col_seq.value = '';
		fm.col_amt.value = '0';		
		fm.in_col.value = '';
		fm.garnish_col.value = '';
		fm.jg_col_st.value = '';	
		fm.dc.value = '';
		fm.dc_seq.value = '';
		fm.dc_amt.value = '0';
		fm.dc_amt2.value = '0';
		fm.esti_d_etc.value = '';
		fm.ls_yn.value = '';		
		fm.jg_g_7.value = jg_g_7;
		fm.tax_dc_amt.value = 0;
		fm.conti_rat.value = '';
		fm.conti_rat_seq.value = '';
		fm.duty_free_opt.value = duty_free_opt;
		fm.jg_g_15.value = jg_g_15;
		
		//�������ϰ��
		<%if(AddUtil.parseInt(car_comp_id) > 5){%>
			fm.car_b_p2.value = parseDecimal(car_b_p2);
    	<%}%>
				
    	// 2021.01.13. �����ڵ� > 8000000(������/ȭ����)�̰ų� ������/�������� ��� ������ȣ�� ��û �׸� �� ���̵��� ó��.
		// �Ϻ� ������ �߰�
		// 2021.11.03. ����/ȭ���� ������ȣ�� ��û ����. �ް�Ʈ�� ����.
		if( ( Number(jg_code) > 9018110 && Number(jg_code) < 9018999 ) 
				|| Number(jg_b) == 5 || Number(jg_b) == 6 
				|| car_comp_id == '0044' || car_comp_id=='0007' || car_comp_id=='0025' || car_comp_id=='0033' || car_comp_id=='0048' 
			){
			fm.new_license_plate[0].style.display = 'none';
			fm.new_license_plate[1].style.display = 'none';
			fm.new_license_plate[2].style.display = 'none';
			fm.new_license_plate[3].style.display = 'none';
			fm.new_license_plate[0].previousElementSibling.style.display = 'none';
			fm.new_license_plate[1].previousElementSibling.style.display = 'none';
			fm.new_license_plate[2].previousElementSibling.style.display = 'none';
			fm.new_license_plate[3].previousElementSibling.style.display = 'none';
			// 20210304 ������ȣ�� �⺻�� '��û'���� �����Ͽ� ����/ȭ����, ����/������ �⺻�� ������ȣ������ ����. 
			fm.new_license_plate[0].value = "0";
			fm.new_license_plate[1].value = "0";
			fm.new_license_plate[2].value = "0";
			fm.new_license_plate[3].value = "0";
		} else {
			fm.new_license_plate[0].style.display = '';
			fm.new_license_plate[1].style.display = '';
			fm.new_license_plate[2].style.display = '';
			fm.new_license_plate[3].style.display = '';
			fm.new_license_plate[0].previousElementSibling.style.display = '';
			fm.new_license_plate[1].previousElementSibling.style.display = '';
			fm.new_license_plate[2].previousElementSibling.style.display = '';
			fm.new_license_plate[3].previousElementSibling.style.display = '';
			fm.new_license_plate[0].value = "1";
			fm.new_license_plate[1].value = "1";
			fm.new_license_plate[2].value = "1";
			fm.new_license_plate[3].value = "1";
		}
    	
		/* if(jg_g_7=='1' || jg_g_7=='2' || jg_g_7=='3' || jg_g_7=='4'){ */
		//�׽��� �߰��� ģȯ���� ���п��� ���������� ����
		if (Number(jg_b) >= 3){
			opener.tr_ecar_tax.style.display = '';
			//20200506 ������ �� �������� ��� �������ｺƼĿ �̹߱�
			// 2021.02.08. �������ｺƼĿ ���ʿ�� �ּ� ó��.
			/* if (Number(jg_b) == 5 || Number(jg_b) == 6) {
				opener.tr_eco_etag.style.display = 'none';
			} else {
				opener.tr_eco_etag.style.display = '';
			}
			fm.eco_e_tag[0].options[1].selected = true;
			fm.eco_e_tag[1].options[1].selected = true;
			fm.eco_e_tag[2].options[1].selected = true;
			fm.eco_e_tag[3].options[1].selected = true; */
		} else {
			opener.tr_ecar_tax.style.display = 'none';
			// opener.tr_eco_etag.style.display = 'none';
			/* fm.eco_e_tag[0].options[0].selected = true;
			fm.eco_e_tag[1].options[0].selected = true;
			fm.eco_e_tag[2].options[0].selected = true;
			fm.eco_e_tag[3].options[0].selected = true; */
		}
		
		fm.ecar_loc_st[0].options[0].selected = true;
		fm.ecar_loc_st[1].options[0].selected = true;
		fm.ecar_loc_st[2].options[0].selected = true;
		fm.ecar_loc_st[3].options[0].selected = true;
		
		//20200313 ���� �Ϸ�Ʈ��, ���� EV �뱸�� ���ð���, �� �ܿ��� �������
		autoEcarLocationDisSel(jg_g_7, jg_code);
		
		// �������� ��ǰ�� - ������� �̽ð� ���� �׸� �� ���̵���.
		if(Number(car_comp_id) > 5){
			opener.tint_sn_yn_div_1.style.display = "none";
			opener.tint_sn_yn_div_2.style.display = "none";
			opener.tint_sn_yn_div_3.style.display = "none";
			opener.tint_sn_yn_div_4.style.display = "none";
			opener.tint_sn_yn_1.checked = false;
			opener.tint_sn_yn_2.checked = false;
			opener.tint_sn_yn_3.checked = false;
			opener.tint_sn_yn_4.checked = false;
			
			// �������� ���ڽ� ���������� �׸� �̳��� 20211028
			opener.tint_bn_yn_div_1.style.display = "none";
			opener.tint_bn_yn_div_2.style.display = "none";
			opener.tint_bn_yn_div_3.style.display = "none";
			opener.tint_bn_yn_div_4.style.display = "none";
			opener.tint_bn_yn_1.checked = false;
			opener.tint_bn_yn_2.checked = false;
			opener.tint_bn_yn_3.checked = false;
			opener.tint_bn_yn_4.checked = false;
			
		} else {
			// ������� �̽ð� ����
			opener.tint_sn_yn_div_1.style.display = "inline";
			opener.tint_sn_yn_div_2.style.display = "inline";
			opener.tint_sn_yn_div_3.style.display = "inline";
			opener.tint_sn_yn_div_4.style.display = "inline";
			
			// ���ڽ� ������ ����
			opener.tint_bn_yn_div_1.style.display = "inline";
			opener.tint_bn_yn_div_2.style.display = "inline";
			opener.tint_bn_yn_div_3.style.display = "inline";
			opener.tint_bn_yn_div_4.style.display = "inline";
		}
		
		if (jg_g_7 == "3") {
						
			opener.tr_hcar_loc.style.display	= 'none';
			fm.loc_st[0].options[0].selected = true;
			fm.loc_st[1].options[0].selected = true;
			fm.loc_st[2].options[0].selected = true;
			fm.loc_st[3].options[0].selected = true;
			
			if (car_comp_id == "0056" || car_comp_id == '0057'){
				//��ǰ
				opener.tr_tint_s_yn.style.display = "none";
				
				//���鼱��
				$(opener.document).find("#tint_s_yn_1").prop("checked", false);
				$(opener.document).find("#tint_s_yn_2").prop("checked", false);
				$(opener.document).find("#tint_s_yn_3").prop("checked", false);
				$(opener.document).find("#tint_s_yn_4").prop("checked", false);
				
				//������� �̽ð� ����
				$(opener.document).find("#tint_sn_yn_1").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_2").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_3").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_4").prop("checked", false);
				
				//��޽��� - üũ�ڽ�
				$(opener.document).find("#tint_ps_yn_1").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_2").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_3").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_4").prop("checked", false);
				
				//��޽��� - ������ǥ�� ����Ʈ�ڽ�
				$(opener.document).find("#setTint_ps_sel_1 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_2 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_3 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_4 option[value='Y']").attr("selected", 'selected');
				
				//��޽��� - FMSǥ��
				$(opener.document).find("#tint_ps_nm_1").val("");
				$(opener.document).find("#tint_ps_nm_2").val("");
				$(opener.document).find("#tint_ps_nm_3").val("");
				$(opener.document).find("#tint_ps_nm_4").val("");
				
				//��޽��� - �߰��ݾ�
				$(opener.document).find("#tint_ps_amt_1").val("0");
				$(opener.document).find("#tint_ps_amt_2").val("0");
				$(opener.document).find("#tint_ps_amt_3").val("0");
				$(opener.document).find("#tint_ps_amt_4").val("0");
								
				//��ġ���׺���̼�
				$(opener.document).find("#tint_n_yn_1").prop("checked", false);
				$(opener.document).find("#tint_n_yn_2").prop("checked", false);
				$(opener.document).find("#tint_n_yn_3").prop("checked", false);
				$(opener.document).find("#tint_n_yn_4").prop("checked", false);
								
				//���ڽ� ������ ���� (��Ʈ��ķ,������..)
				$(opener.document).find("#tint_bn_yn_1").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_2").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_3").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_4").prop("checked", false);
				
				//����ǥ���ǽ�û ����Ʈ�ڽ�
				$(opener.document).find("#new_license_plate_1 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_2 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_3 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_4 option[value='']").attr("selected", 'selected');
				
				//�߰�Ź�۷� ����
				$(opener.document).find("#tint_cons_yn_1").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_2").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_3").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_4").prop("checked", false);
				
				//�߰�Ź�۷� �ݾ�
				$(opener.document).find("#tint_cons_amt_1").val("0");
				$(opener.document).find("#tint_cons_amt_2").val("0");
				$(opener.document).find("#tint_cons_amt_3").val("0");
				$(opener.document).find("#tint_cons_amt_4").val("0");
				
				//�̵���������(������)
				$(opener.document).find("#tint_eb_yn_1").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_2").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_3").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_4").prop("checked", false);
				
				if (jg_code == "5866" || jg_code == "6316111") {
					//���������ּ���
					opener.tr_ecar_loc.style.display	= "none";
				} else {
					//���������ּ���
					opener.tr_ecar_loc.style.display = "";
				}
				
				//�����ε�����0����-�������� esti_mng_atype_i ���� ����
				fm.loc_st[0].disabled = false;
				
				//���ﰭ�����񽺼��Ϳ��� ���� �� �ε� - �ӽ��ּ� 20190821
				/* opener.loc_st_cmt_1.style.display = "";
				opener.loc_st_cmt_2.style.display = "";
				opener.loc_st_cmt_3.style.display = "";
				opener.loc_st_cmt_4.style.display = ""; */
				
			} else {
				opener.tr_tint_s_yn.style.display = "";
				opener.tr_ecar_loc.style.display	= "";
				
				//�����ε�����0����-�������� esti_mng_atype_i ���� ����
				fm.loc_st[0].disabled = false;
				
				//���ﰭ�����񽺼��Ϳ��� ���� �� �ε� - �ӽ��ּ� 20190821
				/* opener.loc_st_cmt_1.style.display = "none";
				opener.loc_st_cmt_2.style.display = "none";
				opener.loc_st_cmt_3.style.display = "none";
				opener.loc_st_cmt_4.style.display = "none"; */
			}
			
			if( jg_g_15 > 0 ){
				opener.tr_ecar_loc.style.display	= '';
			} else {
				opener.tr_ecar_loc.style.display	= 'none';
				// ���κ����� 0���� ������ ���� �� ������ ���ּ��� ������ ���� �������� �ӽ� ���. 2022.01.25
				$(opener.document).find("#ecar_loc_st_1 option[value='13']").prop("selected", true);
				$(opener.document).find("#ecar_loc_st_2 option[value='13']").prop("selected", true);
				$(opener.document).find("#ecar_loc_st_3 option[value='13']").prop("selected", true);
				$(opener.document).find("#ecar_loc_st_4 option[value='13']").prop("selected", true);
			}
			
		} else if (jg_g_7 == '4') {
			
			opener.tr_ecar_loc.style.display	= 'none';
			opener.tr_hcar_loc.style.display	= '';
			opener.tr_tint_s_yn.style.display = "";
			fm.loc_st[0].options[0].selected = true;
			fm.loc_st[1].options[0].selected = true;
			fm.loc_st[2].options[0].selected = true;
			fm.loc_st[3].options[0].selected = true;
			
			//�����ε�����0����-�������� esti_mng_atype_i ���� ����
			fm.loc_st[0].disabled = false;
			
			//���ﰭ�����񽺼��Ϳ��� ���� �� �ε�
			/* opener.loc_st_cmt_1.style.display = "none";
			opener.loc_st_cmt_2.style.display = "none";
			opener.loc_st_cmt_3.style.display = "none";
			opener.loc_st_cmt_4.style.display = "none"; */
			
		} else {
			opener.tr_ecar_loc.style.display	= 'none';
			opener.tr_hcar_loc.style.display	= 'none';
			opener.tr_tint_s_yn.style.display = "";
			//�����ε�����0����-�������� esti_mng_atype_i ���� ����
			fm.loc_st[0].disabled = false;
			
			//���ﰭ�����񽺼��Ϳ��� ���� �� �ε�
			/* opener.loc_st_cmt_1.style.display = "none";
			opener.loc_st_cmt_2.style.display = "none";
			opener.loc_st_cmt_3.style.display = "none";
			opener.loc_st_cmt_4.style.display = "none"; */
			
			// ����Ƽ/�ް�Ʈ�� ��ǰ�� display: none ó��
			if ( Number(jg_code) > 9017300 && Number(jg_code) < 9018200 ){
				//��ǰ
				opener.tr_tint_s_yn.style.display = "none";
				
				//���鼱��
				$(opener.document).find("#tint_s_yn_1").prop("checked", false);
				$(opener.document).find("#tint_s_yn_2").prop("checked", false);
				$(opener.document).find("#tint_s_yn_3").prop("checked", false);
				$(opener.document).find("#tint_s_yn_4").prop("checked", false);
				
				//������� �̽ð� ����
				$(opener.document).find("#tint_sn_yn_1").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_2").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_3").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_4").prop("checked", false);
				
				//��޽��� - üũ�ڽ�
				$(opener.document).find("#tint_ps_yn_1").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_2").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_3").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_4").prop("checked", false);
				
				//��޽��� - ������ǥ�� ����Ʈ�ڽ�
				$(opener.document).find("#setTint_ps_sel_1 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_2 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_3 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_4 option[value='Y']").attr("selected", 'selected');
				
				//��޽��� - FMSǥ��
				$(opener.document).find("#tint_ps_nm_1").val("");
				$(opener.document).find("#tint_ps_nm_2").val("");
				$(opener.document).find("#tint_ps_nm_3").val("");
				$(opener.document).find("#tint_ps_nm_4").val("");
				
				//��޽��� - �߰��ݾ�
				$(opener.document).find("#tint_ps_amt_1").val("0");
				$(opener.document).find("#tint_ps_amt_2").val("0");
				$(opener.document).find("#tint_ps_amt_3").val("0");
				$(opener.document).find("#tint_ps_amt_4").val("0");
								
				//��ġ���׺���̼�
				$(opener.document).find("#tint_n_yn_1").prop("checked", false);
				$(opener.document).find("#tint_n_yn_2").prop("checked", false);
				$(opener.document).find("#tint_n_yn_3").prop("checked", false);
				$(opener.document).find("#tint_n_yn_4").prop("checked", false);
								
				//���ڽ� ������ ���� (��Ʈ��ķ,������..)
				$(opener.document).find("#tint_bn_yn_1").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_2").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_3").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_4").prop("checked", false);
				
				//����ǥ���ǽ�û ����Ʈ�ڽ�
				$(opener.document).find("#new_license_plate_1 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_2 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_3 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_4 option[value='']").attr("selected", 'selected');
				
				//�߰�Ź�۷� ����
				$(opener.document).find("#tint_cons_yn_1").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_2").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_3").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_4").prop("checked", false);
				
				//�߰�Ź�۷� �ݾ�
				$(opener.document).find("#tint_cons_amt_1").val("0");
				$(opener.document).find("#tint_cons_amt_2").val("0");
				$(opener.document).find("#tint_cons_amt_3").val("0");
				$(opener.document).find("#tint_cons_amt_4").val("0");
				
				//�̵���������(������)
				$(opener.document).find("#tint_eb_yn_1").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_2").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_3").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_4").prop("checked", false);
				
			}
			
			opener.LocStSet();			
		}		
	    	
    	$(opener.document).find("#ro_13_0_display_1").css("display", "");
    	$(opener.document).find("#ro_13_0_display_2").css("display", "none");
    	
    	$(opener.document).find("#ro_13_1_display_1").css("display", "");
    	$(opener.document).find("#ro_13_1_display_2").css("display", "none");
    	
    	$(opener.document).find("#ro_13_2_display_1").css("display", "");
    	$(opener.document).find("#ro_13_2_display_2").css("display", "none");
    	
    	$(opener.document).find("#ro_13_3_display_1").css("display", "");
    	$(opener.document).find("#ro_13_3_display_2").css("display", "none");
		
		if (car_comp_id == "0056") {
				
			$(opener.document).find("#sel_a_b_1 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_2 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_3 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_4 option[value='48']").prop("selected", "selected");
			
			$(opener.document).find("#a_b_1").val("48");
			$(opener.document).find("#a_b_2").val("48");
			$(opener.document).find("#a_b_3").val("48");
			$(opener.document).find("#a_b_4").val("48");					
			
			$(opener.document).find("#sel_a_b_1 option[value='48']").prop("disabled", false);
			//$(opener.document).find("#sel_a_b_1 option[value='60']").prop("disabled", true);		// �׽��� ���� �뿩 �Ⱓ ���� ����. �Ϲ� ������ ����. 2021.02.15.
			//$(opener.document).find("#sel_a_b_1 option[value='directInput']").prop("disabled", true);					
			$(opener.document).find("#sel_a_b_2 option[value='48']").prop("disabled", false);
			//$(opener.document).find("#sel_a_b_2 option[value='60']").prop("disabled", true);		// �׽��� ���� �뿩 �Ⱓ ���� ����. �Ϲ� ������ ����. 2021.02.15.
			//$(opener.document).find("#sel_a_b_2 option[value='directInput']").prop("disabled", true);					
			$(opener.document).find("#sel_a_b_3 option[value='48']").prop("disabled", false);
			//$(opener.document).find("#sel_a_b_3 option[value='60']").prop("disabled", true);		// �׽��� ���� �뿩 �Ⱓ ���� ����. �Ϲ� ������ ����. 2021.02.15.
			//$(opener.document).find("#sel_a_b_3 option[value='directInput']").prop("disabled", true);					
			$(opener.document).find("#sel_a_b_4 option[value='48']").prop("disabled", false);
			//$(opener.document).find("#sel_a_b_4 option[value='60']").prop("disabled", true);		// �׽��� ���� �뿩 �Ⱓ ���� ����. �Ϲ� ������ ����. 2021.02.15.
			//$(opener.document).find("#sel_a_b_4 option[value='directInput']").prop("disabled", true);
			
			//�뿩�Ⱓ input
			// �׽��� ���� �뿩 �Ⱓ ���� ����. �Ϲ� ������ ����. 2021.02.15.
			//$(opener.document).find("#a_b_1").attr("readonly", true);
			//$(opener.document).find("#a_b_2").attr("readonly", true);
			//$(opener.document).find("#a_b_3").attr("readonly", true);
			//$(opener.document).find("#a_b_4").attr("readonly", true);
			
			//����Ÿ� selectbox
			/* $(opener.document).find("#sel_agree_dist_1 option[value='35000']").hide();
			$(opener.document).find("#sel_agree_dist_1 option[value='40000']").hide();
			$(opener.document).find("#sel_agree_dist_1 option[value='45000']").hide();
			$(opener.document).find("#sel_agree_dist_1 option[value='50000']").hide();
			$(opener.document).find("#sel_agree_dist_2 option[value='35000']").hide();
			$(opener.document).find("#sel_agree_dist_2 option[value='40000']").hide();
			$(opener.document).find("#sel_agree_dist_2 option[value='45000']").hide();
			$(opener.document).find("#sel_agree_dist_2 option[value='50000']").hide();
			$(opener.document).find("#sel_agree_dist_3 option[value='35000']").hide();
			$(opener.document).find("#sel_agree_dist_3 option[value='40000']").hide();
			$(opener.document).find("#sel_agree_dist_3 option[value='45000']").hide();
			$(opener.document).find("#sel_agree_dist_3 option[value='50000']").hide();
			$(opener.document).find("#sel_agree_dist_4 option[value='35000']").hide();
			$(opener.document).find("#sel_agree_dist_4 option[value='40000']").hide();
			$(opener.document).find("#sel_agree_dist_4 option[value='45000']").hide();
			$(opener.document).find("#sel_agree_dist_4 option[value='50000']").hide(); */
			
			/* $(opener.document).find("#sel_agree_dist_1 option[value='35000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_1 option[value='40000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_1 option[value='45000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_1 option[value='50000']").prop("disabled", true); */
			// $(opener.document).find("#sel_agree_dist_1 option[value='directInput']").prop("disabled", true); 	// �׽��� ���� �����������Ÿ� �����Է� ���(10000~30000) 2021.02.15.
			/* $(opener.document).find("#sel_agree_dist_2 option[value='35000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_2 option[value='40000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_2 option[value='45000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_2 option[value='50000']").prop("disabled", true); */
			// $(opener.document).find("#sel_agree_dist_2 option[value='directInput']").prop("disabled", true);		// �׽��� ���� �����������Ÿ� �����Է� ���(10000~30000) 2021.02.15.
			/* $(opener.document).find("#sel_agree_dist_3 option[value='35000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_3 option[value='40000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_3 option[value='45000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_3 option[value='50000']").prop("disabled", true); */
			// $(opener.document).find("#sel_agree_dist_3 option[value='directInput']").prop("disabled", true);		// �׽��� ���� �����������Ÿ� �����Է� ���(10000~30000) 2021.02.15.
			/* $(opener.document).find("#sel_agree_dist_4 option[value='35000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_4 option[value='40000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_4 option[value='45000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_4 option[value='50000']").prop("disabled", true); */
			// $(opener.document).find("#sel_agree_dist_4 option[value='directInput']").prop("disabled", true);		// �׽��� ���� �����������Ÿ� �����Է� ���(10000~30000) 2021.02.15.		
			
			//����Ÿ� input
			// �׽��� ���� �����������Ÿ� �����Է� ���(10000~30000) 2021.02.15.
			//$(opener.document).find("#agree_dist_1").attr("readonly", true);
			//$(opener.document).find("#agree_dist_2").attr("readonly", true);
			//$(opener.document).find("#agree_dist_3").attr("readonly", true);
			//$(opener.document).find("#agree_dist_4").attr("readonly", true);
			
			//�����ܰ� text
			$(opener.document).find("#ro_13_0_display_3").css("display", "");
			$(opener.document).find("#ro_13_1_display_3").css("display", "");
			$(opener.document).find("#ro_13_2_display_3").css("display", "");
			$(opener.document).find("#ro_13_3_display_3").css("display", "");				
			
		} else {
			
			//�뿩�Ⱓ selectbox
			$(opener.document).find("#sel_a_b_1 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_2 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_3 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_4 option[value='48']").prop("selected", "selected");
			
			$(opener.document).find("#a_b_1").val("48");
			$(opener.document).find("#a_b_2").val("48");
			$(opener.document).find("#a_b_3").val("48");
			$(opener.document).find("#a_b_4").val("48");
			
			$(opener.document).find("#sel_agree_dist_1 option[value='35000']").show();
			$(opener.document).find("#sel_agree_dist_1 option[value='40000']").show();
			$(opener.document).find("#sel_agree_dist_1 option[value='45000']").show();
			$(opener.document).find("#sel_agree_dist_1 option[value='50000']").show();
			$(opener.document).find("#sel_agree_dist_2 option[value='35000']").show();
			$(opener.document).find("#sel_agree_dist_2 option[value='40000']").show();
			$(opener.document).find("#sel_agree_dist_2 option[value='45000']").show();
			$(opener.document).find("#sel_agree_dist_2 option[value='50000']").show();
			$(opener.document).find("#sel_agree_dist_3 option[value='35000']").show();
			$(opener.document).find("#sel_agree_dist_3 option[value='40000']").show();
			$(opener.document).find("#sel_agree_dist_3 option[value='45000']").show();
			$(opener.document).find("#sel_agree_dist_3 option[value='50000']").show();
			$(opener.document).find("#sel_agree_dist_4 option[value='35000']").show();
			$(opener.document).find("#sel_agree_dist_4 option[value='40000']").show();
			$(opener.document).find("#sel_agree_dist_4 option[value='45000']").show();
			$(opener.document).find("#sel_agree_dist_4 option[value='50000']").show();
			
			$(opener.document).find("#sel_a_b_1 option[value='48']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_1 option[value='60']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_1 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_2 option[value='48']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_2 option[value='60']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_2 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_3 option[value='48']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_3 option[value='60']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_3 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_4 option[value='48']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_4 option[value='60']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_4 option[value='directInput']").prop("disabled", false);
					
			
			//�뿩�Ⱓ input
			$(opener.document).find("#a_b_1").attr("readonly", false);
			$(opener.document).find("#a_b_2").attr("readonly", false);
			$(opener.document).find("#a_b_3").attr("readonly", false);
			$(opener.document).find("#a_b_4").attr("readonly", false);
			
			//����Ÿ� selectbox
			$(opener.document).find("#sel_agree_dist_1 option[value='35000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_1 option[value='40000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_1 option[value='45000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_1 option[value='50000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_1 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='35000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='40000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='45000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='50000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='35000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='40000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='45000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='50000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='35000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='40000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='45000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='50000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='directInput']").prop("disabled", false);
			
			//����Ÿ� input
			$(opener.document).find("#agree_dist_1").attr("readonly", false);
			$(opener.document).find("#agree_dist_2").attr("readonly", false);
			$(opener.document).find("#agree_dist_3").attr("readonly", false);
			$(opener.document).find("#agree_dist_4").attr("readonly", false);
			
			//�����ܰ� text
			$(opener.document).find("#ro_13_0_display_3").css("display", "none");
			$(opener.document).find("#ro_13_1_display_3").css("display", "none");
			$(opener.document).find("#ro_13_2_display_3").css("display", "none");
			$(opener.document).find("#ro_13_3_display_3").css("display", "none");
			
		}
		
		//������
		$(opener.document).find("#sel_rg_8_2").attr("disabled", false);
		$(opener.document).find("#rg_8_2").attr("disabled", false);
		$(opener.document).find("#rg_8_amt_2").attr("disabled", false);
		//������
		$(opener.document).find("#pp_per_2").attr("disabled", false);
		$(opener.document).find("#pp_amt_2").attr("disabled", false);
		//���ô뿩��
		$(opener.document).find("#g_10_2").attr("disabled", false);
		//��������
		$(opener.document).find("#gi_per_2").attr("disabled", false);
		$(opener.document).find("#gi_amt_2").attr("disabled", false);
		//��������
		$(opener.document).find("#sel_o_11_2").attr("disabled", false);
		$(opener.document).find("#o_11_2").attr("disabled", false);
		//�뿩��DC
		$(opener.document).find("#fee_dc_per_2").attr("disabled", false);
		
		for (var i = 0; i <= 3; i++) {
			//�뿩��ǰ ���� �ϰ� ó��
			fm.a_a[i].options[1].selected = true;
			
			//���Կɼ� ���� �ϰ� ó��
			fm.opt_chk[i].options[1].selected = true;
			fm.opt_chk[i].disabled = false;
			
			//�뿩��ǰ ��Ȱ��ȭ ���� �ϰ�ó��
			for (var j = 0; j <= 4; j++) {
				fm.a_a[i].options[j].disabled = false;
			}
			
			//���Կɼ�
			for (var z = 0; z <= 1; z++) {
				fm.opt_chk[i].options[z].disabled = false;
			}
		}
		
		fm.ins_per[0].options[0].selected = true;	
		fm.ins_per[1].options[0].selected = true;	
		fm.ins_per[2].options[0].selected = true;	
		fm.ins_per[3].options[0].selected = true;			
		
		fm.jg_f.value = jg_f*100;
		fm.jg_g.value = jg_g*100;
		//20120901���� ���������� �ִ�3% �̳����� ���ð��� - ����Ʈ 0%
		fm.jg_f.value = 0;
		fm.jg_g.value = 0;
		//����������
		fm.jg_w.value = jg_w;
		if(jg_w == '1'){
			fm.car_ja[0].value = '500,000';
			fm.car_ja[1].value = '500,000';
			fm.car_ja[2].value = '500,000';
			fm.car_ja[3].value = '500,000';
		}else{
			fm.car_ja[0].value = '300,000';
			fm.car_ja[1].value = '300,000';
			fm.car_ja[2].value = '300,000';
			fm.car_ja[3].value = '300,000';			
		}
		
		//���ᱸ��
		fm.jg_b.value = jg_b;
		
		//ǥ�ؾ�������Ÿ�
		var b_agree_dist = 30000;
		
		if(<%=rent_dt%> >= 20220415){
			b_agree_dist = 23000;
		}
		
		//���� +5000
		if(jg_b=='1')		b_agree_dist = b_agree_dist + 5000;				
		//LPG���� +10000 -> 20190418 +5000
		if(jg_b=='2')				b_agree_dist = b_agree_dist + 5000;
		fm.b_agree_dist[0].value = parseDecimal(b_agree_dist);
		fm.b_agree_dist[1].value = parseDecimal(b_agree_dist);
		fm.b_agree_dist[2].value = parseDecimal(b_agree_dist);
		fm.b_agree_dist[3].value = parseDecimal(b_agree_dist);
		//�����������Ÿ�
		var agree_dist = b_agree_dist;	
		/* if (car_comp_id == "0056") { // �׽���� 20000 ����
			agree_dist = 20000;
		} */
		fm.agree_dist[0].value = parseDecimal(agree_dist);
		fm.agree_dist[1].value = parseDecimal(agree_dist);
		fm.agree_dist[2].value = parseDecimal(agree_dist);
		fm.agree_dist[3].value = parseDecimal(agree_dist);
		//�����������Ÿ� ����Ʈ�ڽ� ����(2018.03.12)
		if(agree_dist==10000){			$(opener.document).find(".sel_a_dist").val("10000").attr("selected", "selected");	}
		else if(agree_dist==15000){		$(opener.document).find(".sel_a_dist").val("15000").attr("selected", "selected");	}
		else if(agree_dist==20000){		$(opener.document).find(".sel_a_dist").val("20000").attr("selected", "selected");	}
		else if(agree_dist==25000){		$(opener.document).find(".sel_a_dist").val("25000").attr("selected", "selected");	}
		else if(agree_dist==30000){		$(opener.document).find(".sel_a_dist").val("30000").attr("selected", "selected");	}
		else if(agree_dist==35000){		$(opener.document).find(".sel_a_dist").val("35000").attr("selected", "selected");	}
		else if(agree_dist==40000){		$(opener.document).find(".sel_a_dist").val("40000").attr("selected", "selected");	}
		else if(agree_dist==45000){		$(opener.document).find(".sel_a_dist").val("45000").attr("selected", "selected");	}
		else if(agree_dist==50000){		$(opener.document).find(".sel_a_dist").val("50000").attr("selected", "selected");	}
		else if(agree_dist==23000){		$(opener.document).find(".sel_a_dist").val("23000").attr("selected", "selected");	}
		else if(agree_dist==28000){		$(opener.document).find(".sel_a_dist").val("28000").attr("selected", "selected");	}
		
		//��Ʈ,���������
		fm.jg_h.value = jg_h;
		fm.jg_i.value = jg_i;
		fm.jg_tuix_st.value = jg_tuix_st;
		fm.jg_tuix_opt_st.value = '';
		//������Ż ������
		fm.lkas_yn.value = lkas_yn;
		fm.lkas_yn_opt_st.value = '';
		//������Ż �����
		fm.ldws_yn.value = ldws_yn;
		fm.ldws_yn_opt_st.value = '';
		//������� ������
		fm.aeb_yn.value = aeb_yn;
		fm.aeb_yn_opt_st.value = '';
		//������� �����
		fm.fcw_yn.value = fcw_yn;
		fm.fcw_yn_opt_st.value = '';
		
		fm.garnish_yn.value = garnish_yn;		// ���Ͻ� (�ɼ�)
		fm.garnish_yn_opt_st.value = '';		// ���Ͻ� (�ɼ�)

		fm.hook_yn.value = hook_yn;		// ���ΰ� (�ɼ�)
		fm.hook_yn_opt_st.value = '';		// ���ΰ� (�ɼ�)
		
		// �������� - ����
		var car_etc_ment = "";
		// 1�� Ź�� �� TP �Ұ� ����(100% �ε� Ź�� ����)
		var first_tp_code = [
			"6014711", "6014712", "7014311", "7014312", "7014313", "7014314", "8014311", "8014312",
			"9014311", "9014312", "9014313", "9014314", "9015433", "9015436", "9025433", "9025437", "9025439",
			"6024413", "6024414", "6024415", "7024413", "7024414"
		];
		// ������ �ƹ� ǥ�⵵ ���� �ʴ� ����(�����->������ �ε�� �ٷ� �ε��ϴ� ����).
		var empty_etc_code = [
			"9017311", "9017312", "9017313", "9017314", "9017315", "9018111", "9018112"
		];
		
		if(first_tp_code.indexOf(jg_code) > -1){
			car_etc_ment = "1�� Ź��(����� �� ��� �����μ���)�� ���� Ư������ ���� TP(TransPorter) Ź���� �Ұ��Ͽ� �ε�(Road)�� Ź�۵Ǹ� Ź�۰Ÿ���ŭ ����Ÿ��� �߻��˴ϴ�.";
		} else if(empty_etc_code.indexOf(jg_code) > -1){
			car_etc_ment = "";
		} else if(Number(jg_code) > 9000000 && Number(jg_code) < 9900000){
			car_etc_ment = "1�� Ź��(����� �� ��� �����μ���)�� ���� Ư������ ���� TP(TransPorter) Ź���� �Ұ��� �� ������ �ε�(Road) Ź�۽� Ź�۰Ÿ���ŭ ����Ÿ��� �߻��˴ϴ�.";
		}
		
		if(car_etc != ''){
			fm.car_etc.value = car_etc + "\n" + car_etc_ment;
		} else {
			fm.car_etc.value = car_etc_ment;
		}
		fm.car_etc2.value = car_etc2;
		
		
		var etc_jg_code_match = false;
		var etc_jg_code = [
			"2179", 
   			"4115", "4116", "4117", "4149", "4150", "4160", 
   			"4264", "4265", 
   			"5155", "5156", "5171", "5172", "5173", 
   			"5229", "5230", "5271", "5272", "5273", "5274", 
   			"5351", "5352",
   			"6134", "6135", "6136", "6137", "6161", "6162", "6163", 
   			"6255", "6256", "6271", "6272",
   			
   			"2013714", 
   			"4012621", "4012622", "4012623", "4016311", "4016312", "4016313", 
   			"4024121", "4024122", 
   			"5018411", "5018412", "6018111", "6018112", "6018113", 
   			"5026111", "5026112", "6022411", "6022412", "6022413", "6022414", 
   			"3053511", "3053512",
   			"6016111", "6016112", "6016113", "6016114", "6018116", "6018117", "6018118", 
   			"6024411", "6024412", "6022416", "6022417"
		];
		
		for (var j = 0; j < etc_jg_code.length; j++) {
			if (etc_jg_code[j] == jg_code) {
				etc_jg_code_match = true;
			}
		}
		
		//20201020 ���Ҽ�ȯ������ ������������� ǥ��� ����ʿ� ���� �Ʒ� ������ ���Ҽ�ȯ������ ǥ�⿩�� �ӽ� �ּ�ó��
		/* if (jg_w == "1" || (jg_g_7 == "1" || jg_g_7 == "2") || etc_jg_code_match == true) {
			$(opener.document).find("#info_st option[value='']").prop("disabled", false);			
			$(opener.document).find("#info_st option[value='N']").prop("disabled", true);
			
			$(opener.document).find("#info_st").val("").attr("selected", "selected");
		} else {
			if (jg_3 > 0) {
				$(opener.document).find("#info_st option[value='']").prop("disabled", false);
				$(opener.document).find("#info_st option[value='N']").prop("disabled", false);
				
				$(opener.document).find("#info_st").val("N").attr("selected", "selected");
			} else {
				$(opener.document).find("#info_st option[value='']").prop("disabled", true);
				$(opener.document).find("#info_st option[value='N']").prop("disabled", false);
				
				$(opener.document).find("#info_st").val("N").attr("selected", "selected");
			}
		} */
		
		opener.setO11();
		opener.SetComEmpYn();
		<%}else if(idx.equals("2")){%>
		var fm1 = document.form1;
		var flag = false;
		var flag2 = false;
		
		for(var i=0; i<fm1.elements.length; i++){
			var ck = fm1.elements[i];
			if(ck.name == "car_s_seq"){
				var ck_value = ck.value;
				if(ck_value.indexOf('�ʼ�����') > 0) flag = true;
			}
		}
		if(nm.indexOf('�ʼ�����') > 0) flag2 = true;
		if( flag && !flag2 ){
			alert('�ʼ� �ɼ��� �����ϼ���.');
			return;
		}
		
		fm.opt.value = nm;
		fm.opt_seq.value = id;
		fm.opt_amt.value = parseDecimal(amt);	
		if (jg_opt_yn == "N") {
			fm.opt_amt_m.value = parseDecimal(amt);	
		} else {
			fm.opt_amt_m.value = "0";
		}
		fm.jg_opt_st.value = jg_opt_st;
		fm.jg_tuix_opt_st.value = jg_tuix_st;
		fm.lkas_yn_opt_st.value = lkas_yn;//������Ż ������
		fm.ldws_yn_opt_st.value = ldws_yn;//������Ż �����
		fm.aeb_yn_opt_st.value = aeb_yn;//������� ������
		fm.fcw_yn_opt_st.value = fcw_yn;//������� �����	
		fm.garnish_yn_opt_st.value = garnish_yn;		// ���Ͻ� (�ɼ�)
		fm.hook_yn_opt_st.value = hook_yn;		// ���Ͻ� (�ɼ�)
		opener.setO11();
		opener.SetComEmpYn();
		<%}else if(idx.equals("3")){%>
		<%}else if(idx.equals("4")){%>
		fm.dc.value = nm;
		fm.dc_seq.value = id;
		fm.dc_amt.value = parseDecimal(amt);
		<%}else if(idx.equals("5")){%>
		fm.conti_rat.value = nm;
		fm.conti_rat_seq.value = seq;
		<%}%>
		fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));
		
		self.close();
		
		
		opener.location.href="javascript:setEst_yn(1)";
	}
	
	function setDcCode(car_b_dt, car_d, car_d_seq, car_d_per, car_d_p, ls_yn, car_d_per2, car_d_p2, car_d_per_b, car_d_per_b2, esti_d_etc){
		var fm = opener.document.form1;				
		var dc_amt 		= 0;
		var dc_amt2 	= 0;
		var car_price 	= toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)); // - toInt(parseDigit(fm.tax_dc_amt.value)) 20191002 ���Ҽ������ �̹ݿ� ������������ ��.
		
		//dc��
		dc_amt 		= (car_price*car_d_per/100);
		
		//dc�ݾ�
		if(car_d_p>0){
			dc_amt 	= dc_amt+car_d_p;
		}
		
		if(car_d_per_b == '2'){
			//dc��
			dc_amt 	= ((car_price-car_d_p)*car_d_per/100)+car_d_p;
		}
		
		if(ls_yn == 'Y'){
			//dc��
			dc_amt2 = (car_price*car_d_per2/100);
			//dc�ݾ�
			if(car_d_p2>0){
				dc_amt2 	= dc_amt2+car_d_p2;
			}
			if(car_d_per_b2 == '2'){
				dc_amt2 = ((car_price-car_d_p2)*car_d_per2/100)+car_d_p2;
			}
		}
		
		fm.dc.value 		= '';
		fm.dc_seq.value 	= car_b_dt+''+car_d_seq;
		fm.dc_amt.value 	= parseDecimal(dc_amt);
		fm.dc_amt2.value 	= parseDecimal(dc_amt2);
		fm.esti_d_etc.value = esti_d_etc;
		fm.ls_yn.value 		= ls_yn;		
		fm.o_1.value 			= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value))  - toInt(parseDigit(fm.tax_dc_amt.value)));
		fm.o_12.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt2.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));
		self.close();
	}	
	
	function save(){
		var ofm = opener.document.form1;
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var codes="";
		var amts=0;
		var amts_m=0;
		var opts="";	
		var jg_opt_sts= "";	
		var jg_tuix_sts= "";
		var lkas_yn_sts="";
		var ldws_yn_sts="";
		var aeb_yn_sts="";
		var fcw_yn_sts="";
		var jg_opt_yns= "";
		var garnish_yn_sts="";	// ���Ͻ� 
		var hook_yn_sts="";	// ���ΰ� �ɼ�
		var o_split;
		var flag = false;
		var flag2 = false;
		
		<%if(idx.equals("2")){%>
				
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			
			if(ck.name == "car_s_seq"){		
				var ck_value = ck.value;
				if(ck_value.indexOf('�ʼ�����') > 0) flag = true;
								
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes 	+= o_split[0];
					opts 	+= "["+o_split[1]+"]  ";
					amts 	+= toInt(o_split[2]);
					jg_opt_sts = o_split[3];
					jg_tuix_sts = o_split[4];
					lkas_yn_sts = o_split[5];
					ldws_yn_sts = o_split[6];
					aeb_yn_sts = o_split[7];
					fcw_yn_sts = o_split[8];
					jg_opt_yns = o_split[9];
					garnish_yn_sts = o_split[10];
					hook_yn_sts = o_split[11];
					
					if (jg_opt_yns == "N") {
						amts_m += toInt(o_split[2]);
					}
					
					//�����ܰ�
					if(jg_opt_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_opt_sts) jg_opt_sts ='';
						}
						if(jg_opt_sts != ''){
							if(ofm.jg_opt_st.value == ''){
								ofm.jg_opt_st.value = jg_opt_sts;	
							}else{
								ofm.jg_opt_st.value = ofm.jg_opt_st.value+'/'+jg_opt_sts;
							}
						}
					}
					//tuix/tuon �ɼǿ���
					if(jg_tuix_sts != ''){
						var o_split2;
						o_split2 = ofm.jg_tuix_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_tuix_sts) jg_tuix_sts ='';
						}
						if(jg_tuix_sts != ''){
							if(ofm.jg_tuix_opt_st.value == ''){
								ofm.jg_tuix_opt_st.value = jg_tuix_sts;	
							}else{
								ofm.jg_tuix_opt_st.value = ofm.jg_tuix_opt_st.value+'/'+jg_tuix_sts;
							}
						}
					}
					//������Ż ������ �ɼǿ���
					if(lkas_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.lkas_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==lkas_yn_sts) lkas_yn_sts ='';
						}
						if(lkas_yn_sts != ''){
							if(ofm.lkas_yn_opt_st.value == ''){
								ofm.lkas_yn_opt_st.value = lkas_yn_sts;	
							}else{
								ofm.lkas_yn_opt_st.value = ofm.lkas_yn_opt_st.value+'/'+lkas_yn_sts;
							}
						}
					}
					//������Ż ����� �ɼǿ���
					if(ldws_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.ldws_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==ldws_yn_sts) ldws_yn_sts ='';
						}
						if(ldws_yn_sts != ''){
							if(ofm.ldws_yn_opt_st.value == ''){
								ofm.ldws_yn_opt_st.value = ldws_yn_sts;	
							}else{
								ofm.ldws_yn_opt_st.value = ofm.ldws_yn_opt_st.value+'/'+ldws_yn_sts;
							}
						}
					}
					//������� ������ �ɼǿ���
					if(aeb_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.aeb_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==aeb_yn_sts) aeb_yn_sts ='';
						}
						if(aeb_yn_sts != ''){
							if(ofm.aeb_yn_opt_st.value == ''){
								ofm.aeb_yn_opt_st.value = aeb_yn_sts;	
							}else{
								ofm.aeb_yn_opt_st.value = ofm.aeb_yn_opt_st.value+'/'+aeb_yn_sts;
							}
						}
					}
					//������� ����� �ɼǿ���
					if(fcw_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.fcw_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==fcw_yn_sts) fcw_yn_sts ='';
						}
						if(fcw_yn_sts != ''){
							if(ofm.fcw_yn_opt_st.value == ''){
								ofm.fcw_yn_opt_st.value = fcw_yn_sts;	
							}else{
								ofm.fcw_yn_opt_st.value = ofm.fcw_yn_opt_st.value+'/'+fcw_yn_sts;
							}
						}
					}		
					//���Ͻ� �ɼǿ���
					if(garnish_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.garnish_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==garnish_yn_sts) garnish_yn_sts ='';
						}
						if(garnish_yn_sts != ''){
							if(ofm.garnish_yn_opt_st.value == ''){
								ofm.garnish_yn_opt_st.value = garnish_yn_sts;	
							}else{
								ofm.garnish_yn_opt_st.value = ofm.garnish_yn_opt_st.value+'/'+garnish_yn_sts;
							}
						}
					}
					//���ΰ� �ɼǿ���
					if(hook_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.hook_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==hook_yn_sts) hook_yn_sts ='';
						}
						if(hook_yn_sts != ''){
							if(ofm.hook_yn_opt_st.value == ''){
								ofm.hook_yn_opt_st.value = hook_yn_sts;	
							}else{
								ofm.hook_yn_opt_st.value = ofm.hook_yn_opt_st.value+'/'+hook_yn_sts;
							}
						}
					}
					
					if(ck_value.indexOf('�ʼ�����') > 0) flag2 = true;
				}
			}
		}
		
		if( flag && !flag2 ){
			alert('�ʼ� �ɼ��� �����ϼ���.');
			return;
		}
		
		if(fm.dir_nm.value == ''){
		
			if(cnt == 0){
		 		alert("���û���� �����ϼ���.");
				return;
			}
		}else{
			opts 	+= "["+fm.dir_nm.value+"]  ";
			amts 	+= toInt(parseDigit(fm.dir_amt.value));	
		
		}
				
		ofm.opt.value = opts;
		ofm.opt_seq.value = codes;
		ofm.opt_amt.value = parseDecimal(amts);	
		ofm.opt_amt_m.value = parseDecimal(amts_m);	
		
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));		
		

		
		<%}else if(idx.equals("3")){%>
				
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_s_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes 	+= o_split[0];
					opts 	+= o_split[1];
					amts 	+= toInt(o_split[2]);		
					jg_opt_sts = o_split[3];
					
					//�����ܰ�
					if(jg_opt_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_col_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_opt_sts) jg_opt_sts ='';
						}
						if(jg_opt_sts != ''){
							if(ofm.jg_col_st.value == ''){
								ofm.jg_col_st.value = jg_opt_sts;	
							}else{
								ofm.jg_col_st.value = ofm.jg_col_st.value+'/'+jg_opt_sts;
							}
						}
					}
					
				}
			}
		}
				

		if(cnt == 0){
		 	alert("��������� �����ϼ���.");
			return;
		}
				
		ofm.col.value = opts;
		ofm.col_seq.value = codes;
		ofm.col_amt.value = parseDecimal(amts);
		
		
		
				
		codes="";
		amts=0;	
		opts="";
		jg_opt_sts="";	
		
		codes2="";
		amts2=0;	
		opts2="";
		jg_opt_sts2="";	
		
		o_split;
		
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_in_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes 	+= o_split[0];
					opts 	+= o_split[1];
					amts 	+= toInt(o_split[2]);
					jg_opt_sts = o_split[3];					
					
					//�����ܰ�
					if(jg_opt_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_col_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_opt_sts) jg_opt_sts ='';
						}
						if(jg_opt_sts != ''){
							if(ofm.jg_col_st.value == ''){
								ofm.jg_col_st.value = jg_opt_sts;	
							}else{
								ofm.jg_col_st.value = ofm.jg_col_st.value+'/'+jg_opt_sts;
							}
						}
					}
						
				}
			}
		}
		
		for(var z=0 ; z<len ; z++){
			var ck=fm.elements[z];		
			if(ck.name == "car_gar_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes2 	+= o_split[0];
					opts2 	+= o_split[1];
					amts2 	+= toInt(o_split[2]);
					jg_opt_sts2 = o_split[3];					
					
					//�����ܰ�
					if(jg_opt_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_col_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_opt_sts) jg_opt_sts ='';
						}
						if(jg_opt_sts != ''){
							if(ofm.jg_col_st.value == ''){
								ofm.jg_col_st.value = jg_opt_sts;	
							}else{
								ofm.jg_col_st.value = ofm.jg_col_st.value+'/'+jg_opt_sts;
							}
						}
					}
						
				}
			}
		}
		
		ofm.in_col.value = opts;
		ofm.garnish_col.value = opts2;
		
		ofm.col_amt.value = parseDecimal(toInt(parseDigit(ofm.col_amt.value)) + amts + amts2);				
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));				
		
		<%}%>
		
		
		
		self.close();
	}
	

	function setOptSum(){
		var ofm = opener.document.form1;
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var amts=0;	
		var o_split;
		<%if(idx.equals("2")){%>
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_s_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					amts 	+= toInt(o_split[2]);	
				}
			}
		}
		tr_opt_sum.style.display='';
		fm.v_opt_amt.value = parseDecimal(amts);
		fm.v_car_amt.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)));
		//fm.v_o_1.value = parseDecimal(toInt(parseDigit(fm.v_car_amt.value)) + toInt(parseDigit(fm.v_opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));		
		fm.v_o_1.value = parseDecimal(toInt(parseDigit(fm.v_car_amt.value)) + toInt(parseDigit(fm.v_opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)));		
		//���Ҽ� ������� �ִ� ��� ���Ҽ� ������ ������/ ���°�� ����
		if (toInt(parseDigit(ofm.tax_dc_amt.value)) == 0) {
			$("#tax_amt_text").css("display", "none");
		} else {
			$("#tax_amt_text").css("display", "");
		}
		
		<%}%>
	}
	
	//��纸�� ��ư(2018.01.18)
	function view_spec(car_id, car_seq){
		var car_comp_id = '<%=car_comp_id%>';
		var code = '<%=car_cd%>';
		//var car_id = $("#car_id").val();
		var valus = "?car_comp_id="+car_comp_id+"&code="+code+"&car_id="+car_id+"&car_seq="+car_seq;
		window.open("esti_mng_view_opt.jsp"+valus,"car_b_inc", "left=300, top=100, width=1000, height=600, scrollbars=yes");
	}
	
	//tuix/tuon �ɼ� ��ġ��/����
	function tuix_click() {				
		var plain_txt = $("#tuix").text().trim();
		
		if (plain_txt == "TUIX/TUON �ɼ� ����") {			
			$(".hide").css("display", "");
			$("#tuix").text("TUIX/TUON �ɼ� ����");
		} else {
			$(".hide").css("display", "none");
			$("#tuix").text("TUIX/TUON �ɼ� ����");
		}
	}
	
	//20200313 ���� �Ϸ�Ʈ��, ���� EV, ��3 ��ü����. �� �ܿ��� ����, �뱸�� ���ð���
	// 20210218. ������ ���ּ��� ����EV, ����EV�� ���︸, �� �� ��ü ���� �����ϵ��� ����. 
	// 20210518. ���� ȭ���� �� ������ ��ü ���ּ��� ���� ����.
	function autoEcarLocationDisSel(jg_g_7, jg_code) {
		
		var opt_size = $(opener.document).find("#ecar_loc_st_1 option").size();
		
		if (jg_g_7 == "3") {
			
			// ��� ������ ���ּ��� �������������� ���� �׸� ��� �� �� 22.01.06
			$(opener.document).find("#ecar_loc_st_1 option[value='12']").css("display", 'none');
			$(opener.document).find("#ecar_loc_st_2 option[value='12']").css("display", 'none');
			$(opener.document).find("#ecar_loc_st_3 option[value='12']").css("display", 'none');
			$(opener.document).find("#ecar_loc_st_4 option[value='12']").css("display", 'none');
			
			if ( Number(jg_code) > 8000000 ){ // ����ȭ����
				
				// ����ȭ���� ���� �� ������ ���� ���� �׸� �̳���
				$(opener.document).find("#ecar_loc_st_1 option[value='13']").css("display", 'none');
				$(opener.document).find("#ecar_loc_st_2 option[value='13']").css("display", 'none');
				$(opener.document).find("#ecar_loc_st_3 option[value='13']").css("display", 'none');
				$(opener.document).find("#ecar_loc_st_4 option[value='13']").css("display", 'none');
				
				for (var i = 0; i < opt_size; i++) {
					var ecar_loc_st_idx_val = $(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").val();
					
					// ����ȭ���� �������� ����, ������ ���� ���� �� ��� ���ּ��� ���� ����. 20220106
					$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").css("background-color", "");
				}
				
			} else {		// ����ȭ���� �� ������(= ����¿���)
			
				// ����¿��� ���� �� ������ ���� ���� �׸� ����
				$(opener.document).find("#ecar_loc_st_1 option[value='13']").css("display", 'block');
				$(opener.document).find("#ecar_loc_st_2 option[value='13']").css("display", 'block');
				$(opener.document).find("#ecar_loc_st_3 option[value='13']").css("display", 'block');
				$(opener.document).find("#ecar_loc_st_4 option[value='13']").css("display", 'block');
				
				// ����¿��� ��� ������ ���ּ��� ����
				for (var i=0; i < opt_size; i++) {
					var ecar_loc_st_idx_val = $(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").val();
					
// 						$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").prop("disabled", true);
// 						$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").css("background-color", "#E5E5E5");
						
// 						$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").prop("disabled", true);
// 						$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").css("background-color", "#E5E5E5");
						
// 						$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").prop("disabled", true);
// 						$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").css("background-color", "#E5E5E5");
						
// 						$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").prop("disabled", true);
// 						$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").css("background-color", "#E5E5E5");

					$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").css("background-color", "");
				}
			}
		} else {
			for (var i=0; i < opt_size; i++) {
				$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").prop("disabled", false);
				$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").css("background-color", "");
				
				$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").prop("disabled", false);
				$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").css("background-color", "");
				
				$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").prop("disabled", false);
				$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").css("background-color", "");
				
				$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").prop("disabled", false);
				$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").css("background-color", "");
			}
		}
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='size' value='<%=size%>'>
<input type='hidden' name='jg_g_7' value='<%=jg_g_7%>'>
<input type='hidden' name='print_type' value='<%=print_type%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5><%if(idx.equals("1")){%>����<%}else if(idx.equals("2")){%>�ɼ�<%}else if(idx.equals("3")){%>����<%}else if(idx.equals("4")){%>������DC<%}else if(idx.equals("5")){%>����<%}%></span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <% if(idx.equals("5")){%>
    <tr>
    	<td></td>
    </tr>
    <tr>
    	<td style="text-align:right;">
    		�� <span style="font-weight:bold;color:#ee1f46;">���� �̼��� ����</span>: ���� ���ýÿ��� �������� ������� ������ �߰��˴ϴ�</br>
    		�� Ÿ�̾� <span style="font-weight:bold;color:#ee1f46;">�� ������</span>�� ���� ���� ���̳�<span style="font-weight:bold;color:#ee1f46;">(�ɼǼ��ý� ���� ���)</span>
    	</td>
    </tr>
    <%} %>
    <tr> 
        <td class=h></td>
    </tr>
    <!--�������-->
    <%if(idx.equals("3")){%>
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>    
    <%}%>    
    <tr> 
        <td class=line2></td>
    </tr>
    <%if(idx.equals("4")){//������DC%>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=5%>����</td>
                    <td class="title" width=30%>D/C����</td>					
                    <td class="title" width=20%>�ݾ�</td>
                    <td class="title" width=30%>���</td>
                    <td class="title" width=15%>��������</td>
                </tr>
                <%for(int i = 0 ; i < size ; i++){
    			Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center"><%=i+1%></td>
		    		<td align="center"><%=var.get("CAR_D")%></td>					
                    <td>&nbsp;
			<a href="javascript:setDcCode('<%=var.get("CAR_B_DT")%>', '<%=var.get("CAR_D")%>', '<%=var.get("CAR_D_SEQ")%>', <%=var.get("CAR_D_PER")%>, <%=var.get("CAR_D_P")%>, '<%=var.get("LS_YN")%>', <%=var.get("CAR_D_PER2")%>, <%=var.get("CAR_D_P2")%>, '<%=var.get("CAR_D_PER_B")%>', '<%=var.get("CAR_D_PER_B2")%>', '<%=var.get("ESTI_D_ETC")%>');">
			<%if(String.valueOf(var.get("LS_YN")).equals("Y")){%>
			    [��Ʈ]<%=var.get("CAR_D_PER")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P")))%>��
			    &nbsp;
			    [����DC]<%=var.get("CAR_D_PER2")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P2")))%>��
			<%}else{%>
			    <%if(String.valueOf(var.get("CAR_D_PER")).equals("0") && !String.valueOf(var.get("CAR_D_P")).equals("0")){%>
				<%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P")))%>��
			    <%}else if(!String.valueOf(var.get("CAR_D_PER")).equals("0") && String.valueOf(var.get("CAR_D_P")).equals("0")){%>
				<%=var.get("CAR_D_PER")%>%
			    <%}else if(!String.valueOf(var.get("CAR_D_PER")).equals("0") && !String.valueOf(var.get("CAR_D_P")).equals("0")){%>						  
				<%=var.get("CAR_D_PER")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P")))%>��
			    <%}else{%>					
				0��
			    <%}%>						  						  
			<%}%>
		        </a>
		    </td>
		    <td><pre style="white-space: pre-wrap; padding: 5px 10px;"><%=var.get("CAR_D_ETC")%></pre></td>					
		    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(var.get("CAR_D_DT")))%>
			<%if(!String.valueOf(var.get("CAR_D_DT2")).equals("")){%><br>~ <%=AddUtil.ChangeDate2(String.valueOf(var.get("CAR_D_DT2")))%><%}%>
		    </td>
                </tr>
                <%}%>
                		
            </table>
        </td>
    </tr>	
    <%}else if(idx.equals("5")){ //���� %>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr> 
                    <td class="title" width=10%>����</td>
                    <td class="title" width=25%>����</td>					
                    <td class="title" width=35%>���տ���</td>
                    <td class="title" width=30%>���</td>
                </tr>
                 <%for(int i = 0 ; i < size ; i++){
    			Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td><%=var.get("ENGINE")%></td>
                    <td><a href="javascript:setCode('<%=var.get("CAR_CD")%>','<%=var.get("CAR_K_SEQ")%>','<%=var.get("CAR_K")%>','','','','','','','','','','','','','','','','','','','','','','','','')"><%=var.get("CAR_K")%></a></td>
                    <td><%=var.get("CAR_K_ETC")%></td>
                </tr>
                <%} %>
            </table>
        </td>
    </tr>    
    <%}else{%>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=5%><%if(idx.equals("2") || idx.equals("3")) {%>���� <%}else{%>���� <%}%></td>
                    <td class="title" width=34%>����</td>
		    <%if(idx.equals("1")){%>
					<td class="title" width=5%>����</td>										
					<td class="title" width=13%>�ݾ�</td>
					<%if (duty_free_count > 0 && duty_free_count2 > 0) {%>
					<td class="title" width=13%>�鼼����</td>
					<%}%>					
					<td class="title" width=12%>��������</td>	
			<%}else if(idx.equals("3")){%>	
					<td class="title" width=10%>�����̹���</td>
					<td class="title" width=10%>�ݾ�</td>											
		    <%}else{%>
					<td class="title" width=20%>�ݾ�</td>					
		    <%}%>
					<td class="title" width=41%>���</td>			
                </tr>
            
            
            
            
            <%if (idx.equals("2")) {%>
	            <%for (int i = 0 ; i < size ; i++) {
						Hashtable var = (Hashtable)vars.elementAt(i);
						
						if (String.valueOf(var.get("JG_TUIX_ST")).equals("Y")) {
							tuix_count++;
						}
	   			%>
		   			<%if (String.valueOf(var.get("JG_TUIX_ST")).equals("")) {%>
		   			<tr>
	   					<td align="center">
	   						<input type="checkbox" name="car_s_seq" onClick="javascript:setOptSum();" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("JG_OPT_YN")%>||<%=var.get("GARNISH_YN")%>||<%=var.get("HOOK_YN")%>'>
	   					</td>
	   					<td>&nbsp;
	   						<a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_CODE")%>', '<%=var.get("JG_F")%>', '<%=var.get("JG_G")%>', '<%=var.get("JG_3")%>', '<%=var.get("JG_W")%>', '<%=var.get("JG_H")%>', '<%=var.get("JG_I")%>', '<%=var.get("JG_B")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("ETC")%>', '<%=var.get("ETC2")%>', '<%=var.get("CAR_B_P2")%>', '<%=var.get("DUTY_FREE_OPT")%>', '<%=var.get("JG_OPT_YN")%>', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>');">
	   							<font <%if(var.get("IS_NECESSARY").equals("0") || var.get("IS_OPTIONAL").equals("0")){ %>color="red"<%} %>>
	   							<%=var.get("NM")%>
	   							</font>
	   						</a>
	   					</td>
	   					<td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>��</td>
	   					<td>&nbsp;<%=var.get("ETC")%>
				        <%if (AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20151013) {%>
					        <%if (!String.valueOf(var.get("JG_OPT_ST")).equals("") && (idx.equals("2")||idx.equals("3")) ) { //�ɼ�,����%>
					            <%if (!String.valueOf(var.get("ETC")).equals("")) {%>
					            <br>
					            <%}%>				            		            		            
				            	<%=e_db.getEstiJgOptVarJgOpt8(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
					            <br>
				            	<%=e_db.getEstiJgOptVarJgOpt9(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
					        <%}%>
				        <%}%>
			    		</td>
	   				</tr>
		   			<%}%>
				<%}%>
				
				<%if (tuix_count > 0) {%>
					<tr>
						<td colspan="4" style="height: 40px;">
							<div id="tuix" onclick="tuix_click();">
								TUIX/TUON �ɼ� ����
							</div>
						</td>
					</tr>
				<%}%>
					
	            <%for (int i = 0 ; i < size ; i++) {
						Hashtable var = (Hashtable)vars.elementAt(i);
	   			%>
		   			<%if (String.valueOf(var.get("JG_TUIX_ST")).equals("Y")) {%>
		   			<tr class="hide" style="display: none;">
	   					<td align="center">
	   						<input type="checkbox" name="car_s_seq" onClick="javascript:setOptSum();" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("JG_OPT_YN")%>||<%=var.get("GARNISH_YN")%>||<%=var.get("HOOK_YN")%>'>
	   					</td>
	   					<td>&nbsp;
	   						<a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_CODE")%>', '<%=var.get("JG_F")%>', '<%=var.get("JG_G")%>', '<%=var.get("JG_3")%>', '<%=var.get("JG_W")%>', '<%=var.get("JG_H")%>', '<%=var.get("JG_I")%>', '<%=var.get("JG_B")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("ETC")%>', '<%=var.get("ETC2")%>', '<%=var.get("CAR_B_P2")%>', '<%=var.get("DUTY_FREE_OPT")%>', '<%=var.get("JG_OPT_YN")%>', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>');"><%=var.get("NM")%></a>
	   					</td>
	   					<td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>��</td>
	   					<td>&nbsp;<%=var.get("ETC")%>
				        <%if (AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20151013) {%>
					        <%if (!String.valueOf(var.get("JG_OPT_ST")).equals("") && (idx.equals("2")||idx.equals("3")) ) { //�ɼ�,����%>
					            <%if (!String.valueOf(var.get("ETC")).equals("")) {%>
					            <br>
					            <%}%>				            		            		            
				            	<%=e_db.getEstiJgOptVarJgOpt8(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
					            <br>
				            	<%=e_db.getEstiJgOptVarJgOpt9(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
					        <%}%>
				        <%}%>
			    		</td>
	   				</tr>
		   			<%}%>
				<%}%>
            <%} else {%>
	            <%for (int i = 0 ; i < size ; i++) {
						Hashtable var = (Hashtable)vars.elementAt(i);
	   			%>
	   			<tr>
	   				<td align="center">
   					<%if (idx.equals("3")) {%>
                        <input type="radio" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("HOOK_YN")%>'>
                    <%} else {%>
                        <%=i+1%>
                    <%}%>
	   				</td>
	   				<td>&nbsp;
                    <%if (idx.equals("3")) {%>
                        <%=var.get("NM")%>
                    <%} else if(idx.equals("1")) {%>
                       	<table style="margin-top: -15px;">
                       		<tr>
                       			<td width="85%"><a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_CODE")%>', '<%=var.get("JG_F")%>', '<%=var.get("JG_G")%>', '<%=var.get("JG_3")%>', '<%=var.get("JG_W")%>', '<%=var.get("JG_H")%>', '<%=var.get("JG_I")%>', '<%=var.get("JG_B")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("ETC")%>', '<%=var.get("ETC2")%>', '<%=var.get("CAR_B_P2")%>', '<%=var.get("DUTY_FREE_OPT")%>', '', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>', '<%=var.get("JG_G_15")%>');"><%=var.get("NM")%></a></td>
                       			<td><input type="button" class="button" value="���" onclick="javascript:view_spec('<%=var.get("ID")%>', '<%=var.get("SEQ")%>');"></td>
                       		</tr>
                       	</table>
                   	<%} else {%>
                        <a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_CODE")%>', '<%=var.get("JG_F")%>', '<%=var.get("JG_G")%>', '<%=var.get("JG_3")%>', '<%=var.get("JG_W")%>', '<%=var.get("JG_H")%>', '<%=var.get("JG_I")%>', '<%=var.get("JG_B")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("ETC")%>', '<%=var.get("ETC2")%>', '<%=var.get("CAR_B_P2")%>', '<%=var.get("DUTY_FREE_OPT")%>', '', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>');"><%=var.get("NM")%></a>
                   	<%}%>
                    </td>
                    
                    <%if (idx.equals("1")) {%>
					<td align="center"><%=var.get("CAR_Y_FORM")%></td>
					<%} else if(idx.equals("3")) {%>
					<td align=center>
						<%//�����̹��� ���
							String content_code = "CAR_COL";
							String content_seq  = car_comp_id+"^"+car_cd+"^"+var.get("CAR_U_SEQ")+"^"+var.get("CAR_C_SEQ");
			              	
							Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
							int attach_vt_size = attach_vt.size();	
			                  
							if (attach_vt_size > 0) {
								for (int j = 0 ; j < attach_vt_size ; j++) {
									Hashtable ht = (Hashtable)attach_vt.elementAt(j);%> 
									<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="60" height="20"> 
							<%}
							} else {%> 
							����
						<%}%>
					</td>
					<%}%>
					<td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>��</td>		
		    	<%if (idx.equals("1")) {%>
			    
		    		<%if (duty_free_count > 0 && duty_free_count2 > 0) {%>
			        <td align="right">
			        	<%if (var.get("DUTY_FREE_OPT").equals("0")) {%>		        	
				        	<%if (car_comp_id.equals("0001")) {%>
			        				<%=AddUtil.parseDecimal(String.valueOf(var.get("HYUNDAI_DUTY_FREE_AMT")))%>��
				        	<%} else {%>
						        	<%=AddUtil.parseDecimal(String.valueOf(var.get("DUTY_FREE_AMT")))%>��
				        	<%}%>
			        	<%} else {%>
			        			<%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>��
			        	<%}%>
	        		</td>
        			<%}%>
	        		
		    	<%}%>
			    
			    <%if(idx.equals("1")){%>
			        <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(var.get("B_DT")))%></td>						
			    <%}%>
		    		<td>&nbsp;<%=var.get("ETC")%>
			        <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20151013){%>
				        <%if(!String.valueOf(var.get("JG_OPT_ST")).equals("") && (idx.equals("2")||idx.equals("3")) ){ //�ɼ�,����%>
				            <%if(!String.valueOf(var.get("ETC")).equals("")){%><br><%}%>		            		            
				            	<%=e_db.getEstiJgOptVarJgOpt8(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
				            <br>
				            	<%=e_db.getEstiJgOptVarJgOpt9(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
				        <%}%>
			        <%}%>
		    		</td>
	   			</tr>
				<%}%>
   			<%}%>
              
              
              
              
              <%if(idx.equals("2") || idx.equals("3")){%>
                <tr> 
                    <td class="title" style="height: 40px;">-</td>
                    <td >&nbsp;                
                            <%if(idx.equals("2")){%>
                            <input type="text" name="dir_nm" value="" size="30" class=text>
                            <%}else{%>
                            ����
                            <input type="text" name="dir_nm" value="" size="15" class=text>
                            ����
                            <input type="text" name="dir_nm2" value="" size="10" class=text>
                            <%}%>  
                            <a href="javascript:setCodeDir();">�����Է�</a>                          
                    </td>
                  <%if(idx.equals("3")){%>  
                  	<td>&nbsp; </td>
                  <%}%>
		    <td align=right><input type="text" name="dir_amt" value="" size="10" class=num>��</td>
		    <td >&nbsp; </td>
                </tr>                                                
                <%}%>                                	
            </table>
        </td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
    

    
	<!--�������-->
	<%if(idx.equals("3")){
		vars = e_db.getCarSubList("3_in", car_comp_id, car_cd, car_id, car_seq, a_a);
		size = vars.size();		
	%>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>    
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=5%>����</td>
                    <td class="title" width=34%>����</td>
                    <td class="title" width=20%>�ݾ�</td>					
		    		<td class="title" width=41%>���</td>			
                </tr>
                <%for(int i = 0 ; i < size ; i++){
    			Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center">
						<input type="radio" name="car_in_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>'>
                    </td>
                    <td>&nbsp;<%=var.get("NM")%></td>					
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>��</td>						
		    		<td>&nbsp;<%=var.get("ETC")%></td>
                </tr>
                <%}%>		
            </table>
        </td>
    </tr>    
	<%}%>
	
	<!--���Ͻ�����-->
	<%if(idx.equals("3")){
		vars = e_db.getCarSubList("3_gar", car_comp_id, car_cd, car_id, car_seq, a_a);
		size = vars.size();		
	%>
	<tr>
    	<td class=h></td>
    </tr>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Ͻ�����</span></td>
	</tr>    
    <tr <%if (garnish_yn_opt_st.equals("")) {%>style="display: none;"<%}%>> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=5%>����</td>
                    <td class="title" width=34%>����</td>
                    <td class="title" width=20%>�ݾ�</td>					
		    		<td class="title" width=41%>���</td>			
                </tr>
                <%for(int i = 0 ; i < size ; i++){
    			Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center">
						<input type="radio" name="car_gar_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>'>
                    </td>
                    <td>&nbsp;<%=var.get("NM")%></td>					
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>��</td>						
		    		<td>&nbsp;<%=var.get("ETC")%></td>
                </tr>
                <%}%>		
            </table>
        </td>
    </tr>    
	<%}%>
        
<%}%>
    
    <%if(idx.equals("2") || idx.equals("3")){%>
    <tr> 
        <td align="right"> 
            <a href="javascript:save();"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>
        </td>
    </tr>          
    <%}else{%>  
    <tr> 
        <td align="right"> <a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>  
    	<%if(idx.equals("1")){%>
		    <%if (duty_free_count > 0 && duty_free_count2 > 0) {%>
		    <tr>
		        <td align="left">
		        	�� �������� : ������ ����ǥ�� �����ϰ� ǥ��<br>
					&nbsp;-  ����ī��/����ο� LPG ��������: �����Һ� �鼼������ ǥ��,&nbsp;&nbsp;&nbsp;�Ϲ��ο� LPG ��������: �����Һ� ���������� ǥ��<br><br>
					
					�� �����Һ� �鼼���� : ���� ����ī�翡�� �����ϴ� �������� ��ⷻƮ ������ ���� ������ �Ǵ� ����<br>
					&nbsp;- ����ī��, ����ο�, �Ϲ��ο� LPG ���������� ȥ��Ǿ� ���� ��� �����Һ� �鼼������ ������ ���ؾ� ��Ȯ�� �񱳰� �˴ϴ�.
		        </td>
		    </tr>  
		    <%}%>
	    <%}%>
	    
    <%}%>  
    
    <%if(idx.equals("2")){%>
    <tr id=tr_opt_sum style="display:none"> 
        <td>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td width=5%>&nbsp;</td>
                    <td width=34%>�ɼ� �ݾ� �հ�</td>
                    <td width=20% align=right><input type="text" name="v_opt_amt" value="0" size="10" class=whitenum>��</td>
                    <td width=41%>&nbsp;</td>
                </tr>    
                <tr> 
                    <td>&nbsp;</td>
                    <td>���� �ݾ�(�⺻��������)</td>
                    <td align=right><input type="text" name="v_car_amt" value="0" size="10" class=whitenum>��</td>
                    <td>&nbsp;</td>
                </tr>    
                <tr> 
                    <td>&nbsp;</td>
                    <td>��������(�հ�) <span id="tax_amt_text" style="display: none;">���Ҽ� ������</span></td>
                    <td align=right><input type="text" name="v_o_1" value="0" size="10" class=whitenum>��</td>
                    <td>&nbsp;</td>
                </tr>    
    <%}%>
</table>
</form>

<!-- ���� ���� �ѷ��ֱ� 20161107 ����� -->
<%	
	//���� ���� �� ���� ��� �����ֱ�
	if(idx.equals("3")){
	    Vector carEtc = e_db.getCarSubList("3_1", car_comp_id, car_cd, car_id, car_seq, a_a);
%>
	
	<table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
            <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�ش� ���� �������</span></span></td>
            <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
    </table>
<%	    
	    for(int j=0; j<carEtc.size(); j++){
	    	Hashtable carEtcTable = (Hashtable)carEtc.elementAt(j);
%>
			<p style="font-size:12px; padding:15px;">
				<%=(String)carEtcTable.get("ETC")%>
			</p>
<%
	    }

		//����ǥ �����ֱ�(20180629)
		Vector scanList = c_db.getAcarAttachFileList("CAR_COL_CAT",car_comp_id+"^"+car_cd+"^%",-1);
		int scanListSize = scanList.size();
%>
		<div style="margin-bottom: 5px; font-size: 14px;"><b>&lt; <%=car_nm %> ����ǥ &gt;</b></div>
		<table width=100% border=0 cellpadding=0 cellspacing=0 class="inner-table">
			<tr>
				<td class="title" width="4%">����</td>
				<td class="title" width="30%">�����̸�</td>
				<td class="title" width="15%">�������</td>
				<td class="title" width="*">���</td>
			</tr>
<%		if(scanListSize>0){	%>
<%			for(int i=0; i<scanListSize; i++){ %>
			<%	Hashtable carColCat = (Hashtable)scanList.elementAt(i); %>
			<%	CommonEtcBean etc_bean = new CommonEtcBean();  
					etc_bean = c_db.getCommonEtc("acar_attach_file","content_code","CAR_COL_CAT","content_seq",String.valueOf(carColCat.get("CONTENT_SEQ")),"","","","");
			%>
			<tr>
				<td align="center"><%=i+1%></td>
				<td align="center"><a href="javascript:openPopF('<%=carColCat.get("FILE_TYPE")%>','<%=carColCat.get("SEQ")%>');" title='����' ><%=carColCat.get("FILE_NAME")%></a></td>
				<td align="center"><%=String.valueOf(carColCat.get("REG_DATE")).substring(0,10)%></td>
				<td align="left">&nbsp;<%=etc_bean.getEtc_content()%></td>
			</tr>
	<%		} %>			
<%		}else{%>
		<tr>
			<td></td>
			<td colspan="3" align="center">���� ��ϵ� ���� ����ǥ�� �����ϴ�.</td>
		</tr>
<%		} %>	
		</table>
<%	}%>
<%
	//���� ���� ��� display
	if(idx.equals("5")){
    
	    Hashtable car_b = a_cmb.getCar_b(car_id, car_seq);
		String car_b1 = (String)car_b.get("CAR_B");
		
		Hashtable ht2 = a_cmb.getCar_b((String)car_b.get("CAR_B_INC_ID"), (String)car_b.get("CAR_B_INC_SEQ"));
		String car_b2 = (String)ht2.get("CAR_B");
		
		Hashtable ht3 = a_cmb.getCar_b((String)ht2.get("CAR_B_INC_ID"), (String)ht2.get("CAR_B_INC_SEQ"));
		String car_b3 = (String)ht3.get("CAR_B");
		
		Hashtable ht4 = a_cmb.getCar_b((String)ht3.get("CAR_B_INC_ID"), (String)ht3.get("CAR_B_INC_SEQ"));
		String car_b4 = (String)ht4.get("CAR_B");

%>
	<table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
            <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>���� �������</span></span></td>
            <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
    </table>
    <br/>
    <table class="inner-table">
    	<colgroup>
    		<col width="15%"/>
    		<col width="*"/>
    	</colgroup>
    	<thead>
    		<tr>
    			<td class="line" colspan="2" style="background-color:#b0baec;padding:0px;height:2;"></td>
    		</tr>
    		<tr>
    			<th>����</th>
    			<th>�⺻ ǰ��</th>
    		</tr>
    	</thead>
    	<%if(!String.valueOf(car_b.get("CAR_B")).equals("null")){%>
    	<tr>
    		<th><%=(String)car_b.get("CAR_NAME")%>&nbsp;<span class="default-title">(���� Ʈ��)</span></th>
    		<td>
    			<%if(!String.valueOf(ht2.get("CAR_NAME")).equals("null")){%>	
	    			<span class="parent-desc"><%=(String)ht2.get("CAR_NAME")%> �⺻���ǰ�� ��</span><br>
	    		<%} %>
	    		<%=car_b1%>
    		</td>
    	</tr>
    	<%} %>
    	<%if(!String.valueOf(ht2.get("CAR_B")).equals("null")){%>
    	<tr>
    		<th><%=(String)ht2.get("CAR_NAME")%></th>
    		<td>
    			<%if(!String.valueOf(ht3.get("CAR_NAME")).equals("null")){%>
	    			<span class="parent-desc"><%=(String)ht3.get("CAR_NAME")%> �⺻���ǰ�� ��</span><br>
	    		<%} %>
	    		<%=car_b2%>
    		</td>
    	</tr>
    	<%} %>
    	 <%if(!String.valueOf(ht3.get("CAR_B")).equals("null")){%>
    	 <tr>
    	 	<th><%=(String)ht3.get("CAR_NAME")%></th>
    	 	<td>
    	 		<%if(!String.valueOf(ht4.get("CAR_NAME")).equals("null")){%>
	    			<span class="parent-desc"><%=(String)ht4.get("CAR_NAME")%> �⺻���ǰ�� ��</span><br>
	    		<%} %>
	    		<%=car_b3%>
    	 	</td>
    	 </tr>
    	 <%} %>
    	 <%if(!String.valueOf(ht4.get("CAR_B")).equals("null")){%>
    	 <tr>
    	 	<th><%=(String)ht4.get("CAR_NAME")%></th>
    	 	<td>
    	 		<%=car_b4%>
    	 	</td>
    	 </tr>
    	 <%} %>
    </table>
<%} %>
</td>
</tr>
</table>
</form>
</body>
<script language="JavaScript">
<!--
	var ofm = opener.document.form1;
	
	// �ʱ�ȭ 
	
	<%if(idx.equals("1")){%>
		ofm.car_name.value 	= '';
		ofm.car_id.value 	= '';
		ofm.car_seq.value 	= '';
		ofm.car_amt.value 	= '0';
		ofm.jg_tuix_st.value 	= '';
		ofm.lkas_yn.value 	= '';//������Ż ������
		ofm.ldws_yn.value 	= '';//������Ż �����
		ofm.aeb_yn.value 	= '';//������� ������
		ofm.fcw_yn.value 	= '';//������� �����
		ofm.hook_yn.value 	= '';//���ΰ�
		ofm.o_1.value 	= '0';
		
		ofm.conti_rat.value 	= '';	
		ofm.conti_rat_seq.value 	= '';	
		ofm.dc.value 	= '';	
		ofm.dc_seq.value 	= '';	
		ofm.dc_amt.value 	= '0';	
		ofm.esti_d_etc.value 	= '';	
		ofm.tax_dc_amt.value 	= '0';	
	<%}%>
	
	<%if(idx.equals("2")){%>
		/* 
		ofm.jg_tuix_st.value 	= '';
		ofm.lkas_yn.value 	= '';//������Ż ������
		ofm.ldws_yn.value 	= '';//������Ż �����
		ofm.aeb_yn.value 	= '';//������� ������
		ofm.fcw_yn.value 	= '';//������� ����� 
		*/
		
		ofm.jg_tuix_st.value 	= '<%=tmp_jg_tuix_st%>';
		ofm.lkas_yn.value 	= '<%=tmp_lkas_yn%>';//������Ż ������
		ofm.ldws_yn.value 	= '<%=tmp_ldws_yn%>';//������Ż �����
		ofm.aeb_yn.value 	= '<%=tmp_aeb_yn%>';//������� ������
		ofm.fcw_yn.value 	= '<%=tmp_fcw_yn%>';//������� �����
		ofm.hook_yn.value 	= '<%=tmp_hook_yn%>';//������� �����
	<%}%>
		
	<%if(idx.equals("1") || idx.equals("2")){%>
		ofm.opt.value 		= '';
		ofm.opt_seq.value 	= '';
		ofm.opt_amt.value 	= '0';			
		ofm.opt_amt_m.value 	= '0';
		ofm.jg_opt_st.value 	= '';	
		ofm.jg_tuix_opt_st.value 	= '';
		ofm.lkas_yn_opt_st.value 	= '';//������Ż ������
		ofm.ldws_yn_opt_st.value 	= '';//������Ż �����
		ofm.aeb_yn_opt_st.value 	= '';//������� ������
		ofm.fcw_yn_opt_st.value 	= '';//������� �����
		ofm.hook_yn_opt_st.value 	= '';//���ΰ�
		
		ofm.garnish_col.value	= '';
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));
	<%}%>
	
	<%if(idx.equals("1") || idx.equals("3")){%>
		ofm.col.value 		= '';
		ofm.in_col.value	= '';
		ofm.garnish_col.value	= '';
		ofm.col_seq.value 	= '';
		ofm.col_amt.value 	= '0';				
		ofm.jg_col_st.value 	= '';	
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));
	<%}%>
	
//-->
</script>
</html>