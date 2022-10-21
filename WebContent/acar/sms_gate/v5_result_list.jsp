<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String msg = request.getParameter("msg")==null?"":request.getParameter("msg");
	String senddate = request.getParameter("senddate")==null?"":request.getParameter("senddate");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Hashtable ht = umd.getSmsResult_V5(msg, senddate);

	CommonDataBase c_db = CommonDataBase.getInstance();
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>

<body>
<table width="700" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>SMS문자전송결과</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
        <td class="line">
            <table width="700" border="0" cellspacing="1" cellpadding="0">
                <tr><%	String send_name = c_db.getNameById((String)ht.get("SEND_NAME"), "USER");
						if(send_name.equals("")) send_name = (String)ht.get("SEND_NAME"); %>
                    <td class="title" width=12%>발신자</td>
                    <td width=38%>&nbsp;<%= send_name %></td>
                    <td width=12% class="title">회신번호</td>
                    <td width=38%>&nbsp;<%= ht.get("SEND_PHONE") %></td>
                </tr>
                <tr>
                    <td class="title">원본메세지 </td>
                    <td colspan="3">&nbsp;<textarea name="textarea" rows="2" cols="80"><%= msg %></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<br>
<table width="720" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>발송 명단</span></td>
    </tr>
    <tr> 
        <td>
            <table width="700" border="0" cellspacing="0" cellpadding="0">
                <tr><td class=line2></td></tr>
                <tr> 
                    <td class="line">
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td width="30" class="title">연번</td>
                        <td width="80" class="title">수신자명</td>
                        <td width="80" class="title">수신자번호</td>
                        <td width="100" class="title">상태</td>
                        <td width="100" class="title">결과</td>
                        <td width="150" class="title">전달된(될)시간</td>
                        <td width="152" class="title">결과받은시간</td>
                      </tr>
                    </table></td>
                </tr>
      </table></td>
  </tr>
  <tr>
    <td><iframe src="v5_result_list_in.jsp?msg=<%= msg %>&senddate=<%= senddate %>" name="inner" width="720" height="400" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
            </iframe></td>
  </tr>
</table>
</body>
</html>