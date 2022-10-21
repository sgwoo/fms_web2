<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.offls_cmplt.*" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	Vector vt = olcD.getSuiStatLst2("1", s_yy, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	String cont_year 	= "";
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
<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 300px;">
					<div style="width: 300px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  
							    <td width=100 class='title title_border'>&nbsp;<br>매각년도<br>&nbsp;<br></td>
                                <td width=100 class='title title_border'>구분</td>
                                <td width=100 class='title title_border'>총매각대수</td>                                                                 	
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
							<colgroup>				       			
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="30">
				       			<col width="100">				       					       		
				       		</colgroup>
			        		<tr>
			        		  
                    		  <td width=100 class='title title_border'>분석대수</td>
                    		  <td width=100 class='title title_border'>분석비율</td>
                    		  <td width=100 class='title title_border'>소비자차가</td>
                    		  <td width=100 class='title title_border'>차령<br>(개월)</td>
                    		  <td width=100 class='title title_border'>잔가손익</td>
                    		  <td width=100 class='title title_border'>대당 잔가손익</td>                    		  
                    		  <td width=100 class='title title_border'>소비자가 대비<br>잔가손익율</td>
                    		  <td width=100 class='title title_border'>잔가손익<br>미포함기간<br>(개월)</td>
                    		  <td width=100 class='title title_border'>미포함 기간<br>잔가손익 효과</td>
                    		  <td width=100 class='title title_border'>미포함 기간<br>잔가손익<br>효과금액<br>(합계)</td>
                    		  <td width=100 class='title title_border'>미포함 기간<br>잔가손익효과<br>(대당 잔가손익<br>효과금액)</td>
                    		  <td width=100 class='title title_border'>실질<br>잔가손익율</td>
                    		  <td width=100 class='title title_border'>실질<br>잔가손익</td>
                    		  <td width=100 class='title title_border'>실질<br>대당 잔가손익</td>                                        
                    		  <td width=30 class='title title_border'></td>
                    		  <td width=100 class='title title_border'>[참고]<br>재리스/연장계약<br>중고차평가이익</td>                    
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
				<td style="width: 300px;">
					<div style="width: 300px;">
						<table class="inner_top_table left_fix">  			  
			            	<%	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);							
			    			%>
			                <tr style="height: 25px;"> 
			                  <%if(!String.valueOf(ht.get("CONT_YEAR")).equals(cont_year)){%><TD width='100' rowspan="3" class='title title_border'><a href="javascript:parent.show_month('<%=ht.get("CONT_YEAR")%>')"><%=ht.get("CONT_YEAR")%></a></TD><%}%>			                  
			                  <td width='100' class='title title_border'><%=ht.get("JG_2")%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border'<%}else{%>class='center content_border'<%}%>><%=ht.get("D_VAR")%></td>			                  
			                </tr>
			        		<%		cont_year = (String)ht.get("CONT_YEAR");
			        			}	%>
			            </table>
			         </div>            
				  </td>
	    		  <td>			
		     	 	<div>
						<table class="inner_top_table table_layout">   	  	      
			       			<%	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);							
			    			%>
			        		<tr style="height: 25px;"> 			        		  
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border'<%}else{%>class='center content_border'<%}%>><%=ht.get("E_VAR")%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border'<%}else{%>class='center content_border'<%}%>><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("E_PER")),2)%>%</td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border' style='text-align:right'<%}else{%>class='right content_border'<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("I_VAR")))%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border'<%}else{%>class='center content_border'<%}%>><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("F_VAR")),2)%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border' style='text-align:right'<%}else{%>class='right content_border'<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("G_VAR")))%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border' style='text-align:right'<%}else{%>class='right content_border'<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("H_VAR")))%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border'<%}else{%>class='center content_border'<%}%>><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("J_VAR")),2)%>%</td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border'<%}else{%>class='center content_border'<%}%>><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("K_VAR")),2)%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border'<%}else{%>class='center content_border'<%}%>><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("L_VAR")),2)%>%</td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border' style='text-align:right'<%}else{%>class='right content_border'<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("L_VAR_S_AMT")))%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border' style='text-align:right'<%}else{%>class='right content_border'<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("L_VAR_A_AMT")))%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border'<%}else{%>class='center content_border'  style='background-color:#ffeb46;'<%}%>><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("M_VAR")),2)%>%</td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border' style='text-align:right'<%}else{%>class='right content_border' style='background-color:#ffeb46;'<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("N_VAR")))%></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border' style='text-align:right'<%}else{%>class='right content_border' style='background-color:#ffeb46;'<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("O_VAR")))%></td>
			                  <td width='30'  <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border'<%}else{%>class='center content_border'<%}%>></td>
			                  <td width='100' <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title title_border' style='text-align:right'<%}else{%>class='right content_border'<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("P_VAR")))%></td>
			        		</tr>
			      		 	<%	}	%> 		
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