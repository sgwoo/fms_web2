<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	
	if(!gubun4.equals("3")){
		s_dt = "";
		e_dt = "";
	}
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function search(){
		var fm = document.form1;
		
		if(fm.gubun4.value == '3' && (fm.s_dt.value == '' || fm.e_dt.value == '')){
			alert('기간을 입력하십시오.'); 
			return;
		}		
		
		fm.action = "esti_cu_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	

	//디스플레이 타입
	function cng_dt(){
		var fm = document.form1;
		if(fm.gubun4.options[fm.gubun4.selectedIndex].value == '3'){ //기간
			esti.style.display 	= 'inline';
		}else{
			esti.style.display 	= 'none';
		}
	}
	
//-->
</script>
</head>
<body>
<form action="./esti_cu_sc.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<div class="navigation" style="margin-bottom:0px !important">
	영업관리 > 견적관리 > <span class="style5">고객견적서관리</span>
</div>
<div class="search-area">
	<label><i class="fa fa-check-circle"></i>  견적구분</label>&nbsp;
    <select name="gubun1" class="select">
    	<option value="" <%if(gubun1.equals(""))%> selected <%%>>전체</option>
        <option value="S" <%if(gubun1.equals("S"))%>selected<%%>>재리스</option>
        <option value="F" <%if(gubun1.equals("F"))%>selected<%%>>신차</option>                            
    </select> 
    &nbsp;&nbsp;
    <label><i class="fa fa-check-circle"></i>  대여구분</label>
    <select name="gubun2" class="select">
       <option value="">전체</option>
       <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>리스</option>
       <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>장기렌트</option>
    </select> 
    &nbsp;&nbsp;
    <label><i class="fa fa-check-circle"></i>  견적일자</label>
    <select name="gubun4" onChange='javascript:cng_dt()' class="select">
        <option value="4" <%if(gubun4.equals("4"))%>selected<%%>>전월</option>
        <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>당월</option>
        <option value="5" <%if(gubun4.equals("5"))%>selected<%%>>전일</option>
        <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>당일</option>
        <option value="3" <%if(gubun4.equals("3"))%>selected<%%>>기간</option>
    </select>
    <div id='esti' style="display:<%if(!gubun4.equals("3")){%>none<%}else{%>'inline'<%}%>">
   		<input type="text" name="s_dt" size="11" class="input" value="<%=AddUtil.ChangeDate2(s_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
    	~ 
    	<input type="text" name="e_dt" size="11" class="input" value="<%=AddUtil.ChangeDate2(e_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
	</div>
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i>  검색항목</label>
	<select name="s_kd" class="select">
	   <option>선택</option>
	   <option value="1" <%if(s_kd.equals("1"))%>selected<%%>>차종</option> 
	   <option value="2" <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option> 
	   <option value="8" <%if(s_kd.equals("8"))%>selected<%%>>이메일주소</option> 
	</select>
	<input type="text" name="t_wd" size="20" value="<%=t_wd%>" class="input" onKeyDown="javasript:EnterDown()" />
	<a href="javascript:search()" onMouseOver="window.status=''; return true">
	<input type="button" class="button" value="검색" onclick="search()"></a>			
</div>

</form>
</body>
</html>

