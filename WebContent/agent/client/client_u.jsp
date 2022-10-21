<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function modify()
	{
		var fm = document.form1;				
		
		if(fm.email_1.value != '' && fm.email_2.value != ''){
			fm.con_agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
		}
							
		if(fm.email_3.value != '' && fm.email_4.value != ''){
			fm.con_agnt_email2.value = fm.email_3.value+'@'+fm.email_4.value;
		}
		
		if ( fm.client_st.value == '1' || fm.client_st.value == '6' ) {		//법인
			if(fm.ssn1.value=="" && fm.ssn2.value==""){	//법인번호가 없는 법인형태인경우에는 운전면허번호체크(20191001) 
				if(fm.lic_no.value == '' || fm.lic_no.value.length < 12){
					//alert('법인번호가 없는 법인형태인 경우에는 운전면허번호를 입력하십시오.');
					//return;
				}
			}
		}else{ //개인,개인사업자
			if(fm.lic_no.value == '' || fm.lic_no.value.length < 12){
				//alert('개인,개인사업자는 운전면허번호를 입력하십시오.');
				//return;
			}
		}

		if(fm.email_1.value == '' || fm.email_2.value == ''){
			alert('세금계산서 담당자-이메일주소를 입력하십시오.'); return;
		}	
		
		var repre_email_len = fm.repre_email.length;
		
		for (var i=0; i<repre_email_len; i++){
			if(fm.repre_email_1[i].value != '' && fm.repre_email_2[i].value != ''){
				fm.repre_email[i].value = fm.repre_email_1[i].value+'@'+fm.repre_email_2[i].value;
			} else{
				fm.repre_email[i].value = '';
			}
		}
		
		/* if(fm.repre_email_1.value != '' && fm.repre_email_2.value != ''){
			fm.repre_email.value = fm.repre_email_1.value+'@'+fm.repre_email_2.value;
		}else{
			fm.repre_email.value = '';
		}	 */	
		
		
		if(fm.etc_cms.value == ''){
//			alert('면책금 cms 청구여부를 입력하십시오.'); return;
		}	
			
		if(fm.fine_yn.value == ''){
//			alert('선납과태료 청구여부를 입력하십시오.'); return;
		}		
			
			
		if(confirm('수정하시겠습니까?'))
		{
			fm.target='i_no';
			fm.submit();
		}
	}

	function search_zip(str)
	{
		window.open("/acar/common/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	function set_o_addr()
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.t_zip[1].value = fm.t_zip[0].value;
			fm.t_addr[1].value = fm.t_addr[0].value;
		}
		else
		{
			fm.t_zip[1].value = '';
			fm.t_addr[1].value = '';
		}
	}
	
	function view_car_mgr(rent_mng_id, rent_l_cd)
	{
		var fm = document.form1;
		fm.action='/acar/mng_client2/car_mgr_in.jsp?rent_mng_id='+rent_mng_id+'&rent_l_cd='+rent_l_cd;
		fm.target='inner2';
		fm.submit();
	}
	
	function go_to_list()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var t_wd = fm.t_wd.value;
		var asc = fm.asc.value;
		location='/agent/client/client_s_frame.jsp?auth_rw='+auth_rw+'&s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc;
	}
	//네오엠 조회하기
	function search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, resizable=yes, scrollbars=yes, status=yes");		
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	ClientBean client = al_db.getNewClient(client_id);
		
	//거래처 자산
	ClientAssestBean client_assest = al_db.getClientAssest(client_id);
	
	//거래처 재무제표
	ClientFinBean client_fin = al_db.getClientFin(client_id);	
	
