<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.parking.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%	
	
	int park_seq = request.getParameter("park_seq")==null?0:Util.parseInt(request.getParameter("park_seq"));
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");

	String new_car = request.getParameter("new_car")==null?"":request.getParameter("new_car");	
	
	String users_comp = request.getParameter("users_comp")==null?"":request.getParameter("users_comp");
	String user_m_tel = request.getParameter("user_m_tel")==null?"":request.getParameter("user_m_tel");
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng");
	String wash_dt = request.getParameter("wash_dt")==null?"":request.getParameter("wash_dt");
	String wash_pay = request.getParameter("wash_pay")==null?"10000":request.getParameter("wash_pay");
		
	int count =0;
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	
//	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
//	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
//	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호

	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");

	String req_dt = request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String wash_etc = request.getParameter("wash_etc")==null?"포괄지시건":request.getParameter("wash_etc");
	String gubun_st = request.getParameter("gubun_st")==null?"2":request.getParameter("gubun_st");
	
	String s_kd = "";
	String t_wd = "";
	String sort_gubun ="";
	String asc ="";
	
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
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>

/* $(document).ready(function(){
	
	parkAreaSetting();
	$('#park_id').bind('change', function(){
		parkAreaSetting();
	});
	
}); */

function save(){	
	var fm = document.form1;
	var regNum = /^[0-9]*$/;
/* 	if (fm.car_no.value == '') { 
		alert('차대번호를 입력하십시오');	 
		fm.car_no.focus(); 
		return;  */
/* 	} else if(fm.park_id.value == '') {	
		alert('주차장 차고지를 선택하십시오');
		fm.park_id.focus(); 	
		return;	 */
/* 	} else if(fm.rent_l_cd.value == '') {
		alert('차대번호를 조회하여 선택하십시오');
		fm.car_no.focus(); 	
		return; */	
	/* } else if (fm.wash_dt.value == '') {
		alert('세차일시를 입력하세요.');
		fm.wash_dt.focus();
		return; */
	/* } else if (fm.wash_pay.value == '') {
		alert('세차요금을 입력하세요.');
		fm.wash_pay.focus();
		return; */
	/* } else if (!regNum.test(fm.wash_pay.value)) {
		alert("세차요금은 숫자로만 입력하세요.");
		fm.wash_pay.focus();
		return; 
	}
		 */
		 
	if(fm.reason.value== ''){
		alert('사유를 반드시 입력하셔야합니다.');
		return;
	}	 
		 
	if(!confirm('등록 하시겠습니까?')){
		return;
	}

	fm.target="i_no";
	fm.action="park_w_i2_a.jsp";	
	fm.submit();	  
	
	fn_layer_popup();
}

function modify() {
	var fm = document.form1;
	var regNum = /^[0-9]*$/;
	if(fm.park_id.value == '') {	
		alert('주차장 차고지를 선택하십시오');
		fm.park_id.focus(); 	
		return;	
	} else if (fm.wash_dt.value == '') {
		alert('세차일시를 입력하세요.');
		fm.wash_dt.focus();
		return;
	} else if (fm.wash_pay.value == '') {
		alert('세차요금을 입력하세요.');
		fm.wash_pay.focus();
		return;
	} else if (!regNum.test(fm.wash_pay.value)) {
		alert("세차요금은 숫자로만 입력하세요.");
		fm.wash_pay.focus();
		return;
	}	
	
	if(!confirm('수정 하시겠습니까?')){
		return;
	}

	fm.target="i_no";
	fm.action="park_w_i2_a.jsp";	
	fm.submit();	
	
	fn_layer_popup();
}

function Close() {
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

	if(fm.car_no.value == ''){ 
		alert('검색어를 입력하십시오.'); 
		fm.car_no.focus(); 
		return; 
	}	
	window.open("about:blank", "SEARCH_CAR", "left=100, top=100, width=700, height=300, scrollbars=yes");		
	fm.target = "SEARCH_CAR";
	fm.action = "search_w2.jsp?s_kd="+fm.s_kd.value+"&t_wd="+fm.car_no.value;
	fm.submit();
}

