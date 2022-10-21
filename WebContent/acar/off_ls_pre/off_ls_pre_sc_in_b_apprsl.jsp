<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*, acar.offls_yb.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_pre.Offls_preBean"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>

<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	detail = olpD.getPre_detail(car_mng_id);
	apprsl = olpD.getPre_apprsl(car_mng_id);

	
	//���������
	Vector actns = olpD.getActns();
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	//��ǰ�� ���� ��� �����ϱ� ����
	String apprsl_car_mng_id = olyD.getApprsl_Car_mng_id(car_mng_id);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function apprslUpd(ioru)
{
	var fm = document.form1;	
	fm.gubun.value = ioru;
	fm.action="/acar/off_ls_pre/off_ls_pre_sc_in_b_apprsl_iu.jsp";
	fm.submit();	
}
function add_actn(){
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	var SUBWIN = "off_ls_pre_actn_i.jsp"+url;
	window.open(SUBWIN, "View_ADD_ACTN", "left=100, top=100, width=820, height=400, resizable=no, scrollbars=no");
}
-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǰ��</span></td>
        <td align="right"> 
          <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
          <%if(apprsl_car_mng_id.equals("")){%>
          <a href='javascript:apprslUpd("i");' onMouseOver="window.status=''; return true"> 
          <img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a> 
          <%}else{%>
          <a href='javascript:apprslUpd("u");' onMouseOver="window.status=''; return true"> 
          <img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a> 
          <%}%>
          <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0"  width="100%">
                <tr> 
                  <td width=16% height="22" class='title'> ��ü��</td>
                  <td width=21%>
        		  <%if(apprsl.getLev().equals("1")){%>
        		  	&nbsp;��
        		  <%}else if(apprsl.getLev().equals("2")){%>
        		  	&nbsp;��
                  <%}else if(apprsl.getLev().equals("3")){%>
        		  	&nbsp;��
        			<% } %></td>
                  <td class='title' width=14%>������</td>
                  <td width=49%>&nbsp;<%=AddUtil.ChangeDate2(apprsl.getApprsl_dt())%></td>
                </tr>
                <tr> 
                  <td class='title'>�򰡿���</td>
                  <td colspan="3">&nbsp;<%=apprsl.getReason()%></td>
                </tr>
                <tr> 
                  <td class='title'>��������</td>
                  <td colspan="3">&nbsp;<%=apprsl.getCar_st()%>
                  </td>
                </tr>
                <tr> 
                  <td class='title'>�������</td>
                  <td>
        		  <%if(apprsl.getSago_yn().equals("Y")){%>
        		  	&nbsp;��
        		  <%}else if(apprsl.getSago_yn().equals("N")){%>
        			&nbsp;��
        		  <%}%></td>
                  <td class="title">LPG����</td>
                  <td>
        		  <%if(apprsl.getLpg_yn().equals("1")){%>
        		  &nbsp;��
        		  <%}else if(apprsl.getLpg_yn().equals("0")){%>
        		  &nbsp;��
        		  <%}else if(apprsl.getLpg_yn().equals("2")){%>
        		  &nbsp;Ż��
        		  <% } %></td>
                </tr>
                <tr> 
                  <td class='title'>������������Ÿ�</td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(apprsl.getKm())%> KM</td>
                  <td class='title'>��ǰ�����</td>
                  <td>
        		  &nbsp;<%for(int i=0; i<actns.size(); i++){
        					Hashtable ht = (Hashtable)actns.elementAt(i);
                      		if(ht.get("CLIENT_ID").equals(apprsl.getActn_id())){%>
        						<%=ht.get("FIRM_NM")%>
        					<%}
        				}%>
                    <%//<a href='javascript:add_actn();' onMouseOver="window.status=''; return true"> 
                      //<img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="�߰�"></a> 
                    %>
                  </td>
                </tr>
                <tr> 
                  <td class='title'>�������</td>
                  <td colspan="3">&nbsp;<%=apprsl.getDamdang()%></td>
                </tr>
                <tr> 
                  <td class='title'>������������ȣ</td>
                  <td><%if(detail.getCar_pre_no().equals("")){%>
                    &nbsp;���� 
                    <%}else{%>
                    &nbsp;<%=detail.getCar_pre_no()%>
                    <%}%>
                  </td>
                  <td class="title">������ȣ������</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(detail.getCha_dt())%></td>
                </tr>
                <tr> 
                  <td class='title'>�����</td>
                  <td>&nbsp;<%if(login.getAcarName(apprsl.getDamdang_id()).equals("error")){%>
                    &nbsp; 
                    <%}else{%>
                    <%=login.getAcarName(apprsl.getDamdang_id())%> 
                    <%}%></td>
                  <td class="title">����������</td>
                  <td>&nbsp;<%if(login.getAcarName(apprsl.getModify_id()).equals("error")){%>
                    &nbsp; 
                    <%}else{%>
                    <%=login.getAcarName(apprsl.getModify_id())%> 
                    <%}%>
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
