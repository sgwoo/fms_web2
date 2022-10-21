<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_sui.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="olsBean" class="acar.offls_sui.Offls_suiBean" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	Offls_suiBean olsb[] = olsD.getSui_lst(gubun,gubun_nm);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	int totCsum = 0;
	int totFsum = 0;
	
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


<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

<script type="text/javascript">
<!--
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

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 460px;">
					<div style="width: 460px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>										        		   		
		        		   		<td width=40 class='title title_border'> <input type="checkbox" name="all_pr" value="Y" onclick='javascript:AllSelect(this.form.pr)'></td>
		                        <td width=40 class='title title_border'>연번</td>
		                        <td width=120 class='title title_border'>차량번호</td>
		                        <td width=160 class='title title_border'>차명</td>
		                        <td width=100 class='title title_border' >최초등록일</td>			
                        		          		  
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							<colgroup>
				       		  <col  width='230'> <!--  rowspan -->
				       		  <col  width='120'>
				       		  <col  width='120'>
				       		  <col  width='120'> 		       		  
							  <col  width='120'>  <!-- 주행거리 -->
							  <col  width='90'> 
							  <col  width='170'>
							  <col  width='80'> <!-- 색상 -->
												  
							  <col  width='90'> <!--  colspan -->
							  <col  width='120'>
							  <col  width='80'>					  							  
				       		</colgroup>
				       		     		       				       		
				       		  <tr> 
		                          <td rowspan="2" class='title title_border' >보증기간</td>
		                          <td  class='title title_border' rowspan="2">소비자가격(원)</td>
		                          <td  class='title title_border' rowspan="2">구입가격(원)</td>
		      				      <td  class='title title_border' rowspan="2">매각가격(원)</td>
		                          <td  class='title title_border' rowspan="2">누적주행거리(km)</td>
		                          <td  class='title title_border' rowspan="2">사고유무</td>
		                          <td  class='title title_border' rowspan="2">연료</td>
		                          <td  class='title title_border' rowspan="2">색상</td>				  
		                          <td  class='title title_border' colspan="3">상품평가</td>
		                      </tr>
		                      <tr> 
		                          <td class='title title_border ' >자체평가</td>
		                          <td class='title title_border' >평가요인</td>
		                          <td class='title title_border'>담당자</td>
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
				<td style="width: 460px;">
					<div style="width: 460px;">
						<table class="inner_top_table left_fix">	
			<%if(olsb.length !=0 ){%>
		          	    <% for(int i=0; i< olsb.length; i++){
							olsBean = olsb[i];
						%>
		                    <tr style="height: 25px;"> 
		                         <td width=40 class='center content_border'> <input type="checkbox" name="pr" value="<%=olsBean.getCar_mng_id()%>" ></td>
		                         <td width=40 class='center content_border'><%=i+1%></td>
		                         <td width=120 class='center content_border'><a href="javascript:parent.view_detail('<%=auth_rw%>','<%=olsBean.getCar_mng_id()%>')"><%=olsBean.getCar_no()%></a></td>
		                         <td width=160 class='center content_border'><span title='<%=olsBean.getCar_jnm()+" "+olsBean.getCar_nm()%>'>&nbsp;<%=AddUtil.subData(olsBean.getCar_jnm()+" "+olsBean.getCar_nm(),14)%></span></td>
		                         <td width=100 class='center content_border'><%=AddUtil.ChangeDate2(olsBean.getInit_reg_dt())%></td>				  
		                     </tr>    
		                  <%}%>        
			     			<tr>              
			        			 <td class="title content_border" colspan=5 align='center' >합계</td>                    
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

				<%if(olsb.length !=0 ){%>	           
			            <% for(int i=0; i< olsb.length; i++){
									olsBean = olsb[i];
									/*
									int cSum = olsBean.getCar_cs_amt() + olsBean.getCar_cv_amt() + olsBean.getOpt_cs_amt() + olsBean.getOpt_cv_amt()+
											olsBean.getClr_cs_amt() + olsBean.getClr_cv_amt() + olsBean.getSd_cs_amt() + olsBean.getSd_cv_amt() +
											olsBean.getDc_cs_amt() + olsBean.getDc_cv_amt();
									int fSum = olsBean.getCar_fs_amt() + olsBean.getCar_fv_amt() + olsBean.getOpt_fs_amt() + olsBean.getOpt_fv_amt()+
											olsBean.getClr_fs_amt() + olsBean.getClr_fv_amt() + olsBean.getSd_fs_amt() + olsBean.getSd_fv_amt() +
											olsBean.getDc_fs_amt() + olsBean.getDc_fv_amt();
									*/
									int cSum = olsBean.getCar_cs_amt() + olsBean.getCar_cv_amt() + olsBean.getOpt_cs_amt() + olsBean.getOpt_cv_amt()+
											olsBean.getClr_cs_amt() + olsBean.getClr_cv_amt();
									int fSum = olsBean.getCar_fs_amt() + olsBean.getCar_fv_amt() + olsBean.getSd_cs_amt() + olsBean.getSd_cv_amt() -
											olsBean.getDc_cs_amt() - olsBean.getDc_cv_amt();
									totCsum += cSum;
									totFsum += fSum;
							%>
                           <tr style="height: 25px;"> 
	                              <td  width=230 class='center content_border' ><span title='<%=olsBean.getOpt()%>'> <%=AddUtil.ChangeDate2(olsBean.getAss_st_dt())%> 
	                                ~ </span><%=AddUtil.ChangeDate2(olsBean.getAss_ed_dt())%></td>
	                              <td width=120 class='right content_border'><%=AddUtil.parseDecimal(cSum)%>&nbsp;&nbsp;&nbsp;</td>
	                              <td width=120 class='right content_border'><%=AddUtil.parseDecimal(fSum)%>&nbsp;&nbsp;&nbsp;</td>
	            				  <td width=120 class='right content_border'><%=AddUtil.parseDecimal(olsBean.getMm_pr())%>&nbsp;&nbsp;&nbsp;</td>
	                              <td width=120 class='right content_border'><%=AddUtil.parseDecimal(olsBean.getToday_dist())%>&nbsp;&nbsp;&nbsp;</td>
	                              <td width=90 class='center content_border'> 
	                                <%if(olsBean.getAccident_yn().equals("1")){%>
	                                유 
	                                <%}else{%>
	                                - 
	                                <%}%>
	                              </td>
	                              <td width=170 class='center content_border' > 
	                                <%=c_db.getNameByIdCode("0039", "", olsBean.getFuel_kd())%></td>
	                              <td width=80 class='center content_border' ><span title='<%=olsBean.getColo()%>'><%=AddUtil.subData(olsBean.getColo(),5)%></span></td>				  
	                              <td  class='center content_border' width=90>&nbsp; 
	                                <%if(olsBean.getLev().equals("1")){%>
	                                상&nbsp; 
	                                <%}else if(olsBean.getLev().equals("2")){%>
	                                중&nbsp; 
	                                <%}else if(olsBean.getLev().equals("3")){%>
	                                하&nbsp; 
	                                <%}else{%>
	                                &nbsp; 
	                                <%}%>
	                              </td>
	                              <td  class='center content_border' width=120 ><a href='#' title="<%=olsBean.getReason()%>"><%=AddUtil.subData(olsBean.getReason(),8)%></a></td>
	                              <td  width=80 class='center content_border' ><%=c_db.getNameById(olsBean.getDamdang_id(), "USER")%></td>
                            </tr>
                            <%}%>
                            <tr> 
	                              <td  class='title center content_border' >&nbsp;</td>
	                              <td  class='title right content_border'><%=AddUtil.parseDecimal(totCsum)%></td>
	                              <td  class='title right content_border'><%=AddUtil.parseDecimal(totFsum)%></td>
	            				  <td  class='title center content_border'>&nbsp;</td>
	                              <td  class='title right content_border'>&nbsp;</td>
	                              <td  class='title center content_border'>&nbsp;</td>
	                              <td  class='title center content_border'>&nbsp;</td>
	                              <td  class='title center content_border'>&nbsp;</td>
	                              <td  class='title center content_border'>&nbsp;</td>
	                              <td  class='title center content_border'>&nbsp;</td>
	                              <td  class='title center content_border'>&nbsp;</td>
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