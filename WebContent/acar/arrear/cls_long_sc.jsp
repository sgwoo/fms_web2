<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cls.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

	function reg_credit(m_id, l_cd)
	{
		var auth_rw = document.form1.auth_rw.value;		
		window.open("/acar/arrear/credit_memo.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd, "CREDIT_MEMO", "left=100, top=100, width=450, height=300");
	}
	
	function view_credit(m_id, l_cd, arr_type)
	{
		var auth_rw = document.form1.auth_rw.value;		
		window.open("/acar/arrear/view_credit_memo.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd+"&arr_type="+arr_type, "CREDIT_MEMO", "left=100, top=100, width=550, height=400");
	}
		
	//통화 메모 보기
	function view_memo(m_id, l_cd, c_id, tm_st, accid_id, serv_id, mng_id){
		var auth_rw = document.form1.auth_rw.value;
		window.open("/acar/con_ins_m/ins_memo_frame_s.jsp?auth_rw="+auth_rw+"&tm_st="+tm_st+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&serv_id="+serv_id+"&mng_id="+mng_id, "INS_MEMO", "left=100, top=100, width=800, height=600");
	}
	
	function view_memo2(m_id, l_cd, r_st, fee_tm, tm_st1, bus_id2)
	{
		var auth_rw = document.form1.auth_rw.value;		
//		window.open("/fms2/con_fee/fee_memo_frame_s.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st+"&fee_tm="+fee_tm+"&tm_st1="+tm_st1+"&bus_id2="+bus_id2, "FEE_MEMO", "left=0, top=0, width=800, height=750");
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st+"&fee_tm="+fee_tm+"&tm_st1="+tm_st1+"&bus_id2="+bus_id2, "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");		
	}	
	
	//면책금 세부내용 보기
	function view_cls(m_id, l_cd, c_id){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;		
		fm.target = "d_content";
		fm.action = "/acar/con_cls/cls_c.jsp";
		fm.submit();
	}
	
	//고객 보기
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}
		
	//중도해지 대여료 이동
	function cls_cls(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "/acar/con_cls/clsfee_s_frame.jsp";
		fm.submit();
	}		
	//현황
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
		document.form1.action="cls_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"4":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	

	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String search_kd = "";
	String brch_id = "";
	String bus_id2 = "";
	
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
%>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='cls'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	<td>
      <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
				<td align='center'>
				  <iframe src="/acar/arrear/cls_long_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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
