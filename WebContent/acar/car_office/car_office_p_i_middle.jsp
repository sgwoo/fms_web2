<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<table width="800" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="line"><table width="800" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td colspan="2" class="title">* 성명</td>
          <td colspan="3">&nbsp; <input type="text" name="emp_nm" value="" size="12" class=text onKeyDown="javascript:enter('1');" style='IME-MODE: active'> 
            <a href="javascript:name_check();">중복체크</a></td>
        </tr>
        <tr> 
          <td colspan="2" class="title">* 소속사</td>
          <td colspan="3">&nbsp; <select name="car_comp_id">
              <option value="">==선택==</option>
              <%for(int i=0; i<cc_r.length; i++){
							cc_bean = cc_r[i]; 
							if(cc_bean.getNm().equals("에이전트")) continue;%>
              <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
              <%}%>
            </select></td>
        </tr>
        <tr> 
          <td colspan="2" class="title">* 근무처</td>
          <td colspan="3">&nbsp; <input type="text" name="car_off_nm" value="" size="20" class=text onKeyDown="javascript:enter('2');"> 
            <a href="javascript:CarOffSearch()" onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" align="absbottom" border="0"></a> 
          </td>
        </tr>
        <tr> 
          <td colspan="2" class="title">고객구분</td>
          <td colspan="3">&nbsp; <input type="radio" name="cust_st" value="2" checked>
            사업소득&nbsp; <input type="radio" name="cust_st" value="3">
            기타사업소득&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="2" class="title">주민등록번호</td>
          <td colspan="3">&nbsp; <input type="text" name="emp_ssn1" value="" size="6" maxlength=6 class=text>
            - 
            <input type="text" name="emp_ssn2" value="" size="7" maxlength=7 class=text> 
            <input type="hidden" name="emp_ssn" value="" size="18" class=text></td>
        </tr>
        <tr> 
          <td colspan="2" class="title"> 직위</td>
          <td colspan="3">&nbsp; <input type="text" name="emp_pos" value="" size="21" class=text></td>
        </tr>
        <tr> 
          <td colspan="2" class="title">* 휴대폰</td>
          <td colspan="3">&nbsp; <input type="text" name="emp_m_tel" value="" size="23" class=text></td>
        </tr>
        <tr> 
          <td colspan="2" class="title">* 이메일</td>
          <td colspan="3">&nbsp; <input type="text" name="emp_email" value="" size="30" class=text></td>
        </tr>
		<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<script>
			function openDaumPostcode() {
				new daum.Postcode({
					oncomplete: function(data) {
						document.getElementById('emp_post').value = data.zonecode;
						document.getElementById('emp_addr').value = data.address;
						
					}
				}).open();
			}
		</script>	
        <tr> 
          <td colspan="2" class="title">* 주소</td>
          <td colspan="3">&nbsp; 
		  <input type="text" name="emp_post"  id="emp_post" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
			&nbsp;<input type="text" name="emp_addr" id="emp_addr" size="90" >
        </tr>
        <tr> 
          <td width="59" rowspan="3" class="title">계좌</td>
          <td width="106" class="title">개설은행</td>
          <td colspan="3">&nbsp; <select name="emp_bank" style="width:135">
              <option value="">==선택==</option>
              <%
					for(int i=0; i<cd_r.length; i++){
						cd_bean = cd_r[i];
				%>
              <option value="<%= cd_bean.getNm() %>"><%= cd_bean.getNm() %></option>
              <%
					  }%>
            </select></td>
        </tr>
        <tr> 
          <td class="title">번호</td>
          <td colspan="3">&nbsp; <input type="text" name="emp_acc_no" value="" size="23" class=text></td>
        </tr>
        <tr> 
          <td class="title">예금주</td>
          <td colspan="3">&nbsp; <input type="text" name="emp_acc_nm" value="" size="23" class=text></td>
        </tr>
        <tr> 
          <td colspan="2" class="title">최초등록일자</td>
          <td width="236">&nbsp; <input name="reg_dt" type="text" class="text" value="<%= AddUtil.getDate() %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          <td width="198" class="title">최초등록 담당자</td>
          <td width="195"><select name='reg_id'>
              <option value="">==선택==</option>
              <option value="">=영업팀=</option>
              <%for (int i = 0 ; i < buss.size() ; i++){%>
              <% Hashtable user = (Hashtable)buss.elementAt(i);%>
              <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
              <%}%>
              <option value="">=고객지원팀=</option>
              <%for (int i = 0 ; i < mngs.size() ; i++){%>
              <% Hashtable user = (Hashtable)mngs.elementAt(i);%>
              <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
              <%}%>
              <option value="">=총무팀=</option>
              <%for (int i = 0 ; i < gens.size() ; i++){%>
              <% Hashtable user = (Hashtable)gens.elementAt(i);%>
              <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
              <%}%>
            </select></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
