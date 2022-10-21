<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.parking.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%	
	
	int park_seq = request.getParameter("park_seq")==null?1:Util.parseInt(request.getParameter("park_seq"));
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String io_gubun = request.getParameter("io_gubun")==null?"":request.getParameter("io_gubun");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	int car_km = request.getParameter("car_km")==null?0:AddUtil.parseDigit(request.getParameter("car_km")); // 주행거리

	String new_car = request.getParameter("new_car")==null?"":request.getParameter("new_car");
	String last_km = "";
	
	String io_dt = request.getParameter("io_dt")==null?"":request.getParameter("io_dt");
	String io_sau = request.getParameter("io_sau")==null?"":request.getParameter("io_sau");
	String users_comp = request.getParameter("users_comp")==null?"":request.getParameter("users_comp");
	String driver_nm = request.getParameter("driver_nm")==null?"":request.getParameter("driver_nm");
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng");
	String area = request.getParameter("area")==null?"":request.getParameter("area");
	
	int count =0;
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	String serv_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
	String s_kd = "";
	String t_wd = "";
	String sort_gubun = "";
	String asc = "";

	CommonDataBase c_db = CommonDataBase.getInstance();

	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_id = u_bean.getBr_id();

	Vector users = c_db.getUserList("", "", "B_M_EMP");
	int user_size = users.size();

	//운전자 정보
	CodeBean[] drivers = c_db.getCodeAll("0048");
	int drivers_size = drivers.length;

	//주차장 정보
	CodeBean[] goods = c_db.getCodeAll("0027");
	int goods_size = goods.length;
	
	
	//점검사항
	String e_oil = "";
	String cool_wt = "";
	String ws_wt = "";
	String e_clean = "";
	String out_clean = "";
	String tire_air = "";
	String tire_mamo = "";
	String lamp = "";
	String in_clean = "";
	String wiper = "";
	String panel = "";
	String front_bp = "";
	String back_bp = "";
	String lh_fhd = "";
	String lh_bhd = "";
	String lh_fdoor = "";
	String lh_bdoor = "";
	String rh_fhd = "";
	String rh_bhd = "";
	String rh_fdoor = "";
	String rh_bdoor = "";
	String energy = "";
	String car_sound = "";
	String goods1 = "";
	String goods2 = "";
	String goods3 = "";
	String goods4 = "";
	String goods5 = "";
	String goods6 = "";
	String goods7 = "";
	String goods8 = "";
	String goods9 = "";
	String goods10 = "";
	String goods11 = "";
	String goods12 = "";
	String goods13 = "";
	String e_oil_ny = "";
	String cool_wt_ny = "";
	String ws_wt_ny = "";
	String e_clean_ny = "";
	String out_clean_ny = "";
	String tire_air_ny = "";
	String tire_mamo_ny = "";
	String lamp_ny = "";
	String in_clean_ny = "";
	String wiper_ny = "";
	String panel_ny = "";
	String front_bp_ny = "";
	String back_bp_ny = "";
	String lh_fhd_ny = "";
	String lh_bhd_ny = "";
	String lh_fdoor_ny = "";
	String lh_bdoor_ny = "";
	String rh_fhd_ny = "";
	String rh_bhd_ny = "";
	String rh_fdoor_ny = "";
	String rh_bdoor_ny = "";
	String energy_ny = "";
	String car_sound_ny = "";
	String gita ="";
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
$(document).ready(function(){
	
	parkAreaSetting();
	$('#park_id').bind('change', function(){
		parkAreaSetting();
	});
});

