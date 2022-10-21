<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.forfeit_mng.*, acar.user_mng.*"%>
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
	
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");	
	FineGovBn = FineDocDb.getFineGov(gov_id);
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--	
	//목록보기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "fine_gov_frame.jsp";
		fm.submit();
	}	
	
	//수정하기
	function fine_upd(){
		window.open("fine_gov_i.jsp?gov_id=<%=gov_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>", "REG_FINE_GOV", "left=200, top=200, width=550, height=450, scrollbars=yes");
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15 rightmargin=0>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='gov_id' value='<%=gov_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > <span class=style5>과태료청구기관</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align="right"><a href="javascript:go_list();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class="line"> 
                        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr> 
                                <td class='title' width=12%>기관명</td>
                                <td width=38%>&nbsp;<%if(FineGovBn.getUse_yn().equals("N")){%><font color="red">[사용금지]</font><%}%> <%=FineGovBn.getGov_nm()%></td>
                                <td class='title' width=12%>참조</td>
                                <td width=38%>&nbsp;<%=FineGovBn.getMng_dept()%></td>
                            </tr>
                            <tr>
                            	 <td class='title' width=12%>문서24 기관명</td>
                            	 <td>&nbsp;&nbsp;<%=FineGovBn.getGov_nm2()%></td>
                            	 <td class='title' width=12%>기관부서코드</td>
                            	 <td>&nbsp;&nbsp;<%=FineGovBn.getGov_dept_code()%></td>
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
                                <td class='title' width=12%>주소</td>
                                <td colspan="3" width=88%>&nbsp;(<%=FineGovBn.getZip()%>) <%=FineGovBn.getAddr()%></td>
                            </tr>
                        </table>
                    </td>
                    <td width=17>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:fine_upd();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
	<%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>위반리스트</span></td>
    </tr>
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td> 
                        <table border="0" cellspacing="0" cellpadding="0" width=100%>
                            <tr> 
                                <td align='center'> <iframe src="./fine_list.jsp?t_wd=<%=FineGovBn.getGov_nm()%>" name="i_no" width="100%" height="230" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                                </iframe> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>이의신청공문 발행대장</span></td>
    </tr>
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td> 
                        <table border="0" cellspacing="0" cellpadding="0" width=100%>
                            <tr> 
                                <td align='center'> <iframe src="./fine_doc_list.jsp?gubun1=<%=gov_id%>" name="i_no" width="100%" height="230" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                                </iframe> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}%>
    <tr> 
        <td align='right'>&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>
