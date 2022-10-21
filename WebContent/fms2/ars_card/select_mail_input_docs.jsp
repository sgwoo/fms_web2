<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String est_email= request.getParameter("est_email")==null?"":request.getParameter("est_email");
	String content_st = request.getParameter("content_st")==null?"":request.getParameter("content_st");
	
	String print_type = request.getParameter("print_type")==null?"":request.getParameter("print_type");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String est_nm = request.getParameter("est_nm")==null?"고객":request.getParameter("est_nm");
	String send_seq = request.getParameter("send_seq")==null?"":request.getParameter("send_seq");	
	
	String mail_dyr_ggr = request.getParameter("mail_dyr_ggr")==null?"":request.getParameter("mail_dyr_ggr");	
	String mail_etc_ycr = request.getParameter("mail_etc_ycr")==null?"":request.getParameter("mail_etc_ycr");	
	String mail_dyr_bgs = request.getParameter("mail_dyr_bgs")==null?"":request.getParameter("mail_dyr_bgs");	
	String mail_etc_gtr = request.getParameter("mail_etc_gtr")==null?"":request.getParameter("mail_etc_gtr");	
	String mail_etc_hap = request.getParameter("mail_etc_hap")==null?"":request.getParameter("mail_etc_hap");	
	String mail_dyr_hap = request.getParameter("mail_dyr_hap")==null?"":request.getParameter("mail_dyr_hap");	
	String settle_mny = request.getParameter("settle_mny")==null?"":request.getParameter("settle_mny");	
	String card_fee = request.getParameter("card_fee")==null?"":request.getParameter("card_fee");	
	String kj_ggr = request.getParameter("kj_ggr")==null?"":request.getParameter("kj_ggr");	
	String kj_bgs = request.getParameter("kj_bgs")==null?"":request.getParameter("kj_bgs");	
	String good_mny = request.getParameter("good_mny")==null?"":request.getParameter("good_mny");	
	String buyr_name = request.getParameter("buyr_name")==null?"":request.getParameter("buyr_name");	
	String buyr_mail = request.getParameter("buyr_mail")==null?"":request.getParameter("buyr_mail");	
	String card_per = request.getParameter("card_per")==null?"":request.getParameter("card_per");

	
	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>메일주소 입력하기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style type="text/css">
<!--
body.general		{ background-color:#f4f3f3; font-family: 굴림, Gulim, AppleGothic, Seoul, Arial; font-size: 9pt;}
.style2 			{color: #515150; font-weight: bold; font-size:9pt;}
-->
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	margin-bottom: 0px;
	background-color:#f4f3f3;
	font-family: 돋움; font-size: 9pt;
}
-->
</style>
<script>
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

		fm.action = "select_send_mail_docs.jsp";
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

</head>

<body onLoad="document.form1.est_nm.focus();">
<form name="form1" method="post" action="">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="send_seq" value="<%= send_seq %>">
<input type="hidden" name="content_st" value="<%= content_st %>">

<input type="hidden" name="mail_dyr_ggr" value="<%= mail_dyr_ggr %>">
<input type="hidden" name="mail_etc_ycr" value="<%= mail_etc_ycr %>">
<input type="hidden" name="mail_dyr_bgs" value="<%= mail_dyr_bgs %>">
<input type="hidden" name="mail_etc_gtr" value="<%= mail_etc_gtr %>">
<input type="hidden" name="mail_etc_hap" value="<%= mail_etc_hap %>">
<input type="hidden" name="mail_dyr_hap" value="<%= mail_dyr_hap %>">
<input type="hidden" name="settle_mny" value="<%= settle_mny %>">
<input type="hidden" name="card_fee" value="<%= card_fee %>">
<input type="hidden" name="kj_ggr" value="<%= kj_ggr %>">
<input type="hidden" name="kj_bgs" value="<%= kj_bgs %>">
<input type="hidden" name="good_mny" value="<%= good_mny %>">
<input type="hidden" name="card_per" value="<%= card_per %>">

<table width=440 border=0 cellspacing=0 cellpadding=0>
	<tr>
		<td bgcolor=#9acbe1 height=5></td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_11.gif></td>
    </tr>
    <tr>
		<td height=10></td>
	</tr>
    <tr>
    	<td align=center>
    		<table width=392 border=0 cellspacing=0 cellpadding=0 background=http://fms.amazoncar.co.kr/acar/images/center/mail_bg.gif>
    			<tr>
    				<td><img src=http://fms.amazoncar.co.kr/acar/images/center/mail_up.gif></td>
    			</tr>
    			<tr>
    				<td height=20></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_2.gif></td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>상호 또는 성명 &nbsp;<input type="text" name="est_nm" size="29" value="<%=buyr_name%>"></span></td>
    			</tr>
    			<tr>
    				<td height=10></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>이메일주소  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    					<input type="text" name="mail_addr" size="29" onKeydown="javascript:EnterDown()" value='<%=buyr_mail%>' style='IME-MODE: inactive'></span></td>
    			</tr>
    			<tr>
    				<td height=30></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_3.gif></td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr>
			        <td align=center><table width=350 border=0 cellspacing=0 cellpadding=0>
			            <tr>
			                <td colspan='3'>
							  	<span class=style2>
								&nbsp;&nbsp;<input type='radio' name="replyto_st" value='1' onClick="javascript:cng_input()" checked > 회사메일</span>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td colspan='3'>
			        			<span class=style2>
			        			&nbsp;&nbsp;<input type='radio' name="replyto_st" value='2' onClick="javascript:cng_input()" > 사용자등록메일</span>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td colspan='3'>
			        		<table width=350 border=0 cellspacing=0 cellpadding=0>
			        			<tr>
			        				<td><span class=style2>
			        				&nbsp;&nbsp;<input type='radio' name="replyto_st" value='3' onClick="javascript:cng_input()" > 직접입력 </span>	</td>
			        				<td id='tr_replyto' style='display:none'><input type="text" name="replyto" size="27" onKeydown="javascript:EnterDown()" value=''></td>
			        			</tr>
			        		</table>
							  
							</td>
			            </tr>
			        </table></td>
			    </tr>
			    	
  
    			<tr>
    				<td height=30></td>
    			</tr>    						
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms.amazoncar.co.kr/acar/images/center/mail_4.gif></td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr>
    				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    				  <textarea name="memo" cols="45" rows="10"></textarea></td>
    			</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>


			<tr>
    				<td height=20></td>
    			</tr>
    			<tr>
    				<td><img src=http://fms.amazoncar.co.kr/acar/images/center/mail_dw.gif></td>
    			</tr>
    		</table>
    	</td>
    </tr>
    <tr>
    	<td height=10></td>
    </tr>
    <tr>
    	<td align=center><a href="javascript:send_mail();"><img src=http://fms.amazoncar.co.kr/acar/images/center/mail_btn_send.gif border="0"></a></td>
    </tr>
   
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>
