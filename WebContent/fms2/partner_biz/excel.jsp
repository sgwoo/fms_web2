<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;
		fm.action = 'excel_card.jsp';
		
		if(fm.filename.value == ''){					alert('파일을 선택하십시오.'); 		return; 	}
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=570>
      <tr> 
        <td> <font color="red">[ 엑셀파일을 이용한 명함등록  ]</font></td>
      </tr>
      <tr>
        <td align="right" class="line">
		  <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr>
              <td width="15%" class='title'>파일</td>
              <td>&nbsp;
			    <input type="file" name="filename" size="50">
              </td>
            </tr>

          </table>
		</td>
      </tr>
      <tr>
        <td align="right">&nbsp;</td>
      </tr>
      <tr>
        <td align="right"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" aligh="absmiddle" border="0"></a>&nbsp;
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif"  aligh="absmiddle" border="0"></a></td>
      </tr>
    </table>
  </form>
</center>
</body>
</html>
