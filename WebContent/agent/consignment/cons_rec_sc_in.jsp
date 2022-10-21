<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/agent/cookies.jsp" %> 

<%
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
	
	Vector vt = cs_db.getConsignmentRecList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
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
<body onLoad="javascript:init()" topmargin=0>
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
  	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='40%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='10%' class='title'>연번</td>
		            <td width='20%' class='title'>사후입력여부</td>					
		            <td width='35%' class='title'>탁송번호</td>
					<td width='35%' class='title'>탁송업체</td>
				</tr>
			</table>
		</td>
		<td class='line' width='60%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='15%' class='title'>탁송구분</td>					
		          <td width="15%" class='title'>차량대수</td>
				  <td width='15%' class='title'>의뢰자</td>					
				  <td width='27%' class='title'>요청일시</td>
				  <td width='28%' class='title'>의뢰일시</td>
				</tr>
			  </tr>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line' width='40%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
					<td  width='10%' align='center'><%=i+1%></td>
					<td  width='20%' align='center'><%if(!ht.get("AFTER_YN").equals("")){%><%=ht.get("AFTER_YN")%><%}else if(!ht.get("F_MAN").equals("") || !ht.get("D_MAN").equals("")){%>신차<%}%></td>					
					<td  width='35%' align='center'><a href="javascript:parent.view_cons('<%=ht.get("CONS_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CONS_NO")%></a></td>
					<td  width='35%' align='center'><%=ht.get("OFF_NM")%></td>
				</tr>
<%		}%>
			</table>
		</td>
		<td class='line' width='60%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>					
					<td  width='15%' align='center'><%=ht.get("CONS_ST")%></td>
					<td  width='15%' align='center'><%=ht.get("CONS_SU")%></td>																
					<td  width='15%' align='center'><%=ht.get("USER_NM1")%></td>									
					<td  width='27%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_REQ_DT")))%></td>						
					<td  width='28%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("REQ_DT")))%></td>
				</tr>
<%		}%>
			</table>
		</td>
	</tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='40%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='60%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
