<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String page_nm = request.getParameter("page_nm")==null?"":request.getParameter("page_nm");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	CusReg_Database cr_db = CusReg_Database.getInstance();	
	Cycle_vstBean cvBn = cr_db.getCycle_vst(client_id, seq);
	
	CommonDataBase c_db = CommonDataBase.getInstance();

	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
%>

<html>
<head>
<title>:: 업무추진실적현황 ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//검색하기
function vst_reg(){
	var fm = document.form1;	
	fm.target = 'i_no';
<% if(seq.equals("")){ %>
	fm.action = 'vst_reg_ins.jsp';
<% }else{ %>
	fm.action = 'vst_reg_iu.jsp?page_nm=<%= page_nm %>&user_id=<%= user_id %>';
<% } %>
	fm.submit();	
}
-->
</script>
</head>

<body>
<form name='form1' method='post' action=''>
<input type='hidden' name='client_id' value='<%= client_id %>'>
<input type='hidden' name='seq' value='<%= seq %>'>
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 >  <span class=style5>거래처방문 등록 및 수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class=line colspan="2"> 
                        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr> 
                                <td width=18% class='title'>방문예정일자</td>
                                <td width=23%>&nbsp; <input name="vst_est_dt" type="text" class="text" value="<%= AddUtil.ChangeDate2(cvBn.getVst_est_dt())  %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                                <td class='title' width=18%>방문예정내용</td>
                                <td width=41%>&nbsp; <input type="text" name="vst_est_cont" class='text' size="50" value="<%= cvBn.getVst_est_cont() %>" style='IME-MODE: active'></td>
                            </tr>
                            <tr> 
                                <td class='title'>방문일자</td>
                                <td colspan="3">&nbsp; <input name="vst_dt" type="text" class="text" value="<%= AddUtil.ChangeDate2(cvBn.getVst_dt())  %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                            </tr>
                            <tr> 
                                <td class='title'>방문담당자</td>
                                <td colspan="3">&nbsp; 
                                <select name='visiter'>
                              
                                <%if(user_size > 0){
            							for(int i = 0 ; i < user_size ; i++){
            								Hashtable user = (Hashtable)users.elementAt(i); 
            						%>
            		          				  <option value='<%=user.get("USER_ID")%>' <% if(cvBn.getVisiter().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
            		                <%	}
            						}		%>
            					</select></td>
            				                 
                            </tr>
                            <tr> 
                                <td class='title'>방문목적</td>
                                <td colspan="3">&nbsp; 
                                    <select name="vst_pur">
                                      <option value=""  <% if(cvBn.getVst_pur().equals("")){  %>selected<% } %>>==선택==</option>
                                      <option value="1" <% if(cvBn.getVst_pur().equals("1")){ %>selected<% } %>>순회방문</option>
                                      <option value="2" <% if(cvBn.getVst_pur().equals("2")){ %>selected<% } %>>자동차점검</option>
                                      <option value="3" <% if(cvBn.getVst_pur().equals("3")){ %>selected<% } %>>계약상담</option>
                                      <option value="4" <% if(cvBn.getVst_pur().equals("4")){ %>selected<% } %>>연체</option>
                                      <option value="5" <% if(cvBn.getVst_pur().equals("5")){ %>selected<% } %>>계약조건변경</option>
                                      <option value="6" <% if(cvBn.getVst_pur().equals("6")){ %>selected<% } %>>기타</option>
                                    </select> <input type="text" name="vst_title" class='text' size="50" value="<%= cvBn.getVst_title() %>" style='IME-MODE: active'> 
                                </td>
                            </tr>
                            <tr> 
                                <td class='title'>상담자</td>
                                <td colspan="3">&nbsp; <input type="text" name="sangdamja" class='text' size="15" value="<%= cvBn.getSangdamja() %>" style='IME-MODE: active'></td>
                            </tr>
                            <tr> 
                                <td class='title'>상담내용</td>
                                <td colspan="3">&nbsp; <textarea name="vst_cont" cols="100" rows="7"><%= cvBn.getVst_cont() %></textarea></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr align="right"> 
                    <td colspan="2" valign="bottom">
                        <a href="javascript:vst_reg()">
                      <% if(cvBn.getVst_pur().equals("")){ %>
        				<img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
                      <% }else{ %>
                      	<img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
                      <% } %>
                       <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
                </tr>
                <tr> 
                    <td colspan="2">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</html>