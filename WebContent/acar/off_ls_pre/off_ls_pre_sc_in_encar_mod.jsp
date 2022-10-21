<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<jsp:useBean id="encar" scope="page" class="acar.offls_pre.Off_ls_pre_encar"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	encar = olpD.getEncar(car_mng_id);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function updEncar()
{
	var fm = document.form1;
	if(get_length(fm.content.value) > 4000){
		alert("4000자 까지만 입력할 수 있습니다.");
		return;
	}			
	if(!confirm('수정하시겠습니까?')){ return; }
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
<form name="form1" action="/acar/off_ls_pre/off_ls_pre_sc_in_encar_mod_upd.jsp" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
      <td align='left'><< ENCAR >></td>
      <td align="right"> <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
	   <a href='javascript:updEncar();' onMouseOver="window.status=''; return true"> 
        <img src="/images/update.gif" width="50" height="18" align="absmiddle" border="0" alt="수정"></a> 
        <%}%> </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding="0" >
          <tr> 
            <td class='title' width='120'>엔카등록ID</td>
            <td >&nbsp; <input  class="text" type="text" name="encar_id" size="20" value="<%= encar.getEncar_id() %>"></td>
          </tr>
          <tr> 
            <td class='title' width="120">게시등록일</td>
            <td >&nbsp; <input  class="text" type="text" name="reg_dt" size="20" value="<%= AddUtil.ChangeDate2(encar.getReg_dt()) %>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>
          <tr> 
            <td class='title' width="120">조회수</td>
            <td width="677" >&nbsp; <input  class="text" type="text" name="count" size="20" value="<%= encar.getCount() %>"> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">기본옵션</td>
            <td width="677" >&nbsp; <textarea  class="textarea" name="opt_value" cols="100" rows="2"><%= encar.getOpt_value() %></textarea>
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">딜러매입가</td>
            <td >&nbsp; <input  class="num" type="text" name="d_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getD_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">소비자가</td>
            <td >&nbsp; <input  class="num" type="text" name="s_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getS_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">엔카소비자가</td>
            <td >&nbsp; <input  class="num" type="text" name="e_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getE_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">엔카동급물평균가</td>
            <td >&nbsp; <input  class="num" type="text" name="ea_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getEa_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
            </td>
          </tr>
          <tr> 
            <td class='title'>보증서번호</td>
            <td >&nbsp; <input  class="text" type="text" name="guar_no" size="20" value="<%= encar.getGuar_no() %>"> 
            </td>
          </tr>
          <tr> 
            <td class='title'>CashBack차량이용료</td>
            <td >&nbsp; <input  class="num" type="text" name="day_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getDay_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> 원
            &nbsp;&nbsp;&nbsp;&nbsp;(동급차량 1주일 단기렌트료의 30%)</td>
          </tr>
          <tr> 
            <td class='title'>이미지경로</td>
            <td >&nbsp; <input  class="text" type="text" name="img_path" size="50" value="<%= encar.getImg_path() %>"></td>
          </tr>		  
          <tr> 
            <td class='title'>설명</td>
            <td >&nbsp; 
              <textarea  class="textarea" name="content" cols="100" rows="13"><%=encar.getContent()%></textarea>
            </td>
          </tr>
        </table></td>
    </tr>
  </table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
