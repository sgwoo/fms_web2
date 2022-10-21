<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="LcScanDb" class="acar.cont.LcScanDatabase" scope="page" />
<jsp:useBean id="LcScanBn" class="acar.cont.LcScanBean" scope="page" />
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")){ base.setCar_gu(base.getReg_id()); }
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//���뺸��������
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//��������+������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	Vector commis = a_db.getCommis(emp1.getEmp_id());
	int commi_size = commis.size();
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
	
	//����ǰ��
	DocSettleBean doc = new DocSettleBean();
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("1", rent_l_cd);
		doc_no = doc.getDoc_no();
	}else{
		doc = d_db.getDocSettle(doc_no);
	}
	
	user_bean 	= umd.getUsersBean(user_id);
	
	
	
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����Ʈ
	function list(){
		var fm = document.form1;			
		fm.action = 'commi_doc_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//�����������
	function view_emp(emp_id){
		var fm = document.form1;
		window.open("/acar/car_office/car_office_p_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_c_c_fee.jsp&cmd=view&emp_id="+emp_id, "VIEW_EMP", "left=50, top=50, width=850, height=600, scrollbars=yes");
	}
	
	//�����ȣ �˻�
	function search_zip(str){
		window.open("../lc_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
	
	//��ĵ���
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&emp_id=<%=emp1.getEmp_id()%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//��ĵ����
	function scan_del(file_st){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
		fm.file_st.value = file_st;
		fm.target = "i_no"
		fm.action = "del_scan_a.jsp";
		fm.submit();
	}	

	//����������
	function set_amt(){
		var fm = document.form1;
		var per = 1;
		
		if(fm.rec_incom_st.value != ''){
			if(fm.rec_incom_st.value == '2') 		per = 0.03;
			else if(fm.rec_incom_st.value == '3') 	per = 0.05;		
			
			fm.inc_per.value = per*100;
			fm.res_per.value = per*10;
			fm.tot_per.value = per*110;

			fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_amt1.value)) + toInt(parseDigit(fm.add_amt2.value)) + toInt(parseDigit(fm.add_amt3.value))); 	
			fm.a_amt.value = fm.add_tot_amt.value; 	
			fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.a_amt.value))); 	
			
			fm.inc_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.b_amt.value)) * per )); 
			fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			

			fm.c_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) - toInt(parseDigit(fm.c_amt.value))); 			
		}else{
			alert('�Ǽ������� �ҵ汸�и� �Է��Ͽ� �ֽʽÿ�.');
		}
	}
	
	function save(){
		var fm = document.form1;

		if(fm.emp_acc_nm.value == '')	{	alert('�Ǽ����� �̸��� �Է��Ͽ� �ֽʽÿ�.'); 				return;		}
		if(fm.rel.value == '')			{	alert('�Ǽ������� ����������� ���踦 �Է��Ͽ� �ֽʽÿ�.'); return;		}
		if(fm.rec_incom_yn.value == '')	{	alert('�Ǽ������� Ÿ�ҵ濩�θ� �Է��Ͽ� �ֽʽÿ�.'); 		return;		}
		if(fm.rec_incom_st.value == '')	{	alert('�Ǽ������� �ҵ汸�и� �Է��Ͽ� �ֽʽÿ�.'); 			return;		}
		if(fm.emp_bank.value == '')		{	alert('�Ǽ��� ������ �Է��Ͽ� �ֽʽÿ�.'); 					return;		}
		if(fm.emp_acc_no.value == '')	{	alert('�Ǽ��� ���¹�ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 				return;		}
		if(fm.rec_ssn.value == '')		{	alert('�Ǽ������� �ֹι�ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 			return;		}
		if(fm.t_zip.value == '')		{	alert('�Ǽ������� �����ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 			return;		}
		if(fm.t_addr.value == '')		{	alert('�Ǽ������� �ּҸ� �Է��Ͽ� �ֽʽÿ�.'); 				return;		}
		if(fm.b_amt.value == '0')		{	alert('�ҵ�ݾ��� Ȯ���Ͻʽÿ�.'); 							return;		}
		if(fm.c_amt.value == '0')		{	alert('�����ݾ��� Ȯ���Ͻʽÿ�.'); 							return;		}		
		if(fm.d_amt.value == '0')		{	alert('�������޾��� Ȯ���Ͻʽÿ�.'); 						return;		}		
		
		if(confirm('���� �Ͻðڽ��ϱ�?')){	
			fm.action='commi_doc_u_a.jsp';		
			fm.target='d_content';			
			fm.submit();
		}							
	}		
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='commi_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="emp_id" 		value="<%=emp1.getEmp_id()%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="gur_size" 		value="<%=gur_size%>">  
  <input type='hidden' name="mode" 			value="<%=mode%>">    
  <input type='hidden' name="file_st" 		value="">    
  <input type='hidden' name="doc_bit" 		value="">      
    
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
	  <td align='left'><font color="navy">�������� -> </font><font color="navy">�������</font> -> <font color="red">��������ǰ��</font></td>
	</tr>
    <tr>
	  <td align='right'><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
	</tr>	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>����ȣ</td>
            <td width=15%>&nbsp;<%=rent_l_cd%></td>
            <td class=title width=10%>��ȣ</td>
            <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
            <td class=title width=10%>����ڹ�ȣ</td>
            <td width=15%>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
		  </tr>	
          <tr> 
            <td class=title width=10%>�뵵����</td>
            <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
            <td class=title width=10%>��������</td>
            <td width=15%>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}else if(rent_way.equals("2")){%>�����<%}%></td>
            <td class=title width=10%>�̿�Ⱓ</td>
            <td width=15%>&nbsp;<%=fee.getCon_mon()%>����</td>
            <td class=title width=10%>���뿩��</td>
            <td width=15%>&nbsp;<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>��</td>
		  </tr>	
          <tr>
            <td class=title width=10%>��ǰ����</td>
            <td width=15%>&nbsp;</td>
            <td class=title width=10%>�뿩������</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
            <td class=title width=10%>���ݱ���</td>
            <td width=15%>&nbsp;<%if(cms.getCms_acc_no().equals("")){%>������<%}else{%>CMS<%}%></td>
            <td class=title width=10%>���ݰ�꼭</td>
            <td width=15%>&nbsp;
			  <%if(cont_etc.getRec_st().equals("") && client.getEtax_not_cau().equals("")){ 	cont_etc.setRec_st("1"); }
			    if(cont_etc.getRec_st().equals("") && !client.getEtax_not_cau().equals("")){  cont_etc.setRec_st("2"); }
				if(cont_etc.getRec_st().equals("1")){ 	out.print("����");
				}else{									out.print("����"); }%>
				</td>
		  </tr>	
          <tr>
            <td class=title width=10%>���ۻ��</td>
            <td width=15%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
            <td class=title width=10%>����</td>
            <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
            <td class=title width=10%>��ⷮ</td>
            <td width=15%>&nbsp;<%=cm_bean.getDpm()%>cc</td>
		  </tr>	
		</table>
	  </td>
	</tr> 
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>  	 	  
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>�������</td>
            <td width=25%>&nbsp;��������</td>
            <td class=title width=15%>����</td>
            <td class=title width=25%>����</td>
            <td class=title width=25%>����</td>
		  </tr>	
          <tr> 
            <td class=title>���԰���</td>
            <td>&nbsp;<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt()-car.getDc_cs_amt()-car.getDc_cv_amt())%>��</td>			
			<td class=title>������</td>		
            <td>&nbsp;<%=emp1.getComm_rt()%>%</td>
            <td>&nbsp;<%=emp1.getComm_r_rt()%>%</td>
		  </tr>	
          <tr> 
            <td class=title>������ذ���</td>
            <td>&nbsp;<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>��</td>
			<td class=title>�����ݾ�</td>		
            <td>&nbsp;<%=AddUtil.parseDecimal( emp1.getCommi_car_amt()*emp1.getComm_rt()/100 )%>��</td>
            <td>&nbsp;<%=AddUtil.parseDecimal( emp1.getCommi_car_amt()*emp1.getComm_r_rt()/100 )%>��</td>
		  </tr>	
		</table>
	  </td>
	</tr>  	  	 
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>  
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>�������</td>
            <td width=15%>&nbsp;<a href="javascript:view_emp('<%=emp1.getEmp_id()%>');"><%=emp1.getEmp_nm()%></a></td>
            <td class=title width=10%>�����Ҹ�</td>
            <td width=15%>&nbsp;<%=emp1.getCar_off_nm()%></td>
            <td class=title width=10%>�ٷ�����</td>
            <td width=15%>&nbsp;<%if(coe_bean.getJob_st().equals("1")){%>������<%}else if(coe_bean.getJob_st().equals("2")){%>��������<%}%></td>
            <td class=title width=10%>�ҵ汸��</td>
            <td width=15%>&nbsp;<%if(coe_bean.getCust_st().equals("2")){%>����ҵ�<%}else if(coe_bean.getCust_st().equals("3")){%>��Ÿ����ҵ�<%}%></td>
		  </tr>	
		</table>
	  </td>
	</tr>  	  
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 
	<tr>
	  <td align="right"><hr></td>
	<tr> 
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10% rowspan="2">�߽�</td>
            <td class=title width=15%>������</td>
            <td class=title width=10%><%=doc.getUser_nm1()%></td>
            <td class=title width=15%><%=doc.getUser_nm2()%></td>
            <td class=title width=10%><%=doc.getUser_nm3()%></td>
            <td class=title width=15%>&nbsp;</td>
            <td class=title width=10%>&nbsp;</td>
            <td class=title width=15%><%=doc.getUser_nm4()%></td>
		  </tr>	
          <tr> 
            <td align="center"><%=user_bean.getBr_nm()%></td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id1(),"USER")%><br><%=doc.getUser_dt1()%></td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id2(),"USER")%><br><%=doc.getUser_dt2()%><%if(doc.getUser_dt2().equals("") && doc.getDoc_bit().equals("1") && !doc.getUser_nm2().equals("XXXXXX")){%><%if(nm_db.getWorkAuthUser(user_bean.getBr_nm()+"��",user_id) || nm_db.getWorkAuthUser("������",user_id)){%><a href="javascript:doc_sanction('2')">����</a><%}%><br>&nbsp;<%}%></td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id3(),"USER")%><br><%=doc.getUser_dt3()%><%if(doc.getUser_dt3().equals("") && doc.getDoc_bit().equals("2")){                                       %><%if(nm_db.getWorkAuthUser("���翵������",user_id) || nm_db.getWorkAuthUser("������",user_id)){           %><a href="javascript:doc_sanction('3')">����</a><%}%><br>&nbsp;<%}%></td>
            <td align="center">&nbsp;<br>&nbsp;<br>&nbsp;<br></td>
            <td align="center">&nbsp;</td>
            <td align="center"><!--<%=c_db.getNameById(doc.getUser_id4(),"USER")%><br><%=doc.getUser_dt4()%><%if(doc.getUser_dt4().equals("")){																		  %><%if(nm_db.getWorkAuthUser("��ǥ�̻�",user_id) || nm_db.getWorkAuthUser("������",user_id)){               %><a href="javascript:doc_sanction('4')">����</a><%}%><br>&nbsp;<%}%>--></td>
		  </tr>	
		</table>
	  </td>
	</tr>  	  
	<tr>
	  <td align="right">&nbsp;</td>
	</tr> 	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>������</td>
            <td width=15%>&nbsp;
			  <%String pp_st = "";
			  	int pp_amt = fee.getGrt_amt_s()+fee.getPp_s_amt()+fee.getIfee_s_amt();
				if(pp_amt == 0){
					pp_st = "����";
				}else{
					String pp_st1 = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "0");
				  	String pp_st2 = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "1");
				  	String pp_st3 = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "2");
					if(pp_st1.equals("���Ա�") || pp_st1.equals("�ܾ�")){ pp_st = "�̰�"; }
					if(pp_st2.equals("���Ա�") || pp_st2.equals("�ܾ�")){ pp_st = "�̰�"; }
					if(pp_st3.equals("���Ա�") || pp_st3.equals("�ܾ�")){ pp_st = "�̰�"; }
					if(pp_st.equals("")){ pp_st = "�ϰ�"; }
				}%>
				<%=pp_st%><input type='hidden' name='pp_st' value='<%=pp_st%>'></td>
            <td class=title width=10%>�ϰΌ����</td>
            <td width=15%>&nbsp;<input type='text' size='11' name='pp_est_dt' maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
            <td class=title width=10%>�̰����</td>
            <td width=40%>&nbsp;<input type='text' name='pp_etc' size='40' value='<%=fee.getPp_etc()%>' class='whitetext'></td>
		  </tr>
          <tr> 
            <td class=title width=10%>��������</td>
            <td width=15%>&nbsp;
			  <%String gi_st = "";
			  	if(gins.getGi_st().equals("0")){
					gi_st = "����";
			  	}else{
					if(gins.getGi_dt().equals("")){ 	gi_st = "�̰�";
					}else{							gi_st = "�ϰ�"; }
				}
			  %>
			  <%=gi_st%><input type='hidden' name='gi_st' value='<%=gi_st%>'></td>
            <td class=title width=10%>�ϰΌ����</td>
            <td width=15%>&nbsp;<input type='text' size='11' name='gi_est_dt maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(gins.getGi_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
            <td class=title width=10%>�̰����</td>
            <td width=40%>&nbsp;<input type='text' name='gi_etc' size='40' value='<%=gins.getGi_etc()%>' class='whitetext'></td>
		  </tr>	
		  <%for(int i = 0 ; i < gur_size ; i++){
				Hashtable gur = (Hashtable)gurs.elementAt(i);%>
          <tr> 
            <td class=title width=10%>���뺸��</td>
            <td width=15%>&nbsp;
			  <%String gur_st = "�ϰ�";
				LcScanBean scan1 = LcScanDb.getLcScanCase(rent_mng_id, rent_l_cd, "11", String.valueOf(gur.get("GUR_NM")));
				LcScanBean scan2 = LcScanDb.getLcScanCase(rent_mng_id, rent_l_cd, "12", String.valueOf(gur.get("GUR_NM")));
				LcScanBean scan3 = LcScanDb.getLcScanCase(rent_mng_id, rent_l_cd, "13", String.valueOf(gur.get("GUR_NM")));
				if(scan1.getFile_name().equals("") || scan2.getFile_name().equals("") || scan3.getFile_name().equals("")){ gur_st = "�̰�"; }
			  %>
			  <%=gur_st%><input type='hidden' name='gur_st' value='<%=gur_st%>'></td>
            <td class=title width=10%>�ϰΌ����</td>
            <td width=15%>&nbsp;<input type='text' size='11' name='gur_est_dt' maxlength='10' class="whitetext" value='<%=gur.get("GUR_EST_DT")%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
            <td class=title width=10%>�̰����</td>
            <td width=40%>&nbsp;<input type='text' name='gur_etc' size='40' value='<%=gur.get("GUR_ETC")%>' class='whitetext'></td>
		  </tr>	
		  <%}%>
		  <%if(gur_size==0){%>
          <tr> 
            <td class=title width=10%>���뺸��</td>
            <td width=15%>&nbsp;
			  ����<input type='hidden' name='gur_st' value='����'></td>
            <td class=title width=10%>�ϰΌ����</td>
            <td width=15%>&nbsp;<input type='text' size='11' name='gur_est_dt' maxlength='10' class="whitetext" value='' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
            <td class=title width=10%>�̰����</td>
            <td width=40%>&nbsp;<input type='text' name='gur_etc' size='40' value='' class='whitetext'></td>
		  </tr>			  
		  <%}%>
		</table>
	  </td>
	</tr>  	    	  	
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>�Ǽ�����</td>
            <td width=15%>&nbsp;<input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="16" class='text'></td>
            <td class=title width=10%>����</td>
            <td width=15%>&nbsp;<input type='text' name="rel" value='<%=emp1.getRel()%>' size="16" class='text'></td>
            <td class=title width=10%>Ÿ�ҵ�</td>
            <td width=15%>&nbsp;
			  <select name="rec_incom_yn">
                <option value="">==����==</option>
				<option value="1" <%if(emp1.getRec_incom_yn().equals("1")){%> selected <%}%>>��</option>
				<option value="2" <%if(emp1.getRec_incom_yn().equals("2")){%> selected <%}%>>��</option>							
			  </select>
			</td>
            <td class=title width=10%>�ҵ汸��</td>
            <td width=15%>&nbsp;
			  <select name="rec_incom_st">
                <option value="">==����==</option>
				<option value="2" <%if(emp1.getRec_incom_st().equals("2")){%> selected <%}%>>����ҵ�</option>
				<option value="3" <%if(emp1.getRec_incom_st().equals("3")){%> selected <%}%>>��Ÿ����ҵ�</option>							
			  </select>
            </td>
		  </tr>	
          <tr> 
            <td class=title width=10%>�ŷ�����</td>
            <td width=15%>&nbsp;<select name='emp_bank'>
                <option value=''>����</option>
                <%	if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];%>
                <option value='<%= bank.getNm()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                <%		}
					}%>
              </select></td>
            <td class=title width=10%>���¹�ȣ</td>
            <td colspan="3">&nbsp;<input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="30" class='text'></td>
            <td class=title width=10%>�ֹι�ȣ</td>
            <td width=15%>&nbsp;<input type='text' name="rec_ssn" value='<%=emp1.getRec_ssn()%>' size="16" class='text'></td>
		  </tr>	
          <tr> 
            <td class=title width=10%>�ּ�</td>
            <td colspan="3">&nbsp;<input type='text' name="t_zip" value='<%=emp1.getRec_zip()%>' size="7" class='text' readonly onClick="javascript:search_zip('')">
			  &nbsp;<input type='text' name="t_addr" value='<%=emp1.getRec_addr()%>' size="40" class='text'></td>
            <td class=title width=10%>�ź����纻</td>
            <td width=15%>&nbsp;<a href="javascript:scan_reg('2')">���</a>&nbsp;<%if(!emp1.getFile_name2().equals("")){%><a href="javascript:MM_openBrWindow('<%= emp1.getFile_name2() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')">����</a><%}%></td>
            <td class=title width=10%>����纻</td>
            <td width=15%>&nbsp;<a href="javascript:scan_reg('1')">���</a>&nbsp;<%if(!emp1.getFile_name1().equals("")){%><a href="javascript:MM_openBrWindow('<%= emp1.getFile_name1() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')">����</a><%}%></td>
		  </tr>	
		</table>
	  </td>
	</tr>  	  
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td colspan="2" class=title>����</td>
            <td class=title width=15%>�ݾ�</td>
            <td class=title width=10%>����</td>
            <td width=3% rowspan="6" class=title>��<br>��<br></td>
            <td class=title width=12%>�ݾ�</td>
            <td class=title width=50%>����</td>
          </tr>	
          <tr> 
            <td width="3%" rowspan="3" class=title>��<br>��<br></td>
            <td width="7%" class=title>��������</td>
            <td align="center"><input type='text' name='commi' maxlength='10' value='<%=Util.parseDecimal(emp1.getCommi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
            <td align="center">&nbsp;</td>
            <td align="center"><input type='text' name='add_amt1' maxlength='8' value='<%=Util.parseDecimal(emp1.getAdd_amt1())%>' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
            <td>&nbsp;
              <input name="add_cau1" type="text" class="text" value="<%=emp1.getAdd_cau1()%>" size="50"></td>
          </tr>
          <tr>
            <td class=title>�����Ѿ�</td>
            <td align="center"><input type='text' name='a_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getAdd_amt1()+emp1.getAdd_amt2()+emp1.getAdd_amt3())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
            <td align="center">&nbsp;</td>
            <td align="center"><input type='text' name='add_amt2' maxlength='8' value='<%=Util.parseDecimal(emp1.getAdd_amt2())%>' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
            <td>&nbsp;
                <input name="add_cau2" type="text" class="text" value="<%=emp1.getAdd_cau2()%>" size="50"></td>
          </tr>
          <tr>
            <td class=title>�Ұ�</td>
            <td align="center"><input type='text' name='b_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getCommi()+emp1.getAdd_amt1()+emp1.getAdd_amt2()+emp1.getAdd_amt3())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
            <td align="center">&nbsp;</td>
            <td align="center"><input type='text' name='add_amt3' maxlength='8' value='<%=Util.parseDecimal(emp1.getAdd_amt3())%>' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
            <td>&nbsp;
              <input name="add_cau3" type="text" class="text" value="<%=emp1.getAdd_cau3()%>" size="50"></td>
          </tr>
          <tr>
            <td rowspan="3" class=title>��<br>��<br></td>
            <td class=title>�ҵ漼</td>
            <td align="center"><input type='text' name='inc_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getInc_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' set_amt();></td>
            <td align="center"><input type='text' name='inc_per' maxlength='3' value='<%=emp1.getInc_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
            <td align="center">-</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class=title>���漼</td>
            <td align="center"><input type='text' name='res_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getRes_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' set_amt();></td>
            <td align="center"><input type='text' name='res_per' maxlength='3' value='<%=emp1.getRes_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
            <td align="center">-</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class=title>�Ұ�</td>
            <td align="center"><input type='text' name='c_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getTot_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
            <td align="center"><input type='text' name='tot_per' maxlength='3' value='<%=emp1.getTot_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value);'>%</td>
            <td width=3% class=title>�Ұ�</td>
            <td align="center"><input type='text' name='add_tot_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getAdd_amt1()+emp1.getAdd_amt2()+emp1.getAdd_amt3())%>' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class=title>�������޾�</td>
            <td align="center"><input type='text' name='d_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getCommi()+emp1.getAdd_amt1()+emp1.getAdd_amt2()+emp1.getAdd_amt3()-emp1.getTot_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
