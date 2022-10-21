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
	String mode = request.getParameter("mode")==null?"3":request.getParameter("mode");
	
	String update_yn = request.getParameter("update_yn")==null?"":request.getParameter("update_yn");
	
	if(!mode.equals("3") && !mode.equals("pay")) mode = "3";
	
	InsDatabase ai_db = InsDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	EstiDatabase e_db = EstiDatabase.getInstance();

	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//��������
	InsurBean ins = ai_db.getInsCase(c_id, ins_st);
	
	//���轺����
	Vector ins_scd = ai_db.getInsScds(c_id, ins_st);
	int ins_scd_size = ins_scd.size();	
	
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
			fm.r_ins_tm.value = fm.ins_tm.value;
			fm.r_ins_tm2.value = fm.ins_tm2.value;			
			fm.r_ins_est_dt.value = fm.ins_est_dt.value;
			fm.r_ins_est_dt2.value = fm.re_ins_est_dt.value;			
			fm.r_pay_amt.value = fm.pay_amt.value;
			fm.r_pay_dt.value = fm.pay_dt.value;
			fm.r_o_pay_dt.value = fm.o_pay_dt.value;
			fm.r_ch_tm.value = fm.ch_tm.value;
		}else{
			fm.r_ins_tm.value = fm.ins_tm[idx].value;
			fm.r_ins_tm2.value = fm.ins_tm2[idx].value;			
			fm.r_ins_est_dt.value = fm.ins_est_dt[idx].value;
			fm.r_ins_est_dt2.value = fm.re_ins_est_dt[idx].value;						
			fm.r_pay_amt.value = fm.pay_amt[idx].value;
			fm.r_pay_dt.value = fm.pay_dt[idx].value;	
			fm.r_o_pay_dt.value = fm.o_pay_dt[idx].value;	
			fm.r_ch_tm.value = fm.ch_tm[idx].value;
		}
		if(fm.r_ins_est_dt.value == ''){ alert("���ο������� �Է��Ͻʽÿ�."); return; }
