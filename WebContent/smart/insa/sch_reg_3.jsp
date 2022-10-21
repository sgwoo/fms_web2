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
.contents_box th {color:#282828; height:22px; text-align:left; font-weight:bold;}
.contents_box td {line-height:22px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:22px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font:13px; margin:5px 0px;}
.contents_box1 th {color:#282828; width:80px; height:22px; text-align:left; font-weight:bold; line-height:24px;}
.contents_box1 td {line-height:24px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:24px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.attend.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	//연차정보
	Hashtable ht = v_db.getVacation(user_id);
	
	double  su = 0;
	
	su = AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("OV_CNT")) ;
				
				
	//사용자정보
	user_bean = umd.getUsersBean(user_id);
	
	//사원리스트-대체업무자
	Vector users = c_db.getUserSearchList("", user_bean.getDept_id(), "", "Y");//String br_id, String dept_id, String t_wd, String use_yn
	int user_size = users.size();
	
	//코드 구분:부서명
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;

	//반차사용현황 - 누적 
	//Hashtable ht2 = v_db.getVacationBan(user_id);    
	
	Hashtable ht2 = v_db.getVacationBan2(user_id); //1년내 반차 현황 
	
	int b_su = 0;
	int b1_su = 0;
	int b2_su = 0;
	
	b1_su = AddUtil.parseInt((String)ht2.get("B1"));
	b2_su = AddUtil.parseInt((String)ht2.get("B2"));
	
	b_su =  b1_su - b2_su;	
	
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

<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
function free_reg()
{
	var fm = document.form1;
	var date = new Date();  
        var day  = date.getDate();  
        var month = date.getMonth() + 1;  
        var year = date.getFullYear();  
        year = (year < 1000) ? year + 1900 : year;  
	if (("" + month).length == 1) { month = "0" + month; } 
	if (("" + day).length == 1) { day = "0" + day; } 
	var today = year + "-"+ month + "-" + day;
	
//	alert(theForm.st_dt.value);
//	alert(year + "-"+ month + "-" + day);

	if(fm.st_dt.value < today){
		alert("오늘보다 이전 날짜는 등록할 수 없습니다. 전산팀으로 문의 주세요!!!");	 
		return;		
	}
	
	if(fm.title1.value == '오전반휴' || fm.title1.value == '오후반휴' ){
		if(fm.st_dt.value != fm.end_dt.value){
			alert("반휴기간을 확인하세요..!!!");	 
		  	return;		
		}
		
		 if(toFloat(fm.su.value) <  0.5){
			alert("남은연차가 부족하여 반휴를 신청할 수 없습니다!!!");	 
		  	return;		
		}
		
	}
	
	//조민규 제외 ( 000177)  - 20211213
	<% if(!user_id.equals("000177")){ %>
			
		//반차관련 2개이상 차이시 입력체크 - 20211208이후
		if ( <%=Math.abs(b_su)%> >= 2) {		
			//오전반차가 많은 경우 - 오후반차만 등록 또는 연차 
			if ( <%=b_su%> >= 2) {
				if(theForm.title1.value == '오전반휴' ) {
					alert("오전반휴는 등록할 수 없습니다..!!!");	 
				  	return;		
				}
			}	
			
			//오후반차가 많은 경우 -오전반차만 등록 또는 연차
			if ( <%=b_su%> <= -2) {
				if(theForm.title1.value == '오후반휴' ) {
					alert("오후반휴는 등록할 수 없습니다..!!!");	 
				  	return;		
				}
			}			
		}	
	}	
	
	if(fm.work_id.value == '' || fm.work_id.value == '<%=user_id%>' ){	alert("대체근무자가 본인이거나 선택되지 않았습니다. 대체근무자를 다시 선택하십시오!!");	return;	}
	
//	if(fm.ov_yn.value == ''){	alert("급여를 선택하십시오.");	return;	}
	if(fm.sch_chk.value == ''){	alert("대분류를 선택하십시오.");	return;	}
	if(fm.title1.value == ''){	alert("중분류를 선택하십시오.");	return;	}
	if(fm.end_dt.value == ''){	alert("일자를 선택하십시오.");	return;	}
	if(fm.st_dt.value == ''){	alert("일자를 선택하십시오.");	return;	}		
	if(get_length(fm.content.value) > 4000){alert("4000자 까지만 입력할 수 있습니다."); return; }

	var s_str = fm.end_dt.value;
	var e_str = fm.st_dt.value;
			
	var s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7), s_str.substring(8,10) );
	var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7), e_str.substring(8,10) );
		
	var diff_date = s_date.getTime() - e_date.getTime();
			
	count = Math.floor(diff_date/(24*60*60*1000));
									
	if ( fm.sch_chk.value == '3' ) {
		if ( count > 15 ) {  
		  	alert("연차기간을 확인하세요..!!!");	 
		  	return;				
		}
	}	
	
	if ( count < 0 ) {  
	  	alert("연차기간을 확인하세요..!!!");	 
	  	return;				
	}		
	
	
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	
	fm.target = "i_no";
	fm.action = "sch_reg_a.jsp";
	fm.submit();
}

