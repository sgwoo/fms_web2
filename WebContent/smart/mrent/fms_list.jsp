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
.lst_type{width:auto;padding:20px;border-bottom:1px solid #c2c2c2;list-style:none; background-color:#ffffff; font-family:'나눔고딕';font-size:15px;}
.lst_type li{font-family:'나눔고딕';font-size:15px;font-weight:normal;line-height:20px;vertical-align:top}
.lst_type li a{text-decoration:none;font-family:'나눔고딕';font-size:19px;font-weight:normal;line-height:28px;display:inline;} /*링크*/
.lst_type li em{color:#f84e12 font-family:'나눔고딕';}
.lst_type li a:hover{text-decoration:underline font-family:'나눔고딕';}
/* //UI Object */

</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.client.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	Vector vt = new Vector();
	
	if(!t_wd.equals("")){
		if(from_page.equals("esti_main.jsp")){
			vt = a_db.getFmsSearchCarList(s_kd, t_wd, "Y");
		}else{
			//상호,대표자
			if(s_kd.equals("1") || s_kd.equals("3")){			vt = al_db.getFmsSearchClientList(s_kd, t_wd);
			//차량번호,계약일자
			}else if(s_kd.equals("2") || s_kd.equals("5")){			vt = a_db.getFmsSearchCarList(s_kd, t_wd, "");
			//전화번호
			}else if(s_kd.equals("4")){					vt = al_db.getFmsSearchTelList(s_kd, t_wd);
			//
			}
		}
	}
	
	int vt_size = vt.size();
%> 

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		if(fm.s_kd.value == '4' && fm.t_wd.value.length < 4){ alert('전화번호 조회는 최소 4자리로 검색합니다.'); fm.t_wd.focus(); return; }
		fm.action = 'fms_list.jsp';
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
 	//계약서 내용 보기
	function view_fms(st, client_id, firm_nm, rent_mng_id, rent_l_cd, car_mng_id, cont_cnt, car_no, car_nm){
		var fm = document.form1;
		fm.client_id.value 		= client_id;
		fm.firm_nm.value 		= firm_nm;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.car_mng_id.value 	= car_mng_id;
		fm.cont_cnt.value 		= cont_cnt;
		fm.car_no.value 		= car_no;
		fm.car_nm.value 		= car_nm;	

		<%if(from_page.equals("esti_main.jsp")){%>
		if(fm.car_mng_id.value == ''){ alert('차량 미등록인 게약은 연장견적을 할 수 없습니다.'); return;}
		fm.action = '/smart/esti/ext_car_esti_i.jsp';
		<%}else{%>
		if(st == '1'){			//고객검색시
			fm.action = 'fms_menu.jsp';
		}else if(st == '2'){	//차량검색시
	 		fm.action = 'cont_menu.jsp';
		}		
		fm.s_kd.value = '';
		fm.t_wd.value = '';		
		<%}%>
				
		fm.submit();
	}
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "/smart/esti/esti_main.jsp";		
		fm.submit();
	}			
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='fms_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>   
	<input type='hidden' name="from_page" 	value="<%=from_page%>">   	 
	<input type='hidden' name='rent_mng_id' value=''>
	<input type='hidden' name='rent_l_cd' 	value=''>
	<input type='hidden' name='client_id' 	value=''>
	<input type='hidden' name='firm_nm' 	value=''>
	<input type='hidden' name='car_mng_id' 	value=''>
	<input type='hidden' name='cont_cnt' 	value=''>
	<input type='hidden' name='car_no' 		value=''>
	<input type='hidden' name='car_nm' 		value=''>
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">FMS 검색</div>
            <div id="gnb_home">
				<%if(from_page.equals("esti_main.jsp")){%>
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<%}%>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
    	<div id="search">
		<fieldset class="srch">
			<legend>검색영역</legend>
			<select name="s_kd"> 
				<%if(from_page.equals("esti_main.jsp")){%>
				<option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option> 				
				<option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
				<%}else{%>
				<option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option> 
				<option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
				<option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>대표자</option>
				<option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>전화번호</option>
				<option value="5" <%if(s_kd.equals("5")){%> selected <%}%>>계약일자</option>
				<%}%>
			</select> 
			<input accesskey="s" class="keyword" title=검색어 type="text" name="t_wd" value="<%=t_wd%>"> 
			<a onClick='javascript:window.search();' style='cursor:hand'><img src="/smart/images/btn_srch.gif" alt="검색" value="검색"></a>
		</fieldset> 
		</div>
		<br>
		 <%for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			//보험정보
			String ins_st = ai_db.getInsSt((String)ht.get("CAR_MNG_ID"));
			ins = ai_db.getIns((String)ht.get("CAR_MNG_ID"), ins_st);
			%>
			<ul class="lst_type">
				<li>
				<%if(s_kd.equals("2") || s_kd.equals("5") || from_page.equals("esti_main.jsp")){//차량번호 조회시------------------------------------------------------------------------%>
					<h3>[<%=i+1%>]		
						<a href="javascript:view_fms('2', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '1', '<%=ht.get("CAR_NO")%>', '<%=ht.get("CAR_NM")%>')" onMouseOver="window.status=''; return true" title='계약상세내역'>
							<font color='#990000'><b><%=ht.get("CAR_NO")%></b></font>
						</a> 
					</h3>
						<%=ht.get("CAR_NM")%><font color="#aeaeae"> &nbsp;|&nbsp; </font> <font color="#5F00FF"><%=ins.getIns_com_nm()%></font>
					<br>
						<%=ht.get("FIRM_NM")%> 
					<font color="#aeaeae"> &nbsp;|&nbsp; </font><a href="tel:<%=ht.get("USER_M_TEL")%>"><%=ht.get("USER_NM")%></a> 
					<%if(!String.valueOf(ht.get("FIRM_NM")).equals("(주)아마존카")){//장기대여차%>
					<br> 
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%> 
					  <font color="#aeaeae"> &nbsp;|&nbsp; </font>
					  <%=ht.get("RENT_WAY")%>
					  <font color="#aeaeae"> &nbsp;|&nbsp; </font>
					  <%if(ht.get("USE_YN").equals("Y")){%>
                      <font color=#fd5f00><b>대여</b></font>
                      <%}else if(ht.get("USE_YN").equals("N")){%>
        			  <font color='#bd8a48'><b>해지</b></font>
                      <%}else{%>
                      <font color=#fd5f00><b>미결</b></font>					  
                      <%}%>
					  <%if(s_kd.equals("5")){%>
					  &nbsp;<%=ht.get("RENT_ST")%>
					  <%}%>
					<%}else{//보유차%>  
					<br> 
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
					<font color="#aeaeae"> &nbsp;|&nbsp; </font><%if(ht.get("USE_YN").equals("Y")){%>
                      <font color=#fd5f00><b>사용</b></font>
                      <%}else if(ht.get("USE_YN").equals("N")){%>
        			  <font color='#bd8a48'><b>해지</b></font>
                      <%}else{%>
                      <font color=#fd5f00><b>미결</b></font>
                      <%}%>					
					<%}%>
				<%}else{//상호조회시------------------------------------------------------------------------%>
					<h3>
						[<%=ht.get("CLIENT_ST_NM")%>] 
						<a href="javascript:view_fms('1', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%//=ht.get("RENT_MNG_ID")%>', '<%//=ht.get("RENT_L_CD")%>', '<%//=ht.get("CAR_MNG_ID")%>', '<%=ht.get("CONT_CNT")%>', '', '')" onMouseOver="window.status=''; return true">
							<font color='#990000'><b><%=ht.get("FIRM_NM")%></b></font>
						</a>
					</h3>
					<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("2")){%>
					 <%=ht.get("CLIENT_NM")%>
					<%}%>
					&nbsp;<font color="#aeaeae">|</font>&nbsp; <a href="tel:<%=ht.get("O_TEL")%>"><font color='#3b44bb'><%=ht.get("O_TEL")%></font></a> <%if(String.valueOf(ht.get("O_TEL")).equals("")){%><a href="tel:<%=ht.get("M_TEL")%>"><%=ht.get("M_TEL")%></a><%}%>
					<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("2")){%>
					<br> 
					 <%=AddUtil.ChangeEnp(String.valueOf(ht.get("ENP_NO")))%> 
					<%}%>
					&nbsp;<font color="#aeaeae">|</font> &nbsp;<%=AddUtil.ChangeEnp(String.valueOf(ht.get("SSN")))%> 
					<br> 
					 <span title='<%=ht.get("O_ADDR")%>'><%=Util.subData(String.valueOf(ht.get("O_ADDR")), 23)%></span>	
					<%if(!String.valueOf(ht.get("USE_CNT")).equals("0")){%>
                    <br>
					 <font color=#fd5f00><b><%=ht.get("USE_CNT")%>대</b></font> 대여중
					 <%		if(String.valueOf(ht.get("USE_CNT")).equals("1")){%>
					  &nbsp;(<%=ht.get("Y_CAR_NO")%> <%=ht.get("Y_RENT_WAY")%>)
                     <%		}else{%>	
					  &nbsp;(일반식 <%=ht.get("RENT_WAY_1_CNT")%>대, 기본식 <%=ht.get("RENT_WAY_2_CNT")%>대)
					 <%		}%>
                    <%}%>	
					
					
					<%if(s_kd.equals("4")){%>						
					<!--
					<br>
					<%//=ht.get("CLIENT_H_TEL")%>
					<br>
					<%//=ht.get("MGR_H_TEL")%>
					-->
					<%}%>					
				<%}%>
				</li>
			</ul>
          <%}%>
	</div>     
</div>
</form>
</body>
</html>
