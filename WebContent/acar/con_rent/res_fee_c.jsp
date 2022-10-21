<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt 		= request.getParameter("end_dt")	==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String s_brch 		= request.getParameter("s_brch")	==null?"":request.getParameter("s_brch");
	String s_bus 		= request.getParameter("s_bus")		==null?"":request.getParameter("s_bus");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String idx 		= request.getParameter("idx")		==null?"":request.getParameter("idx");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String s_cd 		= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	auth_rw = rs_db.getAuthRw(user_id, "02", "02", "02");
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	String rent_st = rc_bean.getRent_st();
	String use_st  = rc_bean.getUse_st();	
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	//�ܱ�뿩����
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	//����������
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	//�ܱ�뿩��������
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);	
	//������
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
		
	Vector conts = rs_db.getScdRentList(s_cd, "");
	int cont_size = conts.size();
	
	int ext_pay_rent_s_amt = 0;
	int ext_pay_rent_v_amt = 0;
	if(cont_size > 0){
		for(int i = 0 ; i < cont_size ; i++){
    			Hashtable sr = (Hashtable)conts.elementAt(i);
    			if(String.valueOf(sr.get("RENT_ST")).equals("5")){
    				ext_pay_rent_s_amt = ext_pay_rent_s_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    				ext_pay_rent_v_amt = ext_pay_rent_v_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    			}
    		}
    	}	
%>

