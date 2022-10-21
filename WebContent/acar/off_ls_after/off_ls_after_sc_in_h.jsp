<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="acar.offls_sui.*"%>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="detail" scope="page" class="acar.offls_after.Offls_afterBean"/>
<jsp:useBean id="olcD" class="acar.offls_after.Offls_afterDatabase" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="seBean" class="acar.offls_sui.Sui_etcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String migr_dt = request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt");
	String migr_gu	= request.getParameter("migr_gu")==null?"":request.getParameter("migr_gu");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");			
	
	detail = olcD.getAfter_detail(car_mng_id);
	String car_no = detail.getCar_no();

	String actn_id = olpD.getActn_id(car_mng_id);
	
	seBean = olsD.getSuiEtc(car_mng_id);
	
	
%>
<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<style>
a:link { text-decoration:none; }
</style>
<script language="javascript">
<!--
function open_cont(){
	parent.detail_body.location.href = "off_ls_after_sui_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
}
function open_actn(){
	parent.detail_body.location.href = "/acar/off_ls_pre/off_ls_pre_actn.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&id=<%=actn_id%>";
}
function open_auction(){
	parent.detail_body.location.href = "/acar/off_ls_jh/off_ls_jh_st_frame.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>";
}
function open_basic(){
	parent.detail_body.location.href = "off_ls_after_sc_in_b.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
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


function list(from_page){
    
    if (from_page == 'off_ls_after_opt_frame') {
   		parent.location.href = "off_ls_after_opt_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&migr_dt=<%= migr_dt %>&migr_gu=<%= migr_gu %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>&car_st=<%= car_st %>&com_id=<%= com_id %>&car_cd=<%= car_cd %>";
    }else {
	 	parent.location.href = "off_ls_after_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&migr_dt=<%= migr_dt %>&migr_gu=<%= migr_gu %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>&car_st=<%= car_st %>&com_id=<%= com_id %>&car_cd=<%= car_cd %>";
	}
}

	//서류수령일등 저장 
function reg_dt()
	{
		var fm = document.form1;
		
		if(fm.conj_dt.value == ""){ alert("서류수령일을 입력하세요!!."); return;}
		if(fm.est_dt.value == ""){ alert("서류발송예정일을 입력하세요!!."); return;}
								
		if(confirm('등록정보를 저장하시겠습니까?'))
		{		
			fm.target = 'i_no';
			fm.action = 'off_ls_after_dt_upd_a.jsp'
			fm.submit();
		}		
	
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
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 경매관리 > 매각사후관리 > <span class=style5>매각사후현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align=right><a href="javascript:list('<%=from_page%>')"><img src=../images/center/button_list.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
	    <td class=line>
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
			    <tr> 
			        <td class=title width="16%" style='height:28'>차량번호</td>
                  <td  width="44%">&nbsp;&nbsp;&nbsp;<b><%=car_no%></b> </td>              
                  <td width="40%">&nbsp;&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>서류수령일</span>
                    &nbsp;<input type='text' size='11' name='conj_dt' value="<%= AddUtil.ChangeDate2(seBean.getConj_dt()) %>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                     &nbsp; &nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>서류발송예정일</span>
                    &nbsp;<input type='text' size='11' name='est_dt' value="<%= AddUtil.ChangeDate2(seBean.getEst_dt()) %>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    &nbsp;&nbsp;&nbsp;
                       <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>   
                    <a href="javascript:reg_dt()"><img src=../images/center/button_save.gif border=0 align=absmiddle></a>                     
                    <% } %>
                    </td>             
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
            <a href="javascript:open_auction()"><img src=../images/center/button_p_gmgl.gif border=0 align=absmiddle></a>&nbsp; 
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