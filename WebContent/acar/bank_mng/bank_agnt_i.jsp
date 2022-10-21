<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.bank_mng.*"%>
<jsp:useBean id="bl_db" scope="session" class="acar.bank_mng.BankLendDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function add_agnt()
	{
		var fm = document.form1;
		if(fm.page_gubun.value == 'REG')
		{
			alert('은행대출내용을 먼저 등록하십시오');	return;
		}
		else
		{
			if(confirm('등록하시겠습니까?'))
			{
				if(fm.ba_nm.value == '')	{	alert('담당자 이름을 입력하십시오');	return;	}
				fm.submit_gubun.value = 'R';	//등록
				fm.target='i_no';
				fm.submit();
			}
		}
	}
	function select_this(seq, nm, title, tel, email)
	{
		var fm = document.form1;
		fm.seq.value = seq;
		fm.ba_nm.value = nm;
		fm.ba_tel.value = tel;
		fm.ba_title.value = title;
		fm.ba_email.value = email;
	}
	
	function modify_agnt()
	{
		var fm = document.form1;
		if(fm.seq.value == '')			{	alert('등록된 사용자를 선택하고 수정한 후 수정버튼을 누르십시오');	return;	}
		else if(confirm('수정하시겠습니까?'))
		{
			if(fm.ba_nm.value == '')	{	alert('담당자 이름을 입력하십시오');	return;	}
			fm.submit_gubun.value = 'M';	//수정
			fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");

	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String page_gubun = request.getParameter("page_gubun")==null?"":request.getParameter("page_gubun");
	Vector agnts = bl_db.getBankAgnts(lend_id);
	int agnt_size = agnts.size();
%>
<body>
<form action="/acar/bank_mng/bank_agnt_i_a.jsp" name="form1" method="POST">
<input type='hidden' name='page_gubun' value='<%=page_gubun%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='submit_gubun' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=800>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td width='150' class=title>담당자</td>
                    <td width='150' class=title>직위</td>
                    <td width='150' class=title>연락처</td>
                    <td width='350' class=title>담당자이메일</td>
                </tr>
<%
	if(agnt_size > 0)
	{
		for(int i = 0 ; i < agnt_size ; i++)
		{
			BankAgntBean agnt = (BankAgntBean)agnts.elementAt(i);
%>
                <tr>
                	<td align='center'><a href="javascript:select_this('<%=agnt.getSeq()%>', '<%=agnt.getBa_nm()%>', '<%=agnt.getBa_title()%>', '<%=agnt.getBa_tel()%>', '<%=agnt.getBa_email()%>')" onMouseOver="window.status=''; return true"><%=agnt.getBa_nm()%></a></td>
                	<td align='center'><%=agnt.getBa_title()%></td>
                	<td align='center'><%=agnt.getBa_tel()%></td>
                	<td align='center'><%=agnt.getBa_email()%></td>
                </tr>
<%		}
	}else{
%>
					<td colspan='4'>등록된 담당자가 없습니다</td>
<%	}
%>
            </table>
        </td>	
	</tr>
	<tr>
		<td></td>
	</tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td width='70' class=title>담당자</td>
                    <td width='100' align="center"><input type='hidden' name='seq' value=''>
                    	<input type="text" name="ba_nm" value="" size="20" maxlength='30' class=text></td>
                    <td width='70' class=title>직위</td>
                    <td width='100' align="center"><input type="text" name="ba_title" value="" size="20" maxlength='30' class=text></td>
                    <td width='70' class=title>연락처</td>
                    <td width='100' align="center"><input type="text" name="ba_tel" value="" size="15" maxlength='15' class=text></td>
                    <td width='70' class=title>E-mail</td>
                    <td width='150' align="center"><input type="text" name="ba_email" value="" size="20" maxlength='50' class=text></td>
                    <td width='70' align="center">
					<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                    		<a href="javascript:add_agnt()" onMouseOver="window.status=''; return true">등록</a>
					<%	if(page_gubun.equals("MOD"))	{%>
                    		<a href="javascript:modify_agnt()" onMouseOver="window.status=''; return true">수정</a>
					<%	}%>
					<%}%>
                 </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</iframe>
</body>
</html>