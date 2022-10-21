<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=off_ls_jh_excel_list.xls");
%>

<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
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
	
	Offls_actnBean olab[] = olaD.getActn_lst(dt, ref_dt1, ref_dt2, gubun, gubun_nm,brch_id, s_au);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	long totCsum = 0;
	long totFsum = 0;
	long tot3sum = 0;
	long tot4sum = 0;
	long tot5sum = 0;
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--

-->
</script>
</head>
<body>
<form name="form1">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">

<table border=0 cellspacing=0 cellpadding=0 width="2110">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td colspan=2 class=line2></td>
                </tr>
	            <tr id='tr_title' style='position:relative;z-index:1'>		
                    <td class='line' id='td_title' style='position:relative;' width=900> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                
                                <td width=30 class='title'>연번</td>
                                <td width=40 class='title' >구분</td>
                                <td width=75 class='title'>진행상태</td>
                                <td width=180 class='title'>경매장</td>
								<td width=75 class='title'>위치</td>
								<td width=80 class='title'>탁송신청</td>
                                <td width=90 class='title'>차량번호</td>
                                <td width=140 class='title'>차명</td>
                                <td width=80 class='title' rowspan="2">경매일자</td>
                                <td width=80 class='title' rowspan="2">최초등록일</td>				  
                            </tr>
                        </table>
                    </td>		
                    <td class='line' width=1210>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width=90 class='title' rowspan="2">소비자가격(원)</td>
                                <td width=90 class='title' rowspan="2">구입가격(원)</td>
                                <td width=90 class='title' rowspan="2">예상낙찰가</td>
                                <td colspan="3" class='title'>희망가</td>
                                <td width=50 class='title' rowspan="2">연식</td>
                                <td width=70 class='title' rowspan="2">주행거리<br>(km)</td>
                                <td width=30 class='title' rowspan="2">사고<br>유무</td>
                                <td width=100 class='title' rowspan="2">선택사양</td>
                                <td width=60 class='title' rowspan="2">배기량<br>(cc)</td>
                                <td width=100 class='title' rowspan="2">연료</td>
                                <td width=80 class='title' rowspan="2">색상</td>				  
                                <td class='title' colspan="3">상품평가</td>
                            </tr>
                            <tr> 
                                <td class='title' width=90>가격(원)</td>
                                <td class='title' width=90>소비자가대비</td>
                                <td class='title' width=90>구입가대비</td>				  
                                <td class='title' width=70>자체평가</td>
                                <td class='title' width=100>평가요인</td>
                                <td class='title' width=60>담당자</td>
                            </tr>
                        </table>
                    </td>
	            </tr>
