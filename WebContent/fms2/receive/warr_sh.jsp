<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<script language='javascript' src='/include/common.js'></script>
<script>
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //영업담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //영업소
			fm.t_wd.value = fm.s_brch.options[fm.s_brch.selectedIndex].value;
		}				
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }		
		if(fm.t_wd.value != ''){ //검색창에 검색문구가 있을 경우 기간조회는 전체로변경
			fm.gubun2.options[0].selected =true;
		}
		
		if(fm.gubun2.value == '' && fm.t_wd.value == '' ){
			alert("기간조회가 전체인 경우, 검색조건을 입력하시기바랍니다.");
			return;
		}
		
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	//디스플레이 타입(검색) -검색조건 선택시
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //영업담당자
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
			td_brch.style.display	= 'none';			
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //영업소
			td_input.style.display	= 'none';
			td_bus.style.display	= 'none';			
			td_brch.style.display	= '';						
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
			td_brch.style.display	= 'none';						
		}
	}	
	//디스플레이 타입(검색)-세부조회 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ //연체
			td_dt.style.display	 = 'none';
			td_ec.style.display = '';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //기간
			td_dt.style.display	 = '';
			td_ec.style.display = 'none';
		}else{
			if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //검색
				fm.gubun3.options[0].selected = true;
			}				
			td_dt.style.display	 = 'none';
			td_ec.style.display = 'none';
		}
	}		
			
</script>

</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun0 = request.getParameter("gubun0")==null?"1":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
//	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>

<form name='form1' action='warr_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='gubun3' value='1'> <!--계획 보증보험 가입건  -->
<input type='hidden' name='gubun0' > <!--입금 / 미입금   -->


<div>
	<table width=100% border=0 cellpadding=0 cellspacing=0 class="search-area">
		<tr>
		 <td style="height: 30px" class="navigation">&nbsp;<span class=style1>채권관리 > 보증보험관리 > <span class=style5>가입현황</span></span></td>	
		</tr>
	</table>  
</div>

<div class="search-area" style="font-size:12px;font-weight:bold;color:#5f5f5f;">
	<div style="float:left;">
		<label><i class="fa fa-check-circle"></i> 기간조회 </label>		
		 <select name='gubun0' class="select">
                 <option value="1" <%if(gubun0.equals("1"))%>selected<%%>>해지일자</option>
        </select>	
        &nbsp;	  		
	    <select name="gubun2" onChange="javascript:cng_input1()"  class="select" style="vertical-align: bottom;">
	    	<option value="" <%if(gubun2.equals("")){%>selected<%}%>>전체</option>
	    	<option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>당월</option>
	    	<option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>전월</option>
	     	<option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>기간</option>	    	
	    </select>
    </div>
    <div style="float:left;margin-left:10px;">
	    <div id='td_dt'style="float:left;display:none">
		     <input type='text' class="input"  size='11' name='st_dt' class='text' value='<%=st_dt%>'>
		     	~ 
		     <input type='text' class="input"  size='11' name='end_dt' class='text' value="<%=end_dt%>">
	    </div>
	    
     </div>     
</div>
<br>
<div style="font-size:12px;font-weight:bold;color:#5f5f5f;">
	 <div style="float:left;margin-left:15px;">
     		<label><i class="fa fa-check-circle"></i> 검색조건 </label>	
     	<select name='s_kd' class="select"  onChange="javascript:document.form1.t_wd.value='', cng_input()">			
			<option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
			<option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>고객명</option>
			<option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>계약번호</option>
			<option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차량번호</option>	
			<option value='10' <%if(s_kd.equals("10")){%> selected <%}%>>해지일자</option>	
		</select>		
		<input class="input"  type='text' name='t_wd' size='21' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	    
     </div>
     <div style="float:left;margin-left:130px;">
      	<label><i class="fa fa-check-circle"></i> 정렬조건 </label>		
		<select name='sort_gubun' class="select" onChange='javascript:search()'>
			<option value='0' <%if(sort_gubun.equals("0")){%> selected <%}%>>해지일</option>
			<option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>보증보험입금일</option>
			
			<!-- <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>연체일수</option>-->
		</select>
		
        <input type='radio' style="margin-left:10px;" name='asc' value='0' <%if(asc.equals("0")){%>checked<%}%> onClick='javascript:search()'>
                      오름차순 
        <input type='radio' name='asc' value='1' <%if(asc.equals("1")){%>checked<%}%> onClick='javascript:search()'>
                      내림차순 
     </div>
     
     <div style="float:left;margin-left:150px">
     <input type="button" class="button" value="검색" onclick="javascript:search();"> 
     </div>
</div>

</form>
</body>
</html>