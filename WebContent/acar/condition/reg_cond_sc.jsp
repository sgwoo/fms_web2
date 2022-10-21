<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");	
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");	
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");	
	String fn_id= "0";
	
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function CarRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.car_mng_id.value = car_mng_id;
	theForm.cmd.value = reg_gubun;
	theForm.rpt_no.value = rpt_no;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.imm_amt.value = imm_amt;
	
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		theForm.action = "./register_frame.jsp";
<%	}else{%>
		if(reg_gubun=="id"){	alert("미등록 상태입니다.");	return;	}
		theForm.action = "./register_frame.jsp";
<%	}%>
	theForm.target = "d_content"
	theForm.submit();
}

//계약서 내용 보기
	function view_cont(m_id, l_cd, use_yn, car_st){
		var fm =  document.CarRegDispForm;
		fm.rent_mng_id.value = m_id;
		fm.rent_l_cd.value = l_cd;
		fm.from_page.value = '/acar/condition/reg_cond_frame.jsp';
		if(car_st == '예비') fm.c_st.value = 'car';
		fm.target ='d_content';
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';
		fm.submit();
	}
	
	//스캔관리 보기
	function view_scan(m_id, l_cd)
	{
		<%if(nm_db.getWorkAuthUser("계약서재스캔담당",ck_acar_id)){%>
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, scrollbars=yes");		
		<%}else{%>
		window.open("/fms2/lc_rent/view_scan.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, scrollbars=yes");				
		<%}%>
	}	
//-->
</script>
</head>
<body>
<form action="./register_frame.jsp" name="CarRegDispForm" method="POST">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="rpt_no" value="">
<input type="hidden" name="firm_nm" value="">
<input type="hidden" name="client_nm" value="">
<input type="hidden" name="imm_amt" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="from_page" value="">
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>
	<td><iframe src="./reg_cond_sc_in.jsp?height=<%=height%>&auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&br_id=<%=br_id%>&sort=<%=sort%>" name="RegCondList" width="100%" height="<%=height+50%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>							
</table>
</body>
</html>