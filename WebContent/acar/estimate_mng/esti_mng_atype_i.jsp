<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw  = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id    = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id  = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String gubun1   = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2   = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3   = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4   = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5   = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6   = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt     = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt     = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd     = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd     = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
  
	String st       = request.getParameter("st")==null?"":request.getParameter("st");
	String est_id   = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String set_code   = request.getParameter("set_code")==null?"":request.getParameter("set_code");
	String eh_code   = request.getParameter("eh_code")==null?"":request.getParameter("eh_code");
	String spe_seq  = request.getParameter("spe_seq")==null?"":request.getParameter("spe_seq");
	String est_table= request.getParameter("est_table")==null?"":request.getParameter("est_table");
	String cmd      = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String spe_cmd      = request.getParameter("spe_cmd")==null?"":request.getParameter("spe_cmd");
	String spe_car_nm = request.getParameter("spe_car_nm")==null?"":request.getParameter("spe_car_nm");
	String damdang_id   = ck_acar_id;
	
	/*******����������*******/
	String pur_seq = request.getParameter("pur_seq")==null?"":request.getParameter("pur_seq");
	String pur_car_nm = request.getParameter("pur_car_nm")==null?"":request.getParameter("pur_car_nm");
	String pur_car_opt = request.getParameter("pur_car_opt")==null?"":request.getParameter("pur_car_opt");
	String pur_car_col = request.getParameter("pur_car_col")==null?"":request.getParameter("pur_car_col");
	String pur_car_in_col = request.getParameter("pur_car_in_col")==null?"":request.getParameter("pur_car_in_col");
	String pur_car_garnish_col = request.getParameter("pur_car_garnish_col")==null?"":request.getParameter("pur_car_garnish_col");
	
	String pur_eco_yn = request.getParameter("pur_eco_yn")==null?"":request.getParameter("pur_eco_yn");
	String pur_car_amt = request.getParameter("pur_car_amt")==null?"":request.getParameter("pur_car_amt");
	String pur_con_amt = request.getParameter("pur_con_amt")==null?"":request.getParameter("pur_con_amt");
	String pur_dlv_est_dt = request.getParameter("pur_dlv_est_dt")==null?"":request.getParameter("pur_dlv_est_dt");
	String pur_con_pay_dt = request.getParameter("pur_con_pay_dt")==null?"":request.getParameter("pur_con_pay_dt");
	String pur_etc = request.getParameter("pur_etc")==null?"":request.getParameter("pur_etc");
	
	String pur_from_page = request.getParameter("pur_from_page")==null?"":request.getParameter("pur_from_page");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	/*********************/
	
	CommonDataBase c_db   = CommonDataBase.getInstance();
	EstiDatabase e_db   = EstiDatabase.getInstance();
	CarOfficeDatabase umd   = CarOfficeDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstDatabase cmb  = CarMstDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	e_bean = e_db.getEstimateCase(est_id);
	
	//ǥ�ؿ��뿩�ῡ�� ����
	if (est_table.equals("hp")) {
		e_bean = e_db.getEstimateHpCase(est_id);
	}
  
	//ǥ�ؿ��뿩�ῡ�� ����
	if (est_table.equals("esti_spe")) {
	  	e_bean = e_db.getEstimateCuCase(est_id);
	}
	
	//����Ȱ������� ����
	if (est_table.equals("esti_spe")) {
		if (e_bean.getEst_id().equals("")) {
	   		e_bean = e_db.getEstimateSpeCarCase(est_id, spe_seq);
		    e_bean.setOpt_chk   ("0");
		  	e_bean.setIns_per   ("1");
		  	e_bean.setInsurant  ("1");
		  	e_bean.setIns_dj    ("2");
		  	e_bean.setIns_age   ("1");
		  	//�������̸� 500,000
		  	e_bean.setCar_ja    (300000);   
		  	if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5) {
		    	e_bean.setCar_ja  (500000);
		  	}   
	  	}
	}
  
	String a_a[] = new String[4];
	String opt_chk[] = new String[4];
	
	for (int j = 0; j < 4; j++) {
		a_a[j]      = "";
		opt_chk[j] = "0";
	}
	
	if (est_table.equals("esti_spe")) {
		if (spe_cmd.equals("")) {		  
	   		int a_a_len = e_bean.getA_a().length();
	   		for (int j = 0; j < a_a_len/2; j++) {
	   			a_a[j] = e_bean.getA_a().substring(j*2,(j+1)*2);
	     		if (a_a[j].equals("22") || a_a[j].equals("12")) {
	       			opt_chk[j] = "1";
	     		}
	   		}
	 	}
		
	   	if (a_a[0].equals("")) {
	   		e_bean.setA_a("22");
	     	opt_chk[0] = "1";
	   	}
	}
  
	if (!e_bean.getReg_id().equals("") && !e_bean.getReg_id().equals("2016006")) {
		damdang_id = e_bean.getReg_id();
	}
	
	//�ڵ���ȸ�� ����Ʈ
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	float jg_f = 0;
	float jg_g = 0;
	String jg_w = "0";
	String jg_h = "0";
	String jg_i = "0";
	String jg_b = "";
  
	//�񱳰����� ������ȸ
	if (cmd.equals("re")) {
		jg_b = e_db.getJg_b(e_bean.getCar_comp_id(), e_bean.getCar_cd(), e_bean.getCar_id());
	} else {
	 	jg_b = "";
	}
  
	if (est_id.equals("")) {
		e_bean.setCar_comp_id   ("0001");
	  	e_bean.setA_a     		("22");
		//  e_bean.setA_b     		("36");
		e_bean.setA_b     		("48");		//����Ʈ 48������ ����(2018.03.12)
		e_bean.setOpt_chk   	("1");
		e_bean.setIns_per   	("1");
		e_bean.setInsurant    	("1");
		e_bean.setIns_dj    	("2");
		e_bean.setIns_age   	("1");
		e_bean.setCar_ja    	(300000);		
	} else {
	 
	  	cm_bean2 = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	  	if (est_table.equals("hp") && e_bean.getIns_per().equals("")) {
	    	if (e_bean.getEst_nm().indexOf("2_f") != -1) {
	    		e_bean.setIns_per   ("2");
	    	} else {
	    		e_bean.setIns_per   ("1");
	    	}
	  	}
	  
		//��������
		ej_bean = e_db.getEstiJgVarCase(cm_bean2.getJg_code(), "");
		jg_f = ej_bean.getJg_f()*100;
		jg_g = ej_bean.getJg_g()*100;
		jg_w = ej_bean.getJg_w();
		jg_h = ej_bean.getJg_h();
		jg_i = ej_bean.getJg_i();
	  
		//�������̸� 500,000    
		if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5) {
			e_bean.setCar_ja  (500000);
		}
	}
  
	//20120901���� ���������� �ִ�3% �̳����� ���ð��� - ����Ʈ 0%
	jg_f = 0;
	jg_g = 0;
	
	//������ ����� ��� ǥ��
	Hashtable com_ht = umd.getCarCompCase("0001");
	String etc = String.valueOf(com_ht.get("ETC"));
	String bigo = String.valueOf(com_ht.get("BIGO"));
	
	//��������Ʈ
	CarMstBean cm_r [] = cmb.getCarKindAll_Esti(e_bean.getCar_comp_id());
	
	//�׽�Ʈ��
	CarMstBean cm_r2 [] =  cmb.getCarKindAll(e_bean.getCar_comp_id());	
	
	//�뿩��ǰ��
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y");
	int good_size = goods.length;
	
	//�����ε�����
	CodeBean[] code33 = c_db.getCodeAll3("0033");
	int code33_size = code33.length;
	
	//������ ���ּ���
	CodeBean[] code34 = c_db.getCodeAll3("0034");
	int code34_size = code34.length;
	
	//������ ���ּ���
	CodeBean[] code37 = c_db.getCodeAll3("0037");
	int code37_size = code37.length;  
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�ű��߰�
	EstimateBean e_bean2 = new EstimateBean();
	EstimateBean e_bean3 = new EstimateBean();
	EstimateBean e_bean4 = new EstimateBean();
	
	Vector vars = new Vector();
	int size = 0;
	
	if (e_bean.getPrint_type().equals("6")) {
	 	if (spe_cmd.equals("")) {
			vars = e_db.getABTypeEstIds2(set_code, est_id);
			size = vars.size();
		
			for (int i = 0; i < size; i++) {
				Hashtable var = (Hashtable)vars.elementAt(i);
				if (i==0) e_bean = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
				if (i==1) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
				if (i==2) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
				if (i==3) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			}
		
	 	} else {
	 		if (!eh_code.equals("")) {
				vars = e_db.getABTypeEstIds4(set_code, est_id, eh_code);
				size = vars.size();
			
				for (int i = 0; i < size; i++) {
					Hashtable var = (Hashtable)vars.elementAt(i);
					if (i==0) e_bean = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
					if (i==1) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
					if (i==2) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
					if (i==3) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
				}
			
	 		} else {
	 			vars = e_db.getABTypeEstIds5(set_code, est_id, eh_code);
	 			size = vars.size();
	 		  	
	 		    e_bean = e_db.getEstimateCase(est_id);
	 		  	e_bean.setReturn_select("0");
	 		    e_bean.setA_a("22");
	 		    e_bean.setOpt_chk("1");
	 		    
	 		    e_bean2 = e_db.getEstimateCase(est_id);
	 		  	e_bean2.setReturn_select("1");
	 		  	e_bean2.setA_a("22");
	 		    e_bean2.setOpt_chk("0");
	 		    
	 		    e_bean3 = e_db.getEstimateCase(est_id);
	 		}
	 	}
	
	} else {
		e_bean2 = e_bean;
		e_bean3 = e_bean;
		e_bean4 = e_bean;
	}
  
  	// �񱳰����϶��� ������
	String ecar_pur_sub_amt_val = "";	
	if (cmd.equals("re")) {
		ecar_pur_sub_amt_val = String.valueOf(e_bean.getEcar_pur_sub_amt());
	}
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" type="text/css" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<style>
.num_weight {
	font-weight: 800 !important;
}
/* �������� readonly background custom */
.gi_per:-moz-read-only { /* For Firefox */
  background-color: #E5E5E5;
}
.gi_per:read-only {
  background-color: #E5E5E5;
}
.gi_per[readonly] {
  background-color: #E5E5E5;
}
.gi_amt:-moz-read-only { /* For Firefox */
  background-color: #E5E5E5;
}
.gi_amt:read-only {
  background-color: #E5E5E5;
}
.gi_amt[readonly] {
  background-color: #E5E5E5;
}
#btnOk {
	margin-right: 15px !important;
}
.dialogBtnCustom {
	padding: 5px 15px !important;
	font-size: 14px !important;
    border: 1px solid #349BD5 !important;
    background: #349BD5 !important;
    font-weight: normal !important;
    color: #FFFFFF !important;
}
.dialogBtnCustom:hover {
	padding: 5px 15px !important;
	font-size: 14px !important;
    border: 1px solid #187ab1 !important;
    background: #187ab1 !important;
    font-weight: normal !important;
    color: #FFFFFF !important;
}
#esti_condition{
	border: 0.1px solid rgba(176, 186, 236, 0.5) !important;
}
#esti_condition td{
	border: 0.1px solid rgba(176, 186, 236, 0.5) !important;
}
.equal-condition{
	font-size: 20px; 
	font-weight: bold; 
	text-align: center;
}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.js"></script>
<!-- dialog ���̺귯�� -->
<script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript" src="https://nowonbun.github.io/Loader/dialog.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script>
$(function() {
	// �ɼ��� �����Ѵ�.
	dialog.set({
		// ���̾�αװ� show�� ���� �׼� ����
		/* show: {
			effect: "blind",
			duration: 400
		}, */
		// ���̾�αװ� hide�� ���� �׼� ����
		/* hide: {
			effect: "explode",
			duration: 400
		}, */
		// Ÿ��Ʋ ����
		//title: "",
		//width: 450,
        //height: 300,
        position: { my: "center", at: "top+100", of: window },
		// ��� ����
		modal: true,
		resizable: false,
		draggable: false, //â �巡�� ���ϰ�
		// ��ư ����
		/* buttons: {
			OK: function() {
				EstiReg();
				dialog.close();
			},
			Cancel: function() {
				dialog.close();
			}
		} */
		buttons: [
			{
		        text: "Ȯ��",
		        "id": "btnOk",
		        "class": "dialogBtnCustom",
		        click: function () {
		        	EstiReg();
		        	dialog.close();
		        }
	    	},
	    	{
		        text: "���",
		        "id": "btnCancel",
		        "class": "dialogBtnCustom",
		        click: function () {
		        	dialog.close();
		        }
	    	}
	    ],
	    close: function () {
	    	dialog.close();
	    }
	});
});
</script>
<script language="JavaScript">
<!--
function replaceFloatRound(per) {
	return Math.round(per*1000)/10;
}
  
function replaceFloatRound2(per) {
    return Math.round(per*10)/10; 
}
  
//������ã��
function search_cust() {
    var fm = document.form1;
    var SUBWIN="search_cust_list.jsp?t_wd="+fm.est_nm.value;    
    window.open(SUBWIN, "SubCust", "left=10, top=10, width=1250, height=800, scrollbars=yes, status=yes");   
}
  
function enter() {
    var keyValue = event.keyCode;
    if (keyValue =='13') search_cust();
} 
  
//�ڵ���ȸ�� ����� �����ڵ� ����ϱ�
function GetCarCode() {
    var fm = document.form1;
    var fm2 = document.form2;
    
    //������ ���ý� ������ ��� �ʱ�ȭ �� �ϴ��Է� show/hide
    var num_car_comp_id = Number($("#car_comp_id option:selected").val());
    
  	//����,��ƴ� ��üŹ�۷� ��ȸ��ư Ȱ��ȭ
	if (num_car_comp_id < 3) {
		tr_cons_cost_y.style.display='';		
		tr_cons_cost_n.style.display='none';	
	}else{
		tr_cons_cost_y.style.display='none';	
		tr_cons_cost_n.style.display='';		
	}   
  
    if (num_car_comp_id > 5) {
    	$("#import_pur_st_1").prop("checked", true);
    	$("#import_content_1").show();
    	//��ü��� �� �����������ÿ� ���� �ϴ��Է� show/hide
    	release_type();
    	
    	// ������ ���� �� ��Ʈ, ����, ���� ��Ȱ��ȭ
    	fm.print_type[0].checked = true;
    	fm.print_type[2].checked = false;
    	fm.print_type[3].checked = false;
    	fm.print_type[4].checked = false;
    	
    	fm.print_type[2].disabled = true;
    	fm.print_type[3].disabled = true;
    	fm.print_type[4].disabled = true;
    	
    } else {
    	$("#import_pur_st_1").prop("checked", true);
    	$("#import_content_1").hide();
    	//��ü��� �� �����������ÿ� ���� �ϴ��Է� show/hide
    	release_type();
    	
    	fm.print_type[2].disabled = false;
    	fm.print_type[3].disabled = false;
    	fm.print_type[4].disabled = false;
    }
    
    // 20210318. ���� �Ϻ��� ������ȣ�� ��û �Ұ� ó��. ������ ������, ����Ÿ, ȥ��, �ֻ�, ���Ǵ�Ƽ
    var comp_id = $("#car_comp_id option:selected").val();
    if(comp_id == '0044' || comp_id=='0007' || comp_id=='0025' || comp_id=='0033' || comp_id=='0048'){
    	fm.new_license_plate[0].style.display = 'none';
		fm.new_license_plate[1].style.display = 'none';
		fm.new_license_plate[2].style.display = 'none';
		fm.new_license_plate[3].style.display = 'none';
		fm.new_license_plate[0].previousElementSibling.style.display = 'none';
		fm.new_license_plate[1].previousElementSibling.style.display = 'none';
		fm.new_license_plate[2].previousElementSibling.style.display = 'none';
		fm.new_license_plate[3].previousElementSibling.style.display = 'none';
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
    
    te = fm.code;
    te.options[0].value = '';
    te.options[0].text = '��ȸ��';
    
    fm2.sel.value = "form1.code";
    fm2.car_comp_id.value = fm.car_comp_id.value;
    fm2.mode.value = '8';
    fm2.rent_way.value = '';    
    fm2.a_a.value = '';   
    fm2.target="i_no";
    fm2.submit();
}
  
//���θ���Ʈ (����,�ɼ�,����)
function sub_list(idx) {
    var fm = document.form1;    
    if (fm.code.value == '') { alert('������ �����Ͻʽÿ�.'); return;}
    if (idx != 1 && fm.car_name.value == '') {  alert("������ �����ϼ���"); return;  }
    //�Ķ���� jg_g_7 �߰�
    var jg_g_7_val = "";
    if (idx != 1) {
    	jg_g_7_val = fm.jg_g_7.value;
    }
    var garnish_yn_opt_st = fm.garnish_yn_opt_st.value;
	var hook_yn_opt_st = fm.hook_yn_opt_st.value;
    var SUBWIN="./search_sub_list.jsp?idx="+idx+"&a_a=&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&rent_dt="+fm.rent_dt.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text+"&jg_g_7="+jg_g_7_val+"&garnish_yn_opt_st="+garnish_yn_opt_st+"&hook_yn_opt_st="+hook_yn_opt_st;  
    window.open(SUBWIN, "SubList", "left=100, top=100, width=1200, height=800, scrollbars=yes, status=yes");
}

    
//����==�ݾ� ��ȯ
function compare(idx, obj) {
    var fm = document.form1;
    
    if (obj == fm.rg_8[idx]) {
    
      	fm.rg_8_amt[idx].value  = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_1.value)) * toFloat(fm.rg_8[idx].value) / 100, 1000 ));
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.rg_8_amt[idx].value = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_12.value)) * toFloat(fm.rg_8[idx].value) / 100, 1000 ));
        	}
      	}
      
    } else if (obj == fm.rg_8_amt[idx]) {
    	
    	fm.rg_8[idx].value  = replaceFloatRound( toInt(parseDigit(fm.rg_8_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) );
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.rg_8[idx].value = replaceFloatRound( toInt(parseDigit(fm.rg_8_amt[idx].value)) / toInt(parseDigit(fm.o_12.value)) );
        	}
      	}
      	var r_idx = idx+1;
      	$("#sel_rg_8_"+r_idx+" option[value='directInput']").prop("selected",true);
      
    } else if (obj == fm.pp_per[idx]) {
    
      	fm.pp_amt[idx].value  = parseDecimal( toInt(parseDigit(fm.o_1.value)) * toFloat(fm.pp_per[idx].value) / 100 );            
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.pp_amt[idx].value = parseDecimal( toInt(parseDigit(fm.o_12.value)) * toFloat(fm.pp_per[idx].value) / 100 );            
        	}
      	}
      
    } else if (obj == fm.pp_amt[idx]) {
    
      	fm.pp_per[idx].value  = replaceFloatRound( toInt(parseDigit(fm.pp_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) );
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          	fm.pp_per[idx].value = replaceFloatRound( toInt(parseDigit(fm.pp_amt[idx].value)) / toInt(parseDigit(fm.o_12.value)) );
        	}
      	}
      
    } else if (obj == fm.ro_13[idx]) {
    
      	fm.ro_13_amt[idx].value = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_1.value)) * toFloat(fm.ro_13[idx].value) / 100, 1000 )); 
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.ro_13_amt[idx].value = parseDecimal( getCutRoundNumber( toInt(parseDigit(fm.o_12.value)) * toFloat(fm.ro_13[idx].value) / 100, 1000 ));  
        	}
      	} 
      
    } else if (obj == fm.ro_13_amt[idx]) {
    
      	fm.ro_13[idx].value = replaceFloatRound( toInt(parseDigit(fm.ro_13_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) );
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.ro_13[idx].value = replaceFloatRound( toInt(parseDigit(fm.ro_13_amt[idx].value)) / toInt(parseDigit(fm.o_12.value)) );
        	}
      	} 
      
    } else if (obj == fm.gi_per[idx]) {
    	
    	var temp_gi_per = fm.gi_per[idx].value;    	
    	var result_gi_amt = toInt(parseDigit(fm.o_1.value)) * toFloat(fm.gi_per[idx].value) / 100;
    	
    	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
			if (fm.ls_yn.value == 'Y') {
				result_gi_amt = toInt(parseDigit(fm.o_12.value)) * toFloat(fm.gi_per[idx].value) / 100;
			}
      	}
    	
		var unit_num = 100000;
		var round_gi_amt = Math.round(result_gi_amt/unit_num) * unit_num;
		var trunc_gi_amt = Math.floor(result_gi_amt/unit_num) * unit_num;
    	
    	if (temp_gi_per > 34) {
    		fm.gi_amt[idx].value = parseDecimal(trunc_gi_amt);
    	} else {
    		fm.gi_amt[idx].value = parseDecimal(round_gi_amt);
    	}
    	
    	/*
    	fm.gi_amt[idx].value = parseDecimal( toInt(parseDigit(fm.o_1.value)) * toFloat(fm.gi_per[idx].value) / 100 );
    	
		if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
			if (fm.ls_yn.value == 'Y') {
				fm.gi_amt[idx].value = parseDecimal( toInt(parseDigit(fm.o_12.value)) * toFloat(fm.gi_per[idx].value) / 100 );
			}
      	}
		*/
      
    } else if (obj == fm.gi_amt[idx]) {
      
    	if (toInt(parseDigit(fm.gi_amt[idx].value)) == 0) {
	    	fm.gi_per[idx].value = replaceFloatRound(0);
    	} else {
	    	fm.gi_per[idx].value = replaceFloatRound( toInt(parseDigit(fm.gi_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) );
    	}
      
		if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
			if (fm.ls_yn.value == 'Y') {
		  		if (toInt(parseDigit(fm.gi_amt[idx].value)) == 0) {
		   			fm.gi_per[idx].value = replaceFloatRound(0);
		  		} else {
		   			fm.gi_per[idx].value = replaceFloatRound( toInt(parseDigit(fm.gi_amt[idx].value)) / toInt(parseDigit(fm.o_12.value)) );
		  		}          	
		  	}
		} 
	} 
}
  
//�μ� �ݳ����� ����
function return_type(idx) {
	var fm = document.form1;
	  
	var jg_g_7 = fm.jg_g_7.value;
	var jg_code = fm.jg_code.value;
	var car_comp_id = $("#car_comp_id option:selected").val();
	  
	var cmd = fm.cmd.value;
	  
	//�׽���� �μ��ݳ������� Ÿ���ʱ⶧���� üũ
	if ( (jg_g_7 == "3") && (car_comp_id != "0056" && jg_code != "9133" && jg_code != "9015435" && jg_code != "9015436" && jg_code != "9015437" ) ) {
		//�μ��ݳ����� ���ý� �ݳ����� ��� ���Կɼ� �̺ο�
		if (fm.return_select[idx].value == '0') {
			fm.opt_chk[idx].options[1].selected = true;
			fm.opt_chk[idx].disabled = true;
			  
			$("#ro_13_"+idx+"_display_1").show();
			$("#ro_13_"+idx+"_display_2").hide();
			  
		} else if (fm.return_select[idx].value == '1') {
			fm.opt_chk[idx].options[0].selected = true;
			fm.opt_chk[idx].disabled = true;

			$("#ro_13_"+idx+"_display_1").hide();
			$("#ro_13_"+idx+"_display_2").show();
			  
		} else {
			fm.opt_chk[idx].options[1].selected = true;
			fm.opt_chk[idx].disabled = false;
			  
			$("#ro_13_"+idx+"_display_1").show();
			$("#ro_13_"+idx+"_display_2").hide();
		}
		  
		if (idx == 2 || idx == 3) {
			if (fm.return_select[idx].value == "0") {
				//fm.a_a[idx].options[1].selected = true;
				//if (cmd != "re") {
				if (fm.a_a[idx].value == "21") {
					fm.a_a[idx].options[1].selected = true;
				} else if (fm.a_a[idx].value == "11") {
					fm.a_a[idx].options[3].selected = true;
				}
				//}
				  
				fm.a_a[idx].options[0].disabled = true;
				fm.a_a[idx].options[1].disabled = false;
				fm.a_a[idx].options[2].disabled = true;
				fm.a_a[idx].options[3].disabled = false;
				fm.a_a[idx].options[4].disabled = true;
				  
			} else if (fm.return_select[idx].value == "1") {
				//fm.a_a[idx].options[1].selected = true;
				  
				fm.a_a[idx].options[0].disabled = false;
				fm.a_a[idx].options[1].disabled = false;
				fm.a_a[idx].options[2].disabled = false;
				fm.a_a[idx].options[3].disabled = false;
				fm.a_a[idx].options[4].disabled = false;
			}
		}
	}
}
  
	//��ǰ���ý� ���Կɼ� ���� ����
	function SelectA_a(idx) {
	 	var fm = document.form1;
	  
	 	var jg_g_7 = fm.jg_g_7.value;
	 	var jg_code = fm.jg_code.value;  	
	 	var car_comp_id = $("#car_comp_id option:selected").val();
	 
		//�鼼�� ǥ�Ⱑ "�鼼���ݱ���" �����̸� �����Ұ�(20190502)
		if (fm.a_a[idx].value=="11"||fm.a_a[idx].value=="12") {
			if (fm.duty_free_opt.value=="1") {
				alert("�������� ���Ҽ� �鼼�� ǥ�������� ���� ������ �ȵ˴ϴ�.");
				fm.a_a[idx].options[1].selected = true;
			}
		}
		
		//���� ���� ������ �������� �Է� �Ұ�
		if (fm.a_a[idx].value=="11"||fm.a_a[idx].value=="12") {
			$("#gi_per_"+(idx+1)).prop("readonly", true);
			$("#gi_per_"+(idx+1)).val("0");
			$("#gi_amt_"+(idx+1)).prop("readonly", true);
			$("#gi_amt_"+(idx+1)).val("0");
		} else {
			$("#gi_per_"+(idx+1)).prop("readonly", false);
			$("#gi_amt_"+(idx+1)).prop("readonly", false);
		}
		
	  	
			fm.a_a[1].disabled = false;
			if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '21') {//�Ϲݽ�     
			  fm.opt_chk[idx].options[0].selected = true;     
			} else {
			  fm.opt_chk[idx].options[1].selected = true;     
			}
		
	}
  
        
//������D/C �Է��� ��������ϱ�
function set_amt() {
	var fm = document.form1;  
    	fm.o_1.value  = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value))  - toInt(parseDigit(fm.tax_dc_amt.value)));        
    if (fm.ls_yn.value == 'Y') {
    	fm.o_12.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt2.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));    
    }    
}
  
