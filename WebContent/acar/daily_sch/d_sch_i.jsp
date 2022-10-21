<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table.css'>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1;
		if(fm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
		else if(fm.content.value == '')	{	alert('내용을 입력하십시오');	return;	}
		if(get_length(fm.content.value) > 4000){
			alert("4000자 까지만 입력할 수 있습니다.");
			return;
		}	
		fm.target='i_no';
		fm.submit();
	}
	function get_length(f) {
		var max_len = f.length;
		var len = 0;
		for(k=0;k<max_len;k++) {
			t = f.charAt(k);
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}
		return len;
	}	
//-->
</script>
</head>
<%
	String s_sys	= Util.getDate();
	String s_year	= s_sys.substring(0, 4);
	String s_mon	= s_sys.substring(5, 7);
	String s_day	= s_sys.substring(8, 10);

	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<body>
<form action='/acar/daily_sch/d_sch_i_a.jsp' name='form1' method='post'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<table border=0 cellspacing=0 cellpadding=0 width=450>
	<tr>
    	<td><font color="navy">기초정보관리 -> </font><font color="red">일일업무계획</font></td>
    </tr>
    <tr>
    	<td align='right'>
    		<a href='javascript:save()' onMouseOver="window.status=''; return true"> 등록 </a>
    		<a href='javascript:window.close()' onMouseOver="window.status=''; return true">닫기</a>
    	</td>
    </tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=450>
			    <tr>
			    	<td class='title' width='100'>등록일</td>
			    	<td>&nbsp;<select name='s_year'>
			    			<option value='2002' <%if(s_year.equals("2002")){%>selected<%}%>>2002</option>
			    			<option value='2003' <%if(s_year.equals("2003")){%>selected<%}%>>2003</option>
			    			<option value='2004' <%if(s_year.equals("2004")){%>selected<%}%>>2004</option>
			    			<option value='2005' <%if(s_year.equals("2005")){%>selected<%}%>>2005</option>
			    			<option value='2006' <%if(s_year.equals("2006")){%>selected<%}%>>2006</option>
			    		</select>년
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
			    		</select>월
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
			    		</select>일
			    	</td>
			    </tr>
			    <tr>
			    	<td class='title'>등록자</td>
			    	<td>&nbsp;<%=c_db.getNameById(user_id, "USER")%></td>
			    </tr>
			    <tr>
			    	<td class='title'>제목</td>
			    	<td>&nbsp;<input type='text' name='title' size='50' class='text' value='' maxlength='125'></td>
			    </tr>
				<tr>
			    	<td class='title'><br/><br/>내용<br/><br/></td>
			    	<td>&nbsp;<textarea rows='20' name='content' cols='52' maxlength='2000'></textarea></td>
			    </tr>    
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>