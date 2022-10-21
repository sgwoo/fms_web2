<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.insur.*, acar.offls_pre.*,acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode	 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();

	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "5");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
	//�Һ�����
	ContDebtBean debt = a_db.getContDebt(rent_mng_id, rent_l_cd);
	
	//�⺻��� ���� ����
	String car_b_inc_name = cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	

	//3. �뿩-----------------------------
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	

	//4. ����----------------------------
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
		
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	from_page = "/fms2/lc_rent/lc_c_c_car_ac.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
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
	//����
	function update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}else{
			var height = 500;
			if(st == 'car') 			height = 500;
			else if(st == 'car_amt') 		height = 450;
			else if(st == 'insur') 			height = 500;
			else if(st == 'gi') 			height = 250;
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
		}
	}
	
	//4�ܰ� -----------------------------------------------------------
		
	
	//���� �Һ��ڰ� �հ�
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) );
		fm.tot_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) );
		fm.tot_c_amt.value  	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );
	}
	
	//���� ���԰� �հ�
	function sum_car_f_amt(){
		var fm = document.form1;
		
		fm.tot_fs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.commi_s_amt.value)) + toInt(parseDigit(fm.storage_s_amt.value)));
		fm.tot_fv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.commi_v_amt.value)) + toInt(parseDigit(fm.storage_v_amt.value)));
		fm.tot_f_amt.value 		= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );
	}
	
	
	//�ش� ���� �������� �⺻��� ����
	function open_car_b(car_id, car_seq, car_name){
		fm = document.form1;
		window.open('view_car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=100, top=100, width=450, height=600, scrollbars=yes"); 
	}
	
	
	function OpenIns(ins_st){
		var theForm = document.CarRegForm;
		var url = "/acar/ins_mng/ins_u_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&c_id=<%=base.getCar_mng_id()%>&ins_st="+ins_st+"&go_url=lc_rent&cmd=view";		
		window.open(url, "Ins", "left=100, top=50, width=850, height=610, scrollbars=no");		
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
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">    
  <input type='hidden' name="dpm" 				value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="car_end_dt"		value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name="o_1"			value="">
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
    
  <input type='hidden' name="cng_item"			value="">  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���� (<%=base.getCar_mng_id()%>)
	    	<!--<%if(!mode.equals("view")){%><%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id) || nm_db.getWorkAuthUser("����������",user_id) || nm_db.getWorkAuthUser("���������",user_id)){%>&nbsp;<a href="javascript:update('car')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><%}%>-->
	    	</span></td>
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
                    <td>&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[������]<%}%><%=cm_bean.getCar_name()%></td>
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
                    <td class='title'>����</td>
                    <td>&nbsp;<% if(cm_bean.getDiesel_yn().equals("1")) out.print("�ֹ���"); %> <% if(cm_bean.getDiesel_yn().equals("Y")) out.print("����"); %> <% if(cm_bean.getDiesel_yn().equals("2")) out.print("LPG"); %><% if(cm_bean.getDiesel_yn().equals("5")){ out.print("����"); }%><% if(cm_bean.getDiesel_yn().equals("6")){ out.print("����"); }%></td>
                    <td class='title' width="10%">��������</td>
                    <td>&nbsp;<%=cr_bean.getTaking_p()%></td>
                    <td class='title'>���ӱ� </td>
                    <td>&nbsp;<% String auto_yn = "";
        			       if(cm_bean.getAuto_yn().equals("Y")) auto_yn="A/T";
        						 if(cm_bean.getAuto_yn().equals("N")) auto_yn="M/T";
        						 if(car.getOpt().indexOf("���ӱ�") != -1) auto_yn="A/T";
        						 if(car.getOpt().indexOf("DCT") != -1) auto_yn="A/T";
        						 if(car.getOpt().indexOf("C-TECH") != -1) auto_yn="A/T";
        						 if(car.getOpt().indexOf("A/T") != -1) auto_yn="A/T";
        						 if(cm_bean.getCar_b().indexOf("�ڵ����ӱ�") != -1) auto_yn="A/T";
        						 if(cm_bean.getCar_b().indexOf("���� ���ӱ�") != -1) auto_yn="A/T";
        						 out.print(auto_yn); %></td>
                </tr>
                <tr>
                    <td class='title'>�⺻���</td>
                    <td colspan="5" align=center>
                        <table width=99% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td>
                    			<% if(!car_b_inc_name.equals("")){ %> <a href="javascript:open_car_b('<%= cm_bean.getCar_b_inc_id() %>','<%= cm_bean.getCar_b_inc_seq() %>','<%= car_b_inc_name %>');"  onMouseOver="window.status=''; return true"><%= car_b_inc_name %> �⺻���</a> �� <br><% } %>
                    			<%=cm_bean.getCar_b()%></td>
                    	    </tr>
                    	    <tr>
                                <td style='height:3'></td>
                            </tr>
                    	</table>
                    </td>
                </tr>
                <tr>
                    <td class='title'>�ɼ�</td>
                    <td colspan="5">&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr>
                    <td class='title'> ����</td>
                    <td colspan="5">&nbsp;<%=car.getColo()%> 
						<%if(!car.getIn_col().equals("")){%>
						&nbsp;&nbsp;&nbsp;
					  	(�������(��Ʈ): <%=car.getIn_col()%> )  
						<%}%>
						<%if(!car.getGarnish_col().equals("")){%>
						&nbsp;&nbsp;&nbsp;
					  	(���Ͻ�: <%=car.getGarnish_col()%> )  
						<%}%>
					</td>
                </tr>
          <tr>
          		<td class="title">����</td>
          		<td colspan="5">&nbsp;<%=car.getConti_rat()%></td>
          </tr>
                <tr>
                	<td class="title">����������</td>
                	<td>
                		&nbsp;<%=AddUtil.parseDecimal(car.getAccid_serv_amt())%>��
                	</td>
                	<td class="title">�����</td>
                	<td colspan='3'>
                		&nbsp;<%=car.getAccid_serv_cont()%>
                	</td>
                </tr>       
                <tr>
                	<td class="title">�����ܰ��ݿ�</td>
                	<td>
                		&nbsp;<%=car.getJg_col_st()%>
                	</td>
                	<td class="title">����ܰ��ݿ�</td>
                	<td colspan="3">
                		&nbsp;<%=car.getJg_opt_st()%>
                	</td>
                	<!--
                	<td class="title">TUIX/TUON����</td>
                	<td>
                		&nbsp;<%=car.getJg_tuix_st()%>&nbsp;<%=car.getJg_tuix_opt_st()%>
                	</td>
                	-->
                </tr>                                      
                
                <tr>
                    <td class='title'>�����μ���</td>
                    <td>&nbsp;
                        <%String udt_st = pur.getUdt_st();%><%if(udt_st.equals("1")){%>���ﺻ��<%}else if(udt_st.equals("2")){%>�λ�����<%}else if(udt_st.equals("3")){%>��������<%}else if(udt_st.equals("5")){%>�뱸����<%}else if(udt_st.equals("6")){%>��������<%}else if(udt_st.equals("4")){%>��<%}%>
                    </td>                  
                    <td class='title'>�������</td>
                    <td colspan="3">&nbsp;
                      <%String car_ext = car.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>
                      </td>
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
    <tr id=tr_car1 style="display:''"> 
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
                    <td colspan="3" class='title'>�߰������԰���</td>
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
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td class=title>�Ÿűݾ�</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                </tr>
                <tr>
                    <td height="12" class='title'>�ɼ�</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' >
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' >
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  >
             			��</td>
                <td class=title>�߰�������</td>
                <td  align="center">&nbsp;
                  <input type='text' name='commi_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt())%>' maxlength='7' class='whitenum' >
         			��</td>
                <td  align="center">&nbsp;
                  <input type='text' name='commi_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_v_amt())%>' maxlength='7' class='whitenum' >
         			��</td>
                <td  align="center">&nbsp;
                  <input type='text' name='commi_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt()+car.getCommi_v_amt())%>' maxlength='7' class='whitenum'  >
         			��</td>
                </tr>
                <tr>
                    <td height="26" class='title'> ����</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' >
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum' >
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  >
             			��</td>
                                <td class=title>������</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_v_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt()+car.getStorage_v_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                </tr>
                <tr>
                    <td align="center" class='title'>�հ�</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    ��</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                    <td align='center' class='title'>�հ�</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                </tr>
            </table>		
	    </td>
    </tr>	      
    <tr>
        <td class=h></td>
    </tr>    		     	  
    <tr id=tr_car0 style="display:''"> 
	<%	int sh_car_amt = 0;
		String sh_year= "";
		String sh_month = "";
		String sh_day = "";
		String sh_day_bas_dt = "";
		int sh_amt = 0;
		float sh_ja = 0;
		int sh_km = 0;
		int sh_tot_km = 0;
		String sh_km_bas_dt = "";
		String sh_init_reg_dt = "";
		
		sh_car_amt 	= fee_etc.getSh_car_amt();
		sh_year 	= fee_etc.getSh_year();
		sh_month 	= fee_etc.getSh_month();
		sh_day	 	= fee_etc.getSh_day();
		sh_amt		= fee_etc.getSh_amt();
		sh_ja		= fee_etc.getSh_ja();
		sh_km		= fee_etc.getSh_km();
		sh_init_reg_dt	= fee_etc.getSh_init_reg_dt();
		sh_day_bas_dt	= fee_etc.getSh_day_bas_dt();
	%>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'>�����Һ��ڰ�</td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(sh_car_amt)%>'size='10' class='white' >
        				  �� </td>
                    <td class='title' width="10%">�ܰ���</td>
                    <td width="19%">&nbsp;
                      <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher(sh_ja,2) %>'size='4' class='white' >
%</td>
                    <td class='title' width='10%'>�縮��������</td>
                    <td>&nbsp;
                      <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(sh_amt) %>'size='10' class='white' >
�� </td>
                </tr>
                <tr>
                    <td class='title'>����</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='sh_year' value='<%=sh_year%>'size='1' class='white' >
                      ��
                      <input type='text' name='sh_month' value='<%=sh_month%>'size='2' class='white' >
                      ����
                      <input type='text' name='sh_day' value='<%=sh_day%>'size='2' class='white' >
                      �� ( ���ʵ����
                      <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(sh_init_reg_dt)%>' class='white' onBlur='javascript:this.value=ChangeDate(this.value);'>
~ �����
<input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%>'size='11' class='white' >
)</td>
                    <td class='title' width='10%'>�����ü�</td>
                    <td>&nbsp;
                      <input type='text' name='sh_est_amt' value='<%= AddUtil.parseDecimal(car.getSh_est_amt()) %>' size='10' class='white' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      �� 
                    </td>
                </tr>
                <tr>
                  <td class='title'>��������Ÿ�</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(sh_km) %>' class='white' >
                    km</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>		  
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� </span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>	
		<%	//�����̷�-�Ϲݺ���			
			Vector inss2 = ai_db.getInsHisList1(base.getCar_mng_id());
			int ins_size2 = inss2.size();
			if(ins_size2 > 0){	  %>	
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
          <%	for(int i = 0 ; i < ins_size2 ; i++){
					Hashtable ins2 = (Hashtable)inss2.elementAt(i);
					if(i < ins_size2-1) continue;%>
                <tr>
        		    <td class=title width="13%">������</td>
                    <td width="20%">&nbsp;<b><%=ins2.get("INS_COM_NM")%></b></td>
        			<td class=title width="10%">����Ⱓ</td>
                    <td>&nbsp;<%=ins2.get("INS_START_DT")%>~<%=ins2.get("INS_EXP_DT")%><a href="javascript:OpenIns('<%=ins2.get("INS_ST")%>')"></a></td>
                </tr>
          <%	}%>
            </table>
        </td>
    </tr>
    <%}%>
    <tr>
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>��������</td>
                    <td width="20%">&nbsp;<b><%String insurant = cont_etc.getInsurant();%><%if(insurant.equals("1") || insurant.equals("")){%>�Ƹ���ī<%}else if(insurant.equals("2")){%>��<%}%></b></td>
                    <td width="10%"  class=title>�Ǻ�����</td>
                    <td colspan='3'>&nbsp;<b><%String insur_per = cont_etc.getInsur_per();%><%if(insur_per.equals("1") || insur_per.equals("")){%>�Ƹ���ī<%}else if(insur_per.equals("2")){%>��<%}%></b></td>
                </tr>
                <tr> 
                    <td width="13%" class=title>�����ڹ���</td>
                    <td width="20%" class=''>&nbsp;<%String driving_ext = base.getDriving_ext();%><%if(driving_ext.equals("1") || driving_ext.equals("")){%>�����<%}else if(driving_ext.equals("2")){%>��������<%}else if(driving_ext.equals("3")){%>��Ÿ<%}%></td>
                    <td width="10%" class=title >�����ڿ���</td>
                    <td>&nbsp;
                    <b>
                    	<%String driving_age = base.getDriving_age();%>
                    	<%if(driving_age.equals("0")){%>26���̻�<%}
                    	else if(driving_age.equals("3")){%>24���̻�<%}
                    	else if(driving_age.equals("1")){%>21���̻�<%}
                    	else if(driving_age.equals("5")){%>30���̻�<%}
                    	else if(driving_age.equals("6")){%>35���̻�<%}
                    	else if(driving_age.equals("7")){%>43���̻�<%}
                    	else if(driving_age.equals("8")){%>48���̻�<%}
                    	else if(driving_age.equals("9")){%>22���̻�<%}
                    	else if(driving_age.equals("10")){%>28���̻�<%}
                    	else if(driving_age.equals("11")){%>35���̻�~49������<%}
                    	else if(driving_age.equals("2")){%>��������<%}%>
                    </b>
                    </td>
                    <td width="10%" class=title >��������������Ư��</td>
                    <td>&nbsp;<%String com_emp_yn = cont_etc.getCom_emp_yn();%><%if(com_emp_yn.equals("Y")){%>����<%}else if(com_emp_yn.equals("N")){%>�̰���<%}%>                                   
                    </td>                    
                </tr>
                <tr>
                    <td width="13%"  class=title>���ι��</td>
                    <td width="20%">&nbsp;����(���ι��,��)</td>
                    <td width="10%" class=title>�빰���</td>
                    <td width="20%" class=''>&nbsp;<%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5õ����<%}else if(gcp_kd.equals("2")){%>1���<%}else if(gcp_kd.equals("3")){%>5���<%}else if(gcp_kd.equals("4")){%>2���<%}else if(gcp_kd.equals("8")){%>3���<%}%></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td class=''>&nbsp;<%String bacdt_kd = base.getBacdt_kd();%><%if(bacdt_kd.equals("1")){%>5õ����<%}else if(bacdt_kd.equals("2")){%>1���<%}else if(bacdt_kd.equals("9")){%>�̰���<%}%></td>
                </tr>
                <tr>
                    <td  class=title>������������</td>
                    <td>&nbsp;<%String canoisr_yn = cont_etc.getCanoisr_yn();%><%if(canoisr_yn.equals("Y")){%>����<%}else if(canoisr_yn.equals("N")){%>�̰���<%}%></td>
                    <td class=title>�ڱ���������</td>
                    <td class=''>&nbsp;<%String cacdt_yn = cont_etc.getCacdt_yn();%><%if(cacdt_yn.equals("Y")){%><b>����</b><%}else if(cacdt_yn.equals("N")){%>�̰���<%}%></td>
                    <td class=title >����⵿</td>
                    <td class=''>&nbsp;<%String eme_yn = cont_etc.getEme_yn();%><%if(eme_yn.equals("Y")){%>����<%}else if(eme_yn.equals("N")){%>�̰���<%}%></td>
                </tr>
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;<%=HtmlUtil.htmlBR(base.getOthers())%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <tr>
	    <td class=h></td>
	</tr>	
	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�߰�������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_bus style="display:''"> 		
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>           
                <tr>
                    <td width="13%" class='title'>����</td>
                    <td width="20%" >&nbsp;
                      <%=emp1.getEmp_nm()%></td>
                    <td width="10%" class='title'>��ȣ/�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%></td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <%=emp1.getEmp_m_tel()%>
                    </td>
                </tr>
              <tr>
                <td class='title'>�������</td>
                <td >&nbsp;
                  <%= AddUtil.ChangeDate2(emp1.getSh_base_dt())%>
    			</td>
                <td class='title'>�߰�������</td>
                <td colspan='3'>&nbsp;
                  <%=AddUtil.parseDecimal(emp1.getCommi())%>��
    			</td>
              </tr>
              <tr>
                <td class='title'>���ݰ�꼭����</td>
                <td >&nbsp;
                  <%= AddUtil.ChangeDate2(emp1.getFile_gubun1())%>
                  (������)
    			</td>
                <td class='title'>������</td>
                <td colspan='3'>&nbsp;
                  <%=AddUtil.parseDecimal(emp1.getDlv_con_commi())%>��
    			</td>
              </tr>              
                
                <tr>
                    <td class='title'>�����</td>
                    <td >&nbsp;
        		      <select name='emp_bank_cd' disabled>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
                    <td class='title'>���¹�ȣ</td>
                    <td>&nbsp;
                      <%=emp1.getEmp_acc_no()%>
        			</td>
                    <td class='title'>�����ָ�</td>
                    <td>&nbsp;
                      <%=emp1.getEmp_acc_nm()%>
        			</td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�߰�������ó</span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_dlv style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>����</td>
                    <td width="20%" >&nbsp;
                      <%=emp2.getEmp_nm()%>
                    </td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <%=emp2.getCar_off_nm()%>
        			      </td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <%=emp2.getEmp_m_tel()%>
                    </td>
                </tr>
              <tr>
                <td class='title'>�Ÿ�����</td>
                <td >&nbsp;
                  <%= AddUtil.ChangeDate2(emp2.getSh_base_dt())%>
    			</td>
                <td class='title'>�Ÿűݾ�</td>
                <td colspan="3">&nbsp;
                  <%=AddUtil.parseDecimal(emp2.getCommi())%>��
    			</td>
              </tr>
              <tr>
                <td class='title'>��������ȣ</td>
                <td >&nbsp;
                  <%=pur.getEst_car_no()%>
    		    </td>
                <td class='title'>�����ȣ</td>
                <td colspan="3">&nbsp;
                  <%=pur.getCar_num()%>
    			</td>
              </tr>
              <tr>				
                <td class='title'>����</td>
                <td>&nbsp;
				          <%=AddUtil.parseDecimal(pur.getCon_amt())%>��	
    			</td>				
                <td class='title'>�������</td>
                <td colspan="3">&nbsp;
					<select name='con_bank' disabled>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                    </select>
				  	&nbsp;
					���¹�ȣ : 
        			<%=pur.getCon_acc_no()%>
					&nbsp;
					������ : 
        			<%=pur.getCon_acc_nm()%>
    			</td>
              </tr>
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

	
	<%if(!mode.equals("view")){%>
	
	//�ٷΰ���
	var s_fm 	= parent.parent.top_menu.document.form1;
	var fm 		= document.form1;	
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";
	<%}%>
	
//-->
</script>
</body>
</html>
