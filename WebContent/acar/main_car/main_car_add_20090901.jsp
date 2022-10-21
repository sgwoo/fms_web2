<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String base_dt 		= request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");	
	
	String cng_st 		= request.getParameter("cng_st")==null?"-":request.getParameter("cng_st");
	String diesel_yn 	= request.getParameter("diesel_yn")==null?"-":request.getParameter("diesel_yn");

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	e_bean = e_db.getEstimateCase(est_id);
	
	//�ڵ���ȸ�� ����Ʈ
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	//��������Ʈ-����Ʈ=>�����ڵ���
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	Vector cars = a_cmb.getSearchCode("00001", "", "", "", "8", "");
	int car_size = cars.size();		
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* �ڵ� ����:�뿩��ǰ�� */
	int good_size = goods.length;
	
	String est_nm = "", a_a="";
	
	//CAR_NM : ��������
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());
	
	//�߰����ܰ�����
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
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
		location='./main_car_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>';
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
		
		fm.rg_8.value = '20';
		fm.rg_82.value = '20';
		
		//20190516 ������ 20, ������ 25�� (�ֿ������� �״��, ������������� ������/�������� -10 ���� ����) 
		if(toInt(fm.car_comp_id.value) > 5){
			fm.rg_8.value = '25';
			fm.rg_8_2.value = '25';			
		}
	}
	
	//���θ���Ʈ
	function sub_list(idx){
		var fm = document.form1;
		if(fm.code.value == ''){ alert('������ �����Ͻʽÿ�.'); return;}
		var SUBWIN="./esti_sub_list.jsp?idx="+idx+"&a_a=&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text;	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");
	}
	//�켱��������Ʈ
	function open_list(){
		var fm = document.form1;
		var SUBWIN='./main_car_order.jsp?auth_rw=<%=auth_rw%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>';
		window.open(SUBWIN, "OrderList", "left=100, top=100, width=650, height=600, scrollbars=yes, status=yes");	
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
		
	
	//����
	function GetVar(){
		var fm = document.form1;
		fm.action = './get_var_null.jsp';
		fm.target = 'i_no';
		fm.submit();
	}		

	
	//��������
	function EstiReg(){
		var fm = document.form1;
		if(fm.code.value == ''){ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_id.value == ''){ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_amt.value == ''){ alert('�����ݾ��� Ȯ���Ͻʽÿ�'); return; }				
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return; }
		fm.cmd.value = "i";
		fm.action = 'esti_mng_i_a_1.jsp';
		estimate2();
	}

	//�����ݼ���
	function compare(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		var car_price 		= toInt(parseDigit(fm.o_1.value));
		var car_price2 		= toInt(parseDigit(fm.o_12.value));
		
		fm.rg_8.value = '20';
		fm.rg_82.value 		= '20';
		
		//20190516 ������ 20, ������ 25�� (�ֿ������� �״��, ������������� ������/�������� -10 ���� ����) 
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
		
	function estimate3(){
		var fm  = document.form3;
		
		set_amt();
		
		//������ ���� ������ ����
		compare(document.form1.rg_8);	
				
		fm.est_tel.value 		= document.form1.est_tel.value;
		fm.est_fax.value 		= document.form1.est_fax.value;
		fm.car_comp_id.value 		= document.form1.car_comp_id.value;
		fm.code.value 			= document.form1.code.value;
		fm.car_id.value 		= document.form1.car_id.value;
		fm.car_seq.value 		= document.form1.car_seq.value;
		fm.car_amt.value 		= document.form1.car_amt.value;
		fm.opt.value 			= document.form1.opt.value;		
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
		fm.rg_8_amt_2.value 		= document.form1.rg_8_amt_2.value;				
						
		fm.dc_amt2.value 		= document.form1.dc_amt2.value;
		fm.o_12.value 			= document.form1.o_12.value;
		fm.rg_82.value 			= document.form1.rg_82.value;
		fm.rg_8_amt2.value 		= document.form1.rg_8_amt2.value;
		fm.rg_8_22.value 		= document.form1.rg_8_22.value;
		fm.rg_8_amt_22.value 		= document.form1.rg_8_amt_22.value;
		
		fm.ls_yn.value			= document.form1.ls_yn.value;
		
		fm.jg_opt_st.value		= document.form1.jg_opt_st.value;			
		fm.jg_col_st.value		= document.form1.jg_col_st.value;			
		fm.jg_g_7.value		= document.form1.jg_g_7.value;			
		fm.ecar_loc_st.value		= document.form1.ecar_loc_st.value;			
		fm.tax_dc_amt.value 			= document.form1.tax_dc_amt.value;
		fm.conti_rat.value		= document.form1.conti_rat.value;
		fm.jg_tuix_st.value		= document.form1.jg_tuix_st.value;			
		fm.jg_tuix_opt_st.value		= document.form1.jg_tuix_opt_st.value;			
		fm.hcar_loc_st.value		= document.form1.hcar_loc_st.value;					
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
						
		set_car_ext3();
		
		var car_price 	= toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) ;
		var s_dc_amt 	= toInt(parseDigit(fm.dc_amt.value)) ;
		
		fm.r_o_1.value 		= 0;
		fm.r_dc_amt.value 	= 0;
		
		if(fm.code.value == '')		{ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_id.value == '')	{ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_amt.value == '')	{ alert('�����ݾ��� Ȯ���Ͻʽÿ�'); return; }
		
		if(fm.jg_g_7.value == '3') fm.ecar_loc_st.value = '0';
		if(fm.jg_g_7.value == '4') fm.hcar_loc_st.value = '0';

		
		
		fm.target = "i_no3";



		fm.submit();
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
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="base_dt" value="<%=base_dt%>">		
    <input type="hidden" name="cmd" value="">
    <input type="hidden" name="s_st" value="">
    <input type="hidden" name="a_e" value="">
	<input type="hidden" name="a_b" value="36">
	
	<input type="hidden" name="est_st" value="0">
	
	
	
	<input type="hidden" name="r_o_1" value="">
    <input type="hidden" name="r_dc_amt" value="">	
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
	<input type="hidden" name="est_from" value="main_car">
		
	<input type="hidden" name="jg_2" value="">
	<input type="hidden" name="o_2" value="">	
	<input type="hidden" name="rg_8_2" value="">		
	<input type="hidden" name="rg_8_amt_2" value="">				
	<input type="hidden" name="from_page" value="/acar/main_car/main_car_add_20090901.jsp">	
	<input type="hidden" name="jg_opt_st" value="">						
	<input type="hidden" name="jg_col_st" value="">		
	<input type="hidden" name="jg_g_7" value="<%=ej_bean.getJg_g_7()%>">
	<input type="hidden" name="jg_w" value="<%=ej_bean.getJg_w()%>">
	<input type="hidden" name="ecar_loc_st" value="">											
	<input type="hidden" name="hcar_loc_st" value="">											
    <input type="hidden" name="jg_tuix_st" value="">
    <input type="hidden" name="jg_tuix_opt_st" value="">	
    <input type="hidden" name="lkas_yn" value="">		<!-- ������Ż ������ (��������) -->
    <input type="hidden" name="lkas_yn_opt_st" value=""><!-- ������Ż ������ (�ɼ�) -->
    <input type="hidden" name="ldws_yn" value="">		<!-- ������Ż ����� (��������) -->
    <input type="hidden" name="ldws_yn_opt_st" value=""><!-- ������Ż ����� (�ɼ�) -->
    <input type="hidden" name="aeb_yn" value="">		<!-- ������� ������ (��������) -->
    <input type="hidden" name="aeb_yn_opt_st" value="">	<!-- ������� ������ (�ɼ�) -->
    <input type="hidden" name="fcw_yn" value="">		<!-- ������� ����� (��������) -->
    <input type="hidden" name="fcw_yn_opt_st" value="">	<!-- ������� ����� (�ɼ�) -->  	
	<input type="hidden" name="hook_yn" value="">		<!-- ���ΰ� (��������) -->
    <input type="hidden" name="hook_yn_opt_st" value="">	<!-- ���ΰ� (�ɼ�) -->  

	

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > �������� > �ֿ��������� > <span class=style5>��������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
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
                    <td colspan="2">&nbsp;<input type="text" name="est_tel" value="" size="6" class=num> 
                      &nbsp;<a href="javascript:open_list();"><img src=../images/center/button_in_list.gif border=0 align=absmiddle></a></td>
                </tr>
                <tr> 
                    <td class=title>�α�����</td>
                    <td colspan="2">&nbsp;<input type="text" name="est_fax" value="" size="6" class=num> 
                      <a href="javascript:open_hotcar();"><img src=../images/center/button_in_list.gif border=0 align=absmiddle></a></td>
                </tr>	
                <tr> 
                    <td class=title>��ȣ��</td>
                    <td colspan="2">&nbsp;
                    
                    </td>
                </tr>		
                <tr> 
                    <td class=title>������</td>
                    <td colspan="2">&nbsp;<select name="car_comp_id" onChange="javascript:GetCarCode()">
                        <option value="">==��ü==</option>
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="2">&nbsp;<select name="code">
                        <option value="">����</option>
                        <%for(int i = 0 ; i < car_size ; i++){
        					Hashtable car = (Hashtable)cars.elementAt(i);%>
                        <option value="<%=car.get("CODE")%>"><%=car.get("CAR_NM")%></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title width=12%>����</td>
                    <td width=63%>&nbsp;<a href="javascript:sub_list('1');"><img src=../images/center/button_in_choice.gif border=0 align=absmiddle></a> 
                      <input type="text" name="car_name" value="" size="75" class=text> 
                      <input type="hidden" name="car_id" value=""> <input type="hidden" name="car_seq" value=""> 
                    </td>
                    <td width=25% align="center">&nbsp;<input type="text" name="car_amt" value="" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt(); compare(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ɼ�</td>
                    <td>&nbsp;<a href="javascript:sub_list('2');"><img src=../images/center/button_in_choice.gif border=0 align=absmiddle></a> 
                      <input type="text" name="opt" value="" size="75" class=text> <input type="hidden" name="opt_seq" value=""> 
                    </td>
                    <td align="center"> <input type="text" name="opt_amt" value="" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt(); compare(this);'>
                      ��</td>
                </tr>
                <tr>
                	<td class="title">����</td>
                	<td>&nbsp;<a href="javascript:sub_list('5');"><img src=../images/center/button_in_choice.gif border=0 align=absmiddle></a> 
                      <input type="text" name="conti_rat" value="" size="75" class=text> <input type="hidden" name="conti_rat_seq" value="">
                    </td>
                    <td></td>
                </tr>
                <tr> 
                    <td class=title>������DC</td>
                    <td>&nbsp;<a href="javascript:sub_list('4');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
        			<input type="text" name="dc" value="" size="80" class=text>
					<input type="hidden" name="dc_seq" value="">
					<input type="hidden" name="esti_d_etc" value="" size="200">
                    </td>
                    <td align="center"> -<input type="text" name="dc_amt" value="" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt(); compare(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>���Ҽ� ����</td>
                    <td>&nbsp;�����Һ� �� ������ ���� (ģȯ����)</td>
                    <td align="center"> -<input type="text" name="tax_dc_amt" value="<%= AddUtil.parseDecimal(e_bean.getTax_dc_amt()) %>" size="15" class=num>
                      ��</td>
                </tr>                
				<input type="hidden" name="dc2" value="">
				<input type="hidden" name="dc_amt2" value="0">
				<input type="hidden" name="o_12" value="0">			
				<input type="hidden" name="rg_82" value="">		
				<input type="hidden" name="rg_8_amt2" value="">	
				<input type="hidden" name="rg_8_22" value="">		
				<input type="hidden" name="rg_8_amt_22" value="">
				<input type="hidden" name="ls_yn" value="">				
                <tr> 
                    <td class=title colspan="2">��������</td>
                    <td align="center">&nbsp;<input type="text" name="o_1" value="" size="15" class=num>
                      ��</td>
                </tr>
                <tr>
                    <td class=title>������</td>
                    <td colspan="2">&nbsp;������ 
                      <input type="text" name="rg_8" class=num size="4" value="20" onBlur="javascript:compare(this)">
                      %, ���뺸���ݾ� 
                      <input type="text" name="rg_8_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      ��<font color="#666666"> (�⺻�������� 
                      <input type="text" name="g_8" class=whitenum size="2" value="20">
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
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td align=center><a href="javascript:estimate3();"><img src=../images/center/button_p_allgj.gif border=0 align=absmiddle></a>
	    </td>
    </tr>
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td align=center>&nbsp; </td>
    </tr>
</table>
</form>


<form name="form3" method="post" action="./esti_mng_i_a_1_20090901.jsp">
	<input type="hidden" name="reg_dt" value="<%=Util.getLoginTime()%>">
	
	<!--������-->
	<input type="hidden" name="est_nm" value="">
	<input type="hidden" name="est_tel" value="">
	<input type="hidden" name="est_ssn" value="Y">	
	<input type="hidden" name="est_fax" value="">
	<!--�ſ뵵 :�ʿ췮��� 2 -> �Ϲݱ�� 0���� ����-> �췮��� 1�� ����-> �ʿ췮��� 2�� ����-> �췮��� 1�� ����-> �ʿ췮��� 2�� ����-->
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
																
	<input type="hidden" name="from_page" value="/acar/main_car/main_car_add_20090901.jsp">
	<input type="hidden" name="jg_opt_st" value="">											
	<input type="hidden" name="jg_col_st" value="">											
	<input type="hidden" name="jg_g_7" value="<%=ej_bean.getJg_g_7()%>">
	<input type="hidden" name="ecar_loc_st" value="">											
	<input type="hidden" name="hcar_loc_st" value="">											
	<input type="hidden" name="tax_dc_amt" value="">
	<input type="hidden" name="conti_rat" value="">
	<input type="hidden" name="jg_tuix_st" value="">
    <input type="hidden" name="jg_tuix_opt_st" value="">
    <input type="hidden" name="lkas_yn" value="">		<!-- ������Ż ������ (��������) -->
    <input type="hidden" name="lkas_yn_opt_st" value=""><!-- ������Ż ������ (�ɼ�) -->
    <input type="hidden" name="ldws_yn" value="">		<!-- ������Ż ����� (��������) -->
    <input type="hidden" name="ldws_yn_opt_st" value=""><!-- ������Ż ����� (�ɼ�) -->
    <input type="hidden" name="aeb_yn" value="">		<!-- ������� ������ (��������) -->
    <input type="hidden" name="aeb_yn_opt_st" value="">	<!-- ������� ������ (�ɼ�) -->
    <input type="hidden" name="fcw_yn" value="">		<!-- ������� ����� (��������) -->
    <input type="hidden" name="fcw_yn_opt_st" value="">	<!-- ������� ����� (�ɼ�) -->			
	<input type="hidden" name="hook_yn" value="">		<!-- ���ΰ� (��������) -->
    <input type="hidden" name="hook_yn_opt_st" value="">	<!-- ���ΰ� (�ɼ�) -->	
</form>



<script language="JavaScript">
<!--
	function set_car_ext3(){
		var fm1 = document.form1;
		var fm3 = document.form3;
		
		var a_e = toInt(fm1.a_e.value);
		
		//��õ�������-����
		var udt_st = 1;
		var a_h = 1;
		var a_a = fm3.a_a.value;
		var au28 = 0;
		var av28 = 0;
		if(a_e == 402 || a_e == 501 || a_e == 502 || a_e == 601 || a_e == 602) au28 = 1;
		if(a_e == 104 || a_e == 105 || a_e == 106 || a_e == 107 || a_e == 201) av28 = 1;
		if(a_a=='11' || a_a=='12'){//����	
			a_h = 4;
		}else{//��Ʈ
			a_h = 2;
		}
		fm3.a_h.value = a_h;
	}
//-->
</script>

<iframe src="about:blank" name="i_no" width="100%" height="200" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>

<iframe src="about:blank" name="i_no3" width="900" height="110" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>

</body>
</html>