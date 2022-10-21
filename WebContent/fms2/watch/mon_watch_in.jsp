<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*,acar.watch.*, acar.attend.*, acar.car_sche.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>	

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");

	String reg_dt = "";
	
	String member_id 	= request.getParameter("member_id")==null?"":request.getParameter("member_id"); //당직자

	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	String start_day 	= request.getParameter("start_day")==null?"":request.getParameter("start_day");
	String watch_type = request.getParameter("watch_type")==null?"":request.getParameter("watch_type");
	//System.out.println("### w t ");
	//System.out.println(watch_type);
	String watch_ot 	= "";
	String watch_gtext 	= "";
	
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String cm 	= request.getParameter("cm")==null?"":request.getParameter("cm");
	String no 	= request.getParameter("no")==null?"":request.getParameter("no");
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//등록자
	UsersBean user_bean = umd.getUsersBean(member_id);
	reg_dt = AddUtil.getTimeYMDHMS();
	
	Vector vt = wc_db.WatchScheMon(start_year,start_month,start_day, member_id, no, watch_type);
	
	String gj_chk= "";
	String gj_yc = "";
	

%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src="../../include/common.js"></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--




//길이점검
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


//목록
function go_to_list()
{
	var fm = document.form1;
	fm.action = "watch.jsp";
	fm.target = 'd_content';
	fm.submit();
}	

//등록
function watch_reg()
{
	var fm = document.form1;
	fm.cmd.value = "i";
	fm.watch_type.value = <%=watch_type%>;
	//console.log(watch_type);
//	fm.watch_type.value = watch_type;

	fm.action = "mon_watch_in_a.jsp";
	fm.target="i_no";
	fm.submit();
}

//start time in
function st_time_in()
{
	var fm = document.form1;
	fm.cmd.value = "s";

	fm.action='watch_in_a.jsp';		
	fm.target='i_no';
	fm.submit();
}

//end time in
function ed_time_in()
{
	var fm = document.form1;
	fm.cmd.value = "e";

	fm.action='watch_in_a.jsp';		
	fm.target='i_no';
	fm.submit();
}

// 결재
function watch_gj()
{
	var fm = document.form1;
	
	fm.cmd.value="gj";
			
		if(confirm('팀장님 결재하시겠습니까?')){	
			fm.action='watch_in_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}						
}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
<!--
.style10 {
	font-size: 30px;
	font-family: "바탕", "궁서", AppleMyungjo;
	font-weight: bold;
}
-->
</style>
</head>
<body onload="javascript:document.form1.title.focus()">
<form action="mon_watch_in_a.jsp" name="form1" method="post" >
<input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 		value='<%=user_id%>'>
<input type='hidden' name='start_year' 		value='<%=start_year%>'>
<input type='hidden' name='start_month' 	value='<%=start_month%>'>
<input type='hidden' name='start_day' 		value='<%=start_day%>'>        
<input type='hidden' name='user_nm' 		value='<%=user_bean.getUser_nm()%>'>
<input type='hidden' name='member_id' 		value='<%=member_id%>'>
<input type="hidden" name="cmd" 			value="">
<input type="hidden" name="watch_type" 			value="">
<input type="hidden" name="cm" 				value="<%=cm%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>

<%if(vt.size()>0){	            
	for(int j=0; j< vt.size(); j++){
		Hashtable ht = (Hashtable)vt.elementAt(j);
		
		gj_chk = String.valueOf(ht.get("WATCH_SIGN"));
		gj_yc = String.valueOf(ht.get("WATCH_TIME_ED"));
%>	
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan="2" >
			<table width="100%"   border=0 cellpadding=0 cellspacing=0 >
				<tr>
					<td width="100%" align="center" class="style10">주 &nbsp; 간 &nbsp; 당 &nbsp; 직 &nbsp; 일 &nbsp; 지</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>			
				<tr>
					<td width="25%" class="title">작성자</td>
					
					<td width="25%" align="center"><%=ht.get("MEMBER_NM")%></td> 
					<td width="25%" class="title"><div align="center">부서</div></td>
					<td width="25%" align="center"><div align="center"><%=user_bean.getDept_nm()%></div></td>				
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>		
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan="4"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> 당직일지 내용</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100% >
 				<tr>
					<td colspan="4" align="center"><textarea name="watch_gtext" cols='120' rows='50' value=""><%=ht.get("WATCH_GTEXT")%></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
<%}
}%>		
	<tr>
		<td colspan='4' align='right'>
			<a href="javascript:watch_reg()"><img src="/acar/images/center/button_save.gif"  align="absmiddle" border="0"></a>&nbsp;&nbsp;
			<a href='javascript:window.close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0"  frameborder="0" noresize> </iframe>
</body>
</html>