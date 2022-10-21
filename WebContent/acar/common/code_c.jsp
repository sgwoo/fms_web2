<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ce_bean" class="acar.common.CodeEtcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String c_st 	= request.getParameter("c_st")==null?"":request.getParameter("c_st");
	String code 	= request.getParameter("code")==null?"":request.getParameter("code");
		
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	code_bean = c_db.getCodeBean(c_st, code, auth_rw);	
	ce_bean =  c_db.getCodeEtc(c_st, code);
		
	
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
function UpDisp()
{
	var theForm = document.CodeDispForm;
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
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body onLoad="javascript:self.focus()">

<form action="./code_u.jsp" name="CodeDispForm" method="post">
  <input type="hidden" name="c_st" value="<%=c_st%>">
  <input type="hidden" name="code" value="<%=code%>">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">		
  <input type='hidden' name='from_page' value='<%=from_page%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100% style="margin: 0 auto;">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>코드관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>			
			    <tr>
    				<td width=150 class="title">코드구분</td>
    				<td width=200>&nbsp;<%=code_bean.getC_st()%></td>
    				<td width=150 class="title">코드</td>
    				<td width=200>&nbsp;<%=code_bean.getCode()%></td>				
    			</tr>			
    			<tr>
    				<td class="title">사용코드명</td>
    				<td colspan="3" align="left">&nbsp;<%=code_bean.getNm_cd()%></td>
    			</tr>				
    			<tr>
    				<td class="title">코드명칭</td>
    				<td colspan="3" align="left">&nbsp;<%=code_bean.getNm()%></td>
    			</tr>		
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
					<%if(c_st.equals("0001")){%>
						<%if(code_bean.getApp_st().equals("1")) {%>국산
						<%}else if(code_bean.getApp_st().equals("2")) {%>수입차
						<%}else{%>그외
						<%}%>
					<%}else if(c_st.equals("0013")){%>
						<%if(code_bean.getApp_st().equals("1")) {%>KIS-법인
						<%}else if(code_bean.getApp_st().equals("2")){%>크레탐-개인
						<%}else if(code_bean.getApp_st().equals("3")){%>크레탑-법인
						<%}else{%>개인
						<%}%>						
					<%}else{%>
					<%= code_bean.getApp_st() %>
					<%}%>	
					</td>
    			</tr>																	
    			<tr>
    				<td class="title">CMS사용코드</td>
    				<td colspan="3" align="left">&nbsp;<%=code_bean.getCms_bk()%></td>
    			</tr>	
    			
    			    <%if(c_st.equals("0003")){%> <!--  은행이면, 정식명칭, 주소 저장   -->
    			<tr>
				<td class="title">구분</td>
				<td colspan="3" align="left">&nbsp;
				<%if(ce_bean.getGubun().equals("1")) {%>은행
				<%}else if(ce_bean.getGubun().equals("2")){%>캐피탈
				<%}else if(ce_bean.getGubun().equals("3")){%>저축은행 외
				<%}else if(ce_bean.getGubun().equals("4")){%>기타 금융기관
				<%} %>
				</td>
			</tr>					    
     			<tr>
				<td class="title">은행명칭</td>
				<td colspan="3" align="left">&nbsp;<%=ce_bean.getNm()%></td>				
			</tr>
			<tr>
			  <td class=title>우편번호</td>
			  <td colspan=3>&nbsp;<%=ce_bean.getZip()%></td>		
			</tr>
			<tr>
			  <td class=title>주소</td>
			  <td colspan=3>&nbsp;<%=ce_bean.getAddr()%></td>			
			</tr>
    
    		<% } %>											
		    </table>		
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
    				<td width=550>&nbsp;<%if(code_bean.getVar1().equals("1")){%>소숫점 절사<%}%><%if(code_bean.getVar1().equals("7")){%>원단위 절상<%}%></td>
    			</tr>			
    			<tr>
    				<td class="title">이자계산방식</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar2().equals("1")){%>12개월나누기<%}%>
		                <%if(code_bean.getVar2().equals("2")){%>실이용일적용(365일)<%}%>
		                <%if(code_bean.getVar2().equals("4")){%>실이용일적용(실제일수)<%}%>
		                <%if(code_bean.getVar2().equals("3")){%>별도입력값<%}%>
    				</td>
    			</tr>			
    			<tr>
    				<td class="title">이자 금액처리</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar3().equals("1")){%>소숫점 절사<%}%>
		                <%if(code_bean.getVar3().equals("8")){%>소숫점 절상<%}%>
		                <%if(code_bean.getVar3().equals("2")){%>소숫점 반올림<%}%>
		                <%if(code_bean.getVar3().equals("7")){%>원단위 절상<%}%>
		                <%if(code_bean.getVar3().equals("3")){%>원단위 절사<%}%>
		                <%if(code_bean.getVar3().equals("4")){%>십원단위 절상<%}%>
		                <%if(code_bean.getVar3().equals("5")){%>십원단위 절사<%}%>
		                <%if(code_bean.getVar3().equals("6")){%>십원단위 반올림<%}%>
    				</td>
    			</tr>		
    			<tr>
    				<td class="title">1회차 일자계산</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar4().equals("Y")){%>1회차 이자 일자계산 한다.<%}%>   
    				</td>
    			</tr>		 
    			<tr>
    				<td class="title">마지막회차 일자계산</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar5().equals("Y")){%>마지막회차 이자 일자계산 한다. (마지막회차 약정일이 계약일 기준)<%}%>
    				</td>
    			</tr>	   	
    			<tr>
    				<td class="title">일자계산 초일 산입여부</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar6().equals("2")){%>초일 불산입<%}%>
		                <%if(code_bean.getVar6().equals("1")){%>초일 산입<%}%>
    				</td>
    			</tr>	 		
		    </table>		
	    </td>
	</tr>    
	<tr>
	    <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
	<tr>
		<td colspan='4' align='right'>
		<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>
		 <a href="javascript:UpDisp()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify_s.gif border=0></a> 
		<%	}%>
		<a href="javascript:CodeClose()" onMouseOver="window.status=''; return true"><img src=../images/center/button_close.gif border=0></a></td>
	</tr>
	
</table>
</form>		

</body>
</html>