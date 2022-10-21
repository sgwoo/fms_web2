<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src='/include/common.js'></script>
</head>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
%>
<body leftmargin="15">
<form action="bank_lend_i_a.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type="hidden" name="lend_id" value="<%=lend_id%>">
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 구매자금관리 > 은행대출관리 ><span class=style5>대출<%if(lend_id.equals("")){%>등록<%}else{%>수정<%}%></span></span></td>
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
			<table border="0" cellspacing="1" width=100%>
				<tr>
			    	<td align='right'>
					<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){
						if(lend_id.equals("")){%>
			    		<a href='javascript:parent.r_body.save();'><img src=/acar/images/center/button_write.gif border=0 align=absmiddle></a>&nbsp;
					<%	}else{%>
						<a href='javascript:parent.r_body.modify();'><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
					<%	}
					  }%>
			    		<a href='javascript:parent.r_body.go_to_list();'><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a>
			    	</td>
			    </tr>
			</table>
		</td>
    </tr>
</table>
</body>
</html>