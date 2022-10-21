<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.asset.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="bean" class="acar.asset.AssetMaBean" scope="page"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String asset_code = request.getParameter("asset_code")==null?"":request.getParameter("asset_code");
	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//자산 정보 
	AssetDatabase a_db = AssetDatabase.getInstance();
	bean = a_db.getAssetMa(asset_code);
	
	//차량정보
	Hashtable ht = shDb.getBase(bean.getCar_mng_id());
	
	String enp_no1 = "";
	String enp_no2 = "";
	String enp_no3 = "";
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
<!--
	//저장하기
	function save(){
		var fm = document.form1;
		
		if(fm.assch_date.value == ''){	alert('변동일자를 입력하십시오.'); return;}		
		
			//변동일과 기수가 틀린경우 체크  s_str.substring(0,4)
		if ( fm.assch_date.value.substring(0,4)  != fm.gisu.value  ) {
			alert('해당 기수 자산으로만 자산처리할 수 있습니다.');
			return;
		}
		
		// 자산 상각 기수 맞추기.
	//	if ( toInt(replaceString("-","",fm.assch_date.value)) > 20171231	) {
	/*
		if ( toInt(replaceString("-","",fm.assch_date.value)) <= 20171231	) {
			alert('2018년 자산으로만 자산처리할 수 있습니다.');
			return;
		}
	*/
					
		if(fm.sh_car_amt.value == ''){	alert('잔가 계산하기를 누르세요.'); return;}			
		if(fm.s_sup_amt.value == ''){	alert('공급가를 입력하세요.'); return;}			
		
		if ( toInt(parseDigit(fm.sh_car_amt.value))  < 1 ) { alert('잔가 계산하기를 누르세요.'); return;}		
		
	         //계산서 발행인경우
	         if ( fm.bill_doc_yn.value == '1' ) {
	          	if(fm.client_id.value == ''){	alert('공급받는자를 선택하세요.'); return;}	        
	          	//if( fm.ssn1.value=='' || (!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || 
			//((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) ||
			//((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{
		//	alert('주민등록번호를 확인하십시오');
		//	return ; 	         
	         }
	         		
			
		if(!confirm('등록하시겠습니까?')){	return;	}
		
		fm.action = 'asset_move_reg3_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	
	function account_jangaamt(){
		var fm = document.form1;
		var fm2 = document.sh_form;	
		
		if(fm.assch_date.value == ''){	alert('변동일자를 입력하십시오.'); return;}				
		
		fm2.rent_st.value 	= '1'; //재리스
		fm2.a_b.value 		= '1'; //1개월
		fm2.rent_dt.value 	= fm.assch_date.value; //변동일자 기준
		fm2.mode.value 		= 'asset';
		fm2.action='/acar/secondhand/getSecondhandJanga.jsp';
		fm2.target='i_no';
		fm2.submit();	
	}
	

	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		window.open("/acar/mng_client2/client_enp.jsp?client_id="+fm.client_id.value, "VIEW_CLIENT", "left=100, top=100, width=630, height=500");
	}	
	
			
	//거래처조회하기
	function search(idx){
		var fm = document.form1;	
		var h_wd;
		if(fm.firm_nm.value != ''){	h_wd = fm.firm_nm.value;		}
		else{ 							alert('조회할 거래처명을 입력하십시오.'); 	fm.firm_nm.focus(); 	return;}
		
		window.open("/acar/off_ls_cmplt/client_s_p.jsp?go_url=/fms2/asset/asset_move_reg3.jsp&h_wd="+h_wd, "CLIENT", "left=100, top=100, width=650, height=500, status=yes");
			
	}
	
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	
	
//-->	
</script>
</head>

<body leftmargin="15" onLoad="javascript:document.form1.assch_date.focus()">
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="car_mng_id"		value="<%=bean.getCar_mng_id()%>">  
  <input type='hidden' name="mode"				value="">    
  <input type='hidden' name="rent_dt"			value="">    
  <input type='hidden' name="rent_st"			value="">      
  <input type='hidden' name="a_b"				value="">     
  <input type='hidden' name="fee_opt_amt"		value="">
  <input type='hidden' name="cust_sh_car_amt"	value="">   
  <input type='hidden' name="sh_amt"			value="">     
  <input type='hidden' name="cls_n_mon"			value="">     
  <input type='hidden' name="today_dist"		value="<%=String.valueOf(ht.get("TODAY_DIST"))%>">         
