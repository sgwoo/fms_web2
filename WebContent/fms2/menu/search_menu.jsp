<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd"); 	//검색어
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){		
		var fm = document.form1;
		if(fm.t_wd.value == '')		{ 	alert('검색어를 넣어주세요.'); 	return; }
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	
	function page_link(m_st, m_st2, m_cd, url, auth_rw, isInit ,menu_full_path){	
		
		if(m_cd == '' || m_cd == null) m_cd = '01';
		if(url == '' || url == null) url = '';
		if(auth_rw == '' || auth_rw == null) auth_rw = '';
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id=<%=acar_br%>&user_id=<%=ck_acar_id%>';
		
		opener.parent.d_content.location = url+''+values;		
		var menu_full_path = menu_full_path;
		
		var menuCookie = menu_full_path.split(":")[0] + " > " + menu_full_path.split(":")[1] + " > " + menu_full_path.split(":")[2];
		$.cookie("currentMenuNavi",menuCookie,{expires: 1, path: '/', domain:'.amazoncar.co.kr'});
		self.close();		
	} 	
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<p>
<form name='form1' action='search_menu.jsp' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
   <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> <span class=style5>메뉴명 검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	      <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 메뉴명 :	
	          <input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	          <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
	      <td class=h></td>
    </tr>
    <tr>
	      <td class=line2 colspan=2></td>		
    </tr>
    <tr>
	      <td class="line" colspan=2>
	          <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="5%" class='title'>연번</td>
                    <td width="45%" class='title'>경로</td>
                    <td width="50%" class='title'>메뉴명</td>                    
                </tr>
                <%if(!t_wd.equals("")){
                		Vector menu_vt = nm_db.getXmlMenuSearchList(ck_acar_id, t_wd);
                		int menu_size = menu_vt.size();
                		
                		for(int i=0; i<menu_size; i++){
	    								Hashtable menu = (Hashtable)menu_vt.elementAt(i);
                %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td>&nbsp;<%=menu.get("M_NM1")%> - <%=menu.get("M_NM2")%></td>
                    <td>&nbsp;<a href="javascript:page_link('<%=menu.get("M_ST")%>','<%=menu.get("M_ST2")%>','<%=menu.get("M_CD")%>','<%=menu.get("URL")%>','<%=menu.get("AUTH_RW")%>', true, '<%=menu.get("M_NM1")%>:<%=menu.get("M_NM2")%>:<%=menu.get("M_NM3")%>')"><%=menu.get("M_NM")%></a></td>
                </tr>  
                <%	}%>              	
                <%}else{%>
                <tr>
                	  <td colspan='3' align="center">검색어가 없습니다.</td>
                </tr>	
                <%}%>
            </table>
        </td>
    </tr>
	  <tr>
	      <td colspan=2></td>
	  </tr>	
</table>
</form>
</body>
</html>