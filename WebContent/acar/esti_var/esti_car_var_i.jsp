<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String disabled = "";
	if(!seq.equals("")) disabled = "disabled";
		
	//��������
	EstiDatabase e_db = EstiDatabase.getInstance();
	bean = e_db.getEstiCarVarCase(a_e, a_a, seq);
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] sgroups = c_db.getCodeAll2("0008", "Y"); /* �ڵ� ����:�����Һз� */
	int sgroup_size = sgroups.length;		
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
		if(fm.a_e.value == ''){ alert('�Һз��� �����Ͻʽÿ�.'); return;}
		if(cmd == 'i'){
			fm.h_a_a.value = fm.a_a.value;
			fm.h_a_c.value = fm.a_c.value;
			fm.h_m_st.value = fm.m_st.value;
			fm.h_a_e.value = fm.a_e.value;									
			if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		}else if(cmd == 'up'){
			fm.h_a_a.value = fm.a_a.value;
			fm.h_a_c.value = fm.a_c.value;
			fm.h_m_st.value = fm.m_st.value;
			fm.h_a_e.value = fm.a_e.value;											
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
	
	//��з� ���ý� �ߺз� ���÷���
	function change_m(){
		var fm = document.form1;
		drop_m();
		if(fm.a_c.value == '�¿�'){ //����
			fm.m_st.options[0] = new Option('�Ϲ��� �¿�', '�Ϲ��� �¿�');
			fm.m_st.options[1] = new Option('������', '������');
			fm.m_st.options[2] = new Option('�Ϲ��� �¿� LPG', '�Ϲ��� �¿� LPG');
			fm.m_st.options[3] = new Option('5�ν� ¤', '5�ν� ¤');
			fm.m_st.options[4] = new Option('7~8�ν�', '7~8�ν�');
			fm.m_st.options[5] = new Option('9~10�ν�', '9~10�ν�');									
		}else if(fm.a_c.value == '����'){
			fm.m_st.options[0] = new Option('����', '����');
		}else if(fm.a_c.value == 'ȭ��'){
			fm.m_st.options[0] = new Option('ȭ��', 'ȭ��');
		}
		change_s();
	}	
	function drop_m(){
		var fm = document.form1;
		var len = fm.m_st.length;
		for(var i = 0 ; i < len ; i++){
			fm.m_st.options[len-(i+1)] = null;
		}
	}		
	
	//�ߺз� ���ý� �Һз� ���÷���
	function change_s(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.a_e;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.a_e";
		fm2.a_c.value = fm.a_c.value;
		fm2.m_st.value = fm.m_st.value;	
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}	
	
	function OpenList(c_st){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var user_id = fm.user_id.value;
		var br_id = fm.br_id.value;
		var SUBWIN = "../add_mark/s_code_i.jsp";
		window.open(SUBWIN+"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&c_st="+c_st, "OpenList", "left=100, top=100, width=575, height=500, scrollbars=yes");
	}		
//-->
</script>
</head>
<body>
<form action="./esti_var_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="a_c" value="">
  <input type="hidden" name="m_st" value="">  
  <input type="hidden" name="code" value="">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">  
</form>
<form name="form1" method="post" action="esti_car_var_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="seq" value="<%=seq%>">
  <input type="hidden" name="h_a_a" value="<%=a_a%>">
  <input type="hidden" name="h_a_c" value="<%=bean.getA_c()%>">            
  <input type="hidden" name="h_m_st" value="<%=bean.getM_st()%>">            
  <input type="hidden" name="h_a_e" value="<%=bean.getA_e()%>">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > ������������ > <span class=style5>���������� <%if(seq.equals("")){%>
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
            <%if(!auth_rw.equals("1")){%>
	    <%    if(seq.equals("")){%>
	    <a href="javascript:save('i');"><img src=../images/center/button_reg.gif border=0></a> 
	    <%    }else{%>
	    <a href="javascript:save('u');"><img src=../images/center/button_modify.gif border=0></a> 	  
	    <a href="javascript:save('up');"><img src=../images/center/button_upgrade.gif border=0></a> 	  	  
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
                    <td class=title>�뿩����</td>
                    <td colspan="5"> 
                      <select name="a_a" <%=disabled%>>
                        <option value="1" <%if(a_a.equals("1"))%>selected<%%>>����</option>
                        <option value="2" <%if(a_a.equals("2"))%>selected<%%>>��Ʈ</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=12%>��з�</td>
                    <td width=21%> 
                      <select name="a_c" onChange='javascript:change_m()' <%=disabled%>>
                        <option value="�¿�" <%if(bean.getA_c().equals("�¿�")||bean.getA_c().equals(""))%>selected<%%>>�¿�</option>
                        <option value="����" <%if(bean.getA_c().equals("����"))%>selected<%%>>����</option>
                        <option value="ȭ��" <%if(bean.getA_c().equals("ȭ��"))%>selected<%%>>ȭ��</option>
                      </select>
                    </td>
                    <td class=title width=12%>�ߺз�</td>
                    <td width=21%> 
                      <select name="m_st" onChange='javascript:change_s()' <%=disabled%>>
        			  <%if(bean.getA_c().equals("�¿�") || bean.getA_c().equals("")){%>
                        <option value="�Ϲ��� �¿�" <%if(bean.getM_st().equals("�Ϲ��� �¿�") || bean.getM_st().equals(""))%>selected<%%>>�Ϲ��� �¿�</option>
                        <option value="������" <%if(bean.getM_st().equals("������"))%>selected<%%>>������</option>
                        <option value="�Ϲ��� �¿� LPG" <%if(bean.getM_st().equals("�Ϲ��� �¿� LPG"))%>selected<%%>>�Ϲ��� �¿� LPG</option>
                        <option value="5�ν� ¤" <%if(bean.getM_st().equals("5�ν� ¤"))%>selected<%%>>5�ν� ¤</option>
                        <option value="7~8�ν�" <%if(bean.getM_st().equals("7~8�ν�"))%>selected<%%>>7~8�ν�</option>
                        <option value="9~10�ν�" <%if(bean.getM_st().equals("9~10�ν�"))%>selected<%%>>9~10�ν�</option>	
        			  <%}else if(bean.getA_c().equals("����")){%>	
        				<option value="����" <%if(bean.getM_st().equals("����"))%>selected<%%>>����</option>
        			  <%}else if(bean.getA_c().equals("ȭ��")){%>	
                        <option value="ȭ��" <%if(bean.getM_st().equals("ȭ��"))%>selected<%%>>ȭ��</option>
        			  <%}%>	
                      </select>
                    </td>
                    <td class=title width=12%>�Һз�</td>
                    <td width=22%> 
                      <select name="a_e" <%=disabled%>>		
                        <%if(sgroup_size > 0 && seq.equals("")){
        					for(int i = 0 ; i < 7 ; i++){
        						CodeBean sgroup = sgroups[i];%>
                        <option value='<%= sgroup.getNm_cd()%>' <%if(bean.getA_e().equals(sgroup.getNm_cd()))%>selected<%%>><%= sgroup.getNm()%></option>
                        <%	}
        				}else{
        					Vector cars = e_db.getSearchCode(bean.getA_c(), bean.getM_st());
        					int car_size = cars.size();
        					for(int i = 0 ; i < car_size ; i++){
        						Hashtable car = (Hashtable)cars.elementAt(i);%>
        				<option value='<%=car.get("NM_CD")%>' <%if(bean.getA_e().equals(String.valueOf(car.get("NM_CD"))))%>selected<%%>><%=car.get("NM")%></option>
        				<%	}%>
        				<%}%>
                      </select>&nbsp;<a href="javascript:OpenList('0008')"><img src=../images/center/button_in_sbrgl.gif border=0 align=absmiddle></a>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�з�����</td>
                    <td colspan="5"> 
                      <input type="text" name="s_sd" value='<%=bean.getS_sd()%>' size="100" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�ش�����<br>
                  (�ֿ�����)</td>
                <td colspan="5"> 
                    <textarea name="cars" cols="100" class="text" rows="2"><%=bean.getCars()%></textarea>
                </td>
                </tr>
                <tr> 
                    <td class=title>����������</td>
                    <td colspan="5"> 
                      <input type="text" name="a_j" value='<%=AddUtil.ChangeDate2(bean.getA_j())%>' size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
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
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border=0 cellspacing=1 width=100%>
                <!--
                <tr> 
                    <td class=title width=20%>�ִ��ܰ���</td>
                    <td> 48���� 
                      <input type="text" name="o_13_7" value='<%=bean.getO_13_7()%>' size="6" class=num>
                      %, 42���� 
                      <input type="text" name="o_13_6" value='<%=bean.getO_13_6()%>' size="6" class=num>
                      %, 36���� 
                      <input type="text" name="o_13_5" value='<%=bean.getO_13_5()%>' size="6" class=num>
                      %, 30���� 
                      <input type="text" name="o_13_4" value='<%=bean.getO_13_4()%>' size="6" class=num>			  
                      %, 24���� 
                      <input type="text" name="o_13_3" value='<%=bean.getO_13_3()%>' size="6" class=num>
                      %, 18���� 
                      <input type="text" name="o_13_2" value='<%=bean.getO_13_2()%>' size="6" class=num>
                      %, 12���� 
                      <input type="text" name="o_13_1" value='<%=bean.getO_13_1()%>' size="6" class=num>
                      % (VAT����) </td>
                </tr>
                 
                <tr> 
                    <td class=title>�⺻�� �Ϲݰ�����/��(����x,�ҽ�)</td>
                    <td>
                      <input type="text" name="g_6" value='<%=AddUtil.parseDecimal(bean.getG_6())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�Ϲݽ� �߰�������/��(����x,�ҽ�)</td>
                    <td> 
                      <input type="text" name="g_7" value='<%=AddUtil.parseDecimal(bean.getG_7())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>������� ������</td>
                    <td> 
                      <input type="text" name="o_11" value='<%=bean.getO_11()%>' size="10" class=num>
                      %</td>
                </tr>
                 -->
                <tr> 
                    <td class=title>���� �Ƹ���ī ���պ����</td>
                    <td> 
                      <input type="text" name="g_2" value='<%=AddUtil.parseDecimal(bean.getG_2())%>' size="10" class=num>
                      �� (�������ݿø�)</td>
                </tr>
                <tr> 
                    <td class=title>�ż����� ���������� �����������</td>
                    <td> 
                      <input type="text" name="g_4" value='<%=bean.getG_4()%>' size="10" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>��21���̻� �������� ���Խ�<br>�뿩�� �λ�2</td>
                    <td> 
                      <input type="text" name="oa_d" value='<%=AddUtil.parseDecimal(bean.getOa_d())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      (�ݾ�)</td>
                </tr>
                <!-- 
                <tr> 
                    <td class=title>Ź�۷�</td>
                    <td> 
                      <input type="text" name="o_4" value='<%=AddUtil.parseDecimal(bean.getO_4())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>                
                <tr> 
                    <td class=title>LPGŰƮ ������</td>
                    <td> 48���� 
                      <input type="text" name="oa_e_7" value='<%=AddUtil.parseDecimal(bean.getOa_e_7())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 42���� 
                      <input type="text" name="oa_e_6" value='<%=AddUtil.parseDecimal(bean.getOa_e_6())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 36���� 
                      <input type="text" name="oa_e_5" value='<%=AddUtil.parseDecimal(bean.getOa_e_5())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 30���� 
                      <input type="text" name="oa_e_4" value='<%=AddUtil.parseDecimal(bean.getOa_e_4())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 24���� 
                      <input type="text" name="oa_e_3" value='<%=AddUtil.parseDecimal(bean.getOa_e_3())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 18���� 
                      <input type="text" name="oa_e_2" value='<%=AddUtil.parseDecimal(bean.getOa_e_2())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 12���� 
                      <input type="text" name="oa_e_1" value='<%=AddUtil.parseDecimal(bean.getOa_e_1())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
                -->
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
            <!-- 
                <tr> 
                    <td class=title width=20%>Ư�Ҽ���</td>
                    <td> 
                      <input type="text" name="o_2" value='<%=bean.getO_2()%>' size="10" class=num>
                      % (�ֹμ�����)</td>
                </tr>                 
                <tr> 
                    <td class=title>��漼��</td>
                    <td> 
                      <input type="text" name="s_f" value='<%=bean.getS_f()%>' size="10" class=num>
                      %</td>
                </tr>
                -->
                <tr> 
                    <td class=title>��ϼ���</td>
                    <td> 
                      <input type="text" name="o_5" value='<%=bean.getO_5()%>' size="10" class=num>
                      %</td>
                </tr>
                <!-- 
                <tr> 
                    <td class=title>����ǥ�ؾ� ���� ä�Ǹ�����<br>
                      �� ���� ä�Ǹ��Ծ�</td>
                    <td> ���� 
                      <input type="text" name="o_6" value='<%=AddUtil.parseDecimal(bean.getO_6())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , ��� 
                      <input type="text" name="o_7" value='<%=AddUtil.parseDecimal(bean.getO_7())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
                 -->
                <tr> 
                    <td class=title rowspan="3">�ڵ�����/��</td>
                    <td> 7~9�ν����� : cc�� 
                      <input type="text" name="o_14" value='<%=AddUtil.parseDecimal(bean.getO_14())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , ������ 
                      <input type="text" name="o_15" value='<%=AddUtil.parseDecimal(bean.getO_15())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
                <!-- 
                <tr> 
                    <td> 7~9�ν� 2004�� : cc�� 
                      <input type="text" name="o_a" value='<%=AddUtil.parseDecimal(bean.getO_a())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , ������ 
                      <input type="text" name="o_b" value='<%=AddUtil.parseDecimal(bean.getO_b())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td> 7~9�ν� 2007�� : cc�� 
                      <input type="text" name="o_c" value='<%=AddUtil.parseDecimal(bean.getO_c())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , ������ 
                      <input type="text" name="o_d" value='<%=AddUtil.parseDecimal(bean.getO_d())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
                 -->
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>