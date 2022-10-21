<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.end_cont.End_ContDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 				= request.getParameter("mode")==null?"":request.getParameter("mode");
	String fee_start_dt 	= "";
	
	if(rent_l_cd.equals("")) return;
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "24");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	fee_start_dt = rs_db.addDay(ext_fee.getRent_end_dt(), 1);
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//�����۾�������-����
	Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", ext_fee.getRent_st(), "", "", rent_mng_id, rent_l_cd, base.getCar_mng_id(), "", "1");
	int fee_scd_size = fee_scd.size();
	
	Hashtable end_cont = ec_db.selectEnd_Cont(rent_mng_id, rent_l_cd);
	
	//����û������
	Vector rtn = af_db.getFeeRtnList(rent_mng_id, rent_l_cd, ext_fee.getRent_st());
	int rtn_size = rtn.size();
	
//	if(rtn_size>0) out.println("����û�� ��ü�Դϴ�. ������ ������ �븮���� �����ϼ���.");
	
	rtn_size = 0; //������ ���߿�
	
	String f_use_s_dt 	= "";
	String f_use_e_dt 	= "";
	String f_fst_dt 	= "";
	String f_req_dt 	= "";
	String f_tax_dt 	= "";
	String last_fee_tm	= "";
	
	String ext_reg_chk	= "";
	
	//���ɸ����� �ִ뿬�� �ݿ���
	String car_end_dt_max = cr_bean.getInit_reg_dt();
	//2000cc�̸��� 5+2=7��
	car_end_dt_max = c_db.addMonth(car_end_dt_max, 82);
	//��LPG -1����
	if(!ej_bean.getJg_b().equals("2")){
		car_end_dt_max = c_db.addMonth(car_end_dt_max, 1);
	}	
	//2000cc�ʰ��� 8+2=10��
	if(AddUtil.parseInt(cr_bean.getDpm()) > 2000){
		car_end_dt_max = c_db.addMonth(car_end_dt_max, 36);
	}
	//car_end_dt_max = c_db.addDay(car_end_dt_max, -1);
	
	if(!cr_bean.getCar_end_dt().equals("") && cr_bean.getCar_end_yn().equals("Y")){
	//	car_end_dt_max = c_db.addDay(cr_bean.getCar_end_dt(), -2);
	}
	
	//20211126 ������ 1���� �� �� (������ ���������ϸ� �� ��� ��) - �豤�������û
	car_end_dt_max = c_db.addMonth(car_end_dt_max, -1);

	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//�� ����
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���õ� ���� �����ϴ�."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("���õ� ������ �����ϴ�."); return;}
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//�����ٺ����̷�
	function FeeScdCngList(){
		var fm = document.form1;
		window.open("about:blank", "ScdCngList", "left=50, top=50, width=800, height=500, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_cnglist.jsp";
		fm.target = "ScdCngList";
		fm.submit();	
	}	
		
	//�뿩�Ⱓ ����
	function ScdfeeSet()
	{
		var fm = document.form1;
		//fm.rent_end_dt.value = addMonth(fm.rent_start_dt.value, fm.add_tm.value);
		if(toInt(fm.add_tm.value) == 0 || toInt(fm.add_tm.value) > 5)	{ alert('���ǿ����� 1�������� 5�������� �Է��� �� �ֽ��ϴ�.'); 	fm.add_tm.focus(); 		return; }
		if(fm.rent_start_dt.value != '' && fm.add_tm.value != ''){
			fm.action = "/fms2/con_fee/fee_scd_set_nodisplay.jsp";
			fm.target = "i_no";
			fm.submit();
		}
	}			
	
	//���տ��ο� ���� ���÷���
	function display_rtn(){
		var fm = document.form1;		
		if(fm.rtn_st.checked == true){ 					
			tr_rtn.style.display = 'block';		
		}else{											
			tr_rtn.style.display = 'none';							
		}	
	}
	
	function cal_sv_amt(obj)
	{
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);

		if(obj == fm.fee_s_amt){ //���뿩�� ���ް�
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_v_amt){ //���뿩�� �ΰ���		
			fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_amt){ //���뿩�� �հ�		
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));
		}
	}		
			
				
	//���
	function save(){
		var fm = document.form1;

		if(fm.add_tm.value == '')					{ alert('����ȸ���� �Է��Ͻʽÿ�.'); 					fm.add_tm.focus(); 		return; }
		if(toInt(fm.add_tm.value) == 0 || toInt(fm.add_tm.value) > 5)	{ alert('���ǿ����� 1�������� 5�������� �Է��� �� �ֽ��ϴ�.'); 		fm.add_tm.focus(); 		return; }
		
		//fm.rent_end_dt.value = addMonth(fm.rent_start_dt.value, fm.add_tm.value);
		if(fm.rent_end_dt.value == ''){
			ScdfeeSet();
		}
				
		/*
		if(fm.rent_start_dt.value == '')	{ alert('����뿩�Ⱓ�� �Է��Ͻʽÿ�.'); 						fm.rent_start_dt.focus(); 	return; }
		if(fm.rent_end_dt.value == '')		{ alert('����뿩�Ⱓ�� �Է��Ͻʽÿ�.'); 						fm.rent_end_dt.focus(); 	return; }
		if(fm.f_use_start_dt.value == '')	{ alert('1ȸ�� ���Ⱓ�� �Է��Ͻʽÿ�.'); 						fm.f_use_start_dt.focus(); 	return; }
		if(fm.f_use_end_dt.value == '')		{ alert('1ȸ�� ���Ⱓ�� �Է��Ͻʽÿ�.'); 						fm.f_use_end_dt.focus(); 	return; }
		if(fm.f_req_dt.value == '')			{ alert('1ȸ�� ���࿹������ �Է��Ͻʽÿ�.'); 					fm.f_req_dt.focus(); 		return; }
		if(fm.f_tax_dt.value == '')			{ alert('1ȸ�� �������ڸ� �Է��Ͻʽÿ�.'); 						fm.f_tax_dt.focus(); 		return; }
		if(fm.f_est_dt.value == '')			{ alert('1ȸ�� �Աݿ������� �Է��Ͻʽÿ�.'); 					fm.f_est_dt.focus(); 		return; }						
		*/

		<%if(rtn_size>0){%>
		//����û��
		if(fm.rtn_st.checked == true){
			var rtn_tm = <%=rtn_size%>;			
			var tot_rtn_fee_amt = 0;
			if(fm.rtn_fee_amt[0].value == '0'){			alert('1�� ����û�� �뿩�� �ݾ��� Ȯ���Ͻʽÿ�'); 	fm.rtn_fee_amt[0].focus(); 	return; }
			for(i=0; i<rtn_tm; i++){ 
				if(fm.rtn_firm_nm[i].value == '' || fm.rtn_fee_amt[i].value == ''){ alert(i+1+'�� ����û�� ������ �Է��Ͻʽÿ�.'); return;}
				if(toInt(parseDigit(fm.rtn_fee_amt[i].value)) > 0){ 
					fm.rtn_fee_s_amt[i].value 	= sup_amt(toInt(parseDigit(fm.rtn_fee_amt[i].value)));
					fm.rtn_fee_v_amt[i].value 	= toInt(parseDigit(fm.rtn_fee_amt[i].value)) - toInt(fm.rtn_fee_s_amt[i].value);
					tot_rtn_fee_amt 			= tot_rtn_fee_amt + toInt(parseDigit(fm.rtn_fee_amt[i].value));
				}
			}
			if(toInt(parseDigit(fm.fee_amt.value)) != tot_rtn_fee_amt){ alert('����û���ݾ����� ���� �ʽ��ϴ�.'); return; }		
		}
		<%}%>
				
		//������������ ��� ���ɸ����� üũ�ؼ� ���常������ ����� �� ��� ����� �ȵǵ��� �Ѵ�.
		<%if(!ck_acar_id.equals("000029") && !ck_acar_id.equals("000026") && cr_bean.getCar_use().equals("1")){%>
		if(toInt(replaceString('-','','<%=car_end_dt_max%>')) < toInt(replaceString('-','',fm.rent_end_dt.value)) ){
			alert('�뿩�Ⱓ �������� ���ɸ����Ϻ��� Ů�ϴ�. Ȯ���Ͻʽÿ�.'); 						fm.rent_end_dt.focus(); 	return;
		}
		<%}%>				
				
			
		if(confirm('����Ͻðڽ��ϱ�?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
		
			fm.action='lc_im_renew_c_rm_a.jsp';		

			<%if(mode.equals("pop")){%>
				fm.target='RENEW';
			<%}else{%>
				fm.target='d_content';
			<%}%>
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}							
	}

	//û���ݾ� ����
	function set_reqamt(st){
		var fm = document.form1;			
		if(fm.f_use_start_dt.value == ''){	alert('�������� �Է��Ͻʽÿ�.'); fm.f_use_start_dt.focus(); return;}
		if(fm.f_use_end_dt.value == ''){	alert('�������� �Է��Ͻʽÿ�.'); fm.f_use_end_dt.focus(); 	return;}				
		fm.st.value = st;
		fm.action='/fms2/con_fee/getUseDayFeeAmt.jsp';		
		if(st == 'view'){
			fm.target='_blank';
		}else{
			fm.target='i_no';
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
<body leftmargin="15">
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 			value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 			value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"	 	value="<%=ext_fee.getRent_st()%>">
  <input type='hidden' name="from_page" 	value="/fms2/lc_rent/lc_im_renew_c.jsp">             
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name='st' value=''>        
  <input type='hidden' name='f_fee_amt' value=''>
  <input type='hidden' name='f_fee_s_amt' value=''>
  <input type='hidden' name='f_fee_v_amt' value=''>
  <input type='hidden' name='client_id' value='<%=base.getClient_id()%>'>
  <input type='hidden' name='mode' value='<%=mode%>'>
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>�뵵/����</td>
                    <td width=10%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%>
					&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
                    <td class=title width=10%>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>��ȣ</td>
                    <td >&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%> <%=site.getR_site()%></a></td>
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title>����</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(�����ڵ�:<%=cm_bean.getJg_code()%>)</font>
        			</td>
                </tr>
                <tr>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp;<font color=red><b><%=AddUtil.ChangeDate2(cr_bean.getCar_end_dt())%></b></font>
                    	<%if(cr_bean.getCar_use().equals("1")){
							int car_end_d_day = c_db.getCar_D_day("car_end_dt", base.getCar_mng_id());
						%>
						<%if(car_end_d_day <= 30){ %><font color=red>(D-day <%=car_end_d_day%>��)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_end_d_day%>��<%}} %>
						<%} %>
                    </td>
                    <%	
        		    	int car_maint_d_day = c_db.getCar_D_day("car_maint_dt", base.getCar_mng_id());
				%>
                    <td class=title>�˻���ȿ�Ⱓ</td>
                    <td colspan='3'>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%> <%if(car_maint_d_day <= 30){ %><font color=red>(D-day <%=car_maint_d_day%>��)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_maint_d_day%>��<%}} %></b></td>
                </tr>
				<%if(!cms.getCms_bank().equals("")){%>
                <tr>
                     <td class='title'>CMS</td>
                     <td colspan='5'>&nbsp;
						<b><%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%></b>
        			 	<%=cms.getCms_bank()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (�ſ� <%=cms.getCms_day()%>��)
					 </td>                     
                </tr>							
        		<%}%>		
				<%if(!client.getEtc().equals("")){%>	 				
                <tr>
                     <td class='title'>�� Ư�̻���</td>
                     <td colspan='5'>&nbsp;<%=Util.htmlBR(client.getEtc())%></td>                     
                </tr>		
        		<%}%>						
				<%if(!String.valueOf(end_cont.get("RE_BUS_NM")).equals("") && !String.valueOf(end_cont.get("RE_BUS_NM")).equals("null")){%>				
                <tr>
                     <td class='title'>����������Ȳ</td>
                     <td colspan='5'>&nbsp;<%=end_cont.get("REG_DT")%> : [<%=end_cont.get("RE_BUS_NM")%>] <%=end_cont.get("CONTENT")%></td>                     
                </tr>	
				<%}%>						
                <tr>
                     <td class='title'>��꼭���౸��</td>
                     <td colspan='5'>&nbsp;<font color='#CCCCCC'>(��꼭���౸��:
					  <%if(client.getPrint_st().equals("1")) 		out.println("���Ǻ�");
                      	else if(client.getPrint_st().equals("2"))   out.println("<font color='#FF9933'>�ŷ�ó����</font>");
                      	else if(client.getPrint_st().equals("3")) 	out.println("<font color='#FF9933'>��������</font>");
                     	else if(client.getPrint_st().equals("4"))	out.println("<font color='#FF9933'>��������</font>");%>)
						</font></td>                     
                </tr>	
            </table>
	    </td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="3">��<br>��<br>��<br>��<br></td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">�������</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">�̿�Ⱓ</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 8pt;" width="7%" class=title rowspan="2">�����</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">���뿩��</td>
                    <td style="font-size : 8pt;" class=title colspan="2">������</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">������</td>
                    <td style="font-size : 8pt;" class=title colspan="2">���ô뿩��</td>
                    <td style="font-size : 8pt;" class=title colspan="2">���Կɼ�</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>%</td>			
                </tr>
    		  <%//for(int i=0; i<fee_size; i++){
//    				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				ContFeeBean fees = ext_fee;
				
				//����� �緮�� ���ڿ����� �߰����� �������� ����	
				//if(AddUtil.parseInt(base.getRent_dt()) > 20140228 && fees.getCon_mon().equals("0")) ext_reg_chk = "N";    	
				
					
//    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <!--<td style="font-size : 8pt;" align="center"><%//=i+1%></td>-->
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>����</td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getRent_st().equals("1")){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%if(fees.getIfee_s_amt()>0){%><%if(fees.getPere_r_mth()>0){%><%=fees.getPere_r_mth()%><%}else{%><%=fees.getIfee_s_amt()/fees.getFee_s_amt()%><%}%>ȸ&nbsp;<%}%><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%//}}%>
            </table>
	    </td>
	</tr>	
    <%if(ext_reg_chk.equals("N")){%>			
    <tr>
	<td><font color=red>* 20140225�� ���ʰ��к��� ���ڴ��� ������� �߰����� �Ұ��Դϴ�.</font></td>
    </tr>
</table>
</form>    	
    <%		if(1==1) return;
    	}%>		
	<tr>
	    <td align="right">&nbsp;
			    <a href="javascript:FeeScdCngList()"><img src=/acar/images/center/button_scd_bgir.gif  align=absmiddle border="0"></a>
		</td>
	</tr>

	<%if(fee_scd_size>0){
			int start_size = fee_scd_size-3;
			if(start_size < 0)	start_size = 0;
			%>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������� 3ȸ��</span></td>
	</tr>
	<tr>
	    <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>	 
                <tr>
                    <td width='5%' rowspan="2" class='title'>ȸ��</td>
                    <td colspan="2" rowspan="2" class='title'>���Ⱓ</td>
                    <td width="13%" rowspan="2" class='title'>���뿩��</td>
                    <td colspan="3" class='title'>������</td>
                    <td colspan="2" class='title'>�ŷ�����</td>					
                    <td colspan="2" class='title'>��꼭</td>
                </tr>
                <tr>
                  <td width="10%" class='title'>���࿹����</td>
                  <td width="10%" class='title'>��������</td>
                  <td width="10%" class='title'>�Աݿ�����</td>
                  <td width="8%" class='title'>�߱�����</td>
                  <td width="8%" class='title'>��������</td>
                  <td width="8%" class='title'>��������</td>
                  <td width="8%" class='title'>�������</td>
                </tr>
        		<%	for(int j = start_size ; j < fee_scd_size ; j++){
        					Hashtable ht = (Hashtable)fee_scd.elementAt(j);
							
							if(j == fee_scd_size-1){
								f_use_s_dt 	=  c_db.addDay  (String.valueOf(ht.get("USE_E_DT")), 1);																
								f_use_e_dt 	=  c_db.addMonth(String.valueOf(ht.get("USE_E_DT")), 1);
								//����Ʈ�� ���Ⱓ �������� ���࿹����, ��������, �Աݿ������� �⺻���� �Ѵ�.
								f_fst_dt 	=  f_use_s_dt;
								f_req_dt 	=  f_use_s_dt;
								f_tax_dt 	=  f_use_s_dt;
								last_fee_tm = String.valueOf(ht.get("FEE_TM"));								
							}
							%>
                <tr>
                    <td align="center"><%=ht.get("FEE_TM")%></td>
                    <td align="center" width="10%" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td align="center" width="10%" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��&nbsp;&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%><%if(!String.valueOf(ht.get("ITEM_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("ITEM_ID")%>)</font><%}%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_EST_DT")))%></td>										
                    <td align="center">
        		    <%if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
          		    <%}else{%>					
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
					<%}%>
					<%if(!String.valueOf(ht.get("TAX_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("TAX_NO")%>)</font><%}%>
        		    </td>
                    <td align="center">
        		    <%if(String.valueOf(ht.get("PRINT_DT")).equals("")){%>
        		    <%	if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    	<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
          		    <%	}else{%>
						<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
					<%	}%>
        		    <%}else{%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%>
        		    <%}%>
        		    </td>
                </tr>
        		<%	}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǿ���</span></td>	
	</tr>	  	
    <tr>
        <td class=line2></td>
    </tr>		

	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>����ȸ��</td>
                    <td>
                      <%if(base.getCar_st().equals("4")){%>
                      &nbsp;<input type='text' size='3' name='add_tm' value='1' maxlength='2' class='default' onBlur='javscript:ScdfeeSet();'>ȸ
					  (default 1����, 1~5���������� ����)
                      <%}else{%>
                      &nbsp;<input type='text' size='3' name='add_tm' value='3' maxlength='2' class='default' onBlur='javscript:ScdfeeSet();'>ȸ
					  (default 3����, 1~5���������� ����)
		      <%}%>			  
					  <input type='hidden' name='last_fee_tm' value='<%=last_fee_tm%>'>
					  </td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>����뿩�Ⱓ</td>
                    <td>&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(f_use_s_dt)%>' size='10' class='<%if(fee_scd_size==0){%>whitetext<%}else{%>whitetext<%}%>' onBlur='javscript:this.value = ChangeDate4(this, this.value); <%if(f_use_s_dt.equals("")){%>ScdfeeSet();<%}%>'>
        			  ~
        			  <input type='text' name='rent_end_dt' value='' size='10' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        			</td>
                </tr>							
                <tr>
                    <td colspan="2" class='title'>���뿩��</td>
                    <td>&nbsp;<input type='text' name='fee_amt' value='<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>' size='10' class='<%if(ext_fee.getFee_s_amt()==0){%>num<%}else{%>whitenum<%}%>' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>��&nbsp;
						(���ǿ����� ��༭�� ���� �ʰ�, �뿩�����
						 <%if(AddUtil.parseInt(base.getRent_dt()) > 20140228){%>���ʰ�� ���뿩���� 5% ���ε� �ݾ����� �Ѵ�.<%}else{%>������ �����ϰ� �մϴ�.<%}%>
						)
						&nbsp;&nbsp;
						���ް�:<input type='text' name='fee_s_amt' value='<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt())%>' size='10' class='<%if(ext_fee.getFee_s_amt()==0){%>whitenum<%}else{%>whitenum<%}%>' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>��, 
						�ΰ���:<input type='text' name='fee_v_amt' value='<%=AddUtil.parseDecimal(ext_fee.getFee_v_amt())%>' size='10' class='<%if(ext_fee.getFee_s_amt()==0){%>whitenum<%}else{%>whitenum<%}%>' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>��
        			</td>
                </tr>								
                <tr id=tr_im1 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td width="3%" rowspan="5" class='title'>1ȸ��</td>
                    <td class='title'>���Ⱓ</td>
                    <td>
                      &nbsp;<input type='text' name='f_use_start_dt' value='<%=AddUtil.ChangeDate2(f_use_s_dt)%>' maxlength='10' size='10' class='default' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                      ~
                      <input type='text' name='f_use_end_dt' value='<%=AddUtil.ChangeDate2(f_use_e_dt)%>' maxlength='10' size='10' class='default' onBlur="javscript:this.value = ChangeDate4(this, this.value); set_reqamt('');">
					( <input type='hidden' name='use_days' value=''>
					  <input type="text" name="u_mon" value="" size="5" class=text>����
  					  <input type="text" name="u_day" value="" size="5" class=text>�� )
					  &nbsp;&nbsp;&nbsp;					  
					  <a href="javascript:ScdFDdaySet();">[1ȸ�� �ʱ�ȭ]</a>
        		    </td>
                </tr>
                <tr id=tr_im2 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td width="10%" class='title'>���࿹����</td>
                    <td>
                        &nbsp;<input type='text' name='f_req_dt' value='<%=AddUtil.ChangeDate2(f_req_dt)%>' maxlength='10' size='10' class='default' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 
                        (�ŷ����� �ۼ�����, ���������� ���ݰ�꼭 �ۼ����� 15����) </td>
                </tr>
                <tr id=tr_im3 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td class='title'>��������</td>
                    <td>
                        &nbsp;<input type='text' name='f_tax_dt' value='<%=AddUtil.ChangeDate2(f_tax_dt)%>' maxlength='10' size='10' class='default' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 
                        (���ݰ�꼭 �ۼ�����) 
                    </td>
                </tr>						
                <tr id=tr_im4 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td class='title'>�Աݿ�����</td>
                    <td>
                        &nbsp;<input type='text' name='f_est_dt' value='<%=AddUtil.ChangeDate2(f_fst_dt)%>' maxlength='10' size='10' class='default' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>
                <tr id=tr_im5 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td class='title'>�������</td>
                    <td>
                        &nbsp;<textarea name="cng_cau" cols="82" rows="5" class=default style='IME-MODE: active'></textarea>
                        <input type='hidden' name='etc' value=''>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>	
	<tr id=tr_im6 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
	    <td><font color=green>* <!--1ȸ�� ���Ⱓ�� �ִ� [����ϱ�]�� Ŭ���ϸ� ���Ⱓ �� �뿩�� ���� ��� �մϴ�. -->1ȸ�������� �Է½� �ڵ� �����.</font></td>
    </tr>		
	<tr id=tr_im7 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
	    <td><font color=green>* �뿩�ὺ������ �����ϴ�. 1ȸ�� ���ڵ��� �Է��Ͽ� �ֽʽÿ�.</font></td>
    </tr>		
	<tr id=tr_im8 style='display:<%if(ext_fee.getFee_s_amt()==0){%>none<%}else{%>none<%}%>'>
	    <td><font color=green>* ���뿩�ᰡ �����ϴ�. �Է��Ͽ� �ֽʽÿ�.</font></td>
    </tr>		
	<%if(rtn_size>0){%>
	<tr>
	    <td class=h></td>
	</tr>		
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width=13% class='title'>����û������</td>
                    <td>&nbsp;
        			  <input type="checkbox" name="rtn_st" value="Y" onClick="javascript:display_rtn()" checked>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>		
	<tr tr id=tr_rtn style="display:''">
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>����</td>
                    <td width='47%' class='title'>���޹޴���</td>
        			<td width='40%' class='title'>û���ݾ�</td>
                </tr>			
				<%	for(int r = 0 ; r < rtn_size ; r++){
						Hashtable r_ht = (Hashtable)rtn.elementAt(r);%>				
                <tr>
                    <td class='title'><%=r+1%></td>
                    <td align="center">
        			  <input type='text' size='45' name='rtn_firm_nm' value='<%=r_ht.get("FIRM_NM")%>' class='text' readonly>
        			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  </td>
        			  <td align="center">
                      <input type='text' name='rtn_fee_amt' value='<%=AddUtil.parseDecimal(String.valueOf(r_ht.get("RTN_AMT")))%>' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
        			  <input type='hidden' name='rtn_fee_s_amt' value='0'>
        			  <input type='hidden' name='rtn_fee_v_amt' value='0'>		
        			  <input type='hidden' name='rtn_client_id' value='<%=r_ht.get("CLIENT_ID")%>'>
        			  <input type='hidden' name='rtn_site_id' value='<%=r_ht.get("SITE_ID")%>'>
					  <input type='hidden' name='rtn_rent_seq' value='<%=r_ht.get("RENT_SEQ")%>'>
					  </td>
                </tr>
				<%	}%>
            </table>
	    </td>
    </tr>		
	<%}%>
    <tr>
        <td>&nbsp;</td>
    </tr>
	
	<tr>
	    <td class=h></td>
	</tr>	
	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
		<td align="right"><a id="submitLink" href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

	
	function ScdFDdaySet(){
		var fm = document.form1;
		
		fm.f_use_start_dt.value 	= ChangeDate('<%=f_use_s_dt%>');
		fm.f_use_end_dt.value 		= ChangeDate('<%=f_use_e_dt%>');
		fm.f_req_dt.value		= ChangeDate('<%=f_req_dt%>');
		fm.f_tax_dt.value		= ChangeDate('<%=f_tax_dt%>');
		fm.f_est_dt.value		= ChangeDate('<%=f_fst_dt%>');				
	}	

	function initSet(){
		var fm = document.form1;
		
		//20140301 ���ʰ�� ���뿩�� ��� 5%�������� -> 20150317 3% ����
		<%if(AddUtil.parseInt(base.getRent_dt()) >= 20140301 && AddUtil.parseInt(base.getRent_dt()) < 20150317 && fee_size==1){%>			
		fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.95;
		fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);
		<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20150317 && AddUtil.parseInt(base.getRent_dt()) < 20170728 && fee_size==1){%>			
		fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.97;
		fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);
		<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20150317 && AddUtil.parseInt(base.getRent_dt()) < 20170728 && fee_size==2 && ext_fee.getCon_mon().equals("0")){%>			
		fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.97;
		fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);
		<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20170728){%>
		fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;
		//fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);
		<%}else{%>	
		fm.fee_amt.value = <%=ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt()%>;
		//fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);		
		<%}%>
			
		fm.f_fee_amt.value 		= fm.fee_amt.value;
		fm.f_fee_s_amt.value 		= fm.fee_s_amt.value;
		fm.f_fee_v_amt.value 		= fm.fee_v_amt.value;		
		fm.cng_cau.value		= '1ȸ�� �뿩��(���ް�) ���ڰ�� : '+fm.fee_s_amt.value+'*1����'; 
		fm.u_mon.value			= '1';
		fm.u_day.value			= '0';
		
		set_reqamt();
		ScdfeeSet();		
	}	
		
	initSet();
//-->
</script>
</body>
</html>
