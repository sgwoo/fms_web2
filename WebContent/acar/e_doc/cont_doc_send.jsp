<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.fee.*, acar.client.*, acar.cont.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	// 로그인 정보
	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_m_tel 	= login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}

    // 영업담당자 리스트
    Vector users = at_db.getUserList("", "", "EMP", "Y");
    int user_size = users.size();
    
    String document_st 		= request.getParameter("document_st")		== null ? "1" 	: request.getParameter("document_st");			// 문서 구분. 대분류.
    String document_type 	= request.getParameter("document_type")	== null ? "" 	: request.getParameter("document_type");		// 계약서 구분
  
    String rent_mng_id		= request.getParameter("rent_mng_id")		== null ? "" : request.getParameter("rent_mng_id");
   	String rent_l_cd 			= request.getParameter("rent_l_cd")			== null ? "" : request.getParameter("rent_l_cd");
   	String rent_st 				= request.getParameter("rent_st")				== null ? "" : request.getParameter("rent_st");
   	String status 				= request.getParameter("status")				== null ? "" : request.getParameter("status");
   	String client_id 			= request.getParameter("client_id")			== null ? "" : request.getParameter("client_id");
   	String car_st 				= request.getParameter("car_st")				== null ? "" : request.getParameter("car_st");
   	
   	String send_type			= request.getParameter("send_type")			== null ? "" : request.getParameter("send_type");
   	
  	//계약기본정보
  	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
  	//계약기타정보
  	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
  	//고객정보
  	ClientBean client = al_db.getNewClient(client_id);
  	//지점정보
  	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
  	//고객관련자
  	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
  	int mgr_size = car_mgrs.size();
  	//계약담당자
  	CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "계약담당자");
 	//계약승계-기존임차인
  	CarMgrBean suc_mgr = new CarMgrBean();
 	
  	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
  	
  	//이용개월수 & 납입회수 비교 위한 정보 fetch(20191010)	
  	//대여료갯수조회(연장여부)
  	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
  	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
  	
  	int overCount = 0;
    if(document_st.equals("1")){	// 계약서
	 	if(document_type.equals("2")){	// 승계 계약
	 		suc_mgr = a_db.getCarMgr(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "계약담당자");
	 	}
    
    	// 기존 발송 건 유무 조회
    	overCount = ln_db.getEDocMngOverCount(rent_l_cd, rent_mng_id, rent_st);
    }
    

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS - 전자문서 발송</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style type="text/css">
.logo_area {
	height: 45px;
}
.logo_img {
	margin-left: 20px;
}
.no-drag {
	-ms-user-select: none;
	-moz-user-select: -moz-none;
	-webkit-user-select: none;
	-khtml-user-select: none;
	user-select:none;
}
.menu_table_top {
	border: 0px;
	padding: 0px;
	border-spacing: 0px;
}
.menu_table_top td {
	width: 100px;
	height: 40px;
	vertical-align: middle;
    text-align: center;
    background-color: #349BD5;
    cursor: pointer;
	line-height: 14pt;
	font-family: Nanum Square;
    color: #FFF;
	font-weight: bold;
}
.menu_table_top .no-drag:hover {
	background-color: #F6F6F6;
	color: #349BD5;
	font-weight: bold;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
	
	// 문서 구분 선택 시 처리
	function changeDocSelect(sel){
		
		// 검색 버튼 노출
		var searchArea = document.getElementsByClassName('doc-search-area');
		searchArea[0].style.display = 'inline-block';
		
		// 문서명 값 세팅
		var fm = document.form1;
		var doc_name = sel.options[sel.selectedIndex].text
		fm.doc_name.value = doc_name;
		
		// 월렌트계약서 선택 시 발송 구분에 현장 항목 노출.
		var send_parks = document.getElementsByClassName('send_park');
		if(doc_name == '월렌트계약서'){
			for(var i=0; i<send_parks.length; i++){
				send_parks[i].style.display = 'inline-block';
			}
		} else {
			for(var i=0; i<send_parks.length; i++){
				send_parks[i].style.display = 'none';
			}
		}
		
	}
	
	// 검색 팝업
	function openSearchPopup(){
		var document_st = document.getElementById('document_st').value;
		var document_type = '';
		<%if(document_st.equals("") && document_type.equals("")){%>
			document_type = document.getElementsByClassName('document_type')[document_st-1].value;
		<%} else {%>
			document_type = document.getElementsByClassName('document_type')[0].value;
		<%}%>
		
		if(document_type == '') {
			alert('문서를 선택하세요.');
			return;
		}
		
		window.open('e_doc_search.jsp?document_st='+document_st+'&document_type='+document_type, 'SEARCH', 'left=10, top=10, width=1000, height=800, scrollbars=yes, status=yes, resizable=yes')
	}
	
	//이메일주소 점검
	function isEmail(str) {
		// regular expression? 지원 여부 점검
		var supported = 0;
		if (window.RegExp) {
			var tempStr = "a";
			var tempReg = new RegExp(tempStr);
			if (tempReg.test(tempStr)) supported = 1;
		}
		if (!supported) return (str.indexOf(".") > 2) && (str.indexOf("@") > 0);
		var r1 = new RegExp("(@.*@)|(\\.\\.)|(@\\.)|(^\\.)");
		var r2 = new RegExp("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$");
		return (!r1.test(str) && r2.test(str));
	}
	
	//수신 메일 주소 세팅
	function mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.s_mail_addr.options[fm.s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split 	= i_mail_addr.split("||");
			fm.mgr_nm.value 	= i_mail_addr_split[0];
			fm.mgr_email.value 	= i_mail_addr_split[1];
			fm.mgr_m_tel.value 	= i_mail_addr_split[2];
		}else{
			fm.mgr_nm.value 	= '';
			fm.mgr_email.value 	= '';
			fm.mgr_m_tel.value 	= '';
		}
	} 
	
	// 기존 임차인 수신 메일 주소 세팅
	function suc_mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.suc_s_mail_addr.options[fm.suc_s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split 	= i_mail_addr.split("||");
			fm.suc_mgr_nm.value 	= i_mail_addr_split[0];
			fm.suc_mgr_email.value 	= i_mail_addr_split[1];
			fm.suc_mgr_m_tel.value 	= i_mail_addr_split[2];
		}else{
			fm.suc_mgr_nm.value 	= '';
			fm.suc_mgr_email.value 	= '';
			fm.suc_mgr_m_tel.value 	= '';
		}
	}
	
	// 전자 문서 전송
	function sendEDoc(){
		var fm = document.form1;
		
		var document_st = '<%=document_st%>';
		var document_type = '<%=document_type%>';
		
		// 문서명 값 세팅
		var sel = document.querySelector('.document_type');
		fm.doc_name.value = sel.options[sel.selectedIndex].text;
		
		var send_type = fm.send_type.value;
		if(send_type == ''){
			alert('발송 구분을 선택해 주세요.');
			return;
		}
		
		/* var sign_type = fm.sign_type.value;
		if(sign_type == ''){
			alert('서명 구분을 선택해 주세요.');
			return;
		} */
		
		if(document_st == 1){	// 계약서
			
			if(document_type != 4){	// 월렌트 계약서 외. 신규, 승계, 연장 계약서
				<% if( client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1") && !cont_etc.getClient_share_st().equals("1") ){%>
					alert('장기계약서 법인일 때는 대표자 연대보증 대신 대표자 공동임차로 해야 합니다. ');	
					return;
				<% }%>
				
				<% if( client.getClient_st().equals("2") && client.getM_tel().equals("") ){%>
					alert('장기계약서 개인일 때는 휴대폰 번호가 입력되어야 합니다. 고객관리에서 입력하십시오.');	
					return;
				<% }%>
			} else {
				<%	if(fee_rm.getCms_type().equals("")){%>
				if(fm.cms_type[0].checked == false && fm.cms_type[1].checked == false){		
					alert('2회차 청구 방식을 선택하십시오.'); return;
				}
				<%	}%>
			}
		
			if(fm.rent_l_cd.value == ''){
				alert('계약 건이 선택되지 않았습니다.');
				return;
			}
			
			if(send_type == 'mail'){		// 발송 구분 메일인 경우
				var mgr_email = fm.mgr_email.value;
			
				if( !isEmail(mgr_email) ){
					alert('올바른 메일 주소를 입력해 주세요.');
					fm.mgr_email.focus();
					return;
				}
				if( mgr_email == "" || mgr_email == "@" ){ 
					alert("메일 주소를 입력해 주세요.");
					fm.mgr_email.focus();
					return; 
				}
				if( mgr_email.indexOf("@") < 0 || mgr_email.indexOf(".") < 0 || get_length(mgr_email) < 5 ){ 
					alert("메일 주소가 명확하지 않습니다.");
					fm.mgr_email.focus();
					return; 
				}
				
				//공동임차면 공동임차인 이메일 정보 필수 입력
				<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){%>
					var repre_email = fm.repre_email.value;
					
					if( repre_email == "" ){		
						alert("공동 임차인의 메일주소를 입력해 주세요.");
						fm.repre_email.focus();
						return;	
					}
					if( repre_email.indexOf("@") < 0 || repre_email.indexOf(".") < 0 || get_length(repre_email) < 5 ){ 	
						alert("공동 임차인의 메일주소가 명확하지 않습니다.");
						fm.repre_email.focus();
						return; 	
					}
				<%}%>
				
				// 승계 계약
				if(document_type == 2){
					var suc_mgr_email = fm.suc_mgr_email.value;
					
					if( suc_mgr_email == ""){
						alert("기존 임차인의 메일 주소를 입력해 주세요.");
						fm.suc_mgr_email.focus();
						return;	
					}
					if( suc_mgr_email.indexOf("@") < 0 || suc_mgr_email.indexOf(".") < 0 || get_length(suc_mgr_email) < 5 ){ 	
						alert("기존 임차인의 메일주소가 명확하지 않습니다.");
						fm.suc_mgr_email.focus();
						return; 	
					}
				}
				
			} else{		// 발송 구분: 알림톡 / 현장
				var mgr_m_tel = fm.mgr_m_tel.value;
				if( mgr_m_tel == '' ){
					alert('휴대폰 번호를 입력해 주세요.');
					fm.mgr_m_tel.focus();
					return;
				}
				
				// 공동임차인 있는 경우
				<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){%>
						var repre_email = fm.repre_m_tel.value;
						
						if( repre_m_tel == '' ){		
							alert("공동 임차인의 휴대폰 번호를 입력해 주세요.");
							fm.repre_m_tel.focus();
							return;	
						}
				<%}%>
			
				// 승계 계약
				if(document_type == 2){
					var suc_mgr_m_tel = fm.suc_mgr_m_tel.value;
					
					if( suc_mgr_m_tel == '' ){
						alert("기존 임차인의 휴대폰 번호를 입력해 주세요.");
						fm.suc_mgr_m_tel.focus();
						return;	
					}
				}
			}
			
			//이용개월수보다 납입회수가 더 크면 전송불가(20191010)
			<%	if(!fees.getFee_pay_tm().equals("")&&!fees.getCon_mon().equals("")){
						if(AddUtil.parseInt(fees.getFee_pay_tm()) > AddUtil.parseInt(fees.getCon_mon())){
			%>
							alert("납입횟수가 이용기간(개월수)보다 더 큽니다. 확인해주세요.");
							return;
			<%		}
					}	
			%>
			
			// 전자계약서 전송 시 상호+계약번호가 60자리가 넘으면 전자계약서 전송 불가
			<% if((rent_l_cd+client.getFirm_nm()).length() > 60){%>
				alert('계약번호+상호가 60자리가 넘으면 전자계약서를 전송할 수 없습니다.');
				return;
			<%}%>
			
			// 이전 발송 건 유무 체크
			var overCount = '<%=overCount%>';
			
