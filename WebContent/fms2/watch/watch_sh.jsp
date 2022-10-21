<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "10", "01", "08");
	
	String chk1 = request.getParameter("chk1")==null?"m":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	int year =AddUtil.getDate2(1);
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		fm.action = "sale_watch_sc.jsp";		
		fm.target = "c_foot";		
		fm.submit();
	}
	
	function FootWin(arg){
		var theForm = document.form1;

		if(arg == 'S'){			theForm.action = "watch_s.jsp";
		}else if(arg == 'JJ'){		theForm.action = "watch_jj.jsp";
		}else if(arg == 'BS'){		theForm.action = "watch_bs.jsp";		
		}else if(arg == 'DJ'){		theForm.action = "watch_dj.jsp";				
		}else if(arg == 'J'){		theForm.action = "watch_j.jsp";
		}else if(arg == 'G'){		theForm.action = "watch_g.jsp";
		}else if(arg == 'S2'){		theForm.action = "watch_s2.jsp";
		}else if(arg == 'I1'){		theForm.action = "watch_i1.jsp";
		}	
		theForm.target = "c_foot";
		theForm.submit();
	}
	
	//엑셀파일 팝업
	function display_pop(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=800px");
		document.form1.action="/fms2/master/select_stat_etc_list1.jsp";
		document.form1.target="Stat";
		document.form1.submit();
	}	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">	
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>당직근무</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align="right"><input type="button" class="button" value="ARS파트너" onclick="javascript:display_pop();"></td>
    </tr>        
</form>
</table>

<div align="center"><!-- 가독성을 높이기 위한 소스 정리 2017-11-08 -->
	<a href="javascript:FootWin('S')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_p_dj_1.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
	<a href="javascript:FootWin('S2')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_p_dj_4.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
	<a href="javascript:FootWin('JJ')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_p_dj_5.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
</div>
</body>
</html>