<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	
	
	
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
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//��ĵ���
	function scan_reg(file_st){
		window.open("/acar/car_office/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&emp_id=<%=emp1.getEmp_id()%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}

	function update(){
		var fm = document.form1;
		if(confirm('�����Ͻðڽ��ϱ�?')){	
//			fm.action='reg_commi_pay_req_a.jsp';		
//			fm.target='i_no';
//			fm.target='d_content';
//			fm.submit();
		}							

	}
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="emp_id" 			value="<%=emp1.getEmp_id()%>">  
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
	  <td align='left'><font color="navy">�������� -> </font><font color="navy">������</font> -> <font color="red">�����������޿�û</font></td>
	</tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>����ȣ</td>
            <td width=20%>&nbsp;<%=rent_l_cd%></td>
            <td class=title width=10%>��ȣ</td>
            <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
            <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>����<%}else{%>������ȣ<%}%></td>
            <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>
			</td>
          </tr>
		</table>
	  </td>
	</tr>  	  
	<tr>
	  <td align="right">&nbsp;</td>
	<tr>  
    <tr> 	
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width="13%" class='title'>�������</td>
            <td colspan="5">&nbsp;
              <%=emp1.getEmp_nm()%>             
		    </td>
          </tr>
          <tr>
            <td width="13%" class='title'>�����Ҹ�</td>
            <td width="20%">&nbsp;
              <%=emp1.getCar_off_nm()%></td>
            <td width="10%" class='title'>����</td>
            <td>&nbsp;
              <%=emp1.getCar_off_st()%>
            </td>
            <td width="10%" class='title'>�ҵ汸��</td>
            <td>&nbsp;
              <%=emp1.getCust_st()%></td>			
          </tr>
          <tr>
            <td class='title'>�ִ��������</td>
            <td>&nbsp;
              <input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='num'>
			  % 
			</td>
            <td class='title'>�����������</td>
            <td colspan="3">&nbsp;
              <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='num' onBlur='javascript:setCommi()'>
		      % 			  	  
			</td>
          </tr>
          <tr>
            <td class='title'>�������</td>
            <td colspan="3" >&nbsp;
		      <input type='text' name="ch_remark" value='<%=emp1.getCh_remark()%>' size="40" class='text'>
            </td>
            <td class='title'>������</td>
            <td>&nbsp;
              <select name='ch_sac_id'>
                <option value="">����</option>
         		<%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
      			<option value='<%=user.get("USER_ID")%>' <%if(emp1.getCh_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
        		<%		}
					}%>
              </select>
			</td>
          </tr>
          <tr>
            <td class='title'>�����</td>
            <td >&nbsp;
		      <select name='emp_bank'>
                <option value=''>����</option>
                <%	if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];%>
                <option value='<%= bank.getNm()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                <%		}
					}%>
              </select>
			</td>
            <td class='title'>���¹�ȣ</td>
            <td>&nbsp;
              <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="15" class='text'>
			</td>
            <td class='title'>�����ָ�</td>
            <td>&nbsp;
              <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="15" class='text'>
			</td>
          </tr>		
          <tr>
            <td class='title'>���������������</td>
            <td>&nbsp;
              <input type='text' size='11' name='commi_car_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">��</td>
            <td class='title'>���޼�����</td>
            <td colspan="3">&nbsp;
              <input type='text' name="commi" size='10' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
			  ��			  
			</td>
          </tr>	
		</table>
	  </td>
	</tr>  	  
	<tr>
	  <td>�� ���޿�û</td>
	<tr>  
    <tr> 	
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
          <tr>
            <td class=title>����</td>
            <td colspan="5">&nbsp;
			  <textarea name='req_cont' rows='5' cols='100' maxlenght='500'><%=emp1.getReq_cont()%></textarea></td>
          </tr>		  	  		  
          <tr>
            <td class=title>���޿�û��</td>
            <td colspan="5">&nbsp;
			  <input type='text' name='req_dt' size='11' maxlength='20' class='text' value="<%=AddUtil.ChangeDate2(emp1.getReq_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>		  	  		  
          <tr>
            <td width="13%" class='title'>�ź�����ĵ</td>
            <td colspan="5">&nbsp;
              <%if(coe_bean.getFile_name1().equals("")){%><a href="javascript:scan_reg('1')">���</a><%}else{%><a href="javascript:MM_openBrWindow('<%= coe_bean.getFile_name1() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= coe_bean.getFile_name1() %>.pdf</a><%}%>              
		    </td>
          </tr>		    		  
          <tr>
            <td width="13%" class='title'>���彺ĵ</td>
            <td colspan="5">&nbsp;
              <%if(coe_bean.getFile_name2().equals("")){%><a href="javascript:scan_reg('2')">���</a><%}else{%><a href="javascript:MM_openBrWindow('<%= coe_bean.getFile_name2() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= coe_bean.getFile_name2() %>.pdf</a><%}%>
		    </td>			
          </tr>		    		  
        </table>
      </td>
    </tr>
    <tr>
	  <td align='center'>&nbsp;</td>
	</tr>	
    <tr>
	  <td align='center'><input type="button" name="b_selete" value="���" onClick="javascript:update();">&nbsp;<input type="button" name="b_selete" value="�ݱ�" onClick="javascript:window.close();"></td>
	</tr>	
  </table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

