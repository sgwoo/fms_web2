<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.short_fee_mng.*"%>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	
	Vector conts = sfm_db.getShortFeeMngList(gubun1);
	int cont_size = conts.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
//-->
</script>
</head leftmargin=0>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>
    <td class=line>            
      <table border=0 cellspacing=1 width=100%>
        <%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable sfm = (Hashtable)conts.elementAt(i);%>
        <tr> 
          <td width='5%' align=center><%=i+1%></td>
          <td width='8%' align=center><%=sfm.get("NM")%></td>
          <td width='5%' align=center ><a href="javascript:parent.Update('<%=sfm.get("SECTION")%>','<%=sfm.get("REG_DT")%>')" onMouseOver="window.status=''; return true"><%=sfm.get("SECTION")%></a></td>
          <td width='15%' align=center ><%=sfm.get("STAND_CAR")%></td>
          <td width='59%'>&nbsp;<%=sfm_db.getSectionCarList(String.valueOf(sfm.get("SECTION")))%></td>
          <td align=center width="8%"><%=sfm.get("REG_DT")%></td>
        </tr>
        <%	}
  		}else{%>
        <tr align="center"> 
          <td colspan='6'>등록된 데이타가 없습니다.</td>
        </tr>
        <%	}%>
      </table>
    </td>
  </tr>
</table>
</body>
</html>