<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="coh_bean" class="acar.car_office.CarOffEdhBean" scope="page"/>
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
	String cng_rsn = request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");
	
	coe_bean = cod.getCarOffEmpBean(emp_id);
	
	CarCompBean cc_r [] = cod.getCarCompAll();
	CodeBean cd_r [] = c_db.getCodeAll_bank("0003");	//������� �����´�.
	CommiBean cm_r [] = cod.getCommiAll(emp_id);
	//
	Vector mngs = c_db.getUserList("", "", "MNG_EMP"); //������ ����Ʈ
	Vector buss = c_db.getUserList("", "", "BUS_EMP"); //�������� ����Ʈ
	Vector gens = c_db.getUserList("", "", "GEN_EMP"); //�ѹ��� ����Ʈ

	//����ں����̷�
	CarOffEdhBean[] cohList  = cod.getCar_off_edh(emp_id); 
	coh_bean = cohList[cohList.length-1];
		
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
function CarOffEmpUp(){
	var theForm = document.CarOffEmpForm;
	if(!CheckField())	return;
	if(!confirm('�����Ͻðڽ��ϱ�?'))	return;
	theForm.emp_ssn.value = theForm.emp_ssn1.value+theForm.emp_ssn2.value;
	theForm.cmd.value = "u";
	theForm.target = "i_no";
	theForm.submit();
}
function CheckField(){
	var theForm = document.CarOffEmpForm;
	if(theForm.emp_nm.value==""){			alert("�̸��� �Է��Ͻʽÿ�.");			theForm.emp_nm.focus();			return false;	}
	else if(theForm.cng_rsn2.value==""){	alert("���������� �������ּ���!");		theForm.cng_rsn2.focus();	return false;	}	
	else if(theForm.car_comp_id.value==""){alert("�Ҽӻ縦 �����Ͻʽÿ�.");		theForm.car_comp_id.focus();	return false;	}
	else if(theForm.car_off_nm.value==""){	alert("�ٹ�ó�� �Է��Ͻʽÿ�.");		theForm.car_off_nm.focus();		return false;	}	
	else if(theForm.car_off_id.value==""){	alert("�븮������ �����Ͻʽÿ�.");		theForm.car_off_nm.focus();		return false;	}	
	else if(theForm.emp_m_tel.value==""){	alert("�޴�����ȣ�� �Է��Ͻʽÿ�.");	theForm.emp_m_tel.focus();		return false;	}
	else if(theForm.emp_email.value==""){	alert("�̸����� �Է��Ͻʽÿ�.");		theForm.emp_email.focus();		return false;	}
	else if(theForm.upd_dt.value==""){		alert("���������ڸ� �Է��Ͻʽÿ�.");	theForm.reg_dt.focus();		return false;	}
	else if(theForm.upd_id.value==""){		alert("�����ϴ���ڸ� �Է��Ͻʽÿ�.");theForm.reg_id.focus();		return false;	}
	else if(theForm.use_yn[1].checked==true && theForm.sms_denial_rsn.value==""){
							alert("SMS ���Űź��� ��� ������ �Է��Ͻʽÿ�!"); theForm.sms_denial_rsn.focus(); return false; }
	return true;
}
function CarOffSearch(){
	var theForm = document.CarOffEmpForm;
	var car_comp_id = theForm.car_comp_id.value;
	var car_off_nm = theForm.car_off_nm.value;
	var SUBWIN="./car_off_s_open.jsp?car_comp_id="+car_comp_id+"&car_off_nm="+car_off_nm;	
	window.open(SUBWIN, "CarOffList", "left=100, top=100, width=560, height=400, scrollbars=yes");
}
function search_zip(){
	window.open("./zip_s_p.jsp", "�����ȣ�˻�", "left=100, height=200, width=350, height=300, scrollbars=yes");
}
function name_check(){
	var fm = document.form1;	
	fm.name.value = document.CarOffEmpForm.emp_nm.value;
	fm.action ="./name_check.jsp";
	fm.target = "i_no";
	fm.submit();	
}
function sms_denial(arg){
	if(arg=='N'){
		tr_denial.style.display = "";
		document.CarOffEmpForm.sms_denial_rsn.focus();
	}else{
		tr_denial.style.display = "none";
		document.CarOffEmpForm.sms_denial_rsn.value = "";
	}
}
function go_page(arg){
	if(arg=="b"){
		document.location.href = "./car_office_p_frame.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun=<%= gubun %>&gu_nm=<%= gu_nm %>&cng_rsn=<%=cng_rsn%>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>";	
	}
}
-->
</script>
</head>

