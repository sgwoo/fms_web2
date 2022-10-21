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
	String yes = request.getParameter("yes")==null?"":request.getParameter("yes");
	
	Vector vt = t_db.Member_list(user_id, s_kd, t_wd, yes);
	int vt_size = vt.size();

%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<script language="JavaScript">
<!--

function Tour(user_id,auth_rw)
{
	
	var SUBWIN="tour_c.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "WorldTour", "left=100, top=100, width=800, height=600, scrollbars=yes");
}

//-->
</script>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>			 
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>

<table border="0" cellspacing="0" cellpadding="0" width="1130">
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<% 
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			if ( nm_db.getWorkAuthUser("외부개발자",String.valueOf(ht.get("USER_ID"))) ) {
				 continue;
			}
%> 
                <tr> 
                    <td width='50' align='center'><%=i+1%></td>
                    <td width='100' align='center'><%=ht.get("DEPT_NM")%></td>
                    <td width='100' align='center'>
					
						<a href="javascript:Tour('<%=ht.get("USER_ID")%>',<%=auth_rw%>)"><%=ht.get("USER_NM")%></a>
							
					</td>
                    <td width='120' align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("ENTER_DT")))%></td>
                    <td width='120' align='center'><% if (!ht.get("YEAR5_C").equals("1")  &&   AddUtil.parseInt(String.valueOf(ht.get("YEAR5"))) < AddUtil.parseInt(String.valueOf(ht.get("TO_DAY")))  ){ %><font color=red><%=AddUtil.getDate3(String.valueOf(ht.get("YEAR5")))%></font><%}else{%><%=AddUtil.getDate3(String.valueOf(ht.get("YEAR5")))%><%} %></td>
                    <td width='70' align='center'><%if(ht.get("YEAR5_C").equals("1") ) { %>지급<%}else{%>200만원<%}%>&nbsp; </td>
                    <td width='120' align='center'><% if ( !ht.get("YEAR11_C").equals("1")  && AddUtil.parseInt(String.valueOf(ht.get("YEAR11"))) < AddUtil.parseInt(String.valueOf(ht.get("TO_DAY")))){ %><font color=red><%=AddUtil.getDate3(String.valueOf(ht.get("YEAR11")))%></font><%}else{%><%=AddUtil.getDate3(String.valueOf(ht.get("YEAR11")))%><%} %></td>
                    <td width='70' align='center'><%if(ht.get("YEAR11_C").equals("1") ) { %>지급<%}else{%>220만원<%}%>&nbsp; </td>
                    <td width='120' align='center'><% if ( !ht.get("YEAR18_C").equals("1")  && AddUtil.parseInt(String.valueOf(ht.get("YEAR18"))) < AddUtil.parseInt(String.valueOf(ht.get("TO_DAY")))){ %><font color=red><%=AddUtil.getDate3(String.valueOf(ht.get("YEAR18")))%></font><%}else{%><%=AddUtil.getDate3(String.valueOf(ht.get("YEAR18")))%><%} %></td>  
                    <td width='70' align='center'><%if(ht.get("YEAR18_C").equals("1") ) { %>지급<%}else{%>250만원<%}%>&nbsp; </td>
                    <td width='120' align='center'><% if ( !ht.get("YEAR25_C").equals("1") && AddUtil.parseInt(String.valueOf(ht.get("YEAR25"))) < AddUtil.parseInt(String.valueOf(ht.get("TO_DAY")))){ %><font color=red><%=AddUtil.getDate3(String.valueOf(ht.get("YEAR25")))%></font><%}else{%><%=AddUtil.getDate3(String.valueOf(ht.get("YEAR25")))%><%} %></td>
                    <td width='70' align='center'><%if(ht.get("YEAR25_C").equals("1") ) { %>지급<%}else{%>250만원<%}%>&nbsp; </td>
                </tr>
 <% } %>               
                
            </table>
		</td>

    </tr>
</table>
</form>
</body>
</html>
