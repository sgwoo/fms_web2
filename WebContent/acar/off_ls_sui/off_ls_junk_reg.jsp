<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_sui.*, acar.client.*, acar.car_register.*, acar.car_scrap.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="olsBean" class="acar.offls_sui.Offls_suiBean" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>


<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String enp_no1 = "";
	String enp_no2 = "";
	String enp_no3 = "";
	
	sBean = olsD.getSui(car_mng_id);
	if(!sBean.getEnp_no().equals("")){
		enp_no1 = sBean.getEnp_no().substring(0,3);
		enp_no2 = sBean.getEnp_no().substring(3,5);
		enp_no3 = sBean.getEnp_no().substring(5,10);
	}
	
	
	LoginBean login = LoginBean.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();


	//공급받는자
	ClientBean client = al_db.getClient(sBean.getClient_id());
	
	//차량정보
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(ioru)
	{
		var fm = document.form1;	
		if(!this.CheckField()) return;
		
		if(fm.email_1.value != '' && fm.email_2.value != ''){
			fm.email.value = fm.email_1.value+'@'+fm.email_2.value;
		}
		
		if ( fm.bill_doc_yn.value == '1' ) {
			if(fm.mm_pr.value == ''){
					alert('입금액을 입력하십시오');
					return ;
			}	
		}
		
		if(fm.jan_pr_dt.value == ''){
				alert('입금일을 입력하십시오');
				return ;
		}		
			
		if(ioru=="i"){
			if(!confirm('등록 하시겠습니까?')){ return; }
		}else if(ioru=="u"){
			if(!confirm('수정 하시겠습니까?')){ return; }
		}else if(ioru=="p"){
			if(!this.pCheck()) return;
			if(!confirm('매각처리 하시겠습니까?')){ return; }
		}
		fm.gubun.value = ioru;
		fm.action="/acar/off_ls_sui/off_ls_sui_reg_ui.jsp";
		fm.target = "i_no";	
		fm.submit();
	}

	function CheckField()
	{
		var fm = document.form1;
		
		if ( fm.bill_doc_yn.value == '1' ) {
			if(fm.firm_nm.value == ''){
				alert('공급받는자를 입력하십시오');
				return false;
			}else if( fm.ssn1.value=='' || (!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || 
				((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) ||
				((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{
				alert('주민등록번호를 확인하십시오');
				return false;
			}
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
		window.open("http://localhost/data/sui/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}
	function drop_file(idx){
		if(idx=='s'){
			document.form1.s_suifile_del.value = '1';
		}else if(idx=='l'){
			document.form1.s_lpgfile_del.value = '1';
		}
	}
	function getJan_pr(){
		document.form1.jan_pr.value = 
		parseDecimal(parseDigit(document.form1.mm_pr.value) - parseDigit(document.form1.cont_pr.value));
		return parseDecimal(document.form1.cont_pr.value);
	}
	
	function pCheck(){
		var fm = document.form1;
		if(fm.migr_dt.value == ''){
			alert('명의이전일을 입력하십시오');
			return false;
		}else if(fm.migr_no.value == ''){
			alert('명의이전후번호를 입력하십시오');
			return false;
		}
		return true;
	}
	
	//등록/수정: 고객 조회
	function select_client()
	{
		var fm = document.form1;
		var h_wd = "";
		if(fm.firm_nm.value == '') 	h_wd = fm.sui_nm.value;		
		else 						h_wd = fm.firm_nm.value;				
		window.open("/acar/off_ls_cmplt/client_s_p.jsp?go_url=/acar/off_ls_cmplt/off_ls_cmplt_reg.jsp&h_wd="+h_wd, "CLIENT", "left=100, top=100, width=650, height=500, status=yes");
	}		
	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		window.open("/acar/mng_client2/client_enp.jsp?client_id="+fm.client_id.value, "VIEW_CLIENT", "left=100, top=100, width=630, height=500");
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
<input type="hidden" name="client_id" value="<%=sBean.getClient_id()%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약자 정보</span></font>&nbsp;&nbsp;&nbsp;&nbsp;<font color="#999999">♧최종수정자 : 
        <%if(login.getAcarName(sBean.getModify_id()).equals("error")){%>
        &nbsp; 
        <%}else{%>
        <%=login.getAcarName(sBean.getModify_id())%> 
        <%}%>
        </font></td>
        <td align="right"> 
        <%//if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
		<%if(olsD.getCar_mng_id(car_mng_id).equals("")){%>
			<a href='javascript:save("i");' onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        	<%}else{%>
        		<a href='javascript:save("u");' onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>         		   		
			&nbsp;
		<a href='javascript:save("p");' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_mgak.gif border=0 align=absmiddle></a>
        	<%}%> 
        <%//}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
               <tr> 
               <td class=title>세금계산서발행요청구분</td>
                    <td >&nbsp;<select name="bill_doc_yn">
                        <option value="0" <%if(sBean.getBill_doc_yn().equals("0"))%>selected<%%>>미발행</option>
                        <option value="1" <%if(sBean.getBill_doc_yn().equals("1"))%>selected<%%>>발행</option>              
                      </select>                         
                </td>
                <td class='title' >폐차일</td>
                <td colspan='3'>&nbsp; <input type='text' size='13' name='cont_dt' value="<%=AddUtil.ChangeDate2(sBean.getCont_dt())%>" maxlength='40' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'> 
              </tr>
              <tr> 
                <td class='title'>공급받는자</td>
                <td colspan="5">&nbsp; <input type='text' name='firm_nm' value="<%=client.getFirm_nm()%>" size='30' maxlength='40' class='text'> 
                  <a href="javascript:select_client()"><img src=../images/center/button_in_search.gif border=0 align=absmiddle></a> 
                  <%if(!sBean.getClient_id().equals("")){%>
                  &nbsp;<a href="javascript:view_client()"><img src=../images/center/button_in_see.gif border=0 align=absmiddle></a>
                  <%}%>
                </td>
              </tr>
          
              <tr> 
                <td class='title'>주민등록번호<br/> </td>
                <td>&nbsp; <input type='text' size='6' name='ssn1' maxlength='6' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(0,6));%>" >
                  - 
                  <input type='text' name='ssn2' maxlength='7' size='7' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(6));%>" > 
                </td>
                <td class='title'>사업자번호</td>
                <td colspan="3">&nbsp; <input type='text' name='enp_no1' value='<%= enp_no1 %>' size='3' class='text' maxlength='3'>
                  - 
                  <input type='text' name='enp_no2' value='<%= enp_no2 %>' size='2' class='text' maxlength='2'>
                  - 
                  <input type='text' name='enp_no3' value='<%= enp_no3 %>' size='5' class='text' maxlength='5'> 
                </td>
              </tr>
              <tr> 
                <td class='title'>전화번호</td>
                <td>&nbsp; <input type='text' size='15' name='h_tel' maxlength='15' class='text' value="<%=sBean.getH_tel()%>" ></td>
                <td class='title'>휴대폰번호</td>
                <td colspan="3">&nbsp; <input type='text' size='15' name='m_tel' maxlength='15' class='text' value="<%=sBean.getM_tel()%>" ></td>
              </tr>
				<%	String email_1 = "";
					String email_2 = "";
					if(!sBean.getEmail().equals("")){
						int mail_len = sBean.getEmail().indexOf("@");
						if(mail_len > 0){
							email_1 = sBean.getEmail().substring(0,mail_len);
							email_2 = sBean.getEmail().substring(mail_len+1);
						}
					}
				%>		
                <tr> 
                    <td class='title'>E-mail</td>
                    <td colspan='5'> &nbsp;
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">직접 입력</option>
						</select>
					  <input type='hidden' name='email' value='<%=sBean.getEmail()%>'>
					  <!--<input type='text' name='email' value="<%=sBean.getEmail()%>" size='20' maxlength='40' class='text'>-->
                    </td>
                </tr>							  
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('d_zip').value = data.zonecode;
							document.getElementById('d_addr').value = data.roadAddress;
							
						}
					}).open();
				}
			</script>
              <tr> 
                <td class='title'>등본상주소</td>
                <td colspan='5'> &nbsp; <input type="text" name='d_zip' id="d_zip" value="<%= sBean.getD_zip() %>" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='d_addr' id="d_addr" value="<%=sBean.getD_addr()%>" size="50">
                </td>
              </tr>
			  <script>
				function openDaumPostcode2() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('h_zip').value = data.zonecode;
							document.getElementById('h_addr').value = data.roadAddress;
							
						}
					}).open();
				}
			</script>
              <tr> 
                <td class='title'>실제주소</td>
                <td colspan='5'> &nbsp; <input type="text" name='h_zip' id="h_zip" value="<%= sBean.getH_zip() %>" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='h_addr' id="h_addr" value="<%=sBean.getH_addr()%>" size="50">
                  <input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
                  상동</td>
              </tr>
              <tr> 
                <td class='title' >입금액</td>
                <td > &nbsp; <input type='text' size='10' name='mm_pr' value="<%=AddUtil.parseDecimal(sBean.getMm_pr())%>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'> 
                </td>
               <td class='title' >입금일</td>
                <td colspan=3 > &nbsp; <input type='text' size='12' name='jan_pr_dt' value="<%=AddUtil.ChangeDate2(sBean.getJan_pr_dt())%>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                </td>
              </tr>
     
              <tr> 
                <td class='title'> 기타사항 </td>
                <td colspan='5'>&nbsp; <textarea name='etc' rows='2' cols='120' maxlength='500'><%=sBean.getEtc()%></textarea> 
                </td>
              </tr>
          
            </table>
        </td>
    </tr>
    <tr>
        <td>**계산서미발행인경우는 입금액,입금일자만 입력하세요!!</td>
    </tr>
 
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>