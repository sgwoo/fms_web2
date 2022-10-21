<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*, acar.offls_actn.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_pre.Offls_preBean"/>
<jsp:useBean id="auction" scope="page" class="acar.offls_actn.Offls_car_purBean"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	detail = olpD.getPre_detail(car_mng_id);
	Offls_car_purBean[] auctionList = olaD.getOfflsCarpur(car_mng_id);
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
		
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
function carPurUpd(ioru){
	var fm = document.form1;	
	fm.gubun.value = ioru;
	fm.action="/acar/off_ls_pre/off_ls_pre_sc_in_b_car_pur_iu.jsp";
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량출고매핑</span></td>
        <td align="right"> 
          <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
    		  <%if(auctionList.length>0){%>
    			  <a href='javascript:carPurUpd("u");' onMouseOver="window.status=''; return true"> 
    			  <img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a> 
    		  <%}else{%>
    			  <a href='javascript:carPurUpd("i");' onMouseOver="window.status=''; return true"> 
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
                    <td class='title' width=30%>출고점</td>
                    <td class='title' width=12%>관리자</td>
                    <td class='title' width=12%>계약번호</td>
                    <td class='title' width=20%>계출번호</td>
                    <td class='title' width=14%>출고일</td>
                </tr>
                  <% if(auctionList.length>0){
        		  		for(int i=0; i<auctionList.length; i++){
        				auction = auctionList[i];        			
        		  %>
                <tr> 
                    <td align="center"><%= auctionList.length-i %></td>
                    <td align="center"><%=auction.getCar_off_nm()%></td>
                    <td align="center"><%=auction.getEmp_nm()%></td>
                    <td align="center"><%=auction.getRent_l_cd()%></td>
                    <td align="center"><%=auction.getRpt_no()%></td>
                    <td align="center"><%=auction.getDlv_dt()%></td>
                </tr>
          <% }
		  }else{ %>
                <tr> 
                    <td colspan='6' align="center">데이타가 없습니다.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