//영남주차장은 주차장 구역 세분화
/* function parkAreaSetting(){
	var area_type1 = "";
	var area_type2 = "";
	area_type1 += '<option value=""selected>선택</option>		<option value="A" >A구역</option>' +
				  '<option value="B" >B구역</option>			<option value="C" >C구역</option>' +
				  '<option value="D" >D구역</option>			<option value="E" >E구역</option>' +
				  '<option value="F" >F구역</option>			<option value="G" >G구역</option>' +
				  '<option value="H" >H구역</option>';
  	area_type2 += '<option value=""selected>선택</option>			<option value="4A" >4층A구역</option>' +
				  '<option value="4B" >4층B구역</option>			<option value="4C" >4층C구역</option>' +
				  '<option value="5A" >5층A구역</option>			<option value="5B" >5층B구역</option>' +
				  '<option value="5C" >5층C구역</option>			<option value="D" >D구역</option>	' +		
				  '<option value="E" >E구역</option>				<option value="F" >F구역</option>	' +		
				  '<option value="G" >G구역</option>				<option value="H" >H구역</option>';
				  
	if($("#park_id").val()=="1"){	
		$("#area").html(area_type2);	
	}else {							
		$("#area").html(area_type1);	
	}	
} */

function fn_layer_popup(){  
	var layer = document.getElementById("loader");	
	var layerContent = document.getElementById("loaderContent");	
	layer.style.visibility="visible"; 
	layerContent.style.animation="spin 0.8s linear infinite"; 
}


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

