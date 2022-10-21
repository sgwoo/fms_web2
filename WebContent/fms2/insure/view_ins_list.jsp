<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String car_use 	= request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String s_st 	= request.getParameter("s_st")==null? "":request.getParameter("s_st");
	String age_st 	= request.getParameter("age_st")==null? "" :request.getParameter("age_st");
	
	int count =0;
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector vt = ai_db.getInsureStatSearchList(gubun1, car_use, s_st, age_st);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='950'>
  <tr>
    <td class=line2></td>
  </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <tr>
				  <td width='30' class='title'>연번</td>
				  <td width='80' class='title'>차량번호</td>
				  <td width='150' class='title'>차명</td>
				  <td width='120' class='title'>보험사</td>
				  <td width='100' class='title'>계약자</td>
				  <td width='80' class='title'>피보험자</td>
				  <td width='80' class='title'>보험시작일</td>
				  <td width='80' class='title'>보험만료일</td>
				  <td width='50' class='title'>일수</td>
				  <td width='90' class='title'>총보험료<br>(자차제외)</td>
				  <td width='90' class='title'>1년치보험료<br>(자차제외)</td>
			  </tr>    
        <%for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
        %>
				<tr>
					<td align='center'><%=i+1%></td>
					<td align='center'><%=ht.get("CAR_NO")%></td>
					<td align='center'><%=ht.get("CAR_NM")%></td>
					<td align='center'><%=ht.get("INS_COM_NM")%></td>
					<td align='center'><%=ht.get("CONR_NM")%></td>	
					<td align='center'><%=ht.get("CON_F_NM")%></td>	
					<td align='center'><%=ht.get("INS_START_DT")%></td>	
					<td align='center'><%=ht.get("INS_EXP_DT")%></td>	
					<td align='center'><%=ht.get("INS_DAYS")%></td>	
					<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("INS_AMT")))%></td>
					<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("G_2")))%></td>
				</tr>
        <%}%>
			</table>
		</td>
	</tr>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

