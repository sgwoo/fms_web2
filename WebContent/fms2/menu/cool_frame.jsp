<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<script type="text/javascript" src="/include/modalLoading.js" ></script>

<%
	String m_st 	= request.getParameter("m_st")==null?"13":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null?"01":request.getParameter("m_cd");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String url 	= request.getParameter("url")==null?"":request.getParameter("url");
	String m_url 	= request.getParameter("m_url")==null?"":request.getParameter("m_url");
	String menuNm = "";
	String s_width2 = request.getParameter("s_width2")==null?"":request.getParameter("s_width2");
	String s_height2= request.getParameter("s_height2")==null?"":request.getParameter("s_height2");
	
	LoginBean login 	= LoginBean.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
//	System.out.println("=============[쿨메신저프레임]=============");
//	System.out.println("ck_acar_id=" + ck_acar_id + "&url="+  url );
//	System.out.println("=============[쿨메신저프레임]=============");
		
	//사용자정보
	UsersBean user_bean = umd.getUsersBean(ck_acar_id);
	
	
	if(nm_db.getWorkAuthUser("외부_탁송업체",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "07";
		m_cd 	= "02";
		//20120117 협력업체는 무조건 협렵업체-협력업체관리-아마존카차량조회가 기본 페이지가 된다.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("외부_용품업체",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "08";
		m_cd 	= "02";
		//20120117 협력업체는 무조건 협렵업체-협력업체관리-아마존카차량조회가 기본 페이지가 된다.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("외부_정비업체",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "06";
		m_cd 	= "01";
		//20120117 협력업체는 무조건 협렵업체-협력업체관리-아마존카차량조회가 기본 페이지가 된다.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("외부_과태료",ck_acar_id)){
		m_st 	= "03";
		m_st2 	= "06";
		m_cd 	= "01";
		//20120117 협력업체는 무조건 협렵업체-협력업체관리-아마존카차량조회가 기본 페이지가 된다.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("외부_긴급출동",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";
		//20120117 협력업체는 무조건 협렵업체-협력업체관리-아마존카차량조회가 기본 페이지가 된다.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("외부_콜센타",ck_acar_id)){
		m_st 	= "16";
		m_st2 	= "01";
		m_cd 	= "01";
		//20120117 협력업체는 무조건 협렵업체-협력업체관리-아마존카차량조회가 기본 페이지가 된다.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}
		
	
	if(s_width.equals("") && !s_width2.equals("")){
		login.setDisplayCookie(s_width2, s_height2, response);//디스플레이 사이즈 쿠키설정
	}
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, url);
	
	if(m_st.equals("") && !url.equals("")){
		int len = url.indexOf("?");
		String s_url = url;
		if(len != -1){
			s_url = url.substring(0,len);
		}
		MaMenuBean bean = nm_db.getMenuCase(s_url);
		m_st 	= bean.getM_st();
		m_st2 	= bean.getM_st2();
		m_cd 	= bean.getM_cd();
	}
	
//	System.out.println("url=" + url + "|m_url=" + m_url);
	
	if(m_url.equals("")){
	   
		menuNm = nm_db.getMenuCaseNm(url);
	}else{
		menuNm = nm_db.getMenuCaseNm(m_url);
	}
	
	
	url = AddUtil.replace(url, "|", "&");
	
//	if(url.equals("")) url = "amazoncar_main.jsp";
	if(url.equals("")) url = "emp_content.jsp";
	

 //  		System.out.println("url=" + url + "|m_url=" + m_url);
//   		System.out.println("menuNm=" + menuNm );
 //  		System.out.println("dept_id=" + user_bean.getDept_id() + "&url="+  url );
//	System.out.println("=============[쿨메신저프레임]=============");

      
//	System.out.println("dept_id=" + user_bean.getDept_id() + "&url="+  url );
//	System.out.println("=============[쿨메신저프레임]=============");
	
%>
<!DOCTYPE html>
<HTML>
<HEAD>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta name="viewport" content="width=1245, height=1000, user-scalable=yes, initial-scale=1">
<TITLE>FMS</TITLE>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>

<script language=JavaScript>
$( document ).ready(function() {
		var menuCookie =  "<%=menuNm%>";
    $.cookie("currentMenuNavi",menuCookie,{expires: 1, path: '/', domain:'.amazoncar.co.kr'});

});

</script>
</HEAD>

<%if(user_bean.getDept_id().equals("8888")){//외부업체%>
<FRAMESET ROWS="123,*" border=0>
	<FRAME NAME="top_menu"      SRC="/acar/menu/subcont_top.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="no" noresize>
	<FRAMESET cols="185, *" border=0>
		<FRAME name="d_menu"    SRC="/acar/menu/subcont_menu.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="auto" noresize>  
		<%if(url.equals("amazoncar_main.jsp")){%>		
		<FRAME name="d_content" onload="hideBlindLayer();"  SRC="/fms2/master_car/amazoncar_list_frame.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>
		<%}else{%>
		<FRAME name="d_content" onload="hideBlindLayer();"  SRC="<%=url%>" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>
		<%}%>
</FRAMESET>	
</FRAMESET>	
	
<%}else{//아마존카직원%>	

<FRAMESET ROWS="90,0,*" border=0>
	<FRAME NAME="top_menu"  SRC="/fms2/menu/emp_top.jsp" frameborder=0 marginwidth=0 marginheight=0 scrolling="no" noresize>
	<FRAME NAME="sub_menu"  SRC="/fms2/menu/emp_submenu.jsp" frameborder=0 marginwidth=0 marginheight=0 scrolling="auto" noresize>
	<FRAME name="d_content" SRC="<%=url%>" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>		 	
</FRAMESET>	
<NOFRAMES>
	
<%}%>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>