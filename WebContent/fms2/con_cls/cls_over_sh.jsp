<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
	
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }		
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
				
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin=15>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 해지관리 > <span class=style5>운행거리정산현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./cls_over_sc.jsp" name="form1" method="POST" target="c_body">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
            	<tr>            		
            		<td width=17%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="dt" value="1" > 당월
            			<input type="radio" name="dt" value="2" checked> 당해
            			<input type="radio" name="dt" value="3"> 기간
            		</td>
            		<td width=16%><input type="text" name="st_dt" size="10" value="" class=text> ~ <input type="text" name="end_dt" size="10" value="" class=text></td>
            		
            		  <td width=10%><img src=/acar/images/center/arrow_g.gif align=absmiddle>&nbsp;
                        <select name="gubun2">
                            <option value="" <%if(gubun2.equals(""))%>selected<%%>>전체</option>
                            <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>렌트</option>
                            <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>리스</option>
                        </select></td>
            		
			<td><a href="javascript:search()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
            	</tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>