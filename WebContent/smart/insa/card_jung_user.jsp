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
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>
<%@ include file="/smart/cookies.jsp" %>

<%	
	String s_yy 		= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 		= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	AssetDatabase a_db = AssetDatabase.getInstance();
		
	Vector vt = vt = a_db.getAssetSaleList(s_yy, s_mm);
	int cont_size = vt.size();
	
	long t_amt1[] = new long[1];  //기초가액
    	long t_amt2[] = new long[1];  //당기 증가
    	long t_amt3[] = new long[1];  //충당금 증가
    	long t_amt4[] = new long[1];  // 당기 감소
    	long t_amt5[] = new long[1];  //충당금 감소
    	long t_amt6[] = new long[1];  //전기말 충당금
    	long t_amt7[] = new long[1];  //당기말의 장부가액
    	long t_amt8[] = new long[1];
    	long t_amt9[] = new long[1];
    	long t_amt10[] = new long[1];
    	long t_amt11[] = new long[1];
%> 

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.action = 'card_jung_user.jsp';
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}

	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "insa_main.jsp";		
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='card_jung_user.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
	  
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">복리후생비정산</span></div>
            <div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>				
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
	
		 <%for(int i = 0 ; i < cont_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
				long t1=0;
				long t2=0;
				long t3=0;
				long t4=0;
				long t5=0;
				long t6=0;
				long t7=0;
				long t8=0;
				long t9=0;
				long s1=0; //매각액
				float f_sup_amt = 0;
				long sup_amt = 0;
												
				if (String.valueOf(ht.get("GET_DATE")).substring(0,4).equals(String.valueOf(ht.get("GISU")))) {
					t1 = 0;
				  	t2 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
              			} else {
                  			t1 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")));
                  			t2 = AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
              			} 
												
				t4=AddUtil.parseLong(String.valueOf(ht.get("BOOK_CR")));
				t6=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")));
				t8=AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
								
				if ( ht.get("DEPRF_YN").equals("5")) {
					t5=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")))+ AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
					t7 = 0;
					t9 = 0;
				} else {
					t7 = t1 + t2 - t6 - t8;
					t9 = t6 + t8;
				}
				
				s1=AddUtil.parseLong(String.valueOf(ht.get("SALE_AMT")));
								
				if (String.valueOf(ht.get("ASSCH_RMK")).equals("폐차") || String.valueOf(ht.get("ASSCH_RMK")).equals("폐기") ) {
					sup_amt = s1;
				} else {
					sup_amt=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
				}
					      		
				for(int j=0; j<1; j++){
				
						t_amt1[j] += t1;
						t_amt2[j] += t2;
						t_amt3[j] += t3;
						t_amt4[j] += t4;
						t_amt5[j] += t5;
						t_amt6[j] += t6;
						t_amt7[j] += t7;
						t_amt8[j] += t8;
						t_amt9[j] += t9;
						t_amt10[j] += s1;
						t_amt11[j] += sup_amt;
														
				}%>
			<ul class="lst_type">
				<li>					
					<span><h3>(<%=i+1%>) <font color=#990000><%=ht.get("ASSET_NAME")%></font></h3></span>					
					<br> 					
					| 취득일자 <%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%> | 
					<br>
					| 매각일자 <%=AddUtil.ChangeDate2(String.valueOf(ht.get("ASSCH_DATE")))%> |
					<br> 	
					| 경매장 <%=ht.get("FIRM_NM")%> | 
					<br> 
					| 매각액 <%=Util.parseDecimal(sup_amt)%>원 | 손익 <%=Util.parseDecimal(sup_amt - (t1 + t2 - t6 - t8) )%>원 | 
					
				</li>
			</ul>
		 <%}%>
		 <%if(cont_size==0){%>
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