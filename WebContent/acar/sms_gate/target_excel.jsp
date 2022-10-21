<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>

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
		var fm = document.form1;
		if(fm.filename.value == ''){					alert('파일을 선택하십시오.'); 						return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('엑셀파일이 아닙니다.');						return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003통합문서(*.xls)가 아닙니다.');	return;		}
				
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='target_excel_list.jsp' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=750>
      <tr> 
        <td> <font color="red">[ 엑셀파일을 이용한 SMS 전송  ]</font></td>
      </tr>
      <tr>
        <td align="right" class="line">
		  <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr>
              <td width="15%" class='title'>파일</td>
              <td>&nbsp;
			    <input type="file" name="filename" size="60">
              </td>
            </tr>
          </table>
		</td>
      </tr>
      <tr>
        <td align="center"><span class="style1">- 양식폼 - </span></td>
      </tr>      
      <tr>
        <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0">
            <tr>
              <td width="200" class="title">수신자</td>
              <td width="200" class="title">수신번호</td>
              <td width="350" class="title">문자내용</td>
            </tr>
          </table>
		</td>
      </tr>  	  
      <tr>
        <td align="right">* 문자내용이 별도로 없는 경우 휴대폰 디스플레이에 있는 내용을 공통으로 보냅니다.</td>
      </tr>
      <tr>
        <td align="right"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
      </tr>
    </table>
  </form>
</center>
</body>
</html>
