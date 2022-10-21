<%@ page contentType="text/html; charset=euc-kr" language="java" %>

<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");	
	String gu_nm 		= request.getParameter("gu_nm")		==null?"":request.getParameter("gu_nm");		

	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");	
	
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");
	String client_id 	= request.getParameter("client_id")	==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")	==null?"":request.getParameter("firm_nm");
	String m_tel 		= request.getParameter("m_tel")		==null?"":request.getParameter("m_tel");

	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_nm 		= login.getSessionValue(request, "USER_NM");
	String user_m_tel 	= login.getUser_m_tel(user_id);

	String msg = "";
	
	
	//영업담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style type="text/css">
<!--
	.phonemsgbox {
		width:100px; height:105px;
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
		msglen 	= document.form1.msglen.value;
		
		if(document.form1.auto_yn.checked == false){
			maxlen = 80;
		}else{
			maxlen = 58;
		
			if(document.form1.user_pos.value==""){
				msgtext = msgtext+"-아마존카 "+document.form1.s_bus[document.form1.s_bus.selectedIndex].text+"-";
			}else{
				msgtext = msgtext+"-아마존카 "+document.form1.user_pos.value+" "+document.form1.s_bus[document.form1.s_bus.selectedIndex].text+"-";
			}		
		}
		maxlen = 2000;
		
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
				temp = document.form1.txtMessage.value.substr(0,i);
				document.form1.txtMessage.value = temp;
				l = lastl;
				break;
			}
			lastl = l;
			i++;
		}
		
		form1.msglen.value=l;
	
		var msg_cnt = Math.floor(l/80);
		if(l%80 != 0) msg_cnt++;
		form1.msg_cnt.value=msg_cnt;	
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
		}else if(fm.gubun1[3].checked==true && fm.gubun2[4].checked==true){
			fm.action ="./target_input.jsp";
			window.open(SUBWIN, "target_search", "left=30, top=110, width=700, height=700, scrollbars=yes");				
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
	
	
		//직접 개별발송
		if(fm.gubun1[3].checked == true &&  ( fm.gubun2[1].checked==true || fm.gubun2[3].checked==true || fm.gubun2[5].checked==true  || fm.gubun2[6].checked==true  ) ){
			if(fm.destphone.value=="")	{
				alert("수신번호를 입력해 주세요!!");
				fm.destphone.focus();
				return;
			}
	
			if(!confirm("해당 문자내용을 발송하시겠습니까?"))	return;
			fm.target = "i_no";				
			fm.action = "send_case.jsp";
			fm.submit();		
	
		//조회 일괄발송
		}else{
			if(smsList.smsList_in.form1==null){
				alert("발송명단리스트가 없습니다.");
				return;
			}
			
			//체크한건이 없을경우
			cnt=0;
			if(fm.total.value == '1'){
			}else{
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
			}
			
			smsList.smsList_in.form1.sendname.value 	= fm.s_bus.value;
			smsList.smsList_in.form1.sendphone.value 	= fm.user_m_tel.value;
			smsList.smsList_in.form1.msg.value 		= fm.msg.value;		
			smsList.smsList_in.form1.req_dt.value 		= fm.req_dt.value;		
			smsList.smsList_in.form1.req_dt_h.value 	= fm.req_dt_h.value;		
			smsList.smsList_in.form1.req_dt_s.value 	= fm.req_dt_s.value;		
		
			if(fm.gubun1[0].checked == true)	smsList.smsList_in.form1.gubun1.value 	= "1";			
			if(fm.gubun1[1].checked == true)	smsList.smsList_in.form1.gubun1.value 	= "2";			
			if(fm.gubun1[2].checked == true)	smsList.smsList_in.form1.gubun1.value 	= "3";			
			if(fm.gubun1[3].checked == true)	smsList.smsList_in.form1.gubun1.value 	= "4";			
		
			if(fm.gubun2[0].checked == true)	smsList.smsList_in.form1.gubun2.value 	= "1";			
			if(fm.gubun2[1].checked == true)	smsList.smsList_in.form1.gubun2.value 	= "2";			
			if(fm.gubun2[2].checked == true)	smsList.smsList_in.form1.gubun2.value 	= "3";			
			if(fm.gubun2[3].checked == true)	smsList.smsList_in.form1.gubun2.value 	= "4";			
			if(fm.gubun2[4].checked == true)	smsList.smsList_in.form1.gubun2.value 	= "5";		
			if(fm.gubun2[5].checked == true)	smsList.smsList_in.form1.gubun2.value 	= "6";	

			if(fm.msg_type[1].checked == true) 	smsList.smsList_in.form1.msg_type.value = "5";				
		
			if(!confirm("해당 문자내용을 발송하시겠습니까?"))	return;
			
			smsList.smsList_in.form1.target = "i_no";			
			smsList.smsList_in.form1.submit();				
			//action = send_list.jsp
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
			tr_destname.style.display	= '';
			fm.total.value = '1';
		}else{
			tr_destphone.style.display	= 'none';
			tr_destname.style.display	= 'none';
			fm.total.value = '';
		}
	}
	
	function cng_bank_no()
	{
		var fm = document.form1;
	
		if(fm.gubun2[3].checked == true){ // 계좌번호
			tr_destphone.style.display	= '';
			tr_destname.style.display	= '';
			fm.total.value = '1';
			fm.txtMessage.value= '계좌는 신한 140-004-023863 외환 028-22-08080-7 입니다';		
		} else	if(fm.gubun2[6].checked == true){ // 계좌번호
				tr_destphone.style.display	= '';
				tr_destname.style.display	= '';
				fm.total.value = '1';
				fm.txtMessage.value= '[차량번호 인식 다운로드] \r\r https://client.amazoncar.co.kr/mobile/app-debug.apk';						
		} else if(     (fm.gubun2[1].checked == true && fm.gubun1[3].checked == true) || (fm.gubun2[5].checked == true  && fm.gubun1[3].checked == true )){ //직접-개별
			tr_destphone.style.display	= '';
			tr_destname.style.display	= '';
			fm.total.value = '1';
		
		}else{
			tr_destphone.style.display	= 'none';
			tr_destname.style.display	= 'none';
			fm.total.value = '';
			fm.txtMessage.value= '';
		}
		if(fm.gubun2[5].checked == true){
			viewSmsMsg('park');	
		}
	}		
	
	//주차장 안내 문자
	function viewSmsMsg(gubun){

		var SUBWIN="/fms2/con_fee/view_sms_msg_car.jsp?msg_gubun="+gubun;	
		window.open(SUBWIN, "ViewSmsMsg", "left=100, top=100, width=850, height=300, scrollbars=yes, status=yes");
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
	
		if(!confirm("이 문자는 재난재해통지문자입니다. 맞습니까?"))				return;
		if(!confirm("해당 문자내용을 발송하시겠습니까?"))					return;
		if(!confirm("정말 발송하시겠습니까? 같은 내용으로 세번 발송됩니다. "))			return;
		if(!confirm("마지막으로 다시 한번 확인합니다. 정말 진짜로 발송하시겠습니까?"))		return;		
	
		fm.target = "i_no";
		fm.action = "send_case.jsp";
		fm.submit();		
	}	
