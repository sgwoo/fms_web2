<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
 	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dest_gubun= request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");
	String send_dt 	= request.getParameter("send_dt")==null?"1":request.getParameter("send_dt");
	String s_bus 	= request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	//발송완료리스트
	Vector resultList = umd.getSmsCreListV5No(gubun, dest_gubun, send_dt, st_dt, end_dt, s_bus, sort, sort_gubun, s_bus, s_kd, t_wd);
	
	int sum1=0, sum2=0;
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
function view_sms(cmst, cmid){
	window.open("about:blank", "SMS_V5", "left=100, top=110, width=740, height=400, scrollbars=no");	
	fm = document.form1;
	fm.cmid.value = cmid;
	fm.cmst.value = cmst;
	fm.target = "SMS_V5";
	fm.action = "./v5_sms_mng_c2.jsp";
	fm.submit();
}
//-->
</script>
</head>
<body>
<form name="form1" method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun_nm' value='<%=gubun_nm%>'>
<input type='hidden' name='dest_gubun' value='<%=dest_gubun%>'>
<input type='hidden' name='send_dt' value='<%=send_dt%>'>
<input type='hidden' name='s_bus' value='<%=s_bus%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type="hidden" name="cmid" value="">
<input type="hidden" name="cmst" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    <td class="line"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td width="3%" class="title">연번</td>
            <td width="6%" class="title">의뢰자</td>
            <td width="20%" class="title">수신자</td>
            <td width="10%" class="title">수신번호</td>
            <td width="23%" class="title">문자</td>
			<td width="15%" class="title">등급</td>
            <td width="6%" class="title">발신자</td>			
            <td width="17%" class="title">발신일자</td>
            </tr>
<%if(resultList.size() > 0){%>
<%	for(int i=0; i< resultList.size(); i++){
			Hashtable ht = (Hashtable)resultList.elementAt(i);%>
	  <tr>
		<td width="3%" align="center"><%= i+1%></td>
		<td width="6%" align="center"><%= ht.get("USER_NM") %></td>
		<td width="20%" align="center"><a href="javascript:view_sms('log', '<%= ht.get("CMID") %>');" onMouseOver="window.status=''; return true"><%= ht.get("DEST_NAME") %></a></td>
		<td width="10%" align="center"><%if(ht.get("DEST_PHONE").equals("00000000000")){%>서면동의<%}else{%><%= ht.get("DEST_PHONE") %><%}%></td>
		<td width="23%">&nbsp;<%= ht.get("MSG_BODY") %></td>
		<td width="15%" align="center">&nbsp;NICE : <%= ht.get("SCORE") %> , KCB : <%= ht.get("SCORE2") %></td>
		<td width="6%" align="center"><%= ht.get("SEND_NM") %></td>
		<td width="17%" align="center"><%= ht.get("REG_DT") %></td>
		</tr>
<%}%>		
<%}else{%>
		<tr>
			<td colspan="8" align='center'>데이터가 없음.</td>
		</tr>
<%}%>
    </table></td>
  </tr>
</table>
</form>
</body>
</html>