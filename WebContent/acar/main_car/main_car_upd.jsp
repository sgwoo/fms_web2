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
	
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String cng_st 		= request.getParameter("cng_st")==null?"-":request.getParameter("cng_st");
	String diesel_yn 	= request.getParameter("diesel_yn")==null?"-":request.getParameter("diesel_yn");
	
	EstiDatabase e_db = EstiDatabase.getInstance();
//	e_bean = e_db.getEstimateCase(est_id);
	e_bean = e_db.getEstimateHpCase(est_id);
	
//	System.out.println("e_bean.getCar_id()+e_bean.getCar_seq()="+e_bean.getCar_id()+" "+e_bean.getCar_seq());
	
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
	
	//�Һз� üũ�ؼ� �̿�Ұ� ���� �뿩�� -1�� ���.
	//�Һз��� ������..
	String a_e = e_db.getA_e(e_bean.getCar_comp_id(), e_bean.getCar_cd(), e_bean.getCar_id(), e_bean.getCar_seq());
	
	String est_nm = "", a_a="", agree_dist="";
	
	//�𵨺� �������� ����Ʈ
	EstiJuyoDatabase ej_db = EstiJuyoDatabase.getInstance();
	//Vector vt = ej_db.getJuyoCarCase(e_bean.getCar_id());
	Vector vt = ej_db.getJuyoCarHpCase(e_bean.getCar_id());
	
	String car_seq 	= e_bean.getCar_seq();
	int car_amt 	= e_bean.getCar_amt();
	int o_1 		= e_bean.getO_1();
	
	//���� ������ ������ �� �ֱ� ���׷��̵� ���� ��������
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), "");
	if(cng_st.equals("����")){
		car_seq = cm_bean.getCar_seq();
		car_amt = cm_bean.getCar_b_p();
		o_1 	= car_amt+e_bean.getOpt_amt();
	}
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
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
		location='./main_car_frame.jsp?auth_rw=<%=auth_rw%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>';
	}

	//�ڵ���ȸ�� ���ý� �����ڵ� ����ϱ�
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		//var a_a = fm.a_a.options[fm.a_a.selectedIndex].value;		
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '8';
		//fm2.rent_way.value = '1';
		//fm2.a_a.value = '1';
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
		var SUBWIN='./main_car_order.jsp?auth_rw=<%=auth_rw%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>';
		window.open(SUBWIN, "OrderList", "left=100, top=100, width=650, height=400, scrollbars=yes, status=yes");	
	}
	
	//�������
	function set_amt(){
		var fm = document.form1;
		fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));// + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));		
	}
	
	//�����ݼ���
	function compare(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		var car_price 	= toInt(parseDigit(fm.o_1.value));
		
		if(car_price < 25000000){
			fm.rg_8_2.value = '20';
			fm.rg_8_amt_2.value = parseDecimal(car_price * 20 /100 );
			//alert(fm.rg_8_amt_2.value);
		}
				
	}
	
	//����
	function GetVar(){
		var fm = document.form1;
		//if(fm.code.value == ''){ alert('������ �����Ͻʽÿ�'); return; }
		//if(fm.car_id.value == ''){ alert('�𵨸� �����Ͻʽÿ�'); return; }		
		fm.action = './get_var_null.jsp';
		fm.target = 'i_no';
		fm.submit();
	}		

	
	//��������
	function EstiReg(){
		var fm = document.form1;
		//if(fm.spr_yn.value == ''){ alert('�ſ뱸���� �����Ͻʽÿ�'); return; }
		if(fm.est_nm.value == ''){ alert('�켱������ �Է��Ͻʽÿ�'); fm.est_nm.focus(); return; }		
		if(fm.code.value == ''){ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_id.value == ''){ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_amt.value == ''){ alert('�����ݾ��� Ȯ���Ͻʽÿ�'); return; }				
		if(fm.ro_13.value == ''){ alert('�����ܰ��� �Է��Ͻʽÿ�'); return; }				
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return; }
		fm.cmd.value = "i";
		fm.action = 'esti_mng_i_a_1.jsp';
