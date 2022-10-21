<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	CarCompBean cc_r [] = umd.getCarCompAll();
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
		fm.action = "car_office_stat_sc1.jsp";	
		fm.action = "car_office_stat_sc.jsp";	
		fm.target = "c_foot";
		fm.submit();
	}
	//시/구/군 조회
	function cng_sido(){
		var fm = document.form1;
		fm.action = "../fine_gov/get_gugun.jsp";
		fm.target = "i_no";
		fm.submit();	
	}	
	//현황
	function SearchCarOffStat(){
		var fm = document.form1;
		fm.gubun1.value = '';
		fm.gubun2.value = '';		
		fm.action = "car_office_frame.jsp";	
		fm.target = "d_content";
		fm.submit();
	}

//-->
</script>
</head>
<body>
<form action="./car_office_sc.jsp" name="form1" method="POST" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > <span class=style5>영업소현황</span></span></td>
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
            <table width="100%" border=0 cellpadding=0 cellspacing=0>
            	<tr>
            		<td width=22%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jdchs.gif align=absmiddle>&nbsp;
            		  <select name="gubun3">
                        <option value="">전체
                        <%
    for(int i=0; i<cc_r.length; i++){
        cc_bean = cc_r[i];
        if(cc_bean.getNm().equals("에이전트")) continue;
%>
                        <option value="<%= cc_bean.getCode() %>" <% if(gubun3.equals(cc_bean.getCode())) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                        <%}%>
                      </select></td>
           		  <td width=22%><img src=/acar/images/center/arrow_jy.gif align=absmiddle>&nbsp;
                      <select name="gubun1">
                        <option value="">전체</option>
                        <option value="서울" <%if(gubun1.equals("서울")){%>selected<%}%>>서울</option>
                        <option value="경기" <%if(gubun1.equals("경기")){%>selected<%}%>>경기</option>
                        <option value="인천" <%if(gubun1.equals("인천")){%>selected<%}%>>인천</option>																		
                        <option value="기타" <%if(gubun1.equals("기타") || (!gubun1.equals("") && !gubun1.equals("서울") && !gubun1.equals("경기") && !gubun1.equals("인천"))){%>selected<%}%>>기타</option>																								
                      </select>
					&nbsp;<a href="javascript:SearchCarOff()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a> </td>
            		<td align=right>
					<a href="javascript:SearchCarOffStat();"><img src="/acar/images/center/button_jdcgl.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;
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
