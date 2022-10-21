<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String rpt_no 		= request.getParameter("rpt_no")==null? "":request.getParameter("rpt_no");
	String contentSeq 	= request.getParameter("contentSeq")==null? "":request.getParameter("contentSeq");
%>
<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#saveScanFile").on("click", function(){		
		fm = document.form1;
		var file = $("#file").val();
		var contentSeq = $("#contentSeq").val();
		var str_dotlocation,str_ext,str_low, str_value;
	    str_value  			= fm.file.value;
	    str_low   			= str_value.toLowerCase(str_value);
	    str_dotlocation 	= str_low.lastIndexOf(".");
	    str_ext   			= str_low.substring(str_dotlocation+1);
	    
		if(file == ""){	alert("파일을 선택해 주세요!");	return; }	
		if( str_ext != 'gif'  &&  str_ext != 'jpg' ) {
			alert("jpg  또는 gif만 등록됩니다." );
			return;
		}
		else{
			if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
			fm.<%=Webconst.Common.contentSeqName%>.value = contentSeq;
			fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.LC_SCAN%>";			
			fm.submit();
		}
	});
});
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post' enctype="multipart/form-data">
<table width=450 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>세금계산서 스캔등록</span></span></td>
        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
    </tr>
    <tr height="10px;"></tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width='450'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='450' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
	                <td width="140" class='title'>계출번호</td>
	                <td width="310" class='title' colspan="2">세금계산서 스캔</td>
			    </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='line' width='450' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td  width='140' align='center'><%=rpt_no%></td>
					<td  width='310' align='center' colspan="2">								
						<input type="file" name="file" id="file" size="50" class="text">
						<input type="hidden" name="contentSeq" id="contentSeq" value="<%=contentSeq%>">
						<input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.LC_SCAN%>'>
					</td>				
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<div style="margin-top: 10px;" align="center">
	<a id="saveScanFile"><img src=/acar/images/center/button_save.gif align=absmiddle border=0 style="width: 50px; height: 25px;"></a>
</div>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>