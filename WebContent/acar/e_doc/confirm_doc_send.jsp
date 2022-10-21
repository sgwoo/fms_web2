<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.fee.*, acar.client.*, acar.cont.*" %>
<%@ page import="acar.cls.*, acar.car_mst.*, acar.car_register.*, acar.insur.*, acar.estimate_mng.*, acar.kakao.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	
	// 로그인 정보
	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_m_tel 	= login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}

    // 영업담당자 리스트
    Vector users = at_db.getUserList("", "", "EMP", "Y");
    int user_size = users.size();
    
    String document_st 		= request.getParameter("document_st")		== null ? "" : request.getParameter("document_st");		// 문서 구분. 대분류.
    String document_type 	= request.getParameter("document_type")	== null ? "" : request.getParameter("document_type");		// 계약서 구분
    String rent_mng_id		= request.getParameter("rent_mng_id")		== null ? "" : request.getParameter("rent_mng_id");
   	String rent_l_cd 			= request.getParameter("rent_l_cd")			== null ? "" : request.getParameter("rent_l_cd");
   	String rent_st 				= request.getParameter("rent_st")				== null ? "" : request.getParameter("rent_st");
   	String status 				= request.getParameter("status")				== null ? "" : request.getParameter("status");
   	String client_id 			= request.getParameter("client_id")			== null ? "" : request.getParameter("client_id");
   	String car_st 				= request.getParameter("car_st")				== null ? "" : request.getParameter("car_st");
   	String mgr_nm 			= request.getParameter("mgr_nm")			== null ? "" : request.getParameter("mgr_nm");			// 수신자 이름
	String mgr_email 		= request.getParameter("mgr_email")		== null ? "" : request.getParameter("mgr_email");		// 수신자 메일 계정
	String mgr_m_tel 		= request.getParameter("mgr_m_tel")		== null ? "" : request.getParameter("mgr_m_tel");		// 수신자 연락처
	String view_amt 			= request.getParameter("view_amt")			== null ? "" : request.getParameter("view_amt");		
	String pay_way 			= request.getParameter("pay_way")			== null ? "" : request.getParameter("pay_way");		
	String send_type			= request.getParameter("send_type")			== null ? "" : request.getParameter("send_type");
	
  	//계약기본정보
  	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
  	
  	//계약기타정보
  	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
  	
  	//고객정보
  	ClientBean client = al_db.getNewClient(client_id);
  	
  	//차량기본정보
  	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
  	
  	//자동차기본정보
  	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
  	
  	//지점정보
  	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
  	
  	//계약담당자
  	CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "계약담당자");
  	
  	//잔가변수NEW
  	EstiJgVarBean ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
  	String a_e = ej_bean.getJg_a();
 	
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
table td{
	padding: 5px;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
	
	// 검색 팝업
	function openSearchPopup(){
		var document_st = document.getElementById('document_st').value;
				
		window.open('e_doc_search.jsp?document_st='+document_st, 'SEARCH', 'left=10, top=10, width=1000, height=800, scrollbars=yes, status=yes, resizable=yes')
	}
	
	// 문서 선택 시 처리
	function chooseEdoc(el){
		
		var fm = document.form1;
		
		var confirmDocs = ['2', '4', '13'];
		var document_st = '';
		var document_type = el.value;
		
		if( confirmDocs.indexOf(document_type) >= 0){
			document_st = '3';
		} else {
			document_st = '4';
		}
		
		// 문서 구분 값 세팅
		fm.document_st.value = document_st;
		
		// 문서명 값 세팅
		fm.doc_name.value = el.parentNode.nextElementSibling.firstElementChild.innerHTML
		
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
	
	// 전자 문서 전송
	function sendEDoc(){
		var fm = document.form1;
		
		var document_type = fm.document_type.value;
		var document_st = fm.document_st.value;
		// 문서 구분 값 없을 때 처리
		if(document_st == ''){
			var confirmDocs = ['2', '4', '13'];
			if( confirmDocs.indexOf(document_type) >= 0){
				document_st = '3';
			} else {
				document_st = '4';
			}
			fm.document_st.value = document_st;
		}
		
		
		if(fm.rent_l_cd.value == ''){
			alert('계약 건이 선택되지 않았습니다.');
			return;
		}
		
		var send_type = fm.send_type.value;
		if(send_type == ''){
			alert('발송 구분을 선택해 주세요.');
			return;
		}
		
		if(document_st == '' && document_type == ''){
			alert('문서를 선택해 주세요.');
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
			
		} else{		// 발송 구분: 알림톡
			var mgr_m_tel = fm.mgr_m_tel.value;
			if( mgr_m_tel == '' ){
				alert('휴대폰 번호를 입력해 주세요.');
				fm.mgr_m_tel.focus();
				return;
			}
			
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
<input type='hidden' id='document_st' 	name='document_st' value='' />
<input type='hidden' id='rent_l_cd' 		name='rent_l_cd' value='<%=rent_l_cd%>' />
<input type='hidden' id='rent_mng_id' 	name='rent_mng_id' value='<%=rent_mng_id%>' />
<input type='hidden' id='rent_st' 			name='rent_st' value='<%=rent_st%>' />
<input type='hidden' id='client_id' 		name='client_id' value='<%=client_id%>' />
<input type='hidden' id='client_st' 		name='client_st' value='<%=client.getClient_st()%>' />
<input type='hidden' id='doc_name' 		name='doc_name' value='' />

<div class='e-doc-area' style='margin: 10px 15px;'>
	<h2>확인서/요청서</h2>
</div>

<div class='doc-search-area' style='margin: 15px 15px;'>
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
	<span class='style2' style='margin-right: 10px;'>계약 선택:</span>
	<input type='button' class='button' style='padding: 5px 15px;' value='검색' onclick='javascript: openSearchPopup();'/>
</div>

<!-- 발송 구분 선택 영역 -->
<div class='send-type-area' style='margin: 15px 15px;'>
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
	<span class='style2' style='margin-right: 10px;'>발송 구분:</span>
	
	<input type='radio' id='send_mail' name='send_type' value='mail' <%if(send_type.equals("mail")){ %>checked<%} %>>
	<label for='send_mail'>메일(PC)</label>
	
	<input type='radio' id='send_kakao' name='send_type' value='talk' <%if(send_type.equals("talk")){ %>checked<%} %>>
	<label for='send_kakao'>알림톡(Mobile)</label>
</div>

<%if(!rent_mng_id.equals("") && !rent_l_cd.equals("") ){%>
<div class='doc-select-area' style='margin: 15px 15px;'>
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
	<span class='style2' style='margin-right: 10px;'>문서 구분</span>
	
	<div style='background-color: #b0baec; width: 40%; margin: 10px 15px;'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
			<tr>
				<td class='title' style='width: 10%;'>선택</td>
				<td class='title' style='width: 90%;'>문서명</td>
			</tr>
			<tr>
				<td style='text-align: center;'>
					<input type='radio' name='document_type' value='1' onclick="javascript:chooseEdoc(this);" <% if(document_type.equals("") || document_type.equals("1")){ %>checked<% } %>/>
				</td>
				<td>
					<span class='doc-name'>자기차량손해확인서</span>
				</td>
			</tr>
			<tr>
				<td style='text-align: center;'>
					<input type='radio' name='document_type' value='2' onclick="javascript:chooseEdoc(this);" <% if(document_type.equals("1")){ %>checked<% } %> />
				</td>
				<td>
					<span class='doc-name'>자동차 대여이용 계약사실 확인서</span>
					(대여료/보증금 <input type="radio" name="view_amt" value="N" <% if( view_amt.equals("") || view_amt.equals("N") ){ %>checked<% } %>>미표시 
					<input style='margin-left: 10px;' type="radio" name="view_amt" value="Y" <% if( view_amt.equals("Y") ){ %>checked<% } %>>표시)
				</td>
			</tr>
			<tr>
				<td style='text-align: center;'>
					<input type='radio' name='document_type' value='3' onclick="javascript:chooseEdoc(this);" <% if(document_type.equals("3")){ %>checked<% } %> />
				</td>
				<td>
					<span class='doc-name'>자동차보험 관련 특약 약정서</span>
				</td>
			</tr>
			<tr>
				<td style='text-align: center;'>
					<input type='radio' name='document_type' value='4' onclick="javascript:chooseEdoc(this);" <% if(document_type.equals("4")){ %>checked<% } %> />
				</td>
				<td>
					<span class='doc-name'>자동차 장기대여 대여료의 결제수단 안내</span>
					(<input type="radio" name="pay_way" value="ARS" <% if( pay_way.equals("") || pay_way.equals("ARS") ){ %>checked<% } %>>ARS 
					<input style='margin-left: 10px;' type="radio" name="pay_way" value="visit" <% if( pay_way.equals("visit") ){ %>checked<% } %>>방문)
				</td>
			</tr>
			<% if(AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){ %>
				<% if(client.getClient_st().equals("1") && !base.getCar_mng_id().equals("")){ %>
				<tr>
					<td style='text-align: center;'>
						<input type='radio' name='document_type' value='5' onclick="javascript:chooseEdoc(this);" <% if(document_type.equals("5")){ %>checked<% } %> />
					</td>
					<td>
						<span class='doc-name'>업무전용자동차보험 가입/미가입 신청서(법인사업자 고객용)</span>
					</td>
				</tr>
				<% } %>
				<% if(!client.getClient_st().equals("1") && !client.getClient_st().equals("2") && !base.getCar_mng_id().equals("")){ %>
		        <tr>
		        	<td style='text-align: center;'>
						<input type='radio' name='document_type' value='8' onclick="javascript:chooseEdoc(this);" <% if(document_type.equals("8")){ %>checked<% } %> />
					</td>
		        	<td>
		        		<span class='doc-name'>업무전용자동차보험 가입/미가입 신청서(개인사업자 고객용)</span>
		        	</td>
		        </tr>
				<% } %>
			<% } %>
			<%	if(!client.getClient_st().equals("1")){%>
			<tr>
	        	<td style='text-align: center;'>
					<input type='radio' name='document_type' value='12' onclick="javascript:chooseEdoc(this);" <% if(document_type.equals("12")){ %>checked<% } %> />
				</td>
	        	<td>
	        		<span class='doc-name'>CMS자동이체신청서(개인/개인사업자 고객용)</span>
	        	</td>
	        </tr>
			<% } else {%>
			<tr>
	        	<td style='text-align: center;'>
					<input type='radio' name='document_type' value='13' onclick="javascript:chooseEdoc(this);" <% if(document_type.equals("13")){ %>checked<% } %> />
				</td>
	        	<td>
	        		<span class='doc-name'>CMS자동이체신청서(법인 고객용)</span> - 팩스회신
	        	</td>
	        </tr>
			<% } %>
		</table>
	</div>
</div>
<%} %>


<!-- 메일/알림톡 발송 내용 영역 -->
<%if(!rent_mng_id.equals("") && !rent_l_cd.equals("") ){%>
<div class='send-content-eara' style='margin: 20px 15px;'>
	<div style="padding-bottom: 15px;">
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px"><span class='style2'>전송 내용</span>
    </div>
    <div style='margin-left: 15px; display: flex;'>
	    <!-- 계약서(신규, 승계, 연장) -->
			<div id='rent_content' style='width: 40%;'>
				<%if(!base.getUse_yn().equals("N")){ %>
				<div id='cont_content_new'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span class='style2' style='font-weight:bold; font-size: 14px;'>상호(계약번호): <%=client.getFirm_nm()%>(<%=rent_l_cd %>)</span>
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title'>상호</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_nm' value='<%=client.getFirm_nm()%>' size='30' maxlength='20' class='text' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>EMAIL</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_email' value='<%=mgr_email%>' size='30' maxlength='30' class='text' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>이동전화</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_m_tel' value='<%=mgr_m_tel%>' size='30' maxlength='15' class='text' />
					    		</td>
					    	</tr>
					    </table>
				    </div>
				</div>
				<%} %>
			</div>
		<div style='margin-left: 30px; display: flex; flex-direction: column; margin-top: 30px;'>
			<input type='button' class='button' style='font-size: 16px; padding: 10px; margin: 10px 0px;' value='전송' id='btnSendDoc' onclick='javascript:sendEDoc();' />
		</div>
	</div>
</div>
<%} %>
</form>
</body>
<script src="https://apis.google.com/js/client.js?onload=load"></script>
<script>

</script>
</html>
