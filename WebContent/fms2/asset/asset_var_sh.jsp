<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

			
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.target = "c_foot";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=800>
  <form action="./asset_var_sc.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
    <tr>		
      <td> <span class="style1">MASTER -> 코드관리 -><font color="red">자산변수관리</font></span>
	  
	  </td>
	</tr>
	<tr>
		<td>			
        <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <tr>					
            <td width="230">자산구분 : 
              <select name="gubun1">
                <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>리스사업자동차</option>
                <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>렌트사업자동차</option>
              </select>
            </td>
        	
       
            <td><a href="javascript:Search()">검색</a></td>
				</tr>
			</table>
		</td>
	</tr>
</form>
</table>
</body>
</html>