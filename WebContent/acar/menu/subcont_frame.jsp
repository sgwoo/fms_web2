<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String m_st 	= request.getParameter("m_st")==null?"13":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null?"01":request.getParameter("m_cd");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(nm_db.getWorkAuthUser("외부_탁송업체",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "07";
		m_cd 	= "02";
	}else if(nm_db.getWorkAuthUser("외부_용품업체",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "08";
		m_cd 	= "02";
	}else if(nm_db.getWorkAuthUser("외부_정비업체",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "06";
		m_cd 	= "01";
	}else if(nm_db.getWorkAuthUser("외부_과태료",ck_acar_id)){
		m_st 	= "03";
		m_st2 	= "06";
		m_cd 	= "01";
	}else if(nm_db.getWorkAuthUser("외부_긴급출동",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";
	}else if(nm_db.getWorkAuthUser("외부_콜센타",ck_acar_id)){
		m_st 	= "16";
		m_st2 	= "01";
		m_cd 	= "01";
	}else if(nm_db.getWorkAuthUser("외부_자동차사",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "14";
		m_cd 	= "01";
	}
	
	
	//20120117 협력업체는 무조건 협렵업체-협력업체관리-아마존카차량조회가 기본 페이지가 된다.
	if(!nm_db.getWorkAuthUser("외부_자동차사",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";
	}
	
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<script language=JavaScript>

</script>
</HEAD>
<FRAMESET ROWS="123,*" border=0>
	<FRAME NAME="top_menu"      SRC="subcont_top.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="no" noresize>
	<FRAMESET cols="185, *" border=0>
		<FRAME name="d_menu"    SRC="subcont_menu.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="auto" noresize>  
		<%if(nm_db.getWorkAuthUser("외부_자동차사",ck_acar_id)){%>
		<FRAME name="d_content" SRC="/fms2/pur_com/lc_rent_frame.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>
		<%}else{%>
		<FRAME name="d_content" SRC="/fms2/master_car/amazoncar_list_frame.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>
		<%}%>
	</frameset>	
</FRAMESET>	
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>