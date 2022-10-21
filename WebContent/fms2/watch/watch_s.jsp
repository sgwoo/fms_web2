<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ page import="acar.watch.*, acar.car_sche.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String auth_rw = "";
	String noon = "";
	String iljung = "";
	String myid = "";
	int start_year =0;
	int start_month = 0;
	int start_day =0;
	int nyear = 0;
	int nmonth = 0;
	int nday = 0;
	String tr_color = "";
	String whatday = "";	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	
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
		if(start_day == 0 ){ 
			nday = start_day+1; 
		}else{ 
			nday = start_day; 
		}
	}
	
	String thisyear = Integer.toString(nyear);
	String thismonth = Integer.toString(nmonth);
	String thismonth2 = Integer.toString(nmonth-1);
	String thisday = Integer.toString(nday);

	if(thismonth.length() == 1)		thismonth = "0"+thismonth;
	if(thismonth2.length() == 1)	thismonth2 = "0"+thismonth2;
	int day_of_week = 0;

	// 해당월의 마지막 날짜 가져오기....
	int last_day = calendar.getMonthLastDay(nyear,nmonth); 
	
	Vector vt = wc_db.WatchScheAll(thisyear, thismonth, "1");
	int vt_size = vt.size();
	
%>

<HTML>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/index.css">
<style type="text/css">
.button{background-color:#6d758c;font-size:12px;cursor:pointer;border-radius:2px;color:#fff;border:0;outline:0;padding:5px 8px;margin:3px;}
</style>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='javascript'>
<!--

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

//근무자 선택
function SchReg(week, year, mon, day, is_registered_watch)
{
	var fm = document.thefrm;
	var auth_rw = fm.auth_rw.value;
	var url = "&auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_month=" + mon
			+ "&start_day=" + day
			+ "&week=" + week
			+ "&is_registered_watch="+is_registered_watch;
	
	var SUBWIN="./watch_member_i.jsp?watch_type=1" + url;	//원본
	window.open(SUBWIN, "SchReg1", "left=100, top=100, width=250, height=120, scrollbars=yes, status=yes");	
}
//근무자 선택-주간당직/월렌트
function SchSaleReg(week, year, mon, day, no)
{
	var fm = document.thefrm;
	var auth_rw = fm.auth_rw.value;
	var url = "&auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_month=" + mon
			+ "&start_day=" + day
			+ "&no=" + no
			+ "&week=" + week;
	
	var SUBWIN="./sale_watch_member_i.jsp?watch_type=1" + url;	//원본
	window.open(SUBWIN, "SchSaleReg1", "left=100, top=100, width=250, height=120, scrollbars=yes, status=yes");	
}
//근무자 선택-주차장
function SchSaleReg2(week, year, mon, day, no)
{
	var fm = document.thefrm;
	var auth_rw = fm.auth_rw.value;
	var url = "&auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_month=" + mon
			+ "&start_day=" + day
			+ "&no=" + no
			+ "&week=" + week;
	
	var SUBWIN="./mng_watch_member_i.jsp?watch_type=1" + url;	//원본
	window.open(SUBWIN, "SchSaleReg1", "left=100, top=100, width=250, height=120, scrollbars=yes, status=yes");	
}
function SchDel(id, year, mon, day)
{
	var fm = document.thefrm;
	fm.cmd.value='S';
	fm.member_id.value = id;
	fm.start_day.value = day;		
	if(!confirm('취소 하시겠습니까?'))	return;		
	fm.action='watch_member_d_a.jsp';		
	fm.target='i_no';
	fm.submit();
}


	//전체선택
	function AllSelect(){
		var fm = document.thefrm;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}		
	
	//등록
	function save(){
		var fm = document.thefrm;		
		fm.cmd.value='S';
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
			
		if(cnt == 0){
		 	alert("날짜를 선택하세요.");
			return;
		}	
		
		
		if(!confirm('등록 하시겠습니까?'))	return;		
		fm.action='watch_i_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}
	
	
	
		//담당자 전체선택
	function AllMBSelect(){
		var fm = document.thefrm;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_mb"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}	
	
	//담당자 등록
	function save_mb(){
		var fm = document.thefrm;		
		fm.cmd.value='S';
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_mb"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
		
		if(!confirm('등록 하시겠습니까?'))	return;		
		fm.action='watch_member_i_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}
				
	//일정취소
	function save_del(){
		var fm = document.thefrm;		
		fm.cmd.value='S';
		if(!confirm('취소 하시겠습니까?'))	return;		
		fm.action='watch_d_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}					
	
function LoadSche()
	{
		var fm = document.thefrm;
		fm.action='watch_frame.jsp';				
		fm.target='d_content';
		fm.submit();
	}	
	
function WatchReg(id, year, mon, day)
{
	
	var fm = document.thefrm;
	var auth_rw = fm.auth_rw.value;
	
	var url = "&auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_month=" + mon
			+ "&start_day=" + day
			+ "&member_id=" + id;

	var SUBWIN="./watch_in.jsp?cm=s" + url;	

	window.open(SUBWIN, "WatchReg", "left=100, top=100, width=830, height=1000, scrollbars=yes, status=yes");	
}

function WatchReg2(id, year, mon, day)
{
	
	var fm = document.thefrm;
	
		var auth_rw = fm.auth_rw.value;
		
		var url = "&auth_rw=" + auth_rw
				+ "&start_year=" + year 
				+ "&start_month=" + mon
				+ "&start_day=" + day
				+ "&member_id=" + id;
	
		var SUBWIN="./watch_in.jsp?cm=s" + url;	
		
		window.open(SUBWIN, "WatchReg", "left=100, top=100, width=830, height=1000, scrollbars=yes, status=yes");	
}
function WatchReg3(id, year, mon, day, no)
{
	
	var fm = document.thefrm;
	var auth_rw = fm.auth_rw.value;
	
	var url = "&auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_month=" + mon
			+ "&start_day=" + day
			+ "&no=" + no
			+ "&member_id=" + id;

	var SUBWIN="./mon_watch_in.jsp?cm=s" + url;	

	window.open(SUBWIN, "WatchReg", "left=100, top=100, width=830, height=1000, scrollbars=yes, status=yes");	
}
//-->

//일괄결제(20190114)
function sign_all(){
	var fm = document.thefrm;
	var len=fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				cnt++;
				idnum=ck.value;
			}
		}
	}	
	if(cnt == 0){ 
	 	alert("날짜를 선택하세요.");
		return;
	}	
	fm.action='/fms2/watch/watch_sign_all_pop.jsp?cm=s';		
	fm.target='SIGN_ALL';
	
	window.open("", "SIGN_ALL", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	fm.submit();
}
</script>

</HEAD>
<BODY topmargin="15" leftmargin="15" marginwidth="0" marginheight="0">
<form name='thefrm' method='post' action='./watch_s.jsp'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<table width=100% cellspacing=0 cellpadding=0 border=0 height=100% bgcolor=#FFFFFF>
    <tr>
	    <td align=center valign=top>
    	<!---------------------------------- 제목	 ------------------------------------------------->
    	    <table width=100% cellspacing=0 cellpadding=0 border=0>
        		<tr>
        		    <td align=center>
        		      <a href="javascript:go_before2(<%=nyear%>,<%=nmonth%>);"><img src=/acar/images/center/button_b_year.gif align=absmiddle border=0></a>&nbsp;
        			    <a href='javascript:go_before(<%=nyear%>,<%=nmonth%>);' class=hh><img src=/acar/images/center/button_b_month.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
        			    <b class=sub><%=thisyear%>년&nbsp;<%=thismonth%>월</b>&nbsp;&nbsp;&nbsp;
        			    <a href='javascript:go_next(<%=nyear%>,<%=nmonth%>);' class=hh><img src=/acar/images/center/button_n_month.gif align=absmiddle border=0></a>&nbsp;
        			    <a href="javascript:go_next2(<%=nyear%>,<%=nmonth%>);"><img src=/acar/images/center/button_n_year.gif align=absmiddle border=0></a> 
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
			                <tr align="center" bgcolor=b0baec>
				                <td height=3 class=title1><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();">전체</td>
								<td height=3 class=title1 colspan="">본사주간당직자</td>
								<td height=3 class=title1 colspan="">강서/구로 주간당직자</td>
								<td height=3 class=title1 colspan="">종로/송파 주간당직자</td>
			                    <td height=3 class=title1 colspan="">야간당직자</td>
			                </tr>
                			  <%	//요일별 색상
                					for(int i = 1 ; i < last_day + 1 ; i++){
                						day_of_week = calendar.getDayOfWeek(nyear, nmonth, i);
                						tr_color = "#FFFFFF";//평일
                						whatday = AddUtil.parseDateWeek("c", day_of_week);
                						if(day_of_week == 1)		tr_color = "#FEE6E6"; //일요일
                						else if(day_of_week == 7)	tr_color = "#EEF5F9"; //토요일
                						if(nday == i)				tr_color = "#E8FEE6"; // 현재 날짜 포인트
                			  %>
			                <tr align=center bgcolor=<%=tr_color%>>
			                	<!-- 일자 -->
				                <td id='d<%=i%>'  width=10% align=center>
								<input type="checkbox" name="ch_cd" value="<%if(i < 10){%>0<%}%><%=i%>">
								<a name="<%=thisyear%><%=thismonth%><%=i%>"> 
                                <%if(day_of_week == 1){// 일욜일 체크%>
                                <b class=c><%=i%>일<%=whatday%></b> 
                                <%}else if(day_of_week == 7){// 토요일 체크%>
                                <b class=f><%=i%>일<%=whatday%></b> 
                                <%}else{%>
                                <%=i%>일<%=whatday%> 
                                <%}%>
                                </a> 
                                </td>
                <!-- 본사주간당직자 -->
								<td align='center' width=> 
								<%if( vt_size >0){	            
										for(int j=0; j<  vt_size ; j++){
											Hashtable ht = (Hashtable)vt.elementAt(j);
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
												if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
									%>
									<%if(ht.get("MEMBER_ID3").equals("")){%>
									<%	if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "3")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
									<%	}%>
									<%}else{%>
									[<%=ht.get("MEMBER_NM3")%>(내선:<%=ht.get("IN_TEL3")%>)&nbsp;
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "3")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a>
								 	]
									<%}%>
									<%if(ht.get("MEMBER_ID4").equals("")){%>
									<%	if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "4")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
									<%	}%>
									<%}else{%>
									[<%=ht.get("MEMBER_NM4")%>(내선:<%=ht.get("IN_TEL4")%>)&nbsp;
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "4")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a>			
								 	]
									<%}%>
								<%			}
											}
										} 
									}
								%> 
								</td>
								<td align='center' width=> <!-- 강서/구로 주간당직자 -->
								<% if( vt_size >0){	            
									for(int j=0; j<  vt_size ; j++){
										Hashtable ht = (Hashtable)vt.elementAt(j);
		                			
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
		
										if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
										
									%>
								
								<% if(ht.get("MEMBER_ID5").equals("")){%>
								<%if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "5")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
								<%}%>
								<%}else{%>
									[<%=ht.get("MEMBER_NM5")%>&nbsp;
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "5")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a> ]
								<%}%>
								<% if(ht.get("MEMBER_ID6").equals("")){%>
								<%if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "6")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
								<%}%>
								<%}else{%>
									[<%=ht.get("MEMBER_NM6")%>&nbsp;
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "6")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a> ]
								<%}%>
								<%	}
										}
											} 
											}%> 
								</td>
								<td align='center' width=> <!-- 종로/송파 주간당직자 -->
								<% if( vt_size >0){	            
									for(int j=0; j<  vt_size ; j++){
										Hashtable ht = (Hashtable)vt.elementAt(j);
		                			
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
		
										if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
										
									%>
								
								<% if(ht.get("MEMBER_ID7").equals("")){%>
								<%if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "7")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
								<%}%>
								<%}else{%>
									[<%=ht.get("MEMBER_NM7")%>&nbsp;
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "7")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a> ]
								<%}%>
								<% if(ht.get("MEMBER_ID8").equals("")){%>
								<%if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "8")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
								<%}%>
								<%}else{%>
									[<%=ht.get("MEMBER_NM8")%>&nbsp;
									<a href='javascript:SchSaleReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "8")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a> ]
								<%}%>
								<%	}
										}
											} 
											}%> 
								</td>
				                <td align='center' width=> <!-- 야간당직자 -->
	
				                <% 
				                String day = String.format("%02d", i);
				                if( vt_size >0){
				                	int count = 0;				               
									for(int j=0; j<  vt_size ; j++){
										Hashtable ht = (Hashtable)vt.elementAt(j);
		                				
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
											++count;
										if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
											if(ht.get("MEMBER_ID").equals("")){
								%>
									<a href='javascript:SchReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
								<%}else { %>
									<%=ht.get("MEMBER_NM")%>
										<%if(ht.get("WATCH_TIME_ED").equals("") && ht.get("WATCH_SIGN").equals("")){%>
											<a href='javascript:WatchReg2("<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy>
										[일지작성] </a>
										<%}else if(!ht.get("WATCH_TIME_ED").equals("") && ht.get("WATCH_SIGN").equals("")){ %>
											<a href='javascript:WatchReg("<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy>
										<font color="red"><b>[결재요청]</b></font> </a>
										<%}else{ %>
											<a href='javascript:WatchReg("<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy>
											<font color="blue"><b>[일지보기]</b></font></a>
										<%}%>&nbsp;&nbsp;&nbsp; 
								<a href='javascript:SchDel( "<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy><img src="/acar/images/center/button_in_cancel.gif" border="0" align="absmiddle"></a>
								<%  if(!ht.get("WATCH_CH_NM").equals("")){ %>
									<% if(!ht.get("WATCH_CH_NM").equals( String.valueOf(ht.get("MEMBER_NM")) ) ){ %>	
										▶ &nbsp;&nbsp;&nbsp;대체근무자 [<%=ht.get("WATCH_CH_NM")%>]
									<%}%>
								<%  }%>
									
									<BR>
									<% if(!ht.get("MEMBER_ID2").equals("")){  %>
										<% if(!ht.get("MEMBER_ID").equals(ht.get("MEMBER_ID2"))){ %>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<FONT COLOR='BLUE'>당직근무 변경 :</FONT>[<%=ht.get("MEMBER_NM2")%>] ▶ [<%=ht.get("MEMBER_NM")%>]
										<%}%>
									<%}%>
									<%}%>
											<%	}
												}
											}
										if(count == 0){ // DB에 해당 일자에 대한 당직 근무 레코드가 없는 경우에도 야간 당직자 항목에 등록 버튼 노출 2019.12.30.
										%>
										<a href='javascript:SchReg("<%=day_of_week%>", "<%=thisyear%>", "<%=thismonth%>", "<%=day%>", <%=true%>)'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
				                		<%}
										} else {%>
										<a href='javascript:SchReg("<%=day_of_week%>", "<%=thisyear%>", "<%=thismonth%>", "<%=day%>", <%=true%>)'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
									<%} %>       <!-- vt_size end -->     										
                                </td>
			                </tr>
			            <%} %>  <!--요일끝 -->
			            </table>
		            </td>
		        </tr>
	        </table>
	    <!---------------------------------- 게시판끝	 ------------------------------------------------->
	    </td>		
  </tr>

    <tr>
        <td></td>
    </tr>  

  <tr height='30'>
    <td align="center">
    	<!--본사-->
	  <%if(nm_db.getWorkAuthUser("본사당직관리",myid) || nm_db.getWorkAuthUser("전산팀",myid) || nm_db.getWorkAuthUser("보유차관리",myid)){%>
	  	<a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg_ij.gif border=0 align=absmiddle></a>
	  <%}%>
	  <%if(nm_db.getWorkAuthUser("전산팀",myid)){ %>
	  	&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:save_del()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cancel_ij.gif border=0 align=absmiddle></a>
	  <%} %>	
	  <%if(nm_db.getWorkAuthUser("본사관리팀장",myid) || nm_db.getWorkAuthUser("전산팀",myid)){ %>
		&nbsp;&nbsp;&nbsp;&nbsp;
	  <input type="button" class="button" value="일괄결제" onclick="javascript:sign_all();">
	  <%} %>
	</td>
  </tr>

    <tr>
        <td></td>
    </tr>   
  
</table>
<input type='hidden' name='start_year' value='<%=thisyear%>'>
<input type='hidden' name='start_month' value='<%=thismonth%>'>
<input type='hidden' name='today' value='<%=thisday%>'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="start_day" value="">
<input type="hidden" name="member_id" value="">
<input type="hidden" name="member_st" value="">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>