//�ִ��ܰ��� ��ȸ
function searchO13(idx) {
    var fm = document.sh_form;
    var fm2 = document.form1;
    var car_comp_id = $("#car_comp_id option:selected").val();
    var jg_code = fm2.jg_code.value;
    var agree_dist = fm2.agree_dist[idx].value;
    
    <%-- <%if (!(nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵������", user_id) || user_id.equals("000057"))) {%>
    if (Number(jg_code) > 9000000 && Number(jg_code) < 9036000) {
    	if (Number(agree_dist.replace(/,/g,"")) > 60000) {
    		alert("���� ��������Ÿ� �ִ밪�� �ʰ��Ͽ� �Է��Ͽ����ϴ�.\n\n* ������ ���� ��������Ÿ� �ִ밪\n- ��Ÿ���� �� �� Ʈ�� : 6��km/�� ����\n- �׿����� : 5��km/�� ����");
    		return;
    	}
    } else {
    	if (Number(agree_dist.replace(/,/g,"")) > 50000) {
    		alert("���� ��������Ÿ� �ִ밪�� �ʰ��Ͽ� �Է��Ͽ����ϴ�.\n\n* ������ ���� ��������Ÿ� �ִ밪\n- ��Ÿ���� �� �� Ʈ�� : 6��km/�� ����\n- �׿����� : 5��km/�� ����");
    		return;
    	}
    }
    <%}%> --%>
    
    if (fm2.car_id.value == '') {   	alert('������ �����Ͻʽÿ�');     return; }
    if (fm2.car_amt.value == '') {  	alert('�����ݾ��� Ȯ���Ͻʽÿ�');   return; }           
    if (fm2.a_a[idx].value == '') {   alert('�뿩��ǰ�� �����Ͻʽÿ�');   return; }
    if (fm2.a_b[idx].value == '') {   alert('�뿩�Ⱓ�� �����Ͻʽÿ�');   return; }
    
    if (fm2.est_yn[idx].checked ==false)  fm2.est_yn[idx].checked = true;
    
    fm.rent_dt.value   		= fm2.rent_dt.value;
    fm.car_id.value   		= fm2.car_id.value;
    fm.car_seq.value  		= fm2.car_seq.value;
    fm.car_amt.value  		= fm2.car_amt.value;
    fm.opt_amt.value 	 	= fm2.opt_amt.value;
    fm.opt_amt_m.value 	= fm2.opt_amt_m.value;
    fm.col_amt.value  		= fm2.col_amt.value;
    fm.dc_amt.value  	 	= fm2.dc_amt.value;
    fm.o_1.value    			= fm2.o_1.value;    
    fm.jg_opt_st.value 		= fm2.jg_opt_st.value;
    fm.jg_col_st.value  	= fm2.jg_col_st.value;
    fm.a_a.value    		= fm2.a_a[idx].value;
    fm.a_b.value    		= fm2.a_b[idx].value; 
    fm.agree_dist.value 	= fm2.agree_dist[idx].value;
    fm.ecar_loc_st.value 	= fm2.ecar_loc_st[idx].value;
    fm.hcar_loc_st.value 	= fm2.hcar_loc_st[idx].value;
    /* fm.eco_e_tag.value   	= fm2.eco_e_tag[idx].value; */
    fm.rtn_run_amt_yn.value 	= fm2.rtn_run_amt_yn[idx].value;
    
    fm.idx.value    		= idx;  
    
	if (fm2.print_type[0].checked ==true) 	fm.print_type.value	= '1';	
	if (fm2.print_type[1].checked ==true) 	fm.print_type.value	= '5';	
	if (fm2.print_type[2].checked ==true) 	fm.print_type.value	= '2';	
	if (fm2.print_type[3].checked ==true) 	fm.print_type.value	= '3';	
	if (fm2.print_type[4].checked ==true) 	fm.print_type.value	= '4';	
	if (fm2.print_type[5].checked ==true) 	fm.print_type.value	= '6';	
	
	if (fm.print_type.value == '5') {
		fm.ecar_loc_st.value = fm2.ecar_loc_st[0].value;
		fm.hcar_loc_st.value = fm2.hcar_loc_st[0].value;
		/* fm.eco_e_tag.value   = fm2.eco_e_tag[0].value; */
	}
				
	if (fm2.jg_g_7.value == '3' && fm.ecar_loc_st.value == '') {
		if ( jg_code != "5866" && jg_code != "6316111" && Number(fm2.jg_g_15.value) > 0 ) {				
			alert('������ ���ּ����� �����Ͻʽÿ�.'); return;
		}
	}
			
	if (fm2.jg_g_7.value == '4' && fm.hcar_loc_st.value == '') {
		alert('������ ���ּ����� �����Ͻʽÿ�.'); return;
	}
    
    var car_price     = toInt(parseDigit(fm.o_1.value));    
    
//     fm2.rg_8[idx].value     = '25';
    
	/* 
	if (car_price <= 45000000) {
		fm2.rg_8[idx].value     = '20';
    } 
	*/    
	
// 	if (Number($("#car_comp_id option:selected").val()) <= 5) {
// 		fm2.rg_8[idx].value     = '20';
// 	} else {
// 		fm2.rg_8[idx].value     = '25';
// 	}
    
    //�������� �⺻ �����ݿ��� 10% ���ش�
    //20190612 �׽���� ���� ģȯ�������п��� ������������ ����
    /* if (fm2.jg_g_7.value == '3') { */
//     if ( Number(fm2.jg_b.value) > 4 ) {
//      	fm2.rg_8[idx].value     = toInt(fm2.rg_8[idx].value)-10;
//     }
    
    // �⺻������ ���� ���� 2021.07.09.
    // �⺻������ ���� ���� 2022.05.06.
    if(Number($("#car_comp_id option:selected").val()) > 5){ // ������
//     	if (Number(fm2.jg_g_7.value) > 2) 	fm2.rg_8[idx].value = 15;	// ģȯ���� ���л� ����/������
//     	else 												fm2.rg_8[idx].value = 25;
    	fm2.rg_8[idx].value = 25;
    } else{	// ������
//     	if (Number(fm2.jg_g_7.value) > 2) 	fm2.rg_8[idx].value = 10;	// ģȯ���� ���л� ����/������
//     	else 												fm2.rg_8[idx].value = 20;
    	fm2.rg_8[idx].value = 20;
    }
    console.log(fm2.rg_8[idx].value);
 	// ģȯ���� ���л� �������鼭 �������� �հ� �ݾ��� 8õ���� �ʰ� �� +10%, 6500���� ������ +5%, 6500���� ���ϸ� �״��.
 	// ģȯ���� ���л� �������鼭 �������� 7500���� ���ϸ� -5%  2022.05.06.
    if (fm2.jg_g_7.value == '3'){
//     	if(car_price > 80000000)			fm2.rg_8[idx].value = Number(fm2.rg_8[idx].value) + 10;
// 		else if(car_price > 65000000) 	fm2.rg_8[idx].value = Number(fm2.rg_8[idx].value) + 5;
    	
    	if(car_price <= 75000000)			fm2.rg_8[idx].value = Number(fm2.rg_8[idx].value) - 5;
    }
 	// �������� -5%
 	if(fm2.jg_g_7.value == '4'){
 		fm2.rg_8[idx].value = Number(fm2.rg_8[idx].value) - 5;
 	}
 	console.log(fm2.rg_8[idx].value);
    	
    //������, �������� �⺻ �����ݿ��� 10% ���ش�
    /* if (fm2.jg_b.value == '3' || fm2.jg_b.value == '4') { //3 ������, 4 ������
     	fm2.rg_8[idx].value     = toInt(fm2.rg_8[idx].value)-10;
    } */
    
    var r_idx = idx + 1;
    $("#sel_rg_8_"+r_idx+" option[value='"+fm2.rg_8[idx].value+"']").prop("selected", true);
    
    //��Ʈ
    if (fm.a_a.value == '22' || fm.a_a.value == '21') {
      	if (fm2.jg_h.value != '1') {
        	alert('��Ʈ������� �ƴմϴ�.');
        	return;
      	}   
    }   
    
    //����DC �����Ҷ�
    if (fm.a_a.value == '11' || fm.a_a.value == '12') {
      	if (fm2.jg_i.value != '1') {
        	alert('����������� �ƴմϴ�.');
        	return;
      	}                 
      	if (fm2.ls_yn.value == 'Y') {
        	fm.dc_amt.value     = fm2.dc_amt2.value;
        	fm.o_1.value      	= fm2.o_12.value; 
        	car_price       		= toInt(parseDigit(fm2.o_12.value));              
      	}
    }

    fm2.rg_8_amt[idx].value = parseDecimal(getCutRoundNumber(car_price * toFloat(fm2.rg_8[idx].value) /100, 1000 ));
    
    //20141002 ������, ��������� ������ ����
    compare(idx, fm2.pp_per[idx]);
    compare(idx, fm2.gi_per[idx]);

    if ((fm.print_type.value == '2' || fm.print_type.value == '3' || fm.print_type.value == '4') && idx > 0) {
		return;
    }
    
    fm2.search_o13_yn.value = 'Y';
            
    fm.action = '/acar/estimate_mng/get_o13_20141223.jsp';    
    fm.target = 'i_no'; 
    
<%if (nm_db.getWorkAuthUser("������", user_id)) {%>
	if (fm2.O13_yn.checked == true) {
		fm.target = '_blank';
	}
<%}%>
    
    fm.submit();
    
} 
  
// ���ڸ� ������ �޸� �ֱ�
function numberWithCommas(x) {
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
    
//��������
function EstiReg() {
    var fm = document.form1;
    
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
    var doc_type_value = $('input:radio[name="doc_type"]:checked').val();
    
    //20160701 �Ͻ�����
    <%if (AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) == 20160701) {%>
    	//alert('7��1�� �����Һ� �λ����� ���� �غ����Դϴ�. �����������α׷��� �̿��Ͽ� �ֽʽÿ�.');
    	//return;
    <%}%>
    
    fm.est_nm.value = fm.est_nm.value.trim();
    /* 
    var temp_est_nm = fm.est_nm.value;    
	for (var i = 0; i < fm.est_nm.value.length; i++) { // ���� �� ���� ��ŭ ����� ������ ������ ����
		temp_est_nm = temp_est_nm.replace(" ", "");
	} 
	*/
        
    if (fm.est_nm.value == '') {
    	alert('��/��ȣ�� �Է��Ͻʽÿ�');
    	fm.est_nm.focus();
    	return;
    }
    
    if (fm.code.value == '') {    	alert('������ �����Ͻʽÿ�');       	return; }
    if (fm.car_id.value == '') {    alert('������ �����Ͻʽÿ�');       	return; }
    if (fm.car_amt.value == '') {   alert('���������� Ȯ���Ͻʽÿ�');     	return; }       
    if (fm.a_a[0].value == '') {    alert('�뿩��ǰ�� �����Ͻʽÿ�');     	return; }
    if (fm.a_b[0].value == '') {    alert('�뿩�Ⱓ�� �����Ͻʽÿ�');     	return; }
    
    //20160520 �ƽ��� Ư�������� �뺸�޽���
    if (fm.jg_code.value == '4156' || fm.jg_code.value == '4157' || fm.jg_code.value == '4012591' || fm.jg_code.value == '4012592') {
    	alert('�����Ǹ��� ������ �����Դϴ�. ��������� ���� ���������� ��쿡�� �����Ǹ��� ��� �ϰ�, ��翡�� ����� ������ �����ϵ��� �մϴ�. (���� �� �븮�� ��� �Ұ� ����)');
    }
    
    //20191004 ����Ƽ, �ް�Ʈ���� 2.4�� �ʰ��ϴ������� ������ �ȳ����� �˾����� - ������ ���� ��û����
    if ((Number(fm.jg_code.value) >= 9142 && Number(fm.jg_code.value) <= 9152) || (Number(fm.jg_code.value) >= 9017212 && Number(fm.jg_code.value) <= 9018112)) {
    	
    	var msg = "����� �ȳ�����\n\n" +
    					"1. 2.4�� �̻� ����(����Ƽ, �ް�Ʈ�� ��)��,\n" +
						"�������������� ���Ͽ� �����, ������� �� 7��~�ִ� 10�� �ҿ� �˴ϴ�.\n\n" +
						"2. �ش� ����, ����� ����ϱ��� �� �������� ���� �����ؾ� �մϴ�.\n\n" +
						"3. ��ǰ�۾� �Ұ� (���ڽ� ��������, �����۾��Ұ�)";
    	
    	if (!confirm(msg)) {
   			return;
    	}
    }
    
<%if (!est_table.equals("esti_spe")) {%>
    //�񱳰����϶� �Է°��� �ʱⰪ ���ؼ� �ִ��ܰ� ���꿩�� üũ
    <%if (!e_bean.getEst_id().equals("")) {%>
    if (fm.o_1.value != '<%=AddUtil.parseDecimal(e_bean.getO_1())%>' || fm.a_b[0].value != '<%=e_bean.getA_b()%>' ) {    
    	if (fm.search_o13_yn.value == '') { 
        	alert('����1�� ������ ����Ǿ����Ƿ� �ִ��ܰ��� �����Ͽ� �ֽʽÿ�.');
        	return;
      	}
    }
    <%}%>
<%}%>
    
    var ins_confirm = 'N';    
    
    var est_yn_count = 0;
    
<%for (int j = 0; j < 4; j++) {%>
    if (fm.est_yn[<%=j%>].checked == true) {
    	      	
    	est_yn_count++;
    	
<%-- 		if (fm.tint_s_yn[<%=j%>].checked ==true) fm.r_tint_s_yn[<%=j%>].value = 'Y'; --%>
		if (fm.tint_sn_yn[<%=j%>].checked ==true) fm.r_tint_sn_yn[<%=j%>].value = 'Y'; // ������� �̽ð����� üũ
		
		if (fm.tint_ps_yn[<%=j%>].checked ==true) {	
			fm.r_tint_ps_yn[<%=j%>].value = 'Y';		// ��޽���
		    fm.r_tint_ps_nm[<%=j%>].value =	 fm.tint_ps_nm[<%=j%>].value;		// ��޽��� ����
			fm.r_tint_ps_amt[<%=j%>].value = fm.tint_ps_amt[<%=j%>].value;		// ��޽��� �߰��ݾ�(���ް�)
			fm.r_tint_ps_st[<%=j%>].value = fm.setTint_ps_sel[<%=j%>].value;	// ��޽��� ���ð�
		}
		
		if (fm.tint_cons_yn[<%=j%>].checked ==true) {	
			fm.r_tint_cons_yn[<%=j%>].value = 'Y';
			fm.r_tint_cons_amt[<%=j%>].value = fm.tint_cons_amt[<%=j%>].value;		// �߰�Ź�۷�
		}
		
		if (fm.tint_n_yn[<%=j%>].checked ==true) fm.r_tint_n_yn[<%=j%>].value = 'Y';
		if (fm.tint_bn_yn[<%=j%>].checked ==true) fm.r_tint_bn_yn[<%=j%>].value = 'Y';
		if (fm.tint_eb_yn[<%=j%>].checked ==true) fm.r_tint_eb_yn[<%=j%>].value = 'Y';
		
<%-- 		if (fm.tint_s_yn[<%=j%>].checked ==false) fm.r_tint_s_yn[<%=j%>].value = 'N';		// ������� üũ ���� �� �� ���� �߰� 2017.12.27 --%>
		if (fm.tint_sn_yn[<%=j%>].checked ==false) fm.r_tint_sn_yn[<%=j%>].value = 'N';		// ������� �̽ð����� üũ ���� �� �� ���� �߰� 2017.12.27
		if (fm.tint_ps_yn[<%=j%>].checked ==false) fm.r_tint_ps_yn[<%=j%>].value = 'N';		// ��޽��� üũ ���� �� �� ���� �߰� 2017.12.27
		if (fm.tint_cons_yn[<%=j%>].checked ==false) fm.r_tint_cons_yn[<%=j%>].value = 'N';		// �߰�Ź�۷� üũ ���� �� �� ���� �߰� 2020.06.15
		if (fm.tint_n_yn[<%=j%>].checked ==false) fm.r_tint_n_yn[<%=j%>].value = 'N';		// ��ġ�� ������̼� üũ ���� �� �� ���� �߰� 2017.12.27
		if (fm.tint_bn_yn[<%=j%>].checked ==false) fm.r_tint_bn_yn[<%=j%>].value = 'N';		// ���ڽ� ������ ���� (��Ʈ��ķ,������..)
		if (fm.tint_cons_yn[<%=j%>].checked ==false) fm.r_tint_cons_yn[<%=j%>].value = 'N';		// �߰�Ź�۷�
		if (fm.tint_eb_yn[<%=j%>].checked ==false) fm.r_tint_eb_yn[<%=j%>].value = 'N';		// ��ġ�� ������̼� üũ ���� �� �� ���� �߰� 2017.12.27
		
    	fm.r_a_a[<%=j%>].value = fm.a_a[<%=j%>].value;
    	fm.r_ins_per[<%=j%>].value = fm.ins_per[<%=j%>].value;
    	fm.r_ins_dj[<%=j%>].value = fm.ins_dj[<%=j%>].value;
    	fm.r_ins_age[<%=j%>].value = fm.ins_age[<%=j%>].value;
    	fm.r_loc_st[<%=j%>].value = fm.loc_st[<%=j%>].value;
    	fm.r_ecar_loc_st[<%=j%>].value = fm.ecar_loc_st[<%=j%>].value;
    	fm.r_hcar_loc_st[<%=j%>].value = fm.hcar_loc_st[<%=j%>].value;
    	<%-- fm.r_eco_e_tag[<%=j%>].value = fm.eco_e_tag[<%=j%>].value; --%>
    	fm.r_com_emp_yn[<%=j%>].value = fm.com_emp_yn[<%=j%>].value;
    	fm.r_new_license_plate[<%=j%>].value = fm.new_license_plate[<%=j%>].value;
    	            
      	//��Ʈ
      	if (fm.a_a[<%=j%>].value == '22' || fm.a_a[<%=j%>].value == '21') {
        	if (fm.jg_h.value != '1') {
          		alert('��Ʈ������� �ƴմϴ�.');
          		return;
        	}
        	//24���� ��Ʈ�����ȵ�
        	if (fm.ins_age[<%=j%>].value == '3') {
          		alert('�������� ��24���̻��� ������ �����մϴ�.');
          		return;
        	}           
      	} else {
        	if (fm.jg_i.value != '1') {
          		alert('����������� �ƴմϴ�.');
          		return;
        	}                 
      	}
      
      	//20131104 �������� 3% �ʰ��� ���� �ȵ�
      	if (toFloat(fm.o_11[<%=j%>].value) > 3) {
        	alert('������� �������� 3%�� �ʰ��� �� �����ϴ�.');
        	return;
      	}
      
      	//20150414 �빰5���϶� �޽���
      	if (fm.ins_dj[<%=j%>].value == '3') {
        	ins_confirm = 'Y';  
      	}
      
      	//������
      	if (fm.jg_g_7.value == '3') {
      	
      		if (fm.print_type[1].checked == true && <%=j%> > 0) {
      		} else {
	      		if (fm.ecar_loc_st[<%=j%>].value == '') {
  	        		if ( jg_code != "5866" && jg_code != "6316111"  && Number(fm.jg_g_15.value) > 0 ) {
		      			alert('������ ���ּ����� �����Ͻʽÿ�.');
	    	    		return;
  	        		}
      	  		}  	
      		}
      		
	        //�������� 24�����̻�
	      	if (toInt(fm.a_b[<%=j%>].value) < 24) {
	          alert('�������� 24�����̻� ���� �����մϴ�.');
	          return;
	        }
	        
	        //������ ���ּ��� ���� �� �ִ��ܰ��� ����ϵ��� ����(2018.04.25)
	        if (fm.ecar_pur_sub_amt.value == '') {
	        	alert('�ִ��ܰ����� ������ּ���.');
	        	return;
	        }
        
      	//������
      	} else if (fm.jg_g_7.value == '4') {
      	
        	//�������� 24�����̻�
      		if (toInt(fm.a_b[<%=j%>].value) < 24) {
          		alert('�������� 24�����̻� ���� �����մϴ�.');
          		return;
        	}
        	
        	//������ �ִ��ܰ��� ����ϵ��� ����
        	if (fm.ecar_pur_sub_amt.value == '') {
       			alert('�ִ��ܰ����� ������ּ���.');
        		return;
        	}        
        
      	} else {
      		//���������� 12~60������
      		if (toInt(fm.a_b[<%=j%>].value) < 12 || toInt(fm.a_b[<%=j%>].value) > 60) {
          		alert('�뿩�Ⱓ�� 12����~60������ ������ �����մϴ�.');
          		return;
        	}  	
        	fm.r_tint_eb_yn[<%=j%>].value = 'N';
      	}
      
      	var r_ro_13_amt = toInt(parseDigit(fm.o_1.value)) * toFloat(fm.ro_13[<%=j%>].value) / 100;
      	var cha_line_amt = toInt(parseDigit(fm.o_1.value)) * 0.05 / 100;
      
      	if (fm.a_a[<%=j%>].value == '11' || fm.a_a[<%=j%>].value == '12') {
	        if (fm.ls_yn.value == 'Y') {
	          	r_ro_13_amt = toInt(parseDigit(fm.o_12.value)) * toFloat(fm.ro_13[<%=j%>].value) / 100;
	          	cha_line_amt = toInt(parseDigit(fm.o_12.value)) * 0.05 / 100;
	        }
      	} 
      
      	var r_cha_ro_13_amt = toInt(parseDigit(fm.ro_13_amt[<%=j%>].value))-r_ro_13_amt;
      
      	if (r_cha_ro_13_amt > cha_line_amt || r_cha_ro_13_amt < -cha_line_amt) {
      		alert('������ �����ܰ����� ����� �ݾװ� �����ܰ��ݾ��� �ٸ��ϴ�. Ȯ���Ͻʽÿ�.');
      		return;
      	}
      
		// ������ ���� 2018.01.10
		<%-- 
		var regex = "/,/gi";
		if (fm.jg_g_7.value == '3' || fm.jg_g_7.value == '4') {		// ������,������ �� ���
			var deposit = fm.o_1.value.replace(/,/gi,'') - fm.ecar_pur_sub_amt.value;		// �������� �������� - ���ź�����
			var rg_8_amt_replace = fm.rg_8_amt[<%=j%>].value.replace(/,/gi,'');		// ������ �ݾ�
			if (rg_8_amt_replace > deposit) {
				alert('�������� '+numberWithCommas(deposit)+'�� (�������� - ���ź�����) �̳��� ���� �����մϴ�. \n\n�߰��� �ʱⳳ�Ա� ���θ� ���� ��� ���������� �����Ͻø� �˴ϴ�.');
				return;
			}
		} else {		// �������� �ƴ� ��� ������ ���� 100% ����		2018.01.04
			var normal_car_rg8 = fm.rg_8_amt[<%=j%>].value.replace(/,/gi,'');		// �����ݾ�
			var normal_car_total = fm.o_1.value.replace(/,/gi,'');								// ��������
			if (Number(normal_car_rg8) > Number(normal_car_total)) {
				alert('�������� ������ 100% �̳��� ���� �����մϴ�. \n\n�߰��� �ʱⳳ�Ա� ���θ� ���� ��� ���������� �����Ͻø� �˴ϴ�.');
				return;
			}
		} 
		--%>
      
      	//������å�� ����
      	if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
      		if (parseDigit(fm.car_ja[<%=j%>].value) != '500000') {
      			alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      		}
      	} else {
      		if (parseDigit(fm.car_ja[<%=j%>].value) == '300000' || parseDigit(fm.car_ja[<%=j%>].value) == '200000' || parseDigit(fm.car_ja[<%=j%>].value) == '100000') {
      		} else {
      			alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      		}
      	}
      	
		//���λ�����϶� �������� �Ǿ������� ���� �Ǵ� �̰������� �����ϵ��� ����
        if (doc_type_value == "2") {
    	    if (fm.com_emp_yn[<%=j%>].value == "") {
    	    	alert("������ ��������Ư�� ���� ���θ� �������ּ���.\n\n���ǽŰ�Ȯ�δ����, ���������� ���λ���ڴ� 2021��1��1�� ���ĺ��� ���������ڵ������迡 �����Ͽ��� �մϴ�. ��, ����ں� 1��� ���������ڵ������� ���Դ�󿡼� ����, 1�븦 ������ ������ ���� ���������ڵ������� �̰��� �� ����� 50%�� �����˴ϴ�.\n\n�ڼ��� ������ Ȩ������ �ϴ� [�պ�ó�� ����]�� �������ּ���.");
    			return;
    	  	}
        }
      	
    }
    
    <%if (!(nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
    if (Number(fm.jg_code.value) > 9000000 && Number(fm.jg_code.value) < 9036000) {	
    	if (Number(fm.agree_dist[<%=j%>].value.replace(/,/g,"")) < 5000 || Number(fm.agree_dist[<%=j%>].value.replace(/,/g,"")) > 60000) {
    		alert("���� ��������Ÿ� �ִ밪�� �ʰ��Ͽ� �Է��Ͽ����ϴ�.\n\n* ������ ���� ��������Ÿ� �ִ밪\n- ��Ÿ���� �� �� Ʈ�� : 5,000 ~ 60,000km/�� ����\n- �׿����� : 5,000 ~ 50,000km/�� ����");
    		return;
    	}
    } else {
    	if (Number(fm.agree_dist[<%=j%>].value.replace(/,/g,"")) < 5000 || Number(fm.agree_dist[<%=j%>].value.replace(/,/g,"")) > 50000) {
    		alert("���� ��������Ÿ� �ִ밪�� �ʰ��Ͽ� �Է��Ͽ����ϴ�.\n\n* ������ ���� ��������Ÿ� �ִ밪\n- ��Ÿ���� �� �� Ʈ�� : 5,000 ~ 60,000km/�� ����\n- �׿����� : 5,000 ~ 50,000km/�� ����");
    		return;
    	}
    }
    <%}%>
    
<%}%>
    
    if (est_yn_count == 0) {
    	alert("���õ� ������ �����ϴ�. ������ ������ �ּ���.");
    	return;
    }
    
    //�������� �ɼ�,���󰡰� ������ ����.
    if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
    	//if (toInt(parseDigit(fm.opt_amt.value)) > 0) {    alert('�������� �ɼǱݾ��� �߰��Ǹ� ������ �� �����ϴ�.');      return; }
      	//if (toInt(parseDigit(fm.col_amt.value)) > 0) {    alert('�������� ����ݾ��� �߰��Ǹ� ������ �� �����ϴ�.');      return; }
      	if (toInt(parseDigit(fm.dc_amt.value)) > 0) {     
      		alert('�������� ������DC�ݾ��� �߰��Ǹ� ������ �� �����ϴ�.');
      		return;
      	}
    }
    
    //�������� �����϶� �Ǻ����ڴ� �Ƹ���ī�� �� �� ����.
    <%-- 
    if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
    	var ins_per_count = 0;
    	<%for (int z = 0; z < 4; z++) {%>
		if (fm.est_yn[<%=z%>].checked ==true) {
			if (fm.a_a[<%=z%>].value == '12' || fm.a_a[<%=z%>].value == '11') {				
				if (fm.ins_per[<%=z%>].value == "1") {					
					ins_per_count++;
				}
			}
		}
  		<%}%>
  		
  		if (ins_per_count != 0) {
  			alert("������ ������ ���Ǻ����ڷ� �����ؾ� �մϴ�.");
  			return;
  		}
    } 
    --%>
    
  	//Ʈ���Ϲݽ� �Ұ�-20190829
	if ((toInt(jg_code) > 9120 && toInt(jg_code) < 9410) || (toInt(jg_code) > 9015410 && toInt(jg_code) < 9045010)) {
		var truck_count = 0;
    	<%for (int z = 0; z < 4; z++) {%>		
		if (fm.a_a[<%=z%>].value == '11' || fm.a_a[<%=z%>].value == '21') {
			truck_count++;
		}		
  		<%}%>
  		
  		if (truck_count != 0) {
  			alert("Ʈ���� �Ϲݽ� ������ ���� �ʽ��ϴ�.");
  			return;
  		}
	}
    
    if (ins_confirm == 'Y') {
    	alert('�빰 �����ѵ� 5����� ��༭ �ۼ����� ����ī�������տ� �̸� ������ �޾ƾ� �մϴ�.');     
    }

    //������ ������������ ��Ʈ�� ������ ��� �����Ҽ� ����.
    if (fm.print_type[1].checked == true && toInt(parseDigit(fm.car_comp_id.value)) > 5) {
    	var r_cnt = 0;
    	var l_cnt = 0;
    	<%for (int j = 0; j < 4; j++) {%>
   		if (fm.est_yn[<%=j%>].checked ==true) {
   			if (fm.a_a[<%=j%>].value == '22' || fm.a_a[<%=j%>].value == '21') r_cnt++;
   			if (fm.a_a[<%=j%>].value == '12' || fm.a_a[<%=j%>].value == '11') l_cnt++;
   		}
      	<%}%>
     	if (r_cnt>0 && l_cnt>0) {
      		alert('������ ���տ��� ������ ������ ��Ʈ/���� ȥ�հ����� �Ұ����մϴ�.');   return; 
      	}
    } 
    
<%for (int j = 0; j < 4; j++) {%>
	// ������ð� ��޽����� ��� üũ �� �� ����. 2017.12.18
<%--     if (fm.tint_s_yn[<%=j%>].checked && fm.tint_ps_yn[<%=j%>].checked) { --%>
//     	alert('������ð� ��޽��� �� �ϳ��� üũ�ϼ���.'); return;
//     }
	
	// ��޽���(��������)�� ������� �̽ð� ������ �Բ� üũ�� �� ����. 2021.09.13
	if( fm.tint_ps_yn[<%=j%>].checked && fm.tint_sn_yn[<%=j%>].checked ){
		alert('��޽���(��������) ���ý� ������� �̽ð� ������ ������ �ݿ��ǹǷ� ��޽���(��������)�� ������� �̽ð� ������ ���ÿ� ������ �ʿ䰡 �����ϴ�.\n��޽���(��������) üũ�� ������� �̽ð� ���� üũ�� Ǯ���ּ���.');
		return;
	}
    
    // ��޽��� üũ �� �����ݿ� �ݾ��� 0���� �� ����.
    if (fm.tint_ps_yn[<%=j%>].checked && uncomma(fm.tint_ps_amt[<%=j%>].value) < 1) {
    	alert('��޽��� �ݾ��� �Է��ϼ���.'); return;
    }
    
    // ��޽��� üũ �� �����ݿ� �ݾ��� 50���� �̻��� �� ����.
    if (fm.tint_ps_yn[<%=j%>].checked && uncomma(fm.tint_ps_amt[<%=j%>].value) > 500000) {
    	alert('��޽��� �ִ��ѵ� �����ݾ��� 50���� �Դϴ�.\n50���� �ʰ����� ���ú���� ���δ��Դϴ�.\n(�ߵ������� �ܰ� ��ġ�� �������� ���ϸ鼭 ����� ó���Ǹ� ����)'); return;
    }
<%}%>
    
	if (fm.badcust_chk.value == '') {
		//alert('�ҷ��� Ȯ���� �Ͻʽÿ�.'); 	return;		
		//window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.est_nm.value+'&est_tel='+fm.est_tel.value+'&est_mail='+fm.est_email.value+'&est_fax='+fm.est_fax.value, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
		//return;
	}
			
	// ������ ������DC ������� �� ���� �ݿ� ������ �ް� ���� ���� �ٸ���� �˸�â
	var temp_bigo = fm.bigo.value;
	var replace_bigo = temp_bigo.replace(/[^0-9]/g,"");
	
	var today = new Date();
	var get_mm = today.getMonth()+1;
	
	if (temp_bigo != "") {
		if (replace_bigo != get_mm) {
			alert("���������� ���� ���� �ݿ� ���� �ٸ��ϴ�. \n\n����ڿ��� Ȯ�� ��Ź�帳�ϴ�.");
		}
	}
	
	//if (!confirm('�����Ͻðڽ��ϱ�?')) { return; }
	
	// ������ disabled ����	
	$("#est_yn_1").attr("disabled", false);
	$("#est_yn_2").attr("disabled", false);
	
	fm.return_select[0].disabled = false;
	fm.return_select[1].disabled = false;	
	fm.return_select[2].disabled = false;	
	fm.return_select[3].disabled = false;
	
	fm.a_a[0].disabled = false;
	fm.a_a[1].disabled = false;	
	fm.a_a[2].disabled = false;	
	fm.a_a[3].disabled = false;
	
	fm.opt_chk[0].disabled = false;
	fm.opt_chk[1].disabled = false;
	fm.opt_chk[2].disabled = false;
	fm.opt_chk[3].disabled = false;
	
	//�뿩�Ⱓ
	$("#sel_a_b_2").attr("disabled", false); 
	$("#a_b_2").attr("disabled", false);
	//�����������Ÿ�
	$("#sel_agree_dist_2").attr("disabled", false);
	$("#agree_dist_2").attr("disabled", false);
	//������
	$("#sel_rg_8_2").attr("disabled", false);
	$("#rg_8_2").attr("disabled", false);
	$("#rg_8_amt_2").attr("disabled", false);
	//������
	$("#pp_per_2").attr("disabled", false);
	$("#pp_amt_2").attr("disabled", false);
	//���ô뿩��
	$("#g_10_2").attr("disabled", false);
	//��������
	$("#gi_per_2").attr("disabled", false);
	$("#gi_amt_2").attr("disabled", false);
	//��������
	$("#sel_o_11_2").attr("disabled", false);
	$("#o_11_2").attr("disabled", false);
	//�뿩��DC
	$("#fee_dc_per_2").attr("disabled", false);    
    
  	//�����ε�����
	$("#loc_st_1").attr("disabled", false);
	$("#loc_st_2").attr("disabled", false);
	$("#loc_st_3").attr("disabled", false);
	$("#loc_st_4").attr("disabled", false);
	
	// ��Ʈ, ����, ���� ���� �� disabled ó�� �׸� submit �� Ȱ��ȭ
	// ��Ʈ, ����, ���� ���� �� disabled ó�� �׸� submit �� Ȱ��ȭ
	var printType = fm.print_type.value;
	if(printType == 2 || printType == 3 || printType == 4){
		// �뿩��ǰ
		fm.a_a[0].disabled = false;
		fm.a_a[1].disabled = false;
		fm.a_a[2].disabled = false;
		fm.a_a[3].disabled = false;
		      
		// ���Կɼ� �׸� ��Ȱ��ȭ
		fm.opt_chk[0].disabled = false;
		fm.opt_chk[1].disabled = false;
		fm.opt_chk[2].disabled = false;
		fm.opt_chk[3].disabled = false;
		
		for(var i=1; i<4; i++){
			// ��Ȱ��ȭ ����
			fm.sel_a_b[i].disabled = false;				// �뿩�Ⱓ
			fm.a_b[i].disabled = false;						// �뿩�Ⱓ
			fm.b_agree_dist[i].disabled = false;			// ǥ�� ��������Ÿ�
			fm.sel_agree_dist[i].disabled = false;		// ���� ��������Ÿ�
			fm.agree_dist[i].disabled = false;				// ���� ��������Ÿ�
			fm.b_o_13[i].disabled = false;					// ǥ�� �ִ��ܰ�
			fm.o_13[i].disabled = false;					// ǥ�� �ִ��ܰ�
			fm.ro_13[i].disabled = false;					// �����ܰ�
			fm.ro_13_amt[i].disabled = false;			// �����ܰ�
			
			// ���� 2, 3, 4 �׸� ���� 1 �� ����.
			// ������
			fm.sel_rg_8[i].value = fm.sel_rg_8[0].value;
			fm.rg_8[i].value = fm.rg_8[0].value;
			fm.rg_8_amt[i].value = fm.rg_8_amt[0].value;
			// ������
			fm.pp_per[i].value = fm.pp_per[0].value;
			fm.pp_amt[i].value = fm.pp_amt[0].value;
			
		}
	}
    
    var link = document.getElementById("submitLink");
	var originFunc = link.getAttribute("href");
	link.setAttribute('href', "javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
    fm.cmd.value = "i";
    fm.action = 'esti_mng_atype_i_a.jsp';
    fm.target = "i_no";    
    
    fm.submit();
    
    link.getAttribute('href', originFunc);
}
  
//badcust_chk�� confirm ��ü
function confirmDialog() {
	var fm = document.form1;
	var flag = false;
	for(var i=0; i<fm.o_13.length; i++){
		var o_13 = fm.o_13[i].value;
		var ro_13 = fm.ro_13[i].value;
		var fee_dc_per = fm.fee_dc_per[i].value;

		if( o_13-ro_13 > 3 && fee_dc_per > 0)	flag = true;
	}
	if(flag){
		alert('�����ܰ��� ������ ���� �뿩��� ������ �ݿ��Ǿ� �ִ� ���¿��� �߰����� �뿩�� D/C�� ������ �� �ֽ��ϴ�. �߰����� �뿩�� D/C �ݿ� �����Ͽ� ��������� ���ǰ� �ʿ��մϴ�.');
		<%if (!(nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
			return;
		<%}%>
	}
	
	/* if(fm.car_comp_id.value == '0056'){
		for(var i=0; i<fm.agree_dist.length; i++){
			var agree_dist = fm.agree_dist[i].value.replace(',', '');
			if(agree_dist < 10000 || agree_dist > 30000){
				alert('�׽��� ������ ��������Ÿ� 1~3��km�� �����մϴ�.');
				return;
			}
		}
	} */
	
	if (fm.badcust_chk.value == "Y") {
		dialog.open("<p style='text-align: center; font-size: 14px;'>���� �Ͻðڽ��ϱ�?</p>");
	} else {
		EstiReg();
	}
}

//�޸�Ǯ��
function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, "");
}
  
//��������-�⺻������ �ٷ� ó��
function EstiRegAuto() {
    var fm = document.form1;
    
    //20160701 �Ͻ�����
    <%if (AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) == 20160701) {%>
    	//alert('7��1�� �����Һ� �λ����� ���� �غ����Դϴ�. �����������α׷��� �̿��Ͽ� �ֽʽÿ�.');
    	//return;
    <%}%>
        
    var car_price = toInt(parseDigit(fm.o_1.value));
    
