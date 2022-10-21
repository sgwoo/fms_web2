<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String base_dt 		= request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");	
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String cng_st 		= request.getParameter("cng_st")==null?"-":request.getParameter("cng_st");
	String diesel_yn 	= request.getParameter("diesel_yn")==null?"-":request.getParameter("diesel_yn");
	String action_st 	= request.getParameter("action_st")==null?"":request.getParameter("action_st");
	
	
	String est_nm = "", a_a="", agree_dist="";
	
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();	
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	CarOfficeDatabase 	umd 	= CarOfficeDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	EstiJuyoDatabase 	ej_db 	= EstiJuyoDatabase.getInstance();
	
	
	
	//������
	e_bean = e_db.getEstimateHpCase(est_id);
	
	Vector vt = new Vector();
	if(!action_st.equals("h") && !action_st.equals("h_a")){
		//�𵨺� �����̷� ����Ʈ
		vt = ej_db.getJuyoCarHpCase_20150112(e_bean.getCar_id());	//36����		
	}
	
	//�ڵ���ȸ�� ����Ʈ
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	//���� ����Ʈ
	Vector cars = a_cmb.getSearchCode("00001", "", "", "", "8", "");
	int car_size = cars.size();
	
	//�ڵ� ����:�뿩��ǰ��
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); 
	int good_size = goods.length;
	
	String car_seq 	= e_bean.getCar_seq();
	int car_amt 	= e_bean.getCar_amt();
	int o_1 	= e_bean.getO_1();
	
	//���� ������ ������ �� �ֱ� ���׷��̵� ���� ��������
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), "");
	if(cng_st.equals("����")){
		car_seq = cm_bean.getCar_seq();
		car_amt = cm_bean.getCar_b_p();
		o_1 	= car_amt+e_bean.getOpt_amt()-e_bean.getDc_amt()-e_bean.getTax_dc_amt();
	}
	
	//��������
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//�Һз�
	String a_e = ej_bean.getJg_a();
	
	//������DC �ֱ�����
	CarDcBean cd_bean = a_cmb.getCarDcNewCase(cm_bean.getCar_comp_id(), cm_bean.getCode(), cm_bean.getCar_b_dt());	
	
	EstimateBean e_bean2 = e_db.getEstimateHpCase(est_id, "lb36_f");
	
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//��Ϻ���
	function go_list(){
		location='./main_car_frame.jsp?auth_rw=<%=auth_rw%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>&t_wd=<%=t_wd%>';
	}

	function estimate_reg_code(reg_code){
		location='/acar/estimate_mng/esti_mng_i_a_2_proc_20090901.jsp?from_page=main_car&cmd=test&est_id=00&est_code='+reg_code+'&action_st=<%=action_st%>';
	}
	
	function estimates_view(reg_code){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?reg_code="+reg_code;
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}
	
	
	//�ڵ���ȸ�� ���ý� �����ڵ� ����ϱ�
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '8';
		fm2.target="i_no";
		fm2.submit();
	}
	
	//���θ���Ʈ
	function sub_list(idx){
		var fm = document.form1;
		var SUBWIN="./esti_sub_list.jsp?idx="+idx+"&a_a=&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.car_nm.value;	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");
	}
	
	//�켱��������Ʈ
	function open_list(){
		var fm = document.form1;
		var SUBWIN='./main_car_order.jsp?auth_rw=<%=auth_rw%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>&t_wd=<%=t_wd%>';
		window.open(SUBWIN, "OrderList", "left=100, top=100, width=850, height=600, scrollbars=yes, status=yes");	
	}
		
	//�α����� ����Ʈ
	function open_hotcar(){
		var fm = document.form1;
		var SUBWIN='./main_car_hotcar.jsp?auth_rw=<%=auth_rw%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>&t_wd=<%=t_wd%>';
		window.open(SUBWIN, "OrderHotCar", "left=200, top=200, width=650, height=600, scrollbars=yes, status=yes");	
	}
	
	//�������
	function set_amt(){
		var fm = document.form1;
		fm.o_1.value 	= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));
		fm.o_12.value 	= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.dc_amt2.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));
	}
	
	//�����ݼ���
	function compare(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		var car_price 		= toInt(parseDigit(fm.o_1.value));
		var car_price2 		= toInt(parseDigit(fm.o_12.value));
		
		fm.rg_8.value 		= '20';
		fm.rg_82.value 		= '20';
		
		//20190516 ������ 20, ������ 25��  (�ֿ������� �״��, ������������� ������/�������� -10 ���� ����) 
		if(fm.jg_w.value == '1'){
			fm.rg_8.value 		= '25';
			fm.rg_8_2.value 	= '25';			
		}
		
		/*
		if(car_price <= 45000000){
			fm.rg_8.value 		= '20';
			fm.rg_8_2.value 	= '20';
		}		
		if(car_price2 <= 45000000){
			fm.rg_82.value 		= '20';
			fm.rg_8_22.value 	= '20';
		}
		*/
	/*	
    //�������� �⺻ �����ݿ��� 10% ���ش�
    if(fm.jg_g_7.value == '3'){
     	fm.rg_8.value     = toInt(fm.rg_8.value)-10;
     	fm.rg_8_2.value   = toInt(fm.rg_8_2.value)-10;
     	fm.rg_82.value    = toInt(fm.rg_82.value)-10;
     	fm.rg_8_22.value  = toInt(fm.rg_8_22.value)-10;
    }
    //�������� �⺻ �����ݿ��� 15% ���ش�
    if(fm.jg_g_7.value == '4'){
     	fm.rg_8.value     = toInt(fm.rg_8.value)-15;
     	fm.rg_8_2.value   = toInt(fm.rg_8_2.value)-15;
     	fm.rg_82.value    = toInt(fm.rg_82.value)-15;
     	fm.rg_8_22.value  = toInt(fm.rg_8_22.value)-15;
    }
    */

   	fm.rg_8_amt.value    = parseDecimal(car_price  * toFloat(fm.rg_8.value) /100 );
    fm.rg_8_amt_2.value  = parseDecimal(car_price  * toFloat(fm.rg_8_2.value) /100 );
    fm.rg_8_amt2.value   = parseDecimal(car_price2 * toFloat(fm.rg_82.value) /100 );
    fm.rg_8_amt_22.value = parseDecimal(car_price2 * toFloat(fm.rg_8_22.value) /100 );
		
	}
	
	//����
	function GetVar(){
		var fm = document.form1;
		fm.action = './get_var_null.jsp';
		fm.target = 'i_no';
		fm.submit();
	}		

	function estimate3(){
		var fm  = document.form3;		
		var link = document.getElementById("submitLink");
		link.setAttribute('href',"javascript:alert('��ü���� ���Դϴ�. ��ø� ��ٷ��ּ���');");
		
		set_amt();
		
		//������ ���� ������ ����
		compare(document.form1.rg_8);	
			
		fm.t_wd.value 			= document.form1.t_wd.value;
		fm.est_tel.value 		= document.form1.est_tel.value;
		fm.est_fax.value 		= document.form1.est_fax.value;
		fm.car_comp_id.value 		= document.form1.car_comp_id.value;
		fm.code.value 			= document.form1.code.value;
		fm.car_id.value 		= document.form1.car_id.value;
		fm.car_seq.value 		= document.form1.car_seq.value;
		fm.car_amt.value 		= document.form1.car_amt.value;
		fm.opt.value 				= document.form1.opt.value;
		fm.opt_seq.value 		= document.form1.opt_seq.value;
		fm.opt_amt.value 		= document.form1.opt_amt.value;
		
		fm.dc_seq.value 		= document.form1.dc_seq.value;
		fm.dc_amt.value 		= document.form1.dc_amt.value;
		fm.esti_d_etc.value = document.form1.esti_d_etc.value;
		
		fm.o_1.value 			= document.form1.o_1.value;		
		fm.a_e.value 			= document.form1.a_e.value;
		fm.spr_yn.value 		= document.form1.spr_yn.value;
		
		fm.rg_8.value 			= document.form1.rg_8.value;
		fm.rg_8_amt.value 		= document.form1.rg_8_amt.value;
		fm.rg_8_2.value 		= document.form1.rg_8_2.value;
		fm.rg_8_amt_2.value 	= document.form1.rg_8_amt_2.value;				
		
		fm.dc_amt2.value 		= document.form1.dc_amt2.value;
		fm.o_12.value 			= document.form1.o_12.value;
		fm.rg_82.value 			= document.form1.rg_82.value;
		fm.rg_8_amt2.value 		= document.form1.rg_8_amt2.value;
		fm.rg_8_22.value 		= document.form1.rg_8_22.value;
		fm.rg_8_amt_22.value 	= document.form1.rg_8_amt_22.value;
		
		fm.ls_yn.value			= document.form1.ls_yn.value;
		
		fm.jg_opt_st.value		= document.form1.jg_opt_st.value;			
		fm.jg_col_st.value		= document.form1.jg_col_st.value;		
		fm.jg_g_7.value			= document.form1.jg_g_7.value;			
		fm.ecar_loc_st.value	= document.form1.ecar_loc_st.value;			
		fm.tax_dc_amt.value 	= document.form1.tax_dc_amt.value;
		fm.conti_rat.value		= document.form1.conti_rat.value;
		fm.jg_tuix_st.value		= document.form1.jg_tuix_st.value;			
		fm.jg_tuix_opt_st.value		= document.form1.jg_tuix_opt_st.value;					
		fm.hcar_loc_st.value	= document.form1.hcar_loc_st.value;					
		fm.dc.value 		= document.form1.dc.value;
		fm.dc2.value 		= document.form1.dc2.value;
			
		fm.lkas_yn.value = document.form1.lkas_yn.value;
		fm.lkas_yn_opt_st.value = document.form1.lkas_yn_opt_st.value;
		fm.ldws_yn.value = document.form1.ldws_yn.value;
		fm.ldws_yn_opt_st.value = document.form1.ldws_yn_opt_st.value;
		fm.aeb_yn.value = document.form1.aeb_yn.value;
		fm.aeb_yn_opt_st.value = document.form1.aeb_yn_opt_st.value;
		fm.fcw_yn.value = document.form1.fcw_yn.value;
		fm.fcw_yn_opt_st.value = document.form1.fcw_yn_opt_st.value;		
		fm.hook_yn.value = document.form1.hook_yn.value;
		fm.hook_yn_opt_st.value = document.form1.hook_yn_opt_st.value;	
										
		
		
		var car_price 	= toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) ;
		var s_dc_amt 	= toInt(parseDigit(fm.dc_amt.value)) ;
		
		fm.r_o_1.value 		= 0;
		fm.r_dc_amt.value 	= 0;				
							
		if(fm.code.value 	== '')	{ alert('������ �����Ͻʽÿ�'); 	return; }
		if(fm.car_id.value 	== '')	{ alert('������ �����Ͻʽÿ�'); 	return; }
		if(fm.car_amt.value == '')	{ alert('�����ݾ��� Ȯ���Ͻʽÿ�'); return; }	
		
		if(fm.jg_g_7.value == '3'){ // ������
			var jgCode = '<%=cm_bean.getJg_code()%>';
			if(Number(jgCode) > 8000000){ // ����ȭ����
// 				fm.ecar_loc_st.value = '1';
				fm.ecar_loc_st.value = '0';	// ����ȭ���� ���ּ��� ���� ��õ ��Ͽ��� ���� ������� ����. 2022.01.13
			} else {
				fm.ecar_loc_st.value = '0';
			}
			
			if( jgCode == 4218111 || jgCode == 3313117 || jgCode == 5315114 || jgCode == 5315115 ){
				fm.ecar_loc_st.value = '13';
			}
			
		}
		if(fm.jg_g_7.value == '4') fm.hcar_loc_st.value = '0';
		
		
		
		fm.target = "i_no3";		
		
		
		
		fm.submit();
	}
	
	//�ֿ��������� �����Ѵ�. 
	function select_no(est_tel, car_id){
		var fm = document.form1;
		if(!confirm("�ش� �ֿ����� ���뿩�� ��������� �����Ͻðڽ��ϱ�?")) 	return;
		fm.action = "main_car_all_no.jsp?car_id="+car_id+"&est_tel="+est_tel;
		fm.target = 'i_no';
		fm.submit();
	}		
	
	//�������� ����
	function view_car_nm(car_id, car_seq){
		window.open("/acar/car_mst/car_mst_u.jsp?car_id="+car_id+"&car_seq="+car_seq, "VIEW_CAR_NM", "left=20, top=20, width=875, height=650, scrollbars=yes");		
	}
	
	//���Ҽ������ ����ϱ�
	function searchTaxDcAmt(){
    	var fm = document.form1;
    	
		var ch_327 = 0;
		var ch_315 = toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.dc_amt.value)) ;
		var ch_326 = ch_315/(1+<%=ej_bean.getJg_3()%>);
		var bk_122 = 0;
		<%if(!ej_bean.getJg_w().equals("1")){%>
		<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
		//if('<%=ej_bean.getJg_2()%>'=='1') ch_326 = ch_315; //�Ϲݽ¿�LPG�϶�
		if('<%=ej_bean.getJg_g_7()%>'=='1') bk_122 = 1300000;
		if('<%=ej_bean.getJg_g_7()%>'=='2') bk_122 = 1300000;
		if('<%=ej_bean.getJg_g_7()%>'=='3') bk_122 = 3900000;
		if('<%=ej_bean.getJg_g_7()%>'=='4') bk_122 = 5200000;
		if(ch_315-ch_326<bk_122*1.1) 	ch_327 = ch_315-ch_326;
		else                         	ch_327 = bk_122*1.1;
		ch_327 = getCutRoundNumber(ch_327,0);
		if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111')	ch_327 = 0;//��ƮEV
		if('<%=cm_bean.getJg_code()%>'=='9133' || '<%=cm_bean.getJg_code()%>'=='9015435'  || '<%=cm_bean.getJg_code()%>'=='9015436' || '<%=cm_bean.getJg_code()%>'=='9015437')	ch_327 = 0;//�����Ϸ�
		fm.tax_dc_amt.value    = parseDecimal(ch_327);
		set_amt();
		compare(document.form1.rg_8);
	  	<%	}%>
	  	<%}%>
	  
		//���Ҽ� �ѽ��� ���� 20200301~20200630 
	  	var bk_175 = 0.7;     //������
	  	var bk_176 = 1430000; //���Ҽ� ���� �ѵ�(����������,�ΰ�������)
	  	var bk_177 = 0;
	  	<%if(!ej_bean.getJg_w().equals("1")){ //����������%>
	  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//�鼼��ǥ������ ����%>
	  	<%		}else{%>
					if(ch_315<33471429){
						bk_177 = ch_326*<%=ej_bean.getJg_3()%>*bk_175;	
					}else{
						bk_177 = bk_176;
					}	              	
					bk_177 = getCutRoundNumber(bk_177,-4);		
					if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='5033111')	bk_177 = 0;//��ƮEV
	  	<%		}%>
	  	<%}%>
	  	//20200701 ��������
		bk_177 = 0;
	  	
		//���� ������ �����Һ�(�����ѵ� �ʰ��ݾ�) 20210101~20210630**********************
	  	var bk_216 = 0;
	  	<%if(!ej_bean.getJg_w().equals("1")){ //����������%>
	  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//�鼼��ǥ������ ����%>
	  	<%		}else{%>
					if(ch_315-ch_326>0 && ch_326/1.1 > 66666666){
						bk_216 = ((ch_326/1.1) - 66666666) * 0.0195 * 1.1;
					}	    					
					bk_216 = getCutRoundNumber(bk_216,-4);						
	  	<%		}%>
	  	<%}%>
	  	
		var ch327Nbk177 = ch_327;
	  	
	  	if(bk_177>0){
	  		if(ch_315-ch_326<bk_177+(bk_122*1.1)) 	ch327Nbk177 = ch_315-ch_326;
			else                         			ch327Nbk177 = bk_177+(bk_122*1.1);
	  		
			fm.tax_dc_amt.value    = parseDecimal(ch327Nbk177);
			set_amt();
			compare(document.form1.rg_8);
	  		
	  	}
	  	
	  	if(bk_216>0){
	  		if(ch_315-ch_326<-bk_216+(bk_122*1.1)) 	ch327Nbk177 = ch_315-ch_326;
			else                         			ch327Nbk177 = -bk_216+(bk_122*1.1);
	  		
	  		fm.tax_dc_amt.value    = parseDecimal(ch327Nbk177);
			set_amt();
			compare(document.form1.rg_8);
	  	}
	  	
	}
  
	//�ݿø�
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}  
//-->
</script>
</head>
<body leftmargin="15">
  <form action="../car_mst/car_mst_null.jsp" name="form2" method="post">
    <input type="hidden" name="sel" value="">
    <input type="hidden" name="car_comp_id" value="">
    <input type="hidden" name="code" value="">
    <input type="hidden" name="mode" value="">
    <input type="hidden" name="rent_way" value="">
    <input type="hidden" name="a_a" value="">
  </form>
  <form action="./esti_mng_i_a_1_20090901.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    
    
    
    
    
        
    
    
	<input type="hidden" name="base_dt" value="<%=base_dt%>">		
    <input type="hidden" name="cmd" value="">
    <input type="hidden" name="s_st" value="">
    <input type="hidden" name="a_e" value="<%= a_e %>">
    <input type="hidden" name="a_b" value="36">	
	<%if(ej_bean.getJg_2().equals("1")){%>
    <input type="hidden" name="est_st" value="4">	
	<%}else{%>
    <input type="hidden" name="est_st" value="0">	
	<%}%>
    <input type="hidden" name="r_o_1" value="">
    <input type="hidden" name="r_dc_amt" value="">	
    <input type="hidden" name="t_wd" value="<%=t_wd%>">	
    <input type="hidden" name="est_from" value="main_car">
    <input type="hidden" name="est_id" value="<%= est_id %>">
	<input type="hidden" name="jg_2" value="<%=ej_bean.getJg_2()%>">
	<input type="hidden" name="o_2" value="">		
	<input type="hidden" name="rg_8_2" value="">		
	<input type="hidden" name="rg_8_amt_2" value="">
			
	<input type="hidden" name="jg_opt_st" value="<%=e_bean.getJg_opt_st()%>">
	<input type="hidden" name="jg_col_st" value="<%=e_bean.getJg_col_st()%>">
	<input type="hidden" name="jg_g_7" value="<%=ej_bean.getJg_g_7()%>">
	<input type="hidden" name="jg_w" value="<%=ej_bean.getJg_w()%>">
	<input type="hidden" name="ecar_loc_st" value="<%=e_bean.getEcar_loc_st()%>">
	<input type="hidden" name="hcar_loc_st" value="<%=e_bean.getHcar_loc_st()%>">	
	<input type="hidden" name="jg_tuix_st" value="<%=e_bean.getJg_tuix_st()%>">
    <input type="hidden" name="jg_tuix_opt_st" value="<%=e_bean.getJg_tuix_opt_st()%>">	
    <input type="hidden" name="lkas_yn" value="<%=e_bean.getLkas_yn()%>">		<!-- ������Ż ������ (��������) -->
    <input type="hidden" name="lkas_yn_opt_st" value="<%=e_bean.getLkas_yn_opt_st()%>"><!-- ������Ż ������ (�ɼ�) -->
    <input type="hidden" name="ldws_yn" value="<%=e_bean.getLdws_yn()%>">		<!-- ������Ż ����� (��������) -->
    <input type="hidden" name="ldws_yn_opt_st" value="<%=e_bean.getLdws_yn_opt_st()%>"><!-- ������Ż ����� (�ɼ�) -->
    <input type="hidden" name="aeb_yn" value="<%=e_bean.getAeb_yn()%>">		<!-- ������� ������ (��������) -->
    <input type="hidden" name="aeb_yn_opt_st" value="<%=e_bean.getAeb_yn_opt_st()%>">	<!-- ������� ������ (�ɼ�) -->
    <input type="hidden" name="fcw_yn" value="<%=e_bean.getFcw_yn()%>">		<!-- ������� ����� (��������) -->
    <input type="hidden" name="fcw_yn_opt_st" value="<%=e_bean.getFcw_yn_opt_st()%>">	<!-- ������� ����� (�ɼ�) -->  
	<input type="hidden" name="hook_yn" value="<%=e_bean.getHook_yn()%>">		<!-- ���ΰ� (��������) -->
    <input type="hidden" name="hook_yn_opt_st" value="<%=e_bean.getHook_yn_opt_st()%>">	<!-- ���ΰ� (�ɼ�) -->  
        	

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > �ֿ��������� > <span class=style5>��������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%	int esti_chk = e_db.getMainCarCnt(e_bean.getEst_tel());
    	if(esti_chk != 180){ %>
    <tr>
        <td><font color=red>�� ��ȿ�� �ֿ����� ���� �������� <%=esti_chk%>�� �Դϴ�. �ٽ� �����Ͻʽÿ�.</font></td>
    </tr>
    <%} %>
    <tr> 
        <td align="right"><a href="javascript:go_list();"><img src=../images/center/button_list.gif align="absmiddle" border="0"></a>
	    </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>�켱����</td>
                    <td colspan="2">&nbsp;<input type="text" name="est_tel" value="<%= e_bean.getEst_tel() %>" size="6" class=num> 
                      <a href="javascript:open_list();"><img src=../images/center/button_in_list.gif border=0 align=absmiddle></a></td>
                </tr>
                <tr> 
                    <td class=title>�α�����</td>
                    <td colspan="2">&nbsp;<input type="text" name="est_fax" value="<%= e_bean.getEst_fax() %>" size="6" class=num> 
                      <a href="javascript:open_hotcar();"><img src=../images/center/button_in_list.gif border=0 align=absmiddle></a></td>
                </tr>				
                <tr> 
                    <td class=title>��ȣ��</td>
                    <td colspan="2">&nbsp;
                    
                    </td>
                </tr>				
                <tr> 
                    <td class=title>������</td>
                    <td colspan="2">&nbsp;<%= c_db.getNameById(e_bean.getCar_comp_id(), "CAR_COM") %>
        			<input type="hidden" name="car_comp_id" value="<%= e_bean.getCar_comp_id() %>"></td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="2">&nbsp;<%= c_db.getNameById(e_bean.getCar_comp_id()+e_bean.getCar_cd(), "CAR_MNG") %>
                    	&nbsp;(<%=cm_bean.getJg_code()%>), (<%=cm_bean.getS_st()%>, <%=ej_bean.getJg_6()%>, <%=cm_bean.getCar_comp_id()%>, <%=cm_bean.getCode()%>, <a href="javascript:view_car_nm('<%= e_bean.getCar_id() %>','<%=car_seq%>');"><%= e_bean.getCar_id() %>, <%=car_seq%></a>)
        			<input type="hidden" name="car_nm" value="<%= c_db.getNameById(e_bean.getCar_comp_id()+e_bean.getCar_cd(), "CAR_MNG") %>">
        			<input type="hidden" name="code" value="<%= e_bean.getCar_cd() %>"></td>
                </tr>
                <tr> 
                    <td class=title width=12%>����</td>
                    <td width=63%>&nbsp;<a href="javascript:sub_list('1');"><img src=../images/center/button_in_choice.gif border=0 align=absmiddle></a>
					  <input type="text" name="car_name" value="<%= c_db.getNameById(e_bean.getCar_id()+e_bean.getCar_seq(), "CAR_NM3") %>" size="87" class=text> 
                      <input type="hidden" name="car_id" value="<%= e_bean.getCar_id() %>"> <input type="hidden" name="car_seq" value="<%=car_seq%>"> 
                    </td>
                    <td align="center" width=25%> <input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(car_amt) %>" size="15" class=num>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ɼ�</td>
                    <td>&nbsp;<a href="javascript:sub_list('2');"><img src=../images/center/button_in_choice.gif border=0 align=absmiddle></a> 
        			<input type="text" name="opt" value="<%= e_bean.getOpt() %>" size="80" class=text>
        			 <input type="hidden" name="opt_seq" value="<%= e_bean.getOpt_seq() %>"> 			 
                    </td>
                    <td align="center"> <input type="text" name="opt_amt" value="<%= AddUtil.parseDecimal(e_bean.getOpt_amt()) %>" size="15" class=num>
                      ��</td>
                </tr>
                <tr>
                	<td class="title">����</td>
                	<td width=63%>&nbsp;<a href="javascript:sub_list('5');"><img src=../images/center/button_in_choice.gif border=0 align=absmiddle></a>
					  <input type="text" name="conti_rat" value="<%=e_bean.getConti_rat() %>" size="87" class=text> 
                      <input type="hidden" name="conti_rat_seq" value=""> 
                    </td>
                    <td></td>
                </tr>
                <tr> 
                    <td class=title>������DC-��Ʈ</td>
                    <td>&nbsp;<a href="javascript:sub_list('4');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
        			<input type="text" name="dc" value="<%= e_bean.getDc() %>" size="80" class=text>
					<input type="hidden" name="dc_seq" value="<%= e_bean.getDc_seq() %>">
					<input type="hidden" name="esti_d_etc" value="<%=e_bean.getEsti_d_etc()%>" size="200">
                    </td>
                    <td align="center"> -<input type="text" name="dc_amt" value="<%= AddUtil.parseDecimal(e_bean.getDc_amt()) %>" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>������DC-����</td>
                    <td>&nbsp;<input type="text" name="dc2" value="<%= e_bean2.getDc() %>" size="80" class=text>
                    </td>
                    <td align="center"> -<input type="text" name="dc_amt2" value="<%= AddUtil.parseDecimal(e_bean2.getDc_amt()) %>" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>���Ҽ� ����</td>
                    <td>&nbsp;�����Һ� �� ������ ���� (ģȯ����)</td>
                    <td align="center"> -<input type="text" name="tax_dc_amt" value="<%= AddUtil.parseDecimal(e_bean.getTax_dc_amt()) %>" size="15" class=num>
                      ��</td>
                </tr>
                
				<input type="hidden" name="o_12" value="<%=e_bean2.getO_1()%>">			
				<input type="hidden" name="rg_82" value="<%=e_bean2.getRg_8()%>">		
				<input type="hidden" name="rg_8_amt2" value="<%=e_bean2.getRg_8_amt()%>">	
				<input type="hidden" name="rg_8_22" value="<%=e_bean2.getRg_8()%>">		
				<input type="hidden" name="rg_8_amt_22" value="<%=e_bean2.getRg_8_amt()%>">
				<input type="hidden" name="ls_yn" value="<%=cd_bean.getLs_yn()%>">				
                <tr> 
                    <td class=title colspan="2">��������</td>
                    <td align="center"> <input type="text" name="o_1" value="<%= AddUtil.parseDecimal(o_1) %>" size="15" class=num>
                      ��</td>
                </tr>
                <tr>
                    <td class=title>������</td>
                    <td colspan="2">&nbsp;������ 
                      <input type="text" name="rg_8" class=num size="4" value="<%= e_bean.getRg_8() %>" onBlur="javascript:compare(this)">
                      %, ���뺸���ݾ� : 
                      <input type="text" name="rg_8_amt" class=num size="10" value="<%= AddUtil.parseDecimal(o_1*(e_bean.getRg_8()/100f)) %>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      ��<font color="#666666"> (�⺻�������� :
                      <input type="text" name="g_8" class=whitenum size="2" value="<%= e_bean.getRg_8() %>">
                      %) </font></td>
                </tr>
                <tr> 
                    <td class=title>���ſ뵵</td>
                    <td colspan="2">&nbsp;<input type="text" name="spr_yn" class=num size="2" value="2">
    			    <font color="#666666">(�Ϲݱ��:0, �췮���:1, <b>�ʿ췮���:2</b>, �ż�����:3)</font></td>
                </tr>
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan="2">&nbsp;�뿩�Ⱓ : 36���� / ��������: ����-0, ��Ʈ-0 / �뿩��D/C: ����-0, ��Ʈ-0</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;* ��Ʈ�� ������ 25,000,000�� �����϶��� ���������� 20%�̴�. * �������� 10% �����Ѵ�.</td>
    </tr>	
    <%if(cng_st.equals("����")){%>
    <tr> 
        <td>&nbsp;<font color=red>* ���� ������ �־� ������ �ֱ� ���׷��̵� ������ �����Խ��ϴ�. ����, �ɼ�, ������D/C�� ���� �����ϼ���.</font></td>
    </tr>	
    <%}%>
    <tr> 
        <td align=center><a id="submitLink" href="javascript:estimate3();"><img src=../images/center/button_p_allgj.gif border=0 align=absmiddle></a>
	    </td>
    </tr>
    <tr align="right"> 
        <td><a href="javascript:select_no('<%= e_bean.getEst_tel() %>','<%= e_bean.getCar_id() %>');"><img src=../images/center/button_nuse.gif border=0 align=absmiddle></td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
	<%if(!action_st.equals("h") && !action_st.equals("h_a")){%>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����̷�</span></td>
    </tr>
    
    <tr> 
        <td align=center>
            <table width=100% border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class="line">
                        <table width=100% border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td width="3%" rowspan="2" class="title" style="font-size : 12px;">����</td>
                                <td width="7%" rowspan="2" class="title" style="font-size : 12px;">��������</td>
                                <td width="7%" rowspan="2" class="title" style="font-size : 12px;">��������</td>
                                <td width="6%" rowspan="2" class="title" style="font-size : 12px;">�ɼǰ���</td>				  
				<td width="7%" rowspan="2" class="title" style="font-size : 12px;">������DC</td>				  
                                <td width="7%" rowspan="2" class="title" style="font-size : 12px;">��������</td>				  				  
                                <td width="7%" rowspan="2" class="title" style="font-size : 12px;">�ɼ�</td>				  				  
                                <td width="3%" rowspan="2" class="title" style="font-size : 12px;">�뿩<br>�Ⱓ</td>				  				                                  
                                <td width="5%" rowspan="2" class="title" style="font-size : 12px;">����</td>				  				                                  
                                <td colspan="2" class="title" style="font-size : 12px;">��ⷻƮ (���������) </td>				  
                                <td colspan="2" class="title" style="font-size : 12px;">���丮�� (���������) </td>
                                <td colspan="2" class="title" style="font-size : 12px;">���丮�� (����������) </td>
                             </tr>
                            <tr>
                              <td width="8%" class="title" style="font-size : 12px;">�⺻��</td>
                              <td width="8%" class="title" style="font-size : 12px;">�Ϲݽ�</td>
                              <td width="8%" class="title" style="font-size : 12px;">�⺻��</td>
                              <td width="8%" class="title" style="font-size : 12px;">�Ϲݽ�</td>
                              <td width="8%" class="title" style="font-size : 12px;">�⺻��</td>
                              <td width="8%" class="title" style="font-size : 12px;">�Ϲݽ�</td>
                            </tr>
		<% 	if(vt.size()>0){
				for(int i=0; i<vt.size(); i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					Hashtable ht2 = ej_db.getJuyoCarHpCaseList_20150112(String.valueOf(ht.get("REG_CODE")));
					%>				
                            <tr> 
                                <td align="center" style="font-size : 12px;" rowspan='9'><a href="javascript:estimates_view('<%=ht.get("REG_CODE")%>');"><%=i+1%></a></td>
                                <td align="center" style="font-size : 12px;" rowspan='9'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                                <td align="right"  style="font-size : 12px;" rowspan='9'><%=AddUtil.parseDecimal((String)ht.get("CAR_AMT"))%>&nbsp;</td>
                                <td align="right"  style="font-size : 12px;" rowspan='9'><%=AddUtil.parseDecimal((String)ht.get("OPT_AMT"))%>&nbsp;</td>
                                <td align="right"  style="font-size : 12px;" rowspan='9'>
                                	��Ʈ <%=AddUtil.parseDecimal((String)ht.get("DC_AMT_2"))%>
                                	<br><%=ht.get("DC_2")%>
                                	<br>&nbsp;<br>
                                	���� <%=AddUtil.parseDecimal((String)ht.get("DC_AMT_1"))%>
                                	<br><%=ht.get("DC_1")%>
                                </td>	
                                <td align="right"  style="font-size : 12px;" rowspan='9'><%=AddUtil.parseDecimal((String)ht.get("O_1"))%>&nbsp;</td>
                                <td align="center" style="font-size : 12px;" rowspan='9'><%=ht.get("OPT")%><br>(��������Ÿ�:<%=ht.get("AGREE_DIST")%>)</td>				  
                                <td align="center" style="font-size : 12px;" rowspan='3'>60</td>				  				  
                                <td align="right"  style="font-size : 12px;">���Կɼ�</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("RB60_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("RS60_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LB60_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LS60_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LB602_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LS602_RO_13")%>%</td>
                            </tr>
                            <tr> 
                                <td align="center" style="font-size : 12px;">���ް�</td>				  				  
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("RB60_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("RS60_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LB60_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LS60_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LB602_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LS602_AMT")))%></td>
                            </tr>     
                            <tr> 
                                <td align="center" style="font-size : 12px;" class='is'>������</td>				  				  
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("RB60_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("RS60_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LB60_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LS60_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LB602_CLS_PER")%>%</td>				  				                                  
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LS602_CLS_PER")%>%</td>
                            </tr>                                                     
                            <tr> 
                                <td align="center" style="font-size : 12px;" rowspan='3'>48</td>				  				  
                                <td align="right"  style="font-size : 12px;">���Կɼ�</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("RB48_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("RS48_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LB48_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LS48_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LB482_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LS482_RO_13")%>%</td>
                            </tr>
                            <tr> 
                                <td align="center" style="font-size : 12px;">���ް�</td>				  				  
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("RB48_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("RS48_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LB48_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LS48_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LB482_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LS482_AMT")))%></td>
                            </tr>     
                            <tr> 
                                <td align="center" style="font-size : 12px;" class='is'>������</td>				  				  
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("RB48_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("RS48_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LB48_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LS48_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LB482_CLS_PER")%>%</td>				  				                                  
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LS482_CLS_PER")%>%</td>
                            </tr>                             
                            <tr> 
                                <td align="center" style="font-size : 12px;" rowspan='3'>36</td>				  				  
                                <td align="right"  style="font-size : 12px;">���Կɼ�</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("RB36_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("RS36_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LB36_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LS36_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LB362_RO_13")%>%</td>
                                <td align="right"  style="font-size : 12px;"><%=ht2.get("LS362_RO_13")%>%</td>
                            </tr>
                            <tr> 
                                <td align="center" style="font-size : 12px;">���ް�</td>				  				  
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("RB36_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("RS36_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LB36_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LS36_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LB362_AMT")))%></td>
                                <td align="right"  style="font-size : 12px;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("LS362_AMT")))%></td>
                            </tr>     
                            <tr> 
                                <td align="center" style="font-size : 12px;" class='is'>������</td>				  				  
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("RB36_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("RS36_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LB36_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LS36_CLS_PER")%>%</td>
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LB362_CLS_PER")%>%</td>				  				                                  
                                <td align="right"  style="font-size : 12px;" class='is'><%=ht2.get("LS362_CLS_PER")%>%</td>
                            </tr>                                                                          
		<%	}
		 }%>				 
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
	<%}%>
    <tr> 
        <td align=center>&nbsp; </td>
    </tr>	
</table>
</form>

<form name="form3" method="post" action="./esti_mng_i_a_1_20090901.jsp">
	<input type="hidden" name="reg_dt" value="<%=Util.getLoginTime()%>">
	<input type="hidden" name="action_st" value="<%=action_st%>">	
	<input type="hidden" name="t_wd" value="<%=t_wd%>">
	<!--������-->
	<input type="hidden" name="est_nm" value="">
	<input type="hidden" name="est_tel" value="">
	<input type="hidden" name="est_ssn" value="Y">	
	<input type="hidden" name="est_fax" value="">
	<!--�ſ뵵 :�ʿ췮��� 2 -> �Ϲݱ�� 0���� ����-> �췮��� 1�� ����-> �ʿ췮��� 2�� ����-> �췮��� 1�� ���� -> �ʿ췮��� 2�� ����->--> 
	<input type="hidden" name="spr_yn" value="2">
	<!--�뿩��ǰ-->
	<input type="hidden" name="a_a" value="">
	<!--�뿩�Ⱓ :36����-->
	<input type="hidden" name="a_b" value="36">
	<!--��������-->
	<input type="hidden" name="car_comp_id" value="">
	<input type="hidden" name="code" value="">
	<input type="hidden" name="car_id" value="">
	<input type="hidden" name="car_seq" value="">
	<input type="hidden" name="car_amt" value="">
	<input type="hidden" name="opt" value="">
	<input type="hidden" name="opt_seq" value="">
	<input type="hidden" name="opt_amt" value="">
	<input type="hidden" name="col_seq" value="">
	<input type="hidden" name="col_amt" value="">		
	<input type="hidden" name="dc_seq" value="">
	<input type="hidden" name="dc_amt" value="">
	<input type="hidden" name="esti_d_etc" value="">
	<input type="hidden" name="dc_amt2" value="">	
	<input type="hidden" name="o_1" value="">
	<input type="hidden" name="dc" value="">	
	<input type="hidden" name="dc2" value="">
	
	<!--LPG��������:������-->
	<input type="hidden" name="lpg_yn" value="0">
	<!--������:20% -> 25% -> 20190516 ������ 20%,����25% -->
	<input type="hidden" name="rg_8" value="20">
	<input type="hidden" name="rg_8_amt" value="">
	<input type="hidden" name="g_8" value="20">
	<!--���ô뿩��:0����-->
	<input type="hidden" name="pp_st" value="1">
	<input type="hidden" name="g_10" value="0">
	<!--�������:����-->
	<input type="hidden" name="udt_st" value="1">
	<input type="hidden" name="a_h" value="7">

	<!--����(�빰/�ڼ�):1��-->
	<input type="hidden" name="ins_dj" value="2">
	<!--����(���Կ���):26���̻�-->
	<input type="hidden" name="ins_age" value="1">
	<!--��������:����-->	
	<input type="hidden" name="gi_yn" value="0">
	<!--������å��-->
	<input type="hidden" name="car_ja" value="300000">
	<!--�����ܰ���-->
	<input type="hidden" name="ro_13" value="">
	<input type="hidden" name="o_13" value="">
	<input type="hidden" name="ro_13_amt" value="">
	<input type="hidden" name="ro_13" value="">
	<input type="hidden" name="o_13" value="">
	<input type="hidden" name="ro_13_amt" value="">
	<!--�Һз�-->
	<input type="hidden" name="a_e" value="">	
	<!--��������-->
	<input type="hidden" name="o_11" value="0">	
	<!--�뿩��D/C-->
	<input type="hidden" name="fee_dc_per" value="0">
   	<input type="hidden" name="r_o_1" value="">
   	<input type="hidden" name="r_dc_amt" value="">		
	<input type="hidden" name="rg_8_2" value="">		
	<input type="hidden" name="rg_8_amt_2" value="">	
	<input type="hidden" name="o_12" value="0">			
	<input type="hidden" name="rg_82" value="">		
	<input type="hidden" name="rg_8_amt2" value="">	
	<input type="hidden" name="rg_8_22" value="">		
	<input type="hidden" name="rg_8_amt_22" value="">
	<input type="hidden" name="ls_yn" value="">
	
	<input type="hidden" name="from_page" value="/acar/main_car/main_car_upd_20090901.jsp">
	<input type="hidden" name="jg_opt_st" value="<%=e_bean.getJg_opt_st()%>">
	<input type="hidden" name="jg_col_st" value="<%=e_bean.getJg_col_st()%>">
	<input type="hidden" name="jg_g_7" value="<%=ej_bean.getJg_g_7()%>">
	<input type="hidden" name="ecar_loc_st" value="<%=e_bean.getEcar_loc_st()%>">
	<input type="hidden" name="hcar_loc_st" value="<%=e_bean.getHcar_loc_st()%>">
	<input type="hidden" name="tax_dc_amt" value="<%=e_bean.getTax_dc_amt()%>">
	<input type="hidden" name="conti_rat" value="<%=e_bean.getConti_rat()%>">
	<input type="hidden" name="jg_tuix_st" value="<%=e_bean.getJg_tuix_st()%>">
    <input type="hidden" name="jg_tuix_opt_st" value="<%=e_bean.getJg_tuix_opt_st()%>">
    <input type="hidden" name="lkas_yn" value="<%=e_bean.getLkas_yn()%>">		<!-- ������Ż ������ (��������) -->
    <input type="hidden" name="lkas_yn_opt_st" value="<%=e_bean.getLkas_yn_opt_st()%>"><!-- ������Ż ������ (�ɼ�) -->
    <input type="hidden" name="ldws_yn" value="<%=e_bean.getLdws_yn()%>">		<!-- ������Ż ����� (��������) -->
    <input type="hidden" name="ldws_yn_opt_st" value="<%=e_bean.getLdws_yn_opt_st()%>"><!-- ������Ż ����� (�ɼ�) -->
    <input type="hidden" name="aeb_yn" value="<%=e_bean.getAeb_yn()%>">		<!-- ������� ������ (��������) -->
    <input type="hidden" name="aeb_yn_opt_st" value="<%=e_bean.getAeb_yn_opt_st()%>">	<!-- ������� ������ (�ɼ�) -->
    <input type="hidden" name="fcw_yn" value="<%=e_bean.getFcw_yn()%>">		<!-- ������� ����� (��������) -->
    <input type="hidden" name="fcw_yn_opt_st" value="<%=e_bean.getFcw_yn_opt_st()%>">	<!-- ������� ����� (�ɼ�) -->
	<input type="hidden" name="hook_yn" value="<%=e_bean.getHook_yn()%>">		<!-- ���ΰ� (��������) -->
    <input type="hidden" name="hook_yn_opt_st" value="<%=e_bean.getHook_yn_opt_st()%>">	<!-- ���ΰ� (�ɼ�) -->
</form>


<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>

<iframe src="about:blank" name="i_no3" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>

<script language="JavaScript">
<!--
	setOptChk();
	
	searchTaxDcAmt();
	
	function setOptChk(){
		var fm = document.form1;
		if(fm.car_nm.value.indexOf("A/T") != -1 && fm.opt.value.indexOf("���ӱ�") != -1 ){
			alert("A/T�����ε� �ɼǿ� ���ӱⰡ �ֽ��ϴ�. Ȯ���Ͻʽÿ�.");
		}
	}
	
	
	function setDcCode(){
		var fm = document.form1;				
		var dc_amt 	= 0;
		var dc_amt2 	= 0;
		var car_price 	= toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) ;
		
		dc_amt 		= (car_price*<%=cd_bean.getCar_d_per()%>/100)+<%=cd_bean.getCar_d_p()%>;
		
		if('<%=cd_bean.getCar_d_per_b()%>' == '2'){
			dc_amt 	= ((car_price-<%=cd_bean.getCar_d_p()%>)*<%=cd_bean.getCar_d_per()%>/100)+<%=cd_bean.getCar_d_p()%>;
		}
		
		if('<%=cd_bean.getLs_yn()%>' == 'Y'){
			dc_amt2 = (car_price*<%=cd_bean.getCar_d_per2()%>/100)+<%=cd_bean.getCar_d_p2()%>;
			if('<%=cd_bean.getCar_d_per_b2()%>' == '2'){
				dc_amt2 	= ((car_price-<%=cd_bean.getCar_d_p2()%>)*<%=cd_bean.getCar_d_per2()%>/100)+<%=cd_bean.getCar_d_p2()%>;
			}
		}else{
			dc_amt2 = dc_amt;
		}
		
		fm.dc.value 		= '';		
		fm.dc_seq.value 	= '<%=cd_bean.getCar_u_seq()+""+cd_bean.getCar_d_seq()%>';
		fm.dc_amt.value 	= parseDecimal(dc_amt);
		fm.esti_d_etc.value 	= '<%=cd_bean.getEsti_d_etc()%>';
		fm.o_1.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));
		fm.dc_amt2.value 	= parseDecimal(dc_amt2);
		fm.ls_yn.value 		= '<%=cd_bean.getLs_yn()%>';		
		fm.o_12.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.dc_amt2.value)));
		
	}	


	<%if(action_st.equals("h") || action_st.equals("h_a")){%>
	estimate3();
	<%}%>
	<%if(action_st.equals("r") || action_st.equals("r_a")){%>
	estimate_reg_code('<%=e_bean.getReg_code()%>');
	<%}%>	
//-->
</script>
</body>
</html>