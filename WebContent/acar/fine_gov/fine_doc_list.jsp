<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
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
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
		
	
	Vector fines = FineDocDb.getFineDocLists("관리", br_id, gubun1, gubun2, gubun3, gubun4, "", st_dt, end_dt, s_kd, t_wd, sort, asc);
	int fine_size = fines.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//출력하기
	function FineDocPrint(doc_id){
		var SUBWIN="../fine_doc_mng/fine_doc_print.jsp?doc_id="+doc_id;	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=720, height=700, scrollbars=yes, status=yes");			
	}

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='seq_no' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=7%>연번</td>
                    <td width=25% class='title'>문서번호</td>
                    <td width=23% class='title'>시행일자</td>
                    <td width=22% class='title'>이의신청건수</td>
                    <td width=23% class='title'>인쇄여부</td>
                </tr>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><a href="javascript:FineDocPrint('<%=ht.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a></td>
                    <td><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
                    <td><%=ht.get("CNT")%>건</td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%></td>
                </tr>
              <%}%>		  
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
