<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.short_fee_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function CarNmLinkUp(){
		var theForm = document.CarNmForm;
		var nm = theForm.car_name.value;
		if(!CheckField()){	return;	}
	
		if(theForm.sec_st.checked == false && theForm.car_id.value==''){
			alert("차명을 선택하십시요.");
			theForm.car_name.focus();
			return;
		}		
		
		if(!confirm('수정하시겠습니까?')){	return;	}
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
			alert("차종을 선택하십시요.");
			theForm.code.focus();
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
	
	Vector conts = sfm_db.getSectionList();
	int cont_size = conts.size();
%>

<form action="./car_nm_null_ui.jsp" name="CarNmForm" method="POST" >
<input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width="460">
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width="440">
                <tr> 
                    <td width=80>&nbsp;&nbsp;<img src=../images/center/arrow_jdchs.gif align=absmiddle></td>
                    <td> 
                      <select name="car_comp_id" onChange="javascript:GetCarKind()">
                        <option value="">전체 </option>
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
                    <td>&nbsp;&nbsp;<img src=../images/center/arrow_cj.gif align=absmiddle></td>
                    <td> 
                      <select name="code" onChange="javascript:SearchCarNm()">
                        <option value="">전체 </option>
                      </select>
                      <script language="javascript">
        					document.CarNmForm.code.value = '<%=code%>';
        			  </script>
                    </td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;<img src=../images/center/arrow_cm.gif align=absmiddle></td>
                    <td> 
                      <input type="hidden" name="car_id" value="">
                      <input type="text" name="car_name" value="" size="40" class=whitetext>
                      &nbsp;<img src=../images/center/arrow_syyb.gif align=absmiddle> 
                      <input type="checkbox" name="car_yn" value="Y">
                    </td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;<img src=../images/center/arrow_brcd.gif align=absmiddle></td>
                    <td> 
                      <select name='section'>
                        <option value="">전체 </option>			  
                        <%if(cont_size > 0){
        			for(int i = 0 ; i < cont_size ; i++){
        				Hashtable sfm = (Hashtable)conts.elementAt(i);%>
                        <option value='<%=sfm.get("SECTION")%>'> <%=sfm.get("NM")%>(<%=sfm.get("SECTION")%>) 
                        </option>
                        <%	}
        				}%>
                      </select>
                      &nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_cjjcjy.gif align=absmiddle>
                      <input type="checkbox" name="sec_st" value="A">
                    </td>
                </tr>
                <tr> 
                    <td align="right" colspan="2"> 
                      <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:CarNmLinkUp()"><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
                      <%}%>
                      <a href="javascript:self.close();window.close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
                </tr>
            </table>
        </td>
        <td width="20"></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'>               
            <table border="0" cellspacing="1" cellpadding="0" width=440>
                <tr> 
                    <td class=title width="30">연번</td>                      
                    <td class=title width="270">차명</td>                     
                    <td class=title width=70>분류코드</td>                      
                    <td class=title width=70>사용여부</td>
                </tr>
            </table>
        </td>
        <td width="20"></td>	  
    </tr>
    <tr> 
        <td colspan="2"><iframe src="" name="i_in" width="460" height="550" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
</table>
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
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>