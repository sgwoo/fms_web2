<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
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
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
		
	
	Vector fines = FineDocDb.getFineSearchLists(t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int fine_size = fines.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
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
                    <td width='25%' class='title'>고지서번호</td>
                    <td width='15%' class='title'>차량번호</td>
                    <td width='17%' class='title'>상호</td>
                    <td width='18%' class='title'>위반일시</td>
                    <td width='18%' class='title'>위반내용</td>
                </tr>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable fine = (Hashtable)fines.elementAt(i);%>		  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><a class=index1 href="javascript:MM_openBrWindow('../fine_doc_reg/fine_c.jsp?m_id=<%=fine.get("RENT_MNG_ID")%>&l_cd=<%=fine.get("RENT_L_CD")%>&c_id=<%=fine.get("CAR_MNG_ID")%>&seq_no=<%=fine.get("SEQ_NO")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=600,left=100, top=100')"><%=fine.get("PAID_NO")%></a></td>
                    <td><%=fine.get("CAR_NO")%></td>
                    <td><span title='<%=fine.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(fine.get("FIRM_NM")), 7)%></span></td>
                    <td><span title='<%=fine.get("VIO_CONT")%>'><%=AddUtil.ChangeDate3(String.valueOf(fine.get("VIO_DT")))%></span></td>
                    <td><%=fine.get("VIO_CONT")%></td>
                </tr>
              <%}%>		  
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
