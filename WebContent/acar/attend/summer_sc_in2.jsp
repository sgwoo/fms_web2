<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.attend.*, acar.schedule.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<jsp:useBean id="bean" class="acar.attend.AttendBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");	

	int days = AddUtil.getMonthDate(Integer.parseInt(s_year), Integer.parseInt(s_month));
	
	Vector users = aa_db.getAttendUser2(s_kd, t_wd);
	int user_size = users.size();

	
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
<form name='form1' action='bank_mapping_i.jsp' target='MAPPING' method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
<input type="hidden" name="s_month" value="<%=s_month%>">


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
					for(int j=1; j<=days ; j++){%>
					<td class='title1' width='60' align="center"><%=s_month%>월 <%=j%>일</td>
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
				<%	for(int l=1; l<=days ; l++){
    					Sch_prvBean ab2 = aa_db.getAttendUserPrv2(user_id, s_year, AddUtil.addZero(s_month), AddUtil.addZero2(l));
    					
    					int day_of_week = calendar.getDayOfWeek(AddUtil.parseInt(s_year), AddUtil.parseInt(s_month), l);
    					String td_color = "#FFFFFF";//평일
    					if(day_of_week == 1)		td_color = "#FEE6E6"; //일요일
    					else if(day_of_week == 7)	td_color = "#EEF5F9"; //토요일%>
                    <td align='center' width='80' bgcolor=<%=td_color%> height="20"> 
					<%if(ab2.getSch_chk().equals("4") || ab2.getSch_chk().equals("3") || ab2.getSch_chk().equals("5") || ab2.getSch_chk().equals("6") || ab2.getSch_chk().equals("7") || ab2.getSch_chk().equals("8") || ab2.getSch_chk().equals("9")){%>
					<%=ab2.getTitle()%>
					<%}%>
                    </td>
                     			<%	}%>

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