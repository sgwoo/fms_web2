<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.pay_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
//금융사리스트
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
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
	//사업자등록번호 체크
function CheckBizNo() {
	
	var fm = document.form1;

	var strNumb1 = fm.t_ent_no1.value;
    var strNumb2 = fm.t_ent_no2.value;
    var strNumb3 = fm.t_ent_no3.value;

    var strNumb = strNumb1+strNumb2+strNumb3;
    if (strNumb.length != 10) {
        alert("사업자등록번호가 잘못되었습니다.");
		fm.t_ent_no1.value = '';
		fm.t_ent_no2.value = '';
		fm.t_ent_no3.value = '';
        return ;
    }
    
        sumMod  =   0;
        sumMod  +=  parseInt(strNumb.substring(0,1));
        sumMod  +=  parseInt(strNumb.substring(1,2)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(2,3)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(3,4)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(4,5)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(5,6)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(6,7)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(7,8)) * 3 % 10;
        sumMod  +=  Math.floor(parseInt(strNumb.substring(8,9)) * 5 / 10);
        sumMod  +=  parseInt(strNumb.substring(8,9)) * 5 % 10;
        sumMod  +=  parseInt(strNumb.substring(9,10));
    
    if (sumMod % 10  !=  0) {
        alert("잘못된 사업자 등록번호 입니다.");
		fm.t_ent_no1.value = '';
		fm.t_ent_no2.value = '';
		fm.t_ent_no3.value = '';
        return ;
    }
        alert("올바른 사업자 등록번호 입니다.");
    	return ;
}
-->
</script>
</head>

<body onload="javascript:document.form1.car_comp_id.focus();">
<form name='form1' action='cus_reg_serv_off_i_a.jsp' method='post'>
<input type='hidden' name='h_map' value=''>
<input type='hidden' name='h_page_gubun' value='NEW'><!--새로운 고객을 세팅한다는 의미-->
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 차량정비등록 > <span class=style5>정비업체등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align=right colspan=2><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align="absmiddle" border="0"></a> 
        &nbsp;<a href='javascript:history.go(-1);'><img src=/acar/images/center/button_list.gif align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=20% class="title">지정업체</td>
                    <td>&nbsp;<select name='car_comp_id'>
                        <option value="0001">현대자동차</option>
                        <option value="0002">기아자동차</option>
                        <option value="0003">르노코리아자동차</option>
                        <option value="0004">한국지엠</option>
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
                    <td>&nbsp;<input type='text' name='off_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td height="22" class="title">급수</td>
                    <td>&nbsp;<select name='off_st'>
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
                    <td>&nbsp;<input type='text' name='own_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class="title">사업자번호</td>
                    <td>&nbsp;<input type='text' name='t_ent_no1' value='' size='3' class='text' maxlength='3'>
                      - 
                      <input type='text' name='t_ent_no2' value='' size='2' class='text' maxlength='2'>
                      - 
                      <input type='text' name='t_ent_no3' value='' size='5' class='text' maxlength='5' OnBlur="CheckBizNo();"></td>
                </tr>
                <tr> 
                    <td class="title">업태</td>
                    <td>&nbsp;<input type='text' name='off_sta' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class="title">종목</td>
                    <td>&nbsp;<input type='text' name='off_item' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class="title">사무실전화번호</td>
                    <td>&nbsp;<input type='text' name='off_tel' size="30" maxlength='30' class='text' value=''></td>
                </tr>
                <tr> 
                    <td class="title">팩스번호</td>
                    <td>&nbsp;<input type='text' name='off_fax' size="30" maxlength='30' class='text' value=''></td>
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
                    <td>&nbsp;
					<input type="text" name='t_zip' id="t_zip" value="" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" value="" size="50">
                </tr>
                <tr> 
                    <td class="title">계좌개설은행</td>
					<td>&nbsp;<select name='bank'>
						<option value=''>선택</option>
						<%	for(int i = 0 ; i < bank_size ; i++){
										Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
										%>
						<option value='<%= bank_ht.get("NM")%>' ><%= bank_ht.get("NM")%></option>
						<%	}%>
					  </select></td>
 <!--                   <td>&nbsp;<input type='text' name='bank' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td> -->
                </tr>
                <tr> 
                    <td class="title">계좌번호</td>
                    <td>&nbsp;<input type='text' name='acc_no' size="30" maxlength='30' class='text' value=''></td>
                </tr>
                <tr> 
                    <td class="title">예금주</td>
                    <td>&nbsp;<input type='text' name='acc_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class="title">비고</td>
                    <td>&nbsp;<textarea  class="textarea" name="note" cols="63" rows="2"  style='IME-MODE: active'></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
