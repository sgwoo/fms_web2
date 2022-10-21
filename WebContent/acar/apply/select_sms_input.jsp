<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.estimate_mng.*, acar.user_mng.*, acar.util.*, acar.common.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String content_st = request.getParameter("content_st")==null?"":request.getParameter("content_st");
	
	String rent_dt  = "";
	String reg_id = "";
	String est_nm = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	// 로그인 정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getSessionValue(request, "USER_ID");	
	String user_nm = login.getSessionValue(request, "USER_NM");
	String user_m_tel = login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}
	
	String pack_id = Long.toString(System.currentTimeMillis());
	
	String est_table = "estimate";
	
	int count = 0;
	
	if(String.valueOf(request.getParameterValues("ch_l_cd")).equals("") || String.valueOf(request.getParameterValues("ch_l_cd")).equals("null")){
		out.println("선택된 견적이 없습니다.");
		return;
	}	
	
	
	String vid[] = request.getParameterValues("ch_l_cd");
	int vid_size = vid.length;
	
	for(int i=0; i < vid_size; i++){
		String est_id = vid[i];
		
		EstiPackBean ep_bean = new EstiPackBean();
		ep_bean.setPack_id	(pack_id);
		ep_bean.setSeq		(i+1);
		ep_bean.setEst_id	(est_id);
		ep_bean.setEst_table	("estimate");
		ep_bean.setPack_st	("1"); //1-메일
		ep_bean.setReg_id	(user_id);
		ep_bean.setMemo		("");
		
		count = e_db.insertEstiPack(ep_bean);
	}
	
	// 테이블 가져오기
	est_table = e_db.getEstiPackEstTableNm(pack_id);
	
	Vector vt = e_db.getEstiPackList(pack_id, est_table);
	int vt_size = vt.size();
	
	for (int i=0; i<vt_size; i++) {
    	Hashtable ht = (Hashtable)vt.elementAt(i);
		if (i==0) {
			rent_dt = String.valueOf(ht.get("RENT_DT"));
			reg_id = String.valueOf(ht.get("REG_ID"));
		}
		
		if (est_nm.equals("")) 	est_nm 	= String.valueOf(ht.get("EST_NM"));
	}
	
	
	// 선택한 견적이 같은 고객의 견적인지를 체크
	int result_count = 0;
	boolean isSame = true;
	String[] str_arr = new String[vid_size];
	String result_str = "";
	
	for (int i=0; i < vid_size; i++) {
		String est_id = vid[i];
		e_bean = e_db.getEstimateCase(est_id);
		str_arr[i] = e_bean.getEst_nm();
	}
	
	for (int i = 0; i < str_arr.length-1; i++) {
		if (!str_arr[i].equals(str_arr[i+1])) {
			isSame = false;
		}
	}
	
	String est_tel = e_bean.getEst_tel();
	
	if ( content_st.equals("sh_fms")) {
		result_str = "1";
	} else {
		if (isSame == false) {			
			result_str = "0";
		} else {
			result_str = "1";
		}
	}
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>견적서 문자보내기</title>
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0"> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
$('document').ready(function() {
	$("#manager_nm").val($("#manager_id").children("option:selected").text());
	$("#manager_id").change(function(){
        var change_val = $(this).val();
        var change_txt = $(this).children("option:selected").text();
        $("#manager_nm").val(change_txt);
	});
});
</script>
<style type="text/css">
<!--
body.general {
	background-color:#FFFFFF;
	font-family: 굴림, Gulim, AppleGothic, Seoul, Arial;
	font-size: 9pt;
}
.style2 {
	color: #515150;
	font-weight: bold;
	font-size:9pt;
}
-->
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	margin-bottom: 0px;
	background-color:#f4f3f3;
	font-family: 돋움; font-size: 9pt;
}
.title_font {
	color: #0d1b5c;
    font-weight: bold;
    font-size: 22px;
    font-family: 맑은고딕,sans-serif;
    padding-left: 30px;
}
.rec_font {
	color: #b0232a;
    font-weight: bold;
    font-size: 18px;
    font-family: 맑은고딕,sans-serif;
    padding-left: 30px;
}
.left_padd {
	padding-left: 40px;
}
-->
</style>
<script>
<!--
<%if (result_str == "0") {%>
		alert("선택한 견적서가 같은 고객일 경우에만 선택문자발송이 가능 합니다.");
		window.open("about:blank","_self").close();
<%} else if (vid_size > 5) {%>
		alert("한번에 발송가능한 견적은 최대 5건 입니다.");
		window.open("about:blank","_self").close();
<%}%>

	function EnterDown(){
		var keyValue = event.keyCode;
		var fm = document.form1;
		var addr = fm.est_m_tel.value;

		if (keyValue =='13') {
			send_mail();
		}
	}
	
	function popupLink(link, popHeight, popWidth){ 
		var winHeight = document.body.clientHeight;	// 현재창의 높이
		var winWidth = document.body.clientWidth;	// 현재창의 너비
		var winX = window.screenX || window.screenLeft || screen.width || 0; // 현재창의 x좌표 
		var winY = window.screenY || window.screenTop || screen.height || 0;	// 현재창의 y좌표 

		var popX = winX + (winWidth - popWidth)/2;
		var popY = winY + (winHeight - popHeight)/2;
		window.open(link,"popup","width=" + popWidth + "px,height=" + popHeight + "px,top=" + popY + ",left=" + popX + ',scrollbars=yes, status=yes');
	}

	// 견적서 문자 보내기
	function send_mail(){
		var fm = document.form1;
		var est_m_tel = fm.est_m_tel.value;
		/* var manager_phone = fm.manager_phone.value; */
		var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
				
		if (est_m_tel=="") {
			alert("수신번호를 입력해주세요!");
			fm.est_m_tel.focus();
			return;
		} 
		/* else if (manager_phone=="") {
			alert("발신번호를 입력해주세요!");
			fm.manager_phone.focus();
			return;
		} */ 
		/* else if (!(regExp.test(est_m_tel))) {
			alert("수신번호는 '-'를 포함한 000-0000-0000 과 같은 형식으로\n입력해주세요");
			fm.est_m_tel.focus();
			return;
		} else if (!(regExp.test(manager_phone))) {
			alert("발신번호는 '-'를 포함한 000-0000-0000 과 같은 형식으로\n입력해주세요");
			fm.manager_phone.focus();
			return;
		} */
		
		if(!confirm('이 번호로 문자를 발송하시겠습니까?')){	return; }

		fm.action = "send_sms.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
//-->
</script>
</head>

<body> <!-- onLoad="document.form1.est_m_tel.focus();" -->
<form name="form1" method="post" action="" onsubmit="return false;">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="u_nm" id="u_nm" value="<%=user_nm%>">
<input type="hidden" name="u_mt" id="u_mt" value="<%=user_m_tel%>">
<input type="hidden" name="pack_id" value="<%=pack_id%>">
<input type="hidden" name="manager_nm" id="manager_nm" value="">
<input type="hidden" name="select_sms" value="select_sms">

<table width="440" border="0" cellspacing="0" cellpadding="0" style="margin: 0 auto;">
    <tr>
	<td bgcolor="#9acbe1" height="5"></td>
    </tr>
    <tr>
	<td height="20"></td>
    </tr>
    <tr>
        <td><font class="title_font">견적서 문자보내기</font></td>
    </tr>
    <tr>
	<td height="10"></td>
    </tr>
    <tr>
    	<td align="center">
    	    <table width="392" border="0" cellspacing="0" cellpadding="0" background="/acar/images/center/mail_bg.gif">
	    		<tr>
	    		    <td><img src=/acar/images/center/mail_up.gif></td>
	    		</tr>
	    		<tr>
	    		    <td height=20></td>
	    		</tr>
	    		<tr>
	    		    <td align=left><font class="rec_font">수신</font></td>
	    		</tr>
	    		<tr>
	    		    <td height=7></td>
	    		</tr>
	    		<tr>
	    		    <td align=left>
	    		    	<img class="left_padd" src=/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>수신번호 &nbsp;</span>
	    		    	<input type="text" name="est_m_tel" size="30" value="<%=est_tel%>" onKeydown="javascript:EnterDown()" value="">
	    		    </td>
	    		</tr>
	    		<tr>
	    		    <td height=30></td>
	    		</tr>
	    		<tr>
	    		    <td align=left><font class="rec_font">선택견적</font></td>
	    		</tr>
	    		<tr>
	    		    <td height=7></td>
	    		</tr>
	    		<tr>
	    			<td>
						<table width="320" border="0" cellspacing="1" cellpadding="0" bgcolor="#d6d6d6" align="center">
							<tr>
						    	<td bgcolor="#f2f2f2" height="30" width=70% align="center">
						    		<span style="font-family:nanumgothic;font-size:12px;">선택 견적내용</span>
						    	</td>
								<td bgcolor="#f2f2f2" align="center">
									<span style="font-family:nanumgothic;font-size:12px;">견적서 보기</span>
								</td>
					   		</tr>
					   		<%
						   		 String esti_content_a = "";
								 int ss_content = 0;
								
								 for(int i=0; i<vt_size; i++){
								
								 	Hashtable ht = (Hashtable)vt.elementAt(i);							
									String esti_content_b = String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME"))+" "+String.valueOf(ht.get("GOOD_NM"))+" "+String.valueOf(ht.get("A_B"))+"개월";
									String car_full_name = String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME"));
									
									String str = String.valueOf(ht.get("GOOD_NM"));
									String[] split_str = str.split(" ");
									String gubun1 = split_str[0];
									String gubun2 = split_str[1];
									
									int fee_s = AddUtil.parseInt(String.valueOf(ht.get("FEE_S_AMT")));
									int fee_v = AddUtil.parseInt(String.valueOf(ht.get("FEE_V_AMT")));
									int rent_fee = fee_s + fee_v;
									
									String url = "";
									if(content_st.equals("sh_fms_ym")){ //연장견적서에서는 연장견적 문자가 발송되게 수정 (20180919)
										url = "http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms_ym.jsp?est_id=" + String.valueOf(ht.get("EST_ID")) + "&acar_id=" + reg_id + "&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=" + content_st;
									} else if (content_st.equals("sh_fms")) { //재리스견적서에서는 재리스견적 문자가 발송되게 수정 (20180919)
										url = "http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms.jsp?est_id=" + String.valueOf(ht.get("EST_ID")) + "&acar_id=" + reg_id + "&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=" + content_st;
									} else {										
										if(String.valueOf(ht.get("PRINT_TYPE")).equals("6")){
											url = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_eh_all.jsp?est_id=" + String.valueOf(ht.get("EST_ID")) + "&acar_id=" + reg_id + "&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=" + content_st;
										}else{
											url = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id=" + String.valueOf(ht.get("EST_ID")) + "&acar_id=" + reg_id + "&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=" + content_st;
										}
									}
									
									if (esti_content_a.equals(esti_content_b)) {
										ss_content++;
									} else {
										ss_content = 0;
									}
	
									esti_content_a = esti_content_b;
					   		%>
					   		<tr>
		                        <td style="background-color: white;">&nbsp;
		                        	<span style="font-family:nanumgothic; font-size:12px;"><%=esti_content_b%> 견적 <%if(ss_content>0){%>(<%=ss_content+1%>)<%}%></span>
		                        	<input type="hidden" name="a_est_id" value="<%=ht.get("EST_ID")%>">
		                        	<input type="hidden" name="car_name" value="<%=car_full_name%>">
		                        	<input type="hidden" name="car_amount" value="<%=ht.get("O_1")%>"><!-- 차량가격 -->
		                        	<input type="hidden" name="gubun1" value="<%=gubun1%>"><!-- 장기렌트/ 리스 -->
		                        	<input type="hidden" name="gubun2" value="<%=gubun2%>"><!-- 기본식/ 일반식 -->
		                        	<input type="hidden" name="month" value="<%=ht.get("A_B")%>"><!-- 대여기간 -->
		                        	<input type="hidden" name="deposit_rate" value="<%=ht.get("RG_8")%>"><!-- 보증금% -->
		                        	<input type="hidden" name="distance" value="<%=ht.get("AGREE_DIST")%>"><!-- 운행거리 -->
		                        	<input type="hidden" name="rent_fee" value="<%=rent_fee%>"><!-- 월 대여료 -->
		                        	<input type="hidden" name="content_st" value="<%=content_st%>"><!-- 화면 구분 -->
		                        </td>
		                        <td bgcolor=ffffff align=center>
		                        	<span style="font-family:nanumgothic; font-size:12px;">
		                        		<%-- <a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id=<%=ht.get("EST_ID")%>&acar_id=<%=reg_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp" title='견적서 보기' onclick="popupLink(0, 800, 800)">견적서 보기</a> --%> <!-- window.open(this.href,'_black','left=50, top=50, width=800, height=800'); return false; -->
		                        		<%if (String.valueOf(content_st).equals("sh_fms_ym")) {%>
	                        				<span onclick="popupLink('http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms_ym.jsp?est_id=<%=ht.get("EST_ID")%>&acar_id=<%=reg_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=<%=content_st%>', '800', '800')" style="text-decoration: underline; color: blue; cursor: pointer;">견적서 보기</span> 
		                        		<%} else if (String.valueOf(content_st).equals("sh_fms")) {%>
	                        				<span onclick="popupLink('http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms.jsp?est_id=<%=ht.get("EST_ID")%>&acar_id=<%=reg_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=<%=content_st%>', '800', '800')" style="text-decoration: underline; color: blue; cursor: pointer;">견적서 보기</span>
		                        		<%} else {%>
			                        		<%if (String.valueOf(ht.get("PRINT_TYPE")).equals("6")) {%>
		                        				<span onclick="popupLink('http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_eh_all.jsp?est_id=<%=ht.get("EST_ID")%>&acar_id=<%=reg_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=<%=content_st%>', '800', '800')" style="text-decoration: underline; color: blue; cursor: pointer;">견적서 보기</span> 
			                        		<%} else {%>
		                        				<span onclick="popupLink('http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id=<%=ht.get("EST_ID")%>&acar_id=<%=reg_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=<%=content_st%>', '800', '800')" style="text-decoration: underline; color: blue; cursor: pointer;">견적서 보기</span> <!-- window.open(this.href,'_black','left=50, top=50, width=800, height=800'); return false; -->
			                        		<%}%>
		                        		<%}%>
		                        		<input type="hidden" name="esti_link" value="<%=ShortenUrlGoogle.getShortenUrl(url)%>">	                        		
					                </span>
			                	</td>
	                        </tr>
							<%}%>
						</table>
	    		    </td>
	    		</tr>
	    		<tr>
	    		    <td height=30></td>
	    		</tr>
	    		<tr>
	    		    <td align=left><font class="rec_font">발신</font></td>
	    		</tr>
	    		
	    		<tr>
	    		    <td height=7></td>
	    		</tr>
	    		<tr>
	    		    <td align=left>
	    		    	<img class="left_padd" src=/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2 style="padding-right: 23px;">담당자</span>
	    		    	
	    		    	<select name='manager_id' id="manager_id" class="default">            
	                        <option value="">미지정</option>
	        <% if(user_size > 0){
					for(int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i);
			%>
	          			    <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
	          		<% }
			}%>
						</select>
	    		    </td>
	    		</tr>
	    		<tr>
	    		    <td height=10></td>
	    		</tr>
	    		<tr>
	    		    <td align=left>
	    		    	<img class="left_padd" src=/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2 style="padding-right: 23px;">문자내 담당자 표시여부</span>
	    		    	<input type="radio" name="manager_use" id="use_y" value="Y" checked><label for='use_y' style="font-family:nanumgothic; font-size:12px;">표시</label>&nbsp;
						<input type="radio" name="manager_use" id="use_n" value="N"><label for='use_n' style="font-family:nanumgothic; font-size:12px;">미표시</label>
	    		    </td>
	    		</tr>
				<tr>
	    		    <td height=20></td>
	    		</tr>
	    		<tr>
	    		    <td><img src=/acar/images/center/mail_dw.gif></td>
	    		</tr>
    	    </table>
    	</td>
    </tr>
    <tr>
    	<td height=10></td>
    </tr>
    <tr>
    	<td align=center><a href="javascript:send_mail();"><img src=/acar/images/center/mail_btn_send.gif border="0" alt='보내기'></a></td>
    </tr>   
</table>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>

</body>
</html>

