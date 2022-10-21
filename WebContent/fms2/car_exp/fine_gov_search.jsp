<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	Vector fines = FineDocDb.getFineGovLists("", "", t_wd);
	int fine_size = fines.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//검색하기	
	function search(){
		var fm = document.form1;
		fm.action = "fine_gov_search.jsp";		
		fm.submit();	
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function search_ok(gov_id, gov_nm, mng_dept, gov_st_nm, mng_nm, mng_pos){
		var fm = opener.document.form1;
		fm.gov_id.value = gov_id;
		fm.gov_nm.value = gov_nm;
		fm.gov_st.value = gov_st_nm;		
		fm.mng_dept.value = mng_dept;
		fm.mng_nm.value = mng_nm;
		fm.mng_pos.value = mng_pos;				
//		fm.mng_dept.focus();
		window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus()">
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=500>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>과태료청구기관조회</span></span></td>
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
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td width="275">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssc.gif align=absmiddle> : 
                    <input type="text" name="t_wd" size="30" class="text" value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                    </td>
                    <td width="160"><a href='javascript:search()'><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=10%>연번</td>
                    <td width=40% class='title'>기관명</td>
                    <td width=20% class='title'>담당부서</td>
                    <td width=30% class='title'>연락처</td>
                </tr>
                <%for(int i = 0 ; i < fine_size ; i++){
				FineGovBn = (FineGovBean)fines.elementAt(i);%>				  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><a href="javascript:search_ok('<%=FineGovBn.getGov_id()%>','<%=FineGovBn.getGov_nm()%>','<%=FineGovBn.getMng_dept()%>','<%=c_db.getNameByIdCode("0010", "", FineGovBn.getGov_st())%>','<%=FineGovBn.getMng_nm()%>','<%=FineGovBn.getMng_pos()%>')" onMouseOver="window.status=''; return true"><%=FineGovBn.getGov_nm()%></a></td>
                    <td><%=FineGovBn.getMng_dept()%></td>
                    <td><%=FineGovBn.getTel()%></td>
                </tr>
                <%}%>		  		  
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
