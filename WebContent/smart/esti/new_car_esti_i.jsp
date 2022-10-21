<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body ���� �Ӽ� */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '�������';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* ���̾ƿ� ū�ڽ� �Ӽ� */
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* �޴������ܵ� */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}


/* �ձ����̺� ���� */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}





/* �������̺� */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* �������̺� */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:15px 0 0 0;}




</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*, java.lang.* "%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.* "%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_comp_id = "0001";
	
	
	e_bean = e_db.getEstimateCase(est_id);
	
	float jg_f 	= 0;
	float jg_g 	= 0;
	String jg_w 	= "0";
	String jg_b 	= "";
	
	if(!est_id.equals("")){
		cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
		//��������
		ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
		jg_f = ej_bean.getJg_f()*100;
		jg_g = ej_bean.getJg_g()*100;
		jg_w = ej_bean.getJg_w();
		
		//�������̸� 500,000		
		if(AddUtil.parseInt(e_bean.getCar_comp_id()) >  5){
			e_bean.setCar_ja	(500000);
		}
	}else{
		e_bean.setCar_comp_id	("0001");
		e_bean.setA_a				("22");
		e_bean.setA_b				("36");
		e_bean.setOpt_chk 	("1");
		e_bean.setCar_ja		(300000);
	}
	
	//20120901���� ���������� �ִ�3% �̳����� ���ð��� - ����Ʈ 0%
	jg_f = 0;
	jg_g = 0;
	
	/* �ڵ� ����:�뿩��ǰ�� */
	CodeBean[] goods = c_db.getCodeAll("0009"); 
	int good_size = goods.length;
	
  
  //������ ���ּ���
  CodeBean[] code34 = c_db.getCodeAll3("0034");
  int code34_size = code34.length;	
  
  
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�ڵ���ȸ�� ����Ʈ
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	//������ ����� ��� ǥ��
	//String etc = umd.getCarCompOne("0001");
	Hashtable com_ht = umd.getCarCompCase("0001");
	String etc 	= String.valueOf(com_ht.get("ETC"));
	String bigo = String.valueOf(com_ht.get("BIGO"));
	
	
	//��������Ʈ-����Ʈ=>�����ڵ���
	Vector cars = a_cmb.getSearchCode(e_bean.getCar_comp_id(), "", "", "", "8", "");
	int car_size = cars.size();
%>

