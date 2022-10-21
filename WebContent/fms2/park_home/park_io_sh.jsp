<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	String park_id 	= request.getParameter("park_id")==null?"1":request.getParameter("park_id");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_dt 	= request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt		= request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	
	String s_kd 	= request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//주차장 정보
	CodeBean[] goods = c_db.getCodeAll("0027");
	int goods_size = goods.length;
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
	#input_period{	display:none; position: relative; float: left; margin-left: 30px;	}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
$(document).ready(function(){
	
	//초기 검색조건 폼 세팅
	change_sch_form();
	
	//검색조건에 따른 폼 변경
	$("#gubun2").on("change", function(){
		change_sch_form();
	});
});	

//검색하기
function search(){
	var fm = document.form1;		
	fm.action = 'park_io_sc.jsp';
	fm.target='c_foot';
	fm.submit();
}

function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}

function change_sch_form(){
	var selGubun2 = $("#gubun2 option:selected").val();
	if(selGubun2=="4"){	$("#input_period").css("display","block");	}
	else{				$("#input_period").css("display","none");	}
}
//-->
</script>
</head>
<body leftmargin="15" >
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>차량관리 > 보유차관리 > <span class=style5>주차장 입/출고 현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr> 
		<td colspan="2">
			<span  style="float: left;">	
				&nbsp;&nbsp;&nbsp;&nbsp;
				<label><i class="fa fa-check-circle"></i><b>&nbsp;&nbsp;주차장&nbsp;&nbsp;</b></label>
				<select name='park_id' id="park_id">
				<option value=""<%if(park_id.equals(""))%>selected<%%>>전체</option>
				<%-- 
				
					<!-- <option value=""<%if(park_id.equals(""))%>selected<%%>>전체</option> -->
					<option value="1"<%if(park_id.equals("1"))%>selected<%%>>영남주차장</option>
					<option value="8"<%if(park_id.equals("8"))%>selected<%%>>부산조양</option>
					<option value="7"<%if(park_id.equals("7"))%>selected<%%>>부산부경</option>
				<!--	<option value="17"<%if(park_id.equals("17"))%>selected<%%>>웰메이드</option> -->
					<option value="4"<%if(park_id.equals("4"))%>selected<%%>>대전지점</option>
					<option value="9"<%if(park_id.equals("9"))%>selected<%%>>대전현대</option>
					<option value="12"<%if(park_id.equals("12"))%>selected<%%>>광주지점</option>
					<option value="13"<%if(park_id.equals("13"))%>selected<%%>>대구지점</option>
					--%>
									
				<%for(int i = 0 ; i < goods_size ; i++){
					CodeBean good = goods[i];
					if(good.getUse_yn().equals("Y")){
						if(park_id.equals(good.getNm_cd())){
						%>
							<option value='<%= good.getNm_cd()%>' selected><%= good.getNm()%></option>
						<%
						}else{
						%>
							<option value='<%= good.getNm_cd()%>'><%= good.getNm()%></option>
						<%
						}
					%>
				<%}}%>
										
		        </select>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<label><i class="fa fa-check-circle"></i><b>&nbsp;&nbsp;검색항목&nbsp;&nbsp;</b></label> 
				<select name='gubun1'>				
					<option value='1' selected >차량번호</option>
					<option value='2'>차종</option>
				</select>
				<input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<label><i class="fa fa-check-circle"></i><b>&nbsp;&nbsp;입/출고&nbsp;&nbsp;</b></label> 
				<select name='io_gubun' id="io_gubun">				
					<option value=''>전체</option>
					<option value='1'>입고</option>
					<option value='2'>출고</option>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<label><i class="fa fa-check-circle"></i><b>&nbsp;&nbsp;기간&nbsp;&nbsp;</b></label> 
				<select name='gubun2' id="gubun2">				
					<option value='1'>당일</option>
					<option value='2'>전일</option>
					<option value='3'>당월</option>
					<option value='4'>기간</option>
				</select>
			</span>
			<span id="input_period" style="display: none;">
				<input type='text' name='s_dt' size='16' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>&nbsp;~&nbsp;
				<input type='text' name='e_dt' size='16' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
			</span>
		    &nbsp;&nbsp;&nbsp;&nbsp;
		    <a href="javascript:search()" onMouseOver="window.status=''; return true" onFocus="this.blur()" style="position: relative;"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>
		</td>
	</tr>
    <tr>
    	<td class="h"></td>
	</tr>
</table>
</form> 
</body>
</html>

