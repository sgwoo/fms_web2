<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.insur.*, acar.estimate_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//���������ȣ
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String update_yn = request.getParameter("update_yn")==null?"":request.getParameter("update_yn");
	
	String mode = "2";
	
	AccidDatabase as_db = AccidDatabase.getInstance();	
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//��������
	InsurBean ins = ai_db.getInsCase(c_id, ins_st);
	
	//���轺����
	Vector ins_cha = ai_db.getInsChanges(c_id, ins_st);
	int ins_cha_size = ins_cha.size();	
	
	int total_amt = 0;	
	
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "ins_modify_dt");
	String var2 = e_db.getEstiSikVarCase("1", "", "ins_modify_mon");
	
	if(update_yn.equals("")){
			
		String modify_deadline = c_db.addMonth(ins.getIns_exp_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) == 20220325) modify_deadline = "20220425";
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) < AddUtil.parseInt(AddUtil.getDate(4))){
			update_yn = "N";
		}
		
	}	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�����ϱ�
	function save(cmd, idx){	
		var fm = document.form1;	
		if(fm.ins_st.value == ''){ alert("����� ���� ����Ͻʽÿ�."); return; }		
		if(fm.size.value == '0'){
			fm.r_ch_tm.value = fm.ch_tm.value;
			fm.r_ch_dt.value = fm.ch_dt.value;
			fm.r_ch_item.value = fm.ch_item.value;
			fm.r_ch_before.value = fm.ch_before.value;
			fm.r_ch_after.value = fm.ch_after.value;
			fm.r_ch_amt.value = fm.ch_amt.value;
			if(fm.ch_item.value == '') fm.r_ch_item.value = fm.o_ch_item.value;
		}else{
			fm.r_ch_tm.value = fm.ch_tm[idx].value;
			fm.r_ch_dt.value = fm.ch_dt[idx].value;
			fm.r_ch_item.value = fm.ch_item[idx].value;
			fm.r_ch_before.value = fm.ch_before[idx].value;
			fm.r_ch_after.value = fm.ch_after[idx].value;
			fm.r_ch_amt.value = fm.ch_amt[idx].value;
			if(fm.ch_item[idx].value == '') fm.r_ch_item.value = fm.o_ch_item[idx].value;
		}	
		if(fm.r_ch_dt.value == ''){ alert("�輭�������� �Է��Ͻʽÿ�."); return; }
		if(fm.r_ch_item.value == ''){ alert("�����׸��� �����Ͻʽÿ�."); return; }		
		if(fm.r_ch_amt.value == ''){ alert("��¡����Ḧ �Է��Ͻʽÿ�."); return; }		
		if(!confirm('ó���Ͻðڽ��ϱ�?')){	return;	}
		fm.cmd.value = cmd;
		fm.target = "i_no";
//		fm.target = "d_content";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="ins_u_a.jsp" name="form1">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='gubun0' value='<%=gubun0%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' value='<%=gubun4%>'>
	<input type='hidden' name='gubun5' value='<%=gubun5%>'>
	<input type='hidden' name='gubun6' value='<%=gubun6%>'>
	<input type='hidden' name='gubun7' value='<%=gubun7%>'>
	<input type='hidden' name='brch_id' value='<%=brch_id%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='s_kd' value='<%=s_kd%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	<input type='hidden' name='sort' value='<%=sort%>'>
	<input type='hidden' name='asc' value='<%=asc%>'>
	<input type="hidden" name="idx" value="<%=idx%>">
	<input type="hidden" name="s_st" value="<%=s_st%>">
	<input type='hidden' name="go_url" value='<%=go_url%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='ins_st' value='<%=ins_st%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='size' value='<%=ins_cha_size%>'>	
    <input type='hidden' name='cmd' value=''>	
    <input type='hidden' name='r_ch_tm' value=''>
    <input type='hidden' name='r_ch_dt' value=''>
    <input type='hidden' name='r_ch_item' value=''>	
    <input type='hidden' name='r_ch_before' value=''>
    <input type='hidden' name='r_ch_after' value=''>
    <input type='hidden' name='r_ch_amt' value=''>	
    <input type='hidden' name='r_long_emp_yn' value=''>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���躯�����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=6% rowspan="2">����</td>
                    <td class=title width=6% rowspan="2">�����ڵ�</td>
                    <td class=title width=10% rowspan="2">�輭������</td>
                    <td class=title width=20% rowspan="2">�����׸�</td>
                    <td class=title colspan="2">�������</td>
                    <td class=title width=10% rowspan="2">��¡�����</td>
                    <td class=title width=10% rowspan="2">ó��</td>
                </tr>
                <tr> 
                    <td class=title width=19%>������</td>
                    <td class=title width=19%>������</td>
                </tr>
                <%	for(int i = 0 ; i < ins_cha_size ; i++){
				InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%> 
                      <!--<input type='hidden' name='ch_tm' value='<%=cha.getCh_tm()%>'>-->
                    </td>
                    <td><input type='text' size='2' name='ch_tm' class='whitetext' value='<%=cha.getCh_tm()%>'></td>
                    <td>
                      <input type='text' size='11' name='ch_dt' class='text' value='<%=AddUtil.ChangeDate2(cha.getCh_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td>
        	        <select name="ch_item">
        	        	      <option value="" >����</option>
            	            <option value="10" <%if(cha.getCh_item().equals("10")){%>selected<%}%>>����2���Աݾ�</option>
            	            <option value="1" <%if(cha.getCh_item().equals("1")){%>selected<%}%>>�빰���Աݾ�</option>
        	            <option value="2" <%if(cha.getCh_item().equals("2")){%>selected<%}%>>�ڱ��ü����Աݾ�(���/���)</option>
			    		<option value="12" <%if(cha.getCh_item().equals("12")){%>selected<%}%>>�ڱ��ü����Աݾ�(�λ�)</option>
        	            <option value="7" <%if(cha.getCh_item().equals("7")){%>selected<%}%>>�빰+�ڱ��ü����Աݾ�</option>			  
                	    <option value="3" <%if(cha.getCh_item().equals("3")){%>selected<%}%>>������������Ư��</option>
                	    <option value="4" <%if(cha.getCh_item().equals("4")){%>selected<%}%>>�ڱ��������ذ��Աݾ�</option>			  
                	    <option value="9" <%if(cha.getCh_item().equals("9")){%>selected<%}%>>�ڱ����������ڱ�δ��</option>			  			  			  
            	            <option value="5" <%if(cha.getCh_item().equals("5")){%>selected<%}%>>���ɺ���</option>		  
                	    <option value="6" <%if(cha.getCh_item().equals("6")){%>selected<%}%>>�ִ�īƯ��</option>			  			  
                	    <option value="8" <%if(cha.getCh_item().equals("8")){%>selected<%}%>>��������</option>			  			  			  
                	    <option value="11" <%if(cha.getCh_item().equals("11")){%>selected<%}%>>������ü</option>			                  	    
                	    <option value="14" <%if(cha.getCh_item().equals("14")){%>selected<%}%>>��������������Ư��</option>
                	    <option value="17" <%if(cha.getCh_item().equals("17")){%>selected<%}%>>���ڽ�</option>
                	    <option value="20" <%if(cha.getCh_item().equals("20")){%>selected<%}%>>���ΰ�</option>
                	    <option value="21" <%if(cha.getCh_item().equals("21")){%>selected<%}%>>�������������</option>
                	    <option value="22" <%if(cha.getCh_item().equals("22")){%>selected<%}%>>����ắ��</option>
                	    <option value="15" <%if(cha.getCh_item().equals("15")){%>selected<%}%>>�Ǻ�����</option>
                	    <option value="16" <%if(cha.getCh_item().equals("16")){%>selected<%}%>>���谻��</option>
                	    <option value="18" <%if(cha.getCh_item().equals("18")){%>selected<%}%>>����</option>
                	    <option value="19" <%if(cha.getCh_item().equals("19")){%>selected<%}%>>÷�ܻ��</option>
                	    <option value="13" <%if(cha.getCh_item().equals("13")){%>selected<%}%>>��Ÿ</option>                	    
        	        </select>			
        	           <%if(AddUtil.parseInt(cha.getCh_item()) > 0 && AddUtil.parseInt(cha.getCh_item()) < 24){ %>
        	           <%}else{%>
        	               <%=cha.getCh_item()%>
        	           <%}%>
        	           <input type='hidden' name='o_ch_item' value='<%=cha.getCh_item()%>'>
                    </td>
                    <td>
                      <input type='text' size='20' name='ch_before' class='text' value='<%=cha.getCh_before()%>'>
                    </td>
                    <td>
                      <input type='text' size='20' name='ch_after' class='text' value='<%=cha.getCh_after()%>'>
                    </td>
                    <td> 
                      <input type='text' size='10' name='ch_amt' class='num' value='<%=Util.parseDecimal(cha.getCh_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td> 
        	        <%if(!cmd.equals("view")){
        	        
        	        		String update_yn2 = "Y";
        	        		String modify_deadline2 = c_db.addMonth(cha.getCh_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;
        	        		//if(AddUtil.parseInt(AddUtil.replace(modify_deadline2,"-","")) > 20170401) modify_deadline2 = "20170630";
											if(AddUtil.parseInt(AddUtil.replace(modify_deadline2,"-","")) < AddUtil.parseInt(AddUtil.getDate(4))){
												update_yn2 = "N";
											}
        	        
        	        %>
                            <%if(!update_yn2.equals("N") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                                <a href='javascript:save("u", "<%=i%>")'><img src=../images/center/button_in_modify.gif align=absmiddle border=0></a> 
                                &nbsp;<a href='javascript:save("d", "<%=i%>")'><img src=../images/center/button_in_delete.gif align=absmiddle border=0></a> 
                            <%}%>
                        <%}%>			  
                    </td>
                </tr>		  
                <%		total_amt = total_amt + cha.getCh_amt();
			}%>
                <tr align="center"> 
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>��</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title><%=Util.parseDecimal(total_amt)%>&nbsp;��</td>
                    <td class=title>&nbsp;</td>
                </tr>		
	        <%if(!cmd.equals("view")){%>	
                <tr align="center"> 
                    <td>�߰� 
                      <input type='hidden' name='ch_tm' value='<%=ins_cha_size+1%>'>
                    </td>
                    <td></td>
                    <td>
                      <input type='text' size='11' name='ch_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td>
        	        <select name="ch_item">
            	            <option value="">����</option>
            	            <option value="10">����2���Աݾ�</option>			  
            	            <option value="1">�빰���Աݾ�</option>
        	            <option value="2">�ڱ��ü����Աݾ�(���/���)</option>
			    <option value="12">�ڱ��ü����Աݾ�(�λ�)</option>
            	            <option value="7">�빰+�ڱ��ü����Աݾ�</option>
                	    <option value="3">������������Ư��</option>
                	    <option value="4">�ڱ��������ذ��Աݾ�</option>			  
                	    <option value="9">�ڱ����������ڱ�δ��</option>			  			  
            	            <option value="5">���ɺ���</option>		  
                	    <option value="6">�ִ�īƯ��</option>			  	
                	    <option value="8">��������</option>			  			  			  			  		  
                	    <option value="11">������ü</option>                	    
                	    <option value="14">��������������Ư��</option>
                	    <option value="17">���ڽ�</option>
                	    <option value="20">���ΰ�</option>                	    
                	    <option value="21">�������������</option>                	    
                	    <option value="22">����ắ��</option>                	    
                	    <option value="15">�Ǻ�����</option>
                	    <option value="16">���谻��</option>
                	    <option value="13">��Ÿ</option>                	    
                	    
        	        </select>			
        	        <input type='hidden' name='o_ch_item' value=''>
                    </td>
                    <td>
                      <input type='text' size='20' name='ch_before' class='text' value=''>
                    </td>
                    <td>
                      <input type='text' size='20' name='ch_after' class='text' value=''>
                    </td>
                    <td> 
                      <input type='text' size='10' name='ch_amt' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td> 
        	        <%if(!cmd.equals("view")){%>	
                            <%if(!update_yn.equals("N") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                                <a href='javascript:save("i", "<%=ins_cha_size%>")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a> 
                            <%}%>
                        <%}%>			  
                    </td>
                </tr>
                <%}%>			  
            </table>
        </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe> 
</body>
</html>