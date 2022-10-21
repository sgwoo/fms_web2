<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	String gubun = "";
	String gu_nm = "";
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun") != null)	gubun = request.getParameter("gubun");
	if(request.getParameter("gu_nm") != null)	gu_nm = request.getParameter("gu_nm");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");	
		
	CarOffEmpBean coe_r [] = umd.getCarOffEmpAll(gubun, gu_nm, sort_gubun, sort,"");
		
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String user_nm = login.getAcarName(user_id);
	String user_m_tel = login.getUser_m_tel(request, "acar_id");
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>

<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type="text/css">
<!--
.phonemsgbox {
	width:100px; height:84px;
	font-family:돋움체;
	font-size:9pt;
	overflow:hidden;
	border-style:none;
	border-top-width:0px;
	border-bottom-width:0px;
	background:none;
}

.phonemsglen {
	font-family:돋움체;
	font-size:9pt;
	overflow:hidden;
	border-style:none;
	border-top-width:0px;
	border-bottom-width:0px;
	background:none;
}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function SelText()
{
 	
	document.form1.txtMessage.msglen = 0;
}
//메시지 입력시 string() 길이 체크
function checklen()
{
	var msgtext, msglen;
	var maxlen = 0;
	
	msgtext = document.form1.txtMessage.value;
	msglen = document.form1.msglen.value;
	
	if(document.form1.auto_yn.checked == false){
		maxlen = 80;
	}else{
		maxlen = 58;
	}
	document.form1.maxmsglen.value = maxlen;
	
	var i=0,l=0;
	var temp,lastl;
	
	//길이를 구한다.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>maxlen)
		{
//			alert("메시지란에 허용 길이 이상의 글을 쓰셨습니다.\n 메시지란에는 한글 40자, 영문80자까지만 쓰실 수 있습니다.");
			alert("메시지란에 허용 길이 이상의 글을 쓰셨습니다.\n 메시지란에는 한글 "+(maxlen/2)+"자, 영문"+(maxlen)+"자까지만 쓰실 수 있습니다.");
			temp = document.form1.txtMessage.value.substr(0,i);
			document.form1.txtMessage.value = temp;
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}
	form1.msglen.value=l;
}

//발송명단검색화면띄우기
function open_search(){
	fm = document.form1;
	
	var SUBWIN = "";
		
	if(fm.gubun1[0].checked==true && fm.gubun2[0].checked==true){
		fm.action ="./target_search.jsp";
		window.open(SUBWIN, "target_search", "left=30, top=110, width=340, height=550, scrollbars=no");		
	}else if(fm.gubun1[0].checked==true && fm.gubun2[1].checked==true){
		fm.action ="./target_search2.jsp";
		window.open(SUBWIN, "target_search", "left=30, top=110, width=340, height=550, scrollbars=no");		
	}else if(fm.gubun1[2].checked==true){
		fm.action ="./target_search3.jsp";
		window.open(SUBWIN, "target_search", "left=30, top=110, width=340, height=550, scrollbars=no");				
	}else if(fm.gubun1[3].checked==true && fm.gubun2[2].checked==true){
		fm.action ="./target_excel.jsp";
		window.open(SUBWIN, "target_search", "left=30, top=110, width=800, height=600, scrollbars=yes");				
	}else if(fm.gubun1[3].checked==true && fm.gubun2[1].checked==true){
		alert('대상이 직접인 경우에는 명단을 검색하지 않습니다.');
		return;
	}else if(fm.gubun1[3].checked==true && fm.gubun2[0].checked==true){
		alert('대상이 직접인 경우에는 명단을 검색하지 않습니다.');
		return;
	}
	fm.target = "target_search";
	fm.submit();
}
//문자내용 발송하기
function send(){ 
	fm = document.form1;
	
	if(fm.txtMessage.value=="")	{
		alert("보낼 문자 내용을 입력해 주세요!!");
		fm.txtMessage.focus();
		return;
	}
	
	if(document.form1.auto_yn.checked == true){
		if(fm.user_pos.value==""){
			fm.msg.value = fm.txtMessage.value+"-아마존카 "+fm.s_bus[fm.s_bus.selectedIndex].text+"-";
		}else{
			fm.msg.value = fm.txtMessage.value+"-아마존카 "+fm.user_pos.value+" "+fm.s_bus[fm.s_bus.selectedIndex].text+"-";
		}
	}else{
			fm.msg.value = fm.txtMessage.value;	
	}		
	
	
	if(fm.gubun1[3].checked == true && fm.gubun2[2].checked==false){
	
		if(fm.destphone.value=="")	{
			alert("수신번호를 입력해 주세요!!");
			fm.destphone.focus();
			return;
		}
	
		if(!confirm("해당 문자내용을 발송하시겠습니까?"))	return;
		fm.target = "i_no";
		fm.action = "send_case.jsp";
		fm.submit();		
	
	}else{
		if(smsList.smsList_in.form1==null){
			alert("발송명단리스트가 없습니다.");
			return;
		}
		//체크한건이 없을경우
		cnt=0;
		for(i=0; i<smsList.smsList_in.form1.pr.length; i++){ 
			if(smsList.smsList_in.form1.pr[i].checked==true){
				cnt++;
				break;
			}
		}
		if(cnt<1){
			alert("발송할건을 체크해 주시기 바랍니다.");
			return;
		}	
		smsList.smsList_in.form1.sendname.value 	= fm.s_bus.value;
		smsList.smsList_in.form1.sendphone.value 	= fm.user_m_tel.value;
		smsList.smsList_in.form1.msg.value 			= fm.msg.value;		
		if(!confirm("해당 문자내용을 발송하시겠습니까?"))	return;
		smsList.smsList_in.form1.target = "i_no";
		smsList.smsList_in.form1.submit();		
	}

}

