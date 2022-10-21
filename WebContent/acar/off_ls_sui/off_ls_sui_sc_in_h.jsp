<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_sui.Offls_suiBean"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	detail = olsD.getSui_detail(car_mng_id);
	String car_no = detail.getCar_no();

	
	String actn_id = olpD.getActn_id(car_mng_id);
%>
<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
a:link { text-decoration:none; }
</style>
<script language="javascript">
<!--
function open_cont(){
	parent.detail_body.location.href = "off_ls_sui_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
}
function open_basic(){
	parent.detail_body.location.href = "off_ls_sui_sc_in_b.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
}
function open_car_mng()
{
	parent.detail_body.location.href = "/acar/off_lease/off_lease_car_mng.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
}
function open_car_his()
{
	parent.detail_body.location.href = "/acar/off_lease/off_lease_car_his.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
}
function open_accident()
{
	parent.detail_body.location.href = "/acar/off_lease/off_lease_accident.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&car_no=<%=detail.getCar_no()%>&car_nm=<%=detail.getCar_nm()%>";
}
function list(){
	parent.location.href = "off_ls_sui_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
}
function open_actn(){
	parent.detail_body.location.href = "/acar/off_ls_pre/off_ls_pre_actn.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&id=<%=actn_id%>";
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 수의계약관리 > <span class=style5>수의계약현황</span></span></td>
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
            <a href="javascript:open_actn()"><img src=../images/center/button_p_gbsl.gif border=0 align=absmiddle></a>&nbsp; 
            <a href="javascript:open_basic()"><img src=../images/center/button_sh_detail.gif border=0 align=absmiddle></a>&nbsp; 
            <a href="javascript:open_car_his()"><img src=../images/center/button_sh_carir.gif border=0 align=absmiddle></a>&nbsp; 
            <a href="javascript:open_car_mng()"><img src=../images/center/button_sh_jb.gif border=0 align=absmiddle></a>&nbsp; 
            <a href="javascript:open_accident()"><img src=../images/center/button_sh_acc.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>