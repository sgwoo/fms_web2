<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.lang.*, java.util.*, acar.util.*, acar.common.*, acar.car_register.*, acar.accid.*, acar.insur.*, acar.estimate_mng.*"%>
<jsp:useBean id="car" 	class="acar.car_register.CarRegBean" 	scope="page"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<jsp:useBean id="cls" 	class="acar.insur.InsurClsBean" 		scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
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
	String mode = request.getParameter("mode")==null?"4":request.getParameter("mode");	
	
	String update_yn = request.getParameter("update_yn")==null?"":request.getParameter("update_yn");
	
	if(!mode.equals("4") && !mode.equals("cls")) mode = "4";
	String y_days = "365";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();

	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//��������
	ins = ins_db.getInsCase(c_id, ins_st);
	
	//������������
	cls = ins_db.getInsurClsCase(c_id, ins_st);
	
	//��������ὺ����
	int cls_amt = Math.abs(ins_db.getInsurScdAmt(c_id, ins_st, "2"));
	
	//����Ⱓ���� �ϼ� ���ϱ�
	y_days = ins_db.getTotInsDays(c_id, ins_st);
	
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "ins_modify_dt");
	String var2 = e_db.getEstiSikVarCase("1", "", "ins_modify_mon");
	
	if(update_yn.equals("")){
			
		String modify_deadline = c_db.addMonth(ins.getIns_exp_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;
		
		if(!cls.getReq_dt().equals("")){
			modify_deadline = c_db.addMonth(cls.getReq_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;
		}
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) == 20220325) modify_deadline = "20220425";
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) < AddUtil.parseInt(AddUtil.getDate(4))){
			update_yn = "N";
		}
		
	}	
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function cng_input(){
		var fm = document.form1;
		if(fm.cls_st[0].checked == true){ 		//����
			tr_ins_cls1.style.display = '';				
			tr_ins_cls2.style.display = '';				
			tr_ins_cls3.style.display = '';				
			tr_ins_cls4.style.display = '';				
			tr_ins_cls5.style.display = '';																
		}else{
			tr_ins_cls1.style.display = '';		
			tr_ins_cls2.style.display = '';		
			tr_ins_cls3.style.display = '';		
			tr_ins_cls4.style.display = '';		
			tr_ins_cls5.style.display = '';														
		}
	}
	
	//���������߻����� �Է½� ����
	function set_use(){
		var fm = document.form1;
		var t_use_amt = 0;		
		var t_ins_amt = 0;
		var st;
		var et;
		var days;
		var daysRound;
		var ins_kd = fm.ins_kd.value;
		fm.ins_end_dt.value = fm.exp_dt.value;
		
		for(i=0; i<7; i++){
			st = new Date(replaceString("-","/",fm.ins_start_dt[i].value));//������
			et = new Date(replaceString("-","/",fm.ins_end_dt.value));//������
			days = (et - st) / 1000 / 60 / 60 / 24; //1��=24�ð�*60��*60��*1000milliseconds
			daysRound = Math.floor(days);//+1:������ ����
			fm.use_day[i].value = daysRound;
			fm.use_amt[i].value = parseDecimal( th_round(toInt(parseDigit(fm.ins_amt[i].value)) /<%=y_days%> * daysRound) );
			t_use_amt = t_use_amt + toInt(parseDigit(fm.use_amt[i].value));
			t_ins_amt = t_ins_amt + toInt(parseDigit(fm.ins_amt[i].value));
		}
		fm.use_amt[7].value = parseDecimal(t_use_amt);
		fm.ins_amt[7].value = parseDecimal(t_ins_amt);
		fm.tot_use_amt.value = parseDecimal(t_use_amt);
		fm.tot_ins_amt.value = parseDecimal(t_ins_amt);
		
		fm.rtn_est_amt.value = parseDecimal( toInt(parseDigit(fm.tot_ins_amt.value))-toInt(parseDigit(fm.tot_use_amt.value))-toInt(parseDigit(fm.nopay_amt.value)) );
		fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );						
	}
		
	//���� ����� �հ� ����
	function set_tot_use(){
		var fm = document.form1;
		var ins_kd = fm.ins_kd.value;
		var t_use_amt = 0;
		
		for(i=0; i<7; i++){
			t_use_amt = t_use_amt + toInt(parseDigit(fm.use_amt[i].value));
		}
		fm.use_amt[7].value = parseDecimal(t_use_amt);
		fm.tot_use_amt.value = parseDecimal(t_use_amt);

		fm.rtn_est_amt.value = parseDecimal( toInt(parseDigit(fm.tot_ins_amt.value))-toInt(parseDigit(fm.tot_use_amt.value))-toInt(parseDigit(fm.nopay_amt.value)) );
		fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );				
	}
	
	//å�Ӻ��������� ����	
	function set_use_amt(idx){
		var fm = document.form1;
		if(fm.exp_yn[idx].options[fm.exp_yn[idx].selectedIndex].value == 'N'){			
			fm.use_amt[idx].value = parseDecimal( th_rnd(toInt(parseDigit(fm.ins_amt[idx].value)) /<%=y_days%> * toInt(fm.use_day[idx].value)) );		
		}else{
			fm.use_amt[idx].value = 0;				
		}
	
	}
	
	//ȯ�ޱ� �Է½� ���� ���
	function set_dif(){
		var fm = document.form1;
		fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );		
	}
	
	//ȯ�޿����ݾװ� ȯ�ޱݰ� ���Ͻ� üũ�ϸ� �� �ѱ��
	function Rtn_chk(){
		var fm = document.form1;
		if(fm.rtn_chk.checked == true){
			fm.rtn_amt.value = fm.rtn_est_amt.value;					
			fm.dif_amt.value = "0";			
		}else{
			fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );
		}
	}
	
	function save(){
		var fm = document.form1;
		if(fm.exp_dt.value == ''){ 							alert('���������߻����ڸ� �Է��Ͻʽÿ�.'); 	return; }
		if(fm.req_dt.value == ''){ 							alert('û�����ڸ� �Է��Ͻʽÿ�.'); 			return; }
		if(fm.rtn_est_amt.value == ''){ 					alert('ȯ�޿����ݾ��� �Է��Ͻʽÿ�.'); 		return; }		
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.target = 'i_no';
		fm.submit();
	}
