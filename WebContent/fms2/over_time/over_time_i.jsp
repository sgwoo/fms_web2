	<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.user_mng.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>
<%

	UserMngDatabase umd = UserMngDatabase.getInstance();
	

	String id = "";			
	String user_h_tel ="";
	String user_m_tel ="";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";
	String user_nm = "";
	String br_id = "";
	String auth_rw = "";
	
	String user_id = "";
	int seq = 0;
	String reg_dt = "";
	
	String over_sjgj = "";
	String over_sjgj_dt = "";
	String over_sjgj_op = "";
	String over_cont = "";
	String over_cr = "";
	String st_time = "";
	String st_year = "";
	String st_mon = "";
	String st_day = "";
	String ed_time = "";
	String ed_year = "";
	String ed_mon = "";
	String ed_day = "";
	
	/* 실제근로시간/인정근로시간 */
	String jb_time = "";
	String jb_time2 = "";
	
	String over_addr = "";
	
	String over_card1_dt ="";
	int over_card1_amt = 0;
	String over_cash1_dt ="";
	int over_cash1_amt = 0;
	String over_cash1_file ="";
	int over_cash1_cr_amt = 0;
	String over_cash1_cr_dt = "";
	String over_cash1_cr_jpno = "";
	String over_s_cash1_dt = "";
	int over_s_cash1_amt = 0;
	String over_s_cash1_file = "";
	int over_s_cash1_cr_amt = 0;
	String over_s_cash1_cr_jpno ="";
	
	String over_card2_dt ="";
	int over_card2_amt = 0;
	String over_cash2_dt ="";
	int over_cash2_amt = 0;
	String over_cash2_file ="";
	int over_cash2_cr_amt = 0;
	String over_cash2_cr_dt = "";
	String over_cash2_cr_jpno = "";
	String over_s_cash2_dt = "";
	int over_s_cash2_amt = 0;
	String over_s_cash2_file = "";
	int over_s_cash2_cr_amt = 0;
	String over_s_cash2_cr_jpno ="";
	
	String over_card3_dt ="";
	int over_card3_amt = 0;
	String over_cash3_dt ="";
	int over_cash3_amt = 0;
	String over_cash3_file ="";
	int over_cash3_cr_amt = 0;
	String over_cash3_cr_dt = "";
	String over_cash3_cr_jpno = "";
	String over_s_cash3_dt = "";
	int over_s_cash3_amt = 0;
	String over_s_cash3_file = "";
	int over_s_cash3_cr_amt = 0;
	String over_s_cash3_cr_jpno ="";
	
	int over_card_tot = 0;
	int over_cash_tot = 0;
	int over_s_cash_tot = 0;
	
	int over_scgy =  0;
	String over_scgy_dt ="";
	String over_scgy_pl_dt ="";
	
	String s_check ="";
	String s_check_dt ="";
	String s_check_id = "";
	
	String t_check = "";
	String t_check_dt = "";
	String t_check_id = "";
	
//출퇴근 일자및시간 	
	String start_dt = "";
	String start_h = "";
	String start_m = "";
	
	String end_dt = "";
	String end_h = "";
	String end_m = "";
	
	String over_time_mon = "";
	//String s_year2 = request.getParameter("s_year2")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year2"));
//	int s_month2 = request.getParameter("s_month2")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month2"));		
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

	
	reg_dt = Util.getDate();
	user_id = ck_acar_id;
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_nm = u_bean.getBr_nm();
	dept_nm = u_bean.getDept_nm();
	id = u_bean.getId();
	user_h_tel = u_bean.getUser_h_tel();
	user_m_tel = u_bean.getUser_m_tel();
	
	int s_year2 = AddUtil.parseInt(Util.getDate(1));
	String s_month2 = Util.getDate(2);
	int s_day2 = AddUtil.parseInt(Util.getDate(3)) ;
			
	if (s_month2.equals("12") ) {
		if ( s_day2 > 24 ) {
		    s_year2 = s_year2 + 1 ;
		    s_month2 = "01";
		} 	
	} else {
		if ( s_day2 > 24 ) {
		    s_year2 = s_year2 ;
		    s_month2 =AddUtil.addZero2(AddUtil.parseInt(s_month2)+1 );		
	    }
	}	
	 
	
%>
<html>
<head>
<title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--

