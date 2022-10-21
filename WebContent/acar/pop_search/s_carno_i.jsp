<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>고객등록</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;	
		if(fm.car_no.value == '')			{	alert('차량번호를 입력하십시오');		fm.car_no.focus();  		return;	}
		else if(fm.init_reg_dt.value == ''){	alert('최초등록일자를 입력하십시오');	fm.init_reg_dt.focus();		return;	}
		else if(fm.br_id.value = '')		{	alert('관리지점을 선택해 주세요!');		fm.br_id.focus();			return;	}	
		
		if(!confirm('등록하시겠습니까?'))	return;
		
		fm.target='i_no';
		fm.action='./s_carno_i_a.jsp'
		fm.submit();
		
	}
	
	function checkCarNo(){
		fm = document.form1;
		if(fm.car_no.value == ''){	alert("차량번호를 입력해 주세요!");	fm.car_no.focus(); return; }
		fm.target = "i_no";
		fm.action = "./s_carno_chk.jsp";
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.car_no.focus();">

<form name='form1' method='post'>
  <table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
      <td><font color="#666600">< 등록번호 관리 ></font>&nbsp;</td>
  </tr>
  <tr>
    <td class='line'>            
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class='title' width="20%"> 차량번호</td>
            <td colspan='3' align='left'>&nbsp; <a href="javascript:checkCarNo();"><span  class="pop">[중복체크]</span></a> 
              <input type='text' name="car_no" size='20' class='text' style="IME-MODE:active;">
            </td>
          </tr>
          <tr> 
            <td class='title' width="20%">최초등록일자</td>
            <td width="30%">&nbsp; <input type='text' name='init_reg_dt' size='13' class='text' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' value=""> 
            </td>
            <td width='20%' class="title">등록지역</td>
            <td width='30%'>&nbsp; <input type="radio" name="reg_ext" value="1" checked>
              서울 
              <input type="radio" name="reg_ext" value="2">
              경기</td>
          </tr>
          <tr> 
            <td class='title'>관리지점</td>
            <td><select name='br_id'>
                <option value='' selected>선택</option>
                <option value='I1' > 인천영업소 </option>
                <option value='K1' > 파주영업소 </option>
                <option value='S1' > 본사 </option>
                <option value='S2' > 중앙영업소 </option>
                <option value='S3' > OTO </option>
              </select></td>
            <td class="title">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
	</td>
  </tr>
  <tr height="30">
	  <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="../images/bbs/but_in.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
        &nbsp;&nbsp;<a href='javascript:history.go(-1);'><img src="../images/bbs/but_backgo.gif" width="70" height="18" aligh="absmiddle" border="0"></a> 
      </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>