// 			if(overCount > 0){	// 기존 발송 건이 있으면 추가 발송하지 못하도록.
// 				alert('이미 발송된 계약서가 있습니다.\n재발송을 원하실 경우 전자문서관리 메뉴에서 해당 발송 건을 폐기 후 진행하시기 바랍니다.');
// 				document.getElementById('btnSendDoc').style.display = 'none';
// 				return;
// 			}
		}
		
		if(!confirm('전송하시겠습니까?')){
			return;
		}
		
		
		fm.action = 'e_doc_send_a.jsp';
		fm.submit();
	}
	
	
</script>
</head>
<body style='margin: 0;'>
<form name='form1' action='' method='post'>
<input type='hidden' id='user_id' 			name='user_id' value='<%=user_id%>' />
<input type='hidden' id='document_st' 	name='document_st' value='<%=document_st%>' />
<input type='hidden' id='rent_l_cd' 		name='rent_l_cd' value='<%=rent_l_cd%>' />
<input type='hidden' id='rent_mng_id' 	name='rent_mng_id' value='<%=rent_mng_id%>' />
<input type='hidden' id='rent_st' 			name='rent_st' value='<%=rent_st%>' />
<input type='hidden' id='client_id' 		name='client_id' value='<%=client_id%>' />
<input type='hidden' id='client_st' 		name='client_st' value='<%=client.getClient_st()%>' />
<input type='hidden' id='doc_name' 		name='doc_name' value='' />
<input type='hidden' 							name="bus_id"	value="<%=base.getBus_id()%>">  
<input type='hidden'							name="bus_st"	value="<%=base.getBus_st()%>">

