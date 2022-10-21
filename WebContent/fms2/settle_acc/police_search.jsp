<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	Vector fines = FineDocDb.getPoliceListSearch( t_wd);
	int fine_size = fines.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src='/include/common.js'></script>
<script>
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	
	//Enter키로 검색하기
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	// 경찰서 ID 부모창에 세팅하기	
	function setPoliceId(policeId) {
		opener.document.getElementById("pol_place").value = policeId;
		window.close();
	}
	

	
</script>
</head>
<body>
<form name='form1' method='post' action='/fms2/settle_acc/police_search.jsp'>

<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='ins_st' value=''>
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>경찰서 조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
        <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
        <a href='javascript:search()'><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> 
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="1%">연번</td>
                    <td class=title width="9%">이름</td>
                </tr>
              <%for (int i = 0 ; i < fine_size ; i++){
            		FineGovBn = (FineGovBean)fines.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><a href="javascript:setPoliceId('<%=FineGovBn.getGov_id()%>')";><%=FineGovBn.getGov_nm()%></a></td>			
                </tr>
              <%}%>
              
            </table>
        </td>
    </tr>
</table>
<div align="center" style="margin-top:20px;">
  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
</div>
</form>
</body>
</html>
