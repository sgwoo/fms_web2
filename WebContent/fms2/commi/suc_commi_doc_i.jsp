<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.ext.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
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
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, cont_etc.getSuc_rent_st());
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, cont_etc.getSuc_rent_st());
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//���������
	user_bean 	= umd.getUsersBean(base.getBus_id());	
	
	//��������+������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "7");
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(user_bean.getSa_code());

	//������Ʈ���� 20131101
	CarOffBean a_co_bean = new CarOffBean();	
	if(!coe_bean.getAgent_id().equals("")){
		a_co_bean = cod.getCarOffBean(coe_bean.getAgent_id());
	}else{
		a_co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	}
	
	ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//���� ��� ���� ��ȸ
	
	//���Ծ��� �°������ �δ�
	if(cont_etc.getRent_suc_commi_pay_st().equals("1") && cont_etc.getRent_suc_commi() != (suc2.getExt_s_amt()+suc2.getExt_v_amt())){
		suc2 = ae_db.getAGrtScd(rent_mng_id, cont_etc.getRent_suc_l_cd(), "1", "5", "1");//���� ��� ���� ��ȸ
	}
	
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("1", rent_l_cd);
	}
	

	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&from_page="+from_page+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&doc_no="+doc_no+"&mode="+mode+
				   	"";	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����Ʈ
	function list(){
		var fm = document.form1;			
		fm.action = 'suc_commi_doc_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//����������
	function set_amt(){
		var fm = document.form1;
		var per = 1;
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
			
			per = 0.1;
			
			fm.inc_per.value = 0;
			fm.res_per.value = 0;
			fm.vat_per.value = per*100;
			fm.tot_per.value = per*100;
						
			fm.inc_amt.value = 0; 
			fm.res_amt.value = 0;
			fm.vat_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.agent_commi.value))) * per ));
			fm.c_amt.value = fm.vat_amt.value; 
			
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.agent_commi.value)) + toInt(parseDigit(fm.c_amt.value)));
			
		<%}else{%>
		
		if(fm.rec_incom_st.value == ''){			alert('�ҵ汸���� �����Ͻʽÿ�.'); return;		}
						
		if(fm.rec_incom_st.value != ''){
					
			if(fm.rec_incom_st.value == '2'){
				per = 0.03;
			}else if(fm.rec_incom_st.value == '3'){
				per = 0.06;			//20180401���� 0.04->0.06 ����
				if(<%=AddUtil.getDate(4)%> > 20181231){
					per = 0.08;		//20190101���� 0.06->0.08 ����
				}
			}
			
			fm.inc_per.value = per*100;
			fm.res_per.value = per*10;
			fm.vat_per.value = 0;
			fm.tot_per.value = per*110;

			fm.inc_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.agent_commi.value))) * per )); 
			fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			
			fm.vat_amt.value = 0;
			fm.c_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
						
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.agent_commi.value)) - toInt(parseDigit(fm.c_amt.value)) ); 
			
		}
		
		<%}%>
	}
	
	//�ֹε�Ϲ�ȣ üũ

 	var errfound = false;

	function jumin_No(){
		var fm = document.form1;
		
		var ssn = '';
		var ssn1 = '';
		var ssn2 = '';
		
		ssn = replaceString('-','',fm.rec_ssn.value);
		
		ssn1 = ssn.substr(0, 6);
		ssn2 = ssn.substr(6);
		
		var str_len ;
    		var str_no = ssn1+ssn2;

    		str_len = str_no.length;
    		
		var a1=str_no.substring(0,1);
		var a2=str_no.substring(1,2);
		var a3=str_no.substring(2,3);
		var a4=str_no.substring(3,4);
		var a5=str_no.substring(4,5);
		var a6=str_no.substring(5,6);

		var check_digit=a1*2+a2*3+a3*4+a4*5+a5*6+a6*7;

		var b1=str_no.substring(6,7);
		var b2=str_no.substring(7,8);
		var b3=str_no.substring(8,9);
		var b4=str_no.substring(9,10);
		var b5=str_no.substring(10,11);
		var b6=str_no.substring(11,12);
		var b7=str_no.substring(12,13);

		var check_digit=check_digit+b1*8+b2*9+b3*2+b4*3+b5*4+b6*5; 

		check_digit = check_digit%11;
		check_digit = 11 - check_digit;
		check_digit = check_digit%10;
			
		if (check_digit != b7){
			alert('�߸��� �ֹε�Ϲ�ȣ�Դϴ�.');
			errfound = false;          
		}else{
			errfound = true;
		}    				
		
		return errfound;	
	}


	
	function save(){
		var fm = document.form1;
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
		
		<%}else{%>	
			if(fm.emp_acc_nm.value == '')		{	alert('�Ǽ����� �̸��� �Է��Ͽ� �ֽʽÿ�.'); 				return;		}

			if(fm.emp_acc_nm.value.indexOf(',') != -1){	alert('�Ǽ����� �̸��� Ȯ���Ͽ� �ֽʽÿ�. �ҵ�Ű� �Ͽ��� ���� �Է��Ͽ� �ֽʽÿ�.');	return;		}
			if(fm.emp_acc_nm.value.indexOf('(') != -1){	alert('�Ǽ����� �̸��� Ȯ���Ͽ� �ֽʽÿ�. �ҵ�Ű� �Ͽ��� ���� �Է��Ͽ� �ֽʽÿ�.'); 	return;		}

			if(fm.rel.value == '')			{	alert('�Ǽ������� ����������� ���踦 �Է��Ͽ� �ֽʽÿ�.'); 		return;		}
			if(fm.rec_incom_yn.value == '')		{	alert('�Ǽ������� Ÿ�ҵ濩�θ� �Է��Ͽ� �ֽʽÿ�.'); 			return;		}
			if(fm.rec_incom_st.value == '')		{	alert('�Ǽ������� �ҵ汸�и� �Է��Ͽ� �ֽʽÿ�.'); 			return;		}
			if(fm.emp_bank_cd.value == '')		{	alert('�Ǽ��� ������ �Է��Ͽ� �ֽʽÿ�.'); 				return;		}
			if(fm.emp_acc_no.value == '')		{	alert('�Ǽ��� ���¹�ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 				return;		}
			if(fm.rec_ssn.value == '')		{	alert('�Ǽ������� �ֹι�ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 			return;		}
			if(fm.t_zip.value == '')		{	alert('�Ǽ������� �����ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 			return;		}
			if(fm.t_addr.value == '')		{	alert('�Ǽ������� �ּҸ� �Է��Ͽ� �ֽʽÿ�.'); 				return;		}
			
			//�ֹι�ȣ ���� Ȯ��
			if(!jumin_No()){
				return;
			}
		<%}%>
		
		if(fm.d_amt.value == '0')		{	alert('�������޾��� Ȯ���Ͻʽÿ�.'); 					return;		}
		
		if(confirm('ǰ�ǵ�� �Ͻðڽ��ϱ�?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
		
			fm.action='suc_commi_doc_i_a.jsp';
			fm.target='d_content';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}
	
	//�Ǽ����� ��ȸ
	function search_bank_acc(){
		var fm = document.form1;
		window.open("s_emp_bank_acc.jsp?from_page=/fms2/commi/commi_doc_u.jsp&emp_id=<%=user_bean.getSa_code()%>", "SEARCH_EMP_ACC", "left=50, top=50, width=950, height=600, scrollbars=yes");		
	}

	//�����ȣ �˻�
	function search_zip(str){
		window.open("../lc_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, resizable=yes, scrollbars=yes, status=yes");
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
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="emp_id" 		value="<%=coe_bean.getEmp_id()%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="file_st" 		value="">    
  <input type='hidden' name="s_file_name1"	value="">      
  <input type='hidden' name="s_file_name2"	value="">      
  <input type='hidden' name="s_file_gubun1"	value="">      
  <input type='hidden' name="s_file_gubun2"	value="">        
  <input type="hidden" name="rent_dt" 		value="<%=base.getDlv_dt()%>">
  <input type="hidden" name="car_id" 		value="<%=car.getCar_id()%>">
  <input type="hidden" name="car_seq" 		value="<%=car.getCar_seq()%>">
  <input type="hidden" name="car_amt" 		value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">
  <input type="hidden" name="opt_amt" 		value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">
  <input type="hidden" name="col_amt" 		value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">
  <input type='hidden' name="agent_doc_st"	value="<%=a_co_bean.getDoc_st()%>">
  <input type='hidden' name="auto_set_amt"	value="Y">
  
  

  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;FMS����� > ���ڹ������� > <span class=style5>�°�����������޿�û</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
	    <td align='right'><a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
	</tr>
	<tr> 
        <td class=line2></td>
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
                    <td class=title width=10%>���ۻ��</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class=title width=10%>����</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%><%if(!cr_bean.getCar_no().equals("")){%>&nbsp;(<%=cr_bean.getCar_no()%>)<%}%></td>
                    <td class=title width=10%>��ⷮ</td>
                    <td width=15%>&nbsp;<%=cm_bean.getDpm()%>cc</td>
		        </tr>	
		    </table>
	    </td>
	</tr> 
	<tr>
	    <td align="right"></td>
	</tr> 
	<tr> 
        <td class=line2></td>
    </tr> 
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>���°�����</td>
                    <td width=40%>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%></td>
        			      <td class=title width=10%>�����</td>		
                    <td width=40%>&nbsp;<%=c_db.getNameById(base.getBus_id(), "USER")%></td>
    		        </tr>	            	
                <tr> 
                    <td class=title width=10%>���°������</td>
                    <td width=40%>&nbsp;<input type='text' size='11' name='rent_suc_commi' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>' readonly>��
                    &nbsp;( 
					  ���ް� : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(suc2.getExt_s_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' readonly>��
					  �ΰ��� : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(suc2.getExt_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' readonly>��					  
                    	)
                    	</td>
        			      <td class=title width=10%>����°������</td>		
        			      <% int car_amt = car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt();%>
                    <td width=40%>&nbsp;<%=AddUtil.parseDecimal(car_amt*0.8/100)%>�� (�����Һ��ڰ� <%=AddUtil.parseDecimal(car_amt)%>���� 0.8%, �ΰ�������)</td>
    		        </tr>	
                <tr> 
                    <td class=title>�°�����ᰨ�����</td>
                    <td>&nbsp;
                    	<%if(cont_etc.getRent_suc_exem_cau().equals("1")){%>���� ��ȯ (���װ���)
                      <%}else if(cont_etc.getRent_suc_exem_cau().equals("2")){%>�̿��� ���� (50%����)
                      <%}else if(cont_etc.getRent_suc_exem_cau().equals("3")){%>�������� Ư������
                      <%}else if(cont_etc.getRent_suc_exem_cau().equals("5")){%>������Ʈ �°����� ���
                      <%}else{%><%=cont_etc.getRent_suc_exem_cau()%><%}%>
                    	</td>
        			      <td class=title>�����ᰨ�� ������</td>		
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getRent_suc_exem_id(), "USER")%></td>
    		        </tr>	
    	    </table>
	</td>
    </tr>  	  	
    <tr>
	<td>&nbsp;<%if(cont_etc.getRent_suc_exem_cau().equals("5")){%>
                       �� ������Ʈ �°����� ��� : ����°������ 11����(VAT����) ���ϴ� �°������ ���׸���, ����°������ 11����(VAT����) �̻��� �°������ 11����(VAT����)�� ���׵˴ϴ�.
                      <%}%></td>
  </tr> 
	<tr> 
        <td class=line2></td>
    </tr> 
    <%if(a_co_bean.getDoc_st().equals("2")){ //������Ʈ-���ݰ�꼭 �����%>
    <input type="hidden" name="rel" value="������Ʈ">
    <input type="hidden" name="rec_incom_yn" value="">
    <input type="hidden" name="rec_incom_st" value="">
    <input type="hidden" name="rec_ssn" value="<%=a_co_bean.getEnp_no()%>">
    <input type="hidden" name="emp_bank" value="<%=a_co_bean.getBank()%>">
    <input type="hidden" name="emp_bank_cd" value="<%=a_co_bean.getBank_cd()%>">
    <input type="hidden" name="emp_acc_no" value="<%=a_co_bean.getAcc_no()%>">
    <input type="hidden" name="emp_acc_nm" value="<%=a_co_bean.getAcc_nm()%>">
    <input type="hidden" name="t_zip" value="<%=a_co_bean.getCar_off_post()%>">
    <input type="hidden" name="t_addr" value="<%=a_co_bean.getCar_off_addr()%>">
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>��<br>��<br>��<br>��</td>
                    <td class=title width=7%>��ȣ/����</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getCar_off_nm()%></td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;
                        <%if(a_co_bean.getCar_off_st().equals("3")){%>����<%}%>
                    	<%if(a_co_bean.getCar_off_st().equals("4")){%>���λ����<%}%>
                    </td>
                    <td class=title width=10%>�����/�ֹι�ȣ</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeEnpH(a_co_bean.getEnp_no())%></td>
                    <td class=title width=10%>�ŷ�����</td>
                    <td width=15%>&nbsp;
        		<%if(a_co_bean.getDoc_st().equals("1")){%>��õ¡��<%}%>
                    	<%if(a_co_bean.getDoc_st().equals("2")){%>���ݰ�꼭<%}%>
                    </td>
		        </tr>	
                <tr> 
                    <td class=title>�ŷ�����</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getBank()%></td>
                    <td class=title width=10%>���¹�ȣ</td>
                    <td>&nbsp;<%=a_co_bean.getAcc_no()%></td>
                    <td class=title width=10%>������</td>
                    <td colspan="3">&nbsp;<%=a_co_bean.getAcc_nm()%></td>                    
		</tr>	
                <tr> 
                    <td class=title>�ּ�</td>
                    <td colspan="7">&nbsp;<%=a_co_bean.getCar_off_post()%>
        			   &nbsp;<%=a_co_bean.getCar_off_addr()%></td>
		        </tr>	
		    </table>
	    </td>
	</tr> 
    <tr> 
        <td class=h></td>
    </tr>	 				 	 	    
    <%}else{%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>��<br>��<br>��<br>��</td>
                    <td class=title width=7%>�Ǽ�����</td>
                    <td width=15%>&nbsp;<input type='text' name="emp_acc_nm" value='<%=coe_bean.getEmp_nm()%>' size="12" class='text'>					  
					  <a href="javascript:search_bank_acc()"><span title="<%=coe_bean.getEmp_nm()%> ��������� �Ǽ������� ��ȸ�մϴ�."><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></span></a>					  
					</td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;<input type='text' name="rel" value='����' size="16" class='text'></td>
                    <td class=title width=10%>Ÿ�ҵ�</td>
                    <td width=15%>&nbsp;
        			  <select name="rec_incom_yn">
                        <option value="">==����==</option>
        				<option value="1">��</option>
        				<option value="2" selected>��</option>							
        			  </select>
        			</td>
                    <td class=title width=10%>�ҵ汸��</td>
                    <td width=15%>&nbsp;
        			  <select name="rec_incom_st" onChange="javascript:set_amt()">
                        <option value="">==����==</option>
        				<option value="2" <% if(coe_bean.getCust_st().equals("2") || coe_bean.getCust_st().equals("")) out.println("checked"); %>>����ҵ�</option>
        				<option value="3" <% if(coe_bean.getCust_st().equals("3")) out.println("checked"); %>>��Ÿ����ҵ�</option>
        			  </select>
                    </td>
		        </tr>	
		        <%
		        	if(coe_bean.getEmp_bank().equals("")) 	coe_bean.setEmp_bank	(a_co_bean.getBank());
		        	if(coe_bean.getBank_cd().equals("")) 		coe_bean.setBank_cd		(a_co_bean.getBank_cd());
		        	if(coe_bean.getEmp_acc_no().equals("")) coe_bean.setEmp_acc_no(a_co_bean.getAcc_no());
		        	if(coe_bean.getEmp_ssn().equals("")) 		coe_bean.setEmp_ssn		(a_co_bean.getEnp_no());
		        %>
                <tr> 
                    <td class=title>�ŷ�����</td>
                    <td width=15%>&nbsp;
                    	<input type='hidden' name="emp_bank" 			value="<%=coe_bean.getEmp_bank()%>">
                    	<select name='emp_bank_cd'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        								%>
                        <option value='<%= bank.getCode()%>' <%if(coe_bean.getEmp_bank().equals(bank.getNm())||coe_bean.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                      </select></td>
                    <td class=title width=10%>���¹�ȣ</td>
                    <td colspan="3">&nbsp;<input type='text' name="emp_acc_no" value='<%=coe_bean.getEmp_acc_no()%>' size="31" class='text'></td>
                    <td class=title width=10%>�ֹι�ȣ</td>
                    <td width=15%>&nbsp;<input type='text' name="rec_ssn" value='<%= coe_bean.getEmp_ssn() %>' size="16" class='text'></td>
		        </tr>	
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>		        
                <tr> 
                    <td class=title>�ּ�</td>
                    <td colspan="7">&nbsp;<input type='text' name="t_zip" value='<%= a_co_bean.getCar_off_post() %>' size="7" class='text' readonly>
                    	<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
        			   &nbsp;<input type='text' name="t_addr" value='<%= a_co_bean.getCar_off_addr() %>' size="40" class='text' style='IME-MODE: active' ></td>
		</tr>	
	    </table>
	</td>
    </tr>  	 	
    <tr> 
        <td class=h></td>
    </tr>	 		    
	<%}%>
	<tr> 
        <td class=line2></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <%if(a_co_bean.getDoc_st().equals("2")){%>
                <tr> 
                    <td class=title width="10%">����</td>
                    <td class=title width=15%>�ݾ�</td>
                    <td class=title width=75%>����</td>                    
                </tr>	
                <tr> 
                    <td width="10%" class=title>�����������</td>
                    <td align="center"><input type='text' name='agent_commi' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();' readonly></td>
                    <td align="center">&nbsp;</td>
                </tr>                                          
                <tr>
                    <td class=title>VAT</td>
                    <td align="center"><input type='text' name='vat_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                    <td>&nbsp;<input type='text' name='vat_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();' readonly>%</td>
                </tr> 
                <input type="hidden" name="inc_amt" value="<%=Util.parseDecimal(emp1.getInc_amt())%>">
                <input type="hidden" name="inc_per" value="">
                <input type="hidden" name="res_amt" value="<%=Util.parseDecimal(emp1.getRes_amt())%>">
                <input type="hidden" name="res_per" value="">
                <input type="hidden" name="c_amt" value="<%=Util.parseDecimal(emp1.getTot_amt())%>">
                <input type="hidden" name="tot_per" value="">
                <tr>
                  <td class=title>�����޾�</td>
                  <td align="center"><input type='text' name='d_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                  <td>&nbsp;�����޾�  = �������ؾ� <%if(a_co_bean.getDoc_st().equals("2")){%>+ VAT<%}else{%>- ��õ¡������ + ���İ�����<%}%></td>
                </tr>	
                <%}else{%>                
                <tr> 
                    <td colspan='2' class=title>����</td>
                    <td class=title width=15%>�ݾ�</td>
                    <td class=title width=80%>����</td>
                </tr>	
                <tr> 
                    <td colspan='2' class=title>�����������</td>
                    <td align="center"><input type='text' name='agent_commi' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();' readonly></td>
                    <td align="center">&nbsp;</td>
                </tr>                                          
                <tr>
                    <td rowspan="3" class=title width="3%">��<br>õ<br>¡<br>��</td>
                    <td class=title width="7%">�ҵ漼</td>
                    <td align="center"><input type='text' name='inc_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getInc_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                    <td>&nbsp;<input type='text' name='inc_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                </tr>
                <tr>
                    <td class=title>���漼</td>
                    <td align="center"><input type='text' name='res_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getRes_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                    <td>&nbsp;<input type='text' name='res_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                </tr>
                <tr>
                    <td class=title>�Ұ�</td>
                    <td align="center"><input type='text' name='c_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getTot_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                    <td>&nbsp;<input type='text' name='tot_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value);'>%</td>
                </tr>
                <input type="hidden" name="vat_amt" value="<%=Util.parseDecimal(emp1.getVat_amt())%>">
                <input type="hidden" name="vat_per" value="">
                <tr>
                  <td colspan="2" class=title>�����޾�</td>
                  <td align="center"><input type='text' name='d_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                  <td>&nbsp;�����޾�  = ����������� <%if(a_co_bean.getDoc_st().equals("2")){%>+ VAT<%}else{%>- ��õ¡������<%}%></td>
                </tr>	
                <%}%>
		    </table>
	    </td>
	</tr>  
    <tr> 
        <td class=h></td>
    </tr>	 			  	
	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>	  	
    <tr>
	    <td align='center'>
	    <%if(doc_no.equals("")){%><a id="submitLink" href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a><%}%>
	    </td>
	</tr>	
	<%}%>
</table>
</form>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	<%if(coe_bean.getCust_st().equals("") || coe_bean.getCust_st().equals("2")){%>
		fm.rec_incom_st.value = '2';
	<%}else if(coe_bean.getCust_st().equals("3")){%>
		fm.rec_incom_st.value = '3';
	<%}%>
	
	fm.agent_commi.value 	= parseDecimal(<%=suc2.getExt_s_amt()%>);
	
	if(toInt(parseDigit(fm.agent_commi.value)) > 100000){
		fm.agent_commi.value 	= parseDecimal(100000);
	}
	
	set_amt();
	
	//�ٷΰ���
	var s_fm = parent.top_menu.document.form1;
	s_fm.auth_rw.value 		= fm.auth_rw.value;
	s_fm.user_id.value 		= fm.user_id.value;
	s_fm.br_id.value 		= fm.br_id.value;		
	s_fm.m_id.value 		= fm.rent_mng_id.value;
	s_fm.l_cd.value 		= fm.rent_l_cd.value;	
	s_fm.c_id.value 		= "<%=base.getCar_mng_id()%>";
	s_fm.client_id.value 	= "<%=base.getClient_id()%>";	
	s_fm.accid_id.value 	= "";
	s_fm.serv_id.value 		= "";
	s_fm.seq_no.value 		= "";			
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

