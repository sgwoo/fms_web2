<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//��������+������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
	
	//������Ʈ���� 20131101
	CarOffBean a_co_bean = new CarOffBean();
	
	if(!coe_bean.getAgent_id().equals("")){
		a_co_bean = cod.getCarOffBean(coe_bean.getAgent_id());
	}else{
		a_co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	}


	//�����Ҵ���� �����븮��(������Ʈ)
	CommiBean emp4 	= a_db.getCommi(rent_mng_id, rent_l_cd, "4");

	if(emp4.getEmp_id().equals("")){
		emp4.setRent_mng_id	(rent_mng_id);
		emp4.setRent_l_cd	(rent_l_cd);
		emp4.setEmp_id		(emp1.getEmp_id());
		emp4.setAgnt_st		("4");
		//=====[commi] insert=====
		boolean flag4 = a_db.insertCommiNew(emp4);
	}

	CarOffEmpBean coe_bean4 = cod.getCarOffEmpBean(emp4.getEmp_id());
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "COMMI";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//�˾������� ����
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/agent/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		popObj.location = theURL;
		popObj.focus();
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
		

	
	//��ĵ���
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&emp_id=<%=emp1.getEmp_id()%>&agnt_st=4&from_page=/fms2/commi/commi_doc_proxy_i.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
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
	
	//�Ǽ����� ��ȸ
	function search_bank_acc(){
		var fm = document.form1;
		window.open("s_emp_bank_acc.jsp?from_page=/fms2/commi/commi_doc_u.jsp&emp_id=<%=emp1.getEmp_id()%>", "SEARCH_EMP_ACC", "left=50, top=50, width=950, height=600, scrollbars=yes");		
	}	
	

	
	//����������
	function set_amt(){
		var fm = document.form1;
		var per = 1;
		
		if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == ''){
			alert('����1 ������ �����Ͻʽÿ�.'); return;
		}
		
		if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == ''){
			alert('����2 ������ �����Ͻʽÿ�.'); return;
		}
		
		if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == ''){
			alert('����3 ������ �����Ͻʽÿ�.'); return;
		}				
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
			
			per = 0.1;
			
			fm.inc_per.value = 0;
			fm.res_per.value = 0;
			fm.vat_per.value = per*100;
			fm.tot_per.value = per*100;

			var tot_add1 = 0;//����������
			var tot_add2 = 0;//���İ�����
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt3.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt3.value));
			
			fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_amt1.value)) + toInt(parseDigit(fm.add_amt2.value)) + toInt(parseDigit(fm.add_amt3.value))); 										
			fm.a_amt.value = parseDecimal(tot_add1);
			fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.a_amt.value))); 
			
			fm.inc_amt.value = 0; 
			fm.res_amt.value = 0; 			

			fm.vat_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.b_amt.value))) * per )); 			

			fm.c_amt.value = fm.vat_amt.value; 
						
			fm.e_amt.value = parseDecimal(tot_add2);
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) + toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 		
			
		<%}else{%>					
			
		if(fm.rec_incom_st.value == ''){			alert('�ҵ汸���� �����Ͻʽÿ�.'); return;		}
		
		if(fm.rec_incom_st.value != ''){
			
			if(fm.rec_incom_st.value == '2'){
				per = 0.03;
			}else if(fm.rec_incom_st.value == '3'){
				per = 0.06;		//20180401���� 0.04->0.06 ����
				if(<%=AddUtil.getDate(4)%> > 20181231){
					per = 0.06;		//20190101���� 0.06->0.08 ���� -> 20190404 ���������� 2019�� �ʿ��� 70% �����Ǵ� ������ [0.06]
				}				
			}	
			
			fm.inc_per.value = per*100;
			fm.res_per.value = per*10;
			fm.tot_per.value = per*110;

			var tot_add1 = 0;//����������
			var tot_add2 = 0;//���İ�����
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt3.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt3.value));
			
			
			fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_amt1.value)) + toInt(parseDigit(fm.add_amt2.value)) + toInt(parseDigit(fm.add_amt3.value))); 										
			fm.a_amt.value = parseDecimal(tot_add1);
			fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.a_amt.value))); 							
			
			fm.inc_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.b_amt.value))) * per )); 
			fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			
			fm.c_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
						
			fm.e_amt.value = parseDecimal(tot_add2);
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) - toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 
			
		}
		<%}%>
	}
	
	function save(){
		var fm = document.form1;
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
		
		<%}else{%>			
	
		if(fm.emp_acc_nm.value == '')		{	alert('�Ǽ����� �̸��� �Է��Ͽ� �ֽʽÿ�.'); 				return;		}
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
		
		if(fm.b_amt.value == '0')		{	alert('�ҵ�ݾ��� Ȯ���Ͻʽÿ�.'); 					return;		}
		if(fm.c_amt.value == '0')		{	alert('�����ݾ��� Ȯ���Ͻʽÿ�.'); 					return;		}		
		if(fm.d_amt.value == '0')		{	alert('�������޾��� Ȯ���Ͻʽÿ�.'); 					return;		}		
				
		set_amt();

		if(confirm('��� �Ͻðڽ��ϱ�?')){	
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
		
			fm.action='commi_doc_proxy_i_a.jsp';		
			fm.target='d_content';			
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}							
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
			//alert('�ùٸ� �ֹε�� ��ȣ�Դϴ�.');
			errfound = true;
		}    				
		
		return errfound;	
	}	
	

