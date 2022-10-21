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
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
//	t_wd = java.net.URLDecoder.decode((String)request.getParameter("t_wd"),"utf-8"); 
	
	Vector vt = p_db.getOffPropList(s_kd, t_wd, gubun1, st_dt, end_dt, gubun2, gubun3, gubun4, user_id);
	int vt_size = vt.size();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
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
			<% if( nm_db.getWorkAuthUser("전산팀",user_id)){%>			 
			<td width='6%' class='title'>제안평가</td>	
		<!-- 	<td width='6%' class='title'>평가금액</td>		-->
			<td width='6%' class='title'>댓글평가</td>									
		    <td width='38%' class='title'>제목</td>		    
			<%}else{%>				
		    <td width='62%' class='title'>제목</td>
			<%}%>							
			<td width='6%' class='title'>제안자</td>	
			<td width='8%' class='title'>제안일자</td>		
			<td width='4%' class='title'>댓글</td>	
			<td width='12%' class='title'>찬반</td>			
			<!-- 
			<td wid<td width='6%' class='title'>지급</td>			
									 -->
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
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="3%" align="center">
			<%=i+1%>  
            </td>
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="5%" align="center"><%=ht.get("STEP")%></td>			
			<%if( nm_db.getWorkAuthUser("전산팀",user_id) ){%>
			
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="6%" align="center" style="font-size : 8pt;">	
                <%if(!String.valueOf(ht.get("EVAL_MAGAM")).equals("Y")) {%>	  
			<!--  <%if(user_id.equals("000003")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_E3")).equals("-")&&!String.valueOf(ht.get("EVAL_E3")).equals("건")){%>대표:<%=ht.get("EVAL_E3")%><br><%}%><%if(user_id.equals("000003")){%></font><%}%>
			  <%if(user_id.equals("000004")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_E4")).equals("-")&&!String.valueOf(ht.get("EVAL_E4")).equals("건")){%>총무:<%=ht.get("EVAL_E4")%><br><%}%><%if(user_id.equals("000004")){%></font><%}%>
			  <%if(user_id.equals("000005")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_E5")).equals("-")&&!String.valueOf(ht.get("EVAL_E5")).equals("건")){%>영업:<%=ht.get("EVAL_E5")%><br><%}%><%if(user_id.equals("000005")){%></font><%}%>
			  <%if(user_id.equals("000026")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_E6")).equals("-")&&!String.valueOf(ht.get("EVAL_E6")).equals("건")){%>관리:<%=ht.get("EVAL_E6")%><%}%><%if(user_id.equals("000026")){%></font><%}%><br>	-->		  
			  <%if(user_id.equals("000237")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_E7")).equals("-")&&!String.valueOf(ht.get("EVAL_E7")).equals("건")){%> I T    :<%=ht.get("EVAL_E7")%><%}%><%if(user_id.equals("000237")){%></font><%}%>
	       <% } %>	
			</td>	
	<!-- 		
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="6%" align="center" style="font-size : 8pt;">
              <%if(!String.valueOf(ht.get("EVAL_MAGAM")).equals("Y")) {%>	
		      <%if(user_id.equals("000003")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_P3")).equals("-")&&!String.valueOf(ht.get("EVAL_P3")).equals("건")){%>대표:<%=ht.get("EVAL_P3")%><br><%}%><%if(user_id.equals("000003")){%></font><%}%>
			  <%if(user_id.equals("000004")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_P4")).equals("-")&&!String.valueOf(ht.get("EVAL_P4")).equals("건")){%>총무:<%=ht.get("EVAL_P4")%><br><%}%><%if(user_id.equals("000004")){%></font><%}%>
			  <%if(user_id.equals("000005")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_P5")).equals("-")&&!String.valueOf(ht.get("EVAL_P5")).equals("건")){%>영업:<%=ht.get("EVAL_P5")%><br><%}%><%if(user_id.equals("000005")){%></font><%}%>
			  <%if(user_id.equals("000026")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_P6")).equals("-")&&!String.valueOf(ht.get("EVAL_P6")).equals("건")){%>관리:<%=ht.get("EVAL_P6")%><%}%><%if(user_id.equals("000026")){%></font><%}%><br>  
			  <%if(user_id.equals("000237")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_P7")).equals("-")&&!String.valueOf(ht.get("EVAL_P7")).equals("건")){%> I T  :<%=ht.get("EVAL_P7")%><%}%><%if(user_id.equals("000237")){%></font><%}%>			  
		     <% } %>	
			</td>	-->		
						
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="6%" align="center" style="font-size : 8pt;">
                    <%if(!String.valueOf(ht.get("EVAL_MAGAM")).equals("Y")) {%>	
			  <%if(user_id.equals("000237")){%><font color=#0099FF><%}else{%><font color=#999999><%}%><%if(!String.valueOf(ht.get("EVAL_C7")).equals("-")&&!String.valueOf(ht.get("EVAL_C7")).equals("건")){%>I T  :<%=ht.get("EVAL_C7")%><br><%}%><%if(user_id.equals("000237")){%></font><%}%>

			
		     <% } %>		
			</td>                   											
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="38%">&nbsp;<%if(String.valueOf(ht.get("USE_YN")).equals("Y") || String.valueOf(ht.get("USE_YN")).equals("M")){ %><img src=/images/mservice_icon.gif align=absmiddle><% } %>                        
			  <a href="javascript:parent.AncDisp('<%=ht.get("PROP_ID")%>', '<%=i+1%>')" onMouseOver="window.status=''; return true">
			  <%if(String.valueOf(ht.get("READ_YN")).equals("Y")){ %>
			    <font color="#666666"><%=ht.get("TITLE")%></font>
			  <%}else{%>
			    <%=ht.get("TITLE")%>
			  <%}%>
			  <%if(String.valueOf(ht.get("NEW_YN")).equals("new")){ %>&nbsp;<font color="Fuchsia" size="1"><b>New</b></font><%}%>
			  </a></td>
			 
			<%}else{%>	
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="62%">&nbsp;<%if(String.valueOf(ht.get("USE_YN")).equals("Y") || String.valueOf(ht.get("USE_YN")).equals("M") ){ %><img src=/images/mservice_icon.gif align=absmiddle><% } %>
			  <a href="javascript:parent.AncDisp('<%=ht.get("PROP_ID")%>', '<%=i+1%>')" onMouseOver="window.status=''; return true">
			  <%if(String.valueOf(ht.get("READ_YN")).equals("Y")){ %>
			    <font color="#666666"><%=ht.get("TITLE")%></font>
			  <%}else{%>
			    <%=ht.get("TITLE")%>
			  <%}%>
			  <%if(String.valueOf(ht.get("NEW_YN")).equals("new")){ %>&nbsp;<font color="Fuchsia" size="1"><b>New</b></font><%}%>
			  </a></td>			
			<%}%>  
          
			<td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="6%" align="center">		<!-- 제안자 -->
          	<% if ( String.valueOf(ht.get("OPEN_YN")).equals("Y")   ) { %><%=String.valueOf(ht.get("USER_NM"))%>
			<% } else {  %>
			비공개 
			<% } %>          	
            </td>			  
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="8%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>			  
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="4%" align="center"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("CNT1"))) + AddUtil.parseInt(String.valueOf(ht.get("CNT2"))) )%></td>
            <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="12%" align="center">찬:<%=ht.get("R_CNT1")%>&nbsp;&nbsp;반:<%=ht.get("R_CNT2")%>&nbsp;&nbsp;기:<%=ht.get("R_CNT3")%>&nbsp;</td>
            <!-- <td <%if( String.valueOf(ht.get("PROP_STEP")).equals("7") || String.valueOf(ht.get("PROP_STEP")).equals("9") )%>class='is2'<%%> width="6%" align="center"><%=ht.get("JIGUB_DT")%></td> -->
     
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