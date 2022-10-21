<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#ffffff;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}


/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%;  height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}

.News_tit .date {padding-top:14px;font-size:18px;color:#888;}
.News_tit {padding:19px 21px 14px;border-bottom:1px #ddd solid;position:relative;}
.News_content {padding:10px 5px 15px;font-size:18px;color:#111;line-height:1px #ddd solid;}
.News_tit h3 {font-size:19px;color:#000;line-height:22px;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_sche.*, acar.car_service.*, acar.cus_sch.*"%>
<%@ page import="acar.cus0401.*, acar.cus0402.*, acar.user_mng.*" %>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<jsp:useBean id="c41_scBn" class="acar.cus0401.Cus0401_scBean" scope="page"/>
<jsp:useBean id="c42_cvBn" class="acar.cus0402.Cycle_vstBean" scope="page"/>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %> 


<%

	String myid = user_id;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(user_id);
	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	int start_year = request.getParameter("start_year")==null?0:AddUtil.parseInt(request.getParameter("start_year"));
	int start_month = request.getParameter("start_month")==null?0:AddUtil.parseInt(request.getParameter("start_month"));
	int start_day = request.getParameter("start_day")==null?0:AddUtil.parseInt(request.getParameter("start_day"));
	int nyear = 0;
	int nmonth = 0;
	int nday = 0;
	int cnt = 1;
	
	
	
	if(dept_id.equals("")){
		
		dept_id = user_bean.getDept_id();
			
//		if(dept_id.equals("0003")) dept_id = "0002";
	}

	if(start_year==0){
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
	if(thismonth.length() == 1)		thismonth = "0"+thismonth;
	if(thisday.length() == 1)		thisday = "0"+thisday;
	
	int day_of_week = 0;
	int last_day = calendar.getMonthLastDay(nyear,nmonth); 	
	
	String tr_color = "";
	String whatday = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("0008", "", ""); //고객지원팀 리스트
	
	
	
	//업무일지
	CarSchDatabase schedule = CarSchDatabase.getInstance();
	CarScheBean cs_r [] = schedule.getCarScheDay(thisyear,thismonth,thisday);
	
	//순회방문-거래처
	CusSch_Database cs_db = CusSch_Database.getInstance();
	Cycle_vstBean[] cvBns = cs_db.getCycle_vstAll(thisyear, thismonth, thisday);
	Vector sl = cs_db.getServiceAll(thisyear, thismonth, thisday);
	Vector cml = cs_db.getCar_maintAll(thisyear, thismonth, thisday);

	//정비건.
	CarServDatabase csd = CarServDatabase.getInstance();
%>

<script language='javascript'>
<!--
function go_before(year, mon, day){
	var fm = document.form1;
	var cur_day = day - 1;
	var cur_mon = mon;
	var cur_year = year;
	var beforeMonthLastDay = getMonthDateCnt(cur_year, cur_mon-1);
//alert(beforeMonthLastDay);
	if(cur_day < 1){
		cur_day = beforeMonthLastDay;
		cur_mon--;
	}

	if(cur_mon < 1)	{
		cur_mon = 12;
		cur_year = year - 1 ;
	}
	if(cur_day < 10)	cur_day = "0"+cur_day;
	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.start_day.value = cur_day;
	fm.submit();
}
function go_before2(year, mon, day){
	var fm = document.form1;
	var cur_day = day ;
	var cur_mon = mon-1;
	var cur_year = year;
	
	if(cur_mon < 1)	{
		cur_mon = 12;
		cur_year = year - 1 ;
	}
	if(cur_day < 10)	cur_day = "0"+cur_day;
	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.start_day.value = cur_day;
	fm.submit();
}

function go_next(year, mon, day){
	var fm = document.form1;
	var cur_day = day+1;
	var cur_mon = mon;
	var cur_year = year;
	var thisMonthLastDay = getMonthDateCnt(cur_year, cur_mon);

	if(cur_day >thisMonthLastDay){
		cur_day = 1;
		cur_mon++;
	}
	if(cur_mon > 12){
		cur_mon = 1;
		cur_year = year + 1 ;
	}

	if(cur_day < 10)	cur_day = "0"+cur_day;
	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_day.value = cur_day;
	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.submit();
}
function go_next2(year, mon, day){
	var fm = document.form1;
	var cur_day = day;
	var cur_mon = mon+1;
	var cur_year = year;

	if(cur_mon > 12){
		cur_mon = 1;
		cur_year = year + 1 ;
	}

	if(cur_day < 10)	cur_day = "0"+cur_day;
	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	fm.start_day.value = cur_day;
	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.submit();
}


function search(){
	fm = document.form1;
	fm.submit();
}


//어제
function go_before3(year, mon, day){
	var fm = document.form1;
	var cur_day = day - 1;
	var cur_mon = mon;
	var cur_year = year;

	if(cur_day < 1)	{
		cur_day = <%=last_day%>;
		cur_mon = mon - 1 ;
	}
	
	if(cur_mon < 1)	{
		cur_mon = 12;
		cur_year = year - 1 ;
	}
	
	if(cur_mon < 10)	cur_mon = "0"+cur_mon;

	
	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.start_day.value = cur_day;
	fm.submit();
}

//내일
function go_next3(year, mon, day){
	var fm = document.form1;
	var cur_day = day + 1;
	var cur_mon = mon;
	var cur_year = year;

	if(cur_day > <%=last_day%>)	{
		cur_day = 1;
		cur_mon = mon + 1 ;
	}
	
	if(cur_mon > 12){
		cur_mon = 1;
		cur_year = year + 1 ;
	}

	if(cur_mon < 10)	cur_mon = "0"+cur_mon;
	
	fm.start_year.value = cur_year;
	fm.start_month.value = cur_mon;
	fm.start_day.value = cur_day;
	fm.submit();
}

//-->
</script>


<body>
<form name='form1' method='post' action='schedule_all.jsp'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='start_year' value='<%=thisyear%>'>
<input type='hidden' name='start_month' value='<%=thismonth%>'>
<input type='hidden' name='start_day' value='<%=thisday%>'>
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">대전지점 스케줄관리	
			</div> 
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>           
        </div>
    </div>    
	<div id="contents">
		<%	
				int l = nday;
				day_of_week = calendar.getDayOfWeek(nyear, nmonth, l);
				tr_color = "#FFFFFF";//평일
				whatday = AddUtil.parseDateWeek("c", day_of_week);
				if(day_of_week == 1)		tr_color = "RED"; //일요일
				else if(day_of_week == 7)	tr_color = "BLUE"; //토요일
				if(AddUtil.getDate2(3) == l)	tr_color = "#E8FEE6"; // 현재 날짜 포인트
			%>
		<center>
			<a href='javascript:go_before3(<%=nyear%>,<%=nmonth%>,<%=nday%>);' class=hh><img src=/smart/images/button_b_day.gif align=absmiddle /></a>&nbsp;&nbsp;&nbsp;
			<%if(day_of_week == 1){// 일욜일 체크%><font color='<%=tr_color%>'>
			<b class=sub><%=thisyear%>년&nbsp;<%=thismonth%>월&nbsp;<%=thisday%>일</b>&nbsp;&nbsp;&nbsp;</font>
			<%}else if(day_of_week == 7){%><font color='<%=tr_color%>'>
			<b class=sub><%=thisyear%>년&nbsp;<%=thismonth%>월&nbsp;<%=thisday%>일</b>&nbsp;&nbsp;&nbsp;</font>
			<%}else{%>
			<b class=sub><%=thisyear%>년&nbsp;<%=thismonth%>월&nbsp;<%=thisday%>일</b>&nbsp;&nbsp;&nbsp;
			<%}%>
			<a href='javascript:go_next3(<%=nyear%>,<%=nmonth%>,<%=nday%>);' class=hh><img src=/smart/images/button_n_day.gif align=absmiddle /></a>&nbsp;
		</center><br />
	
<!-- content -->
	<div class="News_tit">
		<div>
			<% for(int i=0; i<users.size(); i++){
				Hashtable user = (Hashtable)users.elementAt(i);
				String userid = (String)user.get("USER_ID");
				if(userid.equals("000026"))	continue; %>
				[<%= c_db.getNameById(userid,"USER") %>]
								<%for(int j=0; j<cs_r.length; j++){
								cs_bean = cs_r[j];
										if(userid.equals(cs_bean.getUser_id())){
										out.print("<font color=red>"+"["+cs_bean.getSch_chk()+"] "+"</font>"+cs_bean.getTitle()+"<BR>");
								}
							}%>

		<div><font color="#666666">거래처방문 : </font>
						<%	cnt = 1;
						for(int j=0; j<cvBns.length; j++){
							c42_cvBn = cvBns[j];						
							if(c42_cvBn.getUpdate_id().equals(userid)){
						%><br />
							<%= cnt++ %>.
							<%= c_db.getNameById(c42_cvBn.getClient_id(),"CLIENT") %>
							<%= c42_cvBn.getVst_est_cont() %>
						<% 	}
						}%>
		</div>
		<div><font color="#666666">자동차정비 : </font>
						<%		cnt=1;
						for(int j=0; j<sl.size(); j++){
							Hashtable ht = (Hashtable)sl.elementAt(j);
							String nsdt = (String)ht.get("NEXT_SERV_DT");
							String sst = (String)ht.get("SERV_ST");
							String sdt = (String)ht.get("SERV_DT");
							String mng_id = (String)ht.get("MNG_ID");										
							if(mng_id.equals(userid)){
						%><br />
						<%= cnt++ %>.
						<%= ht.get("FIRM_NM") %>
						<%= ht.get("CAR_NO") %>
						<font color=e98c38>[<% if(sst.equals("1")){ out.print("순회점검");
											}else if(sst.equals("2")){ out.print("일반수리");
											}else if(sst.equals("3")){ out.print("보증수리");
											}else{ out.print("순회점검");
											} %>]</font>
						<% if(!sdt.equals("")){
									ServItem2Bean si_r [] = csd.getServItem2All(c41_scBn.getCar_mng_id(), c41_scBn.getServ_id());
									for(int k=0; k<si_r.length; k++){
										si_bean = si_r[k];
										if(k==0){%> <%=si_bean.getItem()%> 외 <font color="red"> 
							<%if(si_r.length>1){ out.print(si_r.length-1); }else{ out.print(si_r.length); }%>
							</font>건 
							<%}
								}
								}
							%>
						<%
							}
						}%>
		</div>
		<div><font color="#666666">운행차검사 : </font>
						<%		cnt=1;
						for(int j=0; j<cml.size(); j++){
							Hashtable ht = (Hashtable)cml.elementAt(j);
							String med = (String)ht.get("MED");
							String ckd = (String)ht.get("CKD");
							String mcd = (String)ht.get("MCD");
							String mng_id= (String)ht.get("MNG_ID");
							if(mng_id.equals(userid)){
						%><br />
							<%= cnt++ %>.
							<%= ht.get("FIRM_NM") %>
							<%= ht.get("CAR_NO") %>
							<font color=e98c38>[<% if(ckd.equals("1")){ out.print("정기검사");
								}else if(ckd.equals("2")){ out.print("정기정밀검사");
								}else{ out.print("정기검사");
								} %>]</font>
							<%= ht.get("CMP") %>
							<% if(ckd.equals("")){ %>
									<font color="#FF0000">미실시</font> 
							<% }else{ %>
									<font color="#666666">실시</font> 
							<% } %>
						<%
							}
						}%>
		</div><br />
		<hr color=#e3e0d3 height=1>
					  <% } %>
		<div>
	</div>
<!-- //content -->
	</div>
</div>
</form>
</body>
</html>
