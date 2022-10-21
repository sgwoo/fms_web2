<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "04", "04");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");	

	CarCompBean cc_r [] = cod.getCarCompAll();
	
	CodeBean cd_r [] = c_db.getCodeAllCms("0003");		//��������� �����´�.
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function CarOffEmpReg(){
	var theForm = document.form1;
	if(!CheckField())		return;
	if(!confirm('����Ͻðڽ��ϱ�?'))		return;
	theForm.emp_ssn.value = theForm.emp_ssn1.value+theForm.emp_ssn2.value;	
	if(theForm.email_1.value != '' && theForm.email_2.value != ''){
		theForm.emp_email.value = theForm.email_1.value+'@'+theForm.email_2.value;		
	}else{
		theForm.emp_email.value = '';		
	}
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	theForm.action = "./car_off_null_p_ui.jsp";
	theForm.submit();
}
function CheckField(){
	var theForm = document.form1;
	if(theForm.emp_nm.value==""){			alert("�̸��� �Է��Ͻʽÿ�.");			theForm.emp_nm.focus();			return false;	}
	else if(theForm.cng_rsn2.value==""){	alert("���������� �������ּ���!");		theForm.cng_rsn2.focus();	return false;	}
	else if(theForm.emp_m_tel.value==""){	alert("�޴�����ȣ�� �Է��Ͻʽÿ�.");	theForm.emp_m_tel.focus();		return false;	}
//	else if(theForm.email_1.value==""){	alert("�̸����� �Է��Ͻʽÿ�.");		theForm.emp_email.focus();		return false;	}
	else if(theForm.reg_dt.value==""){		alert("���ʵ�����ڸ� �Է��Ͻʽÿ�.");	theForm.reg_dt.focus();		return false;	}
	else if(theForm.reg_id.value==""){		alert("���ʵ�ϴ���ڸ� �Է��Ͻʽÿ�.");theForm.reg_id.focus();		return false;	}
	else if(theForm.car_off_id.value==""){	alert("�ٹ�ó�� �Է��Ͻʽÿ�.");		return false;	}
	
	else if(theForm.use_yn[1].checked==true && theForm.sms_denial_rsn.value==""){
							alert("SMS ���Űź��� ��� ������ �Է��Ͻʽÿ�!"); theForm.sms_denial_rsn.focus(); return false; }
	return true;
}
function CarOffSearch(){
	var theForm = document.form1;
	var car_comp_id = theForm.car_comp_id.value;
	var car_off_nm = theForm.car_off_nm.value;
	var SUBWIN="./car_off_s_open.jsp?car_comp_id="+car_comp_id+"&car_off_nm="+car_off_nm;	
	window.open(SUBWIN, "CarOffList", "left=100, top=100, width=950, height=600, scrollbars=yes");
}
function search_zip(idx){
	window.open("./zip_s.jsp?idx="+idx, "�����ȣ�˻�", "left=100, height=200, width=350, height=300, scrollbars=yes");
}
function enter(arg){
	var keyValue = event.keyCode;
	if (arg=='1'&&keyValue =='13') name_check();
	if (arg=='2'&&keyValue =='13') CarOffSearch();
}
function name_check(){
	var fm = document.form1;	
	fm.name.value = document.form1.emp_nm.value;
	fm.action ="./name_check.jsp";
	fm.target = "i_no";
	fm.submit();	
}
function go_list(){
	var fm = document.form1;
	fm.action = "./car_office_p_frame.jsp";
	fm.target = "d_content";
	fm.submit();	
}
function sms_denial(arg){
	if(arg=='N'){
		tr_denial.style.display = "";
		document.form1.sms_denial_rsn.focus();
	}else{
		tr_denial.style.display = "none";
		document.form1.sms_denial_rsn.value = "";		
	}
}

//�ֹε�Ϲ�ȣ üũ

 var errfound = false;

