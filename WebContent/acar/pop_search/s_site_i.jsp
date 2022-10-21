<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ma.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
%>

<html>
<head>
<title>지점/현장등록</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//우편번호 검색
	function search_zip(str){
		window.open("./s_zip.jsp?idx="+str, "ZIP", "left=300, top=300, height=300, width=350, scrollbars=yes");
	}
		
	function save(){
		var fm = document.form1;	
		if(fm.site_nm.value == '')			{	alert('지점(현장)명을 입력하십시오');		return;	 }
		else if(fm.zip.value == '')			{	alert('우편번호를 입력하십시오'); 			return; }		
		else if(fm.addr.value == '')		{	alert('주소를 입력하십시오'); 				return; }
		
		if(!confirm('등록하시겠습니까?'))	return;

		fm.target='i_no';
		fm.submit();
	}

//-->
</script>
</head>
<body onload="javascript:document.form1.site_nm.focus();">
<form name='form1' action='./s_site_i_a.jsp' method='post'>
<input type="hidden" name="client_id" value="<%=client_id%>">
<table border=0 cellspacing=0 cellpadding=0 width='520'>
  <tr>
      <td><font color="navy">[ 지점/현장 등록 ]</font></td>
  </tr>
  <tr>
    <td class='line'>            
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td width='141' colspan="2" class='title'> 상호명</td>
            <td align='left'>&nbsp; <%=firm_nm%> </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>지점구분</td>
            <td>&nbsp;
			  <input type="radio" name="site_st" value="1" checked>
              지점 
              <input type="radio" name="site_st" value="2">
              현장</td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>지점명</td>
            <td>&nbsp; <input type='text' name='site_nm' value='' size='15' maxlength='15' class='text' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>지점장</td>
            <td>&nbsp; <input type='text' name='site_jang' value='' size='15' maxlength='15' class='text' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>사업자번호</td>
            <td>&nbsp; 
			  <input type='text' name='enp_no1' value='' size='3' class='text' maxlength='3'>
              - 
              <input type='text' name='enp_no2' value='' size='2' class='text' maxlength='2'>
              - 
              <input type='text' name='enp_no3' value='' size='5' class='text' maxlength='5'> 
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>개업년원일</td>
            <td>&nbsp; <input type='text' name='open_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value=""> 
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>전화번호</td>
            <td>&nbsp; <input type='text' name='tel' value='' size='15' maxlength='15' class='text'> 
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>팩스번호</td>
            <td>&nbsp; <input type='text' name='fax' value='' size='15' maxlength='15' class='text'></td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('zip').value = data.zonecode;
							document.getElementById('addr').value = data.address;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td height="26" colspan="2" class='title'>주소</td>
            <td height="26">&nbsp; <input type="text" name='zip' id="zip" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='addr' id="addr" size="47">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>담당자이름</td>
            <td>&nbsp; <input type='text' name='agnt_nm' size='20' class='text' maxlength='40' value="" style='IME-MODE: active'> 
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>담당자전화</td>
            <td>&nbsp; <input type='text' name='agnt_tel' size='20' class='text' maxlength='40' value=""> 
            </td>
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
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>