<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	//�ڵ���������� ��ȸ ������
	
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");	//BUS=�������/DLV=�����
	String mode 	= request.getParameter("mode")==null?"0":request.getParameter("mode"); 	//1=�˻�
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd"); 	//�˻���
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	String off_id 	= request.getParameter("h_off_id")==null?"":request.getParameter("h_off_id");
	String one_self = request.getParameter("one_self")==null?"":request.getParameter("one_self");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	String jg_w = "";
	
	if(AddUtil.parseInt(car_comp_id) > 5)	jg_w = "1";
	
	int count = 0;
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//������� �˻��ϱ�
	function set_com(){
		document.form1.mode.value = '1';
		document.form1.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') set_com();
	}
		
	
	//������-����� ����
	function set_emp(emp_id, emp_nm, car_off_nm, car_off_id, car_off_st, cust_st, emp_bank, emp_acc_no, emp_acc_nm, bank_cd){
		var idx=0;
		
		//20161222 �����ش븮�� ��û���� �߰�
		if(emp_id=='000643'){alert('��ϺҰ��� ��������Դϴ�.'); return;}
		
		if(document.form1.gubun.value == 'BUS'){
			opener.document.form1.emp_id[0].value 		= emp_id;
			opener.document.form1.emp_nm[0].value 		= emp_nm;
			opener.document.form1.car_off_nm[0].value 	= car_off_nm;
			opener.document.form1.car_off_id[0].value 	= car_off_id;
			if(car_off_st == '1') 		opener.document.form1.car_off_st[0].value = '����';
			else if(car_off_st == '2') 	opener.document.form1.car_off_st[0].value = '������';
			if(cust_st == '1') 			opener.document.form1.cust_st.value = '�����ٷμҵ�';
			else if(cust_st == '2') 	opener.document.form1.cust_st.value = '����ҵ�';
			else if(cust_st == '3') 	opener.document.form1.cust_st.value = '��Ÿ����ҵ�';
			opener.document.form1.emp_bank.value 		= emp_bank;
			opener.document.form1.emp_bank_cd.value 	= bank_cd;
			opener.document.form1.emp_acc_no.value 		= emp_acc_no;
			opener.document.form1.emp_acc_nm.value 		= emp_acc_nm;	
			
		}else{
			opener.document.form1.emp_id[1].value 		= emp_id;
			opener.document.form1.emp_nm[1].value 		= emp_nm;
			opener.document.form1.car_off_nm[1].value 	= car_off_nm;
			opener.document.form1.car_off_id[1].value 	= car_off_id;
			if(car_off_st == '1') 		opener.document.form1.car_off_st[1].value = '����';
			else if(car_off_st == '2') 	opener.document.form1.car_off_st[1].value = '������';		
//			if(opener.document.form1.car_gu.value != '2'){ //�����϶���
//				opener.document.form1.con_bank.value 		= emp_bank;
//				opener.document.form1.con_acc_no.value 		= emp_acc_no;
//				opener.document.form1.con_acc_nm.value 		= emp_acc_nm;									
//			}
			
			<%if(gubun.equals("DLV") && car_comp_id.equals("0001")){%>
				if(emp_nm=='�����Ǹ�����'){
					opener.document.form1.dir_pur_yn[0].checked	=true;
				}else{
					opener.document.form1.dir_pur_yn[1].checked	=true;
				}
			<%}%>
			
			<%if(gubun.equals("DLV") && one_self.equals("Y") && jg_w.equals("") && from_page.equals("")){//��ÿ�������%>
				opener.dlv_con_commi_yn_tr.style.display	= '';
				opener.document.form1.dlv_con_commi_yn[1].checked	=true;
			<%}%>
			
			<%if(gubun.equals("DLV") && one_self.equals("N") && jg_w.equals("") && from_page.equals("")){//��ÿ�������%>
				opener.dlv_con_commi_yn_tr.style.display	= 'none';
				opener.document.form1.dlv_con_commi_yn[0].checked	=true;
			<%}%>
			
		}		
		self.close();
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<p>
<form name='form1' action='search_emp.jsp' method='post'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='one_self' value='<%=one_self%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='h_off_id' value=''>
<input type='hidden' name='h_emp_id' value=''>
<input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
	    <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ������/�������/����ó :	
	    <input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	    <a href='javascript:set_com()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
	    <td align="right"><a href='reg_emp_i.jsp?gubun=<%=gubun%>' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td class=line2 colspan=2></td>		
	</tr>
	<tr>
	    <td class="line" colspan=2>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="8%" class='title'>����</td>
                    <td width="20%" class='title'>�Ҽӻ�</td>
                    <td width="20%" class='title'>�ٹ�ó</td>
                    <td width="20%" class='title'>����</td>
                    <td width="12%" class='title'>����</td>		  
                    <td width="20%" class='title'>����ó</td>
                </tr>
				<%	count = 0;
					if(gubun.equals("DLV") && one_self.equals("Y") && jg_w.equals("")){//��ÿ�������
									CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
        					CarOffEmpBean coe_r [] = umd.getCarOffEmpOneSelfAll("mix", t_wd, "car_off_nm", "asc", car_comp_id);
        					if(coe_r.length > 0){
        						for(int i = 0 ; i < coe_r.length ; i++){
        							coe_bean = coe_r[i];
								//�ٹ����� �ּ� ��������
        							Hashtable ht = umd.getCar_off_addr(coe_bean.getCar_off_id());
								
								//��ü���븮���� ���ݿ� �������� ������Ʈ ����Ʈ���� ����								
								if(coe_bean.getEmp_nm().equals("������")) continue;
								if(coe_bean.getEmp_id().equals("038678")) continue; //'038678','�̸��','�׽����ڸ���' ����
								
								count++;
				%>
                <tr align="center">
                    <td><%=count%></td>
                    <td><%= coe_bean.getCar_comp_nm() %></td>
                    <td><%= coe_bean.getCar_off_nm() %></td>
                    <td><%if(gubun.equals("DLV")){//�����%>
						<a href="javascript:set_emp('<%= coe_bean.getEmp_id() %>','<%= coe_bean.getEmp_nm() %>','<%= coe_bean.getCar_off_nm() %>','<%= coe_bean.getCar_off_id() %>','<%= coe_bean.getCar_off_st() %>','<%= coe_bean.getCust_st() %>','<%= ht.get("BANK") %>','<%= ht.get("ACC_NO") %>','<%= ht.get("ACC_NM") %>', '')" onMouseOver="window.status=''; return true"><%= coe_bean.getEmp_nm() %></a>
						<%}else{//�������%>
						<a href="javascript:set_emp('<%= coe_bean.getEmp_id() %>','<%= coe_bean.getEmp_nm() %>','<%= coe_bean.getCar_off_nm() %>','<%= coe_bean.getCar_off_id() %>','<%= coe_bean.getCar_off_st() %>','<%= coe_bean.getCust_st() %>','<%= coe_bean.getEmp_bank() %>','<%= coe_bean.getEmp_acc_no() %>','<%= coe_bean.getEmp_acc_nm() %>', '')" onMouseOver="window.status=''; return true"><%= coe_bean.getEmp_nm() %></a>						
						<%}%>
					</td>
                    <td><%= coe_bean.getEmp_pos() %></td>		  
                    <td><%= coe_bean.getEmp_m_tel() %><%if(coe_bean.getEmp_m_tel().equals("")){%><%= coe_bean.getCar_off_tel() %><%}%></td>
                </tr>
                <%			}%>
                <%	}%>
                <%if(gubun.equals("DLV") && car_comp_id.equals("0001")){%>
                <tr align="center">
                    <td><%=coe_r.length+1%></td>
                    <td>�����ڵ���</td>
                    <td>B2B������</td>
                    <td><a href="javascript:set_emp('030849','�����Ǹ�����','B2B������','03900','','','','','','')" onMouseOver="window.status=''; return true">�����Ǹ�����</a></td>
                    <td></td>		  
                    <td></td>
                </tr>
        	<%			}else{%>
        	<%				if(coe_r.length == 0){%>
                <tr align="center">
                    <td colspan="6">��ϵ� ��������� �����ϴ� </td>
                </tr>
                <%		}%>
                <%	}%>
				<%	}else{%>
                <%		if(!t_wd.equals("")){
                			count = 0;
        					CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	        				CarOffEmpBean coe_r [] = umd.getCarOffEmpAll("mix", t_wd, "emp_nm", "asc","");
    	    				if(coe_r.length > 0){
        						for(int i = 0 ; i < coe_r.length ; i++){
        							coe_bean = coe_r[i];
        							if(coe_bean.getEmp_nm().equals("�ڱԼ�")) continue;
        							if(coe_bean.getUse_yn().equals("N")) continue;
        							if(gubun.equals("DLV") && coe_bean.getEmp_id().equals("038678")) continue; //'038678','�̸��','�׽����ڸ���' ����
									//�ٹ����� �ּ� ��������
        							Hashtable ht = umd.getCar_off_addr(coe_bean.getCar_off_id());
        							count++;
        					%>
        							
                <tr align="center">
                    <td><%=count%></td>
                    <td><%= coe_bean.getCar_comp_nm() %></td>
                    <td><%= coe_bean.getCar_off_nm() %></td>
                    <td><%if(gubun.equals("DLV")){//�����%>
						<a href="javascript:set_emp('<%= coe_bean.getEmp_id() %>','<%= coe_bean.getEmp_nm() %>','<%= coe_bean.getCar_off_nm() %>','<%= coe_bean.getCar_off_id() %>','<%= coe_bean.getCar_off_st() %>','<%= coe_bean.getCust_st() %>','<%= ht.get("BANK") %>','<%= ht.get("ACC_NO") %>','<%= ht.get("ACC_NM") %>','<%= ht.get("BANK_CD") %>')" onMouseOver="window.status=''; return true"><%= coe_bean.getEmp_nm() %></a>
						<%}else{//�������%>
						<a href="javascript:set_emp('<%= coe_bean.getEmp_id() %>','<%= coe_bean.getEmp_nm() %>','<%= coe_bean.getCar_off_nm() %>','<%= coe_bean.getCar_off_id() %>','<%= coe_bean.getCar_off_st() %>','<%= coe_bean.getCust_st() %>','<%= coe_bean.getEmp_bank() %>','<%= coe_bean.getEmp_acc_no() %>','<%= coe_bean.getEmp_acc_nm() %>','<%= ht.get("BANK_CD") %>')" onMouseOver="window.status=''; return true"><%= coe_bean.getEmp_nm() %></a>						
						<%}%>
					</td>
                    <td><%= coe_bean.getEmp_pos() %></td>		  
                    <td><%= coe_bean.getEmp_m_tel() %><%if(coe_bean.getEmp_m_tel().equals("")){%><%= coe_bean.getCar_off_tel() %><%}%></td>
                </tr>
                <%				}
        					}else{%>
                <tr align="center">
                    <td colspan="6">��ϵ� ��������� �����ϴ� </td>
                </tr>
                <%			}%>
        		<%		}else{%>
                <tr align="center">
                    <td colspan="6">�˻�� �����ϴ�.</td>
                </tr>			
				<%		}%>			
				<%}%>			
            </table>
        </td>
	</tr>
	<tr>
	    <td colspan=2></td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>