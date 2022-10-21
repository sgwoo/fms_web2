<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.cls.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_db" scope="page" class="acar.stat_credit.CreditDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	//�˻�����
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	//��� ����� ����Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	//�������ڵ�	
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();

	//�⺻����
	Hashtable fee_base = af_db.getFeebasecls3(m_id, l_cd);

	//�뿩������ ����
	int scd_size = Integer.parseInt(a_db.getFeeScdYn(m_id, l_cd, "1"));

	//�뿩�������� ��ü����Ʈ
	Vector fee_scd = af_db.getFeeScdDly(m_id);
	int fee_scd_size = fee_scd.size();

	//��������
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	String cls_st = cls.getCls_st();
	
	int pp_amt = AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT"));
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(m_id, l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<!--<link rel=stylesheet type="text/css" href="../../include/table.css">-->
<link rel=stylesheet type="text/css" href="../../include/table_p.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.cls_dt.value == ''){ alert('�������ڸ� �Է��Ͻʽÿ�'); fm.cls_dt.focus(); return;	}
		if(!max_length(fm.cls_cau.value, 400)){ alert('���������� ���� 400��, �ѱ� 200�ڱ��� �Է��� �� �ֽ��ϴ�'); fm.cls_cau.focus(); return; }
			
		if(!confirm('�����Ͻðڽ��ϱ�?'))
			return;

		fm.target='i_no';
		fm.action='cls_u_a.jsp';
		fm.submit();		
	}
	
	//���÷��� Ÿ��
	function cls_display2(){
		var fm = document.form1;
		if(fm.cls_st.value == '�ߵ��ؾ�' && fm.cls_doc_yn.options[fm.cls_doc_yn.selectedIndex].value == 'Y'){ //���꼭 ���� 
			tr_default.style.display	= 'block';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';			
		}else{
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';			
		}
	}

	//���÷��� Ÿ��
	function cancel_display(){
		var fm = document.form1;
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'Y'){
			td_cancel_y.style.display	= 'block';
			td_cancel_n.style.display 	= 'none';
		}else{
			td_cancel_y.style.display	= 'none';
			td_cancel_n.style.display 	= 'block';
		}
		set_b_amt();
	}	
	
	//���̿�Ⱓ ����
	function set_day(){
		var fm = document.form1;	
		if(fm.cls_dt.value == ''){ alert('�������ڸ� �Է��Ͻʽÿ�'); fm.cls_dt.focus(); return;	}
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}					
//		fm.action='./cls_nodisplay.jsp';
		fm.action='./cls_settle_nodisplay.jsp';		
		fm.target='i_no';
		fm.submit();
	}

	
	//�����ݾ����� ����
	function set_a_amt(){
		var fm = document.form1;	
		var ifee_tm = 0;
		var pay_tm = 0;
		//�ܿ����ô뿩��
		if(fm.ifee_s_amt.value != '0'){
			ifee_tm = toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value)) ;
			pay_tm = toInt(fm.con_mon.value)-ifee_tm;
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= toInt(fm.r_mon.value)-pay_tm;
				fm.ifee_day.value 	= fm.r_day.value;
			}
			var ifee_ex_amt = 0;
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
		}		
		if(fm.pded_s_amt.value == '0'){
			fm.tpded_s_amt.value 		= 0;
			fm.rfee_s_amt.value 		= 0;
		}else{		
			if(fm.pp_s_amt.value != '0'){		
				fm.pded_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
				fm.tpded_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}

		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
		set_cls_amt();		
	}
	//�̳��Աݾ����� ����
	function set_b_amt(){
		var fm = document.form1;
		fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));		
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );		
		var no_v_amt =0;
	//	if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'N'){
			no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) - toInt(parseDigit(fm.rifee_s_amt.value));
	//	}else{
	//		no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value));
	//	}		
		var no_v_amt2 				= no_v_amt.toString();
		var len 					= no_v_amt2.length;
		no_v_amt2 					= no_v_amt2.substring(0, len-1);
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.etc5_amt.value)));
		set_cls_amt();
	}	
	//���������Ͻ� �ݾ� ����
	function set_c_amt(){
		var fm = document.form1;	
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.etc5_amt.value)));
		set_cls_amt();
	}				
	//���������Ͻ� �ݾ� ����
	function set_cls_amt(){
		var fm = document.form1;	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)) );
	}		
//-->
</script>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 10.0; //��������   
		factory.printing.rightMargin 	= 10.0; //��������
		factory.printing.topMargin 	= 5.0; //��ܿ���    
		factory.printing.bottomMargin 	= 5.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}