function getM_tel(){
	fm = document.form1;
	fm.target = "i_no";
	fm.action = "./getM_tel.jsp?user_id="+fm.s_bus[fm.s_bus.selectedIndex].value;
	fm.submit();
}
function open_result(){
	parent.d_content.location.href = "./sms_result_frame.jsp";
}

	function cng_input()
	{
		var fm = document.form1;
		if(fm.gubun1[3].checked == true){ //직접
			tr_destphone.style.display	= '';
			fm.total.value = '1';
		}else{
			tr_destphone.style.display	= 'none';
			fm.total.value = '';
		}
	}	

//재난재해통지 내용 발송하기
function send_accid(){ 
	fm = document.form1;
	
	if(fm.accidMessage.value=="")	{
		alert("보낼 문자 내용을 입력해 주세요!!");
		fm.accidMessage.focus();
		return;
	}
	
	var msgtext, msglen;
	var maxlen = 80;
	
	msgtext = document.form1.accidMessage.value;
		
	var i=0,l=0;
	var temp,lastl;
	
	//길이를 구한다.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>maxlen)
		{
			alert("메시지란에 허용 길이 이상의 글을 쓰셨습니다.\n 메시지란에는 한글 "+(maxlen/2)+"자, 영문"+(maxlen)+"자까지만 쓰실 수 있습니다.");
			temp = document.form1.accidMessage.value.substr(0,i);
			document.form1.accidMessage.value = temp;
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}

	fm.msg.value 	= fm.accidMessage.value;
	fm.mode.value 	= 'accid';
		
	if('<%=acar_br%>' != 'S1'){  alert('재난재해통지문자는 본사 직원만 해당됩니다.'); return; }
	
	if(!confirm("이 문자는 재난재해통지문자입니다. 맞습니까?"))							return;
	if(!confirm("해당 문자내용을 발송하시겠습니까?"))									return;
	if(!confirm("정말 발송하시겠습니까? 같은 내용으로 세번 발송됩니다. "))				return;
	if(!confirm("마지막으로 다시 한번 확인합니다. 정말 진짜로 발송하시겠습니까?"))		return;		
	
	fm.target = "i_no";
	fm.action = "send_accid_case.jsp";
	fm.submit();		
}	
//-->
</script>
</head>

<body leftmargin="15">
<form method="post" name="form1">
<input name="user_nm" type="hidden" value="<%= user_nm %>">
<input name="msg" type="hidden">
<input name="mode" type="hidden">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>SMS > <span class=style5>재난재해 SMS발송</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td width="230" valign="top" align=center>
	        <table width="100%" border="0" cellspacing="0" cellpadding="0">   
	            <tr>
	                <td></td>
	            </tr>     
                <tr>
                    <td>
                    &nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>재난재해통지</span>
                    </td>
                </tr>
                <tr>
                    <td style='height:5'></td>
                </tr>	
                <tr>
                    <td colspan="2" align=center>
                        <table width=198 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td style="height=181" background=/acar/images/sms_bg.gif align=center><br><br><br>
                                    &nbsp;&nbsp;<textarea name="accidMessage" rows=4 cols=18 value="" style="ime-mode:active;" class=default>파천교 침수위험.문자수신 즉시 파천교 집결-<%=user_nm%>-</textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=198 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td style=height=8 background=/acar/images/sms_bg3.gif colspan=3></td>
                                        </tr>
                                        <tr align=right>
                                            <td colspan=3><a href="javascript:send_accid();" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image4','','/acar/images/sms_button_1.gif',1)><img src=/acar/images/sms_button.gif name=Image4 border=0></a></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 align=right><img src=/acar/images/sms_3.gif></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>    
                    </td>
                </tr>
                <tr>
                    <td align=center>
                    (발송명단상세검색 안해도 됩니다.)
                    </td>		
            </table>
	    </td>
        <td width="6">&nbsp;</td>
        <td width="600" valign="top"><!--<iframe src="./sms_list.jsp" name="smsList" width="600" height="550" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>--></td>
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