<%for (int j=0; j<4; j++) {%>
    	
    if (fm.est_yn[<%=j%>].checked ==true) {
      
<%-- 		if (fm.tint_s_yn[<%=j%>].checked ==true) fm.r_tint_s_yn[<%=j%>].value = 'Y'; --%>
		if (fm.tint_sn_yn[<%=j%>].checked ==true) fm.r_tint_sn_yn[<%=j%>].value = 'Y';
		
		if (fm.tint_ps_yn[<%=j%>].checked ==true) {	
			fm.r_tint_ps_yn[<%=j%>].value = 'Y';		// ��޽���
		    fm.r_tint_ps_nm[<%=j%>].value =	 fm.tint_ps_nm[<%=j%>].value;		// ��޽��� ����
			fm.r_tint_ps_amt[<%=j%>].value = fm.tint_ps_amt[<%=j%>].value;		// ��޽��� �߰��ݾ�(���ް�)
			fm.r_tint_ps_st[<%=j%>].value = fm.setTint_ps_sel[<%=j%>].value;	// ��޽��� ���ð�
		}
		
		if (fm.tint_cons_yn[<%=j%>].checked == true) {	
			fm.r_tint_cons_yn[<%=j%>].value = 'Y';
			fm.r_tint_cons_amt[<%=j%>].value = fm.tint_cons_amt[<%=j%>].value;		// �߰�Ź�۷�
		}
		
    	if (fm.tint_n_yn[<%=j%>].checked ==true) fm.r_tint_n_yn[<%=j%>].value = 'Y';
    	if (fm.tint_bn_yn[<%=j%>].checked ==true) fm.r_tint_bn_yn[<%=j%>].value = 'Y';
		if (fm.tint_eb_yn[<%=j%>].checked ==true) fm.r_tint_eb_yn[<%=j%>].value = 'Y';
		
<%-- 		if (fm.tint_s_yn[<%=j%>].checked ==false) fm.r_tint_s_yn[<%=j%>].value = 'N';		// ������� üũ ���� �� �� ���� �߰� 2017.12.27 --%>
		if (fm.tint_sn_yn[<%=j%>].checked ==false) fm.r_tint_sn_yn[<%=j%>].value = 'N';		// ������� �̽ð� ���� üũ ����
		if (fm.tint_ps_yn[<%=j%>].checked ==false) fm.r_tint_ps_yn[<%=j%>].value = 'N';	// ��޽��� üũ ���� �� �� ���� �߰� 2017.12.27
		if (fm.tint_n_yn[<%=j%>].checked ==false) fm.r_tint_n_yn[<%=j%>].value = 'N';		// ��ġ�� ������̼� üũ ���� �� �� ���� �߰� 2017.12.27
		if (fm.tint_cons_yn[<%=j%>].checked ==false) fm.r_tint_cons_yn[<%=j%>].value = 'N';	// �߰�Ź�۷� üũ ���� �� �� ���� �߰� 2020.06.15
		if (fm.tint_bn_yn[<%=j%>].checked ==false) fm.r_tint_bn_yn[<%=j%>].value = 'N';		// ���ڽ� ������ ���� (��Ʈ��ķ,������..)
		if (fm.tint_eb_yn[<%=j%>].checked ==false) fm.r_tint_eb_yn[<%=j%>].value = 'N';		// ��ġ�� ������̼� üũ ���� �� �� ���� �߰� 2017.12.27
		
    	fm.r_a_a[<%=j%>].value = fm.a_a[<%=j%>].value;
    	fm.r_ins_per[<%=j%>].value = fm.ins_per[<%=j%>].value;
    	fm.r_ins_dj[<%=j%>].value = fm.ins_dj[<%=j%>].value;
    	fm.r_ins_age[<%=j%>].value = fm.ins_age[<%=j%>].value;
    	fm.r_loc_st[<%=j%>].value = fm.loc_st[<%=j%>].value;
    	fm.r_ecar_loc_st[<%=j%>].value = fm.ecar_loc_st[<%=j%>].value;
    	<%-- fm.r_eco_e_tag[<%=j%>].value = fm.eco_e_tag[<%=j%>].value; --%>
    	fm.r_com_emp_yn[<%=j%>].value = fm.com_emp_yn[<%=j%>].value;
    	fm.r_new_license_plate[<%=j%>].value = fm.new_license_plate[<%=j%>].value;
      
<%--       	fm.rg_8[<%=j%>].value     = '25'; --%>
      
//       	if (car_price <= 45000000) {
<%-- 			fm.rg_8[<%=j%>].value     = '20'; --%>
//       	} 

		//�������� �⺻ �����ݿ��� 10% ���ش�
      	/* if (fm.jg_g_7.value == '3') { */
      	if (fm.jg_b.value == '5') {
<%--       		fm.rg_8[<%=j%>].value = toInt(fm.rg_8[<%=j%>].value)-10;      	 --%>
      		//�������� �⺻ �����ݿ��� 15% ���ش�
      	/* else if (fm.jg_g_7.value == '4') { */
      	} else if (fm.jg_b.value == '6') {
<%--       		fm.rg_8[<%=j%>].value     = toInt(fm.rg_8[<%=j%>].value)-15;      	 --%>
      	} else {
			fm.r_tint_eb_yn[<%=j%>].value = 'N';
      	}
      	
     	// �⺻������ ���� ���� 2021.07.09.
        if(Number($("#car_comp_id option:selected").val()) > 5){ // ������
<%--         	if (Number(fm.jg_g_7.value) > 2) 	fm.rg_8[<%=j%>].value = 15;	// ģȯ���� ���л� ����/������ --%>
<%--         	else 												fm.rg_8[<%=j%>].value = 25; --%>
        	fm.rg_8[<%=j%>].value = 25;
        } else{	// ������
<%--         	if (Number(fm.jg_g_7.value) > 2) 	fm.rg_8[<%=j%>].value = 10;	// ģȯ���� ���л� ����/������ --%>
<%--         	else 												fm.rg_8[<%=j%>].value = 20; --%>
        	fm.rg_8[<%=j%>].value = 20;
        } 
     	// ģȯ���� ���л� �������鼭 �������� �հ� �ݾ��� 8õ���� �ʰ� �� +10%, 6500���� ������ +5%, 6500���� ���ϸ� �״��.
     	// ģȯ���� ���л� �������鼭 �������� 7500���� ���ϸ� -5%  2022.05.06.
        if (fm.jg_g_7.value == '3') {
        	<%-- if(car_price > 80000000)			fm.rg_8[<%=j%>].value = Number(fm.rg_8[<%=j%>].value) + 10;
    		else if(car_price > 65000000) 	fm.rg_8[<%=j%>].value = Number(fm.rg_8[<%=j%>].value) + 5; --%>
    		if(car_price <= 75000000)	 fm.rg_8[<%=j%>].value = Number(fm.rg_8[<%=j%>].value) - 5;
        }
     	// �������� -5%
     	if(fm.jg_g_7.value == '4'){
     		fm.rg_8[<%=j%>].value = Number(fm.rg_8[<%=j%>].value) - 5;
     	}
                  
      	fm.rg_8_amt[<%=j%>].value   = parseDecimal(car_price * toFloat(fm.rg_8[<%=j%>].value) /100 );
      
      	if (fm.a_a[<%=j%>].value == '22' || fm.a_a[<%=j%>].value == '21') {
        	if (fm.jg_h.value != '1') {
          		alert('��Ʈ������� �ƴմϴ�.');
          		return;
        	} 
        	//24���� ��Ʈ�����ȵ�
        	if (fm.ins_age[<%=j%>].value == '3') {
          		alert('�������� ��24���̻��� ������ �����մϴ�.');
          		return;
        	}
		} else {
			if (fm.jg_i.value != '1') {
				alert('����������� �ƴմϴ�.');
          		return;
			}
      	} 
      
      	//������å�� ����
      	if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
      		if (parseDigit(fm.car_ja[<%=j%>].value) != '500000') {
      			alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      		}
      	} else {
      		if (parseDigit(fm.car_ja[<%=j%>].value) == '300000' || parseDigit(fm.car_ja[<%=j%>].value) == '200000' || parseDigit(fm.car_ja[<%=j%>].value) == '100000') {
      		} else {
      			alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      		}
      	}
    }
<%}%>
    
	if (fm.badcust_chk.value == '') {
		//alert('�ҷ��� Ȯ���� �Ͻʽÿ�.'); 	return;			
		//window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.est_nm.value+'&est_tel='+fm.est_tel.value+'&est_mail='+fm.est_email.value+'&est_fax='+fm.est_fax.value, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
		//return;
	}
			    
    fm.cmd.value = "i";
    fm.action = 'esti_mng_atype_i_a.jsp';
    fm.target = "i_no";    
    fm.submit();
    
}
    
//�ҷ��� 
function view_badcust()
{
	var fm = document.form1;
    if (fm.est_nm.value == '') {
    	alert('��/��ȣ�� �Է��Ͻʽÿ�');
    	fm.est_nm.focus();
    	return;
    }	
	window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.est_nm.value+'&est_tel='+fm.est_tel.value+'&est_mail='+fm.est_email.value+'&est_fax='+fm.est_fax.value, "BADCUST", "left=10, top=10, width=1400, height=900, resizable=yes, scrollbars=yes, status=yes");
	return;
}	    
  
//��������� ����
function dlv_con_commi() {
    var fm = document.form1;
    if (fm.code.value == '') {    alert('������ �����Ͻʽÿ�');       return; }
    if (fm.car_id.value == '') {    alert('������ �����Ͻʽÿ�');       return; }
    if (fm.car_amt.value == '') {     alert('���������� Ȯ���Ͻʽÿ�');     return; }   
    
    window.open('about:blank', "DlvConCommi", "left=0, top=0, width=500, height=600, scrollbars=yes, status=yes, resizable=yes");   
    
    fm.target = "DlvConCommi";        
    fm.action = 'view_dlv_con_commi.jsp';   
    fm.submit();  
}

//��üŹ�۷� ��ȸ
function search_cons_cost(){
	var fm = document.form1;
	
	var car_comp_id = $("#car_comp_id option:selected").val();
	
	if (car_comp_id == '') {    alert('�����縦 �����Ͻʽÿ�');       return; }
	if (car_comp_id == '0001' || car_comp_id == '0002') {   
		
		window.open('about:blank', "SearchConsCost", "left=0, top=0, width=800, height=800, scrollbars=yes, status=yes, resizable=yes");		
	
		fm.target = "SearchConsCost";				
		fm.action = 'search_cons_cost.jsp';		
		fm.submit();	
	}
}
  
