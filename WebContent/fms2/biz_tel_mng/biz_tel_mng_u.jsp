<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.biz_tel_mng.* " %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>

<%	
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String user_id = "";
	String auth_rw = "";
	String reg_dt = "";
	String cmd = "";
	String tel_mng_id = request.getParameter("tel_mng_id")==null?"":request.getParameter("tel_mng_id");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

	reg_dt = Util.getDate();
	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	String user_nm = u_bean.getUser_nm();
	
	BiztelDatabase biz_db = BiztelDatabase.getInstance();
	
	Hashtable ht = biz_db.Biz_tel_mng_1st(tel_mng_id);

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
	fm.cmd.value = 'u';
	fm.target="i_no";
	fm.action="biz_tel_mng_a.jsp";
	fm.submit();


}

function data_del()
{
	var fm = document.form1;
	fm.cmd.value = 'd';
	fm.target="i_no";
	fm.action="biz_tel_mng_a.jsp";
	fm.submit();


}


//-->
</script>

</HEAD>
<body>
<form action="" name="form1" method="POST" >

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 견적시스템 > <span class=style5>영업전화상담결과 수정</span></span></td>
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
					<td width="30%" align='center'><%=ht.get("USER_NM")%></td>
					<td width="20%" class="title">작성일</td>
					<td width="30%" align='center'><%=ht.get("REG_DT")%></td>
				</tr>
				<tr>
					<td width="20%" class="title">상담구분</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_gubun" size='78' class='text' VALUE='<%=ht.get("TEL_GUBUN")%>'></td>
				</tr>
				<tr>
					<td width="20%" class="title">상담개시시간</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_time" size='78' class='text' value='<%=ht.get("TEL_TIME")%>'></td>
				</tr>
				<tr>
					<td width="20%" class="title">희망차종</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_car" size='78' class='text' VALUE='<%=ht.get("TEL_CAR")%>'></td>
				</tr>
				<tr>
					<td width="20%" class="title">차량구분</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_car_gubun" value='1' <%if(ht.get("TEL_CAR_GUBUN").equals("신차")){%>checked<%}%>>신차
						&nbsp;<input type='radio' name="tel_car_gubun" value='2' <%if(ht.get("TEL_CAR_GUBUN").equals("재리스")){%>checked<%}%>>재리스
						&nbsp;<input type='radio' name="tel_car_gubun" value='3' <%if(ht.get("TEL_CAR_GUBUN").equals("신차 및 재리스")){%>checked<%}%>>신차 및 재리스
						&nbsp;<input type='radio' name="tel_car_gubun" value='4' <%if(ht.get("TEL_CAR_GUBUN").equals("기타")){%>checked<%}%>>기타
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">용도구분</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_car_st" value='1' <%if(ht.get("TEL_CAR_ST").equals("렌트")){%>checked<%}%>>렌트
						&nbsp;<input type='radio' name="tel_car_st" value='2' <%if(ht.get("TEL_CAR_ST").equals("리스")){%>checked<%}%>>리스
						&nbsp;<input type='radio' name="tel_car_st" value='3' <%if(ht.get("TEL_CAR_ST").equals("렌트 및 리스")){%>checked<%}%>>렌트 및 리스
						&nbsp;<input type='radio' name="tel_car_st" value='4' <%if(ht.get("TEL_CAR_ST").equals("기타")){%>checked<%}%>>기타
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">관리구분</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_car_mng" value='1' <%if(ht.get("TEL_CAR_MNG").equals("기본식")){%>checked<%}%>>기본식
						&nbsp;<input type='radio' name="tel_car_mng" value='2' <%if(ht.get("TEL_CAR_MNG").equals("일반식")){%>checked<%}%>>일반식
						&nbsp;<input type='radio' name="tel_car_mng" value='3' <%if(ht.get("TEL_CAR_MNG").equals("기본식 및 일반식")){%>checked<%}%>>기본식 및 일반식
						&nbsp;<input type='radio' name="tel_car_mng" value='4' <%if(ht.get("TEL_CAR_MNG").equals("기타")){%>checked<%}%>>기타
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">업체명</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_firm_nm" size='78' class='text' value='<%=ht.get("TEL_FIRM_NM")%>'></td>
				</tr>
				<tr>
					<td width="20%" class="title">담당자</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_firm_mng" size='78' class='text' value='<%=ht.get("TEL_FIRM_MNG")%>'></td>
				</tr>
				<tr>
					<td width="20%" class="title">연락처</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_firm_tel" size='78' class='text' value='<%=ht.get("TEL_FIRM_TEL")%>'></td>
				</tr>
				<tr>
					<td width="20%" class="title">계약가능성</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_est_yn" value='1' <%if(ht.get("TEL_EST_YN").equals("기타")){%>checked<%}%> >기타
						&nbsp;<input type='radio' name="tel_est_yn" value='2' <%if(ht.get("TEL_EST_YN").equals("상")){%>checked<%}%>>상
						&nbsp;<input type='radio' name="tel_est_yn" value='3' <%if(ht.get("TEL_EST_YN").equals("중")){%>checked<%}%>>중
						&nbsp;<input type='radio' name="tel_est_yn" value='4' <%if(ht.get("TEL_EST_YN").equals("하")){%>checked<%}%>>하
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">영업구분</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_yp_gubun" value='1' <%if(ht.get("TEL_YP_GUBUN").equals("고객")){%>checked<%}%> >고객
						&nbsp;<input type='radio' name="tel_yp_gubun" value='2' <%if(ht.get("TEL_YP_GUBUN").equals("자동차영업사원")){%>checked<%}%>>자동차영업사원
						&nbsp;<input type='radio' name="tel_yp_gubun" value='3' <%if(ht.get("TEL_YP_GUBUN").equals("리스에이전트")){%>checked<%}%>>리스에이전트
						&nbsp;<input type='radio' name="tel_yp_gubun" value='4' <%if(ht.get("TEL_YP_GUBUN").equals("영업사원 또는 에이전트")){%>checked<%}%>>영업사원 또는 에이전트
						&nbsp;<input type='radio' name="tel_yp_gubun" value='5' <%if(ht.get("TEL_YP_GUBUN").equals("기타")){%>checked<%}%>>기타
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">영업사원이름</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_yp_nm" size='78' class='text' value='<%=ht.get("TEL_YP_NM")%>'></td>
				</tr>
				<tr>
					<td class="title">상담결과 및 메모</td>
					<td colspan="3" align=center><textarea name="tel_note" cols='76' rows='13' class='default'><%=ht.get("TEL_NOTE")%></textarea></td>
				</tr>
				<tr>
					<td width="20%" class="title">계약여부</td>
					<td width="40%">
						&nbsp;<input type='radio' name="tel_esty_yn" value='1' <%if(ht.get("TEL_ESTY_YN").equals("미확정")){%>checked<%}%> >미확정
						&nbsp;<input type='radio' name="tel_esty_yn" value='2' <%if(ht.get("TEL_ESTY_YN").equals("계약체결")){%>checked<%}%>>계약체결
						&nbsp;<input type='radio' name="tel_esty_yn" value='3' <%if(ht.get("TEL_ESTY_YN").equals("계약미체결")){%>checked<%}%>>계약미체결
					</td>
					<td width="20%" class="title">계약여부입력일</td>
					<td width="20%">&nbsp;<input type='text' name="tel_esty_dt" size='20' class='text' value='<%=AddUtil.getDate()%>'></td>
				</tr>
			</table>
		</td>
	</tr>

<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="tel_mng_id" value="<%=ht.get("TEL_MNG_ID")%>">
<input type="hidden" name="cmd" value="">
	<tr>
		<td><br>※ 등록대상 : 장기대여 영업상담건 중 사무실로 걸려 온 전화를 받은 경우<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;＊ 개인 휴대전화로 걸려온 건 및 스마트 견적상담은 입력하지 않습니다.<br>
		※ 위 내용 중 일부 항목만 입력해도 됩니다.
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td  align='center'><a href="javascript:data_save()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align=absmiddle border=0></a>&nbsp;&nbsp;<a href="javascript:data_del()"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
				    
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