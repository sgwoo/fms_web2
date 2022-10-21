<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
		
	
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");	
	FineGovBn = FineDocDb.getFineGov(gov_id);
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>수신처정보</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=15%>기관명</td>
                    <td width=35%>&nbsp;<%=FineGovBn.getGov_nm()%></td>
                    <td class='title' width=15%>참조</td>
                    <td width=35%>&nbsp;<%=FineGovBn.getMng_dept()%></td>
                </tr>
                <tr> 
                    <td class='title'>담당자명</td>
                    <td>&nbsp;<%=FineGovBn.getMng_nm()%></td>
                    <td class='title'>직급</td>
                    <td>&nbsp;<%=FineGovBn.getMng_pos()%></td>
                </tr>		  
                <tr> 
                    <td class='title'>연락처</td>
                    <td>&nbsp;<%=FineGovBn.getTel()%></td>
                    <td class='title'>팩스</td>
                    <td>&nbsp;<%=FineGovBn.getFax()%></td>
                </tr>
                <tr> 
                    <td class='title'>주소</td>
                    <td colspan="3">&nbsp;(<%=FineGovBn.getZip()%>) <%=FineGovBn.getAddr()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td align="right" ><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>	    
    </tr>
</table>
</form>
</body>
</html>
