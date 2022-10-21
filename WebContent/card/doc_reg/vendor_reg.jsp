<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
			
	CommonDataBase c_db = CommonDataBase.getInstance();

	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String cust_code = neoe_db.getCustCodeNext(); //-> neoe_db 변환	
	
	Hashtable br = c_db.getBranch("S1");
	
	t_wd = AddUtil.replace(t_wd, "-" , "");		
	
	if ( !Util.CheckNumber(t_wd) ) t_wd="";		 //검색어가 숫자인 경우만 해당 
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//문자열 일정길이 자르기
	function charRound(f, b_len){	
	
		var max_len = f.length;
		var ff = '';
		var len = 0;
		
		for(k=0;k<max_len;k++) {
		
			if(len >= b_len) break; //지정길이보다 길면 종료
			
			t = f.charAt(k);			
			ff += t;
			
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}	
		return ff;			
	}
	
	//등록
	function Save(){
		var fm = document.form1;
		
//		if(fm.cust_code.value == ''){		alert('거래처코드를 입력하십시오.'); 			return; }
//		if(fm.cust_code_yn.value == 'N'){	alert('거래처코드 중복체크를 하십시오.'); 		return; }
		if(fm.cust_name.value == ''){		alert('거래처명을 입력하십시오.'); 				return; }
		if(fm.dname.value == ''){			alert('대표자명을 입력하십시오.'); 				return; }		
		
		if(!chk_vend(fm.s_idno)){ 	alert('사업자번호를 확인하십시오.'); 			return; }		
						
		if(fm.s_idno.value != '' && fm.s_idno_yn.value == 'N'){		alert('사업자등록번호 중복체크를 하십시오.'); 	return; }

		if(fm.t_zip.value == ''){			alert('우편번호를 입력하십시오.'); 				return; }		
		if(fm.t_addr.value == ''){			alert('주소를 입력하십시오.'); 					return; }
		
		if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false && fm.ven_st[2].checked == false && fm.ven_st[3].checked == false){ alert('과세유형을 선택하십시오.'); return;}
		//alert(fm.ven_st[0].value);
		
		if((fm.ven_st[1].checked == true || fm.ven_st[2].checked == true || fm.ven_st[3].checked == true)&&fm.nts_yn.value== ''){		
		
		//if(fm.nts_yn.value== ''){		
		
		alert('국세청 사업자 과세유형 조회를 하십시오.'); return; 
		
		}
		
			
		if(confirm('등록하시겠습니까?')){			
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");					
			
			fm.cust_name.value 	= charRound(fm.cust_name.value ,30);
			fm.dname.value 		= charRound(fm.dname.value	   ,30);
			fm.t_addr.value 	= charRound(fm.t_addr.value	   ,70);			
			
			fm.action='vendor_reg_a.jsp';		
			fm.target='i_no';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}

	//우편번호 검색
	function search_zip(str){
		window.open("/acar/car_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=400, width=400, scrollbars=yes");
	}
	
	//네오엠조회
	function Cust_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		//if(s_kd == 'cust_code')	fm.t_wd.value = fm.cust_code.value;
		//if(s_kd == 's_idno')	
		fm.t_wd.value = fm.s_idno.value.replace(/-/g,"");
		window.open("about:blank",'Cust_search','scrollbars=yes,status=yes,resizable=yes,width=650,height=400,left=400,top=400');		
		fm.action = "cust_sidno_search.jsp";
		fm.target = "Cust_search";
		fm.submit();		
	}
	function Cust_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Cust_search(s_kd);
	}	
	
	// 사업자등록번호 체크
	function check_busino() {
		var fm = document.form1;
		var vencod = fm.s_idno.value;
        var sum = 0;
        var getlist =new Array(10);
        var chkvalue =new Array("1","3","7","1","3","7","1","3","5");
        for(var i=0; i<10; i++) { getlist[i] = vencod.substring(i, i+1); }
        for(var i=0; i<9; i++) 	{ sum += getlist[i]*chkvalue[i]; }
        sum = sum + parseInt((getlist[8]*5)/10);
        sidliy = sum % 10;
        sidchk = 0;
        if(sidliy != 0) { sidchk = 10 - sidliy; }
        else { sidchk = 0; }
        if(sidchk != getlist[9]) { return false; }
        return true;
	}
	
	//국세청과세유형조회
	function search_nts(){
		var fm = document.form1;
		fm.nts_yn.value='Y';
		window.open("https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
	}
//-->
</script>
<script language="JavaScript">
<!--  
function div_OnOff(v,id){
 // 라디오 버튼 value 값 조건 비교
 if(v == "1"){
  document.getElementById(id).style.display = "none"; // 숨김
 }else{
  document.getElementById(id).style.display = ""; // 보여줌
 }
}
    -->
</script>

<script language="Javascript">
<!-- 
	// 사업자등록번호 이상체크
	function chk_vend(a) {
    	var strNumb = a.value.replace(/-/g,"");
		//alert(strNumb);
    	if (strNumb.length != 10) {
        	alert("사업자등록번호가 잘못되었습니다.");
        	return false;
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
        	alert("사업자등록번호가 잘못되었습니다.");
			document.form1.s_idno.value='';
        	return false;
    	}
		
//        alert("유효한 사업자 등록번호 입니다. 중복체크를 해주세요.");
    	return true;
	}
//-->
</script>
<script> 
<!--
function OnCheckBiz_no(oTa) { 
	var oForm = oTa.form ; 
	var sMsg = oTa.value ; 
	var onlynum = "" ; 
		onlynum = RemoveDash2(sMsg); 
	if(event.keyCode != 8 ) { 
	if (GetMsgLen(onlynum) <= 2) oTa.value = onlynum ; 
	if (GetMsgLen(onlynum) == 3) oTa.value = onlynum + "-"; 
	if (GetMsgLen(onlynum) == 5) oTa.value = onlynum.substring(0,3) + "-" + onlynum.substring(3,5) + "-" + onlynum.substring(6,7); 
	} 
} 

function RemoveDash2(sNo) { 
	var reNo = "" 
		for(var i=0; i<sNo.length; i++) { 
		if ( sNo.charAt(i) != "-" ) { 
			reNo += sNo.charAt(i) 
		} 
	} 
	return reNo 
} 

function GetMsgLen(sMsg) { // 0-127 1byte, 128~ 2byte 
	var count = 0 
		for(var i=0; i<sMsg.length; i++) { 
		if ( sMsg.charCodeAt(i) > 127 ) { 
			count += 2 
		} 
	else { 
	count++ 
	} 
	} 
	return count 
} 
//-->
</script> 
</head>
<body topmargin="10" onLoad="javascript:document.form1.cust_name.focus();">
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<!--<input type='hidden' name='cust_code_yn' <%if(cust_code.equals("")){%>value='N'<%}else{%>value='Y'<%}%>>-->
<input type='hidden' name='s_idno_yn' value='N'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='nts_yn' value=''>

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>거래처 등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td></td></tr>
    <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <!--
            <tr>
              <td width='15%' class='title'>거래처코드</td>
              <td>&nbsp;
                  <input name="cust_code" type="text" class="text" value="<%=cust_code%>" size="15" onKeyDown="javasript:Cust_enter('cust_code')"> 
				  
			<a href="javascript:Cust_search('cust_code');"><img src=/acar/images/center/button_in_check_jb.gif border=0 align=absmiddle></a> 
				  (6자리, 100000)
              </td>
            </tr>
			-->
          <tr>
            <td class='title'>거래처명</td>
            <td>&nbsp; 
			<input name="cust_name" type="text" class="text" value="" size="59" style='IME-MODE: active'>(한글15자이내)</td>
          </tr>			
          <tr>
            <td class='title'>대표자명</td>
            <td>&nbsp;
			<input name="dname" type="text" class="text" value="" size="20"></td>
          </tr>
          <tr>
            <td class='title'>사업자번호</td>
            <td>&nbsp;
			<input name="s_idno" type="text" class="text" value="<%=t_wd%>" size="20" maxlength="12" onKeyDown="javasript:Cust_enter('s_idno');" onfocus="OnCheckBiz_no(this)" onKeyup="OnCheckBiz_no(this)" ><!-- OnBlur="chk_vend(this);"-->
			<a href="javascript:Cust_search('s_idno');"><img src=/acar/images/center/button_in_check_jb.gif border=0 align=absmiddle></a> 
			('-' 는 자동으로 입력됩니다.)
			</td>
          </tr>		  		  
          <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

								// 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
								// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
								var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
								var extraRoadAddr = ''; // 도로명 조합형 주소 변수

								// 법정동명이 있을 경우 추가한다. (법정리는 제외)
								// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
								if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
									extraRoadAddr += data.bname;
								}
								// 건물명이 있고, 공동주택일 경우 추가한다.
								if(data.buildingName !== '' && data.apartment === 'Y'){
								   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
								}
								// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
								if(extraRoadAddr !== ''){
									extraRoadAddr = ' (' + extraRoadAddr + ')';
								}
								// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
								if(fullRoadAddr !== ''){
									fullRoadAddr += extraRoadAddr;
								}
								
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = fullRoadAddr;
								
								// 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
								if(data.autoRoadAddress) {
									//예상되는 도로명 주소에 조합형 주소를 추가한다.
									var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
									document.getElementById('t_addr').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

								} else if(data.autoJibunAddress) {
									var expJibunAddr = data.autoJibunAddress;
									document.getElementById('t_addr').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

								} else {
									document.getElementById('t_addr').innerHTML = '';
								}
							}
						}).open();
					}
				</script>				
			<tr>
			  <td class=title>주소</td>
			  <td colspan=7>&nbsp;
				<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="">
				<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
				&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="95" value="">
			  </td>
			</tr>		  		  		  
          <tr>
            <td class='title'>과세유형</td>
            <td>&nbsp;
				<input type="radio" name="ven_st" value="1" onclick="div_OnOff(this.value,'btn');">일반과세
			&nbsp;<input type="radio" name="ven_st" value="2" onclick="div_OnOff(this.value,'btn');">간이과세
			&nbsp;<input type="radio" name="ven_st" value="3" onclick="div_OnOff(this.value,'btn');">면세
			&nbsp;<input type="radio" name="ven_st" value="4" onclick="div_OnOff(this.value,'btn');">비영리법인(국가기관/단체)
			&nbsp;
			<a href="javascript:search_nts();">  <img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0 id="btn" style="display: visibility:hidden;"> 			</a>
	    </td>
          </tr>		  		  
          </table></td>
  </tr>
     
    <tr> 
      <td align="right">
        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")||ck_acar_id.equals("000223")||ck_acar_id.equals("000263")) {%>
      	<a id="submitLink" href="javascript:Save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> 
      	&nbsp;
      	<%}%>
	  <a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> </td>
    </tr>
    <tr> 
      <td>
      	* 국세청 사업자 과세유형 조회는 꼭 하셔야 합니다. 변경한 내용은 이력으로 관리됩니다.
      </td>
    </tr>                
    <tr> 
      <td>
      	* 당사 사업자등록증번호 : <%=AddUtil.ChangeEnt_no(String.valueOf(br.get("BR_ENT_NO")))%>
      </td>
    </tr>      
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
