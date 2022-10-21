<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//할부이자율 반올림현상 수정
//	e_db.updateEstiJgVarJ123();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.target = "c_foot";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="./esti_var_sc.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 차종관리 > <span class=style5>견적변수관리</span></span></td>
                    <td class=bar align=right>
                    <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("차종관리",user_id)){%>
		            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		            <a href ="/acar/estimate_mng/excel.jsp" target="_blank" title='esti_jg_var 변수 엑셀 등록'><img src=/acar/images/center/button_igcr.gif  border=0></a>
					<%}%>&nbsp;</td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
	<tr>
        <td>			
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>					
                    <td width="150">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_dygb.gif align=absmiddle>&nbsp;
                        <select name="gubun1">
                            <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>리스</option>
                            <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>렌트</option>
                        </select>
                    </td>
                    <td width="160"><img src=../images/center/arrow_bsgb.gif align=absmiddle>&nbsp;
                        <select name="gubun2">
                            <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>공통변수</option>
                            <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>차종별변수</option>
                            <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>계산식변수</option>
                            <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>차종별잔가</option>
                        </select>
                    </td>								
                    <td width="200"><img src=../images/center/arrow_gjgji.gif align=absmiddle>
                        <select name="gubun3">
                        <option value="" <%if(gubun1.equals(""))%>selected<%%>>선택</option>			  
        			  <%//변수기준일
        			  	Vector vt = e_db.getEstiBaseDtList();
        				int vt_size = vt.size();        				
        				for(int i = 0 ; i < vt_size ; i++){
        					Hashtable ht = (Hashtable)vt.elementAt(i);%>		
        				<option value="<%=ht.get("B_DT")%>" <%if(gubun3.equals(String.valueOf(ht.get("B_DT"))))%>selected<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("B_DT")))%>(<%=ht.get("ST")%>)</option>
        			  <%}%>				
                      </select>
                    </td>					
                    <td><a href="javascript:Search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
				</tr>
			</table>
		</td>
	</tr>
</form>
</table>
</body>
</html>