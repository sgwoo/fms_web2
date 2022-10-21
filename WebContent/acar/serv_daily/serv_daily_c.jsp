<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_daily.*" %>
<jsp:useBean id="sdd_bean" class="acar.serv_daily.ServDailyDetailBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	ServDailyDatabase sdd = ServDailyDatabase.getInstance();
	String auth_rw = "";
	String car_mng_id = "";
	String rent_mng_id = "";
	String rent_l_cd = "";
	String serv_dt = "";
	
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("rent_mng_id") !=null) rent_mng_id = request.getParameter("rent_mng_id");
	if(request.getParameter("rent_l_cd") !=null) rent_l_cd = request.getParameter("rent_l_cd");
	if(request.getParameter("car_mng_id") !=null) car_mng_id = request.getParameter("car_mng_id");
	if(request.getParameter("serv_dt") !=null) serv_dt = request.getParameter("serv_dt");
		
	ServDailyDetailBean sdd_r [] = sdd.getServDailyDetail(car_mng_id, rent_mng_id, rent_l_cd, serv_dt);
	

%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function DispatchSearch()
{
	var theForm = document.DispatchSearchFrom;
	theForm.submit();
}
function ContractContent(id)
{
	var theForm = document.ContractContentFrom;
	theForm.h_cont_id.value = id;
	theForm.submit();
}
function ServiceSearch()
{
	var theForm = document.ServiceSearchFrom;
	
	var gubun = theForm.gubun.options[theForm.gubun.selectedIndex].value;
	if(gubun=='1')
	{
		location = "./maintenance_s.html";
	}else{
		location = "./service_s.html";
	}

}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=750>
	<tr>
    	<td ><font color="navy">고객지원 -> 정기검사 일지 -> </font><font color="red">정비/점검 리스트</font></td>
    </tr>
	<tr>
    	<td align=right><a href="javascript:self.close();window.close();">닫기</a></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=750>
            	<tr>
            		<td class=title width=100>일자</td>
            		<td class=title width=100>구분</td>
            		<td class=title width=100>담당자</td>
            		<td class=title width=350>점검내용</td>
            		<td class=title width=100>주행거리</td>
            		
            	</tr>
            	<%
    for(int i=0; i<sdd_r.length; i++){
        sdd_bean = sdd_r[i];
%>
	           	<tr>
	        		<td width=100 align=center><%=sdd_bean.getServ_dt()%></td>
	        		<td width=100 align=center><%=sdd_bean.getServ_st_nm()%></td>
	        		<td width=100 align=center><%=sdd_bean.getChecker()%></td>
	        		<td width=350 align=center><%=sdd_bean.getRep_cont()%></td>
	        		<td width=100 align=right><%=Util.parseDecimal(sdd_bean.getTot_dist())%> km </td>
	        	</tr>
<%}%>
<% if(sdd_r.length == 0) { %>
	            <tr>
	                <td width=750 align=center height=25>등록된 데이타가 없습니다.</td>
	            </tr>
<%}%>
            	
            </table>
        </td>
    </tr>
</table>
</body>
</html>