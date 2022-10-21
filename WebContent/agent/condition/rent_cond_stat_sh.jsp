<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/agent/cookies.jsp" %>

<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		fm.action = "rent_cond_stat_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
//-->
</script>
</head>
<body>
<form method="POST" name="form1">
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>    
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='s_kd' value='1'>
  <input type='hidden' name='t_wd' value='<%=ck_acar_id%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 계약관리 > <span class=style5>계약현황</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>	
    <tr>
      <td>
        <table width="100%" border=0 cellspacing=1>
          <tr> 
            <td width=25%>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="gubun1">
                <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>계약일</option>
                <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>대여개시일</option>
				<option value="3" <%if(gubun1.equals("3"))%>selected<%%>>현재기준</option>
              </select>
			  <select name="gubun2" >
                <% for(int i=2002; i<=AddUtil.getDate2(1); i++){%>
                <option value="<%=i%>" <%if(i == AddUtil.parseInt(gubun2)){%> selected <%}%>><%=i%>년도</option>
                <%}%>
              </select>
              <select name="gubun3">
                <option value="" <%if(gubun3.equals("")){%> selected <%}%>>전체</option>
                <% for(int i=1; i<=12; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(gubun3)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
                <%}%>
              </select></td>            		  
            <td width="8%"><a href="javascript:search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
            <td align="right"><a href="/agent/condition/rent_cond_frame.jsp" target='d_content'><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td>			
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>