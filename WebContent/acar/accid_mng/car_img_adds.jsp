<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
		
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	
	function save(){
		var fm = document.form1;	
				
		if(!confirm('파일등록하시겠습니까?')){
			return;
		}
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.PIC_ACCID%>";
		fm.submit();
	}		
//-->
</script>
</head>

<body>
<form name='form1' action='' method='post' enctype="multipart/form-data">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='from_page' value='<%=from_page%>'>	            
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
	<td colspan="2">
	    <table width=100% border=0 cellpadding=0 cellspacing=0>
		<tr>
		    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
		    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>사진등록하기</span></span></td>
		    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
		</tr>
	    </table>
	</td>		
    </tr>
    <tr>
	<td class=h></td>
    </tr>  
    <tr>
	<td class=line2 colspan="2"></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <%for (int i = 0 ; i < 10 ; i++){%>
                <tr> 
                    <td class=title width=20%>사진 <%=i+1%></td>
                    <td width=80%> 
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=c_id%><%=accid_id%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.PIC_ACCID%>'>
                    </td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td><font color="#999999">♣ 사진은 10개씩 계속 추가할 수 있습니다.</font></td>
        <td align="right">
            <a href="javascript:save()"><img src="/acar/images/center/button_conf.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
            <a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
        </td>
    </tr>
    <tr> 
        <td><font color="#999999">♣ 사진은 1MB 이하로 등록해 주세요.</font></td>
        <td align="right"></td>
    </tr>
</table>
</form>
</body>
</html>
