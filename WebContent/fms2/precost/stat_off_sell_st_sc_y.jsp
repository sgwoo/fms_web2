<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	int f_year 	= 2017;	
	int days 	= 0;
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	
	mons = years;
	
	Vector vt = ad_db.getStatOffSellServStMon(s_yy);

	int vt_size = vt.size();
	
	int s1_row = 0;  //수도권
	int x1_row = 0;  //비수도권
			
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		if(String.valueOf(ht.get("BR_NM")).equals("수도권")){								
			s1_row++;		
		}
		if(String.valueOf(ht.get("BR_NM")).equals("비수도권")){
			x1_row++;
		}
				
	}
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  
<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>	
				<td style="width: 370px;">
					<div style="width: 370px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							 	<td class='title title_border' colspan="3" rowspan=2 with=370>구분</td>             
							</tr>
						</table>
					</div>
				</td>		
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
						 <colgroup>						 	
				       			<col width="50">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80"> <!-- 합계 -->
				       			
			              <%for (int j = 0 ; j < mons ; j++){%>
				       			<col width="50">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80">
				       		 <%}%>				       		     			
				       		</colgroup>
				       		
				       		 <tr align="center">					        
					            <td colspan='5' class='title title_border'>합계</td>
										  <%for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){%>
					            <td colspan='5' width=60 class='title title_border'><%=i%>년도</td>
										  <%}%>
					          </tr>
					          <tr align="center"> 
					            <td width=50 class='title title_border'>건수</td>
					            <td width=80 class='title title_border'>부품</td>
					            <td width=80 class='title title_border'>공임</td>
					            <td width=80 class='title title_border'>합계</td>
					            <td width=80 class='title title_border'>면책금</td>					                  
										  <%for (int j = 0 ; j < mons ; j++){%>
					            <td width=50 class='title title_border'>건수</td>
					            <td width=80 class='title title_border'>부품</td>
					            <td width=80 class='title title_border'>공임</td>
					            <td width=80 class='title title_border'>합계</td>
					            <td width=80 class='title title_border'>면책금</td>
										  <%}%>
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
				<td style="width: 370px;">
					<div style="width: 370px;">
						<table class="inner_top_table left_fix"> 
							 <%
						  	String br_nm = "";
						  	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
							%>
				          <tr> 
				            <%if(!String.valueOf(ht.get("BR_NM")).equals(br_nm) && (i+1) < vt_size){%>
				              <td width="70" class='center content_border'
				              	<%if(String.valueOf(ht.get("BR_NM")).equals("수도권")){%>rowspan='<%=s1_row%>'<%}%>
				              	<%if(String.valueOf(ht.get("BR_NM")).equals("비수도권")){%>rowspan='<%=x1_row%>'<%}%>                         	           	
				              ><%=ht.get("BR_NM")%></td>
				            <%}%>
				            <%if((i+1)==vt_size){%>
				            <td class='center content_border' colspan='3'><%=ht.get("OFF_NM")%></td>       
				            <%}else{%>
				            <td width="180" class='center content_border'><span title='<%=ht.get("OFF_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("OFF_NM")), 10)%></span></td>
				             <td width="120" class='center content_border'><span title='<%=ht.get("ST_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("ST_NM")), 10)%></span></td>
				            <%}%>  
			            					       
						  </tr>
					    	<%	br_nm = String.valueOf(ht.get("BR_NM"));
							 }
						  	%>										         
					      </table>        
				     </div>            
				 </td>   <!-- left -->		
				 		
		  	     <td>			
		     		<div>
						<table class="inner_top_table table_layout"> 	  
		    
					     <%						  
						  	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
							%>
				          <tr> 				                       
				            <%	//for (int j = 0 ; j < mons+1 ; j++){%>
				            <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>
				            <td class='center content_border right' width="50"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT"+(j))))%></td>
				            <td class='center content_border right' width="80"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("J_AMT"+(j))))%></td>      
				            <td class='center content_border right' width="80"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("L_AMT"+(j))))%></td>      
				            <td class='center content_border right' width="80"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("T_AMT"+(j))))%></td>      
				            <td class='center content_border right' width="80"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("E_AMT"+(j))))%></td>                              
						  <%	}%>
				          </tr>
	          
					  <%
					    }
					  %>
				     
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

	
	