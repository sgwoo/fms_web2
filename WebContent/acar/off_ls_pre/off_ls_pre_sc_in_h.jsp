<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_pre.Offls_preBean"/>
<jsp:useBean id="olyD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");

	String actn_id = olyD.getActn_id(car_mng_id);
	detail = olyD.getPre_detail(car_mng_id);
	String car_no = detail.getCar_no();


%>
<html>
<head><title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
a:link { text-decoration:none; }
</style>
<script language="javascript">
<!--

function open_encar(){
	parent.detail_body.location.href = "off_ls_pre_sc_in_encar.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
}
function open_basic(){
	parent.detail_body.location.href = "off_ls_pre_sc_in_b.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
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
function open_actn(){
	parent.detail_body.location.href = "off_ls_pre_actn.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&id=<%=actn_id%>";
}
function list(){
	parent.location.href = "off_ls_pre_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
}

//상세대출내역 확인(할부금 조회 페이지 팝업) 
function goDebtPay(){
	var fm = document.form1;
	var car_mng_id = fm.car_mng_id.value;
	window.open("/acar/off_ls_pre/off_ls_pre_go_debt_pop_a.jsp?car_mng_id="+car_mng_id, "SEARCH_DEBT", "left=100, top=120, width=1350, height=800, resizable=yes, scrollbars=yes, status=yes");	
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
        <td colspan=6>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 오프리스현황 > <span class=style5>매각결정자동차현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align=right>
        	<input type="button" class="button" value="상세 대출내역 확인" onclick="javascraipt:goDebtPay();">
        	<a href='javascript:list()'><img src=../images/center/button_list.gif border=0 align=absmiddle></a>
        </td>
    </tr>	
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
	    <td class=line>
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width="15%" style='height:28'>차량번호</td>
                    <td width="85%">&nbsp;&nbsp;&nbsp;<b><%=car_no%></b>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td></td>
    </td>
    <tr> 
        <td align=center>             
            <a href="javascript:open_encar()"><img src=../images/center/button_p_encar.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_actn()"><img src=../images/center/button_p_gbsl.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_basic()"><img src=../images/center/button_sh_detail.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_car_his()"><img src=../images/center/button_sh_carir.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_car_mng()"><img src=../images/center/button_sh_jb.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_accident()"><img src=../images/center/button_sh_acc.gif border=0 align=absmiddle></a></td>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>