function jumin_No(){
        if(!JuminCheck(document.getElementById("emp_ssn1").value,document.getElementById("emp_ssn2").value)){
                alert("�߸��� �ֹε�Ϲ�ȣ�Դϴ�.");
        } else  {
        		alert("�ùٸ� �ֹε�Ϲ�ȣ�Դϴ�.");
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
-->
</script>
</head>

<body leftmargin="15" onLoad="document.form1.emp_nm.focus();">
<form action="./car_off_null_p_ui.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_off_id" value=""> 
<input type="hidden" name="cmd" value="">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gu_nm" value="<%=gu_nm%>">
<input type="hidden" name="reg_dt" value="<%=AddUtil.getDate(4)%>">
<input type="hidden" name="reg_id" value="<%=user_id%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="name" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����������� > <span class=style5>����������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><div align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	      <a href="javascript:CarOffEmpReg()" onMouseOver="window.status=''; return true"> 
          <img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;
		  <a href="javascript:history.go(-1);" onMouseOver="window.status=''; return true"> 
           <img src=/acar/images/center/button_cancel.gif border=0 align=absmiddle></a>&nbsp;
	    <%}%>	  
		  <a href="javascript:go_list();" onMouseOver="window.status=''; return true"> 
           <img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></div></td>
    </tr>
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ڰ���</span></td>
                </tr>
                <tr> 
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td width=15% class="title">�����</td>
                                            <td width=35%>&nbsp; 
                                              <select name='damdang_id'>
                    		                   <%if(user_size > 0){
                    								for(int i = 0 ; i < user_size ; i++){
                    									Hashtable user = (Hashtable)users.elementAt(i); 
                    							%>
                    							<option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>		
                    			                <%	}
                    							}		%>
                                              </select> </td>
                                            <td width=15% class="title">��������</td>
                                            <td width=35%>&nbsp; <input name="cng_dt" type="text" class="whitetext" value="<%= AddUtil.getDate() %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">��������</td>
                                            <td colspan="3">&nbsp; <select name="cng_rsn2">						
                                                <option value="">==����==</option>
                    							<option value="1">1.�ֱٰ��</option>
                                                <option value="2">2.�����</option>
                                                <option value="3">3.��ȭ���</option>
                                                <option value="4">4.�������</option>
                                                <option value="5">5.��Ÿ</option>
                                              </select></td>
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
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ʻ��װ���</span></td>
                </tr>
                <tr> 
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td width=15% class="title">* ����</td>
                                            <td width=35%>&nbsp; <input type="text" name="emp_nm" value="" size="12" class=text onKeyDown="javascript:enter('1');" style='IME-MODE: active'> 
                                              <a href="javascript:name_check();"><img src=/acar/images/center/button_in_check_jb.gif border=0 align=absmiddle></a></td>
                                            <td width=5% rowspan="2" class="title">����ó</td>
                                            <td width=10% class="title">��ȭ</td>
                                            <td width=35%>&nbsp; <input type="text" name="emp_h_tel" value="" size="23" class=text></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">�ҵ汸��</td>
                                            <td>&nbsp; <input type="radio" name="cust_st" value="2">
                                              ����ҵ�&nbsp; <input type="radio" name="cust_st" value="3">
                                              ��Ÿ����ҵ�&nbsp;</td>
                                            <td class="title">* �ڵ���</td>
                                            <td>&nbsp; <input type="text" name="emp_m_tel" value="" size="23" class=text></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">�ֹε�Ϲ�ȣ</td>
                                            <td>&nbsp; <input type="text" name="emp_ssn1" value="" size="6" maxlength=6 class=text>
                                              - 
                                              <input type="text" name="emp_ssn2" value="" size="7" maxlength=7 class=text  OnBlur="jumin_No();"> 
                                              <input type="hidden" name="emp_ssn" value="" size="18" class=text></td>
                                            <td colspan="2" class="title">����</td>
                                            <td>&nbsp; <input type="radio" name="emp_sex" value="1">
                                              ���� 
                                              <input type="radio" name="emp_sex" value="2">
                                              ���� </td>
                                        </tr>										
                                        <tr> 
                                            <td class="title">* �����ּ�</td>
                                            <td colspan="4">&nbsp; 
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
						<option value="">���� ����</option>
						</select>
					  <input type='hidden' name='emp_email' value=''>
											<!--<input type="text" name="emp_email" value="" size="30" class=text>-->
                                            </td>
                                        </tr>
										<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
										<script>
											function openDaumPostcode() {
												new daum.Postcode({
													oncomplete: function(data) {
														document.getElementById('emp_post').value = data.zonecode;
														document.getElementById('emp_addr').value = data.roadAddress;
														
													}
												}).open();
											}
										</script>							
										<tr>
											<td class=title>���ּ�</td>
											<td colspan=5>&nbsp;
											<input type="text" name='emp_post' id="emp_post" value="" size="7" maxlength='7'>
											<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
											&nbsp;&nbsp;<input type="text" name='emp_addr' id="emp_addr" value="" size="100">

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
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ٹ�ó����(*)</span></td>
                </tr>
                <tr> 
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td colspan="2" class="title">���ۻ��</td>
                                            <td>&nbsp; <select name="car_comp_id" disabled>
                                                <option value="">==����==</option>
                                                <%for(int i=0; i<cc_r.length; i++){
                    							cc_bean = cc_r[i]; 
                    							if(cc_bean.getNm().equals("������Ʈ")) continue;%>
                                                <option value="<%= cc_bean.getCode() %>" <%if(cc_bean.getCode().equals(coe_bean.getCar_comp_id())) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                                                <%}%>
                                              </select></td>
                                            <td colspan="2" class="title">����</td>
                                            <td >&nbsp; <input type="text" name="emp_pos" value="" size="21" class="text"> 
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td width=5% rowspan="2" class="title">�ٹ�ó</td>
                                            <td width=10% class="title">��ȣ(�μ���)</td>
                                            <td width=35%>&nbsp; <input type="text" disabled name="car_off_nm" value="<%= c_db.getNameById(coe_bean.getCar_off_id(),"CAR_OFF") %>" size="20"> 
                                              <a href="javascript:CarOffSearch()" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a> 
                                            </td>
                                            <td width=5% rowspan="2" class="title">����ó</td>
                                            <td width=10% class="title">��ȭ</td>
                                            <td width=35%>&nbsp; <input type="text" disabled name="car_off_tel" value="" size="21"></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">����</td>
                                            <td>&nbsp;<input type="radio" disabled name="car_off_st" value="1">
                                              ���� 
                                              <input type="radio" disabled name="car_off_st" value="2">
                                              �븮��</td>
                                            <td class="title">FAX</td>
                                            <td>&nbsp; <input type="text" disabled name="car_off_fax" value="" size="21"></td>
                                        </tr>
										<script>
											function openDaumPostcode2() {
												new daum.Postcode({
													oncomplete: function(data) {
														document.getElementById('car_off_post').value = data.zonecode;
														document.getElementById('car_off_addr').value = data.roadAddress;
														
													}
												}).open();
											}
										</script>	
                                        <tr> 
                                            <td colspan="2" class="title">�ּ�</td>
                                            <td colspan="4">&nbsp; <input type="text" name='car_off_post' id="car_off_post" value="" size="7" maxlength='7'>
											<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
											&nbsp;&nbsp;<input type="text" name='car_off_addr' id="car_off_addr" value="" size="70">
                                            </td>
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
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ��°���</span></td>
                </tr>
                <tr> 
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td width=15% class="title">�����</td>
                                            <td width=35%>&nbsp; 
                                            	<input type='hidden' name="emp_bank" 			value="">
                                            	<select name="emp_bank_cd" style="width:135">
                                                <option value="">==����==</option>
                                                <%
                    					for(int i=0; i<cd_r.length; i++){
                    						cd_bean = cd_r[i];
                    						//�ű��ΰ�� �̻������ ����
																if(cd_bean.getUse_yn().equals("N"))	 continue;
                    				%>
                                                <option value="<%= cd_bean.getCode() %>"><%= cd_bean.getNm() %></option>
                                                <%}%>
                                              </select></td>
                                            <td width=15% class="title">�����ָ�</td>
                                            <td width=35%>&nbsp; <input type="text" name="emp_acc_nm" value="" size="23" class=text></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">���¹�ȣ</td>
                                            <td colspan="3">&nbsp; <input type="text" name="emp_acc_no" value="" size="23" class=text></td>
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
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>SMS����</span></td>
                </tr>
                <tr> 
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td width=15% class="title">���ſ���</td>
                                            <td>&nbsp;<input type="radio" name="use_yn" value="Y" checked onClick="javascript:sms_denial('Y');">
                                              ����&nbsp;&nbsp; <input type="radio" name="use_yn" value="N" onClick="javascript:sms_denial('N');">
                                              �ź�</td>
                                        </tr>
                                        <tr id="tr_denial" style="display:none;">
                                            <td class="title">���Űźλ���</td>
                                            <td>&nbsp; <input type="text" name="sms_denial_rsn" value="" size="70" class=text>
                                              <font color="#666666"> ���ѱ�100���̳�</font></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> <font color="#666666">���� 
        <font color="#0066FF">�ߺ�üũ</font>�� Ŭ���Ͽ� �ڵ�����ȣ�� �����ּҸ� Ȯ���Ͽ�, �ߺ� �Է��� ���� �ʵ��� 
        �Ͻñ� �ٶ��ϴ�.</font></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> <font color="#666666"> 
        <font color="#0066FF">* ǥ��</font>�� ���� ���� �� �Է��Ͻñ� �ٶ��ϴ�.</font></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> <font color="#666666"> 
        <font color="#0066FF">�ٹ�ó����</font>�� �˻��� Ŭ���Ͽ� �����Ͻñ� �ٶ��ϴ�.</font></td>
    </tr>
</table>
</form>
<form name="form2" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="name" value="">
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

