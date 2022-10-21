<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.cc.*"%> 
<jsp:useBean id="cc_db" class="acar.cc.CcDatabase" scope="page"/>
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
					o_split = ck.value.split(",");	
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
	
	function set_credit(arg){
		if(arg=="0"){
			opener.form1.spr_kd_nm.value = "일반고객";
		}else if(arg=="1"){
			opener.form1.spr_kd_nm.value = "우량기업";
		}else if(arg=="2"){
			opener.form1.spr_kd_nm.value = "초우량기업";
		}else if(arg=="3"){
			opener.form1.spr_kd_nm.value = "신설법인";
		}
		opener.form1.spr_kd.value = arg;
		this.close();
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
      <td width="61%" align='right'> <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='5%'>선택</td>
            <td class='title' width="45%">신용구분</td>
          </tr>
          <tr align="center"> 
            <td><input type="radio" name="radiobutton" value="radiobutton"> </td>
            <td><a href="javascript:set_credit('3');">신설법인</a></td>
          </tr>
          <tr align="center">
            <td><input type="radio" name="radiobutton" value="radiobutton"></td>
            <td><a href="javascript:set_credit('0');">일반고객</a></td>
          </tr>
          <tr align="center">
            <td><input type="radio" name="radiobutton" value="radiobutton"></td>
            <td><a href="javascript:set_credit('1');">우량기업</a></td>
          </tr>
          <tr align="center">
            <td><input type="radio" name="radiobutton" value="radiobutton"></td>
            <td><a href="javascript:set_credit('2');">초우량기업</a></td>
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
