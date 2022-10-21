<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");

	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "07", "01", "02");

	CommonDataBase c_db = CommonDataBase.getInstance();

%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
<!--
	function save()
	{
		if(confirm('저장하시겠습니까?'))
		{
			var fm = document.form1;
					
			if((fm.reg_dt.value == '') || !isDate(fm.reg_dt.value))		{	alert('등록일을 확인하십시오');	return;	}
			else if(fm.credit_method.value == '')					{	alert('방식을 확인하십시오');	return;	}
			else if(fm.credit_desc.value == '')						{	alert('사유를 확인하십시오');	return;	}
			fm.action = 'credit_memo_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
-->

</script>
</head>
<body leftmargin="15">
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 > 연체관리 > <span class=style5>채권추심</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=20%>의뢰일</td>
                    <td width=80%>&nbsp;<input type='text' name='reg_dt' size='12' class='text' onBlur='javascript:this.value = ChangeDate(this.value);' value = '<%=Util.getDate()%>' ></td>
                </tr>
                <tr> 
                    <td class='title'>작성자</td>
                    <td>&nbsp;<%=c_db.getNameById(user_id, "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>방식</td>
                    <td> 
                    &nbsp;<select name="credit_method" >
                        <option value="" >-- 선택 --</option>
                        <option value="1" >보증보험 청구</option>
                        <option value="2" >추심업무 의뢰</option>
                           	
                      </select>
                    </td>                         
                </tr>
                <tr> 
                    <td class=title>사유</td>
                    <td> 
                      &nbsp;<textarea name="credit_desc" cols="51" class="text" rows="7"></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp; 
        <a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
