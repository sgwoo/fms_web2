<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>Mobile_FMS_Search_Cont</title>
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 
<meta name="robots" content="noindex, nofollow">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel=stylesheet type="text/css" href="/smart/include/css_list.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--	
	function view_before()
	{
		var fm = document.form1;		
		
		fm.action = "rent_cont_stat.jsp";	
		
		if(fm.gubun2.value == '1'){
		 	fm.action = "rent_cont_stat_1.jsp";	
		 	fm.gubun3.value = '';
		 	fm.gubun4.value = '';
		}else if(fm.gubun2.value == '2'){
		 	fm.action = "rent_cont_stat_2.jsp";
		 	fm.gubun3.value = '';
		 	fm.gubun4.value = '';
		}else if(fm.gubun2.value == ''){
			fm.mode.value = '';
			fm.gubun2.value = '';
			fm.gubun3.value = '';
			fm.gubun4.value = '';
		}
		fm.submit();
	}
//-->
</script>
</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/smart/cookies.jsp" %>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>


<%	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");		

	Vector vt = ec_db.getStatDeptListM("list", mode, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
	int vt_size = vt.size();
								
%> 

<body>
<form name='form1' method='post' action='rent_cont_stat.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
	<input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
	<input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
	<input type='hidden' name='mode' 	value='<%=mode%>'>  
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">계약리스트</span></div>
            <div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>				
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
	    </div>
        </div>
    </div>
    <div id="contents">
	<div id="dj_list">			
	    <table border="0" cellspacing="0" cellpadding="0" width="100%">							
                    <th width=5%>연번</th>
                    <th width=10%>계약일자</th>
                    <th width=20%>상호</th>
                    <th width=10%>차량구분</th>
                    <th width=10%>관리구분</th>
                    <th width=10%>차량번호</th>
                    <th width=25%>차명</th>
                    <th width=10% class="n">최초영업자</th>

		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);					
		%>
				
                <tr>
                    <td><%= i+1 %></td>
                    <td><%=ht.get("RENT_DT")%></td>
                    <td class="c"><%=ht.get("FIRM_NM")%></td>
                    <td><%=ht.get("RENT_ST")%></td>
                    <td><%=ht.get("RENT_WAY")%></td>
                    <td><%=ht.get("CAR_NO")%></td>
                    <td class="c"><%=ht.get("CAR_NAME")%></td>
                    <td><%=ht.get("USER_NM")%></td>                    
                </tr>
        	<%	}%> 
	    </table>
	</div>  
    </div>
    <div id="footer"></div>     
</div>
</form>
</body>
</html>