function Over_time_save()
{
	var theForm = document.form1;
	
	
	if(theForm.over_sjgj.value == '')			{
		alert('사전결재 여부를 선택하세요'); 		
		theForm.over_sjgj.focus(); 		
		return;	
	}else if(theForm.over_sjgj.value != '6' && theForm.over_sjgj_dt.value == '')			{
		alert('결재취득일자를 입력하세요'); 		
		theForm.over_sjgj_dt.focus(); 		
		return;	
	}else if(theForm.over_sjgj.value == '6' && theForm.over_sjgj_op.value == '')			{ 
		alert('미결재 사유를 선택하세요'); 		
		theForm.over_sjgj_op.focus(); 		
		return;	
	}
	
	if(theForm.start_dt.value == '')		{ alert('출근일자를 입력하세요'); 		theForm.start_dt.focus(); 		return;	}
	if(theForm.end_dt.value == '')			{ alert('퇴근일자를 입력하세요'); 		theForm.end_dt.focus(); 		return;	}
	if(!isDate(theForm.start_dt.value)){ theForm.start_dt.focus(); return;	}	
	if(!isDate(theForm.end_dt.value)){ theForm.end_dt.focus(); return;	}	
		
	if(confirm('등록하시겠습니까?')){	
		theForm.cmd.value = "i";
		theForm.target="i_no";		
		theForm.action = "over_time_a.jsp";
	//	theForm.action = "https://fms3.amazoncar.co.kr/fms2/over_time/over_time_a.jsp";
		theForm.submit();
	}		
	
}


function Over_time_close()
{
	self.close();
	window.close();
}



//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body onload="javascript:document.form1.title.focus()">
<form action="" name="form1" method="post" enctype="multipart/form-data">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type="hidden" name="cmd" value="">	
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=8>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7	height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>특근수당 신청서 작성</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7	height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
<!-- 결재여부 시작 -->
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="125" rowspan="2" class="title">결재<br>(<%=br_nm%>)</td>
					<td width="125" align="center" class="title">담당자</td>
					<td width="125" align="center" class="title">지점장/팀장</td>
					<td width="125" align="center" class="title"></td>
					<td width="125" align="center" class="title"></td>
					<td width="125" align="center" class="title"></td>
					<td width="125" align="center" class="title"></td>
					<td width="125" align="center" class="title">대표이사</td>					
				</tr>
				<tr>
				  <td width="125" height="50" align="center"><%=user_nm%></td>
				  <td width="125" height="50" align="center">&nbsp;</td>
			      <td width="125" height="50" align="center">&nbsp;</td>
			      <td width="125" height="50" align="center">&nbsp;</td>
			      <td width="125" height="50" align="center">&nbsp;</td>
			      <td width="125" height="50" align="center">&nbsp;</td>
			      <td width="125" height="50" align="center">&nbsp;</td>
			  </tr>
			</table>
		</td>
	</tr>	
