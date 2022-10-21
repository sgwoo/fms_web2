<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ page import="acar.watch.*, acar.car_sche.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<!-- 
	2017. 10. 24
	watch_jj.jsp
	2017�� 11�� ���� �λ�, �뱸, ����, ���� ���� �޴� ���� �� �߰������� ����
-->
<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
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
		nday = start_day;
	}
	String thisyear = Integer.toString(nyear);
	String thismonth = Integer.toString(nmonth);
	String thisday = Integer.toString(nday);

	if(thismonth.length() == 1)
		thismonth = "0"+thismonth;

	int day_of_week = 0;

	// �ش���� ������ ��¥ ��������....
	int last_day = calendar.getMonthLastDay(nyear,nmonth); 

	String isAfterNov2017 = "";
	if((Integer.parseInt(thisyear) > 2016) && (Integer.parseInt(thismonth) > 10) || Integer.parseInt(thisyear) >= 2018){
		isAfterNov2017 = "1";
	}else{
		isAfterNov2017 = "0";
	}
	
	Vector vt = wc_db.WatchScheAll(thisyear, thismonth, "3");
	int vt_size = vt.size();
	
	Vector vt_dj = wc_db.WatchScheAll(thisyear, thismonth, "4");
	int vt_size_dj = vt_dj.size();

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
//�����⵵
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
//�����⵵
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
	
	var SUBWIN="./watch_member_i.jsp?watch_type=34" + url;	//����
	window.open(SUBWIN, "SchReg1", "left=100, top=100, width=250, height=120, scrollbars=yes, status=yes");	
}
//�ٹ��� ����-�ְ�����/����Ʈ
function SchReg2(week, year, mon, day, no, type)
{
	var fm = document.thefrm;
	var auth_rw = fm.auth_rw.value;
	var url = "&auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_month=" + mon
			+ "&start_day=" + day
			+ "&no=" + no
			+ "&week=" + week;
	
	var SUBWIN="./sale_watch_member_i.jsp?watch_type="+type+""+ url;	//����
	window.open(SUBWIN, "SchSaleReg1", "left=100, top=100, width=250, height=120, scrollbars=yes, status=yes");	
}

function SchDel(id, year, mon, day)
{
	var fm = document.thefrm;
	fm.cmd.value='B';
	fm.member_id.value = id;
	fm.start_day.value = day;		
	if(!confirm('��� �Ͻðڽ��ϱ�?'))	return;		
	fm.action='watch_member_d_a.jsp';		
	fm.target='i_no';
	fm.submit();
}


	//��ü����
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
	
	//���
function save(){
		var fm = document.thefrm;		
		fm.cmd.value='B';
		
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
		 	alert("��¥�� �����ϼ���.");
			return;
		}	
		
		if(!confirm('��� �Ͻðڽ��ϱ�?'))	return;		
		fm.action='watch_i_a.jsp';		
		fm.target='i_no';
		
