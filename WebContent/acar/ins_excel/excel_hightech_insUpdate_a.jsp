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
	String ins_con_no_arr[]  = request.getParameterValues("ins_con_no");	//������ȣ     
	String ins_start_dt_arr[]  = request.getParameterValues("ins_start_dt");	//���ʵ����    
	String lkas_yn_arr[] = request.getParameterValues("lkas_yn");	//������Ż(������)
	String ldws_yn_arr[] = request.getParameterValues("ldws_yn");	//������Ż(�����)
	String aeb_yn_arr[]  = request.getParameterValues("aeb_yn");	//�������(������)
	String fcw_yn_arr[]  = request.getParameterValues("fcw_yn");	//�������(�����)
	String ev_yn_arr[]   = request.getParameterValues("ev_yn");	//�����ڵ���    
	

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
			  	<td width="120"  height="20" class="title" >������ȣ</td>
			  	<td width="120" height="20" class="title" >���ʵ����</td>
			  	<td width="120" height="20" class="title" >������Ż (������)</td>
			  	<td width="120" height="20" class="title" >������Ż (�����)</td>
			  	<td width="120" height="20" class="title" >������� (������)</td>
			 	<td width="120" height="20" class="title" >������� (�����)</td>
			  	<td width="120" height="20" class="title" >�����ڵ���</td>
			  	<td width="120" height="20" class="title" >���</td>
			</tr>   
	
	<%
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		count++;
		ins_con_no  = ins_con_no_arr[i] ==null? "":ins_con_no_arr[i] ;  //���ǹ�ȣ    
		ins_start_dt  = ins_start_dt_arr[i] ==null? "":ins_start_dt_arr[i] ;  //���������       
		lkas_yn = lkas_yn_arr[i]==null? "":lkas_yn_arr[i];  //������Ż(������)   
		ldws_yn = ldws_yn_arr[i]==null? "":ldws_yn_arr[i];  //������Ż(�����)   
		aeb_yn  = aeb_yn_arr[i] ==null? "":aeb_yn_arr[i] ;  //�������(������)   
		fcw_yn  = fcw_yn_arr[i] ==null? "":fcw_yn_arr[i] ;  //�������(�����)   
		ev_yn   = ev_yn_arr[i]  ==null? "":ev_yn_arr[i]  ;  //�����ڵ���       
		
		
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
			
			//������ȣ, ���ʵ���Ϸ� 
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