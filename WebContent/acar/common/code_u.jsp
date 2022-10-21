<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ce_bean" class="acar.common.CodeEtcBean" scope="page"/>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	

	String user_id = "";
	String acar_id = "";
	String c_st = "";
	String code = "";
	String nm_cd = "";
	String nm = "";
	String cms_bk = "";
	String app_st = "";	
    	String auth_rw = "";
    	
    	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
    	
   	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("c_st") != null) 	c_st 	= request.getParameter("c_st");
	if(request.getParameter("code") != null) 	code 	= request.getParameter("code");
	
	acar_id = login.getCookieValue(request, "acar_id");
	
//    out.println("auth_rw="+ auth_rw );
	    
	code_bean = c_db.getCodeBean(c_st, code, auth_rw);
	
	nm_cd = code_bean.getNm_cd();
	nm = code_bean.getNm();
	cms_bk = code_bean.getCms_bk();
	app_st = code_bean.getApp_st();

	ce_bean =  c_db.getCodeEtc(c_st, code);

	
%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function CodeUp()
{
	var theForm = document.CodeUpForm;
	if(theForm.nm_cd.value == '')	{	alert('사용코드명을 입력하십시오');	return;	}
	else if(theForm.nm.value == '')	{	alert('코드명칭을 입력하십시오');	return;	}
	
	if(!confirm('수정하시겠습니까?'))
		return;		
	theForm.cmd.value = "u";
	theForm.target="i_no";
	theForm.submit();
}
function CodeDl()
{
	var theForm = document.CodeUpForm;
	if(!confirm('삭제하시겠습니까?'))
		return;	
	theForm.cmd.value = "d";
	theForm.target="i_no";
	theForm.submit();
}

function CodeClose()
{

	self.close();
	window.close();
}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus()">

