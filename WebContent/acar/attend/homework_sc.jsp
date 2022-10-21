<%@ page language="java"  contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*" %>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String chk1 = request.getParameter("chk1")==null?"m":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-90;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
	
	int days = AddUtil.getMonthDate(s_year, s_month);
	
	Hashtable ht = ft_db.TodayHomeworkStat();
	
	int  day_of_week = 0;
	String whatday = "";	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/index.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="homework_sc.jsp" name="form1" method="POST">
<table border="0" cellspacing="0" cellpadding="0" width=<%=340+(30*days)+20%>>
    <tr> 
        <td colspan='2'> 
            <table border="0" cellspacing="0" cellpadding="0" width='<%=340+(30*days)%>'>
                <tr>
                    <td align='right'>
                    	※ 인원수/ 당일재택근무자 : 
                    	[내근직] <input type='text' name="cnt1" value='' size='2' class='whitenum'>/<input type='text' name="cnt2" value='<%=ht.get("CNT1") %>' size='2' class='whitenum'> 
                    	[영업직] <input type='text' name="cnt3" value='' size='2' class='whitenum'>/<input type='text' name="cnt4" value='<%=ht.get("CNT3") %>' size='2' class='whitenum'>
                    	[고객지원직] <input type='text' name="cnt5" value='' size='2' class='whitenum'>/<input type='text' name="cnt6" value='<%=ht.get("CNT2") %>' size='2' class='whitenum'>                    	
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
    <tr>
        <td class=h class=line2 ></td>
        <td class=h></td>
    </tr>  
   	<tr>
		<td class=line width='<%=340+(30*days)%>' >	
			<table border="0" cellspacing="1" cellpadding="0" width='<%=340+(30*days)%>'>
				<tr align="center"> 
					<td width='30' class='title1'>연번</td>
					<td width='80' class='title1'>근무지</td>
					<td width='70' class='title1'>부서</td>
					<td width='60' class='title1'>이름</td>
					<td width='60' class='title1'>직위</td>
					<td width='40' class='title1'>조</td>					
				<%	for(int j=1; j<=days ; j++){
				
					day_of_week = calendar.getDayOfWeek(s_year, s_month, j);
					whatday = AddUtil.parseDateWeek("c", day_of_week);
				
				%>
					<td class='title1' width='30' align="center"><%=j%>일<br><%=whatday%></td>
				<%}%>
				</tr>
            </table>
        </td>
        <td width='20'></td>
    </tr>
    <tr> 
        <td colspan='2'> 
            <table border="0" cellspacing="0" cellpadding="0" width='100%'>
                <tr> 
                    <td width=100%> 
                        <table border="0" cellspacing="0" cellpadding="0" width=100%>
                            <tr> 
                                <td align='center'><iframe src="homework_sc_in.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                            </iframe> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	
</table>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">		
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
<input type="hidden" name="s_month" value="<%=s_month%>">
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   	
</form>
</body>
</html>