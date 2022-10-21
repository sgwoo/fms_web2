<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="olyBean" class="acar.offls_pre.Offls_preBean" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaA" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String off_id = request.getParameter("r_off_id")==null?"":request.getParameter("r_off_id");
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
%>
	

<html>
<head><title>FMS</title>
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
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                      <td width='3%' class='title' style='height:51'> <input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'> </td>
                        <td width='4%' class='title'>연번</td>
                        <td width='7%' class='title'>위치</td>
                        <td width='7%' class='title'>차량번호</td>
                        <td width='*' class='title'>차명</td>
                        <td width=10% class='title'>출품경매장</td>                               
						<td width=5% class='title' >주행거리<br>(km)</td>                     
                        <td width=5% class='title' >연료</td>
                        <td width=10% class='title'>색상</td>
                        <td width=5% class='title' >최초등록일</td>								  
                        <td width=7% class='title' >소비자가격(원)</td>
                        <td width=7% class='title' >구입가격(원)</td>
                        <td width=7% class='title' >예상낙찰가(원)</td>  
                        <td width=8% class='title' >관리번호</td>				  

                </tr>                
        
<%if(olyb.length !=0 ){
   					        
    for(int i=0; i< olyb.length; i++){
		   olyBean = olyb[i];
		   
			int cSum = olyBean.getCar_cs_amt() + olyBean.getCar_cv_amt() + olyBean.getOpt_cs_amt() + olyBean.getOpt_cv_amt()+
			olyBean.getClr_cs_amt() + olyBean.getClr_cv_amt();
			int fSum = olyBean.getCar_fs_amt() + olyBean.getCar_fv_amt() + olyBean.getSd_cs_amt() + olyBean.getSd_cv_amt() -
			olyBean.getDc_cs_amt() - olyBean.getDc_cv_amt();
		
			int o_s_amt = olpD.getOffls_pre_o_s_amt(olyBean.getCar_mng_id());
						
	%>
                 <tr> 
                                <td width='3%' align='center'> <input type="checkbox" name="pr" value="<%=olyBean.getCar_mng_id()%>^<%=off_id%>^<%=olyBean.getCar_jnm()+" "+olyBean.getCar_nm()%>^<%=cSum%>^" > 
                                </td>
                                <td width='4%' align='center'><%=i+1%></td>
                                <td width='7%' align='center'><%=olyBean.getPark()%></td>			
                                <td width='7%' align='center'><%=olyBean.getCar_no()%>	</td>          
                                <td width='*' align='left'><span title='<%=olyBean.getCar_jnm()+" "+olyBean.getCar_nm()%>'>&nbsp;<%=AddUtil.subData(olyBean.getCar_jnm()+" "+olyBean.getCar_nm(),10)%></span>
								     </td>
								     	<td width='10%' align='center' >
								     	<%=AddUtil.subData(olaA.getActn_nm(olyBean.getActn_id()),8)%>
								     	
								</td>                          
								<td width='5%' align='right'><%=AddUtil.parseDecimal(olyBean.getToday_dist())%>&nbsp;&nbsp;</td>                          
                              <td width='5%' align='center' ><%=c_db.getNameByIdCode("0039", "", olyBean.getFuel_kd())%></td>
                              <td width='10%' align='center' ><span title='<%=olyBean.getColo()%>'><%=AddUtil.subData(olyBean.getColo(),6)%></span></td>
                              <td width='5%' align='center'><%=AddUtil.ChangeDate2(olyBean.getInit_reg_dt())%></td>
							
                              <td width='7%' align='right'><%=AddUtil.parseDecimal(cSum)%>&nbsp;&nbsp;</td>
                              <td width='7%' align='right'><%=AddUtil.parseDecimal(fSum)%>&nbsp;&nbsp;</td>
                              <td width='7%' align='right'><%=AddUtil.parseDecimal(o_s_amt)%>&nbsp;&nbsp;</td>
            				     <td width='8%' align='center'><%=olyBean.getCar_doc_no()%></td>
								     
                      </tr>
      <%}%>
                   
 <%}%>                         
                 
            </table>
        </td>
    </tr>
</table>


</form>
</body>
</html>
