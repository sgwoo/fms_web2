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
.contents_box {width:100%; table-layout:fixed; font-size:14px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:18px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font-size:14px; margin:5px 5px;}
.contents_box1 th {color:#282828; width:115px; height:26px; text-align:left; font-weight:bold;}
.contents_box1 td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font-size:16px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_register.*, acar.fee.*, acar.credit.*, acar.insur.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase" scope="page"/>
<jsp:useBean id="ac_db" class="acar.credit.AccuDatabase" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
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
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//자동차등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	

	
	if(!base.getCar_mng_id().equals("")){
		//보험정보
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}
	
	//차량회수일
	String reco_dt =  ac_db.getClsRecoDt(rent_mng_id, rent_l_cd);
	
	//대여정보
	ContFeeBean fee = new ContFeeBean();
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	
	String fee_rent_start_dt[] 	= new String [fee_size];
	String fee_rent_end_dt[] 	= new String [fee_size];
	String fee_rent_dt[] 		= new String [fee_size];
	String fee_ext_agnt[] 		= new String [fee_size];
	String fee_rent_way[] 		= new String [fee_size];
	String fee_prv_dlv_yn[]		= new String [fee_size];
	
	for(int i=0; i<fee_size; i++){
		ContFeeBean fee_bean = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(i+1));
		
		fee_rent_start_dt[i] 	= fee_bean.getRent_start_dt();
		fee_rent_end_dt[i] 		= fee_bean.getRent_end_dt();
		fee_rent_dt[i]	 		= fee_bean.getRent_dt();
		fee_ext_agnt[i] 		= fee_bean.getExt_agnt();
		fee_rent_way[i] 		= fee_bean.getRent_way();
		fee_prv_dlv_yn[i]		= fee_bean.getPrv_dlv_yn();
		
		if(i+1 == fee_size) fee = fee_bean;
	}
	
	//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
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
			<div id="gnb_login">									
				<%if(car_no.equals("미등록")){%><%//=rent_l_cd%><%=car_nm%><%}else{%><%=car_no%><%}%>
			</div>
			<div id="gnb_home">
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">	
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">주요일정</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>계 약 일 자</th>
							<td><%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
						</tr>
						<tr>
				    		<th>출 고 일 자</th>
				    		<td><%=AddUtil.ChangeDate2(base.getDlv_dt())%></td>
				    	</tr>
				    	<tr>
				    		<th>등 록 일 자</th>
				    		<td><%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
				    	</tr>
						<!--
				    	<tr>
				    		<th>차량인도일</th>
				    		<td><%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%></td>
				    	</tr>
						-->
						<%if(1!=1){%>
						<%if(fee_prv_dlv_yn[0].equals("Y")){%>
						<%		if(!taecha.getCar_rent_st().equals("") && !taecha.getCar_rent_et().equals("null")){%>
				    	<tr>
				    		<th>지연 대여개시일</th>
				    		<td><%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
				    	</tr>
						<%		}%>						
						<%		if(!taecha.getCar_rent_et().equals("") && !taecha.getCar_rent_et().equals("null")){%>
				    	<tr>
				    		<th>지연 대여만료일</th>
				    		<td><%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
				    	</tr>
						<%		}%>
						<%}%>
						<%}%>
				    	<tr>
				    		<th>대여개시일</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_start_dt[0])%></td>
				    	</tr>
						<%if(fee_size==1){%>
				    	<tr>
				    		<th>대여만료일</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_end_dt[0])%></td>
				    	</tr>
						<%}else{%>
				    	<tr>
				    		<th>대여만료일</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_end_dt[fee_size-1])%></td>
				    	</tr>
						<%}%>
						<%if(1!=1){%>
						<%for(int i=1; i<fee_size; i++){%>
				    	<tr>
				    		<th><%=i+1%>차연장 계약일자</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_dt[i])%></td>
				    	</tr>
				    	<tr>
				    		<th><%=i+1%>차연장 대여개시일</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_start_dt[i])%></td>
				    	</tr>
				    	<tr>
				    		<th><%=i+1%>차연장 대여만료일</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_end_dt[i])%></td>
				    	</tr>						
						<%}%>
						<%}%>
				    	<tr>
				    		<th>차량반납일</th>
				    		<td><%=AddUtil.ChangeDate2(reco_dt)%></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<!--계약승계정보-->
		
		<!--계약승계정보-->
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">관리구분</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>차 량 구 분</th>
							<td><%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
						</tr>
						<!--
						<tr>
							<th>계 약 구 분</th>
							<td><%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
						</tr>
						-->
						<tr>
				    		<th>영 업 구 분</th>
				    		<td><%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
				    	</tr>
				    	<tr>
				    		<th>관 리 구 분</th>
				    		<td><font color=#fd5f00><%String rent_way = fee_rent_way[0];%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}else if(rent_way.equals("2")){%>맞춤식<%}%></font></td>
				    	</tr>
				    	<tr>
				    		<th>최초영업자</th>
				    		<td><%=c_db.getNameById(base.getBus_id(),"USER")%></td>
				    	</tr>
						<!--
				    	<tr>
				    		<th>영업담당자</th>
				    		<td><%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
				    	</tr>
						-->
				    	<tr>
				    		<th>관리담당자</th>
				    		<td><%=c_db.getNameById(base.getMng_id(),"USER")%><%if(base.getMng_id().equals("")){%><%=c_db.getNameById(base.getBus_id2(),"USER")%><%}%></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">대여료</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=95px>이 용 기 간</th>
							<td><%=AddUtil.ChangeDate2(fee.getRent_start_dt())%> ~ <%=AddUtil.ChangeDate2(fee.getRent_end_dt())%></td>
						</tr>
						<%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
						<tr>
				    		<th>신 용 등 급</th>
				    		<td><%String dec_gr = cont_etc.getDec_gr();%><%if(dec_gr.equals("3")){%>신설법인<%}else if(dec_gr.equals("0")){%>일반고객<%}else if(dec_gr.equals("1")){%>우량기업<%}else if(dec_gr.equals("2")){%>초우량기업<%}%></td>
				    	</tr>
				    	<tr>
				    		<th>연 대 보 증</th>
				    		<td>대표 <%String client_guar_st = cont_etc.getClient_guar_st();%><%if(client_guar_st.equals("1")){%>입보<%}else if(client_guar_st.equals("2")){%>면제<%}%>
							<%if(!cont_etc.getGuar_st().equals("")){%>
					    		/ 대표외 <%String guar_st = cont_etc.getGuar_st();%><%if(guar_st.equals("1")){%>입보<%}else if(guar_st.equals("2")){%>면제<%}%>
							<%}%>
							</td>
				    	</tr>
						<!--
				    	<tr>
				    		<th>보 &nbsp;&nbsp;증 &nbsp;&nbsp;금</th>
				    		<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원</td>
				    	</tr>
						-->
				    	<tr>
				    		<th>선 &nbsp;&nbsp;수 &nbsp;&nbsp;금</th>
				    		<td><%if(fee.getGrt_amt_s()>0){%>보증금 <%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원<%}%>
								<%if(fee.getGrt_amt_s()>0 && fee.getPp_s_amt()>0){%><br><%}%>
								<%if(fee.getPp_s_amt()>0){%>선수금 <%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>원<%}%>
								<%if(fee.getGrt_amt_s()+fee.getPp_s_amt()>0 && fee.getIfee_s_amt()>0){%><br><%}%>
								<%if(fee.getIfee_s_amt()>0){%>개시대여료 <%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>원<%}%>
							</td>
				    	</tr>
						<!--
				    	<tr>
				    		<th>개시대여료</th>
				    		<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>원</td>
				    	</tr>
						-->
				    	<tr>
				    		<th>월 대 여 료</th>
				    		<td><font color=#fd5f00><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원</font></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<%if(im_vt_size>0){%>
			<div id="carrow"><img src=/smart/images/arrow.gif /></div>
			<div id="ctitle">임의연장</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
       		  		<%	for(int i = im_vt_size-1 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>					
						<tr>
							<th width=125px>회차</th>
							<td><%=im_ht.get("ADD_TM")%>회차</td>
						</tr>
						<tr>
				    		<th>대여기간</th>
				    		<td><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
				    	</tr>
        		 	<%	} %>						
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
		<%}%>
			<div id="carrow"><img src=/smart/images/arrow.gif /></div>
			<div id="ctitle">기타</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=125px>중도해지위약금</th>
							<td><%=fee.getCls_r_per()%>%</td>
						</tr>
				    	<tr>
				    		<th>매&nbsp;&nbsp;&nbsp;입&nbsp;&nbsp;&nbsp;옵&nbsp;&nbsp;&nbsp;션</th>
				    		<td><%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>원</td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">보험</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=110px>보 험 회 사</th>
							<td><%=ins.getIns_com_nm()%></td>
						</tr>
						<tr>
							<th>보험 계약자</th>
							<td><%=ins.getConr_nm()%></td>
						</tr>
						<tr>
							<th>피 보 험 자</th>
							<td><%=ins.getCon_f_nm()%></td>
						</tr>
						<tr>
				    		<th>계 &nbsp;&nbsp;약 &nbsp;&nbsp;자</th>
				    		<td><%=ins.getConr_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th>운전자연령</th>
				    		<td><%String age_scp = ins.getAge_scp();%><%if(age_scp.equals("2")){%>26세이상<%}else if(age_scp.equals("4")){%>24세이상<%}else if(age_scp.equals("1")){%>21세이상<%}else if(age_scp.equals("5")){%>30세이상<%}else if(age_scp.equals("6")){%>35세이상<%}else if(age_scp.equals("7")){%>43세이상<%}else if(age_scp.equals("8")){%>48세이상<%}else if(age_scp.equals("3")){%>모든운전자<%}%></td>
				    	</tr>
				    	<tr>
				    		<th>자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;차</th>
				    		<td><%if(ins.getVins_cacdt_cm_amt()>0){%><%=ins.getIns_com_nm()%><%}else{%>아마존카<%}%></td>
				    	</tr>	
						<tr>
				    		<th>면&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;책&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;금</th>
				    		<td><%=AddUtil.parseDecimal(base.getCar_ja())%>원</td>
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