<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS_Search_Cont</title>
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
#wrap {float:left; margin:0 auto; width:100%; background-color:#ffffff;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu a{text-decoration:none; color:#fff;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

/* 검색창 */
#search fieldset {padding:0px 0px; border:0px;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .name {float:left; position:absolute; width:100px; margin:5px 20px 0 20px; color:#ffe4a9;}
#search .userform .userinput {padding-right:60px; height:50px; margin:0 20px 0 85px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:25px;}

/* 리스트 */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '나눔고딕'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

/* UI Object */

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}
/* //UI Object */


/* UI Object */
.lst_type{width:auto;padding:20px;border:1px solid #c2c2c2;list-style:none; background-color:#ffffff; font-family:'나눔고딕',Dotum;font-size:15px;}
.lst_type li{margin-bottom:5px;font-family:'나눔고딕',Dotum;font-size:15px;font-weight:normal;line-height:14px;vertical-align:top}
.lst_type li a{color:#1478CD;text-decoration:none;font-family:'나눔고딕',Dotum;font-size:20px;font-weight:normal;line-height:30px;display:inline;} /*링크*/
.lst_type li em{color:#f84e12}
.lst_type li a:hover{text-decoration:underline}
/* //UI Object */

</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="t_db" scope="page" class="tax.TaxDatabase"/>
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
	
	String s_yy 		= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 		= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	
	Vector vt = new Vector();
	
	if(st.equals("7")) 	vt = t_db.getTaxList2(client_id, site_seq, s_yy, s_mm); //거래처별세금계산서
	else   				vt = t_db.getTaxList2(client_id, site_seq, s_yy, s_mm); //거래처별세금계산서
	
	int vt_size = vt.size();
%> 

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.action = 'tax_list.jsp';
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}

	//트러스빌 공급자용
	function  viewTaxInvoice(pubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=680px, height=760px");
		document.form1.action="https://www.trusbill.or.kr/jsp/directTax/TaxViewIndex.jsp";
		document.form1.method="post";
		document.form1.pubCode.value=pubCode;
		document.form1.docType.value="T"; //세금계산서
		document.form1.userType.value="S"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
		document.form1.target="taxInvoice";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.pubCode.value="";
		taxInvoice.focus();
		return;
	}
	
	/*
 	//계약서 내용 보기
	function view_tax(client_id, firm_nm, rent_mng_id, rent_l_cd, car_mng_id, car_no, car_nm){
		var fm = document.form1;
		fm.client_id.value 		= client_id;
		fm.firm_nm.value 		= firm_nm;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.car_mng_id.value 	= car_mng_id;
		fm.car_no.value 		= car_no;
		fm.car_nm.value 		= car_nm;
		fm.action = 'tax_view.jsp';
		fm.submit();
	}
	*/
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "tax_view.jsp";		
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
<form name='form1' method='post' action='tax_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
	  
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
	<input type='hidden' name='tax_no' 		value=''>
	
	<input type='hidden' name="pubCode" value="">
	<input type='hidden' name="docType" value="">
	<input type='hidden' name="userType" value="">	
	
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login"><span title='<%=firm_nm%>'><%=AddUtil.subData(firm_nm, 6)%></span></div>
            <div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
    	<div id="search">
<!--ui object -->
		<fieldset class="srch">
			<legend>검색영역</legend>
			<select name="s_yy" >
          		<% for(int i=2002; i<=AddUtil.getDate2(1); i++){%>
          		<option value="<%=i%>" <%if(i == AddUtil.parseInt(s_yy)){%> selected <%}%>><%=i%>년도</option>
          		<%}%>
        	</select>
			<select name="s_mm">
          		<option value="" <%if(s_mm.equals("")){%> selected <%}%>>전체</option>        
          		<% for(int i=1; i<=12; i++){%>        
          		<option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(s_mm)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
          		<%}%>
        	</select> 			
			<input alt=검색 src="/smart/images/btn_srch.gif" type="image"> 
		</fieldset> 
<!--//ui object -->
		</div>
		<br>
	
		 <%for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
			<ul class="lst_type">
				<li>
					<!--<a href="javascript:view_tax('<%=ht.get("TAX_NO")%>')" onMouseOver="window.status=''; return true" title='계산서상세내역'>-->
						<span><h3>(<%=i+1%>) <font color=#990000><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></font> | <%=Util.parseDecimal(String.valueOf(ht.get("TAX_AMT")))%>원</h3></span>
					<!--</a>-->
					<br> 					
					| <%=ht.get("FIRM_NM")%> | <%=ht.get("ENP_NO")%>
					<br> 	
					| <%=ht.get("TAX_G")%> | <%=ht.get("TAX_BIGO")%>
					  <%if(String.valueOf(ht.get("PUBCODE")).equals("") || String.valueOf(ht.get("STATUS")).equals("발급취소")){%>-
					  <%}else{%>
					  	<%if(!String.valueOf(ht.get("STATUS")).equals("대기")){%><!--<a href="javascript:viewTaxInvoice('<%=ht.get("PUBCODE")%>');">--><%}%>
                      	<%if(ht.get("STATUS").equals("수신자미등록")){%><img src=http://fms.amazoncar.co.kr/service/sub/images/button_bill_nreg.gif align=absmiddle border=0>
                      	<%}else if(ht.get("STATUS").equals("수신자미확인")){%><img src=http://fms.amazoncar.co.kr/service/sub/images/button_bill_nconf.gif align=absmiddle border=0>
                      	<%}else if(ht.get("STATUS").equals("수신자미승인")){%><img src=http://fms.amazoncar.co.kr/service/sub/images/button_bill_napp.gif align=absmiddle border=0>
                     	<%}else if(ht.get("STATUS").equals("수신자승인")){%><img src=http://fms.amazoncar.co.kr/service/sub/images/button_bill_app.gif align=absmiddle border=0>
                      	<%}else if(ht.get("STATUS").equals("수신거부")){%><img src=http://fms.amazoncar.co.kr/service/sub/images/button_bill_rej.gif align=absmiddle border=0>
                      	<%}else if(ht.get("STATUS").equals("수신자발행취소요청")){%><img src=http://fms.amazoncar.co.kr/service/sub/images/button_bill_pcanc.gif align=absmiddle border=0>
                      	<%}else if(ht.get("STATUS").equals("발급취소")){%><img src=http://fms.amazoncar.co.kr/service/sub/images/button_bill_canc.gif align=absmiddle border=0>
                      	<%}else{%><img src=http://fms.amazoncar.co.kr/service/sub/images/button_bill_wait.gif align=absmiddle border=0>
                      	<%}%>
					  	<%if(!String.valueOf(ht.get("STATUS")).equals("대기")){%><!--</a>--><%}%>
					  <%}%>
				</li>
			</ul>
          <%}%>
		  <%if(vt_size==0){%>
			<ul class="lst_type">
				<li><span>데이타가 없습니다.</span>
				</li>
			</ul>		  
		  <%}%>		  
	</div>     
</div>
</form>
</body>
</html>