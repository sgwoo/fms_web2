<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*, java.text.*, java.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
		
	String result_arr[]  = new String[value_line];
	String ins_con_no_arr[]  = request.getParameterValues("ins_con_no");	//���ǹ�ȣ     
	String car_no_arr[]  = request.getParameterValues("car_no");	//������ȣ    
	String firm_emp_nm_arr[]  = request.getParameterValues("firm_emp_nm");	//��ȣ   
	String enp_no_arr[]  = request.getParameterValues("enp_no");	//����ڹ�ȣ
	String age_scp_arr[]  = request.getParameterValues("age_scp");	//����    
	String vins_gcp_kd_arr[]  = request.getParameterValues("vins_gcp_kd");	//�빰    
	String com_emp_yn_arr[]  = request.getParameterValues("com_emp_yn");	//������    
	
	int flag = 0;
	int count = 0;
	String result  = "";
	String ins_con_no  = "";
	String car_no  = "";
	String firm_emp_nm  = "";
	String enp_no  = "";
	String age_scp  = "";
	String vins_gcp_kd  = "";
	String com_emp_yn  = ""; 
	
	ArrayList<String> ins_con_no_list 	= new ArrayList<String>();
	ArrayList<String> car_no_list 		= new ArrayList<String>();
	ArrayList<String> firm_emp_nm_list 	= new ArrayList<String>();
	ArrayList<String> enp_no_list 		= new ArrayList<String>();
	ArrayList<String> age_scp_list 		= new ArrayList<String>();
	ArrayList<String> vins_gcp_kd_list 	= new ArrayList<String>();
	ArrayList<String> com_emp_yn_list 	= new ArrayList<String>();
	
	
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	//System.out.println("���糯¥ : "+ sdf.format(d));
	String filename = sdf.format(d)+"����_��������.xls";
	filename = java.net.URLEncoder.encode(filename, "UTF-8");
	response.setContentType("application/octer-stream");
	response.setHeader("Content-Transper-Encoding", "binary");
	response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
	response.setHeader("Content-Description", "JSP Generated Data");
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	Vector vt2 = new Vector();
	
	for (int i = start_row ; i < value_line ; i++){
		ins_con_no = ins_con_no_arr[i] ==null? "":ins_con_no_arr[i];
		Hashtable ins = ai_db.getClientInfoExcel2(ins_con_no);
		vt2.add(ins);
	 	
		ins_con_no  = ins_con_no_arr[i] ==null? "����":ins_con_no_arr[i] ;  	//���ǹ�ȣ       
		car_no  = car_no_arr[i] ==null? "����":car_no_arr[i] ;  				//������ȣ      
		firm_emp_nm  = firm_emp_nm_arr[i] ==null? "����":firm_emp_nm_arr[i] ;   //��ȣ      
		enp_no  = enp_no_arr[i] ==null? "����":enp_no_arr[i]; 					//����ڹ�ȣ
		age_scp = age_scp_arr[i] ==null? "����":age_scp_arr[i]; 				//����    
		vins_gcp_kd =  vins_gcp_kd_arr[i] ==null? "����":vins_gcp_kd_arr[i]; 	//�빰    
		com_emp_yn  = com_emp_yn_arr[i] ==null? "����":com_emp_yn_arr[i]; 		//������    
		
		ins_con_no_list.add(ins_con_no);      //���ǹ�ȣ    
		car_no_list.add(car_no); 	          //������ȣ    
		firm_emp_nm_list.add(firm_emp_nm);    //��ȣ      
		enp_no_list.add(enp_no); 	          //����ڹ�ȣ   
		age_scp_list.add(age_scp); 	          //����      
		vins_gcp_kd_list.add(vins_gcp_kd);    //�빰      
		com_emp_yn_list.add(com_emp_yn);      //������      
	 } 
	

