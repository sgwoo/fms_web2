<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_after.*"%>
<jsp:useBean id="olfBean" class="acar.offls_after.Offls_afterBean" scope="page"/>
<jsp:useBean id="olfD" class="acar.offls_after.Offls_afterDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dt = request.getParameter("dt")==null?"cont_dt":request.getParameter("dt");
	String migr_dt = request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt");
	String migr_gu = request.getParameter("migr_gu")==null?"3":request.getParameter("migr_gu");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");

	Offls_afterBean olfb[] = olfD.getAfter_lst(gubun, gubun_nm, brch_id, dt, st_dt, end_dt, car_st, com_id, car_cd, migr_gu);
	
	
	long totCsum = 0;
	long totFsum = 0;
	long totMsum = 0;
	long totHsum = 0;
	
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
<input type="hidden" name="brch_id" value="<%=brch_id%>">

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
						  	<colgroup>
				       		  <col  width='50'> <!--  rowspan -->
				       		  <col  width='100'>
				       		  <col  width='100'>
				       		  <col  width='150'><!--  rowspan -->		       		  
							  <col  width='160'><!--  rowspan -->
												  
				       		</colgroup>
			                
			                <tr> 
		                          <td width=50 class='title title_border' rowspan="2">연번</td>
		                          <td class='title title_border' colspan="2">차량번호</td>
		                          <td width=150 class='title title_border' rowspan="2">차명</td>
								  <td width=160 class='title title_border' rowspan="2">차대번호</td>
		                    </tr>
		                    <tr> 
		                          <td width=100 class='title title_border'>구</td>
		                          <td width=100 class='title title_border'>신</td>
		                    </tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">						
							<tr> 
	     		 	 		    <td width=150 class='title title_border' rowspan="2" style='height:45'> &nbsp;<br>양수인<br>&nbsp;</td>
	                            <td width=130 class='title title_border' rowspan="2">매매가</td>
	                            <td width=90 class='title title_border' rowspan="2">매매일자</td>
	                            <td width=100 class='title title_border' rowspan="2">희망가(원)</td>
	                            <td width=50 class='title title_border' rowspan="2">보증<br>여부</td>
			            		<td width=80 class='title title_border' rowspan="2">보험사</td>
			            		<td width=80 class='title title_border' rowspan="2">보험청구<br>여부</td>
			            		<td width=130 class='title title_border' rowspan="2">특소세</td>
	                            <td width=90 class='title title_border' rowspan="2">최초등록일</td>
	                            <td width=130 class='title title_border' rowspan="2">소비자가격(원)</td>
	                            <td width=130 class='title title_border' rowspan="2">구입가격(원)</td>
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
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix">

				<%if(olfb.length !=0 ){%>
		           <% for(int i=0; i< olfb.length; i++){
							olfBean = olfb[i];
							String seq = olfD.getAuction_maxSeq(olfBean.getCar_mng_id());
					%>
		                  <tr style="height: 25px;"> 
	                           <td width=50 class='center content_border'><%=i+1%></td>
	                           <td width=100 class='center content_border'><%=olfBean.getCar_pre_no()%></td>
	                           <td width=100 class='center content_border'><a href="javascript:parent.view_detail('<%=auth_rw%>','<%=olfBean.getCar_mng_id()%>','<%=seq%>')"><%=olfBean.getCar_no()%></a></td>
	                           <td width=150 class='left content_border'>&nbsp;<span title='<%=olfBean.getCar_jnm()+" "+olfBean.getCar_nm()%>'><%=AddUtil.subData(olfBean.getCar_jnm()+" "+olfBean.getCar_nm(),12)%></span></td>
	        				   <td width=160 class='center content_border'><%=olfBean.getCar_num()%></td>
		                   </tr>
		               <%}%>         
			     			<tr>              
			        		   <td class="title content_border" colspan=5  >합계</td>                    
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
     	 
					<%if(olfb.length !=0 ){%>
		       	     <% for(int i=0; i< olfb.length; i++){
							olfBean = olfb[i];
							/*
							int cSum = olfBean.getCar_cs_amt() + olfBean.getCar_cv_amt() + olfBean.getOpt_cs_amt() + olfBean.getOpt_cv_amt()+
									olfBean.getClr_cs_amt() + olfBean.getClr_cv_amt() + olfBean.getSd_cs_amt() + olfBean.getSd_cv_amt() +
									olfBean.getDc_cs_amt() + olfBean.getDc_cv_amt();
							int fSum = olfBean.getCar_fs_amt() + olfBean.getCar_fv_amt() + olfBean.getOpt_fs_amt() + olfBean.getOpt_fv_amt()+
									olfBean.getClr_fs_amt() + olfBean.getClr_fv_amt() + olfBean.getSd_fs_amt() + olfBean.getSd_fv_amt() +
									olfBean.getDc_fs_amt() + olfBean.getDc_fv_amt();
							*/
							int cSum = olfBean.getCar_cs_amt() + olfBean.getCar_cv_amt() + olfBean.getOpt_cs_amt() + olfBean.getOpt_cv_amt()+
									   olfBean.getClr_cs_amt() + olfBean.getClr_cv_amt();
							int fSum = olfBean.getCar_fs_amt() + olfBean.getCar_fv_amt() + olfBean.getSd_cs_amt() + olfBean.getSd_cv_amt() -
									   olfBean.getDc_cs_amt() - olfBean.getDc_cv_amt();
							totCsum += cSum;
							totFsum += fSum;
							int carpr = olfBean.getCar_cs_amt()+olfBean.getCar_cv_amt()+olfBean.getOpt_cs_amt()+olfBean.getOpt_cv_amt()+olfBean.getClr_cs_amt()+olfBean.getClr_cv_amt();
							double hppr = olfBean.getHppr();
							double stpr = olfBean.getStpr();
							double hppr_per = (hppr*100)/carpr;
							totMsum += olfBean.getMm_pr();
							totHsum += olfBean.getHppr();
					%>
		                    <tr style="height: 25px;"> 
	                               <td width=150 class='center content_border' ><span title='<%=olfBean.getSui_nm()%>'> <%=AddUtil.subData(olfBean.getSui_nm(),8)%></span></td>
	                               <td width=130 class='right content_border' ><%=AddUtil.parseDecimal(olfBean.getMm_pr())%></td>
	                               <td width=90 class='center content_border' ><%=AddUtil.ChangeDate2(olfBean.getCont_dt())%></td>
	                               <td width=100 class='right content_border' ><%=AddUtil.parseDecimal(olfBean.getHppr())%></td>
	                               <td width=50 class='center content_border' > 
				                   <%if(!olfBean.getAss_ed_dt_actn().equals("")){
									  if(AddUtil.parseInt(olfBean.getAss_ed_dt_actn()) < AddUtil.ChangeStringInt(AddUtil.getDate())){%>
									완료 
									<%}else{%>
									<font color="ff00ff">진행</font>
									<%}
								 }else{
								 	if(olfBean.getAss_ed_dt_sui().equals("")){%>
										-
									<%						
									}else{
										  if(AddUtil.parseInt(olfBean.getAss_ed_dt_sui()) < AddUtil.ChangeStringInt(AddUtil.getDate())){%>
										완료 
										<%}else{%>
										<font color="ff00ff">진행</font>
										<%}
									}
								 }%>
	                                </td>
	                                <td width='80' class='left content_border'>&nbsp;<span title='<%=olfBean.getIns_com_nm()%>'><%=AddUtil.subData(olfBean.getIns_com_nm(),5)%></span></td>
	           						<td width=80 class='center content_border' ><span title="<% if(!olfBean.getReq_dt().equals("")) out.print(AddUtil.ChangeDate2(olfBean.getReq_dt())); %>"><% if(olfBean.getReq_dt().equals("")) out.print("<font color=red>미청구</font>"); else out.print("청구"); %></span></td>
	            					<td width=130 class='center content_border' > 
	            					<% if(olfBean.getTax_st().equals("1")){ %>
	            						<font color="#9900CC">납부(장기대여)</font>
	            					<% }else if(olfBean.getTax_st().equals("2")){
	            							if(olfBean.getCls_man_st().equals("0")||olfBean.getCls_man_st().equals("1")){%>
	            								<font color="#9900CC">납부(매각)</font>					
	            							<%}else{%>
	            								<font color="#3300CC">면제</font>					
	            							<%}
	            					}else{%>
	            						-
	            					<%}%>
	                                </td>
	                                <td width=90 class='center content_border'><%=AddUtil.ChangeDate2(olfBean.getInit_reg_dt())%></td>
	                                <td width=130 class='right content_border'><%=AddUtil.parseDecimal(cSum)%></td>
	                                <td width=130 class='right content_border'><%=AddUtil.parseDecimal(fSum)%></td>
		                       </tr>
		                            <%}%>
		                       <tr> 
	                                <td class='title center content_border' >&nbsp;</td>
	                                <td class='title right content_border' ><%=AddUtil.parseDecimal(totMsum)%></td>
	                                <td class='title center content_border' >&nbsp;</td>
	                                <td class='title center content_border' >&nbsp;</td>
	                                <td class='title center content_border' >&nbsp;</td>
	                                <td class='title center content_border' >&nbsp;</td>
			            			<td class='title center content_border' >&nbsp;</td>
			            			<td class='title center content_border' >&nbsp;</td>
	                                <td class='title center content_border'>&nbsp;</td>
	                                <td class='title right content_border'><%=AddUtil.parseDecimal(totCsum)%></td>
	                                <td class='title right content_border'><%=AddUtil.parseDecimal(totFsum)%></td>
		                       </tr>		                   
					<%} else  {%>  
				      		   <tr>
						            <td  colspan="11" class='center content_border'>&nbsp;</td>
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