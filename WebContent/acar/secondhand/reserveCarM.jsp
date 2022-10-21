<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*" %>
<jsp:useBean id="shBn" class="acar.secondhand.SecondhandBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 			= request.getParameter("seq")==null?"":request.getParameter("seq");
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");	
	String cust_tel 	= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");	
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function regReserveCar(gubun){
		fm = document.form1;
		
		if(fm.cust_nm.value=='' || fm.cust_tel.value=='') { alert('고객명 및 연락처를 입력하십시오.'); return; }
		<%if(from_page.equals("/acar/secondhand/secondhand_sc.jsp") &&situation.equals("2")){%>
			//if(fm.cust_sms_yn.value=='Y') {
			if(fm.cust_sms_yn.checked == true) {
				fm.cust_sms_y.value = 'YS';
			}
		<%}%>
		<%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")&&situation.equals("2")){%>
			//if(fm.cust_sms_yn.value=='Y') {
			if(fm.cust_sms_yn.checked == true) {
				if(fm.sms_msg.value!='' && fm.sms_msg2.value=='') { alert('계약방문시 준비물 안내문자는 방문장소도 선택하십시오.'); return; }
				fm.cust_sms_y.value = 'YM';
			}
		<%}%>			
		fm.gubun.value = gubun;
		if(!confirm("수정 하시겠습니까?"))	return;
		fm.action = "reserveCarM_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
