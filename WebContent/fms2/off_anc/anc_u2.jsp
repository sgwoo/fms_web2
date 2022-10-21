<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*,acar.common.*" %>
<%@ page import="acar.off_anc.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<jsp:useBean id="f_bean" class="acar.off_anc.Bbs_FBean" scope="page"/>

<%
	OffAncDatabase oad = OffAncDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	int bbs_id = 0;
	String user_id = "";
	String acar_id = "";
	String user_nm = "";
	String br_id = "";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";
	String reg_dt = "";
	String exp_dt = "";
	String title = "";
	String content = "";
	String read_yn = "";
    String auth_rw = "";
    String cmd = "";
	String bbs_st = request.getParameter("bbs_st")==null?"":request.getParameter("bbs_st");

	int count = 0;

	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("bbs_id") != null) bbs_id = Util.parseInt(request.getParameter("bbs_id"));
	

	//acar_id = login.getCookieValue(request, "acar_id");
	acar_id = ck_acar_id;

	a_bean = oad.getAncBean(bbs_id);
	f_bean = oad.getBbs_FBean2(bbs_id);
	
	user_id = a_bean.getUser_id();
	user_nm = a_bean.getUser_nm();
	dept_nm = a_bean.getDept_nm();
	reg_dt = a_bean.getReg_dt();
	exp_dt = a_bean.getExp_dt();
	title = a_bean.getTitle();
	content = a_bean.getContent();
	read_yn = a_bean.getRead_yn();
	bbs_st = a_bean.getBbs_st();

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<!-- <SCRIPT LANGUAGE=JAVASCRIPT SRC="Calendar_1.js"></SCRIPT> -->

<SCRIPT LANGUAGE=JAVASCRIPT>

