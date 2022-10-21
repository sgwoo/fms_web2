<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	
	Vector vt = cmp_db.getSaleBusMngList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2);
	int vt_size = vt.size();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">
<script language="JavaScript">
<!--
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 420px;">
					<div style="width: 420px;">
						<table class="inner_top_table left_fix" style="height: 50px;">
							  <tr> 
		  					    <td width="30" class="title title_border">����</td>
          					    <td width="90" class="title title_border">��౸��</td>		  
          					    <td width="100" class="title title_border">����ȣ</td>
          					    <td width="200" class="title title_border">��ȣ</td>          
			                </tr>        
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 50px;">							
							<colgroup>				       			
				       			<col width="65">
				       			<col width="50">
				       			<col width="50">				       			
				       			<col width="50"> 				       					       		
				       			<col width="30">
				       			<col width="40">
				       			<col width="30">
				       			<col width="70">
				       			<col width="70">
				       			<col width="45">				       			
				       			<col width="45"> 				       					       		
				       			<col width="45">
				       			<col width="100"> 
				       			<col width="70">
				       		</colgroup>																      
					        <tr>
		  	                    <td width="65" class="title title_border">����</td>
          	                    <td width="50" class="title title_border">����<br>�����</td>
          	                    <td width="50" class="title title_border">����<br>�븮��</td>
          	                    <td width="50" class="title title_border">����<br>�����</td>		  		  
          	                    <td width="30" class="title title_border">����<br>���</td>		  		  
          	                    <td width="40" class="title title_border">�뿩<br>����</td>		  		  
          	                    <td width="30" class="title title_border">���<br>����</td>		  		  		            
          	                    <td width="70" class="title title_border">�뿩������</td>
          	                    <td width="70" class="title title_border">������</td>		  
          	                    <td width="45" class="title title_border">����<br>����<br>���</td>
          	                    <td width="45" class="title title_border">��ȿ<br>����</td>
          	                    <td width="45" class="title title_border">����<br>����</td>
          	                    <td width="100" class="title title_border">ķ���θ���������</td>
          	                    <td width="70" class="title title_border">�ŷ�������</td>
          	                    	                              
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
				<td style="width: 420px;">
					<div style="width: 420px;">
						<table class="inner_top_table left_fix">  					
			            	<%	if(vt_size > 0){%>  
			                <%		for(int i = 0 ; i < vt_size ; i++){
										Hashtable ht = (Hashtable)vt.elementAt(i);
							%>
			                <tr>
		  	                    <td width="30" class="center content_border"><%= i+1 %></td>
          	                    <td width="90" class="center content_border"><%= ht.get("GUBUN") %></td>
          	                    <td width="100" class="center content_border"><%= ht.get("RENT_L_CD") %></td>
          	                    <td width="200" class="left content_border">&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("FIRM_NM")), 26)%></span></td>          
			                </tr>
			  				<%		} %>
		     				<%	}	%>	   
			            </table>
			         </div>            
				  </td>              
		       		         
				  <td>			
		     	 	<div>
						<table class="inner_top_table table_layout">  
						 	<%	if(vt_size > 0){%>  
			                <%		for(int i = 0 ; i < vt_size ; i++){
										Hashtable ht = (Hashtable)vt.elementAt(i);
							%>  	 		            
		                	<tr> 
		                	<td width="65" class="center content_border"><%= ht.get("GUBUN2") %></td>		  
                        	<td width="50" class="center content_border"><%= ht.get("BUS_NM") %><%if(String.valueOf(ht.get("BUS_NM")).equals("")){%><%=c_db.getNameById(String.valueOf(ht.get("F_BUS_ID")),"USER")%><%}%></td>
                        	<td width="50" class="center content_border"><%= ht.get("BUS_AGNT_NM") %></td>		  
                        	<td width="50" class="center content_border"><%= ht.get("BUS_NM2") %></td>		  		  
                        	<td width="30" class="center content_border"><%= ht.get("BUS_EMP_ID_YN") %></td>		  		  
                        	<td width="40" class="center content_border"><%= ht.get("RENT_WAY_NM") %></td>		  		  		  
                        	<td width="30" class="center content_border"><%= ht.get("CON_MON") %></td>		  		  		            
                        	<td width="70" class="center content_border"><%= AddUtil.ChangeDate2((String)ht.get("RENT_START_DT")) %></td>
                        	<td width="70" class="center content_border"><%= AddUtil.ChangeDate2((String)ht.get("CLS_DT")) %></td>		            
                        	<td width="45" class="center content_border"><%= ht.get("CNT3") %></td>
                        	<td width="45" class="center content_border"><%= ht.get("CNT4") %></td>
                        	<td width="45" class="center content_border"><%= ht.get("V_CNT4") %></td>
                        	<td width="100" class="center content_border"><%= AddUtil.ChangeDate2((String)ht.get("CE_DT")) %></td>
                        	<td width="70" class="center content_border"><%= AddUtil.ChangeDate2((String)ht.get("FIRST_RENT_START_DT2")) %></td>                                  	                  
		                </tr>
		             		<%		} %>
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