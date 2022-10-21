<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.common.*, acar.client.*, acar.res_search.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	//자동이체 등록/수정화면 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc	= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	int stat = 0;
	boolean flag = true;
	
	//계약기본정보
	ContBaseBean base 	= a_db.getCont(m_id, l_cd);
	//고객정보
	ClientBean client 	= al_db.getClient(client_id);
	//자동이체정보
	ContCmsBean cms 	= a_db.getCmsMng(m_id, l_cd);
	
	//차량정보
	Hashtable reserv 	= rs_db.getCarInfo(c_id);	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);	
	
	Vector conts = rs_db.getScdRentList(s_cd, "");
	int cont_size = conts.size();
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();	
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();		
	}	
	
	//수정: 차량관리자 수정,추가
	function save(){
		var fm = document.form1;
		if(fm.cms_bank.value == ''){ 		alert("신청계좌 거래은행을 입력하십시오."); 	fm.cms_bank.focus(); 		return; }
		if(fm.cms_acc_no.value == ''){ 		alert("신청계좌번호를 입력하십시오."); 		fm.cms_acc_no.focus(); 		return; }
		if(fm.cms_dep_nm.value == ''){ 		alert("예금주를 입력하십시오."); 		fm.cms_dep_nm.focus(); 		return; }
		
		if(confirm('처리하시겠습니까?')){
			fm.target='i_no';
			fm.action='cms_mng_null.jsp';
			fm.submit();
		}
	}
	
	//등록/수정: 우편번호 조회
	function search_zip(str){
		window.open("/fms2/lc_rent/zip_s.jsp?str="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}	
	
	function go_to_list()
	{
		var fm = document.form1;
		fm.action='cms_s_frame.jsp';
		fm.target='d_content';
		fm.submit();		
	}	
	
	
	
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post' action='cms_mng_null.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>

<input type='hidden' name='seq' value='<%=cms.getSeq()%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 재무회계 > <span class=style5>CMS관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr> 
    <tr> 
        <td colspan=2 align="right">        
          <a href='javascript:go_to_list()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border="0"></a>
        </td>
    </tr>    
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 	    
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=10%>계약번호</td>
                    <td width=14%>&nbsp;<%=l_cd%></td>
                    <td class='title' width=10%>상호</td>
                    <td width=18%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class='title' width=10%>계약자</td>
                    <td width=14%>&nbsp;<%=client.getClient_nm()%></td>
                    <td class='title' width=10%>차량번호</td>
                    <td width=14%>&nbsp;<%=reserv.get("CAR_NO")%></td>
                </tr>
                <tr> 
                    <td class='title' width=10%>최초영업자</td>
                    <td>&nbsp;        			  
        			  <%=c_db.getNameById(rc_bean.getBus_id(),"USER")%>
        	    </td>		  
                    <td class='title' width=10%>관리담당자</td>
                    <td>&nbsp;        			  
        			  <%=c_db.getNameById(rc_bean.getMng_id(),"USER")%>
        	    </td>		  
                    <td class='title' width=10%>통장사본</td>
                    <td colspan='3'>&nbsp;
                 <%
                	String content_code  = "SC_SCAN";
                	String content_seq  = c_id+""+s_cd+"9";
                
                	Vector attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	int attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                    
             <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
        
                <%		}
                	}%>                
        			  </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수납기관 및 요금 종류</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='24%' class='title'>수납기관명</td>
                    <td class='title' width=28%>담당자</td>
                    <td class='title' width=24%>대금종류</td>
                    <td class='title' width=24%>금액</td>
                </tr>
                <tr> 
                    <td align='center'> 주식회사 아마존카</td>
                    <td align="center"> 대여료청구담당자(02-392-4243)</td>
                    <td align="center"> 
                      <select name='cms_st'>
                        <option value="1" <%if(cms.getCms_st().equals("1"))%>selected<%%>>대여료</option>
                      </select>
                    </td>
                    <td align="center"> 
                        <input type='text' name='cms_amt' size='12' class='num' value="<%if(cms.getSeq().equals("")){%><%}else{%><%=AddUtil.parseDecimal(cms.getCms_amt())%><%}%>" onBlur='javascript:this.value=parseDecimal(this.value);'>                원
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신청 고객(업체) 기본사항</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='24%' class='title'>구분</td>
                    <td class='title' width=28%>사업자번호</td>
                    <td class='title'>생년월일/법인등록번호</td>
                </tr>
                <tr> 
                    <td align='center'> 
                      <select name='cp_st'>
                        <option value="1" <%if(cms.getCp_st().equals("1"))%>selected<%%>>개인</option>
                        <option value="2" <%if(cms.getCp_st().equals("2") || cms.getCp_st().equals(""))%>selected<%%>>법인</option>
                      </select>
                      통장</td>
                    <td align="center">&nbsp;<%=client.getEnp_no1()%><%=client.getEnp_no2()%><%=client.getEnp_no3()%></td>
                    <td align="center">&nbsp;<%if (!client.getClient_st().equals("1")){%><%=client.getSsn1()%>-*******<%}else{%><%=client.getSsn1()%><%=client.getSsn2()%><%}%></td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출금이체 신청내용</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='24%' class='title'>신청구분</td>
                    <td class='title' width="28%">최초인출일자</td>
                    <td class='title' width="24%">마지막인출일자</td>
                    <td class='title' width="24%">이체일</td>
                </tr>
                <tr> 
                    <td align='center'> 
                      <select name='reg_st'>
                        <option value="1"  <%if(cms.getReg_st().equals("1"))%>selected<%%>>신청</option>
                        <option value="2"  <%if(cms.getReg_st().equals("2"))%>selected<%%>>해지</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_start_dt' size='12' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_end_dt' size='12' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                      </td>
                    <td align="center"> 매월 
                      <select name='cms_day'>
        		<%for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>' <%if(AddUtil.parseInt(cms.getCms_day()) == i){%> selected <%}%>><%=i%></option>
                        <%} %>
                      </select>
                      일</td>
                </tr>
                <tr> 
                    <td class='title'>신청계좌 거래은행</td>
                    <td class='title'>신청계좌번호</td>
                    <td class='title'>예금주</td>
                    <td class='title'>예금주 생년월일/사업자번호</td>
                </tr>
                <tr> 
                    <td align='center'> 
                      <select name='cms_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	
        							if(cms.getCms_bank().equals("")){%>
                        <option value='<%= bank.getNm()%>' ><%=bank.getNm()%></option>
                        <%			}else{%>
                        <option value='<%= bank.getNm()%>' <%if(cms.getCms_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}%>
                        <%		}
        					}%>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_acc_no' size='20' class='text' value="<%=cms.getCms_acc_no()%>">
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_dep_nm' size='20' class='text' value="<%if(cms.getCms_dep_nm().equals("")){%><%=client.getFirm_nm()%><%}else{%><%=cms.getCms_dep_nm()%><%}%>" style='IME-MODE: active'>
                      </td>
                    <td align="center"> 
                      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
                    </td>
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
                    <td class='title'>예금주 주소</td>
                    <td colspan="3">&nbsp; 
						<input type="text" name='t_zip' id="t_zip" value="<%if(cms.getCms_dep_post().equals("")){%><%=client.getO_zip()%><%}else{%><%=cms.getCms_dep_post()%><%}%>" size="7" maxlength='7' class='text'>
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" value="<%if(cms.getCms_dep_addr().equals("")){%><%=client.getO_addr()%><%}else{%><%=cms.getCms_dep_addr()%><%}%>" size="77" class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>연락전화</td>
                    <td class='title'>휴대폰</td>
                    <td class='title' colspan="2">이메일</td>
                </tr>
                <tr> 
                    <td align='center'> 
                      <input type='text' name='cms_tel' size='15' class='text' value="<%if(cms.getCms_tel().equals("")){%><%= client.getO_tel()%><%}else{%><%=cms.getCms_tel()%><%}%>">
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_m_tel' size='15' class='text' value="<%=cms.getCms_m_tel()%>">
                    </td>
                    <td align="center" colspan="2">
                      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=cms.getCms_email()%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>계약번호/차량번호</td>
                    <td align="center">
                      <input type='text' name='cms_etc' size='20' class='text' value="<%=cms.getCms_etc()%>" >
                    </td>
                    <td class='title'>신청일자</td>
                    <td align="center">
                      <input type='text' name='app_dt' size='12' class='text' value="<%=AddUtil.ChangeDate2(cms.getApp_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<font color="#666666">※ 자동이체 신청 가능 은행 : 국민,신한,우리,조흥,농협,하나,부산,대구<br>&nbsp;&nbsp;※ 계좌번호, 예금주 주민/사업자번호 입력시 '-' 제외하여 입력</font></td>
        <td align="right">
        <%	if(cms.getSeq().equals("")){
        		if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border="0"></a>&nbsp;&nbsp; 
        <%		}
	    	}else{
        		if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border="0"></a>&nbsp;&nbsp; 
        <%		}
	  		}%>
        </td>
    </tr>
    <tr> 
        <td colspan='2'>&nbsp;&nbsp;<font color="#666666">※ 최초등록 : <%=cms.getReg_dt()%> <%=c_db.getNameById(cms.getReg_id(),"USER")%> / 최종수정자 : <%=cms.getUpdate_dt()%> <%=c_db.getNameById(cms.getUpdate_id(),"USER")%> / 신청자 : <%=c_db.getNameById(cms.getApp_id(),"USER")%> </font></td>
    </tr>
    <tr> 
        <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트 스케줄</span></td>
    </tr>    	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='3%' class='title'>연번</td>
                    <td width='9%' class='title'>요금구분</td>
                    <td width='3%' class='title'>연장</td>
                    <td width='9%' class='title'>수금구분</td>
                    <td width='8%' class='title'>입금예정일</td>
                    <td width='8%' class='title'>공급가</td>		
                    <td width='7%' class='title'>부가세</td>		
                    <td width='8%' class='title'>합계</td>
                    <td width='8%' class='title'>입금일자 </td>
                    <td width='8%' class='title'>실입금액</td>                    
                    <td width='7%' class='title'>세금계산서</td>						
                    <td width='4%' class='title'>연체일</td>
                    <td width='4%' class='title'>연체료</td>
                </tr>
		<%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
			
				Hashtable sr = (Hashtable)conts.elementAt(i);
				
				String is = "";
				String white = "";
				
				if(!String.valueOf(sr.get("PAY_DT")).equals("") || String.valueOf(sr.get("RENT_AMT")).equals("0")){
					is 	= "class='is'";
					white 	= "white";
				}
				
				%>					
                <tr> 
                    <td <%=is%> align='center'><%=i+1%></td>
                    <td <%=is%> align='center'>
                                <select name="v_rent_st">
            	              	  <option value="">==선택==</option>			              	              	  
                	          <option value="1" <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>selected<%}%>>예약금</option>
                    	          <option value="2" <%if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>selected<%}%>>선수대여료</option>
                    	          <option value="3" <%if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>selected<%}%>>대여료</option>
                    	          <option value="5" <%if(String.valueOf(sr.get("RENT_ST")).equals("5")){%>selected<%}%>>연장대여료</option>
                    	          <option value="4" <%if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>selected<%}%>>정산금</option>
                    	          <option value="6" <%if(String.valueOf(sr.get("RENT_ST")).equals("6")){%>selected<%}%>>보증금</option>
                    	          <option value="7" <%if(String.valueOf(sr.get("RENT_ST")).equals("7")){%>selected<%}%>>연체이자</option>
        	                </select>        	                
        	    </td>
        	    <td <%=is%> align='center'>
        	    		<input type='text' name='v_ext_seq' size='2' value='<%=sr.get("EXT_SEQ")%>' class='<%=white%>text'>
        	    </td>
        	    <td <%=is%> align='center'>
        	                <select name="v_paid_st">
            	                  <option value="">=선택=</option>			  
                	          <option value="1" <%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>selected<%}%>>현금</option>
                    	          <option value="2" <%if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>selected<%}%>>신용카드</option>
                    	          <option value="3" <%if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>selected<%}%>>자동이체</option>					  
                    	          <option value="4" <%if(String.valueOf(sr.get("PAID_ST")).equals("4")){%>selected<%}%>>무통장입금</option>					  					  
        	                </select>        					
        			</td>		
                    <td <%=is%> align='center'><input type='text' name='v_est_dt' size='12' value='<%=AddUtil.ChangeDate2(String.valueOf(sr.get("EST_DT")))%>' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td <%=is%> align='center'><input type='text' name='v_rent_s_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("RENT_S_AMT")))%>' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=i%>);'></td>			
                    <td <%=is%> align='center'><input type='text' name='v_rent_v_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("RENT_V_AMT")))%>' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=i%>);'></td>			
                    <td <%=is%> align='center'><input type='text' name='v_rent_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("RENT_AMT")))%>' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=i%>);'></td>
                    <td <%=is%> align='center'><input type='text' name='v_pay_dt' size='12' value='<%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td <%=is%> align='center'><input type='text' name='v_pay_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_rest_amt()'></td>                    
                    <td <%=is%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(sr.get("TAX_DT")))%>
                      <!--세금계산서 발행요청-->
                      <%if(String.valueOf(sr.get("TAX_DT")).equals("") && AddUtil.parseLong(String.valueOf(sr.get("RENT_V_AMT"))) >0 && !String.valueOf(sr.get("PAID_ST")).equals("2")){%>
                      발행요청
                      <%}%>
                    </td>
                    <td <%=is%> align='right'><%=sr.get("DLY_DAYS")%></td>
                    <td <%=is%> align='right'><%=Util.parseDecimal(String.valueOf(sr.get("DLY_AMT")))%></td>
                </tr>	  
<%		}}%>     
            </table>
		</td>
	</tr>   
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
