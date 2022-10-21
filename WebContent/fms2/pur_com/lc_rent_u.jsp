<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.tint.*, acar.doc_settle.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
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
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");


	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
	
	//��������
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//Ư�ǰ������
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");

	//��������		
	CarPurDocListBean cpd_bean = cod.getCarPurCom(rent_mng_id, rent_l_cd, com_con_no);
		
	//������
	Vector vt = cod.getCarPurComCngs(rent_mng_id, rent_l_cd, com_con_no);
	int vt_size = vt.size();
	
	UsersBean dlv_mng_bean 	= umd.getUsersBean(cpd_bean.getDlv_mng_id());
		
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
	UsersBean udt_mng_bean_b2 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ����������"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ�������"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));			
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("�뱸������"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
	
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"";		
	
	if(car.getPurc_gu().equals("")){
		if(base.getCar_st().equals("3")){
			car.setPurc_gu("1");	
		}else{
			car.setPurc_gu("0");	
		}
	}	
	
	String add_dc_yn = e_db.getEstiSikVarCase("1", "", "add_dc_yn");//�߰�DC���˿���
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
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
	//���
	function save(){
		var fm = document.form1;
		
		//��ຯ��
		<%if(cng_item.equals("cng")){%>  
			if(fm.cng_cont.value == ''){	alert('�����׸��� �������� ���汸�п� �Է��Ͽ� �ֽʽÿ�.'); 	fm.cng_cont.focus(); 	return;	}
		<%}%>
		
		
		//�������
		<%if(cng_item.equals("cls1")){// || cng_item.equals("cls2")%>  
		
			if(fm.cng_cont.checked == false){ //  && fm.cng_cont[1].checked == false && fm.cng_cont[2].checked == false
				alert('���������� �����Ͽ� �ֽʽÿ�.');
				return;
			}
		
			<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("��������ü��",user_id)){%>
			<%}else{%>
			//if(fm.cng_cont[1].checked == true && '<%=base.getUse_yn()%>' != 'N'){
			//	alert('���������Ȳ���� ������ ���� ����������� ���� ó���Ͻʽÿ�.');  	return;
			//}
			<%}%>
		
			if(fm.bigo.value == ''){	alert('������ �Է��Ͽ� �ֽʽÿ�.'); 		fm.bigo.focus(); 	return;	}
		
			<%	if(cng_item.equals("cls1") && base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){%>    
					if(fm.cont_use_yn[0].checked == false && fm.cont_use_yn[1].checked == false){
						alert('����������θ� �����Ͽ� �ֽʽÿ�.');
						return;
					}
			<%	}%>
		
			<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("��������ü��",user_id)){%>
			<%}else{%>	
			//�Ӹ����̵�� ��ǰ��� �ȵǰ�
			//if(fm.cng_cont[0].checked == true && '<%=pur_com.get("R_CAR_NM")%>'.indexOf('�Ӹ����̵�') != -1){
			//	alert('�Ӹ����̵�� ��ǰ��Ҹ� ���� ���ʽÿ�. ���������Ȳ���� ó�� �Ͻʽÿ�.');
			//	return;
			//}
			<%}%>
		
		<%}%>
		
		
		//������
		<%if(cng_item.equals("con")){%>
		//�߰�DC : ����Ư��, ������ ����
		if('<%=ej_bean.getJg_g_7()%>' == '3' || '<%=ej_bean.getJg_g_7()%>' == '4'){ 
		}else{	
			if('<%=add_dc_yn%>'=='Y' && fm.car_off_id.value == '03900' && toInt(parseDigit(fm.add_dc_amt.value)) ==0){ 
				alert('�߰�D/C�� �Է��ϰ� ����ó���Ͻʽÿ�.'); 	return;
			}
		}
		if(fm.dlv_con_dt.value == ''){	alert('���������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_con_dt.focus(); 	return;	}
		if(fm.dlv_ext.value == ''){	alert('���繫�Ҹ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_ext.focus(); 	return;	}
		if(fm.udt_st.value == ''){	alert('����������� �����Ͽ� �ֽʽÿ�.'); 	fm.udt_st.focus(); 	return;	}		
		<%}%>
	
		//������
		<%if(cng_item.equals("dlv")){%>
		<%if(cpd_bean.getDlv_st().equals("2")){%>
			if(fm.dlv_con_dt.value == ''){	alert('�������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_con_dt.focus(); 	return;	}
		<%}else{%>
			//if(fm.dlv_est_dt.value == ''){	alert('�������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_est_dt.focus(); 	return;	}
		<%}%>
		if(fm.dlv_ext.value == ''){	alert('���繫�Ҹ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_ext.focus(); 	return;	}
		if(fm.udt_st.value == ''){	alert('����������� �����Ͽ� �ֽʽÿ�.'); 	fm.udt_st.focus(); 	return;	}
		<%}%>
		
		//���Ź�ۻ�
		<%if(cng_item.equals("cons_off")){%>
		if(fm.cons_off_nm.value == ''){		alert('���Ź�ۻ� ��ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 	fm.cons_off_nm.focus(); 	return;	}
		if(fm.cons_off_tel.value == ''){	alert('���Ź�ۻ� ����ó�� �Է��Ͽ� �ֽʽÿ�.'); 	fm.cons_off_tel.focus(); 	return;	}
		<%}%>		
		
		//�������û
		<%if(cng_item.equals("re")){%>
		if(fm.pur_req_dt.value == ''){	alert('�������ϸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.pur_req_dt.focus(); 	return;	}
		if(fm.bigo.value == ''){	alert('������ �Է��Ͽ� �ֽʽÿ�.'); 		fm.bigo.focus(); 	return;	}
		<%}%>
		
		//�����ĺ������
		<%if(cng_item.equals("cng2")){%>
		if(fm.dlv_dt.value == ''){	alert('������ ������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_dt.focus(); 	return;	}		
		if(fm.udt_st.value == ''){	alert('����������� �����Ͽ� �ֽʽÿ�.'); 	fm.udt_st.focus(); 	return;	}		
		<%}%>
		
		//�������
		<%if(cng_item.equals("cls3")){%>  
		if(fm.bigo.value == ''){	alert('������ �Է��Ͽ� �ֽʽÿ�.'); 		fm.bigo.focus(); 	return;	}				
		
		<%	if(base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){%>    
				if(fm.cont_use_yn[0].checked == false && fm.cont_use_yn[1].checked == false){
					alert('����������θ� �����Ͽ� �ֽʽÿ�.');
					return;
				}
		<%	}%>		
		<%}%>
		
		//���
		<%if(cng_item.equals("settle")){%>  
		if(fm.dlv_dt.value == ''){	alert('������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_dt.focus(); 	return;	}		
		<%}%>
		
		//���
		<%if(cng_item.equals("dlv_dt")){%>  
		//if(fm.dlv_dt.value == ''){	alert('������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_dt.focus(); 	return;	}		
		<%}%>

		
		if(confirm('���� �Ͻðڽ��ϱ�?')){	
			fm.action='lc_rent_u_a.jsp';	
			fm.target='i_no';		
			fm.submit();
		}	
	}		
	
	//���� �Һ��ڰ� �հ�
	function set_car_amt(){
		var fm = document.form1;
		
		fm.car_d_amt.value 	= parseDecimal( toInt(parseDigit(fm.dc_amt.value)) + toInt(parseDigit(fm.add_dc_amt.value)) );
		fm.car_g_amt.value 	= parseDecimal( toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_d_amt.value)) );
		fm.car_amt1.value 	= fm.car_g_amt.value;		
		fm.car_amt2.value 	= fm.cons_amt.value;		
		fm.car_amt3.value 	= parseDecimal( toInt(parseDigit(fm.car_g_amt.value)) + toInt(parseDigit(fm.cons_amt.value)) );
		
	}
	
	//���԰����
	function set_car_f_amt(){
		var fm = document.form1;
						
		if(fm.purc_gu.value == '����'){//����1
			fm.car_f_amt.value = fm.car_c_amt.value;
		}else{//����2(�鼼) 
			if('<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || '<%=cm_bean.getS_st()%>' == '301' || '<%=cm_bean.getS_st()%>' =='302' || '<%=cm_bean.getS_st()%>' == '300'))){
				fm.car_f_amt.value = fm.car_c_amt.value;
			}else{
			
				var o_1 = toInt(parseDigit(fm.car_c_amt.value));
										
				//������ Ư�Ҽ���
				var o_2 = <%=ej_bean.getJg_3()%>;	
				
				//Ư�Ҽ��������� o_3 = o_1/(1+o_2), ��������/(1+Ư�Ҽ���);
				var o_3 = Math.round(o_1/(1+o_2));	
					
				fm.car_f_amt.value  = parseDecimal(o_3);				
			}									
		}	
		
		if(fm.car_off_id.value == '03900'){		
			fm.dc_amt.value = parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );
		}
		
		set_car_amt();				
	}				
	
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
			fm.udt_addr.value 	= '�λ걤���� ������ ����4�� 700-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b.getUser_id()%>';			
		}else if(fm.udt_firm.value == '������������� ������'){					
			fm.udt_addr.value 	= '�λ걤���� ������ ����4�� 585-1';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';			
		}else if(fm.udt_firm.value == '������TS'){			
			fm.udt_addr.value 	= '�λ�� ������ �ȿ���7������ 10(���굿 363-13����)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';	

		}else if(fm.udt_firm.value == '�����̵���ǽ��� ����1�� ������'){					
			fm.udt_addr.value 	= '�λ걤���� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵�������';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';			
		}else if(fm.udt_firm.value == '����ī��ǰ'){			
			fm.udt_addr.value 	= '���������� ������ ������ 527-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';						
		}else if(fm.udt_firm.value == '�̼���ũ'){				
			fm.udt_addr.value = '���������� ������ ��õ�Ϸ�59���� 10(���� 690-3)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';			
		}else if(fm.udt_firm.value == '�뱸 ������'){				
			fm.udt_addr.value 	= '�뱸������ �޼��� �Ŵ絿 321-86';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_g.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_g.getUser_id()%>';			
		}else if(fm.udt_firm.value == '������ڵ�����ǰ��'){				
			fm.udt_addr.value 	= '���ֱ����� ���걸 �󹫴�� 233 (������ 1360)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_j.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_j.getUser_id()%>';			
		}else if(fm.udt_firm.value == '<%=client.getFirm_nm()%>'){				
			fm.udt_addr.value 	= '<%=client.getO_addr()%>';
			fm.udt_mng_nm.value 	= '<%=client.getCon_agnt_dept()%> <%=client.getCon_agnt_nm()%> <%=client.getCon_agnt_title()%>';
			fm.udt_mng_tel.value 	= '<%=client.getO_tel()%>';
			fm.udt_mng_id.value     = '';		
		}
					
	}
	
	//����� ���÷���
	function cng_input2(){
		var fm = document.form1;
		if(fm.stock_yn[0].checked == true){ 				//����
			tr_stock1.style.display = '';		
			tr_stock2.style.display = 'none';		
		}else{								//����
			tr_stock1.style.display = 'none';		
			tr_stock2.style.display = '';		
		}
	}	
		
	//������-�ڵ����� �ݿ��ϱ�
	function fms_copy(){
		var fm = document.form1;
		<%if(cng_item.equals("cng")){%>  
		
			
			fm.car_nm.value 	= fm.f_car_nm.value;
			fm.opt.value 		= fm.f_opt.value;
			fm.purc_gu.value 	= fm.f_purc_gu.value;
			fm.colo.value 		= fm.f_colo.value;
			fm.auto.value    	= fm.f_auto.value;
			fm.car_c_amt.value    	= fm.f_car_c_amt.value;
			fm.car_f_amt.value    	= fm.f_car_f_amt.value;
			
			if(fm.car_off_id.value == '03900'){
				fm.dc_amt.value = parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );
			}
	
			set_car_amt();
		<%}%>
		
		<%if(cng_item.equals("amt")){%>
		
			fm.car_c_amt.value    	= fm.f_car_c_amt.value;
			fm.car_f_amt.value    	= fm.f_car_f_amt.value;
			
			//���԰� ���
			if(fm.car_f_amt.value == '0'){
				set_car_f_amt();
			}
			
			if(fm.car_off_id.value == '03900'){
				fm.dc_amt.value = parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );
			}
	
			set_car_amt();
		
		<%}%>
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
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="com_con_no" 	value="<%=com_con_no%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">    
  <input type='hidden' name="cng_item" 		value="<%=cng_item%>">
  <input type='hidden' name="seq" 		value="<%=seq%>">  
  <input type='hidden' name="udt_mng_id" 	value="">
  <input type='hidden' name="cng_size" 		value="<%=vt_size%>">
  <input type='hidden' name="car_off_id" 		value="<%=cpd_bean.getCar_off_id()%>">
  
  
  
  

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������� > <span class=style5>�������</span></span></td>
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
                    <td width=19%>&nbsp;<%=rent_l_cd%></td>
                    <td width=7% rowspan="2" class=title>��������</td>
                    <td width=7% class=title>�������</td>
                    <td width="19%" >&nbsp;<%=AddUtil.ChangeDate10(cpd_bean.getReg_dt())%></td>
                    <td width=7% rowspan="2" class=title>�����</td>
                    <td width=7% class=title>������</td>
                    <td width="20%">&nbsp;<%=dlv_mng_bean.getDept_nm()%>&nbsp;<%=dlv_mng_bean.getUser_nm()%>&nbsp;<%=dlv_mng_bean.getUser_pos()%></td>
    		    </tr>
                <tr>
                  <td class=title><%=cm_bean.getCar_comp_nm()%></td>
                  <td>&nbsp;<%=cpd_bean.getCom_con_no()%></td>
                  <td class=title>��������</td>
                  <td >&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_req_dt())%></td>
                  <td width=5% class=title>����ó</td>
                  <td>&nbsp;<%=dlv_mng_bean.getHot_tel()%></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>    
    
    <%if(cng_item.equals("dlv")){%>          
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="3" class=title>����</td>
                    <td width=7% class=title>����</td>
                    <td width=19%>&nbsp;
                        <%if(cpd_bean.getDlv_st().equals("2")){%>
                        [����]
        		&nbsp;
        		<input type='text' size='11' name='dlv_con_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		(��¥)
        		<%}else{%>
                        [����]
        		&nbsp;
        		<input type='text' size='11' name='dlv_est_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		(��¥)
        		<%}%>
        	    </td>
                    <td width=7% rowspan="3" class=title>�����</td>
                    <td width=7% class=title>����</td>
                    <td width="19%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==����==</option>
        				<option value="1" <%if(cpd_bean.getUdt_st().equals("1")){%> selected<%}%>>���ﺻ��</option>
        				<option value="2" <%if(cpd_bean.getUdt_st().equals("2")){%> selected<%}%>>�λ�����</option>
        				<option value="3" <%if(cpd_bean.getUdt_st().equals("3")){%> selected<%}%>>��������</option>				
        				<option value="5" <%if(cpd_bean.getUdt_st().equals("5")){%> selected<%}%>>�뱸����</option>
        				<option value="6" <%if(cpd_bean.getUdt_st().equals("6")){%> selected<%}%>>��������</option>				        				
        				<option value="4" <%if(cpd_bean.getUdt_st().equals("4")){%> selected<%}%>>��</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>�����</td>
                    <td width="7%" class=title>�μ�/����</td>
                    <td width="20%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cpd_bean.getUdt_mng_nm()%>' class='whitetext' ></td>
    		    </tr>    		   
                <tr>
                  <td class=title>���繫��</td>
                  <td>&nbsp;<%	//������ڵ�
        				if(emp2.getCar_comp_id().equals("0001")){
        					CodeBean[] p_codes = c_db.getCodeAll("0018");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0002")){
        					CodeBean[] p_codes = c_db.getCodeAll("0019");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0004")||emp2.getCar_comp_id().equals("0005")){
        					CodeBean[] p_codes = c_db.getCodeAll("0020");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0003")){
        					CodeBean[] p_codes = c_db.getCodeAll("0021");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			  <%}else{%>
        			  &nbsp;<input type='text' name='dlv_ext' size='15' value='<%=cpd_bean.getDlv_ext()%>' class='default' >
        			  <%}%>		
        	  </td>
                  <td class=title>����/��ȣ</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==����==</option>
        		    <%if(cpd_bean.getUdt_st().equals("1")){%>
        		    <option value="������ ����������" <%if(cpd_bean.getUdt_firm().equals("������ ����������")){%> selected<%}%>>������ ����������</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("2")){%>
        		    <option value="������������� ������" <%if(cpd_bean.getUdt_firm().equals("������������� ������")){%> selected<%}%>>������������� ������</option>
        		    <option value="�����̵���ǽ��� ����1�� ������" <%if(cpd_bean.getUdt_firm().equals("�����̵���ǽ��� ����1�� ������")){%> selected<%}%>>�����̵���ǽ��� ����1�� ������</option>
        		    <option value="����ī(������)" <%if(cpd_bean.getUdt_firm().equals("����ī(������)")){%> selected<%}%>>����ī(������)</option>
        		    <option value="������TS" <%if(cpd_bean.getUdt_firm().equals("������TS"))%> selected<%%>>������TS</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("3")){%>
        		    <option value="�̼���ũ" <%if(cpd_bean.getUdt_firm().equals("�̼���ũ")){%> selected<%}%>>�̼���ũ</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("5")){%>
        		    <option value="�뱸 ������" <%if(cpd_bean.getUdt_firm().equals("�뱸 ������")){%> selected<%}%>>�뱸 ������</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("6")){%>
        		    <option value="������ڵ�����ǰ��" <%if(cpd_bean.getUdt_firm().equals("������ڵ�����ǰ��")){%> selected<%}%>>������ڵ�����ǰ��</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cpd_bean.getUdt_firm().equals(client.getFirm_nm())){%> selected<%}%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select>
        		</td>
                  <td class=title>����ó</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cpd_bean.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
                <tr>
                  <td class=title>���Ź�۷�</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                  <td class=title>�ּ�</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cpd_bean.getUdt_addr()%>' class='whitetext' ></td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
        
    <%}%>
    
    <%if(cng_item.equals("stock")){%>          
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>�ֹ���</td>
                    <td colspan='2'>&nbsp;
                    	<%if(cpd_bean.getOrder_car().equals("") || cpd_bean.getOrder_car().equals("N") || (cpd_bean.getOrder_car().equals("Y") && cpd_bean.getOrder_req_dt().equals(""))){%>
                    	<input type="checkbox" name="order_car" value="Y" <%if(cpd_bean.getOrder_car().equals("Y")){%>checked<%}%>>�ֹ���
                    	<%}else{%>
                    	��Ȯ��ó���� �� ���¿����� �ֹ��� ������ �ȵ˴ϴ�.
                    	<input type='hidden' name='order_car' value='<%=cpd_bean.getOrder_car()%>'>
                    	<%}%>
                    </td>
                </tr>
                <tr>
                    <td width=14% class=title>�����</td>
                    <td width=19%>&nbsp;<input type='radio' name="stock_yn" value='N' <%if(cpd_bean.getStock_yn().equals("N")){%>checked<%}%> onClick="javascript:cng_input2()">
                      ����
                      <input type='radio' name="stock_yn" value='Y' <%if(cpd_bean.getStock_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input2()">
                      ����</td>
                    <td>
                        <table>
                            <tr id=tr_stock1 style="display:<%if(cpd_bean.getStock_yn().equals("N") || cpd_bean.getStock_yn().equals("")){%>''<%}else{%>none<%}%>">
                                <td>
                                    <input type='radio' name="stock_st" value='1' <%if(cpd_bean.getStock_st().equals("1")){%>checked<%}%>>
                      			������ü(1�����̻�)
                      		    <input type='radio' name="stock_st" value='2' <%if(cpd_bean.getStock_st().equals("2")){%>checked<%}%>>
                      			������ü(1�����̳�)
                      		    <input type='radio' name="stock_st" value='3' <%if(cpd_bean.getStock_st().equals("3")){%>checked<%}%>>
                      			��������(��1~2��)
                                </td>  
                            </tr>
                            <tr id=tr_stock2 style="display:<%if(cpd_bean.getStock_yn().equals("Y")){%>''<%}else{%>none<%}%>">
                                <td>
                                    ������ : 
                                    <input type='radio' name="stock_st" value='4' <%if(cpd_bean.getStock_st().equals("4")){%>checked<%}%>>
                      			�Ͻ���
                      		    <input type='radio' name="stock_st" value='5' <%if(cpd_bean.getStock_st().equals("5")){%>checked<%}%>>
                      			�����
                                </td>  
                            </tr>                          
                        </table>                      
                    </td>     
                </tr>
                <tr> 
                    <td width=14% class=title>Ư�̻���</td>
                    <td colspan='2'>&nbsp;<textarea rows='2' cols='90' name='bigo'><%=cpd_bean.getBigo()%></textarea></td>
                </tr>                 
            </table>
        </td>
    </tr>      
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>
        
    <%if(cng_item.equals("amt")){%> 
    <%		if(vt_size ==0 && nm_db.getWorkAuthUser("������",user_id)){%> 
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td colspan="3">&nbsp;<input type='text' name='car_nm' size='100' value='<%=pur_com.get("R_CAR_NM")%>' class='text' ></td>
                </tr>
                <tr> 
                    <td width=14% class=title>���û��</td>
                    <td colspan="3">&nbsp;<textarea rows='3' cols='100' name='opt' ><%=pur_com.get("R_OPT")%></textarea></td>
                </tr>
                 <tr> 
                    <td width=14% class=title>����(����/����/���Ͻ�)</td>
                    <td colspan="3">&nbsp;<input type='text' name='colo' size='100' value='<%=pur_com.get("R_COLO")%>' class='text' ></td>
                </tr>
                <tr>
                  <td class=title>��������</td>
                  <td width="19%">&nbsp;<input type='text' name='purc_gu' size='4' value='<%=pur_com.get("R_PURC_GU")%>' class='text' ></td>                  
                  <td width=14% class=title>T/M</td>
                  <td>&nbsp;<input type='text' name='auto' size='4' value='<%=pur_com.get("R_AUTO")%>' class='text' ></td>
                </tr>	
            </table>
        </td>
    </tr>    
    <%		}%>   
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>����</td>
                    <td width=7% class=title>�Һ��ڰ�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_c_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_f_amt();'>��</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getDc_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                    <td width="14%" class=title>D/C�հ�</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_d_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
    		    </tr>
                <tr>
                  <td class=title>���԰�</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_f_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��<a href="javascript:set_car_f_amt()" onMouseOver="window.status=''; return true" title="���԰� ����ϱ�">[���]</a></td>
                  <td class=title>�߰�D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getAdd_dc_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                  <td class=title>�ŷ��ݾװ�</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>   
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                    <td width=14% class=title>���Ź�۷�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��
                    <input type='hidden' name="cons_amt" value="<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>">    
                    <input type='hidden' name="purc_gu" value="<%=cpd_bean.getPurc_gu()%>">    
                    </td>
                    <td width=14% class=title>�հ�</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt()+cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                </tr>
            </table>
        </td>
    </tr>           
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>
    <tr>
        <td><hr></td>
    </tr>       
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ - �ڵ���</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <input type='hidden' name="f_car_c_amt" value="<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>">
                <input type='hidden' name="f_car_f_amt" value="<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>">
                <tr>
                  <td width=10% class=title>�Һ��ڰ�</td>
                  <td width=40%>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>��</td>
                  <td width=10% class=title>���԰�</td>
                  <td width=40%>&nbsp;<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>��</td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>D/C - ���� �������� �ݿ�</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                  <td width=10% class=title>D/C</td>
                  <td width=90%>&nbsp;<input type='text' name='v_dc_amt' size='10' value=''  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>��
                      &nbsp;&nbsp;&nbsp;&nbsp;(<%=ej_bean.getJg_y()*100%>%)
                  </td>
                </tr>	
            </table>
        </td>
    </tr>     
    <!--
    <tr>
	<td align='center'>
	    <a href="javascript:fms_copy()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[������-�ڵ��� ������ ���������� �ݿ��ϱ�]</a>
	</td>
    </tr>        	                 
    -->
    <%}%>
    <%if(cng_item.equals("cng")){%>     
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ຯ��</span></td>
    </tr>         
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���汸��</td>
                    <td colspan="3">&nbsp;<input type='text' name='cng_cont' size='60' value='' class='text' ></td>
                </tr>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td colspan="3">&nbsp;<input type='text' name='car_nm' size='100' value='<%=pur_com.get("R_CAR_NM")%>' class='text' ></td>
                </tr>
                <tr> 
                    <td width=14% class=title>���û��</td>
                    <td colspan="3" >&nbsp;<textarea rows='3' cols='100' name='opt' ><%=pur_com.get("R_OPT")%></textarea></td>
                </tr>
                <tr> 
                    <td width=14% class=title>����(����/����)</td>
                    <td colspan="3" >&nbsp;<input type='text' name='colo' size='100' value='<%=pur_com.get("R_COLO")%>' class='text' ></td>
                </tr>
                <tr>
                  <td class=title>��������</td>
                  <td width="19%">&nbsp;<input type='text' name='purc_gu' size='4' value='<%=pur_com.get("R_PURC_GU")%>' class='text' ></td>
                  <td width=14% class=title>T/M</td>
                  <td>&nbsp;<input type='text' name='auto' size='4' value='<%=pur_com.get("R_AUTO")%>' class='text' ></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>����</td>
                    <td width=7% class=title>�Һ��ڰ�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_C_AMT")))%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_DC_AMT")))%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                    <td width="14%" class=title>D/C�հ�</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_D_AMT")))%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
    		    </tr>
                <tr>
                  <td class=title>���԰�</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_F_AMT")))%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��<a href="javascript:set_car_f_amt()" onMouseOver="window.status=''; return true" title="���԰� ����ϱ�">[���]</a></td>
                  <td class=title>�߰�D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_ADD_DC_AMT")))%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                  <td class=title>�ŷ��ݾװ�</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_G_AMT")))%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                </tr>	
            </table>
        </td>
    </tr>        
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_G_AMT")))%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                    <td width=14% class=title>���Ź�۷�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��
                    <input type='hidden' name="cons_amt" value="<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>">    
                    </td>
                    <td width=14% class=title>�հ�</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(pur_com.get("R_CAR_G_AMT")))+cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                </tr>
            </table>
        </td>
    </tr>      
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>
    <tr>
        <td><hr></td>
    </tr>       
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������-�ڵ���</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <input type='hidden' name="f_car_nm" 	value="<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%>">
                <input type='hidden' name="f_opt" 	value="<%=car.getOpt()%>">
                <input type='hidden' name="f_purc_gu" 	value="<%if(car.getPurc_gu().equals("1")){%>����<%}else if(car.getPurc_gu().equals("0")){%>�鼼<%}%>">
                <input type='hidden' name="f_colo" 	value="<%=car.getColo()%>/<%=car.getIn_col()%>/<%=car.getGarnish_col()%>">                
                <input type='hidden' name="f_car_c_amt" value="<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>">
                <input type='hidden' name="f_car_f_amt" value="<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>">
                <input type='hidden' name="f_car_b" 	value="<%=cm_bean.getCar_b()%>">
                <tr> 
                    <td width=10% class=title>����</td>
                    <td colspan="3">&nbsp;<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
                    <td class=title>���û��</td>
                    <td colspan="5" >&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr>
                  <td class=title>��������</td>
                  <td width=5%>&nbsp;<%if(car.getPurc_gu().equals("1")){%>����<%}else if(car.getPurc_gu().equals("0")){%>�鼼<%}%></td>
                  <td width=10% class=title>����</td>
                  <td width=20%>&nbsp;����:<%=car.getColo()%>/����:<%=car.getIn_col()%>/���Ͻ�:<%=car.getGarnish_col()%></td>
                  <td width=10% class=title>T/M</td>
                  <td width=5%>&nbsp;<input type='text' name='f_auto' size='4' value='<%if(cm_bean.getAuto_yn().equals("Y")){%>A/T<%}else{%>M/T<%}%>' class='whitetext' ></td>
                  <td width=10% class=title>�Һ��ڰ�</td>
                  <td width=10%>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>��</td>
                  <td width=10% class=title>���԰�</td>
                  <td width=10%>&nbsp;<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>��</td>

                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
	<td align='center'>
	    <a href="javascript:fms_copy()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[������-�ڵ��� ������ ���������� �ݿ��ϱ�]</a>
	</td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>D/C - ���� �������� �ݿ�</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                  <td width=10% class=title>D/C</td>
                  <td width=90%>&nbsp;<input type='text' name='v_dc_amt' size='10' value=''  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>��
                      &nbsp;&nbsp;&nbsp;&nbsp;(<%=ej_bean.getJg_y()*100%>%)
                  </td>
                </tr>	
            </table>
        </td>
    </tr>         
    	     
    <%}%>
    <%if(cng_item.equals("cls1") || cng_item.equals("cls2")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>             
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>            
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td>&nbsp;<input type="radio" name="cng_cont" value="��ǰ���" <%if(cng_item.equals("cls1")){%>checked<%}%>>
            			��ǰ��� 
            			<!--
            			&nbsp;<input type="radio" name="cng_cont" value="���������Ȳ���� ������">
            			���������Ȳ���� ������ 
            			&nbsp;<input type="radio" name="cng_cont" value="��������" <%if(cng_item.equals("cls2")){%>checked<%}%>>
            			��������
            			 -->
            	    </td>
                </tr>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='bigo'></textarea></td>
                </tr>   
                <%if(cng_item.equals("cls1") && base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){%>      
                <tr> 
                    <td width=14% class=title>�������</td>
                    <td>&nbsp;<input type="radio" name="cont_use_yn" value="N">
            			�����Ѵ�
            		<input type="radio" name="cont_use_yn" value="Y">
            			��������Ѵ�
            			&nbsp;&nbsp;&nbsp;&nbsp;
            			( ����ڰ� (��)�Ƹ���ī�� ���������� �� ����ó�� ����)
            	    </td>
                </tr>                
                <%}%> 
                
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>
    <%if(cng_item.equals("re")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������û</span></td>
    </tr>             
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>            
                <tr> 
                    <td width=14% class=title>����</td>
                    <td>&nbsp;�������û <input type='hidden' name='cng_cont' value='�������û'> </td>
                </tr>
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td>&nbsp;<input type='text' name='pur_req_dt' value='<%=pur.getPur_req_dt()%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='bigo'></textarea></td>
                </tr>
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>    
    <%if(cng_item.equals("re_act")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������û �ݿ�</span></td>
    </tr>             
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>            
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td>&nbsp;���� <input type='hidden' name='dlv_st' value='1'> </td>
                </tr>
                <tr> 
                    <td width=14% class=title>�������</td>
                    <td>&nbsp;<input type='text' size='11' name='dlv_est_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>      
    <%if(cng_item.equals("cng_amt")){
    		//�������		
		CarPurDocListBean cng_bean = cod.getCarPurComCng(rent_mng_id, rent_l_cd, com_con_no, seq);
    	%>   
    	<input type='hidden' name="purc_gu" 		value="<%=cpd_bean.getPurc_gu()%>">
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>����</td>
                    <td width=7% class=title>�Һ��ڰ�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getCar_c_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getDc_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                    <td width="14%" class=title>D/C�հ�</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getCar_d_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
    		    </tr>
                <tr>
                  <td class=title>���԰�</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getCar_f_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��<a href="javascript:set_car_f_amt()" onMouseOver="window.status=''; return true" title="���԰� ����ϱ�">[���]</a></td>
                  <td class=title>�߰�D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getAdd_dc_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                  <td class=title>�ŷ��ݾװ�</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>   
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                    <td width=14% class=title>���Ź�۷�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��
                    <input type='hidden' name="cons_amt" value="<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>">    
                    </td>
                    <td width=14% class=title>�հ�</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt()+cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                </tr>
            </table>
        </td>
    </tr>            
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>D/C - ���� �������� �ݿ�</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                  <td width=10% class=title>D/C</td>
                  <td width=90%>&nbsp;<input type='text' name='v_dc_amt' size='10' value=''  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>��
                      &nbsp;&nbsp;&nbsp;&nbsp;(<%=ej_bean.getJg_y()*100%>%)
                  </td>
                </tr>	
            </table>
        </td>
    </tr>              
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	                 
    <%}%>   
    <%if(cng_item.equals("con")){%>          
    <input type='hidden' name="add_dc_amt" 		value="<%=pur_com.get("R_ADD_DC_AMT")%>">
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="3" class=title>����</td>
                    <td width=7% class=title>����</td>
                    <td width=19%>&nbsp;[����]
        		&nbsp;
        		<%  cpd_bean.setDlv_con_dt(AddUtil.getDate()); %>
        		<input type='text' size='11' name='dlv_con_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		(��¥)
        	    </td>
                    <td width=7% rowspan="3" class=title>�����</td>
                    <td width=7% class=title>����</td>
                    <td width="19%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==����==</option>
        				<option value="1" <%if(cpd_bean.getUdt_st().equals("1")){%> selected<%}%>>���ﺻ��</option>
        				<option value="2" <%if(cpd_bean.getUdt_st().equals("2")){%> selected<%}%>>�λ�����</option>
        				<option value="3" <%if(cpd_bean.getUdt_st().equals("3")){%> selected<%}%>>��������</option>				
        				<option value="5" <%if(cpd_bean.getUdt_st().equals("5")){%> selected<%}%>>�뱸����</option>
        				<option value="6" <%if(cpd_bean.getUdt_st().equals("6")){%> selected<%}%>>��������</option>				        				        				
        				<option value="4" <%if(cpd_bean.getUdt_st().equals("4")){%> selected<%}%>>��</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>�����</td>
                    <td width="7%" class=title>�μ�/����</td>
                    <td width="20%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cpd_bean.getUdt_mng_nm()%>' class='whitetext' ></td>
    		    </tr>
    		    <%	//�����ڵ��� ������ڵ�
    		    	CodeBean[] p_codes = c_db.getCodeAll("0018");
        		int p_size = p_codes.length;
        		String dlv_ext_yn = "";
    		    %>
                <tr>
                  <td class=title>���繫��</td>
                  <td>&nbsp;<select name='dlv_ext' class='default'>
                                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	        						
        						%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){  dlv_ext_yn = "Y";%> selected<%}%>><%= code.getNm()%></option>
        				<%	}%>        		
        				<option value="other">�����Է�</option>		
                                    </select>
                                    &nbsp;
                                    <input type='text' name='dlv_ext_sub' size='8' value='<%if(dlv_ext_yn.equals("")){%><%=cpd_bean.getDlv_ext()%><%}%>' class='text' >
        	  </td>
                  <td class=title>����/��ȣ</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==����==</option>
        		    <%if(cpd_bean.getUdt_st().equals("1")){%>
        		    <option value="������ ����������" <%if(cpd_bean.getUdt_firm().equals("������ ����������")){%> selected<%}%>>������ ����������</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("2")){%>
        		    <option value="������������� ������" <%if(cpd_bean.getUdt_firm().equals("������������� ������")){%> selected<%}%>>������������� ������</option>
        		    <option value="�����̵���ǽ��� ����1�� ������" <%if(cpd_bean.getUdt_firm().equals("�����̵���ǽ��� ����1�� ������")){%> selected<%}%>>�����̵���ǽ��� ����1�� ������</option>
        		    <option value="����ī(������)" <%if(cpd_bean.getUdt_firm().equals("����ī(������)")){%> selected<%}%>>����ī(������)</option>
        		    <option value="������TS" <%if(cpd_bean.getUdt_firm().equals("������TS"))%> selected<%%>>������TS</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("3")){%>
        		    <option value="�̼���ũ" <%if(cpd_bean.getUdt_firm().equals("�̼���ũ")){%> selected<%}%>>�̼���ũ</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("5")){%>
        		    <option value="�뱸 ������" <%if(cpd_bean.getUdt_firm().equals("�뱸 ������")){%> selected<%}%>>�뱸 ������</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("6")){%>
        		    <option value="������ڵ�����ǰ��" <%if(cpd_bean.getUdt_firm().equals("������ڵ�����ǰ��")){%> selected<%}%>>������ڵ�����ǰ��</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cpd_bean.getUdt_firm().equals(client.getFirm_nm())){%> selected<%}%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select></td>
                  <td class=title>����ó</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cpd_bean.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
                <tr>
                  <td class=title>���Ź�۷�</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                  <td class=title>�ּ�</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cpd_bean.getUdt_addr()%>' class='whitetext' ></td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
    
    <%}%>     
    
    <%if(cng_item.equals("cng2")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ �������</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>�������</td>
                    <td width=7% class=title>������</td>
                    <td width=19%>&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%><input type='hidden' name='dlv_con_dt_a' value='<%=cpd_bean.getDlv_con_dt()%>'></td>
                    <td width=7% rowspan="3" class=title>�����<br>(������)</td>
                    <td width=7% class=title>����</td>
                    <td width="19%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==����==</option>
        				<option value="1" <%if(cpd_bean.getUdt_st().equals("1")){%> selected<%}%>>���ﺻ��</option>
        				<option value="2" <%if(cpd_bean.getUdt_st().equals("2")){%> selected<%}%>>�λ�����</option>
        				<option value="3" <%if(cpd_bean.getUdt_st().equals("3")){%> selected<%}%>>��������</option>				
        				<option value="5" <%if(cpd_bean.getUdt_st().equals("5")){%> selected<%}%>>�뱸����</option>
        				<option value="6" <%if(cpd_bean.getUdt_st().equals("6")){%> selected<%}%>>��������</option>				        				        				        				
        				<option value="4" <%if(cpd_bean.getUdt_st().equals("4")){%> selected<%}%>>��</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>�����</td>
                    <td width="7%" class=title>�μ�/����</td>
                    <td width="20%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cpd_bean.getUdt_mng_nm()%>' class='text' ></td>
    		    </tr>    		    
                <tr>
                  <td class=title>������</td>
                  <td>&nbsp;<input type='text' size='11' name='dlv_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>        		
        	  </td>
                  <td class=title>����/��ȣ</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==����==</option>
        		    <%if(cpd_bean.getUdt_st().equals("1")){%>
        		    <option value="������ ����������" <%if(cpd_bean.getUdt_firm().equals("������ ����������")){%> selected<%}%>>������ ����������</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("2")){%>
        		    <option value="������������� ������" <%if(cpd_bean.getUdt_firm().equals("������������� ������")){%> selected<%}%>>������������� ������</option>
        		    <option value="�����̵���ǽ��� ����1�� ������" <%if(cpd_bean.getUdt_firm().equals("�����̵���ǽ��� ����1�� ������")){%> selected<%}%>>�����̵���ǽ��� ����1�� ������</option>
        		    <option value="����ī(������)" <%if(cpd_bean.getUdt_firm().equals("����ī(������)")){%> selected<%}%>>����ī(������)</option>
        		    <option value="������TS" <%if(cpd_bean.getUdt_firm().equals("������TS"))%> selected<%%>>������TS</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("3")){%>
        		    <option value="�̼���ũ" <%if(cpd_bean.getUdt_firm().equals("�̼���ũ")){%> selected<%}%>>�̼���ũ</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("5")){%>
        		    <option value="�뱸 ������" <%if(cpd_bean.getUdt_firm().equals("�뱸 ������")){%> selected<%}%>>�뱸 ������</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("6")){%>
        		    <option value="������ڵ�����ǰ��" <%if(cpd_bean.getUdt_firm().equals("������ڵ�����ǰ��")){%> selected<%}%>>������ڵ�����ǰ��</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cpd_bean.getUdt_firm().equals(client.getFirm_nm())){%> selected<%}%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select>
        		</td>
                  <td class=title>����ó</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cpd_bean.getUdt_mng_tel()%>' class='text' ></td>
                </tr>
                <tr>
                  <td class=title colspan="2">���Ź�۷�</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                  <td class=title>�ּ�</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cpd_bean.getUdt_addr()%>' class='text' ></td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
    
    <%}%>   
    
    <%if(cng_item.equals("cls3")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>             
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>            
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td>&nbsp;������� <input type='hidden' name='cng_cont' value='�������'>
            	    </td>
                </tr>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='bigo'></textarea></td>
                </tr>       
                <%if(base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){%>      
                <tr> 
                    <td width=14% class=title>�������</td>
                    <td>&nbsp;<input type="radio" name="cont_use_yn" value="N">
            			�����Ѵ�
            		<input type="radio" name="cont_use_yn" value="Y">
            			��������Ѵ�
            			&nbsp;&nbsp;&nbsp;&nbsp;
            			( ����ڰ� (��)�Ƹ���ī�� ���������� �� ����ó�� ����)
            	    </td>
                </tr>                
                <%}%>                             
            </table>
        </td>
    </tr>   
    <tr>
        <td> <font color=red>* �������ó���Ǹ� <b>������Ȳ</b>���� �Ѿ ���� �����°� �˴ϴ�. ������ �ƴմϴ�.</font>
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>     
    
    <%if(cng_item.equals("settle")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����û</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <%if(cpd_bean.getDlv_dt().equals("")) cpd_bean.setDlv_dt(AddUtil.getDate());%>
                    <td width=14% class=title>�������</td>
                    <td>&nbsp;<input type='text' size='11' name='dlv_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
 		</tr>    		    
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
    
    <%}%>      
    
    <%if(cng_item.equals("dlv_dt")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                    
                    <td width=14% class=title>�������</td>
                    <td>&nbsp;<input type='text' size='11' name='dlv_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
 		</tr>    		    
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>    
        
    <%if(cng_item.equals("com_con_no")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>Ư�ǰ���ȣ ����</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                     
                    <td width=14% class=title>����ȣ</td>
                    <td>&nbsp;<%=cpd_bean.getCom_con_no()%><input type='hidden' name="o_com_con_no" value="<%=cpd_bean.getCom_con_no()%>"> -> <input type='text' size='15' name='n_com_con_no' maxlength='20' class='default' value='<%=cpd_bean.getCom_con_no()%>'></td>
 		</tr>    		    
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
    
    <%}%>        
    
    
    <%if(cng_item.equals("cons_off")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Ź�ۻ�</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                    
                    <td width=14% class=title>���Ź�ۻ�</td>
                    <td>&nbsp;��ȣ : <input type='text' name='cons_off_nm' maxlength='50' value='<%=cpd_bean.getCons_off_nm()%>' class='text' size='40' >
                  	&nbsp;&nbsp;&nbsp;&nbsp;
                  	����ó : <input type='text' name='cons_off_tel' maxlength='50' value='<%=cpd_bean.getCons_off_tel()%>' class='text' size='20' >
                  </td>
 		</tr>    		    
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>     
    
    <%if((cng_item.equals("cls1") || cng_item.equals("cls2")) && !base.getUse_yn().equals("N")){%>  
    <tr> 
        <td>�� ����������� ����ó�� �Ϸ�Ǹ� ������������ �ڵ���ϵ˴ϴ�. (���������Ȳ���� ������� �������������� ��ü �����մϴ�.)<!-- ���������Ȳ���� ������� ����������� ���� ó���ؾ� �մϴ�. --></td>
    </tr>  
    <!-- 
    <%	if(cpd_bean.getDlv_st().equals("1") && AddUtil.parseInt(cpd_bean.getDlv_est_dt()) <= AddUtil.parseInt(AddUtil.getDate(4)) ){%>
    <tr> 
        <td>�� �������ڰ� ����Ǿ����ϴ�. ������� ����Ⱓ ����� �ȵ˴ϴ�. ���������Ȳ���� �����⸦ �Ϸ��� ������ڿ��� ������ �����û�� �Ͻʽÿ�.</td>
    </tr>      
    <%	}%>
    <%	if(cpd_bean.getDlv_st().equals("2") && AddUtil.parseInt(cpd_bean.getDlv_con_dt()) <= AddUtil.parseInt(AddUtil.getDate(4)) ){%>
    <tr> 
        <td>�� �������ڰ� ����Ǿ����ϴ�. ������� ����Ⱓ ����� �ȵ˴ϴ�. ���������Ȳ���� �����⸦ �Ϸ��� ������ڿ��� ������ �����û�� �Ͻʽÿ�.</td>
    </tr>      
    <%	}%>
     -->
    <%}%>         
              
</table>
</form>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	<%if(cng_item.equals("cng")){%>     
		if(fm.f_auto.value == 'M/T' && fm.f_car_b.value.indexOf('�ڵ����ӱ�') != -1){
			fm.f_auto.value = 'A/T';
		}
		if(fm.f_auto.value == 'M/T' && fm.f_opt.value.indexOf('���ӱ�') != -1){
			fm.f_auto.value = 'A/T';
		}
		if(fm.f_auto.value == 'M/T' && fm.f_opt.value.indexOf('DCT') != -1){
			fm.f_auto.value = 'A/T';
		}
		if(fm.f_auto.value == 'M/T' && fm.f_opt.value.indexOf('C-TECH') != -1){
			fm.f_auto.value = 'A/T';
		}	
		if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('A/T') != -1){
			fm.auto.value = 'A/T';
		}			
		if(fm.f_auto.value == 'M/T' && fm.f_car_b.value.indexOf('���� ���ӱ�') != -1){
			fm.f_auto.value = 'A/T';
		}
	<%}%>
	
	
	<%if(cng_item.equals("amt") || cng_item.equals("cng") || cng_item.equals("cng_amt")){%>         
        fm.v_dc_amt.value = parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );         
        <%}%>
        
        //���������� ���Ź�۷� �������ϰ� �Ѵ�.
        <%if(cng_item.equals("dlv") || cng_item.equals("con") || cng_item.equals("cng2")){%>
        <%	if(cpd_bean.getUdt_st().equals("3")){%>
        <%		if(user_id.equals("000048") || user_id.equals("000197")){%>								
			<%}else{%>
        //fm.cons_amt.readOnly = true;   // readonly
        <%		}%>
        <%	}%>
        <%}%>
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

