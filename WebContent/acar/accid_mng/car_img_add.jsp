<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	
	AccidDatabase ac_db = AccidDatabase.getInstance();
	
	//계약:고객관련
	PicAccidBean pa_r [] = ac_db.getPicAccidList(c_id, accid_id);
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
//		fm.target = "i_no";
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/accid_mng_car_img_add_a.jsp";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=450>
<form name='form1' action='' method='post' enctype="multipart/form-data">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>	
    <input type='hidden' name='c_id' value='<%=c_id%>'>	
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='content_code' value='PIC_ACCID'>
	<input type='hidden' name='cmd' value='i'>
    <tr> 
      <td class=line colspan="2"> 
        <table border=0 cellspacing=1 width=450>
          <tr> 
            <td class=title width="100">파일첨부</td>
            <td>
              <input type="file" name="filename" size="30" class=text>
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