//		fm.target = "d_content";
//		fm.target = "i_no";
		estimate2();
		//fm.submit();
	}
<% for(int i=3; i<15; i++){ %>	
	function estimate<%= i-1 %>(){
	
		compare(document.form1.rg_8);
		
		var fm  = document.form<%= i %>;		
		fm.est_tel.value = document.form1.est_tel.value;
		fm.car_comp_id.value = document.form1.car_comp_id.value;
		fm.code.value = document.form1.code.value;
		fm.car_id.value = document.form1.car_id.value;
		fm.car_seq.value = document.form1.car_seq.value;
		fm.car_amt.value = document.form1.car_amt.value;
		fm.opt.value = document.form1.opt.value;
		fm.opt_seq.value = document.form1.opt_seq.value;
		fm.opt_amt.value = document.form1.opt_amt.value;
		fm.dc_amt.value = document.form1.dc_amt.value;
		fm.o_1.value = document.form1.o_1.value;
		fm.rg_8_amt.value = document.form1.rg_8_amt.value;
		fm.ro_13.value = document.form1.ro_13.value;
		fm.o_13.value = document.form1.o_13.value;
		fm.ro_13_amt.value = document.form1.ro_13_amt.value;
		fm.a_e.value = document.form1.a_e.value;
		fm.spr_yn.value = document.form1.spr_yn.value;
		fm.rg_8_2.value = document.form1.rg_8_2.value;
		fm.rg_8_amt_2.value = document.form1.rg_8_amt_2.value;				

		
		var car_price 	= toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) ;
		var s_dc_amt 	= toInt(parseDigit(fm.dc_amt.value)) ;
		
		fm.r_o_1.value 		= 0;
		fm.r_dc_amt.value 	= 0;				
		
		//������D/C ���� ��� Ư�Ҽ��� �ݿ�	
		if(s_dc_amt > 0){
			//������ Ư�Ҽ���
			var o_2 = <%=ej_bean.getJg_3()%>;	
			//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);
			var s_dc_amt = Math.round(s_dc_amt*(1+o_2));
			if(<%=i%> == 2 || <%=i%> == 3 || <%=i%> == 8 || <%=i%> == 9 || <%=i%> == 10 || <%=i%> == 11 || <%=i%> == 12 || <%=i%> == 13){//�鼼(��Ʈ)
				if('<%=ej_bean.getJg_a()%>' == '301' || '<%=ej_bean.getJg_a()%>' =='302'){//LPG��������
				}else{					
					//fm.r_o_1.value 		= parseDecimal(car_price-s_dc_amt);
					//fm.r_dc_amt.value 	= parseDecimal(s_dc_amt);				
				}
			}
		}
					
		if(fm.est_nm.value == '')	{ alert('�켱������ �Է��Ͻʽÿ�'); fm.est_nm.focus(); return; }		
		if(fm.code.value == '')		{ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_id.value == '')	{ alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_amt.value == '')	{ alert('�����ݾ��� Ȯ���Ͻʽÿ�'); return; }				
		if(fm.ro_13.value == '')	{ alert('�����ܰ��� �Է��Ͻʽÿ�'); return; }				
		
		fm.target = "i_no<%= i %>";		
		
		if('<%=ck_acar_id%>'=='000029'){
//			fm.target = "_blank";					
		}
		
		fm.submit();		
		
	}
