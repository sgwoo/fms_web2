<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "1";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-90;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
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
	
<% 
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
		//theForm.action = "./register_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}else{
%>
		if(reg_gubun=="id")
		{
			alert("미등록 상태입니다.");
			return;
		}
		//theForm.action = "./register_r_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}
%>
	theForm.target = "d_content"
	theForm.submit();
}

 	//계약서 내용 보기
	function view_cont(m_id, l_cd){
		var fm = document.form1;
		fm.rent_mng_id.value = m_id;
		fm.rent_l_cd.value = l_cd;
		fm.target ='d_content';
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';
		fm.submit();
	}
	
	
//통화 메모 보기
	function view_memo(m_id, l_cd, c_id, tm_st, accid_id, serv_id, mng_id){
		var auth_rw = document.form1.auth_rw.value;
		window.open("/acar/condition/rent_memo_frame_s.jsp?auth_rw="+auth_rw+"&tm_st="+tm_st+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&serv_id="+serv_id+"&mng_id="+mng_id, "INS_MEMO", "left=100, top=100, width=700, height=600");
	}
	
	//대여료메모
	function view_memo_settle(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
	}		
		
	function req_fee_start_act(m_title, m_content, bus_id)
	{
		window.open("/acar/memo/memo_send_mini.jsp?send_id=<%=ck_acar_id%>&m_title="+m_title+"&m_content="+m_content+"&rece_id="+bus_id, "MEMO_SEND", "left=100, top=100, width=520, height=470");
	}
	
	//자동차등록정보 보기
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}	
	
	//장기계약 임의연장 등록
	function reg_im_cont(m_id, l_cd, car_no){
	//	var fm = document.form1;
	//	var fm2 = document.form2;
		
	//	if(confirm('임의연장 등록으로 넘어가겠습니까?')){

		//	fm2.target ='c_body';
		//	fm2.action = '/fms2/lc_rent/lc_im_renew_h_rm.jsp?s_kd=2&t_wd='+car_no;
		//	fm2.submit();		
		
		//	fm.target ='c_foot';
		//	fm.action = '/fms2/lc_rent/lc_im_renew_c_rm.jsp?rent_mng_id='+m_id+'&rent_l_cd='+l_cd;
		//	fm.submit();
		
		window.open("/fms2/lc_rent/lc_im_renew_c_rm.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&mode=pop", "RENEW", "left=10, top=10, width=1050, height=700, scrollbars=yes");
	//	}
	}		
	
	function view_kakao_contract(m_id, l_cd, car_comp_id) {
        window.open("/acar/kakao/alim_talk_contract.jsp?mng_id="+m_id+"&l_cd="+l_cd+"&car_comp_id="+car_comp_id, "VIEW_KAKAO_CONTRACT", "left=0, top=0, width=800, height=750, scrollbars=yes");
	}
//-->
</script>
</head>
<body>
<form name='form2' method='post' action=''>
</form>
<form name='form1' method='post'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='c_st' value='fee'>  
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name='from_page' value='/fms2/condition/rent_end_cond_rm_frame.jsp'>  

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./rent_end_cond_rm_sc_in.jsp?height=<%=height%>&auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&t_wd=<%=t_wd%>" name="RentEndCondList" width="100%" height="<%=height+15%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>
	
</table>
</form>
</body>
</html>