<%if(olab.length !=0 ){%>
	            <tr>
                    <td class='line' id='td_con' style='position:relative;' width=900> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100% >
                <% for(int i=0; i< olab.length; i++){
		olaBean = olab[i];
		String seq = olaD.getAuction_maxSeq(olaBean.getCar_mng_id());
		String p_seq = olaD.getAuctionPur_maxSeq(olaBean.getCar_mng_id());
		auction = olaD.getAuction(olaBean.getCar_mng_id(), seq);
		auction_ban = olaD.getAuction_ban(olaBean.getCar_mng_id(), auction.getActn_cnt());
	%>
                            <tr> 
                              <td width=30 align='center'><%=i+1%></td>
                              <td width=40 align='center'> 
                                <%if(olaBean.getOff_ls().equals("3")){%>
                                경매 
                                <%}else if(olaBean.getOff_ls().equals("4")){%>
                                소매 
                                <%}else if(olaBean.getOff_ls().equals("5")){%>
                                수의 
                                <%}%>
                              </td>
                              <td width=75 align='center'> 
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
                              <td width=180 align='center'><%=olaD.getActn_nm(olaBean.getActn_id())%></td>							
			      <td width=75 align='center'><%=olaBean.getPark_nm()%></td>							  
			      <td width=80 align='center'><%=olaBean.getCons_dt()%></td>
                              <td width=90 align='center'>
                                
								<%if(olaBean.getA_cnt() < 1 ){//수해경력없음%>
								<%=olaBean.getCar_no()%>
								<%	}else{//수해차량%>			  
								<font color="#ff8200"><%=olaBean.getCar_no()%></font> 						
								<%	}%>
				
			      </td>
                              <td width=140 ><%=olaBean.getCar_jnm()+" "+olaBean.getCar_nm()%></td>
                              <td width=80 align='center'><%=AddUtil.ChangeDate2(olaBean.getActn_dt())%></td>	
                              <td width=80 align='center'><%=AddUtil.ChangeDate2(olaBean.getInit_reg_dt())%></td>			  
                            </tr>
                <%}%>
                            <tr> 
                              <td  class='title' >&nbsp;</td>
                              <td  class='title' >&nbsp;</td>
                              <td  class='title' >&nbsp;</td>
							  <td  class='title' >&nbsp;</td>
							  <td  class='title' >&nbsp;</td>
                              <td  class='title' >&nbsp;</td>
                              <td  class='title' >&nbsp;</td>
                              <td  class='title' >&nbsp;</td>
                              <td  class='title' >&nbsp;</td>
                              <td  class='title' >&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td class='line' width=1210>
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
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
	%>
                            <tr> 
                              <td width=90 align='right'><%=AddUtil.parseDecimal(cSum)%>&nbsp;</td>
                              <td width=90 align='right'><%=AddUtil.parseDecimal(fSum)%>&nbsp;</td>
                              <td width=90 align='right'><%=AddUtil.parseDecimal(olaBean.getO_s_amt())%>&nbsp;</td>
                              <td width=90 align='right'><%=AddUtil.parseDecimal(olaBean.getHppr())%>&nbsp;</td>
                              <td width=90 align='right'><%=AddUtil.parseDecimal(hppr_per)%>%&nbsp;</td>
                              <td width=90 align='right'><%=AddUtil.parseDecimal((hppr*100)/fSum)%>%&nbsp;</td>				  
                              <td width=50 align='center'><%=olaBean.getCar_y_form()%></td>	
                              <td width=70 align='right'><%=AddUtil.parseDecimal(olaBean.getKm())%>
							  <%if(olaBean.getKm().equals("")){%><%=AddUtil.parseDecimal(olaBean.getToday_dist())%><%}%>&nbsp;</td>
                              <td width=30 align='center'> <%if(olaBean.getAccident_yn().equals("1")){%>
                                유 
                                <%}else{%>
                                - 
                              <%}%>&nbsp;</td>
                              <td width=100 align='center' ><%=olaBean.getOpt()%></td>
                              <td width=60 align='center' ><%=AddUtil.parseDecimal(olaBean.getDpm())%></td>
                              <td width=100 align='center' ><%=c_db.getNameByIdCode("0039", "", olaBean.getFuel_kd())%></td>
                              <td width=80 align='center' ><%=olaBean.getColo()%></td>					
                              <td  align='center' width=70><%if(olaBean.getLev().equals("1")){%>
                                상&nbsp; <%}else if(olaBean.getLev().equals("2")){%>
                                중&nbsp; <%}else if(olaBean.getLev().equals("3")){%>
                                하&nbsp; <%}else{%> &nbsp; <%}%> 
            				  </td>
                              <td align='center' width=100 ><%=olaBean.getReason()%>
							  <%=c_db.getNameById(olaBean.getCpt_cd(),"BANK")%>
							  </td>
                              <td width=60 align='center' ><%=c_db.getNameById(olaBean.getDamdang_id(), "USER")%></td>
                            </tr>
                <%}%>
                            <tr> 
                              <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(totCsum)%>&nbsp;</td>
                              <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(totFsum)%>&nbsp;</td>
                              <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(tot5sum)%>&nbsp;</td>                              
                              <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(tot3sum)%>&nbsp;</td>                              
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                              <td class='title'>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
	            </tr>
<%}else{%>
	            <tr>
	                <td class='line' id='td_con' style='position:relative;' width=900> 
	                    <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
	                <td class='line' width=1210> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;상품신탁/제시(경매) 차량이 없읍니다.</td>
                            </tr>          
                        </table>
		            </td>
	            </tr>
<%}%>		
            </table>
        </td>
    </tr>
</table>


</form>
</body>
</html>