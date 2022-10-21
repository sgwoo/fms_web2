<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"5":request.getParameter("gubun");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	AssetDatabase a_db = AssetDatabase.getInstance();
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
			
	Vector buss1 = a_db.getAssetIncomList2(s_yy,gubun2);
	int bus_size1 = buss1.size();
	
	int car_type_cnt = 0;
	int car_type_size1 = 0;
	int car_type_size2 = 0;
	int car_type_size3 = 0;
	int car_type_size4 = 0;
	int car_type_size5 = 0;
	
	int row1 = 0;
	
	String type_nm1 = "";
	String d_nm1 = "";
	String gubun1 = "";
			
	int sub_cnt[]	 	= new int[14];
	long sub_amt[]	 	= new long[14];
	
	int gtt_cnt[]	 	= new int[14];
	long gtt_amt[]	 	= new long[14];
	
	int r_cnt[]	 	= new int[14];
	long r_amt[]	 	= new long[14];
	
	int ltt_cnt[]	 	= new int[14];
	long ltt_amt[]	 	= new long[14];
	
	int rtt_cnt[]	 	= new int[14];
	long rtt_amt[]	 	= new long[14];
	
	//경매장별 	
	int a1_cnt[]	 	= new int[14];
	long a1_amt[]	 	= new long[14];	
	int a2_cnt[]	 	= new int[14];
	long a2_amt[]	 	= new long[14];
	int a3_cnt[]	 	= new int[14];
	long a3_amt[]	 	= new long[14];
	int a4_cnt[]	 	= new int[14];
	long a4_amt[]	 	= new long[14];
	int a5_cnt[]	 	= new int[14];
	long a5_amt[]	 	= new long[14];
	int a6_cnt[]	 	= new int[14];
	long a6_amt[]	 	= new long[14];
		
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

	//해지현황 리스트 이동
	function view_actn(s_yy)
	{
		var fm = document.form1;
		var url = "";
		fm.s_yy.value = s_yy;	
					
		url = "/fms2/stat_month/stat_cls_mng_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
				
//-->
</script>

</head>

<body>
<form  name="form1"  id="form1"   method="POST">
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
							 	<td class='title title_border' rowspan=2 with=160>구분</td>             
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">		
						  <colgroup>
			                <%for (int j = 1 ; j <= 12 ; j++){%>
			       			<col width="80">
			       			<col width="100">
			       			<col width="90">
			       		 <%}%>
			       			<col width="80">		       			
			       			<col width="100">		       			
			       			<col width="90">		       			
			       		</colgroup>
					       		
				     	<tr align="center">                             
						<%for (int j = 1 ; j <=12; j++){%>
			                 <td class='title title_border' colspan=3 width="270"><%=j%>월</td>
						<%}%>
						 	 <td class='title title_border' colspan=3 width="310" >합계</td>
			             </tr>
			              <tr align="center">                             
							<%for (int j = 1 ; j <= 12 ; j++){%>
					            <td class='title title_border' width="80">대수</td>
						        <td class='title title_border' width="100">손익</td>
						        <td class='title title_border' width="90">대당손익</td>      		                
							<%}%>
								<td class='title title_border' width="80">대수</td>
						     	<td class='title title_border' width="100">손익</td>
						     	<td class='title title_border' width="90">대당손익</td>    
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
					          	type_nm1 = "경매<br>리스";
					          	row1=car_type_size1;   
					          	gubun1 = "1";
					          }else if ( k== 1) {
					          	type_nm1 = "경매<br>렌트<br>LPG";
					          	row1=car_type_size5; 
					        	gubun1 = "5";
					          } else if ( k== 2) {
					          	type_nm1 = "경매<br>렌트<br>비LPG";
					          	row1=car_type_size2; 
					        	gubun1 = "2";	        
					          } else if ( k== 3) {
						       	type_nm1 = "기타<br>리스";
						       	row1=car_type_size3; 
						      	gubun1 = "3";
						      } else {
						       	type_nm1 = "기타<br>렌트";
						       	row1=car_type_size4; 
						       	gubun1 = "4";  	
						     }                
					                    
				         	for (int i = 0 ; i < bus_size1 ; i++){
								Hashtable ht = (Hashtable)buss1.elementAt(i);
								
								if(String.valueOf(ht.get("GUBUN")).equals(gubun1)) {
									
									if(String.valueOf(ht.get("ACTN_ID")).equals("000502")){				d_nm1 = "글로비스시화";	
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("013011")){		d_nm1 = "글로비스분당";	
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("061796")){		d_nm1 = "글로비스양산";
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("003226")){		d_nm1 = "매각서울오토";		
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("011723")){		d_nm1 = "매각서울자동차경매";		
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("013222")){		d_nm1 = "매각동화엠파크";
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("020385")){		d_nm1 = "에이제이셀카";
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("022846")){		d_nm1 = "롯데(동화)"; //매각롯데렌탈	
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("048691")){		d_nm1 = "Kcar "; //Kcar 
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("000000")){		d_nm1 = "매입옵션";						
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("111111")){		d_nm1 = "수의/폐차";						
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("999999")){		d_nm1 = "폐차";	
									}			            	
							%>	
						  <tr>
				            <%if(car_type_cnt==0){%>
				            <td class="center content_border " width='60' rowspan='<%=row1%>'><%=type_nm1 %></td>
				            <%}%>		    
				            <td class="left content_border" width="100" height="20">&nbsp;<%=d_nm1%></td>          
				          </tr>          
				           <%	car_type_cnt++;}} %>	
							<%if(row1>0){%>
						   <tr> 
						      <td class="title content_border center" colspan=2  height="20">소합계</td>           
						   </tr>
				        	<%}%>        	
				       <%  }  %>    
				           
				           <tr> 
				            <td class="title_p content_border center" colspan=2  height="20">리스합계</td>
				          
				          </tr>
				            <tr> 
				            <td class="title_p content_border center"  colspan=2  height="20">렌트합계</td>
				          
				          </tr>          
				                 
				          <tr> 
				            <td class="title_p content_border center"  colspan=2  height="20">총합계</td>          
				          </tr>
				          
				          <tr>        
				            <td class="center content_border" width='60' rowspan='7' > 경매</td>        	    
				            <td class="left content_border" width="100" height="20">&nbsp;글로비스시화</td>          
				          </tr>   
				           <tr>    
				            <td class="left content_border" width="100" height="20">&nbsp;글로비스분당</td>          
				          </tr>  
				           <tr>    
				            <td class="left content_border" width="100" height="20">&nbsp;글로비스양산</td>          
				          </tr>   
				            <tr>   
				            <td class="left content_border" width="100" height="20">&nbsp;에이제이셀카</td>          
				          </tr>   
				          <tr>    
				            <td class="left content_border" width="100" height="20">&nbsp;롯데(동화)</td>          
				          </tr>  
				          <tr>    
				            <td class="left content_border" width="100" height="20">&nbsp;Kcar</td>          
				          </tr> 
				          <tr>   	    
				            <td class="title content_border" width="100" height="20">&nbsp; 계</td>          
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
														
									for (int j = 1 ; j <= 12 ; j++){
										
										gtt_cnt[j] = gtt_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
										gtt_amt[j] = gtt_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										
										gtt_cnt[13] = gtt_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
										gtt_amt[13] = gtt_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										  									 										    
									    sub_cnt[j] = sub_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j)))); //sub_total
									    sub_amt[j] = sub_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									    
									    sub_cnt[13] = sub_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j)))); //sub_total
									    sub_amt[13] = sub_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									  									  									    
									    r_cnt[j] = AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
									    r_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									    
									    r_cnt[13] = r_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));
									    r_amt[13] = r_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
									    
								  	}		
								
						  %>			
				          <tr>
				           <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td class="right content_border" height="20" width="80"><%=Util.parseDecimal(r_cnt[j])%></td>
				            <td class="right content_border" height="20" width="100"><%=Util.parseDecimal(r_amt[j])%></td>
				            <td class="right content_border" height="20" width="90"><% if ( r_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(r_amt[j]/r_cnt[j])%><% } %></td>
				        	<% } %>       
				
				          </tr>
				          
				          <%	
				         		 r_cnt[13] = 0;
				        		 r_amt[13] = 0;
				          										
								//리스계
								   if ( k==0 || k== 3 ) {
										for (int j = 1 ; j <= 12 ; j++){
											
											ltt_cnt[j] = ltt_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
											ltt_amt[j] = ltt_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										
											ltt_cnt[13] = ltt_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  
											ltt_amt[13] = ltt_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
											
										}
									
								   } else {
									   for (int j = 1 ; j <= 12 ; j++){
											
											rtt_cnt[j] = rtt_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
											rtt_amt[j] = rtt_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
											
											rtt_cnt[13] = rtt_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  
											rtt_amt[13] = rtt_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										
										}					   
									
								   }
										
									if(String.valueOf(ht.get("ACTN_ID")).equals("000502")){	  // d_nm1 = "글로비스시화";	
									  for (int j = 1 ; j <= 12 ; j++){
												
											a1_cnt[j] = a1_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
											a1_amt[j] = a1_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
											
											a1_cnt[13] = a1_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));   
											a1_amt[13] = a1_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										}		
																							
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("013011")){	//	d_nm1 = "글로비스분당";		
										 for (int j = 1 ; j <= 12 ; j++){
												
												a2_cnt[j] = a2_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
												a2_amt[j] = a2_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
												
												a2_cnt[13] = a2_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));   
												a2_amt[13] = a2_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										 }		
									
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("061796")){	//	d_nm1 = "글로비스양산";		
										 for (int j = 1 ; j <= 12 ; j++){
												
												a3_cnt[j] = a3_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
												a3_amt[j] = a3_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
												
												a3_cnt[13] = a3_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));   
												a3_amt[13] = a3_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										 }		
										 
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("020385")){	//	d_nm1 = "에이제이셀카";
										 for (int j = 1 ; j <= 12 ; j++){
												
												a4_cnt[j] = a4_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
												a4_amt[j] = a4_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
												
												a4_cnt[13] = a4_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));   
												a4_amt[13] = a4_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										 }			
									
									
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("022846")){	//	d_nm1 = "롯데(동화)"; //매각롯데렌탈	
										 for (int j = 1 ; j <= 12 ; j++){
												
												a5_cnt[j] = a5_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
												a5_amt[j] = a5_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
												
												a5_cnt[13] = a5_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));   
												a5_amt[13] = a5_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										 }	
									
									}else if(String.valueOf(ht.get("ACTN_ID")).equals("048691")){	//	d_nm1 = "Kcar"; //매각Kcar	
										 for (int j = 1 ; j <= 12 ; j++){
												
												a6_cnt[j] = a6_cnt[j] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));  //grand total
												a6_amt[j] = a6_amt[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
												
												a6_cnt[13] = a6_cnt[13] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+(j))));   
												a6_amt[13] = a6_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  
										 }	
									}
									
							} } %>
						<%if(row1 >0){%>
				          <tr> 
				            <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td  class="title content_border right" height="20" width="80"><%=Util.parseDecimal(sub_cnt[j])%></td>
				            <td  class="title content_border right" height="20" width="100"><%=Util.parseDecimal(sub_amt[j])%></td>
				            <td  class="title content_border right" height="20" width="90"><% if ( sub_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(sub_amt[j]/sub_cnt[j])%><% } %></td>
				        	<% } %>  
				          </tr>    
				          
				         <%}%> 
				        <%
				         
								for (int j = 1 ; j <= 13 ; j++){
								    sub_cnt[j] = 0;  //sub total
								    sub_amt[j] = 0;  
								}  
				           
						  %>	
				                	
				      <% } %>   
				            
				       <!--리스 -->   
				           <tr> 
				           <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td  class="title_p content_border right" height="20" width="80"><%=Util.parseDecimal(ltt_cnt[j])%></td>
				            <td  class="title_p content_border right" height="20" width="100"><%=Util.parseDecimal(ltt_amt[j])%></td>
				            <td  class="title_p content_border right" height="20" width="90"><% if ( ltt_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(ltt_amt[j]/ltt_cnt[j])%><% } %></td>
				        	<% } %>  				
				          </tr>
				          <!-- 렌트 -->
				          <tr> 
				           <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td  class="title_p content_border right" height="20" width="80"><%=Util.parseDecimal(rtt_cnt[j])%></td>
				            <td  class="title_p content_border right" height="20" width="100"><%=Util.parseDecimal(rtt_amt[j])%></td>
				            <td  class="title_p content_border right" height="20" width="90"><% if ( rtt_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(rtt_amt[j]/rtt_cnt[j])%><% } %></td>
				        	<% } %> 
				          </tr>   
				          
				          <tr> 
				           <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td  class="title_p content_border right" height="20" width="80"><%=Util.parseDecimal(gtt_cnt[j])%></td>
				            <td  class="title_p content_border right" height="20" width="100"><%=Util.parseDecimal(gtt_amt[j])%></td>
				            <td  class="title_p content_border right" height="20" width="90"><% if ( gtt_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(gtt_amt[j]/gtt_cnt[j])%><% } %></td>
				        	<% } %>   																														
				          </tr>
				          
				    <!--  경매장계 -->    							 
				          <tr> 
				            <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td  class="content_border right" height="20" width="80"><%=Util.parseDecimal(a1_cnt[j])%></td>
				            <td  class="content_border right" height="20" width="100"><%=Util.parseDecimal(a1_amt[j])%></td>
				            <td  class="content_border right" height="20" width="90"><% if ( a1_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a1_amt[j]/a1_cnt[j])%><% } %></td>
				        	<% } %> 
				 																											
				          </tr>
				           <tr> 
				            <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td  class="content_border right" height="20" width="80"><%=Util.parseDecimal(a2_cnt[j])%></td>
				            <td  class="content_border right" height="20" width="100"><%=Util.parseDecimal(a2_amt[j])%></td>
				            <td  class="content_border right" height="20" width="90"><% if ( a2_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a2_amt[j]/a2_cnt[j])%><% } %></td>
				        	<% } %>   
																														
				          </tr>
				           <tr> 
				            <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td   class="content_border right" height="20" width="80"><%=Util.parseDecimal(a3_cnt[j])%></td>
				            <td   class="content_border right" height="20" width="100"><%=Util.parseDecimal(a3_amt[j])%></td>
				            <td   class="content_border right" height="20" width="90"><% if ( a3_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a3_amt[j]/a3_cnt[j])%><% } %></td>
				        	<% } %>  																					
				          </tr>
				           <tr> 
				            <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td  class="content_border right" height="20" width="80"><%=Util.parseDecimal(a4_cnt[j])%></td>
				            <td  class="content_border right" height="20" width="100"><%=Util.parseDecimal(a4_amt[j])%></td>
				            <td  class="content_border right" height="20" width="90"><% if ( a4_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a4_amt[j]/a4_cnt[j])%><% } %></td>
				        	<% } %>   															
				          </tr>
				          <tr> 
				            <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td   class="content_border right" height="20" width="80"><%=Util.parseDecimal(a5_cnt[j])%></td>
				            <td   class="content_border right" height="20" width="100"><%=Util.parseDecimal(a5_amt[j])%></td>
				            <td   class="content_border right" height="20" width="90"><% if ( a5_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a5_amt[j]/a5_cnt[j])%><% } %></td>
				        	<% } %>  
				   		 </tr>
				          <tr> 
				            <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td   class="content_border right" height="20" width="80"><%=Util.parseDecimal(a6_cnt[j])%></td>
				            <td   class="content_border right" height="20" width="100"><%=Util.parseDecimal(a6_amt[j])%></td>
				            <td   class="content_border right" height="20" width="90"><% if ( a6_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(a6_amt[j]/a6_cnt[j])%><% } %></td>
				        	<% } %>  
				 		  </tr>
				          
				<!-- 경매장 총계 -->
				          <tr> 
				           <%for (int j = 1 ; j <= 13 ; j++){%> 
				            <td  class="title content_border right" height="20" width="80"><%=Util.parseDecimal(a1_cnt[j]+a2_cnt[j]+a3_cnt[j]+a4_cnt[j]+a5_cnt[j]+a6_cnt[j])%></td>
				            <td  class="title content_border right" height="20" width="100"><%=Util.parseDecimal(a1_amt[j]+a2_amt[j]+a3_amt[j]+a4_amt[j]+a5_amt[j]+a6_amt[j])%></td>
				            <td  class="title content_border right" height="20" width="90"><% if ( a1_cnt[j]+a2_cnt[j]+a3_cnt[j]+a4_cnt[j]+a5_cnt[j]+a6_cnt[j] == 0 ) {%>0<%} else {%><%=Util.parseDecimal((a1_amt[j]+a2_amt[j]+a3_amt[j]+a4_amt[j]+a5_amt[j]+a6_amt[j])/(a1_cnt[j]+a2_cnt[j]+a3_cnt[j]+a4_cnt[j]+a5_cnt[j]+a6_cnt[j]))%><% } %></td>
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
<font size=2> </font>
</body>
</html>
