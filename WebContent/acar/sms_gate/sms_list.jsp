<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	var checkflag = "false";
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}

//-->
</script>
</head>

<body>
<table width="600" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td width="300"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>발송명단 리스트</span></td>
        <td width="280" align="right"><!--<a href="javascript:parent.open_result();">발송내역보기</a>--></td>
        <td width="20" align="right">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="3"><iframe src="./sms_list_t.jsp" name="smsList_t" width="100%" height="28" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <tr>
        <td colspan="3"><iframe src="about:blank" name="smsList_in" width="100%" height="500" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
</table>
</body>
</html>
