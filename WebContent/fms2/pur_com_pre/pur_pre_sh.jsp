<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = umd.getXmlMaMenuAuth(user_id, "07", "04", "13");
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'pur_pre_sc.jsp';
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
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>계출관리 > <span class=style5>사전계약관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>출고영업소</td>
                    <td>&nbsp;
            		<select name='gubun3'>
                            <option value='' <%if(gubun3.equals("")){%>selected<%}%>> 전체 </option>
                            <option value='B2B사업운영팀'   <%if(gubun3.equals("B2B사업운영팀")){%>selected<%}%>> 현대 B2B사업운영팀 </option>
                            <option value='숭실대대리점'  <%if(gubun3.equals("숭실대대리점")){%>selected<%}%>> 기아 숭실대판매점 </option>
                            <option value='세종로대리점'  <%if(gubun3.equals("세종로대리점")){%>selected<%}%>> 기아 세종로판매점 </option>
                            <option value='학익대리점'   <%if(gubun3.equals("학익대리점")){%>selected<%}%>> 기아 학익대리점 </option>
                            <option value='을지로대리점'  <%if(gubun3.equals("을지로대리점")){%>selected<%}%>> 기아 을지로대리점 </option>
                            <option value='증산대리점'   <%if(gubun3.equals("증산대리점")){%>selected<%}%>> 기아 증산대리점 </option>
                            <option value='강서구청영업소' <%if(gubun3.equals("강서구청영업소")){%>selected<%}%>> 지엠 강서구청점 </option>
                        </select>
        	  </td>					
                    <td class=title width=10%>차명</td>
                    <td>&nbsp;
            		<input type='text' name='gubun4' size='15' class='text' value='<%=gubun4%>' style='IME-MODE: active'>
        	  </td>					
                    <td class=title width=10%>구분</td>
                    <td>&nbsp;
            		<select name='gubun5'>
                            <option value='' <%if(gubun5.equals("")){%>selected<%}%>> 전체 </option>
                            <option value='Y' <%if(gubun5.equals("Y")){%>selected<%}%>> 진행 </option>
                            <option value='Y1' <%if(gubun5.equals("Y1")){%>selected<%}%>> 진행-계약 </option>
                            <option value='Y3' <%if(gubun5.equals("Y3")){%>selected<%}%>> 진행-예약 </option>
                            <option value='Y2' <%if(gubun5.equals("Y2")){%>selected<%}%>> 진행-대기 </option>
                            <option value='N' <%if(gubun5.equals("N")){%>selected<%}%>> 취소 </option>
                            <option value='P' <%if(gubun5.equals("P")){%>selected<%}%>> 출고 </option>
                        </select>
        	  </td>					        	          	  
                </tr>    	        
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td width=22%>&nbsp;
            		<select name='s_kd'>
                            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>> 계출번호 </option>
                            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>> 사양 </option>
                            <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>> 색상 </option>
                            <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>> 예약자 </option>
                            <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>> 고객명 </option>
                        </select>
                        &nbsp;
            		<input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>            		
        	  </td>
                    <td class=title width=10%>기간</td>
                    <td width=33%>&nbsp;
            		<select name='gubun1'>
                            <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>> 계약등록일 </option>
                            <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>> 출고예정일 </option>
                            <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>> 계약취소일 </option>
                        </select>
                        &nbsp;
                        <select name='gubun2'>                          
                          <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>당일</option>
                          <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>전일</option>
                          <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>당월</option>
                          <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>기간 </option>
                        </select>
                        &nbsp;
            		<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">      		
        	  </td>
                  <td class=title width=10%>정렬조건</td>
                  <td>&nbsp;
        	      <select name='sort'>
                          <option value='1' <%if(sort.equals("1")){ %>selected<%}%>> 계약등록일 </option>
                          <option value='2' <%if(sort.equals("2")){%>selected<%}%>> 출고예정일 </option>
                          <option value='3' <%if(sort.equals("3")){%>selected<%}%>> 계출번호 </option>
                      </select>
        	  </td>						
                </tr>
    	    </table>
        </td>
    </tr>
    <tr align="right">
        <td>
            <a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
        </td>
    </tr>
</table>
</form>
</body>
</html>

