<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	CarOffBean co_r [] = cod.getCarOffAllList(gubun1,gubun2,gubun3,gubun4,s_kd,t_wd);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function UpdateList(arg)
{	
	var fm = document.form1;
	fm.car_off_id.value = arg;
	fm.target="d_content";
	fm.submit();
}
//-->
</script>
</head>
<body>
<form action="./car_office_c.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="car_off_id" value="">
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
			        		<tr>
			            		<td width=4% class=title>연번</td>
			            		<td width=12% class=title>회사명</td>
			            		<td width=6% class=title>구분</td>								
			            		<td width=11% class=title>관할지점/소장명</td>
			            		<td width=14% class=title>영업소명</td>
			            		<td width=20% class=title>주소</td>
			            		<td width=10% class=title>전화</td>
			            		<td width=10% class=title>FAX</td>
			            		<td width=8% class=title>출고실무자</td>								
			            		<td width=4% class=title>존재</td>								
			            	</tr>			 	
			    <% 	for(int i=0; i<co_r.length; i++){
        				co_bean = co_r[i];%>
                <tr>
            		<td width=4% align=center><%= i+1 %></td>
            		<td width=12% align=center><%= co_bean.getCar_comp_nm() %></td>
            		<td width=6% align=center><%if(co_bean.getCar_off_st().equals("1")) {%>지점 <%} else {%>대리점 <% }%></td>					
            		<td width=11% align=center><%= co_bean.getOwner_nm() %> <%if(!co_bean.getManager().equals("") && !co_bean.getOwner_nm().equals(co_bean.getManager())){%><%= co_bean.getManager() %><%}%></td>
            		<td width=14% align=center><a href="javascript:UpdateList('<%= co_bean.getCar_off_id() %>')" onMouseOver="window.status=''; return true"><%= co_bean.getCar_off_nm() %></a></td>
            		<td width=20%>&nbsp;<span title='<%=co_bean.getCar_off_addr()%>'><%=Util.subData(co_bean.getCar_off_addr(), 20)%></span></td>
            		<td width=10% align=center><%= co_bean.getCar_off_tel() %></td>
            		<td width=10% align=center><%= co_bean.getCar_off_fax() %></td>
					<td width=8% align=center><%= co_bean.getAgnt_nm() %></td>
            		<td width=4% align=center><%if(co_bean.getUse_yn().equals("N")) {%>무 <%} else {%>유 <%}%></td>					
            	</tr>
				<%}%>
				<% if(co_r.length == 0) { %>
                <tr>
                    <td colspan="10" align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
				<%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>