//-->
</script>
</head>

<body>
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
    <input type='hidden' name="car_use" value='<%=ins.getCar_use()%>'>
    <input type='hidden' name="ins_kd" value='<%=ins.getIns_kd()%>'>
    <input type='hidden' name='cmd' value=''>	
    <input type='hidden' name='old_rtn_dt' value='<%=AddUtil.ChangeDate2(cls.getRtn_dt())%>'>		
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<%	sBean = olsD.getSui(c_id);
	if(!sBean.getMigr_dt().equals("")){%>	
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=10%>������<br>������ȣ</td>
                    <td width=13%>&nbsp;<%=car.getFirst_car_no()%></td>
                    <td class=title width=10%>�����</td>
                    <td width=22%>&nbsp;<%=sBean.getSui_nm()%></td>
                    <td class=title width=10%>�������</td>
                    <td width=12%>&nbsp;<%=AddUtil.ChangeDate2(sBean.getCont_dt())%></td>
                    <td class=title width=10%>����������</td>
                    <td width=13%>&nbsp;<%=AddUtil.ChangeDate2(sBean.getMigr_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
<%	}%>

<%	//�뵵���� �̷�
	Vector cngs = ins_db.getCarNoCng(c_id);
	int cng_size = cngs.size();
	if(cng_size > 0){%>
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뵵����</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
<%		for(int i = 0 ; i < cng_size ; i++){
			Hashtable cng = (Hashtable)cngs.elementAt(i);
			String cha_cau = String.valueOf(cng.get("CHA_CAU"));%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=13%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cng.get("CHA_DT")))%></td>
                    <td class=title width=10%>�������</td>
                    <td width=22%> 
                      <%if(cha_cau.equals("1")){%>
                      &nbsp;��뺻���� ���� 
                      <%}else if(cha_cau.equals("2")){%>
                      &nbsp;�뵵���� 
                      <%}else if(cha_cau.equals("3")){%>
                      &nbsp;��Ÿ 
                      <%}else if(cha_cau.equals("4")){%>
                      &nbsp;���� 
                      <%}else if(cha_cau.equals("5")){%>
                      &nbsp;�űԵ�� 
                      <%}%>
                    </td>
                    <td class=title width=10%>���泻��</td>
                    <td width=35%>&nbsp;<%=cng.get("CHA_CAU_SUB")%> </td>
                </tr>
<%		}%>
            </table>
        </td>
    </tr>	
