<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_sui.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	sBean = olsD.getSui(car_mng_id);
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(ioru)
	{
		var fm = document.form1;	
		if(!this.CheckField()) return;
		if(ioru=="i"){
			if(!confirm('등록 하시겠습니까?')){ return; }
		}else if(ioru=="u"){
			if(!confirm('수정 하시겠습니까?')){ return; }
		}
		fm.gubun.value = ioru;
		fm.action="/acar/off_ls_cmplt/off_ls_cmplt_reg_ui.jsp";
		fm.target = "i_no";	
		fm.submit();
	}

	function CheckField()
	{
		var fm = document.form1;
		if(fm.sui_nm.value == ''){
			alert('성명을 입력하십시오');
			return false;
		}else if( fm.ssn1.value=='' || (!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || 
			((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) ||
			((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{
			alert('주민등록번호를 확인하십시오');
			return false;
		}
		return true;
	}

	function search_zip(str)
	{
		window.open("/acar/off_ls_sui/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
	
	function set_o_addr()
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.h_zip.value = fm.d_zip.value;
			fm.h_addr.value = fm.d_addr.value;
		}
		else
		{
			fm.h_zip.value = '';
			fm.h_addr.value = '';
		}
	}
	
	function set_up_addr(){
		var fm = document.form1;
		if(fm.c_up.checked == true){
			fm.car_nm.value = fm.sui_nm.value;
			fm.car_relation.value = '본인';
			fm.car_ssn1.value = fm.ssn1.value;
			fm.car_ssn2.value = fm.ssn2.value;
			fm.car_h_tel.value = fm.h_tel.value;
			fm.car_m_tel.value = fm.m_tel.value;
			fm.car_zip.value = fm.d_zip.value;
			fm.car_addr.value = fm.d_addr.value;
		}else{
			fm.car_nm.value = '';
			fm.car_relation.value = '';
			fm.car_ssn1.value = '';
			fm.car_ssn2.value = '';
			fm.car_h_tel.value = '';
			fm.car_m_tel.value = '';
			fm.car_zip.value = '';
			fm.car_addr.value = '';
		}
	}
	
	function view_file(idx)	
	{
		if(idx == '1'){ 	
			var map_path = document.form1.s_suifile.value;
		}else if(idx == '2'){	 			
			var map_path = document.form1.s_lpgfile.value;
		}
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/sui/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}
	function drop_file(idx){
		if(idx=='s'){
			document.form1.s_suifile_del.value = '1';
		}else if(idx=='l'){
			document.form1.s_lpgfile_del.value = '1';
		}
	}
-->
</script>
</head>
<body>
<form name="form1" action="" enctype='multipart/form-data' method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type='hidden' name='s_suifile' value='<%=sBean.getSuifile()%>'>
<input type='hidden' name='s_lpgfile' value='<%=sBean.getLpgfile()%>'>
<input type='hidden' name='s_suifile_del' value=''>
<input type='hidden' name='s_lpgfile_del' value=''>
<input type="hidden" name="gubun" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
      <td width="526"> <<계약자 정보>> <font color="#999999">♧최종수정자 : 
        <%if(login.getAcarName(sBean.getModify_id()).equals("error")){%>
        &nbsp; 
        <%}else{%>
        <%=login.getAcarName(sBean.getModify_id())%> 
        <%}%>
        </font></td>
      <td align="right" width="488"> 
        <%//if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        <%if(olsD.getCar_mng_id(car_mng_id).equals("")){%>
        <a href='javascript:save("i");' onMouseOver="window.status=''; return true"> 
        <img src="/images/reg.gif" width="50" height="18" align="absmiddle" border="0" alt="등록"></a> 
        <%}else{%>
        <a href='javascript:save("u");' onMouseOver="window.status=''; return true"> 
        <img src="/images/update.gif" width="50" height="18" align="absmiddle" border="0" alt="수정"></a> 
        <%}%>
        <%//}%>
      </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td class='title' width='88'> 성명(명칭)</td>
            <td width='172'>&nbsp; <input type='text' name='sui_nm' value="<%=sBean.getSui_nm()%>" size='20' maxlength='40' class='text' style='IME-MODE: active'> 
            </td>
            <td class='title' width='95'>관계</td>
            <td width='177' align='left'>&nbsp; <input type='text' name='relation' value="<%=sBean.getRelation()%>" size='20' maxlength='40' class='text' style='IME-MODE: active'> 
            </td>
            <td class='title' width='85'>계약일자</td>
            <td width="176">&nbsp; <input type='text' size='13' name='cont_dt' value="<%=AddUtil.ChangeDate2(sBean.getCont_dt())%>" maxlength='40' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="88">주민등록번호<br/> </td>
            <td width="172">&nbsp; <input type='text' size='6' name='ssn1' maxlength='6' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(0,6));%>" >
              - 
              <input type='text' name='ssn2' maxlength='7' size='7' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(6));%>" > 
            </td>
            <td class='title' width='95'>전화번호</td>
            <td width="177">&nbsp; <input type='text' size='15' name='h_tel' maxlength='15' class='text' value="<%=sBean.getH_tel()%>" > 
            </td>
            <td class='title' width='85'>휴대폰번호</td>
            <td width="176">&nbsp; <input type='text' size='15' name='m_tel' maxlength='15' class='text' value="<%=sBean.getM_tel()%>" > 
            </td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('d_zip').value = data.zonecode;
							document.getElementById('d_addr').value = data.address +" (" + data.buildingName +")" ;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class='title' width="88">등본상주소</td>
            <td colspan='5'> &nbsp; 
			<input type="text" name='d_zip' id="d_zip" value="<%= sBean.getD_zip() %>" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='d_addr' id="d_addr" value="<%=sBean.getD_addr()%>" size="50">
					
            </td>
          </tr>
		  <script>
				function openDaumPostcode2() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('h_zip').value = data.zonecode;
							document.getElementById('h_addr').value = data.address +" (" + data.buildingName +")" ;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class='title' width="88">실제주소</td>
            <td colspan='5'> &nbsp; 
			<input type="text" name='h_zip' id="h_zip" value="<%= sBean.getH_zip() %>" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='h_addr' id="h_addr" value="<%=sBean.getH_addr()%>" size="50">
              <input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
              상동</td>
          </tr>
          <tr> 
            <td class='title'>매매대금</td>
            <td> &nbsp; <input type='text' size='10' name='mm_pr' value="<%=AddUtil.parseDecimal(sBean.getMm_pr())%>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'> 
            </td>
            <td class='title' width="95">입금일</td>
            <td width="177"> &nbsp; </td>
            <td class='title' width="85">&nbsp;</td>
            <td width="176"> &nbsp; <input type='text' size='12' name='cont_pr_dt' value="<%=AddUtil.ChangeDate2(sBean.getCont_pr_dt())%>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'> 
            </td>
          </tr>
          <tr>
            <td class='title'>출품수수료</td>
            <td>&nbsp;</td>
            <td class='title' width="95"> 낙찰수수료</td>
            <td width="177"> &nbsp; <input type='text' size='10' name='jan_pr' value="<%=AddUtil.parseDecimal(sBean.getJan_pr())%>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'> 
            </td>
            <td class='title' width="85"> 탁송수수료</td>
            <td width="176"> &nbsp; </td>
          </tr>
          <tr> 
            <td class='title' width="88">양도증명서스캔</td>
            <td colspan="5" class='left'>&nbsp; <input type="file" name="filename" value='S' size="25"> 
              &nbsp; <%if(!sBean.getSuifile().equals("")){%> <input type="button" name="b_map1" value="보기" onClick="javascript:view_file(1);"> 
              &nbsp;&nbsp; <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))%> <input type="button" name="b_map3" value="삭제" onClick="javascript:drop_file('s');"> 
              <%}%> </td>
          </tr>
          <tr> 
            <td class='title' width="88">LPG서류스캔</td>
            <td colspan="5" class='left'>&nbsp; <input type="file" name="filename3" value='S' size="25"> 
              &nbsp; <%if(!sBean.getLpgfile().equals("")){%> <input type="button" name="b_map2" value="보기" onClick="javascript:view_file('2');"> 
              &nbsp;&nbsp; <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))%> <input type="button" name="b_map4" value="삭제" onClick="javascript:drop_file('l');"> 
              <%}%> </td>
          </tr>
          <tr> 
            <td class='title' width="88">보증KM</td>
            <td class='left' width="172">&nbsp; <input class="num" type="text" name="ass_st_km" size="10" value="<%=AddUtil.parseDecimal(sBean.getAss_st_km())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
              ~ 
              <input class="num" type="text" name="ass_ed_km" size="10" value="<%=AddUtil.parseDecimal(sBean.getAss_ed_km())%>" onBlur='javascript:this.value=parseDecimal(this.value)'> 
            </td>
            <td class='title' width="95">보증기간</td>
            <td class='left' width="177">&nbsp; <input class="text" type="text" name="ass_st_dt" size="12" value="<%=AddUtil.ChangeDate2(sBean.getAss_st_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
              ~ 
              <input class="text" type="text" name="ass_ed_dt" size="12" value="<%=AddUtil.ChangeDate2(sBean.getAss_ed_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'> 
            </td>
            <td class='title' width="85" >보증서작성자</td>
            <td class='left' width="176">&nbsp; <input class="text" type='text' name='ass_wrt'    size='20' maxlength='20' value="<%=sBean.getAss_wrt()%>"" > 
            </td>
          </tr>
          <tr> 
            <td class='title' width="88"> 기타사항 </td>
            <td colspan='5'>&nbsp; <textarea name='etc' rows='2' cols='100' maxlength='500'><%=sBean.getEtc()%></textarea> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"></td>
    </tr>
    <tr> 
      <td align='left' colspan="2"> <<이전명의자 정보>> 
        <input type='checkbox' name='c_up' onClick='javascript:set_up_addr()'>
        상동</td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' width='120'> 성명</td>
            <td width="180">&nbsp; 
              <input type='text' name='car_nm' value="<%=sBean.getCar_nm()%>" size='20' maxlength='40' class='text' style='IME-MODE: active'>
            </td>
            <td class='title' width='100'>관계 </td>
            <td width='150'>&nbsp; 
              <input type='text' name='car_relation' value="<%=sBean.getCar_relation()%>" size='20' maxlength='40' class='text' style='IME-MODE: active'>
            </td>
            <td class='title' width='100'>&nbsp;</td>
            <td width='150'>&nbsp; </td>
          </tr>
          <tr> 
            <td class='title' width='120'>주민등록번호</td>
            <td width="180">&nbsp; 
              <input type='text' size='6' name='car_ssn1' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(0,6));%>" maxlength='6' class='text'>
              - 
              <input type='text' name='car_ssn2' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(6));%>" maxlength='7' size='7' class='text'>
              &nbsp; </td>
            <td class='title' width='100'>전화번호</td>
            <td width='150'> &nbsp; 
              <input type='text' size='15' value="<%=sBean.getCar_h_tel()%>" name='car_h_tel' maxlength='15' class='text'>
            </td>
            <td class='title' width='100'>핸드폰번호</td>
            <td width='150'> &nbsp; 
              <input type='text' size='15' value="<%=sBean.getCar_m_tel()%>" name='car_m_tel' maxlength='15' class='text'>
            </td>
          </tr>
		  <script>
				function openDaumPostcode3() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('car_zip').value = data.zonecode;
							document.getElementById('car_addr').value = data.address +" (" + data.buildingName +")" ;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class='title' width="120">주소</td>
            <td colspan="5">&nbsp; 
			<input type="text" name='car_zip' id="car_zip" value="<%= sBean.getCar_zip() %>" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='car_addr' id="car_addr" value="<%=sBean.getCar_addr()%>" size="50">
			
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"></td>
    </tr>
    <%if(!olsD.getCar_mng_id(car_mng_id).equals("")){%>
    <tr> 
      <td colspan="2"><iframe src="./off_ls_cmplt_reg_sugum.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>" name="sugum" width="800" height="300" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <%}%>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>