<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, java.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String start_dt 	= request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = new Vector();
	vt = pk_db.getParkWashList(gubun1, gubun2, start_dt, end_dt, s_kd, t_wd, sort);
	int vt_size = vt.size();
	
	long total_amt = 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	// Title 고정 
	function setupEvents() {
		window.onscroll = moveTitle;
		window.onresize = moveTitle ;
	}
	
	function moveTitle() {
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;
	}
	
	function init() {
		setupEvents();
	}
	
	//팝업윈도우 열기	
	function park_wash_modify(park_seq, car_no, car_nm, users_comp, park_id, park_mng, wash_dt, wash_pay, after_day, today) {
		if (after_day == today) {
			alert("등록일을 기준으로 15일이 경과되어 수정이 불가능 합니다.");
			return;
		}
		window.open("park_w_i.jsp?park_seq="+park_seq+"&car_no="+car_no+"&car_nm="+car_nm+"&users_comp="+users_comp+"&park_id="+park_id+"&park_mng="+park_mng+"&wash_dt="+wash_dt+"&wash_pay="+wash_pay, "세차현황 수정", "left=100, top=20, width=1200, height=200, scrollbars=auto");
	}
	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
//-->
</script>

<style>

.listnum2 a:link {color:#ff0000; text-decoration:underline;} 
.listnum2 a:visited {color:#ff0000; text-decoration:underline;} 
.listnum2 a:hover {color:#ff0000; text-decoration:underline;} 

</style>

</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='start_dt' value='<%=start_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='del' value=''>
<input type='hidden' name='pr_id' value=''>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
		<td class=line2 colspan="2"></td>
	</tr>
	<tr id='tr_title' style='position:relative;z-index:1;'>
		<td class='line' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
				<tr> 
					<td class='title' width="5%">선택</td>
					<td class='title' width="3%">연번</td>
					<td class='title' width="8%">차량번호</td>
					<td class='title' width="10%">차종</td>
					<td class='title' width="10%">주차장</td>
					<td class='title' width="5%">등록자</td>
					<td class='title' width="10%">세차일자</td>
					<td class='title' width="10%">등록일</td>
					<td class='title' width="10%">세차비용</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='line' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<!-- 본문 -->
				<% 
				    if( vt_size > 0) {
						for(int i = 0 ; i < vt_size ; i++) {
							Hashtable ht = (Hashtable)vt.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("WASH_PAY")));
				%>
				<tr>
					<td align="center" width="5%">
					<% if (nm_db.getWorkAuthUser("전산팀",user_id) || user_id.equals("000058")) { %>
								<input type="checkbox" class="pr" name="pr" value="<%=ht.get("SEQ")%>">
					<% } else if (ht.get("REG_MONTH").equals(ht.get("TODAY_MONTH"))) { %>
							<% if (ht.get("REG_ID").equals(user_id)) { %>
									<input type="checkbox" class="pr" name="pr" value="<%=ht.get("SEQ")%>" <% if (ht.get("AFTER_DAY").equals(ht.get("TODAY"))) { %> disabled <% } %>>							
							<% } else { %>
									<input type="checkbox" class="pr" name="pr" value="<%=ht.get("SEQ")%>" disabled>
							<% } %>
					<% } else { %>
								<input type="checkbox" class="pr" name="pr" value="<%=ht.get("SEQ")%>" disabled>
					<% } %>
					</td>
					<td align="center" width="3%"><%=i+1%></td>
					<td align="center" width="8%">
					<% if (nm_db.getWorkAuthUser("전산팀",user_id) || user_id.equals("000058")) { %>
								<a href="javascript:park_wash_modify('<%=ht.get("SEQ")%>', '<%=ht.get("CAR_NO")%>', '<%=ht.get("CAR_NM")%>', '<%=ht.get("USERS_COMP")%>', '<%=ht.get("PARK_ID")%>', '<%=ht.get("PARK_MNG")%>', '<%=ht.get("WASH_DT")%>', '<%=ht.get("WASH_PAY")%>' , '<%=ht.get("AFTER_DAY")%>' , '0')" onMouseOver="window.status=''; return true" hover><%=Util.subData(String.valueOf(ht.get("CAR_NO")), 10)%></a>
					<% } else if (ht.get("REG_MONTH").equals(ht.get("TODAY_MONTH"))) { %>
							<% if (ht.get("REG_ID").equals(user_id)) { %>
									<a href="javascript:park_wash_modify('<%=ht.get("SEQ")%>', '<%=ht.get("CAR_NO")%>', '<%=ht.get("CAR_NM")%>', '<%=ht.get("USERS_COMP")%>', '<%=ht.get("PARK_ID")%>', '<%=ht.get("PARK_MNG")%>', '<%=ht.get("WASH_DT")%>', '<%=ht.get("WASH_PAY")%>' , '<%=ht.get("AFTER_DAY")%>' , '<%=ht.get("TODAY")%>')" onMouseOver="window.status=''; return true" hover><%=Util.subData(String.valueOf(ht.get("CAR_NO")), 10)%></a>
							<% } else { %>
									<%=Util.subData(String.valueOf(ht.get("CAR_NO")), 10)%>
							<% } %>
					<% } else { %>
								<%=Util.subData(String.valueOf(ht.get("CAR_NO")), 10)%>
					<% } %>
					</td>
					<td align="center" width="10%"><%=ht.get("CAR_NM")%></td>
					<td align="center" width="10%"><%=ht.get("PARK_NM")%></td>
					<td align="center" width="5%"><%=ht.get("USER_NM")%></td>
					<td align="center" width="10%"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("WASH_DT")))%></td>
					<td align="center" width="10%"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
					<td align="center" width="10%"><%=AddUtil.parseDecimal(ht.get("WASH_PAY"))%></td>
				</tr>
				<%  }
  					} else { %>
				<tr height="40">
					<td align='center' colspan="8">데이터가 없습니다</td>
				</tr>
			 <% } %>
				<!-- 합계 -->
				<% if (vt_size > 0) { %>
				<tr style="height: 30px;">
					<td align="left" colspan="6"></td>
					<td align="center" class='title'>합계</td>
					<td align="center" class='title'>총 <%=vt_size%> 건</td>
					<td align="center" colspan="2" class='title'><%=AddUtil.parseDecimal(total_amt)%> 원 (vat포함)</td>
				</tr>
				<%}	%>
			</table>
	</tr>
</table>
</form>
</body>
</html>