<div style='margin: 0 15px; display: inline-block; '>
	<div class='e-doc-area'>
		<h2>계약서</h2>
		<div>
			<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
			<span class='style2' style='margin-right: 10px;'>문서 구분:</span>
			<select style='font-size: 14px;' class='document_type' name='document_type' onchange='javascript: changeDocSelect(this);'>
				<option value=''>선택</option>
				<option value='1' <%if(document_st.equals("1") && document_type.equals("1")){ %>selected<%} %>>장기계약서</option>
				<option value='2' <%if(document_st.equals("1") && document_type.equals("2")){ %>selected<%} %>>계약승계계약서</option>
				<option value='3' <%if(document_st.equals("1") && document_type.equals("3")){ %>selected<%} %>>연장계약서</option>
				<option value='4' <%if(document_st.equals("1") && document_type.equals("4")){ %>selected<%} %>>월렌트계약서</option>
			</select>
		</div>
	</div>
</div>

<!-- 검색 영역 -->
<div class='doc-search-area' style='display: <%if(document_st.equals("")){%>none;<%} else{%>inline-block;<%}%>'>
	<input type='button' class='button' value='검색' onclick='javascript: openSearchPopup();'/>
</div>

<!-- 발송 구분 선택 영역 -->
<div class='send-type-area' style='margin: 10px 15px;'>
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
	<span class='style2' style='margin-right: 10px;'>발송 구분:</span>
	
	<input type='radio' id='send_mail' name='send_type' value='mail' <%if(send_type.equals("mail")){ %>checked<%} %>>
	<label for='send_mail'>메일(PC)</label>
	
	<input type='radio' id='send_kakao' name='send_type' value='talk' <%if(client.getClient_st().equals("1")){ // 법인은 메일만 발송 가능.%>disabled<%} %> <%if(send_type.equals("talk")){ %>checked<%} %>>
	<label for='send_kakao'>알림톡(Mobile)</label>
	
	<input type='radio' id='send_park' class='send_park' name='send_type' value='park' style='display: <%if( !( document_st.equals("1") && document_type.equals("4") ) ){%>none;<%} else {%> inline-block;<%}%>'  <%if(send_type.equals("park")){ %>checked<%} %>>
	<label for='send_park' class='send_park' style='display: <%if( !( document_st.equals("1") && document_type.equals("4") ) ){%>none;<%} else {%> inline-block;<%}%>'>현장</label>
</div>

<!-- 서명 구분 선택 영역_2022.04.22 서명구분 선택 안 함 -->
<%-- <div class='sign-type-area' style='margin: 10px 15px; display:<%if(document_st.equals("") && document_type.equals("")){%>none;<%}%>'>
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
	<span class='style2' style='margin-right: 10px;'>서명 구분:</span>
	
	<input type='radio' id='not_signed' name='sign_type' value='0'
		<%if(document_st.equals("1")){	// 계약서 %>
			disabled
		<%} %>
	>
	<label for='not_signed'>서명 없음</label>
	
	<input type='radio' id='certificate' name='sign_type' value='1'
		<%if(document_st.equals("1") && document_type.equals("3")){	// 연장 계약서 %>
			disabled
		<%} %>
	>
	<label for='certificate'>인증서</label>
	
	<input type='radio' id='signed_self' name='sign_type' value='2'
		<%if(document_st.equals("1") && document_type.equals("4")){	// 월렌트 계약서 %>
			disabled
		<%} %>
	>
	<label for='signed_self'>자필서명</label>
</div> --%>

<!-- 메일/알림톡 발송 내용 영역 -->
<div class='send-content-eara' style='margin: 20px 15px; display: <%if(document_st.equals("") || document_type.equals("")){%>none;<%}%>'>
	<div style="padding-bottom: 15px;">
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px"><span class='style2'>전송 내용</span>
    </div>
    <div style='margin-left: 15px;'>
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
    	<span class='style2' style='font-weight:bold; font-size: 14px;'>상호(계약번호): <%=client.getFirm_nm()%>(<%=rent_l_cd %>)</span>
    </div>
    <div style='margin-left: 15px; display: flex;'>
	    <!-- 계약서(신규, 승계, 연장) -->
	    <%if( document_st.equals("1") ){ %>
		    <%if(!document_type.equals("4")){ %>
			<div id='rent_content' style='width: 30%;'>
				<%if(!base.getUse_yn().equals("N")){ %>
				<div id='cont_content_new'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>
			      			<%if(document_type.equals("2")){ // 계약승계%>
					      		변경 임차인: <%=client.getFirm_nm()%>
				      		<%} else{%>
				      			전송
				      		<%} %>
				      	</span>
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>수신자</td>
					    		<td>&nbsp;
					    			<select name="s_mail_addr"  onChange='javascript:mail_addr_set();'>
					    				<option value=''>선택</option>
					    				<%if(!client.getCon_agnt_email().equals("")){%>
					        		    	<option value="<%=client.getCon_agnt_nm()%>||<%=client.getCon_agnt_email()%>||<%=client.getCon_agnt_m_tel()%>">[세금계산서] <%=client.getCon_agnt_email()%> <%=client.getCon_agnt_nm()%></option>
					        		    <%}%>
					        		    <%if(!site.getAgnt_email().equals("")){%>
					        		    	<option value="<%=site.getAgnt_nm()%>||<%=site.getAgnt_email()%>||<%=site.getAgnt_m_tel()%>">[지점세금계산서] <%=site.getAgnt_email()%> <%=site.getAgnt_nm()%></option>
					        		    <%}%>
					        		    <%for(int i = 0 ; i < mgr_size ; i++){
					        			CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
					        			if(!mgr_bean.getMgr_email().equals("")){%>
					        		    <option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("계약담당자")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
					        		    <%}
					        			}%>	
					    			</select>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>이름</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_nm' value='<%=mgr.getMgr_nm()%>' size='15' maxlength='20' class='text' style='IME-MODE: active' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>EMAIL</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_email' value='<%=mgr.getMgr_email()%>' size='30' maxlength='30' class='text' style='IME-MODE: inactive' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>이동전화</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_m_tel' value='<%=mgr.getMgr_m_tel()%>' size='15' maxlength='15' class='text' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>변경</td>
					            <td>&nbsp;
									<input type="checkbox" name="mgr_cng" value="Y"> 전자문서 수신자 정보를 계약담당자에 업데이트 한다.
								</td>
							</tr>
					    </table>
				    </div>
				</div>
				<%} %>
				<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){ %>
				<div id='cont_content_share' style='margin-top: 15px;'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>
				      		공동 임차인: 
				      		<%if(!client.getRepre_nm().equals("")){ %>
				      			<%=client.getRepre_nm()%>
				      		<%}else{ %>
				      			<%=client.getClient_nm()%>
				      		<%} %>
				      	</span>
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>수신자</td>
					    		<td>
					    			&nbsp;계약정보, 고객정보에 연동된 공동임차인 정보를 가져옵니다.<br>
					    			&nbsp;다른 이메일로 보내려면 아래에 직접 입력하거나 고객정보에 공동임차인 정보를 수정하세요.
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>이름</td>
					    		<td>&nbsp;
					    			<span>
					    			<%if(!client.getRepre_nm().equals("")){ %>
					    				<%=client.getRepre_nm()%>
					    			<%}else{ %>
					    				<%=client.getClient_nm()%>
					    			<%}%>
					    			</span>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>EMAIL</td>
					    		<td>&nbsp;
					    			<input type='text' name='repre_email' value='<%=client.getRepre_email()%>' size='30' maxlength='20' class='text' style='IME-MODE: inactive'/>
					    			&nbsp;&nbsp;* 이곳에 입력한 이메일은 전자계약서 전송에만 사용되며(1회성) 계약정보/고객정보의 공동임차인 이메일주소는 변경되지 않습니다.
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>이동전화</td>
					    		<td>&nbsp;
					    			<input type='text' name='repre_m_tel' value='' size='15' maxlength='15' />
					    		</td>
					    	</tr>
					    </table>
				    </div>
				</div>
				<%} %>
				<%if(document_type.equals("2")){	// 승계 계약 
					//계약승계 혹은 차종변경일때 원계약 해지내용
					Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
				
					//기존 임차인 고객관련자
					car_mgrs = a_db.getCarMgrListNew(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "Y");
					mgr_size = car_mgrs.size();	
				%>
				<div id='cont_content_sg' style='margin-top: 15px;'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>기존 임차인: <%=begin.get("FIRM_NM")%></span>
				      	<input type='hidden' name='suc_client_st' value='<%=begin.get("CLIENT_ST") %>' />
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>수신자</td>
					    		<td>&nbsp;
					    			<select name="suc_s_mail_addr"  onchange='javascript:suc_mail_addr_set();'>
					    				<option value=''>선택</option>
					    				<%for(int i = 0 ; i < mgr_size ; i++){
						        			CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
						        			if(!mgr_bean.getMgr_email().equals("")){%>
						        		    <option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("계약담당자")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
						        		    <%}
					        			}%>	
					    			</select>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>이름</td>
					    		<td>&nbsp;
					    			<input type='text' name='suc_mgr_nm' value='<%=suc_mgr.getMgr_nm()%>' size='15' maxlength='20' class='text' style='IME-MODE: active' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>EMAIL</td>
					    		<td>&nbsp;
					    			<input type='text' name='suc_mgr_email' value='<%=suc_mgr.getMgr_email()%>' size='30' maxlength='30' class='text' style='IME-MODE: inactive' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>이동전화</td>
					    		<td>&nbsp;
					    			<input type='text' name='suc_mgr_m_tel' value='<%=suc_mgr.getMgr_m_tel()%>' size='15' maxlength='15' />
					    		</td>
					    	</tr>
					    </table>
				    </div>
				</div>
				<%} %>
				<% if( !( client.getClient_st().equals("1") || client.getClient_st().equals("2") ) && !client.getRepre_nm2().equals("") ){ %>
				<div style='margin-top: 15px;'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>대표자 선택</span>
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>대표자</td>
					    		<td>&nbsp;
					    			<select name='client_repre_st'>
					    				<option value='1'>[대표자] <%= client.getClient_nm()%></option>
					    				<%if(!client.getRepre_nm2().equals("")){%><option value="2">[공동대표자] <%= client.getRepre_nm2() %></option><%} %>
					    			</select>
					    		</td>
					    	</tr>
					    </table>
				    </div>
				</div>
				<%} %>
			</div>
			<%} else { // 계약서(월렌트)%>
			<div id='month_rent_content' style='width: 30%;'>
				<%if(!base.getUse_yn().equals("N")){ %>
				<div id='cont_content_month'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>전송</span>
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>전송구분</td>
					    		<td>&nbsp;모바일</td>
					    	</tr>
					    	<tr>
					    		<td class='title' style='width: 15%;'>2회차청구방식</td>
					    		<td>&nbsp;
					    		<%if(fee_rm.getCms_type().equals("card")){%>
				      				신용카드
				      				<input type='hidden' name='cms_type' 		value='card'>
			      				<%}else if(fee_rm.getCms_type().equals("cms")){%>
				      				CMS
				      				<input type='hidden' name='cms_type' 		value='cms'>
			      				<%}else{%>
				              		<input type='radio' name="cms_type" value='card' checked>
				     				신용카드
				      			  	<input type='radio' name="cms_type" value='cms'>
				      			  	CMS 
			      			  	<%}%>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title' style='width: 15%;'>수신자</td>
					    		<td>&nbsp;
					    			<select name="s_mail_addr"  onChange='javascript:mail_addr_set();'>
					    				<option value=''>선택</option>
					    				<%if(!client.getCon_agnt_email().equals("")){%>
					        		    	<option value="<%=client.getCon_agnt_nm()%>||<%=client.getCon_agnt_email()%>||<%=client.getCon_agnt_m_tel()%>">[세금계산서] <%=client.getCon_agnt_email()%> <%=client.getCon_agnt_nm()%></option>
					        		    <%}%>
					        		    <%if(!site.getAgnt_email().equals("")){%>
					        		    	<option value="<%=site.getAgnt_nm()%>||<%=site.getAgnt_email()%>||<%=site.getAgnt_m_tel()%>">[지점세금계산서] <%=site.getAgnt_email()%> <%=site.getAgnt_nm()%></option>
					        		    <%}%>
					        		    <%for(int i = 0 ; i < mgr_size ; i++){
					        				CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
					        				if(!mgr_bean.getMgr_email().equals("")){%>
					        		    		<option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("계약담당자")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
					        		    <%}
					        			}%>
					    			</select>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>이름</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_nm' value='<%=mgr.getMgr_nm()%>' size='15' maxlength='20' class='text' style='IME-MODE: active' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>EMAIL</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_email' value='<%=mgr.getMgr_email()%>' size='30' maxlength='30' class='text' style='IME-MODE: inactive' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>이동전화</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_m_tel' value='<%=mgr.getMgr_m_tel()%>' size='15' maxlength='15' class='text' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>변경</td>
					            <td>&nbsp;
									<input type="checkbox" name="mgr_cng" value="Y"> 전자문서 수신자 정보를 계약담당자에 업데이트 한다.
								</td>
							</tr>
					    </table>
				    </div>
				</div>
				<%} %>
			</div>
			<%} %>
		<%} %>
		<div style='margin-left: 30px; display: flex; flex-direction: column; margin-top: 30px;'>
			<input type='button' class='button' style='font-size: 16px; padding: 10px; margin: 10px 0px;' value='전송' id='btnSendDoc' onclick='javascript:sendEDoc();' />
		</div>
	</div>
</div>

</form>
</body>
<script src="https://apis.google.com/js/client.js?onload=load"></script>
<script>

</script>
</html>