//		if(fm.r_ins_est_dt2.value == ''){ alert("�ǳ��ο������� �Է��Ͻʽÿ�."); return; }		
		if(fm.r_pay_amt.value == ''){ alert("���αݾ��� �Է��Ͻʽÿ�."); return; }		
		if(fm.r_ins_tm2.value == ''){ alert("����� ������ �����Ͻʽÿ�."); return; }		
		if(cmd=='d'){
			if(fm.r_ins_tm2.value == '1'){
				if(!confirm('�߰�����Ḧ �����ϴ� ��� ��� ������ ���躯��а� �Ⱓ��뵵 ���� ���� ó���˴ϴ�. ����Ͻðڽ��ϱ�?')){	return;	}
			}
		}
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
    <input type='hidden' name='size' value='<%=ins_scd_size%>'>	
    <input type='hidden' name='cmd' value=''>	
    <input type='hidden' name='r_ins_tm' value=''>
    <input type='hidden' name='r_ins_tm2' value=''>	
    <input type='hidden' name='r_ins_est_dt' value=''>
    <input type='hidden' name='r_ins_est_dt2' value=''>	
    <input type='hidden' name='r_pay_amt' value=''>
    <input type='hidden' name='r_pay_dt' value=''>	
    <input type='hidden' name='r_o_pay_dt' value=''>		
    <input type='hidden' name='r_ch_tm' value=''>			
	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���轺����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width="100%">
                <tr> 
                    <td class=title width=10%>ȸ��</td>
                    <td class=title width=15%>����</td>
                    <td class=title width=10%>�����ڵ�</td>
                    <td class=title width=10%>���ο�����</td>
                    <td class=title width=10%>�ǳ��ο�����</td>			
                    <td class=title width=15%>���αݾ�</td>
                    <td class=title width=15%>������</td>
                    <td class=title width=15%>ó��</td>
                </tr>
          <%	for(int i = 0 ; i < ins_scd_size ; i++){
					InsurScdBean scd = (InsurScdBean)ins_scd.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%> 
                      <input type='hidden' name='ins_tm' value='<%=scd.getIns_tm()%>'>
					  <input type='hidden' name='o_pay_dt' value='<%=scd.getPay_dt()%>'>
					  <input type='hidden' name='excel_chk' value='<%=scd.getExcel_chk()%>'>
					  <!--<input type='hidden' name='ch_tm' value='<%=scd.getCh_tm()%>'>-->
                    </td>
                    <td>
                      <select name='ins_tm2'>
                        <option value='0' <%if(scd.getIns_tm2().equals("0")){%>selected<%}%>>���ʳ��Ժ����</option>
                        <option value='1' <%if(scd.getIns_tm2().equals("1")){%>selected<%}%>>�߰������</option>
                        <option value='2' <%if(scd.getIns_tm2().equals("2")){%>selected<%}%>>���������</option>
                      </select>
                      </td>
                      <td><input type='text' size='2' name='ch_tm' class='whitetext' value='<%=scd.getCh_tm()%>'></td>
                    <td>
                      <input type='text' size='11' name='ins_est_dt' class='text' value='<%=scd.getIns_est_dt()%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td>
                      <input type='text' size='11' name='re_ins_est_dt' class='text' value='<%=scd.getR_ins_est_dt()%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td>&nbsp; 
                      <input type='text' size='10' name='pay_amt' class='num' value='<%=Util.parseDecimal(scd.getPay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      &nbsp;��</td>
                    <td>&nbsp; 
                      <input type='text' size='11' name='pay_dt' class='text' value='<%=scd.getPay_dt()%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td> 
        	    <%if(!cmd.equals("view")){

        	        		String update_yn2 = "Y";
        	        		String modify_deadline2 = c_db.addMonth(scd.getIns_est_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;
        	        		
        	        		//if(AddUtil.parseInt(AddUtil.replace(modify_deadline2,"-","")) > 20170401) modify_deadline2 = "20170630";
        	        		
											if(AddUtil.parseInt(AddUtil.replace(modify_deadline2,"-","")) < AddUtil.parseInt(AddUtil.getDate(4))){
												update_yn2 = "N";
											}        	    
        	    %>		
                    <%--   <%if(!update_yn2.equals("N") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%> --%>
                      <a href='javascript:save("u", "<%=i%>")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_in_modify.gif align=absmiddle border=0></a> 
                      &nbsp;<a href='javascript:save("d", "<%=i%>")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_in_delete.gif align=absmiddle border=0></a> 
                      <%-- <%}%> --%>
                <%}%>			  		
                    </td>
                </tr>
          <%	if(scd.getIns_tm2().equals("2")){
		  			total_amt = total_amt - scd.getPay_amt();
				}else{
		  			total_amt = total_amt + scd.getPay_amt();
				}
			  }%>
                <tr> 
                    <td class=title></td>
                    <td class=title>��</td>
                    <td class=title></td>
                    <td class=title></td>
                    <td class=title></td>			
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt)%>&nbsp;&nbsp;��&nbsp;</td>
                    <td class=title></td>
                    <td class=title></td>
                </tr>		  		  
	    <%if(!cmd.equals("view")){%>		
                <tr align="center"> 
                    <td>�߰� 
                      <input type='hidden' name='ins_tm' value='<%=ins_scd_size+1%>'>
					  <input type='hidden' name='o_pay_dt' value=''>
					  <input type='hidden' name='excel_chk' value=''>					  
                    </td>
                    <td>
                      <select name='ins_tm2'>
                        <option value=''>����</option>			  
                        <option value='0'>���ʳ��Ժ����</option>
                        <option value='1'>�߰������</option>
                        <option value='2'>���������</option>
                      </select>
                    </td>
                    <td><input type='text' size='2' name='ch_tm' class='text' value=''></td>
                    <td>
                      <input type='text' size='11' name='ins_est_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td>
                      <input type='text' size='11' name='re_ins_est_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>			
                    <td>&nbsp; 
                      <input type='text' size='10' name='pay_amt' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      &nbsp;��</td>
                    <td>&nbsp; 
                      <input type='text' size='11' name='pay_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td> 
        	    <%if(!cmd.equals("view")){%>			
                      <%if(!update_yn.equals("N") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                      <a href='javascript:save("i", "<%=ins_scd_size%>")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a> 
                      <%}%>
                <%}%>			  
                    </td>
                </tr>
        <%}%>			  				  
            </table>
        </td>
    </tr>
	<%if(mode.equals("cls")){%>
    <tr> 
        <td align="right"><a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>	
	<%}%>			
    <tr> 
        <td>�� �߰�����Ḧ �����ϴ� ��� ��� ������ ���躯��а� �Ⱓ��뵵 ���� ���� ó���˴ϴ�.</td>
    </tr>	
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe> 
</body>
</html>

