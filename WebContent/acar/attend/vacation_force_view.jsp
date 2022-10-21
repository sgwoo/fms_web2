<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.attend.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	Hashtable ht = v_db.getVacation(user_id);
	
	Vector vt = v_db.getVacationForceList(user_id, (String)ht.get("YEAR"));
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}
//-->	
</script>
</head>

<body>
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 연차관리 > <span class=style5>미사용연차통보내역</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
 
</table>

<table  width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table  width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width=10%>연번</td>
                    <td class="title" width=20%>통보일자</td>
                    <td class="title" width=12%>요일</td>
                    <td class="title" width=48%>적요</td>
                </tr>
                <% if(vt.size()>0){
        			 for(int i=0; i< vt.size(); i++){
        				Hashtable sch = (Hashtable)vt.elementAt(i);
        			  %>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%= sch.get("START_YEAR") %>-<%= sch.get("START_MON") %>-<%= sch.get("START_DAY") %></td>
                    <td align="center"><%= sch.get("DAY_NM") %></td> 
                    <td align="left">&nbsp;<%= sch.get("CONTENT") %></td>
                </tr>
                <% 	}
        		  }else{ %>
                <tr> 
                    <td colspan="5" align="center">내역이 없습니다.</td>
                </tr>
                <% } %>
            </table>
        </td>
    </tr>
   
</table>
</body>
</html>
