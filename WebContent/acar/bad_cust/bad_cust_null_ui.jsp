<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bad_cust.*"%>
<jsp:useBean id="bean" class="acar.bad_cust.BadCustBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int chk = 0;
	int count = 0;
	
	BadCustDatabase bcd = BadCustDatabase.getInstance();
	
	if(cmd.equals("i") || cmd.equals("u")){
		bean.setSeq(request.getParameter("seq")==null?"":request.getParameter("seq"));
		bean.setBc_nm(request.getParameter("bc_nm")==null?"":request.getParameter("bc_nm"));
		bean.setBc_ent_no(request.getParameter("bc_ent_no")==null?"":request.getParameter("bc_ent_no"));
		bean.setBc_lic_no(request.getParameter("bc_lic_no")==null?"":request.getParameter("bc_lic_no"));
		bean.setBc_addr(request.getParameter("bc_addr")==null?"":request.getParameter("bc_addr"));
		bean.setBc_firm_nm(request.getParameter("bc_firm_nm")==null?"":request.getParameter("bc_firm_nm"));
		bean.setBc_cont(request.getParameter("bc_cont")==null?"":request.getParameter("bc_cont"));
		bean.setBc_m_tel(request.getParameter("bc_m_tel")==null?"":request.getParameter("bc_m_tel"));
		bean.setBc_email(request.getParameter("bc_email")==null?"":request.getParameter("bc_email"));
		bean.setBc_fax(request.getParameter("bc_fax")==null?"":request.getParameter("bc_fax"));
		bean.setReg_id(user_id);
		if(cmd.equals("i")){
			//주민(법인)등록번호 중복체크
			chk = bcd.checkEntNo(bean.getBc_ent_no(), bean.getBc_nm());
			if(chk == 0){ //중복된 고객이 없으면 등록
				count = bcd.insertBadCust(bean);
			}
		}else if(cmd.equals("u")){
			count = bcd.updateBadCust(bean);
		}
	}else if(cmd.equals("d")){ //삭제
		String vid[] = request.getParameterValues("chk_idnum");
		String vid_num="";
		String where="";
		for(int i=0;i < vid.length;i++){
			vid_num=vid[i];
			if(i == (vid.length -1))	where = where+ "'"+vid_num+"'";
			else						where = where + "'"+vid_num+"'" + ",";
		}
		where = "("+where+")";
		//count = bcd.deleteBadCust(where);
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="bad_cust_frame.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
</form>
<script>
<%	if(chk == 0){
		if(cmd.equals("u")){
			if(count==1){%>
		alert("정상적으로 수정되었습니다.");
<%			}
		}else if(cmd.equals("i")){
			if(count==1){%>
		alert("정상적으로 등록되었습니다.");
<%			}
		}else if(cmd.equals("d")){
			if(count==1){%>
		alert("정상적으로 삭제되었습니다.");
<%			}
		}%>
	var fm = document.form1;
	fm.target = "d_content";
	fm.submit();	
	parent.window.close();
<%	}else{%>	
		alert("이미 등록된 생년월일입니다.\n\n확인하십시오.");
<%	}%>
</script>
</body>
</html>