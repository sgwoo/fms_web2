<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp"%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function search()
	{
		document.form1.submit();
	}
//-->
</script>
</head>
<%
	String s_sys = Util.getDate();
	String s_year = s_sys.substring(0,4);
	String s_mon = s_sys.substring(5,7);
	String s_day = s_sys.substring(8,10);
	String auth_rw = request.getParameter("auth_rw")==null ? "" : request.getParameter("auth_rw");
%>
<body>
<form name='form1' action='/acar/day_sche/day_sche_s_sc.jsp' method='post' target='c_body'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > <span class=style5>일일스케쥴</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gg.gif" align=absmiddle>&nbsp;	 
    	    <select name='s_year'>
    			<option value='2002' <%if(s_year.equals("2002")){%>selected<%}%>>2002</option>
    			<option value='2003' <%if(s_year.equals("2003")){%>selected<%}%>>2003</option>
    			<option value='2004' <%if(s_year.equals("2004")){%>selected<%}%>>2004</option>
    			<option value='2005' <%if(s_year.equals("2005")){%>selected<%}%>>2005</option>
    			<option value='2006' <%if(s_year.equals("2006")){%>selected<%}%>>2006</option>
    			<option value='2007' <%if(s_year.equals("2007")){%>selected<%}%>>2007</option>
    			<option value='2008' <%if(s_year.equals("2008")){%>selected<%}%>>2008</option>
    					
    		</select>년&nbsp;
    		<select name='s_mon'>
    			<option value='01' <%if(s_mon.equals("01")){%>selected<%}%>>01</option>
    			<option value='02' <%if(s_mon.equals("02")){%>selected<%}%>>02</option>
    			<option value='03' <%if(s_mon.equals("03")){%>selected<%}%>>03</option>
    			<option value='04' <%if(s_mon.equals("04")){%>selected<%}%>>04</option>
    			<option value='05' <%if(s_mon.equals("05")){%>selected<%}%>>05</option>
    			<option value='06' <%if(s_mon.equals("06")){%>selected<%}%>>06</option>
    			<option value='07' <%if(s_mon.equals("07")){%>selected<%}%>>07</option>
    			<option value='08' <%if(s_mon.equals("08")){%>selected<%}%>>08</option>
    			<option value='09' <%if(s_mon.equals("09")){%>selected<%}%>>09</option>
    			<option value='10' <%if(s_mon.equals("10")){%>selected<%}%>>10</option>
    			<option value='11' <%if(s_mon.equals("11")){%>selected<%}%>>11</option>
    			<option value='12' <%if(s_mon.equals("12")){%>selected<%}%>>12</option>
    		</select>월&nbsp;
    		<select name='s_day'>
    			<option value='01' <%if(s_day.equals("01")){%>selected<%}%>>01</option>
    			<option value='02' <%if(s_day.equals("02")){%>selected<%}%>>02</option>
    			<option value='03' <%if(s_day.equals("03")){%>selected<%}%>>03</option>
    			<option value='04' <%if(s_day.equals("04")){%>selected<%}%>>04</option>
    			<option value='05' <%if(s_day.equals("05")){%>selected<%}%>>05</option>
    			<option value='06' <%if(s_day.equals("06")){%>selected<%}%>>06</option>
    			<option value='07' <%if(s_day.equals("07")){%>selected<%}%>>07</option>
    			<option value='08' <%if(s_day.equals("08")){%>selected<%}%>>08</option>
    			<option value='09' <%if(s_day.equals("09")){%>selected<%}%>>09</option>
    			<option value='10' <%if(s_day.equals("10")){%>selected<%}%>>10</option>
    			<option value='11' <%if(s_day.equals("11")){%>selected<%}%>>11</option>
    			<option value='12' <%if(s_day.equals("12")){%>selected<%}%>>12</option>
    			<option value='13' <%if(s_day.equals("13")){%>selected<%}%>>13</option>
    			<option value='14' <%if(s_day.equals("14")){%>selected<%}%>>14</option>
    			<option value='15' <%if(s_day.equals("15")){%>selected<%}%>>15</option>
    			<option value='16' <%if(s_day.equals("16")){%>selected<%}%>>16</option>
    			<option value='17' <%if(s_day.equals("17")){%>selected<%}%>>17</option>
    			<option value='18' <%if(s_day.equals("18")){%>selected<%}%>>18</option>
    			<option value='19' <%if(s_day.equals("19")){%>selected<%}%>>19</option>
    			<option value='20' <%if(s_day.equals("20")){%>selected<%}%>>20</option>
    			<option value='21' <%if(s_day.equals("21")){%>selected<%}%>>21</option>
    			<option value='22' <%if(s_day.equals("22")){%>selected<%}%>>22</option>
    			<option value='23' <%if(s_day.equals("23")){%>selected<%}%>>23</option>
    			<option value='24' <%if(s_day.equals("24")){%>selected<%}%>>24</option>
    			<option value='25' <%if(s_day.equals("25")){%>selected<%}%>>25</option>
    			<option value='26' <%if(s_day.equals("26")){%>selected<%}%>>26</option>
    			<option value='27' <%if(s_day.equals("27")){%>selected<%}%>>27</option>
    			<option value='28' <%if(s_day.equals("28")){%>selected<%}%>>28</option>
    			<option value='29' <%if(s_day.equals("29")){%>selected<%}%>>29</option>
    			<option value='30' <%if(s_day.equals("30")){%>selected<%}%>>30</option>
    			<option value='31' <%if(s_day.equals("31")){%>selected<%}%>>31</option>
    		</select>일&nbsp;		
    		<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>