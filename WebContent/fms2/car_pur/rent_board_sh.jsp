<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head><title>FMS</title>
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function search()
	{
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>

<form name='form1' action='/fms2/car_pur/rent_board_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>납품준비상황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>기간</td>
                    <td colspan='3'>&nbsp;
                      	<select name='gubun1'>
                          <option value='' <%if(gubun1.equals("")){%>selected<%}%>>전체(계약일)</option>
                          <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>출고예정일</option>
                          <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>등록예정일</option>
                          <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>납품예정일</option>
                          <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>누적(계약일)</option>
                          <option value='5' <%if(gubun1.equals("5")){%>selected<%}%>>신차등록예정일</option>
                        </select>
                        <select name='gubun2'>
                          <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>당일</option>
                          <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>익일</option>
                          <!--<option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>당월</option>-->
                          <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>기간 </option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
        		    </td>
                  
                </tr>	  
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td width=40%>&nbsp;
            		    <select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>최초영업자</option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>지점 </option>
                          <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>등록지역</option>
                          <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>인수지</option>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>제조사</option>
                          <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>출고점</option>
                          <option value='10' <%if(s_kd.equals("10")){%>selected<%}%>>등록예정일</option>
                          <option value='11' <%if(s_kd.equals("11")){%>selected<%}%>>차명</option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
        			    <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        		    </td>
        		    <td class=title width=10%>정렬조건</td>
                    <td >&nbsp;
            		    <select name='sort'>
            		      <option value=''  <%if(sort.equals("")){%>selected<%}%>>기본 </option>
                          <option value='1' <%if(sort.equals("1")){%>selected<%}%>>용도 </option>
                          <option value='2' <%if(sort.equals("2")){%>selected<%}%>>등록지 </option>
                          <!-- <option value='3' <%if(sort.equals("3")){%>selected<%}%>>인수지 </option> -->
                          <option value='4' <%if(sort.equals("4")){%>selected<%}%>>차량번호 </option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
        			    <input type='radio' name='asc' value='0' <%if(asc.equals("0") || asc.equals("")){%>checked<%}%>>
                      오름차순 
                      <input type='radio' name='asc' value='1' <%if(asc.equals("1")){%>checked<%}%>>
                      내림차순 
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