</form>
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='asset_code' value='<%=asset_code%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<input type="hidden" name="h_wd" value="">  
<input type="hidden" name="sui_nm" value="">
<input type="hidden" name="gisu" value="<%=bean.getGisu()%>">


<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%> 변동 내역</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width="80">변동일자</td>
                    <td colspan=5> 
                      <input type="text" name="assch_date"  type="text" class="text" value="" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="80">변동구분</td>
                   <td colspan=5> <select name="assch_type">
                      
                         <option value="3" >매각/폐기</option>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="80">내역</td>
                        <td colspan=5> 
                      <input type="text" name="assch_rmk"   size="50" class=text style='IME-MODE: active'>
                    </td>
                </tr>
           
                <tr> 
                 	<td class=title width="80">처분수량</td>
                      <td colspan=5> 
                      <input type="text" name="sale_quant"   size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
                <tr> 
                 	<td class=title width="80">처분금액</td>
                         <td colspan=5> 
                      <input type="text" name="sale_amt"   size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>원
                      &nbsp;&nbsp; &nbsp; ( 공급가: 
                        <input type="text" name="s_sup_amt"   size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>원  ) 
               	    &nbsp;&nbsp; &nbsp;
                </td>                    
                </tr>
                <tr> 
                 	<td class=title width="80">잔가금액</td>
                      <td colspan=5> 
                      <input type="text" name="sh_car_amt"  readonly  size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  <a href="javascript:account_jangaamt()" onMouseOver="window.status=''; return true" title="잔가금액 계산하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a>
                    </td>
                </tr>
                  <tr> 
                 	<td class=title width="80">계산서</td>
                        <td colspan=5> &nbsp;<select name="bill_doc_yn">
                        <option value="0" >미발행</option>
                        <option value="1" >발행</option>              
                      </select>  
                      &nbsp; &nbsp; &nbsp; &nbsp;*계산서 발행시에만 아래의 공급받는자를 입력하세요!!!
                                             
                </td>                    
                </tr>
        <!--계산서 관련-->        
                <tr> 
                    <td class='title'> 공급받는자</td>
                    <td colspan="5">&nbsp; <input type='text' name='firm_nm'  size='30' maxlength='40' class='text' onKeyDown="javasript:search_enter(1)">
        			<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
        			<input type="hidden" name="client_id" value="">  
        		 </td>
                </tr>             
           
                <tr> 
                    <td class='title'>주민등록번호<br/> </td>
                    <td>&nbsp;
                             <input type='text' size='6' name='ssn1' maxlength='6' class='text' value="" >
	                      - 
	                    <input type='text' name='ssn2' maxlength='7' size='7' class='text' value=""  >            
                    </td>
                    <td class='title'>사업자번호</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='enp_no1' value='<%= enp_no1 %>' size='3' class='text' maxlength='3'>
                      - 
                      <input type='text' name='enp_no2' value='<%= enp_no2 %>' size='2' class='text' maxlength='2'>
                      - 
                      <input type='text' name='enp_no3' value='<%= enp_no3 %>' size='5' class='text' maxlength='5'  > 
                     
                    </td>
                </tr>
                <tr>
                    <td class='title'>전화번호</td>
                    <td>&nbsp; <input type='text' size='15' name='h_tel' maxlength='15' class='text' value="" ></td>
                    <td class='title'>휴대폰번호</td>
                    <td colspan="3">&nbsp; <input type='text' size='15' name='m_tel' maxlength='15' class='text' value="" ></td>
                </tr>
				<%	String email_1 = "";
					String email_2 = "";				
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
					  <input type='hidden' name='email' value=''>
					
                    </td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('d_zip').value = data.zonecode;
								document.getElementById('d_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title width='15%'>주소</td>
				  <td colspan=5>&nbsp;
					<input type="text" id="d_zip" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" id="d_addr"  size="80"  maxlength="150"  value="">
				  </td>
				</tr>		
				
				
        
            </table>
        </td>
    </tr>
    
    <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("자산관리",user_id)){%>
    <tr> 
        <td align="right"><a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a> 
        </td>
    </tr>
   <%}%>
    
</table>  
  </form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
