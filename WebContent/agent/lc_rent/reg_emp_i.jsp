<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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
	CommiBean cm_r [] = cod.getCommiAll(emp_id);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
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
function CarOffEmpReg(){
	var theForm = document.form1;
	if(!CheckField())		return;
	if(!confirm('����Ͻðڽ��ϱ�?'))		return;
	theForm.emp_ssn.value = theForm.emp_ssn1.value+theForm.emp_ssn2.value;	
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	theForm.submit();
}
function CheckField(){
	var theForm = document.form1;
	if(theForm.emp_nm.value==""){			alert("�̸��� �Է��Ͻʽÿ�.");			theForm.emp_nm.focus();		return false;	}
	else if(theForm.cng_rsn2.value==""){	alert("���������� �������ּ���!");		theForm.cng_rsn2.focus();	return false;	}
	else if(theForm.emp_m_tel.value==""){	alert("�޴�����ȣ�� �Է��Ͻʽÿ�.");	theForm.emp_m_tel.focus();	return false;	}
	else if(theForm.emp_email.value==""){	alert("�̸����� �Է��Ͻʽÿ�.");		theForm.emp_email.focus();	return false;	}
	else if(theForm.reg_dt.value==""){		alert("���ʵ�����ڸ� �Է��Ͻʽÿ�.");	theForm.reg_dt.focus();		return false;	}
	else if(theForm.reg_id.value==""){		alert("���ʵ�ϴ���ڸ� �Է��Ͻʽÿ�.");theForm.reg_id.focus();		return false;	}
	else if(theForm.car_off_nm.value==""){	alert("�ٹ�ó�� �Է��Ͻʽÿ�.");									return false;	}
	else if(theForm.car_off_id.value==""){	alert("�ٹ�ó�� �˻��Ͽ� �Է��Ͻʽÿ�.");							return false;	}
	
	else if(theForm.use_yn[1].checked==true && theForm.sms_denial_rsn.value==""){
							alert("SMS ���Űź��� ��� ������ �Է��Ͻʽÿ�!"); theForm.sms_denial_rsn.focus(); return false; }
	return true;
}

	
function CarOffSearch(){
	var theForm = document.form1;
	var car_comp_id = theForm.car_comp_id.value;
	var car_off_nm = theForm.car_off_nm.value;
	var gubun = theForm.gubun.value;
	var SUBWIN="search_car_off.jsp?car_comp_id="+car_comp_id+"&car_off_nm="+car_off_nm+"&gubun_st="+gubun;	
	window.open(SUBWIN, "CarOffList", "left=100, top=100, width=560, height=450, scrollbars=yes");
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
//-->
</script>
</head>

<body leftmargin="15" onLoad="document.form1.emp_nm.focus();">
<form action="reg_emp_i_a.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
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
<input type="hidden" name="car_off_id" value=""> 
<input type="hidden" name="cmd" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                            <td width="150" class="title">�����</td>
                                            <td width="240">&nbsp; 
                                              <select name='damdang_id'>
                    		                   <%if(user_size > 0){
                    								for(int i = 0 ; i < user_size ; i++){
                    									Hashtable user = (Hashtable)users.elementAt(i); 
                    							%>
                    							<option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>		
                    			                <%	}
                    							}		%>
                    						  
                                              </select> </td>
                                            <td width="150" class="title">��������</td>
                                            <td width="240">&nbsp; <input name="cng_dt" type="text" class="whitetext" value="<%= AddUtil.getDate() %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">��������</td>
                                            <td colspan="3">&nbsp; <select name="cng_rsn2">						
                                                <option value="">==����==</option>
                    							<option value="1" selected>1.�ֱٰ��</option>
                                                <option value="2">2.�����</option>
                                                <option value="3">3.���ʵ��</option>
                                                <option value="4">4.SMS����</option>
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
                                            <td width="150" class="title">* ����</td>
                                            <td width="240">&nbsp; <input type="text" name="emp_nm" value="" size="12" class=text style='IME-MODE: active'> 
                                            </td>
                                            <td width="50" rowspan="2" class="title">����ó</td>
                                            <td width="100" class="title">��ȭ</td>
                                            <td width="240">&nbsp; <input type="text" name="emp_h_tel" value="" size="23" class=text></td>
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
                                              <input type="text" name="emp_ssn2" value="" size="7" maxlength=7 class=text> 
                                              <input type="hidden" name="emp_ssn" value="" size="18" class=text></td>
                                            <td colspan="2" class="title">����</td>
                                            <td>&nbsp; <input type="radio" name="emp_sex" value="1">
                                              ���� 
                                              <input type="radio" name="emp_sex" value="2">
                                              ���� </td>
                                        </tr>
                                        <tr> 
                                            <td class="title">* �����ּ�</td>
                                            <td colspan="4">&nbsp; <input type="text" name="emp_email" value="" size="30" class=text> 
                                            </td>
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
                                            <td class="title"> ���ּ�</td>
                                            <td colspan="4">&nbsp; 
												<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' >
												<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
												&nbsp;<input type="text" name="t_addr" id="t_addr" size="65" >
												
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
                                            <td>&nbsp; <select name="car_comp_id">
                                                <option value="">==����==</option>
                                                <%for(int i=0; i<cc_r.length; i++){
                    							cc_bean = cc_r[i]; %>
                                                <option value="<%= cc_bean.getCode() %>" <%if(cc_bean.getCode().equals(coe_bean.getCar_comp_id())) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                                                <%}%>
                                              </select></td>
                                            <td colspan="2" class="title">����</td>
                                            <td width="240">&nbsp; <input type="text" name="emp_pos" value="" size="21" class="text"> 
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td width="50" rowspan="2" class="title">�ٹ�ó</td>
                                            <td width="100" class="title">�����Ҹ�</td>
                                            <td width="240">&nbsp; <input type="text" name="car_off_nm" value="<%= c_db.getNameById(coe_bean.getCar_off_id(),"CAR_OFF") %>" size="20" class="text"> 
                                              <a href="javascript:CarOffSearch()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
                                            </td>
                                            <td width="50" rowspan="2" class="title">����ó</td>
                                            <td width="100" class="title">��ȭ</td>
                                            <td>&nbsp; <input type="text" name="car_off_tel" value="" size="21" class="text"></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">����</td>
                                            <td>&nbsp;<input type="radio" name="car_off_st" value="1">
                                              ���� 
                                              <input type="radio" name="car_off_st" value="2">
                                              �븮��</td>
                                            <td class="title">FAX</td>
                                            <td>&nbsp; <input type="text" name="car_off_fax" value="" size="21" class="text"></td>
                                        </tr>
										<script>
											function openDaumPostcode1() {
												new daum.Postcode({
													oncomplete: function(data) {
														document.getElementById('t_zip1').value = data.zonecode;
														document.getElementById('t_addr1').value = data.address;
														
													}
												}).open();
											}
										</script>
                                        <tr> 
                                            <td colspan="2" class="title">�ּ�</td>
                                            <td colspan="4">&nbsp; <input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' >
												<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
												&nbsp;<input type="text" name="t_addr" id="t_addr1" size="65" >
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
                                            <td width="150" class="title">�����</td>
                                            <td width="240">&nbsp; 
                                            	<input type='hidden' name="emp_bank" value="">
                                            	<select name="emp_bank_cd" style="width:135">
                                                <option value="">==����==</option>
                                    		<%	if(bank_size > 0){
                    													for(int i = 0 ; i < bank_size ; i++){
                    														CodeBean bank = banks[i];
                    														//�ű��ΰ�� �̻������ ����
   																							if(bank.getUse_yn().equals("N"))	 continue;
                    										%>
                                  				  <option value='<%= bank.getCode()%>' ><%=bank.getNm()%></option>
                               			     <%		}
                    												}%>
                                              </select></td>
                                            <td width="150" class="title">�����ָ�</td>
                                            <td width="240">&nbsp; <input type="text" name="emp_acc_nm" value="" size="23" class=text></td>
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
                                            <td width="150" class="title">���ſ���</td>
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
        <td align="right">
	      <a href="javascript:CarOffEmpReg()" onMouseOver="window.status=''; return true"> 
          <img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;	
		  <a href="javascript:window.close()" onMouseOver="window.status=''; return true"> 
          <img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>	  
		  </td>
    </tr>	
    <tr>
        <td>&nbsp;&nbsp;�� <font color="#666666">���� 
        <font color="#0066FF">�ߺ�üũ</font>�� Ŭ���Ͽ� �ڵ�����ȣ�� �����ּҸ� Ȯ���Ͽ�, �ߺ� �Է��� ���� �ʵ��� 
        �Ͻñ� �ٶ��ϴ�.</font></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;�� <font color="#666666"> 
        <font color="#0066FF">* ǥ��</font>�� ���� ���� �� �Է��Ͻñ� �ٶ��ϴ�.</font></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;�� <font color="#666666"> 
        <font color="#0066FF">�ٹ�ó����</font>�� �˻��� Ŭ���Ͽ� �����Ͻñ� �ٶ��ϴ�.</font></td>
    </tr>
</table>
</form>
<!--
<form name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="name" value="">
</form>
-->
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

