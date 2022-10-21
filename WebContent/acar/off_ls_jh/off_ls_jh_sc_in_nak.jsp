<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_actn.*"%>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<jsp:useBean id="olaBean" class="acar.offls_actn.Offls_actnBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");

	olaBean = olaD.getActn_detail(car_mng_id);
	int carpr = olaBean.getCar_cs_amt()+olaBean.getCar_cv_amt()+olaBean.getOpt_cs_amt()+olaBean.getOpt_cv_amt()+olaBean.getClr_cs_amt()+olaBean.getClr_cv_amt();

	
	Offls_auctionBean auction = olaD.getAuction(car_mng_id, seq);
	double hp_pr = auction.getHp_pr();
	double nak_pr = auction.getNak_pr();
	double nak_pr_per = (nak_pr*100)/hp_pr;
	
	double nak_pr_car_per = Math.round((nak_pr*1000)/carpr)*0.1d;
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "06", "03", "01");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function updNak(ioru){
	var fm = document.form1;
	if(ioru=="i"){
		if(!confirm('등록 하시겠습니까?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('수정 하시겠습니까?')){ return; }
	}
	fm.gubun.value = ioru;
	fm.target = "i_no";
	fm.submit();
}
function getNakprPer(val){	
	var fm = document.form1;
	var nak_pr = toInt(parseDigit(fm.nak_pr.value));
	var hp_pr = toInt(parseDigit(parent.c_body.form1.hp_pr.value));
	var per = (nak_pr*100)/hp_pr;	
	fm.nak_pr_per.value = parseFloatCipher3(per,2);
	return parseDecimal(val);
}
function cancel_nak(){
	location.href='off_ls_jh_actn_mng_re.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>&seq=<%= seq %>&actn_cnt=<%= auction.getActn_cnt() %>'; 
}
-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" action="off_ls_jh_sc_in_nak_upd.jsp" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">  
    <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>    
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>낙찰</span></td>
        <td align="right">
        <%if(auction.getNak_pr()==0){%>
        <a href="javascript:cancel_nak();"><img src=../images/center/button_jcp.gif border=0 align=absmiddle></a>&nbsp;
        <%}%>
        <%if(auction.getNak_pr() == 0 ){%>
        <a href='javascript:updNak("i");'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        <%}else{%>
        <a href='javascript:updNak("u");'><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
        <%}%>
        </td>
    </tr>
   <% } %>  

    <tr> 
        <td colspan=2>
	  	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	        <tr>
                    <td class=line2></td>
                </tr>
		        <tr>
			        <td class="line"> 
			            <table border="0" cellspacing="1" cellpadding='0' width="100%" >
        				    <tr> 
            					<td class='title' width=25%>낙찰자</td>
            					<td class='title' width=24%>낙찰가(원)</td>
            					<td class='title' width=26%>희망가대비(%)</td>
            					<td class='title' width=25%>신차가대비(%)</td>			
        				    </tr>
        				    <tr> 
            					<td align="center"> <input class="text" type="text" name="nak_nm" size="13" value="<%=auction.getNak_nm()%>"> 
            					</td>
            					<td align="center"> <input class="num" type="text" name="nak_pr" size="13" value="<%=AddUtil.parseDecimal(auction.getNak_pr())%>" onBlur='javascript:this.value=getNakprPer(this.value)'> 
            					</td>
            					<td align="center"> <input class="white" type="text" name="nak_pr_per" size="5" value="<%=AddUtil.parseDecimal(nak_pr_per)%> "> 
            					</td>
            					<td align="center"> <input class="white" type="text" name="nak_pr_car_per" size="5" value="<%=AddUtil.parseDecimal(nak_pr_car_per)%> "> 
            					</td>			
        				    </tr>
                        </table>
                    </td>
		        </tr>
	        </table>
	    </td>
    </tr>
</table>

</form>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</html>
