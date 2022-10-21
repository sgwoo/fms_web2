<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<%@ page import="acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");
	
	String period_gubun = request.getParameter("period_gubun")==null?"":request.getParameter("period_gubun");
	String branch = request.getParameter("branch")==null?"":request.getParameter("branch");		//영업지점 검색추가
	String bus_user_id = request.getParameter("bus_user_id")==null?"":request.getParameter("bus_user_id");		//통화작성자 검색추가
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(!gubun4.equals("3")){
		s_dt = "";
		e_dt = "";
	}
	
	LoginBean login = LoginBean.getInstance();
	
	if(t_wd.equals("") && s_kd.equals("4"))		t_wd = login.getCookieValue(request, "acar_id");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//영업담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">

<title>FMS</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
$(document).ready(function(){
	$("input[name='period_gubun']").change(function(){
		search();
	})
	
	//검색조건 존재시 검색바에 세팅
	var pre_period_gubun = $("#pre_period_gubun").val();
	var pre_gubun4 = $("#pre_gubun4").val();
	var pre_s_dt = $("#pre_s_dt").val();
	var pre_e_dt = $("#pre_e_dt").val();
	var pre_period_gubun = $("#pre_e_dt").val();
	var pre_period_gubun = $("#pre_period_gubun").val();
	
	if(pre_period_gubun!=null && pre_period_gubun!=""){	//신차,재리스,월렌트 구분 라디오버튼 세팅
		$("input:radio[name='period_gubun']").removeAttr("checked");
		if(pre_period_gubun == '1') $("input:radio[name='period_gubun']:radio[value='1']").prop("checked",true);
		if(pre_period_gubun == '10') $("input:radio[name='period_gubun']:radio[value='10']").prop("checked",true);		
	}
	if(pre_gubun4!=null && pre_gubun4!=""){	//상세조회 세팅
		if(pre_gubun4 == '3'){
			cng_dt();
		}
	}
})
</script>
<script language="JavaScript">
//조회
function search(){
	var fm = document.form1;
	/*  if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '2'||fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //작성자,상담자
		fm.t_wd.value = fm.reg_id.options[fm.reg_id.selectedIndex].value;		
	} */
	fm.action = "esti_spe_hp_grid_big_sc.jsp";
	fm.target = "c_foot";
	fm.submit();
}

//디스플레이 타입
function cng_input(){
	var fm = document.form1;
	if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '2' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //작성자, 상담자
		td_input.style.display	= 'none';
		td_reg.style.display 	= '';
	}else{
		td_input.style.display	= '';
		td_reg.style.display 	= 'none';
		fm.t_wd.value = '';
	}
}

//디스플레이 타입
function cng_dt(){
	var fm = document.form1;
	if(fm.gubun4.options[fm.gubun4.selectedIndex].value == '3'){ //기간
		esti.style.display 	= 'inline';
		//fm.esti_m_dt.value		= '';
		//esti_m_dt.style.display = 'none';
	}else{
		esti.style.display 	= 'none';
	}
}

function kakaoMsgSend() {
	
	var fm = document.content_form;
	
	var check_length = $('input:checkbox[name="content_check"]:checked').length;
	if (check_length == 0) {
	 	alert("고객을 선택하세요.");
		return;
	} else {
		window.open("", "popup_window", "width=1000, height=850, scrollbars=yes");
		fm.action = "/acar/estimate_mng/esti_spe_hp_grid_alim_talk.jsp";
		fm.target = "popup_window";
		fm.method = "post";
		fm.submit();
	}
}	
</script>
</head>
<body>
<form action="./esti_spe_hp_grid_big_sc.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<!-- 목록보기 클릭시 전단계 검색조건 유지를 위해 추가 -->
<input type='hidden' name='pre_period_gubun' id="pre_period_gubun" value='<%=period_gubun%>'>
<input type='hidden' name='pre_gubun4'  id="pre_gubun4" value='<%=gubun4%>'>
<input type='hidden' name='pre_s_dt'  id="pre_s_dt" value='<%=s_dt%>'>
<input type='hidden' name='pre_e_dt' id="pre_e_dt" value='<%=e_dt%>'>
<input type='hidden' name='pre_esti_m' id="pre_esti_m" value='<%=esti_m%>'>
<input type='hidden' name='pre_branch' id="pre_branch" value='<%=branch%>'>
<input type='hidden' name='pre_branch' id="pre_bus_user_id" value='<%=bus_user_id%>'>

<div class="navigation" style="margin-bottom:0px !important">
	<span class="style1">영업관리 > 견적관리 > </span><span class="style5">스마트 견적관리</span>
