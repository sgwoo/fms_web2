<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.insur.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>



<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");	
	
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String result_arr[]  = new String[value_line];
	String ins_con_no_arr[]  = request.getParameterValues("ins_con_no");	//���ǹ�ȣ     
	String firm_emp_nm_arr[]  = request.getParameterValues("firm_emp_nm");	//��ȣ   
	String enp_no_arr[]  = request.getParameterValues("enp_no");	//����ڹ�ȣ
	String age_scp_arr[]  = request.getParameterValues("age_scp");	//����    
	String vins_gcp_kd_arr[]  = request.getParameterValues("vins_gcp_kd");	//�빰    
	String com_emp_yn_arr[]  = request.getParameterValues("com_emp_yn");	//������    
	
	int flag = 0;
	int count = 0;
	String result  = "";
	String ins_con_no  = "";
	String firm_emp_nm  = "";
	String enp_no  = "";
	String age_scp  = "";
	String vins_gcp_kd  = "";
	String com_emp_yn  = "";
	
	//DB�� �ִ� Client ���� ��������
	InsDatabase ai_db = InsDatabase.getInstance();
	Vector vt2 = new Vector();
	
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
		<table border="1">  
			<tr align="center">	
			 	<td width="30"  height="20" class="title" >����</td>
			  	<td width="120"  height="20" class="title" >���ǹ�ȣ</td>
			  	<td width="120" height="20" class="title" >��ȣ</td>
			  	<td width="120" height="20" class="title" >����ڹ�ȣ </td>
			  	<td width="120" height="20" class="title" >����</td>
			  	<td width="120" height="20" class="title" >�빰 </td>
			  	<td width="120" height="20" class="title" >������ </td>
			  	<td width="120" height="20" class="title" >���</td>
			</tr>   
	
	<%
	InsurBean ins = new InsurBean();
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		count++;
		ins_con_no  = ins_con_no_arr[i] ==null? "":ins_con_no_arr[i] ;  	//���ǹ�ȣ       
		firm_emp_nm  = firm_emp_nm_arr[i] ==null? "":firm_emp_nm_arr[i] ;   //��ȣ      
		enp_no  = enp_no_arr[i] ==null? "":enp_no_arr[i]; 					//����ڹ�ȣ
		age_scp = age_scp_arr[i] ==null? "":age_scp_arr[i]; 				//����    
		vins_gcp_kd =  vins_gcp_kd_arr[i] ==null? "":vins_gcp_kd_arr[i]; 	//�빰    
		com_emp_yn  = com_emp_yn_arr[i] ==null? "":com_emp_yn_arr[i]; 		//������    
		
		if(!ins_con_no.equals("") && !firm_emp_nm.equals("")){
			
			//'2','26���̻�','4','24���̻�','1','21���̻�','3','��������','5','30���̻�','6','35���̻�','7','43���̻�','8','48���̻�'
			
			if(age_scp.equals("26���̻�")){
				age_scp = "2";
			}else if(age_scp.equals("24���̻�")){
				age_scp = "4";
				
			}else if(age_scp.equals("21���̻�")){
				age_scp = "1";
				
			}else if(age_scp.equals("��������")){
				age_scp = "3";
				
			}else if(age_scp.equals("30���̻�")){
				age_scp = "5";
				
			}else if(age_scp.equals("35���̻�")){
				age_scp = "6";
				
			}else if(age_scp.equals("43���̻�")){
				age_scp = "7";
				
			}else if(age_scp.equals("48���̻�")){
				age_scp = "8";
				
			}else{
				age_scp = "2";
			}
			
			// '4','5õ����','3','1���','6','5���','7','2���','8','3���','�׿�'
			
			if(vins_gcp_kd.equals("5õ����")){
				vins_gcp_kd = "4";
			}else if(vins_gcp_kd.equals("1���")){
				vins_gcp_kd = "3";
				
			}else if(vins_gcp_kd.equals("5���")){
				vins_gcp_kd = "6";
				
			}else if(vins_gcp_kd.equals("2���")){
				vins_gcp_kd = "7";
				
			}else if(vins_gcp_kd.equals("3���")){
				vins_gcp_kd = "8";
				
			}else{
				vins_gcp_kd = "3";
			}
			
			
			if(com_emp_yn.equals("����") || com_emp_yn.equals("Y") || com_emp_yn.equals("y")  ){
				com_emp_yn="Y";
			}else if(com_emp_yn.equals("�̰���") || com_emp_yn.equals("N") || com_emp_yn.equals("n")  ){
				com_emp_yn="N";
			}else{
				com_emp_yn="N";
			}
			
			
			ins.setIns_con_no(ins_con_no.replaceAll(" ",""));        //���ǹ�ȣ   
			ins.setFirm_emp_nm(firm_emp_nm.replaceAll(" ",""));      //��ȣ     
			ins.setEnp_no(enp_no.replaceAll(" ",""));                //����ڹ�ȣ  
			ins.setAge_scp(age_scp);              //����     
			ins.setVins_gcp_kd(vins_gcp_kd);      //�빰     
			ins.setCom_emp_yn(com_emp_yn);        //������    
				
			
			
			//������ ,���ǹ�ȣ
		 	if(!ai_db.updateFirmEmpNm(ins)){
				result = "����";
			}else{
				result = "��ϿϷ�";
			} 
			
			
		}else{
			
		}
		
		%>
		<%
			if(result.equals("��ϿϷ�")){
			%>
			 	<tr>
					<td  width="30" align="center" height="20"><p><%=count%></p></td>
					<td  width="120" align="center" height="20"><p><%=ins_con_no%></p></td>
					<td  width="250" align="center" height="20"><p><%=firm_emp_nm%></p></td>
					<td  width="120" align="center" height="20"><p><%=enp_no%></p></td>
					<td  width="120" align="center" height="20"><p><%=age_scp%></p></td>
					<td  width="120" align="center" height="20"><p><%=vins_gcp_kd%></p></td>
					<td  width="120" align="center" height="20"><p><%=com_emp_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=result%></p></td>
				</tr> 
			<%	
				
			}else{
			 %>
			 	<tr style="background-color:FF9999;">
					<td  width="30" align="center" height="20"><p><%=count%></p></td>
					<td  width="120" align="center" height="20"><p><%=ins_con_no%></p></td>
					<td  width="250" align="center" height="20"><p><%=firm_emp_nm%></p></td>
					<td  width="120" align="center" height="20"><p><%=enp_no%></p></td>
					<td  width="120" align="center" height="20"><p><%=age_scp%></p></td>
					<td  width="120" align="center" height="20"><p><%=vins_gcp_kd%></p></td>
					<td  width="120" align="center" height="20"><p><%=com_emp_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=result%></p></td>
				</tr> 	
			 <%
			}
		%>
		
		 		
		<%
		
	 }
	
	%>
	</table>
</BODY>
</HTML>