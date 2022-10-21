<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.cls.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");

	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");

	//��� ����� ����Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();	

	//�������ڵ�
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();

	//�⺻����
	Hashtable fee_base = af_db.getFeebasecls3(m_id, l_cd);

	//�⺻����
	Hashtable base = as_db.getSettleBase(m_id, l_cd, "");

	//�뿩������ ����
	int scd_size = Integer.parseInt(a_db.getFeeScdYn(m_id, l_cd, "1"));
	
	//�뿩�������� ��ü����Ʈ
	Vector fee_scd = af_db.getFeeScdDly(m_id);
	int fee_scd_size = fee_scd.size();
	
	//�������뿩�� �� ��ü��
//	Hashtable exdi = as_db.getFeeNoAmt(m_id, l_cd);
		
	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"))+AddUtil.parseInt((String)base.get("IFEE_S_AMT"));
	int t_dly_amt = 0;
%>	

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;

		//��ุ��� �̼��� ����� ��.
/*		if(fm.cls_st.value == '1'){
			var nopay_amt = toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value));
			if(nopay_amt > 0){ 	
				if(toInt(parseDigit(fm.ex_di_amt.value)) > 0)	{ 	alert('������ �뿩�ᰡ �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if(toInt(parseDigit(fm.nfee_amt.value)) > 0)	{ 	alert('�̳��� �뿩�ᰡ �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if(toInt(parseDigit(fm.dly_amt.value)) > 0)		{ 	alert('�뿩�� ��ü�ᰡ �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if(toInt(parseDigit(fm.car_ja_amt.value)) > 0)	{ 	alert('�ڱ��������ظ�å���� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if(toInt(parseDigit(fm.fine_amt.value)) > 0)	{ 	alert('���·�/��Ģ���� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
			}
		}
*/
		//�ߵ�����,��ุ��� ��ü����Ʈ üũ ���Ѱ� �����ϰ� �������� �����Ѵ�.
/*		2005-07-18 ���� : �������� ���ó��
		if(fm.cls_st.value == '1' || fm.cls_st.value == '2'){
			var len=fm.elements.length;
			var cnt=0;
			var idnum="";
			for(var i=0 ; i<len ; i++){
				var ck=fm.elements[i];		
				if(ck.name == "dly_chk"){		
					if(ck.checked == true){
						cnt++;
						idnum+=ck.value+",";	//������ ',' ����
					}
				}
			}
			fm.dly_count.value = cnt;
			fm.dly_value.value = idnum.substring(0,idnum.lastIndexOf(","));			
		}
*/		

		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
		if(fm.cls_st.value == '2' && fm.cls_doc_yn.value == 'Y'){
			if(fm.dft_amt.value == '')			{ alert('�ߵ������������ �Է��Ͻʽÿ�'); 	fm.dft_amt.focus(); 	return; }
			else if(fm.fdft_amt1.value == '')	{ alert('�ߵ������������ �Է��Ͻʽÿ�');	fm.fdft_amt1.focus(); 	return; }
		}
		if(!max_length(fm.cls_cau.value, 400))	{ alert('���������� ���� 400��, �ѱ� 200�ڱ��� �Է��� �� �ֽ��ϴ�'); 	fm.cls_cau.focus(); 	return; }
			
		if(!confirm('ó���Ͻðڽ��ϱ�?')){ 	return; }
		
		fm.target='i_no';
