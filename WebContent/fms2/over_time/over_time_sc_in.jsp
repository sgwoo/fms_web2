<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.over_time.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	OverTimeDatabase otd = OverTimeDatabase.getInstance();
		
	int count = 0;
	
	Vector vt = otd.Over_List(user_id, st_year, st_mon, asc);
	int vt_size = vt.size();
	
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_step 	= request.getParameter("doc_step")==null?"":request.getParameter("doc_step");

	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
function UserDisp(user_id,doc_no)
{
	
	var SUBWIN="over_time_c.jsp?user_id="+user_id+"&doc_no="+doc_no;	
	window.open(SUBWIN, "UserDisp", "left=100, top=100, width=1035, height=800, scrollbars=yes");
}
//계약서 내용 보기
	function view_cont(user_id, doc_no){
		var fm = document.form1;
		fm.user_id.value = user_id;
		fm.doc_no.value = doc_no;
		fm.target ='d_content';
		fm.action = 'over_time_c.jsp';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='user_id' value=''>
<input type='hidden' name='doc_no' value=''>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>             	
            	<tr>
            		<td width='5%' align="center"><%=i+1%></td>
            		<td width='7%' align="center"><%if(ht.get("OVER_SJGJ_DT").equals("")){%>N<%}else{%>Y<%}%></td>
            		<td width='7%' align="center"><%=ht.get("DEPT_NM")%></td>
            		<td width='8%' align="center"><a href="javascript:parent.view_cont('<%=ht.get("USER_ID")%>','<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM")%></a></td>
            		<td width='7%' align="center"><%=ht.get("DEPT_NM")%></td>
            		<td width='10%' align="center"><%=ht.get("OVER_TIME_YEAR")%>월&nbsp;<%=ht.get("OVER_TIME_MON")%>월</td>
            		<td width='15%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DT")))%>&nbsp;<%=ht.get("START_H")%>시<%=ht.get("START_M")%>분</td>
            		<td width='15%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DT")))%>&nbsp;<%=ht.get("END_H")%>시<%=ht.get("END_M")%>분</td>
            		<%-- <td width='10%' align="center"><%=ht.get("HH")%>시간 <%=ht.get("MI")%>분</td> --%>
            		<td width='10%' align="center"><%if(Integer.parseInt(AddUtil.toString(ht.get("HH"))) < 8){%> <%=ht.get("HH")%>시간 <%=ht.get("MI")%>분 <%}else{%> 8시간 0분 <%}%></td>
            		<td width='9%' align="center"><%=ht.get("JB_TIME")%>시간</td>
            		<td width='7%' align="center"><%if(ht.get("T_CHECK").equals("Y")){%><%=ht.get("T_CHECK")%><%}else{%><%}%></td>
            	</tr>
            	
            	
          	
<%}
}else{%>            	
	            <tr>
    	            <td colspan=9 align=center height=25>등록된 데이타가 없습니다.</td>
        	    </tr>
<%}%>        	    
            </table>
        </td>
    </tr>
</table>
</body>
</html>