//		fm.target='_blank';		
		fm.submit();
	}			
	//�������
	function save_del(){
		var fm = document.thefrm;		
		fm.cmd.value='B';
		if(!confirm('��� �Ͻðڽ��ϱ�?'))	return;		
		fm.action='watch_d_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}					
	
function LoadSche()
	{
		var fm = document.thefrm;
		fm.action='watch_bs.jsp';				
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
	
	var cmData = "";	// 2017.10.26 �߰� | 2017�� 11������ �λ�, �뱸, ����, ���� ������ �������� �̼��� �븮 ���
	
		
	if(fm.isAfterNov2017.value == "1") {
		cmData = "j";
	}else if( year == 2017 && mon == 10 && (day == 31 || day == 30) ){
		cmData = "j";
	}else {
		cmData = "x";
	}

	var SUBWIN="./watch_in.jsp?cm=" + cmData + url;	

	window.open(SUBWIN, "WatchReg", "left=100, top=100, width=830, height=1000, scrollbars=yes, status=yes");	
}


function WatchRegBeforeNov2017(id, year, mon, day)	// 2017�� 10�� 29�ϱ����� ����, ���� ���� �����
{
	
	var fm = document.thefrm;
	var auth_rw = fm.auth_rw.value;
	
	var url = "&auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_month=" + mon
			+ "&start_day=" + day
			+ "&member_id=" + id;
	
	var cmData = "";	// 2017.10.26 �߰� | 2017�� 11������ �λ�, �뱸, ����, ���� ������ �������� �̼��� �븮 ���
	if(fm.isAfterNov2017.value == "1") {
		cmData = "j";
	}else {
		cmData = "x";
	}
	

	var SUBWIN="./watch_in.jsp?cm=" + cmData + url;	

	window.open(SUBWIN, "WatchReg", "left=100, top=100, width=830, height=1000, scrollbars=yes, status=yes");	
}

function WatchReg2(id, year, mon, day)
{
	
	var fm = document.thefrm;
	if(fm.user_id.value != id ){
		alert("�����ٹ��ڰ� �ƴմϴ�.");
	}else{
	var auth_rw = fm.auth_rw.value;
	
	var url = "&auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_month=" + mon
			+ "&start_day=" + day
			+ "&member_id=" + id;
	
	var cmData = "";	// 2017.10.26 �߰� | 2017�� 11������ �λ�, �뱸, ����, ���� ������ �������� �̼��� �븮 ���
	if(fm.isAfterNov2017.value == "1") {
		cmData = "j";
	}else {
		if(fm.br_id.value == "B1" || fm.br_id.value == "G1"){
			cmData = "b";
		}else {
			cmData = "d";
		}
	}

	var SUBWIN="./watch_in.jsp?cm=" + cmData + url;	
	
	window.open(SUBWIN, "WatchReg", "left=100, top=100, width=830, height=1000, scrollbars=yes, status=yes");	
}
}

function WatchReg3(id, year, mon, day, no, type)
{
	
	var fm = document.thefrm;
	var auth_rw = fm.auth_rw.value;
	
	var url = "&auth_rw=" + auth_rw
			+ "&start_year=" + year 
			+ "&start_month=" + mon
			+ "&start_day=" + day
			+ "&no=" + no
			+ "&member_id=" + id;

	var SUBWIN="./mon_watch_in.jsp?watch_type="+type+""+ url;

	window.open(SUBWIN, "WatchReg", "left=100, top=100, width=830, height=1000, scrollbars=yes, status=yes");	
}
//-->

//�ϰ�����(20190114)
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
	 	alert("��¥�� �����ϼ���.");
		return;
	}	
	
	var cmData = "";	// 2017.10.26 �߰� | 2017�� 11������ �λ�, �뱸, ����, ���� ������ �������� �̼��� �븮 ���
	
	if(fm.isAfterNov2017.value == "1") {
		cmData = "j";
	}else if( year == 2017 && mon == 10 && (day == 31 || day == 30) ){
		cmData = "j";
	}else {
		cmData = "x";
	}
	
	fm.action='/fms2/watch/watch_sign_all_pop.jsp?cm='+cmData;		
	fm.target='SIGN_ALL';
	
	window.open("", "SIGN_ALL", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	fm.submit();
}
</script>

