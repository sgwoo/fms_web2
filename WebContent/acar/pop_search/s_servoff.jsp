<html>
<head><title>정비업체 조회</title>
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
      <td align='left' colspan="2"><font color="#666600">- 정비업체 조회 -</font></td>
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
          <option value="1" selected>상호</option>
        </select>
        <input type='text' class='text' name='t_con_cd42' size='15' readonly>
        <a href="#" target="d_content"><img src="../images/bbs/but_search.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a> 
      </td>
      <td align='right'><a href="#" target="d_content"><img src="../images/bbs/but_in.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="6%">연번</td>
            <td class='title' width="39%">상호</td>
            <td class='title' width="15%">대표자</td>
            <td class='title' width="20%">사업자등록번호</td>
            <td class='title' width="20%">연락처</td>
          </tr>
          <tr> 
            <td align="center">1</td>
            <td><a href="#">명진자동차공업사</a></td>
            <td align="center">&nbsp;</td>
            <td align="center">&nbsp;</td>
            <td align="center">306-5986~7</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='right' colspan="2"><a href="#"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a> 
        <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
