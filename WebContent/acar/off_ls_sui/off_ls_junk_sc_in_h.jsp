<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_sui.Offls_suiBean"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String junk = request.getParameter("junk")==null?"":request.getParameter("junk");
	
	detail = olsD.getJunk_detail(car_mng_id);
	String car_no = detail.getCar_no();
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
a:link { text-decoration:none; }
</style>
<script language="javascript">
<!--
function open_cont(){
	parent.detail_body.location.href = "off_ls_junk_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
}

function list(){
	parent.location.href = "off_ls_sui_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
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
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 >  <span class=style5>폐차현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align=right><a href='javascript:list()'><img src=../images/center/button_list.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
	    <td class=line>
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
			    <tr> 
			        <td class=title width="16%" style='height:28'>차량번호</td>
                    <td  width="84%">&nbsp;&nbsp;&nbsp;<b><%=car_no%></b></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td align=center>
            <a href="javascript:open_cont()"><img src=../images/center/button_p_gyjb.gif border=0 align=absmiddle></a>&nbsp; 
       
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>