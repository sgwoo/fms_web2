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
#cbtn { text-align:center; margin:15px 0 0 0;}




</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.* "%>
<%@ page import="acar.client.*, acar.cus_sch.*, acar.cus0402.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	CusSch_Database cs_db = CusSch_Database.getInstance();
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String seq 			= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	Cycle_vstBean cvBn = cs_db.getCycle_vst(client_id, seq);
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function VstUpd()
	{
		var fm = document.form1;		
		fm.action = "client_vst_reg.jsp";	
		fm.target = "_self";	
		fm.submit();
	}			
	
	function VstDel()
	{
		var fm = document.form1;	
		
		if(!confirm('삭제하시겠습니까?')){			return; }
		if(!confirm('정말로 삭제하시겠습니까?')){	return; }		
		
		fm.cmd.value = 'd';	
		fm.action = "client_vst_reg_a.jsp";	
		fm.target = "i_no";	
		fm.submit();
	}				
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "nreg_main.jsp";	
		//if(fm.from_page.value == 'client_vst_reg.jsp')	fm.action = "nreg_main.jsp";	
		fm.target = "_self";	
		fm.submit();
	}			
//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='seq' 		value='<%=seq%>'>	
	<input type='hidden' name='from_page' 	value='<%=from_page%>'>		
	<input type='hidden' name='cmd' 		value=''>	

	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">거래처방문보기</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">고객정보</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>상호/성명</th>
							<td valign=top><font color=#fd5f00><%=client.getFirm_nm()%></font></td>
						</tr>
						<%if(client.getClient_st().equals("1")){%>
						<tr>
							<th valign=top>대표자</th>
							<td valign=top><%=client.getClient_nm()%></td>
						</tr>
						<%}%>
						<tr>
							<th valign=top>사업장주소</th>
							<td valign=top><%=client.getO_zip()%> <%=client.getO_addr()%></td>
						</tr>
						<tr>
							<th valign=top>전화(사무실)</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getO_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getO_tel())%></font></a></td>
						</tr>
						<tr>
							<th valign=top>전화(자택)</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getH_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getH_tel())%></font></a></td>
						</tr>
						<tr>
							<th valign=top>휴대번호</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getM_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getM_tel())%></font></a></td>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">방문내용</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="70">방문일자</th>
				    		<td><%=cvBn.getVst_dt()%></td>
				    	</tr>	
				    	<tr>
				    		<th>방문자</th>
				    		<td><%=c_db.getNameById(cvBn.getVisiter(),"USER")%></td>
				    	</tr>	
				    	<tr>
				    		<th>방문목적</th>
				    		<td><%=cvBn.getVst_title()%></td>
				    	</tr>	
						<tr>
							<th>상담자</th>
							<td><%=cvBn.getSangdamja()%></td>
						</tr>											
						<tr>
							<th>상담내용</th>
							<td><%=cvBn.getVst_cont()%></td>
						</tr>											
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>								
			
	</div>
	<div id="cbtn">
		<a href="javascript:VstUpd();"><img src=/smart/images/btn_modify.gif align=absmiddle border=0></a>
		&nbsp;
		<a href="javascript:VstDel();"><img src=/smart/images/btn_del.gif align=absmiddle border=0></a>
	</div>	
	<div id="footer"></div>  
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