%>
<body>
<form name='form1' method='post' action='/agent/client/client_u_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='client_st' value='<%=client.getClient_st()%>'>
<input type="hidden" name="ssn1" value="<%=client.getSsn1()%>">
<input type="hidden" name="ssn2" value="<%=client.getSsn2()%>"> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>고객수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td align='right'> 
			<a href="javascript:modify()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
			&nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
		</td>
	</tr>	
	<tr>
	    <td class=line2 colspan=2></td>
	</tr>
	<tr> 
        <td colspan="2" class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='13%'> 고객구분 </td>
                    <td >&nbsp; 
                          <%if(client.getClient_st().equals("1")) 		out.println("법인");
                          	else if(client.getClient_st().equals("2"))  out.println("개인");
                          	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                          	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                          	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");
            				else if(client.getClient_st().equals("6")) 	out.println("경매장");%>
                    </td>
                </tr>
            </table>
        </td>
	</tr>	
	<tr>
        <td class=h></td>
    </tr>
	<tr id=tr_acct1 style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  
        <td colspan="2">
            <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>	
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>법인</span></td>
    			</tr>
    			<tr>
    		        <td class=line2></td>
    		    </tr>
			    <tr>
			        <td class=line>
			            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td colspan="2" class='title'>법인규모</td>
            		            <td>&nbsp;
                				    <select name='firm_st'>
                		              <option value="">선택</option>
                		              <option value="1" <%if(client.getFirm_st().equals("1"))%>selected<%%>>대기업</option>
                		              <option value="2" <%if(client.getFirm_st().equals("2"))%>selected<%%>>중기업</option>					  
                		              <option value="3" <%if(client.getFirm_st().equals("3"))%>selected<%%>>소기업</option>
                		              <option value="4" <%if(client.getFirm_st().equals("4"))%>selected<%%>>크레탑미등재</option>					  
                		            </select>
                					<input type='checkbox' name='enp_yn' value='<%=client.getEnp_yn()%>' <%if(client.getEnp_yn().equals("Y"))%>checked<%%>>
                					대기업
                					<input type='text' name='enp_nm' value='<%=client.getEnp_nm()%>' size='10' maxlength='20' class='text' style='IME-MODE: active'>
                					계열사			        
            				    </td>			
            		            <td class='title'>법인형태</td>
            		            <td>&nbsp;
            				        <select name='firm_type'>
                		                <option value="">선택</option>
                		                <option value="1" <%if(client.getFirm_type().equals("1"))%>selected<%%>>유가증권시장</option>
                		                <option value="2" <%if(client.getFirm_type().equals("2"))%>selected<%%>>코스닥상장</option>
                		                <option value="3" <%if(client.getFirm_type().equals("3"))%>selected<%%>>외감법인</option>
                		                <option value="4" <%if(client.getFirm_type().equals("4"))%>selected<%%>>벤처기업</option>
                		                <option value="5" <%if(client.getFirm_type().equals("5"))%>selected<%%>>일반법인</option>
                		                <option value="6" <%if(client.getFirm_type().equals("6"))%>selected<%%>>국가</option>
                		                <option value="7" <%if(client.getFirm_type().equals("7"))%>selected<%%>>지방자치단체</option>
                		                <option value="8" <%if(client.getFirm_type().equals("8"))%>selected<%%>>정부투자기관</option>
                		                <option value="9" <%if(client.getFirm_type().equals("9"))%>selected<%%>>정부출연연구기관</option>
										<option value="10" <%if(client.getFirm_type().equals("10"))%>selected<%%>>비영리법인</option>
										<option value="11" <%if(client.getFirm_type().equals("11"))%>selected<%%>>면세법인</option>
            		                </select>
            	                </td>
            		        </tr>
		                    <tr>
		                        <td colspan="2" class='title'>설립일자</td>
            		            <td>&nbsp;
            		                <input type='text' name='found_year' value='<%= client.getFound_year()%>' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
            		            <td class='title'>개업일자</td>
            		            <td>&nbsp;
            		            <%= client.getOpen_year()%></td>
		                    </tr>
		                    <tr>
		                        <td width='3%' rowspan="5" class='title'>사<br>
                        		업<br>
                        		자<br>
                        		등<br>
                        		록<br>
                        		증</td>
            		            <td width="10%" class='title'>상호</td>
            		            <td width="37%" align='left'>&nbsp;<%=client.getFirm_nm()%></td>
            		            <td class='title'>대표자</td>
            		            <td width="37%">&nbsp;<%=client.getClient_nm()%></td>
		                    </tr>
		                    <tr>
            		            <td class='title'>사업자번호</td>
            		            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>
								<%if(!client.getTaxregno().equals("")){%>
								(종사업자번호:<%=client.getTaxregno()%>)
								<%}%>
								</td>
            		            <td class='title'>법인번호</td>
            		            <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
		                    </tr>
		                    <tr>
                		        <td class='title'>사업장 주소</td>
                		        <td colspan='3'>&nbsp;
                		              <%if(!client.getO_addr().equals("")){%>
                		              ( 
                		              <%}%>
                		              <%=client.getO_zip()%> 
                		              <%if(!client.getO_addr().equals("")){%>
                		              )&nbsp; 
                		              <%}%>
                		              <%=client.getO_addr()%>
                		        </td>
		                    </tr>		
		                    <tr>
            		            <td class='title'>본점소재지</td>
            		            <td colspan='3'>&nbsp;
            		            <%if(!client.getHo_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getHo_zip()%> 
            		              <%if(!client.getHo_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getHo_addr()%>
            		            </td>
		                    </tr>
		                    <tr>
            		            <td class='title'>업태</td>
            		            <td>&nbsp;<%=client.getBus_cdt()%></td>
            		            <td class='title'>종목</td>
            		            <td>&nbsp;<%=client.getBus_itm()%></td>
            		        </tr>
            		        <tr>
            		            <td rowspan="4" class='title'>대<br>
                        		표<br>
                        		자</td>
            		            <td class='title'>대표자구분</td>
            		            <td>&nbsp;
            			          <select name='repre_st'>
            		                <option value='' <%if(client.getRepre_st().equals("")) out.println("selected");%>>선택</option>
            		                <option value='1' <%if(client.getRepre_st().equals("1")) out.println("selected");%>>지배주주</option>
            		                <option value='2' <%if(client.getRepre_st().equals("2")) out.println("selected");%>>전문경영인</option>
            	         	     </select>	
            			        </td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;<input type='text' name='repre_ssn1' value='<%=client.getRepre_ssn1()%>' maxlength='6' size='6' class='text'>
            						-*******
            						<input type='hidden' name='repre_ssn2' value='<%=client.getRepre_ssn2()%>' maxlength='7' size='7' class='text'></td>
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
            		            <td class='title'>주소</td>
            		            <td colspan="3">&nbsp;
								<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=client.getRepre_zip()%>">
								<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
								&nbsp;<input type="text" name="t_addr" id="t_addr" size="50" value="<%=client.getRepre_addr()%>">
            		            </td>
            		        </tr>
				<%	String email_1 = "";
					String email_2 = "";
					if(!client.getRepre_email().equals("")){
						int mail_len = client.getRepre_email().indexOf("@");
						if(mail_len > 0){
							email_1 = client.getRepre_email().substring(0,mail_len);
							email_2 = client.getRepre_email().substring(mail_len+1);
						}
					}
				%>							
            		        <tr>
            		            <td class='title'>이메일주소</td>
            		            <td colspan=3>&nbsp;
					<input type='text' size='35' name='repre_email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='repre_email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="repre_email_domain" align="absmiddle" onChange="javascript:document.form1.repre_email_2[0].value=this.value;">
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
						<option value="esero.go.kr">esero.go.kr</option>
						<option value="">직접 입력</option>
						</select>
						<input type='hidden' name='repre_email' value='<%=client.getRepre_email()%>'>
            		            </td>            		            
            		        </tr>            		        
            		        <tr>
            		            <td class='title'>휴대폰번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='m_tel' value='<%=client.getM_tel()%>' maxlength='15' class='text'></td></td>
            		            <td class='title'>자택번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='h_tel' value='<%=client.getH_tel()%>' maxlength='15' class='text'></td></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>사무실번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='o_tel' value='<%=client.getO_tel()%>' maxlength='30' class='text'></td>
            		            <td class='title'>팩스번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='fax' value='<%=client.getFax()%>' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>  
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;<input type='text' size='50' name='homepage' value='<%=client.getHomepage()%>' maxlength='70' class='text'></td>
            		        </tr>
		                </table>
			        </td>
		        </tr>
    	    </table>
    	</td>
    </tr>	 
    <tr id=tr_acct2 style="display:<%if(client.getClient_st().equals("1") || client.getClient_st().equals("2") ){%>none<%}else{%>''<%}%>">
	    <td colspan="2">
	        <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    			<tr>
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>개인사업자</span></td>
    		    </tr>
    		    <tr>
    		        <td class=line2></td>
    		    </tr>
    			<tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>사<br>
                    		      업<br>
                    		      자<br>
                    		      등<br>
                    		      록<br>
                    		      증</td>
            		            <td class='title' width='10%'>개업년월일 </td>
            		            <td colspan="3">&nbsp;<%= client.getOpen_year()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>상호</td>
            		            <td width="37%" align='left'>&nbsp;<%= client.getFirm_nm()%></td>
            		            <td class='title'>대표자</td>
            		            <td width="37%">&nbsp;<%= client.getClient_nm()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>사업자번호<br/>
            		            </td>
            		            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
            		        </tr>
            		        <tr>
            		          <td class='title'>사업장 소재지</td>
            		          <td colspan='3'>&nbsp;
            		              <%if(!client.getO_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getO_zip()%> 
            		              <%if(!client.getO_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getO_addr()%>
            		           </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>업태</td>
            		            <td>&nbsp;<%= client.getBus_cdt()%></td>
            		            <td class='title'>종목</td>
            		            <td>&nbsp;<%= client.getBus_itm()%></td>
            		        </tr>
            		        <tr>
            		            <td rowspan="4" class='title'>대<br>
            					표<br>
            					자</td>
            				<td class='title'>대표자구분</td>
            		            <td>&nbsp;
                		            이름 : <input type='text' size='10' name='repre_nm' value='<%=client.getRepre_nm()%>' maxlength='50' class='text' value=''>
                		            (공동대표로 다중일 경우 대표자 공동임차인)
            			        </td>
            			        <td class='title'>생년월일</td>
            		            <td>&nbsp;<input type='text' name='repre_ssn1' value='<%=client.getRepre_ssn1()%>' maxlength='6' size='6' class='text'>
            						-*******
            						<input type='hidden' name='repre_ssn2' value='<%=client.getRepre_ssn2()%>' maxlength='7' size='7' class='text'></td>
            				</tr>
            				<tr>
            		            <td class='title'>주소</td>
								<script>
									function openDaumPostcode1() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip1').value = data.zonecode;
												document.getElementById('t_addr1').value = data.address;
												
											}
										}).open();
									}
								</script>
            		            <td colspan="3">&nbsp;
								<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=client.getRepre_zip()%>">
								<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
								&nbsp;<input type="text" name="t_addr" id="t_addr1" size="50" value="<%=client.getRepre_addr()%>">
            		            </td>
            		       	     		       
            				</tr>
            				<%	email_1 = "";
        					email_2 = "";
					if(!client.getRepre_email().equals("")){
						int mail_len = client.getRepre_email().indexOf("@");
						if(mail_len > 0){
							email_1 = client.getRepre_email().substring(0,mail_len);
							email_2 = client.getRepre_email().substring(mail_len+1);
						}
					}
				%>							
            		        <tr>
            		            <td class='title'>이메일주소</td>
            		            <td colspan=3>&nbsp;
					<input type='text' size='35' name='repre_email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='repre_email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="repre_email_domain" align="absmiddle" onChange="javascript:document.form1.repre_email_2[1].value=this.value;">
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
						<option value="esero.go.kr">esero.go.kr</option>
						<option value="">직접 입력</option>
						</select>
						<input type='hidden' name='repre_email' value='<%=client.getRepre_email()%>'>
            		            </td>            		            
            		        </tr>
            		  
            		        <tr>
            		            <td  class='title'>휴대폰번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='m_tel' value='<%=client.getM_tel()%>' maxlength='15' class='text'></td>
            		            <td class='title'>자택번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='h_tel' value='<%=client.getH_tel()%>' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>사무실번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='o_tel' value='<%=client.getO_tel()%>' maxlength='30' class='text'></td>
            		            <td class='title'>팩스번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='fax' value='<%=client.getFax()%>' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;<input type='text' size='50' name='homepage' value='<%=client.getHomepage()%>' maxlength='70' class='text'></td>
            		        </tr>
    		            </table>
    		        </td>
    		    </tr>
    	    </table>
    	</td>
    </tr>	    
    <tr id=tr_acct3 style="display:<%if(client.getClient_st().equals("2")){%>''<%}else{%>none<%}%>"> 
    	<td colspan="2">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 	  
    		    <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>개인</span></td>
    		    </tr>
    		    <tr>
    		        <td class=line2></td>
    		    </tr>
    			<tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td colspan="2" class='title'>성명</td>
            		            <td align='left'>&nbsp;<%=client.getFirm_nm()%></td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>자택주소</td>
            		            <td colspan='3'>&nbsp;
            		         	  <%if(!client.getHo_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getHo_zip()%> 
            		              <%if(!client.getHo_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getHo_addr()%>
            					</td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>휴대폰</td>
            		            <td>&nbsp;<input type='text' size='30' name='m_tel' value='<%=client.getM_tel()%>' maxlength='15' class='text'></td>
            		            <td class='title'>자택전화번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='h_tel' value='<%=client.getH_tel()%>' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>국적</td>
            		            <td>&nbsp;<select name='nationality'>
                		            <option value=""  <%if(client.getNationality().equals(""))  out.println("selected");%>>선택</option>
                		            <option value="1" <%if(client.getNationality().equals("1")) out.println("selected");%>>내국인</option>
                		            <option value="2" <%if(client.getNationality().equals("2")) out.println("selected");%>>외국인</option>
                		          </select>
								</td>
            		            <td class='title'>Homepage</td>
            		            <td>&nbsp;<input type='text' size='50' name='homepage' value='<%=client.getHomepage()%>' maxlength='70' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td width="3%" rowspan="6" class='title'>소<br>
            		            득<br>정<br>
            		            보</td>
            		            <td width="10%" class='title'>직업</td>
            		            <td width=37%>&nbsp;<input type='text' size='30' name='job' value='<%=client.getJob()%>' maxlength='20' class='text'></td>
            		            <td class='title' width=13%>소득구분</td>
            		            <td width=37%>&nbsp; 
            		            <select name='pay_st'>
            		          		<option value='0' <%if(client.getPay_st().equals("")) out.println("selected");%>>선택</option>
            		            	<option value='1' <%if(client.getPay_st().equals("1")) out.println("selected");%>>급여소득</option>
            		                <option value='2' <%if(client.getPay_st().equals("2")) out.println("selected");%>>사업소득</option>
            		                <option value='3' <%if(client.getPay_st().equals("3")) out.println("selected");%>>기타사업소득</option>
            		                </select>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>직장명</td>
            		            <td colspan="3">&nbsp;<input type='text' size='30' name='com_nm' value='<%=client.getCom_nm()%>' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>부서명</td>
            		            <td>&nbsp;<input type='text' size='30' name='dept value='<%=client.getDept()%>' maxlength='10' class='text'></td>
            		            <td class='title'>직위</td>
            		            <td>&nbsp;<input type='text' size='30' name='title'  value='<%=client.getTitle()%>' maxlength='15' class='text'></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>전화번호</td>
            		            <td>&nbsp;<input type='text' size='30' name='o_tel' value='<%=client.getO_tel()%>' maxlength='15' class='text'></td>
            		            <td class='title'>FAX</td>
            		            <td>&nbsp;<input type='text' size='30' name='fax'  value='<%=client.getFax()%>'  maxlength='15' class='text'></td>
            		        </tr>
							<script>
								function openDaumPostcode2() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip2').value = data.zonecode;
											document.getElementById('t_addr2').value = data.address;
											
										}
									}).open();
								}
							</script>
            		        <tr>
            		            <td class='title'>직장주소</td>
            		            <td colspan="3">&nbsp;
								<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value="<%=client.getComm_zip()%>">
								<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
								&nbsp;<input type="text" name="t_addr" id="t_addr2" size="50" value="<%=client.getComm_addr()%>">
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>근속연수</td>
            		            <td>&nbsp;<input type='text' size='2' name='wk_year' value='<%=client.getWk_year()%>' maxlength='2' class='text'>년</td>
            		            <td class='title'>연소득</td>
            		            <td>&nbsp;<input type='text' size='7'  name='pay_type' maxlength='9' class='text' value='<%=client.getPay_type()%>'>&nbsp;만원</td>
            		        </tr>		
            		        <tr>
            		            <td rowspan="3" class='title'>대<br>
                        		표<br>
                        		자</td>
            		            <td class='title'>대표자구분</td>
            		            <td>&nbsp;
                		            이름 : <input type='text' size='10' name='repre_nm' value='<%=client.getRepre_nm()%>' maxlength='50' class='text' value=''>
                		            (공동임차인)
            			        </td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;<input type='text' name='repre_ssn1' value='<%=client.getRepre_ssn1()%>' maxlength='6' size='6' class='text'>
            						-*******
            						<input type='hidden' name='repre_ssn2' value='<%=client.getRepre_ssn2()%>' maxlength='7' size='7' class='text'></td>
            				</tr>	
            				<script>
								function openDaumPostcode4() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip4').value = data.zonecode;
											document.getElementById('t_addr4').value = data.address;
											
										}
									}).open();
								}
							</script>			
							<tr>
							  <td class=title>주소</td>
							  <td colspan=3>&nbsp;
								<input type="text" name='t_zip' id="t_zip4" size="7"  value='<%=client.getRepre_zip()%>' maxlength='7'>
								<input type="button" onclick="openDaumPostcode4()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr4" value='<%=client.getRepre_addr()%>' size="100">
							  </td>
							</tr>
							<%	email_1 = "";
							email_2 = "";
							if(!client.getRepre_email().equals("")){
								int mail_len = client.getRepre_email().indexOf("@");
								if(mail_len > 0){
									email_1 = client.getRepre_email().substring(0,mail_len);
									email_2 = client.getRepre_email().substring(mail_len+1);
								}
							}
						%>							
            		        <tr>
            		            <td class='title'>이메일주소</td>
            		            <td colspan=3>&nbsp;
					<input type='text' size='35' name='repre_email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='repre_email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="repre_email_domain" align="absmiddle" onChange="javascript:document.form1.repre_email_2[2].value=this.value;">
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
						<option value="esero.go.kr">esero.go.kr</option>
						<option value="">직접 입력</option>
						</select>
						<input type='hidden' name='repre_email' value='<%=client.getRepre_email()%>'>
            		            </td>            		            
            		        </tr>		
    		            </table>
    		        </td>
    		    </tr>
    		</table>
        </td>    
    </tr> 	
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>공통</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
	<tr>
	    <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'> 운전면허번호 </td>
                    <td >&nbsp;
                      <input type='text' size='30' name='lic_no' maxlength='30' class='text' value='<%=client.getLic_no()%>'>
                      &nbsp;(개인,개인사업자,일부 법인사업자)
                    </td>
                    <td colspan="2" style="border-left: none;">
                    	&nbsp;※ 계약자의 운전면허번호를 기재하고, 계약자가 운전면허가 없는 경우 차량이용자의 운전면허를 입력<br>
			            &nbsp;※ 법인번호가 없는 법인사업자도 운전면허번호를 입력(비영리법인 등)
			        </td>
                </tr>	 	  	        	
                <tr>
                    <td width="15%" rowspan='2' class='title'>세금계산서<br>
                    수신담당자</td>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 성명:&nbsp;&nbsp;&nbsp;
        		    <input type='text' size='15' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text'>
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 사무실:
        			<input type='text' size='30' name='con_agnt_o_tel' value='<%=client.getCon_agnt_o_tel()%>' maxlength='30' class='text'>
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 이동전화:
        			<input type='text' size='15' name='con_agnt_m_tel' value='<%=client.getCon_agnt_m_tel()%>' maxlength='15' class='text'>
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> FAX:
        			<input type='text' size='15' name='con_agnt_fax' value='<%=client.getCon_agnt_fax()%>' maxlength='15' class='text'>
        		    </td>
                </tr>
				<%	email_1 = "";
					email_2 = "";
					if(!client.getCon_agnt_email().equals("")){
						int mail_len = client.getCon_agnt_email().indexOf("@");
						if(mail_len > 0){
							email_1 = client.getCon_agnt_email().substring(0,mail_len);
							email_2 = client.getCon_agnt_email().substring(mail_len+1);
						}
					}
				%>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> EMAIL: 
					<input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.co.kr">yahoo.co.kr</option>
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
						<input type='hidden' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>'>
        		    <!--<input type='text' size='42' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='100' class='text'>-->
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 근무부서:
        			<input type='text' size='25' name='con_agnt_dept' value='<%=client.getCon_agnt_dept()%>' maxlength='15' class='text'>
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 직위:
        			<input type='text' size='15' name='con_agnt_title' value='<%=client.getCon_agnt_title()%>' maxlength='10' class='text'>
                    </td>
                </tr>
               <tr>
                    <td width="15%" rowspan='2' class='title'>세금계산서<br>
                    추가담당자</td>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 성명:&nbsp;&nbsp;&nbsp;
        		    <input type='text' size='15' name='con_agnt_nm2' value='<%=client.getCon_agnt_nm2()%>' maxlength='20' class='text'>
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 사무실:
        			<input type='text' size='30' name='con_agnt_o_tel2' value='<%=client.getCon_agnt_o_tel2()%>' maxlength='30' class='text'>
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 이동전화:
        			<input type='text' size='15' name='con_agnt_m_tel2' value='<%=client.getCon_agnt_m_tel2()%>' maxlength='15' class='text'>
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> FAX:
        			<input type='text' size='15' name='con_agnt_fax2' value='<%=client.getCon_agnt_fax2()%>' maxlength='15' class='text'>
        		    </td>
                </tr>
				<%	email_1 = "";
						email_2 = "";
					if(!client.getCon_agnt_email2().equals("")){
						int mail_len = client.getCon_agnt_email2().indexOf("@");
						if(mail_len > 0){
							email_1 = client.getCon_agnt_email2().substring(0,mail_len);
							email_2 = client.getCon_agnt_email2().substring(mail_len+1);
						}
					}
				%>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> EMAIL: 
					<input type='text' size='15' name='email_3' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_4' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain2" align="absmiddle" onChange="javascript:document.form1.email_4.value=this.value;">
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
						<option value="esero.go.kr">esero.go.kr</option>
						<option value="">직접 입력</option>
						</select>
						<input type='hidden' name='con_agnt_email2' value='<%=client.getCon_agnt_email2()%>'>        		    
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 근무부서:
        			<input type='text' size='25' name='con_agnt_dept2' value='<%=client.getCon_agnt_dept2()%>' maxlength='15' class='text'>
        			&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 직위:
        			<input type='text' size='15' name='con_agnt_title2' value='<%=client.getCon_agnt_title2()%>' maxlength='10' class='text'>
                    </td>
                </tr>                          
                <tr>
                    <td class='title'>이메일수신거부</td>
                    <td colspan="3">&nbsp;<input name="etax_not_cau" type="text" value="<%=client.getEtax_not_cau()%>" size="90" class='text'></td>
                </tr>	
                <tr>
                    <td class='title'>거래명세서메일수신여부</td>
                    <td width="35%">&nbsp;
                    <select name='item_mail_yn'>
                        <option value='Y' <%if(client.getItem_mail_yn().equals("Y")||client.getItem_mail_yn().equals("")) out.println("selected");%>>승락</option>
                        <option value='N' <%if(client.getItem_mail_yn().equals("N")) out.println("selected");%>>거부</option>
                    </select>
                    </td>
                    <td width="15%" class='title'>세금계산서메일수신여부</td>
                    <td width="35%">&nbsp;
					<select name='tax_mail_yn'>
                        <option value='Y' <%if(client.getTax_mail_yn().equals("Y")||client.getTax_mail_yn().equals("")) out.println("selected");%>>승락</option>
                        <option value='N' <%if(client.getTax_mail_yn().equals("N")) out.println("selected");%>>거부</option>
                    </select>
					</td>
                </tr>					
                <tr>
                    <td class='title'>계산서발행구분</td>
                    <td width="35%">&nbsp;
                    <select name='print_st'>
                        <option value='1' <%if(client.getPrint_st().equals("1")) out.println("selected");%>>계약건별</option>
                        <option value='2' <%if(client.getPrint_st().equals("2")) out.println("selected");%>>거래처통합</option>
                        <option value='3' <%if(client.getPrint_st().equals("3")) out.println("selected");%>>지점통합</option>
                        <option value='4' <%if(client.getPrint_st().equals("4")) out.println("selected");%>>현장통합</option>
                        <option value='9' <%if(client.getPrint_st().equals("9")) out.println("selected");%>>타시스템발행</option>
                    </select>	
                    </td>
                    <td class='title'>계산서별도발행구분</td>
                    <td width="35%">&nbsp;
                    <select name='print_car_st'>
                        <option value=''  <%if(client.getPrint_car_st().equals("")) out.println("selected");%>>없음</option>
                        <option value='1' <%if(client.getPrint_car_st().equals("1")) out.println("selected");%>>승합/화물/9인승/경차</option>							
                    </select>	
                    </td>										
                </tr>				
                <tr>
					<td class='title'>임의연장계산서발행구분</td>
                    <td>&nbsp;
                    <select name='im_print_st'>
                        <option value=''  <%if(client.getIm_print_st().equals("")) out.println("selected");%>>무조건 개별발행</option>
                        <option value='Y' <%if(client.getIm_print_st().equals("Y")) out.println("selected");%>>고객발행구분 그대로</option>
                    </select>	
                    </td>						
                    <td class='title'>계산서 회차 표시 여부</td>
                    <td >&nbsp;
					<select name='tm_print_yn'>
                        <option value='Y' <%if(client.getTm_print_yn().equals("Y")||client.getTm_print_yn().equals("")) out.println("selected");%>>표시</option>
                        <option value='N' <%if(client.getTm_print_yn().equals("N")) out.println("selected");%>>미표시</option>
                    </select>	                      
					</td>	
                </tr>				
                <tr>					
                    <td width="15%" class='title'>계산서비고</td>
                    <td>&nbsp;
					<select name='bigo_yn'>
                        <option value='Y' <%if(client.getBigo_yn().equals("Y")||client.getBigo_yn().equals("")) out.println("selected");%>>기본만 표시</option>						
                        <option value='A' <%if(client.getBigo_yn().equals("A")) out.println("selected");%>>기본+추가삽입분 표시</option>
                        <option value='B' <%if(client.getBigo_yn().equals("B")) out.println("selected");%>>추가삽입분만 표시</option>						
                        <option value='N' <%if(client.getBigo_yn().equals("N")) out.println("selected");%>>미표시</option>
                    </select>	
					(기본 : 차량번호+차명)
					<!--<input type='checkbox' name='bigo_yn' value='N' <%if(client.getBigo_yn().equals("N"))%>checked<%%>>미표시-->
					</td>			
                    <td class='title'>계산서품목표시구분</td>
                    <td >&nbsp;
					<select name='etax_item_st'>
                        <option value='1' <%if(client.getEtax_item_st().equals("1")||client.getEtax_item_st().equals("")) out.println("selected");%>>한줄만 표시</option>
                        <option value='2' <%if(client.getEtax_item_st().equals("2")) out.println("selected");%>>모두 표시</option>
                    </select>	                      
					</td>												
                </tr>	
                <tr>
                    <td class='title'>계산서비고 추가삽입</td>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 
					고정값 : <input type='text' size='20' name='bigo_value1' value='<%=client.getBigo_value1()%>' maxlength='30' class='text'> 
					&nbsp;
					<img src=/acar/images/center/arrow.gif align=absmiddle>
					변동값 : NO.<input type='text' size='10' name='bigo_value2' value='<%=client.getBigo_value2()%>' maxlength='15' class='text'>                     
					(변동값은 숫자만 가능합니다. 계산서 발행시 이값에 1을 증가하여 비고에 표시합니다.)
					</td>	                    							
                </tr>	
                <tr>
                    <td class='title'>계산서 청구발행 구분</td>
                    <td>&nbsp;
					<select name='pubform'>
                        <option value='D' <%if(client.getPubform().equals("D")||client.getPubform().equals("")) out.println("selected");%>>청구</option>
                        <option value='R' <%if(client.getPubform().equals("R")) out.println("selected");%>>영수</option>
                    </select>	
					</td>				
                    <td class='title'>연체문자수신여부</td>
                    <td>&nbsp;
					<select name='dly_sms'>
                        <option value='Y' <%if(client.getDly_sms().equals("Y")||client.getDly_sms().equals("")) out.println("selected");%>>승락</option>
                        <option value='N' <%if(client.getDly_sms().equals("N")) out.println("selected");%>>거부</option>
                    </select>	
					</td>
                    			
                </tr>												
                <tr>
                    <td class='title'>면책금 CMS 청구 여부</td>
                    <td >&nbsp;
					<select name='etc_cms'>
					    <option value='' <%if(client.getEtc_cms().equals("")) out.println("selected");%>>--선택--</option>
                        <option value='Y' <%if(client.getEtc_cms().equals("Y")) out.println("selected");%>>승락</option>
                        <option value='N' <%if(client.getEtc_cms().equals("N")) out.println("selected");%>>거부</option>
                    </select>	
                      &nbsp;&nbsp;* CMS 거래고객에 한함.
					</td>
					
					<td class='title'>선납과태료 청구 여부</td>
                    <td >&nbsp;
					<select name='fine_yn'>
					    <option value='' <%if(client.getFine_yn().equals("")) out.println("selected");%>>--선택--</option>
                        <option value='Y' <%if(client.getFine_yn().equals("Y")) out.println("selected");%>>승락</option>
                        <option value='N' <%if(client.getFine_yn().equals("N")) out.println("selected");%>>거부</option>
                    </select>	
                      
					</td>
                </tr>		
                    <tr>
                    <td class='title'>연체이자 CMS 청구 여부</td>
                    <td >&nbsp;
					<select name='dly_yn'>
					    <option value='' <%if(client.getDly_yn().equals("")) out.println("selected");%>>--선택--</option>
                        <option value='Y' <%if(client.getDly_yn().equals("Y")) out.println("selected");%>>승락</option>
                        <option value='N' <%if(client.getDly_yn().equals("N")) out.println("selected");%>>거부</option>
                    </select>	
                      &nbsp;&nbsp;* CMS 거래고객에 한함.
					</td>
                    <td class='title'>CMS요청문자수신여부</td>
                    <td >&nbsp;
					<select name='cms_sms'>
					    <option value='' <%if(client.getCms_sms().equals("")) out.println("selected");%>>--선택--</option>
                        <option value='Y' <%if(client.getCms_sms().equals("Y")) out.println("selected");%>>승락</option>
                        <option value='N' <%if(client.getCms_sms().equals("N")) out.println("selected");%>>거부</option>
                    </select>	
                     
					</td>					
		
                </tr>		                
                <tr>
                    <td class='title'>네오엠코드</td>
                    <td colspan='3'>&nbsp;<input type='text' name='ven_name' size='50' value='<%=client.getFirm_nm()%>' class='text' style='IME-MODE: active'>
        			  &nbsp;<a href="javascript:search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a> 	
        			  &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <input type='text' name='ven_code' size='10' value='<%=client.getVen_code()%>' class='text'>		
        		    </td>
                </tr>		
                <tr>					
                    <td width="15%" class='title'>차량사용용도</td>
                    <td colspan='3'>&nbsp;<input type='text' size='30' name='car_use' value='<%=client.getCar_use()%>' maxlength='10' class='text'></td>		  
                </tr>											
                <tr>
                    <td class='title'> 특이사항 </td>
                    <td colspan='3'>&nbsp;<textarea name='etc' rows='3' cols='90' maxlenght='500'><%=client.getEtc()%></textarea></td>
                </tr>                
            </table>
        </td>
    </tr>	
	<tr>
	    <td>&nbsp;</td>
    </tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>

</body>
</html>
