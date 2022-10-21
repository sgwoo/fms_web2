<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_after.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dt = request.getParameter("dt")==null?"cls_dt":request.getParameter("dt");
	String migr_dt = request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt");
	String migr_gu = request.getParameter("migr_gu")==null?"3":request.getParameter("migr_gu");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");	
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	
		
	Offls_afterDatabase olfD = Offls_afterDatabase.getInstance();
	Vector mOptionList = olfD.getMoption_lst(gubun, gubun_nm, dt, st_dt, end_dt, car_st, migr_gu);
	
 	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
 	//chrome 관련 
 	String height = request.getParameter("height")==null?"":request.getParameter("height");
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
	
	//전체선택
	var checkflag = "false";
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}	
	
 //-->   
</script>

</head>
<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="from_page" value="off_ls_after_opt_frame">

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 580px;">
					<div style="width: 580px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  
                    			 <td width='40' class='title title_border'><input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'></td>							
			                     <td width='40' class='title title_border'>연번</td>
								 <td width='150' class='title title_border'>차대번호</td>
			                     <td width='100' class='title title_border'>차량번호</td>
			                     <td width='100' class='title title_border'>차량관리번호</td>
			                     <td width='150' class='title title_border'>차명</td>
			                
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
						
							<tr>
							   <td width='160' class='title title_border'>상호</td>
					       	   <td width=90 class='title title_border'>해지일</td>
	                           <td width=90 class='title title_border'>서류수령일</td>							
	                           <td width=120 class='title title_border'>보험사</td> 
	                           <td width=80 class='title title_border'>청구여부</td> 
	                           <td width=100 class='title title_border'>특소세</td> 				  
	                           <td width=100 class='title title_border'>양수인</td>
	                           <td width=90 class='title title_border'>매매가</td>
	                           <td width=90 class='title title_border'>매매일자</td>
	                           <td width=90 class='title title_border'>명의이전일</td> 
	                           <td width=90 class='title title_border'>최초등록일</td>
	                           <td width=100 class='title title_border'>소비자가격(원)</td>
	           					<td width=100 class='title title_border'>구입가격(원)</td>				  	                 	
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
				<td style="width: 580px;">
					<div style="width: 580px;">
						<table class="inner_top_table left_fix" >	

				<%if(mOptionList.size() > 0 ){%>
				 <% for(int i=0; i< mOptionList.size(); i++){
						 Hashtable car = (Hashtable)mOptionList.elementAt(i); %>					
						   <tr style="height: 25px;"> 
                              <td width='40' class='center content_border'><input type="checkbox" name="pr" value="<%=car.get("CAR_MNG_ID")%>" ></td>
                              <td width='40' class='center content_border'><%=i+1%></td>								
                      		  <td width='150' class='center content_border'><%=car.get("CAR_NUM")%></td>
                              <td width='100' class='center content_border'><a href="javascript:parent.view_detail('<%=auth_rw%>','<%=car.get("CAR_MNG_ID")%>','')"><%=car.get("CAR_NO")%></a></td>
                              <td width='100' class='center content_border'><%=car.get("CAR_DOC_NO")%></td>
                              <td width='150' class='left content_border'>&nbsp;<span title='<%=car.get("CAR_NAME")%>'><%=AddUtil.subData((String)car.get("CAR_NAME"),10)%></span></td>
                             
		                    </tr>
		                     <%		}	%>
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
					<table class="inner_top_table table_layout" >	   
	    
			       	<%if(mOptionList.size() > 0 ){%>    
			              <% for(int i=0; i< mOptionList.size(); i++){
							Hashtable car = (Hashtable)mOptionList.elementAt(i); %>
                          <tr style="height: 25px;"> 
                              <td width='160' class='left content_border'>&nbsp;<span title='<%=car.get("FIRM_NM")%>'><%=AddUtil.subData((String)car.get("FIRM_NM"),10)%></span></td>
                              <td width=90 class='center content_border'><%=AddUtil.ChangeDate2((String)car.get("CLS_DT"))%></td>
                              <td width=90 class='center content_border'><%=AddUtil.ChangeDate2((String)car.get("CONJ_DT"))%></td>						
                              <td width='120' class='left content_border'>&nbsp;<span title='<%=car.get("INS_COM_NM")%>'><%=AddUtil.subData((String)car.get("INS_COM_NM"),8)%></span></td>
                              <td width=80 class='center content_border'><span title="<% if(!((String)car.get("REQ_DT")).equals("")) out.print(AddUtil.ChangeDate2((String)car.get("REQ_DT"))); %>"><% if(((String)car.get("REQ_DT")).equals("")) out.print("<font color=red>미청구</font>"); else out.print("청구"); %></span></td>
                              <td width=100 class='center content_border'>
          				    <% if(((String)car.get("TAX_ST")).equals("1")){ %>
          						<font color="#9900CC">납부(장기대여)</font>
          					<% }else if(((String)car.get("TAX_ST")).equals("2")){
          							if(((String)car.get("CLS_MAN_ST")).equals("0")||((String)car.get("CLS_MAN_ST")).equals("1")){%>
          								<font color="#9900CC">납부(매각)</font>					
          							<%}else{%>
          								<font color="#3300CC">면제</font>					
          							<%}%>
          					<% }else if(((String)car.get("TAX_ST")).equals("3")){%>
          								<font color="#3300CC">납부(용도변경)</font>					
          					<% }else if(((String)car.get("TAX_ST")).equals("4")){%>
          								<font color="#3300CC">납부(폐차)</font>					
          					<%}else{%>
          				    	<% if(((String)car.get("CAR_ST")).equals("미대상")){ %>								
          								<font color="#3300CC">과세차량</font>														
							<%}else{%>
								<% if(((String)car.get("DLV_MON_ST")).equals("5년경과")){ %>								
          								<font color="#3300CC">출고후5년경과</font>	
								<%}else{%>
           						-
								<%}%>									
							<%}%>
          					<%}%></td>				  				  
                              <td width=100 class='center content_border'><span title='<%=car.get("SUI_NM")%>'> <%=AddUtil.subData((String)car.get("SUI_NM"),5)%></span></td>
                              <td width=90 class='right content_border'><%=AddUtil.parseDecimal(car.get("MM_PR"))%></td>
                              <td width=90 class='center content_border'><%=AddUtil.ChangeDate2((String)car.get("CONT_DT"))%></td>
                              <td width=90 class='center content_border'><%=AddUtil.ChangeDate2((String)car.get("MIGR_DT"))%></td>
                              <td width=90 class='center content_border'><%=AddUtil.ChangeDate2((String)car.get("INIT_REG_DT"))%></td>
                              <td width=100 class='right content_border'><%=AddUtil.parseDecimal(car.get("C_AMT"))%></td>
          				      <td width=100 class='right content_border'><%=AddUtil.parseDecimal(car.get("F_AMT"))%></td>                        		
                          </tr>
					            <%		}	%> 		
					    <%} else  {%>  
					       <tr>
						       <td  colspan="13" class='center content_border'>&nbsp;</td>
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