</div>
<div class="search-area" style="margin:0px 10px; float: left;">
    <input type="radio" name="period_gubun" id="gubun_total" value="" checked><label for="gubun_total" >전체</label>
	<input type="radio" name="period_gubun" id="gubun_long" value="1"><label for="gubun_long">신차/재리스(PC/모바일)</label>
	<input type="radio" name="period_gubun" id="gubun_month" value="10"><label for="gubun_month">월렌트(모바일)</label>
	<input type="radio" name="period_gubun" id="gubun_reserve" value="15"><label for="gubun_reserve">친환경차사전예약</label>
	<input type="radio" name="period_gubun" id="gubun_consult" value="20"><label for="gubun_consult">간편상담</label>
	<input type="radio" name="period_gubun" id="gubun_consult_ars" value="99"><label for="gubun_consult_ars">ARS상담신청</label>
	
	<br>
	
	<input type="button" class="button" value="선택 알림톡 발송하기" onclick="kakaoMsgSend();" style="margin-top: 12px;">
	
</div>
<div class="search-area" style="margin:0px 10px; float: left;">
	<div style="float: left; width: 310px; font-size: 12px; font-weight: bold; color: #5f5f5f;">
		<label><i class="fa fa-check-circle"></i> 상세조회 </label>
		<select class="select" name="gubun4" onChange="cng_dt();">
			<option value="">전체</option>
			<option value="4" <%if (gubun4.equals("4")) {%>selected<%}%>>당일</option>
			<option value="5" <%if (gubun4.equals("5")) {%>selected<%}%>>전일</option>
			<option value="1" <%if (gubun4.equals("1")) {%>selected<%}%>>당월</option>
			<option value="2" <%if (gubun4.equals("2")) {%>selected<%}%>>전월</option>
			<option value="3" <%if (gubun4.equals("3")) {%>selected<%}%>>기간</option>
		</select>
		<div id="esti" style="display:<%if (!gubun4.equals("3")) {%>none<%} else {%>''<%}%>">
			<input type="text" name="s_dt" size="11" value="<%=AddUtil.ChangeDate2(s_dt)%>" class="text input" onBlur='javscript:this.value = ChangeDate(this.value);'>
		    ~
		    <input type="text" name="e_dt" size="11" value="<%=AddUtil.ChangeDate2(e_dt)%>" class="text input" onBlur='javscript:this.value = ChangeDate(this.value);'>
	    </div>
	    
	    <br>
	    
	    <!-- 영업지점 -->
	    <label><i class="fa fa-check-circle"></i> 영업지점 </label>
	    <select name="branch" class="select">
	    	<option value="" <%if (branch.equals("")) {%>selected<%}%>>전체</option>		
			<option value="강남" <%if (branch.equals("강남")) {%>selected<%}%>>강남</option>
			<option value="강북" <%if (branch.equals("강북")) {%>selected<%}%>>광화문</option>
			<option value="광주" <%if (branch.equals("광주")) {%>selected<%}%>>광주</option>
			<option value="대구" <%if (branch.equals("대구")) {%>selected<%}%>>대구</option>
			<option value="대전" <%if (branch.equals("대전")) {%>selected<%}%>>대전</option>
			<option value="본사" <%if (branch.equals("본사")) {%>selected<%}%>>본사</option>
			<option value="부산" <%if (branch.equals("부산")) {%>selected<%}%>>부산</option>
			<option value="송파" <%if (branch.equals("송파")) {%>selected<%}%>>송파</option>
			<option value="수원" <%if (branch.equals("수원")) {%>selected<%}%>>수원</option>
			<option value="인천" <%if (branch.equals("인천")) {%>selected<%}%>>인천</option>
		</select>	    
    </div>
    
    <div style="float: left; width: 260px; font-size: 12px; font-weight: bold; color: #5f5f5f;">
	    <label><i class="fa fa-check-circle"></i> 상담여부 </label>
	    <select name="esti_m" onChange='javascript:cng_input()' class="select" style="margin-left: 12px;">
			<option value="" <%if (esti_m.equals("")) {%>selected<%}%>>전체</option>
			<option value="1" <%if (esti_m.equals("1")) {%>selected<%}%>>완료</option>
			<option value="2" <%if (esti_m.equals("2")) {%>selected<%}%>>미상담</option>
		</select>
		
		<br>
		
		<!-- 통화작성자 -->
		<label><i class="fa fa-check-circle"></i> 통화작성자 </label>
		<select name='bus_user_id' class="select">
			<option value="">전체</option>
	<%if (user_size > 0) {%>
		<%for (int i = 0; i < user_size; i++) {
			Hashtable user = (Hashtable)users.elementAt(i);	%>
			<option value='<%=user.get("USER_ID")%>' <%if (bus_user_id.equals(user.get("USER_ID"))) {%>selected<%}%>><%=user.get("USER_NM")%></option>
		<%}%>
	<%}%>
		</select>		
		
		&nbsp;&nbsp;<input type="button" class="button" value="검색" onclick="search();">
	</div>
	
