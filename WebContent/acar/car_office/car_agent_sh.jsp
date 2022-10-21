<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2").equals("")?"Y":request.getParameter("gubun2");
	String gubun3	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function EnterDown() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchCarOff();
	}
	function SearchCarOff(){
		var fm = document.form1;
		if(fm.s_kd.value == '' && fm.t_wd.value != '') fm.s_kd.value = 'car_off_nm';
		fm.action = "car_agent_sc.jsp";	
		fm.target = "c_foot";
		fm.submit();
	}
	
	//영업소등록
	function office_reg(){
		var fm = document.form1;
		fm.action = "car_agent_i.jsp";	
		fm.target = "d_content";
		fm.submit();					
	}
//-->
</script>
</head>
<body>
<form action="./car_agent_sc.jsp" name="form1" method="POST" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > <span class=style5>에이전트관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>   
    <tr> 
         <td> 
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_lcs.gif align=absmiddle>&nbsp;
                      <input type="radio" name="gubun1" value="" <% if(gubun1.equals("")) out.print("checked"); %>>
                      전체 
                      <input type="radio" name="gubun1" value="3" <% if(gubun1.equals("1")) out.print("checked"); %>>
                      법인
                      <input type="radio" name="gubun1" value="4" <% if(gubun1.equals("2")) out.print("checked"); %>>
                      개인 </td>      
                      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_deal.gif align=absmiddle>&nbsp;
                      <input type="radio" name="gubun2" value="all" <% if(gubun2.equals("all")) out.print("checked"); %>>
                      전체 
                      <input type="radio" name="gubun2" value="Y" <% if(gubun2.equals("Y")) out.print("checked"); %>>
                      거래                     
					 					 <input type="radio" name="gubun2" value="N" <% if(gubun2.equals("N")) out.print("checked"); %>>
                      미거래 
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      [업무구분]
                      <input type="radio" name="gubun3" value="" <% if(gubun3.equals("")) out.print("checked"); %>>
                      전체 
                      <input type="radio" name="gubun3" value="C" <% if(gubun3.equals("C")) out.print("checked"); %>>
                      견적,계약 모두
					 					 <input type="radio" name="gubun3" value="E" <% if(gubun3.equals("E")) out.print("checked"); %>>
                      견적만                      
                      </td>              
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;&nbsp;&nbsp;
                      <select name="s_kd">                        
                        <option value="car_off_nm" <% if(s_kd.equals("car_off_nm")) out.print("selected"); %>>상호/성명</option>                        
                      </select> 
		      <input type="text" name="t_wd" size="20" value="<%= t_wd %>" class=text onKeydown="javasript:EnterDown()"> 
                      <a href="javascript:SearchCarOff()" onMouseOver="window.status=''; return true" title='검색하기'><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
                    <td align="right">
        		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	        			  
                        <a href="javascript:office_reg();" onMouseOver="window.status=''; return true" title='영업소등록'><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
        		<%}%>                       
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
