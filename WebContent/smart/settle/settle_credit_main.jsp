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
#cbtn {text-align:center; margin:15px 0 5px 0;}

</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
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
		
	
		
	Vector vt = s_db.getStatSettleSubItemList	(rent_mng_id, rent_l_cd, car_mng_id, client_id, "", "", "", "", mode);//String m_id, String l_cd, String car_mng_id, String client_id, String site_id, String bus_id2, String gubun1, String mode
	int vt_size = vt.size();
	
	long total_amt 	= 0;
	
	long pre_amt 	= 0;
	long fine_amt 	= 0;
	long fee_amt 	= 0;
	long fee_amt2 	= 0;
	long serv_amt 	= 0;
	long cls_amt 	= 0;
	long rent_amt 	= 0;
	long accid_amt 	= 0;
	long dly_amt 	= 0;
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
	function view_info(st)
	{
		var fm = document.form1;		
		
		if(st == '1') 		fm.action = "settle_credit_sms.jsp";
		else if(st == '2') 	fm.action = "settle_credit_memo.jsp";
		else if(st == '3') 	fm.action = "settle_credit_doc.jsp";
		else if(st == '4') 	fm.action = "settle_credit_cms.jsp";						
		
		fm.submit();
	}
	
	function view_settle_info(rent_mng_id, rent_l_cd, client_id, firm_nm, car_mng_id, car_no, car_nm, bus_id2, s_cd1, s_cd2, s_cd3, s_cd4, s_cd5)
	{
		var fm = document.form1;		
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value 	= rent_l_cd;
		fm.client_id.value 	= client_id;
		fm.firm_nm.value 	= firm_nm;
		fm.car_mng_id.value = car_mng_id;
		fm.car_no.value 	= car_no;
		fm.car_nm.value 	= car_nm;
		fm.bus_id2.value 	= bus_id2;		
		fm.s_cd1.value 		= s_cd1;
		fm.s_cd2.value 		= s_cd2;		
		fm.s_cd3.value 		= s_cd3;
		fm.s_cd4.value 		= s_cd4;
		fm.s_cd5.value 		= s_cd5;		
		fm.action = "settle_credit_info.jsp";
		fm.submit();
	}	
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "settle_item_list.jsp";		
		fm.submit();
	}			
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
	<input type='hidden' name='s_cd1' 		value=''>
	<input type='hidden' name='s_cd2' 		value=''>		
	<input type='hidden' name='s_cd3' 		value=''>
	<input type='hidden' name='s_cd4' 		value=''>		
	<input type='hidden' name='s_cd5' 		value=''>		

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%=firm_nm%> 채권관리
			</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true"><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle">연체현황</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">							
						<%	for (int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								total_amt += AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("선수금"))		pre_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("과태료"))		fine_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("대여료") && !String.valueOf(ht.get("GUBUN2")).equals("미청구+잔가"))		fee_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("대여료") && String.valueOf(ht.get("GUBUN2")).equals("미청구+잔가"))			fee_amt2 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("면책금"))		serv_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("해지정산금"))	cls_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("단기대여료"))	rent_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("휴/대차료"))	accid_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("연체이자"))		dly_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								
								if(String.valueOf(ht.get("GUBUN1")).equals("대여료") && String.valueOf(ht.get("GUBUN2")).equals("미청구+잔가"))			total_amt 	= total_amt - AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								%>				  
						<tr>
							<th width="80">
								<%=ht.get("GUBUN1")%>
							</th>
							<td>
							<%=ht.get("CAR_NO")%> <font color=#fd5f00><%=ht.get("GUBUN2")%></font>
							<%	if(String.valueOf(ht.get("GUBUN1")).equals("대여료")){%>
							<br>
							<%	}%>
							<%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%>&nbsp;
							<a href="javascript:view_settle_info('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CLIENT_ID")%>','<%=ht.get("FIRM_NM")%>', '<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("CAR_NO")%>','<%=ht.get("CAR_NM")%>','<%=ht.get("BUS_ID2")%>','<%=ht.get("S_CD1")%>','<%=ht.get("S_CD2")%>','<%=ht.get("S_CD3")%>','<%=ht.get("S_CD4")%>','<%=ht.get("S_CD5")%>')" onMouseOver="window.status=''; return true"><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%>원</a>
							</td>
						</tr>	
						<%		if(i+1 < vt_size){%>	
						<tr>
							<td colspan=2 height=1 bgcolor=#b0b0b0></td>
						</tr>						
						<%		}%>	
						<%	}%>	
						<%	if(vt_size==0){%>
						<tr>
							<th valign=top>데이타가 없습니다.</th>
						</tr>
						<%	}else{%>	
						<tr>
							<td height=10  colspan=2></td>
						</tr>
						<tr>
							<td colspan=2 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=2></td>
						</tr>
						<tr>
							<th>합계</th>
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt)%></b></font> 원&nbsp;</th>							
						</tr>
						<%}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div> 
		
	</div>
	<div id="cbtn"><a href="javascript:view_info('1')" onMouseOver="window.status=''; return true"><img src=/smart/images/btn_send_sms.gif align=absmiddle /></a> 
		&nbsp;<a href="javascript:view_info('2')" onMouseOver="window.status=''; return true"><img src=/smart/images/btn_memo_d.gif align=absmiddle /></a>
		&nbsp;<a href="javascript:view_info('3')" onMouseOver="window.status=''; return true"><img src=/smart/images/btn_bh_cgj.gif align=absmiddle /></a>		
		&nbsp;<a href="javascript:view_info('4')" onMouseOver="window.status=''; return true"><img src=/smart/images/btn_memo_cms.gif align=absmiddle /></a></div>			
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