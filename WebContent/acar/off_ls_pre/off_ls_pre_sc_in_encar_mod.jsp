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

	//�α��λ�������� ��������
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
		alert("4000�� ������ �Է��� �� �ֽ��ϴ�.");
		return;
	}			
	if(!confirm('�����Ͻðڽ��ϱ�?')){ return; }
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
        <img src="/images/update.gif" width="50" height="18" align="absmiddle" border="0" alt="����"></a> 
        <%}%> </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding="0" >
          <tr> 
            <td class='title' width='120'>��ī���ID</td>
            <td >&nbsp; <input  class="text" type="text" name="encar_id" size="20" value="<%= encar.getEncar_id() %>"></td>
          </tr>
          <tr> 
            <td class='title' width="120">�Խõ����</td>
            <td >&nbsp; <input  class="text" type="text" name="reg_dt" size="20" value="<%= AddUtil.ChangeDate2(encar.getReg_dt()) %>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>
          <tr> 
            <td class='title' width="120">��ȸ��</td>
            <td width="677" >&nbsp; <input  class="text" type="text" name="count" size="20" value="<%= encar.getCount() %>"> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">�⺻�ɼ�</td>
            <td width="677" >&nbsp; <textarea  class="textarea" name="opt_value" cols="100" rows="2"><%= encar.getOpt_value() %></textarea>
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">�������԰�</td>
            <td >&nbsp; <input  class="num" type="text" name="d_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getD_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> ��
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">�Һ��ڰ�</td>
            <td >&nbsp; <input  class="num" type="text" name="s_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getS_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> ��
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">��ī�Һ��ڰ�</td>
            <td >&nbsp; <input  class="num" type="text" name="e_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getE_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> ��
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">��ī���޹���հ�</td>
            <td >&nbsp; <input  class="num" type="text" name="ea_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getEa_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> ��
            </td>
          </tr>
          <tr> 
            <td class='title'>��������ȣ</td>
            <td >&nbsp; <input  class="text" type="text" name="guar_no" size="20" value="<%= encar.getGuar_no() %>"> 
            </td>
          </tr>
          <tr> 
            <td class='title'>CashBack�����̿��</td>
            <td >&nbsp; <input  class="num" type="text" name="day_car_amt" size="20" value="<%= AddUtil.parseDecimal(encar.getDay_car_amt()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'> ��
            &nbsp;&nbsp;&nbsp;&nbsp;(�������� 1���� �ܱⷻƮ���� 30%)</td>
          </tr>
          <tr> 
            <td class='title'>�̹������</td>
            <td >&nbsp; <input  class="text" type="text" name="img_path" size="50" value="<%= encar.getImg_path() %>"></td>
          </tr>		  
          <tr> 
            <td class='title'>����</td>
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
