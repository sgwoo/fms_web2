<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"5":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
	
	int s_year 	= 2018;	 //��� �� ����
	int s_year_m 	= s_year - 1;	 //��� �� ����;
	int e_year 	= 2022;	 //��� �� ���� 

	int years 	= AddUtil.getDate2(1)-s_year+5;
		
	Vector buss1 = as_db.getAssetIncomList2(gubun2, s_year , e_year);
	int bus_size1 = buss1.size();
		
	int car_type_cnt = 0;
	int car_type_size1 = 0;
	int car_type_size2 = 0;
	int car_type_size3 = 0;
	int car_type_size4 = 0;
	int car_type_size5 = 0;
		
	int row1 = 0;
					
	int sub_cnt[]	 	= new int[7];
	long sub_amt[]	 	= new long[7];
	
	int gtt_cnt[]	 	= new int[7];
	long gtt_amt[]	 	= new long[7];
	
	int r_cnt[]	 		= new int[7];
	long r_amt[]	 	= new long[7];
	
	int ltt_cnt[]	 	= new int[7];
	long ltt_amt[]	 	= new long[7];
	
	int rtt_cnt[]	 	= new int[7];
	long rtt_amt[]	 	= new long[7];
	
	//����庰 		
	int a1_cnt[]	 	= new int[7];
	long a1_amt[]	 	= new long[7];	
	int a2_cnt[]	 	= new int[7];
	long a2_amt[]	 	= new long[7];
	int a3_cnt[]	 	= new int[7];
	long a3_amt[]	 	= new long[7];
	int a4_cnt[]	 	= new int[7];
	long a4_amt[]	 	= new long[7];
	int a5_cnt[]	 	= new int[7];
	long a5_amt[]	 	= new long[7];
	int a6_cnt[]	 	= new int[7];
	long a6_amt[]	 	= new long[7];
	
	String type_nm1 = "";
	String d_nm1 = "";
	String gubun1 = "";
		
	for(int i = 0 ; i < bus_size1 ; i++){
		Hashtable ht = (Hashtable)buss1.elementAt(i);
		if(String.valueOf(ht.get("GUBUN")).equals("1")) car_type_size1++;
		if(String.valueOf(ht.get("GUBUN")).equals("2")) car_type_size2++;	
		if(String.valueOf(ht.get("GUBUN")).equals("3")) car_type_size3++;
		if(String.valueOf(ht.get("GUBUN")).equals("4")) car_type_size4++;		
		if(String.valueOf(ht.get("GUBUN")).equals("5")) car_type_size5++;		
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

<script language='javascript'>
<!--

	//������Ȳ ����Ʈ �̵�
	function view_actn(s_yy)
	{
		var fm = document.form1;
		var url = "";
		fm.s_yy.value = s_yy;	
					
		url = "/fms2/asset/stat_asset1.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
				
//-->
</script>
</head>

<body>
<form  name="form1"  id="form1"  method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='bus_size1' value='<%=bus_size1%>'>
<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 160px;">
					<div style="width: 160px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							 	<td class='title title_border' rowspan=2 with=160>����</td>             
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">		
						   <colgroup>
			                 <%for (int j = s_year ; j <= e_year ; j++){%>
				       			<col width="80">
				       			<col width="100">
				       			<col width="90">
				       		 <%}%>
				       			<col width="80">		       			
				       			<col width="100">		       			
				       			<col width="90">		       			
				       		</colgroup>
				       		 
			          	    <tr align="center">                             
								<%for (int j = s_year ; j <= e_year; j++){%>
					              <td class='title title_border' colspan=3 width="270"><a href="javascript:view_actn('<%=j%>')"><%=j%>��</a></td>
								<%}%>
								  <td class='title title_border' colspan=3 width="310">�հ�</td>
					        </tr>
					        <tr align="center">                             
								<%for (int j = s_year ; j <= e_year ; j++){%>
						         <td class='title title_border' width="80">���</td>
							     <td class='title title_border' width="100">����</td>
							     <td class='title title_border' width="90">������</td>      		                
								<%}%>
								 <td class='title title_border' width="80">���</td>
							     <td class='title title_border' width="100">����</td>
							     <td class='title title_border' width="90">������</td>    
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
				<td style="width: 160px;">
					<div style="width: 160px;">
						<table class="inner_top_table left_fix"> 
					      <% for(int k = 0 ; k < 5 ; k++){ %>	
							   
					         <%	car_type_cnt = 0;                
					          if ( k == 0 )  { 
					          	type_nm1 = "���<br>����";
					          	row1=car_type_size1;   
					          	gubun1 = "1";
					          }else if ( k== 1) {
					          	type_nm1 = "���<br>��Ʈ<br>LPG";
					          	row1=car_type_size5; 
					        	gubun1 = "5";
					          } else if ( k== 2) {
					          	type_nm1 = "���<br>��Ʈ<br>��LPG";
					          	row1=car_type_size2; 
					        	gubun1 = "2";	        
					          } else if ( k== 3) {
						       	type_nm1 = "��Ÿ<br>����";
						       	row1=car_type_size3; 
						      	gubun1 = "3";
						      } else {
						       	type_nm1 = "��Ÿ<br>��Ʈ";
						       	row1=car_type_size4; 
						       	gubun1 = "4";  	
						     }                
					               
			         		for (int i = 0 ; i < bus_size1 ; i++){
							Hashtable ht = (Hashtable)buss1.elementAt(i);
											
							if(String.valueOf(ht.get("GUBUN")).equals(gubun1)) {
													
								if(String.valueOf(ht.get("ACTN_ID")).equals("000502")){				d_nm1 = "�۷κ񽺽�ȭ";	
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("013011")){		d_nm1 = "�۷κ񽺺д�";	
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("061796")){		d_nm1 = "�۷κ񽺾��";
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("003226")){		d_nm1 = "�Ű��������";		
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("011723")){		d_nm1 = "�Ű������ڵ������";		
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("013222")){		d_nm1 = "�Ű���ȭ����ũ";
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("020385")){		d_nm1 = "�������̼�ī";
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("022846")){		d_nm1 = "�Ե�(��ȭ)"; //�Ű��Ե���Ż	
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("048691")){		d_nm1 = "Kcar"; //�Ű��Ե���Ż	
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("000000")){			d_nm1 = "���Կɼ�";						
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("111111")){	d_nm1 = "����/����";						
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("999999")){	d_nm1 = "����";	
								}			            	
											            	
					          %> 		      			
					         <tr>
					           <%if(car_type_cnt==0){%>
					           <td class="center content_border" width='60' rowspan='<%=row1%>'><%=type_nm1 %></td>
					           <%}%>		    
					           <td class="left content_border" width="100" height="20">&nbsp;<%=d_nm1%></td>          
					         </tr>          
					          <%	car_type_cnt++;}} %>	
							<%if(row1>0){%>
						   <tr> 
						      <td class="title content_border center" colspan=2 >���հ�</td>           
						   </tr>
					       	<%}%>        	
					      <%  }  %>    
					            
					         <tr> 
					           <td class="title_p content_border center"  colspan=2 >�����հ�</td>          
					         </tr>    
					         <tr> 
					           <td class="title_p content_border center"  colspan=2  >��Ʈ�հ�</td>
					         </tr>            
					         <tr> 
					           <td class="title_p content_border center"  colspan=2  >���հ�</td>          
					         </tr>
					         
					         <tr>        
					           <td class="center content_border" width='60' rowspan='7' > ���</td>        	    
					           <td class="left content_border" width="100" >&nbsp;�۷κ񽺽�ȭ</td>          
					         </tr>   
					          <tr>    
					           <td class="left content_border" width="100" >&nbsp;�۷κ񽺺д�</td>          
					         </tr>  
					         <tr>    
					           <td class="left content_border" width="100" >&nbsp;�۷κ񽺾��</td>          
					         </tr>    
					           <tr>   
					           <td class="left content_border" width="100" >&nbsp;�������̼�ī</td>          
					         </tr>   
					           <tr>    
					           <td class="left content_border" width="100" ">&nbsp;�Ե�(��ȭ)</td>          
					         </tr>
					         <tr>    
					           <td class="left content_border" width="100" >&nbsp;Kcar</td>          
					         </tr>    
					          <tr>   	    
					           <td class="title content_border" width="100" >&nbsp; ��</td>          
					         </tr>   
					         
					      </table>        
				     </div>            
				 </td>   <!-- left -->   
	
   				 <td>	
   				    <div>
					  <table class="inner_top_table table_layout">	   
	
				<% for(int k = 0 ; k < 5 ; k++){ %>		
							   
				          <%	car_type_cnt = 0;  
				          
				         	  if ( k == 0 )  { 	          
					          	row1=car_type_size1;   
					          	gubun1 = "1";
					          }else if ( k== 1) {	         
					          	row1=car_type_size5; 
					        	gubun1 = "5";
					          } else if ( k== 2) {	          
					          	row1=car_type_size2; 
					        	gubun1 = "2";	        
					          } else if ( k== 3) {		     
						       	row1=car_type_size3; 
						      	gubun1 = "3";
						      } else {		      
						       	row1=car_type_size4; 
						       	gubun1 = "4";  	
						     }                       
					          
				         	  
					        for (int i = 0 ; i < bus_size1 ; i++){
								Hashtable ht = (Hashtable)buss1.elementAt(i);
								
								if(String.valueOf(ht.get("GUBUN")).equals(gubun1)) {					
									for (int j = 1 ; j <= 5 ; j++){
										
										gtt_cnt[j] = gtt_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
										gtt_amt[j] = gtt_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										  
										gtt_cnt[6] = gtt_cnt[6] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
										gtt_amt[6] = gtt_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
																													    
									    sub_cnt[j] = sub_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j)))); //sub_total
									    sub_amt[j] = sub_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									    
									    sub_cnt[6] = sub_cnt[6] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j)))); //sub_total
									    sub_amt[6] = sub_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									  																	    
									    r_cnt[j] = AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
									    r_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									    									  									    
									    r_cnt[6] = r_cnt[6] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
									    r_amt[6] = r_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									    
								  	}		
														
						  %>		
				          <tr>
				           <%for (int j = 1 ; j <= 6 ; j++){%> 
				            <td class="right content_border"  width="80"><%=Util.parseDecimal(r_cnt[j])%></td>
				            <td class="right content_border"  width="100"><%=Util.parseDecimal(r_amt[j])%></td>
				            <td class="right content_border"  width="90"><% if ( r_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(r_amt[j]/r_cnt[j])%><% } %></td>
				        	<% } %>       
				
				          </tr>
			           <%	
			         		  r_cnt[6] = 0;
			         		  r_amt[6] = 0;
			          										
							//������
							   if ( k==0 || k== 3 ) {
									for (int j = 1 ; j <= 5 ; j++){
										
										ltt_cnt[j] = ltt_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
										ltt_amt[j] = ltt_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									
										ltt_cnt[6] = ltt_cnt[6] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
										ltt_amt[6] = ltt_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									}
								
							   } else {
								   for (int j = 1 ; j <= 5 ; j++){
										
										rtt_cnt[j] = rtt_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
										rtt_amt[j] = rtt_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										
										rtt_cnt[6] = rtt_cnt[6] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
										rtt_amt[6] = rtt_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									}					   
								
							   }
								//����� 	
							   if(String.valueOf(ht.get("ACTN_ID")).equals("000502")){	  // d_nm1 = "�۷κ񽺽�ȭ";	
								  for (int j = 1 ; j <= 5 ; j++){
											
										a1_cnt[j] = a1_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
										a1_amt[j] = a1_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										
										a1_cnt[6] = a1_cnt[6]  + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
										a1_amt[6] = a1_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									}		
																						
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("013011")){	//	d_nm1 = "�۷κ񽺺д�";		
									 for (int j = 1 ; j <= 5 ; j++){
											
											a2_cnt[j] = a2_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
											a2_amt[j] = a2_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
											
											a2_cnt[6] = a2_cnt[6]  + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
											a2_amt[6] = a2_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									 }	
									 
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("061796")){	//	d_nm1 = "�۷κ񽺾��";		
									 for (int j = 1 ; j <= 5 ; j++){
											
											a3_cnt[j] = a3_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
											a3_amt[j] = a3_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
											
											a3_cnt[6] = a3_cnt[6]  + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
											a3_amt[6] = a3_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									 }		
									 
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("020385")){	//	d_nm1 = "�������̼�ī";
									 for (int j = 1 ; j <= 5 ; j++){
											
											a4_cnt[j] = a4_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
											a4_amt[j] = a4_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
											
											a4_cnt[6] = a4_cnt[6]  + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
											a4_amt[6] = a4_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									 }			
								
								
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("022846")){	//	d_nm1 = "�Ե�(��ȭ)"; //�Ű��Ե���Ż	
									 for (int j = 1 ; j <= 5 ; j++){
											
											a5_cnt[j] = a5_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
											a5_amt[j] = a5_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
											
											a5_cnt[6] = a5_cnt[6]  + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
											a5_amt[6] = a5_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									 }	
								
								}else if(String.valueOf(ht.get("ACTN_ID")).equals("048691")){	//	d_nm1 = "kcar"; //�Ű�kcar	
									 for (int j = 1 ; j <= 5 ; j++){
											
											a6_cnt[j] = a6_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
											a6_amt[j] = a6_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
											
											a6_cnt[6] = a6_cnt[6]  + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
											a6_amt[6] = a6_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									 }		
								}
								
						} } %>
						
						<%if(row1 >0){%>
					          <tr> 
					            <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td  class="title content_border right"  width="80"><%=Util.parseDecimal(sub_cnt[j])%></td>
					            <td  class="title content_border right"  width="100"><%=Util.parseDecimal(sub_amt[j])%></td>
					            <td  class="title content_border right"  width="90"><% if ( sub_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(sub_amt[j]/sub_cnt[j])%><% } %></td>
					        	<% } %>  
					
					          </tr>    
				        <%}%>         
				       <%
				         
								for (int j = 1 ; j <= 6 ; j++){
								    sub_cnt[j] = 0;  //sub total
								    sub_amt[j] = 0;  
								}  
				              						  %>	
				                	
				      <% } %>   
			  
					     <!--���� -->   
					           <tr> 
					           <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td  class="title_p content_border right"  width="80"><%=Util.parseDecimal(ltt_cnt[j])%></td>
					            <td  class="title_p content_border right"  width="100"><%=Util.parseDecimal(ltt_amt[j])%></td>
					            <td  class="title_p content_border right"  width="90"><% if ( ltt_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(ltt_amt[j]/ltt_cnt[j])%><% } %></td>
					        	<% } %>  
				
					          </tr>
					          <!-- ��Ʈ -->
					          <tr> 
					           <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td  class="title_p content_border right" width="80"><%=Util.parseDecimal(rtt_cnt[j])%></td>
					            <td  class="title_p content_border right" width="100"><%=Util.parseDecimal(rtt_amt[j])%></td>
					            <td  class="title_p content_border right" width="90"><% if ( rtt_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(rtt_amt[j]/rtt_cnt[j])%><% } %></td>
					        	<% } %> 
					          </tr>   
					<!-- ���հ� -->          
					          <tr> 
					           <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td  class="title_p content_border right" width="80"><%=Util.parseDecimal(gtt_cnt[j])%></td>
					            <td  class="title_p content_border right" width="100"><%=Util.parseDecimal(gtt_amt[j])%></td>
					            <td  class="title_p content_border right" width="90"><% if ( gtt_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(gtt_amt[j]/gtt_cnt[j])%><% } %></td>
					        	<% } %>       
					  																						
					          </tr>
					                    
					           <!--  ������ -->                      										
					 <!--  ������ -->    							 
					          <tr> 
					            <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td  class="content_border right"  width="80"><%=Util.parseDecimal(a1_cnt[j])%></td>
					            <td  class="content_border right" width="100"><%=Util.parseDecimal(a1_amt[j])%></td>
					            <td  class="content_border right" width="90"><% if ( a1_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a1_amt[j]/a1_cnt[j])%><% } %></td>
					        	<% } %>   																					
					          </tr>
					          
					           <tr> 
					            <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td  class="content_border right"  width="80"><%=Util.parseDecimal(a2_cnt[j])%></td>
					            <td  class="content_border right"  width="100"><%=Util.parseDecimal(a2_amt[j])%></td>
					            <td  class="content_border right" width="90"><% if ( a2_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a2_amt[j]/a2_cnt[j])%><% } %></td>
					        	<% } %> 																				
					          </tr>
					        
					           <tr> 
					            <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td   class="content_border right"  width="80"><%=Util.parseDecimal(a3_cnt[j])%></td>
					            <td   class="content_border right" width="100"><%=Util.parseDecimal(a3_amt[j])%></td>
					            <td   class="content_border right"  width="90"><% if ( a3_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a3_amt[j]/a3_cnt[j])%><% } %></td>
					        	<% } %> 
																															
					          </tr>					          
					           <tr> 
					            <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td    class="content_border right"  width="80"><%=Util.parseDecimal(a4_cnt[j])%></td>
					            <td    class="content_border right"  width="100"><%=Util.parseDecimal(a4_amt[j])%></td>
					            <td    class="content_border right"  width="90"><% if ( a4_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a4_amt[j]/a4_cnt[j])%><% } %></td>
					        	<% } %>      
					  																				
					          </tr>
					          <tr> 
					            <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td    class="content_border right"  width="80"><%=Util.parseDecimal(a5_cnt[j])%></td>
					            <td    class="content_border right"  width="100"><%=Util.parseDecimal(a5_amt[j])%></td>
					            <td    class="content_border right"  width="90"><% if ( a5_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a5_amt[j]/a5_cnt[j])%><% } %></td>
					        	<% } %>   
					          </tr>
					          <tr> 
					            <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td    class="content_border right"  width="80"><%=Util.parseDecimal(a6_cnt[j])%></td>
					            <td    class="content_border right"  width="100"><%=Util.parseDecimal(a6_amt[j])%></td>
					            <td    class="content_border right"  width="90"><% if ( a6_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a6_amt[j]/a6_cnt[j])%><% } %></td>
					        	<% } %>   
					          </tr>
					<!-- ����� �Ѱ� -->
					          <tr> 
					           <%for (int j = 1 ; j <= 6 ; j++){%> 
					            <td  class="title content_border right"  width="80"><%=Util.parseDecimal(a1_cnt[j]+a2_cnt[j]+a3_cnt[j]+a4_cnt[j]+a5_cnt[j]+a6_cnt[j])%></td>
					            <td  class="title content_border right"  width="100"><%=Util.parseDecimal(a1_amt[j]+a2_amt[j]+a3_amt[j]+a4_amt[j]+a5_amt[j]+a6_amt[j])%></td>
					            <td  class="title content_border right"  width="90"><% if ( a1_cnt[j]+a2_cnt[j]+a3_cnt[j]+a4_cnt[j]+a5_cnt[j]+a6_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal((a1_amt[j]+a2_amt[j]+a3_amt[j]+a4_amt[j]+a5_amt[j]+a6_amt[j])/(a1_cnt[j]+a2_cnt[j]+a3_cnt[j]+a4_cnt[j]+a5_cnt[j]+a6_cnt[j]))%><% } %></td>
					        	<% } %>   																						
					          </tr>
			          
			      		  </table>
				 	  </div>
				   </td>
			</tr>
	   </table>
	</div>
</div>
</form>

<script language='javascript'>
<!--
//-->
</script>

</body>
</html>
