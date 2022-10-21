<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="olyBean" class="acar.offls_pre.Offls_preBean" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");

	Offls_preBean olyb[] = olpD.getPre_lst(gubun, gubun_nm,brch_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	int totCsum = 0;
	int totFsum = 0;
	int totOsum = 0;
	
	String actn_cnt = ""; //반출시 경매회차
	
	/*추가 - gill sun */
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String actn_id = olpD.getActn_id(car_mng_id);
	olyBean = olpD.getPre_detail(car_mng_id);
	String car_no = olyBean.getCar_no();
	
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
	
	function open_print(auth_rw,car_mng_id)
	{
		
		var SUBWIN="http://fms1.amazoncar.co.kr/acar/off_ls_after/pjbj.jsp?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id;	
		window.open(SUBWIN, "open_print", "left=100, top=100, width=800, height=800, scrollbars=yes");
	}

	function open_print2(auth_rw,car_mng_id,seq)
		{
		
			var SUBWIN="http://fms1.amazoncar.co.kr/acar/off_ls_after/cpsc.jsp?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&seq="+seq;	
			window.open(SUBWIN, "open_print", "left=100, top=100, width=800, height=800, scrollbars=yes");
		}

	function on_print(car_mng_id)
		{
		
			var SUBWIN="http://fms1.amazoncar.co.kr/acar/off_ls_jh/off_ls_jh_print.jsp?car_mng_id="+car_mng_id;	
			window.open(SUBWIN, "on_print", "left=100, top=100, width=800, height=800, scrollbars=yes");
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
				<td style="width: 540px;">
					<div style="width: 540px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>															
								 <td width='7%' class='title title_border'> <input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'> </td>
		                         <td width='7%' class='title title_border'>연번</td>
		                         <td width='20%' class='title title_border'>위치</td>								
		                         <td width='16%' class='title title_border'>구비서류</td>
		                         <td width='30%' class='title title_border'>차량번호 [탁송신청]</td>
		                         <td width='*' class='title title_border'>차명</td>
							</tr>					
						</table>
					</div>
				</td>
				<td style="width: 1600px;">
					<div style="width: 1600px;">
						<table class="inner_top_table table_layout" style="height: 60px;">						  								
							<colgroup>
					       		  <col  width='10%'> <!--  rowspan -->
					       		  <col  width='8%'>
					       		  <col  width='5%'>
					       		  <col  width='4%'><!--  rowspan -->		       		  
								  <col  width='5%'><!--  rowspan -->
								  <col  width='6%'> <!--  rowspan -->
					       		  <col  width='5%'>
					       		  <col  width='5%'>
					       		  <col  width='7%'><!--  rowspan -->		       		  
								  <col  width='7%'><!--  rowspan -->
								  <col  width='7%'> <!--  rowspan -->
					       		  <col  width='3%'>
					       		  <col  width='7%'>
					       		  <col  width='7%'>		       		  
								  <col  width='5%'>
								  <col  width='5%'>		       				  
								  <col  width='7%'><!--  rowspan -->											  
				       		</colgroup>
			       			
		       				<tr> 
								<td width=10% class='title title_border' rowspan="2">출품경매장</td>
	                            <td width=8% class='title title_border' rowspan="2">선택사양</td>
								<td width=5% class='title title_border' rowspan="2">주행거리<br>(km)</td>
	                            <td width=4% class='title title_border' rowspan="2">배기량<br>(cc)</td>
	                         	<td width=5% class='title title_border' rowspan="2">연료</td>
	                            <td width=6% class='title title_border' rowspan="2">색상</td>
	                            <td width=5% class='title title_border' rowspan="2">최초등록일</td>
						  		<td width=5% class='title title_border' rowspan="2">차령만료일</td>
	                            <td width=7% class='title title_border' rowspan="2">소비자가격(원)</td>
	                            <td width=7% class='title title_border' rowspan="2">구입가격(원)</td>
	                            <td width=7% class='title title_border' rowspan="2">예상낙찰가(원)</td>
	                               
	                            <td width=3% class='title title_border' rowspan="2">사고<br>유무</td>
	                            <td class='title title_border' colspan="4">상품평가</td>
	                            <td width=7% class='title title_border' rowspan="2">관리번호</td>				  
	                           </tr>
	                           <tr> 
	                            <td class='title title_border'  width=7%>자체평가</td>
	                            <td class='title title_border' width=7%>평가요인</td>
	                            <td width=5% class='title title_border'>담당자</td>
	                            <td width=5% class='title title_border'>비고</td>
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
				<td style="width: 540px;">
					<div style="width: 540px;">
						<table class="inner_top_table left_fix">

				<%if(olyb.length !=0 ){%>
				      <% for(int i=0; i< olyb.length; i++){
							olyBean = olyb[i];		
							String p_seq = olaD.getAuctionPur_maxSeq(olyBean.getCar_mng_id());
						%>
			                 <tr style="height: 25px;"> 
			                    <td width='7%' class='center content_border'> <input type="checkbox" name="pr" value="<%=olyBean.getCar_mng_id()%><%=olpD.getDoc_chk(olyBean.getCar_mng_id())%>  <%=olyBean.getCar_no()%><%="("+olyBean.getCar_jnm()+" "+olyBean.getCar_nm()+") "%>" > 
			                    </td>
			                    <td width='7%' class='center content_border'><a href="javascript:on_print('<%=olyBean.getCar_mng_id()%>')"><%=i+1%></a></td>
			                    <td width='20%' class='center content_border'><%=olyBean.getPark()%><%if(!olyBean.getKm().equals("0")&&!olyBean.getKm().equals("")&&!olyBean.getCar_out_dt().equals("")){%><font color="red">[완료]</font><%}%></td>								
			                    <td width='16%' class='center content_border'>
								<%if(olpD.getDoc_chk(olyBean.getCar_mng_id()).equals("Y")){%>
			                    완료 &nbsp;<a href="javascript:open_print('<%=auth_rw%>','<%=olyBean.getCar_mng_id()%>')"><img src=../images/center/button_in_print.gif align=absmiddle border=0>
			                    <%}else{%>
			                    미비 &nbsp;<a href="javascript:open_print('<%=auth_rw%>','<%=olyBean.getCar_mng_id()%>')"><img src=../images/center/button_in_print.gif align=absmiddle border=0>
			                    <%}%>
								</td>
			                    <td width='30%' class='center content_border'>
									<%//	if ( !actn_id.equals("004242") && !actn_id.equals("003226")  && !actn_id.equals("011723") ) {%>
										<a href="javascript:open_print2('<%=auth_rw%>','<%=olyBean.getCar_mng_id()%>','<%=p_seq%>')">.</a>
									<%// 	}%>
									<a href="javascript:parent.view_detail('<%=auth_rw%>','<%=olyBean.getCar_mng_id()%>')">
									<%if(olyBean.getA_cnt() < 1 ){//수해경력없음%>
									<%=olyBean.getCar_no()%>
									<%	}else{//수해차량%>			  
									<font color="#ff8200"><%=olyBean.getCar_no()%></font> 						
									<%	}%>	 </a>&nbsp;
									<%if(!olyBean.getCons_dt().equals("")){%>[<%=olyBean.getCons_dt()%>]  <% } %>
								</td>          
			                    <td width='*' class='left content_border'><a href="javascript:parent.view_car('', '', '<%=olyBean.getCar_mng_id()%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'><span title='<%=olyBean.getCar_jnm()+" "+olyBean.getCar_nm()%>'>&nbsp;<%=AddUtil.subData(olyBean.getCar_jnm()+" "+olyBean.getCar_nm(),8)%></span></a>
								</td>
			                </tr>
			   			 <%}%>	
			    				<tr> 
						           <td  class='title content_border' colspan='6'>&nbsp;</td>
						        </tr>
					 <%} else  {%>  
				              	<tr>
						            <td class='center content_border'>등록된 데이타가 없습니다</td>
						        </tr>	              
				 <%}	%>
				        </table>
				     </div>
				 </td>	 	
        
     			 <td style="width: 1600px;">	
		   			<div style="width: 1600px;">
						<table class="inner_top_table table_layout" >
	       	
							<%if(olyb.length !=0 ){%>
				                  <% for(int i=0; i< olyb.length; i++){
							olyBean = olyb[i];
							/*
							int cSum = olyBean.getCar_cs_amt() + olyBean.getCar_cv_amt() + olyBean.getOpt_cs_amt() + olyBean.getOpt_cv_amt()+
									olyBean.getClr_cs_amt() + olyBean.getClr_cv_amt() + olyBean.getSd_cs_amt() + olyBean.getSd_cv_amt() +
									olyBean.getDc_cs_amt() + olyBean.getDc_cv_amt();
							int fSum = olyBean.getCar_fs_amt() + olyBean.getCar_fv_amt() + olyBean.getOpt_fs_amt() + olyBean.getOpt_fv_amt()+
									olyBean.getClr_fs_amt() + olyBean.getClr_fv_amt() + olyBean.getSd_fs_amt() + olyBean.getSd_fv_amt() +
									olyBean.getDc_fs_amt() + olyBean.getDc_fv_amt();
							*/
							int cSum = olyBean.getCar_cs_amt() + olyBean.getCar_cv_amt() + olyBean.getOpt_cs_amt() + olyBean.getOpt_cv_amt()+
									olyBean.getClr_cs_amt() + olyBean.getClr_cv_amt();
							int fSum = olyBean.getCar_fs_amt() + olyBean.getCar_fv_amt() + olyBean.getSd_cs_amt() + olyBean.getSd_cv_amt() -
									olyBean.getDc_cs_amt() - olyBean.getDc_cv_amt();
							totCsum += cSum;
							totFsum += fSum;
							
							
							//반출여부
							actn_cnt = olpD.getCar_mng_id_ban(olyBean.getCar_mng_id());
							
							//차량정보
							Hashtable sh_ht = shDb.getShBase(olyBean.getCar_mng_id());	
					
							int o_s_amt = olpD.getOffls_pre_o_s_amt(olyBean.getCar_mng_id());
							
							totOsum += o_s_amt;
						
					%>
                             <tr style="height: 25px;">  
						  	  <td width='10%' class='center content_border' ><%=AddUtil.subData(olaD.getActn_nm(olyBean.getActn_id()),9)%></td>
                              <td width='8%' class='center content_border' ><span title='<%=olyBean.getOpt()%>'> 
                                <%=AddUtil.subData(olyBean.getOpt(), 7)%></span></td>
							  <td width='5%' class='right content_border'><%=AddUtil.parseDecimal(olyBean.getToday_dist())%>&nbsp;&nbsp;</td>
                              <td width='4%' class='center content_border' ><%=AddUtil.parseDecimal(olyBean.getDpm())%></td>
                              <td width='5%' class='center content_border' ><%=c_db.getNameByIdCode("0039", "", olyBean.getFuel_kd())%></td>
                              <td width='6%' class='center content_border' ><span title='<%=olyBean.getColo()%>'><%=AddUtil.subData(olyBean.getColo(),4)%></span></td>
                              <td width='5%' class='center content_border'><%=AddUtil.ChangeDate2(olyBean.getInit_reg_dt())%></td>
							  <td width='5%' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(sh_ht.get("CAR_END_DT")))%></td>
                              <td width='7%' class='right content_border'><%=AddUtil.parseDecimal(cSum)%>&nbsp;&nbsp;</td>
                              <td width='7%' class='right content_border'><%=AddUtil.parseDecimal(fSum)%>&nbsp;&nbsp;</td>
                              <td width='7%' class='right content_border'><%=AddUtil.parseDecimal(o_s_amt)%>&nbsp;&nbsp;</td>                              
                              <td width='3%' class='center content_border'> 
                                <%if(olyBean.getAccident_yn().equals("1")){%>
                                유 
                                <%}else{%>
                                - 
                                <%}%>
                              </td>
                              <td  class='center content_border' width="7%">&nbsp; 
                                <%if(olyBean.getLev().equals("1")){%>
                                상&nbsp; 
                                <%}else if(olyBean.getLev().equals("2")){%>
                                중&nbsp; 
                                <%}else if(olyBean.getLev().equals("3")){%>
                                하&nbsp; 
                                <%}else{%>
                                &nbsp; 
                                <%}%>
                              </td>
                              <td  class='center content_border' width="7%" ><a href='#' title="<%=olyBean.getReason()%>"><%=AddUtil.subData(olyBean.getReason(),8)%></a></td>
                              <td width='5%%' class='center content_border' ><%=c_db.getNameById(olyBean.getDamdang_id(), "USER")%></td>
                              <td width='5%' class='center content_border' ><%if(!actn_cnt.equals("")){%>반출<%}%></td>
            				  <td width='7%' class='center content_border'><%=olyBean.getCar_doc_no()%></td>
                            </tr>
                <%}%>
                            <tr> 
                              <td  class='title content_border center'  colspan='8'  >&nbsp;</td>							
                              <td  class='title content_border right'><%=AddUtil.parseDecimal(totCsum)%>&nbsp;</td>
                              <td  class='title content_border right'><%=AddUtil.parseDecimal(totFsum)%>&nbsp;</td>
                              <td  class='title content_border right'><%=AddUtil.parseDecimal(totOsum)%>&nbsp;</td>
                              <td  class='title content_border center'  colspan='6'  >&nbsp;</td>	
                           			  
                            </tr>
                	<%} else  {%>  
			              	<tr>
					             <td  colspan="17" class='center content_border'>&nbsp;</td>
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