<form action="./code_null_ui.jsp" name="CodeUpForm" method="post">
  <input type='hidden' name='from_page' value='<%=from_page%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100% style="margin: 0 auto;">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>코드수정</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	
	<tr>
	<td class='line'>
		 <table border="0" cellspacing="1" cellpadding="0" width=100%>
			
			<tr>
				<td width=150 class="title">코드구분</td>
				<td width=200 align="center"><%=c_st%></td>
				<td width=150 class="title">코드</td>
				<td width=200 align="center"><%=code%></td>
				
			</tr>
			
			<tr>
				<td class="title">사용코드명</td>
				<td colspan="3" align="left">&nbsp;
				  <input type='text' name="nm_cd" value="<%=nm_cd%>" size='40' class='text'></td>
			</tr>	
			<tr>
				<td class="title">코드명칭</td>
				<td colspan="3" align="left">&nbsp;
				  <input type='text' name="nm" value="<%=nm%>" size='40' class='text'>
				</td>				  
			</tr>	
			<%if(from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
			<input type="hidden" name="app_st" value="<%=app_st%>">
			<input type="hidden" name="cms_bk" value="<%=cms_bk%>">
			<%}else{%>
			<tr>
				<td class="title">
					<%if(c_st.equals("0001")){%>
					출처
					<%}else if(c_st.equals("0013")){%>
					판정기관
					<%}else if(c_st.equals("0018")||c_st.equals("0019")||c_st.equals("0020")||c_st.equals("0021")){%>
					거래처코드					
					<%}else if(c_st.equals("0022")){%>
					탁송금액
					<%}else if(c_st.equals("0003")){%>
					법인번호
					<%}else{%>
					반영여부
					<%}%>	
				</td>
				<td colspan="3" align="left">&nbsp;
				  <input type='text' name="app_st" value="<%=app_st%>" size='15' class='text'>
				    <%if(c_st.equals("0001")){%>
					<br><hr>&nbsp;( 1:국산차, 2:수입차, 3:그외 )
					<%}else if(c_st.equals("0013")){%>
					<br><hr>&nbsp;( 1:KIS, 2:크레탑개인, 3:크레탑법인 )
					<%}else{%>

					<%}%>
				  </td>
			</tr>					
			<tr>
				<td class="title">CMS사용코드</td>
				<td colspan="3" align="left">&nbsp;
				  <input type='text' name="cms_bk" value="<%=cms_bk%>" size='5' class='text'></td>
			</tr>
			<%}%>									
		
		    <%if(c_st.equals("0003")){%> <!--  은행이면, 정식명칭, 주소 저장   -->
	    	<tr>
				<td class="title">구분</td>
				<td colspan="3" align="left">&nbsp;
				      <input type='radio' name="t_gubun" value='1' <%if(ce_bean.getGubun().equals("1")){%> checked <%}%> >
			                      은행&nbsp;
			               <input type='radio' name="t_gubun" value='2' <%if(ce_bean.getGubun().equals("2")){%> checked <%}%> >
			        	 		캐피탈&nbsp;
			        	       <input type='radio' name="t_gubun" value='3' <%if(ce_bean.getGubun().equals("3")){%> checked <%}%> >
			        	 		저축은행&nbsp;	
			      	      <input type='radio' name="t_gubun" value='4' <%if(ce_bean.getGubun().equals("4")){%> checked <%}%> >
			        	 		기타금융기관	
				</td>
			</tr>	
			
     			<tr>
				<td class="title">은행명칭</td>
				<td colspan="3" align="left">&nbsp;
				  <input type="text" name="t_nm" value="<%=ce_bean.getNm()%>" size="50" class="text"></td>
			</tr>	
			        	    				
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

								// 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
								// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
								var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
								var extraRoadAddr = ''; // 도로명 조합형 주소 변수

								// 법정동명이 있을 경우 추가한다. (법정리는 제외)
								// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
								if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
									extraRoadAddr += data.bname;
								}
								// 건물명이 있고, 공동주택일 경우 추가한다.
								if(data.buildingName !== '' && data.apartment === 'Y'){
								   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
								}
								// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
								if(extraRoadAddr !== ''){
									extraRoadAddr = ' (' + extraRoadAddr + ')';
								}
								// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
								if(fullRoadAddr !== ''){
									fullRoadAddr += extraRoadAddr;
								}
								
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = fullRoadAddr;
								
								// 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
								if(data.autoRoadAddress) {
									//예상되는 도로명 주소에 조합형 주소를 추가한다.
									var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
									document.getElementById('t_addr').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

								} else if(data.autoJibunAddress) {
									var expJibunAddr = data.autoJibunAddress;
									document.getElementById('t_addr').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

								} else {
									document.getElementById('t_addr').innerHTML = '';
								}
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title rowspan="2">주소</td>
				  <td colspan=3>&nbsp;
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=ce_bean.getZip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기">
					
				  </td>
				</tr>
				<tr>
				  <!-- <td class=title></td> -->
				  <td colspan=3>&nbsp;				
					<input type="text" name="t_addr" id="t_addr" size="50" value="<%=ce_bean.getAddr()%>">
				  </td>
				</tr>
    
    		<% } %>
    
		</table>
		<input type="hidden" name="code" value="<%=code%>">
		<input type="hidden" name="c_st" value="<%=c_st%>">
		<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
		<input type="hidden" name="cmd" value="">
		<input type="hidden" name="before_nm" value="<%=nm%>">
		
		
	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tR>
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>할부금</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
        <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>			
			    <tr>
    				<td width=150 class="title">월상환료 금액처리 </td>
    				<td width=550>&nbsp;
    				  <select name='var1'>
		                <option value="">선택</option>
		                <option value="1" <%if(code_bean.getVar1().equals("1")){%>selected<%}%>>소숫점 절사</option> 
		                <option value="7" <%if(code_bean.getVar1().equals("7")){%>selected<%}%>>원단위 절상</option>		                		                
		              </select>
    				</td>
    			</tr>			
    			<tr>
    				<td class="title">이자계산방식</td>
    				<td>&nbsp;
    				  <select name='var2'>
		                <option value="">선택</option>
		                <option value="1" <%if(code_bean.getVar2().equals("1")){%>selected<%}%>>12개월나누기</option>
		                <option value="2" <%if(code_bean.getVar2().equals("2")){%>selected<%}%>>실이용일적용(365일)</option>
		                <option value="4" <%if(code_bean.getVar2().equals("4")){%>selected<%}%>>실이용일적용(실제일수)</option>
		                <option value="3" <%if(code_bean.getVar2().equals("3")){%>selected<%}%>>별도입력값</option>
		              </select>
    				</td>
    			</tr>			
    			<tr>
    				<td class="title">이자 금액처리</td>
    				<td>&nbsp;
   				      <select name='var3'>	
    				    <option value="">선택</option>	                
		                <option value="1" <%if(code_bean.getVar3().equals("1")){%>selected<%}%>>소숫점 절사</option>
		                <option value="8" <%if(code_bean.getVar3().equals("8")){%>selected<%}%>>소숫점 절상</option>
		                <option value="2" <%if(code_bean.getVar3().equals("2")){%>selected<%}%>>소숫점 반올림</option>
		                <option value="7" <%if(code_bean.getVar3().equals("7")){%>selected<%}%>>원단위 절상</option><!-- 원단위절상 추가 20180918 -->
		                <option value="3" <%if(code_bean.getVar3().equals("3")){%>selected<%}%>>원단위 절사</option>
		                <option value="4" <%if(code_bean.getVar3().equals("4")){%>selected<%}%>>십원단위 절상</option>
		                <option value="5" <%if(code_bean.getVar3().equals("5")){%>selected<%}%>>십원단위 절사</option>
		                <option value="6" <%if(code_bean.getVar3().equals("6")){%>selected<%}%>>십원단위 반올림</option> 
		              </select>
    				</td>
    			</tr>		
    			<tr>
    				<td class="title">1회차 일자계산</td>
    				<td>&nbsp;
    				    <input type="checkbox" name="var4" value="Y" <%if(code_bean.getVar4().equals("Y")){%>checked<%}%>> 1회차 이자 일자계산 한다.
    				</td>
    			</tr>		 
    			<tr>
    				<td class="title">마지막회차 일자계산</td>
    				<td>&nbsp;
    				    <input type="checkbox" name="var5" value="Y" <%if(code_bean.getVar5().equals("Y")){%>checked<%}%>> 마지막회차 이자 일자계산 한다. (마지막회차 약정일이 계약일 기준)
    				</td>
    			</tr>	   	
    			<tr>
    				<td class="title">일자계산 초일 산입여부</td>
    				<td>&nbsp;
    				  <select name='var6'>
		                <option value="">선택</option>
		                <option value="2" <%if(code_bean.getVar6().equals("2")){%>selected<%}%>>초일 불산입</option>
		                <option value="1" <%if(code_bean.getVar6().equals("1")){%>selected<%}%>>초일 산입</option>		                		                
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
		<td colspan='4' align='right'>
		<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>
		 <a href="javascript:CodeUp()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0></a> 
		<%	}%>
		<a href="javascript:CodeClose()" onMouseOver="window.status=''; return true"><img src=../images/center/button_close.gif border=0></a></td>
	</tr>		
		
</table>
</form>

<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>

</body>
</html>