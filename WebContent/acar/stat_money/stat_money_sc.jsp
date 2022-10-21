<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun = request.getParameter("gubun")==null?"5":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	String s_mon = request.getParameter("s_mon")==null?"60":request.getParameter("s_mon");
	
	int cnt = 3; //검색 라인수
	int sh_height = cnt*sh_line_height;
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function Search(){
		var fm = document.form1;
		if(fm.gubun.value == ''){ alert('구분을 선택하십시오'); return;}
		if(fm.s_yy.value == ''){ alert('기준년을 선택하십시오'); fm.s_yy.focus(); return;}		
		if(fm.s_mm.value == ''){ alert('기준월을 선택하십시오'); fm.s_mm.focus(); return;}
		fm.st_dt.value = fm.s_yy.value+fm.s_mm.value+'01';
		fm.target='i_view';
		fm.action = "stat_money_sc_in_view.jsp";						
		fm.submit();						
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	//중도해지정산 하기
	function view_gh(){
		window.open("about:blank", "VIEW_GH", "left=10, top=10, width=950, height=640, scrollbars=yes, status=yes");
		var fm = document.form1;
		fm.target = "VIEW_GH";
		fm.action = "stat_gh.jsp";				
		fm.submit();		
	}	
	//비율그래프
	function view_gh2(){
		window.open("about:blank", "VIEW_GH", "left=10, top=10, width=950, height=640, scrollbars=yes, status=yes");
		var fm = document.form1;
		fm.target = "VIEW_GH";
		fm.action = "stat_gh2.jsp";				
		fm.submit();		
	}		
	
	//리스트 엑셀 전환
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blank";
	
		fm.action = "popup_excel_money.jsp";
		fm.submit();
	}	

//-->
</script>
</head>
<body>

<form action="stat_money_sc_in_view.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='st_dt' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 재무분석 > <span class=style5>대여료/할부금GAP</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
		<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gjij.gif align=absmiddle>
			<select name="s_yy">
			  <%for(int i=2008; i<=AddUtil.getDate2(1); i++){%>
				<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
				<%}%>
			</select>
	        <select name="s_mm">
	          <%for(int i=1; i<=12; i++){%>
	          <option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=i%>월</option>
	          <%}%>
	        </select>
				<input type="text" name="s_mon" size="4" value="<%=s_mon%>" class=text onKeyDown='javascript:enter()'>개월
		        &nbsp;&nbsp;<a href="javascript:Search();"><img src=../images/center/button_search.gif align=absmiddle border=0></a></td>
		<td align="right">
			<a href="javascript:pop_excel();"><img src=../images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<a href="javascript:view_gh2();"><img src=../images/center/button_graph_p.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<a href="javascript:view_gh();"><img src=../images/center/button_graph.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
	<tR>
	    <td class=h></td>
	</tr>	
	<tr> 
		<td colspan="4"><iframe src="./stat_money_sc_in_view.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&s_mon=<%=s_mon%>" name="i_view" width="100%" height="1000<%//=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>
		</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
</table>
</form>
</body>
</html>