function save(){
	var fm = document.form1;
	
	if(fm.car_no.value == '')						{	alert('차량번호를 입력하십시오');			fm.car_no.focus(); 			return;	}
	if(fm.users_comp.value == '')				{	alert('담당자를 선택하십시오');				fm.users_comp.focus(); 	return;	}
	if(fm.driver_nm.value == '')				{	alert('운전자를 선택하십시오');				fm.driver_nm.focus(); 	return;	}
	if(fm.park_id.value == '')					{	alert(' 주차장 차고지를 선택하십시오');	fm.park_id.focus(); 		return;	}	
	if(fm.rent_l_cd.value == '')				{	alert(' 차량을 선택하십시오');			fm.car_no.focus(); 	return;	}	
	//if(fm.car_key.value == 'X' && fm.car_key_cau.value == '')				{	alert('차키가 없는 사유를 작성하십시오');			fm.car_key_cau.focus(); 	return;	}
	if((fm.car_km.value == '' || toInt(fm.car_km.value ) < 1) && fm.car_key_cau.value == '') {	
		alert('주행거리가 없는 사유를 작성하십시오');		
		fm.car_key_cau.focus(); 	return;	
	}
	
	//영남주차장인경우 위치 
	if (fm.park_id.value == '1' ) {
	   if ( fm.area.value == '' )  {	alert(' 주차장 위치를 선택하십시오');				fm.area.focus(); 	return;	}	
	}
	
		

	
	if(toInt(fm.last_km.value) > toInt(fm.car_km.value) ) { //주행거리가 마지막 입력된것보다 작을때 보여줌. 같을땐 패스..
		alert('입력한 주행거리가 마지막 주행거리 ('+fm.last_km.value+' km) 보다 작습니다.');
		if(!confirm('진짜!!! 등록 하시겠습니까?')){	
			return;	
		}
	}
	
	fm.target="i_no";
	fm.action="park_i_a.jsp";
	fm.submit();
	
	fn_layer_popup();
}
function Close()
{
	opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}
	
		function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search_car();
	}


//검색하기
	function search_car(){
		var fm = document.form1;	
	
		if(fm.car_no.value == ''){ alert('차량번호를 입력하십시오.'); fm.car_no.focus(); return; }	
		window.open("about:blank", "SEARCH_CAR", "left=100, top=100, width=700, height=300, scrollbars=yes");		
		fm.target = "SEARCH_CAR";
		fm.action = "search.jsp?s_kd=2&t_wd="+fm.car_no.value;
		fm.submit();					
	}

//영남주차장은 주차장 구역 세분화
function parkAreaSetting(){
	var area_type1 = "";
	var area_type2 = "";
	area_type1 += '<option value=""selected>선택</option>		<OPTION VALUE="A" >A구역</option>' +
				  '<OPTION VALUE="B" >B구역</option>			<OPTION VALUE="C" >C구역</option>' +
				  '<OPTION VALUE="D" >D구역</option>			<OPTION VALUE="E" >E구역</option>' +
				  '<OPTION VALUE="F" >F구역</option>			<OPTION VALUE="G" >G구역</option>' +
				  '<OPTION VALUE="H" >H구역</option>';
  	area_type2 += '<option value=""selected>선택</option>		<OPTION VALUE="3A" >3층A구역</option>' +
  				  '<OPTION VALUE="3B" >3층B구역</option>		<OPTION VALUE="3C" >3층C구역</option>' +
	  			  '<OPTION VALUE="4A" >4층A구역</option>		<OPTION VALUE="4B" >4층B구역</option>' +
				  '<OPTION VALUE="4C" >4층C구역</option>		<OPTION VALUE="5A" >5층A구역</option>' +
				  '<OPTION VALUE="5B" >5층B구역</option>		<OPTION VALUE="5C" >5층C구역</option>' +
				  '<OPTION VALUE="F" >F구역</option>			<OPTION VALUE="G" >G구역</option>' +		
				  '<OPTION VALUE="H" >H구역</option>';
				  
	if($("#park_id").val()=="1"){	$("#area").html(area_type2);	}
	else{							$("#area").html(area_type1);	}
	
}

function fn_layer_popup(){  
	var layer = document.getElementById("loader");	
	var layerContent = document.getElementById("loaderContent");	
	layer.style.visibility="visible"; 
	layerContent.style.animation="spin 0.8s linear infinite"; 
}

