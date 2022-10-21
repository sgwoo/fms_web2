<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.add_mark.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String c_st = request.getParameter("c_st")==null?"":request.getParameter("c_st");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	CodeBean[] depts = c_db.getCodeAll2(c_st, ""); /* 코드 구분:부서명-가산점적용 */	
	int dept_size = depts.length;
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function UpdateList(code,nm,app_st){
		var theForm = document.SMenuForm;
		theForm.m_st.value = st;
		theForm.m_cd.value = cd;
		theForm.m_nm.value = nm;
		theForm.url.value = url;
		theForm.note.value = note;
		theForm.seq.value = seq;
	}

	function SMenuReg(){
		var theForm = document.SMenuForm;
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "i";
		theForm.target="i_no";
		theForm.submit();
	}

	function SMenuUp(){
		var theForm = document.SMenuForm;
		var nm = theForm.m_nm.value;
		if(!confirm(nm + '을 수정하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "u";
		theForm.target="i_no";
		theForm.submit();
	}

	function SMenuDel(){
		var theForm = document.SMenuForm;
		var delCount = 0;	
		for (i=0 ; i <theForm.ch_m_cd.length; i++) {
    		if (theForm.ch_m_cd[i].checked){
				delCount++;
		    }
	    }
		if(delCount==0){
			alert("먼저 삭제할 목록을 선택하십시요.");
			return;
		}
		if(!confirm('삭제하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "d";
		theForm.target="i_no";
		theForm.submit();
	}

	function SMenuSearch(){
		var theForm = document.SMenuSearchForm;
		var theForm1 = document.SMenuForm;
		theForm.m_st.value = theForm1.m_st.value;
		theForm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./s_menu_null_ui.jsp" name="SMenuForm" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width="300">
    <tr>
    	<td class=line>
            
        <table border="0" cellspacing="1" cellpadding="0" width="300">
          <tr> 
            <td class=title width="80">부서명</td>
            <td width=110 align="center"> 
              <input type="hidden" name="m_cd" value="">
              <input type="text" name="nm" value="" size="12" class=text>
            </td>
            <td class=title width="80">적용여부</td>
            <td align=center width="30"> 
              <input type="checkbox" name="app_st" value="checkbox">
            </td>
          </tr>
        </table>
        </td>
    </tr>
    <tr>
    	<td align=right><a href="javascript:SMenuReg()">등록</a>&nbsp;<a href="javascript:SMenuUp()">수정</a>&nbsp;<!--<a href="javascript:SMenuDel()">삭제</a>&nbsp;--><a href="javascript:self.close();window.close();">닫기</a></td>
    </tr>
    <tr>
        <td class=line>
            
        <table border="0" cellspacing="1" cellpadding="0" width="300">
          <tr> 
            <td width="30" class=title>연번</td>
            <td width="150" class=title>부서명</td>
            <td class=title>적용여부</td>
          </tr>
		  <%for(int i = 0 ; i < dept_size ; i++){
				CodeBean dept = depts[i];%>		
          <tr> 
            <td align=center><%=i+1%></td>
            <td align=center><a href="javascript:UpdateList('<%=dept.getCode()%>','<%=dept.getNm()%>','<%=dept.getApp_st()%>')"><%=dept.getNm()%></a></td>
            <td align=center><%=dept.getApp_st()%></td>
          </tr>
          <%	}%>
        </table>
        </td>
    </tr>
</table>
<input type="hidden" name="cmd" value="">
</form>
<form action="./s_menu_i.jsp" name="SMenuSearchForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="m_st" value="<%//=m_st%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>