<html>
<head><title>FMS</title>
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function change_scd(cmd, idx){

		var fm = document.form1;
		var i_fm = i_in.form1;

		fm.cmd.value = cmd;

		if(idx == 0 && i_fm.c_size.value == '0'){
			fm.est_dt.value 	= i_fm.est_dt.value;
			fm.rent_s_amt.value 	= i_fm.rent_s_amt.value;			
			fm.rent_v_amt.value 	= i_fm.rent_v_amt.value;			
			fm.rent_amt.value 	= i_fm.rent_amt.value;			
			fm.pay_dt.value 	= i_fm.pay_dt.value;
			fm.pay_amt.value	= i_fm.pay_amt.value;
			fm.rest_amt.value	= i_fm.rest_amt.value;			
			fm.rent_st.value	= i_fm.rent_st.value;			
			fm.paid_st.value	= i_fm.paid_st.value;			
			fm.tm.value		= i_fm.tm.value;
			fm.ext_seq.value	= i_fm.ext_seq.value;
		}else{
			fm.est_dt.value 	= i_fm.est_dt[idx].value;
			fm.rent_s_amt.value 	= i_fm.rent_s_amt[idx].value;			
			fm.rent_v_amt.value 	= i_fm.rent_v_amt[idx].value;			
			fm.rent_amt.value 	= i_fm.rent_amt[idx].value;
			fm.pay_dt.value 	= i_fm.pay_dt[idx].value;
			fm.pay_amt.value	= i_fm.pay_amt[idx].value;
			fm.rest_amt.value	= i_fm.rest_amt[idx].value;		
			fm.rent_st.value	= i_fm.rent_st[idx].value;
			fm.paid_st.value	= i_fm.paid_st[idx].value;				
			fm.tm.value		= i_fm.tm[idx].value;
			fm.ext_seq.value	= i_fm.ext_seq[idx].value;
		}		


		if(cmd == 'p'){ //�Ա�ó��:�Ա�����,���Աݾ�,�Աݿ�����
			if(replaceString("-","",fm.pay_dt.value) == ""){			alert('�Ա������� Ȯ���Ͻʽÿ�');	return;	}
			if((fm.pay_amt.value == '')||(fm.pay_amt.value == '0')){		alert('���Աݾ��� Ȯ���Ͻʽÿ�');	return;	}
			if(replaceString("-","",fm.est_dt.value) == ""){			alert('�Աݿ������� Ȯ���Ͻʽÿ�');	return;	}									
			if(!confirm('�Ա� ó�� �Ͻðڽ��ϱ�?')){
				return;
			}		
		}else if(cmd == 'c'){//�Ա����:�Ա�����,���Աݾ� null
			if(!confirm('�Ա� ��� ó�� �Ͻðڽ��ϱ�?')){
				return;
			}
			fm.pay_amt.value = '0';
			fm.pay_dt.value = '';
		}else if(cmd == 'a'){//�߰�
			if(replaceString("-","",fm.est_dt.value) == ""){			alert('�Աݿ����ϸ� Ȯ���Ͻʽÿ�');	return;	}
			if(fm.rent_st.value == ""){						alert('��ݱ����� �����Ͻʽÿ�.'); 	return; }
			fm.c_size.value = i_fm.c_size.value;
			if(!confirm('�߰� �Ͻðڽ��ϱ�?')){
				return;
			}
		}else if(cmd == 'u'){//����		
			if(!confirm('���� �Ͻðڽ��ϱ�?')){
				return;
			}
		}else{//����
			if(!confirm('���� �Ͻðڽ��ϱ�?')){
				return;
			}
		}

		fm.action='mod_scd_u.jsp';
		fm.target = 'i_no';
		fm.submit();		
	}	
			
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		if(fm.from_page.value ==''){
			fm.action='res_fee_frame_s.jsp';
		}else{
			fm.action='res_scd_frame.jsp';
		}
		fm.target = 'd_content';
		fm.submit();		
	}
	
	function RentMemo(){
		var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>&user_id=<%=user_id%>";	
		window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");
	}	
	
	function RentMove(){
		var fm = document.form1;
		if('<%=use_st%>' =='1'){	//����
			fm.action='/acar/res_stat/res_rent_u.jsp';
		}else if('<%=use_st%>' =='2'){	//����
			fm.action='/acar/rent_mng/res_rent_u.jsp';
		}else if('<%=use_st%>' =='3'){	//����
			fm.action='/acar/rent_mng/res_rent_u.jsp';
		}else if('<%=use_st%>' =='4'){	//����
			fm.action='/acar/rent_end/rent_settle_u.jsp';
		}else if('<%=use_st%>' =='5'){	//���
			fm.action='/acar/rent_end/rent_settle_u.jsp';
		}
		fm.target = 'd_content';
		fm.submit();		
	}		
	
	function set_amt(obj){
		
	}
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='rent_st' value=''>
<input type='hidden' name='paid_st' value=''>
<input type='hidden' name='tm' value=''>
<input type='hidden' name='pay_yn' value=''>
<input type='hidden' name='est_dt' value=''>
<input type='hidden' name='rent_amt' value=''>
<input type='hidden' name='rent_s_amt' value=''>
<input type='hidden' name='rent_v_amt' value=''>
<input type='hidden' name='pay_dt' value=''>
<input type='hidden' name='pay_amt' value=''>
<input type='hidden' name='rest_amt' value=''>
<input type='hidden' name='ext_seq' value=''>
<input type='hidden' name='c_size' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=3>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �繫ȸ�� > ���ݰ��� > <span class=style5>�뿩��� ������ ��ȸ �� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr><td class=h></td></tr>
    <%if(!mode.equals("view")){%>
    <tr><td align=right><a href='javascript:go_to_list()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a></td></td></tr> 
    <%}%>
    <tr>
        <td class=line2 colspan=3></td>
    </tr>   
    <tr> 
        <td class='line' colspan="3"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='11%' class='title'>��౸��</td>
                    <td width="24%"><font color="#3366CC"> <b>&nbsp;
                      <%if(rent_st.equals("1")){%>
                      �ܱ�뿩 
                      <%}else if(rent_st.equals("2")){%>
                      ������� 
                      <%}else if(rent_st.equals("3")){%>
                      ������ 
                      <%}else if(rent_st.equals("4")){%>
                      �����뿩 
                      <%}else if(rent_st.equals("5")){%>
                      �������� 
                      <%}else if(rent_st.equals("6")){%>
                      �������� 
                      <%}else if(rent_st.equals("7")){%>
                      �������� 
                      <%}else if(rent_st.equals("8")){%>
                      ������
                      <%}else if(rent_st.equals("9")){%>
                      �������
                      <%}else if(rent_st.equals("10")){%>
                      ��������
                      <%}else if(rent_st.equals("12")){%>
                      ����Ʈ
                      <%}%>
        		</b></font> 
                    </td>
                    <td width='11%' class='title'>����ȣ</td>
                    <td width="18%">&nbsp;<%=rc_bean.getRent_s_cd()%></td>
                    <td class='title' width="11%">������ȣ</td>
                    <td width="25%">&nbsp;<font color="#000099"><b><%=reserv.get("CAR_NO")%></b></font></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class='title'>��ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>�����Ⱓ</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>&nbsp;~&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>                    
                    <td class='title'><%if(rent_st.equals("12")) {%>���ʿ����� <%}else{%>����� <%}%></td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
                    
                </tr>
                <%
    			if(ext_size > 0){
    				for(int i = 0 ; i < ext_size ; i++){
    					Hashtable ext = (Hashtable)exts.elementAt(i);%>	
    					
                <tr> 
                    <td class=title>���� [<%=ext.get("SEQ")%>]</td>
                    <td colspan="5">&nbsp; 
                        ������� : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_DT")))%> &nbsp;&nbsp;
                        | �뿩�Ⱓ : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_END_DT")))%> &nbsp;&nbsp;                    	
                        (<%=ext.get("RENT_MONTHS")%>����<%=ext.get("RENT_DAYS")%>��)                   	
                    </td>
                </tr>
    		  <%		
    		  		}
    		  	}%>     					
                <tr> 
                    <td class='title'>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getMng_id(), "USER")%></td>
                    <td class='title'>�����Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class='title'>�����Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>���ʾ����ð�</td>
                    <td>&nbsp;<%=rc_bean.getRent_hour()%>�ð� <%=rc_bean.getRent_days()%>�� 
                      <%=rc_bean.getRent_months()%>����</td>
                    <td class='title'>�߰��̿�ð�</td>
                    <td>&nbsp;<%=rs_bean.getAdd_hour()%>�ð� <%=rs_bean.getAdd_days()%>�� 
                      <%=rs_bean.getAdd_months()%>����</td>
                    <td class='title'>���̿�ð�</td>
                    <td>&nbsp;<%=rs_bean.getTot_hour()%>�ð� <%=rs_bean.getTot_days()%>�� 
                      <%=rs_bean.getTot_months()%>����</td>
                </tr>
                <tr> 
                    <td class='title'>���ݰ�꼭</td>
                    <td>
                      <%if(rf_bean.getTax_yn().equals("Y")){%>
                      &nbsp;���� 
                      <%}%>
                      <%if(rf_bean.getTax_yn().equals("N")){%>
                      &nbsp;�̹��� 
                      <%}%>
                    </td>
                    <td class='title'>�������</td>
                    <td> 
                      <%if(rf_bean.getPaid_way().equals("1")){%>
                      &nbsp;���� 
                      <%}%>
                      <%if(rf_bean.getPaid_way().equals("2")){%>
                      &nbsp;�ĺ� 
                      <%}%>
                    </td>
                    <td class='title'>��Ÿ</td>
                    <td>&nbsp;<%=rc_bean.getEtc()%>&nbsp; </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td align='right'><a href="javascript:RentMemo();" class="btn" title='��ȭ��������'><img src=/acar/images/center/button_th.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%if(!mode.equals("view")){%>
            <a href="javascript:RentMove();" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>
            <%}%>
    </td></tr>	    
