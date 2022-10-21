<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*, acar.user_mng.*"%>
<jsp:useBean id="auction" class="acar.offls_actn.Offls_auctionBean" scope="page"/>
<jsp:useBean id="auction_ban" class="acar.offls_actn.Offls_auction_banBean" scope="page"/>
<jsp:useBean id="olaBean" class="acar.offls_actn.Offls_actnBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
 	//chrome 관련 
 	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	Offls_actnBean olab[] = olaD.getActn_lst(dt, ref_dt1, ref_dt2, gubun, gubun_nm,brch_id, s_au);
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	long totCsum = 0;
	long totFsum = 0;
	long tot3sum = 0;
	long tot4sum = 0;
	long tot5sum = 0;
	
	String admin_yn = "";
	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("매각관리자",ck_acar_id)){
		admin_yn = "Y";
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
	
	function open_print(auth_rw,car_mng_id,seq) {
		var SUBWIN="/acar/off_ls_after/cpsc.jsp?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&seq="+seq;	
		window.open(SUBWIN, "open_print", "left=100, top=100, width=800, height=800, scrollbars=yes");
	}
	
	function on_print(car_mng_id) {
		var SUBWIN="./off_ls_jh_print.jsp?car_mng_id="+car_mng_id;	
		window.open(SUBWIN, "on_print", "left=100, top=100, width=800, height=800, scrollbars=yes");
	}	

	function print_open(auth_rw,car_mng_id, jh) {
		var SUBWIN="/acar/off_ls_after/pjbj.jsp?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&cmd="+jh;	
		window.open(SUBWIN, "print_open", "left=100, top=100, width=800, height=800, scrollbars=yes");
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


<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 830px;">
					<div style="width: 830px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							  <td width=30 class='title title_border' style='height:45'> <input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'></td>
	                          <td width=30 class='title title_border'>연번</td>
	                          <td width=40 class='title title_border' >구분</td>
	                          <td width=75 class='title title_border'>진행상태</td>
	                          <td width=180 class='title title_border'>경매장</td>
							  <td width=75 class='title title_border'>위치</td>
							  <td width=80 class='title title_border'>탁송신청</td>
	                          <td width=100 class='title title_border'>차량번호</td>
	                          <td width=140 class='title title_border'>차명</td>
	                          <td width=80 class='title title_border' >경매일자</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							<colgroup>
				       		  <col  width='80'>
				       		  <col  width='90'>
				       		  <col  width='90'>
				       		  <col  width='90'> <!--  rowspan -->
				       		  
							  <col  width='90'>
							  <col  width='90'> 
							  <col  width='90'>
							   
							  <col  width='50'>
							  <col  width='70'>
							  <col  width='30'>
							  <col  width='100'>
							  <col  width='60'>
							  <col  width='100'>
							  <col  width='90'>
							  
							  <col  width='60'>
							  <col  width='100'>
							  <col  width='60'>					  							  
				       		</colgroup>
		       				       		
				       		<tr> 
				       		 	 <td width=80 class='title title_border'  rowspan="2" >최초등록일</td>		
		                         <td width=90 class='title title_border' rowspan="2">소비자가격(원)</td>
		                         <td width=90 class='title title_border' rowspan="2">구입가격(원)</td>
		                         <td width=90 class='title title_border' rowspan="2">예상낙찰가</td>
		                         <td colspan="3" class='title title_border'>희망가</td>
		                         <td width=50 class='title title_border' rowspan="2">연식</td>
		                         <td width=70 class='title title_border' rowspan="2">주행거리<br>(km)</td>
		                         <td width=30 class='title title_border' rowspan="2">사고<br>유무</td>
		                         <td width=100 class='title title_border' rowspan="2">선택사양</td>
		                         <td width=60 class='title title_border' rowspan="2">배기량<br>(cc)</td>
		                         <td width=100 class='title title_border' rowspan="2">연료</td>
		                         <td width=90 class='title title_border' rowspan="2">색상</td>				  
		                         <td class='title title_border' colspan="3">상품평가</td>
		                     </tr>
		                     <tr> 
		                         <td class='title title_border' width=90>가격(원)</td>
		                         <td class='title title_border' width=90>소비자가대비</td>
		                         <td class='title title_border' width=90>구입가대비</td>				  
		                         <td class='title title_border' width=60>자체평가</td>
		                         <td class='title title_border' width=100>평가요인</td>
		                         <td class='title title_border' width=60>담당자</td>
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
				<td style="width: 830px;">
					<div style="width: 830px;">
						<table class="inner_top_table left_fix">	    

			<%if(olab.length !=0 ){%>
	     		 <% for(int i=0; i< olab.length; i++){
					olaBean = olab[i];
					String seq = olaD.getAuction_maxSeq(olaBean.getCar_mng_id());
					String p_seq = olaD.getAuctionPur_maxSeq(olaBean.getCar_mng_id());
					auction = olaD.getAuction(olaBean.getCar_mng_id(), seq);
					auction_ban = olaD.getAuction_ban(olaBean.getCar_mng_id(), auction.getActn_cnt());
				%>
                            <tr style="height: 25px;"> 
                              <td width=30 class='center content_border'> <input type="checkbox" id="pr_<%=i%>" name="pr" value="<%=olaBean.getCar_mng_id()+olaBean.getActn_st()%>" ></td>
                              <td width=30 class='center content_border'><a href="javascript:on_print('<%=olaBean.getCar_mng_id()%>')"><%=i+1%></a></td>
                              <td width=40 class='center content_border'> 
                                <%if(olaBean.getOff_ls().equals("3")){%>
                                경매 
                                <%}else if(olaBean.getOff_ls().equals("4")){%>
                                소매 
                                <%}else if(olaBean.getOff_ls().equals("5")){%>
                                수의 
                                <%}%>
                              </td>
                              <td width=75 class='center content_border'> 
                                <%if(olaBean.getActn_st().equals("0")){%>
                                출품예정 
                                <%}else if(olaBean.getActn_st().equals("1")){%>
                                경매진행중 
                                <%}else if(olaBean.getActn_st().equals("2")){
            				if(auction_ban.getCar_mng_id().equals("")){%>
                                유찰 
                                <%	}else{%>
                                반출진행중 
                                <%	}%>
                                <%}else if(olaBean.getActn_st().equals("3")){%>
                                개별상담중 
                                <%}else if(olaBean.getActn_st().equals("4")){%>
                                낙찰 
                                <%}%>
                              </td>
                              <td width=180 class='center content_border'><span title='<%=olaD.getActn_nm(olaBean.getActn_id())%>'><%=AddUtil.subData(olaD.getActn_nm(olaBean.getActn_id()),8)%>&nbsp;<%=olaBean.getActn_wh()%></span>
							  &nbsp;
							  <a href="javascript:print_open('<%=auth_rw%>','<%=olaBean.getCar_mng_id()%>','jh')">P</a>
						      </td>							
						      <td width=75 class='center content_border'><%=olaBean.getPark_nm()%></td>							  
						      <td width=80 class='center content_border'><%=olaBean.getCons_dt()%></td>
			                  <td width=100 class='center content_border'>
                                <!-- 출품신청서 : 글로비스만 할것 -->
                                <%if(admin_yn.equals("Y")){%>
				                <%	if ( !olaBean.getActn_id().equals("004242") && !olaBean.getActn_id().equals("003226")  && !olaBean.getActn_id().equals("011723") ) {%>
				                	<a href="javascript:open_print('<%=auth_rw%>','<%=olaBean.getCar_mng_id()%>','<%=p_seq%>')">.</a>
				                <% 	}%>
				                <%}%>
				                &nbsp;
                                <a href="javascript:parent.view_detail('<%=auth_rw%>','<%=olaBean.getCar_mng_id()%>','<%=seq%>')">
								<%if(olaBean.getA_cnt() < 1 ){//수해경력없음%>
								<%=olaBean.getCar_no()%>
								<%	}else{//수해차량%>			  
								<font color="#ff8200"><%=olaBean.getCar_no()%></font> 						
								<%	}%>
				                </a>
				                &nbsp;
                                <!-- 중고차매각현황 : 엑셀 참조값-->
				                <%if(admin_yn.equals("Y")){%>
				                <a href="javascript:parent.view_detail_s('<%=auth_rw%>','<%=olaBean.getCar_mng_id()%>','<%=seq%>')">.</a>
				                <%}%>
			   			      </td>
                              <td width=140 class='center content_border'><a href="javascript:parent.view_car('', '', '<%=olaBean.getCar_mng_id()%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'><span title='<%=olaBean.getCar_jnm()+" "+olaBean.getCar_nm()%>'>&nbsp;<%=AddUtil.subData(olaBean.getCar_jnm()+" "+olaBean.getCar_nm(),10)%></span></a></td>
                              <td width=80 class='center content_border'><%=AddUtil.ChangeDate2(olaBean.getActn_dt())%></td>	
                              
                            </tr>
			                <%}%>
			       	  		<tr>              
			        			<td class="title content_border" colspan=10 align='center' >합계</td>                    
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
		  
    	  <%if(olab.length !=0 ){%> 
                 <% for(int i=0; i< olab.length; i++){
								olaBean = olab[i];
								/*
								int cSum = olaBean.getCar_cs_amt() + olaBean.getCar_cv_amt() + olaBean.getOpt_cs_amt() + olaBean.getOpt_cv_amt()+
										olaBean.getClr_cs_amt() + olaBean.getClr_cv_amt() + olaBean.getSd_cs_amt() + olaBean.getSd_cv_amt() +
										olaBean.getDc_cs_amt() + olaBean.getDc_cv_amt();
								int fSum = olaBean.getCar_fs_amt() + olaBean.getCar_fv_amt() + olaBean.getOpt_fs_amt() + olaBean.getOpt_fv_amt()+
										olaBean.getClr_fs_amt() + olaBean.getClr_fv_amt() + olaBean.getSd_fs_amt() + olaBean.getSd_fv_amt() +
										olaBean.getDc_fs_amt() + olaBean.getDc_fv_amt();
								*/
								int cSum = olaBean.getCar_cs_amt() + olaBean.getCar_cv_amt() + olaBean.getOpt_cs_amt() + olaBean.getOpt_cv_amt()+
										   olaBean.getClr_cs_amt() + olaBean.getClr_cv_amt();
								int fSum = olaBean.getCar_fs_amt() + olaBean.getCar_fv_amt() + olaBean.getSd_cs_amt() + olaBean.getSd_cv_amt() -
										   olaBean.getDc_cs_amt() - olaBean.getDc_cv_amt();
								totCsum += cSum;
								totFsum += fSum;
								int carpr = olaBean.getCar_cs_amt()+olaBean.getCar_cv_amt()+olaBean.getOpt_cs_amt()+olaBean.getOpt_cv_amt()+olaBean.getClr_cs_amt()+olaBean.getClr_cv_amt();
								double hppr = olaBean.getHppr();
								double stpr = olaBean.getStpr();
								double hppr_per = (hppr*100)/carpr;
								tot3sum += olaBean.getHppr();			
								tot5sum += olaBean.getO_s_amt();
								
								String km = AddUtil.parseDecimal(olaBean.getKm());
								String dist = AddUtil.parseDecimal(olaBean.getToday_dist());
								int kkk = AddUtil.parseInt(olaBean.getKm())-olaBean.getToday_dist();
						%>               
                            <tr style="height: 25px;"> 
                              <td width=80 class='center content_border'><%=AddUtil.ChangeDate2(olaBean.getInit_reg_dt())%></td>			  
                              <td width=90 class='right content_border'><%=AddUtil.parseDecimal(cSum)%>&nbsp;</td>
                              <td width=90 class='right content_border'><%=AddUtil.parseDecimal(fSum)%>&nbsp;</td>
                              <td width=90 class='right content_border'><%=AddUtil.parseDecimal(olaBean.getO_s_amt())%>&nbsp;</td>
                              <td width=90 class='right content_border'><%=AddUtil.parseDecimal(olaBean.getHppr())%>&nbsp;</td>
                              <td width=90 class='right content_border'><%=AddUtil.parseDecimal(hppr_per)%>%&nbsp;</td>
                              <td width=90 class='right content_border'><%=AddUtil.parseDecimal((hppr*100)/fSum)%>%&nbsp;</td>				  
                              <td width=50 class='center content_border'><%=olaBean.getCar_y_form()%></td>				  
                              <td width=70 class='right content_border' <%if(kkk == 0 || Math.abs(kkk) > 30000 )%>style="color:red;"<% %>><%=AddUtil.parseDecimal(olaBean.getKm())%>
							  <%if(olaBean.getKm().equals("")){%><%=AddUtil.parseDecimal(olaBean.getToday_dist())%><%}%>&nbsp;</td>
								<input type="hidden" id="km_<%=i%>" name="km" value="<%=kkk%>">
                              <td width=30 class='center content_border'> <%if(olaBean.getAccident_yn().equals("1")){%>
                                유 
                                <%}else{%>
                                - 
                              <%}%>&nbsp;</td>
                              <td width=100 class='center content_border' ><span title='<%=olaBean.getOpt()%>'><%=AddUtil.subData(olaBean.getOpt(), 7)%></span></td>
                              <td width=60 class='center content_border' ><%=AddUtil.parseDecimal(olaBean.getDpm())%></td>
                              <td width=100 class='center content_border' ><%=c_db.getNameByIdCode("0039", "", olaBean.getFuel_kd())%></td>
                              <td width=90 class='center content_border' ><span title='<%=olaBean.getColo()%>'><%=AddUtil.subData(olaBean.getColo(),4)%></span></td>					
                              <td  class='center content_border' width=60><%if(olaBean.getLev().equals("1")){%>
				                                상&nbsp; <%}else if(olaBean.getLev().equals("2")){%>
				                                중&nbsp; <%}else if(olaBean.getLev().equals("3")){%>
				                                하&nbsp; <%}else{%> &nbsp; <%}%> 
            				  </td>
                              <td class='center content_border' width=100 ><a href='#' title="<%=olaBean.getReason()%>"><%=AddUtil.subData(olaBean.getReason(),8)%></a>
							  <%=AddUtil.subData(c_db.getNameById(olaBean.getCpt_cd(),"BANK"),5)%>
							  </td>
                              <td width=60 class='center content_border' ><%=c_db.getNameById(olaBean.getDamdang_id(), "USER")%></td>
                         </tr>
                <%}%>
                
                         <tr> 
                              <td class='title content_border'> &nbsp;</td>
                              <td class='title content_border right'><%=AddUtil.parseDecimal(totCsum)%>&nbsp;</td>
                              <td class='title content_border right'><%=AddUtil.parseDecimal(totFsum)%>&nbsp;</td>
                              <td class='title content_border right'><%=AddUtil.parseDecimal(tot5sum)%>&nbsp;</td>                              
                              <td class='title content_border right'><%=AddUtil.parseDecimal(tot3sum)%>&nbsp;</td>                              
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
                              <td class='title content_border'>&nbsp;</td>
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