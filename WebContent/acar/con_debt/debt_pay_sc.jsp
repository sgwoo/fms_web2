<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//출금처리&자동전표발행
	function pay_allot(mode, auth_rw, c_id, alt_tm, lend_id, gubun, rtn_seq, idx){
		var fm = document.form1;	
		window.open("debt_pay_p.jsp?auth_rw="+auth_rw+"&mode="+mode+"&gubun="+gubun+"&car_id="+c_id+"&lend_id="+lend_id+"&alt_tm="+alt_tm+"&rtn_seq="+rtn_seq+"&idx="+idx+"&user_id="+fm.user_id.value, "PAY_ALLOT", "left=100, top=100, width=550, height=275");
	}
	
	//세부내용 보기
	function view_allot(m_id, l_cd, c_id, lend_id, gubun, rtn_seq, idx)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.lend_id.value = lend_id;
		fm.c_id.value = c_id;
		fm.rtn_seq.value = rtn_seq;
		fm.idx.value = idx;						
		if(gubun == '0'){		//일반할부금스케줄
			fm.action = 'debt_c.jsp';
		}else if(gubun == '1'){	//은행대출(bank_sche)
			fm.action = 'debt_c_bank.jsp';
		}else if(gubun == '2'){	//은행대출(scd_bank)
			fm.action = 'debt_c_bank2.jsp';
		}
		fm.target= 'd_content';
		fm.submit();
	}
	
	//리스트 엑셀 전환 -- 출금원장으로 현재 사용안함.
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "popup_excel.jsp";
		fm.submit();
	}	
	//리스트 엑셀 전환
	function pop_auto(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "popup_auto.jsp";
		fm.submit();
	}	
	
	//스케줄관리 이동
	function allot_scd(){
		var fm = document.form1;
		fm.gubun2.value = '5';
		fm.gubun3.value = '2';		
		fm.sort_gubun.value = "0";
		fm.asc.value = "1";		
		fm.target = "d_content";
		fm.action = "debt_scd_frame_s.jsp";
		fm.submit();
	}		
	//현황
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
		document.form1.action="debt_pay_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
//	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
//	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='/acar/con_debt/debt_pay_sc.jsp' target='' method='post'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='seq_no' value=''>
<input type='hidden' name='lend_id' value=''>
<input type='hidden' name='rtn_seq' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='pay'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
		<td align='right'>
			<a href="javascript:pop_excel();"><img src=../images/center/button_excel.gif align=absmiddle border=0></a>
			<!-- 출금원장으로 현재 사용안함.
			&nbsp;<a href="javascript:pop_auto();"><img src=../images/center/button_igcr.gif align=absmiddle border=0></a>
			-->
		</td>
	</tr>
	<tr>
		<td>
			<iframe src="/acar/con_debt/debt_pay_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>#<%=idx%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > </iframe>
		</td>
	</tr>
</table>
</form>
</body>
</html>