//����������� ���ý� �������� ����
function setO11() {
	var fm = document.form1;
  	
    //�񱳰����϶� - ������ ������ ������.
    if (fm.cmd.value == 're') {
    	
      	/* if (fm.caroff_emp_yn[1].checked ==true || fm.caroff_emp_yn[2].checked ==true) { */
        //��Ʈ �ִ������̸� ��Ʈ/���� �ִ�
        <%-- if ((<%=e_bean.getA_a()%>==22 || <%=e_bean.getA_a()%>==21) && <%=e_bean.getO_11()%>==fm.jg_f.value) {
         
          <%for (int j=0; j<4; j++) {%>
	          if (fm.est_yn[<%=j%>].checked ==true) {	              
	          	if (<%=j%> == 0) {fm.o_11[<%=j%>].value     = <%=e_bean.getO_11()%>;}
	          	if (<%=j%> == 1) {fm.o_11[<%=j%>].value     = <%=e_bean2.getO_11()%>;}
	          	if (<%=j%> == 2) {fm.o_11[<%=j%>].value     = <%=e_bean3.getO_11()%>;}
	          	if (<%=j%> == 3) {fm.o_11[<%=j%>].value     = <%=e_bean4.getO_11()%>;}	            		            	            
	          }
	        <%}%>
        //���� �ִ������̸� ��Ʈ/���� �ִ�  
        } else if ((<%=e_bean.getA_a()%>==12 || <%=e_bean.getA_a()%>==11) && <%=e_bean.getO_11()%>==fm.jg_g.value) {
          
          <%for (int j=0; j<4; j++) {%>
	          if (fm.est_yn[<%=j%>].checked ==true) {	              
	          	if (<%=j%> == 0) {fm.o_11[<%=j%>].value     = <%=e_bean.getO_11()%>;}
	          	if (<%=j%> == 1) {fm.o_11[<%=j%>].value     = <%=e_bean2.getO_11()%>;}
	          	if (<%=j%> == 2) {fm.o_11[<%=j%>].value     = <%=e_bean3.getO_11()%>;}
	          	if (<%=j%> == 3) {fm.o_11[<%=j%>].value     = <%=e_bean4.getO_11()%>;}	            		            	            
	          }
	        <%}%>
        //�ִ������� �ƴϸ� ������ ���� �״�� ����.                            
        } else {
                	  
        	  <%for (int j=0; j<4; j++) {%>
	            if (fm.est_yn[<%=j%>].checked ==true) {	              
	            	if (<%=j%> == 0) {fm.o_11[<%=j%>].value     = <%=e_bean.getO_11()%>;}
	            	if (<%=j%> == 1) {fm.o_11[<%=j%>].value     = <%=e_bean2.getO_11()%>;}
	            	if (<%=j%> == 2) {fm.o_11[<%=j%>].value     = <%=e_bean3.getO_11()%>;}
	            	if (<%=j%> == 3) {fm.o_11[<%=j%>].value     = <%=e_bean4.getO_11()%>;}	            		            	            
	            }
	          <%}%>
        } --%>
        
      <%-- } else {
        <%for (int j=0; j<4; j++) {%>
            fm.o_11[<%=j%>].value     = 0.0;            
        <%}%>             
      } --%>
      
		//������ ��Ʈ�����ÿ��� �������1 -4%
		if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
	   	<%for (int j = 0; j < 4; j++) {%>
			fm.fee_dc_per[<%=j%>].value = <%=e_bean.getFee_dc_per()%>;
			
			if (fm.a_a[<%=j%>].value == '22') {//��Ʈ
				fm.ins_per[<%=j%>].options[0].selected = true;
			} else if (fm.a_a[<%=j%>].value == '11' || fm.a_a[<%=j%>].value == '21') {//�ϹݽĺҰ�
				alert('�������� �Ϲݽ� ������ �ȵ˴ϴ�.');              
			 	fm.est_yn[<%=j%>].checked = false
				fm.ins_per[<%=j%>].options[0].selected = true;              
			} else {
			  	<%-- fm.ins_per[<%=j%>].options[1].selected = true; --%>
				fm.ins_per[<%=j%>].options[0].selected = true;
			}
			fm.car_ja[<%=j%>].value     = '500,000';
		<%}%>
		}
      
    //�ű԰����϶�
    } else {
		//������ ��Ʈ�����ÿ��� �������1 -4%
		if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
        <%for (int j = 0; j < 4; j++) {%>
			if (fm.a_a[<%=j%>].value == '22') {//��Ʈ
              	fm.ins_per[<%=j%>].options[0].selected = true;
            } else if (fm.a_a[<%=j%>].value == '11' || fm.a_a[<%=j%>].value == '21') {//�ϹݽĺҰ�
              	alert('�������� �Ϲݽ� ������ �ȵ˴ϴ�.');              
              	fm.est_yn[<%=j%>].checked = false
              	fm.ins_per[<%=j%>].options[0].selected = true;
              
            } else {
              	<%-- fm.ins_per[<%=j%>].options[1].selected = true; --%>
              	fm.ins_per[<%=j%>].options[0].selected = true;
            }
            fm.car_ja[<%=j%>].value     = '500,000';
		<%}%>
		} else {
        <%for (int j=0; j<4; j++) {%>
            fm.car_ja[<%=j%>].value     = '300,000';
        <%}%>       
      	}
   	}
}
  
  
//�μ���
function setEst_yn(print_type) {
	  
	//��ǰ��, ����������, ������ �μ� �ݳ� ������ ������ �����ư ����ǰ�
    if (print_type==1 || print_type==5 || print_type==6) {
    	$("#btn_copy2, #btn_copy3, #btn_copy4").css("display","");
    } else {
    	$("#btn_copy2, #btn_copy3, #btn_copy4").css("display","none");
    }
	
    var fm = document.form1;
    var jg_g_7 = fm.jg_g_7.value;
    
    //�μ��� set value
    $('input:radio[name="print_type"][value="'+print_type+'"]').prop('checked', true);
    
    if (print_type == 6) {
    	
    	tr_ecar_return.style.display = "";

    	ro_13_1_display_1.style.display = "none";
    	ro_13_1_display_2.style.display = "";
    	
    	fm.print_type[0].disabled = true;
		fm.print_type[1].disabled = true;
		fm.print_type[2].disabled = true;
		fm.print_type[3].disabled = true;
		fm.print_type[4].disabled = true;
		fm.print_type[5].disabled = false;

		fm.return_select[0].disabled = true;
		fm.return_select[1].disabled = true;

		fm.a_a[0].options[0].disabled = true;
		fm.a_a[0].options[1].disabled = false;
		fm.a_a[0].options[2].disabled = true;
		fm.a_a[0].options[3].disabled = false;
		fm.a_a[0].options[4].disabled = true;
		
		fm.a_a[1].options[0].disabled = true;
		fm.a_a[1].options[1].disabled = false;
		fm.a_a[1].options[2].disabled = true;
		fm.a_a[1].options[3].disabled = false;
		fm.a_a[1].options[4].disabled = true;

		fm.opt_chk[0].disabled = true;
		fm.opt_chk[1].disabled = true;		
		fm.opt_chk[2].disabled = true;
		fm.opt_chk[3].disabled = true;
    	
		//�뿩�Ⱓ
		$("#sel_a_b_2").attr("disabled", true); 
		$("#a_b_2").attr("disabled", true);
		//�����������Ÿ�
		$("#sel_agree_dist_2").attr("disabled", true);
		$("#agree_dist_2").attr("disabled", true);
		//������
		$("#sel_rg_8_2").attr("disabled", true);
		$("#rg_8_2").attr("disabled", true);
		$("#rg_8_amt_2").attr("disabled", true);
		//������
		$("#pp_per_2").attr("disabled", true);
		$("#pp_amt_2").attr("disabled", true);
		//���ô뿩��
		$("#g_10_2").attr("disabled", true);
		//��������
		$("#gi_per_2").attr("disabled", true);
		$("#gi_amt_2").attr("disabled", true);
		//��������
		$("#sel_o_11_2").attr("disabled", true);
		$("#o_11_2").attr("disabled", true);
		//�뿩��DC
		$("#fee_dc_per_2").attr("disabled", true);
		
    } else {		
    	
    	tr_ecar_return.style.display = "none";

    	ro_13_0_display_1.style.display = "";
    	ro_13_0_display_2.style.display = "none";

    	ro_13_1_display_1.style.display = "";
    	ro_13_1_display_2.style.display = "none";

    	ro_13_2_display_1.style.display = "";
    	ro_13_2_display_2.style.display = "none";

    	ro_13_3_display_1.style.display = "";
    	ro_13_3_display_2.style.display = "none";
    	
    	fm.print_type[0].disabled = false;
		fm.print_type[1].disabled = false;
		fm.print_type[2].disabled = false;
		fm.print_type[3].disabled = false;
		fm.print_type[4].disabled = false;
		fm.print_type[5].disabled = true;

		fm.return_select[0].disabled = false;
		fm.return_select[1].disabled = false;

		for (var i = 0; i <= 3; i++) {
			
			//���Կɼ� ��Ȱ��ȭ �ϰ� ó��
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
    	
		//�뿩�Ⱓ
		var car_comp_id = $("#car_comp_id option:selected").val();
		/* if (car_comp_id == "0056") {
			$("#sel_a_b_2").attr("disabled", true); 
			$("#a_b_2").attr("readonly", true);
		} else {
			$("#sel_a_b_2").attr("disabled", false); 
			$("#a_b_2").attr("readonly", false);
		} */
		$("#sel_a_b_2").attr("disabled", false); 
		$("#a_b_2").attr("disabled", false);
		
		//�����������Ÿ�
		/* if (car_comp_id == "0056") {
			$("#sel_agree_dist_2").attr("disabled", true);
			$("#agree_dist_2").attr("readonly", true);	
		} else {
			$("#sel_agree_dist_2").attr("disabled", false);
			$("#agree_dist_2").attr("readonly", false);
		} */
		$("#sel_agree_dist_2").attr("disabled", false);
		$("#agree_dist_2").attr("disabled", false);
		
		//������
		$("#sel_rg_8_2").attr("disabled", false);
		$("#rg_8_2").attr("disabled", false);
		$("#rg_8_amt_2").attr("disabled", false);
		//������
		$("#pp_per_2").attr("disabled", false);
		$("#pp_amt_2").attr("disabled", false);
		//���ô뿩��
		$("#g_10_2").attr("disabled", false);
		//��������
		$("#gi_per_2").attr("disabled", true);
		$("#gi_amt_2").attr("disabled", true);
		//��������
		$("#sel_o_11_2").attr("disabled", false);
		$("#o_11_2").attr("disabled", false);
		//�뿩��DC
		$("#fee_dc_per_2").attr("disabled", false);
		
    }
    
    if (fm.car_id.value == '') {  alert('������ �����Ͻʽÿ�');     return; }
    if (fm.car_amt.value == '') {   alert('�����ݾ��� Ȯ���Ͻʽÿ�');   return; }     
    
    if (print_type == 1 || print_type == 5 || print_type==6) {
      fm.a_a[0].disabled = false;
      fm.a_a[1].disabled = false;
      fm.a_a[2].disabled = false;
      fm.a_a[3].disabled = false;
    } else {
      fm.a_a[0].disabled = true;
      fm.a_a[1].disabled = true;
      fm.a_a[2].disabled = true;
      fm.a_a[3].disabled = true;
    }
    
    //�׽��� readonly
    /* if (car_comp_id == "0056") {    	
	    fm.a_b[0].readOnly = true;
	    fm.a_b[1].readOnly = true;
	    fm.a_b[2].readOnly = true;
	    fm.a_b[3].readOnly = true;
    } else {    	
	    fm.a_b[0].readOnly = false;   // readonly ����
	    fm.a_b[1].readOnly = false;   // readonly ����
	    fm.a_b[2].readOnly = false;   // readonly ����
	    fm.a_b[3].readOnly = false;   // readonly ����
    } */
    
    /* fm.a_b[0].readOnly = false;   // readonly ����
    fm.a_b[1].readOnly = false;   // readonly ����
    fm.a_b[2].readOnly = false;   // readonly ����
    fm.a_b[3].readOnly = false;   // readonly ���� */
    
    //��ǰ��
    if (print_type == 1 || print_type == 5) {
		var car_comp_id = $("#car_comp_id option:selected").val();
      	var jg_code = fm.jg_code.value;
      	var jgG7 = fm.jg_g_7.value;
      	
  		fm.est_yn[0].checked = true;
   		fm.est_yn[1].checked = false;
   		fm.est_yn[2].checked = false;
   		fm.est_yn[3].checked = false;
   		fm.a_a[1].value = '';
   		fm.a_a[2].value = '';
   		fm.a_a[3].value = ''; 
   		SelectA_a(0);
   		setO11();
      
      	if (jgG7 == "3" || jgG7 == "4") {
   		  	if (jg_code == "5866" || jg_code == "6316111") {
   			  	searchO13(0);
   		  	}
      	} else {
    	  	searchO13(0);
      	}
      
    //�μ��ݳ�������
    } else if (print_type==6) {
      	fm.est_yn[0].checked = true;
   	  	fm.est_yn[1].checked = true;
   	  <%if (e_bean3.getReturn_select().equals("")) {%>
		      fm.est_yn[2].checked = false;
   	  <%} else {%>
   			  fm.est_yn[2].checked = true;
   	  <%}%>
   	  
   	  <%if (e_bean4.getReturn_select().equals("")) {%>
   			  fm.est_yn[3].checked = false;
   	  <%} else {%>
   			  fm.est_yn[3].checked = true;
   	  <%}%>
   	  
   	  <%if (e_bean2.getA_a().equals("")) {%>
   			  fm.a_a[1].value = '';
	  <%}%>
	  
// 	  	if (Number($("#car_comp_id option:selected").val()) <= 5) {
// 		  	fm.rg_8[0].value = '20';
// 	  	} else {
// 		  	fm.rg_8[0].value = '25';
// 	  	}
	  
//       	fm.rg_8[0].value = toInt(fm.rg_8[0].value)-10;
      	
     	// �⺻������ ���� ���� 2021.07.09.
        if(Number($("#car_comp_id option:selected").val()) > 5){ // ������
//         	if (Number(fm.jg_g_7.value) > 2) 	fm.rg_8[0].value = 15;	// ģȯ���� ���л� ����/������
//         	else 												fm.rg_8[0].value = 25;
        	fm.rg_8[0].value = 25;
        } else{	// ������
//         	if (Number(fm.jg_g_7.value) > 2) 	fm.rg_8[0].value = 10;	// ģȯ���� ���л� ����/������
//         	else 												fm.rg_8[0].value = 20;
        	fm.rg_8[0].value = 20;
        } 
        	
     	// ģȯ���� ���л� �������鼭 �������� �հ� �ݾ��� 8õ���� �ʰ� �� +10%, 6500���� ������ +5%, 6500���� ���ϸ� �״��.
     	// �������鼭 �������� 7500 ���ϸ� -5%
        if (fm.jg_g_7.value == '3'){
//         	if(car_price > 80000000)			fm.rg_8[0].value = Number(fm.rg_8[0].value) + 10;
//     		else if(car_price > 65000000) 	fm.rg_8[0].value = Number(fm.rg_8[0].value) + 5;
        	if(car_price <= 75000000)			fm.rg_8[0].value = Number(fm.rg_8[0].value) - 5;
        }
     	// �������� -5%
     	if(fm.jg_g_7.value == '4'){
     		fm.rg_8[0].value = Number(fm.rg_8[0].value) - 5;
     	}
      	$("#sel_rg_8_"+1+" option[value='"+fm.rg_8[0].value+"']").prop("selected",true);
      
      	//fm.a_a[2].value = '';
      	//fm.a_a[3].value = ''; 
      	SelectA_a(0);
      	return_type(2);
      	return_type(3);
      	//setO11(); 
      
      	//searchO13(0);
	  	//searchO13(1);
      
    //��Ʈ
   	} /* else if (print_type == 2) {
		fm.est_yn[0].checked = true;
		fm.est_yn[1].checked = true;
		fm.est_yn[2].checked = false;
		fm.est_yn[3].checked = false;
		fm.a_a[0].value = '22';
		fm.a_a[1].value = '21';
		fm.a_a[2].value = '';
		fm.a_a[3].value = ''; 
		document.querySelector('#ins_age_1 option[value="3"]').style.display = 'none';
		document.querySelector('#ins_age_2 option[value="3"]').style.display = 'none';
		document.querySelector('#ins_age_3 option[value="3"]').style.display = 'none';
		document.querySelector('#ins_age_4 option[value="3"]').style.display = 'none';
		SelectA_a(0);
		SelectA_a(1);
		setO11();
		searchO13(0);
		searchO13(1);
		
    //����
    } else if (print_type == 3) {
		fm.est_yn[0].checked = true;
		fm.est_yn[1].checked = true;
		fm.est_yn[2].checked = false;
		fm.est_yn[3].checked = false;   
		fm.a_a[0].value = '12';
		fm.a_a[1].value = '11';     
		fm.a_a[2].value = '';
		fm.a_a[3].value = '';
		SelectA_a(0);
		SelectA_a(1);
		setO11();   
		searchO13(0);
		searchO13(1);       
    //����
    } else if (print_type == 4) {
		fm.est_yn[0].checked = true;
		fm.est_yn[1].checked = true;
		fm.est_yn[2].checked = true;
		fm.est_yn[3].checked = true;    
		fm.a_a[0].value = '22';
		fm.a_a[1].value = '21';
		fm.a_a[2].value = '12';
		fm.a_a[3].value = '11';
		SelectA_a(0);
		SelectA_a(1);
		SelectA_a(2);
		SelectA_a(3);
		setO11();   
		searchO13(0); 
		searchO13(1);
		searchO13(2);
		searchO13(3);
    } */
    
    // ��Ʈ, ����, ���� ����
    if( print_type == 2 || print_type == 3 || print_type == 4 ){
    	
    	if(print_type == 2){ // ��Ʈ
      		fm.est_yn[0].checked = true;
    		fm.est_yn[1].checked = true;
    		fm.est_yn[2].checked = false;
    		fm.est_yn[3].checked = false;
    		fm.a_a[0].value = '22';
    		fm.a_a[1].value = '21';
    		fm.a_a[2].value = '';
    		fm.a_a[3].value = ''; 
    		SelectA_a(0);
    		SelectA_a(1);
    		setO11();
    		searchO13(0);
    		searchO13(1);
    		
    		// ��Ʈ ���� �� �Ϻ� �׸� �̳���
    		var targets = document.querySelectorAll('.esti_target');
    		for(var i = 0; i < targets.length; i++){
    			var target = targets[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets2 = document.querySelectorAll('.esti_target2');
    		for(var i = 0; i < targets2.length; i++){
    			var target = targets2[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets3 = document.querySelectorAll('.esti_target3');
    		for(var i = 0; i < targets3.length; i++){
    			var target = targets3[i];
    			target.style.display = 'none';
    		}
    		
    		// ����1�� ���� ���� ���� ����
			document.getElementById('equal_condition2').style.display= 'table-cell';
			document.getElementById('equal_condition3').style.display= 'none';
			document.getElementById('equal_condition4').style.display= 'none';
			
			// ���� 3, 4 ����
			document.getElementById('rent-lease-target3').style.display= 'table-cell';
			document.getElementById('rent-lease-target4').style.display= 'table-cell';
			
      	} else if(print_type == 3){ // ����
      		fm.est_yn[0].checked = true;
    		fm.est_yn[1].checked = true;
    		fm.est_yn[2].checked = false;
    		fm.est_yn[3].checked = false; 
    		fm.a_a[0].value = '12';
    		fm.a_a[1].value = '11';     
    		fm.a_a[2].value = '';
    		fm.a_a[3].value = '';
    		SelectA_a(0);
    		SelectA_a(1);
    		setO11();
    		searchO13(0);
    		searchO13(1); 
    		
    		// ���� ���� �� �Ϻ� �׸� �̳���
    		var targets = document.querySelectorAll('.esti_target');
    		for(var i = 0; i < targets.length; i++){
    			var target = targets[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets2 = document.querySelectorAll('.esti_target2');
    		for(var i = 0; i < targets2.length; i++){
    			var target = targets2[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets3 = document.querySelectorAll('.esti_target3');
    		for(var i = 0; i < targets3.length; i++){
    			var target = targets3[i];
    			target.style.display = 'none';
    		}
    		
    		// ����1�� ���� ���� ���� ����
			document.getElementById('equal_condition2').style.display= 'table-cell';
			document.getElementById('equal_condition3').style.display= 'none';
			document.getElementById('equal_condition4').style.display= 'none';
			
			// ���� 3, 4 ����
			document.getElementById('rent-lease-target3').style.display= 'table-cell';
			document.getElementById('rent-lease-target4').style.display= 'table-cell';
			
      	} else if(print_type == 4){ // ����
      		fm.est_yn[0].checked = true;
    		fm.est_yn[1].checked = true;
    		fm.est_yn[2].checked = true;
    		fm.est_yn[3].checked = true;   
    		fm.a_a[0].value = '22';
    		fm.a_a[1].value = '21';
    		fm.a_a[2].value = '12';
    		fm.a_a[3].value = '11';
    		SelectA_a(0);
    		SelectA_a(1);
    		SelectA_a(2);
    		SelectA_a(3);
    		setO11();
    		searchO13(0); 
    		searchO13(1);
    		searchO13(2);
    		searchO13(3);
    		var targets = document.querySelectorAll('.esti_target');
    		for(var i = 0; i < targets.length; i++){
    			var target = targets[i];
//     			target.style.opacity = 1.0;
    			target.style.display = 'table-cell';
    		}
    		var targets2 = document.querySelectorAll('.esti_target2');
    		for(var i = 0; i < targets2.length; i++){
    			var target = targets2[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets3 = document.querySelectorAll('.esti_target3');
    		for(var i = 0; i < targets3.length; i++){
    			var target = targets3[i];
    			target.style.display = 'none';
    		}
    		
    		// ����1�� ���� ���� ���� ����
    		document.getElementById('equal_condition2').style.display= 'table-cell';
			document.getElementById('equal_condition3').style.display= 'table-cell';
			document.getElementById('equal_condition4').style.display= 'table-cell';
			
			// ���� 3, 4 ���� �׸� �̳���
			document.getElementById('rent-lease-target3').style.display= 'none';
			document.getElementById('rent-lease-target4').style.display= 'none';
      	}
    	
    	// �뿩��ǰ disabled ó��
        fm.a_a[0].disabled = true;
        fm.a_a[1].disabled = true;
        fm.a_a[2].disabled = true;
        fm.a_a[3].disabled = true;
        
	    // ���Կɼ� �׸� ��Ȱ��ȭ
		fm.opt_chk[0].disabled = true;
		fm.opt_chk[1].disabled = true;
		fm.opt_chk[2].disabled = true;
		fm.opt_chk[3].disabled = true;
		
		// ��Ʈ, ����, ���� ���� �� ����2, 3, 4 �����׸� ��Ȱ��ȭ
		for(var i=1; i<4; i++){
			fm.sel_a_b[i].disabled = true;				// �뿩�Ⱓ
			fm.a_b[i].disabled = true;					// �뿩�Ⱓ
			fm.b_agree_dist[i].disabled = true;		// ǥ�� ��������Ÿ�
			fm.sel_agree_dist[i].disabled = true;	// ���� ��������Ÿ�
			fm.agree_dist[i].disabled = true;			// �����������Ÿ�
			fm.b_o_13[i].disabled = true;				// ǥ�� �ִ��ܰ�
			fm.o_13[i].disabled = true;					// ���� �ִ��ܰ�
			fm.ro_13[i].disabled = true;				// �����ܰ�
			fm.ro_13_amt[i].disabled = true;			// �����ܰ�
		}
    } else {
    	var targets = document.querySelectorAll('.esti_target');
		for(var i = 0; i < targets.length; i++){
			var target = targets[i];
// 			target.style.opacity = 1.0;
			target.style.display = 'table-cell';
		}
		var targets2 = document.querySelectorAll('.esti_target2');
		for(var i = 0; i < targets2.length; i++){
			var target = targets2[i];
// 			target.style.opacity = 1.0;
			target.style.display = 'table-cell';
		}
		var targets3 = document.querySelectorAll('.esti_target3');
		for(var i = 0; i < targets3.length; i++){
			var target = targets3[i];
			target.style.display = 'table-cell';
		}
		document.getElementById('equal_condition2').style.display= 'none';
		document.getElementById('equal_condition3').style.display= 'none';
		document.getElementById('equal_condition4').style.display= 'none';
		
		// ���� 3, 4 ���� �׸� �̳���
		document.getElementById('rent-lease-target3').style.display= 'none';
		document.getElementById('rent-lease-target4').style.display= 'none';
		
		// ���Կɼ� �׸� ��Ȱ��ȭ ����
		fm.opt_chk[0].disabled = false;
		fm.opt_chk[1].disabled = false;
		fm.opt_chk[2].disabled = false;
		fm.opt_chk[3].disabled = false;
		
		// ��Ʈ, ����, ���� �� ���� �� ����2, 3, 4 �����׸� ��Ȱ��ȭ ����
		for(var i=1; i<4; i++){
			fm.sel_a_b[i].disabled = false;
			fm.a_b[i].disabled = false;
			fm.b_agree_dist[i].disabled = false;
			fm.sel_agree_dist[i].disabled = false;
			fm.agree_dist[i].disabled = false;
			fm.b_o_13[i].disabled = false;
			fm.o_13[i].disabled = false;
			fm.ro_13[i].disabled = false;
			fm.ro_13_amt[i].disabled = false;
		}
    }
    
    // ����������
    // ���� ��Ʈ, ����, ���� ���� �� ���������հ� ��� ����
    if (print_type == 5 || print_type == 2 || print_type == 3 || print_type == 4) {
   	<%for (int j=1; j<4; j++) {%>
		fm.ins_per[<%=j%>].disabled = true;
		fm.ins_dj[<%=j%>].disabled = true;
		fm.ins_age[<%=j%>].disabled = true;
		fm.car_ja[<%=j%>].readOnly = true;
<%--       	fm.tint_s_yn[<%=j%>].disabled = true; --%>
      	fm.tint_sn_yn[<%=j%>].disabled = true;
      	fm.tint_ps_yn[<%=j%>].disabled = true;		// ��޽���
      	fm.tint_ps_nm[<%=j%>].disabled = true;
      	fm.tint_ps_amt[<%=j%>].disabled = true;
      	fm.tint_ps_st[<%=j%>].disabled = true;
      	fm.tint_n_yn[<%=j%>].disabled = true;
      	fm.tint_bn_yn[<%=j%>].disabled = true;
		fm.new_license_plate[<%=j%>].disabled = true;
		fm.tint_cons_yn[<%=j%>].disabled = true;
		fm.tint_cons_amt[<%=j%>].disabled = true;
      	fm.tint_eb_yn[<%=j%>].disabled = true;
      	fm.loc_st[<%=j%>].disabled = true;
      	fm.ecar_loc_st[<%=j%>].disabled = true;
      	<%-- fm.eco_e_tag[<%=j%>].disabled = true; --%>
      	fm.com_emp_yn[<%=j%>].disabled = true;
      	fm.car_ja[<%=j%>].style.backgroundColor = 'e5e5e5';
      	fm.setTint_ps_sel[<%=j%>].disabled = true;
   	<%}%>
    //������
    } else if (print_type == 6) {
   	<%for (int j=1; j<4; j++) {%>
		fm.ins_per[<%=j%>].disabled = true;
		fm.ins_dj[<%=j%>].disabled = true;
		fm.ins_age[<%=j%>].disabled = true;
		fm.car_ja[<%=j%>].readOnly = true;
<%-- 		fm.tint_s_yn[<%=j%>].disabled = true; --%>
		fm.tint_sn_yn[<%=j%>].disabled = true;
		fm.tint_ps_yn[<%=j%>].disabled = true;		// ��޽���
		fm.tint_ps_nm[<%=j%>].disabled = true;
		fm.tint_ps_amt[<%=j%>].disabled = true;
		fm.tint_ps_st[<%=j%>].disabled = true;
		fm.tint_n_yn[<%=j%>].disabled = true;
		fm.tint_bn_yn[<%=j%>].disabled = true;
		fm.new_license_plate[<%=j%>].disabled = true;
		fm.tint_cons_yn[<%=j%>].disabled = true;
		fm.tint_cons_amt[<%=j%>].disabled = true;
		fm.tint_eb_yn[<%=j%>].disabled = true;
		fm.loc_st[<%=j%>].disabled = true;
		fm.ecar_loc_st[<%=j%>].disabled = true;
		<%-- fm.eco_e_tag[<%=j%>].disabled = true; --%>
		fm.com_emp_yn[<%=j%>].disabled = true;
		fm.car_ja[<%=j%>].style.backgroundColor = 'e5e5e5';
		fm.setTint_ps_sel[<%=j%>].disabled = true;
	<%}%>
    } else {
		var carCompId = $("#car_comp_id option:selected").val();
    	
   	<%for (int j=1; j<4; j++) {%>
   		fm.ins_per[<%=j%>].disabled = false;
   		fm.ins_dj[<%=j%>].disabled = false;
   		fm.ins_age[<%=j%>].disabled = false;
   		fm.car_ja[<%=j%>].readOnly = false;
<%--       	fm.tint_s_yn[<%=j%>].disabled = false; --%>
      	fm.tint_sn_yn[<%=j%>].disabled = false;
      	fm.tint_ps_yn[<%=j%>].disabled = false;		// ��޽���
      	fm.tint_ps_nm[<%=j%>].disabled = false;
      	fm.tint_ps_amt[<%=j%>].disabled = false;
      	fm.tint_ps_st[<%=j%>].disabled = false;
      	fm.tint_n_yn[<%=j%>].disabled = false;
      	fm.tint_bn_yn[<%=j%>].disabled = false;
		fm.new_license_plate[<%=j%>].disabled = false;
		fm.tint_cons_yn[<%=j%>].disabled = false;
		fm.tint_cons_amt[<%=j%>].disabled = false;
      	fm.tint_eb_yn[<%=j%>].disabled = false;
      	if (carCompId == "0056") {
      		fm.loc_st[<%=j%>].disabled = true;
      	} else {
	      	fm.loc_st[<%=j%>].disabled = false;
      	}
      	fm.ecar_loc_st[<%=j%>].disabled = false;
      	<%-- fm.eco_e_tag[<%=j%>].disabled = false; --%>
      	fm.com_emp_yn[<%=j%>].disabled = false;
      	fm.car_ja[<%=j%>].style.backgroundColor = 'white';
   	<%}%>
    }
    
<%for (int j=0; j<4; j++) {%>
   	fm.r_a_a[<%=j%>].value = fm.a_a[<%=j%>].value;
<%--    	fm.r_tint_s_yn[<%=j%>].value = fm.tint_s_yn[<%=j%>].value; --%>
   	fm.r_tint_sn_yn[<%=j%>].value = fm.tint_sn_yn[<%=j%>].value;
   	fm.r_tint_ps_yn[<%=j%>].value = fm.tint_ps_yn[<%=j%>].value;		// ��޽���
   	fm.r_tint_ps_nm[<%=j%>].value = fm.tint_ps_nm[<%=j%>].value;
   	fm.r_tint_ps_amt[<%=j%>].value = fm.tint_ps_amt[<%=j%>].value;
   	fm.r_tint_ps_st[<%=j%>].value = fm.setTint_ps_sel[<%=j%>].value;
   	fm.r_new_license_plate[<%=j%>].value = fm.new_license_plate[<%=j%>].value;
   	fm.r_tint_cons_yn[<%=j%>].value = fm.tint_cons_yn[<%=j%>].value;
   	fm.r_tint_cons_amt[<%=j%>].value = fm.tint_cons_amt[<%=j%>].value;
   	fm.r_tint_n_yn[<%=j%>].value = fm.tint_n_yn[<%=j%>].value;
   	fm.r_tint_bn_yn[<%=j%>].value = fm.tint_bn_yn[<%=j%>].value;
	fm.r_tint_cons_yn[<%=j%>].value = fm.tint_cons_yn[<%=j%>].value;
   	fm.r_tint_cons_amt[<%=j%>].value = fm.tint_cons_amt[<%=j%>].value;
   	fm.r_tint_eb_yn[<%=j%>].value = fm.tint_eb_yn[<%=j%>].value;
   	fm.r_ins_per[<%=j%>].value = fm.ins_per[<%=j%>].value;
   	fm.r_ins_dj[<%=j%>].value = fm.ins_dj[<%=j%>].value;
   	fm.r_ins_age[<%=j%>].value = fm.ins_age[<%=j%>].value;
   	fm.r_loc_st[<%=j%>].value = fm.loc_st[<%=j%>].value;
   	fm.r_ecar_loc_st[<%=j%>].value = fm.ecar_loc_st[<%=j%>].value;
   	<%-- fm.r_eco_e_tag[<%=j%>].value = fm.eco_e_tag[<%=j%>].value; --%>
   	fm.r_com_emp_yn[<%=j%>].value = fm.com_emp_yn[<%=j%>].value;
<%}%>    

}

//�������������뺸�� ���Կ���
function SetComEmpYn() {
	var fm = document.form1;
	
	var doc_type_value = $('input:radio[name="doc_type"]:checked').val();
	
	//Ư����� ���ǥ��_20201217
	/* if (doc_type_value != "1") {
		$("#doc_type_check_div").hide();
		//$('input:checkbox[name="dir_pur_commi_yn"]').attr("checked", "checked");
		$('input:checkbox[name="dir_pur_commi_yn"]').removeAttr("checked");
	} else {
		$("#doc_type_check_div").show();
	} */
	
	var com_emp_yn_html = "";
	
	if (doc_type_value == "1") {
		com_emp_yn_html = "<option value='N'>�̰���</option>"+
									"<option value='Y' selected>����</option>";
				
		$("#com_emp_yn_1").html(com_emp_yn_html);
		$("#com_emp_yn_2").html(com_emp_yn_html);
		$("#com_emp_yn_3").html(com_emp_yn_html);
		$("#com_emp_yn_4").html(com_emp_yn_html);
		
	} else if (doc_type_value == "2") {
		com_emp_yn_html = "<option value='' selected>����</option>"+
									"<option value='N'>�̰���</option>"+
									"<option value='Y'>����</option>";
									
		$("#com_emp_yn_1").html(com_emp_yn_html);
		$("#com_emp_yn_2").html(com_emp_yn_html);
		$("#com_emp_yn_3").html(com_emp_yn_html);
		$("#com_emp_yn_4").html(com_emp_yn_html);
	} else {
		com_emp_yn_html = "<option value='N' selected>�̰���</option>"+
									"<option value='Y'>����</option>";
					
		$("#com_emp_yn_1").html(com_emp_yn_html);
		$("#com_emp_yn_2").html(com_emp_yn_html);
		$("#com_emp_yn_3").html(com_emp_yn_html);
		$("#com_emp_yn_4").html(com_emp_yn_html);
	}
	
	// ������ ��������Ư�� ���� ���� ���� �����ڵ� ���ؿ��� �����Һз��ڵ� �������� ���� 2021.12.20.
// 	if ((toInt(fm.jg_code.value) > 1999 && toInt(fm.jg_code.value) < 7000) || (toInt(fm.jg_code.value) > 1999999 && toInt(fm.jg_code.value) < 7000000)) {
	var s_st_value = fm.s_st.value;
	if(toInt(s_st_value) > 101 && toInt(s_st_value) < 600 && toInt(s_st_value) != 409){	
		if (doc_type_value == "1" || doc_type_value == "2") {
		//if (fm.doc_type[0].checked == true) {
			
			//���̰�_�����϶��� �������, ���λ�����ϰ�� �ʱⰪ ����
			tr_com_emp_yn.style.display = "";
			
			if (doc_type_value == "2") {
				fm.com_emp_yn[0].value = "";
				fm.com_emp_yn[1].value = "";
				fm.com_emp_yn[2].value = "";
				fm.com_emp_yn[3].value = "";
			} else {
				fm.com_emp_yn[0].value = "Y";
				fm.com_emp_yn[1].value = "Y";
				fm.com_emp_yn[2].value = "Y";
				fm.com_emp_yn[3].value = "Y";
			}
			
		} else {
			//�Ⱥ��̰�
			tr_com_emp_yn.style.display='none';
			fm.com_emp_yn[0].value = "N";
			fm.com_emp_yn[1].value = "N";
			fm.com_emp_yn[2].value = "N";
			fm.com_emp_yn[3].value = "N";
		}
	} else {
		//�Ⱥ��̰�
		tr_com_emp_yn.style.display='none';
		fm.com_emp_yn[0].value = "N";
		fm.com_emp_yn[1].value = "N";
		fm.com_emp_yn[2].value = "N";
		fm.com_emp_yn[3].value = "N";
	}
}

//��纸�� ��ư(2018.01.18)
function view_spec() {
	var car_comp_id = $("#car_comp_id option:selected").val();
	var code = $("#code option:selected").val();
	var car_id = $("#car_id").val();
	var car_seq = $("#car_seq").val();
	var valus = "?car_comp_id="+car_comp_id+"&code="+code+"&car_id="+car_id+"&car_seq="+car_seq;
	if (code=="") { alert("������ �����Ͻʽÿ�.");	$("#code").focus();		return false;	}
	window.open("esti_mng_view_opt.jsp"+valus,"car_b_inc", "left=300, top=100, width=1000, height=900, scrollbars=yes");
}

//�뿩�Ⱓ �޺��ڽ� ����(2018.03.12)
function setA_b(num,val) {
	if (val=="36") {					$("#a_b_"+num).val("36");	}
	else if (val=="48") {				$("#a_b_"+num).val("48");	}
	else if (val=="60") {				$("#a_b_"+num).val("60");	}
	else if (val=="24") {				$("#a_b_"+num).val("24");	}
	else if (val=="directInput") {	$("#a_b_"+num).val("");		$("#a_b_"+num).focus();		}
} 

//���� ��������Ÿ� �޺��ڽ� ����(2018.03.12)
function setAgree_dist(num,val) {
	if (val==10000) {					$("#agree_dist_"+num).val("10,000");	}
	else if (val==15000) {			$("#agree_dist_"+num).val("15,000");	}
	else if (val==20000) {			$("#agree_dist_"+num).val("20,000");	}
	else if (val==23000) {			$("#agree_dist_"+num).val("23,000");	}
	else if (val==25000) {			$("#agree_dist_"+num).val("25,000");	}
	else if (val==28000) {			$("#agree_dist_"+num).val("28,000");	}
	else if (val==30000) {			$("#agree_dist_"+num).val("30,000");	}
	else if (val==35000) {			$("#agree_dist_"+num).val("35,000");	}
	else if (val==40000) {			$("#agree_dist_"+num).val("40,000");	}
	else if (val==45000) {			$("#agree_dist_"+num).val("45,000");	}
	else if (val==50000) {			$("#agree_dist_"+num).val("50,000");	}
	else if (val=="directInput") {	$("#agree_dist_"+num).val("");		$("#agree_dist_"+num).focus();	}
}

//������ �޺��ڽ� ����(2018.03.12)
function setRg_8(num,val) {
	if (val==0) {						$("#rg_8_"+num).val("0.0");		}
	else if (val==10) {				$("#rg_8_"+num).val("10.0");	}
	else if (val==15) {				$("#rg_8_"+num).val("15.0");	}
	else if (val==20) {				$("#rg_8_"+num).val("20.0");	}
	else if (val==25) {				$("#rg_8_"+num).val("25.0");	}
	else if (val==30) {				$("#rg_8_"+num).val("30.0");	}
	else if (val==35) {				$("#rg_8_"+num).val("35.0");	}
	else if (val==40) {				$("#rg_8_"+num).val("40.0");	}
	else if (val==50) {				$("#rg_8_"+num).val("50.0");	}
	else if (val=="directInput") {	$("#rg_8_"+num).val("");	$("#rg_8_"+num).focus();	}
	
	var fm = document.form1;
	fm.rg_8_amt[num-1].value  = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_1.value)) * toFloat(fm.rg_8[num-1].value) / 100, 1000 ));
    if (fm.a_a[num-1].value == '11' || fm.a_a[num-1].value == '12') {
      	if (fm.ls_yn.value == 'Y') {
        	fm.rg_8_amt[num-1].value = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_12.value)) * toFloat(fm.rg_8[num-1].value) / 100, 1000 ));
      	}
    }
}

//�������� �޺��ڽ� ����(2018.03.12)
function setO_11(num,val) {
	if (val==0) {						$("#o_11_"+num).val("0.0");	}
	else if (val==1) {				$("#o_11_"+num).val("1.0");	}
	else if (val==2) {				$("#o_11_"+num).val("2.0");	}
	else if (val==3) {				$("#o_11_"+num).val("3.0");	}
	else if (val=="directInput") {	$("#o_11_"+num).val("");	$("#o_11_"+num).focus();	}
}

//�ݿø�
function getCutRoundNumber(num, n) {
	var remove_price = num / n;   
    remove_price = Math.round(remove_price); 
    remove_price = remove_price * n;
    return remove_price;
}

//������ ���ּ��� ���濡 ���� �����ε����� ����
function setLoc_st(num, val) {
	
	/* if ($("#car_comp_id option:selected").val() == "0056") {
		document.form1.loc_st[num].value='1';
	} else { */
	document.form1.loc_st[num].value=toInt(val)+1;
	if (val == '7') document.form1.loc_st[num].value='4';
	if (val == '8') document.form1.loc_st[num].value='6';
	if (val == '9') document.form1.loc_st[num].value='7';
	if (val == '10') document.form1.loc_st[num].value='5';
	if (val == '11') document.form1.loc_st[num].value='2';	// ���������ּ��� ��� ���� �� �����ε����� ��õ/��� 2021.02.24. 
	if (val == '12') LocStSet();	// ������ ���ּ��� ������(�������������� ����) ���� �� �����ε������� ���� ������ ����Ʈ ������. 2021.11.02. 
	if (val == '13') LocStSet();	// ������ ���ּ��� ������ ���� ���� ���� �� �����ε������� ���� ������ ����Ʈ ������. 2021.12.13. 
	/* } */
}

//��ǰ-��޽��� ����Ʈ�ڽ� ����
function setTint_ps(num, val) {
	if (val=="I") {	$("#tint_ps_span"+num).html(" ������ǥ�⳻�� &nbsp;");	}
	else {			$("#tint_ps_span"+num).html(" FMSǥ��(�����)");	}
}

//����1 �⺻���ð� �����ϱ�(2018.05.30)
function copy_esti_1(num) {
	
	var fm = document.form1;	  
    var jg_g_7 = fm.jg_g_7.value;
    var jg_b = fm.jg_b.value;
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
	
	var print_type = $('input:radio[name="print_type"]:checked').val();
	
	$("#est_yn_"		+num).prop("checked", true);//���� üũ
	
	var return_select_val = $("#return_select_0 option:selected").val();
	
	
	$("#a_a_"+num+" option[value='"+ $("#a_a_1 option:selected").val() +"']").prop("selected", true);//�뿩��ǰ
	$('#a_a_'+num+' option[value=""]').prop('disabled', false);
	$('#a_a_'+num+' option[value="22"]').prop('disabled', false);
	$('#a_a_'+num+' option[value="21"]').prop('disabled', false);
	$('#a_a_'+num+' option[value="12"]').prop('disabled', false);
	$('#a_a_'+num+' option[value="11"]').prop('disabled', false);
		
	
	
	
	$("#sel_a_b_"	+num+" option[value='"+ $("#sel_a_b_1 	option:selected").val() +"']").prop("selected", true);//�뿩�Ⱓ �޺��ڽ�
	$("#a_b_"+num).val($("#a_b_1").val());//�뿩�Ⱓ
	$("#b_agree_dist_"	+num).val($("#b_agree_dist_1").val());//ǥ�ؾ�������Ÿ�
	$("#sel_agree_dist_"+num+" option[value='"+ $("#sel_agree_dist_1	option:selected").val() +"']").prop("selected", true);//�����������Ÿ� �޺��ڽ�
	$("#agree_dist_"	+num).val($("#agree_dist_1"	).val());//�����������Ÿ�
	$("#b_o_13_"		+num).val($("#b_o_13_1"		).val());//ǥ���ִ��ܰ�
	$("#o_13_"			+num).val($("#o_13_1"		).val());//�����ִ��ܰ�
	$("#ro_13_"			+num).val($("#ro_13_1"		).val());//�����ܰ�(%)
	$("#ro_13_amt_"		+num).val($("#ro_13_amt_1"	).val());//�����ܰ�(��)
	$("#sel_rg_8_"		+num+" option[value='"+ $("#sel_rg_8_1 	option:selected").val() +"']").prop("selected", true);//������ �޺��ڽ�
	$("#rg_8_"			+num).val($("#rg_8_1"		).val());	//������(%)
	$("#rg_8_amt_"		+num).val($("#rg_8_amt_1"	).val());	//������(��)
	$("#pp_per_"		+num).val($("#pp_per_1"		).val());	//������(%)
	$("#pp_amt_"		+num).val($("#pp_amt_1"		).val());	//������(��)
	$("#g_10_"			+num).val($("#g_10_1"		).val());	//���ô뿩��
	$("#com_emp_yn_"	+num+" option[value='"+ $("#com_emp_yn_1 option:selected").val() +"']").prop("selected", true);	//���������� ��������Ư�� �޺��ڽ�
	
	if (print_type!=5) {
		//����
		$("#ins_per_"		+num+" option[value='"+ $("#ins_per_1 	option:selected").val() +"']").prop("selected", true);	//�Ǻ����� �޺��ڽ�
		$("#ins_dj_"		+num+" option[value='"+ $("#ins_dj_1 	option:selected").val() +"']").prop("selected", true);	//�빰/�ڼ� �޺��ڽ�
		$("#ins_age_"		+num+" option[value='"+ $("#ins_age_1 	option:selected").val() +"']").prop("selected", true);	//�����ڿ��� �޺��ڽ�
		$("#car_ja"		+(num-1)).val($("#car_ja0"		).val());	//������å��
		$("#gi_per_"		+num).val($("#gi_per_1"		).val());	//��������(%)
		$("#gi_amt_"		+num).val($("#gi_amt_1"		).val());	//��������(��)
		//��ǰ
		$("#new_license_plate_"		+num+" option[value='"+ $("#new_license_plate_1 	option:selected").val() +"']").prop("selected", true);	
// 		if ($("#tint_s_yn_1"	).is(":checked")==true) {$("#tint_s_yn_" +num).prop("checked",true);	} else {$("#tint_s_yn_" +num).prop("checked",false);}	//�������
		if ($("#tint_ps_yn_1").is(":checked")==true) {$("#tint_ps_yn_"+num).prop("checked",true);	} else {$("#tint_ps_yn_"+num).prop("checked",false);}	//��޽���
		if ($("#tint_n_yn_1"	).is(":checked")==true) {$("#tint_n_yn_" +num).prop("checked",true);	} else {$("#tint_n_yn_" +num).prop("checked",false);}	//��ġ���׺���̼�
		if ($("#tint_sn_yn_1"	).is(":checked")==true) {$("#tint_sn_yn_" +num).prop("checked",true);	} else {$("#tint_sn_yn_" +num).prop("checked",false);}	//������� �̽ð� ����
		if ($("#tint_bn_yn_1"	).is(":checked")==true) {$("#tint_bn_yn_" +num).prop("checked",true);	} else {$("#tint_bn_yn_" +num).prop("checked",false);}	//���ڽ� ������ ���� (��Ʈ��ķ,������..)
		if ($("#tint_cons_yn_1"	).is(":checked")==true) {$("#tint_cons_yn_" +num).prop("checked",true);	} else {$("#tint_cons_yn_" +num).prop("checked",false);}	//�߰�Ź�۷�
		$("#tint_cons_amt_"	+num).val($("#tint_cons_amt_1").val());	//�߰�Ź�۷�
		if ($("#tint_eb_yn_1").is(":checked")==true) {$("#tint_eb_yn_"+num).prop("checked",true);	} else {$("#tint_eb_yn_"+num).prop("checked",false);}	//�̵���������(������)
		$("#setTint_ps_sel_"+num+" option[value='"+ $("#setTint_ps_sel_1 option:selected").val() +"']").prop("selected", true);	//��޽��� �޺��ڽ�
		$("#tint_ps_nm_"	+num).val($("#tint_ps_nm_1"	).val());	//��޽��� ������ ǥ�⳻��
		$("#tint_ps_amt_"	+num).val($("#tint_ps_amt_1").val());	//��޽��� �߰��ݾ�(���ް�)
		if ($("#setTint_ps_sel_1 option:selected").val()=='I') {	setTint_ps(num-1, 'I');	} else {	setTint_ps(num-1, '');	}	//��޽��� ǥ�⼱�ý� ����
		//�����ε�����
		$("#loc_st_"		+num+" option[value='"+ $("#loc_st_1 	option:selected").val() +"']").prop("selected", true);	//�����ε����� �޺��ڽ�
		//�������϶�-���������ּ���
		if (form1.jg_g_7.value == '3') {	
			$("#ecar_loc_st_"+num+" option[value='"+ $("#ecar_loc_st_1 option:selected").val() +"']").prop("selected", true);	//������ ���ּ��� �޺��ڽ�
		}
		//�������϶�-���������ּ���
		if (form1.jg_g_7.value == '4') {	
			$("#hcar_loc_st_"+num+" option[value='"+ $("#hcar_loc_st_1 option:selected").val() +"']").prop("selected", true);	//������ ���ּ��� �޺��ڽ�
		}
	}
	
	//if (form1.jg_b.value == '5' || form1.jg_b.value == '6') {	//������ ������ �������϶�
	//	$("#eco_e_tag_"	 +num+" option[value='"+ $("#eco_e_tag_1   option:selected").val() +"']").prop("selected", true);	//���� ���ｺƼĿ �߱� �޺��ڽ�
	//}
	
	$("#sel_o_11_"		+num+" option[value='"+ $("#sel_o_11_1 	option:selected").val() +"']").prop("selected", true);	//�������� �޺��ڽ�
	$("#o_11_"			+num).val($("#o_11_1"		).val());	//��������(%)
	$("#fee_dc_per_"	+num).val($("#fee_dc_per_1"	).val());	//�뿩��D/C
	
}

// �ű�_�������ϰ�� ����2,3,4�� ���� disable ������ ����1�� �����ϰ� ����
function set_disable_value() {
	
	var fm = document.form1;
    var jg_g_7 = fm.jg_g_7.value;
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
	
	var print_type = $('input:radio[name="print_type"]:checked').val();
		
	
	
}

//�ű�_������ �μ��ݳ� ��å�� �� �ݳ��� ������ ��� 2�� ������ 1�� ���� �ɼ��� ���󰣴�.
function set_return2_change() {
	
	var fm = document.form1;
    var jg_g_7 = fm.jg_g_7.value;
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
    
    
	
}

//�ű�_������ �μ��ݳ� ��å�� �� �ݳ��� ������ ��� 1������ �ִ��ܰ��� ��ȸ�� 2���������� ���� ��ȸ
function set_time() {
	var fm = document.form1;
    var jg_g_7 = fm.jg_g_7.value;
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
    
    
}

//�ű�_����3
function eh_chk(idx) {
	
	var check3_stat = $("#est_yn_3").is(":checked");
	var check4_stat = $("#est_yn_4").is(":checked");
	
	if (idx == "3") {		
		if (check4_stat == true) {
			alert("����4���� �ִ°�� ����3�� ������ �� �����ϴ�.");
			$("#est_yn_"+idx).prop("checked", true);
			return;
		}
	} else if (idx == "4") {
		if (check3_stat == false) {
			alert("����3�� ���� ������ �� ����4�� ������ �ּ���.");
			$("#est_yn_"+idx).prop("checked", false);
			return;
		}
	}
}

//�ű�_������ ��� - ��ü��� �� ����������(��ü��� ������)
function release_type() {
	var release_val = $(":input:radio[name=import_pur_st]:checked").val();	
	if (release_val == "1") {
		$("#import_content_2").show();
	} else {
		$("#import_content_2").hide();
		//��ü��� ���ý� �Ʒ� �Է°� �ʱ�ȭ
		$("#r_dc_amt").val("");
		$("#l_dc_amt").val("");
		
		$("#r_card_amt").val("");
		$("#l_card_amt").val("");
		
		$("#r_cash_back").val("");
		$("#l_cash_back").val("");
		
		$("#r_bank_amt").val("");
		$("#l_bank_amt").val("");
	}
}

//�ű�_Ư����� üũ�� �������� 0% �ʱ�ȭ �� ����
function dir_pur_change() {
	var dir_pur_commi_yn = $('input:checkbox[name="dir_pur_commi_yn"]:checked').val();
	
	if (dir_pur_commi_yn == "Y") {
		alert("Ư����� ���ý� ���������� 0%�� �����˴ϴ�.");
		
		$("#sel_o_11_1 option[value='0']").prop("selected", true);
		$("#o_11_1").val("0.0");
		
		$("#sel_o_11_2 option[value='0']").prop("selected", true);
		$("#o_11_2").val("0.0");
		
		$("#sel_o_11_3 option[value='0']").prop("selected", true);
		$("#o_11_3").val("0.0");
		
		$("#sel_o_11_4 option[value='0']").prop("selected", true);
		$("#o_11_4").val("0.0");
	}
}

function set_other_esti_value(tag){
	var fm = document.form1;
	var print_type = fm.print_type.value;
	
	// ��Ʈ, ����, ���� ���� �ÿ��� �ش�.
	if( !(print_type == 2 || print_type == 3 || print_type == 4 ) ) return;
	
	var name = tag.name;
	
	if( name.includes('a_b') ){	// �뿩�Ⱓ
		
		var index = fm.sel_a_b[0].selectedIndex;
		var sel_a_b_list = fm.sel_a_b;
		var a_b_list = fm.a_b;
		
		for(var i=1; i<4; i++){
			sel_a_b_list[i].options[index].selected = true;
			a_b_list[i].value = a_b_list[0].value;
		}
		
	} else if( name.includes('agree_dist') ){	// ���� ��������Ÿ�
		
		var index = fm.sel_agree_dist[0].selectedIndex;
		var sel_agree_dist_list = fm.sel_agree_dist;
		var agree_dist_list = fm.agree_dist;
		
		for(var i=1; i<4; i++){
			sel_agree_dist_list[i].options[index].selected = true;
			agree_dist_list[i].value = agree_dist_list[0].value;
		}
		
	} else if( name.includes('rg_8') ){	// ������
		
		var index = fm.sel_rg_8[0].selectedIndex;
		var sel_rg_8_list = fm.sel_rg_8;
		var rg_8_list = fm.rg_8;
		var rg_8_amt_list = fm.rg_8_amt;
		
		for(var i=1; i<4; i++){
			sel_rg_8_list[i].options[index].selected = true;
			rg_8_list[i].value = rg_8_list[0].value;
			rg_8_amt_list[i].value = rg_8_amt_list[0].value;
		}
	
	} else if( name.includes('pp') ){	// ������
		var pp_per = fm.pp_per;
		var pp_amt = fm.pp_amt;
		
		for(var i=1; i<4; i++){
			pp_per[i].value = pp_per[0].value;
			pp_amt[i].value = pp_amt[0].value;
		}
		
	} else if( name == 'g_10' ){	// ���ô뿩��
		var g_10 = fm.g_10;
		
		for(var i=1; i<4; i++){
			g_10[i].value = g_10[0].value;
		}
	
	} else if( name == 'fee_dc_per' ){	// �뿩�� D/C
		var fee_dc_per = fm.fee_dc_per;
	
		for(var i=1; i<4; i++){
			fee_dc_per[i].value = fee_dc_per[0].value;
		}
	} else if( name == 'ecar_loc_st' ){ // ������ ���ּ���
		var ecar_loc_st = fm.ecar_loc_st;
	
		for(var i=1; i<4; i++){
			ecar_loc_st[i].value = ecar_loc_st[0].value;
		}
	} else if( name == 'hcar_loc_st' ){ // ������ ���ּ���
		var hcar_loc_st = fm.hcar_loc_st;
		
		for(var i=1; i<4; i++){
			hcar_loc_st[i].value = hcar_loc_st[0].value;
		}
	}
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
	<form action="/acar/estimate_mng/get_carcd_null.jsp" name="form2" method="post">
	    <input type="hidden" name="sel" value="">
	    <input type="hidden" name="car_comp_id" value="">
	    <input type="hidden" name="code" value="">
	    <input type="hidden" name="mode" value="">
	    <input type="hidden" name="rent_way" value="">  
	    <input type="hidden" name="a_a" value="">   
  	</form>
  	
	<form action='/acar/estimate_mng/get_o13_20110101.jsp' name="sh_form" method='post'>
		<input type='hidden' name="car_id"      value="">    
		<input type='hidden' name="car_seq"     value="">    
		<input type='hidden' name="car_amt"     value="">  
		<input type='hidden' name="opt_amt"     value="">  
		<input type='hidden' name="opt_amt_m" value="">  
		<input type='hidden' name="col_amt"     value="">      
		<input type='hidden' name="dc_amt"      value="">      
		<input type='hidden' name="o_1"     value="">          
		<input type='hidden' name="a_a"     value="">
		<input type='hidden' name="a_b"     value="">  
		<input type='hidden' name="esti_type"     value="a">    
		<input type='hidden' name="idx"     value="0">      
		<input type='hidden' name="print_type"    value="1">      
		<input type='hidden' name="agree_dist"    value="">      
		<input type='hidden' name="jg_opt_st"     value="">      
		<input type='hidden' name="jg_col_st"     value="">      
		<input type='hidden' name="ecar_loc_st"   value="">     
		<input type='hidden' name="hcar_loc_st"   value="">     
		<!-- <input type='hidden' name="eco_e_tag"   value=""> -->   
		<input type='hidden' name="rent_dt"   value="">
		<input type='hidden' name="rtn_run_amt_yn"   value="">
		
	</form>
	
  	<form action="./esti_mng_atype_i_a.jsp" name="form1" method="POST">
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
	    <input type="hidden" name="cmd" value="<%=cmd%>">
	    <input type="hidden" name="s_st" value="">
	    <input type="hidden" name="a_e" value="">
		<input type="hidden" name="ls_yn" value="">
		<input type="hidden" name="dc_amt2" value="">
		<input type="hidden" name="o_12" value="">
		<input type="hidden" name="ecar_pur_sub_amt" value="<%=ecar_pur_sub_amt_val%>">
		<input type="hidden" name="jg_f" value="<%=jg_f%>">
		<input type="hidden" name="jg_g" value="<%=jg_g%>">
		<input type="hidden" name="jg_w" value="<%=jg_w%>">
		<input type="hidden" name="jg_h" value="<%=jg_h%>">
		<input type="hidden" name="jg_i" value="<%=jg_i%>">
		<input type="hidden" name="jg_b" value="<%=jg_b%>">
		<input type="hidden" name="jg_g_7" value="<%=ej_bean.getJg_g_7()%>">
  
		<%for (int j=0; j<4; j++) {%>
		<input type="hidden" name="r_a_a" value="">
		<input type="hidden" name="r_tint_s_yn" value="">
		<input type="hidden" name="r_tint_sn_yn" value="">
		<input type="hidden" name="r_tint_ps_yn" value="">
		<input type="hidden" name="r_tint_ps_nm" value="">
		<input type="hidden" name="r_tint_ps_amt" value="">
		<input type="hidden" name="r_tint_ps_st" value="">
		<input type="hidden" name="r_tint_n_yn" value="">
		<input type="hidden" name="r_tint_bn_yn" value="">
		<input type="hidden" name="r_new_license_plate" value="">
		<input type="hidden" name="r_tint_cons_yn" value="">
		<input type="hidden" name="r_tint_cons_amt" value="">
		<input type="hidden" name="r_ins_per" value="">
		<input type="hidden" name="r_ins_dj" value="">
		<input type="hidden" name="r_ins_age" value="">
		<input type="hidden" name="r_loc_st" value="">
		<input type="hidden" name="r_ecar_loc_st" value="">
		<input type="hidden" name="r_hcar_loc_st" value="">
		<!-- <input type="hidden" name="r_eco_e_tag" value=""> -->
		<input type="hidden" name="r_com_emp_yn" value="">
		<input type="hidden" name="r_tint_eb_yn" value="">
		<input type="hidden" name="tint_ps_st" value="">	
		<%}%>
	
		<input type="hidden" name="jg_opt_st" value="<%=e_bean.getJg_opt_st()%>">
		<input type="hidden" name="jg_col_st" value="<%=e_bean.getJg_col_st()%>">
		<input type="hidden" name="jg_code" value="<%=ej_bean.getSh_code()%>">
		<input type="hidden" name="search_o13_yn" value="">
    
		<%-- <input type="hidden" name="jg_tuix_st" value="<%=e_bean.getJg_tuix_st()%>"> --%>
		<%-- <input type="hidden" name="lkas_yn" value="<%=e_bean.getLkas_yn()%>"> --%>
		<%-- <input type="hidden" name="ldws_yn" value="<%=e_bean.getLdws_yn()%>"> --%>
		<%-- <input type="hidden" name="aeb_yn" value="<%=e_bean.getAeb_yn()%>"> --%>
		<%-- <input type="hidden" name="fcw_yn" value="<%=e_bean.getFcw_yn()%>"> --%>
		<input type="hidden" name="jg_tuix_st" value="<%if (e_bean.getJg_tuix_st().equals("")) {%><%=cm_bean2.getJg_tuix_st()%><%} else {%><%=e_bean.getJg_tuix_st()%><%}%>">
		<input type="hidden" name="jg_tuix_opt_st" value="<%=e_bean.getJg_tuix_opt_st()%>">
		<input type="hidden" name="lkas_yn" value="<%if (e_bean.getLkas_yn().equals("")) {%><%=cm_bean2.getLkas_yn()%><%} else {%><%=e_bean.getLkas_yn()%><%}%>">
		<input type="hidden" name="lkas_yn_opt_st" value="<%=e_bean.getLkas_yn_opt_st()%>">
		<input type="hidden" name="ldws_yn" value="<%if (e_bean.getLdws_yn().equals("")) {%><%=cm_bean2.getLdws_yn()%><%} else {%><%=e_bean.getLdws_yn()%><%}%>">
		<input type="hidden" name="ldws_yn_opt_st" value="<%=e_bean.getLdws_yn_opt_st()%>">
		<input type="hidden" name="aeb_yn" value="<%if (e_bean.getAeb_yn().equals("")) {%><%=cm_bean2.getAeb_yn()%><%} else {%><%=e_bean.getAeb_yn()%><%}%>">
		<input type="hidden" name="aeb_yn_opt_st" value="<%=e_bean.getAeb_yn_opt_st()%>">
		<input type="hidden" name="fcw_yn" value="<%if (e_bean.getFcw_yn().equals("")) {%><%=cm_bean2.getFcw_yn()%><%} else {%><%=e_bean.getFcw_yn()%><%}%>">
		<input type="hidden" name="fcw_yn_opt_st" value="<%=e_bean.getFcw_yn_opt_st()%>">
		<input type="hidden" name="garnish_yn" value="">				<!-- ���Ͻ� ���� -->
		<input type="hidden" name="garnish_yn_opt_st" value="<%if (e_bean.getGarnish_yn().equals("")) {%><%=cm_bean2.getGarnish_yn()%><%} else {%><%=e_bean.getGarnish_yn()%><%}%>">	<!-- ���Ͻ� ����(�ɼ�) -->
		<input type="hidden" name="hook_yn" value="">				<!-- ���ΰ� ���� -->
		<input type="hidden" name="hook_yn_opt_st" value="<%if (e_bean.getHook_yn().equals("")) {%><%=cm_bean2.getHook_yn()%><%} else {%><%=e_bean.getHook_yn()%><%}%>">	<!-- ���ΰ� ����(�ɼ�) -->
		
		<input type='hidden' name='badcust_chk_from' value='esti_mng_atype_i.jsp'>
		
		<input type='hidden' name='duty_free_opt' value='<%if (!est_id.equals("")) {%><%=cm_bean2.getDuty_free_opt()%><%}%>'>
		<input type="hidden" name="jg_g_15" value="<%=ej_bean.getJg_g_15()%>">     
  
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
        <td class=h colspan=2></td>
    </tr>
    <%if (!spe_car_nm.equals("")) {%>   
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����Ʈ����</span> <b>[�������] : <font color=green><%=spe_car_nm%></font></b></td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
    <%}%>    
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span> <a href="javascript:search_cust()" onMouseOver="window.status=''; return true" title="����ȸ�ϱ�. Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a>
    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <font color=red>�� �ҷ��� Ȯ���ϱ�</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='��Ȯ��' onclick="javascript:view_badcust();">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">        	
        </td>
        <td align="right"></td>
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
                    <td rowspan='2' width=50%>
                    	&nbsp;* ��ȣ �Ǵ� ��������� ����ڸ� ��ȣ����, �����̸� ������ �����ϴ�.<br>
                    	&nbsp;&nbsp;&nbsp;&nbsp; ��, (��) �Ǵ� �ֽ�ȸ��� �����Ͽ��� �˴ϴ�.
                    </td>
                </tr>            
                <tr> 
                    <td align='center'> 
                        <input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="25" maxlength='50' class=text onKeyDown='javascript:enter()' style='IME-MODE: active'>
                    </td>
                    <td align='center'> 
                        <input type="text" name="mgr_nm" value="<%=e_bean.getMgr_nm()%>" size="25" class=text>&nbsp;�� ����
                    </td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td class=h colspan=2></td>
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
                        &nbsp;
                        <input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=text>
                    </td>
                    <td class=title width=10%>�̸����ּ�</td>
                    <td colspan="3">
                    	&nbsp;
                    	<input type="text" name="est_email" value="<%=e_bean.getEst_email()%>" size="50" class=text style='IME-MODE: inactive'>                
					</td>
                </tr>
                <tr>
                    <td class=title>��ȭ��ȣ</td>
                    <td>
                        &nbsp;
                        <input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=text>
                    </td>
                    <td class=title>FAX</td>
                    <td colspan="3">
                        &nbsp;
                        <input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=text>
                    </td>
                </tr>             
                <tr>
                    <td class=title>������</td>
                    <td colspan="5">
                      	<div style="float: left;">
                      		&nbsp;
                      		<input type="radio" id="doc_type_1" name="doc_type" value="1" onClick="javascript:SetComEmpYn()" <% if (e_bean.getDoc_type().equals("1")||e_bean.getDoc_type().equals("")) out.print("checked"); %>>
                      		<label for="doc_type_1">���ΰ�</label>
                      		&nbsp;
	            			<input type="radio" id="doc_type_2" name="doc_type" value="2" onClick="javascript:SetComEmpYn()" <% if (e_bean.getDoc_type().equals("2")) out.print("checked"); %>>
		            		<label for="doc_type_2">���λ����</label>
		            		&nbsp;
	            			<input type="radio" id="doc_type_3" name="doc_type" value="3" onClick="javascript:SetComEmpYn()" <% if (e_bean.getDoc_type().equals("3")) out.print("checked"); %>>
		            		<label for="doc_type_3">����&nbsp;(�����п� ���� �������� �ʿ伭���� ǥ���մϴ�.)</label>
                      	</div>
	           		  	<%-- <div style="float: left; <%if (e_bean.getDoc_type().equals("2") || e_bean.getDoc_type().equals("3")) {%>display: none;<%}%>" id="doc_type_check_div"> --%>
	           		  	<div style="float: left;" id="doc_type_check_div">
							&nbsp;&nbsp;&nbsp;
	           		  		<input type="checkbox" id="dir_pur_commi_yn" name="dir_pur_commi_yn" value="Y" onclick="javascript:dir_pur_change()" <% if (e_bean.getDir_pur_commi_yn().equals("Y")) out.print("checked"); %>>
	           		  		<label for="dir_pur_commi_yn">Ư�����(�����̰�����)</label>
	           		  	</div>
                    </td>
                </tr>
                <tr>
                    <td class=title>�ſ뵵</td>
                    <td>
                    	&nbsp;
                    	<input type="radio" id="spr_yn_2" name="spr_yn" value="2" <% if (e_bean.getSpr_yn().equals("2")||e_bean.getSpr_yn().equals("")) out.print("checked"); %>>
                    	<label for="spr_yn_2">�ʿ췮���</label>
                    	&nbsp;
			            <input type="radio" id="spr_yn_1" name="spr_yn" value="1" <% if (e_bean.getSpr_yn().equals("1")) out.print("checked"); %>>
			            <label for="spr_yn_1">�췮���</label>
			            &nbsp; 
			            <input type="radio" id="spr_yn_0" name="spr_yn" value="0" <% if (e_bean.getSpr_yn().equals("0")) out.print("checked"); %>>
			            <label for="spr_yn_0">�Ϲݱ��</label>
			            &nbsp;
			            <input type="radio" id="spr_yn_3" name="spr_yn" value="3" <% if (e_bean.getSpr_yn().equals("3")) out.print("checked"); %>>
						<label for="spr_yn_3">�ż�����</label>
					</td>
                    <td width=10% class=title>��������</td>
                    <td width=10%>
                    	&nbsp;
                    	<select name="bus_st">
	                        <option value="">����</option>                        
	                        <option value="1" <%if (e_bean.getBus_st().equals("1")) {%>selected<%}%>>���ͳ�</option>
	                        <option value="8" <%if (e_bean.getBus_st().equals("8")) {%>selected<%}%>>�����</option>
	                        <option value="5" <%if (e_bean.getBus_st().equals("5")) {%>selected<%}%>>��ȭ���</option>
	                        <option value="2" <%if (e_bean.getBus_st().equals("2")) {%>selected<%}%>>�������</option>
	                        <option value="7" <%if (e_bean.getBus_st().equals("7")) {%>selected<%}%>>������Ʈ</option>
	                        <option value="6" <%if (e_bean.getBus_st().equals("6")) {%>selected<%}%>>������ü</option>
	                        <option value="3" <%if (e_bean.getBus_st().equals("3")) {%>selected<%}%>>��ü�Ұ�</option>
	                        <option value="4" <%if (e_bean.getBus_st().equals("4")) {%>selected<%}%>>catalog</option>
                      	</select>
					</td>
                    <td width=10% class=title>����</td>
                    <td width=10%>
                    	&nbsp;
                    	<input type="radio" id="compare_n" name="compare_yn" value="N" <% if (e_bean.getCompare_yn().equals("N")||e_bean.getCompare_yn().equals("")) out.print("checked"); %>>
                    	<label for="compare_n">����</label>
                    	&nbsp;
            			<input type="radio" id="compare_y" name="compare_yn" value="Y" <% if (e_bean.getCompare_yn().equals("Y")) out.print("checked"); %>>
            			<label for="compare_y">����</label> 
					</td>
                </tr>
                <tr>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td colspan="5">
                    	&nbsp;
                    	<input type="radio" id="vali_type_0" name="vali_type" value="0" <% if (e_bean.getVali_type().equals("0")||e_bean.getVali_type().equals("")) out.print("checked"); %>>
                    	<label for="vali_type_0">��¥��ǥ��(10��/���, �⺻ 10���̳� 10���� �Ϳ��� �Ѿ ��쿡�� ����� ������ �Ѵ�.)</label>
            			&nbsp;
            			<input type="radio" id="vali_type_1" name="vali_type" value="1" <% if (e_bean.getVali_type().equals("1")) out.print("checked"); %>>
            			<label for="vali_type_1">����ĿD/C ���� ���ɼ� ���(10��)</label> 
            			&nbsp;
            			<input type="radio" id="vali_type_2" name="vali_type" value="2" <% if (e_bean.getVali_type().equals("2")) out.print("checked"); %>>
            			<label for="vali_type_2">��Ȯ������</label> 
                    </td>                	
                </tr>
                <tr>
                    <td class=title>�ʱⳳ�Աݾȳ�����</td>
                    <td colspan="3">
                    	&nbsp;
                    	<input type="radio" id="pp_ment_yn_y" name="pp_ment_yn" value="Y" <%if (e_bean.getPp_ment_yn().equals("Y"))out.print("checked");%>>
                    	<label for="pp_ment_yn_y">ǥ��(�ʱⳳ�Ա��� ������ �ſ뵵�� ���� �ɻ�������� ������ �� �ֽ��ϴ�.)</label>
                      	&nbsp;
                      	<input type="radio" id="pp_ment_yn_n" name="pp_ment_yn" value="N" <% if (e_bean.getPp_ment_yn().equals("N")||e_bean.getPp_ment_yn().equals("")) out.print("checked");%>>
                      	<label for="pp_ment_yn_n">��ǥ��</label>
					</td>
					<td class=title>������������ ���</td>
                	<td>
                		&nbsp;
                		<select name="gi_grade" id="gi_grade">
                			<option value="" <%if (e_bean.getGi_grade().equals("")) {%>selected<%}%>>������ǥ��</option>
                			<option value="1" <%if (e_bean.getGi_grade().equals("1")) {%>selected<%}%>>1���</option>
                			<option value="2" <%if (e_bean.getGi_grade().equals("2")) {%>selected<%}%>>2���</option>
                			<option value="3" <%if (e_bean.getGi_grade().equals("3")) {%>selected<%}%>>3���</option>
                			<option value="4" <%if (e_bean.getGi_grade().equals("4")) {%>selected<%}%>>4���</option>
                			<option value="5" <%if (e_bean.getGi_grade().equals("5")) {%>selected<%}%>>5���</option>
                			<option value="6" <%if (e_bean.getGi_grade().equals("6")) {%>selected<%}%>>6���</option>
                			<%-- <option value="7" <%if (e_bean.getGi_grade().equals("7")) {%>selected<%}%>>7���</option> --%>
                		</select>
                	</td>
                </tr>
                <tr>
                    <td class=title>�����</td>
                    <td colspan="4"><!-- colspan="3" -->
                    	&nbsp;
                    	<select name='damdang_id' class=default>            
                        	<option value="">������</option>
	                   	<%if (user_size > 0) {%>
	                   		<%for (int i = 0; i < user_size; i++) {
                      			Hashtable user = (Hashtable)users.elementAt(i);
                      		%>
                    		<option value='<%=user.get("USER_ID")%>' <% if (damdang_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
	                    	<%}%>
						<%}%>
                		</select>            
            			&nbsp;&nbsp;&nbsp;
			            <label><input type="radio" name="caroff_emp_yn" value="1" onClick="javascript:setO11();" <%if (e_bean.getCaroff_emp_yn().equals("1") || e_bean.getCaroff_emp_yn().equals("")) {%>checked<%}%>>�����������</label>
			            <label><input type="radio" name="caroff_emp_yn" value="2" onClick="javascript:setO11();" <%if (e_bean.getCaroff_emp_yn().equals("2")) {%>checked<%}%>>�����������(��� ����� ǥ��)</label>
			            <label><input type="radio" name="caroff_emp_yn" value="3" onClick="javascript:setO11();" <%if (e_bean.getCaroff_emp_yn().equals("3")) {%>checked<%}%>>�����������(��� ����� ��ǥ��)</label>
			            
			            <!-- 20201020 ���Ҽ�ȯ������ ������������� ǥ��� ����ʿ� ���� �Ʒ� ������ ���Ҽ�ȯ������ ǥ�⿩�� �ӽ� �ּ�ó�� -->
			            <input type="hidden" name="info_st" id="info_st" value="">
					</td>
					<td id=tr_cons_cost_y style="display:<%if(e_bean.getCar_comp_id().equals("0001") || e_bean.getCar_comp_id().equals("0002")){%>''<%}else{%>none<%}%>"> 
            			<input type="button" class="button" value="��üŹ�۷� ��ȸ" onclick="javascript:search_cons_cost();">
        			</td>
        			<td id=tr_cons_cost_n style="display:<%if(e_bean.getCar_comp_id().equals("0001") || e_bean.getCar_comp_id().equals("0002")){%>none<%}else{%>''<%}%>"> 
            			&nbsp;
        			</td>
					<%-- <td class=title>���Ҽ�ȯ�� �ȳ�����</td>
                	<td>&nbsp;
                		<select name="info_st" id="info_st">
                			<option value="" <%if (e_bean.getInfo_st().equals("")) {%>selected<%}%>>�ȳ���ǥ��</option>
                			<option value="N" <%if (e_bean.getInfo_st().equals("N")) {%>selected<%}%>>�ȳ�����ǥ��</option>
                		</select>
                	</td> --%>
                </tr>
            </table>
        </td>
    </tr>
    

    
<!-- ���������� �Է����� -->
<%if (pur_from_page.equals("pur_pre_c.jsp")) {%>
	<tr>
        <td class=h colspan=2></td>
    </tr>
	<tr>
        <td class=h colspan=2></td>
    </tr>
    <tr>
        <td colspan="2">
        	<font class="num_weight" color="red">�� ���������� �������� �� ������Ȳ �Դϴ�. �������� �� ������Ȳ�� Ȯ�� �� �Ʒ� ���� ������ ���� �� ������ �������ּ���.</font>
        </td>
    </tr>
    <tr>
        <td colspan="2">
        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������� �������� �� ������Ȳ</span>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td class=line colspan="2">
            <table border="0" cellspacing="1" width=100%>
				<tr>
				    <td class=title width=13%>����</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_car_nm%>
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>�ɼ�</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_car_opt%>
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>����</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;���� : <%=pur_car_col%>&nbsp;&nbsp;&nbsp;&nbsp;����(���Ͻ� ����) : <%=pur_car_in_col%>
				    	<!-- <%=pur_car_garnish_col%> -->
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>����</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_eco_yn%>
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>�Һ��ڰ�</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_car_amt%> ��
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>����</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_con_amt%> ��
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>����������</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_con_pay_dt%>
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>�������</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_dlv_est_dt%>
				    </td>
				</tr>
				<tr> 
				    <td class=title width=13%>���</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_etc%>
				    </td>
				</tr>
			</table>
		</td>
	</tr>
	<%if (!pur_seq.equals("")) {%>
		<%
		//�����ڸ���Ʈ
		Vector off_pre_vt = cop_db.getCarOffPreSeqResList(pur_seq);
		int off_pre_vt_size = off_pre_vt.size();
		%>
	<tr>
        <td class=h colspan=2></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td class=line colspan="2">
            <table border="0" cellspacing="1" width=100%>
				<tr> 
				    <td width=5% class=title>����</td>
		            <td width=10% class=title>������</td>
		            <td width=15% class=title>����</td>
		            <td width=10% class=title>����ó</td>
		            <td width=15% class=title>�ּ�</td>
		            <td width=20% class=title>�޸�</td>
		            <td width=10% class=title>��������</td>
		            <td width=10% class=title>���������</td>
				</tr>
			<%for (int i = 0; i < off_pre_vt_size; i++) {
				Hashtable pur_ht = (Hashtable)off_pre_vt.elementAt(i);%>
				<tr> 
				    <td align='center'><%=i+1%></td>
                    <td align='center'><%=pur_ht.get("BUS_NM")%></td>
                    <td align='center'><%=pur_ht.get("FIRM_NM")%></td>
                    <td align='center'><%=pur_ht.get("CUST_TEL")%></td>
                    <td align='center'><%=pur_ht.get("ADDR")%></td>
                    <td align='center'><%=pur_ht.get("MEMO")%></td>
                    <td align='center'><%=pur_ht.get("REG_DT")%></td>
                    <td align='center'><%=pur_ht.get("CLS_DT")%></td>
				</tr>
			<%}%>
			</table>
		</td>
	</tr>
	<%}%>	
	<tr>
        <td class=h colspan=2></td>
    </tr>
<%}%>
    
    <tr>
        <td class=h colspan=2></td>
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
				    <td colspan="2" valign=middle>
				    	&nbsp;
				    	<select name="car_comp_id" id="car_comp_id" onChange="javascript:GetCarCode()">
						<%for (int i=0; i<cc_r.length; i++) {
							cc_bean = cc_r[i];						
							//if (cc_bean.getCode().equals("0018")) continue;
						%>
							<option value="<%= cc_bean.getCode() %>" <%if (e_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
						<%}%>
						</select>&nbsp;&nbsp;
						<textarea id="etc" name="etc" cols="130" rows="1" style="overflow: hidden; border: 0;" readonly><%=etc%></textarea>
					</td>
				</tr>
                <tr> 
                    <td class=title>����</td>
                    <td>
                    	&nbsp;
                    	<select name="code" id="code">
                        	<option value="">����</option>
                        <%for (int i=0; i<cm_r.length; i++) {
                            cm_bean = cm_r[i];%>
                        	<option value="<%= cm_bean.getCode() %>" <%if (e_bean.getCar_cd().equals(cm_bean.getCode()))%>selected<%%>><%=cm_bean.getCar_nm()%></option>
                        <%}%>
                      	</select>
                    </td>
                    <td align="center"><input type="button" class="button" value="�ش����� ���� ��������" onclick="javascript:view_car_bbs();"></td>
                </tr>
                <tr>
                    <td class=title>����</td>
                    <td width=66%>
						&nbsp;
						<a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	<input type="text" name="car_name" value="<%=cm_bean2.getCar_name()%>" size="50" class=whitetext readonly>
                      	<input type="hidden" name="car_id" id="car_id" value="<%=e_bean.getCar_id()%>">
                      	<input type="hidden" name="car_seq" id="car_seq" value="<%=e_bean.getCar_seq()%>">
                      	<input type="button" class="button" id="btn_view_spec" value="��纸��" onclick="javascript:view_spec();">
                    </td>
                    <td align="center">
                    	&nbsp;
                    	<input type="text" name="car_amt" value="<%=AddUtil.parseDecimal(e_bean.getCar_amt())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value); set_amt();' readonly>
                    	��
                    </td>
                </tr>
                <tr> 
                    <td class=title>�ɼ�</td>
                    <td>
                    	&nbsp;
                    	<a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	<input type="text" name="opt" value="<%=e_bean.getOpt()%>" size="75" class=whitetext readonly>
                      	<input type="hidden" name="opt_seq" value="<%=e_bean.getOpt_seq()%>">
                    </td>
                    <td align="center">
                      	&nbsp;
                      	<input type="text" name="opt_amt" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value); set_amt();' readonly>
                      	��
                      	<input type="hidden" name="opt_amt_m" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt_m())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value);' readonly>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td>
                    	&nbsp;
                    	<a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	����: <input type="text" name="col" value="<%=e_bean.getCol()%>" size="27" class=whitetext readonly>
                  		&nbsp;&nbsp;&nbsp;&nbsp;
                  		����: <input type="text" name="in_col" value="<%=e_bean.getIn_col()%>" size="27" class=whitetext readonly>
                  		&nbsp;&nbsp;&nbsp;&nbsp;
                  		���Ͻ�: <input type="text" name="garnish_col" value="<%=e_bean.getGarnish_col()%>" size="27" class=whitetext readonly>
                      <input type="hidden" name="col_seq" value="<%=e_bean.getCol_seq()%>">
					</td>
                    <td align="center"> 
                      	&nbsp;
                      	<input type="text" name="col_amt" value="<%=AddUtil.parseDecimal(e_bean.getCol_amt())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value); set_amt();' readonly>
                      	��
                    </td>
                </tr>
                <tr>
                	<td class="title">����</td>
                	<td>
                		&nbsp;
                		<a href="javascript:sub_list('5');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	<input type="text" name="conti_rat" value="<%=e_bean.getConti_rat()%>"  size="75" class=whitetext readonly>
                      	<input type="hidden" name="conti_rat_seq" value="<%=e_bean.getConti_rat()%>">
                    </td>
                    <td align="center"> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>������DC</td>
                    <td>
                    	&nbsp;
                    	<a href="javascript:sub_list('4');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	<input type="text" name="dc" value="<%=e_bean.getDc()%>" size="45" class=text>
                      	<input type="hidden" name="dc_seq" value="<%=e_bean.getDc_seq()%>">
                      	<input type="hidden" name="esti_d_etc" value="<%=e_bean.getEsti_d_etc()%>">
                      	<input type="text" name="bigo" value="<%=bigo%>" size="45" class=whitetext>
                    </td>
                    <td align="center">
                    	- <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(e_bean.getDc_amt())%>" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                    	��
                    </td>
                </tr>
                
                <tr id=tr_ecar_tax style="display:<%if (e_bean.getTax_dc_amt() > 0) {%>''<%} else {%>none<%}%>">
                	<td class=title>�����Һ�</td>
                    <td> 
                    	&nbsp;�����Һ� �� ������ ���� 
                    </td>
                    <td align="center">
                    	- <input type="text" name="tax_dc_amt" value="<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value);'>
                    	��
                    </td>
                </tr>  
                
                <tr> 
                    <td class=title>���</td>
                    <td> 
                    	&nbsp;
                    	<textarea id="car_etc" name="car_etc" cols="100" rows="3" style="overflow: hidden; border: 0;" readonly></textarea>
                      	<input type="hidden" id="car_etc2" name="car_etc2">
                    </td>
                    <td align="center">&nbsp;</td>
                </tr>
                
                <tr> 
                    <td class=title colspan="2">��������</td>
                    <td align="center">
                    	&nbsp;
                    	<input type="text" name="o_1" value="<%=AddUtil.parseDecimal(e_bean.getO_1())%>" size="15" class=whitenum readonly>
                    	��
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr>
        <td class=h></td>
    </tr>
     
    <tr>
        <td align="right"><a href="javascript:dlv_con_commi();"><img src=/acar/images/center/button_sd_cg.gif align=absmiddle border=0 alt='���������'></a></td>
    </tr>
    
    <!-- START_������ -->
    <tr id="import_content_1" style="display: <%if (!e_bean.getImport_pur_st().equals("")) {%>''<%} else {%>none<%}%>">
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
						        <td align="left">
						        	&nbsp;
						        	<input type="radio" name="import_pur_st" id="import_pur_st_1" value="0" <%if (e_bean.getImport_pur_st().equals("0") || e_bean.getImport_pur_st().equals("")) {%>checked<%}%> onchange="javascript:release_type();">
						        	<label for="import_pur_st_1">��ü���</label>
						        	&nbsp;
						          	<input type="radio" name="import_pur_st" id="import_pur_st_2" value="1" <%if (e_bean.getImport_pur_st().equals("1")) {%>checked<%}%> onchange="javascript:release_type();">
						          	<label for="import_pur_st_2">���������� (��ü��� ������)</label>
						        </td>
			                </tr>
			            </table>
        			</td>
        		</tr>
        	</table>
        </td>
    </tr>
    
    <tr id="import_content_2" style="display: <%if (e_bean.getImport_pur_st().equals("1")) {%>''<%} else {%>none<%}%>">
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
			                    <td align="left">
			                    	&nbsp;<input type="text" name="car_b_p2" id="car_b_p2" class="whitenum" size="15" value="<%=AddUtil.parseDecimal(e_bean.getCar_b_p2())%>" readonly> ��
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">���ݰ�꼭D/C</td>
			                    <td align="left">
			                    	&nbsp;
			                    	��Ʈ&nbsp;&nbsp;<input type="text" name="r_dc_amt" id="r_dc_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getR_dc_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> �� /
			                    	&nbsp;
			                    	����&nbsp;&nbsp;<input type="text" name="l_dc_amt" id="l_dc_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getL_dc_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> ��
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">ī������ݾ�</td>
			                    <td align="left">
			                    	&nbsp;
			                    	��Ʈ&nbsp;&nbsp;<input type="text" name="r_card_amt" id="r_card_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getR_card_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> �� /
			                    	&nbsp;
			                    	����&nbsp;&nbsp;<input type="text" name="l_card_amt" id="l_card_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getL_card_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> ��
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">Cash Back</td>
			                    <td align="left">
			                    	&nbsp;
			                    	��Ʈ&nbsp;&nbsp;<input type="text" name="r_cash_back" id="r_cash_back" class="num" value="<%=AddUtil.parseDecimal(e_bean.getR_cash_back())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> �� /
			                    	&nbsp;
			                    	����&nbsp;&nbsp;<input type="text" name="l_cash_back" id="l_cash_back" class="num" value="<%=AddUtil.parseDecimal(e_bean.getL_cash_back())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> ��
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">Ź�۽��ú���</td>
			                    <td align="left">
			                    	&nbsp;
			                    	��Ʈ&nbsp;&nbsp;<input type="text" name="r_bank_amt" id="r_bank_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getR_bank_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> �� /
			                    	&nbsp;
			                    	����&nbsp;&nbsp;<input type="text" name="l_bank_amt" id="l_bank_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getL_bank_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> ��
			                    </td>
			                </tr>
			            </table>
        			</td>
        		</tr>        		
        	</table>
        </td>
    </tr>
    <!-- END_������ -->
    
    <tr>
        <td><font class="num_weight" color="red">�� ��������/����/�뿩�Ⱓ/��������Ÿ��� ����Ǿ��� ��� �ִ��ܰ����� �� �����Ͻʽÿ�.</font></td>
    </tr>
    <tr>
        <td>�� ���������� �ִ��ܰ� ���� ǥ�غ��������� ����˴ϴ�.</td>
    </tr>
    <tr>
        <td>�� ����������/�뿩��DC���� <%if (cmd.equals("re")) {%>�������� ������<%} else {%>�Է��� ����<%}%> �״�� ����մϴ�.</td>
    </tr>
    <tr>
        <td>�� ������ ������ ��� ����,��ǰ,�����ε�����,���������ּ����� ����1�� �������� �����˴ϴ�. ������ ���տ��� ������ ������ ��Ʈ/���� ȥ�հ����� �Ұ����մϴ�.</td>
    </tr>
    <%if (nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("��������������", user_id) || nm_db.getWorkAuthUser("Ȩ�����������ݿ�2", user_id)) {%>
    <tr>
        <td>�� �������� : <input type="text" name="rent_dt" value="<%=AddUtil.getDate()%>" size="10" class=text></td>
    </tr>
    <%}else{ %>
    <input type='hidden' name="rent_dt"   value="">
    <%} %>
    <tr>
        <td class=h></td>
    </tr>
    
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='' colspan="2"> 
            <table border="0" cellspacing="0" width=100% id='esti_condition'>
				<tr>
					<td colspan='2' class=title>����</td>
                  	<td colspan='4'>
                  		&nbsp;
			            <label>
				            <input type="radio" name="print_type" value="1" onClick="javascript:setEst_yn(1);" <% if (e_bean.getPrint_type().equals("1")||e_bean.getPrint_type().equals("5")||e_bean.getPrint_type().equals("")) out.print("checked"); %> <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
				               ��ǰ��
						</label>
						&nbsp;
			            <label>
				            <input type="radio" name="print_type" value="5" onClick="javascript:setEst_yn(5);" <% if (e_bean.getPrint_type().equals("6")) { %>disabled<% } %>>
							����������
			            </label>
			            &nbsp;
			            <label>
			            	<input type="radio" name="print_type" value="2" onClick="javascript:setEst_yn(2);" <% if (e_bean.getPrint_type().equals("2")) out.print("checked"); %> <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
							��Ʈ
						</label>
						&nbsp;
			            <label>
			            	<input type="radio" name="print_type" value="3" onClick="javascript:setEst_yn(3);" <% if (e_bean.getPrint_type().equals("3")) out.print("checked"); %> <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
			                   ����
	                 	</label>
	                 	&nbsp;
			            <label>
			            	<input type="radio" name="print_type" value="4" onClick="javascript:setEst_yn(4);" <% if (e_bean.getPrint_type().equals("4")) out.print("checked"); %> <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
			                   ����
	                  	</label>
	                  	&nbsp;
			            <label <%if ((e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6"))) {%>style="display: ;"<%} else {%>style="display: none;"<%}%>>
			            	<input type="radio" name="print_type" value="6" onClick="javascript:setEst_yn(6);" <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) out.print("checked"); %> <% if (!e_bean.getPrint_type().equals("6") || !e_bean2.getPrint_type().equals("6") || !e_bean3.getPrint_type().equals("6") || !e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
							������ �μ� / �ݳ� ������ �� �ݳ��� ����
						</label>
                  	</td>
                </tr>             
                <tr>
                  	<td colspan='2' class=title>����</td>
                  	<td width="22%" class=title>
                  		<input type="checkbox" name="est_yn" id="est_yn_1" value="Y" checked <%if (e_bean.getPrint_type().equals("6")) {%>disabled<%} else {%><%}%> onClick="javascript:setO11();">
                  		����1
                  	</td>
                  	<td width="21%" class=title>
	                  	<table width="100%">
	                  		<tr>
	                  			<td width="95%" class=title style="border: none !important;">
	                  				<input type="checkbox" name="est_yn" id="est_yn_2" value="Y" <%if (est_table.equals("esti_spe") && !a_a[1].equals("")) {%>checked<%} else if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) {%>checked<%}%> <%if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) {%>disabled<%} else {%><%}%> onClick="javascript:setO11();">
	                  				����2
	                  			</td>
	                  			<td width="5%" class=title  style="border: none !important;">
	                  				<input type="button" class="button" id="btn_copy2" value="����" style="margin-left: 20px;" onclick="javascript:copy_esti_1('2');">
	                  			</td>
	                  		</tr>
	                  	</table>
                  	</td>
                  	<td width="21%" class='title esti_target'>
	                  	<table width="100%">
	                  		<tr>
	                  			<td width="95%" class=title style="border: none !important;">
	                  				<input type="checkbox" name="est_yn" id="est_yn_3" value="Y" <%if (est_table.equals("esti_spe") && !a_a[2].equals("")) {%>checked<%}%> onClick="javascript:setO11();eh_chk('3');">
	                  				����3
	                  			</td>
	                  			<td width="5%" class=title style="border: none !important;">
	                  				<input type="button" class="button" id="btn_copy3" value="����" style="margin-left: 20px;" onclick="javascript:copy_esti_1('3');">
	                  			</td>
	                  		</tr>
	                  	</table>
                  	</td>
                  	<td width="21%" class='title esti_target'>
	                  	<table width="100%">
	                  		<tr>
	                  			<td width="95%" class=title style="border: none !important;">
	                  				<input type="checkbox" name="est_yn" id="est_yn_4" value="Y" <%if (est_table.equals("esti_spe") && !a_a[3].equals("")) {%>checked<%}%> onClick="javascript:setO11();eh_chk('4');">
	                  				����4
	                  			</td>
	                  			<td width="5%" class=title style="border: none !important;">
	                  				<input type="button" class="button" id="btn_copy4" value="����" style="margin-left: 20px;" onclick="javascript:copy_esti_1('4');">
                  				</td>
                  			</tr>
	                  	</table>
                  	</td>
                  	<td id='rent-lease-target3' style='display:none; border-top: 0 !important; border-bottom: 0 !important; border-right: 0 !important;' rowspan='23'></td>
                  	<td id='rent-lease-target4' style='display:none; border: 0 !important;' rowspan='23'></td>
                </tr>   
                                                
                <!-- �ű�_printtype -->
                <tr id=tr_ecar_return style="display:<%if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) {%>''<%} else {%>none<%}%>">
                  	<td colspan='2' class=title>�μ�/�ݳ� ����</td>
                  	<td>
                  		&nbsp;
                  		<select name="return_select" id="return_select_0" onChange="javascript:return_type(0); setO11();">
                      		<option value="" <%if (e_bean.getReturn_select().equals("")) {%> selected<%}%>>=�� ��=</option>
                      		<option value="0" <%if (e_bean.getReturn_select().equals("0")) {%> selected<%}%>>�μ�/�ݳ� ������</option>
                      		<option value="1" <%if (e_bean.getReturn_select().equals("1")) {%> selected<%}%>>�ݳ���</option>
                    	</select> 
                  	</td>
                  	<td>
                  		&nbsp;
                  		<select name="return_select" id="return_select_1" onChange="javascript:return_type(1); setO11();">
                  			<%-- <option value="" <%if (e_bean.getReturn_select().equals("")) {%> selected<%}%>>=�� ��=</option>
		                    <option value="0" <%if (e_bean.getReturn_select().equals("0")) {%> selected<%}%>>�μ�/�ݳ� ������</option>
		                    <option value="1" <%if (e_bean.getReturn_select().equals("1")) {%> selected<%}%>>�ݳ���</option> --%>
		                    <option value="" <%if (e_bean2.getReturn_select().equals("")) {%> selected<%}%>>=�� ��=</option>
		                    <option value="0" <%if (e_bean2.getReturn_select().equals("0")) {%> selected<%}%>>�μ�/�ݳ� ������</option>
		                    <option value="1" <%if (e_bean2.getReturn_select().equals("1")) {%> selected<%}%>>�ݳ���</option>
                    	</select> 
                  	</td>
                  	<td>
                  		&nbsp;
                  		<select name="return_select" id="return_select_2" onChange="javascript:return_type(2); setO11();">
                      		<%-- <option value="" <%if (e_bean.getReturn_select().equals("")) {%> selected<%}%>>=�� ��=</option>
                      		<option value="0" <%if (e_bean.getReturn_select().equals("0")) {%> selected<%}%>>�μ�/�ݳ� ������</option>
                      		<option value="1" <%if (e_bean.getReturn_select().equals("1")) {%> selected<%}%>>�ݳ���</option> --%>
                      		<option value="" <%if (e_bean3.getReturn_select().equals("")) {%> selected<%}%>>=�� ��=</option>
                      		<option value="0" <%if (e_bean3.getReturn_select().equals("0")) {%> selected<%}%>>�μ�/�ݳ� ������</option>
                      		<option value="1" <%if (e_bean3.getReturn_select().equals("1")) {%> selected<%}%>>�ݳ���</option>
                    	</select> 
                  	</td>
                  	<td>
                  		&nbsp;
                  		<select name="return_select" id="return_select_3" onChange="javascript:return_type(3); setO11();">
                      		<%-- <option value="" <%if (e_bean.getReturn_select().equals("")) {%> selected<%}%>>=�� ��=</option>
                      		<option value="0" <%if (e_bean.getReturn_select().equals("0")) {%> selected<%}%>>�μ�/�ݳ� ������</option>
                      		<option value="1" <%if (e_bean.getReturn_select().equals("1")) {%> selected<%}%>>�ݳ���</option> --%>
                      		<option value="" <%if (e_bean4.getReturn_select().equals("")) {%> selected<%}%>>=�� ��=</option>
                      		<option value="0" <%if (e_bean4.getReturn_select().equals("0")) {%> selected<%}%>>�μ�/�ݳ� ������</option>
                      		<option value="1" <%if (e_bean4.getReturn_select().equals("1")) {%> selected<%}%>>�ݳ���</option>
                    	</select> 
                  	</td>
                </tr>

                <tr> 
                    <td colspan='2' class=title>�뿩��ǰ</td>
                    <td>
                    	&nbsp;
                    	<select name="a_a" id="a_a_1" onChange="javascript:SelectA_a(0); setO11();">
	                        <option value="">=�� ��=</option>
                        <%for (int i = 0 ; i < good_size ; i++) {
	                  		CodeBean good = goods[good_size-i-1];%>
	                        <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[0].equals(good.getNm_cd())) {%>selected<%} else {%><%if (e_bean.getA_a().equals(good.getNm_cd())) {%>selected<%}%><%}%>><%= good.getNm()%></option>
	                    <%}%>
                        </select>
                    </td>
                    <td>
                    	&nbsp;
                    	<select name="a_a" id="a_a_2" onChange="javascript:SelectA_a(1); setO11();">
	                        <option value="">=�� ��=</option>
                        <%for (int i = 0 ; i < good_size ; i++) {
	                  		CodeBean good = goods[good_size-i-1];%>
	                        <%-- <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[1].equals(good.getNm_cd())) {%>selected<%} else {%><%if (good.getNm().equals("��ⷻƮ �⺻��"))%>selected<%%><%}%>><%= good.getNm()%></option> --%>
	                        <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[1].equals(good.getNm_cd())) {%> selected <%} else {%><%if (e_bean2.getPrint_type().equals("6")) {%><%if (e_bean2.getA_a().equals(good.getNm_cd())) {%>selected<%}%><%} else {%><%if (good.getNm().equals("��ⷻƮ �⺻��")) {%>selected<%}%><%}%><%}%>><%= good.getNm()%></option>
                        <%}%>
                        </select> 
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select name="a_a" id="a_a_3" onChange="javascript:SelectA_a(2); setO11();">
	                        <option value="">=�� ��=</option>
                        <%for (int i = 0 ; i < good_size ; i++) {
	                  		CodeBean good = goods[good_size-i-1];%>
	                        <%-- <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[2].equals(good.getNm_cd())) {%>selected<%} else {%><%if (good.getNm().equals("��ⷻƮ �⺻��"))%>selected<%%><%}%>><%= good.getNm()%></option> --%>
	                        <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[2].equals(good.getNm_cd())) {%> selected <%} else {%><%if (e_bean3.getPrint_type().equals("6")) {%><%if (e_bean3.getA_a().equals(good.getNm_cd())) {%>selected<%}%><%} else {%><%if (good.getNm().equals("��ⷻƮ �⺻��")) {%>selected<%}%><%}%><%}%>><%= good.getNm()%></option>
                        <%}%>
                        </select> 
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select name="a_a" id="a_a_4" onChange="javascript:SelectA_a(3); setO11();">
	                        <option value="">=�� ��=</option>
                        <%for (int i = 0 ; i < good_size ; i++) {
	                  		CodeBean good = goods[good_size-i-1];%>
	                        <%-- <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[3].equals(good.getNm_cd())) {%>selected<%} else {%><%if (good.getNm().equals("��ⷻƮ �⺻��"))%>selected<%%><%}%>><%= good.getNm()%></option> --%>
	                        <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[3].equals(good.getNm_cd())) {%> selected <%} else {%><%if (e_bean4.getPrint_type().equals("6")) {%><%if (e_bean4.getA_a().equals(good.getNm_cd())) {%>selected<%}%><%} else {%><%if (good.getNm().equals("��ⷻƮ �⺻��")) {%>selected<%}%><%}%><%}%>><%= good.getNm()%></option>
                        <%}%>
                        </select> 
                    </td>
                </tr>
                <tr> 
                    <td colspan='2' class=title>�뿩�Ⱓ</td>
                    <!-- �޺��ڽ��� ����(2018.03.12) -->
                    <td>
                    	&nbsp;
                    	<select id="sel_a_b_1" name='sel_a_b' onchange="javascript:setA_b('1',this.value); set_return2_change(); set_other_esti_value(this);">
                   			<option value="24"<%if (e_bean.getA_b().equals("24")) {%> selected<%}%>>24</option>
                   			<option value="36"<%if (e_bean.getA_b().equals("36")) {%> selected<%}%>>36</option>
							<option value="48"<%if (e_bean.getA_b().equals("48")) {%> selected<%}%>>48</option>
							<option value="60"<%if (e_bean.getA_b().equals("60")) {%> selected<%}%>>60</option> <!--  <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
							<option value="directInput"<%if (!e_bean.getA_b().equals("24")&&!e_bean.getA_b().equals("36")&&!e_bean.getA_b().equals("48")&&!e_bean.getA_b().equals("60")) {%> selected<%}%> >�����Է�</option> <!-- <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="a_b" size="4" id="a_b_1" value="<%=e_bean.getA_b()%>" onBlur='javascript:set_return2_change(); set_other_esti_value(this);'>&nbsp;���� <!--  <%if (e_bean.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td>
                    	&nbsp;
                    	<select id="sel_a_b_2" name='sel_a_b' onchange="javascript:setA_b('2',this.value);">
                    	<%if (est_table.equals("esti_spe") || !e_bean2.getA_b().equals("")) {%>
                    		<option value="24"<%if (e_bean2.getA_b().equals("24")) {%> selected<%}%>>24</option>
                    		<option value="36"<%if (e_bean2.getA_b().equals("36")) {%> selected<%}%>>36</option>
							<option value="48"<%if (e_bean2.getA_b().equals("48")) {%> selected<%}%>>48</option>
							<option value="60"<%if (e_bean2.getA_b().equals("60")) {%> selected<%}%>>60</option> <!--  <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%} else {%>
							<option value="24">24</option>
							<option value="36">36</option>
							<option value="48" selected>48</option>
							<option value="60">60</option> <!--  <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%}%>	
							<option value="directInput"<%if (!e_bean2.getA_b().equals("24")&&!e_bean2.getA_b().equals("36")&&!e_bean2.getA_b().equals("48")&&!e_bean2.getA_b().equals("60")) {%> selected<%}%>>�����Է�</option> <!--  <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="a_b" size="4" id="a_b_2" value="<%=e_bean2.getA_b()%>" >&nbsp;���� <!-- <%if (e_bean2.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select id="sel_a_b_3" name='sel_a_b' onchange="javascript:setA_b('3',this.value);">
                    	<%if (est_table.equals("esti_spe") || !e_bean3.getA_b().equals("")) {%>
                    		<option value="24"<%if (e_bean3.getA_b().equals("24")) {%> selected<%}%>>24</option>
                    		<option value="36"<%if (e_bean3.getA_b().equals("36")) {%> selected<%}%>>36</option>
							<option value="48"<%if (e_bean3.getA_b().equals("48")) {%> selected<%}%>>48</option>
							<option value="60"<%if (e_bean3.getA_b().equals("60")) {%> selected<%}%>>60</option> <!--  <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%} else {%>
							<option value="24">24</option>
							<option value="36">36</option>
							<option value="48" selected>48</option>
							<option value="60">60</option><!--  <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%}%>	
							<option value="directInput"<%if (!e_bean2.getA_b().equals("24")&&!e_bean3.getA_b().equals("36")&&!e_bean3.getA_b().equals("48")&&!e_bean3.getA_b().equals("60")) {%> selected<%}%> >�����Է�</option> <!-- <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="a_b" size="4" id="a_b_3" value="<%=e_bean3.getA_b()%>">&nbsp;���� <!--  <%if (e_bean3.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select id="sel_a_b_4" name='sel_a_b' onchange="javascript:setA_b('4',this.value);">
                    	<%if (est_table.equals("esti_spe") || !e_bean4.getA_b().equals("")) {%>
                    		<option value="24"<%if (e_bean4.getA_b().equals("24")) {%> selected<%}%>>24</option>
                    		<option value="36"<%if (e_bean4.getA_b().equals("36")) {%> selected<%}%>>36</option>
							<option value="48"<%if (e_bean4.getA_b().equals("48")) {%> selected<%}%>>48</option>
							<option value="60"<%if (e_bean4.getA_b().equals("60")) {%> selected<%}%>>60</option> <!--  <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%} else {%>
							<option value="24">24</option>
							<option value="36">36</option>
							<option value="48" selected>48</option>
							<option value="60">60</option> <!--  <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%}%>	
							<option value="directInput"<%if (!e_bean2.getA_b().equals("24")&&!e_bean4.getA_b().equals("36")&&!e_bean4.getA_b().equals("48")&&!e_bean4.getA_b().equals("60")) {%> selected<%}%>>�����Է�</option><!--  <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="a_b" size="4" id="a_b_4" value="<%=e_bean4.getA_b()%>" >&nbsp;���� <!-- <%if (e_bean4.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                </tr>
                <tr> 
                    <td width='3%' rowspan="2" class=title>����<br>�Ÿ�</td>
                    <td class=title width='12%'>ǥ�� ��������Ÿ�</td>
                    <td>
                    	&nbsp;
                        <input type="text" name="b_agree_dist" id="b_agree_dist_1" class=whitenum readonly size="10" value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/��
					</td>
                    <td>
                    	&nbsp;
					    <input type="text" name="b_agree_dist" id="b_agree_dist_2" class=whitenum readonly size="10" value='<%=AddUtil.parseDecimal(e_bean2.getB_agree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
					    km/��
					</td>
                    <td class='esti_target'>
                    	&nbsp;
					    <input type="text" name="b_agree_dist" id="b_agree_dist_3" class=whitenum readonly size="10" value='<%=AddUtil.parseDecimal(e_bean3.getB_agree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
					    km/��
				    </td>
                    <td class='esti_target'>
                    	&nbsp;
						<input type="text" name="b_agree_dist" id="b_agree_dist_4" class=whitenum readonly size="10" value='<%=AddUtil.parseDecimal(e_bean4.getB_agree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
					    km/��
					</td>
                </tr>                   
                <tr> 
                    <td class=title>���� ��������Ÿ�</td>   
      				<!-- �޺��ڽ��� ����(2018.03.12) -->
      				<td>
      					&nbsp;
                    	<select class="sel_a_dist" id="sel_agree_dist_1" name='sel_agree_dist' onchange="javascript:setAgree_dist('1', this.value); set_return2_change(); set_other_esti_value(this);">
                   			<option value="10000" <%if (e_bean.getAgree_dist()==10000) {%>selected<%}%>>10,000</option>
							<option value="15000" <%if (e_bean.getAgree_dist()==15000) {%>selected<%}%>>15,000</option>
							<option value="20000" <%if (e_bean.getAgree_dist()==20000) {%>selected<%}%>>20,000</option>
							<option value="23000" <%if (e_bean.getAgree_dist()==23000) {%>selected<%}%>>23,000</option>
							<option value="25000" <%if (e_bean.getAgree_dist()==25000) {%>selected<%}%>>25,000</option>
							<option value="28000" <%if (e_bean.getAgree_dist()==28000) {%>selected<%}%>>28,000</option>
							<option value="30000" <%if (e_bean.getAgree_dist()==30000) {%>selected<%}%>>30,000</option>
<%-- 							<%if (!e_bean.getCar_comp_id().equals("0056")) {%> --%>
							<option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%>>50,000</option>
<%-- 							<%} %> --%>
							<%-- <option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%> <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%> <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%> <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%> <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%>>50,000</option> --%>
							<option value="directInput" <%if (e_bean.getAgree_dist()!=10000 && e_bean.getAgree_dist()!=15000 && e_bean.getAgree_dist()!=20000 && e_bean.getAgree_dist()!=23000 && e_bean.getAgree_dist()!=25000 && e_bean.getAgree_dist()!=28000
														 && e_bean.getAgree_dist()!=30000 && e_bean.getAgree_dist()!=35000 && e_bean.getAgree_dist()!=40000 && e_bean.getAgree_dist()!=45000
													  	 && e_bean.getAgree_dist()!=50000) {%>selected<%}%> >�����Է�</option> <!-- <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="agree_dist" class="num" size="10" id="agree_dist_1" value="<%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>"  onBlur='javascript:this.value=parseDecimal(this.value);set_return2_change(); set_other_esti_value(this);'>&nbsp;km/�� <!-- <%if (e_bean.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td>
                    	&nbsp;
                    	<select class="sel_a_dist" id="sel_agree_dist_2" name='sel_agree_dist' onchange="javascript:setAgree_dist('2', this.value);">
                   			<option value="10000" <%if (e_bean2.getAgree_dist()==10000) {%>selected<%}%>>10,000</option>
							<option value="15000" <%if (e_bean2.getAgree_dist()==15000) {%>selected<%}%>>15,000</option>
							<option value="20000" <%if (e_bean2.getAgree_dist()==20000) {%>selected<%}%>>20,000</option>
							<option value="23000" <%if (e_bean2.getAgree_dist()==23000) {%>selected<%}%>>23,000</option>
							<option value="25000" <%if (e_bean2.getAgree_dist()==25000) {%>selected<%}%>>25,000</option>
							<option value="28000" <%if (e_bean2.getAgree_dist()==28000) {%>selected<%}%>>28,000</option>
							<option value="30000" <%if (e_bean2.getAgree_dist()==30000) {%>selected<%}%>>30,000</option>
<%-- 							<%if (!e_bean.getCar_comp_id().equals("0056")) {%> --%>
							<option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%>>50,000</option>
<%-- 							<%} %> --%>
							<%-- <option value="35000" <%if (e_bean2.getAgree_dist()==35000) {%>selected<%}%> <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%>>35,000</option>
							<option value="40000" <%if (e_bean2.getAgree_dist()==40000) {%>selected<%}%> <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%>>40,000</option>
							<option value="45000" <%if (e_bean2.getAgree_dist()==45000) {%>selected<%}%> <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%>>45,000</option>
							<option value="50000" <%if (e_bean2.getAgree_dist()==50000) {%>selected<%}%> <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%>>50,000</option> --%>
							<option value="directInput" <%if (e_bean2.getAgree_dist()!=10000 && e_bean2.getAgree_dist()!=15000 && e_bean2.getAgree_dist()!=20000 && e_bean2.getAgree_dist()!=23000 && e_bean2.getAgree_dist()!=25000 && e_bean2.getAgree_dist()!=28000
														 && e_bean2.getAgree_dist()!=30000 && e_bean2.getAgree_dist()!=35000 && e_bean2.getAgree_dist()!=40000 && e_bean2.getAgree_dist()!=45000
													  	 && e_bean2.getAgree_dist()!=50000) {%>selected<%}%> >�����Է�</option> <!-- <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="agree_dist" class="num" size="10" id="agree_dist_2" value="<%=AddUtil.parseDecimal(e_bean2.getAgree_dist())%>"  onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km/�� <!-- <%if (e_bean2.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select class="sel_a_dist" id="sel_agree_dist_3" name='sel_agree_dist' onchange="javascript:setAgree_dist('3', this.value);">
                   			<option value="10000" <%if (e_bean3.getAgree_dist()==10000) {%>selected<%}%>>10,000</option>
							<option value="15000" <%if (e_bean3.getAgree_dist()==15000) {%>selected<%}%>>15,000</option>
							<option value="20000" <%if (e_bean3.getAgree_dist()==20000) {%>selected<%}%>>20,000</option>
							<option value="23000" <%if (e_bean3.getAgree_dist()==23000) {%>selected<%}%>>23,000</option>
							<option value="25000" <%if (e_bean3.getAgree_dist()==25000) {%>selected<%}%>>25,000</option>
							<option value="28000" <%if (e_bean3.getAgree_dist()==28000) {%>selected<%}%>>28,000</option>
							<option value="30000" <%if (e_bean3.getAgree_dist()==30000) {%>selected<%}%>>30,000</option>
<%-- 							<%if (!e_bean.getCar_comp_id().equals("0056")) {%> --%>
							<option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%>>50,000</option>
<%-- 							<%} %> --%>
							<%-- <option value="35000" <%if (e_bean3.getAgree_dist()==35000) {%>selected<%}%> <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%>>35,000</option>
							<option value="40000" <%if (e_bean3.getAgree_dist()==40000) {%>selected<%}%> <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%>>40,000</option>
							<option value="45000" <%if (e_bean3.getAgree_dist()==45000) {%>selected<%}%> <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%>>45,000</option>
							<option value="50000" <%if (e_bean3.getAgree_dist()==50000) {%>selected<%}%> <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%>>50,000</option> --%>
							<option value="directInput" <%if (e_bean3.getAgree_dist()!=10000 && e_bean3.getAgree_dist()!=15000 && e_bean3.getAgree_dist()!=20000 && e_bean3.getAgree_dist()!=23000 && e_bean3.getAgree_dist()!=25000 && e_bean3.getAgree_dist()!=28000
														 && e_bean3.getAgree_dist()!=30000 && e_bean3.getAgree_dist()!=35000 && e_bean3.getAgree_dist()!=40000 && e_bean3.getAgree_dist()!=45000
													  	 && e_bean3.getAgree_dist()!=50000) {%>selected<%}%> >�����Է�</option> <!-- <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="agree_dist" class="num" size="10" id="agree_dist_3" value="<%=AddUtil.parseDecimal(e_bean3.getAgree_dist())%>"  onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km/�� <!-- <%if (e_bean3.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select class="sel_a_dist" id="sel_agree_dist_4" name='sel_agree_dist' onchange="javascript:setAgree_dist('4', this.value);">
                   			<option value="10000" <%if (e_bean4.getAgree_dist()==10000) {%>selected<%}%>>10,000</option>
							<option value="15000" <%if (e_bean4.getAgree_dist()==15000) {%>selected<%}%>>15,000</option>
							<option value="20000" <%if (e_bean4.getAgree_dist()==20000) {%>selected<%}%>>20,000</option>
							<option value="23000" <%if (e_bean4.getAgree_dist()==23000) {%>selected<%}%>>23,000</option>
							<option value="25000" <%if (e_bean4.getAgree_dist()==25000) {%>selected<%}%>>25,000</option>
							<option value="28000" <%if (e_bean4.getAgree_dist()==28000) {%>selected<%}%>>28,000</option>
							<option value="30000" <%if (e_bean4.getAgree_dist()==30000) {%>selected<%}%>>30,000</option>
<%-- 							<%if (!e_bean.getCar_comp_id().equals("0056")) {%> --%>
							<option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%>>50,000</option>
<%-- 							<%} %> --%>
							<%-- <option value="35000" <%if (e_bean4.getAgree_dist()==35000) {%>selected<%}%> <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%>>35,000</option>
							<option value="40000" <%if (e_bean4.getAgree_dist()==40000) {%>selected<%}%> <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%>>40,000</option>
							<option value="45000" <%if (e_bean4.getAgree_dist()==45000) {%>selected<%}%> <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%>>45,000</option>
							<option value="50000" <%if (e_bean4.getAgree_dist()==50000) {%> selected<%}%> <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%>>50,000</option> --%>
							<option value="directInput" <%if (e_bean4.getAgree_dist()!=10000 && e_bean4.getAgree_dist()!=15000 && e_bean4.getAgree_dist()!=20000 && e_bean4.getAgree_dist()!=23000 && e_bean4.getAgree_dist()!=25000 && e_bean4.getAgree_dist()!=28000
														 && e_bean4.getAgree_dist()!=30000 && e_bean4.getAgree_dist()!=35000 && e_bean4.getAgree_dist()!=40000 && e_bean4.getAgree_dist()!=45000
													  	 && e_bean4.getAgree_dist()!=50000) {%>selected<%}%> >�����Է�</option> <!-- <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="agree_dist" class="num" size="10" id="agree_dist_4" value="<%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>"  onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km/�� <!-- <%if (e_bean4.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                </tr>  
                <tr> 
                    <td width='3%' rowspan="4" class=title>�ܰ�</td>
                    <td class=title width='12%'>ǥ�� �ִ��ܰ�</td>
                    <td>
                    	&nbsp;
                        <input type="text" name="b_o_13" id="b_o_13_1" size="4" value='<%=e_bean.getB_o_13()%>' class=whitenum readonly  onblur="javascript:compare(0, this)">
                        %
                        <!-- ������ȹ��, ������ ����, ���� ���常 ����. + ������ -->
                        <%if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
                        &nbsp;&nbsp;&nbsp;&nbsp;
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn_1' onchange="javascript:searchO13(0);">
	                        	<option value='0'>ȯ�޴뿩�� ����</option>
	                        	<option value='1'>������</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
					</td>
                    <td>
                    	&nbsp;
                        <input type="text" name="b_o_13" id="b_o_13_2" size="4" value='<%=e_bean2.getB_o_13()%>' class=whitenum readonly  onblur="javascript:compare(1, this)">
     					 %
     					 <!-- ������ȹ��, ������ ����, ���� ���常 ����. + ������ -->
                        <%if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
                        &nbsp;&nbsp;&nbsp;&nbsp;
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn_2' onchange="javascript:searchO13(1);">
	                        	<option value='0'>ȯ�޴뿩�� ����</option>
	                        	<option value='1'>������</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
  					 </td>
                    <td class='esti_target'>
                    	&nbsp;
                        <input type="text" name="b_o_13" id="b_o_13_3" size="4" value='<%=e_bean3.getB_o_13()%>' class=whitenum readonly  onblur="javascript:compare(2, this)">
      					%
      					<!-- ������ȹ��, ������ ����, ���� ���常 ����. + ������ -->
                        <%if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
                        &nbsp;&nbsp;&nbsp;&nbsp;
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn_3' onchange="javascript:searchO13(2);">
	                        	<option value='0'>ȯ�޴뿩�� ����</option>
	                        	<option value='1'>������</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
   					</td>
                    <td class='esti_target'>
                    	&nbsp;
                        <input type="text" name="b_o_13" id="b_o_13_4" size="4" value='<%=e_bean4.getB_o_13()%>' class=whitenum readonly  onblur="javascript:compare(3, this)">
      					%
      					<!-- ������ȹ��, ������ ����, ���� ���常 ����. + ������ -->
                        <%if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
                        &nbsp;&nbsp;&nbsp;&nbsp;
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn_4' onchange="javascript:searchO13(3);">
	                        	<option value='0'>ȯ�޴뿩�� ����</option>
	                        	<option value='1'>������</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
   					</td>
                </tr>
                
                <tr>                     
                    <td class=title>���� �ִ��ܰ�</td>
                    <td>
                    	&nbsp;
                        <input type="text" name="o_13" id="o_13_1" size="4" value='<%=e_bean.getO_13()%>' class="whitenum num_weight" readonly  onblur="javascript:compare(0, this)">
                        <span class="num_weight">%</span>
                        &nbsp;&nbsp;&nbsp;
                        <a onclick="set_time()" href="javascript:searchO13(0);"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
                        <%if (nm_db.getWorkAuthUser("������",user_id)) {//�ܰ���� ����%>
                        <input type="checkbox" name="O13_yn" value="Y" >����
                        <%}%>
                    </td>
                    <td>
                    	&nbsp;
                        <input type="text" name="o_13" id="o_13_2" size="4" value='<%=e_bean2.getO_13()%>' class="whitenum num_weight" readonly  onblur="javascript:compare(1, this)">
      					<span class="num_weight">%</span>
      					&nbsp;&nbsp;&nbsp;
      					<a href="javascript:searchO13(1);"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
      				</td>
                    <td class='esti_target'>
                    	&nbsp;
                        <input type="text" name="o_13" id="o_13_3" size="4" value='<%=e_bean3.getO_13()%>' class="whitenum num_weight" readonly  onblur="javascript:compare(2, this)">
      					<span class="num_weight">%</span>
      					&nbsp;&nbsp;&nbsp;
      					<a href="javascript:searchO13(2);"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
      				</td>
                    <td class='esti_target'>
                    	&nbsp;
                        <input type="text" name="o_13" id="o_13_4" size="4" value='<%=e_bean4.getO_13()%>' class="whitenum num_weight" readonly  onblur="javascript:compare(3, this)">
      					<span class="num_weight">%</span>
      					&nbsp;&nbsp;&nbsp;
      					<a href="javascript:searchO13(3);"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
      				</td>
                </tr>              
                                                  
                <tr> 
                    <td class=title>�����ܰ�</td>
                    <td>
                    	<%-- <div id="ro_13_0_display_1" style="display: <%if (e_bean.getOpt_chk().equals("0")) {%>none<%} else {%><%}%>"> --%>
                    	<div id="ro_13_0_display_1" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean.getCar_comp_id().equals("0056")) {%><%if (e_bean.getOpt_chk().equals("0")) {%>none<%} else {%><%}%><%} else {%><%}%>">
	                    	&nbsp;
		                    <input type="text" name="ro_13" id="ro_13_1" size="4" value='<%=e_bean.getRo_13()%>' class="num num_weight"  onblur="javascript:compare(0, this);set_return2_change();">
		                    <span class="num_weight">%</span><br>&nbsp;
		                    <input type="text" name="ro_13_amt" id="ro_13_amt_1" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change();'>
		                        ��
                        </div>
                        <%-- <div id="ro_13_0_display_2" style="display: <%if (e_bean.getOpt_chk().equals("0")) {%><%} else {%>none<%}%>"> --%>
                        <div id="ro_13_0_display_2" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean.getCar_comp_id().equals("0056")) {%><%if (e_bean.getOpt_chk().equals("0")) {%><%} else {%>none<%}%><%} else {%>none<%}%>">
					    	&nbsp;
					    	�̰���
					    </div>
                        <div id="ro_13_0_display_3" style="float: right; text-align: right; margin-top: -40px; margin-right: 15px; display: <%if (e_bean.getCar_comp_id().equals("0056")) {%><%} else {%>none<%}%>">
					    	<!-- �� �������� ��������:<br>
					    	�����ִ��ܰ� -3%,<br>
					    	�ܰ������� ������� ��� -->
					    </div>
                    </td>
                    <td>
                    	<%-- <div id="ro_13_1_display_1" style="display: <%if (e_bean2.getOpt_chk().equals("0")) {%>none<%} else {%><%}%>"> --%>
                    	<div id="ro_13_1_display_1" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean2.getCar_comp_id().equals("0056")) {%><%if (e_bean2.getOpt_chk().equals("0")) {%>none<%} else {%><%}%><%} else {%><%}%>">
	                    	&nbsp;
		                    <input type="text" name="ro_13" id="ro_13_2" size="4" value='<%=e_bean2.getRo_13()%>' class="num num_weight" onblur="javascript:compare(1, this)">
						    <span class="num_weight">%</span><br>&nbsp;
						    <input type="text" name="ro_13_amt" id="ro_13_amt_2" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);'>
						     ��
					    </div>
					    <%-- <div id="ro_13_1_display_2" style="display: <%if (e_bean2.getOpt_chk().equals("0")) {%><%} else {%>none<%}%>"> --%>
					    <div id="ro_13_1_display_2" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean2.getCar_comp_id().equals("0056")) {%><%if (e_bean2.getOpt_chk().equals("0")) {%><%} else {%>none<%}%><%} else {%>none<%}%>">
					    	&nbsp;
					    	�̰���
					    </div>
					    <div id="ro_13_1_display_3" style="float: right; text-align: right; margin-top: -40px; margin-right: 15px; display: <%if (e_bean2.getCar_comp_id().equals("0056")) {%><%} else {%>none<%}%>">
							<!-- �� �������� ��������:<br>
							�����ִ��ܰ� -3%,<br>
					    	�ܰ������� ������� ��� -->
					    </div>
				    </td>
                    <td class='esti_target'>
                    	<!-- <div id="ro_13_2_display_1"> -->
                    	<div id="ro_13_2_display_1" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean3.getCar_comp_id().equals("0056")) {%><%if (e_bean3.getOpt_chk().equals("0")) {%>none<%} else {%><%}%><%} else {%><%}%>">
	                    	&nbsp;
	                        <input type="text" name="ro_13" id="ro_13_3" size="4" value='<%=e_bean3.getRo_13()%>' class="num num_weight" onblur="javascript:compare(2, this)">
							<span class="num_weight">%</span><br>&nbsp;
							<input type="text" name="ro_13_amt" id="ro_13_amt_3" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);'>
							��
						</div>
						<!-- <div id="ro_13_2_display_2" style="display: none;"> -->
						<div id="ro_13_2_display_2" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean3.getCar_comp_id().equals("0056")) {%><%if (e_bean3.getOpt_chk().equals("0")) {%><%} else {%>none<%}%><%} else {%>none<%}%>">
					    	&nbsp;
					    	�̰���
					    </div>
					    <div id="ro_13_2_display_3" style="float: right; text-align: right; margin-top: -40px; margin-right: 15px; display: <%if (e_bean3.getCar_comp_id().equals("0056")) {%><%} else {%>none<%}%>">
					    	<!-- �� �������� ��������:<br>
					    	�����ִ��ܰ� -3%,<br>
					    	�ܰ������� ������� ��� -->
					    </div>
					</td>
                    <td class='esti_target'>
                    	<!-- <div id="ro_13_3_display_1"> -->
                    	<div id="ro_13_3_display_1" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean4.getCar_comp_id().equals("0056")) {%><%if (e_bean4.getOpt_chk().equals("0")) {%>none<%} else {%><%}%><%} else {%><%}%>">
	                    	&nbsp;
	                        <input type="text" name="ro_13" id="ro_13_4" size="4" value='<%=e_bean4.getRo_13()%>' class="num num_weight" onblur="javascript:compare(3, this)">
							<span class="num_weight">%</span><br>&nbsp;
							<input type="text" name="ro_13_amt" id="ro_13_amt_4" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);'>
							��
						</div>
						<!-- <div id="ro_13_3_display_2" style="display: none;"> -->
						<div id="ro_13_3_display_2" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean4.getCar_comp_id().equals("0056")) {%><%if (e_bean4.getOpt_chk().equals("0")) {%><%} else {%>none<%}%><%} else {%>none<%}%>">
					    	&nbsp;
					    	�̰���
					    </div>
					    <div id="ro_13_3_display_3" style="float: right; text-align: right; margin-top: -40px; margin-right: 15px; display: <%if (e_bean4.getCar_comp_id().equals("0056")) {%><%} else {%>none<%}%>">
					    	<!-- �� �������� ��������:<br>
					    	�����ִ��ܰ� -3%,<br>
					    	�ܰ������� ������� ��� -->
					    </div>
					</td>
                </tr>                    
                        
                <tr> 
                    <td class=title>���Կɼ�</td>
                    <td>
                    	&nbsp;
                    	<select name="opt_chk" id="opt_chk_1">
                      		<option value="0" <%if (est_table.equals("esti_spe") && opt_chk[0].equals("0")) {%>selected<%} else {%><%if (e_bean.getOpt_chk().equals("0")) {%>selected<%}%><%}%>>�̺ο�</option>
                      		<option value="1" <%if (est_table.equals("esti_spe") && opt_chk[0].equals("1")) {%>selected<%} else {%><%if (e_bean.getOpt_chk().equals("1")) {%>selected<%}%><%}%>>�ο�</option>
                    	</select>
                    </td>
                    <td>
                    	&nbsp;
                    	<select name="opt_chk" id="opt_chk_2">
                      		<option value="0" <%if (est_table.equals("esti_spe") && opt_chk[1].equals("0")) {%>selected<%} else {%><%if (e_bean2.getOpt_chk().equals("0")) {%>selected<%}%><%}%>>�̺ο�</option>
                      		<option value="1" <%if (est_table.equals("esti_spe") && opt_chk[1].equals("1")) {%>selected<%} else {%><%if (e_bean2.getOpt_chk().equals("1")) {%>selected<%}%><%}%>>�ο�</option>
                    	</select>
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select name="opt_chk" id="opt_chk_3">
                      		<option value="0" <%if (est_table.equals("esti_spe") && opt_chk[2].equals("0")) {%>selected<%} else {%><%if (e_bean3.getOpt_chk().equals("0")) {%>selected<%}%><%}%>>�̺ο�</option>
                      		<option value="1" <%if (est_table.equals("esti_spe") && opt_chk[2].equals("1")) {%>selected<%} else {%><%if (e_bean3.getOpt_chk().equals("1")) {%>selected<%}%><%}%>>�ο�</option>
                    	</select>
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select name="opt_chk" id="opt_chk_4">
                      		<option value="0" <%if (est_table.equals("esti_spe") && opt_chk[3].equals("0")) {%>selected<%} else {%><%if (e_bean4.getOpt_chk().equals("0")) {%>selected<%}%><%}%>>�̺ο�</option>
                      		<option value="1" <%if (est_table.equals("esti_spe") && opt_chk[3].equals("1")) {%>selected<%} else {%><%if (e_bean4.getOpt_chk().equals("1")) {%>selected<%}%><%}%>>�ο�</option>
                    	</select>
                    </td>
                </tr> 
                <tr> 
                    <td rowspan="3" class=title>����</td>
                    <td class=title>������</td>  
				      <!-- �޺��ڽ��� ����(2018.03.12) -->
			      	<td>
			      		&nbsp;
                    	<select id="sel_rg_8_1" name='sel_rg_8' onchange="javascript:setRg_8('1',this.value);set_return2_change(); set_other_esti_value(this);">
                   			<option value="0" <%if (e_bean.getRg_8()==0) {%> selected<%}%>>0</option>
							<option value="10"<%if (e_bean.getRg_8()==10) {%> selected<%}%>>10</option>
							<option value="15"<%if (e_bean.getRg_8()==15) {%> selected<%}%>>15</option>
							<option value="20"<%if (e_bean.getRg_8()==20) {%> selected<%}%>>20</option>
							<option value="25"<%if (e_bean.getRg_8()==25) {%> selected<%}%>>25</option>
							<option value="30"<%if (e_bean.getRg_8()==30) {%> selected<%}%>>30</option>
							<option value="35"<%if (e_bean.getRg_8()==35) {%> selected<%}%>>35</option>
							<option value="40"<%if (e_bean.getRg_8()==40) {%> selected<%}%>>40</option>
							<option value="50"<%if (e_bean.getRg_8()==50) {%> selected<%}%>>50</option>
							<option value="directInput"<%if (e_bean.getRg_8()!= 0 && e_bean.getRg_8()!=10 && e_bean.getRg_8()!=15 && e_bean.getRg_8()!=20 
														 && e_bean.getRg_8()!=25 && e_bean.getRg_8()!=30 && e_bean.getRg_8()!=35 && e_bean.getRg_8()!=40
														 && e_bean.getRg_8()!=50) {%> selected<%}%>>�����Է�</option></select>
                    	<input type="text" name="rg_8" class="num" size="4" id="rg_8_1" value="<%=e_bean.getRg_8()%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change(); set_other_esti_value(this);'>&nbsp;%<br>&nbsp;
				      	<input type="text" name="rg_8_amt" id="rg_8_amt_1" value='<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>' class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change(); set_other_esti_value(this);'>&nbsp;��
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select id="sel_rg_8_2" name='sel_rg_8' onchange="javascript:setRg_8('2',this.value);">
                   			<option value="0" <%if (e_bean2.getRg_8()==0) {%> selected<%}%>>0</option>
							<option value="10"<%if (e_bean2.getRg_8()==10) {%> selected<%}%>>10</option>
							<option value="15"<%if (e_bean2.getRg_8()==15) {%> selected<%}%>>15</option>
							<option value="20"<%if (e_bean2.getRg_8()==20) {%> selected<%}%>>20</option>
							<option value="25"<%if (e_bean2.getRg_8()==25) {%> selected<%}%>>25</option>
							<option value="30"<%if (e_bean2.getRg_8()==30) {%> selected<%}%>>30</option>
							<option value="35"<%if (e_bean2.getRg_8()==35) {%> selected<%}%>>35</option>
							<option value="40"<%if (e_bean2.getRg_8()==40) {%> selected<%}%>>40</option>
							<option value="50"<%if (e_bean2.getRg_8()==50) {%> selected<%}%>>50</option>
							<option value="directInput"<%if (e_bean2.getRg_8()!= 0 && e_bean2.getRg_8()!=10 && e_bean2.getRg_8()!=15 && e_bean2.getRg_8()!=20 
														 && e_bean2.getRg_8()!=25 && e_bean2.getRg_8()!=30 && e_bean2.getRg_8()!=35 && e_bean2.getRg_8()!=40
														 && e_bean2.getRg_8()!=50) {%> selected<%}%>>�����Է�</option></select>
                    	<input type="text" name="rg_8" class="num" size="4" id="rg_8_2" value="<%=e_bean2.getRg_8()%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);'>&nbsp;%<br>&nbsp;
				      	<input type="text" name="rg_8_amt" id="rg_8_amt_2" value='<%=AddUtil.parseDecimal(e_bean2.getRg_8_amt())%>' class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);'>&nbsp;��
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select id="sel_rg_8_3" name='sel_rg_8' onchange="javascript:setRg_8('3',this.value);">
                   			<option value="0" <%if (e_bean3.getRg_8()==0) {%> selected<%}%>>0</option>
							<option value="10"<%if (e_bean3.getRg_8()==10) {%> selected<%}%>>10</option>
							<option value="15"<%if (e_bean3.getRg_8()==15) {%> selected<%}%>>15</option>
							<option value="20"<%if (e_bean3.getRg_8()==20) {%> selected<%}%>>20</option>
							<option value="25"<%if (e_bean3.getRg_8()==25) {%> selected<%}%>>25</option>
							<option value="30"<%if (e_bean3.getRg_8()==30) {%> selected<%}%>>30</option>
							<option value="35"<%if (e_bean3.getRg_8()==35) {%> selected<%}%>>35</option>
							<option value="40"<%if (e_bean3.getRg_8()==40) {%> selected<%}%>>40</option>
							<option value="50"<%if (e_bean3.getRg_8()==50) {%> selected<%}%>>50</option>
							<option value="directInput"<%if (e_bean3.getRg_8()!= 0 && e_bean3.getRg_8()!=10 && e_bean3.getRg_8()!=15 && e_bean3.getRg_8()!=20 
														 && e_bean3.getRg_8()!=25 && e_bean3.getRg_8()!=30 && e_bean3.getRg_8()!=35 && e_bean3.getRg_8()!=40
														 && e_bean3.getRg_8()!=50) {%> selected<%}%>>�����Է�</option></select>
                    	<input type="text" name="rg_8" class="num" size="4" id="rg_8_3" value="<%=e_bean3.getRg_8()%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);'>&nbsp;%<br>&nbsp;
				      	<input type="text" name="rg_8_amt" id="rg_8_amt_3" value='<%=AddUtil.parseDecimal(e_bean3.getRg_8_amt())%>' class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);'>&nbsp;��
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select id="sel_rg_8_4" name='sel_rg_8' onchange="javascript:setRg_8('4',this.value);">
                   			<option value="0" <%if (e_bean4.getRg_8()==0) {%> selected<%}%>>0</option>
							<option value="10"<%if (e_bean4.getRg_8()==10) {%> selected<%}%>>10</option>
							<option value="15"<%if (e_bean4.getRg_8()==15) {%> selected<%}%>>15</option>
							<option value="20"<%if (e_bean4.getRg_8()==20) {%> selected<%}%>>20</option>
							<option value="25"<%if (e_bean4.getRg_8()==25) {%> selected<%}%>>25</option>
							<option value="30"<%if (e_bean4.getRg_8()==30) {%> selected<%}%>>30</option>
							<option value="35"<%if (e_bean4.getRg_8()==35) {%> selected<%}%>>35</option>
							<option value="40"<%if (e_bean4.getRg_8()==40) {%> selected<%}%>>40</option>
							<option value="50"<%if (e_bean4.getRg_8()==50) {%> selected<%}%>>50</option>
							<option value="directInput"<%if (e_bean4.getRg_8()!= 0 && e_bean4.getRg_8()!=10 && e_bean4.getRg_8()!=15 && e_bean4.getRg_8()!=20 
														 && e_bean4.getRg_8()!=25 && e_bean4.getRg_8()!=30 && e_bean4.getRg_8()!=35 && e_bean4.getRg_8()!=40
														 && e_bean4.getRg_8()!=50) {%> selected<%}%>>�����Է�</option></select>
                    	<input type="text" name="rg_8" class="num" size="4" id="rg_8_4" value="<%=e_bean4.getRg_8()%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);'>&nbsp;%<br>&nbsp;
				      	<input type="text" name="rg_8_amt" id="rg_8_amt_4" value='<%=AddUtil.parseDecimal(e_bean4.getRg_8_amt())%>' class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);'>&nbsp;��
                    </td>
                    <td id='equal_condition2' class='equal-condition' style='display: none;' rowspan='14'>����1�� ���� ����</td>
                	<td id='equal_condition3' class='equal-condition' style='display: none;' rowspan='14'>����1�� ���� ����</td>
                	<td id='equal_condition4' class='equal-condition' style='display: none;' rowspan='14'>����1�� ���� ����</td>
                </tr>
                <tr> 
                    <td class=title>������</td>
                    <td>
                    	&nbsp;
                      	<input type="text" name="pp_per" id="pp_per_1" class=num size="4" value='<%=e_bean.getPp_per()%>' onBlur="javascript:compare(0, this);set_return2_change();"> %
                      	<br>
                      	&nbsp;
                      	<input type="text" name="pp_amt" id="pp_amt_1" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change();'> ��
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                        <input type="text" name="pp_per" id="pp_per_2" class=num size="4" value='<%=e_bean2.getPp_per()%>' onBlur="javascript:compare(1, this)"> %
				      	<br>
					    &nbsp;
      					<input type="text" name="pp_amt" id="pp_amt_2" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean2.getPp_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);'> �� 
      				</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                        <input type="text" name="pp_per" id="pp_per_3" class=num size="4" value='<%=e_bean3.getPp_per()%>' onBlur="javascript:compare(2, this)"> %
      					<br>
      					&nbsp;
      					<input type="text" name="pp_amt" id="pp_amt_3" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean3.getPp_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);'> �� 
      				</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                        <input type="text" name="pp_per" id="pp_per_4" class=num size="4" value='<%=e_bean4.getPp_per()%>' onBlur="javascript:compare(3, this)"> %
				      	<br>
				    	&nbsp;
					    <input type="text" name="pp_amt" id="pp_amt_4" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean4.getPp_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);'> �� 
					</td>
                </tr>
                <tr> 
                    <td class=title>���ô뿩��</td>
                    <td>
                    	&nbsp;
                    	<font color="#666666"> 
                      		<input type="text" name="g_10" id="g_10_1" class=num size="2" value="<%=e_bean.getG_10()%>" onBlur='javascript:set_return2_change(); set_other_esti_value(this);'>
                      		����ġ
                      	</font>
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<font color="#666666">
                      		<input type="text" name="g_10" id="g_10_2" class=num size="2" value="<%=e_bean2.getG_10()%>">
            				����ġ
           				</font>
           			</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<font color="#666666">
                      		<input type="text" name="g_10" id="g_10_3" class=num size="2" value="<%=e_bean3.getG_10()%>">
            				����ġ
            			</font>
            		</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<font color="#666666">
	                      	<input type="text" name="g_10" id="g_10_4" class=num size="2" value="<%=e_bean4.getG_10()%>">
	            			����ġ
	            		</font>
	            	</td>
                </tr>
                <tr> 
                    <td rowspan="5" class=title>����</td>
                    <td class=title>�Ǻ�����</td>
                  	<td>
                  		&nbsp;
                  		<select name="ins_per" id="ins_per_1" onchange="javascript:set_disable_value();">
                      		<option value="1" <%if (e_bean.getIns_per().equals("1")) {%>selected<%}%>>�Ƹ���ī(��������)</option>
                      		<%-- <option value="2" <%if (e_bean.getIns_per().equals("2")) {%>selected<%}%> disabled>��(���������)</option> --%>
                    	</select>
                    </td>
                    <td class='esti_target3'>
                    	&nbsp;
                    	<select name="ins_per" id="ins_per_2">
                          	<option value="1" <%if (e_bean2.getIns_per().equals("1") || e_bean2.getIns_per().equals("")) {%>selected<%}%>>�Ƹ���ī(��������)</option>
                          	<%-- <option value="2" <%if (e_bean2.getIns_per().equals("2")) {%>selected<%}%> disabled>��(���������)</option> --%>
                      	</select>
                    </td>
                    <td class='esti_target3'>
                    	&nbsp;
                    	<select name="ins_per" id="ins_per_3">
                        	<option value="1" <%if (e_bean.getIns_per().equals("1") || e_bean.getIns_per().equals("")) {%>selected<%}%>>�Ƹ���ī(��������)</option>
                          	<%-- <option value="2" <%if (e_bean.getIns_per().equals("2")) {%>selected<%}%> disabled>��(���������)</option> --%>
                      	</select>
                    </td>
                    <td class='esti_target3'>
                    	&nbsp;
                    	<select name="ins_per" id="ins_per_4">
                          	<option value="1" <%if (e_bean.getIns_per().equals("1") || e_bean.getIns_per().equals("")) {%>selected<%}%>>�Ƹ���ī(��������)</option>
                          	<%-- <option value="2" <%if (e_bean.getIns_per().equals("2")) {%>selected<%}%> disabled>��(���������)</option> --%>
                      	</select>
                    </td>
                </tr>
                <tr>
                  	<td class=title>�빰/�ڼ�</td>
                  	<td>
                  		&nbsp;
                  		<select name="ins_dj" id="ins_dj_1" onchange="javascript:set_disable_value();">
                      		<%-- <option value="1" <%if (e_bean.getIns_dj().equals("1")) {%>selected<%}%>>5õ����/5õ����</option> --%>
                      		<option value="2" <%if (e_bean.getIns_dj().equals("2")) {%>selected<%}%>>1���/1���</option>
                      		<option value="4" <%if (e_bean.getIns_dj().equals("4")) {%>selected<%}%>>2���/1���</option>
                      		<option value="8" <%if (e_bean.getIns_dj().equals("8")) {%>selected<%}%>>3���/1���</option>
                      		<option value="3" <%if (e_bean.getIns_dj().equals("3")) {%>selected<%}%>>5���/1���</option>
                    	</select>
                    </td>
                  	<td class='esti_target2'>
                  		&nbsp;
                  		<select name="ins_dj" id="ins_dj_2">
	                        <%-- <option value="1" <%if (e_bean.getIns_dj().equals("1")) {%>selected<%}%>>5õ����/5õ����</option> --%>
	                        <option value="2" <%if (e_bean2.getIns_dj().equals("2") || e_bean2.getIns_dj().equals("")) {%>selected<%}%>>1���/1���</option>
	                        <option value="4" <%if (e_bean2.getIns_dj().equals("4")) {%>selected<%}%>>2���/1���</option>
	                        <option value="8" <%if (e_bean2.getIns_dj().equals("8")) {%>selected<%}%>>3���/1���</option>
	                        <option value="3" <%if (e_bean2.getIns_dj().equals("3")) {%>selected<%}%>>5���/1���</option>
                    	</select>
                    </td>
                  	<td class='esti_target esti_target2'>
                  		&nbsp;
                  		<select name="ins_dj" id="ins_dj_3">
	                        <%-- <option value="1" <%if (e_bean.getIns_dj().equals("1")) {%>selected<%}%>>5õ����/5õ����</option> --%>
	                        <option value="2" <%if (e_bean.getIns_dj().equals("2") || e_bean.getIns_dj().equals("")) {%>selected<%}%>>1���/1���</option>
	                        <option value="4" <%if (e_bean.getIns_dj().equals("4")) {%>selected<%}%>>2���/1���</option>
	                        <option value="8" <%if (e_bean.getIns_dj().equals("8")) {%>selected<%}%>>3���/1���</option>
	                        <option value="3" <%if (e_bean.getIns_dj().equals("3")) {%>selected<%}%>>5���/1���</option>
                    	</select>
                    </td>
                  	<td class='esti_target esti_target2'>
                  		&nbsp;
                  		<select name="ins_dj" id="ins_dj_4">
	                        <%-- <option value="1" <%if (e_bean.getIns_dj().equals("1")) {%>selected<%}%>>5õ����/5õ����</option> --%>
	                        <option value="2" <%if (e_bean.getIns_dj().equals("2") || e_bean.getIns_dj().equals("")) {%>selected<%}%>>1���/1���</option>
	                        <option value="4" <%if (e_bean.getIns_dj().equals("4")) {%>selected<%}%>>2���/1���</option>
	                        <option value="8" <%if (e_bean.getIns_dj().equals("8")) {%>selected<%}%>>3���/1���</option>
	                        <option value="3" <%if (e_bean.getIns_dj().equals("3")) {%>selected<%}%>>5���/1���</option>
	                    </select>
					</td>
                </tr>
                <tr>
                  	<td class=title>�����ڿ���</td>
                    <td>
                    	&nbsp;
                    	<select name="ins_age" id="ins_age_1" onchange="javascript:set_disable_value();">
		                  	<option value="1" <%if (e_bean.getIns_age().equals("1")) {%>selected<%}%>>��26���̻�</option>
		                  	<option value="3" <%if (e_bean.getIns_age().equals("3")) {%>selected<%}%>>��24���̻�</option>
		                  	<option value="2" <%if (e_bean.getIns_age().equals("2")) {%>selected<%}%>>��21���̻�</option>
                  		</select>
					</td>
                    <td class='esti_target2'>
                    	&nbsp;
                   		<select name="ins_age" id="ins_age_2">
                          	<option value="1" <%if (e_bean2.getIns_age().equals("1") || e_bean2.getIns_age().equals("")) {%>selected<%}%>>��26���̻�</option>
                          	<option value="3" <%if (e_bean2.getIns_age().equals("3")) {%>selected<%}%>>��24���̻�</option>
                          	<option value="2" <%if (e_bean2.getIns_age().equals("2")) {%>selected<%}%>>��21���̻�</option>
                        </select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                   		<select name="ins_age" id="ins_age_3">
                          	<option value="1" <%if (e_bean.getIns_age().equals("1") || e_bean.getIns_age().equals("")) {%>selected<%}%>>��26���̻�</option>
                          	<option value="3" <%if (e_bean.getIns_age().equals("3")) {%>selected<%}%>>��24���̻�</option>
                          	<option value="2" <%if (e_bean.getIns_age().equals("2")) {%>selected<%}%>>��21���̻�</option>
                        </select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ins_age" id="ins_age_4">
                          	<option value="1" <%if (e_bean.getIns_age().equals("1") || e_bean.getIns_age().equals("")) {%>selected<%}%>>��26���̻�</option>
                          	<option value="3" <%if (e_bean.getIns_age().equals("3")) {%>selected<%}%>>��24���̻�</option>
                          	<option value="2" <%if (e_bean.getIns_age().equals("2")) {%>selected<%}%>>��21���̻�</option>
                        </select>
                    </td>
                </tr>
     
                <tr> 
                    <td class=title>������å��</td>
                    <td>
                    	&nbsp;
                    	<input type="text" id="car_ja0"  name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);set_disable_value();'>
          				��
          			</td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<input type="text" id="car_ja1" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean2.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
            			��
            		</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<input type="text" id="car_ja2" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
            			��
            		</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<input type="text" id="car_ja3" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
            			��
            		</td>
                </tr>
            
                <tr> 
                    <td class=title>��������</td>
                    <td>
                    	&nbsp;
                      	<input type="text" name="gi_per" id="gi_per_1" class="num gi_per" size="4" disabled value='<%=e_bean.getGi_per()%>' onBlur="javascript:compare(0, this);set_return2_change();" <%if (est_table.equals("esti_spe") && (a_a[0].equals("12") || a_a[0].equals("11"))) {%>readonly<%} else {%><%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>readonly<%}%><%}%>>
                      	%
                      	<br>
                      	&nbsp;
                      	<input type="text" name="gi_amt" id="gi_amt_1" class="num gi_amt" size="10" disabled value='<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change();' <%if (est_table.equals("esti_spe") && (a_a[0].equals("12") || a_a[0].equals("11"))) {%>readonly<%} else {%><%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>readonly<%}%><%}%>>
                      	��
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                        <input type="text" name="gi_per" id="gi_per_2" class="num gi_per" size="4" disabled value='<%=e_bean2.getGi_per()%>' onBlur="javascript:compare(1, this)" <%if (est_table.equals("esti_spe") && (a_a[1].equals("12") || a_a[1].equals("11"))) {%> readonly <%} else {%><%if (e_bean2.getPrint_type().equals("6")) {%><%if (e_bean2.getA_a().equals("12") || e_bean2.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
      					%<br>
				      	&nbsp;
				      	<input type="text" name="gi_amt" id="gi_amt_2" class="num gi_amt" size="10" disabled value='<%=AddUtil.parseDecimal(e_bean2.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);' <%if (est_table.equals("esti_spe") && (a_a[1].equals("12") || a_a[1].equals("11"))) {%> readonly <%} else {%><%if (e_bean2.getPrint_type().equals("6")) {%><%if (e_bean2.getA_a().equals("12") || e_bean2.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
				      	��
				    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                        <input type="text" name="gi_per" id="gi_per_3" class="num gi_per" size="4" disabled value='<%=e_bean3.getGi_per()%>' onBlur="javascript:compare(2, this)" <%if (est_table.equals("esti_spe") && (a_a[2].equals("12") || a_a[2].equals("11"))) {%> readonly <%} else {%><%if (e_bean3.getPrint_type().equals("6")) {%><%if (e_bean3.getA_a().equals("12") || e_bean3.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
				      	%<br>
				      	&nbsp;
				      	<input type="text" name="gi_amt" id="gi_amt_3" class="num gi_amt" size="10" disabled value='<%=AddUtil.parseDecimal(e_bean3.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);' <%if (est_table.equals("esti_spe") && (a_a[2].equals("12") || a_a[2].equals("11"))) {%> readonly <%} else {%><%if (e_bean3.getPrint_type().equals("6")) {%><%if (e_bean3.getA_a().equals("12") || e_bean3.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
				      	��
				    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                        <input type="text" name="gi_per" id="gi_per_4" class="num gi_per" size="4" disabled value='<%=e_bean4.getGi_per()%>' onBlur="javascript:compare(3, this)" <%if (est_table.equals("esti_spe") && (a_a[3].equals("12") || a_a[3].equals("11"))) {%> readonly <%} else {%><%if (e_bean4.getPrint_type().equals("6")) {%><%if (e_bean4.getA_a().equals("12") || e_bean4.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
						%<br>
				      	&nbsp;
				      	<input type="text" name="gi_amt" id="gi_amt_4" class="num gi_amt" size="10" disabled value='<%=AddUtil.parseDecimal(e_bean4.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);' <%if (est_table.equals("esti_spe") && (a_a[3].equals("12") || a_a[3].equals("11"))) {%> readonly <%} else {%><%if (e_bean4.getPrint_type().equals("6")) {%><%if (e_bean4.getA_a().equals("12") || e_bean4.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
				      	��
				    </td>
                </tr>
                
                <%
                	// ����, ����/ȭ������ ��������������Ư�� ���� �� ���̵���.
//                 	int sh_code_num = 0;
//             		if(!ej_bean.getSh_code().equals("")) sh_code_num = Integer.parseInt(ej_bean.getSh_code());
            		
            		boolean flag1 = false;
//             		if(sh_code_num == 0 || (sh_code_num>1999 && sh_code_num<7000) || (sh_code_num>1999999 && sh_code_num<7000000)) flag1 = true;
            	
					// ������ ��������Ư�� ���� ���� ���� �����ڵ忡�� �����Һз��ڵ� �������� ����. 2021.12.20.
            		int s_st_num = 0;
            		if(!cm_bean.getS_st().equals("")) {
            			s_st_num = Integer.parseInt(cm_bean.getS_st());
            		} else if(!s_st.equals("")){
            			s_st_num = Integer.parseInt(s_st);
            		}
            		
            		if((s_st_num > 101 && s_st_num < 600 && s_st_num != 409)) flag1 = true;
                %>
                <tr id=tr_com_emp_yn style="display:<%if (e_bean.getCom_emp_yn().equals("N") || !flag1 ) {%>none<%} else {%>''<%}%>">
                  	<td colspan='2' class=title><!-- ���� -->������ ��������Ư��</td>
                    <td>
                    	&nbsp;
                    	<select name="com_emp_yn" id="com_emp_yn_1" onchange="javascript:set_disable_value();">
                    		<%-- <%if (e_bean.getDoc_type().equals("2")) {%> --%>
                    		<%if (e_bean.getDoc_type().equals("2") && flag1 ) {%>
		                  	<option value="" <%if (e_bean.getCom_emp_yn().equals("")) {%>selected<%}%>>����</option>
                    		<%}%>
		                  	<option value="N" <%if (e_bean.getCom_emp_yn().equals("N")) {%>selected<%}%>>�̰���</option>
                    		<%if( flag1 ){ %>
		                  	<option value="Y" <%if (e_bean.getCom_emp_yn().equals("Y")) {%>selected<%}%>>����</option>
                    		<%}%>
	                  	</select>                    
	                </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="com_emp_yn" id="com_emp_yn_2">
                    		<%-- <%if (e_bean.getDoc_type().equals("2")) {%> --%>
                    		<%if (e_bean.getDoc_type().equals("2") && flag1 ) {%>
		                  	<option value="" <%if (e_bean2.getCom_emp_yn().equals("")) {%>selected<%}%>>����</option>
                    		<%}%>
                  			<option value="N" <%if (e_bean2.getCom_emp_yn().equals("N")) {%>selected<%}%>>�̰���</option>
                  			<%if( flag1 ){ %>
                  			<option value="Y" <%if (e_bean2.getCom_emp_yn().equals("Y")) {%>selected<%}%>>����</option>
                    		<%}%>
                        </select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="com_emp_yn" id="com_emp_yn_3">
                    		<%-- <%if (e_bean.getDoc_type().equals("2")) {%> --%>
                    		<%if (e_bean.getDoc_type().equals("2") && flag1 ) {%>
		                  	<option value="" <%if (e_bean.getCom_emp_yn().equals("")) {%>selected<%}%>>����</option>
                    		<%}%>
                  			<option value="N" <%if (e_bean.getCom_emp_yn().equals("N")) {%>selected<%}%>>�̰���</option>
                  			<%if( flag1 ){ %>
                  			<option value="Y" <%if (e_bean.getCom_emp_yn().equals("Y")) {%>selected<%}%>>����</option>
                    		<%}%>
                        </select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="com_emp_yn" id="com_emp_yn_4">
                    		<%-- <%if (e_bean.getDoc_type().equals("2")) {%> --%>
                    		<%if (e_bean.getDoc_type().equals("2") && flag1 ) {%>
		                  	<option value="" <%if (e_bean.getCom_emp_yn().equals("")) {%>selected<%}%>>����</option>
                    		<%}%>
                  			<option value="N" <%if (e_bean.getCom_emp_yn().equals("N")) {%>selected<%}%>>�̰���</option>
                  			<%if( flag1 ){ %>
                  			<option value="Y" <%if (e_bean.getCom_emp_yn().equals("Y")) {%>selected<%}%>>����</option>
                    		<%}%>
                        </select>
                    </td>
                </tr>
                
                <% 
                	String jg_code = ej_bean.getSh_code(); // �����ڵ�
                	int jg_code_num = 0;
                	if(!jg_code.equals("")) jg_code_num = Integer.parseInt(jg_code);
                	String car_comp_id = e_bean.getCar_comp_id(); // ������
                	int car_comp_id_num = 0;
                	if(!car_comp_id.equals("")) car_comp_id_num = Integer.parseInt(car_comp_id);
                %>
                <tr id="tr_tint_s_yn" <%if (e_bean.getCar_comp_id().equals("0056") || e_bean.getCar_comp_id().equals("0057") || (jg_code_num > 9017300 && jg_code_num < 9018200 ) ) {%>style="display:none;"<%}%>>
                    <td colspan='2' class=title>��ǰ</td>
                    <td>
                    	<%-- &nbsp;
                      	<label><input type="checkbox" name="tint_s_yn" id="tint_s_yn_1" value="Y" <%if (e_bean.getTint_s_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> �������(�⺻��)</label>
                      	<br> --%>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_ps_yn" id="tint_ps_yn_1" value="Y" <%if (e_bean.getTint_ps_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ��޽���(��������)</label>
                      	<select name="setTint_ps_sel" id="setTint_ps_sel_1" onchange="javascript:set_disable_value();">
                      		<option value="Y">������ǥ��</option>
                      		<option value="N">��������ǥ��</option>
                      		<option value="I">���������Է�</option>
                      	</select>
                      	<br>
                      	<span style="margin-left:0.9cm;" id="tint_ps_span0"><%if (e_bean.getTint_ps_st().equals("I")) {%> ������ ǥ�⳻�� &nbsp;<%} else {%> FMSǥ��(�����)<%}%></span>
                      	<input type="text" id="tint_ps_nm_1" name="tint_ps_nm" value='<%=e_bean.getTint_ps_nm()%>' size="12" class="num" onBlur='javascript:set_disable_value();'><br>
                      	<span style="margin-left:0.9cm;"> ��ǰ�� ���ޱݾ�(���ް�)</span><input type="text" name="tint_ps_amt" id="tint_ps_amt_1" size="6" class="num"
                      	onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_disable_value();' value='<%=AddUtil.parseDecimal(e_bean.getTint_ps_amt())%>'> ��
                      	
                      	<span id="tint_sn_yn_div_1" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
	                      	<br>
	                      	&nbsp;
	                      	<label><input type="checkbox" name="tint_sn_yn" id="tint_sn_yn_1" value="Y" <%if (e_bean.getTint_sn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ������� �̽ð� ����</label>
                      	</span>
                      	<span id="tint_bn_yn_div_1" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
	                      	<br>
	                      	&nbsp;
	                      	<label><input type="checkbox" name="tint_bn_yn" id="tint_bn_yn_1" value="Y" <%if (e_bean.getTint_bn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ���ڽ� ����������(��Ʈ��ķ,������)</label>
                      	</span>
                      	<br>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_cons_yn" id="tint_cons_yn_1" value="Y" <%if (e_bean.getTint_cons_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> �߰�Ź�۷��</label>
                      	<input type="text" name="tint_cons_amt" id="tint_cons_amt_1" size="6" class="num" onBlur='javascript:this.value=parseDecimal(this.value); compare(0, this); set_disable_value();' value='<%=AddUtil.parseDecimal(e_bean.getTint_cons_amt())%>'> ��
                      	<br>
                      	&nbsp;
                      	<label 
                      	<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>
                      	> ��ȣ�Ǳ���</label>
                      	<select name="new_license_plate" id="new_license_plate_1" onchange="javascript:set_disable_value();" 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>
                      	>
                      		<option value="1" <%if (e_bean.getNew_license_plate().equals("") || e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) {%>selected<%}%>>����</option>
                      		<option value="0" <%if (e_bean.getNew_license_plate().equals("0")) {%>selected<%}%>>����(�������)</option>
                      		<%-- <option value="" <%if (e_bean.getNew_license_plate().equals("")) {%>selected<%}%>>��û����</option>
                      		<option value="1" <%if (e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) {%>selected<%}%>>��û</option> --%>
<%--                       		<option value="1" <%if (e_bean.getNew_license_plate().equals("1")) {%>selected<%}%>>������</option> --%>
<%--                       		<option value="2" <%if (e_bean.getNew_license_plate().equals("2")) {%>selected<%}%>>����/�뱸/����/�λ�</option> --%>
                      	</select>
                      	
                      	<label style="display: none;"><input type="checkbox" name="tint_n_yn" id="tint_n_yn_1" value="Y" <%if (e_bean.getTint_n_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ��ġ�� ������̼�</label>
                      	<!-- <br>&nbsp; -->
                      	<label style="display: none;"><input type="checkbox" name="tint_eb_yn" id="tint_eb_yn_1" value="Y" <%if (e_bean.getTint_eb_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> �̵��� ������(������)</label>
                    </td>
                    
                    <td class='esti_target2'>
                    	<%-- &nbsp;
                      	<label><input type="checkbox" name="tint_s_yn" id="tint_s_yn_2" value="Y" <%if (e_bean2.getTint_s_yn().equals("Y")) {%>checked<%}%>> �������(�⺻��)</label>
                      	<br> --%>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_ps_yn" id="tint_ps_yn_2" value="Y" <%if (e_bean2.getTint_ps_yn().equals("Y")) {%>checked<%}%>> ��޽���(��������)</label>
                      	<select name="setTint_ps_sel" id="setTint_ps_sel_2" onchange="javascript:setTint_ps('1', this.value);">
	                      	<option value="Y">������ǥ��</option>
	                      	<option value="N">��������ǥ��</option>
	                      	<option value="I">���������Է�</option>
                      	</select>
                      	<br>
                      	<span style="margin-left:0.9cm;" id="tint_ps_span1"><%if (e_bean2.getTint_ps_st().equals("I")) {%> ������ ǥ�⳻�� &nbsp;<%} else {%> FMSǥ��(�����)<%}%></span>
                      	<input type="text" id="tint_ps_nm_2" name="tint_ps_nm" value='<%=e_bean2.getTint_ps_nm()%>' size="12" class="num"><br>
                      	<span style="margin-left:0.9cm;">��ǰ�� ���ޱݾ�(���ް�)</span><input type="text" name="tint_ps_amt" id="tint_ps_amt_2" size="6" class="num"
                      	onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean2.getTint_ps_amt())%>'> ��
                      	<br>
                      	<span id="tint_sn_yn_div_2" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_sn_yn" id="tint_sn_yn_2" value="Y" <%if (e_bean2.getTint_sn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ������� �̽ð� ����</label>
                      	<br>
                      	</span>
                      	<span id="tint_bn_yn_div_2" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_bn_yn" id="tint_bn_yn_2" value="Y" <%if (e_bean2.getTint_bn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ���ڽ� ����������(��Ʈ��ķ,������)</label>
                      	<br>
                      	</span>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_cons_yn" id="tint_cons_yn_2" value="Y" <%if (e_bean2 .getTint_cons_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> �߰�Ź�۷��</label>
                      	<input type="text" name="tint_cons_amt" id="tint_cons_amt_2" size="6" class="num" onBlur='javascript:this.value=parseDecimal(this.value); compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean2.getTint_cons_amt())%>'> ��
                      	<br>
                      	&nbsp;
                      	<label <%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>
                      	> ��ȣ�Ǳ���</label>
                      	<select name="new_license_plate" id="new_license_plate_2" onchange="javascript:set_disable_value();" 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>
                      		>
                      		<option value="1">����</option>
                      		<option value="0">����(�������)</option>
                      		<!-- <option value="">��û����</option>
                      		<option value="1">��û</option> -->
<!--                       		<option value="1">������</option> -->
<!--                       		<option value="2">����/�뱸/����/�λ�</option> -->
                      	</select>
                      	
                      	<label style="display: none;"><input type="checkbox" name="tint_n_yn" id="tint_n_yn_2" value="Y" <%if (e_bean2.getTint_n_yn().equals("Y")) {%>checked<%}%>> ��ġ�� ������̼�</label>
                      	<!-- <br>&nbsp; -->
                      	<label style="display: none;"><input type="checkbox" name="tint_eb_yn" id="tint_eb_yn_2" value="Y" <%if (e_bean2.getTint_eb_yn().equals("Y")) {%>checked<%}%>> �̵��� ������(������)</label>
        			</td>
        			
                    <td class='esti_target esti_target2'>
                    	<%-- &nbsp;
                      	<label><input type="checkbox" name="tint_s_yn" id="tint_s_yn_3" value="Y" <%if (e_bean.getTint_s_yn().equals("Y")) {%>checked<%}%>> �������(�⺻��)</label>
                      	<br> --%>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_ps_yn" id="tint_ps_yn_3" value="Y" <%if (e_bean.getTint_ps_yn().equals("Y")) {%>checked<%}%>> ��޽���(��������)</label>
                      	<select name="setTint_ps_sel" id="setTint_ps_sel_3" onchange="javascript:setTint_ps('2', this.value);">
	                      	<option value="Y">������ǥ��</option>
	                      	<option value="N">��������ǥ��</option>
	                      	<option value="I">���������Է�</option>
                      	</select>
                      	<br>
                      	<span style="margin-left:0.9cm;" id="tint_ps_span2"><%if (e_bean.getTint_ps_st().equals("I")) {%> ������ ǥ�⳻�� &nbsp;<%} else {%> FMSǥ��(�����)<%}%></span>
                      	<input type="text" id="tint_ps_nm_3" name="tint_ps_nm" value='<%=e_bean.getTint_ps_nm()%>' size="12" class="num"><br>
                      	<span style="margin-left:0.9cm;">��ǰ�� ���ޱݾ�(���ް�)</span><input type="text" name="tint_ps_amt" id="tint_ps_amt_3" size="6" class="num"
                      	onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean.getTint_ps_amt())%>'> ��
                      	<br>
                      	<span id="tint_sn_yn_div_3" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_sn_yn" id="tint_sn_yn_3" value="Y" <%if (e_bean.getTint_sn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ������� �̽ð� ����</label>
                      	<br>
                      	</span>
                      	<span id="tint_bn_yn_div_3" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_bn_yn" id="tint_bn_yn_3" value="Y" <%if (e_bean.getTint_bn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ���ڽ� ����������(��Ʈ��ķ,������)</label>
                      	<br>
                      	</span>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_cons_yn" id="tint_cons_yn_3" value="Y" <%if (e_bean.getTint_cons_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> �߰�Ź�۷��</label>
                      	<input type="text" name="tint_cons_amt" id="tint_cons_amt_3" size="6" class="num" onBlur='javascript:this.value=parseDecimal(this.value); compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean.getTint_cons_amt())%>'> ��
                      	<br>
                      	&nbsp;
                      	<label 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>> ��ȣ�Ǳ���</label>
                      	<select name="new_license_plate" id="new_license_plate_3" onchange="javascript:set_disable_value();" 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>>
                      		<option value="1">����</option>
                      		<option value="0">����(�������)</option>
                      		<!-- <option value="">��û����</option>
                      		<option value="1">��û</option> -->
<!--                       		<option value="1">������</option> -->
<!--                       		<option value="2">����/�뱸/����/�λ�</option> -->
                      	</select>
                      	
                      	<label style="display: none;"><input type="checkbox" name="tint_n_yn" id="tint_n_yn_3" value="Y" <%if (e_bean.getTint_n_yn().equals("Y")) {%>checked<%}%>> ��ġ�� ������̼�</label>
                      	<!-- <br>&nbsp; -->
                      	<label style="display: none;"><input type="checkbox" name="tint_eb_yn" id="tint_eb_yn_3" value="Y" <%if (e_bean.getTint_eb_yn().equals("Y")) {%>checked<%}%>> �̵��� ������(������)</label>
        			</td>
        			
                    <td class='esti_target esti_target2'>
                    	<%-- &nbsp;
                      	<label><input type="checkbox" name="tint_s_yn" id="tint_s_yn_4" value="Y" <%if (e_bean.getTint_s_yn().equals("Y")) {%>checked<%}%>> �������(�⺻��)</label>
                      	<br> --%>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_ps_yn" id="tint_ps_yn_4" value="Y" <%if (e_bean.getTint_ps_yn().equals("Y")) {%>checked<%}%>> ��޽���(��������)</label>
                      	<select name="setTint_ps_sel" id="setTint_ps_sel_4" onchange="javascript:setTint_ps('3', this.value);">
	                      	<option value="Y">������ǥ��</option>
	                      	<option value="N">��������ǥ��</option>
	                      	<option value="I">���������Է�</option>
                      	</select>
                      	<br>
                      	<span style="margin-left:0.9cm;" id="tint_ps_span3"><%if (e_bean.getTint_ps_st().equals("I")) {%> ������ ǥ�⳻�� &nbsp;<%} else {%> FMSǥ��(�����)<%}%></span>
                      	<input type="text" id="tint_ps_nm_4" name="tint_ps_nm" value='<%=e_bean.getTint_ps_nm()%>' size="12" class="num"><br>
                      	<span style="margin-left:0.9cm;">��ǰ�� ���ޱݾ�(���ް�)</span><input type="text" name="tint_ps_amt" id="tint_ps_amt_4" size="6" class="num"
                      	onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean.getTint_ps_amt())%>'> ��
                      	<br>
                      	<span id="tint_sn_yn_div_4" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_sn_yn" id="tint_sn_yn_4" value="Y" <%if (e_bean.getTint_sn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ������� �̽ð� ����</label>
                      	<br>
                      	</span>
                      	<span id="tint_bn_yn_div_4" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_bn_yn" id="tint_bn_yn_4" value="Y" <%if (e_bean.getTint_bn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> ���ڽ� ����������(��Ʈ��ķ,������)</label>
                      	<br>
                      	</span>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_cons_yn" id="tint_cons_yn_4" value="Y" <%if (e_bean.getTint_cons_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> �߰�Ź�۷��</label>
                      	<input type="text" name="tint_cons_amt" id="tint_cons_amt_4" size="6" class="num" onBlur='javascript:this.value=parseDecimal(this.value); compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean.getTint_cons_amt())%>'> ��
                      	<br>
                      	&nbsp;
                      	<label 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>> ��ȣ�Ǳ���</label>
                      	<select name="new_license_plate" id="new_license_plate_4" onchange="javascript:set_disable_value();" 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>>
                      		<option value="1">����</option>
                      		<option value="0">����(�������)</option>
                      		<!-- <option value="">��û����</option>
                      		<option value="1">��û</option> -->
<!--                       		<option value="1">������</option> -->
<!--                       		<option value="2">����/�뱸/����/�λ�</option> -->
                      	</select>
                      	
                      	<label style="display: none;"><input type="checkbox" name="tint_n_yn" id="tint_n_yn_4" value="Y" <%if (e_bean.getTint_n_yn().equals("Y")) {%>checked<%}%>> ��ġ�� ������̼�</label>
                      	<!-- <br>&nbsp; -->
                      	<label style="display: none;"><input type="checkbox" name="tint_eb_yn" id="tint_eb_yn_4" value="Y" <%if (e_bean.getTint_eb_yn().equals("Y")) {%>checked<%}%>> �̵��� ������(������)</label>
        			</td>
                </tr>
                
                <%-- <tr id=tr_ecar_loc style="display:<%if (ej_bean.getJg_g_7().equals("3")) {%>''<%} else {%>none<%}%>"> --%> 
                <tr id="tr_ecar_loc" style="display:<%if (ej_bean.getSh_code().equals("5866") || ej_bean.getSh_code().equals("6316111")) {%>none<%} else {%><%if (ej_bean.getJg_g_7().equals("3")) {%><%} else {%>none<%}%><%if ( ej_bean.getJg_g_15() > 0 ) {%><%} else {%>none<%}%><%}%>"> 
                    <td colspan='2' class=title>������ ���ּ���</td>
                    
				<!-- 20200914 �����Ϸ�Ʈ��, ����EV, ��3 �񱳰��� �������� �ӽ÷� ����(���� �ڵ�� else) 
				   9133	9015435	���� �Ϸ�Ʈ��
                   9237	9025435	���� EV
                   3871	3313111	��3
				-->
<%-- 				<%if (!(ej_bean.getSh_code().equals("9133") || ej_bean.getSh_code().equals("9237") || ej_bean.getSh_code().equals("3871") || ej_bean.getSh_code().equals("9015435") || ej_bean.getSh_code().equals("9025435") || ej_bean.getSh_code().equals("3313111") || ej_bean.getSh_code().equals("3313112") || ej_bean.getSh_code().equals("3313113") || ej_bean.getSh_code().equals("3313114") || ej_bean.getSh_code().equals("9015436") || ej_bean.getSh_code().equals("9015437") || ej_bean.getSh_code().equals("9025439") || ej_bean.getSh_code().equals("9025440") )) {%> --%>
				<!-- 20210302 ����ȭ����, ����ȭ���� �� ������ �񱳰��� �������� �ӽ� ����. -->
				<%if ( AddUtil.parseInt(ej_bean.getSh_code()) < 8000000 ){ // ����ȭ���� �� ������%>
                    <td>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_1" onChange="javascript:setLoc_st('0', this.value); set_disable_value(); set_other_esti_value(this);">
							<option value="" <%if (!(e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5"))) {%>selected<%}%>>����</option>
						<%for (int i = 0; i < code34_size; i++) {
                            CodeBean code = code34[i];%>
	                       	<option value='<%= code.getNm_cd()%>' 
	                       		<%if ( code.getNm_cd().equals(e_bean.getEcar_loc_st()) ) {%>selected<%}%>
	                       		<%if(code.getNm_cd().equals("12")){ %>style="display: none;"<%} %>
<%-- 	                       		<%if ((e_bean.getEcar_loc_st().equals("0") && code.getNm_cd().equals("0")) || (e_bean.getEcar_loc_st().equals("12") && code.getNm_cd().equals("12")) || (e_bean.getEcar_loc_st().equals("13") && code.getNm_cd().equals("13"))) {%>selected<%}%>  --%>
<%-- 	                       		<%if ( !( code.getNm_cd().equals("0") || code.getNm_cd().equals("12") || code.getNm_cd().equals("13")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
	                       		>
	                       		<%= code.getNm()%>
	                       	</option>
                        <%}%>
                      	</select>
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_2" onChange="javascript:setLoc_st('1', this.value);">
							<option value="" <%if (!(e_bean2.getEcar_loc_st().equals("4") || e_bean2.getEcar_loc_st().equals("5"))) {%>selected<%}%>>����</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
                        	<option value='<%= code.getNm_cd()%>'
                        		<%if ( code.getNm_cd().equals(e_bean.getEcar_loc_st()) ) {%>selected<%}%> 
                        		<%if(code.getNm_cd().equals("12")){ %>style="display: none;"<%} %>
<%--                         		<%if ((e_bean2.getEcar_loc_st().equals("0") && code.getNm_cd().equals("0")) || (e_bean2.getEcar_loc_st().equals("12") && code.getNm_cd().equals("12")) || (e_bean2.getEcar_loc_st().equals("13") && code.getNm_cd().equals("13"))) {%>selected<%}%>  --%>
<%--                         		<%if ( !( code.getNm_cd().equals("0") || code.getNm_cd().equals("12") || code.getNm_cd().equals("13")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
                        		>
                        		<%= code.getNm()%>
                        	</option>
                       	<%}%>
                      	</select>
					</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_3" onChange="javascript:setLoc_st('2', this.value);">
							<option value="" <%if (!(e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5"))) {%>selected<%}%>>����</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
							<option value='<%= code.getNm_cd()%>'
								<%if ( code.getNm_cd().equals(e_bean.getEcar_loc_st()) ) {%>selected<%}%> 
								<%if(code.getNm_cd().equals("12")){ %>style="display: none;"<%} %>
<%-- 							<%if ((e_bean.getEcar_loc_st().equals("0") && code.getNm_cd().equals("0")) || (e_bean.getEcar_loc_st().equals("12") && code.getNm_cd().equals("12")) || (e_bean.getEcar_loc_st().equals("13") && code.getNm_cd().equals("13"))) {%>selected<%}%>  --%>
<%-- 							<%if ( !( code.getNm_cd().equals("0") || code.getNm_cd().equals("12") || code.getNm_cd().equals("13")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
							>
							<%= code.getNm()%>
							</option>
                       	<%}%>
                      	</select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_4" onChange="javascript:setLoc_st('3', this.value);">
							<option value="" <%if (!(e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5"))) {%>selected<%}%>>����</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
                        	<option value='<%= code.getNm_cd()%>'
                        		<%if ( code.getNm_cd().equals(e_bean.getEcar_loc_st()) ) {%>selected<%}%> 
                        		<%if(code.getNm_cd().equals("12")){ %>style="display: none;"<%} %>
<%--                         		<%if ((e_bean.getEcar_loc_st().equals("0") && code.getNm_cd().equals("0")) || (e_bean.getEcar_loc_st().equals("12") && code.getNm_cd().equals("12")) || (e_bean.getEcar_loc_st().equals("13") && code.getNm_cd().equals("13"))) {%>selected<%}%>  --%>
<%--                         		<%if ( !( code.getNm_cd().equals("0") || code.getNm_cd().equals("12") || code.getNm_cd().equals("13")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
                        	>
                        	<%= code.getNm()%>
                        	</option>
                       	<%}%>
                      </select>
					</td>
					
				<%} else { // ����ȭ����%>
				
					<td>
						&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_1" onChange="javascript:setLoc_st('0', this.value); set_disable_value(); set_other_esti_value(this);">
							<option value="" <%if (!e_bean.getEcar_loc_st().equals("5")) {%>selected<%}%>>����</option>
						<%for (int i = 0; i < code34_size; i++) {
                            CodeBean code = code34[i];%>
	                       	<option value='<%= code.getNm_cd()%>' 
	                       		<%if (e_bean.getEcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%> 
<%-- 	                       		<%if ( !( code.getNm_cd().equals("1") || code.getNm_cd().equals("4") || code.getNm_cd().equals("5")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
	                       		<%if(code.getNm_cd().equals("12") || code.getNm_cd().equals("13")){ %>style="display: none;"<%} %>
	                       	>
	                       		<%= code.getNm()%>
	                       	</option>
                        <%}%>
                      	</select>
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_2" onChange="javascript:setLoc_st('1', this.value);">
							<option value="" <%if (e_bean2.getEcar_loc_st().equals("")) {%>selected<%}%>>����</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
                        	<option value='<%= code.getNm_cd()%>' 
                        	<%if (e_bean2.getEcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>
<%--                         	<%if ( !( code.getNm_cd().equals("1") || code.getNm_cd().equals("4") || code.getNm_cd().equals("5")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
                        	<%if(code.getNm_cd().equals("12") || code.getNm_cd().equals("13")){ %>style="display: none;"<%} %>
                        	>
                        		<%= code.getNm()%>
                        	</option>
                       	<%}%>
                      	</select>
					</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_3" onChange="javascript:setLoc_st('2', this.value);">
							<option value="" <%if (e_bean.getEcar_loc_st().equals("")) {%>selected<%}%>>����</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
							<option value='<%= code.getNm_cd()%>' 
								<%if (e_bean.getEcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>
<%-- 								<%if ( !( code.getNm_cd().equals("1") || code.getNm_cd().equals("4") || code.getNm_cd().equals("5")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
								<%if(code.getNm_cd().equals("12") || code.getNm_cd().equals("13")){ %>style="display: none;"<%} %>
							>
								<%= code.getNm()%>
							</option>
                       	<%}%>
                      	</select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_4" onChange="javascript:setLoc_st('3', this.value);">
							<option value="" <%if (e_bean.getEcar_loc_st().equals("")) {%>selected<%}%>>����</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
                        	<option value='<%= code.getNm_cd()%>' 
                        		<%if (e_bean.getEcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>
<%--                         		<%if ( !( code.getNm_cd().equals("1") || code.getNm_cd().equals("4") || code.getNm_cd().equals("5")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
                        		<%if(code.getNm_cd().equals("12") || code.getNm_cd().equals("13")){ %>style="display: none;"<%} %>
                        	>
                        		<%= code.getNm()%>
                        	</option>
                       	<%}%>
                      </select>
					</td>
					
				<%}%>
                </tr>
                
                <!-- �ű�_������ -->
                <tr id=tr_hcar_loc style="display:<%if (ej_bean.getJg_g_7().equals("4")) {%>''<%} else {%>none<%}%>"> 
                    <td colspan='2' class=title>������ ���ּ���</td>
                    <td>
                    	&nbsp;
                    	<select name="hcar_loc_st" id="hcar_loc_st_1" onChange="javascript:setLoc_st('0',this.value); set_other_esti_value(this);">
                    	  	<option value="" <%if (e_bean.getHcar_loc_st().equals(""))%>selected<%%>>����</option>
                   	  	<%for (int i = 0 ; i < code37_size ; i++) {
                            CodeBean code = code37[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getHcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                        
						</select> 
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="hcar_loc_st" id="hcar_loc_st_2" onChange="javascript:setLoc_st('1',this.value);">
                    	  	<option value="" <%if (e_bean2.getHcar_loc_st().equals(""))%>selected<%%>>����</option>
                   	  	<%for (int i = 0 ; i < code37_size ; i++) {
                            CodeBean code = code37[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean2.getHcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                        
                      	</select> 
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="hcar_loc_st" id="hcar_loc_st_3" onChange="javascript:setLoc_st('2',this.value);">
                    	  	<option value="" <%if (e_bean.getHcar_loc_st().equals(""))%>selected<%%>>����</option>
                   	  	<%for (int i = 0 ; i < code37_size ; i++) {
                            CodeBean code = code37[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getHcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                        
                   		</select>
                   	</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="hcar_loc_st" id="hcar_loc_st_4" onChange="javascript:setLoc_st('3',this.value);">
                    	  	<option value="" <%if (e_bean.getHcar_loc_st().equals(""))%>selected<%%>>����</option>
                   	  	<%for (int i = 0 ; i < code37_size ; i++) {
                            CodeBean code = code37[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getHcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                        
                      	</select>
					</td>
                </tr>
                
                <!-- �������ｺƼĿ ���ʿ�� �ּ�ó��  2021.02.08. -->
		        <%-- <tr id=tr_eco_etag style="display:<%if (ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||
		        		ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")||ej_bean.getJg_g_7().equals("5")) {%>''<%} else {%>none<%}%>"> --%>
		        <%-- <tr id=tr_eco_etag style="display:<%if (ej_bean.getJg_b().equals("3") || ej_bean.getJg_b().equals("4") || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%>''<%} else {%>none<%}%>"> --%>
<%-- 		        <tr id=tr_eco_etag style="display:<%if (ej_bean.getJg_b().equals("3") || ej_bean.getJg_b().equals("4")) {%>''<%} else {%>none<%}%>"> --%>
<!-- 		        	<td colspan='2' class=title> -->
<!-- 		        		�������ｺƼĿ �߱� -->
<!-- 		        		<br> -->
<!-- 		        		(�����ͳ� �̿� �����±�) -->
<!-- 		        	</td> -->
<!--                     <td> -->
<!--                     	&nbsp; -->
<!--                     	<select name="eco_e_tag" id="eco_e_tag_1" onchange="javascript:set_disable_value();"> -->
<%--                    		<%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%> --%>
<!--         		        	<option value="">����</option> -->
<!--         		        	<option value="0" selected>�̹߱�</option> -->
<!--                         	<option value="1">�߱�</option> -->
<%--                    		<%} else {%> --%>
<%--         		        	<option value="" <%if (e_bean.getEco_e_tag().equals("")) {%>selected<%}%>>����</option> --%>
<%--         		        	<option value="0" <%if (e_bean.getEco_e_tag().equals("0")) {%>selected<%}%>>�̹߱�</option> --%>
<%--                         	<option value="1" <%if (e_bean.getEco_e_tag().equals("1")) {%>selected<%}%>>�߱�</option> --%>
<%--                    		<%}%> --%>
<!--                       	</select> -->
<!--                       	&nbsp; -->
<!--                       	<textarea class="white_sizeFix" cols="26" rows="2">���̺긮������ ��������&#13;&#10;�߱޽� ������/�뿩����</textarea> -->
<!--                     </td> -->
<!--                     <td> -->
<!--                     	&nbsp; -->
<!--                     	<select name="eco_e_tag" id="eco_e_tag_2"> -->
<%--                     	<%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%> --%>
<!--         		        	<option value="">����</option> -->
<!--         		        	<option value="0" selected>�̹߱�</option> -->
<!--                         	<option value="1">�߱�</option> -->
<%--                    		<%} else {%> --%>
<%--         		        	<option value="" <%if (e_bean2.getEco_e_tag().equals("")) {%>selected<%}%>>����</option> --%>
<%--         		        	<option value="0" <%if (e_bean2.getEco_e_tag().equals("0")) {%>selected<%}%>>�̹߱�</option> --%>
<%--                         	<option value="1" <%if (e_bean2.getEco_e_tag().equals("1")) {%>selected<%}%>>�߱�</option> --%>
<%--                    		<%}%>                                              --%>
<!--                       	</select> -->
<!-- 						&nbsp; -->
<!-- 						<textarea class="white_sizeFix" cols="26" rows="2">���̺긮������ ��������&#13;&#10;�߱޽� ������/�뿩����</textarea> -->
<!-- 					</td> -->
<!--                     <td> -->
<!--                     	&nbsp; -->
<!--                     	<select name="eco_e_tag" id="eco_e_tag_3"> -->
<%--                     	<%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%> --%>
<!--         		        	<option value="">����</option> -->
<!--         		        	<option value="0" selected>�̹߱�</option> -->
<!--                         	<option value="1">�߱�</option> -->
<%--                    		<%} else {%> --%>
<%--         		        	<option value="" <%if (e_bean.getEco_e_tag().equals("")) {%>selected<%}%>>����</option> --%>
<%--         		        	<option value="0" <%if (e_bean.getEco_e_tag().equals("0")) {%>selected<%}%>>�̹߱�</option> --%>
<%--                         	<option value="1" <%if (e_bean.getEco_e_tag().equals("1")) {%>selected<%}%>>�߱�</option> --%>
<%--                    		<%}%>                                              --%>
<!--                       	</select> -->
<!--                       	&nbsp; -->
<!--                       	<textarea class="white_sizeFix" cols="26" rows="2">���̺긮������ ��������&#13;&#10;�߱޽� ������/�뿩����</textarea> -->
<!--                     </td> -->
<!--                     <td> -->
<!--                     	&nbsp; -->
<!--                     	<select name="eco_e_tag" id="eco_e_tag_4"> -->
<%--                     	<%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%> --%>
<!--         		        	<option value="">����</option> -->
<!--         		        	<option value="0" selected>�̹߱�</option> -->
<!--                         	<option value="1">�߱�</option> -->
<%--                    		<%} else {%> --%>
<%--         		        	<option value="" <%if (e_bean.getEco_e_tag().equals("")) {%>selected<%}%>>����</option> --%>
<%--         		        	<option value="0" <%if (e_bean.getEco_e_tag().equals("0")) {%>selected<%}%>>�̹߱�</option> --%>
<%--                         	<option value="1" <%if (e_bean.getEco_e_tag().equals("1")) {%>selected<%}%>>�߱�</option> --%>
<%--                    		<%}%>                                               --%>
<!--                       	</select> -->
<!--                       	&nbsp; -->
<!--                       	<textarea class="white_sizeFix" cols="26" rows="2">���̺긮������ ��������&#13;&#10;�߱޽� ������/�뿩����</textarea> -->
<!-- 					</td> -->
<!-- 		        </tr> -->
		        
                <tr> 
                    <td colspan='2' class=title>�����ε�����</td>
                    <td>
                    	&nbsp;
                    	<select name="loc_st" id="loc_st_1" onchange="javascript:set_disable_value();" <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%} else {%><%}%>>
               	  		<%for (int i = 0 ; i < code33_size ; i++) {
							CodeBean code = code33[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getLoc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                    	<%}%>
                      	</select>
                      	<%-- <span id="loc_st_cmt_1" style="display: <%if (e_bean.getCar_comp_id().equals("0056")) {%>''<%} else {%>none<%}%>; font-size: 10px; letter-spacing: 0px;">���ﰭ�����񽺼��Ϳ��� ���� �� �ε�</span> --%>
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="loc_st" id="loc_st_2" <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%} else {%><%}%>>
                   	  	<%for (int i = 0 ; i < code33_size ; i++) {
                            CodeBean code = code33[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean2.getLoc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
                      <%-- <span id="loc_st_cmt_2" style="display: <%if (e_bean.getCar_comp_id().equals("0056")) {%>''<%} else {%>none<%}%>; font-size: 10px; letter-spacing: 0px;">���ﰭ�����񽺼��Ϳ��� ���� �� �ε�</span> --%>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="loc_st" id="loc_st_3" <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%} else {%><%}%>>
                  	  	<%for (int i = 0 ; i < code33_size ; i++) {
                            CodeBean code = code33[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getLoc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      	</select>
                      	<%-- <span id="loc_st_cmt_3" style="display: <%if (e_bean.getCar_comp_id().equals("0056")) {%>''<%} else {%>none<%}%>; font-size: 10px; letter-spacing: 0px;">���ﰭ�����񽺼��Ϳ��� ���� �� �ε�</span> --%>
                    </td>
					<td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="loc_st" id="loc_st_4" <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%} else {%><%}%>>
                   	  	<%for (int i = 0 ; i < code33_size ; i++) {
                            CodeBean code = code33[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getLoc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      	</select>
                      	<%-- <span id="loc_st_cmt_4" style="display: <%if (e_bean.getCar_comp_id().equals("0056")) {%>''<%} else {%>none<%}%>; font-size: 10px; letter-spacing: 0px;">���ﰭ�����񽺼��Ϳ��� ���� �� �ε�</span> --%>
					</td>
                </tr> 
                
			  	<input type="hidden" name="udt_st" value="">
			  	<input type="hidden" name="udt_st" value="">
			  	<input type="hidden" name="udt_st" value="">
			  	<input type="hidden" name="udt_st" value="">
                                  
                <tr> 
                    <td colspan='2' class=title>��������</td>
          			<!-- �޺��ڽ��� ����(2018.03.12) -->
			        <td>
			        	&nbsp;
                    	<select id="sel_o_11_1" onchange="javascript:setO_11('1',this.value);set_return2_change();dir_pur_change();">
                   			<option value="0"<%if (e_bean.getO_11()==0) {%> selected<%}%>>0</option>
							<option value="1.0"<%if (e_bean.getO_11()==1.0) {%> selected<%}%>>1.0</option>
							<option value="2.0"<%if (e_bean.getO_11()==2.0) {%> selected<%}%>>2.0</option>
							<option value="3.0"<%if (e_bean.getO_11()==3.0) {%> selected<%}%>>3.0</option>
							<option value="directInput"<%if (e_bean.getO_11()!=0 && e_bean.getO_11()!=1.0 && e_bean.getO_11()!=2.0 && e_bean.getO_11()!=3.0) {%> selected<%}%>>�����Է�</option>
						</select>
                    	<input type="text" name="o_11" class="num" maxlength="3" size="3" id="o_11_1" value="<%=e_bean.getO_11()%>" onBlur='javascript:set_return2_change();dir_pur_change();'>
                    	&nbsp;%<br>&nbsp;
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select id="sel_o_11_2" onchange="javascript:setO_11('2',this.value);dir_pur_change();">
                   			<option value="0"<%if (e_bean2.getO_11()==0) {%> selected<%}%>>0</option>
							<option value="1.0"<%if (e_bean2.getO_11()==1.0) {%> selected<%}%>>1.0</option>
							<option value="2.0"<%if (e_bean2.getO_11()==2.0) {%> selected<%}%>>2.0</option>
							<option value="3.0"<%if (e_bean2.getO_11()==3.0) {%> selected<%}%>>3.0</option>
							<option value="directInput"<%if (e_bean2.getO_11()!=0 && e_bean2.getO_11()!=1.0 && e_bean2.getO_11()!=2.0 && e_bean2.getO_11()!=3.0) {%> selected<%}%>>�����Է�</option>
						</select>
                    	<input type="text" name="o_11" class="num" maxlength="3" size="3" id="o_11_2" value="<%=e_bean2.getO_11()%>" onBlur='javascript:dir_pur_change();'>
                    	&nbsp;%<br>&nbsp;
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select id="sel_o_11_3" onchange="javascript:setO_11('3',this.value);dir_pur_change();">
                   			<option value="0"<%if (e_bean3.getO_11()==0) {%> selected<%}%>>0</option>
							<option value="1.0"<%if (e_bean3.getO_11()==1.0) {%> selected<%}%>>1.0</option>
							<option value="2.0"<%if (e_bean3.getO_11()==2.0) {%> selected<%}%>>2.0</option>
							<option value="3.0"<%if (e_bean3.getO_11()==3.0) {%> selected<%}%>>3.0</option>
							<option value="directInput"<%if (e_bean3.getO_11()!=0 && e_bean3.getO_11()!=1.0 && e_bean3.getO_11()!=2.0 && e_bean3.getO_11()!=3.0) {%> selected<%}%>>�����Է�</option>
						</select>
                    	<input type="text" name="o_11" class="num" maxlength="3" size="3" id="o_11_3" value="<%=e_bean3.getO_11()%>" onBlur='javascript:dir_pur_change();'>
                    	&nbsp;%<br>&nbsp;
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select id="sel_o_11_4" onchange="javascript:setO_11('4',this.value);dir_pur_change();">
                   			<option value="0"<%if (e_bean4.getO_11()==0) {%> selected<%}%>>0</option>
							<option value="1.0"<%if (e_bean4.getO_11()==1.0) {%> selected<%}%>>1.0</option>
							<option value="2.0"<%if (e_bean4.getO_11()==2.0) {%> selected<%}%>>2.0</option>
							<option value="3.0"<%if (e_bean4.getO_11()==3.0) {%> selected<%}%>>3.0</option>
							<option value="directInput"<%if (e_bean4.getO_11()!=0 && e_bean4.getO_11()!=1.0 && e_bean4.getO_11()!=2.0 && e_bean4.getO_11()!=3.0) {%> selected<%}%>>�����Է�</option>
						</select>
                    	<input type="text" name="o_11" class="num" maxlength="3" size="3" id="o_11_4" value="<%=e_bean4.getO_11()%>" onBlur='javascript:dir_pur_change();'>
                    	&nbsp;%<br>&nbsp;
                    </td>
                </tr>                     
                <tr> 
                    <td colspan='2' class=title>�뿩��D/C</td>
                    <td>
                    	&nbsp;
                    	�뿩����
                    	<input type="text" name="fee_dc_per" id="fee_dc_per_1" size="4" value='<%=e_bean.getFee_dc_per()%>' class=num onBlur='javascript:set_return2_change(); set_other_esti_value(this);'>
          				%
          			</td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	�뿩����
                      	<input type="text" name="fee_dc_per" id="fee_dc_per_2" size="4" value='<%=e_bean2.getFee_dc_per()%>' class=num>
          				%
          			</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                   		�뿩����
                      	<input type="text" name="fee_dc_per" id="fee_dc_per_3" size="4" value='<%=e_bean3.getFee_dc_per()%>' class=num>
          				%
          			</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	�뿩����
                      	<input type="text" name="fee_dc_per" id="fee_dc_per_4" size="4" value='<%=e_bean4.getFee_dc_per()%>' class=num>
          				%
          			</td>
                </tr>       
            </table>
        </td>
    </tr>
    
    <tr> 
        <td colspan="2"><font color="#666666">* �����ܰ��� : ���Կɼ� �ݾ���, ���Է½� �ִ��ܰ����� ����</font> </td>
    </tr> 
    
    <tr>
        <td class=h></td>
    </tr>
    
    <tr> 
        <td align=center colspan="2"> 
            <!-- <a id="submitLink" href="javascript:EstiReg();"><img src=/acar/images/center/button_est.gif align=absmiddle border=0></a> -->
            <a id="submitLink" href="javascript:confirmDialog();"><img src=/acar/images/center/button_est.gif align=absmiddle border=0></a>
        </td>
    </tr>
  </form>
</table>
<script>
<!--	

//����Ȱ������� ����
<%if (est_table.equals("esti_spe")) {%>
	set_amt();	
<%}%>	
	
<%if (est_table.equals("hp")) {%>
	document.form1.gi_per[0].value = 0; 
	document.form1.gi_amt[0].value = 0;
<%}%>

<%if (!est_table.equals("hp") && e_bean.getGi_amt()>0 && e_bean.getGi_per()==0) {%>
	compare(0, document.form1.gi_amt[0]);
<%}%>

<%if (est_table.equals("esti_spe") && st.equals("2")) { //�⺻������ �ٷ� ���%>
	searchO13(0);
  	EstiRegAuto();
<%}%>

<%if (e_bean.getPrint_type().equals("2") || e_bean.getPrint_type().equals("3") || e_bean.getPrint_type().equals("4") || e_bean.getPrint_type().equals("5")) {%>
	setEst_yn(<%=e_bean.getPrint_type()%>);
<%} else if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) {%>
	setEst_yn("6");
<%}%>
	
// 2017.12.22
	
/* $("input[name=tint_s_yn]").on("click", function() {
	$(this + 'input[type=checkbox]:(:checked)').each(function() {
		$(this).attr('checked', true).val('N');
	});
}); */
	
	LocStSet();
	
//�����ε����� ����Ʈ
function LocStSet() {
	<%  
	if (e_bean.getLoc_st().equals("")) {
		if (br_id.equals("S1")) {    e_bean.setLoc_st("1");
        } else if (br_id.equals("S2")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("S3")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("S4")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("S5")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("S6")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("I1")) { e_bean.setLoc_st("2");
        } else if (br_id.equals("K3")) { e_bean.setLoc_st("2");
        } else if (br_id.equals("D1")) { e_bean.setLoc_st("4");
        } else if (br_id.equals("G1")) { e_bean.setLoc_st("6");
        } else if (br_id.equals("J1")) { e_bean.setLoc_st("5");
        } else if (br_id.equals("B1")) { e_bean.setLoc_st("7");
        } else if (br_id.equals("U1")) { e_bean.setLoc_st("7"); }            
	}
    %>	

	document.form1.loc_st[0].value = <%=e_bean.getLoc_st()%>;
	document.form1.loc_st[1].value = <%=e_bean.getLoc_st()%>;
	document.form1.loc_st[2].value = <%=e_bean.getLoc_st()%>;
	document.form1.loc_st[3].value = <%=e_bean.getLoc_st()%>;
}
	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>