<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	String s_kd 	= request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

$(document).ready(function(){
	
	parkAreaSetting();
	$('#brid').bind('change', function(){
		parkAreaSetting();
	});
});

//검색하기
	function search(){
		var fm = document.form1;		
		fm.action = 'park_s_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
	
	function search2(){
		var fm = document.form1;		
		fm.action = "park_frame2.jsp";
		fm.target='d_content';
		fm.submit();
	}
	function save2(){
		var fm = document.form1;	
		if(!confirm('마감 하시겠습니까?')){	
			return;	
		}
		fm.action = 'park_condition_save_a.jsp';						
		fm.target = 'i_no';
		fm.submit();	
	}
	
	//영남주차장은 주차장 구역 세분화
	function parkAreaSetting(){
		var area_type1 = "";
		var area_type2 = "";
		area_type1 += '<option value=""selected>전체</option>		<OPTION VALUE="A" >A열 구역</option>' +
					  '<OPTION VALUE="B" >B열 구역</option>		<OPTION VALUE="C" >C열 구역</option>' +
					  '<OPTION VALUE="D" >D열 구역</option>		<OPTION VALUE="E" >E열 구역</option>' +
					  '<OPTION VALUE="F" >F열 구역</option>		<OPTION VALUE="G" >G열 구역</option>' +
					  '<OPTION VALUE="H" >H열 구역</option>';
	    area_type2 += '<option value=""selected>선택</option>		<OPTION VALUE="3A" >3층A구역</option>' +
	  				  '<OPTION VALUE="3B" >3층B구역</option>		<OPTION VALUE="3C" >3층C구역</option>' +
		  			  '<OPTION VALUE="4A" >4층A구역</option>		<OPTION VALUE="4B" >4층B구역</option>' +
					  '<OPTION VALUE="4C" >4층C구역</option>		<OPTION VALUE="5A" >5층A구역</option>' +
					  '<OPTION VALUE="5B" >5층B구역</option>		<OPTION VALUE="5C" >5층C구역</option>' +
					  '<OPTION VALUE="F" >F구역</option>			<OPTION VALUE="G" >G구역</option>' +		
					  '<OPTION VALUE="H" >H구역</option>';
					  
		if($("#brid").val()=="1"){	$("#gubun1").html(area_type2);	}
		else{						$("#gubun1").html(area_type1);	}
		
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
                    <!-- <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 예비차관리 > <span class=style5>주차장현황</span></span></td> -->
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>차량관리 > 보유차관리 > <span class=style5>주차장현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr> 
		<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp; 
			<select name='s_kd'>				
			<option value='1' selected >차량번호</option>
			<option value='4'>차종</option>
			</select>
			
			<input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
			&nbsp;
			<select name='gubun'>				
			<option value='' selected >전체</option>
			<option value='Y'>고객차량</option>
			</select>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jrjg.gif align=absmiddle> &nbsp; 
        <select name='sort_gubun'>
			<option value='5'>구분</option>
			<option value='1'>차량번호</option>
			<option value='4'>차명</option>
			<option value='3'>배기량</option>
			<option value='2'>최초등록일</option>
        </select>
        <select name='asc'>
          <option value="asc">오름차순</option>
          <option value="desc">내림차순</option>
        </select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jj.gif align=absmiddle>
		<select name='brid' id="brid">
			<!-- <option value=""<%if(br_id.equals(""))%>selected<%%>>전체</option> -->
			<option value="1"<%if(brid.equals("1"))%>selected<%%>>본사</option>
			<option value="3"<%if(brid.equals("3"))%>selected<%%>>부산</option>
			<option value="4"<%if(brid.equals("4"))%>selected<%%>>대전</option>
			<option value="5"<%if(brid.equals("5"))%>selected<%%>>광주</option>
			<option value="6"<%if(brid.equals("6"))%>selected<%%>>대구</option>
			<option value="7"<%if(brid.equals("7"))%>selected<%%>>영남외</option>
        </select>
		<%if(brid.equals("1")){%>
		<select name='gubun1' id="gubun1">
			<option value=''>전체</option>
			<option value='A'>A열 구역</option>
			<option value='B'>B열 구역</option>
			<option value='C'>C열 구역</option>
			<option value='D'>D열 구역</option>
			<option value='E'>E열 구역</option>
        </select>
		<%}%>
      &nbsp;<a href="javascript:search(<%=brid%>)" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>
		</td>

	</tr>
    <tr>
    	<td class="h"></td>
	</tr>
</table>
</form> 
</body>
</html>

