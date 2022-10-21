<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ClRegDb" scope="page" class="acar.cl.ClRegDatabase"/>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String s_con = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	
	Vector ClRegList = ClRegDb.getClRegList(br_id, "", "", "", "", "", "", "", "", "", "", "", "", s_con, t_wd, "", "2", "asc");
%>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='javascript'>
<!--
//-->
</script>
</head>

<body>
<%	if(!s_con.equals("")){%>
<table border="0" cellspacing="0" cellpadding="0" width=600>
	<tr>
		<td class='line' colspan='2'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
        <% if(ClRegList.size()>0){
				for(int i=0; i<ClRegList.size(); i++){ 
					Hashtable ht = (Hashtable)ClRegList.elementAt(i); %>	  
        <tr> 
          <td width='30' align='center'><%= i+1 %></td>
          <td width='70' align='center'><%= ht.get("CLIENT_ST") %></td>
          <td width='40' align='center'><%= ht.get("SITE_ST") %></td>
          <td width='190'align='center'><span title='<%= ht.get("FIRM_NM") %>'><a href="javascript:parent.select('<%= ht.get("CLIENT_ID") %>', '<%= ht.get("SITE_ID") %>')"><%= Util.subData((String)ht.get("FIRM_NM"),10) %></a></span></td>		  
          <td width='70' align='center'><span title='<%= ht.get("CLIENT_NM") %>'><%= Util.subData((String)ht.get("CLIENT_NM"),8) %></span></td>
          <td width='100' align='center'><%= Util.ChangeEnp((String)ht.get("ENP_NO")) %></td>
          <td width='100' align='center'><%= ht.get("FAX") %></td>
        </tr>
        <%				}
			}else{	%>
        <tr> 
          <td align='center' colspan="7">등록된 데이타가 없습니다</td>
        </tr>
        <%			}		%>
      </table>
		</td>
	</tr>
</table>
<%	}%>
</body>
</html>