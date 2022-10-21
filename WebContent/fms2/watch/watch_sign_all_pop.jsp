<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*,acar.watch.*, acar.attend.*, acar.car_sche.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>	

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String cm 	= request.getParameter("cm")==null?"":request.getParameter("cm");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	WatchDatabase wc_db = WatchDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	String reg_dt = "";
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	String start_day	= "";
	String target_id	= "";
	String watch_type	= request.getParameter("watch_type")==null?"":request.getParameter("watch_type");	//본사
	
	String ch_cd[]		= request.getParameterValues("ch_cd");
	String param 		= "";
	int vid_size 		= ch_cd.length;
	int cnt = 0;
	
	if(cm.equals("s")){		
		target_id = nm_db.getWorkAuthUser("본사관리팀장"); //관리팀장
		watch_type = "1";
	}else if(cm.equals("x")){
		target_id = "000219"; //000118(이수재 대리)->류선
		//if(sender_bean.getDept_id().equals("0007")||sender_bean.getDept_id().equals("0011")){
			watch_type = "3";	
		//}else {
		//	watch_type = "4";
		//}
	}else if(cm.equals("b")){		
		target_id = "000053"; //000053(제인학)
		watch_type = "3";
	}else if(cm.equals("d")){			
		target_id = "000052"; //000052(박영규)
		watch_type = "4";
	}else if(cm.equals("s2")){			
		target_id = nm_db.getWorkAuthUser("본사관리팀장"); //관리팀장
		watch_type = "5";
	}else if(cm.equals("j")){			
		target_id = "000219"; //000118(이수재 대리)->류선
		watch_type = "3";
	}else if(cm.equals("g")){			
		target_id = "000054"; //윤영탁대리
		watch_type = "7";
	}else if(cm.equals("i1")){			
		target_id = nm_db.getWorkAuthUser("본사관리팀장"); //관리팀장
		watch_type = "8";
	}
	Vector settle_list = new Vector();
	for(int i=0;i < vid_size;i++){
		Hashtable ht = new Hashtable();
		start_day = ch_cd[i];
		param += start_day+",";
		ht = wc_db.getDangjikSettleList(start_year,start_month,start_day,watch_type);
		settle_list.add(ht);
	}
	int list_size = settle_list.size();

%>
<html>
<head><title>FMS</title>

