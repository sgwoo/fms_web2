<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>

<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); //�⵵
	
	String height = request.getParameter("height")==null?"":request.getParameter("height");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	Vector vt = ad_db.getStatCmpList(gubun1);
		
	int vt_size =vt.size();
      
    long s_amt[] = new long[5];   
    long d_amt[] = new long[5];   
    long c_amt[] = new long[5];   
    long e_amt[] = new long[5];   
    long f_amt[] = new long[5];   
    long g_amt[] = new long[5];   
    long p_amt[] = new long[5];  
    
    long st_s_amt[] = new long[5];   
    long st_d_amt[] = new long[5];   
    long st_c_amt[] = new long[5];   
    long st_e_amt[] = new long[5];   
    long st_f_amt[] = new long[5];   
    long st_g_amt[] = new long[5];   
    long st_p_amt[] = new long[5];  
    
    long gt_s_amt[] = new long[5];   
    long gt_d_amt[] = new long[5];   
    long gt_c_amt[] = new long[5];   
    long gt_e_amt[] = new long[5];   
    long gt_f_amt[] = new long[5];   
    long gt_g_amt[] = new long[5];   
    long gt_p_amt[] = new long[5];  
    
    
    long w_s_amt[] = new long[5];   
    long w_d_amt[] = new long[5];   
    long w_c_amt[] = new long[5];   
    long w_e_amt[] = new long[5];   
    long w_f_amt[] = new long[5];   
    long w_g_amt[] = new long[5];   
    long w_p_amt[] = new long[5];  
    
    long w_st_s_amt[] = new long[5];   
    long w_st_d_amt[] = new long[5];   
    long w_st_c_amt[] = new long[5];   
    long w_st_e_amt[] = new long[5];   
    long w_st_f_amt[] = new long[5];   
    long w_st_g_amt[] = new long[5];   
    long w_st_p_amt[] = new long[5];  
    
    long w_gt_s_amt[] = new long[5];   
    long w_gt_d_amt[] = new long[5];   
    long w_gt_c_amt[] = new long[5];   
    long w_gt_e_amt[] = new long[5];   
    long w_gt_f_amt[] = new long[5];   
    long w_gt_g_amt[] = new long[5];   
    long w_gt_p_amt[] = new long[5];  
             
   	       
    String loan_chk = "";   
    int    t_loan_cnt = 0; 
    int w_cnt=0;
    int p_cnt=0;
        
    String dept_nm = "";    
    long st_amt = 0;   
    long st_sub_amt = 0;   
    long gt_tot_amt = 0;   

    long w_st_amt = 0;   
    long w_st_sub_amt = 0;   
    long w_gt_tot_amt = 0;
    
	int type_size1 = 0;
	int type_size2 = 0;
	int type_size3 = 0;
	
	int w_type_size1 = 0;
	int w_type_size2 = 0;
	int w_type_size3 = 0;
	
	int row1 = 0;
	int wrow1 = 0;
		
    for(int i = 0 ; i < vt_size ; i++){
    	Hashtable ht = (Hashtable)vt.elementAt(i);
		if(String.valueOf(ht.get("LOAN_ST")).equals("2")) type_size1++;
		if(String.valueOf(ht.get("LOAN_ST")).equals("4")) type_size2++;	
		if(String.valueOf(ht.get("LOAN_ST")).equals("5")) type_size3++;	
		
		if  (  AddUtil.parseInt(String.valueOf(ht.get("WY")) ) > 11 ) {
			if(String.valueOf(ht.get("LOAN_ST")).equals("2")) w_type_size1++;
			if(String.valueOf(ht.get("LOAN_ST")).equals("4")) w_type_size2++;	
			if(String.valueOf(ht.get("LOAN_ST")).equals("5")) w_type_size3++;				
		};  //1���̻�  
		
	}    
    
	
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">
</head>