//		fm.target='CLS_I';
		fm.action='cls_i_a.jsp';
		fm.submit();		
	}
	
	//���÷��� Ÿ��
	function cls_display(){
		var fm = document.form1;
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '3'){ //�����Һ��� ���ý� ���÷���
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'block';
			tr_opt.style.display 		= 'none';			
		}else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '2'){ //�ߵ����� ���ý� ���÷���
			tr_default.style.display	= 'block';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';	
			fm.cls_doc_yn.value			= 'Y';		
		}else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //���Կɼ� ���ý� ���÷���
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'block';			
		}else{
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';			
		}
	}	

	//���÷��� Ÿ��
	function cls_display2(){
		var fm = document.form1;
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '2' && fm.cls_doc_yn.options[fm.cls_doc_yn.selectedIndex].value == 'Y'){ //���꼭 ���� 
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
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[1].selected = true;
			alert('�ߵ���������ݾ��� '+fm.fdft_amt2.value+'������ ȯ���ؾ� �մϴ�. \n\n�̿� ���� ��쿡�� ������Ҹ� �����մϴ�.');
			return;			
		}		
	}	
	
	//����� �������ڷ� �ٽ� ���
	function set_day(){
		var fm = document.form1;	
		if(fm.cls_dt.value == ''){ 	alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_dt.focus(); 	return;	}
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}					
//		fm.action='./cls_nodisplay.jsp';
		fm.action='./cls_settle_nodisplay.jsp';		
		fm.target='i_no';
		fm.submit();
	}
		
	//�����ݾ� ���� : �ڵ����
	function set_cls_amt1(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.ifee_mon || obj == fm.ifee_day){ //���ô뿩�� ����Ⱓ
			if(fm.ifee_s_amt.value != '0'){		
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );		
			}
		}else if(obj == fm.ifee_ex_amt){ //���ô뿩�� ����ݾ�
			if(fm.ifee_s_amt.value != '0'){		
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );				
			}
		}else if(obj == fm.pded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		set_cls_amt();
	}		
	//�̳� �뿩�� ���� : �ڵ����
	function set_cls_amt2(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.nfee_mon || obj == fm.nfee_day){ //�̳��Դ뿩�� �Ⱓ
			if(fm.nfee_s_amt.value != '0'){		
				fm.nfee_amt.value 		= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
			}
			var no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) - toInt(parseDigit(fm.rifee_s_amt.value));
			var no_v_amt2 				= no_v_amt.toString();
			var len 					= no_v_amt2.length;
			no_v_amt2 					= no_v_amt2.substring(0, len-1);
			fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );								
		}
		fm.d_amt.value 					= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		set_cls_amt();
	}			
	//�̳� �ߵ���������� ���� : �ڵ����
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //�ܿ��뿩���Ⱓ
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			}
		}else if(obj == fm.dft_int){ //����� �������
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			}			
		}
		fm.d_amt.value 						= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		set_cls_amt();
	}				
	//�������Ͻ� �ݾ� ����
	function set_cls_amt(){
		var fm = document.form1;	
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)) );
	}	
		
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='./cls_i_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='rent_start_dt' value='<%=base.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base.get("RENT_END_DT")%>'>
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>
<input type='hidden' name='con_mon' value='<%=base.get("CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base.get("IFEE_S_AMT")%>'>
<input type='hidden' name='p_brch_cd' value='<%=l_cd.substring(0,2)%>'>
<input type='hidden' name='dly_count' value=''>
<input type='hidden' name='dly_value' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr> 
      <td><font color="navy">������������ -> </font><font color="navy">������</font> -> 
        <font color="red">������Ǻ���</font> </td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='11%' class='title'>����ȣ</td>
            <td width="15%"><%=l_cd%></td>
            <td width='10%' class='title'>��ȣ</td>
            <td><%=base.get("FIRM_NM")%></td>
            <td class='title' width="10%">������ȣ</td>
            <td width="14%"><%=base.get("CAR_NO")%></td>
            <td class='title' width="10%">����</td>
            <td width="15%"><%=base.get("CAR_NM")%></td>
          </tr>
          <tr> 
            <td class='title' width="11%">�뿩���</td>
            <td width="15%"><%=base.get("RENT_WAY")%></td>
            <td class='title' width="10%">���Ⱓ</td>
            <td colspan="5"><%=AddUtil.ChangeDate2((String)base.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String)base.get("RENT_END_DT"))%>&nbsp;(<%=base.get("CON_MON")%> 
              ����)</td>
          </tr>
          <tr> 
            <td class='title' width="11%">���뿩��</td>
            <td width="15%"><%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>��</td>
            <td class='title' width="10%">������</td>
            <td width="15%"><%=AddUtil.parseDecimal((String)base.get("PP_S_AMT"))%>��</td>
            <td class='title' width="10%">���ô뿩��</td>
            <td width="14%"><%=AddUtil.parseDecimal((String)base.get("IFEE_S_AMT"))%>��</td>
            <td class='title' width="10%">������</td>
            <td><%=AddUtil.parseDecimal((String)base.get("GRT_AMT"))%>��</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>��������</td>
            <td width="40%"> 
			  <select name="cls_st" onChange='javascript:cls_display()'>
                <option value="1">��ุ��</option>
                <option value="8">���Կɼ�</option>
                <option value="9">����</option>
                <option value="2">�ߵ��ؾ�</option>
                <option value="3">�����Һ���</option>
                <option value="4">�������������</option>
                <option value="5">����̰�</option>
                <option value="6">�Ű�</option>
                <option value="7">���������</option>
                <option value="10">����������(�縮��)</option>
              </select> </td>
            <td width='10%' class='title'>������</td>
            <td width="15%"><input type='text' name='cls_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'> 
            </td>
            <td class='title' width="10%">�̿�Ⱓ</td>
            <td width="15%"><input type='text' name='r_mon' value='<%=base.get("R_MON")%>' class='text' size="2">
              ���� 
              <input type='text' name='r_day' value='<%=base.get("R_DAY")%>' class='text' size="2">
              �� </td>
          </tr>
          <tr> 
            <td width='10%' class='title'>�������� </td>
            <td colspan="5"><textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"></textarea> 
            </td>
          </tr>
          <tr> 
            <td width='10%' class='title'>������<br>
              ���Թ��</td>
            <td> 
			  <select name="pp_st">
                <option value='' <% if(base.get("IFEE_S_AMT").equals("0") && base.get("PP_S_AMT").equals("0")){%>selected<%}%>>�ش���׾���</option>
                <option value='1' <% if(!base.get("IFEE_S_AMT").equals("0")){%>selected<%}%>>3����ġ�뿩�� 
                ������</option>
                <option value='2' <% if(!base.get("PP_S_AMT").equals("0")){%>selected<%}%>>�������� 
                ������</option>
              </select> 
			</td>
            <td class='title'>���꼭<br>
              �ۼ����� </td>
            <td> 
			  <select name="cls_doc_yn" onChange='javascript:cls_display2()'>
                <option value="N" selected>����</option>
                <option value="Y">����</option>
              </select> 
			</td>
            <td class='title'>�ܿ�������<br>
              ������ҿ���</td>
            <td> 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'>
                <option value="N">��������</option>
                <option value="Y" selected>�������</option>
              </select>
			</td>
          </tr>
        </table>
      </td>
    </tr>
    <!-- ���� -->
    <tr id=tr_default style='display:none'> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td>1. �����ݾ� ���� </td>
            <td align="right">[���ް�]</td>
          </tr>
          <tr> 
            <td  colspan="2" class='line'> <table border="0" cellspacing="1" cellpadding="0" width="100%">
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
                  <td width="35%" class='title' > <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
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
                  <td width="35%" align="center"> <input type='text' size='3' name='ifee_mon' value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    ����&nbsp;&nbsp;&nbsp; <input type='text' size='3' name='ifee_day' value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    ��</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td cwidth="15%" align="center" width="20%">����ݾ�</td>
                  <td width="35%" align="center"> <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td>=���ô뿩�᡿����Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ���ô뿩��(B)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='rifee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td class='title'>=���ô뿩��-����ݾ�</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��</td>
                  <td align='center' width="20%">�������� </td>
                  <td width='35%' align="center"> <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td>=�����ݡ����Ⱓ</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">������ �����Ѿ� </td>
                  <td width='35%' align="center"> <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td>=�������ס����̿�Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ������(C)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='rfee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td class='title'>=������-������ �����Ѿ�</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">��</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='c_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title'>=(A+B+C)</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td align=''left> 2. �̳��Աݾ� ����</td>
            <td align='right'left>[���ް�]</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class="title" colspan="4">�׸�</td>
                  <td class="title" width='35%'> ����</td>
                  <td class="title" width='35%'>���</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="15" width="5%">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td class="title" rowspan="5" width="5%"><br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">������</td>
                  <td class='' width='35%' align="center"> <input type='text' name='ex_di_amt' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_S_AMT"))+AddUtil.parseInt((String)base.get("DI_AMT2")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    ��</td>
                  <td width='35%'>&nbsp; </td>
                </tr>
                <tr> 
                  <td rowspan="2" align="center" width="5%">��<br>
                    ��<br>
                    ��</td>
                  <td width='15%' align="center">�Ⱓ</td>
                  <td class='' width='35%' align="center"> <input type='text' size='3' name='nfee_mon' value='<%=AddUtil.parseInt((String)base.get("S_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt2(this);'>
                    ����&nbsp;&nbsp;&nbsp; <input type='text' size='3' name='nfee_day' value='<%=AddUtil.parseInt((String)base.get("S_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt2(this);'>
                    ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="15%">�ݾ�</td>
                  <td width='35%' align="center"> <input type='text' size='15' name='nfee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    ��</td>
                  <td width='35%'>���� ���ݰ�꼭 ����</td>
                </tr>
                <tr> 
                  <td colspan="2" align="center">��ü��</td>
                  <td width='35%' align="center"> <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">�뿩�� ��(D)</td>
                  <td class='title' width='35%' align="center"> <input type='text' size='15' name='d_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
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
                  <td class='' width='35%' align="center"> <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    ��</td>
                  <td width='35%'>=������+���뿩���Ѿ�</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">���뿩��(ȯ��)</td>
                  <td class='' width='35%' align="center"> <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    ��</td>
                  <td width='35%'>=�뿩���Ѿס����Ⱓ</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��뿩���Ⱓ</td>
                  <td class='' width='35%' align="center"> <input type='text' name='rcon_mon' size='3' value='<%=AddUtil.parseInt((String)base.get("N_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    ����&nbsp;&nbsp;&nbsp; <input type='text' name='rcon_day' size='3' value='<%=AddUtil.parseInt((String)base.get("N_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
                  <td class='' width='35%' align="center"> <input type='text' name='trfee_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2"><font color="#FF0000">*</font>����� 
                    �������</td>
                  <td class='' width='35%' align="center"> <input type='text' name='dft_int' value='<%=base.get("CLS_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                    %</td>
                  <td width='35%'>����� ��������� ��༭�� Ȯ��</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">�ߵ����������(E)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='dft_amt' size='15' class='num' value='' onBlur='javascript:set_cls_amt()'>
                    ��</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td rowspan="4" class="title">��<br>
                    Ÿ</td>
                  <td class="title" colspan="2">�ڱ��������ظ�å��(F)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='car_ja_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("CAR_JA_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("SERV_CNT")%>��</font></a><font color="#66CCFF">&nbsp;</font></td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">���·�/��Ģ��(G)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='fine_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FINE_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("FINE_CNT")%>��</font></a><font color="#66CCFF">&nbsp;</font></td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">����ȸ�����(H)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='etc_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">�ΰ���(I)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='no_v_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td id=td_cancel_n style='display:block' class='title'>=(�뿩�� 
                          �̳��Աݾ�-B-C)��10% </td>
                        <td id=td_cancel_y style='display:none' class='title'>=�뿩�� 
                          �̳��Աݾס�10% </td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">��</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='fdft_amt1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'>=(D+E+F+G+H+I)</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td  colspan="2" align=''left> 3. ������ �����Ͻ� �ݾ�</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%">�� ��</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt2' value=''size='15' class='num' maxlength='15'>
                    �� </td>
                  <td class='title' width="35%"> =�̳��Աݾװ�-ȯ�ұݾװ�</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="2" align='left' > <<���곻��>> </td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width="20%"> DC</td>
                  <td  colspan="3"> 
                    <input type='text' name='fdft_dc_amt' value='' size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                </tr>
                <tr> 
                  <td class='title' width="20%"> ���ް�</td>
                  <td width="30%"> 
                    <input type='text' name='cls_s_amt' value=''size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                  <td class='title' width="20%"> �ΰ���</td>
                  <td width="30%"> 
                    <input type='text' name='cls_v_amt' value='' size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                </tr>
                <tr> 
                  <td class='title' width="20%">��������޿����� </td>
                  <td width="30%"> 
                    <input type='text' name='cls_est_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                  </td>
                  <td class='title' width="20%"> ���ݰ�꼭������</td>
                  <td width="30%"> 
                    <input type='text' name='ext_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                    <select name='ext_id'>
                      <option value=''>�����</option>
                      <%if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                      <option value='<%= user.get("USER_ID") %>' ><%= user.get("USER_NM")%></option>
                      <%	}
					}		%>
                    </select>
                  </td>
                </tr>
                <tr> 
                  <td class='title' width="20%"> ����ݸ������� </td>
                  <td colspan="3">���� 
                    <input type='checkbox' name='no_dft_yn' value="Y">
                    &nbsp;&nbsp;��������: 
                    <textarea name='no_dft_cau' rows='2' cols='80'></textarea>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
		  <!--
          <%if(fee_scd_size>0){//2005-07-18 ���� : �������� ���ó��%>
          <tr> 
            <td colspan="2" align='left' > <<��ü����Ʈ>> </td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
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
                <%	t_dly_amt = t_dly_amt + a_fee.getDly_fee();
				}%>
              </table>
            </td>
          </tr>
          <%	}	%>
		  -->
        </table>
      </td>
    </tr>
    <!-- �����Һ��� -->
    <tr id=tr_brch style='display:none'> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td> <<�����Һ���>> </td>
          </tr>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width="10%">����������</td>
                  <td width="15%"><%=c_db.getNameById((String)fee_base.get("BRCH_ID"), "BRCH")%>(<%=fee_base.get("BRCH_ID")%>) 
                  </td>
                  <td class='title' width="10%">�̰���������</td>
                  <td width="15%">
                    <select name='new_brch_cd'>
                      <option value=''>����</option>
                      <%if(brch_size > 0)	{
						for(int i = 0 ; i < brch_size ; i++){
							Hashtable branch = (Hashtable)branches.elementAt(i);		%>
                      <option value='<%=branch.get("BR_ID")%>'><%= branch.get("BR_NM")%></option>
                      <%	}
					  }	%>
                    </select>
                  </td>
                  <td class='title' width="10%">�̰�����</td>
                  <td width="40%">
                    <input type='text' name='trf_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <!-- ���Կɼ� -->
    <tr id=tr_opt style='display:none'> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td> <<���Կɼ�>> </td>
          </tr>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width="10%">���Կɼ���</td>
                  <td width="15%"> 
                    <input type='text' name='opt_per' value='<%=fee_base.get("OPT_PER")%>' size='5' class='num' maxlength='4'>
                    %</td>
                  <td class='title' width="10%">���Կɼǰ�</td>
                  <td width="15%">
                    <input type='text' name='opt_amt'size='13' class='num' value="<%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("OPT_AMT")))%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                  <td class='title' width="10%">��������</td>
                  <td width="15%">
                    <input type='text' name='opt_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                  </td>
                  <td class='title' width="10%">���������</td>
                  <td width="15%">
            	  <select name='opt_mng'>
	                <option value=''>�����</option>
    	            <%if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	
					%>
                	<option value='<%= user.get("USER_ID") %>'><%= user.get("USER_NM")%></option>
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
    <tr> 
      <td>&nbsp; </td>
      <td align="right">&nbsp;</td>
    </tr>
    <tr>
      <td>
        <%if(fee_base.get("FEE_CHK").equals("1")){%>
        <font color="#FF0000">��</font>���뿩�� �Ͻÿϳ��Դϴ�. �ߵ����� ������� �����ϴ�. 
        <%}%>
      </td>
      <td align="right">
	  <a href='javascript:<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>save();<%}else{%>alert("������ �����ϴ�");<%}%>' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0" alt="���"></a>
		<a href='javascript:window.close();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="�ݱ�"></a></td>
    </tr>
  </table>  
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;

		var ifee_tm = 0;
		var pay_tm = 0;
		
		//�ܿ����ô뿩��
		if(fm.ifee_s_amt.value != '0'){
			ifee_tm = toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value)) ;
			pay_tm = toInt(fm.con_mon.value)-ifee_tm;
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
				fm.ifee_day.value 	= fm.r_day.value;
			}
			var ifee_ex_amt = 0;
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
		}
		
		//�����ݾ� ���� �ʱ� ����
		if(fm.pp_s_amt.value != '0'){
			if(fm.ifee_s_amt.value == '0'){
				fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
			}
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );
		}else{
			fm.pded_s_amt.value 	= "0";
			fm.tpded_s_amt.value 	= "0";
			fm.rfee_s_amt.value 	= "0";
		}
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );

		//�̳��Աݾ� ���� �ʱ� ����		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}
		fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		
		if(fm.r_day.value != '0'){
			fm.rcon_mon.value 		= toInt(fm.con_mon.value) - toInt(fm.r_mon.value) - 1;
			fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
		}else{
			fm.rcon_mon.value = toInt(fm.con_mon.value) - toInt(fm.r_mon.value);
			fm.rcon_day.value = fm.r_day.value;			
		}	
		if(fm.pp_s_amt.value != '0'){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}		
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}				
		if(fm.dft_int.value == '')	fm.dft_int.value 			= 30;
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
		
		var no_v_amt =0;
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'Y'){
			no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) - toInt(parseDigit(fm.rifee_s_amt.value));
		}else{
			no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value));
		}				
		var no_v_amt2 				= no_v_amt.toString();
		var len 					= no_v_amt2.length;
		no_v_amt2 					= no_v_amt2.substring(0, len-1);
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)));
		
		//���� ������ �ݾ� �ʱ� ����	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)) );		
	}
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