//-->
</script>

<script language="JavaScript" type="text/JavaScript">
<!--
	function MM_swapImgRestore() { //v3.0
  		var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_preloadImages() { //v3.0
  		var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

	function MM_findObj(n, d) { //v4.01
  		var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  		if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  		for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  		if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function MM_swapImage() { //v3.0
  		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
//-->
</script>

</head>

<body leftmargin="15">
<form method="post" name="form1">
<input name="user_nm" 	type="hidden" value="<%= user_nm %>">
<input name="rent_l_cd" type="hidden" value="<%= rent_l_cd %>">
<input name="client_id" type="hidden" value="<%= client_id %>">
<input name="firm_nm" 	type="hidden" value="<%= firm_nm %>">
<input name="msg" 	type="hidden">
<input name="mode" 	type="hidden">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>SMS > <span class=style5>SMS발송</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td colspan=10><span class=style4>※ [아마존카 직급 성명 문자내용에 자동삽입]이 선택되었을 경우 총byte에 해당 byte가 추가되어 표시됩니다.</span>
					  <br>
					  <span class=style4>※ 단문자는 80byte 단위로 분할되어 전송됩니다. 장문자는 2000byte이내 문자열을 전송합니다.</span>
					  <br>
					  <span class=style4>※ 문자발송가능 번호(보내는사람 번호)에 등록되지 않은 번호는 문자발송이 제한됩니다. 본사 류길선 과장에게 등록요청 해주세요.</span></td>
    </tr>		
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td width="194" valign="top">
	        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
    		            <table width="194" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="2" align="left"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>발송명단 검색</span></td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
            				        <table width="194" border="0" cellspacing="0" cellpadding="0">
            				            <tr>
                                            <td class=line2></td>
                                        </tr>
                    					<tr>
                    					    <td class="line">
                    					        <table width="194" border="0" cellspacing="1" cellpadding="0">
                        						    <tr>
                        						        <td width="87" class="title">대상</td>
                        							    <td class="title">방식</td>
                        						    </tr>
                    						        <tr>
                    							        <td width="100">
                            							    <table width="100" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td width="17">&nbsp;</td>
                                                                  <td width="82"><input type='radio' name='gubun1' value='1' onClick="javascript:cng_input()">
                                                                      영업사원</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td>&nbsp;</td>
                                                  		 <td><input type='radio' name='gubun1' value='2' disabled>
                                                                     계약자</td>
                                                                </tr>
                                                                <tr>
                                                                  <td>&nbsp;</td>
                                                                  <td><input type='radio' name='gubun1' value='3' onClick="javascript:cng_input()">
                                                                      당사직원</td>
                                                                </tr>
                                                                <tr>
                                                                  <td>&nbsp;</td>								
                                                                  <td><input type='radio' name='gubun1' value='4' onClick="javascript:cng_input()" checked> 
                                                                      직접</td>
                                                                </tr>
                                                                <tr>
                                                                  <td>&nbsp;</td>
                                                                  <td>&nbsp;</td>
                                                                </tr>
                                                            </table>
                    							        </td>
                    							        <td width="94">
                            							    <table width="94" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td width="11">&nbsp;</td>
                                                                  <td width="82"><input type='radio' name='gubun2' value='1' onClick="javascript:cng_bank_no()">
                                                                      조직</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td>&nbsp;</td>
                                                                  <td><input type='radio' name='gubun2' value='2' checked onClick="javascript:cng_bank_no()">
                                                                      개별</td>
                                                                </tr>
                                                                <tr>
                                                                  <td>&nbsp;</td>
                                                                  <td><input type='radio' name='gubun2' value='3'onClick="javascript:cng_bank_no()">
                                                                      엑셀</td>
                                                                </tr>
                                                                <tr>
                                                                  <td>&nbsp;</td>								
                                                                   <td><input type='radio' name='gubun2' value='4' onClick="javascript:cng_bank_no()">
                                                                      입금계좌</td>
                                                                </tr>
                                                                <tr>
                                                                  <td>&nbsp;</td>
                                                                  <td><input type='radio' name='gubun2' value='5' onClick="javascript:cng_bank_no()">
																			작성</td>
                                                                </tr>
                                                                <tr>
                                                                  <td>&nbsp;</td>
                                                                  <td><input type='radio' name='gubun2' value='6' onClick="javascript:cng_bank_no()">
																			주차장</td>
                                                                </tr>
                                                                <tr>
                                                                  <td>&nbsp;</td>
                                                                  <td><input type='radio' name='gubun2' value='7' onClick="javascript:cng_bank_no()">
																		주차어플 다운</td>
                                                                </tr>
                                                            </table>
                    							        </td>
                    						        </tr>
                    						    </table>
                    					    </td>
                    					</tr>
                    					<tr> 
                    					    <td colspan="2" style="height:10"><img src="/images/blank.gif" width="10" height="10"></td>
                    					</tr>						  
                    					<tr>
                    					    <td align="center"><a href="javascript:open_search();"><img src=/acar/images/center/button_search_bsmd.gif align=absmiddle border=0></a></td>
                    					</tr>
            				        </table>
            				    </td>
                            </tr>			
                            <tr>
                                <td colspan="2" style="height:10"><img src="/images/blank.gif" width="10" height="10"></td>
                            </tr>						  			  
                            <tr>
                                <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>문자발송내용</span></td>
                            </tr>	
                            <tr>
                                <td style='height:5'></td>
                            </tr>	
                            <tr>
                                <td colspan="2">
                                    <table width=198 border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td style="height=221" background=/acar/images/sms_bg.gif align=center><br><br><br><br>
                                                <textarea class="phonemsgbox" name="txtMessage" rows=5 cols=6 value="" onClick="SelText()" onKeyUp="javascript:checklen()" style="ime-mode:active;"><%=msg%></textarea><br>
                                                <input class="phonemsglen" type="text" name="msglen" size="2" maxlength="2" readonly value=0>
                                                <font style="font-size:9pt">
						<!--/<input class="phonemsglen" type="text" name="maxmsglen" size="2" maxlength="2" readonly value='58'>--> 
						byte</font>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=198 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td style=height=3 background=/acar/images/sms_bg3.gif colspan=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=28 background=/acar/images/sms_bg1.gif>&nbsp;</td>
                                                        <td width=48 style="background-color:e9e9e9; height:20;"><img src=/acar/images/sms_icon1.gif width=7 height=10> <span class=style8>직급</span> </td>
                                                        <td width=122 background=/acar/images/sms_bg2.gif>
                                                        <select name="user_pos" onChange="javascript:checklen();">
                                            		      <option value="">없음</option>
                                            		      <option value="사장">사장</option>
                                            		      <option value="부장">부장</option>
                                            		      <option value="차장">차장</option>
                                            		      <option value="과장">과장</option>
                                            		      <option value="대리">대리</option>
                                            		      <option value="사원">사원</option>
                                                        </select></td>
                                                    </tr>
                                                    <tr>
                                                        <td background=/acar/images/sms_bg3.gif style="height=2" colspan=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td background=/acar/images/sms_bg1.gif>&nbsp;</td>
                                                        <td style="background-color:e9e9e9; height:20;"><img src=/acar/images/sms_icon2.gif width=8 height=10> <span class=style8>담당자</span></td>
                                                        <td background=/acar/images/sms_bg2.gif>
                                                        <select name='s_bus' onChange="javascript:getM_tel(); checklen();">
                                                          <option value="">=선택=</option>
                                                          <%	if(user_size > 0){
                                            						for (int i = 0 ; i < user_size ; i++){
                                            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                                                          <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                                                              <%		}
                                            					}		%>
                                                        </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 background=/acar/images/sms_bg3.gif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name="auto_yn" value='Y' checked onClick="javascript:checklen()"><font style="font-size:7pt">아마존카 직급 성명 문자내용에<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자동삽입</font></td>
                                                    </tr>
                                                    <tr>
                                                        <td style=height=4 background=/acar/images/sms_bg3.gif colspan=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 style=height=3><img src=/acar/images/sms_1.gif width=198 height=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td style=height=2 background=/acar/images/sms_bg3.gif colspan=3></td>
                                                    </tr>
													<tr id='tr_destname' style="display:''">
                                                        <td background=/acar/images/sms_bg1.gif>&nbsp;</td>
                                                        <td style="background-color:e9e9e9; height:20;"><span class=style8>수신자명</span></td>
                                                        <td background=/acar/images/sms_bg2.gif><input type="text" name="destname" size="15" class="text" value="<%=firm_nm%>"></td>
                                                    </tr>													
                                                    <tr id='tr_destphone' style="display:''">
                                                        <td background=/acar/images/sms_bg1.gif>&nbsp;</td>
                                                        <td style="background-color:e9e9e9; height:20;"><span class=style8>수신번호</span></td>
                                                        <td background=/acar/images/sms_bg2.gif><input type="text" name="destphone" size="15" class="text" value="<%=m_tel%>"></td>
                                                    </tr>
                                                    <tr>
                                                        <td background=/acar/images/sms_bg1.gif>&nbsp;</td>
                                                        <td style="background-color:e9e9e9; height:20;"><span class=style8>회신번호</span></td>
                                                        <td background=/acar/images/sms_bg2.gif><input type="text" name="user_m_tel" size="15" class="text" value="<%= user_m_tel %>"></td>
                                                    </tr>
                                                    <tr>
                                                        <td background=/acar/images/sms_bg1.gif>&nbsp;</td>
                                                        <td style="background-color:e9e9e9; height:20;"><span class=style8>예약일시</span></td>
                                                        <td background=/acar/images/sms_bg2.gif><input type="text" name="req_dt" size="12" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'>
														<br>
					  									<select name="req_dt_h">
                        									<%for(int i=0; i<24; i++){%>
                        									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        									<%}%>
                      									</select>
                      									<select name="req_dt_s">
                        									<%for(int i=0; i<59; i+=5){%>
                        									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        									<%}%>
                     									 </select>
														</td>
                                                    </tr>
                                                    <tr>
                                                        <td background=/acar/images/sms_bg1.gif>&nbsp;</td>
                                                        <td style="background-color:e9e9e9; height:20;"><span class=style8>수신자</span></td>
                                                        <td background=/acar/images/sms_bg2.gif><input type="text" name="total" size="5" class="num" value="1" readonly="true" >
                                                        <span class=style8>명</span></td>
                                                    </tr>
																										
                                                    <tr>
                                                        <td background=/acar/images/sms_bg1.gif>&nbsp;</td>
                                                        <td style="background-color:e9e9e9; height:20;"><span class=style8>문자타입</span></td>
                                                        <td background=/acar/images/sms_bg2.gif><input type="radio" name="msg_type" value="0" checked>단문
														<input class="default" type="text" name="msg_cnt" size="2" readonly value=0>건
														<br>
														<input type="radio" name="msg_type" value="5">장문
														</td>
                                                    </tr>													
																										
                                                    <tr>
                                                        <td colspan=3 style=height=4 background=/acar/images/sms_bg3.gif></td>
                                                    </tr>
                                                    <tr align=right>
                                                        <td colspan=3><a href="javascript:send();" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image4','','/acar/images/sms_button_1.gif',1)><img src=/acar/images/sms_button.gif name=Image4 border=0></a></td>
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
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td width="6">&nbsp;</td>
        <td width="600" valign="top"><iframe src="./sms_list.jsp" name="smsList" width="600" height="700" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
</table>
</form>
<script language="JavaScript">
<!--
	checklen();
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
