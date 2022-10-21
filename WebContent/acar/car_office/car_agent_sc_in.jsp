<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2").equals("")?"Y":request.getParameter("gubun2");
	String gubun3	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	Vector vt = cod.getCarAgentAllList(gubun1,gubun2,gubun3,gubun4,s_kd,t_wd);	
	int vt_size = vt.size();		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function UpdateList(car_off_id)
{	
	var fm = document.form1;
	fm.car_off_id.value = car_off_id;
	fm.target="d_content";
	fm.submit();
}
//-->
</script>
</head>
<body>
<form action="./car_agent_c.jsp" name="form1" method="post">
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
			            		<td width=5% class=title>연번</td>
			            		<td width=10% class=title>관리구분</td>
			            		<td width=8% class=title>업무구분</td>
			            		<td width=7% class=title>거래구분</td>
			            		<td width=10% class=title>소속구분</td>								
			            		<td width=8% class=title>사업자구분</td>
			            		<td width=12% class=title>상호/성명</td>
			            		<td width=7% class=title>대표자</td>								
			            		<td width=10% class=title>전화</td>
			            		<td width=8% class=title>FAX</td>
			            		<td width=10% class=title>주소</td>			            					            		
			  </tr>
		<%for (int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr>
            	    <td width=5% align=center><%= i+1 %></td>
            	    <td width=10% align=center><%=ht.get("CAR_OFF_ST_NM")%></td>
            	    <td width=8% align=center><%if(String.valueOf(ht.get("WORK_ST")).equals("C")){%>견적,계약<%}else{%>견적<%}%></td>
            	    <td width=7% align=center><%=ht.get("USE_YN_NM")%></td>		
            	    <td width=10% align=center><%=ht.get("AGENT_ST_NM")%></td>		
            	    <td width=8% align=center><%=ht.get("ENP_ST_NM")%></td>
            	    <td width=12% align=center><a href="javascript:UpdateList('<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_OFF_NM")%></a></td>
            	    <td width=7% align=center><%=ht.get("OWNER_NM")%></td>
            	    <td width=10% align=center><%=ht.get("CAR_OFF_TEL")%></td>
            	    <td width=8% align=center><%=ht.get("CAR_OFF_FAX")%></td>
            	    <td width=10%>&nbsp;<span title='<%=ht.get("CAR_OFF_ADDR")%>'><%=Util.subData(String.valueOf(ht.get("CAR_OFF_ADDR")), 10)%></span></td>
            	</tr>
		<%}%>
		<%if(vt_size == 0) { %>
                <tr>
                    <td colspan="11" align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
		<%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>