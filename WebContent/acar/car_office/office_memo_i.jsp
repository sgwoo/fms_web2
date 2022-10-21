<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="coev_bean" class="acar.car_office.CarOffEmpVisBean" scope="page"/>
<%
	String emp_id = "";					//영업소 사원ID
    String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	if(request.getParameter("emp_id") != null) emp_id = request.getParameter("emp_id");
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector mngs = c_db.getUserList("", "", "MNG_EMP"); //영업팀 리스트
	Vector buss = c_db.getUserList("", "", "BUS_EMP"); //고객지원팀 리스트
	Vector gens = c_db.getUserList("", "", "GEN_EMP"); //총무팀 리스트

	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
function VisReg()
{
	var theForm = document.VisInsertForm;
	if(!CheckField())
	{
		return;
	}
	
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target = "i_no"
	theForm.submit();
}
function VisUp()
{
	var theForm = document.VisInsertForm;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "u";
	theForm.target = "i_no"
	theForm.submit();
}
function CheckField()
{
	var fm = document.VisInsertForm;
	if(fm.sub.value==""){	alert("제목을 입력해 주세요");	fm.sub.focus(); return false; }
	return true;
}
//-->
</script>
</head>
<body leftmargin="15" >
<form action="./office_memo_null_ui.jsp" name="VisInsertForm" method="POST" >
<input type="hidden" name="emp_id" value="<%=emp_id%>">
<input type="hidden" name="seq_no" value="">
<input type="hidden" name="cmd" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=550>
    <tr> 
      <td> <table border="0" cellspacing="0" cellpadding="0" width=550>
          <tr> 
            <td class=line> <table border="0" cellspacing="1" width=530>
                <tr> 
                  <td class=title width=90>등록자</td>
                  <td width=146>&nbsp; <select name='vis_nm'>
                      <option value="">==선택==</option>
                      <option value="">=영업팀=</option>
                      <%for (int i = 0 ; i < buss.size() ; i++){%>
                      <% Hashtable user = (Hashtable)buss.elementAt(i);%>
                      <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                      <%}%>
                      <option value="">=고객지원팀=</option>
                      <%for (int i = 0 ; i < mngs.size() ; i++){%>
                      <% Hashtable user = (Hashtable)mngs.elementAt(i);%>
                      <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                      <%}%>
                      <option value="">=총무팀=</option>
                      <%for (int i = 0 ; i < gens.size() ; i++){%>
                      <% Hashtable user = (Hashtable)gens.elementAt(i);%>
                      <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                      <%}%>
                    </select></td>
                  <td class=title width=93>등록일자</td>
                  <td width=188>&nbsp; <input type="text" name="vis_dt" value="<%= AddUtil.getDate() %>" size="14" class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <tr> 
                  <td class=title>제목</td>
                  <td colspan=3>&nbsp; <input type="text" name="sub" value="" size="65" class=text></td>
                </tr>
                <tr> 
                  <td class=title>특이사항</td>
                  <td colspan=3>&nbsp; <textarea name="vis_cont" cols=65 rows=3></textarea></td>
                </tr>
              </table></td>
            <td width=20> </td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td align="right"> <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%> <a href="javascript:VisReg()" onMouseOver="window.status=''; return true"> 
        <img src="/images/reg.gif" width="50" height="18" align="absbottom" border="0"></a>&nbsp; 
        <%}%> <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))	{%> <a href="javascript:VisUp()" onMouseOver="window.status=''; return true"> 
        <img src="/images/update.gif" width="50" height="18" align="absbottom" border="0"></a>&nbsp; 
        <%}%> <a href="javascript:self.close();window.close();" onMouseOver="window.status=''; return true"> 
        <img src="/images/close.gif" width="50" height="18" align="absbottom" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
      </td>
    </tr>
    <tr> 
      <td><table width="530" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="line"><table border="0" cellspacing="1" cellpadding="0" width=530>
                <tr> 
                  <td class=title width=60>연번</td>
                  <td class=title width=120>등록자</td>
                  <td class=title width=230>제목</td>
                  <td class=title width=120>등록일자</td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td><iframe src="./office_memo_in.jsp?auth_rw=<%=auth_rw%>&emp_id=<%=emp_id%>" name="VisList" width="550" height="150" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>