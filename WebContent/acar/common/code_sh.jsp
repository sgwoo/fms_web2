<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String c_st 		= request.getParameter("c_st")==null?"":request.getParameter("c_st");


	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector CodeList = c_db.getCodeList();	/* 코드 master 조회 */
	int code_size = CodeList.size();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function search()
	{
		document.form1.submit();
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
</head>

<body>
<form name='form1' action='/acar/common/code_sc.jsp' method='post' target='c_body'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>코드관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_glcd.gif align=absmiddle>&nbsp;&nbsp;
    	  <select name='c_st' onChange='javascript:search()' <%if(from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>disabled<%}%>>
			<option value=''>선택</option>
						
                <%	if(code_size > 0){
						for(int i = 0 ; i < code_size ; i++){
							Hashtable code = (Hashtable)CodeList.elementAt(i);	
							if(String.valueOf(code.get("C_ST")).equals("0003")) continue;							
							%>
                <option value='<%=code.get("C_ST")%>' <%if(c_st.equals(String.valueOf(code.get("C_ST")))){%>selected<%}%>> <%= code.get("NM_CD")%> </option>
                <%		}
					}			%>
          </select>
          	<%if(!from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
    		  <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
    		<%}%>
    	</td>
    </tr>
</table>
</form>
</body>
</html>