</table>
<%if(rent_st.equals("1") || rent_st.equals("9") || rent_st.equals("12")){%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line > 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title rowspan="2" >����</td>
                    <td class=title colspan="6">���뿩��</td>
                    <td class=title width="11%">�뿩���Ѿ�</td>
                    <td class=title rowspan="2" width="8%">������</td>
                    <td class=title rowspan="2" width="8%">������</td>
                    <td class=title rowspan="2" width="11%">�Ѱ���ݾ�</td>                    
                </tr>
                <tr>
                  <td width="10%" class=title>����뿩��</td>
                  <td width="8%" class=title>D/C</td>
                  <td width="8%" class=title>������̼�</td>
                  <td width="8%" class=title>��Ÿ</td>                  
                  <td width="8%" class=title>���ú����</td>                  
                  <td width="10%" class=title>�հ�</td>                  
                  <td class=title>
                  	<input type="text" name="v_rent_months" value="<%=rc_bean.getRent_months()%>" size="1" class=whitenum>
                      	����
                      	<input type="text" name="v_rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum>
                      	��
                  </td>           
                </tr>               
                <tr> 
                    <td class=title width="10%">���ް�</td>
                    <td align="center"> 
                      <input type="text" name="inv_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td align="center"> 
                      <input type="text" name="inv_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center"> 
                      <input type="text" name="inv_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt()+rf_bean.getDc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="ins_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>            
                <tr> 
                    <td class=title colspan="2">���ʰ����ݾ�</td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(rf_bean.getF_rent_tot_amt())%>��</td>
                    <td class=title>���ʰ������</td>
                    <td colspan="8">&nbsp; 
                      <%if(rf_bean.getF_paid_way().equals("1")){%>1����ġ<%}%>
                      <%if(rf_bean.getF_paid_way().equals("2")){%>�Ѿ�<%}%>                      
                      &nbsp; / ������
                      <%if(rf_bean.getF_paid_way2().equals("1")){%>����<%}%>
                      <%if(rf_bean.getF_paid_way2().equals("2")){%>������<%}%>
                      </td>  
                </tr>
            </table>
        </td>
    </tr>
    <%if(!rs_bean.getSett_dt().equals("")){%>    
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����뿩��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>   
    <tr id=tr_sett1 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%} else{ %>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% rowspan="2" class=title>����</td>
                    <td colspan="5" class=title>���뿩��</td>
                    <td width=10% rowspan="2" class=title>�뿩���Ѿ�</td>                    
                    <td width=8% rowspan="2" class=title>������</td>
                    <td width=8% rowspan="2" class=title>������</td>
                    <td width=10% rowspan="2" class=title>�հ�<br>(���ް�)</td>
                    <td width=10% rowspan="2" class=title>�հ�<br>(VAT����)</td>
                </tr>
                <tr>
                  <td width=9% class=title>����</td>
                  <td width=8% class=title>������̼�</td>
                  <td width=9% class=title>��Ÿ</td>
                  <td width=9% class=title>���ú����</td>
                  <td width=9% class=title>�հ�</td>
                </tr>            
                <tr> 
                    <td class=title>����</td>
                    <td align="center">
                      <input type="text" name="ag_inv_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+ext_pay_rent_s_amt)%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_inv_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_inv_amt'   value='<%=rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_navi_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>'>			 
                      <input type='hidden' name='ag_navi_amt'   value='<%=rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_etc_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>'>			 
                      <input type='hidden' name='ag_etc_amt'   value='<%=rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_ins_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">
                      <input type="text" name="ag_t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getIns_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_t_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_t_fee_amt'   value='<%=rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getIns_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>                      
                    <td align="center">
                      <input type="text" name="ag_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+ext_pay_rent_s_amt)%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_fee_amt'   value='<%=rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="ag_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_cons1_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>'>			 
                      <input type='hidden' name='ag_cons1_amt'   value='<%=rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_cons2_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>'>			 
                      <input type='hidden' name='ag_cons2_amt'   value='<%=rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt()+ext_pay_rent_s_amt)%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt)%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                </tr>
                <tr>
                  <td class=title>�߰�</td> 
                    <td align="center">
                      <input type="text" name="add_inv_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_inv_s_amt())%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_inv_v_amt' value='<%=rs_bean.getAdd_inv_v_amt()%>'>
                      <input type='hidden' name='add_inv_amt' value='<%=rs_bean.getAdd_inv_s_amt()+rs_bean.getAdd_inv_v_amt()%>'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_navi_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_navi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_navi_v_amt' value='<%=rs_bean.getAdd_navi_v_amt()%>'>
                      <input type='hidden' name='add_navi_amt' value='<%=rs_bean.getAdd_navi_s_amt()+rs_bean.getAdd_navi_v_amt()%>'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_etc_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_etc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_etc_v_amt' value='<%=rs_bean.getAdd_etc_v_amt()%>'>
                      <input type='hidden' name='add_etc_amt' value='<%=rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_etc_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="add_ins_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_ins_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">
                      <input type="text" name="add_t_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_inv_s_amt()+rs_bean.getAdd_navi_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_ins_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_t_fee_v_amt' value='<%=rs_bean.getAdd_inv_v_amt()+rs_bean.getAdd_navi_v_amt()+rs_bean.getAdd_etc_v_amt()%>'>
                      <input type='hidden' name='add_t_fee_amt'   value='<%=rs_bean.getAdd_inv_s_amt()+rs_bean.getAdd_navi_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_ins_s_amt()+rs_bean.getAdd_inv_v_amt()+rs_bean.getAdd_navi_v_amt()+rs_bean.getAdd_etc_v_amt()%>'>
                    </td>                    
                    <td align="center">
                      <input type="text" name="add_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt())%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_fee_v_amt' value='<%=rs_bean.getAdd_fee_v_amt()%>'>
                      <input type='hidden' name='add_fee_amt' value='<%=rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_fee_v_amt()%>'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_cons1_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_cons1_v_amt' value='<%=rs_bean.getAdd_cons1_v_amt()%>'>
                      <input type='hidden' name='add_cons1_amt' value='<%=rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons1_v_amt()%>'>
                    </td>                      
                    <td align="center">
                      <input type="text" name="add_cons2_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_cons2_v_amt' value='<%=rs_bean.getAdd_cons2_v_amt()%>'>
                      <input type='hidden' name='add_cons2_amt' value='<%=rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_cons2_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="add_tot_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type="text" name="add_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt())%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                </tr>                  
                <tr>
                  <td class=title>����</td> 
                    <td align="center"> 
                      <input type='hidden' name='tot_inv_amt' value='0'>
                      <input type='hidden' name='tot_inv_v_amt' value='0'>
                      <input type="text" name="tot_inv_s_amt" value="0" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type="text" name="tot_navi_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_navi_v_amt' value='0'>
                      <input type='hidden' name='tot_navi_amt' value='0'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="tot_etc_s_amt" value="0" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_etc_v_amt' value='0'>
                      <input type='hidden' name='tot_etc_amt' value='0'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="tot_ins_s_amt" value="0" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_ins_v_amt' value='0'>
                      <input type='hidden' name='tot_ins_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_t_fee_s_amt" value="0" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_t_fee_v_amt' value='0'>
                      <input type='hidden' name='tot_t_fee_amt' value='0'>
                    </td>                    
                    <td align="center"> 
                      <input type='hidden' name='tot_fee_amt' value='0'>
                      <input type='hidden' name='tot_fee_v_amt' value='0'>
                      <input type="text" name="tot_fee_s_amt" value="0" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type='hidden' name='tot_cons1_amt' value='0'>
                      <input type='hidden' name='tot_cons1_v_amt' value='0'>
                      <input type="text" name="tot_cons1_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type='hidden' name='tot_cons2_amt' value='0'>
                      <input type='hidden' name='tot_cons2_v_amt' value='0'>
                      <input type="text" name="tot_cons2_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">                       
                      <input type='hidden' name='rent_tot_v_amt' value='0'>
                      <input type="text" name="rent_tot_s_amt2" value="0" size="9" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">                       
                      <input type="text" name="rent_tot_amt2" value="0" size="9" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>            
    <tr id=tr_sett3 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <tr> 
                    <td class=title width=10% rowspan="2">�δ���</td>
                    <td class=title width=9%>�����</td>
                    <td class=title width=8%>��å��</td>
                    <td class=title width=9%>������</td>
                    <td class=title width=9%>������</td>
                    <td class=title width=9%>km�ʰ�����</td>
                    <td class=title width=10%>�̼����·�</td>
                    <td class=title width=8%>-</td>
                    <td class=title width=8%>-</td>
                    <td class=title width=10%>�հ�<br>(���ް�)</td>
                    <td class=title width=10%>�հ�<br>(VAT����)</td>
                </tr>
                <tr>                  
                    <td align="center"> 
                      <input type='hidden' name='cls_amt' value='<%=rs_bean.getCls_s_amt()+rs_bean.getCls_v_amt()%>'>
                      <input type='hidden' name='cls_v_amt' value='<%=rs_bean.getCls_v_amt()%>'>
                      <input type="text" name="cls_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getCls_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      	��
                   </td>                    
                  <td align="center"><input type='hidden' name='ins_m_amt' value='<%=rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()%>'>
                    <input type='hidden' name='ins_m_v_amt' value='<%=rs_bean.getIns_m_v_amt()%>'>
                    <input type="text" name="ins_m_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>                  
                  <td align="center"><input type='hidden' name='ins_h_amt' value='<%=rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()%>'>
                    <input type='hidden' name='ins_h_v_amt' value='<%=rs_bean.getIns_h_v_amt()%>'>
                    <input type="text" name="ins_h_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_h_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>
                  <td align="center"><input type='hidden' name='oil_amt' value='<%=rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt()%>'>
                    <input type='hidden' name='oil_v_amt' value='<%=rs_bean.getOil_v_amt()%>'>
                    <input type="text" name="oil_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getOil_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>
                  <td align="center"><input type='hidden' name='km_amt' value='<%=rs_bean.getKm_s_amt()+rs_bean.getKm_v_amt()%>'>
                    <input type='hidden' name='km_v_amt' value='<%=rs_bean.getKm_v_amt()%>'>
                    <input type="text" name="km_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getKm_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>
                  <td align="center">
                    <input type="text" name="fine_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getFine_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>
		  <td align="center">-</td>	
		  <td align="center">-</td>	
                  <td align="center"><input type="text" name="etc_tot_s_amt" value="0" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>                  
                  <td align="center"><input type="text" name="etc_tot_amt" value="0" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>                  
                </tr>   
                <tr>
                    <td class=title>VAT</td>
                    <td align="center"><input type="checkbox" name="cls_vat" value="N" <%if(rs_bean.getCls_s_amt()>0 && rs_bean.getCls_v_amt()==0)%>checked<%%> onClick="javascript:set_amt(document.form1.cls_s_amt);">������</td>                    
                    <td align="center"><input type="checkbox" name="ins_m_vat" value="N" <%if(rs_bean.getIns_m_s_amt()>0 && rs_bean.getIns_m_v_amt()==0)%>checked<%%> onClick="javascript:set_amt(document.form1.ins_m_s_amt);">������</td>                    
                    <td align="center"><input type="checkbox" name="ins_h_vat" value="N" <%if(rs_bean.getIns_h_s_amt()>0 && rs_bean.getIns_h_v_amt()==0)%>checked<%%>  onClick="javascript:set_amt(document.form1.ins_h_s_amt);">������</td>
                    <td align="center"><input type="checkbox" name="oil_vat" value="N" <%if(rs_bean.getOil_s_amt()>0 && rs_bean.getOil_v_amt()==0)%>checked<%%>  onClick="javascript:set_amt(document.form1.oil_s_amt);">������</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>                 
            </table>
        </td>
    </tr>       
    <tr id=tr_sett2 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>�������</td>
                    <td class=title_p style='text-align:left'> 
                    &nbsp;<input type='text' size='12' class=num name="rent_sett_amt" value="<%=AddUtil.parseDecimal(rs_bean.getRent_sett_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                    �� (����뿩�� �հ� + �δ��� �հ�  - �Ա�ó�� �հ�, �������/�뿩������� �ջ��� ��� : �뿪��� �հ� ����)</td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr><td class=h></td></tr>
    <%}%>
<%}%>
<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line > 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>û������</td>
                    <td colspan='4'>&nbsp;1�� <%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>�� (���ް�)
                      </td>                      
                </tr>       	            
                <tr> 
                    <td class=title>����</td>                    
                    <td width="11%" class=title>�뿩���Ѿ�</td>
                    <td width="8%" class=title>������</td>
                    <td width="8%" class=title>������</td>
                    <td width="11%" class=title>�Ѱ���ݾ�</td>
                </tr>            
                <tr> 
                    <td class=title width="10%">���ް�</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr> 
            </table>
        </td>
    </tr>
