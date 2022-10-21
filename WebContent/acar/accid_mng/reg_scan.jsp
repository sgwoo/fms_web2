<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String accid_id	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
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
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.PIC_RESRENT_ACCID%>";		
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 	value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 	value="<%=user_id%>">
  <input type='hidden' name="br_id"   	value="<%=br_id%>">
  <input type="hidden" name="m_id" 	value="<%=m_id%>">
  <input type='hidden' name='c_id' 	value='<%=c_id%>'>
  <input type='hidden' name='l_cd' 	value='<%=l_cd%>'>
  <input type="hidden" name="seq_no" 	value="<%=seq_no%>">
  <input type='hidden' name="accid_id"	value="<%=accid_id%>">  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
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
        <td class=line2 colspan=2></td>
    </tr>	
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='15%'>구분</td>
                    <td>&nbsp;대차차량 계약서</td>
                </tr>			
                <tr>
                    <td class='title' width=15%>스캔파일</td>
                    <td width=85%>&nbsp;
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=c_id%><%=accid_id%><%=seq_no%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.PIC_RESRENT_ACCID%>'>        			
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
