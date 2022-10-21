<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="encar" scope="page" class="acar.offls_pre.Off_ls_pre_encar"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	encar = olpD.getEncar(car_mng_id);
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
a:link { text-decoration:none; }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function encarIns()
{
	this.location.href = "off_ls_pre_sc_in_encar_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%= car_mng_id %>";
}
function encarUpd(){
	this.location.href = "off_ls_pre_sc_in_encar_mod.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%= car_mng_id %>";
}
-->
</script>
</head>
<body>
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ENCAR</span></td>
        <td align="right">
	    <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
    	  	<% if(encar.getCar_mng_id().equals("")){ %>
    			<a href='javascript:encarIns();' onMouseOver="window.status=''; return true"> 
    	        <img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a> 
    		<% }else{ %>
            	<a href='javascript:encarUpd();' onMouseOver="window.status=''; return true"> 
    	        <img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a> 
            <% } %>
    	  <%}%> </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td class='title' width=15%>엔카등록ID</td>
                <td colspan="3">&nbsp; <%= encar.getEncar_id() %></td>
              </tr>
              <tr> 
                <td class='title'>게시등록일</td>
                <td colspan="3">&nbsp; <%= AddUtil.ChangeDate2(encar.getReg_dt()) %></td>
              </tr>
              <tr> 
                <td class='title'>조회수</td>
                <td colspan="3">&nbsp; <%= encar.getCount() %></td>
              </tr>
              <tr> 
                <td class='title'>기본옵션</td>
                <td colspan="3">&nbsp; <textarea  class="textarea" name="opt_value" cols="100" rows="2" readonly><%= encar.getOpt_value() %></textarea></td>
              </tr>
              <tr> 
                <td class='title'>딜러매입가</td>
                <td colspan="3">&nbsp; <%= AddUtil.parseDecimal(encar.getD_car_amt()) %> 원</td>
              </tr>
              <tr> 
                <td class='title'>소비자가</td>
                <td colspan="3">&nbsp; <%= AddUtil.parseDecimal(encar.getS_car_amt()) %> 원</td>
              </tr>
              <tr> 
                <td class='title'>엔카소비자가</td>
                <td colspan="3">&nbsp; <%= AddUtil.parseDecimal(encar.getE_car_amt()) %> 원</td>
              </tr>
              <tr> 
                <td class='title'>엔카동급물평균가</td>
                <td colspan="3">&nbsp; <%= AddUtil.parseDecimal(encar.getEa_car_amt()) %> 원</td>
              </tr>
              <tr> 
                <td class='title'>보증서번호</td>
                <td colspan="3">&nbsp; <%= encar.getGuar_no() %></td>
              </tr>
              <tr> 
                <td class='title'>CashBack차량이용료</td>
                <td colspan="3">&nbsp; <%= AddUtil.parseDecimal(encar.getDay_car_amt()) %> 원&nbsp;&nbsp;&nbsp;&nbsp;(동급차량 1주일 단기렌트료의 30%) </td>
              </tr>
              <tr> 
                <td class='title'>이미지경로</td>
                <td colspan="3">&nbsp; <%= encar.getImg_path() %></td>
              </tr>		  
    		  <tr> 
                <td class='title'>설명</td>
                <td colspan="3">&nbsp; 
                  <textarea  class="textarea" name="content" cols="100" rows="10" readonly><%= encar.getContent() %></textarea>
                </td>
              </tr>
              <tr> 
                <td class='title'>등록자</td>
                <td colspan="3">&nbsp; 
    			<%if(login.getAcarName(encar.getReg_id()).equals("error")){%>
                  &nbsp;
                  <%}else{%>
                  <%=login.getAcarName(encar.getReg_id())%> 
                  <%}%></td>
              </tr>
              <tr>
                <td class='title'>수정자</td>
                <td colspan="3">&nbsp; 
    			<%if(login.getAcarName(encar.getUpd_id()).equals("error")){%>
                  &nbsp;
                  <%}else{%>
                  <%=login.getAcarName(encar.getUpd_id())%> 
                  <%}%></td>
              </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>