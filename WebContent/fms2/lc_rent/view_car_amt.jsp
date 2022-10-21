<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�⺻��� ���� ����
	String car_b_inc_name = cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�߰����ܰ� ����
	Hashtable janga 	= new Hashtable();
	Hashtable carOld 	= new Hashtable();
	if(base.getCar_gu().equals("0")){
		janga = shDb.getJanga_20070528(base.getCar_mng_id());
		carOld = c_db.getOld(cr_bean.getInit_reg_dt(), base.getRent_dt());
	}

	//3. �뿩-----------------------------
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//Ư�Ҽ�����
	TaxScdBean tax = t_db.getTaxScdCase(rent_mng_id, rent_l_cd, base.getCar_mng_id());

	//4. ����----------------------------
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String o_3 		= edb.getEstiSikVarCase("1", "", "o_3");
	
	from_page = "/fms2/lc_rent/lc_c_c_car.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	
	
	//4�ܰ� -----------------------------------------------------------
		
	//���� Ư�Ҽ� �ڵ����
	function set_tax_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.spe_tax){ 	//Ư�Ҽ�
			fm.edu_tax.value = parseDecimal(toInt(parseDigit(obj.value))*(30/100));		
		}
		fm.tot_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );					
	}

	//���� Ư�Ҽ� �հ�
	function sum_tax_amt(){
		var fm = document.form1;
		
		if(toInt(parseDigit(fm.spe_tax.value)) >  0){	return; }
		
		if(toInt(parseDigit(fm.car_f_amt.value)) == 0){	sum_car_f_amt(); }
		
		var purc_gu 	= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_c_price = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));		
		var car_f_price = toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		
		var a_e = toInt(s_st);
		var o_1 = car_c_price;
		//������ Ư�Ҽ���
		var o_2 = <%=ej_bean.getJg_3()%>;			
		//Ư�Ҽ��������� o_3 = o_1/(1+o_2), ��������/(1+Ư�Ҽ���);
		var o_3 = Math.round(<%=o_3%>);		
		
		if(purc_gu == '1'){//����1
			fm.spe_tax.value = parseDecimal(car_c_price-o_3);
			fm.pay_st[1].selected = true;
		}else{//����2(�鼼)		 
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
				fm.spe_tax.value = parseDecimal(Math.round(o_1*o_2));
			}else{
				fm.spe_tax.value = parseDecimal(car_c_price-toInt(parseDigit(fm.car_f_amt.value)));
			}				
			fm.pay_st[2].selected = true;
		}
		fm.edu_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value))*(30/100));		
		fm.tot_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );			
	}
	
	//���� �Һ��ڰ� �հ�
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
	}
	
	//���� ���԰� �հ�
	function sum_car_f_amt(){
		var fm = document.form1;		
		
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							
	}	
	
	//����DC
	function search_dc(){
		var fm = document.form1;
		window.open("search_dc.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "COMP_DC", "left=100, top=100, height=200, width=800, scrollbars=yes, status=yes");
	}
	

	
	//�ش� ���� �������� �⺻��� ����
	function open_car_b(car_id, car_seq, car_name){
		fm = document.form1;		 
		window.open('view_car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=100, top=100, width=450, height=600, scrollbars=yes"); 
	}
	
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">    
  <input type='hidden' name="rent_way" 			value="<%=ext_fee.getRent_way()%>">  
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
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name="o_1"				value="">
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
    
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		  <%if(!cr_bean.getCar_no().equals("")){%>
    		    <tr>
        		    <td width='13%' class='title'>������ȣ</td>
        		    <td width="20%">&nbsp;<%=cr_bean.getCar_doc_no()%>&nbsp;(<%String car_ext = cr_bean.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>)</td>
                	<td width="10%" class='title'>���ʵ����</td>
        		    <td width="20%">&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                	<td width="10%" class='title'>���ɸ�����</td>
        		    <td>&nbsp;<%=cr_bean.getCar_end_dt()%></td>
    		    </tr>			  
    		  <%}%>	  
                <tr>
                    <td width='13%' class='title'>�ڵ���ȸ��</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' width="10%">����</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' width='10%'>����</td>
                    <td>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class='title'>�Һз� </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
                    <td class='title' width="10%">�����ڵ�</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>��ⷮ</td>
                    <td>&nbsp;<%if(cr_bean.getCar_mng_id().equals("")){%><%=cm_bean.getDpm()%>cc<%}else{%><%=cr_bean.getDpm()%>cc<%}%></td>
                </tr>
                <tr>
                    <td class='title'>�⺻���</td>
                    <td colspan="5">&nbsp;
        			<% if(!car_b_inc_name.equals("")){ %> <a href="javascript:open_car_b('<%= cm_bean.getCar_b_inc_id() %>','<%= cm_bean.getCar_b_inc_seq() %>','<%= car_b_inc_name %>');"  onMouseOver="window.status=''; return true"><%= car_b_inc_name %> �⺻���</a> �� <br><% } %>
        			<%=HtmlUtil.htmlBR(cm_bean.getCar_b())%></td>
                </tr>
                <tr>
                    <td class='title'>�ɼ�</td>
                    <td colspan="5">&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr>
                    <td class='title'> ����</td>
                    <td colspan="5">&nbsp;<%=car.getColo()%></td>
                </tr>
                <tr>
                    <td class='title'>�������</td>
                    <td colspan="3">&nbsp;<%String car_ext = car.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=car.getSun_per()%>%</td>
                </tr>
                <tr>
                    <td class='title'>LPG����</td>
                    <td colspan="5" >
        			  <table width="350" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="80">&nbsp;����: <%String lpg_yn = car.getLpg_yn();%><%if(lpg_yn.equals("Y")){%>����<%}else if(lpg_yn.equals("N")){%>������<%}%></td>
                          <td width="130">&nbsp;���: <%String lpg_setter = car.getLpg_setter();%><%if(lpg_setter.equals("1")){%>������<%}else if(lpg_setter.equals("2")){%>���뿩�ῡ ����<%}else if(lpg_setter.equals("3")){%>�����ݿ� ����<%}else if(lpg_setter.equals("4")){%>��������<%}%></td>
                          <td>&nbsp;�ݾ�: <%=AddUtil.parseDecimal(car.getLpg_price())%>��</td>
                        </tr>
                      </table>
        			</td>
                </tr>
                <tr>
                    <td class='title'><span class="title1"> �߰�����</span></td>
                    <td colspan="5">&nbsp;<%=car.getAdd_opt()%>&nbsp;<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>��<font color="#666666">(�ΰ������Աݾ�, ���� �ݿ���)</font></td>
                </tr>
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;<%=HtmlUtil.htmlBR(car.getRemark())%></td>
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
    <tr id=tr_car1 style="display:<%if(base.getCar_gu().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td class='title'>��������</td>
                <td colspan="3">&nbsp;<%String purc_gu = car.getPurc_gu();%><%if(purc_gu.equals("1")){%>����<%}else if(purc_gu.equals("0")){%>�鼼<%}%></td>
                <td class='title'>��ó</td>
                <td colspan="3">&nbsp;<%String car_origin = car.getCar_origin();%>
    			<%	if(car_origin.equals("")){
    					code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
    					car_origin = code_bean.getApp_st();
    				}%>
    			<%if(car_origin.equals("1")){%>����<%}else if(car_origin.equals("2")){%>����<%}%></td>
              </tr>
              <tr>
                <td width="13%" rowspan="2" class='title'>���� </td>
                <td colspan="3" class='title'>�Һ��ڰ���</td>
                <td width="10%" rowspan="2" class='title'>����</td>
                <td colspan="3" class='title'>���԰���</td>
              </tr>
              <tr>
                <td width="13%" class='title'>���ް�</td>
                <td width="13%" class='title'>�ΰ���</td>
                <td width="13%" class='title'>�հ�</td>
                <td width="13%" class='title'>���ް�</td>
                <td width="12%" class='title'>�ΰ���</td>
                <td width="13%" class='title'>�հ�</td>
              </tr>
              <tr>
                <td class='title'> �⺻����</td>
                <td align="center">&nbsp;
                  <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>��������</td>
                <td align="center">&nbsp;
                  <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
              </tr>
              <tr>
                <td height="12" class='title'>�ɼ�</td>
                <td align="center">&nbsp;
                  <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>Ź�۷�</td>
                <td align="center" height="12">&nbsp;
                  <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center" height="12">&nbsp;
                  <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center" height="12">&nbsp;
                  <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
              </tr>
              <tr>
                <td height="26" class='title'> ����</td>
                <td align="center">&nbsp;
                  <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title><span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">����D/C</a></span></td>
                <td align="center">&nbsp;
                  <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
    				��</td>
                <td align="center">&nbsp;
                  <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
    				��</td>
                <td align="center">&nbsp;
                  <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
    				��</td>
              </tr>
              <tr id=tr_ecar_dc <%if(car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>���Ҽ� �����</td>
                <td align=center>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align=center>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align=center>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>                
              <tr>
                <td align="center" class='star'>�հ�</td>
                <td  align="center"class='star'>&nbsp;
                  <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
    			    ��</td>
                <td  align="center"class='star'>&nbsp;
                  <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
    				��</td>
                <td  align="center"class='star'>&nbsp;
                  <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
    				��</td>
                <td align='center' class='star'>�հ�</td>
                <td  align="center"class='star'>&nbsp;
                  <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
    				��</td>
                <td  align="center"class='star'>&nbsp;
                  <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
    				��</td>
                <td  align="center"class='star'>&nbsp;
                  <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
    				��</td>
              </tr>
            </table>		
	    </td>
    </tr>			  
    <tr id=tr_car0 style="display:<%if(base.getCar_gu().equals("0")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width='13%' class='title'> �������԰� </td>
                <td width="20%">&nbsp;
    				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt()-car.getDc_cs_amt()-car.getDc_cv_amt())%>'size='10' class='white' readonly>
    				  ��</td>
                <td class='title' width="10%">���ʵ����</td>
                <td width="20%">&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                <td class='title' width='10%'>����</td>
                <td>&nbsp;<input type='text' name='sh_year' value='<%=carOld.get("YEAR")%>'size='1' class='white' readonly>��
    				  <input type='text' name='sh_month' value='<%=carOld.get("MONTH")%>'size='2' class='white' readonly>����
    				  <input type='text' name='sh_day' value='<%=carOld.get("DAY")%>'size='2' class='white' readonly>��
    				  (<input type='text' name='sh_day_bas_dt' value='<%= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='white' readonly>)</td>
              </tr>
              <tr>
                <td class='title'>�߰�����</td>
                <td>&nbsp;
                          <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal((String)janga.get("SH_AMT")) %>'size='10' class='white' readonly>
    					  ��
                </td>
                <td class='title' width="10%">�ܰ���</td>
                <td>&nbsp;
    				  <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher((String)janga.get("REAL_KM_JANGA"),3) %>'size='4' class='white' readonly>
    			%</td>
                <td class='title'>����Ÿ�</td>
                <td>&nbsp;
                          <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal((String)janga.get("TODAY_DIST")) %>' class='white' readonly>					   
                        km(<input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2((String)janga.get("SERV_DT")) %>' class='white' readonly>)</td>
              </tr>
            </table>
	    </td>
    </tr>
    <tr></tr><tr></tr>
    <tr> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
              <tr>
                <td width="3%" class='title' style='height:34'>����</td>
                <td width="10%" class='title'>���ο���</td>
                <td width="13%">&nbsp;<%String pay_st = car.getPay_st();%><%if(pay_st.equals("1")){%>����<%}else if(pay_st.equals("2")){%>�鼼<%}%></td>
                <td width="13%" class='title'>Ư�Ҽ�</td>
                <td  align="center"width="13%">&nbsp;
                  <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
    				��</td>
                <td width="10%" class='title'>������</td>
                <td  align="center"width="13%">&nbsp;
                  <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
    				��</td>
                <td width="12%" class='title'>�հ�</td>
                <td  align="center"width="13%" >&nbsp;
                  <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>
    				��</td>
              </tr>
    		  <%if(!tax.getCar_mng_id().equals("")){%>
              <tr>
                <td class='title'>����</td>
                <td class='title'>��������</td>
                <td>&nbsp;<%=tax.getPay_dt()%></td>
                <td class='title'>Ư�Ҽ�</td>
                <td align="center">&nbsp;
                    <input type='text' name='spe_tax2' size='10' value='<%=Util.parseDecimal(tax.getSpe_tax_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
    				  ��</td>
                <td class='title'>������</td>
                <td align="center">&nbsp;
                    <input type='text' name='edu_tax2' size='10' value='<%=Util.parseDecimal(tax.getEdu_tax_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
    				  ��</td>
                <td class='title'>�հ�</td>
                <td align="center" >&nbsp;
                    <input type='text' name='tot_tax2' size='10' value='<%=Util.parseDecimal(tax.getPay_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>
    				  ��</td>
              </tr>
    		  <%}%>
            </table>		
	    </td>
    </tr>			  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	sum_car_c_amt();
	sum_car_f_amt();
//-->
</script>
</body>
</html>
