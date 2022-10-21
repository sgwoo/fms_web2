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
#contents {float:left; width:100%; height:100%;}
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
.contents_box th {color:#282828; width:90px; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}





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

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.cont.*, acar.insur.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
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
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(!base.getCar_mng_id().equals("")){
		//보험정보
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}
%>

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
			<div id="gnb_login"><%=car_no%></div>
			<div id="gnb_home">
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">보험계약</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
				    		<th>보험회사</th>
				    		<td><%=ins.getIns_com_nm()%></td>							
				    	</tr>
						<tr>
							<th>피보험자</th>
							<td><%=ins.getCon_f_nm()%></td>
						</tr>
						<tr>
				    		<th>계약자</th>
				    		<td><%=ins.getConr_nm()%></td>
				    	</tr>
						<tr>
				    		<th>보험기간</th>
				    		<td><%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>~<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%></td>
				    	</tr>
						<tr>
				    		<th>보험종류</th>
				    		<td><%String car_use = ins.getCar_use();%><%if(car_use.equals("1")){%>영업용<%}else if(car_use.equals("2")){%>업무용<%}else if(car_use.equals("3")){%>개인용<%}%></td>
				    	</tr>
				    	<tr>
				    		<th>운전자연령</th>
				    		<td><%String age_scp = ins.getAge_scp();%><%if(age_scp.equals("2")){%>26세이상<%}else if(age_scp.equals("4")){%>24세이상<%}else if(age_scp.equals("1")){%>21세이상<%}else if(age_scp.equals("5")){%>30세이상<%}else if(age_scp.equals("6")){%>35세이상<%}else if(age_scp.equals("7")){%>43세이상<%}else if(age_scp.equals("8")){%>48세이상<%}else if(age_scp.equals("3")){%>모든운전자<%}%></td>
				    	</tr>
				    	<tr>
				    		<th>에어백/장치</th>
				    		<td><%if(ins.getAir_ds_yn().equals("Y")){%>운전석<%}%>
								<%if(ins.getAir_as_yn().equals("Y")){%> 조수석<%}%>
								<%if(ins.getAuto_yn().equals("Y")){%> 자동변속기<%}%>
								<%if(ins.getAbs_yn().equals("Y")){%> ABS장치<%}%>
							</td>
				    	</tr>						
					</table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">청약사항</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>대인배상Ⅰ</th>
							<td>자배법 시행령에서 정한 금액</td>
						</tr>
						<tr>
				    		<th>대인배상Ⅱ</th>
				    		<td><%	if(ins.getVins_pcp_kd().equals("1")) 		out.println("무한");
									else if(ins.getVins_pcp_kd().equals("2")) 	out.println("유한");%></td>
				    	</tr>
						<tr>
				    		<th>대물배상</th>
				    		<td><%	if(ins.getVins_gcp_kd().equals("6")) 		out.println("5억원");
									else if(ins.getVins_gcp_kd().equals("7")) 	out.println("2억원");
									else if(ins.getVins_gcp_kd().equals("3")) 	out.println("1억원");
									else if(ins.getVins_gcp_kd().equals("4")) 	out.println("5000만원");
									else if(ins.getVins_gcp_kd().equals("1")) 	out.println("3000만원");
									else if(ins.getVins_gcp_kd().equals("2")) 	out.println("1500만원");
									else if(ins.getVins_gcp_kd().equals("5")) 	out.println("1000만원");%>
									</td>
				    	</tr>
						<tr>
				    		<th>자기신체사고</th>
				    		<td>사망/장해
								<%	if(ins.getVins_bacdt_kd().equals("1")) 			out.println("3억원");
									else if(ins.getVins_bacdt_kd().equals("2")) 	out.println("1억5천만원");
									else if(ins.getVins_bacdt_kd().equals("6")) 	out.println("1억원");
									else if(ins.getVins_bacdt_kd().equals("5")) 	out.println("5000만원");
									else if(ins.getVins_bacdt_kd().equals("3")) 	out.println("3000만원");
									else if(ins.getVins_bacdt_kd().equals("4")) 	out.println("1500만원");%>
								/ 부상
								<%	if(ins.getVins_bacdt_kc2().equals("1")) 		out.println("3억원");
									else if(ins.getVins_bacdt_kc2().equals("2")) 	out.println("1억5천만원");
									else if(ins.getVins_bacdt_kc2().equals("6")) 	out.println("1억원");
									else if(ins.getVins_bacdt_kc2().equals("5")) 	out.println("5000만원");
									else if(ins.getVins_bacdt_kc2().equals("3")) 	out.println("3000만원");
									else if(ins.getVins_bacdt_kc2().equals("4")) 	out.println("1500만원");%>								
							</td>
				    	</tr>
						<tr>
				    		<th>무보험차상해</th>
				    		<td><%	if(ins.getVins_canoisr_amt()>0) 	out.println("가입");
									else 								out.println("미가입");%></td>
				    	</tr>
						<tr>
				    		<th>자기차량손해</th>
				    		<td><%	if(ins.getVins_cacdt_cm_amt()>0) 	out.println("가입");
									else 								out.println("미가입");%></td>
				    	</tr>
						<tr>
				    		<th>자차면책금</th>
				    		<td><%=AddUtil.parseDecimal(base.getCar_ja())%>원 (아마존카)</td>
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
</body>
</html>
