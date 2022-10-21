<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "04", "04");
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String cng_rsn = request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
//	out.println ("height="+ height + "sh_height" + sh_height + "cnt" + cnt );
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function DispatchSearch()
{
	var theForm = document.DispatchSearchFrom;
	theForm.submit();
}
function ContractContent(id)
{
	var theForm = document.ContractContentFrom;
	theForm.h_cont_id.value = id;
	theForm.submit();
}
function CompanyAdd()
{
	
	var SUBWIN="./car_company_i.html";	
	window.open(SUBWIN, "CompanyList", "left=100, top=100, width=300, height=300, scrollbars=yes");
}
function OfficeAdd()
{
	
	var SUBWIN="./car_office_i.html";	
	window.open(SUBWIN, "OfficeList", "left=100, top=100, width=350, height=330, scrollbars=yes");
}
function OpenMemo(emp_id)
{
	var theForm = document.CarOffEmpUpdateForm;
	var auth_rw = theForm.auth_rw.value;
	var SUBWIN="./office_memo_i.jsp?emp_id="+emp_id + "&auth_rw=" +auth_rw;	
	window.open(SUBWIN, "Memo", "left=100, top=100, width=570, height=320, scrollbars=no");
}

function UpdateList(arg)
{
	
	var theForm = document.CarOffEmpUpdateForm;
	theForm.emp_id.value = arg;
	theForm.target="d_content";
	theForm.submit();
}


//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gu_nm" value="<%=gu_nm%>">
<input type="hidden" name="cng_rsn" value="<%=cng_rsn%>">
<input type="hidden" name="sort_gubun" value="<%=sort_gubun%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td> <iframe src="./car_office_p_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&gu_nm=<%=gu_nm%>&sort_gubun=<%= sort_gubun %>&sort=<%= sort %>&cng_rsn=<%=cng_rsn%>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>" name="CarOffPList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
                    </td>
                </tr>
</table>
</form>
</body>
</html>