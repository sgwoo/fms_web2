<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	String gubun = "1";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String br_id = "";
	String fn_id = "0";
	String dt = "1";
	if(request.getParameter("br_id") != null)	br_id = request.getParameter("br_id");
	if(request.getParameter("fn_id") != null ) 	fn_id = request.getParameter("fn_id") + request.getParameter("find_u");
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
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
	
<% 
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
		theForm.action = "./register_frame.jsp";
<%
	}else{
%>
		if(reg_gubun=="id")
		{
			alert("미등록 상태입니다.");
			return;
		}
		theForm.action = "./register_frame.jsp";
<%
	}
%>
	theForm.target = "d_content"
	theForm.submit();
}

	//희망번호 등록
	function reg_DlvEstDt(m_id, l_cd){
		window.open("reg_dlvestdt.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=board", "REG_DLVESTDT", "left=100, top=100, width=620, height=400, resizable=yes, scrollbars=yes, status=yes");					
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr> 
    <td><iframe src="./reg_m_cond_sc_in.jsp?height=<%=height%>&auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&fn_id=<%=fn_id%>&br_id=<%=br_id%>" name="RegCondList" width="100%" height="<%=height+10%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>
  <tr>
    <td><img src="../../images/blank.gif" height="2"></td>
  </tr>
 
</table>
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
</form>
</body>
</html>