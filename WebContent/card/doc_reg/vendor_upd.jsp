<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	String ven_name 	= request.getParameter("ven_name")==null?"":request.getParameter("ven_name");
	String ven_nm_cd 	= request.getParameter("ven_nm_cd")==null?"":request.getParameter("ven_nm_cd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	Hashtable ven = neoe_db.getTradeCase(ven_code);//-> neoe_db 변환
	
	Hashtable ven_his = neoe_db.getTradeHisCase(ven_code);  //-> neoe_db 변환없이 그대로 씀	
	
	String ven_st = String.valueOf(ven_his.get("VEN_ST"));
	
	if(ven_st.equals("null") || ven_st.equals("")){
		ven_st = c_db.getCardDocVenSt(ven_code);
	}
	
	Hashtable br = c_db.getBranch("S1");
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
	//수정
	function Save(){
		var fm = document.form1;
//		if(fm.cust_code.value == ''){		alert('거래처코드를 입력하십시오.'); 			return; }
		if(fm.cust_name.value == ''){		alert('거래처명을 입력하십시오.'); 				return; }
		if(fm.dname.value == ''){		alert('대표자명을 입력하십시오.'); 				return; }		
//		if(fm.s_idno.value == ''){		alert('사업자등록번호를 입력하십시오.'); 		return; }
		if(fm.t_zip.value == ''){		alert('우편번호를 입력하십시오.'); 				return; }		
		if(fm.t_addr.value == ''){		alert('주소를 입력하십시오.'); 					return; }
		
		if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false && fm.ven_st[2].checked == false && fm.ven_st[3].checked == false){ alert('과세유형을 선택하십시오.'); return;}
		
		//if(fm.nts_yn.value== ''){		alert('국세청 사업자 과세유형 조회를 하십시오.'); return; }
		
		if((fm.ven_st[1].checked == true || fm.ven_st[2].checked == true || fm.ven_st[3].checked == true)&&fm.nts_yn.value== ''){		
		
			alert('국세청 사업자 과세유형 조회를 하십시오.'); return; 
		
		}
		
		if(confirm('수정하시겠습니까?')){					
		
			fm.cust_name.value 	= charRound(fm.cust_name.value 	,30);
			fm.dname.value 		= charRound(fm.dname.value	   	,30);
			fm.t_addr.value 	= charRound(fm.t_addr.value	   	,70);						
			fm.dc_rmk.value 	= charRound(fm.dc_rmk.value 	,80);			
			
			fm.action='vendor_upd_a.jsp';					
			fm.target='i_no';

			fm.submit();
		}
	}


	//네오엠조회
	function Cust_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cust_code')	fm.t_wd.value = fm.cust_code.value;
		if(s_kd == 's_idno')	fm.t_wd.value = fm.s_idno.value;
		window.open("about:blank",'Cust_search','scrollbars=no,status=no,resizable=yes,width=350,height=200,left=400,top=400');		
		fm.action = "cust_search.jsp";
		fm.target = "Cust_search";
		fm.submit();		
	}
	function Cust_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Cust_search(s_kd);
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
<!--  //과세유형조회 버튼 보이고/숨기기
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
</head>
<body topmargin="10" onLoad="javascript:document.form1.cust_name.focus();">
<form action="./" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='nts_yn' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>거래처 수정</span></span></td>
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
            <tr>
              <td width='15%' class='title'>거래처코드</td>
              <td>&nbsp;
                  <%=ven_code%>
				  <input type='hidden' name='cust_code' value='<%=ven_code%>'>
              </td>
            </tr>
          <tr>
            <td class='title'>거래처명</td>
            <td>&nbsp; 
			<input name="cust_name" type="text" class="text" value="<%=ven.get("CUST_NAME")%>" size="59" style='IME-MODE: active'>(한글15자이내)</td>
          </tr>			
          <tr>
            <td class='title'>대표자명</td>
            <td>&nbsp;
			<input name="dname" type="text" class="text" value="<%=ven.get("DNAME")%>" size="15"></td>
          </tr>
          <tr>
            <td class='title'>사업자번호</td>
            <td>&nbsp;
			<%=ven.get("S_IDNO")%>
			<input type='hidden' name='s_idno' value='<%=ven.get("S_IDNO")%>'>
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
				<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=ven.get("NO_POST1")%>">
				<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
				&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="95" value="<%=ven.get("S_ADDRESS")%>">
			  </td>
			</tr>		  
          
          <tr>
            <td class='title'>과세유형</td>
            <td>&nbsp;
			<input type="radio" name="ven_st" value="1" <%if(ven_st.equals("1"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">일반과세
					&nbsp;<input type="radio" name="ven_st" value="2" <%if(ven_st.equals("2"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">간이과세
					&nbsp;<input type="radio" name="ven_st" value="3" <%if(ven_st.equals("3"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">면세
					&nbsp;<input type="radio" name="ven_st" value="4" <%if(ven_st.equals("4"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">비영리법인(국가기관/단체)
					&nbsp;<input type="radio" name="ven_st" value="0" <%if(ven_st.equals("0"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">없음
					&nbsp;
					<a href="javascript:search_nts();">
			  		  <img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0 id="btn" style="display: visibility:hidden;">
					</a>											
					</td>
          </tr>		  		  		    		  
          <tr>
            <td class='title'>종료여부</td>
            <td>&nbsp;
			  <input type="checkbox" name="md_gubun" value="N" <%if(String.valueOf(ven.get("MD_GUBUN")).equals("N"))%>checked<%%>> 종료
			</td>
          </tr>		  		  
          <tr>
            <td class='title'>비고</td>
            <td>&nbsp;
			<input type="text" name="dc_rmk" class=text value="<%=ven.get("DC_RMK")%>" size="50" maxlength='100'>
			</td>
          </tr>				    		  
          </table></td>
  </tr>
     
    <tr> 
      <td align="right">
        <%//if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
      	<a href="javascript:Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a> 
      	&nbsp;
      	<%//}%>
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
