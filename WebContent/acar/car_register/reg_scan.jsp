<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cha_seq 		= request.getParameter("cha_seq")==null?"":request.getParameter("cha_seq");
	String subject 		= request.getParameter("subject")==null?"":request.getParameter("subject");
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
		
		var file = fm.file.value;
		file = file.slice(file.indexOf("\\") +1 );
		ext = file.slice(file.indexOf(".")).toLowerCase();
				
		if(ext != '.jpg'){
			alert('JPG가 아닙니다. JPG로 스캔한 파일만 등록이 가능합니다.');
			return;
		}
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
				
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.CAR_CHANGE%>";
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="car_mng_id" 	value="<%=car_mng_id%>">
  <input type='hidden' name="cha_seq" 		value="<%=cha_seq%>">  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;
                    	<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
                    	<span class=style1><span class=style5>스캔등록</span></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<%if(!subject.equals("")){%><span><b>차량번호 : <%=subject%></b></span><%} %>
                    </td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>	
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width=15%>스캔파일</td>
                    <td width=85%>&nbsp;
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=car_mng_id%><%=cha_seq%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.CAR_CHANGE%>'>        			
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
            <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
            <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>
</table>
</form>
</center>
</body>
</html>