%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<style>
table{
	font-size:9pt;
}
</style>
</head>
<body>
	<table border="1">  
	<tr align="center">	
		<td colspan="7" width="100" height="30" class="title" bgcolor="">���������</td>
	  	<td colspan="7" width="100" height="30" class="title" bgcolor="">�Ƹ���ī����</td>
	</tr>
	
	<tr align="center">	
	  	<td width="200" height="30" class="title">���ǹ�ȣ</td>
	  	<td width="100" height="30" class="title">������ȣ</td>
	 	<td width="220" height="30" class="title">��ȣ</td>
	  	<td width="130" height="30" class="title">����ڹ�ȣ</td>
	  	<td width="100" height="30" class="title">����</td>
	  	<td width="100" height="30" class="title">�빰</td>
	  	<td width="100" height="30" class="title" >������</td>
	  	
	  	<td width="200" height="30" class="title">���ǹ�ȣ</td>
	  	<td width="100" height="30" class="title">������ȣ</td>
	 	<td width="220" height="30" class="title">��ȣ</td>
	  	<td width="130" height="30" class="title">����ڹ�ȣ</td>
	  	<td width="100" height="30" class="title">����</td>
	  	<td width="100" height="30" class="title">�빰</td>
	  	<td width="100" height="30" class="title" >������</td>
	</tr>
	<%
	for (int i = 0 ; i < vt2.size() ; i++){
		Hashtable content2 = (Hashtable)vt2.elementAt(i);
		
		flag = 0;
		count++;
	%>
 		<tr height="30">
		<td width="130" align="center" height="30" ><p><%=ins_con_no_list.get(i)%></p></td>
 		<td width="130" align="center" height="30" ><p><%=car_no_list.get(i)%></p></td>
		<td width="100" align="center" height="30" ><p><%=firm_emp_nm_list.get(i)%></p></td>
		<td width="150" align="center" height="30" ><p><%=enp_no_list.get(i)%></p></td>
		<td width="100" align="center" height="30" ><p><%=age_scp_list.get(i)%></p></td>
		<td width="100" align="center" height="30" ><p><%=vins_gcp_kd_list.get(i)%></p></td>
		<td width="40" align="center" height="30"  ><p><%=com_emp_yn_list.get(i)%></p></td> 
		 
	  	<%if((ins_con_no_list.get(i)).equals((String)content2.get("INS_CON_NO"))){%> 
			<td width="130" align="center" height="30" ><p><%=content2.get("INS_CON_NO")%></p></td>
		 <%}else{%>
			<td width="130" align="center" height="30" style="background-color:#FFCDD2;"><p><%=content2.get("INS_CON_NO")%></p></td>
		<%}%> 		
		  <td width="130" align="center" height="30"><p><%=car_no_list.get(i)%></p></td>  	
			
		 <%if((firm_emp_nm_list.get(i)).equals((String)content2.get("FIRM_EMP_NM"))){%>
			<td width="100" align="center" height="30" ><p><%=content2.get("FIRM_EMP_NM")%></p></td>
		<%}else{%>
			<td width="100" align="center" height="30" style="background-color:#FFCDD2;"><p><%=content2.get("FIRM_EMP_NM")%></p></td>
		<%}%>		
		
		<%if((enp_no_list.get(i)).equals((String)content2.get("ENP_NO"))){%>
			<td width="150" align="center" height="30" ><p><%=content2.get("ENP_NO")%></p></td>
		<%}else{%>
			<td width="150" align="center" height="30" style="background-color:#FFCDD2;"><p><%=content2.get("ENP_NO")%></p></td>
		<%}%>
		
		<%if((age_scp_list.get(i)).equals((String)content2.get("AGE_SCP"))){%>
			<td width="100" align="center" height="30" ><p><%=content2.get("AGE_SCP")%></p></td>
		<%}else{%>
			<td width="100" align="center" height="30" style="background-color:#FFCDD2;"><p><%=content2.get("AGE_SCP")%></p></td>
		<%}%>
		
		<%if((vins_gcp_kd_list.get(i)).equals((String)content2.get("VINS_GCP_KD"))){%>
			<td width="100" align="center" height="30" ><p><%=content2.get("VINS_GCP_KD")%></p></td>
		<%}else{%>
			<td width="100" align="center" height="30" style="background-color:#FFCDD2;"><p><%=content2.get("VINS_GCP_KD")%></p></td>
		<%}%>
		
		<%if((com_emp_yn_list.get(i)).equals((String)content2.get("COM_EMP_YN"))){%>
			<td width="40" align="center" height="30"  ><p><%=content2.get("COM_EMP_YN")%></p></td> 
		<%}else{%>
			<td width="40" align="center" height="30"  style="background-color:#FFCDD2;"><p><%=content2.get("COM_EMP_YN")%></p></td> 
		<%}%>		
			  
		
		</tr>
	<%}%>
		
	</table>
</body>
</html>
