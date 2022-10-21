<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_register.*, acar.insur.*"%>
<jsp:useBean id="car" 	class="acar.car_register.CarRegBean" 	scope="page"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//�ڵ���������ȣ
	String y_days = "365";
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "02");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase car_db = CarRegDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	
	//��������
	car = car_db.getCarRegBean(c_id);
	
	//��������
	ins = ins_db.getInsCase(c_id, ins_st);
	
	//����Ⱓ���� �ϼ� ���ϱ�
	y_days = ins_db.getTotInsDays(c_id, ins_st);
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	function aim_display(){
	return;
		var fm = document.form1;
		var car_use = fm.car_use.value;
		var ins_kd = fm.ins_kd.value;
		td_aim1.style.display = 'none';
		td_aim2.style.display = 'none';
		td_aim3.style.display = 'none';
		td_aim4.style.display = 'none';
		td_aim5.style.display = 'none';
		if(ins_kd == '2'){//å�Ӻ���
			td_aim3.style.display = '';
		}else{//���պ���
			if(car_use == '1'){//������(��Ʈ)
				if(fm.exp_st[0].checked == true){	
					td_aim1.style.display = '';	
					td_aim2.style.display = ''; 	
				}else if(fm.exp_st[1].checked == true){	
					td_aim4.style.display = '';	
					td_aim5.style.display = ''; 	
				}
					td_aim3.style.display = '';
					td_aim6.style.display = '';
			}else{//������(����)
				if(fm.exp_st[0].checked == true){	
					td_aim1.style.display = '';	
					td_aim2.style.display = ''; 	
				}else if(fm.exp_st[1].checked == true){	
					td_aim4.style.display = '';	
					td_aim5.style.display = ''; 	
					td_aim3.style.display = ''; 	
				}
					td_aim6.style.display = '';							
			}
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
		
		if(fm.cls_st[0].checked == true){
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
			if(toInt(parseDigit(fm.rtn_amt.value)) > 0){
				fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );						
			}
		}
	}
		
	//���� ����� �հ� ����
	function set_tot_use(){
		var fm = document.form1;
		var ins_kd = fm.ins_kd.value;
		var t_use_amt = 0;
		if(fm.cls_st[0].checked == true){
		
			for(i=0; i<7; i++){
				t_use_amt = t_use_amt + toInt(parseDigit(fm.use_amt[i].value));
			}
			fm.use_amt[7].value = parseDecimal(t_use_amt);
			fm.tot_use_amt.value = parseDecimal(t_use_amt);
			
			fm.rtn_est_amt.value = parseDecimal( toInt(parseDigit(fm.tot_ins_amt.value))-toInt(parseDigit(fm.tot_use_amt.value))-toInt(parseDigit(fm.nopay_amt.value)) );
			if(toInt(parseDigit(fm.rtn_amt.value)) > 0){
				fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );				
			}
		}
	}
	
	//å�Ӻ��������� ����	
	function set_use_amt(idx){
		var fm = document.form1;
		if(fm.cls_st[0].checked == true){
			if(fm.exp_yn[idx].options[fm.exp_yn[idx].selectedIndex].value == 'N'){			
				fm.use_amt[idx].value = parseDecimal( th_rnd(toInt(parseDigit(fm.ins_amt[idx].value)) /<%=y_days%> * toInt(fm.use_day[idx].value)) );		
			}else{
				fm.use_amt[idx].value = 0;				
			}
		}
	}
	
	//ȯ�ޱ� �Է½� ���� ���
	function set_dif(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.rtn_amt.value)) > 0){		
			fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );		
		}
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
		var len=fm.elements.length;
		var exp_st=0;
		var exp_aim=0;
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "exp_st" && ck.checked == true)	exp_st++;
			if(ck.name == "exp_aim" && ck.checked == true)	exp_aim++;			
		}	
		if(exp_st == 0){									alert('�뵵���� ������ �����Ͻʽÿ�.');		return;	}
		if(exp_aim == 0){ 									alert('�뵵���� ������ �����Ͻʽÿ�.'); 	return; }		
		if(fm.c_id.value == '' || fm.ins_st.value == ''){ 	alert('������ �����Ͻʽÿ�.'); 				return; }
		if(fm.exp_dt.value == ''){ 							alert('���������߻����ڸ� �Է��Ͻʽÿ�.'); 	return; }
		if(fm.req_dt.value == ''){ 							alert('û��/�°����ڸ� �Է��Ͻʽÿ�.');		return; }		
		
		if(fm.cls_st[0].checked == true){
			if(fm.rtn_est_amt.value == ''){ 					alert('ȯ�޿����ݾ��� �Է��Ͻʽÿ�.'); 		return; }			
		
			if(toInt(parseDigit(fm.rtn_amt.value)) == 0 || fm.rtn_amt.value == ''){		
				fm.scd_ins_amt.value = fm.rtn_est_amt.value;
			}else{
				fm.scd_ins_amt.value = fm.rtn_amt.value;
			}
		}
		
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		//fm.target = 'i_no';
		fm.action = 'ins_cls_a.jsp';
		fm.submit();
	}
