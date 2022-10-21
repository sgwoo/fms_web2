<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  

<%@ page import="java.util.*, acar.util.*, acar.car_scrap.*"%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_scrap_sc_in_m_excel.xls");
%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"서울":request.getParameter("gubun");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int count =0;
	
	Vector scrs = sc_db.getScrapList_m(gubun, s_kd, t_wd);
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<form action="" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="seq" value="">
<table border=0 cellspacing=0 cellpadding=0 width=730>
    <tr>		
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>					
                    <td class='line'> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td class=title>연번</td>                                
                                <td class=title>사용본거지</td>
                                <td class=title>구차량번호</td>
                                <td class=title>차명</td>
                                <td class=title>최초등록일</td>
                                <td class=title>최종변경일자</td>
                            </tr>                        
                            <%for(int i =0; i < scrs.size() ; i++){
        				Hashtable scr = (Hashtable)scrs.elementAt(i);%>
                            <tr> 
                                <td align="center" width="30"><%=i+1%></td>            			
                                <td align="center" width="100"><%=scr.get("CAR_EXT_NM")%></td>
                                <td align="center" width="100"><%=scr.get("CAR_NO")%></td>
                                <td align="center" width="300"><%=scr.get("CAR_NM")%></td>
                                <td align="center" width="100"><%=AddUtil.ChangeDate2((String)scr.get("INIT_REG_DT"))%></td>
                                <td align="center" width="100"><%=AddUtil.ChangeDate2((String)scr.get("REG_DT"))%></td>
                            </tr>
                            <% }%>
                        </table>
        		    </td>
        		</tr>
    	    </table>
	    </td>
    </tr>	
</table>
</form>
</body>
</html>
