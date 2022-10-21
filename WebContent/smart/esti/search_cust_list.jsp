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
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	//견적고객찾기
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Vector vars = new Vector();
	
	if(!t_wd.equals("")){
		vars = e_db.getCustSubList(t_wd);
	}
	
	int size = vars.size();
%>


<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.action = 'search_cust_list.jsp';
		fm.submit();
	}
		
	function setCode(st, nm, ssn, tel, fax, reg_dt, doc_type, est_email, spr_kd, spr_kd_rent_dt){
		var fm = opener.document.form1;				
		fm.est_nm.value 	= nm;
		fm.est_ssn.value 	= ssn;
		fm.est_tel.value 	= tel;
		fm.est_fax.value 	= fax;
		fm.doc_type.value 	= doc_type;
		fm.est_email.value 	= est_email;
		var spr1 = '';
		var spr2 = '';
		if(spr_kd == '2') spr1 = '초우량';
		if(spr_kd == '1') spr1 = '우량';
		if(spr_kd == '0') spr1 = '일반기업';
		if(spr_kd == '3') spr1 = '신설기업';
		if(fm.spr_yn.value == '2') spr2 = '초우량';
		if(fm.spr_yn.value == '1') spr2 = '우량';
		if(fm.spr_yn.value == '0') spr2 = '일반기업';
		if(fm.spr_yn.value == '3') spr2 = '신설기업';
		if(spr1 != '' && spr1 != '초우량' && spr1 != spr2){
			sure = confirm('가장 최근에 입력된 신차 계약('+spr_kd_rent_dt+')의 신용도가 ['+spr1+']입니다. \n견적시 참고하시기 바랍니다. \n\n현재 작성중인 ['+spr2+']견적으로 계속 견적하시겠습니까?');
		}	
		//if(spr_kd == '2') alert('최근 계약은 초우량기업입니다.');
		//if(spr_kd == '1') alert('최근 계약은 우량기업입니다.'); 
		//if(spr_kd == '0') alert('최근 계약은 일반기업입니다.'); 
		//if(spr_kd == '3') alert('최근 계약은 신설법인입니다.'); 		
		//if(spr_kd == '2' || spr_kd == '1' || spr_kd == '0' || spr_kd == '3'){
		//	fm.spr_yn.value 	= spr_kd;			
		//}
		self.close();
	}
	
	//거래처 연체금액
	function cl_dlyamt(client_id)
	{
		window.open('/acar/account/stat_settle_sc_in_view_sub_list_client.jsp?client_id='+client_id, "CLIENT_DLVAMT", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}	
//-->
</script>

<body onload="javascript:document.form1.t_wd.focus();"> 
<form name='form1' action='search_cust_list.jsp' method='post'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>    

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
				<option value="1" selected>검색어</option> 
			</select> 
			<input accesskey="s" class="keyword" title=검색어 type="text" name="t_wd" value="<%=t_wd%>" style='IME-MODE: active'> 
			<a onClick='javascript:window.search();' style='cursor:hand'><img src="/smart/images/btn_srch.gif" alt="검색" value="검색"></a>
		</fieldset> 
		</div>
		<br>	
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">신차견적고객</div>
    	<div id="ctable">		
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
    		    <%	if(size >10) size = 10; %>						
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<th valign=top><%=i+1%></th>
							<td valign=top><a href="javascript:setCode('1', '<%=var.get("EST_NM")%>', '<%=var.get("EST_SSN")%>', '<%=var.get("EST_TEL")%>', '<%=var.get("EST_FAX")%>', '<%=var.get("REG_DT")%>', '<%=var.get("DOC_TYPE")%>', '<%=var.get("EST_EMAIL")%>', '', '');"><%=var.get("EST_NM")%></a>
								&nbsp;<%=var.get("EST_SSN")%>
								&nbsp;<%=var.get("EST_TEL")%>
								&nbsp;<%=var.get("EST_EMAIL")%>
								&nbsp;<%=var.get("REG_DT")%></td>
						</tr>
              		<%}%>								
					<%if(size==0){%>								
						<tr>
							<th>데이타가 없습니다.</th>
						</tr>
					<%}%>					
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
	<%	if(!t_wd.equals("")){
				vars = e_db.getSpeCustSubList(t_wd);
			}
			size = vars.size();%>
    		    <%	if(size >10) size = 10; %>				
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">스폐셜견적고객</div>
    	<div id="ctable">		
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<th valign=top><%=i+1%></th>
							<td valign=top><a href="javascript:setCode('2', '<%=var.get("EST_NM")%>', '<%=var.get("EST_SSN")%>', '<%=var.get("EST_TEL")%>', '<%=var.get("EST_FAX")%>', '<%=var.get("REG_DT")%>', '<%=var.get("DOC_TYPE")%>', '<%=var.get("EST_EMAIL")%>', '', '');"><%=var.get("EST_NM")%></a>
								&nbsp;<%=var.get("EST_SSN")%>
								&nbsp;<%=var.get("EST_TEL")%>
								&nbsp;<%=var.get("EST_EMAIL")%>
								&nbsp;<%=var.get("REG_DT")%></td>
						</tr>
              		<%}%>								
					<%if(size==0){%>								
						<tr>
							<th>데이타가 없습니다.</th>
						</tr>
					<%}%>					
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
		<%	if(!t_wd.equals("")){
				//신차고객
				//vars = e_db.getLcCustSprSubList("1", t_wd);
				vars = e_db.getLcCustSubList(t_wd);
			}
			size = vars.size();%>
    		    <%	if(size >5) size = 5; %>	
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">장기고객</div>
    	<div id="ctable">		
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);
    					Hashtable s_ht = new Hashtable();
   						//신차고객
   						s_ht = e_db.getLcCustSprSubCase("1", String.valueOf(var.get("CLIENT_ID")));
   						String spr_kd = "";
   						String spr_kd_rent_dt = "";
    					if(!String.valueOf(s_ht.get("SPR_KD")).equals("") && !String.valueOf(s_ht.get("SPR_KD")).equals("null")){
    						spr_kd = String.valueOf(s_ht.get("SPR_KD"));
    						spr_kd_rent_dt = String.valueOf(s_ht.get("RENT_DT"));
              			}
   						
    				%>							
						<tr>
							<th valign=top><%=i+1%></th>
							<td valign=top><a href="javascript:setCode('3', '<%=var.get("EST_NM")%>', '<%=var.get("EST_SSN")%>', '<%=var.get("EST_TEL")%>', '<%=var.get("EST_FAX")%>', '<%=var.get("REG_DT")%>', '<%=var.get("DOC_TYPE")%>', '<%=var.get("EST_EMAIL")%>', '<%=spr_kd%>', '<%=spr_kd_rent_dt%>');"><%=var.get("EST_NM")%></a>
								&nbsp;<%=var.get("EST_SSN")%>
								&nbsp;<%=var.get("EST_TEL")%>
								&nbsp;<%=var.get("EST_EMAIL")%>
								&nbsp;<%=var.get("REG_DT")%>
								&nbsp;<a href="javascript:cl_dlyamt('<%=var.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
							</td>
						</tr>
              		<%}%>
					<%if(size==0){%>								
						<tr>
							<th>데이타가 없습니다.</th>
						</tr>
					<%}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>	
		<%	if(!t_wd.equals("")){
				vars = e_db.getEmpSubList(t_wd);
			}
			size = vars.size();%>
    		    <%	if(size >5) size = 5; %>	
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">영업사원</div>
    	<div id="ctable">		
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<th valign=top><%=i+1%></th>
							<td valign=top><a href="javascript:setCode('4', '<%=var.get("EST_NM")%>', '<%=var.get("EST_SSN")%>', '<%=var.get("EST_TEL")%>', '<%//=var.get("EST_FAX")%>', '<%=var.get("REG_DT")%>', '<%=var.get("DOC_TYPE")%>', '<%=var.get("EST_EMAIL")%>', '', '');"><%=var.get("EST_NM")%></a>
								&nbsp;<%=AddUtil.subDataCut(var.get("EST_SSN")+"",7)%>
								&nbsp;<%=var.get("EST_TEL")%>
								&nbsp;<%=var.get("EST_EMAIL")%>
								&nbsp;<%=var.get("REG_DT")%></td>
						</tr>
              		<%}%>
					<%if(size==0){%>								
						<tr>
							<th>데이타가 없습니다.</th>
						</tr>
					<%}%>
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