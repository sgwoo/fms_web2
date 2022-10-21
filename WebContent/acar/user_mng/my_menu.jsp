<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="bme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="mme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="sme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String m_st = request.getParameter("m_st")==null?"01":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	String m_nm = request.getParameter("m_nm")==null?"":request.getParameter("m_nm");
	String url = request.getParameter("url")==null?"":request.getParameter("url");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String base = request.getParameter("base")==null?"":request.getParameter("base");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	int count = 0;
	
	MaMymenuDatabase nm_db = MaMymenuDatabase.getInstance();
	
	//마이메뉴 리스트
	Vector menus1 = nm_db.getMyMenuList(user_id);
	int menu_size1 = menus1.size();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function SMenuUp(){
		var theForm = document.SMenuForm;
		
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "u";
		theForm.target="i_no";
		theForm.submit();
	}
	function SMenuDel(idx){
		var theForm = document.SMenuForm;
		SMenuForm.idx.value = idx;
		if(!confirm('삭제하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "d";
		theForm.target="i_no";
		theForm.submit();
	}
	function SMenuSearch(){
		var theForm = document.SMenuSearchForm;
		var theForm1 = document.SMenuForm;
		theForm.submit();
	}
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./my_menu_null_ui.jsp" name="SMenuForm" method="POST" >
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="size" value="<%=menu_size1%>">
<input type="hidden" name="idx" value="">
<input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>마이메뉴관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td align=right>
		<%//if(menu_size1<10){%><a href="javascript:MM_openBrWindow('my_menu_i.jsp?cmd=i','popwin','scrollbars=yes,status=no,resizable=no,width=800,height=130,left=300,top=300')"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></a>&nbsp;&nbsp;<%//}%>
		<%//if(menu_size1>0){%><a href="javascript:SMenuUp()"><img src="/acar/images/center/button_modify_sw.gif"  border="0" align=absmiddle></a><%//}%>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class=line>
        <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class=title width="4%">연번</td>
            <td class=title width="10%">대메뉴</td>
            <td class=title width="10%">중메뉴</td>
            <td class=title width="20%">메뉴명</td>
            <td class=title>URL</td>
            <td class=title width="15%">비고</td>
            <td class=title width="7%">순위</td>
            <td class=title width="7%">삭제</td>			
          </tr>
          <%	for (int i = 0 ; i < menu_size1 ; i++){
		Hashtable menu1 = (Hashtable)menus1.elementAt(i);%>
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><%=menu1.get("BM_NM")%></td>
            <td align="center"><%=menu1.get("MM_NM")%></td>
            <td align="center"><%=menu1.get("M_NM")%></td>
            <td>&nbsp;<%=menu1.get("URL")%></td>
            <td>&nbsp;<%=menu1.get("NOTE")%></td>
            <td align="center"><input type='text' name="sort" value="<%=menu1.get("SORT")%>" size="2" class=num><input type="hidden" name="seq" value="<%=menu1.get("SEQ")%>"></td>
            <td align="center"><a href="javascript:SMenuDel('<%=i%>')"><img src="/acar/images/center/button_in_delete.gif"  border="0" align=absmiddle></a></td>
          </tr>
          <%	}%>
        </table>
      </td>
	</tr>
	<tr>
    	<td >* 최대 10개만 등록 권유 (10개이상이면 메뉴부분에 스크롤바가 생길수 있음)</td>
    </tr>
</table>
</form>
<form action="./my_menu.jsp" name="SMenuSearchForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>