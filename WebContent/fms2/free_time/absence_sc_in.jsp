<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.user_mng.* " %>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	LoginBean login = LoginBean.getInstance();
	
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	

	int count = 0;
	
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_step = request.getParameter("doc_step")==null?"":request.getParameter("doc_step");

	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String gubun3 	= request.getParameter("gubun3")==null?"8":request.getParameter("gubun3");
	
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "10", "01", "01");
	

	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	int year =AddUtil.getDate2(1);
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));

	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");

	Vector vt = ft_db.absence_List(st_year, st_mon, user_id, gubun, dt, gubun3, ref_dt1, ref_dt2);
	int vt_size = vt.size();
	
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--

function input_reg(doc_no, id, chk)	{
		var SUBWIN="absence_i.jsp?auth_rw=<%=auth_rw%>&doc_no="+doc_no+"&user_id="+id+"&chk="+chk;	
		window.open(SUBWIN, "input_reg", "left=100, top=50, width=620, height=500, scrollbars=yes");
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='user_id' value=''>
<input type='hidden' name='doc_no' value=''>
<input type='hidden' name='s_year' value=''>
<input type='hidden' name='s_month' value=''>
<input type='hidden' name='s_day' value=''>
<input type="hidden" name="cmd" value="">	
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr> 
		<td class="line">
			<table  width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr> 
					<td class="title" width=4% rowspan="3">연번</td>
					<td class="title" width=8%% rowspan="3">구분</td>
					<td class="title" width=5% rowspan="3">성명</td>
					<td class="title" width=8% rowspan="3">부서명</td>
					<td class="title" width=21% colspan="3">휴가기간</td>
					<td class="title" width=5% rowspan="3">결재자</td>
					<td class="title" width=35% colspan="5">보험료납부유예(등록/수정)</td>
					<td class="title" width=14% colspan="2">보험료납부재개</td>
				</tr>
				<tr>
					<td class="title" rowspan="2">시작일</td>
					<td class="title" rowspan="2">종료일</td>
					<td class="title" rowspan="2">기간(월)</td>
					<td class="title" rowspan="2">보험구분</td>
					<td class="title" rowspan="2">시작일</td>
					<td class="title" rowspan="2">종료일</td>
					<td class="title" colspan="2">신고서접수</td>
					<td class="title" colspan="2">신고서접수</td>
				</tr>
				<tr>
					<td class="title">처리일자</td>
					<td class="title">담당자</td>
					<td class="title">처리일자</td>
					<td class="title">담당자</td>
				</tr>
	<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	
	Hashtable pt1= ft_db.absence_one("KK", (String)ht.get("DOC_NO"));
	Hashtable pt2= ft_db.absence_one("KM", (String)ht.get("DOC_NO"));
	
	%>
				<tr>
				    <td align="center" rowspan="2"><%= i+1 %></td>
				    <td align="center" rowspan="2"><%=ht.get("SCH_CHK")%><br/><%=ht.get("TITLE")%></td>
				    <td align="center" rowspan="2"><a href="javascript:input_reg('<%=ht.get("DOC_NO")%>','<%=ht.get("USER_ID")%>','I')"><%=ht.get("USER_NM")%></a></td>
					<td align="center" rowspan="2"><%=ht.get("DEPT_NM")%></td>
				    <td align="center" rowspan="2"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DATE")))%></td>
				    <td align="center" rowspan="2"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DATE")))%></td> 
				    <td align="center" rowspan="2"><%=ht.get("M")%></td>
				    <td align="center" rowspan="2"><%=ht.get("OK_MNG")%></td>
				    <td align="center">건강보험</td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt1.get("START_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt1.get("START_DT"))).equals("null")){%><%}else{%><%=AddUtil.ChangeDate2(String.valueOf(pt1.get("START_DT")))%><%}%></td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt1.get("START_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt1.get("START_DT"))).equals("null")){%><%}else{%><%=AddUtil.ChangeDate2(String.valueOf(pt1.get("END_DT")))%><%}%></td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt1.get("START_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt1.get("START_DT"))).equals("null")){%><%}else{%><%=AddUtil.ChangeDate2(String.valueOf(pt1.get("JSE_DT")))%><%}%></td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt1.get("JSE_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt1.get("JSE_DT"))).equals("null")){%><%}else{%><%=pt1.get("JSE_NM")%><%}%></td>
					<td align="center"><a href="javascript:input_reg('<%=ht.get("DOC_NO")%>','<%=ht.get("USER_ID")%>','II')"><%if(AddUtil.ChangeDate2(String.valueOf(pt1.get("JSS_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt1.get("JSS_DT"))).equals("null")){%><img src="/acar/images/center/button_in_reg.gif" border=0 align=absmiddle><%}else{%><%=AddUtil.ChangeDate2(String.valueOf(pt1.get("JSS_DT")))%><%}%></a></td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt1.get("JSS_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt1.get("JSS_DT"))).equals("null")){%><%}else{%><%=pt1.get("JSS_NM")%><%}%></td>
				</tr>
				<tr>
					<td align="center">국민연금</td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt2.get("START_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt2.get("START_DT"))).equals("null")){%><%}else{%><%=AddUtil.ChangeDate2(String.valueOf(pt2.get("START_DT")))%><%}%></td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt2.get("END_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt2.get("END_DT"))).equals("null")){%><%}else{%><%=AddUtil.ChangeDate2(String.valueOf(pt2.get("END_DT")))%><%}%></td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt2.get("JSE_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt2.get("JSE_DT"))).equals("null")){%><%}else{%><%=AddUtil.ChangeDate2(String.valueOf(pt2.get("JSE_DT")))%><%}%></td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt2.get("JSE_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt2.get("JSE_DT"))).equals("null")){%><%}else{%><%=pt2.get("JSE_NM")%><%}%></td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt2.get("JSS_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt2.get("JSS_DT"))).equals("null")){%><%}else{%><%=AddUtil.ChangeDate2(String.valueOf(pt2.get("JSS_DT")))%><%}%></td>
					<td align="center"><%if(AddUtil.ChangeDate2(String.valueOf(pt2.get("JSS_DT"))).equals("")||AddUtil.ChangeDate2(String.valueOf(pt2.get("JSS_DT"))).equals("null")){%><%}else{%><%=pt2.get("JSS_NM")%><%}%></td>
				</tr>

	<% 	}
	}else{ %>
				<tr> 
	    			<td colspan="15" align="center">사용내역이 없습니다.</td>
				</tr>
	<% } %>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</body>
</html>
