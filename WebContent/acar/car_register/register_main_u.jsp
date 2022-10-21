<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.cont.*,acar.common.*,acar.car_register.*,acar.car_mst.*"%>
<%@ page import="acar.cus_reg.*, acar.insur.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�������� ũ���� ��� �Ǻ�		2018.03.05
	String ua = request.getHeader("User-Agent");
	boolean isChrome = false;
	if(ua.contains("Chrome")){
		isChrome = true;
	}

	//�ڵ������� ����,��ȸ ������
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CusReg_Database cr_db = CusReg_Database.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd	 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	// �������� > ������ϰ��� > �ڵ����������� ���� ���� �������� > ������� > ��ǰ�غ��Ȳ���� ���� ��츦 �������� ���� �߰�		2017. 12. 08
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	/*�ٷΰ���*/
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	if(!rent_mng_id.equals("") && m_id.equals("")) m_id = rent_mng_id;
	if(!rent_l_cd.equals("")   && l_cd.equals("")) l_cd = rent_l_cd;
	if(!car_mng_id.equals("")  && c_id.equals("")) c_id = car_mng_id;
	
	ContBaseBean base = a_db.getContBaseAll(m_id, l_cd);
	
	if(c_id.equals(""))			c_id = base.getCar_mng_id();
	if(client_id.equals(""))	client_id = base.getClient_id();
	
	
	
	//��������	
	cr_bean = crd.getCarRegBean(car_mng_id);
		
	//��������
	InsDatabase ai_db = InsDatabase.getInstance();
	String ins_st = ai_db.getInsSt(car_mng_id);
	ins = ai_db.getIns(car_mng_id, ins_st);
	ins_st = ins_st ==null?"0":ins_st;
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(m_id, l_cd);
	
		
	
	
	//�ڵ���ȸ��&����&�ڵ�����	
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = a_cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));

	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
			
	String m1_dt = "";

	m1_dt =  cr_db.getMaster_dt(car_mng_id);
	
  	//�����������
  	CodeBean[] code32 = c_db.getCodeAll3("0032");
  	int code32_size = code32.length;
  	
	//�����ڵ�
	CodeBean[] code39 = c_db.getCodeAll2("0039", "Y");
	int code39_size = code39.length;  
	

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//�����ϱ�
	function CarRegUp(){
		var theForm = document.CarRegForm;	
		
		if(!CheckInputField()){			return;	}	
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "u";
		theForm.action = "register_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}
	//����ȭ��
	function CarRegUpDisp(){
		var theForm = document.CarRegForm;	
		theForm.cmd.value = "udp";
		theForm.action = "./register_frame.jsp";
		theForm.target = "d_content"
		theForm.submit();
	}

	function OpenIns(){
		var theForm = document.CarRegForm;
		<%if(ins.getCar_mng_id().equals("")){%>
		var url = "/acar/ins_reg/ins_reg_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&c_id=<%=car_mng_id%>&go_url=car_register";
		<%}else{%>		
		var url = "/acar/ins_mng/ins_u_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&c_id=<%=car_mng_id%>&ins_st=<%=ins_st%>&go_url=car_register&cmd=view";		
		<%}%>				
		window.open(url, "Ins", "left=100, top=50, width=1050, height=710, scrollbars=no");		

	}
	
	function OpenService(){
	   var theForm = document.CarRegForm;
	
	   var url = "/acar/cus0401/cus0401_d_sc_carhis_s.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=car_mng_id%>&go_url=car_search";				
			   	
	   theForm.action = url;
	   theForm.target = "c_foot";
	   theForm.submit();
	    
	}
	
	function OpenAccident(){
	   var theForm = document.CarRegForm;
	   var url = "/acar/accid_mng/accid_s_sc.jsp?gubun2=5&s_kd=99&t_wd=<%=car_mng_id%>&sh_height=450";		
			   	
	   theForm.action = url;
	   theForm.target = "c_foot";
	   theForm.submit();
	
	}

	function FootWin(arg){
		var theForm = document.CarRegForm;
		if(theForm.cmd.value=='id'){	alert("���ȭ���� ����� �ϴ� �޴��� ����Ͻʽÿ�.");	return;	}	
		if(arg == 'HIS'){			theForm.action = "register_his_id.jsp";
		}else if(arg == 'PUR'){		theForm.action = "register_pur_id.jsp";		
		}else if(arg == 'SER'){		theForm.action = "register_service_id.jsp";				
		}else if(arg == 'CHA'){		theForm.action = "register_change_id.jsp";	
		}else if(arg == 'ACQ'){		theForm.action = "register_acquisition_id.jsp";
		}else if(arg == 'GEN'){		theForm.action = "/fms2/car_reg/register_gen_id.jsp";
		}else if(arg == 'MORT'){	theForm.action = "register_mort_id.jsp";
		}else if(arg == 'KEY'){		theForm.action = "register_key_id.jsp";		
		}	
		theForm.target = "c_foot";
		theForm.submit();
	}

	function ChangeMortDT(){
		var theForm = document.CarRegForm;
		theForm.mort_dt.value = ChangeDate(theForm.mort_dt.value);
	}

	function CheckInputField(){
		var theForm = document.CarRegForm;
		if(theForm.car_no.value==""){		alert("�ڵ���������ȣ�� �Է��Ͻʽÿ�"); theForm.car_no.focus(); return false; }
		if(theForm.car_num.value==""){		alert("�����ȣ�� �Է��Ͻʽÿ�"); theForm.car_num.focus(); return false; }
		if(theForm.car_num.value.length != 17){		alert("�����ȣ�� 17�ڸ��Դϴ�. Ȯ�����ּ���!"); theForm.car_num.focus(); return false; }		
		if(theForm.init_reg_dt.value==""){	alert("���ʵ������ �Է��Ͻʽÿ�."); theForm.init_reg_dt.focus(); return false; }
		if(theForm.car_nm.value==""){		alert("������ �Է��Ͻʽÿ�."); theForm.car_nm.focus(); return false; }
	//	if(theForm.car_form.value==""){		alert("������ �Է��Ͻʽÿ�."); theForm.car_form.focus(); return false; }
		if(theForm.car_y_form.value==""){	alert("������ �Է��Ͻʽÿ�."); theForm.car_y_form.focus(); return false; }
	//	if(theForm.mot_form.value==""){		alert("������������ �Է��Ͻʽÿ�."); theForm.mot_form.focus(); return false; }
	
		<%if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){ //������,������%>
		<%}else{%>
		if(theForm.dpm.value==""){  		alert("��ⷮ�� �Է��Ͻʽÿ�."); theForm.dpm.focus(); return false; }
		if(!isNum(theForm.dpm.value)){  	alert("��ⷮ�� ���ڸ� �Է��ϼ���."); 		theForm.dpm.focus(); return false; }
		<%}%>
		
		if(theForm.taking_p.value==""){		alert("���������� �Է��Ͻʽÿ�."); theForm.taking_p.focus(); return false; }
		if(theForm.fuel_kd.value==""){		alert("������ ������ �Է��Ͻʽÿ�."); theForm.fuel_kd.focus(); return false; }
		if(theForm.conti_rat.value==""){	alert("���� �Է��Ͻʽÿ�."); theForm.conti_rat.focus(); return false; }
		
		<%if(car.getCar_origin().equals("2")){//������%>
		if(toInt(parseDigit(theForm.import_car_amt.value)) >0 && theForm.import_tax_dt.value ==''){
			alert("�������Ű����� �Է��Ͻʽÿ�."); 	theForm.import_tax_dt.focus(); return false; 
		}
		<%}%>

		//�������ϴ� �����Һ��ڰ��� �����Һ񼼰������� �Է� �˻�
		<%if(ej_bean.getJg_w().equals("1") || ej_bean.getJg_w().equals("2")){//������%>
			if(toInt(parseDigit(theForm.import_car_amt.value)) > <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt()%> ){
				alert("���������������� �����Һ��ڰ����� Ŭ �� �����ϴ�. �ݾ� Ȯ���Ͻʽÿ�."); return false;
			}
		<%}%>		
				
		return true;
	}

	//��ϰ���
	function go_to_list(){
		if(document.CarRegForm.from_page.value == "rbs"){	// �������� > ������� > ��ǰ�غ��Ȳ���� �����ϴ� ���
			parent.location='/fms2/car_pur/rent_board_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>';
		}else {	// �������� > ������ϰ��� > �ڵ����������� �����ϴ� ���
			parent.location='register_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>';	
		}
		
	}
	
	function go_to_list_cus0403(){
		parent.location='/acar/cus0403/cus0403_s_frame.jsp';
	}

	function loan_set(){
		var fm = document.CarRegForm;
		fm.loan_s_rat.value = parseFloatCipher3(toFloat(parseDigit(fm.loan_s_amt.value)) / toFloat(parseDigit(fm.loan_b_amt.value))*100, 1);
	}	
	
	function get_makedYear(val){
		if(val.length == 17){
			var fm = document.CarRegForm;
			var str = val.substr(9,1);
			var year = "";
			
			if(		    str=="A"){	year = "2010";	}else if(str=="B"){	year = "2011";	}else if(str=="C"){	year = "2012";	}
			else if(	str=="D"){	year = "2013";	}else if(str=="E"){	year = "2014";	}else if(str=="F"){	year = "2015";	}
			else if(	str=="G"){	year = "2016";	}else if(str=="H"){	year = "2017";	}else if(str=="J"){	year = "2018";	}
			else if(	str=="K"){	year = "2019";	}else if(str=="L"){	year = "2020";	}else if(str=="M"){	year = "2021";	}
			else if(	str=="N"){	year = "2022";	}else if(str=="P"){	year = "2023";	}else if(str=="R"){	year = "2024";	}
			else if(	str=="S"){	year = "2025";	}else if(str=="T"){	year = "2026";	}else if(str=="V"){	year = "2027";	}
			else if(	str=="W"){	year = "2028";	}else if(str=="X"){	year = "2029";	}else if(str=="Y"){	year = "2030";	}
			else if(	str=="1"){	year = "2031";	}else if(str=="2"){	year = "2032";	}else if(str=="3"){	year = "2033";	}
			else if(	str=="4"){	year = "2034";	}else if(str=="5"){	year = "2035";	}else if(str=="6"){	year = "2036";	}
			else if(	str=="7"){	year = "2037";	}else if(str=="8"){	year = "2038";	}else if(str=="9"){	year = "2039";	}
			else{	alert("�����ȣ ���Է����� ������ �ڵ��Է� �� �� �����ϴ�. �����ȣ Ȯ�����ּ���.");	return false;	}
			
			fm.car_y_form.value = year;
		}	
	}
