<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.con_ins.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�ڵ����⺻����-�⺻����
	CarMstBean cm_bean2 = new CarMstBean();
	if(!cm_bean.getCar_b_inc_id().equals("")){
		cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	}
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	
	//�߰��� ������ �Ǹ�ó
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "5");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
	
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	
	
	
	//�����Ҹ���Ʈ
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	//�����縮��Ʈ - cms ����
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
  //�����������
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;	
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	Hashtable carOld = new Hashtable();	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&from_page="+from_page+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
				  "&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"";
	String valus_t = valus;
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	
	function replaceFloatRound(per){return Math.round(per*1000)/10;}
	function replaceFloatRound2(per){return Math.round(per*10)/10;}
	//���� üũ
	function CheckLen(f, max_len){
		if(get_length(f)>max_len){alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');}
	}
	//����Ʈ
	function list(){
		var fm = document.form1;
		if(fm.from_page.value==''){fm.action='lc_b_frame.jsp';}
		else{fm.action=fm.from_page.value;}
		fm.target='d_content';
		fm.submit();
	}
	
	//���/����: �������� �Է½� �ڵ�������� ����..
	function enter_car(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_car_amt(obj);
	}	
	//���/����: ���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_car_amt(obj)
	{
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		//�߰��� ������ ó���� �޶� �̰ῡ�� �ڵ������ ����.
		
		sum_car_c_amt();
		sum_car_f_amt();
	}	

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
	
	//������ �������ϱ�
	function rent_delete(){
		var fm = document.form1;
		fm.idx.value = 'delete';
		if(confirm('�����Ͻðڽ��ϱ�?')){					
		if(confirm('������ ��� ����Ÿ�� �����ϰ� �˴ϴ�. \n\n�����Ͻðڽ��ϱ�?')){				
			fm.action='lc_b_u_ac_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}}
	}		

	//����
	function update(idx){
		var fm = document.form1;
		
		fm.idx.value = idx;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_u_ac_a.jsp';
			fm.target='d_content';
			fm.submit();
		}							
	}
	
	//�߰������� ����ϱ�-���(�߰���)
	function getSecondhandCarAmt_h(){
		var fm = document.form1;
		fm.action = "/acar/secondhand/getSecondhandBaseSet3.jsp";
		fm.target = "i_no";
		if(fm.user_id.value == '000029'){
			fm.target = "_blank";
		}
		fm.submit();
	}	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="opt"					value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%><%=cm_bean2.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="dpm" 				value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="car_end_dt"	value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">
  <input type='hidden' name="o_1"					value="">
  <input type='hidden' name="ro_13"				value="">
  <input type='hidden' name="o_13"				value="">
  <input type='hidden' name="o_13_amt"		value="">
  <input type='hidden' name="esti_stat"		value="">
  <input type='hidden' name="t_dc_amt"		value="">
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">
  <input type='hidden' name="rent_dt"			value="<%=base.getRent_dt()%>">
  <input type='hidden' name="car_mng_id"	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id"		value="<%=base.getClient_id()%>">
  <input type='hidden' name="from_page"		value="<%=from_page%>">
  <input type='hidden' name="est_from"		value="lc_reg">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_id"			value="<%=car.getCar_id()%>">
  <input type='hidden' name="car_seq"			value="<%=car.getCar_seq()%>">
  <input type='hidden' name="idx"					value="">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�̰���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>�������</td>
                    <td width=20%>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <%String car_gu = base.getCar_gu();%>
                <%String car_st = base.getCar_st();%>
                <tr>
                    <td class=title>��������</td>
                    <td>&nbsp;<%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%><b>�߰���</b><%}%></td>
                    <td class=title>�뵵����</td>
                    <td colspan='3'>&nbsp;<b><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></b></td>
                </tr>  
                <tr> 
                    <td class=title>��������</td>
                    <td colspan='5'>&nbsp;<%if(cont_etc.getMng_br_id().equals("")) cont_etc.setMng_br_id(base.getBrch_id());%>
        	        <select name='mng_br_id'>
                            <option value=''>����</option>
                            <%for (int i = 0 ; i < brch_size ; i++){
        			Hashtable branch = (Hashtable)branches.elementAt(i);%>
                            <option value='<%=branch.get("BR_ID")%>' <%if(cont_etc.getMng_br_id().equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                            <%}%>
                        </select></td>
                </tr>                
            </table>
	    </td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>
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
        		    <td width='13%' class='title'> ������ȣ </td>
        		    <td width="20%">&nbsp;<%=cr_bean.getCar_no()%> (<%=cr_bean.getCar_mng_id()%>)</td>
                <td class='title' width="10%">������ȣ</td>
        		    <td width="20%">&nbsp;<%=cr_bean.getCar_doc_no()%>&nbsp;(<%String car_ext = cr_bean.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>)</td>
        		    <td width="10%" class='title'><%if(cr_bean.getCar_use().equals("1")){%>���ɸ�����<%}else{%>���ʵ����<%}%></td>
        		    <td>&nbsp;<%if(cr_bean.getCar_use().equals("1")){%><font color=red><b><%=cr_bean.getCar_end_dt()%></b></font><%}else{%><%=cr_bean.getInit_reg_dt()%><%}%></td>
        	    </tr>		
    		    <tr>
        		    <td class='title'> �˻���ȿ�Ⱓ </td>
        		    <td>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%></b></td>
                	<td class='title'>������ȿ�Ⱓ</td>
        		    <td colspan='3'>&nbsp;<b><%=cr_bean.getTest_st_dt()%>~<%=cr_bean.getTest_end_dt()%></b></td>
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
                    <td class='title'>�����ڵ�</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>��ⷮ</td>
                    <td>&nbsp;<%if(cr_bean.getCar_mng_id().equals("")){%><%=cm_bean.getDpm()%>cc<%}else{%><%=cr_bean.getDpm()%>cc<%}%></td>
                </tr>
                <tr>
                    <td class='title'>�ɼ�</td>
                    <td colspan="5">&nbsp;
        			          <%=car.getOpt()%></td>
                </tr>
                <tr>
                    <td class='title'>����</td>
                    <td colspan="5">&nbsp;                        
        			  <input type='text' name='color' size='45' maxlength='100' class='text' value='<%=car.getColo()%>'>
					  &nbsp;&nbsp;&nbsp;
					  (�������(��Ʈ): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'> )  
					  &nbsp;&nbsp;&nbsp;
					  (���Ͻ�: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'> )  
        			  </td>
                </tr>	
                <tr>
                	<td class="title">����</td>
                	<td colspan="5">
                		&nbsp;<%=car.getConti_rat() %>
                	</td>
                </tr>
                <tr>
                	<td class="title">����������</td>
                	<td>
                		&nbsp;<input type='text' name='accid_serv_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getAccid_serv_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        		��
                	<td class="title">�����</td>
                	<td colspan='3'>
                		&nbsp;<input type='text' name="accid_serv_cont" size='50' class='text' value='<%=car.getAccid_serv_cont()%>'>
                	</td>
                </tr>  
                <tr>
                	<td class="title">�����ܰ��ݿ�</td>
                	<td>
                		&nbsp;<input type='text' name="jg_col_st" size='5' class='text' value='<%=car.getJg_col_st()%>'>
                	</td>
                	<td class="title">����ܰ��ݿ�</td>
                	<td colspan='3'>
                		&nbsp;<input type='text' name="jg_opt_st" size='5' class='text' value='<%=car.getJg_opt_st()%>'>
                	</td>
                </tr>  
                <!--
                <tr>
                	<td class="title">TUIX/TUONƮ������</td>
                	<td>
                		&nbsp;<input type='text' name="jg_tuix_st" size='5' class='text' value='<%=car.getJg_tuix_st()%>'>
                	</td>
                	<td class="title">TUIX/TUON�ɼǿ���</td>
                	<td colspan='3'>
                		&nbsp;<input type='text' name="jg_tuix_opt_st" size='5' class='text' value='<%=car.getJg_tuix_opt_st()%>'>
                	</td>
                </tr>
                -->
                <tr>
                    <td class='title'>�����μ���</td>
                    <td colspan="3">&nbsp;
                        <select name="udt_st">
                        <option value=''>����</option>
        				    <option value="1" <%if(pur.getUdt_st().equals("1"))%> selected<%%>>���ﺻ��</option>
        		        <option value="2" <%if(pur.getUdt_st().equals("2"))%> selected<%%>>�λ�����</option>
                		<option value="3" <%if(pur.getUdt_st().equals("3"))%> selected<%%>>��������</option>				
        		        <option value="5" <%if(pur.getUdt_st().equals("5"))%> selected<%%>>�뱸����</option>
                		<option value="6" <%if(pur.getUdt_st().equals("6"))%> selected<%%>>��������</option>				
                		<option value="4" <%if(pur.getUdt_st().equals("4"))%> selected<%%>>��</option>
                      </select>
        			  </td>
                    <td class='title'>�������</td>
                    <td colspan="3">&nbsp;
                      <select name="car_ext">
                    <option value=''>����</option>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(car.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select></td>
                </tr>
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='5' cols='90' name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_car1 style="display:<%if(!base.getCar_gu().equals("0")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>��������</td>
                    <td colspan="3">&nbsp;
                      <select name="purc_gu">
                        <option value=''>����</option>
                        <option value='1' <%if(car.getPurc_gu().equals("1")){%> selected <%}%>>����</option>
                        <option value='0' <%if(car.getPurc_gu().equals("0")){%> selected <%}%>>�鼼</option>
                      </select></td>
                    <td class='title'>��ó</td>
                    <td colspan="3">&nbsp;
        			  <%String car_origin = car.getCar_origin();%>
        			  <%if(car_origin.equals("")){
        			  		if(!cm_bean.getCar_comp_id().equals("")){
        						code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
        					}
        					car_origin = code_bean.getApp_st();
        				}%>
        			<select name="car_origin">
                        <option value="">����</option>
                        <option value="1" <%if(car_origin.equals("1")){%> selected <%}%>>����</option>
                        <option value="2" <%if(car_origin.equals("2")){%> selected <%}%>>����</option>
                      </select></td>
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
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_c_amt()" onMouseOver="window.status=''; return true" title="�Һ��ڰ� �հ� ����ϱ�">�հ�</a></span></td>
                    <td width="13%" class='title'>���ް�</td>
                    <td width="12%" class='title'>�ΰ���</td>
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_f_amt()" onMouseOver="window.status=''; return true" title="���԰� �հ� ����ϱ�">�հ�</a></span>&nbsp;<span class="b"><a href="javascript:sum_car_f_amt2()" onMouseOver="window.status=''; return true" title="���԰� ����ϱ�">���</a></span></td>
                </tr>
                <tr>
                    <td class='title'> �⺻����</td>
                    <td>&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title>�Ÿűݾ�</td>
                    <td>&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                </tr>
                <tr>
                    <td height="12" class='title'>�ɼ�</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                <td class=title>�߰�������</td>
                <td height="12">&nbsp;
                  <input type='text' name='commi_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td height="12">&nbsp;
                  <input type='text' name='commi_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_v_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td height="12">&nbsp;
                  <input type='text' name='commi_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt()+car.getCommi_v_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                </tr>
                <tr>
                    <td height="26" class='title'> ����</td>
                    <td>&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                                <td class=title>������</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_v_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt()+car.getStorage_v_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                </tr>           
                <tr>
                    <td align="center" class='title_p'>�հ�</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    ��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                    <td align='center' class='title_p'>�հ�</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
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
		
				sh_car_amt 		= fee_etc.getSh_car_amt();
				sh_year 		= fee_etc.getSh_year();
				sh_month 		= fee_etc.getSh_month();
				sh_day	 		= fee_etc.getSh_day();
				sh_amt			= fee_etc.getSh_amt();
				sh_ja			= fee_etc.getSh_ja();
				sh_km			= fee_etc.getSh_km();
				sh_tot_km		= fee_etc.getSh_tot_km();
				sh_km_bas_dt	= fee_etc.getSh_km_bas_dt();
				sh_init_reg_dt	= fee_etc.getSh_init_reg_dt();
				sh_day_bas_dt	= fee_etc.getSh_day_bas_dt();
				if(sh_tot_km==0) sh_tot_km = a_db.getSh_tot_km(base.getCar_mng_id(), fee_etc.getSh_km_bas_dt());
				
				if(sh_year.equals("")){
					sh_year 	= String.valueOf(carOld.get("YEAR"));
					sh_month 	= String.valueOf(carOld.get("MONTH"));
					sh_day	 	= String.valueOf(carOld.get("DAY"));
					
				}
	%>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> �����Һ��ڰ� </td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(sh_car_amt)%>'size='10' class='defaultnum' >
        				  �� 
        				  <input type='hidden' name="view_car_amt" value=""></td>
                    <td class='title' width="10%">�ܰ���</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher(sh_ja,2) %>'size='4' class='defaultnum' >
					  %</td>
                    <td class='title' width='10%'>�縮��������</td>
                  <td>&nbsp;
                    <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(sh_amt) %>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>
					  ��
					  </td>
                </tr>
                <tr>
                  <td class='title'>����</td>
                  <td colspan="3">&nbsp;
                    <input type='text' name='sh_year' value='<%=sh_year%>'size='1' class='white' >
                    ��
                    <input type='text' name='sh_month' value='<%=sh_month%>'size='2' class='white' >
                    ����
                    <input type='text' name='sh_day' value='<%=sh_day%>'size='2' class='white' >
                    �� (���ʵ����
                    <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(sh_init_reg_dt)%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    ~�����
                    <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%>'size='11' class='white' >
                    )
				            </td>
                    <td class='title' width='10%'>�����ü�</td>
                    <td>&nbsp;
                      <input type='text' name='sh_est_amt' value='<%= AddUtil.parseDecimal(car.getSh_est_amt()) %>' size='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      �� 
                    </td>
                </tr>
                <tr>				  
                  <td class='title'>��������Ÿ�</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(sh_km) %>' class='defaultnum' >
					  km 
					  
                       &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="javascript:getSecondhandCarAmt_h();"><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0></a>
                        ( �߰��� ���ʵ���ϰ� ����Ÿ��� �Է��ϰ� Ȯ���� Ŭ���ϸ� ��� �縮�������� ����մϴ�. )					  
					 </td>
                </tr>

            </table>
	    </td>
    </tr>                        
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>��������</td>
                    <td width="20%">&nbsp;
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                      </select></td>
                    <td width="10%"  class=title>�Ǻ�����</td>
                    <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' onChange='javascript:display_ip()'>
                          <option value="">����</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <!--  <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>-->
                      </select></td>
                </tr>            
                <tr> 
                    <td width="13%" class=title>�����ڹ���</td>
                    <td width="20%" class=''>&nbsp;
        			<select name='driving_ext'>
                          <option value="">����</option>
                          <option value="1" <%if(base.getDriving_ext().equals("1")){%> selected <%}%>>�����</option>
                          <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>��������</option>
                          <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>��Ÿ</option>
                      </select>
        			</td>
                    <td width="10%" class=title >�����ڿ���</td>
                    <td width="20%">&nbsp;
                        <select name='driving_age'>
                          <option value="">����</option>
                          <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26���̻�</option>
                          <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24���̻�</option>
                          <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21���̻�</option>
                          <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>��������</option>
					  <option value=''>=�Ǻ����ڰ�=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30���̻�</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35���̻�</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43���̻�</option>						
					  <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48���̻�</option>					  						  
					  <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>22���̻�</option>					  						  
					  <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>22���̻�</option>					  						  
					  <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>35������~49������</option>					  						  
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a></td>
                <td class=title >��������������Ư��</td>
                <td class=''>&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">����</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                  </select>
                  
                  </td>                        
                </tr>
                <tr>
                    <td class=title>���ι��</td>
                    <td>&nbsp; ����(���ι��,��)</td>
                    <td class=title>�빰���</td>
                    <td class=''>&nbsp;
                        <select name='gcp_kd'>
                          <option value="">����</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1���</option>
						  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2���</option>
						  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3���</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5���</option>						  
                      </select></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td class=''>&nbsp;
                        <select name='bacdt_kd'>
                          <option value="">����</option>
                          <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                          <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1���</option>
                          <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>�̰���</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>������������</td>
                    <td>&nbsp;
                      <select name='canoisr_yn'>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getCanoisr_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>            </td>
                    <td class=title>�ڱ���������</td>
                    <td class=''>&nbsp;
                      <select name='cacdt_yn'>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>              </td>
                    <td class=title >����⵿</td>
                    <td class=''>&nbsp;
                      <select name='eme_yn'>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getEme_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getEme_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select></td>
                </tr>
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='3' cols='90' name='others'><%=base.getOthers()%></textarea></td>
                </tr>
            </table>
        </td>
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
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>
        		    </td>
                    <td width="10%" class='title'>��ȣ/�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>
                      <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
					  </td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp1.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
              <tr>
                <td class='title'>�������</td>
                <td >&nbsp;
                  <input type='text' name='sh_base_dt' value='<%= AddUtil.ChangeDate2(emp1.getSh_base_dt())%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
                <td class='title'>�߰�������</td>
                <td colspan='3'>&nbsp;
                  <input type='text' name='commi' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
              </tr>
              <tr>
                <td class='title'>���ݰ�꼭����</td>
                <td >&nbsp;
                  <input type='text' name='file_gubun1' value='<%= AddUtil.ChangeDate2(emp1.getFile_gubun1())%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  (������)
    			</td>
                <td class='title'>������</td>
                <td colspan='3'>&nbsp;
                  <input type='text' name='dlv_con_commi' value='<%=AddUtil.parseDecimal(emp1.getDlv_con_commi())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			</td>
              </tr>              
                
                <tr>
                    <td class='title'>�����</td>
                    <td >&nbsp;
                    	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
        		      <select name='emp_bank_cd'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        											CodeBean bank = banks[i];
        											//�ű��ΰ�� �̻������ ����
															if(bank.getUse_yn().equals("N"))	 continue;
												%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        										}%>
                      </select>
        			</td>
                    <td class='title'>���¹�ȣ</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='text'>
        			</td>
                    <td class='title'>�����ָ�</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='text'>
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
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
        			        <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
                    </td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
					            <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
        			      </td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp2.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
              <tr>
                <td class='title'>�Ÿ�����</td>
                <td >&nbsp;
                  <input type='text' name='sh_base_dt' value='<%= AddUtil.ChangeDate2(emp2.getSh_base_dt())%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
                <td class='title'>�Ÿűݾ�</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='commi' value='<%=AddUtil.parseDecimal(emp2.getCommi())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			</td>
              </tr>
              <tr>
                <td class='title'>��������ȣ</td>
                <td >&nbsp;
                  <input type='text' name='est_car_no' value='<%=pur.getEst_car_no()%>' class='text' maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
    		    </td>
                <td class='title'>�����ȣ</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='car_num' value='<%=pur.getCar_num()%>' class='text' maxlength='20' size='20' onBlur='javascript:this.value=this.value.toUpperCase()'>
    			</td>
              </tr>
              <tr>				
                <td class='title'>����</td>
                <td>&nbsp;
				  <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��	
    			</td>				
                <td class='title'>�������</td>				
                <td colspan="3">&nbsp;
					<select name='con_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                    </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					������ : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
    			</td>				
              </tr>		  		  
            </table>
        </td>
    </tr>
    <tr>
	    <td>&nbsp;</td>
    </tr>		
    <tr>
	      <td align='center'>	

            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            
            
	              <%	if(base.getReg_step().equals("4") || base.getReg_step().equals("0")){%>	
	                  <% if(user_id.equals("000000") || base.getBus_id().equals(ck_acar_id) || base.getBus_id2().equals(ck_acar_id) || base.getReg_id().equals(ck_acar_id) || nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id)){%>
	                  &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:update(99);" title='��ü �����ϱ�'><img src=/acar/images/center/button_all_modify.gif align=absmiddle border=0></a>
	                  <% }%>
	              <%	}%>
            
		
	              <%	if(nm_db.getWorkAuthUser("������",ck_acar_id)){%>
	                  <%		if(base.getUse_yn().equals("")){%>
	                      &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:rent_delete();" title='��� �����ϱ�'>[����]</a>
	                  <%		}%>
	              <%	}%>
			    
	          <%}%>
		
        </td>
    </tr>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	    <td>&nbsp;</td>
    </tr>		
    <tr>
        <td align='right'>
	        <%if(nm_db.getWorkAuthUser("������",ck_acar_id) || (base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("3")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("3"))){%>	  
	          <a href="lc_reg_step4_ac.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
          <%}%>
          <%if(nm_db.getWorkAuthUser("������",ck_acar_id)){%>            
            <a href="lc_c_frame.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>	  	   
          <%}%>
	</td>	
    </tr>	
    <%}%>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	var fm = document.form1;
	sum_car_c_amt();
	sum_car_f_amt();

	//�ٷΰ���
	var s_fm 	= parent.top_menu.document.form1;
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

//-->
</script>
</body>
</html>