<body>
<form action="./car_off_null_p_ui.jsp" name="CarOffEmpForm" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="emp_id" value="<%=emp_id%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gu_nm" value="<%=gu_nm%>">
<input type="hidden" name="cng_rsn" value="<%=cng_rsn%>">
<input type="hidden" name="car_off_id" value="<%=coe_bean.getCar_off_id()%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="upd_id" value="<%= user_id %>">
<input type="hidden" name="upd_dt" value="<%= AddUtil.getDate(4) %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
  <table width="800" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td><font color="navy">�������� -> </font><a href="/acar/car_office/car_office_p_frame.jsp"><font color="navy">�ڵ��������������</font></a> 
        -> <font color="red">�����������</font></td>
    </tr>
    <tr> 
      <td><div align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	      <a href="javascript:CarOffEmpUp()" onMouseOver="window.status=''; return true"> 
          <img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
		  <a href="javascript:history.go(-1)" onMouseOver="window.status=''; return true"> 
          <img src="/images/calcel.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
	  <%}%>		  
		  <a href="javascript:go_page('b')" onMouseOver="window.status=''; return true"> 
          <img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></div></td>
    </tr>
    <tr> 
      <td><table width="800" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td colspan="2">2. �����ʻ��װ���</td>
          </tr>
          <tr> 
            <td width="20">&nbsp;</td>
            <td width="780"><table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td width="150" class="title">* ����</td>
                        <td width="240">&nbsp; <input type="text" name="emp_nm" value="<%= coe_bean.getEmp_nm() %>" size="12" class=text> 
                          <a href="javascript:name_check();">�ߺ�üũ</a></td>
                        <td width="50" rowspan="2" class="title">����ó</td>
                        <td width="100" class="title">��ȭ</td>
                        <td width="240">&nbsp; <input type="text" name="emp_h_tel" value="<%= coe_bean.getEmp_h_tel() %>" size="23" class=text></td>
                      </tr>
                      <tr> 
                        <td class="title">�ҵ汸��</td>
                        <td>&nbsp; <input type="radio" name="cust_st" value="2" <% if(coe_bean.getCust_st().equals("2")||coe_bean.getCust_st().equals("")) out.println("checked"); %>>
                          ����ҵ�&nbsp; <input type="radio" name="cust_st" value="3" <% if(coe_bean.getCust_st().equals("3")) out.println("checked"); %>>
                          ��Ÿ����ҵ�</td>
                        <td class="title">* �ڵ���</td>
                        <td>&nbsp; <input type="text" name="emp_m_tel" value="<%= coe_bean.getEmp_m_tel() %>" size="23" class=text></td>
                      </tr>
                      <tr> 
                        <td class="title">�ֹε�Ϲ�ȣ</td>
                        <td>&nbsp; <input type="text" name="emp_ssn1" value="<%= coe_bean.getEmp_ssn1() %>" size="6" maxlength=6 class=text>
                          - 
                          <input type="text" name="emp_ssn2" value="<%= coe_bean.getEmp_ssn2() %>" size="7" maxlength=7 class=text> 
                          <input type="hidden" name="emp_ssn" value="" size="18" class=text></td>
                        <td colspan="2" class="title">����</td>
                        <td>&nbsp; <input type="radio" name="emp_sex" value="1" <% if(coe_bean.getEmp_sex().equals("1")) out.println("checked"); %>>
                          ���� 
                          <input type="radio" name="emp_sex" value="2" <% if(coe_bean.getEmp_sex().equals("2")) out.println("checked"); %>>
                          ���� </td>
                      </tr>
                      <tr> 
                        <td class="title">* �����ּ�</td>
                        <td colspan="4">&nbsp; <input type="text" name="emp_email" value="<%= coe_bean.getEmp_email() %>" size="30" class=text> 
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
                        <td class="title"> ���ּ�</td>
                        <td colspan="4">&nbsp; 
						<input type="text" name="emp_post"  id="emp_post" size="7" maxlength='7' value="<%=coe_bean.getEmp_post()%>">
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="emp_addr" id="emp_addr" size="65" value="<%= coe_bean.getEmp_addr() %>">
						<!--
						<input type="text" name="emp_post" value="<%= coe_bean.getEmp_post() %>" size="7" class=text> 
                          <a href="javascript:search_zip()" onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" align="absbottom" border="0"></a>&nbsp;<br> 
                          &nbsp; <input type="text" name="emp_addr" value="<%= coe_bean.getEmp_addr() %>" size="90" class=text> 
						  -->
                        </td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td colspan="2">3. �ٹ�ó����(*)</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
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
                        <td width="240">&nbsp; <input type="text" name="emp_pos" value="<%= coe_bean.getEmp_pos() %>" size="21" class=text> 
                        </td>
                      </tr>
                      <tr> 
                        <td width="50" rowspan="2" class="title">�ٹ�ó</td>
                        <td width="100" class="title">��ȣ(�μ���)</td>
                        <td width="240">&nbsp; <input type="text" name="car_off_nm" value="<%= c_db.getNameById(coe_bean.getCar_off_id(),"CAR_OFF") %>" size="20" disabled> 
                          <a href="javascript:CarOffSearch()" onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" align="absbottom" border="0"></a> 
                        </td>
                        <td width="50" rowspan="2" class="title">����ó</td>
                        <td width="100" class="title">��ȭ</td>
                        <td>&nbsp; <input type="whitetext" name="car_off_tel" value="<%= coe_bean.getCar_off_tel() %>" size="21" disabled></td>
                      </tr>
                      <tr> 
                        <td class="title">����</td>
                        <td>&nbsp; <input type="radio" name="car_off_st" value="1"  <% if(coe_bean.getCar_off_st().equals("1")) out.println("checked"); %> disabled>
                          ���� 
                          <input type="radio" name="car_off_st" value="2"  <% if(coe_bean.getCar_off_st().equals("2")) out.println("checked"); %> disabled>
                          �븮��</td>
                        <td class="title">FAX</td>
                        <td>&nbsp; <input type="whitetext" name="car_off_fax" value="<%= coe_bean.getCar_off_fax() %>" size="21" disabled></td>
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
                        <td colspan="4">&nbsp; 
						<input type="text" name="car_off_post"  id="car_off_post" size="7" maxlength='7' value="<%=coe_bean.getCar_off_post()%>">
						<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="car_off_addr" id="car_off_addr" size="65" value="<%= coe_bean.getCar_off_addr() %>">
						<!--
						<input type="whitetext" name="car_off_post" value="<%= coe_bean.getCar_off_post() %>" size="7" disabled> 
                          <input type="whitetext" name="car_off_addr" value="<%= coe_bean.getCar_off_addr() %>" size="70" disabled> 
						  -->
                        </td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td><img src="../../images/arrow2.gif" width="12" height="9"><font color="#666666">���� 
        <font color="#0066FF">�ߺ�üũ</font>�� Ŭ���Ͽ� �ڵ�����ȣ�� �����ּҸ� Ȯ���Ͽ�, �ߺ� �Է��� ���� �ʵ��� 
        �Ͻñ� �ٶ��ϴ�.</font></td>
    </tr>
    <tr> 
      <td><img src="../../images/arrow2.gif" width="12" height="9"> <font color="#666666"> 
        <font color="#0066FF">* ǥ��</font>�� ���� ���� �� �Է��Ͻñ� �ٶ��ϴ�.</font></td>
    </tr>
    <tr> 
      <td><img src="../../images/arrow2.gif" width="12" height="9"> <font color="#666666"> 
        <font color="#0066FF">�ٹ�ó����</font>�� �˻��� Ŭ���Ͽ� �����Ͻñ� �ٶ��ϴ�.</font></td>
    </tr>
  </table>
</form>
<form name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="name" value="">
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="50" height="50" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>

