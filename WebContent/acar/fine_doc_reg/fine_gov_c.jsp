<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
		
	
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");	
	FineGovBn = FineDocDb.getFineGov(gov_id);
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->

//수정하기
function fine_doc_upd(){
	var fm = document.form1;

	if(!confirm('수정하시겠습니까?')){	return;	}
	fm.action = "fine_gov_c_a.jsp";
	fm.target = "i_no";
	fm.submit()
}
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=15%>기관명</td>
                    <td width=35%>&nbsp;<%=FineGovBn.getGov_nm()%></td>
                    <td class='title' width=15%>참조</td>
                    <td width=35%>&nbsp;<%=FineGovBn.getMng_dept()%></td>
                </tr>
                <tr>
                	<td class='title'>문서24 기관명</td>
                    <td width=85% colspan="3">
                    	&nbsp;<input type="text" name="gov_nm2" value="<%=FineGovBn.getGov_nm2()%>" style="vertical-align: middle; width: 85%;">&nbsp;&nbsp;<a href="javascript:fine_doc_upd();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0 style="vertical-align: middle; align: right; " ></a>
                    	<input type="hidden" name="gov_id" value="<%=FineGovBn.getGov_id()%>">
                    </td>
                </tr>
                <tr>
                	<td class='title'>기관부서코드</td>
                    <td width=85% colspan="3">
                    	&nbsp;<input type="text" name="gov_dept_code" value="<%=FineGovBn.getGov_dept_code()%>" size='15'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>담당자명</td>
                    <td>&nbsp;<%=FineGovBn.getMng_nm()%></td>
                    <td class='title'>직급</td>
                    <td>&nbsp;<%=FineGovBn.getMng_pos()%></td>
                </tr>		  
                <tr> 
                    <td class='title'>연락처</td>
                    <td>&nbsp;<%=FineGovBn.getTel()%></td>
                    <td class='title'>팩스</td>
                    <td>&nbsp;<%=FineGovBn.getFax()%></td>
                </tr>
                <tr> 
                    <td class='title'>주소</td>
                    <td colspan="3">&nbsp;(<%=FineGovBn.getZip()%>) <%=FineGovBn.getAddr()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td align="right" ><a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>	    
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
