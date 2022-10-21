<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String white = "";
	String disabled = "";
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	if(nm_db.getWorkAuthUser("아마존카이외",user_id)){
		white = "white";
		disabled = "disabled";
	}
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body <%//if(white.equals("")){%>onload="javascript:search();"<%//}%> leftmargin=15 >
<form name='form1' action='/fms2/consignment_new/cons_rec_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 탁송관리 > <span class=style5>미수신현황/기사등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>기간</td>
                    <td>&nbsp;
        			  <select name='gubun3'>
                        <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>요청일자</option>				
                        <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>의뢰일자</option>				
                      </select>
                	  <select name='gubun2'>
                        <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>당월</option>
                        <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>당일</option>
                        <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>익일</option>
                        <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>기간 </option>
                      </select>
                	  <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                      ~ 
                      <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                	</td>
                    <td class=title width=10%>탁송업체</td>
                    <td width=40%>&nbsp;
        		      <select name='gubun1'>
					<%if(user_id.equals("000223") ||  user_id.equals("000231")){%>			  
                        <option value='아마존탁송'       		 <%if(gubun1.equals("아마존탁송")){%>selected<%}%>>주식회사 아마존탁송</option>			  
       			    <%}else if(user_id.equals("000139")){%>			  
                        <option value='하이카콤'   		<%if(gubun1.equals("하이카콤")){%>selected<%}%>>하이카콤</option>		
					<%}else if(user_id.equals("000196")){%>			  
						<option value='에프앤티코리아'   	<%if(gubun1.equals("에프앤티코리아")){%>selected<%}%>>에프앤티코리아</option>								
					<%}else if(user_id.equals("000187")||user_id.equals("000192")){%>			  
                        <option value='(주)삼진특수'   	<%if(gubun1.equals("(주)삼진특수")){%>selected<%}%>>(주)삼진특수</option>								
					<%}else if(user_id.equals("000222")){%>			  
						<option value='(주)영원물류'   	<%if(gubun1.equals("(주)영원물류")){%>selected<%}%>>(주)영원물류</option>
					<%}else if(user_id.equals("000308")){%>			  
						<option value='상원물류(주)'   	<%if(gubun1.equals("상원물류(주)")){%>selected<%}%>>상원물류(주)</option>
					<%}else if(user_id.equals("000147")){%>			  
                        <option value='대전케리어'   	<%if(gubun1.equals("대전케리어")){%>selected<%}%>>대전케리어</option>								
					<%}else if(user_id.equals("000109")){%>			  
                        <option value='포엠티엠씨' 		 <%if(gubun1.equals("포엠티엠씨")){%>selected<%}%>>포엠티엠씨</option>		
                    <%}else if(user_id.equals("000263")){%>			  
                        <option value='스마일TS'   	<%if(gubun1.equals("스마일TS")){%>selected<%}%>>스마일TS</option>
                    <%}else if(user_id.equals("000328")){%>			  
                        <option value='퍼스트드라이브'   	<%if(gubun1.equals("퍼스트드라이브")){%>selected<%}%>>퍼스트드라이브</option>					  				
       			    <%}else{%>
        			    <option value='' >전체</option>
        				<option value='아마존카'   		 <%if(gubun1.equals("아마존카"))		{%>selected<%}%>>아마존카</option>
						<option value='아마존탁송'       	 <%if(gubun1.equals("아마존탁송"))			{%>selected<%}%>>주식회사 아마존탁송</option>
						<option value='에프앤티코리아' 	 	<%if(gubun1.equals("에프앤티코리아"))	{%>selected<%}%>>에프앤티코리아</option>						
						<option value='하이카콤'   		 <%if(gubun1.equals("하이카콤"))		{%>selected<%}%>>하이카콤</option>	
						<option value='(주)삼진특수' 	 <%if(gubun1.equals("(주)삼진특수"))		{%>selected<%}%>>(주)삼진특수</option>
						<option value='(주)영원물류'   	<%if(gubun1.equals("(주)영원물류")){%>selected<%}%>>(주)영원물류</option>						
						<option value='상원물류(주)'   	<%if(gubun1.equals("상원물류(주)")){%>selected<%}%>>상원물류(주)</option>						
						<option value='대전케리어'   	 <%if(gubun1.equals("대전케리어"))		{%>selected<%}%>>대전케리어</option>									
       					<option value='포엠티엠씨' 		 <%if(gubun1.equals("포엠티엠씨"))		{%>selected<%}%>>포엠티엠씨</option>		
       					<option value='스마일TS'   	 <%if(gubun1.equals("스마일TS")){%>selected<%}%>>스마일TS</option>	
       					<option value='퍼스트드라이브'   	 <%if(gubun1.equals("퍼스트드라이브")){%>selected<%}%>>퍼스트드라이브</option>	  
        			    <%}%>
                      </select>
                	</td>
                </tr>	  
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td>&nbsp;
                	  <select name='s_kd'>
                        <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>지점 </option>
                        <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>의뢰자</option>
                        <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차명</option>
                        <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>차량/차대번호</option>
                        <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>출발/도착장소 </option>				
                      </select>
                	  &nbsp;&nbsp;&nbsp;
                	  <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active' <%if(nm_db.getWorkAuthUser("아마존카이외",user_id)){%>readonly<%}%>>
                	</td>
                    <td class=title width=10%>정렬조건</td>
                    <td>&nbsp;
                	  <select name='sort'>
                        <option value='1' <%if(sort.equals("1")){%>selected<%}%>>지점 </option>
                        <option value='2' <%if(sort.equals("2")){%>selected<%}%>>의뢰자</option>
                        <option value='6' <%if(sort.equals("6")){%>selected<%}%>>요청일자 </option>
                        <option value='7' <%if(sort.equals("7")){%>selected<%}%>>의뢰일자 </option>								
                      </select>
                	</td>
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><%//if(white.equals("")){%><a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a> <%//}%></td>
    </tr>
</table>
</form>
</body>
</html>
