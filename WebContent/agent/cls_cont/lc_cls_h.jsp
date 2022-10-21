<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>

<%

	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		fm.go_target.value = "c_foot";
	
		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=yes,resizable=yes,width=850,height=600,left=50,top=50');		
		fm.action = "/agent/tax/pop_search/s_cont.jsp";		
		fm.target = "search_open";
		fm.submit();		
	}
	function Search(){
		var fm = document.form1;

		fm.action="lc_cls_c.jsp";
		fm.target="c_foot";		
		fm.submit();
	}	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.t_wd.focus();">
<form  name="form1" method='post'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type="hidden" name="go_url" value="/agent/cls_cont/lc_cls_c.jsp">      
  <input type="hidden" name="type" value="search">  
  <input type="hidden" name="go_target" value="">            
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 해지관리 > <span class=style5>대여개시전해지 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
 
    <tr> 
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp;
      <select name="s_kd">
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
      </select>
	  &nbsp;<input type="text" name="t_wd" size="20" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()" style='IME-MODE: active'>
	  &nbsp;<a href="javascript:SearchopenBrWindow();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
      </td>      
    </tr>
  </table>
</form>
</body>
</html>
