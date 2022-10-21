<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String actn_id 	= request.getParameter("actn_id")==null?"":request.getParameter("actn_id");
	String actn_dt 	= request.getParameter("actn_dt")==null?"":request.getParameter("actn_dt");
	String actn_su 	= request.getParameter("actn_su")==null?"":request.getParameter("actn_su");
	String file_st	= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	//등록하기
	function save(){
		fm = document.form1;
		if(fm.filename2.value == ""){	alert("파일을 선택해 주세요!");		fm.filename2.focus();	return;		}		
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		//fm.target = "i_no";
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/fine_mng_reg_scan_a.jsp";
		fm.submit();
	}
	
	function file_save(){
		var fm = document.form1;	
				
		if(!confirm('파일등록하시겠습니까?')){
			return;
		}
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.ACTN_SCAN%>";
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
  <input type="hidden" name="actn_id" 		value="<%=actn_id%>">
  <input type='hidden' name='actn_dt' 		value='<%=actn_dt%>'>
  <input type='hidden' name='actn_su' 		value='<%=actn_su%>'>
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
                    <td class='title' width=15%>사업자등록증</td>
                    <td width=85%>&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=actn_id%><%=actn_dt%><%=actn_su%>1' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.ACTN_SCAN%>' />
                    </td>
                </tr>
				<tr>
                    <td class='title' width=15%>낙찰확인서</td>
                    <td width=85%>&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=actn_id%><%=actn_dt%><%=actn_su%>2' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.ACTN_SCAN%>' />
                    </td>
                </tr>
				<tr>
                    <td class='title' width=15%>세금계산서</td>
                    <td width=85%>&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=actn_id%><%=actn_dt%><%=actn_su%>3' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.ACTN_SCAN%>' />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right"><a href="javascript:file_save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp; <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
