<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕'; }
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0; text-align:center;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#322719;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%;}
#footer {float:left; width:100%; height:50px; background:#CCC; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; text-align:middle; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/cl_smain_mbg.gif);}
#gnb_menu a{text-decoration:none; color:#fff; line-height:32px; display:block;}
#menu_mn {float:left; height:47px; font-size:0.95em; font-weight:bold; text-align:left;}
#menu_mnt {float:left;  padding:10px 0 0 4px; color:#fff; font-weight:bold;}
#menu_tt {float:right; font-weight:bold; color:#fff; padding:10px 55px 0 0; position:absolute; right:0;}
#menu_tt em{color:#4ff5f3}
#menu_mrg {float:right;}


#gnb_sum {float:left; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/fms_smain_bg.gif);}
#gnb_tt {float:left; height:47px; font-size:0.95em; font-weight:bold; text-align:left;}
#gnb_t {float:left;  padding:15px 0 0 4px; color:#fff; font-weight:bold;}
#gnb_pr {float:right; font-weight:bold; color:#fff; padding:15px 55px 0 0; position:absolute; right:0;}
#gnb_pr em{color:#fde83a}
#gnb_mrg {float:right;}

/* 로고 */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

.List li {padding:0 21px;border-bottom:0px #eaeaea solid; color:#fff; font-weight:bold;}

</style>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //계약건수
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	String mode = "client";
	if(from_page.equals("cont_menu.jsp")) mode = "cont";
	
	
	//미수금 정산-연체
	Hashtable ht1 = s_db.getContSettleCase1("2", "", rent_l_cd, client_id, mode, "", "");//(String gubun, String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	
	
	//미청구+잔가
	Vector end_lists = s_db.getStatSettleSubItemList	("", rent_l_cd, "", client_id, "", "", "미청구+잔가", "", mode);//(String m_id, String l_cd, String car_mng_id, String client_id, String site_id, String bus_id2, String gubun1, String mode)
	int end_size = end_lists.size();
	long end_t_amt 	= 0;
	if(end_size > 0){
		for (int i = 0 ; i < end_size ; i++){
			Hashtable ht = (Hashtable)end_lists.elementAt(i);
			end_t_amt += AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
		}
	}
	
	//연체이자
	Vector dly_lists = s_db.getStatSettleSubItemList	("", rent_l_cd, "", client_id, "", "", "연체이자", "", mode);
	int dly_size = dly_lists.size();
	long dly_t_amt 	= 0;
	if(dly_size > 0){
		for (int i = 0 ; i < dly_size ; i++){
			Hashtable ht = (Hashtable)dly_lists.elementAt(i);
			dly_t_amt += AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
		}
	}
	
	long settle_total_amt 	= end_t_amt+dly_t_amt+AddUtil.parseLong(String.valueOf(ht1.get("EST_AMT1")))+AddUtil.parseLong(String.valueOf(ht1.get("EST_AMT3")))+AddUtil.parseLong(String.valueOf(ht1.get("EST_AMT4")))+AddUtil.parseLong(String.valueOf(ht1.get("EST_AMT2")))+AddUtil.parseLong(String.valueOf(ht1.get("EST_AMT7")))+AddUtil.parseLong(String.valueOf(ht1.get("EST_AMT6")))+AddUtil.parseLong(String.valueOf(ht1.get("EST_AMT5")));
%>
<script language='javascript'>
<!--
	function view_info(s_item)
	{
		var fm = document.form1;		
		fm.s_item.value = s_item;				
		fm.action = "settle_item_list.jsp";
		fm.submit();
	}
	
	function view_before()
	{
		var fm = document.form1;		
		if(fm.from_page.value == 'fms_menu.jsp') fm.action = 'fms_menu.jsp';
		if(fm.from_page.value == 'cont_menu.jsp') fm.action = 'cont_menu.jsp';
		fm.submit();
	}	
	
	function view_sitemap()
	{
		var fm = document.form1;	
		fm.action = "sitemap.jsp";		
		fm.submit();
	}								
//-->
</script>
</head>
<body>
<form name="form1" method="post" action="">
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>		
	<input type='hidden' name='from_page' 	value='<%=from_page%>'>			
	<input type='hidden' name='s_item'		value=''>

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%if(from_page.equals("fms_menu.jsp")){%>
				<%=AddUtil.subData(firm_nm, 6)%>
				<%}else{%>
				<%=car_no%>
				<%}%>
			</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
    	<div id="gnb_sum">
    		<div id="gnb_tt"><img src="/smart/images/fms_smain_mrl.gif" alt="menu1" /></div>
        	<div id="gnb_t">합계</div>
        	<div id="gnb_pr"><em><%=AddUtil.parseDecimal(settle_total_amt)%> 원</em></div>
        	 <div id="gnb_mrg"><img src="/smart/images/fms_smain_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('선수금')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></a></div>
			<div id="menu_mnt"> <a href="javascript:view_info('선수금')" onMouseOver="window.status=''; return true">선수금</a></div>
            <div id="menu_tt"> <a href="javascript:view_info('선수금')" onMouseOver="window.status=''; return true"><em><%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht1.get("EST_AMT1")))%> 원</em></a></div>
            <div id="menu_mrg"><a href="javascript:view_info('선수금')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('과태료')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></a></div>
            <div id="menu_mnt"> <a href="javascript:view_info('과태료')" onMouseOver="window.status=''; return true">과태료</a></div>
            <div id="menu_tt"> <a href="javascript:view_info('과태료')" onMouseOver="window.status=''; return true"><em><%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht1.get("EST_AMT3")))%> 원</em></a></div>
            <div id="menu_mrg"><a href="javascript:view_info('과태료')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('면책금')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></a></div>
			<div id="menu_mnt"> <a href="javascript:view_info('면책금')" onMouseOver="window.status=''; return true">면책금</a></div>
            <div id="menu_tt"> <a href="javascript:view_info('면책금')" onMouseOver="window.status=''; return true"><em><%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht1.get("EST_AMT4")))%> 원</em></a></div>
            <div id="menu_mrg"><a href="javascript:view_info('면책금')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('연체이자')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></a></div>
            <div id="menu_mnt"> <a href="javascript:view_info('연체이자')" onMouseOver="window.status=''; return true">연체이자</a></div>
            <div id="menu_tt"> <a href="javascript:view_info('연체이자')" onMouseOver="window.status=''; return true"><em><%=AddUtil.parseDecimal(dly_t_amt)%> 원</em></a></div>
            <div id="menu_mrg"><a href="javascript:view_info('연체이자')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></a></div>
        </div>		
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('대여료')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></a></div>
			<div id="menu_mnt"> <a href="javascript:view_info('대여료')" onMouseOver="window.status=''; return true">대여료</a></div>
            <div id="menu_tt"> <a href="javascript:view_info('대여료')" onMouseOver="window.status=''; return true"><em><%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht1.get("EST_AMT2")))%> 원</em></a></div>
            <div id="menu_mrg"><a href="javascript:view_info('대여료')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('단기대여료')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></a></div>
            <div id="menu_mnt"> <a href="javascript:view_info('단기대여료')" onMouseOver="window.status=''; return true">단기대여료</a></div>
            <div id="menu_tt"> <a href="javascript:view_info('단기대여료')" onMouseOver="window.status=''; return true"><em><%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht1.get("EST_AMT7")))%> 원</em></a></div>
            <div id="menu_mrg"><a href="javascript:view_info('단기대여료')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></a></div>
        </div>		
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('해지정산금')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></a></div>
            <div id="menu_mnt"> <a href="javascript:view_info('해지정산금')" onMouseOver="window.status=''; return true">해지정산금</em></a></div>
            <div id="menu_tt"> <a href="javascript:view_info('해지정산금')" onMouseOver="window.status=''; return true"><em><%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht1.get("EST_AMT6")))%> 원</em></a></div>
            <div id="menu_mrg"><a href="javascript:view_info('해지정산금')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('미청구+잔가')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></a></div>
            <div id="menu_mnt"> <a href="javascript:view_info('미청구+잔가')" onMouseOver="window.status=''; return true">미청구+잔가</a></div>
            <div id="menu_tt"> <a href="javascript:view_info('미청구+잔가')" onMouseOver="window.status=''; return true"><em><%=AddUtil.parseDecimal(end_t_amt)%> 원</em></a></div>
            <div id="menu_mrg"><a href="javascript:view_info('미청구+잔가')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('휴/대차료')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></a></div>
			<div id="menu_mnt"> <a href="javascript:view_info('휴/대차료')" onMouseOver="window.status=''; return true">휴/대차료</a></div>
            <div id="menu_tt"> <a href="javascript:view_info('휴/대차료')" onMouseOver="window.status=''; return true"><em><%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht1.get("EST_AMT5")))%> 원</em></a></div>
            <div id="menu_mrg"><a href="javascript:view_info('휴/대차료')" onMouseOver="window.status=''; return true"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></a></div>
        </div>

		
    </div>
    <div id="footer"></div>
</div>
</form>

</body>
</html>
