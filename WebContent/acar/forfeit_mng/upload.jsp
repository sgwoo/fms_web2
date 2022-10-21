<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"1":request.getParameter("seq_no");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String gubun = request.getParameter("gubun")==null?"pdf":request.getParameter("gubun");
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(){
		var fm = document.form1;	
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		fm.target = "i_no";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=450>
<form name='form1' action='upload_a.jsp' method='post' enctype="multipart/form-data">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type="hidden" name="seq_no" value="<%=seq_no%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
    <tr> 
      <td class=line colspan="2"> 
        <table border=0 cellspacing=1 width=450>
          <tr> 
            <td class=title width="100">파일첨부</td>
            <td>
              <input type="file" name="filename2" size="30" class=text>
              </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td></td>
      <td align="right"><a href="javascript:save()">확인</a>&nbsp;&nbsp;<a href="javascript:window.close()">닫기</a></td>
    </tr>	
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