</script>
</head>

<body>
<form name='form1' method='post'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="ins_st" value='<%=ins_st%>'>
<input type='hidden' name="car_use" value='<%=ins.getCar_use()%>'>
<input type='hidden' name="ins_kd" value='<%=ins.getIns_kd()%>'>
<input type='hidden' name="scd_ins_amt" value=''>
<input type='hidden' name="car_no" value='<%=car.getCar_no()%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td width=13%>&nbsp;<%=car.getCar_no()%><a href=# title=<%=c_id+" "+ins_st%>>&nbsp;<font color="#999999">(<%=ins_st%>)</font></a></td>
                    <td class=title width=10%>����</td>
                    <td width=20%>&nbsp;<%=car.getCar_nm()%></td>
                    <td class=title width=10%>���ʵ����</td>
                    <td width=13%>&nbsp;<%=AddUtil.ChangeDate2(car.getInit_reg_dt())%></td>
                    <td class=title width=10%>�����ȣ</td>
                    <td width=14%>&nbsp;<%=car.getCar_num()%></td>
                </tr>
                <tr> 
                    <td class=title>�����</td>
                    <td>&nbsp;<%=c_db.getNameById(ins.getIns_com_id(), "INS_COM")%></td>
                    <td class=title>����Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>~<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%></td>
                    <td class=title>��������</td>
                    <td> 
                      <%if(ins.getCar_use().equals("1")) {%>
                      &nbsp;������ 
                      <%}else{%>
                      &nbsp;������ 
                      <%}%>
                    </td>
                    <td class=title>�㺸����</td>
                    <td> 
                      <%if(ins.getIns_kd().equals("1")) {%>
                      &nbsp;���㺸 
                      <%}else{%>
                      &nbsp;å�Ӻ��� 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���ǹ�ȣ</td>
                    <td colspan="7">&nbsp;<%=ins.getIns_con_no()%></td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <%	sBean = olsD.getSui(c_id);
		if(!sBean.getMigr_dt().equals("")){%>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=10% style='height:36'>������<br>������ȣ</td>
                    <td width=13%>&nbsp;<%=car.getFirst_car_no()%></td>
                    <td class=title width=10%>�����</td>
                    <td width=20%>&nbsp;<%=sBean.getSui_nm()%></td>
                    <td class=title width=10%>�������</td>
                    <td width=13%>&nbsp;<%=AddUtil.ChangeDate2(sBean.getCont_dt())%></td>
                    <td class=title width=10%>����������</td>
                    <td width=14%>&nbsp;<%=AddUtil.ChangeDate2(sBean.getMigr_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <%	}//else{%>
    <%		//�뵵���� �̷�
			Vector cngs = ins_db.getCarNoCng(c_id);
			int cng_size = cngs.size();
			if(cng_size > 0){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뵵����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
              <%     		for(int i = 0 ; i < cng_size ; i++){
    					Hashtable cng = (Hashtable)cngs.elementAt(i);
    					String cha_cau = String.valueOf(cng.get("CHA_CAU"));%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=13%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cng.get("CHA_DT")))%></td>
                    <td class=title width=10%>�������</td>
                    <td width=20%> 
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
                    <td width=37%>&nbsp;<%=cng.get("CHA_CAU_SUB")%> </td>
                </tr>
              <%			}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>		
    <%		}
		//}
	%>
	<%	//���轺����
			Vector ins_scd = ins_db.getInsScds(c_id, ins_st, "0");
			int ins_scd_size = ins_scd.size();	
			if(ins_scd_size > 0){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" width="100%">
                <tr> 
                    <td class=title width=10%>ȸ��</td>
                    <td class=title width=30%>����</td>
                    <td class=title width=30%>���ο�����</td>
                    <td class=title width=30%>���αݾ�</td>
                </tr>
              <%	for(int i = 0 ; i < ins_scd_size ; i++){
    					InsurScdBean scd = (InsurScdBean)ins_scd.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <select name='ins_tm2' disabled>
                        <option value='0' <%if(scd.getIns_tm2().equals("0")){%>selected<%}%>>���ʳ��Ժ����</option>
                        <option value='1' <%if(scd.getIns_tm2().equals("1")){%>selected<%}%>>�߰������</option>
                        <option value='2' <%if(scd.getIns_tm2().equals("2")){%>selected<%}%>>���������</option>
                      </select>
                    </td>
                    <td><%=scd.getIns_est_dt()%></td>
                    <td><%=Util.parseDecimal(scd.getPay_amt())%>��</td>
                </tr>
              <%
    			  }%>
            </table>
        </td>
    </tr>				
    <%	}%>				
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title rowspan="2" width=7%>�뵵<br>
                      ����</td>
                    <td class=title width=10%><font color="#FF0000">* </font>����</td>
                    <td colspan="3">
        			<%if(sBean.getMigr_dt().equals("")){%> 			 
                      <%if(ins.getIns_kd().equals("") || ins.getIns_kd().equals("1")){%>
                      <%if(ins.getCar_use().equals("1")){%>
                      <input type="radio" name="exp_st" value="1" onclick="javascript:aim_display()">
                      ������(R)-&gt;������(L) 
                      <%}else if(ins.getCar_use().equals("2")){%>
                      <input type="radio" name="exp_st" value="2" onclick="javascript:aim_display()">
                      ������(L)-&gt;������(R) 
                      <%}%>
                      <input type="radio" name="exp_st" value="3" onclick="javascript:aim_display()">
                      ���� 
                      <%}else{%>
                      <input type="radio" name="exp_st" value="3" onclick="javascript:aim_display()">
                      ���� 
                      <%}%>
        			<%}else{%>	
                      <input type="radio" name="exp_st" value="3" checked>
                      ���� 
        			<%}%>
                     </td>
                </tr>
                <tr> 
                    <td class=title><font color="#FF0000">* </font>����</td>
                    <td colspan="3">
        			<%if(sBean.getMigr_dt().equals("")){%> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td id="td_aim1" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="1">
                                �縮��</td>
                              <td id="td_aim2" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="2">
                                Self</td>
                              <td id="td_aim3" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="3">
                                �Ű�</td>
                              <td id="td_aim4" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="4">
                                ����</td>
                              <td id="td_aim5" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="5">
                                ����</td>
                              <td id="td_aim6" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="9">
                                ��Ÿ</td>
                              <td>&nbsp;</td>
                            </tr>
                        </table>
    			<%}else{%>
    			    <input type="radio" name="exp_aim" value="3" checked>
                        �Ű�
    			<%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title colspan="2"><font color="#FF0000">* </font>��������</td>
                    <td colspan="3"> 
                      <input type="radio" name="cls_st" value="1" onClick="javascript:tr_cls1.style.display='';tr_cls2.style.display='';tr_cls3.style.display='';">��������
        			  <input type="radio" name="cls_st" value="2" onClick="javascript:tr_cls1.style.display='none'; tr_cls2.style.display='none'; tr_cls3.style.display='none';">����°�			  
                    </td>
                </tr>		  
                <tr> 
                    <td class=title colspan="2"><font color="#FF0000">* </font>���������߻�����</td>
                    <td width=36%> 
                      &nbsp;<input type='text' size='11' name='exp_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td class=title width=10%><font color="#FF0000">* </font>û��/�°�����</td>
                    <td width=37%> 
                      <input type='text' size='11' name='req_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr id="tr_cls1" style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">�㺸</td>
                    <td class=title>�����ѵ�</td>
                    <td class=title>�����</td>
                    <td class=title>��ళ����</td>
                    <td class=title>���������</td>
                    <td class=title>����ϼ�</td>
                    <td class=title>����</td>
                    <td class=title>��������</td>
                </tr>
                <tr> 
                    <td class=title width=7%>å�Ӻ���</td>
                    <td class=title width=10%>���ι��</td>
                    <td width=14%>&nbsp;</td>
                    <td align="center" width=12%> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getRins_pcp_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      ��</td>
                    <td align="center" width=10%> 
                      <input type='text' size='12' name='ins_start_dt' value='<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center" rowspan="7" width=10%> 
                      <input type='text' size='12' name='ins_end_dt' value='' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center" width=12%> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center" width=12%> 
                      <select name="exp_yn" <%if(ins.getCar_use().equals("2") && ins.getIns_kd().equals("1")){%>onchange="javascript:set_use_amt(0);"<%}else{%>disabled<%}%>>
                        <option value="N" selected>����</option>
                        <option value="Y">����</option>
                      </select>
                    </td>
                    <td align="center" width=13%> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
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
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_pcp_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "10"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N">����</option>
                        <option value="Y">����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�빰���&nbsp;&nbsp;</td>
                    <td> 
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
                      <%if(ins.getVins_gcp_kd().equals("5")){%>
                      &nbsp;1000���� 
                      <%}%>			  
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_gcp_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "(7,1)"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>����</option>
                        <option value="Y">����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
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
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_bacdt_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "(7,2)"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>����</option>
                        <option value="Y">����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ڱ���������</td>
                    <td>&nbsp;<%=ins.getVins_cacdt_car_amt()%>��/<%=ins.getVins_cacdt_me_amt()%>��	
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_cacdt_cm_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "9"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>����</option>
                        <option value="Y">����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2">Ư��</td>
                    <td class=title>������������</td>
                    <td> </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_canoisr_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "3"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>����</option>
                        <option value="Y">����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>����⵿</td>
                    <td>&nbsp;<%=ins.getVins_spe()%></td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_spe_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "6"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>����</option>
                        <option value="Y">����</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title rowspan="5" colspan="2">�հ�</td>
                    <td>&nbsp; </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getRins_pcp_amt()+ins.getVins_pcp_amt()+ins.getVins_gcp_amt()+ins.getVins_bacdt_amt()+ins.getVins_cacdt_cm_amt()+ins.getVins_canoisr_amt()+ins.getVins_spe_amt())%>' class='whitenum' readonly>
                      ��</td>
                    <td align="center" colspan="4">&nbsp;</td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' readonly>
                      ��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr id="tr_cls2" style="display:''"> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                                <td class=title width=17%>�Ѻ����</td>
                                <td width=14%> 
                                <input type='text' name='tot_ins_amt' value='<%=Util.parseDecimal(ins.getRins_pcp_amt()+ins.getVins_pcp_amt()+ins.getVins_gcp_amt()+ins.getVins_bacdt_amt()+ins.getVins_cacdt_cm_amt()+ins.getVins_canoisr_amt()+ins.getVins_spe_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>
                                ��</td>
                                <td class=title width=14%>�Ѱ�������</td>
                                <td width=18%> 
                                <input type='text' size='10' name='tot_use_amt' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>
                                ��</td>
                                <td class=title width=14%>��ȸ�����</td>
                                <td width=23%> 
                                <input type='text' name='nopay_amt' value='<%=Util.parseDecimal(ins_db.getNopayAmt(c_id, ins_st))%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>
                                �� (�̳��κ����)</td>
                            </tr>
                            <tr> 
                                <td class=title>ȯ�޿����ݾ�</td>
                                <td colspan="5"> 
                                <input type='text' size='10' name='rtn_est_amt' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                                �� <font color="#999999">(=�Ѻ����-�Ѱ�������-��ȸ�����)</font>&nbsp;&nbsp;
                                ȯ�ޱݰ� ��ġ
                                <input type="checkbox" name="rtn_chk" value="Y" onClick="javascript:Rtn_chk();">
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
    <tr id="tr_cls3" style="display:''"> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ȯ��</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                              <td class=title width=17%>ȯ�ޱ�</td>
                              <td width=14%> 
                                <input type='text' name='rtn_amt' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_dif();'>
                                ��</td>
                              <td class=title width=14%>�Ա�����</td>
                              <td width=18%> 
                                <input type='text' size='11' name='rtn_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                              </td>
                              <td class=title width=14%>����</td>
                              <td width=23%> 
                                <input type='text' name='dif_amt' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                                ��</td>
                            </tr>
                            <tr> 
                              <td class=title>����</td>
                              <td colspan="5"> 
                                <input type="text" name="dif_cau" size="120" value="" class="text" style='IME-MODE: active'>
                              </td>
                            </tr>
                            <tr> 
                              <td class=title>�ڵ���ǥ ��������</td>
                              <td colspan="5"> 
                     			 <input type="radio" name="acct_code" value="10300" <%if(ins.getIns_com_id().equals("0007")){%>checked<%}%>>���뿹��
        			 			 <input type="radio" name="acct_code" value="12000" <%if(ins.getIns_com_id().equals("0008")||ins.getIns_com_id().equals("0038")){%>checked<%}%>>�̼���
                              </td>
                            </tr>							
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a> 
        <%}%>
      </td>
    </tr>
</table>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</form>
<script language='javascript'>
<!--
	set_tot_use();
//-->
</script>
</body>
</html>
