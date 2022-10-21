<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='javascript'>
<!--
	function select(cust_id, firm_nm, cust_nm, m_tel){		
		var fm = document.form1;
		var ofm = opener.document.form1;
		ofm.client_id.value = cust_id;
		ofm.firm_nm.value 	= firm_nm;
		ofm.destname.value 	= cust_nm;				
		ofm.destphone.value 	= m_tel;
		ofm.key_name.value 	= cust_nm;				
		self.close();			
	}
	
	function search(){
		var fm = document.form1;
		fm.action='search_client_in.jsp';
		fm.target='inner';
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
</head>

<body onLoad="javascript:document.form1.t_wd.focus();">
<center>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>SMS > <span class=style5>고객 조회</span></span></td>
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
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td align='left' width="80%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp; 
                        <select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                          <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>성명</option>
                          <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>생년월일/사업자번호</option>
                        </select>
                        <input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                        <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
                    </td>
                    <td align='right' width="20%">
    			    </td>
                </tr>
            </table>
	    </td>
	    <td width=17></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='5%' class='title'>연번</td>
                    <td class='title' width="35%">상호</td>
                    <td class='title' width='20%'>대표자</td>
                    <td class='title' width='20%' style='height:38'>생년월일/사업자번호</td>
                    <td class='title' width='20%'>핸드폰번호</td>
                </tr>
            </table>
	    </td>
	    <td width='17'></td>
	</tr>
	<tr>
	    <td colspan='2'>
		    <iframe src="search_client_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="inner" width="100%" height="340" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	    </td>
	</tr>
</table>
</form>
</center>
</body>
</html>