//-->
</script>
<style>
.loaderLayer {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0px;
  left: 0px;
  visibility: hidden;
  background-color: rgba(112, 113, 102, 0.3);
}
.loader {
  position: absolute;
  top: 45%;
  left: 50%;
  z-index: 1;
  border: 8px solid #f3f3f3;
  border-radius: 50%;
  border-top: 8px solid #3498db;
  width: 30px;
  height: 30px;
  /* -webkit-animation: spin 1s linear infinite; */
  /* animation: spin 0.8s linear infinite; */
}

/* Safari */
@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<body leftmargin="15">
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type="hidden" name="car_mng_id" value=""> 
<input type="hidden" name="rent_mng_id" value=""> 
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_st" value="">  
<input type="hidden" name="mng_id" value=""> 
<input type="hidden" name="firm_nm" value=""> 
<input type="hidden" name="init_reg_dt" value=""> 
<input type="hidden" name="io_gubun" value="1"> 
<input type='hidden' name="reg_id" value='<%=user_id%>'>
<input type="hidden" name="serv_dt" value="<%=AddUtil.ChangeString(AddUtil.getDate())%>"> 
<input type="hidden" name="cmd" value="">


<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 예비차관리 > 당산주차장현황 > <span class=style5>차량입고등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>            
		</td>
	</tr>
	<tr> 
		<td class=h></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">
				<tr>
					<td class=title width=10% >차량/차대번호</td>
					<td width=20%>&nbsp;<input type='text' name="car_no" value='' size='20' class='text' onKeyDown='javascript:enter()' style="ime-mode:active;" >
					<a href="javascript:search_car()"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></td>
					<td class=title width=10%>차종</td>
					<td width=20%>&nbsp;<input type="text" name="car_nm" value="" size="25" maxlength='50' class='text'></td>
					<td class=title width=10%>주행거리</td>
					<input type="hidden" name="last_km" value="">
					<td width=20%>&nbsp;<input type='text' name="car_km" size='20' class='num'>(km)</td>
				</tr>
		
				<tr>
					<td class=title width=10%>담당자</td>
					<td width='20%'>&nbsp;<select name='users_comp'>
		                <option value="">담당자선택</option>
						<option value="알수없음">알수없음</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_NM")%>' <%if(mng_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
		                <%		}
							}%>
		              </select></td>            	
					<td class=title width=10%>차량운전자</td>
					<td width=20%>&nbsp;<SELECT NAME="driver_nm" >
										<option value=""selected>운전자선택</option>
									<!-- 	<OPTION VALUE="S">직원</option>
										<OPTION VALUE="C">고객</option>
										<OPTION VALUE="T">탁송업체</option>
										<OPTION VALUE="M">명진공업사</option>
										<OPTION VALUE="H">정일현대공업사</option>
										<OPTION VALUE="D">두꺼비공업사</option>
										<OPTION VALUE="BK">부경공업사</option>
										<OPTION VALUE="G2">플라이클럽</option>
										<OPTION VALUE="AT">오토크린</option>
										<OPTION VALUE="HD">현대카독크</option>
										<OPTION VALUE="DA">다옴방</option>
										<OPTION VALUE="NB">노블레스</option>
										<OPTION VALUE="1K">대전금호</option>
										<OPTION VALUE="BD">본동카센타</option>
										<option value="NO">알수없음</option> -->
										<%for(int i = 0 ; i < drivers_size ; i++){
											CodeBean driver = drivers[i];
											if(driver.getUse_yn().equals("Y")){
											%>
										<option value='<%= driver.getNm_cd()%>'><%= driver.getNm()%></option>
										<%}}%>
									</SELECT>
					</td>
					<td class='title' width=10% >주차장</td>
					<td width=20%>&nbsp;<SELECT NAME="park_id" id="park_id" >
							
							
										<option value=""selected>주차장선택</option>
										 <OPTION VALUE="1" <%if(br_id.equals("S1")){%>selected<%}%>>영남주차장</option>
										<%-- <OPTION VALUE="8" <%if(br_id.equals("B1")){%>selected<%}%>>부산조양</option>  --%>
										<OPTION VALUE="8" <%if(br_id.equals("B1")){%>selected<%}%>>웰메이드</option> 
										<OPTION VALUE="7" >부산부경</option>
										<OPTION VALUE="4" <%if(br_id.equals("D1")){%>selected<%}%>>대전지점</option>
										<!-- <OPTION VALUE="9" >대전현대</option>		 -->								
										<OPTION VALUE="12" <%if(br_id.equals("J1")){%>selected<%}%>>광주지점</option>
										<OPTION VALUE="13" <%if(br_id.equals("G1")){%>selected<%}%>>대구지점</option> 
										<OPTION VALUE="20">성서현대</option> 
										
								<%-- 		<%for(int i = 0 ; i < goods_size ; i++){
											CodeBean good = goods[i];
											if(good.getUse_yn().equals("Y")){
											%>
										<option value='<%= good.getNm_cd()%>'><%= good.getNm()%></option>
										<%}}%> --%>
										
									</SELECT>
								&nbsp;&nbsp;<SELECT NAME="area" id="area">
										<option value=""selected>선택</option>
										<OPTION VALUE="A" >A구역</option>
										<OPTION VALUE="B" >B구역</option>
										<OPTION VALUE="C" >C구역</option>
										<OPTION VALUE="D" >D구역</option>
										<OPTION VALUE="E" >E구역</option>
										<OPTION VALUE="F" >F구역</option>
										<OPTION VALUE="G" >G구역</option>
										<OPTION VALUE="H" >H구역</option>
									</SELECT>		
					</td>
				</tr>
				<tr>
					<td class=title width=10%>입고일시</td>
					<td colspan="" width=20%>&nbsp;<input type="text" name="io_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(AddUtil.getDate(4)))%>" size="30" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate4(this, this.value);'></td>					
					<td class=title width=10%>등록자</td>
					<td  colspan="" width=20%>&nbsp;<input type='text' name="park_mng" size='30' class='text' value='<%=user_nm%>'></td>
