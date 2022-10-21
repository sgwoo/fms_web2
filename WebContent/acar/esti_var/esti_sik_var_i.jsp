<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSikVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String disabled = "";
	if(!seq.equals("")) disabled = "disabled";
		
	//공통변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstiSikVarBean [] ea_r = e_db.getEstiSikVarList(gubun1, gubun2, gubun3);
	int size = ea_r.length;			
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function save(cmd){
		var fm = document.form1;
		if(fm.a_e.value == ''){ alert('소분류를 선택하십시오.'); return;}
		if(cmd == 'i'){
			fm.h_a_a.value = fm.a_a.value;
			fm.h_a_c.value = fm.a_c.value;
			fm.h_m_st.value = fm.m_st.value;
			fm.h_a_e.value = fm.a_e.value;									
			if(!confirm('등록하시겠습니까?')){	return;	}
		}else{
			if(!confirm('수정하시겠습니까?')){	return;	}		
		}
		fm.cmd.value = cmd;
		fm.target = "i_no";
//		fm.submit();		
	}
	
	//목록보기
	function go_list(){
		location='esti_var_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>';
	}
	
	function Helplist(){
		var SUBWIN = "esti_sik_var_help.jsp";
		window.open(SUBWIN, "HelpList", "left=100, top=100, width=450, height=300, scrollbars=yes");
	}		
				
//-->
</script>
</head>
<body>
<form action="./esti_var_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="a_c" value="">
  <input type="hidden" name="m_st" value="">  
  <input type="hidden" name="code" value="">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">  
</form>
<form name="form1" method="post" action="esti_car_var_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="seq" value="<%=seq%>">
  <input type="hidden" name="h_a_a" value="<%//=a_a%>">
  <input type="hidden" name="h_a_c" value="<%//=bean.getA_c()%>">            
  <input type="hidden" name="h_m_st" value="<%//=bean.getM_st()%>">            
  <input type="hidden" name="h_a_e" value="<%//=bean.getA_e()%>">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 견적변수관리 > <span class=style5>계산식변수</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr> 
        <td align="right"> <a href="javascript:Helplist();"><img src=../images/center/button_help.gif border=0 align=absmiddle></a>&nbsp;
        <a href="javascript:go_list();"><img src=../images/center/button_list.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="5%">연번</td>
                    <td class=title width="10%">변수코드</td>
                    <td class=title width="25%">변수명</td>
                    <td class=title width="50%">변수값</td>
                    <td class=title width="10%">처리</td>
                </tr>
                <tr> 
                    <td align="center">- </td>
                    <td align="center"> 
                    <input type="text" name="var_cd" value="" size="12" class=text>
                    </td>
                    <td align="center"> 
                    <input type="text" name="var_nm" value="" size="37" class=text>
                    </td>
                    <td> 
                    <input type="text" name="var_sik" value="" size="85" class=text>
                    </td>
                    <td align="center"><%if(!auth_rw.equals("1")){%><a href="javascript:save('0','','','');"><img src=../images/center/button_in_reg.gif border=0 align=absmiddle></a><%}%></td>
                </tr>
                  <%for(int i=0; i<size; i++){
        					bean = ea_r[i];%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"> 
                      <input type="text" name="var_cd" value="<%=bean.getVar_cd()%>" size="12" class=whitetext readonly>
                    </td>
                    <td align="center"> 
                      <input type="text" name="var_nm" value="<%=bean.getVar_nm()%>" size="37" class=text>
                    </td>
                    <td> 
                      <input type="text" name="var_sik" value="<%=bean.getVar_sik()%>" size="85" class=text>
                    </td>
                    <td align="center"><%if(!auth_rw.equals("1")){%><a href="javascript:save('<%=i+1%>','<%=bean.getA_a()%>','<%=bean.getSeq()%>');"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a><%}%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>