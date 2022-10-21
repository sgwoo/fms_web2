<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*,acar.user_mng.*,acar.parking.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String cnt = request.getParameter("cnt")==null?"":request.getParameter("cnt");

	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_s_cd = request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");

	String deli_dt = request.getParameter("deli_dt")==null?"":request.getParameter("deli_dt");

	String pr[]  = request.getParameterValues("pr");


	int vid_size = pr.length;

	String car_st="";  //2:예비차, 1,3:고객차량, 4:신차
	String park	="";
	String c_id	="";
	String c_no = "";
	String c_nm = "";
	String s_cd	="";
	String d_dt ="";
	String init_reg_dt ="";

	for(int i=0; i < vid_size; i++){
		String[] value = pr[i].toString().split("\\^");
		car_st		= value[0];
		park		= value[1];
		c_id		= value[2];
		c_no		= value[3];
		c_nm		= value[4];
		s_cd		= value[5];
		d_dt		= value[6];
		init_reg_dt		= value[7];
	}

	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_id = u_bean.getBr_id();

	Vector vt = pk_db.CarBasicInfo(c_id);
	int vt_size = vt.size();

	String mng_id	= request.getParameter("mng_id")==null?"":request.getParameter("mng_id");

	//예약시스템에서 의뢰자 정보 가져오기
	if ( mng_id.equals("") ) {

	    if ( car_st.equals("2") ) {
	    		mng_id = pk_db.GetRentContMngId(s_cd);  //보유차
	    } else {
	    		mng_id =  pk_db.CarBasicMngId(c_id); //고객차량
	    }
	}

	int i = 0;
	int j = 0;

	String serv_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "B_M_EMP");
	int user_size = users.size();

	//주차장 정보
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;
	
	//운전자 정보
	CodeBean[] drivers = c_db.getCodeAll("0048");
	int drivers_size = drivers.length;
	
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
<!--
$(document).ready(function(){
	
	parkAreaSetting();
	$('#park_id').bind('change', function(){
		parkAreaSetting();
	});
	
	var fm = document.form1;
	fm.init_reg_dt.value = '<%= init_reg_dt%>';
});

