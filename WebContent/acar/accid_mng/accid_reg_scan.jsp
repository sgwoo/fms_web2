<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String gubun 	= request.getParameter("gubun")  ==null?"":request.getParameter("gubun");

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

		function file_save(){
		var fm = document.form1;	
				
		if(!confirm('파일등록하시겠습니까?')){
			return;
		}
			
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.BBS%>";	
	<%-- 	fm.action = "http://localhost:8088/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.BBS%>"; --%>	
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
	<input type='hidden' name="c_id" 	value="<%=c_id%>">
	<input type='hidden' name="accid_id" 	value="<%=accid_id%>">

<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>첨부파일</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
   
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <% if ( gubun.equals("1") )  {%>
                <tr>
                    <td class='title'>사고사실확인서</td>
                    <td >&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=c_id%><%=accid_id%>1' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.ACCIDENT%>' />
                    </td>
                </tr>
				<tr>
                    <td class='title'>사고수리견적서</td>
                    <td >&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=c_id%><%=accid_id%>2' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.ACCIDENT%>' />
                    </td>
                </tr>
				<tr>
                    <td class='title'>기타1</td>
                    <td >&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=c_id%><%=accid_id%>3' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.ACCIDENT%>' />
                    </td>
                </tr>
				<tr>
                    <td class='title'>기타2</td>
                    <td >&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=c_id%><%=accid_id%>4' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.ACCIDENT%>' />
                    </td>
                </tr>
             <%} else if ( gubun.equals("2") )  {%>   
                <tr>
                    <td class='title'>판결문</td>
                    <td >&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=c_id%><%=accid_id%>6' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.ACCIDENT%>' />
                    </td>
                </tr>
             <% } else { %>   
				<tr>
                    <td class='title'>소장</td>
                    <td >&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=c_id%><%=accid_id%>5' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.ACCIDENT%>' />
                    </td>
                </tr>
              <% } %>  
            </table>
        </td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:file_save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
        &nbsp;<a href='javascript:window.close()'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
