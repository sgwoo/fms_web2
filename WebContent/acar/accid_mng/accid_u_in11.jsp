<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.con_ins_m.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"11":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	Vector memos = as_db.getInsMemo(m_id, l_cd, c_id, "6", accid_id, "");
	int memo_size = memos.size();
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(cmd){
		var fm = document.form1;	
		fm.cmd.value = cmd;
		if(fm.accid_id.value == ''){ alert("상단을 먼저 등록하십시오."); return; }		
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		fm.target = "i_no";
		fm.action = "accid_u_a.jsp";	
		fm.submit();
	}
	
	function reg(){	
		window.open("about:blank", "INS_MEMO", "left=100, top=100, width=820, height=475, scrollbars=yes");		
		var fm = document.form1;	
		fm.target = "INS_MEMO"
		fm.action = "accid_memo_i.jsp"
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="accid_u_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>통화 리스트</span></td>
        <td align="right"> 
        <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:reg()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a> 
        <%	}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="4%">NO</td>
                    <td class=title width="11%">통화일자</td>
                    <td class=title width="8%">담당자</td>
                    <td class=title width="10%">통화자</td>
                    <td class=title width="60%">통화내용</td>
                    <td class=title width="7%">처리</td>
                </tr>
              <%	if(memo_size > 0){
    		for(int i = 0 ; i < memo_size ; i++){
    			InsMemoBean memo = (InsMemoBean)memos.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align='center'><%=c_db.getNameById(memo.getReg_id(), "USER")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(memo.getReg_dt())%></td>
                    <td align='center'><%=memo.getSpeaker()%></td>
                    <td><%=Util.htmlBR(memo.getContent())%></td>
                    <td align="center"></td>
                </tr>
              <%		}
    	}else{%>
                <tr> 
                    <td colspan='6' align='center'>등록된 데이타가 없습니다 </td>
                </tr>
              <%	}%>
            </table>
        </td>
        </tr>
  </form>
</table>
<table border="0" cellspacing="1" cellpadding="0" width=570>
</table>
</body>
</html>
