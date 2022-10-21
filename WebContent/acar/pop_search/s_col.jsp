<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.cc.*"%> 
<jsp:useBean id="cc_db" class="acar.cc.CcDatabase" scope="page"/>
<jsp:useBean id="co_bean" class="acar.beans.CcColBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	
	//차종리스트
	CcColBean [] co_r = cc_db.getCarColList(car_comp_id, car_cd, car_seq, "");
%>

<html>
<head><title>색상 선택</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var codes="";
		var amts=0;	
		var cols="";		
		var o_split;
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_c_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes += o_split[0];
					amts += toInt(o_split[1]);
					cols += o_split[2];					//+", "
				}
			}
		}	
		if(cnt == 0){
		 	alert("색상을 선택하세요.");
			return;
		}
		window.opener.form1.clr_amt.value = parseDecimal(amts);
		window.opener.form1.clr_s_amt.value = parseDecimal(sup_amt(amts));
		window.opener.form1.clr_v_amt.value = parseDecimal(amts - toInt(parseDigit(window.opener.form1.clr_s_amt.value)));
		window.opener.form1.colo.value 	= cols;		
		window.close();
	}
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10">
<form name='form1' method='post'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td align='left'><font color="#666600">- 색상 조회 -</font></td>
      <td align='right'><a href="#" target="d_content"><img src="../images/bbs/but_in.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='20%'>선택</td>
            <td class='title' width="40%">색상</td>
            <td class='title' width="40%">금액</td>
          </tr>
          <%if(co_r.length>0){
		  		for(int i=0; i<co_r.length; i++){
			        co_bean = co_r[i]; %>		  
          <tr align="center"> 
            <td width='20%' height="19"> 
              <input type="radio" name="car_c_seq" value='<%=co_bean.getCar_c_seq()%>||<%=co_bean.getCar_c_p()%>||<%=co_bean.getCar_c()%>'>
            </td>
            <td width="40%" height="19"><%=co_bean.getCar_c()%></td>
            <td width="40%" height="19"><div align="right"><%=AddUtil.parseDecimal(co_bean.getCar_c_p())%>원&nbsp;</div></td>
          </tr>
          <%	}
		  }else{	%>
          <tr align="center"> 
            <td colspan="3">해당 색상이 없읍니다.</td>
          </tr>
	  <% } %>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='right' colspan="2"><a href="javascript:save();"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a> 
        <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