</script>

</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<form name='form1' method='post' action='cls_u_a.jsp'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='rent_way' value='<%=fee_base.get("RENT_WAY")%>'>
<input type='hidden' name='con_mon' value='<%=fee_base.get("TOT_CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
<input type='hidden' name='fee_chk' value='<%=fee_base.get("FEE_CHK")%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 

  <table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr align="center"> 
      <td colspan="2"><font color="#006600">&lt; ���뿩 <%=cls.getCls_st()%> ���꼭 &gt;</font></td>
    </tr>  
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>����ȣ</td>
            <td width="15%"><%=l_cd%></td>
            <td width='10%' class='title'>��ȣ</td>
            <td colspan="3"><%=fee_base.get("FIRM_NM")%></td>
            <td class='title' width="10%">������</td>
            <td width="15%"><%=fee_base.get("CLIENT_NM")%></td>
          </tr>
          <tr> 
            <td class='title' width="10%">������ȣ</td>
            <td width="15%"><font color="#000099"><b><%=fee_base.get("CAR_NO")%></b></font></td>
            <td width='10%' class='title'>����</td>
            <td colspan="3"><%=fee_base.get("CAR_NM")%></td>
            <td class='title' width="10%">���ʵ����</td>
            <td><%=fee_base.get("INIT_REG_DT")%></td>
          </tr>
          <tr> 
            <td class='title' width="10%">�뿩���</td>
            <td width="15%"><font color="#000099"> 
              <%if(fee_base.get("RENT_WAY").equals("1")){%>
              �Ϲݽ� 
              <%}else if(fee_base.get("RENT_WAY").equals("2")){%>
              ����� 
              <%}else{%>
              �⺻�� 
              <%}%>
              </font></td>
            <td class='title' width="10%">�뿩�Ⱓ</td>
            <td colspan="3"><%=fee_base.get("RENT_START_DT")%>~&nbsp; 
              <%if(fee_base.get("RENT_ST").equals("1")){ out.println(fee_base.get("RENT_END_DT")); }else{ out.println(fee_base.get("EX_RENT_END_DT")); }%>
            </td>
            <td class='title' width="10%">���Ⱓ</td>
            <td><%=fee_base.get("TOT_CON_MON")%> ����</td>
          </tr>
          <tr> 
            <td class='title' width="10%">���뿩��</td>
            <td width="15%"> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_FEE_AMT")))%> 
              <%}%>
              ��</td>
            <td class='title' width="10%">������</td>
            <td width="15%"> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("PP_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_PP_AMT"))%> 
              <%}%>
              ��</td>
            <td class='title' width="10%">���ô뿩��</td>
            <td width="15%"> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("IFEE_AMT"))%> 
              <%}else{%>
              <%//=AddUtil.parseDecimal((String)fee_base.get("EX_IFEE_AMT"))%>
			  <%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>  
              <%}%>
              ��</td>
            <td class='title' width="10%">������</td>
            <td> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("GRT_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_GRT_AMT"))%> 
              <%}%>
              ��</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp; </td>
    </tr>
    <tr>
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>��������</td>
            <td width="40%"><%=cls.getCls_st()%> 
            </td>
            <td width='10%' class='title'>������</td>
            <td width="15%"> 
              <%=cls.getCls_dt()%>
            </td>
            <td class='title' width="10%">�̿�Ⱓ</td>
            <td width="15%"> 
              <%=cls.getR_mon()%>
              ���� 
              <%=cls.getR_day()%>
              ��</td>
          </tr>
		  <!--
          <tr> 
            <td width='10%' class='title'>�������� </td>
            <td colspan="5"> 
              <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cls.getCls_cau()%></textarea>
            </td>
          </tr>
          <tr> 
            <td width='10%' class='title'>������<br>
              ���Թ��</td>
            <td> 
              <select name="pp_st">
                <option value='1' <% if(cls.getPp_st().equals("1")){%>selected<%}%>>3����ġ 
                �뿩�� ������</option>
                <option value='2' <% if(cls.getPp_st().equals("2")){%>selected<%}%>>���� 
                ������ ������</option>
              </select>
            </td>
            <td class='title'>���꼭<br>
              �ۼ����� </td>
            <td> 
              <select name="cls_doc_yn" onChange='javascript:cls_display2()' <%if(!cls.getCls_st().equals("�ߵ��ؾ�"))%>disabled<%%>>
                <option value="N" <% if(cls.getCls_doc_yn().equals("N")){%>selected<%}%>>����</option>
                <option value="Y" <% if(cls.getCls_doc_yn().equals("Y")){%>selected<%}%>>����</option>
              </select>
            </td>
            <td class='title'>�ܿ�������<br>
              ������ҿ���</td>
            <td> <select name="cancel_yn" onChange='javascript:cancel_display()'>
                <option value="N" <% if(cls.getCancel_yn().equals("N")){%>selected<%}%>>��������</option>
                <option value="Y" <% if(cls.getCancel_yn().equals("Y")){%>selected<%}%>>�������</option>
              </select></td>			
          </tr>-->
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp; </td>
    </tr>	
    <!--�ߵ�����-->
    <tr id=tr_default style='display:<%if((cls.getCls_st().equals("�ߵ��ؾ�") || cls.getCls_st().equals("��ุ��") ||  cls.getCls_st().equals("����Ʈ����") ) && cls.getCls_doc_yn().equals("Y")  ) {%>block<%}else{%>none<%}%>'> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td colspan="2"> 1. �����ݾ� ���� </td>
          </tr>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' align='right' colspan="3">�׸�</td>
                  <td class='title' width='35%' align="center">����</td>
                  <td class='title' width="35%">���</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="7">ȯ<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td class='title' colspan="2">������(A)</td>
                  <td width="35%" class='title' > 
                    <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    ��</td>
                  <td class='title'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td cwidth="15%" align="center" width="20%">����Ⱓ</td>
                  <td width="35%" align="center"> 
                    <input type='text' size='3' name='ifee_mon' value='<%=cls.getIfee_mon()%>' class='num' maxlength='4' onBlur='javascript:set_b_amt();'>
                    ����&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='ifee_day' value='<%=cls.getIfee_day()%>' class='num' maxlength='4' onBlur='javascript:set_b_amt();'>
                    ��</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td cwidth="15%" align="center" width="20%">����ݾ�</td>
                  <td width="35%" align="center"> 
                    <input type='text' name='ifee_ex_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    ��</td>
                  <td>=���ô뿩�᡿����Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ���ô뿩��(B)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    ��</td>
                  <td class='title'>=���ô뿩��-����ݾ�</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��</td>
                  <td align='center' width="20%">�������� </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='pded_s_amt' value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    ��</td>
                  <td>=�����ݡ����Ⱓ</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">������ �����Ѿ� </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    ��</td>
                  <td>=�������ס����̿�Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ������(C)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    ��</td>
                  <td class='title'>=������-������ �����Ѿ�</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">��</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='c_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title'>=(A+B+C)</td>
                </tr>
              </table>			
            </td>
          </tr>
          <tr> 
            <td align=''left> 2. �̳��Աݾ� ����</td>
          </tr>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class="title" colspan="4">�׸�</td>
                  <td class="title" width='35%'> ����</td>
                  <td class="title" width='35%'>���</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="19" width="5%">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td colspan="3" class="title">���·�/��Ģ��(D)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='fine_amt' value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_c_amt();'>
                    �� </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="3" class="title">�ڱ��������ظ�å��(E)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='car_ja_amt' value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_c_amt();'>
                    �� </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                   <td class="title" rowspan="5" width="5%"><br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">������</td>
                  <td align="center">&nbsp; 
                    <input type='text' name='ex_di_amt' value='<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_b_amt();'>
                  ��&nbsp; </td>
                  <td width='35%'>&nbsp; </td>
                </tr>
                <tr> 
                  <td rowspan="2" align="center" width="10%">�̳���</td>
                  <td width='10%' align="center">�Ⱓ</td>
                  <td align="center"> &nbsp; 
                    <input type='text' size='4' name='nfee_mon' value='<%=cls.getNfee_mon()%>' class='num' maxlength='4'>
                    ���� 
                    <input type='text' size='4' name='nfee_day' value='<%=cls.getNfee_day()%>' class='num' onBlur='javascript:set_b_amt();' maxlength='4'>
                  ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">�ݾ�</td>
                  <td align="center"> 
                    <input type='text' size='15' name='nfee_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_b_amt();'>
                  ��</td>
                  <td width='35%'>���� ���ݰ�꼭 ����</td>
                </tr>
                <tr> 
                  <td colspan="2" align="center">��ü��</td>
                  <td align="center"> 
                    <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(cls.getDly_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_b_amt();'>
                  �� </td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">�뿩��(F)</td>
                  <td class='title' align="center">
                    <input type='text' name='d_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                  �� </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td rowspan="6" class="title">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">�뿩���Ѿ�</td>
                  <td align="center"> 
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_b_amt();'>
                  ��</td>
                  <td width='35%'>=������+���뿩���Ѿ�</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">���뿩��(ȯ��)</td>
                  <td align="center"> 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_b_amt();'>
                  ��</td>
                  <td width='35%'>=�뿩���Ѿס����Ⱓ</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��뿩���Ⱓ</td>
                  <td align="center"> 
                    <input type='text' name='rcon_mon' size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4'>
                    ���� 
                    <input type='text' name='rcon_day' size='3' value='<%=cls.getRcon_day()%>' class='num' maxlength='4' onBlur='javascript:set_b_amt();'>
                  ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
                  <td align="center"> 
                    <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_b_amt();'>
                  ��&nbsp;</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">����� �������</td>
                  <td align="center"> 
                    <input type='text' name='dft_int' value='<%=cls.getDft_int()%>' size='5' class='num' onBlur='javascript:set_b_amt()' maxlength='4'>
                  %</td>
                  <td width='35%'>�ܿ��Ⱓ �뿩�� �Ѿ� ����</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">�ߵ����������(G)</td>
                  <td class='title' align="center"> 
                    <input type='text' name='dft_amt' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_b_amt();'>
                  ��&nbsp;</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                         
                <tr> 
                 <td class="title" rowspan="6" width="5%"><br>
                    ��<br>
                    Ÿ</td> 
                  <td colspan="2" class="title">����ȸ�����ֺ��(H)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='etc_amt' value='<%=AddUtil.parseDecimal(cls.getEtc_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_c_amt();'>
                    �� </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">����ȸ���δ���(I)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='etc2_amt' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_c_amt();'>
                    �� </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">������������(J)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='etc3_amt' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_c_amt();'>
                    �� </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">��Ÿ���ع���(K)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='etc4_amt' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_c_amt();'>
                    �� </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">��Ÿ(L)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='etc5_amt' value='<%=AddUtil.parseDecimal(cls.getEtc5_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_c_amt();'>
                    �� </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr> 
                <tr> 
                  <td colspan="2" class="title">�ΰ���(M)</td>
                  <td class='title' align="center"> 
                    <input type='text' name='no_v_amt' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_c_amt();'>
                  �� </td>
                  <td class='title' width='35%'><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td id=td_cancel_n style='display:block' class='title'>=(�̳��Աݾ�-B-C)��10% 
                        </td>
                        <td id=td_cancel_y style='display:none' class='title'>=(�̳��Աݾ�-B-C)��10%
                        </td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">��(J)</td>
                  <td class='title' align="center"> 
                    <input type='text' name='fdft_amt1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                  �� </td>
                  <td class='title' width='35%'>=(D+E+F+G+H+I+J+K+L+M)</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td> 3. �������� �����Ͻ� �ݾ�</td>
          </tr>
          <tr> 
            <td class="line"> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%">�� ��</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt2' value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>'size='15' class='num' maxlength='15'>
                  �� </td>
                  <td class='title' width="35%"> =�̳��Աݾװ�-ȯ�ұݾװ�</td>
                </tr>
              </table>
            </td>
          </tr>
          <%	//���ຸ������
				ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);%>
          <tr> 
            <td  colspan="2" align=''left> 4. �������� ����</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%"> 
                    <%if(gins.getGi_amt() > 0){%>
                    ���� 
                    <%}else{%>
                    �̰��� 
                    <%}%>
                  </td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' maxlength='15'>
                    ��</td>
                  <td class='title' width="35%"></td>
                </tr>
              </table>
            </td>
          </tr>
	  <tr> 
           <td colspan="2">&nbsp; </td>
          </tr>
    	  
	 <tr> 
           <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Աݰ���</span>&nbsp;&nbsp;&nbsp;* �������� 140-004-023871 (��)�Ƹ���ī</td>
          </tr>	
    	  
          <tr id=tr_cls2 style='display:none'> 
            <td align='left' ><<���곻��>> </td>
          </tr>
          <tr id=tr_cls3 style='display:none'> 
            <td width='800' class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width="20%"> DC</td>
                  <td  colspan="3"> 
                    <input type='text' name='fdft_dc_amt' value='<%=AddUtil.parseDecimal(cls.getFdft_dc_amt())%>' size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                </tr>
                <tr> 
                  <td class='title' width="20%"> ���ް�</td>
                  <td width="30%"> 
                    <input type='text' name='cls_s_amt' value='<%=AddUtil.parseDecimal(cls.getCls_s_amt())%>' size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                  <td class='title' width="20%"> �ΰ���</td>
                  <td width="30%"> 
                    <input type='text' name='cls_v_amt' value='<%=AddUtil.parseDecimal(cls.getCls_v_amt())%>' size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                </tr>
                <tr> 
                  <td class='title' width="20%">��������޿����� </td>
                  <td width="30%"> 
                    <input type='text' name='cls_est_dt' size='10' class='text' value='<%=AddUtil.ChangeDate2(cls.getCls_est_dt())%>' onBlur='javascript: this.value = ChangeDate(this.value)'>
                  </td>
                  <td class='title' width="20%"> ���ݰ�꼭������</td>
                  <td width="30%"> 
                    <input type='text' name='ext_dt' value='<%=AddUtil.ChangeDate2(cls.getExt_dt())%>' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                    <select name='ext_id'>
                      <option value=''>�����</option>
                      <%if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	
						%>
                      <option value='<%= user.get("USER_ID") %>' <%if(cls.getExt_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
                      <%	}
					  }	%>
                    </select>
                  </td>
                </tr>
                <tr> 
                  <td class='title' width="20%"> ����ݸ������� </td>
                  <td colspan="3">���� 
                    <input type='checkbox' name='no_dft_yn' onClick='check_free()' <%if(cls.getNo_dft_yn().equals("Y"))%> checked <%%> value="Y">
                    &nbsp;&nbsp;��������: 
                    <textarea name='no_dft_cau' rows='2' cols='80'><%=cls.getNo_dft_cau()%></textarea>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          
		  <!--
          <%if(fee_scd_size>0){%>
          <tr> 
            <td align='left' > <<��ü����Ʈ>> </td>
          </tr>
          <tr> 
            <td width='500' class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width="100">ȸ��</td>
                  <td class='title' width="110">����</td>
                  <td class='title' width="200">���뿩��</td>
                  <td class='title' width="150">��ü�ϼ�</td>
                  <td class='title' width="150">��ü��</td>
                  <td class='title' width="90">����</td>
                </tr>
                <%for(int i = 0 ; i < fee_scd_size ; i++){
		  			FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);%>
                <tr> 
                  <td width="100" align="center"> 
                    <%if(a_fee.getTm_st1().equals("0")){%>
                    <%=a_fee.getFee_tm()%> 
                    <%}%>
                  </td>
                  <td width="110" align="center"> 
                    <%if(a_fee.getTm_st1().equals("0")){%>
                    �뿩�� 
                    <%}else{%>
                    �ܾ� 
                    <%}%>
                  </td>
                  <td width="200" align='right'><%=AddUtil.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>��&nbsp;</td>
                  <td width="150" align="center"><%=a_fee.getDly_days()%>��</td>
                  <td width="150" align='right'><%=AddUtil.parseDecimal(a_fee.getDly_fee())%>��&nbsp;</td>
                  <td align="center" width="90"> 
                    <input type='checkbox' name='dly_chk' value='<%=a_fee.getRent_st()+a_fee.getFee_tm()+a_fee.getTm_st1()%>'>
                  </td>
                </tr>
                <%}%>
              </table>
            </td>
          </tr>
          <%}%>
		  -->
          <%if(1!=1){
		  	Vector cls_scd = as_db.getClsScd(m_id, l_cd);
			int cls_scd_size = cls_scd.size();
			if(cls_scd_size>0){%>
          <tr> 
            <td align='left' > <<�ߵ���������� ������ ����Ʈ>> </td>
          </tr>
          <tr> 
            <td width='100%' class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td width='100' class='title'>����</td>
                  <td width='110' class='title'>�Աݿ�����</td>
                  <td width='200' class='title'>���ް�</td>
                  <td width='150' class='title'>�ΰ���</td>
                  <td width="74" class='title'>������</td>
                  <td width='75' class='title'>�Ա����� </td>
                  <td width='150' class='title'>���Աݾ�</td>
                </tr>
                <%for(int i = 0 ; i < cls_scd_size ; i++){
					ClsScdBean cls2 = (ClsScdBean)cls_scd.elementAt(i);%>
                <tr> 
                  <td align='center'><%=i+1%></td>
                  <td align='center'><%=cls2.getCls_est_dt()%></td>
                  <td align='right'><%=Util.parseDecimal(cls2.getCls_s_amt())%>��</td>
                  <td align='right'><%=Util.parseDecimal(cls2.getCls_v_amt())%>��</td>
                  <td align='right'><%=Util.parseDecimal(cls2.getCls_s_amt()+cls2.getCls_v_amt())%>��</td>
                  <td align='center'><%=cls2.getPay_dt()%></td>
                  <td align='right'><%=Util.parseDecimal(cls2.getPay_amt())%>��</td>
                </tr>
                <%}%>
              </table>
            </td>
          </tr>
          <%}}%>
          <%if(1!=1){
		  	Vector cre_scd = cr_db.getCreditScd(m_id, l_cd);
			int cre_scd_size = cre_scd.size();
			if(cre_scd_size>0){%>
          <tr> 
            <td align='left' > <<���ó�� ����Ʈ>> </td>
          </tr>
          <tr> 
            <td width='100%' class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td width="100" class='title'>����</td>
                  <td width="110" class='title'>ä�Ǳ���</td>
                  <td width="200" class='title'>��ձ���</td>
                  <td width="150" class='title'>ȸ��</td>
                  <td width="150" class='title'>�ݾ�</td>
                </tr>
                <%for(int i = 0 ; i < cre_scd_size ; i++){
					Hashtable cre = (Hashtable)cre_scd.elementAt(i);
					String credit = (String)cre.get("CREDIT");%>
                <tr> 
                  <td align='center'><%=i+1%></td>
                  <td align='center'><%=cre.get("CLS_GUBUN")%></td>
                  <td align='center'><%=cre.get("CREDIT_ST")%></td>
                  <td align='center'><%=cre.get("TM")%><%=cre.get("TM_ST")%>ȸ</td>
                  <td align='right'><%=Util.parseDecimal(String.valueOf(cre.get("AMT")))%>��&nbsp;&nbsp;</td>
                </tr>
                <%}%>
              </table>
            </td>
          </tr>
          <%}}%>
        </table>
      </td>
    </tr>
    <tr id=tr_brch style='display:<%if(cls.getCls_st().equals("�����Һ���")) {%>block<%}else{%>none<%}%>'> 
      <td> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td align='left' > <<�����Һ���>> </td>
          </tr>
          <tr> 
            <td width='500' class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width="100">����������</td>
                  <td width="160"><%=c_db.getNameById(cls.getP_brch_cd(), "BRCH")%>(<%=fee_base.get("BRCH_ID")%>) 
                  </td>
                  <td class='title' width="100">�̰���������</td>
                  <td width="160">
                    <select name='new_brch_cd'>
                      <option value=''>����</option>
                      <%if(brch_size > 0)	{
						for(int i = 0 ; i < brch_size ; i++){
							Hashtable branch = (Hashtable)branches.elementAt(i);		%>
                      <option value='<%=branch.get("BR_ID")%>' <%if(cls.getNew_brch_cd().equals(branch.get("BR_ID")))%>selected<%%>><%= branch.get("BR_NM")%></option>
                      <%	}
					  }	%>
                    </select>
                  </td>
                  <td class='title' width="100">�̰�����</td>
                  <td width="180">
                    <input type='text' name='trf_dt' size='10' value='<%=cls.getTrf_dt()%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr id=tr_opt style='display:<%if(cls.getCls_st().equals("���Կɼ�")) {%>block<%} else{%>none<%}%>'> 
      <td> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td align='left' > <<���Կɼ�>> </td>
          </tr>
          <tr> 
            <td width='500' class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width="100">���Կɼ���</td>
                  <td width="70">
                    <input type='text' name='opt_per' value='<%=cls.getOpt_per()%>' size='5' class='num' maxlength='4'>
                    %</td>
                  <td class='title' width="100">���Կɼǰ�</td>
                  <td width="130">
                    <input type='text' name='opt_amt'size='15' class='num' maxlength='15' value="<%=AddUtil.parseDecimal(cls.getOpt_amt())%>">
                    ��</td>
                  <td class='title' width="100">��������</td>
                  <td width="100">
                    <input type='text' name='opt_dt' size='10' value='<%=cls.getOpt_dt()%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                  </td>
                  <td class='title' width="100">���������</td>
                  <td width="100">
                    <select name='opt_mng'>
                      <option value=''>�����</option>
                      <%if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	
						%>
                      <option value='<%= user.get("USER_ID") %>' <%if(cls.getOpt_mng().equals(user.get("USER_ID")))%>selected<%%>><%= user.get("USER_NM")%></option>
                      <%	}
						}		%>
                    </select>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
	
  </table>
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));		
	}
//-->
</script>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>