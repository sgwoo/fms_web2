<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.accid.*"%>
<jsp:useBean id="rl_bean" class="acar.accid.AccidentBean" scope="page"/>
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
	String mode = request.getParameter("mode")==null?"12":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//사고리스트
	AccidentBean rl_r [] = as_db.getCarAccidList(c_id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;				
		fm.cmd.value = "u";		
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form name='form1' action='accid_u_frame.jsp' method='post' target='d_content'>
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
    <input type='hidden' name='accid_st' value=''>	
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고 리스트</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title rowspan="2" width="4%">NO</td>
                    <td class=title rowspan="2" width="13%">사고일시</td>
                    <td class=title width="13%">사고유형</td>
                    <td class=title width="15%">사고장소</td>
                    <td class=title width="55%">사고내용</td>
                </tr>
                <tr> 
                    <td class=title>계약번호</td>
                    <td class=title>상호</td>
                    <td class=title>기타</td>
                </tr>
              <%	for(int i=0; i<rl_r.length; i++){
            	rl_bean = rl_r[i];%>
                <tr valign="top"> 
                    <td align="center" rowspan="2" valign="middle"><%=i+1%></td>
                    <td align="center" rowspan="2" valign="middle"><a href="javascript:AccidentDisp('<%= rl_bean.getRent_mng_id() %>', '<%= rl_bean.getRent_l_cd() %>', '<%= rl_bean.getCar_mng_id() %>', '<%= rl_bean.getAccid_id() %>', '<%= rl_bean.getAccid_st() %>')" onMouseOver="window.status=''; return true"><%=AddUtil.ChangeDate3(rl_bean.getAccid_dt())%></a></td>
                    <td align="center" valign="middle"><%=rl_bean.getAccid_st_nm()%></td>
                    <td>
                        <table border=0 cellspacing=0 cellpadding=3 width=100%>
                            <tr>                             
                                <td align="center" valign="middle"><%=rl_bean.getAccid_addr()%></td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table border=0 cellspacing=0 cellpadding=3 width=100%>
                            <tr>    
                                <td>
                                    <%=Util.htmlBR(rl_bean.getAccid_cont())%> 
                                      <%if(!rl_bean.getAccid_cont2().equals("")){%>
                                      <br>
                                      <%}%>
                                      <%=Util.htmlBR(rl_bean.getAccid_cont2())%> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr valign="top"> 
                    <td align="center" valign="middle"><%= rl_bean.getRent_l_cd() %></td>
                    <td align="center" valign="middle"><%=rl_bean.getFirm_nm()%></td>
                    <td> <font color="#CCCC00"> <font color="#9900CC">
                      <%if(rl_bean.getSub_rent_gu().equals("1")){%>
                      단기대여 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("2")){%>
                      정비대차 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("3")){%>
                      사고대차 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("9")){%>
                      보험대차 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("10")){%>
                      지연대차 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("4")){%>
                      업무대여 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("5")){%>
                      업무지원 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("6")){%>
                      차량정비 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("7")){%>
                      차량점검 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("8")){%>
                      사고수리 
                      <%}%>
                      <%if(rl_bean.getSub_rent_gu().equals("12")){%>
                      월렌트
                      <%}%>
                      </font> </font><%=rl_bean.getSub_firm_nm()%> </td>
                </tr>
              <%	}%>
              <% 	if(rl_r.length == 0) { %>
                <tr> 
                    <td colspan=5 align=center>등록된 데이타가 없습니다.</td>
                </tr>
              <%	}%>
            </table>
            
        </td>
    </tr>
  </form>
</table>
</body>
</html>
