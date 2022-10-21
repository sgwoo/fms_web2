<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String var_cd = request.getParameter("var_cd")==null?"":request.getParameter("var_cd");	
	String var_nm = request.getParameter("var_nm")==null?"":request.getParameter("var_nm");	
	String d_type = request.getParameter("d_type")==null?"":request.getParameter("d_type");	
	
	//차종변수별 리스트
	EstiDatabase e_db = EstiDatabase.getInstance();
	Vector vars = e_db.getEstiCarVarList(gubun1, gubun2, gubun3, var_cd);
	int size = vars.size();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>차종변수 : <%if(gubun1.equals("1")) {%>리스 <%}else{%>렌트<%}%> - <%=var_nm%></title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//차종별 수정
	function save(){
		var fm = document.form1;				
		fm.target='i_no';
		fm.action = 'esti_car_var_list_a.jsp';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name="form1" method="post" action="esti_car_var_list_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="var_cd" value="<%=var_cd%>">
  <input type="hidden" name="var_nm" value="<%=var_nm%>">
  <input type="hidden" name="d_type" value="<%=d_type%>">          
  <input type="hidden" name="size" value="<%=size%>">          
  <input type="hidden" name="cmd" value="u">
<table border=0 cellspacing=0 cellpadding=0 width=<%=70*(size+1)%>>
  <tr> 
    <td>&nbsp;&nbsp;<img src=../images/center/arrow_bys.gif border=0 align=absmiddle> : <%=var_nm%> (<%=var_cd%>)</td>
  </tr>
  <tr> 
    <td class=line>
      <table border=0 cellspacing=1 width=<%=70*(size+1)%>>
        <tr> 
            <td class="title" width="70">소분류</td>
          <!--소분류-->
          <%for (int i = 0 ; i < size ; i++){
			Hashtable var = (Hashtable)vars.elementAt(i);%>
          <td class="title" width="70"><%=c_db.getNameByIdCode("0008", "", String.valueOf(var.get("A_E")))%></td>
          <%}%>
        </tr>
        <tr> 
            <td class="title"  width="70">변수값</td>
          <!--대분류-->
          <%for (int i = 0 ; i < size ; i++){
			Hashtable var = (Hashtable)vars.elementAt(i);
			String car_st_nm = c_db.getNameByIdCode("0008", "", String.valueOf(var.get("A_E")));%>
          <td align="center" width="70" <%if(car_st_nm.equals("대형승용Ⅲ")||car_st_nm.equals("대형승용Ⅳ")||car_st_nm.equals("리무진")){%>class="star"<%}%>>
              <input type="hidden" name="var" size="8" value="<%=var.get("A_A")%><%=var.get("SEQ")%><%=var.get("A_E")%>" class=num>
			  <input type="text" name="value" size="8" 
			  	<%if(d_type.equals("f")){%>value="<%=AddUtil.parseFloat(String.valueOf(var.get("VALUE")))%>"
				<%}else if(d_type.equals("i")){%>value="<%=AddUtil.parseDecimal(String.valueOf(var.get("VALUE")))%>"  onBlur="javascript:this.value=parseDecimal(this.value);"
				<%}else{%>value="<%=var.get("VALUE")%>"<%}%> class=num>
              </td>
          <%}%>
        </tr>
      </table>
    </td>
  </tr>
  <%if(!auth_rw.equals("1")){%>
  <tr> 
      <td align="right"><a href="javascript:save();">수정</a> </td>
  </tr>  
  <%}%>
</table>
</form> 
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>