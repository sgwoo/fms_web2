<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ���� 
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
			        		    <td class='title title_border' width="11%" style='height:60'>�����</td>
					            <td class='title title_border' width="12%" >������ȣ</td>
							    <td  class='title title_border'  width="32%">����</td>
							    <td  class='title title_border'  width="11%">����<br>����</td>
							    <td class='title title_border'  width="11%">���谡��<br>����</td>
							    <td  class='title title_border'  width="11%">������<br>�Ÿ�</td>
							    <td  class='title title_border'  width="12%">������<br>���Ÿ�</td>								
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
							    <td  rowspan=2 class='title title_border'  width="60">����<br>������</td>
							    <td  colspan=9 class='title title_border'  style='height:25'>������¿������ú��</td>
							    <td  colspan=3 class='title title_border'  style='height:25'>�������ݾ�</td>
							    <td  colspan=3 class='title title_border'  style='height:25'>�����ܻ��ݾ�</td>
							    <td rowspan="2" class='title title_border' width='90'>�����󰢺�<br>(����)<br>�ѵ��ʰ��ݾ�</td>
							    <td rowspan="2" class='title title_border' width='90'>�ձݺһ���<br>�հ�</td>
							    <td rowspan="2" class='title title_border' width='90'>�ձݻ���<br>�հ�</td>
							</tr>
			        		<tr>		
							  	  <td class='title title_border' width='80'  style='height:25'>�����󰢺�</td>
								  <td class='title title_border' width='100'>���κδ�뿩��<br>�뿩����</td> 
								  <td class='title title_border' width='100'>ȸ�������뿩��<br>�����󰢻���</td> 
								  <td class='title title_border' width='90'>������</td>
								  <td class='title title_border' width='80'>�����</td>
								  <td class='title title_border' width='80'>������</td>
								  <td class='title title_border' width='90'>�ڵ�����</td>
								  <td class='title title_border' width='90'>��Ÿ</td>
								  <td class='title title_border' width='90'>�հ�</td>
								  
								  <td class='title title_border' width='90'  style='height:25'>�����󰢺�<br>(����)</td>
								  <td class='title title_border' width='90'>���ú��</td>
								  <td class='title title_border' width='90'>�հ�</td>
								  <td class='title title_border' width='90'  style='height:25'>�����󰢺�<br>(����)</td>
								  <td class='title title_border' width='90'>���ú��</td>
								  <td class='title title_border' width='90'>�հ�</td>
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
				        		 <td class="title center content_border"  colspan=7  style='height:50'>�հ�</td>                    
				            </tr>			
				    <%} else  {%>  
					        <tr>
							     <td class='center content_border'>��ϵ� ����Ÿ�� �����ϴ�</td>
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
			            //2018����ʹ� �ǻ�밳������ ��� 
			  				   if (  AddUtil.parseInt(st_year) < 2018 ) { 
			  				       cost_amt = 10000000;
			  				       asset_amt = 8000000;
			  				   }   else {
			  				     //1���̻� ����� ��������ѵ��ݾ� 10000000 
			  				      if ( AddUtil.parseInt(String.valueOf(ht.get("RENT_MONTH")))   ==  0  )  {
			  				          cost_amt = 10000000;
			  				          asset_amt = 8000000;
			  				      }  else {
			  				          cost_amt = 10000000 * AddUtil.parseInt(String.valueOf(ht.get("RENT_MONTH"))) / 12 ;
			  				          asset_amt = 8000000 * AddUtil.parseInt(String.valueOf(ht.get("RENT_MONTH"))) / 12 ;
			  				      }  				   				   
			  				   }   				    
			                              	
			   					if ( s_amt3 + s_amt4 + s_amt5 + s_amt6 + s_amt7 + s_amt8   > cost_amt ) {  //��� - õ���� �ʰ� 
			         
			                    aa =    s_amt3  + s_amt4 + s_amt5 + s_amt6 + s_amt7 + s_amt8 ;
						              
						          
						        bb =  AddUtil.parseFloatCipher(cost_amt /AddUtil.parseFloat(Integer.toString(aa) ) , 3 )    ;       
											          
						        cc = bb * 100;
						                  
			                      //���ú��  -  ������ ����       			: ��ư 70% ����       			      			       			          
						        fs_amt11 =  AddUtil.parseFloat(Integer.toString(s_amt3) )  * 70/100  ;  	
						            			                          
						        s_amt11 = (int) fs_amt11;
						          
						          //�������  -  ������ ����
						         fs_amt21 =  AddUtil.parseFloat(Integer.toString(s_amt11) )  * bb  ;  			          			                          
						         s_amt21 = (int) fs_amt21;
						          			          
						         if ( s_amt21 > asset_amt) {  // �����󰢺� ������ 800���� �ʰ� �ΰ�� 800�������� ����  - 2018��� ��밳���� �����Ͽ� ���� 
			                       s_amt21 = asset_amt;                       
			                     }
			                                                          
			                    fs_amt22 =  ( AddUtil.parseFloat(Integer.toString(s_amt3 - s_amt11) )  +  AddUtil.parseFloat(Integer.toString(s_amt4) )  + AddUtil.parseFloat(Integer.toString(s_amt5) ) + AddUtil.parseFloat(Integer.toString(s_amt6) )  + AddUtil.parseFloat(Integer.toString(s_amt7) ) +  AddUtil.parseFloat(Integer.toString(s_amt8) ) ) * bb;
			 					s_amt22 = (int) fs_amt22; 		//���ú�� 				 				
						  
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
			  
			  	//������ ���ݾ�
			 			s_amt24 = s_amt11 - s_amt21;
			 			s_amt25 = s_amt - ( s_amt21+ s_amt22  + s_amt24 ) ;
			 			
			    		o_amt = s_amt21  - asset_amt;  //������ �ѵ� �ʰ� �ݾ�  ( �������ݾ��� �ѵ� �ʰ��ݾ� ���) 
			    		
						if ( o_amt < 0 ) o_amt = 0;
						
					   if ( s_amt21 > asset_amt) {  // �����󰢺� ������ 800���� �ʰ� �ΰ�� 800�������� ����  - 2018��� ��밳���� �����Ͽ� ���� 
			                   s_amt21 = asset_amt;                       
			           }		
			        
						t_amt11 += s_amt11;  			
						t_amt21 += s_amt21;  				
				     	t_amt22 += s_amt22;  	
				     	t_amt24 += s_amt24;  				
				     	t_amt25 += s_amt25;  	
				     		     				
						t_amt27 += o_amt;  			
					    	
					           	
			%>			
					        </td>     <!--���������� -->    		
								 
		                    <td rowspan="2" width='80' class='right content_border'  ><%=Util.parseDecimal(String.valueOf(ht.get("ASSET_AMT")))%></td>
		                    <td class='right content_border' width='100' ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>
		                    <td class='right content_border' width='100' ><%=Util.parseDecimal(String.valueOf(ht.get("A_FEE_AMT")))%></td>
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>
		                    <td rowspan="2" width='80' class='right content_border'><%=Util.parseDecimal(String.valueOf(ht.get("INSUR_AMT")))%></td>      
		                    <td rowspan="2" width='80' class='right content_border'><%=Util.parseDecimal(String.valueOf(ht.get("SERVICE_AMT")))%></td>      
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(String.valueOf(ht.get("TAX_AMT")))%></td>      
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt3 -s_amt11 + s_amt8)%></td>      <!-- ��Ÿ-->
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt)%></td>   <!-- �հ� -->
		                    
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt21)%></td>     <!-- �����󰢺�(����) �ѵ��ʰ��ݾ� - �ѵ� 800 ����  -->                  
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt22)%></td>    <!--������� ���ú��  �հ� -->   
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt21+ s_amt22)%></td>   <!-- ��������-->   
		                    
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt24)%></td>     <!-- ������ ���  - �����󰢺� -->                  
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt25)%></td>    <!--  ������ ��� - ���ú�� �հ� -->   
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt24 + s_amt25)%></td>   <!-- �ձݻ��� �԰� : �հ�- �ձݺһ����հ� -->      
		                   
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(o_amt)%></td>     <!-- �����󰢺�(����) �ѵ��ʰ��ݾ� -->                  
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal(s_amt24 + s_amt25 + o_amt)%></td>    <!-- �ձݺһ��� �հ� -->   
		                    <td rowspan="2" width='90' class='right content_border'><%=Util.parseDecimal( s_amt - (s_amt24 + s_amt25 + o_amt ) )%></td>   <!-- �ձݻ��� �԰� : �հ�- �ձݺһ����հ� -->      
		                </tr>
		                <tr>
		                    <td class='right content_border'  style='height:25'><%=Util.parseDecimal(s_amt2+ s_amt3)%></td>
		                    <td class='right content_border'  style='height:25'><%=Util.parseDecimal(s_amt11)%></td>
		                </tr>
		             
			        <%} %>
			      	        
			            <tr>   <!-- �հ� -->      
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
		                    
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt21)%></td>     <!-- ������ ��� -->
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt22)%></td>    
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt21+ t_amt22)%></td> 
		                           
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt24)%></td>     <!-- ������ �����󰢺�  -->
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt25)%></td>      <!-- ������ ���ú��  -->
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt24 + t_amt25)%></td>    
		                       
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt27)%></td>    <!-- �����󰢺�(����) �ѵ��ʰ��ݾ� --> 
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal(t_amt24 + t_amt25 + t_amt27)%></td>  <!-- �ձݺһ��� �հ� -->    
		                    <td class='title content_border' rowspan="2" style="text-align:right" ><%=Util.parseDecimal( t_amt29  - t_amt24 - t_amt25 - t_amt27)%></td>   <!-- �ձݻ��� �԰� : �հ�- �ձݺһ����հ� -->      
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
