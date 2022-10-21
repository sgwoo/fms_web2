<html>
<head><title>대폐차번호 조회</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10">
<form name='form1' action='get_con_cd_p.jsp' method='post'>
<input type='hidden' name='h_com' value=''>
<input type='hidden' name='com_nm' value=''>
<input type='hidden' name='com_id' value=''>
<input type='hidden' name='car_cd' value=''>
<input type='hidden' name='car_nm' value=''>
<input type='hidden' name='car_name' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td align='left'><font color="#666600">- 대폐차번호 조회 -</font></td>
    </tr>
	<!--
    <tr> 
      <td align='left'> 
        <input type="radio" name="radiobutton" value="radiobutton" checked>
        전체 
        <input type="radio" name="radiobutton" value="radiobutton">
        대여중인 차량만 
        <input type="radio" name="radiobutton" value="radiobutton">
        대기중인 차량만</td>
    </tr>-->
    <tr> 
      <td align='left'> 
        <select name="gubun1">
          <option value="0" selected>지역</option>
          <option value="1">서울</option>
          <option value="2">경기</option>
        </select>
        <font color="#999999">(미사용중인 번호 목록) </font></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="6%">연번</td>
            <td class='title' width="20%">차량번호</td>
            <td class='title' width="30%">최초등록일자</td>
            <td class='title' width="30%">말소일자</td>
            <td class='title' width="14%">상태</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='right'><a href="#"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a> 
        <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

