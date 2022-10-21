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
<%@ page import="acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_s_cd		= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(car_mng_id);
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(rent_s_cd, car_mng_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	String rent_st = rc_bean.getRent_st();
	
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//보유차량찾기
	function search_car(){
		var fm = document.form1;
		var SUBWIN="search_deli_car_list.jsp?t_wd=&self_st=Y";		
		window.open(SUBWIN, "SubCust", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");		
	}
	
	//등록하기
	function DistReg(){
		var fm = document.form1;
		
		<%if(rent_s_cd.equals("")){%>
		if(fm.rent_s_cd.value == '')	{ alert('계약을 조회하십시오'); 	return; }				
		<%}%>
		
		if(fm.deli_dt.value == ''){ 		alert('배차일시를 입력하십시오'); 			fm.deli_dt.focus(); 		return; }
		if(fm.deli_loc.value == ''){ 		alert('배차위치를 입력하십시오'); 			fm.deli_loc.focus(); 		return; }		
		if(fm.deli_mng_id.value == ''){ 	alert('배차담당자를 선택하십시오'); 		fm.deli_mng_id.focus(); 	return; }						
		if(fm.deli_dt.value != '')
			fm.h_deli_dt.value = fm.deli_dt.value+fm.deli_dt_h.value+fm.deli_dt_s.value;		
				
		if(fm.ret_plan_dt.value != '')
			fm.h_ret_plan_dt.value = fm.ret_plan_dt.value+fm.ret_plan_dt_h.value+fm.ret_plan_dt_s.value;
		
		if(!confirm('등록하시겠습니까?')){	return; }
		fm.cmd.value = "i";
		fm.action = 'car_deli_reg_a.jsp';		
//		fm.target = "i_no";
		fm.target = "_self";		
		fm.submit();
	
	}
	
	function page_reload()
	{
		var fm = document.form1;		
		fm.action = "car_deli_reg.jsp";		
		fm.target = "_self";
		fm.submit();
	}	
	
			
	function view_before()
	{
		var fm = document.form1;	
		<%if(rent_s_cd.equals("")){%>
		fm.action = "nreg_main.jsp";	
		<%}else{%>
		fm.action = "car_deli_view.jsp";	
		<%}%>		
		fm.target = "_self";	
		fm.submit();
	}			
//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>	
	<input type='hidden' name='rent_s_cd'	value='<%=rent_s_cd%>'>		
	<input type='hidden' name='cmd' 		value=''>		
	<input type='hidden' name='dist' 		value=''>			
	<input type='hidden' name='from_page'	value='car_deli_reg.jsp'>	
	<input type='hidden' name='h_deli_dt' 	value=''>
	<input type='hidden' name='h_ret_plan_dt' value=''>
	<input type='hidden' name='car_no' 		value='<%=reserv.get("CAR_NO")%>'>        
	<input type='hidden' name='c_firm_nm' 	value='<%=rc_bean2.getFirm_nm()%>'>         
	<input type='hidden' name='c_client_nm' value='<%=rc_bean2.getCust_nm()%>'>          
	

	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">보유차배차등록</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">계약정보&nbsp;
		<a href="javascript:search_car()" onMouseOver="window.status=''; return true" title="차량조회하기. 클릭하세요"><img src="/smart/images/btn_serch.gif"  border="0" align=absmiddle></a>
		</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>계약구분</th>
							<td valign=top><%if(rent_st.equals("1")){%>
                &nbsp;단기대여 
                <%}else if(rent_st.equals("2")){%>
                &nbsp;정비대차 
                <%}else if(rent_st.equals("3")){%>
                &nbsp;사고대차 
                <%}else if(rent_st.equals("9")){%>
                &nbsp;보험대차 
                <%}else if(rent_st.equals("10")){%>
                &nbsp;지연대차 
                <%}else if(rent_st.equals("4")){%>
                &nbsp;업무대여 
                <%}else if(rent_st.equals("5")){%>
                &nbsp;업무지원 
                <%}else if(rent_st.equals("6")){%>
                &nbsp;차량정비 
                <%}else if(rent_st.equals("7")){%>
                &nbsp;차량점검 
                <%}else if(rent_st.equals("8")){%>
                &nbsp;사고수리 
                <%}else if(rent_st.equals("11")){%>
                &nbsp;장기대기
                <%}%>		</td>
						</tr>
						<tr>
							<th valign=top>차량번호</th>
							<td valign=top><font color=#fd5f00><%=reserv.get("CAR_NO")==null?"":reserv.get("CAR_NO")%></font></td>
						</tr>
						<tr>
							<th valign=top>차명</th>
							<td valign=top><%=reserv.get("CAR_NM")==null?"":reserv.get("CAR_NM")%></td>
						</tr>
						<tr>
							<th valign=top>상호</th>
							<td valign=top><%=rc_bean2.getFirm_nm()%> <%=rc_bean2.getCust_nm()%></td>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">배차정보</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>배차예정일시</th>
							<td><%=AddUtil.ChangeDate3(rc_bean.getDeli_plan_dt())%></td>
						</tr>																
				    	<tr>
				    		<th width="70">배차일시</th>
				    		<td><input type="text" name="deli_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <select name="deli_dt_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                        </select>
                        <select name="deli_dt_s" >
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                        </select>
							</td>
				    	</tr>	
						<tr>
							<th>배차위치</th>
							<td><textarea name="deli_loc" cols="30" rows="3" class="text" style="IME-MODE: active"><%=rc_bean.getDeli_loc()%></textarea></td>
						</tr>											
						<tr>
							<th>배차담당자</th>
							<td><select name='deli_mng_id'>
                        <option value="">미지정</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                    </select></td>
						</tr>											
						<tr>
							<th>반차예정일시</th>
							<td><input type="text" name="ret_plan_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="ret_plan_dt_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                        </select>
                        <select name="ret_plan_dt_s" >
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                        </select></td>
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
	<%if(rent_s_cd.equals("")){%>

	<%}%>
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