<!-- 					<td class=title width=10%>신차여부</td>
					<td  colspan="" width=20%>&nbsp;<SELECT NAME="new_car" >
										<option value=""selected>선택</option>
										<OPTION VALUE="YC" >신차</option>
									</SELECT></td> 
					-->
									
					<td class=title width=10%>차키유무</td>
					<td colspan="" width=20%>&nbsp;
					<input type='radio' name='car_key' value="O" checked >유
					<input type='radio' name='car_key' value="X" >무
					</td>
				</tr>
				<tr>
					<td class=title width=10%>사유</td>
					<td  colspan="5" width=20%>&nbsp;<input type='text' name="car_key_cau" size='70' class='text' value=''></td>
				</tr>
			</table>
		</td>
    </tr>
		<tr>
    	<td class=""></td>
    </tr>
	<tr>
    	<td class=line>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class=title colspan="4">점검사항</td>
				</tr>
				<tr>
					<td class=title width=10%>엔진오일</td>
					<td width=40%>&nbsp;
						<SELECT NAME="e_oil">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="e_oil_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>냉각수</td>
					<td width=40%>&nbsp;
						<SELECT NAME="cool_wt">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="cool_wt_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>워셔액</td>
					<td width=40%>&nbsp;
						<SELECT NAME="ws_wt">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="ws_wt_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>엔진청결도</td>
					<td width=40%>&nbsp;
						<SELECT NAME="e_clean">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="e_clean_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>외관청결도</td>
					<td width=40%>&nbsp;
						<SELECT NAME="out_clean">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="out_clean_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>타이어공기압</td>
					<td width=40%>&nbsp;
						<SELECT NAME="tire_air">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="tire_air_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>타이어 마모</td>
					<td width=40%>&nbsp;
						<SELECT NAME="tire_mamo">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="tire_mamo_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>각종램프</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lamp">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lamp_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>내부청결도</td>
					<td width=40%>&nbsp;
						<SELECT NAME="in_clean">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="in_clean_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>와이퍼작동</td>
					<td width=40%>&nbsp;
						<SELECT NAME="wiper">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="wiper_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>경적작동</td>
					<td width=40%>&nbsp;
						<SELECT NAME="car_sound">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="car_soundl_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>계기판</td>
					<td width=40%>&nbsp;
						<SELECT NAME="panel">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충" style="color:#f00">보충</option>
							<OPTION VALUE="정비" style="color:#f00">정비</option>
							<OPTION VALUE="교환" style="color:#f00">교환</option>
					</SELECT>&nbsp;내용 : <input type='text' name="panel_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>전면범퍼</td>
					<td width=40%>&nbsp;
						<SELECT NAME="front_bp">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="front_bp_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>후면범퍼</td>
					<td width=40%>&nbsp;
						<SELECT NAME="back_bp">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="back_bp_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>LH_앞휀더</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_fhd">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lh_fhd_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>LH_뒤휀더</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_bhd">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lh_bhd_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>LH_앞도어</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_fdoor">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lh_fdoor_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>LH_뒤도어</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_bdoor">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lh_bdoor_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>RH_앞휀더</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_fhd">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="rh_fhd_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>RH_뒤휀더</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_bhd">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="rh_bhd_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>RH_앞도어</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_fdoor">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="rh_fdoor_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>RH_뒤도어</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_bdoor">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손" style="color:#f00">파손</option>
							<OPTION VALUE="상처" style="color:#f00">상처</option>
							<OPTION VALUE="휘임" style="color:#f00">휘임</option>
							<OPTION VALUE="이색" style="color:#f00">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="rh_bdoor_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>연    료</td>
					<td colspan="3" width=40%>&nbsp;
						<SELECT NAME="energy">
							<OPTION VALUE="FULL">FULL</option>
							<OPTION VALUE="3/4">3/4</option>
							<OPTION VALUE="2/4">2/4</option>
							<OPTION VALUE="1/4">1/4</option>
							<OPTION VALUE="E" style="color:#f00">E</option>
						</SELECT>&nbsp;내용 : <input type='text' name="energy_ny" size='80' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>기    타</td>
					<td width=90% colspan="3">&nbsp;<TEXTAREA NAME="gita" ROWS="5" COLS="135"></TEXTAREA></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
    	<td class=""></td>
    </tr>
    <tr>
    	<td class=line2></td>
    </tr>
	<tr>
    	<td class=line>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
  					<td class=title colspan="10">비치용품</td>
				</tr>
				<tr>
					<td class=title width=10%>등록증</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods1" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods1" VALUE="없음" style="color:#f00">없음
					</td>
					<td class=title width=10%>사용설명서</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods2" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods2" VALUE="없음" style="color:#f00">없음
					</td>
					<td class=title width=10%>리모컨</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods3" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods3" VALUE="없음" style="color:#f00">없음
					</td>
					<td class=title width=10%>보조키</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods4" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods4" VALUE="없음" style="color:#f00">없음
					</td>
					<td class=title width=10%>시거라이터</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods13" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods13" VALUE="없음" style="color:#f00">없음
					</td>
				</tr>
				<tr>
					<td class=title width=10%>삼각대</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods7" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods7" VALUE="없음" style="color:#f00">없음
					</td>
					<td class=title width=10%>공구</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods8" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods8" VALUE="없음" style="color:#f00">없음
					</td>
					<td class=title width=10%>S타이어</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods10" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods10" VALUE="없음" style="color:#f00">없음
					</td>
					<td class=title width=10%>스노우체인</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods11" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods11" VALUE="없음" style="color:#f00">없음
					</td>
					<td class= width=10% colspan='2'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	  <td align='right'>
	  	<img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle" onMouseOver="this.style.cursor='pointer'" onclick="save();"><!-- <a href="javascript:save()"></a>  this.style.visibility='hidden'-->
	  	<a href='javascript:close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
	  	<div class="loaderLayer" id="loader">
	  		<div class="loader" id="loaderContent"></div>
	  	</div>
	  	</td>
	</tr>
	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>