//-->
</script>
</head>
<body leftmargin="15">

<form action="register_null_ui.jsp" name="CarRegForm" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="acq_std" value="<%=cr_bean.getAcq_std()%>">
<input type="hidden" name="acq_acq" value="<%=cr_bean.getAcq_acq()%>">
<input type="hidden" name="acq_f_dt" value="<%=cr_bean.getAcq_f_dt()%>">
<input type="hidden" name="acq_ex_dt" value="<%=cr_bean.getAcq_ex_dt()%>">
<input type="hidden" name="acq_re" value="<%=cr_bean.getAcq_re()%>">
<input type="hidden" name="acq_is_p" value="<%=cr_bean.getAcq_is_p()%>">
<input type="hidden" name="acq_is_o" value="<%=cr_bean.getAcq_is_o()%>">
<input type="hidden" name="mort_st" value="<%=cr_bean.getMort_st()%>">
<input type="hidden" name="mort_dt" value="<%=cr_bean.getMort_dt()%>">
<input type="hidden" name="acq_amt_card" value="<%=cr_bean.getAcq_amt_card()%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="isChrome" id="isChrome" value="<%=isChrome%>"><!-- �������� ũ������ �ƴ��� �Ǻ� 2018.03.05 -->
<input type="hidden" name="car_size" id="car_size" value="<%=cm_bean.getJg_code()%>"><!-- ���� ���ÿ��� �ڵ��� �ڵ尡 8000 ���ϴ� �¿���, 8000 �ʰ� 9000 ���ϴ� ������, 9000 �ʰ��� ȭ�������� ���� ���� 2018.03.05 -->


