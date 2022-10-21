<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.call.*, acar.user_mng.* " %>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	/*여기부터 수정문안*/
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//사용자ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");		//소속사ID
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String g_fm = "1";
	
	String mode_str = request.getParameter("mode")==null?"":request.getParameter("mode"); 		//등록,조회(수정)구분
	String use_yn 	= request.getParameter("use_yn")==null?"":request.getParameter("use_yn"); 	//계약상태
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id"); 		//계약서관리번호(rent_mng_id)
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd"); 		//계약번호		(rent_l_cd)
	String cls_st 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st"); 	//재등록일때(계약이관,차종변경)
	
	String b_lst 	= request.getParameter("b_lst")==null?"cont":request.getParameter("b_lst"); //요청페이지구분
	String cls_dt 	= request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String type 	= request.getParameter("type")==null?"1":request.getParameter("type"); //페이지구분
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "16", "01", "01");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//cont call  reg_id
	String reg_id 	= "";
	reg_id = p_db.getCallReg_id(m_id, l_cd);	
	
	if ( reg_id.equals("")) {
		reg_id = user_id;
	}
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

	//등록하기
	function save()
	{		
		var fm = document.form1;		
		var t_fm = parent.c_foot.document.form1;
			
		t_fm.t_con_cd.value 		= fm.t_con_cd.value;
		t_fm.t_rent_dt.value 		= fm.t_rent_dt.value;
		t_fm.s_rent_st.value 		= fm.s_rent_st.value;
		t_fm.s_car_st.value 		= fm.s_car_st.value;
		t_fm.h_brch.value 			= fm.h_brch.value;
	//	t_fm.s_bus_id.value 		= fm.s_bus_id.value;		
		t_fm.s_dept_id.value 		= fm.s_dept_id.value;		
		t_fm.s_rent_way.value 		= fm.s_rent_way.value;
		t_fm.s_bus_st.value 		= fm.s_bus_st.value;
		t_fm.t_con_mon.value 		= fm.t_con_mon.value;
		t_fm.t_rent_start_dt.value 	= fm.t_rent_start_dt.value;
		t_fm.t_rent_end_dt.value 	= fm.t_rent_end_dt.value;
		t_fm.use_yn.value 			= fm.use_yn.value;
	//	t_fm.s_bus_id2.value		= fm.s_bus_id2.value;			
	//	t_fm.s_mng_id.value 		= fm.s_mng_id.value;
	//	t_fm.s_mng_id2.value 		= fm.s_mng_id2.value;				
	}


	//수정하기
	function update()
	{
		var fm = document.form1;	
		save();			
		parent.c_foot.save();
		
	}	
	
	//수정하기
	function nocall()
	{
		var fm = document.form1;	
		if(confirm('Call 비대상으로 지정하시겠습니까?')){
			fm.target='nodisplay';
//			fm.target='parent.c_foot';
			fm.action='call_reg_cont_u_a.jsp';
			fm.submit();
		}
				
	}	
	
	
	//목록보기
	function list(b_lst)
	{
		var fm = document.form1;
		var auth = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var brch_id = fm.brch_id.value;
		var s_bank = fm.s_bank.value;
		var t_wd = fm.t_wd.value;		
		var cont_st = fm.cont_st.value;		
		var type1 = fm.type.value;		
		
		if ( type1 == '1' ) {
			parent.location='survey_rm_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
		} else { 
			          
			parent.location='survey_rm_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
			
		}
	}		

	
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<div class="navigation">
	<span class=style1>콜센터 ></span><span class=style5>월렌트상세현황</span>
</div>

</body>
</html>