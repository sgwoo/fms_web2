<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_sche.*" %>
<%@ page import="acar.schedule.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	ScheduleDatabase schedule = ScheduleDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = "";
	String noon = "";
	String iljung = "";
	String myid = "";
	int start_year =0;
	int start_month = 0;
	int start_day =1;
	int nyear = 0;
	int nmonth = 0;
	int nday = 0;
	String tr_color = "";
	String whatday = "";	
	myid = login.getCookieValue(request, "acar_id");
	
	if(request.getParameter("auth_rw")!=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("start_year")!=null) start_year = Util.parseInt(request.getParameter("start_year"));
	if(request.getParameter("start_month")!=null) start_month = Util.parseInt(request.getParameter("start_month"));

	if(start_year==0)
	{
		nyear = calendar.getThisYear();
		nmonth = calendar.getThisMonth();
		nday = calendar.getThisDay();
	}else{
		nyear = start_year;
		nmonth = start_month;
		nday = start_day;
	}
	String thisyear = Integer.toString(nyear);
	String thismonth = Integer.toString(nmonth);
	String thisday = Integer.toString(nday);

	if(thismonth.length() == 1)
		thismonth = "0"+thismonth;

	int day_of_week = 0;

	// 해당월의 마지막 날짜 가져오기....
	int last_day = calendar.getMonthLastDay(nyear,nmonth); 
	
	CarScheBean cs_r [] = schedule.getCarScheAll(thisyear,thismonth,myid);
%>

<HTML>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/index.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
function OpenMonth()
{
	var theForm = document.thefrm;
	var auth_rw = theForm.auth_rw.value;
	var year = theForm.start_year.value;
	var mon = theForm.start_month.value;
	
	var url = "?auth_rw=" + auth_rw
			+ "&sche_year=" + year 
			+ "&sche_mon=" + mon
			+ "&user_id=<%=myid%>";

	var SUBWIN="./month_i.jsp" + url;	
	
	window.open(SUBWIN, "MSchReg", "left=100, top=100, width=600, height=600, scrollbars=yes");
}
function OpenYear()
{
	var theForm = document.thefrm;
	var auth_rw = theForm.auth_rw.value;
	var year = theForm.start_year.value;
	var mon = theForm.start_month.value;
	
	var url = "?auth_rw=" + auth_rw
			+ "&sche_year=" + year 
			+ "&user_id=<%=myid%>";

	var SUBWIN="./year_i.jsp" + url;	
	
	window.open(SUBWIN, "YSchReg", "left=100, top=100, width=600, height=600, scrollbars=yes");
}

function init()
{
	var day = document.thefrm.today.value;
	
	//location.href='#d'+day+'';

}

function go_before(year, mon)
{
	var cur_mon = mon - 1;
	var cur_year = year;

	if(cur_mon < 1)
	{
		cur_mon = 12;
		cur_year = year - 1 ;
	}

	if(cur_mon < 10)
		cur_mon = "0"+cur_mon;

	document.thefrm.start_year.value = cur_year;
	document.thefrm.start_month.value = cur_mon;

	document.thefrm.submit();
}
//이전년도
function go_before2(year, mon){
	var fm = document.thefrm;
	var cur_mon = mon;
	var cur_year = year-1;

	if(cur_year < 1)	{
		cur_year = 1 ;
	}

	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.submit();
}

function go_next(year, mon)
{
	var cur_mon = mon + 1;
	var cur_year = year;

	if(cur_mon > 12)
	{
		cur_mon = 1;
		cur_year = year + 1 ;
	}

	if(cur_mon < 10)
		cur_mon = "0"+cur_mon;

	document.thefrm.start_year.value = cur_year;
	document.thefrm.start_month.value = cur_mon;

	document.thefrm.submit();
}
//다음년도
function go_next2(year, mon){
	var fm = document.thefrm;
	var cur_mon = mon;
	var cur_year = year+1;

	if(cur_year > 9999){
		cur_year = 9999;
	}

	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.submit();
}

