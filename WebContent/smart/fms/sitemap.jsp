<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 

<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#372b1a;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}


/* 둥근테이블 시작 */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#372b1a; border:3px solid #ffc46a;}
    #type4 .corner {background-image:url(/smart/images/corners-type2.gif);}
        #type4 .topLeft {top:-3px;left:-3px;}
        #type4 .topRight {top:-3px; right:-3px;}
        #type4 .bottomLeft {bottom:-3px; left:-3px;}
        #type4 .bottomRight {bottom:-3px; right:-3px;}

/* 내용테이블 */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:18px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; margin:5px 0;}
.contents_box1 th {color:#c88b28;line-height:22px; width:115px; font-size:18px; height:26px; text-align:left; font-weight:bold;}
.contents_box1 th a {color:#c88b28; font-weight:bold; text-decoration:none;}
.contents_box1 td {font-size:15px; color:#fff; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:#fff; font-weight:bold; text-decoration:none;}
.contents_box1 td.row {font-size:13px; color:#a69e94; font-weight:bold;}
.contents_box1 td.row a{ color:#a69e94; font-weight:bold; text-decoration:none;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}



</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.client.*, acar.cont.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
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
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	if(firm_nm.equals("")) firm_nm = client.getFirm_nm();
	
	//사업장현황
	Vector vt = a_db.getContClientStat(client_id, "");
	int vt_size = vt.size();
%>

<style type=text/css>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #828282;
         font-size: 11px;}
.style2 {color: #ff00ff;
         font-size: 11px;} 
.style3 {color: #727272}
.style4 {color: #ef620c}
.style5 {color: #334ec5;
        font-weight: bold;} 
-->

</style>


<script language='javascript'>
<!--
	function mode_page(menu_url, from_page)
	{
		var fm = document.form1;
		fm.from_page.value = from_page;	
		if(menu_url == 'cont_list.jsp'){
			fm.site_nm.value = '';		
			fm.site_seq.value = '';	
		}		
		fm.action = menu_url;				
		fm.submit();
	}	
	
	function mode_page_site(st)
	{
		var fm = document.form1;	
		fm.st.value = st;	
		fm.action = "client_site_list.jsp";
		fm.submit();
	}		
	
	function view_info_site(st, site_nm, site_seq)
	{
		var fm = document.form1;	
		fm.site_nm.value = site_nm;		
		fm.site_seq.value = site_seq;			
		if(st == '4'){	
			fm.action = "cont_list.jsp";			//차량리스트			
			fm.t_wd.value = '';
			fm.s_kd.value = '';			
		}else if(st == '2'){
			fm.st.value = st;
			if(site_seq == '00'){
				fm.action = "client_view_base.jsp";	 //본사 정보
			}else{
				fm.action = "client_site_view.jsp";	 //사업장 정보
			}			
		}
		fm.submit();
	}	
			
	function view_info_settle(from_page, s_item)
	{
		var fm = document.form1;	
		fm.from_page.value = from_page;			
		fm.s_item.value = s_item;			
		fm.action = "settle_item_list.jsp";
		fm.submit();
	}			
	
//-->
</script>

</head>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>
	<input type='hidden' name='from_page' 	value='<%=from_page%>'>
	<input type='hidden' name='s_item' 		value=''>

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">FMS 전체메뉴</span></div>
			<div id="gnb_home">
				<a href=/smart/fms/fms_list.jsp onMouseOver="window.status=''; return true" title='검색'><img src=/smart/images/button_search.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<!-- 고객메인 -->
						<tr>
							<th><a href="javascript:mode_page('fms_menu.jsp', '')" onMouseOver="window.status=''; return true">고객메인</a></th>
						</tr>
						<tr>
							<td height=5></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('client_view_base.jsp', 'fms_menu.jsp')" onMouseOver="window.status=''; return true">고객 기본정보</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page_site('2')" onMouseOver="window.status=''; return true">사업장별고객정보</a></td>
						</tr>
						<tr>
							<td height=2></td>
						</tr>
						<tr>
							<td class=row>
							<%	for (int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);%>								
								<a href="javascript:view_info_site('2', '<%=ht.get("R_SITE")%>', '<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true"><%=ht.get("R_SITE")%><em><%=ht.get("CONT_Y_CNT")%>대</em></a>
								<%if(i+1 < vt_size){%>
								&nbsp;/&nbsp; 
								<%}%>
							<%	}%>	
							</td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cont_list.jsp', 'fms_menu.jsp')" onMouseOver="window.status=''; return true">사업자단위 계약조회</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page_site('4')" onMouseOver="window.status=''; return true">사업장단위 계약조회</a></td>
						</tr>
						<tr>
							<td height=2></td>
						</tr>
						<tr>
							<td class=row>
							<%	for (int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);%>								
								<a href="javascript:view_info_site('4', '<%=ht.get("R_SITE")%>', '<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true"><%=ht.get("R_SITE")%><em><%=ht.get("CONT_Y_CNT")%>대</em></a>
								<%if(i+1 < vt_size){%>
								&nbsp;/&nbsp; 
								<%}%>
							<%	}%>								
							</td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('settle_list.jsp', 'fms_menu.jsp')" onMouseOver="window.status=''; return true">거래처별 미수금조회</a></td>
						</tr>
						<tr>
							<td height=2></td>
						</tr>
						<tr>
							<td class=row>
								<a href="javascript:view_info_settle('fms_menu.jsp', '선수금')" onMouseOver="window.status=''; return true">선수금</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('fms_menu.jsp', '과태료')" onMouseOver="window.status=''; return true">과태료</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('fms_menu.jsp', '면책금')" onMouseOver="window.status=''; return true">면책금</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('fms_menu.jsp', '연체이자')" onMouseOver="window.status=''; return true">연체이자</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('fms_menu.jsp', '대여료')" onMouseOver="window.status=''; return true">대여료</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('fms_menu.jsp', '단기대여료')" onMouseOver="window.status=''; return true">단기대여료</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('fms_menu.jsp', '해지정산금')" onMouseOver="window.status=''; return true">해지정산금</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('fms_menu.jsp', '미청구+잔가')" onMouseOver="window.status=''; return true">미청구+잔가</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('fms_menu.jsp', '휴/대차료')" onMouseOver="window.status=''; return true">휴·대차료</a>
								</td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cms_view.jsp', 'fms_menu.jsp')" onMouseOver="window.status=''; return true">CMS정보</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('tax_view.jsp', 'fms_menu.jsp')" onMouseOver="window.status=''; return true">세금계산서정보</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('client_vst_list.jsp', 'fms_menu.jsp')" onMouseOver="window.status=''; return true">거래처방문기록</a></td>
						</tr>
						<tr>
							<td height=20></td>
						</tr>
						<%if(!rent_l_cd.equals("")){%>						
						<tr>
							<td bgcolor=#977440 height=1></td>
						</tr>
						<tr>
							<td height=20></td>
						</tr>
				<!-- 계약메인 -->
						<tr>
							<th><a href="javascript:mode_page('cont_menu.jsp', '')" onMouseOver="window.status=''; return true">계약메인</a></th>
						</tr>
						<tr>
							<td height=5></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cont_main.jsp', 'cont_menu.jsp')" onMouseOver="window.status=''; return true">계약내용</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('car_main.jsp', 'cont_menu.jsp')" onMouseOver="window.status=''; return true">자동차</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cms_view.jsp', 'cont_menu.jsp')" onMouseOver="window.status=''; return true">CMS정보</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('tax_view.jsp', 'cont_menu.jsp')" onMouseOver="window.status=''; return true">세금계산서</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('settle_list.jsp', 'cont_menu.jsp')" onMouseOver="window.status=''; return true">미수금조회</a></td>
						</tr>
						<tr>
							<td height=2></td>
						</tr>
						<tr>
							<td class=row>
								<a href="javascript:view_info_settle('cont_menu.jsp', '선수금')" onMouseOver="window.status=''; return true">선수금</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('cont_menu.jsp', '과태료')" onMouseOver="window.status=''; return true">과태료</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('cont_menu.jsp', '면책금')" onMouseOver="window.status=''; return true">면책금</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('cont_menu.jsp', '연체이자')" onMouseOver="window.status=''; return true">연체이자</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('cont_menu.jsp', '대여료')" onMouseOver="window.status=''; return true">대여료</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('cont_menu.jsp', '단기대여료')" onMouseOver="window.status=''; return true">단기대여료</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('cont_menu.jsp', '해지정산금')" onMouseOver="window.status=''; return true">해지정산금</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('cont_menu.jsp', '미청구+잔가')" onMouseOver="window.status=''; return true">미청구+잔가</a> &nbsp;/&nbsp; 
								<a href="javascript:view_info_settle('cont_menu.jsp', '휴/대차료')" onMouseOver="window.status=''; return true">휴·대차료</a>
							</td>
						</tr>
						<tr>
							<td height=20></td>
						</tr>
						<tr>
							<td bgcolor=#977440 height=1></td>
						</tr>
						<tr>
							<td height=20></td>
						</tr>
				<!-- 계약내용메인 -->
						<tr>
							<th><a href="javascript:mode_page('cont_main.jsp', '')" onMouseOver="window.status=''; return true">계약내용메인</a></th>
						</tr>
						<tr>
							<td height=5></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cont_view_base.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">기본사항<font size=2>(주요일정,관리구분,대여료,기타,보험)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cont_view_etc.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">특약사항<font size=2>(신용평가,대여차량,보험사항,대여요금,영업효율)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cont_view_janga.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">잔가<font size=2>(차량가격,잔가,매입옵션)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cont_view_grt.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">선수금<font size=2>(차량가격,보증금,선납금,개시대여료)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cont_view_fee.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">대여료<font size=2>(정상요금,계약요금)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cont_view_incom.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">수금현황<font size=2>(항목별 수금리스트)</font></a></td>
						</tr>
						<tr>
							<td height=2></td>
						</tr>
						<tr>
							<td class=row>
								<a href="javascript:mode_page('cont_view_incom_pre.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">선수금</a> &nbsp;/&nbsp; 
								<a href="javascript:mode_page('cont_view_incom_fine.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">과태료</a> &nbsp;/&nbsp; 
								<a href="javascript:mode_page('cont_view_incom_serv.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">면책금</a> &nbsp;/&nbsp; 
								<a href="javascript:mode_page('cont_view_incom_dly.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">연체이자</a> &nbsp;/&nbsp; 
								<a href="javascript:mode_page('cont_view_incom_fee.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">대여료</a> &nbsp;/&nbsp; 
								<a href="javascript:mode_page('cont_view_incom_rent.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">단기대여료</a> &nbsp;/&nbsp; 
								<a href="javascript:mode_page('cont_view_incom_cls.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">해지정산금</a> &nbsp;/&nbsp; 
								<a href="javascript:mode_page('cont_view_incom_accid.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">휴·대차료</a>
							</td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('cont_view_emp.jsp', 'cont_main.jsp')" onMouseOver="window.status=''; return true">영업사원<font size=2>(영업담당자,출고담당자)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td height=20></td>
						</tr>
						<tr>
							<td bgcolor=#977440 height=1></td>
						</tr>
						<tr>
							<td height=20></td>
						</tr>
				<!-- 자동차메인 -->
						<tr>
							<th><a href="javascript:mode_page('car_main.jsp', '')" onMouseOver="window.status=''; return true">자동차메인</a></th>
						</tr>
						<tr>
							<td height=5></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('car_view_base.jsp', 'car_main.jsp')" onMouseOver="window.status=''; return true">기본정보<font size=2>(등록사항,관리사항)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('car_view_pur.jsp', 'car_main.jsp')" onMouseOver="window.status=''; return true">구매정보<font size=2>(출고사항,차량가격)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('car_view_opt.jsp', 'car_main.jsp')" onMouseOver="window.status=''; return true">사양정보<font size=2>(기본사양품목,선택사양품목,출고후추가장착품목,서비스품목,기타)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('car_view_his.jsp', 'car_main.jsp')" onMouseOver="window.status=''; return true">이력정보<font size=2>(번호변경이력,장기대여이력,단기대여이력)</font></a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('car_view_accid.jsp', 'car_main.jsp')" onMouseOver="window.status=''; return true">사고정보</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('car_view_serv.jsp', 'car_main.jsp')" onMouseOver="window.status=''; return true">정비정보</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('car_view_maint.jsp', 'car_main.jsp')" onMouseOver="window.status=''; return true">검사정보</a></td>
						</tr>
						<tr>
							<td height=8></td>
						</tr>
						<tr>
							<td><a href="javascript:mode_page('car_view_ins.jsp', 'car_main.jsp')" onMouseOver="window.status=''; return true">종합보험<font size=2>(보험계약,청약사항)</font></a></td>
						</tr>
						<%}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div> 
	</div>	
    <div id="footer"></div>  
</div>
</form>
</body>
</html>