//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="emp_id" 		value="<%=emp1.getEmp_id()%>">
  <input type='hidden' name='gubun1'  			value='<%=gubun1%>'>    
  <input type='hidden' name="agnt_st" 		value="4">    
  <input type='hidden' name="file_st" 		value="">    
  <input type='hidden' name="s_file_name1"	value="">      
  <input type='hidden' name="s_file_name2"	value="">      
  <input type='hidden' name="s_file_gubun1"	value="">      
  <input type='hidden' name="s_file_gubun2"	value="">          
  <input type='hidden' name="agent_doc_st"	value="<%=a_co_bean.getDoc_st()%>">

	
    
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�������� > ������� > �����������޿�û > <span class=style1><span class=style5>�����븮�� ��� </span></span></td>
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
                    <td class=title width=10%>����ȣ</td>
                    <td >&nbsp;<%=rent_l_cd%></td>
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
                    <td class=title width=10%>�����/�������</td>
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
                    <td width=15%>&nbsp;<input type='text' name="emp_acc_nm" value='<%//=emp1.getEmp_acc_nm()%>' size="12" class='text' readonly>					  
					  <a href="javascript:search_bank_acc()"><span title="<%//=emp1.getEmp_nm()%> ��������� �Ǽ������� ��ȸ�մϴ�."><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></span></a>					  
					</td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;<input type='text' name="rel" value='<%//=emp1.getRel()%>' size="16" class='text' readonly></td>
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
        				<option value="2" >����ҵ�</option>
        				<option value="3" >��Ÿ����ҵ�</option>							
        			  </select>
                    </td>
		        </tr>	
                <tr> 
                    <td class=title>�ŷ�����</td>
                    <td width=15%>&nbsp;
                    	<input type='hidden' name="emp_bank" 			value="<%//=emp1.getEmp_bank()%>">
                    	<select name='emp_bank_cd'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//�ű��ΰ�� �̻������ ����
																if(bank.getUse_yn().equals("N"))	 continue;
        								%>
                        <option value='<%= bank.getCode()%>' ><%=bank.getNm()%></option><!-- <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%> -->
                        <%		}
        					}%>
                      </select></td>
                    <td class=title width=10%>���¹�ȣ</td>
                    <td colspan="3">&nbsp;<input type='text' name="emp_acc_no" value='<%//=emp1.getEmp_acc_no()%>' size="31" class='text' readonly></td>
                    <td class=title width=10%>�ֹι�ȣ</td>
                    <td width=15%>&nbsp;<input type='text' name="rec_ssn" value='' size="16" class='text' readonly></td>
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
                    <td colspan="3">&nbsp;
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="" readonly>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="65" value="" readonly>
					</td>
                    <td class=title width=10%>�ź����纻</td>
                    <td width=15%>&nbsp;
                    	<%
				content_seq  = rent_mng_id+""+rent_l_cd+"4"+"1";

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>   
    						<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;                                                                    
    						<%}%>                                            
                    </td>
                    <td class=title width=10%>����纻</td>
                    <td width=15%>&nbsp;
                    	<%
				content_seq  = rent_mng_id+""+rent_l_cd+"4"+"2";

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>   
    						<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;                                                                    
    						<%}%>                                              
                    </td>
		</tr>	
            </table>
	</td>
    </tr>  	 
    <tr>
	<td style='height:18'><span class=style4>&nbsp;<font color=red>* �Ǽ������� �� ��ȸ�ؼ� ����Ͻʽÿ�. �Ǽ����ο� ��ȸ ����Ÿ�� ���ų� ���뺯���� ������ ��������-�����������-��������������� �Ǽ������� ���(����)�Ͻʽÿ�.</font></span> </td>
    </tr>
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* ��������� �Ǽ����� �̸��� ���� ��������� <b>�ź���,���� �纻</b>�� ������ ���� ������� �ʾƵ� ���ó���� ����ɴϴ�.</span> </td>
	</tr>			  	
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* ���� : �������� �Է��� �����̸�, ���������� �Է��� ������ ���� ������ ��������� �ִ� ���������� �����ɴϴ�.</span> </td>
	</tr>			  	
	<%}%>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr> 
        <td class=line2></td>
    </tr> 
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title>����</td>
                    <td class=title width=12%>�ݾ�</td>
                    <td class=title width=10%>����</td>
                    <td width=3% rowspan="<%if(a_co_bean.getDoc_st().equals("2")){%>4<%}else{%>6<%}%>" class=title>��<br>��<br></td>
                    <td class=title width=12%>����</td>
                    <td class=title width=10%>�ݾ�</td>			
                    <td class=title width=40%>����</td>
                </tr>	
                <tr> 
                    <td width="3%" rowspan="3" class=title><%if(a_co_bean.getDoc_st().equals("2")){%>��<br>��<br>��<br>��<br>��<br><%}else{%>��<br>
                      ��<br>��<br>��<br><%}%></td>
                    <td width="10%" class=title>�����븮����</td>
                    <td align="center"><input type='text' name='commi' maxlength='10' value='<%if(base.getBus_st().equals("7") && cont_etc.getBus_agnt_id().equals("")){%>100,000<%}%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;
        			  <select name="add_st1" onchange="javascript:set_amt()">
                        <option value="">==����==</option>
        				<option value="1">����</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2">����</option><%}%>
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt1' maxlength='8' value='' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                      <input name="add_cau1" type="text" class="num" id="add_cau1" value="<%=emp4.getAdd_cau1()%>" size="50"></td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">����������</td>
                    <td align="center"><input type='text' name='a_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;
        			  <select name="add_st2" onchange="javascript:set_amt()">
                        <option value="">==����==</option>
        				<option value="1" <%if(emp4.getAdd_st2().equals("1"))%>selected<%%>>����</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp4.getAdd_st2().equals("2"))%>selected<%%>>����</option><%}%>
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt2' maxlength='8' value='<%=Util.parseDecimal(emp4.getAdd_amt2())%>' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                    <input name="add_cau2" type="text" class="text" value="<%=emp4.getAdd_cau2()%>" size="50"></td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">�Ұ�</td>
                    <td align="center"><input type='text' name='b_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;
        			  <select name="add_st3" onchange="javascript:set_amt()">
                        <option value="">==����==</option>
        				<option value="1" <%if(emp4.getAdd_st3().equals("1"))%>selected<%%>>����</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp4.getAdd_st3().equals("2"))%>selected<%%>>����</option><%}%>
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt3' maxlength='8' value='<%=Util.parseDecimal(emp4.getAdd_amt3())%>' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                    <input name="add_cau3" type="text" class="text" value="<%=emp4.getAdd_cau3()%>" size="50"></td>
                </tr>
                <%if(a_co_bean.getDoc_st().equals("2")){%>
                <tr>
                    <td colspan="2" class=title>VAT</td>
                    <td align="center"><input type='text' name='vat_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                    <td align="center"><input type='text' name='vat_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td width=3% class=title>�Ұ�</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type='text' name='add_tot_amt' maxlength='8' value='' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;</td>                    
                </tr> 
                <input type="hidden" name="inc_amt" value="<%=Util.parseDecimal(emp4.getInc_amt())%>">
                <input type="hidden" name="inc_per" value="">
                <input type="hidden" name="res_amt" value="<%=Util.parseDecimal(emp4.getRes_amt())%>">
                <input type="hidden" name="res_per" value="">
                <input type="hidden" name="c_amt" value="<%=Util.parseDecimal(emp4.getTot_amt())%>">
                <input type="hidden" name="tot_per" value="">
                <input type="hidden" name="e_amt" value="">
                <%}else{%>      
                <tr>
                    <td rowspan="3" class=title>��<br>õ<br>¡<br>��</td>
                    <td class=title>�ҵ漼</td>
                    <td align="center"><input type='text' name='inc_amt' maxlength='8' value='<%=Util.parseDecimal(emp4.getInc_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='inc_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>���漼</td>
                    <td align="center"><input type='text' name='res_amt' maxlength='8' value='<%=Util.parseDecimal(emp4.getRes_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='res_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>�Ұ�</td>
                    <td align="center"><input type='text' name='c_amt' maxlength='8' value='<%=Util.parseDecimal(emp4.getTot_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='tot_per' maxlength='3' value='' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value);'>%</td>
                    <td width=3% class=title>�Ұ�</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type='text' name='add_tot_amt' maxlength='8' value='' class='num' size='8' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2" class=title>���İ�����</td>
                    <td align="center"><input type='text' name='e_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                    <td colspan="5">&nbsp;  </td>
                </tr>
                <%}%>
                <tr>
                  <td colspan="2" class=title>�����޾�</td>
                  <td align="center"><input type='text' name='d_amt' maxlength='8' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  <td colspan="5">&nbsp;�����޾�  = �������ؾ� -  ��õ¡������ + ���İ�����</td>
                </tr>	
		    </table>
	    </td>
	</tr>  
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* ���� : �����븮����ܿ� �߰��� ���޵Ǵ� �� �Ǵ� �����ؾ� �Ǵ� �Ϳ� ���� �����Դϴ�.</span> </td>
	</tr>			  	

    <tr>
	    <td align='center'>
	    <a id="submitLink" href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    </td>
	</tr>	

    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>		
</table>
</form>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	<%if(coe_bean.getCust_st().equals("")){%>
		fm.rec_incom_st.value = '2';
	<%}%>
	
	set_amt();
	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

