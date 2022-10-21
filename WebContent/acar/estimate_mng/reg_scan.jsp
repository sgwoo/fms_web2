<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String content_code 	= request.getParameter("content_code")==null?"":request.getParameter("content_code");
	String content_seq 	= request.getParameter("content_seq")==null?"":request.getParameter("content_seq");
	String file_st_nm 	= request.getParameter("file_st_nm")==null?"":request.getParameter("file_st_nm");
	
	
	if(content_code.equals("") && content_seq.equals("")){
		return;
	}
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
		
		if(fm.file.value == ""){		alert("파일을 선택해 주세요!");		fm.file.focus();		return;		}
		
		var str_dotlocation,str_ext,str_low, str_value;
    str_value  			= fm.file.value;
    str_low   			= str_value.toLowerCase(str_value);
    str_dotlocation = str_low.lastIndexOf(".");
    str_ext   			= str_low.substring(str_dotlocation+1);
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
			
		fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value;
						
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.ESTI_SPE%>";

		fm.submit();
	}
	
//-->
</script>
</head>

<body onload='javascript:document.form1.file.focus();'>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>스캔등록 : 차량예약관리 </span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr> 
        <td>&nbsp;</td>
    </tr>
  <tr>
	 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=file_st_nm%></span></td>
  </tr>    
    <tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>스캔파일</td>
                    <td>
                        <input type="file" name="file" size="70" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=content_seq%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.ESTI_SPE%>'>                               			    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right">
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;            
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
