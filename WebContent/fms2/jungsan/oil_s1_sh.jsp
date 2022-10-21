<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
			
	int year =AddUtil.getDate2(1);
//	int year = 2016;
	int mon =AddUtil.getDate2(2);
	
	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
function Search()
{
		var fm = document.form1;
		fm.action="oil_s1_sc.jsp";
			
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

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=5>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 복리후생비 > <span class=style5>유류대 분기정산</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
     <tr> 
      <td> 
        <table width="100%" border="0" cellpadding="0" cellspacing="1">
          <tr> 
          	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
			 
            <select name="st_year">
				<%for(int i=2015; i<=year; i++){%>
				<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>년</option>
				<%}%>
			</select> 
			
			&nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>
			
	
            </tr>
            
            <tr> 
          	<td align=right><!--<font color=red>&nbsp;&nbsp;업무용 월한도 기준 :&nbsp;&nbsp; 2007년:300,000원,&nbsp;&nbsp;2008년:360,000원 &nbsp;&nbsp;&nbsp;</font>-->
          	</td>
        </table>
      </td>
   
    </tr>
  </form>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</table>
</body>