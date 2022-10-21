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
	
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	//���뺯��
	EstiDatabase e_db = EstiDatabase.getInstance();
	bean = e_db.getEstiCommVarCase(a_a, seq);
	
	String em_a_j  = e_db.getVar_b_dt_Chk("em", a_a, AddUtil.getDate(4));
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function save(cmd){
		var fm = document.form1;
		if(cmd == 'i'){
			if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		}else if(cmd == 'up'){
			if(!confirm('�Է��� ����Ÿ�� ���׷��̵��մϴ�.\n\n��¥�� ���׷��̵��Ͻðڽ��ϱ�?')){	return;	}			
		}else{
			if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}		
		}
		fm.cmd.value = cmd;
		fm.target = "i_no";
		fm.submit();		
	}
	
	//��Ϻ���
	function go_list(){
		location='esti_var_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>';
	}
	

//-->
</script>
</head>
<body>
<form name="form1" method="post" action="esti_comm_var_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="seq" value="<%=seq%>">          
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > ������������ > <span class=style5>���뺯�� 
                    <%if(seq.equals("")){%>
                    ��� 
                    <%}else{%>
                    ���� 
                    <%}%></span></span>
                    </td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr> 
        <td align="right"> 
        
        <%if(!auth_rw.equals("1") && em_a_j.equals(bean.getA_j())){ //�ֱٰ͸� ����,���׷��̵� �Ҽ� �ִ�%>
        <%    if(seq.equals("")){%>
        <a href="javascript:save('i');"><img src=../images/center/button_reg.gif border=0></a> 
        <%    }else{%>
        <a href="javascript:save('u');"><img src=../images/center/button_modify.gif border=0></a> <a href="javascript:save('up');"><img src=../images/center/button_upgrade.gif border=0></a> 
        <%    }%>
        <%}%>
        <a href="javascript:go_list();"><img src=../images/center/button_list.gif border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">�뿩����</td>
                    <td > <select name="a_a">
                        <option value="1" <%if(a_a.equals("1"))%>selected<%%>>����</option>
                        <option value="2" <%if(a_a.equals("2"))%>selected<%%>>��Ʈ</option>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title width="400">����������</td>
                    <td > <input type="text" name="a_j" value='<%=AddUtil.ChangeDate2(bean.getA_j())%>' size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><span class=style2>1. �ٽɺ���</span></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=275>����������</td>
                    <td> <input type="text" name="a_f" size="15" class=num value='<%=bean.getA_f()%>'>
                      %</td>
                </tr>
                <!-- 20080901 ���� �̻��  -->
                <!-- 
                <tr> 
                    <td class=title width="400">10������ ���Һα�</td>
                    <td> 48���� 
                      <input type="text" name="a_g_7" value='<%=AddUtil.parseDecimal(bean.getA_g_7())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 42���� 
                      <input type="text" name="a_g_5" value='<%=AddUtil.parseDecimal(bean.getA_g_5())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 36���� 
                      <input type="text" name="a_g_1" value='<%=AddUtil.parseDecimal(bean.getA_g_1())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 30���� 
                      <input type="text" name="a_g_6" value='<%=AddUtil.parseDecimal(bean.getA_g_6())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, <br>24���� 
                      <input type="text" name="a_g_2" value='<%=AddUtil.parseDecimal(bean.getA_g_2())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 18���� 
                      <input type="text" name="a_g_3" value='<%=AddUtil.parseDecimal(bean.getA_g_3())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 12���� 
                      <input type="text" name="a_g_4" value='<%=AddUtil.parseDecimal(bean.getA_g_4())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
                 -->
                <tr> 
                    <td class=title width="400">Ư�Ҽ� ȯ����</td>
                    <td> <input type="text" name="o_12" value='<%=bean.getO_12()%>' size="15" class=num>
                      % (12������)</td>
                </tr>
                <tr> 
                    <td class=title width="400">���պ����� ������</td>
                    <td> <input type="text" name="g_3" value='<%=bean.getG_3()%>' size="15" class=num>
                      % (������� ���)</td>
                </tr>
                <tr> 
                    <td class=title width="400">���������� ������</td>
                    <td> <input type="text" name="g_5" value='<%=bean.getG_5()%>' size="15" class=num>
                      % (�Ϲݹ��κ������)</td>
                </tr>
                <!-- �̻�� 
                <tr> 
                    <td class=title width="400">�빰,�ڼպ��� 1�� ���Խ�<br>
                      �뿩�� �λ��</td>
                    <td> <input type="text" name="oa_b" value='<%=bean.getOa_b()%>' size="15" class=num>
                      ��</td>
                </tr>
                 -->
                <tr> 
                    <td class=title width="400">��21���̻� �������� ���Խ�<br>
                      �뿩�� �λ�1</td>
                    <td> <input type="text" name="oa_c" value='<%=bean.getOa_c()%>' size="15" class=num>
                      % (�������)</td>
                </tr>
                <tr> 
                    <td class=title width="400">�⺻�� �⺻��������</td>
                    <td> <input type="text" name="g_8" value='<%=bean.getG_8()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">�⺻�� ��ǥ����</td>
                    <td> <!-- 48���� 
                      <input type="text" name="g_9_7" value='<%=bean.getG_9_7()%>' size="6" class=num>
                      %, 42���� 
                      <input type="text" name="g_9_6" value='<%=bean.getG_9_6()%>' size="6" class=num>
                      %, 36���� 
                      <input type="text" name="g_9_5" value='<%=bean.getG_9_5()%>' size="6" class=num>
                      %, 30���� 
                      <input type="text" name="g_9_4" value='<%=bean.getG_9_4()%>' size="6" class=num>
                      %, <br>24���� 
                      <input type="text" name="g_9_3" value='<%=bean.getG_9_3()%>' size="6" class=num>
                      %, 18���� 
                      <input type="text" name="g_9_2" value='<%=bean.getG_9_2()%>' size="6" class=num>
                      %, 12����
                       --> 
                      <input type="text" name="g_9_1" value='<%=bean.getG_9_1()%>' size="6" class=num>
                      % (���� ���) </td>
                </tr>
                <tr> 
                    <td class=title width="400">�Ϲݽ� ���ô뿩�� �⺻���� ������</td>
                    <td> <input type="text" name="g_10" value='<%=bean.getG_10()%>' size="6" class=num>
                      ����</td>
                </tr>
                <tr> 
                    <td class=title width="400">�Ϲݽ� ��ǥ����</td>
                    <td> <!-- 48���� 
                      <input type="text" name="g_11_7" value='<%=bean.getG_11_7()%>' size="6" class=num>
                      %, 42���� 
                      <input type="text" name="g_11_6" value='<%=bean.getG_11_6()%>' size="6" class=num>
                      %, 36���� 
                      <input type="text" name="g_11_5" value='<%=bean.getG_11_5()%>' size="6" class=num>
                      %, 30���� 
                      <input type="text" name="g_11_4" value='<%=bean.getG_11_4()%>' size="6" class=num>
                      %, <br>24���� 
                      <input type="text" name="g_11_3" value='<%=bean.getG_11_3()%>' size="6" class=num>
                      %, 18���� 
                      <input type="text" name="g_11_2" value='<%=bean.getG_11_2()%>' size="6" class=num>
                      %, 12���� 
                      --> 
                      <input type="text" name="g_11_1" value='<%=bean.getG_11_1()%>' size="6" class=num>
                      % (���� ���) </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><span class=style2>2. ��Ÿ����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">ä��������</td>
                    <td >���� 
                      <input type="text" name="o_8_1" value='<%=bean.getO_8_1()%>' size="8" class=num>
                      %, ��� 
                      <input type="text" name="o_8_2" value='<%=bean.getO_8_2()%>' size="8" class=num>
                      %, �λ�
                      <input type="text" name="o_8_3" value='<%=bean.getO_8_3()%>' size="8" class=num>
                      %, �泲
                      <input type="text" name="o_8_4" value='<%=bean.getO_8_4()%>' size="8" class=num>
                      %, ����
                      <input type="text" name="o_8_5" value='<%=bean.getO_8_5()%>' size="8" class=num>
                      %, ��õ
                      <input type="text" name="o_8_7" value='<%=bean.getO_8_7()%>' size="8" class=num>
                      %, ����/�뱸
                      <input type="text" name="o_8_8" value='<%=bean.getO_8_8()%>' size="8" class=num>
                      % </td>
                </tr>
                <tr> 
                    <td class=title>��Ϻδ���</td>
                    <td>���� 
                      <input type="text" name="o_9_1" value='<%=AddUtil.parseDecimal(bean.getO_9_1())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, ��� 
                      <input type="text" name="o_9_2" value='<%=AddUtil.parseDecimal(bean.getO_9_2())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, �λ� 
                      <input type="text" name="o_9_3" value='<%=AddUtil.parseDecimal(bean.getO_9_3())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, �泲
                      <input type="text" name="o_9_4" value='<%=AddUtil.parseDecimal(bean.getO_9_4())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, ����
                      <input type="text" name="o_9_5" value='<%=AddUtil.parseDecimal(bean.getO_9_5())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, ��õ
                      <input type="text" name="o_9_7" value='<%=AddUtil.parseDecimal(bean.getO_9_7())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, ����/�뱸
                      <input type="text" name="o_9_8" value='<%=AddUtil.parseDecimal(bean.getO_9_8())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>���ް���� ������</td>
                    <td> <input type="text" name="o_10" value='<%=bean.getO_10()%>' size="15" class=num>
                      %</td>
                </tr>
                <!-- �̻��
                 
                <tr> 
                    <td class=title>������������ �⸻����</td>
                    <td> <input type="text" name="o_e" value='<%=AddUtil.ChangeDate2(bean.getO_e())%>' size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
                -->
                <tr> 
                    <td class=title>������ ������</td>
                    <td> <input type="text" name="g_1" value='<%=AddUtil.parseDecimal(bean.getG_1())%>' size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�������谡�Ա� ������-�Ϲݽ�</td>
                    <td> <input type="text" name="oa_f" value='<%=bean.getOa_f()%>' size="15" class=num>
                      %</td>
                </tr>
                <!--  �̻��
                <tr> 
                    <td class=title>�������谡�Ա� ������-�⺻��</td>
                    <td> <input type="text" name="oa_h" value='<%=bean.getOa_h()%>' size="15" class=num>
                      %</td>
                </tr>
                -->
                <tr> 
                    <td class=title>��������� ������</td>
                    <td> <input type="text" name="oa_g" value='<%=bean.getOa_g()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>���� �߰��� �������</td>
                    <td> <input type="text" name="a_m_1" value='<%=bean.getA_m_1()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>36������ ���� �߰��� ������� �ݿ���</td>
                    <td> <input type="text" name="a_m_2" value='<%=bean.getA_m_2()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>(�縮��)���� �߰��� �������</td>
                    <td> <input type="text" name="sh_a_m_1" value='<%=bean.getSh_a_m_1()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>(�縮��)36������ ���� �߰��� ������� �ݿ���</td>
                    <td> <input type="text" name="sh_a_m_2" value='<%=bean.getSh_a_m_2()%>' size="15" class=num>
                      %</td>
                </tr>  
                <!--       �̻��       
                <tr> 
                    <td class=title>CASH BACK��</td>
                    <td> <input type="text" name="bc_s_i" value='<%=bean.getBc_s_i()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">ī�����������Ʈ��</td>
                    <td> <input type="text" name="ax_n" value='<%=bean.getAx_n()%>' size="15" class=num>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">ī������ݾ���</td>
                    <td> <input type="text" name="ax_n_c" value='<%=bean.getAx_n_c()%>' size="15" class=num>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">����ݻ������ �̿�Ⱓ</td>
                    <td> <input type="text" name="ax_p" value='<%=bean.getAx_p()%>' size="15" class=num>
                      ����</td>
                </tr>
                 -->				
                <tr> 
                    <td class=title width="400">��������ѱݾ�-�Ϲݽ� �߰���������</td>
                    <td> <input type="text" name="ax_q" value='<%=bean.getAx_q()%>' size="15" class=num>
                      %</td>
                </tr>
                <!-- �̻��								
                <tr> 
                    <td class=title width="400">����Ÿ� �����Ѱ��� ���� ����-��������Ÿ���</td>
                    <td> <input type="text" name="ax_r_1" value='<%=bean.getAx_r_1()%>' size="15" class=num>
                      %</td>
                </tr>								
                <tr> 
                    <td class=title width="400">����Ÿ� ���������� ���� ����-��������Ÿ���</td>
                    <td> <input type="text" name="ax_r_2" value='<%=bean.getAx_r_2()%>' size="15" class=num>
                      %</td>
                </tr>
                 -->	
                <!-- 	�̻��						
                <tr> 
                    <td class=title>���뿩���� �̿� �ֿ� ����</td>
                    <td> <textarea name="companys" cols="80" class="text" rows="7"><%=bean.getCompanys()%></textarea> 
                    </td>
                </tr>                 
                <tr> 
                    <td class=title>�̿빮��</td>
                    <td> ����� 
                      <input type="text" name="quiry_nm" value='<%=bean.getQuiry_nm()%>' size="15" class=text>
                      , ����ó 
                      <input type="text" name="quiry_tel" value='<%=bean.getQuiry_tel()%>' size="15" class=text> 
                    </td>
                </tr>
                -->
                <tr>
                	<td class=title>������Ż������</td>
                	<td>
                		<input type="text" name="a_y_1" value='<%=bean.getA_y_1()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>������Ż�����</td>
                	<td>
                		<input type="text" name="a_y_2" value='<%=bean.getA_y_2()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>�������������</td>
                	<td>
                		<input type="text" name="a_y_3" value='<%=bean.getA_y_3()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>������������</td>
                	<td>
                		<input type="text" name="a_y_4" value='<%=bean.getA_y_4()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>����������</td>
                	<td>
                		<input type="text" name="a_y_5" value='<%=bean.getA_y_5()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>���ΰ�(Ʈ���Ϸ���)</td>
                	<td>
                		<input type="text" name="a_y_6" value='<%=bean.getA_y_6()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr> 
                    <td class=title>�ʱⳳ�Ա� ���� ������</td>
                    <td> <input type="text" name="a_f_2" size="15" class=num value='<%=bean.getA_f_2()%>'>
                      %</td>
                </tr>  
                <tr> 
                    <td class=title>�߰��� ������ġ ȯ�� ������</td>
                    <td> <input type="text" name="a_f_3" size="15" class=num value='<%=bean.getA_f_3()%>'>
                      %</td>
                </tr>  
                <tr> 
                    <td class=title>���ﺸ������ �Ƹ���ī ����������</td>
                    <td> <input type="text" name="oa_extra" value='<%=bean.getOa_extra()%>' size="15" class=num>
                      %</td>
                </tr>          
                <tr> 
                    <td class=title>���ﺸ������ �ſ�1��� �������</td>
                    <td> <input type="text" name="oa_g_1" value='<%=bean.getOa_g_1()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>���ﺸ������ �ſ�2��� �������</td>
                    <td> <input type="text" name="oa_g_2" value='<%=bean.getOa_g_2()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>���ﺸ������ �ſ�3��� �������</td>
                    <td> <input type="text" name="oa_g_3" value='<%=bean.getOa_g_3()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>���ﺸ������ �ſ�4��� �������</td>
                    <td> <input type="text" name="oa_g_4" value='<%=bean.getOa_g_4()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>���ﺸ������ �ſ�5��� �������</td>
                    <td> <input type="text" name="oa_g_5" value='<%=bean.getOa_g_5()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>���ﺸ������ �ſ�6��� �������</td>
                    <td> <input type="text" name="oa_g_6" value='<%=bean.getOa_g_6()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>���ﺸ������ �ſ�7��� �������</td>
                    <td> <input type="text" name="oa_g_7" value='<%=bean.getOa_g_7()%>' size="15" class=num>
                      %</td>
                </tr>                                          
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
                <!-- 20080901 ���� �̻��  -->
                <!--    
    <tr>
        <td><span class=style2>3. �췮��� ����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">����������</td>
                    <td > <input type="text" name="a_f_w" size="15" class=num value='<%=bean.getA_f_w()%>'>
                      %</td>
                </tr>

                <tr> 
                    <td class=title>10������ ���Һα�</td>
                    <td> 48���� 
                      <input type="text" name="a_g_7_w" value='<%=AddUtil.parseDecimal(bean.getA_g_7_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 42���� 
                      <input type="text" name="a_g_6_w" value='<%=AddUtil.parseDecimal(bean.getA_g_6_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 36���� 
                      <input type="text" name="a_g_5_w" value='<%=AddUtil.parseDecimal(bean.getA_g_5_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 30���� 
                      <input type="text" name="a_g_4_w" value='<%=AddUtil.parseDecimal(bean.getA_g_4_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, <br>24���� 
                      <input type="text" name="a_g_3_w" value='<%=AddUtil.parseDecimal(bean.getA_g_3_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 18���� 
                      <input type="text" name="a_g_2_w" value='<%=AddUtil.parseDecimal(bean.getA_g_2_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 12���� 
                      <input type="text" name="a_g_1_w" value='<%=AddUtil.parseDecimal(bean.getA_g_1_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�⺻�� ��ǥ����</td>
                    <td> <input type="text" name="g_9_11_w" value='<%=bean.getG_9_11_w()%>' size="6" class=num>
                      % (���� ���) </td>
                </tr>
                <tr>
                    <td class=title>�Ϲݽ� ��ǥ����</td>
                    <td><input type="text" name="g_11_w" value='<%=bean.getG_11_w()%>' size="6" class=num>
                      % (���� ���) </td>
              </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
                -->
                <!-- 20080901 ���� �̻��  -->
                <!--    
    <tr>
        <td><span class=style2>4. �ʿ췮��� ����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">����������</td>
                    <td> <input type="text" name="a_f_uw" size="15" class=num value='<%=bean.getA_f_uw()%>'>
                      %</td>
                </tr>

                <tr> 
                    <td class=title>10������ ���Һα�</td>
                    <td> 48���� 
                      <input type="text" name="a_g_7_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_7_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 42���� 
                      <input type="text" name="a_g_6_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_6_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 36���� 
                      <input type="text" name="a_g_5_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_5_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 30���� 
                      <input type="text" name="a_g_4_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_4_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, <br>24���� 
                      <input type="text" name="a_g_3_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_3_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 18���� 
                      <input type="text" name="a_g_2_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_2_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��, 12���� 
                      <input type="text" name="a_g_1_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_1_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�⺻�� ��ǥ����</td>
                    <td> <input type="text" name="g_9_11_uw" value='<%=bean.getG_9_11_uw()%>' size="6" class=num>
                    % (���� ���) </td>
                </tr>
                <tr>
                    <td class=title>�Ϲݽ� ��ǥ����</td>
                    <td> <input type="text" name="g_11_uw" value='<%=bean.getG_11_uw()%>' size="6" class=num>
                     % (���� ���) </td>
                </tr>
            </table>
        </td>
    </tr>
    -->
    
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>5. �ܰ����뺯��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">0���������ܰ�</td>
                    <td> <input type="text" name="jg_c_1" size="15" class=num value='<%=bean.getJg_c_1()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">����24���� �ܰ��� 2�Ⱓ ������</td>
                    <td> <input type="text" name="jg_c_2" size="15" class=num value='<%=bean.getJg_c_2()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">���� ��Ͽ��� ���� 12������ �ܰ��� ������</td>
                    <td> <input type="text" name="jg_c_3" size="15" class=num value='<%=bean.getJg_c_3()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">�縮������ ��Ͽ��� ���� 12������ �ܰ��� ������</td>
                    <td> <input type="text" name="jg_c_32" size="15" class=num value='<%=bean.getJg_c_32()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">LPG����� �ܰ��� ���� ������</td>
                    <td> <input type="text" name="jg_c_4" size="15" class=num value='<%=bean.getJg_c_4()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">LPG����� �ܰ��� 1�⵿ ������</td>
                    <td> <input type="text" name="jg_c_5" size="15" class=num value='<%=bean.getJg_c_5()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">3�� �ʰ������� �ܰ��� 1�⵿ ������</td>
                    <td> <input type="text" name="jg_c_6" size="15" class=num value='<%=bean.getJg_c_6()%>'>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">3�� ǥ������Ÿ�(km)-���ָ�����</td>
                    <td> <input type="text" name="jg_c_71" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_71())%>'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title width="400">3�� ǥ������Ÿ�(km)-��������</td>
                    <td> <input type="text" name="jg_c_72" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_72())%>'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title width="400">3�� ǥ������Ÿ�(km)-LPG����(������)</td>
                    <td> <input type="text" name="jg_c_73" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_73())%>'>
                      ��</td>
                </tr>
                <!-- �̻��
                <tr> 
                    <td class=title width="400">ǥ������Ÿ� �ʰ� 10,000km�� �߰����� ������ (���ָ�,LPG)</td>
                    <td> <input type="text" name="jg_c_81" size="15" class=num value='<%=bean.getJg_c_81()%>'>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">ǥ������Ÿ� �ʰ� 10,000km�� �߰����� ������ (����)</td>
                    <td> <input type="text" name="jg_c_82" size="15" class=num value='<%=bean.getJg_c_82()%>'>
                      %</td>
                </tr>
                 -->				
                <tr> 
                    <td class=title width="400">24���� �ð������ ���� �߰����� �϶���</td>
                    <td> <input type="text" name="jg_c_9" size="15" class=num value='<%=bean.getJg_c_9()%>'>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">LPG�������� 24���� �ð������ ���� �߰����� �϶���</td>
                    <td> <input type="text" name="jg_c_10" size="15" class=num value='<%=bean.getJg_c_10()%>'>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">24���� �ð������ ���� �߰��� ����Ʈ ������</td>
                    <td> <input type="text" name="jg_c_11" size="15" class=num value='<%=bean.getJg_c_11()%>'>
                      %</td>
                </tr>
                <!-- 		�̻��		
                <tr> 
                    <td class=title width="400">�����л�LPGŰƮ����/Ż�����(���ް�)</td>
                    <td> <input type="text" name="jg_c_a" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_a())%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">�����л�LPGŰƮ����/Ż�����(���ް�)</td>
                    <td> <input type="text" name="jg_c_b" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_b())%>'>
                      %</td>
                </tr>
                 -->
                <tr> 
                    <td class=title width="400">�ִ��ܰ���� �����ܰ��� 1% ���̴� D/C��</td>
                    <td> <input type="text" name="jg_c_c" size="15" class=num value='<%=bean.getJg_c_c()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">�����ܰ��� ������ ���� �ִ� D/C��</td>
                    <td> <input type="text" name="jg_c_d" size="15" class=num value='<%=bean.getJg_c_d()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">������ DC�� �ܰ����� ȿ��</td>
                    <td> <input type="text" name="jg_c_12" size="15" class=num value='<%=bean.getJg_c_12()%>'>
                      %</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>6. �縮�����뺯��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">�������� ��� ���簡ġ ���� �¼�</td>
                    <td> <input type="text" name="sh_c_a" size="15" class=num value='<%=bean.getSh_c_a()%>'>
                      %</td>
                </tr>
                <!-- �̻��
                <tr> 
                    <td class=title width="400">�縮�� �ʱ� ������� ������-�縮��</td>
                    <td> <input type="text" name="sh_c_b1" size="15" class=num value='<%=bean.getSh_c_b1()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">�縮�� �ʱ� ������� ������-����</td>
                    <td> <input type="text" name="sh_c_b2" size="15" class=num value='<%=bean.getSh_c_b2()%>'>
                      %</td>
                </tr>
                 -->
                <tr> 
                    <td class=title width="400">�縮�� �ʱ� ������� ������-�縮��</td>
                    <td> <input type="text" name="sh_c_d1" size="15" class=num value='<%=bean.getSh_c_d1()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">�縮�� �ʱ� ������� ������-����</td>
                    <td> <input type="text" name="sh_c_d2" size="15" class=num value='<%=bean.getSh_c_d2()%>'>
                      %</td>
                </tr>
                <!-- �̻�� 
                <tr> 
                    <td class=title width="400">�߰��� �������� ���׺���</td>
                    <td> <input type="text" name="sh_p_1" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getSh_p_1())%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">�߰��� �������� ��������</td>
                    <td> <input type="text" name="sh_p_2" size="15" class=num value='<%=bean.getSh_p_2()%>'>
                      %</td>
                </tr>
                 
                <tr> 
                    <td class=title width="400">�Ϲݽ¿�LPG �縮�� ���۽��� ����60���� �̻��� ��� �ܰ�������</td>
                    <td> <input type="text" name="sh_c_k" size="15" class=num value='<%=bean.getSh_c_k()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">�Ϲݽ¿�LPG �縮�� ������� ����60���� �̻��� ��� �ܰ�������</td>
                    <td> <input type="text" name="sh_c_m" size="15" class=num value='<%=bean.getSh_c_m()%>'>
                      %</td>
                </tr>
                -->
                <tr> 
                    <td class=title width="400">�縮�� ������ �̵� Ź�۷� : �������</td>
                    <td>
                         ����<input type="text" name="br_cons_00" size="10" class=num value='<%=bean.getBr_cons_00()%>'>�� 
                         ����<input type="text" name="br_cons_01" size="10" class=num value='<%=bean.getBr_cons_01()%>'>�� 
                         �뱸<input type="text" name="br_cons_02" size="10" class=num value='<%=bean.getBr_cons_02()%>'>�� 
                         ����<input type="text" name="br_cons_03" size="10" class=num value='<%=bean.getBr_cons_03()%>'>�� 
                         �λ�<input type="text" name="br_cons_04" size="10" class=num value='<%=bean.getBr_cons_04()%>'>�� 
                    </td>
                </tr>     
                <tr> 
                    <td class=title width="400">�縮�� ������ �̵� Ź�۷� : �������</td>
                    <td>
                         ����<input type="text" name="br_cons_10" size="10" class=num value='<%=bean.getBr_cons_10()%>'>�� 
                         ����<input type="text" name="br_cons_11" size="10" class=num value='<%=bean.getBr_cons_11()%>'>�� 
                         �뱸<input type="text" name="br_cons_12" size="10" class=num value='<%=bean.getBr_cons_12()%>'>�� 
                         ����<input type="text" name="br_cons_13" size="10" class=num value='<%=bean.getBr_cons_13()%>'>�� 
                         �λ�<input type="text" name="br_cons_14" size="10" class=num value='<%=bean.getBr_cons_14()%>'>�� 
                    </td>
                </tr>   
                <tr> 
                    <td class=title width="400">�縮�� ������ �̵� Ź�۷� : �뱸���</td>
                    <td>
                         ����<input type="text" name="br_cons_20" size="10" class=num value='<%=bean.getBr_cons_20()%>'>�� 
                         ����<input type="text" name="br_cons_21" size="10" class=num value='<%=bean.getBr_cons_21()%>'>�� 
                         �뱸<input type="text" name="br_cons_22" size="10" class=num value='<%=bean.getBr_cons_22()%>'>�� 
                         ����<input type="text" name="br_cons_23" size="10" class=num value='<%=bean.getBr_cons_23()%>'>�� 
                         �λ�<input type="text" name="br_cons_24" size="10" class=num value='<%=bean.getBr_cons_24()%>'>�� 
                    </td>
                </tr>   
                <tr> 
                    <td class=title width="400">�縮�� ������ �̵� Ź�۷� : �������</td>
                    <td>
                         ����<input type="text" name="br_cons_30" size="10" class=num value='<%=bean.getBr_cons_30()%>'>�� 
                         ����<input type="text" name="br_cons_31" size="10" class=num value='<%=bean.getBr_cons_31()%>'>�� 
                         �뱸<input type="text" name="br_cons_32" size="10" class=num value='<%=bean.getBr_cons_32()%>'>�� 
                         ����<input type="text" name="br_cons_33" size="10" class=num value='<%=bean.getBr_cons_33()%>'>�� 
                         �λ�<input type="text" name="br_cons_34" size="10" class=num value='<%=bean.getBr_cons_34()%>'>�� 
                    </td>
                </tr>   
                <tr> 
                    <td class=title width="400">�縮�� ������ �̵� Ź�۷� : �λ����</td>
                    <td>
                         ����<input type="text" name="br_cons_40" size="10" class=num value='<%=bean.getBr_cons_40()%>'>�� 
                         ����<input type="text" name="br_cons_41" size="10" class=num value='<%=bean.getBr_cons_41()%>'>�� 
                         �뱸<input type="text" name="br_cons_42" size="10" class=num value='<%=bean.getBr_cons_42()%>'>�� 
                         ����<input type="text" name="br_cons_43" size="10" class=num value='<%=bean.getBr_cons_43()%>'>�� 
                         �λ�<input type="text" name="br_cons_44" size="10" class=num value='<%=bean.getBr_cons_44()%>'>�� 
                    </td>
                </tr>                                                                              
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>7. ���������뺯��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">������ ���Ҽ��������� ������ ��������ġ</td>
                    <td> <input type="text" name="k_su_1" size="15" class=num value='<%=bean.getK_su_1()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����鼼�� ����¼�</td>
                    <td> <input type="text" name="k_su_2" value='<%=bean.getK_su_2()%>' size="15" class=num>
                    </td>
                </tr>
                <tr>
                    <td class=title>������ ī����� cash back �ݿ�����</td>
                    <td> <input type="text" name="a_cb_1" value='<%=bean.getA_cb_1()%>' size="15" class=num>
                    </td>
                </tr>
            </table>
        </td>
    </tr>    	
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>8. �縮��/���� �������� �ݿ� ���뺯��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">���� �ڽ¼�</td>
                    <td> <input type="text" name="accid_a" size="15" class=num value='<%=bean.getAccid_a()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">���ı��� ������ �¼�</td>
                    <td> <input type="text" name="accid_b" size="15" class=num value='<%=bean.getAccid_b()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">������ �¼�</td>
                    <td> <input type="text" name="accid_c" size="15" class=num value='<%=bean.getAccid_c()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">2�� �������� �ݿ���</td>
                    <td> <input type="text" name="accid_d" size="15" class=num value='<%=bean.getAccid_d()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">���ؼ�����̸� �ڽ¼�</td>
                    <td> <input type="text" name="accid_e" size="15" class=num value='<%=bean.getAccid_e()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">���ؼ������̻� �ڽ¼�</td>
                    <td> <input type="text" name="accid_f" size="15" class=num value='<%=bean.getAccid_f()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">���� ������</td>
                    <td> <input type="text" name="accid_g" size="15" class=num value='<%=bean.getAccid_g()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">��������¼�</td>
                    <td> <input type="text" name="accid_h" size="15" class=num value='<%=bean.getAccid_h()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">���ɹݿ�����</td>
                    <td> <input type="text" name="accid_j" size="15" class=num value='<%=bean.getAccid_j()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">����Ÿ�����¼�</td>
                    <td> <input type="text" name="accid_k" size="15" class=num value='<%=bean.getAccid_k()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">����Ÿ��ݿ�����</td>
                    <td> <input type="text" name="accid_m" size="15" class=num value='<%=bean.getAccid_m()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">����,����Ÿ��ݿ� �����¼�</td>
                    <td> <input type="text" name="accid_n" size="15" class=num value='<%=bean.getAccid_n()%>'>
                    </td>
                </tr>                                                
            </table>
        </td>
    </tr>    	
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>9. ���������뺯��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">������/������ �ڵ�����(�Ⱓ)</td>
                    <td> <input type="text" name="ecar_tax" size="15" class=num value='<%=bean.getEcar_tax()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ����</td>
                    <td> ���޿��� <input type="text" name="ecar_0_yn" value='<%=bean.getEcar_0_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_0_amt" value='<%=bean.getEcar_0_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ��õ/���</td>
                    <td> ���޿��� <input type="text" name="ecar_1_yn" value='<%=bean.getEcar_1_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_1_amt" value='<%=bean.getEcar_1_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ����</td>
                    <td> ���޿��� <input type="text" name="ecar_2_yn" value='<%=bean.getEcar_2_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_2_amt" value='<%=bean.getEcar_2_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ����</td>
                    <td> ���޿��� <input type="text" name="ecar_3_yn" value='<%=bean.getEcar_3_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_3_amt" value='<%=bean.getEcar_3_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ����</td>
                    <td> ���޿��� <input type="text" name="ecar_4_yn" value='<%=bean.getEcar_4_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_4_amt" value='<%=bean.getEcar_4_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ �뱸</td>
                    <td> ���޿��� <input type="text" name="ecar_5_yn" value='<%=bean.getEcar_5_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_5_amt" value='<%=bean.getEcar_5_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ �λ�</td>
                    <td> ���޿��� <input type="text" name="ecar_6_yn" value='<%=bean.getEcar_6_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_6_amt" value='<%=bean.getEcar_6_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ����/�泲/���</td>
                    <td> ���޿��� <input type="text" name="ecar_7_yn" value='<%=bean.getEcar_7_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_7_amt" value='<%=bean.getEcar_7_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ���</td>
                    <td> ���޿��� <input type="text" name="ecar_8_yn" value='<%=bean.getEcar_8_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_8_amt" value='<%=bean.getEcar_8_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ���/�泲</td>
                    <td> ���޿��� <input type="text" name="ecar_9_yn" value='<%=bean.getEcar_9_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_9_amt" value='<%=bean.getEcar_9_amt()%>' size="15" class=num>����
                    </td>
                </tr>      
                                                                                          <tr> 
                    <td class=title>������ ����ü������ ����/����(��������)</td>
                    <td> ���޿��� <input type="text" name="ecar_10_yn" value='<%=bean.getEcar_10_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	���ޱݾ� <input type="text" name="ecar_10_amt" value='<%=bean.getEcar_10_amt()%>' size="15" class=num>����
                    </td>
                </tr>    
                <tr> 
                    <td class=title>������ �ϼ������� �������</td>
                    <td> <input type="text" name="ecar_bat_cost" value='<%=bean.getEcar_bat_cost()%>' size="15" class=num>
                    </td>
                </tr>                                                                
            </table>
        </td>
    </tr> 
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>10. ���������뺯��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">������ ����ü������ ����/���</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_0_amt" value='<%=bean.getHcar_0_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ��õ</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_1_amt" value='<%=bean.getHcar_1_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ����</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_2_amt" value='<%=bean.getHcar_2_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ����</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_3_amt" value='<%=bean.getHcar_3_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ����/����/����</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_4_amt" value='<%=bean.getHcar_4_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ �뱸/���</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_5_amt" value='<%=bean.getHcar_5_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ �λ�/���/�泲</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_6_amt" value='<%=bean.getHcar_6_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ����/�泲/���(��������)</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_7_amt" value='<%=bean.getHcar_7_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ��Ÿ</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_8_amt" value='<%=bean.getHcar_8_amt()%>' size="15" class=num>����
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ ����ü������ ��Ÿ</td>
                    <td> ���ޱݾ� <input type="text" name="hcar_9_amt" value='<%=bean.getHcar_9_amt()%>' size="15" class=num>����
                    </td>
                </tr>                                                                
                <tr> 
                    <td class=title>������ �ߵ����� ����ũ ������</td>
                    <td> <input type="text" name="hcar_cost" value='<%=bean.getHcar_cost()%>' size="15" class=num>
                    </td>
                </tr>                                                                
            </table>
        </td>
    </tr>   
    <tr>
        <td></td>
    </tr>     
    <tr> 
        <td><span class=style2>11. ���ݾ�</span></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">�ڵ�������˻������</td>
                    <td> <input type="text" name="car_maint_amt1" value='<%=bean.getCar_maint_amt1()%>' size="15" class=num> ��</td>
                </tr>
                <tr> 
                    <td class=title width="400">�ڵ������հ˻������</td>
                    <td> <input type="text" name="car_maint_amt2" value='<%=bean.getCar_maint_amt2()%>' size="15" class=num> ��
                         (����/������ <input type="text" name="car_maint_amt3" value='<%=bean.getCar_maint_amt3()%>' size="15" class=num> ��)                    
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">���������п��������</td>
                    <td> <input type="text" name="car_maint_amt4" value='<%=bean.getCar_maint_amt4()%>' size="15" class=num> �� (���а˻������+Ź�۷�/�ΰǺ�)</td>
                </tr>
                <tr> 
                    <td class=title width="400">��ǰ��-���ڽ�</td>
                    <td> <input type="text" name="tint_b_amt" value='<%=bean.getTint_b_amt()%>' size="15" class=num> ��</td>
                </tr>
                <tr> 
                    <td class=title width="400">��ǰ��-�������</td>
                    <td> <input type="text" name="tint_s_amt" value='<%=bean.getTint_s_amt()%>' size="15" class=num> ��</td>
                </tr>
                <tr> 
                    <td class=title width="400">��ǰ��-������̼�</td>
                    <td> <input type="text" name="tint_n_amt" value='<%=bean.getTint_n_amt()%>' size="15" class=num> ��</td>
                </tr>
                <tr> 
                    <td class=title width="400">��ǰ��-�̵���������</td>
                    <td> <input type="text" name="tint_eb_amt" value='<%=bean.getTint_eb_amt()%>' size="15" class=num> ��</td>
                </tr>
                <tr> 
                    <td class=title width="400">��ǰ��-���ڽ������� ����</td>
                    <td> <input type="text" name="tint_bn_amt" value='<%=bean.getTint_bn_amt()%>' size="15" class=num> ��</td>
                </tr>          
                <tr> 
                    <td class=title width="400">�������������</td>
                    <td> <input type="text" name="legal_amt" value='<%=bean.getLegal_amt()%>' size="15" class=num> ��</td> 
                </tr>                                                                             
            </table>
        </td>
    </tr>
        	        
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>