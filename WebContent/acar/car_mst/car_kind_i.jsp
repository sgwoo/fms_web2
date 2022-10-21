<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.car_mst.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function CarKindReg(){
		var theForm = document.CarKindForm;
		if(!CheckField()){	return;	}
		if(theForm.code.value != ''){ alert('이미 등록된 차명입니다.'); return;}
		if(!confirm('등록하시겠습니까?')){	return;	}
		theForm.cmd.value = "i";
		theForm.target = "i_no";
		theForm.submit();
	}	
	
	function CarKindUp(){
		var theForm = document.CarKindForm;
		var nm = theForm.car_nm.value;
		if(!CheckField()){	return;	}
		if(theForm.code.value == ''){ alert('등록하십시오.'); return;}		
		if(!confirm(nm + '을 수정하시겠습니까?')){	return;	}
		theForm.cmd.value = "u";
		theForm.target = "i_no";
		theForm.submit();
	}

	function UpdateList(cd,nm_cd,nm){
		var theForm = document.CarCompForm;
		theForm.nm_cd.value = nm_cd;
		theForm.nm.value= nm;
		theForm.cd.value= cd;
	}

	function SearchCarKind(){
		var theForm1 = document.CarKindForm;
		var theForm2 = document.SearchCarKindForm;	
		theForm2.car_comp_id.value = theForm1.car_comp_id.value;
		theForm2.submit();
	}

	//상단에 디스플레이
	function UpdateCarKindDisp(code,car_cd,car_nm,car_yn,sd_amt,est_yn,main_yn,ab_nm,dlv_ext){
		var theForm = document.CarKindForm;
		theForm.code.value = code;
		theForm.car_cd.value = car_cd;
		theForm.car_nm.value = car_nm;
		if(car_yn == 'Y'){	
			theForm.car_yn.checked = true;			
		}else{
			theForm.car_yn.checked = false;
		}
		theForm.sd_amt.value = parseDecimal(sd_amt);
		if(est_yn == 'Y'){	
			theForm.est_yn.checked = true;			
		}else{
			theForm.est_yn.checked = false;
		}
		if(main_yn == 'Y'){	
			theForm.main_yn.checked = true;			
		}else{
			theForm.main_yn.checked = false;
		}
		theForm.ab_nm.value = ab_nm;
		theForm.dlv_ext.value = dlv_ext;
		
	}
	
	function CheckField(){
		var theForm = document.CarKindForm;
		if(theForm.car_comp_id.value==""){	alert("자동차회사를 선택하십시요.");	theForm.car_comp_id.focus();	return false; }
		if(theForm.car_cd.value==""){		alert("차명코드를 입력하십시요.");		theForm.car_cd.focus();			return false; }
		if(theForm.car_nm.value==""){		alert("차종명을 입력하십시요.");		theForm.car_nm.focus(); 		return false; }
		return true;
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_comp_id = request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	
	//자동차회사 리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//차종리스트
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll(car_comp_id);
%>
<form action="./car_kind_null_ui.jsp" name="CarKindForm" method="POST" >
<input type="hidden" name="cmd" value="">
<input type="hidden" name="code" value="">
<input type="hidden" name="sd_amt" value=""><!--탁송료 현재 안씀-->
<table border=0 cellspacing=0 cellpadding=0 width="700">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>차명관리 </span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
                <tr> 
                    <td class=title width="12%">자동차회사</td>
                    <td width="48%">
                        <select name="car_comp_id" onChange="javascript:SearchCarKind()">
                        <option value="">전체</option>
                        <%for(int i=0; i<cc_r.length; i++){
        					cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                        <%}%>
                      </select>
                      <script language="javascript">
        					document.CarKindForm.car_comp_id.value = '<%=car_comp_id%>';
        			  </script>
                    </td>
                    <td class=title width="12%">차명코드</td>
                    <td width="28%">
                        <input type="text" name="car_cd" value="" size="3" maxlength='2' class=text>
                    </td>
                </tr>    
                <tr> 
                    <td class=title width="12%">차명</td>
                    <td  width="38%">
                        <input type="text" name="car_nm" value="" size="40" class=text>
                    </td>
                    <td class=title width="12%">통합차명</td>
                    <td  width="38%">
                        <input type="text" name="ab_nm" value="" size="20" class=text>
                    </td>
                </tr>   
                <tr> 
                    <td class=title width="80">구분</td>
                    <td>
                        <input type="checkbox" name="car_yn" value="Y"> 사용여부 
                        <input type="checkbox" name="est_yn" value="Y"> 견적여부 
                        <input type="checkbox" name="main_yn" value="Y"> 주요차종여부 
                    <td class=title width="80">기본출고지</td>
                    <td>
                        <input type="text" name="dlv_ext" value="" size="10" class=text>
                    </td>
                </tr>   
            </table>
        </td>
    </tr>
    <tr> 
                    <td align="right"> 
                      <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:CarKindReg()"><img src=../images/center/button_reg.gif border=0></a> 
                      <%}%>
                      <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:CarKindUp()"><img src=../images/center/button_modify.gif border=0></a> 
                      <%}%>
                      <a href="javascript:self.close();window.close();"><img src=../images/center/button_close.gif border=0></a></td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
                <tr> 
                    <td class=title width="10%">차명코드</td>
                    <td class=title width="39%">차명</td>
                    <td class=title width="15%">통합차명</td>
                    <!--<td class=title width="60">탁송료</td>-->
                    <td class=title width="7%">사용<br>여부</td>
                    <td class=title width="7%">견적<br>여부</td>
                    <td class=title width="7%">주요<br>차종</td>                    
                    <td class=title width="15%">기본출고지</td>
                </tr>
                <%	for(int i=0; i<cm_r.length; i++){
			        	cm_bean = cm_r[i];
			        	
			        	String td_color = "";
						if(cm_bean.getCar_yn().equals("N")) td_color = " class='is' ";
			    %>
                <tr> 
                    <td <%=td_color%> align=center ><%=cm_bean.getCar_cd()%></td>
                    <td <%=td_color%> align=center><a href="javascript:UpdateCarKindDisp('<%=cm_bean.getCode()%>','<%=cm_bean.getCar_cd()%>','<%=cm_bean.getCar_nm()%>','<%=cm_bean.getCar_yn()%>','<%=cm_bean.getSd_amt()%>','<%=cm_bean.getEst_yn()%>','<%=cm_bean.getMain_yn()%>','<%=cm_bean.getAb_nm()%>','<%=cm_bean.getDlv_ext()%>')"><%=cm_bean.getCar_nm()%></a></td>
                    <td <%=td_color%> align=center><%=cm_bean.getAb_nm()%></td>
                    <!--<td align=center><%=AddUtil.parseDecimal(cm_bean.getSd_amt())%></td>-->
                    <td <%=td_color%> align=center><%=cm_bean.getCar_yn()%></td>
                    <td <%=td_color%> align=center><%=cm_bean.getEst_yn()%></td>
                    <td <%=td_color%> align=center><%=cm_bean.getMain_yn()%></td>
                    <td <%=td_color%> align=center><%=cm_bean.getDlv_ext()%></td>
                </tr>
          <%	}%>
            </table>
        </td>
    </tr>
</table>
</form>
<form action="./car_kind_i.jsp" name="SearchCarKindForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>