<!-- 결재여부 끝 -->
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width="125">근무일자/요일</td>
					<td width="125" align="center"></td>
					<td class="title" width="125">작성일자</td>
					<td width="125" align="center"><%=reg_dt%></td>
					<td class="title" width="125">제출일자</td>
					<td width="125" align="center"></td>
					<td width="125" colspan="2" class="title">귀속월(급여)</td>
					<td width="125" align="center"><input type="text" name="over_time_year" size="4" value="<%=Integer.toString(s_year2)%>" readonly >년<input type="text" name="over_time_mon" size="2" value="<%=s_month2%>" readonly >월</td>

				</tr>
				<tr>
					<td width="125" rowspan="2" class="title">소속부서명</td>
					<td width="125" rowspan="2" align="center"><%=br_nm%>-<%=dept_nm%></td>
					<td width="125" rowspan="2" class="title">사원번호</td>
					<td width="125" rowspan="2" align="center"><%=id%></td>
					<td width="125" rowspan="2" class="title">성명</td>
					<td width="125" rowspan="2" align="center"><%=user_nm%></td>
					<td width="62" rowspan="2" class="title">연락처</td>
					<td class="title" width="63">휴대폰</td>
					<td width="125" align="center"><%=user_m_tel%></td>
				</tr>
				<tr>
				  <td class="title" width="63">사무실</td>
			      <td width="125" align="center"><%=user_h_tel%></td>
			  </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연장(휴무일)근로 내용</span></td>
	</tr>
    <tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width="125">사전결재</td>
					<td width="125" align="center">
						<SELECT NAME="over_sjgj">
							<OPTION VALUE="">결재권자</OPTION>
							<OPTION VALUE="1">정채달</OPTION>
					-		<OPTION VALUE="2">김광수</OPTION> 
							<OPTION VALUE="3">안보국</OPTION>
							<OPTION VALUE="7">이종준</OPTION> 
							<OPTION VALUE="4">제인학</OPTION>
							<OPTION VALUE="5">박영규</OPTION>
							<OPTION VALUE="8">윤영탁</OPTION>
							<OPTION VALUE="9">김은철</OPTION> 
							<OPTION VALUE="A">강주원</OPTION> 
							<OPTION VALUE="B">김욱</OPTION> 
							<OPTION VALUE="C">김우석</OPTION> 
							<OPTION VALUE="D">류선</OPTION> 			
							<OPTION VALUE="6">미결재</OPTION>
  						</SELECT>
  					</td>
					<td class="title" width="125">결재취득일자</td>
					<td width="125" align="center"><INPUT TYPE="TEXT" NAME="over_sjgj_dt" SIZE="14" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
					<td class="title" width="125">미결재사유</td>
					<td width="375" colspan="3">&nbsp;
						<SELECT NAME="over_sjgj_op">
							<OPTION VALUE="">미결재시 사유를 선택하세요.</OPTION>
							<OPTION VALUE="1">1.갑자기 발생한 업무.</OPTION>
							<OPTION VALUE="2">2.팀장과 통화가 안됨.</OPTION>
						
  						</SELECT>
					</td>
				</tr>
				<tr>
					<td class="title" width="125">출근</td>
