<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*, acar.offls_actn.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="detail"  class="acar.offls_pre.Offls_preBean" scope="page"/>
<jsp:useBean id="olpD"    class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD"    class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<jsp:useBean id="auction" class="acar.offls_actn.Offls_auctionBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	detail = olpD.getPre_detail(car_mng_id);
	Offls_auctionBean[] auctionList = olaD.getAuction(car_mng_id);
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//차량가격
	int carpr = detail.getCar_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cs_amt()+detail.getOpt_cv_amt()+detail.getClr_cs_amt()+detail.getClr_cv_amt();

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function auctionUpd(ioru){
	var fm = document.form1;	
	fm.gubun.value = ioru;
	fm.action="/acar/off_ls_pre/off_ls_pre_sc_in_b_auction_iu.jsp";
	fm.submit();
}
-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>상품가격결정</span></td>
        <td align="right"> 
          <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
    		  <%if(auctionList.length>0){%>
    			  <a href='javascript:auctionUpd("u");' onMouseOver="window.status=''; return true"> 
    			  <img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a> 
    		  <%}else{%>
    			  <a href='javascript:auctionUpd("i");' onMouseOver="window.status=''; return true"> 
    			  <img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a> 
    		  <%}%>
          <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td class='title' width=12%>연번</td>
                    <td class='title' width=19%>최종결정자</td>
                    <td class='title' width=23%>신차가</td>
                    <td class='title' width=23%>시작가(신차대비)</td>
                    <td class='title' width=23%>희망가(신차대비)</td>
                </tr>
                  <% if(auctionList.length>0){
        		  		for(int i=0; i<auctionList.length; i++){
        				auction = auctionList[i];
        				//희망가,시작가 퍼센트
        				float hppr_per=0.0f, stpr_per=0.0f;
        				float hppr = auction.getHp_pr();
        				float stpr = auction.getSt_pr();
        				if(carpr==0){
        					hppr_per = 0;
        					stpr_per = 0;
        				}else{
        					hppr_per = (hppr*100)/carpr;
        					stpr_per = (stpr*100)/carpr;
        				}  %>
                <tr> 
                    <td align="center"><%= auctionList.length-i %></td>
                    <td align="center">
                      <%if(login.getAcarName(auction.getDamdang_id()).equals("error")){%>
                      &nbsp; 
                      <%}else{%>
                      <%=login.getAcarName(auction.getDamdang_id())%> 
                      <%}%>
                    </td>
                    <td  align="center"><%=AddUtil.parseDecimal(carpr)%>원</td>
                    <td  align="center"><%=AddUtil.parseDecimal(auction.getSt_pr())%>원(<%=AddUtil.parseFloatCipher2(stpr_per,2)%>%)</td>
                    <td  align="center"><%=AddUtil.parseDecimal(auction.getHp_pr())%>원(<%=AddUtil.parseFloatCipher2(hppr_per,2)%>%)</td>
                </tr>
          <% }
		  }else{ %>
                <tr> 
                    <td colspan='5' align="center">아직 가격이 결정되지 않았습니다.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