<body>
<form action="" id="form1"  name="form1" method="POST">
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 250px;">
					<div style="width: 250px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>						
			        		    <td width="30" class='title title_border'>����</td>
			                    <td width="85" class='title title_border' >����</td>
			                    <td width="65" class='title title_border'>����</td>
			                    <td width="70" class='title title_border'>�Ի���</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							   <tr> 
				        	        <td colspan=6 class='title title_border'   width='516' >����(����)</td>
				        	        <td rowspan=2 class='title title_border'   width='104' >�հ�</td> 
				                    <td colspan=6 class='title title_border'   width='516' >1(Ȯ��)</td>
				                    <td colspan=6 class='title title_border'   width='516' >2(Ȯ��)</td>
				                    <td colspan=6 class='title title_border'   width='516' >3(Ȯ��)</td>
				                    <td colspan=3 class='title title_border'   width='255' >4(Ȯ��)</td>
				                     
				                </tr>      
				                <tr> 
				                <%for (int j = 1 ; j <= 4 ; j++){%>
				                 	<td class='title title_border' width='86'> ����</td>
				                 	<td class='title title_border' width='86' >ä��</td>
				                    <td class='title title_border' width='86' >1�����</td>             
				                    <td class='title title_border' width='86' >2�����</td>
				                    <td class='title title_border' width='86' >����</td>
				                    <td class='title title_border' width='86' >�Ұ�</td>
				               <% } %>     
				                         
				                    <td class='title title_border' width="85" >����</td> <!--4�б� --> 
				                    <td class='title title_border' width="85" >ä��</td>                   
				                    <td class='title title_border' width="85" >�Ұ�</td>
				                </tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 250px;">
					<div style="width: 250px;">
						<table class="inner_top_table left_fix">
					<%if(vt_size > 0){%>   
				        <%	for(int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								if ( i == 0 ) {
								    loan_chk = String.valueOf(ht.get("LOAN_ST"));
								}
								
								//��Ī
								dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("USER_ID")));				
								p_cnt++;
								
						%>		
						
				<%    if ( !loan_chk.equals(String.valueOf(ht.get("LOAN_ST")))) {  %>        
				                <tr> 
				                     <td class='title content_border' colspan="4" style='height:44;'><% if ( loan_chk.equals("2")) { %>2��<% } else if ( loan_chk.equals("4")) { %>1��<%} else {%>����<% } %>&nbsp;�Ұ�<br>&nbsp;&nbsp;&nbsp;&nbsp;���</td>
				                </tr>
				                <tr> 
				                     <td class='title content_border' colspan="4" style='height:44;'><% if ( loan_chk.equals("2")) { %>2��<% } else if ( loan_chk.equals("4")) { %>1��<%} else {%>����<% } %>&nbsp;�Ұ�(1��̸�����)<br>&nbsp;&nbsp;&nbsp;&nbsp;���(1��̸�����)</td>
				                </tr>
				<%		
				       		 loan_chk = String.valueOf(ht.get("LOAN_ST"));
				       		 p_cnt=1;
				        }
				%>   									
				              <tr> 
				                   <td width='30' class='center content_border'>&nbsp;<%=p_cnt%></td>
				                   <td width='85' class='center content_border'>
				           <%  if ( ht.get("NM").equals("�����")) { %>
				           �����
				           <% } else { %>				          
				                   <%=dept_nm%>
				           <% } %>     
				                    </td>
				                    <td width='64' class='center content_border'><%=ht.get("USER_NM")%></td>
				                    <td width='70' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>				     
				                </tr>
				 
				        <%		}	%>
				                <tr> 
				                    <td class='title content_border' colspan="4" style='height:44;'><% if ( loan_chk.equals("2")) { %>2��<% } else if ( loan_chk.equals("4")) { %>1��<%} else {%>����<% } %>&nbsp;�Ұ�<br>&nbsp;&nbsp;&nbsp;&nbsp;���</td>
				                </tr>
				                
				                <tr> 
				                     <td class='title content_border' colspan="4" style='height:44;' ><% if ( loan_chk.equals("2")) { %>2��<% } else if ( loan_chk.equals("4")) { %>1��<%} else {%>����<% } %>&nbsp;�Ұ�(1��̸�����)<br>&nbsp;&nbsp;&nbsp;&nbsp;���(1��̸�����)</td>
				                </tr>
				
				                <tr> 
				                    <td class='title_p content_border' colspan="4" style='height:44;'>�հ�<br>���</td>
				                </tr>
				                <tr> 
				                    <td class='title_p content_border' colspan="4" style='height:44;'>�հ�(1��̸�����)<br>���(1��̸�����)</td>
				                </tr>
				     
					 <%		}  else {	%>    
					 			<tr>
							   		<td width="250" colspan="4" class='center content_border'>&nbsp;</td>
							 </tr>	   
					 <% } %>
					 
					     </table>	
				    </div>
				</td>	
	      
				<td> 
					<div>
						<table class="inner_top_table table_layout">
					<%  if(vt_size > 0)	{  %>
					
					  <% for(int k = 0 ; k < 3 ; k++){ %>		
								   
					        <%	          
					        	  if ( k == 0 )  { 	          
						          	row1=type_size1;   
						        	wrow1=w_type_size1;   
						          	gubun1 = "2";
						          }else if ( k== 1) {	         
						          	row1=type_size2; 
						        	wrow1=w_type_size2;   
						        	gubun1 = "4";
						          } else if ( k== 2) {	          
						          	row1=type_size3; 
						        	wrow1=w_type_size3;   
						        	gubun1 = "5";	      
						         
							     }                     
					         	  
					        	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
															
									if(String.valueOf(ht.get("LOAN_ST")).equals(gubun1)) {	
										 				 
										for (int j = 0 ; j < 5 ; j++){
											
											  s_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //����
											  d_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //ä��
											  c_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));	//1�����		
											  e_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("E"+(j))));
											  f_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("F"+(j))));  //2�����
											  g_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("G"+(j))));
											  p_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //����	
											  
											  
											  st_s_amt[j] = st_s_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //����
											  st_d_amt[j] = st_d_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //ä��
											  st_c_amt[j] = st_c_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));  //1�����
											  st_e_amt[j] = st_e_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("E"+(j)))); //1�����
						 					  st_f_amt[j] = st_f_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("F"+(j)))); //2�����  
											  st_g_amt[j] = st_g_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("G"+(j)))); //1����� 
											  st_p_amt[j] = st_p_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //����	
											  
											  gt_s_amt[j] = gt_s_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //����
											  gt_d_amt[j] = gt_d_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //ä��
											  gt_c_amt[j] = gt_c_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));
											  gt_e_amt[j] = gt_e_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("E"+(j))));
											  gt_f_amt[j] = gt_f_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("F"+(j))));
											  gt_g_amt[j] = gt_g_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("G"+(j))));
											  gt_p_amt[j] = gt_p_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //����	
											  
											  if ( j > 0 ) { 	
												  st_amt 	   = st_amt   +  (s_amt[j]+d_amt[j]+c_amt[j]+e_amt[j]+f_amt[j] + g_amt[j] + p_amt[j])  ;  
												  st_sub_amt = st_sub_amt +  (s_amt[j]+d_amt[j]+c_amt[j]+e_amt[j]+f_amt[j] + g_amt[j] + p_amt[j]  );  
												  gt_tot_amt = gt_tot_amt +  (s_amt[j]+d_amt[j]+c_amt[j]+e_amt[j]+f_amt[j] + g_amt[j] + p_amt[j] );  
											  }		
											  
											  
											  //1��̸� 
											 if  (  AddUtil.parseInt(String.valueOf(ht.get("WY")) ) > 11 ) { 
												  w_s_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //����
												  w_d_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //ä��
												  w_c_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));	//1�����		
												  w_e_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("E"+(j))));
												  w_f_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("F"+(j))));  //2�����
												  w_g_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("G"+(j))));
												  w_p_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //����	
												  
												  
												  w_st_s_amt[j] = w_st_s_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //����
												  w_st_d_amt[j] = w_st_d_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //ä��
												  w_st_c_amt[j] = w_st_c_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));  //1�����
												  w_st_e_amt[j] = w_st_e_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("E"+(j)))); //1�����
							 					  w_st_f_amt[j] = w_st_f_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("F"+(j)))); //2�����  
												  w_st_g_amt[j] = w_st_g_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("G"+(j)))); //1����� 
												  w_st_p_amt[j] = w_st_p_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //����	
												  
												  w_gt_s_amt[j] = w_gt_s_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //����
												  w_gt_d_amt[j] = w_gt_d_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //ä��
												  w_gt_c_amt[j] = w_gt_c_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));
												  w_gt_e_amt[j] = w_gt_e_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("E"+(j))));
												  w_gt_f_amt[j] = w_gt_f_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("F"+(j))));
												  w_gt_g_amt[j] = w_gt_g_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("G"+(j))));
												  w_gt_p_amt[j] = w_gt_p_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //����	
												  
												  if ( j > 0 ) { 	
													  w_st_amt 	   = w_st_amt   +  (w_s_amt[j]+w_d_amt[j]+w_c_amt[j]+w_e_amt[j]+w_f_amt[j] + w_g_amt[j] + w_p_amt[j])  ;  
													  w_st_sub_amt = w_st_sub_amt +  (w_s_amt[j]+w_d_amt[j]+w_c_amt[j]+w_e_amt[j]+w_f_amt[j] + w_g_amt[j] + w_p_amt[j] );  
													  w_gt_tot_amt = w_gt_tot_amt +  (w_s_amt[j]+w_d_amt[j]+w_c_amt[j]+w_e_amt[j]+w_f_amt[j] + w_g_amt[j] + w_p_amt[j] );  
												  }					  
											  
											 }
										  
										}	
						   %>
						     	<tr>
						    <% for (int j = 0 ; j < 1 ; j++){  %>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(s_amt[j])%></td>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(d_amt[j])%></td>	
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(c_amt[j]+e_amt[j]+g_amt[j])%></td>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(f_amt[j])%></td>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(p_amt[j])%></td>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(s_amt[j]+d_amt[j]+c_amt[j]+e_amt[j]+f_amt[j] + g_amt[j] + p_amt[j])%></td>	      		
				        	<% } %>	
				        		    <td class='right content_border' width='104'><%=Util.parseDecimal(st_amt)%></td>	 <!--  total -->     		
				        	         	
				        	 <% for (int j = 1 ; j < 4 ; j++){  %>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(s_amt[j])%></td>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(d_amt[j])%></td>	
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(c_amt[j]+e_amt[j]+g_amt[j])%></td>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(f_amt[j])%></td>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(p_amt[j])%></td>
				        		    <td class='right content_border' width='86'><%=Util.parseDecimal(s_amt[j]+d_amt[j]+c_amt[j]+e_amt[j]+f_amt[j] + g_amt[j] + p_amt[j])%></td>	      		
				        	<% } %>	       
				        
				           <% for (int j = 4 ; j < 5 ; j++){  %>
				        		    <td class='right content_border' width='85'><%=Util.parseDecimal(s_amt[j])%></td>
				        		    <td class='right content_border' width='85'><%=Util.parseDecimal(d_amt[j])%></td>        		 
				        		    <td class='right content_border' width='85'><%=Util.parseDecimal(s_amt[j]+d_amt[j])%></td>	      		
				        	<% } %>	 
							  </tr>		
							  		
					<%   st_amt = 0;
						 w_st_amt = 0;
						}  }		
					    
					%> <!-- loan_st�� Ʋ�� ���  -->
					
						<%if(row1 >0){%>      	
					        <tr>	
						   <% for (int j = 0 ; j < 1 ; j++){  %>
				        		    <td class='title content_border'  style='text-align:right;height:44;' ><%=Util.parseDecimal(st_s_amt[j])%><br><%=Util.parseDecimal(st_s_amt[j]/row1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_d_amt[j])%><br><%=Util.parseDecimal(st_d_amt[j]/row1)%></td>	
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_c_amt[j]+st_e_amt[j]+st_g_amt[j])%><br><%=Util.parseDecimal((st_c_amt[j]+st_e_amt[j]+st_g_amt[j])/row1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_f_amt[j])%><br><%=Util.parseDecimal(st_f_amt[j]/row1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_p_amt[j])%><br><%=Util.parseDecimal(st_p_amt[j]/row1)%></td>
				        		    <td class='title content_border'  style='text-align:right' ><%=Util.parseDecimal(st_s_amt[j]+st_d_amt[j]+st_c_amt[j]+st_e_amt[j] +st_f_amt[j]+st_g_amt[j]+st_p_amt[j])%><br><%=Util.parseDecimal((st_s_amt[j]+st_d_amt[j]+st_c_amt[j]+st_e_amt[j] +st_f_amt[j]+st_g_amt[j]+st_p_amt[j])/row1)%></td>	      		
				           <% } %>	
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_sub_amt)%><br><%=Util.parseDecimal(st_sub_amt/row1)%></td>	 <!--  total -->     		
				        	 
				        	
				        	 <% for (int j = 1 ; j < 4 ; j++){  %>
				        		    <td class='title content_border'  style='text-align:right' ><%=Util.parseDecimal(st_s_amt[j])%><br><%=Util.parseDecimal(st_s_amt[j]/row1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_d_amt[j])%><br><%=Util.parseDecimal(st_d_amt[j]/row1)%></td>	
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_c_amt[j]+st_e_amt[j]+st_g_amt[j])%><br><%=Util.parseDecimal((st_c_amt[j]+st_e_amt[j]+st_g_amt[j])/row1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_f_amt[j])%><br><%=Util.parseDecimal(st_f_amt[j]/row1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_p_amt[j])%><br><%=Util.parseDecimal(st_p_amt[j]/row1)%></td>
				        		    <td class='title content_border'  style='text-align:right' ><%=Util.parseDecimal(st_s_amt[j]+st_d_amt[j]+st_c_amt[j]+st_e_amt[j] +st_f_amt[j]+st_g_amt[j]+st_p_amt[j])%><br><%=Util.parseDecimal((st_s_amt[j]+st_d_amt[j]+st_c_amt[j]+st_e_amt[j] +st_f_amt[j]+st_g_amt[j]+st_p_amt[j])/row1)%></td>	      		
				        	<% } %>	       
				        
				           <% for (int j = 4 ; j < 5 ; j++){  %>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_s_amt[j])%><br><%=Util.parseDecimal(st_s_amt[j]/row1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_d_amt[j])%><br><%=Util.parseDecimal(st_d_amt[j]/row1)%></td>        		 
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(st_s_amt[j]+st_d_amt[j])%><br><%=Util.parseDecimal((st_s_amt[j]+st_d_amt[j])/row1)%></td>	      		
				        	<% } %>        	
							 </tr>
							   
							  <tr> 
						 <!-- �Ұ� 1��̸� --> 
						    <% for (int j = 0 ; j < 1 ; j++){  %>
				        		    <td class='title content_border'  style='text-align:right;height:44;' ><%=Util.parseDecimal(w_st_s_amt[j])%><br><%=Util.parseDecimal(w_st_s_amt[j]/wrow1)%></td>
				        		    <td class='title content_border'  style='text-align:right' ><%=Util.parseDecimal(w_st_d_amt[j])%><br><%=Util.parseDecimal(w_st_d_amt[j]/wrow1)%></td>	
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_c_amt[j]+w_st_e_amt[j]+w_st_g_amt[j])%><br><%=Util.parseDecimal((w_st_c_amt[j]+w_st_e_amt[j]+w_st_g_amt[j])/wrow1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_f_amt[j])%><br><%=Util.parseDecimal(w_st_f_amt[j]/wrow1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_p_amt[j])%><br><%=Util.parseDecimal(w_st_p_amt[j]/wrow1)%></td>
				        		    <td class='title content_border'  style='text-align:right' ><%=Util.parseDecimal(w_st_s_amt[j]+w_st_d_amt[j]+w_st_c_amt[j]+w_st_e_amt[j] +w_st_f_amt[j]+w_st_g_amt[j]+w_st_p_amt[j])%><br><%=Util.parseDecimal((w_st_s_amt[j]+w_st_d_amt[j]+w_st_c_amt[j]+w_st_e_amt[j] +w_st_f_amt[j]+w_st_g_amt[j]+w_st_p_amt[j])/wrow1)%></td>	      		
				           <% } %>	
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_sub_amt)%><br><%=Util.parseDecimal(w_st_sub_amt/wrow1)%></td>	 <!--  total -->     		
				        	 
				        	
				        	 <% for (int j = 1 ; j < 4 ; j++){  %>
				        		    <td class='title content_border'  style='text-align:right' ><%=Util.parseDecimal(w_st_s_amt[j])%><br><%=Util.parseDecimal(w_st_s_amt[j]/wrow1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_d_amt[j])%><br><%=Util.parseDecimal(w_st_d_amt[j]/wrow1)%></td>	
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_c_amt[j]+w_st_e_amt[j]+w_st_g_amt[j])%><br><%=Util.parseDecimal((w_st_c_amt[j]+w_st_e_amt[j]+w_st_g_amt[j])/wrow1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_f_amt[j])%><br><%=Util.parseDecimal(w_st_f_amt[j]/wrow1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_p_amt[j])%><br><%=Util.parseDecimal(w_st_p_amt[j]/wrow1)%></td>
				        		    <td class='title content_border'  style='text-align:right' ><%=Util.parseDecimal(w_st_s_amt[j]+w_st_d_amt[j]+w_st_c_amt[j]+w_st_e_amt[j] +w_st_f_amt[j]+w_st_g_amt[j]+w_st_p_amt[j])%><br><%=Util.parseDecimal((w_st_s_amt[j]+w_st_d_amt[j]+w_st_c_amt[j]+w_st_e_amt[j] +w_st_f_amt[j]+w_st_g_amt[j]+w_st_p_amt[j])/wrow1)%></td>	      		
				        	<% } %>	       
				        
				           <% for (int j = 4 ; j < 5 ; j++){  %>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_s_amt[j])%><br><%=Util.parseDecimal(w_st_s_amt[j]/wrow1)%></td>
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_d_amt[j])%><br><%=Util.parseDecimal(w_st_d_amt[j]/wrow1)%></td>        		 
				        		    <td class='title content_border'  style='text-align:right'><%=Util.parseDecimal(w_st_s_amt[j]+w_st_d_amt[j])%><br><%=Util.parseDecimal((w_st_s_amt[j]+w_st_d_amt[j])/wrow1)%></td>	      		
				        	<% } %>        	
					        	
							   </tr>
					  <%}%>       	      		 		        		
					<%  
							st_sub_amt = 0;      	
							w_st_sub_amt = 0;      	
							for (int j = 0 ; j < 5 ; j++){			  
								st_s_amt[j] = 0;  
								st_d_amt[j] = 0;  
								st_c_amt[j] = 0;  
								st_e_amt[j] = 0;  
								st_g_amt[j] = 0;
								st_f_amt[j] = 0;  
								st_p_amt[j] = 0; 
								w_st_s_amt[j] = 0;  
								w_st_d_amt[j] = 0;  
								w_st_c_amt[j] = 0;  
								w_st_e_amt[j] = 0;  
								w_st_g_amt[j] = 0;
								w_st_f_amt[j] = 0;  
								w_st_p_amt[j] = 0; 
							}  
					       
					    } 
						
					  t_loan_cnt = type_size1 + type_size2 +  type_size3 ;
					  w_cnt = w_type_size1 + w_type_size2 +  w_type_size3 ;
					%>
							
							   <!-- �հ� -->
							   	<tr> 		
						 <% for (int j = 0 ; j < 1 ; j++){  %>
				        		    <td class='title_p content_border'  style='text-align:right;height:44;' ><%=Util.parseDecimal(gt_s_amt[j])%><br><%=Util.parseDecimal(gt_s_amt[j]/t_loan_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right' ><%=Util.parseDecimal(gt_d_amt[j])%><br><%=Util.parseDecimal(gt_d_amt[j]/t_loan_cnt)%></td>	
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_c_amt[j]+gt_e_amt[j]+gt_g_amt[j])%><br><%=Util.parseDecimal((gt_c_amt[j]+gt_e_amt[j]+gt_g_amt[j])/t_loan_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_f_amt[j])%><br><%=Util.parseDecimal(gt_f_amt[j]/t_loan_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_p_amt[j])%><br><%=Util.parseDecimal(gt_p_amt[j]/t_loan_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right' ><%=Util.parseDecimal(gt_s_amt[j]+gt_d_amt[j]+gt_c_amt[j]+gt_e_amt[j] +gt_f_amt[j]+gt_g_amt[j]+gt_p_amt[j])%><br><%=Util.parseDecimal((gt_s_amt[j]+gt_d_amt[j]+gt_c_amt[j]+gt_e_amt[j] +gt_f_amt[j]+gt_g_amt[j]+gt_p_amt[j])/t_loan_cnt)%></td>	      		
				           <% } %>	
				        		    <td class='title_p content_border'   style='text-align:right'><%=Util.parseDecimal(gt_tot_amt)%><br><%=Util.parseDecimal(gt_tot_amt/t_loan_cnt)%></td>	 <!--  total -->     		
				        	 
				        	
				        	 <% for (int j = 1 ; j < 4 ; j++){  %>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_s_amt[j])%><br><%=Util.parseDecimal(gt_s_amt[j]/t_loan_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_d_amt[j])%><br><%=Util.parseDecimal(gt_d_amt[j]/t_loan_cnt)%></td>	
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_c_amt[j]+gt_e_amt[j]+gt_g_amt[j])%><br><%=Util.parseDecimal((gt_c_amt[j]+gt_e_amt[j]+gt_g_amt[j])/t_loan_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_f_amt[j])%><br><%=Util.parseDecimal(gt_f_amt[j]/t_loan_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_p_amt[j])%><br><%=Util.parseDecimal(gt_p_amt[j]/t_loan_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right' ><%=Util.parseDecimal(gt_s_amt[j]+gt_d_amt[j]+gt_c_amt[j]+gt_e_amt[j] +gt_f_amt[j]+gt_g_amt[j]+gt_p_amt[j])%><br><%=Util.parseDecimal((gt_s_amt[j]+gt_d_amt[j]+gt_c_amt[j]+gt_e_amt[j] +gt_f_amt[j]+gt_g_amt[j]+gt_p_amt[j])/t_loan_cnt)%></td>	 
				        	<% } %>	       
				        
				           <% for (int j = 4 ; j < 5 ; j++){  %>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_s_amt[j])%><br><%=Util.parseDecimal(gt_s_amt[j]/t_loan_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_d_amt[j])%><br><%=Util.parseDecimal(gt_d_amt[j]/t_loan_cnt)%></td>        		 
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(gt_s_amt[j]+gt_d_amt[j])%><br><%=Util.parseDecimal((gt_s_amt[j]+gt_d_amt[j])/t_loan_cnt)%></td>	      		
				        	<% } %>        	
							   </tr>
							   <tr> 
							 <!-- �Ұ� 1��̸� --> 
						 <% for (int j = 0 ; j < 1 ; j++){  %>
				        		    <td class='title_p content_border'  style='text-align:right;height:44;' ><%=Util.parseDecimal(w_gt_s_amt[j])%><br><%=Util.parseDecimal(w_gt_s_amt[j]/w_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right' ><%=Util.parseDecimal(w_gt_d_amt[j])%><br><%=Util.parseDecimal(w_gt_d_amt[j]/w_cnt)%></td>	
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_c_amt[j]+w_gt_e_amt[j]+w_gt_g_amt[j])%><br><%=Util.parseDecimal((w_gt_c_amt[j]+w_gt_e_amt[j]+w_gt_g_amt[j])/w_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_f_amt[j])%><br><%=Util.parseDecimal(w_gt_f_amt[j]/w_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_p_amt[j])%><br><%=Util.parseDecimal(w_gt_p_amt[j]/w_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right' ><%=Util.parseDecimal(w_gt_s_amt[j]+w_gt_d_amt[j]+w_gt_c_amt[j]+w_gt_e_amt[j]+w_gt_g_amt[j]+w_gt_f_amt[j]+w_gt_p_amt[j])%><br><%=Util.parseDecimal((w_gt_s_amt[j]+w_gt_d_amt[j]+w_gt_c_amt[j]+w_gt_e_amt[j]+w_gt_g_amt[j]+w_gt_f_amt[j]+w_gt_p_amt[j])/w_cnt)%></td>	      		
				           <% } %>	
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_tot_amt)%><br><%=Util.parseDecimal(w_gt_tot_amt/w_cnt)%></td>	 <!--  total -->     		
				        	 
				        	
				        	 <% for (int j = 1 ; j < 4 ; j++){  %>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_s_amt[j])%><br><%=Util.parseDecimal(w_gt_s_amt[j]/w_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_d_amt[j])%><br><%=Util.parseDecimal(w_gt_d_amt[j]/w_cnt)%></td>	
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_c_amt[j]+w_gt_e_amt[j]+w_gt_g_amt[j])%><br><%=Util.parseDecimal((w_gt_c_amt[j]+w_gt_e_amt[j]+w_gt_g_amt[j])/w_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_f_amt[j])%><br><%=Util.parseDecimal(w_gt_f_amt[j]/w_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_p_amt[j])%><br><%=Util.parseDecimal(w_gt_p_amt[j]/w_cnt)%></td>
				        		    <td class='title_p content_border'  style='text-align:right'><%=Util.parseDecimal(w_gt_s_amt[j]+w_gt_d_amt[j]+w_gt_c_amt[j]+w_gt_e_amt[j]+w_gt_g_amt[j]+w_gt_f_amt[j]+w_gt_p_amt[j])%><br><%=Util.parseDecimal((w_gt_s_amt[j]+w_gt_d_amt[j]+w_gt_c_amt[j]+w_gt_e_amt[j]+w_gt_g_amt[j]+w_gt_f_amt[j]+w_gt_p_amt[j])/w_cnt)%></td>	      		
				        	<% } %>	       
				        
				           <% for (int j = 4 ; j < 5 ; j++){  %>
				        		    <td class='title_p content_border'   style='text-align:right'><%=Util.parseDecimal(w_gt_s_amt[j])%><br><%=Util.parseDecimal(w_gt_s_amt[j]/w_cnt)%></td>
				        		    <td class='title_p content_border'   style='text-align:right'><%=Util.parseDecimal(w_gt_d_amt[j])%><br><%=Util.parseDecimal(w_gt_d_amt[j]/w_cnt)%></td>        		 
				        		    <td class='title_p content_border'   style='text-align:right'><%=Util.parseDecimal(w_gt_s_amt[j]+w_gt_d_amt[j])%><br><%=Util.parseDecimal((w_gt_s_amt[j]+w_gt_d_amt[j])/w_cnt)%></td>	      		
				        	<% } %>       	   	
					        	
							   </tr>
						 
					<%	}else{	%>    
							<tr>
								    <td width="2684" colspan="32" class='center content_border'>&nbsp;��ϵ� ����Ÿ�� �����ϴ�</td>
							 </tr>	              
									    
					   <%}	%>
				   	   </table>
				   	</div>
			 	 </td>
 			</tr>
		</table>
	</div>
</div>

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun1' value=>
<input type='hidden' name='ba_amt' value=>
<input type='hidden' name='ba1_amt' value=>
</form>
</body>
</html>
