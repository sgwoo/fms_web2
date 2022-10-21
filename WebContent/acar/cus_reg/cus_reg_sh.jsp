<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mdata = request.getParameter("mdata")==null?"":request.getParameter("mdata");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	if(!car_no.equals("")){
	t_wd = car_no;
	}
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	LoginBean login = LoginBean.getInstance();
	String dept_id = login.getDept_id(ck_acar_id);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') cng_display();
	}
	
	//검색하기
	function cng_display(){
		var fm = document.form1;
		var url = '';
		<%if(dept_id.equals("8888")){%>
			if(fm.t_wd.value==""){	alert("차량번호를 입력해 주세요!"); fm.t_wd.focus(); return; }
			url = 'cr_c_service.jsp';
		<%}else{%>
		if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '1'){
			if(fm.t_wd.value==""){	alert("상호명을 입력해 주세요!"); fm.t_wd.focus();	return; }
			url = 'cr_c_visit.jsp';
			fm.s_kd[0].selected = true;									
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '2'){
			if(fm.t_wd.value==""){	alert("차량번호를 입력해 주세요!"); fm.t_wd.focus(); return; }
			url = 'cr_c_service.jsp';
			fm.s_kd[1].selected = true;																					
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '3'){
			if(fm.t_wd.value==""){	alert("차량번호를 입력해 주세요!"); fm.t_wd.focus(); return; }
			url = 'cr_c_maint.jsp';
			fm.s_kd[1].selected = true;																								
		}else{
			url = 'cr_c.jsp';
		}	
		<%}%>
		fm.action =  url;		
		fm.target = 'i_no';	
		fm.submit();
	}
	
	//디스플레이 타입
	function cng_display3(){
		var fm = document.form1;
		if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '1'){						
			fm.s_kd[0].selected = true;
			//fm.t_wd.value = "";									
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '2'){
			fm.s_kd[1].selected = true;	
			//fm.t_wd.value = "";			
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '3'){
			fm.s_kd[1].selected = true;	
			//fm.t_wd.value = "";			
		}else{
		}
	}
	
-->
</script>

</head>

<body onLoad="document.form1.t_wd.focus();">
<form name='form1' method='post' action=''>
 <input type='hidden' name='sh_height' value='<%=sh_height%>'>
 <input type='hidden' name='mdata' value='<%=mdata%>'>
  <table width="100%" border="0" cellspacing="1" cellpadding="0">
  		<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 >  <span class=style5>업무등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td width=18%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_um.gif align=absmiddle>&nbsp; 
            <select name='s_gubun1' onChange='javascript:cng_display3()'>
    		<%if(dept_id.equals("8888")){%>
              <option value="2">자동차정비</option>
    		<%}else{%>
              <option value="1" <% if(s_gubun1.equals("1")) out.print("selected");%>> 
              고객방문 </option>
              <option value="2" <% if(s_gubun1.equals("2")) out.print("selected");%>> 자동차정비</option>		  
              <option value="3" <% if(s_gubun1.equals("3")) out.print("selected");%>> 
              운행차검사 </option>
    		<%}%>
            </select></td>
        <td width=11%><img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp; 
            <select name='s_kd'>
    		<%if(dept_id.equals("8888")){%>
              <option value='2' <% if(s_kd.equals("2")) out.print("selected");%>>차량번호</option>
    		<%}else{%>
              <option value='1' <% if(s_kd.equals("1")) out.print("selected");%>>상호</option>
              <option value='2' <% if(s_kd.equals("2")) out.print("selected");%>>차량번호</option>
    		<%}%>
            </select>
        </td>
        <td width=10% valign="middle"><input type="text" name="t_wd" size="25" class=text value="<%= t_wd %>" onKeyDown="javascript:enter()" style='IME-MODE: active'></td>
        <td><a href='javascript:cng_display()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</html>
<script language="JavaScript">
<% if(!t_wd.equals("")){ %>
	cng_display();
<% } %>
</script>
