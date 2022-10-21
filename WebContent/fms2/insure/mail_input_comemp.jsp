<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.client.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	CarMgrBean rent_mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "계약담당자");
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//고객관련자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
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
body.general		{ background-color:#FFFFFF; font-family: 굴림, Gulim, AppleGothic, Seoul, Arial; font-size: 9pt;}
.style2 		{ color: #515150; font-weight: bold; font-size:9pt;}
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
	//이메일주소 점검
	function isEmail(str) {
		// regular expression? 지원 여부 점검
		var supported = 0;
		if (window.RegExp) {
			var tempStr = "a";
			var tempReg = new RegExp(tempStr);
			if (tempReg.test(tempStr)) supported = 1;
		}
		if (!supported) return (str.indexOf(".") > 2) && (str.indexOf("@") > 0);
		var r1 = new RegExp("(@.*@)|(\\.\\.)|(@\\.)|(^\\.)");
		var r2 = new RegExp("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$");
		return (!r1.test(str) && r2.test(str));
	}


	//길이구하기
	function get_length(f) {
		var max_len = f.length;
		var len = 0;
		for(k=0;k<max_len;k++) {
			t = f.charAt(k);
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}
		return len;
	}
	
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') send_mail();
	}

	//메일수신하기
	function send_mail(){
		var fm = document.form1;
		var addr = fm.mail_addr.value;
		
		if(fm.rent_l_cd.value == '') 	{ alert('계약서가 선택되지 않았습니다. 메일발송이 안됩니다.'); 	return; }
		
		if(isEmail(addr)==false)	{ alert("올바른 이메일주소를 입력해주세요"); 			return; }		
				
		if(addr=="" || addr=="@")	{ alert("메일주소를 입력해주세요!"); 				return; }		
		if(addr.indexOf("@")<0)		{ alert("메일주소가 명확하지 않습니다!"); 			return; }
		if(addr.indexOf(".")<0)		{ alert("메일주소가 명확하지 않습니다!"); 			return; }
		if(get_length(addr) < 5)	{ alert("메일주소가 명확하지 않습니다!"); 			return; }
		
		if(fm.replyto_st[0].checked == false && fm.replyto.value == 'cont@amazoncar.co.kr'){ alert('cont 메일계정은 최종적으로 당사에 전달하면 보관/관리하는 메일입니다. 다른메일주소를 입력해주세요.'); return; }
						
		fm.action = "mail_send_comemp.jsp";
		//fm.target = "_self";
		fm.target = "i_no";
		fm.submit();
	}
	
	//수신메일주소 셋팅
	function mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.s_mail_addr.options[fm.s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split 	= i_mail_addr.split("||");
			fm.mail_addr.value 	= i_mail_addr_split[0];
			fm.tel_number.value 	= i_mail_addr_split[1];
		}else{
			fm.mail_addr.value 	= '';
			fm.tel_number.value 	= '';
		}
	}			
//-->
</script>

</head>

<body onLoad="document.form1.mail_addr.focus();">
<form name="form1" method="post" action="">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="user_id" value="<%=ck_acar_id%>">



<table width=440 border=0 cellspacing=0 cellpadding=0>
    <tr>
	<td bgcolor=#9acbe1 height=5></td>
    </tr>
    <tr>
	<td height=20></td>
    </tr>
    <!--
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/acar/images/center/mail_renew.gif></td>
    </tr>
    -->
    <tr>
	<td height=10></td>
    </tr>
    <tr>
    	<td align=center>
    	    <table width=392 border=0 cellspacing=0 cellpadding=0 background=http://fms1.amazoncar.co.kr/acar/images/center/mail_bg.gif>
    		<tr>
    		    <td><img src=http://fms1.amazoncar.co.kr/acar/images/center/mail_up.gif></td>
    		</tr>
    		<tr>
    		    <td height=20></td>
    		</tr>
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/acar/images/center/mail_2.gif></td>
    		</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    		        <img src=http://fms1.amazoncar.co.kr/acar/images/center/mail_arrow.gif> &nbsp;
    			<span class=style2>
    			<select name="s_mail_addr"  onChange='javascript:mail_addr_set();'>
			    <option value="">선택</option>
        		    <%if(!client.getCon_agnt_email().equals("")){%>
        		    <option value="<%=client.getCon_agnt_email()%>||<%=client.getCon_agnt_m_tel()%>">[세금계산서] <%=client.getCon_agnt_email()%> <%=client.getCon_agnt_nm()%></option>
        		    <%}%>
        		    <%if(!site.getAgnt_email().equals("")){%>
        		    <option value="<%=site.getAgnt_email()%>||<%=site.getAgnt_m_tel()%>">[지점세금계산서] <%=site.getAgnt_email()%> <%=site.getAgnt_nm()%></option>
        		    <%}%>
        		    <%for(int i = 0 ; i < mgr_size ; i++){
        			CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        			if(!mgr.getMgr_email().equals("")){%>
        		    <option value="<%=mgr.getMgr_email()%>||<%=mgr.getMgr_m_tel()%>" <%if(mgr.getMgr_st().equals("계약담당자")){%>selected<%}%>>[<%=mgr.getMgr_st()%>] <%=mgr.getMgr_email()%> <%=mgr.getMgr_nm()%></option>
        		    <%}}%>	        				
        		</select>
        	<tr>
        		<td align=center height=30>
        		<img src=http://fms1.amazoncar.co.kr/acar/images/center/renew_line.gif align=center>
        		</td>
        	</tr>
        	<tr>
        		<td>
    			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    			이메일주소 &nbsp;<input type="text" name="mail_addr" size="33" value='<%=rent_mgr.getMgr_email()%>' style='IME-MODE: inactive'>
    			<!--
    			<br><br>
    			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    			휴대폰번호 &nbsp;<input type="text" name="tel_number" size="33" value='<%=rent_mgr.getMgr_m_tel()%>'>
    			</span>    			
    			-->
    			<input type="hidden" name="tel_number" value="">
    		    </td>
    		</tr>
    		<tr>
    		    <td height=30></td>
    		</tr>    			
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/acar/images/center/mail_3.gif></td>
    		</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>
    		<tr>
		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		  	
			<span class=style2>&nbsp;&nbsp;<input type='radio' name="replyto_st" value='2' checked > 사용자등록메일</span>
			<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span class=style2>&nbsp;&nbsp;<input type='radio' name="replyto_st" value='3' > 직접입력 : </span>
			<input type="text" name="replyto" size="27" value=''>
		    </td>
		</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>
    		<tr>
    		    <td><img src=http://fms1.amazoncar.co.kr/acar/images/center/mail_dw.gif></td>
    		</tr>    		
	    </table>
	</td>
    </tr>	
    <tr>
    	<td height=20></td>
    </tr>    		
    <tr>
    	<td align=center><a href="javascript:send_mail();"><img src=http://fms1.amazoncar.co.kr/acar/images/center/mail_btn_send.gif border="0"></a></td>
    </tr>   
</table>

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>

