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
.contents_box1 th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box1 td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:red; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.cont.*"%>
<%@ page import="acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	
	
	String bus_id2 		= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String s_item 		= request.getParameter("s_item")==null?"":request.getParameter("s_item");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String s_cd1 		= request.getParameter("s_cd1")==null?"":request.getParameter("s_cd1");
	String s_cd2 		= request.getParameter("s_cd2")==null?"":request.getParameter("s_cd2");
	String s_cd3 		= request.getParameter("s_cd3")==null?"":request.getParameter("s_cd3");
	String s_cd4 		= request.getParameter("s_cd4")==null?"":request.getParameter("s_cd4");
	String s_cd5 		= request.getParameter("s_cd5")==null?"":request.getParameter("s_cd5");
	
	String s_cd = s_cd1+""+s_cd2+""+s_cd3+""+s_cd4+""+s_cd5;
	
	String item_st 	= request.getParameter("item_st")==null?"":request.getParameter("item_st");
	if(item_st.equals("1")){//모바일 연체이자구분자
		s_item = "연체이자";
		//차량정보
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		car_no = String.valueOf(cont.get("CAR_NO"));
		firm_nm = String.valueOf(cont.get("FIRM_NM"));
	}
	Vector vt = new Vector();
	int vt_size = 0;
	
	if(s_item.equals("선수금")){
		vt = s_db.getGrtList2("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("과태료")){
		vt = s_db.getFineList("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("면책금")){
		vt = s_db.getInsurMList("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("연체이자")){
		vt = s_db.getFeeDlyScdList("", "", "1", rent_l_cd);
	}else if(s_item.equals("대여료")){
		vt = s_db.getFeeList4("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("해지정산금")){
		vt = s_db.getClsFeeScdList("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("단기대여료")){
		vt = s_db.getScdRentMngList_New("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("미청구+잔가")){
		vt = s_db.getEndFeeList("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("휴/대차료")){
		vt = s_db.getInsurHList("", "", "1", rent_l_cd, s_cd);
	}
	
	vt_size = vt.size();
	
	Hashtable ht = new Hashtable();
	
	int f_vt_size = vt_size;
	if(f_vt_size>1) f_vt_size = 1;
	for (int i = 0 ; i < f_vt_size ; i++){
		ht = (Hashtable)vt.elementAt(i);
	}
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

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>

</head>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='bus_id2' 	value='<%=bus_id2%>'>
	<input type='hidden' name='s_item' 		value='<%=s_item%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>
	<input type='hidden' name='mode' 		value='<%=mode%>'>

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%=AddUtil.subData(firm_nm, 10)%> 채권관리
			</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle"><%=s_item%></div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">	
						<tr>
							<th width="80">차량번호</th>
							<td><%=car_no%></font></td>
						</tr>						
					<%if(s_item.equals("선수금")){
							long total_amt1 	= AddUtil.parseLong(String.valueOf(ht.get("EXT_EST_AMT")));
							long total_amt2 	= 0;%>
						<tr>
							<th width="80">구분</th>
							<td><%=ht.get("GUBUN")%> <font color=#fd5f00><%if(!String.valueOf(ht.get("EXT_TM")).equals("1")){%>잔액<%}%></font></td>
						</tr>	
						<tr>
							<th>입금예정일</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXT_EST_DT")))%></td>
						</tr>	
						<%if(!String.valueOf(ht.get("RENT_SUC_DT")).equals("")){%>													
						<tr>
							<th>승계일자</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%></td>
						</tr>		
						<%}else{%>												
						<tr>
							<th>대여개시일</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
						</tr>		
						<%}%>
						<tr>
							<th>예정금액</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("EXT_EST_AMT")))%>원</td>
						</tr>	
					<%		if(vt_size>1){%>											
						<tr>
							<td colspan=3 height=20></td>
						</tr>																		
					<%			for (int i = 0 ; i < vt_size ; i++){
									ht = (Hashtable)vt.elementAt(i);
									if(!String.valueOf(ht.get("EXT_PAY_DT")).equals("")){
										total_amt2 += AddUtil.parseLong(String.valueOf(ht.get("EXT_PAY_AMT")));%>
						<tr>
							<th>수금</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXT_PAY_DT")))%>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("EXT_PAY_AMT")))%>원</td>
						</tr>						
					<%				}%>
					<%			}%>
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>잔액</th>
							<th></th>							
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>원</th>							
						</tr>	
					<%		}%>																								
						
					<%}else if(s_item.equals("과태료")){%>
						<tr>
							<th width="80">위반내용</th>
							<td><%=ht.get("VIO_CONT")%></td>
						</tr>	
						<tr>
							<th>위반일시</th>
							<td><%=ht.get("VIO_DT")%> </td>
						</tr>	
						<tr>
							<th>위반장소</th>
							<td><%=ht.get("VIO_PLA")%></td>
						</tr>		
						<tr>
							<th>위반금액</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("PAID_AMT")))%>원</td>
						</tr>												
						<tr>
							<th>납부기한</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAID_END_DT")))%></td>
						</tr>		
						<tr>
							<th>대납일자</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROXY_DT")))%></td>
						</tr>		
						<tr>
							<th>청구일자</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DEM_DT")))%></td>
						</tr>		
						
					<%	}else if(s_item.equals("면책금")){
							long total_amt1 	= AddUtil.parseLong(String.valueOf(ht.get("CUST_AMT")));
							long total_amt2 	= 0;%>
						<tr>
							<th width="80">구분</th>
							<td><%=ht.get("SERV_ST")%> 
							<font color=#fd5f00><%if( Util.parseInt(String.valueOf(ht.get("TOT_AMT")))==0 && String.valueOf(ht.get("OFF_NM")).equals("") ){
							Hashtable s_ht = s_db.getInsurMCaseNotNN(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("ACCID_ID")), String.valueOf(ht.get("SERV_ID")));
							if(!String.valueOf(s_ht.get("OFF_NM")).equals("") && !String.valueOf(s_ht.get("OFF_NM")).equals("null")){
								ht.put("OFF_NM",  String.valueOf(s_ht.get("OFF_NM"))==null?"":String.valueOf(s_ht.get("OFF_NM")));
								ht.put("TOT_AMT", String.valueOf(s_ht.get("TOT_AMT"))==null?"":String.valueOf(s_ht.get("TOT_AMT")));
								ht.put("SERV_DT", String.valueOf(s_ht.get("SERV_DT"))==null?"":String.valueOf(s_ht.get("SERV_DT")));
							}
							%>
							[선청구분]
							<%}%></font></td>
						</tr>	
						<tr>
							<th>정비업체</th>
							<td><%=ht.get("OFF_NM")%></td>
						</tr>	
						<tr>
							<th>정비일자</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SERV_DT")))%></td>
						</tr>		
						<tr>
							<th>정비금액</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%>원</td>
						</tr>		
						<tr>
							<th>입금예정일</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CUST_PLAN_DT")))%></td>
						</tr>		
						<tr>
							<th>금액</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("CUST_AMT")))%>원</td>
						</tr>	
						
					<%		if(vt_size>1){%>											
						<tr>
							<td colspan=3 height=20></td>
						</tr>																		
					<%			for (int i = 0 ; i < vt_size ; i++){
									ht = (Hashtable)vt.elementAt(i);
									if(!String.valueOf(ht.get("CUST_PAY_DT")).equals("")){
										total_amt2 += AddUtil.parseLong(String.valueOf(ht.get("EXT_PAY_AMT")));%>
						<tr>
							<th>수금</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CUST_PAY_DT")))%>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("EXT_PAY_AMT")))%>원</td>
						</tr>						
					<%				}%>
					<%			}%>
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>잔액</th>
							<th></th>							
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>원</th>							
						</tr>	
					<%		}%>												
												
					<%	}else if(s_item.equals("연체이자")){
							long total_amt1 	= 0;
							long total_amt2 	= 0;
							for (int i = 0 ; i < vt_size ; i++){
								ht = (Hashtable)vt.elementAt(i);
								total_amt1 += AddUtil.parseLong(String.valueOf(ht.get("DLY_FEE")));%>
						<tr>
							<th width="80"><%=ht.get("FEE_TM")%>회차</th>						
							<td width="120"><%=ht.get("DLY_DAYS")%>일 <%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_FEE_EST_DT")))%></td>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("DLY_FEE")))%>원</td>
						</tr>						
					<%		}%>	
					<%		//연체이자 수금리스트
							Vector vt2 = s_db.getFeeDlyScd(gubun3, gubun4, "1", rent_l_cd);//(String gubun3, String gubun4, String s_kd, String t_wd)
							int vt_size2 = vt2.size();%>
					<%		for (int i = 0 ; i < vt_size2 ; i++){
								Hashtable ht2 = (Hashtable)vt2.elementAt(i);
								total_amt2 += AddUtil.parseLong(String.valueOf(ht2.get("DLY_FEE")));%>
						<tr>
							<th>수금</th>						
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("PAY_DT")))%></td>
							<td align="right">-<%=Util.parseDecimal(String.valueOf(ht2.get("PAY_AMT")))%>원</td>
						</tr>										
					<%		}%>			
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>합계</th>
							<td></td>
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>원</th>							
						</tr>										
					<%	}else if(s_item.equals("대여료")){
							long total_amt1 	= AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT")));
							long total_amt2 	= 0;%>
						<tr>
							<th width="80">구분</th>
							<td colspan=2><%=ht.get("FEE_TM")%>회차</font></td>
						</tr>	
						<tr>
							<th>입금예정일</th>
							<td colspan=2><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
						</tr>	
						<tr>
							<th>예정금액</th>
							<td colspan=2><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원</td>
						</tr>	
					<%		if(vt_size>1){%>											
						<tr>
							<td colspan=3 height=20></td>
						</tr>																		
					<%			for (int i = 0 ; i < vt_size ; i++){
									ht = (Hashtable)vt.elementAt(i);
									if(!ht.get("RC_DT").equals("")){
										total_amt2 += AddUtil.parseLong(String.valueOf(ht.get("RC_AMT")));%>
						<tr>
							<th>수금</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RC_DT")))%>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("RC_AMT")))%>원</td>
						</tr>						
					<%				}%>
					<%			}%>
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>잔액</th>
							<th></th>							
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>원</th>							
						</tr>	
					<%		}%>								
						
					<%	}else if(s_item.equals("단기대여료")){%>
						<tr>
							<th width="80">구분</th>
							<td><%=ht.get("RENT_ST")%></td>
						</tr>	
						<tr>
							<th>계약일자</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
						</tr>	
						<tr>
							<th>입금예정일</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
						</tr>	
						<tr>
							<th>예정금액</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("RENT_AMT")))%>원</td>
						</tr>						
						
					<%	}else if(s_item.equals("해지정산금")){
							long total_amt1 	= AddUtil.parseLong(String.valueOf(ht.get("AMT")));
							long total_amt2 	= 0;%>
						<tr>
							<th width="80">구분</th>
							<td><%=ht.get("CLS_GUBUN")%> <font color=#fd5f00><%if(!String.valueOf(ht.get("TM")).equals("1")){%>잔액<%}%></font></td>
						</tr>	
						<tr>
							<th>해지일자</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>
						</tr>	
						<tr>
							<th>입금예정일</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
						</tr>	
						<tr>
							<th>예정금액</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("AMT")))%>원</td>
						</tr>	
					<%		if(vt_size>1){%>											
						<tr>
							<td colspan=3 height=20></td>
						</tr>																		
					<%			for (int i = 0 ; i < vt_size ; i++){
									ht = (Hashtable)vt.elementAt(i);
									if(!String.valueOf(ht.get("PAY_DT")).equals("")){
										total_amt2 += AddUtil.parseLong(String.valueOf(ht.get("EXT_PAY_AMT")));%>
						<tr>
							<th>수금</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_DT")))%>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("EXT_PAY_AMT")))%>원</td>
						</tr>						
					<%				}%>
					<%			}%>
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>잔액</th>
							<th></th>							
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>원</th>							
						</tr>	
					<%		}%>									
						
					<%	}else if(s_item.equals("미청구+잔가")){%>						
						<tr>
							<th width="80">최종만료일</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BAS_END_DT")))%></td>
						</tr>	
						<tr>
							<th>미청구대여료</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%></td>
						</tr>	
						<tr>
							<th>잔가금액</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("O_1")))%>원</td>
						</tr>			
						<tr>
							<th>합계</th>
							<td><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")))+AddUtil.parseLong(String.valueOf(ht.get("O_1"))))%>원</td>
						</tr>			
												
					<%	}else if(s_item.equals("휴/대차료")){%>						
						<tr>
							<th width="80">구분</th>
							<td><%=ht.get("REQ_GU")%></td>
						</tr>	
						<tr>
							<th>보험회사</th>
							<td><%=ht.get("OT_INS2")%></td>
						</tr>	
						<tr>
							<th>사고구분</th>
							<td><%=ht.get("ACCID_ST")%></td>
						</tr>							
						<tr>
							<th>사고일자</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACCID_DT")))%></td>
						</tr>	
						<tr>
							<th>청구일자</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
						</tr>	
						<tr>
							<th>청구금액</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("REQ_AMT")))%>원</td>
						</tr>			
					<%	}%>
						
					<%	if(vt_size==0){%>
						<tr>
							<th valign=top>데이타가 없습니다.</th>
						</tr>
					<%	}%>
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
<script language='javascript'>
<!--

//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</body>
</html>