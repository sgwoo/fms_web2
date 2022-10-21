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
<%@ page import="acar.client.*, acar.cont.*, acar.car_register.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//자동차등록정보
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	int car_ret_chk = 0;
	
	//재리스일때 예약시스템 반차종료 확인
	if(base.getCar_gu().equals("0")){
		car_ret_chk = rs_db.getCarRetChk(base.getCar_mng_id());
	}
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//계약조회
	function search_cont(){
		var fm = document.form1;
		var SUBWIN="search_start_cont_list.jsp?t_wd=&self_st=Y";		
		window.open(SUBWIN, "SubCust", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");		
	}
	
	//등록하기
	function DistReg(){
		var fm = document.form1;
		
		if(fm.rent_l_cd.value == '')	{ alert('차량을 조회하십시오'); 	return; }				
		
		
		if(toInt(fm.car_ret_chk.value) > 0)		{ alert('대여개시-예약시스템에 반차 미처리분이 있습니다. 먼저 반차처리후에 대여개시 하십시오.'); return; }
		if(fm.con_mon.value == '')				{ alert('대여개시-이용기간을 입력하십시오.'); 				fm.con_mon.focus(); 		return; }
		if(fm.rent_start_dt.value == '')		{ alert('대여개시-대여개시일을 입력하십시오.'); 			fm.rent_start_dt.focus(); 	return; }
		if(fm.rent_end_dt.value == '')			{ alert('대여개시-대여만료일을 입력하십시오.'); 			fm.rent_end_dt.focus(); 	return; }				
		
		<%if(fee.getFee_s_amt()>0 && !fee.getFee_chk().equals("1") ){%>
		if(fm.fee_pay_tm.value == '')			{ alert('대여개시-납입횟수를 입력하십시오.'); 				fm.fee_pay_tm.focus(); 		return; }
		if(fm.fee_est_day.value == '')			{ alert('대여개시-납일일자를 입력하십시오.'); 				fm.fee_est_day.focus(); 	return; }
		if(fm.fee_pay_start_dt.value == '')		{ alert('대여개시-납입기간을 입력하십시오.'); 				fm.fee_pay_start_dt.focus();return; }
		if(fm.fee_pay_end_dt.value == '')		{ alert('대여개시-납입기간을 입력하십시오.'); 				fm.fee_pay_end_dt.focus(); 	return; }
		<%}%>
		
		if(!confirm('등록하시겠습니까?')){	return; }
		fm.cmd.value = "i";
		fm.action = 'rent_start_reg_a.jsp';		
//		fm.target = "i_no";
		fm.target = "_self";		
		fm.submit();
	
	}
	
	function date_type_input(date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";		
		var dt = today;
		if(date_type==1){//내일			
			dt = new Date(today.valueOf()+(24*60*60*1000));
		}else if(date_type == -1){
			dt = new Date(today.valueOf()-(24*60*60*1000)*1);
		}else if(date_type == -2){
			dt = new Date(today.valueOf()-(24*60*60*1000)*2);
		}
		s_dt = String(dt.getFullYear())+"-";
		if(dt.getFullYear()<2000) s_dt = String(dt.getFullYear()+1900)+"-";		
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		
		fm.rent_start_dt.value = s_dt;		
		
		set_cont_date();
	}			
		
	function page_reload()
	{
		var fm = document.form1;		
		fm.action = "rent_start_reg.jsp";		
		fm.target = "_self";
		fm.submit();
	}			
			
	function view_before()
	{
		var fm = document.form1;	
		fm.action = "nreg_main.jsp";	
		fm.target = "_self";	
		fm.submit();
	}
	
	//대여기간 셋팅
	function set_cont_date(){
		var fm = document.form1;
	
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;

		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
			
		fm.action='/fms2/lc_rent/get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
	}				
//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>	
	<input type='hidden' name='car_no' 	    value='<%=cr_bean.getCar_no()%>'>	
	<input type='hidden' name='cmd' 		value=''>		
	<input type='hidden' name='dist' 		value=''>			
	<input type='hidden' name='from_page'	value='rent_start_reg.jsp'>	
	<input type='hidden' name="rent_way"			value="<%=fee.getRent_way()%>">
	<input type='hidden' name="car_ret_chk"			value="<%=car_ret_chk%>">
	<input type='hidden' name="pere_r_mth"			value="<%=fee.getPere_r_mth()%>">

	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">대여개시등록</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">계약정보&nbsp;
		<a href="javascript:search_cont()" onMouseOver="window.status=''; return true" title="차량조회하기. 클릭하세요"><img src="/smart/images/btn_serch.gif"  border="0" align=absmiddle></a>
		</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>상호/성명</th>
							<td valign=top><%=client.getFirm_nm()%></td>
						</tr>
						<tr>
							<th valign=top>최초영업자</th>
							<td valign=top><%=c_db.getNameById(base.getBus_id(),"USER")%></td>
						</tr>						
						<tr>
							<th valign=top>차량구분</th>
							<td valign=top><%if(base.getCar_gu().equals("0")){%>재리스<%}else if(base.getCar_gu().equals("1")){%>신차<%}else if(base.getCar_gu().equals("2")){%>중고차<%}%></td>
						</tr>
						<tr>
							<th valign=top>차량번호</th>
							<td valign=top><font color=#fd5f00><%=cr_bean.getCar_no()%></font></td>
						</tr>
						<tr>
							<th valign=top>차명</th>
							<td valign=top><%=cr_bean.getCar_nm()%></td>
						</tr>
						<tr>
							<th valign=top>최초등록일</th>
							<td valign=top><%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">신차대여개시</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>이용기간</th>
							<td><input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='fix' onBlur='javascript:set_cont_date()' readonly>개월</td>
						</tr>											
					
				    	<tr>
				    		<th width="70">대여개시일</th>
				    		<td><input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date();'>
								<%if(fee.getRent_start_dt().equals("")){%>
								<input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(-1)">어제								
								<input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(0)">오늘
								<%}%>
							</td>
				    	</tr>	
						<tr>
							<th>대여만료일</th>
							<td><input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
						</tr>	
						<%if(fee.getFee_s_amt()>0 && !fee.getFee_chk().equals("1") ){%>
						<tr>
							<th>납입횟수</th>
							<td><input type='text' size='3' name='fee_pay_tm' value='<%=fee.getFee_pay_tm()%>' maxlength='2' class='text' >회</td>
						</tr>	
						<tr>
							<th>납입일자</th>
							<td>매월
		                      <select name='fee_est_day'>
    		                    <option value="">선택</option>
        		                <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
            		            <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                		        <% } %>
                    		    <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
								<option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
		                      </select>
					  		</td>
						</tr>	
						<tr>
							<th>1회차납입일</th>
							<td><input type='text' name='fee_fst_dt' value='<%=fee.getFee_fst_dt()%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value); set_cont_date();'></td>
						</tr>	
						<tr>
							<th>1회차납입액</th>
							<td><input type='text' name='fee_fst_amt' value='<%=AddUtil.parseDecimal(fee.getFee_fst_amt())%>' maxlength='10' size='10' class='num'>원</td>
						</tr>	
						<tr>
							<th>납입기간</th>
							<td><input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
		        				~
			    			    <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
								&nbsp;&nbsp;<font color='#CCCCCC'>(납입횟수, 1회차납입일을 입력하면 자동처리됩니다.)</font>
							</td>
						</tr>	
						<%}else{%>	  	
						  <input type='hidden' name='fee_pay_tm' 			value='<%=fee.getFee_pay_tm()%>'>  
						  <input type='hidden' name='fee_est_day' 			value='<%=fee.getFee_est_day()%>'>  
						  <input type='hidden' name='fee_fst_dt' 			value='<%=fee.getFee_fst_dt()%>'>  
						  <input type='hidden' name='fee_fst_amt' 			value='<%=fee.getFee_fst_amt()%>'>  
						  <input type='hidden' name='fee_pay_start_dt' 		value='<%=fee.getFee_pay_start_dt()%>'>  
						  <input type='hidden' name='fee_pay_end_dt' 		value='<%=fee.getFee_pay_end_dt()%>'>  						
						<%}%>										
						<tr>
							<th>차량인도일</th>
							<td><input type='text' name='car_deli_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
					&nbsp;&nbsp;<font color='#CCCCCC'>(실제 고객에게 인도되는 날짜를 입력하십시오.)</font></td>
						</tr>	
						<tr>
							<th>차량이용안내메일<br>자동발송</th>
							<td><input type='checkbox' name='car_info_mail' value="Y" checked ></td>
						</tr>	
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>								
			
	</div>
	<div id="cbtn"><a href="javascript:DistReg();"><img src=/smart/images/btn_reg.gif align=absmiddle border=0></a></div>	
	<div id="footer"></div>  
</div>
</form>
<script language="JavaScript">
<!--
	<%if(rent_l_cd.equals("")){%>
	//date_type_input(0);
	<%}%>
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