function NowDateCall() {
var NowDay = new Date;
var DDyear = NowDay.getYear();
var DDmonth = NowDay.getMonth() + 1;
var DDday = NowDay.getDate();
if (DDmonth < 10) { DDmonth = "0" + DDmonth; }
if (DDday < 10) { DDday = "0" + DDday; }
AncRegForm.exp_dt.value = DDyear + "-" + DDmonth + "-" + DDday;
}
</SCRIPT>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
	//리스트
	function list(){
		var fm = document.AncUpForm;			
		fm.action = 'anc_s_grid_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}
	
function AncUp()
{
	var theForm = document.AncUpForm;
	if(theForm.title1.value == '')		{	alert('제목을 입력하십시오');	return;	}
	//else if(theForm.content.value == null)	{	alert('내용을 입력하십시오');	return;	}
//	if(get_length(theForm.content.value) > 4000){
//		alert("4000자 까지만 입력할 수 있습니다.");
//		return;
//	}	
	if(!confirm('수정하시겠습니까?'))
		return;		
	theForm.cmd.value = "u";
	theForm.action = "anc_null_ui.jsp";
	theForm.target="i_no";
	theForm.submit();
}
function AncDl()
{
	var theForm = document.AncUpForm;
	if(!confirm('삭제하시겠습니까?'))
		return;	
	theForm.cmd.value = "d";
	theForm.target="i_no";
	theForm.action = "anc_null_ui.jsp";	
	theForm.submit();
}
function ChangeDT()
{
	var theForm = document.AncUpForm;
	theForm.exp_dt.value = ChangeDate(theForm.exp_dt.value);
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
function AncClose()
{
	//opener.parent.c_body.SearchBbs();
	//self.close();
	window.close();
}

//리스트 가기	
function go_to_list()
{
		var fm = document.AncUpForm;
				
		var auth_rw = fm.auth_rw.value;
	
		location = "anc_s_frame.jsp?auth_rw="+auth_rw;
	
}	
//디스플레이 타입
function cng_est_st2(st) {
	var fm = document.form1;
	if(st == "1"){ 			//경사
		est_st3_1.style.display	= '';						
		est_st3_2.style.display	= 'none';		
	}else if(st == "2"){	//조사
		est_st3_1.style.display	= 'none';						
		est_st3_2.style.display	= '';		
	}
}

function file_save(){
		var fm = document.AncUpForm;	
				
		if(!confirm('파일등록하시겠습니까?')){
			return;
		}
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.BBS%>";
		fm.submit();
	}
	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="../js/datepicker/jquery-ui.min.css"><!-- date picker c s s 2018.02.06 -->
</head>
<body onLoad="javascript:self.focus()">
<form  name="AncUpForm" method="post" >
<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
<input type="hidden" name="title_st" value="<%=f_bean.getTitle_st()%>">
<input type="hidden" name="bbs_st" value="<%=a_bean.getBbs_st()%>">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > 공지사항 > <span class=style5>공지사항수정</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan='4' align='right'><a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
			<!--<a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>--></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class="title">카테고리</td>
					<td align="center" colspan="3">
					<INPUT TYPE="radio" NAME="bbs_st" value="1" <%if(a_bean.getBbs_st().equals("1")){%>checked<%}%>	>일반공지&nbsp;&nbsp; 
					<INPUT TYPE="radio" NAME="bbs_st" value="4" <%if(a_bean.getBbs_st().equals("4")){%>checked<%}%>	>업무협조&nbsp;&nbsp;
					<INPUT TYPE="radio" NAME="bbs_st" value="5" <%if(a_bean.getBbs_st().equals("5")){%>checked<%}%>	>경조사&nbsp;&nbsp;
					<INPUT TYPE="radio" NAME="bbs_st" value="6" <%if(a_bean.getBbs_st().equals("6")){%>checked<%}%>	>규정및인사&nbsp;&nbsp;
					<INPUT TYPE="radio"	NAME="bbs_st" value="2" <%if(a_bean.getBbs_st().equals("2")){%>checked<%}%>	>최근뉴스&nbsp;&nbsp; 
					<INPUT TYPE="radio" NAME="bbs_st" value="3" <%if(a_bean.getBbs_st().equals("3")){%>checked<%}%>	>판매조건&nbsp;&nbsp; 
					</td>
				</tr>
				<tr>
					<td class="title" >작성자</td>
					<td align="center"><%=user_nm%></td>
					<td class="title" >부서</td>
					<td align="center" ><%=dept_nm%></td>
					
				</tr>
				<tr>
					<td class="title" width="72">작성일</td>
					<td align="center" width="117"><%=reg_dt%></td>
					<td class="title" width="72">만료일</td>
					<td align="center" width="339" valign="bottom">
					<input type='text' name="exp_dt" id="exp_dt" size='20' class='text' onBlur="javascript:ChangeDT()" value="<%=a_bean.getExp_dt()%>">
					<!-- <IMG onfocus=this.blur() id="datepicker" src="/acar/images/center/button_in_calendar.gif" border=0 align='absmiddle'> -->
					</td>
				</tr>
				<tr>
					<td align="center" class="title">제목</td>
					<td align="center" colspan="3">
						<%if(a_bean.getRead_yn().equals("Y")){%> <img src="/images/n_icon.gif"	border=0 align=absmiddle>&nbsp; <%}%> 
						
						<input type='text' name="title1" id="title1" value="<%=a_bean.getTitle()%>" size='70' class='text'>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<%if(f_bean.getTitle_st().equals("1")||f_bean.getTitle_st().equals("3")){%>
	<tr>
		<td class='line' >
			<table border="0" cellspacing="1" cellpadding="0" width="100%">				
				<tbody>
					<tr>
					  <td colspan="1" rowspan="3" class="title" width=15%>당사자</td>
					  <td class="title" width=15%>성명</td>
					  <td>&nbsp;<%=f_bean.getD_user_nm()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>부서</td>
					  <td>&nbsp;<%=f_bean.getD_dept_nm()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>전화번호</td>
					  <td>&nbsp;<%=f_bean.getD_user_h_tel()%></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="2" class="title" width=15%>행사일시</td>
					  <td class="title" width=15%>시작</td>
					  <td>&nbsp;&nbsp;<input type='text' name="d_day_st1" id="d_day_st1" size='60' class='text' value='<%=f_bean.getD_day_st()%>'></td>
					</tr>
					<tr>
					  <td class="title" width=15%>종료</td>
					  <td>&nbsp;&nbsp;<input type='text' name="d_day_ed" id="d_day_ed" size='60' class='text' value='<%=f_bean.getD_day_ed()%>'></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="3" class="title" width=15%>장소</td>
					  <td class="title" width=15%>명칭</td>
					  <td>&nbsp;&nbsp;<input type='text' name="place_nm1" id="place_nm1" size='60' class='text' value='<%=f_bean.getPlace_nm()%>'></td>
					</tr>
					<tr>
					  <td class="title" width=15%>전화번호</td>
					  <td>&nbsp;&nbsp;<input type='text' name="place_tel1" id="place_tel1" size='60' class='text' value='<%=f_bean.getPlace_tel()%>'></td>
					</tr>
					<tr>
					  <td class="title" width=15%>주소</td>
					  <td>&nbsp;&nbsp;<input type='text' name="place_addr1" id="place_addr1" size='60' class='text' value='<%=f_bean.getPlace_addr()%>'></td>
					</tr>
					<tr>
						<td class="title" colspan="2" width=30%>첨언</td>
						<td colspan="">&nbsp;&nbsp;<textarea name="content1" id="content1" cols='65' rows='7'><%=a_bean.getContent()%></textarea></td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
	<%}else if(f_bean.getTitle_st().equals("2")){%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">				
				<tbody>
					<tr>
					  <td colspan="1" rowspan="3" class="title" width=15%>당사자</td>
					  <td class="title" width=15%>성명</td>
					  <td>&nbsp;<%=f_bean.getD_user_nm()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>부서</td>
					  <td>&nbsp;<%=f_bean.getD_dept_nm()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>전화번호</td>
					  <td>&nbsp;<%=f_bean.getD_user_h_tel()%></td>
					</tr>
					<%-- <tr>
					  <td colspan="1" rowspan="3" class="title" width=15%>고인</td>
					  <td class="title" width=15%>성명</td>
					  <td>&nbsp;&nbsp;<%=f_bean.getDeceased_nm()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>영면일시</td>
					  <td>&nbsp;&nbsp;<%=f_bean.getDeceased_day()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>관계</td>
					  <td>&nbsp;&nbsp;<%=f_bean.getFamily_relations()%></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="2" class="title" width=15%>발인</td>
					  <td class="title" width=15%>일시</td>
					  <td>&nbsp;&nbsp;<%=f_bean.getD_day_st()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>장소</td>
					  <td>&nbsp;&nbsp;<%=f_bean.getD_day_place()%></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="4" class="title" width=15%>문상</td>
					  <td class="title" width=15%>상주</td>
					  <td>&nbsp;&nbsp;<%=f_bean.getChief_nm()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>명칭</td>
					  <td>&nbsp;&nbsp;<%=f_bean.getPlace_nm()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>전화번호</td>
					  <td>&nbsp;&nbsp;<%=f_bean.getPlace_tel()%></td>
					</tr>
					<tr>
					  <td class="title" width=15%>주소</td>
					  <td>&nbsp;&nbsp;<%=f_bean.getPlace_addr()%></td>
					</tr> --%>
					<!-- 수정 가능하게 input태그처리(2017.12.29) S-->
					<tr>
					  <td colspan="1" rowspan="3" class="title" width=15%>고인</td>
					  <td class="title" width=15%>성명</td>
					  <td>&nbsp;&nbsp;<input type='text' name="deceased_nm" size='60' class='text' value='<%=f_bean.getDeceased_nm()%>'></td>
					</tr>
					<tr>
					  <td class="title" width=15%>영면일시</td>
					  <td>&nbsp;&nbsp;<input type='text' name="deceased_day" size='60' class='text' value='<%=f_bean.getDeceased_day()%>'></td>
					</tr>
					<tr>
					  <td class="title" width=15%>관계</td>
					  <td>&nbsp;&nbsp;<input type='text' name="family_relations" size='60' class='text' value='<%=f_bean.getFamily_relations()%>'></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="2" class="title" width=15%>발인</td>
					  <td class="title" width=15%>일시</td>
					  <td>&nbsp;&nbsp;<input type='text' name="d_day_st2" size='60' class='text' value='<%=f_bean.getD_day_st()%>'></td>
					</tr>
					<tr>
					  <td class="title" width=15%>장소</td>
					  <td>&nbsp;&nbsp;<input type='text' name="d_day_place" size='60' class='text' value='<%=f_bean.getD_day_place()%>'></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="4" class="title" width=15%>문상</td>
					  <td class="title" width=15%>상주</td>
					  <td>&nbsp;&nbsp;<input type='text' name="chief_nm" size='60' class='text' value='<%=f_bean.getChief_nm()%>'></td>
					</tr>
					<tr>
					  <td class="title" width=15%>명칭</td>
					  <td>&nbsp;&nbsp;<input type='text' name=place_nm2 size='60' class='text' value='<%=f_bean.getPlace_nm()%>'></td>
					</tr>
					<tr>
					  <td class="title" width=15%>전화번호</td>
					  <td>&nbsp;&nbsp;<input type='text' name=place_tel2 size='60' class='text' value='<%=f_bean.getPlace_tel()%>'></td>
					</tr>
					<tr>
					  <td class="title" width=15%>주소</td>
					  <td>&nbsp;&nbsp;<input type='text' name=place_addr2 size='60' class='text' value='<%=f_bean.getPlace_addr()%>'>
					  		<input type='hidden' name=d_user_id2 size='60' class='text' value='<%=f_bean.getD_user_id()%>'>	
					  </td>
					</tr>
					<!-- 수정 가능하게 input태그처리(2017.12.29) E-->
					<tr>
						<td class="title" colspan="2" width=30%>첨언</td>
						<td colspan="">&nbsp;&nbsp;<textarea name="content2"	cols='65' rows='7'><%=a_bean.getContent()%></textarea></td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
		<td class=h></td>
	</tr>
	<%}%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">		
				<tr> 
					 <td align='center'class='title' width="30%">첨부파일1</td>
					 <td colspan="3">&nbsp;&nbsp;<input type='file' name="file" size='90' class='text'>
				<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=bbs_id%>' />
				<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.BBS%>' /></td>
				</tr>
				<tr> 
					 <td align='center'class='title' width="30%">첨부파일2</td>
					 <td colspan="3">&nbsp;&nbsp;<input type='file' name="file" size='90' class='text'>
				<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=bbs_id%>' />
				<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.BBS%>' /></td>
				</tr>
			</table>
		</td>
	</tr>
	</tr>
		<td class=h></td>
	</tr>
	<%if(f_bean.getTitle_st().equals("1")){%>
	<tr>
		<td><b>Ο 사내 규정</b><br>
		&nbsp;&nbsp;1) 화환 : 회사가 대표로 지급<br>
		&nbsp;&nbsp;2) 경조금 : 회사는 사규에 정하고, 개인적 친분 관계에 따른 부조는 통제하지 않음.<p>
		</td>
	</tr>
	<!-- 
	<tr>
		<td>2. 사외(회사와 거래관계, 하청관계) 경조사 규정 (2012-06-05 현재)<br>
		&nbsp;&nbsp;1) 화환 : 회사가 대표로 지급(사내직원과 동일한 품질)<br>
		&nbsp;&nbsp;2) 축의금 : 회사는 지급하지 않고, 개인적 친분 관계에 따른 부조는 통제하지 않음.
		</td>
	</tr>
	 -->
	<%}else if(f_bean.getTitle_st().equals("2")){%>
	<tr>
		<td><b>Ο 사내 규정</b><br>
		&nbsp;&nbsp;1) 조화 : 회사가 조치<br>
		&nbsp;&nbsp;2) 부조금액 : 회사의 공식 부조금만 지급하고 직원간 부조는 일체 하지 않음.<p>
		</td>
	</tr>
	<!-- 
	<tr>
		<td>2. 사외(회사와 거래관계, 하청관계) 조사 규정 (2012-06-05 현재)<br>
		&nbsp;&nbsp;1) 경조사에 대해 당사직원과 협력업체직원간에 굳이 확대하여 알리지 않음.<br>
			      &nbsp;&nbsp;2) 어떤 사정으로 알게 되더라도 다음과 같은 원칙하에 처리함.<br>
			       &nbsp;&nbsp;&nbsp;&nbsp;   ① 경사의 경우 직원본인에 한해 참석할 경우에만 최소한의 부조를 함.<br>
			       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       (불참 시 다른 직원을 통한 대리부조는 하지 않는 것으로 함.)<br>
			       &nbsp;&nbsp;&nbsp;&nbsp;   ② 조사의 경우 본인 및 본인의 부모(배우자부모제외)상에 한해 참석하는 경우에만 최소한의 부조를 함.<br>
			       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       (역시 불참 시 다른 사람을 통한 대리부조는 하지 않음.)<br>
		</td>
	</tr>
	 -->
	<%}%>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td colspan='4' align='right'><a href="javascript:file_save()">첨부파일등록</a>&nbsp;&nbsp;&nbsp;
		<%if(!f_bean.getTitle_st().equals("")){ %>
			<a href="javascript:AncUp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align=absmiddle border=0></a>
		<%} %>
		<a href="javascript:AncDl()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align=absmiddle border=0></a>&nbsp;

		</td>
	</tr>
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
	<input type="hidden" name="bbs_st" value="<%=bbs_st%>">
	<input type="hidden" name="cmd" value="">
		
