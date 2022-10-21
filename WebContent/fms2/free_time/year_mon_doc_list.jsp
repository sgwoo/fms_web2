<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.user_mng.*" %>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");
	
	Vector vt = ft_db.getFreeTimeStatList(dt, st_year, st_mon, dept_id, gubun1, gubun2);
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
					<td class="title" width=5%>연번</td>
					<td class="title" width=10%>구분</td>
					<td class="title" width=10%>휴가자</td>
					<td class="title" width=25%>휴가기간</td>
					<td class="title" width=10%>등록일자</td>
					<td class="title" width=15%>휴가구분</td>
					<td class="title" width=25%>내용</td>
				</tr>
	<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
				<tr>
					 
				    <td align="center" <%if(String.valueOf(ht.get("ST")).equals("취소")){%>class=is<%}%>><%= i+1 %></td>
				    <td align="center" <%if(String.valueOf(ht.get("ST")).equals("취소")){%>class=is<%}%>><%=ht.get("ST")%></td>
				    <td align="center" <%if(String.valueOf(ht.get("ST")).equals("취소")){%>class=is<%}%>><%=ht.get("USER_NM")%></td>
				    <td align="center" <%if(String.valueOf(ht.get("ST")).equals("취소")){%>class=is<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DATE")))%>(<%=ht.get("S_DAY_NM")%>) ~ <%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DATE")))%>(<%=ht.get("E_DAY_NM")%>) <%=ht.get("CNT")%>일</td>
				    <td align="center" <%if(String.valueOf(ht.get("ST")).equals("취소")){%>class=is<%}%>><%= AddUtil.ChangeDate2((String)ht.get("REG_DT")) %></td>
				    <td align="center" <%if(String.valueOf(ht.get("ST")).equals("취소")){%>class=is<%}%>><%=ht.get("TITLE")%></td>
				    <td align="left" <%if(String.valueOf(ht.get("ST")).equals("취소")){%>class=is<%}%>>&nbsp;<%=ht.get("CONTENT")%></td>
				</tr>
	<% 	}
	}else{ %>
				<tr> 
	    			<td colspan="7" align="center">사용내역이 없습니다.</td>
				</tr>
	<% } %>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
