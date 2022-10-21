<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
			
	
	int s_days = 31;
	
	int c_width = 100;
	
	
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
<%@ include file="/acar/getNaviCookies.jsp" %>
<body onLoad="javascript:init()">

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_yy'  	value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 	value='<%=s_mm%>'>	

  <table border="0" cellspacing="0" cellpadding="0" width='<%=180+(c_width*s_days)%>'>
    <tr>
      <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='180' id='td_title' style='position:relative;'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	    <tr>
		<td width='180' class='title'>영업일</td>
	    </tr>
	  </table>
	</td>
	<td class='line' width='<%=c_width*s_days%>'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	    <tr>
		<%for(int i=1; i<=s_days; i++){%>
		<td width='<%=c_width%>' class='title'><%=i%>일</td>				
		<%}%>			  
	    </tr>
	  </table>
	</td>
    </tr>
	<tr>
		<td class='line' width='180' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td colspan="3" align='center'>연체율</td>
				</tr>
				<tr>
					<td  width='60' rowspan="10" align='center'>연체<br>대여료</td>
					<td  width='70' rowspan="2" align='center'>1개월이내</td>
					<td  width='50' align='center'>건수</td>
				</tr>
				<tr>
					<td  width='50' align='center'>금액</td>
				</tr>
				<tr>
					<td  width='70' rowspan="2" align='center'>1~2개월</td>
					<td  width='50' align='center'>건수</td>
				</tr>
				<tr>
					<td  width='50' align='center'>금액</td>
				</tr>
				<tr>
					<td  width='70' rowspan="2" align='center'>3~4개월</td>
					<td  width='50' align='center'>건수</td>
				</tr>
				<tr>
					<td  width='50' align='center'>금액</td>
				</tr>
				<tr>
					<td  width='70' rowspan="2" align='center'>4개월이상</td>
					<td  width='50' align='center'>건수</td>
				</tr>
				<tr>
					<td  width='50' align='center'>금액</td>
				</tr>
				<tr>
					<td  width='70' rowspan="2" align='center'>소계</td>
					<td  width='50' align='center'>건수</td>
				</tr>		
				<tr>
					<td  width='50' align='center'>금액</td>
				</tr>
				<tr>
					<td colspan="3" align='center'>총대여료</td>
				</tr>																										
			</table>
		</td>
		<td class='line' width='<%=c_width*s_days%>'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int j = 0 ; j < 12 ; j++){
				Hashtable ht = ac_db.getStatIncomPayDlyList(j, s_yy+""+s_mm);				
%>			
				<tr>
				    <%for(int i=1; i<=s_days; i++){%>
					<td  width='<%=c_width%>' align='right'><%if(j==0){%><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("AMT_"+AddUtil.addZero2(i))),2)%><%}else{%><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT_"+AddUtil.addZero2(i))))%><%}%></td>				
				    <%}%>	
				</tr>
<%		}%>
			</table>
		</td>


</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
