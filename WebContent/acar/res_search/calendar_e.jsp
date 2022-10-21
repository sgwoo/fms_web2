<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.Date"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<style type="text/css">
<!--
	td,body {font-size:12px; font-family:굴림; text-decoration:none; color:black}
	th {font-size:12px; font-family:굴림; font-weight : bold; text-decoration:none; color:white}
	a:link {font-size:12px; font-family:굴림; text-decoration:none; color:black}
	a:visited {font-size:12px; font-family:굴림; text-decoration:none; color:black}
	a:hover {  font-size: 12px; text-decoration: blink; color:red}
//-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function set_deli_dt(year, month, day){
		var fm = parent.document.form1;
		fm.rent_end_dt.value = year+"-"+month+"-"+day;
	}
	
	function search_date(mode, year, month, date){
		var fm = document.form1;
		fm.mode.value = mode;
		fm.year.value = year;
		fm.month.value = month;
		fm.date.value = date;
		fm.action = "calendar_e.jsp";
		fm.submit();
	}	
//-->
</script>
</head>
<body onLoad="self.focus()">
<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	String max_dt = rs_db.getMaxData(c_id);
	if(max_dt.equals("")) max_dt = AddUtil.getDate(4);
%>

<%! int year;
	int month;
	int date;
	int dayofweek;  //첫번째 날의 요일
	int days;  //그달의 날짜수
	int nowyear; //현재의 년도
	int nowmonth;  //현재의 월
	int nowdate;  //현재의 일
	String nowweek;  //현재의 요일
	String url="";  //링크 Url
	int max = 2;
%>
<%    	
/**********          현재 년월일시를 구한다.                **********/
/**********          처음 불러올때 이값을 사용한다.          **********/
 	Calendar now = Calendar.getInstance();
	year =now.get(Calendar.YEAR);
	month = now.get(Calendar.MONTH)+1;
	date = now.get(Calendar.DATE);
	dayofweek = now.get(Calendar.DAY_OF_WEEK);
	nowyear = year;
	nowmonth = month;
	nowdate = date;

/**********          년 월 값을 받는다.                    **********/
/**********          년 월을 변경했을때 사용하다.          **********/
	String reqyear = request.getParameter("year");
	String reqmonth = request.getParameter("month");
	String reqdate = request.getParameter("date");
	String mode = request.getParameter("mode");

/**********          받은 값을 mode에따라 처리를 한다.                      **********/
/**********          처음 시작하면 reqyear, reqmonth는 null 이므로          **********/
	int curyear;
	int curmonth;
	int curdate;
	int curdayofweek;

	if ( (reqyear == null || reqyear.equals("") || reqyear.equals("null")) && (reqmonth == null || reqmonth.equals("") || reqmonth.equals("null")) ){
		curyear = year;
		curmonth = month-1;
		curdate = nowdate;
		mode="no";
	}else{
		if(mode.equals("preyear")){
			curyear = Integer.parseInt(reqyear)-1;
			curmonth = Integer.parseInt(reqmonth)-1;
			curdate = Integer.parseInt(reqdate);
		}else if(mode.equals("nextyear")){
			curyear = Integer.parseInt(reqyear)+1;
			curmonth = Integer.parseInt(reqmonth)-1;
			curdate = Integer.parseInt(reqdate);
		}else if(mode.equals("premonth")){
			curyear = Integer.parseInt(reqyear);
			curmonth = Integer.parseInt(reqmonth)-2;
			curdate = Integer.parseInt(reqdate);
		}else if(mode.equals("nextmonth")){
			curyear = Integer.parseInt(reqyear);
			curmonth = Integer.parseInt(reqmonth);
			curdate = Integer.parseInt(reqdate);
		}else{
			curyear = Integer.parseInt(reqyear);
			curmonth = Integer.parseInt(reqmonth)-1;
			curdate = Integer.parseInt(reqdate);
		}
	}
	
/**********          값을 받아서 세팅을 한다.          **********/
/**********          원하는 년,월,일을 설정!          **********/
	now.set(Calendar.YEAR,curyear);	
	now.set(Calendar.MONTH,curmonth);
	now.set(Calendar.DATE,1);

/**********          세팅된 내용의 년,월,일을 얻어 온다.          **********/
	year =now.get(Calendar.YEAR);//년도
	month = now.get(Calendar.MONTH)+1;//월
	date = now.get(Calendar.DATE);//날짜
	int blank = now.get(Calendar.DAY_OF_WEEK);//요일

