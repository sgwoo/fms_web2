<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc_kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_cmplt.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="olcBean" class="acar.offls_cmplt.Offls_cmpltBean" scope="page"/>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
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
	
	if(!ref_dt1.equals("") && ref_dt2.equals("")) ref_dt2 = ref_dt1;
	
	Offls_cmpltBean olcb[] = olcD.getCmplt_lst(dt, ref_dt1, ref_dt2, gubun, gubun_nm,brch_id, s_au);
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	long totCsum = 0;
	long totFsum = 0;
	long tot3sum = 0;
	long tot4sum = 0;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}
	
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
-->
</script>
</head>
<body onLoad="javascript:init()">
<form name="form1">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<table border=0 cellspacing=0 cellpadding=0 width="2000">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td colspan=2 class=line2></td>
                </tR>
	            <tr id='tr_title' style='position:relative;z-index:1'>		
                    <td class='line' id='td_title' style='position:relative;' width=30%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width=10% class='title'>연번</td>
                                <td width=15% class='title'>차량번호</td>				  
                                <td width=21% class='title'>차명</td>
                                <td width=24% class='title'>경매장</td>				  								
            				    <td width=15% class='title'>경매일자</td>
                                <td width=15% class='title'>최초등록일</td>				  
                            </tr>
                        </table>
                    </td>		
                    <td class='line' width=70%>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width=7% class='title' rowspan="2">소비자가격(원)</td>
                                <td width=7% class='title' rowspan="2">구입가격(원)</td>
                                <td width=7% rowspan="2" class='title'>희망가(원)</td>
                                <td colspan="3" class='title'>매각(낙찰)</td>
								<td class='title' colspan="4">매각 수수료</td>
                                <td width=7% class='title' rowspan="2">낙찰자</td>				  
                                <td width=7% class='title' rowspan="2">주행거리(km)</td>
                                <td width=4% class='title' rowspan="2">사고유무</td>
                                <td width=7% class='title' rowspan="2">선택사양</td>
                                <td width=4% class='title' rowspan="2">배기량(cc)</td>
                                <td width=7% class='title' rowspan="2">연료</td>
                                <td width=4% class='title' rowspan="2">색상</td>
                                

                            </tr>
                            <tr> 
                                <td width=6% class='title'>가격(원)</td>
                                <td class='title' width=7%>소비자가대비</td>
                                <td class='title' width=7%>구입가대비</td>				  
                                <td class='title' width=5%>낙출수수료</td>
                                <td class='title' width=6%>재출품수수료</td>
                                <td width=4% class='title'>반입탁송대금입금</td>
								<td width=4% class='title'>합계</td>
                            </tr>
                        </table>
                    </td>
	            </tr>
