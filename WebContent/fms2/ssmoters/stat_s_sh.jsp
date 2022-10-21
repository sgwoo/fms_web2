<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
			
	int year =AddUtil.getDate2(1);
//	int year = 2017;
		
	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
function search()
{
		var fm = document.form1;
		fm.action="stat_s_sc.jsp";
		fm.target="cd_foot";		
		fm.submit();
}


function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') Search();
}

//-->
</script>

</head>
<body>
<form  name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    

  <table border=0 cellspacing=0 cellpadding=0 width=100% class="search-area">
	<tr>
		<td colspan=5 style="height: 30px">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp;<span class=style1>현황및통계 > 협력업체관리 > <span class=style5>검사현황</span></span></td>
				</tr>
			</table>
		</td>
				
	</tr>
	<tr>
		<td colspan=5  class=h></td>
	</tr>
	<tr> 
        <td><label><i class="fa fa-check-circle"></i> 연도 </label>
             
			  <select name='st_year'>
             	<%for(int i=2019; i<=year; i++){%>
						<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>년</option>
				<%}%>
				</select> 
                                          	     
		    &nbsp;<input type="button" class="button" value="검색" onclick="javascript:search();"> 
		   &nbsp; </td>
    </tr>    
    </table>
    </form>
 </body>
</html>