</HEAD>
<BODY topmargin="15" leftmargin="15" marginwidth="0" marginheight="0">
<form name='thefrm' method='post' action='./watch_jj.jsp'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='isAfterNov2017' 	value='<%=isAfterNov2017%>'>
<table width=100% cellspacing=0 cellpadding=0 border=0 height=100% bgcolor=#FFFFFF>
    <tr>
	    <td align=center valign=top>
    	<!---------------------------------- ����	 ------------------------------------------------->
    	    <table width=100% cellspacing=0 cellpadding=0 border=0>
        		<tr>
        		    <td align=center>
        		    <a href="javascript:go_before2(<%=nyear%>,<%=nmonth%>);"><img src=/acar/images/center/button_b_year.gif align=absmiddle border=0></a>&nbsp;
        			<a href='javascript:go_before(<%=nyear%>,<%=nmonth%>);' class=hh><img src=/acar/images/center/button_b_month.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
        			<b class=sub><%=thisyear%>��&nbsp;<%=thismonth%>��</b>&nbsp;&nbsp;&nbsp;
        			<a href='javascript:go_next(<%=nyear%>,<%=nmonth%>);' class=hh><img src=/acar/images/center/button_n_month.gif align=absmiddle border=0></a>&nbsp;
        			<a href="javascript:go_next2(<%=nyear%>,<%=nmonth%>);"><img src=/acar/images/center/button_n_year.gif align=absmiddle border=0></a> 
        		    </td>					
        		</tr>
    	    </table>
    	<!---------------------------------- �Խ��ǽ���	 ------------------------------------------------->
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
				                <td height=3 class=title1><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();">��ü</td>
			                    <td height=3 class=title1>�λ� �ְ�(����Ʈ)������</td>
								<td height=3 class=title1>�뱸 �ְ�(����Ʈ)������</td>
								<td height=3 class=title1>���� �ְ�(����Ʈ)������</td>
								<td height=3 class=title1>���� �ְ�(����Ʈ)������</td>
								<%if(Integer.parseInt(thisyear) >= 2018 || (Integer.parseInt(thisyear) > 2016) && (Integer.parseInt(thismonth) > 10)){%>
									<td height=3 class=title1>�߰�������</td>
								<%}else{%>
									<td height=3 class=title1 colspan=2>�߰�������</td>
								<%}%>
								
			                </tr>
                			  <%	//���Ϻ� ����
                					for(int i = 1 ; i < last_day + 1 ; i++){
                						day_of_week = calendar.getDayOfWeek(nyear, nmonth, i);
                						tr_color = "#FFFFFF";//����
                						whatday = AddUtil.parseDateWeek("c", day_of_week);
                						if(day_of_week == 1)		tr_color = "#FEE6E6"; //�Ͽ���
                						else if(day_of_week == 7)	tr_color = "#EEF5F9"; //�����
                						if(nday == i)				tr_color = "#E8FEE6"; // ���� ��¥ ����Ʈ
                			  %>
			                <tr align=center bgcolor=<%=tr_color%>>
				                <td id='d<%=i%>'  width=10% align=center>
								<input type="checkbox" name="ch_cd" value="<%if(i < 10){%>0<%}%><%=i%>">
								<a name="<%=thisyear%><%=thismonth%><%=i%>"> 
                                <%if(day_of_week == 1){// �Ͽ��� üũ%>
                                <b class=c><%=i%>��<%=whatday%></b> 
                                <%}else if(day_of_week == 7){// ����� üũ%>
                                <b class=f><%=i%>��<%=whatday%></b> 
                                <%}else{%>
                                <%=i%>��<%=whatday%> 
                                <%}%>
                                </a> 
                                </td>
								<td align='center' width=15%> <!-- �λ� �ְ�(����Ʈ)������ -->
								<% if( vt_size >0){	            
									for(int j=0; j<  vt_size ; j++){
										Hashtable ht = (Hashtable)vt.elementAt(j);
		                			
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
		
										if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
										
									%>
								
								<% if(ht.get("MEMBER_ID5").equals("")){%>
								<%if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchReg2("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "5","3")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
								<%}%>
								<%}else{%>
									<%=ht.get("MEMBER_NM5")%>(����:<%=ht.get("IN_TEL5")%>)&nbsp;
									<a href='javascript:WatchReg3("<%=ht.get("MEMBER_ID5")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>","5","3")' border='0' class=copy>
													<font color="blue"><b>[����]</b></font></a>
									<a href='javascript:SchReg2("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "5","3")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a>
								<%}%>
								
								<%	}
										}
											} 
											}%> 
								</td>
								<td align='center' width=15%> <!-- �뱸 �ְ�(����Ʈ)������ -->
								<% if( vt_size >0){	            
									for(int j=0; j<  vt_size ; j++){
										Hashtable ht = (Hashtable)vt.elementAt(j);
		                			
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
		
										if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
										
									%>
								
								<% if(ht.get("MEMBER_ID6").equals("")){%>
								<%if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchReg2("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "6","7")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
								<%}%>
								<%}else{%>
									<%=ht.get("MEMBER_NM6")%><!--(����:<%=ht.get("IN_TEL6")%>)-->&nbsp;
									<a href='javascript:WatchReg3("<%=ht.get("MEMBER_ID6")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>","6","3")' border='0' class=copy>
													<font color="blue"><b>[����]</b></font></a>
									<a href='javascript:SchReg2("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "6","7")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a>
								<%}%>
								
								<%	}
										}
											} 
											}%> 
								</td>
								<td align='center' width=15%> <!-- ���� �ְ�(����Ʈ)������ -->
								<% if( vt_size_dj >0){	            
									for(int j=0; j<  vt_size_dj ; j++){
										Hashtable ht = (Hashtable)vt_dj.elementAt(j);
		                			
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
		
										if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
										
									%>
								
								<% if(ht.get("MEMBER_ID5").equals("")){%>
								<%if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchReg2("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "5","4")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
								<%}%>
								<%}else{%>
									<%=ht.get("MEMBER_NM5")%>(����:<%=ht.get("IN_TEL5")%>)&nbsp;
									<a href='javascript:WatchReg3("<%=ht.get("MEMBER_ID5")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>","5","4")' border='0' class=copy>
													<font color="blue"><b>[����]</b></font></a>
									<a href='javascript:SchReg2("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "5","4")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a>
								<%}%>
								
								<%	}
										}
											} 
											}%> 
								</td>
								<td align='center' width=15%> <!-- ���� �ְ�(����Ʈ)������ -->
								<% if( vt_size_dj >0){	            
									for(int j=0; j<  vt_size_dj ; j++){
										Hashtable ht = (Hashtable)vt_dj.elementAt(j);
		                			
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
		
										if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
										
									%>
								
								<% if(ht.get("MEMBER_ID6").equals("")){%>
								<%if(day_of_week != 1 && day_of_week != 7){%>
									<a href='javascript:SchReg2("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "6","6")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>			
								<%}%>
								<%}else{%>
									<%=ht.get("MEMBER_NM6")%><!--(����:<%=ht.get("IN_TEL6")%>)-->&nbsp;
									<a href='javascript:WatchReg3("<%=ht.get("MEMBER_ID6")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>","6","4")' border='0' class=copy>
													<font color="blue"><b>[����]</b></font></a> 
									<a href='javascript:SchReg2("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>", "6","6")'><img src=/acar/images/center/button_in_bg.gif border=0 align=absmiddle></a>
								<%}%>
								
								<%	}
										}
											} 
											}%> 
								</td>
								
								<%if(Integer.parseInt(thisyear) >= 2018 || (Integer.parseInt(thisyear) > 2016) && (Integer.parseInt(thismonth) > 10)){%>
								<td align='center' width=40%>		<!-- 2017�� 11������ ���� �߰������� width ����-->
								<%}else if( (Integer.parseInt(thisyear) == 2017) && (Integer.parseInt(thismonth) == 10) && (i > 29) ){%><!-- 2017�� 10�� 30�� 31�� ó�� -->
								<td align='center' width=40% colspan="2">
								<%}else{%>
								<td align='center' width=12%>		<!-- 2017�� 11�� ���� �λ�, �뱸 �߰������� width ����-->
								<%}%>
								
				                <% 
				                String day = String.format("%02d", i);
				                if( vt_size >0){
				                	int count = 0;
									for(int j=0; j<  vt_size ; j++){
										Hashtable ht = (Hashtable)vt.elementAt(j);
		                			
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
											++count;
										if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
									%>
									<% if(ht.get("MEMBER_ID").equals("")){%>
											<a href='javascript:SchReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
									<%}else {%>
										<%=ht.get("MEMBER_NM")%>
											<%if(ht.get("WATCH_TIME_ED").equals("") && ht.get("WATCH_SIGN").equals("")){%>
												<a href='javascript:WatchReg2("<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy>
											[�����ۼ�] </a>
											<%}else if(!ht.get("WATCH_TIME_ED").equals("") && ht.get("WATCH_SIGN").equals("")){%>
												<a href='javascript:WatchReg("<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy>
											<font color="red"><b>[�����û]</b></font> </a>
											<%}else{%>
												<a href='javascript:WatchReg("<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy>
												<font color="blue"><b>[��������]</b></font></a>
											<%}%>&nbsp;&nbsp;&nbsp; 
									 <a href='javascript:SchDel( "<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy><img src="/acar/images/center/button_in_cancel.gif" border="0" align="absmiddle"></a>
									<%  if(!ht.get("WATCH_CH_NM").equals("")){%>
										<% if(!ht.get("WATCH_CH_NM").equals( String.valueOf(ht.get("MEMBER_NM")) ) ){%>	
											�� &nbsp;&nbsp;&nbsp;��ü�ٹ��� [<%=ht.get("WATCH_CH_NM")%>]
										<%}%>
									<%  }%>	
									<%}%>
								<%	}
            						}
								}
								// DB�� �ش� ���ڿ� ���� ���� �ٹ� ���ڵ尡 ���� ��쿡�� �߰� ������ �׸� ��� ��ư ���� 2019.12.30.
								if(count == 0) {
								%>
									<a href='javascript:SchReg("<%=day_of_week%>", "<%=thisyear%>", "<%=thismonth%>", "<%=day%>", <%=true%>)'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
								<% }
								} else {%>
									<a href='javascript:SchReg("<%=day_of_week%>", "<%=thisyear%>", "<%=thismonth%>", "<%=day%>", <%=true%>)'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
								<%} %>    
                                </td>
                                
                                <%if(Integer.parseInt(thisyear) >= 2018 || (Integer.parseInt(thisyear) > 2016) && (Integer.parseInt(thismonth) > 10) || (Integer.parseInt(thisyear) == 2017) && (Integer.parseInt(thismonth) == 10) && (i > 29) ){}else{%>
                                <td align='center' width=12%> 	<!-- 2017�� 11�� ���� ����, ���� �߰������� -->			                            
				                  	
				                <% if( vt_size_dj >0){	            
									for(int j=0; j<  vt_size_dj ; j++){
										Hashtable ht = (Hashtable)vt_dj.elementAt(j);
		                			
		   								if(Integer.parseInt(AddUtil.toString(ht.get("START_DAY"))) == i){
		
										if(ht.get("START_YEAR").equals(thisyear) && ht.get("START_MON").equals(thismonth)){
										
									%>
									<% if(ht.get("MEMBER_ID").equals("")){%>
														<a href='javascript:SchReg("<%=day_of_week%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")'><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;
									<%}else {%>
										<%=ht.get("MEMBER_NM")%>
												<%if(ht.get("WATCH_TIME_ED").equals("") && ht.get("WATCH_SIGN").equals("")){%>
													<a href='javascript:WatchReg2("<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy>
												[�����ۼ�] </a>
												<%}else if(!ht.get("WATCH_TIME_ED").equals("") && ht.get("WATCH_SIGN").equals("")){%>
													<a href='javascript:WatchReg("<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy>
												<font color="red"><b>[�����û]</b></font> </a>
												<%}else{%>
													<a href='javascript:WatchRegBeforeNov2017("<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy>
													<font color="blue"><b>[��������]</b></font></a>
												<%}%>&nbsp;&nbsp;&nbsp;
									<a href='javascript:SchDel( "<%=ht.get("MEMBER_ID")%>", "<%=ht.get("START_YEAR")%>", "<%=ht.get("START_MON")%>", "<%=ht.get("START_DAY")%>")' border='0' class=copy><img src="/acar/images/center/button_in_cancel.gif" border="0" align="absmiddle"></a>
									<%  if(!ht.get("WATCH_CH_NM").equals("")){%>
										<% if(!ht.get("WATCH_CH_NM").equals( String.valueOf(ht.get("MEMBER_NM")) ) ){%>	
											�� &nbsp;&nbsp;&nbsp;��ü�ٹ��� [<%=ht.get("WATCH_CH_NM")%>]
										<%}%>
									<%  }%>	
									<%}%>
											<%	}
            									}
								} }%>       <!-- vt_size end -->     										
                                </td>
                                <%} %>

			                </tr>
			            <%} %>  <!--���ϳ� -->
			            </table>
		            </td>
		        </tr>
	        </table>
	    <!---------------------------------- �Խ��ǳ�	 ------------------------------------------------->
	    </td>		
  </tr>

    <tr>
        <td></td>
    </tr>  

  <tr height='30'>
    <td align="center">
	  <%if(nm_db.getWorkAuthUser("������",myid) || nm_db.getWorkAuthUser("������",myid)){%>
	  <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg_ij.gif border=0 align=absmiddle></a>
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <a href="javascript:save_del()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cancel_ij.gif border=0 align=absmiddle></a>
	  <%}%>
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <%if((user_id.equals("000026")||user_id.equals("000052")||user_id.equals("000053")||user_id.equals("000054")||user_id.equals("000096")||user_id.equals("000219")) || nm_db.getWorkAuthUser("������",myid)){ %>
	  <input type="button" class="button" value="�ϰ�����" onclick="javascript:sign_all();">
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