<%	if(cmd.equals("ud")){ //����%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �ڵ������� > <span class=style5>�ڵ�������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right">
        <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:CarRegUpDisp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify_s.gif" align="absmiddle" border="0"></a>&nbsp; 
        <%	}%>
		<% if(st.equals("cus0403")){%>
			<a href="javascript:go_to_list_cus0403()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>	
		<% }else{ %>		
	        <a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>	
		<% } %>

        </td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>���ʵ����</td>
                    <td width=23%>&nbsp; 
                      <input type="text" name="init_reg_dt" value="<%=cr_bean.getInit_reg_dt()%>" size="10" class=whitetext  maxlength="10">
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=23%>&nbsp;
                      <%if( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���������",user_id) || (cr_bean.getInit_reg_dt().length()>6 && AddUtil.replace(cr_bean.getInit_reg_dt(),"-","").substring(0,6).equals(AddUtil.getDate(5))) ){ %>
                      <select name="car_ext"  class='red'>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(cr_bean.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                      	
                      </select>
                      <%}else{%>
                        <%=c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())%> 
                        <input type="hidden" name="car_ext" value="<%=cr_bean.getCar_ext()%>">
                      <%}%>
                    </td>
                    <td class=title width=10%>������ȣ</td>
                    <td width=24%>&nbsp; 
                      <input type="text" name="car_doc_no" value="<%=cr_bean.getCar_doc_no()%>" size="10" class=whitetext  maxlength="10">
                    </td>			
                </tr>
                <tr> 
                    <td class=title>�ڵ�����ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="car_no" value="<%=cr_bean.getCar_no()%>" size="15" class=whitetext maxlength="15">
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp;
                      <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>                            
                    </td>
                    <td class=title>�뵵</td>
                    <td>&nbsp; 
                      <select name="car_use" disabled>
                        <option value="1" <%if(cr_bean.getCar_use().equals("1"))%> selected<%%>>������</option>
                        <option value="2" <%if(cr_bean.getCar_use().equals("2"))%> selected<%%>>�ڰ���</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[������]<%}%><%=mst.getCar_nm()%> <%=mst.getCar_name()%> 
                      <input type="hidden" name="car_nm" value="<%=mst.getCar_nm()%>">
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_form" value="<%=cr_bean.getCar_form()%>" size="15" class=whitetext>
                    </td>
                    <td class=title>�𵨿���</td>
                    <td>&nbsp; 
                      <input type="text" name="car_y_form" value="<%=cr_bean.getCar_y_form()%>" size="6" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�����ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="car_num" value="<%=cr_bean.getCar_num()%>" size="20" class=whitetext maxlength="20" onblur="javascript:get_makedYear(this.value);">
                    </td>
                    <td class=title>����������</td>
                    <td>&nbsp; 
                      <input type="text" name="mot_form" value="<%=cr_bean.getMot_form()%>" size="30" class=whitetext>
                    </td>
                    <td class=title style="font-size : 8pt;">GPS��ġ������ġ</td>
                    <td>&nbsp; 
                      <%if(cr_bean.getGps().equals("Y")){%>����<%}else{%>������<%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>��ⷮ</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="dpm" value="<%=cr_bean.getDpm()%>" size="4" class=whitetext>
                      cc </td>
                    <td class=title width=10%>��������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="taking_p" value="<%=cr_bean.getTaking_p()%>" size="2" class=whitetext>
                      �� </td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="car_length" value="<%=cr_bean.getCar_length()%>" size="6" class=whitenum>
                      mm </td>
                    <td class=title width=10%>�ʺ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="car_width" value="<%=cr_bean.getCar_width()%>" size="6" class=whitenum>
                      mm </td>  
                    
                </tr>
                <tr> 
                    <td class=title>����������</td>
                    <td colspan="3">&nbsp; 
                      <%=c_db.getNameByIdCode("0039", "", cr_bean.getFuel_kd())%>                      
                      (����: 
                      <input type="text" name="conti_rat" value="<%=cr_bean.getConti_rat()%>" size="4" class=whitetext>
                      km/L) &nbsp; </td>
                    <td class=title>Ÿ�̾�</td>
                    <td>&nbsp; 
                      <input type="text" name="tire" value="<%=cr_bean.getTire()%>" size="20" class=whitetext>
                    </td>  
                    <td class=title>�ִ����緮</td>
                    <td>&nbsp; 
                      <input type="text" name="max_kg" value="<%=cr_bean.getMax_kg()%>" size="4" class=whitetext>kg
                    </td>			  
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span>&nbsp;&nbsp;
    	<% if (!m1_dt.equals("") ){ %>���� ��Ź�˻� �Ƿ���:<%=m1_dt%><%}%>         
        </td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td width=23%>&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=cr_bean.getMaint_st_dt()%>" size="10" class=whitetext>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=cr_bean.getMaint_end_dt()%>" size="10" class=whitetext>
                      &nbsp; </td>
                    <td class=title width=10%>�Ϲݼ�����</td>
                    <td width=23%>&nbsp; 
                      <input type="text" name="guar_gen_y" value="<%=cr_bean.getGuar_gen_y()%>" size="4" class=whitetext>
                      �� 
                      <input type="text" name="guar_gen_km" value="<%=cr_bean.getGuar_gen_km()%>" size="8" class=whitetext>
                      km </td>
                    <td class=title width=10%>����������</td>
                    <td width=24%>&nbsp; 
                      <input type="text" name="guar_endur_y" value="<%=cr_bean.getGuar_endur_y()%>" size="4" class=whitetext>
                      �� 
                      <input type="text" name="guar_endur_km" value="<%=cr_bean.getGuar_endur_km()%>" size="8" class=whitetext>
                      km </td>
                </tr>
                <tr> 
                    <td class=title>���ʵ�Ϲ�ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="first_car_no" value="<%=cr_bean.getFirst_car_no()%>" size="15" class=whitetext  maxlength="15">
                    </td>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=cr_bean.getCar_end_dt()%>" size="10" class=whitetext>
                      &nbsp;2ȸ��������: <input type="text" name="car_end_yn" value="<%=cr_bean.getCar_end_yn()%>" size="1" class=whitetext>                     
                    </td>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td>&nbsp; 
                      <input type="text" name="test_st_dt" value="<%=cr_bean.getTest_st_dt()%>" size="10" class=whitetext>
                      ~&nbsp; 
                      <input type="text" name="test_end_dt" value="<%=cr_bean.getTest_end_dt()%>" size="10" class=whitetext>
                    </td>
                </tr>
                <%if(ej_bean.getJg_w().equals("1") || ej_bean.getJg_w().equals("2")){//������%>
                <tr> 
                    <td class=title>��������������</td>
                    <td>&nbsp;
                      <input type="text" name="import_car_amt" value="<%=Util.parseDecimal(cr_bean.getImport_car_amt())%>" size="10" class=whitenum onBlur='javscript:this.value=parseDecimal(this.value);'>
                    ��</td>
                    <td class=title>����������</td>
                    <td>&nbsp; 
                      ����
                      <input type="text" name="import_tax_amt" value="<%=Util.parseDecimal(cr_bean.getImport_tax_amt())%>" size="10" class=whitenum onBlur='javscript:this.value=parseDecimal(this.value);'>
                    ��,
                    �����Һ�
                      <input type="text" name="import_spe_tax_amt" value="<%=Util.parseDecimal(cr_bean.getImport_spe_tax_amt())%>" size="10" class=whitenum onBlur='javscript:this.value=parseDecimal(this.value);'>
                    ��
                    </td>
                    <td class=title>�������Ű���</td>
                    <td>&nbsp; 
                      <input type="text" name="import_tax_dt" value="<%=AddUtil.ChangeDate2(cr_bean.getImport_tax_dt())%>" size="10" class=whitetext>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    (���ԽŰ�����)
                    </td>
                </tr>                
                <%}else{%>
                <input type='hidden' name="import_car_amt" value="<%=cr_bean.getImport_car_amt()%>">
                <input type='hidden' name="import_tax_amt" value="<%=cr_bean.getImport_tax_amt()%>">
                <input type='hidden' name="import_tax_dt" value="<%=cr_bean.getImport_tax_dt()%>">
                <input type='hidden' name="import_spe_tax_amt" value="<%=cr_bean.getImport_spe_tax_amt()%>">
                <%}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ϼ�����(�ݾ�)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width=10% class=title>��ä(ä��)����</td>
                    <td width=15%>&nbsp; 
                      <select name="loan_st"  disabled>
                        <option value="1" <%if(cr_bean.getLoan_st().equals("1"))%> selected<%%>>����ö��ä(ä��)</option>
                        <option value="2" <%if(cr_bean.getLoan_st().equals("2"))%> selected<%%>>�������߰�ä(ä��)</option>
                      </select>
                    </td>
                    <td width=10% class=title>��ä���Խ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="loan_b_amt" value="<%=Util.parseDecimal(cr_bean.getLoan_b_amt())%>" size="8" class=whitenum>
                      ��</td>
                    <td width=10% class=title>��ä���ν�</td>
                    <td width=16%>&nbsp; 
                      <input type="text" name="loan_s_amt" value="<%=Util.parseDecimal(cr_bean.getLoan_s_amt())%>" size="8" class=whitenum  onBlur='javscript:loan_set();'>
                      �� </td>
                    <td width=10% class=title>��ä������</td>
                    <td width=14%>&nbsp; 
                      <input type="text" name="loan_s_rat" value="<%=cr_bean.getLoan_s_rat()%>" size="6" class=whitenum readonly>
                      % </td>
                </tr>
                <tr> 
                    <td class=title>��ϼ�</td>
                    <td>&nbsp; 
                      <input type="text" name="reg_amt" value="<%=Util.parseDecimal(cr_bean.getReg_amt())%>" size="8" class=whitenum>
                      �� </td>
                    <td class=title>��漼</td>
                    <td>&nbsp; 
                      <input type="text" name="acq_amt" value="<%=Util.parseDecimal(cr_bean.getAcq_amt())%>" size="8" class=whitenum>
                      ��</td>
                    <td class=title>��ȣ���ۺ�</td>
                    <td>&nbsp; 
                      <input type="text" name="no_m_amt" value="<%=Util.parseDecimal(cr_bean.getNo_m_amt())%>" size="8" class=whitenum>
                      �� </td>
                    <td class=title>��,������</td>
                    <td>&nbsp; 
                      <input type="text" name="stamp_amt" value="<%=Util.parseDecimal(cr_bean.getStamp_amt())%>" size="6" class=whitenum>
                      �� </td>
                </tr>
                <tr> 
                    <td class=title >��Ÿ</td>
                    <td >&nbsp; 
                      <input type="text" name="etc" value="<%=Util.parseDecimal(cr_bean.getEtc())%>" size="8" class=whitenum>
        			  �� </td>
                    <td class=title>��Ϻ�������</td>                    
                    <td  colspan=7 >&nbsp; 
                      <input type="text" name="reg_pay_dt" value="<%=cr_bean.getReg_pay_dt()%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                      </td>
			  
                </tr>
                <tr>                    
                    <td class=title>��ϼ�����</td>                    
                    <td >&nbsp;
					   <input type="checkbox" name="reg_amt_card" value="Y" <%if(cr_bean.getReg_amt_card().equals("Y"))%>checked<%%>> 
					    ī�����
        				 </td>
                    <td class=title>��ȣ�Ǵ�ݰ���</td>                    
                    <td  colspan=7 >&nbsp; 
                      <input type="checkbox" name="no_amt_card" value="Y" <%if(cr_bean.getNo_amt_card().equals("Y"))%>checked<%%>> 
					  ī�����
                      </td>
    			  
                </tr>
				
            </table>
        </td>
    </tr>
</table>
<%	}else{ //udp%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<%	if(cmd.equals("id")){%>
                    <span class=style1>�������� > �ڵ������� > <span class=style5>�ڵ��� ���</span>
                    <%	}else{%>
                    <span class=style1>�������� > �ڵ������� > <span class=style5>�ڵ��� ����</span>
                    <%	}%></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"> 
	  	<%//if(br_id.equals("S1") || br_id.equals(brch_id)){%> 	  
      	<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  	<a href="javascript:CarRegUp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp; 
	  	<%	}%>
   		<% 	if(st.equals("cus0403")){%>
			<a href="javascript:go_to_list_cus0403()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>	
		<% 	}else{ %>		
	        <a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>	
		<% 	} %>
		<%//}else{%>
	        <!--<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a>-->
		<%//}%>
        </td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>���ʵ����</td>
                    <td width=23%>&nbsp; 
                      <input type="text" name="init_reg_dt" value="<%if(cmd.equals("id")) out.println(Util.getDate()); else out.println(cr_bean.getInit_reg_dt());%>" size="10" class=text  maxlength="10" onBlur="javascript:CheckDate()">
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=23%>&nbsp; 
					<%if(nm_db.getWorkAuthUser("������",user_id)  || nm_db.getWorkAuthUser("���������",user_id) || (cr_bean.getInit_reg_dt().length()>6 && AddUtil.replace(cr_bean.getInit_reg_dt(),"-","").substring(0,6).equals(AddUtil.getDate(5)))){ %>
                      <select name="car_ext"  class='red'>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(cr_bean.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                              	
                      </select>
					  <%}else{%>					
					              <%=c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())%>
						            <input type="hidden" name="car_ext" value="<%=cr_bean.getCar_ext()%>">
					  <%}%>					
                    </td>
                    <td class=title width=10%>������ȣ</td>
                    <td width=24%>&nbsp; 
                      <input type="text" name="car_doc_no" value="<%=cr_bean.getCar_doc_no()%>" size="10" class=text  maxlength="10">
                    </td>			
                </tr>
                <tr> 
                    <td class=title>�ڵ�����ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="car_no" value="<%=cr_bean.getCar_no()%>" size="15" class=text maxlength="15">
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <select name="car_kd" id="car_kd">
                        <option value="1" id="big_pass" <%if(cr_bean.getCar_kd().equals("1"))%> selected<%%>>�����¿�</option>
                        <option value="2" id="mid_pass" <%if(cr_bean.getCar_kd().equals("2"))%> selected<%%>>�����¿�</option>
                        <option value="3" id="small_pass" <%if(cr_bean.getCar_kd().equals("3"))%> selected<%%>>�����¿�</option>
                        <option value="9" id="ssmall_pass" <%if(cr_bean.getCar_kd().equals("9"))%> selected<%%>>�����¿�</option>
                        <option value="4" id="mid_van" <%if(cr_bean.getCar_kd().equals("4"))%> selected<%%>>��������</option>
                        <option value="5" id="small_van" <%if(cr_bean.getCar_kd().equals("5"))%> selected<%%>>��������</option>
                        <option value="8" id="big_truck" <%if(cr_bean.getCar_kd().equals("8"))%> selected<%%>>����ȭ��</option>				
                        <option value="7" id="mid_truck" <%if(cr_bean.getCar_kd().equals("7"))%> selected<%%>>����ȭ��</option>
                        <option value="6" id="small_truck" <%if(cr_bean.getCar_kd().equals("6"))%> selected<%%>>����ȭ��</option>
                      </select>
                    </td>
                    <td class=title>�뵵</td>
                    <td>&nbsp; 
                      <select name="car_use">
                        <option value="1" <%if(cr_bean.getCar_use().equals("1"))%> selected<%%>>������</option>
                        <option value="2" <%if(cr_bean.getCar_use().equals("2"))%> selected<%%>>�ڰ���</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[������]<%}%><%=mst.getCar_nm()%> <%=mst.getCar_name()%> 
                      <input type="hidden" name="car_nm" value="<%=mst.getCar_nm()%>">
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_form" value="<%=cr_bean.getCar_form()%>" size="15" class=text>
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_y_form" value="<%=cr_bean.getCar_y_form()%>" size="6" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�����ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="car_num" value="<%=cr_bean.getCar_num()%>" size="20" class=text maxlength="20" onblur="javascript:get_makedYear(this.value);">
                    </td>
                    <td class=title>����������</td>
                    <td>&nbsp; 
                      <input type="text" name="mot_form" value="<%=cr_bean.getMot_form()%>" size="30" class=text>
                    </td>
                    <td class=title style="font-size : 8pt;">GPS��ġ������ġ</td>
                    <td>&nbsp; 
                      <select name='gps'>
                    <option value="">����</option>
                    <option value="Y" <% if(cr_bean.getGps().equals("Y")) out.print("selected");%>>����</option>
                    <option value="N" <% if(cr_bean.getGps().equals("N")) out.print("selected");%>>������</option>
                  </select>
                    </td>					
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>��ⷮ</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="dpm" value="<%=cr_bean.getDpm()%>" size="4" class=text>
                      cc</td>
                    <td class=title width=10%>��������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="taking_p" value="<%=cr_bean.getTaking_p()%>" size="2" class=text>
                      ��</td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="car_length" value="<%=cr_bean.getCar_length()%>" size="6" class=num>
                      mm </td>
                    <td class=title width=10%>�ʺ�</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="car_width" value="<%=cr_bean.getCar_width()%>" size="6" class=num>
                      mm </td>  
                </tr>
                <tr> 
                    <td class=title>����������</td>
                    <td colspan="3">&nbsp; 
                      <select name="fuel_kd">
                        <%for(int i = 0 ; i < code39_size ; i++){
                            CodeBean code = code39[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(cr_bean.getFuel_kd().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                           
                      </select>
                      (���� 
                      <input type="text" name="conti_rat" value="<%=cr_bean.getConti_rat()%>" size="4" class=text>
                      km/L)</td>
                    <td class=title>Ÿ�̾�</td>
                    <td>&nbsp; 
                      <input type="text" name="tire" value="<%=cr_bean.getTire()%>" size="20" class=text>
                    </td>                      
        			<td class=title>�ִ����緮</td>
                    <td>&nbsp; 
                        <input type="text" name="max_kg" value="<%=cr_bean.getMax_kg()%>" size="4" class=text>kg
                    </td>					  
                </tr>		  
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span>&nbsp;&nbsp;
    	<% if (!m1_dt.equals("") ){ %>���� ��Ź�˻� �Ƿ���:<%=m1_dt%><%}%> 
        </td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td width=23%>&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=cr_bean.getMaint_st_dt()%>" size="10" class=text>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=cr_bean.getMaint_end_dt()%>" size="10" class=text>
                      &nbsp; </td>
                    <td class=title width=10%>�Ϲݼ�����</td>
                    <td width=23%>&nbsp; 
                      <input type="text" name="guar_gen_y" value="<%=cr_bean.getGuar_gen_y()%>" size="4" class=text>
                      �� 
                      <input type="text" name="guar_gen_km" value="<%=cr_bean.getGuar_gen_km()%>" size="8" class=text>
                      km </td>
                    <td class=title width=10%>����������</td>
                    <td width=24%>&nbsp; 
                      <input type="text" name="guar_endur_y" value="<%=cr_bean.getGuar_endur_y()%>" size="4" class=text>
                      �� 
                      <input type="text" name="guar_endur_km" value="<%=cr_bean.getGuar_endur_km()%>" size="8" class=text>
                      km </td>
                </tr>
                <tr> 
                    <td class=title>���ʵ�Ϲ�ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="first_car_no" value="<%=cr_bean.getFirst_car_no()%>" size="15" class=whitetext maxlength="15">
                    </td>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=cr_bean.getCar_end_dt()%>" size="10" class=text>
                         &nbsp;2ȸ��������:  
                            <select name="car_end_yn">
                        <option value="" <%if(cr_bean.getCar_end_yn().equals(""))%>selected<%%>>����</option>
                        <option value="Y" <%if(cr_bean.getCar_end_yn().equals("Y"))%>selected<%%>>����</option>
                     </select>   
                    </td>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td>&nbsp; 
                      <input type="text" name="test_st_dt" value="<%=cr_bean.getTest_st_dt()%>" size="10" class=text>
                      ~ 
                      <input type="text" name="test_end_dt" value="<%=cr_bean.getTest_end_dt()%>" size="10" class=text>
                    </td>
                </tr>
                <%if(ej_bean.getJg_w().equals("1") || ej_bean.getJg_w().equals("2")){//������%>
                <tr> 
                    <td class=title>��������������</td>
                    <td>&nbsp;
                      <input type="text" name="import_car_amt" value="<%=Util.parseDecimal(cr_bean.getImport_car_amt())%>" size="10" class=num onBlur='javscript:this.value=parseDecimal(this.value);'>
                    ��</td>
                    <td class=title>����������</td>
                    <td>&nbsp; 
                      ����
                      <input type="text" name="import_tax_amt" value="<%=Util.parseDecimal(cr_bean.getImport_tax_amt())%>" size="10" class=num onBlur='javscript:this.value=parseDecimal(this.value);'>
                    ��,
                    �����Һ�
                      <input type="text" name="import_spe_tax_amt" value="<%=Util.parseDecimal(cr_bean.getImport_spe_tax_amt())%>" size="10" class=num onBlur='javscript:this.value=parseDecimal(this.value);'>
                    ��
                    </td>
                    <td class=title>�������Ű���</td>
                    <td>&nbsp; 
                      <input type="text" name="import_tax_dt" value="<%=AddUtil.ChangeDate2(cr_bean.getImport_tax_dt())%>" size="10" class=text>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    (���ԽŰ�����)
                    </td>                    
                </tr>                
                <%}else{%>
                <input type='hidden' name="import_car_amt" value="<%=cr_bean.getImport_car_amt()%>">
                <input type='hidden' name="import_tax_amt" value="<%=cr_bean.getImport_tax_amt()%>">
                <input type='hidden' name="import_tax_dt" value="<%=cr_bean.getImport_tax_dt()%>">
                <input type='hidden' name="import_spe_tax_amt" value="<%=cr_bean.getImport_spe_tax_amt()%>">
                <%}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ϼ�����(�ݾ�)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width=10% class=title>��ä(ä��)����</td>
                    <td width=15%>&nbsp; 
                        <select name="loan_st">
                            <option value="1" <%if(cr_bean.getLoan_st().equals("1"))%> selected<%%>>����ö��ä(ä��)</option>
                            <option value="2" <%if(cr_bean.getLoan_st().equals("2"))%> selected<%%>>�������߰�ä(ä��)</option>
                        </select>
                    </td>
                    <td width=10% class=title>��ä���Խ�</td>
                    <td width=15%>&nbsp; 
                        <input type="text" name="loan_b_amt" value="<%=Util.parseDecimal(cr_bean.getLoan_b_amt())%>" size="8" class=num  onBlur='javscript:loan_set(); this.value=parseDecimal(this.value);'>
                        ��</td>
                    <td width=10% class=title>��ä���ν�</td>
                    <td width=16%>&nbsp; 
                        <input type="text" name="loan_s_amt" value="<%=Util.parseDecimal(cr_bean.getLoan_s_amt())%>" size="8" class=num  onBlur='javscript:loan_set(); this.value=parseDecimal(this.value);'>
                        �� </td>
                    <td width=10% class=title>��ä������</td>
                    <td width=14%>&nbsp; 
                        <input type="text" name="loan_s_rat" value="<%=cr_bean.getLoan_s_rat()%>" size="6" class=num readonly>
                        % </td>
                </tr>
                <tr> 
                    <td class=title>��ϼ�</td>
                    <td>&nbsp; 
                      <input type="text" name="reg_amt" value="<%=Util.parseDecimal(cr_bean.getReg_amt())%>" size="8" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                      �� </td>
                    <td class=title>��漼</td>
                    <td>&nbsp; 
                      <input type="text" name="acq_amt" value="<%=Util.parseDecimal(cr_bean.getAcq_amt())%>" size="8" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                      ��</td>
                    <td class=title>��ȣ���ۺ�</td>
                    <td>&nbsp; 
                      <input type="text" name="no_m_amt" value="<%=Util.parseDecimal(cr_bean.getNo_m_amt())%>" size="8" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                      �� </td>
                    <td class=title>��,������</td>
                    <td>&nbsp; 
                      <input type="text" name="stamp_amt" value="<%=Util.parseDecimal(cr_bean.getStamp_amt())%>" size="6" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                      �� </td>
                </tr>
                <tr> 
                    <td class=title >��Ÿ</td>
                    <td >&nbsp; 
                      <input type="text" name="etc" value="<%=Util.parseDecimal(cr_bean.getEtc())%>" size="8" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
        			  �� </td>
                    <td class=title>��Ϻ�������</td>                    
                    <td  colspan=7 >&nbsp; 
                      <input type="text" name="reg_pay_dt" value="<%=cr_bean.getReg_pay_dt()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>    			  
                </tr>
                <tr>                    
                    <td class=title>��ϼ�����</td>                    
                    <td >&nbsp;
					   <input type="checkbox" name="reg_amt_card" value="Y" <%if(cr_bean.getReg_amt_card().equals("Y"))%>checked<%%>> 
					    ī�����
        				 </td>
                    <td class=title>��ȣ�Ǵ�ݰ���</td>                    
                    <td  colspan=7 >&nbsp; 
                      <input type="checkbox" name="no_amt_card" value="Y" <%if(cr_bean.getNo_amt_card().equals("Y"))%>checked<%%>> 
					  ī�����
                      </td>    			  
                </tr>				
            </table>
        </td>
    </tr>
</table>
<%	}%>	
</form>
<div align="center"> 
<a href="javascript:FootWin('HIS')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_ir.gif" align="absmiddle" border="0"></a>
<a href="javascript:FootWin('PUR')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_cg.gif" align="absmiddle" border="0"></a>
<a href="javascript:FootWin('MORT')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_jdg.gif" align="absmiddle" border="0"></a>
<a href="javascript:FootWin('SER')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_jggs.gif" align="absmiddle" border="0"></a>
<a href="javascript:FootWin('CHA')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_gj.gif" align="absmiddle" border="0"></a>
<a href="javascript:OpenIns()"      onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_ins.gif" align="absmiddle" border="0"></a>
<a href="javascript:FootWin('ACQ')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_cd.gif" align="absmiddle" border="0"></a>
<a href="javascript:FootWin('GEN')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_jdc.gif" align="absmiddle" border="0"></a> 
<a href="javascript:FootWin('KEY')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_ybk.gif" align="absmiddle" border="0"></a> 
<a href="javascript:OpenService()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_jbir.gif" align="absmiddle" border="0"></a>
<a href="javascript:OpenAccident()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_car_sgir.gif" align="absmiddle" border="0"></a>
</div>
<!--<a href="javascript:FootWin('KEY')" onMouseOver="window.status=''; return true">�ڻ���</a>&nbsp;| 
<a href="javascript:FootWin('KEY')" onMouseOver="window.status=''; return true">����</a>&nbsp;| -->

<script>
/* ���� ���ÿ��� �ڵ��� �ڵ尡 8000 ���ϴ� �¿���, 8000 �ʰ� 9000 ���ϴ� ������, 9000 �ʰ��� ȭ�������� ���� ���� 2018.03.05 */
var car_size = $("#car_size").val();
var isChrome = $("#isChrome").val();
if(car_size < 8001000){	// �¿���
	if(isChrome=="true"){
		$("#car_kd option[id=mid_van]").hide();
		$("#car_kd option[id=small_van]").hide();
		$("#car_kd option[id=big_truck]").hide();
		$("#car_kd option[id=mid_truck]").hide();
		$("#car_kd option[id=small_truck]").hide();	
	}else{
		$("#car_kd option[id=mid_van]").prop('disabled','disabled');
		$("#car_kd option[id=small_van]").prop('disabled','disabled');
		$("#car_kd option[id=big_truck]").prop('disabled','disabled');
		$("#car_kd option[id=mid_truck]").prop('disabled','disabled');
		$("#car_kd option[id=small_truck]").prop('disabled','disabled');
	}
}else if(car_size < 9001000){// ������
	if(isChrome=="true"){
		$("#car_kd option[id=big_pass]").hide();
		$("#car_kd option[id=mid_pass]").hide();
		$("#car_kd option[id=small_pass]").hide();
		$("#car_kd option[id=ssmall_pass]").hide();
		$("#car_kd option[id=big_truck]").hide();
		$("#car_kd option[id=mid_truck]").hide();
		$("#car_kd option[id=small_truck]").hide();	
	}else{
		$("#car_kd option[id=big_pass]").prop('disabled','disabled');
		$("#car_kd option[id=mid_pass]").prop('disabled','disabled');
		$("#car_kd option[id=small_pass]").prop('disabled','disabled');
		$("#car_kd option[id=ssmall_pass]").prop('disabled','disabled');
		$("#car_kd option[id=big_truck]").prop('disabled','disabled');
		$("#car_kd option[id=mid_truck]").prop('disabled','disabled');
		$("#car_kd option[id=small_truck]").prop('disabled','disabled');
	}
}else{	// ȭ����
	if(isChrome=="true"){
		$("#car_kd option[id=big_pass]").hide();
		$("#car_kd option[id=mid_pass]").hide();
		$("#car_kd option[id=small_pass]").hide();
		$("#car_kd option[id=ssmall_pass]").hide();
		$("#car_kd option[id=mid_van]").hide();
		$("#car_kd option[id=small_van]").hide();
	}else{
		$("#car_kd option[id=big_pass]").prop('disabled','disabled');
		$("#car_kd option[id=mid_pass]").prop('disabled','disabled');
		$("#car_kd option[id=small_pass]").prop('disabled','disabled');
		$("#car_kd option[id=ssmall_pass]").prop('disabled','disabled');
		$("#car_kd option[id=mid_van]").prop('disabled','disabled');
		$("#car_kd option[id=small_van]").prop('disabled','disabled');
	}
}
</script>
</body>
</html>

