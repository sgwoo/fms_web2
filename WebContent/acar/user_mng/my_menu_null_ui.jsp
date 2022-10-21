<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.user_mng.MaMymenuBean" scope="page"/>

<%
	MaMymenuDatabase nm_db = MaMymenuDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String m_st = request.getParameter("m_st")==null?"01":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	String m_nm = request.getParameter("m_nm")==null?"":request.getParameter("m_nm");
	String url = request.getParameter("url")==null?"":request.getParameter("url");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String base = request.getParameter("base")==null?"":request.getParameter("base");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	int sort = request.getParameter("sort")==null?0:Util.parseInt(request.getParameter("sort"));
	int count = 0;
	
	if(user_id.equals("")){
		//로그인ID&영업소ID
		LoginBean login = LoginBean.getInstance();
		user_id = login.getCookieValue(request, "acar_id");
	}
	
	if(cmd.equals("i")){
		
		bean.setSeq(nm_db.getMyNaxtNum(user_id));//seq 생성
		bean.setUser_id(user_id);
		bean.setM_st(m_st);
		bean.setM_st2(m_st2);
		bean.setM_cd(m_cd);
		bean.setSort(sort);
		count = nm_db.insertMyMenu(bean);
		
	}else if(cmd.equals("u")){
		
		String seqs []  = request.getParameterValues("seq");
		String sorts []	= request.getParameterValues("sort");
		int size = request.getParameter("size")==null?1:AddUtil.parseInt(request.getParameter("size"));
		
		for(int i=0; i<size; i++){
			count = nm_db.updateMyMenu(user_id, AddUtil.parseInt(seqs[i]), AddUtil.parseInt(sorts[i]));
		}
		
	}else if(cmd.equals("d")){
		
		String seqs []  = request.getParameterValues("seq");
		String sorts []	= request.getParameterValues("sort");
		int idx = request.getParameter("idx")==null?1:AddUtil.parseInt(request.getParameter("idx"));
		
		count = nm_db.deleteMyMenu(user_id, AddUtil.parseInt(seqs[idx]), AddUtil.parseInt(sorts[idx]));
    }
	
	out.println(count);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body leftmargin="15">
<script>
<%	if(cmd.equals("u")){
		if(count > 0){%>
	alert("정상적으로 수정되었습니다.");
	parent.SMenuSearch();
	parent.parent.d_menu.location.reload();
<%		}
	}else if(cmd.equals("i")){
		if(count > 0){%>
	alert("정상적으로 등록되었습니다.");
	parent.SMenuSearch();
	parent.opener.SMenuSearch();	
	parent.opener.parent.d_menu.location.reload();	
<%		}
	}else if(cmd.equals("d")){
		if(count > 0){%>
	alert("정상적으로 삭제되었습니다.");
	parent.SMenuSearch();
	parent.parent.d_menu.location.reload();
<%		}
	}%>
</script>
</body>
</html>