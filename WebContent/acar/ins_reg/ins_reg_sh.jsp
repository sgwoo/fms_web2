<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.accid.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");//사고구분
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");//등록구분
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");//등록사유
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	if(!c_id.equals("")){
		AccidDatabase as_db = AccidDatabase.getInstance();	
		//계약조회
		Hashtable cont = as_db.getRentCase(m_id, l_cd);
		s_kd = "2";
		t_wd = String.valueOf(cont.get("CAR_NO"));
	}
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		window.open("about:blank", "SEARCH", "left=100, top=100, width=1020, height=600, scrollbars=yes");
		var fm = document.form1;
		fm.action = "search.jsp";		
		fm.target = "SEARCH";
		fm.submit();		
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//하단 디스플레이
	function cng_display(){
		var fm = document.form1;		
		var fm2 = parent.c_foot.document.form1;		
		if(fm.t_wd.value == ''){ fm.t_wd.focus(); return; }
		if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '1'){
			parent.c_foot.tr1.style.display = '';
			parent.c_foot.tr2.style.display = '';			
		}else if(fm.s_gubun1.options[fm.s_gubun1.selectedIndex].value == '2'){
			parent.c_foot.tr1.style.display = 'none';
			parent.c_foot.tr2.style.display = 'none';	
			fm2.age_scp[2].selected = true;//모든운전자	
		}
	}	
	//등록사유 디스플레이
	function change_type()
	{
		var fm = document.form1;
		drop_type();
		if(fm.s_gubun2.value == '1'){
			fm.s_gubun3.options[0] = new Option('신차', '1');
			fm.s_gubun3.options[1] = new Option('용도변경', '2');
		}else if(fm.s_gubun2.value == '2'){
			fm.s_gubun3.options[0] = new Option('만기', '4');
			fm.s_gubun3.options[1] = new Option('담보변경', '3');
		}
	}	
	function drop_type()
	{
		var fm = document.form1;
		var len = fm.s_gubun3.length;
		for(var i = 0 ; i < len ; i++){
			fm.s_gubun3.options[len-(i+1)] = null;
		}
	}		

	//변수수정		
	function OpenInsAmtVar(){
		var fm = document.form1;		
		var SUBWIN = "var_insamt.jsp?auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&br_id="+fm.br_id.value;
		window.open(SUBWIN, "Help", "left=100, top=100, width=650, height=370, scrollbars=yes");
	}	
	
//-->
</script>
</head>

<body onLoad="javascript:document.form1.t_wd.focus()">
<form name='form1' method='post'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="s_gubun1" value='<%=s_gubun1%>'>
<input type='hidden' name="s_gubun2" value='<%=s_gubun2%>'>
<input type='hidden' name="s_gubun3" value='<%=s_gubun3%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험 > 보험관리 > <span class=style5>보험가입등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
              <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>계약번호</option>		  
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
              <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>차대번호</option>		  
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()">&nbsp;
            <a href='javascript:search()'><img src=../images/center/button_search.gif align=absmiddle border=0></a> 
    		<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%>
    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    		<a href="/acar/ins_excel/excel.jsp" target="_blank"><img src=../images/center/button_ignb.gif align=absmiddle border=0></a>   		
    		<!--
    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    		
    		<a href="https://fms3.amazoncar.co.kr/acar/ins_excel/excel.jsp" target="_blank">[업무용일괄갱신]</a>
    		-->
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:OpenInsAmtVar()" title='변수수정'><img src=../images/center/button_modify_bs.gif align=absmiddle border=0></a>
    		<%}%>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>