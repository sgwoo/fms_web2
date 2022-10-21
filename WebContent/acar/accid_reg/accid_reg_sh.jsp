<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");//사고구분
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");//검색조건
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");//검색어
	
	if(!car_no.equals("")){
		s_kd = "2";
		t_wd = car_no;
	}	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.s_gubun1.value == ''){ alert('사고구분을 선택하십시오.'); return; }	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		window.open("about:blank", "SEARCH", "left=100, top=100, width=750, height=500, scrollbars=yes");		
		fm.target = "SEARCH";
		fm.action = "search.jsp";
		fm.submit();					
//		window.open("search.jsp?auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&br_id="+fm.br_id.value+"&s_gubun1="+fm.s_gubun1.value+"&s_kd="+fm.s_kd.value+"&t_wd="+fm.t_wd.value, "SEARCH", "left=100, top=100, width=700, height=300, scrollbars=yes");		
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//하단 디스플레이
	function cng_display(){
		var fm = document.form1;		
		if(parent.c_foot.document.form1 == null){
			return;
		}
		var fm2 = parent.c_foot.document.form1;		
		if(fm.t_wd.value == ''){ fm.t_wd.focus(); return; }
		if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '1'){
			parent.c_foot.tr1.style.display = '';
			fm2.our_fault_per.value = 0;
			fm2.ot_fault_per.value = 100;
			fm2.dam_type1.checked = false;
			fm2.dam_type2.checked = false;
			fm2.dam_type3.checked = true;
			fm2.dam_type4.checked = true;									
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '2'){
			parent.c_foot.tr1.style.display = '';
			fm2.our_fault_per.value = 100;
			fm2.ot_fault_per.value = 0;
			fm2.dam_type1.checked = true;
			fm2.dam_type2.checked = true;
			fm2.dam_type3.checked = false;
			fm2.dam_type4.checked = false;			
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '3'){
			parent.c_foot.tr1.style.display = '';
			fm2.our_fault_per.value = 0;
			fm2.ot_fault_per.value = 0;		
			fm2.dam_type1.checked = true;
			fm2.dam_type2.checked = true;
			fm2.dam_type3.checked = true;
			fm2.dam_type4.checked = true;							
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '4' || fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '7'){
			parent.c_foot.tr1.style.display = 'none';
			fm2.our_fault_per.value = 0;
			fm2.ot_fault_per.value = 0;	
			fm2.dam_type1.checked = false;
			fm2.dam_type2.checked = false;
			fm2.dam_type3.checked = true;
			fm2.dam_type4.checked = true;													
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '5' || fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '6'){
			parent.c_foot.tr1.style.display = '';
			fm2.our_fault_per.value = 0;
			fm2.ot_fault_per.value = 0;				
			fm2.dam_type1.checked = false;
			fm2.dam_type2.checked = false;
			fm2.dam_type3.checked = true;
			fm2.dam_type4.checked = true;													
		}
	}	
-->
</script>
</head>

<body>
<form name='form1' method='post'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="rent_st" value='<%=rent_st%>'>
<input type='hidden' name="car_no" value='<%=car_no%>'>
<input type='hidden' name="gubun" value='<%=gubun%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  		<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험 > 사고관리 > <span class=style5>
						사고등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  

    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_sgyh.gif  align=absmiddle>&nbsp; 
        <select name='s_gubun1' onChange='javascript:cng_display()'>
          <option value=""> ===선택=== </option>
          <option value="1" <%if(s_gubun1.equals("1"))%>selected<%%>>피해</option>
          <option value="2" <%if(s_gubun1.equals("2"))%>selected<%%>>가해</option>
          <option value="3" <%if(s_gubun1.equals("3"))%>selected<%%>>쌍방</option>
   <!--       <option value="5" <%if(s_gubun1.equals("5"))%>selected<%%>>사고자차</option>
          <option value="4" <%if(s_gubun1.equals("4"))%>selected<%%>>운행자차</option>      
          <option value="7" <%if(s_gubun1.equals("7"))%>selected<%%>>재리스정비</option>		-->  
           <option value="8" <%if(s_gubun1.equals("8"))%>selected<%%>>단독</option>		  
          <option value="6" <%if(s_gubun1.equals("6"))%>selected<%%>>수해</option>
         
        </select>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif  align=absmiddle>&nbsp;  
        <select name='s_kd'>
          <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
          <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
        </select>&nbsp;
        <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()">
        &nbsp;<a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a> 
      </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>