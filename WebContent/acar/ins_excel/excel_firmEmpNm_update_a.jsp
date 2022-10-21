<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.insur.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>



<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");	
	
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String result_arr[]  = new String[value_line];
	String ins_con_no_arr[]  = request.getParameterValues("ins_con_no");	//증권번호     
	String firm_emp_nm_arr[]  = request.getParameterValues("firm_emp_nm");	//상호   
	String enp_no_arr[]  = request.getParameterValues("enp_no");	//사업자번호
	String age_scp_arr[]  = request.getParameterValues("age_scp");	//연령    
	String vins_gcp_kd_arr[]  = request.getParameterValues("vins_gcp_kd");	//대물    
	String com_emp_yn_arr[]  = request.getParameterValues("com_emp_yn");	//임직원    
	
	int flag = 0;
	int count = 0;
	String result  = "";
	String ins_con_no  = "";
	String firm_emp_nm  = "";
	String enp_no  = "";
	String age_scp  = "";
	String vins_gcp_kd  = "";
	String com_emp_yn  = "";
	
	//DB에 있는 Client 정보 가져오기
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
			 	<td width="30"  height="20" class="title" >연번</td>
			  	<td width="120"  height="20" class="title" >증권번호</td>
			  	<td width="120" height="20" class="title" >상호</td>
			  	<td width="120" height="20" class="title" >사업자번호 </td>
			  	<td width="120" height="20" class="title" >연령</td>
			  	<td width="120" height="20" class="title" >대물 </td>
			  	<td width="120" height="20" class="title" >임직원 </td>
			  	<td width="120" height="20" class="title" >결과</td>
			</tr>   
	
	<%
	InsurBean ins = new InsurBean();
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		count++;
		ins_con_no  = ins_con_no_arr[i] ==null? "":ins_con_no_arr[i] ;  	//증권번호       
		firm_emp_nm  = firm_emp_nm_arr[i] ==null? "":firm_emp_nm_arr[i] ;   //상호      
		enp_no  = enp_no_arr[i] ==null? "":enp_no_arr[i]; 					//사업자번호
		age_scp = age_scp_arr[i] ==null? "":age_scp_arr[i]; 				//연령    
		vins_gcp_kd =  vins_gcp_kd_arr[i] ==null? "":vins_gcp_kd_arr[i]; 	//대물    
		com_emp_yn  = com_emp_yn_arr[i] ==null? "":com_emp_yn_arr[i]; 		//임직원    
		
		if(!ins_con_no.equals("") && !firm_emp_nm.equals("")){
			
			//'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상'
			
			if(age_scp.equals("26세이상")){
				age_scp = "2";
			}else if(age_scp.equals("24세이상")){
				age_scp = "4";
				
			}else if(age_scp.equals("21세이상")){
				age_scp = "1";
				
			}else if(age_scp.equals("모든운전자")){
				age_scp = "3";
				
			}else if(age_scp.equals("30세이상")){
				age_scp = "5";
				
			}else if(age_scp.equals("35세이상")){
				age_scp = "6";
				
			}else if(age_scp.equals("43세이상")){
				age_scp = "7";
				
			}else if(age_scp.equals("48세이상")){
				age_scp = "8";
				
			}else{
				age_scp = "2";
			}
			
			// '4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','그외'
			
			if(vins_gcp_kd.equals("5천만원")){
				vins_gcp_kd = "4";
			}else if(vins_gcp_kd.equals("1억원")){
				vins_gcp_kd = "3";
				
			}else if(vins_gcp_kd.equals("5억원")){
				vins_gcp_kd = "6";
				
			}else if(vins_gcp_kd.equals("2억원")){
				vins_gcp_kd = "7";
				
			}else if(vins_gcp_kd.equals("3억원")){
				vins_gcp_kd = "8";
				
			}else{
				vins_gcp_kd = "3";
			}
			
			
			if(com_emp_yn.equals("가입") || com_emp_yn.equals("Y") || com_emp_yn.equals("y")  ){
				com_emp_yn="Y";
			}else if(com_emp_yn.equals("미가입") || com_emp_yn.equals("N") || com_emp_yn.equals("n")  ){
				com_emp_yn="N";
			}else{
				com_emp_yn="N";
			}
			
			
			ins.setIns_con_no(ins_con_no.replaceAll(" ",""));        //증권번호   
			ins.setFirm_emp_nm(firm_emp_nm.replaceAll(" ",""));      //상호     
			ins.setEnp_no(enp_no.replaceAll(" ",""));                //사업자번호  
			ins.setAge_scp(age_scp);              //연령     
			ins.setVins_gcp_kd(vins_gcp_kd);      //대물     
			ins.setCom_emp_yn(com_emp_yn);        //임직원    
				
			
			
			//임차인 ,증권번호
		 	if(!ai_db.updateFirmEmpNm(ins)){
				result = "실패";
			}else{
				result = "등록완료";
			} 
			
			
		}else{
			
		}
		
		%>
		<%
			if(result.equals("등록완료")){
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