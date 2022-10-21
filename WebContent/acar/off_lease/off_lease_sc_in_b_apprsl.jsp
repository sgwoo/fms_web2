<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_yb.*"%>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	Offls_ybBean detail = olyD.getYb_detail(car_mng_id);
	
	
	

	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//��ǰ�� ���� ��� �����ϱ� ����
	String apprsl_car_mng_id = olyD.getApprsl_Car_mng_id(car_mng_id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
function detailUpd(ioru)
{
	var fm = document.form1;	
	fm.gubun.value = ioru;
	fm.action="./off_lease_sc_in_b_apprsl_iu.jsp";
	fm.submit();
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
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǰ��</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        <%if(apprsl_car_mng_id.equals("")){%>
        <a href='javascript:detailUpd("i");' onMouseOver="window.status=''; return true"> 
        <img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        <%}else{%>
        <a href='javascript:detailUpd("u");' onMouseOver="window.status=''; return true"> 
        <img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
        <%}%>
        <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td class='title' width=16%> ��ü��</td>
                    <td width=22% align=center><%if(detail.getLev().equals("1")){%>
        		  	��
        		  <%}else if(detail.getLev().equals("2")){%>
        		  	��
                  <%}else if(detail.getLev().equals("3")){%>
        		  	��
        			<% } %></td>
                    <td class='title' width=14%>������</td>
                    <td align="center" width=18%><%=AddUtil.ChangeDate2(detail.getApprsl_dt())%></td>
                    <td class='title' width=13%>&nbsp;</td>
                    <td width=17%>&nbsp; </td>
                </tr>
                <tr> 
                    <td class='title'>�򰡿���</td>
                    <td colspan="5">&nbsp;&nbsp;<%=detail.getReason()%></td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td colspan="5">&nbsp;&nbsp;<%=detail.getCar_st()%></td>
                </tr>
                <tr> 
                    <td class='title'>�������</td>
                    <td width="180" align="center">
                      <%if(detail.getAccident_yn().equals("1")){%>
                      ���� 
                      <%}else{%>
                      ���� 
                      <%}%>
                    </td>
                    <td class='title'>�����</td>
                    <td><%if(login.getAcarName(detail.getDamdang_id()).equals("error")){%>
                    &nbsp; 
                    <%}else{%>
                    <%=login.getAcarName(detail.getDamdang_id())%> 
                    <%}%></td>
                    <td class='title'>����������</td>
                    <td align="center">&nbsp; 
                      <%if(login.getAcarName(detail.getModify_id()).equals("error")){%>
                      &nbsp; 
                      <%}else{%>
                      <%=login.getAcarName(detail.getModify_id())%> 
                      <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ݳ��� ����������</span></td>
        <td align="right">&nbsp; </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" align='left' class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=16%>������</td>
                    <td width=84%>&nbsp;&nbsp;
        			<%if(detail.getDriver().equals("1")){%>
        			�ӿ�
        			<%}else if(detail.getDriver().equals("2")){%>
        			����
        			<%}%> 
        			</td>
                </tr>
            </table>
        </td>
    </tr>
	
</table>
</form>
</body>
</html>
