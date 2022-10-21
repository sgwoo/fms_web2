<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, cust.board.*, cust.member.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="b_db" scope="page" class="cust.board.BoardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	
	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd = request.getParameter("s_dd")==null?"":request.getParameter("s_dd");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String cmd = request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	String bbs_st = request.getParameter("bbs_st")==null?"":request.getParameter("bbs_st");
	String bbs_id = request.getParameter("bbs_id")==null?"":request.getParameter("bbs_id");
	int ref = request.getParameter("ref")==null?0:AddUtil.parseInt(request.getParameter("ref"));
	int re_level = request.getParameter("re_level")==null?0:AddUtil.parseInt(request.getParameter("re_level"));
	int re_step = request.getParameter("re_step")==null?1:AddUtil.parseInt(request.getParameter("re_step"));
	
	String email = request.getParameter("email")==null?"":request.getParameter("email");
	String title = request.getParameter("title")==null?"":request.getParameter("title");
	String content = request.getParameter("content")==null?"":request.getParameter("content");
	int count = 0;
	int h_bbs_id = 0;
	
	BoardBean bean = new BoardBean();
	
	if(bbs_id.equals("") && cmd.equals("i")){//등록
		
		bean.setBbs_st(gubun);
//		bean.setBbs_id();
		if(gubun.equals("1")){
			bean.setTarget("A");
		}else{
			bean.setTarget(member_id);
		}
		bean.setReg_id(member_id);
		bean.setEmail(email);
		bean.setTitle(title);
		bean.setContent(content);
		bean.setHit(0);
//		bean.setRef();
		bean.setRe_level(0);
		bean.setRe_step(1);
		h_bbs_id = b_db.insertBoard(bean);
		bbs_id = Integer.toString(h_bbs_id);
		
	}else if(!bbs_id.equals("") && cmd.equals("u")){//수정
		bean = b_db.getBoardCase(bbs_st, bbs_id);
		bean.setEmail(email);
		bean.setTitle(title);
		bean.setContent(content);
		count = b_db.updateBoard(bean);
		
	}else if(!bbs_id.equals("") && cmd.equals("r")){//답글
		BoardBean o_bean = b_db.getBoardCase(bbs_st, bbs_id);
		
		//순서 뒤로 하나씩 밀기
		count = b_db.changeSeq(ref, re_step);
		
		bean.setBbs_st(o_bean.getBbs_st());
//		bean.setBbs_id(o_bean.getBbs_id());
		bean.setTarget(o_bean.getTarget());
		bean.setReg_id(member_id);
		bean.setEmail(email);
		bean.setTitle(title);
		bean.setContent(content);
		bean.setHit(0);
		bean.setRef(ref);
		bean.setRe_level(re_level+1);
		bean.setRe_step(re_step+1);
		
		h_bbs_id = b_db.insertBoard(bean);
		bbs_id = Integer.toString(h_bbs_id);
	}
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' method='post' action='board_c.jsp' target='d_content'>
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="gubun" value="<%=gubun%>">
<input type='hidden' name="s_yy" value="<%=s_yy%>">
<input type='hidden' name="s_mm" value="<%=s_mm%>">
<input type='hidden' name="s_dd" value="<%=s_dd%>">
<input type='hidden' name="s_kd" value="<%=s_kd%>">
<input type='hidden' name="t_wd" value="<%=t_wd%>">
<input type='hidden' name="idx" value="<%=idx%>">
<input type='hidden' name="bbs_st" value="<%=bean.getBbs_st()%>">
<input type='hidden' name="bbs_id" value="<%=bbs_id%>">
<input type='hidden' name="cmd" value="c">
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(cmd.equals("i")){
		if(!bbs_id.equals("")){%>			
			alert("등록 되었습니다.");
			fm.submit();
<%		}else{%>
			alert("등록 오류!!");
<%		}
	}else if(cmd.equals("u")){
		if(count == 1){%>			
			alert("수정 되었습니다.");
			fm.submit();
<%		}else{%>
			alert("수정 오류!!");
<%		}
	}else if(cmd.equals("r")){
		if(h_bbs_id > 0){%>			
			alert("답변 등록 되었습니다.");
			fm.submit();
<%		}else{%>
			alert("답변 등록 오류!!");
<%		}
	}%>	

//-->
</script>
</body>
</html>
