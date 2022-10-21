<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.attend.*, acar.schedule.*, acar.fee.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<jsp:useBean id="bean" class="acar.attend.Sch_prvBean" scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");
	
	int days = AddUtil.getMonthDate(Integer.parseInt(s_year), Integer.parseInt(s_month));
	
	Vector users = aa_db.getHomeWorkStat(s_year, AddUtil.addZero(s_month), days, s_kd, t_wd);
	int user_size = users.size();

	String td_color = "";
	
	int count1 =0;
	int count2 =0;
	int count3 =0;
	int count4 =0;
	int count5 =0;
	int count6 =0;
	
	int  day_of_week = 0;
	String whatday = "";
	
%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/index.css">
</head>
<body>
<form name='form1'  target='MAPPING' method="POST">
<table border="0" cellspacing="0" cellpadding="0" width=<%=340+(30*days)%>>
    <tr>    
        <td class=line2 ></td>
    </tr>
	<tr >
		<td class=line width='<%=340+(30*days)%>' >	
			<table border="0" cellspacing="1" cellpadding="0" width='<%=340+(30*days)%>'>
			    <!-- 
				<tr align="center"> 
					<td width='30' class='title1'>연번</td>
					<td width='80' class='title1'>근무지</td>
					<td width='70' class='title1'>부서</td>
					<td width='60' class='title1'>이름</td>
					<td width='60' class='title1'>직위</td>
					<td width='40' class='title1'>조</td>					
				<%	for(int j=1; j<=days ; j++){
				
					//day_of_week = calendar.getDayOfWeek(Integer.parseInt(s_year), Integer.parseInt(s_month), j);
					//whatday = AddUtil.parseDateWeek("c", day_of_week);
				
				%>
					<td class='title1' width='30' align="center"><%=j%>일<br><%=whatday%></td>
				<%}%>
				</tr>
				 -->
				<%for(int i = 0 ; i < user_size ; i++){
					Hashtable user = (Hashtable)users.elementAt(i);
					//인원수
					
					if(String.valueOf(user.get("LOAN_ST")).equals("")){
						count1 = count1+1;
					}	
					if(String.valueOf(user.get("LOAN_ST")).equals("2")){
						count3 = count3+1;
					}	
					if(String.valueOf(user.get("LOAN_ST")).equals("1")){
						count5 = count5+1;
					}
					
				%>
				<tr bgcolor="#FFFFFF"> 
					<td width='30' align='center' height="20"><%=i+1%></td>
					<td width='80' align='center' height="20"><%=user.get("BR_NM")%></td>
					<td width='70' align='center' height="20"><%=user.get("DEPT_NM")%></td>					
					<td width='60' align='center' height="20"><%=user.get("USER_NM")%></span></td>
					<td width='60' align='center' height="20"><%=user.get("USER_POS")%></td>
					<td width='40' align='center' height="20"><%if(String.valueOf(user.get("TEAM_NM")).equals("0")){%><%}else{%><%=user.get("TEAM_NM")%><%}%></span></td>
					<%for(int j=1; j<=days ; j++){
						td_color = "#FFFFFF";
						String h_dy = user.get("H_DY"+j)+"";
						String p_dy = user.get("P_DY"+j)+"";
						if(h_dy.equals("R")){
							td_color = "#FEE6E6";
						}
						if(h_dy.equals("R2")){
							td_color = "#f7c3c3";
						}
						if(p_dy.equals("B")){
							td_color = "#349BD5";
						}
						if(p_dy.equals("Y")){
							td_color = "#FFFF00";
						}	
						//근무일현황
						/*
						if(String.valueOf(user.get("LOAN_ST")).equals("") && td_color.equals("#FFFFFF")){
							count1 = count1+1;
						}	
						if(String.valueOf(user.get("LOAN_ST")).equals("2") && td_color.equals("#FFFFFF")){
							count3 = count3+1;
						}	
						if(String.valueOf(user.get("LOAN_ST")).equals("1") && td_color.equals("#FFFFFF")){
							count5 = count5+1;
						}
						*/
						//재택근무현황
						/*
						if(String.valueOf(user.get("LOAN_ST")).equals("") && td_color.equals("#349BD5")){
							count2 = count2+1;
						}	
						if(String.valueOf(user.get("LOAN_ST")).equals("2") && td_color.equals("#349BD5")){
							count4 = count4+1;
						}	
						if(String.valueOf(user.get("LOAN_ST")).equals("1") && td_color.equals("#349BD5")){
							count6 = count6+1;
						}
						*/						
					%>
					<td align='center' width='30' bgcolor=<%=td_color%> height="20">&nbsp;<%if(j==1 && ck_acar_id.equals("000029")){%><%=user.get("LOAN_ST")%><%}%></td>
					<%} %>				
				</tr>
				<%}%>
		  </table>
		</td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.cnt1.value = '<%=count1%>';	
	parent.document.form1.cnt3.value = '<%=count3%>';
	parent.document.form1.cnt5.value = '<%=count5%>';

//-->
</script>
</body>
</html>