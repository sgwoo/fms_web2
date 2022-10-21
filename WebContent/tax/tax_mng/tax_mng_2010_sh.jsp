<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		if(fm.st_dt.value == ''){ alert('기간을 입력하십시오.'); return;}
		if(fm.end_dt.value == ''){ alert('기간을 입력하십시오.'); return;}
		fm.action="tax_mng_2010_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	

//-->
</script>

</head>
<body>
<form action="./tax_mng_2010_sc.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type="hidden" name="idx" value="<%=idx%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan="3">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > <span class=style5>
						세금계산서보관함5년전(2001년~)</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" class=h></td>
	</tr>  	    
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gggub.gif" align=absmiddle>&nbsp;
        <select name="gubun1" >
          <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>세금일자&nbsp;</option>
          <option value="2" <%if(gubun1.equals("2")){%> selected <%}%>>작성일자&nbsp;</option>
        </select>
        &nbsp;&nbsp;
        <select name="gubun2" >
        	<%for(int i=2001; i<=AddUtil.parseInt(gubun3); i++){%>
          <option value="<%=i%>" <%if(gubun2.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
          <%}%>
        </select>	
        &nbsp;&nbsp;
		    <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		    &nbsp;~&nbsp;
		    <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">
		    (선택년도이내)
      </td>
      <td><img src="/acar/images/center/arrow_bhgb.gif" align=absmiddle>&nbsp; 
        <input type="radio" name="chk1" value="0" <%if(chk1.equals("0")){%> checked <%}%>>
        전체
        <input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>
        정상
        <input type="radio" name="chk1" value="2" <%if(chk1.equals("2")){%> checked <%}%>>
        수정
        <input type="radio" name="chk1" value="3" <%if(chk1.equals("3")){%> checked <%}%>>
        취소</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td width="40%">
	    <table width="100%"  cellspacing=0 border="0" cellpadding="0">
          <tr>
            <td width="250">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" align=absmiddle>&nbsp; 
              <select name="s_kd">
                <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
                <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>공급받는자</option>
                <option value="13" <%if(s_kd.equals("13")){%> selected <%}%>>고객명</option>				
                <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>계약번호</option>
                <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>차량번호</option>
                <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>사업자번호</option>
                <option value="5" <%if(s_kd.equals("5")){%> selected <%}%>>일련번호</option>
                <option value="6" <%if(s_kd.equals("6")){%> selected <%}%>>품목/비고</option>
                <option value="10" <%if(s_kd.equals("10")){%> selected <%}%>>수신이메일</option>
                <option value="12" <%if(s_kd.equals("12")){%> selected <%}%>>국세청승인번호</option>
              </select>
          </td>
          <td>
		  <input type="text" name="t_wd1" size="12" value="<%=t_wd1%>" class="text" onKeyDown="javasript:enter()">
      OR
        <input type="text" name="t_wd2" size="12" value="<%=t_wd2%>" class="text" onKeyDown="javasript:enter()"></td>          
        </tr>
      </table>
	  </td>
      <td width="35%"><img src="/acar/images/center/arrow_jr.gif" align=absmiddle>&nbsp; 
        <select name="sort">
          <option value="1" <%if(sort.equals("1")){%> selected <%}%>>상호</option>
          <option value="2" <%if(sort.equals("2")){%> selected <%}%>>차량번호</option>
          <option value="3" <%if(sort.equals("3")){%> selected <%}%>>사업자번호</option>
          <option value="4" <%if(sort.equals("4")){%> selected <%}%>>일련번호</option>
          <option value="5" <%if(sort.equals("5")){%> selected <%}%>>세금일자</option>
          <option value="6" <%if(sort.equals("6")){%> selected <%}%>>작성일자</option>
          <option value="7" <%if(sort.equals("7")){%> selected <%}%>>출력일자</option>
        </select>
        <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search()'>
        오름차순 
        <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search()'>
        내림차순 </td>
      <td width="10%"><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>
  </table>
</form>
</body>
</html>
