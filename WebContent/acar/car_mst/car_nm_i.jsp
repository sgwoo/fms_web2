<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include./table.css">
<script language="JavaScript">
<!--
	function CarNmReg(){
		var theForm = document.CarNmForm;
		if(!CheckField()){	return;	}
		if(!confirm('등록하시겠습니까?')){	return;	}
		theForm.cmd.value = "i";
		theForm.target="i_no";
		theForm.submit();
	}

	function CarNmUp(){
		var theForm = document.CarNmForm;
		var nm = theForm.car_name.value;
		if(!CheckField()){	return;	}
		if(!confirm(nm + '을 수정하시겠습니까?')){	return;	}
		theForm.cmd.value = "u";
		theForm.target="i_no";
		theForm.submit();
	}

	function GetCarKind(){
		var theForm1 = document.CarNmForm;
		var theForm2 = document.CarKindSearchForm;
		te = theForm1.code;
		theForm2.sel.value = "CarNmForm.code";
		theForm2.car_comp_id.value = theForm1.car_comp_id.value;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		theForm2.target="i_no";
		theForm2.submit();
	}

	function SearchCarNm(){
		var theForm1 = document.CarNmForm;
		var theForm2 = document.SearchCarNmForm;	
		theForm2.car_comp_id.value = theForm1.car_comp_id.value;
		theForm2.code.value = theForm1.code.value;
		theForm2.target="i_in";
		theForm2.submit();
	}

	function CheckField(){
		var theForm = document.CarNmForm;
		if(theForm.car_comp_id.value==""){
			alert("자동차회사를 선택하십시요.");
			theForm.car_comp_id.focus();
			return false;
		}
		if(theForm.code.value==""){
			alert("차명을 선택하십시요.");
			theForm.code.focus();
			return false;
		}
		if(theForm.car_name.value==""){
			alert("차명을 입력하십시요.");
			theForm.car_name.focus();
			return false;
		}
		return true;
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	
	//자동차회사 리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
%>

<form action="./car_nm_null_ui.jsp" name="CarNmForm" method="POST" >
  <table border=0 cellspacing=0 cellpadding=0 width="360">
    <tr>    	
      <td> 
        <table border="0" cellspacing="0" cellpadding="0" width="340">
          <tr> 
            <td width=80 align="right">자동차회사&nbsp;</td>
            <td colspan="2"> 
              <select name="car_comp_id" onChange="javascript:GetCarKind()">
                <option value="">전체 
                <%for(int i=0; i<cc_r.length; i++){
			        cc_bean = cc_r[i];%>
                <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                <%}%>
              </select>
              <script language="javascript">
					document.CarNmForm.car_comp_id.value = '<%=car_comp_id%>';
			  </script>
            </td>
          </tr>
          <tr> 
            <td align="right" width="80">차명&nbsp;</td>
            <td colspan="2"> 
              <select name="code" onChange="javascript:SearchCarNm()">
                <option value="">전체 
              </select>
              <script language="javascript">
					document.CarNmForm.code.value = '<%=code%>';
			  </script>
            </td>
          </tr>
          <tr> 
            <td align="right" width="80">차종&nbsp;</td>
            <td colspan="2"> 
              <input type="hidden" name="car_id" value="">
              <input type="text" name="car_name" value="" size="25" class=text>
              &nbsp;사용여부 
              <input type="checkbox" name="car_yn" value="Y">
            </td>
          </tr>
          <tr> 
            <td align="right" width="80">&nbsp;</td>
            <td align="right">
			<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
			  <a href="javascript:CarNmReg()" onMouseOver="window.status=''; return true">등록</a>&nbsp;
			<%}%>			
			<%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
			  <a href="javascript:CarNmUp()" onMouseOver="window.status=''; return true">수정</a>&nbsp;
			<%}%>		
			  <a href="javascript:self.close();window.close();" onMouseOver="window.status=''; return true">닫기</a></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
        <tr>
		<td colspan=4>
			<table border="0" cellspacing="0" cellpadding="0" width=360>
				<tr>
					<td class='line' width="341">						 
		              <table border="0" cellspacing="1" cellpadding="0" width=340>
        		        <tr>								
                		  <td class=title>차명</td>								
		                  <td class=title width=70>사용여부</td>
						</tr>
					  </table>
					</td>
					<td width=19>&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
		<td><iframe src="./car_nm_i_in.jsp?auth_rw=<%=auth_rw%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>" name="i_in" width="358" height="260" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
	</tr> 
</table>
<input type="hidden" name="cmd" value="">
</form>
<form action="./car_mst_nodisplay.jsp" name="CarKindSearchForm" method="post">
<input type="hidden" name="sel" value="">
<input type="hidden" name="car_comp_id" value="">
<input type="hidden" name="code" value="">
</form>
<form action="./car_nm_i_in.jsp" name="SearchCarNmForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
<input type="hidden" name="code" value="<%=code%>">
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</body>
</html>