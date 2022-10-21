<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="encar" scope="page" class="acar.offls_pre.Off_ls_pre_encar"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
a:link { text-decoration:none; }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function insEncar()
{
	var fm = document.form1;
	if(get_length(fm.content.value) > 4000){
		alert("4000자 까지만 입력할 수 있습니다.");
		return;
	}			
	if(!confirm('등록하시겠습니까?')){ return; }	
	fm.action="/acar/off_ls_pre/off_ls_pre_sc_in_encar_reg_ins.jsp";
	fm.target = "i_no";	
	fm.submit();	
}
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}
-->
</script>
</head>
<body>
<form name="form1" action=""  method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ENCAR</span></td>
        <td align="right"> <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
	    <a href='javascript:insEncar();' onMouseOver="window.status=''; return true"> 
        <img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a> 
        <%}%> </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td class='title' width=15%> 엔카등록ID</td>
                <td colspan="3">&nbsp; <input  class="text" type="text" name="encar_id" size="20" value=""></td>
              </tr>
              <tr> 
                <td class='title'>게시등록일</td>
                <td colspan="3">&nbsp; <input  class="text" type="text" name="reg_dt" size="20" value="" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
              </tr>
              <tr> 
                <td class='title'>조회수</td>
                <td colspan="3">&nbsp; <input  class="text" type="text" name="count" size="20" value=""> 
                </td>
              </tr>
              <tr> 
                <td class='title'>기본옵션</td>
                <td colspan="3">&nbsp; <textarea  class="textarea" name="opt_value" cols="100" rows="2">&nbsp;</textarea>
                </td>
              </tr>
              <tr> 
                <td class='title'>딜러매입가</td>
                <td colspan="3">&nbsp; <input  class="num" type="text" name="d_car_amt" size="20" value="" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
                </td>
              </tr>
              <tr> 
                <td class='title'>소비자가</td>
                <td colspan="3"> &nbsp; <input  class="num" type="text" name="s_car_amt" size="20" value="" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
                </td>
              </tr>
              <tr> 
                <td class='title'>엔카소비자가</td>
                <td colspan="3">&nbsp; <input  class="num" type="text" name="e_car_amt" size="20" value="" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
                </td>
              </tr>
              <tr> 
                <td class='title'>엔카동급물평균가</td>
                <td colspan="3">&nbsp; <input  class="num" type="text" name="ea_car_amt" size="20" value="" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
                </td>
              </tr>
              <tr> 
                <td class='title'>보증서번호</td>
                <td colspan="3">&nbsp; <input  class="text" type="text" name="guar_no" size="20" value=""> 
                </td>
              </tr>
              <tr> 
                <td class='title'>CashBack차량이용료</td>
                <td colspan="3">&nbsp; <input  class="num" type="text" name="day_car_amt" size="20" value="" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
                &nbsp;&nbsp;&nbsp;&nbsp;(동급차량 1주일 단기렌트료의 30%)</td>
              </tr>
              <tr> 
                <td class='title'>이미지경로</td>
                <td colspan="3">&nbsp; <input  class="text" type="text" name="img_path" size="70" value=""> 
                </td>
              </tr>		  
              <tr> 
                <td class='title'>설명</td>
                <td colspan="3">&nbsp; <textarea  class="textarea" name="content" cols="100" rows="5">&nbsp;</textarea> 
                </td>
              </tr>		  
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>