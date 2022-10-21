<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.tour.*" %>
<jsp:useBean id="t_db" scope="page" class="acar.tour.TourDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String yes = request.getParameter("yes")==null?"N":request.getParameter("yes");
	int st_year = request.getParameter("st_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("st_year"));
	
	Vector vt = t_db.tourlist(s_kd, t_wd, yes, st_year);
	int vt_size = vt.size();
			
	int gs_year = 0;
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<script language="JavaScript">
<!--

function WorldTour(user_id,auth_rw)
{
	var SUBWIN="tour_c.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "Tour", "left=100, top=100, width=800, height=600, scrollbars=yes");
}

//-->
</script>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>			 
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='yes'  value='<%=yes%>'>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='5%' rowspan="2" class='title'>연번</td>
					<td width='10%' rowspan="2" class='title'>부서</td>
					<td width='10%' rowspan="2" class='title'>성명</td>
					<td width='20%' rowspan="2" class='title'>입사일자</td>
					<td width='10%' class='title'>포상구분</td>
					<td width='20%' class='title'><%if(yes.equals("Y")){%>휴가사용일<%}else{%>휴가사용예정일<%}%></td>
					<td width='10%' class='title'>포상금</td>
				</tr>
			</table>
		</td>
		<td width=17>&nbsp;</td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<% 
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			gs_year = AddUtil.parseInt(String.valueOf(ht.get("YEAR")));
%> 
                <tr> 
                    <td width='5%' align='center'><%=i+1%></td>
                    <td width='10%' align='center'><%=ht.get("DEPT_NM")%></td>
                    <td width='10%' align='center'>
						<%if(acar_id.equals(ht.get("USER_ID")) || nm_db.getWorkAuthUser("전산팀",acar_id) || nm_db.getWorkAuthUser("임원",acar_id)){%>
							<a href="javascript:WorldTour('<%=ht.get("USER_ID")%>',<%=auth_rw%>)"><%=ht.get("USER_NM")%></a>
						<%}else{%>
							<%=ht.get("USER_NM")%>
						<%}%>					
					</td>
                    <td width='20%' align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("ENTER_DT")))%></td>
					<td width='10%' align='center'><%=String.valueOf(ht.get("YEAR"))%>년차	</td>
                    <td width='20%' align='center'>
							<%if(!ht.get("PS_STR_DT").equals("")){%>
								<%if(AddUtil.parseInt(String.valueOf(ht.get("YEAR")))  == AddUtil.parseInt(String.valueOf(ht.get("PS_COUNT"))) ){%>
									<%=AddUtil.getDate3(String.valueOf(ht.get("PS_STR_DT")))%>
								<%}else{%>
									날짜미정
								<%}%>
							<%}else{%>
									날짜미정
							<%}%>
					</td>
                    <td width='10%' align='center'>
						<%if(gs_year == 5  &&  AddUtil.parseInt(String.valueOf(ht.get("YEAR")))  != AddUtil.parseInt(String.valueOf(ht.get("PS_COUNT")))  ){%>200만원 지급예정
						<%}else if(gs_year == 11 &&  AddUtil.parseInt(String.valueOf(ht.get("YEAR")))  != AddUtil.parseInt(String.valueOf(ht.get("PS_COUNT")))  ){%>220만원 지급예정
						<%}else if(gs_year >= 18 &&  AddUtil.parseInt(String.valueOf(ht.get("YEAR")))  != AddUtil.parseInt(String.valueOf(ht.get("PS_COUNT")))  ){%>250만원 지급예정
						<%}else {%>지급<%}%>
						
						&nbsp;</td>
<%}%>
                </tr>
            </table>
		</td>
    </tr>
</table>
</form>
</body>
</html>
