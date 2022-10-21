<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>

<%	
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String user_id = "";
	String auth_rw = "";
	String reg_dt = "";
	String cmd = "";
	
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

	reg_dt = Util.getDate();
	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	String user_nm = u_bean.getUser_nm();


%>
<HTML>
<HEAD>
<TITLE>::: 국내 최초, 국내 유일의 오토리스 장기렌트 동시영업 아마존카 :::</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function data_save()
{

	var fm = document.form1;
			
//	if(fm.est_nm.value == '')				{ alert('성명/법인명을 입력하십시오'); 		fm.est_nm.focus(); 		return;	}

	fm.cmd.value = 'i';
	fm.target="i_no";
	fm.action="biz_tel_mng_a.jsp";
	fm.submit();

}



//-->
</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
day = new Date();
miVisit = day.getTime();

function clock() {
	dayTwo = new Date();
	hrNow = dayTwo.getHours();
	mnNow = dayTwo.getMinutes();	
	scNow = dayTwo.getSeconds();
	miNow = dayTwo.getTime();
	

	if (hrNow == 0) {
		hour = 12;
		ap = " AM";
		} else if(hrNow <= 11) {
			ap = " AM";
			hour = hrNow;
		} else if(hrNow == 12) {
			ap = " PM";
			hour = 12;
		} else if (hrNow >= 13) {
			hour = (hrNow - 12);
			ap = " PM";
		}
	if (hrNow >= 13) {
		hour = hrNow - 12;
		}
	if (mnNow <= 9) {
		min = "0" + mnNow;
		}
		else (min = mnNow)
			if (scNow <= 9) {
				secs = "0" + scNow;
			} else {
				secs = scNow;
		}

	time = hour + "시 " + min + "분";
//	alert(document.form1.tel_time);
//	document.form1.tel_time.value = time;
	self.status = time;
	setTimeout('clock()', 1000);
}

function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      if (oldonload) {
        oldonload();
      }
      func();
    }
  }
}

//addLoadEvent(function() {
//  clock();
//}); 

clock();
// -->
</SCRIPT>
</HEAD>
<body>
<form action="" name="form1" method="POST" >

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 견적시스템 > <span class=style5>영업전화상담결과 등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="20%" class="title">작성자</td>
					<td width="30%" align="center"><%=user_nm%></td>
					<td width="20%" class="title">작성일</td>
					<td width="30%" align="center"><%=reg_dt%></td>
				</tr>
				<tr>
					<td width="20%" class="title">상담구분</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_gubun" size='78' class='text' value="사무실로 걸려 온 전화"></td>
				</tr>
				<tr>
					<td width="20%" class="title">상담개시시간</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_time" size='78' class='text' value='__시 __분' ></td>
				</tr>
				<tr>
					<td width="20%" class="title">희망차종</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_car" size='78' class='text'></td>
				</tr>
				<tr>
					<td width="20%" class="title">차량구분</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_car_gubun" value='1' checked >신차
						&nbsp;<input type='radio' name="tel_car_gubun" value='2' >재리스
						&nbsp;<input type='radio' name="tel_car_gubun" value='3' >신차 및 재리스
						&nbsp;<input type='radio' name="tel_car_gubun" value='4' >기타
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">용도구분</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_car_st" value='1' checked >렌트
						&nbsp;<input type='radio' name="tel_car_st" value='2' >리스
						&nbsp;<input type='radio' name="tel_car_st" value='3' >렌트 및 리스
						&nbsp;<input type='radio' name="tel_car_st" value='4' >기타
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">관리구분</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_car_mng" value='1' checked >기본식
						&nbsp;<input type='radio' name="tel_car_mng" value='2' >일반식
						&nbsp;<input type='radio' name="tel_car_mng" value='3' >기본식 및 일반식
						&nbsp;<input type='radio' name="tel_car_mng" value='4' >기타
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">업체명</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_firm_nm" size='78' class='text'></td>
				</tr>
				<tr>
					<td width="20%" class="title">담당자</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_firm_mng" size='78' class='text'></td>
				</tr>
				<tr>
					<td width="20%" class="title">연락처</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_firm_tel" size='78' class='text'></td>
				</tr>
				<tr>
					<td width="20%" class="title">계약가능성</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_est_yn" value='1' checked >기타
						&nbsp;<input type='radio' name="tel_est_yn" value='2' >상
						&nbsp;<input type='radio' name="tel_est_yn" value='3' >중
						&nbsp;<input type='radio' name="tel_est_yn" value='4' >하
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">영업구분</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_yp_gubun" value='1' checked >고객
						&nbsp;<input type='radio' name="tel_yp_gubun" value='2' >자동차영업사원
						&nbsp;<input type='radio' name="tel_yp_gubun" value='3' >리스에이전트
						&nbsp;<input type='radio' name="tel_yp_gubun" value='4' >영업사원 또는 에이전트
						&nbsp;<input type='radio' name="tel_yp_gubun" value='5' >기타
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">영업사원이름</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_yp_nm" size='78' class='text'></td>
				</tr>
				<tr>
					<td class="title">상담결과 및 메모</td>
					<td colspan="3" align=center><textarea name="tel_note" cols='76' rows='13' class='default'> </textarea></td>
				</tr>
				<tr>
					<td width="20%" class="title">계약여부</td>
					<td width="40%">
						&nbsp;<input type='radio' name="tel_esty_yn" value='1' >미확정
						&nbsp;<input type='radio' name="tel_esty_yn" value='2' >계약체결
						&nbsp;<input type='radio' name="tel_esty_yn" value='3' >계약미체결
					</td>
					<td width="20%" class="title">계약여부입력일</td>
					<td width="20%">&nbsp;<input type='text' name="tel_esty_dt" size='20' class='text' value='<%=AddUtil.getDate()%>'></td>
				</tr>
			</table>
		</td>
	</tr>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="reg_dt" value="<%=reg_dt%>">
<input type="hidden" name="cmd" value="">
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td>※ 등록대상 : 장기대여 영업상담건 중 사무실로 걸려 온 전화를 받은 경우<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;＊ 개인 휴대전화로 걸려온 건 및 스마트 견적상담은 입력하지 않습니다.<br>
		※ 위 내용 중 일부 항목만 입력해도 됩니다.
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td  align='center'><a href="javascript:data_save()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>&nbsp;&nbsp;<a href="javascript:self.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>



</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</BODY>
</HTML>