<%if(olcb.length > 0 ){%>
	            <tr>
                    <td class='line' id='td_con' style='position:relative;' width=30%> 
			            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <% for(int i=0; i< olcb.length; i++){
		olcBean = olcb[i];
		String seq = olcD.getAuction_maxSeq(olcBean.getCar_mng_id());
	%>
                            <tr> 
                                <td width=10% align='center'><%=i+1%></td>
                                <td width=15% align='center'><%=olcBean.getCar_no()%></td>								
                                <td width=21%><span title='<%=olcBean.getCar_jnm()+" "+olcBean.getCar_nm()%>'>&nbsp;<%=AddUtil.subData(olcBean.getCar_jnm()+" "+olcBean.getCar_nm(),10)%></span></td>
								<td width=24% align='center'><span title='<%=olaD.getActn_nm(olcBean.getActn_id())%>'><%=AddUtil.subData(olaD.getActn_nm(olcBean.getActn_id()),8)%>&nbsp;<%=olcBean.getActn_wh()%></span></td>
            				    <td width=15% align="center"><%= AddUtil.ChangeDate2(olcBean.getActn_dt()) %></td>
                                <td width=15% align='center'><%=AddUtil.ChangeDate2(olcBean.getInit_reg_dt())%></td>				  
                            </tr>
                            <%}%>
                            <tr> 
                                <td class='title'>&nbsp;</td>
                                <td class='title'>&nbsp;</td>
                                <td class='title'>&nbsp;</td>								
            				    <td class='title'>&nbsp;</td>
                                <td class='title'>&nbsp;</td>				  
                                <td class='title'>&nbsp;</td>				  				  
                            </tr>
                        </table>
                    </td>
                    <td class='line' width=70%>
                        <table border="0" cellspacing="1" cellpadding="0" width=100% >
                <% for(int i=0; i< olcb.length; i++){
			olcBean = olcb[i];
			/*
			int cSum = olcBean.getCar_cs_amt() + olcBean.getCar_cv_amt() + olcBean.getOpt_cs_amt() + olcBean.getOpt_cv_amt()+
					olcBean.getClr_cs_amt() + olcBean.getClr_cv_amt() + olcBean.getSd_cs_amt() + olcBean.getSd_cv_amt() +
					olcBean.getDc_cs_amt() + olcBean.getDc_cv_amt();
			int fSum = olcBean.getCar_fs_amt() + olcBean.getCar_fv_amt() + olcBean.getOpt_fs_amt() + olcBean.getOpt_fv_amt()+
					olcBean.getClr_fs_amt() + olcBean.getClr_fv_amt() + olcBean.getSd_fs_amt() + olcBean.getSd_fv_amt() +
					olcBean.getDc_fs_amt() + olcBean.getDc_fv_amt();
			*/
			int cSum = olcBean.getCar_cs_amt() + olcBean.getCar_cv_amt() + olcBean.getOpt_cs_amt() + olcBean.getOpt_cv_amt()+
					   olcBean.getClr_cs_amt() + olcBean.getClr_cv_amt();
			int fSum = olcBean.getCar_fs_amt() + olcBean.getCar_fv_amt() + olcBean.getSd_cs_amt() + olcBean.getSd_cv_amt() -
					   olcBean.getDc_cs_amt() - olcBean.getDc_cv_amt();
			totCsum += cSum;
			totFsum += fSum;
			int carpr = olcBean.getCar_cs_amt()+olcBean.getCar_cv_amt()+olcBean.getOpt_cs_amt()+olcBean.getOpt_cv_amt()+olcBean.getClr_cs_amt()+olcBean.getClr_cv_amt();
			double hppr = olcBean.getHppr();
			double nakpr = olcBean.getNak_pr();
			double nakpr_per = (nakpr*100)/carpr;
			tot3sum += olcBean.getHppr();
			tot4sum += olcBean.getNak_pr();
	%>
                            <tr>
                  
                              <td width=7% align='right'><%=AddUtil.parseDecimal(cSum)%>&nbsp;</td>
                              <td width=7% align='right'><%=AddUtil.parseDecimal(fSum)%>&nbsp;</td>
            				  <td width=7% align='right' ><%=AddUtil.parseDecimal(olcBean.getHppr())%>&nbsp;</td>
                              <td width=6% align='right' ><%=AddUtil.parseDecimal(olcBean.getNak_pr())%>&nbsp;</td>
                              <td width=7% align='center' ><%=AddUtil.parseDecimal(nakpr_per)%>%</td>
                              <td width=7%' align='center' ><%=AddUtil.parseDecimal((nakpr*100)/fSum)%>%</td>
							  
							  <td align='center' width=5%><%=AddUtil.parseDecimal(olcBean.getComm1_tot())%>&nbsp;</td>
                              <td align='center' width=6%><%=AddUtil.parseDecimal(olcBean.getComm2_tot())%>&nbsp;</td>
                              <td width=4% align='center'><%=AddUtil.parseDecimal(olcBean.getComm3_tot())%>&nbsp;</td>							  
							  <td width=4% align='center'><%=AddUtil.parseDecimal(olcBean.getComm_tot())%>&nbsp;</td>
							  
                              <td width=7% align='center' ><span title='<%=olcBean.getSui_nm()%>'><%=AddUtil.subData(olcBean.getSui_nm(),6)%></span></td>				  
                              <td width=7% align='right'><%=AddUtil.parseDecimal(olcBean.getKm())%>
							  <%if(olcBean.getKm().equals("")){%><%=AddUtil.parseDecimal(olcBean.getToday_dist())%><%}%>&nbsp;</td>
                              <td width=4% align='center'> 
                                <%if(olcBean.getAccident_yn().equals("1")){%>
                                유 
                                <%}else{%>
                                - 
                                <%}%>
                              </td>
                              <td width=7% align='center' ><span title='<%=olcBean.getOpt()%>'><%=AddUtil.subData(olcBean.getOpt(), 6)%></span></td>
                              <td width=4% align='center' ><%=AddUtil.parseDecimal(olcBean.getDpm())%></td>
                              <td width=7% align='center' ><%=c_db.getNameByIdCode("0039", "", olcBean.getFuel_kd())%></td>
                              <td width=4% align='center' ><span title='<%=olcBean.getColo()%>'><%=AddUtil.subData(olcBean.getColo(),3)%></span></td>				  
                              
            				  
                            </tr>				
                            <%}%>
        				    <tr> 

            		            <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(totCsum)%>&nbsp;</td>
            		            <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(totFsum)%>&nbsp;</td>
            		            <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(tot3sum)%>&nbsp;</td>
            		            <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(tot4sum)%>&nbsp;</td>
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
                                <td class='title'>&nbsp;</td>
                                <td class='title'>&nbsp;</td>					
		                    </tr>
                        </table>
                    </td>
	            </tr>
<%}else{%>
	            <tr>
	                <td class='line' id='td_con' style='position:relative;' width=30%> 
	                    <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
	                <td class='line' width=70%> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 차량이 없읍니다.</td>
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
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>