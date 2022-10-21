<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn" class="acar.secondhand.SecondhandBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String ret_dt 		= request.getParameter("ret_dt")==null?"":request.getParameter("ret_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "06", "01", "04");	
	
	String reg_dt = AddUtil.getDate();
	
	ret_dt = AddUtil.ChangeString(ret_dt);
	reg_dt = AddUtil.ChangeString(reg_dt);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//담당자 리스트
	Vector mngs = c_db.getUserList("", "", "EMP");
	int user_size = mngs.size();
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	Vector sr = shDb.getShResList(car_mng_id);
	int sr_size = sr.size();
	
	int sh_res_reg_chk = 0;
	for (int i = 0 ; i < sr_size ; i++) {
		Hashtable sr_ht = (Hashtable)sr.elementAt(i);
		if (String.valueOf(sr_ht.get("SITUATION")).equals("0") || String.valueOf(sr_ht.get("SITUATION")).equals("2")) {
			sh_res_reg_chk++;
		}
	}
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
$(document).ready(function(){
	var carName = $(opener.document).find("#car_name").val();
	var regCode = $(opener.document).find("#reg_code").val();
	
	$('#car_name').val(carName);
	$('#reg_code').val(regCode);
})
</script>
<script language="JavaScript">
<!--
function regReserveCar(gubun){
	fm = document.form1;
	fm.gubun.value = gubun;
	
	<%for(int i = 0 ; i < sr_size ; i++){
		Hashtable sr_ht = (Hashtable)sr.elementAt(i);%>
		if('<%=sr_ht.get("DAMDANG_ID")%>' == fm.damdang_id.value) { alert('기등록자는 입력할 수 없습니다.'); return;}
	<%}%>	
	
	if(fm.cust_nm.value=='' || fm.cust_tel.value=='') { alert('고객명 및 연락처를 입력하십시오.'); return; }
	if(fm.cust_tel.value.replace(/-/gi,'').length < 9){	alert('고객연락처를 다시 입력하십시오.(숫자9자리이상)');	return;	}
	
	<%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>
	if(fm.situation.value == '2' && fm.sms_add.checked == true && fm.sms_msg.value=='') { alert('계약방문시 준비물 안내문자를 선택하십시오.'); return; }
	if(fm.situation.value == '2' && fm.sms_add.checked == true && fm.sms_msg.value!='' && fm.sms_msg2.value=='') { alert('계약방문시 준비물 안내문자는 방문장소도 선택하십시오.'); return; }
  <%}%>
  
  <%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")||from_page.equals("/acar/secondhand/secondhand_sc.jsp")){%>
	if(fm.situation.value == '2' && fm.sms_add2.checked == true && fm.sms_msg2.value=='') { alert('계약방문시 주차장 안내문자를 선택하십시오.'); return; }
  <%}%>
  
	if(gubun=="i"){
		if(!confirm("등록 하시겠습니까?"))	return;
		
	}else{
		if(!confirm("수정 하시겠습니까?"))	return;
	}
	fm.action = "reserveCar_iu.jsp";
	fm.target = "i_no";
	fm.submit();
}

function SendSms(){
  
	var fm = document.form1;
	
	if(fm.cust_nm.value=='' || fm.cust_tel.value=='') { alert('고객명 및 연락처를 입력하십시오.'); return; }
	if(fm.cust_tel.value.replace(/-/gi,'').length < 9){	alert('고객연락처를 다시 입력하십시오.(숫자9자리이상)');	return;	}
	<%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")||from_page.equals("/acar/secondhand/secondhand_sc.jsp")){%>
		if(fm.sms_msg2.value=='') { alert('계약방문시 주차장 안내문자를 선택하십시오.'); return; }
	<%}%>
	<%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>
		if(fm.sms_msg.value=='' && fm.sms_msg2.value=='') { alert('계약방문시 준비물 안내문자를 선택하십시오.'); return; }
		if(fm.sms_msg.value!='' && fm.sms_msg2.value=='') { alert('방문장소도 선택하십시오.'); return; }
	<%}%>
	fm.gubun.value = 'sms';

	if(!confirm('문자를 전송 하시겠습니까?')){	return;	}	
	fm.action = "reserveCar_iu.jsp";
	fm.target = "i_no";
	fm.submit();
	
}