<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
// 결재
function watch_gj_all(){
	var fm = document.form1;
	fm.cmd.value="gj";
	if(confirm('팀장님 결재하시겠습니까?')){	
		fm.action='watch_sign_all_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}						
}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.style10 {font-size: 30px;font-family: "바탕", "궁서", AppleMyungjo;font-weight: bold;}
</style>
</head>
<body>
<form action="watch_sign_all_a.jsp" name="form1" method="post" >
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='start_year' 	value='<%=start_year%>'>
<input type='hidden' name='start_month' value='<%=start_month%>'> 
<input type="hidden" name="cmd" 		value="<%=cmd%>">
<input type="hidden" name="cm" 			value="<%=cm%>">
<table border="0" cellspacing="0" cellpadding="0" width=880>
	<tr>
		<td class=h ></td> 
	</tr>
	<tr>
		<td colspan="2" >
			<table width="100%"   border=0 cellpadding=0 cellspacing=0 >
				<tr>
					<td width="80%" align="center" class="style10">당&nbsp;직&nbsp;일&nbsp;지&nbsp; 일&nbsp;괄&nbsp;결&nbsp;제</td>
					<td width="20%">
						<div align="right">
							<table width=100%  border=1 cellpadding=0 cellspacing=0 >
								<tr>
									<td class="title">결재</td>
								</tr>
								<tr>
									<td align="center">
										<table width="76%" height="60" border=0 cellpadding=0 cellspacing=0>
											<tr>
												<td align="center">
											<% if (cm.equals("s")||cm.equals("s2") ||cm.equals("i1")) { %>
													<td align="center">고객지원팀장<br>김광수<br>									
											<% } else if (cm.equals("x") ) { %>
												<%-- <%if(user_bean.getDept_id().equals("0007")){%>
													<td align="center">부산지점장<br>제인학<br>							
												<%}else if(user_bean.getDept_id().equals("0008")){%>
													<td align="center">대전지점장<br>박영규<br>
												<%}else if(user_bean.getDept_id().equals("0010")){%>
													<td align="center">광주지점<br>이수재<br>
												<%}else if(user_bean.getDept_id().equals("0011")){%>
													<td align="center">대구지점<br>윤영탁<br>
												<%}else{%> --%>
													<td align="center">에러<br>홍길동<br>
												<%-- <%}%> --%>
											<% } else if (cm.equals("b") ) { %>											
													<td align="center">부산지점장<br>제인학<br>
											<% } else if (cm.equals("d") ) { %>											
													<td align="center">대전지점장<br>박영규<br>
											<% } else if (cm.equals("j") ) { %>
													<td align="center">광주지점<br>이수재<br>
											<% } else if (cm.equals("g") ) { %>											
													<td align="center">대구지점<br>윤영탁<br>													
											<% } %>
											
											<!-- 결제버튼 VV부터 이어서~ -->
											
											
													<a href='javascript:watch_gj_all()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align=absmiddle border=0></a>
												</td>
											</tr>
										</table>
									</td> 
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=880>			
				<tr>
					<td width="5%" class="title">연번</td>
					<td width="35%" class="title">당직일</td>
					<td width="30%" class="title">당직자</td>
					<td width="30%" class="title"><div align="center">지급 당직비</div></td>
				</tr>
<%	if(list_size > 0){
		for(int j=0; j<list_size; j++){
			Hashtable ht2 = (Hashtable)settle_list.elementAt(j);
			if(!String.valueOf(ht2.get("WATCH_TIME_ED")).equals("") && String.valueOf(ht2.get("WATCH_SIGN")).equals("")){
				cnt++;
				int day_of_week = calendar.getDayOfWeek(Integer.parseInt(String.valueOf(ht2.get("START_YEAR"))), Integer.parseInt(String.valueOf(ht2.get("START_MON"))), Integer.parseInt(String.valueOf(ht2.get("START_DAY"))));
				String tr_color = "#FFFFFF";//평일
				String whatday = AddUtil.parseDateWeek("c", day_of_week);
				if(day_of_week == 1)		tr_color = "#FEE6E6"; //일요일
				else if(day_of_week == 7)	tr_color = "#EEF5F9"; //토요일
			%>	
				<tr <%if(day_of_week==1||day_of_week==7){%>style="font-weight: bold;"<%} %>>
					<td align="center" style="background-color:<%=tr_color%>;"><%=cnt%></td>
					<td align="right" style="background-color:<%=tr_color%>; padding-right:120px;">
						<%if(j==0){%><%=ht2.get("START_YEAR")%>년 
							<%if(Integer.parseInt(String.valueOf(ht2.get("START_MON")))<10){ %>
								<%=String.valueOf(ht2.get("START_MON")).replace("0"," ")%>월  
							<%}else{ %>
								<%=ht2.get("START_MON")%>월 
							<%} %>	 
						<%}%>
						<%if(Integer.parseInt(String.valueOf(ht2.get("START_DAY")))<10){ %>
							<%=String.valueOf(ht2.get("START_DAY")).replace("0"," ")%>일
						<%}else{ %>
							<%=ht2.get("START_DAY")%>일 
						<%}%>
						(<%=String.valueOf(ht2.get("DAY_NM")).substring(0,1)%>)
						<input type="hidden" name="s_day" value="<%=ht2.get("START_DAY")%>">
					</td>
					<td align="center" style="background-color:<%=tr_color%>;"><%if(ht2.get("WATCH_CH_NM").equals("")){%><%=ht2.get("MEMBER_NM")%><%}else{%><%=ht2.get("WATCH_CH_NM")%><%}%></td>
					<td align="center" style="background-color:<%=tr_color%>;"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("WATCH_AMT")))%> 원</td>
				</tr>
<%			}%>
	<%	}%>	
				
<%	}else{	%>
				<tr><td colspan="7" align="center">결제할 내역이 없습니다.</td></tr>
<%	} %>			
			</table>
		</td>
	</tr>
	<tr><td> &nbsp;결제요청 상태가 아닌 건(일지작성 전/결제완료)은 결제리스트에서 자동 제외 되었습니다.</td></tr>	
	<tr>	
		<td align='right'>
			<span style="text-align: left;"></span>
			<a href='javascript:window.close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0"  frameborder="0" noresize> </iframe>
</body>
</html>