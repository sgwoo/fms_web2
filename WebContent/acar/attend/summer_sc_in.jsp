<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.attend.*, acar.schedule.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<jsp:useBean id="bean" class="acar.attend.Sch_prvBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");	
	int s_month2 = request.getParameter("s_month2")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month2"));
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	int days = AddUtil.getMonthDate(Integer.parseInt(s_year), Integer.parseInt(s_month));
	
	Vector users = aa_db.getAttendUser2(s_kd, t_wd);
	int user_size = users.size();

	String td_color = "";
	int today = days - s_day;
	int m_day = s_day;

	if (s_month.equals("12") ) {
		s_month2 = 1;
	} else {
	//	if(days-today > 1){
			s_month2 = Integer.parseInt(s_month) + 1;
	//	}else{
	//		s_month2 = 1;
	//	}
	}	
	
	String s1_year = "";
	int s1_mon = 0;
	
%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	

	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/index.css">
</head>
<body onLoad="javascript:init()">
<form name='form1'  target='MAPPING' method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
<input type="hidden" name="s_month" value="<%=s_month%>">
<input type="hidden" name="s_month2" value="<%=s_month2%>">
<input type="hidden" name="s_day" value="<%=s_day%>">

<table border="0" cellspacing="0" cellpadding="0" width=<%=300+60*days%>>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class=line width='300' id='td_title' style='position:relative;'>	
			<table border="0" cellspacing="1" cellpadding="0" width='300'>
				<tr align="center"> 
					<td width='30' class='title1'>연번</td>
					<td width='80' class='title1'>근무지</td>
					<td width='60' class='title1'>부서</td>
					<td width='60' class='title1'>이름</td>
					<td width='60' class='title1'>직위</td>
				</tr>
			</table>
		</td> 
		<td class=line width='<%=60*days%>'>			
			<table border="0" cellspacing="1" cellpadding="0" width=<%=60*days%>>
				<tr align="center"> 

				<%
					for(int j=m_day; j<=days ; j++){%>
					<td class='title1' width='60' align="center"><%=s_month%>월<%=j%>일</td>
				<%}%>
				<%

				for(int k=1; k<=days-today ; k++){%>
					<td class='title1' width='60' align="center"><%=s_month2%>월<%=k%>일</td>
				<%}%>

				</tr>
			</table>
		</td>
	</tr>

<%if(user_size > 0){%>
	
	<tr>
		<td class=line width='300' id='td_con' style='position:relative;'>	
			<table border="0" cellspacing="1" cellpadding="0" width='300'>
				<%for(int i = 0 ; i < user_size ; i++){
					Hashtable user = (Hashtable)users.elementAt(i);%>
				<tr bgcolor="#FFFFFF"> 
					<td width='30' align='center' height="20"><%=i+1%></td>
					<td width='80' align='center' height="20"><%=user.get("BR_NM")%></td>
					<td width='60' align='center' height="20" style="font-size:8pt"><%=user.get("DEPT_NM")%></td>
					<td width='60' align='center' height="20"><span title='<%=user.get("USER_NM")%>'><%=AddUtil.subData(String.valueOf(user.get("USER_NM")),3)%></span></td>
					<td width='60' align='center' height="20"><%=user.get("USER_POS")%></td>
				</tr>
				<%}%>
			</table>
		</td>
		<td class=line width='<%=60*days%>'>			
			<table border="0" cellspacing="1" cellpadding="0" width=<%=60*days%>>
				<%for(int i = 0 ; i < user_size ; i++){
					Hashtable user = (Hashtable)users.elementAt(i);
					String user_id = String.valueOf(user.get("USER_ID"));%>
				<tr> 
				<%	for(int l=s_day; l<=days ; l++){
    					Sch_prvBean ab2 = aa_db.getAttendUserPrv2(user_id, s_year, AddUtil.addZero(s_month), AddUtil.addZero2(l));
						int day_of_week = calendar.getDayOfWeek(AddUtil.parseInt(s_year), AddUtil.parseInt(s_month), l);

    					td_color = "#FFFFFF";//평일
    					if(day_of_week == 1)		td_color = "#FEE6E6"; //일요일
    					else if(day_of_week == 7)	td_color = "#EEF5F9"; //토요일

					%> 
					<td align='center' width='60' bgcolor=<%=td_color%> height="20"> 
					<%if(ab2.getSch_chk().equals("4") || ab2.getSch_chk().equals("3") || ab2.getSch_chk().equals("5") || ab2.getSch_chk().equals("6") || ab2.getSch_chk().equals("7") || ab2.getSch_chk().equals("8") || ab2.getSch_chk().equals("9")){%>
					<%=ab2.getTitle()%>
					<%}%>
					</td>
				<%}%>
								
					 	<%//	if(ab2.getStart_mon().equals("8")){
							for(int l=1; l<=s_day ; l++){
							   s1_year = s_year;
							   s1_mon = s_month2;
							if ( s_month.equals("12")) {
								s1_year = AddUtil.toString((AddUtil.parseInt(s_year) + 1));
								s1_mon = 1;
							} 
    					Sch_prvBean ab2 = aa_db.getAttendUserPrv2(user_id, s1_year, AddUtil.addZero2(s1_mon), AddUtil.addZero2(l));
						int day_of_week = calendar.getDayOfWeek(AddUtil.parseInt(s1_year), s1_mon, l);
						
    					td_color = "#FFFFFF";//평일
												
    					if(day_of_week == 1)		td_color = "#FEE6E6"; //일요일
    					else if(day_of_week == 7)	td_color = "#EEF5F9"; //토요일

						%>
					<td align='center' width='60' bgcolor=<%=td_color%> height="20"> 
						<%if(ab2.getSch_chk().equals("4") || ab2.getSch_chk().equals("3") || ab2.getSch_chk().equals("5") || ab2.getSch_chk().equals("6") || ab2.getSch_chk().equals("7") || ab2.getSch_chk().equals("8") || ab2.getSch_chk().equals("9")){%>
					<%=ab2.getTitle()%>
					<%}%>
					</td>
					<%}%>
					<%//}%>
				</tr>
				<%}%>
		  </table>
		</td>
	</tr>
<%}else{%>                     
	<tr>		
		<td align='center' colspan="6">등록된 데이타가 없습니다</td>
	</tr>
<%}%>
</table>
</form>
</body>
</html>