</div>

<!-- table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td width="150px"> 
            <table border=0 cellspacing=1 cellpadding=0 width="100%">
                <tr> 
                    <td>&nbsp;&nbsp;
						<img src=../images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
						<select name="gubun4" onChange='javascript:cng_dt()'>
						<option value="">전체</option>
						<option value="4" <%if(gubun4.equals("4"))%>selected<%%>>당일</option>
						<option value="5" <%if(gubun4.equals("5"))%>selected<%%>>전일</option>
						<option value="1" <%if(gubun4.equals("1"))%>selected<%%>>당월</option>
						<option value="2" <%if(gubun4.equals("2"))%>selected<%%>>전월</option>
						<option value="3" <%if(gubun4.equals("3"))%>selected<%%>>기간</option>
						</select>
					</td>
                    <td id='esti' style="display:<%if(!gubun4.equals("3")){%>none<%}else{%>''<%}%>">
                    	<input type="text" name="s_dt" size="11" value="<%=AddUtil.ChangeDate2(s_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    	~
                    	<input type="text" name="e_dt" size="11" value="<%=AddUtil.ChangeDate2(e_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
			</table>  
		</td>
		<td width="370px">
			<img src=../images/center/arrow_g.gif align=absmiddle>&nbsp;
			<input type="radio" name="period_gubun" id="gubun_total" value="" checked><label for="gubun_total" >전체</label>
			<input type="radio" name="period_gubun" id="gubun_long" value="1"><label for="gubun_long">신차/재리스(PC/모바일)</label>
			<input type="radio" name="period_gubun" id="gubun_month" value="10"><label for="gubun_month">월렌트(모바일)</label>
		</td>
		<td width="140px">
			<img src=../images/center/arrow_sdyb.gif align=absmiddle>&nbsp;
			<select name="esti_m" onChange='javascript:cng_input()'>
				<option value="" <%if(esti_m.equals(""))%>selected<%%>>전체</option>
				<option value="1" <%if(esti_m.equals("1"))%>selected<%%>>완료</option>
				<option value="2" <%if(esti_m.equals("2"))%>selected<%%>>미상담</option>
			</select>
		</td>
		<td width="*">
			<input type="button" class="button" value="검색" onclick="search()">
			 <a id="submitLink" href="javascript:search()" onMouseOver="window.status=''; return true">
					<img src=/acar/images/center/button_search.gif align=absmiddle border=0>
			 </a> 
	     </td> -->
		<!-- <td width="*">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><img src=../images/center/arrow_g.gif align=absmiddle>&nbsp;
						<select name="gubun2">
							<option value="">전체</option>
							<option value="1" <%if(gubun2.equals("1"))%>selected<%%>>장기계약</option>
							<option value="2" <%if(gubun2.equals("2"))%>selected<%%>>월렌트</option>
							<option>------------------</option>
							<option value="5" <%if(gubun2.equals("5"))%>selected<%%>>PC-신차</option>
							<option value="6" <%if(gubun2.equals("6"))%>selected<%%>>PC-재리스</option>
							<option value="7" <%if(gubun2.equals("7"))%>selected<%%>>PC-월렌트</option>
							<option value="8" <%if(gubun2.equals("8"))%>selected<%%>>모바일-신차</option>
							<option value="9" <%if(gubun2.equals("9"))%>selected<%%>>모바일-재리스</option>
							<option value="10" <%if(gubun2.equals("10"))%>selected<%%>>모바일-월렌트</option>
							<option>------------------</option>
							<option value="3" <%if(gubun2.equals("3"))%>selected<%%>>PC용</option>
							<option value="4" <%if(gubun2.equals("4"))%>selected<%%>>모바일용</option>
						</select>&nbsp;&nbsp;
						<a id="submitLink" href="javascript:search()" onMouseOver="window.status=''; return true">
							<img src=/acar/images/center/button_search.gif align=absmiddle border=0>
						</a>
					</td>
				</tr>
			</table>
		</td>
	</tr> 
</table>	 -->
</form>
</body>
</html>

