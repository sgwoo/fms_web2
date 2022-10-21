<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String opt1 		= request.getParameter("opt1")		==null?"":request.getParameter("opt1");
	String opt2 		= request.getParameter("opt2")		==null?"":request.getParameter("opt2");
	String opt3 		= request.getParameter("opt3")		==null?"":request.getParameter("opt3");
	String opt4 		= request.getParameter("opt4")		==null?"":request.getParameter("opt4");
	String opt5 		= request.getParameter("opt5")		==null?"":request.getParameter("opt5");
	String opt6 		= request.getParameter("opt6")		==null?"":request.getParameter("opt6");
	String opt7 		= request.getParameter("opt7")		==null?"":request.getParameter("opt7");
	String e_opt1 		= request.getParameter("e_opt1")	==null?"":request.getParameter("e_opt1");
	String e_opt2 		= request.getParameter("e_opt2")	==null?"":request.getParameter("e_opt2");
	String e_opt3 		= request.getParameter("e_opt3")	==null?"":request.getParameter("e_opt3");
	String e_opt4 		= request.getParameter("e_opt4")	==null?"":request.getParameter("e_opt4");
	String e_opt5 		= request.getParameter("e_opt5")	==null?"":request.getParameter("e_opt5");
	String e_opt6 		= request.getParameter("e_opt6")	==null?"":request.getParameter("e_opt6");
	String e_opt7 		= request.getParameter("e_opt7")	==null?"":request.getParameter("e_opt7");
	String ready_car	= request.getParameter("ready_car")	==null?"":request.getParameter("ready_car");
	String eco_yn		= request.getParameter("eco_yn")	==null?"":request.getParameter("eco_yn");
	String car_nm2 		= request.getParameter("car_nm2")		==null?"":request.getParameter("car_nm2");
	String car_nm3 		= request.getParameter("car_nm3")		==null?"":request.getParameter("car_nm3");
		
	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = umd.getXmlMaMenuAuth(user_id, "07", "04", "13");
	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		fm.t_wd.value 		= replaceString("&","AND",fm.t_wd.value);
		fm.ready_car.value	= '';
		fm.first.value = 'N';
	//	fm.action = 'pur_pre_sc.jsp';
		fm.action = 'pur_pre_grid_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	