.input_box {width: 100px;}
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
<input type="hidden" name="mng_id" value="<%=mng_id%>"> 
<input type="hidden" name="users_comp" value="<%=users_comp%>"> 
<input type="hidden" name="user_m_tel" value="<%=user_m_tel%>"> 
<input type="hidden" name="firm_nm" value=""> 
<input type="hidden" name="io_gubun" value="1"> 
<input type='hidden' name="reg_id" value='<%=user_id%>'>
<input type="hidden" name="serv_dt" value="<%=AddUtil.ChangeString(AddUtil.getDate())%>"> 
<input type="hidden" name="cmd" value="">
<input type="hidden" name="park_seq" value="<%=park_seq%>">
<input type="hidden" name="gubun_st" value="<%=gubun_st%>">
<input type="hidden" name="wash_etc" value="<%=wash_etc%>">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>차량관리 > 보유차관리 > 주차장세차현황 > <span class=style5>신차세차차량등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>            
		</td>
	</tr>
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">
				<tr>
					<td class=title width=10%>
						 <select name='s_kd'>       
				          <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option> 
				          <option value='4' <%if(s_kd.equals("4"))%>selected<%%>>차대번호</option>
				        </select>
					</td>
					 <td width=20% style="padding-left: 5px;">
						<% if (park_seq == 0) { %>
								<input type='text' name="car_no" value='<%=car_no%>' size='25' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
								<a href="javascript:search_car()"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a>
						<% } else { %>
								<%=car_no%>
								<input type='hidden' name="car_no" value='<%=car_no%>'>
						<% } %>						
					</td> 
					
					<td class=title width=10%>차명</td>
					<td width=20% style="padding-left: 5px;">
						<% if (park_seq == 0) { %>
							<input type="text" name="car_nm" value="<%=car_nm%>" size="30" maxlength='50' class='text'>
						<% } else { %>
								<%=car_nm%>
								<input type="hidden" name="car_nm" value="<%=car_nm%>">
						<% } %>
					</td>
					<%-- <td class=title width=10%>담당자</td>
					<td width='20%' style="padding-left: 5px;">
						<select name='users_comp'>
			                <option value="">담당자선택</option>
							<option value="알수없음">알수없음</option>
			                <%	if(user_size > 0){
										for(int i = 0 ; i < user_size ; i++){
											Hashtable user = (Hashtable)users.elementAt(i); %>
			                				<%if (park_seq == 0) { %>
			                					<option value='<%=user.get("USER_NM")%>' <%if(mng_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
			                				<%} else { %>
			                					<option value='<%=user.get("USER_NM")%>' <%if(users_comp.equals(user.get("USER_NM"))){%>selected<%}%>><%=user.get("USER_NM")%></option>			                				
			                				<%}%>
			                	<%	}
									}%>	
		              	</select>
		            </td> --%>
		            <td class='title' width=10% >주차위치</td>
					<td width=20% style="padding-left: 5px;">
						<select name="park_id" id="park_id" >
						<% if (park_seq == 0) { %>
								<option value="" selected>차고지선택</option>
								<option value="1" <%if(br_id.equals("S1")){%>selected<%}%>>영남주차장</option>
								<%-- <option value="17" <%if(br_id.equals("B1")){%>selected<%}%>>웰메이드</option>
								<option value="7" >부산부경</option>
								<option value="4" <%if(br_id.equals("D1")){%>selected<%}%>>대전지점</option>
								<option value="12" <%if(br_id.equals("J1")){%>selected<%}%>>광주지점</option>
								<option value="13" <%if(br_id.equals("G1")){%>selected<%}%>>대구지점</option> --%>
						<% } else { %>							
								<option value="" selected>차고지선택</option>
								<option value="1" <%if(park_id.equals("1")){%>selected<%}%>>영남주차장</option>
								<%-- <option value="17" <%if(park_id.equals("17")){%>selected<%}%>>웰메이드</option>
								<option value="7" <%if(park_id.equals("7")){%>selected<%}%>>부산부경</option>
								<option value="4" <%if(park_id.equals("4")){%>selected<%}%>>대전지점</option>										
								<option value="12" <%if(park_id.equals("12")){%>selected<%}%>>광주지점</option>
								<option value="13" <%if(park_id.equals("13")){%>selected<%}%>>대구지점</option> --%>							
						<% } %>
						</select>
						<!-- &nbsp;
						<select name="area" id="area">
								<option value="" selected>선택</option>
								<option value="A">A구역</option>
								<option value="B">B구역</option>
								<option value="C">C구역</option>
								<option value="D">D구역</option>
								<option value="E">E구역</option>
								<option value="F">F구역</option>
								<option value="G">G구역</option>
								<option value="H">H구역</option>
						</select> -->
					</td>
				</tr>		
				<!-- <tr> -->					
					<%-- <td class=title width=10%>등록자</td>
					<td width=20% style="padding-left: 5px;">
						<% if (park_seq == 0) { %>
							<input type='text' name="park_mng" size='30' class='text' value='<%=user_nm%>'>
						<% } else { %>
							<input type='text' name="park_mng" size='30' class='text' value='<%=park_mng%>'>
						<% } %>
					</td> --%>
					
					
					<%-- <td class=title width=10%>작업요청일시</td>
					<td width=20% style="padding-left: 5px;">
						<% if (park_seq == 0) { %>
							<input type="text" name="start_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(AddUtil.getDate(4)))%>" size="10" maxlength='10' class='text input_box' onBlur='javascript:this.value=ChangeDate4(this, this.value);'>
						<% } else { %>
							<input type="text" name="start_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(req_dt))%>" size="10" maxlength='10' class='text input_box' onBlur='javascript:this.value=ChangeDate4(this, this.value);'>
						<% } %>
						<select name="start_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                        </select>
                        <select name="start_m" >
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                        </select>
					</td> --%>
					
					
					<%-- <td class=title width=10%>세차요금(vat포함)</td>
					<td width=20% colspan="3" style="padding-left: 5px;">
						<input type="text" name="wash_pay" value="<%=wash_pay%>" size="10" maxlength='10' class='text'>원
					</td> --%>
					
					
					<%-- <td class=title width=10%>적요</td>
					<td width=20% colspan="5" style="padding-left: 5px;">
						<input type="text" class="text" name="wash_etc" value="<%=wash_etc%>" style="width: 500px;">						
					</td> --%>
				<!-- </tr> -->
				<tr>
					<td class=title width=10%>작업요청</td>
					<td width=20% colspan="5" style="padding-left:5px;">
						<input type="checkbox" name="wash_pay" value="10000" checked>세차 (10,000원)&nbsp;			
						<input type="checkbox" name="inclean_pay" value="20000" >실내크리닝 및 냄새제거 (20,000원)		
					</td>
				</tr>
				<tr>
					<td class=title width=10%>사유</td>
					<td width=20% colspan="5" style="padding-left:5px;">
						<input type="text" name="reason" style="width:95%;">			
						
					</td>
				</tr>
					
			</table>
		</td>
    </tr>
		<tr>
    	<td class=""></td>
    </tr>
	
	<tr>
	  <td align='right'>
	  		<img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle" onMouseOver="this.style.cursor='pointer'" onclick="save();">	  	
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