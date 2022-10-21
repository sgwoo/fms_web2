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
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
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
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}

/* 내용테이블 */
.contents_box {width:100%; table-layout:fixed; font-size:14px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:18px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font-size:14px; margin:5px 5px;}
.contents_box1 th {color:#282828; width:115px; height:26px; text-align:left; font-weight:bold;}
.contents_box1 td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font-size:16px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.res_search.*  "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_s_cd 	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //계약건수
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	
	//단기대여정보
	RentFeeBean rf_bean = rs_db.getRentFeeCase(rent_s_cd);
	
	//선수금정보
	ScdRentBean sr_bean0 = rs_db.getScdRentCase(rent_s_cd, "6");
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(rent_s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(rent_s_cd, "2");
	
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
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_s_cd'	value='<%=rent_s_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>		

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%if(car_no.equals("미등록")){%><%//=rent_l_cd%><%=car_nm%><%}else{%><%=car_no%><%}%>
			</div>
			<div id="gnb_home">
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">대여요금</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
							<th width=100px>공 &nbsp;&nbsp;급&nbsp;&nbsp; 가</th>
							<td><%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>원</td>
						</tr>
						<tr>
							<th>부 &nbsp;&nbsp;가&nbsp;&nbsp; 세</th>
							<td><%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>원</td>
						</tr>
						<tr>
							<th>합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계</th>
							<td><font color=#fd5f00><%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>원</font></td>
						</tr>
						<tr>
							<th>최초결제금액</th>
							<td><%=AddUtil.parseDecimal(rf_bean.getF_rent_tot_amt())%>원 (최초결제방식:<%if(rf_bean.getF_paid_way().equals("1")){%>1개월치<%}%><%if(rf_bean.getF_paid_way().equals("2")){%>총액<%}%>, 반차료:<%if(rf_bean.getF_paid_way2().equals("1")){%>포함<%}%><%if(rf_bean.getF_paid_way2().equals("2")){%>미포함<%}%>)</td>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">보증금</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>납부구분</th>
							<td>
								<%if(sr_bean0.getPaid_st().equals("1")){%>현금<%}%>
								<%if(sr_bean0.getPaid_st().equals("2")){%>신용카드<%}%>
								<%if(sr_bean0.getPaid_st().equals("3")){%>자동이체<%}%>
								<%if(sr_bean0.getPaid_st().equals("4")){%>무통장입금<%}%>
							</td>
						</tr>
						<tr>
							<th width=100px>입금 예정일</th>
							<td><%=AddUtil.ChangeDate2(sr_bean0.getEst_dt())%></td>
						</tr>
						<tr>
							<th>입 금 일 자</th>
							<td><%=AddUtil.ChangeDate2(sr_bean0.getPay_dt())%></td>
						</tr>
						<tr>
							<th>청 구 금 액</th>
							<td><font color=#fd5f00><%=AddUtil.parseDecimal(sr_bean0.getRent_s_amt()+sr_bean0.getRent_v_amt())%>원</font></td>
						</tr>
						<tr>
							<th>입 금 금 액</th>
							<td><%=AddUtil.parseDecimal(sr_bean0.getPay_amt())%>원</td>
						</tr>
				    	<tr>
				    		<th>청 구 잔 액</th>
				    		<td>계약종료후 환불할 보증금</td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">예약금</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>납부구분</th>
							<td>
								<%if(sr_bean1.getPaid_st().equals("1")){%>현금<%}%>
								<%if(sr_bean1.getPaid_st().equals("2")){%>신용카드<%}%>
								<%if(sr_bean1.getPaid_st().equals("3")){%>자동이체<%}%>
								<%if(sr_bean1.getPaid_st().equals("4")){%>무통장입금<%}%>
							</td>
						</tr>
						<tr>
							<th width=100px>입금 예정일</th>
							<td><%=AddUtil.ChangeDate2(sr_bean1.getEst_dt())%></td>
						</tr>
						<tr>
							<th>입 금 일 자</th>
							<td><%=AddUtil.ChangeDate2(sr_bean1.getPay_dt())%></td>
						</tr>
						<tr>
							<th>청 구 금 액</th>
							<td><font color=#fd5f00><%=AddUtil.parseDecimal(sr_bean1.getRent_s_amt()+sr_bean1.getRent_v_amt())%>원</font></td>
						</tr>
						<tr>
							<th>입 금 금 액</th>
							<td><%=AddUtil.parseDecimal(sr_bean1.getPay_amt())%>원</td>
						</tr>
				    	<tr>
				    		<th>청 구 잔 액</th>
				    		<td><%=AddUtil.parseDecimal(sr_bean1.getRest_amt())%>원</td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">선수대여료</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>납부구분</th>
							<td>
								<%if(sr_bean2.getPaid_st().equals("1")){%>현금<%}%>
								<%if(sr_bean2.getPaid_st().equals("2")){%>신용카드<%}%>
								<%if(sr_bean2.getPaid_st().equals("3")){%>자동이체<%}%>
								<%if(sr_bean2.getPaid_st().equals("4")){%>무통장입금<%}%>
							</td>
						</tr>
						<tr>
							<th width=100px>입금 예정일</th>
							<td><%=AddUtil.ChangeDate2(sr_bean2.getEst_dt())%></td>
						</tr>
						<tr>
							<th>입 금 일 자</th>
							<td><%=AddUtil.ChangeDate2(sr_bean2.getPay_dt())%></td>
						</tr>
						<tr>
							<th>청 구 금 액</th>
							<td><font color=#fd5f00><%=AddUtil.parseDecimal(sr_bean2.getRent_s_amt()+sr_bean2.getRent_v_amt())%>원</font></td>
						</tr>
						<tr>
							<th>입 금 금 액</th>
							<td><%=AddUtil.parseDecimal(sr_bean2.getPay_amt())%>원</td>
						</tr>
				    	<tr>
				    		<th>청 구 잔 액</th>
				    		<td><%=AddUtil.parseDecimal(sr_bean2.getRest_amt())%>원</td>
				    	</tr>
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