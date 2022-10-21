<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/off/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = cs_db.getConsignmentOksmsList(s_kd, t_wd, gubun1, st_dt, end_dt);
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
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/off/consignment/cons_oksms_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
  	<tr><td class=line2></td></tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='4%' class='title'>연번</td>
		          <td width='10%' class='title'>탁송번호</td>
				  <td width='6%' class='title'>운전자</td>
		          <td width='15%' class='title'>운행일자</td>
		          <td width='8%' class='title'>차량번호</td>				  
				  <td width='10%' class='title'>고객명</td>
			      <td width='15%' class='title'>상호</td>
			      <td width='7%' class='title'>주행거리</td>
			      <td width='12%' class='title'>출발시간</td>
			      <td width='12%' class='title'>도착시간</td>
			  </tr>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			String prev_car_no = String.valueOf(ht.get("CAR_NO"));
			String seq = String.valueOf(ht.get("SEQ"));
			String car_no = "";
			if( prev_car_no.length() > 10 ) {
				car_no = cs_db.getCarNo(String.valueOf(ht.get("CONS_NO")), Integer.parseInt(seq));
			}
			car_no = car_no == "" ? Util.subData(prev_car_no, 8) : car_no;
			%>
				<tr>
					<td width='4%' align='center'><%=i+1%></td>
					<td width='10%' align='center'><%=ht.get("CONS_NO")%>-<%=ht.get("SEQ")%></td>					
					<td width='6%' align='center'><%=ht.get("REG_NM")%></td>
					<td width='15%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("REG_DT")))%></td>
					<td width='8%' align='center'><%=car_no%></td>				  
					<td width='10%' align='center'><%=ht.get("CLIENT_NM")%></td>
					<td width='15%' align='center'><%=Util.subData(String.valueOf(ht.get("CLIENT_BR")), 10)%></td>
					<td width='7%' align='right'><%=ht.get("DIST_KM")%>km &nbsp;</td>
					<td width='12%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("START_DT")))%></td>
					<td width='12%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("END_DT")))%></td>
				</tr>
<%}%>
			</table>
		</td>
	</tr>
<%	}else{%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center' colspan='10'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
</body>
</html>