//	function enter(){
//		var keyValue = event.keyCode;
//		if (keyValue =='13') search();
//	}
	
	//출고예정차량 보기(20190306)
	function search_ready_car(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.ready_car.value	= 'Y';
		fm.action = 'pur_pre_grid_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	
	//친환경차 여부에따른 리스트 조회_20191119
	function search_eco_car(eco_yn) {
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.eco_yn.value = eco_yn;
		fm.ready_car.value	= '';
		
		fm.action = 'pur_pre_grid_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='from_page' 	value='<%=from_page%>'>  
	<input type='hidden' name='sh_height' 	value='<%=sh_height%>'> 
	<input type='hidden' name='first' 	> 
	
	<div class="navigation" style="margin-bottom:0px !important">
		<span class="style1">협력업체관리 > 자체출고관리 > </span><span class="style5">사전계약관리</span>
	</div>
	<div class="search-area" style="margin:0px 10px;">
		<table width="100%">
			<colgroup>
				<col width="7%">
				<col width="12%">
				<col width="4%">
				<col width="20%">
				<col width="6%">
				<col width="15%">
				<col width="6%">
				<col width="11%">
				<col width="6%">
				<col width="11%">
				<col width="2%">
			</colgroup>
			<tr>
				<td>
					<label><i class="fa fa-check-circle"></i> 출고영업소 </label>
				</td>
				<td>
					<select name='gubun3' class="select">
				    	<option value='' <%if(gubun3.equals("")){%>selected<%}%>> 전체 </option>
				      	<option value='B2B사업운영팀'   <%if(gubun3.equals("B2B사업운영팀")){%>selected<%}%>>현대 B2B사업운영팀</option>
				      	<%if(!acar_de.equals("1000")){ %>
				      	<option value='총신대'   <%if(gubun3.equals("총신대")){%>selected<%}%>>현대 총신대대리점</option>
				      	<option value='사직'   <%if(gubun3.equals("사직")){%>selected<%}%>>현대 사직대리점</option>
				      	<option value='한강'   <%if(gubun3.equals("한강")){%>selected<%}%>>현대 한강대리점</option>
				      	<%} %>
				      	<option value='숭실대대리점'  <%if(gubun3.equals("숭실대대리점")){%>selected<%}%>>기아 숭실대판매점</option>
				      	<option value='세종로대리점'  <%if(gubun3.equals("세종로대리점")){%>selected<%}%>>기아 세종로판매점</option>
					    <option value='학익대리점'   <%if(gubun3.equals("학익대리점")){%>selected<%}%>>기아 학익대리점</option>
					    <option value='을지로대리점'  <%if(gubun3.equals("을지로대리점")){%>selected<%}%>>기아 을지로대리점</option>
					    <option value='증산대리점'   <%if(gubun3.equals("증산대리점")){%>selected<%}%>>기아 증산대리점</option>
					    <option value='강서구청영업소' <%if(gubun3.equals("강서구청영업소")){%>selected<%}%>>지엠 강서구청점</option>
					    <option value='영등포중앙대리점'  <%if(gubun3.equals("영등포중앙대리점")){%>selected<%}%>>쌍용 영등포중앙대리점</option>
					    <option value='르노삼성블루모터스'  <%if(gubun3.equals("르노삼성블루모터스")){%>selected<%}%>>르노삼성 블루모터스</option>
					    <option value='테슬라' 	<%if(gubun3.equals("테슬라")){%>selected<%}%>>테슬라</option>
					</select>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> 차명 </label>
				</td>
				<td>
			 		<input type='text' name='gubun4' size='10' class='text input' value='<%=gubun4%>' style='IME-MODE: active'>
			 		<input type='text' name='car_nm2' size='10' class='text input' value='<%=car_nm2%>' style='IME-MODE: active'>
			 		<input type='text' name='car_nm3' size='10' class='text input' value='<%=car_nm3%>' style='IME-MODE: active'>
				</td>
				<td>
			    	<label><i class="fa fa-check-circle"></i> 검색조건 </label>
				</td>
				<td>
			 		<select name='s_kd' class="select" id="s_kd">
				      	<option value='4' <%if(s_kd.equals("4")){%>selected<%}%>> 예약자 </option>
				        <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>> 계출번호 </option>
				      	<%-- <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>> 사양 </option> --%>
				      	<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>> 색상 </option>
				      	<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>> 고객명 </option>
			        </select>&nbsp;
					<input type='text' name='t_wd' size='12' class='text input' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> 진행구분 </label>
				</td>
				<td>
			 		<select name='gubun5' class="select">
				        <option value='' <%if(gubun5.equals("")){%>selected<%}%>> 전체 </option>
				      	<option value='Y' <%if(gubun5.equals("Y")){%>selected<%}%>> 진행 </option>
				      	<option value='Y1' <%if(gubun5.equals("Y1")){%>selected<%}%>> 진행-계약 </option>
				      	<option value='Y3' <%if(gubun5.equals("Y3")){%>selected<%}%>> 진행-예약 </option>
				      	<option value='Y2' <%if(gubun5.equals("Y2")){%>selected<%}%>> 진행-대기 </option>
				      	<option value='Y4' <%if(gubun5.equals("Y4")){%>selected<%}%>> 진행-즉시출고 </option>
				      	<option value='N' <%if(gubun5.equals("N")){%>selected<%}%>> 취소 </option>
				      	<option value='P' <%if(gubun5.equals("P")){%>selected<%}%>> 출고 </option>
			        </select>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> 정렬조건 </label>
				</td>
				<td>
				    <select name='sort' class="select">
				    	<option value='2' <%if(sort.equals("2")){%>selected<%}%>> 출고예정일 </option>
				    	<option value='4' <%if(sort.equals("4")){ %>selected<%}%>> 요청일시 </option>
				        <option value='1' <%if(sort.equals("1")){ %>selected<%}%>> 계약등록일 </option>
				    	<option value='3' <%if(sort.equals("3")){%>selected<%}%>> 계출번호 </option>
				    	<option value='5' <%if(sort.equals("5")){%>selected<%}%>> 예약일 </option>
				    	<option value='6' <%if(sort.equals("6")){%>selected<%}%>> 즉시출고 </option>
			        </select>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
			    	<label><i class="fa fa-check-circle"></i> 선택품목 </label>
				</td>
				<td colspan="5">(+)&nbsp;
					<input type='text' name='opt1' size='15' class='text input' value='<%=opt1%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='opt2' size='15' class='text input' value='<%=opt2%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='opt3' size='15' class='text input' value='<%=opt3%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='opt4' size='15' class='text input' value='<%=opt4%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='opt5' size='15' class='text input' value='<%=opt5%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='opt6' size='15' class='text input' value='<%=opt6%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='opt7' size='15' class='text input' value='<%=opt7%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> 기간 </label>
				</td>
				<td colspan="3">
			 		<select name='gubun1' class="select">
			 			<option value='5' <%if(gubun1.equals("5")){%>selected<%}%>> 예약일 </option>
				        <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>> 계약등록일 </option>
				      	<option value='2' <%if(gubun1.equals("2")){%>selected<%}%>> 출고예정일 </option>
				      	<option value='3' <%if(gubun1.equals("3")){%>selected<%}%>> 계약취소일 </option>
			 			<option value='4' <%if(gubun1.equals("4")){%>selected<%}%>> 요청일 </option>
			  		</select>&nbsp;
			  		<select name='gubun2' class="select">                          
				    	<option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>당일</option>
				    	<option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>전일</option>
				    	<option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>당월</option>
				    	<option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>기간 </option>
			        </select>&nbsp;
					<input type='text' size='11' name='st_dt' class='text input' value='<%=st_dt%>'>
			          ~ 
			  		<input type='text' size='11' name='end_dt' class='text input' value="<%=end_dt%>">
				</td>
				<td>
					<input type="button" class="button" value="검색" onclick="search();">
				</td>
			</tr>
			<tr>
				<td></td>
				<td colspan="9">(-)&nbsp;
					<input type='text' name='e_opt1' size='15' class='text input' value='<%=e_opt1%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='e_opt2' size='15' class='text input' value='<%=e_opt2%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='e_opt3' size='15' class='text input' value='<%=e_opt3%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='e_opt4' size='15' class='text input' value='<%=e_opt4%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='e_opt5' size='15' class='text input' value='<%=e_opt5%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<!-- 
					<input type='text' name='e_opt6' size='15' class='text input' value='<%=e_opt6%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<input type='text' name='e_opt7' size='15' class='text input' value='<%=e_opt7%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					 -->
				</td>				
			</tr>
			<tr>
				<td>
					<label><i class="fa fa-check-circle"></i> 엔진종류 </label>
				</td>
				<td colspan="5">
					<!-- <input type="button" class="button" value="친환경차" onclick="javascript:search_eco_car('Y');">&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" class="button" value="일반차" onclick="javascript:search_eco_car('N');"> -->
					<input type="radio" name="eco_yn" value="" <%if (eco_yn.equals("")) {%>checked<%}%>>전체&nbsp;&nbsp;
					<input type="radio" name="eco_yn" value="0" <%if (eco_yn.equals("0")) {%>checked<%}%>>가솔린엔진&nbsp;&nbsp;
					<input type="radio" name="eco_yn" value="1" <%if (eco_yn.equals("1")) {%>checked<%}%>>디젤엔진&nbsp;&nbsp;
					<input type="radio" name="eco_yn" value="2" <%if (eco_yn.equals("2")) {%>checked<%}%>>LPG엔진&nbsp;&nbsp;
					<input type="radio" name="eco_yn" value="3" <%if (eco_yn.equals("3")) {%>checked<%}%>>하이브리드&nbsp;&nbsp;
					<input type="radio" name="eco_yn" value="4" <%if (eco_yn.equals("4")) {%>checked<%}%>>플러그인 하이브리드&nbsp;&nbsp;
					<input type="radio" name="eco_yn" value="5" <%if (eco_yn.equals("5")) {%>checked<%}%>>전기차&nbsp;&nbsp;
					<input type="radio" name="eco_yn" value="6" <%if (eco_yn.equals("6")) {%>checked<%}%>>수소차
				</td>
				<td colspan="3">
					<input type="button" class="button" value="출고예정+본인 차량보기" onclick="javascript:search_ready_car();">&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="hidden" name="ready_car" value="<%=ready_car%>">
					( <span style="background-color: #FFD4DF; border:1px solid; border-color:#B4B4FF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> : 즉시출고가능차량 )
				</td>
			</tr>
		</table>      		
	</div>
</form>
</body>
</html>

