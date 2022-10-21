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
	
	Offls_suiBean olsb[] = olsD.getJunk_lst(gubun,gubun_nm);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	int totCsum = 0;
	int totFsum = 0;
%>
<html>
<head>
<title>FMS</title>
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
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="1800">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
	            <tr id='tr_title' style='position:relative;z-index:1'>		
                    <td class='line' id='td_title' style='position:relative;' width=25%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width=9% class='title' style='height:45'> <input type="checkbox" name="all_pr" value="Y" onclick='javascript:AllSelect(this.form.pr)'></td>
                                <td width=9% class='title'>연번</td>
                                <td width=25% class='title'>차량번호</td>
                                <td width=34% class='title'>차명</td>
                                <td width=23% class='title' rowspan="2">최초등록일</td>				  
                            </tr>
                        </table>
                    </td>		
                    <td class='line' width=75%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td rowspan="2" class='title' width=17%>보증기간</td>
                                <td width=9% class='title' rowspan="2">소비자가격(원)</td>
                                <td width=9% class='title' rowspan="2">구입가격(원)</td>
            				    <td width=9% class='title' rowspan="2">매각가격(원)</td>
                                <td width=9% class='title' rowspan="2">누적주행거리(km)</td>
                                <td width=7% class='title' rowspan="2">사고유무</td>
                                <td width=12% class='title' rowspan="2">연료</td>
                                <td width=6% class='title' rowspan="2">색상</td>				  
                                <td class='title' colspan="3">상품평가</td>
                            </tr>
                            <tr> 
                                <td class='title' width=7%>자체평가</td>
                                <td class='title' width=9%>평가요인</td>
                                <td width=6% class='title'>담당자</td>
                            </tr>
                        </table>
 		            </td>
	            </tr>
<%if(olsb.length !=0 ){%>
	            <tr>
                    <td class='line' id='td_con' style='position:relative;' width=25%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <% for(int i=0; i< olsb.length; i++){
		olsBean = olsb[i];
	%>
                            <tr> 
                                <td width=9% align='center'> <input type="checkbox" name="pr" value="<%=olsBean.getCar_mng_id()%>" ></td>
                                <td width=9% align='center'><%=i+1%></td>
                                <td width=25% align='center'><a href="javascript:parent.view_detail('<%=auth_rw%>','<%=olsBean.getCar_mng_id()%>')"><%=olsBean.getCar_no()%></a></td>
                                <td width=34%><span title='<%=olsBean.getCar_jnm()+" "+olsBean.getCar_nm()%>'>&nbsp;<%=AddUtil.subData(olsBean.getCar_jnm()+" "+olsBean.getCar_nm(),10)%></span></td>
                                <td width=23% align='center'><%=AddUtil.ChangeDate2(olsBean.getInit_reg_dt())%></td>				  
                            </tr>
                <%}%>
                            <tr> 
                                <td  class='title' width=9% align='center'>&nbsp;</td>
                                <td  class='title' width=9% align='center'>&nbsp;</td>
                                <td  class='title' width=25% align='center'>&nbsp;</td>
                                <td  class='title' width=34% align='center'>&nbsp;</td>
                                <td  class='title' width=23% align='center'>&nbsp;</td>				  
                            </tr>
                        </table>
                    </td>
                    <td class='line' width=75%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100% >
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
                            <tr> 
                              <td  width=17% align='center' ><span title='<%=olsBean.getOpt()%>'> <%=AddUtil.ChangeDate2(olsBean.getAss_st_dt())%> 
                                ~ </span><%=AddUtil.ChangeDate2(olsBean.getAss_ed_dt())%></td>
                              <td width=9% align='right'><%=AddUtil.parseDecimal(cSum)%>&nbsp;&nbsp;&nbsp;</td>
                              <td width=9% align='right'><%=AddUtil.parseDecimal(fSum)%>&nbsp;&nbsp;&nbsp;</td>
            				  <td width=9% align='right'><%=AddUtil.parseDecimal(olsBean.getMm_pr())%>&nbsp;&nbsp;&nbsp;</td>
                              <td width=9% align='right'><%=AddUtil.parseDecimal(olsBean.getToday_dist())%>&nbsp;&nbsp;&nbsp;</td>
                              <td width=7% align='center'> 
                                <%if(olsBean.getAccident_yn().equals("1")){%>
                                유 
                                <%}else{%>
                                - 
                                <%}%>
                              </td>
                              <td width=12% align='center' > 
                                <%=c_db.getNameByIdCode("0039", "", olsBean.getFuel_kd())%></td>
                              <td width=6% align='center' ><span title='<%=olsBean.getColo()%>'><%=AddUtil.subData(olsBean.getColo(),4)%></span></td>				  
                              <td  align='center' width=7%>&nbsp; 
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
                              <td  align='center' width=9% ><a href='#' title="<%=olsBean.getReason()%>"><%=AddUtil.subData(olsBean.getReason(),8)%></a></td>
                              <td width=6% align='center' ><%=c_db.getNameById(olsBean.getDamdang_id(), "USER")%></td>
                            </tr>
                            <%}%>
                            <tr> 
                              <td align='center'  class='title'  width=17%>&nbsp;</td>
                              <td width=9% align='right'><%=AddUtil.parseDecimal(totCsum)%>&nbsp;&nbsp;&nbsp;</td>
                              <td width=9% align='right'><%=AddUtil.parseDecimal(totFsum)%>&nbsp;&nbsp;&nbsp;</td>
            				  <td  class='title'  width=9% align='center'>&nbsp;</td>
                              <td  class='title' width=9% align='right'>&nbsp;</td>
                              <td  class='title' width=7% align='center'>&nbsp;</td>
                              <td  class='title' width=12% align='center' >&nbsp;</td>
                              <td  class='title' width=6% align='center' >&nbsp;</td>
                              <td  class='title' align='center' width=7%>&nbsp;</td>
                              <td  class='title' align='center' width=9% >&nbsp;</td>
                              <td  class='title' width=6% align='center' >&nbsp;</td>
                            </tr>
                        </table>
		            </td>
	            </tr>
<%}else{%>
	            <tr>
	                <td class='line' id='td_con' style='position:relative;' width=25%> 
	                    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
	                <td class='line' width=75%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;차량이 없읍니다.</td>
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