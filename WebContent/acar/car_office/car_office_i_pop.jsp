<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CarCompBean cc_r [] = cod.getCarCompAll();
	CodeBean cd_r [] = c_db.getCodeAllCms("0003");	//은행명을 가져온다.

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	function save(){
		var fm = document.form1;	

		if(fm.car_comp_id.value == '')			{ alert('소속사를 선택해주세요');			return;	 }
		else if(fm.car_off_st.value == '')		{ alert('소속사구분을 선택해주세요');		return; }			
		else if((fm.car_off_nm.value == ''))	{ alert('지점(대리점)명을 입력해주세요'); 	return; }
		else if(fm.car_off_tel.value == '')	{ alert('전화번호를 입력하십시오');			return; }
		else if(fm.car_off_fax.value == '')	{ alert('팩스번호를 입력하십시오'); 		return; }
		else if(fm.t_addr.value == '')			{ alert('주소를 입력하십시오'); 			return; }
					
		if(confirm('등록하시겠습니까?')){
			fm.target='i_no';
			fm.submit();
		}
	}

	//네오엠 조회하기
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=400, scrollbars=yes");		
	}		
-->
</script>
</head>

<body onload="javascript:document.form1.car_comp_id.focus();">
<form name='form1' action='./car_office_i_pop_a.jsp' method='post'>
<input type='hidden' name='page_gubun' value='NEW'><!--새로운 고객을 세팅한다는 의미-->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > <span class=style5>영업소등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border="0"></a> 
        &nbsp;<a href='javascript:history.go(-1);'><img src=/acar/images/center/button_list.gif align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width=20%>제작사</td>
                    <td>&nbsp;<select name="car_comp_id">
                        <option value="">==선택==</option>
                        <%for(int i=0; i<cc_r.length; i++){
        							cc_bean = cc_r[i];
        							if(cc_bean.getNm().equals("에이전트")) continue;
        							 %>
                        <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                        <%}%>
                      </select></td>
                </tr>
                <tr> 
                    <td height="22" class="title">구분</td>
                    <td>&nbsp;<input type="radio" name="car_off_st" value="1">
                      지점&nbsp; <input type="radio" name="car_off_st" value="2">
                      대리점&nbsp; </td>
                </tr>
                <tr> 
                    <td height="22" class="title">지점(대리점)명</td>
                    <td>&nbsp;<input type='text' name='car_off_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr>
                    <td class=title>사업자등록번호</td>
               	    <td>&nbsp;
               	      <input type='text' name='enp_no' value='' size='15' class='text' maxlength='15'> ('-'빼고)							
               	    </td>
                </tr>                 
                <tr> 
                    <td class="title">전화번호</td>
                    <td>&nbsp;<input type='text' name='car_off_tel' value='' size='30' class='text' maxlength='30'></td>
                </tr>
                <tr> 
                    <td class="title">팩스번호</td>
                    <td>&nbsp;<input type='text' name='car_off_fax' size="30" maxlength='30' class='text' value=''></td>
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
					&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" value="" size="100">
                </tr>
                <tr> 
                    <td class="title">계좌개설은행</td>
                    <td>&nbsp;
                    	<input type='hidden' name="bank" 			value="">
                    	<select name="bank_cd">
                        <option value="">선택</option>
                        <%
        						for(int i=0; i<cd_r.length; i++){
        							cd_bean = cd_r[i];
        							//신규인경우 미사용은행 제외
											if(cd_bean.getUse_yn().equals("N"))	 continue;
        					%>
                        <option value="<%= cd_bean.getCode() %>"><%= cd_bean.getNm() %></option>
                        <%}%>
                      </select></td>
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
               		<td class=title>네오엠거래처</td>
               		<td colspan=3>&nbsp;<input type='text' name='ven_name' size='40' value='' class='text' style='IME-MODE: active'>
					  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  		  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <input type='text' name='ven_code' size='5' value='' class='text'>		
			  		  <br>
			  		  &nbsp;<input type="checkbox" name="ven_autoreg_yn" value="Y"> 영업소 등록시 네오엠거래처를 자동 등록한다. (영업소명, 사업자등록번호)
					</td>
                </tr>                 
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