<!-- 					<td width="375" colspan="3">&nbsp;<INPUT TYPE="text" NAME="st_year" size="5">년 <INPUT TYPE="text" NAME="st_mon" size="3">월 <INPUT TYPE="text" NAME="st_day" size="3">일 - 시간 : <INPUT TYPE="text" NAME="st_time" size="5"></td> -->
					<td width="375" colspan="3" align="center">&nbsp;<input type="text" name="start_dt" value="" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <select name="start_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                        </select>
                        <select name="start_m" >
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                        </select></td>
					<td class="title" width="500" colspan="4" align="left"> 근로목적의 이동시간은 제외하고 근로현장에 도착한 시각</td>
				</tr>
				<tr>
					<td class="title" width="125">퇴근</td>
					<td width="375" colspan="3" align="center">&nbsp;<input type="text" name="end_dt" value="" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <select name="end_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                        </select>
                        <select name="end_m" >
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                        </select></td>
					<td class="title" width="500" colspan="4"> 근로현장을 이탈한 시각</td>
				</tr>
				<tr>
					<td class="title" width="125">실제근로시간</td>
					<td width="125" align="center">&nbsp;자동계산</td>
					<td class="title" width="125">인정근로시간</td>
					<td width="125" align="center">&nbsp;자동계산</td>
					<td class="title" width="500" colspan="4"> <font size="1">사무실외 현장근로는 근로한 시간이 2시간에 미치치 못한경우 인정근로시간을 2시간으로 함</font></td>
				</tr>
				<tr>
					<td class="title" width="125">근로현장명/주소</td>
					<td width="875" colspan="7">&nbsp;<INPUT TYPE="TEXT" NAME="over_addr" SIZE="120" ></td>
				</tr>
				<tr>
					<td class="title" width="125">근로사유</td>
					<td width="875" colspan="7">&nbsp;<textarea name="over_cont" cols='140' rows='5'></textarea></td>
				</tr>
				<tr>
					<td class="title" width="125">근로결과</td>
					<td width="875" colspan="7">&nbsp;<textarea name="over_cr" cols='140' rows='5'></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연장(휴무일)근로중 비용지출 내역</span></td>
	</tr>
	
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>	  
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width="65" rowspan="2">과목</td>
					<td width="165" colspan="2" rowspan="2" class="title">지출구분</td>
					<td class="title" width="100" rowspan="2">지출일자/<br>카드결재일자</td>
					<td class="title" width="100" rowspan="2">지출금액</td>
					<td class="title" width="270" rowspan="2"><p>증빙첨부<br>(현금지출)</p></td>
					<td class="title" width="300" colspan="3">현금비용청구/처리</td>
				</tr>
				<tr>
					<td class="title" width="100">금액</td>
					<td class="title" width="100">지급일자</td>
					<td class="title" width="100">전표번호</td>
				</tr>
				<tr>
					<td rowspan="3" class="title" width="65">식대</td>
					<td colspan="2" class="title" width="165">법인카드</td>
					<td width="100" align="center"><input type="text" name="over_card1_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
					<td width="100" align="center"><input type="text" name="over_card1_amt" size="10"></td>
					<td colspan="4" class="title" width="600"></td>
				</tr>
				<tr>
				  <td rowspan="2" class="title" width="65">현금</td>
			      <td class="title" width="100">자비</td>
			      <td width="100" align="center"><input type="text" name="over_cash1_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
			      <td width="100" align="center"><input type="text" name="over_cash1_amt" size="10"></td>
			      <td width="270" align="center"></td>
			      <td width="100" align="center"><input type="text" name="over_cash1_cr_amt" size="10"></td>
			      <td width="100" align="center"><input type="text" name="over_cash1_cr_dt" size="10" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
			      <td width="100" align="center"><input type="text" name="over_cash1_cr_jpno" size="10"></td>
			  </tr>
				<tr>
				  <td class="title" width="100">선급금</td>
			      <td width="100" align="center"><input type="text" name="over_s_cash1_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
			      <td width="100" align="center"><input type="text" name="over_s_cash1_amt" size="10"></td>
			      <td width="270" align="center"></td>
			      <td width="100" align="center"><input type="text" name="over_s_cash1_cr_amt" size="10"></td>
			      <td class="title" width="100"></td>
			      <td width="100" align="center"><input type="text" name="over_s_cash1_cr_jsno" size="10"></td>
			  </tr>
			  <tr>
					<td rowspan="3" class="title" width="50">여비<br>교통비</td>
					<td colspan="2" class="title" width="125">법인카드</td>
					<td width="100" align="center"><input type="text" name="over_card2_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
					<td width="100" align="center"><input type="text" name="over_card2_amt" size="10"></td>
					<td colspan="4" class="title" width="125"></td>
				</tr>
				<tr>
				  <td rowspan="2" class="title" width="50">현금</td>
			      <td class="title" width="100">자비</td>
			      <td width="100" align="center"><input type="text" name="over_cash2_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
			      <td width="100" align="center"><input type="text" name="over_cash2_amt" size="10"></td>
			      <td width="270" align="center"></td>
			      <td width="100" align="center"><input type="text" name="over_cash2_cr_amt" size="10"></td>
			      <td width="100" align="center"><input type="text" name="over_cash2_cr_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
			      <td width="100" align="center"><input type="text" name="over_cash2_cr_jpno" size="10"></td>
			  </tr>
				<tr>
				  <td class="title" width="100">선급금</td>
			      <td width="100" align="center"><input type="text" name="over_s_cash2_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
			      <td width="100" align="center"><input type="text" name="over_s_cash2_amt" size="10"></td>
			      <td width="270" align="center"></td>
			      <td width="100" align="center"><input type="text" name="over_s_cash2_cr_amt" size="10"></td>
			      <td class="title" width="100"></td>
			      <td width="100" align="center"><input type="text" name="over_s_cash2_cr_jpno" size="10"></td>
			  </tr>
			  <tr>
					<td rowspan="3" class="title" width="65">기타</td>
					<td colspan="2" class="title" width="150">법인카드</td>
					<td width="100" align="center"><input type="text" name="over_card3_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
					<td width="100" align="center"><input type="text" name="over_card3_amt" size="10"></td>
					<td colspan="4" class="title"  width="125"></td>
				</tr>
				<tr>
				  <td rowspan="2" class="title" width="65">현금</td>
			      <td class="title" width="100">자비</td>
			      <td width="100" align="center"><input type="text" name="over_cash3_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
			      <td width="100" align="center"><input type="text" name="over_cash3_amt" size="10"></td>
			      <td width="270" align="center"></td>
			      <td width="100" align="center"><input type="text" name="over_cash3_cr_amt" size="10"></td>
			      <td width="100" align="center"><input type="text" name="over_cash3_cr_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
			      <td width="100" align="center"><input type="text" name="over_cash3_cr_jpno" size="10"></td>
			  </tr>
				<tr>
				  <td class="title" width="125">선급금</td>
			      <td width="100" align="center"><input type="text" name="over_s_cash3_dt" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
			      <td width="100" align="center"><input type="text" name="over_s_cash3_amt" size="10"></td>
			      <td width="270" align="center"></td>
			      <td width="100" align="center"><input type="text" name="over_s_cash3_cr_amt" size="10"></td>
			      <td class="title" width="125"></td>
			      <td width="100" align="center"><input type="text" name="over_s_cash3_cr_jpno" size="10"></td>
			  </tr>
			  <tr>
					<td rowspan="3" class="title" width="65">합계</td>
					<td colspan="2" class="title" width="165">법인카드</td>
					<td width="100" class="title"></td>
					<td width="100" align="center"></td>
					<td colspan="4" class="title" width="600"></td>
				</tr>
				<tr>
				  <td rowspan="2" class="title" width="50">현금</td>
			      <td class="title" width="125">자비</td>
			      <td width="100" class="title"></td>
			      <td width="100" align="center"></td>
			      <td width="100" class="title"></td>
			      <td width="100" class="title"></td>
			      <td width="100" class="title"></td>
			      <td width="100" class="title"></td>
			  </tr>
				<tr>
				  <td class="title" width="100">선급금</td>
			      <td width="100" class="title"></td>
			      <td width="100" align="center"></td>
			      <td width="100" class="title"></td>
			      <td width="100" class="title"></td>
			      <td class="title" width="100"></td>
			      <td width="100" class="title"></td>
			  </tr>
        	</table>
        </td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연장(휴무일)근로수당 산출</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td rowspan="2" width="50" class="title">근로<br>수당<br>(참조)</td>
					<td width="150" class="title">산출식</td>
					<td colspan="6" width="600" align="center">수당 = 월통상급여 ÷ 209(시간) × 근로시간 × 할증율(150%)</td>
				</tr>
				<tr>
					<td class="title" width="150">시급산정기준 시간수의 산출근거</td>
					<td colspan="6" width="600" align="center">1)주4시간 근로&nbsp;&nbsp;&nbsp;2)1일 8시간 근로&nbsp;&nbsp;&nbsp;3)토요일은 무급 </td>
				</tr>
				<tr>
					<td colspan="2" class="title" width="200">산출급여 </td>
					<td colspan="2" width="200" align="right"><input type="text" name="over_scgy" size="20">원&nbsp;</td>
					<td width="125" class="title">지급예정일자 </td>
					<td width="125">&nbsp;<input type="text" name="over_scgy_dt" size="15" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
					<td width="125" class="title">PL등록일자 </td>
					<td width="125">&nbsp;<input type="text" name="over_scgy_pl_dt" size="15" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="125" rowspan="2" class="title">결재<br>(인사부서)</td>
					<td width="125" align="center" class="title">인사담당</td>
					<td width="125" align="center" class="title">급여담당자</td>
					<td width="125" align="center" class="title"></td>
					<td width="125" align="center" class="title"></td>
					<td width="125" align="center" class="title"></td>
					<td width="125" align="center" class="title"></td>
					<td width="125" align="center" class="title">대표이사</td>					
				</tr>
				<tr>
				  <td width="125" align="center">&nbsp;</td>
				  <td width="125" align="center">&nbsp;</td>
			      <td width="125" align="center">&nbsp;</td>
			      <td width="125" align="center">&nbsp;</td>
			      <td width="125" align="center">&nbsp;</td>
			      <td width="125" align="center">&nbsp;</td>
			      <td width="125" align="center">&nbsp;</td>
			  </tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td class=h></td>
	</tr>
		<tr>
		<td class=h></td>
	</tr>
	 <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<tr> 
        <td colspan="2" align='right'> <a href='javascript:Over_time_save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>&nbsp;<a href='javascript:Over_time_close()'><img src="/acar/images/center/button_cancel.gif" align=absmiddle border=0></a></td>
	</tr>
	<%}%>
</TABLE>
</form>
<iframe src="about:blank" name="i_no" width="125" height="125" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</BODY>

</HTML>
