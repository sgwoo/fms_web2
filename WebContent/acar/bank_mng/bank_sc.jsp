<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table.css'>
<script language="JavaScript">
<!--
	//은행대출 등록
	function reg_bank_lend(){
		var fm = document.form1;	
		fm.lend_id.value = '';
		fm.action ='bank_reg_frame.jsp';
		fm.target='d_content';		
		fm.submit();
//		parent.location='bank_reg_frame.jsp?sh_height='+document.form1.sh_height.value+'&auth_rw='+document.form1.auth_rw.value+'&user_id='+document.form1.user_id.value+'&br_id='+document.form1.br_id.value+'&bank_id='+document.form1.bank_id.value+'&lend_id=';
	}
	
	//은행대출 수정
	function view_bank_lend(lend_id){
		var fm = document.form1;	
		fm.lend_id.value = lend_id;
		fm.action ='bank_reg_frame.jsp';
		fm.target='d_content';		
		fm.submit();	
//		parent.location='bank_reg_frame.jsp?sh_height='+document.form1.sh_height.value+'&auth_rw='+document.form1.auth_rw.value+'&user_id='+document.form1.user_id.value+'&br_id='+document.form1.br_id.value+'&bank_id='+document.form1.bank_id.value+'&lend_id='+lend_id;
	}
	
	//스케줄 가기
	function scd_view(idx, lend_id, cont_term){
		fm = inner.document.form1;
		var scd_yn = fm.scd_yn[idx].value;
		var rtn_seq = fm.s_rtn[idx].value;	
		
		var fm2 = document.form1;	
		fm2.lend_id.value 	= lend_id;
		fm2.rtn_seq.value 	= rtn_seq;
		fm2.cont_term.value = cont_term;		
		fm2.target='d_content';		
						
		if(scd_yn == null || scd_yn == ''){
			fm2.action ='bank_scd_i.jsp';
//			parent.location='bank_scd_i.jsp?sh_height='+document.form1.sh_height.value+'&auth_rw='+document.form1.auth_rw.value+'&lend_id='+lend_id+'&rtn_seq='+rtn_seq+'&cont_term='+cont_term;		
		}else{//등록
			fm2.action ='bank_scd_u.jsp';
//			parent.location='bank_scd_u.jsp?sh_height='+document.form1.sh_height.value+'&auth_rw='+document.form1.auth_rw.value+'&lend_id='+lend_id+'&rtn_seq='+rtn_seq+'&cont_term='+cont_term;
		}
		
		fm2.submit();	
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='lend_id' value=''>
<input type='hidden' name='rtn_seq' value=''>
<input type='hidden' name='cont_term' value=''>
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr> 
    <td> <iframe src="bank_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&bank_id=<%=bank_id%>&gubun1=<%=gubun1%>&gubun=<%=gubun%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
      </iframe> </td>
  </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>