<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	 
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function search()
	{
	   	var fm = document.form1;	   	 
	   	if (fm.gubun1[0].checked == true || fm.gubun1[2].checked == true) {	     	     
		     	if (fm.t_wd.value == '') {	alert("검색조건을 입력하셔야 합니다.");	return;	}
		} 	
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>

<form name='form1' action='/fms2/insure/ins_doc_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>전자문서 > <span class=style5>보험변경문서관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td width=40%>&nbsp;
            		<select name='s_kd'>
                            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
                            <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
			    <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>차명</option>
			    <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>기안자</option>
			    <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>기안일자</option>			    
			    <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>등록일자</option>
                        </select>
        		&nbsp;&nbsp;&nbsp;
        		<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        	    </td>
                    <td class=title width=10%>구분</td>
                    <td width=40%>&nbsp;
            		<select name='gubun2'>
                            <option value=''  <%if(gubun2.equals("")){%>selected<%}%>>전체 </option>
                            <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>반영 </option>
                            <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>견적 </option>
                        </select>                    
            		<input type="radio" name="gubun1" value=""  <%if(gubun1.equals(""))%>checked<%%>>
            		전체
            		<input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>
            		미결
            		<input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>
            		결재완료
        	    </td>		  		  
                </tr>
            </table>
        </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>
