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
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
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
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
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
	
	
	
	
	
	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
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
			fm.action='doc_settle_commi_pay_req_a.jsp';		
//			fm.target='i_no';
//			fm.target='d_content';
//			fm.submit();
		}							

	}
	
	//����������
	function setCommi(){
		var fm = document.form1;		
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));		
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);		
		fm.commi.value = parseDecimal(car_price*comm_r_rt/100);				
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
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="emp_id" 		value="<%=emp1.getEmp_id()%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
	  <td align='left'><font color="navy">�������� -> </font><font color="navy">������</font> -> <font color="red">�����������޿�û</font></td>
	</tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=15%>����ȣ</td>
            <td width=35%>&nbsp;<%=rent_l_cd%></td>
            <td class=title width=15%>��ȣ</td>
            <td width=35%>&nbsp;<%=client.getFirm_nm()%></td>
		  </tr>	
		  <tr>
            <td class=title>������ȣ</td>
            <td>&nbsp;<%=cr_bean.getCar_no()%></td>		
			<td class=title>����</td>
            <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
          </tr>
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
            <td class=title width=15%>�������</td>
            <td width=35%>&nbsp;<%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>&nbsp;<%=emp1.getCar_off_nm()%> <%=emp1.getEmp_nm()%></td>
            <td class=title width=15%>�ҵ汸��</td>
            <td width=35%>&nbsp;<%=emp1.getCust_st()%></td>
		  </tr>	
		  <tr>
            <td class=title>�ź�����ĵ</td>
            <td>&nbsp;<%if(coe_bean.getFile_name1().equals("")){%><a href="javascript:scan_reg('1')">���</a><%}else{%><a href="javascript:MM_openBrWindow('<%= coe_bean.getFile_name1() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= coe_bean.getFile_name1() %>.pdf</a><%}%></td>		
			<td class=title>���彺ĵ</td>
            <td>&nbsp;<%if(coe_bean.getFile_name2().equals("")){%><a href="javascript:scan_reg('2')">���</a><%}else{%><a href="javascript:MM_openBrWindow('<%= coe_bean.getFile_name2() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= coe_bean.getFile_name2() %>.pdf</a><%}%></td>
          </tr>		  
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
            <td class=title width=15%>��������</td>
            <td width=35%>&nbsp;<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>��</td>
            <td class=title width=15%>���ޱݾ�</td>
            <td width=35%>&nbsp;<%=AddUtil.parseDecimal(emp1.getCommi())%>��
			  &nbsp;(<%=emp1.getComm_r_rt()%>%)</td>
		  </tr>	
		  <tr>
            <td class=title>���޿�û��</td>
            <td>&nbsp;<input type='text' name='req_dt' size='11' maxlength='20' class='text' value="<%=AddUtil.getDate()%>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>		
			<td class=title>��Ÿ</td>
            <td>&nbsp;<%if(emp1.getCust_st().equals("����ҵ�")){%>3.3<%}else if(emp1.getCust_st().equals("��Ÿ����ҵ�")){%>5.5<%}%>% ����</td>
          </tr>
		  <tr>
            <td class=title>ó���ǰ� ��<br>���û���</td>
            <td colspan="3">&nbsp;<textarea name='req_cont' rows='5' cols='100' maxlenght='500' style='IME-MODE: active'><%=emp1.getReq_cont()%></textarea></td>		
          </tr>		  
		  <tr id=tr_etc style='display:none'><!-- -->
            <td class=title>etc</td>
            <td colspan="3">&nbsp;
			  <textarea name='doc_etc' rows='5' cols='100' maxlenght='500'>
			    1)����ȣ  :<%=rent_l_cd%>
				2)��ȣ      :<%=client.getFirm_nm()%>
				3)����      :<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>
				4)��������  :<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>
				5)���޿�û��:<%=AddUtil.getDate()%>
				6)���ޱݾ�  :<%=AddUtil.parseDecimal(emp1.getCommi())%>
				7)������    :<%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>&nbsp;<%=emp1.getCar_off_nm()%> <%=emp1.getEmp_nm()%>		
			  </textarea>
			  
			  </td>		
          </tr>		  
		    
		</table>
	  </td>
	</tr>  	  
	<tr>
	  <td align="right">&nbsp;</td>
	<tr>  	
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

