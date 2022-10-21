<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//���뺯��
	EstiDatabase e_db = EstiDatabase.getInstance();
	bean = e_db.getEstiCommVarCase(gubun1, gubun2, gubun3);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function update(){
		var fm = document.form1;
		fm.target='d_content';
		fm.submit();
	}
	

//-->
</script>
</head>
<body>
<form name="form1" method="post" action="esti_comm_var_i.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="a_a" value="<%=bean.getA_a()%>">          
  <input type="hidden" name="seq" value="<%=bean.getSeq()%>">          
  <input type="hidden" name="cmd" value="">
</form>  
<table border=0 cellspacing=0 cellpadding=0 width=100%>    
    <tr> 
        <td><span class=style2>1. <a href="javascript:update()">�ٽɺ���</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
        <td align="right"><img src=/acar/images/center/arrow.gif align=absmiddle> <span class="style1">�������� : <%=AddUtil.ChangeDate2(bean.getA_j())%></span>&nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="150">������ȣ</td>
                    <td class=title width="150">�����ڵ�</td>
                    <td class=title colspan="2">������</td>
                    <td class=title width="200">������</td>
                </tr>
                <tr> 
                    <td align="center">F</td>
                    <td align="center">a_f</td>
                    <td colspan="2">&nbsp;����������</td>
                    <td align="right" ><%=bean.getA_f()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 20080901 �̻��  -->
                <!-- 
                <tr> 
                    <td align="center" rowspan="7" width="95">G</td>
                    <td align="center">a_g_7</td>
                    <td rowspan="7" width="396">&nbsp;10������ ���Һα�</td>
                    <td align="center">48����</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_7())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">a_g_5</td>
                    <td align="center">42����</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_5())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >a_g_1</td>
                    <td align="center">36����</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_1())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">a_g_6</td>
                    <td align="center">30����</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_6())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >a_g_2</td>
                    <td align="center">24����</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_2())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >a_g_3</td>
                    <td align="center">18����</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_3())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >a_g_4</td>
                    <td align="center">12����</td>
                    <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_4())%>��&nbsp;&nbsp;</td>
                </tr>
                -->
                <tr> 
                    <td align="center" >��</td>
                    <td align="center" >o_12</td>
                    <td colspan="2">&nbsp;Ư�Ҽ� ȯ����(12������)</td>
                    <td align="right" ><%=bean.getO_12()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >(3)</td>
                    <td align="center" >g_3</td>
                    <td colspan="2">&nbsp;���պ����� ������(������� ���)</td>
                    <td align="right" ><%=bean.getG_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >(5)</td>
                    <td align="center" >g_5</td>
                    <td colspan="2">&nbsp;���������� ������(�Ϲݹ��κ������)</td>
                    <td align="right" ><%=bean.getG_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- �̻��
                <tr> 
                    <td align="center">�߰���</td>
                    <td align="center">oa_b</td>
                    <td colspan="2">&nbsp;�빰, �ڼ� ���� 1�� ���Խ� �뿩�� �λ��</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getOa_b())%>��&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                    <td align="center">�߰���</td>
                    <td align="center">oa_c</td>
                    <td colspan="2">&nbsp;��21���̻� �������� ���Խ� �뿩�� �λ�1(�������)</td>
                    <td align="right"><%=bean.getOa_c()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >(8)</td>
                    <td align="center" >g_8</td>
                    <td colspan="2">&nbsp;�⺻�� �⺻��������</td>
                    <td align="right" ><%=bean.getG_8()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" rowspan="7" width="95">(9)</td>
                    <td align="center">g_9_7</td>
                    <td rowspan="7" width="500">&nbsp;�⺻�� ��ǥ����(���� ���)</td>
                    <td align="center">48����</td>
                    <td align="right"><%=bean.getG_9_7()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_9_6</td>
                    <td align="center">42����</td>
                    <td align="right" ><%=bean.getG_9_6()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_9_5</td>
                    <td align="center">36����</td>
                    <td align="right" ><%=bean.getG_9_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_9_4</td>
                    <td align="center">30����</td>
                    <td align="right" ><%=bean.getG_9_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_9_3</td>
                    <td align="center"> 24����</td>
                    <td align="right" ><%=bean.getG_9_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">g_9_2</td>
                    <td align="center">18����</td>
                    <td align="right"><%=bean.getG_9_2()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                    <td align="center" >(9)</td>
                    <td align="center">g_9_1</td>
                    <td colspan="2">&nbsp;�⺻�� ��ǥ����(���� ���)</td>
                    <td align="right"><%=bean.getG_9_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >(10)</td>
                    <td align="center" >g_10</td>
                    <td colspan="2">&nbsp;�Ϲݽ� ���ô뿩�� �⺻���� ������</td>
                    <td align="right" ><%=bean.getG_10()%>&nbsp;&nbsp;</td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" rowspan="7">(11)</td>
                    <td align="center">g_11_7</td>
                    <td rowspan="7">&nbsp;�Ϲݽ� ��ǥ����(���� ���)</td>
                    <td align="center">48����</td>
                    <td align="right"><%=bean.getG_11_7()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_11_6</td>
                    <td align="center">42����</td>
                    <td align="right" ><%=bean.getG_11_6()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">g_11_5</td>
                    <td align="center">36����</td>
                    <td align="right" ><%=bean.getG_11_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_11_4</td>
                    <td align="center">30����</td>
                    <td align="right" ><%=bean.getG_11_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">g_11_3</td>
                    <td align="center">24����</td>
                    <td align="right"><%=bean.getG_11_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">g_11_2</td>
                    <td align="center">18����</td>
                    <td align="right"><%=bean.getG_11_2()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                 <tr>
                    <td align="center">(11)</td>
                    <td align="center" >g_11_1</td>
                    <td colspan="2">&nbsp;�Ϲݽ� ��ǥ����(���� ���)</td>
                    <td align="right" ><%=bean.getG_11_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- �̻��
                <tr> 
                    <td align="center">��Ÿ</td>
                    <td align="center">ax_n</td>
                    <td colspan="2">&nbsp;ī����� ������Ʈ��</td>
                    <td align="right"><%=bean.getAx_n()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">��Ÿ</td>
                    <td align="center">ax_n_c</td>
                    <td colspan="2">&nbsp;ī������ݾ���</td>
                    <td align="right"><%=bean.getAx_n_c()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">��Ÿ</td>
                    <td align="center">ax_p</td>
                    <td colspan="2">&nbsp;����ݻ������ �̿�Ⱓ</td>
                    <td align="right"><%=bean.getAx_p()%>����&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                    <td align="center">��Ÿ</td>
                    <td align="center">ax_q</td>
                    <td colspan="2">&nbsp;��������ѱݾ�-�Ϲݽ� �߰���������</td>
                    <td align="right"><%=bean.getAx_q()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- �̻��
                <tr> 
                    <td align="center">��Ÿ</td>
                    <td align="center">ax_r_1</td>
                    <td colspan="2">&nbsp;����Ÿ� �����Ѱ��� ���� ����-��������Ÿ���</td>
                    <td align="right"><%=bean.getAx_r_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">��Ÿ</td>
                    <td align="center">ax_r_2</td>
                    <td colspan="2">&nbsp;����Ÿ� ���������� ���� ����-��������Ÿ���</td>
                    <td align="right"><%=bean.getAx_r_2()%>%&nbsp;&nbsp;</td>
                </tr>
                -->
				
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td colspan="2"><span class=style2>2. <a href="javascript:update()">��Ÿ����</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">������ȣ</td>
                  <td class=title width="150">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="200">������</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="7">��</td>
                  <td align="center">o_8_1</td>
                  <td rowspan="7" width="150">&nbsp;ä��������</td>
                  <td align="center">����</td>
                  <td align="right"><%=bean.getO_8_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_2</td>
                  <td align="center">���</td>
                  <td align="right"><%=bean.getO_8_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_3</td>
                  <td align="center">�λ�</td>
                  <td align="right"><%=bean.getO_8_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_4</td>
                  <td align="center">�泲</td>
                  <td align="right"><%=bean.getO_8_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_5</td>
                  <td align="center">����</td>
                  <td align="right"><%=bean.getO_8_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_7</td>
                  <td align="center">��õ</td>
                  <td align="right"><%=bean.getO_8_7()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_8</td>
                  <td align="center">����/�뱸</td>
                  <td align="right"><%=bean.getO_8_8()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="7">��</td>
                  <td align="center">o_9_1</td>
                  <td rowspan="7">&nbsp;��Ϻδ���</td>
                  <td  align="center">����</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_1())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_2</td>
                  <td align="center">���</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_2())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_3</td>
                  <td align="center">�λ�</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_3())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_4</td>
                  <td align="center">�泲</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_4())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_5</td>
                  <td align="center">����</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_5())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_7</td>
                  <td align="center">��õ</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_7())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_8</td>
                  <td align="center">����/�뱸</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_8())%>��&nbsp;&nbsp;</td>
                </tr>
                <!-- �̻�� 
                <tr> 
                  <td align="center">��</td>
                  <td align="center">o_10</td>
                  <td colspan="2">&nbsp;���ް���� ������</td>
                  <td align="right"><%=bean.getO_10()%>%&nbsp;&nbsp;</td>
                </tr>
                 
                <tr> 
                  <td align="center">��</td>
                  <td align="center">o_e</td>
                  <td colspan="2">&nbsp;������������ �⸻����</td>
                  <td align="right"><%=AddUtil.ChangeDate2(bean.getO_e())%>&nbsp;&nbsp;</td>
                </tr>
                -->
                <tr> 
                  <td align="center">(1)</td>
                  <td align="center">g_1</td>
                  <td colspan="2">&nbsp;������ ������</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getG_1())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">�߰���</td>
                  <td align="center">oa_f</td>
                  <td colspan="2">&nbsp;�������谡�Ա� ������-�Ϲݽ�</td>
                  <td align="right"><%=bean.getOa_f()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- �̻��
                <tr> 
                  <td align="center">�߰���</td>
                  <td align="center">oa_h</td>
                  <td colspan="2">&nbsp;�������谡�Ա� ������-�⺻��</td>
                  <td align="right"><%=bean.getOa_h()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                  <td align="center">�߰���</td>
                  <td align="center">oa_g</td>
                  <td colspan="2">&nbsp;��������� ������</td>
                  <td align="right"><%=bean.getOa_g()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="2">M</td>
                  <td align="center">a_m_1</td>
                  <td colspan="2">&nbsp;���� �߰��� �������</td>
                  <td align="right"><%=bean.getA_m_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">a_m_2</td>
                  <td colspan="2">&nbsp;36������ ���� �߰��� ������� �ݿ���</td>
                  <td align="right"><%=bean.getA_m_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="2">M</td>
                  <td align="center">sh_a_m_1</td>
                  <td colspan="2">&nbsp;(�縮��)���� �߰��� �������</td>
                  <td align="right"><%=bean.getSh_a_m_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">sh_a_m_2</td>
                  <td colspan="2">&nbsp;(�縮��)36������ ���� �߰��� ������� �ݿ���</td>
                  <td align="right"><%=bean.getSh_a_m_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- �̻��                
                <tr> 
				  <td align="center">i</td>
                  <td align="center">bc_s_i</td>
                  <td colspan="2">&nbsp;CASH BACK��</td>
                  <td align="right"><%=bean.getBc_s_i()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <!-- �̻��
                <tr> 
                  <td align="center">-</td>
                  <td align="center">-</td>
                  <td colspan="2">&nbsp;���뿩���� �̿� �ֿ� ����</td>
                  <td align="right"><span title='<%=bean.getCompanys()%>'><%=Util.subData(bean.getCompanys(), 6)%></span></td>
                </tr>
                <tr> 
                  <td align="center">-</td>
                  <td align="center">-</td>
                  <td colspan="2">&nbsp;�̿빮�� �����</td>
                  <td align="right"><%=bean.getQuiry_nm()%></td>
                </tr>
                <tr> 
                  <td align="center">-</td>
                  <td align="center">-</td>
                  <td colspan="2">&nbsp;�̿빮�� ����ó</td>
                  <td align="right"><%=bean.getQuiry_tel()%></td>
                </tr>
                 -->
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_1</td>
                	<td colspan="2">&nbsp;������Ż������</td>
                	<td align="right"><%=bean.getA_y_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_2</td>
                	<td colspan="2">&nbsp;������Ż�����</td>
                	<td align="right"><%=bean.getA_y_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_3</td>
                	<td colspan="2">&nbsp;�������������</td>
                	<td align="right"><%=bean.getA_y_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_4</td>
                	<td colspan="2">&nbsp;������������</td>
                	<td align="right"><%=bean.getA_y_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_5</td>
                	<td colspan="2">&nbsp;����������</td>
                	<td align="right"><%=bean.getA_y_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_6</td>
                	<td colspan="2">&nbsp;���ΰ�(Ʈ���Ϸ���)</td>
                	<td align="right"><%=bean.getA_y_6()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_f_2</td>
                	<td colspan="2">&nbsp;�ʱⳳ�Ա� ���� ������</td>
                	<td align="right"><%=bean.getA_f_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_f_3</td>
                	<td colspan="2">&nbsp;�߰��� ������ġ ȯ�� ������</td>
                	<td align="right"><%=bean.getA_f_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_extra</td>
                	<td colspan="2">&nbsp;���ﺸ������ �Ƹ���ī ����������</td>
                	<td align="right"><%=bean.getOa_extra()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_1</td>
                	<td colspan="2">&nbsp;���ﺸ������ �ſ�1��� �������</td>
                	<td align="right"><%=bean.getOa_g_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_2</td>
                	<td colspan="2">&nbsp;���ﺸ������ �ſ�2��� �������</td>
                	<td align="right"><%=bean.getOa_g_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_3</td>
                	<td colspan="2">&nbsp;���ﺸ������ �ſ�3��� �������</td>
                	<td align="right"><%=bean.getOa_g_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_4</td>
                	<td colspan="2">&nbsp;���ﺸ������ �ſ�4��� �������</td>
                	<td align="right"><%=bean.getOa_g_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_5</td>
                	<td colspan="2">&nbsp;���ﺸ������ �ſ�5��� �������</td>
                	<td align="right"><%=bean.getOa_g_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_6</td>
                	<td colspan="2">&nbsp;���ﺸ������ �ſ�6��� �������</td>
                	<td align="right"><%=bean.getOa_g_6()%>%&nbsp;&nbsp;</td>
                </tr>                                
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_7</td>
                	<td colspan="2">&nbsp;���ﺸ������ �ſ�7��� �������</td>
                	<td align="right"><%=bean.getOa_g_7()%>%&nbsp;&nbsp;</td>
                </tr>                                
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
                <!-- 20080901 �̻��  -->
                <!--     
    <tr>
        <td colspan="2"><span class=style2>3. <a href="javascript:update()">�췮��� ����</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="95">������ȣ</td>
                  <td class=title width="99">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="97">������</td>
                </tr>
                <tr> 
                  <td align="center" width="95">F</td>
                  <td align="center" width="99">a_f_w</td>
                  <td colspan="2">&nbsp;����������</td>
                  <td align="right" width="97"><%=bean.getA_f_w()%>%&nbsp;&nbsp;</td>
                </tr>

                <tr> 
                  <td align="center" rowspan="7" width="95">G</td>
                  <td align="center">a_g_7_w</td>
                  <td rowspan="7" width="500">&nbsp;10������ ���Һα�</td>
                  <td align="center">48����</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_7_w())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">a_g_6_w</td>
                  <td align="center">42����</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_6_w())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_5_w</td>
                  <td align="center">36����</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_5_w())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">a_g_4_w</td>
                  <td align="center">30����</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_4_w())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_3_w</td>
                  <td align="center">24����</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getA_g_3_w())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_2_w</td>
                  <td align="center">18����</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_2_w())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_1_w</td>
                  <td align="center">12����</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_1_w())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(9) </td>
                  <td align="center" width="99">g_9_11_w</td>
                  <td colspan="2">&nbsp;�⺻�� ��ǥ����(���� ���)</td>
                  <td align="right" width="97"><%=bean.getG_9_11_w()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td align="center">(11)</td>
                  <td align="center">g_11_w</td>
                  <td colspan="2">&nbsp;�Ϲݽ� ��ǥ����(���� ���)</td>
                  <td align="right"><%=bean.getG_11_w()%>%&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr>
        <td></td>
    </tr> 
                -->
                <!-- 20080901 �̻��  -->
                <!--
    
    <tr>
        <td colspan="2"><span class=style2>4. <a href="javascript:update()">�ʿ췮��� ����</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="95">������ȣ</td>
                  <td class=title width="99">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="97">������</td>
                </tr>
                <tr> 
                  <td align="center" width="95">F</td>
                  <td align="center" width="99">a_f_uw</td>
                  <td colspan="2">&nbsp;����������</td>
                  <td align="right" width="97"><%=bean.getA_f_uw()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="7" width="95">G</td>
                  <td align="center">a_g_7_uw</td>
                  <td rowspan="7" width="500">&nbsp;10������ ���Һα�</td>
                  <td align="center">48����</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_7_uw())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_6_uw</td>
                  <td align="center">42����</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_6_uw())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_5_uw</td>
                  <td align="center">36����</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getA_g_5_uw())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">a_g_4_uw</td>
                  <td align="center">30����</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_4_uw())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_3_uw</td>
                  <td align="center">24����</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_3_uw())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_2_uw</td>
                  <td align="center">18����</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_2_uw())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_1_uw</td>
                  <td align="center">12����</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_1_uw())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(9)</td>
                  <td align="center">g_9_11_uw</td>
                  <td colspan="2">&nbsp;�⺻�� ��ǥ����(���� ���)</td>
                  <td align="right" ><%=bean.getG_9_11_uw()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td align="center"> (11)</td>
                  <td align="center">g_11_uw</td>
                  <td colspan="2">&nbsp;�Ϲݽ� ��ǥ����(���� ���)</td>
                  <td align="right"><%=bean.getG_11_uw()%>%&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td></td>
    </tr>
                -->
    
    <tr>
        <td colspan="2"><span class=style2>5. <a href="javascript:update()">�ܰ����뺯��</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">������ȣ</td>
                  <td class=title width="150">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="200">������</td>
                </tr>
                <tr> 
                  <td align="center">(1)</td>
                  <td align="center">jg_c_1</td>
                  <td colspan="2">&nbsp;0���������ܰ�</td>
                  <td align="right"><%=bean.getJg_c_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(2)</td>
                  <td align="center">jg_c_2</td>
                  <td colspan="2">&nbsp;����24���� �ܰ��� 2�Ⱓ ������</td>
                  <td align="right"><%=bean.getJg_c_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(3)</td>
                  <td align="center">jg_c_3</td>
                  <td colspan="2">&nbsp;������Ͽ��� ���� 12������ �ܰ��� ������</td>
                  <td align="right"><%=bean.getJg_c_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(3)2</td>
                  <td align="center">jg_c_32</td>
                  <td colspan="2">&nbsp;�縮�� ��Ͽ��� ���� 12������ �ܰ��� ������</td>
                  <td align="right"><%=bean.getJg_c_32()%>%&nbsp;&nbsp;</td>
                </tr>				
                <tr> 
                  <td align="center">(4)</td>
                  <td align="center">jg_c_4</td>
                  <td colspan="2">&nbsp;LPG����� �ܰ��� ���� ������</td>
                  <td align="right"><%=bean.getJg_c_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(5)</td>
                  <td align="center">jg_c_5</td>
                  <td colspan="2">&nbsp;LPG����� �ܰ��� 1�⵿ ������</td>
                  <td align="right"><%=bean.getJg_c_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(6)</td>
                  <td align="center">jg_c_6</td>
                  <td colspan="2">&nbsp;3�� �ʰ������� �ܰ��� 1�⵿ ������</td>
                  <td align="right"><%=bean.getJg_c_6()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(7)1</td>
                  <td align="center">jg_c_71</td>
                  <td colspan="2">&nbsp;3�� ǥ������Ÿ�(km)-���ָ�����</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getJg_c_71())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(7)2</td>
                  <td align="center">jg_c_72</td>
                  <td colspan="2">&nbsp;3�� ǥ������Ÿ�(km)-��������</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getJg_c_72())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(7)3</td>
                  <td align="center">jg_c_73</td>
                  <td colspan="2">&nbsp;3�� ǥ������Ÿ�(km)-LPG����(������)</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getJg_c_73())%>��&nbsp;&nbsp;</td>
                </tr>
                <!-- 
                <tr> 
                  <td align="center" width="95">(8)1</td>
                  <td align="center" width="99">jg_c_81</td>
                  <td colspan="2">&nbsp;ǥ������Ÿ� �ʰ� 10,000km�� �߰����� ������ (���ָ�,LPG)</td>
                  <td align="right" width="97"><%=bean.getJg_c_81()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">(8)2</td>
                  <td align="center" width="99">jg_c_82</td>
                  <td colspan="2">&nbsp;ǥ������Ÿ� �ʰ� 10,000km�� �߰����� ������ (����)</td>
                  <td align="right" width="97"><%=bean.getJg_c_82()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                  <td align="center">(9)</td>
                  <td align="center">jg_c_9</td>
                  <td colspan="2">&nbsp;24���� �ð������ ���� �߰����� �϶���</td>
                  <td align="right"><%=bean.getJg_c_9()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >(10)</td>
                  <td align="center">jg_c_10</td>
                  <td colspan="2">&nbsp;LPG�������� 24���� �ð������ ���� �߰����� �϶���</td>
                  <td align="right"><%=bean.getJg_c_10()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(11)</td>
                  <td align="center">jg_c_11</td>
                  <td colspan="2">&nbsp;24���� �ð������ ���� �߰��� ����Ʈ ������</td>
                  <td align="right"><%=bean.getJg_c_11()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- �̻��
                <tr> 
                  <td align="center" width="95">(a)</td>
                  <td align="center" width="99">jg_c_a</td>
                  <td colspan="2">&nbsp;�����л�LPGŰƮ����/Ż�����(���ް�)</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getJg_c_a())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">(b)</td>
                  <td align="center" width="99">jg_c_b</td>
                  <td colspan="2">&nbsp;�����л�LPGŰƮ����/Ż�����(���ް�)</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getJg_c_b())%>��&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                  <td align="center">(c)</td>
                  <td align="center">jg_c_c</td>
                  <td colspan="2">&nbsp;�ִ��ܰ���� �����ܰ��� 1% ���̴� D/C��</td>
                  <td align="right" ><%=bean.getJg_c_c()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(d)</td>
                  <td align="center">jg_c_d</td>
                  <td colspan="2">&nbsp;�����ܰ��� ������ ���� �ִ� D/C��</td>
                  <td align="right"><%=bean.getJg_c_d()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >(12)</td>
                  <td align="center" >jg_c_12</td>
                  <td colspan="2">&nbsp;������ DC�� �ܰ����� ȿ��</td>
                  <td align="right" ><%=bean.getJg_c_12()%>%&nbsp;&nbsp;</td>
                </tr>                
            </table>
        </td>
    </tr>  
    <tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2"><span class=style2>6. <a href="javascript:update()">�縮�����뺯��</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">������ȣ</td>
                  <td class=title width="150">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="200">������</td>
                </tr>
                <tr> 
                  <td align="center">(a)</td>
                  <td align="center">sh_c_a</td>
                  <td colspan="2">&nbsp;�������� ��� ���簡ġ ���� �¼�</td>
                  <td align="right"><%=bean.getSh_c_a()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- �̻��
                <tr> 
                  <td align="center" width="95">(b)1</td>
                  <td align="center" width="99">sh_c_b1</td>
                  <td colspan="2">&nbsp;�縮�� �ʱ� ������� ������-�縮��</td>
                  <td align="right" width="97"><%=bean.getSh_c_b1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">(b)2</td>
                  <td align="center" width="99">sh_c_b2</td>
                  <td colspan="2">&nbsp;�縮�� �ʱ� ������� ������-����</td>
                  <td align="right" width="97"><%=bean.getSh_c_b2()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                  <td align="center">(d)1</td>
                  <td align="center">sh_c_d1</td>
                  <td colspan="2">&nbsp;�縮�� �ʱ� ������� ������-�縮��</td>
                  <td align="right"><%=bean.getSh_c_d1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(d)2</td>
                  <td align="center" >sh_c_d2</td>
                  <td colspan="2">&nbsp;�縮�� �ʱ� ������� ������-����</td>
                  <td align="right"><%=bean.getSh_c_d2()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- �̻��
                <tr> 
                  <td align="center" width="95">(p)1</td>
                  <td align="center" width="99">sh_p_1</td>
                  <td colspan="2">&nbsp;�߰��� �������� ���׺���</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getSh_p_1())%>��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">(p)2</td>
                  <td align="center" width="99">sh_p_2</td>
                  <td colspan="2">&nbsp;�߰��� �������� ��������</td>
                  <td align="right" width="97"><%=bean.getSh_p_2()%>%&nbsp;&nbsp;</td>
                </tr>
                 
                <tr> 
                  <td align="center" width="95">k</td>
                  <td align="center" width="99">sh_c_k</td>
                  <td colspan="2">&nbsp;�Ϲݽ¿�LPG �縮�� ���۽��� ����60���� �̻��� ��� �ܰ�������</td>
                  <td align="right" width="97"><%=bean.getSh_c_k()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">m</td>
                  <td align="center" width="99">sh_c_m</td>
                  <td colspan="2">&nbsp;�Ϲݽ¿�LPG �縮�� ������� ����60���� �̻��� ��� �ܰ�������</td>
                  <td align="right" width="97"><%=bean.getSh_c_m()%>%&nbsp;&nbsp;</td>
                </tr>
                -->
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons00~04</td>
                  <td colspan="3">&nbsp; �縮�� ������ �̵� Ź�۷� : ������� ->                   
                                   ����<%=bean.getBr_cons_00()%>��&nbsp;
                                   ����<%=bean.getBr_cons_01()%>��&nbsp;
                                   �뱸<%=bean.getBr_cons_02()%>��&nbsp;
                                   ����<%=bean.getBr_cons_03()%>��&nbsp;
                                   �λ�<%=bean.getBr_cons_04()%>��&nbsp;                                  
                  </td>
                </tr>
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons10~14</td>
                  <td colspan="3">&nbsp; �縮�� ������ �̵� Ź�۷� : ������� ->                   
                                   ����<%=bean.getBr_cons_10()%>��&nbsp;
                                   ����<%=bean.getBr_cons_11()%>��&nbsp;
                                   �뱸<%=bean.getBr_cons_12()%>��&nbsp;
                                   ����<%=bean.getBr_cons_13()%>��&nbsp;
                                   �λ�<%=bean.getBr_cons_14()%>��&nbsp;                                  
                  </td>
                </tr>
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons20~24</td>
                  <td colspan="3">&nbsp; �縮�� ������ �̵� Ź�۷� : �뱸��� ->                   
                                   ����<%=bean.getBr_cons_20()%>��&nbsp;
                                   ����<%=bean.getBr_cons_21()%>��&nbsp;
                                   �뱸<%=bean.getBr_cons_22()%>��&nbsp;
                                   ����<%=bean.getBr_cons_23()%>��&nbsp;
                                   �λ�<%=bean.getBr_cons_24()%>��&nbsp;                                  
                  </td>
                </tr>
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons30~34</td>
                  <td colspan="3">&nbsp; �縮�� ������ �̵� Ź�۷� : ������� ->                   
                                   ����<%=bean.getBr_cons_30()%>��&nbsp;
                                   ����<%=bean.getBr_cons_31()%>��&nbsp;
                                   �뱸<%=bean.getBr_cons_32()%>��&nbsp;
                                   ����<%=bean.getBr_cons_33()%>��&nbsp;
                                   �λ�<%=bean.getBr_cons_34()%>��&nbsp;                                  
                  </td>
                </tr>
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons40~44</td>
                  <td colspan="3">&nbsp; �縮�� ������ �̵� Ź�۷� : �λ���� ->                   
                                   ����<%=bean.getBr_cons_40()%>��&nbsp;
                                   ����<%=bean.getBr_cons_41()%>��&nbsp;
                                   �뱸<%=bean.getBr_cons_42()%>��&nbsp;
                                   ����<%=bean.getBr_cons_43()%>��&nbsp;
                                   �λ�<%=bean.getBr_cons_44()%>��&nbsp;                                  
                  </td>
                </tr>                                                                
            </table>
        </td>
    </tr>  
    <tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2"><span class=style2>7. <a href="javascript:update()">���������뺯��</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">������ȣ</td>
                  <td class=title width="150">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="200">������</td>
                </tr>
                <tr> 
                  <td align="center">��1</td>
                  <td align="center">k_su_1</td>
                  <td colspan="2">&nbsp;������ ���Ҽ��������� ������ ��������ġ</td>
                  <td align="right"><%=bean.getK_su_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">��3</td>
                  <td align="center">k_su_2</td>
                  <td colspan="2">&nbsp;������ ����鼼�� ����¼�</td>
                  <td align="right"><%=bean.getK_su_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">CB1</td>
                  <td align="center">a_cb_1</td>
                  <td colspan="2">&nbsp;������ ī����� cash back �ݿ�����</td>
                  <td align="right"><%=bean.getA_cb_1()%>%&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>      
    <tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2"><span class=style2>8. <a href="javascript:update()">�縮��/���� �������� �ݿ� ���뺯�� </a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">������ȣ</td>
                  <td class=title width="150">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="200">������</td>
                </tr>
                <tr> 
                  <td align="center">��� a.</td>
                  <td align="center">accid_a</td>
                  <td colspan="2">&nbsp;���� �ڽ¼�</td>
                  <td align="right"><%=bean.getAccid_a()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">��� b.</td>
                  <td align="center">accid_b</td>
                  <td colspan="2">&nbsp;���ı��� ������ �¼�</td>
                  <td align="right"><%=bean.getAccid_b()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">��� c.</td>
                  <td align="center">accid_c</td>
                  <td colspan="2">&nbsp;������ �¼�</td>
                  <td align="right" width="97"><%=bean.getAccid_c()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">��� d.</td>
                  <td align="center" width="99">accid_d</td>
                  <td colspan="2">&nbsp;2�� �������� �ݿ���</td>
                  <td align="right" width="97"><%=bean.getAccid_d()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">��� e.</td>
                  <td align="center" width="99">accid_e</td>
                  <td colspan="2">&nbsp;���ؼ�����̸� �ڽ¼�</td>
                  <td align="right" width="97"><%=bean.getAccid_e()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">��� f.</td>
                  <td align="center" width="99">accid_f</td>
                  <td colspan="2">&nbsp;���ؼ������̻� �ڽ¼�</td>
                  <td align="right" width="97"><%=bean.getAccid_f()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">��� g.</td>
                  <td align="center" width="99">accid_g</td>
                  <td colspan="2">&nbsp;���� ������</td>
                  <td align="right" width="97"><%=bean.getAccid_g()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">��� h.</td>
                  <td align="center" width="99">accid_h</td>
                  <td colspan="2">&nbsp;��������¼�</td>
                  <td align="right" width="97"><%=bean.getAccid_h()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">��� j.</td>
                  <td align="center" width="99">accid_j</td>
                  <td colspan="2">&nbsp;���ɹݿ�����</td>
                  <td align="right" width="97"><%=bean.getAccid_j()%>&nbsp;&nbsp;</td>
                </tr>      
                <tr> 
                  <td align="center" width="95">��� k.</td>
                  <td align="center" width="99">accid_k</td>
                  <td colspan="2">&nbsp;����Ÿ�����¼�</td>
                  <td align="right" width="97"><%=bean.getAccid_k()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">��� m.</td>
                  <td align="center" width="99">accid_m</td>
                  <td colspan="2">&nbsp;����Ÿ��ݿ�����</td>
                  <td align="right" width="97"><%=bean.getAccid_m()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">��� n.</td>
                  <td align="center" width="99">accid_n</td>
                  <td colspan="2">&nbsp;����,����Ÿ��ݿ� �����¼�</td>
                  <td align="right" width="97"><%=bean.getAccid_n()%>&nbsp;&nbsp;</td>
                </tr>                                              
            </table>
        </td>
    </tr>  
    <tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2"><span class=style2>9. <a href="javascript:update()">���������뺯�� </a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>       
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">������ȣ</td>
                  <td class=title width="150">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="200">������</td>
                </tr>
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">ecar_tax</td>
                  <td colspan="2">&nbsp;������/������ �ڵ�����(�Ⱓ)</td>
                  <td align="right" width="97"><%=bean.getEcar_tax()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">ecar_0_yn</td>
                  <td align="center" width="99">ecar_0_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����</td>
                  <td align="right" width="97"><%=bean.getEcar_0_yn()%>&nbsp;<%=bean.getEcar_0_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_1_yn</td>
                  <td align="center" width="99">ecar_1_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ��õ/���</td>
                  <td align="right" width="97"><%=bean.getEcar_1_yn()%>&nbsp;<%=bean.getEcar_1_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_2_yn</td>
                  <td align="center" width="99">ecar_2_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����</td>
                  <td align="right" width="97"><%=bean.getEcar_2_yn()%>&nbsp;<%=bean.getEcar_2_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_3_yn</td>
                  <td align="center" width="99">ecar_3_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����</td>
                  <td align="right" width="97"><%=bean.getEcar_3_yn()%>&nbsp;<%=bean.getEcar_3_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_4_yn</td>
                  <td align="center" width="99">ecar_4_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����</td>
                  <td align="right" width="97"><%=bean.getEcar_4_yn()%>&nbsp;<%=bean.getEcar_4_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_5_yn</td>
                  <td align="center" width="99">ecar_5_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ �뱸</td>
                  <td align="right" width="97"><%=bean.getEcar_5_yn()%>&nbsp;<%=bean.getEcar_5_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_6_yn</td>
                  <td align="center" width="99">ecar_6_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ �λ�</td>
                  <td align="right" width="97"><%=bean.getEcar_6_yn()%>&nbsp;<%=bean.getEcar_6_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_7_yn</td>
                  <td align="center" width="99">ecar_7_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����/�泲/���</td>
                  <td align="right" width="97"><%=bean.getEcar_7_yn()%>&nbsp;<%=bean.getEcar_7_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_8_yn</td>
                  <td align="center" width="99">ecar_8_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ���</td>
                  <td align="right" width="97"><%=bean.getEcar_8_yn()%>&nbsp;<%=bean.getEcar_8_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_9_yn</td>
                  <td align="center" width="99">ecar_9_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ���/�泲</td>
                  <td align="right" width="97"><%=bean.getEcar_9_yn()%>&nbsp;<%=bean.getEcar_9_amt()%>����&nbsp;</td>
                </tr>    
                <tr> 
                  <td align="center" width="95">ecar_10_yn</td>
                  <td align="center" width="99">ecar_10_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����/����(��������)</td>
                  <td align="right" width="97"><%=bean.getEcar_10_yn()%>&nbsp;<%=bean.getEcar_10_amt()%>����&nbsp;</td>
                </tr>                                                      
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">ecar_bat_cost</td>
                  <td colspan="2">&nbsp;������ �ϼ������� �������</td>
                  <td align="right" width="97"><%=bean.getEcar_bat_cost()%>��&nbsp;</td>
                </tr>                                                         
            </table>
        </td>
    </tr>      
    <tr>
        <td colspan="2"><span class=style2>10. <a href="javascript:update()">���������뺯�� </a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>       
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">������ȣ</td>
                  <td class=title width="150">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="200">������</td>
                </tr>
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_0_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����/���</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_0_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_1_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ��õ</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_1_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_2_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_2_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_3_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_3_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_4_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����/����/����</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_4_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_5_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ �뱸/���</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_5_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_6_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ �λ�/���/�泲</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_6_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_7_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ����/�泲/���(��������)</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_7_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_8_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ��Ÿ</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_8_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_9_amt</td>
                  <td colspan="2">&nbsp;������ ����ü������ ��Ÿ</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_9_amt()%>����&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_cost</td>
                  <td colspan="2">&nbsp;������ �ߵ����� ����ũ ������</td>
                  <td align="right" width="97"><%=bean.getHcar_cost()%>��&nbsp;</td>
                </tr>                                                         
            </table>
        </td>
    </tr>          
    <tr>
        <td colspan="2"><span class=style2>11. <a href="javascript:update()">���ݾ� </a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>       
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">������ȣ</td>
                  <td class=title width="150">�����ڵ�</td>
                  <td class=title colspan="2">������</td>
                  <td class=title width="200">������</td>
                </tr>
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">car_maint_amt1</td>
                  <td colspan="2">&nbsp;�ڵ�������˻������</td>
                  <td align="right" width="97">&nbsp;<%=bean.getCar_maint_amt1()%>��&nbsp;</td>
                </tr>        
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">car_maint_amt2</td>
                  <td colspan="2">&nbsp;�ڵ������հ˻������</td>
                  <td align="right" width="97">&nbsp;<%=bean.getCar_maint_amt2()%>��&nbsp;(����/������:<%=bean.getCar_maint_amt3()%>��)&nbsp;</td>
                </tr>   
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">car_maint_amt4</td>
                  <td colspan="2">&nbsp;���������п�������� (���а˻������+Ź�۷�/�ΰǺ�)</td>
                  <td align="right" width="97">&nbsp;<%=bean.getCar_maint_amt4()%>��&nbsp;</td>
                </tr>     
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_b_amt</td>
                  <td colspan="2">&nbsp;��ǰ��-���ڽ�</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_b_amt()%>��&nbsp;</td>
                </tr>        
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_s_amt</td>
                  <td colspan="2">&nbsp;��ǰ��-�������</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_s_amt()%>��&nbsp;</td>
                </tr>      
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_n_amt</td>
                  <td colspan="2">&nbsp;��ǰ��-������̼�</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_n_amt()%>��&nbsp;</td>
                </tr>      
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_eb_amt</td>
                  <td colspan="2">&nbsp;��ǰ��-�̵���������</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_eb_amt()%>��&nbsp;</td>
                </tr>      
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_bn_amt</td>
                  <td colspan="2">&nbsp;��ǰ��-���ڽ�����������</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_bn_amt()%>��&nbsp;</td>
                </tr>         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">legal_amt</td>
                  <td colspan="2">&nbsp;�������������</td>
                  <td align="right" width="97">&nbsp;<%=bean.getLegal_amt()%>��&nbsp;</td>
                </tr>                                                                                               
            </table>
        </td>
    </tr>                 
</table>
</body>
</html>