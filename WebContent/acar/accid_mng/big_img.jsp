<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String filename = request.getParameter("filename")==null?"":request.getParameter("filename");
	
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	//계약:고객관련
	RentListBean base = a_cad.getCont_View(m_id, l_cd);	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=600>
  <tr> 
    <td><img src="../../images/res/icon_red.gif" border="0" > 차량번호 : <%=base.getCar_no()%></td>
    <td align="right">&nbsp;</td>
  </tr>
  <tr> 
    <td class=line colspan="2"> 
      <table border=0 cellspacing=1 width=600>
        <tr> 
          <td class=title>사진</td>
        </tr>
        <tr valign="top"> 
          <td align="center">
            <img name="carImg" src="/images/accidImg/<%=filename%>.gif" border="0" width="600" height="396"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td align="right"><a href="javascript:self.close();">닫기</a></td>
  </tr>  
</table>
</body>
</html>
