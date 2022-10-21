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

table th{
	padding-top:2px;
	background-color:#eee;
	border:1px solid #c6c6c6;
	line-height:1.2em;
}
table td{
	padding-top:3px;
	border:1px solid #c6c6c6;
	line-height:1.2em;
	text-align:right;
	font-weight:bold;
}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_actn.*"%>
<%@ include file="/smart/cookies.jsp" %>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<%	
	String s_yy 		= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 		= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	String actn_id 		= request.getParameter("actn_id")==null?"":request.getParameter("actn_id");

//	String idx = request.getParameter("idx")==null?"":request.getParameter("idx"); 
	String iw = request.getParameter("iw")==null?"":request.getParameter("iw"); 
	
	Vector vt = olaD.AuctionMobileList(s_yy, s_mm , iw);
	
	int actn_size = vt.size();
	
	int no = 0;	
	int s_su1 = 0; //서울경매장 출품댓수
	int g_su1 = 0; //글로비스 출품댓수
	int s_su2 = 0; //서울경매장 낙찰댓수
	int g_su2 = 0; //글로비스 낙찰댓수
	long s_su2_amt = 0; //서울경매장 낙찰가 합계
	long g_su2_amt = 0; //글로비스 낙찰가 합계
	long s_su3_amt = 0; //서울경매장 탁송료 - 면제
	long s_su4_amt = 0; //서울경매장 출품수수료 - 면제
	long s_su5_amt = 0; //서울경매장 재출품수수료 - 면제
	long s_su6_amt = 0; //서울경매장 낙찰수수료 - 낙찰가 * 2% + 부가세 10%, 최대금액 33만원
	long s_su7_amt = 0; //서울경매장 합계
	long s_su8_amt = 0; //서울경매장 입금예정대금
	long g_su3_amt = 0; //글로비스 탁송료 - 서울:34000원, 대전:86000원, 부산:143000원
	long g_su4_amt = 0; //글로비스 출품수수료 - 60500원
	long g_su5_amt = 0; //글로비스 재출품수수료 - 66000원
	long g_su6_amt = 0; //글로비스 낙찰수수료 - 낙찰가 * 2% + 부가세 10%, 최대금액 33만원
	long g_su7_amt = 0; //글로비스 합계
	long g_su8_amt = 0; //글로비스 입금예정대금
	
	String actn_name="에이제이셀카(주) [구 서울경매장]";
		
%> 

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.action = 'car_auction_list.jsp';
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}

	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "stat_main.jsp";		
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='car_auction_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
	  
	
<div id="wrap">
<!--
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">경매현황</span></div>
            <div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>				
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
	-->
	<div id="header">
		<div align="center"><%=s_yy%>년 <%=s_mm%>월 <%if(!iw.equals("")){%><%=iw%>주차<%}%> <%if(idx.equals("1")){%>출품<%}else if(idx.equals("2")){%>유찰<%}else if(idx.equals("3")){%>낙찰<%}%>리스트</div>
		<div align="center"><%=actn_name%></div>
	</div>
    <div id="contents">
		<%if(idx.equals("1")){%>
				 <% for(int i = 0 ; i < actn_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					if (ht.get("ACTN_ID").equals("011723") || ht.get("ACTN_ID").equals("003226") || ht.get("ACTN_ID").equals("020385")) {
					no += 1;
					%>
		<ul class="lst_type">
			<li>					
				<span><h3>(<%=no%>) <font color=#990000><%=ht.get("CAR_NM")%>(<%=ht.get("CAR_NO")%>)</font></h3></span>					
				<br> 					
				| 출품일자 <%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACTN_DT")))%> | 
			</li>
		</ul>
		<%}
		}%>
		<%}else if(idx.equals("2")){%>
		 <% for(int i = 0 ; i < actn_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			if (ht.get("ACTN_ID").equals("011723") || ht.get("ACTN_ID").equals("003226") || ht.get("ACTN_ID").equals("020385")) {
			if(ht.get("ACTN_ST").equals("2")){
			no += 1;
			%>
		<ul class="lst_type">
			<li>					
				<span><h3>(<%=no%>) <font color=#990000><%=ht.get("CAR_NM")%>(<%=ht.get("CAR_NO")%>)</font></h3></span>					
				<br> 					
				| 경매일자 <%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACTN_DT")))%> | 
			</li>
		</ul>
		<%}
		}
		}%>
		<%}else if(idx.equals("3")){%>
		 <% for(int i = 0 ; i < actn_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			if (ht.get("ACTN_ID").equals("011723") || ht.get("ACTN_ID").equals("003226") || ht.get("ACTN_ID").equals("020385")) {
			if(ht.get("ACTN_ST").equals("4")){
			no += 1;
			s_su2_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")));
			%>
		<ul class="lst_type">
			<li>					
				<span><h3>(<%=no%>) <font color=#990000><%=ht.get("CAR_NM")%>(<%=ht.get("CAR_NO")%>)</font></h3></span>					
				<br> 					
				| 경매일자 <%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACTN_DT")))%>  
				<br> 					
				| 낙찰금액 <%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("NAK_PR"))))%>원  
			</li>
		</ul>
		<%}
		}
		}%>
		<ul class="lst_type">
			<li>					
				<span><h3>합계 <font color=#990000><%=AddUtil.parseDecimal(s_su2_amt)%>원</font></h3></span>					
			</li>
		</ul>
		<%}%>
							</table>
						</tr>
					</table>
				</li>
			</ul>
	</div>     
</div>
</form>
</body>
</html>