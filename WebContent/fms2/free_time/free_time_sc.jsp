<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*, acar.free_time.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")		==	null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")			==	null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")		==	null?"":request.getParameter("user_id");
	String st_mon 		= request.getParameter("st_mon")		==	null?"":request.getParameter("st_mon");
	String gubun1 		= request.getParameter("gubun1")		==	null?"":request.getParameter("gubun1");
	String st_year 		= request.getParameter("st_year")		==	null?"":request.getParameter("st_year");
	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));	
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun2_word 	= request.getParameter("gubun2_word")	==	null?"":request.getParameter("gubun2_word");	//조건검색 추가(2018.02.13)
	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	

	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&gubun="+gubun+"&gubun2="+gubun2+"&gubun2_word="+gubun2_word+
					"&gubun3="+gubun3+"&gubun1="+gubun1+"&st_year="+st_year+"&st_mon="+st_mon+"&s_day="+s_day+
				   	"&sh_height="+height+"&dt="+dt+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+"";
					
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	//일괄등록하기
function free_reg()	{
		var SUBWIN="./free_time_i.jsp?auth_rw=<%=auth_rw%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";	
		window.open(SUBWIN, "free_reg", "left=100, top=50, width=750, height=400, scrollbars=yes");
	}
	
//연차신청 내용 보기
	function view_cont(user_id, doc_no){
		var fm = document.form1;
		fm.user_id.value = user_id;
		fm.doc_no.value = doc_no;
		fm.target ='d_content';
		fm.action = 'free_time_c.jsp';
		fm.submit();
	}
	
//취소요청 등록
function free_cancel(user_id, doc_no){
	var SUBWIN="free_time_cancel.jsp?user_id="+user_id+"&doc_no="+doc_no;	
		window.open(SUBWIN, "free_cancel", "left=100, top=50, width=630, height=400, scrollbars=yes");
	}

	
//취소요청 보기
function free_cancel_c(user_id, doc_no){
	var SUBWIN="free_time_cancel_c.jsp?user_id="+user_id+"&doc_no="+doc_no;	
		window.open(SUBWIN, "FREE_CANCEL_C","left=100, top=50, width=630, height=400, scrollbars=yes");
	}	
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="user_id" value="">
<input type="hidden" name="doc_no" value="">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   	
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr> 
		<td colspan="2" align='right'> <a href='javascript:free_reg()'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 cellpadding=0 width=100%>
				<tr> 
					<td class="title" width=5%>연번</td>
					<td class="title" width=8%%>구분</td>
					<td class="title" width=10%>휴가자</td>
					<td class="title" width=17%>휴가기간</td>
					<td class="title" width=10%>요일</td>
					<td class="title" width=10%>등록일자</td>
					<td class="title" width=14%>휴가구분</td>
					<td class="title" width=16%>내용</td>
					<td class="title" width=10%>취소요청</td>
					
				</tr>
			</table>
		</td>
		<td width=17>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="free_time_sc_in.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>