<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_start_dt = request.getParameter("s_start_dt")==null?"":request.getParameter("s_start_dt");	
	String s_gubun = request.getParameter("s_gubun")==null?"":request.getParameter("s_gubun");
	String s_mng_who = request.getParameter("s_mng_who")==null?"":request.getParameter("s_mng_who");	
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();	
	
	CodeBean[] depts = c_db.getCodeAll2("0002", "Y"); /* 코드 구분:부서명 */	
	int dept_size = depts.length;
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.target = "c_foot";
		fm.submit();
	}
	
	function OpenList(c_st){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var user_id = fm.user_id.value;
		var br_id = fm.br_id.value;
		var s_br_id = fm.s_br_id.value;						
		var s_dept_id = fm.s_dept_id.value;		
		var SUBWIN = "s_code_i.jsp";
		window.open(SUBWIN+"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&s_br_id="+s_br_id+"&s_dept_id="+s_dept_id+"&c_st="+c_st, "OpenList", "left=100, top=100, width=550, height=410, scrollbars=no");
	}
//-->
</script>
</head>
<body>
<form action="./add_mark_s_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 코드관리 > <span class=style5>가산점 관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	  <td>			
        <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <tr> 
            <td width="180">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_yus.gif align=absmiddle>&nbsp;  
              <select name='s_br_id'>
                <option value=''>전체</option>
                <%if(brch_size > 0){
					for (int i = 0 ; i < brch_size ; i++){
						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                <option value='<%= branch.get("BR_ID") %>'  <%if(s_br_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
                <%= branch.get("BR_NM")%> </option>
                <%	}
				}%>
              </select>
            </td>
            <td width="130"><img src=../images/center/arrow_bs.gif align=absmiddle>&nbsp; 
              <select name='s_dept_id'>
                <option value=''>전체</option>
                <%if(dept_size > 0){
					for(int i = 0 ; i < dept_size ; i++){
						CodeBean dept = depts[i];%>
                <option value='<%= dept.getCode()%>' <%if(s_dept_id.equals(dept.getCode())){%>selected<%}%>> 
                <%= dept.getNm()%> </option>
                <%	}
				}%>
              </select>
            </td>
            <td width="60"><a href="javascript:Search()"><img src=../images/center/button_search.gif border=0 align=absmiddle</a></td>
            <td align="right"><a href="javascript:OpenList('0002')"><img src=../images/center/button_bsgl.gif align=absmiddle border=0></a> <a href="javascript:OpenList('0005')"><img src=../images/center/button_dybsgl.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;</td>
            <td width=20>&nbsp;</td>
          </tr>
        </table>			
	  </td>
	</tr>
  </table>
</form>
</body>
</html>