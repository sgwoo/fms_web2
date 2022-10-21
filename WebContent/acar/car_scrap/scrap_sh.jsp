<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.con_tax.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"서울":request.getParameter("gubun");	
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
  CommonDataBase c_db = CommonDataBase.getInstance();

  //차량등록지역
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		fm.target = "c_foot";
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function regCar_scrap(){
		parent.location.href  = "scrap_s_frame_m.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&gubun=<%=gubun%>";
	}
/-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="scrap_sc.jsp" name="form1" method="POST">
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type='hidden' name='sh_height' value='<%=sh_height%>'> 	
    <tr> 
      <td> <font color="navy">경영지원 -> 대폐차관리 -> </font><font color="red">대폐차현황</font></td>
    </tr>
    
    <tr> 
      <td> 
        <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <tr> 
            <td width="70"> 
            	<select name='gubun'>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm()%>' <%if(gubun.equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
              </select> </td>
            <td width="90"> <select name='s_kd'>
                <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>차량번호 
                </option>
              </select> </td>
            <td width="110"> <input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
              &nbsp; </td>
            <td width="407"><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
            <td width="117"><% if(auth_rw.equals("6")){ %><a href="javascript:regCar_scrap();">차량직접입력</a><% } %></td>
          </tr>
        </table>
      </td>
    </tr>
  </form>
</table>
</body>
</html>