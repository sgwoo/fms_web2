<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='/fms2/condition/auc_s1_sc.jsp' target='c_body'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>경매출품실적현황</span></span></td>
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
            <table border='0' cellspacing='1' cellpadding='0' width='100%'>
            	<tr>
            		<td width="365">
            		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgg.gif align=absmiddle>&nbsp;
        			 <select name='dt'>
        			 	<option value='actn_dt' selected >출품일</option>
        		<!--	   	<option value='jan_pr_dt'>경매일</option> -->
        			 	<option value='ip_est_dt'>입금예정일</option>
           			 </select>&nbsp;
           			 <select name='s_year'>	          					  				  
	          			<%for(int i=2011; i<=AddUtil.getDate2(1); i++){%>
	          			<option value="<%=i%>" <%if(i == AddUtil.parseInt(s_year)){%> selected <%}%>><%=i%>년도</option>
	          			<%}%>				  
	    		     </select>
	    		
	    		     </td> 
            		<td width=350>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
            			<select name='s_kd'>
            				<option value='0'>전체</option>
            				<option value='1'>경매횟차</option>
            				<option value='5'>관리지점</option>
            			</select>
						<input type='text' name='t_wd' size='15' class='text' value='' onKeyDown='javascript:enter()'>
						 &nbsp;<a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
					</td>
					<td>&nbsp;</td>
						
				</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>