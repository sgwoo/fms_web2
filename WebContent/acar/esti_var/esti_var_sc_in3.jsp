<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSikVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//계산식변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstiSikVarBean [] ea_r = e_db.getEstiSikVarList(gubun1, gubun2, gubun3);
	int size = ea_r.length;			
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function update3(){
		var fm = document.form1;
		fm.target='d_content';
		fm.submit();
	}
	

//-->
</script>
</head>
<body>
<form name="form1" method="post" action="esti_sik_var_i.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="a_a" value="<%//=bean.getA_a()%>">          
  <input type="hidden" name="seq" value="<%//=bean.getSeq()%>">          
  <input type="hidden" name="cmd" value="">
</form>  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td><span class=style2>1. <a href="javascript:update3()">계산식</a></span> <a href="javascript:update3()"><img src=../images/center/button_see.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="100">변수코드</td>
                    <td class=title width="300">변수명</td>
                    <td class=title width="400">변수값</td>
                </tr>
    		<%for(int i=0; i<size; i++){
    					bean = ea_r[i];%>
                <tr> 
                <td align="center"><%=bean.getVar_cd()%></td>
                <td >&nbsp;<%=bean.getVar_nm()%></td>
                <td>&nbsp;<%=bean.getVar_sik()%>&nbsp;</td>
                </tr>
    		<%}%>
          </table>
        </td>
    </tr>
</table>
</body>
</html>