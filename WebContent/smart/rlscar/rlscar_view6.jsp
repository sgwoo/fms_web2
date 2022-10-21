<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
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
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}

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
.contents_box {width:100%; table-layout:fixed; font-size:13px; }
.contents_box th {color:#282828; width:30%; height:26px; text-align:center; font-size:15px; margin-bottom:10px; font-weight:bold;}
.contents_box td {line-height:22px; color:#7f7f7f; margin-bottom:10px; font-weight:bold;}
.contents_box em{color:#b20075; font-weight:bold;}




/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}




</style>
</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*, acar.off_ls_hpg.*"%>
<jsp:useBean id="oh_db" scope="page" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//차량정보
	Hashtable secondhand = oh_db.getSecondhandCase_20090901(rent_mng_id, rent_l_cd, car_mng_id);
	
	int mon[] = new int[18];
	mon[0]  = 48;
	mon[1]  = 42;
	mon[2]  = 36;
	mon[3]  = 30;
	mon[4]  = 24;
	mon[5]  = 18;
	mon[6]  = 12;
	mon[7]  = 11;
	mon[8]  = 10;
	mon[9]  = 9;
	mon[10] = 8;
	mon[11] = 7;
	mon[12] = 6;
	mon[13] = 5;
	mon[14] = 4;
	mon[15] = 3;
	mon[16] = 2;
	mon[17] = 1;
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
%>

<script language='javascript'>
<!--
	//견적서인쇄
	function EstiPrint(a_a,rent_way,a_b,amt){ 		
		var fm = document.form1;  		
		var SUBWIN="/acar/secondhand_hp/estimate.jsp?mobile_yn=Y&acar_id=<%=user_id%>&from_page=secondhand_hp&car_mng_id=<%= car_mng_id %>&today_dist=<%=secondhand.get("REAL_KM")%>&o_1=<%=secondhand.get("APPLY_SH_PR")%>&rent_dt=<%=secondhand.get("UPLOAD_DT")%>&est_code=<%=secondhand.get("REG_CODE")%>&a_a="+a_a+""+rent_way+"&a_b="+a_b+"&amt="+amt;  	
		window.open(SUBWIN, "SubList_"+amt, "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}
	
	function EstiPrintRm(a_a,rent_way,a_b,amt){ 		
		var fm = document.form1;  		
		var SUBWIN="/acar/secondhand_hp/estimate_rm.jsp?mobile_yn=Y&acar_id=<%=user_id%>&from_page=secondhand_hp&car_mng_id=<%= car_mng_id %>&today_dist=<%=secondhand.get("REAL_KM")%>&o_1=<%=secondhand.get("APPLY_SH_PR")%>&rent_dt=<%=secondhand.get("UPLOAD_DT")%>&est_code=<%=secondhand.get("REG_CODE")%>&a_a="+a_a+""+rent_way+"&a_b="+a_b+"&amt="+amt;  	
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}
	
	
	//견적내기
	function EstiMate (st, nm, a_a, rent_way, a_b, amt, target){
		var fm = document.form1;		
		fm.st.value 		= st;	 //1:출고전대차	3:기본견적 4:조정견적		
		fm.esti_nm.value 	= nm;
		fm.a_a.value 		= a_a+""+rent_way;
		fm.a_b.value 		= a_b;		
		fm.amt.value 		= amt;				
		fm.pp_st.value 		= '0';
		fm.rg_8.value 		= '25'; //20->30(20081216)->25(20090117)
		
		fm.target = target;
		fm.action = '/smart/esti/sh_car_esti_i.jsp';
		fm.submit();		
	}

	//기존고객찾기
	function search_cust(){
		var fm = document.form1;
		var SUBWIN="/smart/esti/search_cust_list.jsp?t_wd="+fm.est_nm.value;		
		window.open(SUBWIN, "SubCust", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");		
	}
	
	//불량고객 
	function view_badcust()
	{
		var fm = document.form1;
	    if (fm.est_nm.value == '') {
	    	alert('고객/상호명를 입력하십시오');
	    	fm.est_nm.focus();
	    	return;
	    }	
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.est_nm.value+'&est_tel='+fm.est_tel.value+'&est_mail='+fm.est_email.value+'&est_fax='+fm.est_fax.value, "BADCUST", "left=10, top=10, width=1400, height=900, resizable=yes, scrollbars=yes, status=yes");
		return;
	}	    	

//-->
</script>

<body>

<form name='form1' method='post' action=''>
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='from_page'	value='<%=from_page%>'>
	<!--변동변수-->	
	<input type="hidden" name="st"	 			value="">
	<input type="hidden" name="esti_nm"			value="">
	<input type="hidden" name="a_a"				value="">
	<input type="hidden" name="a_b"				value="">
	<input type="hidden" name="pp_st"			value="">
	<input type="hidden" name="rg_8"			value="">
	<input type="hidden" name="amt"				value="">			
	<input type="hidden" name="o_1"				value="<%=secondhand.get("APPLY_SH_PR")%>">	
	<input type="hidden" name="rent_dt"			value="<%=secondhand.get("UPLOAD_DT")%>">
	<input type="hidden" name="today_dist"		value="<%=secondhand.get("REAL_KM")%>">	
	<input type="hidden" name="est_code"		value="<%=secondhand.get("REG_CODE")%>">			
	<input type="hidden" name="page_kind"		value="homepage">
			
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">
        	
			<div id="gnb_login"><%=car_no%> 견적요금</div>
            <div id="gnb_home"><a href="rlscar_list.jsp" onMouseOver="window.status=''; return true" title='리스트 가기'><img src=/smart/images/button_list.gif align=absmiddle /></a>
			<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
		<%if(from_page.equals("esti_main.jsp")){//재리스견적내기%>
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">고객정보&nbsp;
		<a href="javascript:search_cust()" onMouseOver="window.status=''; return true" title="고객조회하기. 클릭하세요"><img src="/smart/images/btn_serch.gif"  border="0" align=absmiddle></a>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <font color=red>※ 불량고객 확인하기</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='고객확인' onclick="javascript:view_badcust();">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">   
		
		</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>상호/성명</th>
							<td valign=top><input type="text" name="est_nm" value="" size="25" class=text style='IME-MODE: active'></td>
						</tr>
						<tr>
							<th valign=top>사업자/생년월일</th>
							<td valign=top><input type="text" name="est_ssn" value="" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>전화번호</th>
							<td valign=top><input type="text" name="est_tel" value="" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>FAX</th>
							<td valign=top><input type="text" name="est_fax" value="" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>이메일주소</th>
							<td valign=top><input type="text" name="est_email" value="" size="25" class=text style='IME-MODE: inactive'></td>
						</tr>
				    	<tr>
				    		<th>고객구분</th>
				    		<td><select name="doc_type">
                        <option value="1" selected>법인고객</option>
                        <option value="2" >개인사업자</option>
						<option value="3" >개인</option>
                      </select>
        	 		  		</td>
				    	</tr>							
						<tr>
							<th>담당자</th>
							<td><select name='damdang_id'>            
                        		<option value="">미지정</option>
        		        		<%	if(user_size > 0){
        								for(int i = 0 ; i < user_size ; i++){
        									Hashtable user = (Hashtable)users.elementAt(i); 
        							%>
          			    		<option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                				<%		}
        							}%>
        			  </select></td>
						</tr>
					</table>
				</div>
				<div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>			
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">출고전대차</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><% if ( secondhand.get("CAR_USE").equals("1") ) {%>렌트기본식<%}else{%>리스기본식<%}%> 1개월 <a href="javascript:EstiMate('1', '', '<% if ( secondhand.get("CAR_USE").equals("1") ){%>2<%}else{%>1<%}%>', '2', '1', '0', '_blank');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a></td>
						</tr>
					</table>
				</div>
				<div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>					
		<%}%>
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">리스플러스</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th rowspan="8">기본식</th>
							<td width="20%">48개월</td>
							<td align=right>
								<font color='#b20075'>
								<% if(AddUtil.parseInt((String)secondhand.get("LB48"))>0){ %>
									<a href="javascript:EstiPrint('1','2','48','<%=secondhand.get("LB48")%>');"><%= AddUtil.parseDecimal(AddUtil.parseInt((String)secondhand.get("LB48"))) %>원</a>
									<%if(from_page.equals("esti_main.jsp")){//재리스견적내기%>
									<a href="javascript:EstiMate('2', 'lb48','1','2','48','<%=secondhand.get("LB48")%>', '_blank');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                      				<a href="javascript:EstiMate('3', 'lb48','1','2','48','<%=secondhand.get("LB48")%>', '_blank');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
									<%}%>									
								<% }else{%>견적불가<%}%>
								</font>
							</td>
							<td width="1%">&nbsp;</td>
						</tr>
						<%for(int i = 1 ; i < 7 ; i++){%>
						<tr>
							<td><%=mon[i]%>개월</td>
							<td align=right>
								<font color='#b20075'>
								<% if(AddUtil.parseInt((String)secondhand.get("LB"+mon[i]))>0){ %>
									<a href="javascript:EstiPrint('1','2','<%=mon[i]%>','<%=secondhand.get("LB"+mon[i])%>');"><%= AddUtil.parseDecimal(AddUtil.parseInt((String)secondhand.get("LB"+mon[i]))) %>원</a>
									<%if(from_page.equals("esti_main.jsp")){//재리스견적내기%>
                      				<a href="javascript:EstiMate('2', 'lb<%=mon[i]%>','1','2','<%=mon[i]%>','<%=secondhand.get("LB"+mon[i])%>', '_blank');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
									<a href="javascript:EstiMate('3', 'lb<%=mon[i]%>','1','2','<%=mon[i]%>','<%=secondhand.get("LB"+mon[i])%>', '_blank');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
									<%}%>									
								<% }else{%>견적불가<%}%>
								</font>
							</td>
							<td>&nbsp;</td>
						</tr>
						<%}%>
						<tr>
							<td colspan=4 height=5></td>
						</tr>
						<tr>
							<td colspan=4 bgcolor=#e3e0d3 height=1></td>
						</tr>
						<tr>
							<td colspan=4 height=8></td>
						</tr>
				  		<tr>
							<th rowspan="8">일반식</th>
							<td>48개월</td>
							<td align=right>
								<font color='#b20075'>
								<% if(AddUtil.parseInt((String)secondhand.get("LS48"))>0){ %>
									<a href="javascript:EstiPrint('1','1','48','<%=secondhand.get("LS48")%>');"><%= AddUtil.parseDecimal(AddUtil.parseInt((String)secondhand.get("LS48"))) %>원</a>
									<%if(from_page.equals("esti_main.jsp")){//재리스견적내기%>
                      				<a href="javascript:EstiMate('2', 'ls48','1','1','48','<%=secondhand.get("LS48")%>', '_blank');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
									<a href="javascript:EstiMate('3', 'ls48','1','1','48','<%=secondhand.get("LS48")%>', '_blank');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
									<%}%>
								<% }else{%>견적불가<%}%>
								</font>
							</td>
							<td>&nbsp;</td>
						</tr>
						<%for(int i = 1 ; i < 7 ; i++){%>
						<tr>
							<td><%=mon[i]%>개월</td>
							<td align=right>
								<font color='#b20075'>
								<% if(AddUtil.parseInt((String)secondhand.get("LS"+mon[i]))>0){ %>
									<a href="javascript:EstiPrint('1','1','<%=mon[i]%>','<%=secondhand.get("LS"+mon[i])%>');"><%= AddUtil.parseDecimal(AddUtil.parseInt((String)secondhand.get("LS"+mon[i]))) %>원</a>
									<%if(from_page.equals("esti_main.jsp")){//재리스견적내기%>
                      				<a href="javascript:EstiMate('2', 'ls<%=mon[i]%>','1','1','<%=mon[i]%>','<%=secondhand.get("LS"+mon[i])%>', '_blank');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
									<a href="javascript:EstiMate('3', 'ls<%=mon[i]%>','1','1','<%=mon[i]%>','<%=secondhand.get("LS"+mon[i])%>', '_blank');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
									<%}%>									
								<% }else{%>견적불가<%}%>
								</font>
							</td>
							<td>&nbsp;</td>
						</tr>
						<%}%>										
					</table>
				</div>
				<div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">장기렌트</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th rowspan="14">기본식</th>
							<td width="20%">48개월</td>
							<td align=right>
								<font color='#b20075'>
								<% if(AddUtil.parseInt((String)secondhand.get("RB48"))>0){ %>
									<a href="javascript:EstiPrint('2','2','48','<%=secondhand.get("RB48")%>');"><%= AddUtil.parseDecimal(AddUtil.parseInt((String)secondhand.get("RB48"))) %>원</a>
									<%if(from_page.equals("esti_main.jsp")){//재리스견적내기%>
                      				<a href="javascript:EstiMate('2', 'rb48','2','2','48','<%=secondhand.get("RB48")%>', '_blank');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
									<a href="javascript:EstiMate('3', 'rb48','2','2','48','<%=secondhand.get("RB48")%>', '_blank');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
									<%}%>
								<% }else{%>견적불가<%}%>
								</font>
							</td>
							<td width="1%">&nbsp;</td>
						</tr>
						<%for(int i = 1 ; i < 13 ; i++){%>						
						<tr>
							<td><%=mon[i]%>개월</td>
							<td  align=right>
								<font color='#b20075'>
								<% if(AddUtil.parseInt((String)secondhand.get("RB"+mon[i]))>0){ %>
									<a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=secondhand.get("RB"+mon[i])%>');"><%= AddUtil.parseDecimal(AddUtil.parseInt((String)secondhand.get("RB"+mon[i]))) %>원</a>
									<%if(from_page.equals("esti_main.jsp")){//재리스견적내기%>
                      				<a href="javascript:EstiMate('2', 'rb<%=mon[i]%>','2','2','<%=mon[i]%>','<%=secondhand.get("RB"+mon[i])%>', '_blank');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
									<a href="javascript:EstiMate('3', 'rb<%=mon[i]%>','2','2','<%=mon[i]%>','<%=secondhand.get("RB"+mon[i])%>', '_blank');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
									<%}%>									
								<% }else{%>견적불가<%}%>
								</font>
							</td>
							<td>&nbsp;</td>
						</tr>
						<%}%>		
						<tr>
							<td colspan=4 height=5></td>
						</tr>
						<tr>
							<td colspan=4 bgcolor=#e3e0d3 height=1></td>
						</tr>
						<tr>
							<td colspan=4 height=8></td>
						</tr>
				    	<tr>
							<th rowspan="19">일반식</th>
							<td>48개월</td>
							<td  align=right>
								<font color='#b20075'>
								<% if(AddUtil.parseInt((String)secondhand.get("RS48"))>0){ %>
									<a href="javascript:EstiPrint('2','1','48','<%=secondhand.get("RS48")%>');"><%= AddUtil.parseDecimal(AddUtil.parseInt((String)secondhand.get("RS48"))) %>원</a>
									<%if(from_page.equals("esti_main.jsp")){//재리스견적내기%>
                      				<a href="javascript:EstiMate('2', 'rs48','2','1','48','<%=secondhand.get("RS48")%>', '_blank');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
									<a href="javascript:EstiMate('3', 'rs48','2','1','48','<%=secondhand.get("RS48")%>', '_blank');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
									<%}%>
								<% }else{%>견적불가<%}%>
								</font>
							</td>
							<td>&nbsp;</td>
						</tr>
						<%for(int i = 1 ; i < 18 ; i++){%>						
						<tr>
							<td><%=mon[i]%>개월</td>
							<td  align=right>
								<font color='#b20075'>
								<% if(AddUtil.parseInt((String)secondhand.get("RS"+mon[i]))>0){ %>
									<a href="javascript:EstiPrint('2','1','<%=mon[i]%>','<%=secondhand.get("RS"+mon[i])%>');"><%= AddUtil.parseDecimal(AddUtil.parseInt((String)secondhand.get("RS"+mon[i]))) %>원</a>
									<%if(from_page.equals("esti_main.jsp")){//재리스견적내기%>
                      				<a href="javascript:EstiMate('2', 'rs<%=mon[i]%>','2','1','<%=mon[i]%>','<%=secondhand.get("RS"+mon[i])%>', '_blank');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
									<a href="javascript:EstiMate('3', 'rs<%=mon[i]%>','2','1','<%=mon[i]%>','<%=secondhand.get("RS"+mon[i])%>', '_blank');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
									<%}%>									
								<% }else{%>견적불가<%}%>
								</font>
							</td>
							<td>&nbsp;</td>
						</tr>
						<%}%>																	
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			   
			</div>
			<!--
			<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=/smart/rlscar/rlscar_view6_mail.jsp>메일보내기</a></div>
			-->
		</div>
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">월렌트</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
					<td>1개월</td>
							<td  align=right>
								<font color='#b20075'>
								<% if(AddUtil.parseInt((String)secondhand.get("RM1"))>0){ %>
									<a href="javascript:EstiPrintRm('2','1','1','<%=secondhand.get("RM1")%>');"><%= AddUtil.parseDecimal(AddUtil.parseInt((String)secondhand.get("RM1"))) %>원</a>																
								<% }else{%>견적불가<%}%>
								</font>
							</td>
							<td>&nbsp;</td>
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
