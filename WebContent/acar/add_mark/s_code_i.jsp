<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.add_mark.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String c_st = request.getParameter("c_st")==null?"":request.getParameter("c_st");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "11", "03", "04");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CodeBean[] depts = c_db.getCodeAll2(c_st, ""); /* 코드 구분:부서명-가산점적용 */
	int dept_size = depts.length;
	
	String nm = "";
	if(c_st.equals("0002")) 		nm = "부서";
	else if(c_st.equals("0005")) 	nm = "대여방식";
	
	String nm1 = "";
	if(c_st.equals("0002")) 		nm1 = "<img src=../images/pop/arrow_bsgl.gif>";
	else if(c_st.equals("0005")) 	nm1 = "<img src=../images/pop/arrow_dybsgl.gif>";
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function UpdateList(code,nm_cd,nm,app_st){
		var fm = document.form1;
		fm.code.value = code;
		fm.nm_cd.value = nm_cd;
		fm.nm.value = nm;
		if(app_st == 'Y'){	
			fm.app_st.checked = true;			
		}else{
			fm.app_st.checked = false;
		}		
	}

	function CodeReg(){
		var fm = document.form1;
		if(fm.code.value != ''){ alert("이미 등록된 코드입니다."); return;}
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.cmd.value = "i";
		fm.target="i_no";
		fm.submit();
	}

	function CodeUp(){
		var fm = document.form1;
		if(fm.code.value == ''){ alert("코드를 선택하십시오."); return;}		
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		fm.cmd.value = "u";
		fm.target="i_no";
		fm.submit();
	}
	
	function CodeClose(){
		<%if(!c_st.equals("0007")){%>
		parent.opener.location = "/acar/add_mark/add_mark_s_frame.jsp";
		opener.Search();
		<%}%>		
		self.close();
		window.close();
	}


//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./s_code_null_ui.jsp" name="form1" method="POST" >
<input type="hidden" name="cmd" value="">
<input type="hidden" name="c_st" value="<%=c_st%>">
<table border=0 cellspacing=0 cellpadding=0 width="525">
    <tr>
    	<td><%=nm1%></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>            
            <table border="0" cellspacing="1" cellpadding="0" width="525">
                <tr> 
                    <td class=title width=90><%=nm%>명</td>
                    <td align="center" width=160> 
                      <input type="hidden" name="code" value="">
                      <input type="text" name="nm" value="" size="21" class=text>
                    </td>
                    <td class=title width=50>CD</td>
                    <td align="center" width=95>               
                      <input type="text" name="nm_cd" value="" size="10" class=text>
                    </td>
                    <td class=title width=80>적용여부</td>
                    <td align=center width=50> 
                      <input type="checkbox" name="app_st" value="Y">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
    	<td align=right>
		<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>				  
		<a href="javascript:CodeReg()"><img src=../images/pop/button_reg.gif border=0></a>&nbsp;<a href="javascript:CodeUp()"><img src=../images/pop/button_modify.gif border=0></a>
		<!--<a href="javascript:SMenuDel()">삭제</a>&nbsp;-->
		<%}%>
		<a href="javascript:CodeClose();"><img src=../images/pop/button_close.gif border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="0" width="525">
                <tr> 
                    <td width="40" class=title>연번</td>
                    <td width="237" class=title><%=nm%>명</td>
                    <td width="120" class=title>CD</td>
                    <td class=title width="128">적용여부</td>
                </tr>
                  <%for(int i = 0 ; i < dept_size ; i++){
        				CodeBean dept = depts[i];%>
                <tr> 
                    <td align=center><%=i+1%></td>
                    <td align=center><a href="javascript:UpdateList('<%=dept.getCode()%>','<%=dept.getNm_cd()%>','<%=dept.getNm()%>','<%=dept.getApp_st()%>')"><%=dept.getNm()%></a></td>
                    <td align=center><%=dept.getNm_cd()%></td>
                    <td align=center><%=dept.getApp_st()%></td>
                </tr>
                  <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>