function openSearchWindow(){
	window.open("./search_cstmer_list.jsp","","left=250, top=250, width=520, height=600, scrollbars=no, status=yes")	
}

//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="ret_dt" value="<%=ret_dt%>">
<input type="hidden" name="reg_dt" value="<%= AddUtil.getDate() %>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="sr_size" value="<%=sr_size%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="prevEstId" id="prevEstId" value=""/>
<input type="hidden" name="car_name" id="car_name" value=""/>
<input type="hidden" name="reg_code" id="reg_code" value=""/>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량예약 입력사항</span></span></td>
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
                    <td class=title>담당자</td>
                    <td>&nbsp;<select name='damdang_id'>
                            <option value="">==선택==</option>
                            <%	if(user_size > 0){
        										    	for(int i = 0 ; i < user_size ; i++){
        												    Hashtable user = (Hashtable)mngs.elementAt(i); 
        										%>
        								    <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>	
        			    			    <%		}
         										    }
        								    %>										
                        </select>
        			      </td>
                </tr>
                <tr> 
                    <td width="20%" class=title>진행상황</td>
                    <td width="80%" colspan="4">&nbsp;<select name='situation'>
                            <option value="0">상담중</option>  
			                      <%if(sh_res_reg_chk==0){%>
                            <option value="2">계약확정</option>
			                      <%}%>
                        </select>
        			      </td>
                </tr>
                <tr> 
                    <td class=title>고객명</td>
                    <td>
                    	&nbsp;<input type="text" name="cust_nm" value="" size="30" id="cust_nm" class=text style='IME-MODE: active'>
                    	&nbsp;<a href="javascript:openSearchWindow()"><img src="../images/chg_car_btn.jpg" style="vertical-align:middle;"/></a>
                    </td>
                </tr>
                <tr> 
                    <td class=title>고객연락처</td>
                    <td >&nbsp;<input type="text" name="cust_tel" id="cust_tel" value="" size="15" maxlength='20' class=text style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class=title>메모</td>
                    <td >&nbsp;<textarea name="memo" cols="53" rows="6" style="IME-MODE:ACTIVE"><%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>[월렌트]<%}%></textarea></td>
                </tr>
                
                <tr>
                	  <td class=title>문자</td>
                    <td>
                    <%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>
                    	<input type="checkbox" name="sms_add" value="Y"> 계약확정시 계약확정 안내문자에 하단에서 선택된 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;월렌트 	계약방문시 <b>준비물</b> 안내문자도 포함하여 보낸다.<br>     
                    <%}%>              
                    		<input type="checkbox" name="sms_add2" value="Y"> 계약확정시 계약확정 안내문자에 하단에서 선택된 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    		 <%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>
			                    	월렌트 
			                    	<%}%>
			                    	 <%if(from_page.equals("/acar/secondhand/secondhand_sc.jsp")){%>
			                    	재렌트 
			                    <%}%>
                    		 계약방문시 <b>방문장소</b> 안내문자도 포함하여 보낸다.
                    </td>
                </tr>                 
              
            </table>
        </td>
    </tr>
    <tr>  
        <td>* 현재 차량예약이 등록된 담당자는 중복 입력할수 없습니다.
	    </td>	
    </tr>	
    <tr>  
        <td>* 상담중인 예약이 있으면 계약확정을 등록할수 없습니다.
	    </td>	
    </tr>
    <tr>  
        <td align="right">        	
	        <%if(!auth_rw.equals("1")){%>	          
		        <a href="javascript:regReserveCar('i');"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	        <%}%>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>
         <%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>
			                    	월렌트 
			                    	<%}%>
			                    	 <%if(from_page.equals("/acar/secondhand/secondhand_sc.jsp")){%>
			                    	재렌트 
			                    <%}%>
         계약방문시 방문장소 안내문자</span></td>
    </tr>    
    <tr> 
        <td class=line2 ></td>
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
