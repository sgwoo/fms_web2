<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript">
<!--
	//검색
	function Search()
	{
		var fm = document.form1;
		fm.action = 'stat_rent_com_sc_m.jsp';		
		fm.target = 'c_foot';
		fm.submit();
	}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body leftmargin=15>
<form name="form1" method="POST">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='user_id'	value='<%=user_id%>'>
		
	<div class="navigation" style="margin-bottom:0px !important">
		<span class="style1">경영정보> 영업관리> </span><span class="style5"></span>
	</div>
	<div class="search-area" style="padding-bottom: 100px;">
		<label><i class="fa fa-check-circle"></i>&nbsp;기준일자</label>
		<select name="gubun" class="select">
			<option value="1" <%if(gubun.equals("1")){%>selected<%}%>>계약일</option>
			<option value="2" <%if(gubun.equals("2")){%>selected<%}%>>출고일</option>
		</select>	
		<select name="s_yy" class="select">
			<option value="" <%if(s_yy.equals("")){%>selected<%}%>>전체</option>						
				<%for(int i=2000; i<=AddUtil.getDate2(1); i++){%>
			<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
				<%}%>
		</select>			
		 <input type="button" class="button btn-default" value="검색" onclick="javascript:Search();">		 
	</div>
</form>
</body>
</html>