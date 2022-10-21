<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  	==null?"":request.getParameter("br_id");

	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String s_dt 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 	= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");
	
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		
		if(fm.gubun2[2].checked == true && fm.s_dt.value == '' && fm.e_dt.value == ''){
			alert('기간을 입력하십시오.');  	return;			
		}
		
		fm.action = 'rent_comm_rt_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}	
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function ChangeDT(arg){
		var fm = document.form1;
		if     (arg=="s_dt")		fm.s_dt.value = ChangeDate(fm.s_dt.value);
		else if(arg=="e_dt")		fm.e_dt.value = ChangeDate(fm.e_dt.value);		
	}
//-->
</script>
</head>
<body leftmargin="15">
<form action="./rent_comm_rt_sc.jsp" name="form1" method="POST" target="c_foot">
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > <span class=style5>영업수당수수료현황</span></span></td>
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
            <table border=0 cellspacing=1>
                <tr> 
                    <td>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g.gif align=absmiddle title='구분'>&nbsp;
            		<select name="gubun1">            		    
                            <option value="1" <% if(gubun1.equals("1")) out.print("selected"); %>>계약일자</option>
                            <option value="2" <% if(gubun1.equals("2")) out.print("selected"); %>>출고일자</option>
                            <option value="3" <% if(gubun1.equals("3")) out.print("selected"); %>>대여개시일</option>
            		</select>
            		&nbsp;&nbsp;&nbsp;&nbsp;								
        		<input type="radio" name="gubun2" value="1" <%if(gubun2.equals("1"))%>checked<%%>>
                        당월
                        <input type="radio" name="gubun2" value="2" <%if(gubun2.equals("2"))%>checked<%%>>
                        전월
                        <input type="radio" name="gubun2" value="3" <%if(gubun2.equals("3"))%>checked<%%>>
                        기간
        		&nbsp;&nbsp;
        		<input type="text" name="s_dt" size="11" value="<%=s_dt%>" class="text" onBlur="javascript:ChangeDT('s_dt')">
                        ~ 
                        <input type="text" name="e_dt" size="11" value="<%=e_dt%>" class="text" onBlur="javascript:ChangeDT('e_dt')" onKeydown="javasript:EnterDown()">         			  
        		&nbsp;
        		<a href="javascript:search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>