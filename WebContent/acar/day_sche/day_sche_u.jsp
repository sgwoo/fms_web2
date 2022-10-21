<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.day_sche.*"%>
<jsp:useBean id="dsch_db" scope="page" class="acar.day_sche.DScheDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");	
	String s_seq = request.getParameter("s_seq")==null?"":request.getParameter("s_seq");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	CommonDataBase c_db = CommonDataBase.getInstance();
	DayScheBean scd = dsch_db.getDailyScd(s_year, s_mon, s_day, s_seq);

	Vector users = c_db.getUserList("", "", "MNG_EMP"); //고객지원팀 리스트
	int user_size = users.size();

	String pr_dt = scd.getPr_dt();
	String pr_dt_year;
	String pr_dt_mon;
	String pr_dt_day;
	String pr_id = scd.getPr_id();

	if(scd.getStatus().equals("1")){
		pr_dt_year = pr_dt.substring(0,4);
		pr_dt_mon = pr_dt.substring(4,6);
		pr_dt_day = pr_dt.substring(6,8);
	}else{
		String sys_dt = Util.getDate();
		pr_dt_year = sys_dt.substring(0,4);
		pr_dt_mon = sys_dt.substring(5,7);
		pr_dt_day = sys_dt.substring(8,10);
	}
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function modify()
	{
		var fm = document.form1;
		if(fm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
		else if(fm.content.value == '')	{	alert('내용을 입력하십시오');	return;	}
		if(get_length(fm.content.value) > 4000){
			alert("4000자 까지만 입력할 수 있습니다.");
			return;
		}
		fm.target='i_no';
		fm.action='/acar/day_sche/day_sche_upd.jsp';
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
	function del(){
		if(!confirm('삭제하시겠습니까?')){	return;	}
		var fm = document.form1;
		fm.target = 'i_no';
		fm.action='/acar/day_sche/day_sche_del.jsp';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action='' name='form1' method='post'>
<input type='hidden' name='s_year' value='<%=s_year%>'>
<input type='hidden' name='s_mon' value='<%=s_mon%>'>
<input type='hidden' name='s_day' value='<%=s_day%>'>
<input type='hidden' name='s_seq' value='<%=s_seq%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객관리 > <span class=style5>일일스케쥴</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td align='right'>
			<a href='javascript:del()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif"  align="absmiddle" border="0"></a>&nbsp;
    		<a href='javascript:modify()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a>&nbsp;
    		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a>
    	</td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
			    <tr>
			    	<td class='title' width=20%>등록일</td>
			    	<td width=80%>&nbsp;<%=s_year%>년&nbsp;<%=s_mon%>월&nbsp;<%=s_day%>일
			    	</td>
			    </tr>
			    <tr>
			    	<td class='title'>등록자</td>
			    	<td>&nbsp;<%=c_db.getNameById(scd.getUser_id(), "USER")%></td>
			    </tr>
			    <tr>
			    	<td class='title'>제목</td>
			    	<td>&nbsp;<input type='text' name='title' style='IME-MODE: active' size='50' class='text' value='<%=scd.getTitle()%>' maxlength='125'></td>
			    </tr>
				<tr>
			    	<td class='title'>내용</td>
			    	<td>&nbsp;<textarea rows='20' name='content' style='IME-MODE: active' cols='52' maxlength='2000'><%=scd.getContent()%></textarea></td>
			    </tr>
				<tr>
			    	<td class='title'>처리일</td>
					<td>&nbsp;<select name='pr_dt_year'>
							<option value='2002' <%if(pr_dt_year.equals("2002")){%>selected<%}%>>2002</option>
							<option value='2003' <%if(pr_dt_year.equals("2003")){%>selected<%}%>>2003</option>
							<option value='2004' <%if(pr_dt_year.equals("2004")){%>selected<%}%>>2004</option>
							<option value='2005' <%if(pr_dt_year.equals("2005")){%>selected<%}%>>2005</option>
							<option value='2006' <%if(pr_dt_year.equals("2006")){%>selected<%}%>>2006</option>
						</select>년
						<select name='pr_dt_mon'>
							<option value='01' <%if(pr_dt_mon.equals("01")){%>selected<%}%>>01</option>
							<option value='02' <%if(pr_dt_mon.equals("02")){%>selected<%}%>>02</option>
							<option value='03' <%if(pr_dt_mon.equals("03")){%>selected<%}%>>03</option>
							<option value='04' <%if(pr_dt_mon.equals("04")){%>selected<%}%>>04</option>
							<option value='05' <%if(pr_dt_mon.equals("05")){%>selected<%}%>>05</option>
							<option value='06' <%if(pr_dt_mon.equals("06")){%>selected<%}%>>06</option>
							<option value='07' <%if(pr_dt_mon.equals("07")){%>selected<%}%>>07</option>
							<option value='08' <%if(pr_dt_mon.equals("08")){%>selected<%}%>>08</option>
							<option value='09' <%if(pr_dt_mon.equals("09")){%>selected<%}%>>09</option>
							<option value='10' <%if(pr_dt_mon.equals("10")){%>selected<%}%>>10</option>
							<option value='11' <%if(pr_dt_mon.equals("11")){%>selected<%}%>>11</option>
							<option value='12' <%if(pr_dt_mon.equals("12")){%>selected<%}%>>12</option>
						</select>월
						<select name='pr_dt_day'>
							<option value='01' <%if(pr_dt_day.equals("01")){%>selected<%}%>>01</option>
							<option value='02' <%if(pr_dt_day.equals("02")){%>selected<%}%>>02</option>
							<option value='03' <%if(pr_dt_day.equals("03")){%>selected<%}%>>03</option>
							<option value='04' <%if(pr_dt_day.equals("04")){%>selected<%}%>>04</option>
							<option value='05' <%if(pr_dt_day.equals("05")){%>selected<%}%>>05</option>
							<option value='06' <%if(pr_dt_day.equals("06")){%>selected<%}%>>06</option>
							<option value='07' <%if(pr_dt_day.equals("07")){%>selected<%}%>>07</option>
							<option value='08' <%if(pr_dt_day.equals("08")){%>selected<%}%>>08</option>
							<option value='09' <%if(pr_dt_day.equals("09")){%>selected<%}%>>09</option>
							<option value='10' <%if(pr_dt_day.equals("10")){%>selected<%}%>>10</option>
							<option value='11' <%if(pr_dt_day.equals("11")){%>selected<%}%>>11</option>
							<option value='12' <%if(pr_dt_day.equals("12")){%>selected<%}%>>12</option>
							<option value='13' <%if(pr_dt_day.equals("13")){%>selected<%}%>>13</option>
							<option value='14' <%if(pr_dt_day.equals("14")){%>selected<%}%>>14</option>
							<option value='15' <%if(pr_dt_day.equals("15")){%>selected<%}%>>15</option>
							<option value='16' <%if(pr_dt_day.equals("16")){%>selected<%}%>>16</option>
							<option value='17' <%if(pr_dt_day.equals("17")){%>selected<%}%>>17</option>
							<option value='18' <%if(pr_dt_day.equals("18")){%>selected<%}%>>18</option>
							<option value='19' <%if(pr_dt_day.equals("19")){%>selected<%}%>>19</option>
							<option value='20' <%if(pr_dt_day.equals("20")){%>selected<%}%>>20</option>
							<option value='21' <%if(pr_dt_day.equals("21")){%>selected<%}%>>21</option>
							<option value='22' <%if(pr_dt_day.equals("22")){%>selected<%}%>>22</option>
							<option value='23' <%if(pr_dt_day.equals("23")){%>selected<%}%>>23</option>
							<option value='24' <%if(pr_dt_day.equals("24")){%>selected<%}%>>24</option>
							<option value='25' <%if(pr_dt_day.equals("25")){%>selected<%}%>>25</option>
							<option value='26' <%if(pr_dt_day.equals("26")){%>selected<%}%>>26</option>
							<option value='27' <%if(pr_dt_day.equals("27")){%>selected<%}%>>27</option>
							<option value='28' <%if(pr_dt_day.equals("28")){%>selected<%}%>>28</option>
							<option value='29' <%if(pr_dt_day.equals("29")){%>selected<%}%>>29</option>
							<option value='30' <%if(pr_dt_day.equals("30")){%>selected<%}%>>30</option>
							<option value='31' <%if(pr_dt_day.equals("31")){%>selected<%}%>>31</option>
						</select>일		
					</td>
			    </tr>
			    <tr>
			    	<td class='title'>처리자</td>
					<td>
						&nbsp;<select name='pr_id'>
							<option value="">고객지원팀</option>
							<%if(user_size > 0){
								for (int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i);	%>
							<option value='<%=user.get("USER_ID")%>' <%if(pr_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
								<%}
							}%>
						</select>
					</td>
			    </tr>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</body>
</html>