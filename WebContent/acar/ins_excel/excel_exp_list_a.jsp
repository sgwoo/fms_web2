<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>


<%

		int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
		int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
		int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
		int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
		
		String result[]   = new String[value_line];
		String no[] 			= request.getParameterValues("no");			
		String car_no[] 		= request.getParameterValues("car_no");		
		String insur_per[]	= request.getParameterValues("insur_per");	
		String ins_dt[] 		= request.getParameterValues("ins_dt");		
		String age_scp[] 		= request.getParameterValues("age_scp");	
		String pay_way[] 		= request.getParameterValues("pay_way");	
		String car_name[] 	= request.getParameterValues("car_name");	
		String ins_kd[] 		= request.getParameterValues("ins_kd");		
		String use_yn[] 		= request.getParameterValues("use_yn");		
		String com_emp_yn[] 	= request.getParameterValues("com_emp_yn");	
		String ins_con_no[] 	= request.getParameterValues("ins_con_no");	

		InsDatabase ai_db = InsDatabase.getInstance();
		InsurBean insurBean = new InsurBean();
		String ins_start_dt = "";
		String ins_exp_dt = "";
		String age = "";
		String fms_age = "";
		
%>
	<HTML>
	<HEAD>
	<TITLE>FMS</TITLE>
	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
	<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
	<script language="JavaScript" src="/include/info.js"></script>
	<!-- <script language='JavaScript' src='/include/common.js'></script> -->
	<style>
		table{
			font-size:9pt;
			border-collapse:collapse;
		}
	</style>
	</HEAD>
	<body>
		<table border="1" width="900">  
			<tr align="center">	
			   <td width="20"  class="title"></td>
	          <td width="20"  class="title"></td>
	         <!--  <td width="50 " class="title">No</td> -->
	          <td width="80 " class="title">������ȣ</td>
	         <!--  <td width="100" class="title">�ǰ����ڸ�</td> -->
	          <td width="150" class="title">�����Ⱓ</td>
	          <td width="50 " class="title">����Ư��</td>
	          <!-- <td width="60 " class="title">�г����</td>
	          <td width="250" class="title">����</td>
	          <td width="300" class="title">���Դ㺸</td>
	          <td width="50 " class="title">������</td> -->
	          <td width="60 " class="title">������Ư��</td>
	          <td width="150" class="title">���ǹ�ȣ</td>
	          
	          <td width="150" class="title">FMS �����Ⱓ</td>
	          <td width="50 " class="title">FMS ����Ư��</td>
	           <td width="60 " class="title">FMS ������Ư��</td>
			</tr>
	
	<%
	for(int i=start_row ; i < value_line ; i++){
	%>
	<style>
		.ins_dt{background-color:white;}
		.age_scp{background-color:white;}
		.com_emp_yn{background-color:white;}
	</style>
	
	<%	
		// ������ ���ǹ�ȣ�� DB�� �ִ� Client�� ã�� ����
		//Hashtable content1 = (Hashtable)vt.elementAt(a);
	
		 //��������
		if(!car_no[i].equals("")) 		car_no[i] = car_no[i].replaceAll(" ","");
		if(!age_scp[i].equals(""))			age_scp[i] = age_scp[i].replaceAll(" ","");
		if(!com_emp_yn[i].equals("")) 	com_emp_yn[i] = com_emp_yn[i].replaceAll(" ","");
		if(!ins_con_no[i].equals("")) 	ins_con_no[i] = ins_con_no[i].replaceAll(" ","");
		if(!ins_dt[i].equals("")) ins_dt[i] = ins_dt[i].replaceAll(" ","");
		
		//1:21�� �̻� 2:26�� �̻� 
		//3:��� ������ 4 : 24���̻�
		 if(!age_scp[i].equals("")){
			if(age_scp[i].contains("21")) age = "1";
			else if(age_scp[i].contains("26")) 	age = "2";
			else if(age_scp[i].contains("24"))	age = "4";
			else if(age_scp[i].contains("���")) 	age = "3";
			else if(age_scp[i].contains("30")) 	age = "5";
			else if(age_scp[i].contains("35"))	age = "6";
			else if(age_scp[i].contains("43"))	age = "7";
			else if(age_scp[i].contains("48"))	age = "8";
			else if(age_scp[i].contains("22"))	age = "9";
			else if(age_scp[i].contains("28"))	age = "10";
			else if(age_scp[i].contains("49"))	age = "11";
			else age ="12";
		}
		
		 String temp[] = new String[2];
		 if(!ins_dt[i].equals("")){
			 temp =  ins_dt[i].split("~");
			 ins_start_dt =  temp[0].substring(0,10).replaceAll("/",""); 
			 ins_exp_dt =  temp[1].substring(0,10).replaceAll("/",""); 
		 }
	
		 insurBean = ai_db.getInsInfo(ins_con_no[i]);
		 
			 
		if(!insurBean.getAge_scp().equals("")){
			if(insurBean.getAge_scp().equals("1")) 	fms_age = "21��";
			else if(insurBean.getAge_scp().equals("2")) 	fms_age = "26��"; 
			else if(insurBean.getAge_scp().equals("4"))		fms_age = "24��"; 
			else if(insurBean.getAge_scp().equals("3")) 	fms_age = "���"; 
			else if(insurBean.getAge_scp().equals("5")) 	fms_age = "30��"; 
			else if(insurBean.getAge_scp().equals("6"))		fms_age = "35��"; 
			else if(insurBean.getAge_scp().equals("7"))		fms_age = "43��"; 
			else if(insurBean.getAge_scp().equals("8"))		fms_age = "48��"; 
			else if(insurBean.getAge_scp().equals("9"))		fms_age = "22��"; 
			else if(insurBean.getAge_scp().equals("10"))	fms_age = "28��"; 
			else if(insurBean.getAge_scp().equals("11"))	fms_age = "49��"; 
			else fms_age ="������";
		}
		 
		if(!ins_start_dt.equals(insurBean.getIns_start_dt())){
			%><style>.ins_dt{background-color:#ffbcbc;}</style><%	
		}
		if(!ins_exp_dt.equals(insurBean.getIns_exp_dt())){
			%><style>.ins_dt{background-color:#ffbcbc;}</style><%	
		}
		if(!age.equals(insurBean.getAge_scp())){
			%><style>.age_scp{background-color:#ffbcbc;}</style><%	
		}
		if(!com_emp_yn[i].equals(insurBean.getCom_emp_yn())){
			%><style>.com_emp_yn{background-color:#ffbcbc;}</style><%	
		}
		
		 
		
	%>
		<tr>
    	  <td width=""  height="30" class="title"><%=i+1%></td>
    	  <td width=""  align="center"><input name="ch_start" type="checkbox"	class="style1" 	value="<%=value_line%>"></td>	
    	 <%--  <td width="50 "  align="center"><%=no[i] 		%></td> --%>
    	  <td width="80 "  align="center"><%=car_no[i] 	%></td>
    	 <%--  <td width="100" align="center"> <%=insur_per[i]	%></td> --%>
    	  <td width="150" align="center" class="ins_dt"> <%=ins_start_dt%>~<%=ins_exp_dt%></td>
    	  <td width="50 " align="center" class="age_scp"> <%=age_scp[i] 	%></td>
    	  <%-- <td width="60 " align="center"> <%=pay_way[i] 	%></td>
    	  <td width="250" align="center"> <%=car_name[i] 	%></td>
    	  <td width="300" align="center"> <%=ins_kd[i] 	%></td>
    	  <td width="50 " align="center"> <%=use_yn[i] 	%></td> --%>
    	  <td width="60 " align="center" class="com_emp_yn"> <%=com_emp_yn[i] %></td>
    	  <td width="150" align="center" style=""> <%=ins_con_no[i] %></td>
    	  
    	  <td width="150" align="center" class="ins_dt"> <%=insurBean.getIns_start_dt()%>~<%=insurBean.getIns_exp_dt()%></td>
    	  <td width="50 " align="center" class="age_scp"> <%=fms_age	%></td>
    	  <td width="60 " align="center" class="com_emp_yn"> <%=insurBean.getCom_emp_yn() %></td>
  		</tr>        
	<%} %>
	</table>	
</BODY>
</HTML>