<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String est_email= request.getParameter("est_email")==null?"":request.getParameter("est_email");
	String content_st = request.getParameter("content_st")==null?"":request.getParameter("content_st");
	
	String print_type = request.getParameter("print_type")==null?"":request.getParameter("print_type");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	System.out.println("/acar/apply/select_mail_input.jsp");
	System.out.println("user_id="+user_id);	
	System.out.println("print_type="+print_type);	
	System.out.println("from_page="+from_page);	
	System.out.println("vid="+request.getParameterValues("ch_l_cd"));	
	
	System.out.println(content_st);
			
	if(String.valueOf(request.getParameterValues("ch_l_cd")).equals("") || String.valueOf(request.getParameterValues("ch_l_cd")).equals("null")){
		out.println("선택된 견적이 없습니다.");
		return;
	}
				
	String vid[] = request.getParameterValues("ch_l_cd");
	int vid_size = vid.length;
	
	if(from_page.equals("esti_mng_atype_u.jsp")){
		if(print_type.equals("2") || print_type.equals("3") || print_type.equals("4")){
			vid_size = 1;	
		}		
	}	
	
	System.out.println("[다중견적 메일주소 입력하기] user_id = "+user_id);
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	EstimateBean e_bean = new EstimateBean();
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

		fm.action = "select_send_mail.jsp";
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

<body onLoad="document.form1.mail_addr.focus();">
<form name="form1" method="post" action="">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="est_size" value="<%= vid_size %>">
<%	for(int i=0; i < vid_size; i++){
		String est_id = vid[i];
		if(i==0){
			e_bean = e_db.getEstimateCase(est_id);
			if(est_email.equals("")){
				est_email = e_bean.getEst_email();
			}
		}
			%>
<input type="hidden" name="est_id" value="<%= est_id %>">
<%	}%>
<input type="hidden" name="content_st" value="<%= content_st %>">
<input type="hidden" name="from_page" value="<%= from_page %>">
<input type="hidden" name="rent_st" value="<%= rent_st %>">

<table width=440 border=0 cellspacing=0 cellpadding=0>
	<tr>
		<td bgcolor=#9acbe1 height=5></td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
    <tr>
        <td>
        	<img src=/acar/images/center/mail_1.gif style="padding-left: 60px;">
        </td>
    </tr>
    <tr>
		<td height=10></td>
	</tr>
    <tr>
    	<td align=center>
    		<table width=392 border=0 cellspacing=0 cellpadding=0 background=/acar/images/center/mail_bg.gif>
    			<tr>
    				<td>
    					<img src=/acar/images/center/mail_up.gif>
    				</td>
    			</tr>
    			<tr>
    				<td height=20></td>
    			</tr>
    			<tr>
    				<td>
    					<img src=/acar/images/center/mail_2.gif style="padding-left: 32px;">
    				</td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr>
    				<td>
    					<img src=/acar/images/center/mail_arrow.gif style="padding-left: 40px;">
    					&nbsp;<span class=style2>이메일주소 &nbsp;<input type="text" name="mail_addr" size="30" onKeydown="javascript:EnterDown()" value='<%=est_email%>' style='IME-MODE: inactive'></span>
    				</td>
    			</tr>
    			<tr>
    				<td height=30></td>
    			</tr>
    			<tr>
    				<td>
    					<img src=/acar/images/center/mail_3.gif style="padding-left: 32px;">
    				</td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr>
			        <td align=center>
				        <table width=350 border=0 cellspacing=0 cellpadding=0>
				            <tr>
				                <td colspan='3'>
								  	<span class=style2>
									&nbsp;&nbsp;<input type='radio' name="replyto_st" value='1' onClick="javascript:cng_input()" checked > 회사메일
									</span>
				        		</td>
				        	</tr>
				        	<tr>
				        		<td colspan='3'>
				        			<span class=style2>
				        			&nbsp;&nbsp;<input type='radio' name="replyto_st" value='2' onClick="javascript:cng_input()" > 사용자등록메일
				        			</span>
				        		</td>
				        	</tr>
				        	<tr>
				        		<td colspan='3'>
					        		<table width=350 border=0 cellspacing=0 cellpadding=0>
					        			<tr>
					        				<td>
					        					<span class=style2>
					        					&nbsp;&nbsp;<input type='radio' name="replyto_st" value='3' onClick="javascript:cng_input()" > 직접입력 
					        					</span>
											</td>
					        				<td id='tr_replyto' style='display:none'>
					        					<input type="text" name="replyto" size="27" onKeydown="javascript:EnterDown()" value=''>
					        				</td>
					        			</tr>
					        		</table>
								</td>
				            </tr>
				        </table>
			        </td>
			    </tr>  
    			<tr>
    				<td height=30></td>
    			</tr>    						
    			<tr>
    				<td>
    					<img src=/acar/images/center/mail_4.gif style="padding-left: 32px;">
    				</td>
    			</tr>
    			<tr>
    				<td height=7></td>
    			</tr>
    			<tr>
    				<td style="text-align: center;">
    					<textarea name="memo" cols="45" rows="10"></textarea>
    				</td>
    			</tr>
	    		<tr>
	    		    <td height=7></td>
	    		</tr>
	    		<tr>
	    		    <td height=7><hr></td>
	    		</tr>
	    		<tr>
	    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    		    	<input type="checkbox" name="file_add_yn1" value="Y"> <span class=style2>체크시 [개인신용정보 조회동의] 파일을 첨부한다.</span>
	    		    </td>
	    		</tr>
	    		<tr>
	    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    		    	<input type="checkbox" name="file_add_yn2" value="Y"> <span class=style2> 체크시 [사업자등록증] 파일을 첨부한다.</span>
	    		    </td>
	    		</tr>
	
				<tr>
	   				<td height=20></td>
	   			</tr>
	   			<tr>
	   				<td>
	   					<img src=/acar/images/center/mail_dw.gif>
	   				</td>
	   			</tr>
    		</table>
    	</td>
    </tr>
    <tr>
    	<td height=10></td>
    </tr>
    <tr>
    	<td align=center>
    		<a href="javascript:send_mail();">
    			<img src=/acar/images/center/mail_btn_send.gif border="0">
    		</a>
    	</td>
    </tr>   
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>