<%}%>

</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݽ�����</span></td>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="res_fee_c_in.jsp?mode=<%=mode%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&rent_tot_amt=<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt()+rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_ins_s_amt()+rs_bean.getAdd_ins_v_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_etc_v_amt()+rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()+rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()+rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt())%>&brch_id=<%=rc_bean.getBrch_id()%>" name="i_in" width="100%" height="<%=30*(cont_size+3)%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--

	var fm = document.form1;	
	
	<%if(rc_bean.getUse_st().equals("4")){%>
	if('<%=rent_st%>' == '1' || '<%=rent_st%>' == '9' || '<%=rent_st%>' == '12'){
	
		//����		
		
		fm.tot_inv_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_s_amt.value)) 	+ toInt(parseDigit(fm.add_inv_s_amt.value))	);
		fm.tot_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_fee_s_amt.value))	);
		fm.tot_t_fee_s_amt.value= parseDecimal( toInt(parseDigit(fm.ag_t_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_s_amt.value))	);
		fm.tot_navi_s_amt.value = parseDecimal( toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value))	);
		fm.tot_etc_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.add_etc_s_amt.value))	);
		fm.tot_ins_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.tot_cons1_s_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_s_amt.value))	);
		fm.tot_cons2_s_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons2_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_s_amt.value))	);
		
		fm.tot_inv_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_v_amt.value)) 	+ toInt(parseDigit(fm.add_inv_v_amt.value))	);
		fm.tot_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_fee_v_amt.value))	);
		fm.tot_t_fee_v_amt.value= parseDecimal( toInt(parseDigit(fm.ag_t_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_v_amt.value))	);
		fm.tot_navi_v_amt.value = parseDecimal( toInt(parseDigit(fm.ag_navi_v_amt.value)) 	+ toInt(parseDigit(fm.add_navi_v_amt.value))	);
		fm.tot_etc_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_etc_v_amt.value)) 	+ toInt(parseDigit(fm.add_etc_v_amt.value))	);
		fm.tot_cons1_v_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons1_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_v_amt.value))	);
		fm.tot_cons2_v_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons2_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_v_amt.value))	);		

		fm.tot_inv_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_amt.value)) 		+ toInt(parseDigit(fm.add_inv_amt.value))	);
		fm.tot_fee_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.add_fee_amt.value))	);
		fm.tot_t_fee_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_t_fee_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_amt.value))	);
		fm.tot_navi_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_navi_amt.value)) 	+ toInt(parseDigit(fm.add_navi_amt.value))	);
		fm.tot_etc_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_etc_amt.value)) 		+ toInt(parseDigit(fm.add_etc_amt.value))	);
		fm.tot_ins_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.tot_cons1_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_amt.value))	);
		fm.tot_cons2_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons2_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_amt.value))	);		
		
		fm.rent_tot_s_amt2.value = parseDecimal( toInt(parseDigit(fm.tot_fee_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_s_amt.value))	);
		fm.rent_tot_amt2.value 	= parseDecimal( toInt(parseDigit(fm.tot_fee_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_amt.value))	);


		//�δ���
		fm.etc_tot_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_s_amt.value)) 		+ toInt(parseDigit(fm.ins_m_s_amt.value)) 	+ toInt(parseDigit(fm.ins_h_s_amt.value)) 	+ toInt(parseDigit(fm.oil_s_amt.value)) 	+ toInt(parseDigit(fm.km_s_amt.value))		+ toInt(parseDigit(fm.fine_s_amt.value))	);		
		fm.etc_tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_amt.value)) 		+ toInt(parseDigit(fm.ins_m_amt.value)) 	+ toInt(parseDigit(fm.ins_h_amt.value)) 	+ toInt(parseDigit(fm.oil_amt.value)) 		+ toInt(parseDigit(fm.km_amt.value))		+ toInt(parseDigit(fm.fine_s_amt.value))        );		
				
	}
	
	<%}%>

//-->
</script>
</body>
</html>
