<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}


/* 둥근테이블 시작 */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}





/* 내용테이블 */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}




</style>

</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	
	
	String self_st 	= request.getParameter("self_st")==null?"N":request.getParameter("self_st");
	
	Vector vt = new Vector();
	
	vt = a_db.getRentStartEstCarList(s_kd, t_wd, self_st, user_id);
	
	int vt_size = vt.size();
%>


<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
//		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.action = 'search_start_cont_list.jsp';
		fm.target = '_self';
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function setCode(rent_mng_id, rent_l_cd, car_mng_id){
		var fm = opener.document.form1;				
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;		
		fm.car_mng_id.value 	= car_mng_id;				
		opener.page_reload();
		self.close();
	}
//-->
</script>

<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' action='search_start_cont_list.jsp' method='post'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>    
	<input type='hidden' name='rent_mng_id' value=''>
	<input type='hidden' name='rent_l_cd' 	value=''>
	<input type='hidden' name='car_mng_id' 	value=''>	

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">고객 조회</div>
			<div id="gnb_home"></div>
            
        </div>
    </div>
    <div id="contents">
    	<div id="search">
		<fieldset class="srch">
			<legend>검색영역</legend>
			<select name="s_kd"> 
				<option value="1" <%if(s_kd.equals("1")||s_kd.equals("")){%> selected <%}%>>상호</option> 
				<option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
			</select> 
			<input accesskey="s" class="keyword" title=검색어 type="text" name="t_wd" value="<%=t_wd%>"  style='IME-MODE: active'> 
			<input type='checkbox' name='self_st' value="Y" checked >담당자입력분만
			<a onClick='javascript:window.search();' style='cursor:hand'><img src="/smart/images/btn_srch.gif" alt="검색" value="검색"></a>
		</fieldset> 
		</div>
		<br>			
    	<div id="ctable">		
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
              		<%	for (int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);%>					
						<tr>
							<th valign=top><a href="javascript:setCode('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>');"><%=ht.get("CAR_NO")%></a><br><%=ht.get("CAR_NM")%></th>
							<td valign=top>
								<%=ht.get("FIRM_NM")%> 
								<font color="#aeaeae"> &nbsp;|&nbsp; </font><%=ht.get("USER_NM")%>

								<br> 
								<%if(ht.get("RENT_ST").equals("재리스")){%>
								<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%> 계약
								<%}else{%>
								<%	if(ht.get("DLV_DT").equals("")){%>
								<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%> 계약
								<%	}else{%>
								<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%> 출고
								<%	}%>
								<%}%>								
								<font color="#aeaeae"> &nbsp;|&nbsp; </font>								  
								  &nbsp;<%=ht.get("RENT_ST")%>
								  <br>&nbsp;
							</td>
						</tr>
              		<%	}%>
					<%	if(vt_size==0){%>								
						<tr>
							<th>데이타가 없습니다.</th>
						</tr>
					<%	}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
	</div>
	<div id="footer"></div>  
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>