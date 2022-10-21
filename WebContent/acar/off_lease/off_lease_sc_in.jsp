<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_yb.*"%>
<%@ page import="acar.common.*, acar.user_mng.*"%>
<jsp:useBean id="olyBean" class="acar.offls_yb.Offls_ybBean" scope="page"/>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String gubun2 = request.getParameter("gubun2")==null?"N":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"all":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"asc":request.getParameter("gubun5");
	String cjgubun = request.getParameter("cjgubun")==null?"all":request.getParameter("cjgubun");
	
	Offls_ybBean olyb[] = olyD.getYb_lst(gubun,gubun_nm,brch_id,gubun2,gubun3,gubun4,gubun5,cjgubun);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	long totCsum = 0;
	long totFsum = 0;
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
 	//chrome 관련 
 	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	String mng_mode = ""; 
	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id) || nm_db.getWorkAuthUser("지점장",ck_acar_id) || nm_db.getWorkAuthUser("본사관리팀장",ck_acar_id)){
		mng_mode = "A";
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
	
	function view_ncar_spe_dc(car_mng_id){
		var fm = document.form1;
		fm.car_mng_id.value = car_mng_id;
		window.open('about:blank', "SPEDC", "left=0, top=0, width=650, height=300, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "SPEDC";
		fm.action = "newcar_special_discount_i.jsp";
		fm.submit();			
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
<input type="hidden" name="from_page" value="/acar/off_lease/off_lease_frame.jsp">
<input type="hidden" name="car_mng_id" value="">

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 622px;">
					<div style="width: 623px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							  	<td width='40' class='title title_border' style='height:45'> <input type="checkbox" name="all_pr" value="Y" onclick='javascript:AllSelect(this.form.pr)'></td>
								<td width='40' class='title title_border'>연번</td>
								<td width='70' class='title title_border'>재리스</td>
								<td width='100' class='title title_border'>현위치</td>
								<td width='80' class='title title_border'>구분</td>
								<td width='82' class='title title_border'>내용</td>								
								<td width='100' class='title title_border'>차량번호</td>
								<td width='110' class='title title_border'>차명</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
						  	<colgroup>
				       		  <col  width='100'> <!--  rowspan -->
				       		  <col  width='60'>
				       		  <col  width='79'>
				       		  <col  width='98'><!--  rowspan -->		       		  
							  <col  width='40'><!--  rowspan -->
							  <col  width='43'> <!--  rowspan -->
				       		  <col  width='40'>
				       		  <col  width='90'>
				       		  <col  width='90'><!--  rowspan -->		       		  
							  <col  width='100'><!--  rowspan -->
							  <col  width='100'> <!--  rowspan -->
				       		  <col  width='80'>
				       		  <col  width='42'>
				       		  <col  width='79'><!--  rowspan -->		       		  
							  <col  width='75'><!--  rowspan -->
							  <col  width='59'>		       				  
							  <col  width='95'><!--  rowspan -->
												  
				       		</colgroup>
				       		       		       				       		
			       			<tr> 
									<td width='100' class='title title_border' rowspan="2" style='height:48'>선택사양</td>
									<td width='60' class='title title_border' rowspan="2">배기량</td>
									<td width='79' class='title title_border' rowspan="2">연료</td>
									<td width='98' class='title title_border' rowspan="2">색상</td>
									<td width='40' class='title title_border' rowspan="2">자산<br>양수</td>
									<td width='43' class='title title_border' rowspan="2">GPS</td>								
									<td width='40' class='title title_border' rowspan="2">차령</td>								
									<td width='90' class='title title_border' rowspan="2">최초등록일</td>
									<td width='90' class='title title_border' rowspan="2">차령만료일</td>
									<td width='100' class='title title_border' rowspan="2">소비자가격</td>
									<td width='100' class='title title_border' rowspan="2">구입가격</td>
									<td width='80' class='title title_border' rowspan="2">주행거리</td>
									<td width='42' class='title title_border' rowspan="2">사고<br>유무</td>
									<td  class='title title_border' colspan="3">상품평가</td>
									<td width='95' class='title title_border' rowspan="2">피보험자</td>								
								</tr>
								<tr> 
									<td class='title title_border' width="79">자체평가</td>
									<td class='title title_border' width="75">평가요인</td>
									<td width='59' class='title title_border'>담당자</td>
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
				<td style="width: 622px;">
					<div style="width: 623px;">
						<table class="inner_top_table left_fix">
       		<%if(olyb.length !=0 ){%>
			<% for(int i=0; i< olyb.length; i++){
								olyBean = olyb[i];
							%>
							 <tr style="height: 25px;">  
								<td width='40' class='center content_border'> 
								  <% if(!olyBean.getPrepare().equals("미회수") && !olyBean.getPrepare().equals("말소")){ %> 
								  <input type="checkbox" name="pr" value="<%=olyBean.getCar_mng_id()%>" >
								  <%}%>
								</td>
								<td width='40' class='center content_border'><%=i+1%></td>
								<td width='70' class='center content_border'> 
	                    		<% if(olyBean.getSecondhand().equals("1")){  %>
									Y
									<%} %>
									&nbsp;<a href="javascript:parent.view_detail_sh('<%=auth_rw%>','<%=olyBean.getCar_mng_id()%>','<%=olyBean.getRent_mng_id()%>','<%=olyBean.getRent_l_cd()%>','<%=olyBean.getJg_code()%>')" title='견적하기'>SH</a>
									
									<%if(mng_mode.equals("A")){%>
									<% if(!olyBean.getRm_yn().equals("N")){ 
									out.print("월");
									} %>
									<%}%>
	                  			</td>
								<td width='100' class='center content_border'>
								  	<% if(olyBean.getPrepare().equals("예비")){ %> 
				                    	<a href="javascript:chang_prepare('<%=olyBean.getCar_mng_id()%>')"><%=olyBean.getPark_nm()%></a>
									<% }else{ %>
										<span title='<%=olyBean.getPark_cont()%>'><%=olyBean.getPark_nm() %></span>&nbsp;
									<% } %>
	                  			</td>
	             				 <td width='80' class='center content_border'>
	             				    <!--특별할인 있으면-->
	             				    <%if(AddUtil.parseInt(olyBean.getNcar_spe_dc_amt())>0){ %>
	             				       <a href="javascript:view_ncar_spe_dc('<%=olyBean.getCar_mng_id()%>')"><font color=red>특별할인</font></a>
	             				    <%}else{%> 
								  	<% if(olyBean.getPrepare().equals("예비")){ %> 
				                    	<a href="javascript:chang_prepare('<%=olyBean.getCar_mng_id()%>')"><%=olyBean.getPrepare()%></a>
									<% }else{ %>
										<span title='<%=olyBean.getPark_cont()%>'></span>&nbsp;<%=olyBean.getPrepare()%>
									<% } %>
									<%} %>
									<%if(ck_acar_id.equals("000029") && AddUtil.parseInt(olyBean.getSpe_dc_per())>0){ %>
	             				       <font color=red>SD</font>
	             				    <%}%> 
	                  			</td>
								<td width='82' class='center content_border'><%= olyBean.getRent_st_nm() %></td> 
								<td width='100' class='center content_border'><a href="javascript:parent.view_detail('<%=auth_rw%>','<%=olyBean.getCar_mng_id()%>')"><%=olyBean.getCar_no()%></a></td>
								<td width='110' class='center content_border'><span title='<%=olyBean.getCar_jnm()+" "+olyBean.getCar_nm()%>'>&nbsp;<%=AddUtil.subData(olyBean.getCar_jnm()+" "+olyBean.getCar_nm(),6)%></span></td>
							</tr>
                			<%}%>
                			<tr> 
			                  <td  class='title content_border' colspan='8'>&nbsp;</td>
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
				%>
							 <tr style="height: 25px;"> 
								<td width='100' class='center content_border' ><span title='<%=olyBean.getOpt()%>'> <%=AddUtil.subData(olyBean.getOpt(), 6)%></span></td>
								<td width='60' class='center content_border' ><%=AddUtil.parseDecimal(olyBean.getDpm())%>cc</td>
								<td width='79' class='center content_border' ><%=c_db.getNameByIdCode("0039", "", olyBean.getFuel_kd())%></td>
								<td width='98' class='center content_border' ><span title='<%=olyBean.getColo()%>'><%=AddUtil.subData(olyBean.getColo(),4)%></span></td>
								<td width='40' class='center content_border'><% 	if(olyBean.getCar_gu().equals("중고차")){%>○<%}%></td>
								<td width='43' class='center content_border'><%=olyBean.getGps()%></td>
								<td width='40' class='center content_border'><%=olyBean.getUse_mon()%></td>								
								<td width='90' class='center content_border'><%=AddUtil.ChangeDate2(olyBean.getInit_reg_dt())%></td>
								<td width='90' class='center content_border'><%=AddUtil.ChangeDate2(olyBean.getCar_end_dt())%></td>								
								<td width='100' class='right content_border'><%=AddUtil.parseDecimal(cSum)%>&nbsp;</td>
								<td width='100' class='right content_border'><%=AddUtil.parseDecimal(fSum)%>&nbsp;</td>
								<td width='80' class='right content_border'><%=AddUtil.parseDecimal(olyBean.getToday_dist())%>km&nbsp;</td>
								<td width='42' class='center content_border'><%if(olyBean.getAccident_yn().equals("1")){%>유<%}else{%>-<%}%></td>
								<td  class='center content_border' width="79">&nbsp;
									<%if(olyBean.getLev().equals("1")){%>상&nbsp;
										<%}else if(olyBean.getLev().equals("2")){%>중&nbsp;
										<%}else if(olyBean.getLev().equals("3")){%>하&nbsp;
										<%}else{%>&nbsp;
										<%}%>
								</td>
								<td  class='center content_border' width="75" ><a href='#' title="<%=olyBean.getReason()%>"><%=AddUtil.subData(olyBean.getReason(),8)%></a></td>
								<td width='59' class='center content_border' ><%=c_db.getNameById(olyBean.getDamdang_id(), "USER")%></td>
								<td width='95' class='center content_border'><span title="<%=olyBean.getCon_f_nm()%>"><%=AddUtil.subData(olyBean.getCon_f_nm(),4)%></span></td>								
							</tr>
         					<%}%>
							<tr> 
								<td  class='title content_border' colspan='9'>&nbsp;</td>
								<td  class='title content_border right' ><%=AddUtil.parseDecimal(totCsum)%>&nbsp;</td>
								<td  class='title content_border right' '><%=AddUtil.parseDecimal(totFsum)%>&nbsp;</td>
								<td  class='title content_border' colspan='6'>&nbsp;</td>								
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