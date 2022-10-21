<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.estimate_mng.*" %>

<%
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String acar_id 		= request.getParameter("acar_id")	==null?"":request.getParameter("acar_id");
	String est_id 		= request.getParameter("est_id")	==null?"":request.getParameter("est_id");
	
	String mail_st 		= request.getParameter("mail_st")	==null?"":request.getParameter("mail_st");
	
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")	==null?"0":request.getParameter("fee_opt_amt");
	String content_st 	= request.getParameter("content_st")	==null?"":request.getParameter("content_st");
	
	String reg_id 		= request.getParameter("write_id")	==null?"":request.getParameter("write_id");
	String est_email	= request.getParameter("est_email")	==null?"":request.getParameter("est_email");
	
	//월렌트견적서 관련
	String months 		= request.getParameter("months")	==null?"":request.getParameter("months");
	String days 		= request.getParameter("days")		==null?"":request.getParameter("days");
	String tot_rm 		= request.getParameter("tot_rm")	==null?"":request.getParameter("tot_rm");
	String tot_rm1 		= request.getParameter("tot_rm1")	==null?"":request.getParameter("tot_rm1");
	String per 			= request.getParameter("per")		==null?"":request.getParameter("per");
	String navi_yn 		= request.getParameter("navi_yn")	==null?"":request.getParameter("navi_yn");
	
	//재리스견적 여러건 한장보내기(20180808)
	String param1		= request.getParameter("param1")==null?"":request.getParameter("param1");
	String param2		= request.getParameter("param2")==null?"":request.getParameter("param2");
	String param3		= request.getParameter("param3")==null?"":request.getParameter("param3");
	String param4		= request.getParameter("param4")==null?"":request.getParameter("param4");
	String cust_info	= request.getParameter("cust_info")==null?"":request.getParameter("cust_info");
	
	String br_from		= request.getParameter("br_from")==null?"":request.getParameter("br_from");
	String br_to		= request.getParameter("br_to")==null?"":request.getParameter("br_to");
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns=”http://www.w3.org/1999/xhtml”>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>매일주소 입력하기</title>
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />


<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
<style type="text/css">
<!--
body.general		{ background-color:#FFFFFF; font-family: 굴림, Gulim, AppleGothic, Seoul, Arial; font-size: 9pt; }
.style2 		{ color: #515150; font-weight: bold; font-size:9pt; }
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
		
		if(fm.est_id.value == '') { alert('견적서가 선택되지 않았습니다. 메일발송이 안됩니다.'); return; }
		
		if(addr=="")			{ alert("메일주소를 입력해주세요!"); return; }		
		else if(addr.indexOf("@")<0)	{ alert("메일주소가 명확하지 않습니다!"); return; }

		fm.action = "send_mail.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//회신메일선택
	function cng_input(){
		var fm = document.form1;
		if(fm.replyto_st[0].checked == true || fm.replyto_st[1].checked == true){ 	//회사||개인
			tr_replyto.style.display='none';
		}else{										//직접입력
			tr_replyto.style.display='';				
		}
	}		
//-->
</script>
</head>

<body onLoad="document.form1.mail_addr.focus();">
<form name="form1" method="post" action="">
<input type="hidden" name="from_page" 	value="<%=from_page %>">
<input type="hidden" name="est_id" 		value="<%=est_id %>">
<input type="hidden" name="acar_id" 	value="<%=acar_id %>">
<input type="hidden" name="mail_st" 	value="<%=mail_st %>">
<input type="hidden" name="opt_chk" 	value="<%=opt_chk%>">
<input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">
<input type="hidden" name="content_st" 	value="<%=content_st %>">
<input type="hidden" name="reg_id" 		value="<%=reg_id %>">
<input type="hidden" name="months" 		value="<%=months%>">
<input type="hidden" name="days" 		value="<%=days%>">
<input type="hidden" name="tot_rm" 		value="<%=tot_rm%>">
<input type="hidden" name="tot_rm1" 	value="<%=tot_rm1%>">
<input type="hidden" name="per" 		value="<%=per%>">
<input type="hidden" name="navi_yn" 	value="<%=navi_yn%>">
<input type="hidden" name="param1" 		value="<%=param1%>">
<input type="hidden" name="param2" 		value="<%=param2%>">
<input type="hidden" name="param3" 		value="<%=param3%>">
<input type="hidden" name="param4" 		value="<%=param4%>">
<input type="hidden" name="cust_info" 	value="<%=cust_info%>">
<input type="hidden" name="br_from" 	value="<%=br_from%>">
<input type="hidden" name="br_to" 		value="<%=br_to%>">

<table width=440 border=0 cellspacing=0 cellpadding=0>
    <tr>
	<td bgcolor=#9acbe1 height=5></td>
    </tr>
    <tr>
	<td height=20></td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/mail_1.gif alt='견적서 이메일보내기'></td>
    </tr>
    <tr>
	<td height=10></td>
    </tr>
    <tr>
    	<td align=center>
    	    <table width=392 border=0 cellspacing=0 cellpadding=0 background=/acar/images/center/mail_bg.gif>
    		<tr>
    		    <td><img src=/acar/images/center/mail_up.gif></td>
    		</tr>
    		<tr>
    		    <td height=20></td>
    		</tr>
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/mail_2.gif alt='수신'></td>
    		</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>이메일주소 &nbsp;<input type="text" name="mail_addr" size="30" onKeydown="javascript:EnterDown()" value='<%=est_email%>' style='IME-MODE: inactive'></span></td>
    		</tr>
    		<tr>
    		    <td height=30></td>
    		</tr>
    		<%if(!acar_id.equals("") && !from_page.equals("mrent_list.jsp")){%>
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/mail_3.gif alt='회신'></td>
    		</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>
    		<tr>
		    <td align=center>
			<table width=350 border=0 cellspacing=0 cellpadding=0>
			    <tr>
			        <td>
			            <span class=style2>
			                &nbsp;&nbsp;<input type='radio' name="replyto_st" value='1' onClick="javascript:cng_input()" checked > 회사메일
			                &nbsp;&nbsp;<input type='radio' name="replyto_st" value='2' onClick="javascript:cng_input()" > 사용자등록메일
			                &nbsp;&nbsp;<input type='radio' name="replyto_st" value='3' onClick="javascript:cng_input()" > 직접입력
			            </span>
			        </td>
			    </tr>
			    <tr id='tr_replyto' style='display:none'>
			        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			            <input type="text" name="replyto" size="27" onKeydown="javascript:EnterDown()" value=''>
			        </td>
			    </tr>
			</table>
		    </td>
		</tr>	
    		<tr>
    		    <td height=30></td>
    		</tr>    						
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/mail_4.gif alt='담당자메모'></td>
    		</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>
    		<tr>
    		    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="memo" cols="45" rows="10"></textarea></td>
    		</tr>			
    		<tr>
    		    <td height=7></td>
    		</tr>
    		<tr>
    		    <td height=7><hr></td>
    		</tr>
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="file_add_yn1" value="Y"> 체크시 [개인신용정보 조회동의] 파일을 첨부한다.</td>
    		</tr>
    		<%}%>
		<tr>
    		    <td height=20></td>
    		</tr>
    		<tr>
    		    <td><img src=/acar/images/center/mail_dw.gif></td>
    		</tr>
    	    </table>
    	</td>
    </tr>
    <tr>
    	<td height=10></td>
    </tr>
    <tr>
    	<td align=center><a href="javascript:send_mail();"><img src=/acar/images/center/mail_btn_send.gif border="0" alt='보내기'></a></td>
    </tr>   
</table>


</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>




</body>
</html>

