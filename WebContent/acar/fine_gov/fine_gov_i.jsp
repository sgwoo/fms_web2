<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "06", "03");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");	
	FineGovBn = FineDocDb.getFineGov(gov_id);
	
	if(FineGovBn.getVen_name().equals("") && !FineGovBn.getGov_nm().equals("")) FineGovBn.setVen_name(FineGovBn.getGov_nm());
	
	CodeBean[] codes = c_db.getCodeAll2("0010", "Y");
	int codes_size = codes.length;	
	
	//네오엠 거래처 정보	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code = FineGovBn.getVen_code();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//청구기관 선택
	function fine_gov_search(){
		var fm = document.form1;	
		window.open("fine_gov_search.jsp?t_wd="+fm.gov_nm.value, "SEARCH_FINE", "left=280, top=280, width=550, height=450, scrollbars=yes");
	}

	function search_zip(){
		window.open("../car_rent/zip_s.jsp", "우편번호검색", "left=100, height=200, height=500, width=400, scrollbars=yes");
	}
	
	//등록||수정
	function reg(){
		var fm = document.form1;
		if(fm.gov_st.value == '')	{ alert('기관구분을 선택하십시오.'); return; }
		if(fm.gov_nm.value == '')	{ alert('기관명을 입력하십시오.'); return; }
		if(fm.gov_id.value == '' && fm.chk.value == '')		
									{ alert('중복확인을 하십시오.'); return; }		
		if(!confirm('처리하시겠습니까?')){	return;	}		
		fm.target = "i_no";
//		fm.target ="REG_FINE_GOV";
		fm.action = "fine_gov_i_a.jsp";
		fm.submit();
	}
	
	//네오엠 조회하기
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, scrollbars=yes");		
	}		
			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.gov_nm.focus();">
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='gov_id' value='<%=gov_id%>'>
<input type='hidden' name='chk' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객관리 > <span class=style5>과태료청구기관</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            	<colgroup>
            		<col width='20%'>
            		<col width='*'>
            	</colgroup>
                <tr> 
                    <td class='title'>기관구분</td>
                    <td> 
        			  &nbsp;<select name="gov_st">
        			     <option value=''>선택</option>
                        <%  if(codes_size > 0){
        						for(int i = 0 ; i < codes_size ; i++){
        							CodeBean code = codes[i];%>
                         <option value='<%= code.getNm_cd()%>' <%if(FineGovBn.getGov_st().equals(code.getNm_cd()))%>selected<%%>><%= code.getNm()%></option>
                         <%		}
        					}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>기관명</td>
                    <td> 
                      &nbsp;<input type="text" name="gov_nm" value="<%=FineGovBn.getGov_nm()%>" size="50" class="text" style='IME-MODE: active'>
        			  <%if(gov_id.equals("")){%>
        			  <a href="javascript:fine_gov_search();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_jb.gif" n align="absmiddle" border="0"></a>
        			  <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>문서24 기관명</td>
                    <td> 
                      &nbsp;<input type="text" name="gov_nm2" value="<%=FineGovBn.getGov_nm2()%>" size="60" class="text" >
                    </td>
                </tr>
                <tr> 
                    <td class='title'>기관부서코드</td>
                    <td> 
                      &nbsp;<input type="text" name="gov_dept_code" value="<%=FineGovBn.getGov_dept_code()%>" size="30" class="text" > (고지서)
                    </td>
                </tr>
                <tr> 
                    <td class='title'>참조</td>
                    <td> 
                      &nbsp;<input type="text" name="mng_dept" value="<%=FineGovBn.getMng_dept()%>" size="30" class="text">
                    </td>
                </tr>
                <tr>
                    <td class='title'>담당자명</td>
                    <td>&nbsp;<input type="text" name="mng_nm" value="<%=FineGovBn.getMng_nm()%>" size="30" class="text"></td>
                </tr>
                <tr>
                    <td class='title'>담당자직급</td>
                    <td>&nbsp;<input type="text" name="mng_pos" value="<%=FineGovBn.getMng_pos()%>" size="30" class="text"></td>
                </tr>
                <tr> 
                    <td class='title'>연락처</td>
                    <td> 
                        &nbsp;<input type="text" name="tel" value="<%=FineGovBn.getTel()%>" size="30" class="text">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>팩스</td>
                    <td> 
                      &nbsp;<input type="text" name="fax" value="<%=FineGovBn.getFax()%>" size="30" class="text">
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
				  <td>&nbsp;
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=FineGovBn.getZip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="50" value="<%=FineGovBn.getAddr()%>">
				  </td>
				</tr>
				<tr> 
                    <td class=title>네오엠거래처</td>
                    <td>
					  &nbsp;<input type='text' name='ven_name' size='30' value='<%=ven.get("VEN_NAME")==null?FineGovBn.getVen_name():ven.get("VEN_NAME")%>' class='text' style='IME-MODE: active'>
					  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  		  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <input type='text' name='ven_code' size='6' value='<%=ven_code%>' class='text'>
					</td>					
                </tr>
				<tr> 
                    <td class='title'>사용유무</td>
                    <td> 
       			  &nbsp;<select name="use_yn">
						<option value='Y' <%if(FineGovBn.getUse_yn().equals("Y")){%>selected<%}%>>사용</option>
						<option value='N' <%if(FineGovBn.getUse_yn().equals("N")){%>selected<%}%>>사용금지</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
          <td align='right'>
    	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    	  <a href="javascript:reg();"><img src="/acar/images/center/<%if(gov_id.equals("")) {%>button_reg<%}else{%>button_modify<%}%>.gif"  align="absmiddle" border="0"></a>
    	  <%}%>
    	  &nbsp;<a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif" n align="absmiddle" border="0"></a>
    	  </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>