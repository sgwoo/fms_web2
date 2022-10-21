<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'ars_card_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						ARS결제관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td class="title">조회일자</td>
                <td colspan='3'>&nbsp;
				  <select name='gubun4'>
                    <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>등록일자</option>                    
                    <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>결제일자</option>
                    
                  </select>			
				  &nbsp;	
				  <select name='gubun1'>
                    <option value="4" <%if(gubun1.equals("4"))%>selected<%%>>전일</option>				  
                    <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>당일</option>
                    <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>당월</option>
                    <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>기간</option>					
                  </select>		
				  &nbsp;				  
                    <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
					~
					<input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text"></td>
					<!--
                <td width="10%" class="title">카드구분</td>
                <td width="40%">&nbsp;
                  <select name='gubun2'>
                    <option value="">선택</option>
		    <option value="BC카드"   <%if(gubun2.equals("BC카드"))%>selected<%%>>BC카드</option>
		    <option value="삼성카드" <%if(gubun2.equals("삼성카드"))%>selected<%%>>삼성카드</option>
		    <option value="신한카드" <%if(gubun2.equals("신한카드"))%>selected<%%>>신한카드</option>			                                
		    <option value="외환카드" <%if(gubun2.equals("외환카드"))%>selected<%%>>외환카드</option>
		    <option value="현대카드" <%if(gubun2.equals("현대카드"))%>selected<%%>>현대카드</option>
		    <option value="롯데카드" <%if(gubun2.equals("롯데카드"))%>selected<%%>>롯데카드</option>
                  </select></td>
                  -->
              </tr>
              <tr>
                <td width="10%" class="title">검색조건</td>
                <td width="40%">&nbsp;
                  <select name='s_kd'>
                    <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>고객 </option>                    
                    <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>결제금액</option>
		    <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호</option>							    
		    <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>내역</option>							    
		    <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>등록자</option>
                  </select>
		  &nbsp;&nbsp;&nbsp;
		  <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></td>
                <td width="10%" class="title">결제상태</td>
                <td width="40%">&nbsp;
                  <input type="radio" name="gubun3" value="1" <%if(gubun3.equals("1"))%>checked<%%>>
            	  전체
            	  <input type="radio" name="gubun3" value="2" <%if(gubun3.equals("2"))%>checked<%%>>
            	  대기
            	  <input type="radio" name="gubun3" value="3" <%if(gubun3.equals("3"))%>checked<%%>>
            	  결제완료
                </td>
              </tr>
            </table></td>
    </tr>
    <tr align="right">
        <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>	 
</table>
</form>
</body>
</html>

