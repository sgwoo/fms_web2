<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 		= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");


	String cons_no 		= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	
	

	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
	
	//�������
	co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	
	//��������
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//������ȣ �̷�	
	CarHisBean ch_r [] = crd.getCarHisAll(base.getCar_mng_id());

	
	//Ź���Ƿ�
	ConsignmentBean cons = cs_db.getConsignmentPur(cons_no);
		
	//������
	Vector vt = cs_db.getConsignmentPurCngs(cons_no);
	int vt_size = vt.size();
	
	String cns_st = "";	
	String cns_dt = "";	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		if(i+1 == vt_size){
			cns_st = String.valueOf(ht.get("CNG_ST_NM"));		
			cns_dt = String.valueOf(ht.get("REG_DT"));		
		}
	}		
	

	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
				   	"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&cons_no="+cons_no+"";				   	

	
    	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
    	UsersBean udt_mng_bean_b2 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ����������"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ�������"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("�뱸������"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//�μ����� ����� ����Ʈ
	function setOff(){
		var fm = document.form1;
		
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
	
	//�����μ��� ���ý� ��ǰ��ü ����
	function cng_input1(value){
		var fm = document.form1;
		
		if(fm.udt_firm.value == '������ ����������'){					
			fm.udt_addr.value 	= '����� �������� �������� 34�� 9';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_s.getDept_nm()%> <%=udt_mng_bean_s.getUser_nm()%> <%=udt_mng_bean_s.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_s.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_s.getUser_id()%>';			
		}else if(fm.udt_firm.value == '����ī(������)'){				
			fm.udt_addr.value = '�λ걤���� ������ ����4�� 700-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b.getUser_id()%>';			
		}else if(fm.udt_firm.value == '������������� ������'){					
			fm.udt_addr.value = '�λ걤���� ������ ����4�� 585-1';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';
		}else if(fm.udt_firm.value == '������TS'){			
			fm.udt_addr.value 	= '�λ�� ������ �ȿ���7������ 10(���굿 363-13����)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';		
		}else if(fm.udt_firm.value == '�����̵���ǽ��� ����1�� ������'){					
			fm.udt_addr.value = '�λ걤���� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵�������';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';			
		}else if(fm.udt_firm.value == '����ī��ǰ'){				
			fm.udt_addr.value = '���������� ������ ������ 527-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';			
		}else if(fm.udt_firm.value == '�̼���ũ'){				
			fm.udt_addr.value = '���������� ������ ��õ�Ϸ�59���� 10(���� 690-3)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';			
		}else if(fm.udt_firm.value == '<%=client.getFirm_nm()%>'){				
			fm.udt_addr.value 	= '<%=client.getO_addr()%>';
			fm.udt_mng_nm.value 	= '<%=client.getCon_agnt_dept()%> <%=client.getCon_agnt_nm()%> <%=client.getCon_agnt_title()%>';
			fm.udt_mng_tel.value 	= '<%=client.getO_tel()%>';
			fm.udt_mng_id.value     = '';			
		}else if(fm.udt_firm.value == '�뱸 ������'){				
			fm.udt_addr.value = '�뱸������ �޼��� �Ŵ絿 321-86';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_g.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_g.getUser_id()%>';			
		}else if(fm.udt_firm.value == '������ڵ�����ǰ��'){				
			fm.udt_addr.value = '���ֱ����� ���걸 �󹫴�� 233 (������ 1360)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_j.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_j.getUser_id()%>';			
		}
					
	}
	
	//���汸�� ���÷���
	function cng_input2(){
		var fm = document.form1;
		<%if(cons.getDlv_dt().equals("")){%>
		if(fm.cng_st[0].checked == true){ 				//���������
			tr_cng1.style.display = '';		
			tr_cng2.style.display = 'none';		
			tr_cng4.style.display = 'none';		
		}else{								//���������������
			tr_cng1.style.display = 'none';		
			tr_cng2.style.display = 'none';		
			tr_cng4.style.display = '';	
		}
		<%}else{%>
		if(fm.cng_st[0].checked == true){ 				//����Ϻ���
			tr_cng1.style.display = 'none';		
			tr_cng2.style.display = '';		
			tr_cng4.style.display = 'none';		
		}else{ 								//������
			tr_cng1.style.display = 'none';		
			tr_cng2.style.display = 'none';		
			tr_cng4.style.display = 'none';		
		}		
		<%}%>
	}			

	//���
	function save(){
		var fm = document.form1;
		
		//����
		<%if(cng_item.equals("cng")){%>  
		if(fm.udt_st.value == ''){		alert('����������� �����Ͽ� �ֽʽÿ�.'); 	fm.udt_st.focus(); 	return;	}
		<%}%>
		
		//�μ�
		<%if(cng_item.equals("udt")){%>  
		if(fm.udt_yn[0].checked == false && fm.udt_yn[1].checked == false){
			alert('�μ������� �����Ͽ� �ֽʽÿ�.');
			return;
		}
		if(fm.udt_dt.value == ''){		alert('�μ����ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.udt_dt.focus(); 	return;	}
		<%}%>
				
		//���
		<%if(cng_item.equals("cancel")){%>

		<%}%>
		
		//��ǰŹ��
		<%if(cng_item.equals("return_car")){%>
		if(fm.return_dt.value == ''){		alert('��ǰŹ�����ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.return_dt.focus(); 	return;	}
		if(toInt(parseDigit(fm.return_amt.value))==0){ alert('��ǰŹ�۷Ḧ �Է��Ͻʽÿ�.'); fm.return_amt.focus(); 	return;}
		<%}%>

		//�Ƿڷ�
		<%if(cng_item.equals("init")){%>

		<%}%>
	
		//���
		<%if(cng_item.equals("dlv")){%>
		if(fm.dlv_dt.value == ''){		alert('������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_dt.focus(); 	return;	}
		<%}%>
		
		//���븮��
		<%if(cng_item.equals("driver")){%>
		if(fm.driver_nm.value == ''){		alert('���븮���� �����Ͽ� �ֽʽÿ�.'); 		fm.driver_nm.focus(); 		return;	}
		if(fm.driver_m_tel.value == ''){	alert('���븮�� ����ó�� �Է��Ͽ� �ֽʽÿ�.'); 	fm.driver_m_tel.driver_m_tel(); return;	}		
		<%}%>
		
		<%if(cng_item.equals("to_est_dt")){%>
		if(fm.driver_nm2.value == ''){		alert('Ź�۱�縦 �Է��Ͽ� �ֽʽÿ�.'); 		fm.driver_nm2.focus(); 		return;	}
		if(fm.driver_m_tel2.value == ''){	alert('Ź�۱�� ����ó�� �Է��Ͽ� �ֽʽÿ�.'); 		fm.driver_m_tel2.driver_m_tel(); 	return;	}
		if(fm.to_est_dt.value == ''){		alert('����� ���������ϸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.to_est_dt.focus(); 		return;	}
		if(fm.to_est_h.value == ''){		alert('����� ���������� �ð��� �Է��Ͽ� �ֽʽÿ�.'); 	fm.to_est_h.focus(); 		return;	}
		if(fm.to_est_s.value == ''){		alert('����� ���������� ���� �� �Է��Ͽ� �ֽʽÿ�.'); 	fm.to_est_s.focus(); 		return;	}
		<%}%>
		
		if(confirm('���� �Ͻðڽ��ϱ�?')){	
			fm.action='cons_pur_u_a.jsp';	
			fm.target='i_no';		
			fm.submit();
		}	
	}	
	
	//������ ��ȸ
	function cng_input6(){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 700;		
		window.open("s_man.jsp?off_id=<%=pur.getOff_id()%>&car_comp_id=<%=emp2.getCar_comp_id()%>&dlv_ext=<%=pur.getDlv_ext()%>", "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		

	}				
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="cons_no" 		value="<%=cons_no%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="car_nm" 		value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">  
  <input type='hidden' name="udt_mng_id" 	value="<%=cons.getUdt_mng_id()%>">  
  <input type='hidden' name="cng_item" 		value="<%=cng_item%>">
  <input type='hidden' name="seq" 		value="">  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���Ź�۰��� > <span class=style5>���Ź�ۼ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
                    <td width=7% rowspan="2" class=title>����ȣ</td>
                    <td width=7% class=title>�Ƹ���ī</td>
                    <td width=36%>&nbsp;<%=rent_l_cd%></td>
                    <td width=7% rowspan="2" class=title>�������</td>
                    <td width=7% class=title>��������</td>
                    <td width="36%" >&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%></td>
    		    </tr>
                <tr>
                  <td class=title><%=cm_bean.getCar_comp_nm()%></td>
                  <td>&nbsp;<%=pur.getRpt_no()%></td>
                  <td class=title>�������</td>
                  <td >&nbsp;
                      <%if(cng_item.equals("dlv") || cng_item.equals("dlv_dt")){%>
                          <input type='text' size='11' name='dlv_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cons.getDlv_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <%}else{%>    
                          <%=AddUtil.ChangeDate2(cons.getDlv_dt())%>
                      <%}%>
                  </td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <%if(cng_item.equals("cng")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���汸��</td>
                    <td>&nbsp;
                        <%if(cons.getDlv_dt().equals("")){%>
                        <input type="radio" name="cng_st" value="1" checked onClick="javascript:cng_input2()" >
            			���������            	
            		<input type="radio" name="cng_st" value="4" onClick="javascript:cng_input2()" >
            			���������������
            		<%}else{%>		
            		<input type="radio" name="cng_st" value="2" checked onClick="javascript:cng_input2()" >
            			����Ϻ���
            		<input type="radio" name="cng_st" value="3" onClick="javascript:cng_input2()" >
            			������     
            		<%}%>	
            	    </td>
                </tr>
            </table>
        </td>
    </tr>             
    <tr>
        <td class=h></td>
    </tr>
    <tr id=tr_cng1 style="display:<%if(cons.getDlv_dt().equals("")){%>''<%}else{%>none<%}%>">
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="3" class=title>�����</td>
                    <td width=7% class=title>����</td>
                    <td width="36%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getUdt_st().equals("1"))%> selected<%%>>���ﺻ��</option>
        				<option value="2" <%if(pur.getUdt_st().equals("2"))%> selected<%%>>�λ�����</option>
        				<option value="3" <%if(pur.getUdt_st().equals("3"))%> selected<%%>>��������</option>				
        				<option value="5" <%if(pur.getUdt_st().equals("5"))%> selected<%%>>�뱸����</option>
        				<option value="6" <%if(pur.getUdt_st().equals("6"))%> selected<%%>>��������</option>				
        				<option value="4" <%if(pur.getUdt_st().equals("4"))%> selected<%%>>��</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>�����</td>
                    <td width="7%" class=title>�μ�/����</td>
                    <td width="36%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cons.getUdt_mng_nm()%>' class='whitetext' ></td>
    		    </tr>
                <tr>

                  <td class=title>����/��ȣ</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==����==</option>
        		    <%if(pur.getUdt_st().equals("1")){%>
        		    <option value="������ ����������" <%if(cons.getUdt_firm().equals("������ ����������"))%> selected<%%>>������ ����������</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("2")){%>
        		    <option value="������������� ������" <%if(cons.getUdt_firm().equals("������������� ������"))%> selected<%%>>������������� ������</option>
        		    <option value="�����̵���ǽ��� ����1�� ������" <%if(cons.getUdt_firm().equals("�����̵���ǽ��� ����1�� ������"))%> selected<%%>>�����̵���ǽ��� ����1�� ������</option>
        		    <option value="����ī(������)" <%if(cons.getUdt_firm().equals("����ī(������)"))%> selected<%%>>����ī(������)</option>
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
                  <td class=title>����ó</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cons.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
                <tr>
                  <td class=title>�ּ�</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cons.getUdt_addr()%>' class='whitetext' ></td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr id=tr_cng2 style="display:<%if(!cons.getDlv_dt().equals("")){%>''<%}else{%>none<%}%>">
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>�������</td>
                    <td>&nbsp;<input type='text' size='11' name='dlv_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cons.getDlv_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>                   
    		</tr>
            </table>
        </td>
    </tr>       
    <tr id=tr_cng4 style='display:none'>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>������������</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='etc'><%=cons.getEtc()%></textarea></td>                   
    		</tr>
            </table>
        </td>
    </tr>       
    <tr>
        <td class=h></td>
    </tr>
    <%}%>
    
    <%if(cng_item.equals("udt")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>�μ�����</td>
                    <td width=19%>&nbsp;
                        <input type="radio" name="udt_yn" value="Y" checked>
            			�μ�
            		<input type="radio" name="udt_yn" value="N">
            			�ź�
			</td>
                    <td>
                    <td width=14% class=title>�μ�����</td>
                    <td>&nbsp;
                    <% if(cons.getUdt_dt().equals("")) cons.setUdt_dt(AddUtil.getDate()); %>
                    &nbsp;<input type='text' size='11' name='udt_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cons.getUdt_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                    </td>
                </tr>
            </table>
        </td>
    </tr>       
    <%}%>
    
    <%if(cng_item.equals("udt_dt")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>�μ�����</td>
                    <td>&nbsp;
                    <% if(cons.getUdt_dt().equals("")) cons.setUdt_dt(AddUtil.getDate()); %>
                    &nbsp;<input type='text' size='11' name='udt_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cons.getUdt_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                    </td>
                </tr>
            </table>
        </td>
    </tr>       
    <%}%>    
    
    <%if(cng_item.equals("return_car")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=15% class=title>��ǰŹ������</td>
                    <td width=35%>&nbsp;                    
                    &nbsp;<input type='text' size='11' name='return_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cons.getReturn_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                    </td>
                    <td width=15% class=title>��ǰŹ�۷�</td>
                    <td width=35%>&nbsp;                    
                    &nbsp;<input type='text' name='return_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cons.getReturn_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��                                       
                    </td>
                </tr>
            </table>
        </td>
    </tr>       
    <%}%>    
    
    <%if(cng_item.equals("driver")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���븮�� ����</td>
                    <td width=19%>&nbsp;
                        <input type='text' size='10' name='driver_nm' maxlength='15' class='default' value='<%=cons.getDriver_nm()%>'>
                        &nbsp;
                        <a href="javascript:cng_input6()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a>                        
                    </td>
                    <td width=14% class=title>�������</td>
                    <td width=19%>&nbsp;
                        <input type='text' size='15' name='driver_ssn' maxlength='8' class='default' value='<%=cons.getDriver_ssn()%>'>                    
                    </td>
                    <td width=14% class=title>����ó</td>
                    <td>&nbsp;
                        <input type='text' size='13' name='driver_m_tel' maxlength='15' class='default' value='<%=cons.getDriver_m_tel()%>'>         
                    </td>
                </tr>                
            </table>
        </td>
    </tr> 
    <%}%>
    
    
    <%if(cng_item.equals("to_est_dt")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>Ź�۱�� ����</td>
                    <td width=36% >&nbsp;
                        <input type='text' size='10' name='driver_nm2' maxlength='15' class='default' value='<%=cons.getDriver_nm2()%>'>                                              
                    </td>
                    <td width=14% class=title>����ó</td>
                    <td width=36%>&nbsp;
                        <input type='text' size='13' name='driver_m_tel2' maxlength='15' class='default' value='<%=cons.getDriver_m_tel2()%>'>         
                    </td>
                </tr>            
                <tr> 
                    <td width='14%' class=title>����� ���������Ͻ�</td>
                    <td colspan="3">&nbsp;
                        <%		String to_est_dt = "";
			  		String to_est_h = "";
					String to_est_s = "";					
			  		if(cons.getTo_est_dt().length() == 12){
						to_est_dt 	= cons.getTo_est_dt().substring(0,8);
						to_est_h 	= cons.getTo_est_dt().substring(8,10);
						to_est_s 	= cons.getTo_est_dt().substring(10,12);
					}%>						
                        <input type='text' name="to_est_dt" value='<%=AddUtil.ChangeDate2(to_est_dt)%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'>
			&nbsp;
			<select name="to_est_h" >
			    <option vlaue="">����</option>
                        <%for(int i=0; i<24; i++){%>
                            <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                        </select>
                        <select name="to_est_s" >
                            <option vlaue="">����</option>
                        <%for(int i=0; i<59; i+=5){%>
                            <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                        </select>                        
                    <td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr> 
        <td>* �Ƹ���ī ��������ڿ��� ���ڸ޼���( ex : <%=pur.getRpt_no()%> ���� 2013/12/06 11:00 ���������Դϴ�.Ź�۱�� 000 010-000-0000 )�� �߼۵˴ϴ�.</td>
    </tr>           
    <tr> 
        <td>* ���븮�ο��� ���ڸ޼���( ex : �Ƹ���ī <%=pur.getRpt_no()%> ��������� ��00 010-111-1111 )�� �߼۵˴ϴ�.</td>
    </tr>      
    <%}%>    
    
    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
     <tr>
	<td align='center'>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	</td>
    </tr>	
    <%}%>

    
</table>
</form>
<script language="JavaScript">
<!--	
  <%if(cng_item.equals("cancel") || cng_item.equals("settle") || cng_item.equals("init")){%>
    save();
  <%}%>
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

