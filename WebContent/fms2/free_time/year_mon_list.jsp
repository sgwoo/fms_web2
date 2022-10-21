<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.user_mng.*" %>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	LoginBean login = LoginBean.getInstance();
	
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept = request.getParameter("dept")==null?"":request.getParameter("dept");
	String sch_chk = request.getParameter("sch_chk")==null?"":request.getParameter("sch_chk");
	String today = request.getParameter("today")==null?"":request.getParameter("today");
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "10", "01", "01");
	
	Vector vt = new Vector();
	String q="";
//System.out.println(today);
	if(dt.equals("1")){
	 vt = ft_db.Year_Mon_List(dept, sch_chk, today, gubun);
	 q="1";
	}else{
	 vt = ft_db.Year_Mon_List2(dept, sch_chk, st_year, st_mon, gubun);
	 q="2";
	}
	
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

function free_close()
{
	
	self.close();
	window.close();
}
	
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='user_id' value=''>

<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1> 인사관리 > 근태관리 > <span class=style5>휴가리스트</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td align='right'>
	
			<a href="javascript:free_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 cellpadding=0 width=100%>
				<tr> 
					<td class="title" width=5%>연번<%=q%></td>
					<td class="title" width=8%%>구분</td>
					<td class="title" width=10%>휴가자</td>
					<td class="title" width=17%>휴가기간</td>
					<td class="title" width=10%>요일</td>
					<td class="title" width=10%>등록일자</td>
					<td class="title" width=10%>휴가구분</td>
					<td class="title" width=20%>내용</td>
					<td class="title" width=10%>취소요청</td>
					
				</tr>
			</table>
		</td>
		<td width=17>&nbsp;</td>
	</tr>
	<tr> 
		<td class="line">
			<table  width="100%" border="0" cellspacing="1" cellpadding="0">
	<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
				<tr>
					 
				    <td align="center" width="5%"><%= i+1 %></td>
				    <td align="center" width="8%"><% if(!ht.get("CM_CHECK").equals("")&&!ht.get("CANCEL").equals("Y")){%>완료<%}else if(!ht.get("CM_CHECK").equals("") && ht.get("CANCEL").equals("Y") && !ht.get("C_CHECK").equals("") ){%><font color='red'>취소</font><%}else if (!ht.get("CM_CHECK").equals("Y")  && !ht.get("CANCEL").equals("Y") ) {%>대기<%}else if (!ht.get("C_CHECK").equals("Y")  && ht.get("CANCEL").equals("Y") ) {%>취소대기<% }else{%><%}%></td>
				    <td align="center" width="10%"><%=ht.get("USER_NM")%></td>
				    <td align="center" width="17%"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DATE")))%> ~ <%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DATE")))%></td>
				    <td align="center" width="10%"><%= ht.get("DAY_NM")%>~<%= ht.get("DAY_NM2") %></td> 
				    <td align="center" width="10%"><%= AddUtil.ChangeDate2((String)ht.get("REG_DT")) %></td>
				    <td align="center" width="10%"><%=ht.get("TITLE")%></td>
				    <td align="left"   width="20%">&nbsp;<%=Util.subData(String.valueOf(ht.get("CONTENT")),70)%></td>
				    <td align="center" width="10%"></td>
				    
				</tr>
	<% 	}
	}else{ %>
				<tr> 
	    			<td colspan="5" align="center">사용내역이 없습니다.</td>
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