<% } %>	
	
	//������
	function select_no(est_id){
		var fm = document.form1;
		if(!confirm("�ش� �ֿ����� ���뿩�� ��������� �����Ͻðڽ��ϱ�?")) 	return;
		fm.action = "main_car_all_no.jsp?est_id"+est_id;
		fm.target = 'i_no';
		fm.submit();
	}		
	
	//�ִ��ܰ��� ��ȸ
	function searchO13(){
		var fm = document.form1;
		if(fm.code.value == ''){ 	alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_id.value == ''){ 	alert('������ �����Ͻʽÿ�'); return; }
		if(fm.car_amt.value == ''){ alert('�����ݾ��� Ȯ���Ͻʽÿ�'); return; }				
		if(fm.a_b.value == ''){ 	alert('�뿩�Ⱓ�� �����Ͻʽÿ�'); return; }
		
		var car_price 	= toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) ;
		var s_dc_amt 	= toInt(parseDigit(fm.dc_amt.value)) ;
		
		fm.r_o_1.value 		= 0;
		fm.r_dc_amt.value 	= 0;				
		
		//������D/C ���� ��� Ư�Ҽ��� �ݿ�	
		if(s_dc_amt > 0){
			//������ Ư�Ҽ���
			var o_2 = <%=ej_bean.getJg_3()%>;	
			//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);
			var s_dc_amt = Math.round(s_dc_amt*(1+o_2));
			if('<%=ej_bean.getJg_a()%>' == '301' || '<%=ej_bean.getJg_a()%>' =='302'){//LPG��������
			}else{					
				//fm.r_o_1.value 		= parseDecimal(car_price-s_dc_amt);
				//fm.r_dc_amt.value 	= parseDecimal(s_dc_amt);
			}
		}
		
		fm.action = '/acar/estimate_mng/get_o13_20080808.jsp';
		fm.target = 'i_no';
		//fm.target='_blank';
		fm.submit();
		
		
	}			
	
	//��ü����	
	function show_all(){
		var fm = document.form1;
		var speed = 0;
		var add_speed = 5000;
		
		
		
		
		
		if(fm.ro_13.value == ''){ alert('�����ܰ��� �Է��Ͻʽÿ�'); return; }			
		
		<% for(int i=3; i<9; i++){ %>
		setTimeout("estimate<%= i-1 %>()", speed);
		speed+=add_speed;
		<%}%>
		
		//setTimeout("alert('�����Ϸ�')", speed);
/*		
		<%if(ej_bean.getJg_2().equals("1")){%>
		<% for(int i=9; i<15; i++){ %>
		setTimeout("estimate<%= i-1 %>()", speed);
		speed+=add_speed;
		<%}%>		
		<%}%>
*/
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
  <form action="./esti_mng_i_a_1.jsp" name="form1" method="POST" >
    <input type="hidden" name="r_o_1" value="">
    <input type="hidden" name="r_dc_amt" value="">	
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="cmd" value="">
    <input type="hidden" name="s_st" value="">
    <input type="hidden" name="est_from" value="main_car">
    <input type="hidden" name="a_b" value="36">	
    <input type="hidden" name="a_e" value="<%= a_e %>">
    <input type="hidden" name="est_id" value="<%= est_id %>">
	<%if(ej_bean.getJg_2().equals("1")){%>
    <input type="hidden" name="est_st" value="4">	
	<%}else{%>
    <input type="hidden" name="est_st" value="0">	
	<%}%>
	<input type="hidden" name="jg_2" value="<%=ej_bean.getJg_2()%>">
	<input type="hidden" name="o_2" value="">		
	<input type="hidden" name="rg_8_2" value="">		
	<input type="hidden" name="rg_8_amt_2" value="">				

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
                    <td colspan="2">&nbsp;<input type="text" name="est_tel" value="<%= e_bean.getEst_tel() %>" size="3" class=num> 
                      <a href="javascript:open_list();"><img src=../images/center/button_in_list.gif border=0 align=absmiddle></a></td>
                </tr>
                <tr> 
                    <td class=title>������</td>
                    <td colspan="2">&nbsp;<%= c_db.getNameById(e_bean.getCar_comp_id(), "CAR_COM") %>
        			<input type="hidden" name="car_comp_id" value="<%= e_bean.getCar_comp_id() %>"></td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="2">&nbsp;<%= c_db.getNameById(e_bean.getCar_comp_id()+e_bean.getCar_cd(), "CAR_MNG") %>&nbsp;(<%=cm_bean.getJg_code()%>)
        			<input type="hidden" name="car_nm" value="<%= c_db.getNameById(e_bean.getCar_comp_id()+e_bean.getCar_cd(), "CAR_MNG") %>">
        			<input type="hidden" name="code" value="<%= e_bean.getCar_cd() %>"></td>
                </tr>
                <tr> 
                    <td class=title width=12%>����</td>
                    <td width=63%>&nbsp;<input type="text" name="car_name" value="<%= c_db.getNameById(e_bean.getCar_id()+e_bean.getCar_seq(), "CAR_NM3") %>" size="87" class=text> 
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
                    <td class=title>������DC</td>
                    <td>&nbsp;
        			<input type="text" name="dc" value="<%= e_bean.getDc() %>" size="87" class=text>
                    </td>
                    <td align="center"> <input type="text" name="dc_amt" value="<%= AddUtil.parseDecimal(e_bean.getDc_amt()) %>" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">��������</td>
                    <td align="center"> <input type="text" name="o_1" value="<%= AddUtil.parseDecimal(o_1) %>" size="15" class=num>
                      ��</td>
                </tr>
                <tr>
                    <td class=title>������</td>
                    <td colspan="2">&nbsp;������ 
                      <input type="text" name="rg_8" class=num size="4" value="25<%//= e_bean.getRg_8() %>" onBlur="javascript:compare(this)">
                      %, ���뺸���ݾ� : 
                      <input type="text" name="rg_8_amt" class=num size="10" value="<%= AddUtil.parseDecimal(o_1*(25/100f)) %><%//= AddUtil.parseDecimal(o_1*(e_bean.getRg_8()/100f)) %>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      ��<font color="#666666"> (�⺻�������� :
                      <input type="text" name="g_8" class=whitenum size="2" value="25">
                      %) </font></td>
                </tr>
                <tr> 
                    <td class=title>�����ܰ���</td>
                    <td colspan="2">&nbsp;������ 
                      <input type="text" name="ro_13" size="4" class=num value="<%//= e_bean.getRo_13() %>"  onblur="javascript:compare(this)">
                      %, �����ܰ��ݾ� :
                      <input type="text" name="ro_13_amt" class=num size="10" value="<%//= AddUtil.parseDecimal(o_1*(e_bean.getRo_13()/100f)) %>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                        �� <font color="#666666">(���Կɼ� �ݾ���)</font><br><font color="#666666">&nbsp;�ִ��ܰ��� :
                      <input type="text" name="o_13" class=whitenum size="3"  value="<%//= e_db.getJanga(est_id)*100 %>">
                      % ������ ����</font>
        			  <a href="javascript:searchO13();"><img src=../images/center/button_in_max.gif border=0 align=absmiddle></a></td>
                </tr>
                <tr> 
                    <td class=title>���ſ뵵</td>
                    <td colspan="2">&nbsp;<input type="text" name="spr_yn" class=num size="2" value="2">
    			    <font color="#666666">(�Ϲݱ��:0, �췮���:1, <b>�ʿ췮���:2</b>, �ż�����:3)</font></td>
                </tr>
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan="2">&nbsp;��������: ����-0, ��Ʈ-0
					&nbsp;�뿩��D/C: ����-0, ��Ʈ-0</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td align=right><a href="javascript:show_all();"><img src=../images/center/button_p_allgj.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
            <a href="javascript:estimate2();"><img src=../images/center/button_rent_g.gif border=0 align=absmiddle></a>&nbsp;
            <a href="javascript:estimate3();"><img src=../images/center/button_rent_i.gif border=0 align=absmiddle></a>&nbsp;
            <a href="javascript:estimate4();"><img src=../images/center/button_lease_g.gif border=0 align=absmiddle></a>&nbsp;
            <a href="javascript:estimate5();"><img src=../images/center/button_lease_i.gif border=0 align=absmiddle></a>&nbsp;
            <a href="javascript:estimate6();"><img src=../images/center/button_lease_g2.gif border=0 align=absmiddle></a>&nbsp;
            <a href="javascript:estimate7();"><img src=../images/center/button_lease_i2.gif border=0 align=absmiddle></a>
            <span class=style4>(�����⺻��2/�����Ϲݽ�2�� ����������)</span>
	    </td>
    </tr>
	<%if(ej_bean.getJg_2().equals("1")){%>
	<tr>
	    <td class=h></td>
	</tr>
    <tr> 
        <td align=center>
            <a href="javascript:estimate8();"><img src=../images/center/button_rent_5.gif border=0 align=absmiddle></a>&nbsp;
            <a href="javascript:estimate9();"><img src=../images/center/button_rent_i5.gif border=0 align=absmiddle></a>&nbsp;			
            <a href="javascript:estimate10();"><img src=../images/center/button_rent_6.gif border=0 align=absmiddle></a>&nbsp;
            <a href="javascript:estimate11();"><img src=../images/center/button_rent_i6.gif border=0 align=absmiddle></a>&nbsp;			
            <a href="javascript:estimate12();"><img src=../images/center/button_rent_free.gif border=0 align=absmiddle></a>&nbsp;
            <a href="javascript:estimate13();"><img src=../images/center/button_rent_ifree.gif border=0 align=absmiddle></a>
	    </td>
    </tr>	
	<%}%>
    <tr align="right"> 
        <td><a href="javascript:select_no('<%=est_id%>');"><img src=../images/center/button_nuse.gif border=0 align=absmiddle></td>
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
                                <td rowspan="2" width=11% class="title">�뿩�Ⱓ</td>
                                <td colspan="2" class="title">��ⷻƮ(���������)<%if(ej_bean.getJg_2().equals("1")){%>-4��km<%}%></td>
                                <td colspan="2" class="title">���丮��(���������)</td>
                                <td colspan="2" class="title">���丮��(����������)</td>				  
                            </tr>
                            <tr> 
                                <td width="14%" class="title">�⺻��</td>
                                <td width="14%" class="title">�Ϲݽ�</td>
                                <td width="14%" class="title">�⺻��</td>
                                <td width="14%" class="title">�Ϲݽ�</td>
                                <td width="15%" class="title">�⺻��</td>
                                <td width="15%" class="title">�Ϲݽ�</td>
                            </tr>
                            <tr> 
                                <td class="title">36����</td>
                                <td class=title_p><div align="right"> 
                                  <input type="text" name="rb36" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div></td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="rs36" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div></td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="lb36" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div></td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="ls36" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div>
            				    </td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="lb362" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div></td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="ls362" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div>
            				    </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%if(ej_bean.getJg_2().equals("1")){%>
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
                                <td rowspan="2" width=11% class="title">�뿩�Ⱓ</td>
                                <td colspan="2" class="title">��ⷻƮ(���������)-5��km</td>
                                <td colspan="2" class="title">��ⷻƮ(���������)-6��km</td>
                                <td colspan="2" class="title">��ⷻƮ(���������)-������</td>		  
                            </tr>
                            <tr> 
                                <td width="14%" class="title">�⺻��</td>
                                <td width="14%" class="title">�Ϲݽ�</td>
                                <td width="14%" class="title">�⺻��</td>
                                <td width="14%" class="title">�Ϲݽ�</td>
                                <td width="15%" class="title">�⺻��</td>
                                <td width="15%" class="title">�Ϲݽ�</td>
                            </tr>
                            <tr> 
                                <td class="title">36����</td>
                                <td class=title_p><div align="right"> 
                                  <input type="text" name="rb36_5tt" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div></td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="rs36_5tt" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div></td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="rb36_6tt" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div></td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="rs36_6tt" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div>
            				    </td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="rb36_free" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div></td>
                                <td class=title_p> <div align="right"> 
                                  <input type="text" name="rs36_free" class=num size="10" value="" readonly >
                                  ��&nbsp;&nbsp; &nbsp;</div>
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
        <td>&nbsp;</td>
    </tr>
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
                                <td width="30" class="title" style="font-size : 8pt;">����</td>
                                <td width="75" class="title" style="font-size : 8pt;">��������</td>
                                <td width="65" class="title" style="font-size : 8pt;">��������</td>
                                <td width="60" class="title" style="font-size : 8pt;">�ɼǰ���</td>				  
                                <td width="70" class="title" style="font-size : 8pt;">��������</td>				  				  
                                <td width="140" class="title" style="font-size : 8pt;">�ɼ�</td>				  				  
                                <td width="60" class="title" style="font-size : 8pt;">���Կɼ�</td>				  				  
                                <td width="70" class="title" style="font-size : 8pt;">��Ʈ�⺻��</td>				  
                                <td width="70" class="title" style="font-size : 8pt;">��Ʈ�Ϲݽ�</td>				  				  
                                <td width="65" class="title" style="font-size : 8pt;">�����⺻��</td>
                                <td width="65" class="title" style="font-size : 8pt;">�����Ϲݽ�</td>
                                <td width="65" class="title" style="font-size : 8pt;">�����⺻��</td>
                                <td width="65" class="title" style="font-size : 8pt;">�����Ϲݽ�</td>
                             </tr>
		<% 	if(vt.size()>0){
				for(int i=0; i<vt.size(); i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>				
                            <tr> 
                                <td align="center" style="font-size : 8pt;"><%=i+1%></td>
                                <td align="center" style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                                <td align="right"  style="font-size : 8pt;"><%=AddUtil.parseDecimal((String)ht.get("CAR_AMT"))%>&nbsp;</td>
                                <td align="right"  style="font-size : 8pt;"><%=AddUtil.parseDecimal((String)ht.get("OPT_AMT"))%>&nbsp;</td>
                                <td align="right"  style="font-size : 8pt;"><%=AddUtil.parseDecimal((String)ht.get("O_1"))%>&nbsp;</td>
                                <td align="center" style="font-size : 8pt;"><%=ht.get("OPT")%></td>				  
                                <td align="center" style="font-size : 8pt;"><%=ht.get("RO_13")%>%</td>				  				  
                                <td align="right"  style="font-size : 8pt;"><%=AddUtil.parseDecimal((String)ht.get("RB36_AMT"))%>&nbsp;</td>
                                <td align="right"  style="font-size : 8pt;"><%=AddUtil.parseDecimal((String)ht.get("RS36_AMT"))%>&nbsp;</td>
                                <td align="right"  style="font-size : 8pt;"><%=AddUtil.parseDecimal((String)ht.get("LB36_AMT"))%>&nbsp;</td>
                                <td align="right"  style="font-size : 8pt;"><%=AddUtil.parseDecimal((String)ht.get("LS36_AMT"))%>&nbsp;</td>
                                <td align="right"  style="font-size : 8pt;"><%=AddUtil.parseDecimal((String)ht.get("LB36_AMT2"))%>&nbsp;</td>
                                <td align="right"  style="font-size : 8pt;"><%=AddUtil.parseDecimal((String)ht.get("LS36_AMT2"))%>&nbsp;</td>
                            </tr>	
		<%	}
		 }%>							
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align=center>&nbsp; </td>
    </tr>	
</table>
</form>
<% 	for(int i=3; i<15; i++){
		if(i==3){
			est_nm = "rb36"; a_a = "22";
		}else if(i==4){
			est_nm = "rs36"; a_a = "21";
		}else if(i==5){
			est_nm = "lb36"; a_a = "12";
		}else if(i==6){
			est_nm = "ls36"; a_a = "11";
		}else if(i==7){
			est_nm = "lb362"; a_a = "12";
		}else if(i==8){
			est_nm = "ls362"; a_a = "11";
		//LPG�����Ÿ��� �߰�
		}else if(i==9){
			est_nm = "rb36_5tt"; a_a = "22";
		}else if(i==10){
			est_nm = "rs36_5tt"; a_a = "21";
		}else if(i==11){
			est_nm = "rb36_6tt"; a_a = "22";
		}else if(i==12){
			est_nm = "rs36_6tt"; a_a = "21";
		}else if(i==13){
			est_nm = "rb36_free"; a_a = "22";
		}else if(i==14){
			est_nm = "rs36_free"; a_a = "21";
		}
 %>

<form name="form<%= i %>" method="post" action="./esti_mng_i_a_1.jsp">
	<input type="hidden" name="reg_dt" value="<%=Util.getLoginTime()%>">
	<!--������-->
	<input type="hidden" name="est_nm" value="<%= est_nm %>">
	<input type="hidden" name="est_tel" value="">
	<input type="hidden" name="est_ssn" value="Y">	
	<input type="hidden" name="est_fax" value="">
	<!--�ſ뵵 :�ʿ췮��� 2 -> �Ϲݱ�� 0���� ����-> �췮��� 1�� ����-> �ʿ췮��� 2�� ����-> �췮��� 1�� ���� -> �ʿ췮��� 2�� ����->--> 
	<input type="hidden" name="spr_yn" value="2">
	<!--�뿩��ǰ-->
	<input type="hidden" name="a_a" value="<%= a_a %>">
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
	<input type="hidden" name="o_1" value="">
	<!--LPG��������:������-->
	<input type="hidden" name="lpg_yn" value="0">
	<!--������:20% -> 25% -->
	<input type="hidden" name="rg_8" value="25">
	<input type="hidden" name="rg_8_amt" value="">
	<input type="hidden" name="g_8" value="25">
	<!--���ô뿩��:0����-->
	<input type="hidden" name="pp_st" value="1">
	<input type="hidden" name="g_10" value="0">
	<!--�������:����-->
	<input type="hidden" name="udt_st" value="1">
	<%	String a_h = "2";
		if(a_a.equals("12")||a_a.equals("11")){//����
			a_h = "4";
			//if(a_e.equals("104") || a_e.equals("105") || a_e.equals("106") || a_e.equals("107") || a_e.equals("201")) a_h = "4";
			//else{
			//	if(a_e.equals("402") || a_e.equals("501") || a_e.equals("502") || a_e.equals("601") || a_e.equals("602"))	a_h = "1";
			//}
		}
	%>
	<input type="hidden" name="a_h" value="<%=a_h%>">

	<!--����(�빰/�ڼ�):1��-->
	<input type="hidden" name="ins_dj" value="2">
	<!--����(���Կ���):26���̻�-->
	<input type="hidden" name="ins_age" value="1">
	<!--��������:����-->	
	<input type="hidden" name="gi_yn" value="1">
	<!--������å��-->
	<input type="hidden" name="car_ja" value="300000">
	<!--�����ܰ���-->
	<input type="hidden" name="ro_13" value="">
	<input type="hidden" name="o_13" value="">
	<input type="hidden" name="ro_13_amt" value="">
	<!--�Һз�-->
	<input type="hidden" name="a_e" value="">	
	<!--��������-->
	<%if(a_a.equals("12")||a_a.equals("11")){//����%>
	<input type="hidden" name="o_11" value="0">	
	<%}else{%>
	<input type="hidden" name="o_11" value="0">	
	<%}%>
	<!--�뿩��D/C-->
	<%if(a_a.equals("12")||a_a.equals("11")){//����%>
	<input type="hidden" name="fee_dc_per" value="0">	
	<%}else{%>
	<input type="hidden" name="fee_dc_per" value="0">
	<%}%>
    <input type="hidden" name="r_o_1" value="">
    <input type="hidden" name="r_dc_amt" value="">		
	<input type="hidden" name="rg_8_2" value="">		
	<input type="hidden" name="rg_8_amt_2" value="">					
</form>
<% 	} %>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>

<% for(int i=3; i<15; i++){ %>
<iframe src="about:blank" name="i_no<%= i %>" width="800" height="110" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
<% } %>
<script language="JavaScript">
<!--
	<%if(cng_st.equals("����")){%>
		set_amt();
		setTimeout("show_all()", 1000);
	<%}%>
	searchO13();	
	setTimeout("show_all()", 1500);

//-->
</script>
</body>
</html>