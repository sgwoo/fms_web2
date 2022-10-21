<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 

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
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}


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
.contents_box td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:18px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font:13px; margin:5px 5px;}
.contents_box1 th {color:#282828; width:115px; height:26px; text-align:left; font-weight:bold;}
.contents_box1 td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //계약건수
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	if(firm_nm.equals("")) firm_nm = client.getFirm_nm();
%>

<style type=text/css>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #828282;
         font-size: 11px;}
.style2 {color: #ff00ff;
         font-size: 11px;} 
.style3 {color: #727272}
.style4 {color: #ef620c}
.style5 {color: #334ec5;
        font-weight: bold;} 
-->

</style>


<script language='javascript'>
<!--
	function view_sitemap()
	{
		var fm = document.form1;	
		fm.action = "sitemap.jsp";		
		fm.submit();
	}					
//-->
</script>

</head>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>		

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login"><span title='<%=firm_nm%>'><%=AddUtil.subData(firm_nm, 10)%></span></div>
			<div id="gnb_home">
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle"><%if(st.equals("2")){%>사업장별 고객정보(법인본점)<%}else{%>고객 기본정보(법인본점)<%}%></div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th valign=top>고객구분</th>
							<td valign=top><%if(client.getClient_st().equals("1")) 	out.println("법인");
                      			else if(client.getClient_st().equals("2"))  out.println("개인");
                      			else if(client.getClient_st().equals("3")) 	out.println("개인사업자");
                      			else if(client.getClient_st().equals("4"))	out.println("개인사업자");
                      			else if(client.getClient_st().equals("5")) 	out.println("개인사업자");
        						else if(client.getClient_st().equals("6")) 	out.println("경매장");%></td>
						</tr>						
						<%if(client.getClient_st().equals("2")){//개인%>				
						<tr>
							<th valign=top>성명</th>
							<td valign=top><font color=#fd5f00><%=client.getFirm_nm()%></font></td>
						</tr>						
						<tr>
							<th valign=top>생년월일</th>
							<td valign=top><%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******<%//=client.getSsn2()%></td>
						</tr>						
						<tr>
							<th valign=top>자택주소</th>
							<td valign=top><%=client.getHo_zip()%> <%=client.getHo_addr()%></td>
						</tr>						
						<tr>
							<th valign=top>휴대폰번호</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getM_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getM_tel())%></font></a></td>
						</tr>						
						<tr>
							<th valign=top>전화(자택)</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getH_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getH_tel())%></font></a></td>
						</tr>						
						
						<%}else{//법인,개인사업자%>	
						<%		if(client.getClient_st().equals("1")){//법인%>	
						<tr>
							<th valign=top>법인규모</th>
							<td valign=top><%	if(client.getFirm_st().equals("1")) 		out.println("대기업");
                	               	else if(client.getFirm_st().equals("2"))	out.println("중기업");
                					else if(client.getFirm_st().equals("3"))	out.println("소기업");
                					else if(client.getFirm_st().equals("4"))	out.println("크레탑미등재");%>
                	               	&nbsp;<%if(client.getEnp_yn().equals("Y")) 	out.println("대기업");%> 
                				    &nbsp;<%= client.getEnp_nm()%> &nbsp;<%if(client.getEnp_yn().equals("Y")) 	out.println("계열사");%></td>
						</tr>						
						<tr>
							<th valign=top>법인형태</th>
							<td valign=top><%if(client.getFirm_type().equals("1")) 		out.println("유가증권시장");
            	              	 else if(client.getFirm_type().equals("2")) 	out.println("코스닥상장");
            	              	 else if(client.getFirm_type().equals("3"))   	out.println("외감법인");
            	              	 else if(client.getFirm_type().equals("4"))   	out.println("벤처기업");
            	              	 else if(client.getFirm_type().equals("5"))   	out.println("일반법인");
            	              	 else if(client.getFirm_type().equals("6"))   	out.println("국가");
            	              	 else if(client.getFirm_type().equals("7"))   	out.println("지방자치단체");
            	              	 else if(client.getFirm_type().equals("8"))   	out.println("정부투자기관");
            	              	 else if(client.getFirm_type().equals("9"))		out.println("정부출연연구기관");
            	              	 else if(client.getFirm_type().equals("10"))	out.println("비영리법인");
								 else if(client.getFirm_type().equals("11"))	out.println("면세법인");
            	              	 %></td>
						</tr>						
						<tr>
							<th valign=top>설립일자</th>
							<td valign=top><%= client.getFound_year()%></td>
						</tr>						
						<%		}%>			
						<tr>
							<th valign=top>개업년월일</th>
							<td valign=top><%= client.getOpen_year()%></td>
						</tr>						
						<tr>
							<th valign=top>성명</th>
							<td valign=top><font color=#fd5f00><%=client.getFirm_nm()%></font></td>
						</tr>						
						<tr>
							<th valign=top>대표자</th>
							<td valign=top><%=client.getClient_nm()%></td>
						</tr>						
						<tr>
							<th valign=top>사업자등록번호</th>
							<td valign=top><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
						</tr>
						<%		if(client.getClient_st().equals("1")){//법인%>			
						<tr>
							<th valign=top>법인등록번호</th>
							<td valign=top><%=client.getSsn1()%>-<%=client.getSsn2()%></td>
						</tr>		
						<tr>
							<th valign=top>사업장소재지</th>
							<td valign=top><%=client.getO_zip()%> <%=client.getO_addr()%></td>
						</tr>						
						<tr>
							<th valign=top>본점 소재지</th>
							<td valign=top><%=client.getHo_zip()%> <%=client.getHo_addr()%></td>
						</tr>																							
						<%		}else{%>			
						<tr>
							<th valign=top>생년월일</th>
							<td valign=top><%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******<%//=client.getSsn2()%></td>
						</tr>													
						<tr>
							<th valign=top>사업장소재지</th>
							<td valign=top><%=client.getO_zip()%> <%=client.getO_addr()%></td>
						</tr>						
						<%		}%>
						<tr>
							<th valign=top>업태</th>
							<td valign=top><%= client.getBus_cdt()%></td>
						</tr>						
						<tr>
							<th valign=top>종목</th>
							<td valign=top><%= client.getBus_itm()%></td>
						</tr>	
						<%		if(client.getClient_st().equals("1")){//법인%>			
						<tr>
							<th valign=top>대표자 구분</th>
							<td valign=top><%	if(client.getRepre_st().equals("1")) 		out.println("지배주주");
            	                   	else if(client.getRepre_st().equals("2"))	out.println("전문경영인");%></td>
						</tr>												
						<tr>
							<th valign=top>대표자 생년월일</th>
							<td valign=top><%if(!client.getRepre_ssn1().equals("")){%><%=client.getRepre_ssn1()%>-<%if(client.getRepre_ssn2().length() > 1){%><%=client.getRepre_ssn2().substring(0,1)%><%}%>******<%//=client.getRepre_ssn2()%><%}%></td>
						</tr>																		
						<%		}%>
						<tr>
							<th valign=top>대표자 주소</th>
							<td valign=top><%=client.getRepre_zip()%> <%=client.getRepre_addr()%><%if(client.getRepre_zip().equals("")){%><%=client.getHo_zip()%> <%=client.getHo_addr()%><%}%></td>
						</tr>												
						<tr>
							<th valign=top>대표자 휴대번호</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getM_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getM_tel())%></font></a></td>
						</tr>						
						<tr>
							<th valign=top>대표자 전화(자택)</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getH_tel())%>"><%=AddUtil.phoneFormat(client.getH_tel())%></a></td>
						</tr>						
						<tr>
							<th valign=top>전화(사무실)</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getO_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getO_tel())%></font></a></td>
						</tr>						
						<tr>
							<th valign=top>FAX(사무실)</th>
							<td valign=top><%=AddUtil.phoneFormat(client.getFax())%></td>
						</tr>																
						<%}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div> 
		<%if(client.getClient_st().equals("2")){//개인%>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle">소득정보</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>직업</th>
							<td><%=client.getJob()%></td>
						</tr>
						<tr>
				    		<th>소득구분</th>
				    		<td><%if(client.getPay_st().equals("1")) 		out.println("급여소득");
            	              	else if(client.getPay_st().equals("2"))    out.println("사업소득");
            	               	else if(client.getPay_st().equals("3"))	out.println("기타사업소득");%></td>
				    	</tr>
				    	<tr>
				    		<th>직장명</th>
				    		<td><%=client.getCom_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th>부서명</th>
				    		<td><%=client.getDept()%></td>
				    	</tr>
				    	<tr>
				    		<th>직위</th>
				    		<td><%=client.getTitle()%></td>
				    	</tr>
				    	<tr>
				    		<th>전화(사무실)</th>
				    		<td><a href="tel:<%=AddUtil.phoneFormat(client.getO_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getO_tel())%></font></a></td>
				    	</tr>
				    	<tr>
				    		<th>FMS(사무실)</th>
				    		<td><%=AddUtil.phoneFormat(client.getFax())%></td>
				    	</tr>
				    	<tr>
				    		<th>직장주소</th>
				    		<td><%=client.getComm_zip()%> <%=client.getComm_addr()%></td>
				    	</tr>
				    	<tr>
				    		<th>근속연수</th>
				    		<td><%=client.getWk_year()%>년</td>
				    	</tr>
				    	<tr>
				    		<th>연소득</th>
				    		<td><%=client.getPay_type()%>만원</td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
		<%}%>		
		<%if(st.equals("2") && site_seq.equals("00")){%>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">세금계산서담당자</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="80px">성명</th>
							<td><%=client.getCon_agnt_nm()%></td>
						</tr>
						<tr>
							<th>부서</th>
							<td><%=client.getCon_agnt_dept()%></td>
						</tr>
						<tr>
							<th>직위</th>
							<td><%=client.getCon_agnt_title()%></td>
						</tr>
						<tr>
							<th>휴대폰번호</th>
							<td><a href="tel:<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%></font></a></td>
						</tr>
						<tr>
							<th>전화(사무실)</th>
							<td><a href="tel:<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%></font></a></td>
						</tr>
						<tr>
							<th>FAX(사무실)</th>
							<td><%=AddUtil.phoneFormat(client.getCon_agnt_fax())%></td>
						</tr>
						<tr>
							<th>이메일</th>
							<td><a href="mailto:<%=client.getCon_agnt_email()%>"><%=client.getCon_agnt_email()%></a></td>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>			
		<%	//고객관계자
			Vector vt = al_db.getClientMgrList(client_id, "00");
			int vt_size = vt.size();
		%>	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">차량이용자</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<%	for(int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								if(String.valueOf(ht.get("MGR_NM1")).equals("미등록 ")) continue;%>	
						<tr>						
							<th width="70px"><%=ht.get("CAR_NO")%></th>
							<td width="90px"><%=ht.get("MGR_NM1")%></td>
							<td><a href="tel:<%=ht.get("MGR_TEL1")%>"><font color=#fd5f00><%=ht.get("MGR_TEL1")%></font></a></td>
						</tr>
						<%	}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>			
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">차량담당자</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<%	for(int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								if(String.valueOf(ht.get("MGR_NM2")).equals("미등록 ")) continue;%>	
						<tr>						
							<th width="70px"><%=ht.get("CAR_NO")%></th>
							<td width="90px"><%=ht.get("MGR_NM2")%></td>
							<td><a href="tel:<%=ht.get("MGR_TEL2")%>"><font color=#fd5f00><%=ht.get("MGR_TEL2")%></font></a></td>
						</tr>
						<%	}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>		
		<div id="ctitle">회계담당자</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<%	for(int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								if(String.valueOf(ht.get("MGR_NM3")).equals("미등록 ")) continue;%>	
						<tr>						
							<th width="70px"><%=ht.get("CAR_NO")%></th>
							<td width="90px"><%=ht.get("MGR_NM3")%></td>
							<td><a href="tel:<%=ht.get("MGR_TEL3")%>"><font color=#fd5f00><%=ht.get("MGR_TEL3")%></font></a></td>
						</tr>
						<%	}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>											
		<div id="ctitle">계약담당자</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<%	for(int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								if(String.valueOf(ht.get("MGR_NM4")).equals("미등록 ")) continue;%>	
						<tr>						
							<th width="70px"><%=ht.get("CAR_NO")%></th>
							<td width="90px"><%=ht.get("MGR_NM4")%></td>
							<td><a href="tel:<%=ht.get("MGR_TEL4")%>"><font color=#fd5f00><%=ht.get("MGR_TEL4")%></font></a></td>
						</tr>
						<%	}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>						
		<%}%>
	</div>	
    <div id="footer"></div>  
</div>
</form>
</body>
</html>
