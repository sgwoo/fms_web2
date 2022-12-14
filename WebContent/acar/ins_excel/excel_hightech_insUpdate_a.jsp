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
	String ins_con_no_arr[]  = request.getParameterValues("ins_con_no");	//차량번호     
	String ins_start_dt_arr[]  = request.getParameterValues("ins_start_dt");	//최초등록일    
	String lkas_yn_arr[] = request.getParameterValues("lkas_yn");	//차선이탈(제어형)
	String ldws_yn_arr[] = request.getParameterValues("ldws_yn");	//차선이탈(경고형)
	String aeb_yn_arr[]  = request.getParameterValues("aeb_yn");	//긴급제동(제어형)
	String fcw_yn_arr[]  = request.getParameterValues("fcw_yn");	//긴급제동(경고형)
	String ev_yn_arr[]   = request.getParameterValues("ev_yn");	//전기자동차    
	

	%>
	<script>
	
		alert('<%=request.getParameterValues("ins_start_dt")%>');	
	</script>
	<%	
	
	int flag = 0;
	int count = 0;
	String result  = "";
	String ins_con_no  = "";
	String ins_start_dt  = "";
	String lkas_yn = "";
	String ldws_yn = "";
	String aeb_yn  = "";
	String fcw_yn  = "";
	String ev_yn   = "";
	String rent_l_cd ="";
	
	
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
			  	<td width="120"  height="20" class="title" >차량번호</td>
			  	<td width="120" height="20" class="title" >최초등록일</td>
			  	<td width="120" height="20" class="title" >차선이탈 (제어형)</td>
			  	<td width="120" height="20" class="title" >차선이탈 (경고형)</td>
			  	<td width="120" height="20" class="title" >긴급제동 (제어형)</td>
			 	<td width="120" height="20" class="title" >긴급제동 (경고형)</td>
			  	<td width="120" height="20" class="title" >전기자동차</td>
			  	<td width="120" height="20" class="title" >결과</td>
			</tr>   
	
	<%
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		count++;
		ins_con_no  = ins_con_no_arr[i] ==null? "":ins_con_no_arr[i] ;  //증권번호    
		ins_start_dt  = ins_start_dt_arr[i] ==null? "":ins_start_dt_arr[i] ;  //보험시작일       
		lkas_yn = lkas_yn_arr[i]==null? "":lkas_yn_arr[i];  //차선이탈(제어형)   
		ldws_yn = ldws_yn_arr[i]==null? "":ldws_yn_arr[i];  //차선이탈(경고형)   
		aeb_yn  = aeb_yn_arr[i] ==null? "":aeb_yn_arr[i] ;  //긴급제동(제어형)   
		fcw_yn  = fcw_yn_arr[i] ==null? "":fcw_yn_arr[i] ;  //긴급제동(경고형)   
		ev_yn   = ev_yn_arr[i]  ==null? "":ev_yn_arr[i]  ;  //전기자동차       
		
		
		if(!ins_con_no.equals("") && !ins_start_dt.equals("")){
			if(lkas_yn.equals("") || lkas_yn.equals("N")){
				lkas_yn = "N";				
			}else{
				lkas_yn = "Y";				
			}
			if(ldws_yn.equals("") || ldws_yn.equals("N")){
				ldws_yn = "N";				
			}else{
				ldws_yn = "Y";				
			}
			if(aeb_yn.equals("") || aeb_yn.equals("N")){
				aeb_yn = "N";				
			}else{
				aeb_yn = "Y";				
			}
			if(fcw_yn.equals("") || fcw_yn.equals("N")){
				fcw_yn = "N";				
			}else{
				fcw_yn = "Y";				
			}
			if(ev_yn.equals("") || ev_yn.equals("N")){
				ev_yn = "N";				
			}else{
				ev_yn = "Y";				
			}
			
			//차량번호, 최초등록일로 
	/* 		if(ins_con_no.length() == 13){
				rent_l_cd = car_no;				
			}else{
				rent_l_cd = ai_db.getRent_l_cd(car_no, reg_dt);
				
			} */
					
			InsurBean ins = new InsurBean();
			
			ins.setLkas_yn(lkas_yn);
			ins.setLdws_yn(ldws_yn);
			ins.setAeb_yn (aeb_yn );
			ins.setFcw_yn (fcw_yn );
			ins.setEv_yn  (ev_yn  );
			ins.setIns_con_no(ins_con_no);	
			ins.setIns_start_dt(ins_start_dt);	
			
			/* 
			System.out.println(ins.getLkas_yn());
			System.out.println(ins.getLdws_yn());
			System.out.println(ins.getAeb_yn());
			System.out.println(ins.getFcw_yn());
			System.out.println(ins.getEv_yn());
			System.out.println(ins.getRent_l_cd()); 
			*/
			
			if(!ai_db.updateHightechIns(ins)){
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
					<td  width="120" align="center" height="20"><p><%=ins_start_dt%></p></td>
					<td  width="120" align="center" height="20"><p><%=lkas_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=ldws_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=aeb_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=fcw_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=ev_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=result%></p></td>
				</tr> 
			<%	
				
			}else{
			 %>
			 	<tr style="background-color:FF9999;">
					<td  width="30" align="center" height="20"><p><%=count%></p></td>
					<td  width="120" align="center" height="20"><p><%=ins_con_no%></p></td>
					<td  width="120" align="center" height="20"><p><%=ins_start_dt%></p></td>
					<td  width="120" align="center" height="20"><p><%=lkas_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=ldws_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=aeb_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=fcw_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=ev_yn%></p></td>
					<td  width="120" align="center" height="20"><p><%=result%></p></td>
				</tr> 	
			 <%
			}
		 }
	
	%>
	</table>
	
</BODY>
</HTML>