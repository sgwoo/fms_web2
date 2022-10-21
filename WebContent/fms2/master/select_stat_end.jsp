<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.admin.*,acar.common.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('������ �۾��մϱ�? �� �� �����ϴ�.'); return;}
		
		fm.work_st.value = work_st;
		fm.target = 'i_no';
		fm.action = 'autowork_a.jsp';
		fm.submit();
	}
	
	function popup(url)
	{
		var fm = document.form1;
				
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}	
	
	function popup2(url, s_var)
	{
		var fm = document.form1;
		fm.s_var.value = s_var;		
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}
	
	function popup3()
	{
		var fm = document.form1;				
		fm.target = '_blank';
		
		if(fm.stat_st.value == 'a'){
			alert('��뷮�ڷ�� ������ ���� �������� Ȯ���Ͻʽÿ�.');		
			return;
		}else{
			
			if(fm.stat_st.value == '1') 		fm.action = 'select_stat_end_cont_list_db.jsp';
			if(fm.stat_st.value == '2') 		fm.action = 'select_stat_end_car_list_db.jsp';
			if(fm.stat_st.value == '3') 		fm.action = 'select_stat_end_bank_debt_list_db.jsp';
			if(fm.stat_st.value == '4') 		fm.action = 'select_stat_end_car_comp_db.jsp';
			if(fm.stat_st.value == '5') 		fm.action = 'select_stat_end_fee_dly_list_db.jsp';
			if(fm.stat_st.value == '6') 		fm.action = 'select_stat_end_bank_debt_list_int_db.jsp';
			if(fm.stat_st.value == '7') 		fm.action = 'select_stat_end_bank_debt_ls_list_db.jsp';
			if(fm.stat_st.value == '8') 		fm.action = 'select_stat_end_asset_db.jsp';
			if(fm.stat_st.value == '9') 		fm.action = 'select_stat_end_asset_list_db.jsp';
			if(fm.stat_st.value == '10') 		fm.action = 'select_stat_end_bank_debt_stat_db.jsp';
			if(fm.stat_st.value == '11') 		fm.action = 'select_stat_end_cont_fee_list_db.jsp';
			if(fm.stat_st.value == '12') 		fm.action = 'select_stat_end_12_list_db.jsp';
			if(fm.stat_st.value == '13') 		fm.action = 'select_stat_end_13_list_db.jsp';
			if(fm.stat_st.value == '14') 		fm.action = 'select_stat_end_14_list_db.jsp';
			if(fm.stat_st.value == '15') 		fm.action = 'select_stat_end_15_list_db.jsp';
			if(fm.stat_st.value == '16') 		fm.action = 'select_stat_end_16_list_db.jsp';
			if(fm.stat_st.value == '17') 		fm.action = 'select_stat_end_17_list_db.jsp';
			if(fm.stat_st.value == '18') 		fm.action = 'select_stat_end_18_list_db.jsp';
			if(fm.stat_st.value == '19') 		fm.action = 'select_stat_end_19_list_db.jsp';
			if(fm.stat_st.value == '20') 		fm.action = 'select_stat_end_20_list_db.jsp';
			if(fm.stat_st.value == '21') 		fm.action = 'select_stat_end_21_list_db.jsp';
			if(fm.stat_st.value == '') 			return;
								
			fm.submit();		
		}
		
	}	
		
	//����ϱ�
	function save2(ment){
		var fm = document.form1;	
		
		if(!confirm(ment+'�� �����Ͻðڽ��ϱ�?'))
			return;
				
		fm.action = 'select_stat_end_a.jsp';						
		fm.target = 'i_no';
		fm.submit();	
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//������Ȳ
	Vector deb1s = ad_db.getStatDebtList("stat_rent_month");
	int deb1_size = deb1s.size();
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
	
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_var' value=''>
<input type='hidden' name='s_unit' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>��������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� <b>DB ������ ���</b> - <a href="javascript:save2('�����Ȳ');"><img src=/acar/images/center/button_dimg.gif align=absmiddle border=0></a>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� <b>DB ������ ����</b> - 
		<select name="save_dt">
			<%	if(deb1_size > 0){
				    for(int i = 0 ; i < deb1_size ; i++){
						StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>		
			<option value="<%=sd.getSave_dt()%>">[<%=sd.getSave_dt()%>] <%=sd.getReg_dt()%></option>		
			<%		}
				}%>
		</select>
		<select name="stat_st">
			<option value="">����</option>		
			<option value="">===������===</option>
			<option value="1">�����Ȳ(�ŷ�ó��|�뿩���|���뿩��|���)</option>
			<option value="2">������Ȳ(����|������ȣ|�����|���)</option>
			<option value="4">�����纰������Ȳ</option>
			<option value="3">���Աݻ�ȯ������</option>
			<option value="6">���Աݻ�ȯ������(��������)</option>			
			<option value="5">�뿩�Ῥü��Ȳ(�ŷ�ó��|������ȣ|��ü�Ǽ�|��ü�뿩��)</option>			
			<option value="">===�ڻ�===</option>
			<option value="8">�ڻ���Ȳ</option>
			<option value="10">�����纰���Աݼ�����Ȳ</option>
			<option value="12">�űԿ��� �ߴ��ϰ� �뿩��� ��ӽ�(���簡ġ,�鸸������)</option>
			<option value="13">�űԿ��� �ߴ��ϰ� �뿩��� ��ӽ�(���簡ġ,������)</option>
			<option value="18">�뿩�Ͻ� ����� ���갡ġ(������) - ���˿�</option>
			<option value="19">�űԿ��� �ߴ��ϰ� �뿩��� ��ӽ� CASH FLOW(����,�鸸������)</option>			
			<option value="20">�űԿ��� �ߴ��ϰ� �뿩��� ��ӽ� CASH FLOW(����,������)</option>
			<option value="">===�ܺο�û===</option>
			<option value="14">��ü��Ȳ(����ȣ|������ȣ|���뿩��|��ü�뿩��|����������|�̵����뿩��|�հ�)</option>
			<option value="15">�����纰������Ȳ(�������|��������|��������|����ݾ�|��ȯ���|�Һΰ�����|�����ݸ�|�ܾ�)</option>
			<option value="11">�����Ȳ(��������|������|�뿩����)</option>
			<option value="">===��뷮-��������===</option>
			<option value="a" disabled>�������ڻ���Ȳ Excel</option><!-- 9 -->
			<option value="a" disabled>�űԿ��� �ߴ��ϰ� �뿩��� ��ӽ�(���簡ġ) ���������θ���Ʈ Excel - �ܺ������</option><!-- 16 -->
			<option value="a" disabled>�űԿ��� �ߴ��ϰ� �뿩��� ��ӽ�(���簡ġ) ���������θ���Ʈ Excel - �������˿�</option><!-- 17 -->
			<option value="a" disabled>�űԿ��� �ߴ��ϰ� �뿩��� ��ӽ� CASH FLOW(��������) Excel</option><!-- 20 -->
			<option value="a" disabled>�űԿ��� �ߴ��ϰ� �뿩��� ��ӽ� CASH FLOW(�˻�) Excel</option><!-- 21 -->
			<!--<option value="7">���������޽�����</option>-->
		</select>
		&nbsp;&nbsp;<a href="javascript:popup3()"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		
	</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>* �����Ȳ, ������Ȳ, ���Աݻ�ȯ������ �� ������ ����Ÿ�Դϴ�.</font></td>
  </tr>  
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(�ڻ� �����ʹ� �ڻ��� �Ⱓ�� �����Ͽ� �Ϳ���(1~10)�� �縶���� �˴ϴ�.)</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(�ڻ� �����ʹ� 2020��11������ ������ ����)</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. ������ - <b>�����Ȳ</b> : �������� ���������� <input type='text' size='11' name='cont_end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-"+AddUtil.getMonthDate(AddUtil.getDate2(1),AddUtil.getDate2(2))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('select_stat_end_cont_list.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		   &nbsp;&nbsp;(���� | �ŷ�ó�� | �뿩���	| ���뿩�� | ���)
		   &nbsp;&nbsp;<font color=red>* ������� �ǽð�����Ÿ�Դϴ�.</font>
		   

	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. ������ - <b>������Ȳ</b> : �������� ���������� <input type='text' size='11' name='car_end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-"+AddUtil.getMonthDate(AddUtil.getDate2(1),AddUtil.getDate2(2))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('select_stat_end_car_list.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		   &nbsp;&nbsp;(���� | ���� | ������ȣ | ����� | ���)
		   &nbsp;&nbsp;<font color=red>* ������� �ǽð�����Ÿ�Դϴ�.</font>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* SBI+SBI3+SBI4 �� , KBĳ��Ż+�츮���̳��� ��</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. ������ - <b>���Աݻ�ȯ����ǥ</b> : �������� ù���� <input type='text' size='11' name='bank_end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-01"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
		   &nbsp;&nbsp;(��ȯ | �ܾ�)
		   &nbsp;&nbsp;[����] �������� 2009-12-31 -> ��ȸ���� 2009-12-01
		   &nbsp;&nbsp;<font color=red>* ������� �ǽð�����Ÿ�Դϴ�.</font>
	</td>
  </tr>
    <tr>
	<td>
	    <table width="100%"  border="0">
                <%if(bank_size > 0){
        		for(int i = 0 ; i < bank_size ; i++){
        			CodeBean bank = banks[i];
        	%>
		<tr>
                    <td>&nbsp;</td>
                    <td width="20%"><%= bank.getNm()%></td>
                    <td width="20%"><a href="javascript:popup2('select_stat_end_bank_debt_list.jsp','<%=bank.getCode()%>')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
                    <td width="40%">&nbsp;<!--  <%if(bank.getNm().equals("�Ե����丮��")){%>�����ὺ���� <a href="javascript:popup2('select_stat_end_bank_debt_ls_list.jsp','<%=bank.getCode()%>')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><%}%>-->
                    	
                    </td>
                </tr>
                <%	}
        	}%>	
        	

    </table></td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <%if(ck_acar_id.equals("000029")){ %>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;## <a href="javascript:popup('temp_bacth_excel.jsp')">[���������� �̿��� �ϰ�ó��]</a>
	</td>
  </tr>  
  <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
