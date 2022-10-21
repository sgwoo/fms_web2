<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	
	Vector cost = t_db.getCostCarList(st_year);
	int c_size = cost.size();

	int s_amt = 0;
	int o_amt = 0;
	
	int t_amt1 = 0;
	int t_amt2 = 0;
	int t_amt3 = 0;
	int t_amt4 = 0;
	int t_amt5 = 0;
	int t_amt6 = 0;
	int t_amt7 = 0;
	int t_amt8 = 0;
	int t_amt9 = 0;
	int t_amt10 = 0;
	
	
	int s_amt1 = 0;
	int s_amt2 = 0;
	int s_amt3 = 0;
	int s_amt4 = 0;
	int s_amt5 = 0;
	int s_amt6 = 0;
	int s_amt7 = 0;
	int s_amt8 = 0;
	int s_amt9 = 0;
	int s_amt10 = 0;
	
	String chk_id = "";
	String chk_nm = "";
	
	int aa = 0;
	float bb= 0;
	float cc= 0;
	
	float fs_amt11 = 0;	
	int s_amt11 = 0;
	int t_amt11 = 0;

	int s_amt21 = 0;
	int s_amt22 = 0;
	int s_amt24 = 0;
	int s_amt25 = 0;
	
	int t_amt21 = 0;
	int t_amt22 = 0;
	int t_amt23 = 0;
	int t_amt24 = 0;
	int t_amt25 = 0;
	int t_amt27 = 0;
	int t_amt29 = 0;
	
	float fs_amt21 = 0;
	float fs_amt22 = 0;
	
	int cost_amt = 10000000;
	int asset_amt = 8000000;
		   	
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

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 540px;">
					<div style="width: 540px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>										        		
			        		    <td class='title title_border' width="11%" style='height:60'>사용자</td>
					            <td class='title title_border' width="12%" >차량번호</td>
							    <td  class='title title_border'  width="32%">차종</td>
							    <td  class='title title_border'  width="11%">임차<br>여부</td>
							    <td class='title title_border'  width="11%">보험가입<br>여부</td>
							    <td  class='title title_border'  width="11%">총주행<br>거리</td>
							    <td  class='title title_border'  width="12%">업무용<br>사용거리</td>								
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							<colgroup>		       		
				       		  <col  width='60'> <!--  rowspan -->
				       			       		
							  <col  width='80'>
							  <col  width='100'> 
							  <col  width='100'> 
							  <col  width='90'>
							  <col  width='80'>
							  <col  width='80'>
							  <col  width='90'>
							  <col  width='90'>
							  <col  width='90'>
							  
							  <col  width='90'>
							  <col  width='90'>
							  <col  width='90'>
							  
							  <col  width='90'>
							  <col  width='90'>
							  <col  width='90'>
											
							  <col  width='90'> <!--  rowspan -->
							  <col  width='90'> <!--  rowspan -->
							  <col  width='90'> <!--  rowspan -->
							  
				       		</colgroup>
				       		<tr>
							    <td  rowspan=2 class='title title_border'  width="60">업무<br>사용비율</td>
							    <td  colspan=9 class='title title_border'  style='height:25'>업무용승용차관련비용</td>
							    <td  colspan=3 class='title title_border'  style='height:25'>업무사용금액</td>
							    <td  colspan=3 class='title title_border'  style='height:25'>업무외사용금액</td>
							    <td rowspan="2" class='title title_border' width='90'>감가상각비<br>(상당액)<br>한도초과금액</td>
							    <td rowspan="2" class='title title_border' width='90'>손금불산입<br>합계</td>
							    <td rowspan="2" class='title title_border' width='90'>손금산입<br>합계</td>
							</tr>
			        		<tr>		
							  	  <td class='title title_border' width='80'  style='height:25'>감가상각비</td>
								  <td class='title title_border' width='100'>본인부담대여료<br>대여원가</td> 
								  <td class='title title_border' width='100'>회사지원대여료<br>감가상각상당액</td> 
								  <td class='title title_border' width='90'>유류비</td>
								  <td class='title title_border' width='80'>보험료</td>
								  <td class='title title_border' width='80'>수선비</td>
								  <td class='title title_border' width='90'>자동차세</td>
								  <td class='title title_border' width='90'>기타</td>
								  <td class='title title_border' width='90'>합계</td>
								  
								  <td class='title title_border' width='90'  style='height:25'>감가상각비<br>(상당액)</td>
								  <td class='title title_border' width='90'>관련비용</td>
								  <td class='title title_border' width='90'>합계</td>
								  <td class='title title_border' width='90'  style='height:25'>감가상각비<br>(상당액)</td>
								  <td class='title title_border' width='90'>관련비용</td>
								  <td class='title title_border' width='90'>합계</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb" >
			<tr> 
				<td style="width: 540px;">
					<div style="width: 540px;">
						<table class="inner_top_table left_fix">
						<%if(c_size > 0){%>
				          <%	for(int i = 0 ; i <c_size ; i++){
								Hashtable ht = (Hashtable)cost.elementAt(i); 						
							%>   
				 			  <tr style="height: 50px;">
			        		     <td class='center content_border'  width="11%" style='height:45'><%=ht.get("USER_NM")%></td>
			       		         <td class='center content_border'  width="12%" ><%=ht.get("CAR_NO")%></td>
				                 <td class='center content_border'  width="32%"><%=ht.get("CAR_NM")%></td>
				                 <td class='center content_border'  width="11%"><%=ht.get("CAR_USE")%></td>
				                 <td class='center content_border'  width="11%"><%=ht.get("INSUR_YN")%></td>
				                 <td class='right content_border'  width="11%"><%=Util.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%></td>
				                 <td class='right content_border'  width="12%">0</td>            
				        	</tr>
					<%      } %>
				         	<tr>              
				        		 <td class="title center content_border"  colspan=7  style='height:50'>합계</td>                    
				            </tr>			
				    <%} else  {%>  
					        <tr>
							     <td class='center content_border'>등록된 데이타가 없습니다</td>
							</tr>	              
					 <%}	%>
				        </table>
				     </div>
				 </td>					
				  
				 <td>
				    <div>
					   <table class="inner_top_table table_layout">	
			<%if(c_size > 0){%>   
			     	<%	for(int i = 0 ; i <c_size ; i++){
							Hashtable ht = (Hashtable) cost.elementAt(i);					
							
							s_amt = AddUtil.parseInt(String.valueOf(ht.get("A_FEE_AMT")))  + AddUtil.parseInt(String.valueOf(ht.get("OIL_AMT")))  + AddUtil.parseInt(String.valueOf(ht.get("INSUR_AMT")))  + AddUtil.parseInt(String.valueOf(ht.get("SERVICE_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TAX_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("ETC_AMT")))  ;  
													
							t_amt1 += AddUtil.parseInt(String.valueOf(ht.get("ASSET_AMT")));  
							t_amt2 += AddUtil.parseInt(String.valueOf(ht.get("FEE_AMT")));  
							t_amt3 += AddUtil.parseInt(String.valueOf(ht.get("A_FEE_AMT")));  
							t_amt4 += AddUtil.parseInt(String.valueOf(ht.get("OIL_AMT")));  
							t_amt5 += AddUtil.parseInt(String.valueOf(ht.get("INSUR_AMT")));  
							t_amt6 += AddUtil.parseInt(String.valueOf(ht.get("SERVICE_AMT")));  
							t_amt7 += AddUtil.parseInt(String.valueOf(ht.get("TAX_AMT")));  
							t_amt8 += AddUtil.parseInt(String.valueOf(ht.get("ETC_AMT")));  		
							
							
							s_amt1 = AddUtil.parseInt(String.valueOf(ht.get("ASSET_AMT")));  
							s_amt2 = AddUtil.parseInt(String.valueOf(ht.get("FEE_AMT")));  
							s_amt3 = AddUtil.parseInt(String.valueOf(ht.get("A_FEE_AMT")));
							s_amt4 = AddUtil.parseInt(String.valueOf(ht.get("OIL_AMT")));  
							s_amt5 = AddUtil.parseInt(String.valueOf(ht.get("INSUR_AMT")));  
							s_amt6 = AddUtil.parseInt(String.valueOf(ht.get("SERVICE_AMT")));  
							s_amt7 = AddUtil.parseInt(String.valueOf(ht.get("TAX_AMT")));  
							s_amt8 = AddUtil.parseInt(String.valueOf(ht.get("ETC_AMT")));  			
								
							s_amt9 = AddUtil.parseInt(String.valueOf(ht.get("ASSET_AMT"))) +  AddUtil.parseInt(String.valueOf(ht.get("A_FEE_AMT")));  
							
							t_amt29  += s_amt;																				
		           	
		   %>
		    			 <tr>    
			                 <td rowspan="2" width='60' class='content_border right'  >
			 <%          
			            //2018년부터는 실사용개월수로 계산 
			  				   if (  AddUtil.parseInt(st_year) < 2018 ) { 
			  				       cost_amt = 10000000;
			  				       asset_amt = 8000000;
			  				   }   else {
			  				     //1년이상 사용은 비용인정한도금액 10000000 
			  				      if ( AddUtil.parseInt(String.valueOf(ht.get("RENT_MONTH")))   ==  0  )  {
			  				          cost_amt = 10000000;
			  				          asset_amt = 8000000;
			  				      }  else {
			  				          cost_amt = 10000000 * AddUtil.parseInt(String.valueOf(ht.get("RENT_MONTH"))) / 12 ;
			  				          asset_amt = 8000000 * AddUtil.parseInt(String.valueOf(ht.get("RENT_MONTH"))) / 12 ;
			  				      }  				   				   
			  				   }   				    
			                              	
			   					if ( s_amt3 + s_amt4 + s_amt5 + s_amt6 + s_amt7 + s_amt8   > cost_amt ) {  //비용 - 천만원 초과 
			         
			                    aa =    s_amt3  + s_amt4 + s_amt5 + s_amt6 + s_amt7 + s_amt8 ;
						              
						          
						        bb =  AddUtil.parseFloatCipher(cost_amt /AddUtil.parseFloat(Integer.toString(aa) ) , 3 )    ;       
											          
						        cc = bb * 100;
						                  
			                      //관련비용  -  감가상각 상당액       			: 렌튼 70% 까지       			      			       			          
						        fs_amt11 =  AddUtil.parseFloat(Integer.toString(s_amt3) )  * 70/100  ;  	
						            			                          
						        s_amt11 = (int) fs_amt11;
						          
						          //업무사용  -  감가상각 상당액
						         fs_amt21 =  AddUtil.parseFloat(Integer.toString(s_amt11) )  * bb  ;  			          			                          
						         s_amt21 = (int) fs_amt21;
						          			          
						         if ( s_amt21 > asset_amt) {  // 감가상각비 상당액이 800만원 초과 인경우 800만원까지 인정  - 2018년붜 사용개월수 적용하여 산정 
			                       s_amt21 = asset_amt;                       
			                     }
			                                                          
			                    fs_amt22 =  ( AddUtil.parseFloat(Integer.toString(s_amt3 - s_amt11) )  +  AddUtil.parseFloat(Integer.toString(s_amt4) )  + AddUtil.parseFloat(Integer.toString(s_amt5) ) + AddUtil.parseFloat(Integer.toString(s_amt6) )  + AddUtil.parseFloat(Integer.toString(s_amt7) ) +  AddUtil.parseFloat(Integer.toString(s_amt8) ) ) * bb;
			 					s_amt22 = (int) fs_amt22; 		//관련비용 				 				
						  
			 	%>
			          <%=AddUtil.parseFloatCipher(cc, 1)%>%         
			  <% } else {
			  		 
			  		   s_amt11= s_amt3 * 70/100  ;  
			  		   
			  		   s_amt21= s_amt11  ;    
			  		      		        			           		  
			     	   fs_amt22 =   AddUtil.parseFloat(Integer.toString(s_amt3 - s_amt11) )  +  AddUtil.parseFloat(Integer.toString(s_amt4) )  + AddUtil.parseFloat(Integer.toString(s_amt5) ) + AddUtil.parseFloat(Integer.toString(s_amt6) )  + AddUtil.parseFloat(Integer.toString(s_amt7) ) +  AddUtil.parseFloat(Integer.toString(s_amt8) ) ;
			 			s_amt22 = (int) fs_amt22; 			
			 		           
			  %>   
			             100.0%
			  <% } 
			  
			  	//업무외 사용금액
			 			s_amt24 = s_amt11 - s_amt21;
			 			s_amt25 = s_amt - ( s_amt21+ s_amt22  + s_amt24 ) ;
			 			
			    		o_amt = s_amt21  - asset_amt;  //감가상각 한도 초과 금액  ( 업무사용금액중 한도 초과금액 계산) 
			    		
						if ( o_amt < 0 ) o_amt = 0;
						
					   if ( s_amt21 > asset_amt) {  // 감가상각비 상당액이 800만원 초과 인경우 800만원까지 인정  - 2018년붜 사용개월수 적용하여 산정 
			                   s_amt21 = asset_amt;                       
			           }		
			        
						t_amt11 += s_amt11;  			
						t_amt21 += s_amt21;  				
				     	t_amt22 += s_amt22;  	
				     	t_amt24 += s_amt24;  				
				     	t_amt25 += s_amt25;  	
				     		     				
						t_amt27 += o_amt;  			
					    	
					           	
			%>			
					        </td>     <!--업무사용비율 -->    		
								 
		                    <td rowspan="2" width='80' class='right content_border'  ><%=Util.parseDecimal(String.valueOf(ht.get("ASSET_AMT")))%></td>
		                    <td class='right content_border' width='100' ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>
		                    <td class='right content_border' width='100' ><%=Util.parseDecimal(String.valueOf(ht.get("A_FEE_AMT")))%></td>
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>
		                    <td rowspan="2" width='80' class='right content_border'><%=Util.parseDecimal(String.valueOf(ht.get("INSUR_AMT")))%></td>      
		                    <td rowspan="2" width='80' class='right content_border'><%=Util.parseDecimal(String.valueOf(ht.get("SERVICE_AMT")))%></td>      
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(String.valueOf(ht.get("TAX_AMT")))%></td>      
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt3 -s_amt11 + s_amt8)%></td>      <!-- 기타-->
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt)%></td>   <!-- 합계 -->
		                    
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt21)%></td>     <!-- 감가상각비(상당액) 한도초과금액 - 한도 800 만원  -->                  
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt22)%></td>    <!--업무사용 관련비용  합계 -->   
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt21+ s_amt22)%></td>   <!-- 업무사용계-->   
		                    
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt24)%></td>     <!-- 업무외 사용  - 감가상각비 -->                  
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt25)%></td>    <!--  업무외 사용 - 관련비용 합계 -->   
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt24 + s_amt25)%></td>   <!-- 손금산입 함계 : 합계- 손금불산입합계 -->      
		                   
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(o_amt)%></td>     <!-- 감가상각비(상당액) 한도초과금액 -->                  
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt24 + s_amt25 + o_amt)%></td>    <!-- 손금불산입 합계 -->   
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal( s_amt - (s_amt24 + s_amt25 + o_amt ) )%></td>   <!-- 손금산입 함계 : 합계- 손금불산입합계 -->      
		                </tr>
		                <tr>
		                    <td class='right content_border'  style='height:25'><%=Util.parseDecimal(s_amt2+ s_amt3)%></td>
		                    <td class='right content_border'  style='height:25'><%=Util.parseDecimal(s_amt11)%></td>
		                </tr>
		             
			        <%} %>
			      	        
			            <tr>   <!-- 합계 -->      
		                    <td class='title content_border' rowspan="2" style="text-align:right"  ></td>             
		                    <td class='title content_border' rowspan="2" style="text-align:right"  ><%=Util.parseDecimal(t_amt1)%></td>
		                    <td class='title content_border' style="text-align:right"  ><%=Util.parseDecimal(t_amt2)%></td>               
		                    <td class='title content_border' style="text-align:right" ><%=Util.parseDecimal(t_amt3)%></td>
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt4)%></td>
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt5)%></td>      
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt6)%></td>      
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt7)%></td>      
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt8)%></td>      
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt3 + t_amt4 + t_amt5 + t_amt6 + t_amt7 + t_amt8)%></td> 
		                    
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt21)%></td>     <!-- 업무용 사용 -->
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt22)%></td>    
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt21+ t_amt22)%></td> 
		                           
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt24)%></td>     <!-- 업무외 감가상각비  -->
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt25)%></td>      <!-- 업무외 관련비용  -->
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt24 + t_amt25)%></td>    
		                       
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt27)%></td>    <!-- 감가상각비(상당액) 한도초과금액 --> 
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt24 + t_amt25 + t_amt27)%></td>  <!-- 손금불산입 합계 -->    
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal( t_amt29  - t_amt24 - t_amt25 - t_amt27)%></td>   <!-- 손금산입 함계 : 합계- 손금불산입합계 -->      
		                </tr>
		                <tr>
		                   <td class='title content_border' style="text-align:right" ><%=Util.parseDecimal(t_amt2+t_amt3)%></td>
		                   <td class='title content_border' style="text-align:right" ><%=Util.parseDecimal(t_amt11)%></td>
		                </tr>         
		<%} else  {%>  
			        	<tr>
					       <td colspan="21" class='center content_border'>&nbsp;</td>
					   </tr>	              
		   <%}	%>
		            </table>
		        </div>
		     </td>
    	  </tr>
   	   </table>
	</div>
</div>		    	  	

</form>
</body>
</html>
