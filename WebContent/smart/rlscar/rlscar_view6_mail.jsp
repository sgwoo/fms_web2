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
#header {float:left; width:100%; height:43px; margin-bottom:30px;}
#contents {float:left; width:100%; height:100% vertical-align:middle;}
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
.contents_box {width:100%; table-layout:fixed; font-size:13px; height:260px; margin-top:10px;}
.contents_box th {color:#282828; font-size:14px; margin-bottom:10px; font-weight:bold;}
.contents_box td {line-height:22px; color:#7f7f7f; margin-bottom:10px; font-weight:bold;}
.contents_box em{color:#b20075; font-weight:bold;}



/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:30px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}




</style>
</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>

<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	String mail_st 		= request.getParameter("mail_st")==null?"":request.getParameter("mail_st");
	
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?"0":request.getParameter("fee_opt_amt");
	String content_st 	= request.getParameter("content_st")==null?"":request.getParameter("content_st");
	
	String reg_id 		= request.getParameter("write_id")==null?"":request.getParameter("write_id");
	String est_email	= request.getParameter("est_email")==null?"":request.getParameter("est_email");
	
	String months 		= request.getParameter("months")	==null?"":request.getParameter("months");
	String days 		= request.getParameter("days")		==null?"":request.getParameter("days");
	String tot_rm 		= request.getParameter("tot_rm")	==null?"":request.getParameter("tot_rm");
	String tot_rm1 		= request.getParameter("tot_rm1")	==null?"":request.getParameter("tot_rm1");
	String per 		= request.getParameter("per")		==null?"":request.getParameter("per");
	String navi_yn 		= request.getParameter("navi_yn")	==null?"":request.getParameter("navi_yn");

	
%>

<script language='javascript'>
<!--
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') send_mail();
	}

	//메일수신하기
	function send_mail(){
		var fm = document.form1;
		var addr = fm.mail_addr.value;
		if(addr==""){ alert("메일주소를 입력해주세요!"); return; }		
		else if(addr.indexOf("@")<0){ alert("메일주소가 명확하지 않습니다!"); return; }

		fm.action = "/acar/apply/send_mail.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	function cng_input(){
		var fm = document.form1;
		if(fm.replyto_st[0].checked == true || fm.replyto_st[1].checked == true){ 				//회사||개인
			tr_replyto.style.display='none';
		}else{																					//직접입력
			tr_replyto.style.display='';				
		}
	}			
//-->
</script>

<body onLoad="document.form1.mail_addr.focus();">

<form name='form1' method='post' action=''>
<input type="hidden" name="from_page" 	value="<%= from_page %>">
<input type="hidden" name="est_id" 	value="<%= est_id %>">
<input type="hidden" name="acar_id" 	value="<%= acar_id %>">
<input type="hidden" name="mail_st" 	value="<%= mail_st %>">
<input type="hidden" name="opt_chk" 	value="<%=opt_chk%>">
<input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">
<input type="hidden" name="content_st" 	value="<%= content_st %>">
<input type="hidden" name="reg_id" 	value="<%= reg_id %>">
<input type="hidden" name="months" 	value="<%=months%>">
<input type="hidden" name="days" 	value="<%=days%>">
<input type="hidden" name="tot_rm" 	value="<%=tot_rm%>">
<input type="hidden" name="tot_rm1" 	value="<%=tot_rm1%>">
<input type="hidden" name="per" 	value="<%=per%>">
<input type="hidden" name="navi_yn" 	value="<%=navi_yn%>">
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">
        	
			<div id="gnb_login">견적서 메일보내기</div>
            <div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">메일주소</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th height=30>수신 : <input type="text" name="mail_addr" size="27" onKeydown="javascript:EnterDown()" value='<%=est_email%>' style='IME-MODE: inactive'></th>
						</tr>
						<tr>
							<th height=30>회신 : <input type='radio' name="replyto_st" value='1' onClick="javascript:cng_input()" checked >
        			회사메일
        			<input type='radio' name="replyto_st" value='2' onClick="javascript:cng_input()" >
        			사용자등록메일
        			<input type='radio' name="replyto_st" value='3' onClick="javascript:cng_input()" >
        			직접입력</th>
						</tr>
						<tr id='tr_replyto' style='display:none'>
							<th align=center height=30><input type="text" name="replyto" size="27" onKeydown="javascript:EnterDown()" value=''></th>
						</tr>						
						<tr>
							<th height=30>메모 : <textarea name="memo" cols="27" rows="5"></textarea></th>
						</tr>
						<tr>
							<th height=30><input type="checkbox" name="file_add_yn1" value="Y"> 체크시 [개인신용정보 조회동의] 파일을 첨부한다.</th>
						</tr>						
						<tr>
							<th align=center height=20>&nbsp;</th>
						</tr>
						<tr>
							<th align=center><a href="javascript:send_mail();"><img src=/smart/images/btn_send.gif align=absmiddle /></a></th>
						</tr>
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
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>
