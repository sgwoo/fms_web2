<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day 	= request.getParameter("s_day")==null?"":request.getParameter("s_day");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function search()
	{
		var fm = document.form1;
		fm.action = 'cooperation_p_sc.jsp';
		fm.target='c_body';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post' target=''>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 업무협조 > <span class=style5>고객방문협조(주차장)</span></span></td>
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
                <td class="title">요청일자</td>
                <td width="40%">&nbsp;
				  <select name='s_year'>
          			<option value="" <%if(s_year.equals("")){%> selected <%}%>>전체</option>        		  				  
          			<%for(int i=2009; i<=AddUtil.getDate2(1); i++){%>
          			<option value="<%=i%>" <%if(i == AddUtil.parseInt(s_year)){%> selected <%}%>><%=i%>년도</option>
          			<%}%>				  
    		      </select>
    			  <select name='s_mon'>
          			<option value="" <%if(s_mon.equals("")){%> selected <%}%>>전체</option>        		  
	          		<% for(int i=1; i<=12; i++){%>        
          			<option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(s_mon)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
          			<%}%>			
    		      </select>
 				</td>
                <td width="10%" class="title">처리여부</td>
                <td width="40%">&nbsp;
                  <select name='gubun2'>
                    <option value="">선택</option>
                    <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>처리</option>
                    <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>미처리</option>
                  </select></td>
              </tr>
              <tr>
                <td width="10%" class="title">검색조건</td>
                <td>&nbsp;
                  <select name='s_kd'>
                    <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>제목+내용 </option>
                    <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>고객</option>
                    <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>처리자</option>										
                    <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>요청자+처리자</option>
                  </select>
					&nbsp;&nbsp;&nbsp;
					<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></td>
                <td class="title">처리자지정</td>
                <td>&nbsp;
                    <select name='gubun3'>
                      	<option value="">선택</option>
                      	<option value="1" <%if(gubun3.equals("1"))%>selected<%%>>지정</option>
						<option value="2" <%if(gubun3.equals("2"))%>selected<%%>>미지정</option>
                  </select></td>
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