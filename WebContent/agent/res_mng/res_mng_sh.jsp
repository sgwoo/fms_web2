<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>

<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	
	String s_kd 	= request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.gubun1[1].checked == false && fm.t_wd.value == '' && fm.s_kd.value != '10'){ alert('검색어를 입력하십시오.'); return;}		
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'res_mng_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 계출관리 > <span class=style5>출고지연대차현황</span></span></td>
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
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td width=30%>&nbsp;
            		<select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='13' <%if(s_kd.equals("13")){%>selected<%}%>>대표자 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>신차차량번호 </option>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>대차차량번호 </option>                          
                          <option value='14' <%if(s_kd.equals("14")){%>selected<%}%>>계약일자</option>			  
			  <option value='15' <%if(s_kd.equals("15")){%>selected<%}%>>대여개시일자</option>			  
                        </select>
        			    &nbsp;
        			    <input type='text' name='t_wd' size='18' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        		    </td>
                    <td class=title width=10%>구분</td>
                    <td width=20%>&nbsp;
            		<select name='gubun1'>
                          <option value=''  <%if(gubun1.equals("")){ %>selected<%}%>>전체 </option>
                          <option value='Y' <%if(gubun1.equals("Y")){%>selected<%}%>>진행 </option>
                          <option value='N' <%if(gubun1.equals("N")){%>selected<%}%>>해지 </option>
                        </select>&nbsp;
            		<select name='gubun3'>
                          <option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>전체 </option>
                          <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>대차중</option>
                          <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>신차개시</option>
                        </select>
        			</td>		  		  
                    <td class=title width=10%>청구여부</td>
                    <td width=20%>&nbsp;
            		    <select name='gubun2'>
                          <option value=''  <%if(gubun2.equals("")){ %>selected<%}%>>전체 </option>
                          <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>청구</option>
                          <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>무상대차</option>
                        </select></td>		  		  
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td><a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></td>
    </tr>
</form> 
</table>
</body>
</html>

