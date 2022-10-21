<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.user_mng.*, acar.car_sche.*,acar.common.*, acar.car_office.*, acar.car_mst.*, acar.consignment.*, acar.estimate_mng.*,acar.client.*, acar.tint.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="pt_db" scope="page" class="acar.partner.PartnerDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	//����ڵ��� Ź�� ����� ������
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�������
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	CommiBean emp2 	= a_db.getCommi(m_id, l_cd, "2");
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
	
	String gubun = c_db.getNameByIdCode("0032", "", car.getCar_ext());
	
	
	
	Hashtable est = a_db.getRentEst(m_id, l_cd);
	
	//���� ���Ź�� ����� �ִ��� Ȯ��
	ConsignmentBean cons = cs_db.getConsignmentPur(m_id, l_cd);
	
	//���븮��
	Hashtable cons_man = cs_db.getConsignmentPurMan(cm_bean.getCar_comp_id(), pur.getDlv_ext(), pur.getOff_id());
	
	
	//���븮�� ����Ʈ
	Vector vt = cs_db.getConsignmentPurManList(cm_bean.getCar_comp_id(), pur.getOff_id(), pur.getDlv_ext());
	int vt_size = vt.size();
	
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
	UsersBean udt_mng_bean_b2 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ����������"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ�������"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));			
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("�뱸������"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
	
	//��ǰ	
	TintBean tint1 	= t_db.getCarTint(m_id, l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(m_id, l_cd, "2");	
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function update(){		
		var fm = document.form1;
		
		if(fm.dlv_ext.value == '')		{	alert('������� �Է��Ͽ� �ֽʽÿ�.'); 			fm.dlv_ext.focus(); 		return;		}
		if(fm.dlv_est_dt.value == '')		{	alert('��������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 		fm.dlv_est_dt.focus(); 		return;		}
		if(fm.udt_st.value == '')		{	alert('�μ����� �Է��Ͽ� �ֽʽÿ�.'); 			fm.udt_st.focus(); 		return;		}
		if(fm.off_id.value == '')		{ 	alert('Ź�۾�ü�� �����Ͻʽÿ�.'); 							return; 	}
		if(fm.rpt_no.value == '')		{	alert('�����ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 		fm.rpt_no.focus(); 		return;		}
		if(fm.cons_amt1.value == '' || fm.cons_amt1.value == '0'){	alert('Ź�۷Ḧ �Է��Ͽ� �ֽʽÿ�.'); 	fm.cons_amt1.focus(); 		return;		}
		
		var dlv_chk = 0;
		//�������Ź�۱��к� ����
		//������-�ƻ�-�������-�μ���(����/����/�λ�/�뱸/����)
		if(fm.car_comp_id.value=='0001' && fm.dlv_ext.value=='�ƻ�' && fm.off_id.value=='011372' && (fm.udt_st.value=='1'||fm.udt_st.value=='2'||fm.udt_st.value=='3'||fm.udt_st.value=='5'||fm.udt_st.value=='6')){
			dlv_chk = 1;
		}
		//������-���-�������-�μ���(����/����)
		if(fm.car_comp_id.value=='0001' && fm.dlv_ext.value=='���' && fm.off_id.value=='011372' && (fm.udt_st.value=='1'||fm.udt_st.value=='3')){
			dlv_chk = 1;
		}
		//�����-ȭ��-����Ư��-�μ���(����/����/�λ�/�뱸)
		if(fm.car_comp_id.value=='0002' && fm.dlv_ext.value=='ȭ��' && fm.off_id.value=='007751' && (fm.udt_st.value=='1'||fm.udt_st.value=='2'||fm.udt_st.value=='5'||fm.udt_st.value=='6')){
			dlv_chk = 1;
		}
		//�����-����-����Ư��-�μ���(�λ�/�뱸)
		if(fm.car_comp_id.value=='0002' && fm.dlv_ext.value=='����' && fm.off_id.value=='007751' && (fm.udt_st.value=='2'||fm.udt_st.value=='5')){
			dlv_chk = 1;
		}
		//��ȭ�������� �ϴ� �����ϰ�  - 20210812
		if ( fm.off_id.value=='010265') {
			dlv_chk = 1;
		}
		//�Ｚ�� ����
		if (fm.car_comp_id.value=='0003') {
			dlv_chk = 1;
		}
				
		if(fm.cons_st.value == '2' && dlv_chk==0){
			alert('��üŹ�� �Ұ����� <�����-�μ���-Ź�ۻ�>�Դϴ�. Ȯ���Ͻʽÿ�.'); return;
		}

		fm.to_place.value = fm.udt_st.options[fm.udt_st.selectedIndex].text;
		
		if(confirm('��� �Ͻðڽ��ϱ�?')){	
			fm.action='reg_cons_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//Ź�۾�ü ��ȸ
	function search_off()
	{
		var fm = document.form1;
		if(fm.dlv_ext.value == '')		{ 	alert('������� �����Ͻʽÿ�.'); 				return;	}
		if(fm.udt_st.value == '')		{	alert('�μ����� �����Ͻʽÿ�.'); 				return; }			
		window.open("/agent/cus0601/cus0602_frame.jsp?from_page=/agent/car_pur/reg_cons.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		

	//Ź�۾�ü Ź�۷� ��ȸ
	function search_off_amt()
	{
		var fm = document.form1;		
		if(fm.dlv_ext.value == '')		{ 	alert('������� �����Ͻʽÿ�.'); 				return;	}
		if(fm.udt_st.value == '')		{	alert('�μ����� �����Ͻʽÿ�.'); 				return; }
		if(fm.off_id.value == '')		{	alert('Ź�۾�ü�� �����Ͻʽÿ�.'); 				return; }
		var o_url = "/agent/cons_cost/s_cons_cost.jsp?car_comp_id=<%=cm_bean.getCar_comp_id()%>&car_cd=<%=cm_bean.getCode()%>&off_id="+fm.off_id.value+"&off_nm="+fm.off_nm.value+"&dlv_ext="+fm.dlv_ext.value+"&udt_st="+fm.udt_st.value;
		window.open(o_url, "CONS_COST", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//�����μ��� ���ý� ��ǰ��ü ����
	function cng_input1(value){
		var fm = document.form1;
				
		if(value == '������ ����������'){		
			fm.udt_addr.value 	= '����� �������� �������� 34�� 9';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_s.getDept_nm()%> <%=udt_mng_bean_s.getUser_nm()%> <%=udt_mng_bean_s.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_s.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_s.getUser_id()%>';
			
		}else if(value == '����ī(������)'){
			fm.udt_addr.value 	= '�λ걤���� ������ ����4�� 700-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b.getUser_id()%>';
			
		}else if(value == '������������� ������'){			
			fm.udt_addr.value 	= '�λ걤���� ������ ����4�� 585-1';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';
			
		}else if(value == '������TS'){			
			fm.udt_addr.value 	= '�λ�� ������ �ȿ���7������ 10(���굿 363-13����)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';	

		}else if(value == '�����̵���ǽ��� ����1�� ������'){			
			fm.udt_addr.value 	= '�λ걤���� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵�������';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';
			
		}else if(value == '����ī��ǰ'){
			fm.udt_addr.value 	= '���������� ������ ������ 527-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';
			
		}else if(value == '�̼���ũ'){
			fm.udt_addr.value 	= '���������� ������ ��õ�Ϸ�59���� 10(���� 690-3)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';
			
		}else if(value == '�뱸 ������'){
			fm.udt_addr.value 	= '�뱸������ �޼��� �Ŵ絿 321-86';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_g.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_g.getUser_id()%>';			
		}else if(value == '������ڵ�����ǰ��'){
			fm.udt_addr.value 	= '���ֱ����� ���걸 �󹫴�� 233 (������ 1360)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_j.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_j.getUser_id()%>';			
		}else if(value == '<%=client.getFirm_nm()%>'){
			fm.udt_addr.value 	= '<%=client.getO_addr()%>';
			fm.udt_mng_nm.value 	= '<%=client.getCon_agnt_dept()%> <%=client.getCon_agnt_nm()%> <%=client.getCon_agnt_title()%>';
			fm.udt_mng_tel.value 	= '<%=client.getO_tel()%>';
			fm.udt_mng_id.value     = '';
		}				
	}		
		
	function set_cons_amt(){
	}	
	
	function view_cons_man(){
		window.open("/fms2/pur_com/consp_man_sc.jsp", "VIEW_MAN", "left=200, top=200, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	function cons_man_sms(){
		var fm = document.form1;
		
		if(fm.destname.value == '')		{	alert('�����ڸ� �Է��Ͽ� �ֽʽÿ�.'); 			fm.destname.focus(); 		return;		}
		if(fm.destphone.value == '')		{	alert('���Ź�ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 		fm.destphone.focus(); 		return;		}
		if(fm.msg.value == '')			{	alert('���ڳ����� �Է��Ͽ� �ֽʽÿ�.'); 		fm.msg.focus(); 		return;		}
		
		if(confirm('��� �Ͻðڽ��ϱ�?')){	
			fm.action='reg_cons_sms_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}		
	}	
	
	//���븮�θ���Ʈ �����ֱ�
	function cons_man_list(){
		var fm = document.form1;		
		fm.action='reg_cons_mans.jsp';		
		fm.target='inner1';
		fm.submit();
	}	
	
	//�����, �μ����� Ź�۾�ü ����Ʈ
	function setOff(){
		var fm = document.form1;		
		
		if(<%=AddUtil.getDate(4)%> >= 20150429){
			if('<%=cm_bean.getCar_comp_id()%>' == '0001'){
				if(fm.dlv_ext.value == '���' && ( fm.udt_st.value == '2' || fm.udt_st.value == '6' || fm.udt_st.value == '5')){
					fm.off_id.value = '007751';
					fm.off_nm.value = '(��)����Ư��';
				}else{	
					fm.off_id.value = '011372';
					fm.off_nm.value = '�������(��)';
				}
				<%if(cons.getCons_no().equals("")){%> 		
				tr_driver1.style.display	= '';
				<%}%>
				tr_driver2.style.display	= 'none';
				
				
			}else if('<%=cm_bean.getCar_comp_id()%>' == '0002'){
				if(fm.udt_st.value == '3' || fm.dlv_ext.value == '���ϸ�' || fm.dlv_ext.value == '����'){
					
				}else if((fm.udt_st.value == '1' || fm.udt_st.value == '6') && fm.dlv_ext.value == '����'){
					fm.off_id.value = '011372';
					fm.off_nm.value = '�������(��)';
					
					<%if(cons.getCons_no().equals("")){%> 
					tr_driver1.style.display	= '';
					<%}%>			
					tr_driver2.style.display	= 'none';
					
				}else{
					fm.off_id.value = '007751';
					fm.off_nm.value = '(��)����Ư��';	
					
					<%if(cons.getCons_no().equals("")){%> 
					tr_driver1.style.display	= '';
					<%}%>
					tr_driver2.style.display	= 'none';		
					
				}
			}else if('<%=cm_bean.getCar_comp_id()%>' == '0003'){
				if(fm.udt_st.value == '1' || fm.udt_st.value == '3' || fm.udt_st.value == '6'){
					fm.off_id.value = '010265';
					fm.off_nm.value = '(��)��ȭ������';	
					
					<%if(cons.getCons_no().equals("")){%> 
					tr_driver1.style.display	= '';
					tr_driver2.style.display	= 'none';		
					<%}%>
				
				}else if(fm.udt_st.value == '2' || fm.udt_st.value == '5'){
					fm.off_id.value = '010266';
					fm.off_nm.value = '�����';	
					
					<%if(cons.getCons_no().equals("")){%> 
					tr_driver1.style.display	= '';
					<%}%>
					tr_driver2.style.display	= 'none';		
					
				
				}
			}
			<%if(cons.getCons_no().equals("")){%> 
			cons_man_list();
			<%}%>
		}	
		
		var deposit_len = fm.udt_firm.length;			
		for(var i = 1 ; i < deposit_len ; i++){
			fm.udt_firm.options[i] = null;			
		}
						
		
		if(fm.udt_st.value == '1'){
			fm.udt_firm.options[1] = new Option('������ ����������', '������ ����������');
			fm.udt_firm.value = '������ ����������';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '2'){
			<%if(AddUtil.getDate2(4) >= 20210205){%>
			fm.udt_firm.options[1] = new Option('������TS', '������TS');
			fm.udt_firm.options[2] = new Option('�����̵���ǽ��� ����1�� ������', '�����̵���ǽ��� ����1�� ������');
			fm.udt_firm.options[3] = new Option('����ī(������)', '����ī(������)');
			fm.udt_firm.value = '������TS';
			<%}else{%>
			fm.udt_firm.options[1] = new Option('������������� ������', '������������� ������');
			fm.udt_firm.options[2] = new Option('�����̵���ǽ��� ����1�� ������', '�����̵���ǽ��� ����1�� ������');
			fm.udt_firm.options[3] = new Option('����ī(������)', '����ī(������)');
			fm.udt_firm.options[4] = new Option('������TS', '������TS');
			fm.udt_firm.value = '������������� ������';
			<%}%>
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '3'){
			fm.udt_firm.options[1] = new Option('�̼���ũ', '�̼���ũ');
			fm.udt_firm.value = '�̼���ũ';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '5'){
			fm.udt_firm.options[1] = new Option('�뱸 ������', '�뱸 ������');
			fm.udt_firm.value = '�뱸 ������';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '6'){
			fm.udt_firm.options[1] = new Option('������ڵ�����ǰ��', '������ڵ�����ǰ��');
			fm.udt_firm.value = '������ڵ�����ǰ��';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '4'){
			fm.udt_firm.options[1] = new Option('<%=client.getFirm_nm()%>', '<%=client.getFirm_nm()%>');
			fm.udt_firm.value = '<%=client.getFirm_nm()%>';
			cng_input1(fm.udt_firm.value);
		}		
		
		
	}						
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="mode" value="<%=mode%>">
<input type='hidden' name="car_nm" value="<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%>">
<input type='hidden' name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
<input type='hidden' name="to_place" value="">
<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>����������޿�û���� ����� ��üŹ�� ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����ȣ</td>
                    <td width='29%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>��ȣ</td>
                    <td width='41%'>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>�������</td>
                    <td>&nbsp;<%=gubun%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>Ź���Ƿ�</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr> 
                    <td width=3% rowspan="2" class=title>��<br>��</td>
                    <td width=7% class=title>�����</td>
                    <td width=15%>
                      <select name='dlv_ext' class='default' onchange="javascript:setOff();cons_man_list();">
                        <option value="">����</option>     
                        <%if(emp2.getCar_comp_id().equals("0001")){%>
        				<option value='�ƻ�' <%if(pur.getDlv_ext().equals("�ƻ�"))%>selected<%%>>�ƻ�</option>
        				<option value='���' <%if(pur.getDlv_ext().equals("���"))%>selected<%%>>���</option>        				
        		<%}else if(emp2.getCar_comp_id().equals("0002")){%>		
        				<option value='���ϸ�' <%if(pur.getDlv_ext().equals("���ϸ�"))%>selected<%%>>���ϸ�</option>
        				<option value='ȭ��' <%if(pur.getDlv_ext().equals("ȭ��"))%>selected<%%>>ȭ��</option>        				
        				<option value='����' <%if(pur.getDlv_ext().equals("����"))%>selected<%%>>����</option>
        				<option value='����' <%if(pur.getDlv_ext().equals("����"))%>selected<%%>>����</option>
        		<%}else if(emp2.getCar_comp_id().equals("0003")){%>		
        				<option value='�λ�' <%if(pur.getDlv_ext().equals("�λ�"))%>selected<%%>>�λ�</option>
        		<%}%>
                      </select>

        			</td>
                    <td width=3% rowspan="3" class=title>Ź<br>��</td>
                    <td width=7% class=title>����</td>
                    <td width=15%>
        			  &nbsp;<select name="cons_st" class='default'>
        				<option value="2">��ü</option>							
        			  </select>
        			</td>
    		    </tr>
                <tr>
                    <td class=title>�����Ͻ�</td>
                    <td>&nbsp;<input type='text' size='12' name='dlv_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  <input type='text' size='2' name='dlv_est_h' class='default' value='<%=String.valueOf(est.get("DLV_EST_H"))%>'>��        			  
        			</td>
                    <td class=title>��ü��</td>
                    <td>&nbsp;<input type='text' name="off_nm" value='<%=pur.getOff_nm()%>' size='17' class='default'>
        			  <input type='hidden' name='off_id' value='<%=pur.getOff_id()%>'>
    			    <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span></td>
                </tr>
                <tr>                    
                    <td class=title colspan='2'>�μ���</td>
                    <td>
        			  &nbsp;<select name="udt_st" class='default' onChange="javascript:setOff();cng_input1(this.value);">
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getUdt_st().equals("1"))%> selected<%%>>���ﺻ��</option>
        				<option value="2" <%if(pur.getUdt_st().equals("2"))%> selected<%%>>�λ�����</option>
        				<option value="3" <%if(pur.getUdt_st().equals("3"))%> selected<%%>>��������</option>				
        				<option value="5" <%if(pur.getUdt_st().equals("5"))%> selected<%%>>�뱸����</option>
        				<option value="6" <%if(pur.getUdt_st().equals("6"))%> selected<%%>>��������</option>				
        				<option value="4" <%if(pur.getUdt_st().equals("4"))%> selected<%%>>��</option>
        			  </select>
        			</td>
                    <td class=title>Ź�۷�</td>
                    <td>&nbsp;<input type='text' name='cons_amt1' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCons_amt1())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��
        			  <span class="b"><a href="javascript:search_off_amt()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span></td>
                </tr>	
                <tr>
                  <td class=title colspan='2'>�����ȣ</td>
                    <td colspan='4'>&nbsp;<input type='text' name='rpt_no' maxlength='15' value='<%=pur.getRpt_no()%>' class='default' size='15'></td>
                </tr>	  
    		</table>
	    </td>
	</tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr> 
                    <td width=6% rowspan="2" class=title>��<br>
                  ��<br>
                  ��</td>
                    <td width=14% class=title>����/��ȣ</td>
                    <td width="80%">&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==����==</option>
        		    <%if(pur.getUdt_st().equals("1")){%>
        		    <option value="������ ����������" <%if(cons.getUdt_firm().equals("������ ����������"))%> selected<%%>>������ ����������</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("2")){%>     
        		    <%if(AddUtil.getDate2(4) < 20210205){%>   		    
        		    <option value="������������� ������" <%if(cons.getUdt_firm().equals("������������� ������"))%> selected<%%>>������������� ������</option>
        		    <%}%>
        		    <option value="�����̵���ǽ��� ����1�� ������" <%if(cons.getUdt_firm().equals("�����̵���ǽ��� ����1�� ������"))%> selected<%%>>�����̵���ǽ��� ����1�� ������</option>
        		    <option value="����ī(������)" <%if(cons.getUdt_firm().equals("����ī(������)"))%> selected<%%>>����ī(������)</option>
        		    <option value="������TS" <%if(cons.getUdt_firm().equals("������TS"))%> selected<%%>>������TS</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("3")){%>
        		    <option value="�̼���ũ" <%if(cons.getUdt_firm().equals("�̼���ũ"))%> selected<%%>>�̼���ũ</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("5")){%>
        		    <option value="�뱸 ������" <%if(cons.getUdt_firm().equals("�뱸 ������"))%> selected<%%>>�뱸 ������</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("6")){%>
        		    <option value="������ڵ�����ǰ��" <%if(cons.getUdt_firm().equals("������ڵ�����ǰ��"))%> selected<%%>>������ڵ�����ǰ��</option>				
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cons.getUdt_firm().equals(client.getFirm_nm()))%> selected<%%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select>
                    </td>
    		</tr>
                <tr>
                    <td class=title>�ּ�</td>
                    <td>&nbsp;<input type='text' name='udt_addr' size='70' value='<%=cons.getUdt_addr()%>' class='whitetext' ></td>
                </tr>
                <tr> 
                    <td rowspan="2" class=title>��<br>��<br>��</td>
                    <td class=title>�μ�/����</td>
                    <td>&nbsp;<input type='text' name='udt_mng_nm' size='30' value='<%=cons.getUdt_mng_nm()%>' class='whitetext'>
                        <input type='hidden' name="udt_mng_id" 	value="<%=cons.getUdt_mng_id()%>">
                    </td>
    		</tr>
                <tr>
                    <td class=title>����ó</td>
                    <td>&nbsp;<input type='text' name='udt_mng_tel' size='30' value='<%=cons.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
    		</table>
	    </td>
	</tr>     	
    <tr>
        <td class=h></td>
    </tr>		
    <tr> 
        <td><font color=red>* ���Ȯ���� ��츸 ����ϼ���.</red></td>
    </tr>    
    <tr>
        <td align="right">		
                <%if(pur.getPur_pay_dt().equals("")){%>			
		<a href="javascript:update()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;		
		<%}%>
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <%if(!cons.getCons_no().equals("") && !coe_bean.getCar_off_nm().equals("����������") && !coe_bean.getCar_off_nm().equals("�����Ǹ���") && !coe_bean.getCar_off_nm().equals("B2B������")){%>   
    
    <%		//���¾�ü�� ��ϵ� �����Ҵ� �繫�� ���������� ������    
    		//if(pur.getOne_self().equals("Y")){
    			//��󿬶���-���¾�ü
    			Hashtable pt_ht = pt_db.getPartnerAgnt(coe_bean.getEmp_nm(), coe_bean.getEmp_m_tel());
    			if(!String.valueOf(pt_ht.get("PO_AGNT_NM")).equals("") && !String.valueOf(pt_ht.get("PO_AGNT_NM")).equals("null")){
    				coe_bean.setEmp_nm	(String.valueOf(pt_ht.get("PO_AGNT_NM")));
    				coe_bean.setEmp_pos	("");
    				coe_bean.setEmp_m_tel	(String.valueOf(pt_ht.get("PO_AGNT_M_TEL")));
    			}    		    		
    		//}
    %>        
    <tr> 
        <td><hr></td>
    </tr>  
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���븮�� SMS �߼�</span>&nbsp;&nbsp;<a href="javascript:view_cons_man()" onMouseOver="window.status=''; return true">[���븮����Ȳ]</a></td>
    </tr>  	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>���븮��</td>
                    <td>&nbsp;
                                                <%if(!String.valueOf(cons_man.get("MAN_NM")).equals("") && !String.valueOf(cons_man.get("MAN_NM")).equals("null")){%>                   
                            <%=cons_man.get("OFF_NM")%> <%=cons_man.get("MAN_NM")%> <%=cons_man.get("MAN_SSN")%> <%=cons_man.get("MAN_TEL")%>
                        <%}else{%>                            
                            <%=pur.getOff_nm()%> <%=cons.getDriver_nm()%> <%=cons.getDriver_ssn()%> <%=cons.getDriver_m_tel()%>
                        <%}%>
                    </td>
                </tr>            
                <tr> 
                    <td class='title' width='10%'>����</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='msg'>[<%=pur.getDlv_ext()%>]�Ƹ���ī ���븮��:<%if(!String.valueOf(cons_man.get("MAN_NM")).equals("") && !String.valueOf(cons_man.get("MAN_NM")).equals("null")){%><%=cons_man.get("OFF_NM")%> <%=cons_man.get("MAN_NM")%> <%=cons_man.get("MAN_SSN")%> <%=cons_man.get("MAN_TEL")%><%}else{%><%=pur.getOff_nm()%> <%=cons.getDriver_nm()%> <%=cons.getDriver_ssn()%> <%=cons.getDriver_m_tel()%><%}%></textarea></td>
                </tr>
                <tr> 
                    <td class='title' width='10%'>������</td>
                    <td>&nbsp;<%=coe_bean.getCar_off_nm()%> <input type='text' name='destname' maxlength='15' value='<%=coe_bean.getEmp_nm()%> <%=coe_bean.getEmp_pos()%>' class='default' size='15'>
                        <input type='text' name='destphone' maxlength='15' value='<%=coe_bean.getEmp_m_tel()%>' class='default' size='15'>
                        &nbsp;&nbsp;&nbsp;
                        <a href="javascript:cons_man_sms();" title='���ں�����'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>        
                    </td>
                </tr>                
            </table>
        </td>
    </tr>	    
    <%}%>
    <%if(cons.getCons_no().equals("")){%>       
    <tr> 
        <td><hr></td>
    </tr>  
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���븮��</span></td>
    </tr>  	
	<tr id=tr_driver1 style="display:<%if(pur.getOff_id().equals("009771")){%>none<%}else{%>''<%}%>">
	    <td>
		    <iframe src="reg_cons_mans.jsp?car_comp_id=<%=cm_bean.getCar_comp_id()%>&off_id=<%=pur.getOff_id()%>&dlv_ext=<%=pur.getDlv_ext()%>" name="inner1" width="100%" height="250" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		    </iframe>
	    </td>
	</tr>
    <%}%>
    <tr id=tr_driver2 style="display:<%if(pur.getOff_id().equals("009771")){%>''<%}else{%>none<%}%>">
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td width=19%>&nbsp;
                        <input type='text' size='10' name='driver_nm' maxlength='15' class='default' value='<%=cons.getDriver_nm()%>'>                                                
                    </td>
                    <td width=14% class=title>�������</td>
                    <td width=19%>&nbsp;
                        <input type='text' size='15' name='driver_ssn' maxlength='8' class='default' value='<%=cons.getDriver_ssn()%>'>                    
                        (������ϰ� ���� �����ڸ� �־��ּ��� ��: 990101-1, 990101-2)
                    </td>
                    <td width=14% class=title>����ó</td>
                    <td>&nbsp;
                        <input type='text' size='13' name='driver_m_tel' maxlength='15' class='default' value='<%=cons.getDriver_m_tel()%>'>         
                    </td>
                </tr>
            </table>
        </td>
    </tr>   
</table>
</form>
<script language="JavaScript">
<!--	
	
	var fm = document.form1;
	
	
	cng_input1(<%=pur.getUdt_st()%>);
	
	if(fm.off_id.value == ''){
		setOff();
	}		
		
//-->
</script>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