function Change(arg)
{
	if(arg=='1')
	{
		location = "./sch_year_s.jsp";
	}else if(arg=='2'){
		location = "./sch_month_s.jsp";
	}else if(arg=='3'){
		location = "./sch_s.jsp";
	}
}
function SchReg(year, mon, day, id)
{
	var theForm = document.thefrm;
	var auth_rw = theForm.auth_rw.value;
	
	var url = "?auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_mon=" + mon
			+ "&start_day=" + day
			+ "&acar_id=" + id;

	var SUBWIN="./sch_i.jsp" + url;	
	
	window.open(SUBWIN, "SchDisp", "left=100, top=100, width=620, height=600, scrollbars=yes");
}

function ScheDisp(id, seq, year, mon, day)
{
	var theForm = document.thefrm;
	var auth_rw = theForm.auth_rw.value;
	
	var url = "?auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_mon=" + mon
			+ "&start_day=" + day
			+ "&acar_id=" + id
			+ "&seq=" + seq;

	var SUBWIN="./sch_c.jsp" + url;	
	
	window.open(SUBWIN, "SchDisp", "left=100, top=100, width=620, height=600, scrollbars=yes");
}
-->
</script>

</HEAD>
<BODY onLoad='init();' topmargin="15" leftmargin="15" marginwidth="0" marginheight="0">
<form name='thefrm' method='post' action='./sch_s.jsp'>
<table width=100% cellspacing=0 cellpadding=0 border=0 height=100% bgcolor=#FFFFFF>
    <tr>
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 업무일지관리 > <span class=style5>업무스케줄관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
	    <td align=center valign=top>
    	<!---------------------------------- 제목	 ------------------------------------------------->
    	    <table width=100% cellspacing=0 cellpadding=0 border=0>
        		<tr>
        		    <td align=center>
        		    <a href="javascript:go_before2(<%=nyear%>,<%=nmonth%>);"><img src=../images/center/button_b_year.gif align=absmiddle border=0></a>&nbsp;
        			<a href='javascript:go_before(<%=nyear%>,<%=nmonth%>);' class=hh><img src=../images/center/button_b_month.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
        			<b class=sub><%=thisyear%>년&nbsp;<%=thismonth%>월</b>&nbsp;&nbsp;&nbsp;
        			<a href='javascript:go_next(<%=nyear%>,<%=nmonth%>);' class=hh><img src=../images/center/button_n_month.gif align=absmiddle border=0></a>&nbsp;
        			<a href="javascript:go_next2(<%=nyear%>,<%=nmonth%>);"><img src=../images/center/button_n_year.gif align=absmiddle border=0></a> 
        		    </td>					
        		</tr>
    	    </table>
    	<!---------------------------------- 게시판시작	 ------------------------------------------------->
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
	        <table width=100% cellspacing=0 cellpadding=0 border=0>
	            <tr>
	                <td class=line2></td>
	            </tr>
		        <tr>
		            <td bgcolor=#7A9494 class=line>  
		                <table width=100% cellspacing=1 cellpadding=3 border=0>
			                <tr bgcolor=b0baec>
				                <td colspan=2 height=3 class=title1><img src=../image/blank.gif height=3></td>
			                </tr>
                			  <!--
                			  <tr align=center bgcolor=#E8FEE6>
                				  <td width=100 align=center> <a href="javascript:SchReg('<%=AddUtil.getDate2(1)%>','<%=AddUtil.getDate2(2)%>','<%=AddUtil.getDate2(3)%>','<%=myid%>')" border='0'> 
                                    <%=AddUtil.getDate2(1)%>년<%=AddUtil.getDate2(2)%>월<%=AddUtil.getDate2(3)%>일(<%=AddUtil.parseDateWeek("k", calendar.getDayOfWeek(AddUtil.getDate2(1), AddUtil.getDate2(2), AddUtil.getDate2(3)))%>요일)	
                                    </a> </td>
                				  <td align=left width=700>--> 
                                    <%/*for(int j=0; j<cs_r.length; j++){
                        			cs_bean = cs_r[j];
                					if(Integer.parseInt(cs_bean.getStart_day()) == AddUtil.getDate2(3)){
                						if(cs_bean.getStart_year().equals(AddUtil.getDate(1)) && cs_bean.getStart_mon().equals(AddUtil.getDate(2))){				
                							out.print("<a href='javascript:ScheDisp(\""+cs_bean.getUser_id()+"\",\""+cs_bean.getSeq()+"\",\""+cs_bean.getStart_year()+"\",\""+cs_bean.getStart_mon()+"\",\""+cs_bean.getStart_day()+"\")' border='0' class=copy>"+cs_bean.getUser_nm()+" ["+cs_bean.getSch_chk()+"] "+cs_bean.getTitle()+"</a><BR>");
                						}
                					}
                				}*/%>
                              <!--    </td>
                			  </tr>			
                			  <tr bgcolor=#B5E5EF>
                				<td colspan=2 height=3><img src=../image/blank.gif height=3></td>
                			  </tr>-->
                			  <%	
                					for(int i = 1 ; i < last_day + 1 ; i++){
                						day_of_week = calendar.getDayOfWeek(nyear, nmonth, i);
                						tr_color = "#FFFFFF";//평일
                						whatday = AddUtil.parseDateWeek("c", day_of_week);
                						if(day_of_week == 1)		tr_color = "#FEE6E6"; //일요일
                						else if(day_of_week == 7)	tr_color = "#EEF5F9"; //토요일
                						if(nday == i)				tr_color = "#E8FEE6"; // 현재 날짜 포인트
                			  %>
			                <tr align=center bgcolor=<%=tr_color%>>
				                <td id='d<%=i%>'  width=15% align=center><a name="<%=thisyear%><%=thismonth%><%=i%>"> <a href="javascript:SchReg('<%=thisyear%>','<%=thismonth%>','<%if(i < 10){%>0<%}%><%=i%>','<%=myid%>')" border='0'> 
                                <%if(day_of_week == 1){// 일욜일 체크%>
                                <b class=c><%=i%>일<%=whatday%></b> 
                                <%}else if(day_of_week == 7){%>
                                <b class=f><%=i%>일<%=whatday%></b> 
                                <%}else{%>
                                <%=i%>일<%=whatday%> 
                                <%}%>
                                </a></a> </td>
				                <td align=left width=85%> 
                                <%for(int j=0; j<cs_r.length; j++){
                    			cs_bean = cs_r[j];
            					if(Integer.parseInt(cs_bean.getStart_day()) == i){
            						if(cs_bean.getStart_year().equals(thisyear) && cs_bean.getStart_mon().equals(thismonth)){				
            							out.print("<a href='javascript:ScheDisp(\""+cs_bean.getUser_id()+"\",\""+cs_bean.getSeq()+"\",\""+cs_bean.getStart_year()+"\",\""+cs_bean.getStart_mon()+"\",\""+cs_bean.getStart_day()+"\")' border='0' class=copy>"+cs_bean.getUser_nm()+" ["+cs_bean.getSch_chk()+"] "+cs_bean.getTitle()+"</a><BR>");
            						}
            					}
            				}%>
                                </td>
			                </tr>
			            <%} %>
			            </table>
		            </td>
		        </tr>
	        </table>
	    <!---------------------------------- 게시판끝	 ------------------------------------------------->
	    </td>		
  </tr>
  <tr height='30'><td colspan=3></td></tr>
</table>
<input type='hidden' name='start_year' value='<%=thisyear%>'>
<input type='hidden' name='start_month' value='<%=thismonth%>'>
<input type='hidden' name='today' value='<%=thisday%>'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
</form>
</BODY>
</HTML>
