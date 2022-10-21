<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id  = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd  	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String emp_id 		= request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String agnt_st 		= request.getParameter("agnt_st")==null?"1":request.getParameter("agnt_st");
	String file_st	 	= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	String remove_seq	= request.getParameter("remove_seq")==null?"":request.getParameter("remove_seq");
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		fm = document.form1;
		if(fm.file.value == ""){	alert("파일을 선택해 주세요!");		fm.file.focus();	return;		}		

		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;

		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.COMMI%>";				
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="emp_id" 		value="<%=emp_id%>">    
  <input type='hidden' name="agnt_st" 		value="<%=agnt_st%>">    
  <input type='hidden' name="remove_seq"	value="<%=remove_seq%>">
  <input type='hidden' name="from_page"		value="<%=from_page%>">  
  <input type='hidden' name="seq" 			value="">
<table border="0" cellspacing="0" cellpadding="0" width=570>
      <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>스캔등록</span></span></td>
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
        <td align="right" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>스캔파일</td>
                    <td >&nbsp;
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=rent_mng_id%><%=rent_l_cd%><%=agnt_st%><%=file_st%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.COMMI%>'>        			
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%}%>
            <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
