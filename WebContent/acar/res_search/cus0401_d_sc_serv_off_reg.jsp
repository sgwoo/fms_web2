<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//우편번호 검색
	function search_zip(str){
		window.open("/acar/car_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
	
	function save(){
		var fm = document.form1;	
		//NN check
		if(fm.off_nm.value == '')			{	alert('상호를 입력하십시오');		return;	}
		else if(fm.own_nm.value == '')		{	alert('대표자를 입력하십시오');		return;	}			
		else if((fm.t_ent_no1.value == '') || (fm.t_ent_no2.value == '') || (fm.t_ent_no3.value == '')){ alert('사업자번호를 입력하십시오'); return; }
		else if(fm.off_sta.value == '')		{ alert('업태를 입력하십시오'); 		return; }
		else if(fm.off_item.value == '')		{ alert('종목을 입력하십시오'); 		return; }
		else if(fm.off_tel.value == '')	{ alert('사무실전화번호를 입력하십시오'); 	return; }
		else if(fm.t_addr.value == '')	{ alert('주소를 입력하십시오'); 	return; }
					
		if(confirm('등록하시겠습니까?')){
			fm.target='i_no';
			fm.submit();
		}
	}

-->
</script>
</head>

<body onload="javascript:document.form1.car_comp_id.focus();">
<form name='form1' action='./cus0401_d_sc_serv_off_i_a.jsp' method='post'>
<input type='hidden' name='h_map' value=''>
<input type='hidden' name='h_page_gubun' value='NEW'><!--새로운 고객을 세팅한다는 의미-->
  <table width="500" border="0" cellspacing="1" cellpadding="0">
    <tr> 
      <td width="380"><font color="navy">고객관리 -> 차량정비등록 </font>-> <font color="red">정비업체등록 
        </font></td>
      <td width="120"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
        &nbsp;<a href='javascript:history.go(-1);'><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
    <tr> 
      <td colspan="2" class="line"><table width="500" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td width="100" class="title">지정업체</td>
            <td width="400"><select name='car_comp_id'>
                <option value="0001">현대자동차</option>
                <option value="0002">기아자동차</option>
                <option value="0003">르노삼성자동차</option>
                <option value="0004">한국GM</option>
                <option value="0005">쌍용자동차</option>
                <option value="0006">볼보</option>
                <option value="0007">도요타</option>
                <option value="0009">기타</option>
                <option value="0011">폭스바겐</option>
                <option value="0012">크라이슬러</option>
                <option value="0013">BMW</option>
              </select></td>
          </tr>
          <tr> 
            <td class="title">상호</td>
            <td><input type='text' name='off_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td height="22" class="title">급수</td>
            <td><select name='off_st'>
                <option value="1">1급</option>
                <option value="2">2급</option>
                <option value="3">3급</option>
                <option value="4">4급</option>
                <option value="5">5급</option>
                <option value="6">기타</option>
              </select></td>
          </tr>
          <tr> 
            <td class="title">대표자</td>
            <td><input type='text' name='own_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">사업자번호</td>
            <td><input type='text' name='t_ent_no1' value='' size='3' class='text' maxlength='3'>
              - 
              <input type='text' name='t_ent_no2' value='' size='2' class='text' maxlength='2'>
              - 
              <input type='text' name='t_ent_no3' value='' size='5' class='text' maxlength='5'></td>
          </tr>
          <tr> 
            <td class="title">업태</td>
            <td><input type='text' name='off_sta' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">종목</td>
            <td><input type='text' name='off_item' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">사무실전화번호</td>
            <td><input type='text' name='off_tel' size="30" maxlength='30' class='text' value=''></td>
          </tr>
          <tr> 
            <td class="title">팩스번호</td>
            <td><input type='text' name='off_fax' size="30" maxlength='30' class='text' value=''></td>
          </tr>
          <tr> 
            <td height="22" class="title">홈페이지</td>
            <td><input type='text' name='homepage' size="30" maxlength='30' class='text' value='http://'></td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('t_zip').value = data.zonecode;
							document.getElementById('t_addr').value = data.address;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class="title">주소</td>
            <td><input type="text" name='t_zip' id="t_zip" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" size="50"></td>
          </tr>
          <tr> 
            <td class="title">계좌개설은행</td>
            <td><input type='text' name='bank' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">계좌번호</td>
            <td><input type='text' name='acc_no' size="30" maxlength='30' class='text' value=''></td>
          </tr>
          <tr> 
            <td class="title">예금주</td>
            <td><input type='text' name='acc_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td class="title">비고</td>
            <td><textarea  class="textarea" name="note" cols="63" rows="2"  style='IME-MODE: active'></textarea></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
