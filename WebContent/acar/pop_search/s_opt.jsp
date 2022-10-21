<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.cc.*"%> 
<jsp:useBean id="cc_db" class="acar.cc.CcDatabase" scope="page"/>
<jsp:useBean id="co_bean" class="acar.beans.CcOptBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	
	//차종리스트
	CcOptBean [] co_r = cc_db.getCarOptList(car_comp_id, car_cd, car_id, car_seq, "");
%>

<html>
<head><title>선택사양 선택</title>
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
		var opts="";		
		var o_split;
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_s_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes += o_split[0];
					amts += toInt(o_split[1]);
					opts += o_split[2]+", ";					
				}
			}
		}	
		if(cnt == 0){
		 	alert("선택사양을 선택하세요.");
			return;
		}
		opener.form1.opt_c_amt.value = parseDecimal(amts);
		opener.form1.opt_cs_amt.value = parseDecimal(sup_amt(amts));
		opener.form1.opt_cv_amt.value = parseDecimal(amts - toInt(parseDigit(window.opener.form1.opt_s_amt.value)));
		opener.form1.opt.value 		= opts;		
		window.close();
	}
	
	function set_opt(arg1, arg2){
		fm = document.form1;
		fm.opt_nm.value = arg1;
		fm.opt_amt.value = arg2;
		
	}
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10">
<form name='form1' method='post'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td width="39%" align='left'><font color="#666600">- 선택사양 선택 -</font></td>
      <td width="61%" align='right'><a href="javascript:save();"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a> 
        <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='5%'>선택</td>
            <td class='title' width="45%">선택사양</td>
            <td class='title' width="25%">금액</td>
            <td class='title' width="25%">비고</td>
          </tr>
          <%if(co_r.length>0){
		  		for(int i=0; i<co_r.length; i++){
			        co_bean = co_r[i]; %>
          <tr align="center"> 
            <td><input type="checkbox" name="car_s_seq" value='<%=co_bean.getCar_seq()%>||<%=co_bean.getCar_o_p()%>||<%=co_bean.getCar_o()%>'> 
            </td>
            <td><a href="javascript:set_opt('<%=co_bean.getCar_o()%>','<%=AddUtil.parseDecimal(co_bean.getCar_o_p())%>');"><%=co_bean.getCar_o()%></a></td>
            <td><div align="right"><%=AddUtil.parseDecimal(co_bean.getCar_o_p())%>원&nbsp;</div></td>
            <td>&nbsp;</td>
          </tr>
          <%	}
		  }else{	%>
          <tr align="center"> 
            <td colspan="4">해당 선택사양이 없읍니다.</td>
          </tr>
          <% } %>
          <tr align="center"> 
            <td>&nbsp;</td>
            <td><input type="text" name="opt_nm"></td>
            <td><input type="text" name="opt_amt" size="10"></td>
            <td><a href="#" target="d_content"><img src="../images/bbs/but_in.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a>
			&nbsp;<a href="#" target="d_content"><img src="../images/bbs/but_modi.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='right' colspan="2">&nbsp;</td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