<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='javascript'>
<!--
	//�ڵ���ȸ�� ���ý� �����ڵ� ����ϱ�
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;		
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '8';
		fm2.rent_way.value = a_a.substring(1);		
		fm2.a_a.value = a_a.substring(0,1);		
		fm2.target="i_no";
		fm2.submit();
	}
	
	//���θ���Ʈ
	function sub_list(idx){
		var fm = document.form1;
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;				
		if(fm.code.value == ''){ alert('������ �����Ͻʽÿ�.'); return;}
		var SUBWIN="./search_car_list.jsp?idx="+idx+"&a_a="+a_a.substring(0,1)+"&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text;	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");
	}
	
	//������D/C �Է��� ��������ϱ�
	function set_amt(){
		var fm = document.form1;	
				fm.o_1.value  = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value))  - toInt(parseDigit(fm.tax_dc_amt.value)));		
		if(fm.a_a.value == '11' || fm.a_a.value == '12'){
			if(fm.ls_yn.value == 'Y'){
				fm.o_12.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt2.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));		
			}
		}	
	}
	
	
	//�ѵ��� ��, ����==�ݾ� ��ȯ
	function compare(obj){
		var fm = document.form1;
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		if(obj == fm.rg_8){
			fm.rg_8_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.rg_8.value)/100);	
			if(a_a == '11' || a_a == '12'){
				if(fm.ls_yn.value == 'Y'){
					fm.rg_8_amt.value = parseDecimal(toInt(parseDigit(fm.o_12.value)) * toInt(fm.rg_8.value)/100);	
				}
			}	
		}else if(obj == fm.rg_8_amt){
			var rg_8 = toInt(parseDigit(fm.rg_8_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
			if(a_a == '11' || a_a == '12'){
				if(fm.ls_yn.value == 'Y'){
					rg_8 = toInt(parseDigit(fm.rg_8_amt.value)) / toInt(parseDigit(fm.o_12.value)) * 100;
				}
			}	
			fm.rg_8.value = Math.round(rg_8);	
		}else if(obj == fm.pp_per){
			fm.pp_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.pp_per.value)/100);	
			if(a_a == '11' || a_a == '12'){
				if(fm.ls_yn.value == 'Y'){
					fm.pp_amt.value = parseDecimal(toInt(parseDigit(fm.o_12.value)) * toInt(fm.pp_per.value)/100);	
				}
			}						
		}else if(obj == fm.pp_amt){
			fm.pp_per.value = Math.round(toInt(parseDigit(fm.pp_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
			if(a_a == '11' || a_a == '12'){
				if(fm.ls_yn.value == 'Y'){
					fm.pp_per.value = Math.round(toInt(parseDigit(fm.pp_amt.value)) / toInt(parseDigit(fm.o_12.value)) * 100);
				}
			}	
		}else if(obj == fm.ro_13){
			fm.ro_13_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.ro_13.value)/100);		
			if(a_a == '11' || a_a == '12'){
				if(fm.ls_yn.value == 'Y'){
					fm.ro_13_amt.value = parseDecimal(toInt(parseDigit(fm.o_12.value)) * toInt(fm.ro_13.value)/100);		
				}
			}	
		}else if(obj == fm.ro_13_amt){
			var ro_13 = toInt(parseDigit(fm.ro_13_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
			if(a_a == '11' || a_a == '12'){
				if(fm.ls_yn.value == 'Y'){
					ro_13 = toInt(parseDigit(fm.ro_13_amt.value)) / toInt(parseDigit(fm.o_12.value)) * 100;
				}
			}	
			fm.ro_13.value = Math.round(ro_13);		
		}else if(obj == fm.gi_per){
			
			var temp_gi_per = fm.gi_per.value;    	
	    	var result_gi_amt = toInt(parseDigit(fm.o_1.value)) * toInt(fm.gi_per.value)/100;
	    	
	    	if(a_a == '11' || a_a == '12'){
				if (fm.ls_yn.value == 'Y') {
					result_gi_amt = toInt(parseDigit(fm.o_12.value)) * toInt(fm.gi_per.value)/100;
				}
	      	}
	    	
			var unit_num = 100000;
			var round_gi_amt = Math.round(result_gi_amt/unit_num) * unit_num;
			var trunc_gi_amt = Math.floor(result_gi_amt/unit_num) * unit_num;
	    	
	    	if (temp_gi_per > 34) {
	    		fm.gi_amt.value = parseDecimal(trunc_gi_amt);
	    	} else {
	    		fm.gi_amt.value = parseDecimal(round_gi_amt);
	    	}
			
			/* fm.gi_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.gi_per.value)/100);	
			if(a_a == '11' || a_a == '12'){
				if(fm.ls_yn.value == 'Y'){
					fm.gi_amt.value = parseDecimal(toInt(parseDigit(fm.o_12.value)) * toInt(fm.gi_per.value)/100);	
				}
			} */
		}else if(obj == fm.gi_amt){
			fm.gi_per.value = Math.round(toInt(parseDigit(fm.gi_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
			if(a_a == '11' || a_a == '12'){
				if(fm.ls_yn.value == 'Y'){
					fm.gi_per.value = Math.round(toInt(parseDigit(fm.gi_amt.value)) / toInt(parseDigit(fm.o_12.value)) * 100);
				}
			}	
		}	
	}	
	
	//������ã��
	function search_cust(){
		var fm = document.form1;
		var SUBWIN="search_cust_list.jsp?t_wd="+fm.est_nm.value;		
		window.open(SUBWIN, "SubCust", "left=10, top=10, width=600, height=400, scrollbars=yes, status=yes");		
	}
	
	// ���ڸ� ������ �޸� �ֱ�
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	//��������
	function EstiReg(){
		var fm = document.form1;
		
    //20160701 �Ͻ�����
    <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) == 20160701){%>
    	//alert('7��1�� �����Һ� �λ����� ���� �غ����Դϴ�. �����������α׷��� �̿��Ͽ� �ֽʽÿ�.');
    	//return;
    <%}%>		
		
    	fm.est_nm.value = fm.est_nm.value.trim();
    	
		if(fm.est_nm.value == ''){ alert('��/��ȣ�� �Է��Ͻʽÿ�'); fm.est_nm.focus(); return; }		
		
		var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;
		var ins_age = fm.ins_age.options[fm.ins_age.selectedIndex].value;
		
		if(fm.code.value == '')			{ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_id.value == '')		{ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_amt.value == '')	{ alert('�����ݾ��� Ȯ���Ͻʽÿ�'); return; }				
		if(fm.a_a.value == '')			{ alert('�뿩��ǰ�� �����Ͻʽÿ�'); return; }
		if(fm.a_b.value == '')			{ alert('�뿩�Ⱓ�� �����Ͻʽÿ�'); return; }
		
	//20160520 �ƽ��� Ư�������� �뺸�޽���
    if((fm.jg_code.value == '4156' || fm.jg_code.value == '4157') || (fm.jg_code.value == '4012591' || fm.jg_code.value == '4012592')){
    	alert('�����Ǹ��� ������ �����Դϴ�. ��������� ���� ���������� ��쿡�� �����Ǹ��� ��� �ϰ�, ��翡�� ����� ������ �����ϵ��� �մϴ�. (���� �� �븮�� ��� �Ұ� ����)');
    }
		
  	//20191004 ����Ƽ, �ް�Ʈ���� 2.4�� �ʰ��ϴ������� ������ �ȳ����� �˾����� - ������ ���� ��û����
    if((Number(fm.jg_code.value) >= 9142 && Number(fm.jg_code.value) <= 9152) || (Number(fm.jg_code.value) >= 9017212 && Number(fm.jg_code.value) <= 9018112)){
    	
    	var msg = "����� �ȳ�����\n\n" +
						"1. 2.4�� �̻� ����(����Ƽ, �ް�Ʈ�� ��)��,\n" +
						"�������������� ���Ͽ� �����, ������� �� 7��~�ִ� 10�� �ҿ� �˴ϴ�.\n\n" +
						"2. �ش� ����, ����� ����ϱ��� �� �������� ���� �����ؾ� �մϴ�.\n\n" +
						"3. ��ǰ�۾� �Ұ� (���ڽ� ��������, �����۾��Ұ�)";
    	
    	if (!confirm(msg)) {
   			return;
    	}
    }
				
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
	
	// ������ð� ��޽����� ��� üũ �� �� ����. 2017.12.26
    if(fm.tint_s_yn.checked && fm.tint_ps_yn.checked){
    	alert('������ð� ��޽��� �� �ϳ��� üũ�ϼ���.'); return;
    }
    
    // ��޽��� üũ �� �����ݿ� �ݾ��� 0���� �� ����.
    if(fm.tint_ps_yn.checked && fm.tint_ps_amt.value < 1){
    	alert('��޽��� �ݾ��� �Է��ϼ���.'); return;
    }
		
    //������
    if(fm.jg_g_7.value == '3'){
			if(fm.ecar_loc_st.value == ''){
      	alert('������ ���ּ����� �����Ͻʽÿ�.');
        return;
      }  	
     	if(fm.ecar_loc_st.value != '0'){
      	//alert('������ ���ּ����� ���︸ ������ �˴ϴ�.');
        //return;
      }  				
			//�������� 24�����̻�
      if(toInt(fm.a_b.value) < 24){
         alert('�������� 24�����̻� ���� �����մϴ�.');
         return;      
      }
    //������
    }else if(fm.jg_g_7.value == '4'){
			//�������� 24�����̻�
      if(toInt(fm.a_b.value) < 24){
         alert('�������� 24�����̻� ���� �����մϴ�.');
         return;      
      }      
    }else{
     	//���������� 12~60������
     	if(toInt(fm.a_b.value) < 12 || toInt(fm.a_b.value) > 60){
         alert('�뿩�Ⱓ�� 12����~60������ ������ �����մϴ�.');
         return;
       } 
       fm.tint_eb_yn.checked = false;
       
    }
    
    
     var r_ro_13_amt = toInt(parseDigit(fm.o_1.value)) * toFloat(fm.ro_13.value) / 100;
     var cha_line_amt = toInt(parseDigit(fm.o_1.value)) * 0.05 / 100;
      
     if(fm.a_a.value == '11' || fm.a_a.value == '12'){
       if(fm.ls_yn.value == 'Y'){
         r_ro_13_amt = toInt(parseDigit(fm.o_12.value)) * toFloat(fm.ro_13.value) / 100;
         cha_line_amt = toInt(parseDigit(fm.o_12.value)) * 0.05 / 100;
       }
     } 
      
     var r_cha_ro_13_amt = toInt(parseDigit(fm.ro_13_amt.value))-r_ro_13_amt;
     if(r_cha_ro_13_amt > cha_line_amt || r_cha_ro_13_amt < -cha_line_amt){
     	alert('������ �����ܰ����� ����� �ݾװ� �����ܰ��ݾ��� �ٸ��ϴ�. Ȯ���Ͻʽÿ�.');
     	return;
     }
     
		// ������ ���� 2018.01.10
		/* var car_price = fm.o_1.value.replace(/,/g,"");			// ��������
		var rg_price = fm.rg_8_amt.value.replace(/,/g,"");	// ������
		if(fm.jg_g_7.value == '3' || fm.jg_g_7.value == '4'){		// ������, ������ �� ���
			var deposit = car_price - fm.ecar_pur_sub_amt.value;		// ������ = �������� - ���ź�����
			if(rg_price > deposit){
				alert('�������� '+numberWithCommas(deposit)+'�� (�������� - ���ź�����) �̳��� ���� �����մϴ�. \n\n�߰��� �ʱⳳ�Ա� ���θ� ���� ��� ���������� �����Ͻø� �˴ϴ�.');
				return;
			}
		}else {
			if(rg_price > car_price){		// �������� �ƴѰ�� �������� ������ 100% �����Ѵ� 
				alert('�������� ������ 100% �̳��� ���� �����մϴ�. \n\n�߰��� �ʱⳳ�Ա� ���θ� ���� ��� ���������� �����Ͻø� �˴ϴ�.');
				return;
			}	
		} */
     
      //������å�� ����
      if(toInt(parseDigit(fm.car_comp_id.value)) > 5){
      	if(parseDigit(fm.car_ja.value) != '500000'){
      		alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      	}
      }else{
      	if(parseDigit(fm.car_ja.value) == '300000' || parseDigit(fm.car_ja.value) == '200000' || parseDigit(fm.car_ja.value) == '100000'){
      	}else{
      		alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      	}
      }     
          				
			if(fm.badcust_chk.value == ''){ 
				//alert('�ҷ��� Ȯ���� �Ͻʽÿ�.'); 	return;		
				//window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.est_nm.value+'&est_tel='+fm.est_tel.value+'&est_mail='+fm.est_email.value+'&est_fax='+fm.est_fax.value, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
				//return;
			}
					
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return; }
		fm.cmd.value = "i";
		fm.action = 'new_car_esti_i_a.jsp';
//		fm.target = "_self";
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
	
	//�ִ��ܰ��� ��ȸ
	function searchO13(){
		var fm = document.form1;
		
		var a_a 		= fm.a_a.options[fm.a_a.selectedIndex].value;
		var ins_age = fm.ins_age.options[fm.ins_age.selectedIndex].value;
		
		if(fm.code.value == ''){ 		alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_id.value == ''){ 	alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_amt.value == ''){ alert('�����ݾ��� Ȯ���Ͻʽÿ�'); return; }				
		if(fm.a_a.value == ''){ 		alert('�뿩��ǰ�� �����Ͻʽÿ�'); return; }
		if(fm.a_b.value == ''){ 		alert('�뿩�Ⱓ�� �����Ͻʽÿ�'); return; }
		
		if(fm.jg_g_7.value == '3' && fm.ecar_loc_st.value == ''){
			alert('������ ���ּ����� �����Ͻʽÿ�.'); return;
		}		
		
		var car_price 		= toInt(parseDigit(fm.o_1.value));
		
		fm.rg_8.value     = '25';
		$(document).find("#rg_8_s1").val("25").attr("selected", "selected");
		document.getElementById("rg_8_s2_span").style.display ='none';
    
		if(toInt(parseDigit(fm.car_comp_id.value)) <= 5){
			fm.rg_8.value     = '20';
			$(document).find("#rg_8_s1").val("20").attr("selected", "selected");
	    	document.getElementById("rg_8_s2_span").style.display ='none';
	    } 
    
	    //�������� �⺻ �����ݿ��� 10% ���ش�
	    if(fm.jg_g_7.value == '3'){
	     	fm.rg_8.value     = toInt(fm.rg_8.value)-10;
	     	if (toInt(fm.rg_8.value)-10 == 10){
	     		 $(document).find("#rg_8_s1").val("10").attr("selected", "selected");
	     	}else{
	     		 $(document).find("#rg_8_s1").val("").attr("selected", "selected");
	     		 fm.rg_8_s2.value = fm.rg_8.value;
	     		 document.getElementById("rg_8_s2_span").style.display ='inline';
	     	}
	    }
	    //�������� �⺻ �����ݿ��� 10% ���ش�
	    if(fm.jg_g_7.value == '4'){
	     	fm.rg_8.value     = toInt(fm.rg_8.value)-10;
	     	if (toInt(fm.rg_8.value)-15 == 10){
	     		 $(document).find("#rg_8_s1").val("10").attr("selected", "selected");
	     	}else{
	     		 $(document).find("#rg_8_s1").val("").attr("selected", "selected");
	     		 fm.rg_8_s2.value = fm.rg_8.value;
	     		 document.getElementById("rg_8_s2_span").style.display ='inline';
	     	}
	    }
        		
		//����DC �����Ҷ�
		if(fm.a_a.value == '11' || fm.a_a.value == '12'){
			if(fm.ls_yn.value == 'Y'){
				fm.dc_amt.value 	= fm.dc_amt2.value;
				fm.o_1.value 			= fm.o_12.value;	
				car_price 				= toInt(parseDigit(fm.o_1.value));											
			}
		}
		
		fm.rg_8_amt.value   = parseDecimal(car_price * toFloat(fm.rg_8.value) /100 );		
		
		//20141002 ������, ��������� ������ ����
		compare(fm.pp_per);
		compare(fm.gi_per);		
		
		fm.search_o13_yn.value = 'Y';	
		
		fm.target = 'i_no';		
		fm.action = 'get_o13_20141223.jsp';	
		//fm.target = '_blank';
		fm.submit();		
		
	}	
	
	
	//����������� ���ý� �������� ����
	function setO11(){
		var fm = document.form1;
		
		//�񱳰����϶� - ������ ������ ������.
		if(fm.cmd.value == 're'){
			if(fm.caroff_emp_yn[1].checked ==true || fm.caroff_emp_yn[2].checked ==true){		
				//��Ʈ �ִ������̸� ��Ʈ/���� �ִ�
				if((<%=e_bean.getA_a()%>==22 || <%=e_bean.getA_a()%>==21) && <%=e_bean.getO_11()%>==fm.jg_f.value){					
					if(fm.a_a.value == '22' || fm.a_a.value == '21'){//��Ʈ
						//fm.o_11.value 		= fm.jg_f.value;						
					}else{
						//fm.o_11.value 		= fm.jg_g.value;					
					}
					fm.o_11.value 		= <%=e_bean.getO_11()%>;					
				//���� �ִ������̸� ��Ʈ/���� �ִ�	
				}else if((<%=e_bean.getA_a()%>==12 || <%=e_bean.getA_a()%>==11) && <%=e_bean.getO_11()%>==fm.jg_g.value){					
					if(fm.a_a.value == '22' || fm.a_a.value == '21'){//��Ʈ
						//fm.o_11.value 		= fm.jg_f.value;						
					}else{
						//fm.o_11.value 		= fm.jg_g.value;					
					}
					fm.o_11.value 		= <%=e_bean.getO_11()%>;					
				//�ִ������� �ƴϸ� ������ ���� �״�� ����.														
				}else{
					fm.o_11.value 		= <%=e_bean.getO_11()%>;						
				}
			}else{
					fm.o_11.value 		= 0.0;						
			}
			
			//������ ��Ʈ�����ÿ��� �������1 -4%
			if(fm.jg_w.value == '1'){
						fm.fee_dc_per.value   = <%=e_bean.getFee_dc_per()%>;
						if(fm.a_a.value == '22'){//��Ʈ
							//fm.fee_dc_per.value 	= 0; // -4 -> 0 (20130501)			
							fm.ins_per.options[0].selected = true;
						}else if(fm.a_a.value == '11' || fm.a_a.value == '21'){//�ϹݽĺҰ�
							alert('�������� �Ϲݽ� ������ �ȵ˴ϴ�.');							
							fm.est_yn.checked = false;
							//fm.fee_dc_per.value 	= 0;		
							fm.ins_per.options[0].selected = true;
							
						}else{
							//fm.fee_dc_per.value 	= 0;
							//fm.ins_per.options[1].selected = true;
						}
						fm.car_ja.value 		= '500,000';
			}
			
		//�ű԰����϶�
		}else{		
			if(fm.caroff_emp_yn[1].checked ==true || fm.caroff_emp_yn[2].checked ==true){				
				if(fm.a_a.value == '22' || fm.a_a.value == '21'){//��Ʈ
					//fm.o_11.value 		= toFloat(fm.jg_f.value);						
				}else{
					//fm.o_11.value 		= toFloat(fm.jg_g.value);					
				}				
			}else{			
				fm.o_11.value 		= 0.0;									
			}
			
			//������ ��Ʈ�����ÿ��� �������1 -4%
			if(fm.jg_w.value == '1'){
						if(fm.a_a.value == '22'){//��Ʈ
							//fm.fee_dc_per.value 	= 0; // -4 -> 0 (20130501)			
							fm.ins_per.options[0].selected = true;
						}else if(fm.a_a.value == '11' || fm.a_a.value == '21'){//�ϹݽĺҰ�
							alert('�������� �Ϲݽ� ������ �ȵ˴ϴ�.');							
							fm.est_yn.checked = false;
							//fm.fee_dc_per.value 	= 0;		
							fm.ins_per.options[0].selected = true;
							
						}else{
							//fm.fee_dc_per.value 	= 0;
							//fm.ins_per.options[1].selected = true;
						}
						fm.car_ja.value 		= '500,000';
			}else{
						//fm.fee_dc_per.value 		= 0;						
						fm.car_ja.value 		= '300,000';
			}
		}
	}		
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "esti_main.jsp";		
		fm.submit();
	}		
	function setSelect(sgubun)
	{
		var fm = document.form1;
		if(sgubun=='a'){
			if(fm.a_b_s1.value == ''){
				fm.a_b.value = fm.a_b_s2.value;
				document.getElementById("a_b_s2_span").style.display ='inline';
			}else{
				fm.a_b.value = fm.a_b_s1.value;
				document.getElementById("a_b_s2_span").style.display ='none';
			}
		}
		else if(sgubun=='b'){
			if(fm.rg_8_s1.value == ''){
				fm.rg_8.value = fm.rg_8_s2.value;
				compare(fm.rg_8);
				document.getElementById("rg_8_s2_span").style.display ='inline';
			}else{
				fm.rg_8.value = fm.rg_8_s1.value;
				compare(fm.rg_8);
				document.getElementById("rg_8_s2_span").style.display ='none';
			}
		}
		else if(sgubun=='c'){
			if(fm.o_11_s1.value == ''){
				fm.o_11.value = fm.o_11_s2.value;
				document.getElementById("o_11_s2_span").style.display ='inline';
			}else{
				fm.o_11.value = fm.o_11_s1.value;
				document.getElementById("o_11_s2_span").style.display ='none';
			}
		}
		else if(sgubun=='d'){
			if(fm.agree_dist_s1.value == ''){
				fm.agree_dist.value = fm.agree_dist_s2.value;
				document.getElementById("agree_dist_s2_span").style.display ='inline';
			}else{
				fm.agree_dist.value = fm.agree_dist_s1.value;
				document.getElementById("agree_dist_s2_span").style.display ='none';
			}
		}
	}		
//������ ���ּ��� ���濡 ���� �����ε����� ����
function setLoc_st(val){
	document.form1.loc_st.value=toInt(val)+1;
	if(val == '7') document.form1.loc_st.value='4';
	if(val == '8') document.form1.loc_st.value='6';
}		
//-->
</script>

<body>
  <form action="get_car_mst_null.jsp" name="form2" method="post">
    <input type="hidden" name="sel" value="">
    <input type="hidden" name="car_comp_id" value="">
    <input type="hidden" name="code" value="">
    <input type="hidden" name="mode" value="">
    <input type="hidden" name="rent_way" value="">	
    <input type="hidden" name="a_a" value="">		
  </form>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
    <input type="hidden" name="cmd" value="<%=cmd%>">
    <input type="hidden" name="s_st" value="">
    <input type="hidden" name="a_e" value="">
	<input type="hidden" name="a_h" value="">	
	<input type="hidden" name="ins_good" value="0"><!--�ִ�ī����:�̰���-->	
	<input type="hidden" name="ls_yn" value="">
	<input type="hidden" name="dc_amt2" value="">
	<input type="hidden" name="o_12" value="">		
	<input type="hidden" name="ecar_pur_sub_amt" value="">
	<input type="hidden" name="jg_f" value="<%=jg_f%>">
	<input type="hidden" name="jg_g" value="<%=jg_g%>">
	<input type="hidden" name="jg_w" value="<%=jg_w%>">
	<input type="hidden" name="jg_b" value="<%=jg_b%>">
	<input type="hidden" name="jg_g_7" value="<%=ej_bean.getJg_g_7()%>">
	<input type="hidden" name="jg_code" value="<%=cm_bean.getJg_code()%>">	
	<input type="hidden" name="jg_opt_st" value="<%=e_bean.getJg_opt_st()%>">
	<input type="hidden" name="jg_col_st" value="<%=e_bean.getJg_col_st()%>">
	<input type="hidden" name="search_o13_yn" value="">
	<input type="hidden" name="jg_tuix_st" value="<%=e_bean.getJg_tuix_st()%>">
	<input type="hidden" name="jg_tuix_opt_st" value="<%=e_bean.getJg_tuix_opt_st()%>">
	<input type="hidden" name="lkas_yn" value="<%=e_bean.getLkas_yn()%>">							<!-- ������Ż ������ (��������)	-->
  	<input type="hidden" name="lkas_yn_opt_st" value="<%=e_bean.getLkas_yn_opt_st()%>">	<!-- ������Ż ������ (�ɼ�)			-->
  	<input type="hidden" name="ldws_yn" value="<%=e_bean.getLdws_yn()%>">							<!-- ������Ż ����� (��������)	-->
  	<input type="hidden" name="ldws_yn_opt_st" value="<%=e_bean.getLdws_yn_opt_st()%>">	<!-- ������Ż ����� (�ɼ�)			-->
  	<input type="hidden" name="aeb_yn" value="<%=e_bean.getAeb_yn()%>">								<!-- ������� ������ (��������)	-->
  	<input type="hidden" name="aeb_yn_opt_st" value="<%=e_bean.getAeb_yn_opt_st()%>">		<!-- ������� ������ (�ɼ�)			-->
	<input type="hidden" name="fcw_yn" value="<%=e_bean.getFcw_yn()%>">								<!-- ������� ����� (��������)	-->
	<input type="hidden" name="fcw_yn_opt_st" value="<%=e_bean.getFcw_yn_opt_st()%>">		<!-- ������� ����� (�ɼ�)			-->
	<input type="hidden" name="hook_yn" value="<%=e_bean.getHook_yn()%>">							<!-- ���ΰ� (��������)	-->
	<input type="hidden" name="hook_yn_opt_st" value="<%=e_bean.getHook_yn_opt_st()%>">		<!-- ���ΰ� (�ɼ�)			-->
	
  <input type='hidden' name='badcust_chk_from' value='esti_mng_atype_i.jsp'>
     
			
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">������������</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='����ȭ�� ����'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">������&nbsp;
		<a href="javascript:search_cust()" onMouseOver="window.status=''; return true" title="����ȸ�ϱ�. Ŭ���ϼ���"><img src="/smart/images/btn_serch.gif"  border="0" align=absmiddle></a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <font color=red>�� �ҷ��� Ȯ���ϱ�</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='��Ȯ��' onclick="javascript:view_badcust();">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">   		
		</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>��ȣ/����</th>
							<td valign=top><input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="25" class=text style='IME-MODE: active'></td>
						</tr>
						<tr>
							<th valign=top>�����/<br>�������</th>
							<td valign=top><input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>��ȭ��ȣ</th>
							<td valign=top><input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>FAX</th>
							<td valign=top><input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>�̸����ּ�</th>
							<td valign=top><input type="text" name="est_email" value="<%=e_bean.getEst_email()%>" size="25" class=text style='IME-MODE: inactive'></td>
						</tr>
				    	<tr>
				    		<th>������</th>
				    		<td><select name="doc_type">
					   <option value="">����</option>
                        <option value="1" <%if(e_bean.getDoc_type().equals("1")||e_bean.getDoc_type().equals(""))%>selected<%%>>���ΰ�</option>
                        <option value="2" <%if(e_bean.getDoc_type().equals("2"))%>selected<%%>>���λ����</option>
						<option value="3" <%if(e_bean.getDoc_type().equals("3"))%>selected<%%>>����</option>
                      </select>
        	 		  		</td>
				    	</tr>	
				    	<tr>
				    		<th>�ſ뵵����</th>
				    		<td><select name="spr_yn">
                        		  <option value="">=�� ��=</option>
								  <option value="3" <% if(e_bean.getSpr_yn().equals("3")) out.print("selected"); %>>�ż�����</option>
								  <option value="0" <% if(e_bean.getSpr_yn().equals("0")) out.print("selected"); %>>�Ϲݱ��</option>
								  <option value="1" <% if(e_bean.getSpr_yn().equals("1")) out.print("selected"); %>>�췮���</option>
								  <option value="2" <% if(e_bean.getSpr_yn().equals("2")||e_bean.getSpr_yn().equals("")) out.print("selected"); %>>�ʿ췮���</option>
                      			</select></td>
				    	</tr>																									
				    	<tr>
				    		<th>������ȿ�Ⱓ</th>
				    		<td><select name="vali_type">
					    		<option value="">����</option>
                        		<option value="0" <%if(e_bean.getVali_type().equals("0")||e_bean.getVali_type().equals(""))%>selected<%%>>��¥��ǥ��(10��)</option>
                        		<option value="1" <%if(e_bean.getVali_type().equals("1"))%>selected<%%>>����ĿD/C ���� ���ɼ� ���</option>
                       			<option value="2" <%if(e_bean.getVali_type().equals("2"))%>selected<%%>>��Ȯ������</option>						
                      		</select>
        	 		  		</td>
				    	</tr>
				    	<tr>
				    		<th>���������<br>���� ���</th>
				    		<td>
				    			<select name="gi_grade">
				    				<option value="" <%if(e_bean.getGi_grade().equals("")){%>selected<%}%>>������ǥ��</option>
			    					<option value="1" <%if(e_bean.getGi_grade().equals("1")){%>selected<%}%>>1���</option>
			    					<option value="2" <%if(e_bean.getGi_grade().equals("2")){%>selected<%}%>>2���</option>
			    					<option value="3" <%if(e_bean.getGi_grade().equals("3")){%>selected<%}%>>3���</option>
			    					<option value="4" <%if(e_bean.getGi_grade().equals("4")){%>selected<%}%>>4���</option>
			    					<option value="5" <%if(e_bean.getGi_grade().equals("5")){%>selected<%}%>>5���</option>
			    					<option value="6" <%if(e_bean.getGi_grade().equals("6")){%>selected<%}%>>6���</option>
			    					<option value="7" <%if(e_bean.getGi_grade().equals("7")){%>selected<%}%>>7���</option>
				    			</select>
				    		</td>
				    	</tr>		
				    	<tr>
				    		<th>�����</th>
				    		<td><select name='damdang_id' class=default>            
                        <option value="">������</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        					%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(ck_acar_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        			  
        			  &nbsp;&nbsp;&nbsp;
        			  <input type="radio" name="caroff_emp_yn" value="1"  onClick="javascript:setO11();" <%if(e_bean.getCaroff_emp_yn().equals("1") || e_bean.getCaroff_emp_yn().equals("")){%>checked<%}%>  >�����������
        			  <input type="radio" name="caroff_emp_yn" value="2"  onClick="javascript:setO11();" <%if(e_bean.getCaroff_emp_yn().equals("2")){%>checked<%}%>  >�����������(��� ����� ǥ��)
        			  <input type="radio" name="caroff_emp_yn" value="3"  onClick="javascript:setO11();" <%if(e_bean.getCaroff_emp_yn().equals("3")){%>checked<%}%>  >�����������(��� ����� ��ǥ��)
        		
        		
        		
        	 		  		</td>
				    	</tr>																																																														
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">��������</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="90">������</th>
				    		<td><select name="car_comp_id" onChange="javascript:GetCarCode()">
                        		  <option value="">=�� ��=</option>
								              <%for(int i=0; i<cc_r.length; i++){
        						        			cc_bean = cc_r[i];
        						        			
        						        			//if(cc_bean.getCode().equals("0018")) continue;
        						        			
        						        	%>
                        		  <option value="<%= cc_bean.getCode() %>" <%if(e_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        		  <%	
                          		  }	%>
                      			</select>                      			
                      			</td>
				    	</tr>
				    	<tr>
				    		<th width="90"></th>
				    		<td>
                      			<textarea id="etc" name="etc" cols="37" rows="5" style="border: 0;" readonly><%=etc%></textarea>
                      			</td>
				    	</tr>				    	
				    	<tr>
				    		<th>����</th>
				    		<td><select name="code">
                        		  <option value="">����</option>
                        		  <%for(int i = 0 ; i < car_size ; i++){
        								Hashtable car = (Hashtable)cars.elementAt(i);%>
                        		  <option value="<%=car.get("CODE")%>" <%if(car.get("CODE").equals(cm_bean.getCode()))%>selected<%%>><%=car.get("CAR_NM")%></option>
                        		  <%	}	%>		
                      			</select></td>
				    	</tr>	
						<tr>
							<th>����&nbsp;<a href="javascript:sub_list('1');"><img src=/smart/images/btn_in_ch.gif border=0></a></th>
							<td><textarea name="car_name" cols="25" rows="3" class="text"><%=cm_bean.getCar_name()%></textarea>
                      			<input type="hidden" name="car_id" value="<%=e_bean.getCar_id()%>">
                      			<input type="hidden" name="car_seq" value="<%=e_bean.getCar_seq()%>"><br>
								&nbsp;<input type="text" name="car_amt" value="<%=AddUtil.parseDecimal(e_bean.getCar_amt())%>" size="10" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      			��
							</td>
						</tr>					
						<tr>
							<th>�ɼ�&nbsp;<a href="javascript:sub_list('2');"><img src=/smart/images/btn_in_ch.gif border=0></a></th>
							<td><textarea name="opt" cols="25" rows="4" class="text"><%=e_bean.getOpt()%></textarea>
                      			<input type="hidden" name="opt_seq" value="<%=e_bean.getOpt_seq()%>"><br>
								&nbsp;<input type="text" name="opt_amt" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>" size="10" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
								<input type="hidden" name="opt_amt_m" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt_m())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value);' readonly>
                      			��
							</td>
						</tr>				
						<tr>
							<th>����&nbsp;<a href="javascript:sub_list('3');"><img src=/smart/images/btn_in_ch.gif border=0></a></th>
							<td>����:<textarea name="col" cols="20" class="text"><%=e_bean.getCol()%></textarea><br>
							����:<input type="text" name="in_col" value="<%=e_bean.getIn_col()%>" size="20" class=text>
                      			<input type="hidden" name="col_seq" value="<%=e_bean.getCol_seq()%>"><br>
								&nbsp;<input type="text" name="col_amt" value="<%=AddUtil.parseDecimal(e_bean.getCol_amt())%>" size="10" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      			��
							</td>
						</tr>		
						<tr>
							<th>����&nbsp;<a href="javascript:sub_list('5');"><img src=/smart/images/btn_in_ch.gif border=0></a></th>
							<td>
								<input type="text" name="conti_rat" value="<%=e_bean.getConti_rat()%>" size="30">
								<input type="hidden" name="conti_rat_seq" value=""/>
							</td>
						</tr>				
						<tr>
							<th>������DC&nbsp;<a href="javascript:sub_list('4');"><img src=/smart/images/btn_in_ch.gif border=0></a></th>
							<td><textarea name="dc" cols="25" class="text"><%=e_bean.getDc()%></textarea>
                      			<input type="hidden" name="dc_seq" value="<%=e_bean.getDc_seq()%>"><br>
								-<input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(e_bean.getDc_amt())%>" size="10" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      			��
							</td>
						</tr>		
				    	<tr>
				    		<th width="90"></th>
				    		<td>
                      			<textarea id="bigo" name="bigo" cols="37" rows="5" style="border: 0;" readonly><%=bigo%></textarea>
                      			</td>
				    	</tr>				    							
						<tr>
							<th>���Ҽ� ����&nbsp;</th>
							<td>�����Һ� �� ������ ����<br>
								-<input type="text" name="tax_dc_amt" value="<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%>" size="10" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value);'>
                      			��
							</td>
						</tr>									
				    	<tr>
				    		<th width="90">���</th>
				    		<td>
                      			<textarea id="car_etc" name="car_etc" cols="37" rows="5" style="border: 0;" readonly></textarea>
                      			</td>
				    	</tr>				    						
						<tr>
							<th>��������</th>
							<td>
								&nbsp;<input type="text" name="o_1" value="<%=AddUtil.parseDecimal(e_bean.getO_1())%>" size="10" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      			��
							</td>
						</tr>																																
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">�������</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th>�뿩��ǰ</th>
				    		<td><select name="a_a" onChange="javascript:setO11();">
                        		<option value="">=�� ��=</option>
								<%for(int i = 0 ; i < good_size ; i++){
        							CodeBean good = goods[i];%>
                        		  <option value='<%= good.getNm_cd()%>' <%if(e_bean.getA_a().equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        		<%}%>
                      			</select></td>
				    	</tr>	
						<tr>
							<th>�뿩�Ⱓ</th>
							<td><select name="a_b_s1" onChange="setSelect('a');">
              		  <option value='12' <%if(e_bean.getA_b().equals("12"))%>selected<%%> >12����</option>
              		  <option value='24' <%if(e_bean.getA_b().equals("24"))%>selected<%%> >24����</option>
              		  <option value='36' <%if(e_bean.getA_b().equals("36"))%>selected<%%> >36����</option>
              		  <option value='48' <%if(e_bean.getA_b().equals("48"))%>selected<%%> >48����</option>
              		  <option value='' <%if(!e_bean.getA_b().equals("48") && !e_bean.getA_b().equals("12") && !e_bean.getA_b().equals("24") && !e_bean.getA_b().equals("36") )%>selected<%%> >�����Է�</option>
            			</select>
                 <span id = "a_b_s2_span" style="<%if(e_bean.getA_b().equals("48") || e_bean.getA_b().equals("12") || e_bean.getA_b().equals("24") || e_bean.getA_b().equals("36") ){%>display:none;<%}%>"><input type="text" name="a_b_s2" value="<%=e_bean.getA_b()%>" size="3" class=text onChange="setSelect('a');">����</span>
                 <input type="hidden" name="a_b" value="<%=e_bean.getA_b()%>" size="3">
              </td>
                 
						</tr>	
					<%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20141223){%>
				    	<tr>
				    		<th width="90">ǥ�� ��������Ÿ�</th>
				    		<td><input type="text" name="b_agree_dist" class=whitenum size="10" value='<%//=AddUtil.parseDecimal(e_bean.getAgree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);' style="border:white;">
							km/��    
        	 		  		</td>
				    	</tr>	
				    	<tr>
				    		<th width="90">���� ��������Ÿ�</th>
				    		<td>
				    		<select name="agree_dist_s1" id="agree_dist_s1" onChange="setSelect('d');">
              		  <option value='20000'>20,000 km/��</option>
              		  <option value='30000'>30,000 km/��</option>
              		  <option value='40000'>40,000 km/��</option>
              		  <option value='' >�����Է�</option>
            		</select>
				    		<span id = "agree_dist_s2_span" style="display:none;"><input type="text" name="agree_dist_s2" class=num size="10" value='<%//=AddUtil.parseDecimal(e_bean.getAgree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);' onChange="setSelect('d');">km/��</span>
				    		<input type="hidden" name="agree_dist" class=num size="10" value='<%//=AddUtil.parseDecimal(e_bean.getAgree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
							    
        	 		  		</td>
				    	</tr>	
				    	<tr>
				    		<th width="90">ǥ�� �ִ��ܰ�</th>
				    		<td><input type="text" name="b_o_13" size="4" class=whitenum  value='<%//=e_bean.getO_13()%>'">%
							    <a href="javascript:searchO13();"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
        	 		  		</td>
				    	</tr>	
				    	<tr>
				    		<th width="90">���� �ִ��ܰ�</th>
				    		<td><input type="text" name="o_13" size="4" class=whitenum  value='<%//=e_bean.getO_13()%>'">%
							  
        	 		  		</td>
				    	</tr>					    					    					    						
					<%}else{%>
																
				    	<tr>
				    		<th width="90">�ִ��ܰ�</th>
				    		<td><input type="text" name="o_13" size="4" class=text  value='<%//=e_bean.getO_13()%>'">%
							    <a href="javascript:searchO13();"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
        	 		  		</td>
				    	</tr>	
				    	<%}%>																																	
				    	<tr>
				    		<th width="90">�����ܰ�</th>
				    		<td><input type="text" name="ro_13" size="4" class=text  value='<%//=e_bean.getRo_13()%>' onblur="javascript:compare(this)">%
	                      		<input type="text" name="ro_13_amt" class=num size="10" value='<%//=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		��<br>
						  		(���Կɼ� �ݾ���, ���Է½� �ִ��ܰ����� ����)
        	 		  		</td>
				    	</tr>																													
				    	<tr>
				    		<th>���Կɼ�</th>
				    		<td><input type='radio' name="opt_chk" value='0' <%if(e_bean.getOpt_chk().equals("0")||e_bean.getOpt_chk().equals("")){%> checked <%}%>>
                      			�̺ο�
                      			<input type='radio' name="opt_chk" value='1' <%if(e_bean.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		 			�ο�
							</td>
				    	</tr>
				    	<tr>
				    		<th>������</th>
				    		<td><select name="rg_8_s1" id= "rg_8_s1" onChange="setSelect('b');">
              		  <option value='0'  <%if(new Float(e_bean.getRg_8()).equals(new Float("0.0")))%>selected<%%> >0%</option>
              		  <option value='10' <%if(new Float(e_bean.getRg_8()).equals(new Float("10.0")))%>selected<%%>>10%</option>
              		  <option value='20' <%if(new Float(e_bean.getRg_8()).equals(new Float("20.0")))%>selected<%%>>20%</option>
              		  <option value='25' <%if(new Float(e_bean.getRg_8()).equals(new Float("25.0")))%>selected<%%>>25%</option>
              		  <option value='30' <%if(new Float(e_bean.getRg_8()).equals(new Float("30.0")))%>selected<%%>>30%</option>
              		  <option value=''   <%if(!new Float(e_bean.getRg_8()).equals(new Float("30.0")) && !new Float(e_bean.getRg_8()).equals(new Float("0.0")) && !new Float(e_bean.getRg_8()).equals(new Float("10.0")) && !new Float(e_bean.getRg_8()).equals(new Float("20.0")) && !new Float(e_bean.getRg_8()).equals(new Float("25.0")))%>selected<%%>>�����Է�</option>
            			</select>
            			<span id = "rg_8_s2_span" style="<%if(new Float(e_bean.getRg_8()).equals(new Float("0.0")) || new Float(e_bean.getRg_8()).equals(new Float("10.0")) || new Float(e_bean.getRg_8()).equals(new Float("20.0")) || new Float(e_bean.getRg_8()).equals(new Float("25.0")) || new Float(e_bean.getRg_8()).equals(new Float("30.0"))  ){%>display:none;<%}%>" ><input type="text" name="rg_8_s2" class=num size="4" value='<%=e_bean.getRg_8()%>' onChange="setSelect('b');">%</span>
	                      		<input type="text" name="rg_8_amt" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		��
    	                  		<input type="hidden" name="rg_8" class=num size="4" value='<%=e_bean.getRg_8()%>' >
        	 		  		</td>
				    	</tr>				
				    	<tr>
				    		<th>������</th>
				    		<td><input type="text" name="pp_per" class=num size="4" value="<%=e_bean.getPp_per()%>" onBlur="javascript:compare(this)">%
	                      		<input type="text" name="pp_amt" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		��
        	 		  		</td>
				    	</tr>			
				    	<tr>
				    		<th>���ô뿩��</th>
				    		<td><input type="checkbox" name="pp_st" value="1" <%if(e_bean.getPp_st().equals("1"))%> checked<%%>>
							    <input type="text" name="g_10" class=num size="2" value="<%=e_bean.getG_10()%>">����ġ
        	 		  		</td>
				    	</tr>	
				    	<!--
				    	<tr>
				    		<th>��������</th>
				    		<td><select name="insurant">
                            <option value="1" <%if(e_bean.getInsurant().equals("1")||e_bean.getInsurant().equals(""))%>selected<%%>>�Ƹ���ī</option>
                            <option value="2" <%if(e_bean.getInsurant().equals("2"))%>selected<%%>>��</option>
                          </select>
        	 		  		</td>
				    	</tr>
				    	-->																																																	
				    	<tr>
				    		<th>�Ǻ�����</th>
				    		<td><select name="ins_per">
                            <option value="1" <%if(e_bean.getIns_per().equals("1")||e_bean.getIns_per().equals(""))%>selected<%%>>�Ƹ���ī(��������)</option>
                            <!--<option value="2" <%if(e_bean.getIns_per().equals("2"))%>selected<%%>>��(���������)</option>-->
                          </select>
        	 		  		</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>�����ڿ���</th>
				    		<td><select name="ins_age">
                			<option value="1" <%if(e_bean.getIns_age().equals("1")||e_bean.getIns_age().equals(""))%>selected<%%>>��26���̻�</option>
   							<option value="3" <%if(e_bean.getIns_age().equals("3"))%>selected<%%>>��24���̻�</option>
                			<option value="2" <%if(e_bean.getIns_age().equals("2"))%>selected<%%>>��21���̻�</option>
               			 	</select>
        	 		  		</td>
				    	</tr>																																																																																																							
				    	<tr>
				    		<th>�빰/�ڼ�</th>
				    		<td><select name="ins_dj" >
                			<option value="1" <%if(e_bean.getIns_dj().equals("1"))%>selected<%%>>5õ����/5õ����</option>
                			<option value="2" <%if(e_bean.getIns_dj().equals("2")||e_bean.getIns_dj().equals(""))%>selected<%%>>1���/1���</option>
                			<option value="4" <%if(e_bean.getIns_dj().equals("4"))%>selected<%%>>2���/1���</option>
                                        <option value="8" <%if(e_bean.getIns_dj().equals("8")){%>selected<%}%>>3���/1���</option>
                                        <option value="3" <%if(e_bean.getIns_dj().equals("3")){%>selected<%}%>>5���/1���</option>
                			
               	 			</select>
        	 		  		</td>
				    	</tr>																																																				
				    	<tr>
				    		<th>������å��</th>
				    		<td><input type="text" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
        	 		  		</td>
				    	</tr>																																																							
				    	<tr>
				    		<th>��������</th>
				    		<td><input type="text" name="gi_per" class=num size="4" value='<%=e_bean.getGi_per()%>' onBlur="javascript:compare(this)">%
							<input type="text" name="gi_amt" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>��
        	 		  		</td>
				    	</tr>	
				    	
				    	<tr>
				    		<th>��ǰ</th>
				    		<td>&nbsp;				    
                      					<label><input type="checkbox" name="tint_s_yn" value="Y" <%if(e_bean.getTint_s_yn().equals("Y")){%>checked<%}%>> ���� ����(�⺻��)</label>
                      					<br>&nbsp;
                      					<label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(e_bean.getTint_ps_yn().equals("Y")){%>checked<%}%>> ��� ����</label>
                      					<span style="margin-left:1cm;">����</span><input type="text" name="tint_ps_nm" size="10"> 
                      					<br>
                      					<span style="margin-left:1.6cm;">�߰��ݾ�(���ް�)</span><input type="text" name="tint_ps_amt" size="10"
                      						onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);'> �� 
                      					<br>&nbsp;
                      					<label><input type="checkbox" name="tint_bn_yn" value="Y" <%if(e_bean.getTint_bn_yn().equals("Y")){%>checked<%}%>> ���ڽ� ������ ���� (��Ʈ��ķ,������..)</label>
                      					<br>&nbsp;
                      					<label><input type="checkbox" name="tint_cons_yn" value="Y" <%if(e_bean.getTint_cons_yn().equals("Y")){%>checked<%}%>> �߰�Ź�۷��</label>
                      					<input type="text" name="tint_cons_amt" size="10" value="<%=AddUtil.parseDecimal(e_bean.getTint_cons_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);'> ��
                      					<br>&nbsp;
				                      	<label> ��ȣ�Ǳ���</label>
				                      	<!-- <label> ������ȣ�ǽ�û</label> -->
				                      	<select name="new_license_plate" id="new_license_plate">
				                      		<option value="1" <%if (e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) {%>selected<%}%>>����</option>
				                      		<option value="0" <%if (!(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2"))) {%>selected<%}%>>����</option>
				                      		<%-- <option value="" <%if (e_bean.getNew_license_plate().equals("")) {%>selected<%}%>>��û����</option>
				                      		<option value="1" <%if (e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) {%>selected<%}%>>��û</option> --%>
<%-- 				                      		<option value="1" <%if (e_bean.getNew_license_plate().equals("1")) {%>selected<%}%>>������</option> --%>
<%-- 				                      		<option value="2" <%if (e_bean.getNew_license_plate().equals("2")) {%>selected<%}%>>����/�뱸/����/�λ�</option> --%>
				                      	</select>	
                      					<!-- <br>&nbsp; -->
                      					<label style="display: none;"><input type="checkbox" name="tint_n_yn" value="Y" <%if(e_bean.getTint_n_yn().equals("Y")){%>checked<%}%>> ��ġ�� ������̼�</label>
                      					<!-- <br>&nbsp; -->
                      					<label style="display: none;"><input type="checkbox" name="tint_eb_yn" value="Y" <%if(e_bean.getTint_eb_yn().equals("Y")){%>checked<%}%>> �̵��� ������(������)</label>
        	 		  		</td>
				    	</tr>			
				    	
				    	<tr>
				    		<th>������ ���ּ���</th>
				    		<td><select name="ecar_loc_st" onChange="setLoc_st(this.value);">
                    	  <option value="" <%if(e_bean.getEcar_loc_st().equals(""))%>selected<%%>>����</option>
                    	  <%for(int i = 0 ; i < code34_size ; i++){
                            CodeBean code = code34[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(e_bean.getEcar_loc_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                            	  
                      </select>
        	 		  		</td>
				    	</tr>
				    	
				    	<tr <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("5")){%><%}else{%>style="display: none;"<%}%>>
				    		<th>�������ｺƼĿ �߱�<br>(�����ͳ� �̿� �����±�)</th>
				    		<td>
				    			<select name="eco_e_tag">
				    			<%if (ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")) {%>
		        		        	<option value="0" selected>�̹߱�</option>
		                        	<option value="1">�߱�</option>
		                   		<%} else {%>
		        		        	<option value="0" <%if (e_bean.getEco_e_tag().equals("0")) {%>selected<%}%>>�̹߱�</option>
		                        	<option value="1" <%if (e_bean.getEco_e_tag().equals("1")) {%>selected<%}%>>�߱�</option>
		                   		<%}%>
                      			</select>
        	 		  		</td>
				    	</tr>
				    					    					    	
				    	<tr>
				    		<th>�����ε�����</th>
				    		<td><select name="loc_st">
                        <option value="1" <%if(br_id.equals("S1") || br_id.equals("S2") || br_id.equals("S3") || br_id.equals("S4") || br_id.equals("S5") || br_id.equals("S6"))%>selected<%%>>����</option>
                        <option value="2" <%if(br_id.equals("I1") || br_id.equals("K3"))%>selected<%%>>��õ/���</option>
                        <option value="3" >����</option>                        
                        <option value="4" <%if(br_id.equals("D1"))%>selected<%%>>����/����/�泲/���</option>
                        <option value="5" <%if(br_id.equals("J1"))%>selected<%%>>����/����/����</option>                        
                        <option value="6" <%if(br_id.equals("G1"))%>selected<%%>>�뱸/���</option>                        
                        <option value="7" <%if(br_id.equals("B1") || br_id.equals("U1"))%>selected<%%>>�λ�/���/�泲</option>  
                      </select>
        	 		  		</td>
				    	</tr>	
				    	<input type="hidden" name="udt_st" value="">				
				    																																									
				    	<tr>
				    		<th>��������</th>
				    		<td>������ <select name="o_11_s1" onChange="setSelect('c');">
              		  <option value='0'  <%if(new Float(e_bean.getO_11()).equals(new Float("0.0")))%>selected<%%>  >0%</option>
              		  <option value='1'  <%if(new Float(e_bean.getO_11()).equals(new Float("1.0")))%>selected<%%>  >1%</option>
              		  <option value='2'  <%if(new Float(e_bean.getO_11()).equals(new Float("2.0")))%>selected<%%>  >2%</option>
              		  <option value='3'  <%if(new Float(e_bean.getO_11()).equals(new Float("3.0")))%>selected<%%>  >3%</option>
              		  <option value=''   <%if(!new Float(e_bean.getO_11()).equals(new Float("0.0")) && !new Float(e_bean.getO_11()).equals(new Float("1.0")) && !new Float(e_bean.getO_11()).equals(new Float("2.0")) && !new Float(e_bean.getO_11()).equals(new Float("3.0")) )%>selected<%%>  >�����Է�</option>
            			</select>
            			<span id = "o_11_s2_span"  style="<%if(new Float(e_bean.getO_11()).equals(new Float("0.0")) || new Float(e_bean.getO_11()).equals(new Float("1.0")) || new Float(e_bean.getO_11()).equals(new Float("2.0")) || new Float(e_bean.getO_11()).equals(new Float("3.0"))  ){%>display:none;<%}%>" > <input type="text" name="o_11_s2" value="<%=e_bean.getO_11()%>" size="4" class=text onChange="setSelect('c');">% </span>
            			<input type="hidden" name="o_11" value="<%=e_bean.getO_11()%>" size="4" class=text>
                      		
        	 		  		</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>�뿩��D/C</th>
				    		<td>�뿩���� 
                     		<input type="text" name="fee_dc_per" value="<%=e_bean.getFee_dc_per()%>" size="4" class=text>
                      		%
        	 		  		</td>
				    	</tr>	
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>								
			
	</div>
	<div id="cbtn"><a href="javascript:EstiReg();"><img src=/smart/images/btn_est.gif align=absmiddle border=0></a></div>	
	<div id="footer"></div>  
</div>
</form>
<script>
<!--
	LocStSet();
	
	//�����ε����� ����Ʈ
	function LocStSet(){
        <%  if(e_bean.getLoc_st().equals("")){
            if(br_id.equals("S1"))    e_bean.setLoc_st("1");
            else if(br_id.equals("S2")) e_bean.setLoc_st("1");
            else if(br_id.equals("S3")) e_bean.setLoc_st("1");
            else if(br_id.equals("S4")) e_bean.setLoc_st("1");
            else if(br_id.equals("S5")) e_bean.setLoc_st("1");
            else if(br_id.equals("S6")) e_bean.setLoc_st("1");
            else if(br_id.equals("I1")) e_bean.setLoc_st("2");
            else if(br_id.equals("K3")) e_bean.setLoc_st("2");
            else if(br_id.equals("D1")) e_bean.setLoc_st("4");
            else if(br_id.equals("G1")) e_bean.setLoc_st("6");
            else if(br_id.equals("J1")) e_bean.setLoc_st("5");
            else if(br_id.equals("B1")) e_bean.setLoc_st("7");
            else if(br_id.equals("U1")) e_bean.setLoc_st("7");            
          }
        %>	
        
        document.form1.loc_st.value = <%=e_bean.getLoc_st()%>;
	}
	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
