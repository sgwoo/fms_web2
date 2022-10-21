<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String use_yn = request.getParameter("use_yn")==null?"1":request.getParameter("use_yn");
	
	int count = 0;
		
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	
	Vector vt = p_db.getOffPropList(s_kd, t_wd, gubun1, st_dt, end_dt, "O" , gubun3, gubun4, user_id);  //:gubun2:o -> 외부업체허용
	int vt_size = vt.size();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">

<script language="JavaScript">
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
<body onLp_db="javascript:init()">

  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
	  <td class='line2' id='td_title' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='3%' class='title'>연번</td>
			<td width='5%' class='title'>상태</td>									
		    <td width='56%' class='title'>제목</td>									
			<td width='6%' class='title'>제안자</td>	
			<td width='8%' class='title'>제안일자</td>		
			<td width='4%' class='title'>댓글</td>	
			<td width='12%' class='title'>찬반</td>			
			<td width='6%' class='title'>지급</td>			
									
		  </tr>
		</table>
	  </td>
	  <td class='line' width='0%'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
		  </tr>
		</table>
	  </td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
	  <td class='line' width='100%' id='td_con' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
          <tr>
            <td <%if(String.valueOf(ht.get("PROP_STEP")).equals("7"))%>class='is2'<%%> width="3%" align="center">
			<%=i+1%>                         
            
            </td>
            <td <%if(String.valueOf(ht.get("PROP_STEP")).equals("7"))%>class='is2'<%%> width="5%" align="center"><%=ht.get("STEP")%></td>
            						
            <td <%if(String.valueOf(ht.get("PROP_STEP")).equals("7"))%>class='is2'<%%> width="56%">&nbsp;<%if(String.valueOf(ht.get("USE_YN")).equals("Y")){ %><img src=/images/mservice_icon.gif align=absmiddle><% } %>
			  <a href="javascript:parent.AncDisp('<%=ht.get("PROP_ID")%>', '<%=i+1%>')" onMouseOver="window.status=''; return true">
			  <%if(String.valueOf(ht.get("READ_YN")).equals("Y")){ %>
			    <font color="#666666"><%=ht.get("TITLE")%></font>
			  <%}else{%>
			    <%=ht.get("TITLE")%>
			  <%}%>
			  <%if(String.valueOf(ht.get("NEW_YN")).equals("new")){ %>&nbsp;<font color="Fuchsia" size="1"><b>New</b></font><%}%>
			  </a></td>			
			  
          
			<td <%if(String.valueOf(ht.get("PROP_STEP")).equals("7"))%>class='is2'<%%> width="6%" align="center">		<!-- 제안자 -->
          	<% if ( String.valueOf(ht.get("OPEN_YN")).equals("Y")   ) { %><%=String.valueOf(ht.get("USER_NM"))%>
			<% } else {  %>
			비공개 
			<% } %>          	
            </td>			  
            <td <%if(String.valueOf(ht.get("PROP_STEP")).equals("7"))%>class='is2'<%%> width="8%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>			  
            <td <%if(String.valueOf(ht.get("PROP_STEP")).equals("7"))%>class='is2'<%%> width="4%" align="center"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("CNT1"))) + AddUtil.parseInt(String.valueOf(ht.get("CNT2"))) )%></td>
            <td <%if(String.valueOf(ht.get("PROP_STEP")).equals("7"))%>class='is2'<%%> width="12%" align="center">찬:<%=ht.get("R_CNT1")%>&nbsp;&nbsp;반:<%=ht.get("R_CNT2")%>&nbsp;&nbsp;기:<%=ht.get("R_CNT3")%>&nbsp;</td>
            <td <%if(String.valueOf(ht.get("PROP_STEP")).equals("7"))%>class='is2'<%%> width="6%" align="center"><%=ht.get("JIGUB_DT")%></td>
     
		  </tr>
<%		}%>
		</table>
	  </td>
	  <td class='line' width='0%'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
		  <tr>									  					  
       	  </tr>
<%	}%>
        </table>
      </td>
    </tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='0%'>
			
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