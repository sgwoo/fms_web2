<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");


	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	//if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
					
		var fm = document.form1;	
					
		
		if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {		//����
			
			if(fm.firm_nm[0].value == '')	{	alert('��ȣ�� �Է��Ͻʽÿ�');	return;	}
			if(fm.client_nm[0].value == '')	{	alert('��ǥ�ڸ� �Է��Ͻʽÿ�');	return;	}
			if(fm.ssn1[0].value == '' || fm.ssn2[0].value == '')	{	alert('���ι�ȣ�� �Է��Ͻʽÿ�');	return;	}
			if((!isNum(fm.ssn1[0].value)) || (!isNum(fm.ssn2[0].value)) || ((fm.ssn1[0].value.length != 6)&&(fm.ssn1[0].value.length != 0)) || ((fm.ssn2[0].value.length != 7)&&(fm.ssn2[0].value.length != 0)))	{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� Ȯ���Ͻʽÿ�');	return;	}
			if((!isNum(fm.enp_no1[0].value)) || (!isNum(fm.enp_no2[0].value)) || (!isNum(fm.enp_no3[0].value))|| ((fm.enp_no1[0].value.length != 3)&&(fm.enp_no1[0].value.length != 0)) || ((fm.enp_no2[0].value.length != 2)&&(fm.enp_no2[0].value.length != 0)) || ((fm.enp_no3[0].value.length != 5)&&(fm.enp_no3[0].value.length != 0)))	{	alert('����ڵ�Ϲ�ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(fm.m_tel[0].value == '')	{	alert('�޴�����ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(!isTel(fm.m_tel[0].value))	{	alert('�޴�����ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(fm.o_tel[0].value == '')	{	alert('ȸ����ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(!isTel(fm.o_tel[0].value))	{	alert('ȸ����ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(!isTel(fm.fax[0].value))	{	alert('�ѽ���ȣ�� Ȯ���Ͻʽÿ�');	return;	}
				
		} else if ( fm.client_st.value == '2' ) {				//����
			
			if(fm.firm_nm[2].value == '')	{	alert('������ �Է��Ͻʽÿ�');	return;	}
			if(fm.ssn1[2].value == '' || fm.ssn2[2].value == '')	{	alert('�ֹι�ȣ�� �Է��Ͻʽÿ�');	return;	}
			if((!isNum(fm.ssn1[2].value)) || (!isNum(fm.ssn2[2].value)) || ((fm.ssn1[2].value.length != 6)&&(fm.ssn1[2].value.length != 0)) || ((fm.ssn2[2].value.length != 7)&&(fm.ssn2[2].value.length != 0)))	{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� Ȯ���Ͻʽÿ�');	return;	}
			if(fm.t_zip[5].value == '')	{	alert('�����ּҸ� Ȯ���Ͻʽÿ�');	return;	}
			if(fm.m_tel[2].value == '')	{	alert('�޴�����ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(!isTel(fm.m_tel[2].value))	{	alert('�޴�����ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(fm.h_tel[2].value == '')	{	alert('������ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(!isTel(fm.h_tel[2].value))	{	alert('������ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
								
	   	} else {		
									
			if(fm.firm_nm[1].value == '')	{	alert('��ȣ�� �Է��Ͻʽÿ�');	return;	}
			if(fm.client_nm[1].value == '')	{	alert('��ǥ�ڸ� �Է��Ͻʽÿ�');	return;	}
			if((!isNum(fm.ssn1[1].value)) || (!isNum(fm.ssn2[1].value)) || ((fm.ssn1[1].value.length != 6)&&(fm.ssn1[1].value.length != 0)) || ((fm.ssn2[1].value.length != 7)&&(fm.ssn2[1].value.length != 0)))	{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� Ȯ���Ͻʽÿ�');	return;	}
			if((!isNum(fm.enp_no1[1].value)) || (!isNum(fm.enp_no2[1].value)) || (!isNum(fm.enp_no3[1].value))|| ((fm.enp_no1[1].value.length != 3)&&(fm.enp_no1[1].value.length != 0)) || ((fm.enp_no2[1].value.length != 2)&&(fm.enp_no2[1].value.length != 0)) || ((fm.enp_no3[1].value.length != 5)&&(fm.enp_no3[1].value.length != 0)))	{	alert('����ڵ�Ϲ�ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(fm.m_tel[1].value == '')	{	alert('�޴�����ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(!isTel(fm.m_tel[1].value))	{	alert('�޴�����ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(fm.o_tel[1].value == '')	{	alert('ȸ����ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(!isTel(fm.o_tel[1].value))	{	alert('ȸ����ȭ��ȣ�� Ȯ���Ͻʽÿ�');	return;	}
			if(!isTel(fm.fax[1].value))	{	alert('�ѽ���ȣ�� Ȯ���Ͻʽÿ�');	return;	}
		
		}
			
		if(fm.email_1.value != '' && fm.email_2.value != ''){
			fm.con_agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
		}else{
			fm.con_agnt_email.value = '';
		}
		
		if ( fm.client_st.value != '2' ) {				//����				
			if(fm.email_1.value == '' || fm.email_2.value == ''){
				alert('���ݰ�꼭 �����-�̸����ּҸ� �Է��Ͻʽÿ�.'); return;
			}							
		}
			
		if(fm.etc_cms.value == ''){
			alert('��å�� cms û�����θ� �Է��Ͻʽÿ�.'); return;
		}	
			
		if(fm.fine_yn.value == ''){
			alert('�������·� û�����θ� �Է��Ͻʽÿ�.'); return;
		}	
			
		if(fm.print_st.value == ''){
			alert('��꼭���౸���� �Է��Ͻʽÿ�.'); return;
		}	

				
		if(confirm('����Ͻðڽ��ϱ�?'))
		{
												     
			fm.target='i_no';
//			fm.target='self';
			fm.submit();
		}
	}

	function search_zip(str)
	{
		window.open("/acar/common/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	function set_o_addr()
	{
		var fm = document.form1;
			
		if(fm.c_ho.checked == true)
		{
			fm.t_zip[1].value = fm.t_zip[0].value;
			fm.t_addr[1].value = fm.t_addr[0].value;
		}
		else
		{
			fm.t_zip[1].value = '';
			fm.t_addr[1].value = '';
		}
	}	
	
	function set_tax()
	{
		var fm = document.form1;
		
		if(fm.c_tax.checked == true)
		{
			if ( fm.client_st.value == '1'  || fm.client_st.value == '6' ) {		//����
				fm.con_agnt_nm.value 	= fm.client_nm[0].value;
				fm.con_agnt_o_tel.value = fm.o_tel[0].value;
				fm.con_agnt_m_tel.value = fm.m_tel[0].value;
				fm.con_agnt_fax.value   = fm.fax[0].value;			
			} else if ( fm.client_st.value == '2' ) {		//����
				fm.con_agnt_nm.value 	= fm.firm_nm[2].value;
				fm.con_agnt_m_tel.value = fm.m_tel[2].value;
			  } else {			
				fm.con_agnt_nm.value 	= fm.client_nm[1].value;
				fm.con_agnt_o_tel.value = fm.o_tel[1].value;
				fm.con_agnt_m_tel.value = fm.m_tel[1].value;
				fm.con_agnt_fax.value   = fm.fax[1].value;
			  }			
		}else{
			fm.con_agnt_nm.value 		= '';
			fm.con_agnt_o_tel.value 	= '';
			fm.con_agnt_m_tel.value 	= '';
			fm.con_agnt_fax.value 		= '';
		}
	}	
	
	function set_print()
	{
		var fm = document.form1;
		
		if ( fm.print_st.value == '2') {		//�ŷ�ó����
			fm.print_car_st.value 	= '1';
		}else{
			fm.print_car_st.value 	= '';
		}
	}		
	
	function go_to_list()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var asc 	= fm.asc.value;
		var from_page 	= fm.from_page.value;		
		var rent_st 	= fm.rent_st.value;		
		location='client_s_p.jsp?auth_rw='+auth_rw+'&s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc+'&from_page='+from_page+'&rent_st='+rent_st;
	}	
	
	
	//���÷���--------------------------------------------------------------------
	function cng_input(arg){
		  	    
		if(arg == '1' || arg == '6'){ 		//����
			tr_acct1.style.display		= '';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';										
		} else if(arg == '2'){ 		//����
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= '';					
				
		} else { 		//���λ����
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= '';
			tr_acct3.style.display		= 'none';							
		}
	}	
	
	//����ڹ�ȣ ���� �Ѿ��
	function set_next(idx, column, next_cd){
		var fm = document.form1;
		if(idx == '0' && column == 'enp_no'    && next_cd == '1' && get_length(fm.enp_no1[0].value) == 3)   { fm.enp_no2[0].focus();   }
		if(idx == '0' && column == 'enp_no'    && next_cd == '2' && get_length(fm.enp_no2[0].value) == 2)   { fm.enp_no3[0].focus();   }
		if(idx == '0' && column == 'enp_no'    && next_cd == '3' && get_length(fm.enp_no3[0].value) == 5)   { fm.ssn1[0].focus();      }
		if(idx == '0' && column == 'ssn'       && next_cd == '1' && get_length(fm.ssn1[0].value) == 6)      { fm.ssn2[0].focus();      }
		if(idx == '0' && column == 'ssn'       && next_cd == '2' && get_length(fm.ssn2[0].value) == 7)      { search_zip('0');         }
		if(idx == '0' && column == 'repre_ssn' && next_cd == '1' && get_length(fm.repre_ssn1[0].value) == 6){ fm.repre_ssn2[0].focus();}
		if(idx == '0' && column == 'repre_ssn' && next_cd == '2' && get_length(fm.repre_ssn2[0].value) == 7){ search_zip('2');         }
	}	

//����ڵ�Ϲ�ȣ üũ
function CheckBizNo() {
	
	var fm = document.form1;
if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {//����
	var strNumb1 = fm.enp_no1[0].value;
    var strNumb2 = fm.enp_no2[0].value;
    var strNumb3 = fm.enp_no3[0].value;
}else if( fm.client_st.value == '2'){//����
	var strNumb1 = fm.enp_no1[2].value;
    var strNumb2 = fm.enp_no2[2].value;
    var strNumb3 = fm.enp_no3[2].value;
}else{//���λ����
	var strNumb1 = fm.enp_no1[1].value;
    var strNumb2 = fm.enp_no2[1].value;
    var strNumb3 = fm.enp_no3[1].value;
}
    var strNumb = strNumb1+strNumb2+strNumb3;
    if (strNumb.length != 10) {
        alert("����ڵ�Ϲ�ȣ�� �߸��Ǿ����ϴ�.");
		
        return ;
    }
    
        sumMod  =   0;
        sumMod  +=  parseInt(strNumb.substring(0,1));
        sumMod  +=  parseInt(strNumb.substring(1,2)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(2,3)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(3,4)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(4,5)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(5,6)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(6,7)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(7,8)) * 3 % 10;
        sumMod  +=  Math.floor(parseInt(strNumb.substring(8,9)) * 5 / 10);
        sumMod  +=  parseInt(strNumb.substring(8,9)) * 5 % 10;
        sumMod  +=  parseInt(strNumb.substring(9,10));
    
    if (sumMod % 10  !=  0) {
        alert("�߸��� ����� ��Ϲ�ȣ �Դϴ�.");
		fm.enp_no1[0].value = '';
		fm.enp_no2[0].value = '';
		fm.enp_no3[0].value = '';
        return ;
    }
        alert("�ùٸ� ����� ��Ϲ�ȣ �Դϴ�.");
    	return ;
}

//�ֹε�Ϲ�ȣ üũ

 var errfound = false;

function jumin_No(){
	var fm = document.form1;	
	if ( fm.client_st.value != '2') {//����
	    if(!JuminCheck(document.getElementById("repre_ssn1").value,document.getElementById("repre_ssn2").value)){
                alert("�߸��� �ֹε�Ϲ�ȣ�Դϴ�.");
        } else  {
        		alert("�ùٸ� �ֹε�Ϲ�ȣ�Դϴ�.");
		}
	}
}

function JuminCheck(jumin1, jumin2){
        check = false;
        total =0;
        temp = new Array(13);
        for(i=1; i<=6; i++)temp[i] = jumin1.charAt(i-1);
        for(i=7; i<=13; i++) temp[i] =jumin2.charAt(i-7);
        for(i=1; i<=12;i++){
                k = i + 1;
                if(k >= 10) k = k% 10 + 2;
                total = total + temp[i] *k;
        }
        mm = temp[3] + temp[4];
        dd =temp[5] + temp[6];
        totalmod = total % 11;
        chd = 11 -totalmod;
        if(chd == temp[13] && mm < 13 && dd< 32 && (temp[7]==1 ||temp[7]==2))
                check=true;
        return check;
}


//���ι�ȣ üũ
function Biz_ck(){

	var fm = document.form1;
	
if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {//����
	var strBiz1 = fm.ssn1[0].value;
    var strBiz2 = fm.ssn2[0].value;
}else if( fm.client_st.value == '2'){//����
	var strBiz1 = fm.ssn1[2].value;
    var strBiz2 = fm.ssn2[2].value;
}else{//���λ����
	var strBiz1 = fm.ssn1[1].value;
    var strBiz2 = fm.ssn2[1].value;
}

    var str_len ;
    var str_no = strBiz1+strBiz2;

    str_len = str_no.length;
    
	if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {
		if (str_len == 13 ){		
	        no_ck = str_no.substring(0, 1) * 1;
	        no_ck = no_ck + str_no.substring( 1, 2) * 2;
	        no_ck = no_ck + str_no.substring( 2, 3) * 1;
	        no_ck = no_ck + str_no.substring( 3, 4) * 2;
	        no_ck = no_ck + str_no.substring( 4, 5) * 1;
	        no_ck = no_ck + str_no.substring( 5, 6) * 2;
	        no_ck = no_ck + str_no.substring( 6, 7) * 1;
	        no_ck = no_ck + str_no.substring( 7, 8) * 2;
	        no_ck = no_ck + str_no.substring( 8, 9) * 1;
	        no_ck = no_ck + str_no.substring( 9, 10) * 2;
	        no_ck = no_ck + str_no.substring( 10, 11) * 1;
	        no_list = no_ck + str_no.substring( 11, 12) * 2;
	        no_ck_no = no_list / 10;
	        ck_no = "'"+no_ck_no+"'";
	        namuji = ck_no.substring(3,4);
	        no = 10 - namuji; 
	        if (no > 9 ){
	            no = 0;
	        }
	        if (no == str_no.substring(12, 13)){
	            alert ("�ùٸ� ���ι�ȣ�Դϴ�.");
	        }else{
	            alert ("�߸��� ���ι�ȣ�Դϴ�.");
	        }
		}else{
			alert( "���ι�ȣ�� ��Ȯ�� �Է��� �ֽñ� �ٶ��ϴ�.");
		}
    }else if ( fm.client_st.value != '1' && fm.nationality.value !='2' && fm.nationality.value !='6') {
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
		}else{
			alert('�ùٸ� �ֹε�� ��ȣ�Դϴ�.');
		}
		
	}

}


//-->
</script>


<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post' action='/acar/res_search/client_i_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type='hidden' name='rent_st' value='<%=rent_st%>'> 
<input type='hidden' name='etax_not_cau' value=''> 
 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align='right'>
		        &nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a> 
	    </td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='13%'><b>������</b></td>
                    <td>&nbsp;
                        <select name='client_st' onChange="javascript:cng_input(this.value)">
                            <option value='1' > ���� </option>
                            <option value='2' > ���� </option>
                            <option value='3' > ���λ����(�Ϲݰ���) </option>
                            <option value='4' > ���λ����(���̰���) </option>
                            <option value='5' > ���λ����(�鼼�����)</option>
            				<option value='6' > �����</option>
                        </select>
                    </td>
                </tr>
            </table>
        </td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
    <tr id=tr_acct1 style="display:''">
        <td>
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>	
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2></td>
                </tr>
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td colspan="2" class='title'>���αԸ�</td>
            		            <td>&nbsp;
                		            <select name='firm_st'>
                		              <option value="">����</option>
                		              <option value="1">����</option>
                		              <option value="2">�߱��</option>					  
                		              <option value="3">�ұ��</option>
                		              <option value="4">ũ��ž�̵���</option>					  
                		            </select>
                					<input type='checkbox' name='enp_yn' value='Y'>
                					����
                					<input type='text' name='enp_nm' size='10' maxlength='20' class='text' style='IME-MODE: active'>
                					�迭��</td>
            		            <td class='title'>��������</td>
            		            <td>&nbsp;
            		                <select name='firm_type'>
                		                <option value="">����</option>
                		                <option value="1">�������ǽ���</option>
                		                <option value="2">�ڽ��ڻ���</option>
                		                <option value="3">�ܰ�����</option>
                		                <option value="4">��ó���</option>
                		                <option value="5">�Ϲݹ���</option>
                		                <option value="6">����</option>
                		                <option value="7">������ġ��ü</option>
                		                <option value="8">�������ڱ��</option>
                		                <option value="9">�����⿬�������</option>
										<option value="10">�񿵸�����</option>
										<option value="11">�鼼����</option>
            		                </select></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>��������</td>
            		            <td>&nbsp;
            		                <input type='text' name='found_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value);document.form1.t_open_year[0].value=ChangeDate(this.value);' value=""></td>
            		            <td class='title'>��������</td>
            		            <td>&nbsp;
            		                <input type='text' name='t_open_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value=""></td>
            		        </tr>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>��<br>
                					��<br>
                					��<br>
                					��<br>
                					��<br>
                					��</td>
            		            <td width="10%" class='title'><b>��ȣ</b></td>
            		            <td width="37%" align='left'>&nbsp;
            		              <input type='text' name='firm_nm' size='30' maxlength='40' class='text' style='IME-MODE: active' value='' >
            		            </td>
            		            <td class='title' width=13%><b>��ǥ��</b></td>
            		            <td width="37%">&nbsp;
            		              <input type='text' size='30' name='client_nm' maxlength='40' class='text' value=''>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'><b>����ڹ�ȣ</b></td>
            		            <td>&nbsp;
                		            <!--<input type='text' size='3' name='enp_no1' maxlength='3' class='text' value='' onkeyup="javascript:set_next('0','enp_no','1');">-->
                					<input type='text' size='3' name='enp_no1' maxlength='3' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 3){ document.form1.enp_no2[0].focus(); }">
                					-
                					<input type='text' size='2' name='enp_no2' maxlength='2' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 2){ document.form1.enp_no3[0].focus(); }">
                					-
                					<input type='text' size='5' name='enp_no3' maxlength='5' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 5){ document.form1.ssn1[0].focus(); }"  OnBlur="CheckBizNo();">
									&nbsp;&nbsp;
									(������ڹ�ȣ : <input type='text' size='3' name='taxregno' maxlength='4' class='text' value=''>)
                					</td>
            		            <td class='title'><b>���ι�ȣ</b></td>
            		            <td>&nbsp;
            		              <input type='text' name='ssn1' maxlength='6' size='6' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.ssn2[0].focus(); }">
            					-
            					<input type='text' name='ssn2' maxlength='7' size='7' class='text' value=''  OnBlur="Biz_ck();">
            					</td>
            		        </tr>
							<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
							<script>
								function openDaumPostcode() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip').value = data.zonecode;
											document.getElementById('t_addr').value = data.roadAddress;
											
										}
									}).open();
								}
							</script>
            		        <tr>
            		            <td class='title'>����� �ּ�</td>
            		            <td colspan='3'>&nbsp;
								<input type="text" name='t_zip' id="t_zip" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" size="50">
            		            </td>
            		        </tr>		
							<script>
								function openDaumPostcode1() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip1').value = data.zonecode;
											document.getElementById('t_addr1').value = data.roadAddress;
											
										}
									}).open();
								}
							</script>							
            		        <tr>
            		          <td class='title'>����������</td>
            		          <td colspan='3'>&nbsp;
            		              <input type="text" name='t_zip' id="t_zip1" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr1" size="50">
								  <input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
            			              ��
            		          </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='bus_cdt' maxlength='40' class='text' value=''>
            		            </td>
            		            <td class='title'>����</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='bus_itm' value='' maxlength='40' class='text' value=''>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td rowspan="3" class='title'>��<br>
            					    ǥ<br>
            					    ��</td>
            		            <td class='title'>��ǥ�ڱ���</td>
            		            <td>&nbsp;
                		            <select name='repre_st'>
                		              <option value="">����</option>
                		              <option value="1">��������</option>
                		              <option value="2">�����濵��</option>
                		            </select></td>
            		            <td class='title'>�������</td>
            		            <td>&nbsp;
                		            <input type='text' name='repre_ssn1' maxlength='6' size='6' class='text' value='' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.repre_ssn2[0].focus(); }">
                					-*******
                					<input type='hidden' name='repre_ssn2' maxlength='7' size='7' class='text' value='*******' OnBlur="jumin_No();">
                						</td>
            		        </tr>
							<script>
								function openDaumPostcode2() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip2').value = data.zonecode;
											document.getElementById('t_addr2').value = data.roadAddress;
											
										}
									}).open();
								}
							</script>	
            		        <tr>
            		            <td class='title'>�ּ�</td>
            		            <td colspan="3">&nbsp;
            		                <input type="text" name='t_zip' id="t_zip2" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr2" size="50"></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>�޴�����ȣ</td>
            		            <td>&nbsp;
            				        <input type='text' size='30' name='m_tel' maxlength='15' class='text' value=''></td>
            		            <td class='title'>���ù�ȣ</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='h_tel' maxlength='15' class='text' value=''></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'><b>�繫�ǹ�ȣ</b></td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='o_tel' maxlength='15' class='text' value=''>
            					</td>
            		            <td class='title'><b>�ѽ���ȣ</b></td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='fax' maxlength='15' class='text' value=''>
            					</td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;
            		                <input type='text' size='50' name='homepage' value='' maxlength='70' class='text' style='IME-MODE: inactive'></td>
            		        </tr>
    		            </table>
    			    </td>
    		    </tr>
        	</table>
	    </td>  	
    </tr>	       
	<tr id=tr_acct2 style='display:none'>
	    <td>
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���λ����</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2></td>
                </tr>
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>��<br>
            		      		  ��<br>
            				      ��<br>
            				      ��<br>
            				      ��<br>
            				      ��</td>
            		            <td class='title' width='10%'>��������� </td>
            		            <td colspan="3">&nbsp;
            		              <input type='text' name='t_open_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value=""></td>
            		        </tr>
            		        <tr>
            		            <td class='title'><b>��ȣ</b></td>
            		            <td width="37%" align='left'>&nbsp;
            		              <input type='text' name='firm_nm' size='30' maxlength='40' class='text' style='IME-MODE: active'>
            		            </td>
            		            <td class='title' width=13%><b>��ǥ��</b></td>
            		            <td width="37%">&nbsp;
            		              <input type='text' size='30' name='client_nm' maxlength='40' class='text'>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'><b>����ڹ�ȣ</b></td>
            		            <td>&nbsp;
            		              <input type='text' size='3' name='enp_no1' maxlength='3' class='text' onkeyup="javascript:if(get_length(this.value) == 3){ document.form1.enp_no2[1].focus(); }">
            		      			-
            		      			<input type='text' size='2' name='enp_no2' maxlength='2' class='text' onkeyup="javascript:if(get_length(this.value) == 2){ document.form1.enp_no3[1].focus(); }">
            		      			-
            		      			<input type='text' size='5' name='enp_no3' maxlength='5' class='text' onkeyup="javascript:if(get_length(this.value) == 5){ document.form1.ssn1[1].focus(); }" OnBlur="CheckBizNo();">
            		            </td>
            		            <td width='15%' class='title'><b>�������</b></td>
            		            <td>&nbsp;
            		                <input type='text' name='ssn1' maxlength='6' size='6' class='text' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.ssn2[1].focus(); }">
            		      			-*******
            		      			<input type='hidden' name='ssn2' maxlength='7' size='7' class='text' value='*******' OnBlur="Biz_ck();">
            		            </td>
            		        </tr>
							<script>
								function openDaumPostcode3() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip3').value = data.zonecode;
											document.getElementById('t_addr3').value = data.roadAddress;
											
										}
									}).open();
								}
							</script>	
            		        <tr>
            		            <td class='title'>����� ������</td>
            		            <td colspan='3'>&nbsp;
								<input type="text" name='t_zip' id="t_zip3" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr3" size="50">

            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='bus_cdt' maxlength='40' class='text'>
            		            </td>
            		            <td class='title'>����</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='bus_itm' value='' maxlength='40' class='text'>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td rowspan="2" class='title'>��<br>
                					ǥ<br>
                					��</td>
            		            <td class='title'>�ּ�</td>
							<script>
								function openDaumPostcode4() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip4').value = data.zonecode;
											document.getElementById('t_addr4').value = data.roadAddress;
											
										}
									}).open();
								}
							</script>								
            		            <td colspan="3">&nbsp;
              		               <input type="text" name='t_zip' id="t_zip4" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode4()" value="�����ȣ ã��"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr4" size="50">
            				    </td>
            		        </tr>
            				<input type='hidden' name='repre_ssn1'>
            				<input type='hidden' name='repre_ssn2'>
            				<!--
            		        <tr>
            		          <td class='title'>�ֹι�ȣ</td>
            		          <td colspan="3">&nbsp;
            		            <input type='hidden' name='repre_ssn1' maxlength='6' size='6' class='text'>
            					-
            					<input type='hidden' name='repre_ssn2' maxlength='7' size='7' class='text'>
            				  </td>
            		        </tr>-->
            		        <tr>
            		            <td class='title'>�޴�����ȣ</td>
            		            <td>&nbsp;
            				        <input type='text' size='30' name='m_tel' maxlength='15' class='text'></td>
            		            <td class='title'>���ù�ȣ</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='h_tel' maxlength='15' class='text'></td>
            		        </tr>		    		    
            		        <tr>
            		            <td colspan="2" class='title'><b>�繫�ǹ�ȣ</b></td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='o_tel' maxlength='15' class='text'>
            		            </td>
            		            <td class='title'><b>�ѽ���ȣ</b></td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='fax' maxlength='15' class='text'>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;
            		              <input type='text' size='50' name='homepage' value='' maxlength='70' class='text' style='IME-MODE: inactive'></td>
            		        </tr>		     
    		            </table>
    				</td>
    		    </tr>
        	</table>
        </td>   	
    </tr>	    
    <tr id=tr_acct3 style='display:none'>
	    <td>
	        <table border="0" cellspacing="0" cellpadding="0" width=100%> 	  
    		    <tr>
    				 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2></td>
                </tr>
    			<tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td colspan="2" class='title'><b>����</b></td>
            		            <td align='left'>&nbsp;
            		              <input type='text' name='firm_nm' size='30' maxlength='40' class='text' style='IME-MODE: active'>
            		            </td>
            		            <td class='title'><b>�ֹι�ȣ</b></td>
            		            <td>&nbsp;
                		            <input type='text' name='ssn1' maxlength='6' size='6' class='text' onkeyup="javascript:if(get_length(this.value) == 6){ document.form1.ssn2[2].focus(); }">
                					-
                					<input type='text' name='ssn2' maxlength='7' size='7' class='text' OnBlur="Biz_ck();">
           						</td>
            		        </tr>
							<script>
								function openDaumPostcode5() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip5').value = data.zonecode;
											document.getElementById('t_addr5').value = data.roadAddress;
											
										}
									}).open();
								}
							</script>						
            		        <tr>
            		            <td colspan="2" class='title'>�����ּ�</td>
            		            <td colspan='3'>&nbsp;
            		              <input type="text" name='t_zip' id="t_zip5" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode5()" value="�����ȣ ã��"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr5" size="50">
								</td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'><b>�޴���</b></td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='m_tel' maxlength='15' class='text'></td>
            		            <td class='title'>������ȭ��ȣ</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='h_tel' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>����</td>
            		            <td>&nbsp;
            		              <select name='nationality'>
                		            <option value="">����</option>
                		            <option value="1">������</option>
                		            <option value="2">�ܱ���</option>
                		          </select>
            		            </td>
            		            <td class='title'>Homepage</td>
            		            <td>&nbsp;
            		              <input type='text' size='50' name='homepage' value='' maxlength='70' class='text' style='IME-MODE: inactive'>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td width="3%" rowspan="6" class='title'>��<br>
                		            ��<br>��<br>
                		            ��</td>
            		            <td width="10%" class='title'>����</td>
            		            <td width="37%">&nbsp;
            		              <input type='text' size='30' name='job' maxlength='20' class='text'>
            		            </td>
            		            <td width="13%" class='title'>�ҵ汸��</td>
            		            <td width="37%">&nbsp; <select name='pay_st'>
                		            <option value="">����</option>
                		            <option value="1">�޿��ҵ�</option>
                		            <option value="2">����ҵ�</option>
                		            <option value="3">��Ÿ����ҵ�</option>
                		                    </select></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>�����</td>
            		            <td colspan="3">&nbsp;
            		              <input type='text' size='50' name='com_nm' maxlength='50' class='text'> </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>�μ���</td>
            		            <td>
            					&nbsp;
            					    <input type='text' size='30' name='dept' maxlength='10' class='text'>
            				    </td>
            		            <td class='title'>����</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='title' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>��ȭ��ȣ</td>
            		            <td>&nbsp;
            		                <input type='text' size='30' name='o_tel' maxlength='15' class='text'></td>
            		            <td class='title'>FAX</td>
            		            <td>&nbsp;
            		              <input type='text' size='30' name='fax' maxlength='15' class='text'>
            		            </td>
            		        </tr>
							<script>
								function openDaumPostcode6() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip6').value = data.zonecode;
											document.getElementById('t_addr6').value = data.roadAddress;
											
										}
									}).open();
								}
							</script>
            		        <tr>
            		          <td class='title'>�����ּ�</td>
            		          <td colspan="3">&nbsp;
            		            <input type="text" name='t_zip' id="t_zip6" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode6()" value="�����ȣ ã��"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr6" size="50">
								</td>
            		          </tr>
            		        <tr>
            		            <td class='title'>�ټӿ���</td>
            		            <td>
            					    &nbsp;
            					    <input type='text' size='2'  name='wk_year' maxlength='2' class='text' value=''>&nbsp;��
            				    </td>
            		            <td class='title'>���ҵ�</td>
            		            <td>&nbsp;
            		                <input type='text' size='7'  name='pay_type' maxlength='9' class='text' value=''>&nbsp;����</td>
            		        </tr>				  
    		            </table>
    			    </td>
    		    </tr>
		    </table>
	    </td>    		
    </tr>  
    <tr>
	    <td class=h></td>
	</tr>  
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="15%" rowspan='3' class='title'>���ݰ�꼭<br>
                        �����</td>
                    <td colspan='3'><input type='checkbox' name='c_tax' onClick='javascript:set_tax();'>
        			    ��ǥ�ڿ� ����</td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp;&nbsp;&nbsp;
                        <input type='text' size='15' name='con_agnt_nm' maxlength='20' class='text'>
        				&nbsp;<img src=/acar/images/center/arrow.gif> �繫��:
        				<input type='text' size='30' name='con_agnt_o_tel' maxlength='30' class='text'>
        				&nbsp;<img src=/acar/images/center/arrow.gif> �̵���ȭ:
        				<input type='text' size='15' name='con_agnt_m_tel' maxlength='15' class='text'>
        				&nbsp;<img src=/acar/images/center/arrow.gif> FAX:
        				<input type='text' size='15' name='con_agnt_fax' maxlength='15' class='text'></td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif> EMAIL:
                      <input type='text' size='15' name='email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" onChange="javascript:document.form1.email_2.value=this.value;" align="absmiddle">
						<option value="" selected>�����ϼ���</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">���� �Է�</option>
						</select>
						<input type='hidden' name='con_agnt_email' value=''>
        			  &nbsp;<img src=/acar/images/center/arrow.gif> �ٹ��μ�:
        			  <input type='text' size='25' name='con_agnt_dept' maxlength='15' class='text' style='IME-MODE: inactive'>
        			  &nbsp;<img src=/acar/images/center/arrow.gif> ����:
        			  <input type='text' size='15' name='con_agnt_title' maxlength='10' class='text'>
                    </td>
                </tr>
                <tr>
                    <td width="15%" class='title'> �ŷ��������ϼ��ſ��� </td>
                    <td width="35%">&nbsp;
                        <select name='item_mail_yn'>
                          <option value='Y' selected>�¶�</option>
                          <option value='N'>�ź�</option>
                        </select>
                    </td>
                    <td width="15%" class='title'> ���ݰ�꼭���ϼ��ſ��� </td>
                    <td width="35%">&nbsp;
                        <select name='tax_mail_yn'>
                          <option value='Y' selected>�¶�</option>
                          <option value='N'>�ź�</option>
                        </select>
                    </td>
                </tr>					
				<!--		
                <tr>
                    <td class='title'> �̸��ϼ��Űźλ��� </td>
                    <td>&nbsp;
                        <textarea name='etax_not_cau' rows='2' cols='100' maxlenght='500'></textarea>
                    </td>
                </tr>
				-->				
                <tr>
                    <td class='title'>��꼭���౸��</td>
                    <td>&nbsp;
                        <select name='print_st' onClick='javascript:set_print();'>
                            <option value=''>����</option>
                            <option value='1'>���Ǻ�</option>
                            <option value='2'>�ŷ�ó����</option>
                            <option value='3'>��������</option>
                            <option value='4'>��������</option>
                            <option value='9'>Ÿ�ý��۹���</option>
                        </select></td>
                    <td class='title'> ��꼭�������౸��</td>
                    <td>&nbsp;
                        <select name='print_car_st'>
                          <option value='' selected>����</option>
                          <option value='1'>����/ȭ��/9�ν�/����</option>
                        </select>
                    </td>
                </tr>
                <tr>                    
                    <td class='title'> ��꼭ǰ��ǥ�ñ���</td>
                    <td >&nbsp;
                        <select name='etax_item_st'>
                          <option value='1' selected>���ٸ�ǥ��</option>
                          <option value='2'>���ǥ��</option>
                        </select>
                    </td>
                    <td class='title'> ��ü���ڼ��ſ��� </td>
                    <td >&nbsp;
                        <select name='dly_sms'>
                          <option value='Y' selected>�¶�</option>
                          <option value='N'>�ź�</option>
                        </select>
                    </td>
                </tr>				
                <tr>	   
                    <td class='title'> ��å�� CMS û�� ���� </td>
                    <td>&nbsp;
                        <select name='etc_cms'>
                          <option value='' selected>--����--</option>
                          <option value='Y'>�¶�</option>
                          <option value='N'>�ź�</option>                  
                        </select>
                        &nbsp;&nbsp;* CMS �ŷ����� ����.
                    <td class='title'> �������·� û�� ���� </td>
                    <td>&nbsp;
                        <select name='fine_yn'>
                          <option value='' selected>--����--</option>
                          <option value='Y'>�¶�</option>
                          <option value='N'>�ź�</option>                  
                        </select>
                        &nbsp;&nbsp;
                        
                    </td>
                </tr>                 			
                <tr>
                    <td class='title'> Ư�̻��� </td>
                    <td colspan='3'>&nbsp;
                      <textarea name='etc' rows='5' cols='100' maxlenght='500'></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	<tr>
	    <td align='right'> <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    </td>
	</tr>	
<%	}%>	
	<tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>

