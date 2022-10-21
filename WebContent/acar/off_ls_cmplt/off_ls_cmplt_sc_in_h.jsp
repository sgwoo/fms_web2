<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_cmplt.Offls_cmpltBean"/>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")	==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");	
	String dt		= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 		= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_au 		= request.getParameter("s_au")		==null?"":request.getParameter("s_au");
		
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");	
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	detail = olcD.getCmplt_detail(car_mng_id);
	String car_no = detail.getCar_no();

	String actn_dt = detail.getActn_dt();
	String actn_id = detail.getActn_id();
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&brch_id="+br_id+
					"&gubun="+gubun+"&gubun_nm="+gubun_nm+"&dt="+dt+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+"&s_au="+s_au+
				   	"&car_mng_id="+car_mng_id+"&seq="+seq+"&from_page="+from_page+"";					
	
	

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
function open_cont(){
	parent.detail_body.location.href = "off_ls_cmplt_reg.jsp<%=vlaus%>&actn_id=<%=actn_id%>&actn_dt=<%=actn_dt%>";
}
function open_actn(){
	parent.detail_body.location.href = "/acar/off_ls_pre/off_ls_pre_actn.jsp<%=vlaus%>&id=<%=actn_id%>";
}
function open_auction(){
	parent.detail_body.location.href = "/acar/off_ls_jh/off_ls_jh_st_frame.jsp<%=vlaus%>&actn_id=<%=actn_id%>";
}
function open_basic(){
	parent.detail_body.location.href = "off_ls_cmplt_sc_in_b.jsp<%=vlaus%>";
}
function open_car_mng()
{
	parent.detail_body.location.href = "/acar/off_lease/off_lease_car_mng.jsp<%=vlaus%>";
}
function open_car_his()
{
	parent.detail_body.location.href = "/acar/off_lease/off_lease_car_his.jsp<%=vlaus%>";
}
function open_accident()
{
	parent.detail_body.location.href = "/acar/off_lease/off_lease_accident.jsp<%=vlaus%>&car_no=<%=detail.getCar_no()%>&car_nm=<%=detail.getCar_nm()%>";
}

function list(){
	if('<%=from_page%>' == '/acar/off_ls_cmplt/off_ls_stat_grid_sc.jsp'){
		parent.location.href = "/acar/off_ls_cmplt/off_ls_stat_grid_frame.jsp<%=vlaus%>";
	}else if('<%=from_page%>' == '/acar/off_ls_cmplt/off_ls_stat_grid_sc_old.jsp'){
		parent.location.href = "/acar/off_ls_cmplt/off_ls_stat_grid_frame_old.jsp<%=vlaus%>";
	}else if('<%=from_page%>' == '/acar/off_ls_cmplt/off_ls_stat_sc.jsp'){
		alert("aaa");
		parent.location.href = "/acar/off_ls_cmplt/off_ls_stat_frame.jsp<%=vlaus%>";
	}else{
		parent.location.href = "off_ls_cmplt_grid_frame.jsp<%=vlaus%>";
	}
}
-->
</script>
</head>
<body>
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan=6>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 경매관리 > 낙찰현황 > <span class=style5>경매장낙찰현황</span></span></td>
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
            <a href="javascript:open_cont()"><img src=../images/center/button_p_gyjb.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_auction()"><img src=../images/center/button_p_gmgl.gif border=0 align=absmiddle></a>&nbsp;
    	    <a href="javascript:open_actn()"><img src=../images/center/button_p_gbsl.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_basic()"><img src=../images/center/button_sh_detail.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_car_his()"><img src=../images/center/button_sh_carir.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_car_mng()"><img src=../images/center/button_sh_jb.gif border=0 align=absmiddle></a>&nbsp; 
    	    <a href="javascript:open_accident()"><img src=../images/center/button_sh_acc.gif border=0 align=absmiddle></a></td>
        </td>
    </tr>
    <tr>
        <td></td>
    </td>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>