</td>
            <td colspan="4">&nbsp;�������޾� = �ҵ� - ����</td>
          </tr>	
		</table>
	  </td>
	</tr>  
	<tr>
	  <td align="right">&nbsp;</td>
	<tr>  	
    <tr>
	  <td align='center'>
	  <input type="button" name="b_selete" value="����" onClick="javascript:save();">&nbsp;
	  <%if(!doc.getUser_dt8().equals("")){%><input type="button" name="b_selete" value="ó��" onClick="javascript:update();">&nbsp;<%}%>
	  </td>
	</tr>			  
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>
	<%if(mode.equals("6")||mode.equals("7")||mode.equals("8")||mode.equals("9")||mode.equals("10")){%>
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10% rowspan="2">����</td>
            <td class=title width=15%><%=doc.getUser_nm6()%></td>
            <td class=title width=10%><%=doc.getUser_nm7()%></td>
            <td class=title width=15%><%=doc.getUser_nm8()%></td>
            <td class=title width=10%>&nbsp;</td>
            <td class=title width=15%>&nbsp;</td>
            <td class=title width=10%>&nbsp;</td>
            <td class=title width=15%><%=doc.getUser_nm9()%></td>
		  </tr>	
          <tr> 
            <td align="center"><%=c_db.getNameById(doc.getUser_id6(),"USER")%><br><%=doc.getUser_dt6()%><%if(doc.getUser_dt6().equals("")){%><%if(nm_db.getWorkAuthUser("�����ⳳ",user_id) || nm_db.getWorkAuthUser("������",user_id)){  %><a href="javascript:doc_sanction('6')">����</a><%}%><br>&nbsp;<%}%></td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id7(),"USER")%><br><%=doc.getUser_dt7()%><%if(doc.getUser_dt7().equals("")){%><%if(nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("������",user_id)){    %><a href="javascript:doc_sanction('7')">����</a><%}%><br>&nbsp;<%}%></td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id8(),"USER")%><br><%=doc.getUser_dt8()%><%if(doc.getUser_dt8().equals("")){%><%if(nm_db.getWorkAuthUser("�����ѹ�����",user_id) || nm_db.getWorkAuthUser("������",user_id)){%><a href="javascript:doc_sanction('8')">����</a><%}%><br>&nbsp;<%}%></td>
            <td align="center">&nbsp;<br>&nbsp;<br>&nbsp;<br></td>
            <td align="center">&nbsp;</td>
            <td align="center">&nbsp;</td>
            <td align="center"><!--<%=c_db.getNameById(doc.getUser_id9(),"USER")%><br><%=doc.getUser_dt9()%><%if(doc.getUser_dt9().equals("")){%><%if(nm_db.getWorkAuthUser("��ǥ�̻�",user_id) || nm_db.getWorkAuthUser("������",user_id)){    %><a href="javascript:doc_sanction('9')">����</a><%}%><br>&nbsp;<%}%>--></td>
		  </tr>	
		</table>
	  </td>
	</tr>  	  
	<tr>
	  <td align="right">&nbsp;</td>
	</tr> 	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>��������</td>
            <td width=15%>&nbsp;</td>
            <td class=title width=10%>����</td>
            <td width=15%>&nbsp;</td>
            <td class=title width=10%>�ѽ�</td>
            <td width=15%>&nbsp;</td>
            <td class=title width=10%>�ڵ���ǥ</td>
            <td width=15%>&nbsp;</td>
          </tr>	
		</table>
	  </td>
	</tr>  	  	
    <tr>
	  <td align='center'>&nbsp;</td>
	</tr>			
	<%}%>	
	<tr>
	  <td align="right"><hr></td>
	<tr> 
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10% rowspan="3">����</td>
            <td class=title colspan="4">���س⵵</td>
            <td class=title colspan="3">����(��������)</td>
		  </tr>	
          <tr> 
            <td class=title width=15%>�������</td>
            <td class=title width=10%>���ޱݾ�</td>
            <td class=title width=15%>���޿����ݾ�</td>
            <td class=title width=10%>�հ�</td>
            <td class=title width=15%>�������</td>
            <td class=title width=10%>���ޱݾ�</td>
            <td class=title width=15%>����(�����������)</td>
		  </tr>	
          <tr> 
            <td align="center"><input type='text' name='now_val1' value='' class='whitenum' size='10'></td>
            <td align="center"><input type='text' name='now_val2' value='' class='whitenum' size='10'></td>
            <td align="center"><input type='text' name='now_val3' value='' class='whitenum' size='10'></td>
            <td align="center"><input type='text' name='now_val4' value='' class='whitenum' size='10'></td>
            <td align="center"><input type='text' name='old_val1' value='' class='whitenum' size='10'></td>
            <td align="center"><input type='text' name='old_val2' value='' class='whitenum' size='10'></td>
            <td align="center"><input type='text' name='old_val3' value='' class='whitenum' size='10'></td>
		  </tr>	
		</table>
	  </td>
	</tr>  	  
    <tr>
	  <td align='center'>&nbsp;</td>
	</tr>	
	<%	int now_val1 = 0;
		int now_val2 = 0;
		int now_val3 = 0;
		int now_val4 = 0;
		int old_val1 = 0;
		int old_val2 = 0;
	%>
	<%if(commi_size > 0){%>
	<tr>
	  <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
            <td class=title width=12%>����ȣ</td>
            <td class=title width=13%>��</td>
            <td class=title width=10%>��������</td>
            <td class=title width=10%>������</td>
            <td class=title width=10%>��������</td>
            <td class=title width=10%>�����ݾ�</td>
            <td class=title width=10%>�ҵ漼</td>
            <td class=title width=10%>�ֹμ�</td>
            <td class=title width=5%>����</td>
            <td class=title width=10%>�������޾�</td>																								
		  </tr>
		
          <%for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);
				int car_commi_amt= AddUtil.parseInt(String.valueOf(commi.get("COMMI_CAR_AMT")));
				int commi_amt	= AddUtil.parseInt(String.valueOf(commi.get("COMMI")));
				int add_amt 	= AddUtil.parseInt(String.valueOf(commi.get("ADD_AMT1")))+AddUtil.parseInt(String.valueOf(commi.get("ADD_AMT2")))+AddUtil.parseInt(String.valueOf(commi.get("ADD_AMT3")));
				int tot_amt 	= AddUtil.parseInt(String.valueOf(commi.get("TOT_AMT")));
				int inc_amt 	= AddUtil.parseInt(String.valueOf(commi.get("INC_AMT")));
				int res_amt 	= AddUtil.parseInt(String.valueOf(commi.get("RES_AMT")));
				int dif_amt 	= AddUtil.parseInt(String.valueOf(commi.get("DIF_AMT")));
				String tax_per	= AddUtil.parseFloatCipher2((float)tot_amt/(commi_amt+add_amt)*100,1);
				if(tax_per.equals("3.2")) tax_per = "3.3";
				String dlv_dt 	= String.valueOf(commi.get("DLV_DT"));
				if(dlv_dt.length()>0){
					if(dlv_dt.substring(0,4).equals(AddUtil.getDate(1))){
						now_val1 = now_val1 + 1;
						if(!String.valueOf(commi.get("SUP_DT")).equals("")){
							now_val2 = now_val2 + dif_amt;
						}else{
							now_val3 = now_val3 + dif_amt;
						}
					}else{
						old_val1 = old_val1 + 1;
						old_val2 = old_val2 + dif_amt;
					}
				}
				%>
          <tr> 
            <td align='center'><%=commi.get("RENT_L_CD")%></td>
            <td align='center'><span title='<%=commi.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(commi.get("FIRM_NM")), 8)%></span></td>
            <td align='right'><%=Util.parseDecimal(car_commi_amt)%></td>		
            <td align='center'><%=commi.get("COMM_R_RT")%>%</td>					
            <td align='right'><%=Util.parseDecimal(commi_amt)%></td>
            <td align='right'><%=Util.parseDecimal(add_amt)%></td>
            <td align='right'><%=Util.parseDecimal(inc_amt)%></td>
            <td align='right'><%=Util.parseDecimal(res_amt)%></td>
            <td align='center'><%=tax_per%>%</td>
            <td align='right'><%=Util.parseDecimal(dif_amt)%></td>												
          </tr>
          <%}%>
        </table>
	  </td>
	<tr>  	
	<%}%>
  </table>
</form>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	
	fm.now_val1.value = '<%=now_val1%>';
	fm.now_val2.value = '<%=Util.parseDecimal(now_val2)%>';
	fm.now_val3.value = '<%=Util.parseDecimal(now_val3)%>';
	fm.now_val4.value = '<%=Util.parseDecimal(now_val2+now_val3)%>';
	fm.old_val1.value = '<%=old_val1%>';
	fm.old_val2.value = '<%=Util.parseDecimal(old_val2)%>';
	fm.old_val3.value = '<%=d_db.getCommiEmpRank(emp1.getEmp_id())%>';						
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