<%	}%>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=23%>�뵵����</td>
                    <td width=32%> 
                       <%if(cls.getExp_st().equals("1")){%>
                      &nbsp;������(R) -&gt; ������(L) 
                      <%}else if(cls.getExp_st().equals("2")){%>
                      &nbsp;������(L) -&gt; ������(R) 
                      <%}else if(cls.getExp_st().equals("3")){%>
                      &nbsp;���� 
                      <%}%>
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=35%>&nbsp; 
					  <input type="radio" name="exp_aim" value="1" <%if(cls.getExp_aim().equals("1")){%>checked<%}%>>�縮��
					  <input type="radio" name="exp_aim" value="2" <%if(cls.getExp_aim().equals("2")){%>checked<%}%>>Self
					  <input type="radio" name="exp_aim" value="3" <%if(cls.getExp_aim().equals("3")){%>checked<%}%>>�Ű�
					  <input type="radio" name="exp_aim" value="4" <%if(cls.getExp_aim().equals("4")){%>checked<%}%>>����
					  <input type="radio" name="exp_aim" value="5" <%if(cls.getExp_aim().equals("5")){%>checked<%}%>>����
					  <input type="radio" name="exp_aim" value="9" <%if(cls.getExp_aim().equals("9")){%>checked<%}%>>��Ÿ
                    </td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td colspan="3">&nbsp;
        			  <input type="radio" name="cls_st" value="1" onClick="javascript:cng_input()" <%if(cls.getCls_st().equals("1") || cls.getCls_st().equals("")){%>checked<%}%>>��������
        			  <input type="radio" name="cls_st" value="2" onClick="javascript:cng_input()" <%if(cls.getCls_st().equals("2")){%>checked<%}%>>����°�			  
                    </td>
                </tr>
                <tr> 
                    <td class=title>���������߻�����</td>
                    <td> 
                      &nbsp;<input type='text' size='11' name='exp_dt' class='text' value='<%=AddUtil.ChangeDate2(cls.getExp_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value);'><!-- set_use();-->
                    </td>
                    <td class=title>û������</td>
                    <td> 
                      &nbsp;<input type='text' size='11' name='req_dt' class='text' value='<%=AddUtil.ChangeDate2(cls.getReq_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>	
    <tr id=tr_ins_cls1 style='display:<%if(!cls.getCls_st().equals("2")){%>""<%}else{%>none<%}%>'> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2" width=23%>�㺸</td>
                    <td class=title width=17%>�����ѵ�</td>
                    <td class=title width=15%>�����</td>
                    <td class=title width=10%>��ళ����</td>
                    <td class=title width=8%>���������</td>
                    <td class=title width=8%>����ϼ�</td>
                    <td class=title width=8%>����</td>
                    <td class=title width=11%>��������</td>
                </tr>
                <tr> 
                    <td class=title>å�Ӻ���</td>
                    <td class=title>���ι��</td>
                    <td>&nbsp;</td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getRins_pcp_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' value='<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center" rowspan="7"> 
                      <input type='text' size='12' name='ins_end_dt' value='<%=AddUtil.ChangeDate2(cls.getExp_dt())%>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='<%=cls.getUse_day1()%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" <%if(cls.getExp_yn1().equals("N"))%>selected<%%>>����</option>
                        <option value="Y" <%if(cls.getExp_yn1().equals("Y"))%>selected<%%>>����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='<%=Util.parseDecimal(cls.getUse_amt1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title rowspan="4">���Ǻ���</td>
                    <td class=title>���ι��</td>
                    <td> 
                      <%if(ins.getVins_pcp_kd().equals("1")){%>
                      &nbsp;���� 
                      <%}%>
                      <%if(ins.getVins_pcp_kd().equals("2")){%>
                      &nbsp;���� 
                      <%}%>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_pcp_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "10"))%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='<%=cls.getUse_day2()%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" <%if(cls.getExp_yn2().equals("N"))%>selected<%%>>����</option>
                        <option value="Y" <%if(cls.getExp_yn2().equals("Y"))%>selected<%%>>����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='<%=Util.parseDecimal(cls.getUse_amt2())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�빰���&nbsp;&nbsp;</td>
                    <td> 
                      <%if(ins.getVins_gcp_kd().equals("9")){%>
                      &nbsp;10��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("6")){%>
                      &nbsp;5��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("8")){%>
                      &nbsp;3��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("7")){%>
                      &nbsp;2��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("3")){%>
                      &nbsp;1��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("4")){%>
                      &nbsp;5000���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("1")){%>
                      &nbsp;3000���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("2")){%>
                      &nbsp;1500���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("4")){%>
                      &nbsp;1000���� 
                      <%}%>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_gcp_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "(7,1)"))%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='<%=cls.getUse_day3()%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" <%if(cls.getExp_yn3().equals("N"))%>selected<%%>>����</option>
                        <option value="Y" <%if(cls.getExp_yn3().equals("Y"))%>selected<%%>>����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='<%=Util.parseDecimal(cls.getUse_amt3())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ڱ��ü���</td>
                    <td> 
                      <%if(ins.getVins_bacdt_kd().equals("1")){%>
                      &nbsp;3��� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("2")){%>
                      &nbsp;1��5õ���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("6")){%>
                      &nbsp;1��� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("5")){%>
                      &nbsp;5000���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("3")){%>
                      &nbsp;3000���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("4")){%>
                      &nbsp;1500���� 
                      <%}%>
                      / 
                      <%if(ins.getVins_bacdt_kc2().equals("1")){%>
                      3��� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("2")){%>
                      1��5õ���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("6")){%>
                      1��� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("5")){%>
                      5000���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("3")){%>
                      3000���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("4")){%>
                      1500���� 
                      <%}%>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_bacdt_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "(7,2)"))%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='<%=cls.getUse_day4()%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" <%if(cls.getExp_yn4().equals("N"))%>selected<%%>>����</option>
                        <option value="Y" <%if(cls.getExp_yn4().equals("Y"))%>selected<%%>>����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='<%=Util.parseDecimal(cls.getUse_amt4())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ڱ���������</td>
                    <td>&nbsp;<%=ins.getVins_cacdt_car_amt()%>��/<%=ins.getVins_cacdt_me_amt()%>�� 
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_cacdt_cm_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "9"))%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='<%=cls.getUse_day5()%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" <%if(cls.getExp_yn5().equals("N"))%>selected<%%>>����</option>
                        <option value="Y" <%if(cls.getExp_yn5().equals("Y"))%>selected<%%>>����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='<%=Util.parseDecimal(cls.getUse_amt5())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2">Ư��</td>
                    <td class=title>������������</td>
                    <td> </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_canoisr_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "3"))%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='<%=cls.getUse_day6()%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" <%if(cls.getExp_yn6().equals("N"))%>selected<%%>>����</option>
                        <option value="Y" <%if(cls.getExp_yn6().equals("Y"))%>selected<%%>>����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='<%=Util.parseDecimal(cls.getUse_amt6())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>����⵿</td>
                    <td>&nbsp;<%=ins.getVins_spe()%>&nbsp;</td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_spe_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "6"))%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='<%=cls.getUse_day7()%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" <%if(cls.getExp_yn7().equals("N"))%>selected<%%>>����</option>
                        <option value="Y" <%if(cls.getExp_yn7().equals("Y"))%>selected<%%>>����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='<%=Util.parseDecimal(cls.getUse_amt7())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title rowspan="5" colspan="2">�հ�</td>
                    <td>&nbsp; </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(cls.getTot_ins_amt())%>' class='whitenum' readonly>
                      ��</td>
                    <td align="center" colspan="4">&nbsp;</td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='<%=Util.parseDecimal(cls.getTot_use_amt())%>' class='num' readonly>
                      ��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_ins_cls2 style='display:<%if(!cls.getCls_st().equals("2")){%>""<%}else{%>none<%}%>'> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                                <td class=title width=23%>�Ѻ����</td>
                                <td width=17%> 
                                &nbsp;<input type='text' name='tot_ins_amt' value='<%=Util.parseDecimal(cls.getTot_ins_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>��</td>
                                <td class=title width=15%>�Ѱ�������</td>
                                <td width=18%> 
                                &nbsp;<input type='text' size='10' name='tot_use_amt' value='<%=Util.parseDecimal(cls.getTot_use_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>��
								</td>
                                <td class=title width=8%>��ȸ�����</td>
                                <td width=19%> 
                                &nbsp;<input type='text' name='nopay_amt' value='<%=Util.parseDecimal(cls.getNopay_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>��
								(�̳������)</td>
                            </tr>
                            <tr> 
                                <td class=title width=23%>ȯ�޿����ݾ�</td>
                                <td width=17%> 
                                &nbsp;<input type='text' size='10' name='rtn_est_amt' value='<%=Util.parseDecimal(cls.getRtn_est_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>
                                ��</td>
                                <td class=title width=15%>ȯ�ޱ�</td>
                                <td width=18%> 
                                &nbsp;<input type='text' name='rtn_amt' value='<%=Util.parseDecimal(cls_amt)%>' class='whitenum' size='10' readonly onBlur='javascript:this.value=parseDecimal(this.value); set_dif();'>
                                ��</td>
                                <td class=title width=8%>����</td>
                                <td width=19%> 
                                &nbsp;<input type='text' name='dif_amt' value='<%=Util.parseDecimal(cls.getDif_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                                ��</td>
                            </tr>
                            <tr> 
                                <td class=title width=23%>����</td>
                                <td colspan="5">
                                    &nbsp;<input type="text" name="dif_cau" size="104" value="<%=cls.getDif_cau()%>" class="text" style='IME-MODE: active'>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
