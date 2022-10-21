<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
    String s_gubun3 =  request.getParameter("user_id")==null?"":request.getParameter("user_id");	
    String s_work =  request.getParameter("work")==null?"A":request.getParameter("work");	
    String s_work_nm =  request.getParameter("work_nm")==null?"A":request.getParameter("work_nm");	
    String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	

	String st_year		= request.getParameter("st_year")==null?"":request.getParameter("st_year");
   	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	

  	String chk="0";
	int year =AddUtil.getDate2(1);
	int mon =AddUtil.getDate2(2);

    //담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//현황 라인수만큼 제한 아이프레임 사이즈
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

		
function Search(){
		var fm = document.form1;
	
		fm.action="1st_doc_sc.jsp";
			
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
<input type='hidden' name='s_user' value='<%=user_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name="sh_height" value="<%=sh_height%>">   
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 복리후생비 > <span class=style5>개인별 세부내역</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" >&nbsp;<select name='s_gubun3'>
				<option value=''>전체</option>
					<%for (int i = 0 ; i < user_size ; i++){
						Hashtable us = (Hashtable)users.elementAt(i);%>
				<option value='<%=us.get("USER_ID")%>' <%if(s_gubun3.equals(us.get("USER_ID"))){%>selected<%}%>><%=us.get("USER_NM")%></option>
					<%}%>
			</select>&nbsp;	<select name="st_year">
                        <%for(int i=2017; i<=year; i++){%>
                        <option value="<%=i%>" <%if(year == i){%>selected<%}%> ><%=i%>년</option>
                        <%}%>
                      </select>&nbsp;&nbsp;
                      <a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
		</td>
	</tr>
	<tr><td class=h></td></tr>
	<tr><td class=h></td></tr>
    </tr>
  </table>
  </form>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</table>
</body>