function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

	//직원리스트
	function GetUsetList(nm){
		var fm = document.form1;
		te = fm.work_id;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm.nm.value = "form1."+nm;
		fm.target = "i_no";
		fm.action = "user_null.jsp";
		fm.submit();
	}
	
function date_type_input(dt_st, date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";		
		var dt = today;
		if(date_type==2){//내일			
			dt = new Date(today.valueOf()+(24*60*60*1000));
		}else if(date_type == 3){
			dt = new Date(today.valueOf()+(24*60*60*1000)*2);						
		}else if(date_type == 4){
			dt = new Date(today.valueOf()+(24*60*60*1000)*3);						
		}
		s_dt = String(dt.getFullYear())+"-";
		if(dt.getFullYear()<2000) s_dt = String(dt.getFullYear()+1900)+"-";		
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		
		if(dt_st==1)		fm.st_dt.value = s_dt;		
		else 				fm.end_dt.value = s_dt;				
	}		
//-->
</script>
<script>
 mArray = new Array("오전반휴","오후반휴","연차");
 aArray = new Array("본인출산","배우자출산","생리휴가","기타"); 
 bArray = new Array("포상휴가"); 
 cArray = new Array("훈련","교육", "백신접종","자가격리","시설격리"); 
 dArray = new Array("본인결혼","자녀결혼","부모결혼","형제결혼","부모회갑","부모사망","배우자부모사망","배우자사망","조부모사망","형제/자녀사망","기타"); 
 eArray = new Array("본인출산","배우자출산"); 
 fArray = new Array("본인육아휴직","배우자육아휴직","기타"); 
 
 function changeSelect(value) {
 	document.all.title.length=1;
  if(value == '3') {
   for(i=0; i<mArray.length; i++) {
    option = new Option(mArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '5') {
   for(i=0; i<aArray.length; i++) {
    option = new Option(aArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '9') {
   for(i=0; i<bArray.length; i++) {
    option = new Option(bArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '7') {
   for(i=0; i<cArray.length; i++) {
    option = new Option(cArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '6') {
   for(i=0; i<dArray.length; i++) {
    option = new Option(dArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '4') {
   for(i=0; i<dArray.length; i++) {
    option = new Option(dArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '8') {
   for(i=0; i<fArray.length; i++) {
    option = new Option(fArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
 }
 
 
function firstChange() {// 대분류 변한 경우
 var x = document.form1.sch_chk.options.selectedIndex;//선택한 인덱스
 var groups=document.form1.sch_chk.options.length;//대분류 갯수
 var group=new Array(groups);//배열 생성
 for (i=0; i<groups; i++) {
  group[i]=new Array();
 }//for
 // 옵션(<option>) 생성
 group[0][0]=new Option("대분류를 먼저 선택하세요","");
 
 group[1][0]=new Option("연차선택","");
 group[1][1]=new Option("오전반휴","오전반휴");//결과 <option value="ss">삼성</option>
 group[1][2]=new Option("오후반휴","오후반휴");
 group[1][3]=new Option("연차","연차");

 group[2][0]=new Option("병가선택","");
 group[2][1]=new Option("본인출산","본인출산");
 group[2][2]=new Option("배우자출산","배우자출산");
 group[2][3]=new Option("생리휴가","생리휴가");
 group[2][4]=new Option("기타","기타");
 
 group[3][0]=new Option("포상휴가선택","");
 group[3][1]=new Option("포상휴가","포상휴가");
  
 group[4][0]=new Option("공가선택","");
 group[4][1]=new Option("훈련","훈련");
 group[4][2]=new Option("교육","교육");
 group[4][3]=new Option("백신접종","백신접종");
 group[4][4]=new Option("자가격리","자가격리");
 group[4][5]=new Option("시설격리","시설격리");
  
 group[5][0]=new Option("경조사선택","");
 group[5][1]=new Option("본인결혼","본인결혼");
 group[5][2]=new Option("자녀결혼","자녀결혼");
 group[5][3]=new Option("부모결혼","부모결혼");
 group[5][4]=new Option("형제결혼","형제결혼");
 group[5][5]=new Option("부모회갑","부모회갑");
 group[5][6]=new Option("부모사망","부모사망");
 group[5][7]=new Option("배우자부모사망","배우자부모사망");
 group[5][8]=new Option("배우자사망","배우자사망");
 group[5][9]=new Option("조부모사망","조부모사망");
 group[5][10]=new Option("형제/자매사망","형제/자매사망");
 group[5][11]=new Option("기타","기타");
 
 group[6][0]=new Option("출산휴가선택","");
 group[6][1]=new Option("본인출산","본인출산");
 group[6][2]=new Option("배우자출산","배우자출산");

 group[7][0]=new Option("휴직","");
 group[7][1]=new Option("본인육아휴직","본인육아휴직");
 group[7][2]=new Option("배우자육아휴직","배우자육아휴직");
 group[7][3]=new Option("기타","기타");

 temp = document.form1.title1;//두번 째 셀렉트 얻기(<select name=second>)
 for (m = temp.options.length - 1 ; m > 0 ; m--) {//현재 값 지우기
  temp.options[m]=null
 }
 for (i=0;i<group[x].length;i++){//값 셋팅
  //예) <option value="ss">삼성</option>
  temp.options[i]=new Option(group[x][i].text,group[x][i].value);
 }
 temp.options[0].selected=true//인덱스 0번째, 즉, 첫번째 선택
}//firstChange

 
</script>

</head>

<body>
<form name='form1' method='post' action='sch_reg_a.jsp'>
  <input type="hidden" name="nm" value="">
  <input type="hidden" name="su" value="<%=su%>">		

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">휴가등록</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle">연차정보</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>근무지</th>
							<td><%= ht.get("BR_NM") %></td>
						</tr>
						<tr>
							<th>부서</th>
							<td><%= ht.get("DEPT_NM") %></td>
						</tr>			
						<tr>
							<th>직급</th>
							<td><%= ht.get("USER_POS") %></td>
						</tr>						
						<tr>
							<th>성명</th>
							<td><%= ht.get("USER_NM") %></td>
						</tr>						
						<tr>
							<th>입사일자</th>
							<td><%= AddUtil.ChangeDate2((String)ht.get("ENTER_DT")) %></td>
						</tr>
						<tr>
							<th>근무기간</th>
							<td><%= ht.get("YEAR") %>년 <%= ht.get("MONTH") %>월 <%= ht.get("DAY") %>일</td>
						</tr>
						<tr>
							<th valign=top>연차현황</th>
							<td valign=top>연차일수[<%= ht.get("VACATION") %>]<br>
							사용[<%= ht.get("SU") %>] 
							<font color="#990000">미사용[<%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU")) %>]</font> 
							무급[<% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %><font style="color:red;"><% } %><%= ht.get("OV_CNT") %><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %></font><% } %>]</td>
						</tr>
						<tr>
							<th>반휴가 현황</th>
							<td>오전[<%=ht2.get("B1")%>]&nbsp;&nbsp;&nbsp;오후[<%=ht2.get("B2")%>]</td>
						</tr>
						<tr>
							<th>연차소멸일</th>
							<td><font color="#990000"><%= AddUtil.ChangeDate2((String)ht.get("END_DT")) %></font> [<%= ht.get("RE_MONTH") %>개월<%= ht.get("RE_DAY") %>일 남음]</td>
						</tr>						
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>						
	</div>
	<div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle">휴가등록</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th valign=top>휴가구분</th>
							<td valign=top>
							<!--
							<select name='ov_yn' onchange="ffirstChange();" size=1>
									<option value='N'>유급</option>
									<option value='Y'>무급</option>
							</select>
							-->
							<select name='sch_chk' onchange="firstChange();" size=1>
									<option value=''>대분류선택</option>
									<option value='3'>연차</option>
									<option value='5'>병가</option>
									<option value='9'>포상휴가</option>
									<option value='7'>공가</option>
									<option value='6'>경조사</option>
									<option value='4'>출산휴가</option>
									<option value='8'>휴직</option>
								</select>
								<select name='title1' size=1>
	 							<option value=''>중분류선택</option>
								</select>
								<br>
								- 훈련은 공가로 선택
                    			<br>- 포상휴가는 장기근속사원 해외여행인 경우만 선택
							</td>
						</tr>			
						<tr>
							<th valign=top>대체업무자</th>
							<td valign=top>
							<select name='gubun3' onChange="javascript:GetUsetList('work_id');">
					          <option value=''>전체</option>
					          <%for(int i = 0 ; i < dept_size ; i++){
									CodeBean dept = depts[i];%>
					          <option value='<%=dept.getCode()%>' <%if(user_bean.getDept_id().equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
					          <%	
									}%>
					        </select>
							<select name="work_id">
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' ><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
					  <br>
        			   - 연차,휴가,병가,경조사일때 : 전자문서 결재 대체자
							</td>
						</tr>							
						<tr>
							<th>휴가기간</th>
							<td>
								<input type="text" name="st_dt" value='' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
								<br>
								<input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(1,1)">오늘
								<input type='radio' name="date_type1" value='2' onClick="javascript:date_type_input(1,2)" checked>내일
								<input type='radio' name="date_type1" value='3' onClick="javascript:date_type_input(1,3)">모레
								<input type='radio' name="date_type1" value='4' onClick="javascript:date_type_input(1,4)">글피
								<br>
			        			  ~
			        			<input type="text" name="end_dt" value='' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>	
								<br>  
								<input type='radio' name="date_type2" value='1' onClick="javascript:date_type_input(2,1)">오늘
								<input type='radio' name="date_type2" value='2' onClick="javascript:date_type_input(2,2)" checked>내일			  
								<input type='radio' name="date_type2" value='3' onClick="javascript:date_type_input(2,3)">모레
								<input type='radio' name="date_type2" value='4' onClick="javascript:date_type_input(2,4)">글피
			       			</td>
						</tr>						
						<tr>
							<th>내용</th>
							<td><textarea name='content' rows='9' cols='25' ></textarea></td>
						</tr>
						<tr>
							<td style='height:10px;'></td>
						</tr>
						<tr>
							<th>&nbsp;</th>
							<td valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:free_reg()"><img src='/smart/images/btn_pres.gif' align=absmiddle /></a></td>
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
<script language="JavaScript">
<!--
		var s_dt = '<%=AddUtil.ChangeDate2(rs_db.addDay(AddUtil.getDate(),1))%>';
		document.form1.st_dt.value  = s_dt;		
		document.form1.end_dt.value = s_dt;			
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</body>
</html>