<%	//��������
	Hashtable ins_doc = ins_db.getInsClsDocCasc(c_id, ins_st);
	if(!String.valueOf(ins_doc.get("DOC_ID")).equals("")){%>	
    <tr id=tr_ins_cls3 style='display:<%if(!cls.getCls_st().equals("2")){%>""<%}else{%>none<%}%>'> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����������û����</span></td>
    </tr>
    <tr id=tr_ins_cls4 style='display:<%if(!cls.getCls_st().equals("2")){%>""<%}else{%>none<%}%>'> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                                <td class=title width=10%>������ȣ</td>
                                <td width=13%>&nbsp;<%=ins_doc.get("DOC_ID")%></td>
                                <td class=title width=10%>��������</td>
                                <td width=67%>&nbsp;<%=AddUtil.getDate3(String.valueOf(ins_doc.get("DOC_DT")))%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
<%	}%>	
    <tr id=tr_ins_cls5 style='display:<%if(!cls.getCls_st().equals("2")){%>""<%}else{%>none<%}%>'> 
        <td><font color="#999999">�� ȯ�ޱ� �Ա�ó���� &quot;���轺����&quot;���� ó���Ͻʽÿ�.</font></td>
    </tr>
	<%//}%>
    <tr> 
        <td align="right"> <!--������°� ���ᳪ �ߵ������� ��� �������� ���ϰ� ����(������ �������� �����߻�) -->
        <%	if((!ins.getIns_sts().equals("2") || !ins.getIns_sts().equals("3")) && !update_yn.equals("N") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
        <a href='javascript:save()'><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
        <%	}%>
        </td>
    </tr>
</table>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