function SendSms(){
	var fm = document.form1;
	
	if(fm.cust_nm.value=='' || fm.cust_tel.value=='') { alert('고객명 및 연락처를 입력하십시오.'); return; }
	<%if(from_page.equals("/acar/secondhand/secondhand_sc.jsp")){%>
		if(fm.sms_msg2.value=='') { alert('계약방문시 주차장 안내문자를 선택하십시오.'); return; }
	<%}%>
	<%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>
		if(fm.sms_msg.value=='' && fm.sms_msg2.value=='') { alert('계약방문시 준비물 안내문자를 선택하십시오.'); return; }
		if(fm.sms_msg.value!='' && fm.sms_msg2.value=='') { alert('계약방문시 준비물 안내문자는 방문장소도 선택하십시오.'); return; }
	<%}%>

	if(!confirm('문자를 전송 하시겠습니까?')){	return;	}
	
	fm.gubun.value = 'sms';
	
	fm.action = "reserveCar_iu.jsp";
	fm.target = "i_no";
	fm.submit();
}	
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="damdang_id" value="<%=damdang_id%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="cust_sms_y" value="">
<input type="hidden" name="situation" value="<%=situation%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량예약 메모수정</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 ></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td width="20%" class=title>진행상황</td>
                    <td width="80%">&nbsp;
        			<%if (situation.equals("0")) {%>
        				상담중
        			<%} else if (situation.equals("2")) {%>
        				계약확정
        			<%}%>
      		    	</td>
                </tr>
                <tr> 
                    <td class=title>고객명</td>
                    <td>&nbsp;<input type="text" name="cust_nm" value="<%=cust_nm%>" size="30" class=text style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class=title>고객연락처</td>
                    <td>&nbsp;<input type="text" name="cust_tel" value="<%=cust_tel%>" size="15" class=text style='IME-MODE: active'></td>
                </tr>                
                <tr> 
                    <td class=title>메모</td>
                    <td>&nbsp;<textarea name="memo" cols="48" rows="6" style="IME-MODE:ACTIVE"><%=memo%></textarea></td>
                </tr>
                <%if(situation.equals("2")){//계약확정%>
                <tr> 
                    <td class=title>안내문자</td>
                    <td>&nbsp;<input type="checkbox" name="cust_sms_yn" value="Y"> 발송
                        <br>&nbsp;(위 고객명과 고객연락처에 기재된 정보로 발송합니다.)
                    </td>
                </tr>                
                <%}%>
            </table>
        </td>
    </tr>
    <!--
    <tr>  
        <td>* 메모에 고객명과 고객연락처를 꼭 입력하십시오.
	    </td>	
    </tr>	
    -->
    <tr>  
        <td align="right">
	    	<a href="javascript:regReserveCar('memo');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	    </td>	
    </tr>   
    <tr> 
        <td><hr></td>
    </tr>   
     <%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%> 
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트 계약방문시 준비물 안내문자</span></td>
    </tr>    
    <tr> 
        <td class=line2 ></td>
    </tr>
    <tr> 
        <td class="line">
        	<table border="0" cellspacing="1" cellpadding=0 width=100%>
        		<tr>                     
                    <td align='center'>
                    	<select name='sms_msg'>
	                        <option value="">================선택================</option>
							<option value="본인명의 신용카드(체크카드 불가), 운전면허증">일반개인/본인방문/본인만 운전</option>
							<option value="본인명의 신용카드(체크카드 불가), 운전면허증, 추가운전자(배우자) 면허증 사본, 가족관계 증명서류">일반개인/본인방문/추가운전자(배우자) 있는경우</option>
							<option value="">------------------------------------------------------------</option>
							<option value="본인명의 신용카드(체크카드 불가), 운전면허증, 사업자 사본">개인사업자/본인방문/본인만 운전</option>
							<option value="본인명의 신용카드(체크카드 불가), 운전면허증, 사업자 사본, 추가운전자 [건강보험 자격확인서], 추가운전자 면허증사본">개인사업자/본인방문/추가운전자 있는경우</option>
							<option value="개인사업자 명의 신용카드(체크카드는 불가), 계약자(개인사업자) 운전면허증 사본, 사업자 사본, 운전자 [건강보험 자격확인서], 운전자 면허증">개인사업자/직원방문/계약자 운전자 여부 상관없이</option>
							<option value="">------------------------------------------------------------</option>
							<option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 대표자 개인카드 [체크카드 불가], 대표이사 운전면허증, 사업자 사본">법인/대표자방문/본인만 운전</option>
							<option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 대표자 개인카드 [체크카드 불가], 대표이사 운전면허증, 사업자 사본, 추가운전자 [건강보험 자격확인서], 추가운전자 면허증사본">법인/대표자방문/추가운전자 있는경우</option>
							<option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 법인 임직원 개인카드 [체크카드 불가], 사업자 사본, 방문자 [건강보험 자격확인서], 방문자 운전면허증">법인/직원방문/방문자만 운전</option>
							<option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 법인 임직원 개인카드 [체크카드 불가], 사업자 사본, 방문자 [건강보험 자격확인서], 방문자 운전면허증, 추가운전자 [건강보험 자격확인서], 추가운전자 면허증사본">법인/직원방문/추가운전자 있는경우</option>
                       	</select>
					</td>
                </tr>                
            </table>
        </td>
    </tr>
      <%}%>        
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td>
	        <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>
	        <%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>
	       	월렌트 
	       	<%}%>
	       	 <%if(from_page.equals("/acar/secondhand/secondhand_sc.jsp")){%>
	       	재렌트 
			<%}%>
			계약방문시 주차장 안내문자</span>
		</td>
    </tr>    
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>                                
		        <tr>
                    <td align='center'>
                    	<select name='sms_msg2'>
                        	<option value="">================선택================</option>
						    <!--<option value="목동주차장">목동주차장:한마음 공영 주차장(서문출입구 직전 20m)</option>-->
							<option value="영등포주차장">영등포주차장:영등포 영남주차장</option>
						    <option value="부산주차장1">부산주차장1:부산지점 하이트빌딩 3층</option>
							<option value="부산주차장2">부산주차장2:웰메이드오피스텔 지하1층 주차장</option>
						    <!-- <option value="대전주차장1">대전주차장1:금호자동차공업사 2층</option> -->
							<option value="대전주차장2">대전주차장:(주)현대카독크 2층</option>
						    <option value="대구주차장">대구주차장:(주)성서현대정비센터</option>
						    <option value="광주주차장">광주주차장:상무1급자동차공업사</option>
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
        <td align="right">        	
	        <%if(!auth_rw.equals("1")){%>
	          <a href="javascript:SendSms()"><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>		        
	        <%}%>
	    </td>	
    </tr>      
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