</table>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="../js/datepicker/jquery-ui.min.js"></script><!-- date picker j s 2018.02.06 -->
<script src="../js/datepicker/datepicker-ko.js"></script><!-- date picker j s 2018.02.06 -->
<script>
	// 특수문자 ' " \ 제한 2018.02.06
	var regex = /['"\\]/gi;

	var title1;					// 제목
	var content1;			// 첨언
	var content2;			// 첨언
	var d_day_st1;			// 행사일시 시작
	var d_day_ed;			// 행사일시 종료
	var place_nm1;		// 장소 명칭
	var place_tel1;			// 장소 전화번호
	var place_addr1;		// 주소
	var deceased_nm;	// 부고 고인 성명
	var deceased_day;	// 부고 고인 영면일시
	var family_relations;	// 부고 고인과 관계
	var d_day_place;		// 장례식장 장소
	var chief_nm;			// 상주
	var place_nm2;		// 영결식상호
	var place_tel2;			// 장례식장 전화번호
	var place_addr2;		// 장례식장 주소
	
	$("#title1").bind("keyup",function(){title1 = $("#title1").val();if(regex.test(title1)){$("#title1").val(title1.replace(regex,""));}});
	$("#content1").bind("keyup",function(){content1 = $("#content1").val();if(regex.test(content1)){$("#content1").val(content1.replace(regex,""));}});
	$("#content2").bind("keyup",function(){content2 = $("#content2").val();if(regex.test(content2)){$("#content2").val(content2.replace(regex,""));}});
	$("#d_day_st1").bind("keyup",function(){d_day_st1 = $("#d_day_st1").val();if(regex.test(d_day_st1)){$("#d_day_st1").val(d_day_st1.replace(regex,""));}});
	$("#d_day_ed").bind("keyup",function(){d_day_ed = $("#d_day_ed").val();if(regex.test(d_day_ed)){$("#d_day_ed").val(d_day_ed.replace(regex,""));}});
	$("#place_nm1").bind("keyup",function(){place_nm1 = $("#place_nm1").val();if(regex.test(place_nm1)){$("#place_nm1").val(place_nm1.replace(regex,""));}});
	$("#place_tel1").bind("keyup",function(){place_tel1 = $("#place_tel1").val();if(regex.test(place_tel1)){$("#place_tel1").val(place_tel1.replace(regex,""));}});
	$("#place_addr1").bind("keyup",function(){place_addr1 = $("#place_addr1").val();if(regex.test(place_addr1)){$("#place_addr1").val(place_addr1.replace(regex,""));}});
	$("#deceased_nm").bind("keyup",function(){deceased_nm = $("#deceased_nm").val();if(regex.test(deceased_nm)){$("#deceased_nm").val(deceased_nm.replace(regex,""));}});
	$("#deceased_day").bind("keyup",function(){deceased_day = $("#deceased_day").val();if(regex.test(deceased_day)){$("#deceased_day").val(deceased_day.replace(regex,""));}});
	$("#family_relations").bind("keyup",function(){family_relations = $("#family_relations").val();if(regex.test(family_relations)){$("#family_relations").val(family_relations.replace(regex,""));}});
	$("#d_day_place").bind("keyup",function(){d_day_place = $("#d_day_place").val();if(regex.test(d_day_place)){$("#d_day_place").val(d_day_place.replace(regex,""));}});
	$("#chief_nm").bind("keyup",function(){chief_nm = $("#chief_nm").val();if(regex.test(chief_nm)){$("#chief_nm").val(chief_nm.replace(regex,""));}});
	$("#place_nm2").bind("keyup",function(){place_nm2 = $("#place_nm2").val();if(regex.test(place_nm2)){$("#place_nm2").val(place_nm2.replace(regex,""));}});
	$("#place_tel2").bind("keyup",function(){place_tel2 = $("#place_tel2").val();if(regex.test(place_tel2)){$("#place_tel2").val(place_tel2.replace(regex,""));}});
	$("#place_addr2").bind("keyup",function(){place_addr2 = $("#place_addr2").val();if(regex.test(place_addr2)){$("#place_addr2").val(place_addr2.replace(regex,""));}});
	
	$(function(){
		$("#exp_dt").datepicker({
			showOn: "both",
			buttonImage: "/acar/images/center/button_in_calendar.gif",
			buttonImageOnly: true,
			buttonText : "달력"
		});
	});
	
</script>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
	</form>
</body>
</html>