<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "12", "01");
	
	String s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?	"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
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
		//if(fm.t_wd.value == '' && fm.gubun1.value == ''){
		//	if(fm.gubun5.value == '6' && ( fm.st_dt.value == '' || fm.end_dt.value == '' ) ){  alert('기간을 입력하십시오.'); return; }
		//}		
				
		fm.action = 'alink_s2_sc.jsp';
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
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>전자계약서</span></span></td>
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
                    <td class="title" width=10%>조회일자</td>
                    <td width="40%">&nbsp;
			<select name='gubun4'>
                            <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>송신일자</option>
                        </select>			
			&nbsp;	
			<select name='gubun5'>			    
                            <option value="1" <%if(gubun5.equals("1"))%>selected<%%>>당일</option>                            
                            <option value="2" <%if(gubun5.equals("2"))%>selected<%%>>전일</option>
                            <option value="3" <%if(gubun5.equals("3"))%>selected<%%>>2일</option>	
                            <option value="4" <%if(gubun5.equals("4"))%>selected<%%>>당월</option>
                            <option value="5" <%if(gubun5.equals("5"))%>selected<%%>>전월</option>
                            <option value="6" <%if(gubun5.equals("6"))%>selected<%%>>기간</option>					
                        </select>		
			&nbsp;				  
                        <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
			~
			<input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">
		    </td>
                    <td class=title width=10%>계약 구분</td>
                    <td width=40%>&nbsp;
        				<select name='gubun1'>
                            <option value=''  <%if(gubun1.equals("")){ %>selected<%}%>>전체 </option>
                            <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>장기대여계약서 </option>
                            <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>장기대여계약서(승계) </option>
                            <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>장기대여계약서(연장) </option>
                        </select>&nbsp;
        	    	</td>		  		  		    					                
                </tr>		    
                <tr>		    
                    <td class=title width=10%>검색조건</td>
                    <td>&nbsp;
        	        	<select name='s_kd'>
                            <option value='1'  <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                            <option value='2'  <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
                            <option value='3'  <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
                            <option value='4'  <%if(s_kd.equals("4")){%>selected<%}%>>차명 </option>
                            <option value='5'  <%if(s_kd.equals("5")){%>selected<%}%>>송신자 </option>
                        </select>
        		&nbsp;
        		<input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                    </td>
                    <td class=title width=10%>상태 구분</td>
                    <td width=40%>&nbsp;
        				<select name='gubun2'>
                            <option value=''  <%if(gubun2.equals("")){ %>selected<%}%>> 전체 </option>
                            <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>> 송신계약서</option>
                            <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>> 완료계약서</option>
                            <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>> 폐기계약서</option>
                        </select>&nbsp;
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
    <tr><td><div>※ 2019년 5월 14일 이후 전자계약서 전송내역이 표시됩니다. (이전 전송내역은 영업관리>계약관리> 송신/완료/폐기전자계약서(구) 에서 확인)</div></td></tr>
    <tr><td><div>※ 비대면계약중  CMS동의서(JPG파일)도  파일크기300k 미만인 경우  등록됩니다.!!!!.</div></td></tr>  
</table>
</form> 
</body>
</html>