function save(){
	var fm = document.form1;

	if(fm.car_no.value == '')				{	alert('차량번호를 입력하십시오');	fm.car_no.focus(); 		return;	}
	else if(fm.car_nm.value == '')			{	alert('차종을 입력하십시오');		fm.car_nm.focus(); 		return;	}
	else if(fm.users_comp.value == '')		{	alert('담당자를 선택하십시오');		fm.users_comp.focus(); 	return;	}
	else if(fm.driver_nm.value == '')		{	alert('운전자를 선택하십시오');		fm.driver_nm.focus(); 	return;	}
	else if(fm.park_id.value == '')			{	alert('주차장를 선택하십시오');		fm.park_id.focus(); 	return;	}
	else if((fm.driver_nm.value == 'M'||fm.driver_nm.value == 'AT')&&fm.park.value == '')			{	alert('출고위치를 선택하십시오');		fm.park.focus(); 	return;	}
	
	if((fm.car_km.value == '' || Number(fm.car_km.value ) < 1) && fm.car_key_cau.value == '') {	
		alert('주행거리가 없는 사유를 작성하십시오');		
		fm.car_key_cau.focus(); 	return;	
	}
	
	fm.target="i_no";
	fm.action = 'park_o_a.jsp';
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

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<input type='hidden' name='car_mng_id' value='<%=c_id%>'>
<input type='hidden' name='rent_s_cd' value='<%=s_cd%>'>
<input type='hidden' name='d_dt' value='<%=AddUtil.substring(d_dt,0,8)%>'>
<input type="hidden" name="serv_dt" value="<%=AddUtil.ChangeString(AddUtil.getDate())%>">
<input type="hidden" name="io_gubun" value="2">
<input type='hidden' name='mng_id' value='<%=mng_id%>'>
<input type='hidden' name='car_st' value='<%=car_st%>'>
<input type="hidden" name="init_reg_dt" value='<%=init_reg_dt%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 자동차관리 > 주차관리 > <span class=style5>출고 등록</span></span></td>
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
					<td class=title width=10% >차량번호</td>
					<td width='20%'>&nbsp;<input type='text' name="car_no" value='<%=c_no%>' size='30' class='text' style="ime-mode:active;" ></td>
					<td class=title width=10%>차종</td>
					<td  colspan="" width=20%>&nbsp;<input type="text" name="car_nm" value="<%=c_nm%>" size="30" maxlength='50' class='text'></td>
					<td class=title width=10%>주행거리</td>
					<td width=20%>&nbsp;<input type='text' name="car_km" size='20' value="" class='num'>(km)</td>

				</tr>
				<tr>
					<td class=title width=10%>출고일시</td>
					<td colspan="" width=20%>&nbsp;<input type="text" name="io_dt" value="<%=AddUtil.getTimeYMDHMS()%>" size="30" maxlength='10' class='text'></td>
					<td class=title width=10%>등록자</td>
					<td  colspan="" width=20%>&nbsp;<input type='text' name="park_mng" size='30' class='text' value='<%=user_nm%>'></td>
					<td class='title' width=10% >주차장</td>
					<td width=20%>&nbsp;
						<SELECT NAME="park_id" id="park_id">
							<%for(int k = 0 ; k < good_size ; k++){
								CodeBean good = goods[k];
								if(park.equals(good.getNm())){
								%>
							<option value='<%= good.getNm_cd()%>' selected><%= good.getNm()%></option>
							<%}}%>
										
						</SELECT>
						&nbsp;&nbsp;<SELECT NAME="area" id="area">
							<option value=""selected>선택</option>
							<OPTION VALUE="A" >A</option>
							<OPTION VALUE="B" >B</option>
							<OPTION VALUE="C" >C</option>
							<OPTION VALUE="D" >D</option>
							<OPTION VALUE="E" >E</option>
							<OPTION VALUE="F" >F</option>
							<OPTION VALUE="G" >G</option>
							<OPTION VALUE="H" >H</option>
							<OPTION VALUE="I" >I</option>
							<OPTION VALUE="J" >J</option>
							<OPTION VALUE="K" >K</option>
							<OPTION VALUE="L" >L</option>
							<OPTION VALUE="M" >M</option>
							<OPTION VALUE="N" >N</option>
						</SELECT>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>담당자</td>
					<td width='20%'>&nbsp;<select name='users_comp'>
							<option value="">담당자선택</option>
							<option value="알수없음">알수없음</option>
							<%	if(user_size > 0){
									for(int k = 0 ; k < user_size ; k++){
										Hashtable user = (Hashtable)users.elementAt(k); %>
							<option value='<%=user.get("USER_NM")%>' <%if(mng_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
							<%		}
								}%>
						</select>
					</td>
					<td class=title width=10%>차량운전자</td>
					<td width=20%>&nbsp;<SELECT NAME="driver_nm" >
				 			<option value="">담당자선택</option>
						<!--	<OPTION VALUE="S" selected>직원</option>
							<OPTION VALUE="C">고객</option>
							<OPTION VALUE="T">탁송업체</option>
							<OPTION VALUE="M">명진공업사</option>
							<OPTION VALUE="H">정일현대공업사</option>
							<OPTION VALUE="D">두꺼비공업사</option>
							<OPTION VALUE="G1">명광택</option>
							<OPTION VALUE="BK">부경공업사</option>
							<OPTION VALUE="G2">플라이클럽</option>
							<OPTION VALUE="AT">오토크린</option>
							<OPTION VALUE="HD">현대카독크</option>
							<OPTION VALUE="DA">다옴방</option>
							<OPTION VALUE="1K">대전금호</option>
							<OPTION VALUE="BD">본동자동차</option>
							<OPTION VALUE="TW">타이어휠타운</option>
							<OPTION VALUE="NO">알수없음</option> -->
							<%for(int k = 0 ; k < drivers_size ; k++){
											CodeBean driver = drivers[k];
											if(driver.getUse_yn().equals("Y")){
												if(driver.getNm_cd().equals("S")){
											%>
											<option value='<%= driver.getNm_cd()%>' selected><%= driver.getNm()%></option>
											<%		
												}else{
											%>
											<option value='<%= driver.getNm_cd()%>'><%= driver.getNm()%></option>
											<%
												}
											%>
										<%}}%>
						</SELECT>
					</td>
					<td class=title width=10%>출고위치</td>
					<td class= width=30% colspan="">&nbsp;
						<SELECT NAME="park" >
							<option value="0">고객인수</option>							
							
							<%for(int k = 0 ; k < good_size ; k++){
								CodeBean good = goods[k];
								if (!good.getNm_cd().equals("6")) {
							%>
							<option value='<%= good.getNm_cd()%>' ><%= good.getNm()%></option>
							<%
								}
								}
							%>
							<option value="000502">현대글로비스(주)-시화</option>
							<option value="013011">현대글로비스(주)-분당</option>
			                <option value="020385">에이제이셀카(주)</option>
							<option value="022846">롯데렌탈((구)케이티렌탈)</option>				
        		        </SELECT>
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
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="e_oil_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>냉각수</td>
					<td width=40%>&nbsp;
						<SELECT NAME="cool_wt">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="cool_wt_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>워셔액</td>
					<td width=40%>&nbsp;
						<SELECT NAME="ws_wt">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="ws_wt_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>엔진청결도</td>
					<td width=40%>&nbsp;
						<SELECT NAME="e_clean">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="e_clean_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>외관청결도</td>
					<td width=40%>&nbsp;
						<SELECT NAME="out_clean">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="out_clean_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>타이어공기압</td>
					<td width=40%>&nbsp;
						<SELECT NAME="tire_air">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="tire_air_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>타이어 마모</td>
					<td width=40%>&nbsp;
						<SELECT NAME="tire_mamo">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="tire_mamo_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>각종램프</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lamp">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lamp_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>내부청결도</td>
					<td width=40%>&nbsp;
						<SELECT NAME="in_clean">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="in_clean_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>와이퍼작동</td>
					<td width=40%>&nbsp;
						<SELECT NAME="wiper">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="wiper_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>경적작동</td>
					<td width=40%>&nbsp;
						<SELECT NAME="car_sound">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
						</SELECT>&nbsp;내용 : <input type='text' name="car_soundl_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>계기판</td>
					<td width=40%>&nbsp;
						<SELECT NAME="panel">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="보충">보충</option>
							<OPTION VALUE="정비">정비</option>
							<OPTION VALUE="교환">교환</option>
					</SELECT>&nbsp;내용 : <input type='text' name="panel_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>전면범퍼</td>
					<td width=40%>&nbsp;
						<SELECT NAME="front_bp">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="front_bp_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>후면범퍼</td>
					<td width=40%>&nbsp;
						<SELECT NAME="back_bp">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="back_bp_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>LH_앞휀더</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_fhd">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lh_fhd_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>LH_뒤휀더</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_bhd">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lh_bhd_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>LH_앞도어</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_fdoor">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lh_fdoor_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>LH_뒤도어</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_bdoor">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="lh_bdoor_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>RH_앞휀더</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_fhd">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="rh_fhd_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>RH_뒤휀더</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_bhd">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="rh_bhd_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>RH_앞도어</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_fdoor">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
						</SELECT>&nbsp;내용 : <input type='text' name="rh_fdoor_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>RH_뒤도어</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_bdoor">
							<OPTION VALUE="정상">정상</option>
							<OPTION VALUE="파손">파손</option>
							<OPTION VALUE="상처">상처</option>
							<OPTION VALUE="휘임">휘임</option>
							<OPTION VALUE="이색">이색</option>
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
							<OPTION VALUE="E">E</option>
						</SELECT>&nbsp;내용 : <input type='text' name="energy_ny" size='80' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>기    타</td>
					<td width=90% colspan="3">&nbsp;<TEXTAREA NAME="gita" ROWS="3" COLS="135"></TEXTAREA></td>
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
						<INPUT TYPE="radio" NAME="goods1" VALUE="없음">없음
					</td>
					<td class=title width=10%>사용설명서</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods2" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods2" VALUE="없음">없음
					</td>
					<td class=title width=10%>리모컨</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods3" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods3" VALUE="없음">없음
					</td>
					<td class=title width=10%>보조키</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods4" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods4" VALUE="없음">없음
					</td>
					<td class=title width=10%>시거라이터</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods13" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods13" VALUE="없음">없음
					</td>
				</tr>
				<tr>
					<td class=title width=10%>삼각대</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods7" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods7" VALUE="없음">없음
					</td>
					<td class=title width=10%>공구</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods8" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods8" VALUE="없음">없음
					</td>
					<td class=title width=10%>S타이어</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods10" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods10" VALUE="없음">없음
					</td>
					<td class=title width=10%>스노우체인</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods11" VALUE="있음">있음
						<INPUT TYPE="radio" NAME="goods11" VALUE="없음">없음
					</td>
					<td class= width=10% colspan='2'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	  <td align='right'>
	  	<img src="/acar/images/center/button_reg.gif" onclick="save();" border="0" align="absmiddle"><!-- <a href="javascript:save()"></a> -->
	  	<a href='javascript:close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
	  	</td>
	</tr>

  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
