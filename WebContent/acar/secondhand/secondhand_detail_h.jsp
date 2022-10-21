<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.car_register.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");		
	
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String res_yn 		= request.getParameter("res_yn")	==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")	==null?"":request.getParameter("res_mon_yn");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String jg_code 		= request.getParameter("jg_code")==null?"":request.getParameter("jg_code");
	
	String est_st 		= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?"":request.getParameter("fee_opt_amt");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");	
	
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String spe_seq 		= request.getParameter("spe_seq")==null?"":request.getParameter("spe_seq");
	String est_table 	= request.getParameter("est_table")==null?"":request.getParameter("est_table");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
	
	String br_to_st 	= request.getParameter("br_to_st")==null?"":request.getParameter("br_to_st");
	
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);

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
	var url =   "?auth_rw=<%= auth_rw %>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&gubun2=<%=gubun2%>&gubun_nm=<%=gubun_nm%>&sort_gubun=<%=sort_gubun%>&brch_id=<%=brch_id%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>";
	
	url = url + "&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&jg_code=<%=jg_code%>";
	
	url = url + "&est_st=<%=est_st%>&fee_opt_amt=<%=fee_opt_amt%>&fee_rent_st=<%=fee_rent_st%>&est_id=<%=est_id%>&spe_seq=<%=spe_seq%>&est_table=<%=est_table%>&list_from_page=<%=list_from_page%>&br_to_st=<%=br_to_st%>";
	
	
	//재리스
	function open_secondhand()
	{
		parent.detail_body.location.href = "secondhand_price_20090901.jsp"+url;
	}

	//상세정보
	function open_basic()
	{
		parent.detail_body.location.href = "secondhand_detail_b.jsp"+url;
	}

	//차량이력표
	function open_car_his()
	{
		parent.detail_body.location.href = "/acar/off_lease/off_lease_car_his.jsp"+url;
	}

	//정비기록표
	function open_car_mng()
	{
		parent.detail_body.location.href = "/acar/off_lease/off_lease_car_mng.jsp"+url;
	}

	//사고이력표
	function open_accident()
	{
		parent.detail_body.location.href = "/acar/off_lease/off_lease_accident.jsp"+url;
	}

	//목록
	function list(){
		<%if(list_from_page.equals("/acar/secondhand/sh_mon_rent_frame.jsp")){%>
		parent.location.href = "/acar/secondhand/sh_mon_rent_frame.jsp"+url;
		<%}else{%>
		<%	if(est_st.equals("")){%>
		parent.location.href = "secondhand_grid_frame.jsp"+url;
		<%	}else{%>
		parent.location.href = "/fms2/lc_rent/lc_c_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&sort_gubun=<%=sort_gubun%>&gubun2=<%=gubun2%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=fee_rent_st%>&est_id=<%=est_id%>&spe_seq=<%=spe_seq%>&est_table=<%=est_table%>";
		<%	}%>
		<%}%>
	}

	function open_estimate(){
		parent.detail_body.location.href = "esti_mng_i.jsp"+url;
	}

//-->
</script>
</head>
<body>
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="sort_gubun" value="<%=sort_gubun%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="res_yn" value="<%=res_yn%>">
<input type="hidden" name="res_mon_yn" value="<%=res_mon_yn%>">

<input type="hidden" name="car_mng_id" 	value="<%=car_mng_id%>">
<input type='hidden' name="est_st"	value="<%=est_st%>">      
<input type='hidden' name="fee_opt_amt"	value="<%=fee_opt_amt%>">        
<input type="hidden" name="est_id" 	value="<%=est_id%>">
<input type='hidden' name="spe_seq"	value="<%=spe_seq%>">      
<input type='hidden' name="est_table"	value="<%=est_table%>">        
<input type='hidden' name="list_from_page" value="<%=list_from_page%>">        

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 오프리스현황 > 재리스결정차량현황 > <span class=style5>재리스현황</span></span></td>
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
		    <table border=0 cellspacing=1 cellpadding=0 width=100%>
			    <tr>  
                    <td class=title width="16%" style='height:28'>차량번호</td>
                    <td width="34%">&nbsp;&nbsp;&nbsp;<b><%=cr_bean.getCar_no()%></b></td>
					<td class=title width="16%" style='height:28'>차량명</td>
                    <td width="34%">&nbsp;&nbsp;&nbsp;<b><%=cr_bean.getCar_nm()%></b></td>
        	   </tr>
            </table>
        </td> 
    </tr>
    <tr> 
        <td align=center style='height:40'> 
        	        <a href="javascript:open_secondhand()"><img src=../images/center/button_sh_slease.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
            	    <a href="javascript:open_basic()"><img src=../images/center/button_sh_detail.gif border=0 align=absmiddle></a>&nbsp;&nbsp; 
            	    <a href="javascript:open_car_his()"><img src=../images/center/button_sh_carir.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
            	    <a href="javascript:open_car_mng()"><img src=../images/center/button_sh_jb.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
            	    <a href="javascript:open_accident()"><img src=../images/center/button_sh_acc.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
            	    <input type="button" class="button btn-submit" value="차량상태" onclick="window.open('/acar/rent_prepare/car_rmst.jsp?c_id=<%=car_mng_id%>&car_no=<%=cr_bean.getCar_no()%>&auth_rw=<%=auth_rw%>','delivery','width=500, height=600, toolbar=no, menubar=no, scrollbars=auto, resizable=yes');return false;"/>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>