/**********          년,월,일,날짜수를 출력 한다.          **********/
	if ((nowyear == year) && (nowmonth == month)){  //현재 년,월일 같을면
		curdayofweek = now.get(Calendar.DAY_OF_WEEK);
		if(reqdate == null || reqdate.equals("") || reqdate.equals("null")){
			date= nowdate;
		}else{
			date = Integer.parseInt(reqdate);
		}
		curdayofweek = (curdayofweek+((date-1)%7))%7;
	}else{
		curdayofweek = now.get(Calendar.DAY_OF_WEEK);
		if(reqdate == null || reqdate.equals("") || reqdate.equals("null")){
			date= nowdate;
		}else{
			date = Integer.parseInt(reqdate);
		}
		curdayofweek = (curdayofweek+((date-1)%7))%7;
	}
	switch (curdayofweek){
		case	1:
				nowweek = "일";
				break;
		case	2:
				nowweek = "월";
				break;
		case	3:
				nowweek = "화";
				break;
		case	4:
				nowweek = "수";
				break;
		case	5:
				nowweek = "목";
				break;
		case	6:
				nowweek = "금";
				break;
		default:
				nowweek = "토";
				break;
	}
	switch (month){
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			days = 31; break;
		case 4:
		case 6:
		case 9:
		case 11:
			days = 30; break;
		default:
			if((year % 4 ==0) &&(year % 100 !=0 ) ||(year % 400 ==0)){
				days = 29;
			}else{
				days = 28;
			}
	}
//	out.println(days+"<br>");
%>
<form name="form1" method="post" action="">
 <input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='mode' value=''>
 <input type='hidden' name='year' value=''>
 <input type='hidden' name='month' value=''>   
 <input type='hidden' name='date' value=''>    
  <table border=0 cellspacing=0 cellpadding=0 width=280>
    <tr> 
      <td align="right" height="22" width="180"><a href="javascript:search_date('premonth', '<%=year%>', '<%=month%>', '<%=date%>');"><font color=#5f5a5a>◀</font></a>&nbsp;<%=month%>월&nbsp; 
        <a href="javascript:search_date('nextmonth', '<%=year%>', '<%=month%>', '<%=date%>');"><font color=#5f5a5a>▶</font></a></td>
      <td align="right" height="22" width="120">&nbsp;<font color="#999999">대여만료일</font></td>
    </tr>
    <tr> 
      <td align="right" colspan="2"> 
        <table bordercolor=#5e5e5e cellspacing=0 bordercolordark=white cellpadding=1 bordercolorlight=#5e5e5e border=1>
          <tbody> 
          <tr> 
            <td align=middle bgcolor=#209ed0 colspan=7 height=25> 
              <table bordercolor=#5e5e5e cellspacing=2 bordercolordark=white cellpadding=0 width="100%" bordercolorlight=#5e5e5e border=0>
                <tbody> 
                <tr> 
                  <td align=middle width=35> 
                    <p><font color=white>일</font></p>
                  </td>
                  <td align=middle width=35> 
                    <p><font color=white>월</font></p>
                  </td>
                  <td align=middle width=35> 
                    <p><font color=white>화</font></p>
                  </td>
                  <td align=middle width=35> 
                    <p><font color=white>수</font></p>
                  </td>
                  <td align=middle width=35> 
                    <p><font color=white>목</font></p>
                  </td>
                  <td align=middle width=35> 
                    <p><font color=white>금</font></p>
                  </td>
                  <td align=middle width=35> 
                    <p><font color=white>토</font></p>
                  </td>
                </tr>
                </tbody> 
              </table>
            </td>
          </tr>
          <tr> 
            <%	/********** 요일만큼 공백을 위해서          **********/
			int tr=0;  
			for(int i=1;i<blank;i++){
				out.println("<td bgcolor=\"#ffffff\" >&nbsp;</td>");
				tr++;
			}
			/********** 날짜를 출력 한다.          **********/
			String dt [] = rs_db.getResCalendar(c_id, Integer.toString(year), AddUtil.addZero2(month), days);
//			for (int j =1; j< days+1;j++){
			for (int j =1; j< dt.length+1;j++){
				tr++;
		%>
            <td height="35" valign="top" align="center" width="35"> 
			  <!--사용여부-->
			  <%if(dt[j-1].equals("N") || max_dt.equals(year+AddUtil.addZero2(month)+AddUtil.addZero2(j))){%>
              <%//if(rs_db.getResSearchDate(c_id, year+AddUtil.addZero2(month)+AddUtil.addZero2(j)) || max_dt.equals(year+AddUtil.addZero2(month)+AddUtil.addZero2(j))){%>
              <a href="javascript:set_deli_dt('<%=year%>', '<%=AddUtil.addZero2(month)%>', '<%=AddUtil.addZero2(j)%>');" onFocus="this.blur()"><%=j%><br>
              <font color=red>○</font></a> 
              <%}else{%>
              <%=j%><br>
              X 
              <%}%>
            </td>
            <%		if( tr == 7){
					out.println("</tr>");
					if(j != days){
						out.println("<tr>");
					}
					tr=0;
				}
			}
			/********** 날짜를 출력하고 나머지는 빈공백          **********/
			while(tr > 0 && tr <7){
				out.println("<td bgcolor=\"#ffffff\">&nbsp;</td>");
				tr++;
			}%>
          </tr>
          </tbody> 
        </table>
      </td>
    </tr>
    <tr> 
      <td align="right" height="22" colspan="2"><font color=#0a52df>○</font><font color=black> 
        - 예약가능 </font><font color=#5d5d5d>X</font><font color=black> - 예약마감</font></td>
    </tr>
  </table>
</form>
</body>
</html>